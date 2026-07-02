"""Verifier la couverture des objets sf dans le knowledge graph local."""

from __future__ import annotations

import json
import sqlite3
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
GRAPH_DB = ROOT / ".kg" / "graph.sqlite"


def main() -> None:
    with sqlite3.connect(GRAPH_DB) as con:
        rows = con.execute("SELECT id, props_json FROM nodes WHERE type = 'Dataset'").fetchall()
        indexed = [(node_id, json.loads(props)) for node_id, props in rows if "sf_ready" in json.loads(props)]
        ready = [(node_id, props) for node_id, props in indexed if props.get("sf_ready") is True]
        aux_edges = con.execute(
            """
            SELECT COUNT(*) FROM edges
            WHERE relation = 'HAS_AUXILIARY_FILE'
              AND source IN (
                SELECT id FROM nodes
                WHERE type = 'Dataset'
                  AND json_extract(props_json, '$.sf_ready') = 1
              )
            """
        ).fetchone()[0]

    print(f"sf_index_nodes={len(indexed)}")
    print(f"sf_ready={len(ready)}")
    print(f"sf_rejected={sum(props.get('sf_ready') is False for _, props in indexed)}")
    print(f"languages={dict(Counter(props.get('language') for _, props in ready))}")
    print(f"geometry={dict(Counter(props.get('sf_geometry_family') for _, props in ready))}")
    print(f"spatiotemporal={sum(props.get('sf_has_time') is True for _, props in ready)}")
    print(f"with_formula={sum(props.get('has_formula') is True for _, props in ready)}")
    print(f"crs_documented={sum(bool(props.get('sf_crs_input')) for _, props in ready)}")
    print(f"crs_verified_by_audit={sum(props.get('crs_audit_verified') is True for _, props in ready)}")
    print(
        "crs_available_or_verified="
        f"{sum(bool(props.get('sf_crs_input')) or props.get('crs_audit_verified') is True for _, props in ready)}"
    )
    print(f"response_known={sum(props.get('response_type') not in (None, '', 'inconnu') for _, props in ready)}")
    print(f"paths_present={sum((ROOT / props['sf_path']).exists() for _, props in ready)}")
    print(f"unique_paths={len({props.get('sf_path') for _, props in ready})}")
    print(f"auxiliary_file_edges={aux_edges}")

    strict = [
        (node_id, props)
        for node_id, props in ready
        if props.get("sf_has_time") is True
        and props.get("has_formula") is True
        and bool(props.get("sf_crs_input"))
        and props.get("response_type") not in (None, "", "inconnu")
    ]
    benchmark_ready = [
        (node_id, props)
        for node_id, props in ready
        if props.get("has_formula") is True
        and bool(props.get("sf_crs_input"))
        and props.get("response_type") not in (None, "", "inconnu")
    ]
    print(f"quality_intersection_without_time={len(benchmark_ready)}")
    print(
        "quality_intersection_without_time_polygons="
        f"{sum(props.get('sf_geometry_family') == 'polygone' for _, props in benchmark_ready)}"
    )
    print(f"strict_intersection={len(strict)}")
    for node_id, props in sorted(strict, key=lambda item: item[1].get("sf_geometry_family", "")):
        print(
            "strict_candidate="
            f"{node_id}|{props.get('sf_geometry_family')}|n={props.get('n')}|"
            f"response={props.get('response_variable')}|type={props.get('response_type')}|"
            f"crs={props.get('sf_crs_input')}|path={props.get('sf_path')}"
        )


if __name__ == "__main__":
    main()
