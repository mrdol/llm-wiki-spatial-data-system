"""Ingestion incrementale de papiers dans le KG.

Cette commande sert aux ajouts ponctuels de papiers. Elle evite de relancer
`run_all.py`, qui reparcourt tout le corpus TEI et tous les catalogues.

Workflow:
1. lancer GROBID seulement pour les PDF qui n'ont pas encore de TEI;
2. parser seulement les TEI nouveaux ou dont l'extraction incrementale manque;
3. ecrire des JSONL par papier dans `.kg/extracted/`;
4. reconstruire `.kg/graph.sqlite` une seule fois;
5. ajouter une entree courte dans `wiki/log.md`.

Exemples:
  python tools/kg/ingest_papers.py --pdf "paper.pdf"
  python tools/kg/ingest_papers.py --from-bib
  python tools/kg/ingest_papers.py --missing-only --dry-run
"""

from __future__ import annotations

import argparse
import hashlib
import subprocess
import sys
from datetime import date
from pathlib import Path

from importlib import import_module


ROOT = Path(__file__).resolve().parents[2]
OUT_DIR = ROOT / ".kg" / "extracted"
LOG_PATH = ROOT / "wiki" / "log.md"

if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))


grobid = import_module("tools.kg.02_run_grobid")
tei_parser = import_module("tools.kg.03_parse_tei")


def incremental_stem(tei_path: Path) -> str:
    """Construit un prefixe stable pour les extractions JSONL d'un TEI."""
    raw_stem = tei_parser.slug(tei_path.stem.replace(".tei", ""))
    digest = hashlib.sha1(raw_stem.encode("utf-8")).hexdigest()[:10]
    stem = raw_stem[:80].strip("_")
    return f"zz_incremental_tei_{stem}_{digest}"


def incremental_paths(tei_path: Path) -> tuple[Path, Path]:
    """Retourne les fichiers JSONL incrementaux associes a un TEI."""
    stem = incremental_stem(tei_path)
    return OUT_DIR / f"{stem}_nodes.jsonl", OUT_DIR / f"{stem}_edges.jsonl"


def resolve_pdf(value: str) -> Path:
    """Retrouve un PDF par chemin absolu, chemin relatif ou nom dans raw_pdf."""
    candidates = [Path(value), ROOT / value, grobid.RAW_PDF_DIR / value]
    for candidate in candidates:
        if candidate.exists():
            return candidate.resolve()
    raise FileNotFoundError(f"PDF not found: {value}")


def select_pdfs(args: argparse.Namespace) -> list[Path]:
    """Selectionne les PDF cibles sans declencher d'action reseau."""
    if args.pdf:
        return sorted({resolve_pdf(value) for value in args.pdf})

    pdfs = grobid.bib_linked_pdf_files() if args.from_bib else grobid.all_pdf_files()
    if args.missing_only:
        pdfs = [path for path in pdfs if not grobid.tei_path_for(path).exists()]
    return sorted(pdfs)


def needs_incremental_parse(tei_path: Path, force: bool) -> bool:
    """Determine si le TEI doit etre parse pour cette couche incrementale."""
    node_path, edge_path = incremental_paths(tei_path)
    if force:
        return True
    if not node_path.exists() or not edge_path.exists():
        return True
    return tei_path.stat().st_mtime > min(node_path.stat().st_mtime, edge_path.stat().st_mtime)


def run_grobid_for_missing(pdfs: list[Path], args: argparse.Namespace) -> tuple[list[Path], list[Path], list[str]]:
    """Lance GROBID seulement sur les PDF sans TEI, sauf si --force-grobid."""
    written: list[Path] = []
    skipped: list[Path] = []
    failures: list[str] = []

    to_process = [pdf for pdf in pdfs if args.force_grobid or not grobid.tei_path_for(pdf).exists()]
    skipped = [pdf for pdf in pdfs if pdf not in to_process]

    if not to_process:
        return written, skipped, failures

    if args.dry_run:
        return written, skipped, failures

    if not grobid.grobid_is_alive(args.url, timeout=10):
        raise RuntimeError(
            "GROBID ne repond pas. Lance Docker/GROBID: "
            "docker run --rm -p 8070:8070 lfoppiano/grobid:latest-crf"
        )

    grobid.TEI_DIR.mkdir(parents=True, exist_ok=True)
    for pdf in to_process:
        try:
            result = grobid.process_pdf(pdf, args.url, args.timeout, force=args.force_grobid)
        except Exception as exc:  # noqa: BLE001 - l'ingestion doit lister les echecs.
            failures.append(f"{pdf.name}: {exc}")
            continue
        if result == "written":
            written.append(grobid.tei_path_for(pdf))
        else:
            skipped.append(pdf)

    return written, skipped, failures


def parse_incremental(tei_paths: list[Path], force: bool, dry_run: bool) -> list[dict[str, object]]:
    """Parse seulement les TEI cibles et ecrit des JSONL par papier."""
    method_aliases = tei_parser.load_method_aliases()
    dataset_aliases = tei_parser.load_dataset_aliases()
    dataset_variables = tei_parser.load_dataset_variables()
    variable_dataset_index = tei_parser.build_variable_dataset_index(dataset_variables)

    parsed: list[dict[str, object]] = []
    for tei_path in tei_paths:
        if not needs_incremental_parse(tei_path, force=force):
            continue
        if dry_run:
            parsed.append({"tei_file": str(tei_path.relative_to(ROOT)), "dry_run": True})
            continue

        nodes: dict[str, dict[str, object]] = {}
        edges: dict[str, dict[str, object]] = {}
        summary = tei_parser.parse_one_tei(
            tei_path,
            method_aliases,
            dataset_aliases,
            dataset_variables,
            variable_dataset_index,
            nodes,
            edges,
        )
        node_path, edge_path = incremental_paths(tei_path)
        tei_parser.write_jsonl(node_path, sorted(nodes.values(), key=lambda row: row["id"]))
        tei_parser.write_jsonl(edge_path, sorted(edges.values(), key=lambda row: row["id"]))
        summary["nodes"] = len(nodes)
        summary["edges"] = len(edges)
        summary["node_path"] = str(node_path.relative_to(ROOT))
        summary["edge_path"] = str(edge_path.relative_to(ROOT))
        parsed.append(summary)
    return parsed


def run_step(args: list[str], dry_run: bool) -> None:
    """Lance une etape Python locale ou l'affiche en mode dry-run."""
    print("==", " ".join(args))
    if dry_run:
        return
    subprocess.run([sys.executable, *args], cwd=ROOT, check=True)


def append_log(title: str, pdfs: list[Path], written_teis: list[Path], parsed: list[dict[str, object]], failures: list[str]) -> None:
    """Ajoute une entree courte dans wiki/log.md pour tracer l'ingestion."""
    LOG_PATH.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "",
        f"## [{date.today().isoformat()}] ingest-papers-incremental | {title}",
        "",
        "PDF selected:",
        *[f"- `corpus/papers/raw_pdf/{pdf.name}`" for pdf in pdfs],
        "",
        "TEI generated:",
        *([f"- `{path.relative_to(ROOT)}`" for path in written_teis] or ["- none"]),
        "",
        "TEI parsed incrementally:",
        *(
            [
                f"- `{row.get('tei_file')}` -> {row.get('nodes', 'dry-run')} nodes, {row.get('edges', 'dry-run')} edges"
                for row in parsed
            ]
            or ["- none"]
        ),
        "",
        "Graph rebuild:",
        "- `.kg/graph.sqlite` rebuilt once from extracted layers.",
    ]
    if failures:
        lines.extend(["", "Failures:", *[f"- {failure}" for failure in failures]])
    LOG_PATH.write_text(LOG_PATH.read_text(encoding="utf-8") + "\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Incrementally ingest paper PDFs into the KG.")
    parser.add_argument("--pdf", action="append", help="PDF name/path to ingest. May be repeated.")
    parser.add_argument("--from-bib", action="store_true", help="select PDFs linked in corpus/bib/references.bib")
    parser.add_argument("--missing-only", action="store_true", help="when no --pdf is given, select only PDFs without TEI")
    parser.add_argument("--force-grobid", action="store_true", help="regenerate TEI even if it exists")
    parser.add_argument("--force-parse", action="store_true", help="rewrite incremental JSONL even if already current")
    parser.add_argument("--dry-run", action="store_true", help="show actions without writing files or calling GROBID")
    parser.add_argument("--no-log", action="store_true", help="do not append wiki/log.md")
    parser.add_argument("--title", default="paper ingest", help="title used in wiki/log.md")
    parser.add_argument("--url", default="http://localhost:8070", help="GROBID base URL")
    parser.add_argument("--timeout", type=int, default=180, help="GROBID timeout in seconds per PDF")
    args = parser.parse_args()

    pdfs = select_pdfs(args)
    print(f"PDF selected: {len(pdfs)}")
    for pdf in pdfs:
        print(f"- {pdf.name}")
    if not pdfs:
        return 0

    written_teis, skipped_pdfs, failures = run_grobid_for_missing(pdfs, args)
    existing_teis = [grobid.tei_path_for(pdf) for pdf in pdfs if grobid.tei_path_for(pdf).exists()]
    candidate_teis = sorted({*written_teis, *existing_teis})
    parsed = parse_incremental(candidate_teis, force=args.force_parse, dry_run=args.dry_run)

    print("")
    print(f"TEI generated: {len(written_teis)}")
    print(f"PDF skipped existing TEI: {len(skipped_pdfs)}")
    print(f"TEI parsed incrementally: {len(parsed)}")
    print(f"Failures: {len(failures)}")
    for failure in failures:
        print(f"FAILED: {failure}", file=sys.stderr)

    if not args.dry_run:
        run_step(["tools/kg/04_build_graph.py"], dry_run=False)
        run_step(["tools/kg/06_make_summaries.py"], dry_run=False)
        run_step(["tools/kg/07_export_agent_index.py", "stats"], dry_run=False)

    if not args.no_log and not args.dry_run:
        append_log(args.title, pdfs, written_teis, parsed, failures)

    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
