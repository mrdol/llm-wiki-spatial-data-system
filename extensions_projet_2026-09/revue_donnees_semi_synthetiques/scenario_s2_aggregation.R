# S2 — aggregation of a nonlinear relation on documented spatial partitions.
# Run from repository root:
# Rscript extensions_projet_2026-09/revue_donnees_semi_synthetiques/scenario_s2_aggregation.R 40
source("extensions_projet_2026-09/revue_donnees_semi_synthetiques/priorites_plasmode.R")

recursive_spatial_partition <- function(xy, n_zones) {
  n <- nrow(xy)
  stopifnot(n >= 2L, n_zones >= 2L, n_zones <= n)
  groups <- list(seq_len(n))
  while (length(groups) < n_zones) {
    eligible <- which(lengths(groups) >= 2L)
    score <- vapply(eligible, function(i) {
      g <- groups[[i]]
      max(diff(range(xy[g, 1])), diff(range(xy[g, 2]))) * length(g)
    }, numeric(1))
    chosen <- eligible[which.max(score)]
    g <- groups[[chosen]]
    spans <- apply(xy[g, , drop=FALSE], 2, function(v) diff(range(v)))
    axis <- which.max(spans)
    ordered <- g[order(xy[g, axis], xy[g, 3L-axis])]
    cut <- floor(length(ordered) / 2)
    groups[[chosen]] <- ordered[seq_len(cut)]
    groups <- append(groups, list(ordered[(cut+1L):length(ordered)]), after=chosen)
  }
  group <- integer(n)
  for (i in seq_along(groups)) group[groups[[i]]] <- i
  stopifnot(all(group > 0L), identical(sort(unlist(groups)), seq_len(n)))
  group
}

aggregation_operator <- function(group) {
  stopifnot(all(group > 0L), !anyNA(group))
  A <- matrix(0, max(group), length(group))
  for (g in seq_len(nrow(A))) A[g, group == g] <- 1 / sum(group == g)
  stopifnot(max(abs(rowSums(A)-1)) < 1e-12,
            all(colSums(A > 0) == 1L))
  A
}

zone_folds <- function(xy, k=3L) {
  stopifnot(nrow(xy) >= 2L*k)
  ordering <- order(xy[, 1], xy[, 2])
  fold <- integer(nrow(xy))
  fold[ordering] <- pmin(k, ceiling(seq_along(ordering) / length(ordering) * k))
  stopifnot(all(tabulate(fold, nbins=k) >= 2L))
  fold
}

make_s2_design <- function(cal, means, target_group_size) {
  # The current GAM specification needs enough whole zones in each training split.
  # Twenty-four zones leave at least 16 training observations in the 3-fold design.
  n_zones <- max(24L, round(nrow(cal$data) / target_group_size))
  group <- recursive_spatial_partition(cal$xy, n_zones)
  A <- aggregation_operator(group)
  fine_x <- as.matrix(cal$data[, c("x1", "x2", "z")])
  coarse_x <- A %*% fine_x
  coarse_xy <- A %*% cal$xy
  coarse <- as.data.frame(coarse_x)
  names(coarse) <- c("x1", "x2", "z")
  centers <- colMeans(coarse_xy)
  scales <- apply(coarse_xy, 2, sd)
  coarse$sx <- (coarse_xy[, 1]-centers[1])/scales[1]
  coarse$sy <- (coarse_xy[, 2]-centers[2])/scales[2]
  coarse$y <- 0
  truth <- as.numeric(A %*% means)
  folds <- zone_folds(coarse_xy)
  sizes <- tabulate(group, nbins=nrow(A))
  list(A=A, group=group, data=coarse, xy=coarse_xy, fold=folds,
       truth=truth, sizes=sizes,
       internal_variance_x1=as.numeric(A %*% fine_x[,1]^2)-coarse$x1^2,
       internal_variance_x2=as.numeric(A %*% fine_x[,2]^2)-coarse$x2^2,
       internal_covariance_x1_x2=as.numeric(A %*% (fine_x[,1]*fine_x[,2]))-coarse$x1*coarse$x2)
}

polynomial_support_identity <- function(cal, design) {
  naive <- as.numeric(predict(cal$generator, design$data))
  b <- coef(cal$generator)
  correction <- b[["I(x1^2)"]]*design$internal_variance_x1 +
    b[["I(x2^2)"]]*design$internal_variance_x2 +
    b[["x1:x2"]]*design$internal_covariance_x1_x2
  error <- design$truth-naive-correction
  stopifnot(max(abs(error)) < 1e-10)
  list(naive=naive, correction=correction, max_error=max(abs(error)))
}

s2_predict <- function(method, train, test, seed) {
  predict_competitor(method, train, test, seed)
}

run_s2 <- function(repetitions=40L,
                   output=file.path(pilot_dir, "scenario_s2_output_2026-09-14")) {
  stopifnot(repetitions >= 2L, !dir.exists(output))
  dir.create(output, recursive=TRUE)
  datasets <- c("georgia", "meuse")
  generators <- c("polynomial", "forest")
  methods <- c("linear", "polynomial", "gam_covariates", "gam_spatial", "forest")
  granularities <- c(2L, 4L, 8L)
  rows <- diagnostics <- partitions <- list()
  for (id in datasets) {
    cal <- calibrate_source(load_source(id))
    fitted_generators <- build_generators(cal)
    for (generator in generators) for (target_size in granularities) {
      design <- make_s2_design(cal, fitted_generators$means[[generator]], target_size)
      key <- paste(id, generator, target_size, sep="/")
      if (generator == "polynomial") {
        identity <- polynomial_support_identity(cal, design)
        naive <- identity$naive
        identity_error <- identity$max_error
      } else {
        naive <- as.numeric(predict(fitted_generators$forest, design$data)$predictions)
        identity_error <- NA_real_
      }
      delta <- design$truth-naive
      sigma <- sqrt(var(fitted_generators$means[[generator]])/3)
      noise_covariance <- sigma^2 * tcrossprod(design$A)
      offdiag <- noise_covariance; diag(offdiag) <- 0
      stopifnot(max(abs(offdiag)) < 1e-14,
                all(vapply(seq_len(nrow(design$A)), function(z)
                  length(unique(design$fold[z])) == 1L, logical(1))))
      diagnostics[[key]] <- data.frame(dataset=id, generator=generator,
        target_group_size=target_size, n_zones=nrow(design$A),
        min_zone_size=min(design$sizes), max_zone_size=max(design$sizes),
        zone_size_cv=sd(design$sizes)/mean(design$sizes),
        delta_rmse=sqrt(mean(delta^2)), delta_nmse=mean(delta^2)/var(design$truth),
        delta_moran=moran_descriptive(delta, make_weights(design$xy)),
        cor_abs_delta_heterogeneity=cor(abs(delta), design$internal_variance_x1+
          design$internal_variance_x2+abs(design$internal_covariance_x1_x2)),
        polynomial_identity_max_error=identity_error,
        noise_max_offdiagonal=max(abs(offdiag)))
      partitions[[key]] <- design[c("A", "group", "xy", "fold", "sizes", "truth",
                                    "internal_variance_x1", "internal_variance_x2",
                                    "internal_covariance_x1_x2")]
      for (replication in seq_len(repetitions)) {
        seed <- 914000L + match(id, datasets)*10000L + match(generator, generators)*1000L +
          target_size*100L + replication
        set.seed(seed)
        fine_y <- fitted_generators$means[[generator]] + sigma*rnorm(nrow(cal$data))
        supplied <- design$data
        supplied$y <- as.numeric(design$A %*% fine_y)
        for (method in methods) {
          predicted <- rep(NA_real_, nrow(supplied)); errors <- warnings_seen <- character()
          for (fold in 1:3) {
            train <- supplied[design$fold != fold, , drop=FALSE]
            test <- supplied[design$fold == fold, , drop=FALSE]
            prediction_seed <- 914300L + fold
            p <- withCallingHandlers(tryCatch(s2_predict(method, train, test, prediction_seed),
              error=function(e) {errors <<- c(errors, conditionMessage(e)); rep(NA_real_, nrow(test))}),
              warning=function(w) {warnings_seen <<- c(warnings_seen, conditionMessage(w));
                invokeRestart("muffleWarning")})
            if (replication == 1L && !anyNA(p)) {
              poisoned <- test; poisoned$y <- 1e12
              stopifnot(identical(p, s2_predict(method, train, poisoned, prediction_seed)))
            }
            predicted[design$fold == fold] <- p
          }
          failed <- any(!is.finite(predicted))
          rows[[length(rows)+1L]] <- data.frame(dataset=id, generator=generator,
            target_group_size=target_size, n_zones=nrow(design$A), replication=replication,
            seed=seed, method=method, failed=failed,
            nmse_mean=if (failed) NA_real_ else mean((predicted-design$truth)^2)/var(design$truth),
            mse_observed=if (failed) NA_real_ else mean((predicted-supplied$y)^2),
            error=paste(unique(errors), collapse=" | "),
            warning=paste(unique(warnings_seen), collapse=" | "))
        }
      }
      message(key, ": ", repetitions, " replications complete")
    }
  }
  raw <- do.call(rbind, rows)
  diagnostic_table <- do.call(rbind, diagnostics)
  groups <- split(raw, interaction(raw$dataset, raw$generator, raw$target_group_size,
                                   raw$method, drop=TRUE))
  summary <- do.call(rbind, lapply(groups, function(d) {
    ok <- !d$failed
    data.frame(dataset=d$dataset[1], generator=d$generator[1],
      target_group_size=d$target_group_size[1], n_zones=d$n_zones[1], method=d$method[1],
      completed=sum(ok), failed=sum(!ok),
      nmse_mean=if (any(ok)) mean(d$nmse_mean[ok]) else NA_real_,
      mcse=if (sum(ok)>1L) sd(d$nmse_mean[ok])/sqrt(sum(ok)) else NA_real_)
  }))
  config <- list(schema="plasmode_s2_v1", date="2026-09-14", repetitions=repetitions,
    datasets=datasets, generators=generators, methods=methods,
    target_group_sizes=granularities, minimum_zones=24L,
    partition="recursive median bisection along the largest coordinate span; each leaf is an axis-aligned contiguous spatial cell",
    folds="three east-west bands of whole zones; no zone crosses a fold; no buffer in S2",
    target="zonal latent mean A m(X)", observed_response="A(m(X)+iid Gaussian innovation)",
    naive_reconstruction="m(A X)", snr_fine=3,
    note="Meuse is scored on the zonal mean of log(zinc); it is not interpreted as log of mean zinc")
  result <- list(config=config, diagnostics=diagnostic_table, summary=summary, raw=raw)
  saveRDS(list(results=result, partitions=partitions), file.path(output, "results.rds"))
  jsonlite::write_json(result, file.path(output, "results.json"), pretty=TRUE,
                       auto_unbox=TRUE, digits=12, na="null")
  writeLines(capture.output(sessionInfo()), file.path(output, "sessionInfo.txt"))
  if (any(raw$failed)) stop("S2 contains failed fits; inspect results.rds")
  invisible(result)
}

if (sys.nframe() == 0L) {
  args <- commandArgs(trailingOnly=TRUE)
  repetitions <- if (length(args)) as.integer(args[1]) else 40L
  output <- if (length(args)>1L) args[2] else file.path(pilot_dir, "scenario_s2_output_2026-09-14")
  run_s2(repetitions, output)
}
