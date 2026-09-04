const dns = require("dns").promises;
const net = require("net");
const ApiError = require("../utils/ApiError");

const MAX_IMAGE_BYTES = 8 * 1024 * 1024;

const isPrivateIp = (address) => {
  const ipVersion = net.isIP(address);

  if (ipVersion === 4) {
    const [a, b] = address.split(".").map(Number);

    return (
      a === 10 ||
      a === 127 ||
      a === 0 ||
      (a === 169 && b === 254) ||
      (a === 172 && b >= 16 && b <= 31) ||
      (a === 192 && b === 168) ||
      (a === 100 && b >= 64 && b <= 127)
    );
  }

  if (ipVersion === 6) {
    const lower = address.toLowerCase();

    return (
      lower === "::1" ||
      lower.startsWith("fc") ||
      lower.startsWith("fd") ||
      lower.startsWith("fe80") ||
      lower.includes("::ffff:127.0.0.1")
    );
  }

  return true;
};

const validatePublicImageUrl = async (imageUrl) => {
  let parsedUrl;

  try {
    parsedUrl = new URL(imageUrl);
  } catch (error) {
    throw new ApiError(400, "imageUrl must be a valid URL.");
  }

  if (!["http:", "https:"].includes(parsedUrl.protocol)) {
    throw new ApiError(400, "Only HTTP and HTTPS image URLs are allowed.");
  }

  if (parsedUrl.username || parsedUrl.password) {
    throw new ApiError(400, "Image URL credentials are not allowed.");
  }

  if (parsedUrl.hostname === "localhost") {
    throw new ApiError(400, "Local image URLs are not allowed.");
  }

  try {
    const addresses = await dns.lookup(parsedUrl.hostname, {
      all: true,
      verbatim: true,
    });

    if (!addresses.length || addresses.some((item) => isPrivateIp(item.address))) {
      throw new ApiError(400, "Private network image URLs are not allowed.");
    }
  } catch (error) {
    if (error instanceof ApiError) throw error;

    throw new ApiError(400, "Unable to validate image URL host.");
  }

  return parsedUrl.toString();
};

const readResponseWithLimit = async (response) => {
  if (!response.body) {
    throw new ApiError(422, "Unable to read image data.");
  }

  const reader = response.body.getReader();
  const chunks = [];
  let totalBytes = 0;

  while (true) {
    const { done, value } = await reader.read();

    if (done) break;

    totalBytes += value.length;

    if (totalBytes > MAX_IMAGE_BYTES) {
      await reader.cancel();
      throw new ApiError(413, "Image must be smaller than 8 MB.");
    }

    chunks.push(value);
  }

  return Buffer.concat(chunks);
};

const downloadPublicImage = async (imageUrl) => {
  const validatedUrl = await validatePublicImageUrl(imageUrl);

  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 15000);

  try {
    const response = await fetch(validatedUrl, {
      method: "GET",
      redirect: "error",
      signal: controller.signal,
      headers: {
        Accept: "image/jpeg,image/png,image/webp",
      },
    });

    if (!response.ok) {
      throw new ApiError(
        422,
        `Unable to download image. Server returned ${response.status}.`
      );
    }

    const contentType = String(
      response.headers.get("content-type") || ""
    )
      .split(";")[0]
      .trim()
      .toLowerCase();

    const allowedMimeTypes = ["image/jpeg", "image/png", "image/webp"];

    if (!allowedMimeTypes.includes(contentType)) {
      throw new ApiError(
        415,
        "Only JPEG, PNG, and WEBP images are supported."
      );
    }

    const contentLength = Number(response.headers.get("content-length"));

    if (contentLength && contentLength > MAX_IMAGE_BYTES) {
      throw new ApiError(413, "Image must be smaller than 8 MB.");
    }

    const imageBuffer = await readResponseWithLimit(response);

    return {
      mimeType: contentType,
      base64Data: imageBuffer.toString("base64"),
    };
  } catch (error) {
    if (error instanceof ApiError) throw error;

    if (error.name === "AbortError") {
      throw new ApiError(408, "Image download timed out.");
    }

    throw new ApiError(422, "Could not download the provided image.");
  } finally {
    clearTimeout(timeout);
  }
};

module.exports = {
  downloadPublicImage,
};
