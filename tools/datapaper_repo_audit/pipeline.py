"""Orchestration: per-paper state, resumable inventory/inspect passes, link discovery.

State lives in ``<out>/cache/state/{links,inventory,inspect}/<paper>.json`` and is
written after every resource, so an interrupted run resumes where it stopped:
re-running the same command skips completed resources (unless ``--refresh``)
and retries only transient failures.
"""

from __future__ import annotations

import json
import re
import threading
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

from lxml import etree

from . import evidence as ev
from . import links as lk
from .netcache import HttpClient, atomic_write, now_iso
from .providers import Config, inspect_record, inventory_link

RETRYABLE = {"rate_limited", "error", "cache_miss", "pending"}
TOOL_VERSION = "1.0"


class State:
    def __init__(self, cache_dir: Path):
        self.root = Path(cache_dir) / "state"
        self._lock = threading.Lock()

    def path(self, kind: str, paper: str) -> Path:
        return self.root / kind / f"{paper}.json"

    def load(self, kind: str, paper: str, default=None):
        p = self.path(kind, paper)
        if not p.exists():
            return {} if default is None else default
        return json.loads(p.read_text(encoding="utf-8"))

    def save(self, kind: str, paper: str, data) -> None:
        with self._lock:
            atomic_write(self.path(kind, paper), json.dumps(data, indent=1, ensure_ascii=False).encode("utf-8"))


# -- papers & links ------------------------------------------------------------------
def select_papers(grid_path: Path, wanted: list[str] | None) -> list[dict]:
    rows = lk.grid_rows(grid_path)
    if wanted:
        ids = {w.strip().upper() for item in wanted for w in item.split(",") if w.strip()}
        unknown = ids - {r["id"] for r in rows}
        if unknown:
            raise SystemExit(f"unknown paper id(s): {', '.join(sorted(unknown))}")
        rows = [r for r in rows if r["id"] in ids]
    return rows


def article_evidence(paper_id: str, tei_path: Path, repo_root: Path, max_per_topic: int = 6) -> list[dict]:
    """Keyword hits in the TEI running text (not the bibliography), located by TEI line."""
    root, _ = lk.parse_tei(tei_path)
    rel = tei_path.relative_to(repo_root).as_posix() if tei_path.is_relative_to(repo_root) else str(tei_path)
    counts: dict[str, int] = {}
    rows = []
    for p in root.iterfind(".//t:text//t:p", lk.NS):
        if any(etree.QName(a).localname == "listBibl" for a in p.iterancestors()):
            continue
        text = re.sub(r"\s+", " ", "".join(p.itertext())).strip()
        if not text:
            continue
        _, _, head = lk._location(p)
        for topic, patterns in ev.DOC_RULES.items():
            if counts.get(topic, 0) >= max_per_topic:
                continue
            m = next((m for pat in patterns if (m := pat.search(text))), None)
            if not m:
                continue
            counts[topic] = counts.get(topic, 0) + 1
            a, b = max(0, m.start() - 200), min(len(text), m.end() + 200)
            row = {
                "paper_id": paper_id,
                "link_id": None,
                "topic": topic,
                "volet": ev.TOPIC_VOLET[topic],
                "source_kind": "article_tei",
                "evidence_kind": "article_statement",
                "provider": "article",
                "resource_url": None,
                "version_ref": None,
                "path": rel,
                "location": f"section: {head}" if head else None,
                "line_start": p.sourceline,
                "line_end": p.sourceline,
                "permalink": None,
                "snippet": ("…" if a else "") + text[a:b] + ("…" if b < len(text) else ""),
                "matched_rule": m.group(0)[:80],
                "confidence": "keyword_match",
                "review_status": "pending",
            }
            row["evidence_id"] = ev.evidence_id(paper_id, "article", topic, rel, p.sourceline)
            rows.append(row)
    return rows


def build_paper_links(row: dict, ctx: dict) -> dict:
    stem = lk.tei_stem(row)
    tei_path = ctx["tei_dir"] / f"{stem}.tei.xml" if stem else None
    links: list[dict] = []
    paper_doi = None
    notes = []
    art_rows: list[dict] = []
    if tei_path and tei_path.exists():
        links, paper_doi = lk.extract_tei_links(row["id"], tei_path, ctx["repo_root"])
        art_rows = article_evidence(row["id"], tei_path, ctx["repo_root"])
    else:
        notes.append(f"TEI not found for {row['id']} (expected {tei_path})")
    grid_file = ctx["grid"].name
    extra = lk.grid_links(row, grid_file) + lk.seed_links(ctx["out"] / "seeds.tsv", row["id"])
    exclusions = {l["canonical"] for l in extra if l.get("role_guess") == "exclude"}
    merged = lk.dedupe(links + [l for l in extra if l.get("role_guess") != "exclude"])
    for l in merged:
        if l["canonical"] in exclusions:
            l["keep"], l["drop_reason"] = False, "manual_exclusion (seeds.tsv)"
    lk.assign_relations(merged)
    return {
        "paper_id": row["id"],
        "banque": row.get("banque_collection"),
        "tei_file": tei_path.relative_to(ctx["repo_root"]).as_posix() if tei_path and tei_path.exists() else None,
        "paper_doi": paper_doi,
        "links": merged,
        "article_evidence": art_rows,
        "notes": notes,
        "extracted_at": now_iso(),
    }


FOLLOWED_DEPOSITS = {"zenodo", "figshare", "dryad", "dataverse", "osf", "openml", "edi", "datacite"}
CONFIG_PATH_RE = re.compile(r"(^|/)\.github/|\.(ya?ml|toml|json|lock|cfg)$|(^|/)(renv|packrat)/", re.I)


def discovered_links(paper_id: str, inv: dict, insp: dict, known: dict[str, dict], max_depth: int) -> list[dict]:
    """Turn links found inside inventoried/inspected resources into new link dicts.

    Followed (inventoried, and inspected when the parent is a resource):
    data deposits, and code repositories whose owner also owns a resource
    (e.g. the project's R package). Links found in CI/config files and
    third-party code repositories are listed but not followed.
    """
    owners = {(l["extra"].get("owner") or l["extra"].get("pages_owner") or "").lower() for l in known.values() if l.get("relation") == "resource"} - {""}
    # A renamed GitHub repository answers under its new name: map it to the
    # canonical already inventoried so it is not audited twice.
    aliases = {f"github.com/{r['full_name']}".lower(): c for c, r in inv.items() if r.get("full_name")}
    out: list[dict] = []
    for canonical, rec in inv.items():
        found = list(rec.get("discovered", [])) + list((insp.get(canonical) or {}).get("discovered", []))
        for d in found:
            if CONFIG_PATH_RE.search(d.get("via") or ""):
                continue
            try:
                info = lk.classify(doi=d["value"]) if d["kind"] == "doi" else lk.classify(url=d["value"])
            except Exception:
                continue
            key = aliases.get(info["canonical"], info["canonical"])
            if key in known:
                target = known[key]
                tag = f"discovered:{canonical}"
                if tag not in target["also_found_in"] and target.get("parent") != canonical:
                    target["also_found_in"].append(tag)
                continue
            depth = rec.get("depth", 0) + 1
            link = lk.make_link(paper_id, info, found_in="discovered", source_file=f"{rec['url']} :: {d['via']}", source_line=d.get("line"), context=d["value"], raw=d["value"], depth=depth, parent=canonical)
            # One hop away from the paper: may be the project's own deposit or an
            # upstream source; inspected, but never counted in the comparison.
            link["relation"] = "linked_from_resource" if rec.get("relation") in {"resource", "linked_from_resource"} else "cited_deposit"
            same_owner = (info["extra"].get("owner") or "").lower() in owners
            is_archive = info["provider"] == "web" and ev.ARCHIVE_PATH_RE.search(info["url"].split("?")[0])
            if info["provider"] not in FOLLOWED_DEPOSITS and not same_owner and not is_archive:
                link["keep"], link["drop_reason"] = False, "discovered_third_party_repository_not_followed"
            elif depth > max_depth:
                link["keep"], link["drop_reason"] = False, f"not_followed_depth_limit (depth {depth} > {max_depth})"
            known[key] = link
            out.append(link)
    return out


# -- commands ------------------------------------------------------------------------
class Auditor:
    def __init__(self, ctx: dict, cfg: Config, http: HttpClient, workers: int, providers: set[str] | None, max_depth: int, inspect_cited: bool, log=print, redo: bool = False):
        self.ctx, self.cfg, self.http = ctx, cfg, http
        self.workers = max(1, workers)
        self.providers = providers
        self.max_depth = max_depth
        self.inspect_cited = inspect_cited
        self.state = State(cfg.cache_dir)
        self.log = log
        self.redo = redo
        self._cleared: set[str] = set()

    def _clear_once(self, paper: str) -> None:
        """--redo: forget the derived state of a paper (the HTTP cache is kept)."""
        if self.redo and paper not in self._cleared:
            for kind in ("links", "inventory", "inspect"):
                self.state.path(kind, paper).unlink(missing_ok=True)
            self._cleared.add(paper)

    def _wanted(self, link: dict) -> bool:
        if not link["keep"]:
            return False
        if self.providers and link["provider"] not in self.providers:
            return False
        return True

    def paper_links(self, row: dict) -> dict:
        data = build_paper_links(row, self.ctx)
        # Discovered links are re-derived from the inventory/inspect state every time.
        known = {l["canonical"]: l for l in data["links"]}
        inv = self.state.load("inventory", row["id"])
        insp = self.state.load("inspect", row["id"])
        data["links"] += discovered_links(row["id"], inv, insp, known, self.max_depth)
        self.state.save("links", row["id"], data)
        return data

    def inventory(self, rows: list[dict]) -> int:
        todo = []
        for row in rows:
            self._clear_once(row["id"])
            data = self.paper_links(row)
            inv = self.state.load("inventory", row["id"])
            for link in data["links"]:
                if not self._wanted(link):
                    continue
                prev = inv.get(link["canonical"])
                if prev and prev["status"] not in RETRYABLE and not self.cfg.refresh:
                    continue
                todo.append(link)
        self.log(f"inventory: {len(todo)} resource(s) to query")
        done = 0

        def work(link):
            rec = inventory_link(link, self.http, self.cfg)
            rec["found_in"] = link["found_in"]
            return link, rec

        with ThreadPoolExecutor(self.workers) as pool:
            for fut in as_completed([pool.submit(work, l) for l in todo]):
                link, rec = fut.result()  # results are merged in this (main) thread only
                inv = self.state.load("inventory", link["paper_id"])
                inv[link["canonical"]] = rec
                self.state.save("inventory", link["paper_id"], inv)
                done += 1
                self.log(f"  [{done}/{len(todo)}] {link['paper_id']} {rec['provider']:<9} {rec['status']:<12} {link['canonical']}")
        return len(todo)

    def inspect(self, rows: list[dict]) -> int:
        todo = []
        for row in rows:
            links = {l["canonical"]: l for l in self.state.load("links", row["id"]).get("links", [])}
            inv = self.state.load("inventory", row["id"])
            insp = self.state.load("inspect", row["id"])
            for canonical, rec in inv.items():
                link = links.get(canonical)
                if link is None or not self._wanted(link):
                    continue
                rec["relation"] = link.get("relation")
                if rec["relation"] not in {"resource", "linked_from_resource"} and not self.inspect_cited:
                    continue
                prev = insp.get(canonical)
                if prev and prev.get("version_ref") == rec.get("version_ref") and not self.cfg.refresh and prev.get("complete"):
                    continue
                todo.append((row["id"], canonical, rec))
        self.log(f"inspect: {len(todo)} resource(s) to read")
        done = 0

        def work(item):
            paper, canonical, rec = item
            result = inspect_record(rec, self.http, self.cfg)
            result["version_ref"] = rec.get("version_ref")
            result["complete"] = not any("offline cache miss" in l.get("status", "") or "rate limited" in l.get("status", "") for l in result["files_log"])
            result["archives"] = rec.get("archives", {})
            return paper, canonical, result

        with ThreadPoolExecutor(self.workers) as pool:
            for fut in as_completed([pool.submit(work, t) for t in todo]):
                paper, canonical, result = fut.result()
                insp = self.state.load("inspect", paper)
                insp[canonical] = result
                self.state.save("inspect", paper, insp)
                done += 1
                n_read = sum(1 for l in result["files_log"] if l.get("status") == "read" or "zip listed" in l.get("status", ""))
                self.log(f"  [{done}/{len(todo)}] {paper} {canonical}: {n_read} file(s) read, {len(result['evidence'])} evidence row(s), {len(result['discovered'])} link(s) discovered")
        return len(todo)

    def run(self, rows: list[dict]) -> None:
        for round_ in range(self.max_depth + 1):
            self.log(f"== round {round_}")
            n_inv = self.inventory(rows)
            n_insp = self.inspect(rows)
            if round_ > 0 and n_inv == 0 and n_insp == 0:
                break

    def save_run_meta(self, command: str, argv: list[str]) -> None:
        meta = self.state.load("meta", "runs", default={"runs": []})
        meta["runs"].append({
            "at": now_iso(),
            "command": command,
            "argv": argv,
            "tool_version": TOOL_VERSION,
            "network_calls": self.http.network_calls,
            "blocked_hosts": self.http.blocked_hosts,
            "config": {k: (str(v) if isinstance(v, Path) else v) for k, v in vars(self.cfg).items()},
        })
        meta["runs"] = meta["runs"][-50:]
        self.state.save("meta", "runs", meta)
