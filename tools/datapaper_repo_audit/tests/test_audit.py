"""Unit tests with local fixtures and a simulated network (no real HTTP).

Run:  python -m unittest discover -s tools/datapaper_repo_audit/tests -t tools
"""

from __future__ import annotations

import io
import json
import os
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from datapaper_repo_audit import evidence as ev  # noqa: E402
from datapaper_repo_audit import links as lk  # noqa: E402
from datapaper_repo_audit import providers as pv  # noqa: E402
from datapaper_repo_audit import pipeline as pl  # noqa: E402
from datapaper_repo_audit import remotezip  # noqa: E402
from datapaper_repo_audit import report as rp  # noqa: E402
from datapaper_repo_audit.netcache import HttpClient, HttpRangeFile, OfflineCacheMiss, RateLimited  # noqa: E402


# -- simulated network ---------------------------------------------------------------
class FakeRaw:
    def __init__(self, url, status, headers, body):
        self.url, self.status_code, self.headers, self._body = url, status, headers, body

    def iter_content(self, n):
        for i in range(0, len(self._body), n):
            yield self._body[i : i + n]

    def close(self):
        pass


class FakeSession:
    """routes: url -> (status, headers, body) | callable(headers) -> tuple."""

    def __init__(self, routes):
        self.routes = routes
        self.calls: list[str] = []

    def get(self, url, headers=None, **_kw):
        self.calls.append(url)
        route = self.routes.get(url)
        if route is None:
            return FakeRaw(url, 404, {}, b"not found")
        if callable(route):
            route = route(headers or {})
        status, hdrs, body = route
        if isinstance(body, (dict, list)):
            body = json.dumps(body).encode()
        elif isinstance(body, str):
            body = body.encode()
        return FakeRaw(url, status, hdrs, body)


def client(tmp: Path, routes, **kw) -> tuple[HttpClient, FakeSession]:
    session = FakeSession(routes)
    http = HttpClient(tmp, session_factory=lambda: session, sleep=lambda s: None, **kw)
    return http, session


def ranged(blob: bytes):
    def route(headers):
        rng = headers.get("Range")
        if not rng:
            return 200, {}, blob
        a, b = (int(x) for x in rng.split("=")[1].split("-"))
        return 206, {"Content-Range": f"bytes {a}-{b}/{len(blob)}"}, blob[a : b + 1]

    return route


TEI_FIXTURE = """<?xml version="1.0" encoding="UTF-8"?>
<TEI xmlns="http://www.tei-c.org/ns/1.0">
 <teiHeader><fileDesc><sourceDesc><biblStruct><analytic><idno type="DOI">10.1093/gigascience/gix000</idno></analytic></biblStruct></sourceDesc></fileDesc></teiHeader>
 <text>
  <body>
   <div><head>Methods</head>
    <p>Lake data were obtained from 87 state agencies and harmonized; see http://dx.doi.org/doi:10.6073/pasta/16f4bdaa and <ref type="url" target="https://www.codeocean.com/,10.24433/CO.5304543.v1">capsule</ref>.</p>
    <p>We used <ref type="url" target="https://github.com/kermitt2/grobid">GROBID</ref>.</p>
   </div>
  </body>
  <back>
   <div type="availability"><head>Availability of supporting data</head>
    <p>Project home page: <ref type="url" target="https://github.com/acme/lakes/blob/main/docs/README.md">repo</ref>. Data components [<ref type="bibr" target="#b1">1</ref>].</p>
   </div>
   <listBibl>
    <biblStruct xml:id="b1"><monogr><title>LAGOS-NE-LOCUS v1.01</title><idno type="DOI">10.6073/pasta/16f4bdaa9607c845c0b261a580730a7a</idno><ptr target="http://dx.doi.org"/></monogr></biblStruct>
    <biblStruct xml:id="b2"><analytic><title>Some cited article</title><idno type="DOI">10.1016/j.x.2020.1</idno></analytic></biblStruct>
    <biblStruct xml:id="b3"><monogr><title>Third-party tool</title><idno type="DOI">10.5281/zenodo.806850</idno></monogr></biblStruct>
    <biblStruct xml:id="b4"><monogr><title>Sister repo</title><ptr target="https://github.com/acme/tools"/></monogr></biblStruct>
   </listBibl>
  </back>
 </text>
</TEI>"""


class LinkTests(unittest.TestCase):
    def test_classify_variants(self):
        gh = lk.classify(url="https://github.com/Owner/Repo/blob/main/add-datasets-readme.md")
        self.assertEqual((gh["provider"], gh["canonical"], gh["extra"]["focus_path"]), ("github", "github.com/owner/repo", "add-datasets-readme.md"))
        self.assertEqual(lk.classify(doi="10.6084/m9.figshare.23937978")["extra"]["article_id"], "23937978")
        self.assertEqual(lk.classify(url="https://zenodo.org/records/123")["extra"]["record_id"], "123")
        self.assertEqual(lk.classify(url="https://doi.org/doi:10.5281/zenodo.9")["canonical"], "doi:10.5281/zenodo.9")
        edi = lk.classify(url="https://portal.edirepository.org/nis/mapbrowse?packageid=edi.100.4")
        self.assertEqual((edi["provider"], edi["canonical"]), ("edi", "edi:edi.100.4"))
        self.assertEqual(lk.classify(doi="10.17605/OSF.IO/C63AW")["extra"]["node_id"], "c63aw")
        self.assertEqual(lk.classify(url="https://www.openml.org/search?type=data&id=31")["canonical"], "openml.org/d/31")
        pages = lk.classify(url="https://knights-lab.github.io/MLRepo/")
        self.assertEqual((pages["provider"], pages["extra"]["pages_repo"]), ("web", "MLRepo"))

    def test_tei_extraction_rules(self):
        with tempfile.TemporaryDirectory() as tmp:
            tei = Path(tmp) / "x.tei.xml"
            tei.write_text(TEI_FIXTURE, encoding="utf-8")
            links, doi = lk.extract_tei_links("DPX", tei, Path(tmp))
        self.assertEqual(doi, "10.1093/gigascience/gix000")
        by = {l["canonical"]: l for l in links}
        repo = by["github.com/acme/lakes"]
        self.assertTrue(repo["keep"])
        self.assertEqual((repo["relation"], repo["focus_paths"]), ("resource", ["docs/README.md"]))
        self.assertEqual(by["doi:10.6073/pasta/16f4bdaa9607c845c0b261a580730a7a"]["relation"], "resource")  # cited from availability
        self.assertEqual(by["doi:10.6073/pasta/16f4bdaa"]["drop_reason"], "truncated_doi_of_a_longer_doi")
        self.assertFalse(by["doi:10.1016/j.x.2020.1"]["keep"])  # plain cited article
        self.assertEqual(by["doi:10.5281/zenodo.806850"]["relation"], "cited_deposit")
        self.assertEqual(by["github.com/acme/tools"]["relation"], "resource")  # same owner as a resource
        self.assertIn("doi:10.24433/co.5304543.v1", by)  # GROBID "url,doi" artefact split
        self.assertFalse(by["github.com/kermitt2/grobid"]["keep"])


class NetTests(unittest.TestCase):
    def test_cache_offline_and_dead_links(self):
        with tempfile.TemporaryDirectory() as tmp:
            http, session = client(Path(tmp), {"https://a.org/x": (200, {"content-type": "text/plain"}, "hello")})
            self.assertEqual(http.get("https://a.org/x").text(), "hello")
            self.assertTrue(http.get("https://a.org/x").from_cache)
            self.assertEqual(http.get("https://a.org/dead").status, 404)
            http.get("https://a.org/dead")
            self.assertEqual(session.calls.count("https://a.org/x"), 1)
            self.assertEqual(session.calls.count("https://a.org/dead"), 1)  # 404 cached: reproducible
            offline, _ = client(Path(tmp), {}, offline=True)
            self.assertEqual(offline.get("https://a.org/x").text(), "hello")
            with self.assertRaises(OfflineCacheMiss):
                offline.get("https://a.org/other")

    def test_transient_errors_are_retried_and_not_cached(self):
        with tempfile.TemporaryDirectory() as tmp:
            http, session = client(Path(tmp), {"https://a.org/busy": (503, {}, "")}, max_retries=2)
            self.assertEqual(http.get("https://a.org/busy").status, 503)
            self.assertEqual(len(session.calls), 3)
            http.get("https://a.org/busy")
            self.assertEqual(len(session.calls), 6)

    def test_rate_limit_blocks_host(self):
        with tempfile.TemporaryDirectory() as tmp:
            http, session = client(Path(tmp), {"https://api.github.com/repos/a/b": (403, {"x-ratelimit-remaining": "0", "x-ratelimit-reset": "99"}, "{}")})
            with self.assertRaises(RateLimited):
                http.get("https://api.github.com/repos/a/b")
            with self.assertRaises(RateLimited):
                http.get("https://api.github.com/repos/a/c")
            self.assertEqual(len(session.calls), 1)

    def test_truncation_respects_max_bytes(self):
        with tempfile.TemporaryDirectory() as tmp:
            http, _ = client(Path(tmp), {"https://a.org/big": (200, {}, b"x" * 200_000)})
            resp = http.get("https://a.org/big", max_bytes=1000)
            self.assertTrue(resp.truncated)
            self.assertEqual(len(resp.content), 1000)


class ZipTests(unittest.TestCase):
    def test_remote_zip_listing_reads_only_small_members(self):
        buf = io.BytesIO()
        with zipfile.ZipFile(buf, "w", zipfile.ZIP_DEFLATED) as zf:
            zf.writestr("CMPD/README.txt", "Projects were parsed from PSPLIB; duplicates were removed.\nLicense: CC BY 4.0\n")
            zf.writestr("CMPD/data/p1.json", "{}" * 100)
            zf.writestr("CMPD/data/p2.mat", b"\x00" * 5000)
        blob = buf.getvalue()
        with tempfile.TemporaryDirectory() as tmp:
            http, _ = client(Path(tmp), {"https://files.org/a.zip": ranged(blob)})
            rec = pv.base_record({**lk.make_link("DP15", lk.classify(doi="10.6084/m9.figshare.1"), found_in="tei_bibl", source_file="x", source_line=1)})
            cfg = pv.Config(cache_dir=Path(tmp), max_file_bytes=1_000_000)
            rows, used = pv.list_zip(rec, http, {"path": "a.zip", "url": "https://files.org/a.zip", "size": len(blob)}, cfg, 10_000_000)
        arch = rec["archives"]["a.zip"]
        self.assertEqual(arch["n_members"], 3)
        self.assertLessEqual(used, len(blob) + HttpRangeFile.BLOCK)
        topics = {r["topic"] for r in rows}
        self.assertIn("cleaning_join_dedup", topics)
        self.assertIn("license_citation", topics)
        self.assertTrue(all(r["path"].startswith("a.zip!CMPD/README.txt") for r in rows))


    def test_large_central_directory_is_sampled_not_downloaded(self):
        buf = io.BytesIO()
        with zipfile.ZipFile(buf, "w", zipfile.ZIP_STORED) as zf:
            for i in range(3000):
                zf.writestr(f"projects/p{i:05d}.json", "{}")
        blob = buf.getvalue()
        with tempfile.TemporaryDirectory() as tmp:
            http, _ = client(Path(tmp), {"https://files.org/b.zip": ranged(blob)})
            reader = HttpRangeFile(http, "https://files.org/b.zip", len(blob), 10**9)
            full = remotezip.list_members(reader, budget_bytes=10**9)
            sampled = remotezip.list_members(reader, budget_bytes=1000, sample_bytes=20_000)
        self.assertEqual((full["n_members_declared"], len(full["members"]), full["sampled"]), (3000, 3000, False))
        self.assertTrue(sampled["sampled"])
        self.assertEqual(sampled["n_members_declared"], 3000)
        self.assertLess(len(sampled["members"]), 3000)


class DiscoveryTests(unittest.TestCase):
    def test_follow_rules_and_renamed_repository(self):
        resource = lk.make_link("DP17", lk.classify(url="https://github.com/cont-limno/LAGOS"), found_in="tei_back", source_file="x", source_line=1)
        known = {resource["canonical"]: resource}
        inv = {resource["canonical"]: {"url": resource["url"], "relation": "resource", "depth": 0, "full_name": "cont-limno/LAGOSNE", "discovered": [
            {"kind": "url", "value": "https://github.com/cont-limno/LAGOSNE", "via": "README.md", "line": 3},
            {"kind": "url", "value": "https://github.com/cont-limno/LAGOSUS", "via": "README.md", "line": 4},
            {"kind": "url", "value": "https://github.com/r-lib/actions", "via": ".github/workflows/check.yaml", "line": 9},
            {"kind": "url", "value": "https://github.com/tidyverse/dplyr", "via": "README.md", "line": 5},
            {"kind": "doi", "value": "10.6073/pasta/0c23a789232ab4f92107e26f70a7d8ef", "via": "README.md", "line": 6},
        ]}}
        new = {l["canonical"]: l for l in pl.discovered_links("DP17", inv, {}, known, max_depth=1)}
        self.assertNotIn("github.com/cont-limno/lagosne", new)  # alias of the renamed repo
        self.assertNotIn("github.com/r-lib/actions", new)  # CI config: ignored
        self.assertTrue(new["github.com/cont-limno/lagosus"]["keep"])  # same owner
        self.assertEqual(new["github.com/tidyverse/dplyr"]["drop_reason"], "discovered_third_party_repository_not_followed")
        pasta = new["doi:10.6073/pasta/0c23a789232ab4f92107e26f70a7d8ef"]
        self.assertEqual((pasta["keep"], pasta["relation"], pasta["depth"]), (True, "linked_from_resource", 1))


class EvidenceTests(unittest.TestCase):
    def test_priorities_and_selection(self):
        files = [
            {"path": "README.md", "size": 100},
            {"path": "data/big.csv", "size": 10**9},
            {"path": "scripts/download_data.py", "size": 500},
            {"path": "lib/util.py", "size": 500},
            {"path": "node_modules/x/readme.md", "size": 10},
            {"path": "img/logo.png", "size": 10},
            {"path": "metadata/variables.csv", "size": 1000},
        ]
        chosen = [f["path"] for f in ev.select_files(files, 10, 2_000_000)]
        self.assertEqual(chosen[0], "README.md")
        self.assertLess(chosen.index("scripts/download_data.py"), chosen.index("lib/util.py"))
        self.assertNotIn("data/big.csv", chosen)
        self.assertNotIn("img/logo.png", chosen)
        self.assertNotIn("node_modules/x/readme.md", chosen)
        self.assertIn("metadata/variables.csv", chosen)

    def test_scan_merges_adjacent_lines_and_caps(self):
        lines = ["Lakes with fewer than 3 samples were excluded.", "Records were excluded if flagged.", "", "Unrelated."]
        hits = [h for h in ev.scan_lines(lines, "doc") if h["topic"] == "inclusion_criteria"]
        self.assertEqual(len(hits), 1)
        self.assertEqual((hits[0]["line_start"], hits[0]["line_end"]), (1, 3))
        many = ["was excluded"] + [""] * 3
        self.assertLessEqual(len([h for h in ev.scan_lines(many * 10, "doc", max_per_topic=2) if h["topic"] == "inclusion_criteria"]), 2)

    def test_code_vs_comment_and_notebook(self):
        code = "# Reproject to EPSG:5070 before joining\ngdf = gdf.to_crs(5070)\n"
        hits = ev.scan_document(code, "code")
        kinds = {(h["topic"], h["kind"], bool(h.get("from_comment"))) for h in hits}
        self.assertIn(("spatial_crs", "code", False), kinds)
        self.assertIn(("spatial_crs", "doc", True), kinds)
        nb = json.dumps({"cells": [{"cell_type": "markdown", "source": ["# Data\n", "Downloaded from Qiita"]}, {"cell_type": "code", "source": "train_test_split(X, y)"}]})
        self.assertEqual(ev.notebook_lines(nb)[1], ("cell 1 line 2", "doc", "Downloaded from Qiita"))

    def test_licence_config_and_data_files_are_restricted(self):
        gpl = "Everyone is permitted to copy and distribute verbatim copies.\nPrograms were excluded if they did not comply.\nGNU General Public License"
        self.assertEqual({h["topic"] for h in ev.scan_document(gpl, "doc", topics=ev.topics_for("LICENSE.txt", "doc"))}, {"license_citation"})
        self.assertEqual(ev.topics_for(".github/workflows/ci.yml", "config"), ev.CONFIG_TOPICS)
        self.assertEqual(ev.file_class("datasets/kostic/mapping-orig.txt"), "table")  # data file: header only
        self.assertEqual(ev.priority("datasets/kostic/mapping-orig.txt", 1000), 0)
        self.assertEqual(ev.priority("web/data/tasks.txt", 1000), 86)  # a registry, even under data/

    def test_lfs_and_binary_detection(self):
        self.assertTrue(ev.is_lfs_pointer(b"version https://git-lfs.github.com/spec/v1\noid sha256:..."))
        self.assertTrue(ev.is_binary(b"abc\x00def"))


def github_routes(sha="abc123"):
    api = "https://api.github.com/repos/acme/lakes"
    return {
        api: (200, {}, {"full_name": "acme/lakes", "default_branch": "main", "license": {"spdx_id": "MIT"}, "size": 10, "html_url": "https://github.com/acme/lakes", "created_at": "2017-01-01", "pushed_at": "2020-01-01", "archived": False, "homepage": "https://zenodo.org/records/42"}),
        f"{api}/commits?sha=main&per_page=1": (200, {}, [{"sha": sha, "commit": {"committer": {"date": "2020-01-01T00:00:00Z"}}}]),
        f"{api}/git/trees/{sha}?recursive=1": (200, {}, {"truncated": False, "tree": [
            {"path": "README.md", "type": "blob", "size": 120},
            {"path": "R/lagos_download.R", "type": "blob", "size": 80},
            {"path": "data/huge.rds", "type": "blob", "size": 10**9},
            {"path": "data", "type": "tree"},
        ]}),
        f"{api}/releases?per_page=100": (200, {}, [{"tag_name": "v1.0", "name": "first", "published_at": "2018-01-01"}]),
        f"{api}/tags?per_page=100": (200, {}, [{"name": "v1.0"}]),
        f"https://raw.githubusercontent.com/acme/lakes/{sha}/README.md": (200, {}, "# LAGOS\nData were obtained from state agencies.\nLicense: CC-BY\n"),
        f"https://raw.githubusercontent.com/acme/lakes/{sha}/R/lagos_download.R": (200, {}, "x <- download.file(url)\ny <- st_transform(x, 5070)\n"),
    }


class GithubProviderTests(unittest.TestCase):
    def test_inventory_and_inspect_pin_the_commit(self):
        with tempfile.TemporaryDirectory() as tmp:
            http, session = client(Path(tmp), github_routes())
            cfg = pv.Config(cache_dir=Path(tmp))
            link = lk.make_link("DP17", lk.classify(url="https://github.com/acme/lakes"), found_in="tei_back", source_file="x", source_line=1)
            rec = pv.inventory_link(link, http, cfg)
            self.assertEqual((rec["status"], rec["version_ref"], rec["license"], rec["n_files"]), ("ok", "abc123", "MIT", 3))
            self.assertEqual(rec["discovered"][0]["canonical"], "zenodo.org/records/42")
            result = pv.inspect_record(rec, http, cfg)
            self.assertNotIn("https://raw.githubusercontent.com/acme/lakes/abc123/data/huge.rds", session.calls)
            rows = result["evidence"]
            readme = [r for r in rows if r["path"] == "README.md" and r["topic"] == "sources_origin"]
            self.assertEqual(readme[0]["permalink"], "https://github.com/acme/lakes/blob/abc123/README.md#L1-L3")
            self.assertEqual(readme[0]["version_ref"], "abc123")
            self.assertTrue(any(r["topic"] == "spatial_crs" and r["evidence_kind"] == "code_statement" for r in rows))
            self.assertTrue(any(r["evidence_kind"] == "metadata_field" and r["topic"] == "license_citation" for r in rows))
            self.assertTrue(all(r["review_status"] == "pending" for r in rows))

    def test_rate_limit_falls_back_without_crashing(self):
        with tempfile.TemporaryDirectory() as tmp:
            http, _ = client(Path(tmp), {"https://api.github.com/repos/acme/lakes": (403, {"x-ratelimit-remaining": "0"}, "{}")})
            cfg = pv.Config(cache_dir=Path(tmp), allow_clone=False)
            link = lk.make_link("DP17", lk.classify(url="https://github.com/acme/lakes"), found_in="tei_back", source_file="x", source_line=1)
            self.assertEqual(pv.inventory_link(link, http, cfg)["status"], "rate_limited")


class ComparisonTests(unittest.TestCase):
    def test_statuses(self):
        row = {"id": "DP1", "banque_collection": "B", "collecte_sources": "Agences d'État", "spatial_temporel": "Non spatial"}
        base = {"paper_id": "DP1", "relation": "resource", "path": "p", "line_start": 1, "line_end": 1, "evidence_id": "e"}
        evidence = [
            {**base, "topic": "sources_origin", "source_kind": "repository_doc", "evidence_kind": "documentation_statement"},
            {**base, "topic": "spatial_crs", "source_kind": "repository_code", "evidence_kind": "code_statement"},
            {**base, "topic": "license_citation", "source_kind": "file_listing", "evidence_kind": "file_presence"},
        ]
        papers = {"DP1": {"row": row, "links": {}, "inventory": {}, "inspect": {"x": {"evidence": evidence, "files_log": [{}]}}}}
        table = {c["dimension"]: c for c in rp.comparison_rows(papers, evidence)}
        # "confirmé" needs a human decision; a keyword hit is only a candidate
        self.assertEqual(table["sources_origin"]["statut_auto"], "confirmé dans le dépôt")
        self.assertEqual(table["sources_origin"]["statut_synthese"], "à confirmer (preuve documentaire candidate)")
        self.assertEqual(table["spatial_crs"]["statut_synthese"], "présent mais non documenté")
        self.assertEqual(table["spatial_crs"]["article_statut"], "non décrit")  # "Non spatial" is a negative entry
        self.assertEqual(table["collection_method"]["statut_synthese"], "décrit dans l'article")
        self.assertEqual(table["license_citation"]["statut_synthese"], "non trouvé")  # presence never counts

        review = {("DP1", "sources_origin"): {"decision": "confirmé dans le dépôt"}, ("DP1", "spatial_crs"): {"decision": "non trouvé"}}
        reviewed = {c["dimension"]: c for c in rp.comparison_rows(papers, evidence, review)}
        self.assertEqual((reviewed["sources_origin"]["statut_synthese"], reviewed["sources_origin"]["niveau_preuve"]), ("confirmé dans le dépôt", "relu (revue_humaine.tsv)"))
        self.assertEqual(reviewed["spatial_crs"]["statut_synthese"], "non trouvé")  # the human may overrule the keyword hit

    def test_review_file_keeps_human_columns(self):
        row = {"id": "DP1", "banque_collection": "B"}
        papers = {"DP1": {"row": row, "links": {}, "inventory": {}, "inspect": {}}}
        with tempfile.TemporaryDirectory() as tmp:
            out = Path(tmp)
            comparison = rp.comparison_rows(papers, [])
            rp.write_review(out, comparison, {})
            review = rp.load_review(out)
            review[("DP1", "sources_origin")].update(decision="non trouvé", commentaire="vérifié", proposition_claude="non trouvé")
            review[("DP9", "sources_origin")] = {c: "" for c in rp.REVIEW_COLUMNS} | {"paper_id": "DP9", "dimension": "sources_origin", "decision": "oui"}
            warnings = rp.write_review(out, comparison, review)
            again = rp.load_review(out)
        self.assertEqual((again[("DP1", "sources_origin")]["decision"], again[("DP1", "sources_origin")]["commentaire"]), ("non trouvé", "vérifié"))
        self.assertIn(("DP9", "sources_origin"), again)  # rows of other papers are never dropped
        self.assertTrue(any("DP9" in w for w in warnings))  # "oui" is not an allowed decision


class NewSourcesTests(unittest.TestCase):
    def test_archive_links_are_discovered_and_probed(self):
        rec = pv.base_record(lk.make_link("DP19", lk.classify(url="https://github.com/knights-lab/MLRepo"), found_in="tei_bibl", source_file="x", source_line=1))
        pv.add_discovered(rec, "url", "http://metagenome.cs.umn.edu/public/MLRepo/datasets.tar.gz", "README.md", 5)
        pv.add_discovered(rec, "url", "http://metagenome.cs.umn.edu/public/index.html", "README.md", 6)
        self.assertEqual([d["value"] for d in rec["discovered"]], ["http://metagenome.cs.umn.edu/public/MLRepo/datasets.tar.gz"])
        with tempfile.TemporaryDirectory() as tmp:
            url = "http://lab.org/datasets.tar.gz"
            http, _ = client(Path(tmp), {url: (206, {"content-range": "bytes 0-0/123456", "content-type": "application/x-gzip", "last-modified": "Tue, 01 Jan 2019 00:00:00 GMT"}, b"\x1f")})
            link = lk.make_link("DP19", lk.classify(url=url), found_in="discovered", source_file="x", source_line=1)
            probed = pv.inventory_link(link, http, pv.Config(cache_dir=Path(tmp)))
        self.assertEqual((probed["status"], probed["files"][0]["size"], probed["version_kind"]), ("ok", 123456, "http_last_modified"))

    def test_tar_prefix_listing(self):
        import gzip
        import tarfile

        buf = io.BytesIO()
        with tarfile.open(fileobj=buf, mode="w") as tf:
            for name, data in [("datasets/a/task.txt", b"#SampleID\tVar\n"), ("datasets/b/otutable.txt", os.urandom(20000))]:
                info = tarfile.TarInfo(name)
                info.size = len(data)
                tf.addfile(info, io.BytesIO(data))
        full = gzip.compress(buf.getvalue())
        members, complete = remotezip.list_tar_prefix(full)
        self.assertEqual(([m["path"] for m in members], complete), (["datasets/a/task.txt", "datasets/b/otutable.txt"], True))
        partial, complete = remotezip.list_tar_prefix(full[: len(full) // 2])
        self.assertFalse(complete)
        self.assertEqual(partial[0]["path"], "datasets/a/task.txt")

    def test_spreadsheet_documentation_is_read(self):
        try:
            import openpyxl
        except ImportError:
            self.skipTest("openpyxl not installed")
        wb = openpyxl.Workbook()
        ws = wb.active
        ws.title = "datasets"
        ws.append(["dataset", "format", "source"])
        ws.append(["PSPLIB", ".sm", "Kolisch & Sprecher; instances were excluded if infeasible"])
        buf = io.BytesIO()
        wb.save(buf)
        self.assertEqual(ev.file_class("doc/datasets_info.xlsx"), "spreadsheet")
        self.assertGreater(ev.priority("doc/datasets_info.xlsx", 1000), 0)
        self.assertEqual(ev.priority("data/results_raw.xlsx", 1000), 0)  # data workbooks are not read
        rec = pv.base_record(lk.make_link("DP15", lk.classify(url="https://github.com/a/b"), found_in="tei_back", source_file="x", source_line=1))
        rows, skip = pv.scan_file(rec, "doc/datasets_info.xlsx", buf.getvalue(), source_prefix="repository", permalink_fn=lambda p, a, b: p)
        self.assertIsNone(skip)
        header = [r for r in rows if r["evidence_kind"] == "schema_header"][0]
        self.assertIn("dataset | format | source", header["snippet"])
        self.assertTrue(any(r["topic"] == "inclusion_criteria" and "row 2" in r["location"] for r in rows))

    def test_github_token_read_from_env_file_only(self):
        from datapaper_repo_audit import cli

        saved = {k: os.environ.pop(k, None) for k in cli.TOKEN_KEYS}
        try:
            with tempfile.TemporaryDirectory() as tmp:
                env = Path(tmp) / ".env"
                env.write_text("ANTHROPIC_API_KEY=secret\nGITHUB_TOKEN='abc'\n", encoding="utf-8")
                self.assertEqual(cli.load_github_token(env), ".env")
                self.assertEqual(os.environ["GITHUB_TOKEN"], "abc")
                self.assertNotIn("ANTHROPIC_API_KEY", {k for k in os.environ if os.environ[k] == "secret"})
        finally:
            for k in cli.TOKEN_KEYS:
                os.environ.pop(k, None)
                if saved[k] is not None:
                    os.environ[k] = saved[k]


if __name__ == "__main__":
    unittest.main()
