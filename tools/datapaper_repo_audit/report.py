"""Write the four audit outputs from the per-paper state.

``manifest.tsv``                        one row per paper x link (and one per paper without link)
``evidence.jsonl``                      one sourced observation per line
``comparaison_methodes_collecte.tsv``   paper x dimension status table
``rapport.md``                          readable synthesis (+ ``synthese_pilote.md`` if present)
"""

from __future__ import annotations

import csv
import json
import os
import re
from collections import Counter, defaultdict
from pathlib import Path

from . import evidence as ev
from .netcache import now_iso
from .pipeline import TOOL_VERSION, State

DOC_KINDS = {"documentation_statement", "metadata_field"}
CODE_KINDS = {"code_statement", "code_comment", "schema_header"}
NEGATIVE_RE = re.compile(r"^\s*(non\b|aucun|pas\b|—|-|unknown|n/?a\b|non renseign)", re.I)

MANIFEST_COLUMNS = [
    "paper_id", "banque", "paper_doi", "tei_file", "link_id", "relation", "depth", "parent", "provider", "role_guess",
    "url", "canonical", "found_in", "also_found_in", "source_file", "source_line", "section", "context", "keep", "drop_reason",
    "status", "http_status", "access_mode", "resolved_url", "title", "license", "version_kind", "version_ref", "version_date",
    "n_files", "total_bytes", "sizes_complete", "largest_file", "formats", "archives", "releases_tags", "key_files_present",
    "inspected", "n_files_read", "n_evidence", "notes", "inventoried_at", "inspected_at",
]
COMPARISON_COLUMNS = [
    "paper_id", "banque", "volet", "dimension", "libelle", "article_statut", "article_source", "n_preuves_article",
    "depot_statut", "n_preuves_doc", "n_preuves_code", "statut_auto", "statut_synthese", "niveau_preuve", "preuves_exemples", "extrait_grille",
]
CACHE_WARN_BYTES = 1024**3  # user's threshold: move the cache out of Synology Drive beyond 1 GB


def _fmt_bytes(n) -> str:
    if n in (None, ""):
        return ""
    n = float(n)
    for unit in ("o", "Ko", "Mo", "Go", "To"):
        if n < 1024 or unit == "To":
            return f"{n:.0f} {unit}" if unit == "o" else f"{n:.1f} {unit}"
        n /= 1024
    return ""


def _archive_label(name: str, info: dict) -> str:
    if "error" in info:
        return f"{name}: listage impossible ({info['error'][:60]})"
    if info.get("sampled"):
        return f"{name}: {info.get('n_members')} membres déclarés, liste échantillonnée ({info.get('n_listed')} premiers)"
    return f"{name}: {info.get('n_members')} membres, {_fmt_bytes(info.get('uncompressed_bytes'))} décompressés"


def _cell(value) -> str:
    if value is None:
        return ""
    if isinstance(value, (list, dict)):
        value = json.dumps(value, ensure_ascii=False)
    return re.sub(r"[\t\r\n]+", " ", str(value))


def _dir_size(path: Path) -> int:
    total = 0
    for base, _dirs, files in os.walk(path):
        for f in files:
            try:
                total += (Path(base) / f).stat().st_size
            except OSError:
                pass
    return total


def collect(state: State, rows: list[dict]) -> dict:
    papers = {}
    for row in rows:
        pid = row["id"]
        papers[pid] = {
            "row": row,
            "links": state.load("links", pid),
            "inventory": state.load("inventory", pid),
            "inspect": state.load("inspect", pid),
        }
    return papers


def manifest_rows(papers: dict) -> list[dict]:
    out = []
    for pid, p in papers.items():
        links = p["links"].get("links", [])
        kept = [l for l in links if l["keep"]]
        base = {"paper_id": pid, "banque": p["row"].get("banque_collection"), "paper_doi": p["links"].get("paper_doi"), "tei_file": p["links"].get("tei_file")}
        if not kept:
            out.append({**base, "status": "no_link_found" if p["links"] else "not_extracted", "notes": "; ".join(p["links"].get("notes", []))})
        for l in links:
            if not l["keep"] and l["found_in"] != "discovered" and l.get("drop_reason") not in ("manual_exclusion (seeds.tsv)",):
                continue  # dropped bibliography noise: counted in the report, not listed
            rec = p["inventory"].get(l["canonical"], {})
            insp = p["inspect"].get(l["canonical"], {})
            log = insp.get("files_log", [])
            archives = insp.get("archives") or rec.get("archives") or {}
            out.append({
                **base,
                "link_id": l["link_id"], "relation": l.get("relation"), "depth": l.get("depth"), "parent": l.get("parent"),
                "provider": rec.get("provider") or l["provider"], "role_guess": l.get("role_guess"), "url": l["url"], "canonical": l["canonical"],
                "found_in": l["found_in"], "also_found_in": ", ".join(l.get("also_found_in", [])), "source_file": l.get("source_file"),
                "source_line": l.get("source_line"), "section": l.get("section"), "context": (l.get("context") or "")[:250],
                "keep": l["keep"], "drop_reason": l.get("drop_reason"),
                "status": rec.get("status") or ("not_followed" if not l["keep"] else "not_inventoried"),
                "http_status": rec.get("http_status"), "access_mode": rec.get("access_mode"), "resolved_url": rec.get("resolved_url"),
                "title": rec.get("title"), "license": rec.get("license"), "version_kind": rec.get("version_kind"),
                "version_ref": rec.get("version_ref"), "version_date": rec.get("version_date"), "n_files": rec.get("n_files"),
                "total_bytes": rec.get("total_bytes"), "sizes_complete": rec.get("sizes_complete"),
                "largest_file": rec.get("largest_file"), "formats": rec.get("formats"),
                "archives": {k: {kk: v.get(kk) for kk in ("n_members", "sampled", "n_listed", "central_directory_bytes", "uncompressed_bytes", "formats", "top_dirs", "error") if v.get(kk) is not None} for k, v in archives.items()},
                "releases_tags": f"{len(rec.get('releases', []))} releases / {len(rec.get('tags', []))} tags" if rec else "",
                "key_files_present": ", ".join(rec.get("key_files_present", [])[:15]),
                "inspected": bool(insp), "n_files_read": sum(1 for x in log if x.get("status") == "read"),
                "n_evidence": len(insp.get("evidence", [])), "notes": "; ".join((l.get("notes") or []) + (rec.get("notes") or []))[:600],
                "inventoried_at": rec.get("inventoried_at"), "inspected_at": insp.get("inspected_at"),
            })
    return out


def all_evidence(papers: dict) -> list[dict]:
    rows = []
    for pid, p in papers.items():
        rows += p["links"].get("article_evidence", [])
        relation = {l["canonical"]: l.get("relation") for l in p["links"].get("links", [])}
        for canonical, insp in p["inspect"].items():
            for r in insp.get("evidence", []):
                rows.append({**r, "relation": relation.get(canonical)})
    return rows


def article_status(row: dict, columns: list[str]) -> tuple[bool, str, str]:
    texts = [(c, (row.get(c) or "").strip()) for c in columns]
    good = [(c, t) for c, t in texts if t and not NEGATIVE_RE.match(t)]
    return bool(good), ", ".join(c for c, _ in good), " || ".join(t for _, t in good)[:300]


REVIEW_FILE = "revue_humaine.tsv"
REVIEW_COLUMNS = [
    "paper_id", "banque", "volet", "dimension", "libelle", "statut_auto", "n_preuves_doc", "n_preuves_code",
    "preuves_a_lire", "proposition_claude", "justification_claude", "decision", "commentaire", "relu_le",
]
REVIEW_KEEP = ("proposition_claude", "justification_claude", "decision", "commentaire", "relu_le")
DECISIONS = {"confirmé dans le dépôt", "présent mais non documenté", "décrit dans l'article", "non trouvé"}
COUNTED_RELATIONS = {"resource", "linked_from_resource"}


def load_review(out: Path) -> dict[tuple[str, str], dict]:
    path = out / REVIEW_FILE
    if not path.exists():
        return {}
    with path.open(encoding="utf-8-sig", newline="") as stream:
        return {(r["paper_id"], r["dimension"]): r for r in csv.DictReader(stream, delimiter="\t")}


def write_review(out: Path, comparison: list[dict], review: dict) -> list[str]:
    """Refresh the automatic columns; never touch the human/Claude columns.

    Rows of papers not in this run are kept as they are. Returns warnings
    about decisions that are not one of the four allowed statuses.
    """
    rows = dict(review)
    for c in comparison:
        key = (c["paper_id"], c["dimension"])
        old = review.get(key, {})
        rows[key] = {
            "paper_id": c["paper_id"], "banque": c["banque"], "volet": c["volet"], "dimension": c["dimension"], "libelle": c["libelle"],
            "statut_auto": c["statut_auto"], "n_preuves_doc": c["n_preuves_doc"], "n_preuves_code": c["n_preuves_code"],
            "preuves_a_lire": c["preuves_exemples"], **{k: old.get(k, "") for k in REVIEW_KEEP},
        }
    write_tsv(out / REVIEW_FILE, REVIEW_COLUMNS, [rows[k] for k in sorted(rows)])
    return [f"{k[0]}/{k[1]}: décision « {r['decision']} » non reconnue" for k, r in sorted(rows.items()) if r.get("decision") and r["decision"].strip() not in DECISIONS]


def comparison_rows(papers: dict, evidence: list[dict], review: dict | None = None) -> list[dict]:
    """Paper x dimension table.

    Evidence of the resources named by the paper and of resources linked from
    them is counted. ``confirmé dans le dépôt`` is only granted by a human
    decision in ``revue_humaine.tsv``; until then a documentary keyword hit
    reads ``à confirmer (preuve documentaire candidate)``.
    """
    review = review or {}
    by = defaultdict(list)
    for e in evidence:
        by[(e["paper_id"], e["topic"])].append(e)
    out = []
    for pid, p in papers.items():
        inspected = any(i.get("evidence") or i.get("files_log") for i in p["inspect"].values())
        for topic, volet, label, cols in ev.DIMENSIONS:
            described, source, excerpt = article_status(p["row"], cols)
            items = by.get((pid, topic), [])
            art = [e for e in items if e["source_kind"] == "article_tei"]
            repo = [e for e in items if e["source_kind"] != "article_tei" and e.get("relation") in COUNTED_RELATIONS]
            repo.sort(key=lambda e: e.get("relation") != "resource")  # the paper's own resources first
            doc = [e for e in repo if e["evidence_kind"] in DOC_KINDS]
            code = [e for e in repo if e["evidence_kind"] in CODE_KINDS]
            if not inspected:
                depot = "aucun dépôt inspecté"
            elif doc:
                depot = "documenté dans le dépôt"
            elif code:
                depot = "code seulement"
            else:
                depot = "non trouvé"
            if doc:
                auto = "confirmé dans le dépôt"
            elif code:
                auto = "présent mais non documenté"
            elif described:
                auto = "décrit dans l'article"
            else:
                auto = "non trouvé"
            decision = (review.get((pid, topic), {}).get("decision") or "").strip()
            if decision in DECISIONS:
                synth, level = decision, "relu (revue_humaine.tsv)"
            elif auto == "confirmé dans le dépôt":
                synth, level = "à confirmer (preuve documentaire candidate)", "automatique (mots-clés, à relire)"
            else:
                synth, level = auto, "automatique (mots-clés, à relire)"
            examples = []
            for e in (doc or code)[:5]:
                where = e["path"] if not e.get("line_start") else f"{e['path']}:{e['line_start']}-{e['line_end']}"
                if e.get("location"):
                    where += f" [{e['location']}]"
                tag = "" if e.get("relation") == "resource" else " (lien depuis une ressource)"
                examples.append(f"{e['evidence_id']} {where}{tag}")
            out.append({
                "paper_id": pid, "banque": p["row"].get("banque_collection"), "volet": volet, "dimension": topic, "libelle": label,
                "article_statut": "décrit (grille)" if described else ("mention TEI à relire" if art else "non décrit"),
                "article_source": source or ("TEI" if art else ""), "n_preuves_article": len(art),
                "depot_statut": depot, "n_preuves_doc": len(doc), "n_preuves_code": len(code),
                "statut_auto": auto, "statut_synthese": synth, "niveau_preuve": level,
                "preuves_exemples": " | ".join(examples), "extrait_grille": excerpt,
            })
    return out


def write_tsv(path: Path, columns: list[str], rows: list[dict]) -> None:
    with path.open("w", encoding="utf-8", newline="") as stream:
        w = csv.writer(stream, delimiter="\t", lineterminator="\n")
        w.writerow(columns)
        for r in rows:
            w.writerow([_cell(r.get(c)) for c in columns])


def _pilot_sections(out: Path) -> str:
    path = out / "synthese_pilote.md"
    return path.read_text(encoding="utf-8") if path.exists() else ""


def render_report(out: Path, cache: Path, state: State, papers: dict, manifest: list[dict], evidence: list[dict], comparison: list[dict], warnings: list[str] | None = None) -> str:
    runs = state.load("meta", "runs", default={"runs": []})["runs"]
    lines = [
        "# Audit des dépôts associés aux data papers",
        "",
        f"_Généré le {now_iso()} par `tools/audit_datapaper_repositories.py` (v{TOOL_VERSION}). "
        "Analyse **statique** : aucun code tiers n'a été exécuté, aucun fichier de données volumineux ni objet Git LFS n'a été téléchargé._",
        "",
        "> Statut : **proposition automatique, relecture humaine requise**. Chaque preuve de `evidence.jsonl` porte "
        "`review_status: pending`. Les correspondances par mots-clés (`confidence: keyword_match`) localisent les passages à lire ; "
        "elles ne valent pas confirmation. La présence d'un fichier (`file_presence`) n'est jamais comptée comme documentation.",
        "",
        "## Périmètre et volumes",
        "",
        "| Article | Banque | Liens retenus | Ressources inspectées | Statuts | Preuves dépôt (doc / code) | Preuves article |",
        "|---|---|---|---|---|---|---|",
    ]
    for pid, p in papers.items():
        kept = [m for m in manifest if m["paper_id"] == pid and m.get("keep")]
        statuses = Counter(m.get("status") for m in kept)
        ev_p = [e for e in evidence if e["paper_id"] == pid]
        doc = sum(1 for e in ev_p if e["source_kind"] != "article_tei" and e["evidence_kind"] in DOC_KINDS and e.get("relation") in COUNTED_RELATIONS)
        code = sum(1 for e in ev_p if e["source_kind"] != "article_tei" and e["evidence_kind"] in CODE_KINDS and e.get("relation") in COUNTED_RELATIONS)
        art = sum(1 for e in ev_p if e["source_kind"] == "article_tei")
        n_insp = sum(1 for m in kept if m.get("inspected"))
        lines.append(f"| {pid} | {p['row'].get('banque_collection')} | {len(kept)} | {n_insp} | {', '.join(f'{k}: {v}' for k, v in statuses.items())} | {doc} / {code} | {art} |")

    for pid, p in papers.items():
        lines += ["", f"## {pid} — {p['row'].get('banque_collection')}", ""]
        doi = p["links"].get("paper_doi")
        lines.append(f"Article : DOI `{doi or 'unknown'}` — TEI `{p['links'].get('tei_file') or 'absent'}`.")
        links = p["links"].get("links", [])
        dropped = Counter(l.get("drop_reason") for l in links if not l["keep"] and l["found_in"] != "discovered")
        if dropped:
            lines.append("Liens écartés à l'extraction : " + ", ".join(f"{k} ({v})" for k, v in dropped.items()) + ".")
        lines += ["", "| Relation | Fournisseur | Ressource | Statut | Version examinée | Fichiers / volume | Licence |", "|---|---|---|---|---|---|---|"]
        for m in [m for m in manifest if m["paper_id"] == pid and m.get("link_id")]:
            if not m.get("keep"):
                continue
            vol = f"{m.get('n_files') or 0} fichiers, {_fmt_bytes(m.get('total_bytes'))}" if m.get("n_files") else ""
            if m.get("archives"):
                vol += " (" + "; ".join(_archive_label(k, v) for k, v in m["archives"].items()) + ")"
            version = f"{m.get('version_kind') or ''} `{(m.get('version_ref') or '')[:60]}` {m.get('version_date') or ''}".strip()
            depth = f" (profondeur {m['depth']})" if m.get("depth") else ""
            lines.append(f"| {m.get('relation')}{depth} | {m.get('provider')} | {m['url']} | {m.get('status')} | {version} | {vol} | {m.get('license') or 'unknown'} |")
        problems = [m for m in manifest if m["paper_id"] == pid and m.get("keep") and m.get("status") not in ("ok", None)]
        if problems:
            lines += ["", "**Accès refusés, liens morts ou incomplets** :"]
            for m in problems:
                lines.append(f"- `{m['status']}` — {m['url']} — {m.get('notes') or ''}")
        lines += ["", "| Volet | Dimension | Article | Dépôt | Synthèse |", "|---|---|---|---|---|"]
        for c in [c for c in comparison if c["paper_id"] == pid]:
            lines.append(f"| {c['volet']} | {c['libelle']} | {c['article_statut']} | {c['depot_statut']} ({c['n_preuves_doc']}/{c['n_preuves_code']}) | **{c['statut_synthese']}** |")
        unknown = [c["libelle"] for c in comparison if c["paper_id"] == pid and c["statut_synthese"] == "non trouvé"]
        if unknown:
            lines += ["", "Inconnu (ni article ni dépôt) : " + "; ".join(unknown) + "."]

    pilot = _pilot_sections(out)
    if pilot:
        lines += ["", "---", "", pilot.strip()]

    if warnings:
        lines += ["", "## Avertissements", ""] + [f"- {w}" for w in warnings]

    size_cache = _dir_size(cache) if cache.exists() else 0
    size_git = _dir_size(cache / "git") if (cache / "git").exists() else 0
    last = runs[-1] if runs else {}
    lines += [
        "",
        "## Reproductibilité, reprise et disque",
        "",
        f"- Cache : `{cache.relative_to(out).as_posix() + '/' if cache.is_relative_to(out) else cache}` = {_fmt_bytes(size_cache)} (dont clones Git partiels {_fmt_bytes(size_git)}); ignoré par Git (`.gitignore` local). "
        "Sur un dossier synchronisé (Synology Drive), `--cache-dir` permet de le placer hors synchronisation.",
        f"- Dernière commande : `{' '.join(last.get('argv', []))}` ({last.get('network_calls', 0)} appels réseau, hôtes bloqués : {last.get('blocked_hosts') or 'aucun'}).",
        "- Reprise après interruption : relancer **la même commande** ; les ressources terminées sont sautées, seules les erreurs transitoires "
        "(`rate_limited`, `error`, `cache_miss`) sont retentées. `--offline` rejoue l'analyse depuis le cache sans réseau ; `--refresh` force la mise à jour.",
        "- Les versions examinées (commit, DOI de version, révision) sont dans `manifest.tsv` (`version_ref`) et dans chaque preuve (`version_ref`, `permalink`).",
        "- Corrections manuelles de liens : `seeds.tsv` (colonnes `paper_id`, `url`, `role`, `note`; `role=exclude` retire un lien), tracées `found_in=manual_seed`.",
        "",
        "## Précautions d'interprétation",
        "",
        "- `confirmé dans le dépôt` n'est accordé **que par une décision humaine** dans `revue_humaine.tsv` (colonne `decision`) ; "
        "avant relecture, un passage documentaire ou un champ d'API trouvé par mots-clés s'affiche `à confirmer (preuve documentaire candidate)`. "
        "`présent mais non documenté` = seulement du code, des commentaires de code ou des en-têtes de tableaux ; "
        "`décrit dans l'article` = renseigné dans la grille comparative (lecture intégrale) sans trace dans le dépôt ; `non trouvé` = aucun des deux.",
        "- `revue_humaine.tsv` n'est jamais écrasé : seules ses colonnes automatiques (`statut_auto`, comptes, `preuves_a_lire`) sont rafraîchies.",
        "- Les dépôts cités en bibliographie sans lien avec la section de disponibilité (`cited_deposit`) sont inventoriés mais non lus. "
        "Les ressources atteintes par un lien depuis une ressource (`linked_from_resource`, profondeur 1) sont lues et **comptées** dans la comparaison ; "
        "elles peuvent être des sources amont, et leurs preuves sont marquées « (lien depuis une ressource) » dans `preuves_exemples`.",
        "- Aucune matrice de voisinage `W` construite par notre projet n'est attribuée aux auteurs : seules comptent les preuves trouvées dans leurs propres dépôts.",
        "- Toute exécution future de code tiers devra être une option distincte, désactivée par défaut, dans un environnement isolé (conteneur sans secrets ni réseau sortant).",
    ]
    return "\n".join(lines) + "\n"


def build(out: Path, rows: list[dict], cache_dir: Path | None = None) -> dict:
    cache_dir = cache_dir or out / "cache"
    state = State(cache_dir)
    papers = collect(state, rows)
    manifest = manifest_rows(papers)
    evidence = all_evidence(papers)
    out.mkdir(parents=True, exist_ok=True)
    review = load_review(out)
    comparison = comparison_rows(papers, evidence, review)
    warnings = write_review(out, comparison, review)
    size_cache = _dir_size(cache_dir) if cache_dir.exists() else 0
    if size_cache > CACHE_WARN_BYTES:
        warnings.append(f"cache {_fmt_bytes(size_cache)} > 1 Go : le déplacer hors de Synology Drive avec --cache-dir")
    write_tsv(out / "manifest.tsv", MANIFEST_COLUMNS, manifest)
    with (out / "evidence.jsonl").open("w", encoding="utf-8", newline="\n") as stream:
        for e in sorted(evidence, key=lambda e: (e["paper_id"], e["source_kind"] != "article_tei", e["topic"], e["path"] or "", e.get("line_start") or 0)):
            stream.write(json.dumps(e, ensure_ascii=False) + "\n")
    write_tsv(out / "comparaison_methodes_collecte.tsv", COMPARISON_COLUMNS, comparison)
    (out / "rapport.md").write_text(render_report(out, cache_dir, state, papers, manifest, evidence, comparison, warnings), encoding="utf-8")
    gitignore = out / ".gitignore"
    if not gitignore.exists():
        gitignore.write_text("cache/\n", encoding="utf-8")
    return {"manifest": len(manifest), "evidence": len(evidence), "comparison": len(comparison), "warnings": warnings}
