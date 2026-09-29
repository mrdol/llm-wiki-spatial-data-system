"""Provider adapters: ``inventory`` (metadata + file tree) and ``inspect``
(targeted reading of small text files).

Inventory never downloads data files. Inspect downloads only files whose
size is known to be below ``max_file_bytes`` (or, for Git fallbacks, reads
single blobs), lists ZIP archives through HTTP Range requests, and stops once
``max_repo_bytes`` have been fetched for one resource. Nothing is executed.
"""

from __future__ import annotations

import os
import re
import shutil
import stat
import subprocess
import zlib
from dataclasses import dataclass
from pathlib import Path
from urllib.parse import quote, urlsplit

from . import evidence as ev
from . import remotezip
from .links import DOI_RE, REPOSITORY_PROVIDERS, classify, clean_doi, links_in_text
from .netcache import (
    HttpClient,
    HttpRangeFile,
    NoRangeSupport,
    OfflineCacheMiss,
    RangeBudgetExceeded,
    RateLimited,
    now_iso,
)

GH_ACCEPT = {"Accept": "application/vnd.github+json"}
TAR_PREFIX_BYTES = 4 * 1024 * 1024  # gzip cannot be read at random offsets: list what the first MB contain
MAX_TREE_ENTRIES = 200_000
MAX_DISCOVERED_PER_RESOURCE = 30


@dataclass
class Config:
    cache_dir: Path
    max_file_bytes: int = 2 * 1024 * 1024
    max_repo_bytes: int = 50 * 1024 * 1024
    max_files: int = 150
    allow_clone: bool = True
    offline: bool = False
    refresh: bool = False


# -- records ----------------------------------------------------------------------
def base_record(link: dict) -> dict:
    return {
        "link_id": link["link_id"],
        "paper_id": link["paper_id"],
        "canonical": link["canonical"],
        "url": link["url"],
        "doi": link.get("doi"),
        "provider": link["provider"],
        "relation": link.get("relation"),
        "role_guess": link.get("role_guess"),
        "depth": link.get("depth", 0),
        "status": "pending",
        "http_status": None,
        "resolved_url": None,
        "access_mode": None,
        "title": None,
        "description": None,
        "license": None,
        "version_ref": None,
        "version_kind": None,
        "version_date": None,
        "files": [],
        "files_complete": None,
        "releases": [],
        "tags": [],
        "archives": {},
        "discovered": [],
        "metadata_evidence": [],
        "api_sources": [],
        "notes": list(link.get("notes") or []),
        "focus_paths": list(link.get("focus_paths") or []),
        "inventoried_at": now_iso(),
    }


def status_from_http(code: int | None) -> str:
    if code is None:
        return "error"
    if 200 <= code < 300:
        return "ok"
    if code in (404, 410):
        return "dead"
    if code in (401, 403):
        return "denied"
    return "error"


def fetch_json(http: HttpClient, url: str, rec: dict, *, headers: dict | None = None, primary: bool = False):
    """GET JSON; on failure record status (only when ``primary``) and return None."""
    resp = http.get(url, headers=headers)
    rec["api_sources"].append({"url": url, "status": resp.status, "from_cache": resp.from_cache, "at": resp.fetched_at})
    if primary:
        rec["http_status"] = resp.status
    if not resp.ok:
        if primary:
            rec["status"] = status_from_http(resp.status)
            if resp.error:
                rec["notes"].append(resp.error)
            elif resp.status in (401, 403):
                rec["notes"].append(f"access denied ({resp.status}): {resp.text()[:160]}")
        return None
    try:
        return resp.json()
    except ValueError:
        if primary:
            rec["status"] = "error"
            rec["notes"].append(f"non-JSON answer from {url}")
        return None


def meta_row(rec: dict, topic: str, field: str, value, source: str) -> None:
    if value in (None, "", [], {}):
        return
    rec["metadata_evidence"].append(
        {"topic": topic, "field": field, "value": value if isinstance(value, (str, int, float)) else str(value)[:500], "source": source}
    )


def add_discovered(rec: dict, kind: str, value: str, via: str, line: int | None = None) -> None:
    if len(rec["discovered"]) >= MAX_DISCOVERED_PER_RESOURCE:
        return
    try:
        info = classify(doi=value) if kind == "doi" else classify(url=value)
    except Exception:
        return
    # Besides repositories, direct links to archives (e.g. a "download all
    # tasks" tar.gz on a lab server) are kept: they are published files.
    is_archive = info["provider"] == "web" and ev.ARCHIVE_PATH_RE.search(urlsplit(info["url"]).path or "")
    if (info["provider"] not in REPOSITORY_PROVIDERS and not is_archive) or info["canonical"] == rec["canonical"]:
        return
    if any(d["canonical"] == info["canonical"] for d in rec["discovered"]):
        return
    rec["discovered"].append({"canonical": info["canonical"], "kind": kind, "value": value, "via": via, "line": line})


def summarise_files(rec: dict) -> None:
    files = rec["files"]
    sizes = [f.get("size") for f in files if f.get("size") is not None]
    rec["n_files"] = len(files)
    rec["total_bytes"] = sum(sizes) if sizes and len(sizes) == len(files) else (sum(sizes) if sizes else None)
    rec["sizes_complete"] = bool(files) and len(sizes) == len(files)
    formats: dict[str, dict] = {}
    for f in files:
        ext = ev.suffix(f["path"]) or "(none)"
        slot = formats.setdefault(ext, {"n": 0, "bytes": 0})
        slot["n"] += 1
        slot["bytes"] += f.get("size") or 0
    rec["formats"] = dict(sorted(formats.items(), key=lambda kv: (-kv[1]["bytes"], -kv[1]["n"]))[:15])
    if sizes:
        big = max((f for f in files if f.get("size") is not None), key=lambda f: f["size"])
        rec["largest_file"] = {"path": big["path"], "size": big["size"]}
    if files:
        meta_row(rec, "downloadable_files", "n_files/total_bytes", f"{len(files)} files, {rec['total_bytes']} bytes (sizes complete: {rec['sizes_complete']})", rec["api_sources"][-1]["url"] if rec["api_sources"] else rec["url"])
    presence = [f["path"] for f in files if ev.priority(f["path"], f.get("size")) >= 95 or ".github/workflows" in f["path"]]
    rec["key_files_present"] = presence[:40]


# -- git fallback -----------------------------------------------------------------
def _safe(name: str) -> str:
    return re.sub(r"[^A-Za-z0-9._-]+", "_", name)[:120]


def _git(args: list[str], cwd: Path | None = None, timeout: int = 600) -> subprocess.CompletedProcess:
    env = {**os.environ, "GIT_LFS_SKIP_SMUDGE": "1", "GIT_TERMINAL_PROMPT": "0"}
    return subprocess.run(["git", "-c", "core.longpaths=true", *args], cwd=cwd, env=env, capture_output=True, timeout=timeout)


def _rmtree(path: Path) -> None:
    def onerror(func, p, _exc):
        os.chmod(p, stat.S_IWRITE)
        func(p)

    shutil.rmtree(path, onerror=onerror)


def clone_partial(clone_url: str, rec: dict, cfg: Config) -> Path | None:
    """Blobless, checkout-free, depth-1 clone: trees and commit only, no file contents, no LFS."""
    dest = cfg.cache_dir / "git" / _safe(rec["canonical"])
    if dest.exists() and cfg.refresh and not cfg.offline:
        _rmtree(dest)
    if not dest.exists():
        if cfg.offline:
            raise OfflineCacheMiss(clone_url)
        dest.parent.mkdir(parents=True, exist_ok=True)
        proc = _git(["clone", "--filter=blob:none", "--no-checkout", "--depth", "1", "--quiet", clone_url, str(dest)])
        if proc.returncode != 0:
            rec["notes"].append("git clone failed: " + proc.stderr.decode("utf-8", "replace")[:300])
            if dest.exists():
                _rmtree(dest)
            return None
    rec["access_mode"] = "git_partial_clone"
    sha = _git(["rev-parse", "HEAD"], cwd=dest).stdout.decode().strip()
    date = _git(["log", "-1", "--format=%cI"], cwd=dest).stdout.decode().strip()
    names = _git(["ls-tree", "-r", "--name-only", "-z", "HEAD"], cwd=dest).stdout.decode("utf-8", "replace").split("\0")
    rec["version_ref"], rec["version_kind"], rec["version_date"] = sha or None, "commit", date or None
    rec["files"] = [{"path": n, "size": None} for n in names if n][:MAX_TREE_ENTRIES]
    rec["files_complete"] = True
    if not cfg.offline:
        tags = _git(["ls-remote", "--tags", clone_url], timeout=120).stdout.decode("utf-8", "replace").splitlines()
        rec["tags"] = sorted({t.split("refs/tags/")[-1].removesuffix("^{}") for t in tags if "refs/tags/" in t})[:200]
    rec["notes"].append("file sizes unknown in git fallback (reading them would fetch blobs)")
    return dest


def git_reader(dest: Path):
    def read(path: str, _size, max_bytes: int):
        proc = _git(["show", f"HEAD:{path}"], cwd=dest, timeout=300)
        if proc.returncode != 0:
            return None, "git show failed"
        data = proc.stdout
        if len(data) > max_bytes:
            return None, f"too large after fetch ({len(data)} bytes)"
        return data, None

    return read


# -- GitHub -----------------------------------------------------------------------
def inventory_github(link: dict, http: HttpClient, cfg: Config) -> dict:
    rec = base_record(link)
    owner, repo = link["extra"]["owner"], link["extra"]["repo"]
    try:
        meta = fetch_json(http, f"https://api.github.com/repos/{owner}/{repo}", rec, headers=GH_ACCEPT, primary=True)
        if meta is None:
            return rec
        full = meta["full_name"]
        if full.lower() != f"{owner}/{repo}".lower():
            rec["notes"].append(f"repository renamed/moved to {full}")
        rec.update(
            title=full,
            description=meta.get("description"),
            license=(meta.get("license") or {}).get("spdx_id"),
            default_branch=meta.get("default_branch"),
            repo_size_kb=meta.get("size"),
            archived=meta.get("archived"),
            created_at=meta.get("created_at"),
            pushed_at=meta.get("pushed_at"),
            homepage=meta.get("homepage"),
            resolved_url=meta.get("html_url"),
            full_name=full,
            access_mode="github_api",
        )
        api = f"https://api.github.com/repos/{full}"
        meta_row(rec, "license_citation", "license.spdx_id (GitHub API)", rec["license"], api)
        meta_row(rec, "versioning_maintenance", "created_at / pushed_at / archived", f"created {meta.get('created_at')}, last push {meta.get('pushed_at')}, archived={meta.get('archived')}", api)
        if meta.get("homepage"):
            add_discovered(rec, "url", meta["homepage"], "github_api:homepage")
        commits = fetch_json(http, f"{api}/commits?sha={quote(meta['default_branch'])}&per_page=1", rec, headers=GH_ACCEPT)
        if commits:
            rec["version_ref"] = commits[0]["sha"]
            rec["version_kind"] = "commit"
            rec["version_date"] = commits[0]["commit"]["committer"]["date"]
        if rec["version_ref"]:
            tree = fetch_json(http, f"{api}/git/trees/{rec['version_ref']}?recursive=1", rec, headers=GH_ACCEPT)
            if tree:
                rec["files"] = [{"path": e["path"], "size": e.get("size")} for e in tree.get("tree", []) if e.get("type") == "blob"][:MAX_TREE_ENTRIES]
                rec["files_complete"] = not tree.get("truncated", False)
                if tree.get("truncated"):
                    rec["notes"].append("GitHub tree listing truncated by the API")
        releases = fetch_json(http, f"{api}/releases?per_page=100", rec, headers=GH_ACCEPT) or []
        rec["releases"] = [{"tag": r.get("tag_name"), "name": r.get("name"), "published_at": r.get("published_at")} for r in releases]
        tags = fetch_json(http, f"{api}/tags?per_page=100", rec, headers=GH_ACCEPT) or []
        rec["tags"] = [t.get("name") for t in tags]
        meta_row(rec, "versioning_maintenance", "releases/tags (GitHub API)", f"{len(rec['releases'])} releases, {len(rec['tags'])} tags" + (f"; latest release {rec['releases'][0]['tag']} ({rec['releases'][0]['published_at']})" if rec["releases"] else ""), f"{api}/releases")
        rec["status"] = "ok"
    except RateLimited as exc:
        rec["notes"].append(f"GitHub API rate limited (reset {exc.reset}); falling back to partial git clone")
        if cfg.allow_clone:
            if clone_partial(f"https://github.com/{owner}/{repo}.git", rec, cfg):
                rec["status"] = "ok"
                rec["full_name"] = f"{owner}/{repo}"
            else:
                rec["status"] = "rate_limited"
        else:
            rec["status"] = "rate_limited"
    summarise_files(rec)
    return rec


def github_reader(rec: dict, http: HttpClient, cfg: Config):
    if rec.get("access_mode") == "git_partial_clone":
        return git_reader(cfg.cache_dir / "git" / _safe(rec["canonical"]))
    full, sha = rec["full_name"], rec["version_ref"]

    def read(path: str, size, max_bytes: int):
        resp = http.get(f"https://raw.githubusercontent.com/{full}/{sha}/{quote(path)}", max_bytes=max_bytes)
        if not resp.ok:
            return None, f"HTTP {resp.status}"
        if resp.truncated:
            return None, "exceeds max file size"
        return resp.content, None

    return read


def github_permalink(rec: dict, path: str, a: int | None, b: int | None) -> str:
    base = f"https://github.com/{rec.get('full_name') or rec['canonical'].split('/', 1)[1]}/blob/{rec['version_ref']}/{quote(path)}"
    return f"{base}#L{a}-L{b}" if a else base


# -- GitLab -----------------------------------------------------------------------
def inventory_gitlab(link: dict, http: HttpClient, cfg: Config) -> dict:
    rec = base_record(link)
    host, project = link["extra"]["host"], link["extra"]["project"]
    api = f"https://{host}/api/v4/projects/{quote(project, safe='')}"
    try:
        meta = fetch_json(http, api, rec, primary=True)
        if meta is None:
            if rec["status"] in ("denied", "error") and cfg.allow_clone and clone_partial(f"https://{host}/{project}.git", rec, cfg):
                rec["status"] = "ok"
            summarise_files(rec)
            return rec
        pid = meta["id"]
        rec.update(
            title=meta.get("path_with_namespace"),
            description=meta.get("description"),
            license=(meta.get("license") or {}).get("key") if isinstance(meta.get("license"), dict) else None,
            resolved_url=meta.get("web_url"),
            gitlab_id=pid,
            access_mode="gitlab_api",
            pushed_at=meta.get("last_activity_at"),
        )
        branch = meta.get("default_branch") or "main"
        commit = fetch_json(http, f"https://{host}/api/v4/projects/{pid}/repository/commits/{quote(branch, safe='')}", rec)
        if commit:
            rec["version_ref"], rec["version_kind"], rec["version_date"] = commit["id"], "commit", commit.get("committed_date")
            files, page = [], 1
            while page and page <= 50:
                resp = http.get(f"https://{host}/api/v4/projects/{pid}/repository/tree?recursive=true&per_page=100&page={page}&ref={commit['id']}")
                if not resp.ok:
                    break
                files += [{"path": e["path"], "size": None} for e in resp.json() if e.get("type") == "blob"]
                nxt = resp.headers.get("x-next-page") or ""
                page = int(nxt) if nxt.isdigit() else (page + 1 if len(resp.json()) == 100 else 0)
            rec["files"], rec["files_complete"] = files, page == 0
        rel = fetch_json(http, f"https://{host}/api/v4/projects/{pid}/releases", rec) or []
        rec["releases"] = [{"tag": r.get("tag_name"), "name": r.get("name"), "published_at": r.get("released_at")} for r in rel]
        tags = fetch_json(http, f"https://{host}/api/v4/projects/{pid}/repository/tags", rec) or []
        rec["tags"] = [t.get("name") for t in tags]
        rec["status"] = "ok"
    except RateLimited as exc:
        rec["status"] = "rate_limited"
        rec["notes"].append(str(exc))
    summarise_files(rec)
    return rec


def gitlab_reader(rec: dict, http: HttpClient, cfg: Config):
    if rec.get("access_mode") == "git_partial_clone":
        return git_reader(cfg.cache_dir / "git" / _safe(rec["canonical"]))
    host = urlsplit(rec["url"]).netloc

    def read(path: str, size, max_bytes: int):
        resp = http.get(f"https://{host}/api/v4/projects/{rec['gitlab_id']}/repository/files/{quote(path, safe='')}/raw?ref={rec['version_ref']}", max_bytes=max_bytes)
        if not resp.ok:
            return None, f"HTTP {resp.status}"
        if resp.truncated:
            return None, "exceeds max file size"
        return resp.content, None

    return read


# -- DOI resolution / DataCite -----------------------------------------------------
def resolve_handle(http: HttpClient, doi: str, rec: dict) -> str | None:
    data = fetch_json(http, f"https://doi.org/api/handles/{doi}", rec)
    if not data:
        return None
    for value in data.get("values", []):
        if value.get("type") == "URL":
            return value["data"]["value"]
    return None


def datacite_into(rec: dict, http: HttpClient, doi: str) -> dict | None:
    """Fill ``rec`` from DataCite; returns the attributes or None (not a DataCite DOI)."""
    api = f"https://api.datacite.org/dois/{quote(doi, safe='/')}"
    data = fetch_json(http, api, rec)
    if not data:
        return None
    a = data["data"]["attributes"]
    rec["title"] = rec["title"] or ((a.get("titles") or [{}])[0].get("title"))
    rec["publisher"] = a.get("publisher") if isinstance(a.get("publisher"), str) else (a.get("publisher") or {}).get("name")
    rec["version_ref"] = rec["version_ref"] or f"doi:{doi}"
    rec["version_kind"] = rec["version_kind"] or "doi"
    rec["version_date"] = rec["version_date"] or str(a.get("publicationYear") or "") or None
    rights = [r.get("rightsIdentifier") or r.get("rights") for r in a.get("rightsList", [])]
    rec["license"] = rec["license"] or ("; ".join(r for r in rights if r) or None)
    descriptions = [d.get("description", "") for d in a.get("descriptions", []) if d.get("description")]
    rec["datacite_descriptions"] = descriptions
    rec["description"] = rec["description"] or (descriptions[0][:500] if descriptions else None)
    meta_row(rec, "license_citation", "rightsList (DataCite)", rec["license"], api)
    meta_row(rec, "versioning_maintenance", "version (DataCite)", a.get("version"), api)
    meta_row(rec, "downloadable_files", "sizes/formats (DataCite)", "; ".join((a.get("sizes") or []) + (a.get("formats") or [])), api)
    meta_row(rec, "license_citation", "publisher / publicationYear (DataCite)", f"{rec['publisher']} {a.get('publicationYear')}", api)
    for rel in a.get("relatedIdentifiers", []):
        kind = rel.get("relatedIdentifierType")
        value = rel.get("relatedIdentifier", "")
        rec.setdefault("related_identifiers", []).append(f"{rel.get('relationType')}:{kind}:{value}")
        if rel.get("relationType") in {"IsCitedBy", "References", "Cites"}:
            continue
        if kind == "DOI":
            add_discovered(rec, "doi", value, f"datacite:{rel.get('relationType')}")
        elif kind == "URL":
            add_discovered(rec, "url", value, f"datacite:{rel.get('relationType')}")
    rec["landing_url"] = a.get("url")
    return a


def inventory_gigadb(rec: dict, http: HttpClient, landing: str) -> None:
    m = re.search(r"/dataset/(?:view/id/)?(\d+)", landing)
    if not m:
        return
    api = f"https://gigadb.org/api/dataset?doi={m.group(1)}"
    data = fetch_json(http, api, rec)
    if not data:
        return
    d = data.get("data", {})
    ds = d.get("dataset", {})
    rec["access_mode"] = "gigadb_api"
    rec["description"] = ds.get("description") or rec["description"]
    rec["gigadb_description"] = ds.get("description")
    files = []
    for f in d.get("files", []) or []:
        files.append({"path": f.get("file_name"), "size": f.get("file_size"), "url": f.get("url"), "data_type": f.get("data_type"), "file_description": f.get("description")})
        if f.get("url") and (f.get("data_type") or "").lower() == "external link":
            add_discovered(rec, "url", f["url"], "gigadb:external_link")
    rec["files"], rec["files_complete"] = files, True
    external = [f for f in files if (f.get("data_type") or "").lower() == "external link"]
    if external:
        rec["notes"].append(f"{len(external)} GigaDB entries are external links (data hosted elsewhere)")
    for h in d.get("histories", []) or []:
        meta_row(rec, "versioning_maintenance", "history (GigaDB)", f"{h.get('created_at', '')} {h.get('message', '')}"[:300], api)


def inventory_doi(link: dict, http: HttpClient, cfg: Config) -> dict:
    """Generic DOI: DataCite first, then dispatch on the landing page host."""
    rec = base_record(link)
    doi = link["doi"]
    try:
        attrs = datacite_into(rec, http, doi)
        landing = rec.get("landing_url") or resolve_handle(http, doi, rec)
        rec["resolved_url"] = landing
        if attrs is None and landing is None:
            rec["status"] = "dead"
            rec["notes"].append("DOI unknown to DataCite and to the DOI handle system")
            return rec
        if attrs is None:
            rec["provider"] = "doi_non_datacite"
            rec["notes"].append("not a DataCite DOI (article or Crossref DOI): landing page checked only")
        if landing:
            target = classify(url=landing)
            if target["provider"] in {"github", "gitlab", "zenodo", "figshare", "osf", "openml"}:
                sub = inventory_link({**link, **{k: target[k] for k in ("provider", "extra")}, "doi": None, "url": target["url"]}, http, cfg)
                sub.update(canonical=rec["canonical"], doi=doi, via_doi_provider=target["provider"])
                for key in ("title", "license", "description"):
                    sub[key] = sub.get(key) or rec.get(key)
                sub["metadata_evidence"] = rec["metadata_evidence"] + sub["metadata_evidence"]
                sub["api_sources"] = rec["api_sources"] + sub["api_sources"]
                return sub
            host = urlsplit(landing).netloc.lower()
            if "gigadb.org" in host:
                inventory_gigadb(rec, http, landing)
            page = http.get(landing, max_bytes=512 * 1024)
            rec["api_sources"].append({"url": landing, "status": page.status, "from_cache": page.from_cache, "at": page.fetched_at})
            rec["landing_status"] = page.status
            rec["landing_final_url"] = page.final_url
            if page.ok and "html" in page.headers.get("content-type", ""):
                title = re.search(r"(?is)<title[^>]*>(.*?)</title>", page.text())
                rec["landing_title"] = re.sub(r"\s+", " ", title.group(1)).strip()[:200] if title else None
                if rec["landing_title"] and re.search(r"\blog ?in\b|sign ?in", rec["landing_title"], re.I):
                    rec["notes"].append(f"landing page requires login: {rec['landing_title']}")
        rec["status"] = "ok" if attrs is not None or (rec.get("landing_status") and 200 <= rec["landing_status"] < 400) else status_from_http(rec.get("landing_status"))
    except RateLimited as exc:
        rec["status"] = "rate_limited"
        rec["notes"].append(str(exc))
    summarise_files(rec)
    return rec


def inventory_edi(link: dict, http: HttpClient, cfg: Config) -> dict:
    """EDI: DataCite metadata + an attempt on PASTA (public access currently refused)."""
    rec = inventory_doi({**link, "provider": "edi"}, http, cfg) if link.get("doi") else base_record(link)
    rec["provider"] = "edi"
    landing = rec.get("resolved_url") or link["url"]
    from .links import edi_package_from_url

    ids = edi_package_from_url(landing or "")
    if ids:
        scope, ident, rev = ids
        rec["edi_package"] = f"{scope}.{ident}.{rev}"
        rec["version_ref"] = f"{rec['edi_package']} ({rec['version_ref']})" if rec.get("version_ref") else rec["edi_package"]
        rec["version_kind"] = "edi_revision"
        probe = http.get(f"https://pasta.lternet.edu/package/metadata/eml/{scope}/{ident}/{rev}", max_bytes=rec_max(cfg))
        rec["api_sources"].append({"url": probe.final_url, "status": probe.status, "from_cache": probe.from_cache, "at": probe.fetched_at})
        if probe.ok:
            rec["eml_url"] = probe.final_url
            rec["access_mode"] = "pasta_api"
        else:
            rec["access_mode"] = "datacite_only"
            rec["notes"].append(f"PASTA refused EML/file listing ({probe.status}): {probe.text()[:140]}")
            rec["files_complete"] = False
        if rec["status"] == "pending":
            rec["status"] = "ok" if probe.ok else status_from_http(probe.status)
    elif link.get("doi") and rec["status"] != "ok":
        rec["notes"].append("EDI DOI did not resolve to a package (possibly truncated DOI)")
    return rec


def rec_max(cfg: Config) -> int:
    return max(cfg.max_file_bytes, 5 * 1024 * 1024)


# -- Zenodo / Figshare / Dryad / Dataverse / OSF / OpenML ----------------------------
def inventory_zenodo(link: dict, http: HttpClient, cfg: Config) -> dict:
    rec = base_record(link)
    rid = link["extra"].get("record_id")
    try:
        if not rid and link.get("doi"):
            landing = resolve_handle(http, link["doi"], rec) or ""
            m = re.search(r"/records?/(\d+)", landing)
            rid = m.group(1) if m else None
        if not rid:
            rec["status"] = "error"
            rec["notes"].append("could not determine the Zenodo record id")
            return rec
        j = fetch_json(http, f"https://zenodo.org/api/records/{rid}", rec, primary=True)
        if j is None:
            return rec
        md = j.get("metadata", {})
        lic = md.get("license")
        rec.update(
            title=md.get("title"),
            description=md.get("description"),
            license=lic.get("id") if isinstance(lic, dict) else lic,
            version_ref=f"doi:{j.get('doi')}" if j.get("doi") else f"zenodo:{rid}",
            version_kind="doi_version",
            version_date=md.get("publication_date"),
            zenodo_version=md.get("version"),
            concept_doi=j.get("conceptdoi"),
            resolved_url=(j.get("links") or {}).get("html"),
            access_mode="zenodo_api",
        )
        files = []
        for f in j.get("files", []) or []:
            url = (f.get("links") or {}).get("self") or (f.get("links") or {}).get("content")
            files.append({"path": f.get("key") or f.get("filename"), "size": f.get("size"), "url": url})
        rec["files"], rec["files_complete"] = files, True
        api = f"https://zenodo.org/api/records/{rid}"
        meta_row(rec, "license_citation", "license (Zenodo)", rec["license"], api)
        meta_row(rec, "versioning_maintenance", "version / concept DOI (Zenodo)", f"version={md.get('version')} conceptdoi={j.get('conceptdoi')}", api)
        for rel in md.get("related_identifiers", []) or []:
            ident = rel.get("identifier", "")
            add_discovered(rec, "doi" if DOI_RE.match(ident) else "url", ident, f"zenodo:{rel.get('relation')}")
        rec["status"] = "ok"
    except RateLimited as exc:
        rec["status"] = "rate_limited"
        rec["notes"].append(str(exc))
    summarise_files(rec)
    return rec


def inventory_figshare(link: dict, http: HttpClient, cfg: Config) -> dict:
    rec = base_record(link)
    aid, ver = link["extra"].get("article_id"), link["extra"].get("version")
    try:
        api = f"https://api.figshare.com/v2/articles/{aid}" + (f"/versions/{ver}" if ver else "")
        j = fetch_json(http, api, rec, primary=True)
        if j is None:
            return rec
        lic = j.get("license") or {}
        rec.update(
            title=j.get("title"),
            description=j.get("description"),
            license=lic.get("name"),
            version_ref=f"figshare:{aid} v{j.get('version')}",
            version_kind="figshare_version",
            version_date=j.get("published_date"),
            resolved_url=j.get("url_public_html") or j.get("figshare_url"),
            access_mode="figshare_api",
        )
        rec["files"] = [
            {"path": f.get("name"), "size": f.get("size"), "url": f.get("download_url"), "md5": f.get("computed_md5"), "link_only": f.get("is_link_only")}
            for f in j.get("files", []) or []
        ]
        rec["files_complete"] = True
        meta_row(rec, "license_citation", "license (Figshare)", rec["license"], api)
        meta_row(rec, "license_citation", "citation (Figshare)", j.get("citation"), api)
        versions = fetch_json(http, f"https://api.figshare.com/v2/articles/{aid}/versions", rec) or []
        rec["releases"] = [{"tag": f"v{v.get('version')}", "name": None, "published_at": None} for v in versions]
        meta_row(rec, "versioning_maintenance", "versions (Figshare)", f"{len(versions)} version(s); inspected v{j.get('version')}", f"https://api.figshare.com/v2/articles/{aid}/versions")
        for ref in j.get("references", []) or []:
            add_discovered(rec, "url", ref, "figshare:references")
        rec["status"] = "ok"
    except RateLimited as exc:
        rec["status"] = "rate_limited"
        rec["notes"].append(str(exc))
    summarise_files(rec)
    return rec


def inventory_dryad(link: dict, http: HttpClient, cfg: Config) -> dict:
    rec = base_record(link)
    doi = link["doi"]
    api = f"https://datadryad.org/api/v2/datasets/{quote('doi:' + doi, safe='')}"
    try:
        j = fetch_json(http, api, rec, primary=True)
        if j is None:
            return rec
        rec.update(
            title=j.get("title"),
            description=j.get("abstract"),
            license=j.get("license"),
            version_ref=f"doi:{doi} (version {j.get('versionNumber')})",
            version_kind="dryad_version",
            version_date=j.get("publicationDate"),
            access_mode="dryad_api",
        )
        meta_row(rec, "license_citation", "license (Dryad)", rec["license"], api)
        vlink = ((j.get("_links") or {}).get("stash:version") or {}).get("href")
        if vlink:
            fj = fetch_json(http, f"https://datadryad.org{vlink}/files", rec) or {}
            files = (fj.get("_embedded") or {}).get("stash:files", [])
            rec["files"] = [{"path": f.get("path"), "size": f.get("size"), "url": "https://datadryad.org" + ((f.get("_links") or {}).get("stash:download") or {}).get("href", "")} for f in files]
            rec["files_complete"] = (fj.get("total") or len(files)) == len(files)
        rec["status"] = "ok"
    except RateLimited as exc:
        rec["status"] = "rate_limited"
        rec["notes"].append(str(exc))
    summarise_files(rec)
    return rec


def inventory_dataverse(link: dict, http: HttpClient, cfg: Config) -> dict:
    rec = base_record(link)
    doi = link["doi"]
    host = link["extra"].get("host")
    try:
        if not host:
            landing = resolve_handle(http, doi, rec) or ""
            host = urlsplit(landing).netloc or "dataverse.harvard.edu"
        api = f"https://{host}/api/datasets/:persistentId/?persistentId=doi:{doi}"
        j = fetch_json(http, api, rec, primary=True)
        if j is None:
            return rec
        v = (j.get("data") or {}).get("latestVersion", {})
        fields = {f["typeName"]: f.get("value") for f in ((v.get("metadataBlocks") or {}).get("citation") or {}).get("fields", [])}
        lic = v.get("license")
        rec.update(
            title=fields.get("title"),
            license=lic.get("name") if isinstance(lic, dict) else (lic or v.get("termsOfUse")),
            version_ref=f"doi:{doi} v{v.get('versionNumber')}.{v.get('versionMinorNumber')}",
            version_kind="dataverse_version",
            version_date=v.get("releaseTime"),
            access_mode="dataverse_api",
        )
        rec["files"] = [
            {"path": (f.get("directoryLabel") + "/" if f.get("directoryLabel") else "") + (f.get("dataFile") or {}).get("filename", f.get("label", "")),
             "size": (f.get("dataFile") or {}).get("filesize"),
             "url": f"https://{host}/api/access/datafile/{(f.get('dataFile') or {}).get('id')}",
             "restricted": f.get("restricted")}
            for f in v.get("files", [])
        ]
        rec["files_complete"] = True
        meta_row(rec, "license_citation", "license (Dataverse)", rec["license"], api)
        rec["status"] = "ok"
    except RateLimited as exc:
        rec["status"] = "rate_limited"
        rec["notes"].append(str(exc))
    summarise_files(rec)
    return rec


def inventory_osf(link: dict, http: HttpClient, cfg: Config) -> dict:
    rec = base_record(link)
    node = (link["extra"].get("node_id") or "").lower()
    try:
        j = None
        for kind in ("nodes", "registrations"):
            api = f"https://api.osf.io/v2/{kind}/{node}/"
            resp = http.get(api)
            rec["api_sources"].append({"url": api, "status": resp.status, "from_cache": resp.from_cache, "at": resp.fetched_at})
            if resp.ok:
                j = resp.json()
                break
            rec["http_status"] = resp.status
        if j is None:
            rec["status"] = status_from_http(rec["http_status"])
            return rec
        a = j["data"]["attributes"]
        rec.update(title=a.get("title"), description=a.get("description"), version_ref=f"osf:{node} (modified {a.get('date_modified')})", version_kind="osf_snapshot", version_date=a.get("date_modified"), access_mode="osf_api")
        files, queue, seen = [], [f"https://api.osf.io/v2/{kind}/{node}/files/osfstorage/"], 0
        while queue and seen < 20:
            url = queue.pop(0)
            seen += 1
            listing = fetch_json(http, url, rec) or {}
            for item in listing.get("data", []):
                at = item["attributes"]
                if at.get("kind") == "folder":
                    rel = ((item.get("relationships") or {}).get("files") or {}).get("links", {}).get("related", {}).get("href")
                    if rel:
                        queue.append(rel)
                else:
                    files.append({"path": at.get("materialized_path", at.get("name", "")).lstrip("/"), "size": at.get("size"), "url": (item.get("links") or {}).get("download")})
            nxt = (listing.get("links") or {}).get("next")
            if nxt:
                queue.append(nxt)
        rec["files"], rec["files_complete"] = files, not queue
        rec["status"] = "ok"
    except RateLimited as exc:
        rec["status"] = "rate_limited"
        rec["notes"].append(str(exc))
    summarise_files(rec)
    return rec


def inventory_openml(link: dict, http: HttpClient, cfg: Config) -> dict:
    rec = base_record(link)
    kind, oid = link["extra"]["kind"], link["extra"]["id"]
    endpoint = {"d": "data", "t": "task", "s": "study"}[kind]
    api = f"https://www.openml.org/api/v1/json/{endpoint}/{oid}"
    try:
        j = fetch_json(http, api, rec, primary=True)
        if j is None:
            return rec
        body = j.get("data_set_description") or j.get("task") or j.get("study") or {}
        rec.update(
            title=body.get("name") or body.get("task_name"),
            description=(body.get("description") or "")[:4000] if isinstance(body.get("description"), str) else None,
            license=body.get("licence"),
            version_ref=f"openml:{endpoint}/{oid}" + (f" v{body.get('version')}" if body.get("version") else ""),
            version_kind="openml_id",
            version_date=body.get("upload_date") or body.get("creation_date"),
            access_mode="openml_api",
        )
        if body.get("url"):
            rec["files"] = [{"path": f"{body.get('name')}.{(body.get('format') or 'arff').lower()}", "size": None, "url": body.get("url")}]
        if endpoint == "study":
            data_ids = ((body.get("data") or {}).get("data_id")) or []
            task_ids = ((body.get("tasks") or {}).get("task_id")) or []
            meta_row(rec, "corpus_levels", "study content (OpenML)", f"{len(data_ids)} datasets, {len(task_ids)} tasks", api)
        meta_row(rec, "license_citation", "licence (OpenML)", rec["license"], api)
        meta_row(rec, "license_citation", "original_data_url / citation (OpenML)", f"{body.get('original_data_url') or ''} {body.get('citation') or ''}".strip(), api)
        rec["status"] = "ok"
    except RateLimited as exc:
        rec["status"] = "rate_limited"
        rec["notes"].append(str(exc))
    summarise_files(rec)
    return rec


# -- generic web ------------------------------------------------------------------
def inventory_archive_url(link: dict, http: HttpClient, cfg: Config) -> dict:
    """Direct archive URL: a 1-byte Range probe gives status, size, type and date."""
    rec = base_record(link)
    resp = http.get(link["url"], headers={"Range": "bytes=0-0"}, max_bytes=1024)
    rec["api_sources"].append({"url": link["url"], "status": resp.status, "from_cache": resp.from_cache, "at": resp.fetched_at})
    rec["http_status"], rec["resolved_url"] = resp.status, resp.final_url
    rec["status"] = status_from_http(resp.status)
    rec["access_mode"] = "http_range_probe"
    if resp.error:
        rec["notes"].append(resp.error)
    size = None
    m = re.search(r"/(\d+)$", resp.headers.get("content-range", ""))
    if m:
        size = int(m.group(1))
    elif resp.status == 200 and resp.headers.get("content-length", "").isdigit():
        size = int(resp.headers["content-length"])
        rec["notes"].append("server ignored the Range request (no partial reads possible)")
    rec["range_support"] = resp.status == 206
    last_modified = resp.headers.get("last-modified")
    rec["version_ref"] = f"last-modified {last_modified}" if last_modified else f"retrieved {resp.fetched_at}"
    rec["version_kind"] = "http_last_modified" if last_modified else "web_snapshot"
    rec["version_date"] = last_modified
    if rec["status"] == "ok":
        name = urlsplit(resp.final_url or link["url"]).path.rsplit("/", 1)[-1] or "archive"
        rec["title"] = name
        rec["files"] = [{"path": name, "size": size, "url": link["url"], "content_type": resp.headers.get("content-type")}]
        rec["files_complete"] = True
        meta_row(rec, "downloadable_files", "HTTP probe (size / type / last-modified)", f"{name}: {size} bytes, {resp.headers.get('content-type')}, last-modified {last_modified}", link["url"])
    summarise_files(rec)
    return rec


def inventory_web(link: dict, http: HttpClient, cfg: Config) -> dict:
    if ev.ARCHIVE_PATH_RE.search(urlsplit(link["url"]).path or ""):
        return inventory_archive_url(link, http, cfg)
    rec = base_record(link)
    try:
        page = http.get(link["url"], max_bytes=1024 * 1024)
    except RateLimited as exc:
        rec["status"] = "rate_limited"
        rec["notes"].append(str(exc))
        return rec
    rec["api_sources"].append({"url": link["url"], "status": page.status, "from_cache": page.from_cache, "at": page.fetched_at})
    rec["http_status"] = page.status
    rec["resolved_url"] = page.final_url
    rec["status"] = status_from_http(page.status)
    if page.error:
        rec["notes"].append(page.error)
    rec["access_mode"] = "http_get"
    rec["version_ref"] = f"retrieved {page.fetched_at}"
    rec["version_kind"] = "web_snapshot"
    if page.ok and "html" in page.headers.get("content-type", ""):
        raw = page.text()
        title = re.search(r"(?is)<title[^>]*>(.*?)</title>", raw)
        rec["title"] = re.sub(r"\s+", " ", title.group(1)).strip()[:200] if title else None
        for href in re.findall(r"""href=["']([^"']+)["']""", raw):
            if href.startswith("http"):
                add_discovered(rec, "url", href, "web:href")
    pages_owner = link["extra"].get("pages_owner")
    if pages_owner:
        add_discovered(rec, "url", f"https://github.com/{pages_owner}/{link['extra']['pages_repo']}", "derived_from_github_pages_url")
    return rec


# -- dispatch ---------------------------------------------------------------------
INVENTORY = {
    "github": inventory_github,
    "gitlab": inventory_gitlab,
    "zenodo": inventory_zenodo,
    "figshare": inventory_figshare,
    "dryad": inventory_dryad,
    "dataverse": inventory_dataverse,
    "osf": inventory_osf,
    "openml": inventory_openml,
    "edi": inventory_edi,
    "datacite": inventory_doi,
    "doi": inventory_doi,
    "web": inventory_web,
}


def inventory_link(link: dict, http: HttpClient, cfg: Config) -> dict:
    fn = INVENTORY.get(link["provider"])
    if fn is None:
        rec = base_record(link)
        rec["status"] = "unsupported"
        return rec
    try:
        return fn(link, http, cfg)
    except OfflineCacheMiss as exc:
        rec = base_record(link)
        rec["status"] = "cache_miss"
        rec["notes"].append(f"offline and not cached: {exc}")
        return rec


# -- inspect ----------------------------------------------------------------------
def _row(rec: dict, hit: dict, *, path: str, source_kind: str, permalink: str | None, location: str | None = None) -> dict:
    kind = hit.get("kind", "doc")
    evidence_kind = {"doc": "documentation_statement", "code": "code_statement", "schema_header": "schema_header"}.get(kind, kind)
    if hit.get("from_comment"):
        evidence_kind = "code_comment"
    row = {
        "paper_id": rec["paper_id"],
        "link_id": rec["link_id"],
        "topic": hit["topic"],
        "volet": ev.TOPIC_VOLET.get(hit["topic"], "collecte"),
        "source_kind": source_kind,
        "evidence_kind": evidence_kind,
        "provider": rec["provider"],
        "resource_url": rec.get("resolved_url") or rec["url"],
        "version_ref": rec.get("version_ref"),
        "path": path,
        "location": location,
        "line_start": hit.get("line_start") if not location else None,
        "line_end": hit.get("line_end") if not location else None,
        "permalink": permalink,
        "snippet": hit.get("snippet", ""),
        "matched_rule": hit.get("rule"),
        "confidence": "keyword_match",
        "review_status": "pending",
    }
    row["evidence_id"] = ev.evidence_id(row["paper_id"], row["link_id"], row["topic"], path, location, row["line_start"], row["evidence_kind"])
    return row


def scan_file(rec: dict, path: str, content: bytes, *, source_prefix: str, permalink_fn) -> tuple[list[dict], str | None]:
    """Scan one file; returns (evidence rows, skip reason)."""
    if ev.is_lfs_pointer(content):
        return [], "git-lfs pointer (object not fetched)"
    cls = ev.file_class(path)
    if cls == "spreadsheet":
        return scan_spreadsheet(rec, path, content, source_prefix=source_prefix, permalink_fn=permalink_fn)
    if ev.is_binary(content):
        return [], "binary content"
    text = content.decode("utf-8", errors="replace")
    name = path.lower()
    rows = []
    if name.endswith(".ipynb"):
        cells = ev.notebook_lines(text)
        for kind in ("doc", "code"):
            lines = [t if k == kind else "" for _, k, t in cells]
            for hit in ev.scan_lines(lines, kind):
                loc = f"{cells[hit['line_start'] - 1][0]} .. {cells[hit['line_end'] - 1][0]}"
                hit["snippet"] = "\n".join(lines[hit["line_start"] - 1 : hit["line_end"]])[:600]
                hit["kind"] = kind
                rows.append(_row(rec, hit, path=path, source_kind=f"{source_prefix}_{'doc' if kind == 'doc' else 'code'}", permalink=permalink_fn(path, None, None), location=loc))
    else:
        if name.endswith((".html", ".htm")):
            text = ev.html_to_text(text)
        for hit in ev.scan_document(text, cls, topics=ev.topics_for(path, cls)):
            sk = f"{source_prefix}_{'code' if hit['kind'] in ('code',) or hit.get('from_comment') else 'doc'}"
            rows.append(_row(rec, hit, path=path, source_kind=sk, permalink=permalink_fn(path, hit["line_start"], hit["line_end"])))
    if cls in ("doc", "code", "config") or name.endswith(".ipynb"):
        for lineno, kind, value in links_in_text(text)[:200]:
            add_discovered(rec, kind, value, f"{path}", lineno)
    return rows, None


def scan_spreadsheet(rec: dict, path: str, content: bytes, *, source_prefix: str, permalink_fn) -> tuple[list[dict], str | None]:
    """Documentation workbook: each sheet's first row is a schema header, rows are scanned as documentation."""
    try:
        cells = ev.spreadsheet_lines(content)
    except ImportError:
        return [], "openpyxl not installed"
    except Exception as exc:  # corrupt or password-protected workbook
        return [], f"unreadable workbook ({type(exc).__name__})"
    rows: list[dict] = []
    lines = [t for _, t in cells]
    seen_sheets: dict[str, int] = {}
    for loc, text in cells:
        sheet = loc.rsplit(" row ", 1)[0]
        seen_sheets[sheet] = seen_sheets.get(sheet, 0) + 1
    first_row = {}
    for loc, text in cells:
        sheet = loc.rsplit(" row ", 1)[0]
        first_row.setdefault(sheet, (loc, text))
    for sheet, (loc, text) in first_row.items():
        hit = {"topic": "schema_fields", "kind": "schema_header", "rule": "sheet_header", "snippet": f"{text[:500]}  [{seen_sheets[sheet] - 1} non-empty rows read]"}
        rows.append(_row(rec, hit, path=path, source_kind=f"{source_prefix}_doc", permalink=permalink_fn(path, None, None), location=loc))
    for hit in ev.scan_lines(lines, "doc"):
        hit["kind"] = "doc"
        loc = f"{cells[hit['line_start'] - 1][0]} .. {cells[hit['line_end'] - 1][0]}"
        rows.append(_row(rec, hit, path=path, source_kind=f"{source_prefix}_doc", permalink=permalink_fn(path, None, None), location=loc))
    for lineno, kind, value in links_in_text("\n".join(lines))[:200]:
        add_discovered(rec, kind, value, f"{path} ({cells[lineno - 1][0]})", None)
    return rows, None


def list_targz(rec: dict, http: HttpClient, f: dict, budget: int) -> int:
    """List the members found in the first ``budget`` bytes of a remote tar(.gz)."""
    resp = http.get(f["url"], max_bytes=budget)
    if not resp.ok:
        rec["archives"][f["path"]] = {"error": f"HTTP {resp.status}"}
        return len(resp.content)
    try:
        members, complete = remotezip.list_tar_prefix(resp.content, compressed=not f["path"].lower().endswith(".tar"))
    except zlib.error as exc:
        rec["archives"][f["path"]] = {"error": f"not a gzip stream ({exc})"}
        return len(resp.content)
    complete = complete or not resp.truncated
    rec["archives"][f["path"]] = {
        "n_members": len(members) if complete else None,
        "sampled": not complete,
        "n_listed": len(members),
        "prefix_bytes_read": len(resp.content),
        "uncompressed_bytes": sum(m["size"] for m in members) if complete else None,
        "uncompressed_bytes_listed": sum(m["size"] for m in members),
        "members_sample": members[:300],
        "formats": _formats(members),
        "top_dirs": _top_dirs(members),
    }
    return len(resp.content)


def inspect_tree(rec: dict, reader, cfg: Config, *, source_prefix: str, permalink_fn) -> tuple[list[dict], list[dict]]:
    selected = ev.select_files(rec["files"], cfg.max_files, cfg.max_file_bytes, rec.get("focus_paths"))
    rows, log, spent = [], [], 0
    for f in selected:
        if spent >= cfg.max_repo_bytes:
            log.append({"path": f["path"], "status": "skipped: repository byte budget exhausted"})
            continue
        try:
            content, reason = reader(f["path"], f.get("size"), cfg.max_file_bytes)
        except OfflineCacheMiss:
            content, reason = None, "offline cache miss"
        except RateLimited as exc:
            content, reason = None, str(exc)
        if content is None:
            log.append({"path": f["path"], "status": f"skipped: {reason}"})
            continue
        spent += len(content)
        file_rows, skip = scan_file(rec, f["path"], content, source_prefix=source_prefix, permalink_fn=permalink_fn)
        rows += file_rows
        log.append({"path": f["path"], "status": f"skipped: {skip}" if skip else "read", "bytes": len(content), "n_hits": len(file_rows)})
    return rows, log


CAP_DOC_PER_TOPIC = 12
CAP_CODE_PER_TOPIC = 6


def cap_rows(rows: list[dict], focus_paths: list[str] | None = None) -> list[dict]:
    """Keep, per topic, the documentary rows first and from the highest-priority files.

    Metadata fields, file-presence rows and table headers (one per file) are never capped.
    """
    fixed = [r for r in rows if r["evidence_kind"] in {"metadata_field", "file_presence", "schema_header"}]
    rest = [r for r in rows if r["evidence_kind"] not in {"metadata_field", "file_presence", "schema_header"}]

    def rank(r):
        path = (r["path"] or "").split("!")[-1]
        return (-ev.priority(path, None, focus_paths), r["path"] or "", r.get("line_start") or 0)

    kept, counts = [], {}
    for r in sorted(rest, key=rank):
        family = "doc" if r["evidence_kind"] == "documentation_statement" else "code"
        key = (r["topic"], family)
        limit = CAP_DOC_PER_TOPIC if family == "doc" else CAP_CODE_PER_TOPIC
        if counts.get(key, 0) < limit:
            counts[key] = counts.get(key, 0) + 1
            kept.append(r)
    return fixed + kept


def presence_rows(rec: dict) -> list[dict]:
    """File-presence observations: never interpreted as documentation."""
    out = []
    for path in rec.get("key_files_present", []):
        hit = {"topic": "file_presence", "kind": "file_presence", "snippet": f"file present: {path} (presence only, content not interpreted)", "rule": "file_name"}
        out.append(_row(rec, hit, path=path, source_kind="file_listing", permalink=None))
    return out


def metadata_rows(rec: dict) -> list[dict]:
    out = []
    for m in rec.get("metadata_evidence", []):
        hit = {"topic": m["topic"], "kind": "metadata_field", "snippet": f"{m['field']}: {m['value']}", "rule": m["field"]}
        row = _row(rec, hit, path=m["source"], source_kind="api_metadata", permalink=m["source"])
        row["confidence"] = "api_field"
        out.append(row)
    return out


def description_rows(rec: dict, text: str | None, field: str) -> list[dict]:
    if not text:
        return []
    plain = ev.html_to_text(text) if "<" in text else text
    rows = []
    for hit in ev.scan_document(plain, "doc"):
        rows.append(_row(rec, hit, path=f"api:{field}", source_kind="deposit_description", permalink=rec.get("resolved_url") or rec["url"]))
    for lineno, kind, value in links_in_text(plain):
        add_discovered(rec, kind, value, f"api:{field}", lineno)
    return rows


def list_zip(rec: dict, http: HttpClient, f: dict, cfg: Config, budget: int) -> tuple[list[dict], int]:
    """Describe a remote ZIP through Range requests and scan its small text members.

    The declared member count always comes from the EOCD record; the member
    list is complete when the central directory fits ``budget``, otherwise it
    is a sample of the first entries (``sampled: true``).
    """
    rows: list[dict] = []
    remote = HttpRangeFile(http, f["url"], f["size"], budget)
    try:
        info = remotezip.list_members(remote, budget_bytes=max(0, budget - 256 * 1024))
        members = info["members"]
        rec["archives"][f["path"]] = {
            "n_members": info["n_members_declared"],
            "central_directory_bytes": info["central_directory_bytes"],
            "zip64": info["zip64"],
            "sampled": info["sampled"],
            "n_listed": len(members),
            "uncompressed_bytes": None if info["sampled"] else sum(m["size"] for m in members),
            "uncompressed_bytes_listed": sum(m["size"] for m in members),
            "members_sample": [{k: m[k] for k in ("path", "size")} for m in members[:300]],
            "formats": _formats(members),
            "top_dirs": _top_dirs(members),
        }
        for m in ev.select_files(members, 8, cfg.max_file_bytes):
            if m["compressed"] > cfg.max_file_bytes:
                continue
            try:
                content = remotezip.read_member(remote, m)
            except (RangeBudgetExceeded, NoRangeSupport, remotezip.ZipStructureError, zlib.error) as exc:
                rec["notes"].append(f"could not read {f['path']}!{m['path']}: {type(exc).__name__}")
                continue
            file_rows, _ = scan_file(rec, f"{f['path']}!{m['path']}", content, source_prefix="deposit_file", permalink_fn=lambda p, a, b: f["url"])
            rows += file_rows
    except (NoRangeSupport, RangeBudgetExceeded, remotezip.ZipStructureError) as exc:
        rec["archives"][f["path"]] = {"error": f"{type(exc).__name__}: {str(exc)[:200]}"}
    return rows, remote.fetched


def _formats(members: list[dict]) -> dict:
    out: dict[str, dict] = {}
    for m in members:
        ext = ev.suffix(m["path"]) or "(none)"
        slot = out.setdefault(ext, {"n": 0, "bytes": 0})
        slot["n"] += 1
        slot["bytes"] += m["size"]
    return dict(sorted(out.items(), key=lambda kv: -kv[1]["n"])[:12])


def _top_dirs(members: list[dict]) -> dict:
    out: dict[str, int] = {}
    for m in members:
        top = m["path"].split("/", 1)[0] if "/" in m["path"] else "(root)"
        out[top] = out.get(top, 0) + 1
    return dict(sorted(out.items(), key=lambda kv: -kv[1])[:20])


def inspect_deposit(rec: dict, http: HttpClient, cfg: Config) -> tuple[list[dict], list[dict]]:
    rows = description_rows(rec, rec.get("description"), "description")
    for i, extra in enumerate(rec.get("datacite_descriptions", [])[1:], start=2):
        rows += description_rows(rec, extra, f"datacite.descriptions[{i}]")
    log, spent = [], 0
    for f in rec["files"]:
        url, size = f.get("url"), f.get("size")
        if not url or size is None or not url.startswith("http"):
            continue
        if (f.get("data_type") or "").lower() == "external link" or f.get("link_only") or urlsplit(url).netloc.lower() in {"doi.org", "dx.doi.org"}:
            continue  # a pointer to another resource, not a file of this deposit
        name = f["path"].lower()
        if name.endswith(".zip"):
            # A ZIP's central directory can be tens of MB for 100k+ members:
            # give it what is left of the resource budget.
            budget = max(0, cfg.max_repo_bytes - spent)
            if budget <= 0:
                log.append({"path": f["path"], "status": "skipped: byte budget exhausted"})
                continue
            zrows, used = list_zip(rec, http, f, cfg, budget)
            spent += used
            rows += zrows
            error = rec["archives"].get(f["path"], {}).get("error")
            log.append({"path": f["path"], "status": f"zip listing failed: {error}" if error else "zip listed via HTTP Range", "bytes": used, "n_hits": len(zrows)})
            continue
        if name.endswith((".tar.gz", ".tgz", ".tar")):
            budget = min(TAR_PREFIX_BYTES, max(0, cfg.max_repo_bytes - spent))
            if budget <= 0:
                log.append({"path": f["path"], "status": "skipped: byte budget exhausted"})
                continue
            used = list_targz(rec, http, f, budget)
            spent += used
            error = rec["archives"].get(f["path"], {}).get("error")
            log.append({"path": f["path"], "status": f"tar listing failed: {error}" if error else "tar prefix listed", "bytes": used})
            continue
        if ev.priority(f["path"], size) <= 0 or size > cfg.max_file_bytes:
            continue
        if spent + size > cfg.max_repo_bytes:
            log.append({"path": f["path"], "status": "skipped: byte budget exhausted"})
            continue
        resp = http.get(url, max_bytes=cfg.max_file_bytes)
        if not resp.ok or resp.truncated:
            log.append({"path": f["path"], "status": f"skipped: HTTP {resp.status}{' truncated' if resp.truncated else ''}"})
            continue
        spent += len(resp.content)
        file_rows, skip = scan_file(rec, f["path"], resp.content, source_prefix="deposit_file", permalink_fn=lambda p, a, b, u=url: u)
        rows += file_rows
        log.append({"path": f["path"], "status": f"skipped: {skip}" if skip else "read", "bytes": len(resp.content), "n_hits": len(file_rows)})
    if rec.get("eml_url"):
        resp = http.get(rec["eml_url"], max_bytes=rec_max(cfg))
        if resp.ok:
            file_rows, _ = scan_file(rec, "EML metadata (PASTA)", resp.content, source_prefix="deposit_file", permalink_fn=lambda p, a, b: rec["eml_url"])
            rows += file_rows
    return rows, log


def inspect_web(rec: dict, http: HttpClient, cfg: Config) -> tuple[list[dict], list[dict]]:
    if rec["status"] != "ok" or rec.get("role_guess") not in {"documentation", "code"}:
        return [], [{"path": rec["url"], "status": f"link-checked only (role {rec.get('role_guess')})"}]
    page = http.get(rec["url"], max_bytes=1024 * 1024)
    if not page.ok:
        return [], [{"path": rec["url"], "status": f"HTTP {page.status}"}]
    content = page.content
    rows, skip = scan_file(rec, "page.html" if "html" in page.headers.get("content-type", "") else "page.txt", content, source_prefix="web_page", permalink_fn=lambda p, a, b: rec["resolved_url"] or rec["url"])
    for r in rows:
        r["path"] = rec["resolved_url"] or rec["url"]
        r["location"] = f"extracted text lines {r['line_start']}-{r['line_end']}"
        r["line_start"] = r["line_end"] = None
    return rows, [{"path": rec["url"], "status": "read", "bytes": len(content), "n_hits": len(rows)}]


def inspect_record(rec: dict, http: HttpClient, cfg: Config) -> dict:
    """Return ``{evidence, files_log, discovered, inspected_at}`` for an inventoried record."""
    rec["discovered"] = list(rec.get("discovered", []))
    rows: list[dict] = metadata_rows(rec) + presence_rows(rec)
    log: list[dict] = []
    if rec["status"] != "ok":
        return {"evidence": rows, "files_log": [{"path": rec["url"], "status": f"not inspected: status {rec['status']}"}], "discovered": rec["discovered"], "inspected_at": now_iso()}
    try:
        provider = rec.get("via_doi_provider") or rec["provider"]
        if provider == "github":
            r, log = inspect_tree(rec, github_reader(rec, http, cfg), cfg, source_prefix="repository", permalink_fn=lambda p, a, b: github_permalink(rec, p, a, b))
            rows += r + description_rows(rec, rec.get("description"), "github.description")
        elif provider == "gitlab":
            base = (rec.get("resolved_url") or rec["url"]).rstrip("/")
            r, log = inspect_tree(rec, gitlab_reader(rec, http, cfg), cfg, source_prefix="repository", permalink_fn=lambda p, a, b: f"{base}/-/blob/{rec['version_ref']}/{quote(p)}" + (f"#L{a}-{b}" if a else ""))
            rows += r
        elif provider == "web" and rec.get("access_mode") == "http_range_probe":
            r, log = inspect_deposit(rec, http, cfg)  # a direct archive URL: list it like a deposit file
            rows += r
        elif provider == "web":
            r, log = inspect_web(rec, http, cfg)
            rows += r
        else:
            r, log = inspect_deposit(rec, http, cfg)
            rows += r
    except OfflineCacheMiss as exc:
        log.append({"path": rec["url"], "status": f"offline cache miss: {exc}"})
    except RateLimited as exc:
        log.append({"path": rec["url"], "status": str(exc)})
    seen, unique = set(), []
    for row in rows:
        if row["evidence_id"] not in seen:
            seen.add(row["evidence_id"])
            unique.append(row)
    return {"evidence": cap_rows(unique, rec.get("focus_paths")), "files_log": log, "discovered": rec["discovered"], "inspected_at": now_iso()}
