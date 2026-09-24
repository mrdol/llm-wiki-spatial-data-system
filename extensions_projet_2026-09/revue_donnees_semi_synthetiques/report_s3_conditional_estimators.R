# Propagate S3 conditional z realizations through ordinary estimators.
# This is a first-replication covariate-uncertainty diagnostic, not a full interval.
source("extensions_projet_2026-09/revue_donnees_semi_synthetiques/scenario_s3_interpolated_covariate.R")

run_s3_conditional_estimators <- function(
  input=file.path(pilot_dir,"scenario_s3_central_paired_2026-09-15","results.rds"),
  output=file.path(pilot_dir,"scenario_s3_central_paired_2026-09-15","conditional_estimators_v2.rds"),
  draws=30L) {
  stopifnot(draws>=2L,!file.exists(output))
  saved <- readRDS(input); raw <- saved$results$raw
  methods <- c("linear","polynomial","gam_covariates","gam_spatial","forest")
  rows <- list()
  for(id in c("georgia","meuse")) {
    cal <- calibrate_source(load_source(id)); generators <- build_generators(cal)
    for(generator in c("polynomial","forest")) for(task in c("known_network","geographic_transfer")) {
      setting <- paste(id,generator,.4,task,"kriging",0,sep="/")
      surface <- saved$surfaces[[setting]]
      stopifnot(!is.null(surface))
      mean_truth <- generators$means[[generator]]
      sigma <- sqrt(var(mean_truth)/3)
      stopifnot(any(raw$dataset==id & raw$generator==generator & raw$task==task &
                    raw$interpolation=="kriging" & raw$replication==1L))
      seed <- 915000L+match(id,c("georgia","meuse"))*100000L+
        match(generator,c("polynomial","forest"))*10000L+1000000L
      set.seed(seed+500000L); observed_y <- mean_truth+sigma*rnorm(length(mean_truth))
      for(fold in 1:3) {
        model <- surface$models[[fold]]
        conditional <- conditional_covariate_draws(cal$xy,model$stations,model$measured,
          model$variogram,draws=draws,seed=seed+900000L+fold)
        train_index <- which(cal$fold!=fold); test_index <- which(cal$fold==fold)
        stopifnot(!any(cal$fold[model$stations]==fold) || task=="known_network")
        for(method in methods) {
          predictions <- matrix(NA_real_,length(test_index),draws)
          errors <- character()
          for(j in seq_len(draws)) {
            data <- cal$data; data$z <- conditional$draws[,j]; data$y <- observed_y
            train <- data[train_index,,drop=FALSE]; test <- data[test_index,,drop=FALSE]
            p <- tryCatch(predict_competitor(method,train,test,915300L+fold),
              error=function(e){errors <<- c(errors,conditionMessage(e));
                rep(NA_real_,length(test_index))})
            predictions[,j] <- p
          }
          failed <- any(!is.finite(predictions))
          if(!failed) {
            interval <- apply(predictions,1,quantile,probs=c(.05,.95))
            mean_prediction <- rowMeans(predictions)
          }
          rows[[length(rows)+1L]] <- data.frame(dataset=id,generator=generator,
            task=task,fold=fold,method=method,draws=draws,failed=failed,
            nmse_mean=if(failed)NA_real_ else mean((mean_prediction-mean_truth[test_index])^2)/var(mean_truth),
            latent_mean_hit_rate_z_only_90pct=if(failed)NA_real_ else mean(mean_truth[test_index]>=interval[1,] &
              mean_truth[test_index]<=interval[2,]),
            mean_width_90pct=if(failed)NA_real_ else mean(interval[2,]-interval[1,]),
            error=paste(unique(errors),collapse=" | "))
        }
        message(setting," fold ",fold," conditional predictions complete")
      }
    }
  }
  result <- do.call(rbind,rows)
  saveRDS(result,output)
  write.csv(result,sub("\\.rds$",".csv",output),row.names=FALSE)
  if(any(result$failed)) stop("Conditional estimator propagation contains failed fits")
  invisible(result)
}

if(sys.nframe()==0L)run_s3_conditional_estimators()
