from __future__ import annotations

import unittest

from audit_reader import candidate_key, is_priority_candidate, llm_downgrade_reason


def audit_row(section_role: str, score: int, **extra: object) -> dict[str, object]:
    return {
        "section_role": section_role,
        "priority_score_int": score,
        "priority_score": str(score),
        "formula_type": "",
        "audit_reason": "",
        "paper_id": "paper:test",
        "section_id": "section:1",
        "candidate_text": "some candidate text",
        **extra,
    }


class IsPriorityCandidateTests(unittest.TestCase):
    def test_data_source_below_threshold_is_not_priority(self) -> None:
        self.assertFalse(is_priority_candidate(audit_row("data_source", 49)))

    def test_data_source_at_threshold_is_priority(self) -> None:
        self.assertTrue(is_priority_candidate(audit_row("data_source", 50)))

    def test_variable_tables_at_inclusion_floor_is_priority(self) -> None:
        self.assertTrue(is_priority_candidate(audit_row("variable_tables", 45)))

    def test_model_tables_needs_the_higher_model_evidence_threshold(self) -> None:
        # model_tables clears the report's own 30-point inclusion floor at 31,
        # but is_priority_candidate uses the higher review_for_model_evidence
        # bar (55), not the report's lowered inclusion threshold.
        self.assertFalse(is_priority_candidate(audit_row("model_tables", 31)))
        self.assertTrue(is_priority_candidate(audit_row("model_tables", 55)))


class CandidateKeyTests(unittest.TestCase):
    def test_same_content_produces_the_same_key(self) -> None:
        row_a = audit_row("data_source", 50)
        row_b = audit_row("data_source", 50)
        self.assertEqual(candidate_key(row_a), candidate_key(row_b))

    def test_different_text_produces_a_different_key(self) -> None:
        row_a = audit_row("data_source", 50, candidate_text="text one")
        row_b = audit_row("data_source", 50, candidate_text="text two")
        self.assertNotEqual(candidate_key(row_a), candidate_key(row_b))


class LlmDowngradeReasonTests(unittest.TestCase):
    def test_no_cache_entry_means_no_downgrade(self) -> None:
        row = audit_row("data_source", 53)
        self.assertIsNone(llm_downgrade_reason(row, cache={}))

    def test_theoretical_verdict_above_confidence_bar_downgrades(self) -> None:
        row = audit_row("data_source", 53)
        cache = {candidate_key(row): {"verdict": "theoretical", "confidence": 0.9, "reasoning": "Pure theorie"}}
        self.assertEqual(llm_downgrade_reason(row, cache), "Pure theorie")

    def test_theoretical_verdict_below_confidence_bar_does_not_downgrade(self) -> None:
        row = audit_row("data_source", 53)
        cache = {candidate_key(row): {"verdict": "theoretical", "confidence": 0.3, "reasoning": "Pas sur"}}
        self.assertIsNone(llm_downgrade_reason(row, cache))

    def test_empirical_verdict_never_downgrades(self) -> None:
        row = audit_row("data_source", 53)
        cache = {candidate_key(row): {"verdict": "empirical", "confidence": 0.95, "reasoning": "Vrai dataset"}}
        self.assertIsNone(llm_downgrade_reason(row, cache))


if __name__ == "__main__":
    unittest.main()
