import { API_BASE, nav, centsToAUD, formatDateTime, renderError } from './common.js';

document.getElementById('top').innerHTML = nav();

const box = document.getElementById('box');
const params = new URLSearchParams(location.search);
const id = Number(params.get('id'));

if (!Number.isInteger(id)) {
  renderError(box, 'Invalid event id.');
} else {
  (async () => {
    try {
      const res = await fetch(`${API_BASE}/api/events/${id}`);
      if (res.status === 404) {
        renderError(box, 'Event not found.');
        return;
      }
      if (!res.ok) throw new Error('Failed to load event');
      const e = await res.json();

      box.innerHTML = `
        <img src="${e.image_url || 'https://picsum.photos/seed/fallback/1000/400'}" alt=""
             style="width:100%;height:260px;object-fit:cover;border-radius:10px;margin-bottom:10px">
        <div class="row">
          <span class="badge">${e.category_name}</span>
          <span class="badge">${centsToAUD(e.price_cents)}</span>
        </div>
        <h2>${e.title}</h2>
        <div class="muted">
          ${e.location_city || ''}${e.location_venue ? ' · ' + e.location_venue : ''}
        </div>
        <div class="muted">
          ${formatDateTime(e.start_datetime)} → ${formatDateTime(e.end_datetime)}
        </div>
        <p>${e.description || ''}</p>

        <div class="row">
          <div><strong>Goal:</strong> ${e.goal_amount_cents ? 'A$ ' + (e.goal_amount_cents/100).toFixed(2) : '—'}</div>
          <div><strong>Raised:</strong> ${e.raised_amount_cents ? 'A$ ' + (e.raised_amount_cents/100).toFixed(2) : '—'}</div>
        </div>

        <hr style="border-color:#1e2a42">
        <h3>Register</h3>
        <p class="muted">Ticketing/registration is not implemented in A2.</p>
        <button class="btn-primary" id="btnReg">Register</button>

        <hr style="border-color:#1e2a42">
        <h3>Organiser</h3>
        <p>
          <strong>${e.org_name}</strong><br>
          ${e.org_mission || ''}<br>
          ${e.org_website ? `<a href="${e.org_website}" target="_blank" rel="noopener">${e.org_website}</a>` : ''}
        </p>
      `;

      document.getElementById('btnReg').addEventListener('click', () => {
        alert('This feature is currently under construction.');
      });
    } catch (err) {
      renderError(box, err.message);
    }
  })();
}
