const Product = require("../models/Product");

const getUtcDay = () => {
  const date = new Date();

  return new Date(
    Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate())
  );
};

const normalizeSearchTag = (tag) => {
  if (!tag || typeof tag !== "string") return null;

  return tag.trim().toLowerCase().slice(0, 80) || null;
};

const recordProductMetric = async (productId, { type, tag = null }) => {
  const validTypes = ["view", "wishlist", "search"];

  if (!validTypes.includes(type)) {
    return;
  }

  const product = await Product.findById(productId);

  if (!product) return;

  const today = getUtcDay();

  product.analytics = product.analytics || {};
  product.analytics.daily = product.analytics.daily || [];

  let metric = product.analytics.daily.find(
    (item) => new Date(item.date).getTime() === today.getTime()
  );

  if (!metric) {
    metric = {
      date: today,
      views: 0,
      wishlists: 0,
      searchCount: 0,
      searches: [],
    };

    product.analytics.daily.push(metric);
  }

  if (type === "view") {
    metric.views += 1;
    product.views = (product.views || 0) + 1;
  }

  if (type === "wishlist") {
    metric.wishlists += 1;
    product.wishlistCount = (product.wishlistCount || 0) + 1;
  }

  if (type === "search") {
    metric.searchCount += 1;

    const normalizedTag = normalizeSearchTag(tag);

    if (normalizedTag) {
      const existingTag = metric.searches.find(
        (item) => item.tag === normalizedTag
      );

      if (existingTag) {
        existingTag.count += 1;
      } else {
        metric.searches.push({
          tag: normalizedTag,
          count: 1,
        });
      }
    }
  }

  /*
    Keep only approximately 90 days of demand analytics.
  */
  const retentionDate = new Date();
  retentionDate.setUTCDate(retentionDate.getUTCDate() - 90);

  product.analytics.daily = product.analytics.daily.filter(
    (item) => new Date(item.date) >= retentionDate
  );

  product.markModified("analytics");

  await product.save();
};

module.exports = {
  recordProductMetric,
};
