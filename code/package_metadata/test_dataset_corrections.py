"""Regression checks for fiche -> package metadata, without rewriting outputs."""
import importlib.util
import sys
import unittest
import json
from unittest.mock import patch
from pathlib import Path

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('exporter', Path(__file__).with_name('export_spatialtidymodels_metadata.py'))
exporter = importlib.util.module_from_spec(spec)
spec.loader.exec_module(exporter)


class DatasetCorrectionTests(unittest.TestCase):
    def test_curation_preserves_short_table_range(self):
        sys.path.insert(0, str(ROOT / 'code/r_catalog'))
        from dataset_curation import apply_curation
        body = '- formula_used: `richness ~ x`\n\n| Variable | Typologie | Plage |\n|---|---|---|\n| `richness` | unknown | [0, 49] |\n'
        manifest = Path('reviewed-curation-test.json')
        data = json.dumps({'records': {'demo': {'selected_response': 'richness', 'bullets': {'Selected Y typology': 'count'}}}})
        with patch.object(Path, 'exists', return_value=True), patch.object(Path, 'read_text', return_value=data):
            result = apply_curation(body, 'demo', manifest)
            self.assertIn('| `richness` | count | [0, 49] |', result)
            self.assertEqual(result, apply_curation(result, 'demo', manifest))

    def test_pending_is_not_published(self):
        self.assertEqual(exporter._formula_status('- Statut: resolu', 'y ~ x', 'pending'), 'unavailable')

    def test_generated_used_is_not_the_published_model(self):
        body = '- Formula used evidence: generated_system_formula\n- Reference publication: source primary'
        self.assertEqual(exporter._formula_status(body, 'y ~ x', 'other_y ~ z'), 'generated_system_formula')

    def test_selected_response_does_not_union_candidate_types(self):
        path = ROOT / 'wiki/datasets/fiches_datasets/paper_snake_home_range.md'
        record = exporter.parse_dataset_fiche(path, ROOT)
        self.assertEqual(record['response_typology'], ['continuous'])

    def test_short_detail_table_uses_its_header(self):
        body = '#### Detail Y\n\n| Variable | Typologie | Plage |\n|---|---|---|\n| `richness` | count | [0, 49] |\n'
        self.assertEqual(exporter.selected_response_typology(body, 'richness'), ['count'])

    def test_alias_does_not_bypass_explicit_review(self):
        # Existing alias data paths/formula provenance remain useful, but the
        # final readiness flag must honor the current fiche's decision.
        path = ROOT / 'wiki/datasets/fiches_datasets/Python_libpysal_georgia.md'
        text = path.read_text(encoding='utf-8').replace('package_include: "yes"', 'package_include: "manual_review"')
        with patch.object(Path, 'read_text', return_value=text):
            record = exporter.parse_dataset_fiche(path, ROOT)
        self.assertEqual(record['package_include'], 'manual_review')
        self.assertFalse(record['benchmark_ready'])


if __name__ == '__main__':
    unittest.main()
