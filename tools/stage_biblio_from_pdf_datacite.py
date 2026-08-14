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
import json
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
DEFAULT_KG = REPO_ROOT / "inst" / "kg" / "paper_dataset_uses.json"
DEFAULT_BATCH = "llm_wiki_datacite_2026_08"
READY_STATUS = "pdf_present_pending_grobid"
MAX_STAGED_STEM_CHARS = 90
RAW_PDF_REL = Path("corpus") / "papers" / "raw_pdf"


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


def read_batch_bib_dois(biblio_root: Path, batch: str) -> dict[str, str]:
    """Associe chaque citekey du .bib du lot a son DOI (en minuscules)."""
    bib_path = biblio_root / f"{batch}.bib"
    if not bib_path.exists():
        raise FileNotFoundError(f".bib du lot introuvable: {bib_path}")
    text = bib_path.read_text(encoding="utf-8", errors="replace")
    result: dict[str, str] = {}
    for entry_match in re.finditer(r"@\w+\{\s*([^,\s]+)\s*,(.*?)\n\}", text, flags=re.DOTALL):
        citekey = entry_match.group(1)
        body = entry_match.group(2)
        doi_match = re.search(r"doi\s*=\s*\{([^}]+)\}", body, flags=re.IGNORECASE)
        if doi_match:
            result[citekey] = doi_match.group(1).strip().lower()
    return result


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with open(windows_long_path(path), "rb") as handle:
        for chunk in iter(lambda: handle.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def dedupe_after_import(
    biblio_root: Path,
    batch: str,
    manifest_path: Path,
    kg_path: Path,
    apply: bool,
) -> None:
    """Supprime les anciens PDF (nom descriptif) une fois la copie citekey
    importee et verifiee identique, et resynchronise CSV/KG sur le nouveau nom.

    Sans cette etape, `import-apply` laisse deux copies du meme PDF dans
    `corpus/papers/raw_pdf/` (l'original depose en Phase 2-3, et la copie
    renommee par pdf2bib) -- voir la discussion du 2026-08-12.
    """
    citekey_by_doi = {doi: key for key, doi in read_batch_bib_dois(biblio_root, batch).items()}

    with manifest_path.open("r", encoding="utf-8-sig", newline="") as handle:
        reader = csv.DictReader(handle, delimiter=";")
        rows = list(reader)
        fieldnames = reader.fieldnames or []

    raw_pdf_dir = REPO_ROOT / RAW_PDF_REL
    renamed: list[tuple[str, str, str]] = []  # doi, old_name, citekey
    unchanged: list[str] = []
    problems: list[str] = []

    for row in rows:
        pdoi = (row.get("publication_doi") or "").strip().lower()
        citekey = citekey_by_doi.get(pdoi)
        if not citekey:
            continue
        old_local = (row.get("local_pdf") or "").strip()
        if not old_local:
            continue
        old_name = Path(old_local).name
        if old_name == f"{citekey}.pdf":
            unchanged.append(pdoi)
            continue

        old_path = raw_pdf_dir / old_name
        new_path = raw_pdf_dir / f"{citekey}.pdf"
        if not new_path.exists():
            problems.append(f"{pdoi}: copie citekey absente ({new_path.name}), rien fait")
            continue
        if not old_path.exists():
            problems.append(f"{pdoi}: ancien fichier deja absent ({old_name}), CSV/KG resynchronises quand meme")
        elif old_path.stat().st_size != new_path.stat().st_size or sha256_file(old_path) != sha256_file(new_path):
            problems.append(f"{pdoi}: contenu different entre '{old_name}' et '{citekey}.pdf' -- suppression annulee")
            continue

        renamed.append((pdoi, old_name, citekey))
        if apply:
            if old_path.exists():
                os.remove(windows_long_path(old_path))
            row["local_pdf"] = str(RAW_PDF_REL / f"{citekey}.pdf")
            row["note"] = (row.get("note") or "") + f" | dedup: renomme {citekey}.pdf via pdf2bib, ancien '{old_name}' supprime"

    if apply and renamed:
        with manifest_path.open("w", encoding="utf-8-sig", newline="") as handle:
            writer = csv.DictWriter(handle, fieldnames=fieldnames, delimiter=";")
            writer.writeheader()
            writer.writerows(rows)

    kg_updates: list[str] = []
    if kg_path.exists():
        kg = json.loads(kg_path.read_text(encoding="utf-8-sig"))
        for rec in kg.get("records", []):
            pdoi = (rec.get("paper_doi") or "").strip().lower()
            citekey = citekey_by_doi.get(pdoi)
            if not citekey:
                continue
            new_rel = str(RAW_PDF_REL / f"{citekey}.pdf")
            if rec.get("local_pdf") != new_rel:
                kg_updates.append(f"{rec.get('bib_key')} -> {citekey}.pdf")
                if apply:
                    rec["local_pdf"] = new_rel
        if apply and kg_updates:
            kg_path.write_text(json.dumps(kg, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")

    mode = "apply" if apply else "dry-run"
    print(f"[dedupe:{mode}] doublons a traiter: {len(renamed)}")
    for pdoi, old_name, citekey in renamed:
        print(f"  {pdoi}: {old_name} -> {citekey}.pdf")
    print(f"[dedupe:{mode}] deja au bon nom: {len(unchanged)}")
    print(f"[dedupe:{mode}] problemes: {len(problems)}")
    for message in problems:
        print(f"  ! {message}")
    print(f"[dedupe:{mode}] entrees KG a resynchroniser: {len(kg_updates)}")
    for message in kg_updates:
        print(f"  {message}")


def print_commands(biblio_root: Path, batch: str) -> None:
    """Affiche les commandes manuelles correspondant aux cinq phases."""
    script = "tools/stage_biblio_from_pdf_datacite.py"
    print("Commandes depuis llm-wiki-karpathy:")
    print(f"python {script} --phase prepare")
    print(f"python {script} --phase pdf2bib-dry-run")
    print(f"python {script} --phase pdf2bib-apply")
    print(f"python {script} --phase import-dry-run")
    print(f"python {script} --phase import-apply")
    print(f"python {script} --phase dedupe-dry-run")
    print(f"python {script} --phase dedupe-apply")
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
            "dedupe-dry-run",
            "dedupe-apply",
        ),
        default="commands",
        help="Phase a executer.",
    )
    parser.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    parser.add_argument("--kg", type=Path, default=DEFAULT_KG)
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

    if args.phase == "dedupe-dry-run":
        dedupe_after_import(biblio_root, args.batch, args.manifest.resolve(), args.kg.resolve(), apply=False)
        return 0

    if args.phase == "dedupe-apply":
        dedupe_after_import(biblio_root, args.batch, args.manifest.resolve(), args.kg.resolve(), apply=True)
        return 0

    raise AssertionError(f"Phase non geree: {args.phase}")


if __name__ == "__main__":
    raise SystemExit(main())
