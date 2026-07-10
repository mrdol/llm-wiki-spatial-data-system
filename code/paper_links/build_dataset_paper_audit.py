from __future__ import annotations

import argparse
import csv
import json
import re
import time
from pathlib import Path
from urllib.parse import quote
from urllib.request import Request, urlopen


ROOT = Path(__file__).resolve().parents[2]
DOCS_ROOT = ROOT / "wiki" / "datasets" / "r_package_docs"
RAW_ROOT = ROOT / "raw"
OUT = ROOT / "data" / "manifests" / "datasets" / "software_r_dataset_paper_formula_audit.csv"

DOI_RE = re.compile(r"\b10\.\d{4,9}/[^\s\"'<>),;]+", re.IGNORECASE)
URL_RE = re.compile(r"https?://[^\s\"'<>)]+", re.IGNORECASE)
MODEL_RE = re.compile(
    r"\b("
    r"lm|glm|glmer|lmer|gam|gamm|gwr|krig|krige|variogram|anova|ancova|"
    r"mixed model|linear mixed|generalized linear|spatial model|bayesian|"
    r"AMMI|threshold model|response surface|regression|prediction|forecast"
    r")\b",
    re.IGNORECASE,
)
FORMULA_RE = re.compile(
    r"("
    r"\b(?:lm|glm|glmer|lmer|gam|gwr|aov|asreml|mmer|spautolm|lagsarlm)\s*\([^)]{0,260}"
    r"|[A-Za-z][A-Za-z0-9_.]*\s*~\s*[^,\n)]{3,220}"
    r")",
    re.IGNORECASE,
)


def clean_text(text: str) -> str:
    text = re.sub(r"<[^>]+>", " ", text)
    return re.sub(r"\s+", " ", text).strip()


def normalize_doi(doi: str) -> str:
    doi = doi.strip().rstrip(".")
    doi = doi.replace("doi:", "").replace("DOI:", "")
    return doi.lower()


def split_sections(text: str) -> dict[str, str]:
    sections: dict[str, list[str]] = {"header": []}
    current = "header"
    known = {
        "Description",
        "Usage",
        "Format",
        "Details",
        "Source",
        "References",
        "Examples",
        "See Also",
        "Variables detected from installed object",
    }

    for line in text.splitlines():
        stripped = line.strip()
        if stripped in known:
            current = stripped
            sections.setdefault(current, [])
            continue
        sections.setdefault(current, []).append(line)

    return {key: "\n".join(value).strip() for key, value in sections.items()}


def compact_evidence(lines: list[str], max_items: int = 4) -> str:
    cleaned = []
    for line in lines:
        item = clean_text(line)
        if item and item not in cleaned:
            cleaned.append(item)
    return " | ".join(cleaned[:max_items])


def extract_formula_evidence(text: str) -> tuple[str, str]:
    lines = text.splitlines()
    evidence_lines = []
    keyword_hits = []

    for line in lines:
        if MODEL_RE.search(line) or "~" in line:
            evidence_lines.append(line)
            keyword_hits.extend(match.group(1).lower() for match in MODEL_RE.finditer(line))

    formulas = [match.group(1) for match in FORMULA_RE.finditer(text)]
    evidence = compact_evidence(formulas + evidence_lines, max_items=6)
    keywords = ", ".join(sorted(set(keyword_hits)))
    return evidence, keywords


def extract_references(sections: dict[str, str]) -> str:
    parts = []
    for name in ("Source", "References", "Description", "Details"):
        value = clean_text(sections.get(name, ""))
        if value:
            parts.append(f"{name}: {value}")
    return " || ".join(parts)


def raw_matches(package: str, dataset: str, reference: str) -> str:
    if not RAW_ROOT.exists():
        return ""

    needles = {package.lower(), dataset.lower()}
    for doi in DOI_RE.findall(reference):
        needles.add(normalize_doi(doi).replace("/", "_"))
        needles.add(normalize_doi(doi).replace("/", "-"))

    matches = []
    for path in RAW_ROOT.rglob("*"):
        if not path.is_file():
            continue
        name = path.name.lower()
        if any(needle and needle in name for needle in needles):
            matches.append(str(path.relative_to(ROOT)))
        if len(matches) >= 5:
            break
    return " | ".join(matches)


def crossref_lookup(doi: str) -> dict[str, str]:
    url = f"https://api.crossref.org/works/{quote(doi)}"
    req = Request(
        url,
        headers={
            "User-Agent": "llm-wiki-karpathy dataset DOI audit (mailto:unknown@example.com)"
        },
    )
    with urlopen(req, timeout=35) as response:
        payload = json.loads(response.read().decode("utf-8"))

    msg = payload.get("message") or {}
    authors = []
    for author in msg.get("author") or []:
        name = " ".join(
            part for part in [author.get("given"), author.get("family")] if part
        )
        if name:
            authors.append(name)

    published = msg.get("published-print") or msg.get("published-online") or msg.get("created") or {}
    date_parts = published.get("date-parts") or []
    year = ""
    if date_parts and date_parts[0]:
        year = str(date_parts[0][0])

    container = msg.get("container-title") or []
    titles = msg.get("title") or []
    abstract = clean_text(msg.get("abstract") or "")
    subjects = "; ".join(clean_text(item) for item in (msg.get("subject") or []) if item)
    title = clean_text(titles[0]) if titles else ""
    use_summary = title
    if abstract:
        use_summary = f"{title}. {abstract}" if title else abstract

    return {
        "doi_verified": "yes",
        "doi_type": msg.get("type", ""),
        "title": title,
        "authors": "; ".join(authors[:8]),
        "year": year,
        "venue": clean_text(container[0]) if container else "",
        "publisher": msg.get("publisher", ""),
        "paper_abstract": abstract,
        "paper_subjects": subjects,
        "paper_use_summary": use_summary,
    }


def iter_doc_rows() -> list[dict[str, str]]:
    rows = []
    for path in sorted(DOCS_ROOT.glob("*/topics/*.md")):
        package = path.parts[-3]
        dataset = path.stem
        text = path.read_text(encoding="utf-8", errors="replace")
        sections = split_sections(text)
        reference = extract_references(sections)
        dois = sorted({normalize_doi(doi) for doi in DOI_RE.findall(reference)})
        urls = sorted({url.rstrip(".,") for url in URL_RE.findall(reference)})
        formula_evidence, model_keywords = extract_formula_evidence(text)

        has_reference = bool(dois or urls)
        has_model_signal = bool(model_keywords or formula_evidence)
        if not has_reference and not has_model_signal:
            continue

        if dois:
            for doi in dois:
                rows.append(
                    {
                        "package": package,
                        "dataset": dataset,
                        "reference_type": "doi",
                        "doi": doi,
                        "doi_url": f"https://doi.org/{doi}",
                        "source_url": "",
                        "detected_reference": reference,
                        "model_or_equation_found_locally": formula_evidence,
                        "model_keywords": model_keywords,
                        "local_raw_match": raw_matches(package, dataset, reference),
                        "doc_path": str(path.relative_to(ROOT)),
                    }
                )

        for url in urls:
            if any(doi in url.lower() for doi in dois):
                continue
            rows.append(
                {
                    "package": package,
                    "dataset": dataset,
                    "reference_type": "url",
                    "doi": "",
                    "doi_url": "",
                    "source_url": url,
                    "detected_reference": reference,
                    "model_or_equation_found_locally": formula_evidence,
                    "model_keywords": model_keywords,
                    "local_raw_match": raw_matches(package, dataset, reference),
                    "doc_path": str(path.relative_to(ROOT)),
                }
            )

        if not has_reference and has_model_signal:
            rows.append(
                {
                    "package": package,
                    "dataset": dataset,
                    "reference_type": "local_model_signal",
                    "doi": "",
                    "doi_url": "",
                    "source_url": "",
                    "detected_reference": reference,
                    "model_or_equation_found_locally": formula_evidence,
                    "model_keywords": model_keywords,
                    "local_raw_match": raw_matches(package, dataset, reference),
                    "doc_path": str(path.relative_to(ROOT)),
                }
            )
    return rows


def enrich_rows(rows: list[dict[str, str]], verify_crossref: bool) -> list[dict[str, str]]:
    cache: dict[str, dict[str, str]] = {}
    for row in rows:
        row.update(
            {
                "doi_verified": "",
                "doi_type": "",
                "paper_or_book_title": "",
                "authors": "",
                "year": "",
                "venue": "",
                "publisher": "",
                "paper_abstract": "",
                "paper_subjects": "",
                "paper_use_summary": "",
                "verification_note": "",
            }
        )
        doi = row.get("doi", "")
        if not doi:
            row["verification_note"] = "Lien non DOI ou signal local; verification manuelle requise."
            continue
        if not verify_crossref:
            row["verification_note"] = "DOI extrait localement; verification Crossref non lancee."
            continue
        if doi not in cache:
            try:
                cache[doi] = crossref_lookup(doi)
                time.sleep(0.15)
            except Exception as exc:  # noqa: BLE001
                cache[doi] = {
                    "doi_verified": "no",
                    "doi_type": "",
                    "title": "",
                    "authors": "",
                    "year": "",
                    "venue": "",
                    "publisher": "",
                    "paper_abstract": "",
                    "paper_subjects": "",
                    "paper_use_summary": "",
                    "verification_note": f"Crossref error: {exc}",
                }
        meta = cache[doi]
        row["doi_verified"] = meta.get("doi_verified", "")
        row["doi_type"] = meta.get("doi_type", "")
        row["paper_or_book_title"] = meta.get("title", "")
        row["authors"] = meta.get("authors", "")
        row["year"] = meta.get("year", "")
        row["venue"] = meta.get("venue", "")
        row["publisher"] = meta.get("publisher", "")
        row["paper_abstract"] = meta.get("paper_abstract", "")
        row["paper_subjects"] = meta.get("paper_subjects", "")
        row["paper_use_summary"] = meta.get("paper_use_summary", "")
        row["verification_note"] = meta.get("verification_note", "")
    return rows


def write_csv(rows: list[dict[str, str]], out: Path) -> None:
    out.parent.mkdir(parents=True, exist_ok=True)
    fields = [
        "package",
        "dataset",
        "reference_type",
        "doi",
        "doi_url",
        "source_url",
        "doi_verified",
        "doi_type",
        "paper_or_book_title",
        "authors",
        "year",
        "venue",
        "publisher",
        "paper_abstract",
        "paper_subjects",
        "paper_use_summary",
        "model_or_equation_found_locally",
        "model_keywords",
        "detected_reference",
        "local_raw_match",
        "doc_path",
        "verification_note",
    ]
    with out.open("w", encoding="utf-8-sig", newline="") as fh:
        writer = csv.DictWriter(fh, fieldnames=fields, delimiter=";")
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--verify-crossref", action="store_true")
    parser.add_argument("--output", type=Path, default=OUT)
    args = parser.parse_args()

    rows = iter_doc_rows()
    rows = enrich_rows(rows, verify_crossref=args.verify_crossref)
    rows.sort(key=lambda row: (row["package"].lower(), row["dataset"].lower(), row["reference_type"], row["doi"], row["source_url"]))
    write_csv(rows, args.output)

    doi_count = len({row["doi"] for row in rows if row["doi"]})
    print(f"rows={len(rows)}")
    print(f"unique_dois={doi_count}")
    print(f"output={args.output}")


if __name__ == "__main__":
    main()
