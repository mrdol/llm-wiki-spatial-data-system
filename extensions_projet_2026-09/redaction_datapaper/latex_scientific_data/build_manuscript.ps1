param(
    [string]$Tectonic = "C:\Users\jdoliveira\.codex\.tmp\bundled-marketplaces\openai-bundled\plugins\latex\bin\tectonic.exe"
)

$ErrorActionPreference = "Stop"
$projectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$buildDir = Join-Path $projectDir "build"
$source = Join-Path $projectDir "manuscript_scientific_data.tex"
$cacheDir = Join-Path $projectDir ".tectonic-cache"

New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
New-Item -ItemType Directory -Force -Path $cacheDir | Out-Null
$env:TECTONIC_CACHE_DIR = $cacheDir
& $Tectonic $source --outdir $buildDir --keep-intermediates --keep-logs --synctex --reruns 1
if ($LASTEXITCODE -ne 0) {
    throw "Tectonic compilation failed with exit code $LASTEXITCODE"
}

Write-Host "Built: $(Join-Path $buildDir 'manuscript_scientific_data.pdf')"
