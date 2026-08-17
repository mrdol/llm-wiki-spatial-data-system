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

test_that("le registre distingue benchmark_task_id (par fiche) de source_dataset_id (source independante)", {
  datasets <- available_benchmark_datasets()
  expect_true(all(c(
    "dataset_id", "parent_dataset", "source_dataset_id", "benchmark_task_id",
    "bundled", "storage"
  ) %in% names(datasets)))

  korea <- datasets[grepl("korea_hedonic_housing", datasets$dataset_id), , drop = FALSE]
  skip_if(nrow(korea) == 0L, "korea_hedonic_housing family not present in this registry snapshot")

  # 32 temporal splits + 1 parent = 33 distinct benchmark tasks...
  expect_equal(length(unique(korea$benchmark_task_id)), nrow(korea))
  # ...but exactly ONE independent source: splitting a dataset into many
  # yearly benchmark tasks must not let it silently count as many sources.
  expect_equal(length(unique(korea$source_dataset_id)), 1L)
  expect_equal(unique(korea$source_dataset_id), "paper_korea_hedonic_housing")

  parent_row <- korea[korea$dataset_id == "paper_korea_hedonic_housing", , drop = FALSE]
  expect_true(is.na(parent_row$parent_dataset))
  split_rows <- korea[korea$dataset_id != "paper_korea_hedonic_housing", , drop = FALSE]
  expect_true(all(split_rows$parent_dataset == "paper_korea_hedonic_housing"))

  # bundled/storage: only the 7 legacy native-data() datasets are "bundled".
  bundled <- datasets[isTRUE(datasets$bundled) | datasets$bundled %in% TRUE, , drop = FALSE]
  expect_setequal(bundled$dataset, c("georgia", "columbus_crime", "london_hp", "boston_housing", "dub_voter", "ewhp", "lasrosas"))
  expect_true(all(bundled$storage == "bundled"))
  expect_true(all(korea$storage == "repo_only")) # none of the korea splits are bundled
})

test_that("le registre expose la taxonomie family/role/reference_estimator/variant_family", {
  estimators <- available_benchmark_estimators(include_installed = FALSE)
  expect_true(all(c("family", "role", "reference_estimator", "variant_family") %in% names(estimators)))
  expect_true(all(estimators$role %in% c("reference", "variant", "alias")))

  by_name <- function(id) estimators[estimators$estimator == id, , drop = FALSE]

  # References have no reference_estimator of their own.
  expect_equal(by_name("sar_lag")$role, "reference")
  expect_true(is.na(by_name("sar_lag")$reference_estimator))
  expect_equal(by_name("sem_error")$role, "reference")

  # SAR/SEM boosting variants point back to their spatialreg reference.
  expect_equal(by_name("spboost_bspa_sar_ml")$reference_estimator, "sar_lag")
  expect_equal(by_name("spboost_bspa_sar_cfe")$reference_estimator, "sar_lag")
  expect_equal(by_name("spboost_bspa_sem_ml")$reference_estimator, "sem_error")
  expect_equal(by_name("spboost_bspa_sem_cfe")$reference_estimator, "sem_error")
  expect_equal(by_name("mgwrsar_sar")$reference_estimator, "sar_lag")

  # spboost is a historical alias of spboost_bspa_sar_ml, not a distinct variant.
  expect_equal(by_name("spboost")$role, "alias")
  expect_equal(by_name("spboost")$reference_estimator, "spboost_bspa_sar_ml")

  # Group 1 (validated with the user): spatialml_grf/spatialrf/rfgls are
  # three structurally different spatial-RF approaches, each its own
  # standalone reference family -- not variants of random_forest or of
  # each other.
  for (id in c("spatialml_grf", "spatialrf", "rfgls")) {
    row <- by_name(id)
    expect_equal(row$role, "reference")
    expect_true(is.na(row$reference_estimator))
    expect_equal(row$family, id) # each is its own family
  }

  # Group 2 (validated with the user): mgwrsar_mgwrsar/MGWRSAR_0_kc_kv/
  # MGWRSAR_1_kc_kv form their own "mgwrsar_hybrid" family (GWR-style local
  # coefficients + SAR-style autocorrelation), not folded into GWR or SAR.
  expect_equal(by_name("mgwrsar_mgwrsar")$family, "mgwrsar_hybrid")
  expect_equal(by_name("mgwrsar_mgwrsar")$role, "reference")
  expect_equal(by_name("MGWRSAR_0_kc_kv")$reference_estimator, "mgwrsar_mgwrsar")
  expect_equal(by_name("MGWRSAR_1_kc_kv")$reference_estimator, "mgwrsar_mgwrsar")
  expect_equal(by_name("mgwrsar_gwr")$family, "GWR")
  expect_equal(by_name("mgwrsar_mgwr")$reference_estimator, "mgwrsar_gwr")

  # Every estimator in the built-in registry has a taxonomy entry -- none
  # silently fell through to NA family/role.
  expect_true(all(!is.na(estimators$family)))
  expect_true(all(!is.na(estimators$role)))
})

test_that("register_spatial_estimator() carries role/variant_family without erasing them for built-ins", {
  on.exit(unregister_spatial_estimator("taxonomy_test_variant"), add = TRUE)
  register_spatial_estimator(
    id = "taxonomy_test_variant",
    fit = function(formula, data, coords) stats::lm(formula, data = data),
    predict = function(fit, new_data) stats::predict(fit, newdata = new_data),
    family = "SAR",
    reference_estimator = "sar_lag",
    variant_family = "custom",
    requires_coords = FALSE
  )

  estimators <- available_benchmark_estimators(include_installed = FALSE)
  custom_row <- estimators[estimators$estimator == "taxonomy_test_variant", , drop = FALSE]
  expect_equal(custom_row$role, "variant")
  expect_equal(custom_row$reference_estimator, "sar_lag")
  expect_equal(custom_row$variant_family, "custom")

  # Registering a custom estimator must not wipe out the built-ins' own
  # role/variant_family via the intersect()-based column merge.
  sar_lag_row <- estimators[estimators$estimator == "sar_lag", , drop = FALSE]
  expect_equal(sar_lag_row$role, "reference")
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
