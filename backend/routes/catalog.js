const express = require("express");
const router = express.Router();

const { protect, restrictTo } = require("../middleware/auth");
const artisanOnly = require("../middleware/artisanOnly");
const verifyWhatsAppBotSecret = require("../middleware/whatsappBotAuth");
const upload = require("../middleware/upload");
const { analyzeCraftImage } = require("../services/aiService");
const { uploadProductImage } = require("../services/imageService");
const { signCatalogDraft } = require("../services/catalogDraftService");

const {
  voiceCatalog,
  confirmCatalog,
  whatsappBotCatalog,
} = require("../controllers/catalogController");

/*
FEATURE 1:
Voice/Transcript Catalog Generation
Protected + Artisan only
*/
router.post(
  "/voice-catalog",
  protect,
  artisanOnly,
  voiceCatalog
);

/*
FEATURE 2:
Confirm & Publish Product with Fair Price Shield
Protected + Artisan only
*/
router.post(
  "/confirm",
  protect,
  artisanOnly,
  confirmCatalog
);

/*
FEATURE 5:
WhatsApp Bot Craft Image Cataloging
Webhook with x-whatsapp-bot-secret
*/
router.post(
  "/whatsapp-bot",
  verifyWhatsAppBotSecret,
  whatsappBotCatalog
);

const { analyzeCraft, predictPrice } = require("../services/mlService");

/*
Image Upload Smart Cataloging (Direct Image Upload via Multer)
Protected + Artisan only
*/
router.post(
  "/smart-catalog",
  protect,
  artisanOnly,
  upload.single("image"),
  async (req, res, next) => {
    try {
      if (!req.file) {
        return res.status(400).json({ success: false, message: "Please upload an image file." });
      }

      // 1. Upload to Cloudinary / storage
      const uploadedImage = await uploadProductImage(req.file.buffer, req.user._id);

      // 2. AI Multimodal Analysis via FastAPI Python AI Service with fallback to local Gemini service
      let aiData;
      try {
        const mlData = await analyzeCraft(req.file.buffer);
        const priceData = await predictPrice({
          category: mlData.category,
          craftTechnique: mlData.craftTechnique,
          materials: mlData.materials,
        });
        aiData = {
          productName: mlData.productName,
          productNameHindi: mlData.productNameHindi || "",
          category: mlData.category,
          craftTechnique: mlData.craftTechnique,
          materials: mlData.materials,
          description: mlData.description,
          tags: mlData.tags,
          estimatedCost: priceData.estimatedCost || 50,
          sellingPrice: priceData.sellingPrice || 150,
          productionDays: priceData.productionDays || 3,
          region: mlData.region || "Unknown",
          aiMinPrice: priceData.aiMinPrice || 120,
          suggestedPriceMin: priceData.suggestedPriceMin || 120,
          suggestedPriceMax: priceData.suggestedPriceMax || 180,
        };
      } catch (mlErr) {
        console.warn("FastAPI ML service call failed, falling back to local Gemini client:", mlErr.message);
        aiData = await analyzeCraftImage({
          base64Data: req.file.buffer.toString("base64"),
          mimeType: req.file.mimetype,
          language: req.user.language || "hi",
        });
      }

      // 3. Generate signed catalog draft token
      const catalogDraftToken = signCatalogDraft({
        artisanId: req.user._id,
        catalog: {
          ...aiData,
          images: [uploadedImage.url],
        },
      });

      return res.json({
        success: true,
        message: "AI Smart Cataloging complete!",
        draftProductData: aiData,
        image: uploadedImage,
        catalogDraftToken,
      });
    } catch (err) {
      next(err);
    }
  }
);

module.exports = router;