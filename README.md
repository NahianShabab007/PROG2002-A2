# Charity Events (PROG2002 – A2)

## Prerequisites
- Node.js 18+
- MySQL or MariaDB running locally (port 3306)

## Setup
1) adjust DB creds in .env if needed.
2) Import `db/charityevents_db.sql` (Workbench → Data Import, or mysql CLI).
3) Install deps:
   npm install
4) Run:
   npm start
   # Site: http://localhost:3001/index.html
   # Health: http://localhost:3001/health

## Endpoints
- GET /health
- GET /api/categories
- GET /api/events/home
- GET /api/events/past
- GET /api/events/search?start=YYYY-MM-DD&end=YYYY-MM-DD&city=Sydney&category=fun-run
- GET /api/events/:id

## Notes
- Suspended events are hidden.
- “Register” is intentionally non-functional for A2 (modal/alert).

## Troubleshooting
- 1045 access denied → check `.env` DB_USER/DB_PASS; ensure server running on 3306.
- If using XAMPP (MariaDB), 127.0.0.1 works better than `localhost`.
