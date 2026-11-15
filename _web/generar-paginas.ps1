# Genera las páginas de servicio (/reformas/) y el blog (/blog/), y actualiza el sitemap.
# Uso:  powershell -ExecutionPolicy Bypass -File _web\generar-paginas.ps1
$ErrorActionPreference = 'Stop'
$root = Split-Path (Split-Path $MyInvocation.MyCommand.Path)
$SITE = 'https://subterraneogroup.com'
$utf8 = New-Object Text.UTF8Encoding $false
. (Join-Path $root '_web\plantilla.ps1')
$empresa = @{ '@id' = "$SITE/#empresa" }
$zonas = @(@{ '@type' = 'City'; name = 'Torrent' }, @{ '@type' = 'City'; name = 'Valencia' }, @{ '@type' = 'State'; name = 'Comunidad Valenciana' })
$wa = 'https://wa.me/34638571920?text=Hola%2C%20me%20gustar%C3%ADa%20solicitar%20un%20presupuesto'

$servicios = @(
  @{ slug = 'reformas-integrales-valencia'; nombre = 'Reformas integrales'; servicio = 'Reforma integral de viviendas'
     title = 'Reformas integrales en Valencia y Torrent | Subterráneo Group'
     desc = 'Reforma integral de pisos y casas en Valencia y Torrent: proyecto, licencias, obra y acabados con un solo interlocutor. Presupuesto cerrado en 24 h.'
     h1 = 'Reformas integrales en <em>Valencia y Torrent</em>'
     lead = 'Renovamos tu piso o tu casa de principio a fin: distribución, instalaciones, carpintería y acabados. Te encargas de elegir; nosotros del proyecto, las licencias, los gremios y los plazos.'
     img = '/interior-reforma.jpg'; alt = 'Reforma integral de vivienda en Valencia'
     tile = 'Pisos y casas de principio a fin, con un solo interlocutor.'
     body = @'
<h2>Una reforma, una sola llamada</h2>
<p>En una reforma integral intervienen albañiles, fontaneros, electricistas, carpinteros, pintores y, a menudo, arquitectos y el ayuntamiento. Coordinarlos es lo que más estrés genera. En Subterráneo Group nos encargamos de todo: <strong>proyecto, licencias, ejecución y acabados</strong>, con un responsable de obra que te informa en cada fase.</p>
<h2>Qué incluye una reforma integral</h2>
<ul>
<li><strong>Distribución:</strong> derribo y construcción de tabiques, apertura de cocinas al salón, nuevos baños.</li>
<li><strong>Instalaciones nuevas:</strong> fontanería, saneamiento, electricidad y, si lo necesitas, climatización o suelo radiante.</li>
<li><strong>Suelos y revestimientos:</strong> porcelánico, imitación madera, gran formato o microcemento. Puedes elegirlos en nuestro <a href="/materiales/">catálogo de suelos</a>.</li>
<li><strong>Baño y cocina</strong> completos, con mobiliario a medida.</li>
<li><strong>Carpintería interior y exterior</strong>, pintura y acabados.</li>
<li><strong>Gestión de licencias</strong> y trámites con el ayuntamiento.</li>
</ul>
<h2>Cómo trabajamos</h2>
<ol>
<li><strong>Visita y toma de medidas</strong> sin compromiso.</li>
<li><strong>Presupuesto cerrado y detallado</strong> por partidas, en menos de 24 horas desde la visita.</li>
<li><strong>Elección de materiales</strong>: te asesoramos y te enseñamos muestras.</li>
<li><strong>Planificación</strong> con fechas de inicio y fin.</li>
<li><strong>Ejecución</strong> con un responsable de obra y seguimiento continuo.</li>
<li><strong>Entrega llave en mano</strong> y limpieza final.</li>
</ol>
<div class="c-note"><p>Si la vivienda es tu residencia habitual y tiene más de dos años, la obra puede tributar al <strong>IVA reducido del 10 %</strong> en lugar del 21 %, siempre que los materiales que aporte la empresa no superen el 40 % del total. Te lo indicamos en el presupuesto.</p></div>
<h2>Dónde trabajamos</h2>
<p>Tenemos la base en <a href="/reformas/empresa-reformas-torrent/">Torrent</a> y trabajamos en Valencia y en toda la Comunidad Valenciana. Nuestro personal suma más de 15 años de oficio y hemos realizado más de 20 obras en la zona.</p>
'@
     faq = @(
       @('¿Cuánto tarda una reforma integral de un piso?', 'Depende del tamaño y de lo que se cambie, pero un piso de unos 80-90 m² suele llevar entre 2 y 4 meses. En el presupuesto te damos un plan de obra con fechas.'),
       @('¿Necesito licencia para reformar mi piso?', 'Las reformas interiores que no tocan estructura ni fachada suelen tramitarse con una declaración responsable de obras en el ayuntamiento. Si hay cambios estructurales hace falta proyecto técnico y licencia. Nosotros nos encargamos de los trámites.'),
       @('¿Puedo vivir en casa durante la reforma?', 'En una reforma integral no es recomendable: hay cortes de agua y luz, polvo y ruido. En reformas parciales, como solo un baño, sí suele ser posible.'),
       @('¿El presupuesto es cerrado?', 'Sí. Detallamos cada partida y el precio no cambia salvo que tú decidas modificar algo durante la obra.')
     ) }
  @{ slug = 'reforma-banos-valencia'; nombre = 'Reforma de baños'; servicio = 'Reforma de baños'
     title = 'Reforma de baños en Valencia y Torrent | Subterráneo Group'
     desc = 'Reformamos tu baño en Valencia y Torrent: cambio de bañera por ducha, platos de obra, porcelánico de gran formato y mueble a medida. Presupuesto en 24 h.'
     h1 = 'Reforma de baños en <em>Valencia y Torrent</em>'
     lead = 'Del baño anticuado al baño que quieres: duchas a ras de suelo, porcelánico de gran formato, mueble suspendido y grifería de calidad. Con presupuesto cerrado y plazos claros.'
     img = '/bano-premium.jpg'; alt = 'Baño reformado con ducha de obra y espejo retroiluminado'
     tile = 'Duchas de obra, gran formato y mueble a medida.'
     body = @'
<h2>Lo que más nos piden</h2>
<ul>
<li><strong>Cambiar la bañera por un plato de ducha</strong>, con mampara y, si se puede, ducha a ras de suelo (tipo italiana).</li>
<li><strong>Reforma completa</strong>: nuevas tuberías, desagües, revestimientos, sanitarios y mueble.</li>
<li><strong>Baños con aspecto de hotel</strong>: porcelánico efecto mármol o piedra en gran formato, iluminación indirecta y espejo con luz.</li>
<li><strong>Baños accesibles</strong>, sin escalones y con suelo antideslizante.</li>
</ul>
<figure><img src="/bano-negro-moderno.jpg" alt="Baño moderno con grifería negra" width="900" height="1600" loading="lazy"><figcaption>Uno de nuestros baños terminados.</figcaption></figure>
<h2>Materiales que recomendamos</h2>
<p>Para el baño, el <strong>porcelánico</strong> es la mejor opción: no absorbe agua, no se mancha y aguanta décadas. En la ducha conviene un acabado <strong>mate o antideslizante</strong>; en paredes puedes optar por mármoles pulidos o piedra en <a href="/materiales/porcelanico-gran-formato/">gran formato</a>, que reducen las juntas y facilitan la limpieza. Puedes ver opciones en nuestro <a href="/materiales/suelos-efecto-marmol/">catálogo de suelos efecto mármol</a>.</p>
<h2>Cuánto cuesta reformar un baño</h2>
<p>Depende del tamaño, de si hay que cambiar instalaciones y de los materiales. Hemos recopilado precios orientativos de 2026 en este artículo: <a href="/blog/cuanto-cuesta-reformar-un-bano-en-valencia/">¿cuánto cuesta reformar un baño en Valencia?</a> Para tu caso concreto te damos un presupuesto cerrado y gratuito.</p>
<h2>Cómo trabajamos</h2>
<ol>
<li>Visita, medición y propuesta de distribución.</li>
<li>Presupuesto cerrado por partidas en menos de 24 horas.</li>
<li>Elección de revestimientos, sanitarios y grifería.</li>
<li>Obra con un único equipo coordinado y limpieza final.</li>
</ol>
'@
     faq = @(
       @('¿Cuánto tarda la reforma de un baño?', 'Una reforma completa de un baño estándar suele llevar entre una y tres semanas, según si hay que mover tuberías o fabricar muebles a medida. Cambiar solo la bañera por un plato de ducha puede hacerse en pocos días.'),
       @('¿Se puede cambiar la bañera por ducha sin hacer toda la obra?', 'Sí. Es la reforma más pedida y se hace sin tocar el resto del baño, siempre que el desagüe lo permita.'),
       @('¿Qué suelo es mejor para un baño?', 'Porcelánico mate o antideslizante. Es impermeable, resistente y fácil de limpiar. En imitación madera da calidez sin los problemas de la madera natural con el agua.'),
       @('¿Puedo usar el baño durante la obra?', 'Si es el único baño de la casa, mientras dura la obra no se puede usar. Planificamos los trabajos para que sea el menor tiempo posible.')
     ) }
  @{ slug = 'reforma-cocinas-valencia'; nombre = 'Reforma de cocinas'; servicio = 'Reforma de cocinas'
     title = 'Reforma de cocinas en Valencia y Torrent | Subterráneo Group'
     desc = 'Reforma de cocinas en Valencia y Torrent: mobiliario a medida, encimeras de porcelánico o piedra, cocinas abiertas al salón e instalaciones nuevas. Presupuesto en 24 h.'
     h1 = 'Reforma de cocinas en <em>Valencia y Torrent</em>'
     lead = 'Cocinas funcionales y bonitas: mobiliario a medida, encimeras resistentes, electrodomésticos integrados y, si quieres, abiertas al salón. Nos ocupamos de la obra y del montaje.'
     img = '/cocina-moderna.jpg'; alt = 'Cocina reformada con muebles blancos'
     tile = 'Mobiliario a medida y cocinas abiertas al salón.'
     body = @'
<h2>Qué hacemos en una reforma de cocina</h2>
<ul>
<li><strong>Nueva distribución</strong>: cocinas en L, en U, con isla o abiertas al salón (si el tabique no es estructural).</li>
<li><strong>Instalaciones</strong>: fontanería, desagües, electricidad con circuitos independientes para horno y placa, y extracción de humos.</li>
<li><strong>Mobiliario a medida</strong> con herrajes de calidad y aprovechamiento de cada rincón.</li>
<li><strong>Encimeras y frentes</strong> de porcelánico, cuarzo o piedra natural.</li>
<li><strong>Suelo y paredes</strong>: porcelánico resistente a manchas y golpes.</li>
</ul>
<h2>Encimeras y frentes de porcelánico</h2>
<p>Las <a href="/materiales/placas-porcelanicas-xlim/">placas porcelánicas de 120 × 280 cm</a> permiten encimeras y frentes casi sin juntas, resistentes al calor y a las manchas, con aspecto de mármol o piedra. Combinadas con el suelo de la misma serie, consiguen un acabado continuo muy elegante.</p>
<h2>Suelos para cocina</h2>
<p>En la cocina recomendamos porcelánico <strong>mate o satinado</strong>: aguanta caídas de agua y aceite y se limpia con facilidad. Si la cocina se abre al salón, usar el mismo suelo en ambos espacios amplía visualmente la casa. Mira las opciones de <a href="/materiales/suelos-efecto-piedra/">efecto piedra</a> y <a href="/materiales/suelo-porcelanico-imitacion-madera/">imitación madera</a>.</p>
<h2>Cómo trabajamos</h2>
<ol>
<li>Visita y diseño de la distribución contigo.</li>
<li>Presupuesto cerrado por partidas en menos de 24 horas.</li>
<li>Obra, instalaciones y montaje de mobiliario por un mismo equipo.</li>
<li>Entrega con todo funcionando y limpieza final.</li>
</ol>
'@
     faq = @(
       @('¿Cuánto tarda la reforma de una cocina?', 'Entre dos y cinco semanas según la obra. El mobiliario a medida suele marcar el plazo, por eso lo encargamos al principio.'),
       @('¿Puedo abrir la cocina al salón?', 'Sí, si el tabique no es estructural. Lo comprobamos en la visita; si es de carga, se puede abrir con un refuerzo calculado por un técnico.'),
       @('¿Qué encimera es más resistente?', 'El porcelánico es de las más resistentes al calor, a los arañazos y a las manchas. El cuarzo y la piedra natural también son buenas opciones con distinto mantenimiento.')
     ) }
  @{ slug = 'rehabilitacion-fachadas-valencia'; nombre = 'Rehabilitación de fachadas'; servicio = 'Rehabilitación de fachadas'
     title = 'Rehabilitación de fachadas en Valencia y Torrent | Subterráneo Group'
     desc = 'Rehabilitación de fachadas en Valencia y Torrent: reparación, impermeabilización, aislamiento térmico y acabados exteriores para viviendas y comunidades.'
     h1 = 'Rehabilitación de fachadas en <em>Valencia y Torrent</em>'
     lead = 'Reparamos, impermeabilizamos y renovamos fachadas de casas y edificios: grietas, humedades, desprendimientos y mejora del aislamiento, con acabados que aguantan el sol y la humedad del Mediterráneo.'
     img = '/obra-exterior.jpg'; alt = 'Fachada rehabilitada'
     tile = 'Grietas, humedades, impermeabilización y aislamiento.'
     body = @'
<h2>Problemas que resolvemos</h2>
<ul>
<li><strong>Grietas y fisuras</strong> en el revestimiento.</li>
<li><strong>Humedades</strong> por filtración o capilaridad.</li>
<li><strong>Desprendimientos</strong> de enfoscado, pintura o cerámica.</li>
<li><strong>Pérdida de aislamiento</strong>: casas frías en invierno y calurosas en verano.</li>
</ul>
<h2>Qué incluye la rehabilitación</h2>
<ul>
<li>Diagnóstico del estado de la fachada.</li>
<li>Saneado y reparación de zonas dañadas.</li>
<li><strong>Impermeabilización</strong> y tratamiento de humedades.</li>
<li><strong>Aislamiento térmico</strong> por el exterior cuando conviene, que mejora el confort y reduce el gasto en climatización.</li>
<li>Acabados de alta durabilidad: morteros, pinturas de exterior o revestimientos cerámicos.</li>
</ul>
<h2>Viviendas y comunidades</h2>
<p>Trabajamos tanto en casas unifamiliares como en edificios. En comunidades de vecinos preparamos el presupuesto por partidas para la junta y gestionamos los permisos de ocupación de vía pública y andamios cuando hacen falta.</p>
<div class="c-note"><p>Las obras que mejoran la eficiencia energética del edificio pueden optar a ayudas públicas cuando hay convocatorias abiertas. Te informamos de las que estén vigentes cuando prepares la obra.</p></div>
'@
     faq = @(
       @('¿Necesito permiso para rehabilitar la fachada?', 'Sí, normalmente hace falta comunicarlo al ayuntamiento y, si se instala andamio en la calle, una autorización de ocupación de vía pública. Nos encargamos de los trámites.'),
       @('¿Cuánto dura una rehabilitación de fachada?', 'Depende de la superficie y del estado, pero en una vivienda unifamiliar suele llevar entre dos y seis semanas.'),
       @('¿Qué es el aislamiento por el exterior?', 'Es una capa aislante que se coloca sobre la fachada y se reviste. Mejora mucho el confort térmico sin quitar espacio dentro de la vivienda.')
     ) }
  @{ slug = 'instalacion-suelos-valencia'; nombre = 'Suministro e instalación de suelos'; servicio = 'Suministro e instalación de suelos porcelánicos'
     title = 'Instalación de suelos porcelánicos en Valencia | Subterráneo Group'
     desc = 'Suministro e instalación de suelos porcelánicos en Valencia y Torrent: gran formato, imitación madera, mármol pulido y exterior. Material y colocación en un solo presupuesto.'
     h1 = 'Suministro e instalación de <em>suelos porcelánicos</em>'
     lead = 'Elige tu suelo entre más de 100 referencias de STN Cerámica y te lo instalamos. Material y colocación en un mismo presupuesto, con un equipo acostumbrado al gran formato.'
     img = '/materiales/img/kobe-1.jpg'; alt = 'Suelo porcelánico imitación madera instalado en un salón'
     tile = 'Más de 100 suelos de STN, con la colocación incluida.'
     body = @'
<h2>Material y colocación, de una vez</h2>
<p>En nuestro <a href="/materiales/">catálogo de suelos</a> tienes porcelánicos efecto mármol, piedra, madera, cemento y terrazo, de interior y de exterior. Calcula los metros, añádelos a tu presupuesto y te respondemos con el precio del material y de la colocación.</p>
<h2>Por qué importa una buena colocación</h2>
<p>Un porcelánico de calidad mal colocado se nota: piezas con resalte, juntas irregulares o baldosas que suenan huecas. Sobre todo en <a href="/materiales/porcelanico-gran-formato/">gran formato</a> (120 × 120, 75 × 150 cm) hace falta:</p>
<ul>
<li>Una base bien nivelada.</li>
<li>Adhesivo adecuado y doble encolado (en la base y en la pieza).</li>
<li>Sistemas de nivelación para evitar resaltes entre piezas.</li>
<li>Herramienta de corte y manipulación específica.</li>
<li>Juntas de dilatación respetadas.</li>
</ul>
<h2>Qué suelo elegir</h2>
<ul>
<li><strong>Salón y dormitorios:</strong> <a href="/materiales/suelo-porcelanico-imitacion-madera/">imitación madera</a> o piedra mate en gran formato.</li>
<li><strong>Baños y cocinas:</strong> acabados mate o satinados, fáciles de limpiar.</li>
<li><strong>Recibidores y espacios de lujo:</strong> <a href="/materiales/porcelanico-pulido/">porcelánico pulido</a> efecto mármol.</li>
<li><strong>Terrazas y piscinas:</strong> <a href="/materiales/suelos-exterior-antideslizantes/">exterior antideslizante</a>, incluido 2 cm de grosor.</li>
</ul>
<p>Si dudas entre porcelánico y tarima, te lo explicamos en <a href="/blog/porcelanico-o-tarima-que-suelo-elegir/">porcelánico o tarima: qué suelo elegir</a>.</p>
'@
     faq = @(
       @('¿Se puede poner porcelánico encima del suelo antiguo?', 'En muchos casos sí, si el suelo existente está firme y nivelado y la altura de puertas lo permite. Lo valoramos en la visita.'),
       @('¿El porcelánico sirve para suelo radiante?', 'Sí. Es de los mejores materiales para suelo radiante porque transmite muy bien el calor.'),
       @('¿Cuántas cajas necesito?', 'En cada ficha de producto tienes una calculadora: pones los metros y te dice cuántas cajas hacen falta, con un 10 % de margen para cortes.')
     ) }
  @{ slug = 'empresa-reformas-torrent'; nombre = 'Reformas en Torrent'; servicio = 'Reformas en Torrent'
     title = 'Empresa de reformas en Torrent | Subterráneo Group'
     desc = 'Empresa de reformas en Torrent (Valencia): reformas integrales, baños, cocinas, fachadas y suelos. Estamos en la calle Moralets 3. Presupuesto sin compromiso en 24 h.'
     h1 = 'Empresa de reformas en <em>Torrent</em>'
     lead = 'Somos una empresa de reformas de Torrent. Desde la calle Moralets trabajamos en el municipio y en toda el área de Valencia, con personal de más de 15 años de oficio.'
     img = '/obra-empresa.jpg'; alt = 'Obra de reforma en curso'
     tile = 'Nuestra base, en la calle Moralets 3.'
     body = @'
<h2>Tu empresa de reformas, cerca de casa</h2>
<p>Al estar en Torrent podemos visitar tu vivienda rápido, preparar el presupuesto en menos de 24 horas y estar pendientes de la obra cada día. Conocemos el tipo de viviendas de la zona, desde pisos de los años 70 y 80 hasta chalets y casas de pueblo.</p>
<h2>Qué hacemos</h2>
<ul>
<li><a href="/reformas/reformas-integrales-valencia/">Reformas integrales</a> de pisos y casas.</li>
<li><a href="/reformas/reforma-banos-valencia/">Reforma de baños</a>: de bañera a ducha, baños completos.</li>
<li><a href="/reformas/reforma-cocinas-valencia/">Reforma de cocinas</a> con mobiliario a medida.</li>
<li><a href="/reformas/rehabilitacion-fachadas-valencia/">Rehabilitación de fachadas</a> e impermeabilización.</li>
<li><a href="/reformas/instalacion-suelos-valencia/">Suministro e instalación de suelos</a> porcelánicos.</li>
<li>Obra nueva con gestión completa del proyecto.</li>
</ul>
<h2>Licencias en Torrent</h2>
<p>Las reformas interiores sin cambios estructurales suelen tramitarse en el Ayuntamiento de Torrent con una declaración responsable de obras; las que afectan a la estructura o a la fachada necesitan proyecto y licencia. Nosotros preparamos la documentación y hacemos el trámite.</p>
<h2>Visítanos o llámanos</h2>
<p><strong>Subterráneo Group S.L</strong> · Calle Moralets 3, 46900 Torrent (Valencia) · <a href="tel:+34638571920">638 57 19 20</a> · <a href="tel:+34747416814">747 41 68 14</a></p>
'@
     faq = @(
       @('¿Trabajáis solo en Torrent?', 'No. Torrent es nuestra base, pero trabajamos en Valencia y en toda la Comunidad Valenciana.'),
       @('¿La visita y el presupuesto tienen coste?', 'No. La visita y el presupuesto son gratuitos y sin compromiso.'),
       @('¿Cuánto tardáis en dar el presupuesto?', 'Normalmente en menos de 24 horas desde la visita.')
     ) }
)

$articulos = @(
  @{ slug = 'cuanto-cuesta-reformar-un-bano-en-valencia'; fecha = '2026-11-15'; min = 6
     title = '¿Cuánto cuesta reformar un baño en Valencia en 2026?'
     desc = 'Precios orientativos de 2026 para reformar un baño en Valencia: reforma completa, cambio de bañera por ducha, qué encarece la obra y cómo pagar menos IVA.'
     h1 = '¿Cuánto cuesta reformar un baño <em>en Valencia en 2026?</em>'
     lead = 'Una reforma completa de un baño de unos 5 m² cuesta, según las fuentes del sector, entre 4.000 y 9.000 euros en Valencia. Te explicamos de qué depende y cómo ajustar el presupuesto.'
     img = '/bano-premium.jpg'; alt = 'Baño reformado con ducha de obra'
     tile = 'Precios de 2026, qué encarece la obra y cómo pagar menos IVA.'
     body = @'
<h2>Precios orientativos en 2026</h2>
<p>Estas son las cifras que publican varias fuentes del sector. Son orientativas: cada baño es distinto y el precio final depende de lo que se cambie.</p>
<table>
<thead><tr><th>Tipo de reforma</th><th>Precio orientativo</th><th>Fuente</th></tr></thead>
<tbody>
<tr><td>Reforma completa de baño en Valencia</td><td>4.500 – 9.000 €</td><td>Cuantomecuesta</td></tr>
<tr><td>Baño de 5 m² con calidades medias</td><td>unos 4.250 €</td><td>Habitissimo</td></tr>
<tr><td>Baño de 6 m² con calidades altas</td><td>unos 4.860 €</td><td>Habitissimo</td></tr>
<tr><td>Baño completo de 4 a 6 m² (media en España)</td><td>4.000 – 5.000 €</td><td>N26</td></tr>
<tr><td>Cambiar la bañera por un plato de ducha</td><td>unos 1.900 €</td><td>Que.es</td></tr>
</tbody>
</table>
<h2>Qué hace que una reforma cueste más o menos</h2>
<ul>
<li><strong>Las instalaciones.</strong> Mover el inodoro o la ducha de sitio obliga a cambiar desagües y tuberías, y es de lo que más encarece la obra.</li>
<li><strong>Los revestimientos.</strong> No es lo mismo alicatar hasta el techo que solo la zona de ducha, ni un porcelánico estándar que un gran formato o un mármol pulido.</li>
<li><strong>El plato de ducha.</strong> Un plato estándar es más económico que una ducha de obra a ras de suelo.</li>
<li><strong>Sanitarios, grifería y mueble.</strong> Aquí la horquilla es enorme: desde gama básica hasta diseño.</li>
<li><strong>El estado de partida.</strong> Si aparecen tuberías viejas o humedades, hay que resolverlas.</li>
</ul>
<h2>Cómo pagar menos sin perder calidad</h2>
<ul>
<li><strong>Mantén la distribución</strong> si funciona: dejar cada elemento en su sitio ahorra fontanería.</li>
<li><strong>Elige bien dónde invertir</strong>: un buen plato de ducha y una buena grifería se notan cada día; el resto puede ser de gama media.</li>
<li><strong>Pide un presupuesto cerrado por partidas</strong>, para comparar y evitar sorpresas.</li>
<li><strong>Aplica el IVA reducido</strong> si cumples los requisitos (lo explicamos abajo).</li>
</ul>
<div class="c-note"><p><strong>IVA del 10 %.</strong> Si el baño es de tu vivienda habitual, la vivienda tiene más de dos años y los materiales que aporta la empresa no superan el 40 % del importe total, la obra tributa al 10 % en lugar del 21 %.</p></div>
<h2>¿Y el suelo?</h2>
<p>Para el baño recomendamos porcelánico mate o antideslizante. Si quieres un aspecto de lujo, los <a href="/materiales/suelos-efecto-marmol/">porcelánicos efecto mármol</a> en gran formato reducen las juntas y se limpian muy fácil. Puedes calcular las cajas que necesitas en cada ficha de nuestro <a href="/materiales/">catálogo</a>.</p>
<h2>Pide tu presupuesto</h2>
<p>Las cifras de arriba son una referencia. Para saber lo que costaría tu baño, te visitamos y te damos un presupuesto cerrado y gratuito en menos de 24 horas. Más información en nuestra página de <a href="/reformas/reforma-banos-valencia/">reforma de baños</a>.</p>
<h3>Fuentes</h3>
<ul class="c-sources">
<li><a href="https://cuantomecuesta.com/es/reforma-bano/" rel="nofollow noopener" target="_blank">Cuantomecuesta: precio de reformar un baño (actualizado en abril de 2026)</a></li>
<li><a href="https://www.habitissimo.es/presupuestos/reformas-banos" rel="nofollow noopener" target="_blank">Habitissimo: presupuestos de reforma de baños</a></li>
<li><a href="https://n26.com/es-es/blog/cuanto-cuesta-reformar-un-bano" rel="nofollow noopener" target="_blank">N26: cuánto cuesta reformar un baño</a></li>
<li><a href="https://www.que.es/2026/09/04/precio-reforma-bano-ducha/" rel="nofollow noopener" target="_blank">Que.es: el precio de cambiar la bañera por ducha (septiembre de 2026)</a></li>
</ul>
'@
     faq = @(
       @('¿Cuánto cuesta reformar un baño pequeño?', 'Un baño de 4 a 6 m² con calidades medias suele estar entre 4.000 y 5.000 euros según las fuentes del sector. Si no hay que mover instalaciones, puede quedar por debajo.'),
       @('¿Cuánto cuesta cambiar la bañera por un plato de ducha?', 'Unos 1.900 euros de media en 2026 según datos publicados, aunque depende del plato, la mampara y si hay que modificar el desagüe.'),
       @('¿Qué IVA se aplica a la reforma de un baño?', 'El 10 % si es tu vivienda habitual, tiene más de dos años y los materiales aportados por la empresa no superan el 40 % del total. Si no, el 21 %.')
     ) }
  @{ slug = 'porcelanico-o-tarima-que-suelo-elegir'; fecha = '2026-11-15'; min = 5
     title = 'Porcelánico o tarima: qué suelo elegir para tu casa | Subterráneo Group'
     desc = 'Porcelánico imitación madera o tarima flotante: comparamos resistencia al agua, durabilidad, suelo radiante, instalación y confort para que elijas bien.'
     h1 = 'Porcelánico o tarima: <em>qué suelo elegir</em>'
     lead = 'Los dos dan el aspecto cálido de la madera, pero se comportan de forma muy distinta. Te contamos en qué se diferencian y cuál conviene en cada caso.'
     img = '/materiales/img/kobe-1.jpg'; alt = 'Suelo porcelánico imitación madera en un salón'
     tile = 'Comparativa práctica para acertar con el suelo.'
     body = @'
<h2>La diferencia en una frase</h2>
<p>La <strong>tarima flotante</strong> (laminada o de madera) es más rápida y económica de colocar; el <strong>porcelánico imitación madera</strong> es más resistente, no le afecta el agua y dura mucho más.</p>
<h2>Comparativa</h2>
<table>
<thead><tr><th></th><th>Porcelánico imitación madera</th><th>Tarima flotante laminada</th></tr></thead>
<tbody>
<tr><td>Agua y humedad</td><td>Impermeable: apto para baños, cocinas y terrazas</td><td>Sensible al agua, salvo gamas específicas</td></tr>
<tr><td>Arañazos y golpes</td><td>Muy resistente</td><td>Se raya con más facilidad</td></tr>
<tr><td>Duración</td><td>Décadas</td><td>Menor, según la calidad y el uso</td></tr>
<tr><td>Suelo radiante</td><td>Excelente: transmite muy bien el calor</td><td>Solo con modelos compatibles</td></tr>
<tr><td>Instalación</td><td>Obra con adhesivo; más tiempo</td><td>Rápida, flotante sobre el suelo existente</td></tr>
<tr><td>Sensación al pisar</td><td>Más fría y dura</td><td>Más cálida y amortiguada</td></tr>
<tr><td>Mantenimiento</td><td>Mínimo: agua y jabón neutro</td><td>Cuidado con el exceso de agua</td></tr>
</tbody>
</table>
<h2>Cuándo elegir porcelánico</h2>
<ul>
<li>Si quieres <strong>el mismo suelo en toda la casa</strong>, incluidos baños y cocina.</li>
<li>Si tienes o vas a poner <strong>suelo radiante</strong>.</li>
<li>Si hay <strong>niños, mascotas</strong> o mucho trasiego.</li>
<li>Si quieres continuar el suelo hacia la <strong>terraza</strong>: hay series con versión exterior antideslizante.</li>
</ul>
<p>Hoy el porcelánico imita la madera con mucho realismo, en lamas largas de hasta 180 cm. Mira nuestros <a href="/materiales/suelo-porcelanico-imitacion-madera/">suelos porcelánicos imitación madera</a>.</p>
<h2>Cuándo elegir tarima</h2>
<ul>
<li>Si buscas una <strong>solución rápida</strong> sobre el suelo actual, sin obra.</li>
<li>Para <strong>dormitorios</strong> o viviendas de alquiler donde prima el precio.</li>
<li>Si prefieres una sensación más cálida al pisar descalzo.</li>
</ul>
<h2>Nuestra recomendación</h2>
<p>Para una reforma pensada para muchos años, el porcelánico compensa: no hay que cambiarlo, aguanta el agua y funciona con suelo radiante. Si quieres verlo en tu casa, te asesoramos y te lo <a href="/reformas/instalacion-suelos-valencia/">suministramos e instalamos</a>.</p>
'@
     faq = @(
       @('¿El porcelánico imitación madera parece madera de verdad?', 'Los porcelánicos actuales reproducen la veta y el color con mucho realismo, y las lamas largas ayudan a que el efecto sea más natural.'),
       @('¿Es frío el porcelánico?', 'Al tacto es más fresco que la tarima, algo que en verano se agradece. Con suelo radiante es el material que mejor reparte el calor.'),
       @('¿Se puede poner porcelánico sobre el suelo antiguo?', 'En muchos casos sí, si el suelo está firme y nivelado y las puertas lo permiten.')
     ) }
  @{ slug = 'que-suelo-poner-en-terraza-y-piscina'; fecha = '2026-11-15'; min = 5
     title = 'Qué suelo poner en una terraza o piscina | Subterráneo Group'
     desc = 'Cómo elegir suelo para terraza, jardín y piscina: clase antideslizante C3, porcelánico de 2 cm, colores que no se calientan y continuidad con el interior.'
     h1 = 'Qué suelo poner en una <em>terraza o piscina</em>'
     lead = 'En exterior el suelo tiene que ser seguro con agua, aguantar el sol y los cambios de temperatura y ser fácil de limpiar. Estas son las claves para acertar.'
     img = '/materiales/img/miller-2out-1.jpg'; alt = 'Terraza con suelo porcelánico antideslizante'
     tile = 'Antideslizante, 2 cm de grosor y colores frescos.'
     body = @'
<h2>1. Que sea antideslizante de verdad</h2>
<p>La resistencia al deslizamiento se clasifica en España por clases, de 0 a 3. Para terrazas, playas de piscina y duchas exteriores lo recomendable es la <strong>clase 3 (C3)</strong>, que es la que el Código Técnico de la Edificación exige en zonas exteriores y piscinas de edificios de uso público. Muchos fabricantes indican además la clasificación alemana R (de R9 a R13); en exterior se suele trabajar con <strong>R11</strong>.</p>
<h2>2. Porcelánico: resistente a heladas y al sol</h2>
<p>El porcelánico apenas absorbe agua, así que no se agrieta con las heladas ni pierde color con el sol. Es la opción más duradera para exterior, por delante de la piedra natural (que hay que tratar) o la madera (que necesita mantenimiento).</p>
<h2>3. El grosor de 2 cm abre posibilidades</h2>
<p>Las piezas de <strong>2 cm de grosor</strong> son mucho más resistentes a la rotura. Además de colocarse con cemento, se pueden instalar <strong>en seco sobre grava, césped o soportes regulables</strong>, ideal para caminos de jardín o terrazas sobre cubiertas.</p>
<h2>4. Colores claros para no quemarse</h2>
<p>Bajo el sol de verano, los tonos claros (beige, marfil, arena) se calientan bastante menos que los oscuros. Alrededor de la piscina, mejor colores claros.</p>
<h2>5. Continuidad con el interior</h2>
<p>Muchas series tienen versión de interior y de exterior con el mismo diseño. Así el salón continúa hacia la terraza sin cambio de suelo y la casa parece más grande. Ten en cuenta que la pieza de exterior de 2 cm es más gruesa que la de interior, así que hay que preparar la base para que no quede escalón.</p>
<h2>Nuestras propuestas</h2>
<p>En nuestro catálogo de <a href="/materiales/suelos-exterior-antideslizantes/">suelos de exterior antideslizantes</a> tienes porcelánicos C3 de 2 cm en efecto piedra y cemento, en formatos de 60 × 90, 60 × 120 y 100 × 100 cm. Te los <a href="/reformas/instalacion-suelos-valencia/">suministramos e instalamos</a>.</p>
'@
     faq = @(
       @('¿Qué clase antideslizante necesito para una piscina?', 'La clase 3 (C3) es la recomendada para playas de piscina y zonas exteriores mojadas.'),
       @('¿Se puede usar el mismo suelo dentro y fuera?', 'Sí, si la serie tiene versión exterior antideslizante. Se mantiene el diseño y cambia el acabado y, a veces, el grosor.'),
       @('¿El porcelánico de exterior se puede poner sobre césped?', 'Las piezas de 2 cm de grosor sí: se pueden colocar en seco sobre césped, grava o soportes regulables.')
     ) }
)

$facts = '<ul class="c-facts"><li><b>+15</b><span>Años de oficio</span></li><li><b>24 h</b><span>Presupuesto</span></li><li><b>360°</b><span>Llave en mano</span></li></ul>'
$ctaRow = "<div class=`"c-cta-row`"><a href=`"/#contacto`" class=`"btn-gold`">Pedir presupuesto</a><a href=`"$wa`" class=`"btn-ghost`" target=`"_blank`" rel=`"noopener`">Escribir por WhatsApp</a></div>"
$ctaBox = "<section class=`"c-cta`"><div><h2>¿Hablamos de tu proyecto?</h2><p>Visita y presupuesto sin compromiso. Respondemos en menos de 24 horas.</p></div>$ctaRow</section>"

function FaqHtml($faq) { '<section class="c-faq"><h2>Preguntas frecuentes</h2>' + (($faq | ForEach-Object { "<details><summary>$(Esc $_[0])</summary><p>$(Esc $_[1])</p></details>" }) -join '') + '</section>' }
function FaqLd($faq) { @{ '@type' = 'FAQPage'; mainEntity = @($faq | ForEach-Object { @{ '@type' = 'Question'; name = $_[0]; acceptedAnswer = @{ '@type' = 'Answer'; text = $_[1] } } }) } }
function Tiles($items, $base) {
  '<div class="c-grid">' + (($items | ForEach-Object { "<a class=`"c-tile`" href=`"/$base/$($_.slug)/`"><img src=`"$($_.img)`" alt=`"$(Esc $_.alt)`" width=`"600`" height=`"450`" loading=`"lazy`"><div><h2>$(Esc ($_.h1 -replace '<[^>]+>', ''))</h2><p>$(Esc $_.tile)</p><span>Ver más →</span></div></a>" }) -join '') + '</div>'
}
$fechaTxt = { param($d) ([datetime]$d).ToString('d \de MMMM \de yyyy', [Globalization.CultureInfo]::GetCultureInfo('es-ES')) }

# ── Páginas de servicio ──
foreach ($s in $servicios) {
  $url = "/reformas/$($s.slug)/"
  $crumbs = @(@('Inicio', '/'), @('Reformas', '/reformas/'), @($s.nombre, $null))
  $ld = Json @{ '@context' = 'https://schema.org'; '@graph' = @(
      (CrumbsLd $crumbs),
      @{ '@type' = 'Service'; name = $s.servicio; serviceType = $s.servicio; description = $s.desc; url = "$SITE$url"; image = "$SITE$($s.img)"; provider = $empresa; areaServed = $zonas },
      (FaqLd $s.faq)) }
  $otros = @($servicios | Where-Object { $_.slug -ne $s.slug })
  $html = (Head $s.title $s.desc $url $s.img $ld) + (Get-Nav 'reformas') + @"
  <main class="m-page">
    <div class="m-wrap">
      $(Crumbs $crumbs)
      <header class="c-hero">
        <div>
          <p class="label-gold">Subterráneo Group · Reformas</p>
          <h1>$($s.h1)</h1>
          <p class="c-lead">$(Esc $s.lead)</p>
          $ctaRow
          $facts
        </div>
        <figure class="c-hero__img"><img src="$($s.img)" alt="$(Esc $s.alt)" width="900" height="1000" fetchpriority="high"></figure>
      </header>
      <article class="c-body">
$($s.body)
      </article>
      $(FaqHtml $s.faq)
      $ctaBox
      <section><h2 class="m-label">Otros servicios</h2>$(Tiles $otros 'reformas')</section>
    </div>
  </main>
"@ + (Get-Footer)
  Write-Page "reformas/$($s.slug)/index.html" $html
}

# ── Índice de reformas ──
$crumbs = @(@('Inicio', '/'), @('Reformas', $null))
$ld = Json @{ '@context' = 'https://schema.org'; '@graph' = @((CrumbsLd $crumbs), @{ '@type' = 'CollectionPage'; name = 'Reformas en Valencia y Torrent'; url = "$SITE/reformas/"; about = $empresa }) }
$html = (Head 'Reformas en Valencia y Torrent | Subterráneo Group' 'Empresa de reformas en Valencia y Torrent: reformas integrales, baños, cocinas, fachadas y suelos porcelánicos. Presupuesto cerrado y sin compromiso en 24 h.' '/reformas/' '/interior-reforma.jpg' $ld) + (Get-Nav 'reformas') + @"
  <main class="m-page">
    <div class="m-wrap">
      $(Crumbs $crumbs)
      <header class="m-hero">
        <div>
          <h1>Reformas en <em>Valencia y Torrent</em></h1>
          <p>Reformas integrales, baños, cocinas, fachadas y suelos. Nos encargamos del proyecto, las licencias, la obra y los acabados, con un presupuesto cerrado en menos de 24 horas.</p>
        </div>
        <div class="m-usp"><div><b>+15</b><span>Años de oficio</span></div><div><b>+20</b><span>Obras</span></div><div><b>24 h</b><span>Presupuesto</span></div></div>
      </header>
      $(Tiles $servicios 'reformas')
      $ctaBox
    </div>
  </main>
"@ + (Get-Footer)
Write-Page 'reformas/index.html' $html

# ── Artículos ──
foreach ($a in $articulos) {
  $url = "/blog/$($a.slug)/"
  $crumbs = @(@('Inicio', '/'), @('Blog', '/blog/'), @(($a.h1 -replace '<[^>]+>', ''), $null))
  $ld = Json @{ '@context' = 'https://schema.org'; '@graph' = @(
      (CrumbsLd $crumbs),
      @{ '@type' = 'Article'; headline = ($a.h1 -replace '<[^>]+>', ''); description = $a.desc; image = "$SITE$($a.img)"; datePublished = $a.fecha; dateModified = $a.fecha
         author = @{ '@type' = 'Organization'; name = 'Subterráneo Group'; url = "$SITE/" }; publisher = $empresa; mainEntityOfPage = "$SITE$url"; inLanguage = 'es-ES' },
      (FaqLd $a.faq)) }
  $html = (Head $a.title $a.desc $url $a.img $ld 'index, follow' 'article') + (Get-Nav '') + @"
  <main class="m-page">
    <div class="m-wrap">
      $(Crumbs $crumbs)
      <header class="c-hero">
        <div>
          <p class="label-gold">Blog · Subterráneo Group</p>
          <h1>$($a.h1)</h1>
          <p class="c-meta"><time datetime="$($a.fecha)">$(& $fechaTxt $a.fecha)</time> · $($a.min) min de lectura</p>
          <p class="c-lead">$(Esc $a.lead)</p>
          $ctaRow
        </div>
        <figure class="c-hero__img"><img src="$($a.img)" alt="$(Esc $a.alt)" width="900" height="1000" fetchpriority="high"></figure>
      </header>
      <article class="c-body">
$($a.body)
      </article>
      $(FaqHtml $a.faq)
      $ctaBox
      <section><h2 class="m-label">Más artículos</h2>$(Tiles @($articulos | Where-Object { $_.slug -ne $a.slug }) 'blog')</section>
    </div>
  </main>
"@ + (Get-Footer)
  Write-Page "blog/$($a.slug)/index.html" $html
}

# ── Índice del blog ──
$crumbs = @(@('Inicio', '/'), @('Blog', $null))
$ld = Json @{ '@context' = 'https://schema.org'; '@graph' = @((CrumbsLd $crumbs), @{ '@type' = 'Blog'; name = 'Blog de Subterráneo Group'; url = "$SITE/blog/"; publisher = $empresa; inLanguage = 'es-ES' }) }
$html = (Head 'Blog de reformas y suelos | Subterráneo Group' 'Consejos y precios para tu reforma en Valencia: cuánto cuesta reformar un baño, qué suelo elegir y cómo acertar en terrazas y piscinas.' '/blog/' '/bano-premium.jpg' $ld) + (Get-Nav '') + @"
  <main class="m-page">
    <div class="m-wrap">
      $(Crumbs $crumbs)
      <header class="m-hero">
        <div>
          <h1>Blog de <em>reformas y suelos</em></h1>
          <p>Precios, consejos y comparativas para que tomes buenas decisiones en tu reforma.</p>
        </div>
      </header>
      $(Tiles $articulos 'blog')
      $ctaBox
    </div>
  </main>
"@ + (Get-Footer)
Write-Page 'blog/index.html' $html

$mapa = & (Join-Path $root '_web\sitemap.ps1') -Root $root
"Generadas: reformas ($($servicios.Count) servicios + índice) y blog ($($articulos.Count) artículos + índice). $mapa."
