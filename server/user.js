'use strict';
const express = require('express');

const auth = require('./auth');
const headers = require('./headers');
const db = require('./database');
const result = require('./result');
const push = require('./push');
const spotify = require('./spotify');

const app = express();

/**
 * Sign up
 * @body {
 *   first: String,
 *   last: String,
 *   psw: String,
 *   email: String
 * }
 */
app.post('/new', headers, async (req, res) => {
  const { first, last, psw, email } = req.body;
  try {
    await db.createAccount(first, last, psw, email);
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
 *   psw: String
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

/**
 * Suggest a song to someone else
 * @requires Authorization
 * @body { song : { title: String, artist: ?String, album: ?String } }
 */
app.post('/:user_id/suggest', auth.check, headers, async (req, res) => {
  const { uid } = req.user;
  const { user_id } = req.params;
  const { song } = req.body;
  try {
    const [devices, me, track] = await Promise.all([
      db.getDevices(user_id),
      db.getUser(uid),
      spotify.identifySong(song),
    ]);
    push.suggestion(devices, me, track);
    res.send(result.success());
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

module.exports = app;
