"""Tier 3 - manual review queue.

Maintains wiki/eval_queue.md for amber fiches and writes rejection reports
under .eval/rejected/.
"""

from __future__ import annotations

import json
from datetime import date
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent.parent.parent  # LLM-wiki-Assessment/eval/ → llm-wiki-karpathy/
QUEUE_PATH = PROJECT_ROOT / "wiki" / "eval_queue.md"
REJECTED_DIR = PROJECT_ROOT / ".eval" / "rejected"

QUEUE_HEADER = """---
title: File de verification manuelle
type: metadata
created: {today}
updated: {today}
sources: []
tags: [eval, queue, review]
---

File des fiches wiki a revision manuelle (score Tier 2 entre 0.50 et 0.74).
Cocher la case et corriger la fiche, puis relancer `python eval/run_eval.py <fiche>`.

| Date | Fiche | Score | Type | Champs suspects | Raison | Statut |
|------|-------|-------|------|-----------------|--------|--------|
"""


def _load_queue() -> tuple[str, list[str]]:
    """Return (header, table rows)."""
    if not QUEUE_PATH.exists():
        today = date.today().isoformat()
        return QUEUE_HEADER.format(today=today), []

    text = QUEUE_PATH.read_text(encoding="utf-8-sig")
    lines = text.splitlines()

    header_end = 0
    for i, line in enumerate(lines):
        if line.startswith("|---"):
            header_end = i + 1
            break

    header = "\n".join(lines[:header_end]) + "\n"
    rows = [line for line in lines[header_end:] if line.startswith("|")]
    return header, rows


def _save_queue(header: str, rows: list[str]) -> None:
    QUEUE_PATH.write_text(header + "\n".join(rows) + "\n", encoding="utf-8")


def _entity_type(fiche_path: Path) -> str:
    try:
        from .tier1_structural import parse_frontmatter

        text = fiche_path.read_text(encoding="utf-8-sig")
        frontmatter, _ = parse_frontmatter(text)
        return str((frontmatter or {}).get("type", "?"))
    except Exception:
        return "?"


def add_to_queue(fiche_path: Path, score: float, fields_to_review: list[str], reasoning: str) -> None:
    """Add or update an amber fiche in eval_queue.md."""
    stem = fiche_path.stem
    today = date.today().isoformat()
    entity_type = _entity_type(fiche_path)

    fields_str = ", ".join(fields_to_review) if fields_to_review else "-"
    reason_short = reasoning[:80].replace("|", "/") if reasoning else "-"
    new_row = f"| {today} | [[{stem}]] | {score:.2f} | {entity_type} | {fields_str} | {reason_short} | [ ] a corriger |"

    header, rows = _load_queue()

    for i, row in enumerate(rows):
        if f"[[{stem}]]" in row:
            rows[i] = new_row
            break
    else:
        rows.append(new_row)

    header_lines = header.splitlines()
    for i, line in enumerate(header_lines):
        if line.startswith("updated:"):
            header_lines[i] = f"updated: {today}"
            break
    header = "\n".join(header_lines) + "\n"

    _save_queue(header, rows)


def add_to_rejected(fiche_path: Path, score: float, details: dict, reasoning: str) -> None:
    """Write a rejection report under .eval/rejected/."""
    REJECTED_DIR.mkdir(parents=True, exist_ok=True)
    today = date.today().isoformat()
    report_path = REJECTED_DIR / f"{today}_{fiche_path.stem}.json"

    report = {
        "fiche": str(fiche_path.relative_to(PROJECT_ROOT)),
        "date": today,
        "score": score,
        "reasoning": reasoning,
        "details": details,
    }
    report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")


def remove_from_queue(fiche_path: Path) -> None:
    """Remove a fiche from the review queue after correction and validation."""
    stem = fiche_path.stem
    header, rows = _load_queue()
    rows = [row for row in rows if f"[[{stem}]]" not in row]
    _save_queue(header, rows)
