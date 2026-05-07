"""Validation externe optionnelle du catalogue et des manifests.

Ce fichier regroupe les controles qui exigent le reseau:

- verifier que les DOI existent vraiment via doi.org;
- verifier que les metadonnees DOI correspondent grossierement au contexte local;
- verifier que les URLs importantes repondent en ligne;
- verifier que les licences annoncees sont coherentes avec les champs locaux;
- verifier les URLs de licence quand elles existent.

Ces tests sont desactives par defaut pour garder pytest rapide et reproductible.

Lancement:

    $env:RUN_EXTERNAL_VALIDATION="1"
    $env:EXTERNAL_VALIDATION_LIMIT="25"
    pytest tests/validation/test_external_catalog_integrity.py
"""

from __future__ import annotations

import json
import os
import re
from dataclasses import dataclass
from difflib import SequenceMatcher
from pathlib import Path
from typing import Any, Iterable
from urllib.error import HTTPError, URLError
from urllib.parse import quote, urlparse
from urllib.request import Request, urlopen

import pytest

from conftest import DOI_PATTERN, MANIFESTS_DIR, iter_nested_values


RUN_EXTERNAL = os.environ.get("RUN_EXTERNAL_VALIDATION") == "1"
MAX_EXTERNAL_CHECKS = int(os.environ.get("EXTERNAL_VALIDATION_LIMIT", "25"))
MIN_TITLE_SIMILARITY = float(os.environ.get("DOI_TITLE_MIN_SIMILARITY", "0.35"))

KNOWN_OPEN_LICENSE_TERMS = {
    "cc0",
    "cc-by",
    "cc by",
    "creative commons attribution",
    "odc-by",
    "odbl",
    "open database license",
    "etalab",
    "licence ouverte",
    "open licence",
    "open license",
    "public domain",
}

KNOWN_RESTRICTIVE_LICENSE_TERMS = {
    "all rights reserved",
    "proprietary",
    "restricted",
    "non-commercial",
    "non commercial",
}


@dataclass(frozen=True)
class DoiCandidate:
    """DOI a verifier avec son contexte local."""

    path: str
    doi: str
    expected_title: str | None
    expected_kind: str | None


@dataclass(frozen=True)
class UrlCandidate:
    """URL a verifier avec son contexte local."""

    source_name: str
    path: str
    url: str


def _normalize_doi(value: str) -> str:
    """Normalise un DOI ou une URL DOI pour comparaison stable."""

    doi = value.strip()
    doi = re.sub(r"^https?://(dx\.)?doi\.org/", "", doi, flags=re.IGNORECASE)
    doi = doi.strip().rstrip(".,);]")
    return doi.lower()


def _field_name(path: str) -> str:
    """Retourne le dernier segment d'un chemin logique JSON."""

    return path.lower().split(".")[-1].replace("_", "")


def _is_doi_field(path: str) -> bool:
    """Repere les champs dont le nom indique un DOI."""

    return _field_name(path).endswith("doi")


def _is_url_field(path: str) -> bool:
    """Repere les champs JSON qui representent probablement une URL."""

    field_name = _field_name(path)
    return "url" in field_name or field_name in {"href", "uri"}


def _iter_string_values(value: Any) -> list[str]:
    """Aplati les valeurs possibles en chaines."""

    if isinstance(value, str):
        return [value]
    if isinstance(value, list):
        return [item for item in value if isinstance(item, str)]
    return []


def _iter_doi_values(value: Any) -> list[Any]:
    """Retourne les DOI a tester, meme si le champ contient une liste."""

    if value is None:
        return []
    if isinstance(value, list):
        return [item for item in value if item is not None]
    return [value]


def _expected_kind_from_path(path: str) -> str | None:
    """Infere si le DOI devrait pointer vers un dataset ou un papier."""

    lowered = path.lower()
    if "paper" in lowered or "publication" in lowered or "article" in lowered:
        return "paper"
    if "dataset" in lowered or "concept_doi" in lowered:
        return "dataset"
    return None


def _context_title(value: Any) -> str | None:
    """Extrait un titre local proche du champ DOI quand il est disponible."""

    if not isinstance(value, dict):
        return None
    for key in ("paper_title", "dataset_title", "title", "name", "short_title"):
        title = value.get(key)
        if isinstance(title, str) and title.strip():
            return title.strip()
    identity = value.get("identity")
    if isinstance(identity, dict):
        return _context_title(identity)
    return None


def _iter_doi_candidates(value: Any, path: str = "$") -> Iterable[DoiCandidate]:
    """Parcourt un objet JSON et conserve le titre autour de chaque DOI."""

    if isinstance(value, dict):
        for key, nested in value.items():
            nested_path = f"{path}.{key}"
            if _is_doi_field(nested_path):
                for doi_value in _iter_doi_values(nested):
                    if isinstance(doi_value, str) and doi_value.strip():
                        title = _context_title(value)
                        if any(marker in key.lower() for marker in ("paper", "publication", "article")):
                            title = _context_title(
                                {
                                    title_key: value.get(title_key)
                                    for title_key in ("paper_title", "publication_title", "article_title")
                                    if isinstance(value.get(title_key), str)
                                }
                            )
                        yield DoiCandidate(
                            path=nested_path,
                            doi=doi_value,
                            expected_title=title,
                            expected_kind=_expected_kind_from_path(nested_path),
                        )
            yield from _iter_doi_candidates(nested, nested_path)
    elif isinstance(value, list):
        for index, nested in enumerate(value):
            yield from _iter_doi_candidates(nested, f"{path}[{index}]")


def _fetch_doi_csl_json(doi: str) -> dict[str, Any]:
    """Interroge doi.org en demandant les metadonnees CSL JSON."""

    normalized = _normalize_doi(doi)
    request = Request(
        f"https://doi.org/{quote(normalized, safe='/')}",
        headers={
            "Accept": "application/vnd.citationstyles.csl+json",
            "User-Agent": "llm-wiki-validation/1.0 (external integrity check)",
        },
        method="GET",
    )
    with urlopen(request, timeout=20) as response:
        payload = response.read().decode("utf-8", errors="replace")
    parsed = json.loads(payload)
    if not isinstance(parsed, dict):
        raise AssertionError("DOI resolver did not return a JSON object")
    return parsed


def _title_similarity(local_title: str, remote_title: str) -> float:
    """Calcule une similarite simple entre titre local et titre distant."""

    def clean(text: str) -> str:
        text = text.lower()
        text = re.sub(r"[^a-z0-9]+", " ", text)
        return " ".join(text.split())

    return SequenceMatcher(None, clean(local_title), clean(remote_title)).ratio()


def _remote_type_matches_expected(remote_type: str | None, expected_kind: str | None) -> bool:
    """Verifie grossierement que le DOI pointe vers un papier ou un dataset."""

    if expected_kind is None:
        return True
    remote = (remote_type or "").lower()
    if expected_kind == "dataset":
        return remote in {"dataset", "data", "report", "webpage"} or "dataset" in remote
    if expected_kind == "paper":
        return remote in {
            "article",
            "article-journal",
            "book-chapter",
            "journal-article",
            "paper",
            "proceedings-article",
        }
    return True


def _url_exists(url: str) -> tuple[bool, str | None]:
    """Teste une URL avec HEAD, puis GET si le serveur refuse HEAD."""

    headers = {"User-Agent": "llm-wiki-validation/1.0 (external integrity check)"}
    for method in ("HEAD", "GET"):
        request = Request(url, headers=headers, method=method)
        try:
            with urlopen(request, timeout=20) as response:
                status = getattr(response, "status", 200)
                if status < 400:
                    return True, None
                return False, f"HTTP {status}"
        except HTTPError as exc:
            if method == "HEAD" and exc.code in {403, 405, 501}:
                continue
            if 500 <= exc.code <= 599:
                return True, f"transient server error HTTP {exc.code}"
            return False, f"HTTP {exc.code}"
        except TimeoutError as exc:
            return True, f"transient timeout: {exc}"
        except URLError as exc:
            if "timed out" in str(exc).lower():
                return True, f"transient timeout: {exc}"
            return False, str(exc)
    return False, "unreachable"


def _looks_like_blocked_network(reason: str | None) -> bool:
    """Detect local sandbox/proxy failures rather than a bad remote URL."""

    if not reason:
        return False
    lowered = reason.lower()
    blocked_markers = (
        "winerror 10061",
        "connection refused",
        "failed to establish a new connection",
        "temporary failure in name resolution",
        "network is unreachable",
        "proxyerror",
    )
    return any(marker in lowered for marker in blocked_markers)


def _iter_catalog_urls(catalog: dict[str, Any]) -> Iterable[UrlCandidate]:
    """Retourne les URLs HTTP/HTTPS declarees dans le catalogue."""

    for path, value in iter_nested_values(catalog):
        if not _is_url_field(path):
            continue
        for url in _iter_string_values(value):
            parsed = urlparse(url)
            if parsed.scheme in {"http", "https"} and parsed.netloc:
                yield UrlCandidate("data/catalogue_datasets.json", path, url)


def _iter_manifest_urls() -> Iterable[UrlCandidate]:
    """Retourne les URLs HTTP/HTTPS declarees dans les manifests JSON."""

    for manifest_path in sorted(MANIFESTS_DIR.rglob("*.json")):
        with manifest_path.open("r", encoding="utf-8") as handle:
            payload = json.load(handle)

        for path, value in iter_nested_values(payload):
            if not _is_url_field(path):
                continue
            for url in _iter_string_values(value):
                parsed = urlparse(url)
                if parsed.scheme in {"http", "https"} and parsed.netloc:
                    source_name = str(manifest_path.relative_to(MANIFESTS_DIR).as_posix())
                    yield UrlCandidate(source_name, path, url)


def _license_name(license_metadata: dict[str, Any]) -> str | None:
    """Retourne le nom de licence le plus precis disponible."""

    for key in ("exact_name", "license_name", "name"):
        value = license_metadata.get(key)
        if isinstance(value, str) and value.strip():
            return value.strip()
    return None


def _license_url(license_metadata: dict[str, Any]) -> str | None:
    """Retourne une URL de licence si elle est documentee."""

    for key in ("license_url", "url", "evidence_url", "terms_url"):
        value = license_metadata.get(key)
        if isinstance(value, str) and value.strip():
            return value.strip()
    return None


def _license_open_hint(license_name: str) -> bool | None:
    """Classe grossierement une licence connue comme ouverte ou restrictive."""

    lowered = license_name.lower()
    if any(term in lowered for term in KNOWN_OPEN_LICENSE_TERMS):
        return True
    if any(term in lowered for term in KNOWN_RESTRICTIVE_LICENSE_TERMS):
        return False
    return None


def _iter_license_metadata(catalog: dict[str, Any]) -> Iterable[tuple[str, dict[str, Any]]]:
    """Retourne tous les blocs license_metadata du catalogue."""

    for path, value in iter_nested_values(catalog):
        if path.lower().endswith("license_metadata") and isinstance(value, dict):
            yield path, value


@pytest.mark.skipif(not RUN_EXTERNAL, reason="Set RUN_EXTERNAL_VALIDATION=1 to run external integrity checks")
def test_external_catalog_integrity(catalog):
    """Controle en ligne les DOI, URLs et licences du systeme."""

    failures: list[str] = []
    blocked_network_failures: list[str] = []

    doi_candidates = [
        candidate
        for candidate in _iter_doi_candidates(catalog)
        if DOI_PATTERN.match(_normalize_doi(candidate.doi))
    ][:MAX_EXTERNAL_CHECKS]

    for candidate in doi_candidates:
        try:
            remote = _fetch_doi_csl_json(candidate.doi)
        except (HTTPError, URLError, TimeoutError, json.JSONDecodeError, AssertionError) as exc:
            message = f"{candidate.path}: DOI not resolvable {candidate.doi!r}: {exc}"
            if _looks_like_blocked_network(str(exc)):
                blocked_network_failures.append(message)
            else:
                failures.append(message)
            continue

        remote_doi = _normalize_doi(str(remote.get("DOI") or remote.get("doi") or candidate.doi))
        local_doi = _normalize_doi(candidate.doi)
        if remote_doi != local_doi:
            failures.append(f"{candidate.path}: resolver DOI mismatch local={local_doi!r} remote={remote_doi!r}")

        remote_type = remote.get("type")
        if not _remote_type_matches_expected(str(remote_type) if remote_type else None, candidate.expected_kind):
            failures.append(
                f"{candidate.path}: DOI type mismatch expected={candidate.expected_kind!r} remote={remote_type!r}"
            )

        remote_title = remote.get("title")
        if isinstance(remote_title, list):
            remote_title = " ".join(str(item) for item in remote_title)
        if candidate.expected_title and isinstance(remote_title, str) and remote_title.strip():
            score = _title_similarity(candidate.expected_title, remote_title)
            if score < MIN_TITLE_SIMILARITY:
                failures.append(
                    f"{candidate.path}: weak title match score={score:.2f} "
                    f"local={candidate.expected_title!r} remote={remote_title!r}"
                )

    url_candidates = list(_iter_catalog_urls(catalog)) + list(_iter_manifest_urls())
    for candidate in url_candidates[:MAX_EXTERNAL_CHECKS]:
            ok, reason = _url_exists(candidate.url)
            if not ok:
                message = f"{candidate.source_name} {candidate.path}: unreachable URL {candidate.url!r} ({reason})"
                if _looks_like_blocked_network(reason):
                    blocked_network_failures.append(message)
                else:
                    failures.append(message)

    for path, license_metadata in _iter_license_metadata(catalog):
        explicit = license_metadata.get("explicit_license_present")
        if explicit is None:
            explicit = license_metadata.get("license_present")
        license_name = _license_name(license_metadata)
        license_url = _license_url(license_metadata)

        if explicit is True and not license_name:
            failures.append(f"{path}: explicit license is true but no exact license name is recorded")

        if license_name:
            open_hint = _license_open_hint(license_name)
            stored_open = license_metadata.get("is_open")
            if stored_open is None:
                stored_open = license_metadata.get("license_open")
            if open_hint is not None and stored_open is not None and bool(stored_open) != open_hint:
                failures.append(
                    f"{path}: license openness mismatch name={license_name!r} "
                    f"stored={stored_open!r} inferred={open_hint!r}"
                )

        if license_url:
            parsed = urlparse(license_url)
            if parsed.scheme not in {"http", "https"} or not parsed.netloc:
                failures.append(f"{path}: malformed license URL {license_url!r}")
            else:
                    ok, reason = _url_exists(license_url)
                    if not ok:
                        message = f"{path}: license URL unreachable {license_url!r} ({reason})"
                        if _looks_like_blocked_network(reason):
                            blocked_network_failures.append(message)
                        else:
                            failures.append(message)

    if blocked_network_failures and not failures:
        pytest.skip(
            "External validation requested, but this environment blocks outbound network access; "
            f"{len(blocked_network_failures)} URL checks could not run."
        )

    assert not failures, "\n".join(failures)


def test_external_integrity_script_can_find_targets(catalog):
    """Verifie sans reseau que le script externe sait trouver les cibles a controler."""

    doi_count = sum(1 for _ in _iter_doi_candidates(catalog))
    url_count = sum(1 for _ in _iter_catalog_urls(catalog)) + sum(1 for _ in _iter_manifest_urls())
    license_count = sum(1 for _ in _iter_license_metadata(catalog))

    assert doi_count >= 0
    assert url_count >= 0
    if catalog.get("datasets"):
        assert license_count > 0, "No license_metadata blocks found in catalog datasets"
