#!/usr/bin/env python3
"""Enrich existing dataset fiches with external metadata not present in the sf object.

Two independent steps, run separately or together:

  1. --license-year : deterministic lookup of package license + first-publication
     year via the PyPI JSON API (Python packages) and the CRAN metadata mirror
     crandb.r-pkg.org (R packages). No LLM involved -- structured API data only.

  2. --publication   : LLM + native web_search tool to locate the scientific
     publication (if any) associated with a dataset, its DOI, and a modelling
     formula if explicitly stated. A result is only accepted if a DOI matching
     the standard DOI pattern is found verbatim in the model's response -- the
     model is instructed to answer "not found" rather than guess.

Both steps write into a single shared cache file (data/yx_llm_cache.json, the
same file already used for Y/X candidate selection) under the top-level keys
"package_metadata" and "web_enrichment", so data/ does not accumulate one
cache file per enrichment step.

generate_fiches.py reads this cache when rendering fiches; re-run it with
--overwrite after this script to bake the enriched values into the .md files.

Usage:
    python Code_scrapping/r_catalog/enrich_web.py --license-year
    python Code_scrapping/r_catalog/enrich_web.py --publication
    python Code_scrapping/r_catalog/enrich_web.py --license-year --publication
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import threading
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
from typing import Any

import requests

sys.path.insert(0, str(Path(__file__).resolve().parent))
from generate_fiches import repo_root, load_json, load_cache, save_cache, should_keep  # noqa: E402

LLM_MODEL = "claude-haiku-4-5-20251001"
DOI_RE = re.compile(r"\b10\.\d{4,9}/\S+", re.IGNORECASE)
HTTP_TIMEOUT = 15

PUBLICATION_SYSTEM_PROMPT = (
    "Tu cherches si un dataset spatial distribue via un package R ou Python est "
    "associe a une source documentaire identifiable -- article scientifique avec "
    "DOI, OU livre/chapitre/rapport technique sans DOI. Utilise web_search pour "
    "verifier. Regles strictes : "
    "1) N'indique un DOI QUE si tu l'as vu ecrit explicitement dans une page web "
    "trouvee -- ne reconstruis jamais un DOI de memoire, meme si tu es presque sur. "
    "2) Si la source est un livre, un chapitre, ou un rapport sans DOI (ex: un "
    "ouvrage academique), laisse publication_doi a null MAIS remplis quand meme "
    "reference_publication (auteurs, annee, titre, editeur) et evidence_url "
    "(page de l'editeur, WorldCat, Google Books, page du package qui cite "
    "l'ouvrage) -- ne mets PAS tout a null seulement parce qu'il n'y a pas de DOI. "
    "3) Si tu ne trouves AUCUNE source clairement associee a CE dataset precis "
    "(pas juste au package en general), alors seulement reponds avec tous les "
    "champs a null. "
    "4) Une formule de modelisation (formula_pub) ne doit etre remplie que si elle "
    "est ecrite explicitement dans la source (ex: 'y = b0 + b1*x1 + ...' ou notation "
    "Wilkinson 'y ~ x1 + x2'). "
    "Reponds UNIQUEMENT avec un objet JSON : "
    '{"publication_doi": "10.xxxx/yyyy" ou null, '
    '"reference_publication": "Auteurs (Annee) Titre (livre/article/rapport)" ou null, '
    '"formula_pub": "texte de la formule" ou null, '
    '"x_terms_pub": ["terme1", ...] ou [], '
    '"y_term_pub": "terme" ou null, '
    '"evidence_url": "URL de la page source (article, editeur, ou page du package)" ou null}'
)

# Recherche separee de la formule : un article academique cite RAREMENT la
# formule R exacte utilisee. Elle se trouve presque toujours ailleurs -- une
# vignette du package, un tutoriel, un chapitre de livre en ligne (ex :
# Geocomputation with R, r.geocompx.org) qui montre un exemple de code reel
# (glm(...), lm(...), notation Wilkinson y ~ x1 + x2). Intention de recherche
# differente de la recherche de publication -> prompt et appel separes.
FORMULA_SYSTEM_PROMPT = (
    "Tu cherches un EXEMPLE D'USAGE CONCRET d'un dataset spatial distribue via "
    "un package R ou Python -- pas l'article scientifique qui l'a introduit, "
    "mais un endroit qui montre du CODE REEL utilisant ce dataset dans un "
    "modele : vignette du package, tutoriel, documentation pkgdown, ou chapitre "
    "de livre en ligne (ex: Geocomputation with R sur r.geocompx.org, qui "
    "documente plusieurs datasets de spData/spDataLarge avec des formules "
    "glm()/lm() completes). Utilise web_search pour trouver une page qui "
    "contient un appel de modele explicite avec ce dataset comme argument "
    "`data = <dataset>`. Regles strictes : "
    "1) Ne remplis formula_pub QUE si tu as vu la formule ecrite explicitement "
    "dans le code source de la page trouvee -- jamais reconstruite de memoire. "
    "2) Note bien que la variable reponse dans le code peut avoir un nom "
    "different du nom du dataset (ex: dataset `lsl`, variable reponse `lslpts`) -- "
    "rapporte le nom exact tel qu'il apparait dans la formule. "
    "3) Si aucun exemple de code avec formule explicite n'est trouve, reponds "
    "avec tous les champs a null -- ne devine jamais une formule plausible. "
    "Reponds UNIQUEMENT avec un objet JSON : "
    '{"formula_pub": "texte exact de la formule (ex: lslpts ~ slope + cplan)" ou null, '
    '"x_terms_pub": ["terme1", "terme2", ...] ou [], '
    '"y_term_pub": "nom exact de la variable reponse dans la formule" ou null, '
    '"formula_evidence_url": "URL de la page contenant le code" ou null}'
)


# ---------------------------------------------------------------------------
# Step 1 -- deterministic license/year lookup
# ---------------------------------------------------------------------------

def fetch_pypi_metadata(package: str) -> dict[str, Any]:
    url = f"https://pypi.org/pypi/{package}/json"
    try:
        resp = requests.get(url, timeout=HTTP_TIMEOUT)
        resp.raise_for_status()
    except requests.RequestException as exc:
        return {"license": None, "year": None, "source": url, "error": str(exc)}

    data = resp.json()
    info = data.get("info", {})

    license_name = info.get("license") or None
    if not license_name:
        for classifier in info.get("classifiers", []):
            if classifier.startswith("License ::"):
                license_name = classifier.split("::")[-1].strip()
                break

    dates = [
        f.get("upload_time_iso_8601")
        for files in data.get("releases", {}).values()
        for f in files
        if f.get("upload_time_iso_8601")
    ]
    year = sorted(dates)[0][:4] if dates else None

    return {"license": license_name, "year": year, "source": url}


# Packages R distribues hors CRAN (trop volumineux ou non soumis), accessibles
# via un depot GitHub source -- utilise comme repli quand crandb.r-pkg.org
# renvoie 404. Ajouter une entree ici suffit a couvrir un nouveau package externe.
EXTERNAL_R_SOURCES: dict[str, str] = {
    "spDataLarge": "Nowosad/spDataLarge",
}


def fetch_github_description_metadata(owner_repo: str) -> dict[str, Any]:
    """Repli pour les packages R distribues via GitHub/drat plutot que CRAN.

    Licence : champ `License:` du DESCRIPTION a la racine du repo (essaie les
    branches master/main). Annee : date de creation du depot GitHub (proxy
    raisonnable pour la premiere publication, a defaut d'un historique de
    versions CRAN).
    """
    desc_text = None
    desc_url = None
    for branch in ("master", "main"):
        url = f"https://raw.githubusercontent.com/{owner_repo}/{branch}/DESCRIPTION"
        try:
            resp = requests.get(url, timeout=HTTP_TIMEOUT)
        except requests.RequestException:
            continue
        if resp.status_code == 200:
            desc_text = resp.text
            desc_url = url
            break

    license_name = None
    if desc_text:
        match = re.search(r"(?m)^License:\s*(.+)$", desc_text)
        if match:
            license_name = match.group(1).strip()

    year = None
    api_url = f"https://api.github.com/repos/{owner_repo}"
    try:
        resp = requests.get(api_url, timeout=HTTP_TIMEOUT)
        if resp.status_code == 200:
            created_at = resp.json().get("created_at")
            if created_at:
                year = created_at[:4]
    except requests.RequestException:
        pass

    return {"license": license_name, "year": year, "source": desc_url or api_url}


def fetch_cran_metadata(package: str) -> dict[str, Any]:
    url = f"https://crandb.r-pkg.org/{package}/all"
    try:
        resp = requests.get(url, timeout=HTTP_TIMEOUT)
    except requests.RequestException as exc:
        return {"license": None, "year": None, "source": url, "error": str(exc)}

    if resp.status_code == 404 and package in EXTERNAL_R_SOURCES:
        return fetch_github_description_metadata(EXTERNAL_R_SOURCES[package])

    try:
        resp.raise_for_status()
    except requests.RequestException as exc:
        return {"license": None, "year": None, "source": url, "error": str(exc)}

    data = resp.json()
    versions = data.get("versions", {})
    license_name = None
    if versions:
        latest_version = sorted(versions.keys())[-1]
        license_name = versions[latest_version].get("License")

    timeline = data.get("timeline", {})
    year = sorted(timeline.values())[0][:4] if timeline else None

    return {"license": license_name, "year": year, "source": url}


def get_package_metadata(package: str, source_lang: str) -> dict[str, Any]:
    if source_lang == "python":
        return fetch_pypi_metadata(package)
    return fetch_cran_metadata(package)


def run_license_year(data: dict[str, Any], cache: dict[str, Any], refresh: bool) -> None:
    cache.setdefault("package_metadata", {})
    seen_packages: set[str] = set()

    for entry in data.get("datasets", []):
        package = entry["package"]
        source_lang = str(entry.get("source_lang") or "R").lower()
        cache_key = f"{source_lang}::{package}"

        if cache_key in seen_packages:
            continue
        seen_packages.add(cache_key)

        if not refresh and cache_key in cache["package_metadata"]:
            print(f"  CACHE   {cache_key}")
            continue

        meta = get_package_metadata(package, source_lang)
        cache["package_metadata"][cache_key] = meta
        status = "OK" if meta.get("license") or meta.get("year") else "EMPTY"
        print(f"  {status:<7} {cache_key} -> license={meta.get('license')!r} year={meta.get('year')!r}")


# ---------------------------------------------------------------------------
# Step 2 -- LLM + web_search publication lookup
# ---------------------------------------------------------------------------

def _extract_text(response: Any) -> str:
    parts = [block.text for block in response.content if getattr(block, "type", None) == "text"]
    return "\n".join(parts).strip()


def fetch_publication_web(did: str, package: str, dataset: str, intro: str, client: Any) -> dict[str, Any]:
    user_prompt = (
        f"Dataset : `{dataset}` (package {package}). Description disponible : {intro}\n\n"
        "Cherche si une publication scientifique est specifiquement associee a ce "
        "dataset (pas juste au package en general)."
    )
    try:
        response = client.messages.create(
            model=LLM_MODEL,
            max_tokens=1536,
            tools=[{"type": "web_search_20250305", "name": "web_search", "max_uses": 2}],
            system=PUBLICATION_SYSTEM_PROMPT,
            messages=[{"role": "user", "content": user_prompt}],
        )
        raw_text = _extract_text(response)
        match = re.search(r"\{[\s\S]+\}", raw_text)
        if not match:
            raise ValueError(f"Reponse LLM non parseable: {raw_text[:200]}")
        result = json.loads(match.group())
    except Exception as exc:  # noqa: BLE001 - degrade proprement
        print(f"  WARN WEB  {did}: {exc}", file=sys.stderr)
        return {"publication_doi": None, "reference_publication": None, "formula_pub": None,
                "x_terms_pub": [], "y_term_pub": None, "evidence_url": None, "error": str(exc)}

    doi = result.get("publication_doi")
    if doi and not DOI_RE.search(str(doi)):
        result["publication_doi"] = None  # garde-fou: rejette un DOI mal forme

    return result


def run_publication(
    data: dict[str, Any],
    cache: dict[str, Any],
    cache_path: Path,
    client: Any,
    refresh: bool,
    only_dataset: str | None,
    max_workers: int = 6,
) -> None:
    """Lance les recherches publication en parallele (I/O-bound: attente reseau,
    pas de calcul CPU -- des threads suffisent, pas besoin de multiprocessing).

    Sauvegarde le cache apres CHAQUE dataset traite (pas seulement a la fin),
    pour ne rien perdre en cas d'interruption et pour pouvoir suivre la
    progression en lisant le fichier de cache pendant que ca tourne.
    """
    cache.setdefault("web_enrichment", {})
    save_lock = threading.Lock()

    todo = []
    for entry in data.get("datasets", []):
        did = entry["dataset_id"]
        if only_dataset and did != only_dataset:
            continue
        if not should_keep(entry):
            continue
        if not refresh and did in cache["web_enrichment"]:
            print(f"  CACHE   {did}")
            continue
        todo.append(entry)

    if not todo:
        return

    def worker(entry: dict[str, Any]) -> tuple[str, dict[str, Any]]:
        did = entry["dataset_id"]
        package = entry["package"]
        dataset = entry.get("dataset", did)
        intro = f"Dataset spatial issu du package `{package}` (`{dataset}`)."
        result = fetch_publication_web(did, package, dataset, intro, client)
        return did, result

    done = 0
    with ThreadPoolExecutor(max_workers=max_workers) as pool:
        futures = {pool.submit(worker, entry): entry["dataset_id"] for entry in todo}
        for future in as_completed(futures):
            did, result = future.result()
            with save_lock:
                cache["web_enrichment"][did] = result
                save_cache(cache_path, cache)
            done += 1
            doi = result.get("publication_doi")
            print(f"  [{done}/{len(todo)}] {'FOUND' if doi else 'NONE':<7} {did} -> doi={doi!r}", flush=True)


# ---------------------------------------------------------------------------
# Step 3 -- LLM + web_search formula lookup (separate intent from Step 2:
# "where is this dataset cited" vs "where is this dataset actually modelled").
# ---------------------------------------------------------------------------

def fetch_formula_web(did: str, package: str, dataset: str, intro: str, client: Any) -> dict[str, Any]:
    user_prompt = (
        f"Dataset : `{dataset}` (package {package}). Description disponible : {intro}\n\n"
        "Cherche un exemple de code (vignette, tutoriel, livre en ligne) qui "
        "modelise ce dataset avec une formule explicite."
    )
    try:
        response = client.messages.create(
            model=LLM_MODEL,
            max_tokens=1536,
            tools=[{"type": "web_search_20250305", "name": "web_search", "max_uses": 2}],
            system=FORMULA_SYSTEM_PROMPT,
            messages=[{"role": "user", "content": user_prompt}],
        )
        raw_text = _extract_text(response)
        match = re.search(r"\{[\s\S]+\}", raw_text)
        if not match:
            raise ValueError(f"Reponse LLM non parseable: {raw_text[:200]}")
        result = json.loads(match.group())
    except Exception as exc:  # noqa: BLE001 - degrade proprement
        print(f"  WARN FORM {did}: {exc}", file=sys.stderr)
        return {"formula_pub": None, "x_terms_pub": [], "y_term_pub": None,
                "formula_evidence_url": None, "error": str(exc)}

    return result


def run_formula(
    data: dict[str, Any],
    cache: dict[str, Any],
    cache_path: Path,
    client: Any,
    refresh: bool,
    only_dataset: str | None,
    max_workers: int = 6,
) -> None:
    """Recherche dediee a la formule, separee de run_publication() : ne re-paie

    pas une recherche pour des datasets dont le DOI/reference est deja trouve
    -- ne complete que le champ formula_pub (et x_terms_pub/y_term_pub), sans
    toucher publication_doi/reference_publication deja en cache.
    """
    cache.setdefault("web_enrichment", {})
    save_lock = threading.Lock()

    todo = []
    for entry in data.get("datasets", []):
        did = entry["dataset_id"]
        if only_dataset and did != only_dataset:
            continue
        if not should_keep(entry):
            continue
        existing = cache["web_enrichment"].get(did, {})
        if not refresh and existing.get("formula_pub"):
            print(f"  CACHE   {did}")
            continue
        todo.append(entry)

    if not todo:
        return

    def worker(entry: dict[str, Any]) -> tuple[str, dict[str, Any]]:
        did = entry["dataset_id"]
        package = entry["package"]
        dataset = entry.get("dataset", did)
        intro = f"Dataset spatial issu du package `{package}` (`{dataset}`)."
        result = fetch_formula_web(did, package, dataset, intro, client)
        return did, result

    done = 0
    with ThreadPoolExecutor(max_workers=max_workers) as pool:
        futures = {pool.submit(worker, entry): entry["dataset_id"] for entry in todo}
        for future in as_completed(futures):
            did, result = future.result()
            with save_lock:
                existing = cache["web_enrichment"].setdefault(did, {})
                existing["formula_pub"] = result.get("formula_pub")
                existing["x_terms_pub"] = result.get("x_terms_pub") or []
                existing["y_term_pub"] = result.get("y_term_pub")
                existing["formula_evidence_url"] = result.get("formula_evidence_url")
                if "error" in result:
                    existing["formula_error"] = result["error"]
                else:
                    existing.pop("formula_error", None)
                save_cache(cache_path, cache)
            done += 1
            found = bool(result.get("formula_pub"))
            print(f"  [{done}/{len(todo)}] {'FOUND' if found else 'NONE':<7} {did} -> formula={result.get('formula_pub')!r}", flush=True)


# ---------------------------------------------------------------------------

def parse_args() -> argparse.Namespace:
    root = repo_root()
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--json-in", type=Path, default=root / "data" / "sf_catalog_metadata.json")
    parser.add_argument("--cache", type=Path, default=root / "data" / "yx_llm_cache.json")
    parser.add_argument("--license-year", action="store_true", help="lancer l'etape 1 (deterministe)")
    parser.add_argument("--publication", action="store_true", help="lancer l'etape 2 (DOI/reference, LLM + web_search)")
    parser.add_argument("--formula", action="store_true", help="lancer l'etape 3 (formule, LLM + web_search, recherche separee)")
    parser.add_argument("--refresh", action="store_true",
                         help="ignorer le cache existant et repayer une recherche LLM+web_search "
                              "deja faite -- a utiliser seulement si un resultat est errone, pas par habitude")
    parser.add_argument("--dataset", type=str, default=None, help="limiter aux etapes 2/3 a un seul dataset_id")
    parser.add_argument("--workers", type=int, default=6, help="nombre de requetes LLM en parallele (I/O-bound)")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if not args.license_year and not args.publication and not args.formula:
        args.license_year = args.publication = args.formula = True  # par defaut : tout

    if args.refresh:
        print(
            "  WARN: --refresh actif -- chaque dataset deja en cache va repayer un "
            "appel LLM + web_search. Utilise --dataset <id> pour limiter le refresh "
            "a un seul cas errone plutot que de relancer tout le lot.",
            file=sys.stderr,
        )

    data = load_json(args.json_in)
    cache = load_cache(args.cache)

    try:
        from dotenv import load_dotenv
        load_dotenv(repo_root() / ".env")
    except ImportError:
        pass

    if args.license_year:
        print("=== Etape 1 -- License/Year (PyPI/CRAN, deterministe) ===")
        run_license_year(data, cache, args.refresh)
        save_cache(args.cache, cache)

    client = None
    if args.publication or args.formula:
        api_key = os.environ.get("ANTHROPIC_API_KEY")
        if not api_key:
            print("  WARN: ANTHROPIC_API_KEY absent -- etapes 2/3 desactivees.", file=sys.stderr)
        else:
            import anthropic
            client = anthropic.Anthropic(api_key=api_key)

    if args.publication and client:
        print("\n=== Etape 2 -- Publication DOI/reference (LLM + web_search) ===")
        run_publication(data, cache, args.cache, client, args.refresh, args.dataset, args.workers)
        save_cache(args.cache, cache)

    if args.formula and client:
        print("\n=== Etape 3 -- Formule (LLM + web_search, vignettes/tutoriels) ===")
        run_formula(data, cache, args.cache, client, args.refresh, args.dataset, args.workers)
        save_cache(args.cache, cache)

    print("\nCache mis a jour :", args.cache)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
