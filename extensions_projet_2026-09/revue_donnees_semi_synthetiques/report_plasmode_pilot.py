"""Render the completed pilot from its saved JSON; no model fitting or data edits."""
from pathlib import Path
import json, html, sys

ROOT = Path(__file__).resolve().parents[2]
OUT = Path(__file__).parent / "pilot_output_2026-09-08"
def main():
    result = json.loads((OUT / "results.json").read_text(encoding="utf-8"))
    summary, diagnostics, raw = result["summary"], result["diagnostics"], result["raw"]
    assert len(raw) == 2*7*result["repetitions"]*4
    assert not any(r["failed"] for r in raw)
    labels = {"reference":"P0 Référence", "omitted_z":"P1 Z omise", "curvature":"P2 Courbure", "interaction":"P3 Interaction", "measured_z":"P4 Z dégradée", "sem_positive":"P5 Bruit SEM", "heteroskedastic_control":"P6 Variance variable"}
    methods = {"linear":"Linéaire", "gam_covariates":"GAM covariables", "gam_spatial":"GAM + espace", "oracle_basis":"Base complète privilégiée"}
    md = ["# Premier pilote plasmode — 8 septembre 2026", ""]
    body = ["<h1>Premier pilote plasmode</h1><p class=\"subtitle\">8 septembre 2026 · Georgia et Meuse · étude de faisabilité</p>"]
    def paragraph(text):
        md.extend([text, ""]); body.append("<p>"+html.escape(text)+"</p>")
    def heading(text):
        md.extend(["## "+text, ""]); body.append("<h2>"+html.escape(text)+"</h2>")
    def table(headers, rows):
        md.append("| "+" | ".join(headers)+" |");md.append("| "+" | ".join("---" for _ in headers)+" |")
        body.append("<div class=\"table-wrap\"><table><thead><tr>"+"".join("<th>"+html.escape(str(x))+"</th>" for x in headers)+"</tr></thead><tbody>")
        for row in rows:
            md.append("| "+" | ".join(str(x).replace("|"," / ") for x in row)+" |")
            body.append("<tr>"+"".join("<td>"+html.escape(str(x))+"</td>" for x in row)+"</tr>")
        md.append("");body.append("</tbody></table></div>")
    def fmt(value):return "—" if value is None else f"{value:.3f}"
    paragraph("Le cadrage demandé par l’encadrant est appliqué : plasmode exclusivement, avec distinction entre information omise, forme du modèle et processus d’observation. Les sept scénarios du pilote ne couvrent pas toute la grille D0–D9.")
    paragraph(f"Exécution effective : {len(raw)} évaluations agrégées sur trois folds, soit {len(raw)*3} ajustements ; {result['repetitions']} réplications par source/scénario ; aucun échec ni warning de modèle. Les avertissements de locale au démarrage de R sont distincts. Trois concurrents et une référence diagnostique privilégiée sont séparés.")
    heading("Ce que ce pilote montre")
    paragraph("La présence d’un motif spatial dépend du signal réellement laissé inexpliqué. Pour Meuse, la courbure non représentée par le modèle linéaire présente un Moran descriptif de 0.304 ; pour Georgia, il est de -0.083. Une même famille de scénario ne garantit donc pas un effet spatial dans chaque dataset.")
    paragraph("L’interaction de Meuse a un motif spatial résiduel descriptif (Moran 0.297) mais une variance inexpliquée de seulement 0.0004 : elle est trop faible, dans ce design, pour créer une grande difficulté. La force du motif et son amplitude doivent être examinées ensemble.")
    paragraph("Sur la courbure de Georgia, la MSE normalisée moyenne passe de 0.274 pour le modèle linéaire à 0.092 pour le GAM sur covariables, contre 0.104 pour le GAM avec espace. Ici, la flexibilité des covariables suffit à améliorer la prédiction ; ajouter l’espace n’apporte pas automatiquement mieux. Ce sont des résultats descriptifs conditionnels, pas un verdict statistique.")
    paragraph("Sur Meuse avec Z omise, le GAM spatial obtient 0.209 contre 0.225 pour le GAM sur covariables ; le modèle linéaire reste à 0.150. Ce pilote ne montre donc pas une supériorité générale des méthodes spatiales lorsque Z manque. La référence privilégiée ne constitue pas non plus une borne parfaite : son estimation et sa complexité ajoutent de la variance.")
    paragraph("Le contrôle SEM produit des innovations spatialement corrélées (Moran moyen proche de 0.17 dans les deux sources). Le contrôle à variance variable conserve une covariance diagonale par construction ; une hétéroscédasticité spatialisée n’équivaut pas à une corrélation entre erreurs.")
    heading("Sources et fidélité du générateur")
    table(["Source","Lignes source","Calibration","Évaluation","Lignes exclues","R² réel hors calibration"], [[k,v["n_source"],v["n_calibration"],v["n_evaluation"],len(v["removed_rows"]),fmt(v["source_fit_evaluation_r2"])] for k,v in result["sources"].items()])
    paragraph("Le R² mesure la prédiction du Y réel par le générateur complet sur les sites non utilisés pour son ajustement. Il est de 0.235 pour Georgia et 0.747 pour Meuse. Le réalisme de Georgia est donc limité avec cette base. Ces sites sont intercalés géographiquement avec la calibration : ce contrôle de fidélité n’est pas une validation indépendante par région.")
    paragraph("Georgia : les colonnes longitude/latitude et les variables sont vérifiées contre spgwr::gSRDF par AreaKey ; la géométrie sf convertie incohérente est contournée seulement dans ce pilote. Meuse : x/y métriques RDH documentés ; deux lignes sans om retirées. Les originaux et le registre package sont conservés.")
    paragraph("La base y ~ x1 + x2 + z + I(x1²) + I(x2²) + x1:x2 est un choix système ajusté sur le réel, pas une formule publiée. Les scénarios désactivent ses blocs estimés. Ils ne prétendent pas représenter tous les phénomènes possibles. Georgia conserve l’échelle de PctBach dans le signal, mais le bruit gaussien ne garantit pas les bornes 0–100 d’un pourcentage.")
    heading("Performance des concurrents")
    paragraph("MSE normalisée = moyenne des erreurs quadratiques sur la moyenne latente connue, divisée par sa variance sur les sites. Valeur plus faible = erreur plus faible pour cette cible. ± désigne une erreur standard Monte Carlo, pas un intervalle de confiance intégrant l’incertitude des sources ou du générateur.")
    md.extend(["![Performances et erreurs standard Monte Carlo](performance_pilote.png)",""])
    body.append("<img src=\"performance_pilote.png\" alt=\"Performances des trois concurrents par scénario et source ; barres d’une erreur standard Monte Carlo\">")
    for dataset in result["sources"]:
        heading(dataset.capitalize())
        index={(r["scenario"],r["method"]):r for r in summary if r["dataset"]==dataset}
        table(["Scénario"]+[methods[m] for m in ("linear","gam_covariates","gam_spatial")], [[label]+[fmt(index[(scenario,m)]["nmse_mean"])+" ± "+fmt(index[(scenario,m)]["mcse"]) for m in ("linear","gam_covariates","gam_spatial")] for scenario,label in labels.items()])
    heading("Signal laissé inexpliqué par une référence linéaire")
    paragraph("Diagnostic sur la vérité connue, projetée sur les variables accessibles au modèle linéaire. Ce calcul utilise m uniquement pour l’analyse et ne fournit aucune information aux concurrents. Il faut distinguer ces résidus déterministes des résidus bruités hors échantillon du tableau suivant. Un tiret indique un signal nul à la précision numérique.")
    table(["Source","Scénario","Variance inexpliquée","Moran du signal inexpliqué"], [[r["dataset"],labels[r["scenario"]],f"{r['linear_unexplained_variance']:.4f}",fmt(r["linear_unexplained_moran"])] for r in diagnostics])
    heading("Résidus hors échantillon et contrôle privilégié")
    paragraph("Moran descriptif moyen sur les prédictions assemblées des trois folds, sans p-value. La référence privilégiée reçoit la vraie Z et la base du générateur ; elle est exclue de la figure des concurrents. Aucun classement global, regret agrégé ni verdict win/tie/loss n’est produit.")
    table(["Source","Scénario","Méthode","Rôle","MSE normalisée","Moran résiduel"], [[r["dataset"],labels[r["scenario"]],methods[r["method"]],"diagnostic privilégié" if r["role"]=="diagnostic_privileged" else "concurrent",fmt(r["nmse_mean"]),fmt(r["residual_moran"])] for r in summary])
    heading("Tests, reproduction et limites")
    paragraph("Les tests passent : coordonnées et clés Georgia, partitions disjointes, W standardisé, graines reproductibles, égalité de Y entre référence/omission/proxy, décomposition du générateur, SNR attendu, covariance SEM ou diagonale selon le contrôle, absence de dépendance aux Y de test pour la calibration et la prédiction.")
    paragraph("Le SNR attendu est 3 ; W utilise quatre plus proches voisins symétrisés puis standardisés par ligne, en mètres. Les paramètres et matrices sont conservés. Les trois bandes est-ouest sont fixes, sans tampon spatial. Les effectifs sont petits ; aucune convergence du nombre de réplications n’est démontrée.")
    paragraph("Dans le scénario de mesure dégradée, on évalue la moyenne latente sur les sites et covariables complets fixes. On ne connaît pas ici une fonction de population E[Y|X bruités] intégrant toutes les réalisations possibles de l’erreur de mesure. Le proxy n’est tiré qu’une fois ; cette limite doit être levée dans une étude plus large.")
    paragraph("Ces scripts autonomes testent lm et mgcv ; ils ne certifient pas les wrappers de spatialtidymodels. Aucune simulation SVC, SAR, g(s), changement de support ou lissage n’est exécutée. La note originale de l’encadrant et les admissions du catalogue restent inchangées.")
    commands=["Rscript extensions_projet_2026-09/revue_donnees_semi_synthetiques/test_plasmode_pilot.R","Rscript extensions_projet_2026-09/revue_donnees_semi_synthetiques/plasmode_pilot.R 20","Rscript extensions_projet_2026-09/revue_donnees_semi_synthetiques/plot_plasmode_pilot.R","python extensions_projet_2026-09/revue_donnees_semi_synthetiques/report_plasmode_pilot.py"]
    md.extend(["```powershell",*commands,"```",""]);body.append("<pre>"+html.escape("\n".join(commands))+"</pre>")
    paragraph("L’enrichissement des diagnostics de projection a été exécuté par enrich_pilot_diagnostics.R sur les objets sauvegardés, sans réajuster les concurrents ; le pilote courant calcule également ces champs directement. Les objets sources sont contrôlés par empreinte MD5 dans le run. Le contrôle externe SHA256 confirme les deux RDS inchangés ; il observe aussi des modifications concomitantes de fiches et registres hors pilote, conservées sans intervention. Le détail à l’instant du contrôle est dans preservation_check.json. La synthèse originale de l’encadrant est inchangée.")
    heading("Décisions proposées avant la suite")
    paragraph("Retenir Meuse pour approfondir la courbure et l’omission ; conserver Georgia comme contre-exemple de fidélité limitée, sans remplacer a posteriori les résultats. Choisir une seconde famille génératrice avant toute conclusion sur les méthodes ; répliquer les folds et les proxies, examiner un tampon spatial, puis augmenter les réplications selon la précision requise.")
    paragraph("L’agrégation et le lissage restent des pistes distinctes à formaliser avec de vraies unités et groupes. La priorité est de valider avec l’encadrant les mécanismes et les cibles de ce pilote, puis seulement d’étendre lambda, f, g et u et d’intégrer les routes au package.")
    md.append("[Protocole détaillé](../../../wiki/analyses/protocole_plasmode_spatial_2026-09-08.md) · [Résultats JSON](results.json) · [Résultats RDS](results.rds)")
    body.append("<p><a href=\"../../../wiki/analyses/protocole_plasmode_spatial_2026-09-08.md\">Protocole détaillé</a> · <a href=\"results.json\">JSON</a> · <a href=\"results.rds\">RDS</a></p>")
    (OUT/"rapport_pilote.md").write_text("\n".join(md).rstrip()+"\n",encoding="utf-8")
    style="body{font:17px/1.6 system-ui,sans-serif;background:#f4f5f2;color:#1b262c;margin:0}main{max-width:1100px;margin:auto;padding:42px 24px 80px}h1{font-size:36px;line-height:1.2}h2{margin-top:38px;color:#225f59}.subtitle{color:#5a666a}a{color:#176e80}img{width:100%;height:auto;border:1px solid #ddd;border-radius:8px;background:white}table{width:100%;border-collapse:collapse;font-size:14px;background:white}th,td{text-align:left;padding:9px 12px;border-bottom:1px solid #e1e6e4}th{background:#e1ebe7;position:sticky;top:0}tr:nth-child(even){background:#f7f9f7}.table-wrap{overflow:auto}pre{white-space:pre-wrap;overflow-wrap:anywhere;padding:20px;background:#e7ece9;font-size:13px;border-radius:8px}@media(max-width:650px){main{padding:24px 14px}h1{font-size:29px}body{font-size:16px}}@media print{body{background:white}main{max-width:none}h2{break-after:avoid}tr{break-inside:avoid}} "
    page="<!doctype html><html lang=\"fr\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"><title>Pilote plasmode — 8 septembre 2026</title><style>"+style+"</style></head><body><main>"+"\n".join(body)+"</main></body></html>"
    (OUT/"rapport_pilote.html").write_text(page,encoding="utf-8")
    print("Report written:",len(raw),"evaluations,",sum(r["failed"] for r in raw),"failures.")

if __name__=="__main__":main()
