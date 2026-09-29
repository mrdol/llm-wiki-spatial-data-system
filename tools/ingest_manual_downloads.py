#!/usr/bin/env python
"""Recupere les fichiers deposes manuellement pour les candidats bloques.

Contexte (2026-08-08) : certains candidats DataCite ont TOUS les bons signaux
(papier confirme, dataset reel, CRS/coordonnees/covariables plausibles) mais
le telechargement automatique echoue pour des raisons qu'on ne contourne pas
(challenge anti-bot AWS WAF, jeton d'authentification requis). Pour ces cas,
`inst/kg/paper_dataset_uses.json` porte le statut `needs_data_retrieval` et
ce script :

1. Liste les candidats en attente avec l'URL exacte a recuperer et le dossier
   cible sous `data/data_retrievals/pending/<bib_key>/` ;
2. Scanne ce dossier : des lors qu'un fichier y est depose par l'utilisateur,
   le deplace vers `data/raw/papers/<bib_key>/` et met a jour le statut KG.

Usage:
    python tools/ingest_data_retrievals.py --list       # generer les instructions
    python tools/ingest_data_retrievals.py --collect     # recuperer ce qui a ete depose
"""

from __future__ import annotations

import argparse
import json
import shutil
import sys
from pathlib import Path
from typing import Any

from dataset_manifest_check import classify_file_manifest

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")


ROOT = Path(__file__).resolve().parent.parent
KG_PATH = ROOT / "inst" / "kg" / "paper_dataset_uses.json"
PENDING_DIR = ROOT / "data" / "data_retrievals" / "pending"
RAW_DIR = ROOT / "data" / "raw" / "papers"

TARGET_STATUS = "needs_data_retrieval"


def load_kg() -> dict[str, Any]:
    return json.loads(KG_PATH.read_text(encoding="utf-8-sig"))


def save_kg(payload: dict[str, Any]) -> None:
    KG_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")


def pending_records(payload: dict[str, Any]) -> list[dict[str, Any]]:
    return [r for r in payload.get("records", []) if r.get("ingestion_status") == TARGET_STATUS]


def write_instructions(record: dict[str, Any]) -> None:
    folder = PENDING_DIR / record["bib_key"]
    folder.mkdir(parents=True, exist_ok=True)
    readme = folder / "INSTRUCTIONS.md"

    lines = [
        f"# {record.get('paper_title', '')}",
        "",
        f"- Paper DOI: {record.get('paper_doi', '')}",
        f"- Dataset DOI: {record.get('dataset_doi', '')}",
        f"- URL du dataset a telecharger manuellement: {record.get('data_access_url', '')}",
    ]

    if not record.get("local_pdf"):
        pdf_url = record.get("open_access_pdf_url") or record.get("publication_url") or "(non trouvee)"
        lines.append(f"- Le PDF du papier n'a PAS ete recupere automatiquement - URL a essayer: {pdf_url}")

    lines.extend(
        [
            f"- Raison du blocage automatique: {record.get('rejection_reason', '')}",
            "",
            "Deposez ici le(s) fichier(s) de donnees (et le PDF du papier si absent) "
            "telecharges manuellement (pas besoin de dezipper). Lancez ensuite:",
            "",
            "    python tools/ingest_data_retrievals.py --collect",
            "",
        ]
    )
    readme.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Manual-download intake for blocked DataCite candidates.")
    parser.add_argument("--list", action="store_true", help="Cree/actualise les dossiers d'instructions pour les candidats en attente.")
    parser.add_argument("--collect", action="store_true", help="Recupere les fichiers deposes dans data/data_retrievals/pending/.")
    args = parser.parse_args()

    if not args.list and not args.collect:
        args.list = True
        args.collect = True

    payload = load_kg()
    pending = pending_records(payload)

    if args.list:
        print(f"Candidats en attente de telechargement manuel : {len(pending)}")
        for record in pending:
            write_instructions(record)
            print(f"  - {record['bib_key']}")
            print(f"    URL: {record.get('data_access_url', '')}")
            print(f"    Dossier: {PENDING_DIR / record['bib_key']}")

    if args.collect:
        pdf_dir = ROOT / "corpus" / "papers" / "raw_pdf"
        collected = 0
        for record in pending:
            folder = PENDING_DIR / record["bib_key"]
            if not folder.exists():
                continue
            all_files = [f for f in folder.iterdir() if f.is_file() and f.name != "INSTRUCTIONS.md"]
            if not all_files:
                continue

            pdf_files = [f for f in all_files if f.suffix.lower() == ".pdf"]
            data_files = [f for f in all_files if f.suffix.lower() != ".pdf"]

            if pdf_files and not record.get("local_pdf"):
                pdf_dir.mkdir(parents=True, exist_ok=True)
                dest = pdf_dir / pdf_files[0].name
                shutil.move(str(pdf_files[0]), str(dest))
                record["local_pdf"] = str(dest)
                print(f"[{record['bib_key']}] PDF recupere -> {dest}")
                for extra in pdf_files[1:]:
                    print(f"[{record['bib_key']}] PDF supplementaire ignore (un seul attendu): {extra.name}")

            if data_files:
                manifest_like = [{"name": f.name, "size": f.stat().st_size} for f in data_files]
                probably_real, reason = classify_file_manifest(manifest_like)
                if not probably_real:
                    print(f"[{record['bib_key']}] fichiers de donnees deposes mais rejetes ({reason}) - non recuperes.")
                else:
                    target_dir = RAW_DIR / record["bib_key"]
                    target_dir.mkdir(parents=True, exist_ok=True)
                    for f in data_files:
                        shutil.move(str(f), str(target_dir / f.name))
                    record["ingestion_status"] = (
                        "raw_data_downloaded" if record.get("local_pdf") else "raw_data_downloaded_pdf_still_missing"
                    )
                    record["evidence"] = (record.get("evidence") or "") + " | Raw data provided via manual download by the user."
                    print(f"[{record['bib_key']}] {len(data_files)} fichier(s) de donnees recupere(s) -> {target_dir}")

            collected += 1

        if collected:
            save_kg(payload)
        print(f"\nCandidats traites via depot manuel : {collected}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
