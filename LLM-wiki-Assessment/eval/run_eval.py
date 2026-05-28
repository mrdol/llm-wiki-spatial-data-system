"""Evaluation pipeline orchestrator.

Usage:
    python LLM-wiki-Assessment/eval/run_eval.py <fiche.md> [<fiche.md> ...]
    python LLM-wiki-Assessment/eval/run_eval.py <fiche.md> --external
    python LLM-wiki-Assessment/eval/run_eval.py <fiche.md> --formulas
    python LLM-wiki-Assessment/eval/run_eval.py <fiche.md> --formulas --force-formulas
    python LLM-wiki-Assessment/eval/run_eval.py --all
    python LLM-wiki-Assessment/eval/run_eval.py --all --external
    python LLM-wiki-Assessment/eval/run_eval.py --all --skip-tests

Flags:
    --external       Run network checks (DOI resolution, URL reachability).
                     Works with individual fiches and with --all.
                     Without this flag, an interactive prompt is shown when
                     evaluating individual fiches in a TTY session.
    --formulas       Run Tier 2.5 formula verification (estimator fiches only).
                     Extracts formulas from the raw PDF source via Claude vision
                     and compares them with the ## Model Equation section.
                     Requires: pip install pymupdf  +  ANTHROPIC_API_KEY.
    --force-formulas Re-extract formulas from PDF even if a cached manifest exists.
                     Only effective when used with --formulas.
    --skip-tests     Skip pytest entirely (only valid with --all).

Exit codes:
    0 - Tier 1 passed on all fiches and pytest passed (or was skipped).
    1 - At least one Tier 1 failure OR pytest failure.
"""

from __future__ import annotations

import json
import re
import subprocess
import sys
from dataclasses import dataclass, field
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.parse import quote, urlparse
from urllib.request import Request, urlopen

PROJECT_ROOT = Path(__file__).parent.parent.parent  # LLM-wiki-Assessment/eval/ → llm-wiki-karpathy/
EVAL_PACKAGE_ROOT = Path(__file__).parent.parent    # LLM-wiki-Assessment/
TESTS_DIR = EVAL_PACKAGE_ROOT / "tests"

sys.path.insert(0, str(PROJECT_ROOT))
sys.path.insert(0, str(EVAL_PACKAGE_ROOT))

try:
    from dotenv import load_dotenv
    load_dotenv(PROJECT_ROOT / ".env", override=True)
except ImportError:
    pass

from eval import tier1_structural, tier2_semantic, tier2_5_formula, tier3_queue

SCORE_OK = 0.75
SCORE_AMBER_MIN = 0.50

EXCLUDED_FILES = tier1_structural.EXCLUDED_FILES

# Tier 2 criteria to display per entity type
DETAIL_KEYS = {
    "dataset": [
        "y_typology_ok",
        "x_typology_ok",
        "nt_profile_consistent",
        "formula_faithful",
        "quality_gate_ok",
        "metadata_completeness_ok",
        "paper_linkage_ok",
    ],
    "estimator": ["equation_coherent", "hyperparameters_coherent", "source_faithful"],
    "analysis": ["claims_faithful", "internally_consistent"],
}


# ---------------------------------------------------------------------------
# Pytest integration
# ---------------------------------------------------------------------------

@dataclass
class PytestResult:
    passed: int = 0
    failed: int = 0
    errors: int = 0
    failed_tests: list[str] = field(default_factory=list)
    output: str = ""
    exit_code: int = 0


def _run_pytest(external: bool = False) -> PytestResult:
    """Run deterministic tests (and optionally external tests) via pytest."""
    suites = [
        str(TESTS_DIR / "unit"),
        str(TESTS_DIR / "validation"),
    ]
    env_extras: dict[str, str] = {}

    if external:
        suites.append(str(TESTS_DIR / "validation" / "test_external_catalog_integrity.py"))
        env_extras["RUN_EXTERNAL_VALIDATION"] = "1"

    import os
    env = {**os.environ, **env_extras}

    cmd = [sys.executable, "-m", "pytest", *suites, "-v", "--tb=short", "--no-header"]
    try:
        proc = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            cwd=str(PROJECT_ROOT),
            env=env,
        )
    except FileNotFoundError:
        result = PytestResult(exit_code=1)
        result.output = "pytest not found — run: pip install pytest"
        return result

    output = proc.stdout + proc.stderr
    result = PytestResult(exit_code=proc.returncode, output=output)

    for line in output.splitlines():
        stripped = line.strip()
        if stripped.startswith("PASSED"):
            result.passed += 1
        elif stripped.startswith("FAILED"):
            result.failed += 1
            # extract test id after "FAILED "
            test_id = stripped[len("FAILED "):].split(" ")[0]
            result.failed_tests.append(test_id)
        elif stripped.startswith("ERROR"):
            result.errors += 1

    # Parse summary line: "X passed, Y failed" etc.
    for line in reversed(output.splitlines()):
        if " passed" in line or " failed" in line or " error" in line:
            import re
            m_pass = re.search(r"(\d+) passed", line)
            m_fail = re.search(r"(\d+) failed", line)
            m_err  = re.search(r"(\d+) error", line)
            if m_pass:
                result.passed = int(m_pass.group(1))
            if m_fail:
                result.failed = int(m_fail.group(1))
            if m_err:
                result.errors = int(m_err.group(1))
            break

    return result


def _print_pytest_section(result: PytestResult, external: bool) -> None:
    label = "Tests catalogue + wiki (pytest" + (", réseau activé)" if external else ")")
    print(f"\n{'=' * 60}")
    print(f"PYTEST — {label}")
    print("=" * 60)

    if result.exit_code == 0:
        print(f"  PASS  {result.passed} test(s) passed")
    else:
        total_fail = result.failed + result.errors
        print(f"  FAIL  {result.passed} passed / {total_fail} failed")
        for t in result.failed_tests[:20]:
            print(f"     - {t}")
        if len(result.failed_tests) > 20:
            print(f"     ... ({len(result.failed_tests) - 20} more)")

    if result.exit_code != 0:
        print("\n  Full pytest output:")
        for line in result.output.splitlines()[-40:]:
            print(f"    {line}")


# ---------------------------------------------------------------------------
# External validation (DOI resolution + URL reachability) on a single fiche
# ---------------------------------------------------------------------------

_DOI_RE  = re.compile(r"\b10\.\d{4,9}/[^\s\)\]\>\`\"\']+", re.IGNORECASE)
_URL_RE  = re.compile(r"https?://[^\s\)\]\>\`\"\']+")
_TRAIL   = re.compile(r"[.,);>\]`'\"]+$")


def _clean_doi(raw: str) -> str:
    raw = _TRAIL.sub("", raw.strip())
    raw = re.sub(r"^https?://(dx\.)?doi\.org/", "", raw, flags=re.IGNORECASE)
    return raw.lower()


def _extract_dois(body: str) -> list[str]:
    seen: set[str] = set()
    result = []
    for m in _DOI_RE.finditer(body):
        doi = _clean_doi(m.group())
        if doi not in seen:
            seen.add(doi)
            result.append(doi)
    return result


def _extract_urls(body: str) -> list[str]:
    seen: set[str] = set()
    result = []
    for m in _URL_RE.finditer(body):
        url = _TRAIL.sub("", m.group())
        parsed = urlparse(url)
        if parsed.scheme in {"http", "https"} and parsed.netloc and url not in seen:
            seen.add(url)
            result.append(url)
    return result


def _fetch_doi_metadata(doi: str) -> dict:
    """Query doi.org for CSL JSON metadata (raises on failure)."""
    req = Request(
        f"https://doi.org/{quote(doi, safe='/')}",
        headers={
            "Accept": "application/vnd.citationstyles.csl+json",
            "User-Agent": "llm-wiki-validation/1.0 (run_eval external check)",
        },
    )
    with urlopen(req, timeout=15) as resp:
        payload = resp.read().decode("utf-8", errors="replace")
    data = json.loads(payload)
    if not isinstance(data, dict):
        raise ValueError("doi.org did not return a JSON object")
    return data


def _check_url_reachable(url: str) -> tuple[bool, str | None]:
    """HEAD then GET fallback. Returns (ok, reason_if_not_ok)."""
    headers = {"User-Agent": "llm-wiki-validation/1.0 (run_eval external check)"}
    for method in ("HEAD", "GET"):
        req = Request(url, headers=headers, method=method)
        try:
            with urlopen(req, timeout=15) as resp:
                status = getattr(resp, "status", 200)
                if status < 400:
                    return True, None
                return False, f"HTTP {status}"
        except HTTPError as exc:
            if method == "HEAD" and exc.code in {403, 405, 501}:
                continue
            if 500 <= exc.code <= 599:
                return True, f"transient server error HTTP {exc.code}"
            return False, f"HTTP {exc.code}"
        except (TimeoutError, URLError) as exc:
            if "timed out" in str(exc).lower():
                return True, "timeout (traite comme transitoire)"
            return False, str(exc)
    return False, "unreachable"


def _run_external_checks(body: str) -> bool:
    """Run DOI resolution and URL reachability on content extracted from fiche.

    Returns True if all checks passed (or no checks ran), False if any failed.
    """
    dois = _extract_dois(body)
    urls = _extract_urls(body)

    print("\nTier Ext - Verification reseau")
    print("-" * 60)

    if not dois and not urls:
        print("  Aucun DOI ni URL HTTP/HTTPS trouves dans la fiche")
        return True

    all_ok = True

    if dois:
        print(f"\n  DOI trouves : {len(dois)}")
        for doi in dois:
            try:
                remote = _fetch_doi_metadata(doi)
                remote_title = remote.get("title") or ""
                if isinstance(remote_title, list):
                    remote_title = " ".join(str(x) for x in remote_title)
                remote_type  = remote.get("type", "inconnu")
                remote_doi   = _clean_doi(str(remote.get("DOI") or remote.get("doi") or doi))
                match_marker = "OK" if remote_doi == doi else "WARN"
                print(f"    OK   {doi}")
                print(f"         type={remote_type}")
                if remote_title:
                    print(f"         titre distant : {remote_title[:100]}")
                if match_marker == "WARN":
                    print(f"         WARN DOI retourne par le serveur : {remote_doi!r}")
            except Exception as exc:
                print(f"    FAIL {doi}")
                print(f"         {exc}")
                all_ok = False

    if urls:
        print(f"\n  URLs trouvees : {len(urls)} (verification des 10 premieres)")
        for url in urls[:10]:
            ok, reason = _check_url_reachable(url)
            marker = "OK  " if ok else "FAIL"
            note   = f"  [{reason}]" if reason else ""
            short  = url if len(url) <= 90 else url[:87] + "..."
            print(f"    {marker} {short}{note}")
            if not ok:
                all_ok = False

    print()
    if all_ok:
        print("  Resultat : tous les DOI et URLs sont accessibles")
    else:
        print("  Resultat : certains DOI ou URLs sont inaccessibles (voir details ci-dessus)")

    return all_ok


def _ask_external(external_flag: bool) -> bool:
    """Return True if external checks should run.

    - If --external flag is set: always True.
    - If stdin is a TTY (interactive session): ask the user.
    - Otherwise (CI / pipe): skip silently.
    """
    if external_flag:
        return True
    if not sys.stdin.isatty():
        return False
    try:
        answer = input(
            "\nLancer la verification reseau (resolution DOI + URLs) ? [o/N] "
        ).strip().lower()
        return answer in {"o", "oui", "y", "yes"}
    except (EOFError, KeyboardInterrupt):
        print()
        return False


# ---------------------------------------------------------------------------
# Fiche evaluation
# ---------------------------------------------------------------------------

def _label(score: float) -> str:
    if score >= SCORE_OK:
        return "OK"
    if score >= SCORE_AMBER_MIN:
        return "AMBER"
    return "REJECTED"


def _body_from_fiche(fiche_content: str) -> str:
    if not fiche_content.startswith("---"):
        return fiche_content
    end = fiche_content.find("\n---", 3)
    if end == -1:
        return fiche_content
    return fiche_content[end + 4:].strip()


@dataclass
class FicheOutcome:
    path: Path
    blocked: bool = False       # Tier 1 FAIL
    amber: bool = False
    rejected: bool = False
    score: float | None = None


def eval_fiche(
    fiche_path: Path,
    external: bool = False,
    formulas: bool = False,
    force_formulas: bool = False,
) -> FicheOutcome:
    """Evaluate one fiche. Returns a FicheOutcome summary."""
    outcome = FicheOutcome(path=fiche_path)

    rel = fiche_path.relative_to(PROJECT_ROOT) if fiche_path.is_absolute() else fiche_path
    print(f"\nFILE {rel}")
    print("-" * 60)

    print("Tier 1 - Structural")
    t1 = tier1_structural.run(fiche_path)

    if t1.entity_type == "excluded":
        print("  SKIP excluded file")
        return outcome

    if t1.errors:
        print("  FAIL")
        for err in t1.errors:
            print(f"     - {err}")
        for warning in t1.warnings:
            print(f"     WARN {warning}")
        outcome.blocked = True
        return outcome

    print("  PASS")
    for warning in t1.warnings:
        print(f"  WARN {warning}")

    print("\nTier 2 - Semantic")

    try:
        fiche_content = fiche_path.read_text(encoding="utf-8-sig")
        body = _body_from_fiche(fiche_content)
        t2 = tier2_semantic.run(fiche_path, t1.frontmatter, body)
    except Exception as exc:
        print(f"  WARN Tier 2 not executed: {exc}")
        print(f"  Default score: {tier2_semantic.DEFAULT_SCORE_SKIP:.2f} -> OK")
        return outcome

    if t2.skipped:
        print(f"  SKIP {t2.reasoning}")
        print(f"  Score: {t2.score:.2f} -> OK (type not evaluated)")
        return outcome

    if t2.error:
        print(f"  WARN Tier 2 error: {t2.error}")
        print(f"  Default score: {t2.score:.2f} -> OK (graceful degradation)")
        return outcome

    keys = DETAIL_KEYS.get(t1.entity_type, [])
    for key in keys:
        value = t2.details.get(key)
        marker = "OK" if value is True else ("FAIL" if value is False else "-")
        issue_key = (
            key.replace("_ok", "_issue")
            .replace("_consistent", "_issue")
            .replace("_coherent", "_issue")
            .replace("_faithful", "_issue")
        )
        issue = t2.details.get(issue_key) or ""
        issue_text = f" - {issue}" if issue else ""
        print(f"  {marker}  {key}{issue_text}")

    cap_note = " (capped - raw source absent)" if not t2.raw_available else ""
    print(f"\n  Score: {t2.score:.2f}{cap_note} -> {_label(t2.score)}")

    if t2.reasoning:
        print(f"  Reason: {t2.reasoning}")

    outcome.score = t2.score

    # --- External validation (DOI resolution + URL reachability) ---
    if _ask_external(external):
        _run_external_checks(body)

    # --- Tier 2.5 — Formula verification (estimators only, optional) ---
    if formulas and t1.entity_type == "estimator":
        t25 = tier2_5_formula.run(fiche_path, t1.frontmatter, force_reextract=force_formulas)
        if t25.skipped:
            print(f"\n{t25.report}")
        elif t25.error:
            print(f"\nTier 2.5 - WARN : {t25.report}")
        else:
            print(f"\n{t25.report}")

    if t2.score >= SCORE_OK:
        tier3_queue.remove_from_queue(fiche_path)
    elif t2.score >= SCORE_AMBER_MIN:
        tier3_queue.add_to_queue(fiche_path, t2.score, t2.fields_to_review, t2.reasoning)
        print("  -> Added to wiki/eval_queue.md")
        outcome.amber = True
    else:
        tier3_queue.add_to_rejected(fiche_path, t2.score, t2.details, t2.reasoning)
        if t2.fields_to_review:
            print(f"  Suspicious fields: {', '.join(t2.fields_to_review)}")
        print("  -> Report written to .eval/rejected/")
        outcome.rejected = True

    return outcome


# ---------------------------------------------------------------------------
# Consolidated summary
# ---------------------------------------------------------------------------

def _print_summary(pytest_result: PytestResult | None, outcomes: list[FicheOutcome], external: bool) -> None:
    blocked   = [o for o in outcomes if o.blocked]
    amber     = [o for o in outcomes if o.amber]
    rejected  = [o for o in outcomes if o.rejected]
    passed    = [o for o in outcomes if not o.blocked and not o.amber and not o.rejected]

    print(f"\n{'=' * 60}")
    print("RAPPORT CONSOLIDE")
    print("=" * 60)

    if pytest_result is not None:
        label = "réseau activé" if external else "sans réseau"
        status = "PASS" if pytest_result.exit_code == 0 else "FAIL"
        total_fail = pytest_result.failed + pytest_result.errors
        print(f"\nTests catalogue/wiki (pytest, {label})")
        print(f"  {status}  {pytest_result.passed} passés / {total_fail} échoués")

    print("\nFiches wiki (Tier 1/2/3)")
    print(f"  PASS      {len(passed)}")
    print(f"  AMBER     {len(amber)}  → wiki/eval_queue.md")
    print(f"  REJECTED  {len(rejected)}  → .eval/rejected/")
    print(f"  BLOCKED   {len(blocked)}  ← commit bloqué")

    pytest_failed = pytest_result is not None and pytest_result.exit_code != 0
    commit_ready = not blocked and not pytest_failed

    print()
    if not commit_ready:
        reasons = []
        if blocked:
            reasons.append(f"{len(blocked)} fiche(s) Tier 1 FAIL")
        if pytest_failed:
            reasons.append("pytest échoué")
        print(f"  ❌ COMMIT NON PRÊT — {', '.join(reasons)}")
    elif amber or rejected:
        print("  🟡 COMMIT POSSIBLE — des fiches amber/rejected nécessitent une révision")
    else:
        print("  ✅ COMMIT PRÊT")


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def main() -> int:
    args = sys.argv[1:]

    if not args:
        print("Usage: python LLM-wiki-Assessment/eval/run_eval.py <fiche.md> [...]")
        print("       python LLM-wiki-Assessment/eval/run_eval.py <fiche.md> --external")
        print("       python LLM-wiki-Assessment/eval/run_eval.py <fiche.md> --formulas")
        print("       python LLM-wiki-Assessment/eval/run_eval.py <fiche.md> --formulas --force-formulas")
        print("       python LLM-wiki-Assessment/eval/run_eval.py --all")
        print("       python LLM-wiki-Assessment/eval/run_eval.py --all --external")
        print("       python LLM-wiki-Assessment/eval/run_eval.py --all --skip-tests")
        return 1

    run_all       = "--all" in args
    external      = "--external" in args
    skip_tests    = "--skip-tests" in args
    formulas      = "--formulas" in args
    force_formulas = "--force-formulas" in args
    file_args     = [a for a in args if not a.startswith("--")]

    # --skip-tests only makes sense with --all
    if skip_tests and not run_all:
        print("--skip-tests requires --all")
        return 1

    # --force-formulas only makes sense with --formulas
    if force_formulas and not formulas:
        print("--force-formulas requires --formulas")
        return 1

    pytest_result: PytestResult | None = None

    # Step 1 — pytest (only with --all, unless skipped)
    if run_all and not skip_tests:
        print(f"\n{'=' * 60}")
        print("Étape 1/2 — Tests catalogue et wiki (pytest)")
        print("=" * 60)
        if external:
            print("  Mode réseau activé (--external) — résolution DOI et URLs")
        pytest_result = _run_pytest(external=external)
        _print_pytest_section(pytest_result, external=external)

    # Step 2 — Tier 1/2/3 on wiki fiches
    if run_all:
        print(f"\n{'=' * 60}")
        label = "Étape 2/2" if not skip_tests else "Étape unique"
        print(f"{label} — Évaluation Tier 1/2/3 des fiches wiki")
        print("=" * 60)
        paths = [
            path
            for path in (PROJECT_ROOT / "wiki").rglob("*.md")
            if path.name not in EXCLUDED_FILES
        ]
    else:
        paths = []
        for arg in file_args:
            path = Path(arg)
            if not path.is_absolute():
                path = PROJECT_ROOT / path
            if not path.exists():
                print(f"File not found: {arg}")
                return 1
            paths.append(path)

    outcomes: list[FicheOutcome] = []
    for path in paths:
        outcome = eval_fiche(
            path,
            external=external,
            formulas=formulas,
            force_formulas=force_formulas,
        )
        outcomes.append(outcome)

    # Step 3 — consolidated summary (only with --all)
    if run_all:
        _print_summary(pytest_result, outcomes, external=external)

    # Exit code
    pytest_failed = pytest_result is not None and pytest_result.exit_code != 0
    tier1_failed  = any(o.blocked for o in outcomes)
    return 1 if (pytest_failed or tier1_failed) else 0


if __name__ == "__main__":
    sys.exit(main())
