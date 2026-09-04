param(
    [switch]$InstallSystemTools,
    [switch]$InstallGrobidImage,
    [string]$RscriptPath = "C:\Users\jdoliveira\AppData\Local\Programs\R\R-4.5.3\bin\Rscript.exe",
    [string]$VenvPath = "",
    [string]$UnpaywallEmail = "johnny.d-oliveira@inrae.fr"
)

$ErrorActionPreference = "Stop"

function Info($message) {
    Write-Host "[setup] $message"
}

function Command-Exists($name) {
    return $null -ne (Get-Command $name -ErrorAction SilentlyContinue)
}

function Install-WingetPackage($id, $name) {
    if (-not (Command-Exists "winget")) {
        Write-Warning "winget absent: installer manuellement $name ($id)."
        return
    }
    Info "Verification winget: $name"
    $found = winget list --id $id --accept-source-agreements 2>$null
    if ($LASTEXITCODE -eq 0 -and $found -match [regex]::Escape($id)) {
        Info "$name deja installe."
        return
    }
    Info "Installation: $name"
    winget install --id $id --exact --accept-package-agreements --accept-source-agreements
}

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $RepoRoot

if ([string]::IsNullOrWhiteSpace($VenvPath)) {
    $VenvPath = Join-Path (Split-Path $RepoRoot -Parent) ".venv"
}

Info "Repo: $RepoRoot"
Info "Venv: $VenvPath"

if ($InstallSystemTools) {
    Install-WingetPackage "Git.Git" "Git"
    Install-WingetPackage "GitHub.cli" "GitHub CLI"
    Install-WingetPackage "Python.Python.3.11" "Python 3.11"
    Install-WingetPackage "RProject.R" "R"
    Install-WingetPackage "UB-Mannheim.TesseractOCR" "Tesseract OCR"
    Install-WingetPackage "oschwartz10612.Poppler" "Poppler"
    Install-WingetPackage "Docker.DockerDesktop" "Docker Desktop"
}

$TesseractDir = Join-Path $env:LOCALAPPDATA "Tesseract-OCR"
if (Test-Path (Join-Path $TesseractDir "tesseract.exe")) {
    if ($env:Path -notlike "*$TesseractDir*") {
        $env:Path = "$TesseractDir;$env:Path"
    }
    if (-not $env:TESSDATA_PREFIX) {
        $env:TESSDATA_PREFIX = Join-Path $TesseractDir "tessdata"
    }
}

$WingetRoot = Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages"
if (Test-Path $WingetRoot) {
    $PopplerCandidates = Get-ChildItem -Path $WingetRoot -Directory -Filter "oschwartz10612.Poppler*" -ErrorAction SilentlyContinue |
        ForEach-Object { Get-ChildItem -Path $_.FullName -Directory -Filter "poppler-*" -ErrorAction SilentlyContinue } |
        ForEach-Object { Join-Path $_.FullName "Library\bin" } |
        Where-Object { Test-Path (Join-Path $_ "pdftotext.exe") }
    if ($PopplerCandidates) {
        $PopplerBin = @($PopplerCandidates)[-1]
        if ($env:Path -notlike "*$PopplerBin*") {
            $env:Path = "$PopplerBin;$env:Path"
        }
    }
}

if (-not (Test-Path $VenvPath)) {
    Info "Creation du venv Python"
    if (Command-Exists "py") {
        py -3.11 -m venv $VenvPath
    } else {
        python -m venv $VenvPath
    }
}

$Python = Join-Path $VenvPath "Scripts\python.exe"
if (-not (Test-Path $Python)) {
    throw "Python du venv introuvable: $Python"
}

Info "Installation dependances Python"
& $Python -m pip install --upgrade pip setuptools wheel
& $Python -m pip install `
    requests `
    pandas `
    geopandas `
    openpyxl `
    pyyaml `
    beautifulsoup4 `
    lxml `
    rdata `
    anthropic `
    pymupdf `
    pdfminer.six `
    pytest `
    playwright `
    tqdm
& $Python -m playwright install chromium

if (-not (Test-Path $RscriptPath)) {
    $RscriptCmd = Get-Command Rscript -ErrorAction SilentlyContinue
    if ($RscriptCmd) {
        $RscriptPath = $RscriptCmd.Source
    } else {
        throw "Rscript introuvable. Passez -RscriptPath ou installez R."
    }
}

Info "Installation dependances R"
$RSetup = @'
options(repos = c(CRAN = "https://cloud.r-project.org"))

cran_packages <- c(
  "remotes", "pkgload", "devtools", "roxygen2", "testthat",
  "jsonlite", "readr", "dplyr", "tidyr", "purrr", "stringr", "tibble",
  "sf", "terra", "spdep", "spatialreg", "Matrix", "mgcv",
  "parsnip", "workflows", "dials", "tune", "rsample", "yardstick",
  "ranger", "xgboost", "earth", "mboost", "nabor", "reticulate",
  "blockCV", "SpatialML", "spatialRF", "RandomForestsGLS",
  "mgwrsar", "spmoran", "httr2", "rnaturalearth", "tigris",
  "haven", "readxl", "whitebox", "geodata", "units", "lwgeom"
)

installed <- rownames(installed.packages())
missing <- setdiff(cran_packages, installed)
if (length(missing)) {
  install.packages(missing)
}

if (!requireNamespace("spboost", quietly = TRUE)) {
  tryCatch(
    install.packages("spboost"),
    error = function(e) {
      local_spboost <- file.path("raw", "estimators", "spboost_0.6.3", "spboost")
      if (dir.exists(local_spboost)) {
        remotes::install_local(local_spboost, upgrade = "never")
      } else {
        message("spboost non installe: CRAN/local indisponible")
      }
    }
  )
}

remotes::install_local(file.path("packages", "spatialtidymodels"), dependencies = FALSE, upgrade = "never")
'@

$TempR = Join-Path $env:TEMP "llm_wiki_project_setup.R"
Set-Content -LiteralPath $TempR -Value $RSetup -Encoding UTF8
& $RscriptPath $TempR

if ($InstallGrobidImage) {
    if (-not (Command-Exists "docker")) {
        Write-Warning "Docker introuvable: image GROBID non installee."
    } else {
        Info "Telechargement image GROBID"
        docker pull lfoppiano/grobid:latest-crf
    }
}

Info "Verification outils"
git --version
gh --version
& $Python --version
& $RscriptPath --version
if (Command-Exists "tesseract") { tesseract --version | Select-Object -First 1 }
if (Command-Exists "pdftotext") { pdftotext -v }

if ($UnpaywallEmail) {
    $env:UNPAYWALL_EMAIL = $UnpaywallEmail
    Info "UNPAYWALL_EMAIL defini pour cette session: $UnpaywallEmail"
}

Info "Installation terminee. Pour activer le venv:"
Write-Host "& `"$VenvPath\Scripts\Activate.ps1`""

