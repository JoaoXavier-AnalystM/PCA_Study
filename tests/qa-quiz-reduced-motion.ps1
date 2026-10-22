param()

$ErrorActionPreference = 'Stop'
$session = "pca-quiz-reduced-motion-$([guid]::NewGuid().ToString('N'))"
$port = Get-Random -Minimum 49152 -Maximum 65500
$baseUrl = "http://127.0.0.1:$port"
$server = $null

function Invoke-AgentBrowser {
  param([Parameter(Mandatory)][string[]]$Arguments)
  & agent-browser --session $session @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "agent-browser failed: $($Arguments -join ' ')"
  }
}

function Assert-QuizScrollBehavior {
  param(
    [Parameter(Mandatory)][ValidateSet('normal', 'reduced')][string]$Motion,
    [Parameter(Mandatory)][ValidateSet('pt', 'en')][string]$Language
  )

  $page = if ($Language -eq 'en') { 'day1-en.html' } else { 'day1.html' }
  Invoke-AgentBrowser @('open', "$baseUrl/$page")
  Invoke-AgentBrowser @('wait', '--load', 'networkidle')
  $script = @"
const reduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
const expectedReduced = '$Motion' === 'reduced';
if (reduced !== expectedReduced) throw new Error('prefers-reduced-motion mismatch: ' + reduced);
const explanation = document.querySelector('.quiz-exp');
const option = document.querySelector('.quiz-opt');
if (!explanation || !option) throw new Error('quiz controls missing');
const scrollCalls = [];
explanation.scrollIntoView = options => scrollCalls.push(options);
option.click();
if (explanation.hidden) throw new Error('quiz feedback did not appear');
if (scrollCalls.length !== 1) throw new Error('quiz feedback scroll count is ' + scrollCalls.length);
const behavior = scrollCalls[0] && scrollCalls[0].behavior;
const expectedBehavior = expectedReduced ? 'auto' : 'smooth';
if (behavior !== expectedBehavior) throw new Error('scroll behavior is ' + behavior + ', expected ' + expectedBehavior);
const label = option.getAttribute('aria-label') || '';
const labelPattern = '$Language' === 'en' ? /\u2014 (correct|incorrect)$/ : /\u2014 (correta|incorreta)$/;
if (!labelPattern.test(label)) throw new Error('quiz label is ' + label);
"@
  $encoded = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($script))
  Invoke-AgentBrowser @('eval', '-b', $encoded)
  Write-Output "PASS ${Motion}/${Language}: quiz feedback scroll and label"
}

try {
  $server = Start-Process -FilePath 'python' -ArgumentList @('-m', 'http.server', $port, '--directory', 'web') -PassThru -WindowStyle Hidden
  Start-Sleep -Milliseconds 500

  Invoke-AgentBrowser @('set', 'media', 'light')
  Assert-QuizScrollBehavior -Motion normal -Language pt
  Assert-QuizScrollBehavior -Motion normal -Language en

  Invoke-AgentBrowser @('set', 'media', 'light', 'reduced-motion')
  Assert-QuizScrollBehavior -Motion reduced -Language pt
  Assert-QuizScrollBehavior -Motion reduced -Language en

  Write-Output 'PASS reduced-motion regression: normal and reduced quiz feedback paths'
}
finally {
  try { Invoke-AgentBrowser @('close') } catch {}
  if ($server) {
    Stop-Process -Id $server.Id -Force -ErrorAction SilentlyContinue
  }
}
