"""Tests unitaires sur les champs obligatoires de chaque dataset."""

from __future__ import annotations

from conftest import dataset_label


def test_each_dataset_has_required_sections(catalog):
    """Verifie que chaque dataset porte les sections minimales de metadata."""

    datasets = catalog.get("datasets")
    assert isinstance(datasets, list), "catalog.datasets must be a list"

    required_sections = {
        "identity",
        "source_access",
        "content_metadata",
        "spatiotemporal",
        "license_metadata",
    }
    failures: list[str] = []

    for index, dataset in enumerate(datasets):
        if not isinstance(dataset, dict):
            failures.append(f"dataset[{index}] is not an object")
            continue
        missing = sorted(required_sections - set(dataset))
        if missing:
            failures.append(f"{dataset_label(dataset, index)} missing {missing}")

    assert not failures, "\n".join(failures)
