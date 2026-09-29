# Run from repository root. Separate sensitivity study; no package verdict.
# Rscript extensions_projet_2026-09/revue_donnees_semi_synthetiques/priorites_plasmode.R
source("extensions_projet_2026-09/revue_donnees_semi_synthetiques/plasmode_pilot.R")

forest_fit <- function(d, seed) {
  ranger::ranger(y ~ x1+x2+z, data=d, num.trees=300, mtry=2,
                 min.node.size=5, seed=seed, num.threads=1)
}

build_generators <- function(cal) {
  d <- cal$source$data[cal$calibration, ]
  for(v in names(cal$centers)) d[[v]] <- (d[[v]]-cal$centers[v])/cal$scales[v]
  forest <- forest_fit(d, 909100L)
  list(polynomial=cal$generator, forest=forest,
       means=list(polynomial=as.numeric(predict(cal$generator,cal$data)),
                  forest=as.numeric(predict(forest,cal$data)$predictions)))
}

predict_competitor <- function(method, train, test, seed) {
  # Enforce the boundary: held-out responses never enter prediction.
  test$y <- NULL
  if(method == "forest") return(as.numeric(predict(forest_fit(train,seed),test)$predictions))
  fit_predict(if(method == "polynomial") "oracle_basis" else method, train, test)
}

observation_diagnostics <- function(cal, draws=10000L) {
  n <- nrow(cal$data); m <- as.numeric(predict(cal$generator,cal$data))
  sigma <- sqrt(var(m)/3)
  set.seed(909201L+match(cal$source$id,c("georgia","meuse")))
  eps <- matrix(rnorm(n*draws),n,draws)
  vector_moran <- function(U,W) {
    V <- sweep(U,2,colMeans(U),"-")
    nrow(U)/sum(W)*colSums(V*(W %*% V))/colSums(V^2)
  }
  smoothing <- operators <- list()
  for(alpha in c(0,.25,.5)) {
    H <- (1-alpha)*diag(n)+alpha*cal$W
    covariance <- sigma^2*tcrossprod(H)
    U <- sigma*H %*% eps
    empirical <- tcrossprod(sweep(U,1,rowMeans(U),"-"))/(draws-1)
    relative_error <- norm(empirical-covariance,"F")/norm(covariance,"F")
    # Matched marginal variances, independent innovations: separates variance and covariance.
    independent <- sqrt(diag(covariance))*eps
    observed_moran <- vector_moran(U,cal$W)
    independent_moran <- vector_moran(independent,cal$W)
    offdiag <- covariance; diag(offdiag) <- 0
    stopifnot(relative_error < .15, max(abs(rowSums(H)-1)) < 1e-12)
    if(alpha==0) stopifnot(max(abs(offdiag))==0)
    shared <- tcrossprod(1*(H>0))>0
    cross_fold <- outer(cal$fold,cal$fold,"!=")
    smoothing[[length(smoothing)+1L]] <- data.frame(dataset=cal$source$id,alpha=alpha,
      covariance_relative_mc_error=relative_error,
      max_offdiagonal_covariance=max(abs(offdiag)),
      mean_moran=mean(observed_moran),mcse_moran=sd(observed_moran)/sqrt(draws),
      independent_mean_moran=mean(independent_moran),
      paired_moran_gap=mean(observed_moran-independent_moran),
      paired_moran_gap_mcse=sd(observed_moran-independent_moran)/sqrt(draws),
      train_test_pairs_with_shared_sources=sum(shared & cross_fold)/2,
      cross_fold_pairs=sum(cross_fold)/2)
    operators[[as.character(alpha)]] <- list(H=H,mean=as.numeric(H%*%m),covariance=covariance)
  }
  # Constructed groups of three consecutive east-west sites (last may be smaller).
  # This is an algebraic support-change diagnostic, not real administrative zoning.
  ordering <- order(cal$xy[,1],cal$xy[,2]); group <- integer(n)
  group[ordering] <- ceiling(seq_len(n)/3)
  A <- matrix(0,max(group),n)
  for(g in seq_len(nrow(A))) A[g,group==g] <- 1/sum(group==g)
  x <- as.matrix(cal$data[,c("x1","x2","z")]); xb <- A%*%x
  coarse <- as.data.frame(xb); coarse$y <- 0
  truth <- as.numeric(A%*%m)
  naive <- as.numeric(predict(cal$generator,coarse))
  variance1 <- as.numeric(A%*%(x[,1]^2))-xb[,1]^2
  variance2 <- as.numeric(A%*%(x[,2]^2))-xb[,2]^2
  covariance12 <- as.numeric(A%*%(x[,1]*x[,2]))-xb[,1]*xb[,2]
  b <- coef(cal$generator)
  correction <- b["I(x1^2)"]*variance1+b["I(x2^2)"]*variance2+b["x1:x2"]*covariance12
  identity_error <- max(abs(truth-naive-correction))
  noise_covariance <- sigma^2*tcrossprod(A); offdiag <- noise_covariance; diag(offdiag) <- 0
  stopifnot(identity_error < 1e-10, max(abs(offdiag))==0)
  coarse_xy <- A%*%cal$xy; Wcoarse <- make_weights(coarse_xy)
  aggregation <- data.frame(dataset=cal$source$id,n_groups=nrow(A),
    rmse_missing_moments=sqrt(mean((truth-naive)^2)),
    normalized_mse_missing_moments=mean((truth-naive)^2)/var(truth),
    discrepancy_moran=moran_descriptive(truth-naive,Wcoarse),
    identity_max_error=identity_error,noise_max_offdiagonal=max(abs(offdiag)))
  list(smoothing=do.call(rbind,smoothing),aggregation=aggregation,
       operators=operators,aggregation_truth=list(A=A,group=group,xy=coarse_xy,W=Wcoarse,
         mean=truth,naive_mean=naive,correction=correction,noise_covariance=noise_covariance))
}

run_priorities <- function(repetitions=40L,
                          output=file.path(pilot_dir,"priority_output_2026-09-09")) {
  stopifnot(repetitions>=2L, !dir.exists(output))
  dir.create(output,recursive=TRUE)
  methods <- c("linear","polynomial","gam_covariates","gam_spatial","forest")
  config <- list(schema="plasmode_priorities_v1",date="2026-09-09",repetitions=repetitions,
    datasets=c("georgia","meuse"),generators=c("polynomial","forest"),methods=methods,
    lambda=0,snr=3,innovation="Gaussian iid, shared standard draws across generators",
    split="same fixed calibration sites and three east-west folds as 2026-09-08 pilot; no buffer",
    forest=list(trees=300,mtry=2,min_node_size=5,generator_seed=909100,threads=1),
    tuning="none; prespecified configurations; algorithmic seeds fixed across repetitions",
    target="conditional mean risk on fixed evaluation sites; all X observed",
    uncertainty="innovation Monte Carlo only, conditional on source, generator fit, seeds and folds",
    observation_draws=10000,observation_alphas=c(0,.25,.5),
    script_md5=as.list(tools::md5sum(file.path(pilot_dir,c("plasmode_pilot.R","priorites_plasmode.R")))))
  jsonlite::write_json(config,file.path(output,"config.json"),pretty=TRUE,auto_unbox=TRUE)
  rows <- sources <- observation <- checks <- list(); predictions <- list()
  for(id in config$datasets) {
    cal <- calibrate_source(load_source(id)); generators <- build_generators(cal)
    # Perturb all real evaluation Y: calibration and simulated truths must be unchanged.
    poisoned <- cal$source; poisoned$data$y[cal$evaluation] <- 1e9
    poisoned_generators <- build_generators(calibrate_source(poisoned))
    stopifnot(identical(generators$means,poisoned_generators$means))
    saveRDS(list(calibration=cal,generators=generators),file.path(output,paste0(id,"_generators.rds")))
    truth_real <- cal$source$data$y[cal$evaluation]
    for(gen in config$generators) {
      m <- generators$means[[gen]]
      sources[[length(sources)+1L]] <- data.frame(dataset=id,generator=gen,
        calibration_n=length(cal$calibration),evaluation_n=length(m),signal_variance=var(m),
        source_evaluation_r2=1-sum((m-truth_real)^2)/sum((truth_real-mean(truth_real))^2))
      for(replication in seq_len(repetitions)) {
        seed <- 909000L+match(id,config$datasets)*1000L+replication
        set.seed(seed); epsilon <- rnorm(length(m)); sigma <- sqrt(var(m)/3)
        supplied <- cal$data; supplied$y <- m+sigma*epsilon
        for(method in methods) {
          predicted <- rep(NA_real_,length(m)); errors <- warnings_seen <- character()
          for(fold in 1:3) {
            train <- supplied[cal$fold!=fold,]; test <- supplied[cal$fold==fold,]
            prediction_seed <- 909300L+fold
            p <- withCallingHandlers(tryCatch(predict_competitor(method,train,test,prediction_seed),
              error=function(e) {errors <<- c(errors,conditionMessage(e));rep(NA_real_,nrow(test))}),
              warning=function(w) {warnings_seen <<- c(warnings_seen,conditionMessage(w));invokeRestart("muffleWarning")})
            if(replication==1L && !anyNA(p)) {
              test$y <- 1e12
              stopifnot(isTRUE(all.equal(p,predict_competitor(method,train,test,prediction_seed),tolerance=0)))
            }
            predicted[cal$fold==fold] <- p
          }
          failed <- any(!is.finite(predicted))
          rows[[length(rows)+1L]] <- data.frame(dataset=id,generator=gen,method=method,
            replication=replication,seed=seed,failed=failed,
            nmse_mean=if(failed) NA_real_ else mean((predicted-m)^2)/var(m),
            mse_observed=if(failed) NA_real_ else mean((predicted-supplied$y)^2),
            error=paste(unique(errors),collapse=" | "),warning=paste(unique(warnings_seen),collapse=" | "))
          predictions[[paste(id,gen,replication,method,sep="/")]] <- predicted
        }
      }
      message(id," / ",gen,": ",repetitions," repetitions complete")
    }
    observation[[id]] <- observation_diagnostics(cal,config$observation_draws)
    stopifnot(identical(cal$source$checksum,unname(tools::md5sum(cal$source$path))))
    checks[[id]] <- list(no_real_evaluation_y_leak=TRUE,no_prediction_y_leak=TRUE,
                        source_md5_unchanged=TRUE,source_path=cal$source$path,source_md5=cal$source$checksum)
  }
  raw <- do.call(rbind,rows)
  summaries <- do.call(rbind,lapply(split(raw,interaction(raw$dataset,raw$generator,raw$method,drop=TRUE)),function(d) {
    ok <- !d$failed
    data.frame(dataset=d$dataset[1],generator=d$generator[1],method=d$method[1],
      completed=sum(ok),failed=sum(!ok),nmse_mean=mean(d$nmse_mean[ok]),mcse=sd(d$nmse_mean[ok])/sqrt(sum(ok)))
  }))
  paired <- list()
  for(id in config$datasets) for(gen in config$generators)
    for(pair in list(c("forest","polynomial"),c("gam_spatial","gam_covariates"),c("gam_covariates","polynomial"))) {
      a <- subset(raw,dataset==id & generator==gen & method==pair[1])
      b <- subset(raw,dataset==id & generator==gen & method==pair[2])
      stopifnot(identical(a$replication,b$replication),identical(a$seed,b$seed))
      paired[[length(paired)+1L]] <- data.frame(dataset=id,generator=gen,
        contrast=paste(pair,collapse=" - "),replication=a$replication,difference=a$nmse_mean-b$nmse_mean)
    }
  paired <- do.call(rbind,paired)
  summarize_gaps <- function(d) data.frame(dataset=d$dataset[1],generator=d$generator[1],
    contrast=d$contrast[1],difference=mean(d$difference),mcse=sd(d$difference)/sqrt(nrow(d)),n=nrow(d))
  gaps <- do.call(rbind,lapply(split(paired,interaction(paired$dataset,paired$generator,paired$contrast,drop=TRUE)),summarize_gaps))
  shifts <- merge(subset(paired,generator=="forest"),subset(paired,generator=="polynomial"),
                  by=c("dataset","contrast","replication"),suffixes=c("_forest","_polynomial"))
  shifts$difference <- shifts$difference_forest-shifts$difference_polynomial
  shifts$generator <- "forest minus polynomial generator"
  shifts_summary <- do.call(rbind,lapply(split(shifts,interaction(shifts$dataset,shifts$contrast,drop=TRUE)),summarize_gaps))
  result <- list(config=config,raw=raw,summary=summaries,paired_contrasts=gaps,
    between_generator_contrast_change=shifts_summary,source_fidelity=do.call(rbind,sources),checks=checks,
    smoothing=do.call(rbind,lapply(observation,`[[`,"smoothing")),
    aggregation=do.call(rbind,lapply(observation,`[[`,"aggregation")))
  saveRDS(list(results=result,predictions=predictions,paired=paired,observation=observation),file.path(output,"results.rds"))
  jsonlite::write_json(result,file.path(output,"results.json"),pretty=TRUE,auto_unbox=TRUE,digits=12,na="null")
  writeLines(capture.output(sessionInfo()),file.path(output,"sessionInfo.txt"))
  message(nrow(raw)," evaluations, ",sum(raw$failed)," failures, ",sum(nzchar(raw$warning))," rows with warnings")
  stopifnot(!any(raw$failed))
  invisible(result)
}

if(sys.nframe()==0L) run_priorities()
