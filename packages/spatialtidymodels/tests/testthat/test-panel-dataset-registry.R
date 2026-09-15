# Tests for the spatial panel dataset registry (J5 of
# wiki/analyses/plan_implementation_panel_spatial_2026-09-09.md):
# a single traceable call from a dataset id (fiche) to a
# spatial_panel_benchmark result, mirroring benchmark_spatial_dataset() for
# the cross-sectional registry -- and the guard preventing either registry
# from routing into the other's harness.
#
# paper_li_energy_price_co2_china is the only spatial-panel dataset currently
# registered (see data/manifests/datasets/review_2026-09-09/spatial_panel_inventory.json);
# uses the real repo-checked-out RDS/W files, same convention as the existing
# lasrosas test in test-metadata-registry.R.

test_that("reject_if_spatial_panel() errors only for data_structure == 'spatial_panel'", {
  panel_spec <- data.frame(data_structure = "spatial_panel", stringsAsFactors = FALSE)
  cross_spec <- data.frame(data_structure = "cross_sectional", stringsAsFactors = FALSE)
  na_spec <- data.frame(data_structure = NA_character_, stringsAsFactors = FALSE)

  expect_error(reject_if_spatial_panel(panel_spec, "some_dataset"), "benchmark_spatial_panel_dataset")
  expect_silent(reject_if_spatial_panel(cross_spec, "some_dataset"))
  expect_silent(reject_if_spatial_panel(na_spec, "some_dataset"))
})

test_that("available_panel_datasets() lists paper_li_energy_price_co2_china with the expected panel fields", {
  registry <- available_panel_datasets()
  expect_true("paper_li_energy_price_co2_china" %in% registry$dataset)
  row <- registry[registry$dataset == "paper_li_energy_price_co2_china", ]
  expect_equal(row$panel_unit, "province_name")
  expect_equal(row$panel_time, "year")
  expect_equal(row$panel_effect, "individual")
  expect_equal(row$panel_balance, "balanced")
  expect_equal(row$n_units, 30L)
  expect_equal(row$n_periods, 15L)
  expect_match(row$w_file, "paper_li_energy_price_co2_china_W\\.rds$")
  # Conditionnel : ne doit PAS apparaitre pretendre a une promotion automatique.
  expect_equal(row$package_include, "no")
  expect_false(row$benchmark_ready)
})

test_that("available_panel_datasets() never lists a cross-sectional (non-panel) dataset", {
  registry <- available_panel_datasets()
  expect_false("paper_swiss_heat_exposure" %in% registry$dataset)
})

test_that("get_panel_dataset_spec() errors clearly for an unregistered dataset", {
  expect_error(get_panel_dataset_spec("jeu_totalement_inexistant"), "inconnu")
})

test_that("load_benchmark_panel_dataset() loads real data, spec, and W consistently", {
  loaded <- load_benchmark_panel_dataset("paper_li_energy_price_co2_china")
  expect_s3_class(loaded$panel, "spatial_panel_spec")
  expect_false(inherits(loaded$data, "sf"))
  expect_equal(nrow(loaded$data), 450L)
  expect_true(all(c("province_name", "year", "CO2", "EP") %in% names(loaded$data)))
  expect_equal(dim(loaded$W), c(30L, 30L))
  expect_equal(deparse(loaded$formula[[2]]), "log(CO2)")
})

test_that("load_benchmark_panel_dataset() W row-sums to 1 for every province (already row-standardized on disk)", {
  loaded <- load_benchmark_panel_dataset("paper_li_energy_price_co2_china")
  expect_equal(unname(rowSums(loaded$W)), rep(1, 30L))
})

test_that("benchmark_spatial_panel_dataset() runs end to end on the real dataset with no fit_error", {
  bench <- benchmark_spatial_panel_dataset(
    "paper_li_energy_price_co2_china",
    estimators = c("panel_fe", "panel_sar_fe", "panel_sem_fe", "panel_sac_fe")
  )
  expect_s3_class(bench, "spatial_panel_benchmark")
  expect_equal(nrow(bench$results), 4L)
  expect_true(all(is.na(bench$results$fit_error)))
  expect_equal(bench$results$n_units, rep(30L, 4L))
  # log(EP) negatif et coherent sur les 4 routes avec la W retenue (session du
  # 2026-09-10, rattachement k-NN de Hainan) -- verifie independamment dans
  # la fiche contre les elasticites publiees par Li, Fang et He (2020).
  ep_signs <- vapply(bench$fits, function(f) sign(f$fit$coefficients[["log(EP)"]]), numeric(1))
  expect_true(all(ep_signs < 0))
})

test_that("benchmark_spatial_dataset() (cross-sectional) refuses paper_li_energy_price_co2_china", {
  # Aujourd'hui deja exclu du registre transversal (benchmark_ready == FALSE),
  # donc ce test echoue avec 'Unknown dataset' plutot que le message
  # spatial_panel explicite -- les deux sont un refus correct ; seul le garde-
  # fou direct (reject_if_spatial_panel(), teste plus haut) verifie le message
  # specifique, au cas ou ce jeu deviendrait un jour benchmark_ready.
  expect_error(benchmark_spatial_dataset("paper_li_energy_price_co2_china"))
})
