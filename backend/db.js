const { Pool } = require('pg');

const pool = new Pool({
  user: 'gatoaa',
  host: 'localhost',
  database: 'menu',
  password: 'phisiaa',
  port: 5432,
});

module.exports = pool;