'use strict';
const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');

const auth = require('./auth');
const headers = require('./headers');
const db = require('./database');
const result = require('./result');

const app = express();

app.listen(process.env.PORT || 19786, () => console.log(`Server is listening on port ${process.env.PORT || 19786}`));

app.use(bodyParser.json());

app.use('/user', require('./user'));

/**
 * Sign in
 * @body {
 *   usr: String
 *   psw: String
 * }
 * @return { { tok: String } }
 */
app.post('/auth', headers, async (req, res) => {
  const { usr, psw } = req.body;
  try {
    const uid = await db.getUserId(usr, psw);
    res.send(result.success(auth.create(uid)));
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

/**
 * Status change
 * @requires Authorization
 * @body {
 *   status: 'PLAY' | 'STOP',
 *   song: ?String
 * }
 */
app.put('/status', auth.check, headers, async (req, res) => {
  const { uid } = req.user;
  const { status, song } = req.body;
  try {
    await db.playingStatus(uid, status === 'PLAY' ? song : null);
    res.send(result.success());
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

/**
 * Send location
 * @requires Authorization
 * @body {
 *   lat: Double,
 *   lng: Double
 * }
 */
app.put('/location', auth.check, headers, async (req, res) => {
  const { uid } = req.user;
  const { lat, lng } = req.body;
  try {
    await db.setLocation(uid, lat, lng);
    res.send(result.success());
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
 *   nearby: {
 *     username: String,
 *     score: Int,
 *     song: String,
 *     distance: Double
 *   }
 * }
 */
app.get('/nearby', auth.check, headers, async (req, res) => {
  const { uid } = req.user;
  try{
    var close = parseFloat(req.query.close);
    var medium = parseFloat(req.query.medium);
    var far = parseFloat(req.query.far);

    res.send(result.success(await db.findClose(uid, close, medium, far)));
  }
  catch(error){
    res.send(error.message);
  }

});

app.use('/debug', express.static('../web-console'));
