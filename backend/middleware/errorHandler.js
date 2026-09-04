module.exports = (err, req, res, next) => {
  console.error('❌ Server Error:', err.message || err);

  const statusCode = err.statusCode || 500;

  res.status(statusCode).json({
    success: false,
    message: err.message || 'Internal server error',
    details: err.details || undefined,
  });
};