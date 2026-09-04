# Installation et reinstallation de l'environnement

Ce document decrit les outils necessaires pour refaire tourner le projet
`llm-wiki-spatial-data-system` sur Windows.

Le projet combine :

- des scripts Python pour la collecte, le KG, les manifests et les PDF ;
- des scripts R pour les datasets `sf`, les fiches et le package
  `spatialtidymodels` ;
- des outils externes pour les PDF/OCR ;
- GROBID via Docker pour convertir les PDF scientifiques en TEI.

## Ordre recommande

Installer dans cet ordre limite les conflits :

1. Git + GitHub CLI.
2. Python + environnement virtuel.
3. R.
4. Outils PDF/OCR : Poppler puis Tesseract.
5. Docker Desktop + image GROBID.
6. Packages Python.
7. Packages R.
8. Package local `packages/spatialtidymodels`.
9. Verification finale.

Un script PowerShell est fourni :

```powershell
.\tools\setup_project_environment.ps1
```

Par defaut, le script verifie l'environnement et installe les dependances
Python/R dans les environnements locaux. Pour autoriser aussi l'installation
des outils systeme avec `winget` :

```powershell
.\tools\setup_project_environment.ps1 -InstallSystemTools
```

Pour tirer aussi l'image Docker de GROBID :

```powershell
.\tools\setup_project_environment.ps1 -InstallSystemTools -InstallGrobidImage
```

## Outils systeme attendus

| Outil | Role | Verification |
|---|---|---|
| Git | versionnement | `git --version` |
| GitHub CLI (`gh`) | login GitHub, PR, auth SSH | `gh --version`, `gh auth status` |
| Python | scripts du projet | `python --version` |
| R / Rscript | loaders, fiches, package | `Rscript --version` ou chemin explicite |
| Poppler | `pdftotext`, `pdftoppm`, `pdfunite` pour PDF/Biblio_from_pdf | `pdftotext -v` |
| Tesseract | OCR quand PDF scanne | `tesseract --version` |
| Docker Desktop | GROBID | `docker --version` |
| GROBID | PDF -> TEI | `http://localhost:8070` |

Sur cette machine, `Rscript` peut ne pas etre dans le `PATH`. Le chemin connu
est :

```powershell
C:\Users\jdoliveira\AppData\Local\Programs\R\R-4.5.3\bin\Rscript.exe
```

## Variables d'environnement

Les secrets restent locaux et ne doivent pas etre commit :

```text
.env
2.env
claude_key.env
```

Variables utiles :

| Variable | Role |
|---|---|
| `ANTHROPIC_API_KEY` | verification LLM des candidats DataCite |
| `UNPAYWALL_EMAIL` | etiquette API Unpaywall |
| `DRYAD_*` | acces API Dryad si un compte API est configure |
| `TESSDATA_PREFIX` | donnees de langue Tesseract |
| `R_SCRIPT` | chemin explicite vers `Rscript.exe` |

Exemple temporaire dans PowerShell :

```powershell
$env:ANTHROPIC_API_KEY = "..."
$env:UNPAYWALL_EMAIL = "johnny.d-oliveira@inrae.fr"
$env:R_SCRIPT = "C:\Users\jdoliveira\AppData\Local\Programs\R\R-4.5.3\bin\Rscript.exe"
```

## Python

Le projet utilise de preference le venv situe au niveau du dossier parent :

```text
C:\Users\jdoliveira\SynologyDrive\johnny D'OLIVEIRA\Travaux stages\.venv
```

Activation :

```powershell
& "..\.venv\Scripts\Activate.ps1"
python --version
```

Dependances principales :

```powershell
python -m pip install --upgrade pip setuptools wheel
python -m pip install requests pandas geopandas openpyxl pyyaml beautifulsoup4 lxml rdata anthropic pymupdf pdfminer.six pytest playwright tqdm
python -m playwright install chromium
```

`tools/kg/requirements.txt` contient la dependance minimale KG explicite
(`rdata`), mais les pipelines recents utilisent aussi les packages ci-dessus.

## R

Le package local est :

```text
packages/spatialtidymodels
```

Dependances principales lues dans `packages/spatialtidymodels/DESCRIPTION` et
dans les scripts `code/r_catalog/*.R` :

```r
install.packages(c(
  "remotes", "pkgload", "devtools", "roxygen2", "testthat",
  "jsonlite", "readr", "dplyr", "tidyr", "purrr", "stringr", "tibble",
  "sf", "terra", "spdep", "spatialreg", "Matrix", "mgcv",
  "parsnip", "workflows", "dials", "tune", "rsample", "yardstick",
  "ranger", "xgboost", "earth", "mboost", "nabor", "reticulate",
  "blockCV", "SpatialML", "spatialRF", "RandomForestsGLS",
  "mgwrsar", "spmoran", "httr2", "rnaturalearth", "tigris",
  "haven", "readxl", "whitebox", "geodata", "units", "lwgeom"
))
```

Installer ensuite le package local :

```r
remotes::install_local("packages/spatialtidymodels", dependencies = FALSE, upgrade = "never")
```

Verification :

```powershell
& "C:\Users\jdoliveira\AppData\Local\Programs\R\R-4.5.3\bin\Rscript.exe" -e "setwd('packages/spatialtidymodels'); pkgload::load_all(quiet=TRUE); testthat::test_file('tests/testthat/test-metadata-registry.R')"
```

## PDF, OCR et Biblio_from_pdf

`Biblio_from_pdf` est un dossier frere du projet :

```text
C:\Users\jdoliveira\SynologyDrive\johnny D'OLIVEIRA\Travaux stages\Biblio_from_pdf
```

Le projet l'utilise comme sas temporaire pour generer des BibTeX propres
depuis les PDF deja valides.

Commandes :

```powershell
python tools/stage_biblio_from_pdf_datacite.py --phase commands
python tools/stage_biblio_from_pdf_datacite.py --phase prepare
python tools/stage_biblio_from_pdf_datacite.py --phase pdf2bib-dry-run
python tools/stage_biblio_from_pdf_datacite.py --phase pdf2bib-apply
python tools/stage_biblio_from_pdf_datacite.py --phase import-dry-run
python tools/stage_biblio_from_pdf_datacite.py --phase import-apply
python tools/stage_biblio_from_pdf_datacite.py --phase dedupe-dry-run
python tools/stage_biblio_from_pdf_datacite.py --phase dedupe-apply
```

## GROBID

GROBID tourne avec Docker :

```powershell
docker run --rm -p 8070:8070 lfoppiano/grobid:latest-crf
```

Laisser cette fenetre ouverte, puis dans une autre fenetre :

```powershell
python tools/kg/02_run_grobid.py --from-bib
```

Ou pour relancer toute la chaine KG avec GROBID :

```powershell
python tools/kg/run_all.py --run-grobid --from-bib
```

Sans GROBID :

```powershell
python tools/kg/run_all.py
```

## Pipelines principaux

Harvest DataCite :

```powershell
python tools/run_datacite_harvest_pipeline.py `
  --target 300 `
  --openalex-limit 700 `
  --min-citations 5 `
  --crossref-workers 4 `
  --min-dataset-size-kb 200 `
  --profiles core,agriculture_economic,public_health,natural_hazards `
  --strict-spatial-only `
  --rscript "C:\Users\jdoliveira\AppData\Local\Programs\R\R-4.5.3\bin\Rscript.exe"
```

Telechargement legal de PDF par DOI :

```powershell
python tools/pdf_resolver.py --doi 10.1111/ele.14478
```

Avec navigateur Playwright si les routes API/OA ne suffisent pas :

```powershell
python tools/pdf_resolver.py --doi 10.1111/ele.14478 --use-playwright
```

Controler la readiness des fiches papier :

```powershell
python tools/check_paper_benchmark_readiness.py
```

Exporter les metadonnees package :

```powershell
python code/package_metadata/export_spatialtidymodels_metadata.py
```

## Serveurs MCP locaux (`mcp_servers/`)

Le dossier `mcp_servers/` contient des serveurs MCP (Model Context Protocol)
locaux qui donnent a Claude Code des outils supplementaires specifiques a ce
projet (recherche dans le catalogue dataset, memoire du code, compression du
contexte). Voir `mcp_servers/MCP_ARCHITECTURE.md` pour le detail des fichiers.

| Fichier | Type | Role |
|---|---|---|
| `dataset_search_server.py` | serveur MCP (stdio) | recherche, audit et validation du catalogue dataset (`data/catalogue_datasets.json`) |
| `codebase_memory_server.py` | serveur MCP (stdio) | indexe fichiers/symboles/imports dans `.codex_memory/code_index.sqlite` |
| `context_store_server.py` | serveur MCP (stdio) | stocke les grosses sorties terminal dans `.codex_memory/outputs/` et renvoie des resumes |
| `rtk_server.py` | serveur MCP (stdio) | compresse les sorties terminal petites/moyennes, sans stockage |
| `headroom_server.py` | serveur MCP (stdio) | compresse un paquet global de prompt/contexte |
| `headroom.py`, `token_slimming.py` | modules internes | logique de compression, importes par les serveurs ci-dessus, jamais lances directement |
| `headroom_proxy.py` | proxy HTTP autonome | relaie et compresse des requetes vers l'API OpenAI (n'est pas un serveur MCP) |

### Dependance Python

Les serveurs utilisent le SDK officiel `mcp` (avec `FastMCP`). Il est deja
inclus dans les dependances principales du projet ; sinon :

```powershell
python -m pip install "mcp[cli]"
```

### Enregistrer les serveurs aupres de Claude Code

Chaque serveur `*_server.py` communique en stdio et s'enregistre avec
`claude mcp add` (a executer une fois, depuis la racine du projet). Utiliser
le meme interpreteur Python que le reste du projet :

```powershell
claude mcp add dataset-search -- "..\.venv\Scripts\python.exe" "mcp_servers\dataset_search_server.py"
claude mcp add codebase-memory -- "..\.venv\Scripts\python.exe" "mcp_servers\codebase_memory_server.py"
claude mcp add context-store -- "..\.venv\Scripts\python.exe" "mcp_servers\context_store_server.py"
claude mcp add rtk -- "..\.venv\Scripts\python.exe" "mcp_servers\rtk_server.py"
claude mcp add headroom -- "..\.venv\Scripts\python.exe" "mcp_servers\headroom_server.py"
```

Verification :

```powershell
claude mcp list
```

Cela cree (ou met a jour) un `.mcp.json` local. Ce fichier n'est pas commit
par defaut : chaque poste doit relancer ces commandes une fois apres avoir
clone le depot.

### Proxy Headroom (optionnel)

`headroom_proxy.py` n'est pas un serveur MCP : c'est un proxy HTTP autonome
a lancer separement si on veut compresser les requetes vers l'API OpenAI
(distinct de `ANTHROPIC_API_KEY`) :

```powershell
$env:OPENAI_API_KEY = "..."
python mcp_servers/headroom_proxy.py --port 8787
```

Puis pointer le client OpenAI vers `http://127.0.0.1:8787` au lieu de
`https://api.openai.com`.

### Stockage local genere

`.codex_memory/` (index SQLite + sorties terminal stockees) est cree
automatiquement au premier usage des serveurs memoire/contexte. Comme les
autres dossiers locaux, il ne doit pas etre commit (voir section suivante).

## Ce qui n'est pas versionne

Ces dossiers/fichiers sont locaux :

```text
.env
2.env
data/raw/
data/data_retrievals/
data/browser_profiles/
corpus/papers/tei/
.kg/
.codex_memory/
.mcp.json
```

Ils peuvent etre necessaires pour relancer des traitements, mais ils ne doivent
pas etre pousses vers GitHub.

## Verification rapide apres installation

```powershell
git --version
gh --version
python --version
tesseract --version
pdftotext -v
```

R avec chemin explicite :

```powershell
& "C:\Users\jdoliveira\AppData\Local\Programs\R\R-4.5.3\bin\Rscript.exe" --version
```

Python/KG :

```powershell
python tools/kg/07_export_agent_index.py stats
```

Package :

```powershell
& "C:\Users\jdoliveira\AppData\Local\Programs\R\R-4.5.3\bin\Rscript.exe" -e "setwd('packages/spatialtidymodels'); pkgload::load_all(quiet=TRUE); print(available_benchmark_datasets())"
```

