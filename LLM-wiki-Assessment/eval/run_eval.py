"""Evaluation pipeline orchestrator.

Usage:
    python LLM-wiki-Assessment/eval/run_eval.py <fiche.md> [<fiche.md> ...]
    python LLM-wiki-Assessment/eval/run_eval.py --all
    python LLM-wiki-Assessment/eval/run_eval.py --all --external
    python LLM-wiki-Assessment/eval/run_eval.py --all --skip-tests

Flags (only valid with --all):
    --external    Also run network tests (DOI resolution, URL reachability).
    --skip-tests  Skip pytest entirely, run only Tier 1/2/3 on wiki fiches.

Exit codes:
    0 - Tier 1 passed on all fiches and pytest passed (or was skipped).
    1 - At least one Tier 1 failure OR pytest failure.
"""

from __future__ import annotations

import subprocess
import sys
from dataclasses import dataclass, field
from pathlib import Path

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

from eval import tier1_structural, tier2_semantic, tier3_queue

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


def eval_fiche(fiche_path: Path) -> FicheOutcome:
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

    print(f"\nFiches wiki (Tier 1/2/3)")
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
        print("       python LLM-wiki-Assessment/eval/run_eval.py --all")
        print("       python LLM-wiki-Assessment/eval/run_eval.py --all --external")
        print("       python LLM-wiki-Assessment/eval/run_eval.py --all --skip-tests")
        return 1

    run_all     = "--all" in args
    external    = "--external" in args
    skip_tests  = "--skip-tests" in args
    file_args   = [a for a in args if not a.startswith("--")]

    # --external and --skip-tests only make sense with --all
    if (external or skip_tests) and not run_all:
        print("--external and --skip-tests require --all")
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
        outcome = eval_fiche(path)
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
