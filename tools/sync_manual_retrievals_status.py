#!/usr/bin/env python
"""Synchronise le KG et le CSV de suivi PDF avec l'etat reel du disque.

Contexte : les scripts automatiques (download_datacite_verified_pdfs.py pour
les PDF, download_curated_paper_datasets.py pour les datasets) ne mettent a
jour `inst/kg/paper_dataset_uses.json` et
`data/manifests/papers/datacite_verified_pdf_download_manifest.csv` que
lorsqu'ILS reussissent eux-memes le telechargement. Quand un PDF ou un
dataset est rapporte manuellement (navigateur, telechargement direct) puis
depose dans `corpus/papers/raw_pdf/` ou `data/raw/papers/<bib_key>/`, ces
fichiers de suivi restent perimes -- les phases suivantes du pipeline
(Phase 5 BibTeX, Phase 7 GROBID, ...) se basent sur ces statuts et ratent
donc tout ce qui a ete recupere a la main.

Ce script reconcilie dans les deux sens, sans jamais retrograder un statut
deja plus avance ni inventer une correspondance douteuse :

  1. Pour chaque enregistrement du KG portant un `dataset_doi` et dont le
     statut est encore "en attente" (voir PENDING_STATUSES), cherche un PDF
     correspondant dans `corpus/papers/raw_pdf/` (comparaison de titre
     robuste aux variantes de tiret unicode). Si trouve, avance le statut a
     `pdf_present_pending_grobid`.
  2. Si en plus un dossier `data/raw/papers/<bib_key>/` non vide existe,
     avance le statut a `raw_data_downloaded` (supersede le cas 1).
  3. Met a jour `datacite_verified_pdf_download_manifest.csv` en consequence :
     cree ou corrige la ligne (status=pdf_present_pending_grobid, local_pdf=
     chemin reel) pour que `tools/stage_biblio_from_pdf_datacite.py` les
     trouve avec son statut par defaut.

Usage:
    python tools/sync_manual_retrievals_status.py --dry-run
    python tools/sync_manual_retrievals_status.py --apply
"""

from __future__ import annotations

import argparse
import csv
import json
import re
from pathlib import Path
from typing import Any

REPO_ROOT = Path(__file__).resolve().parent.parent
KG_PATH = REPO_ROOT / "inst" / "kg" / "paper_dataset_uses.json"
PDF_CSV_PATH = REPO_ROOT / "data" / "manifests" / "papers" / "datacite_verified_pdf_download_manifest.csv"
RAW_PDF_DIR = REPO_ROOT / "corpus" / "papers" / "raw_pdf"
RAW_DATASET_DIR = REPO_ROOT / "data" / "raw" / "papers"

# statuts a partir desquels on autorise une avancee automatique du KG --
# jamais les statuts deja avances (ingested, converted_to_sf,
# raw_data_downloaded, rejected_*, catalog_only_*,
# superseded_by_better_version, ...).
PENDING_STATUSES = {
    "candidate_dataset_download_pending",
    "pdf_not_accessible_needs_manual_retrieval",
    "needs_data_retrieval",
    "warehouse_download_failed",
    "warehouse_download_partial",
    "warehouse_download_error_listing_files",
    "warehouse_download_skipped_too_large",
    "warehouse_download_skipped_unsupported_repo",
}

# statuts qui indiquent que le papier est definitivement hors-perimetre --
# on ne cree/actualise jamais de ligne CSV Phase 5 pour ceux-ci, meme si un
# PDF homonyme traine sur le disque.
CSV_EXCLUDED_STATUS_PREFIXES = ("rejected_",)
CSV_EXCLUDED_STATUSES = {
    "superseded_by_better_version",
    "not_ingested_source_known",
}

HYPHEN_VARIANTS = re.compile(r"[‐‑‒–—-]")


def norm_title(s: str | None) -> str:
    s = (s or "").lower()
    s = HYPHEN_VARIANTS.sub("-", s)
    s = re.sub(r"[^a-z0-9 -]", "", s)
    s = re.sub(r"\s+", " ", s).strip()
    return s


def find_pdf(title: str, existing_norm: list[tuple[str, str]]) -> str | None:
    n = norm_title(title)[:40]
    if not n:
        return None
    for fn, orig in existing_norm:
        if fn[:25] == n[:25] or n[:25] in fn:
            return orig
    return None


def dataset_dir_has_content(bib_key: str) -> bool:
    if not bib_key:
        return False
    d = RAW_DATASET_DIR / bib_key
    if not d.is_dir():
        return False
    return any(p.is_file() for p in d.rglob("*"))


def load_pdf_csv() -> tuple[list[dict[str, str]], list[str]]:
    if not PDF_CSV_PATH.exists():
        return [], ["dataset_doi", "publication_doi", "publication_title", "local_pdf", "status", "source_url", "note"]
    with PDF_CSV_PATH.open(encoding="utf-8-sig", newline="") as f:
        reader = csv.DictReader(f, delimiter=";")
        rows = list(reader)
        fieldnames = reader.fieldnames or []
    return rows, fieldnames


def write_pdf_csv(rows: list[dict[str, str]], fieldnames: list[str]) -> None:
    with PDF_CSV_PATH.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, delimiter=";")
        writer.writeheader()
        writer.writerows(rows)


def main() -> int:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--dry-run", action="store_true")
    mode.add_argument("--apply", action="store_true")
    parser.add_argument(
        "--dataset-doi-file",
        type=Path,
        default=None,
        help=(
            "Fichier texte (un dataset_doi par ligne) restreignant la synchronisation "
            "a un lot precis (ex: le batch DataCite en cours). Sans cette option, "
            "TOUT le KG est parcouru -- utile pour un rattrapage global mais risque "
            "de melanger des lots/phases differents."
        ),
    )
    args = parser.parse_args()

    scope_dois: set[str] | None = None
    if args.dataset_doi_file:
        scope_dois = {
            line.strip().lower()
            for line in args.dataset_doi_file.read_text(encoding="utf-8").splitlines()
            if line.strip()
        }

    kg = json.loads(KG_PATH.read_text(encoding="utf-8-sig"))
    records: list[dict[str, Any]] = kg["records"]

    existing_pdfs = [p.name for p in RAW_PDF_DIR.glob("*.pdf")]
    existing_norm = [(norm_title(n)[:40], n) for n in existing_pdfs]

    csv_rows, csv_fields = load_pdf_csv()
    csv_by_pdoi = {(r.get("publication_doi") or "").strip().lower(): r for r in csv_rows}

    kg_updates: list[tuple[str, str, str, str]] = []  # dataset_doi, title, old_status, new_status
    csv_updates: list[tuple[str, str]] = []  # publication_doi, action (updated/created)
    no_pdf_found: list[tuple[str, str]] = []  # dataset_doi, title -- only tracked within scope

    for rec in records:
        ddoi = (rec.get("dataset_doi") or "").strip()
        pdoi = (rec.get("paper_doi") or "").strip()
        title = rec.get("paper_title") or rec.get("dataset_name_in_paper") or ""
        status = rec.get("ingestion_status") or ""
        bib_key = rec.get("bib_key") or ""

        if not ddoi or not pdoi:
            continue
        if scope_dois is not None and ddoi.lower() not in scope_dois:
            continue
        if status.startswith(CSV_EXCLUDED_STATUS_PREFIXES) or status in CSV_EXCLUDED_STATUSES:
            continue

        pdf_match = find_pdf(title, existing_norm)
        if not pdf_match:
            if scope_dois is not None:
                no_pdf_found.append((ddoi, title))
            continue

        # 1) avancee du statut KG, seulement depuis un statut "en attente"
        if status in PENDING_STATUSES:
            new_status = "pdf_present_pending_grobid"
            if dataset_dir_has_content(bib_key):
                new_status = "raw_data_downloaded"
            if new_status != status:
                kg_updates.append((ddoi, title, status, new_status))
                if args.apply:
                    rec["ingestion_status"] = new_status

        # 2) sync du CSV Phase 5 (stage_biblio_from_pdf_datacite.py) --
        # independant de l'avancement du KG : un PDF present suffit, quel
        # que soit le stade de conversion du dataset associe.
        row = csv_by_pdoi.get(pdoi.lower())
        rel_pdf = str(Path("corpus") / "papers" / "raw_pdf" / pdf_match)
        if row is None:
            new_row = {
                "dataset_doi": ddoi,
                "publication_doi": pdoi,
                "publication_title": title,
                "local_pdf": rel_pdf,
                "status": "pdf_present_pending_grobid",
                "source_url": "",
                "note": "synced by sync_manual_retrievals_status.py (manual retrieval)",
            }
            csv_updates.append((pdoi, "created"))
            if args.apply:
                csv_rows.append(new_row)
                csv_by_pdoi[pdoi.lower()] = new_row
        elif row.get("status") != "pdf_present_pending_grobid":
            csv_updates.append((pdoi, f"updated (was {row.get('status')!r})"))
            if args.apply:
                row["status"] = "pdf_present_pending_grobid"
                row["local_pdf"] = rel_pdf
                row["note"] = (row.get("note") or "") + " | synced by sync_manual_retrievals_status.py"

    print(f"KG updates: {len(kg_updates)}")
    for ddoi, title, old, new in kg_updates:
        print(f"  {ddoi} | {title[:55]!r} : {old} -> {new}")

    print(f"\nPDF CSV updates: {len(csv_updates)}")
    for pdoi, action in csv_updates:
        print(f"  {pdoi} : {action}")

    if scope_dois is not None:
        print(f"\nDans le lot ({len(scope_dois)} DOI), sans PDF trouve ({len(no_pdf_found)}):")
        for ddoi, title in no_pdf_found:
            print(f"  {ddoi} | {title[:70]!r}")

    if args.apply:
        KG_PATH.write_text(json.dumps(kg, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
        write_pdf_csv(csv_rows, csv_fields)
        print("\nApplique : KG et CSV ecrits sur disque.")
    else:
        print("\nDry-run : rien ecrit. Relancer avec --apply pour ecrire.")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
