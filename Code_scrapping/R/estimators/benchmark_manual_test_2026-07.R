# Test manuel de benchmark (2026-07).
#
# Objectif: comparer GLM, GAM spatial, SpBoost et les variantes du moteur
# MGWRSAR sur des datasets
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
source("R/utils/spatial_weights.R")
source("R/estimators/parsnip_spboost.R")
source("R/estimators/parsnip_mgwrsar.R")
source("R/estimators/spatial_model_specs.R")
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
# Estimateurs spatiaux hors parsnip
# ---------------------------------------------------------------------------
score_predictions <- function(preds, truth, n_test, error = NA_character_) {
  # Normalise la sortie des estimateurs qui ne passent pas par workflow().
  if (inherits(preds, "error") || anyNA(preds)) {
    msg <- if (inherits(preds, "error")) conditionMessage(preds) else "NA predictions"
    return(data.frame(rmse = NA_real_, mae = NA_real_, n_test = n_test, error = msg))
  }
  data.frame(
    rmse = sqrt(mean((preds - truth)^2)),
    mae = mean(abs(preds - truth)),
    n_test = n_test,
    error = error
  )
}

predict_spatialreg_trend <- function(fit_obj, train, test, x, coords, k_neighbors = 8) {
  # Repli hors-echantillon quand predict.Sarlm refuse le listw du split.
  # On reconstruit la partie lineaire: beta*X et, pour SDM, beta_lag*W*X.
  all_data <- rbind(train, test)
  coef_vec <- stats::coef(fit_obj)
  X <- stats::model.matrix(stats::reformulate(x), data = all_data)
  design <- X

  lag_coef_names <- grep("^lag\\.", names(coef_vec), value = TRUE)
  if (length(lag_coef_names) > 0) {
    W_all <- as.matrix(build_knn_W(all_data[, coords, drop = FALSE], k = k_neighbors, sparse = FALSE))
    X_no_intercept <- X[, setdiff(colnames(X), "(Intercept)"), drop = FALSE]
    lag_X <- W_all %*% X_no_intercept
    colnames(lag_X) <- paste0("lag.", colnames(X_no_intercept))
    design <- cbind(design, lag_X)
  }

  keep <- intersect(colnames(design), names(coef_vec))
  if (length(keep) == 0) {
    stop("spatialreg: aucun coefficient compatible avec le design de prediction.", call. = FALSE)
  }
  pred_all <- as.numeric(design[, keep, drop = FALSE] %*% coef_vec[keep])
  tail(pred_all, nrow(test))
}

score_spatialreg_split <- function(split, y, x, coords, model_type, k_neighbors = 8) {
  # Ajuste les modeles econometriques spatiaux classiques de spatialreg.
  # W est reconstruit sur les observations d'entrainement pour l'estimation,
  # puis sur train+test pour fournir le voisinage necessaire a predict().
  require_package("spatialreg", "modeles SAR/SEM/SDM")
  train <- rsample::analysis(split)
  test <- rsample::assessment(split)
  model_formula <- build_estimator_formula(y, x)

  fit_obj <- tryCatch({
    listw_train <- build_knn_listw(as.matrix(train[, coords, drop = FALSE]), k = k_neighbors)
    if (model_type == "SAR") {
      spatialreg::lagsarlm(model_formula, data = train, listw = listw_train, zero.policy = TRUE)
    } else if (model_type == "SEM") {
      spatialreg::errorsarlm(model_formula, data = train, listw = listw_train, zero.policy = TRUE)
    } else if (model_type == "SDM") {
      spatialreg::lagsarlm(model_formula, data = train, listw = listw_train, type = "mixed", zero.policy = TRUE)
    } else {
      stop(sprintf("Type spatialreg inconnu: %s", model_type), call. = FALSE)
    }
  }, error = function(e) e)

  if (inherits(fit_obj, "error")) {
    return(data.frame(rmse = NA_real_, mae = NA_real_, n_test = nrow(test), error = conditionMessage(fit_obj)))
  }

  preds <- tryCatch({
    all_data <- rbind(train, test)
    row.names(all_data) <- as.character(seq_len(nrow(all_data)))
    coords_all <- all_data[, coords, drop = FALSE]
    listw_all <- build_knn_listw(as.matrix(coords_all), k = k_neighbors)
    pred_all <- suppressWarnings(stats::predict(
      fit_obj,
      newdata = all_data,
      listw = listw_all,
      pred.type = "TS",
      all.data = TRUE,
      zero.policy = TRUE
    ))
    tail(as.numeric(pred_all), nrow(test))
  }, error = function(e) {
    # Certains objets spatialreg acceptent une prediction tendance seule sans
    # listw. On garde ce repli pour ne pas bloquer tout le benchmark.
    tryCatch(predict_spatialreg_trend(fit_obj, train, test, x, coords, k_neighbors), error = function(e2) e2)
  })

  score_predictions(preds, test[[y]], nrow(test))
}

spmoran_subset_meig <- function(meig, rows) {
  # Cree un objet meig restreint aux lignes d'entrainement. Les vecteurs
  # propres sont calcules sur train+test pour pouvoir projeter les points test,
  # mais l'ajustement ne voit que y_train.
  out <- meig
  n_all <- if (is.null(meig$sf)) NA_integer_ else nrow(meig$sf)
  if (!is.null(out$sf)) out$sf <- out$sf[rows, , drop = FALSE]
  if (!is.null(out$sf_z)) out$sf_z <- out$sf_z[rows, , drop = FALSE]
  if (!is.null(out$other$coords)) out$other$coords <- out$other$coords[rows, , drop = FALSE]
  if (!is.null(out$other$Cmean) && length(out$other$Cmean) == n_all) {
    out$other$Cmean <- out$other$Cmean[rows]
  }
  out
}

score_spmoran_split <- function(split, y, x, coords, random_effect = FALSE,
                                enum = 200L, fast_threshold = 2500L) {
  # ESF/RE-ESF utilisent les vecteurs propres de Moran comme variables
  # spatiales latentes. meigen_f est reserve aux grands jeux de donnees.
  require_package("spmoran", "modeles ESF et RE-ESF")
  train <- rsample::analysis(split)
  test <- rsample::assessment(split)
  n_train <- nrow(train)
  coords_all <- as.matrix(rbind(train[, coords, drop = FALSE], test[, coords, drop = FALSE]))
  x_train <- as.matrix(train[, x, drop = FALSE])
  x_test <- as.matrix(test[, x, drop = FALSE])

  fit_obj <- tryCatch({
    meig_all <- if (nrow(coords_all) >= fast_threshold) {
      spmoran::meigen_f(coords = coords_all, enum = enum)
    } else {
      spmoran::meigen(coords = coords_all)
    }
    meig_train <- spmoran_subset_meig(meig_all, seq_len(n_train))
    if (isTRUE(random_effect)) {
      list(model = spmoran::resf(y = train[[y]], x = x_train, meig = meig_train), meig = meig_all)
    } else {
      list(model = spmoran::esf(y = train[[y]], x = x_train, meig = meig_train, vif = 10), meig = meig_all)
    }
  }, error = function(e) e)

  if (inherits(fit_obj, "error")) {
    return(data.frame(rmse = NA_real_, mae = NA_real_, n_test = nrow(test), error = conditionMessage(fit_obj)))
  }

  preds <- tryCatch({
    fit <- fit_obj$model
    meig_all <- fit_obj$meig
    test_rows <- seq.int(n_train + 1L, n_train + nrow(test))
    beta <- as.data.frame(fit$b)$Estimate
    names(beta) <- rownames(as.data.frame(fit$b))
    X_test <- cbind("(Intercept)" = 1, x_test)
    common <- intersect(colnames(X_test), names(beta))
    if (length(common) == 0) stop("spmoran: aucun coefficient beta utilisable.", call. = FALSE)
    pred <- as.numeric(X_test[, common, drop = FALSE] %*% beta[common])

    if (isTRUE(random_effect)) {
      r_coef <- as.numeric(fit$r)
      n_filter <- min(length(r_coef), ncol(meig_all$sf))
      if (n_filter > 0) {
        pred <- pred + as.numeric(meig_all$sf[test_rows, seq_len(n_filter), drop = FALSE] %*% r_coef[seq_len(n_filter)])
      }
    } else if (!is.null(fit$r) && nrow(as.data.frame(fit$r)) > 0) {
      r_df <- as.data.frame(fit$r)
      idx <- suppressWarnings(as.integer(sub("^sf", "", rownames(r_df))))
      ok <- is.finite(idx) & idx >= 1L & idx <= ncol(meig_all$sf)
      if (any(ok)) {
        pred <- pred + as.numeric(meig_all$sf[test_rows, idx[ok], drop = FALSE] %*% r_df$Estimate[ok])
      }
    }
    pred
  }, error = function(e) e)

  score_predictions(preds, test[[y]], nrow(test))
}

validate_estimators <- function(estimators, available) {
  # Valide la selection avant les etapes couteuses (construction des folds,
  # tuning, fit), pour qu'une faute de nom echoue immediatement.
  if (is.null(estimators)) return(NULL)
  # Compatibilite temporaire avec les anciens noms utilises dans les premiers
  # runs 2026-07. Les sorties nouvelles utilisent les noms explicites.
  aliases <- c(
    mgwrsar = "mgwrsar_gwr",
    mgwrsar_multiscale = "mgwrsar_mgwr",
    mgwrsar_autocorr = "mgwrsar_mgwrsar"
  )
  estimators <- unname(ifelse(estimators %in% names(aliases), aliases[estimators], estimators))
  missing <- setdiff(estimators, available)
  if (length(missing) > 0) {
    stop(sprintf(
      "Estimateur(s) inconnu(s): %s. Estimateurs disponibles: %s",
      paste(missing, collapse = ", "),
      paste(available, collapse = ", ")
    ), call. = FALSE)
  }
  estimators
}

# ---------------------------------------------------------------------------
# Grilles d'hyperparametres
# ---------------------------------------------------------------------------
# Premiere passe volontairement compacte. Les folds near-prediction servent
# encore au tuning et a l'evaluation finale; ce n'est pas encore une CV imbriquee.
TUNING_GRIDS <- list(
  mstop = c(50L, 100L, 200L, 300L, 400L, 600L, 800L, 1000L),
  # Pour GWR/MGWRSAR, H est traite ici comme une bande passante adaptative
  # exprimee en nombre de voisins. Le papier top-down scale rappelle que les
  # bandwidths peuvent correspondre a une distance ou a un nombre de voisins,
  # et recommande de confronter les echelles par validation croisee/AICc. On
  # elargit donc la grille au-dela du premier test 10-40 pour couvrir des
  # voisinages locaux, moyens et larges sans tuner W ni nu.
  bandwidth = c(10, 20, 30, 40, 60, 80, 100, 150, 200),
  kernels = c("bisq", "gauss")
)

# ---------------------------------------------------------------------------
# Ajuster et scorer une paire (estimateur, split)
# ---------------------------------------------------------------------------
score_split <- function(model_entry, split, y) {
  # Prend un split rsample, ajuste le modele sur analysis(split), predit sur
  # assessment(split), puis retourne RMSE/MAE dans un data.frame simple.
  if (!is.null(model_entry$score)) {
    return(model_entry$score(split, y))
  }
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
# Sauvegarder les lots train/test
# ---------------------------------------------------------------------------
resample_index_manifest <- function(dataset_name, holdout_split, near_rset, block_rset) {
  # On sauvegarde uniquement les identifiants de lignes, pas les donnees
  # completes. Cela rend les lots train/test auditables sans multiplier de
  # gros fichiers RDS ni dupliquer les tables pour chaque fold.
  split_rows <- function(split, cv_scheme, fold_id) {
    train_ids <- rsample::analysis(split)$.row_id
    test_ids <- rsample::assessment(split)$.row_id
    data.frame(
      dataset = dataset_name,
      cv_scheme = cv_scheme,
      fold = fold_id,
      role = c(rep("train", length(train_ids)), rep("test", length(test_ids))),
      row_id = c(train_ids, test_ids),
      stringsAsFactors = FALSE
    )
  }

  rows <- list(split_rows(holdout_split, "holdout_10pct", "holdout"))
  for (i in seq_len(nrow(near_rset))) {
    rows[[length(rows) + 1]] <- split_rows(near_rset$splits[[i]], "near_prediction", near_rset$id[[i]])
  }
  for (i in seq_len(nrow(block_rset))) {
    rows[[length(rows) + 1]] <- split_rows(block_rset$splits[[i]], "block_spatial", block_rset$id[[i]])
  }
  do.call(rbind, rows)
}

# ---------------------------------------------------------------------------
# Lancer un dataset complet
# ---------------------------------------------------------------------------
run_dataset <- function(name, spec, v_block = 5, seed = 1, estimators = NULL) {
  # Etapes:
  # 1. preparation des donnees;
  # 2. holdout pur de 10 %;
  # 3. folds near-prediction + folds block spatial;
  # 4. tuning des hyperparametres spatiaux sur near-prediction;
  # 5. evaluation finale des estimateurs declares dans build_specs().
  cat(sprintf("\n########## %s ##########\n", name))
  estimators <- validate_estimators(estimators, names(build_specs(spec$y, spec$x)))
  df <- prep_dataset(spec)
  # Identifiant stable dans le dataset prepare: il permet de sauvegarder les
  # lots train/test sous forme compacte et de retrouver les lignes utilisees.
  df$.row_id <- seq_len(nrow(df))
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

  runs_dir <- file.path(REPO_ROOT, "data/manifests/runs")
  dir.create(runs_dir, showWarnings = FALSE, recursive = TRUE)
  resamples_path <- file.path(runs_dir, sprintf("resamples_%s_2026-07.rds", name))
  saveRDS(resample_index_manifest(name, holdout_split, near, block), resamples_path)
  cat(sprintf("  -- resamples train/test sauvegardes: %s\n", resamples_path))

  formula_full <- build_estimator_formula(spec$y, spec$x)
  # Formule speciale pour les modeles spatiaux custom: on y ajoute les
  # coordonnees pour que workflows ne les supprime pas avant le fit.
  spatial_formula_full <- build_estimator_formula(spec$y, c(spec$x, "coord_x", "coord_y"))

  needs_spboost_tuning <- is.null(estimators) || "spboost" %in% estimators
  needs_mgwrsar_tuning <- is.null(estimators) || any(c("mgwrsar_gwr", "mgwrsar_mgwrsar") %in% estimators)
  tuned_spboost <- NULL
  tuned_mgwrsar <- NULL

  if (needs_spboost_tuning) {
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
  } else {
    cat("  -- tuning spboost mstop ignore (spboost non selectionne)\n")
  }

  if (needs_mgwrsar_tuning) {
    cat("  -- tuning mgwrsar_gwr bandwidth/kernel (near-prediction grid search)...\n")
    tuned_mgwrsar <- tune_mgwrsar_bandwidth(
      TUNING_GRIDS$bandwidth, TUNING_GRIDS$kernels, coords = c("coord_x", "coord_y"),
      formula = spatial_formula_full, y = spec$y, rset = near
    )
    cat(sprintf("     best H = %.3g, kernel = %s (mean near-prediction RMSE = %.3f)\n",
                tuned_mgwrsar$best$bandwidth, tuned_mgwrsar$best$kernels, tuned_mgwrsar$best$rmse))
  } else {
    cat("  -- tuning mgwrsar_gwr bandwidth/kernel ignore (mgwrsar_gwr/mgwrsar_mgwrsar non selectionnes)\n")
  }

  tuning_dir <- runs_dir
  # On ecrit les resultats de tuning separement du benchmark final pour garder
  # la trace de la grille testee et du candidat retenu. Les sorties sont des
  # objets R natifs pour eviter une serialisation texte et conserver les types R.
  if (!is.null(tuned_spboost)) {
    spboost_grid_out <- cbind(dataset = name, tuned_spboost$grid)
    spboost_base <- file.path(tuning_dir, sprintf("hyperparam_tuning_%s_spboost_mstop_2026-07", name))
    saveRDS(spboost_grid_out, paste0(spboost_base, ".rds"))
    saveRDS(tuned_spboost, paste0(spboost_base, "_full.rds"))
  }
  if (!is.null(tuned_mgwrsar)) {
    mgwrsar_grid_out <- cbind(dataset = name, tuned_mgwrsar$grid)
    mgwrsar_base <- file.path(tuning_dir, sprintf("hyperparam_tuning_%s_mgwrsar_gwr_H_kernel_2026-07", name))
    saveRDS(mgwrsar_grid_out, paste0(mgwrsar_base, ".rds"))
    saveRDS(tuned_mgwrsar, paste0(mgwrsar_base, "_full.rds"))
  }

  specs <- build_specs(spec$y, spec$x,
                        spboost_mstop = if (is.null(tuned_spboost)) 200 else tuned_spboost$best$mstop,
                        mgwrsar_bandwidth = if (is.null(tuned_mgwrsar)) 20 else tuned_mgwrsar$best$bandwidth,
                        mgwrsar_kernel = if (is.null(tuned_mgwrsar)) "bisq" else tuned_mgwrsar$best$kernels)
  if (!is.null(estimators)) {
    # Permet de lancer seulement un sous-ensemble du benchmark, utile pour
    # eviter les estimateurs lents pendant les tests interactifs.
    specs <- specs[estimators]
    cat(sprintf("  -- estimateurs selectionnes: %s\n", paste(names(specs), collapse = ", ")))
  }
  rows <- list()

  for (est_name in names(specs)) {
    cat(sprintf("  -- %s : holdout ", est_name))
    t0 <- proc.time()[["elapsed"]]
    r <- score_split(specs[[est_name]], holdout_split, spec$y)
    elapsed <- proc.time()[["elapsed"]] - t0
    cat(sprintf("RMSE=%.3f MAE=%.3f (%.1fs)%s\n", r$rmse, r$mae, elapsed,
                if (!is.na(r$error)) paste0(" [", r$error, "]") else ""))
    rows[[length(rows) + 1]] <- cbind(dataset = name, estimator = est_name, cv_scheme = "holdout_10pct", fold = "holdout", r)

    for (cv_name in c("near_prediction", "block_spatial")) {
      rset <- if (cv_name == "near_prediction") near else block
      cat(sprintf("  -- %s : %s (%d folds)\n", est_name, cv_name, nrow(rset)))
      for (i in seq_len(nrow(rset))) {
        fold_id <- rset$id[[i]]
        split <- rset$splits[[i]]
        n_train <- nrow(rsample::analysis(split))
        n_test <- nrow(rsample::assessment(split))
        cat(sprintf("     fold %s/%s: train=%d test=%d ... ",
                    i, nrow(rset), n_train, n_test))
        t0 <- proc.time()[["elapsed"]]
        r <- score_split(specs[[est_name]], split, spec$y)
        elapsed <- proc.time()[["elapsed"]] - t0
        cat(sprintf("RMSE=%.3f MAE=%.3f (%.1fs)%s\n", r$rmse, r$mae, elapsed,
                    if (!is.na(r$error)) paste0(" [", r$error, "]") else ""))
        rows[[length(rows) + 1]] <- cbind(dataset = name, estimator = est_name, cv_scheme = cv_name,
                                           fold = fold_id, r)
      }
    }
  }

  do.call(rbind, rows)
}

run_manual_test <- function(which = c("georgia"), estimators = NULL) {
  # Point d'entree que tu peux appeler dans la console R.
  # Attention: benchmark_manual_test_2026-07.rds est reecrit a chaque appel
  # avec uniquement les datasets passes dans `which`.
  results <- lapply(which, function(nm) run_dataset(nm, DATASETS[[nm]], estimators = estimators))
  out <- do.call(rbind, results)
  out_path <- file.path(REPO_ROOT, "data/manifests/runs/benchmark_manual_test_2026-07.rds")
  dir.create(dirname(out_path), showWarnings = FALSE, recursive = TRUE)
  saveRDS(out, out_path)
  cat("\nWrote", out_path, "\n")

  cat("\n=== Summary (mean RMSE/MAE by dataset x estimator x cv_scheme) ===\n")
  agg <- stats::aggregate(cbind(rmse, mae) ~ dataset + estimator + cv_scheme, data = out, FUN = mean, na.action = na.omit)
  print(agg[order(agg$dataset, agg$estimator, agg$cv_scheme), ])
  # Le resume agrege est aussi conserve comme objet R natif pour comparaison
  # rapide entre datasets, estimateurs et schemas de validation.
  summary_path <- sub("\\.rds$", "_summary.rds", out_path)
  saveRDS(agg[order(agg$dataset, agg$estimator, agg$cv_scheme), ], summary_path)
  cat("Wrote", summary_path, "\n")
  out
}

if (sys.nframe() == 0) {
  run_manual_test()
}
