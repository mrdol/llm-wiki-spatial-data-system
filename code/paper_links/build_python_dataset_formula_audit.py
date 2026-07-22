from __future__ import annotations

import argparse
import csv
import json
import re
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
FICHE_ROOT = ROOT / "wiki" / "datasets" / "fiches_datasets"
OUT_DIR = ROOT / "data" / "manifests" / "datasets"
QUEUE_PATH = ROOT / "wiki" / "datasets" / "python_formula_manual_search_queue.md"

PENDING_VALUES = {"", "pending", "null", "none", "n/a", "na", "unknown"}

# Formules trouvees par revue ciblee de sources web/articles.
# Ces entrees restent explicites pour ne pas melanger une formule publiee
# avec une formule simplement generee depuis les colonnes disponibles.
CURATED_SOURCE_FORMULAS: dict[str, dict[str, str]] = {
    "Python_geodatasets_spdata.boston": {
        "formula_pub": (
            "log(CMEDV) ~ CRIM + I(RM^2) + log(LSTAT) + TAX + ZN + INDUS + "
            "CHAS + I(NOX^2) + AGE + log(DIS) + log(RAD) + PTRATIO + B"
        ),
        "x_terms_pub": (
            "CRIM + I(RM^2) + log(LSTAT) + TAX + ZN + INDUS + CHAS + "
            "I(NOX^2) + AGE + log(DIS) + log(RAD) + PTRATIO + B"
        ),
        "y_term_pub": "log(CMEDV)",
        "source_ref": (
            "Liu-type pretest and shrinkage estimation for the conditional autoregressive model, "
            "Table 1, Boston housing full model; dataset originally Harrison & Rubinfeld (1978)."
        ),
        "source_type": "scientific_article",
        "evidence_source": "web_search: PMC10072455 snippet, Table 1",
    }
}


FIELD_RE = re.compile(r"(?im)^-\s*([^:\n]+)\s*:\s*(.*?)\s*$")
YAML_FIELD_RE = re.compile(r'(?im)^\s{2}([a-zA-Z0-9_]+)\s*:\s*"?([^"\n]+?)"?\s*$')
DATASET_ID_RE = re.compile(r"(?im)^-\s*Dataset ID\s*:\s*`?([^`\n]+)`?\s*$")


@dataclass
class FicheInfo:
    dataset_id: str
    path: Path
    fields: dict[str, str]
    yaml_fields: dict[str, str]
    text: str


def clean(value: str | None) -> str:
    if value is None:
        return ""
    return value.strip().strip('"').strip("'")


def is_pending(value: str | None) -> bool:
    return clean(value).lower() in PENDING_VALUES


def repo_rel(path: Path) -> str:
    return path.relative_to(ROOT).as_posix()


def parse_fiche(path: Path) -> FicheInfo:
    text = path.read_text(encoding="utf-8", errors="replace")
    fields = {clean(key): clean(value) for key, value in FIELD_RE.findall(text)}
    yaml_fields = {clean(key): clean(value) for key, value in YAML_FIELD_RE.findall(text)}
    match = DATASET_ID_RE.search(text)
    dataset_id = clean(match.group(1)) if match else path.stem
    return FicheInfo(dataset_id=dataset_id, path=path, fields=fields, yaml_fields=yaml_fields, text=text)


def split_formula(formula: str) -> tuple[str, str]:
    if "~" not in formula:
        return "", ""
    y_term, x_terms = formula.split("~", 1)
    return clean(y_term), clean(x_terms)


def load_fiches(pattern: str) -> dict[str, FicheInfo]:
    fiches: dict[str, FicheInfo] = {}
    for path in sorted(FICHE_ROOT.glob(pattern)):
        info = parse_fiche(path)
        fiches[info.dataset_id] = info
    return fiches


def load_homologs_from_generate_fiches() -> dict[str, str]:
    """Recupere les paires Python/R deja maintenues par le generateur de fiches."""
    generate_path = ROOT / "code" / "r_catalog" / "generate_fiches.py"
    text = generate_path.read_text(encoding="utf-8", errors="replace")
    block_match = re.search(
        r"PYTHON_R_HOMOLOGS\s*:\s*dict\[str,\s*str\]\s*=\s*\{(?P<body>.*?)\n\}",
        text,
        flags=re.DOTALL,
    )
    if not block_match:
        return {}

    pairs: dict[str, str] = {}
    for left, right in re.findall(r'"([^"]+)"\s*:\s*"([^"]+)"', block_match.group("body")):
        pairs[left] = right
    return pairs


def load_formula_cache() -> dict[str, dict[str, str]]:
    """Lit le cache Y/X si une ancienne passe y a stocke une formule publiee."""
    cache_path = ROOT / "data" / "yx_llm_cache.json"
    if not cache_path.exists():
        return {}

    try:
        payload = json.loads(cache_path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return {}

    formulas: dict[str, dict[str, str]] = {}
    for key, value in payload.items():
        if not isinstance(value, dict):
            continue
        dataset_id = key.split("::", 1)[0]
        formula = clean(value.get("formula_pub"))
        if is_pending(formula):
            continue
        formulas[dataset_id] = {
            "formula_pub": formula,
            "x_terms_pub": clean(value.get("x_terms_pub")),
            "y_term_pub": clean(value.get("y_term_pub")),
            "source_ref": clean(value.get("source_ref")),
            "source_type": clean(value.get("source_type")),
            "evidence_source": "data/yx_llm_cache.json",
        }
    return formulas


def formula_from_fiche(info: FicheInfo) -> dict[str, str]:
    formula = clean(info.fields.get("formula_pub"))
    source_ref = clean(info.fields.get("Reference publication")) or clean(info.yaml_fields.get("source_ref"))
    y_term = clean(info.fields.get("y_term_pub"))
    x_terms = clean(info.fields.get("x_terms_pub"))
    if (not y_term or not x_terms) and "~" in formula:
        y_term, x_terms = split_formula(formula)
    return {
        "formula_pub": formula,
        "x_terms_pub": x_terms,
        "y_term_pub": y_term,
        "source_ref": source_ref,
        "source_type": clean(info.yaml_fields.get("source_type")),
        "evidence_source": repo_rel(info.path),
    }


def make_search_queries(info: FicheInfo) -> str:
    source = clean(info.fields.get("Source")) or "Python spatial dataset"
    name = clean(info.fields.get("Dataset name")) or info.dataset_id
    dataset_token = info.dataset_id.replace("Python_", "").replace("_", " ")
    queries = [
        f'"{name}" regression formula',
        f'"{dataset_token}" spatial regression formula',
        f'"{source}" "{name}" model formula',
    ]
    return " ; ".join(queries)


def build_rows() -> list[dict[str, str]]:
    python_fiches = load_fiches("Python_*.md")
    all_fiches = load_fiches("*.md")
    homologs = load_homologs_from_generate_fiches()
    cache_formulas = load_formula_cache()

    rows: list[dict[str, str]] = []
    for dataset_id, info in sorted(python_fiches.items()):
        current = formula_from_fiche(info)
        current_formula = current["formula_pub"]

        row = {
            "dataset_id": dataset_id,
            "fiche_path": repo_rel(info.path),
            "status": "",
            "formula_pub": "",
            "x_terms_pub": "",
            "y_term_pub": "",
            "source_ref": "",
            "source_type": "",
            "evidence_source": "",
            "evidence_fiche": "",
            "manual_search_reason": "",
            "search_queries": make_search_queries(info),
        }

        if not is_pending(current_formula):
            row.update(current)
            row["status"] = "resolved_existing_python_fiche"
            row["evidence_fiche"] = repo_rel(info.path)
            rows.append(row)
            continue

        homolog_id = homologs.get(dataset_id, "")
        homolog = all_fiches.get(homolog_id)
        if homolog:
            homolog_formula = formula_from_fiche(homolog)
            if not is_pending(homolog_formula["formula_pub"]):
                row.update(homolog_formula)
                row["status"] = "resolved_equivalent_r_fiche"
                row["evidence_fiche"] = repo_rel(homolog.path)
                rows.append(row)
                continue

        cached = cache_formulas.get(dataset_id)
        if cached:
            row.update(cached)
            row["status"] = "resolved_local_formula_cache"
            rows.append(row)
            continue

        curated = CURATED_SOURCE_FORMULAS.get(dataset_id)
        if curated:
            row.update(curated)
            row["status"] = "resolved_curated_web_source"
            rows.append(row)
            continue

        row["status"] = "manual_search_required"
        row["manual_search_reason"] = (
            "Aucune formule de regression publiee n'a ete trouvee dans les fiches Python, "
            "les homologues R connus ou le cache local."
        )
        rows.append(row)

    return rows


def write_csv(rows: list[dict[str, str]], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    columns = [
        "dataset_id",
        "fiche_path",
        "status",
        "formula_pub",
        "x_terms_pub",
        "y_term_pub",
        "source_ref",
        "source_type",
        "evidence_source",
        "evidence_fiche",
        "manual_search_reason",
        "search_queries",
    ]
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=columns)
        writer.writeheader()
        writer.writerows(rows)


def write_jsonl(rows: list[dict[str, str]], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="\n") as handle:
        for row in rows:
            handle.write(json.dumps(row, ensure_ascii=False) + "\n")


def write_manual_queue(rows: list[dict[str, str]], path: Path) -> None:
    manual = [row for row in rows if row["status"] == "manual_search_required"]
    resolved = [row for row in rows if row["status"] != "manual_search_required"]
    lines = [
        "---",
        'title: "Python Dataset Formula Manual Search Queue"',
        "type: dataset_audit",
        "created: 2026-07-22",
        "updated: 2026-07-22",
        "tags: [dataset, formula, python, manual-search]",
        "---",
        "",
        "# Python Dataset Formula Manual Search Queue",
        "",
        "Cette file liste les jeux de données Python pour lesquels la passe automatique n'a pas trouvé de formule de régression publiée.",
        "Aucune formule n'est inventée ici : les lignes `manual_search_required` doivent être traitées par revue manuelle d'article, manuel, dépôt ou documentation.",
        "",
        "## Résumé",
        "",
        f"- Fiches Python auditées: {len(rows)}",
        f"- Formules résolues automatiquement/localement: {len(resolved)}",
        f"- Recherche manuelle requise: {len(manual)}",
        "",
        "## Jeux de données à vérifier manuellement",
        "",
        "| Dataset | Fiche | Requêtes suggérées |",
        "|---|---|---|",
    ]
    for row in manual:
        lines.append(
            f"| `{row['dataset_id']}` | `{row['fiche_path']}` | {row['search_queries'].replace(' ; ', '<br>')} |"
        )

    lines.extend(
        [
            "",
            "## Formules déjà résolues",
            "",
            "| Dataset | Statut | Formule | Source |",
            "|---|---|---|---|",
        ]
    )
    for row in resolved:
        lines.append(
            f"| `{row['dataset_id']}` | `{row['status']}` | `{row['formula_pub']}` | {row['source_ref']} |"
        )

    path.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")


def main() -> None:
    parser = argparse.ArgumentParser(description="Audit Python dataset fiches for published regression formulas.")
    parser.add_argument("--csv", default=str(OUT_DIR / "python_dataset_formula_audit.csv"))
    parser.add_argument("--jsonl", default=str(OUT_DIR / "python_dataset_formula_audit.jsonl"))
    parser.add_argument("--queue", default=str(QUEUE_PATH))
    args = parser.parse_args()

    rows = build_rows()
    write_csv(rows, Path(args.csv))
    write_jsonl(rows, Path(args.jsonl))
    write_manual_queue(rows, Path(args.queue))

    counts: dict[str, int] = {}
    for row in rows:
        counts[row["status"]] = counts.get(row["status"], 0) + 1
    print(json.dumps({"n": len(rows), "status_counts": counts}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
