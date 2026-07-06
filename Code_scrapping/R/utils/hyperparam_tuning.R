# Tuning d'hyperparametres via workflows::workflow() + tune::tune_grid().
#
# Principe: les folds de validation spatiale restent construits hors des
# wrappers d'estimateurs. On passe ensuite ces folds a tidymodels pour scorer
# chaque candidat par RMSE/MAE.
#
# Note importante 2026-07-03:
# les fonctions natives de spboost et mgwrsar ne permettent pas d'injecter nos
# folds near-prediction. On tente donc d'abord la route tidymodels standard
# tune_grid(). Si elle echoue avec les moteurs parsnip custom, on bascule vers
# un fallback robuste: workflow statique + fit_resamples() candidat par candidat.

source("R/utils/estimator_common.R")

# Fabrique l'objet tidymodels standard "formule + modele".
make_formula_workflow <- function(spec, formula) {
  require_package("workflows", "tidymodels workflow construction")
  workflows::workflow() |>
    workflows::add_formula(formula) |>
    workflows::add_model(spec)
}

# Reduit l'objet riche retourne par tune_grid() en table plate exploitable dans
# les CSV du projet: hyperparametres, RMSE, MAE et nombre de folds valides.
collect_tune_grid_metrics <- function(tune_result, grid_cols) {
  metrics <- tune::collect_metrics(tune_result)
  if (nrow(metrics) == 0) {
    stop("tune_grid() returned no metrics; inspect tune::show_notes(result).", call. = FALSE)
  }

  one_metric <- function(metric_name, value_name) {
    rows <- metrics[metrics$.metric == metric_name, c(grid_cols, "mean", "n"), drop = FALSE]
    names(rows)[names(rows) == "mean"] <- value_name
    names(rows)[names(rows) == "n"] <- paste0("n_", metric_name)
    rows
  }

  rmse <- one_metric("rmse", "rmse")
  mae <- one_metric("mae", "mae")
  out <- merge(rmse, mae, by = grid_cols, all = TRUE)
  out$n_ok <- out$n_rmse
  out[order(out$rmse), , drop = FALSE]
}

# Solution de repli pour les modeles custom qui savent fitter/predire via workflow(),
# mais que tune_grid() n'arrive pas a finaliser. Chaque ligne de grille devient
# une specification statique, evaluee avec fit_resamples().
fit_static_grid_resamples <- function(spec_builder, grid, rset, formula, grid_cols) {
  metrics <- yardstick::metric_set(yardstick::rmse, yardstick::mae)
  rows <- lapply(seq_len(nrow(grid)), function(i) {
    candidate <- grid[i, , drop = FALSE]

    # Tout le bloc fit+collecte est dans UN SEUL tryCatch (2026-07-04). Avant
    # ce correctif, seul fit_resamples() etait protege: si tous les folds
    # d'un candidat echouaient au fit (ex: matrice singuliere pour certaines
    # combinaisons de predicteurs/tailles de fold, observe sur ewhp), l'objet
    # retourne par fit_resamples() restait "valide" mais sans metrique, et
    # tune::collect_metrics() levait alors une erreur "All models failed" non
    # rattrapee, qui arretait tout le pipeline au lieu de juste ce candidat.
    out <- tryCatch({
      spec <- spec_builder(candidate)
      wf <- make_formula_workflow(spec, formula)
      res <- tune::fit_resamples(
        wf,
        resamples = rset,
        metrics = metrics,
        control = tune::control_resamples(save_pred = FALSE, verbose = FALSE)
      )
      collected <- tune::collect_metrics(res)
      metric_value <- function(metric_name) {
        value <- collected[collected$.metric == metric_name, , drop = FALSE]
        if (nrow(value) == 0) return(data.frame(mean = NA_real_, n = 0L))
        data.frame(mean = value$mean[[1]], n = value$n[[1]])
      }
      rmse <- metric_value("rmse")
      mae <- metric_value("mae")
      row <- candidate
      row$rmse <- rmse$mean
      row$n_rmse <- rmse$n
      row$mae <- mae$mean
      row$n_mae <- mae$n
      row$n_ok <- rmse$n
      row$error <- NA_character_
      row
    }, error = function(e) {
      # On conserve les candidats echoues dans la table de sortie pour pouvoir
      # diagnostiquer la grille sans relancer le pipeline.
      row <- candidate
      row$rmse <- NA_real_
      row$n_rmse <- 0L
      row$mae <- NA_real_
      row$n_mae <- 0L
      row$n_ok <- 0L
      row$error <- conditionMessage(e)
      row
    })
    out
  })
  out <- do.call(rbind, rows)
  out[order(out$rmse), , drop = FALSE]
}

# Moran I simplifie sur une matrice de poids row-standardized.
# Garde cette fonction disponible pour remettre plus tard le diagnostic du
# "geoadditive trap" dans SpBoost.
moran_i <- function(residuals, W) {
  e <- residuals - mean(residuals)
  n <- length(e)
  s0 <- sum(W)
  num <- as.numeric(t(e) %*% (W %*% e))
  den <- as.numeric(t(e) %*% e)
  if (!is.finite(den) || den <= 0 || !is.finite(s0) || s0 <= 0) return(NA_real_)
  (n / s0) * (num / den)
}

# Tune mstop pour SpBoost.
# Pour cette premiere passe, nu et k_neighbors restent fixes afin de limiter la
# taille de la grille et le temps de calcul.
tune_spboost_mstop <- function(mstop_grid, coords, formula, y, rset,
                                DGP = "SAR", nu = 0.1, k_neighbors = 8,
                                rho_drop_threshold = 0.01, moran_drop_ratio_threshold = 0.30) {
  grid <- data.frame(mstop = as.integer(sort(unique(mstop_grid))))

  # Version statique utilisee par le fallback: aucun tune() dans cette spec.
  spec_builder <- function(candidate) {
    spboost_reg(
      coords = coords, DGP = DGP,
      mstop = as.integer(candidate$mstop), nu = nu, k_neighbors = k_neighbors
    ) |>
      parsnip::set_engine("spboost") |>
      parsnip::set_mode("regression")
  }

  # Version tunable utilisee par tune_grid().
  tuned_spec <- spboost_reg(coords = coords, DGP = DGP, mstop = tune::tune(), nu = nu, k_neighbors = k_neighbors) |>
    parsnip::set_engine("spboost") |>
    parsnip::set_mode("regression")
  wf <- make_formula_workflow(tuned_spec, formula)
  metrics <- yardstick::metric_set(yardstick::rmse, yardstick::mae)

  tuned <- tryCatch(
    tune::tune_grid(
      wf,
      resamples = rset,
      grid = grid,
      metrics = metrics,
      control = tune::control_grid(save_pred = FALSE, verbose = FALSE)
    ),
    error = function(e) e
  )

  used_fallback <- inherits(tuned, "error")
  grid_out <- if (used_fallback) {
    tuned
  } else {
    tryCatch(collect_tune_grid_metrics(tuned, "mstop"), error = function(e) e)
  }

  used_fallback <- used_fallback || inherits(grid_out, "error")
  if (used_fallback) {
    grid_out <- fit_static_grid_resamples(spec_builder, grid, rset, formula, "mstop")
    grid_out$tuning_method <- "static_workflow_resamples"
    tune_result <- NULL
  } else {
    grid_out$tuning_method <- "tune_grid"
    tune_result <- tuned
  }

  ok <- grid_out$n_ok > 0
  if (!any(ok)) stop("tune_spboost_mstop(): every mstop candidate failed on every fold.")
  grid_out <- grid_out[ok, , drop = FALSE]

  # Colonnes reservees au diagnostic spatial avance. Elles restent presentes
  # dans le schema CSV, meme si elles ne sont pas encore calculees ici.
  grid_out$rho_hat <- NA_real_
  grid_out$moran_i <- NA_real_
  grid_out$d_rho <- NA_real_
  grid_out$moran_drop_ratio <- NA_real_
  grid_out$regime <- ifelse(
    grid_out$tuning_method == "tune_grid",
    "tune_grid_rmse",
    "static_workflow_rmse"
  )

  best <- grid_out[which.min(grid_out$rmse), , drop = FALSE]
  list(grid = grid_out, best = best, tune_result = tune_result)
}

# Tune H/bandwidth et kernel pour MGWRSAR/GWR.
# Le bandwidth est numerique et peut etre tune; le kernel est boucle
# explicitement car les arguments caractere custom sont moins robustes dans
# tune_grid().
tune_mgwrsar_bandwidth <- function(bandwidth_grid, kernels_grid, coords, formula, y, rset,
                                    model_type = "GWR") {
  metrics <- yardstick::metric_set(yardstick::rmse, yardstick::mae)

  results <- lapply(as.character(kernels_grid), function(kernel) {
    grid <- data.frame(bandwidth = as.numeric(bandwidth_grid))

    spec_builder <- function(candidate) {
      mgwrsar_reg(
        coords = coords, model_type = model_type,
        kernels = kernel, bandwidth = as.numeric(candidate$bandwidth)
      ) |>
        parsnip::set_engine("mgwrsar") |>
        parsnip::set_mode("regression")
    }

    tuned_spec <- mgwrsar_reg(
      coords = coords, model_type = model_type,
      kernels = kernel, bandwidth = tune::tune()
    ) |>
      parsnip::set_engine("mgwrsar") |>
      parsnip::set_mode("regression")
    wf <- make_formula_workflow(tuned_spec, formula)

    tuned <- tryCatch(
      tune::tune_grid(
        wf,
        resamples = rset,
        grid = grid,
        metrics = metrics,
        control = tune::control_grid(save_pred = FALSE, verbose = FALSE)
      ),
      error = function(e) e
    )

    used_fallback <- inherits(tuned, "error")
    grid_out <- if (used_fallback) {
      tuned
    } else {
      tryCatch(collect_tune_grid_metrics(tuned, "bandwidth"), error = function(e) e)
    }

    used_fallback <- used_fallback || inherits(grid_out, "error")
    if (used_fallback) {
      grid_out <- fit_static_grid_resamples(spec_builder, grid, rset, formula, "bandwidth")
      grid_out$tuning_method <- "static_workflow_resamples"
      tune_result <- NULL
    } else {
      grid_out$tuning_method <- "tune_grid"
      tune_result <- tuned
    }
    grid_out$kernels <- kernel
    list(grid = grid_out, tune_result = tune_result)
  })

  grid_out <- do.call(rbind, lapply(results, `[[`, "grid"))
  grid_out <- grid_out[order(grid_out$rmse), , drop = FALSE]
  ok <- grid_out$n_ok > 0
  if (!any(ok)) stop("tune_mgwrsar_bandwidth(): every candidate failed on every fold.")
  grid_out <- grid_out[ok, , drop = FALSE]
  best <- grid_out[which.min(grid_out$rmse), , drop = FALSE]
  list(grid = grid_out, best = best, tune_result = lapply(results, `[[`, "tune_result"))
}
