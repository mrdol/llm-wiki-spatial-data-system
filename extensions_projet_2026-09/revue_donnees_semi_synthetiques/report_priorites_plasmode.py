"""Render the descriptive report from existing results; no inferred package verdict."""
from pathlib import Path
import json

BASE = Path(__file__).resolve().parent / "priority_output_2026-09-09"
r = json.loads((BASE / "results.json").read_text(encoding="utf-8"))


def table(headers, rows):
    return "\n".join(["| " + " | ".join(headers) + " |",
                      "| " + " | ".join(["---"] * len(headers)) + " |"] +
                     ["| " + " | ".join(map(str, row)) + " |" for row in rows])


contrasts = [d for d in r["paired_contrasts"] if d["contrast"] == "forest - polynomial"]
contrasts.sort(key=lambda d: (d["dataset"], d["generator"] != "polynomial"))
families = {"polynomial": "Polynôme", "forest": "Forêt"}
lines = [
    "# Résultats des priorités plasmode — 9 septembre 2026\n",
    "**Le choix du générateur inverse l'écart forêt–polynôme sur les deux sources.** "
    "Les supports recouvrants créent aussi une covariance observable malgré des innovations latentes indépendantes. "
    "Ce sont des résultats du protocole conditionnel décrit dans la [note méthodologique](../priorites_plasmode_2026-09-09.md).\n",
    "## 1. Sensibilité aux générateurs\n",
    "Deux sources × deux générateurs × cinq méthodes × 40 réplications = **800 évaluations**, "
    "soit 2 400 ajustements de fold pour les scores, plus les réajustements de vérification de non-fuite. "
    f"Échecs : {sum(d['failed'] for d in r['raw'])} ; évaluations avec avertissement de modèle : "
    f"{sum(bool(d['warning']) for d in r['raw'])}. Les avertissements de locale au démarrage de R sont distincts des avertissements de modèle.\n",
    "La différence est NMSE(forêt) − NMSE(polynôme). Un signe positif correspond à un risque plus faible pour le polynôme ; "
    "un signe négatif à un risque plus faible pour la forêt. MCSE = erreur standard Monte Carlo de la différence appariée.\n",
    table(["Source", "Générateur", "Différence", "MCSE"],
          [(d["dataset"].title(), families[d["generator"]], f"{d['difference']:+.4f}", f"{d['mcse']:.4f}") for d in contrasts]),
    "\nL'inversion apparaît pour les deux sources. Elle démontre une sensibilité dans ces réglages, "
    "sans fournir de classement universel ni établir la supériorité scientifique d'une famille génératrice. "
    "Chaque générateur induit sa propre moyenne, sa propre variance de signal et sa propre difficulté ; "
    "les innovations standardisées sont appariées et le SNR fixé à 3.\n",
    table(["Source", "Changement de l'écart, générateur forêt moins polynomial", "MCSE appariée"],
          [(d["dataset"].title(), f"{d['difference']:+.4f}", f"{d['mcse']:.4f}")
           for d in r["between_generator_contrast_change"] if d["contrast"] == "forest - polynomial"]),
    "\nLe supplément spatial du GAM augmente le risque moyen par rapport au GAM de covariables dans les quatre configurations "
    "(écarts et MCSE dans le JSON). Cette observation concerne lambda = 0, les bandes fixes et ces réglages ; "
    "elle ne condamne pas les lissages spatiaux en général.\n",
    "### Fidélité des générateurs sur les réponses réelles hors calibration\n",
    table(["Source", "Générateur", "R² hors calibration", "Sites calibration / évaluation"],
          [(d["dataset"].title(), families[d["generator"]], f"{d['source_evaluation_r2']:.3f}",
            f"{d['calibration_n']} / {d['evaluation_n']}") for d in r["source_fidelity"]]),
    "\nLa forêt représente mieux ces Y réels selon ce diagnostic ponctuel. Georgia reste moins bien représenté. "
    "Ce R² ne justifie pas de supprimer le générateur polynomial ni de retenir la forêt comme vérité du monde réel. "
    "La calibration entrelacée ne mesure pas le transfert vers un territoire distant.\n",
    "## 2. Supports recouvrants : covariance et validation\n",
    "Moran est calculé sur le bruit observé, centré sur la **vraie moyenne observée H_obs m** ; "
    "ce ne sont pas des résidus d'un modèle ajusté. Les contrôles indépendants ont les mêmes variances marginales.\n",
    table(["Source", "alpha", "Moran moyen", "MCSE", "Contrôle indépendant", "Paires entre folds partageant des sources"],
          [(d["dataset"].title(), d["alpha"], f"{d['mean_moran']:.4f}", f"{d['mcse_moran']:.4f}",
            f"{d['independent_mean_moran']:.4f}",
            f"{int(d['train_test_pairs_with_shared_sources'])} / {int(d['cross_fold_pairs'])}") for d in r["smoothing"]]),
    "\nÀ alpha = 0,5, le Moran moyen est proche de 0,385 pour les deux sources, contre environ −0,01 pour les contrôles. "
    "Les covariances empiriques de 10 000 tirages diffèrent des matrices analytiques de 7,5 à 10,4 % "
    "en norme de Frobenius relative : contrôle numérique avec erreur Monte Carlo, et non identité numérique exacte. "
    "Le seuil de contrôle fixé dans le script est 15 %.\n",
    "Le partage porte sur des paires non ordonnées de sites appartenant à des folds différents. "
    "Les 143 paires Georgia et 82 paires Meuse rendent nécessaire un traitement des supports sources "
    "pour une évaluation visant des mesures indépendantes. Aucun score prédictif sur ces réponses lissées n'est présenté.\n",
    "## 3. Agrégation non linéaire disjointe\n",
    table(["Source", "Groupes", "RMSE des moments omis", "MSE / variance moyenne agrégée", "Moran de l'écart"],
          [(d["dataset"].title(), d["n_groups"], f"{d['rmse_missing_moments']:.4f}",
            f"{d['normalized_mse_missing_moments']:.4f}", f"{d['discrepancy_moran']:.4f}") for d in r["aggregation"]]),
    "\nLes RMSE sont dans les unités de réponse du générateur : points de pourcentage pour Georgia, log(zinc) pour Meuse. "
    "Leur taille ne permet donc pas une comparaison directe entre sources. Le Moran de l'écart est descriptif, sans test de significativité.\n",
    "L'ajout des variances internes et de la covariance interne reconstitue la moyenne agrégée avec une erreur "
    f"maximale de {max(d['identity_max_error'] for d in r['aggregation']):.2e}. "
    "La covariance hors diagonale des bruits agrégés est exactement nulle pour les groupes disjoints. "
    "Le signal omis et la covariance des innovations sont donc bien deux objets différents. "
    "Les groupes par ordre est–ouest servent à vérifier l'algèbre ; ils ne remplacent pas des supports géographiques substantifs.\n",
    "## 4. Vérifications et limites\n",
    "- Altération des Y réels hors calibration : aucune modification des moyennes génératrices, pour les deux familles.\n"
    "- Altération des Y de test : mêmes prédictions pour chaque méthode, famille, source et fold de la première réplication.\n"
    "- Empreintes MD5 des deux objets sources identiques avant et après le calcul.\n"
    "- Contrôles de covariance, normalisation des poids et identité d'agrégation passants.\n"
    "- Les erreurs Monte Carlo couvrent seulement les innovations, avec calibration, sources, folds et graines algorithmiques fixes.\n"
    "- Réglages prédéfinis sans tuning ; deux sources seulement ; pas de verdict statistique du package.\n",
    "![Sensibilité au générateur et effet d'observation](sensibilite_et_observation.png)\n",
    "Figure : barres de gauche = moyenne ±1,96 MCSE, approximation de l'incertitude Monte Carlo conditionnelle ; "
    "elles ne représentent pas l'incertitude de sélection des sources ou du générateur. "
    "Les deux courbes de Moran de droite sont presque superposées.\n",
    "Fichiers : [configuration](config.json), [résultats détaillés](results.json), [objets R](results.rds), "
    "[versions logicielles](sessionInfo.txt), [script de calcul](../priorites_plasmode.R). "
    "Le rapport est régénérable par `report_priorites_plasmode.py`, la figure par `plot_priorites_plasmode.R`.\n",
]
(BASE / "lecture_resultats.md").write_text("\n".join(lines), encoding="utf-8")
print(BASE / "lecture_resultats.md")
