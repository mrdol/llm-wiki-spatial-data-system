# Tests for the spatial panel harness (J1/J2 of
# wiki/analyses/plan_implementation_panel_spatial_2026-09-09.md):
# spatial_panel_spec(), validate_spatial_panel_data(), align_panel_W(),
# panel_fe_fit()/panel_sar_fe_fit(), and benchmark_spatial_panel(). This is a
# separate branch from the cross-sectional harness (sar_lag/sem_error/
# sdm_mixed) and must never be reachable through benchmark_spatial().

munnell_panel <- function() {
  skip_if_not_installed("plm")
  skip_if_not_installed("splm")
  skip_if_not_installed("spdep")
  data("Produc", package = "plm")
  data("usaww", package = "splm")
  list(
    data = Produc,
    W = usaww,
    panel = spatial_panel_spec(
      unit = "state", time = "year", effect = "individual",
      balance = "balanced", prediction_target = "fit_only"
    ),
    formula = log(gsp) ~ log(pcap) + log(pc) + log(emp) + unemp
  )
}

# --- spatial_panel_spec() ---

test_that("spatial_panel_spec() validates its enum arguments", {
  spec <- spatial_panel_spec(unit = "u", time = "t")
  expect_s3_class(spec, "spatial_panel_spec")
  expect_equal(spec$effect, "individual")
  expect_equal(spec$balance, "balanced")
  expect_equal(spec$prediction_target, "fit_only")
  expect_error(spatial_panel_spec(unit = "u", time = "t", effect = "bogus"))
  expect_error(spatial_panel_spec(unit = 1, time = "t"))
})

# --- validate_spatial_panel_data(): structural checks ---

test_that("validate_spatial_panel_data() detects duplicate unit-time pairs", {
  dat <- data.frame(u = c("a", "a", "b"), t = c(1, 1, 2), y = 1:3)
  panel <- spatial_panel_spec(unit = "u", time = "t", balance = "unbalanced")
  expect_error(validate_spatial_panel_data(dat, panel), "dupliqu")
})

test_that("validate_spatial_panel_data() catches a mismatch between declared and actual balance", {
  dat <- data.frame(
    u = rep(c("a", "b"), each = 3),
    t = c(1, 2, 3, 1, 2, 3),
    y = rnorm(6)
  )
  dat_gap <- dat[-6, ] # drop b/3 -> unbalanced
  panel_balanced <- spatial_panel_spec(unit = "u", time = "t", balance = "balanced")
  expect_error(validate_spatial_panel_data(dat_gap, panel_balanced), "balanced")

  panel_unbalanced <- spatial_panel_spec(unit = "u", time = "t", balance = "unbalanced")
  expect_error(validate_spatial_panel_data(dat, panel_unbalanced), "unbalanced")

  v <- validate_spatial_panel_data(dat_gap, panel_unbalanced)
  expect_false(v$balanced)
  expect_equal(nrow(v$missing_unit_periods), 1L)
})

test_that("validate_spatial_panel_data() rejects NA unit/time identifiers", {
  dat <- data.frame(u = c("a", NA, "b"), t = c(1, 2, 3), y = 1:3)
  panel <- spatial_panel_spec(unit = "u", time = "t", balance = "unbalanced")
  expect_error(validate_spatial_panel_data(dat, panel), "NA")
})

test_that("validate_spatial_panel_data() computes n_units/n_periods and reports balanced=TRUE for a full grid", {
  dat <- expand.grid(u = c("a", "b", "c"), t = 2000:2004, stringsAsFactors = FALSE)
  dat$y <- rnorm(nrow(dat))
  panel <- spatial_panel_spec(unit = "u", time = "t", balance = "balanced")
  v <- validate_spatial_panel_data(dat, panel)
  expect_equal(v$n_units, 3L)
  expect_equal(v$n_periods, 5L)
  expect_true(v$balanced)
})

# --- align_panel_W(): dimension/name checks and permutation invariance ---

test_that("align_panel_W() errors on wrong dimension", {
  units <- c("a", "b", "c")
  W <- matrix(0, 2, 2, dimnames = list(c("a", "b"), c("a", "b")))
  expect_error(align_panel_W(units, W), "[Dd]imension")
})

test_that("align_panel_W() errors on a non-square matrix", {
  units <- c("a", "b")
  W <- matrix(0, 2, 3)
  expect_error(align_panel_W(units, W), "carr")
})

test_that("align_panel_W() requires w_unit_order when W has no dimnames", {
  units <- c("a", "b")
  W <- matrix(c(0, 1, 1, 0), 2, 2)
  expect_error(align_panel_W(units, W), "w_unit_order")
  out <- align_panel_W(units, W, w_unit_order = c("a", "b"))
  expect_equal(rownames(out), c("a", "b"))
})

test_that("align_panel_W() errors when named W's dimnames don't match the units", {
  units <- c("a", "b")
  W <- matrix(0, 2, 2, dimnames = list(c("a", "x"), c("a", "x")))
  expect_error(align_panel_W(units, W), "correspond")
})

test_that("align_panel_W() is invariant to the row/column order of W and of the unit vector", {
  units <- c("c", "a", "b", "a", "c") # repeated units, arbitrary order
  W <- matrix(c(0, 1, 1, 1, 0, 1, 1, 1, 0), 3, 3, dimnames = list(c("b", "c", "a"), c("b", "c", "a")))
  aligned1 <- align_panel_W(units, W)
  expect_equal(rownames(aligned1), c("a", "b", "c"))

  units_perm <- rev(units)
  W_perm <- W[c("a", "c", "b"), c("a", "c", "b")]
  aligned2 <- align_panel_W(units_perm, W_perm)
  expect_equal(aligned1, aligned2)
})

test_that("align_panel_W() refuses a listw object directly", {
  skip_if_not_installed("spdep")
  W <- matrix(c(0, 1, 1, 0), 2, 2, dimnames = list(c("a", "b"), c("a", "b")))
  listw <- spdep::mat2listw(W, style = "W")
  expect_error(align_panel_W(c("a", "b"), listw), "listw")
})

# --- panel_fe_fit() / panel_sar_fe_fit(): parity with direct plm/splm calls ---

test_that("panel_fe_fit() matches a direct plm::plm() call on the Munnell panel", {
  m <- munnell_panel()
  fit <- panel_fe_fit(m$formula, m$data, m$panel, model_type = "within")
  expect_s3_class(fit, "spatial_panel_fit")
  expect_equal(fit$n_units, 48L)
  expect_equal(fit$n_periods, 17L)
  expect_true(fit$balanced)

  direct <- plm::plm(m$formula, data = plm::pdata.frame(m$data, index = c("state", "year")), model = "within", effect = "individual")
  expect_equal(unname(coef(fit$fit)), unname(coef(direct)), tolerance = 1e-8)
})

test_that("panel_sar_fe_fit() matches a direct splm::spml() call on the Munnell panel (Millo & Piras 2012 reference)", {
  m <- munnell_panel()
  fit <- panel_sar_fe_fit(m$formula, m$data, m$panel, W = m$W, model_type = "within")
  expect_s3_class(fit, "spatial_panel_fit")
  expect_equal(fit$engine, "panel_sar_fe")

  listw <- spdep::mat2listw(row_standardize_W(align_panel_W(m$data$state, m$W)), style = "W")
  direct <- splm::spml(
    m$formula, data = plm::pdata.frame(m$data, index = c("state", "year")),
    listw = listw, model = "within", effect = "individual", lag = TRUE, spatial.error = "none"
  )
  expect_equal(unname(coef(fit$fit)), unname(coef(direct)), tolerance = 1e-6)
  # Published reference (Millo & Piras 2012, JSS 47, splm vignette): lambda ~= 0.275.
  expect_equal(fit$extra$lag_coefficient, 0.2746887, tolerance = 1e-5)
})

test_that("panel_fe_fit()/panel_sar_fe_fit() are invariant to a permutation of the input rows", {
  m <- munnell_panel()
  set.seed(1)
  perm <- sample(nrow(m$data))
  data_perm <- m$data[perm, ]

  fit_a <- panel_fe_fit(m$formula, m$data, m$panel, model_type = "within")
  fit_b <- panel_fe_fit(m$formula, data_perm, m$panel, model_type = "within")
  expect_equal(unname(coef(fit_a$fit)), unname(coef(fit_b$fit)), tolerance = 1e-8)

  W_perm <- m$W[sample(nrow(m$W)), ]
  W_perm <- W_perm[, rownames(W_perm)]
  fit_sar_a <- panel_sar_fe_fit(m$formula, m$data, m$panel, W = m$W, model_type = "within")
  fit_sar_b <- panel_sar_fe_fit(m$formula, data_perm, m$panel, W = W_perm, model_type = "within")
  expect_equal(unname(coef(fit_sar_a$fit)), unname(coef(fit_sar_b$fit)), tolerance = 1e-6)
})

# --- benchmark_spatial_panel(): orchestration ---

test_that("available_panel_estimators() lists panel_fe and panel_sar_fe with correct W requirement", {
  reg <- available_panel_estimators()
  expect_true(all(c("panel_fe", "panel_sar_fe") %in% reg$estimator))
  expect_false(reg$requires_W[reg$estimator == "panel_fe"])
  expect_true(reg$requires_W[reg$estimator == "panel_sar_fe"])
})

test_that("benchmark_spatial_panel() runs panel_fe and panel_sar_fe end to end on the Munnell panel", {
  m <- munnell_panel()
  bench <- benchmark_spatial_panel(
    m$formula, m$data, m$panel, W = m$W,
    estimators = c("panel_fe", "panel_sar_fe")
  )
  expect_s3_class(bench, "spatial_panel_benchmark")
  expect_true(all(is.na(bench$results$fit_error)))
  expect_equal(bench$results$n_units, c(48L, 48L))
  expect_equal(bench$results$cv_scheme, c("panel_full_fit", "panel_full_fit"))
  expect_true(is.na(bench$results$lag_coefficient[bench$results$estimator == "panel_fe"]))
  expect_equal(bench$results$lag_coefficient[bench$results$estimator == "panel_sar_fe"], 0.2746887, tolerance = 1e-5)
  expect_true(all(c("panel_fe", "panel_sar_fe") %in% names(bench$fits)))
})

test_that("benchmark_spatial_panel() rejects an unknown estimator with a clear error", {
  m <- munnell_panel()
  expect_error(
    benchmark_spatial_panel(m$formula, m$data, m$panel, W = m$W, estimators = "panel_totally_bogus"),
    "inconnu"
  )
})

test_that("benchmark_spatial_panel() reports a per-row fit_error (not a crash) when W is missing for panel_sar_fe", {
  m <- munnell_panel()
  bench <- benchmark_spatial_panel(m$formula, m$data, m$panel, estimators = "panel_sar_fe")
  expect_true(is.na(bench$results$n_obs))
  expect_false(is.na(bench$results$fit_error))
  expect_length(bench$fits, 0L)
})

test_that("benchmark_spatial_panel() only accepts the panel_full_fit cv_scheme", {
  m <- munnell_panel()
  expect_error(
    benchmark_spatial_panel(m$formula, m$data, m$panel, W = m$W, estimators = "panel_fe", cv_scheme = "vfold_cv")
  )
})

# --- row_standardize_W(): the fitting convention shared by all spatial engines ---

test_that("row_standardize_W() divides each row by its own row sum", {
  # Construite ligne par ligne (rbind) pour eviter toute ambiguite avec le
  # remplissage column-major d'une matrice construite via un seul vecteur.
  W <- rbind(
    a = c(a = 0, b = 1, c = 1),
    b = c(a = 1, b = 0, c = 0),
    c = c(a = 1, b = 1, c = 0)
  )
  out <- row_standardize_W(W)
  expect_equal(unname(rowSums(out)), rep(1, 3))
  expect_equal(unname(out["a", "b"]), 0.5)
  expect_equal(unname(out["b", "a"]), 1)
  expect_equal(unname(out["c", "a"]), 0.5)
})

test_that("row_standardize_W() errors clearly on a unit with no neighbours (zero row sum)", {
  W <- matrix(c(0, 0, 0, 1), 2, 2, dimnames = list(c("a", "b"), c("a", "b")))
  expect_error(row_standardize_W(W), "voisin")
})

test_that("row_standardize_W() is a no-op on a W that is already row-standardized", {
  data("usaww", package = "splm")
  expect_equal(row_standardize_W(usaww), usaww)
})

# --- panel_sem_fe_fit() / panel_sac_fe_fit(): parity with direct splm::spml() ---

test_that("panel_sem_fe_fit() matches a direct splm::spml(lag=FALSE, spatial.error='b') call", {
  m <- munnell_panel()
  fit <- panel_sem_fe_fit(m$formula, m$data, m$panel, W = m$W, model_type = "within")
  expect_equal(fit$engine, "panel_sem_fe")
  expect_true(is.na(fit$extra$lag_coefficient))

  listw <- spdep::mat2listw(row_standardize_W(m$W), style = "W")
  direct <- splm::spml(
    m$formula, data = plm::pdata.frame(m$data, index = c("state", "year")),
    listw = listw, model = "within", effect = "individual", lag = FALSE, spatial.error = "b"
  )
  expect_equal(unname(coef(fit$fit)), unname(coef(direct)), tolerance = 1e-6)
  expect_equal(fit$extra$error_coefficient, 0.5574013, tolerance = 1e-5)
})

test_that("panel_sac_fe_fit() matches a direct splm::spml(lag=TRUE, spatial.error='b') call and separates lag from error", {
  m <- munnell_panel()
  fit <- panel_sac_fe_fit(m$formula, m$data, m$panel, W = m$W, model_type = "within")
  expect_equal(fit$engine, "panel_sac_fe")

  listw <- spdep::mat2listw(row_standardize_W(m$W), style = "W")
  direct <- splm::spml(
    m$formula, data = plm::pdata.frame(m$data, index = c("state", "year")),
    listw = listw, model = "within", effect = "individual", lag = TRUE, spatial.error = "b"
  )
  expect_equal(unname(coef(fit$fit)), unname(coef(direct)), tolerance = 1e-6)
  # splm nomme "lambda" son coefficient de lag et "rho" son coefficient
  # d'erreur -- l'inverse de la convention LeSage-Pace ; extract_splm_*
  # doit lire le bon nom malgre cette inversion.
  expect_equal(fit$extra$lag_coefficient, 0.08857603, tolerance = 1e-5)
  expect_equal(fit$extra$error_coefficient, 0.4553116, tolerance = 1e-5)
})

# --- build_panel_wx() / panel_sdm_fe_fit(): Durbin built by hand, verified against an independent loop ---

test_that("build_panel_wx() matches a hand-written per-period loop using a different code path", {
  m <- munnell_panel()
  x_formula <- ~ log(pcap) + log(pc) + log(emp) + unemp
  wx <- build_panel_wx(m$data, m$panel, m$W, x_formula)

  # Reimplementation independante : boucle explicite sur les etats plutot que
  # sur les indices de ligne, matrice recalculee directement depuis les
  # colonnes brutes (pas via model.matrix()).
  Wstd <- row_standardize_W(m$W)
  states <- rownames(Wstd)
  manual <- matrix(NA_real_, nrow(m$data), 4)
  vars <- c("pcap", "pc", "emp")
  for (yr in unique(m$data$year)) {
    rows <- which(m$data$year == yr)
    ord <- match(states, m$data$state[rows])
    sub <- m$data[rows[ord], ]
    x_mat <- cbind(log(sub$pcap), log(sub$pc), log(sub$emp), sub$unemp)
    manual[rows[ord], ] <- Wstd %*% x_mat
  }
  expect_equal(unname(as.matrix(wx)), unname(manual), tolerance = 1e-10)
})

test_that("build_panel_wx() rejects an unbalanced panel", {
  dat <- expand.grid(u = c("a", "b", "c"), t = 1:3, stringsAsFactors = FALSE)
  dat$x <- rnorm(nrow(dat))
  dat <- dat[-1, ]
  panel <- spatial_panel_spec(unit = "u", time = "t", balance = "unbalanced")
  W <- matrix(c(0, 1, 1, 1, 0, 1, 1, 1, 0), 3, 3, dimnames = list(c("a", "b", "c"), c("a", "b", "c")))
  expect_error(build_panel_wx(dat, panel, W, ~x), "equilibre")
})

test_that("panel_sdm_fe_fit() fits a lag model on X + WX and matches a manually augmented splm::spml() call", {
  m <- munnell_panel()
  fit <- panel_sdm_fe_fit(m$formula, m$data, m$panel, W = m$W, model_type = "within")
  expect_equal(fit$engine, "panel_sdm_fe")
  expect_length(fit$extra$wx_terms, 4L)

  wx <- build_panel_wx(m$data, m$panel, m$W, ~ log(pcap) + log(pc) + log(emp) + unemp)
  aug_data <- cbind(m$data, wx)
  aug_formula <- stats::as.formula(paste(
    "log(gsp) ~ log(pcap) + log(pc) + log(emp) + unemp +",
    paste(names(wx), collapse = " + ")
  ))
  listw <- spdep::mat2listw(row_standardize_W(m$W), style = "W")
  direct <- splm::spml(
    aug_formula, data = plm::pdata.frame(aug_data, index = c("state", "year")),
    listw = listw, model = "within", effect = "individual", lag = TRUE, spatial.error = "none"
  )
  expect_equal(unname(coef(fit$fit)), unname(coef(direct)), tolerance = 1e-6)
})

# --- panel_sar_sdm_impacts(): LeSage-Pace decomposition, verified against a closed-form identity ---
#
# Pour un W standardise par ligne (somme de chaque ligne = 1), W %*% 1 = 1,
# donc (I - rho*W)^-1 %*% 1 = 1/(1-rho) * 1 et l'effet total se simplifie en
# beta/(1-rho) pour SAR, (beta+theta)/(1-rho) pour SDM -- une identite connue
# (LeSage & Pace 2009), independante du code de panel_sar_sdm_impacts().

test_that("panel_sar_sdm_impacts() total effect matches the closed-form beta/(1-rho) identity for SAR", {
  m <- munnell_panel()
  fit <- panel_sar_fe_fit(m$formula, m$data, m$panel, W = m$W, model_type = "within")
  imp <- panel_sar_sdm_impacts(fit)
  beta <- fit$fit$coefficients[imp$term]
  expected_total <- unname(beta) / (1 - fit$extra$lag_coefficient)
  expect_equal(imp$total, expected_total, tolerance = 1e-8)
  expect_equal(imp$direct + imp$indirect, imp$total, tolerance = 1e-10)
})

test_that("panel_sar_sdm_impacts() total effect matches the closed-form (beta+theta)/(1-rho) identity for SDM", {
  m <- munnell_panel()
  fit <- panel_sdm_fe_fit(m$formula, m$data, m$panel, W = m$W, model_type = "within")
  imp <- panel_sar_sdm_impacts(fit)
  coefs <- fit$fit$coefficients
  wx_names <- unname(fit$extra$wx_term_map[imp$term])
  expected_total <- unname(coefs[imp$term] + coefs[wx_names]) / (1 - fit$extra$lag_coefficient)
  expect_equal(imp$total, expected_total, tolerance = 1e-8)
})

test_that("panel_sar_sdm_impacts() rejects a fit that is not SAR/SDM (e.g. panel_fe)", {
  m <- munnell_panel()
  fit <- panel_fe_fit(m$formula, m$data, m$panel, model_type = "within")
  expect_error(panel_sar_sdm_impacts(fit), "panel_sar_fe_fit|panel_sdm_fe_fit")
})

test_that("available_panel_estimators() lists all five estimators with correct requirements", {
  reg <- available_panel_estimators()
  expect_setequal(reg$estimator, c("panel_fe", "panel_sar_fe", "panel_sem_fe", "panel_sac_fe", "panel_sdm_fe"))
  expect_true(reg$requires_balanced[reg$estimator == "panel_sdm_fe"])
  expect_false(any(reg$requires_balanced[reg$estimator != "panel_sdm_fe"]))
})

test_that("benchmark_spatial_panel() runs all five estimators end to end on the Munnell panel", {
  m <- munnell_panel()
  bench <- benchmark_spatial_panel(
    m$formula, m$data, m$panel, W = m$W,
    estimators = c("panel_fe", "panel_sar_fe", "panel_sem_fe", "panel_sac_fe", "panel_sdm_fe")
  )
  expect_true(all(is.na(bench$results$fit_error)))
  expect_equal(nrow(bench$results), 5L)
  expect_equal(
    bench$results$error_coefficient[bench$results$estimator == "panel_sem_fe"],
    0.5574013,
    tolerance = 1e-5
  )
})

test_that("the panel harness never builds W automatically from coordinates (unit-level W must be supplied explicitly)", {
  # Contrairement au harnais transversal (build_knn_W() sur les coordonnees de
  # chaque ligne), aucune fonction du module panel n'accepte un argument
  # `coords` : W est toujours fourni par l'appelant, jamais reconstruit a
  # partir de geometries repetees dans le temps.
  expect_false("coords" %in% names(formals(panel_fe_fit)))
  expect_false("coords" %in% names(formals(panel_sar_fe_fit)))
  expect_false("coords" %in% names(formals(panel_sem_fe_fit)))
  expect_false("coords" %in% names(formals(panel_sac_fe_fit)))
  expect_false("coords" %in% names(formals(panel_sdm_fe_fit)))
  expect_false("coords" %in% names(formals(build_panel_wx)))
  expect_false("coords" %in% names(formals(benchmark_spatial_panel)))
})

# --- predict_panel_fit(): time_forecast_known_units, verified against each
# fit's own in-sample residual scale before being trusted out-of-sample ---

test_that("predict_panel_fit() in-sample residuals average to ~0 and have sd close to sqrt(sigma2), for all five engines", {
  m <- munnell_panel()
  check_in_sample <- function(fit, sigma2) {
    pred <- predict_panel_fit(fit, m$data)
    resid <- log(m$data$gsp) - pred
    expect_equal(mean(resid), 0, tolerance = 1e-10)
    # Le residu realise n'est pas identique a sqrt(sigma2) (SEM/SAC ont une
    # composante d'erreur spatialement correlee non capturee par la moyenne
    # systematique), mais reste du meme ordre de grandeur -- un ecart de
    # plusieurs multiples signalerait une formule fausse, pas juste du bruit.
    expect_lt(abs(sd(resid) - sqrt(sigma2)) / sqrt(sigma2), 0.3)
  }
  fit_fe <- panel_fe_fit(m$formula, m$data, m$panel)
  pred_fe <- predict_panel_fit(fit_fe, m$data)
  expect_equal(mean(log(m$data$gsp) - pred_fe), 0, tolerance = 1e-10)

  fit_sar <- panel_sar_fe_fit(m$formula, m$data, m$panel, W = m$W)
  check_in_sample(fit_sar, fit_sar$fit$sigma2)
  fit_sem <- panel_sem_fe_fit(m$formula, m$data, m$panel, W = m$W)
  check_in_sample(fit_sem, fit_sem$fit$sigma2)
  fit_sac <- panel_sac_fe_fit(m$formula, m$data, m$panel, W = m$W)
  check_in_sample(fit_sac, fit_sac$fit$sigma2)
  fit_sdm <- panel_sdm_fe_fit(m$formula, m$data, m$panel, W = m$W)
  check_in_sample(fit_sdm, fit_sdm$fit$sigma2)
})

test_that("predict_panel_fit() refuses a genuinely new unit (fixed effect never estimated)", {
  m <- munnell_panel()
  fit <- panel_sar_fe_fit(m$formula, m$data, m$panel, W = m$W)
  newrow <- m$data[1, ]
  newrow$state <- "NEW_STATE_NEVER_SEEN"
  expect_error(predict_panel_fit(fit, newrow), "nouvelles unites")
})

test_that("predict_panel_fit() refuses effect %in% c('time', 'twoways') with a clear message", {
  m <- munnell_panel()
  panel_tw <- spatial_panel_spec(unit = "state", time = "year", effect = "twoways", balance = "balanced")
  fit <- panel_sar_fe_fit(m$formula, m$data, panel_tw, W = m$W)
  expect_error(predict_panel_fit(fit, m$data), "effect")
})

test_that("predict_panel_fit() refuses a SAR/SDM prediction on an incomplete cross-section", {
  m <- munnell_panel()
  fit <- panel_sar_fe_fit(m$formula, m$data, m$panel, W = m$W)
  partial <- m$data[m$data$year == 1986, ][1:10, ]
  expect_error(predict_panel_fit(fit, partial), "coupe complete")
})

test_that("predict_panel_fit() succeeds for SEM on an incomplete cross-section (no simultaneous spatial feedback in the mean)", {
  m <- munnell_panel()
  fit <- panel_sem_fe_fit(m$formula, m$data, m$panel, W = m$W)
  partial <- m$data[m$data$year == 1986, ][1:10, ]
  pred <- predict_panel_fit(fit, partial)
  expect_length(pred, 10L)
  expect_true(all(is.finite(pred)))
})

# --- panel_time_holdout() / panel_rolling_origin(): temporal splitting and anti-leakage ---

test_that("panel_time_holdout() reserves exactly the last h periods, in chronological order", {
  m <- munnell_panel()
  split <- panel_time_holdout(m$data, m$panel, h = 3)
  expect_s3_class(split, "panel_time_split")
  expect_equal(split$train_periods, as.character(1970:1983))
  expect_equal(split$test_periods, as.character(1984:1986))
  expect_equal(nrow(split$train), 48L * 14L)
  expect_equal(nrow(split$test), 48L * 3L)
  expect_true(all(as.integer(as.character(split$train$year)) <= 1983))
  expect_true(all(as.integer(as.character(split$test$year)) >= 1984))
})

test_that("panel_time_holdout() orders periods numerically, not lexicographically (the '9' vs '10' trap)", {
  dat <- expand.grid(u = c("a", "b"), t = 1:11, stringsAsFactors = FALSE)
  dat$y <- rnorm(nrow(dat))
  panel <- spatial_panel_spec(unit = "u", time = "t", balance = "balanced")
  split <- panel_time_holdout(dat, panel, h = 2)
  # Un tri de chaines donnerait test = c("10", "11") en fin lexicographique,
  # mais placerait "9" avant "10" -- un tri numerique correct donne 10 et 11.
  expect_equal(split$test_periods, c("10", "11"))
  expect_equal(split$train_periods, as.character(1:9))
})

test_that("panel_time_holdout() rejects h outside [1, n_periods - 1]", {
  m <- munnell_panel()
  expect_error(panel_time_holdout(m$data, m$panel, h = 0), "entre 1 et")
  expect_error(panel_time_holdout(m$data, m$panel, h = 17), "entre 1 et")
})

test_that("panel_rolling_origin() produces growing training windows advancing by assess+skip", {
  m <- munnell_panel()
  folds <- panel_rolling_origin(m$data, m$panel, initial = 10, assess = 2, skip = 1)
  expect_length(folds, 2L)
  expect_equal(folds[[1]]$train_periods, as.character(1970:1979))
  expect_equal(folds[[1]]$test_periods, as.character(1980:1981))
  expect_equal(folds[[2]]$train_periods, as.character(1970:1982))
  expect_equal(folds[[2]]$test_periods, as.character(1983:1984))
})

test_that("panel_rolling_origin() errors clearly when no fold fits in the available periods", {
  m <- munnell_panel()
  expect_error(panel_rolling_origin(m$data, m$panel, initial = 16, assess = 5), "Aucune fenetre")
})

test_that("panel_time_holdout()/panel_rolling_origin() never leak future periods into training (checked for every unit)", {
  m <- munnell_panel()
  split <- panel_time_holdout(m$data, m$panel, h = 3)
  max_train_by_unit <- tapply(as.integer(as.character(split$train$year)), split$train$state, max)
  min_test_by_unit <- tapply(as.integer(as.character(split$test$year)), split$test$state, min)
  expect_true(all(max_train_by_unit[names(min_test_by_unit)] < min_test_by_unit))

  folds <- panel_rolling_origin(m$data, m$panel, initial = 10, assess = 2, skip = 1)
  for (f in folds) {
    max_train_by_unit <- tapply(as.integer(as.character(f$train$year)), f$train$state, max)
    min_test_by_unit <- tapply(as.integer(as.character(f$test$year)), f$test$state, min)
    expect_true(all(max_train_by_unit[names(min_test_by_unit)] < min_test_by_unit))
  }
})

# --- benchmark_spatial_panel(): time-aware cv_schemes, horizon metrics, error handling ---

test_that("benchmark_spatial_panel(cv_scheme='panel_time_holdout') computes per-horizon RMSE/MAE matching a manual calculation", {
  m <- munnell_panel()
  bench <- benchmark_spatial_panel(
    m$formula, m$data, m$panel, W = m$W,
    estimators = "panel_fe", cv_scheme = "panel_time_holdout", h = 3
  )
  expect_equal(bench$results$horizon, 1:3)
  expect_equal(bench$results$period, as.character(1984:1986))
  expect_true(all(is.na(bench$results$fold)))
  expect_true(all(is.na(bench$results$fit_error)))

  # Recalcul manuel independant, sans passer par predict_panel_fit() ni
  # panel_metrics_by_horizon() : refit direct sur le train, predict.plm()
  # direct sur le test, RMSE/MAE calcules a la main.
  split <- panel_time_holdout(m$data, m$panel, h = 3)
  fit_direct <- plm::plm(m$formula, data = plm::pdata.frame(split$train, index = c("state", "year")), model = "within", effect = "individual")
  pred_direct <- as.numeric(predict(fit_direct, newdata = plm::pdata.frame(split$test, index = c("state", "year"))))
  truth <- log(split$test$gsp)
  for (h in 1:3) {
    idx <- which(as.character(split$test$year) == as.character(1983 + h))
    expect_equal(bench$results$rmse[h], sqrt(mean((truth[idx] - pred_direct[idx])^2)), tolerance = 1e-8)
    expect_equal(bench$results$mae[h], mean(abs(truth[idx] - pred_direct[idx])), tolerance = 1e-8)
  }
})

test_that("benchmark_spatial_panel(cv_scheme='panel_rolling_origin') produces one row per fold/estimator/horizon", {
  m <- munnell_panel()
  bench <- benchmark_spatial_panel(
    m$formula, m$data, m$panel, W = m$W,
    estimators = c("panel_fe", "panel_sar_fe"), cv_scheme = "panel_rolling_origin",
    initial = 10, assess = 2, skip = 1
  )
  expect_equal(nrow(bench$results), 2L * 2L * 2L) # 2 folds x 2 estimators x 2 horizons
  expect_setequal(bench$results$fold, 1:2)
  expect_true(all(is.na(bench$results$fit_error)))
  expect_true(all(is.finite(bench$results$rmse)))
})

test_that("benchmark_spatial_panel() requires h for panel_time_holdout and initial/assess for panel_rolling_origin", {
  m <- munnell_panel()
  expect_error(
    benchmark_spatial_panel(m$formula, m$data, m$panel, W = m$W, estimators = "panel_fe", cv_scheme = "panel_time_holdout"),
    "h"
  )
  expect_error(
    benchmark_spatial_panel(m$formula, m$data, m$panel, W = m$W, estimators = "panel_fe", cv_scheme = "panel_rolling_origin"),
    "initial"
  )
})

test_that("benchmark_spatial_panel() reports a fit_error row (not a crash) when prediction target is unsupported", {
  m <- munnell_panel()
  panel_tw <- spatial_panel_spec(unit = "state", time = "year", effect = "twoways", balance = "balanced")
  bench <- benchmark_spatial_panel(
    m$formula, m$data, panel_tw, W = m$W,
    estimators = "panel_sar_fe", cv_scheme = "panel_time_holdout", h = 3
  )
  expect_equal(nrow(bench$results), 1L)
  expect_false(is.na(bench$results$fit_error))
  expect_true(is.na(bench$results$rmse))
})
