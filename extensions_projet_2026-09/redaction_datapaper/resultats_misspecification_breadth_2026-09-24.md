# Variété des mauvaises spécifications Monte Carlo — 66 articles (24 septembre 2026)

## Objet

Réponse à la demande de l'encadrant du 24 septembre : distinguer, dans les 66 articles de la méta-analyse, ceux qui font varier uniquement la taille d'échantillon et/ou le niveau de bruit (pas un vrai test de mauvaise spécification) de ceux qui testent plusieurs mécanismes qualitativement distincts.

## Méthode

Skill dédié `.claude/skills/code-monte-carlo-misspecification/SKILL.md`, exécuté sur les 66 articles répartis en 4 lots (agents indépendants, lecture TEI intégrale, pas seulement l'abstract). Neuf axes de mauvaise spécification suivis (`spatial_dependence`, `weights_geometry`, `error_distribution`, `heteroskedasticity`, `nonlinearity`, `x_correlation`, `spatial_scale`, `measurement_error`, `missing_data`) ; `sample_size` et `noise_snr` explicitement exclus du comptage (axes de difficulté, pas de mauvaise spécification).

**Critère retenu (choix explicite, plus strict que la première option envisagée)** : un axe ne compte comme « varié » que s'il est un facteur explicite d'un plan factoriel documenté croisant cet axe avec au moins une autre dimension du design. Une mention isolée, un run de robustesse ad hoc non repris dans le design formel, ou un axe fixé à un seul niveau ne comptent pas.

Le pré-filtre regex déjà présent dans le TSV (`axis_*`, colonnes sans suffixe) n'a **pas** été utilisé comme verdict — seulement comme un signal ponctuel pour savoir où chercher, jamais suivi aveuglément (plusieurs désaccords documentés ci-dessous, dans les deux sens).

## Vérification de cohérence

Chaque article a un compte article par article (`misspecification_axes_count`) rapporté par l'agent codeur, et un compte recalculé indépendamment à partir des 9 verdicts individuels (`recomputed_count`). Un seul désaccord trouvé : **A04** (Geniaux & Martinetti, MGWR-SAR) — l'agent avait rapporté 4 axes dans son résumé alors que ses propres verdicts détaillés en listaient 5 (`spatial_dependence`, `weights_geometry`, `x_correlation`, `spatial_scale`, `measurement_error` tous à `yes`). Le compte recalculé (5, `broad`) est retenu comme faisant foi ; le tableau final ci-dessous utilise cette valeur corrigée.

## Résultat : répartition (n=66)

| Catégorie | Définition | N | % |
|---|---:|---:|---:|
| `only_scale_noise` | 0 axe vraiment varié (au mieux N et/ou bruit) | 17 | 25.8 % |
| `narrow` | 1 à 4 axes vraiment variés | 47 | 71.2 % |
| `broad` | 5 axes ou plus | 2 | 3.0 % |

**Écart notable avec l'intuition de l'encadrant** (~85 % / ~10 % / ~2 %, donnée comme estimation à vérifier, pas comme référence) : la catégorie `narrow` est beaucoup plus large que prévu (71 % contre ~10 % anticipés), et `only_scale_noise` beaucoup plus restreinte (26 % contre ~85 % anticipés). Le corpus des 66 articles fait donc, dans sa majorité, au moins un vrai test de mauvaise spécification qualitative — mais rarement plus d'un ou deux à la fois (`broad`, 5+ axes, reste rare : seulement 2 articles sur 66).

## Répartition par axe (nombre d'articles à `yes` sur 66)

| Axe | N à `yes` | N `unclear` |
|---|---:|---:|
| spatial_dependence | 23 | 1 |
| weights_geometry | 15 | 2 |
| error_distribution | 13 | 1 |
| heteroskedasticity | 10 | 1 |
| spatial_scale | 12 | 1 |
| x_correlation | 7 | 0 |
| nonlinearity | 5 | 0 |
| measurement_error | 4 | 0 |
| missing_data | 0 | 0 |

`spatial_dependence` et `weights_geometry` dominent largement (cohérent avec le fait que le corpus est majoritairement composé d'articles d'économétrie spatiale SAR/SEM, où ρ/λ et la structure de W sont les leviers naturels de robustesse). `nonlinearity` — le premier exemple cité par l'encadrant — n'apparaît vraiment variée factoriellement que dans 5 articles sur 66. `missing_data` n'apparaît **jamais** vériifée dans ce corpus, y compris comme `unclear` — à vérifier si c'est un vrai zéro ou un axe mal défini pour ce type de littérature.

## Réserve structurelle importante

Une partie substantielle du corpus (surtout les familles S et une partie de G, papiers de géostatistique/krigeage pure : `S02, S03, S05, S06, S07`, etc.) n'a **aucune covariable X ni structure de régression** — ce sont des articles d'estimation de champ spatial (covariance, taper, NNGP...). Pour ces articles, `x_correlation`, `nonlinearity`, `heteroskedasticity` et `measurement_error` sont **structurellement non applicables**, pas « les auteurs n'ont pas testé ». Une partie du score `only_scale_noise` reflète donc un choix de genre d'article (pure estimation de covariance vs comparaison d'estimateurs de régression), pas nécessairement une pauvreté de conception Monte Carlo. Point à nuancer avant de présenter le tableau à l'encadrant.

## Points de désaccord/interprétation signalés par les agents codeurs (à trancher, pas encore validés)

- **A08** : `x_correlation` compté `yes` en interprétant γ (corrélation entre le régresseur inclus et une variable omise latente z) comme relevant de cet axe — interprétation élargie par rapport à une corrélation entre deux covariables incluses. À confirmer.
- **G08** : scénario symétrique (variable omise, corrélation fixe 0.5) **non** compté nulle part, faute de correspondre à un des 9 axes — cohérence à vérifier avec A08.
- **C04** : trois scénarios d'hétéroscédasticité comptés `yes` bien qu'aucun ne soit jamais comparé à un cas homoscédastique — compté par analogie à « plusieurs DGP nommés », cas limite.
- **S01, S04** : « stationnaire vs non-stationnaire » d'un champ gaussien assimilé à `spatial_scale` par analogie — choix d'interprétation, pas une correspondance évidente.
- **N02** : deux facteurs centraux de l'article (discordance spatiale, séparabilité des groupes) ne correspondent à aucun des 9 axes retenus — candidat possible pour un 10ᵉ axe si ce type d'article devient significatif dans le corpus.
- **S02, T05** : verdicts `unclear` documentés (variation mentionnée mais statut de croisement factoriel non confirmable dans le texte disponible).
- **S07** : annexes A5-A9 (expériences de simulation additionnelles) absentes de l'extraction TEI — verdict basé uniquement sur le corps du texte, à réviser si les annexes deviennent disponibles.

## Fichiers produits

- `meta_analyse_misspecification_breadth_2026-09-24.tsv` — verdict par article et par axe, avec compte agent et compte recalculé (66 lignes, alignées sur les `id` du TSV principal `meta_analyse_codage_66_articles_2026-09-21.tsv`).
- Ce document.

## Reste à faire avant intégration à l'article

1. Trancher les points de désaccord/interprétation ci-dessus (notamment A08/G08 et le statut du 10ᵉ axe potentiel de N02).
2. Décider si le tableau va dans le corps de l'article (à côté du tableau déjà existant sur le nombre de jeux réels par article) ou en matériel supplémentaire.
3. Nuancer explicitement la réserve structurelle (papiers de covariance pure vs comparaison d'estimateurs) dans le texte qui accompagnera ce tableau.
