// Error handling utilities
class AppError extends Error {
  constructor(message, statusCode) {
    super(message);
    this.statusCode = statusCode;
    Error.captureStackTrace(this, this.constructor);
  }
}

const handleDatabaseError = (err) => {
  console.error('Database Error:', err);
  if (err.code === '23505') {
    return new AppError('Duplicate entry found', 409);
  }
  if (err.code === '23503') {
    return new AppError('Referenced record does not exist', 400);
  }
  return new AppError('Database operation failed', 500);
};

const errorHandler = (err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  const message = err.message || 'Internal Server Error';
  
  console.error(`[${new Date().toISOString()}] Error:`, {
    message,
    statusCode,
    path: req.path,
    method: req.method
  });

  res.status(statusCode).json({
    success: false,
    error: message,
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
};

module.exports = {
  AppError,
  handleDatabaseError,
  errorHandler
};
