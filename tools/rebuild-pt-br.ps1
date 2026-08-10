param(
  [string]$Php = 'C:\tmp\php-8.5.9-lint\php.exe',
  [string]$WorkingDirectory = (Split-Path -Parent $PSScriptRoot),
  [int]$BatchCharacters = 2800,
  [int]$DelayMilliseconds = 180
)

$ErrorActionPreference = 'Stop'
$sourcePath = Join-Path $env:TEMP 'sngine-pt-br-source.json'
$translatedPath = Join-Path $env:TEMP 'sngine-pt-br-translated.json'
$cachePath = Join-Path $env:TEMP 'sngine-pt-br-cache.json'
$catalogTool = Join-Path $PSScriptRoot 'pt_br_catalog.php'

Push-Location $WorkingDirectory
try {
  & $Php $catalogTool export $sourcePath
  if ($LASTEXITCODE -ne 0) { throw 'Could not export the PT-BR catalog source.' }

  $entries = Get-Content -LiteralPath $sourcePath -Raw -Encoding UTF8 | ConvertFrom-Json
  $cache = @{}
  if (Test-Path -LiteralPath $cachePath) {
    $cachedRows = Get-Content -LiteralPath $cachePath -Raw -Encoding UTF8 | ConvertFrom-Json
    foreach ($row in $cachedRows) { $cache[[string]$row.id] = [string]$row.translation }
  }

  $pending = @($entries | Where-Object { -not $cache.ContainsKey([string]$_.id) })
  $batch = New-Object System.Collections.Generic.List[object]
  $batchLength = 0
  $processed = 0

  function Save-Cache {
    $rows = foreach ($key in $cache.Keys) { [ordered]@{ id = $key; translation = $cache[$key] } }
    $rows | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $cachePath -Encoding UTF8
  }

  function Invoke-TranslationBatch([object[]]$Rows) {
    if ($Rows.Count -eq 0) { return }
    $parts = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $Rows.Count; $i++) {
      if ($i -gt 0) { $parts.Add(('ZXQBATCH{0:D4}ZX' -f $i)) }
      $parts.Add([string]$Rows[$i].masked)
    }
    $payload = $parts -join "`n"
    $response = Invoke-RestMethod -Method Post -Uri 'https://translate.googleapis.com/translate_a/single' -Body @{
      client = 'gtx'; sl = 'en'; tl = 'pt'; dt = 't'; q = $payload
    } -TimeoutSec 45
    $translated = (($response[0] | ForEach-Object { [string]$_[0] }) -join '')

    $pattern = '(?m)^ZXQBATCH\d{4}ZX\r?\n?'
    $pieces = [regex]::Split($translated, $pattern)
    if ($pieces.Count -ne $Rows.Count) {
      throw "Translation batch was split into $($pieces.Count) pieces; expected $($Rows.Count)."
    }
    for ($i = 0; $i -lt $Rows.Count; $i++) {
      $cache[[string]$Rows[$i].id] = $pieces[$i].Trim("`r", "`n")
    }
  }

  foreach ($entry in $pending) {
    $length = ([string]$entry.masked).Length
    if ($batch.Count -gt 0 -and ($batchLength + $length) -gt $BatchCharacters) {
      Invoke-TranslationBatch $batch.ToArray()
      $processed += $batch.Count
      Write-Progress -Activity 'Reconstruindo tradução PT-BR' -Status "$processed de $($pending.Count) frases" -PercentComplete (($processed / [Math]::Max(1, $pending.Count)) * 100)
      if (($processed % 250) -lt $batch.Count) { Save-Cache }
      $batch.Clear()
      $batchLength = 0
      Start-Sleep -Milliseconds $DelayMilliseconds
    }
    $batch.Add($entry)
    $batchLength += $length + 24
  }
  Invoke-TranslationBatch $batch.ToArray()
  Save-Cache
  Write-Progress -Activity 'Reconstruindo tradução PT-BR' -Completed

  $result = foreach ($entry in $entries) {
    [ordered]@{ id = [string]$entry.id; translation = [string]$cache[[string]$entry.id] }
  }
  $result | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $translatedPath -Encoding UTF8
  & $Php $catalogTool apply $translatedPath
  if ($LASTEXITCODE -ne 0) { throw 'Could not apply the rebuilt PT-BR catalog.' }
  & $Php $catalogTool audit
} finally {
  Pop-Location
}
