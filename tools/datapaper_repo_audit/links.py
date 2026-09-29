"""Extract, normalise, classify and deduplicate the links of a data paper.

Sources, in order of trust: TEI body/back/notes (what the authors point to),
TEI bibliography entries *only* when they are cited from an availability
section or carry a data-repository DOI/host, the comparison grid, and an
optional hand-written ``seeds.tsv`` (corrections, logged as ``manual_seed``).
"""

from __future__ import annotations

import csv
import hashlib
import re
from pathlib import Path
from urllib.parse import parse_qs, unquote, urlsplit

from lxml import etree

TEI = "http://www.tei-c.org/ns/1.0"
NS = {"t": TEI}

URL_RE = re.compile(r"https?://[^\s\"<>\]\[)(]+", re.I)
DOI_RE = re.compile(r"\b10\.\d{4,9}/[^\s\"<>,;]+", re.I)
TRAILING = ".,;:)]}'\""

# DOI prefix -> provider handling the deposit.
DATA_DOI_PREFIXES = {
    "10.5281": "zenodo",
    "10.6084": "figshare",
    "10.5061": "dryad",
    "10.17605": "osf",
    "10.7910": "dataverse",
    "10.6073": "edi",
    "10.5524": "datacite",  # GigaDB
    "10.24433": "datacite",  # Code Ocean
    "10.17632": "datacite",  # Mendeley Data
    "10.1594": "datacite",  # PANGAEA
    "10.4121": "datacite",  # 4TU
    "10.5066": "datacite",  # USGS ScienceBase
    "10.15468": "datacite",  # GBIF
    "10.3886": "datacite",  # ICPSR
    "10.25740": "datacite",  # Stanford SDR
    "10.34740": "datacite",  # Kaggle
}

REPOSITORY_PROVIDERS = {"github", "gitlab", "zenodo", "figshare", "dryad", "osf", "dataverse", "edi", "openml", "datacite"}

NOISE_HOSTS = {
    "www.tei-c.org",
    "tei-c.org",
    "www.w3.org",
    "creativecommons.org",
    "orcid.org",
    "scholar.google.com",
    "www.ncbi.nlm.nih.gov",
    "pubmed.ncbi.nlm.nih.gov",
}
NOISE_URLS = {"github.com/kermitt2/grobid"}
PLATFORM_ROOTS = {
    "github.com",
    "gitlab.com",
    "zenodo.org",
    "figshare.com",
    "doi.org",
    "dx.doi.org",
    "codeocean.com",
    "osf.io",
    "datadryad.org",
    "openml.org",
}

AVAILABILITY_RE = re.compile(
    r"availab|data (records?|access|deposit|citation|descriptor)|code (and data )?availab|supporting (data|source code)"
    r"|software availab|data and code|usage notes|code availability",
    re.I,
)
ROLE_RULES = [
    ("code", re.compile(r"\b(source code|code|software|scripts?|package|parsers?|library|toolbox|github)\b", re.I)),
    ("data", re.compile(r"\b(data ?sets?|data|database|deposit|repository|archive|download)\b", re.I)),
    ("documentation", re.compile(r"\b(documentation|home ?page|website|web site|portal|project page|tutorial)\b", re.I)),
]
PROVIDER_ROLE = {
    "github": "code",
    "gitlab": "code",
    "zenodo": "data",
    "figshare": "data",
    "dryad": "data",
    "dataverse": "data",
    "edi": "data",
    "osf": "data",
    "openml": "data",
    "datacite": "data",
}


def clean_url(url: str) -> str:
    url = url.strip().rstrip(TRAILING)
    return url


def clean_doi(doi: str) -> str:
    doi = unquote(doi.strip()).rstrip(TRAILING)
    doi = re.sub(r"^(https?://(dx\.)?doi\.org/)", "", doi, flags=re.I)
    doi = re.sub(r"^doi:\s*", "", doi, flags=re.I)
    return doi.lower()


def doi_from_url(url: str) -> str | None:
    parts = urlsplit(url)
    host = parts.netloc.lower()
    if host in {"doi.org", "dx.doi.org", "www.doi.org"}:
        path = unquote(parts.path.lstrip("/"))
        path = re.sub(r"^doi:\s*", "", path, flags=re.I)
        match = DOI_RE.match(path)
        return clean_doi(match.group(0)) if match else None
    return None


def link_id(canonical: str) -> str:
    return hashlib.sha1(canonical.encode("utf-8")).hexdigest()[:12]


def classify(url: str | None = None, doi: str | None = None) -> dict:
    """Return ``{provider, canonical, url, doi, extra}`` for a URL or DOI."""
    if url and not doi:
        doi = doi_from_url(url)
    if doi:
        doi = clean_doi(doi)
        prefix = doi.split("/", 1)[0]
        provider = DATA_DOI_PREFIXES.get(prefix, "doi")
        extra: dict = {}
        if provider == "zenodo":
            m = re.search(r"zenodo\.(\d+)", doi)
            extra["record_id"] = m.group(1) if m else None
        elif provider == "figshare":
            m = re.search(r"figshare\.(\d+)(?:\.v(\d+))?", doi)
            if m:
                extra["article_id"], extra["version"] = m.group(1), m.group(2)
        elif provider == "osf":
            m = re.search(r"osf\.io/([a-z0-9]+)", doi)
            extra["node_id"] = m.group(1) if m else None
        return {"provider": provider, "canonical": f"doi:{doi}", "url": f"https://doi.org/{doi}", "doi": doi, "extra": extra}

    assert url
    url = clean_url(url)
    parts = urlsplit(url)
    host = parts.netloc.lower().removeprefix("www.")
    path = parts.path.rstrip("/")
    segs = [s for s in path.split("/") if s]
    extra = {}

    if host in {"github.com", "raw.githubusercontent.com"} and len(segs) >= 2:
        owner, repo = segs[0], segs[1].removesuffix(".git")
        extra = {"owner": owner, "repo": repo}
        if host == "github.com" and len(segs) >= 4 and segs[2] in {"blob", "tree"}:
            extra["ref"] = segs[3]
            extra["focus_path"] = "/".join(segs[4:]) or None
        elif host == "raw.githubusercontent.com" and len(segs) >= 4:
            extra["ref"] = segs[2]
            extra["focus_path"] = "/".join(segs[3:])
        canonical = f"github.com/{owner}/{repo}".lower()
        return {"provider": "github", "canonical": canonical, "url": f"https://github.com/{owner}/{repo}", "doi": None, "extra": extra}
    if host == "github.com" and len(segs) == 1:
        return {"provider": "github_owner", "canonical": f"github.com/{segs[0]}".lower(), "url": url, "doi": None, "extra": {"owner": segs[0]}}
    if (host == "gitlab.com" or host.startswith("gitlab.")) and len(segs) >= 2:
        project = path.strip("/").split("/-/")[0].removesuffix(".git")
        extra = {"host": host, "project": project}
        if "/-/blob/" in path or "/-/tree/" in path:
            tail = path.split("/-/", 1)[1].split("/")
            extra["ref"] = tail[1] if len(tail) > 1 else None
            extra["focus_path"] = "/".join(tail[2:]) or None
        return {"provider": "gitlab", "canonical": f"{host}/{project}".lower(), "url": f"https://{host}/{project}", "doi": None, "extra": extra}
    if host == "zenodo.org":
        m = re.search(r"/records?/(\d+)", path)
        if m:
            rid = m.group(1)
            return {"provider": "zenodo", "canonical": f"zenodo.org/records/{rid}", "url": f"https://zenodo.org/records/{rid}", "doi": None, "extra": {"record_id": rid}}
    if host.endswith("figshare.com"):
        m = re.search(r"/(?:articles/[^/]+/[^/]+|articles)/(\d+)(?:/(\d+))?$", path)
        if m:
            aid, ver = m.group(1), m.group(2)
            return {"provider": "figshare", "canonical": f"figshare.com/articles/{aid}", "url": url, "doi": None, "extra": {"article_id": aid, "version": ver}}
    if host == "osf.io" and segs and re.fullmatch(r"[a-z0-9]{5}", segs[0]):
        return {"provider": "osf", "canonical": f"osf.io/{segs[0]}", "url": f"https://osf.io/{segs[0]}", "doi": None, "extra": {"node_id": segs[0]}}
    if host == "datadryad.org":
        m = re.search(r"(10\.5061/dryad\.[a-z0-9]+)", unquote(url), re.I)
        if m:
            return classify(doi=m.group(1))
    if host.endswith("openml.org"):
        m = re.search(r"/(d|t|s)/(\d+)", path)
        q = parse_qs(parts.query)
        kind, oid = (m.group(1), m.group(2)) if m else (None, None)
        if not m and q.get("id") and q.get("type"):
            kind, oid = {"data": "d", "task": "t", "study": "s", "benchmark": "s"}.get(q["type"][0]), q["id"][0]
        if kind and oid:
            return {"provider": "openml", "canonical": f"openml.org/{kind}/{oid}", "url": f"https://www.openml.org/{kind}/{oid}", "doi": None, "extra": {"kind": kind, "id": oid}}
    if host in {"portal.edirepository.org", "pasta.lternet.edu"}:
        ids = edi_package_from_url(url)
        if ids:
            scope, ident, rev = ids
            return {
                "provider": "edi",
                "canonical": f"edi:{scope}.{ident}.{rev}",
                "url": f"https://portal.edirepository.org/nis/mapbrowse?scope={scope}&identifier={ident}&revision={rev}",
                "doi": None,
                "extra": {"scope": scope, "identifier": ident, "revision": rev},
            }
    if "dataverse" in host:
        q = parse_qs(parts.query)
        pid = (q.get("persistentId") or [None])[0]
        if pid and pid.lower().startswith("doi:"):
            info = classify(doi=pid[4:])
            info["provider"] = "dataverse"
            info["extra"]["host"] = host
            return info

    canonical = f"{host}{path}".lower()
    if parts.query:
        canonical += "?" + parts.query
    extra = {}
    if host.endswith(".github.io"):
        owner = host.split(".")[0]
        extra["pages_owner"] = owner
        extra["pages_repo"] = segs[0] if segs else f"{owner}.github.io"
    return {"provider": "web", "canonical": canonical, "url": url, "doi": None, "extra": extra}


def edi_package_from_url(url: str) -> tuple[str, str, str] | None:
    parts = urlsplit(url)
    q = parse_qs(parts.query)
    if q.get("packageid"):
        m = re.fullmatch(r"([a-z-]+)\.(\d+)\.(\d+)", q["packageid"][0])
        if m:
            return m.group(1), m.group(2), m.group(3)
    if q.get("scope") and q.get("identifier") and q.get("revision"):
        return q["scope"][0], q["identifier"][0], q["revision"][0]
    m = re.search(r"/eml/([a-z-]+)/(\d+)/(\d+)", parts.path)
    if m:
        return m.group(1), m.group(2), m.group(3)
    return None


def guess_role(provider: str, context: str) -> str:
    """Repository providers have a fixed role; web pages are typed by context.

    Only ``documentation`` and ``code`` web pages are read during ``inspect``;
    a page cited for its data (``upstream_or_data_site``) is typically an
    upstream source (e.g. an agency portal) and is only link-checked.
    """
    if provider in PROVIDER_ROLE:
        return PROVIDER_ROLE[provider]
    for role, pattern in (ROLE_RULES[2], ROLE_RULES[0], ROLE_RULES[1]):
        if pattern.search(context or ""):
            return "upstream_or_data_site" if role == "data" else role
    return "reference_site"


def _text(elem) -> str:
    return re.sub(r"\s+", " ", "".join(elem.itertext())).strip()


def _location(elem) -> tuple[str, str | None, str]:
    """(found_in, bibl_id, section_head) for an element."""
    bibl_id = None
    found_in = "tei_body"
    head = ""
    for anc in elem.iterancestors():
        tag = etree.QName(anc).localname
        if tag == "biblStruct" and bibl_id is None:
            bibl_id = anc.get("{http://www.w3.org/XML/1998/namespace}id")
            found_in = "tei_bibl"
        elif tag == "note" and found_in == "tei_body":
            found_in = "tei_note"
        elif tag == "back" and found_in == "tei_body":
            found_in = "tei_back"
        elif tag == "teiHeader":
            found_in = "tei_header"
        elif tag == "div" and not head:
            h = anc.find("t:head", NS)
            head = _text(h) if h is not None else (anc.get("type") or "")
    return found_in, bibl_id, head


def _context(elem, needle: str, width: int = 160) -> str:
    bibl = next((a for a in elem.iterancestors() if etree.QName(a).localname == "biblStruct"), None)
    if bibl is not None:
        titles = [_text(t) for t in bibl.iterfind(".//t:title", NS)]
        return " | ".join(t for t in titles if t)[:300]
    block = next((a for a in elem.iterancestors() if etree.QName(a).localname in {"p", "note", "head", "item"}), elem)
    text = _text(block)
    i = text.find(needle)
    if i < 0:
        return text[: 2 * width]
    return text[max(0, i - width) : i + len(needle) + width]


def parse_tei(tei_path: Path) -> tuple[etree._Element, str | None]:
    tree = etree.parse(str(tei_path), etree.XMLParser(huge_tree=True, recover=True))
    root = tree.getroot()
    doi = None
    for idno in root.iterfind(".//t:teiHeader//t:sourceDesc//t:idno[@type='DOI']", NS):
        if idno.text:
            doi = clean_doi(idno.text)
            break
    return root, doi


def availability_bibl_ids(root) -> set[str]:
    ids: set[str] = set()
    for div in root.iterfind(".//t:text//t:div", NS):
        head = div.find("t:head", NS)
        label = (div.get("type") or "") + " " + (_text(head) if head is not None else "")
        if div.get("type") == "availability" or AVAILABILITY_RE.search(label):
            for ref in div.iterfind(".//t:ref[@type='bibr']", NS):
                target = (ref.get("target") or "").lstrip("#")
                if target:
                    ids.add(target)
    return ids


def _raw_candidates(root, source_file: str):
    """Yield (kind, value, element) for every URL/DOI mention in the TEI."""
    for elem in root.iter("{%s}ref" % TEI, "{%s}ptr" % TEI):
        target = elem.get("target") or ""
        if target.startswith("http") or target.lower().startswith("doi:") or target.lower().startswith("10."):
            for piece in target.split(","):
                piece = piece.strip()
                if not piece:
                    continue
                if DOI_RE.match(piece) or piece.lower().startswith("doi:"):
                    yield "doi", piece, elem
                else:
                    yield "url", piece, elem
    for elem in root.iter("{%s}idno" % TEI):
        if (elem.get("type") or "").upper() == "DOI" and elem.text:
            yield "doi", elem.text, elem
    # URLs and DOIs left as plain text by GROBID.
    for tag in ("p", "note", "head", "item", "note"):
        for elem in root.iterfind(f".//t:text//t:{tag}", NS):
            text = _text(elem)
            for m in URL_RE.finditer(text):
                yield "url", m.group(0), elem
            for m in re.finditer(r"(?:doi(?:\.org)?[:/]\s*)(10\.\d{4,9}/[^\s\"<>,;]+)", text, re.I):
                yield "doi", m.group(1), elem


def extract_tei_links(paper_id: str, tei_path: Path, repo_root: Path) -> tuple[list[dict], str | None]:
    """Return (links, paper_doi). Dropped candidates are kept with ``keep=False``."""
    root, paper_doi = parse_tei(tei_path)
    avail_ids = availability_bibl_ids(root)
    source_file = tei_path.relative_to(repo_root).as_posix() if tei_path.is_relative_to(repo_root) else str(tei_path)
    out: list[dict] = []
    for kind, value, elem in _raw_candidates(root, source_file):
        found_in, bibl_id, head = _location(elem)
        if found_in == "tei_header":
            continue
        try:
            info = classify(doi=value) if kind == "doi" else classify(url=clean_url(value))
        except Exception:  # malformed value: keep a trace, never crash
            continue
        context = _context(elem, value.split(",")[0][:40])
        link = make_link(paper_id, info, found_in=found_in, source_file=source_file, source_line=elem.sourceline, section=head, context=context, raw=value)
        link["bibl_id"] = bibl_id
        link["cited_from_availability"] = bibl_id in avail_ids if bibl_id else False
        keep, reason = keep_decision(link, avail_ids, paper_doi)
        link["keep"], link["drop_reason"] = keep, reason
        out.append(link)
    links = dedupe(out)
    assign_relations(links)
    return links, paper_doi


def assign_relations(links: list[dict]) -> None:
    """Tag each kept link with its relation to the paper.

    ``resource``               pointed to by the authors as their data/code
                               (text, availability section, grid, seed) -> inspected;
    ``availability_citation``  a non-repository reference cited from an
                               availability section (often an upstream source) -> link-checked;
    ``cited_deposit``          a repository cited elsewhere in the bibliography
                               (third-party tool or dataset) -> metadata only.
    A cited GitHub repository whose owner also owns a ``resource`` link
    (repository or GitHub Pages site) is promoted to ``resource``.
    """
    for link in links:
        if link["found_in"] == "discovered":
            continue  # relation fixed when discovered (see pipeline.discovered_links)
        if not link["keep"]:
            link["relation"] = None
            continue
        if link["found_in"] != "tei_bibl" or link["also_found_in"] and any(f != "tei_bibl" for f in link["also_found_in"]):
            link["relation"] = "resource"
        elif link.get("cited_from_availability"):
            link["relation"] = "resource" if link["provider"] in REPOSITORY_PROVIDERS else "availability_citation"
        else:
            link["relation"] = "cited_deposit"
        note = "suspected_truncated_doi (EDI DOIs end with 32 hex characters)"
        if link["provider"] == "edi" and link["doi"] and not re.search(r"pasta/[0-9a-f]{32}$", link["doi"]) and note not in link.setdefault("notes", []):
            link["notes"].append(note)
    owners = set()
    for link in links:
        if link.get("relation") == "resource":
            owner = link["extra"].get("owner") or link["extra"].get("pages_owner")
            if owner:
                owners.add(owner.lower())
    for link in links:
        note = "promoted: same GitHub owner as a resource link"
        if link.get("relation") == "cited_deposit" and link["provider"] == "github" and link["extra"]["owner"].lower() in owners:
            link["relation"] = "resource"
            if note not in link.setdefault("notes", []):
                link["notes"].append(note)


def make_link(paper_id: str, info: dict, *, found_in: str, source_file: str, source_line, section: str = "", context: str = "", raw: str = "", depth: int = 0, parent: str | None = None) -> dict:
    return {
        "link_id": link_id(info["canonical"]),
        "paper_id": paper_id,
        "raw": raw,
        "url": info["url"],
        "canonical": info["canonical"],
        "provider": info["provider"],
        "doi": info["doi"],
        "extra": info["extra"],
        "found_in": found_in,
        "also_found_in": [],
        "source_file": source_file,
        "source_line": source_line,
        "section": section,
        "context": (context or "")[:400],
        "role_guess": guess_role(info["provider"], f"{section} {context}"),
        "depth": depth,
        "parent": parent,
        "keep": True,
        "drop_reason": None,
        "focus_paths": [info["extra"]["focus_path"]] if info["extra"].get("focus_path") else [],
        "relation": "resource",
        "notes": [],
    }


def keep_decision(link: dict, avail_ids: set[str], paper_doi: str | None) -> tuple[bool, str | None]:
    parts = urlsplit(link["url"])
    host = parts.netloc.lower()
    bare = host.removeprefix("www.")
    if link["doi"] and paper_doi and link["doi"] == paper_doi:
        return False, "paper_itself"
    if host in NOISE_HOSTS or bare in NOISE_HOSTS:
        return False, "noise_host"
    if any(link["canonical"].startswith(n) for n in NOISE_URLS):
        return False, "tool_used_to_parse_the_pdf"
    if not link["doi"] and bare in PLATFORM_ROOTS and parts.path.strip("/") == "":
        return False, "bare_platform_or_resolver_url"
    if link["provider"] == "github_owner":
        return False, "github_owner_page_not_a_repository"
    if link["found_in"] == "tei_bibl":
        if link.get("bibl_id") in avail_ids:
            return True, None
        if link["provider"] in REPOSITORY_PROVIDERS:
            return True, None
        return False, "bibliography_reference_not_data_or_code"
    if link["provider"] == "doi":
        # Article DOI quoted in the running text: rarely the resource itself.
        return False, "non_data_doi_in_text"
    return True, None


def dedupe(links: list[dict]) -> list[dict]:
    """Merge duplicates (same canonical) and drop GROBID-truncated DOIs."""
    by_key: dict[str, dict] = {}
    order: list[str] = []
    for link in links:
        key = link["canonical"]
        if key in by_key:
            first = by_key[key]
            if link["keep"] and not first["keep"]:
                link["also_found_in"] = first["also_found_in"] + [first["found_in"]]
                by_key[key] = link
            elif link["found_in"] not in first["also_found_in"] and link["found_in"] != first["found_in"]:
                first["also_found_in"].append(link["found_in"])
            for p in link["focus_paths"]:
                if p not in by_key[key]["focus_paths"]:
                    by_key[key]["focus_paths"].append(p)
            continue
        by_key[key] = link
        order.append(key)
    result = [by_key[k] for k in order]
    dois = [l["doi"] for l in result if l["doi"]]
    for link in result:
        if link["doi"] and any(d != link["doi"] and d.startswith(link["doi"]) for d in dois):
            link["keep"], link["drop_reason"] = False, "truncated_doi_of_a_longer_doi"
    return result


def grid_rows(grid_path: Path) -> list[dict]:
    with grid_path.open(encoding="utf-8-sig", newline="") as stream:
        return list(csv.DictReader(stream, delimiter="\t"))


def tei_stem(row: dict) -> str | None:
    m = re.match(r"\s*([A-Za-z0-9_\-]+)\.pdf", row.get("preuves_locales", ""))
    return m.group(1) if m else None


def grid_links(row: dict, grid_file: str) -> list[dict]:
    out = []
    for column, value in row.items():
        for m in URL_RE.finditer(value or ""):
            info = classify(url=m.group(0))
            out.append(make_link(row["id"], info, found_in="grid", source_file=grid_file, source_line=None, section=column, context=value[:300], raw=m.group(0)))
    return out


def seed_links(seeds_path: Path, paper_id: str) -> list[dict]:
    """Manual corrections: TSV with columns paper_id, url, role, note."""
    if not seeds_path.exists():
        return []
    out = []
    with seeds_path.open(encoding="utf-8-sig", newline="") as stream:
        for row in csv.DictReader(stream, delimiter="\t"):
            if row.get("paper_id") != paper_id or not row.get("url"):
                continue
            value = row["url"].strip()
            info = classify(doi=value) if DOI_RE.match(value) or value.lower().startswith("doi:") else classify(url=value)
            link = make_link(paper_id, info, found_in="manual_seed", source_file=seeds_path.name, source_line=None, context=row.get("note", ""), raw=value)
            if row.get("role"):
                link["role_guess"] = row["role"]
            out.append(link)
    return out


def links_in_text(text: str) -> list[tuple[int, str, str]]:
    """(line number, kind, value) of URLs/DOIs in a text document."""
    out = []
    for lineno, line in enumerate(text.splitlines(), start=1):
        for m in URL_RE.finditer(line):
            out.append((lineno, "url", clean_url(m.group(0))))
        for m in re.finditer(r"(?:doi(?:\.org)?[:/]\s*)(10\.\d{4,9}/[^\s\"<>,;)\]]+)", line, re.I):
            out.append((lineno, "doi", m.group(1)))
    return out
