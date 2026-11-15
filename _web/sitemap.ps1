# Crea /sitemap.xml con todas las páginas indexables de la web (las que no llevan "noindex").
param([string] $Root = (Split-Path (Split-Path $MyInvocation.MyCommand.Path)))
$SITE = 'https://subterraneogroup.com'
$hoy = (Get-Date).ToString('yyyy-MM-dd')
$rootFull = (Resolve-Path $Root).Path.TrimEnd('\')
$urls = foreach ($f in (Get-ChildItem $rootFull -Recurse -Filter *.html)) {
  $rel = $f.FullName.Substring($rootFull.Length).Replace('\', '/')
  if ($rel -match '/[_.]' -or $f.Name -eq '404.html' -or $f.Name -like 'google*.html') { continue }
  $html = [IO.File]::ReadAllText($f.FullName, [Text.Encoding]::UTF8)
  if ($html -match '<meta name="robots" content="[^"]*noindex') { continue }
  $path = if ($f.Name -eq 'index.html') { $rel.Substring(0, $rel.Length - 'index.html'.Length) } else { $rel }
  $prio = switch -Regex ($path) {
    '^/$' { '1.0'; break }
    '^/(materiales|reformas|blog)/$' { '0.9'; break }
    '^/reformas/' { '0.8'; break }
    '^/materiales/(suelos-|suelo-|porcelanico-|placas-)' { '0.8'; break }
    '^/blog/' { '0.7'; break }
    default { '0.6' }
  }
  [pscustomobject]@{ loc = "$SITE$path"; prio = $prio }
}
$urls = @($urls | Sort-Object { - [double]$_.prio }, loc)
$xml = "<?xml version=`"1.0`" encoding=`"UTF-8`"?>`n<urlset xmlns=`"http://www.sitemaps.org/schemas/sitemap/0.9`">`n" +
  (($urls | ForEach-Object { "  <url><loc>$($_.loc)</loc><lastmod>$hoy</lastmod><priority>$($_.prio)</priority></url>" }) -join "`n") + "`n</urlset>`n"
[IO.File]::WriteAllText((Join-Path $rootFull 'sitemap.xml'), $xml, (New-Object Text.UTF8Encoding $false))
"Sitemap: $($urls.Count) URLs"
