'use strict';
const pg = require('pg');
const SQL = require('sql-template-strings');
const password = require('./password');

const config = {
  user: 'musicapp',
  host: 'localhost',
  database: 'music',
  port: 26257,
};

const pool = new pg.Pool(config);

function connect() { return pool.connect(); }

/* NOTE: Don't forget to add it to module.exports list at the bottom!
async function example(user_id) {
  const db = await connect();
  try {
    const { rows: users } = await db.query(SQL `SELECT * FROM users WHERE user_id = ${user_id}`);
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
    const hashed = await password.encrypt(psw);
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

async function getUserId(usr, psw) {
  const db = await connect();
  try {
    const { rows: [ user ] } = await db.query(SQL `SELECT user_id, password FROM USERS WHERE username = ${usr}`);
    if (user) {
      const { user_id, password: pass } = user;
      if(await password.check(psw, pass)) {
        return user_id;
      } else {
        throw new Error('Incorrect email or password');
      }
    } else {
      throw new Error('Non-existent user');
    }
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

async function setLocation(user_id, lat, long) {
  const db = await connect();
  try {
    const { rows: users } = await db.query(SQL `UPDATE users SET latitude = ${lat}, longitude = ${long} WHERE user_id = ${user_id}` );
  } catch(error) {
    throw error;
  } finally {
    db.release();
  }
}
async function findClose(user_id, close, medium, far) {
  const db = await connect();
  try {
    // user_id's longitude & latitude
    const { rows: [self] } = await db.query(SQL
      `SELECT longitude, latitude FROM users WHERE user_id = ${user_id}`
    );

    // close
    const { rows: usersClose } = await findUsers(user_id, 0, close, self.latitude, self.longitude, db);
    // medium
    const { rows: usersMedium } = await findUsers(user_id, close, medium, self.latitude, self.longitude, db);
    // far
    const { rows: usersFar } = await findUsers(user_id, medium, far, self.latitude, self.longitude, db);
    return {
      close: usersClose,
      medium: usersMedium,
      far: usersFar
    };
  } catch(error) {
    throw error;
  } finally {
    db.release();
  }
}
async function findUsers(user_id, small, big, lat, long, db){
  return await db.query(SQL
    `SELECT * FROM users
     WHERE sqrt(pow(${lat} - latitude, 2.0) + pow(${long} - users.longitude, 2.0)) <= ${big}
     AND  sqrt(pow(${lat} - latitude, 2.0), pow(${long} - users.longitude, 2.0)) > ${small}
     AND users.user_id <> ${user_id}`
  );
};
module.exports = { createAccount, getUserId, playingStatus, setLocation, findClose };
