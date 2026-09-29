source("extensions_projet_2026-09/revue_donnees_semi_synthetiques/scenario_s1_overlapping_supports.R")

for(id in c("georgia","meuse")) {
  cal <- calibrate_source(load_source(id)); fitted <- build_generators(cal)
  identity <- make_s1_design(cal,fitted$means$polynomial,0L,"identity")
  stopifnot(identical(identity$H,diag(nrow(cal$data))),
            max(abs(identity$truth-fitted$means$polynomial))<1e-12,
            identity$overlap$cross_fold_pairs_sharing_sources==0L)
  for(spec in list(c(2L,"uniform"),c(4L,"uniform"),c(2L,"distance"),c(4L,"distance"))) {
    design <- make_s1_design(cal,fitted$means$polynomial,as.integer(spec[[1]]),spec[[2]])
    stopifnot(max(abs(rowSums(design$H)-1))<1e-12,all(design$H>=0),
              all(design$leakage==0L),design$overlap$cross_fold_pairs_sharing_sources==0L,
              design$overlap$fraction_overlapping_within>0,
              all(lengths(lapply(design$splits,`[[`,"train"))>=20L))
    sigma <- sqrt(var(fitted$means$polynomial)/3)
    set.seed(44); draws <- matrix(rnorm(nrow(design$H)*10000L),nrow(design$H),10000L)
    observed <- sigma*design$H%*%draws
    empirical <- tcrossprod(sweep(observed,1,rowMeans(observed),"-"))/(ncol(observed)-1L)
    expected <- sigma^2*tcrossprod(design$H)
    stopifnot(norm(empirical-expected,"F")/norm(expected,"F") < .15)
  }
}

temporary_output <- tempfile("s1-test-"); on.exit(unlink(temporary_output,recursive=TRUE),add=TRUE)
result <- run_s1(2L,temporary_output)
stopifnot(nrow(result$diagnostics)==20L,nrow(result$raw)==200L,!any(result$raw$failed),
          all(result$summary$completed==2L),
          all(result$diagnostics$cross_fold_pairs_sharing_sources==0L),
          file.exists(file.path(temporary_output,"results.rds")))
cat("PASS: S1 geographic supports, covariance, buffers, independent-support folds and no test-Y leakage.\n")
