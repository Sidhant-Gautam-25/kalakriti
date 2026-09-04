const crypto = require("crypto");
const ApiError = require("../utils/ApiError");

const verifyWhatsAppBotSecret = (req, res, next) => {
  const expectedSecret = process.env.WHATSAPP_BOT_SECRET;
  const receivedSecret = req.get("x-whatsapp-bot-secret");

  if (!expectedSecret) {
    return next(
      new ApiError(503, "WHATSAPP_BOT_SECRET is not configured in server environment.")
    );
  }

  if (!receivedSecret) {
    return next(new ApiError(401, "WhatsApp bot secret header (x-whatsapp-bot-secret) is missing."));
  }

  const expectedBuffer = Buffer.from(expectedSecret);
  const receivedBuffer = Buffer.from(receivedSecret);

  const isValid =
    expectedBuffer.length === receivedBuffer.length &&
    crypto.timingSafeEqual(expectedBuffer, receivedBuffer);

  if (!isValid) {
    return next(new ApiError(401, "Invalid WhatsApp bot secret."));
  }

  next();
};

module.exports = verifyWhatsAppBotSecret;
