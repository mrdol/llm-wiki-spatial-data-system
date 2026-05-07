"""Validation deterministe des metadonnees de licence."""

from __future__ import annotations

from conftest import dataset_label


def test_license_metadata_required_values(catalog):
    """Verifie que les champs de licence critiques existent et ne sont pas nuls."""

    datasets = catalog.get("datasets", [])
    required_fields = {"license_present", "license_name", "license_open"}
    failures: list[str] = []

    for index, dataset in enumerate(datasets):
        if not isinstance(dataset, dict):
            continue
        license_metadata = dataset.get("license_metadata")
        label = dataset_label(dataset, index)
        if not isinstance(license_metadata, dict):
            failures.append(f"{label}: missing license_metadata object")
            continue

        for field in sorted(required_fields):
            if field not in license_metadata:
                failures.append(f"{label}: missing license_metadata.{field}")
            elif license_metadata[field] is None:
                failures.append(f"{label}: null license_metadata.{field}")

    assert not failures, "\n".join(failures)
