"""Verification legere du contenu d'un depot de donnees, sans telechargement.

Module partage entre:
- tools/check_dataset_availability.py (verification precoce, juste apres le
  harvest DataCite, avant tout PDF/GROBID/ingestion KG)
- tools/download_curated_paper_datasets.py (meme verification refaite juste
  avant le telechargement reel, en garde-fou final)

Le but est de detecter, a partir du seul listing de fichiers d'un depot
(figshare/Dataverse/Dryad), si celui-ci ressemble a une vraie microdonnee
exploitable ou a un miroir de "data availability" d'article (SciELO et
equivalents republient automatiquement les figures/tableaux de CHAQUE article
comme un "dataset", independamment de l'existence d'une vraie microdonnee).
"""

from __future__ import annotations

import os
import re
import urllib.parse
from pathlib import Path
from typing import Any

import requests


UA = {"User-Agent": "llm-wiki-spatial-data-system/0.1 (johnny.d-oliveira@inrae.fr)"}
ROOT = Path(__file__).resolve().parent.parent
_DRYAD_TOKEN_CACHE: str | None = None


def load_local_env() -> None:
    """Load local .env files without overriding the process environment."""
    for env_name in (".env", "2.env"):
        env_path = ROOT / env_name
        if not env_path.exists():
            continue
        for raw_line in env_path.read_text(encoding="utf-8").splitlines():
            line = raw_line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, value = line.split("=", 1)
            key = key.strip()
            value = value.strip().strip('"').strip("'")
            if key and key not in os.environ:
                os.environ[key] = value


def dryad_access_token() -> str | None:
    """Return a Dryad bearer token, using either a provided token or OAuth."""
    global _DRYAD_TOKEN_CACHE
    load_local_env()
    token = os.environ.get("DRYAD_ACCESS_TOKEN") or os.environ.get("DRYAD_API_TOKEN")
    if token:
        return token
    if _DRYAD_TOKEN_CACHE:
        return _DRYAD_TOKEN_CACHE

    client_id = os.environ.get("DRYAD_CLIENT_ID")
    client_secret = os.environ.get("DRYAD_CLIENT_SECRET")
    if not client_id or not client_secret:
        return None

    resp = requests.post(
        "https://datadryad.org/oauth/token",
        data={
            "client_id": client_id,
            "client_secret": client_secret,
            "grant_type": "client_credentials",
        },
        headers={"Content-Type": "application/x-www-form-urlencoded;charset=UTF-8", **UA},
        timeout=30,
    )
    resp.raise_for_status()
    _DRYAD_TOKEN_CACHE = resp.json().get("access_token")
    return _DRYAD_TOKEN_CACHE


def request_headers(repo: str | None = None) -> dict[str, str]:
    headers = dict(UA)
    if repo == "dryad":
        token = dryad_access_token()
        if token:
            headers["Authorization"] = f"Bearer {token}"
    return headers

# Fichiers qui sont presque toujours des figures/tableaux d'article republies
# comme "dataset" (obligation de data availability des revues), pas une
# microdonnee exploitable pour un benchmark.
SUPPLEMENT_TABLE_RX = re.compile(r"^table[_\s]?\d+\.(xlsx?|docx?|csv)$", re.IGNORECASE)
SUPPLEMENT_FIGURE_RX = re.compile(r"\.(jpe?g|png|gif|tiff?|bmp)$", re.IGNORECASE)
SUPPLEMENT_DOC_RX = re.compile(r"^(sm\d+|supp(lement(ary)?)?[-_ ]?(file|material|info|data)?\d*)\.(docx?|pdf)$", re.IGNORECASE)
# Formats qui indiquent une vraie microdonnee structuree/geospatiale.
REAL_DATA_FORMAT_RX = re.compile(
    r"\.(csv|tsv|shp|shx|dbf|prj|geojson|gpkg|gdb|kml|gml|nc|tif|tiff|rds|rdata|"
    r"dta|sav|parquet|zip|sqlite|db|json|txt)$",
    re.IGNORECASE,
)

# Formats raster/imagerie purs : une grille de valeurs sans variables Y/X
# explicitement identifiables (pas de table observation x variable).
RASTER_OR_IMAGE_FORMAT_RX = re.compile(
    r"\.(tif|tiff|nc|nc4|img|jp2|hdf|hdf5|grd|bil|bip|bsq|vrt|asc|jpe?g|png|gif|bmp)$",
    re.IGNORECASE,
)
# Formats vecteur/tabulaire : une table observation x variable, avec une
# dependante, des independantes et (pour le vecteur) une geometrie associee.
VECTOR_TABULAR_FORMAT_RX = re.compile(
    r"\.(csv|tsv|shp|geojson|gpkg|gdb|kml|gml|dta|sav|parquet|rds|rdata|"
    r"xlsx?|json|txt|sqlite|db)$",
    re.IGNORECASE,
)


def classify_spatial_structure(files: list[dict[str, Any]]) -> tuple[bool, str]:
    """Determine si le depot contient au moins un fichier vecteur/tabulaire
    avec variables identifiables (Y/X), pas seulement du raster/imagerie.

    Utilise pour le Bloc 3 (entrepots sans papier associe) : sans un papier
    pour justifier qu'un raster brut EST la donnee d'interet, on exige une
    structure observation x variable exploitable directement pour une
    regression (table avec reponse, covariables, et une dimension spatiale -
    coordonnees ou geometrie).
    """
    if not files:
        return False, "listing vide"

    names = [f.get("name") or "" for f in files]
    has_vector_tabular = any(
        bool(VECTOR_TABULAR_FORMAT_RX.search(n))
        and not SUPPLEMENT_TABLE_RX.match(n)
        and not SUPPLEMENT_DOC_RX.match(n)
        for n in names
    )
    if has_vector_tabular:
        return True, "au moins un fichier vecteur/tabulaire detecte (Y/X potentiellement identifiables)"

    all_raster_or_image = all(bool(RASTER_OR_IMAGE_FORMAT_RX.search(n)) for n in names)
    if all_raster_or_image:
        return False, "uniquement du raster/imagerie - aucune variable Y/X tabulaire identifiable, hors perimetre Bloc 3"

    return False, "aucun format vecteur/tabulaire reconnu - verification manuelle recommandee"


# Page de citation generique presente sur toute instance Dataverse (Harvard,
# CSUC, Borealis, Consorcio Madrono, etc.) - permet de detecter le logiciel
# independamment du nom de domaine.
DATAVERSE_CITATION_RX = re.compile(r"https?://([^/]+)/citation\?persistentId=doi:", re.IGNORECASE)
SCIENCEBASE_ITEM_RX = re.compile(r"sciencebase\.gov/catalog/item/([a-f0-9]+)", re.IGNORECASE)
B2SHARE_RECORD_RX = re.compile(r"b2share\.eudat\.eu/records/([a-zA-Z0-9_-]+)", re.IGNORECASE)


def repo_from_url(url: str) -> str:
    url = url or ""
    if "figshare.com" in url:
        return "figshare"
    if "dataverse.harvard.edu" in url or DATAVERSE_CITATION_RX.search(url):
        return "dataverse"
    if "datadryad.org" in url:
        return "dryad"
    if "zenodo.org" in url:
        return "zenodo"
    if "mendeley.com" in url:
        return "mendeley"
    if "purr.purdue.edu" in url:
        return "purr"
    if "sciencebase.gov" in url:
        return "sciencebase"
    if "pangaea.de" in url:
        return "pangaea"
    if "b2share.eudat.eu" in url:
        return "b2share"
    return "unknown"


def figshare_files(dataset_doi: str) -> list[dict[str, Any]]:
    r = requests.get("https://api.figshare.com/v2/articles", params={"doi": dataset_doi}, timeout=30, headers=UA)
    r.raise_for_status()
    hits = r.json()
    if not hits:
        return []
    article_id = hits[0]["id"]
    r2 = requests.get(f"https://api.figshare.com/v2/articles/{article_id}", timeout=30, headers=UA)
    r2.raise_for_status()
    return [
        {"name": f["name"], "size": f["size"], "url": f["download_url"]}
        for f in r2.json().get("files", [])
    ]


def dataverse_files(dataset_doi: str, data_access_url: str = "") -> list[dict[str, Any]]:
    # Le meme logiciel Dataverse tourne sur des dizaines de domaines (Harvard,
    # CSUC, Borealis, Consorcio Madrono...) - l'hote est extrait de l'URL de
    # citation plutot que suppose fixe sur dataverse.harvard.edu.
    match = DATAVERSE_CITATION_RX.search(data_access_url or "")
    host = match.group(1) if match else "dataverse.harvard.edu"
    persistent_id = f"doi:{dataset_doi}" if not dataset_doi.lower().startswith("doi:") else dataset_doi
    r = requests.get(
        f"https://{host}/api/datasets/:persistentId",
        params={"persistentId": persistent_id},
        timeout=30,
        headers=UA,
    )
    r.raise_for_status()
    files = r.json().get("data", {}).get("latestVersion", {}).get("files", [])
    out = []
    for f in files:
        df = f.get("dataFile", {})
        out.append(
            {
                "name": df.get("filename"),
                "size": df.get("filesize") or 0,
                "url": f"https://{host}/api/access/datafile/{df.get('id')}",
            }
        )
    return out


def sciencebase_files(data_access_url: str) -> list[dict[str, Any]]:
    match = SCIENCEBASE_ITEM_RX.search(data_access_url or "")
    if not match:
        return []
    item_id = match.group(1)
    r = requests.get(
        f"https://www.sciencebase.gov/catalog/item/{item_id}",
        params={"format": "json", "fields": "files,title"},
        timeout=30,
        headers=UA,
    )
    r.raise_for_status()
    out = []
    for f in r.json().get("files", []) or []:
        out.append(
            {
                "name": f.get("name"),
                "size": f.get("size") or 0,
                "url": f.get("downloadUri") or f.get("url"),
            }
        )
    return out


def b2share_files(data_access_url: str) -> list[dict[str, Any]]:
    match = B2SHARE_RECORD_RX.search(data_access_url or "")
    if not match:
        return []
    record_id = match.group(1)
    r = requests.get(f"https://b2share.eudat.eu/api/records/{record_id}", timeout=30, headers=UA)
    r.raise_for_status()
    entries = r.json().get("files", {}).get("entries", {})
    out = []
    for name, meta in entries.items():
        links = meta.get("links", {})
        out.append(
            {
                "name": name,
                "size": meta.get("size") or 0,
                "url": links.get("content") or links.get("self"),
            }
        )
    return out


def pangaea_files(dataset_doi: str) -> list[dict[str, Any]]:
    r = requests.get(
        f"https://doi.pangaea.de/{dataset_doi}",
        params={"format": "metadata_jsonld"},
        timeout=30,
        headers=UA,
    )
    r.raise_for_status()
    distribution = r.json().get("distribution") or []
    out = []
    for item in distribution:
        url = item.get("contentUrl")
        if not url:
            continue
        size = 0
        try:
            head = requests.head(url, timeout=20, headers=UA, allow_redirects=True)
            size = int(head.headers.get("Content-Length") or 0)
        except Exception:  # noqa: BLE001
            pass
        out.append({"name": url.rsplit("/", 1)[-1], "size": size, "url": url})
    return out


def dryad_files(dataset_doi: str) -> list[dict[str, Any]]:
    enc = urllib.parse.quote(f"doi:{dataset_doi}", safe="")
    headers = request_headers("dryad")
    r = requests.get(f"https://datadryad.org/api/v2/datasets/{enc}", timeout=30, headers=headers)
    r.raise_for_status()
    ver_link = r.json().get("_links", {}).get("stash:version", {}).get("href")
    if not ver_link:
        return []
    r2 = requests.get(f"https://datadryad.org{ver_link}/files", timeout=30, headers=headers)
    r2.raise_for_status()
    out = []
    for f in r2.json().get("_embedded", {}).get("stash:files", []):
        download_href = f.get("_links", {}).get("stash:download", {}).get("href")
        out.append(
            {
                "name": f.get("path"),
                "size": f.get("size") or 0,
                "url": f"https://datadryad.org{download_href}" if download_href else None,
            }
        )
    return out


def zenodo_files(dataset_doi: str) -> list[dict[str, Any]]:
    # Le DOI Zenodo (10.5281/zenodo.<record_id>) encode directement l'ID.
    match = re.search(r"zenodo\.(\d+)", dataset_doi, re.IGNORECASE)
    if not match:
        return []
    record_id = match.group(1)
    r = requests.get(f"https://zenodo.org/api/records/{record_id}", timeout=30, headers=UA)
    r.raise_for_status()
    payload = r.json()
    out = []
    for f in payload.get("files", []) or []:
        links = f.get("links") if isinstance(f.get("links"), dict) else {}
        out.append(
            {
                "name": f.get("key") or f.get("filename"),
                "size": f.get("size") or 0,
                "url": links.get("self") or links.get("download"),
            }
        )
    return out


def list_files(repo: str, dataset_doi: str, data_access_url: str = "") -> list[dict[str, Any]]:
    if repo == "figshare":
        return figshare_files(dataset_doi)
    if repo == "dataverse":
        return dataverse_files(dataset_doi, data_access_url)
    if repo == "dryad":
        return dryad_files(dataset_doi)
    if repo == "zenodo":
        return zenodo_files(dataset_doi)
    if repo == "sciencebase":
        return sciencebase_files(data_access_url)
    if repo == "pangaea":
        return pangaea_files(dataset_doi)
    if repo == "b2share":
        return b2share_files(data_access_url)
    raise ValueError(f"Depot non supporte pour verification automatique: {repo}")


def classify_file_manifest(files: list[dict[str, Any]]) -> tuple[bool, str]:
    """Determine si un listing de depot ressemble a une vraie microdonnee.

    Retourne (probably_real_dataset, reason).
    """
    if not files:
        return False, "listing vide"

    names = [f.get("name") or "" for f in files]
    is_table = [bool(SUPPLEMENT_TABLE_RX.match(n)) for n in names]
    is_figure = [bool(SUPPLEMENT_FIGURE_RX.search(n)) for n in names]
    is_supp_doc = [bool(SUPPLEMENT_DOC_RX.match(n)) for n in names]
    is_real_data = [
        bool(REAL_DATA_FORMAT_RX.search(n)) and not SUPPLEMENT_TABLE_RX.match(n)
        for n in names
    ]

    if any(is_real_data):
        return True, f"{sum(is_real_data)} fichier(s) au format donnee reelle detecte(s)"

    if all(t or fi or d for t, fi, d in zip(is_table, is_figure, is_supp_doc)):
        return False, (
            "tous les fichiers correspondent au pattern 'supplement d'article republie' "
            "(Table_N.xls / figures / docx de supplement) - probable mirroir de "
            "data-availability (ex. SciELO/figshare), pas une microdonnee"
        )

    return True, "listing ambigu (formats non reconnus) - verification manuelle recommandee"


def check_dataset_doi(
    dataset_doi: str,
    data_access_url: str,
    max_size_mb: float | None = 200,
    require_vector_tabular: bool = False,
) -> dict[str, Any]:
    """Point d'entree unique : verifie un DOI de dataset et renvoie un verdict.

    max_size_mb : plafond de poids total du depot (None = pas de limite). Le
    projet vise des jeux de donnees "pas lourds" (CSV/shapefile/petit raster
    de regression spatiale), pas des rasters continentaux ou des archives
    d'imagerie - les depots au-dela du plafond sont ecartes du pipeline
    automatique meme s'ils sont par ailleurs de vraies microdonnees.

    require_vector_tabular : pour le Bloc 3 (entrepots, pas de papier pour
    justifier un raster brut) - rejette les depots qui ne contiennent que du
    raster/imagerie, meme s'ils passent le controle "vraie microdonnee vs
    miroir de supplement".
    """
    repo = repo_from_url(data_access_url or "")
    if repo not in {"figshare", "dataverse", "dryad", "zenodo", "sciencebase", "pangaea", "b2share"}:
        return {
            "repo": repo,
            "checked": False,
            "probably_real_dataset": True,
            "reason": f"depot '{repo}' non verifiable automatiquement - a controler manuellement",
            "n_files": None,
            "total_size_mb": None,
        }
    try:
        files = list_files(repo, dataset_doi, data_access_url or "")
    except Exception as exc:  # noqa: BLE001 - on veut degrader proprement
        return {
            "repo": repo,
            "checked": False,
            "probably_real_dataset": True,
            "reason": f"erreur d'appel API ({exc}) - a controler manuellement",
            "n_files": None,
            "total_size_mb": None,
        }

    total_mb = sum(f.get("size") or 0 for f in files) / (1024 * 1024)
    if max_size_mb is not None and total_mb > max_size_mb:
        return {
            "repo": repo,
            "checked": True,
            "probably_real_dataset": False,
            "reason": f"depot trop volumineux ({total_mb:.0f} Mo > seuil {max_size_mb:.0f} Mo) - hors perimetre 'pas lourd'",
            "n_files": len(files),
            "total_size_mb": total_mb,
        }

    probably_real, reason = classify_file_manifest(files)
    if probably_real and require_vector_tabular:
        has_structure, structure_reason = classify_spatial_structure(files)
        if not has_structure:
            return {
                "repo": repo,
                "checked": True,
                "probably_real_dataset": False,
                "reason": structure_reason,
                "n_files": len(files),
                "total_size_mb": total_mb,
            }
    return {
        "repo": repo,
        "checked": True,
        "probably_real_dataset": probably_real,
        "reason": reason,
        "n_files": len(files),
        "total_size_mb": total_mb,
    }
