// server.js
require('dotenv').config();
const path = require('path');
const express = require('express');
const cors = require('cors');
const { pool, selfTest } = require('./event_db');

const app = express();
app.use(cors());
app.use(express.json());

// Serve the client site
app.use(express.static(path.join(__dirname, 'public')));

// --- Health ---
app.get('/health', async (_req, res) => {
  try {
    const [r] = await pool.query('SELECT 1 AS ok');
    res.json({ status: 'ok', db: r[0].ok === 1 ? 'up' : 'unknown' });
  } catch (e) {
    res.status(500).json({ status: 'error', error: String(e) });
  }
});

// --- Categories (for search filter) ---
app.get('/api/categories', async (_req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT id, name, slug FROM categories ORDER BY name ASC`
    );
    res.json(rows);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Failed to fetch categories' });
  }
});

// --- Home feed: active + upcoming (exclude suspended) ---
app.get('/api/events/home', async (_req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT e.id, e.title, e.start_datetime, e.end_datetime,
              e.location_city, e.location_venue, e.image_url,
              e.is_free, e.price_cents, c.name AS category
         FROM events e
         JOIN categories c ON c.id = e.category_id
        WHERE e.status = 'active'
          AND e.end_datetime > NOW()
        ORDER BY e.start_datetime ASC`
    );
    res.json(rows);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Failed to fetch events' });
  }
});

// --- Past events: active but ended (for "Show past" toggle) ---
app.get('/api/events/past', async (_req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT e.id, e.title, e.start_datetime, e.end_datetime,
              e.location_city, e.location_venue, e.image_url,
              e.is_free, e.price_cents, c.name AS category
         FROM events e
         JOIN categories c ON c.id = e.category_id
        WHERE e.status = 'active'
          AND e.end_datetime <= NOW()
        ORDER BY e.end_datetime DESC`
    );
    res.json(rows);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Failed to fetch past events' });
  }
});

// --- Search: date (start/end), city, category (any combo) ---
app.get('/api/events/search', async (req, res) => {
  try {
    const { start, end, city, category } = req.query;

    const where = [`e.status = 'active'`];
    const params = [];

    if (start) {
      where.push(`e.start_datetime >= ?`);
      params.push(`${start} 00:00:00`);
    }
    if (end) {
      where.push(`e.end_datetime < ?`);
      params.push(`${end} 00:00:00`);
    }
    if (city) {
      where.push(`e.location_city LIKE ?`);
      params.push(`%${city}%`);
    }
    if (category) {
      where.push(`c.slug = ?`);
      params.push(category);
    }

    const sql = `
      SELECT e.id, e.title, e.start_datetime, e.end_datetime,
             e.location_city, e.location_venue, e.image_url,
             e.is_free, e.price_cents, c.name AS category
        FROM events e
        JOIN categories c ON c.id = e.category_id
       WHERE ${where.join(' AND ')}
       ORDER BY e.start_datetime ASC`;

    const [rows] = await pool.query(sql, params);
    res.json({ count: rows.length, results: rows });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Search failed' });
  }
});

// --- Event details ---
app.get('/api/events/:id', async (req, res) => {
  try {
    const id = Number(req.params.id);
    if (!Number.isInteger(id)) {
      return res.status(400).json({ error: 'Invalid id' });
    }

    const [rows] = await pool.query(
      `SELECT e.*, c.name AS category_name,
              o.name AS org_name, o.mission AS org_mission, o.website AS org_website
         FROM events e
         JOIN categories c ON c.id = e.category_id
         JOIN organisations o ON o.id = e.org_id
        WHERE e.id = ?`,
      [id]
    );

    if (rows.length === 0) return res.status(404).json({ error: 'Not found' });
    res.json(rows[0]);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Failed to fetch event details' });
  }
});

// Fallback to SPA pages
app.get('*', (_req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Start server after DB self-test
const PORT = Number(process.env.PORT || 3001);
selfTest()
  .then(() => app.listen(PORT, () => console.log(`running: http://localhost:${PORT}`)))
  .catch((err) => {
    console.error('[Startup] DB connection failed:', err);
    process.exit(1);
  });
