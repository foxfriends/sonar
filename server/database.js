const pg = require('pg');
const SQL = require('sql-template-strings');

const config = {
  user: 'musicapp',
  host: 'localhost',
  database: 'music',
  port: 26257,
};
const pool = new pg.Pool(config);



module.exports = {};
