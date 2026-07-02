#!/usr/bin/env python3
"""Telecharge les PDF en libre acces pour les jeux spatiaux sans papier KG.

A LANCER SUR TA MACHINE (pas dans le bac a sable) :
    python corpus/papers/download_oa_papers.py

Les PDF atterrissent dans corpus/papers/raw_pdf/ ; ensuite :
    docker run --rm -p 8070:8070 lfoppiano/grobid:latest-crf   # si pas deja lance
    python tools/kg/02_run_grobid.py --workers 8
    python tools/kg/run_all.py
"""
from __future__ import annotations
import sys, urllib.request
from pathlib import Path

OUT = Path(__file__).resolve().parent / "raw_pdf"

# (nom_fichier, [urls a essayer dans l'ordillon], jeux concernes)
PAPERS = [
    ("Gollini_2015_GWmodel_JSS.pdf",
     ["https://www.jstatsoft.org/index.php/jss/article/view/v063i17/v63i17.pdf",
      "https://research-information.bris.ac.uk/ws/files/85724436/v63i17.pdf",
      "https://arxiv.org/pdf/1306.0413"],
     "GWmodel: Georgia, USelect, London, DubVoter, EWHP"),
    ("Lu_2014_GWmodel_further_topics.pdf",
     ["https://arxiv.org/pdf/1312.2753"],
     "GWmodel (topics avances)"),
    ("Graler_2016_gstat_spatiotemporal_RJournal.pdf",
     ["https://journal.r-project.org/articles/RJ-2016-014/RJ-2016-014.pdf"],
     "gstat::DE_RB_2005 (PM10 ST)"),
    ("Pebesma_2012_spacetime_JSS.pdf",
     ["https://www.jstatsoft.org/index.php/jss/article/view/v051i07/v51i07.pdf"],
     "gstat::DE_RB_2005 (classes spacetime)"),
    ("Kolak_2020_neighborhood_SDOH_JAMANetworkOpen.pdf",
     ["https://europepmc.org/backend/ptpmcrender.fcgi?accid=PMC6991288&blobtype=pdf",
      "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6991288/pdf/main.pdf"],
     "us_sdoh, chicagoSDOH"),
]

UA = {"User-Agent": "Mozilla/5.0 (compatible; llm-wiki-karpathy/1.0)"}

def fetch(url: str, dest: Path) -> bool:
    req = urllib.request.Request(url, headers=UA)
    with urllib.request.urlopen(req, timeout=60) as r:
        data = r.read()
    if not data[:4] == b"%PDF":
        # certaines pages renvoient du HTML : on rejette
        return False
    dest.write_bytes(data)
    return True

def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    ok = fail = 0
    for name, urls, datasets in PAPERS:
        dest = OUT / name
        if dest.exists():
            print(f"[skip] {name} (deja present)"); continue
        done = False
        for url in urls:
            try:
                if fetch(url, dest):
                    print(f"[ok]   {name}  <-  {url}   ({datasets})")
                    ok += 1; done = True; break
                else:
                    print(f"[warn] non-PDF: {url}")
            except Exception as e:
                print(f"[warn] echec {url} : {e}")
        if not done:
            fail += 1
            print(f"[FAIL] {name} : a telecharger manuellement ({datasets})")
    print(f"\nTermine. PDF recuperes: {ok} | echecs: {fail}")
    print("Note: certains editeurs (Wiley, Routledge) ne sont pas en libre acces "
          "-> Baller 2001, Kopczewska, livres GWR/Anselin a recuperer via ta bibliotheque.")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
