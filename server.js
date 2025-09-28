// server.js
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { pool, selfTest } = require('./event_db');

const app = express();
app.use(cors());
app.use(express.json());

// health check (also pings DB)
app.get('/health', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT 1 AS ok');
    res.json({ status: 'ok', db: rows[0].ok === 1 ? 'up' : 'unknown' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ status: 'error', error: String(err) });
  }
});

// small smoke test: count events + return first 5
app.get('/events', async (req, res) => {
  try {
    const [[countRow]] = await pool.query('SELECT COUNT(*) AS total FROM events');
    const [rows] = await pool.query(
      `SELECT e.id, e.title, e.start_datetime, e.end_datetime, e.location_city, c.name AS category
         FROM events e
         JOIN categories c ON c.id = e.category_id
         ORDER BY e.start_datetime ASC
         LIMIT 5`
    );
    res.json({ total: countRow.total, sample: rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ status: 'error', error: String(err) });
  }
});

const PORT = Number(process.env.PORT || 3001);
selfTest()
  .then(() => app.listen(PORT, () => console.log(`API up on http://localhost:${PORT}`)))
  .catch((err) => {
    console.error('[Startup] DB connection failed:', err);
    process.exit(1);
  });
