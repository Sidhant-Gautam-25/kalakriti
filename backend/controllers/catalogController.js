const Product = require("../models/Product");
const User = require("../models/User");

const ApiError = require("../utils/ApiError");

const {
  extractCatalogFromTranscript,
  analyzeCraftImage,
} = require("../services/aiService");

const {
  signCatalogDraft,
  verifyCatalogDraft,
} = require("../services/catalogDraftService");

const {
  downloadPublicImage,
} = require("../services/imageFetchService");

const cleanText = (value, fallback = null, maxLength = 250) => {
  const selectedValue =
    value !== undefined && value !== null && value !== "" ? value : fallback;

  if (typeof selectedValue !== "string") return null;

  const cleaned = selectedValue.replace(/\s+/g, " ").trim();

  return cleaned ? cleaned.slice(0, maxLength) : null;
};

const numberValue = (value, fallback, fieldName, allowZero = false) => {
  const selectedValue =
    value !== undefined && value !== null && value !== "" ? value : fallback;

  const number = Number(
    String(selectedValue ?? "")
      .replace(/₹/g, "")
      .replace(/,/g, "")
      .trim()
  );

  if (!Number.isFinite(number) || (!allowZero && number <= 0)) {
    throw new ApiError(400, `${fieldName} must be a valid positive number.`);
  }

  return Math.round(number);
};

const booleanValue = (value) => {
  return value === true || value === "true" || value === 1 || value === "1";
};

const rupees = (value) => {
  return new Intl.NumberFormat("en-IN", {
    maximumFractionDigits: 0,
  }).format(Math.round(value));
};

const ensureUsableAiCatalog = (catalog) => {
  const missing = [];

  if (!catalog.productName) missing.push("productName");
  if (!catalog.category) missing.push("category");
  if (!catalog.sellingPrice || catalog.sellingPrice <= 0) {
    missing.push("sellingPrice");
  }
  if (!catalog.aiMinPrice || catalog.aiMinPrice <= 0) {
    missing.push("aiMinPrice");
  }

  if (missing.length) {
    throw new ApiError(
      422,
      "AI could not extract enough product information.",
      { missingFields: missing }
    );
  }
};

const normalizeImages = (images) => {
  const imageList = Array.isArray(images)
    ? images
    : typeof images === "string"
    ? [images]
    : [];

  return imageList
    .filter((image) => typeof image === "string")
    .map((image) => image.trim())
    .filter((image) => /^https?:\/\//i.test(image))
    .slice(0, 6);
};

const normalizeGiTag = (giTag) => {
  if (!giTag) return null;

  if (typeof giTag === "string") {
    const name = giTag.trim();

    if (!name) return null;

    return {
      name,
      isVerified: false,
    };
  }

  if (typeof giTag === "object") {
    const name = String(giTag.name || "").trim();
    const code = String(giTag.code || "").trim();

    if (!name && !code) return null;

    return {
      name: name || undefined,
      code: code || undefined,
      isVerified: false,
    };
  }

  return null;
};

const createSearchTags = ({ category, craftTechnique, materials, searchTags }) => {
  const values = [
    category,
    craftTechnique,
    ...(materials || []),
    ...(Array.isArray(searchTags) ? searchTags : []),
  ];

  return [...new Set(
    values
      .filter(Boolean)
      .map((tag) => String(tag).trim().toLowerCase())
      .filter(Boolean)
  )].slice(0, 25);
};

const buildProductDocument = (body, aiCatalog, artisanId) => {
  const productName = cleanText(body.productName || body.name, aiCatalog.productName, 160);
  const category = cleanText(body.category, aiCatalog.category, 100);
  const craftTechnique = cleanText(
    body.craftTechnique,
    aiCatalog.craftTechnique,
    150
  );

  const materials = Array.isArray(body.materials)
    ? body.materials
        .map((item) => cleanText(String(item), null, 80))
        .filter(Boolean)
    : aiCatalog.materials || [];

  const estimatedCost = numberValue(
    body.estimatedCost,
    aiCatalog.estimatedCost || 0,
    "estimatedCost",
    true
  );

  const sellingPrice = numberValue(
    body.sellingPrice,
    aiCatalog.sellingPrice,
    "sellingPrice"
  );

  const productionDays = numberValue(
    body.productionDays,
    aiCatalog.productionDays || 1,
    "productionDays"
  );

  if (!productName || !category) {
    throw new ApiError(400, "productName and category are required.");
  }

  const aiMinPrice = numberValue(
    aiCatalog.aiMinPrice,
    null,
    "aiMinPrice"
  );

  const isUnderpriced = sellingPrice < aiMinPrice;
  const fairPriceGap = isUnderpriced ? aiMinPrice - sellingPrice : 0;

  const giTag = normalizeGiTag(body.giTag);

  const productData = {
    artisan: artisanId,
    name: productName,
    productNameHindi: cleanText(
      body.productNameHindi,
      aiCatalog.productNameHindi,
      160
    ),
    category,
    craftTechnique,
    materials,
    estimatedCost,
    sellingPrice,
    pricing: {
      sellingPrice,
      costPrice: estimatedCost,
      aiSuggestedPrice: aiCatalog.sellingPrice || aiMinPrice,
      currency: "INR",
    },
    productionDays,
    region: cleanText(body.region, aiCatalog.region, 150),
    images: normalizeImages(body.images || body.imageUrls),
    description: cleanText(body.description, `${productName} - authentic handmade craft item`, 1500),
    aiMinPrice,
    searchTags: createSearchTags({
      category,
      craftTechnique,
      materials,
      searchTags: body.searchTags,
    }),
    metadata: {
      aiGenerated: true,
      aiCraftTechniqueIdentified: Boolean(craftTechnique),
      isUnderpriced,
      fairPriceGap,
      underpriceWarningDismissed: isUnderpriced
        ? booleanValue(body.underpriceWarningDismissed)
        : false,
      confirmedAt: new Date(),
    },
  };

  if (giTag) {
    productData.giTag = giTag;
  }

  return productData;
};

/*
FEATURE 1:
POST /api/catalog/voice-catalog
*/
const voiceCatalog = async (req, res, next) => {
  try {
    const { transcript, language = "hi" } = req.body;

    if (!transcript || typeof transcript !== "string") {
      throw new ApiError(400, "transcript is required.");
    }

    if (transcript.trim().length < 5) {
      throw new ApiError(400, "Transcript is too short for catalog generation.");
    }

    if (transcript.length > 6000) {
      throw new ApiError(413, "Transcript must be shorter than 6000 characters.");
    }

    const catalog = await extractCatalogFromTranscript(
      transcript.trim(),
      language
    );

    ensureUsableAiCatalog(catalog);

    const catalogDraftToken = signCatalogDraft({
      artisanId: req.user._id,
      catalog,
    });

    return res.status(200).json({
      success: true,
      message: "Catalog draft generated successfully.",
      draftProductData: catalog,
      catalogDraftToken,
    });
  } catch (error) {
    next(error);
  }
};

/*
FEATURE 2:
POST /api/catalog/confirm
*/
const confirmCatalog = async (req, res, next) => {
  try {
    const { catalogDraftToken } = req.body;

    const draft = verifyCatalogDraft(catalogDraftToken);

    if (String(draft.artisanId) !== String(req.user._id)) {
      throw new ApiError(
        403,
        "This AI catalog draft belongs to another artisan account."
      );
    }

    ensureUsableAiCatalog(draft.catalog);

    const productData = buildProductDocument(
      req.body,
      draft.catalog,
      req.user._id
    );

    const product = await Product.create(productData);

    const isUnderpriced = product.metadata?.isUnderpriced;
    const fairPriceGap = product.metadata?.fairPriceGap || 0;

    const warning = isUnderpriced
      ? `Price is below fair market value of ₹${rupees(
          product.aiMinPrice
        )}. Potential earnings loss.`
      : null;

    return res.status(201).json({
      success: true,
      message: "Product listing confirmed successfully.",
      product,
      priceProtection: {
        aiMinPrice: product.aiMinPrice,
        isUnderpriced,
        fairPriceGap,
        underpriceWarningDismissed:
          product.metadata?.underpriceWarningDismissed || false,
        warning,
      },
    });
  } catch (error) {
    next(error);
  }
};

const getWhatsAppReply = (draftProductData, language) => {
  const isHindi = String(language || "hi").toLowerCase().startsWith("hi");

  const productName =
    isHindi && draftProductData.productNameHindi
      ? draftProductData.productNameHindi
      : draftProductData.productName;

  const min = rupees(draftProductData.suggestedPriceMin);
  const max = rupees(draftProductData.suggestedPriceMax);

  if (isHindi) {
    return `*Artisan AI Assistant*

Namaskar! Humne aapke utpad ko pehchan liya hai:

*Naam:* ${productName}
*Uchit Mulya:* ₹${min} - ₹${max}

Kya aap ise bazaar me bechna chahte hain? Confirm karne ke liye *HAAN* reply karein.`;
  }

  return `*Artisan AI Assistant*

Hello! We identified your product:

*Name:* ${productName}
*Fair Price:* ₹${min} - ₹${max}

Would you like to sell this product in the marketplace? Reply *YES* to confirm.`;
};

const whatsappBotCatalog = async (req, res, next) => {
  try {
    let { phone, artisanPhone, phoneNumber, imageUrl, userLanguage, language } = req.body;
    let inputPhone = phone || artisanPhone || phoneNumber;
    const selectedLanguage = userLanguage || language || "hi";

    if (!inputPhone || typeof inputPhone !== "string") {
      throw new ApiError(400, "phone is required.");
    }

    inputPhone = inputPhone.trim();
    // Normalize 10-digit Indian number to E.164 if needed
    if (/^[6-9]\d{9}$/.test(inputPhone)) {
      inputPhone = `+91${inputPhone}`;
    }

    if (!/^\+[1-9]\d{7,14}$/.test(inputPhone)) {
      throw new ApiError(
        400,
        "phone must be in E.164 format (e.g. +919876543210) or a valid 10-digit mobile number."
      );
    }

    if (!imageUrl || typeof imageUrl !== "string") {
      throw new ApiError(400, "imageUrl is required.");
    }

    const image = await downloadPublicImage(imageUrl);

    const draftProductData = await analyzeCraftImage({
      base64Data: image.base64Data,
      mimeType: image.mimeType,
      language: selectedLanguage,
    });

    ensureUsableAiCatalog(draftProductData);

    draftProductData.images = [imageUrl];

    const raw10Digit = inputPhone.replace(/^\+91/, "").replace(/^\+/, "");

    // Search user with either formatted or raw phone number
    const artisan = await User.findOne({
      $or: [
        { phone: inputPhone },
        { phone: raw10Digit },
        { phone: `+91${raw10Digit}` },
      ],
    }).select("_id role");

    if (artisan && String(artisan.role).toLowerCase() !== "artisan") {
      throw new ApiError(
        403,
        "This phone number is not registered as an artisan account."
      );
    }

    const catalogDraftToken = artisan
      ? signCatalogDraft({
          artisanId: artisan._id,
          catalog: draftProductData,
        })
      : null;

    const whatsappReplyText = getWhatsAppReply(
      draftProductData,
      selectedLanguage
    );

    return res.status(200).json({
      success: true,
      artisanFound: Boolean(artisan),
      whatsappReplyText,
      draftProductData,
      catalogDraftToken,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  voiceCatalog,
  confirmCatalog,
  whatsappBotCatalog,
};
