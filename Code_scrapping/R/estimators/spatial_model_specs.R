# Registre central des specifications de modeles pour le benchmark spatial.
#
# Ce fichier decrit quels estimateurs sont disponibles et comment chacun doit
# etre appele par le pipeline. Le script benchmark_manual_test_2026-07.R reste
# responsable des datasets, folds, tuning et sorties; ce fichier garde la
# feuille de route technique des modeles.

# ---------------------------------------------------------------------------
# Specifications des modeles
# ---------------------------------------------------------------------------
build_specs <- function(y, x, coords = c("coord_x", "coord_y"),
                        spboost_mstop = 200, mgwrsar_bandwidth = 20,
                        mgwrsar_kernel = "bisq") {
  # Chaque entree contient:
  # - spec: la specification parsnip du modele;
  # - formula: la formule transmise au workflow ou au fit direct;
  # - score: optionnel, pour les estimateurs hors parsnip scores directement.
  #
  # Pour les modeles spatiaux custom, la formule inclut coord_x/coord_y afin
  # que workflows conserve ces colonnes. Les wrappers les retirent ensuite de
  # la formule backend: elles servent aux distances/W, pas comme covariables.
  list(
    # OLS simple: parsnip::linear_reg(engine="glm") EST l'OLS simple (famille
    # gaussienne par defaut, lien identite, aucun terme spatial). Ce baseline
    # ne doit donc pas etre duplique sous un autre nom.
    glm = list(
      spec = parsnip::linear_reg(mode = "regression") |> parsnip::set_engine("glm"),
      formula = build_estimator_formula(y, x)
    ),

    # Baselines ML natives tidymodels: une version stricte X seules et une
    # version "_xy" qui ajoute les coordonnees comme covariables brutes. Les
    # versions "_xy" ne modelisent pas une structure spatiale explicite.
    earth = list(
      spec = parsnip::mars(mode = "regression") |> parsnip::set_engine("earth"),
      formula = build_estimator_formula(y, x)
    ),
    earth_xy = list(
      spec = parsnip::mars(mode = "regression") |> parsnip::set_engine("earth"),
      formula = build_estimator_formula(y, c(x, coords))
    ),
    random_forest = list(
      spec = parsnip::rand_forest(mode = "regression") |> parsnip::set_engine("ranger"),
      formula = build_estimator_formula(y, x)
    ),
    random_forest_xy = list(
      spec = parsnip::rand_forest(mode = "regression") |> parsnip::set_engine("ranger"),
      formula = build_estimator_formula(y, c(x, coords))
    ),
    xgboost = list(
      spec = parsnip::boost_tree(mode = "regression") |> parsnip::set_engine("xgboost"),
      formula = build_estimator_formula(y, x)
    ),
    xgboost_xy = list(
      spec = parsnip::boost_tree(mode = "regression") |> parsnip::set_engine("xgboost"),
      formula = build_estimator_formula(y, c(x, coords))
    ),

    # Exception volontaire: workflow() prepare mal le terme mgcv::s() dans
    # notre usage formule. On garde donc parsnip::fit() direct pour ce GAM.
    gam_spatial = list(
      spec = parsnip::gen_additive_mod(mode = "regression") |> parsnip::set_engine("mgcv"),
      formula = build_gam_spatial_formula(y, x, coords),
      use_workflow = FALSE
    ),

    # SpBoost est un wrapper parsnip custom complet: il passe par workflow()
    # et peut etre tune par tune_grid() sur mstop.
    spboost = list(
      spec = spboost_reg(coords = coords, DGP = "SAR", mstop = spboost_mstop,
                         nu = 0.1, k_neighbors = 8) |>
        parsnip::set_engine("spboost") |> parsnip::set_mode("regression"),
      formula = build_estimator_formula(y, c(x, coords))
    ),

    # GWR simple via le package MGWRSAR: une seule bande passante H pour tous
    # les coefficients locaux. Le prefixe "mgwrsar_" indique le moteur R, le
    # suffixe "gwr" indique le modele statistique reel.
    mgwrsar_gwr = list(
      spec = mgwrsar_reg(coords = coords, model_type = "GWR",
                         kernels = mgwrsar_kernel,
                         bandwidth = mgwrsar_bandwidth) |>
        parsnip::set_engine("mgwrsar") |> parsnip::set_mode("regression"),
      formula = build_estimator_formula(y, c(x, coords))
    ),

    # SAR simple pour baseline: lambda constant, beta constants, aucune
    # variation spatiale des coefficients. La matrice W est construite dans le
    # wrapper MGWRSAR, car le backend ne la fabrique pas seul.
    mgwrsar_sar = list(
      spec = mgwrsar_reg(coords = coords, model_type = "SAR") |>
        parsnip::set_engine("mgwrsar") |> parsnip::set_mode("regression"),
      formula = build_estimator_formula(y, c(x, coords))
    ),

    # SAR/SEM/SDM natifs spatialreg. Ces modeles ne sont pas encore des
    # wrappers parsnip: ils passent par une fonction score directe car leurs
    # predictions hors-echantillon demandent un objet listw explicite.
    sar_lag = list(
      score = function(split, y_resp) score_spatialreg_split(split, y_resp, x, coords, model_type = "SAR")
    ),
    sem_error = list(
      score = function(split, y_resp) score_spatialreg_split(split, y_resp, x, coords, model_type = "SEM")
    ),
    sdm_mixed = list(
      score = function(split, y_resp) score_spatialreg_split(split, y_resp, x, coords, model_type = "SDM")
    ),

    # MGWRSAR avec autocorrelation spatiale: Model="MGWRSAR_1_0_kv" ajoute le
    # terme W*y via control(W = W). W est construit une fois dans le wrapper a
    # partir des k plus proches voisins et reste fixe pendant le fit.
    mgwrsar_mgwrsar = list(
      spec = mgwrsar_reg(coords = coords, model_type = "MGWRSAR_1_0_kv",
                         kernels = mgwrsar_kernel,
                         bandwidth = mgwrsar_bandwidth) |>
        parsnip::set_engine("mgwrsar") |> parsnip::set_mode("regression"),
      formula = build_estimator_formula(y, c(x, coords))
    ),

    # MGWR multiscale via mgwrsar::TDS_MGWR(): bande passante differente par
    # covariable, trouvee par backfitting. Pas de bandwidth/kernel externe a
    # tuner ici: l'algorithme est auto-suffisant.
    mgwrsar_mgwr = list(
      spec = mgwrsar_reg(coords = coords, model_type = "tds_mgwr", kernels = "gauss") |>
        parsnip::set_engine("mgwrsar") |> parsnip::set_mode("regression"),
      formula = build_estimator_formula(y, c(x, coords))
    ),

    # spmoran: ESF ajoute des filtres spatiaux selectionnes; RE-ESF traite
    # l'effet spatial comme un effet aleatoire. Les deux sont scores hors
    # parsnip pour garder le controle sur meigen/meigen_f et la projection test.
    spmoran_esf = list(
      score = function(split, y_resp) score_spmoran_split(split, y_resp, x, coords, random_effect = FALSE)
    ),
    spmoran_resf = list(
      score = function(split, y_resp) score_spmoran_split(split, y_resp, x, coords, random_effect = TRUE)
    )
  )
}
