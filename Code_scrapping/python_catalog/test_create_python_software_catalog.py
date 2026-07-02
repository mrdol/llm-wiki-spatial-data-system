from __future__ import annotations

import unittest

from create_python_software_catalog import classify_row, datetime_columns


class PythonCatalogClassificationTests(unittest.TestCase):
    def test_australia_boundary_is_reference_geometry(self) -> None:
        row = {
            "package": "geodatasets",
            "dataset": "australia",
            "description": "Australia land polygon including external territories.",
            "variables": "AUS_CODE21, AUS_NAME21, CHG_FLAG21, CHG_LBL21, AREASQKM21, LOCI_URI21, geometry",
            "n": 2,
            "has_geometry": "Yes",
            "has_coordinates": "No",
            "has_place_name_if_no_geometry": "No",
            "role": "main_dataset_catalog_entry",
        }
        result = classify_row(row)
        self.assertEqual(result["usage_role"], "reference_geometry")
        self.assertEqual(result["final_category"], "Declasser auxiliaire")
        self.assertIn("AUS_CODE21", result["identifier_variables"])
        self.assertIn("AUS_NAME21", result["identifier_variables"])
        self.assertNotIn("LOCI_URI21", result["candidate_x_variables"])

    def test_spatial_model_requires_response_covariates_and_rows(self) -> None:
        row = {
            "package": "example",
            "dataset": "observations",
            "description": "Spatial observations with a response.",
            "variables": "record_id, target, elevation, slope, geometry",
            "n": 100,
            "has_geometry": "Yes",
            "has_coordinates": "No",
            "has_place_name_if_no_geometry": "No",
            "role": "main_dataset_catalog_entry",
        }
        result = classify_row(row)
        self.assertEqual(result["candidate_y_variables"], "target")
        self.assertEqual(result["candidate_x_variables"], "elevation, slope")
        self.assertEqual(result["final_category"], "Bons candidats spatial")

    def test_small_spatial_dataset_is_not_good_candidate(self) -> None:
        row = {
            "package": "example",
            "dataset": "tiny_observations",
            "description": "Tiny spatial observations.",
            "variables": "target, x1, x2, geometry",
            "n": 5,
            "has_geometry": "Yes",
            "has_coordinates": "No",
            "has_place_name_if_no_geometry": "No",
            "role": "main_dataset_catalog_entry",
        }
        result = classify_row(row)
        self.assertEqual(result["final_category"], "Spatial simple")
        self.assertIn("n<10", result["classification_reason"])

    def test_nonspatial_model_candidate_keeps_existing_category(self) -> None:
        row = {
            "package": "example",
            "dataset": "tabular",
            "description": "Tabular regression dataset.",
            "variables": "sample_id, response, x1, x2",
            "n": 80,
            "has_geometry": "No",
            "has_coordinates": "No",
            "has_place_name_if_no_geometry": "No",
            "role": "main_dataset_catalog_entry",
        }
        result = classify_row(row)
        self.assertEqual(result["final_category"], "ML non spatial")

    def test_candidate_is_not_mistaken_for_date(self) -> None:
        self.assertEqual(datetime_columns(["I_candidates_total", "event_date"]), ["event_date"])

    def test_xarray_axes_are_spatial_coordinates(self) -> None:
        row = {
            "package": "xarray",
            "dataset": "ice_velocity",
            "description": "Ice velocity observed on a regular grid.",
            "variables": "vx1996, vy1996, err1996, xaxis, yaxis",
            "n": 400000,
            "has_geometry": "No",
            "has_coordinates": "No",
            "has_place_name_if_no_geometry": "No",
            "role": "main_dataset_catalog_entry",
        }
        result = classify_row(row)
        self.assertEqual(result["has_coordinates"], "Yes")
        self.assertEqual(result["coordinate_columns"], "xaxis, yaxis")
        self.assertEqual(result["final_category"], "Spatial simple")


if __name__ == "__main__":
    unittest.main()
