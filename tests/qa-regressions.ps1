param(
  [ValidateSet('issue1', 'issue2', 'issue3', 'all')]
  [string]$Case = 'all'
)

$ErrorActionPreference = 'Stop'
$session = "pca-regressions-$([guid]::NewGuid().ToString('N'))"
$port = Get-Random -Minimum 49152 -Maximum 65500
$url = "http://127.0.0.1:$port/index.html"
$server = $null

function Invoke-AgentBrowser {
  param([Parameter(Mandatory)][string[]]$Arguments)
  & agent-browser --session $session @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "agent-browser failed: $($Arguments -join ' ')"
  }
}

try {
  $server = Start-Process -FilePath 'python' -ArgumentList @('-m', 'http.server', $port, '--directory', 'web') -PassThru -WindowStyle Hidden
  Start-Sleep -Milliseconds 500
  Invoke-AgentBrowser @('open', $url)
  Invoke-AgentBrowser @('wait', '--load', 'networkidle')

  if ($Case -in @('issue1', 'all')) {
    Invoke-AgentBrowser @('eval', "localStorage.setItem('pca_lang','en'); location.reload()")
    Invoke-AgentBrowser @('wait', '--load', 'networkidle')
    Invoke-AgentBrowser @('eval', "const prep=Array.from(document.querySelectorAll('#about h2')).find(h=>h.getAttribute('data-i18n')==='about.prep'); const actual={lang:document.documentElement.lang,badge:document.querySelector('#about .hero-badge').textContent.trim(),intro:document.querySelector('#about .hero p').textContent.trim(),resources:Array.from(prep.nextElementSibling.querySelectorAll('.about-card h3')).map(h=>h.textContent.trim()),theme:document.querySelector('.nav-theme-btn').getAttribute('aria-label')}; const expectedResources=['Official LFS241 Course','Open source curriculum','Candidate Handbook','KodeKloud - PCA','YetMike - practice PCA']; if(actual.lang!=='en') throw new Error('document language is '+actual.lang); if(actual.badge!=='ABOUT THE CERTIFICATION') throw new Error('about badge is '+actual.badge); if(actual.intro!=='Pre-professional certification from CNCF and the Linux Foundation that validates fundamentals of observability and use of Prometheus - the open source toolkit for monitoring and alerting.') throw new Error('about intro is '+actual.intro); if(JSON.stringify(actual.resources)!==JSON.stringify(expectedResources)) throw new Error('resource headings are '+actual.resources.join('|')); if(actual.theme!=='Toggle theme') throw new Error('theme label is '+actual.theme)")
    Write-Output 'PASS issue1: English localization and document language'
  }

  if ($Case -in @('issue2', 'all')) {
    Invoke-AgentBrowser @('eval', "localStorage.setItem('pca_quiz_lang','pt'); location.reload()")
    Invoke-AgentBrowser @('wait', '--load', 'networkidle')
    Invoke-AgentBrowser @('eval', "show('quiz'); const displayedScore=document.getElementById('scoreDisplay').textContent.trim(); if(displayedScore!=='Pontua\u00e7\u00e3o: 0/50') throw new Error('quiz score is '+displayedScore)")
    Write-Output 'PASS issue2: quiz score denominator'
  }

  if ($Case -in @('issue3', 'all')) {
    Invoke-AgentBrowser @('eval', "show('about'); const tags=Array.from(document.querySelectorAll('#about h1, #about h2, #about h3')).map(el=>el.tagName); const firstH3=tags.indexOf('H3'); const firstH2=tags.indexOf('H2'); if(firstH3>=0 && firstH2>=0 && firstH3<firstH2) throw new Error('H3 precedes first H2')")
    Write-Output 'PASS issue3: homepage heading hierarchy'
  }
}
finally {
  try { Invoke-AgentBrowser @('close') } catch {}
  if ($server) {
    Stop-Process -Id $server.Id -Force -ErrorAction SilentlyContinue
  }
}
