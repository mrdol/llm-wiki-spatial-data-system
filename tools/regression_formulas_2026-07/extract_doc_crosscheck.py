\
# -*- coding: utf-8 -*-
"""For each fiche in wiki/datasets/packages, locate its r_package_docs topic
file and dump: current fiche N/T/Structure/License fields + raw doc excerpts
(Format section, any License/@source-like lines) for manual cross-check.
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]  # tools/regression_formulas_2026-07/ -> repo root
PKG_DIR = ROOT / "wiki" / "datasets" / "packages"
DOC_DIR = ROOT / "wiki" / "datasets" / "r_package_docs"


def first_existing(paths):
    for p in paths:
        if p.exists():
            return p
    return None


def find_doc(package: str, dataset: str):
    base_dir = DOC_DIR / package / "topics"
    if not base_dir.is_dir():
        return None
    base = re.split(r"\.(df|pred|val|dat|c|sf)$", dataset.lower())[0]
    candidates = [dataset, dataset.lower(), base]
    return first_existing([base_dir / f"{name}.md" for name in candidates])


def field(text, label):
    m = re.search(rf"(?im)^{re.escape(label)}\s*:\s*(.+?)\s*$", text)
    return m.group(1).strip() if m else None


def parse_fiche_meta(text):
    def g(label):
        m = re.search(rf"(?im)^-\s*{re.escape(label)}\s*:\s*(.+?)\s*$", text)
        return m.group(1).strip() if m else None
    return {
        "package_field": g("Source"),
        "N": g("N observations"),
        "T": g("T periods"),
        "structure": g("Structure"),
        "data_type": g("Data type"),
        "license_name": g("License name"),
        "dataset_name": g("Dataset name"),
    }


def extract_doc_sections(text):
    result = {}
    for section in ["Format", "Source", "Description", "References"]:
        m = re.search(
            rf"{section}\s*\n+\s*(.*?)(?:\n\s*\n|\n(?:Format|Usage|Arguments|Value|Source|References|Examples|Author)\b)",
            text, re.DOTALL,
        )
        if m:
            result[section] = " ".join(m.group(1).split())[:500]
    license_m = re.search(r"(?im)^license\s*:?\s*(.+?)\s*$", text)
    if license_m:
        result["License_field"] = license_m.group(1).strip()
    return result


def main():
    rows = []
    no_doc = []
    for fpath in sorted(PKG_DIR.glob("*.md")):
        ftext = fpath.read_text(encoding="utf-8-sig")
        meta = parse_fiche_meta(ftext)
        dsname = meta["dataset_name"] or ""
        if "::" in dsname:
            package, dataset = dsname.split("::", 1)
        else:
            package, dataset = "", fpath.stem
        doc_path = find_doc(package, dataset)
        if not doc_path:
            no_doc.append(fpath.stem)
            continue
        doc_text = doc_path.read_text(encoding="utf-8", errors="replace")
        doc_info = extract_doc_sections(doc_text)
        rows.append((fpath.stem, meta, doc_info, doc_path.relative_to(ROOT)))

    out = []
    for stem, meta, doc_info, doc_rel in rows:
        out.append(f"=== {stem} ===")
        out.append(f"  fiche: N={meta['N']} T={meta['T']} structure={meta['structure']} data_type={meta['data_type']} license_name={meta['license_name']}")
        out.append(f"  doc: {doc_rel}")
        for k in ["Format", "Source", "License_field"]:
            if k in doc_info:
                out.append(f"  doc.{k}: {doc_info[k]}")
        out.append("")

    report = "\n".join(out)
    out_path = Path(__file__).parent / "doc_crosscheck_report.txt"
    out_path.write_text(report, encoding="utf-8")
    print(f"Wrote {out_path} ({len(rows)} matched, {len(no_doc)} without doc)")
    print("NO DOC:", no_doc)


if __name__ == "__main__":
    main()
