# Plasmode pilot: empirical generator, fixed real X/sites, controlled omissions.
# From repository root:
# Rscript extensions_projet_2026-09/revue_donnees_semi_synthetiques/plasmode_pilot.R 20
# Outputs are isolated from the package registry and original dataset artifacts.
suppressPackageStartupMessages({library(sf); library(mgcv); library(jsonlite)})

pilot_dir <- "extensions_projet_2026-09/revue_donnees_semi_synthetiques"
full_formula <- y ~ x1 + x2 + z + I(x1^2) + I(x2^2) + x1:x2

make_weights <- function(xy, k=4L) {
  stopifnot(nrow(xy) > k, all(is.finite(xy)), !anyDuplicated(as.data.frame(xy)))
  distances <- as.matrix(dist(xy)); diag(distances) <- Inf
  adjacency <- matrix(0, nrow(xy), nrow(xy))
  for (i in seq_len(nrow(xy))) adjacency[i, order(distances[i, ])[seq_len(k)]] <- 1
  adjacency <- 1 * ((adjacency + t(adjacency)) > 0)
  adjacency / rowSums(adjacency)
}

moran_descriptive <- function(v, W) {
  centered <- v - mean(v)
  denominator <- sum(centered^2)
  if (denominator < 1e-14) return(NA_real_)
  as.numeric(length(v) / sum(W) * crossprod(centered, W %*% centered) / denominator)
}

load_source <- function(id) {
  path <- switch(id,
    georgia="data/final_datasets/sf/Python_libpysal_georgia.rds",
    meuse="data/final_datasets/sf/R_sp_meuse_meuse.rds")
  object <- readRDS(path)
  if (id == "georgia") {
    # Do not use the converted sf geometry: its range is inconsistent with Georgia.
    stopifnot(all(object$Latitude > 30 & object$Latitude < 36),
              all(object$Longitud > -86 & object$Longitud < -80))
    native <- new.env(parent=baseenv())
    utils::data("georgia", package="spgwr", envir=native)
    native <- native$gSRDF@data
    stopifnot(!anyDuplicated(object$AreaKey), !anyDuplicated(native$AreaKey))
    idx <- match(object$AreaKey, native$AreaKey)
    stopifnot(!anyNA(idx))
    for (name in c("Latitude", "Longitud", "PctBach", "PctRural", "PctFB", "PctEld")) {
      stopifnot(isTRUE(all.equal(object[[name]], native[[name]][idx], check.attributes=FALSE)))
    }
    geo <- st_as_sf(data.frame(lon=object$Longitud, lat=object$Latitude), coords=c("lon","lat"), crs=4326)
    xy <- st_coordinates(st_transform(geo, 5070))
    data <- data.frame(y=object$PctBach, x1=object$PctRural, x2=object$PctFB, z=object$PctEld)
    mapping <- c(y="PctBach", x1="PctRural", x2="PctFB", z="PctEld")
    support <- "Longitud/Latitude matched by AreaKey to installed spgwr::gSRDF; EPSG:4326 -> EPSG:5070 metres; converted geometry deliberately not used."
  } else {
    stopifnot(all(object$zinc > 0))
    xy <- as.matrix(as.data.frame(object)[,c("x","y")])
    data <- data.frame(y=log(object$zinc), x1=object$dist, x2=object$om, z=object$elev)
    mapping <- c(y="log(zinc)", x1="dist", x2="om", z="elev")
    support <- "Source x/y in RDH metres, EPSG:28992 as documented by sp::meuse; no CRS change to original sf."
  }
  keep <- complete.cases(data, xy)
  stopifnot(all(vapply(data[keep, ], function(x) all(is.finite(x)), logical(1))))
  list(id=id, path=path, checksum=unname(tools::md5sum(path)), data=data[keep, ],
       xy=xy[keep, ,drop=FALSE], source_rows=which(keep), removed_rows=which(!keep),
       mapping=mapping, support=support, n_source=nrow(data))
}

calibrate_source <- function(source) {
  data <- source$data; xy <- source$xy
  # Every third site in east-west order is calibration-only. Independent of Y.
  ordering <- order(xy[,1], xy[,2])
  calibration <- ordering[seq_along(ordering) %% 3 == 0]
  evaluation <- setdiff(seq_len(nrow(data)), calibration)
  centers <- vapply(data[calibration,c("x1","x2","z")], mean, numeric(1))
  scales <- vapply(data[calibration,c("x1","x2","z")], sd, numeric(1))
  stopifnot(all(scales > 0))
  for (v in names(centers)) data[[v]] <- (data[[v]]-centers[v])/scales[v]
  generator <- lm(full_formula, data=data[calibration, ])
  stopifnot(all(is.finite(coef(generator))))
  design <- model.matrix(full_formula, data=data[evaluation, ])
  terms <- sweep(design, 2, coef(generator), "*")
  pieces <- list(base=rowSums(terms[,c("(Intercept)","x1","x2","z"),drop=FALSE]),
                 curvature=rowSums(terms[,c("I(x1^2)","I(x2^2)"),drop=FALSE]),
                 interaction=terms[,"x1:x2"])
  eval_xy <- xy[evaluation, ,drop=FALSE]
  # Three contiguous east-west stripes: held-out geographic regions, no buffer.
  order_eval <- order(eval_xy[,1],eval_xy[,2]); fold <- integer(nrow(eval_xy))
  fold[order_eval] <- pmin(3L, ceiling(seq_along(order_eval)/length(order_eval)*3))
  coords_center <- colMeans(eval_xy); coords_scale <- apply(eval_xy,2,sd)
  eval_data <- data[evaluation, ]; eval_data$sx <- (eval_xy[,1]-coords_center[1])/coords_scale[1]
  eval_data$sy <- (eval_xy[,2]-coords_center[2])/coords_scale[2]
  W <- make_weights(eval_xy)
  # Known, fixed observed proxy: same source sites and same contamination in every run.
  set.seed(if (source$id == "georgia") 90201L else 90202L)
  proxy <- eval_data$z + rnorm(nrow(eval_data), sd=0.75)
  # Projection diagnoses omitted signal; it is never used to train competitors.
  mean_without_z <- as.numeric(predict(lm(y ~ x1+x2, data=transform(eval_data,y=pieces$base)),eval_data))
  list(source=source, generator=generator, centers=centers, scales=scales,
       calibration=calibration, evaluation=evaluation, data=eval_data, xy=eval_xy,
       fold=fold, W=W, pieces=pieces, proxy=proxy,
       omitted_component=pieces$base-mean_without_z)
}

scenario_mean <- function(calibration, scenario) {
  p <- calibration$pieces
  switch(scenario,
    reference=p$base, omitted_z=p$base, measured_z=p$base,
    curvature=p$base+p$curvature,
    interaction=p$base+p$interaction,
    sem_positive=p$base, heteroskedastic_control=p$base,
    stop("Unknown scenario"))
}

noise_operator <- function(calibration, scenario) {
  n <- nrow(calibration$data)
  if (scenario == "sem_positive") B <- solve(diag(n)-0.4*calibration$W)
  else if (scenario == "heteroskedastic_control") B <- diag(exp(0.5*calibration$data$z))
  else B <- diag(n)
  # Fix expected average marginal noise variance, not each realized draw.
  B / sqrt(mean(rowSums(B^2)))
}

unexplained_signal <- function(calibration, scenario) {
  data <- calibration$data
  if(scenario=="omitted_z") data$z <- NULL
  if(scenario=="measured_z") data$z <- calibration$proxy
  data$y <- scenario_mean(calibration,scenario)
  # Truth projection is a descriptive diagnostic, never a competitor input.
  residuals(lm(reformulate(intersect(c("x1","x2","z"),names(data)),response="y"),data=data))
}

generate_draw <- function(calibration, scenario, seed, snr=3) {
  m <- scenario_mean(calibration,scenario)
  stopifnot(snr > 0, var(m) > 0)
  sigma <- sqrt(var(m)/snr)
  set.seed(seed); epsilon <- rnorm(length(m))
  B <- noise_operator(calibration,scenario)
  u <- as.numeric(sigma*B %*% epsilon)
  observed <- calibration$data
  observed$y <- m+u
  if (scenario == "omitted_z") observed$z <- NULL
  if (scenario == "measured_z") observed$z <- calibration$proxy
  latent <- calibration$data; latent$y <- observed$y
  list(observed=observed, latent=latent, m=m, u=u, sigma=sigma, B=B, seed=seed)
}

fit_predict <- function(method, train, test) {
  variables <- intersect(c("x1","x2","z"),names(train))
  if (method == "linear") fit <- lm(reformulate(variables,response="y"),data=train)
  else if (method == "oracle_basis") fit <- lm(full_formula,data=train)
  else {
    rhs <- paste(sprintf("s(%s,k=4)",variables),collapse="+")
    rhs <- paste(rhs,"ti(x1,x2,k=c(4,4))",sep="+")
    if (method == "gam_spatial") rhs <- paste(rhs,"s(sx,sy,k=10)",sep="+")
    fit <- mgcv::gam(as.formula(paste("y~",rhs)),data=train,method="REML",select=TRUE)
    if (!isTRUE(fit$converged)) stop("GAM did not converge")
  }
  predicted <- as.numeric(predict(fit,newdata=test))
  if (length(predicted)!=nrow(test) || any(!is.finite(predicted))) stop("Invalid predictions")
  predicted
}

run_pilot <- function(repetitions=20L, output=file.path(pilot_dir,"pilot_output_2026-09-08")) {
  stopifnot(repetitions >= 2L)
  dir.create(output,recursive=TRUE,showWarnings=FALSE)
  scenarios <- c("reference","omitted_z","curvature","interaction","measured_z","sem_positive","heteroskedastic_control")
  methods <- c("linear","gam_covariates","gam_spatial","oracle_basis")
  raw <- diagnostics <- snapshots <- metadata <- list(); counter <- 0L
  for (id in c("georgia","meuse")) {
    calibration <- calibrate_source(load_source(id))
    saveRDS(calibration,file.path(output,paste0(id,"_calibration.rds")))
    meta <- calibration$source[c("path","checksum","source_rows","removed_rows","mapping","support","n_source")]
    meta$n_calibration <- length(calibration$calibration); meta$n_evaluation <- nrow(calibration$data)
    meta$generator_formula <- paste(deparse(full_formula),collapse=" ")
    meta$generator_coefficients <- as.list(coef(calibration$generator))
    meta$generator_provenance <- "system-designed polynomial basis fitted to real Y on calibration-only sites; not a published empirical formula"
    meta$source_fit_calibration_rmse <- sqrt(mean(residuals(calibration$generator)^2))
    source_truth <- calibration$source$data$y[calibration$evaluation]
    source_prediction <- as.numeric(predict(calibration$generator,newdata=calibration$data))
    meta$source_fit_evaluation_rmse <- sqrt(mean((source_truth-source_prediction)^2))
    meta$source_fit_evaluation_r2 <- 1-sum((source_truth-source_prediction)^2)/sum((source_truth-mean(source_truth))^2)
    meta$weights <- "Euclidean distances in documented projected metres; symmetrized union of k=4 nearest neighbors, zero diagonal, row-standardized, no isolates; pilot W, not original publication W"
    meta$z_moran <- moran_descriptive(calibration$data$z,calibration$W)
    metadata[[id]] <- meta
    for (scenario in scenarios) {
      m <- scenario_mean(calibration,scenario)
      missed <- switch(scenario,omitted_z=calibration$omitted_component,
                       curvature=calibration$pieces$curvature,
                       interaction=calibration$pieces$interaction,
                       measured_z=as.numeric(coef(calibration$generator)["z"])*(calibration$data$z-calibration$proxy),
                       rep(0,length(m)))
      diagnostics[[length(diagnostics)+1L]] <- data.frame(dataset=id,scenario=scenario,
        m_moran=moran_descriptive(m,calibration$W), component_sd=sd(missed),
        component_moran=moran_descriptive(missed,calibration$W),
        linear_unexplained_variance=var(unexplained_signal(calibration,scenario)),
        linear_unexplained_moran=moran_descriptive(unexplained_signal(calibration,scenario),calibration$W),
        signal_variance=var(m),sigma=sqrt(var(m)/3),snr_expected=3,
        lambda=ifelse(scenario=="sem_positive",0.4,0))
      for (replication in seq_len(repetitions)) {
        seed <- 908000L + match(id,c("georgia","meuse"))*1000L + replication
        draw <- generate_draw(calibration,scenario,seed)
        if (replication==1L) snapshots[[paste(id,scenario,sep="/")]] <- draw
        for (method in methods) {
          predictions <- rep(NA_real_,length(m)); errors <- warnings_seen <- character(); elapsed <- 0
          supplied <- if(method=="oracle_basis") draw$latent else draw$observed
          for (fold in 1:3) {
            test <- which(calibration$fold==fold); train <- which(calibration$fold!=fold)
            start <- proc.time()[["elapsed"]]
            result <- withCallingHandlers(tryCatch(fit_predict(method,supplied[train,],supplied[test,]),
              error=function(e) { errors <<- c(errors,paste0("fold ",fold,": ",conditionMessage(e))); rep(NA_real_,length(test)) }),
              warning=function(w) {warnings_seen <<- c(warnings_seen,conditionMessage(w));invokeRestart("muffleWarning")})
            elapsed <- elapsed+proc.time()[["elapsed"]]-start
            predictions[test] <- result
          }
          failed <- anyNA(predictions)
          counter <- counter+1L
          raw[[counter]] <- data.frame(dataset=id,scenario=scenario,replication=replication,
            seed=seed,method=method,role=ifelse(method=="oracle_basis","diagnostic_privileged","competitor"),
            n=length(m),failed=failed,mse_mean=if(failed) NA_real_ else mean((predictions-m)^2),
            nmse_mean=if(failed) NA_real_ else mean((predictions-m)^2)/var(m),
            mse_observed=if(failed) NA_real_ else mean((predictions-draw$observed$y)^2),
            residual_moran=if(failed) NA_real_ else moran_descriptive(draw$observed$y-predictions,calibration$W),
            innovation_moran=moran_descriptive(draw$u,calibration$W),elapsed_seconds=elapsed,
            error=paste(unique(errors),collapse=" | "),warning=paste(unique(warnings_seen),collapse=" | "))
        }
      }
      message(id," / ",scenario," complete (",repetitions," replications)")
    }
    stopifnot(identical(calibration$source$checksum,unname(tools::md5sum(calibration$source$path))))
  }
  raw <- do.call(rbind,raw); diagnostics <- do.call(rbind,diagnostics)
  grouping <- split(raw,interaction(raw$dataset,raw$scenario,raw$method,drop=TRUE))
  summary <- do.call(rbind,lapply(grouping,function(d) {
    ok <- !d$failed
    data.frame(dataset=d$dataset[1],scenario=d$scenario[1],method=d$method[1],role=d$role[1],
      completed=sum(ok),failed=sum(!ok),nmse_mean=if(any(ok)) mean(d$nmse_mean[ok]) else NA_real_,
      mcse=if(sum(ok)>1) sd(d$nmse_mean[ok])/sqrt(sum(ok)) else NA_real_,
      residual_moran=if(any(ok)) mean(d$residual_moran[ok],na.rm=TRUE) else NA_real_)
  }))
  result <- list(schema="plasmode_pilot_v1",date="2026-09-08",repetitions=repetitions,
    snr=3,split="fixed calibration every third east-west ordered site; 3 held-out east-west stripes among evaluation sites; no buffer",
    truth="fixed-site latent conditional mean given complete source X; measured_z does NOT target population E[Y|noisy X]",
    uncertainty="Monte Carlo SE conditional on fixed sources, calibration, folds, measurement proxy and design; no inferential comparison verdict",
    raw=raw,summary=summary,diagnostics=diagnostics,sources=metadata,
    session=as.list(sapply(c("sf","mgcv","jsonlite","spgwr"),function(p)as.character(packageVersion(p)))))
  saveRDS(result,file.path(output,"results.rds"))
  saveRDS(snapshots,file.path(output,"first_replication_truth.rds"))
  jsonlite::write_json(result,file.path(output,"results.json"),auto_unbox=TRUE,pretty=TRUE,na="null",digits=10)
  writeLines(capture.output(sessionInfo()),file.path(output,"sessionInfo.txt"))
  message("Pilot complete: ",nrow(raw)," evaluations; ",sum(raw$failed)," failures.")
  if(any(raw$failed)) stop("Pilot contains failures; inspect results before reporting.")
  invisible(result)
}

if (sys.nframe()==0L) {
  args <- commandArgs(trailingOnly=TRUE)
  n <- if(length(args)) as.integer(args[1]) else 20L
  out <- if(length(args)>1) args[2] else file.path(pilot_dir,"pilot_output_2026-09-08")
  run_pilot(n,out)
}
