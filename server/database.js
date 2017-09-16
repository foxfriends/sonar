const pg = require('pg');
const SQL = require('sql-template-strings');

const config = {
  user: 'musicapp',
  host: 'localhost',
  database: 'music',
  port: 26257,
};
const pool = new pg.Pool(config);

function connect() { return pool.connect(); }

/*
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

module.exports = {};
