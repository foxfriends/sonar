'use strict';
module.exports = (req, res, next) => {
  res.set('Content-Type', 'application/json');
  res.set('Cache-Control', 'no-cache, no-store, must-revalidate');
  res.set('Pragma', 'no-cache');
  res.set('Expires', '0');

  next();
};
