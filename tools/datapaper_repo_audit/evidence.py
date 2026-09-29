"""Topic rules, line-level scanning and file prioritisation.

Evidence is *located*, not interpreted: a rule hit records the exact lines
(path + line range + snippet) that a human must read to confirm the claim.
Every automatic row carries ``confidence='keyword_match'`` and
``review_status='pending'``. File names alone never produce topical
evidence; they only produce ``file_presence`` rows, which the comparison
table does not count as documentation.
"""

from __future__ import annotations

import hashlib
import html
import json
import re
from pathlib import PurePosixPath

# (topic, volet, label FR, grid columns describing it in the article)
DIMENSIONS = [
    ("sources_origin", "collecte", "Origine et nombre des sources intégrées", ["collecte_sources"]),
    ("inclusion_criteria", "collecte", "Critères d'inclusion et d'exclusion", ["selection_inclusion"]),
    ("collection_method", "collecte", "Méthode de collecte ou d'acquisition", ["collecte_sources"]),
    ("scripts_apis_downloads", "collecte", "Scripts, API et téléchargements", ["collecte_sources", "acces_interface"]),
    ("cleaning_join_dedup", "collecte", "Nettoyage, jointure, déduplication", ["harmonisation_transformations", "controle_qualite"]),
    ("transformations_units", "collecte", "Transformations des réponses/prédicteurs et unités", ["harmonisation_transformations"]),
    ("identifiers_groups_time", "collecte", "Identifiants parents, groupes, temps, répétitions", ["unite_principale", "spatial_temporel"]),
    ("spatial_crs", "collecte", "Coordonnées, géométrie, CRS, résolution, rééchantillonnage", ["spatial_temporel"]),
    ("missing_qc_validation", "collecte", "Valeurs manquantes, contrôle qualité, validation manuelle", ["controle_qualite", "validation_technique"]),
    ("original_vs_derived", "collecte", "Données originales / dérivées / augmentées / synthétiques", ["harmonisation_transformations"]),
    ("corpus_levels", "collecte", "Corpus inventorié / analysé / redistribué", ["ampleur_annoncee"]),
    ("tasks_splits_leakage", "benchmark", "Tâches, splits et protections contre les fuites", ["taches_splits_metriques"]),
    ("benchmark_role", "benchmark", "Rôle du benchmark (validation légère ou contribution centrale)", ["validation_technique", "type_article_objet"]),
    ("downloadable_files", "publication", "Fichiers téléchargeables, volume et format", ["acces_interface"]),
    ("license_citation", "publication", "Provenance, licence, redistribution, citation", ["metadonnees_provenance", "licence_version_maintenance"]),
    ("versioning_maintenance", "publication", "Version, maintenance, ajout de nouvelles sources", ["licence_version_maintenance"]),
]
TOPIC_VOLET = {d[0]: d[1] for d in DIMENSIONS} | {"schema_fields": "collecte", "file_presence": "publication"}

I = re.I
DOC_RULES: dict[str, list[re.Pattern]] = {
    "sources_origin": [
        re.compile(r"\b(obtained|downloaded|retrieved|compiled|derived|collected|acquired|sourced|aggregated|integrated)\s+(from|by)\b", I),
        re.compile(r"\b(data|original|primary|upstream)\s+sources?\b", I),
        re.compile(r"\bprovided by\b", I),
    ],
    "inclusion_criteria": [
        re.compile(r"\b(inclusion|exclusion|eligib\w*|selection)\s+(criteri\w+|rules?)\b", I),
        re.compile(r"\b(were|was|are|is)\s+(excluded|included|removed|discarded|retained|kept)\b", I),
        re.compile(r"\b(only|must|required to)\b.{0,40}\b(include|have|contain|satisf)\w*", I),
    ],
    "collection_method": [
        re.compile(r"\b(data\s+collection|collection\s+(protocol|method)|sampling\s+(protocol|design|method)|field\s+(campaign|survey|sampling))\b", I),
        re.compile(r"\b(harvest\w*|scrap(ed|ing)|crawl\w*|queried|web\s+search|literature\s+search|systematic\s+search)\b", I),
    ],
    "scripts_apis_downloads": [
        re.compile(r"\b(API|REST|endpoint|download\s+script|script\w*\s+(to|for|that)\s+(download|fetch|retriev|pars|build|generat))", I),
        re.compile(r"\b(pip install|install\.packages|remotes::install|devtools::install|conda install|git clone)\b", I),
    ],
    "cleaning_join_dedup": [
        re.compile(r"\b(clean(ed|ing)?|de-?duplicat\w*|duplicates?|merg(ed|ing)|join(ed|ing)?|harmoni[sz]\w*|reconcil\w*|standardi[sz]\w*|curat(ed|ion))\b", I),
    ],
    "transformations_units": [
        re.compile(r"\b(units?|log[- ]?transform\w*|transform(ed|ation)s?|normali[sz]\w*|rescal\w*|convert(ed)?\s+(to|from|into)|aggregat(ed|ion))\b", I),
        re.compile(r"(mg/l|µg/l|ug/l|mg\s*l-1|km2|km²|\bha\b|hectares?|°c|\bdegrees?\b|per\s+capita|ppm|ppb)", I),
    ],
    "identifiers_groups_time": [
        re.compile(r"\b(unique\s+)?(identifier|ID)s?\b", re.M),
        re.compile(r"\b(subject|site|sample|patient|lake|station|study)[ _-]?(id|identifier)s?\b", I),
        re.compile(r"\b(repeated\s+(measure\w*|sampl\w*)|longitudinal|time[- ]series|sampl(e|ing)\s+dates?|temporal\s+(extent|resolution|coverage))\b", I),
    ],
    "spatial_crs": [
        re.compile(r"\b(CRS|EPSG|WGS\s?84|NAD\s?83|Albers|UTM|datum|projection|projected|reproject\w*)\b", I),
        re.compile(r"\b(latitude|longitude|coordinates?|geometr\w+|polygons?|raster|shapefiles?|geopackage|spatial\s+(resolution|extent|scale|unit|join)|resampl\w*|buffers?|watersheds?|catchments?|HUC\d*)\b", I),
    ],
    "missing_qc_validation": [
        re.compile(r"\b(missing\s+(values?|data)|NA\s+values|quality\s+(control|assurance|check|flags?)|QA/?QC|QAQC|outliers?|flag(ged|s)?|validat\w+|sanity\s+check\w*|detection\s+limits?|censor\w*)\b", I),
        re.compile(r"\bmanual(ly)?\s+(check\w*|review\w*|curat\w*|inspect\w*|verif\w*|annotat\w*)\b", I),
    ],
    "original_vs_derived": [
        re.compile(r"\b(raw\s+data|original\s+(data|values|format)|derived|processed|synthetic|simulated|augment\w*|generat(ed|or)|imputed|interpolat\w*|modell?ed\s+values?)\b", I),
    ],
    "corpus_levels": [
        re.compile(r"\b\d[\d,]*\s+(data\s?sets|studies|lakes|samples|tasks|instances|projects|graphs|series|sources|datasets|files|records)\b", I),
        re.compile(r"\b(redistribut\w*|not\s+(publicly\s+)?available|restricted\s+access|available\s+(up)?on\s+request|subset\s+of)\b", I),
    ],
    "tasks_splits_leakage": [
        re.compile(r"\b(train(ing)?\s*(/|-|and)?\s*(test|validation)|test\s+set|cross[- ]validation|folds?|hold[- ]?out|data\s+leak\w*|leakage|splits?)\b", I),
        re.compile(r"\b(prediction\s+tasks?|classification\s+tasks?|regression\s+tasks?|learning\s+tasks?)\b", I),
    ],
    "benchmark_role": [
        re.compile(r"\b(benchmark\w*|baselines?|leaderboards?|state[- ]of[- ]the[- ]art|reference\s+(models?|results?))\b", I),
    ],
    "downloadable_files": [
        re.compile(r"\b(download\w*)\b", I),
        re.compile(r"\.(csv|tsv|zip|tar\.gz|tgz|rds|rda|parquet|h5|hdf5|nc|feather|xlsx?|json|biom|txt|mpp|xml|sm|rcp)\b", I),
    ],
    "license_citation": [
        re.compile(r"\b(licen[cs]e[ds]?|CC[- ]?BY(-[A-Z]{2})*|CC0|public\s+domain|MIT\s+License|GPL|Apache|BSD|copyright|terms\s+of\s+use)\b", I),
        re.compile(r"\b(please\s+cite|citation|how\s+to\s+cite|cite\s+(this|the|us))\b", I),
    ],
    "versioning_maintenance": [
        re.compile(r"\b(version\s*\d|v\d+\.\d+|releases?|changelog|change\s+log|NEWS|deprecat\w*|maintain\w*|roadmap)\b", I),
        re.compile(r"\b(contribut(e|ing|ions?)|pull\s+requests?|add(ing)?\s+(a\s+)?new\s+(data\s?sets?|sources?|studies))\b", I),
    ],
}

CODE_RULES: dict[str, list[re.Pattern]] = {
    "scripts_apis_downloads": [
        re.compile(r"(requests\.(get|post)|urllib|urlopen|urlretrieve|\bwget\b|\bcurl\b|download\.file|httr::|RCurl|GET\(|fetch_openml|openml\.(datasets|tasks)|Entrez|boto3|gsutil|kaggle\s+datasets|zenodo|figshare|ftp://|https?://)", I),
    ],
    "cleaning_join_dedup": [
        re.compile(r"(\bmerge\(|left_join|inner_join|full_join|right_join|anti_join|semi_join|pd\.merge|\.join\(|rbind|bind_rows|pd\.concat|drop_duplicates|duplicated\(|distinct\(|\bunique\(|dropna|na\.omit|drop_na|fillna|replace_na)", I),
    ],
    "transformations_units": [
        re.compile(r"(\blog1?p?\(|log10\(|log2\(|sqrt\(|\bscale\(|StandardScaler|MinMaxScaler|normali[sz]e|one.?hot|get_dummies|LabelEncoder|units::|set_units|conv_unit)", I),
    ],
    "identifiers_groups_time": [
        re.compile(r"(group_by\(|groupby\(|GroupKFold|GroupShuffleSplit|\b\w*_id\b|to_datetime|as\.Date|as\.POSIX|lubridate|strptime)", I),
    ],
    "spatial_crs": [
        re.compile(r"(st_transform|st_crs|spTransform|to_crs|set_crs|EPSG|proj4string|\bCRS\(|pyproj|rasterio|\bgdal|terra::project|projectRaster|reproject|st_join|st_intersect|st_buffer|st_area|resample|\bshp\b|\.gpkg|geojson)", I),
    ],
    "missing_qc_validation": [
        re.compile(r"(\bassert\b|stopifnot|is\.na\(|isna\(|isnull\(|notna\(|na_values|\bNaN\b|quality|\bqc_|\bflag|outlier|validate|check_\w+|testthat|pytest|unittest)", I),
    ],
    "original_vs_derived": [
        re.compile(r"(synthetic|simulat\w+|augment\w*|generat\w+|np\.random|set\.seed|random_state|impute|interpolat\w*)", I),
    ],
    "tasks_splits_leakage": [
        re.compile(r"(train_test_split|KFold|StratifiedKFold|GroupKFold|TimeSeriesSplit|LeaveOneOut|cross_val\w*|createFolds|vfold_cv|initial_split|\btrain_idx|\btest_idx|\bleak\w*|holdout)", I),
    ],
    "inclusion_criteria": [
        re.compile(r"(min_samples|min_n\b|threshold|exclude\w*|blacklist|whitelist|keep_ids|filter\(|subset\()", I),
    ],
    "benchmark_role": [
        re.compile(r"(baseline|benchmark|leaderboard|RandomForest|randomForest|xgboost|lightgbm|\bsvm\b|LogisticRegression|roc_auc|accuracy_score|mean_squared_error)", I),
    ],
}

DOC_SUFFIXES = {".md", ".rst", ".txt", ".html", ".htm", ".cff", ".tex", ".rd", ".xml", ".eml"}
CONFIG_SUFFIXES = {".yml", ".yaml", ".toml", ".cfg", ".ini", ".json", ".lock"}
CODE_SUFFIXES = {".py", ".r", ".rmd", ".qmd", ".ipynb", ".sh", ".bash", ".sql", ".m", ".jl", ".js", ".ts", ".java", ".c", ".cpp", ".go", ".pl", ".scala", ".do", ".sas", ".ps1", ".bat", ".mk"}
TABLE_SUFFIXES = {".csv", ".tsv"}
BINARY_SUFFIXES = {
    ".zip", ".gz", ".tgz", ".bz2", ".xz", ".7z", ".rar", ".tar", ".rds", ".rda", ".rdata", ".parquet", ".h5", ".hdf5",
    ".nc", ".feather", ".pkl", ".pickle", ".npy", ".npz", ".png", ".jpg", ".jpeg", ".gif", ".pdf", ".tif", ".tiff",
    ".shp", ".dbf", ".shx", ".gpkg", ".xlsx", ".xls", ".docx", ".pptx", ".mat", ".sav", ".dta", ".sqlite", ".db",
    ".jar", ".exe", ".dll", ".so", ".whl", ".mp4", ".svg", ".ico", ".woff", ".woff2", ".ttf", ".eot", ".biom",
}
BINARY_SUFFIXES.discard(".xlsx")  # read as a spreadsheet (openpyxl), see spreadsheet_lines
SPREADSHEET_SUFFIXES = {".xlsx", ".xlsm"}
ARCHIVE_PATH_RE = re.compile(r"\.(zip|tar\.gz|tgz|tar|tar\.bz2|tar\.xz)$", re.I)
DOC_SPREADSHEET_RE = re.compile(r"(info|metadata|overview|summary|dictionar|codebook|variables?|format|datasets?|parameters|readme|description|sources?)", re.I)
EXCLUDED_DIRS = {".idea", ".vscode", "node_modules", ".git", "site-packages", "venv", ".venv", "__pycache__", "_build", ".ipynb_checkpoints", "vendor", "dist"}
METADATA_TABLE_RE = re.compile(r"(metadata|manifest|schema|dictionar|codebook|variables?|tasks?|sources?|datasets?|catalog|index|readme|description)", I)
# Registries that enumerate the resource's own content (datasets, tasks, sources...).
REGISTRY_STEM_RE = re.compile(r"^(tasks|datasets|manifest|catalog(ue)?|metadata|sources|variables|data_dictionary|dictionary|codebook|studies|index)$", I)
DATA_DIR_RE = re.compile(r"^(data|datasets?|test_data|testdata|raw|raw_data|instances|input|output|results)$", I)
# Topics a file may document, by kind: a licence text only documents the licence,
# CI/build configuration only dependencies, versions and licence.
LICENSE_TOPICS = {"license_citation"}
CONFIG_TOPICS = {"scripts_apis_downloads", "versioning_maintenance", "license_citation"}
SCRIPT_NAME_RE = re.compile(r"(download|fetch|collect|scrap|harvest|ingest|pars(e|er)|clean|process|prep|build|make|merge|join|convert|import|crs|project|split|task|generat|valid|check|qc|quality|export|pipeline|workflow)", I)


def suffix(path: str) -> str:
    name = PurePosixPath(path).name.lower()
    if name.endswith(".tar.gz"):
        return ".tar.gz"
    return PurePosixPath(name).suffix


def file_class(path: str) -> str:
    """doc | config | code | table | binary | other."""
    p = PurePosixPath(path)
    name = p.name.lower()
    ext = suffix(path)
    if ext in SPREADSHEET_SUFFIXES:
        return "spreadsheet"
    if ext in BINARY_SUFFIXES or ext == ".tar.gz":
        return "binary"
    if name.startswith(("readme", "license", "licence", "copying", "citation", "contributing", "changelog", "news", "history", "authors")):
        return "doc"
    if name in {"description", "namespace", "makefile", "snakefile", "dockerfile", "codemeta.json"}:
        return "config"
    if ext in CODE_SUFFIXES:
        return "code"
    if ext in {".txt", ".csv", ".tsv"} and REGISTRY_STEM_RE.match(PurePosixPath(name).stem):
        return "table"
    if ext in {".txt", ".csv", ".tsv"} and any(DATA_DIR_RE.match(part) for part in p.parts[:-1]):
        return "table"  # a data file (OTU table, mapping, instance): header only, never prose
    if ext in DOC_SUFFIXES:
        return "doc"
    if ext in CONFIG_SUFFIXES:
        return "config"
    if ext in TABLE_SUFFIXES:
        return "table"
    return "other"


def priority(path: str, size: int | None, focus_paths: list[str] | None = None) -> int:
    """Higher = inspected first; 0 = never inspected."""
    if focus_paths and path in focus_paths:
        return 200
    p = PurePosixPath(path)
    if any(part in EXCLUDED_DIRS for part in p.parts[:-1]):
        return 0
    name = p.name.lower()
    depth = len(p.parts) - 1
    cls = file_class(path)
    if cls == "binary":
        return 0
    if cls == "spreadsheet":
        # Documentation workbooks (dataset overviews, formats, dictionaries), not data sheets.
        if DOC_SPREADSHEET_RE.search(name) or "doc" in path.lower() or "metadata" in path.lower():
            return 75 - depth
        return 0
    if name.endswith((".min.js", ".min.css", ".css", ".map")) or name in {".editorconfig", ".gitignore", ".rbuildignore", ".gitattributes", ".ds_store"}:
        return 0
    if name.startswith(("readme", "citation.cff", "codemeta.json", "license", "licence", "copying")):
        return 120 - 5 * depth
    if name.startswith(("contributing", "changelog", "news", "history")) or name in {"description"}:
        return 95 - 2 * depth
    if re.search(r"(datasheet|datacard|data_card|data-card|dictionary|codebook|schema|metadata|eml)", name):
        return 90 - depth
    if ".github/workflows" in path or name in {"setup.py", "setup.cfg", "pyproject.toml", "environment.yml", "environment.yaml", "makefile", "snakefile", "dockerfile", "renv.lock", "namespace"} or name.startswith("requirements"):
        return 80 - depth
    if cls == "doc" and ("doc" in path.lower() or depth == 0):
        return 85 - depth
    if cls == "code":
        base = 70 if SCRIPT_NAME_RE.search(path) else 50
        if re.search(r"(^|/)tests?/|test_", path.lower()):
            base = 60
        return base - depth
    if cls == "table":
        if size is not None and size > 512 * 1024:
            return 0
        if REGISTRY_STEM_RE.match(PurePosixPath(name).stem) and depth <= 2:
            return 88 - depth
        return 40 if METADATA_TABLE_RE.search(name) else 0
    if cls == "doc":
        return 45 - depth
    if cls == "config":
        return 35 - depth
    return 0


def select_files(files: list[dict], max_files: int, max_file_bytes: int, focus_paths: list[str] | None = None) -> list[dict]:
    ranked = []
    for f in files:
        size = f.get("size")
        score = priority(f["path"], size, focus_paths)
        if score <= 0:
            continue
        if size is not None and size > max_file_bytes:
            continue
        ranked.append((-score, f["path"], f))
    ranked.sort(key=lambda t: (t[0], t[1]))
    return [f for _, _, f in ranked[:max_files]]


# -- text preparation ------------------------------------------------------------
TAG_RE = re.compile(r"<[^>]+>")


def html_to_text(raw: str) -> str:
    raw = re.sub(r"(?is)<(script|style)\b.*?</\1>", " ", raw)
    raw = re.sub(r"(?i)<br\s*/?>|</(p|div|li|h[1-6]|tr)>", "\n", raw)
    text = html.unescape(TAG_RE.sub(" ", raw))
    return "\n".join(re.sub(r"[ \t]+", " ", line).strip() for line in text.splitlines() if line.strip())


def notebook_lines(raw: str) -> list[tuple[str, str, str]]:
    """(location, kind, text) for every line of every cell of a notebook."""
    try:
        nb = json.loads(raw)
    except ValueError:
        return []
    out = []
    for ci, cell in enumerate(nb.get("cells", []), start=1):
        src = cell.get("source", "")
        src = "".join(src) if isinstance(src, list) else src
        kind = "doc" if cell.get("cell_type") == "markdown" else "code"
        for li, line in enumerate(src.splitlines(), start=1):
            out.append((f"cell {ci} line {li}", kind, line))
    return out


def spreadsheet_lines(content: bytes, max_rows_per_sheet: int = 500, max_lines: int = 5000) -> list[tuple[str, str]]:
    """(location, text) per non-empty row of every sheet: 'sheet X row N', cells joined by ' | '.

    Raises ImportError when openpyxl is unavailable (caller records the skip).
    """
    import io as _io

    import openpyxl

    wb = openpyxl.load_workbook(_io.BytesIO(content), read_only=True, data_only=True)
    out: list[tuple[str, str]] = []
    try:
        for ws in wb.worksheets:
            for r, row in enumerate(ws.iter_rows(values_only=True), start=1):
                if r > max_rows_per_sheet or len(out) >= max_lines:
                    break
                cells = [str(c).strip() for c in row if c is not None and str(c).strip()]
                if cells:
                    out.append((f"sheet '{ws.title}' row {r}", " | ".join(cells)[:1500]))
    finally:
        wb.close()
    return out


def is_lfs_pointer(content: bytes) -> bool:
    return content.startswith(b"version https://git-lfs.github.com/spec")


def is_binary(content: bytes) -> bool:
    return b"\x00" in content[:8192]


# -- scanning ---------------------------------------------------------------------
def evidence_id(*parts) -> str:
    return hashlib.sha1("|".join(str(p) for p in parts).encode("utf-8")).hexdigest()[:16]


def scan_lines(lines: list[str], kind: str, *, max_per_topic: int = 4, context: int = 1, topics: set[str] | None = None) -> list[dict]:
    """Return hits ``{topic, rule, line_start, line_end, snippet}`` for ``kind`` in {doc, code}.

    Consecutive matching lines of one topic are merged into a single hit.
    """
    rules = DOC_RULES if kind == "doc" else CODE_RULES
    hits: list[dict] = []
    for topic, patterns in rules.items():
        if topics and topic not in topics:
            continue
        count = 0
        last_end = -10
        for idx, line in enumerate(lines):
            if len(line) > 2000:
                line = line[:2000]
            match = next((m for pat in patterns if (m := pat.search(line))), None)
            if not match:
                continue
            lineno = idx + 1
            if hits and hits[-1]["topic"] == topic and lineno <= last_end + 1:
                hits[-1]["line_end"] = min(len(lines), lineno + context)
                last_end = lineno
                continue
            if count >= max_per_topic:
                break
            start = max(1, lineno - context)
            end = min(len(lines), lineno + context)
            hits.append({"topic": topic, "rule": match.group(0)[:80], "line_start": start, "line_end": end, "match_line": lineno})
            count += 1
            last_end = lineno
    for hit in hits:
        snippet = "\n".join(lines[hit["line_start"] - 1 : hit["line_end"]])
        hit["snippet"] = snippet[:600]
    return hits


def topics_for(path: str, cls: str) -> set[str] | None:
    """Topic restriction for a file (None = all topics)."""
    name = PurePosixPath(path.split("!")[-1]).name.lower()
    if name.startswith(("license", "licence", "copying")):
        return LICENSE_TOPICS
    if cls == "config" or ".github/workflows" in path:
        return CONFIG_TOPICS
    return None


def scan_document(text: str, cls: str, **kw) -> list[dict]:
    """Scan a decoded file; ``cls`` from :func:`file_class`."""
    if cls == "code":
        lines = text.splitlines()
        code_hits = scan_lines(lines, "code", **kw)
        # Comments and docstrings in code count as documentation of that code.
        comment_lines = [l if re.match(r"\s*(#|//|%|--|\"\"\"|''')", l) else "" for l in lines]
        doc_hits = scan_lines(comment_lines, "doc", **kw)
        for h in doc_hits:
            h["snippet"] = "\n".join(lines[h["line_start"] - 1 : h["line_end"]])[:600]
            h["from_comment"] = True
        return [dict(h, kind="code") for h in code_hits] + [dict(h, kind="doc") for h in doc_hits]
    if cls == "table":
        lines = text.splitlines()
        if not lines:
            return []
        n_rows = sum(1 for l in lines[1:] if l.strip())
        return [{"topic": "schema_fields", "rule": "table_header", "line_start": 1, "line_end": 1, "match_line": 1,
                 "snippet": f"{lines[0][:500]}  [{n_rows} data rows]", "kind": "schema_header"}]
    lines = text.splitlines()
    return [dict(h, kind="doc") for h in scan_lines(lines, "doc", **kw)]
