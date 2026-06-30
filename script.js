/* ── COOKIES ── */
function acceptCookies() {
  localStorage.setItem('cookies', 'accepted');
  document.getElementById('cookieBanner').classList.remove('show');
}
function declineCookies() {
  localStorage.setItem('cookies', 'declined');
  document.getElementById('cookieBanner').classList.remove('show');
}
if (!localStorage.getItem('cookies')) {
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
  if (!document.getElementById('lightbox').classList.contains('open')) return;
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

document.getElementById('contactForm').addEventListener('submit', async function(e) {
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
