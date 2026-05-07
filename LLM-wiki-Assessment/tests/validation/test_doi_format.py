"""Validation deterministe du format des DOI."""

from __future__ import annotations

from conftest import DOI_PATTERN, iter_nested_values


def _is_doi_field(path: str) -> bool:
    """Repere les champs dont le nom indique un DOI."""

    return path.lower().split(".")[-1].replace("_", "").endswith("doi")


def _iter_doi_values(value):
    """Retourne une liste de DOI a tester, meme si le champ contient une liste."""

    if value is None:
        return []
    if isinstance(value, list):
        return [item for item in value if item is not None]
    return [value]


def test_doi_values_start_with_10_when_present(catalog):
    """Verifie que tout DOI renseigne commence par 10. et respecte un format minimal."""

    failures: list[str] = []
    for path, value in iter_nested_values(catalog):
        if not _is_doi_field(path):
            continue
        for doi in _iter_doi_values(value):
            if not isinstance(doi, str):
                failures.append(f"{path}: DOI value must be string or null, got {type(doi).__name__}")
                continue
            if not DOI_PATTERN.match(doi):
                failures.append(f"{path}: invalid DOI format {doi!r}")

    assert not failures, "\n".join(failures)
