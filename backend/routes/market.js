const express = require("express");
const router = express.Router();

const { protect } = require("../middleware/auth");
const {
  demandInsights,
  getRecommendations,
  getArtisanDashboard,
} = require("../controllers/marketController");

/*
FEATURE 3:
GET /api/market/demand-insights
Demand Radar Engine with seasonal multipliers & trending categories
*/
router.get("/demand-insights", demandInsights);

/*
Marketplace Product Recommendations
*/
router.get("/recommendations", getRecommendations);

/*
Artisan Dashboard Stats
*/
router.get("/artisan-dashboard", protect, getArtisanDashboard);

module.exports = router;