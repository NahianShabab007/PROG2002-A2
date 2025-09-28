// event_db.js
const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  // Helpful for MySQL 8 timezone handling
  dateStrings: true
});

// quick self-test at startup
async function selfTest() {
  const conn = await pool.getConnection();
  try {
    const [rows] = await conn.query('SELECT DATABASE() AS db');
    console.log(`[DB] Connected. Using database: ${rows[0].db}`);
  } finally {
    conn.release();
  }
}

module.exports = { pool, selfTest };
