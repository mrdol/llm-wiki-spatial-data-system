"""Verification/recuperation legere d'un PDF open access, sans contournement anti-bot.

Module partage entre:
- tools/check_dataset_availability.py (verification precoce, juste apres le
  harvest DataCite, avant verification Claude / ingestion KG / GROBID)
- tools/download_datacite_verified_pdfs.py (meme logique, appelee plus tard
  dans le pipeline pour les candidats qui n'auraient pas encore de PDF local)

Accepte indifferemment le schema des candidats bruts du harvest
(`article_oa_url`, `publication_url`) et celui du manifeste d'ingestion
(`open_access_pdf_url`, `publication_url`), pour pouvoir tourner tot ou tard
dans le pipeline avec le meme code.
"""

from __future__ import annotations

import re
import unicodedata
from pathlib import Path
from typing import Any

import requests


USER_AGENT = "llm-wiki-spatial-data-system/0.1 (johnny.d-oliveira@inrae.fr)"
UNPAYWALL_EMAIL = "johnny.d-oliveira@inrae.fr"


def build_session() -> requests.Session:
    session = requests.Session()
    session.headers.update(
        {
            "User-Agent": USER_AGENT,
            "Accept": "application/pdf,text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.5",
        }
    )
    return session


def safe_name(value: str, limit: int = 120) -> str:
    value = unicodedata.normalize("NFKD", value).encode("ascii", "ignore").decode("ascii")
    value = re.sub(r"[^A-Za-z0-9_. -]+", " ", value)
    value = re.sub(r"\s+", " ", value).strip(" .")
    if len(value) > limit:
        value = value[:limit].rsplit(" ", 1)[0].strip(" .")
    return value or "unknown"


def output_name(row: dict[str, Any]) -> str:
    title = str(row.get("publication_title") or row.get("article_title") or row.get("title") or row.get("dataset_title") or "paper")
    title = re.sub(r"\s*:\s*", " - ", title)
    title_part = safe_name(title, limit=170)
    return f"{title_part}.pdf"


def unpaywall_pdf_url(doi: str, session: requests.Session, timeout: int) -> str | None:
    """Interroge Unpaywall pour une copie legitime en libre acces (depot/preprint).

    Unpaywall est un service d'agregation d'acces ouvert (pas un contournement) :
    il indexe les copies deja legalement deposees (archive institutionnelle,
    preprint, auteur) qui echappent souvent aux protections anti-bot des pages
    editeur.
    """
    doi = (doi or "").strip()
    if not doi:
        return None
    try:
        resp = session.get(
            f"https://api.unpaywall.org/v2/{doi}",
            params={"email": UNPAYWALL_EMAIL},
            timeout=timeout,
        )
        if resp.status_code != 200:
            return None
        payload = resp.json()
    except (requests.RequestException, ValueError):
        return None

    best = payload.get("best_oa_location") or {}
    url = best.get("url_for_pdf") or best.get("url")
    if url:
        return str(url)
    for location in payload.get("oa_locations") or []:
        url = location.get("url_for_pdf") or location.get("url")
        if url:
            return str(url)
    return None


def pdf_url_candidates(row: dict[str, Any], session: requests.Session | None = None, timeout: int = 30) -> list[str]:
    # Plusieurs metadonnees DataCite pointent vers une page article et non vers
    # un PDF direct. On garde toutes les candidates et on verifiera le contenu.
    values = [
        row.get("open_access_pdf_url"),
        row.get("article_oa_url"),
        row.get("publication_url"),
    ]
    urls: list[str] = []
    for value in values:
        url = str(value or "").strip()
        if url and url not in urls:
            urls.append(url)
            pmc = re.search(r"pmc\.ncbi\.nlm\.nih\.gov/articles/(PMC\d+)", url, re.IGNORECASE)
            if pmc:
                derived = f"https://pmc.ncbi.nlm.nih.gov/articles/{pmc.group(1)}/pdf/"
                if derived not in urls:
                    urls.append(derived)

    if session is not None:
        publication_doi = str(row.get("publication_doi") or "")
        unpaywall_url = unpaywall_pdf_url(publication_doi, session, timeout)
        if unpaywall_url and unpaywall_url not in urls:
            urls.append(unpaywall_url)

    return urls


def looks_like_pdf(content: bytes, content_type: str) -> bool:
    head = content[:20].lstrip()
    return head.startswith(b"%PDF") or "application/pdf" in content_type.lower()


def fetch_pdf(
    row: dict[str, Any],
    pdf_dir: Path,
    session: requests.Session,
    timeout: int = 60,
    dry_run: bool = False,
) -> dict[str, Any]:
    """Tente de recuperer un PDF open access reel (pas une page HTML/editeur).

    N'essaie jamais de contourner une protection anti-bot/CAPTCHA : un echec
    HTTP (403, page HTML) est trace comme tel, pas retente avec des en-tetes
    de contournement.
    """
    destination = pdf_dir / output_name(row)
    urls = pdf_url_candidates(row, session=session, timeout=timeout)
    base = {
        "dataset_doi": str(row.get("dataset_doi") or ""),
        "publication_doi": str(row.get("publication_doi") or ""),
        "publication_title": str(row.get("publication_title") or row.get("article_title") or row.get("title") or ""),
        "local_pdf": str(destination),
    }

    if destination.exists() and destination.stat().st_size > 1024:
        return {**base, "status": "already_present", "source_url": "", "note": ""}
    if not urls:
        return {**base, "status": "no_url", "source_url": "", "note": "Aucune URL PDF/article."}
    if dry_run:
        return {**base, "status": "dry_run", "source_url": " | ".join(urls), "note": ""}

    attempts = []
    for url in urls:
        try:
            response = session.get(url, timeout=timeout, allow_redirects=True)
            content_type = response.headers.get("content-type", "")
            attempts.append(f"{response.status_code} {content_type} {url}")
            if response.status_code == 200 and looks_like_pdf(response.content, content_type):
                pdf_dir.mkdir(parents=True, exist_ok=True)
                destination.write_bytes(response.content)
                return {**base, "status": "downloaded", "source_url": response.url, "note": ""}
        except requests.RequestException as exc:
            attempts.append(f"ERROR {type(exc).__name__} {url}")

    return {
        **base,
        "status": "not_downloaded",
        "source_url": " | ".join(urls),
        "note": "Aucune URL candidate n'a renvoye un PDF. Tentatives: " + " ; ".join(attempts),
    }
