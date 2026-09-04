const express = require("express");
const router = express.Router();

const { protect } = require("../middleware/auth");
const artisanOnly = require("../middleware/artisanOnly");
const {
  getProductById,
  getAllProducts,
  getMyProducts,
} = require("../controllers/productsController");

/*
List all active products (with category, text search, price filters, pagination)
*/
router.get("/", getAllProducts);

/*
Get products uploaded by logged-in artisan
*/
router.get("/artisan/my-products", protect, artisanOnly, getMyProducts);

/*
FEATURE 4:
Get product by ID with Heritage Authenticity Score calculation
*/
router.get("/:id", getProductById);

module.exports = router;