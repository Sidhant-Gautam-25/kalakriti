const crypto = require("crypto");
const ApiError = require("../utils/ApiError");

const getSecret = () => {
  if (!process.env.CATALOG_DRAFT_SECRET) {
    throw new ApiError(
      503,
      "CATALOG_DRAFT_SECRET is missing from environment configuration."
    );
  }

  return process.env.CATALOG_DRAFT_SECRET;
};

const signCatalogDraft = ({ artisanId, catalog, expiresInSeconds = 1800 }) => {
  const payload = {
    artisanId: String(artisanId),
    catalog,
    issuedAt: Date.now(),
    expiresAt: Date.now() + expiresInSeconds * 1000,
  };

  const encodedPayload = Buffer.from(JSON.stringify(payload)).toString(
    "base64url"
  );

  const signature = crypto
    .createHmac("sha256", getSecret())
    .update(encodedPayload)
    .digest("base64url");

  return `${encodedPayload}.${signature}`;
};

const verifyCatalogDraft = (token) => {
  if (!token || typeof token !== "string" || !token.includes(".")) {
    throw new ApiError(400, "A valid catalogDraftToken is required.");
  }

  const [encodedPayload, receivedSignature] = token.split(".");

  const expectedSignature = crypto
    .createHmac("sha256", getSecret())
    .update(encodedPayload)
    .digest("base64url");

  const receivedBuffer = Buffer.from(receivedSignature);
  const expectedBuffer = Buffer.from(expectedSignature);

  const isValidSignature =
    receivedBuffer.length === expectedBuffer.length &&
    crypto.timingSafeEqual(receivedBuffer, expectedBuffer);

  if (!isValidSignature) {
    throw new ApiError(401, "Invalid catalog draft token.");
  }

  let payload;

  try {
    payload = JSON.parse(
      Buffer.from(encodedPayload, "base64url").toString("utf8")
    );
  } catch (error) {
    throw new ApiError(400, "Invalid catalog draft payload.");
  }

  if (!payload.expiresAt || Date.now() > payload.expiresAt) {
    throw new ApiError(
      401,
      "Catalog draft expired. Please generate the AI catalog again."
    );
  }

  return payload;
};

module.exports = {
  signCatalogDraft,
  verifyCatalogDraft,
};
