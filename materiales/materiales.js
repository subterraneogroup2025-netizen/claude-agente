(() => {
  const WP = '34638571920';
  const KEY = 'sg-presupuesto';
  const $ = (s, el = document) => el.querySelector(s);
  const $$ = (s, el = document) => [...el.querySelectorAll(s)];

  const dec = n => n.toFixed(2).replace('.', ',').replace(/\B(?=(\d{3})+(?!\d))/g, '.');
  const int = n => Math.round(n).toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.');

  function load() {
    try { return JSON.parse(localStorage.getItem(KEY)) || []; } catch { return []; }
  }
  function save(items) {
    try { localStorage.setItem(KEY, JSON.stringify(items)); } catch { /* sin almacenamiento: el presupuesto dura lo que la página */ }
  }
  let quote = load();

  /* ── Panel "Mi presupuesto" ── */
  const drawer = document.createElement('aside');
  drawer.className = 'm-drawer';
  drawer.setAttribute('aria-label', 'Mi presupuesto');
  drawer.innerHTML = `
    <header><h2>Mi presupuesto</h2><button type="button" data-close aria-label="Cerrar">✕</button></header>
    <div class="m-drawer__body">
      <div id="m-lines"></div>
      <div class="m-totals" id="m-totals"></div>
      <p class="m-label">Tus datos</p>
      <div class="m-form">
        <input id="m-nombre" placeholder="Nombre" autocomplete="name">
        <input id="m-tel" placeholder="Teléfono" type="tel" autocomplete="tel">
        <input id="m-loc" placeholder="Localidad de la obra" autocomplete="address-level2">
        <select id="m-inst"><option value="Sí">Quiero también la colocación</option><option value="No">Solo el material</option></select>
      </div>
    </div>
    <footer>
      <button type="button" class="m-btn m-btn--wp" data-send>Enviar solicitud por WhatsApp</button>
      <small>Te respondemos en menos de 24 h con el presupuesto cerrado. Tus datos se usan solo para este presupuesto (<a href="/privacidad.html">privacidad</a>).</small>
    </footer>`;
  const bg = document.createElement('div');
  bg.className = 'm-drawer__bg';
  const toast = document.createElement('div');
  toast.className = 'm-toast';
  toast.setAttribute('role', 'status');
  document.body.append(drawer, bg, toast);

  function openDrawer() { render(); drawer.classList.add('is-open'); bg.classList.add('is-open'); }
  function closeDrawer() { drawer.classList.remove('is-open'); bg.classList.remove('is-open'); }
  $$('[data-open-quote]').forEach(b => b.addEventListener('click', openDrawer));
  bg.addEventListener('click', closeDrawer);
  $('[data-close]', drawer).addEventListener('click', closeDrawer);
  document.addEventListener('keydown', e => { if (e.key === 'Escape') closeDrawer(); });

  function render() {
    $$('[data-quote-count]').forEach(el => { el.textContent = quote.length; });
    const lines = $('#m-lines');
    if (!quote.length) {
      lines.innerHTML = '<p class="m-empty">Todavía no has añadido ningún suelo. Entra en un producto, calcula tus metros y pulsa «Añadir a mi presupuesto».</p>';
      $('#m-totals').innerHTML = '';
      return;
    }
    lines.innerHTML = quote.map((q, i) => `
      <div class="m-line">
        <img src="${q.img}" alt="" width="64" height="64">
        <div><a href="/materiales/${q.slug}/">${q.nombre}</a><span>${q.formato} cm · ${q.cajas} ${q.unidad}${q.cajas === 1 ? '' : 's'} · ${dec(q.m2)} m²</span></div>
        <div>${q.precio ? `<strong>${int(q.m2 * q.precio)} €</strong>` : '<strong>A consultar</strong>'}<button type="button" data-remove="${i}">Quitar</button></div>
      </div>`).join('');
    const priced = quote.filter(q => q.precio);
    const total = priced.reduce((s, q) => s + q.m2 * q.precio, 0);
    $('#m-totals').innerHTML = priced.length
      ? `<span>Material aproximado${priced.length < quote.length ? ' (sin los productos a consultar)' : ''}</span><b>${int(total)} €</b>`
      : '<span>Te enviaremos el precio de cada material</span>';
    $$('[data-remove]', lines).forEach(b => b.addEventListener('click', () => {
      quote.splice(Number(b.dataset.remove), 1);
      save(quote);
      render();
    }));
  }

  $('[data-send]', drawer).addEventListener('click', () => {
    if (!quote.length) { closeDrawer(); return; }
    const items = quote.map(q => `• ${q.nombre} ${q.formato} cm: ${q.cajas} ${q.unidad}${q.cajas === 1 ? '' : 's'} (${dec(q.m2)} m²)`).join('\n');
    const nombre = $('#m-nombre').value.trim();
    const tel = $('#m-tel').value.trim();
    const loc = $('#m-loc').value.trim();
    const msg = ['Hola, quiero presupuesto de estos materiales:', items, '',
      `Colocación: ${$('#m-inst').value}`,
      nombre && `Nombre: ${nombre}`, tel && `Teléfono: ${tel}`, loc && `Localidad: ${loc}`]
      .filter(Boolean).join('\n');
    window.open(`https://wa.me/${WP}?text=${encodeURIComponent(msg)}`, '_blank', 'noopener');
  });

  function flash(text) {
    toast.textContent = text;
    toast.classList.add('is-on');
    setTimeout(() => toast.classList.remove('is-on'), 2200);
  }

  /* ── Ficha de producto ── */
  const dataEl = $('#m-product');
  if (dataEl) {
    const p = JSON.parse(dataEl.textContent);
    const main = $('#m-main-img');
    const cap = $('#m-main-cap');
    $$('.m-thumbs button').forEach(btn => btn.addEventListener('click', () => {
      $$('.m-thumbs button').forEach(b => b.classList.remove('is-on'));
      btn.classList.add('is-on');
      main.src = btn.dataset.src;
      main.alt = btn.dataset.cap;
      cap.textContent = btn.dataset.cap;
    }));

    const input = $('#m-m2');
    const extra = $('#m-extra');
    const result = () => {
      const need = Math.max(0, parseFloat(String(input.value).replace(',', '.')) || 0);
      const withExtra = extra.checked ? need * 1.1 : need;
      const cajas = Math.max(need ? 1 : 0, Math.ceil(withExtra / p.m2caja - 1e-9));
      return { cajas, m2: cajas * p.m2caja };
    };
    const calc = () => {
      const r = result();
      $('#m-out-cajas').textContent = r.cajas;
      $('#m-out-m2').textContent = dec(r.m2);
      $('#m-out-total').textContent = p.precio ? `${int(r.m2 * p.precio)} €` : 'A consultar';
    };
    input.addEventListener('input', calc);
    extra.addEventListener('change', calc);
    $$('[data-step]').forEach(b => b.addEventListener('click', () => {
      input.value = Math.max(1, (parseFloat(input.value) || 0) + Number(b.dataset.step));
      calc();
    }));
    calc();

    const current = () => {
      const r = result();
      return { slug: p.slug, nombre: p.nombre, formato: p.formato, img: p.img, unidad: p.unidad, precio: p.precio, cajas: r.cajas, m2: r.m2 };
    };
    $('[data-add]').addEventListener('click', () => {
      const item = current();
      if (!item.cajas) { input.focus(); return; }
      const i = quote.findIndex(q => q.slug === item.slug);
      if (i >= 0) quote[i] = item; else quote.push(item);
      save(quote);
      render();
      flash('Añadido a tu presupuesto');
      openDrawer();
    });
    $('[data-wp-now]').addEventListener('click', () => {
      const r = result();
      const msg = `Hola, quiero presupuesto de ${p.nombre} ${p.formato} cm: ${r.cajas} ${p.unidad}${r.cajas === 1 ? '' : 's'} (${dec(r.m2)} m²). Colocación: ${$('#m-inst-pdp').checked ? 'Sí' : 'No'}.`;
      window.open(`https://wa.me/${WP}?text=${encodeURIComponent(msg)}`, '_blank', 'noopener');
    });
  }

  /* ── Listado con filtros ── */
  const grid = $('#m-grid');
  if (grid) {
    const cards = $$('.m-card', grid);
    const counter = $('#m-count');
    const boxes = $$('.m-filters input[type=checkbox]');
    const apply = () => {
      const groups = {};
      boxes.filter(b => b.checked).forEach(b => { (groups[b.name] = groups[b.name] || []).push(b.value); });
      let shown = 0;
      cards.forEach(c => {
        const ok = Object.entries(groups).every(([k, vals]) => vals.some(v => (c.dataset[k] || '').split(' ').includes(v)));
        c.hidden = !ok;
        if (ok) shown++;
      });
      counter.textContent = `${shown} ${shown === 1 ? 'producto' : 'productos'}`;
    };
    boxes.forEach(b => b.addEventListener('change', apply));
    const sort = $('#m-sort');
    if (sort) sort.addEventListener('change', () => {
      const key = sort.value;
      const num = (c, k) => parseFloat(c.dataset[k]) || 0;
      const sorted = [...cards].sort((a, b) => {
        if (key === 'formato') return num(b, 'area') - num(a, 'area');
        if (key === 'precio') return (num(a, 'precio') || 1e9) - (num(b, 'precio') || 1e9);
        return num(a, 'orden') - num(b, 'orden');
      });
      sorted.forEach(c => grid.appendChild(c));
    });
    const toggle = $('.m-filters__toggle');
    if (toggle) toggle.addEventListener('click', () => $('.m-filters').classList.toggle('is-open'));
    apply();
  }

  render();
})();
