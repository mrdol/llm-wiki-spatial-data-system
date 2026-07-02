import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent))
from regression_findings import FINDINGS

ROOT = Path(__file__).resolve().parents[2]  # tools/regression_formulas_2026-07/ -> repo root
PKG_DIR = ROOT / "wiki" / "datasets" / "packages"

missing = []
for did in FINDINGS:
    p = PKG_DIR / f"{did}.md"
    if not p.exists():
        missing.append(did)

all_files = {p.stem for p in PKG_DIR.glob("*.md")}
covered = set(FINDINGS.keys())
uncovered = sorted(all_files - covered)

print("MISSING FILES FOR FINDINGS KEYS:")
for m in missing:
    print(" ", m)
print(f"\nTotal fiches on disk: {len(all_files)}")
print(f"Total findings entries: {len(covered)}")
print(f"\nUNCOVERED FICHES ({len(uncovered)}):")
for u in uncovered:
    print(" ", u)
