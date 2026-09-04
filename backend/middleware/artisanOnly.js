const ApiError = require("../utils/ApiError");

const artisanOnly = (req, res, next) => {
  const role = String(req.user?.role || "").toLowerCase();

  if (!req.user || role !== "artisan") {
    return next(
      new ApiError(403, "Only artisan accounts can access this resource.")
    );
  }

  next();
};

module.exports = artisanOnly;
