# LLM Wiki Spatial Data System

Prototype de systeme de decouverte, documentation et preparation de jeux de
donnees spatiaux et spatio-temporels pour comparer des modeles predictifs.

Le projet combine quatre couches qui s'alimentent mutuellement :

- un corpus scientifique et documentaire ;
- un knowledge graph local ;
- un wiki maintenu et valide ;
- des pipelines de collecte, inspection et evaluation.

## Objectif

L'objectif est de construire progressivement une banque de jeux de donnees
spatiaux et spatio-temporels reutilisable pour tester des estimateurs dans des
conditions comparables.

Un dataset ideal contient :

- une structure spatiale explicite : coordonnees, geometrie, voisinage ou unite
  territoriale ;
- une structure temporelle si le probleme est spatio-temporel ;
- une variable reponse `Y` identifiable ;
- des covariables candidates `X_candidate` ;
- une formule ou un modele deja utilise dans un papier, un livre, une
  documentation ou un code ;
- une licence et une source reutilisables ;
- un lien clair vers un papier, un depot de donnees ou une documentation.

## Familles de sources

Le projet distingue trois familles de sources de jeux de donnees.

| Famille | Role | Etat actuel |
|---|---|---|
| Packages R/Python | Premiere source exploree : datasets embarques dans des librairies de statistique spatiale, econometrie spatiale, SIG ou apprentissage | pipeline le plus avance |
| Articles scientifiques avec donnees ouvertes | Papiers de statistique/econometrie spatiale qui publient leurs donnees, code ou supplements | pipeline bibliographique en construction |
| Banques et entrepots de donnees | Zenodo, Dryad, Dataverse, Figshare, data.gouv, INSEE, Eurostat, OECD, World Bank, etc. | scrapers et manifests deja presents |

Les packages R/Python ne sont donc pas l'objectif final : ils constituent une
premiere entree plus controlee pendant que les deux autres familles sont
structurees.

## Architecture principale

```text
corpus/
  bib/                    Bibliographie JabRef/BibDesk, dont references.bib
  papers/
    raw_pdf/              PDF scientifiques valides
    tei/                  TEI XML produits par GROBID
  web_md/                 Pages web, manuels et tutoriels convertis en Markdown
  sources.yml             Sources du corpus

wiki/
  concepts/               Concepts methodologiques et de donnees
  datasets/               Fiches de datasets et documentation de packages
  estimators/             Fiches d'estimateurs
  papers/                 Fiches de papiers
  software/               Fiches de packages/librairies
  metadata/               Schemas, politiques et conventions
  analyses/               Syntheses et sorties interpretees

inst/kg/
  schema.yml              Types de noeuds et relations du KG
  concepts.yml            Concepts reconnus par le KG
  entrypoints.yml         Entrees conseillees pour agents
  sources_rules.yml       Regles de priorite des sources
  topic_taxonomy.yml      Taxonomie de themes

tools/kg/
  01_extract_bib.py       Passerelle bibliographie
  02_run_grobid.py        Conversion PDF -> TEI via GROBID
  03_parse_tei.py         Extraction Paper/Section/Formula/Method/Dataset
  ingest_papers.py        Ingestion incrementale de PDF scientifiques
  04_extract_dataset_catalogs.py
                          Passage des catalogues datasets vers le KG
  04_build_graph.py       Fusion des noeuds/relations en SQLite
  05_make_wiki_pages.py   Generation de pages wiki depuis le KG
  07_export_agent_index.py
                          Consultation lisible du KG pour les agents

.kg/
  extracted/              Noeuds et relations JSONL extraits
  graph.sqlite            Graphe local consultable avec SQLite
  summaries/              Resumes de parsing et controles

Code_scrapping/
  r_catalog/              Pipeline datasets software R
  python_catalog/         Pipeline datasets software Python
  paper_links/            Liens dataset-package-papier-formule
  pipeline_lit/           Recherche bibliographique OpenAlex/Crossref
  pipeline_portals/       Scrapers d'entrepots de donnees
```

## Pipeline datasets software

La couche software part des packages R/Python et produit des catalogues
exploitables par le wiki et le KG.

```text
packages R/Python
-> inventaire des datasets
-> extraction locale quand possible
-> inspection des objets
-> detection de geometrie, coordonnees, temps, Y, X et formules
-> documentation package/dataset en Markdown
-> audit papier/source/formule
-> extraction vers KG
-> fiches wiki et consultation agent
```

Scripts principaux :

- `Code_scrapping/r_catalog/extract_r_software_datasets.R`
- `Code_scrapping/r_catalog/Inspection_of_each_dataset.R`
- `Code_scrapping/r_catalog/create_r_software_catalog.R`
- `Code_scrapping/r_catalog/render_r_dataset_rd_docs.R`
- `Code_scrapping/r_catalog/llm_curate_r_datasets.R`
- `Code_scrapping/python_catalog/extract_python_software_datasets.py`
- `Code_scrapping/paper_links/build_dataset_paper_audit.py`

Sorties principales :

- `data/manifests/datasets/software_r_catalog_main_datasets.csv`
- `data/manifests/datasets/software_python_catalog_all.csv`
- `data/manifests/datasets/software_catalog_curated_final.csv`
- `data/manifests/datasets/software_r_dataset_paper_formula_audit.csv`
- `wiki/datasets/r_package_docs/<package>/<package>.md`
- `wiki/datasets/r_package_docs/<package>/topics/<dataset>.md`

## Corpus, JabRef et GROBID

JabRef ou BibDesk gere `corpus/bib/references.bib` : metadonnees, DOI, URL,
cle BibTeX et lien vers les PDF locaux. Il ne remplace ni le KG ni GROBID.

GROBID lit les PDF de `corpus/papers/raw_pdf/` et produit les fichiers TEI dans
`corpus/papers/tei/`. Ces TEI sont ensuite parses pour extraire titres,
auteurs, sections, formules, references, methodes et mentions de datasets.

Workflow conseille :

```text
references.bib + raw_pdf/
-> tools/kg/02_run_grobid.py
-> tools/kg/03_parse_tei.py
-> tools/kg/04_extract_dataset_catalogs.py
-> tools/kg/04_build_graph.py
-> tools/kg/07_export_agent_index.py
```

Pour une ingestion ciblee de quelques papiers, utiliser plutot le pipeline
incremental :

```bash
python tools/kg/ingest_papers.py --pdf "article.pdf" --title "titre court"
```

Cette commande :

- lance GROBID seulement si le TEI du PDF manque ;
- parse seulement les nouveaux TEI ou les TEI sans extraction incrementale ;
- ecrit des JSONL par papier dans `.kg/extracted/` ;
- reconstruit `.kg/graph.sqlite` une seule fois ;
- ajoute une entree dans `wiki/log.md`.

`tools/kg/run_all.py` reste reserve aux reconstructions completes du KG.

## Role du KG

Le KG sert de memoire structuree pour eviter de relire tout le corpus ou tout le
wiki a chaque question.

Il encode notamment :

- `Paper USES_DATASET Dataset`
- `RPackage PROVIDES_DATASET Dataset`
- `Dataset HAS_VARIABLE Variable`
- `Dataset HAS_RESPONSE ResponseVariable`
- `Dataset HAS_COVARIATE Covariate`
- `Dataset SHOWS_FORMULA Formula`
- `Dataset DOCUMENTED_BY DocumentationPage`
- `Method IMPLEMENTED_BY Package`

Le fichier final est `./.kg/graph.sqlite`. Il peut etre ouvert avec DB Browser
for SQLite ou interroge par les scripts `tools/kg/`.

## Role du wiki

Le wiki est la couche editoriale : il stabilise ce qui est valide, lisible et
utile pour le raisonnement humain/LLM.

Le KG peut suggerer des relations ; le wiki les rend explicites. Inversement,
les pages wiki validees peuvent reinjecter des concepts, methodes, datasets et
formules dans le KG.

## Evaluation

`LLM-wiki-Assessment/` contient un controle qualite en trois niveaux :

| Niveau | Role | Cout |
|---|---|---|
| Tier 1 | Structure, frontmatter, liens internes | 0 token |
| Tier 2 | Evaluation semantique LLM-as-judge | tokens |
| Tier 3 | File de revue manuelle | 0 token |

Commandes utiles :

```bash
python LLM-wiki-Assessment/eval/run_eval.py wiki/datasets/zenodo/zenodo_xxx.md
python LLM-wiki-Assessment/eval/run_eval.py --all
python -m pytest LLM-wiki-Assessment/tests/
```

## Regle de priorite

Pour les questions scientifiques, commencer par le KG puis verifier dans le
wiki/corpus si besoin. Pour les questions de code, commencer par le MCP
`codebase_memory`, puis verifier dans les fichiers reels. Le fichier reel sur
disque reste la source finale de verite.

## Origine

Ce projet est base initialement sur le modele `llm-wiki-karpathy`, puis adapte
pour la constitution d'une banque de donnees spatiales et spatio-temporelles
documentee, reliee a des papiers, des formules, des packages et des methodes.
