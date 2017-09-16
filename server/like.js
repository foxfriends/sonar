'use strict';
const express = require('express');
const app = express();
const auth = require('./auth');
const headers = require('./headers');
const result = require('./result');
const db = require('./database');

/**
 * Get a list of songs I like
 * @requires Authorization
 * @returns {
 *   list: { [song_id: String] }
 * }
 */
app.get('/', auth.check, headers, async (req, res) => {
  const { uid } = req.user;
  try {
    res.send(result.success(await db.getMyLikes(uid)));
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

/**
 * like a new song
 * @requires Authorization
 * @param { Number } user_id
 */
app.put('/:song_id', auth.check, headers, async (req, res) => {
  const { uid } = req.user;
  const { song_id } = req.params;
  try {
    await db.likeSong(uid, song_id)
    res.send(result.success());
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

app.delete('/:song_id', auth.check, headers, async (req, res) => {
  const { uid } = req.user;
  const { song_id } = req.params;
  try {
    await db.unlikeSong(uid, song_id)
    res.send(result.success());
  } catch(error) {
    res.send(result.failure(error.message));
  }
});
module.exports = app;
