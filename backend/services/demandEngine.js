const Product = require("../models/Product");
const Order = require("../models/Order");

const getDateRange = () => {
  const currentStart = new Date();
  currentStart.setUTCHours(0, 0, 0, 0);
  currentStart.setUTCDate(currentStart.getUTCDate() - 29);

  const previousStart = new Date(currentStart);
  previousStart.setUTCDate(previousStart.getUTCDate() - 30);

  return {
    currentStart,
    previousStart,
  };
};

const numberOrZero = (value) => {
  const number = Number(value);
  return Number.isFinite(number) ? number : 0;
};

const percentageGrowth = (current, previous) => {
  if (previous <= 0) {
    return current > 0 ? 100 : 0;
  }

  return Math.round(((current - previous) / previous) * 100);
};

const getSeasonalContext = (date = new Date()) => {
  const month = date.getMonth() + 1;

  if ([10, 11].includes(month)) {
    return {
      name: "Diwali Season",
      multiplier: 1.4,
      keywords: [
        "terracotta",
        "diya",
        "lamp",
        "lighting",
        "home decor",
        "decor",
      ],
    };
  }

  if ([2, 3].includes(month)) {
    return {
      name: "Holi Season",
      multiplier: 1.2,
      keywords: ["textile", "fabric", "stole", "scarf", "block print"],
    };
  }

  if ([7, 8].includes(month)) {
    return {
      name: "Rakhi and Festival Season",
      multiplier: 1.2,
      keywords: ["gift", "jewellery", "bracelet", "decor", "handmade"],
    };
  }

  if ([11, 12].includes(month)) {
    return {
      name: "Wedding and Winter Season",
      multiplier: 1.25,
      keywords: ["textile", "shawl", "jewellery", "gift", "home decor"],
    };
  }

  return {
    name: "Regular Season",
    multiplier: 1,
    keywords: [],
  };
};

const getCategorySeasonalMultiplier = (category, seasonalContext) => {
  const categoryText = String(category || "").toLowerCase();

  const isSeasonalCategory = seasonalContext.keywords.some((keyword) =>
    categoryText.includes(keyword)
  );

  return isSeasonalCategory ? seasonalContext.multiplier : 1;
};

const buildCategoryActivityPipeline = (previousStart, currentStart) => {
  return [
    {
      $unwind: "$analytics.daily",
    },
    {
      $match: {
        "analytics.daily.date": {
          $gte: previousStart,
        },
      },
    },
    {
      $project: {
        category: {
          $ifNull: ["$category", "Other"],
        },
        sellingPrice: {
          $ifNull: ["$sellingPrice", "$pricing.sellingPrice"],
        },
        currentViews: {
          $cond: [
            { $gte: ["$analytics.daily.date", currentStart] },
            { $ifNull: ["$analytics.daily.views", 0] },
            0,
          ],
        },
        previousViews: {
          $cond: [
            { $lt: ["$analytics.daily.date", currentStart] },
            { $ifNull: ["$analytics.daily.views", 0] },
            0,
          ],
        },
        currentWishlists: {
          $cond: [
            { $gte: ["$analytics.daily.date", currentStart] },
            { $ifNull: ["$analytics.daily.wishlists", 0] },
            0,
          ],
        },
        previousWishlists: {
          $cond: [
            { $lt: ["$analytics.daily.date", currentStart] },
            { $ifNull: ["$analytics.daily.wishlists", 0] },
            0,
          ],
        },
        currentSearches: {
          $cond: [
            { $gte: ["$analytics.daily.date", currentStart] },
            { $ifNull: ["$analytics.daily.searchCount", 0] },
            0,
          ],
        },
        previousSearches: {
          $cond: [
            { $lt: ["$analytics.daily.date", currentStart] },
            { $ifNull: ["$analytics.daily.searchCount", 0] },
            0,
          ],
        },
      },
    },
    {
      $group: {
        _id: "$_id",
        category: { $first: "$category" },
        sellingPrice: { $first: "$sellingPrice" },
        currentViews: { $sum: "$currentViews" },
        previousViews: { $sum: "$previousViews" },
        currentWishlists: { $sum: "$currentWishlists" },
        previousWishlists: { $sum: "$previousWishlists" },
        currentSearches: { $sum: "$currentSearches" },
        previousSearches: { $sum: "$previousSearches" },
      },
    },
    {
      $group: {
        _id: "$category",
        views: { $sum: "$currentViews" },
        previousViews: { $sum: "$previousViews" },
        wishlists: { $sum: "$currentWishlists" },
        previousWishlists: { $sum: "$previousWishlists" },
        searches: { $sum: "$currentSearches" },
        previousSearches: { $sum: "$previousSearches" },
        avgSellingPrice: { $avg: "$sellingPrice" },
      },
    },
  ];
};

const buildTrendingTagsPipeline = (previousStart, currentStart) => {
  return [
    {
      $unwind: "$analytics.daily",
    },
    {
      $match: {
        "analytics.daily.date": {
          $gte: previousStart,
        },
      },
    },
    {
      $unwind: "$analytics.daily.searches",
    },
    {
      $project: {
        tag: {
          $toLower: {
            $ifNull: ["$analytics.daily.searches.tag", ""],
          },
        },
        currentCount: {
          $cond: [
            { $gte: ["$analytics.daily.date", currentStart] },
            { $ifNull: ["$analytics.daily.searches.count", 0] },
            0,
          ],
        },
        previousCount: {
          $cond: [
            { $lt: ["$analytics.daily.date", currentStart] },
            { $ifNull: ["$analytics.daily.searches.count", 0] },
            0,
          ],
        },
      },
    },
    {
      $match: {
        tag: { $ne: "" },
      },
    },
    {
      $group: {
        _id: "$tag",
        count: { $sum: "$currentCount" },
        previousCount: { $sum: "$previousCount" },
      },
    },
    {
      $sort: {
        count: -1,
      },
    },
    {
      $limit: 10,
    },
  ];
};

const resolveOrderConfig = () => {
  const itemPath =
    process.env.ORDER_ITEMS_FIELD ||
    (Order.schema.path("items")
      ? "items"
      : Order.schema.path("orderItems")
      ? "orderItems"
      : null);

  if (!itemPath) return null;

  const productPath =
    process.env.ORDER_PRODUCT_FIELD ||
    (Order.schema.path(`${itemPath}.product`)
      ? `${itemPath}.product`
      : Order.schema.path(`${itemPath}.productId`)
      ? `${itemPath}.productId`
      : null);

  const quantityPath =
    process.env.ORDER_QUANTITY_FIELD ||
    (Order.schema.path(`${itemPath}.quantity`)
      ? `${itemPath}.quantity`
      : `${itemPath}.qty`);

  const statusField = Order.schema.path("status")
    ? "status"
    : Order.schema.path("orderStatus")
    ? "orderStatus"
    : null;

  if (!productPath) return null;

  return {
    itemPath,
    productPath,
    quantityPath,
    statusField,
  };
};

const getSalesByCategory = async (currentStart) => {
  const config = resolveOrderConfig();

  if (!config) {
    return [];
  }

  const matchStage = {
    createdAt: {
      $gte: currentStart,
    },
  };

  if (config.statusField) {
    matchStage[config.statusField] = {
      $in: [
        "paid",
        "confirmed",
        "placed",
        "processing",
        "in_production",
        "shipped",
        "delivered",
        "completed",
      ],
    };
  }

  return Order.aggregate([
    {
      $match: matchStage,
    },
    {
      $unwind: `$${config.itemPath}`,
    },
    {
      $lookup: {
        from: Product.collection.name,
        localField: config.productPath,
        foreignField: "_id",
        as: "catalogProduct",
      },
    },
    {
      $unwind: "$catalogProduct",
    },
    {
      $group: {
        _id: {
          $ifNull: ["$catalogProduct.category", "Other"],
        },
        unitsSold: {
          $sum: {
            $ifNull: [`$${config.quantityPath}`, 1],
          },
        },
      },
    },
  ]);
};

const craftRecommendationsForCategory = (category) => {
  const text = String(category || "").toLowerCase();

  if (
    text.includes("textile") ||
    text.includes("fabric") ||
    text.includes("block print")
  ) {
    return ["Block Print Cushion Covers", "Hand Block Printed Table Runners"];
  }

  if (
    text.includes("terracotta") ||
    text.includes("pottery") ||
    text.includes("ceramic")
  ) {
    return ["Terracotta Diyas", "Handcrafted Terracotta Planters"];
  }

  if (text.includes("jewellery") || text.includes("jewelry")) {
    return ["Handmade Tribal Earrings", "Beaded Artisan Necklaces"];
  }

  if (text.includes("bamboo") || text.includes("cane")) {
    return ["Bamboo Storage Baskets", "Handwoven Cane Lamps"];
  }

  if (text.includes("wood")) {
    return ["Wooden Serving Trays", "Hand-Carved Decorative Boxes"];
  }

  if (text.includes("metal")) {
    return ["Dhokra Brass Figurines", "Hand-hammered Copper Bowls"];
  }

  if (text.includes("paint")) {
    return ["Madhubani Folk Paintings", "Warli Art Wall Hangings"];
  }

  return [`Handmade ${category} Products`];
};

const getDemandInsights = async () => {
  const { currentStart, previousStart } = getDateRange();
  const seasonalContext = getSeasonalContext();

  const [categoryRows, tagRows, salesRows] = await Promise.all([
    Product.aggregate(
      buildCategoryActivityPipeline(previousStart, currentStart)
    ),
    Product.aggregate(buildTrendingTagsPipeline(previousStart, currentStart)),
    getSalesByCategory(currentStart),
  ]);

  const salesMap = new Map(
    salesRows.map((item) => [
      item._id,
      numberOrZero(item.unitsSold),
    ])
  );

  const trendingCategories = categoryRows
    .map((item) => {
      const category = item._id || "Other";
      const views = numberOrZero(item.views);
      const wishlists = numberOrZero(item.wishlists);
      const unitsSold = salesMap.get(category) || 0;

      const engagementScore = views + wishlists * 3;
      const seasonalMultiplier = getCategorySeasonalMultiplier(
        category,
        seasonalContext
      );

      const demandScore = Math.round(
        (engagementScore + unitsSold * 2) * seasonalMultiplier
      );

      return {
        category,
        demandScore,
        avgSellingPrice: Math.round(numberOrZero(item.avgSellingPrice)),
        searchGrowth: percentageGrowth(
          numberOrZero(item.searches),
          numberOrZero(item.previousSearches)
        ),
        views,
        wishlistCount: wishlists,
        unitsSold,
        seasonalMultiplier,
      };
    })
    .sort((a, b) => b.demandScore - a.demandScore)
    .slice(0, 3);

  const trendingSearchTags = tagRows.map((item) => ({
    tag: item._id,
    count: numberOrZero(item.count),
    growth: percentageGrowth(
      numberOrZero(item.count),
      numberOrZero(item.previousCount)
    ),
  }));

  const recommendations = [
    ...new Set(
      trendingCategories.flatMap((item) =>
        craftRecommendationsForCategory(item.category)
      )
    ),
  ].slice(0, 5);

  const recommendedCraftsToMake =
    recommendations.length > 0
      ? recommendations
      : ["Block Print Cushion Covers", "Terracotta Diyas"];

  let insightSummaryHindi =
    "Abhi paryapt demand data available nahi hai. Product views aur wishlist activity badhane par better insights milenge.";

  if (trendingCategories.length > 0) {
    const topCategory = trendingCategories[0];

    const growthText =
      topCategory.searchGrowth > 0
        ? `${topCategory.searchGrowth}% badhi hai`
        : "sthir hai";

    insightSummaryHindi = `Is mahine ${topCategory.category} items ki maang ${growthText}. ${
      seasonalContext.name !== "Regular Season"
        ? `${seasonalContext.name} ke karan seasonal demand bhi badh rahi hai.`
        : ""
    }`;
  }

  return {
    trendingCategories,
    trendingSearchTags,
    recommendedCraftsToMake,
    insightSummaryHindi,
    seasonalContext: {
      name: seasonalContext.name,
      multiplier: seasonalContext.multiplier,
    },
  };
};

module.exports = {
  getDemandInsights,
};
