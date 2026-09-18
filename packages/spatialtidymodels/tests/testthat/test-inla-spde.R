# Tests for the INLA SPDE estimator (inla_spde_reg(), inlabru::bru()), added
# alongside the plan in .claude/plans (INLA as a new spatial estimator).
# INLA is not on CRAN and not universally installable -- every test here is
# guarded with skip_if_not_installed(), same convention as the ProbitSpatial
# tests in test-classification-count.R. Kept fast (tiny synthetic dataset,
# coarse mesh), same convention as the rest of the suite.

inla_spde_grid_coords <- function(n) {
  side <- ceiling(sqrt(n))
  cbind(
    x_coord = rep(seq_len(side), each = side)[seq_len(n)],
    y_coord = rep(seq_len(side), times = side)[seq_len(n)]
  )
}

inla_spde_test_data <- function(n = 60L, seed = 1L) {
  set.seed(seed)
  coords <- inla_spde_grid_coords(n)
  x1 <- stats::rnorm(n)
  # Champ spatial lisse simple (fonction sinusoidale des coordonnees) + bruit,
  # pour que le champ SPDE ait effectivement quelque chose a capturer.
  spatial_signal <- sin(coords[, 1] / 2) + cos(coords[, 2] / 2)
  y <- 1 + 0.8 * x1 + spatial_signal + stats::rnorm(n, sd = 0.3)
  data.frame(y = y, x1 = x1, x_coord = coords[, 1], y_coord = coords[, 2])
}

test_that("inla_spde_reg()/update() build a parsnip spec without evaluating args", {
  spec <- inla_spde_reg(coords = c("x_coord", "y_coord"))
  expect_s3_class(spec, "model_spec")
  expect_equal(spec$mode, "regression")

  updated <- update(spec, mesh_max_edge = c(1, 2))
  expect_s3_class(updated, "model_spec")
})

test_that("inla_spde_default_priors()/inla_spde_default_mesh() are deterministic and overridable", {
  skip_if_not_installed("fmesher")
  set.seed(2)
  coords <- inla_spde_grid_coords(40L)
  y <- stats::rnorm(40L, sd = 2)

  priors_a <- inla_spde_default_priors(coords, y)
  priors_b <- inla_spde_default_priors(coords, y)
  expect_equal(priors_a, priors_b)
  expect_length(priors_a$prior_range, 2L)
  expect_length(priors_a$prior_sigma, 2L)
  expect_equal(priors_a$prior_sigma[1], stats::sd(y))

  overridden <- inla_spde_default_priors(coords, y, prior_range = c(5, 0.5))
  expect_equal(overridden$prior_range, c(5, 0.5))
  expect_equal(overridden$prior_sigma, priors_a$prior_sigma)

  mesh_a <- inla_spde_default_mesh(coords)
  mesh_b <- inla_spde_default_mesh(coords)
  expect_equal(mesh_a$n, mesh_b$n)

  mesh_override <- inla_spde_default_mesh(coords, cutoff = 0.5)
  expect_true(!is.null(mesh_override$n))
})

test_that("inlaspde_fit_impl()/inlaspde_pred_impl() fit and predict end-to-end on synthetic data", {
  skip_if_not_installed("INLA")
  skip_if_not_installed("inlabru")
  skip_if_not_installed("fmesher")

  dat <- inla_spde_test_data(n = 60L)
  train <- dat[1:50, ]
  test <- dat[51:60, ]

  fit_obj <- inlaspde_fit_impl(y ~ x1, train, coords = c("x_coord", "y_coord"))
  expect_true(!is.null(attr(fit_obj, "inlaspde_mesh")))
  expect_true(!is.null(attr(fit_obj, "inlaspde_spde")))

  # parsnip::extract_fit_engine.model_fit() ne fait que renvoyer x$fit --
  # un objet model_fit minimal suffit donc pour appeler pred_impl() isolement,
  # sans passer par workflows::fit() (couvert separement ci-dessous).
  model_fit_stub <- structure(list(fit = fit_obj), class = "model_fit")
  preds <- inlaspde_pred_impl(model_fit_stub, test)
  expect_length(preds, nrow(test))
  expect_true(all(is.finite(preds)))
})

test_that("inla_spde_reg() fits and predicts end-to-end through the parsnip/workflows path", {
  skip_if_not_installed("INLA")
  skip_if_not_installed("inlabru")
  skip_if_not_installed("fmesher")
  skip_if_not_installed("workflows")

  dat <- inla_spde_test_data(n = 60L)
  train <- dat[1:50, ]
  test <- dat[51:60, ]

  wf <- make_benchmark_workflow(
    inla_spde_reg(coords = c("x_coord", "y_coord")) |> parsnip::set_engine("inlabru"),
    y ~ x1, c("x_coord", "y_coord"), train
  ) |>
    workflows::fit(data = train)

  preds <- predict(wf, new_data = test)
  expect_equal(nrow(preds), nrow(test))
  expect_true(all(is.finite(preds$.pred)))
})

test_that("fit_one_benchmark_estimator() routes 'inla_spde' end-to-end", {
  skip_if_not_installed("INLA")
  skip_if_not_installed("inlabru")
  skip_if_not_installed("fmesher")

  dat <- inla_spde_test_data(n = 60L)
  fit <- fit_one_benchmark_estimator(
    "inla_spde", y ~ x1, dat, coords = c("x_coord", "y_coord")
  )
  expect_true(!is.null(fit))
})

# --- Phase 2 (2026-09-15): familles non-gaussiennes, motivees par 3 papiers
# du corpus qui utilisent reellement INLA en binomial/poisson --
# paper_flapper_skate_presence (binomial+cloglog), paper_mistletoe_bird_abundance
# et paper_goa_trawl_demersal (binomial+poisson/gamma). Meme convention de
# grille/DGP que test-classification-count.R.

inla_spde_binary_test_data <- function(n = 80L, seed = 1L, link = "logit") {
  set.seed(seed)
  coords <- inla_spde_grid_coords(n)
  x1 <- stats::rnorm(n)
  eta <- -0.5 + 1.1 * x1 + sin(coords[, 1] / 2)
  p <- if (identical(link, "cloglog")) 1 - exp(-exp(eta)) else stats::plogis(eta)
  y <- stats::rbinom(n, 1, p)
  data.frame(y = y, x1 = x1, x_coord = coords[, 1], y_coord = coords[, 2])
}

inla_spde_count_test_data <- function(n = 80L, seed = 1L) {
  set.seed(seed)
  coords <- inla_spde_grid_coords(n)
  x1 <- stats::rnorm(n)
  lambda <- exp(1 + 0.3 * x1 + 0.1 * sin(coords[, 1] / 2))
  y <- stats::rpois(n, lambda)
  data.frame(y = y, x1 = x1, x_coord = coords[, 1], y_coord = coords[, 2])
}

test_that("fit_one_benchmark_estimator() routes 'inla_spde' to binomial (logit) for a binary task", {
  skip_if_not_installed("INLA")
  skip_if_not_installed("inlabru")
  skip_if_not_installed("fmesher")

  dat <- inla_spde_binary_test_data(link = "logit")
  fit <- fit_one_benchmark_estimator(
    "inla_spde", y ~ x1, dat, coords = c("x_coord", "y_coord"),
    response_typology = "binary"
  )
  preds <- predict(fit, new_data = dat[1:10, ])$.pred
  expect_length(preds, 10L)
  expect_true(all(is.finite(preds)))
  expect_true(all(preds >= 0 & preds <= 1))
})

test_that("fit_one_benchmark_estimator() routes 'inla_spde' to binomial+cloglog when glm_link='cloglog'", {
  skip_if_not_installed("INLA")
  skip_if_not_installed("inlabru")
  skip_if_not_installed("fmesher")

  dat <- inla_spde_binary_test_data(link = "cloglog")
  fit <- fit_one_benchmark_estimator(
    "inla_spde", y ~ x1, dat, coords = c("x_coord", "y_coord"),
    response_typology = "binary", glm_link = "cloglog"
  )
  preds <- predict(fit, new_data = dat[1:10, ])$.pred
  expect_length(preds, 10L)
  expect_true(all(is.finite(preds)))
  expect_true(all(preds >= 0 & preds <= 1))
  expect_equal(attr(parsnip::extract_fit_engine(fit), "inlaspde_link"), "cloglog")
})

test_that("fit_one_benchmark_estimator() routes 'inla_spde' to poisson for a count task", {
  skip_if_not_installed("INLA")
  skip_if_not_installed("inlabru")
  skip_if_not_installed("fmesher")

  dat <- inla_spde_count_test_data()
  fit <- fit_one_benchmark_estimator(
    "inla_spde", y ~ x1, dat, coords = c("x_coord", "y_coord"),
    response_typology = "count"
  )
  preds <- predict(fit, new_data = dat[1:10, ])$.pred
  expect_length(preds, 10L)
  expect_true(all(is.finite(preds)))
  expect_true(all(preds > 0))
  expect_equal(attr(parsnip::extract_fit_engine(fit), "inlaspde_family"), "poisson")
})

test_that("inla_spde_reg() stays mode='regression' for binary tasks (numeric probability, not a class)", {
  skip_if_not_installed("INLA")
  skip_if_not_installed("inlabru")
  skip_if_not_installed("fmesher")

  dat <- inla_spde_binary_test_data()
  fit <- fit_one_benchmark_estimator(
    "inla_spde", y ~ x1, dat, coords = c("x_coord", "y_coord"),
    response_typology = "binary"
  )
  expect_s3_class(fit, "workflow")
  expect_equal(workflows::extract_spec_parsnip(fit)$mode, "regression")
})

test_that("inlaspde_normalize_binomial_y() accepts a 2-level factor or 0/1 numeric, rejects other values", {
  expect_equal(inlaspde_normalize_binomial_y(factor(c("0", "1", "0"), levels = c("0", "1"))), c(0L, 1L, 0L))
  expect_equal(inlaspde_normalize_binomial_y(c(0, 1, 0, 1)), c(0L, 1L, 0L, 1L))
  expect_error(inlaspde_normalize_binomial_y(c(0, 1, 2)), "binaire")
  expect_error(inlaspde_normalize_binomial_y(factor(c("a", "b", "c"))), "2 niveaux")
})

test_that("inlaspde_fit_impl() rejects unsupported family/link combinations with a clear error", {
  dat <- inla_spde_test_data(n = 30L)
  expect_error(
    inlaspde_fit_impl(y ~ x1, dat, coords = c("x_coord", "y_coord"), family = "gamma"),
    "family"
  )
  expect_error(
    inlaspde_fit_impl(y ~ x1, dat, coords = c("x_coord", "y_coord"), family = "gaussian", link = "log"),
    "gaussian"
  )
  expect_error(
    inlaspde_fit_impl(y ~ x1, dat, coords = c("x_coord", "y_coord"), family = "binomial", link = "probit"),
    "binomial"
  )
})

# --- Phase 3 (2026-09-18): variante effets aleatoires de groupe
# (`inla_spde_group`) et variante spatio-temporelle (`inla_spde_st`) --
# motivees par paper_banff_stream_temperature/paper_mistletoe_bird_abundance
# (groupe) et paper_crane/paper_mistletoe_bird_abundance/
# paper_goa_trawl_demersal (espace-temps). Voir le plan
# "Etendre inla_spde : variante spatio-temporelle + effets aleatoires de
# groupe" pour le contexte complet.

inla_spde_group_test_data <- function(n = 80L, seed = 1L, n_groups = 4L) {
  set.seed(seed)
  coords <- inla_spde_grid_coords(n)
  x1 <- stats::rnorm(n)
  groupe <- factor(sample(seq_len(n_groups), n, replace = TRUE))
  group_effect <- stats::rnorm(n_groups, sd = 1.5)[as.integer(groupe)]
  spatial_signal <- sin(coords[, 1] / 2) + cos(coords[, 2] / 2)
  y <- 1 + 0.8 * x1 + spatial_signal + group_effect + stats::rnorm(n, sd = 0.3)
  data.frame(y = y, x1 = x1, x_coord = coords[, 1], y_coord = coords[, 2], groupe = groupe)
}

test_that("inlaspde_fit_impl() translates (1 | groupe) into an iid component and fits/predicts", {
  skip_if_not_installed("INLA")
  skip_if_not_installed("inlabru")
  skip_if_not_installed("fmesher")

  dat <- inla_spde_group_test_data(n = 80L)
  train <- dat[1:70, ]
  test <- dat[71:80, ]

  fit_obj <- inlaspde_fit_impl(y ~ x1 + (1 | groupe), train, coords = c("x_coord", "y_coord"))
  expect_equal(attr(fit_obj, "inlaspde_group_cols"), "groupe")
  expect_true(is.character(attr(fit_obj, "inlaspde_group_levels")$groupe))

  model_fit_stub <- structure(list(fit = fit_obj), class = "model_fit")
  preds <- inlaspde_pred_impl(model_fit_stub, test)
  expect_length(preds, nrow(test))
  expect_true(all(is.finite(preds)))
})

test_that("inlaspde_pred_impl() handles an unseen group level gracefully via the iid prior (no NA, no error)", {
  skip_if_not_installed("INLA")
  skip_if_not_installed("inlabru")
  skip_if_not_installed("fmesher")

  # Verifie empiriquement (2026-09-18) : predict.bru() ne plante pas et ne
  # renvoie pas NA pour un niveau de groupe absent de l'entrainement -- il
  # marginalise sur le prior bayesien de l'effet iid, un comportement correct
  # et attendu pour ce type de modele (contrairement a mgcv::predict.gam()
  # sur un s(x, bs="re"), sans notion de prior). Ce test fige ce comportement
  # observe, il ne l'invente pas.
  dat <- inla_spde_group_test_data(n = 60L)
  fit_obj <- inlaspde_fit_impl(y ~ x1 + (1 | groupe), dat, coords = c("x_coord", "y_coord"))
  new_row <- dat[1, ]
  new_row$groupe <- factor("99", levels = "99")
  model_fit_stub <- structure(list(fit = fit_obj), class = "model_fit")
  preds <- inlaspde_pred_impl(model_fit_stub, new_row)
  expect_length(preds, 1L)
  expect_true(is.finite(preds))
})

test_that("fit_one_benchmark_estimator() routes 'inla_spde_group' end-to-end and rejects a formula without a group term", {
  skip_if_not_installed("INLA")
  skip_if_not_installed("inlabru")
  skip_if_not_installed("fmesher")

  dat <- inla_spde_group_test_data(n = 80L)
  fit <- fit_one_benchmark_estimator(
    "inla_spde_group", y ~ x1 + (1 | groupe), dat, coords = c("x_coord", "y_coord")
  )
  expect_true(!is.null(fit))
  expect_s3_class(fit, "inla_spde_group_fit")

  expect_error(
    fit_one_benchmark_estimator("inla_spde_group", y ~ x1, dat, coords = c("x_coord", "y_coord")),
    "aucun terme"
  )
})

test_that("predict_vector_for_benchmark() bypasses generic predict() dispatch for inla_spde_group_fit", {
  skip_if_not_installed("INLA")
  skip_if_not_installed("inlabru")
  skip_if_not_installed("fmesher")

  # isGeneric("predict") devient TRUE une fois INLA charge (confirme
  # empiriquement, 2026-09-18) -- le predict() generique standard route alors
  # vers predict.bru() (sortie brute inlabru), pas vers notre
  # predict.inla_spde_group_fit(), meme si la methode existe et est trouvee
  # par getS3method(). predict_vector_for_benchmark() doit donc contourner
  # le dispatch generique explicitement -- ce test protege ce contournement.
  dat <- inla_spde_group_test_data(n = 80L)
  fit <- fit_one_benchmark_estimator(
    "inla_spde_group", y ~ x1 + (1 | groupe), dat, coords = c("x_coord", "y_coord")
  )
  preds <- predict_vector_for_benchmark(fit, dat[1:5, ])
  expect_true(is.numeric(preds))
  expect_length(preds, 5L)
  expect_true(all(is.finite(preds)))
})

inla_spde_st_test_data <- function(n_per_period = 25L, n_period = 4L, seed = 1L) {
  set.seed(seed)
  coords <- inla_spde_grid_coords(n_per_period)
  coords_rep <- coords[rep(seq_len(n_per_period), n_period), ]
  period <- rep(seq_len(n_period), each = n_per_period)
  x1 <- stats::rnorm(n_per_period * n_period)
  spatial_signal <- sin(coords_rep[, 1] / 2) + cos(coords_rep[, 2] / 2)
  # Derive persistant plausible d'un AR1 (pas simule comme un AR1 exact --
  # suffisant pour verifier que le harnais ajuste et utilise le parametre,
  # pas pour une verification statistique fine).
  period_shift <- c(0, 0.5, 0.9, 1.1)[period]
  y <- 1 + 0.8 * x1 + spatial_signal + period_shift + stats::rnorm(length(period), sd = 0.3)
  data.frame(y = y, x1 = x1, x_coord = coords_rep[, 1], y_coord = coords_rep[, 2], period = period)
}

test_that("inlaspde_fit_impl() fits a space-time field via time= and actually estimates an AR1 group correlation", {
  skip_if_not_installed("INLA")
  skip_if_not_installed("inlabru")
  skip_if_not_installed("fmesher")

  dat <- inla_spde_st_test_data()
  fit_obj <- inlaspde_fit_impl(y ~ x1, dat, coords = c("x_coord", "y_coord"), time = "period")
  expect_equal(attr(fit_obj, "inlaspde_time_col"), "period")
  expect_equal(attr(fit_obj, "inlaspde_time_levels"), c("1", "2", "3", "4"))
  # Un champ purement spatial (sans group=/control.group=) n'a pas de
  # hyperparametre de correlation de groupe -- sa presence prouve que la
  # structure spatio-temporelle a reellement ete ajustee, pas juste poolee.
  expect_true(any(grepl("Rho", rownames(fit_obj$summary.hyperpar))))

  model_fit_stub <- structure(list(fit = fit_obj), class = "model_fit")
  seen_period_row <- dat[dat$period == 2, ][1, ]
  preds <- inlaspde_pred_impl(model_fit_stub, seen_period_row)
  expect_length(preds, 1L)
  expect_true(is.finite(preds))
})

test_that("inlaspde_pred_impl() refuses to extrapolate to an unseen period", {
  skip_if_not_installed("INLA")
  skip_if_not_installed("inlabru")
  skip_if_not_installed("fmesher")

  dat <- inla_spde_st_test_data()
  fit_obj <- inlaspde_fit_impl(y ~ x1, dat, coords = c("x_coord", "y_coord"), time = "period")
  new_row <- dat[1, ]
  new_row$period <- 99
  model_fit_stub <- structure(list(fit = fit_obj), class = "model_fit")
  expect_error(inlaspde_pred_impl(model_fit_stub, new_row), "periode")
})

test_that("fit_one_benchmark_estimator() routes 'inla_spde_st' end-to-end and requires inla_time", {
  skip_if_not_installed("INLA")
  skip_if_not_installed("inlabru")
  skip_if_not_installed("fmesher")

  dat <- inla_spde_st_test_data()
  fit <- fit_one_benchmark_estimator(
    "inla_spde_st", y ~ x1, dat, coords = c("x_coord", "y_coord"), inla_time = "period"
  )
  expect_true(!is.null(fit))

  expect_error(
    fit_one_benchmark_estimator("inla_spde_st", y ~ x1, dat, coords = c("x_coord", "y_coord")),
    "inla_time"
  )
})
