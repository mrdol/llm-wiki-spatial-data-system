"""Lancer GROBID sur les PDF du corpus.

Entrees possibles:
- corpus/papers/raw_pdf/*.pdf
- corpus/bib/references.bib si l'option --from-bib est utilisee

Sortie:
- corpus/papers/tei/*.tei.xml

Ce script ne demarre pas Docker. Il suppose que GROBID tourne deja, par exemple:

    docker run --rm -p 8070:8070 lfoppiano/grobid:latest-crf

Utilisation:

    python tools/kg/02_run_grobid.py
    python tools/kg/02_run_grobid.py --from-bib
    python tools/kg/02_run_grobid.py --pdf "paper.pdf"
    python tools/kg/02_run_grobid.py --dry-run
    python tools/kg/02_run_grobid.py --force
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

import requests


ROOT = Path(__file__).resolve().parents[2]
BIB_PATH = ROOT / "corpus" / "bib" / "references.bib"
RAW_PDF_DIR = ROOT / "corpus" / "papers" / "raw_pdf"
TEI_DIR = ROOT / "corpus" / "papers" / "tei"


def tei_path_for(pdf_path: Path) -> Path:
    """Construit le chemin TEI correspondant a un PDF."""
    return TEI_DIR / f"{pdf_path.stem}.tei.xml"


def normalize_text_path(value: str) -> str:
    """Normalise un chemin pour comparer BibTeX et chemins Windows."""
    return value.replace("\\", "/").lower()


def all_pdf_files() -> list[Path]:
    """Retourne tous les PDF presents dans corpus/papers/raw_pdf."""
    if not RAW_PDF_DIR.exists():
        return []
    return sorted(RAW_PDF_DIR.glob("*.pdf"))


def bib_linked_pdf_files() -> list[Path]:
    """Retourne les PDF locaux du corpus qui apparaissent dans references.bib."""
    if not BIB_PATH.exists():
        raise FileNotFoundError(BIB_PATH)

    bib_text = normalize_text_path(BIB_PATH.read_text(encoding="utf-8", errors="ignore"))
    linked: list[Path] = []

    for pdf_path in all_pdf_files():
        name = normalize_text_path(pdf_path.name)
        rel = normalize_text_path(str(pdf_path.relative_to(ROOT)))
        absolute = normalize_text_path(str(pdf_path))

        # JabRef peut stocker seulement le nom, un chemin relatif, ou un chemin absolu.
        if name in bib_text or rel in bib_text or absolute in bib_text:
            linked.append(pdf_path)

    return linked


def grobid_is_alive(base_url: str, timeout: int) -> bool:
    """Verifie que le service GROBID repond."""
    try:
        response = requests.get(f"{base_url.rstrip('/')}/api/isalive", timeout=timeout)
    except requests.RequestException:
        return False
    return response.ok and response.text.strip().lower() == "true"


def looks_like_tei(text: str) -> bool:
    """Controle minimal pour eviter de sauver une page d'erreur comme TEI."""
    sample = text[:500].lower()
    return "<tei" in sample or "<tei:" in sample


def process_pdf(pdf_path: Path, base_url: str, timeout: int, force: bool) -> str:
    """Envoie un PDF a GROBID et ecrit le TEI."""
    out_path = tei_path_for(pdf_path)
    if out_path.exists() and not force:
        return "skipped"

    with pdf_path.open("rb") as fh:
        response = requests.post(
            f"{base_url.rstrip('/')}/api/processFulltextDocument",
            files={"input": (pdf_path.name, fh, "application/pdf")},
            timeout=timeout,
        )

    response.raise_for_status()
    if not looks_like_tei(response.text):
        raise ValueError(f"GROBID response does not look like TEI for {pdf_path.name}")

    out_path.write_text(response.text, encoding="utf-8")
    return "written"


def select_pdfs(from_bib: bool, pdf_name: str | None) -> list[Path]:
    """Choisit les PDF a traiter selon le mode demande."""
    if pdf_name:
        candidates = [
            Path(pdf_name),
            RAW_PDF_DIR / pdf_name,
        ]
        for candidate in candidates:
            if candidate.exists():
                return [candidate.resolve()]
        raise FileNotFoundError(f"PDF not found: {pdf_name}")

    return bib_linked_pdf_files() if from_bib else all_pdf_files()


def main() -> int:
    parser = argparse.ArgumentParser(description="Run GROBID on corpus PDF files.")
    parser.add_argument(
        "--from-bib",
        action="store_true",
        help="traiter seulement les PDF deja lies dans corpus/bib/references.bib",
    )
    parser.add_argument(
        "--pdf",
        help="traiter un seul PDF par nom de fichier ou chemin",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="regenerer les TEI meme s'ils existent deja",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="afficher les PDF qui seraient traites sans appeler GROBID",
    )
    parser.add_argument(
        "--url",
        default="http://localhost:8070",
        help="URL de base du service GROBID",
    )
    parser.add_argument(
        "--timeout",
        type=int,
        default=180,
        help="timeout en secondes pour chaque appel GROBID",
    )
    parser.add_argument(
        "--limit",
        type=int,
        default=0,
        help="limiter le nombre de PDF traites, 0 signifie aucune limite",
    )
    args = parser.parse_args()

    TEI_DIR.mkdir(parents=True, exist_ok=True)
    pdfs = select_pdfs(args.from_bib, args.pdf)
    if args.limit and args.limit > 0:
        pdfs = pdfs[: args.limit]

    mode = "references.bib" if args.from_bib else "raw_pdf"
    print(f"GROBID input mode: {mode}")
    print(f"GROBID input dir: {RAW_PDF_DIR}")
    print(f"GROBID output dir: {TEI_DIR}")
    print(f"PDF selected: {len(pdfs)}")

    if not pdfs:
        return 0

    for pdf in pdfs:
        out = tei_path_for(pdf)
        status = "overwrite" if args.force and out.exists() else ("skip-existing" if out.exists() else "to-process")
        print(f"- {status}: {pdf.name} -> {out.name}")

    if args.dry_run:
        return 0

    if not grobid_is_alive(args.url, timeout=10):
        print(
            "\nGROBID ne repond pas. Lance d'abord Docker/GROBID dans une autre fenetre:\n"
            "  docker run --rm -p 8070:8070 lfoppiano/grobid:latest-crf\n",
            file=sys.stderr,
        )
        return 2

    written = 0
    skipped = 0
    failed = 0

    for pdf in pdfs:
        try:
            result = process_pdf(pdf, args.url, args.timeout, args.force)
        except Exception as exc:  # noqa: BLE001 - on veut continuer avec les autres PDF.
            failed += 1
            print(f"FAILED: {pdf.name}: {exc}", file=sys.stderr)
            continue

        if result == "written":
            written += 1
            print(f"WRITTEN: {tei_path_for(pdf).name}")
        else:
            skipped += 1

    print("")
    print(f"TEI written: {written}")
    print(f"TEI skipped: {skipped}")
    print(f"PDF failed: {failed}")
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
