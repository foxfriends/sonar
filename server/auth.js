const JWT = require('jsonwebtoken');
const expressJWT = require('express-jwt');

const secret = 'SUPER-SECRET-KEY!';

function create(uid) {
  return JWT.sign({ uid }, secret, { expiresIn: '30 days' });
}

const check = expressJWT({ secret });

module.exports = { create, check };
