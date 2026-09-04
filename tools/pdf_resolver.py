#!/usr/bin/env python
"""Resolve and download legal article PDFs for paper-derived datasets.

Resolution order:
1. local exclusion / already-present checks;
2. DOI -> PMCID through the official PMC ID Converter;
3. PMCID -> public NCBI S3 bucket (`pmc-oa-opendata`);
4. Unpaywall and OpenAlex open-access locations;
5. optional Playwright browser fallback.

Only files whose bytes start with the PDF magic number (`%PDF-`) are saved.
HTML challenge pages are logged but never kept as PDFs.
"""

from __future__ import annotations

import argparse
import csv
import json
import re
import sys
import time
import urllib.parse
import xml.etree.ElementTree as ET
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import requests

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")


ROOT = Path(__file__).resolve().parent.parent
KG_PATH = ROOT / "inst" / "kg" / "paper_dataset_uses.json"
PDF_DIR = ROOT / "corpus" / "papers" / "raw_pdf"
DEFAULT_MANIFEST = ROOT / "gg" / "doi_pdf_resolver_manifest_2026-08.tsv"
DEFAULT_EMAIL = "johnny.d-oliveira@inrae.fr"
PMC_IDCONV_URL = "https://pmc.ncbi.nlm.nih.gov/tools/idconv/api/v1/articles/"
PMC_S3_URL = "https://pmc-oa-opendata.s3.amazonaws.com/"


@dataclass
class PaperTarget:
    doi: str
    title: str = ""
    dataset_doi: str = ""
    status: str = ""
    url_hint: str = ""


def normalize_doi(value: str | None) -> str:
    doi = (value or "").strip().lower()
    doi = clean_markdown_url(doi)
    for prefix in ("https://doi.org/", "http://doi.org/", "https://dx.doi.org/", "http://dx.doi.org/", "doi:"):
        if doi.startswith(prefix):
            doi = doi[len(prefix) :]
    return doi.strip().rstrip(".")


def clean_markdown_url(value: str | None) -> str:
    text = (value or "").strip()
    match = re.match(r"^\[[^\]]+\]\(([^)]+)\)$", text)
    if match:
        return match.group(1).strip()
    return text.strip("<>")


def doi_stem(doi: str) -> str:
    return re.sub(r"[^A-Za-z0-9]+", "_", doi).strip("_")


def pdf_path_for_doi(doi: str) -> Path:
    return PDF_DIR / f"{doi_stem(doi)}.pdf"


def is_pdf_bytes(data: bytes) -> bool:
    return len(data) > 1024 and data[:1024].lstrip().startswith(b"%PDF-")


def build_session() -> requests.Session:
    session = requests.Session()
    session.headers.update(
        {
            "User-Agent": "llm-wiki-spatial-data-system-pdf-resolver/0.1 (johnny.d-oliveira@inrae.fr)",
            "Accept": "application/json,application/pdf,text/html;q=0.8,*/*;q=0.3",
            "Accept-Language": "en-US,en;q=0.9,fr;q=0.8",
        }
    )
    return session


def load_targets_from_kg(include_rejected: bool = False) -> list[PaperTarget]:
    payload = json.loads(KG_PATH.read_text(encoding="utf-8-sig"))
    targets: dict[str, PaperTarget] = {}
    for record in payload.get("records", []):
        doi = normalize_doi(record.get("paper_doi"))
        if not doi:
            continue
        status = record.get("ingestion_status") or ""
        if status == "rejected_user_excluded" and not include_rejected:
            continue
        if doi not in targets:
            targets[doi] = PaperTarget(
                doi=doi,
                title=record.get("paper_title") or "",
                dataset_doi=record.get("dataset_doi") or "",
                status=status,
                url_hint=record.get("open_access_pdf_url") or record.get("publication_url") or "",
            )
    return sorted(targets.values(), key=lambda item: item.doi)


def explicit_targets(dois: list[str] | None, url_rows: list[str] | None) -> list[PaperTarget]:
    targets: dict[str, PaperTarget] = {}
    for doi in dois or []:
        normalized = normalize_doi(doi)
        if normalized:
            targets[normalized] = PaperTarget(doi=normalized)
    for row in url_rows or []:
        if "=" in row:
            doi, url = row.split("=", 1)
            normalized = normalize_doi(doi)
            if normalized:
                targets.setdefault(normalized, PaperTarget(doi=normalized)).url_hint = clean_markdown_url(url)
    return list(targets.values())


def pmcid_for_doi(session: requests.Session, doi: str, email: str, timeout: int) -> tuple[str, str]:
    params = {"ids": doi, "format": "json", "tool": "llm-wiki-spatial-data-system", "email": email}
    try:
        response = session.get(PMC_IDCONV_URL, params=params, timeout=timeout)
    except requests.RequestException as exc:
        return "", f"pmc_idconv_request_error:{type(exc).__name__}:{exc}"
    if response.status_code != 200:
        return "", f"pmc_idconv_http_{response.status_code}"
    try:
        payload = response.json()
    except ValueError:
        return "", "pmc_idconv_non_json"
    records = payload.get("records") or []
    if not records:
        return "", "pmc_idconv_no_record"
    pmcid = records[0].get("pmcid") or ""
    return pmcid, "" if pmcid else "pmc_idconv_no_pmcid"


def s3_list_common_prefixes(session: requests.Session, prefix: str, timeout: int) -> list[str]:
    response = session.get(
        PMC_S3_URL,
        params={"list-type": "2", "prefix": prefix, "delimiter": "/"},
        timeout=timeout,
    )
    response.raise_for_status()
    root = ET.fromstring(response.content)
    prefixes = []
    for node in root.findall("{http://s3.amazonaws.com/doc/2006-03-01/}CommonPrefixes"):
        child = node.find("{http://s3.amazonaws.com/doc/2006-03-01/}Prefix")
        if child is not None and child.text:
            prefixes.append(child.text)
    return prefixes


def s3_list_objects(session: requests.Session, prefix: str, timeout: int) -> list[str]:
    response = session.get(PMC_S3_URL, params={"list-type": "2", "prefix": prefix}, timeout=timeout)
    response.raise_for_status()
    root = ET.fromstring(response.content)
    keys = []
    for node in root.findall("{http://s3.amazonaws.com/doc/2006-03-01/}Contents"):
        child = node.find("{http://s3.amazonaws.com/doc/2006-03-01/}Key")
        if child is not None and child.text:
            keys.append(child.text)
    return keys


def download_url(session: requests.Session, url: str, dest: Path, timeout: int) -> tuple[bool, str, int, str]:
    url = clean_markdown_url(url)
    if not url:
        return False, "empty_url", 0, ""
    try:
        response = session.get(url, timeout=timeout, allow_redirects=True)
    except requests.RequestException as exc:
        return False, f"request_error:{type(exc).__name__}:{exc}", 0, ""
    data = response.content
    if response.status_code != 200:
        return False, f"http_{response.status_code}", len(data), response.url
    if not is_pdf_bytes(data):
        ctype = response.headers.get("content-type", "")
        prefix = data[:32].replace(b"\n", b" ")
        return False, f"not_pdf:ct={ctype}:prefix={prefix!r}", len(data), response.url
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_bytes(data)
    return True, "pdf_magic", len(data), response.url


def download_from_pmc_s3(session: requests.Session, doi: str, dest: Path, email: str, timeout: int) -> dict[str, Any]:
    pmcid, note = pmcid_for_doi(session, doi, email, timeout)
    if not pmcid:
        return {"ok": False, "status": "PDF_LINK_NOT_FOUND", "source": "pmc_id_converter", "note": note}

    try:
        prefixes = s3_list_common_prefixes(session, f"{pmcid}.", timeout)
    except Exception as exc:  # noqa: BLE001
        return {"ok": False, "status": "PDF_LINK_NOT_FOUND", "source": "pmc_s3", "pmcid": pmcid, "note": f"s3_prefix_error:{exc}"}

    if not prefixes:
        return {"ok": False, "status": "PDF_LINK_NOT_FOUND", "source": "pmc_s3", "pmcid": pmcid, "note": "no_s3_version_prefix"}

    def version_key(prefix: str) -> tuple[int, str]:
        match = re.search(r"\.(\d+)/$", prefix)
        return (int(match.group(1)) if match else -1, prefix)

    for prefix in sorted(prefixes, key=version_key, reverse=True):
        try:
            keys = s3_list_objects(session, prefix, timeout)
        except Exception as exc:  # noqa: BLE001
            return {"ok": False, "status": "PDF_LINK_NOT_FOUND", "source": "pmc_s3", "pmcid": pmcid, "note": f"s3_object_error:{exc}"}
        pdf_keys = [key for key in keys if key.lower().endswith(".pdf")]
        for key in pdf_keys:
            url = urllib.parse.urljoin(PMC_S3_URL, urllib.parse.quote(key, safe="/"))
            ok, detail, size, final_url = download_url(session, url, dest, timeout)
            if ok:
                return {
                    "ok": True,
                    "status": "SUCCESS_PMC_S3",
                    "source": "pmc_s3",
                    "pmcid": pmcid,
                    "url": final_url or url,
                    "size": size,
                    "note": prefix,
                }
            last = detail
    return {"ok": False, "status": "PDF_LINK_NOT_FOUND", "source": "pmc_s3", "pmcid": pmcid, "note": f"no_valid_pdf_in_s3:{locals().get('last', '')}"}


def unpaywall_candidates(session: requests.Session, doi: str, email: str, timeout: int) -> list[tuple[str, str]]:
    try:
        response = session.get(f"https://api.unpaywall.org/v2/{urllib.parse.quote(doi, safe='')}", params={"email": email}, timeout=timeout)
    except requests.RequestException:
        return []
    if response.status_code != 200:
        return []
    try:
        payload = response.json()
    except ValueError:
        return []
    candidates = []
    locations = []
    if isinstance(payload.get("best_oa_location"), dict):
        locations.append(payload["best_oa_location"])
    locations.extend([loc for loc in payload.get("oa_locations") or [] if isinstance(loc, dict)])
    for loc in locations:
        for key in ("url_for_pdf", "url"):
            url = clean_markdown_url(loc.get(key))
            if url:
                candidates.append(("unpaywall", url))
    return candidates


def openalex_candidates(session: requests.Session, doi: str, email: str, timeout: int) -> list[tuple[str, str]]:
    try:
        response = session.get(
            f"https://api.openalex.org/works/doi:{urllib.parse.quote(doi, safe='')}",
            params={"mailto": email, "select": "best_oa_location,locations,open_access"},
            timeout=timeout,
        )
    except requests.RequestException:
        return []
    if response.status_code != 200:
        return []
    try:
        payload = response.json()
    except ValueError:
        return []
    candidates = []
    locations = []
    if isinstance(payload.get("best_oa_location"), dict):
        locations.append(payload["best_oa_location"])
    locations.extend([loc for loc in payload.get("locations") or [] if isinstance(loc, dict)])
    for loc in locations:
        for key in ("pdf_url", "landing_page_url"):
            url = clean_markdown_url(loc.get(key))
            if url:
                candidates.append(("openalex", url))
    return candidates


def try_oa_locations(session: requests.Session, doi: str, dest: Path, email: str, timeout: int) -> dict[str, Any]:
    candidates = []
    candidates.extend(unpaywall_candidates(session, doi, email, timeout))
    candidates.extend(openalex_candidates(session, doi, email, timeout))
    seen = set()
    failures = []
    for source, url in candidates:
        if url in seen:
            continue
        seen.add(url)
        ok, detail, size, final_url = download_url(session, url, dest, timeout)
        if ok:
            return {"ok": True, "status": "SUCCESS_OA_LOCATION", "source": source, "url": final_url or url, "size": size, "note": ""}
        failures.append(f"{source}:{detail}:{url}")
    return {"ok": False, "status": "PDF_LINK_NOT_FOUND", "source": "oa_locations", "note": " | ".join(failures[:8])}


def publisher_browser_urls(doi: str, hints: list[str]) -> list[str]:
    """Build legal browser targets likely to expose an open PDF/download button."""
    doi = normalize_doi(doi)
    candidates = [clean_markdown_url(url) for url in hints if clean_markdown_url(url)]
    candidates.append(f"https://doi.org/{doi}")

    # Publisher-specific routes. These are public article/PDF endpoints; the
    # browser step still validates that the final bytes are a real PDF.
    if doi.startswith(("10.1002/", "10.1111/")):
        candidates.extend(
            [
                f"https://onlinelibrary.wiley.com/doi/{doi}",
                f"https://onlinelibrary.wiley.com/doi/epdf/{doi}",
                f"https://onlinelibrary.wiley.com/doi/pdf/{doi}",
                f"https://onlinelibrary.wiley.com/doi/pdfdirect/{doi}",
            ]
        )
    if doi.startswith("10.1080/"):
        candidates.extend(
            [
                f"https://www.tandfonline.com/doi/full/{doi}",
                f"https://www.tandfonline.com/doi/pdf/{doi}",
                f"https://www.tandfonline.com/doi/epdf/{doi}",
            ]
        )
    if doi.startswith("10.1098/"):
        candidates.extend(
            [
                f"https://royalsocietypublishing.org/doi/{doi}",
                f"https://royalsocietypublishing.org/doi/pdf/{doi}",
            ]
        )
    if doi.startswith("10.1186/"):
        candidates.append(f"https://link.springer.com/content/pdf/{doi}.pdf")

    seen = set()
    ordered = []
    for url in candidates:
        normalized = clean_markdown_url(url)
        if normalized and normalized not in seen:
            seen.add(normalized)
            ordered.append(normalized)
    return ordered


def looks_like_challenge(text: str) -> bool:
    lowered = text.lower()
    needles = [
        "cloudflare",
        "just a moment",
        "checking your browser",
        "captcha",
        "client challenge",
        "access denied",
        "institutional login",
        "verify you are human",
        "enable javascript and cookies",
    ]
    return any(needle in lowered for needle in needles)


def write_pdf_if_valid(data: bytes, dest: Path) -> bool:
    if not is_pdf_bytes(data):
        return False
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_bytes(data)
    return True


def try_response_pdf(response: Any, dest: Path) -> dict[str, Any] | None:
    try:
        url = response.url
        headers = {key.lower(): value for key, value in response.headers.items()}
        content_type = headers.get("content-type", "")
        if "pdf" not in content_type.lower() and not re.search(r"(\.pdf|/pdf|/epdf|pdfdirect)", url, re.I):
            return None
        body = response.body()
    except Exception:
        return None
    if write_pdf_if_valid(body, dest):
        return {
            "ok": True,
            "status": "SUCCESS_BROWSER",
            "source": "playwright",
            "url": url,
            "size": len(body),
            "note": "network_response_pdf",
        }
    return None


def browser_click_selectors() -> list[str]:
    return [
        'a[href*="/doi/epdf/"]',
        'a[href*="/doi/pdf"]',
        'a[href*="pdf"]',
        'button:has-text("PDF")',
        'a:has-text("PDF")',
        'text=/^PDF$/',
        'button[aria-label*="Download" i]',
        'a[aria-label*="Download" i]',
        'button[title*="Download" i]',
        'a[title*="Download" i]',
        '[data-testid*="download" i]',
        '[class*="download" i]',
        '[id*="download" i]',
    ]


def try_playwright(
    doi: str,
    dest: Path,
    urls: list[str],
    timeout_ms: int,
    *,
    headed: bool = False,
    browser_profile: str = "",
    max_clicks: int = 8,
    manual_wait_sec: int = 0,
) -> dict[str, Any]:
    try:
        from playwright.sync_api import TimeoutError as PlaywrightTimeoutError
        from playwright.sync_api import sync_playwright
    except Exception as exc:  # noqa: BLE001
        return {"ok": False, "status": "DOWNLOAD_EVENT_FAILED", "source": "playwright", "note": f"import_failed:{exc}"}

    urls = publisher_browser_urls(doi, urls)
    failures = []
    challenge_seen = False
    with sync_playwright() as playwright:
        browser = None
        if browser_profile:
            profile_dir = ROOT / browser_profile if not Path(browser_profile).is_absolute() else Path(browser_profile)
            profile_dir.mkdir(parents=True, exist_ok=True)
            context = playwright.chromium.launch_persistent_context(
                user_data_dir=str(profile_dir),
                headless=not headed,
                accept_downloads=True,
            )
        else:
            browser = playwright.chromium.launch(headless=not headed)
            context = browser.new_context(accept_downloads=True)

        try:
            for url in urls:
                page = context.new_page()
                responses: list[Any] = []
                page.on("response", lambda response: responses.append(response))
                try:
                    response = page.goto(url, wait_until="domcontentloaded", timeout=timeout_ms)
                    if response:
                        found = try_response_pdf(response, dest)
                        if found:
                            return found
                    page.wait_for_timeout(1000)
                    for response_item in responses:
                        found = try_response_pdf(response_item, dest)
                        if found:
                            return found

                    html = page.content()
                    if looks_like_challenge(html):
                        if headed and manual_wait_sec > 0:
                            print(
                                f"[playwright] Manual interaction window for {url}: "
                                f"{manual_wait_sec}s to pass challenge/login if access is legitimate.",
                                flush=True,
                            )
                            page.wait_for_timeout(manual_wait_sec * 1000)
                            html = page.content()
                        if looks_like_challenge(html):
                            challenge_seen = True
                            failures.append(f"challenge_or_login:{url}")
                            continue

                    clicks = 0
                    for selector in browser_click_selectors():
                        if clicks >= max_clicks:
                            break
                        locator = page.locator(selector).first
                        try:
                            if locator.count() == 0 or not locator.is_visible(timeout=1500):
                                continue
                        except Exception:
                            continue
                        clicks += 1
                        before_url = page.url
                        try:
                            with page.expect_download(timeout=timeout_ms) as download_info:
                                locator.click(timeout=timeout_ms)
                            download = download_info.value
                            tmp = dest.with_suffix(".playwright.tmp")
                            try:
                                download.save_as(str(tmp))
                                data = tmp.read_bytes()
                                if write_pdf_if_valid(data, dest):
                                    return {
                                        "ok": True,
                                        "status": "SUCCESS_BROWSER",
                                        "source": "playwright",
                                        "url": page.url,
                                        "size": len(data),
                                        "note": f"clicked:{selector}",
                                    }
                            finally:
                                tmp.unlink(missing_ok=True)
                        except PlaywrightTimeoutError:
                            # Some PDF viewers navigate or fetch the PDF instead of
                            # creating a download event.
                            for response_item in responses:
                                found = try_response_pdf(response_item, dest)
                                if found:
                                    found["note"] = f"clicked_response:{selector}"
                                    return found
                            if page.url != before_url:
                                found = try_response_pdf(page.goto(page.url, wait_until="domcontentloaded", timeout=timeout_ms), dest)
                                if found:
                                    found["note"] = f"clicked_navigation:{selector}"
                                    return found
                        except Exception as exc:  # noqa: BLE001
                            failures.append(f"click_failed:{selector}:{type(exc).__name__}")

                    failures.append(f"no_pdf_clickable:{url}")
                except Exception as exc:  # noqa: BLE001
                    failures.append(f"{type(exc).__name__}:{url}:{exc}")
                finally:
                    page.close()
        finally:
            context.close()
            if browser is not None:
                browser.close()

    status = "CAPTCHA_OR_LOGIN_REQUIRED" if challenge_seen else "MANUAL_ACTION_REQUIRED"
    return {"ok": False, "status": status, "source": "playwright", "note": " | ".join(failures[:8])}


def resolve_one(
    target: PaperTarget,
    *,
    session: requests.Session,
    email: str,
    timeout: int,
    playwright_timeout: int,
    use_playwright: bool,
    playwright_headed: bool,
    browser_profile: str,
    max_browser_clicks: int,
    manual_browser_wait: int,
    url_hints: dict[str, str],
) -> dict[str, Any]:
    doi = target.doi
    dest = pdf_path_for_doi(doi)
    base = {
        "doi": doi,
        "title": target.title,
        "dataset_doi": target.dataset_doi,
        "local_path": "",
        "status": "",
        "source": "",
        "pmcid": "",
        "url": "",
        "size": "",
        "note": "",
    }

    if target.status == "rejected_user_excluded":
        return {**base, "status": "SKIPPED_EXCLUDED", "note": "rejected_user_excluded"}
    if dest.exists() and dest.stat().st_size > 1024:
        if is_pdf_bytes(dest.read_bytes()[:2048]):
            return {**base, "status": "ALREADY_PRESENT", "local_path": str(dest.relative_to(ROOT)), "size": str(dest.stat().st_size)}

    pmc = download_from_pmc_s3(session, doi, dest, email, timeout)
    if pmc["ok"]:
        return {
            **base,
            "status": pmc["status"],
            "source": pmc.get("source", ""),
            "pmcid": pmc.get("pmcid", ""),
            "url": pmc.get("url", ""),
            "size": str(pmc.get("size", "")),
            "local_path": str(dest.relative_to(ROOT)),
            "note": pmc.get("note", ""),
        }

    oa = try_oa_locations(session, doi, dest, email, timeout)
    if oa["ok"]:
        return {
            **base,
            "status": oa["status"],
            "source": oa.get("source", ""),
            "url": oa.get("url", ""),
            "size": str(oa.get("size", "")),
            "local_path": str(dest.relative_to(ROOT)),
            "note": oa.get("note", ""),
        }

    if use_playwright:
        hints = [url_hints.get(doi, ""), target.url_hint, f"https://doi.org/{doi}"]
        browser = try_playwright(
            doi,
            dest,
            hints,
            playwright_timeout * 1000,
            headed=playwright_headed,
            browser_profile=browser_profile,
            max_clicks=max_browser_clicks,
            manual_wait_sec=manual_browser_wait,
        )
        if browser["ok"]:
            return {
                **base,
                "status": browser["status"],
                "source": browser.get("source", ""),
                "url": browser.get("url", ""),
                "size": str(browser.get("size", "")),
                "local_path": str(dest.relative_to(ROOT)),
                "note": browser.get("note", ""),
            }
        return {**base, "status": browser["status"], "source": browser.get("source", ""), "note": " ; ".join([pmc.get("note", ""), oa.get("note", ""), browser.get("note", "")])[:1200]}

    return {**base, "status": "MANUAL_ACTION_REQUIRED", "source": "resolver", "note": " ; ".join([pmc.get("note", ""), oa.get("note", "")])[:1200]}


def write_manifest(rows: list[dict[str, Any]], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fields = ["doi", "title", "dataset_doi", "status", "source", "pmcid", "url", "local_path", "size", "note"]
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, delimiter="\t")
        writer.writeheader()
        writer.writerows(rows)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Resolve article PDFs through PMC/S3, OA APIs and optional browser fallback.")
    parser.add_argument("--doi", action="append", dest="dois", help="Paper DOI to resolve. Repeatable.")
    parser.add_argument("--url", action="append", dest="urls", help="Optional DOI=URL hint. Repeatable.")
    parser.add_argument("--from-kg", action="store_true", help="Use paper DOIs from inst/kg/paper_dataset_uses.json.")
    parser.add_argument("--include-rejected", action="store_true", help="Do not skip rejected_user_excluded KG records.")
    parser.add_argument("--use-playwright", action="store_true", help="Use Playwright after PMC/S3 and OA APIs fail.")
    parser.add_argument("--playwright-headed", action="store_true", help="Run the optional Playwright browser visibly for publisher pages.")
    parser.add_argument("--browser-profile", default="", help="Optional persistent Playwright profile directory, relative to repo root or absolute.")
    parser.add_argument("--max-browser-clicks", type=int, default=8, help="Maximum PDF/download candidate clicks per browser page.")
    parser.add_argument("--manual-browser-wait", type=int, default=0, help="Seconds to wait in headed Playwright if a challenge/login page is detected.")
    parser.add_argument("--email", default=DEFAULT_EMAIL, help="Email for PMC/OpenAlex/Unpaywall etiquette.")
    parser.add_argument("--timeout", type=int, default=60, help="HTTP timeout in seconds.")
    parser.add_argument("--playwright-timeout", type=int, default=20, help="Playwright timeout per URL in seconds.")
    parser.add_argument("--sleep", type=float, default=0.2, help="Pause between DOI records.")
    parser.add_argument("--manifest", default=str(DEFAULT_MANIFEST), help="TSV manifest path.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    session = build_session()
    targets = load_targets_from_kg(args.include_rejected) if args.from_kg else explicit_targets(args.dois, args.urls)
    explicit = {target.doi: target for target in explicit_targets(args.dois, args.urls)}
    for doi, target in explicit.items():
        if doi not in {item.doi for item in targets}:
            targets.append(target)
    targets = sorted({target.doi: target for target in targets}.values(), key=lambda item: item.doi)
    url_hints = {normalize_doi(item.split("=", 1)[0]): clean_markdown_url(item.split("=", 1)[1]) for item in args.urls or [] if "=" in item}

    if not targets:
        print("No DOI targets. Use --doi or --from-kg.", file=sys.stderr)
        return 2

    rows = []
    for index, target in enumerate(targets, start=1):
        print(f"[{index}/{len(targets)}] {target.doi}", flush=True)
        row = resolve_one(
            target,
            session=session,
            email=args.email,
            timeout=args.timeout,
            playwright_timeout=args.playwright_timeout,
            use_playwright=args.use_playwright,
            playwright_headed=args.playwright_headed,
            browser_profile=args.browser_profile,
            max_browser_clicks=args.max_browser_clicks,
            manual_browser_wait=args.manual_browser_wait,
            url_hints=url_hints,
        )
        print(f"    {row['status']} {row.get('local_path', '')} {row.get('note', '')[:120]}", flush=True)
        rows.append(row)
        if args.sleep > 0:
            time.sleep(args.sleep)

    write_manifest(rows, Path(args.manifest))
    counts: dict[str, int] = {}
    for row in rows:
        counts[row["status"]] = counts.get(row["status"], 0) + 1
    print(f"summary: {counts}")
    print(f"manifest: {args.manifest}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
