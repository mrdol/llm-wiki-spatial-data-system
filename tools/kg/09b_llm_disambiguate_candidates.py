"""Desambiguise par LLM les candidats prioritaires de l'audit TEI (theorie vs empirique).

Etape hybride optionnelle du pipeline KG. Le filtre a mots-cles
(`section_role.py`) reste le premier passage, gratuit, sur l'ensemble du
corpus (~4000 lignes d'audit). Ce script n'appelle Claude que sur les
candidats qui ont deja franchi le seuil d'une action prioritaire
(`review_for_dataset_use` / `review_for_model_evidence`), c'est-a-dire la
zone ou un faux positif coute le plus cher a un relecteur humain (voir
`wiki/analyses/model_evidence_candidates_review_2026-08.md`, ex. un chapitre
theorique d'Anselin 1988 qui franchit le score malgre l'absence de dataset
empirique).

Les verdicts sont mis en cache par candidat (hash paper_id + section_id +
debut du texte) pour ne jamais repayer un appel API sur un candidat
inchange d'un run a l'autre.

Usage:
    python tools/kg/09b_llm_disambiguate_candidates.py
    python tools/kg/09b_llm_disambiguate_candidates.py --limit 20   # test rapide

Necessite ANTHROPIC_API_KEY (dans .env ou l'environnement). Si absente, le
script s'arrete proprement sans rien casser : `10_make_audit_candidate_review.py`
retombe alors sur le seul score a mots-cles.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import time
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from audit_reader import (  # noqa: E402
    LLM_DISAMBIGUATION_CACHE,
    audit_candidate_kind,
    candidate_key,
    is_priority_candidate,
    load_llm_disambiguation_cache,
    read_model_evidence_audit,
)

try:
    from dotenv import load_dotenv

    load_dotenv(ROOT / ".env", override=True)
except ImportError:
    pass

DEFAULT_MODEL = os.environ.get("EVAL_MODEL", "claude-haiku-4-5-20251001")

PROMPT = """Tu evalues un extrait candidat issu de l'audit automatique d'un papier scientifique de spatial econometrics/spatial statistics.

Question : cet extrait decrit-il une utilisation EMPIRIQUE reelle d'un jeu de donnees DANS CE PAPIER (dataset nomme ou identifiable, observations concretes, source de donnees, application a un cas d'etude precis) -- ou s'agit-il d'une exposition THEORIQUE/METHODOLOGIQUE generique (definitions, cadre general, revue de litterature, chapitre de manuel, simulation Monte Carlo sans dataset reel) ?

Titre de section/tableau : {section_title}

Extrait :
{candidate_text}

Reponds uniquement en JSON valide, sans texte autour :
{{"verdict": "empirical", "confidence": 0.0, "reasoning": "courte justification en francais"}}

verdict doit valoir exactement "empirical", "theoretical" ou "uncertain".
"""


def save_cache(path: Path, cache: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(cache, ensure_ascii=False, indent=1, sort_keys=True), encoding="utf-8")


def call_judge(section_title: str, candidate_text: str) -> dict[str, Any]:
    import anthropic

    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        raise RuntimeError("ANTHROPIC_API_KEY is not set")

    client = anthropic.Anthropic(api_key=api_key)
    prompt = PROMPT.format(section_title=section_title or "", candidate_text=(candidate_text or "")[:2000])
    response = client.messages.create(
        model=DEFAULT_MODEL,
        max_tokens=300,
        messages=[{"role": "user", "content": prompt}],
    )
    raw_text = (response.content[0].text or "").strip()
    match = re.search(r"\{[\s\S]+\}", raw_text)
    if not match:
        raise ValueError(f"Reponse non parseable: {raw_text[:200]}")
    data = json.loads(match.group())
    verdict = data.get("verdict")
    if verdict not in {"empirical", "theoretical", "uncertain"}:
        verdict = "uncertain"
    return {
        "verdict": verdict,
        "confidence": float(data.get("confidence") or 0.0),
        "reasoning": str(data.get("reasoning") or ""),
    }


def main() -> None:
    parser = argparse.ArgumentParser(description="Desambiguise par LLM les candidats prioritaires (theorie vs empirique).")
    parser.add_argument("--limit", type=int, default=None, help="Limiter le nombre d'appels API (utile pour tester).")
    parser.add_argument("--sleep", type=float, default=0.3, help="Pause en secondes entre deux appels.")
    args = parser.parse_args()

    rows = read_model_evidence_audit()
    priority_rows = [r for r in rows if is_priority_candidate(r)]
    cache = load_llm_disambiguation_cache()

    uncached = [r for r in priority_rows if candidate_key(r) not in cache]
    to_call = uncached[: args.limit] if args.limit is not None else uncached

    print(f"candidats prioritaires (mots-cles) : {len(priority_rows)}")
    print(f"deja en cache : {len(priority_rows) - len(uncached)}")
    print(f"a appeler cette fois : {len(to_call)}")

    if not to_call:
        print("rien a faire.")
        return
    if not os.environ.get("ANTHROPIC_API_KEY"):
        print("ANTHROPIC_API_KEY absente : desambiguisation LLM non executee.")
        print("10_make_audit_candidate_review.py retombera sur le seul score a mots-cles.")
        return

    errors = 0
    for index, row in enumerate(to_call, start=1):
        key = candidate_key(row)
        text = row.get("candidate_text") or row.get("table_caption") or ""
        try:
            verdict = call_judge(row.get("section_title") or "", text)
            cache[key] = {
                **verdict,
                "paper_id": row.get("paper_id"),
                "paper_title": row.get("paper_title"),
                "section_id": row.get("section_id"),
                "section_title": row.get("section_title"),
                "kind": audit_candidate_kind(row),
                "keyword_score": row.get("priority_score"),
                "model": DEFAULT_MODEL,
            }
            print(f"[{index}/{len(to_call)}] {verdict['verdict']:>11} ({verdict['confidence']:.2f}) {row.get('section_title')!r}")
        except Exception as exc:
            errors += 1
            print(f"[{index}/{len(to_call)}] ERREUR: {exc}")
        if index % 20 == 0:
            save_cache(LLM_DISAMBIGUATION_CACHE, cache)
        time.sleep(args.sleep)

    save_cache(LLM_DISAMBIGUATION_CACHE, cache)
    print(f"cache: {LLM_DISAMBIGUATION_CACHE}")
    print(f"erreurs: {errors}")


if __name__ == "__main__":
    main()
