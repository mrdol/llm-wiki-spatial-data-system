"""Telecharge les PDF open-access pour une liste de DOI donnee.

Resout chaque DOI via l'API Unpaywall (meilleure localisation OA connue),
puis tente le telechargement direct. Les DOI sans PDF legal accessible sont
signales dans le manifeste plutot que contournes.
"""

from __future__ import annotations

import argparse
import csv
import re
import time
from pathlib import Path

import requests


ROOT = Path(__file__).resolve().parents[1]
PDF_DIR = ROOT / "corpus" / "papers" / "raw_pdf"
MANIFEST = ROOT / "gg" / "doi_pdf_download_manifest_2026-08.tsv"
UNPAYWALL_EMAIL = "johnny.d-oliveira@inrae.fr"

DOIS = [
    "10.1002/eap.2893",
    "10.1002/sim.7172",
    "10.1016/j.eneco.2015.08.003",
    "10.1016/j.envint.2019.104909",
    "10.1016/j.ufug.2020.126778",
    "10.1017/pan.2020.23",
    "10.1021/acs.est.0c01791",
    "10.1021/acs.est.9b03358",
    "10.1080/07474938.2022.2047507",
    "10.1080/13658816.2019.1707834",
    "10.1080/17583004.2021.1962979",
    "10.1080/24694452.2018.1462691",
    "10.1093/ajae/aaz047",
    "10.1093/isq/sqz068",
    "10.1111/1365-2435.13092",
    "10.1111/2041-210x.13762",
    "10.1111/2041-210x.13957",
    "10.1111/ecog.06085",
    "10.1111/geb.12999",
    "10.1111/geb.13792",
    "10.1186/s41043-022-00309-7",
    "10.1590/0034-7612163114",
]

UA = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/126.0 Safari/537.36"
    ),
    "Accept": "application/pdf,text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
}


def clean_filename(doi: str) -> str:
    value = re.sub(r"[^A-Za-z0-9]+", "_", doi)
    return re.sub(r"_+", "_", value).strip("_")


def looks_like_pdf(content: bytes, content_type: str) -> bool:
    head = content[:20].lstrip()
    return head.startswith(b"%PDF") or "application/pdf" in content_type.lower()


def unpaywall_candidates(session: requests.Session, doi: str) -> tuple[list[str], str]:
    """Retourne les URLs PDF candidates trouvees via Unpaywall, plus une note."""
    url = f"https://api.unpaywall.org/v2/{doi}?email={UNPAYWALL_EMAIL}"
    try:
        response = session.get(url, timeout=30)
    except requests.RequestException as exc:
        return [], f"Unpaywall injoignable: {type(exc).__name__}"
    if response.status_code != 200:
        return [], f"Unpaywall HTTP {response.status_code}"
    try:
        data = response.json()
    except ValueError:
        return [], "Reponse Unpaywall non-JSON"

    if not data.get("is_oa"):
        return [], "Unpaywall: aucune version open access connue"

    candidates: list[str] = []
    locations = []
    if data.get("best_oa_location"):
        locations.append(data["best_oa_location"])
    locations.extend(data.get("oa_locations") or [])
    for loc in locations:
        for key in ("url_for_pdf", "url"):
            value = loc.get(key)
            if value and value not in candidates:
                candidates.append(value)
                pmc = re.search(r"pmc/articles/(?:PMC)?(\d+)", value, re.IGNORECASE)
                if pmc:
                    pmcid = pmc.group(1)
                    for derived in (
                        f"https://pmc.ncbi.nlm.nih.gov/articles/PMC{pmcid}/pdf/",
                        f"https://europepmc.org/backend/ptpmcrender.fcgi?accid=PMC{pmcid}&blobtype=pdf",
                    ):
                        if derived not in candidates:
                            candidates.insert(0, derived)
    return candidates, "" if candidates else "Unpaywall OA mais sans URL exploitable"


def download_one(session: requests.Session, doi: str) -> dict[str, str]:
    PDF_DIR.mkdir(parents=True, exist_ok=True)
    destination = PDF_DIR / f"{clean_filename(doi)}.pdf"
    base = {"doi": doi, "local_path": "", "source_url": "", "http_status": "", "content_type": ""}

    if destination.exists() and destination.stat().st_size > 1024:
        return {**base, "status": "already_present", "local_path": str(destination.relative_to(ROOT)), "note": ""}

    urls, note = unpaywall_candidates(session, doi)
    if not urls:
        return {**base, "status": "no_oa_url", "note": note}

    attempts = []
    for url in urls:
        try:
            response = session.get(url, timeout=90, allow_redirects=True)
            content_type = response.headers.get("content-type", "")
            attempts.append(f"{response.status_code} {content_type} {url}")
            if response.status_code == 200 and looks_like_pdf(response.content, content_type):
                destination.write_bytes(response.content)
                return {
                    **base,
                    "status": "downloaded",
                    "local_path": str(destination.relative_to(ROOT)),
                    "source_url": response.url,
                    "http_status": str(response.status_code),
                    "content_type": content_type,
                    "note": "",
                }
        except requests.RequestException as exc:
            attempts.append(f"ERROR {type(exc).__name__}: {url}")

    return {
        **base,
        "status": "not_downloaded",
        "note": "Aucune URL OA n'a renvoye un PDF. Tentatives: " + " ; ".join(attempts),
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Telecharge des PDF open access par DOI via Unpaywall.")
    parser.add_argument(
        "--doi",
        action="append",
        dest="dois",
        help="DOI a telecharger (repetable). Sans cette option, utilise la liste DOIS codee en dur.",
    )
    parser.add_argument("--manifest", default=str(MANIFEST), help="Chemin du manifeste TSV de sortie.")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    dois = args.dois if args.dois else DOIS
    manifest_path = Path(args.manifest)

    session = requests.Session()
    session.headers.update(UA)

    rows = []
    for index, doi in enumerate(dois, start=1):
        print(f"[{index}/{len(dois)}] {doi}", flush=True)
        rows.append(download_one(session, doi))
        time.sleep(0.5)

    manifest_path.parent.mkdir(parents=True, exist_ok=True)
    with manifest_path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()), delimiter="\t")
        writer.writeheader()
        writer.writerows(rows)

    counts: dict[str, int] = {}
    for row in rows:
        counts[row["status"]] = counts.get(row["status"], 0) + 1
        print(f"{row['status']:>15}  {row['doi']}  {row['local_path']}")
    print(f"\nresume: {counts}")
    print(f"manifest: {manifest_path}")


if __name__ == "__main__":
    main()
