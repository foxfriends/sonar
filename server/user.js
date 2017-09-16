'use strict';
const express = require('express');

const auth = require('./auth');
const headers = require('./headers');
const db = require('./database');
const result = require('./result');

const app = express();

/**
 * Sign up
 * @body {
 *   usr: String,
 *   psw: String,
 *   email: String
 * }
 */
app.post('/new', headers, async (req, res) => {
  const { usr, psw } = req.body;
  try {
    await db.createAccount(usr, psw);
    res.send(result.success());
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

/**
 * Edit profile
 * @requires Authorization
 * @body {
 *   usr: String,
 *   psw: String,
 *   email: String
 * }
 */
app.put('/', auth.check, headers, (req, res) => {
  const { uid } = req.user;
});

/**
 * Get your own profile
 * @requires Authorization
 */
app.get('/', auth.check, headers, (req, res) => {
  const { uid } = req.user;
  return getUserProfile(req, res, uid, uid);
});

/**
 * Get a user's profile
 * @requires Authorization
 * @param { Number } user_id
 */
app.get('/:user_id', auth.check, headers, (req, res) => {
  const { uid } = req.user;
  const { user_id } = req.params;
  return getUserProfile(req, res, uid, user_id);
});

function getUserProfile(req, res, me, them) {}

module.exports = app;
