# Genere F2_pipeline_curation.png : schema du pipeline de curation
# (equivalent du schema de delimitation de bassin de LamaH-CE, Fig. 2).
# Sources du contenu :
#  - Memoire/Rapport de stage/DOLIVEIRAjohnny_internshipreportM2.tex,
#    lignes 270 et 345-349 (les trois blocs de collecte, LEUR VRAI ORDRE
#    CHRONOLOGIQUE : Bloc 1 logiciel en premier, Bloc 2 dataset-first en
#    second, Bloc 3 article-first en dernier -- complement de Bloc 2, pas
#    une voie independante essayee en premier). Utilise ici uniquement
#    comme aide d'orientation historique, confirme par l'utilisateur.
#  - wiki/metadata/paper_dataset_ingestion_pipeline_2026-08.md pour le
#    detail technique des deux voies papier (mesure du rendement 4%
#    article-first, etc.).
#  - code/r_catalog/create_r_software_catalog.R, build_sf_datasets.R,
#    generate_fiches.py pour la voie logicielle.
# Corrige le 24 septembre 2026 : (1) boites bleues et texte reduits
# (densite trop forte signalee par l'utilisateur), (2) ordre et cadrage
# de la voie article-first corriges (elle vient en dernier, en
# complement de dataset-first, motivee par un corpus d'articles deja
# reuni pour la meta-analyse -- pas une voie essayee en premier et
# remplacee).
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch
from matplotlib.lines import Line2D

fig, ax = plt.subplots(figsize=(11.5, 12.5))
ax.set_xlim(0, 12)
ax.set_ylim(0, 15.5)
ax.axis("off")

COL_SOFT = "#6b8c6b"
COL_ROUTE = "#8c9bab"
COL_SHARED = "#2e6f95"
COL_VERIF = "#c0392b"
COL_DECISION = "#2e7d4f"
TEXT_WHITE = "white"


def box(x, y, w, h, text, color, fontsize=7.4, textcolor=TEXT_WHITE, style="round,pad=0.018,rounding_size=0.07"):
    b = FancyBboxPatch((x - w / 2, y - h / 2), w, h, boxstyle=style,
                        linewidth=0, facecolor=color)
    ax.add_patch(b)
    ax.text(x, y, text, ha="center", va="center", fontsize=fontsize,
             color=textcolor, wrap=True, linespacing=1.2)
    return (x, y, w, h)


def arrow(b_from, b_to, **kw):
    x0, y0, w0, h0 = b_from
    x1, y1, w1, h1 = b_to
    start = (x0, y0 - h0 / 2) if y0 > y1 else (x0, y0 + h0 / 2)
    end = (x1, y1 + h1 / 2) if y0 > y1 else (x1, y1 - h1 / 2)
    a = FancyArrowPatch(start, end, arrowstyle="-|>", mutation_scale=11,
                         linewidth=1.1, color="#333333", **kw)
    ax.add_patch(a)


# --- Three entry routes, in their real chronological/logical order:
# Bloc 1 (software) -> Bloc 2 (dataset-first) -> Bloc 3 (article-first,
# a complement of Bloc 2, not an equal alternative tried first).
b_soft = box(1.7, 14.8, 3.0, 0.8,
             "Bloc 1 -- Software route\nR/Python package datasets\n(no paper to extract)",
             COL_SOFT, fontsize=7.2)
b_dataset = box(5.7, 14.8, 3.6, 0.8,
                 "Bloc 2 -- Dataset-first\nDryad/Zenodo/DataCite keyword search ->\nread linked publication from repo metadata",
                 COL_ROUTE, fontsize=7.0)
b_article = box(9.7, 14.8, 3.6, 0.8,
                 "Bloc 3 -- Article-first (complement)\nStarted from an article corpus already\nassembled for the meta-analysis; used when\na known paper's data is not found via Bloc 2",
                 COL_ROUTE, fontsize=6.8)

b_softcat = box(1.7, 13.4, 3.0, 0.7,
                "Combined R/Python package\ncatalogue (cross-language)",
                COL_SOFT, fontsize=7.2)
b_verified = box(5.7, 13.4, 3.6, 0.7,
                  "Repository file existence verified\nvia API (Dryad/Zenodo) before ingestion",
                  COL_ROUTE, fontsize=7.0)
b_pdf = box(9.7, 13.4, 3.6, 0.7,
            "PDF resolver (DOI -> PMC -> OA mirrors\n-> optional headless browser); never\nbypass paywall/CAPTCHA",
            COL_ROUTE, fontsize=6.8)

b_tei = box(7.7, 12.05, 5.0, 0.62, "GROBID: PDF -> structured TEI XML\n(paper routes only)", COL_SHARED, fontsize=7.0)
b_kg = box(7.7, 11.05, 5.0, 0.72,
           "Knowledge graph: dataset mentions,\nY/X roles, formulas, repository links,\nlicenses (paper routes only)",
           COL_SHARED, fontsize=6.8)
b_audit = box(7.7, 10.0, 5.0, 0.72,
              "Automated candidate audit +\nprioritized curation queue (no raw\nsignal becomes a sheet directly)",
              COL_SHARED, fontsize=6.8)

b_loader = box(6.0, 8.85, 5.4, 0.95,
               "Re-executable loader -> unified\nsf object -> versioned local artifact\n"
               "(software route: package docs are\nthe primary evidence)",
               COL_SHARED, fontsize=6.8)
b_sheet = box(6.0, 7.7, 5.4, 0.82,
              "Six-block sheet: artifact +\ndeclared roles + primary evidence\n(KG for papers; package help\ndocs for software)",
              COL_SHARED, fontsize=6.6)

b_verif1 = box(3.2, 6.5, 5.0, 1.15,
               "Verification 1 -- against primary source\nRe-read paper Methods/Data/Results, or package\ndocumentation. Covariate genuine (not a weight/\nexclusion mask)? Temporal var. genuine?\nN = authors' analytic sample, not raw file?",
               COL_VERIF, fontsize=6.8)
b_verif2 = box(8.8, 6.5, 5.0, 1.15,
               "Verification 2 -- self-consistency\nDeterministic, rule-based, no LLM, identical on all\nroutes. Formula vars declared? yes status never with\nunresolved formula? N consistent? Eligibility aligned?",
               COL_VERIF, fontsize=6.8)

b_posthoc = box(6.0, 5.1, 5.6, 0.72,
                "Dataset-first orphans: targeted post-hoc\nsearch -> formula confirmed / revised /\nleft unresolved",
                COL_SHARED, fontsize=6.8)

b_promo = box(6.0, 3.8, 5.8, 1.0,
              "Conservative promotion gate, applied\nuniformly across routes: response +\ncovariates + spatial support + formula +\nartifact required, or documented as missing",
              COL_DECISION, fontsize=6.9)

b_registry = box(3.8, 2.6, 4.0, 0.68, "package_include:\nyes / manual_review / no", COL_DECISION, fontsize=7.0)
b_bundle = box(8.2, 2.6, 4.0, 0.68, "storage: bundled / repo_only\n(independent decision)", COL_DECISION, fontsize=6.8)

arrow(b_soft, b_softcat)
arrow(b_dataset, b_verified)
arrow(b_article, b_pdf)
arrow(b_verified, b_tei)
arrow(b_pdf, b_tei)
arrow(b_tei, b_kg)
arrow(b_kg, b_audit)
arrow(b_softcat, b_loader)
arrow(b_audit, b_loader)
arrow(b_loader, b_sheet)
arrow(b_sheet, b_verif1)
arrow(b_sheet, b_verif2)
arrow(b_verif1, b_posthoc)
arrow(b_verif2, b_posthoc)
arrow(b_posthoc, b_promo)
arrow(b_promo, b_registry)
arrow(b_promo, b_bundle)

legend_elems = [
    Line2D([0], [0], marker="s", color="none", markerfacecolor=COL_SOFT, markersize=11, label="Software route (Bloc 1)"),
    Line2D([0], [0], marker="s", color="none", markerfacecolor=COL_ROUTE, markersize=11, label="Paper routes (Bloc 2-3)"),
    Line2D([0], [0], marker="s", color="none", markerfacecolor=COL_SHARED, markersize=11, label="Shared pipeline step"),
    Line2D([0], [0], marker="s", color="none", markerfacecolor=COL_VERIF, markersize=11, label="Mandatory verification"),
    Line2D([0], [0], marker="s", color="none", markerfacecolor=COL_DECISION, markersize=11, label="Human-controlled decision"),
]
ax.legend(handles=legend_elems, loc="lower center", bbox_to_anchor=(0.5, -0.03),
          ncol=3, frameon=False, fontsize=7.2)

fig.suptitle("Data collection, provenance and curation pipeline", fontsize=13, y=0.995)
fig.text(0.5, 0.005,
         "Blocs 1-2-3 follow the project's actual chronology (software first, then dataset-first, then article-first as a "
         "complement to it -- not three routes tried in parallel or article-first tried first). "
         "A pilot fourth, warehouse-sourced route (one sheet) reuses this architecture and is omitted here for legibility.",
         ha="center", fontsize=6.6, style="italic", color="#444444")

fig.tight_layout(rect=[0.01, 0.02, 0.99, 0.98])
fig.savefig("extensions_projet_2026-09/redaction_datapaper/figures/F2_pipeline_curation.png",
            dpi=200, bbox_inches="tight")
print("wrote F2_pipeline_curation.png")
