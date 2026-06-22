"""Registre relationnel minimal pour la curation des datasets.

Objectif:
- centraliser les datasets trouves par le catalogue software;
- rattacher les signaux de l'audit papier/formule aux memes datasets;
- garder les nœuds Dataset actuels du KG comme observations, pas comme verite;
- permettre de tracer un dataset depuis ses sources jusqu'a sa synthese.

Sortie unique:
- data/curation/dataset_registry.sqlite

Ce script ne genere ni CSV ni JSON.
"""

from __future__ import annotations

import argparse
import csv
import json
import re
import sqlite3
from datetime import datetime
from pathlib import Path
from typing import Any, Iterable


ROOT = Path(__file__).resolve().parents[2]
DATASETS_DIR = ROOT / "data" / "manifests" / "datasets"
REGISTRY_DIR = ROOT / "data" / "curation"
REGISTRY_DB = REGISTRY_DIR / "dataset_registry.sqlite"
KG_DB = ROOT / ".kg" / "graph.sqlite"

SOFTWARE_CATALOG = DATASETS_DIR / "software_catalog_curated_final.csv"
AUDIT_CATALOG = DATASETS_DIR / "software_r_dataset_paper_formula_audit.csv"


def norm_text(value: Any) -> str:
    """Nettoyer une valeur textuelle."""
    if value is None:
        return ""
    return re.sub(r"\s+", " ", str(value)).strip()


def slug(value: Any) -> str:
    """Creer une cle stable simple."""
    text = norm_text(value).lower()
    text = re.sub(r"[^a-z0-9]+", "_", text)
    return text.strip("_") or "unknown"


def source_priority_rank(source_type: str) -> int:
    """Priorite de source demandee: package > papier > entrepot."""
    return {
        "package": 1,
        "paper": 2,
        "warehouse": 3,
        "kg_observation": 9,
    }.get(source_type, 99)


def sniff_delimiter(path: Path) -> str:
    """Detecter le separateur CSV sans supposer virgule ou point-virgule."""
    sample = path.read_text(encoding="utf-8-sig", errors="ignore")[:4096]
    return ";" if sample.count(";") > sample.count(",") else ","


def read_csv_rows(path: Path) -> list[dict[str, str]]:
    """Lire un CSV en conservant le numero de ligne source."""
    if not path.exists():
        return []
    delimiter = sniff_delimiter(path)
    rows: list[dict[str, str]] = []
    with path.open("r", encoding="utf-8-sig", errors="ignore", newline="") as handle:
        reader = csv.DictReader(handle, delimiter=delimiter)
        for row_number, row in enumerate(reader, start=2):
            clean = {"" if key is None else str(key): value for key, value in row.items()}
            clean["_row_number"] = str(row_number)
            rows.append(clean)
    return rows


def first(row: dict[str, Any], *names: str) -> str:
    """Retourner la premiere colonne non vide."""
    lower = {str(k).lower(): v for k, v in row.items()}
    for name in names:
        value = row.get(name)
        if norm_text(value):
            return norm_text(value)
        value = lower.get(name.lower())
        if norm_text(value):
            return norm_text(value)
    return ""


def package_dataset_key(package: str, dataset: str) -> str:
    """Cle de dedoublonnage principale."""
    return f"{slug(package)}::{slug(dataset)}"


def dataset_id_from_key(canonical_key: str) -> str:
    """Identifiant canonique du registre."""
    return f"ds:{slug(canonical_key)}"


def raw_json(row: dict[str, Any]) -> str:
    """Stocker la ligne brute dans SQLite pour audit manuel."""
    return json.dumps(row, ensure_ascii=False, sort_keys=True)


def connect() -> sqlite3.Connection:
    """Ouvrir la base SQLite."""
    REGISTRY_DIR.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(REGISTRY_DB)
    conn.row_factory = sqlite3.Row
    conn.execute("pragma foreign_keys = on")
    return conn


def reset_schema(conn: sqlite3.Connection) -> None:
    """Recreer le schema minimal."""
    conn.executescript(
        """
        drop view if exists v_dataset_trace;
        drop table if exists kg_dataset_nodes;
        drop table if exists article_datasets;
        drop table if exists articles;
        drop table if exists dataset_observations;
        drop table if exists datasets;
        drop table if exists packages;
        drop table if exists source_files;

        create table source_files (
            source_file_id text primary key,
            path text not null,
            source_layer text not null,
            loaded_at text not null,
            row_count integer not null
        );

        create table packages (
            package_id text primary key,
            package_name text not null,
            language text,
            source_layer text,
            unique(package_name, language)
        );

        create table datasets (
            dataset_id text primary key,
            canonical_key text not null unique,
            canonical_name text not null,
            package_id text,
            package_name text,
            dataset_name text,
            preferred_source_type text not null,
            source_priority_rank integer not null,
            status text not null,
            utility_class text,
            curation_decision text,
            curation_reason text,
            primary_observation_id text,
            notes text,
            foreign key(package_id) references packages(package_id)
        );

        create table dataset_observations (
            observation_id text primary key,
            dataset_id text not null,
            source_file_id text not null,
            source_layer text not null,
            row_number integer,
            raw_package text,
            raw_dataset text,
            raw_label text,
            normalised_key text not null,
            role text,
            description text,
            n_rows text,
            n_cols text,
            has_geometry text,
            has_coordinates text,
            has_datetime text,
            has_y text,
            candidate_y text,
            candidate_x text,
            formula_text text,
            doi text,
            source_url text,
            confidence text,
            raw_json text not null,
            foreign key(dataset_id) references datasets(dataset_id),
            foreign key(source_file_id) references source_files(source_file_id)
        );

        create table articles (
            article_id text primary key,
            doi text,
            title text,
            authors text,
            year text,
            venue text,
            publisher text,
            source_layer text,
            unique(doi, title)
        );

        create table article_datasets (
            article_dataset_id text primary key,
            article_id text not null,
            dataset_id text not null,
            source_file_id text not null,
            row_number integer,
            relation_type text not null,
            reference_type text,
            doi_verified text,
            doi_type text,
            model_or_equation_found_locally text,
            model_keywords text,
            detected_reference text,
            evidence_note text,
            foreign key(article_id) references articles(article_id),
            foreign key(dataset_id) references datasets(dataset_id),
            foreign key(source_file_id) references source_files(source_file_id)
        );

        create table kg_dataset_nodes (
            kg_node_id text primary key,
            dataset_id text,
            label text not null,
            kg_source text,
            normalised_key text,
            props_json text not null,
            foreign key(dataset_id) references datasets(dataset_id)
        );

        create view v_dataset_trace as
        select
            d.dataset_id,
            d.canonical_key,
            d.canonical_name,
            d.preferred_source_type,
            d.status,
            d.utility_class,
            d.curation_decision,
            d.curation_reason,
            o.source_layer,
            o.source_file_id,
            o.row_number,
            o.raw_package,
            o.raw_dataset,
            o.raw_label,
            o.role,
            o.has_geometry,
            o.has_y,
            o.candidate_y,
            o.candidate_x,
            o.formula_text,
            o.doi,
            o.source_url
        from datasets d
        left join dataset_observations o on o.dataset_id = d.dataset_id;
        """
    )


def insert_source_file(conn: sqlite3.Connection, path: Path, layer: str, row_count: int) -> str:
    """Enregistrer un fichier source lu."""
    source_file_id = path.name
    conn.execute(
        """
        insert or replace into source_files(source_file_id, path, source_layer, loaded_at, row_count)
        values (?, ?, ?, ?, ?)
        """,
        (source_file_id, str(path.relative_to(ROOT)), layer, datetime.now().isoformat(timespec="seconds"), row_count),
    )
    return source_file_id


def upsert_package(conn: sqlite3.Connection, package: str, language: str, source_layer: str) -> str | None:
    """Ajouter un package si disponible."""
    if not package:
        return None
    package_id = f"pkg:{slug(language)}:{slug(package)}"
    conn.execute(
        """
        insert or ignore into packages(package_id, package_name, language, source_layer)
        values (?, ?, ?, ?)
        """,
        (package_id, package, language, source_layer),
    )
    return package_id


def upsert_dataset(
    conn: sqlite3.Connection,
    package: str,
    dataset: str,
    language: str,
    preferred_source_type: str,
    status: str,
    utility_class: str = "",
    curation_decision: str = "",
    curation_reason: str = "",
    notes: str = "",
) -> str:
    """Ajouter ou mettre a jour un dataset canonique."""
    canonical_key = package_dataset_key(package, dataset)
    dataset_id = dataset_id_from_key(canonical_key)
    canonical_name = f"{package}::{dataset}" if package else dataset
    package_id = upsert_package(conn, package, language, "software_catalog" if preferred_source_type == "package" else preferred_source_type)
    rank = source_priority_rank(preferred_source_type)

    existing = conn.execute("select * from datasets where dataset_id=?", (dataset_id,)).fetchone()
    if existing is None:
        conn.execute(
            """
            insert into datasets(
                dataset_id, canonical_key, canonical_name, package_id, package_name, dataset_name,
                preferred_source_type, source_priority_rank, status, utility_class,
                curation_decision, curation_reason, notes
            )
            values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (
                dataset_id,
                canonical_key,
                canonical_name,
                package_id,
                package,
                dataset,
                preferred_source_type,
                rank,
                status,
                utility_class,
                curation_decision,
                curation_reason,
                notes,
            ),
        )
    else:
        current_rank = int(existing["source_priority_rank"])
        if rank < current_rank:
            conn.execute(
                """
                update datasets
                set canonical_name=?, package_id=?, package_name=?, dataset_name=?,
                    preferred_source_type=?, source_priority_rank=?, status=?,
                    utility_class=?, curation_decision=?, curation_reason=?, notes=?
                where dataset_id=?
                """,
                (
                    canonical_name,
                    package_id,
                    package,
                    dataset,
                    preferred_source_type,
                    rank,
                    status,
                    utility_class,
                    curation_decision,
                    curation_reason,
                    notes,
                    dataset_id,
                ),
            )
        elif preferred_source_type == "package" and not existing["utility_class"] and utility_class:
            conn.execute(
                """
                update datasets
                set utility_class=?, curation_decision=?, curation_reason=?
                where dataset_id=?
                """,
                (utility_class, curation_decision, curation_reason, dataset_id),
            )
    return dataset_id


def insert_observation(
    conn: sqlite3.Connection,
    dataset_id: str,
    source_file_id: str,
    source_layer: str,
    row: dict[str, Any],
    package: str,
    dataset: str,
    label: str,
    **fields: Any,
) -> str:
    """Ajouter une observation source rattachee a un dataset canonique."""
    row_number = int(first(row, "_row_number") or 0)
    observation_id = f"obs:{slug(source_layer)}:{slug(source_file_id)}:{row_number}:{slug(package)}:{slug(dataset)}"
    normalised_key = package_dataset_key(package, dataset)
    conn.execute(
        """
        insert or replace into dataset_observations(
            observation_id, dataset_id, source_file_id, source_layer, row_number,
            raw_package, raw_dataset, raw_label, normalised_key, role, description,
            n_rows, n_cols, has_geometry, has_coordinates, has_datetime, has_y,
            candidate_y, candidate_x, formula_text, doi, source_url, confidence, raw_json
        )
        values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        (
            observation_id,
            dataset_id,
            source_file_id,
            source_layer,
            row_number or None,
            package,
            dataset,
            label,
            normalised_key,
            fields.get("role", ""),
            fields.get("description", ""),
            fields.get("n_rows", ""),
            fields.get("n_cols", ""),
            fields.get("has_geometry", ""),
            fields.get("has_coordinates", ""),
            fields.get("has_datetime", ""),
            fields.get("has_y", ""),
            fields.get("candidate_y", ""),
            fields.get("candidate_x", ""),
            fields.get("formula_text", ""),
            fields.get("doi", ""),
            fields.get("source_url", ""),
            fields.get("confidence", ""),
            raw_json(row),
        ),
    )
    conn.execute(
        "update datasets set primary_observation_id=coalesce(primary_observation_id, ?) where dataset_id=?",
        (observation_id, dataset_id),
    )
    return observation_id


def load_software_catalog(conn: sqlite3.Connection) -> int:
    """Charger le catalogue software cure comme source prioritaire package."""
    rows = read_csv_rows(SOFTWARE_CATALOG)
    source_file_id = insert_source_file(conn, SOFTWARE_CATALOG, "software_catalog", len(rows))

    count = 0
    for row in rows:
        language = first(row, "source_language")
        package = first(row, "package")
        dataset = first(row, "dataset", "main_object", "bundle", "dataset_key")
        if not package or not dataset:
            continue
        final_category = first(row, "final_category")
        curation_decision = first(row, "curation_decision")
        curation_reason = first(row, "curation_reason")
        status = "auxiliary" if final_category == "Declasser auxiliaire" else "curated"
        dataset_id = upsert_dataset(
            conn,
            package=package,
            dataset=dataset,
            language=language,
            preferred_source_type="package",
            status=status,
            utility_class=final_category,
            curation_decision=curation_decision,
            curation_reason=curation_reason,
        )
        insert_observation(
            conn,
            dataset_id,
            source_file_id,
            "software_catalog",
            row,
            package,
            dataset,
            f"{package}::{dataset}",
            role=first(row, "role"),
            description=first(row, "description_bundle", "description"),
            n_rows=first(row, "n"),
            n_cols=first(row, "k"),
            has_geometry=first(row, "has_geometry"),
            has_coordinates=first(row, "has_coordinates"),
            has_datetime=first(row, "has_datetime"),
            has_y=first(row, "has_y"),
            candidate_y=first(row, "candidate_y_variables"),
            candidate_x=first(row, "candidate_x_variables"),
            source_url=first(row, "source_url", "source"),
            confidence="curated_catalog",
        )
        count += 1
    return count


def article_id_from(row: dict[str, Any], package: str, dataset: str) -> str:
    """Construire un identifiant article depuis DOI ou titre/source."""
    doi = first(row, "doi").replace("https://doi.org/", "")
    title = first(row, "paper_or_book_title")
    if doi:
        return f"paper:doi:{doi.lower()}"
    return f"paper:audit:{slug(package)}:{slug(dataset)}:{slug(title or first(row, 'source_url') or first(row, 'detected_reference'))}"


def upsert_article(conn: sqlite3.Connection, row: dict[str, Any], package: str, dataset: str) -> str:
    """Inserer un article ou reutiliser celui qui porte deja le meme DOI."""
    doi = first(row, "doi").replace("https://doi.org/", "")
    title = first(row, "paper_or_book_title")
    effective_title = title or first(row, "source_url")
    if doi:
        existing = conn.execute(
            "select article_id from articles where lower(doi)=lower(?)",
            (doi,),
        ).fetchone()
        if existing:
            return str(existing["article_id"])
    if effective_title:
        existing = conn.execute(
            "select article_id from articles where lower(title)=lower(?)",
            (effective_title,),
        ).fetchone()
        if existing:
            return str(existing["article_id"])

    article_id = article_id_from(row, package, dataset)
    conn.execute(
        """
        insert or ignore into articles(
            article_id, doi, title, authors, year, venue, publisher, source_layer
        )
        values (?, ?, ?, ?, ?, ?, ?, ?)
        """,
        (
            article_id,
            doi,
            effective_title,
            first(row, "authors"),
            first(row, "year"),
            first(row, "venue"),
            first(row, "publisher"),
            "dataset_paper_formula_audit",
        ),
    )
    existing = conn.execute(
        "select article_id from articles where article_id=?",
        (article_id,),
    ).fetchone()
    if existing:
        return str(existing["article_id"])
    if doi:
        existing = conn.execute(
            "select article_id from articles where lower(doi)=lower(?)",
            (doi,),
        ).fetchone()
        if existing:
            return str(existing["article_id"])
    if effective_title:
        existing = conn.execute(
            "select article_id from articles where lower(title)=lower(?)",
            (effective_title,),
        ).fetchone()
        if existing:
            return str(existing["article_id"])
    return article_id


def load_audit_catalog(conn: sqlite3.Connection) -> int:
    """Charger l'audit papier/formule comme source relationnelle paper->dataset."""
    rows = read_csv_rows(AUDIT_CATALOG)
    source_file_id = insert_source_file(conn, AUDIT_CATALOG, "dataset_paper_formula_audit", len(rows))

    count = 0
    for row in rows:
        package = first(row, "package")
        dataset = first(row, "dataset")
        if not package or not dataset:
            continue
        dataset_id = upsert_dataset(
            conn,
            package=package,
            dataset=dataset,
            language="R",
            preferred_source_type="paper",
            status="candidate_from_audit",
            notes="Present in paper/formula audit; package source remains preferred if available.",
        )
        insert_observation(
            conn,
            dataset_id,
            source_file_id,
            "dataset_paper_formula_audit",
            row,
            package,
            dataset,
            f"{package}::{dataset}",
            description=first(row, "detected_reference", "verification_note"),
            formula_text=first(row, "model_or_equation_found_locally"),
            doi=first(row, "doi"),
            source_url=first(row, "source_url", "doi_url"),
            confidence=first(row, "doi_verified") or "manual_review_required",
        )

        title = first(row, "paper_or_book_title")
        doi = first(row, "doi").replace("https://doi.org/", "")
        if title or doi or first(row, "source_url"):
            article_id = upsert_article(conn, row, package, dataset)
            row_number = int(first(row, "_row_number") or 0)
            relation_id = f"ad:{slug(article_id)}:{slug(dataset_id)}:{row_number}"
            missing_refs = []
            if conn.execute("select 1 from articles where article_id=?", (article_id,)).fetchone() is None:
                missing_refs.append(f"article_id={article_id}")
            if conn.execute("select 1 from datasets where dataset_id=?", (dataset_id,)).fetchone() is None:
                missing_refs.append(f"dataset_id={dataset_id}")
            if conn.execute("select 1 from source_files where source_file_id=?", (source_file_id,)).fetchone() is None:
                missing_refs.append(f"source_file_id={source_file_id}")
            if missing_refs:
                raise RuntimeError(
                    "Lien article-dataset orphelin ligne "
                    f"{row_number}: {', '.join(missing_refs)}"
                )
            conn.execute(
                """
                insert or replace into article_datasets(
                    article_dataset_id, article_id, dataset_id, source_file_id, row_number,
                    relation_type, reference_type, doi_verified, doi_type,
                    model_or_equation_found_locally, model_keywords,
                    detected_reference, evidence_note
                )
                values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    relation_id,
                    article_id,
                    dataset_id,
                    source_file_id,
                    row_number or None,
                    "uses_or_documents",
                    first(row, "reference_type"),
                    first(row, "doi_verified"),
                    first(row, "doi_type"),
                    first(row, "model_or_equation_found_locally"),
                    first(row, "model_keywords"),
                    first(row, "detected_reference"),
                    first(row, "verification_note"),
                ),
            )
        count += 1
    return count


def load_kg_dataset_nodes(conn: sqlite3.Connection) -> int:
    """Conserver les nœuds Dataset actuels du KG comme observations auditees."""
    if not KG_DB.exists():
        return 0
    kg = sqlite3.connect(KG_DB)
    kg.row_factory = sqlite3.Row
    rows = kg.execute("select id, label, props_json from nodes where type='Dataset'").fetchall()
    insert_source_file(conn, KG_DB, "kg_current_dataset_nodes", len(rows))

    count = 0
    for row in rows:
        props = json.loads(row["props_json"] or "{}")
        package = norm_text(props.get("package"))
        dataset = norm_text(props.get("dataset"))
        label = norm_text(row["label"])
        if not package or not dataset:
            match = re.match(r"([^:]+)::(.+)", label)
            if match:
                package = package or norm_text(match.group(1))
                dataset = dataset or norm_text(match.group(2))
        dataset_id = None
        normalised_key = ""
        if package and dataset:
            normalised_key = package_dataset_key(package, dataset)
            dataset_id = dataset_id_from_key(normalised_key)
            if conn.execute("select 1 from datasets where dataset_id=?", (dataset_id,)).fetchone() is None:
                dataset_id = upsert_dataset(
                    conn,
                    package=package,
                    dataset=dataset,
                    language="unknown",
                    preferred_source_type="kg_observation",
                    status="kg_only_candidate",
                    notes="Present in current KG but not yet validated in software/audit registry.",
                )
        conn.execute(
            """
            insert or replace into kg_dataset_nodes(
                kg_node_id, dataset_id, label, kg_source, normalised_key, props_json
            )
            values (?, ?, ?, ?, ?, ?)
            """,
            (
                row["id"],
                dataset_id,
                label,
                norm_text(props.get("source")) or "<missing>",
                normalised_key,
                row["props_json"] or "{}",
            ),
        )
        count += 1
    return count


def build_registry() -> None:
    """Construire la base de curation."""
    conn = connect()
    reset_schema(conn)
    software_count = load_software_catalog(conn)
    audit_count = load_audit_catalog(conn)
    kg_count = load_kg_dataset_nodes(conn)
    conn.commit()

    summary = {
        "datasets": conn.execute("select count(*) from datasets").fetchone()[0],
        "software_observations": software_count,
        "audit_observations": audit_count,
        "kg_dataset_nodes": kg_count,
        "articles": conn.execute("select count(*) from articles").fetchone()[0],
        "article_dataset_links": conn.execute("select count(*) from article_datasets").fetchone()[0],
    }
    print(f"registry={REGISTRY_DB}")
    for key, value in summary.items():
        print(f"{key}={value}")
    conn.close()


def print_rows(rows: Iterable[sqlite3.Row]) -> None:
    """Afficher des lignes SQLite simplement."""
    for row in rows:
        print(dict(row))


def search_registry(term: str) -> None:
    """Chercher un dataset canonique."""
    conn = connect()
    pattern = f"%{term.lower()}%"
    rows = conn.execute(
        """
        select dataset_id, canonical_name, preferred_source_type, status, utility_class
        from datasets
        where lower(canonical_name) like ? or lower(canonical_key) like ?
        order by canonical_name
        limit 50
        """,
        (pattern, pattern),
    ).fetchall()
    print_rows(rows)
    conn.close()


def explain_dataset(package: str, dataset: str) -> None:
    """Tracer un dataset dans le registre."""
    conn = connect()
    dataset_id = dataset_id_from_key(package_dataset_key(package, dataset))
    ds = conn.execute("select * from datasets where dataset_id=?", (dataset_id,)).fetchone()
    if ds is None:
        print(f"No dataset found for {package}::{dataset}")
        conn.close()
        return

    print("# Dataset")
    print(dict(ds))

    print("\n# Observations")
    rows = conn.execute(
        """
        select source_layer, source_file_id, row_number, raw_label, role, description,
               has_geometry, has_y, candidate_y, candidate_x, formula_text, doi, source_url, confidence
        from dataset_observations
        where dataset_id=?
        order by source_layer, row_number
        """,
        (dataset_id,),
    ).fetchall()
    print_rows(rows)

    print("\n# Articles")
    rows = conn.execute(
        """
        select a.article_id, a.doi, a.title, a.authors, a.year, ad.reference_type,
               ad.doi_verified, ad.model_or_equation_found_locally, ad.evidence_note
        from article_datasets ad
        join articles a on a.article_id = ad.article_id
        where ad.dataset_id=?
        order by a.year, a.title
        """,
        (dataset_id,),
    ).fetchall()
    print_rows(rows)

    print("\n# KG nodes")
    rows = conn.execute(
        """
        select kg_node_id, label, kg_source, normalised_key
        from kg_dataset_nodes
        where dataset_id=?
        order by kg_node_id
        """,
        (dataset_id,),
    ).fetchall()
    print_rows(rows)
    conn.close()


def main() -> None:
    parser = argparse.ArgumentParser(description="Construire ou interroger le registre dataset.")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("build", help="Reconstruire data/curation/dataset_registry.sqlite")

    search = sub.add_parser("search", help="Chercher un dataset")
    search.add_argument("term")

    explain = sub.add_parser("explain", help="Tracer package::dataset")
    explain.add_argument("package")
    explain.add_argument("dataset")

    args = parser.parse_args()
    if args.command == "build":
        build_registry()
    elif args.command == "search":
        search_registry(args.term)
    elif args.command == "explain":
        explain_dataset(args.package, args.dataset)


if __name__ == "__main__":
    main()
