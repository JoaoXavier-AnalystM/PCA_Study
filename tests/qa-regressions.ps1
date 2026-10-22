param(
  [ValidateSet('issue1', 'issue2', 'issue3', 'issue4', 'all')]
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
    Invoke-AgentBrowser @('eval', "localStorage.setItem('pca_lang','en'); localStorage.removeItem('pca_quiz_answered'); localStorage.removeItem('pca_quiz_score'); localStorage.removeItem('pca_quiz_total'); location.reload()")
    Invoke-AgentBrowser @('wait', '--load', 'networkidle')
    Invoke-AgentBrowser @('eval', "const prep=Array.from(document.querySelectorAll('#about h2')).find(h=>h.getAttribute('data-i18n')==='about.prep'); const actual={lang:document.documentElement.lang,badge:document.querySelector('#about .hero-badge').textContent.trim(),intro:document.querySelector('#about .hero p').textContent.trim(),resources:Array.from(prep.nextElementSibling.querySelectorAll('.about-card h3')).map(h=>h.textContent.trim()),theme:document.querySelector('.nav-theme-btn').getAttribute('aria-label'),resetTitle:document.querySelector('[data-i18n=\'plano.reset\']').title,quizLanguage:document.querySelector('.quiz-lang').getAttribute('aria-label')}; const expectedResources=['Official LFS241 Course','Open source curriculum','Candidate Handbook','KodeKloud - PCA','YetMike - practice PCA']; if(actual.lang!=='en') throw new Error('document language is '+actual.lang); if(actual.badge!=='ABOUT THE CERTIFICATION') throw new Error('about badge is '+actual.badge); if(actual.intro!=='Pre-professional certification from CNCF and the Linux Foundation that validates fundamentals of observability and use of Prometheus - the open source toolkit for monitoring and alerting.') throw new Error('about intro is '+actual.intro); if(JSON.stringify(actual.resources)!==JSON.stringify(expectedResources)) throw new Error('resource headings are '+actual.resources.join('|')); if(actual.theme!=='Toggle theme') throw new Error('theme label is '+actual.theme); if(actual.resetTitle!=='Clear visit history') throw new Error('reset title is '+actual.resetTitle); if(actual.quizLanguage!=='Language') throw new Error('quiz language is '+actual.quizLanguage)")
    Write-Output 'PASS issue1: English localization and document language'
  }

  if ($Case -in @('issue2', 'all')) {
    Invoke-AgentBrowser @('eval', "localStorage.setItem('pca_quiz_lang','pt'); localStorage.removeItem('pca_quiz_answered'); localStorage.removeItem('pca_quiz_score'); localStorage.removeItem('pca_quiz_total'); location.reload()")
    Invoke-AgentBrowser @('wait', '--load', 'networkidle')
    Invoke-AgentBrowser @('eval', "show('quiz'); const initial=document.getElementById('scoreDisplay').textContent.trim(); if(initial!=='Pontua\u00e7\u00e3o: 0/50') throw new Error('initial quiz score is '+initial); document.querySelector('#quizContainer .option-btn').click(); const afterAnswer=document.getElementById('scoreDisplay').textContent.trim(); if(!/\/50$/.test(afterAnswer)) throw new Error('answered quiz score is '+afterAnswer); const filterButton=document.querySelectorAll('#quiz .filter-btn')[1]; filterQuiz('PromQL', {target:filterButton}); const expected=questions.filter(q=>q.domain==='PromQL').length; const filtered=document.getElementById('scoreDisplay').textContent.trim(); if(!filtered.endsWith('/'+expected)) throw new Error('filtered quiz score is '+filtered+' expected /'+expected); setQuizLang('en'); const english=document.getElementById('scoreDisplay').textContent.trim(); if(!english.startsWith('Score: ')) throw new Error('english quiz score is '+english)")
    Write-Output 'PASS issue2: quiz score denominator'
  }

  if ($Case -in @('issue3', 'all')) {
    Invoke-AgentBrowser @('eval', "show('about'); const h1s=Array.from(document.querySelectorAll('#about h1')); const h2Keys=Array.from(document.querySelectorAll('#about h2')).map(el=>el.getAttribute('data-i18n')); const expectedH2=['about.what.h','about.who.h','about.details.h','about.certs.h','about.domains','about.prep']; if(h1s.length!==1) throw new Error('homepage H1 count is '+h1s.length); if(JSON.stringify(h2Keys.slice(0,6))!==JSON.stringify(expectedH2)) throw new Error('homepage H2 order is '+h2Keys.join('|')); const tags=Array.from(document.querySelectorAll('#about h1, #about h2, #about h3')).map(el=>el.tagName); const firstH3=tags.indexOf('H3'); const firstH2=tags.indexOf('H2'); if(firstH3>=0 && firstH2>=0 && firstH3<firstH2) throw new Error('H3 precedes first H2')")
    Write-Output 'PASS issue3: homepage heading hierarchy'
  }

  if ($Case -in @('issue4', 'all')) {
    $studyPages = Get-ChildItem (Join-Path $PSScriptRoot '..\web') -Filter 'day*.html'
    foreach ($page in $studyPages) {
      $html = [System.IO.File]::ReadAllText($page.FullName)
      if ([regex]::Matches($html, '<title\b', 'IgnoreCase').Count -ne 1) { throw "$($page.Name) must have exactly one title" }
      if ([regex]::Matches($html, '<main\b', 'IgnoreCase').Count -ne 1) { throw "$($page.Name) must have exactly one main" }
      if ($html -notmatch '<script\s+src="day-quiz\.js"') { throw "$($page.Name) must load day-quiz.js" }
    }

    $indexHtml = [System.IO.File]::ReadAllText((Join-Path $PSScriptRoot '..\web\index.html'))
    if ([regex]::Matches($indexHtml, '<main\b', 'IgnoreCase').Count -ne 1) { throw 'index.html must have exactly one main' }
    if ([regex]::Matches($indexHtml, 'class="day-card[^>]*role="button"[^>]*tabindex="0"', 'IgnoreCase').Count -ne 7) { throw 'homepage day cards need button semantics' }

    $quizPages = $studyPages | Where-Object { $_.Name -match '^day[1-5](-en)?\.html$' }
    foreach ($page in $quizPages) {
      $html = [System.IO.File]::ReadAllText($page.FullName)
      $optionCount = [regex]::Matches($html, 'class="quiz-opt"', 'IgnoreCase').Count
      $buttonCount = [regex]::Matches($html, '<button\s+type="button"\s+class="quiz-opt"', 'IgnoreCase').Count
      if ($optionCount -eq 0 -or $buttonCount -ne $optionCount) { throw "$($page.Name) quiz options must be native buttons" }
    }

    Write-Output 'PASS issue4: study page landmarks and native quiz controls'

    Invoke-AgentBrowser @('open', "$url")
    Invoke-AgentBrowser @('wait', '--load', 'networkidle')
    Invoke-AgentBrowser @('eval', "const main=document.querySelectorAll('main'); const cards=document.querySelectorAll('.day-card'); if(main.length!==1) throw new Error('homepage main count is '+main.length); if(cards.length!==7) throw new Error('day card count is '+cards.length); if(Array.from(cards).some(card=>card.getAttribute('role')!=='button'||card.tabIndex!==0)) throw new Error('day card keyboard semantics missing')")

    Invoke-AgentBrowser @('open', "$($url -replace '/index\.html$','')/day1.html")
    Invoke-AgentBrowser @('wait', '--load', 'networkidle')
    Invoke-AgentBrowser @('eval', "const main=document.querySelectorAll('main'); const first=document.querySelector('.quiz-opt'); if(!document.title.includes('PCA Guia')||!document.title.includes('Dia 1')) throw new Error('PT day title is '+document.title); if(main.length!==1) throw new Error('PT day main count is '+main.length); if(!first||first.tagName!=='BUTTON'||first.type!=='button') throw new Error('PT quiz option is not button'); first.focus(); if(document.activeElement!==first) throw new Error('PT quiz option cannot receive focus')")
    Invoke-AgentBrowser @('eval', "document.querySelector('.quiz-opt').click(); if(document.querySelector('.quiz-exp').hidden) throw new Error('PT quiz feedback did not appear')")

    Invoke-AgentBrowser @('open', "$($url -replace '/index\.html$','')/day1-en.html")
    Invoke-AgentBrowser @('wait', '--load', 'networkidle')
    Invoke-AgentBrowser @('eval', "const main=document.querySelectorAll('main'); const first=document.querySelector('.quiz-opt'); if(!document.title.includes('PCA Guide')||!document.title.includes('Day 1')) throw new Error('EN day title is '+document.title); if(main.length!==1) throw new Error('EN day main count is '+main.length); if(!first||first.tagName!=='BUTTON'||first.type!=='button') throw new Error('EN quiz option is not button'); first.focus(); first.click(); if(document.querySelector('.quiz-exp').hidden) throw new Error('EN quiz feedback did not appear')")
    Write-Output 'PASS issue4: direct PT/EN study pages and quiz feedback'
  }
}
finally {
  try { Invoke-AgentBrowser @('close') } catch {}
  if ($server) {
    Stop-Process -Id $server.Id -Force -ErrorAction SilentlyContinue
  }
}
