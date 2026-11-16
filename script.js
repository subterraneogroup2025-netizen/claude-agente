/* ── VIDEO LIGHTBOX ── */
function openVideo(src) {
  const lb = document.getElementById('videoLightbox');
  const player = document.getElementById('videoPlayer');
  player.src = src;
  lb.classList.add('open');
  document.body.style.overflow = 'hidden';
  player.play();
}
function closeVideo() {
  const lb = document.getElementById('videoLightbox');
  const player = document.getElementById('videoPlayer');
  lb.classList.remove('open');
  player.pause();
  player.src = '';
  document.body.style.overflow = '';
}
document.addEventListener('keydown', e => {
  const lb = document.getElementById('videoLightbox');
  if (e.key === 'Escape' && lb && lb.classList.contains('open')) closeVideo();
});

/* ── MEDICIÓN DE GOOGLE ADS (solo si el visitante acepta las cookies) ──
   ADS_ID: el "ID de conversión" de Google Ads (AW-...). Vacío = medición apagada.
   ADS_LABELS: la "etiqueta de conversión" de cada acción, desde Objetivos → Conversiones. */
const ADS_ID = 'AW-18576970369';   /* cuenta Google Ads 553-976-9241 */
const ADS_LABELS = {
  whatsapp:   'ZFWeCPjg_rgdEIGlmJpF',   /* WhatsApp (clic en la web) */
  llamada:    'nZV4CPvg_rgdEIGlmJpF',   /* Llamada (clic en el teléfono de la web) */
  formulario: 'FHMxCP7g_rgdEIGlmJpF',   /* Formulario de presupuesto enviado */
  suelos:     '3yJwCIHh_rgdEIGlmJpF'    /* Presupuesto de suelos por WhatsApp */
};

window.dataLayer = window.dataLayer || [];
function gtag() { dataLayer.push(arguments); }
gtag('consent', 'default', {
  ad_storage: 'denied', ad_user_data: 'denied', ad_personalization: 'denied', analytics_storage: 'denied'
});
let adsLoaded = false;
function loadAds() {
  if (adsLoaded || !ADS_ID) return;
  adsLoaded = true;
  gtag('consent', 'update', { ad_storage: 'granted', ad_user_data: 'granted' });
  const s = document.createElement('script');
  s.async = true;
  s.src = 'https://www.googletagmanager.com/gtag/js?id=' + ADS_ID;
  document.head.appendChild(s);
  gtag('js', new Date());
  gtag('config', ADS_ID);
}
window.trackConversion = function (kind) {
  if (!adsLoaded || !ADS_LABELS[kind]) return;
  gtag('event', 'conversion', { send_to: ADS_ID + '/' + ADS_LABELS[kind] });
};
document.addEventListener('click', e => {
  const a = e.target.closest && e.target.closest('a[href]');
  if (!a) return;
  if (a.protocol === 'tel:') trackConversion('llamada');
  else if (/(^|\.)wa\.me$|whatsapp\.com$/.test(a.hostname)) trackConversion('whatsapp');
}, true);

/* ── COOKIES ── */
const COOKIE_KEY = 'cookies-v2';   /* v2: el aviso ahora incluye Google Ads, se vuelve a preguntar */
function storeCookieChoice(value) {
  try { localStorage.setItem(COOKIE_KEY, value); } catch (e) { /* almacenamiento bloqueado */ }
  document.getElementById('cookieBanner').classList.remove('show');
}
function acceptCookies() { storeCookieChoice('accepted'); loadAds(); }
function declineCookies() { storeCookieChoice('declined'); }
function resetCookies() {
  try { localStorage.removeItem(COOKIE_KEY); } catch (e) { /* almacenamiento bloqueado */ }
  document.cookie.split(';').map(c => c.split('=')[0].trim()).filter(n => /^_gcl|^_ga/.test(n)).forEach(n => {
    document.cookie = n + '=; Max-Age=0; path=/';
    document.cookie = n + '=; Max-Age=0; path=/; domain=.' + location.hostname.replace(/^www\./, '');
  });
  const banner = document.getElementById('cookieBanner');
  if (adsLoaded) { location.reload(); return; }
  if (banner) banner.classList.add('show');
}
let cookieChoice = null;
try { cookieChoice = localStorage.getItem(COOKIE_KEY); } catch (e) { /* almacenamiento bloqueado */ }
if (cookieChoice === 'accepted') loadAds();
if (!cookieChoice && document.getElementById('cookieBanner')) {
  document.getElementById('cookieBanner').classList.add('show');
}

/* ── NAV SCROLL ── */
const nav = document.getElementById('nav');
window.addEventListener('scroll', () => {
  nav.classList.toggle('scrolled', window.scrollY > 60);
}, { passive: true });

/* ── BURGER MENU ── */
const burger = document.getElementById('burger');
const navLinks = document.querySelector('.nav__links');

function toggleMenu() {
  const open = navLinks.classList.toggle('open');
  burger.classList.toggle('open', open);
  document.body.style.overflow = open ? 'hidden' : '';
}

navLinks.querySelectorAll('a').forEach(a => {
  a.addEventListener('click', () => {
    navLinks.classList.remove('open');
    burger.classList.remove('open');
    document.body.style.overflow = '';
  });
});

/* ── LIGHTBOX ── */
let lightboxImgs = [];
let lightboxIndex = 0;

document.querySelectorAll('.gallery__item img').forEach((img, i) => {
  img.parentElement.addEventListener('click', () => openLightbox(i));
});

function buildGalleryList() {
  lightboxImgs = Array.from(document.querySelectorAll('.gallery__item img')).map(i => i.src);
}

function openLightbox(index) {
  if (!lightboxImgs.length) buildGalleryList();
  lightboxIndex = index;
  document.getElementById('lightboxImg').src = lightboxImgs[index];
  document.getElementById('lightbox').classList.add('open');
  document.body.style.overflow = 'hidden';
}

function closeLightbox() {
  document.getElementById('lightbox').classList.remove('open');
  document.body.style.overflow = '';
}

function lightboxMove(dir) {
  lightboxIndex = (lightboxIndex + dir + lightboxImgs.length) % lightboxImgs.length;
  document.getElementById('lightboxImg').src = lightboxImgs[lightboxIndex];
}

document.addEventListener('keydown', e => {
  const lb = document.getElementById('lightbox');
  if (!lb || !lb.classList.contains('open')) return;
  if (e.key === 'Escape') closeLightbox();
  if (e.key === 'ArrowLeft') lightboxMove(-1);
  if (e.key === 'ArrowRight') lightboxMove(1);
});

/* ── REVEAL ON SCROLL ── */
const revealObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
      revealObserver.unobserve(entry.target);
    }
  });
}, { threshold: 0.08, rootMargin: '0px 0px -40px 0px' });

document.querySelectorAll('.reveal').forEach(el => revealObserver.observe(el));

setTimeout(() => {
  document.querySelectorAll('.reveal:not(.visible)').forEach(el => el.classList.add('visible'));
}, 800);

/* ── FORMULARIO → EMAIL ──
   Usa EmailJS (gratis hasta 200 emails/mes).
   Pasos para activarlo:
   1. Regístrate en https://emailjs.com con tu cuenta de Google
   2. Crea un "Email Service" conectado a Gmail
   3. Crea un "Email Template" y copia tu template_id
   4. Copia tu public_key desde Account → API Keys
   5. Sustituye los valores TU_PUBLIC_KEY, TU_SERVICE_ID, TU_TEMPLATE_ID abajo
*/
const EMAILJS_PUBLIC_KEY  = 'R3Ey8-rse7M2TZAEE';
const EMAILJS_SERVICE_ID  = 'service_rogfukp';
const EMAILJS_TEMPLATE_ID = 'template_rjdp271';

const contactForm = document.getElementById('contactForm');
if (contactForm) contactForm.addEventListener('submit', async function(e) {
  e.preventDefault();
  const btn = this.querySelector('button[type="submit"]');
  const msg = document.getElementById('form-msg');

  const data = {
    nombre:   this.nombre.value,
    telefono: this.telefono.value,
    email:    this.email.value,
    tipo:     this.tipo.value,
    zona:     this.zona.value,
    desc:     this.desc.value,
  };

  /* Si EmailJS no está configurado aún, muestra confirmación local */
  if (EMAILJS_PUBLIC_KEY === 'TU_PUBLIC_KEY') {
    msg.style.color = 'var(--gold)';
    msg.textContent = '✓ Solicitud recibida. Le contactaremos en menos de 24 horas.';
    this.reset();
    setTimeout(() => { msg.textContent = ''; }, 6000);
    return;
  }

  btn.textContent = 'Enviando...';
  btn.disabled = true;

  try {
    await emailjs.send(EMAILJS_SERVICE_ID, EMAILJS_TEMPLATE_ID, data, EMAILJS_PUBLIC_KEY);
    msg.style.color = 'var(--gold)';
    msg.textContent = '✓ Solicitud enviada. Le contactaremos en menos de 24 horas.';
    trackConversion('formulario');
    this.reset();
  } catch (err) {
    msg.style.color = '#e05555';
    msg.textContent = 'Error al enviar. Llámenos directamente al 638 57 19 20.';
  } finally {
    btn.textContent = 'Enviar solicitud';
    btn.disabled = false;
    setTimeout(() => { msg.textContent = ''; }, 8000);
  }
});
