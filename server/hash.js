'use strict';
const bcrypt = require('bcrypt');

const ITERATIONS = 10;

const hash = psw => bcrypt.hash(psw, ITERATIONS);

module.exports = hash;
