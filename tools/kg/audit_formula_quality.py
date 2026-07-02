#!/usr/bin/env python3
"""Audit de non-regression de la qualite des noeuds Formula du KG.

Lecture seule des fichiers .kg/extracted/*_nodes.jsonl et *_edges.jsonl deja
produits par run_all.py. Aucune dependance, aucun reseau, pas besoin du
graph.sqlite. A lancer apres chaque rebuild du KG :

    python tools/kg/audit_formula_quality.py
    python tools/kg/audit_formula_quality.py --csv .kg/audit_formules.csv

Controles :
  - texte R casse (assignation <-, accesseur $, separateur ;) ;
  - equation mathematique (signalee a part, ce n'est PAS une formule R cassee) ;
  - formule tronquee (parentheses desequilibrees) ;
  - attribution formule->jeu : overlap des variables OK / mauvaise / zone aveugle ;
  - pulverisation (meme formule attribuee a >= N jeux).
"""
from __future__ import annotations

import argparse
import csv
import glob
import json
import re
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
EXTRACTED = ROOT / ".kg" / "extracted"

# Code R casse : assignation, accesseur data.frame, separateur d'instruction.
BROKEN_R = re.compile(r"<-|##|\$|;|scannf|=\s*(?:FALSE|TRUE)\b")
# Marqueurs d'equation mathematique (LaTeX/maths, legitimes - pas du code R).
MATH = re.compile(r"[∑βεσ∈≤≥±×·∫√θλμ]|\\[a-zA-Z]+|\bi\s*=\s*1\b|_\{|\^\{")


def iter_formula_nodes():
    for path in sorted(glob.glob(str(EXTRACTED / "*_nodes.jsonl"))):
        for line in open(path, encoding="utf-8", errors="ignore"):
            if '"type": "Formula"' not in line:
                continue
            try:
                obj = json.loads(line)
            except json.JSONDecodeError:
                continue
            if obj.get("type") == "Formula":
                yield Path(path).name, obj


def formula_text_of(obj) -> str:
    return str(obj.get("props", {}).get("formula_text") or obj.get("label") or "")


def load_dataset_variables() -> dict[str, set[str]]:
    """variables connues par dataset, via HAS_VARIABLE/COVARIATE/RESPONSE."""
    var_label: dict[str, str] = {}
    for path in glob.glob(str(EXTRACTED / "*_nodes.jsonl")):
        for line in open(path, encoding="utf-8", errors="ignore"):
            if '"Variable"' not in line and "Covariate" not in line and "Response" not in line:
                continue
            try:
                obj = json.loads(line)
            except json.JSONDecodeError:
                continue
            t = obj.get("type", "")
            if t.endswith("Variable") or t == "Covariate":
                var_label[obj["id"]] = str(obj.get("label", "")).lower()
    ds_vars: dict[str, set[str]] = defaultdict(set)
    for path in glob.glob(str(EXTRACTED / "*_edges.jsonl")):
        for line in open(path, encoding="utf-8", errors="ignore"):
            if "HAS_" not in line:
                continue
            try:
                obj = json.loads(line)
            except json.JSONDecodeError:
                continue
            if obj.get("relation", "").startswith("HAS_") and str(obj.get("source", "")).startswith("dataset:"):
                lab = var_label.get(obj["target"])
                if lab:
                    ds_vars[obj["source"]].add(lab)
    return ds_vars


def dataset_id_from_label(label: str) -> str:
    pkg, _, ds = str(label).partition("::")
    norm = lambda s: re.sub(r"[^a-z0-9]", "", s.lower())
    return f"dataset:r:{norm(pkg)}:{norm(ds)}"


def main() -> int:
    parser = argparse.ArgumentParser(description="Audit qualite des formules du KG.")
    parser.add_argument("--csv", help="exporter le detail des formules suspectes vers ce fichier")
    parser.add_argument("--spray-min", type=int, default=3, help="seuil de pulverisation (defaut 3)")
    args = parser.parse_args()

    if not EXTRACTED.exists():
        print(f"Dossier introuvable : {EXTRACTED}. Lance d'abord run_all.py.")
        return 2

    ds_vars = load_dataset_variables()

    total = 0
    by_source = Counter()
    broken = math_eq = truncated = 0
    attr_ok = attr_bad = attr_blind = 0
    spray = defaultdict(set)
    suspects: list[tuple[str, str, str]] = []

    for _file, obj in iter_formula_nodes():
        total += 1
        ft = formula_text_of(obj)
        src = (
            "papier" if obj["id"].startswith("formula:tei")
            else "doc" if obj["id"].startswith("formula:catalog")
            else "autre"
        )
        by_source[src] += 1

        # Une formule R a un "~" ; une equation mathematique non. On ne juge
        # "casse"/"tronque" QUE les formules R (avec ~), sinon on compte
        # l'equation maths a part (parentheses et ; y sont legitimes).
        is_r_formula = "~" in ft
        if not is_r_formula and MATH.search(ft):
            math_eq += 1
        elif not is_r_formula:
            math_eq += 1  # sans ~ : traite comme equation/expression, pas du code R
        else:
            if BROKEN_R.search(ft):
                broken += 1
                suspects.append((src, "texte_casse", ft))
            if ft.count("(") != ft.count(")"):
                truncated += 1
                suspects.append((src, "tronquee", ft))

        ds = obj.get("props", {}).get("dataset")
        if ds:
            spray[ft].add(str(ds))
            if obj["id"].startswith("formula:tei"):
                known = ds_vars.get(dataset_id_from_label(ds))
                if not known:
                    attr_blind += 1
                else:
                    tokens = {t.lower() for t in re.findall(r"[A-Za-z_][A-Za-z0-9_.]*", ft)}
                    if tokens & known:
                        attr_ok += 1
                    else:
                        attr_bad += 1
                        suspects.append((src, "mauvaise_attribution", f"{ds} | {ft}"))

    multi = {k: v for k, v in spray.items() if len(v) >= args.spray_min}
    for ft, datasets in multi.items():
        suspects.append(("-", "spray", f"{len(datasets)} jeux | {ft}"))

    pct = lambda n: f"{100 * n // total}%" if total else "0%"
    print(f"# Audit qualite des formules du KG  ({EXTRACTED})")
    print(f"\nTOTAL noeuds Formula : {total}   {dict(by_source)}")
    print(f"  texte R casse (<-, $, ;)                 : {broken:4d}  {pct(broken)}")
    print(f"  equation mathematique (legitime, a part) : {math_eq:4d}  {pct(math_eq)}")
    print(f"  formule tronquee (parentheses)           : {truncated:4d}  {pct(truncated)}")
    print("\nAttribution formule(papier) -> jeu :")
    print(f"  overlap variables OK            : {attr_ok}")
    print(f"  AUCUN overlap (mauvaise attrib.): {attr_bad}")
    print(f"  zone aveugle (jeu sans variables): {attr_blind}")
    print(f"\nPulverisation (>= {args.spray_min} jeux) : {len(multi)} formule(s)")
    for ft, datasets in sorted(multi.items(), key=lambda x: -len(x[1]))[:10]:
        print(f"  {len(datasets):2d} <- {ft[:60]}")

    verdict = "PROPRE" if (broken == 0 and attr_bad == 0) else "A INSPECTER"
    print(f"\nVerdict : {verdict}  (texte casse={broken}, mauvaises attributions={attr_bad})")

    if args.csv:
        out = Path(args.csv)
        out.parent.mkdir(parents=True, exist_ok=True)
        with open(out, "w", newline="", encoding="utf-8") as fh:
            w = csv.writer(fh)
            w.writerow(["source", "probleme", "detail"])
            w.writerows(suspects)
        print(f"\nDetail des {len(suspects)} cas suspects -> {out}")

    # Code de sortie non nul si regression (utile en CI / pre-commit).
    return 1 if (broken or attr_bad) else 0


if __name__ == "__main__":
    raise SystemExit(main())
