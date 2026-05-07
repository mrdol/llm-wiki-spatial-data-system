"""Tests unitaires sur la structure generale du catalogue."""

from __future__ import annotations

import json


def test_catalog_is_valid_json(repo_root):
    """Verifie que data/catalogue_datasets.json est un JSON lisible et bien forme."""

    catalog_path = repo_root / "data" / "catalogue_datasets.json"
    with catalog_path.open("r", encoding="utf-8") as handle:
        payload = json.load(handle)

    assert isinstance(payload, dict), "data/catalogue_datasets.json must contain a JSON object"


def test_catalog_required_top_level_fields(catalog):
    """Verifie la presence des champs racine attendus par le systeme."""

    required_fields = {"datasets", "warehouses", "papers", "estimator_policy"}
    missing = sorted(required_fields - set(catalog))

    assert not missing, f"Missing top-level catalog fields: {missing}"
