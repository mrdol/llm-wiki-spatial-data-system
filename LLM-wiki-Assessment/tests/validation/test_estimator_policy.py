"""Validation deterministe de la politique d'estimateurs."""

from __future__ import annotations

from conftest import dataset_label


def _extract_estimator_names(methodological_selection: dict) -> list[str]:
    """Extrait les noms d'estimateurs declares dans methodological_selection."""

    names: list[str] = []

    legacy = methodological_selection.get("legacy_candidate_estimators")
    if isinstance(legacy, list):
        names.extend(item for item in legacy if isinstance(item, str))

    candidates = methodological_selection.get("candidate_estimators")
    if isinstance(candidates, list):
        for item in candidates:
            if isinstance(item, str):
                names.append(item)
            elif isinstance(item, dict) and isinstance(item.get("name"), str):
                names.append(item["name"])

    estimator_name = methodological_selection.get("estimator_name")
    if isinstance(estimator_name, str):
        names.append(estimator_name)

    return [name for name in names if name.strip()]


def test_methodological_selection_uses_allowed_estimators(catalog):
    """Verifie que les estimateurs declares appartiennent a l'allowlist du catalogue."""

    policy = catalog.get("estimator_policy")
    assert isinstance(policy, dict), "catalog.estimator_policy must be an object"

    allowed = policy.get("allowed_estimators")
    assert isinstance(allowed, list), "estimator_policy.allowed_estimators must be a list"
    allowed_set = {str(name) for name in allowed}

    failures: list[str] = []
    for index, dataset in enumerate(catalog.get("datasets", [])):
        if not isinstance(dataset, dict):
            continue
        methodological_selection = dataset.get("methodological_selection")
        if not isinstance(methodological_selection, dict):
            continue
        for estimator_name in _extract_estimator_names(methodological_selection):
            if estimator_name not in allowed_set:
                failures.append(
                    f"{dataset_label(dataset, index)}: unknown estimator {estimator_name!r}"
                )

    assert not failures, "\n".join(failures)
