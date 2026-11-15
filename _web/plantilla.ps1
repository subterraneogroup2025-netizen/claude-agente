# Plantilla común de las páginas generadas (materiales, reformas y blog).
# Requiere que quien la cargue defina antes: $root, $SITE y $utf8.

function Esc([string] $s) { [Net.WebUtility]::HtmlEncode($s) }
function Write-Page([string] $rel, [string] $html) {
  $path = Join-Path $root $rel
  New-Item -ItemType Directory -Force (Split-Path $path) | Out-Null
  [IO.File]::WriteAllText($path, $html, $utf8)
}
function Json($o) { ($o | ConvertTo-Json -Depth 12 -Compress) -replace '</', '<\/' }

function Head($title, $desc, $canonical, $image, $jsonld, $robots = 'index, follow, max-image-preview:large', $ogType = 'website') {
@"
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$(Esc $title)</title>
  <meta name="description" content="$(Esc $desc)">
  <meta name="robots" content="$robots">
  <link rel="canonical" href="$SITE$canonical">
  <meta name="theme-color" content="#0A0A0A">
  <meta property="og:type" content="$ogType">
  <meta property="og:locale" content="es_ES">
  <meta property="og:site_name" content="Subterráneo Group">
  <meta property="og:title" content="$(Esc $title)">
  <meta property="og:description" content="$(Esc $desc)">
  <meta property="og:url" content="$SITE$canonical">
  <meta property="og:image" content="$SITE$image">
  <meta name="twitter:card" content="summary_large_image">
  <link rel="icon" type="image/png" sizes="32x32" href="/logo/logo/favicon/favicon-32.png">
  <link rel="icon" type="image/png" sizes="256x256" href="/logo/logo/favicon/favicon-256.png">
  <link rel="apple-touch-icon" href="/logo/logo/favicon/favicon-256.png">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,500;0,600;1,500&family=Montserrat:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="/style.css">
  <link rel="stylesheet" href="/materiales/materiales.css">
  <script type="application/ld+json">$jsonld</script>
</head>
"@
}

function Get-Nav([string] $active, [bool] $quote = $false) {
  $a = { param($k) if ($k -eq $active) { ' class="is-active"' } else { '' } }
  $quoteBtn = if ($quote) { '<button type="button" class="m-quote-btn" data-open-quote aria-label="Abrir mi presupuesto"><span>Mi presupuesto</span> <b data-quote-count>0</b></button>' } else { '' }
@"
<body>
  <nav class="nav scrolled m-solid" id="nav" aria-label="Principal">
    <a href="/" class="nav__logo"><img src="/logo-nav.png" alt="Subterráneo Group, reformas integrales" width="93" height="70"></a>
    <ul class="nav__links">
      <li><a href="/#nosotros">Nosotros</a></li>
      <li><a href="/reformas/"$(& $a 'reformas')>Reformas</a></li>
      <li><a href="/#galeria">Galería</a></li>
      <li><a href="/materiales/"$(& $a 'materiales')>Materiales</a></li>
      <li><a href="/#contacto" class="nav__cta">Presupuesto</a></li>
    </ul>
    <div class="m-nav-right">
      $quoteBtn
      <button class="nav__burger" id="burger" aria-label="Abrir menú" onclick="toggleMenu()"><span></span><span></span><span></span></button>
    </div>
  </nav>
"@
}

function Get-Footer([bool] $quote = $false) {
  $js = if ($quote) { "`n  <script src=`"/materiales/materiales.js`" defer></script>" } else { '' }
@"
  <footer class="footer">
    <div class="footer__top">
      <img src="/logo/logo/isotipo/transparente/subterraneo-isotipo-transparente-256.png" alt="" class="footer__logo" width="70" height="70" loading="lazy">
      <p class="footer__tagline">Bien hecho, hasta donde no se ve</p>
      <nav class="footer__nav" aria-label="Reformas">
        <a href="/reformas/reformas-integrales-valencia/">Reformas integrales</a>
        <a href="/reformas/reforma-banos-valencia/">Reforma de baños</a>
        <a href="/reformas/reforma-cocinas-valencia/">Reforma de cocinas</a>
        <a href="/reformas/rehabilitacion-fachadas-valencia/">Fachadas</a>
        <a href="/reformas/empresa-reformas-torrent/">Reformas en Torrent</a>
        <a href="/blog/">Blog</a>
      </nav>
      <nav class="footer__nav" aria-label="Materiales">
        <a href="/materiales/suelos-efecto-marmol/">Efecto mármol</a>
        <a href="/materiales/suelo-porcelanico-imitacion-madera/">Imitación madera</a>
        <a href="/materiales/suelos-efecto-piedra/">Efecto piedra</a>
        <a href="/materiales/porcelanico-gran-formato/">Gran formato</a>
        <a href="/materiales/suelos-exterior-antideslizantes/">Exterior</a>
      </nav>
    </div>
    <div class="footer__divider"></div>
    <div class="footer__legal">
      <a href="/aviso-legal.html">Aviso Legal</a><span>·</span><a href="/privacidad.html">Política de Privacidad</a>
    </div>
    <p class="footer__copy">© 2026 Subterráneo Group S.L · Calle Moralets 3, 46900 Torrent (Valencia) · <a href="tel:+34638571920">638 57 19 20</a></p>
  </footer>

  <a class="whatsapp-btn" href="https://wa.me/34638571920?text=Hola%2C%20me%20gustar%C3%ADa%20solicitar%20un%20presupuesto" target="_blank" rel="noopener" aria-label="Contactar por WhatsApp">
    <svg viewBox="0 0 24 24" fill="currentColor" width="28" height="28" aria-hidden="true"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347z"/><path d="M12 0C5.373 0 0 5.373 0 12c0 2.125.557 4.126 1.532 5.862L.057 23.428a.75.75 0 00.916.916l5.566-1.475A11.952 11.952 0 0012 24c6.627 0 12-5.373 12-12S18.627 0 12 0zm0 21.75a9.737 9.737 0 01-4.964-1.358l-.355-.211-3.684.976.976-3.684-.211-.355A9.738 9.738 0 012.25 12C2.25 6.615 6.615 2.25 12 2.25S21.75 6.615 21.75 12 17.385 21.75 12 21.75z"/></svg>
  </a>
  <div class="mobile-cta-bar" aria-label="Contacto rápido">
    <a href="tel:+34638571920" class="mobile-cta-bar__call">Llamar</a>
    <a href="https://wa.me/34638571920?text=Hola%2C%20me%20gustar%C3%ADa%20solicitar%20un%20presupuesto" target="_blank" rel="noopener" class="mobile-cta-bar__wp">WhatsApp</a>
  </div>
  <div class="cookie-banner" id="cookieBanner">
    <p>Utilizamos Google Fonts, que puede recoger tu IP según su política de privacidad. No usamos cookies propias de seguimiento. <a href="/privacidad.html">Más información</a></p>
    <div class="cookie-banner__btns">
      <button class="btn-gold" onclick="acceptCookies()">Aceptar</button>
      <button class="btn-ghost" onclick="declineCookies()">Rechazar</button>
    </div>
  </div>
  <script src="/script.js" defer></script>$js
</body>
</html>
"@
}

function Crumbs($items) {
  $li = ($items | ForEach-Object { if ($_[1]) { "<li><a href=`"$($_[1])`">$(Esc $_[0])</a></li>" } else { "<li aria-current=`"page`">$(Esc $_[0])</li>" } }) -join ''
  "<nav class=`"m-crumbs`" aria-label=`"Migas de pan`"><ol>$li</ol></nav>"
}
function CrumbsLd($items) {
  $i = 0
  @{ '@type' = 'BreadcrumbList'; itemListElement = @($items | ForEach-Object { $i++; $e = @{ '@type' = 'ListItem'; position = $i; name = $_[0] }; if ($_[1]) { $e.item = "$SITE$($_[1])" }; $e }) }
}
