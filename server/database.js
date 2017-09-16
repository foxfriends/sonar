'use strict';
const pg = require('pg');
const SQL = require('sql-template-strings');
const hash = require('./hash');

const config = {
  user: 'musicapp',
  host: 'localhost',
  database: 'music',
  port: 26257,
};

const pool = new pg.Pool(config);

function connect() { return pool.connect(); }

/* NOTE: Don't forget to add it to module.exports list at the bottom!
async function example() {
  const db = await connect();
  try {
    const { rows: users } = await db.query(SQL `SELECT * FROM USERS`);
    // do stuff
    return users;
  } catch(error) {
    throw error;
  } finally {
    db.release();
  }
}
*/

async function createAccount(usr, psw) {
  const db = await connect();
  try {
    const hashed = await hash(psw);
    const { rowCount: exists } = await db.query(SQL `SELECT 1 FROM USERS WHERE username = ${usr}`);
    if (exists) {
      throw new Error('An account with that username has already been created');
    }
    await db.query(SQL `INSERT INTO users (username, password) VALUES (${usr}, ${hashed})`);
  } catch(error) {
    throw error;
  } finally {
    db.release();
  }
}

async function playingStatus(user_id, song) {
  const db = await connect();
  try {
    const { rows: users } = await db.query(SQL `UPDATE users SET current_playing = ${song} WHERE user_id = ${user_id}` );
  } catch(error) {
    throw error;
  } finally {
    db.release();
  }
}

module.exports = { createAccount, playingStatus };
