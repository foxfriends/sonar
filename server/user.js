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
 * Edit profile??
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
 * @returns { user_id: Number, first_name: String, last_name: String, likes: Number, email: String, current_playing: String, song: { title: String, artist: String, album: String } }
 */
app.get('/', auth.check, headers, (req, res) => {
  const { uid } = req.user;
  return getUserProfile(req, res, uid);
});

/**
 * Get a user's profile
 * @requires Authorization
 * @param { Number } user_id
 * @returns { user_id: Number, first_name: String, last_name: String, likes: Number, email: String, current_playing: String, song: { title: String, artist: String, album: String } }
 */
app.get('/:user_id', auth.check, headers, (req, res) => {
  const { user_id } = req.params;
  return getUserProfile(req, res, user_id);
});

/**
 * Get the user's listening history
 * @requires Authorization
 * @param { String } user_id
 * @return { { title: String, artist: String, album: String, id: String }[] }
 */
app.get('/:user_id/history', auth.check, headers, async (req, res) => {
  const { user_id } = req.params;
  try {
    const history = await db.getHistory(user_id);
    const spotlift = await spotify.lookupSongs(history.map(_ => _.song_name));
    res.send(result.success(spotlift.map(_ => ({ title: _.name, album: _.album.name, artist: _.artists.map(_ => _.name).join(', '), id: _.id }))));
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

async function getUserProfile(req, res, user_id) {
  try {
    const user = await db.getUser(user_id);
    const [track] = user.current_playing ? await spotify.lookupSongs([user.current_playing]) : [null];
    if (track !== null){
      user.song = {
        title: track.name,
        album: track.album.name,
        artist: track.artists.map(_ => _.name).join(', '),
        id: track.id,
      };
    }
    else {
        user.song = null;
    }

    delete user.current_playing;
    res.send(result.success(user));
  } catch(error) {
    res.send(result.failure(error.message));
  }
}

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
