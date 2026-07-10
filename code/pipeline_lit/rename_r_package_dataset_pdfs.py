"""Rename downloaded R package dataset papers with readable filenames."""

from __future__ import annotations

import argparse
import csv
import re
import unicodedata
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
DEFAULT_MANIFEST = ROOT / "data" / "manifests" / "datasets" / "software_r_dataset_papers_downloads.csv"


def safe_name(value: str) -> str:
    value = (value or "").replace("https://doi.org/", "")
    value = re.sub(r"<[^>]+>", " ", value)
    value = value.replace("&amp;", "and").replace("&lt;", "").replace("&gt;", "")
    value = unicodedata.normalize("NFKD", value).encode("ascii", "ignore").decode("ascii")
    value = re.sub(r'[<>:"/\\|?*\x00-\x1f]+', " ", value.strip())
    value = re.sub(r"\s+", " ", value).strip(" .")
    if len(value) > 130:
        value = value[:130].rsplit(" ", 1)[0].strip(" .")
    return value or "unknown"


def target_name(row: dict[str, str]) -> str:
    pairs = [p.strip() for p in (row.get("package_datasets") or "").split("|") if p.strip()]
    if pairs:
        dataset = pairs[0].replace("::", "_")
    else:
        package = row.get("package") or "r_dataset"
        dataset_name = row.get("dataset") or "paper"
        dataset = f"{package}_{dataset_name}"
    title = row.get("title") or row.get("paper_or_book_title") or row.get("doi") or "paper"
    return f"{safe_name(dataset + ' - ' + title)}.pdf"


def unique_target(path: Path) -> Path:
    if not path.exists():
        return path
    stem = path.stem
    suffix = path.suffix
    index = 2
    while True:
        candidate = path.with_name(f"{stem} ({index}){suffix}")
        if not candidate.exists():
            return candidate
        index += 1


def rename_from_manifest(manifest: Path, *, dry_run: bool = False) -> list[tuple[str, str]]:
    with manifest.open(encoding="utf-8-sig", newline="") as fh:
        rows = list(csv.DictReader(fh, delimiter=";"))
    if not rows:
        return []

    changed: list[tuple[str, str]] = []
    for row in rows:
        rel_path = row.get("downloaded_file") or ""
        if not rel_path:
            continue
        source = (ROOT / rel_path).resolve()
        if not source.exists():
            continue
        base_target = source.with_name(target_name(row))
        if base_target.resolve() == source:
            continue
        target = unique_target(base_target)
        if dry_run:
            changed.append((str(source), str(target)))
            continue

        source.rename(target)
        row["downloaded_file"] = str(target.relative_to(ROOT))
        changed.append((source.name, target.name))

    if not dry_run and changed:
        with manifest.open("w", encoding="utf-8-sig", newline="") as fh:
            writer = csv.DictWriter(fh, fieldnames=rows[0].keys(), delimiter=";")
            writer.writeheader()
            writer.writerows(rows)

    return changed


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    changed = rename_from_manifest(args.manifest.resolve(), dry_run=args.dry_run)
    print(f"renamed={len(changed)}")
    for source, target in changed:
        print(f"{source} => {target}")


if __name__ == "__main__":
    main()
