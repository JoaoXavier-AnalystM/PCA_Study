$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$configPath = Join-Path $repoRoot 'deploy\nginx.conf'
$config = [System.IO.File]::ReadAllText($configPath)

function Assert-ConfigMatch {
  param(
    [Parameter(Mandatory)][string]$Pattern,
    [Parameter(Mandatory)][string]$Message,
    [string]$Text = $config
  )

  if ($Text -notmatch $Pattern) {
    throw $Message
  }
}

function Get-NginxBlocks {
  param([Parameter(Mandatory)][string]$Pattern)

  $blocks = @()
  foreach ($match in [regex]::Matches($config, $Pattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)) {
    $openBrace = $config.IndexOf('{', $match.Index)
    if ($openBrace -lt 0) {
      throw "Missing opening brace for block matching $Pattern"
    }

    $depth = 0
    for ($index = $openBrace; $index -lt $config.Length; $index++) {
      if ($config[$index] -eq '{') { $depth++ }
      if ($config[$index] -eq '}') { $depth-- }
      if ($depth -eq 0) {
        $blocks += $config.Substring($match.Index, $index - $match.Index + 1)
        break
      }
    }
  }

  return $blocks
}

# Preserve compression directives that serve current static responses.
Assert-ConfigMatch '(?m)^\s*add_header\s+X-Content-Type-Options\s+"nosniff"\s+always;\s*$' 'X-Content-Type-Options must remain enabled'
Assert-ConfigMatch '(?m)^\s*add_header\s+Referrer-Policy\s+"strict-origin-when-cross-origin"\s+always;\s*$' 'Referrer-Policy must remain strict-origin-when-cross-origin'
Assert-ConfigMatch '(?m)^\s*gzip\s+on;\s*$' 'gzip must remain enabled'
Assert-ConfigMatch '(?m)^\s*gzip_vary\s+on;\s*$' 'gzip_vary must remain enabled'
Assert-ConfigMatch '(?m)^\s*gzip_min_length\s+1024;\s*$' 'gzip_min_length must remain 1024'
Assert-ConfigMatch '(?m)^\s*gzip_types\s+text/html\s+text/css\s+text/plain\s+application/javascript\s+application/json\s+image/svg\+xml;\s*$' 'gzip_types must preserve current content types'

# Preserve cache behavior for HTML and static assets.
Assert-ConfigMatch '(?ms)location\s+~\*\s+\\\.html\$\s*\{.*?add_header\s+Cache-Control\s+"no-cache";' 'HTML responses must remain no-cache'
Assert-ConfigMatch '(?ms)location\s+~\*\s+\\\.\(css\|js\|png\|jpg\|jpeg\|gif\|svg\|webp\|ico\|woff2\?\)\$\s*\{.*?expires\s+30d;.*?add_header\s+Cache-Control\s+"public, immutable";' 'Static assets must retain long-lived immutable caching'

$securityHeaders = @(
  'add_header Strict-Transport-Security "max-age=31536000" always;',
  'add_header X-Frame-Options "SAMEORIGIN" always;',
  'add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;'
)

foreach ($header in $securityHeaders) {
  $escapedHeader = [regex]::Escape($header)
  $headerCount = [regex]::Matches($config, $escapedHeader).Count
  if ($headerCount -lt 3) {
    throw "$header must be defined at server scope and both cached location blocks (found $headerCount)"
  }
}

# Avoid an unverified CSP that could break inline scripts or Google Fonts.
if ($config -match '(?im)^\s*add_header\s+Content-Security-Policy(?:-Report-Only)?\b') {
  throw 'CSP must not be added without verifying inline scripts and Google Fonts compatibility'
}

$locationBlocks = Get-NginxBlocks '^\s*location\s+~\*\s+'
if ($locationBlocks.Count -ne 2) {
  throw "Expected two existing regex location blocks, found $($locationBlocks.Count)"
}

foreach ($block in $locationBlocks) {
  foreach ($header in $securityHeaders) {
    Assert-ConfigMatch ([regex]::Escape($header)) "Cached location is missing security header: $header" $block
  }
}

# Run syntax validation when a local nginx executable is available.
$nginx = Get-Command nginx -ErrorAction SilentlyContinue
if ($null -eq $nginx) {
  Write-Output 'SKIP nginx -t: nginx executable unavailable'
} else {
  $syntaxRoot = Join-Path ([System.IO.Path]::GetTempPath()) "pca-nginx-$([guid]::NewGuid().ToString('N'))"
  New-Item -ItemType Directory -Path $syntaxRoot | Out-Null
  try {
    $wrapperPath = Join-Path $syntaxRoot 'nginx.conf'
    $includedConfigPath = $configPath.Replace('\', '/')
    $wrapper = "events { }`nhttp {`n    include `"$includedConfigPath`";`n}`n"
    [System.IO.File]::WriteAllText($wrapperPath, $wrapper)
    $syntaxOutput = & $nginx.Source -t -c $wrapperPath 2>&1
    if ($LASTEXITCODE -ne 0) {
      throw "nginx -t failed:`n$($syntaxOutput -join [Environment]::NewLine)"
    }
    Write-Output 'PASS nginx -t'
  } finally {
    Remove-Item -LiteralPath $syntaxRoot -Recurse -Force -ErrorAction SilentlyContinue
  }
}

Write-Output 'PASS nginx security headers and existing directives'
