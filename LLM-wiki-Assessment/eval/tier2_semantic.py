"""Tier 2 - semantic LLM-as-judge evaluation.

Tier 2 is optional and non-blocking. It reads the fiche plus available evidence
from frontmatter sources, then asks a model for a structured JSON judgment.
"""

from __future__ import annotations

import json
import os
import re
from dataclasses import dataclass, field
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent.parent.parent  # LLM-wiki-Assessment/eval/ → llm-wiki-karpathy/
RAW_ROOT = PROJECT_ROOT / "raw"
AGENTS_PATH = PROJECT_ROOT / "AGENTS.md"

DEFAULT_MODEL = os.environ.get("EVAL_MODEL", "claude-haiku-4-5-20251001")
RAW_TEXT_LIMIT = int(os.environ.get("EVAL_RAW_TEXT_LIMIT", "3000"))

EVALUATED_TYPES = {"dataset", "paper", "estimator", "analysis"}
DEFAULT_SCORE_SKIP = 0.80
RAW_ABSENT_CAP = 0.74


@dataclass
class Tier2Result:
    score: float
    raw_available: bool
    details: dict = field(default_factory=dict)
    fields_to_review: list[str] = field(default_factory=list)
    reasoning: str = ""
    skipped: bool = False
    error: str = ""


def _find_source_file(source_name: str) -> Path | None:
    source = Path(str(source_name))
    if source.is_absolute() and source.exists():
        return source
    project_relative = PROJECT_ROOT / source
    if project_relative.exists():
        return project_relative
    for candidate in RAW_ROOT.rglob(str(source_name)):
        return candidate
    for candidate in RAW_ROOT.rglob(source.name):
        return candidate
    return None


def _read_source(path: Path) -> str:
    suffix = path.suffix.lower()
    if suffix in {".txt", ".md", ".json", ".jsonl", ".csv", ".tsv", ".yml", ".yaml"}:
        try:
            return path.read_text(encoding="utf-8-sig")[:RAW_TEXT_LIMIT]
        except OSError:
            return ""
    if suffix == ".pdf":
        try:
            from pdfminer.high_level import extract_text

            return (extract_text(str(path)) or "")[:RAW_TEXT_LIMIT]
        except ImportError:
            return f"[PDF detected: {path.name} - install pdfminer.six for extraction]"
        except Exception as exc:
            return f"[PDF read error {path.name}: {exc}]"
    return ""


def _load_raw_context(sources: list) -> tuple[bool, str]:
    if not sources:
        return False, ""
    blocks = []
    for source in sources:
        path = _find_source_file(str(source))
        if path is None:
            continue
        text = _read_source(path)
        if text:
            rel = path.relative_to(PROJECT_ROOT) if path.is_relative_to(PROJECT_ROOT) else path
            blocks.append(f"### Source: {rel}\n\n{text}")
    return bool(blocks), "\n\n".join(blocks)


def _raw_section(raw_available: bool, raw_context: str) -> str:
    if raw_available:
        return f"## Evidence source excerpt\n\n{raw_context}"
    return "## Evidence source excerpt\n\nNo local source evidence was available for this fiche."


PROMPT_DATASET = """Evaluate this dataset wiki fiche against AGENTS.md and catalog_registry_schema_v3.
Return only valid JSON.

## Fiche

{fiche}

{raw_section}

## Criteria

1. y_typology_ok: candidate Y variables use an allowed typology, or null if unknown.
2. x_typology_ok: candidate X variables use allowed roles/types, or null if unknown.
3. nt_profile_consistent: N/T profile is consistent with N and T, or null if all are unknown.
4. formula_faithful: modeling_evidence is faithful to source evidence, or null if no model source evidence.
5. quality_gate_ok: LLM-proposed quality_pedigree remains pending and requires human review.
6. metadata_completeness_ok: DOI traceability, license, source URL, reproducibility, feature_selection, modeling_evidence and quality_pedigree are explicit. A null/none Dataset DOI is acceptable only when the fiche clearly says no DOI is available.
7. paper_linkage_ok: if the dataset claims a linked scientific paper, paper DOI/title/evidence are coherent; if no paper is linked, the fiche explicitly says none/unknown rather than silently omitting it.

## Expected JSON

{{
  "y_typology_ok": null,
  "y_typology_issue": null,
  "x_typology_ok": null,
  "x_typology_issue": null,
  "nt_profile_consistent": null,
  "nt_issue": null,
  "formula_faithful": null,
  "formula_issue": null,
  "quality_gate_ok": true,
  "quality_gate_issue": null,
  "metadata_completeness_ok": true,
  "metadata_completeness_issue": null,
  "paper_linkage_ok": null,
  "paper_linkage_issue": null,
  "global_score": 0.85,
  "fields_to_review": [],
  "reasoning": "Short justification."
}}
"""

PROMPT_PAPER = """Evaluate this scientific paper wiki fiche against AGENTS.md and catalog_registry_schema_v3.
Return only valid JSON.

## Fiche

{fiche}

{raw_section}

## Criteria

1. paper_doi_ok: paper DOI is present, valid-looking and faithful to source evidence.
2. source_faithful: title, authors/year/venue, abstract and claims match source evidence, or null if no source evidence.
3. dataset_linkage_ok: linked datasets, dataset DOI, data repository, or explicit absence are documented clearly.
4. metadata_completeness_ok: source URL, abstract/summary, related pages, quality_pedigree and review gate are present.
5. quality_gate_ok: LLM-proposed quality_pedigree remains pending and requires human review.

## Expected JSON

{{
  "paper_doi_ok": true,
  "paper_doi_issue": null,
  "source_faithful": null,
  "source_issue": null,
  "dataset_linkage_ok": null,
  "dataset_linkage_issue": null,
  "metadata_completeness_ok": true,
  "metadata_completeness_issue": null,
  "quality_gate_ok": true,
  "quality_gate_issue": null,
  "global_score": 0.85,
  "fields_to_review": [],
  "reasoning": "Short justification."
}}
"""

PROMPT_ESTIMATOR = """Evaluate this estimator wiki fiche against AGENTS.md.
Return only valid JSON.

## Fiche

{fiche}

{raw_section}

## Criteria

1. equation_coherent: equation matches the estimator family, or null if absent.
2. hyperparameters_coherent: hyperparameters match the estimator.
3. source_faithful: fiche is faithful to source evidence, or null if no source evidence.

## Expected JSON

{{
  "equation_coherent": true,
  "equation_issue": null,
  "hyperparameters_coherent": true,
  "hyperparameters_issue": null,
  "source_faithful": null,
  "source_issue": null,
  "global_score": 0.80,
  "fields_to_review": [],
  "reasoning": "Short justification."
}}
"""

PROMPT_ANALYSIS = """Evaluate this analysis wiki fiche against AGENTS.md.
Return only valid JSON.

## Fiche

{fiche}

{raw_section}

## Criteria

1. claims_faithful: claims match source evidence, or null if no source evidence.
2. internally_consistent: no internal contradiction and conclusions are supported.

## Expected JSON

{{
  "claims_faithful": null,
  "claims_issue": null,
  "internally_consistent": true,
  "consistency_issue": null,
  "global_score": 0.85,
  "fields_to_review": [],
  "reasoning": "Short justification."
}}
"""

PROMPTS = {
    "dataset": PROMPT_DATASET,
    "paper": PROMPT_PAPER,
    "estimator": PROMPT_ESTIMATOR,
    "analysis": PROMPT_ANALYSIS,
}


def _load_agents_rules() -> str:
    try:
        return AGENTS_PATH.read_text(encoding="utf-8-sig")
    except OSError:
        return "AGENTS.md rules unavailable."


def _call_judge(entity_type: str, fiche_content: str, raw_available: bool, raw_context: str) -> dict:
    try:
        import anthropic
    except ImportError as exc:
        raise RuntimeError("Package 'anthropic' required: pip install anthropic") from exc

    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        raise RuntimeError("ANTHROPIC_API_KEY is not set")

    user_prompt = PROMPTS[entity_type].format(
        fiche=fiche_content,
        raw_section=_raw_section(raw_available, raw_context),
    )

    client = anthropic.Anthropic(api_key=api_key)
    response = client.messages.create(
        model=DEFAULT_MODEL,
        max_tokens=1024,
        system=_load_agents_rules(),
        messages=[{"role": "user", "content": user_prompt}],
    )
    raw_text = (response.content[0].text or "").strip()
    json_match = re.search(r"\{[\s\S]+\}", raw_text)
    if not json_match:
        raise ValueError(f"Judge response is not parseable JSON: {raw_text[:200]}")
    return json.loads(json_match.group())


def run(fiche_path: Path, frontmatter: dict, body: str) -> Tier2Result:
    entity_type = frontmatter.get("type", "")
    if entity_type not in EVALUATED_TYPES:
        return Tier2Result(
            score=DEFAULT_SCORE_SKIP,
            raw_available=False,
            skipped=True,
            reasoning=f"Type '{entity_type}' is not evaluated by Tier 2",
        )

    raw_available, raw_context = _load_raw_context(frontmatter.get("sources") or [])
    fiche_content = fiche_path.read_text(encoding="utf-8-sig")
    try:
        data = _call_judge(entity_type, fiche_content, raw_available, raw_context)
    except Exception as exc:
        return Tier2Result(
            score=DEFAULT_SCORE_SKIP,
            raw_available=raw_available,
            error=str(exc),
            reasoning=f"Tier 2 was not executed: {exc}",
        )

    score = float(data.get("global_score", DEFAULT_SCORE_SKIP))
    if not raw_available:
        score = min(score, RAW_ABSENT_CAP)
    score = max(0.0, min(1.0, score))
    return Tier2Result(
        score=score,
        raw_available=raw_available,
        details=data,
        fields_to_review=data.get("fields_to_review") or [],
        reasoning=data.get("reasoning", ""),
    )
