# Reconstruction du corpus de la méta-analyse : première livraison

Date : 28 septembre 2026
Statut : **proposition à valider**. Aucune suppression, aucun téléchargement, aucune modification de l'Abstract ni du manuscrit n'ont été effectués.
Mode : production de secours (Claude), sur demande explicite de l'utilisateur.

## 1. Règles appliquées

Critères d'inclusion appliqués au texte intégral (TEI) :

- réponse `Y` et covariable(s) `X` explicitement définies ;
- l'objet méthodologique porte sur la relation `Y ~ X` : estimation, inférence, prédiction ou comparaison de méthodes de régression spatiale ou spatio-temporelle ;
- Monte-Carlo fondé sur un DGP paramétrique identifiable **qui contient lui-même des covariables** ;
- l'absence de jeu réel n'exclut pas l'article, mais elle est codée.

Motifs d'exclusion : krigeage ou interpolation d'un champ, estimation ou approximation de covariance (tapering, Vecchia, NNGP, rang réduit), simulation sans `X`, absence de Monte-Carlo propre, clustering.

`context_only` : article fondateur conservé hors du dénominateur.

## 2. Résultat de la réévaluation (70 lignes, 67 TEI actifs et 3 TEI hors corpus actif)

| Décision | N | Identifiants |
|---|---:|---|
| `include_quantitative` | **48** | C02, C03, C05, E03, E05–E14, G03–G11, T01–T09, A01–A08, A10–A14, N03, N05, N06 |
| `context_only` | 5 | E01, E02, E04, G01, G02 |
| `exclude` | 17 | C01, C04, S01–S10, T10, A09, N01, N02, N04 |

Changements par rapport au codage du 21 septembre :

- **Toute la famille S (S01–S10) sort.** Ce sont des articles d'estimation ou d'approximation de covariance et de krigeage. S04, S06 et S07 contiennent bien `Xβ`, mais β n'y est qu'un paramètre de nuisance.
- **C01, C04 et T10 sortent**, car leurs simulations ne contiennent aucune covariable.
- **A09 (spARCH) sort.** Le DGP simulé est un spARCH(1) pur, sans `X` ; les covariables n'apparaissent que dans l'application.
- **N01 et N02 sortent.** N01 est un test de dépendance spatiale d'une seule variable ; N02 est un clustering de réseaux.
- **N04 sort.** Le seul objet étudié est la structure de dépendance (comparaison par LOOIC et WAIC) ; il s'agit d'un **cas limite**.
- **N03 est inclus, à titre de cas limite.** C'est un modèle de comptage zéro-enflé avec `X`, mais les résultats sur β ne figurent qu'en supplément. **À arbitrer.**
- **E01 et E04 passent en `context_only`.** Le Monte-Carlo d'E01 simule `u` sans `X`. E04 renvoie son Monte-Carlo à un autre article.
- **A14 est désormais inclus** (aucun jeu réel, ce qui est maintenant admis).
- **E02, G01 et G02** passent en `context_only` (pas de DGP paramétrique propre).

Parmi les 48 inclus, **32 (67 %) sont publiés depuis 2017**. Répartition du nombre de jeux réels : 0 → 12 articles, 1 → 28, 2 → 6, 5 → 1, 7 → 1.

Le détail, avec extraits et justifications, figure dans `manifeste_reevaluation_corpus_2026-09-28.tsv`.

## 3. Fichiers à retirer du corpus actif (proposition, non exécutée)

17 paires PDF/TEI sont concernées, dans `corpus_meta_analyse/pdf/` et `corpus_meta_analyse/tei/` : C01, C04, S01–S10, T10, A09, N01, N02, N04.

Vérifications effectuées :

- Ces fichiers ne sont **pas suivis par git** : les PDF sont ignorés par `.gitignore` (`*.pdf`) et les TEI ne sont pas indexés. `git rm` est donc inutile.
- Pour 15 des 17 articles, une autre copie existe dans `corpus/papers/tei` ou `corpus/papers/raw_pdf`. Ces copies sont utilisées par le KG et **ne doivent pas être touchées**.
- **N02 et N04 : le TEI du corpus actif est l'unique copie TEI du dépôt.** Leurs PDF existent aussi dans `corpus/papers/raw_pdf` (`10_1111_2041_210X_12208.pdf`, `10_1007_s13253_025_00720_7.pdf`).

Action proposée : **déplacer**, sans supprimer, les 17 paires vers `corpus_meta_analyse/_exclus_2026-09-28/`. Les lignes de criblage sont conservées dans le manifeste. Aucune fiche dataset, aucun élément du KG ni aucune source d'une autre revue n'est affecté.

## 4. Nouveaux candidats (55 articles, DOI vérifiés)

Liste complète : `candidats_nouveaux_corpus_2026-09-28.tsv`. Pour chaque candidat, le DOI, le titre, l'année, la revue, les citations et l'accès ouvert ont été vérifiés dans OpenAlex le 28 septembre 2026. Sept DOI proposés de mémoire étaient faux ; ils ont été corrigés par recherche sur le titre. Aucun candidat n'est déjà présent dans le corpus ni dans `corpus/bib/references.bib`.

- **Répartition par famille :** économétrie spatiale et W (16), panels (3), GWR/SVC/ML spatial (21), confusion spatiale et variables omises (7), axes rares — données manquantes, erreur de mesure, W mal spécifiée, colinéarité (8).
- **Récence :** 45 sur 55 publiés depuis 2017.
- **Accès :** 36 en accès ouvert d'après OpenAlex ; 19 à récupérer par l'accès institutionnel.
- **Projection :** 48 + 55 = **103 articles**, dont **77 depuis 2017 (75 %)**.
- **Marge :** si des téléchargements échouent, il reste une marge d'environ 3 articles avant de descendre sous 100.

Le Monte-Carlo n'est confirmé que par le résumé ; il reste à vérifier dans le texte intégral pour Debarsy et LeSage (2018), Wolf et al. (2018), Géniaux (2024) et Le Gallo et Fingleton (2012).

## 5. Grille de codage prévue pour le corpus élargi

Champs par expérience :

- `n_simulation_experiments` ;
- `dgp_structures` ;
- `n_cells_by_experiment` et `cell_count_status` ;
- `n_replications_by_experiment` ;
- `bootstrap_counts`, `randomization_counts` et `mcmc_iterations`, tenus séparément des répétitions ;
- `methods_compared` et `metrics` ;
- `n_real_datasets`, `real_dataset_roles` et `validation_scheme` (en échantillon ou hors échantillon).

Les axes de simulation sont codés en deux blocs distincts.

- **Facteurs minimaux**, obligatoires et non comptés comme mauvaise spécification : taille, bruit ou SNR, loi des erreurs, intensité de la dépendance spatiale, configuration élémentaire de `W`. Cette règle suit l'encadrant.
- **Vrais tests de mauvaise spécification :**
  - non-linéarité ;
  - hétérogénéité spatiale ;
  - hétéroscédasticité ;
  - corrélation des `X` ;
  - interactions ;
  - variables omises ;
  - erreur de mesure ;
  - données manquantes ;
  - changement de support ou d'échelle ;
  - `W` volontairement incorrecte ;
  - endogénéité de `W`.

## 6. Rapport d'audit (mode production de secours)

- **Fichiers créés :**
  - `manifeste_reevaluation_corpus_2026-09-28.tsv` ;
  - `candidats_nouveaux_corpus_2026-09-28.tsv` ;
  - cette note.
- **Fichiers modifiés ou supprimés :** aucun.
- **Sources :**
  - les 67 TEI de `corpus_meta_analyse/tei/`, plus E02, G01 et G02 dans `corpus/papers/tei/` ;
  - l'API OpenAlex, uniquement pour les métadonnées des candidats.
- **Méthode de lecture :** pour chaque TEI, lecture de l'introduction, du modèle, des simulations, des applications et de la conclusion. Les annexes de démonstrations (lemmes, preuves) ont été parcourues sans être lues en détail, car elles n'entrent pas dans le codage.
- **Points à revoir manuellement :**
  - N03 (inclus) et N04 (exclu), deux cas limites ;
  - l'année retenue pour les articles publiés en ligne l'année précédente (E08, G06, C05) ;
  - les 4 candidats dont le Monte-Carlo n'est pas confirmé au résumé.
- **Non fait :** suppression, téléchargement, conversion GROBID, codage détaillé des cellules du nouveau lot.

## 7. Mise à jour du 28 septembre 2026 : décision de l'utilisateur et nettoyage exécuté

**Décision.** C03 (*double fixed rank kriging*) passe de `include_quantitative` à `exclude`, car la famille fixed-rank kriging est hors périmètre. C02, A07 et N05 sont confirmés comme inclus.

**Bilan corrigé :** 47 `include_quantitative`, dont 31 publiés depuis 2017 ; 5 `context_only` ; 18 `exclude`.

**Nettoyage exécuté :**

- **Suppression de 16 paires PDF/TEI** du corpus actif : C01, C03, C04, S01–S10, T10, A09 et N01. Avant chaque suppression, une copie identique a été vérifiée par empreinte MD5 dans `corpus/papers/raw_pdf` ou `corpus/papers/tei`.
- **Déplacement de N02 et N04** vers `redaction_datapaper/archive_hors_corpus_quantitatif_2026-09-28/`.
  - **Constat :** leurs copies identiques existent en réalité aussi dans `corpus/papers`, sous des noms fondés sur le DOI :
    - N02 : `10_1111_2041_210X_12208.*` ;
    - N04 : `10_1007_s13253_025_00720_7.*`.
- **Corpus actif :** il contient maintenant 49 paires, soit les 47 inclus plus E01 et E04, conservés en `context_only`.
- **Hors périmètre :** aucune fiche dataset, donnée, élément du KG ni fichier d'une autre revue n'a été modifié.
- **Manifeste :** il est mis à jour, avec les colonnes `decision`, `motif` et `action_proposee`, cette dernière passée à « EXECUTE ».

**Cible :** 100 inclusions, soit environ 53 nouvelles, dont au moins 39 publiées depuis 2017.

**Sursélection :** la liste compte 69 candidats (61 publiés depuis 2017), dans `candidats_sursélection_2026-09-28.tsv`. Elle remplace `candidats_nouveaux_corpus_2026-09-28.tsv`.

- Trois candidats de la liste précédente ont été retirés après lecture du résumé :
  - Hsu et Li (2023), une classification d'images ;
  - Liu et al. (2022), sans simulation ;
  - Lu et al. (2016), une étude de cas sans Monte-Carlo.
- Le Gallo et Fingleton (2012) a également été retiré, car son Monte-Carlo n'était pas confirmé.
- Les colonnes Y, X, Monte-Carlo et nombre de jeux réels proviennent **du seul résumé**. La mention « probable » ou « à confirmer » signale un résumé muet ; ces champs seront vérifiés sur le texte intégral.

## 8. Téléchargement et conversion des candidats (28 septembre 2026)

Les 69 candidats portent les identifiants `M01`–`M69`, selon leur rang dans `candidats_sursélection_2026-09-28.tsv`. Le suivi complet figure dans `telechargement_candidats_2026-09-28.tsv` : statut, source, URL, chemins, raison d'échec.

**Méthode.** Le téléchargement réutilise les fonctions de `code/pipeline_lit/download_open_access_dataset_papers.py` (OpenAlex et Crossref, sans Unpaywall ni courriel), complétées par trois passages légaux :

- arXiv, par correspondance exacte du titre ;
- Semantic Scholar, via le champ `openAccessPdf` ;
- des dépôts ouverts : OSF et e-archivo (UC3M).

Les PDF sont déposés dans `corpus_meta_analyse/pdf/`, sous le nom `Titre (60 car.) [Mxx].pdf` ; les noms sont courts pour éviter la limite MAX_PATH de Windows.

**Résultat :**

- **31 PDF obtenus et 31 TEI produits** par GROBID (`tools/kg/02_run_grobid.py::process_pdf`, sortie dans `corpus_meta_analyse/tei/`). Parmi eux, 28 articles sont publiés depuis 2017.
- **Contrôle des TEI :** le titre concorde pour chaque TEI. Pour M61, GROBID n'a pas extrait de titre, mais le contenu a été vérifié. Tous les TEI mentionnent des simulations.
- **Versions préprint à rapprocher de la version publiée :**
  - arXiv : M20, M26, M29, M36, M38, M39, M51, M56, M57 ;
  - OSF : M24 ;
  - dépôt institutionnel : M16 ;
  - HAL (via Semantic Scholar) : M03.
- **Rien n'a été copié dans `corpus/papers/`.** Le KG n'a pas été modifié.
- **Fichier supprimé :** un fragment PDF de 7 octets pour M06, créé par un téléchargement avorté.

**38 échecs**, dont 33 articles publiés depuis 2017. Les causes :

- le PDF éditeur est réservé aux abonnés (lien XML/HTML ou refus HTTP 403) ;
- aucune version en accès ouvert n'est signalée.

La liste (identifiant, titre, auteurs, DOI, URL officielle `https://doi.org/<DOI>`, raison) se trouve dans `telechargement_candidats_2026-09-28.tsv` (lignes sans `local_path`). Ces articles nécessitent un téléchargement manuel par l'accès institutionnel.

**Projection :**

- 47 inclus + 31 obtenus = 78 textes, avant la lecture qui confirmera ou non leur inclusion.
- Pour atteindre environ 100, il faut récupérer manuellement environ 22 des 38 manquants, en priorisant les articles récents.

## 9. Téléchargements manuels et conversion (29 septembre 2026)

**Dépôt.** L'utilisateur a déposé 34 PDF dans `C:/Users/jdoliveira/Downloads`. Ils ont été **copiés**, sans être déplacés, vers `corpus_meta_analyse/pdf/`, sous le nom `[Mxx]`. L'association à chaque identifiant s'est faite par le titre ; elle a été confirmée par le titre extrait dans le TEI.

**Conversion.** Les 34 PDF ont été convertis par GROBID, sans échec.

**Contrôle.** Pour M12 et M14, GROBID a extrait un en-tête d'éditeur à la place du titre ; le contenu a été vérifié et correspond aux articles attendus. M64 est une version « Journal Pre-proof ».

**Bilan.** Sur les 69 candidats, 65 ont désormais un PDF et un TEI. Restent non récupérés : M18, M28, M68 et M69.

**À contrôler en priorité à la lecture.** Ces textes mentionnent très peu les simulations (0 ou 1 mention) ; ce sont des exclusions probables faute de Monte-Carlo :

- M58 (SGWR) ;
- M31 (GWANN) ;
- M62 (améliorations de calcul de MGWR) ;
- M48 (Kelejian et Prucha, 2010).

## 10. Compléments manuels, nettoyage de Downloads et codage du lot M (29 septembre 2026)

**Compléments.** M18 (déjà présent dans Downloads) et M68 ont été copiés dans le corpus puis convertis par GROBID. Leur statut est `SUCCESS_MANUAL` dans `telechargement_candidats_2026-09-28.tsv`.

**M28 non récupéré.** Le fichier fourni (`geniaux_mgwrsar_2022.pdf`) contient les diapositives de conférence (HAL), pas l'article. Sa copie et son TEI ont été retirés du corpus ; l'original reste dans Downloads.

**M69 non récupéré.** L'article est en accès abonné et l'utilisateur n'a pas pu l'obtenir.

**Nettoyage de Downloads.** Les 36 originaux copiés ont été supprimés de `C:/Users/jdoliveira/Downloads`, après vérification MD5 de l'identité avec la copie du corpus.

**Codage.** Les 67 textes M disponibles ont été lus en texte intégral (sections de simulation et d'application extraites du TEI). Ils ont été codés selon la grille de la section 5.

Fichiers produits :

- `codage_candidats_M_2026-09-29.tsv` : une ligne par article ;
- `codage_candidats_M_2026-09-29.jsonl` : même contenu, avec les listes non aplaties.

**Décisions.** 63 articles sont retenus en `include_quantitative`, dont 56 publiés depuis 2017. Quatre sont exclus :

- M48 : article théorique, le Monte-Carlo est seulement annoncé comme travail futur ;
- M58 : SGWR, évaluée uniquement sur cinq jeux réels ;
- M62 : jeu simulé servant seulement à mesurer le temps de calcul et la mémoire de MGWR ;
- M67 : X n'intervient que dans le mécanisme de manquement, pas dans l'équation de Y.

M31 (GWANN), signalé comme exclusion probable en section 9, est finalement retenu : son DGP paramétrique avec X est bien présent.

**Inclusions à la marge (à arbitrer).** Huit articles n'ont qu'une réalisation simulée par scénario, sans répétitions Monte-Carlo : M21, M24, M25, M26, M27, M31, M51 et M64. S'y ajoute M13, qui n'a que 20 réplications et une dépendance spatiale portée seulement par des grappes.

**Comptage des cellules.** 40 comptages sont exacts, 20 sont des bornes inférieures (plan partiel dans le texte principal, reste en supplément) et 3 ne sont pas reconstructibles (M38, M46, M52). Sur les 60 articles chiffrés, la médiane est de 15,5 cellules (de 1 à 200).

Les expériences sans X ne sont pas comptées dans les cellules : M35 exemple 1 et M60 expérience 1.

**Conventions de codage.**

- L'hétérogénéité et l'hétéroscédasticité sont codées comme axes de mauvaise spécification dès que le DGP s'écarte du modèle linéaire homogène standard, même quand l'estimateur est conçu pour les traiter.
- La confusion spatiale (effet spatial omis corrélé à X) est codée `variables_omises` + `correlation_X`.
- Les effets fixes corrélés aux régresseurs sont codés `correlation_X`.
- Une réponse non gaussienne (binaire, Poisson) est codée `loi_erreurs`.

**M54.** Les chiffres du nombre de réplications manquaient dans le TEI ; le PDF indique 1 000 simulations (corrigé).

## 11. Décision context_only et recodage des 47 inclusions d'origine (29 septembre 2026)

> **État intermédiaire, remplacé par la section 13.** M13 a ensuite été réintégré après vérification de ses 20 régénérations indépendantes pour chacune des trois tailles d'échantillon.

**Décision de l'utilisateur.** Neuf articles M passent en `context_only`, avec la mention « DÉCISION UTILISATEUR 2026-09-29 » : M13, M21, M24, M25, M26, M27, M31, M51 et M64. Ce sont ceux qui n'ont pas de Monte-Carlo répété (une seule réalisation par scénario, ou seulement 20 réplications). Ils restent cités mais ne sont pas comptés.

**Recodage.** Les 47 inclusions d'origine ont été recodées avec la grille de la section 5. Le codage du 21 septembre servait de point de départ, systématiquement vérifié sur les sections de simulation du texte intégral (TEI). Fichier produit : `codage_corpus_origine_2026-09-29.jsonl`.

**Fichier consolidé.** `codage_corpus_complet_2026-09-29.tsv` regroupe 119 lignes :

- 101 `include_quantitative` (47 d'origine et 54 du lot M) ;
- 14 `context_only` (5 d'origine et 9 du lot M) ;
- 4 `exclude` (lot M).

Les 18 exclusions d'origine restent consignées dans le manifeste.

**Corpus quantitatif (101 articles).**

- *Ancienneté.* 79 articles sont publiés depuis 2017, soit 78,2 %.
- *Comptage des cellules.* 60 comptages sont exacts, 33 sont des bornes inférieures et 8 ne sont pas reconstructibles (E05, E08, E11, T06, T07, M38, M46, M52). Sur les 93 articles chiffrés, la médiane est de 16 cellules (quartiles 6 et 36, extrêmes 1 et 288).
- *Facteurs minimaux.* Taille : 58 articles ; intensité spatiale : 45 ; loi des erreurs : 26 ; configuration de W : 21 ; bruit/SNR : 17. 19 articles n'en font varier aucun.
- *Mauvaises spécifications.* Hétérogénéité : 40 ; corrélation des X : 36 ; modèle spatial erroné : 20 ; variables omises : 15 ; hétéroscédasticité : 14 ; non-linéarité : 13 ; W incorrecte : 9 ; W endogène : 6 ; erreur de mesure : 5 ; interactions : 3 ; support/échelle : 1 ; données manquantes : 1.
- *Nombre d'axes de mauvaise spécification par article.* 0 axe : 12 articles ; 1 : 36 ; 2 : 35 ; 3 : 16 ; 4 ou 5 : 2.
- *Jeux réels.* 27 articles n'en ont aucun, 61 en ont un seul et 13 en ont deux ou plus.
- *Validation.* 67 articles en échantillon seulement, 16 en échantillon et hors échantillon, 3 hors échantillon seulement, 15 sans jeu réel ni validation prédictive.
- *Procédures internes.* MCMC : 16 articles ; bootstrap : 9 ; randomisations : 2. Elles sont comptées séparément des réplications Monte-Carlo.

**À arbitrer.** A02 (benchmark sous hétérogénéité spatiale) et A05 (STWR) n'ont qu'un jeu simulé par cellule ou par scénario. C'est la même situation que les neuf articles M passés en `context_only`. Leur statut reste `include_quantitative` en attendant la décision de l'utilisateur.

N05 ne rapporte pas son nombre de réplications B : il reste inclus, mais ce point est signalé.

**Conventions ajoutées lors du recodage.**

- Des X spatialement autocorrélés ne sont pas, à eux seuls, une mauvaise spécification (cas d’E08, non codé).
- Ils sont codés `correlation_X` quand l'article étudie explicitement leur confusion avec la structure spatiale ou avec l'intercept (G11, A14, confusion spatiale).
- Les covariables réelles injectées dans un DGP sont notées `semi_synthetique`, et ne comptent pas comme jeu réel.

## 12. A02 et A05 en context_only, ajout de M70 : corpus à 100 articles (29 septembre 2026)

> **État intermédiaire, remplacé par la section 13.** Le total final passe à 101 après réintégration justifiée de M13.

**Décision de l'utilisateur.** A02 et A05 passent en `context_only`, pour la même raison que les neuf articles M de la section 11 : un seul jeu simulé par scénario, sans répétitions Monte-Carlo. Le corpus quantitatif tombe alors à 99 articles.

**Ajout de M70.** Pour atteindre 100, M70 est ajouté : Harris (2019), *A Simulation Study on Specifying a Regression Model for Spatial Data: Choosing between Autocorrelation and Heterogeneity Effects*, Geographical Analysis, DOI 10.1111/gean.12163. Ses DOI et titre ont été vérifiés dans OpenAlex. Il n'est pas un doublon de M22 ni de A01.

**Téléchargement.** L'article est en accès ouvert chez l'éditeur, mais Wiley renvoie une erreur 403 aux requêtes automatiques et CORE n'a pas de texte intégral. L'utilisateur l'a donc téléchargé via son navigateur. Le PDF a été copié dans le corpus sous l'identifiant `[M70]`, converti par GROBID, puis l'original a été supprimé de Downloads après vérification MD5.

**Codage de M70 : `include_quantitative`.**

- *Plan :* 4 processus (SP1 à SP4 : coefficients fixes avec erreur aléatoire, coefficients fixes avec erreur autocorrélée, non-stationnarité faible, non-stationnarité forte) × 100 réalisations sur les 159 comtés de Géorgie.
- *Sensibilité :* colinéarité forte et deux ratios moyenne:erreur supplémentaires, soit 16 cellules au total.
- *Procédures internes :* par réplication, bootstrap paramétrique R = 99 et 99 permutations.
- *Jeu réel :* un seul, les données d'éducation de Géorgie.

**Bilan final** (fichier `codage_corpus_complet_2026-09-29.tsv`, 120 lignes) :

- 100 articles `include_quantitative`, dont 45 d'origine et 55 du lot M ; 78 publiés depuis 2017, soit 78 % ;
- 16 articles `context_only` ;
- 4 articles `exclude` (auxquels s'ajoutent les 18 exclusions d'origine consignées dans le manifeste).

**Indicateurs sur les 100 articles.**

- *Comptage des cellules :* 60 exacts, 32 bornes inférieures, 8 non reconstructibles. Sur les 92 articles chiffrés, la médiane est de 16 cellules (quartiles 6 et 36, maximum 200).
- *Facteurs minimaux :*

  | Facteur | Articles |
  |---|---|
  | Taille | 57 |
  | Intensité spatiale | 45 |
  | Loi des erreurs | 26 |
  | Configuration de W | 21 |
  | Bruit/SNR | 17 |
  | Aucun facteur varié | 18 |

- *Mauvaises spécifications :*

  | Axe | Articles |
  |---|---|
  | Hétérogénéité | 39 |
  | Corrélation des X | 37 |
  | Modèle spatial erroné | 21 |
  | Variables omises | 15 |
  | Hétéroscédasticité | 13 |
  | Non-linéarité | 12 |
  | W incorrecte | 9 |
  | W endogène | 6 |
  | Erreur de mesure | 5 |
  | Interactions | 3 |
  | Support/échelle | 1 |
  | Données manquantes | 1 |

- *Nombre d'axes de mauvaise spécification par article :*

  | Axes | Articles |
  |---|---|
  | 0 | 12 |
  | 1 | 35 |
  | 2 | 35 |
  | 3 | 16 |
  | 4 ou 5 | 2 |

- *Jeux réels :*

  | Nombre de jeux réels | Articles |
  |---|---|
  | 0 | 27 |
  | 1 | 61 |
  | 2 ou plus | 12 |

- *Validation :*

  | Type | Articles |
  |---|---|
  | En échantillon seulement | 68 |
  | En échantillon et hors échantillon | 15 |
  | Hors échantillon seulement | 2 |
  | Aucune validation prédictive | 15 |

- *Procédures internes :*

  | Procédure | Articles |
  |---|---|
  | MCMC | 16 |
  | Bootstrap | 10 |
  | Randomisations | 3 |

L'Abstract et le manuscrit n'ont pas été modifiés.

## 13. Réintégration de M13 et validation des applications réelles (29 septembre 2026)

M13 est réintégré dans le corpus quantitatif. Le texte intégral décrit trois tailles d'échantillon (200, 500 et 1 000 observations) et 20 régénérations indépendantes par taille. Le DGP contient une réponse ROA, des covariables sectorielles et spatiales, un bruit normal et une variation de la matrice de poids. Il satisfait donc le critère de Monte-Carlo répété avec Y et X. Le corpus ne doit pas être limité artificiellement à 100 articles.

Le champ `validation` est renommé `validation_application_reelle`. Il décrit uniquement l'usage des données empiriques. Un article sans jeu réel reçoit `aucune`, même lorsqu'il emploie une séparation apprentissage--test dans ses simulations.

**Bilan courant :**

- 101 articles `include_quantitative`, 15 `context_only` et 4 `exclude` ;
- 79 articles quantitatifs publiés depuis 2017 (78,2 %) ;
- 199 expériences de simulation codées ;
- 61 comptages exacts, 32 bornes inférieures et 8 plans non reconstructibles ;
- 2 977 cellules documentées au minimum sur 93 articles chiffrés ; médiane 16, quartiles 6 et 36, maximum 200 ;
- 93 utilisations empiriques au niveau article : 27 articles sans jeu réel, 62 avec un, 9 avec deux, 2 avec trois et 1 avec sept ;
- validation des applications réelles : 59 en échantillon, 13 combinant en échantillon et hors échantillon, 2 exclusivement hors échantillon et 27 sans application réelle.

Les calculs courants reposent sur `codage_corpus_complet_2026-09-29.tsv`. Les sections 11 et 12 restent conservées comme trace des états intermédiaires.
