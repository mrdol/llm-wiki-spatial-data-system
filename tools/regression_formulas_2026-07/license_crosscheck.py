import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]  # tools/regression_formulas_2026-07/ -> repo root
PKG_DIR = ROOT / "wiki" / "datasets" / "packages"
DOC_DIR = ROOT / "wiki" / "datasets" / "r_package_docs"

for fpath in sorted(PKG_DIR.glob("*.md")):
    text = fpath.read_text(encoding="utf-8-sig")
    m2 = re.search(r"(?im)^-\s*Dataset name\s*:\s*(.+?)\s*$", text)
    if not m2:
        continue
    dsname = m2.group(1).strip()
    if "::" not in dsname:
        continue
    package, dataset = dsname.split("::", 1)
    pkgdir = DOC_DIR / package
    if not pkgdir.exists():
        continue
    candidates = list(pkgdir.glob("*.md"))
    pkgdoc = next((c for c in candidates if c.stem.lower() == package.lower()), None)
    if not pkgdoc:
        continue
    doctext = pkgdoc.read_text(encoding="utf-8", errors="replace")
    lic_m = re.search(r"(?im)^-\s*License\s*:\s*(.+?)\s*$", doctext)
    if not lic_m:
        continue
    doc_license = lic_m.group(1).strip()
    fiche_lic_m = re.search(r"(?im)^-\s*License name\s*:\s*(.+?)\s*$", text)
    fiche_license = fiche_lic_m.group(1).strip() if fiche_lic_m else None
    if fiche_license and fiche_license.replace(" ", "") != doc_license.replace(" ", ""):
        print(f'{fpath.stem}: fiche="{fiche_license}" vs doc="{doc_license}" (pkg={package})')

print("done")
