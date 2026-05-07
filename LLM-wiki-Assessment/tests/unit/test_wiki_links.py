"""Tests unitaires sur les liens internes du wiki."""

from __future__ import annotations

import re

from conftest import WIKI_DIR


WIKI_LINK_PATTERN = re.compile(r"\[\[([^\]]+)\]\]")

# Fichiers générés automatiquement dont le contenu libre ne doit pas être validé
GENERATED_FILES = {"eval_queue.md", "log.md"}


def _normalize_wiki_target(raw_target: str) -> str:
    """Nettoie une cible Obsidian: alias, ancre, extension et chemin."""

    target = raw_target.split("|", 1)[0].split("#", 1)[0].strip()
    if target.endswith(".md"):
        target = target[:-3]
    return target.replace("\\", "/")


def test_all_wiki_links_point_to_existing_pages():
    """Verifie que tous les liens [[page]] pointent vers une page Markdown existante."""

    markdown_pages = list(WIKI_DIR.rglob("*.md"))
    existing_stems = {page.stem for page in markdown_pages}
    existing_relative = {
        page.relative_to(WIKI_DIR).with_suffix("").as_posix()
        for page in markdown_pages
    }

    failures: list[str] = []
    for page in markdown_pages:
        if page.name in GENERATED_FILES:
            continue
        text = page.read_text(encoding="utf-8")
        for match in WIKI_LINK_PATTERN.finditer(text):
            target = _normalize_wiki_target(match.group(1))
            if not target:
                continue
            if target not in existing_stems and target not in existing_relative:
                rel_page = page.relative_to(WIKI_DIR).as_posix()
                failures.append(f"{rel_page} -> [[{match.group(1)}]]")

    assert not failures, "Broken wiki links:\n" + "\n".join(failures)
