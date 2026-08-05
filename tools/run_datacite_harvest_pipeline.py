#!/usr/bin/env python
"""Lance toute la chaine DataCite: harvest, verification Claude, apurement."""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Run DataCite harvest -> Claude verification -> pruning."
    )
    parser.add_argument(
        "--repo-root",
        default=None,
        help="Repository root. Defaults to the parent of tools/.",
    )
    parser.add_argument(
        "--rscript",
        default=None,
        help="Path to Rscript.exe. Defaults to R_SCRIPT env var or PATH.",
    )
    parser.add_argument(
        "--model",
        default="claude-3-5-sonnet-20241022",
        help="Anthropic model used by verify_datacite_candidates.py.",
    )
    parser.add_argument("--skip-harvest", action="store_true")
    parser.add_argument("--skip-verification", action="store_true")
    parser.add_argument("--skip-apply", action="store_true")
    parser.add_argument(
        "--no-force-verification",
        action="store_true",
        help="Do not overwrite the current monthly verification report.",
    )
    parser.add_argument("--skip-api-checks", action="store_true")
    return parser.parse_args()


def find_rscript(explicit: str | None) -> str:
    # On privilegie un chemin explicite, puis la variable d'environnement,
    # puis le PATH, puis le chemin R connu sur la machine du projet.
    candidates = [
        explicit,
        os.environ.get("R_SCRIPT"),
        shutil.which("Rscript"),
        r"C:\Users\jdoliveira\AppData\Local\Programs\R\R-4.5.3\bin\Rscript.exe",
    ]
    for candidate in candidates:
        if candidate and Path(candidate).exists():
            return str(candidate)
    raise FileNotFoundError(
        "Rscript introuvable. Passez --rscript ou definissez R_SCRIPT."
    )


def run_step(command: list[str], cwd: Path) -> None:
    print("\n== " + " ".join(command), flush=True)
    subprocess.run(command, cwd=str(cwd), check=True)


def main() -> int:
    args = parse_args()
    script_dir = Path(__file__).resolve().parent
    repo_root = Path(args.repo_root).resolve() if args.repo_root else script_dir.parent
    rscript = find_rscript(args.rscript)

    if not args.skip_harvest:
        run_step([rscript, "tools/harvest_datacite.R"], cwd=repo_root)

    if not args.skip_verification:
        verify_cmd = [
            sys.executable,
            "tools/verify_datacite_candidates.py",
            "--repo-root",
            str(repo_root),
            "--model",
            args.model,
        ]
        if not args.no_force_verification:
            verify_cmd.append("--force")
        if args.skip_api_checks:
            verify_cmd.append("--skip-api-checks")
        run_step(verify_cmd, cwd=repo_root)

    if not args.skip_apply:
        run_step([rscript, "tools/apply_datacite_verification.R"], cwd=repo_root)

    print("\nPipeline DataCite termine.", flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
