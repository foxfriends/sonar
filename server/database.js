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

async function createAccount(first, last, psw, email) {
  const db = await connect();
  try {
    const hashed = await password.encrypt(psw);
    const { rowCount: exists } = await db.query(SQL `SELECT 1 FROM USERS WHERE email = ${email}`);
    if (exists) {
      throw new Error('An account with that username has already been created');
    }
    const { rows: [ { user_id } ] } = await db.query(SQL `INSERT INTO users (password, email) VALUES (${hashed}, ${email}) RETURNING user_id`);
    await db.query(SQL `INSERT INTO profile (user_id, first_name, last_name) VALUES (${user_id}, ${first}, ${last})`);
  } catch(error) {
    throw error;
  } finally {
    db.release();
  }
}

async function getSecureUser(email, psw) {
  const db = await connect();
  try {
    const { rows: [ user ] } = await db.query(SQL `SELECT user_id, first_name, last_name, email, avatar, password FROM users INNER JOIN profile ON users.user_id = profile.user_id WHERE email = ${email}`);
    if (user) {
      const { user_id, password: pass } = user;
      if(await password.check(psw, pass)) {
        delete user.password;
        return user;
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

async function getUser(user_id) {
  const db = await connect();
  try {
    const { rows: [ user ] } = await db.query(SQL `
      SELECT user_id, first_name, last_name, likes, current_playing, email
      FROM users
      WHERE user_id = ${user_id}
    `);
    if(user) {
      return user;
    } else {
      throw new Error('No user with that user id exists!');
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
    if (song != null){
        const { rows: history } = await db.query(SQL `INSERT INTO history_songs (user_id, song_name) VALUES (${user_id}, ${song})`);
    }
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
    if (self.longitude !== null && self.latitude !== null) {
      // close
      const { rows: usersClose } = await findNearbyUsers(user_id, 0, close, self.latitude, self.longitude, db);
      // medium
      const { rows: usersMedium } = await findNearbyUsers(user_id, close, medium, self.latitude, self.longitude, db);
      // far
      const { rows: usersFar } = await findNearbyUsers(user_id, medium, far, self.latitude, self.longitude, db);
      return {
        close: usersClose,
        medium: usersMedium,
        far: usersFar
      };
    }
    throw new Error("User doesn't have a longitude/latitude set");
  } catch(error) {
    throw error;
  } finally {
    db.release();
  }
}

async function findNearbyUsers(user_id, small, big, lat, long, db) {
  return await db.query(SQL
    `SELECT first_name, last_name, avatar, likes, current_playing FROM users
     WHERE sqrt(pow(${lat} - latitude, 2.0) + pow(${long} - users.longitude, 2.0)) <= ${big}
     AND sqrt(pow(${lat} - latitude, 2.0) + pow(${long} - users.longitude, 2.0)) > ${small}
     AND users.user_id <> ${user_id} AND current_playing IS NOT NULL`
  );
}

async function followUser(me, them) {
  const db = await connect();
  try {
    // would be nice to do 'ON CONFLICT ON CONSTRAINT follow_only_once DO NOTHING'
    // but it appears unimplemented by cockroach...
    await db.query(SQL`
      INSERT INTO following_users (user_id, following_user_id) VALUES (${me}, ${them})
    `);
  } catch(error) {
    throw error;
  } finally {
    db.release();
  }
}

async function unfollowUser(me, them) {
  const db = await connect();
  try {
    await db.query(SQL`DELETE FROM following_users WHERE user_id = ${me} AND following_user_id = ${them}`);
  } catch(error) {
    throw error;
  } finally {
    db.release();
  }
}

async function getMyFollowingList(user_id){
  const db = await connect();
  try {
    const { rows: following } = await db.query(SQL
      `SELECT first_name, last_name, avatar, email
       FROM following_users
       INNER JOIN users ON following_users.following_user_id = users.user_id
       WHERE following_users.user_id = ${user_id}`
     );
    return following;
  } catch(error) {
    throw error;
  } finally {
    db.release();
  }
}
async function getFollowers(user_id) {
  const db = await connect();
  try {
    const { rowCount } = await db.query(
      SQL `SELECT first_name, last_name, avatar, email
       FROM following_users
       INNER JOIN users ON following_users.following_user_id = users.user_id
       WHERE following_users.following_user_id = ${user_id}`
    );
    return rowCount;
  } catch(error) {
    throw error;
  } finally {
    db.release();
  }
}

async function getDevices(user_id) {
  const db = await connect();
  try {
    const { rows: devices } = await db.query(SQL `SELECT device_id FROM user_devices WHERE user_id = ${user_id}`);
    return devices;
  } catch(error) {
    throw error;
  } finally {
    db.release();
  }
}

async function getMyLikes(user_id){
  const db = await connect();
  try {
    const { rows: likes } = await db.query(SQL
      `SELECT song_id
       FROM song_likes
       WHERE user_id = ${user_id}`
     );
    return likes;
  } catch(error) {
    throw error;
  } finally {
    db.release();
  }
}
async function likeSong(user_id, song_id, from_user){
  const db = await connect();
  try {
    const { rows: likes } = await db.query(SQL
      `INSERT INTO song_likes (song_id, user_id)
       VALUES (${song_id}, ${user_id})`
     );
     const { rows: increaseLike } = await db.query(SQL
       `UPDATE users SET likes = likes + 1
     WHERE user_id = ${from_user}`
   );
    return likes;
  } catch(error) {
    throw error;
  } finally {
    db.release();
  }
}
async function unlikeSong(user_id, song_id){
  const db = await connect();
  try {
    const { rows: likes } = await db.query(SQL
      `DELETE FROM song_likes WHERE user_id = ${user_id} AND song_id = ${song_id}`
     );
    return likes;
  } catch(error) {
    throw error;
  } finally {
    db.release();
  }
}
module.exports = {
  createAccount,
  getSecureUser,
  getUser,
  playingStatus,
  setLocation,
  findClose,
  followUser,
  unfollowUser,
  getMyFollowingList,
  getFollowers,
  getDevices,
  getMyLikes,
  unlikeSong,
  likeSong
};
