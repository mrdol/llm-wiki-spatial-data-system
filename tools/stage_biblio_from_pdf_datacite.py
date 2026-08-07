#!/usr/bin/env python
"""Prepare et orchestre le passage DataCite par Biblio_from_pdf.

Le script garde `llm-wiki-karpathy` comme source projet et utilise
`Biblio_from_pdf` seulement comme sas temporaire pour produire un `.bib`
enrichi depuis les PDF deja valides.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import os
import re
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_BIBLIO_ROOT = REPO_ROOT.parent / "Biblio_from_pdf"
DEFAULT_MANIFEST = (
    REPO_ROOT
    / "data"
    / "manifests"
    / "papers"
    / "datacite_verified_pdf_download_manifest.csv"
)
DEFAULT_BATCH = "llm_wiki_datacite_2026_08"
READY_STATUS = "pdf_present_pending_grobid"
MAX_STAGED_STEM_CHARS = 90


@dataclass(frozen=True)
class PdfCandidate:
    dataset_doi: str
    publication_doi: str
    publication_title: str
    local_pdf: Path
    source_url: str


def read_candidates(manifest: Path, status: str) -> list[PdfCandidate]:
    """Lit le manifeste et conserve les PDF prets a passer par pdf2bib."""
    if not manifest.exists():
        raise FileNotFoundError(f"Manifest introuvable: {manifest}")

    candidates: list[PdfCandidate] = []
    seen: set[Path] = set()
    with manifest.open("r", encoding="utf-8-sig", newline="") as handle:
        reader = csv.DictReader(handle, delimiter=";")
        for row in reader:
            if row.get("status") != status:
                continue
            local_pdf_value = (row.get("local_pdf") or "").strip()
            if not local_pdf_value:
                continue
            local_pdf = (REPO_ROOT / local_pdf_value).resolve()
            if local_pdf in seen:
                continue
            seen.add(local_pdf)
            candidates.append(
                PdfCandidate(
                    dataset_doi=(row.get("dataset_doi") or "").strip(),
                    publication_doi=(row.get("publication_doi") or "").strip(),
                    publication_title=(row.get("publication_title") or "").strip(),
                    local_pdf=local_pdf,
                    source_url=(row.get("source_url") or "").strip(),
                )
            )
    return candidates


def resolve_existing_pdf(path: Path) -> Path:
    """Retrouve un PDF meme quand Windows bloque sur un chemin tres long."""
    if path.exists():
        return path
    parent = path.parent
    if parent.exists():
        for candidate in parent.glob("*.pdf"):
            if candidate.name == path.name:
                return candidate.resolve()
    raise FileNotFoundError(f"PDF local introuvable: {path}")


def windows_long_path(path: Path) -> str:
    """Convertit un chemin Windows long en forme acceptee par les APIs fichier."""
    resolved = str(path.resolve())
    if sys.platform != "win32" or resolved.startswith("\\\\?\\"):
        return resolved
    return "\\\\?\\" + resolved


def copy_pdf(source: Path, destination: Path) -> None:
    """Copie un PDF en preservant les metadonnees, y compris avec chemins longs."""
    shutil.copy2(windows_long_path(source), windows_long_path(destination))


def safe_ascii_stem(value: str, fallback: str) -> str:
    """Construit une racine de fichier courte, ASCII et stable."""
    cleaned = re.sub(r"[^A-Za-z0-9]+", " ", value).strip()
    words = [word for word in cleaned.split() if word]
    stem = "".join(word[:1].upper() + word[1:30] for word in words[:8])
    if not stem:
        stem = fallback
    return stem[:MAX_STAGED_STEM_CHARS].rstrip("_- ")


def staged_pdf_name(candidate: PdfCandidate, source_pdf: Path) -> str:
    """Produit un nom court pour eviter les limites de chemins Windows."""
    title_stem = safe_ascii_stem(candidate.publication_title, source_pdf.stem)
    digest_source = candidate.publication_doi or candidate.dataset_doi or source_pdf.name
    digest = hashlib.sha1(digest_source.encode("utf-8", errors="replace")).hexdigest()[:8]
    return f"{title_stem}_{digest}.pdf"


def prepare_staging(
    candidates: list[PdfCandidate],
    biblio_root: Path,
    batch: str,
    overwrite: bool,
) -> Path:
    """Copie les PDF valides dans le dossier de staging Biblio_from_pdf."""
    staging_dir = (biblio_root / batch).resolve()
    staging_dir.mkdir(parents=True, exist_ok=True)

    copied = 0
    skipped = 0
    manifest_rows: list[dict[str, str]] = []
    for candidate in candidates:
        source_pdf = resolve_existing_pdf(candidate.local_pdf)

        destination = staging_dir / staged_pdf_name(candidate, source_pdf)
        if destination.exists():
            same_size = destination.stat().st_size == source_pdf.stat().st_size
            if same_size and not overwrite:
                skipped += 1
            elif overwrite:
                copy_pdf(source_pdf, destination)
                copied += 1
            else:
                raise FileExistsError(
                    "PDF deja present avec une taille differente; utilisez "
                    f"--overwrite-staging si vous voulez le remplacer: {destination}"
                )
        else:
            copy_pdf(source_pdf, destination)
            copied += 1

        manifest_rows.append(
            {
                "dataset_doi": candidate.dataset_doi,
                "publication_doi": candidate.publication_doi,
                "publication_title": candidate.publication_title,
                "source_pdf": str(source_pdf),
                "staged_pdf": str(destination),
                "source_url": candidate.source_url,
            }
        )

    staging_manifest = staging_dir / "_llm_wiki_staging_manifest.csv"
    with staging_manifest.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=[
                "dataset_doi",
                "publication_doi",
                "publication_title",
                "source_pdf",
                "staged_pdf",
                "source_url",
            ],
            delimiter=";",
        )
        writer.writeheader()
        writer.writerows(manifest_rows)

    print(f"[prepare] staging: {staging_dir}")
    print(f"[prepare] PDF copies: {copied}; deja presents: {skipped}; total: {len(candidates)}")
    print(f"[prepare] manifest: {staging_manifest}")
    return staging_dir


def run_command(cmd: list[str], cwd: Path) -> int:
    """Execute une commande en affichant clairement son contexte."""
    print("[run]", " ".join(cmd))
    print("[cwd]", cwd)
    return subprocess.call(cmd, cwd=str(cwd), env=tool_env())


def discover_poppler_bin() -> Path | None:
    """Trouve Poppler installe via winget si le PATH courant ne le voit pas."""
    if shutil.which("pdftotext") and shutil.which("pdftoppm") and shutil.which("pdfunite"):
        return None
    winget_root = Path.home() / "AppData" / "Local" / "Microsoft" / "WinGet" / "Packages"
    if not winget_root.exists():
        return None
    candidates = sorted(winget_root.glob("oschwartz10612.Poppler*/poppler-*/Library/bin"))
    for candidate in reversed(candidates):
        if (candidate / "pdftotext.exe").exists():
            return candidate
    return None


def tool_env() -> dict[str, str]:
    """Prepare l'environnement des outils PDF/OCR pour pdf2bib."""
    env = os.environ.copy()
    extra_paths: list[str] = []

    tesseract_dir = Path.home() / "AppData" / "Local" / "Tesseract-OCR"
    if (tesseract_dir / "tesseract.exe").exists():
        extra_paths.append(str(tesseract_dir))
        env.setdefault("TESSDATA_PREFIX", str(tesseract_dir / "tessdata"))

    poppler_bin = discover_poppler_bin()
    if poppler_bin is not None:
        extra_paths.append(str(poppler_bin))

    if extra_paths:
        env["PATH"] = ";".join(extra_paths + [env.get("PATH", "")])
    return env


def project_python() -> str:
    """Retourne le Python du projet, en evitant les Python systeme parasites."""
    workspace_venv = REPO_ROOT.parent / ".venv" / "Scripts" / "python.exe"
    if workspace_venv.exists():
        return str(workspace_venv)
    return sys.executable


def run_pdf2bib(biblio_root: Path, batch: str, apply: bool, overwrite: bool) -> int:
    """Lance pdf2bib depuis le depot Biblio_from_pdf."""
    cmd = [project_python(), "tools/pdf2bib.py", batch]
    if apply:
        cmd.append("--apply")
    if overwrite:
        cmd.append("--overwrite")
    return run_command(cmd, biblio_root)


def run_import_back(biblio_root: Path, batch: str, apply: bool) -> int:
    """Importe le `.bib` et les PDF renommes dans llm-wiki-karpathy."""
    cmd = [
        project_python(),
        "tools/import_to_llm_wiki.py",
        batch,
        "--target",
        str(REPO_ROOT),
    ]
    if not apply:
        cmd.append("--dry-run")
    return run_command(cmd, biblio_root)


def print_commands(biblio_root: Path, batch: str) -> None:
    """Affiche les commandes manuelles correspondant aux cinq phases."""
    script = "tools/stage_biblio_from_pdf_datacite.py"
    print("Commandes depuis llm-wiki-karpathy:")
    print(f"python {script} --phase prepare")
    print(f"python {script} --phase pdf2bib-dry-run")
    print(f"python {script} --phase pdf2bib-apply")
    print(f"python {script} --phase import-dry-run")
    print(f"python {script} --phase import-apply")
    print("")
    print("Commandes equivalentes depuis Biblio_from_pdf:")
    print(f"cd \"{biblio_root}\"")
    print(f"python tools/pdf2bib.py {batch}")
    print(f"python tools/pdf2bib.py {batch} --apply --overwrite")
    print(f"python tools/import_to_llm_wiki.py {batch} --target \"{REPO_ROOT}\" --dry-run")
    print(f"python tools/import_to_llm_wiki.py {batch} --target \"{REPO_ROOT}\"")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Stage les PDF DataCite de llm-wiki-karpathy vers Biblio_from_pdf."
    )
    parser.add_argument(
        "--phase",
        choices=(
            "commands",
            "prepare",
            "pdf2bib-dry-run",
            "pdf2bib-apply",
            "import-dry-run",
            "import-apply",
        ),
        default="commands",
        help="Phase a executer.",
    )
    parser.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    parser.add_argument("--biblio-root", type=Path, default=DEFAULT_BIBLIO_ROOT)
    parser.add_argument("--batch", default=DEFAULT_BATCH)
    parser.add_argument("--status", default=READY_STATUS)
    parser.add_argument(
        "--overwrite-staging",
        action="store_true",
        help="Remplace les PDF deja presents dans le sas si leur nom existe.",
    )
    parser.add_argument(
        "--overwrite-bib",
        action="store_true",
        help="Autorise pdf2bib a remplacer le fichier .bib du lot.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    biblio_root = args.biblio_root.resolve()
    if not biblio_root.exists():
        raise FileNotFoundError(f"Biblio_from_pdf introuvable: {biblio_root}")

    if args.phase == "commands":
        print_commands(biblio_root, args.batch)
        return 0

    if args.phase == "prepare":
        candidates = read_candidates(args.manifest.resolve(), args.status)
        if not candidates:
            raise RuntimeError(f"Aucun PDF avec status={args.status}")
        prepare_staging(candidates, biblio_root, args.batch, args.overwrite_staging)
        return 0

    if args.phase == "pdf2bib-dry-run":
        return run_pdf2bib(biblio_root, args.batch, apply=False, overwrite=False)

    if args.phase == "pdf2bib-apply":
        return run_pdf2bib(biblio_root, args.batch, apply=True, overwrite=args.overwrite_bib)

    if args.phase == "import-dry-run":
        return run_import_back(biblio_root, args.batch, apply=False)

    if args.phase == "import-apply":
        return run_import_back(biblio_root, args.batch, apply=True)

    raise AssertionError(f"Phase non geree: {args.phase}")


if __name__ == "__main__":
    raise SystemExit(main())
