# S3: observed subnetwork -> reconstructed z; fixed true m(X) and geographic transfer.
# Execute from the repository root.
source("extensions_projet_2026-09/revue_donnees_semi_synthetiques/priorites_plasmode.R")
stopifnot(requireNamespace("gstat",quietly=TRUE))

maximin_order <- function(xy, seed) {
  set.seed(seed); first <- sample.int(nrow(xy),1L)
  d <- as.matrix(dist(xy)); selected <- first
  while(length(selected)<nrow(xy)) {
    nearest <- apply(d[,selected,drop=FALSE],1,min)
    nearest[selected] <- -Inf
    selected <- c(selected,which.max(nearest))
  }
  selected
}

network_indices <- function(ordering, density) {
  ordering[seq_len(max(8L,round(length(ordering)*density)))]
}

idw_surface <- function(xy, stations, measured, power=2) {
  stopifnot(length(stations)==length(measured),length(stations)>=2L)
  distance <- as.matrix(dist(rbind(xy,xy[stations,,drop=FALSE])))
  distance <- distance[seq_len(nrow(xy)),nrow(xy)+seq_along(stations),drop=FALSE]
  weights <- 1/pmax(distance,1e-8)^power
  prediction <- as.numeric(weights%*%measured/rowSums(weights))
  prediction[stations] <- measured
  prediction
}

kriging_surface <- function(xy, stations, measured) {
  domain <- data.frame(x=xy[,1],y=xy[,2])
  sample <- domain[stations,,drop=FALSE]; sample$z <- measured
  spatial_points <- sf::st_as_sf(sample,coords=c("x","y"),crs=NA)
  domain_points <- sf::st_as_sf(domain,coords=c("x","y"),crs=NA)
  empirical <- gstat::variogram(z~1,as(spatial_points,"Spatial"))
  span <- max(dist(xy[stations,,drop=FALSE]))
  initial <- gstat::vgm(psill=max(var(measured)*.8,1e-6),model="Exp",
                        range=span/3,nugget=max(var(measured)*.2,1e-6))
  # The short transfer subnetworks cannot reliably identify sill, nugget and range
  # jointly. Fix the prespecified range to one third of station-domain diameter.
  fitted <- suppressWarnings(gstat::fit.variogram(empirical,initial,fit.ranges=FALSE))
  if(isTRUE(attr(fitted,"singular")) || any(!is.finite(fitted$psill)) ||
     any(fitted$psill<0) || !is.finite(fitted$range[2]) || fitted$range[2]<=0)
    stop("Invalid exponential variogram fit")
  predicted <- suppressMessages(gstat::krige(z~1,as(spatial_points,"Spatial"),
                                             as(domain_points,"Spatial"),model=fitted))
  value <- as.numeric(predicted$var1.pred)
  value[stations] <- measured
  list(value=value,variance=as.numeric(predicted$var1.var),variogram=fitted,
       empirical=empirical)
}

conditional_covariate_draws <- function(xy, stations, measured, variogram,
                                        measurement_sd=0, draws=20L, seed=1L) {
  stopifnot(draws>=2L,length(stations)==length(measured),
            variogram$model[2]=="Exp",all(variogram$psill>=0))
  d <- as.matrix(dist(xy)); n <- nrow(xy)
  process_sill <- variogram$psill[2]
  nugget <- variogram$psill[1]
  C <- process_sill*exp(-d/variogram$range[2])+diag(nugget,n)
  Cmm <- C[stations,stations,drop=FALSE]+diag(measurement_sd^2,length(stations))
  mean_z <- mean(measured)
  gain <- C[,stations,drop=FALSE]%*%solve(Cmm)
  conditional_mean <- as.numeric(mean_z+gain%*%(measured-mean_z))
  conditional_cov <- C-gain%*%C[stations,,drop=FALSE]
  conditional_cov <- (conditional_cov+t(conditional_cov))/2
  # Positive semidefinite at exact stations; numerical jitter is explicit.
  jitter <- 1e-9*max(1,max(diag(C)))
  L <- chol(conditional_cov+diag(jitter,n))
  set.seed(seed)
  realization <- matrix(conditional_mean,n,draws)+
    t(L)%*%matrix(rnorm(n*draws),n,draws)
  if(measurement_sd==0) realization[stations,] <- measured
  list(mean=conditional_mean,covariance=conditional_cov,draws=realization,
       jitter=jitter,measurement_sd=measurement_sd)
}

transfer_network <- function(xy, fold, station_pool, test_fold, buffer) {
  test <- which(fold==test_fold)
  permitted <- station_pool[fold[station_pool]!=test_fold]
  distances <- as.matrix(dist(rbind(xy[permitted,,drop=FALSE],xy[test,,drop=FALSE])))
  cross <- distances[seq_along(permitted),length(permitted)+seq_along(test),drop=FALSE]
  permitted[apply(cross,1,min)>buffer]
}

make_s3_surface <- function(cal, ordering, density, task, interpolation,
                            measurement_sd, seed) {
  xy <- cal$xy; fold <- cal$fold
  pool <- network_indices(ordering,density)
  set.seed(seed); measured <- cal$data$z[pool]+rnorm(length(pool),sd=measurement_sd)
  supplied <- rep(NA_real_,nrow(xy)); models <- vector("list",3L)
  for(k in 1:3) {
    stations <- if(task=="known_network") pool else
      transfer_network(xy,fold,pool,k,median(apply(replace(as.matrix(dist(xy)),
        row(as.matrix(dist(xy)))==col(as.matrix(dist(xy))),Inf),1,min)))
    if(length(stations)<8L) stop("Too few permitted stations")
    values <- measured[match(stations,pool)]
    surface <- if(interpolation=="idw") list(value=idw_surface(xy,stations,values))
      else kriging_surface(xy,stations,values)
    supplied[fold==k] <- surface$value[fold==k]
    models[[k]] <- list(stations=stations,measured=values,value=surface$value,
                        variogram=surface$variogram,empirical=surface$empirical,
                        variance=surface$variance)
  }
  stopifnot(all(is.finite(supplied)))
  list(value=supplied,pool=pool,measured=measured,models=models)
}

run_s3 <- function(repetitions=40L,
                   output=file.path(pilot_dir,"scenario_s3_output_2026-09-15"),
                   densities=c(.2,.4,.7),tasks=c("known_network","geographic_transfer"),
                   interpolations=c("idw","kriging"),measurement=c(0,.25)) {
  stopifnot(repetitions>=2L,!dir.exists(output))
  dir.create(output,recursive=TRUE)
  stopifnot(all(densities%in%c(.2,.4,.7)),
            all(tasks%in%c("known_network","geographic_transfer")),
            all(interpolations%in%c("idw","kriging")),all(measurement%in%c(0,.25)))
  methods <- c("linear","polynomial","gam_covariates","gam_spatial","forest")
  rows <- surfaces <- conditional_diagnostics <- list()
  for(id in c("georgia","meuse")) {
    cal <- calibrate_source(load_source(id)); generators <- build_generators(cal)
    ordering <- maximin_order(cal$xy,915100L+match(id,c("georgia","meuse")))
    stopifnot(all(network_indices(ordering,.2)%in%network_indices(ordering,.4)),
              all(network_indices(ordering,.4)%in%network_indices(ordering,.7)))
    for(generator in c("polynomial","forest")) {
      m <- generators$means[[generator]]; sigma <- sqrt(var(m)/3)
      for(density in densities) for(task in tasks) for(interpolation in interpolations)
        for(measurement_level in measurement) {
          setting <- paste(id,generator,density,task,interpolation,measurement_level,sep="/")
          for(replication in seq_len(repetitions)) {
            seed <- 915000L+match(id,c("georgia","meuse"))*100000L+
              match(generator,c("polynomial","forest"))*10000L+
              replication*1000000L
            measurement_seed <- seed+match(density,c(.2,.4,.7))*1000L+
              match(measurement_level,c(0,.25))
            surface <- tryCatch(make_s3_surface(cal,ordering,density,task,interpolation,
              measurement_level*sd(cal$data$z),measurement_seed),
              error=function(e)e)
            if(inherits(surface,"error")) {
              rows[[length(rows)+1L]] <- data.frame(dataset=id,generator=generator,
                density=density,task=task,interpolation=interpolation,
                measurement=measurement_level,replication=replication,seed=seed,method=methods,
                failed=TRUE,nmse_mean=NA_real_,z_rmse=NA_real_,
                error=conditionMessage(surface))
              next
            }
            if(replication==1L) {
              surfaces[[setting]] <- surface
              if(interpolation=="kriging") for(fold in 1:3) {
                model <- surface$models[[fold]]
                conditional <- conditional_covariate_draws(cal$xy,model$stations,
                  model$measured,model$variogram,
                  measurement_sd=measurement_level*sd(cal$data$z),draws=30L,
                  seed=seed+900000L+fold)
                test <- which(cal$fold==fold)
                draw_mean <- vapply(seq_len(ncol(conditional$draws)),function(j) {
                  trial <- cal$data
                  trial$z <- conditional$draws[,j]
                  if(generator=="polynomial")
                    as.numeric(predict(cal$generator,trial))[test]
                  else as.numeric(predict(generators$forest,trial)$predictions)[test]
                },numeric(length(test)))
                interval <- apply(draw_mean,1,quantile,probs=c(.05,.95))
                conditional_diagnostics[[paste(setting,fold,sep="/")]] <- data.frame(
                  dataset=id,generator=generator,density=density,task=task,
                  measurement=measurement_level,fold=fold,draws=30L,
                  privileged_mean_nmse=mean((rowMeans(draw_mean)-m[test])^2)/var(m),
                  privileged_90pct_coverage=mean(m[test]>=interval[1,] & m[test]<=interval[2,]),
                  conditional_z_rmse=sqrt(mean((conditional$mean[test]-cal$data$z[test])^2)),
                  jitter=conditional$jitter)
              }
            }
            set.seed(seed+500000L)
            observed_y <- m+sigma*rnorm(length(m))
            for(method in methods) {
              predicted <- rep(NA_real_,length(m)); errors <- character()
              for(fold in 1:3) {
                supplied <- cal$data
                supplied$z <- surface$models[[fold]]$value
                supplied$y <- observed_y
                train <- supplied[cal$fold!=fold,,drop=FALSE]
                test <- supplied[cal$fold==fold,,drop=FALSE]
                p <- tryCatch(predict_competitor(method,train,test,915300L+fold),
                  error=function(e){errors <<- c(errors,conditionMessage(e));rep(NA_real_,nrow(test))})
                if(replication==1L && !anyNA(p)) {
                  poisoned <- test; poisoned$y <- 1e12
                  stopifnot(identical(p,predict_competitor(method,train,poisoned,915300L+fold)))
                }
                predicted[cal$fold==fold] <- p
              }
              failed <- any(!is.finite(predicted))
              rows[[length(rows)+1L]] <- data.frame(dataset=id,generator=generator,
                density=density,task=task,interpolation=interpolation,
                measurement=measurement_level,replication=replication,seed=seed,method=method,
                failed=failed,nmse_mean=if(failed)NA_real_ else mean((predicted-m)^2)/var(m),
                z_rmse=sqrt(mean((surface$value-cal$data$z)^2)),
                error=paste(unique(errors),collapse=" | "))
            }
          }
          message(setting,": ",repetitions," replications complete")
        }
    }
  }
  raw <- do.call(rbind,rows)
  groups <- split(raw,interaction(raw$dataset,raw$generator,raw$density,raw$task,
                                  raw$interpolation,raw$measurement,raw$method,drop=TRUE))
  summary <- do.call(rbind,lapply(groups,function(d) {
    ok <- !d$failed
    data.frame(dataset=d$dataset[1],generator=d$generator[1],density=d$density[1],
      task=d$task[1],interpolation=d$interpolation[1],measurement=d$measurement[1],
      method=d$method[1],completed=sum(ok),failed=sum(!ok),
      nmse_mean=if(any(ok))mean(d$nmse_mean[ok])else NA_real_,
      mcse=if(sum(ok)>1L)sd(d$nmse_mean[ok])/sqrt(sum(ok))else NA_real_,
      z_rmse=if(any(ok))mean(d$z_rmse[ok])else NA_real_)
  }))
  result <- list(config=list(schema="plasmode_s3_single_surface_v1",date="2026-09-15",
    repetitions=repetitions,densities=densities,tasks=tasks,interpolations=interpolations,
    measurement_sd_fraction=measurement,methods=methods,
    target="m(X) using true complete z",note="known_network is transductive; geographic_transfer removes test-region stations and a metric buffer; conditional generator diagnostics are privileged and use the first replication only"),
    raw=raw,summary=summary,
    conditional_diagnostics=if(length(conditional_diagnostics))do.call(rbind,conditional_diagnostics)else NULL)
  saveRDS(list(results=result,surfaces=surfaces),file.path(output,"results.rds"))
  jsonlite::write_json(result,file.path(output,"results.json"),auto_unbox=TRUE,
                       pretty=TRUE,na="null",digits=12)
  writeLines(capture.output(sessionInfo()),file.path(output,"sessionInfo.txt"))
  invisible(result)
}

if(sys.nframe()==0L) {
  args <- commandArgs(trailingOnly=TRUE)
  repetitions <- if(length(args))as.integer(args[1])else 40L
  output <- if(length(args)>1L)args[2]else file.path(pilot_dir,"scenario_s3_output_2026-09-15")
  run_s3(repetitions,output)
}
