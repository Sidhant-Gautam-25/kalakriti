const { getDemandInsights } = require("../services/demandEngine");
const Product = require("../models/Product");
const Order = require("../models/Order");

/*
FEATURE 3:
GET /api/market/demand-insights
*/
const demandInsights = async (req, res, next) => {
  try {
    const insights = await getDemandInsights();

    return res.status(200).json({
      success: true,
      ...insights,
    });
  } catch (error) {
    next(error);
  }
};

const getRecommendations = async (req, res, next) => {
  try {
    const products = await Product.find({ status: "active" })
      .populate("artisan", "name artisanProfile")
      .limit(10);

    return res.json({ success: true, recommendations: products });
  } catch (err) {
    next(err);
  }
};

const getArtisanDashboard = async (req, res, next) => {
  try {
    const totalProducts = await Product.countDocuments({ artisan: req.user._id });
    const orders = await Order.find({ "items.artisan": req.user._id });

    const totalRevenue = orders.reduce((sum, ord) => sum + (ord.totalAmount || 0), 0);

    return res.json({
      success: true,
      stats: {
        totalProducts,
        totalOrders: orders.length,
        totalRevenue,
      },
    });
  } catch (err) {
    next(err);
  }
};

module.exports = {
  demandInsights,
  getRecommendations,
  getArtisanDashboard,
};
