# S3 sensitivity to the choice of measurement network; privileged generator only.
source("extensions_projet_2026-09/revue_donnees_semi_synthetiques/scenario_s3_interpolated_covariate.R")

run_network_repeats <- function(networks=20L,draws=30L,
  output=file.path(pilot_dir,"scenario_s3_network_repeat_2026-09-15")) {
  stopifnot(networks>=2L,draws>=2L,!dir.exists(output))
  dir.create(output,recursive=TRUE)
  rows <- list()
  for(id in c("georgia","meuse")) {
    cal <- calibrate_source(load_source(id)); generators <- build_generators(cal)
    for(network in seq_len(networks)) {
      ordering <- maximin_order(cal$xy,916000L+match(id,c("georgia","meuse"))*1000L+network)
      for(task in c("known_network","geographic_transfer")) {
        surface <- make_s3_surface(cal,ordering,.4,task,"kriging",0,
                                   916500L+network)
        for(fold in 1:3) {
          model <- surface$models[[fold]]
          conditional <- conditional_covariate_draws(cal$xy,model$stations,
            model$measured,model$variogram,draws=draws,
            seed=916800L+network*100L+fold)
          test <- which(cal$fold==fold)
          for(generator in c("polynomial","forest")) {
            truth <- generators$means[[generator]]
            predicted <- vapply(seq_len(draws),function(j) {
              trial <- cal$data; trial$z <- conditional$draws[,j]
              if(generator=="polynomial")
                as.numeric(predict(cal$generator,trial))[test]
              else as.numeric(predict(generators$forest,trial)$predictions)[test]
            },numeric(length(test)))
            limits <- apply(predicted,1,quantile,probs=c(.05,.95))
            rows[[length(rows)+1L]] <- data.frame(dataset=id,network=network,
              task=task,fold=fold,generator=generator,draws=draws,
              measured_n=length(model$stations),
              z_rmse=sqrt(mean((surface$value[test]-cal$data$z[test])^2)),
              generator_z_only_hit_rate=mean(truth[test]>=limits[1,] &
                                             truth[test]<=limits[2,]),
              generator_mean_nmse=mean((rowMeans(predicted)-truth[test])^2)/var(truth))
          }
        }
        message(id," network ",network," / ",task," complete")
      }
    }
  }
  raw <- do.call(rbind,rows)
  by_network <- aggregate(cbind(z_rmse,generator_z_only_hit_rate,generator_mean_nmse)~
    dataset+network+task+generator,raw,mean)
  groups <- split(by_network,interaction(by_network$dataset,by_network$task,
                                        by_network$generator,drop=TRUE))
  summary <- do.call(rbind,lapply(groups,function(d)data.frame(
    dataset=d$dataset[1],task=d$task[1],generator=d$generator[1],
    networks=nrow(d),mean_z_rmse=mean(d$z_rmse),
    mcse_z_rmse=sd(d$z_rmse)/sqrt(nrow(d)),
    mean_generator_z_only_hit_rate=mean(d$generator_z_only_hit_rate),
    mcse_hit_rate=sd(d$generator_z_only_hit_rate)/sqrt(nrow(d)),
    mean_generator_nmse=mean(d$generator_mean_nmse),
    mcse_generator_nmse=sd(d$generator_mean_nmse)/sqrt(nrow(d)))))
  saveRDS(list(raw=raw,by_network=by_network,summary=summary),file.path(output,"results.rds"))
  write.csv(summary,file.path(output,"summary.csv"),row.names=FALSE)
  write.csv(by_network,file.path(output,"by_network.csv"),row.names=FALSE)
  invisible(summary)
}

if(sys.nframe()==0L)run_network_repeats()
