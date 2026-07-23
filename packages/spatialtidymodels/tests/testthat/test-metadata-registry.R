test_that("les JSON de metadonnees sont installes avec le package", {
  datasets_json <- system.file("metadata", "datasets.json", package = "spatialtidymodels")
  estimators_json <- system.file("metadata", "estimators.json", package = "spatialtidymodels")

  expect_true(nzchar(datasets_json))
  expect_true(file.exists(datasets_json))
  expect_true(nzchar(estimators_json))
  expect_true(file.exists(estimators_json))
})

test_that("le registre JSON conserve les datasets benchmark actuels", {
  datasets <- available_benchmark_datasets()

  expect_true(all(c(
    "georgia", "columbus_crime", "london_hp", "boston_housing",
    "dub_voter", "ewhp", "lasrosas"
  ) %in% datasets$dataset))
  expect_true(all(c(
    "formula", "coords", "coords_crs", "source_ref",
    "topic", "observation_unit", "source_description"
  ) %in% names(datasets)))
  expect_true(all(nzchar(datasets$topic)))
})

test_that("le registre JSON conserve les estimateurs benchmark actuels", {
  estimators <- available_benchmark_estimators(include_installed = FALSE)

  expect_true(all(c(
    "ols", "gam_spatial", "gamboost", "random_forest", "xgboost",
    "sar_lag", "sem_error", "sdm_mixed",
    "spboost_bspa_sar_ml", "spboost_bspa_sar_cfe",
    "spboost_bspa_sem_ml", "spboost_bspa_sem_cfe",
    "mgwrsar_gwr", "MGWRSAR_0_kc_kv", "MGWRSAR_1_kc_kv",
    "spmoran_esf", "spmoran_resf"
  ) %in% estimators$estimator))
  expect_true(all(c("backend", "spatial_args", "tunable_parameters") %in% names(estimators)))
})

test_that("les metadonnees relient datasets et estimateurs eligibles", {
  columbus_estimators <- eligible_estimators_for_dataset(
    "columbus_crime",
    include_installed = FALSE
  )
  gwr_datasets <- eligible_datasets_for_estimator("mgwrsar_gwr")
  columbus_all <- eligible_estimators_for_dataset(
    "columbus_crime",
    include_installed = FALSE,
    evidence = "all"
  )

  expect_equal(columbus_estimators$estimator, c("ols", "sar_lag", "sem_error", "sdm_mixed"))
  expect_equal(unique(columbus_estimators$eligibility_basis), "scientific_evidence")
  expect_match(unique(columbus_estimators$eligibility_source_ref), "Anselin")
  expect_true(all(c("pages", "pdf_pages") %in% names(columbus_estimators)))
  expect_true(all(c("spmoran_esf", "spmoran_resf") %in% columbus_all$estimator))
  expect_equal(
    columbus_all$eligibility_basis[columbus_all$estimator == "spmoran_esf"],
    "benchmark_use"
  )
  expect_true("london_hp" %in% gwr_datasets$dataset)
  expect_true(all(c("eligible_estimators", "eligibility_basis", "eligibility_source_ref") %in% names(gwr_datasets)))
})

test_that("les relations dataset-estimateur viennent des fiches Markdown exportees", {
  datasets_json <- system.file("metadata", "datasets.json", package = "spatialtidymodels")
  payload <- jsonlite::fromJSON(datasets_json, simplifyDataFrame = FALSE)
  columbus <- Filter(function(x) identical(x$dataset, "columbus_crime"), payload$records)[[1]]

  expect_true(length(columbus$estimator_evidence) >= 6)
  expect_true(all(c("ols", "sar_lag", "sem_error", "sdm_mixed") %in% columbus$eligible_estimators))
  expect_match(columbus$eligibility_notes, "fiche Markdown")
})

test_that("explain_dataset et explain_estimator exposent la couche de guidage", {
  dataset_info <- explain_dataset("columbus_crime", evidence = "all")
  estimator_info <- explain_estimator("sar_lag")

  expect_s3_class(dataset_info, "spatial_dataset_explanation")
  expect_s3_class(estimator_info, "spatial_estimator_explanation")
  expect_true(all(c("topic", "observation_unit", "formula") %in% names(dataset_info$summary)))
  expect_true("sar_lag" %in% dataset_info$eligible_estimators$estimator)
  expect_true("columbus_crime" %in% estimator_info$eligible_datasets$dataset)
})
