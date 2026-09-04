from __future__ import annotations

import unittest

from section_role import pattern_hits, score_section, score_table


class PatternHitsWordBoundaryTests(unittest.TestCase):
    def test_short_token_does_not_match_inside_unrelated_word(self) -> None:
        self.assertEqual(pattern_hits("this is not necessary at all", ["sar"]), [])
        self.assertEqual(pattern_hits("we describe the methodology here", ["log"]), [])

    def test_short_token_matches_as_standalone_word(self) -> None:
        self.assertEqual(pattern_hits("we estimate a sar model", ["sar"]), ["sar"])

    def test_multiword_phrase_still_matches_by_substring(self) -> None:
        self.assertEqual(pattern_hits("the data set was obtained from the county", ["obtained from"]), ["obtained from"])


class ScoreSectionRegressionTests(unittest.TestCase):
    def test_theoretical_textbook_prose_is_not_a_top_priority_data_source(self) -> None:
        # Paraphrase of an Anselin (1988) theory chapter: no real dataset is
        # described, but it uses the same generic econometrics vocabulary
        # (data set, regression, coefficient, log, census) that used to
        # saturate the score to 100 as DataSourceCandidate.
        title = "Spatial Dependence and Aggregation"
        text = (
            "The second factor which may cause spatial dependence is more fundamental in "
            "regional science. Spatial data set structures such as census tracts are commonly "
            "used to illustrate the regression model, and coefficient estimates from the "
            "spatial lag or spatial error specification depend on how the log of the variable "
            "is defined in this general framework."
        )
        result = score_section(title, text)
        self.assertNotEqual(result["section_role"], "data_source")
        self.assertLess(result["priority_score"], 70)

    def test_real_dataset_mention_without_a_provenance_verb_is_still_typed_data_source(self) -> None:
        # Regression case: a real named/used dataset ("Used Car Prices", Hanna
        # 1960s data) described without an explicit "downloaded"/"available
        # at" phrase must still be typed data_source, even though its score
        # stays modest without a strong provenance verb.
        title = "Used Car Prices"
        text = (
            "In the 1960s, Hanna wanted to examine the effects of regional differences in "
            "state taxes and transportation charges on used car prices. The article lists "
            "data for the 48 coterminous US states. The data set was used by Hepple in "
            "developing ML estimation methods for spatial series."
        )
        result = score_section(title, text)
        self.assertEqual(result["section_role"], "data_source")

    def test_genuine_data_provenance_passage_is_still_flagged_as_data_source(self) -> None:
        title = "Study Area and Data"
        text = (
            "We downloaded the parcel-level dataset from the county assessor's office, "
            "available at the open data portal as a shapefile. The sample consists of "
            "1,204 residential properties sold between 2015 and 2020."
        )
        result = score_section(title, text)
        self.assertEqual(result["section_role"], "data_source")
        self.assertGreaterEqual(result["priority_score"], 45)

    def test_primary_role_is_the_strongest_match_not_the_first_rule_in_file(self) -> None:
        # Only a weak, incidental data_source content hit ("shapefile" once)
        # against a much stronger, repeated empirical_model signal: the
        # section should not be mislabeled data_source just because that
        # role happens to be listed first in section_role_rules.yml.
        title = "Empirical Model Specification"
        text = (
            "We estimate a spatial regression model with a spatial lag term. The dependent "
            "variable is regressed on explanatory variables using a spatial autoregressive "
            "specification (sar); coefficients are interpreted following standard practice. "
            "A shapefile was mentioned once in passing."
        )
        result = score_section(title, text)
        self.assertEqual(result["section_role"], "empirical_model")

    def test_simulation_table_is_penalized(self) -> None:
        title = "Table 1"
        text = (
            "Simulation of the power of a t-test on the regression coefficient at the "
            "nominal level of 0.05 for uncorrelated y and x, following a Monte Carlo "
            "experiment with synthetic data generated for the spatial dependence parameter."
        )
        result = score_section(title, text)
        self.assertIn("simulation", result["section_roles"])
        self.assertLess(result["priority_score"], 70)


class ScoreTableRegressionTests(unittest.TestCase):
    def test_substantial_regression_results_table_is_not_silently_dropped(self) -> None:
        # GROBID often fails to isolate a clean caption for these tables (the
        # caption text ends up glued to the body). Before the fix, a table
        # like this scored exactly 0 and was discarded entirely by
        # 03_parse_tei.py, so it never appeared in the audit CSV or the KG.
        caption = "Table 9 ."
        body = (
            "Table 9 .9Spatial Model Estimation Results SDM SAR SEM GS-2SLS Lnypc 0.009 0.005 0.027 0.002 "
            "(0.866) (0.932) (0.625) (0.974) Density -0.011 (0.021) ** -0.025 (0.000) *"
        )
        result = score_table(caption, body)
        self.assertGreater(result["priority_score"], 0)
        self.assertEqual(result["table_role"], "model_tables")

    def test_spatial_dependence_test_table_is_recognized(self) -> None:
        caption = "Table 8 ."
        body = "Table 8 .8Tests for Spatial Dependence in the OLS Regression Moran's I 3.036 (0.002) ** LM(error) 25.407"
        result = score_table(caption, body)
        self.assertEqual(result["table_role"], "model_tables")

    def test_truly_empty_table_still_scores_zero(self) -> None:
        result = score_table("", "")
        self.assertEqual(result["priority_score"], 0)

    def test_unmatched_but_substantial_table_gets_a_floor_score_not_zero(self) -> None:
        # No known caption/body keyword matches at all, but there is real
        # tabular content: this must stay visible (floor score) rather than
        # vanish like the previous behavior.
        caption = "Table 10 ."
        body = "Table 10 .10Summary of factors determining PV adoption Variable Findings in existing literature Our findings Income Muller and Rode (2013)"
        result = score_table(caption, body)
        self.assertGreater(result["priority_score"], 0)
        self.assertEqual(result["table_role"], "table_other")


if __name__ == "__main__":
    unittest.main()
