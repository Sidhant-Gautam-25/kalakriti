const mongoose = require("mongoose");

const Product = require("../models/Product");
const ApiError = require("../utils/ApiError");
const {
  recordProductMetric,
} = require("../services/productAnalyticsService");

const hasGiTag = (giTag) => {
  if (!giTag) return false;

  if (typeof giTag === "string") {
    return Boolean(giTag.trim());
  }

  return Boolean(giTag.name || giTag.code);
};

const isGiVerified = (giTag) => {
  if (!giTag) return false;

  if (typeof giTag === "string") {
    return Boolean(giTag.trim());
  }

  return Boolean(giTag.isVerified);
};

const calculateAuthenticity = (product) => {
  const profile = product.artisan?.artisanProfile || {};
  const location = profile.location || {};
  const shg = profile.shg || {};

  const giTag = product.giTag || product.heritage?.giTag;

  const giPresent = hasGiTag(giTag);

  const locationVerified = Boolean(
    location.isVerified ||
      location.verified ||
      profile.districtVerified
  );

  const shgMember = Boolean(
    profile.isSHGMember || shg.isVerified || shg.name || profile.shgName
  );

  const aiTechniqueIdentified = Boolean(
    product.metadata?.aiCraftTechniqueIdentified ||
      product.aiCatalog?.craftTechniqueIdentified
  );

  const productPrice = product.sellingPrice || product.pricing?.sellingPrice || 0;
  const fairPriceVerified = Boolean(
    product.aiMinPrice > 0 &&
      productPrice >= product.aiMinPrice &&
      !product.metadata?.isUnderpriced
  );

  let authenticityScore = 0;
  const authenticityBadges = [];

  if (giPresent) {
    authenticityScore += 30;

    if (isGiVerified(giTag)) {
      authenticityBadges.push("GI Verified");
    } else {
      authenticityBadges.push("GI Tag Declared");
    }
  }

  if (locationVerified) {
    authenticityScore += 25;
    authenticityBadges.push("Direct Artisan");
  }

  if (shgMember) {
    authenticityScore += 20;
    authenticityBadges.push("SHG Member");
  }

  if (aiTechniqueIdentified) {
    authenticityScore += 25;
    authenticityBadges.push("Handmade Technique Identified");
  }

  if (fairPriceVerified) {
    authenticityBadges.push("Fair Price Verified");
  }

  return {
    authenticityScore: Math.min(authenticityScore, 100),
    authenticityBadges,
  };
};

/*
FEATURE 4:
GET /api/products/:id
*/
const getProductById = async (req, res, next) => {
  try {
    const { id } = req.params;

    if (!mongoose.isValidObjectId(id)) {
      throw new ApiError(400, "Invalid product id.");
    }

    const product = await Product.findById(id)
      .populate({
        path: "artisan",
        select:
          "name phone artisanProfile.story artisanProfile.location artisanProfile.shg artisanProfile.isSHGMember artisanProfile.shgName",
      })
      .lean();

    if (!product) {
      throw new ApiError(404, "Product not found.");
    }

    const authenticity = calculateAuthenticity(product);

    product.authenticityScore = authenticity.authenticityScore;
    product.authenticityBadges = authenticity.authenticityBadges;

    /*
      Do not fail product detail API if analytics update fails.
    */
    recordProductMetric(product._id, { type: "view" }).catch((error) => {
      console.error("Unable to record product view:", error.message);
    });

    return res.status(200).json({
      success: true,
      product,
    });
  } catch (error) {
    next(error);
  }
};

/*
GET /api/products
*/
const getAllProducts = async (req, res, next) => {
  try {
    const { category, minPrice, maxPrice, search, page = 1, limit = 20 } = req.query;
    const filter = { status: "active" };

    if (category) filter.category = category;
    if (search) {
      filter.$text = { $search: search };
    }
    if (minPrice || maxPrice) {
      filter.$or = [
        {
          sellingPrice: {
            ...(minPrice ? { $gte: Number(minPrice) } : {}),
            ...(maxPrice ? { $lte: Number(maxPrice) } : {}),
          },
        },
        {
          "pricing.sellingPrice": {
            ...(minPrice ? { $gte: Number(minPrice) } : {}),
            ...(maxPrice ? { $lte: Number(maxPrice) } : {}),
          },
        },
      ];
    }

    const products = await Product.find(filter)
      .populate("artisan", "name phone artisanProfile")
      .skip((page - 1) * limit)
      .limit(Number(limit))
      .sort({ createdAt: -1 });

    const total = await Product.countDocuments(filter);

    if (search && products.length > 0) {
      // Record search analytics asynchronously for first few matching products
      products.slice(0, 5).forEach((prod) => {
        recordProductMetric(prod._id, { type: "search", tag: search }).catch(() => {});
      });
    }

    return res.json({ success: true, total, products });
  } catch (err) {
    next(err);
  }
};

/*
GET /api/products/artisan/my-products
*/
const getMyProducts = async (req, res, next) => {
  try {
    const products = await Product.find({ artisan: req.user._id }).sort({ createdAt: -1 });
    return res.json({ success: true, products });
  } catch (err) {
    next(err);
  }
};

module.exports = {
  getProductById,
  getAllProducts,
  getMyProducts,
};
