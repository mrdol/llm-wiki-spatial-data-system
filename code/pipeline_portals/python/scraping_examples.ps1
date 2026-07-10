# Exemples de commandes pour lancer les scrapers institutionnels et scientifiques.
# A lancer depuis la racine du projet :
# C:\Users\jdoliveira\SynologyDrive\johnny D'OLIVEIRA\Travaux stages\llm-wiki-karpathy
#
# Si tu es dans le dossier parent "Travaux stages", ajoute le prefixe :
# llm-wiki-karpathy\


# 1. World Bank
# Cherche des indicateurs World Bank contenant les mots agriculture, climate ou population.
# La structure World Bank est souvent pays x annee x indicateur.
python pipeline_portals\python\scrape_world_bank.py --query "agriculture climate population" --limit 5 --view summary

# Meme recherche avec un affichage JSON lisible.
python pipeline_portals\python\scrape_world_bank.py --query "agriculture climate population" --limit 5 --view summary --pretty

# Sauvegarde les candidats dans data/candidates/world_bank.records.jsonl.
python pipeline_portals\python\scrape_world_bank.py --query "agriculture climate population" --limit 20 --write --view summary --pretty

# Telecharge les fichiers candidats retenus.
# Si un fichier depasse le seuil de 100 MB, le script demande confirmation.
python pipeline_portals\python\scrape_world_bank.py --query "agriculture climate population" --limit 5 --download --view summary --pretty


# 2. Eurostat
# Recherche des donnees europeennes regionales, par exemple emploi/population/region.
python pipeline_portals\python\scrape_eurostat.py --query "employment population region nuts time" --limit 5 --view summary --pretty

# Sauvegarde les candidats Eurostat.
python pipeline_portals\python\scrape_eurostat.py --query "employment population region nuts time" --limit 20 --write --view summary --pretty

# Telecharge les fichiers Eurostat candidats retenus, avec confirmation si lourd.
python pipeline_portals\python\scrape_eurostat.py --query "employment population region nuts time" --limit 5 --download --view summary --pretty


# 3. OECD
# Recherche dans les references OECD, utile surtout pour donnees comparatives internationales.
python pipeline_portals\python\scrape_oecd.py --query "trade commodity country partner annual panel" --limit 5 --view summary --pretty

# Sauvegarde les candidats OECD.
python pipeline_portals\python\scrape_oecd.py --query "trade commodity country partner annual panel" --limit 20 --write --view summary --pretty


# 4. UN Comtrade
# Recherche des donnees commerciales pays x partenaire x produit x annee.
python pipeline_portals\python\scrape_un_comtrade.py --query "trade commodity reporter partner year annual country panel" --limit 5 --view summary --pretty

# Telecharge des fichiers de reference legers, par exemple reporters/partners/classifications.
python pipeline_portals\python\scrape_un_comtrade.py --query "trade commodity reporter partner year annual country panel" --limit 5 --download --view summary --pretty


# 5. data.gouv.fr
# Recherche des donnees publiques francaises avec dimension territoriale.
python pipeline_portals\python\scrape_data_gouv.py --query "agriculture climat population territoire" --max-pages 1 --page-size 10 --limit 5 --view summary --pretty

# Sauvegarde les candidats data.gouv.fr.
python pipeline_portals\python\scrape_data_gouv.py --query "agriculture climat population territoire" --max-pages 2 --page-size 20 --limit 20 --write --view summary --pretty


# 6. INSEE
# Recherche des pages INSEE connues et des pages de recherche INSEE.
python pipeline_portals\python\scrape_insee.py --query "population emploi territoire commune" --max-pages 5 --limit 5 --view summary --pretty

# Telecharge les fichiers candidats INSEE avec confirmation si lourd.
python pipeline_portals\python\scrape_insee.py --query "population emploi territoire commune" --max-pages 5 --limit 5 --download --view summary --pretty


# 7. CEPII
# Scrape les pages CEPII connues dans le catalogue local, par exemple BACI.
python pipeline_portals\python\scrape_cepii.py --query "baci gravity geodist trade country year distance" --limit 5 --view summary --pretty

# Telecharge les fichiers candidats CEPII avec confirmation si lourd.
python pipeline_portals\python\scrape_cepii.py --query "baci gravity geodist trade country year distance" --limit 5 --download --view summary --pretty


# 8. Entrepots scientifiques
# Zenodo : recherche de datasets avec signaux spatiaux/spatio-temporels.
python pipeline_portals\python\scrape_zenodo.py --query "spatiotemporal spatial panel data" --max-pages 1 --limit 5 --view summary --pretty

# Figshare.
python pipeline_portals\python\scrape_figshare.py --query "spatiotemporal spatial panel data" --max-pages 1 --limit 5 --view summary --pretty

# Dataverse.
python pipeline_portals\python\scrape_dataverse.py --query "spatiotemporal spatial panel data" --max-pages 1 --limit 5 --view summary --pretty

# Dryad.
python pipeline_portals\python\scrape_dryad.py --query "spatiotemporal spatial panel data" --max-pages 1 --limit 5 --view summary --pretty


# 9. Enrichissement par papiers scientifiques
# --enrich-paper cherche les DOI associes puis recupere les abstracts via OpenAlex quand possible.
# --mailto est optionnel mais recommande pour les appels OpenAlex.
python pipeline_portals\python\scrape_zenodo.py --query "spatiotemporal spatial panel data" --max-pages 1 --limit 5 --enrich-paper --mailto "ton.email@example.com" --view summary --pretty


# 10. Generer seulement le plan local sans scraper le web
# Utile pour voir quelles URLs du catalogue local seront utilisees comme points de depart.
python pipeline_portals\python\scrape_world_bank.py --plan --limit 5 --pretty
python pipeline_portals\python\scrape_eurostat.py --plan --limit 5 --pretty
python pipeline_portals\python\scrape_oecd.py --plan --limit 5 --pretty
python pipeline_portals\python\scrape_un_comtrade.py --plan --limit 5 --pretty


# 11. Changer le seuil de fichier lourd
# Ici le script demande confirmation si un fichier depasse 50 MB.
python pipeline_portals\python\scrape_data_gouv.py --query "population territoire" --limit 5 --download --heavy-threshold-mb 50 --view summary --pretty

# Ici le script ne demande pas confirmation et accepte les fichiers lourds.
# A utiliser seulement si tu es certain de vouloir telecharger.
python pipeline_portals\python\scrape_data_gouv.py --query "population territoire" --limit 5 --download --yes-heavy --view summary --pretty
