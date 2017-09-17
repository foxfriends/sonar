'use strict';
const express = require('express');
const app = express();
const auth = require('./auth');
const headers = require('./headers');
const result = require('./result');
const db = require('./database');

/**
 * Get how many people are following a user
 * @requires Authorization
 * @param { Number } user_id
 * @returns Number
 */
app.get('/followers/:user_id', auth.check, headers, async (req, res) => {
  const { user_id } = req.params;
  try {
    res.send(result.success(await db.getFollowers(user_id)));
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

/**
 * Get list of people are following you
 * @requires Authorization
 * @returns Number
 */
app.get('/followers', auth.check, headers, async (req, res) => {
  const { uid } = req.user;
  try {
    res.send(result.success(await db.getFollowers(uid)));
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

/**
 * Follow a new user
 * @requires Authorization
 * @param { Number } user_id
 */
app.put('/:user_id', auth.check, headers, async (req, res) => {
  const { uid } = req.user;
  const { user_id } = req.params;
  try {
    await db.followUser(uid, user_id)
    res.send(result.success());
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

app.delete('/:user_id', auth.check, headers, async (req, res) => {
  const { uid } = req.user;
  const { user_id } = req.params;
  try {
    await db.unfollowUser(uid, user_id)
    res.send(result.success());
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

/**
 * Get a list of people a user is following
 * @requires Authorization
 * @param { Number } user_id
 * @returns {
 *  list: { first_name: String, last_name: String, avatar: String }[]
 * }
 */
app.get('/:user_id', auth.check, headers, async (req, res) => {
  const { user_id } = req.params;
  try {
    res.send(result.success(await db.getMyFollowingList(user_id)));
  } catch(error) {
    res.send(result.failure(error.message));
  }
});

/**
 * Get a list of people you are following
 * @requires Authorization
 * @returns {
 *   list: { first_name: String, last_name: String, avatar: String }[]
 * }
 */
app.get('/', auth.check, headers, async (req, res) => {
  const { uid } = req.user;
  try {
    res.send(result.success(await db.getMyFollowingList(uid)));
  } catch(error) {
    res.send(result.failure(error.message));
  }
});


module.exports = app;
