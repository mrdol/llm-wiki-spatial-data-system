"""Lancer le pipeline KG dans l'ordre.

Par defaut, ce script ne relance pas GROBID car Docker doit etre ouvert dans
une autre fenetre. Pour convertir les PDF aussi, ajouter --run-grobid.

Utilisation:
  python tools/kg/run_all.py
  python tools/kg/run_all.py --run-grobid --from-bib
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def run_step(args: list[str]) -> None:
    """Lance une etape et stoppe si elle echoue."""
    print("\n==", " ".join(args))
    subprocess.run([sys.executable, *args], cwd=ROOT, check=True)


def main() -> None:
    parser = argparse.ArgumentParser(description="Run KG pipeline.")
    parser.add_argument("--run-grobid", action="store_true", help="lancer aussi l'etape PDF -> TEI")
    parser.add_argument("--from-bib", action="store_true", help="avec --run-grobid, traiter seulement les PDF du .bib")
    args = parser.parse_args()

    run_step(["tools/kg/01_extract_bib.py"])
    if args.run_grobid:
        grobid_args = ["tools/kg/02_run_grobid.py"]
        if args.from_bib:
            grobid_args.append("--from-bib")
        run_step(grobid_args)
    run_step(["tools/kg/03_parse_tei.py"])
    run_step(["tools/kg/04_extract_dataset_catalogs.py"])
    run_step(["tools/kg/04_extract_web_sources.py"])
    run_step(["tools/kg/04_build_graph.py"])
    run_step(["tools/kg/06_make_summaries.py"])
    run_step(["tools/kg/07_export_agent_index.py", "stats"])


if __name__ == "__main__":
    main()
