# Genera el apartado /materiales/ y el sitemap a partir de productos.csv, precios.csv y fotos.csv.
# Uso:  powershell -ExecutionPolicy Bypass -File materiales\_datos\generar.ps1
$ErrorActionPreference = 'Stop'
$datos = Split-Path $MyInvocation.MyCommand.Path
$mat = Split-Path $datos
$root = Split-Path $mat
$SITE = 'https://subterraneogroup.com'
$inv = [Globalization.CultureInfo]::InvariantCulture
$utf8 = New-Object Text.UTF8Encoding $false
$hoy = (Get-Date).ToString('yyyy-MM-dd')

. (Join-Path $root '_web\plantilla.ps1')
function Dec([double] $n) { $n.ToString('N2', [Globalization.CultureInfo]::GetCultureInfo('es-ES')) }
function Fmt([string] $f) { $f -replace 'x', ' × ' }

# ── Datos ──
$prods = @(Import-Csv "$datos\productos.csv" -Delimiter ';' -Encoding UTF8)
$precios = @{}
foreach ($r in (Import-Csv "$datos\precios.csv" -Delimiter ';' -Encoding UTF8)) {
  $v = ($r.precio_m2 -replace '[^\d,\.]', '') -replace ',', '.'
  if ($v) { $precios[$r.slug] = [double]::Parse($v, $inv) }
}
$pies = @{}
foreach ($r in (Import-Csv "$datos\fotos.csv" -Delimiter ';' -Encoding UTF8)) { $pies[$r.img] = $r.pie }

$pack = @{
  'astra|120x120' = @(10.5, 1, 1.42, 34.5);  'astra|60x120' = @(10.5, 2, 1.40, 33.21)
  'astra|75x150'  = @(10.5, 1, 1.08, 25.88); 'astra|100x100' = @(10.5, 2, 1.92, 46.48)
  'general|120x120' = @(10.5, 1, 1.44, 34.0); 'general|60x120' = @(10, 2, 1.43, 30.38)
  'general|75x150'  = @(10, 1, 1.11, 25.0);   'general|100x100' = @(10, 2, 1.98, 44.38)
  'general|23x120'  = @(9.7, 4, 1.09, 22.22); 'general|30x150' = @(10, 3, 1.35, 28.5)
  'general|30x180'  = @(8.5, 3, 1.62, 46.66)
  'general-nr|23x120' = @(9.7, 4, 1.12, 22.78)
  '2out|60x90' = @(20, 2, 1.07, 44.76); '2out|100x100' = @(20, 1, 0.99, 42.5); '2out|60x120' = @(20, 1, 0.71, 30.67)
  'xlim|120x280' = @(6, 1, 3.36, 0)
}
# Medida real de fabricación (lista de embalaje de los catálogos STN); "general-nr" = pieza no rectificada
$real = @{
  'astra|120x120' = '119 × 119'; 'astra|60x120' = '59 × 119'; 'astra|75x150' = '73,5 × 148'; 'astra|100x100' = '98 × 98'
  'general|120x120' = '120 × 120'; 'general|60x120' = '59,5 × 120'; 'general|75x150' = '74,5 × 149,5'; 'general|100x100' = '99,5 × 99,5'
  'general|23x120' = '22,7 × 119,5'; 'general|30x150' = '30 × 149,5'; 'general|30x180' = '30 × 180'
  'general-nr|23x120' = '23,3 × 120'
  '2out|60x90' = '59,5 × 90'; '2out|100x100' = '99,5 × 99,5'; '2out|60x120' = '59,5 × 120'
}
$efectoTxt = @{ marmol = 'efecto mármol'; piedra = 'efecto piedra'; madera = 'imitación madera'; cemento = 'efecto cemento'; terrazo = 'terrazo' }
$efectoCorto = @{ marmol = 'Mármol'; piedra = 'Piedra'; madera = 'Madera'; cemento = 'Cemento'; terrazo = 'Terrazo' }
$usoTxt = @{
  interior = 'Suelo y pared de interior'
  antid    = 'Interior y exterior, zonas húmedas'
  inout    = 'Interior y exterior con la misma pieza'
  exterior = 'Exterior: terrazas, jardines y piscinas'
  xlim     = 'Encimeras, paredes y mobiliario'
}
$acabadoTxt = @{
  'Pulido'             = 'El acabado pulido da un brillo de espejo que multiplica la luz natural y realza cada veta.'
  'Pulido apomazado'   = 'El acabado apomazado suaviza el brillo del pulido y deja una superficie sedosa y elegante.'
  'Satinado'           = 'El acabado satinado ofrece un brillo suave, menos reflectante que el pulido y muy fácil de mantener.'
  'Lappato'            = 'El acabado lappato es un semipulido: combina zonas mate y brillo y deja un tacto sedoso.'
  'Mate'               = 'El acabado mate es natural al tacto, no refleja la luz y disimula bien el uso diario.'
  'Antideslizante'     = 'Su superficie antideslizante clase C3 lo hace seguro en baños, terrazas y bordes de piscina.'
  'Mate INOUT'         = 'Tiene la misma estética dentro y fuera, con un acabado antideslizante apto para exterior: el suelo continúa sin cortes hacia la terraza.'
  'Antideslizante 2 cm' = 'Con 2 cm de grosor, clase antideslizante C3 y alta resistencia a la rotura, aguanta el uso exterior y admite también colocación en seco sobre grava o césped.'
}
$formatoTxt = @{
  '120x120' = 'El gran formato de 120 × 120 cm reduce las juntas al mínimo, da continuidad al suelo y hace que la estancia parezca más amplia.'
  '75x150'  = 'La pieza de 75 × 150 cm es un gran formato rectangular muy elegante, con pocas juntas y una lectura del material muy natural.'
  '100x100' = 'El formato 100 × 100 cm combina la presencia del gran formato con una colocación más manejable.'
  '60x120'  = 'El formato 60 × 120 cm es el más versátil: sirve para suelo y pared y se adapta a cualquier estancia.'
  '30x180'  = 'La lama XL de 30 × 180 cm imita las tablas largas de la tarima natural y alarga visualmente el espacio.'
  '30x150'  = 'La lama de 30 × 150 cm reproduce el aspecto de una tarima de madera natural con piezas largas.'
  '23x120'  = 'La lama de 23 × 120 cm es el formato clásico de la tarima, fácil de colocar en recto, a la inglesa o en espiga.'
  '60x90'   = 'La pieza de 60 × 90 cm en 2 cm de grosor está pensada para terrazas, jardines y playas de piscina.'
  '120x280' = 'La placa de 120 × 280 cm y solo 6 mm de grosor permite revestir encimeras, frentes de cocina, paredes y muebles casi sin juntas.'
}

$catDefs = @(
  @{ slug = 'suelos-efecto-marmol'; nombre = 'Efecto mármol'; h1 = 'Suelos porcelánicos <em>efecto mármol</em>'
     title = 'Suelos porcelánicos efecto mármol en Valencia | Subterráneo Group'
     desc = 'Porcelánico efecto mármol Calacatta, Carrara y mármoles cálidos y negros, en pulido, satinado y mate. Gran formato 120x120 y 75x150. Presupuesto en 24 h.'
     intro = 'La elegancia del mármol natural sin su mantenimiento: Calacatta, Carrara, mármoles cálidos y negros en porcelánico de gran formato.'
     seo = @('El porcelánico efecto mármol reproduce con mucho detalle las vetas de los mármoles más conocidos, como el Calacatta o el Carrara, pero sin sus inconvenientes: no se mancha, no necesita pulirse y aguanta el uso diario de una casa.', 'En acabado pulido da un brillo de espejo que multiplica la luz; en satinado o mate es más discreto y fácil de mantener. En formatos grandes como 120 × 120 o 75 × 150 cm las juntas casi desaparecen y el suelo parece de una sola pieza.')
     f = { param($p) $p.efecto -eq 'marmol' -and $p.linea -ne 'xlim' } }
  @{ slug = 'suelos-efecto-piedra'; nombre = 'Efecto piedra'; h1 = 'Suelos porcelánicos <em>efecto piedra</em>'
     title = 'Suelos porcelánicos efecto piedra natural | Subterráneo Group'
     desc = 'Porcelánico efecto piedra caliza, arenisca y piedra natural en tonos arena, marfil y greige. Gran formato y acabados mate, lappato y pulido. Pide presupuesto.'
     intro = 'Calizas, areniscas y piedras naturales en tonos arena, marfil y greige: la tendencia más cálida para suelos modernos.'
     seo = @('Los suelos efecto piedra son de los más buscados para reformas actuales: aportan calidez, combinan con madera y textiles naturales y no pasan de moda.', 'Trabajamos piedras calizas, areniscas y piedras con relieve en grandes formatos, con acabados mate, lappato y pulido para que elijas el nivel de brillo de tu suelo.')
     f = { param($p) $p.efecto -eq 'piedra' -and $p.linea -ne 'xlim' } }
  @{ slug = 'suelo-porcelanico-imitacion-madera'; nombre = 'Imitación madera'; h1 = 'Suelo porcelánico <em>imitación madera</em>'
     title = 'Suelo porcelánico imitación madera: roble y lama XL | Subterráneo'
     desc = 'Porcelánico imitación madera en roble, haya y tonos miel, con lamas de hasta 180 cm. También antideslizante para baños y terrazas. Pide presupuesto.'
     intro = 'La calidez de la tarima de madera con la resistencia del porcelánico: roble, haya y tonos miel, en lamas de hasta 180 cm.'
     seo = @('El porcelánico imitación madera es la opción más demandada para salones y dormitorios: tiene el aspecto de la tarima natural pero no se raya, no le afecta el agua y es compatible con suelo radiante.', 'Las lamas largas, como la de 30 × 180 cm, reproducen tablas de madera de gran tamaño; las versiones antideslizantes permiten llevar el mismo suelo al baño o a la terraza.')
     f = { param($p) $p.efecto -eq 'madera' } }
  @{ slug = 'suelos-efecto-cemento'; nombre = 'Efecto cemento'; h1 = 'Suelos porcelánicos <em>efecto cemento</em>'
     title = 'Suelos porcelánicos efecto cemento y microcemento | Subterráneo'
     desc = 'Porcelánico efecto cemento en tonos marfil, beige, perla y greige, en mate, lappato y pulido. La estética del microcemento sin sus fisuras. Pide presupuesto.'
     intro = 'La estética continua del microcemento sin fisuras ni mantenimiento, en tonos marfil, beige, perla y greige.'
     seo = @('El efecto cemento es la base de los interiores minimalistas: superficies lisas y continuas que dejan todo el protagonismo a la luz y al mobiliario.', 'En porcelánico evitas las fisuras y el mantenimiento del microcemento, y en formatos de 100 × 100 o 120 × 120 cm consigues un suelo casi sin juntas.')
     f = { param($p) $p.efecto -eq 'cemento' -and $p.linea -ne 'xlim' } }
  @{ slug = 'suelos-terrazo'; nombre = 'Terrazo'; h1 = 'Suelos porcelánicos <em>terrazo</em>'
     title = 'Suelos porcelánicos terrazo moderno | Subterráneo Group'
     desc = 'Porcelánico terrazo con fragmentos minerales sobre fondos beige y perla, en formato 60x120. El clásico terrazo, renovado y sin mantenimiento. Pide presupuesto.'
     intro = 'El terrazo vuelve con fuerza: fragmentos minerales sobre fondos claros, con aire artesanal y contemporáneo.'
     seo = @('El terrazo vive un resurgir en el diseño de interiores: aporta textura y personalidad a baños, cocinas y zonas de paso.', 'En porcelánico mantiene la estética del terrazo tradicional sin necesidad de pulidos ni tratamientos.')
     f = { param($p) $p.efecto -eq 'terrazo' } }
  @{ slug = 'suelos-exterior-antideslizantes'; nombre = 'Exterior y piscina'; h1 = 'Suelos de <em>exterior antideslizantes</em>'
     title = 'Suelos de exterior antideslizantes para terraza y piscina'
     desc = 'Porcelánico antideslizante C3 para terrazas, jardines y piscinas, incluido 2 cm de grosor. A juego con los suelos de interior. Presupuesto con colocación.'
     intro = 'Porcelánico antideslizante para terrazas, jardines y piscinas, con piezas de 2 cm de grosor y a juego con los suelos de interior.'
     seo = @('En exterior el suelo tiene que ser seguro y resistente: estos porcelánicos tienen clase antideslizante C3, soportan heladas y el sol del Mediterráneo y no pierden color.', 'Muchas series tienen la misma estética en interior y exterior, así el salón continúa hacia la terraza sin cambio de suelo. Las piezas de 2 cm se pueden colocar también en seco sobre grava o césped.')
     f = { param($p) $p.uso -in @('exterior', 'antid', 'inout') } }
  @{ slug = 'porcelanico-pulido'; nombre = 'Porcelánico pulido'; h1 = 'Porcelánico <em>pulido</em> de alto brillo'
     title = 'Porcelánico pulido de alto brillo: mármol y piedra | Subterráneo'
     desc = 'Suelos de porcelánico pulido con brillo espejo: mármoles Calacatta, Carrara, mármoles negros y piedras, en 120x120, 100x100, 75x150 y 60x120. Pide presupuesto.'
     intro = 'Brillo espejo para espacios de lujo: mármoles y piedras en porcelánico pulido de gran formato.'
     seo = @('El porcelánico pulido recibe un tratamiento mecánico que deja la superficie lisa y brillante como un espejo: multiplica la luz y da a la estancia un aire de hotel de lujo.', 'Es ideal para salones, recibidores y cocinas abiertas. Para baños y zonas húmedas recomendamos un acabado satinado o mate.')
     f = { param($p) $p.acabado -like 'Pulido*' -and $p.linea -ne 'xlim' } }
  @{ slug = 'porcelanico-gran-formato'; nombre = 'Gran formato'; h1 = 'Porcelánico de <em>gran formato</em>'
     title = 'Porcelánico de gran formato: 120x120, 75x150 y 100x100'
     desc = 'Suelos porcelánicos de gran formato: 120x120, 75x150, 100x100 y lamas de 180 cm. Menos juntas y más amplitud. Efecto mármol, piedra, cemento y madera.'
     intro = 'Piezas de 120 × 120, 75 × 150 y 100 × 100 cm y lamas de 180 cm: menos juntas, más amplitud.'
     seo = @('El gran formato es la tendencia más clara en suelos: al reducir el número de juntas el pavimento se ve continuo y la estancia parece más grande.', 'Requiere una colocación cuidadosa, con base bien nivelada y herramientas específicas: nuestro equipo se encarga del suministro y de la instalación.')
     f = { param($p) $p.formato -in @('120x120', '75x150', '100x100', '30x180') -and $p.linea -ne 'xlim' } }
  @{ slug = 'placas-porcelanicas-xlim'; nombre = 'Placas XLIM'; h1 = 'Placas porcelánicas <em>XLIM 120 × 280</em>'
     title = 'Placas porcelánicas XLIM 120x280 para encimeras y paredes'
     desc = 'Placas porcelánicas XLIM de 120x280 cm y 6 mm para encimeras de cocina, baños, paredes sin juntas y mobiliario. Mármoles y piedras. Pide presupuesto.'
     intro = 'Placas de 120 × 280 cm y solo 6 mm para encimeras, paredes sin juntas y mobiliario.'
     seo = @('Las placas XLIM permiten revestir una pared entera o una encimera con muy pocas juntas. Son ligeras, resistentes al calor y a las manchas.', 'Combínalas con el suelo de la misma serie para conseguir un acabado continuo en cocinas y baños.')
     f = { param($p) $p.linea -eq 'xlim' } }
)

# ── Enriquecer productos ──
foreach ($p in $prods) {
  $k = "$($p.linea)|$($p.formato)"
  $pk = $pack[$k]
  $p | Add-Member -NotePropertyName esp -NotePropertyValue $pk[0]
  $p | Add-Member -NotePropertyName piezas -NotePropertyValue $pk[1]
  $p | Add-Member -NotePropertyName m2caja -NotePropertyValue $pk[2]
  $p | Add-Member -NotePropertyName kg -NotePropertyValue $pk[3]
  $p | Add-Member -NotePropertyName real -NotePropertyValue $real[$k]
  $p | Add-Member -NotePropertyName unidad -NotePropertyValue $(if ($p.linea -eq 'xlim') { 'placa' } else { 'caja' })
  $p | Add-Member -NotePropertyName precio -NotePropertyValue $(if ($precios.ContainsKey($p.slug)) { $precios[$p.slug] } else { $null })
  $p | Add-Member -NotePropertyName fotos -NotePropertyValue @($p.imgs -split ',')
  $dims = $p.formato -split 'x'
  $p | Add-Member -NotePropertyName area -NotePropertyValue ([int]$dims[0] * [int]$dims[1])
  $p | Add-Member -NotePropertyName url -NotePropertyValue "/materiales/$($p.slug)/"
  $acab = switch -Wildcard ($p.acabado) { 'Pulido*' { 'pulido' } 'Satinado' { 'satinado' } 'Lappato' { 'lappato' } 'Antideslizante*' { 'antideslizante' } 'Mate INOUT' { 'antideslizante' } default { 'mate' } }
  $p | Add-Member -NotePropertyName acabKey -NotePropertyValue $acab
  $badge = if ($p.linea -eq 'xlim') { @('Placa XLIM', 'm-badge--dark') }
    elseif ($p.uso -eq 'exterior') { @('Exterior 2 cm', 'm-badge--green') }
    elseif ($p.uso -in @('antid', 'inout')) { @('Antideslizante', 'm-badge--green') }
    elseif ($p.catalogo -like 'Novedades*') { @('Novedad 2026', '') }
    elseif ($p.acabado -eq 'Pulido') { @('Premium', '') }
    elseif ($p.acabado -eq 'Lappato') { @('Lappato', 'm-badge--dark') }
    elseif ($p.formato -eq '30x180') { @('Lama XL', 'm-badge--dark') }
    else { @() }
  $p | Add-Member -NotePropertyName badge -NotePropertyValue $badge
}

# ── Fragmentos comunes (cabecera, menú y pie en _web/plantilla.ps1) ──
$navHtml = Get-Nav 'materiales' $true
$footerHtml = Get-Footer $true
function PriceHtml($p) {
  if ($p.precio) { "<div class=`"m-price`"><b>$(Dec $p.precio) €</b><span>/m²</span></div>" }
  else { '<div class="m-price m-price--ask"><b>Precio a consultar</b></div>' }
}
function Card($p, [int] $idx) {
  $lazy = if ($idx -lt 3) { 'eager' } else { 'lazy' }
  $badge = if ($p.badge.Count) { "<span class=`"m-badge $($p.badge[1])`">$($p.badge[0])</span>" } else { '' }
  $usoKey = if ($p.uso -in @('exterior', 'antid', 'inout')) { "$($p.uso) exterior" } else { $p.uso }
  $precioAttr = if ($p.precio) { $p.precio.ToString($inv) } else { '' }
  $unidadTxt = if ($p.unidad -eq 'placa') { "Placa de $((Dec $p.m2caja)) m²" } else { "Caja de $((Dec $p.m2caja)) m²" }
@"
          <a class="m-card" href="$($p.url)" data-efecto="$($p.efecto)" data-acabado="$($p.acabKey)" data-formato="$($p.formato)" data-uso="$usoKey" data-area="$($p.area)" data-orden="$($p.n)" data-precio="$precioAttr">
            <div class="m-card__img"><img src="/materiales/img/m/$($p.fotos[0]).jpg" alt="$(Esc $pies[$p.fotos[0]])" width="560" height="476" loading="$lazy" decoding="async">$badge</div>
            <div class="m-card__body">
              <span class="m-card__brand">STN Cerámica · $($efectoCorto[$p.efecto])</span>
              <h3 class="m-card__name">$(Esc $p.nombre)</h3>
              <span class="m-card__spec">$(Fmt $p.formato) cm · $(Esc $p.acabado)</span>
              $(PriceHtml $p)
              <span class="m-card__box">$unidadTxt</span>
              <span class="m-card__cta m-btn m-btn--gold">Calcular presupuesto</span>
            </div>
          </a>
"@
}

function Listing($list, $cfg) {
  $count = { param($f) @($list | Where-Object $f).Count }
  $fGroup = {
    param($title, $name, $opts)
    $rows = foreach ($o in $opts) {
      $n = @($list | Where-Object { (& $o[2] $_) }).Count
      if ($n) { "<label><input type=`"checkbox`" name=`"$name`" value=`"$($o[0])`"> $($o[1]) <small>$n</small></label>" }
    }
    if ($rows) { "<div class=`"m-fgroup`"><h2>$title</h2>$($rows -join '')</div>" }
  }
  $efectos = foreach ($e in 'marmol', 'piedra', 'madera', 'cemento', 'terrazo') { , @($e, $efectoCorto[$e], [scriptblock]::Create("param(`$p) `$p.efecto -eq '$e'")) }
  $acabados = foreach ($a in @(@('pulido', 'Pulido brillo'), @('satinado', 'Satinado'), @('lappato', 'Lappato'), @('mate', 'Mate'), @('antideslizante', 'Antideslizante'))) { , @($a[0], $a[1], [scriptblock]::Create("param(`$p) `$p.acabKey -eq '$($a[0])'")) }
  $formatos = foreach ($f in '120x280', '120x120', '75x150', '100x100', '60x120', '60x90', '30x180', '30x150', '23x120') { , @($f, "$(Fmt $f) cm", [scriptblock]::Create("param(`$p) `$p.formato -eq '$f'")) }
  $usos = @(, @('interior', 'Interior', { param($p) $p.uso -eq 'interior' })) + @(, @('exterior', 'Exterior y piscina', { param($p) $p.uso -in @('exterior', 'antid', 'inout') })) + @(, @('xlim', 'Encimeras y paredes', { param($p) $p.uso -eq 'xlim' }))
  $filters = @(
    (& $fGroup 'Aspecto' 'efecto' $efectos),
    (& $fGroup 'Acabado' 'acabado' $acabados),
    (& $fGroup 'Formato' 'formato' $formatos),
    (& $fGroup 'Uso' 'uso' $usos)
  ) -join "`n"
  $chips = (@(, @('Todos', '/materiales/')) + @($catDefs | ForEach-Object { , @($_.nombre, "/materiales/$($_.slug)/") }) | ForEach-Object {
    $on = if ($_[1] -eq $cfg.url) { ' is-on' } else { '' }
    "<a class=`"m-chip$on`" href=`"$($_[1])`">$($_[0])</a>"
  }) -join ''
  $i = 0
  $cards = ($list | ForEach-Object { Card $_ ($i++) }) -join "`n"
  $seoP = ($cfg.seo | ForEach-Object { "<p>$_</p>" }) -join ''
  $catLinks = ($catDefs | Where-Object { "/materiales/$($_.slug)/" -ne $cfg.url } | ForEach-Object { "<li><a href=`"/materiales/$($_.slug)/`">$($_.h1 -replace '<[^>]+>', '') →</a></li>" }) -join ''
  $crumbItems = @(, @('Inicio', '/')) + $cfg.crumbs
  $ld = Json @{ '@context' = 'https://schema.org'; '@graph' = @(
      (CrumbsLd $crumbItems),
      @{ '@type' = 'CollectionPage'; name = $cfg.titleShort; description = $cfg.desc; url = "$SITE$($cfg.url)"
         mainEntity = @{ '@type' = 'ItemList'; numberOfItems = $list.Count; itemListElement = @($list | ForEach-Object -Begin { $k = 0 } -Process { $k++; @{ '@type' = 'ListItem'; position = $k; url = "$SITE$($_.url)"; name = "$($_.nombre) $($_.formato)" } }) } }
    ) }
  $html = (Head $cfg.title $cfg.desc $cfg.url "/materiales/img/$($list[0].fotos[0]).jpg" $ld) + $navHtml + @"
  <main class="m-page">
    <div class="m-wrap">
      $(Crumbs $crumbItems)
      <header class="m-hero">
        <div>
          <h1>$($cfg.h1)</h1>
          <p>$(Esc $cfg.intro)</p>
        </div>
        <div class="m-usp">
          <div><b>$($list.Count)</b><span>Referencias</span></div>
          <div><b>24 h</b><span>Presupuesto</span></div>
          <div><b>360°</b><span>Suministro y obra</span></div>
        </div>
      </header>
      <nav class="m-chips" aria-label="Categorías de suelos">$chips</nav>
      <div class="m-shop">
        <aside class="m-filters" aria-label="Filtros">
$filters
        </aside>
        <section aria-label="Productos">
          <div class="m-toolbar">
            <button type="button" class="m-chip m-filters__toggle">Filtrar</button>
            <span id="m-count">$($list.Count) productos</span>
            <select id="m-sort" aria-label="Ordenar"><option value="orden">Destacados</option><option value="formato">Formato más grande</option><option value="precio">Precio: menor a mayor</option></select>
          </div>
          <div class="m-grid" id="m-grid">
$cards
          </div>
        </section>
      </div>
      <section class="m-seo">
        <div><h2>$(Esc $cfg.seoTitle)</h2>$seoP</div>
        <div><h2>Más tipos de suelo</h2><ul>$catLinks</ul></div>
      </section>
    </div>
  </main>
"@ + $footerHtml
  Write-Page ($cfg.url.TrimStart('/') + 'index.html') $html
}

# ── Listado general y categorías ──
Listing $prods @{
  url = '/materiales/'; titleShort = 'Suelos porcelánicos'
  title = 'Suelos porcelánicos en Valencia: mármol, madera y gran formato'
  desc = 'Más de 100 suelos porcelánicos de STN Cerámica: mármol pulido, imitación madera, piedra, cemento, terrazo y exterior. Calcula los m² y pide presupuesto.'
  h1 = 'Suelos <em>porcelánicos</em>'
  intro = 'Porcelánico de primera calidad fabricado en Castellón. Calcula los metros que necesitas y te enviamos el presupuesto, con la colocación incluida si la quieres.'
  seoTitle = 'Suministro e instalación de suelos en Valencia'
  seo = @('En Subterráneo Group seleccionamos suelos porcelánicos de STN Cerámica, uno de los mayores fabricantes de Europa, y te los suministramos para tu reforma en Torrent, Valencia y toda la Comunidad Valenciana.', 'Elige el suelo, calcula los metros cuadrados y añádelo a tu presupuesto: te respondemos en menos de 24 horas con el precio del material y, si lo necesitas, de la colocación por nuestro equipo.')
  crumbs = @(, @('Materiales', $null))
}
foreach ($c in $catDefs) {
  $list = @($prods | Where-Object { & $c.f $_ })
  Listing $list @{
    url = "/materiales/$($c.slug)/"; titleShort = ($c.h1 -replace '<[^>]+>', '')
    title = $c.title; desc = $c.desc; h1 = $c.h1; intro = $c.intro
    seoTitle = ($c.h1 -replace '<[^>]+>', ''); seo = $c.seo
    crumbs = @(@('Materiales', '/materiales/'), @($c.nombre, $null))
  }
}

# ── Fichas de producto ──
foreach ($p in $prods) {
  $cat = $catDefs | Where-Object { & $_.f $p } | Select-Object -First 1
  $crumbItems = @(@('Inicio', '/'), @('Materiales', '/materiales/'), @($cat.nombre, "/materiales/$($cat.slug)/"), @("$($p.nombre) $($p.formato)", $null))
  $efTxt = $efectoTxt[$p.efecto]
  $tipo = if ($p.linea -eq 'xlim') { 'Placa porcelánica' } else { 'Porcelánico' }
  # Título: lo bastante corto para que Google no lo corte (marca solo si cabe)
  $efCap = $efTxt.Substring(0, 1).ToUpper() + $efTxt.Substring(1)
  $tBase = "$($p.nombre) $($p.formato) · $efCap"
  $title = if (("$tBase | Subterráneo").Length -le 62) { "$tBase | Subterráneo" } else { $tBase }
  # Descripción: 120-158 caracteres
  $dBase = "$($p.nombre) en $(Fmt $p.formato) cm: $($tipo.ToLower()) $efTxt, acabado $($p.acabado.ToLower())."
  $desc = "$dBase Calcula las $($p.unidad)s que necesitas y pide presupuesto con colocación."
  if ($desc.Length -gt 158) { $desc = "$dBase Pide presupuesto con colocación en 24 h." }
  if ($desc.Length -gt 158) { $desc = "$dBase Presupuesto en 24 h." }
  $imgsAbs = @($p.fotos | ForEach-Object { "$SITE/materiales/img/$_.jpg" })
  $product = [ordered]@{
    '@type' = 'Product'; name = "$($p.nombre) $($p.formato) cm"; image = $imgsAbs; description = $p.desc
    sku = $(if ($p.codigo) { "STN-$($p.codigo)-$($p.formato)" } else { "STN-$($p.slug)" })
    brand = @{ '@type' = 'Brand'; name = 'STN Cerámica' }
    category = "Suelos porcelánicos > $($cat.nombre)"; material = 'Gres porcelánico'
    additionalProperty = @(
      @{ '@type' = 'PropertyValue'; name = 'Formato'; value = "$(Fmt $p.formato) cm" },
      @{ '@type' = 'PropertyValue'; name = 'Acabado'; value = $p.acabado },
      @{ '@type' = 'PropertyValue'; name = 'Espesor'; value = "$($p.esp.ToString($inv)) mm" }
    )
    url = "$SITE$($p.url)"
  }
  if ($p.precio) {
    $pr = $p.precio.ToString('0.00', $inv)
    $product.offers = @{ '@type' = 'Offer'; url = "$SITE$($p.url)"; priceCurrency = 'EUR'; price = $pr
      priceSpecification = @{ '@type' = 'UnitPriceSpecification'; price = $pr; priceCurrency = 'EUR'; unitCode = 'MTK'; valueAddedTaxIncluded = $true }
      seller = @{ '@type' = 'Organization'; name = 'Subterráneo Group S.L' } }
  }
  # Google exige precio (offers) en los datos de producto: sin precio, solo migas de pan
  $graph = if ($p.precio) { @((CrumbsLd $crumbItems), $product) } else { @(, (CrumbsLd $crumbItems)) }
  $ld = Json @{ '@context' = 'https://schema.org'; '@graph' = $graph }

  $thumbs = ''
  if ($p.fotos.Count -gt 1) {
    $j = 0
    $thumbs = '<div class="m-thumbs">' + (($p.fotos | ForEach-Object { $on = if ($j++ -eq 0) { ' class="is-on"' } else { '' }; "<button type=`"button`"$on data-src=`"/materiales/img/$_.jpg`" data-cap=`"$(Esc $pies[$_])`" aria-label=`"Ver foto: $(Esc $pies[$_])`"><img src=`"/materiales/img/m/$_.jpg`" alt=`"`" width=`"140`" height=`"140`" loading=`"lazy`"></button>" }) -join '') + '</div>'
  }
  $siblings = @($prods | Where-Object { $_.serie -eq $p.serie -and $_.slug -ne $p.slug })
  $formatsHtml = "<span>$(Fmt $p.formato) cm<small>$(Esc $p.acabado) · $(Esc $p.color)</small></span>" + (($siblings | ForEach-Object { "<a href=`"$($_.url)`">$(Fmt $_.formato) cm<small>$(Esc $_.acabado) · $(Esc $_.color)</small></a>" }) -join '')
  $priceBlock = if ($p.precio) {
    "<div class=`"m-pricebox__p`">$(Dec $p.precio) € <small>/m²</small></div><div class=`"m-pricebox__sub`">$((Get-Culture).TextInfo.ToTitleCase($p.unidad)) de $(Dec $p.m2caja) m² · $(Dec ($p.precio * $p.m2caja)) € por $($p.unidad)</div>"
  } else {
    "<div class=`"m-pricebox__p is-ask`">Precio a consultar</div><div class=`"m-pricebox__sub`">$((Get-Culture).TextInfo.ToTitleCase($p.unidad)) de $(Dec $p.m2caja) m² · te enviamos el precio en menos de 24 h</div>"
  }
  $taxNote = if ($p.precio) { 'IVA incluido<br>Precio por m²' } else { 'Presupuesto<br>sin compromiso' }
  $specRows = @(
    @('Material', $(if ($p.linea -eq 'xlim') { 'Placa de gres porcelánico rectificado' } elseif ($p.linea -eq 'general-nr') { 'Gres porcelánico (no rectificado)' } else { 'Gres porcelánico rectificado' })),
    @('Aspecto', ($efTxt.Substring(0, 1).ToUpper() + $efTxt.Substring(1))),
    @('Acabado', $p.acabado),
    @('Formato nominal', "$(Fmt $p.formato) cm")
  )
  if ($p.real) { $specRows += , @('Medida real de fabricación', "$($p.real) cm") }
  $specRows += @(
    @('Espesor', "$($p.esp.ToString($inv).Replace('.', ',')) mm"),
    @("Piezas por $($p.unidad)", "$($p.piezas)"),
    @("m² por $($p.unidad)", "$(Dec $p.m2caja) m²")
  )
  if ($p.kg) { $specRows += , @("Peso por $($p.unidad)", "$((Dec $p.kg)) kg") }
  if ($p.tono) { $specRows += , @('Variación de tono', $p.tono) }
  if ($p.uso -in @('exterior', 'antid')) { $specRows += , @('Antideslizante', 'Clase C3 (R11)') }
  if ($p.uso -eq 'inout') { $specRows += , @('Antideslizante', 'Clase C3 (R10)') }
  $specRows += , @('Uso recomendado', $usoTxt[$p.uso])
  $specRows += , @('Colección', "$($p.serie) · $($p.catalogo)")
  if ($p.codigo) { $specRows += , @('Código STN', $p.codigo) }
  $specRows += , @('Fabricante', 'STN Cerámica (Castellón)')
  $specs = ($specRows | ForEach-Object { "<tr><th scope=`"row`">$(Esc $_[0])</th><td>$(Esc $_[1])</td></tr>" }) -join ''

  $related = @($prods | Where-Object { $_.efecto -eq $p.efecto -and $_.serie -ne $p.serie } | Sort-Object { [math]::Abs([int]$_.n - [int]$p.n) } | Select-Object -First 4)
  $k = 3
  $relatedHtml = ($related | ForEach-Object { Card $_ ($k++) }) -join "`n"
  $dataJson = Json ([ordered]@{ slug = $p.slug; nombre = $p.nombre; formato = $p.formato; m2caja = $p.m2caja; precio = $p.precio; unidad = $p.unidad; img = "/materiales/img/m/$($p.fotos[0]).jpg" })
  $mainCap = $pies[$p.fotos[0]]
  $alsoNote = if ($mainCap -notmatch [regex]::Escape($p.color)) { '<p class="m-pricebox__sub">Las fotos muestran otros colores de la misma serie.</p>' } else { '' }

  $html = (Head $title $desc $p.url "/materiales/img/$($p.fotos[0]).jpg" $ld) + $navHtml + @"
  <main class="m-page">
    <div class="m-wrap">
      $(Crumbs $crumbItems)
      <article>
        <section class="m-pdp">
          <div>
            <figure class="m-gal__main">
              <img id="m-main-img" src="/materiales/img/$($p.fotos[0]).jpg" alt="$(Esc $mainCap)" width="1200" height="1020" fetchpriority="high">
              <figcaption id="m-main-cap">$(Esc $mainCap)</figcaption>
            </figure>
            $thumbs
          </div>
          <div class="m-info">
            <span class="m-info__brand">STN Cerámica · $(Esc $p.catalogo)</span>
            <h1>$(Esc $p.nombre) <em>$(Fmt $p.formato)</em></h1>
            <span class="m-info__ref">Ref. $(Esc $p.serie) $(Esc $p.color) $(Fmt $p.formato) cm$(if ($p.codigo) { " · Código STN $($p.codigo)" })</span>
            <ul class="m-tags">
              <li>$(Esc ($efTxt.Substring(0, 1).ToUpper() + $efTxt.Substring(1)))</li>
              <li>$(Esc $p.acabado)</li>
              <li>$(Esc $usoTxt[$p.uso])</li>
            </ul>
            <div class="m-pricebox">
              <div>$priceBlock</div>
              <div class="m-pricebox__tax">$taxNote</div>
            </div>
            $alsoNote
            <p class="m-label">Formatos y acabados de la serie $(Esc $p.serie)</p>
            <div class="m-formats">$formatsHtml</div>
            <p class="m-label">¿Cuántos metros necesitas?</p>
            <div class="m-calc">
              <div class="m-calc__row">
                <label for="m-m2">Superficie a cubrir</label>
                <div class="m-stepper">
                  <button type="button" data-step="-1" aria-label="Menos metros">−</button>
                  <input id="m-m2" type="number" inputmode="decimal" min="1" step="1" value="25">
                  <span>m²</span>
                  <button type="button" data-step="1" aria-label="Más metros">+</button>
                </div>
              </div>
              <label class="m-check"><input type="checkbox" id="m-extra" checked> Añadir un 10 % por cortes y reserva (recomendado)</label>
              <label class="m-check"><input type="checkbox" id="m-inst-pdp" checked> Quiero también presupuesto de colocación</label>
              <div class="m-calc__out">
                <div><b id="m-out-cajas">0</b><span>$((Get-Culture).TextInfo.ToTitleCase($p.unidad))s</span></div>
                <div><b id="m-out-m2">0</b><span>m² totales</span></div>
                <div><b id="m-out-total">—</b><span>Material aprox.</span></div>
              </div>
            </div>
            <div class="m-actions">
              <button type="button" class="m-btn m-btn--gold" data-add>Añadir a mi presupuesto</button>
              <button type="button" class="m-btn m-btn--wp" data-wp-now>Pedir presupuesto por WhatsApp</button>
            </div>
            <div class="m-trust">
              <div><b>Respuesta en 24 h</b>Presupuesto cerrado y sin compromiso</div>
              <div><b>Entrega en obra</b>Torrent, Valencia y Comunidad Valenciana</div>
              <div><b>Colocación</b>Nuestro equipo lo instala por ti</div>
            </div>
          </div>
        </section>
        <section class="m-details">
          <div>
            <h2>Sobre este suelo</h2>
            <p>$(Esc $p.desc)</p>
            <p>$(Esc $acabadoTxt[$p.acabado]) $(Esc $formatoTxt[$p.formato])</p>
            <p>En Subterráneo Group te lo suministramos y, si quieres, lo colocamos. Calcula los metros, añádelo a tu presupuesto y te respondemos en menos de 24 horas. Trabajamos en Torrent, Valencia y toda la Comunidad Valenciana.</p>
          </div>
          <div>
            <h2>Características técnicas</h2>
            <table class="m-specs">$specs</table>
          </div>
        </section>
      </article>
      <section class="m-related">
        <h2>Otros suelos $(Esc $efTxt)</h2>
        <div class="m-grid">
$relatedHtml
        </div>
      </section>
    </div>
  </main>
  <script type="application/json" id="m-product">$dataJson</script>
"@ + $footerHtml
  Write-Page "materiales/$($p.slug)/index.html" $html
}

# ── Sitemap (de toda la web) ──
$mapa = & (Join-Path $root '_web\sitemap.ps1') -Root $root

$conPrecio = @($prods | Where-Object { $_.precio }).Count
"Generadas: 1 listado, $($catDefs.Count) categorías y $($prods.Count) fichas. $mapa. Productos con precio: $conPrecio de $($prods.Count)."
