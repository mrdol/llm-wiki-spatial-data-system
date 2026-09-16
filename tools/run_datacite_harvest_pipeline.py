#!/usr/bin/env python
"""Lance toute la chaine DataCite: harvest, verification, apurement, ingestion."""

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
        "--target",
        type=int,
        default=300,
        help="Maximum number of DataCite candidates kept after filtering.",
    )
    parser.add_argument(
        "--openalex-limit",
        type=int,
        default=1200,
        help="Maximum number of pre-screened candidates enriched with OpenAlex/Crossref.",
    )
    parser.add_argument(
        "--min-citations",
        type=int,
        default=2,
        help="Minimum OpenAlex citation count for the parent article.",
    )
    parser.add_argument(
        "--crossref-workers",
        type=int,
        default=1,
        help="Number of parallel Crossref workers. Use 1 for the most conservative API behavior.",
    )
    parser.add_argument(
        "--min-dataset-size-kb",
        type=int,
        default=5120,
        help="Minimum DataCite deposit size in KB when size metadata is available. Use 0 to disable.",
    )
    parser.add_argument(
        "--profiles",
        default="all",
        help="Comma-separated DataCite thematic profiles, or 'all'. Examples: core,transport_mobility,public_health.",
    )
    parser.add_argument(
        "--model",
        default="claude-sonnet-4-5",
        help="Anthropic model used by verify_datacite_candidates.py.",
    )
    parser.add_argument("--skip-harvest", action="store_true")
    parser.add_argument("--skip-verification", action="store_true")
    parser.add_argument("--skip-apply", action="store_true")
    parser.add_argument("--skip-ingestion", action="store_true")
    parser.add_argument(
        "--no-force-verification",
        action="store_true",
        help="Do not overwrite the current monthly verification report.",
    )
    parser.add_argument("--skip-api-checks", action="store_true")
    parser.add_argument(
        "--strict-spatial-only",
        action="store_true",
        help="Exclude candidates flagged as spatio-temporal during the DataCite harvest.",
    )
    parser.add_argument(
        "--include-spatiotemporal",
        action="store_true",
        help="Allow panel/spatio-temporal candidates during the DataCite harvest.",
    )
    parser.add_argument(
        "--include-ecology-sdm",
        action="store_true",
        help="Allow ecology species-distribution/presence-absence candidates during the DataCite harvest.",
    )
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


def find_python(repo_root: Path) -> str:
    # sys.executable suit l'interpreteur qui a lance ce script, ce qui peut
    # etre un Python systeme sans les dependances du projet (ex. `anthropic`)
    # si l'utilisateur ne l'a pas invoque depuis le venv. On privilegie donc
    # le venv du projet quand il existe, avant de retomber sur sys.executable.
    candidates = [
        repo_root / ".venv" / "Scripts" / "python.exe",
        repo_root.parent / ".venv" / "Scripts" / "python.exe",
    ]
    for candidate in candidates:
        if candidate.exists():
            return str(candidate)
    return sys.executable


def run_step(command: list[str], cwd: Path) -> None:
    print("\n== " + " ".join(command), flush=True)
    subprocess.run(command, cwd=str(cwd), check=True)


def main() -> int:
    args = parse_args()
    script_dir = Path(__file__).resolve().parent
    repo_root = Path(args.repo_root).resolve() if args.repo_root else script_dir.parent
    rscript = find_rscript(args.rscript)
    python_exe = find_python(repo_root)

    if not args.skip_harvest:
        # Le harvest R garde DataCite comme source primaire, puis enrichit
        # les articles parents avec OpenAlex et Crossref.
        run_step(
            [
                rscript,
                "tools/harvest_datacite.R",
                "--target",
                str(args.target),
                "--openalex-limit",
                str(args.openalex_limit),
                "--min-citations",
                str(args.min_citations),
                "--crossref-workers",
                str(args.crossref_workers),
                "--min-dataset-size-kb",
                str(args.min_dataset_size_kb),
                "--profiles",
                args.profiles,
                *(["--strict-spatial-only"] if args.strict_spatial_only else []),
                *(["--include-spatiotemporal"] if args.include_spatiotemporal else []),
                *(["--include-ecology-sdm"] if args.include_ecology_sdm else []),
            ],
            cwd=repo_root,
        )

    if not args.skip_verification:
        verify_cmd = [
            python_exe,
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

    if not args.skip_ingestion:
        run_step([python_exe, "tools/ingest_datacite_verified.py"], cwd=repo_root)

    print("\nPipeline DataCite termine.", flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
