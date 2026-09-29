"""Generate a read-only index of every dataset fiche grouped by
package_include / benchmark_status, so the wiki can be browsed by
validation state without physically moving fiche files around.

Why a generated page instead of a folder split: package_include changes
often (fiches get promoted or demoted as evidence is verified), and
encoding that status in a file *path* would require a matching file
move on every such change -- exactly the kind of dual-source-of-truth
drift (frontmatter says one thing, location implies another) this
project has repeatedly had to fix this session. A regenerated index
avoids that: it is never a source of truth itself, just a rendering of
the real one (each fiche's own benchmark_readiness block).

Usage:
    python tools/generate_fiches_status_index.py

Regenerate this after any batch of fiche status changes.
"""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FICHES_DIR = ROOT / "wiki/datasets/fiches_datasets"
OUT_PATH = ROOT / "wiki/datasets/INDEX_PAR_STATUT.md"

STATUS_LABELS = {
    "yes": "Validées (`package_include: yes`)",
    "manual_review": "En revue manuelle (`package_include: manual_review`)",
    "no": "Écartées (`package_include: no`)",
}
STATUS_ORDER = ["yes", "manual_review", "no", "autre"]


def extract_readiness(text: str) -> dict[str, str | None]:
    match = re.search(r"^benchmark_readiness:\n(.*?)(?=^```)", text, re.M | re.S)
    block = match.group(1) if match else ""

    def field(name: str) -> str | None:
        m = re.search(r'^\s*' + name + r':\s*"(.*?)"\s*$', block, re.M)
        return m.group(1) if m else None

    package_include = field("package_include")
    benchmark_status = field("benchmark_status")
    reason = field("reason") or ""
    return {
        "package_include": package_include,
        "benchmark_status": benchmark_status,
        "reason": reason,
    }


def extract_title(text: str) -> str:
    m = re.search(r"^title:\s*(.+?)\s*$", text, re.M)
    return m.group(1) if m else "?"


def short_reason(reason: str, limit: int = 140) -> str:
    reason = reason.strip()
    if not reason:
        return ""
    if len(reason) <= limit:
        return reason
    return reason[:limit].rstrip() + "…"


def main() -> None:
    rows = []
    for path in sorted(FICHES_DIR.glob("*.md")):
        text = path.read_text(encoding="utf-8")
        title = extract_title(text)
        readiness = extract_readiness(text)
        status = readiness["package_include"] or "autre"
        if status not in STATUS_LABELS:
            status = "autre"
        rows.append({
            "id": title,
            "status": status,
            "benchmark_status": readiness["benchmark_status"] or "?",
            "reason": short_reason(readiness["reason"]),
        })

    by_status: dict[str, list[dict]] = {s: [] for s in STATUS_ORDER}
    for r in rows:
        by_status[r["status"]].append(r)

    lines = [
        "---",
        "title: Index des fiches datasets par statut",
        "type: metadata",
        f"updated: {__import__('datetime').date.today().isoformat()}",
        "tags: [metadata, index, generated]",
        "---",
        "",
        "> **Page générée automatiquement par `tools/generate_fiches_status_index.py`. "
        "Ne pas éditer à la main — relancer le script pour la rafraîchir après un batch "
        "de changements de statut.** Le statut affiché ici est une lecture du bloc "
        "`benchmark_readiness` de chaque fiche (`package_include`), jamais une "
        "information stockée séparément — aucun risque de désynchronisation.",
        "",
        f"Total : {len(rows)} fiches.",
        "",
    ]

    for status in STATUS_ORDER:
        group = by_status[status]
        if not group and status == "autre":
            continue
        label = STATUS_LABELS.get(status, "Statut non reconnu")
        lines.append(f"## {label} — {len(group)} fiches")
        lines.append("")
        if not group:
            lines.append("_Aucune fiche dans cette catégorie._")
            lines.append("")
            continue
        lines.append("| Fiche | benchmark_status | Raison (tronquée) |")
        lines.append("|---|---|---|")
        for r in sorted(group, key=lambda x: x["id"].lower()):
            reason_cell = r["reason"].replace("|", "\\|").replace("\n", " ")
            lines.append(f"| [[{r['id']}]] | `{r['benchmark_status']}` | {reason_cell} |")
        lines.append("")

    OUT_PATH.write_text("\n".join(lines), encoding="utf-8", newline="\n")
    counts = {s: len(by_status[s]) for s in STATUS_ORDER}
    print(json.dumps({"total": len(rows), "by_status": counts, "out": str(OUT_PATH)}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
