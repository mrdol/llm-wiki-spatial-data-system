"""Download topic-selected review PDFs using the repository's existing downloader.

Input/output are JSON, not a replacement for the future Biblio_from_pdf workflow.
Run from repository root: python tools/download_extension_review_pdfs.py
"""
from pathlib import Path
import concurrent.futures
import hashlib
import importlib.util
import json
import sys
from pypdf import PdfReader

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "extensions_projet_2026-09"
SELECTION = BASE / "selection_articles_web_2026-09-09.json"
PRIOR = {}
spec = importlib.util.spec_from_file_location("existing_pdf_downloader", ROOT / "code/package_metadata/download_regression_article_pdfs.py")
downloader = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = downloader
spec.loader.exec_module(downloader)


def one(item):
    folder = BASE / item["topic"] / "articles_complementaires_2026-09-09"
    folder.mkdir(parents=True, exist_ok=True)
    path = folder / downloader.safe_filename(item["key"])
    if path.exists():
        result = {**PRIOR.get(item["key"],{}), "status":"already_present",
                  "local_path":path.relative_to(ROOT).as_posix()}
    else:
        with downloader.build_session() as session:
            entry = downloader.BibEntry(key=item["key"], title=item["title"],doi=item.get("doi",""),urls=item["urls"])
            result = downloader.download_entry(session,entry,folder,downloader.DEFAULT_EMAIL,25,False)
    record = {**item, **result, "checked_on":"2026-09-09", "reading_status":"selected_not_fully_read"}
    if record["status"] in ("downloaded","already_present"):
        try:
            reader = PdfReader(path)
            assert len(reader.pages)>0
            preview = "\n".join((p.extract_text() or "") for p in reader.pages[:2])
            record.update(pages=len(reader.pages),sha256=hashlib.sha256(path.read_bytes()).hexdigest(),
                          first_pages_excerpt=preview[:3500],pdf_parse_valid=True)
        except Exception as exc:
            record.update(status="invalid_pdf",pdf_parse_valid=False,note=str(exc))
    return record


def main():
    items = json.loads(SELECTION.read_text(encoding="utf-8"))
    for previous in BASE.glob("revue_*/articles_complementaires_2026-09-09/manifest_telechargements.json"):
        PRIOR.update({r["key"]:r for r in json.loads(previous.read_text(encoding="utf-8"))})
    records = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=3) as executor:
        tasks = {executor.submit(one,item):item for item in items}
        for future in concurrent.futures.as_completed(tasks):
            item = tasks[future]
            try: record = future.result()
            except Exception as exc: record = {**item,"status":"error","note":str(exc)}
            records.append(record)
            print(record["key"],record["status"],flush=True)
            for topic in {r["topic"] for r in records}:
                subset = sorted([r for r in records if r["topic"]==topic],key=lambda r:r["key"])
                output = BASE/topic/"articles_complementaires_2026-09-09"/"manifest_telechargements.json"
                output.write_text(json.dumps(subset,indent=2,ensure_ascii=False)+"\n",encoding="utf-8")
    print("Completed",len(records),"selected papers",flush=True)


if __name__=="__main__": main()
