"""Command-line interface (see ``tools/audit_datapaper_repositories.py``)."""

from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path

from . import report
from .netcache import HttpClient
from .pipeline import Auditor, select_papers
from .providers import Config

REPO_ROOT = Path(__file__).resolve().parents[2]
REVIEW = REPO_ROOT / "extensions_projet_2026-09" / "revue_jeux_donnees_benchmark"
DEFAULT_GRID = REVIEW / "grille_comparative_20_data_papers_2026-09-26.tsv"
DEFAULT_TEI = REVIEW / "tei"
DEFAULT_OUT = REVIEW / "repo_audit"
PROVIDERS = ["github", "gitlab", "zenodo", "figshare", "dryad", "dataverse", "osf", "openml", "edi", "datacite", "doi", "web"]


def parser() -> argparse.ArgumentParser:
    common = argparse.ArgumentParser(add_help=False)
    common.add_argument("--grid", type=Path, default=DEFAULT_GRID, help="comparison grid TSV (one row per data paper)")
    common.add_argument("--tei-dir", type=Path, default=DEFAULT_TEI)
    common.add_argument("--out", type=Path, default=DEFAULT_OUT, help="single output directory (cache/ inside)")
    common.add_argument("--cache-dir", type=Path, default=None, help="cache location (default: <out>/cache); use a non-synced folder if needed")
    common.add_argument("--paper", action="append", help="paper id(s), e.g. DP17 or DP17,DP19 (repeatable); default: all")
    common.add_argument("--provider", action="append", choices=PROVIDERS, help="restrict to these providers (repeatable)")
    common.add_argument("--offline", action="store_true", help="use the cache only; never touch the network")
    common.add_argument("--refresh", action="store_true", help="ignore cached responses and completed state")
    common.add_argument("--max-file-mb", type=float, default=2.0, help="largest single text file read during inspect")
    common.add_argument("--max-repo-mb", type=float, default=50.0, help="bytes fetched per resource during inspect (incl. ZIP listings)")
    common.add_argument("--max-files", type=int, default=150, help="files read per repository, by priority")
    common.add_argument("--max-depth", type=int, default=1, help="follow links discovered inside resources up to this depth")
    common.add_argument("--inspect-cited", action="store_true", help="also read third-party deposits cited only in the bibliography")
    common.add_argument("--no-clone", action="store_true", help="never fall back to a partial git clone")
    common.add_argument("--redo", action="store_true", help="recompute inventory/inspect state from the HTTP cache (after a rule change)")
    common.add_argument("--workers", type=int, default=4)

    p = argparse.ArgumentParser(prog="audit_datapaper_repositories", description=__doc__)
    sub = p.add_subparsers(dest="command", required=True)
    sub.add_parser("inventory", parents=[common], help="metadata and file trees only (no data download)")
    sub.add_parser("inspect", parents=[common], help="targeted reading of small text files of inventoried resources")
    sub.add_parser("report", parents=[common], help="(re)write manifest, evidence, comparison and report from state")
    sub.add_parser("run", parents=[common], help="inventory + inspect (+ discovered links up to --max-depth) + report")
    return p


TOKEN_KEYS = ("GITHUB_TOKEN", "GH_TOKEN")


def load_github_token(env_file: Path) -> str | None:
    """Export GITHUB_TOKEN/GH_TOKEN from the repository .env (only these keys; never printed)."""
    if any(os.environ.get(k) for k in TOKEN_KEYS):
        return "environment"
    if not env_file.exists():
        return None
    for line in env_file.read_text(encoding="utf-8", errors="replace").splitlines():
        key, sep, value = line.strip().partition("=")
        key = key.removeprefix("export ").strip()
        if sep and key in TOKEN_KEYS and value.strip():
            os.environ[key] = value.strip().strip("'\"")
            return ".env"
    return None


def main(argv: list[str] | None = None) -> int:
    argv = list(sys.argv[1:] if argv is None else argv)
    args = parser().parse_args(argv)
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    token_source = load_github_token(REPO_ROOT / ".env")
    print(f"GitHub token: {'found in ' + token_source if token_source else 'none (anonymous API, 60 requests/hour)'}")
    out = args.out.resolve()
    rows = select_papers(args.grid, args.paper)
    cfg = Config(
        cache_dir=(args.cache_dir or out / "cache").resolve(),
        max_file_bytes=int(args.max_file_mb * 1024 * 1024),
        max_repo_bytes=int(args.max_repo_mb * 1024 * 1024),
        max_files=args.max_files,
        allow_clone=not args.no_clone,
        offline=args.offline,
        refresh=args.refresh,
    )
    http = HttpClient(cfg.cache_dir, offline=args.offline, refresh=args.refresh)
    ctx = {"grid": args.grid.resolve(), "tei_dir": args.tei_dir.resolve(), "out": out, "repo_root": REPO_ROOT}
    auditor = Auditor(ctx, cfg, http, args.workers, set(args.provider) if args.provider else None, args.max_depth, args.inspect_cited, redo=args.redo)
    print(f"{args.command}: {len(rows)} paper(s) -> {out}")
    if args.command == "inventory":
        auditor.inventory(rows)
    elif args.command == "inspect":
        auditor.inspect(rows)
    elif args.command == "run":
        auditor.run(rows)
    if args.command != "report":
        auditor.save_run_meta(args.command, ["python", "tools/audit_datapaper_repositories.py", *argv])
    if args.command in ("report", "run"):
        counts = report.build(out, rows, cfg.cache_dir)
        print(f"report: {counts['manifest']} manifest rows, {counts['evidence']} evidence rows, {counts['comparison']} comparison rows")
        for warning in counts["warnings"]:
            print(f"WARNING: {warning}")
    print(f"network calls this run: {http.network_calls}; blocked hosts: {http.blocked_hosts or 'none'}")
    return 0
