# Visualisations pour le pipeline tidymodels spatial (2026-07-04).
#
# Objectif: reproduire les types de figures habituels des papiers d'econometrie
# spatiale consultes (spbbost_article.pdf, top-down-scale MGWR, MGWR-SAR
# Geniaux & Martinetti) a partir des objets R deja produits par
# benchmark_manual_test_2026-07.R et hyperparam_tuning.R -- aucune
# reexecution de modele n'est necessaire, ces fonctions ne font que lire et
# tracer des resultats existants.
#
# Deux types de figures pour l'instant:
# - courbe de calibration d'un hyperparametre (RMSE vs mstop/bandwidth),
#   comme la Fig. 5 du papier spboost;
# - barres RMSE/MAE comparatives par (estimateur x schema de CV), pour lire
#   d'un coup d'oeil le tableau recapitulatif de run_manual_test().
#
# Ajoute le 2026-07-04: cartes de coefficients locaux beta(u,v) (plot_local_
# coefficient_maps()), inspirees de la Fig. 7 de arxiv:2212.05814 (papier
# source de nyc_education). Contrairement a un premier essai qui utilisait
# coord_x/coord_y (donc des points meme pour georgia/nyc_education), la
# geometrie d'ORIGINE est en fait deja presente dans data/final_datasets/sf,
# dans la colonne `geom_origine` (masquee par defaut dans prep_dataset(),
# voir son parametre keep_geometry=): georgia et nyc_education la portent en
# MULTIPOLYGON (comtes / census tracts), confirmes contre le shapefile
# libpysal.examples("georgia") -- meme AreaKey, memes coordonnees UTM.
# ewhp/lasrosas restent en POINT car ce sont des observations individuelles
# (logements, parcelles) sans polygone d'origine. plot_local_coefficient_
# maps() detecte le type et bascule automatiquement entre choropleth et
# nuage de points colore.
#
# Hors scope pour l'instant (voir wiki/metadata/tidymodels_spatial_pipeline_status_2026-07.md):
# - diagnostic de perturbation de W selon le schema de CV (Fig. 2 du papier
#   spboost) -- demande de construire un diagnostic dedie, pas encore fait.

source("R/utils/estimator_common.R")

require_package("ggplot2", "visualisations du pipeline spatial")
require_package("patchwork", "cartes de coefficients locaux (echelles de couleur independantes par covariable)")

# ---------------------------------------------------------------------------
# Courbe de calibration d'un hyperparametre
# ---------------------------------------------------------------------------

#' Trace RMSE (ou MAE) en fonction d'un hyperparametre, a partir d'une grille
#' de tuning (le data.frame `grid` retourne par tune_spboost_mstop()/
#' tune_mgwrsar_bandwidth(), ou lu directement depuis un objet RDS
#' hyperparam_tuning_<dataset>_*.rds).
#'
#' @param tuning_grid data.frame avec au moins les colonnes `x` et `metric`.
#' @param x nom de la colonne hyperparametre (ex. "mstop", "bandwidth").
#' @param metric nom de la colonne metrique a tracer ("rmse" ou "mae").
#' @param color nom de colonne optionnel pour separer plusieurs courbes
#'   (ex. "kernels" pour mgwrsar, qui a une courbe par noyau).
#' @param title titre du graphique; genere automatiquement si NULL.
plot_tuning_curve <- function(tuning_grid, x, metric = "rmse", color = NULL, title = NULL) {
  stopifnot(is.data.frame(tuning_grid), x %in% names(tuning_grid), metric %in% names(tuning_grid))
  tuning_grid <- tuning_grid[order(tuning_grid[[x]]), ]

  p <- ggplot2::ggplot(tuning_grid, ggplot2::aes(x = .data[[x]], y = .data[[metric]]))
  if (!is.null(color) && color %in% names(tuning_grid)) {
    p <- p +
      ggplot2::geom_line(ggplot2::aes(color = .data[[color]], group = .data[[color]]), linewidth = 0.7) +
      ggplot2::geom_point(ggplot2::aes(color = .data[[color]]), size = 2.2)
  } else {
    p <- p +
      ggplot2::geom_line(linewidth = 0.7, color = "#2c7fb8") +
      ggplot2::geom_point(size = 2.2, color = "#2c7fb8")
  }

  # Marque le meilleur candidat (RMSE minimal) pour lecture rapide, comme
  # dans les figures de calibration du papier spboost.
  best <- tuning_grid[which.min(tuning_grid[[metric]]), , drop = FALSE]
  p <- p +
    ggplot2::geom_point(data = best, ggplot2::aes(x = .data[[x]], y = .data[[metric]]),
                         color = "#d7191c", size = 3.5, shape = 8) +
    ggplot2::labs(
      title = title %||% sprintf("Calibration de %s (%s)", x, toupper(metric)),
      subtitle = sprintf("Meilleur candidat marque d'une etoile rouge: %s = %s, %s = %.4g",
                          x, format(best[[x]]), toupper(metric), best[[metric]]),
      x = x, y = toupper(metric), color = color
    ) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(legend.position = if (is.null(color)) "none" else "top")
  p
}

# ---------------------------------------------------------------------------
# Barres RMSE/MAE comparatives par estimateur x schema de CV
# ---------------------------------------------------------------------------

#' Barres groupees RMSE/MAE, une facette par schema de CV, pour un dataset
#' donne. Attend le meme format que l'objet RDS ecrit par run_manual_test()
#' (colonnes dataset, estimator, cv_scheme, rmse, mae).
plot_cv_comparison <- function(benchmark_df, dataset_name, metric = "rmse") {
  stopifnot(is.data.frame(benchmark_df), metric %in% c("rmse", "mae"))
  df <- benchmark_df[benchmark_df$dataset == dataset_name & !is.na(benchmark_df[[metric]]), ]
  if (nrow(df) == 0) {
    stop(sprintf("plot_cv_comparison(): aucune ligne valide pour dataset='%s'.", dataset_name), call. = FALSE)
  }
  agg <- stats::aggregate(
    stats::as.formula(paste(metric, "~ estimator + cv_scheme")),
    data = df, FUN = mean
  )

  ggplot2::ggplot(agg, ggplot2::aes(x = estimator, y = .data[[metric]], fill = estimator)) +
    ggplot2::geom_col(width = 0.7, show.legend = FALSE) +
    ggplot2::facet_wrap(~cv_scheme, scales = "free_y") +
    ggplot2::labs(
      title = sprintf("%s moyen par estimateur et schema de CV -- %s", toupper(metric), dataset_name),
      x = NULL, y = toupper(metric)
    ) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 30, hjust = 1))
}

# ---------------------------------------------------------------------------
# Cartes de coefficients locaux beta(u,v): GWR vs MGWR multiscale
# ---------------------------------------------------------------------------

#' Refit GWR (mgwrsar_reg(model_type="GWR")) et MGWR multiscale
#' (model_type="tds_mgwr") sur l'ensemble complet du dataset (pas de split),
#' et trace les coefficients locaux beta_j(u,v), une facette par (modele x
#' covariable) -- meme esprit que la Fig. 7 de arxiv:2212.05814 (comparaison
#' de la variation spatiale d'un coefficient entre deux variantes de
#' modele).
#'
#' Geometrie utilisee (2026-07-04): la colonne `geom_origine` de l'objet
#' source, PAS coord_x/coord_y. Confirme que georgia et nyc_education la
#' portent en MULTIPOLYGON (comtes / census tracts d'origine, deja presents
#' dans data/final_datasets/sf -- aucune reimportation externe necessaire),
#' tandis qu'ewhp et lasrosas restent en POINT (parcelles/logements
#' individuels, pas de polygones a l'origine). La fonction detecte le type
#' de geometrie et bascule automatiquement entre choropleth (geom_sf+fill)
#' et nuage de points colore (geom_sf+color).
#'
#' Contrairement a generate_dataset_figures(), cette fonction REFIT les
#' modeles (les sorties benchmark ne contiennent pas les coefficients locaux)
#' -- necessite que DATASETS et mgwrsar_reg() soient deja charges (source()
#' benchmark_manual_test_2026-07.R au prealable).
#'
#' @param dataset_name nom du dataset, doit exister dans DATASETS.
#' @param covariates sous-ensemble de covariables a tracer; NULL = toutes
#'   (hors Intercept).
#' @param bandwidth,kernels parametres GWR; si bandwidth=NULL (defaut), la
#'   fonction essaie de lire le meilleur candidat dans
#'   hyperparam_tuning_<dataset>_mgwrsar_H_kernel_2026-07.rds (produit par
#'   run_manual_test()), sinon retombe sur H=20/kernel="bisq".
plot_local_coefficient_maps <- function(dataset_name, covariates = NULL,
                                         bandwidth = NULL, kernels = NULL,
                                         runs_dir = NULL) {
  if (!exists("DATASETS", envir = .GlobalEnv)) {
    stop("plot_local_coefficient_maps(): DATASETS introuvable -- source() ",
         "benchmark_manual_test_2026-07.R avant d'appeler cette fonction.", call. = FALSE)
  }
  spec <- get("DATASETS", envir = .GlobalEnv)[[dataset_name]]
  if (is.null(spec)) stop(sprintf("Dataset '%s' introuvable dans DATASETS.", dataset_name), call. = FALSE)

  if (is.null(runs_dir)) {
    root <- if (exists("REPO_ROOT", envir = .GlobalEnv)) get("REPO_ROOT", envir = .GlobalEnv) else "."
    runs_dir <- file.path(root, "data/manifests/runs")
  }
  if (is.null(bandwidth) || is.null(kernels)) {
    tuned_path <- file.path(runs_dir, sprintf("hyperparam_tuning_%s_mgwrsar_H_kernel_2026-07.rds", dataset_name))
    if (file.exists(tuned_path)) {
      grid <- readRDS(tuned_path)
      best <- grid[which.min(grid$rmse), ]
      if (is.null(bandwidth)) bandwidth <- best$bandwidth
      if (is.null(kernels)) kernels <- best$kernels
    } else {
      if (is.null(bandwidth)) bandwidth <- 20
      if (is.null(kernels)) kernels <- "bisq"
    }
  }

  coords <- c("coord_x", "coord_y")
  prepped <- prep_dataset(spec, keep_geometry = TRUE)
  df <- prepped$df
  geometry <- prepped$geometry
  fml <- build_estimator_formula(spec$y, c(spec$x, coords))

  fit_local <- function(model_type, label, ...) {
    mspec <- mgwrsar_reg(coords = coords, model_type = model_type, ...) |>
      parsnip::set_engine("mgwrsar") |> parsnip::set_mode("regression")
    fit_obj <- parsnip::fit(mspec, fml, data = df)
    eng <- parsnip::extract_fit_engine(fit_obj)
    if (nrow(eng@Betav) != length(geometry)) {
      # mgwrsar collapse les coordonnees dupliquees en interne
      # (make_unique_by_structure()) pour les modeles autres que "OLS" --
      # si ca arrive, Betav a moins de lignes que la geometrie et on ne peut
      # plus les aligner ligne a ligne en toute confiance. Mieux vaut
      # echouer bruyamment que produire une carte silencieusement fausse.
      stop(sprintf(
        "plot_local_coefficient_maps('%s'): %d lignes dans Betav (%s) vs %d dans la geometrie -- ",
        dataset_name, nrow(eng@Betav), label, length(geometry)),
        "coordonnees dupliquees probablement collapsees par mgwrsar; alignement non fiable.", call. = FALSE)
    }
    sf::st_sf(as.data.frame(eng@Betav), model = label, geometry = geometry)
  }

  gwr_sf <- fit_local("GWR", "GWR", kernels = kernels, bandwidth = bandwidth)
  tds_sf <- fit_local("tds_mgwr", "MGWR (tds)", kernels = "gauss")
  combined <- rbind(gwr_sf, tds_sf)
  combined$model <- factor(combined$model, levels = c("GWR", "MGWR (tds)"))

  covs <- covariates %||% setdiff(colnames(gwr_sf), c("model", "geometry", "Intercept"))
  missing_covs <- setdiff(covs, colnames(gwr_sf))
  if (length(missing_covs) > 0) {
    stop(sprintf("plot_local_coefficient_maps(): covariable(s) inconnue(s): %s",
                  paste(missing_covs, collapse = ", ")), call. = FALSE)
  }

  is_polygon <- any(grepl("POLYGON", as.character(sf::st_geometry_type(combined))))

  # Une echelle de couleur PARTAGEE entre toutes les covariables ecraserait
  # les covariables a faible amplitude (ex. PctBlack ~[-0.1,0.1]) a cote
  # d'une covariable a forte amplitude (ex. PctFB ~[-1,3.5]) -- confirme
  # visuellement le 2026-07-04 sur Georgia. Comme dans la figure de
  # reference (chaque panel a sa propre legende), chaque covariable recoit
  # sa PROPRE echelle diverging (mais partagee entre GWR et MGWR pour rester
  # comparable entre les deux lignes d'un meme panel), et les panels sont
  # assembles cote a cote avec patchwork.
  panels <- lapply(covs, function(cv) {
    sub <- combined[, "model"]
    sub$beta <- combined[[cv]]
    lim <- max(abs(sub$beta), na.rm = TRUE)
    p <- ggplot2::ggplot(sub)
    if (is_polygon) {
      p <- p +
        ggplot2::geom_sf(ggplot2::aes(fill = beta), color = "grey40", linewidth = 0.08) +
        ggplot2::scale_fill_gradient2(low = "#2166ac", mid = "#f7f7f7", high = "#b2182b",
                                       midpoint = 0, limits = c(-lim, lim))
    } else {
      p <- p +
        ggplot2::geom_sf(ggplot2::aes(color = beta), size = 1.5) +
        ggplot2::scale_color_gradient2(low = "#2166ac", mid = "#f7f7f7", high = "#b2182b",
                                        midpoint = 0, limits = c(-lim, lim))
    }
    p +
      ggplot2::facet_grid(model ~ .) +
      ggplot2::labs(title = cv, x = NULL, y = NULL, color = NULL, fill = NULL) +
      ggplot2::theme_minimal(base_size = 10) +
      ggplot2::theme(axis.text = ggplot2::element_blank(), axis.ticks = ggplot2::element_blank(),
                      plot.title = ggplot2::element_text(hjust = 0.5, size = 11))
  })

  combined_plot <- patchwork::wrap_plots(panels, nrow = 1) +
    patchwork::plot_annotation(
      title = sprintf("Coefficients locaux beta(u,v) -- GWR (haut) vs MGWR multiscale (bas), %s", dataset_name),
      subtitle = sprintf(
        "%s -- inspire de la Fig. 7, arxiv:2212.05814 -- une echelle de couleur par covariable",
        if (is_polygon) "Choropleth sur la geometrie d'origine (geom_origine)" else "Nuage de points colore (geometrie d'origine ponctuelle)"
      )
    )
  attr(combined_plot, "n_covariates") <- length(covs)
  combined_plot
}

# ---------------------------------------------------------------------------
# Orchestrateur: genere et sauvegarde toutes les figures d'un dataset
# ---------------------------------------------------------------------------

#' Lit les objets R de tuning et de benchmark deja ecrits par
#' benchmark_manual_test_2026-07.R pour `dataset_name`, produit les figures
#' de calibration (spboost mstop, mgwrsar bandwidth/kernel) et de comparaison
#' RMSE/MAE, et les enregistre dans data/manifests/runs/figures/.
#'
#' @param dataset_name nom du dataset (ex. "georgia"), doit correspondre aux
#'   fichiers hyperparam_tuning_<dataset_name>_*.rds et aux lignes
#'   `dataset == dataset_name` du benchmark_manual_test_2026-07.rds.
#' @param runs_dir dossier contenant les objets RDS (par defaut data/manifests/runs
#'   relatif a REPO_ROOT si defini, sinon au repertoire courant).
#' Chaque dataset ecrit ses PNG dans son propre sous-dossier
#' data/manifests/runs/figures/<dataset_name>/ (2026-07-04), pour ne pas
#' melanger les fichiers de plusieurs datasets dans un seul dossier plat.
generate_dataset_figures <- function(dataset_name, runs_dir = NULL) {
  if (is.null(runs_dir)) {
    root <- if (exists("REPO_ROOT", envir = .GlobalEnv)) get("REPO_ROOT", envir = .GlobalEnv) else "."
    runs_dir <- file.path(root, "data/manifests/runs")
  }
  fig_dir <- file.path(runs_dir, "figures", dataset_name)
  dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)

  saved <- character(0)

  spboost_path <- file.path(runs_dir, sprintf("hyperparam_tuning_%s_spboost_mstop_2026-07.rds", dataset_name))
  if (file.exists(spboost_path)) {
    grid <- readRDS(spboost_path)
    p <- plot_tuning_curve(grid, x = "mstop", metric = "rmse",
                            title = sprintf("SpBoost -- calibration de mstop (%s)", dataset_name))
    out <- file.path(fig_dir, sprintf("%s_tuning_spboost_mstop.png", dataset_name))
    ggplot2::ggsave(out, p, width = 7, height = 5, dpi = 130)
    saved <- c(saved, out)
  }

  mgwrsar_path <- file.path(runs_dir, sprintf("hyperparam_tuning_%s_mgwrsar_H_kernel_2026-07.rds", dataset_name))
  if (file.exists(mgwrsar_path)) {
    grid <- readRDS(mgwrsar_path)
    p <- plot_tuning_curve(grid, x = "bandwidth", metric = "rmse", color = "kernels",
                            title = sprintf("MGWRSAR/GWR -- calibration de H et kernel (%s)", dataset_name))
    out <- file.path(fig_dir, sprintf("%s_tuning_mgwrsar_bandwidth.png", dataset_name))
    ggplot2::ggsave(out, p, width = 7, height = 5, dpi = 130)
    saved <- c(saved, out)
  }

  bench_path <- file.path(runs_dir, "benchmark_manual_test_2026-07.rds")
  if (file.exists(bench_path)) {
    bench <- readRDS(bench_path)
    if (dataset_name %in% bench$dataset) {
      for (metric in c("rmse", "mae")) {
        p <- plot_cv_comparison(bench, dataset_name, metric = metric)
        out <- file.path(fig_dir, sprintf("%s_comparison_%s.png", dataset_name, metric))
        ggplot2::ggsave(out, p, width = 8, height = 5, dpi = 130)
        saved <- c(saved, out)
      }
    }
  }

  if (length(saved) == 0) {
    warning(sprintf("generate_dataset_figures('%s'): aucun objet RDS trouve dans %s.", dataset_name, runs_dir), call. = FALSE)
  } else {
    cat(sprintf("Figures ecrites pour '%s':\n", dataset_name))
    for (f in saved) cat("  -", f, "\n")
  }
  invisible(saved)
}

#' Variante de generate_dataset_figures() qui REFIT GWR + MGWR multiscale
#' (voir plot_local_coefficient_maps()) et sauvegarde la carte de
#' coefficients locaux dans le meme sous-dossier data/manifests/runs/figures/<dataset_name>/.
#' Appel separe et explicite car plus couteux (refit de deux modeles sur
#' l'ensemble du dataset), contrairement au reste de ce fichier qui ne
#' relit que des objets RDS deja ecrits.
save_local_coefficient_maps <- function(dataset_name, runs_dir = NULL, ...) {
  if (is.null(runs_dir)) {
    root <- if (exists("REPO_ROOT", envir = .GlobalEnv)) get("REPO_ROOT", envir = .GlobalEnv) else "."
    runs_dir <- file.path(root, "data/manifests/runs")
  }
  fig_dir <- file.path(runs_dir, "figures", dataset_name)
  dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)

  p <- plot_local_coefficient_maps(dataset_name, runs_dir = runs_dir, ...)
  out <- file.path(fig_dir, sprintf("%s_local_coefficient_maps.png", dataset_name))
  n_covariates <- attr(p, "n_covariates") %||% 4
  ggplot2::ggsave(out, p, width = max(7, 2.6 * n_covariates), height = 5.5, dpi = 130)
  cat("Carte de coefficients locaux ecrite:", out, "\n")
  invisible(out)
}
