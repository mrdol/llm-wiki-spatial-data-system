from __future__ import annotations

import importlib.util
import sys
import unittest
from pathlib import Path

MODULE_PATH = Path(__file__).with_name("10_make_audit_candidate_review.py")
_spec = importlib.util.spec_from_file_location("make_audit_candidate_review", MODULE_PATH)
make_audit_candidate_review = importlib.util.module_from_spec(_spec)
sys.modules[_spec.name] = make_audit_candidate_review
_spec.loader.exec_module(make_audit_candidate_review)  # type: ignore[union-attr]

selected_rows = make_audit_candidate_review.selected_rows
review_action = make_audit_candidate_review.review_action
candidate_key = make_audit_candidate_review.candidate_key


def audit_row(section_role: str, score: int, formula_type: str = "", **extra: object) -> dict[str, object]:
    return {
        "section_role": section_role,
        "priority_score_int": score,
        "priority_score": str(score),
        "formula_type": formula_type,
        "audit_reason": "",
        "paper_id": "paper:test",
        "section_id": "section:1",
        "candidate_text": "some candidate text",
        **extra,
    }


class SelectedRowsThresholdTests(unittest.TestCase):
    def test_model_table_candidate_uses_a_lower_threshold(self) -> None:
        # Table captions extracted by GROBID are often too thin to reach the
        # default 45 cutoff even for a genuine results table (real
        # regression coefficients / spatial dependence tests).
        row = audit_row("model_tables", 31)
        self.assertEqual(selected_rows([row]), [row])

    def test_model_table_candidate_below_its_own_threshold_is_still_excluded(self) -> None:
        row = audit_row("model_tables", 29)
        self.assertEqual(selected_rows([row]), [])

    def test_data_source_candidate_keeps_the_default_higher_threshold(self) -> None:
        # The default-45 kinds must NOT be loosened: that was exactly the
        # false-positive flood fixed earlier (generic theory/textbook prose
        # scoring in the 30s-40s for data_source/empirical_model).
        row = audit_row("data_source", 31)
        self.assertEqual(selected_rows([row]), [])

    def test_data_source_candidate_at_default_threshold_is_included(self) -> None:
        row = audit_row("data_source", 45)
        self.assertEqual(selected_rows([row]), [row])


class ReviewActionLlmDowngradeTests(unittest.TestCase):
    def test_without_llm_cache_keyword_action_is_unchanged(self) -> None:
        row = audit_row("data_source", 53)
        self.assertEqual(review_action(row, llm_cache=None), "review_for_dataset_use")

    def test_llm_theoretical_verdict_downgrades_a_priority_candidate(self) -> None:
        row = audit_row("data_source", 53)
        cache = {candidate_key(row): {"verdict": "theoretical", "confidence": 0.9, "reasoning": "Chapitre theorique"}}
        self.assertEqual(review_action(row, llm_cache=cache), "low_priority_review")

    def test_llm_empirical_verdict_keeps_the_priority_action(self) -> None:
        row = audit_row("data_source", 53)
        cache = {candidate_key(row): {"verdict": "empirical", "confidence": 0.9, "reasoning": "Dataset reel"}}
        self.assertEqual(review_action(row, llm_cache=cache), "review_for_dataset_use")

    def test_llm_cache_cannot_promote_a_non_priority_candidate(self) -> None:
        # The LLM step only ever runs on candidates already in the priority
        # zone, but review_action() must stay safe even if given a cache
        # entry for a low-scoring row: it must not invent a promotion.
        row = audit_row("data_source", 20)
        cache = {candidate_key(row): {"verdict": "empirical", "confidence": 0.99, "reasoning": "n/a"}}
        self.assertEqual(review_action(row, llm_cache=cache), "low_priority_review")


if __name__ == "__main__":
    unittest.main()
