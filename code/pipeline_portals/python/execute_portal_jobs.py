"""Execute a small controlled portal scraping batch.

This script performs real HTTP metadata scraping, but it does not download
large raw datasets and never writes to raw/. It appends request metadata to
the JSONL paths suggested by portal plans.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

import requests

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from portal_common import build_fetch_jobs, enrich_paper_dois, extract_html_links, html_title, resolve_plan_payload
from run_portal_plan import WAREHOUSE_LAYER_DEFAULTS


MAX_CAPTURE_BYTES = 1_000_000
TEXT_TYPES = ("text/", "application/json", "application/xml", "application/vnd.sdmx")


def _utc_now() -> str:
    """Retourne la date UTC pour tracer chaque job execute."""

    return datetime.now(timezone.utc).isoformat()


def _append_jsonl(path: str | Path, record: dict[str, Any]) -> None:
    """Ajoute un enregistrement JSON sur une ligne dans un fichier de manifest."""

    output = Path(path)
    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(record, ensure_ascii=True) + "\n")


def _is_textual(content_type: str | None) -> bool:
    """Dit si la reponse HTTP peut etre capturee comme texte ou metadonnees."""

    value = (content_type or "").lower()
    return any(marker in value for marker in TEXT_TYPES)


def _extract_title(text: str) -> str | None:
    """Extrait le titre HTML avec BeautifulSoup si possible, sinon avec regex."""

    return html_title(text)


def _extract_links(text: str, base_url: str, limit: int = 30) -> list[str]:
    """Extrait les liens HTML statiques avec BeautifulSoup et garde les premiers liens uniques."""

    links: list[str] = []
    for link in extract_html_links(text, base_url):
        url = link["url"]
        if url not in links:
            links.append(url)
        if len(links) >= limit:
            break
    return links


def _extract_dois(text: str) -> list[str]:
    """Repere les DOI presents dans une page ou une reponse texte."""

    matches = re.findall(r"\b10\.\d{4,9}/[-._;()/:A-Z0-9]+\b", text, flags=re.IGNORECASE)
    return sorted(set(match.rstrip(".,);]") for match in matches))


def _extract_license_terms(text: str) -> list[str]:
    """Cherche des indices simples de licence ou de conditions de reutilisation."""

    patterns = [
        "license",
        "licence",
        "Creative Commons",
        "Open Data",
        "Etalab",
        "Terms of Use",
        "conditions d'utilisation",
        "reuse",
        "réutilisation",
    ]
    found = []
    lower = text.lower()
    for pattern in patterns:
        if pattern.lower() in lower:
            found.append(pattern)
    return found


def _json_summary(text: str) -> dict[str, Any] | None:
    """Resume une reponse JSON sans stocker tout son contenu dans le manifest."""

    try:
        payload = json.loads(text)
    except json.JSONDecodeError:
        return None
    if isinstance(payload, dict):
        return {
            "json_type": "object",
            "top_level_keys": list(payload.keys())[:25],
            "label": payload.get("label"),
            "source": payload.get("source"),
            "updated": payload.get("updated"),
        }
    if isinstance(payload, list):
        return {"json_type": "array", "length": len(payload)}
    return {"json_type": type(payload).__name__}


def _render_with_playwright(url: str, timeout_ms: int = 20000) -> dict[str, Any]:
    """Rend une page JavaScript avec Playwright quand requests ne suffit pas.

    Playwright est plus lourd que BeautifulSoup: il lance un vrai navigateur.
    On l'utilise seulement pour les pages dynamiques ou quand l'extraction HTML
    simple ne trouve pas de liens.
    """

    try:
        from playwright.sync_api import sync_playwright
    except Exception as exc:  # pragma: no cover - optional dependency
        return {"available": False, "error": f"playwright import failed: {exc}"}

    try:
        with sync_playwright() as playwright:
            browser = playwright.chromium.launch(headless=True)
            page = browser.new_page()
            response = page.goto(url, wait_until="networkidle", timeout=timeout_ms)
            title = page.title()
            links = page.eval_on_selector_all(
                "a[href]",
                "(els) => els.slice(0, 30).map((a) => a.href)",
            )
            html = page.content()
            browser.close()
        return {
            "available": True,
            "status_code": response.status if response else None,
            "title": title,
            "links": links,
            "content_sha256": hashlib.sha256(html.encode("utf-8", errors="ignore")).hexdigest(),
            "content_chars": len(html),
        }
    except Exception as exc:  # pragma: no cover - depends on browser install
        return {"available": True, "error": str(exc)}


def execute_job(
    job: dict[str, Any],
    use_playwright: str,
    *,
    enrich_paper: bool = False,
    mailto: str | None = None,
) -> tuple[dict[str, Any], dict[str, Any]]:
    """Execute un job de scraping controle et produit une trace brute plus une trace normalisee.

    La logique suit trois niveaux:
    1. `requests` recupere les API, JSON, XML ou HTML statiques;
    2. BeautifulSoup extrait les titres et liens des pages HTML statiques;
    3. Playwright intervient seulement pour les pages dynamiques si l'option le demande.
    """

    session = requests.Session()
    headers = job.get("headers", {})
    result: dict[str, Any] = {
        "scraped_at": _utc_now(),
        "job_id": job["job_id"],
        "warehouse_id": job["warehouse_id"],
        "dataset_id": job["dataset_id"],
        "layer_type": job["layer_type"],
        "url": job["url"],
        "method": job.get("method", "GET"),
        "parser_hint": job.get("parser_hint"),
    }

    chunks: list[bytes] = []
    captured = 0
    try:
        with session.get(job["url"], headers=headers, timeout=60, stream=True, allow_redirects=True) as response:
            content_type = response.headers.get("content-type")
            content_length = response.headers.get("content-length")
            result.update(
                {
                    "status_code": response.status_code,
                    "final_url": response.url,
                    "content_type": content_type,
                    "content_length": content_length,
                }
            )
            if _is_textual(content_type):
                for chunk in response.iter_content(chunk_size=65536):
                    if not chunk:
                        continue
                    chunks.append(chunk)
                    captured += len(chunk)
                    if captured >= MAX_CAPTURE_BYTES:
                        break
            result["captured_bytes"] = captured
    except requests.RequestException as exc:
        result.update(
            {
                "status_code": None,
                "final_url": None,
                "content_type": None,
                "content_length": None,
                "captured_bytes": 0,
                "request_error": repr(exc),
            }
        )

    body = b"".join(chunks)
    text = body.decode("utf-8", errors="replace") if body else ""
    result["captured_sha256"] = hashlib.sha256(body).hexdigest() if body else None
    result["capture_truncated"] = captured >= MAX_CAPTURE_BYTES

    normalized: dict[str, Any] = {
        "scraped_at": result["scraped_at"],
        "job_id": job["job_id"],
        "warehouse_id": job["warehouse_id"],
        "dataset_id": job["dataset_id"],
        "dataset_title": job["dataset_title"],
        "layer_type": job["layer_type"],
        "url": job["url"],
        "final_url": result.get("final_url"),
        "status_code": result.get("status_code"),
        "content_type": result.get("content_type"),
        "title": _extract_title(text) if text else None,
        "links": _extract_links(text, result.get("final_url") or job["url"]) if text else [],
        "doi_strings": _extract_dois(text) if text else [],
        "license_terms": _extract_license_terms(text) if text else [],
        "json_summary": _json_summary(text) if text else None,
        "playwright": None,
    }
    if enrich_paper:
        normalized["paper_enrichment"] = enrich_paper_dois(
            normalized["doi_strings"],
            mailto=mailto,
        )

    needs_playwright = (
        use_playwright == "always"
        or (
            use_playwright == "auto"
            and (
                result.get("request_error")
                or (
                    "html" in (result.get("content_type") or "").lower()
                    and not normalized["links"]
                )
            )
        )
    )
    if needs_playwright:
        normalized["playwright"] = _render_with_playwright(job["url"])

    return result, normalized


def main() -> None:
    """Point d'entree CLI pour executer une petite serie de jobs issus d'un plan."""

    parser = argparse.ArgumentParser(description="Execute real controlled portal scraping jobs.")
    parser.add_argument("--plan", help="Path to a saved portal plan JSON.")
    parser.add_argument("--warehouse-id", help="Warehouse id to build the plan on the fly.")
    parser.add_argument("--dataset-id", help="Restrict to one dataset_id.")
    parser.add_argument("--limit", type=int, default=3, help="Maximum number of jobs to execute.")
    parser.add_argument(
        "--use-playwright",
        choices=("auto", "always", "never"),
        default="auto",
        help="Use Playwright for dynamic pages when needed.",
    )
    parser.add_argument("--pretty", action="store_true", help="Pretty-print a summary.")
    parser.add_argument(
        "--enrich-paper",
        action="store_true",
        help="Fetch OpenAlex abstracts/modeling signals for DOI strings found in scraped metadata pages.",
    )
    parser.add_argument("--mailto", help="Optional email parameter for polite OpenAlex API requests.")
    args = parser.parse_args()

    preferred_layer_types = None
    if args.warehouse_id:
        preferred_layer_types = WAREHOUSE_LAYER_DEFAULTS.get(args.warehouse_id)
        if preferred_layer_types is None:
            raise ValueError(f"No default layer configuration for warehouse_id={args.warehouse_id}")

    plan_payload = resolve_plan_payload(
        warehouse_id=args.warehouse_id,
        preferred_layer_types=preferred_layer_types,
        dataset_id=args.dataset_id,
        plan_path=args.plan,
    )
    jobs = build_fetch_jobs(plan_payload)[: args.limit]
    raw_output = plan_payload["suggested_outputs"]["raw_seed_log"]
    normalized_output = plan_payload["suggested_outputs"]["normalized_records"]

    summary = {
        "mode": "real_scrape_metadata_only",
        "warehouse_id": plan_payload["warehouse_id"],
        "job_count": len(jobs),
        "raw_output": raw_output,
        "normalized_output": normalized_output,
        "records": [],
    }
    for job in jobs:
        raw_record, normalized_record = execute_job(
            job,
            use_playwright=args.use_playwright,
            enrich_paper=args.enrich_paper,
            mailto=args.mailto,
        )
        _append_jsonl(raw_output, raw_record)
        _append_jsonl(normalized_output, normalized_record)
        paper_enrichment = normalized_record.get("paper_enrichment", [])
        summary["records"].append(
            {
                "job_id": job["job_id"],
                "status_code": raw_record.get("status_code"),
                "content_type": raw_record.get("content_type"),
                "title": normalized_record.get("title"),
                "link_count": len(normalized_record.get("links", [])),
                "doi_count": len(normalized_record.get("doi_strings", [])),
                "paper_enrichment_count": len(paper_enrichment),
                "candidate_decisions": sorted(
                    {
                        item.get("candidate_decision")
                        for item in paper_enrichment
                        if isinstance(item, dict) and item.get("candidate_decision")
                    }
                ),
                "license_terms": normalized_record.get("license_terms", []),
                "playwright_used": normalized_record.get("playwright") is not None,
            }
        )

    if args.pretty:
        print(json.dumps(summary, indent=2, ensure_ascii=True))
    else:
        print(json.dumps(summary, ensure_ascii=True))


if __name__ == "__main__":
    main()
