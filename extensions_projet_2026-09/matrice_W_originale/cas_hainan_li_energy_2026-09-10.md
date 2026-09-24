# Cas d'application : Hainan dans `paper_li_energy_price_co2_china`

Premier cas concret confrontant la méthodologie du [README](README.md) à un vrai
jeu de données (30 provinces chinoises, panel spatial SAR de Li, Fang et He
2020). Aucune des géométries/W des auteurs n'est disponible : le dépôt brut
qu'ils partagent (`data/raw/papers/DataCite_2019_TheImpactOfEnergy_10_1016_j_scitot/data.xlsx`)
ne contient que des identifiants numériques de province et les 9 variables du
modèle -- ni nom de province, ni géométrie, ni matrice de poids. L'identification
des provinces (population + codes GB/T 2260) et la reconstruction de W sont
entièrement à la charge du projet.

Script : [`code/r_catalog/build_li_energy_panel_W.R`](../../code/r_catalog/build_li_energy_panel_W.R).
Sortie : `data/final_datasets/weights/paper_li_energy_price_co2_china_W.rds`.

## Pourquoi ce cas ne rentre pas exactement dans les 3 cas du README

Le papier déclare (page PDF 16) utiliser une **contiguïté binaire** ("if the two
regions have a common boundary, the weight is set to 1"), normalisée par ligne
-- cas 3 du README (contiguïté sur géométrie complexe). Reconstruite directement
avec `spdep::poly2nb(queen=TRUE)` sur la géométrie déjà jointe au projet, cette
contiguïté est calculable pour 29 des 30 provinces. **Hainan** (île, aucune
frontière terrestre) ressort systématiquement sans aucun voisin -- y compris
dans la géométrie complète à 30 provinces, pas seulement dans un sous-échantillon.

Le README anticipe un noeud qui devient isolé *après sous-sélection* d'une W
existante (cas 3, solution : voisins-de-voisins `W²`, sinon élimination de la
ligne). Ce n'est pas le cas ici : Hainan n'a jamais eu de W d'origine à sous-
sélectionner, et `W²` appliqué à une ligne déjà nulle reste nulle -- la
technique ne s'applique pas telle quelle à une île isolée dès la construction
initiale.

## Trois traitements testés, comparés aux valeurs publiées

Le papier (section 4, discussion) rapporte pour le modèle SAR principal :
élasticité directe de `log(EP)` = **-0.169**, indirecte = **-0.070**.

| Traitement de Hainan | N provinces | `log(EP)` (SAR) | Impacts SAR (direct / indirect) | Verdict |
|---|---:|---:|---|---|
| **Exclusion** (dernier recours du README) | 29 | **+0.089** | non calculé, signe déjà incohérent | Le signe du résultat principal du papier s'inverse. Vérifié indépendamment d'un bug via un appel `plm::plm()` direct hors package : Hainan (valeur de CO2 la plus basse de tout l'échantillon, économie insulaire atypique) a un poids réel sur un panel à effets fixes de seulement 29-30 unités. |
| **Contiguïté patchée manuellement vers le Guangdong** (convention usuelle dans la littérature chinoise -- ArcGIS/GeoDa, non documentée par les auteurs) | 30 | -0.129 | -0.130 / -0.022 | Bon signe, mais magnitude assez loin des valeurs publiées. Le choix de Guangdong n'était pas vérifié géométriquement, juste une convention supposée. |
| **k plus proche voisin (k=1) par distance de centroïde, vérifié géométriquement** | 30 | **-0.167** | **-0.170 / -0.060** | Le plus proche des trois du résultat publié. Le plus proche voisin réel de Hainan est **Guangxi** (566 km), pas Guangdong (643 km) comme le laisserait croire la seule proximité du détroit de Qiongzhou -- confirmé par `sf::st_distance()` sur les centroïdes, pas supposé. |

## Justification du choix retenu (k-NN vers la plus proche voisine)

Le papier lui-même (page PDF 16) reconnaît le k-NN comme une des trois méthodes
usuelles de construction de W ("binary adjacency matrix, K-nearest Neighbors
matrix and distance threshold matrix"), utilisée dans leur propre analyse de
sensibilité. Rattacher spécifiquement Hainan par k-NN (k=1, vérifié
géométriquement) reste donc dans l'esprit de leur méthodologie déclarée,
sans en être une reproduction prouvée -- les auteurs ne disent nulle part
comment ils ont traité ce cas precis. Ce n'est pas non plus une preuve que
cette reconstruction est identique à la leur : le rapprochement des
élasticités publiées est un indice de plausibilité, pas une validation.

**`package_include` reste `no`** pour ce dataset : voir
[[paper_li_energy_price_co2_china]] et
[[plan_implementation_panel_spatial_2026-09-09]] (jalon J5) pour l'état complet
des réserves (identification des provinces, provenance de W, méthode SEM du
backend non comparée à celle des auteurs).

## Enseignement méthodologique pour les cas futurs

Compléter le README : quand un noeud est isolé **dès la construction initiale**
(pas seulement après sous-échantillonnage) et que la méthode principale du
papier ne peut pas lui donner de voisin, chercher d'abord si le papier
lui-même documente une méthode alternative (ici : k-NN, cité explicitement)
avant d'inventer une convention externe (contiguïté "logique" non vérifiée) ou
d'éliminer par défaut. Vérifier géométriquement le choix (distance de
centroïde réelle), ne jamais le supposer par intuition géographique.
