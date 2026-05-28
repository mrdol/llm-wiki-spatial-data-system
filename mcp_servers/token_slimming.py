"""Compression légère des sorties terminal pour limiter le bruit dans le contexte."""

from __future__ import annotations

import re
from collections import Counter
from dataclasses import dataclass


@dataclass
class SlimmedOutput:
    """Résultat compact d'une sortie terminal."""

    summary: str
    important_lines: list[str]
    omitted_line_count: int
    original_line_count: int


ERROR_PATTERNS = (
    "error",
    "failed",
    "failure",
    "exception",
    "traceback",
    "assertionerror",
    "fatal",
    "warning",
    "warn",
    "erreur",
    "échoué",
    "echoue",
)


def normalize_repeated_line(line: str) -> str:
    """Normalise une ligne pour mieux repérer les répétitions de logs."""
    line = re.sub(r"\d{4}-\d{2}-\d{2}[T ][0-9:.+-]+", "<timestamp>", line)
    line = re.sub(r"\b\d+\b", "<num>", line)
    return line.strip()


def is_important_line(line: str) -> bool:
    """Repère les lignes à conserver en priorité dans un résumé."""
    lowered = line.lower()
    return any(pattern in lowered for pattern in ERROR_PATTERNS)


def summarize_git_status(lines: list[str]) -> str | None:
    """Produit un résumé spécial pour les sorties de git status --short."""
    if not lines or not all(re.match(r"^(\?\?|[ MARCUD?!]{1,2})\s+", line) for line in lines[: min(20, len(lines))]):
        return None
    prefixes = Counter(line[:2].strip() or line[:1].strip() for line in lines)
    parts = [f"{count} {status}" for status, count in sorted(prefixes.items())]
    return f"git status: {len(lines)} changement(s) détecté(s) ({', '.join(parts)})."


def summarize_pytest(lines: list[str]) -> str | None:
    """Produit un résumé spécial pour les sorties pytest."""
    text = "\n".join(lines)
    if "pytest" not in text.lower() and "failed" not in text.lower() and "passed" not in text.lower():
        return None
    summary_lines = [
        line.strip()
        for line in lines
        if re.search(r"(\d+\s+failed|\d+\s+passed|FAILED|ERROR|Traceback|AssertionError)", line, re.IGNORECASE)
    ]
    if not summary_lines:
        return None
    return "pytest: " + " | ".join(summary_lines[-8:])


def summarize_ruff(lines: list[str]) -> str | None:
    """Produit un résumé spécial pour les sorties Ruff."""
    text = "\n".join(lines)
    if "ruff" not in text.lower() and "all checks passed" not in text.lower() and "found " not in text.lower():
        return None
    if "All checks passed!" in text:
        return "ruff: tous les contrôles passent."
    found = [line.strip() for line in lines if line.strip().lower().startswith("found ")]
    if found:
        return "ruff: " + found[-1]
    return None


def slim_output(text: str, max_lines: int = 80) -> SlimmedOutput:
    """Compresse une sortie courte ou moyenne en conservant les lignes utiles."""
    lines = text.splitlines()
    if not lines:
        return SlimmedOutput("Sortie vide.", [], 0, 0)

    specialized = summarize_git_status(lines) or summarize_pytest(lines) or summarize_ruff(lines)

    important = [line for line in lines if is_important_line(line)]
    if not important:
        head_count = min(20, len(lines))
        tail_count = min(20, max(0, len(lines) - head_count))
        important = [*lines[:head_count], *lines[-tail_count:]]

    compact: list[str] = []
    seen_normalized: set[str] = set()
    for line in important:
        normalized = normalize_repeated_line(line)
        if normalized in seen_normalized:
            continue
        seen_normalized.add(normalized)
        compact.append(line)
        if len(compact) >= max_lines:
            break

    omitted = max(0, len(lines) - len(compact))
    summary = specialized or f"Sortie terminal: {len(lines)} ligne(s), {len(compact)} ligne(s) conservée(s)."
    if omitted:
        summary += f" {omitted} ligne(s) non affichée(s)."

    return SlimmedOutput(
        summary=summary,
        important_lines=compact,
        omitted_line_count=omitted,
        original_line_count=len(lines),
    )


def search_lines(text: str, query: str, limit: int = 20) -> list[dict[str, str | int]]:
    """Cherche une chaîne dans une sortie terminal et retourne les lignes correspondantes."""
    query_lower = query.lower()
    matches = []
    for index, line in enumerate(text.splitlines(), start=1):
        if query_lower in line.lower():
            matches.append({"line": index, "text": line})
            if len(matches) >= limit:
                break
    return matches
