source("extensions_projet_2026-09/revue_donnees_semi_synthetiques/scenario_s2_aggregation.R")

for (id in c("georgia", "meuse")) {
  cal <- calibrate_source(load_source(id))
  generators <- build_generators(cal)
  previous_zones <- Inf
  for (target_size in c(2L, 4L, 8L)) {
    design <- make_s2_design(cal, generators$means$polynomial, target_size)
    stopifnot(nrow(design$A) < previous_zones,
              max(abs(rowSums(design$A)-1)) < 1e-12,
              all(colSums(design$A > 0) == 1L),
              identical(sort(unique(design$group)), seq_len(nrow(design$A))),
              all(tabulate(design$fold, nbins=3L) >= 2L),
              polynomial_support_identity(cal, design)$max_error < 1e-10)
    previous_zones <- nrow(design$A)
    sigma <- sqrt(var(generators$means$polynomial)/3)
    covariance <- sigma^2*tcrossprod(design$A)
    stopifnot(max(abs(covariance[row(covariance) != col(covariance)])) < 1e-14)
  }
}

temporary_output <- tempfile("s2-test-")
on.exit(unlink(temporary_output, recursive=TRUE), add=TRUE)
result <- run_s2(2L, temporary_output)
stopifnot(nrow(result$diagnostics) == 12L,
          nrow(result$raw) == 120L,
          !any(result$raw$failed),
          all(result$summary$completed == 2L),
          all(result$diagnostics$polynomial_identity_max_error[
            result$diagnostics$generator == "polynomial"] < 1e-10),
          all(result$diagnostics$noise_max_offdiagonal < 1e-14),
          file.exists(file.path(temporary_output, "results.rds")),
          file.exists(file.path(temporary_output, "results.json")))

cat("PASS: S2 spatial partitions, aggregation identities, whole-zone folds, noise covariance and no test-Y leakage.\n")
