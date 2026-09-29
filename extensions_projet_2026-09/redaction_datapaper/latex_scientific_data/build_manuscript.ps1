param(
    [string]$Tectonic = "C:\Users\jdoliveira\.codex\.tmp\bundled-marketplaces\openai-bundled\plugins\latex\bin\tectonic.exe",
    [switch]$UseTectonic
)

$ErrorActionPreference = "Stop"
$projectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$buildDir = Join-Path $projectDir "build"
$source = Join-Path $projectDir "manuscript_scientific_data.tex"
$cacheDir = Join-Path $projectDir ".tectonic-cache"

New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
Push-Location $projectDir
try {
    $latexmk = Get-Command latexmk -ErrorAction SilentlyContinue
    if (-not $UseTectonic -and $latexmk) {
        & $latexmk.Source -quiet -pdf -interaction=nonstopmode -halt-on-error "-outdir=$buildDir" $source
        if ($LASTEXITCODE -ne 0) {
            throw "latexmk compilation failed with exit code $LASTEXITCODE"
        }
    } else {
        New-Item -ItemType Directory -Force -Path $cacheDir | Out-Null
        $env:TECTONIC_CACHE_DIR = $cacheDir
        & $Tectonic $source --outdir $buildDir --keep-intermediates --keep-logs --synctex --reruns 1
        if ($LASTEXITCODE -ne 0) {
            throw "Tectonic compilation failed with exit code $LASTEXITCODE"
        }
    }
} finally {
    Pop-Location
}

Write-Host "Built: $(Join-Path $buildDir 'manuscript_scientific_data.pdf')"
