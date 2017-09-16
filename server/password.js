'use strict';
const bcrypt = require('bcrypt');

const ITERATIONS = 10;

const encrypt = psw => bcrypt.hash(psw, ITERATIONS);
const check = (a, b) => bcrypt.compare(a, b);

module.exports = { encrypt, check };
