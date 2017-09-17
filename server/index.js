'use strict';
const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');

const auth = require('./auth');
const headers = require('./headers');
const db = require('./database');
const result = require('./result');
const spotify = require('./spotify');

const app = express();

app.listen(process.env.PORT || 19786, () => console.log(`Server is listening on port ${process.env.PORT || 19786}`));

app.use(bodyParser.json());

app.use('/user', require('./user'));
app.use('/follow', require('./follow'));
app.use('/like', require('./like'));

/**
 * Sign in
 * @body {
 *   email: String,
 *   psw: String
 * }
 * @return { { authtoken: String, first_name: String, last_name: String, avatar: String } }
 */
app.post('/auth', headers, async (req, res) => {
  const { email, psw } = req.body;
  try {
    const { user_id, first_name, last_name, avatar } = await db.getSecureUser(email, psw);
    res.send(result.success({
      authtoken: auth.create(user_id),
      user_id, first_name, last_name, avatar, email
    }));
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

/**
 * Status change
 * @requires Authorization
 * @body {
 *   status: 'PLAY' | 'STOP',
 *   song: { title: String, artist: ?String, album: ?String }
 * }
 */
app.put('/status', auth.check, headers, async (req, res) => {
  const { uid } = req.user;
  const { status, song } = req.body;
  try {
    if(status === 'PLAY') {
      const spotlift = await spotify.identifySong(song);
      await db.playingStatus(uid, spotlift.id);
    } else {
      await db.playingStatus(uid, null);
    }
    res.send(result.success());
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

/**
 * Send location
 * @requires Authorization
 * @param {Double} close
 * @param {Double} medium
 * @param {Double} far
 * @body {
 *   lat: Double,
 *   lng: Double
 * }
 * @returns {
 *   close: [
 *     {
 *        first_name: String,
 *        last_name: String,
 *        avatar: String,
 *        likes: Int
 *     }
 *  ]
 *   medium: [...]
 *   far: [...]
 * }
 */
app.put('/location', auth.check, headers, async (req, res) => {
  const { uid } = req.user;
  const { lat, lng } = req.body;
  try {
    await db.setLocation(uid, lat, lng);
    const close = 1;
    const medium = 5;
    const far = 10;
    res.send(result.success(await findCloseUsers(uid, close, medium, far)));
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

/**
 * Get people listening nearby
 * @requires Authorization
 * @param {Double} close
 * @param {Double} medium
 * @param {Double} far
 * @returns {
 *   close: [
 *     {
 *        first_name: String,
 *        last_name: String,
 *        avatar: ?String,
 *        likes: Int,
 *        song: {
 *          name: String
 *          artist: String
 *          album: String
 *          id: String
 *        }
 *     }
 *  ]
 *   medium: [...]
 *   far: [...]
 * }
 */
app.get('/nearby', auth.check, headers, async (req, res) => {
  const { uid } = req.user;
  try{
    const close = 1;
    const medium = 5;
    const far = 10;
    res.send(result.success(await findCloseUsers(uid, close, medium, far)));
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

async function findCloseUsers(user_id, distClose, distMedium, distFar){
  const { close, medium, far } = await db.findClose(user_id, distClose, distMedium, distFar);
  const rows = [].concat(close, medium, far);
  const songs = await spotify.lookupSongs(rows.map(_ => _.current_playing));
  const final = { close: [], medium: [], far: [] };
  songs.forEach((row, i) => {
    const song = {
      name: row.name,
      album: row.album.name,
      artist: row.artists.map(_ => _.name).join(', '),
      id: row.id,
    };
    let user;
    if(i < close.length) {
      user = close[i];
      const { first_name, last_name, avatar, likes, user_id, email } = user;
      final.close.push({ first_name, last_name, avatar, likes: +likes, song, user_id, email });
    } else if(i < close.length + medium.length) {
      user = medium[i - close.length];
      const { first_name, last_name, avatar, likes, user_id, email } = user;
      final.medium.push({ first_name, last_name, avatar, likes: +likes, song, user_id, email });
    } else {
      user = far[i - close.length - medium.length];
      const { first_name, last_name, avatar, likes, user_id, email } = user;
      final.far.push({ first_name, last_name, avatar, likes: +likes, song, user_id, email });
    }
  });
  return final;
};

app.use('/debug', express.static('../web-console'));
