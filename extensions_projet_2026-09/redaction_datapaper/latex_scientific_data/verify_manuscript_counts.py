"""Recalculate the manuscript's numerical claims from current project sources."""

import csv
import hashlib
import json
import statistics
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
WRITING = ROOT / "extensions_projet_2026-09" / "redaction_datapaper"


def read_tsv(path):
    with path.open(encoding="utf-8-sig", newline="") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


coding_path = WRITING / "codage_corpus_complet_2026-09-29.tsv"
registry_path = ROOT / "packages/spatialtidymodels/inst/metadata/datasets.json"
audit_path = WRITING / "audit_etat_repo.json"

coding = read_tsv(coding_path)
selected = [row for row in coding if row["decision"] == "include_quantitative"]
records = json.loads(registry_path.read_text(encoding="utf-8"))["records"]
audit = json.loads(audit_path.read_text(encoding="utf-8"))

assert len(coding) == 120
assert Counter(row["decision"] for row in coding) == {
    "include_quantitative": 101, "context_only": 15, "exclude": 4
}
assert len({row["id"] for row in selected}) == 101
assert sum(int(row["annee"]) >= 2017 for row in selected) == 79

real = [int(row["n_jeux_reels"]) for row in selected]
assert Counter(real) == {0: 27, 1: 62, 2: 9, 3: 2, 7: 1}
assert sum(real) == 93 and statistics.median(real) == 1

validation = Counter(row["validation_application_reelle"] for row in selected)
assert validation == {"in": 59, "aucune": 27, "in+oos": 13, "oos": 2}
assert all(row["validation_application_reelle"] == "aucune"
           for row in selected if int(row["n_jeux_reels"]) == 0)

counting = Counter(row["statut_comptage"] for row in selected)
assert counting == {"exact": 61, "borne_inf": 32, "non_reconstructible": 8}
cells = [int(row["n_cellules"]) for row in selected if row["n_cellules"]]
assert len(cells) == 93 and sum(cells) == 2977
assert statistics.median(cells) == 16
quartiles = statistics.quantiles(cells, n=4, method="inclusive")
assert (quartiles[0], quartiles[2], max(cells)) == (6, 36, 200)
assert sum(int(row["n_experiences"]) for row in selected) == 199

factor_counts = Counter(v for row in selected
                        for v in row["facteurs_minimaux"].split(";") if v)
misspec_counts = Counter(v for row in selected
                         for v in row["misspec"].split(";") if v)
assert factor_counts == {
    "taille": 58, "intensite_spatiale": 45, "loi_erreurs": 26,
    "W_config": 22, "bruit_snr": 17,
}
assert misspec_counts == {
    "heterogeneite": 39, "correlation_X": 37,
    "modele_spatial_errone": 21, "variables_omises": 15,
    "heteroscedasticite": 13, "nonlinearite": 12,
    "W_incorrecte": 10, "W_endogene": 6, "erreur_mesure": 5,
    "interactions": 3, "support_echelle": 1, "donnees_manquantes": 1,
}

assert len(records) == 392
by_status = Counter(row["package_include"] for row in records)
assert by_status == {"yes": 278, "manual_review": 59, "no": 55}
admitted = [row for row in records if row["package_include"] == "yes"]
assert sum(bool(row["benchmark_ready"]) for row in admitted) == 276
assert audit["fiches"]["families"] == {
    "paper": 280, "software_or_other": 111, "warehouse": 1
}

source_hashes = {
    str(path.relative_to(ROOT)): hashlib.sha256(path.read_bytes()).hexdigest()
    for path in (coding_path, registry_path, audit_path)
}
print(json.dumps({
    "quantitative_articles": len(selected),
    "articles_since_2017": sum(int(row["annee"]) >= 2017 for row in selected),
    "real_dataset_distribution": dict(sorted(Counter(real).items())),
    "empirical_uses": sum(real),
    "median_real_datasets": statistics.median(real),
    "validation_application_reelle": dict(validation),
    "simulation_experiments": sum(int(row["n_experiences"]) for row in selected),
    "cell_count_status": dict(counting),
    "documented_cells_minimum": sum(cells),
    "cell_median": statistics.median(cells),
    "cell_quartiles": [quartiles[0], quartiles[2]],
    "cell_maximum": max(cells),
    "basic_factor_counts": dict(factor_counts),
    "misspecification_counts": dict(misspec_counts),
    "catalogue_records": len(records),
    "admission": dict(by_status),
    "source_sha256": source_hashes,
}, indent=2, ensure_ascii=False))
