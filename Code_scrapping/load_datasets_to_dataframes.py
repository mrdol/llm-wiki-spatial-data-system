from __future__ import annotations

import argparse
import io
import itertools
import json
import zipfile
from pathlib import Path
from typing import Any

import pandas as pd
from pandas.errors import ParserError


PROJECT_ROOT = Path(__file__).resolve().parents[1]
DOWNLOADS_DIR = PROJECT_ROOT / "data" / "downloads"
DEFAULT_OUTPUT_DIR = PROJECT_ROOT / "data" / "dataframes"


def read_csv_flexible(source: Any, compression: str | None = None) -> pd.DataFrame:
    """
    Read CSV with resilient fallbacks for mixed delimiters and metadata preambles.
    """
    attempts: list[dict[str, Any]] = [
        {"sep": ",", "low_memory": False, "compression": compression},
        {"sep": ";", "decimal": ",", "low_memory": False, "compression": compression},
        {"sep": None, "engine": "python", "decimal": ",", "compression": compression},
        {"sep": ",", "skiprows": 4, "low_memory": False, "compression": compression},
        {"sep": ";", "skiprows": 4, "engine": "python", "decimal": ",", "compression": compression},
    ]

    last_error: Exception | None = None
    for kwargs in attempts:
        try:
            cleaned = {k: v for k, v in kwargs.items() if v is not None}
            return pd.read_csv(source, **cleaned)
        except (ParserError, UnicodeDecodeError, ValueError) as exc:
            last_error = exc

    if last_error is not None:
        raise last_error
    raise ValueError("Unable to parse CSV source with fallback strategies.")


def _safe_dim_labels(payload: dict[str, Any], dim: str) -> list[Any]:
    dim_meta = payload.get("dimension", {}).get(dim, {})
    category = dim_meta.get("category", {})
    labels = category.get("label", {})
    index = category.get("index", {})

    if isinstance(index, dict):
        ordered = sorted(index.items(), key=lambda item: item[1])
        return [labels.get(code, code) for code, _ in ordered]
    if isinstance(index, list):
        return [labels.get(code, code) for code in index]
    return []


def json_stat_to_dataframe(payload: dict[str, Any], max_rows: int | None = None) -> pd.DataFrame:
    dims = payload.get("id", [])
    sizes = payload.get("size", [])
    values = payload.get("value", [])
    if not dims or not sizes:
        return pd.json_normalize(payload)

    dim_labels: list[list[Any]] = []
    for dim, size in zip(dims, sizes):
        labels = _safe_dim_labels(payload, dim)
        if len(labels) != size:
            labels = list(range(size))
        dim_labels.append(labels)

    rows: list[dict[str, Any]] = []

    # JSON-stat "value" can be:
    # - list: dense positional values
    # - dict: sparse values keyed by flattened position index
    if isinstance(values, list):
        for idx, combo in enumerate(itertools.product(*[range(s) for s in sizes])):
            if idx >= len(values):
                break
            if max_rows is not None and len(rows) >= max_rows:
                break

            value = values[idx]
            if value is None:
                continue

            row = {dim: dim_labels[pos][combo[pos]] for pos, dim in enumerate(dims)}
            row["value"] = value
            rows.append(row)
    elif isinstance(values, dict):
        multipliers: list[int] = []
        acc = 1
        for size in reversed(sizes[1:]):
            acc *= size
            multipliers.append(acc)
        multipliers = list(reversed(multipliers)) + [1]

        def index_to_combo(flat_idx: int) -> list[int]:
            combo: list[int] = []
            remainder = flat_idx
            for size, mult in zip(sizes, multipliers):
                coord = remainder // mult
                remainder = remainder % mult
                if coord >= size:
                    return []
                combo.append(coord)
            return combo

        for key, value in values.items():
            if max_rows is not None and len(rows) >= max_rows:
                break
            if value is None:
                continue

            try:
                flat_idx = int(key)
            except ValueError:
                continue

            combo = index_to_combo(flat_idx)
            if not combo:
                continue

            row = {dim: dim_labels[pos][combo[pos]] for pos, dim in enumerate(dims)}
            row["value"] = value
            rows.append(row)
    else:
        return pd.json_normalize(payload)

    return pd.DataFrame(rows)


def read_json(path: Path, max_rows: int | None = None) -> pd.DataFrame:
    with path.open("r", encoding="utf-8") as f:
        payload = json.load(f)

    if isinstance(payload, dict) and {"id", "size", "value"}.issubset(payload.keys()):
        return json_stat_to_dataframe(payload, max_rows=max_rows)
    if isinstance(payload, list):
        return pd.json_normalize(payload)
    if isinstance(payload, dict):
        return pd.json_normalize(payload)
    raise ValueError(f"Unsupported JSON structure in {path}")


def read_zip(path: Path, max_rows: int | None = None) -> pd.DataFrame:
    with zipfile.ZipFile(path) as zf:
        names = [n for n in zf.namelist() if not n.endswith("/")]
        if not names:
            raise ValueError(f"No files found inside {path}")

        candidates = sorted(
            names,
            key=lambda n: (
                0 if n.lower().endswith(".csv") else 1 if n.lower().endswith(".tsv") else 2 if n.lower().endswith(".json") else 9,
                n,
            ),
        )
        best_df: pd.DataFrame | None = None
        best_score = -1
        last_error: Exception | None = None

        for target in candidates:
            with zf.open(target) as fp:
                raw = fp.read()

            lower = target.lower()
            try:
                if lower.endswith(".csv"):
                    df = read_csv_flexible(io.BytesIO(raw))
                elif lower.endswith(".tsv"):
                    df = pd.read_csv(io.BytesIO(raw), sep="\t")
                elif lower.endswith(".json"):
                    payload = json.loads(raw.decode("utf-8", errors="replace"))
                    if isinstance(payload, dict) and {"id", "size", "value"}.issubset(payload.keys()):
                        df = json_stat_to_dataframe(payload, max_rows=max_rows)
                    else:
                        df = pd.json_normalize(payload)
                else:
                    continue
            except Exception as exc:  # noqa: BLE001
                last_error = exc
                continue

            # Prefer the richest candidate table in archives that bundle metadata files.
            score = int(df.shape[0]) * max(int(df.shape[1]), 1)
            if score > best_score:
                best_df = df
                best_score = score

        if best_df is not None:
            return best_df
        if last_error is not None:
            raise last_error

    raise ValueError(f"No supported table-like file in zip: {path}")


def load_to_dataframe(path: Path, max_rows: int | None = None) -> pd.DataFrame:
    lower = path.name.lower()
    if lower.endswith(".csv"):
        return read_csv_flexible(path)
    if lower.endswith(".csv.gz"):
        return read_csv_flexible(path, compression="gzip")
    if lower.endswith(".json"):
        return read_json(path, max_rows=max_rows)
    if lower.endswith(".zip"):
        return read_zip(path, max_rows=max_rows)
    raise ValueError(f"Unsupported file type: {path}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Load downloaded datasets into pandas DataFrames.")
    parser.add_argument("--downloads-dir", type=Path, default=DOWNLOADS_DIR)
    parser.add_argument("--max-rows-json", type=int, default=200000)
    parser.add_argument("--persist-pickle", action="store_true", help="Persist each dataframe to data/dataframes/*.pkl")
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    args = parser.parse_args()

    files = sorted([p for p in args.downloads_dir.iterdir() if p.is_file()])
    if not files:
        raise SystemExit(f"No files found in {args.downloads_dir}")

    dataframes: dict[str, pd.DataFrame] = {}
    failures: list[tuple[str, str]] = []

    for file_path in files:
        try:
            df = load_to_dataframe(file_path, max_rows=args.max_rows_json)
            dataframes[file_path.name] = df
            print(f"[OK] {file_path.name}: shape={df.shape}")
        except Exception as exc:  # noqa: BLE001
            failures.append((file_path.name, str(exc)))
            print(f"[FAIL] {file_path.name}: {exc}")

    print(f"\nLoaded {len(dataframes)} / {len(files)} files into DataFrames.")

    if args.persist_pickle and dataframes:
        args.output_dir.mkdir(parents=True, exist_ok=True)
        for filename, df in dataframes.items():
            out = args.output_dir / f"{Path(filename).stem}.pkl"
            df.to_pickle(out)
            print(f"[SAVED] {out}")

    if failures:
        print("\nFiles not converted:")
        for filename, reason in failures:
            print(f" - {filename}: {reason}")


if __name__ == "__main__":
    main()
