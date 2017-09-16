'use strict';
const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');

const auth = require('./auth');

const app = express();

app.listen(process.env.PORT || 19786, () => console.log('Server is listening on port 19786'));

app.use(bodyParser.json());

// TODO: modularize below

/**
 * Sign in
 * @body {
 *   usr: String
 *   psw: String
 * }
 * @return { { tok: String } }
 */
app.post('/auth', (req, res) => {
  const { usr, psw } = req.body;
});

/**
 * Sign up
 * @body {
 *   usr: String,
 *   psw: String,
 *   email: String
 * }
 */
app.post('/user/new', (req, res) => {
  const { usr, psw, email } = req.body;
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
app.put('/user', auth.check, (req, res) => {
  const { uid } = req.user;
});
/**
 * Read profile
 * @requires Authorization
 * @param { Number } user_id
 */
app.get('/user/:user_id', auth.check, (req, res) => {
  const { uid } = req.user;
  const { user_id } = req.params;
});

/**
 * Status change
 * @body {
 *   status: 'PLAY' | 'STOP',
 *   song: ?String
 * }
 */
app.put('/status', auth.check, (req, res) => {
  const { uid } = req.user;
  const { status, song } = req.body;
});

/**
 * Send location
 * @requires Authorization
 * @body {
 *   lat: Double,
 *   lng: Double
 * }
 */
app.put('/location', auth.check, (req, res) => {
  const { uid } = req.user;
  const { lat, lng } = req.body;
});

/**
 * Get people listening nearby
 * @requires Authorization
 * @returns {
 *   nearby: {
 *     song: String,
 *     distance: Double
 *   }
 * }
 */
app.get('/nearby', auth.check, (req, res) => {
  const { uid } = req.user;
});
