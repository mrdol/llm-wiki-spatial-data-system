"""Utilitaires partages pour les tests deterministes du LLM Wiki."""

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any, Iterable

import pytest


REPO_ROOT = Path(__file__).resolve().parents[2]
CATALOG_PATH = REPO_ROOT / "data" / "catalogue_datasets.json"
WIKI_DIR = REPO_ROOT / "wiki"
MANIFESTS_DIR = REPO_ROOT / "data" / "manifests"

DOI_PATTERN = re.compile(r"^10\.\d{4,9}/\S+$", flags=re.IGNORECASE)


@pytest.fixture(scope="session")
def repo_root() -> Path:
    """Retourne la racine du depot pour construire des chemins stables."""

    return REPO_ROOT


@pytest.fixture(scope="session")
def catalog() -> dict[str, Any]:
    """Charge le catalogue JSON une seule fois pour tous les tests."""

    with CATALOG_PATH.open("r", encoding="utf-8") as handle:
        payload = json.load(handle)
    if not isinstance(payload, dict):
        raise AssertionError("data/catalogue_datasets.json must contain a JSON object")
    return payload


def iter_nested_values(value: Any, path: str = "$") -> Iterable[tuple[str, Any]]:
    """Parcourt recursivement un objet JSON en conservant le chemin de chaque valeur."""

    yield path, value
    if isinstance(value, dict):
        for key, nested in value.items():
            yield from iter_nested_values(nested, f"{path}.{key}")
    elif isinstance(value, list):
        for index, nested in enumerate(value):
            yield from iter_nested_values(nested, f"{path}[{index}]")


def dataset_label(dataset: dict[str, Any], index: int) -> str:
    """Produit un identifiant lisible pour les messages d'erreur des tests."""

    return str(
        dataset.get("dataset_id")
        or dataset.get("id")
        or dataset.get("identity", {}).get("title")
        or f"dataset[{index}]"
    )
