# Données semi-synthétiques pour l'évaluation d'estimateurs de régression spatiale — synthèse

*Note de synthèse issue d'une discussion de travail, septembre 2026. Destinée au projet de banque de données spatiales / benchmark, pour cadrer l'intégration de données synthétiques.*

---

## 1. Familles d'approches pour créer des données semi-synthétiques (cadre régression Y | X)

Le terme « semi-synthétique » recouvre plusieurs familles selon **ce qui est conservé du réel** (X, Y, la dépendance X→Y, la structure spatiale) et **ce qui est simulé**.

**F1. Covariables réelles, réponse simulée par un DGP contrôlé (« real-X / synthetic-Y »).**
On garde la matrice X observée (corrélations, marginales, colinéarités, support réaliste des interactions) et on génère Y = f(X) + ε avec f et ε choisis (linéaire, additif, interactions, hétéroscédasticité). C'est le principe des benchmarks causaux ACIC (Dorie et al. 2019), IHDP (Hill 2011), des knockoffs sur génotypes réels (Candès et al. 2018), de la prédiction conforme. Vérité connue, géométrie réaliste de X ; limite : le mécanisme Y|X reste artificiel. En économétrie spatiale, c'est le schéma « coordonnées et W réels + processus SAR/SEM/SVC simulé », qui conserve la topologie de voisinage réelle.

**F2. Plasmodes / simulation semi-paramétrique ancrée sur un modèle ajusté.**
Comme F1, mais f est *estimée* sur les données réelles : on ajuste un modèle flexible (GAM, BART, forêt, réseau) sur (X, Y) réels, ses prédictions deviennent la « vraie » fonction de régression, et on rééchantillonne le bruit (résidus bootstrappés ou paramétrique). Référence principale : Franklin et al. (2014) et la revue-tutoriel de Schreck et al. (*Stat Med* 2024, doi:10.1002/sim.10012) qui fournit un protocole pas-à-pas et des recommandations de reporting. RealCause (Neal et al. 2020) est la version « deep » de cette idée. Réalisme maximal du mécanisme, au prix d'une vérité dépendante du modèle ajusté (risque de circularité si l'on évalue ensuite la même classe de modèles).

**F3. Injection de signal dans des données entièrement réelles (« spike-in »).**
(X, Y) réels + effet connu ajouté (Y* = Y + β·x_j, ou une colonne permutée pour créer un vrai négatif). Utilisé en sélection de variables / contrôle du FDR. Vérité partielle : on connaît l'effet injecté, pas le reste.

**F4. Rééchantillonnage semi-paramétrique du bruit.**
On conserve ŷ et on regénère seulement ε (bootstrap résiduel, wild bootstrap, bootstrap spatial par blocs ou par filtrage de Moran).

**F5. Synthèse partielle au sens de la confidentialité (Rubin 1993 ; Reiter 2003).**
Remplacement de certaines variables ou enregistrements par des tirages d'un modèle d'imputation séquentiel ajusté sur le réel — package R `synthpop` (Nowok et al. 2016). Objectif : fidélité au réel et partageabilité, pas une vérité connue.

**F6. X synthétisé par modèle génératif, Y par mécanisme contrôlé (hybride).**
X généré par copules, CTGAN, TVAE, TabDDPM, Forest-Flow, GReaT… puis Y par DGP choisi ou modèle ajusté. La littérature récente montre pourquoi séparer les deux étapes : les synthétiseurs entièrement génératifs préservent l'utilité prédictive mais peuvent déformer les contrastes d'intérêt.

**F7. Augmentation / perturbation locale de lignes réelles.**
SMOGN, mixup tabulaire, jitter. Outil d'entraînement plus que de benchmark.

**Deux axes transversaux pour organiser une banque de données :** (i) *quelle vérité est connue* (f entière, un effet injecté, la distribution de Y|X, rien) ; (ii) *quel niveau de réalisme est conservé* (X seul, X + dépendance spatiale, X + Y). Pour un benchmark spatio-temporel, les familles F1 et F2 dominent : « coordonnées/W réels + Y simulé, avec f choisie ou f̂ plasmode ».

---

## 2. Coupler plasmodes et modèle génératif : Y à vérité connue mais indiscernable du réel

Question posée : peut-on avoir un Y simulé dont la moyenne conditionnelle est celle du plasmode (vérité connue) tout en étant statistiquement indiscernable du Y réel ?

**Tension de fond.** Un plasmode fixe une vérité f̂(X) ; un générateur conditionnel cherche P(Y|X) réel. Si le discriminateur gagne, le générateur converge vers le vrai E[Y|X], qui n'est pas f̂ sauf si f̂ est un bon estimateur. Les deux objectifs ne sont compatibles qu'à hauteur de l'erreur d'approximation de f̂ — ce qui fait du discriminateur un diagnostic de qualité du plasmode.

**Trois architectures.**
- **A1 — décomposition moyenne / résidu (recommandée).** Y* = f̂(X) + ε*(X), f̂ = plasmode, ε* généré par un modèle conditionnel entraîné sur les résidus réels avec contrainte E[ε*|X] = 0. Vérité exacte E[Y*|X] = f̂(X) ; le générateur capture hétéroscédasticité, asymétrie, queues. En spatial, ε* doit porter la dépendance : processus SAR/SEM/Matérn ajusté sur les résidus, ou générateur conditionné sur les résidus des voisins (Wε̂).
- **A2 — générateur conditionnel ancré par pénalité.** Perte = terme adversarial + λ·‖E_G[Y|X] − f̂(X)‖² (+ moments). λ règle le curseur plasmode/réel ; la vérité n'est plus exacte.
- **A3 — générateur = plasmode (RealCause).** Vérité = E_G[Y|X] extraite d'un générateur ajusté au réel. Indiscernabilité maximale, contrôle expérimental minimal.

**Éviter le GAN proprement dit** aux tailles typiques des jeux spatiaux (instabilité, mode collapse). Alternatives sans discriminateur, avec outils R : engression (Shen & Meinshausen 2024, package `engression`, régression générative par score d'énergie), distributional random forests (`drf`), flows/diffusion conditionnels (tree flows de Wang, Awaya & Ma 2024 ; Forest-Flow de Jolicoeur-Martineau et al. 2024). En bayésien, BART fournit nativement des plasmodes distributionnels.

**Validation de l'indiscernabilité.** Classifier two-sample test (Lopez-Paz & Oquab 2017) ou pMSE (Snoke et al. 2018) sur (X, Y) réel vs (X, Y*) — accuracy proche de 50 % ; compléter par marginales de Y, moments conditionnels par tranches de f̂, et en spatial Moran's I des résidus et variogramme réel vs simulé.

---

## 3. Protocole de benchmark : DGP variés, estimateurs variés, estimandes comparables

Objectif : comparer des estimateurs (SAR, GWR/MGWR, SVC, boosting spatial, GAM, forêts…) sur des données où f est non linéaire avec quelques interactions et où le processus spatial varie (SAR, SVC/GWR, tendance, aspatial avec variable spatialement autocorrélée omise). La difficulté n'est pas de générer les DGP mais de rendre les estimandes comparables entre estimateurs de paramétrisations différentes.

### 3.1 Forme canonique unique

$$
Y = \rho W Y + f(X, s) + g(s) + u, \qquad u = \lambda W u + \varepsilon
$$

| Code | DGP | Blocs actifs | Estimateur « maison » |
|---|---|---|---|
| D0 | Linéaire aspatial | f linéaire | OLS |
| D1 | Non linéaire aspatial | f additive + interactions | GAM, boosting |
| D2 | SVC | f = Σ β_k(s) x_k, champs GP/Matérn | GWR / MGWR / spmoran |
| D3 | SVC multi-échelle | portées φ_k distinctes | MGWR |
| D4 | SVC + SAR | D3 + ρ > 0 | MGWRSAR |
| D5 | SAR non linéaire | ρ > 0, f non linéaire | BSPA / spboost, GAM-SAR |
| D6 | SEM non linéaire | λ > 0 | GAM-SEM |
| D7 | Tendance spatiale | g(s) GP | GAM `s(x,y)`, GP |
| D8 | Nonlinéarité spatialement variable | f = f_1(X) + h(x_j, s) non séparable | aucun |
| D9 | Variable omise autocorrélée | Y = f(X_obs, Z) + ε, Z réelle retirée (corrélée ou non aux X_obs) | aucun |

D2/D3 et D8 sont partiellement confondus (β(s)·x ressemble à une interaction lisse x × s) : c'est ce que le benchmark mesure, mais il faut le dire et éviter de conclure « X bat Y » sur un DGP où X est la vérité par construction. D9 est le seul DGP aspatial qui produit l'apparence d'un processus spatial ; il teste la robustesse des interprétations.

### 3.2 Réel vs simulé

- **Réel** : X, coordonnées, W, et Z (covariable à fort Moran's I) pour D9. Plusieurs jeux de domaines différents et plusieurs n.
- **Simulé** : f, champs β_k(s) et g(s), ρ/λ, ε. Deux sources de f : fonctions choisies (Friedman-like, additive + interactions, seuil) et f̂ plasmode ajustée sur le Y réel.
- Tirer un nouveau champ à chaque réplication (jamais un pattern unique).

### 3.3 Trois facteurs de difficulté communs — indispensables

Les paramètres natifs (ρ, λ, bandwidth, portée Matérn) ne sont pas commensurables entre familles. Chaque DGP est reparamétré par :

1. **SNR** : var(m)/var(ε), m = E[Y|X, s].
2. **Part spatiale** : var(composante spatiale)/var(f(X)).
3. **Portée spatiale** : fraction du diamètre du domaine, ou mesurée sur la composante spatiale simulée (portée effective du variogramme, Moran's I à W fixée).

Les paramètres natifs sont *calibrés numériquement* pour atteindre ces cibles (rescaler σ² des champs, résoudre ρ par recherche unidimensionnelle) et enregistrés comme sorties. Sans cela, une différence entre « SAR » et « SVC » peut n'être qu'une différence d'amplitude du signal spatial.

### 3.4 Estimandes communes

1. m̂(x, s) contre la vraie m sur points test — split spatial par blocs (interpolation) et par régions tenues à l'écart (extrapolation). C'est l'avantage du plasmode : comparaison à la vraie moyenne conditionnelle, pas à un Y bruité.
2. Effets partiels moyens et courbes de dépendance partielle (par différences finies) ; effets partiels locaux sur grille de sites pour les DGP SVC.
3. Impacts directs / indirects (LeSage & Pace 2009) reconstruits par différences finies pour les non-paramétriques quand ρ > 0.
4. Moran's I des résidus, couverture des intervalles, temps de calcul.

Présentation : par DGP et en **regret** relatif au meilleur estimateur de chaque DGP (à la Grinsztajn et al. 2022), rangs moyens, test de Friedman/Nemenyi.

### 3.5 DGP « maison » vs DGP tiré au hasard

Soit P(e, d, θ) la perte de l'estimateur e sur la famille d au point θ du design commun, et H(e) l'ensemble où e est correctement spécifié — une famille **et** une région de θ (un SAR paramétrique n'est chez lui que si f est linéaire ; GWR seulement si la portée est atteignable par sa recherche de bandwidth à ce n). Définir H(e) explicitement est un livrable.

- regret conditionnel : r(e, d, θ) = P(e, d, θ) − min_{e'} P(e', d, θ) ;
- perte maison : moyenne de r sur H(e) ;
- perte sous DGP aléatoire : E_{(d,θ)∼π}[r(e, d, θ)] ; l'écart mesure la fragilité à la mauvaise spécification.

Le choix de π est une décision : l'uniforme sur les familles est arbitraire. Alternative cohérente avec la logique plasmode : **π empirique** — ajuster les familles candidates sur chaque jeu réel et pondérer par leur adéquation (CV spatiale), pour une performance attendue « dans le monde réel ». Reporter les deux.

### 3.6 Deux designs Monte Carlo complémentaires

- **Grille factorielle fixe** : 2–3 niveaux par facteur commun × n × familles × réplications ; mêmes X et mêmes seeds pour tous les estimateurs (common random numbers) ; ANOVA / modèle mixte sur log-perte avec effets estimateur × facteur × famille, η² partiels, profils marginaux. Lecture interprétable.
- **Design aléatoire** : (d, θ, n, jeu) tirés selon π, une réplication par tirage, quelques milliers de tirages ; méta-régression du regret (GAM ou forêt + dépendance partielle). Couvre les interactions non prévues, notamment portée × n.

Les deux partagent la même fonction `dgp()` ; seule la façon de peupler la grille change.

### 3.7 Implémentation

`dgp(X, coords, W, design_row, seed)` → Y, m, effets partiels vrais, impacts vrais, paramètres natifs calibrés ; grille de design (jeu × DGP × SNR × part spatiale × portée × n × réplication) ; `fit_eval(estimator, ...)` unique ; pipeline `targets` + `future` ; seeds sauvegardés. Budgéter le temps de calcul dès le départ (GWR, MGWR, MGWRSAR sont les postes lourds).

---

## 4. Références clés

- Schreck, Slynko, Saadati & Benner (2024). Statistical plasmode simulations – potentials, challenges and recommendations. *Stat Med*, doi:10.1002/sim.10012.
- Franklin et al. (2014). Plasmode simulation for the evaluation of pharmacoepidemiologic methods. *CSDA*, 72.
- Morris, White & Crowther (2019). Using simulation studies to evaluate statistical methods. *Stat Med*, 38(11).
- Dorie et al. (2019). Automated versus do-it-yourself methods for causal inference. *Stat Sci*, 34(1). — ACIC.
- Hill (2011). *JCGS*, 20(1). — IHDP.
- Neal, Huang & Raghupathi (2020). RealCause. arXiv:2011.15007.
- Candès, Fan, Janson & Lv (2018). Model-X knockoffs. *JRSS-B*, 80(3).
- Rubin (1993) *JOS* ; Reiter (2003) *Survey Methodology* ; Nowok, Raab & Dibben (2016) synthpop, *JSS*, 74(11).
- Snoke et al. (2018). General and specific utility measures for synthetic data. *JRSS-A*. — pMSE.
- Lopez-Paz & Oquab (2017). Revisiting classifier two-sample tests. *ICLR*.
- Shen & Meinshausen (2024). Engression. *JRSS-B* (à vérifier) ; Ćevid et al. (2022). Distributional random forests. *JMLR*.
- Jolicoeur-Martineau, Fatras & Kachman (2024). Forest-Flow. *AISTATS* ; Wang, Awaya & Ma (2024). Tree flows. arXiv:2406.05260.
- Grinsztajn, Oyallon & Varoquaux (2022). *NeurIPS D&B*. — regret relatif au meilleur.
- LeSage & Pace (2009). *Introduction to Spatial Econometrics*. CRC.
