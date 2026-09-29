# S1 — geographically overlapping observation supports without fine-unit leakage.
# Run from repository root:
# Rscript extensions_projet_2026-09/revue_donnees_semi_synthetiques/scenario_s1_overlapping_supports.R 40
source("extensions_projet_2026-09/revue_donnees_semi_synthetiques/priorites_plasmode.R")

fine_spatial_folds <- function(xy, k=3L) {
  ordering <- order(xy[,1], xy[,2]); fold <- integer(nrow(xy))
  fold[ordering] <- pmin(k, ceiling(seq_along(ordering)/length(ordering)*k))
  stopifnot(all(tabulate(fold, nbins=k) >= 10L))
  fold
}

overlap_operator <- function(xy, fold, neighbors=0L, weighting="identity") {
  n <- nrow(xy)
  stopifnot(length(fold)==n, neighbors >= 0L,
            weighting %in% c("identity", "uniform", "distance"))
  if (neighbors == 0L) {
    stopifnot(weighting == "identity")
    return(diag(n))
  }
  H <- matrix(0, n, n)
  for (i in seq_len(n)) {
    candidates <- which(fold == fold[i] & seq_len(n) != i)
    d <- sqrt(rowSums((xy[candidates,,drop=FALSE]-matrix(xy[i,],length(candidates),2,
                                                         byrow=TRUE))^2))
    selected <- candidates[order(d, candidates)[seq_len(min(neighbors,length(candidates)))]]
    support <- c(i, selected)
    if (weighting == "uniform") weights <- rep(1, length(support))
    else {
      support_d <- c(0, sort(d)[seq_len(length(selected))])
      bandwidth <- max(support_d)
      weights <- exp(-support_d/bandwidth)
    }
    H[i,support] <- weights/sum(weights)
  }
  stopifnot(max(abs(rowSums(H)-1)) < 1e-12, all(H >= 0))
  H
}

nearest_neighbor_scale <- function(xy) {
  distances <- as.matrix(dist(xy)); diag(distances) <- Inf
  median(apply(distances,1,min))
}

buffered_support_split <- function(H, fine_xy, fold, test_fold, buffer_distance) {
  test <- which(fold == test_fold)
  candidates <- which(fold != test_fold)
  test_sources <- which(colSums(H[test,,drop=FALSE] > 0) > 0)
  source_distances <- as.matrix(dist(fine_xy))[,test_sources,drop=FALSE]
  keep <- vapply(candidates,function(i) {
    train_sources <- which(H[i,] > 0)
    min(source_distances[train_sources,,drop=FALSE]) > buffer_distance
  },logical(1))
  train <- candidates[keep]
  stopifnot(length(train) >= 20L, !length(intersect(train,test)))
  list(train=train,test=test,excluded=setdiff(candidates,train))
}

support_overlap_metrics <- function(H, fold) {
  shared_count <- tcrossprod(1*(H>0))
  off <- upper.tri(shared_count)
  within <- outer(fold,fold,"==") & off
  across <- outer(fold,fold,"!=") & off
  list(mean_shared_within=mean(shared_count[within]),
       fraction_overlapping_within=mean(shared_count[within]>0),
       cross_fold_pairs_sharing_sources=sum(shared_count[across]>0))
}

make_s1_design <- function(cal, means, neighbors, weighting) {
  fold <- fine_spatial_folds(cal$xy)
  H <- overlap_operator(cal$xy, fold, neighbors, weighting)
  observed_x <- H %*% as.matrix(cal$data[,c("x1","x2","z")])
  observed_xy <- H %*% cal$xy
  supplied <- as.data.frame(observed_x); names(supplied) <- c("x1","x2","z")
  centers <- colMeans(observed_xy); scales <- apply(observed_xy,2,sd)
  supplied$sx <- (observed_xy[,1]-centers[1])/scales[1]
  supplied$sy <- (observed_xy[,2]-centers[2])/scales[2]
  supplied$y <- 0
  buffer <- nearest_neighbor_scale(cal$xy)
  splits <- lapply(1:3, function(k) buffered_support_split(H,cal$xy,fold,k,buffer))
  # Since H is block-diagonal by fold, no fine source can cross a train/test split.
  leakage <- vapply(seq_along(splits), function(k) {
    train_sources <- colSums(H[splits[[k]]$train,,drop=FALSE] > 0) > 0
    test_sources <- colSums(H[splits[[k]]$test,,drop=FALSE] > 0) > 0
    sum(train_sources & test_sources)
  }, integer(1))
  stopifnot(all(leakage == 0L))
  list(H=H,data=supplied,xy=observed_xy,fold=fold,splits=splits,
       truth=as.numeric(H%*%means),buffer_distance=buffer,leakage=leakage,
       overlap=support_overlap_metrics(H,fold))
}

run_s1 <- function(repetitions=40L,
                   output=file.path(pilot_dir,"scenario_s1_output_2026-09-14")) {
  stopifnot(repetitions >= 2L, !dir.exists(output))
  dir.create(output,recursive=TRUE)
  datasets <- c("georgia","meuse"); generators <- c("polynomial","forest")
  methods <- c("linear","polynomial","gam_covariates","gam_spatial","forest")
  supports <- data.frame(label=c("identity","uniform_2","uniform_4","distance_2","distance_4"),
    neighbors=c(0L,2L,4L,2L,4L),weighting=c("identity","uniform","uniform","distance","distance"))
  rows <- diagnostics <- operators <- list()
  for (id in datasets) {
    cal <- calibrate_source(load_source(id)); fitted <- build_generators(cal)
    for (generator in generators) for (case in seq_len(nrow(supports))) {
      spec <- supports[case,]
      design <- make_s1_design(cal,fitted$means[[generator]],spec$neighbors,spec$weighting)
      key <- paste(id,generator,spec$label,sep="/")
      sigma <- sqrt(var(fitted$means[[generator]])/3)
      covariance <- sigma^2*tcrossprod(design$H)
      offdiag <- covariance; diag(offdiag) <- 0
      diagnostics[[key]] <- data.frame(dataset=id,generator=generator,support=spec$label,
        neighbors=spec$neighbors,weighting=spec$weighting,
        mean_shared_sources_within_fold=design$overlap$mean_shared_within,
        fraction_overlapping_pairs_within_fold=design$overlap$fraction_overlapping_within,
        cross_fold_pairs_sharing_sources=design$overlap$cross_fold_pairs_sharing_sources,
        buffer_distance=design$buffer_distance,buffer_excluded_mean=mean(lengths(lapply(design$splits,`[[`,"excluded"))),
        covariance_max_offdiagonal=max(abs(offdiag)))
      operators[[key]] <- design[c("H","xy","fold","splits","truth","buffer_distance","leakage")]
      for (replication in seq_len(repetitions)) {
        seed <- 915000L+match(id,datasets)*10000L+match(generator,generators)*1000L+case*100L+replication
        set.seed(seed); fine_error <- sigma*rnorm(nrow(cal$data))
        supplied <- design$data
        supplied$y <- as.numeric(design$H%*%(fitted$means[[generator]]+fine_error))
        for (method in methods) {
          predicted <- rep(NA_real_,nrow(supplied)); errors <- warnings_seen <- character()
          for (fold in 1:3) {
            split <- design$splits[[fold]]
            train <- supplied[split$train,,drop=FALSE]; test <- supplied[split$test,,drop=FALSE]
            prediction_seed <- 915300L+fold
            p <- withCallingHandlers(tryCatch(predict_competitor(method,train,test,prediction_seed),
              error=function(e){errors <<- c(errors,conditionMessage(e));rep(NA_real_,nrow(test))}),
              warning=function(w){warnings_seen <<- c(warnings_seen,conditionMessage(w));invokeRestart("muffleWarning")})
            if (replication==1L && !anyNA(p)) {
              poisoned <- test; poisoned$y <- 1e12
              stopifnot(identical(p,predict_competitor(method,train,poisoned,prediction_seed)))
            }
            predicted[split$test] <- p
          }
          failed <- any(!is.finite(predicted))
          rows[[length(rows)+1L]] <- data.frame(dataset=id,generator=generator,support=spec$label,
            replication=replication,seed=seed,method=method,failed=failed,
            nmse_mean=if(failed) NA_real_ else mean((predicted-design$truth)^2)/var(design$truth),
            mse_observed=if(failed) NA_real_ else mean((predicted-supplied$y)^2),
            error=paste(unique(errors),collapse=" | "),warning=paste(unique(warnings_seen),collapse=" | "))
        }
      }
      message(key,": ",repetitions," replications complete")
    }
  }
  raw <- do.call(rbind,rows); diagnostic_table <- do.call(rbind,diagnostics)
  groups <- split(raw,interaction(raw$dataset,raw$generator,raw$support,raw$method,drop=TRUE))
  summary <- do.call(rbind,lapply(groups,function(d){ok <- !d$failed; data.frame(
    dataset=d$dataset[1],generator=d$generator[1],support=d$support[1],method=d$method[1],
    completed=sum(ok),failed=sum(!ok),nmse_mean=if(any(ok))mean(d$nmse_mean[ok])else NA_real_,
    mcse=if(sum(ok)>1L)sd(d$nmse_mean[ok])/sqrt(sum(ok))else NA_real_)}))
  config <- list(schema="plasmode_s1_v1",date="2026-09-14",repetitions=repetitions,
    datasets=datasets,generators=generators,methods=methods,supports=supports,
    support_rule="self plus nearest fine units restricted to the same geographic fold",
    weighting="identity, uniform, or exponential distance decay",
    folds="three east-west fine-unit regions; one median nearest-neighbor distance buffer",
    target="H m(X)",covariance="sigma^2 H H'",snr_fine=3,
    transfer="independent-support transfer: zero fine units shared between training and test")
  result <- list(config=config,diagnostics=diagnostic_table,summary=summary,raw=raw)
  saveRDS(list(results=result,operators=operators),file.path(output,"results.rds"))
  jsonlite::write_json(result,file.path(output,"results.json"),pretty=TRUE,auto_unbox=TRUE,digits=12,na="null")
  writeLines(capture.output(sessionInfo()),file.path(output,"sessionInfo.txt"))
  if(any(raw$failed)) stop("S1 contains failed fits; inspect results.rds")
  invisible(result)
}

if(sys.nframe()==0L) {
  args <- commandArgs(trailingOnly=TRUE)
  repetitions <- if(length(args))as.integer(args[1])else 40L
  output <- if(length(args)>1L)args[2]else file.path(pilot_dir,"scenario_s1_output_2026-09-14")
  run_s1(repetitions,output)
}
