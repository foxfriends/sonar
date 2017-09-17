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
    const songList = await db.getMyLikes(uid);
    const spotlift = await spotify.lookupSongs(songList.map(_ => _.song_id));
    res.send(result.success(spotlift.map(_ => ({ title: _.name, album: _.album.name, artist: _.artists.map(_ => _.name).join(', '), id: _.id }))));
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

/**
 * like a new song
 * @requires Authorization
 * @param { Number } user_id
 * @body {
 *    from_user: INT
 * }
 */
app.put('/:song_id', auth.check, headers, async (req, res) => {
  const { uid } = req.user;
  const { song_id } = req.params;
  const { from_user } = req.body;
  try {
    const songList = await db.likeSong(uid, song_id, from_user);

    res.send(result.success());
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

app.delete('/:song_id', auth.check, headers, async (req, res) => {
  const { uid } = req.user;
  const { song_id } = req.params;
  try {
    await db.unlikeSong(uid, song_id);
    res.send(result.success());
  } catch(error) {
    res.send(result.failure(error.message));
  }
});
module.exports = app;
