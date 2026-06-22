"""Download legally available open-access papers linked to software datasets.

The script starts from the dataset-paper audit CSV and downloads only PDFs
advertised by scholarly metadata APIs:
- Unpaywall, when an email is provided;
- OpenAlex open-access locations;
- Crossref full-text/TDM links.

Closed-access landing pages are recorded in the manifest but not downloaded.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import os
import re
import sys
import time
import unicodedata
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any
from urllib.parse import quote

import requests


ROOT = Path(__file__).resolve().parents[2]
DEFAULT_AUDIT = ROOT / "data" / "manifests" / "datasets" / "software_r_dataset_paper_formula_audit.csv"
DEFAULT_PAPER_DIR = ROOT / "corpus" / "papers" / "raw_pdf"
DEFAULT_MANIFEST = ROOT / "data" / "manifests" / "datasets" / "software_r_dataset_paper_downloads.csv"


def normalize_doi(value: str | None) -> str:
    doi = (value or "").strip().lower()
    doi = doi.replace("https://doi.org/", "").replace("http://dx.doi.org/", "")
    doi = doi.replace("doi:", "").strip().rstrip(".")
    return doi


def safe_name(value: str) -> str:
    value = value.replace("https://doi.org/", "")
    value = re.sub(r"<[^>]+>", " ", value)
    value = value.replace("&amp;", "and")
    value = value.replace("&lt;", "")
    value = value.replace("&gt;", "")
    value = unicodedata.normalize("NFKD", value).encode("ascii", "ignore").decode("ascii")
    value = re.sub(r'[<>:"/\\|?*\x00-\x1f]+', " ", value.strip())
    value = re.sub(r"\s+", " ", value).strip(" .")
    if len(value) > 130:
        value = value[:130].rsplit(" ", 1)[0].strip(" .")
    return value or "unknown"


def paper_filename(record: "DoiRecord") -> str:
    # Nomme le PDF par le dataset R et le sujet de l'article, pas par le DOI.
    pair = record.package_datasets[0] if record.package_datasets else ""
    dataset = pair.replace("::", "_") if pair else record.packages[0] if record.packages else "r_dataset"
    title = record.title or record.doi
    stem = safe_name(f"{dataset} - {title}")
    return f"{stem}.pdf"


def compact(values: list[str], limit: int = 12) -> str:
    out = []
    for value in values:
        value = (value or "").strip()
        if value and value not in out:
            out.append(value)
    return " | ".join(out[:limit])


@dataclass
class DoiRecord:
    doi: str
    packages: list[str] = field(default_factory=list)
    datasets: list[str] = field(default_factory=list)
    package_datasets: list[str] = field(default_factory=list)
    title: str = ""
    authors: str = ""
    year: str = ""
    doi_type: str = ""
    venue: str = ""
    doi_url: str = ""
    model_signal: str = ""


def read_audit(path: Path, *, verified_only: bool = True) -> list[DoiRecord]:
    grouped: dict[str, DoiRecord] = {}
    with path.open(encoding="utf-8-sig", newline="") as fh:
        reader = csv.DictReader(fh, delimiter=";")
        for row in reader:
            doi = normalize_doi(row.get("doi"))
            if not doi:
                continue
            if verified_only and row.get("doi_verified") != "yes":
                continue
            record = grouped.setdefault(doi, DoiRecord(doi=doi))
            package = row.get("package", "")
            dataset = row.get("dataset", "")
            if package and package not in record.packages:
                record.packages.append(package)
            if dataset and dataset not in record.datasets:
                record.datasets.append(dataset)
            pair = f"{package}::{dataset}" if package and dataset else package or dataset
            if pair and pair not in record.package_datasets:
                record.package_datasets.append(pair)
            for attr, column in (
                ("title", "paper_or_book_title"),
                ("authors", "authors"),
                ("year", "year"),
                ("doi_type", "doi_type"),
                ("venue", "venue"),
                ("doi_url", "doi_url"),
                ("model_signal", "model_or_equation_found_locally"),
            ):
                if not getattr(record, attr) and row.get(column):
                    setattr(record, attr, row[column])
    return sorted(grouped.values(), key=lambda item: item.doi)


def session_with_headers() -> requests.Session:
    session = requests.Session()
    session.headers.update(
        {
            "User-Agent": "llm-wiki-karpathy-open-access-paper-downloader/0.1",
            "Accept": "application/json, application/pdf;q=0.9, */*;q=0.3",
        }
    )
    return session


def query_unpaywall(session: requests.Session, doi: str, email: str | None) -> dict[str, Any] | None:
    if not email:
        return None
    url = f"https://api.unpaywall.org/v2/{quote(doi, safe='')}"
    response = session.get(url, params={"email": email}, timeout=45)
    if response.status_code == 404:
        return None
    response.raise_for_status()
    return response.json()


def query_openalex(session: requests.Session, doi: str, mailto: str | None) -> dict[str, Any] | None:
    params = {
        "filter": f"doi:{doi}",
        "per-page": 1,
        "select": "id,doi,title,publication_year,open_access,best_oa_location,locations,primary_location,authorships",
    }
    if mailto:
        params["mailto"] = mailto
    response = session.get("https://api.openalex.org/works", params=params, timeout=45)
    response.raise_for_status()
    results = response.json().get("results") or []
    return results[0] if results else None


def query_crossref(session: requests.Session, doi: str, mailto: str | None) -> dict[str, Any] | None:
    headers = {}
    if mailto:
        headers["mailto"] = mailto
    response = session.get(
        f"https://api.crossref.org/works/{quote(doi, safe='')}",
        headers=headers,
        timeout=45,
    )
    if response.status_code == 404:
        return None
    response.raise_for_status()
    return response.json().get("message") or {}


def add_candidate(candidates: list[dict[str, str]], *, source: str, url: str | None, license_url: str = "", landing_url: str = "") -> None:
    if not url:
        return
    url = url.strip()
    if not url or url in {item["pdf_url"] for item in candidates}:
        return
    candidates.append(
        {
            "source_api": source,
            "pdf_url": url,
            "license": license_url or "",
            "landing_url": landing_url or "",
        }
    )


def collect_candidates(
    *,
    unpaywall: dict[str, Any] | None,
    openalex: dict[str, Any] | None,
    crossref: dict[str, Any] | None,
) -> list[dict[str, str]]:
    candidates: list[dict[str, str]] = []

    if unpaywall:
        best = unpaywall.get("best_oa_location") or {}
        add_candidate(
            candidates,
            source="unpaywall",
            url=best.get("url_for_pdf"),
            license_url=best.get("license") or "",
            landing_url=best.get("url") or "",
        )
        for loc in unpaywall.get("oa_locations") or []:
            if isinstance(loc, dict):
                add_candidate(
                    candidates,
                    source="unpaywall",
                    url=loc.get("url_for_pdf"),
                    license_url=loc.get("license") or "",
                    landing_url=loc.get("url") or "",
                )

    if openalex:
        for loc in [openalex.get("best_oa_location")] + list(openalex.get("locations") or []):
            if isinstance(loc, dict):
                add_candidate(
                    candidates,
                    source="openalex",
                    url=loc.get("pdf_url"),
                    license_url=loc.get("license") or "",
                    landing_url=loc.get("landing_page_url") or "",
                )

    if crossref:
        licenses = crossref.get("license") or []
        license_url = ""
        if licenses and isinstance(licenses[0], dict):
            license_url = licenses[0].get("URL") or ""
        for link in crossref.get("link") or []:
            if not isinstance(link, dict):
                continue
            content_type = (link.get("content-type") or "").lower()
            intended = (link.get("intended-application") or "").lower()
            if "pdf" not in content_type and "text-mining" not in intended:
                continue
            add_candidate(
                candidates,
                source="crossref",
                url=link.get("URL"),
                license_url=license_url,
                landing_url=crossref.get("URL") or "",
            )

    return candidates


def validate_pdf_response(response: requests.Response) -> tuple[bool, str]:
    content_type = (response.headers.get("content-type") or "").lower()
    prefix = response.raw.read(5, decode_content=True)
    response.raw.decode_content = True
    if prefix.startswith(b"%PDF-"):
        return True, "pdf_magic"
    if "application/pdf" in content_type:
        return True, f"content_type:{content_type}"
    return False, f"not_pdf content_type={content_type or 'unknown'} prefix={prefix!r}"


def download_pdf(session: requests.Session, url: str, output_file: Path, *, timeout: int = 90) -> tuple[bool, str, int, str]:
    headers = {"Accept": "application/pdf,*/*;q=0.2"}
    try:
        with session.get(url, headers=headers, stream=True, timeout=timeout, allow_redirects=True) as response:
            if response.status_code >= 400:
                return False, f"http_{response.status_code}", 0, ""
            is_pdf, reason = validate_pdf_response(response)
            if not is_pdf:
                return False, reason, 0, response.url
            output_file.parent.mkdir(parents=True, exist_ok=True)
            sha = hashlib.sha256()
            total = 0
            with output_file.open("wb") as fh:
                fh.write(b"%PDF-")
                sha.update(b"%PDF-")
                total += 5
                for chunk in response.iter_content(chunk_size=1024 * 128):
                    if not chunk:
                        continue
                    fh.write(chunk)
                    sha.update(chunk)
                    total += len(chunk)
            if total < 1024:
                output_file.unlink(missing_ok=True)
                return False, "pdf_too_small", total, response.url
            return True, sha.hexdigest(), total, response.url
    except requests.RequestException as exc:
        return False, f"request_error:{exc}", 0, ""
    except OSError as exc:
        return False, f"file_error:{exc}", 0, ""


def openalex_oa_status(work: dict[str, Any] | None) -> str:
    if not work:
        return ""
    oa = work.get("open_access") or {}
    return str(oa.get("oa_status") or oa.get("is_oa") or "")


def write_manifest(rows: list[dict[str, Any]], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fields = [
        "doi",
        "doi_url",
        "package_datasets",
        "title",
        "authors",
        "year",
        "doi_type",
        "venue",
        "oa_status",
        "download_status",
        "downloaded_file",
        "pdf_url",
        "source_api",
        "license",
        "landing_url",
        "file_size",
        "sha256",
        "failure_reason",
        "model_signal",
    ]
    with path.open("w", encoding="utf-8-sig", newline="") as fh:
        writer = csv.DictWriter(fh, delimiter=";", fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)


def process_records(args: argparse.Namespace) -> list[dict[str, Any]]:
    args.audit_csv = args.audit_csv.resolve()
    args.paper_dir = args.paper_dir.resolve()
    args.manifest = args.manifest.resolve()

    records = read_audit(args.audit_csv, verified_only=not args.include_unverified)
    if args.limit:
        records = records[: args.limit]

    session = session_with_headers()
    email = args.email or os.environ.get("UNPAYWALL_EMAIL")
    mailto = args.mailto or email
    out_dir = args.paper_dir
    manifest_rows: list[dict[str, Any]] = []

    for index, record in enumerate(records, start=1):
        if not args.quiet:
            print(f"[{index}/{len(records)}] {record.doi}", file=sys.stderr)

        unpaywall = openalex = crossref = None
        errors = []

        try:
            unpaywall = query_unpaywall(session, record.doi, email)
        except Exception as exc:  # noqa: BLE001
            errors.append(f"unpaywall:{exc}")
        try:
            openalex = query_openalex(session, record.doi, mailto)
        except Exception as exc:  # noqa: BLE001
            errors.append(f"openalex:{exc}")
        try:
            crossref = query_crossref(session, record.doi, mailto)
        except Exception as exc:  # noqa: BLE001
            errors.append(f"crossref:{exc}")

        candidates = collect_candidates(unpaywall=unpaywall, openalex=openalex, crossref=crossref)
        filename = paper_filename(record)
        output_file = out_dir / filename

        status = "no_legal_pdf_url_found"
        selected: dict[str, str] = {}
        sha = ""
        size = 0
        failure = compact(errors)

        if output_file.exists() and output_file.stat().st_size > 1024:
            status = "already_downloaded"
            size = output_file.stat().st_size
            selected = candidates[0] if candidates else {}
        else:
            for candidate in candidates:
                if args.dry_run:
                    status = "dry_run_pdf_url_found"
                    selected = candidate
                    break
                ok, detail, bytes_written, final_url = download_pdf(session, candidate["pdf_url"], output_file)
                if ok:
                    status = "downloaded"
                    selected = dict(candidate)
                    selected["pdf_url"] = final_url or candidate["pdf_url"]
                    sha = detail
                    size = bytes_written
                    failure = ""
                    break
                failure = compact([failure, f"{candidate['source_api']}:{detail}"], limit=8)
                time.sleep(args.sleep)

        if status == "no_legal_pdf_url_found" and not email:
            failure = compact([failure, "unpaywall_skipped_missing_email"], limit=8)

        manifest_rows.append(
            {
                "doi": record.doi,
                "doi_url": record.doi_url or f"https://doi.org/{record.doi}",
                "package_datasets": compact(record.package_datasets, limit=50),
                "title": record.title or (openalex or {}).get("title", ""),
                "authors": record.authors,
                "year": record.year or str((openalex or {}).get("publication_year") or ""),
                "doi_type": record.doi_type,
                "venue": record.venue,
                "oa_status": openalex_oa_status(openalex) or str((unpaywall or {}).get("oa_status") or ""),
                "download_status": status,
                "downloaded_file": str(output_file.resolve().relative_to(ROOT)) if status in {"downloaded", "already_downloaded"} else "",
                "pdf_url": selected.get("pdf_url", ""),
                "source_api": selected.get("source_api", ""),
                "license": selected.get("license", ""),
                "landing_url": selected.get("landing_url", "") or (crossref or {}).get("URL", ""),
                "file_size": str(size or ""),
                "sha256": sha,
                "failure_reason": failure,
                "model_signal": record.model_signal,
            }
        )
        time.sleep(args.sleep)

    return manifest_rows


def main() -> None:
    parser = argparse.ArgumentParser(description="Download legal OA PDFs linked to dataset DOI audit CSV.")
    parser.add_argument("--audit-csv", type=Path, default=DEFAULT_AUDIT)
    parser.add_argument("--paper-dir", type=Path, default=DEFAULT_PAPER_DIR)
    parser.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    parser.add_argument("--email", help="Email for Unpaywall API. Can also be set with UNPAYWALL_EMAIL.")
    parser.add_argument("--mailto", help="Optional mailto parameter for OpenAlex/Crossref etiquette.")
    parser.add_argument("--include-unverified", action="store_true")
    parser.add_argument("--limit", type=int)
    parser.add_argument("--sleep", type=float, default=0.15)
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--quiet", action="store_true")
    args = parser.parse_args()

    rows = process_records(args)
    write_manifest(rows, args.manifest)

    counts: dict[str, int] = {}
    for row in rows:
        counts[row["download_status"]] = counts.get(row["download_status"], 0) + 1
    print(f"records={len(rows)}")
    for key in sorted(counts):
        print(f"{key}={counts[key]}")
    print(f"manifest={args.manifest}")
    print(f"paper_dir={args.paper_dir}")


if __name__ == "__main__":
    main()
