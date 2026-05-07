"""Validation deterministe des URLs declarees dans les manifests."""

from __future__ import annotations

import json
from urllib.parse import urlparse

from conftest import MANIFESTS_DIR, iter_nested_values


def _is_url_field(path: str) -> bool:
    """Repere les champs JSON qui representent probablement une URL."""

    field_name = path.lower().split(".")[-1]
    return "url" in field_name or field_name in {"href", "uri"}


def _iter_string_values(value):
    """Aplati les valeurs URL possibles en chaines de caracteres."""

    if isinstance(value, str):
        return [value]
    if isinstance(value, list):
        return [item for item in value if isinstance(item, str)]
    return []


def test_manifest_urls_have_valid_format():
    """Verifie le format des URLs HTTP/HTTPS dans les manifests JSON."""

    manifest_paths = sorted(MANIFESTS_DIR.rglob("*.json"))
    failures: list[str] = []

    for manifest_path in manifest_paths:
        with manifest_path.open("r", encoding="utf-8") as handle:
            payload = json.load(handle)

        for path, value in iter_nested_values(payload):
            if not _is_url_field(path):
                continue
            for url in _iter_string_values(value):
                if not url:
                    continue
                parsed = urlparse(url)
                if parsed.scheme in {"http", "https"} and parsed.netloc:
                    continue
                if "://" in url or parsed.scheme in {"http", "https"}:
                    rel = manifest_path.relative_to(MANIFESTS_DIR).as_posix()
                    failures.append(f"{rel} {path}: malformed URL {url!r}")

    assert not failures, "\n".join(failures)
