# Test manuel de benchmark (2026-07).
#
# Objectif: comparer GLM, GAM spatial, SpBoost et MGWRSAR/GWR sur des datasets
# spatiaux a variable reponse continue, avec:
# - un holdout pur de 10 %;
# - une validation "near-prediction";
# - une validation spatiale par blocs non hexagonaux.
#
# A lancer depuis le dossier Code_scrapping:
#   setwd(".../Code_scrapping")
#   source("R/estimators/benchmark_manual_test_2026-07.R")
#   out <- run_manual_test(c("nyc_education"))

source("R/utils/estimator_common.R")
source("R/utils/spatial_cv.R")
source("R/estimators/parsnip_spboost.R")
source("R/estimators/parsnip_mgwrsar.R")
source("R/utils/hyperparam_tuning.R")
source("R/utils/spatial_viz.R")

# Packages tidymodels utilises dans ce script.
library(parsnip)
library(rsample)
library(yardstick)
library(workflows)
library(mgcv)

REPO_ROOT <- normalizePath("..")

# ---------------------------------------------------------------------------
# Registre des datasets
# ---------------------------------------------------------------------------
# Chaque entree decrit comment charger le .rds, quelle variable predire, quels
# predicteurs utiliser, et comment obtenir des coordonnees metriques.
DATASETS <- list(
  # Petit dataset de reference: utile pour tester vite que toute la chaine
  # fonctionne avant de lancer un jeu plus gros comme nyc_education.
  georgia = list(
    rds = "data/final_datasets/sf/Python_libpysal_georgia.rds",
    y = "PctBach", x = c("PctRural", "PctFB", "PctBlack", "PctEld"),
    coords_raw = c("X", "Y"), raw_crs = 4326, target_crs = 26916,
    drop_cols = "geom_origine",
    # Pool 90 % ~= 143 obs. build_near_prediction_folds exige
    # n >= n_reps * test_size; les deux valeurs restent donc petites ici.
    near_n_reps = 3L, near_test_size = 20L
  ),

  # Dataset immobilier anglais fourni par GWmodel. Les coordonnees sont deja
  # dans le CRS metrique EPSG:27700, donc aucune reprojection n'est necessaire.
  # Formule alignee sur wiki/datasets/packages/R_GWmodel_EWHP_ewhp.md
  # (formula_pub, 2026-07-04): TypDetch/TypSemiD/TypFlat avaient ete omis par
  # erreur dans une version anterieure de ce registre alors qu'ils sont bien
  # presents dans le .rds (dummies 0/1, 0% NA, verifie 2026-07-04).
  ewhp = list(
    rds = "data/final_datasets/sf/R_GWmodel_EWHP_ewhp.rds",
    y = "PurPrice",
    x = c("BldIntWr", "BldPostW", "Bld60s", "Bld70s", "Bld80s",
          "TypDetch", "TypSemiD", "TypFlat", "FlrArea"),
    coords_raw = c("Easting", "Northing"), raw_crs = 27700, target_crs = 27700,
    drop_cols = "geom_origine",
    near_n_reps = 8L, near_test_size = 20L
  ),

  # Dataset agricole: les coordonnees source sont longitude/latitude, mais les
  # modeles spatiaux ont besoin de distances metriques; on projette en UTM 20S.
  lasrosas = list(
    rds = "data/final_datasets/sf/R_agridat_lasrosas.corn_lasrosas.corn.rds",
    # La formule canonique de mission utilise les noms transformes de GeoDa,
    # pas les noms bruts presents dans ce .rds. Pour cette passe de validation,
    # on utilise une formule numerique simplifiee et on ecarte topo.
    y = "yield", x = c("nitro", "bv"),
    coords_raw = c("long", "lat"), raw_crs = 4326, target_crs = 32720,
    drop_cols = "geom_origine",
    near_n_reps = 20L, near_test_size = 100L
  ),

  # Dataset NYC ajoute pour tester le pipeline sur un N plus grand. Ici on
  # extrait les coordonnees depuis la geometrie sf, pas depuis les colonnes X/Y.
  # Formule alignee sur wiki/datasets/packages/Python_geodatasets_geoda.nyc_education.md
  # (formula_pub, source arxiv.org/pdf/2212.05814, corrige le 2026-07-04):
  # une version anterieure de ce registre utilisait Y=YOUTH_DROP avec un jeu
  # de predicteurs different, ne correspondant pas a la formule publiee/verifiee.
  nyc_education = list(
    rds = "data/final_datasets/sf/Python_geodatasets_geoda.nyc_education.rds",
    y = "mean_inc",
    x = c("sub18", "PER_PRV_SC", "YOUTH_DROP", "HS_DROP", "COL_DEGREE", "SCHOOL_CT"),
    coords_from_geometry = TRUE, raw_crs = 4326, target_crs = 32618,
    drop_cols = c("geom_origine"),
    # Pool 90 % ~= 1994 obs. On garde ce premier run modeste: assez de folds
    # pour valider workflow/tune_grid, sans lancer un benchmark trop long.
    near_n_reps = 3L, near_test_size = 60L
  )
)

#' @param keep_geometry Si TRUE (2026-07-04), retourne une liste
#'   list(df=..., geometry=...) au lieu du data.frame seul: `geometry` est la
#'   colonne `geom_origine` de l'objet source (geometrie surfacique
#'   d'origine -- comtes pour georgia, census tracts pour nyc_education,
#'   points pour ewhp/lasrosas), filtree avec le meme masque complete.cases
#'   que `df`, donc alignee ligne a ligne. Sert aux cartes de coefficients
#'   locaux (voir plot_local_coefficient_maps() dans spatial_viz.R), qui ont
#'   besoin d'une vraie geometrie pour les choropleths -- coord_x/coord_y
#'   seuls (utilises pour le fit) ne donnent que des points.
prep_dataset <- function(spec, keep_geometry = FALSE) {
  # Charge l'objet sf final, retire la geometrie pour obtenir une table de
  # modelisation, puis reconstruit deux colonnes metriques coord_x/coord_y.
  obj <- readRDS(file.path(REPO_ROOT, spec$rds))
  df <- sf::st_drop_geometry(obj)
  for (col in spec$drop_cols) {
    if (col %in% names(df)) df[[col]] <- NULL
  }

  if (isTRUE(spec$coords_from_geometry)) {
    # Cas NYC: la geometrie sf porte le CRS fiable; on la reprojette avant
    # d'extraire les coordonnees numeriques.
    if (!inherits(obj, "sf")) {
      stop("`coords_from_geometry = TRUE` requires an sf object.", call. = FALSE)
    }
    proj <- sf::st_transform(obj, spec$target_crs)
    xy <- sf::st_coordinates(proj)
  } else if (spec$raw_crs != spec$target_crs) {
    # Cas general: les coordonnees sont des colonnes a convertir en CRS
    # metrique pour les distances, matrices W et bandwidths.
    pts <- sf::st_as_sf(df, coords = spec$coords_raw, crs = spec$raw_crs, remove = FALSE)
    proj <- sf::st_transform(pts, spec$target_crs)
    xy <- sf::st_coordinates(proj)
  } else {
    # Cas deja projete: on reutilise directement les coordonnees source.
    xy <- as.matrix(df[, spec$coords_raw])
  }
  df$coord_x <- xy[, 1]
  df$coord_y <- xy[, 2]

  keep <- c(spec$y, spec$x, "coord_x", "coord_y")
  cc <- stats::complete.cases(df[, keep])
  df <- df[cc, keep]

  if (isTRUE(keep_geometry)) {
    geom_col <- if ("geom_origine" %in% names(obj)) obj[["geom_origine"]] else sf::st_geometry(obj)
    return(list(df = df, geometry = geom_col[cc]))
  }
  df
}

# ---------------------------------------------------------------------------
# Specifications des modeles
# ---------------------------------------------------------------------------
build_specs <- function(y, x, coords = c("coord_x", "coord_y"),
                         spboost_mstop = 200, mgwrsar_bandwidth = 20, mgwrsar_kernel = "bisq") {
  # Chaque entree contient:
  # - spec: la specification parsnip du modele;
  # - formula: la formule transmise au workflow ou au fit direct.
  # Pour les modeles spatiaux custom, la formule inclut coord_x/coord_y afin
  # que workflows conserve ces colonnes. Les wrappers les retirent ensuite de
  # la formule backend: elles servent aux distances/W, pas comme covariables.
  list(
    # OLS simple: parsnip::linear_reg(engine="glm") EST l'OLS simple (famille
    # gaussienne par defaut, lien identite, aucun terme spatial) -- pas de
    # doublon a ajouter, seulement documente ici pour clarifier (2026-07-04)
    # que ce baseline "OLS simple" demande par l'utilisateur est deja couvert.
    glm = list(
      spec = parsnip::linear_reg(mode = "regression") |> parsnip::set_engine("glm"),
      formula = build_estimator_formula(y, x)
    ),
    # ML non-spatial pour baseline (2026-07-04, demande utilisateur): arbres
    # boostes sur les seules covariables X, sans coord_x/coord_y -- si on
    # voulait un XGBoost "conscient" de l'espace comme le baseline "XGBoost_xy"
    # de spbbost_article.pdf (coordonnees en covariables brutes), il
    # suffirait d'ajouter coords a la formule; on garde volontairement la
    # version non-augmentee ici, la plus stricte comme reference "aucune info
    # spatiale".
    xgboost = list(
      spec = parsnip::boost_tree(mode = "regression") |> parsnip::set_engine("xgboost"),
      formula = build_estimator_formula(y, x)
    ),
    gam_spatial = list(
      spec = parsnip::gen_additive_mod(mode = "regression") |> parsnip::set_engine("mgcv"),
      formula = build_gam_spatial_formula(y, x, coords),
      # Exception volontaire: workflow() prepare mal le terme mgcv::s() dans
      # notre usage formule. On garde donc parsnip::fit() direct pour ce GAM.
      use_workflow = FALSE
    ),
    spboost = list(
      spec = spboost_reg(coords = coords, DGP = "SAR", mstop = spboost_mstop, nu = 0.1, k_neighbors = 8) |>
        parsnip::set_engine("spboost") |> parsnip::set_mode("regression"),
      formula = build_estimator_formula(y, c(x, coords))
    ),
    # GWR simple: model_type="GWR" EST le GWR simple (une seule bande
    # passante, tous les coefficients varient spatialement) -- pas de doublon
    # a ajouter, documente ici pour la meme raison que "glm" ci-dessus.
    mgwrsar = list(
      spec = mgwrsar_reg(coords = coords, model_type = "GWR", kernels = mgwrsar_kernel, bandwidth = mgwrsar_bandwidth) |>
        parsnip::set_engine("mgwrsar") |> parsnip::set_mode("regression"),
      formula = build_estimator_formula(y, c(x, coords))
    ),
    # SAR simple pour baseline (2026-07-04, demande utilisateur): lambda
    # constant, beta constant -- aucune variation spatiale des coefficients,
    # a l'oppose de GWR/MGWR. mgwrsar::MGWRSAR(Model="SAR") ne construit pas
    # W elle-meme: mgwrsar_fit_impl() en batit une par kNN (k=8, voir
    # mgwrsar_build_knn_W() dans parsnip_mgwrsar.R). Pas de bandwidth/kernel
    # a tuner ici (Model="SAR" ignore H/kernels pour le calcul).
    mgwrsar_sar = list(
      spec = mgwrsar_reg(coords = coords, model_type = "SAR") |>
        parsnip::set_engine("mgwrsar") |> parsnip::set_mode("regression"),
      formula = build_estimator_formula(y, c(x, coords))
    ),
    # Vrai MGWR multiscale (2026-07-04): contrairement a "mgwrsar" ci-dessus
    # (Model="GWR", une seule bande passante pour toutes les covariables),
    # celui-ci utilise mgwrsar::TDS_MGWR() (algorithme du papier top-down
    # scale de Geniaux) qui trouve une bande passante DIFFERENTE par
    # covariable via backfitting. Pas de bandwidth/kernel a tuner ici --
    # l'algorithme est auto-suffisant, voir mgwrsar_fit_impl().
    mgwrsar_multiscale = list(
      spec = mgwrsar_reg(coords = coords, model_type = "tds_mgwr", kernels = "gauss") |>
        parsnip::set_engine("mgwrsar") |> parsnip::set_mode("regression"),
      formula = build_estimator_formula(y, c(x, coords))
    )
  )
}

# ---------------------------------------------------------------------------
# Grilles d'hyperparametres
# ---------------------------------------------------------------------------
# Premiere passe volontairement compacte. Les folds near-prediction servent
# encore au tuning et a l'evaluation finale; ce n'est pas encore une CV imbriquee.
TUNING_GRIDS <- list(
  mstop = c(50L, 100L, 200L, 300L, 400L),
  bandwidth = c(10, 20, 30, 40),
  kernels = c("bisq", "gauss")
)

# ---------------------------------------------------------------------------
# Ajuster et scorer une paire (estimateur, split)
# ---------------------------------------------------------------------------
score_split <- function(model_entry, split, y) {
  # Prend un split rsample, ajuste le modele sur analysis(split), predit sur
  # assessment(split), puis retourne RMSE/MAE dans un format CSV simple.
  train <- rsample::analysis(split)
  test <- rsample::assessment(split)
  if (isFALSE(model_entry$use_workflow)) {
    fit_obj <- tryCatch(
      parsnip::fit(model_entry$spec, model_entry$formula, data = train),
      error = function(e) e
    )
  } else {
    wf <- make_formula_workflow(model_entry$spec, model_entry$formula)
    fit_obj <- tryCatch(
      workflows::fit(wf, data = train),
      error = function(e) e
    )
  }
  if (inherits(fit_obj, "error")) {
    return(data.frame(rmse = NA_real_, mae = NA_real_, n_test = nrow(test), error = conditionMessage(fit_obj)))
  }
  preds <- tryCatch(predict(fit_obj, new_data = test)$.pred, error = function(e) e)
  if (inherits(preds, "error") || anyNA(preds)) {
    return(data.frame(rmse = NA_real_, mae = NA_real_, n_test = nrow(test),
                       error = if (inherits(preds, "error")) conditionMessage(preds) else "NA predictions"))
  }
  truth <- test[[y]]
  data.frame(
    rmse = sqrt(mean((preds - truth)^2)),
    mae = mean(abs(preds - truth)),
    n_test = nrow(test), error = NA_character_
  )
}

# ---------------------------------------------------------------------------
# Lancer un dataset complet
# ---------------------------------------------------------------------------
run_dataset <- function(name, spec, v_block = 5, seed = 1) {
  # Etapes:
  # 1. preparation des donnees;
  # 2. holdout pur de 10 %;
  # 3. folds near-prediction + folds block spatial;
  # 4. tuning des hyperparametres spatiaux sur near-prediction;
  # 5. evaluation finale des quatre estimateurs.
  cat(sprintf("\n########## %s ##########\n", name))
  df <- prep_dataset(spec)
  cat(sprintf("n = %d (after complete.cases)\n", nrow(df)))

  set.seed(seed)
  n <- nrow(df)
  holdout_idx <- sample(seq_len(n), max(1L, round(0.10 * n)))
  pool_idx <- setdiff(seq_len(n), holdout_idx)
  holdout_split <- rsample::make_splits(list(analysis = pool_idx, assessment = holdout_idx), data = df)

  pool <- df[pool_idx, ]
  near <- near_prediction_rset(pool, coords = c("coord_x", "coord_y"),
                                n_reps = spec$near_n_reps,
                                test_size = spec$near_test_size, seed = seed)
  block <- spatial_block_rset(pool, coords = c("coord_x", "coord_y"),
                               crs = spec$target_crs, v = v_block, seed = seed)

  formula_full <- build_estimator_formula(spec$y, spec$x)
  # Formule speciale pour les modeles spatiaux custom: on y ajoute les
  # coordonnees pour que workflows ne les supprime pas avant le fit.
  spatial_formula_full <- build_estimator_formula(spec$y, c(spec$x, "coord_x", "coord_y"))

  cat("  -- tuning spboost mstop (near-prediction grid search)...\n")
  tuned_spboost <- tune_spboost_mstop(
    TUNING_GRIDS$mstop, coords = c("coord_x", "coord_y"),
    formula = spatial_formula_full, y = spec$y, rset = near
  )
  cat(sprintf("     best mstop = %d (mean near-prediction RMSE = %.3f, regime = %s)\n",
              tuned_spboost$best$mstop, tuned_spboost$best$rmse, tuned_spboost$best$regime))
  n_trap <- sum(tuned_spboost$grid$regime == "D_trap")
  if (n_trap > 0) {
    cat(sprintf("     [geoadditive-trap check] %d/%d mstop candidate(s) flagged D_trap (excluded from selection):\n",
                n_trap, nrow(tuned_spboost$grid)))
    trap_rows <- tuned_spboost$grid[tuned_spboost$grid$regime == "D_trap", ]
    for (i in seq_len(nrow(trap_rows))) {
      cat(sprintf("       mstop=%d: d_rho=%.3f, moran_drop_ratio=%.3f, rmse=%.3f\n",
                  trap_rows$mstop[i], trap_rows$d_rho[i], trap_rows$moran_drop_ratio[i], trap_rows$rmse[i]))
    }
  }

  cat("  -- tuning mgwrsar bandwidth/kernel (near-prediction grid search)...\n")
  tuned_mgwrsar <- tune_mgwrsar_bandwidth(
    TUNING_GRIDS$bandwidth, TUNING_GRIDS$kernels, coords = c("coord_x", "coord_y"),
    formula = spatial_formula_full, y = spec$y, rset = near
  )
  cat(sprintf("     best H = %.3g, kernel = %s (mean near-prediction RMSE = %.3f)\n",
              tuned_mgwrsar$best$bandwidth, tuned_mgwrsar$best$kernels, tuned_mgwrsar$best$rmse))

  tuning_dir <- file.path(REPO_ROOT, "data/manifests/runs")
  dir.create(tuning_dir, showWarnings = FALSE, recursive = TRUE)
  # On ecrit les resultats de tuning separement du benchmark final pour garder
  # la trace de la grille testee et du candidat retenu.
  write.csv(cbind(dataset = name, tuned_spboost$grid),
            file.path(tuning_dir, sprintf("hyperparam_tuning_%s_spboost_mstop_2026-07.csv", name)),
            row.names = FALSE)
  write.csv(cbind(dataset = name, tuned_mgwrsar$grid),
            file.path(tuning_dir, sprintf("hyperparam_tuning_%s_mgwrsar_H_kernel_2026-07.csv", name)),
            row.names = FALSE)

  specs <- build_specs(spec$y, spec$x,
                        spboost_mstop = tuned_spboost$best$mstop,
                        mgwrsar_bandwidth = tuned_mgwrsar$best$bandwidth,
                        mgwrsar_kernel = tuned_mgwrsar$best$kernels)
  rows <- list()

  for (est_name in names(specs)) {
    cat(sprintf("  -- %s : holdout ", est_name))
    r <- score_split(specs[[est_name]], holdout_split, spec$y)
    cat(sprintf("RMSE=%.3f MAE=%.3f%s\n", r$rmse, r$mae, if (!is.na(r$error)) paste0(" [", r$error, "]") else ""))
    rows[[length(rows) + 1]] <- cbind(dataset = name, estimator = est_name, cv_scheme = "holdout_10pct", fold = "holdout", r)

    for (cv_name in c("near_prediction", "block_spatial")) {
      rset <- if (cv_name == "near_prediction") near else block
      cat(sprintf("  -- %s : %s (%d folds)\n", est_name, cv_name, nrow(rset)))
      for (i in seq_len(nrow(rset))) {
        r <- score_split(specs[[est_name]], rset$splits[[i]], spec$y)
        rows[[length(rows) + 1]] <- cbind(dataset = name, estimator = est_name, cv_scheme = cv_name,
                                           fold = rset$id[[i]], r)
      }
    }
  }

  do.call(rbind, rows)
}

run_manual_test <- function(which = c("georgia")) {
  # Point d'entree que tu peux appeler dans la console R.
  # Attention: benchmark_manual_test_2026-07.csv est reecrit a chaque appel
  # avec uniquement les datasets passes dans `which`.
  results <- lapply(which, function(nm) run_dataset(nm, DATASETS[[nm]]))
  out <- do.call(rbind, results)
  out_path <- file.path(REPO_ROOT, "data/manifests/runs/benchmark_manual_test_2026-07.csv")
  dir.create(dirname(out_path), showWarnings = FALSE, recursive = TRUE)
  write.csv(out, out_path, row.names = FALSE)
  cat("\nWrote", out_path, "\n")

  cat("\n=== Summary (mean RMSE/MAE by dataset x estimator x cv_scheme) ===\n")
  agg <- stats::aggregate(cbind(rmse, mae) ~ dataset + estimator + cv_scheme, data = out, FUN = mean, na.action = na.omit)
  print(agg[order(agg$dataset, agg$estimator, agg$cv_scheme), ])
  out
}

if (sys.nframe() == 0) {
  run_manual_test()
}
