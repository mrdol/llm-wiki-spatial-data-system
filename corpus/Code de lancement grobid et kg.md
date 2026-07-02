# 1. Récupérer les PDF open access (JSS, R Journal, Europe PMC)
python corpus/papers/download_oa_papers.py

# 2. GROBID (s'il n'est pas déjà lancé — ton conteneur l'est)
#    puis traiter en parallèle :
python tools/kg/02_run_grobid.py --workers 8

# 3. Reconstruire le KG
python tools/kg/run_all.py