# S4: calibrated Gaussian spatial fields on fixed real sites. Run from repo root.
# This is a review pilot, not a spatialtidymodels engine.
source("extensions_projet_2026-09/revue_donnees_semi_synthetiques/priorites_plasmode.R")

s4_source_ids <- c("georgia","meuse","banff")

s4_load_source <- function(id) {
  if(id!="banff") return(load_source(id))
  path <- "data/final_datasets/sf/paper_banff_stream_temperature.rds"
  object <- readRDS(path)
  stopifnot(inherits(object,"sf"),nrow(object)==110L,
    all(object$Year_==2018L),
    isTRUE(all.equal(object$Easting,object$X,check.attributes=FALSE)),
    isTRUE(all.equal(object$Northing,object$Y,check.attributes=FALSE)))
  xy <- cbind(object$Easting,object$Northing)
  colnames(xy) <- c("Easting","Northing")
  data <- data.frame(y=object$WaterTemp,x1=object$Elev,
                     x2=object$RSlope,z=object$LE)
  stopifnot(all(complete.cases(data,xy)),
    all(vapply(data,function(v) all(is.finite(v)),logical(1))),
    !anyDuplicated(as.data.frame(xy)),
    identical(sort(unique(data$z)),c(0L,1L)))
  list(id=id,path=path,checksum=unname(tools::md5sum(path)),
    data=data,xy=xy,source_rows=seq_len(nrow(data)),removed_rows=integer(),
    mapping=c(y="WaterTemp",x1="Elev",x2="RSlope",z="LE"),
    support="Original Easting/Northing; EPSG:32611 UTM metres documented in the paper fiche and raw source; RDS geometry CRS absent; Euclidean pilot is not the published stream-network SSN/INLA model.",
    n_source=nrow(object))
}

s4_predict_competitor <- function(method,train,test,seed) {
  if(!method %in% c("gam_covariates","gam_spatial") ||
     length(unique(train$z))>=4L)
    return(predict_competitor(method,train,test,seed))
  # Binary/categorical z is parametric; a k=4 smooth is not identifiable.
  test$y <- NULL
  rhs <- "s(x1,k=4)+s(x2,k=4)+z+ti(x1,x2,k=c(4,4))"
  if(method=="gam_spatial") rhs <- paste(rhs,"s(sx,sy,k=10)",sep="+")
  fit <- mgcv::gam(as.formula(paste("y~",rhs)),data=train,
                   method="REML",select=TRUE)
  if(!isTRUE(fit$converged)) stop("GAM did not converge")
  out <- as.numeric(predict(fit,newdata=test))
  if(length(out)!=nrow(test) || any(!is.finite(out)))
    stop("Invalid GAM predictions")
  out
}

s4_centered_variance <- function(C) {
  n <- nrow(C)
  (sum(diag(C))-sum(C)/n)/(n-1)
}

s4_calibrate <- function(xy, m, snr=3, pi_s=.15, range_fraction=.2) {
  stopifnot(is.matrix(xy), nrow(xy)==length(m), nrow(xy)>3,
            all(is.finite(xy)), all(is.finite(m)), snr>0,
            pi_s>=0, pi_s<1, range_fraction>0, range_fraction<1)
  D <- as.matrix(dist(xy)); diameter <- max(D)
  # Exponential effective range is distance where correlation reaches 0.05.
  phi <- range_fraction*diameter/(-log(.05))
  R <- exp(-D/phi)
  signal <- var(m)
  stopifnot(signal>0)
  # pi_s = E sample Var(field)/(Var(m)+E sample Var(field)).
  target_spatial <- signal*pi_s/(1-pi_s)
  target_total <- signal/snr
  if (target_spatial>target_total+1e-12*signal)
    stop("Infeasible SNR and pi_s: spatial variance exceeds total noise variance")
  spatial_sill <- if(pi_s==0) 0 else target_spatial/s4_centered_variance(R)
  nugget <- max(0,target_total-target_spatial)
  C <- spatial_sill*R+diag(nugget,nrow(xy))
  eigen_min <- min(eigen(C,symmetric=TRUE,only.values=TRUE)$values)
  stopifnot(eigen_min>0, abs(s4_centered_variance(C)-target_total)<1e-9*signal)
  list(covariance=C,spatial_covariance=spatial_sill*R,
       nugget=nugget,spatial_sill=spatial_sill,phi=phi,
       effective_range=range_fraction*diameter,diameter=diameter,
       snr=snr,pi_s=pi_s,nugget_fraction=nugget/target_total,
       expected_spatial_variance=target_spatial,
       expected_total_variance=target_total,
       expected_snr=signal/s4_centered_variance(C),
       expected_pi_s=target_spatial/(signal+target_spatial),
       min_eigenvalue=eigen_min)
}

s4_draw <- function(C,seed) {
  set.seed(seed)
  as.numeric(t(chol(C))%*%rnorm(nrow(C)))
}

s4_conditional_draw <- function(C, sites, observed, seed) {
  n <- nrow(C); sites <- as.integer(sites)
  stopifnot(length(sites)>0, length(sites)<n,!anyDuplicated(sites),
            all(sites>=1 & sites<=n), length(observed)==length(sites),
            all(is.finite(observed)))
  free <- setdiff(seq_len(n),sites)
  K <- C[sites,sites,drop=FALSE]
  B <- C[free,sites,drop=FALSE]
  mu <- as.numeric(B%*%solve(K,observed))
  V <- C[free,free,drop=FALSE]-B%*%solve(K,t(B))
  V <- (V+t(V))/2
  set.seed(seed)
  draw <- numeric(n); draw[sites] <- observed
  draw[free] <- mu+as.numeric(t(chol(V))%*%rnorm(length(free)))
  list(draw=draw,conditional_mean=mu,conditional_covariance=V,
       sites=sites,free=free,max_honor_error=max(abs(draw[sites]-observed)))
}

s4_moran_expected <- function(C,W) {
  n <- nrow(C); P <- diag(n)-matrix(1/n,n,n)
  sum(W*(P%*%C%*%P))*n/sum(W)/sum(diag(P%*%C%*%P))
}

s4_buffer_splits <- function(xy,fold,buffer=NULL) {
  stopifnot(is.matrix(xy),length(fold)==nrow(xy),all(is.finite(xy)))
  D <- as.matrix(dist(xy))
  nearest <- D; diag(nearest) <- Inf
  if(is.null(buffer)) buffer <- median(apply(nearest,1,min))
  stopifnot(is.finite(buffer),buffer>0)
  splits <- lapply(sort(unique(fold)),function(k) {
    test <- which(fold==k); candidates <- which(fold!=k)
    min_to_test <- apply(D[candidates,test,drop=FALSE],1,min)
    train <- candidates[min_to_test>buffer]
    stopifnot(length(train)>=20L,!length(intersect(train,test)),
              min(D[train,test,drop=FALSE])>buffer)
    list(fold=k,train=train,test=test,excluded=setdiff(candidates,train),
         buffer=buffer,min_train_test_distance=min(D[train,test,drop=FALSE]))
  })
  names(splits) <- as.character(sort(unique(fold)))
  splits
}

s4_calibrate_trend <- function(xy,m,snr=3,pi_s=.15,range_fraction=.2) {
  stopifnot(snr>0,pi_s>=0,pi_s<1)
  # Common SNR across variants: Var(m)/E sample Var(spatial + epsilon).
  # The distinction is the target (m+g versus m), not a different Y law.
  base <- s4_calibrate(xy,m,snr,pi_s,range_fraction)
  base$epsilon_variance <- base$nugget
  base$trend_covariance <- base$spatial_covariance
  base
}

s4_conditional_field_by_fold <- function(C, split, anchor_seed, draw_seed) {
  n <- nrow(C)
  sites <- split$train[seq_along(split$train)%%5L==0L]
  stopifnot(length(sites)>=3L, !length(intersect(sites,split$test)))
  if(max(abs(C))==0) return(list(draw=rep(0,n),sites=sites,
    observed=rep(0,length(sites)),max_honor_error=0))
  # Anchor values are drawn once per configuration/fold, not renewed per replicate.
  observed <- s4_draw(C,anchor_seed)[sites]
  q <- s4_conditional_draw(C,sites,observed,draw_seed)
  stopifnot(q$max_honor_error==0)
  list(draw=q$draw,sites=sites,observed=observed,
       max_honor_error=q$max_honor_error,
       conditional_mean=q$conditional_mean,
       conditional_covariance=q$conditional_covariance)
}

s4_conditioning_plan <- function(C, split, anchor_seed) {
  n <- nrow(C)
  sites <- split$train[seq_along(split$train)%%5L==0L]
  stopifnot(length(sites)>=3L,!length(intersect(sites,split$test)))
  if(max(abs(C))==0) return(list(sites=sites,free=setdiff(seq_len(n),sites),
    observed=rep(0,length(sites)),mean=NULL,chol=NULL,n=n))
  observed <- s4_draw(C,anchor_seed)[sites]
  free <- setdiff(seq_len(n),sites)
  K <- C[sites,sites,drop=FALSE]
  B <- C[free,sites,drop=FALSE]
  solved <- solve(K,observed)
  mu <- as.numeric(B%*%solved)
  V <- C[free,free,drop=FALSE]-B%*%solve(K,t(B))
  V <- (V+t(V))/2
  list(sites=sites,free=free,observed=observed,mean=mu,
    chol=chol(V),n=n)
}

s4_conditioning_plan_draw <- function(plan,seed) {
  if(is.null(plan$chol)) return(list(draw=rep(0,plan$n),sites=plan$sites,
    observed=plan$observed,max_honor_error=0))
  set.seed(seed)
  draw <- numeric(plan$n)
  draw[plan$sites] <- plan$observed
  draw[plan$free] <- plan$mean+
    as.numeric(t(plan$chol)%*%rnorm(length(plan$free)))
  list(draw=draw,sites=plan$sites,observed=plan$observed,
    max_honor_error=max(abs(draw[plan$sites]-plan$observed)))
}

s4_summarize_risk <- function(raw) {
  groups <- split(raw,interaction(raw$dataset,raw$generator,raw$variant,
    raw$pi_s,raw$range_fraction,raw$method,drop=TRUE))
  do.call(rbind,lapply(groups,function(d) data.frame(dataset=d$dataset[1],
    generator=d$generator[1],variant=d$variant[1],pi_s=d$pi_s[1],
    range_fraction=d$range_fraction[1],method=d$method[1],
    completed=sum(!d$failed),failed=sum(d$failed),
    mean_nmse=mean(d$nmse[!d$failed]),
    mcse_nmse=sd(d$nmse[!d$failed])/sqrt(sum(!d$failed)))))
}

s4_pair_gap <- function(d, a, b, contrast, label_a, label_b) {
  keys <- c("dataset","generator","variant","replication")
  if(contrast=="method_gap") keys <- c(keys,"pi_s","range_fraction")
  if(contrast=="range_gap") keys <- c(keys,"pi_s","method")
  if(contrast=="strength_gap") keys <- c(keys,"range_fraction","method")
  if(contrast=="spatial_gap") keys <- c(keys,"method")
  p <- merge(a,b,by=keys,suffixes=c("_a","_b"))
  stopifnot(nrow(p)>0,all(p$seed_a==p$seed_b),
            all(!p$failed_a & !p$failed_b))
  gap <- p$nmse_a-p$nmse_b
  data.frame(dataset=p$dataset[1],generator=p$generator[1],variant=p$variant[1],
    contrast=contrast,label_a=label_a,label_b=label_b,
    pi_s=if("pi_s" %in% names(p)) p$pi_s[1] else if(contrast=="spatial_gap") p$pi_s_a[1] else NA_real_,
    range_fraction=if("range_fraction" %in% names(p)) p$range_fraction[1] else
      if(contrast=="spatial_gap") p$range_fraction_a[1] else NA_real_,
    method=if("method" %in% names(p)) p$method[1] else label_a,
    n=nrow(p),mean_gap=mean(gap),mcse_gap=sd(gap)/sqrt(length(gap)))
}

s4_factor_contrasts <- function(raw, pis, ranges, methods) {
  stopifnot(!any(raw$failed))
  out <- list()
  for(id in unique(raw$dataset)) for(gen in unique(raw$generator))
    for(variant in unique(raw$variant)) {
      d <- raw[raw$dataset==id & raw$generator==gen &
               raw$variant==variant,,drop=FALSE]
      for(method in methods) {
        m <- d[d$method==method,,drop=FALSE]
        baseline <- subset(m,pi_s==0)
        for(p in pis[pis>0]) for(r in ranges) {
          a <- subset(m,pi_s==p & range_fraction==r)
          out[[length(out)+1L]] <- s4_pair_gap(d,a,baseline,"spatial_gap",
            paste0("pi=",p,", range=",r),"pi=0")
        }
        for(p in pis[pis>0]) {
          a <- subset(m,pi_s==p & range_fraction==max(ranges))
          b <- subset(m,pi_s==p & range_fraction==min(ranges))
          out[[length(out)+1L]] <- s4_pair_gap(d,a,b,"range_gap",
            paste0("range=",max(ranges)),paste0("range=",min(ranges)))
        }
        for(r in ranges) {
          a <- subset(m,pi_s==max(pis) & range_fraction==r)
          b <- subset(m,pi_s==min(pis[pis>0]) & range_fraction==r)
          out[[length(out)+1L]] <- s4_pair_gap(d,a,b,"strength_gap",
            paste0("pi=",max(pis)),paste0("pi=",min(pis[pis>0])))
        }
      }
      for(p in pis) for(r in if(p==0) ranges[1] else ranges)
        for(pair in list(c("gam_spatial","gam_covariates"),c("forest","polynomial"))) {
          a <- subset(d,pi_s==p & range_fraction==r & method==pair[1])
          b <- subset(d,pi_s==p & range_fraction==r & method==pair[2])
          out[[length(out)+1L]] <- s4_pair_gap(d,a,b,"method_gap",pair[1],pair[2])
        }
    }
  do.call(rbind,out)
}

run_s4 <- function(repetitions=2L,
                   output=file.path(pilot_dir,"scenario_s4_buffered_run_2026-09-15"),
                   ranges=c(.1,.3), pis=c(0,.1,.2),
                   snr=3, conditional=FALSE,
                   variants=c("innovation","trend"),save_output=TRUE,
                   source_ids=c("georgia","meuse")) {
  stopifnot(repetitions>=2L,all(ranges>0 & ranges<1),
            all(pis>=0 & pis<1),length(variants)>0,
            all(variants %in% c("innovation","trend")),
            length(source_ids)>0L,!anyDuplicated(source_ids),
            all(source_ids %in% s4_source_ids))
  stopifnot(identical(sort(unique(pis)),c(0,.1,.2)),
            length(unique(ranges))==2L,all(ranges>0))
  if(save_output) stopifnot(!dir.exists(output))
  if(save_output) dir.create(output,recursive=TRUE)
  methods <- c("linear","polynomial","gam_covariates","gam_spatial","forest")
  rows <- diagnostics <- calibrations <- split_checks <- source_md5 <- source_metadata <- condition_checks <- distance_rows <- list()
  for(id in source_ids) {
    cal <- calibrate_source(s4_load_source(id)); gen <- build_generators(cal)
    source_md5[[id]] <- cal$source$checksum
    source_metadata[[id]] <- cal$source[c("path","checksum","mapping","support","n_source")]
    splits <- s4_buffer_splits(cal$xy,cal$fold)
    split_checks[[id]] <- do.call(rbind,lapply(splits,function(s)
      data.frame(dataset=id,fold=s$fold,train_n=length(s$train),
        test_n=length(s$test),excluded_n=length(s$excluded),
        buffer_m=s$buffer,min_train_test_distance_m=s$min_train_test_distance)))
    for(generator in c("polynomial","forest")) {
      m <- gen$means[[generator]]; n <- length(m)
      for(variant in variants) for(p in pis) for(r in if(p==0) ranges[1] else ranges) {
        field <- if(variant=="innovation") s4_calibrate(cal$xy,m,snr,p,r)
                 else s4_calibrate_trend(cal$xy,m,snr,p,r)
        key <- paste(id,generator,variant,p,r,sep="/")
        calibrations[[key]] <- field[c("spatial_sill","nugget","phi","effective_range",
                                      "expected_snr","expected_pi_s","nugget_fraction","min_eigenvalue")]
        diagnostics[[length(diagnostics)+1L]] <- data.frame(dataset=id,generator=generator,
          variant=variant,pi_s=p,range_fraction=r,snr_target=snr,snr_expected=field$expected_snr,
          pi_s_expected=field$expected_pi_s,nugget_fraction=field$nugget_fraction,
          expected_moran=s4_moran_expected(field$covariance,cal$W),
          min_eigenvalue=field$min_eigenvalue)
        plans <- if(conditional) lapply(seq_along(splits),function(fold) {
          split <- splits[[as.character(fold)]]
          # Common anchor normals across strength and range configurations.
          anchor_seed <- 950000L+match(id,s4_source_ids)*10000L+
            match(generator,c("polynomial","forest"))*1000L+fold
          s4_conditioning_plan(field$spatial_covariance,split,anchor_seed)
        }) else NULL
        distance_by_fold <- if(conditional) lapply(seq_along(splits),function(fold) {
          split <- splits[[as.character(fold)]]
          D <- as.matrix(dist(cal$xy))
          apply(D[split$test,plans[[fold]]$sites,drop=FALSE],1,min)
        }) else NULL
        for(replication in seq_len(repetitions)) {
          # Identical underlying standard normals across spatial settings.
          seed <- 940000L+match(id,s4_source_ids)*10000L+
            match(generator,c("polynomial","forest"))*1000L+replication
          field_seed <- seed+100000L
          spatial <- if(!conditional) {
            if(p==0) rep(0,n) else s4_draw(field$spatial_covariance,field_seed)
          } else rep(NA_real_,n)
          set.seed(seed)
          epsilon <- rnorm(n,sd=sqrt(field$nugget))
          if(!conditional) {
            u <- if(variant=="innovation") spatial+epsilon else epsilon
            latent_mean <- if(variant=="trend") m+spatial else m
            supplied <- cal$data; supplied$y <- latent_mean+u
            fold_supplied <- rep(list(supplied),length(splits))
          } else {
            u <- latent_mean <- observed_y <- rep(NA_real_,n)
            fold_supplied <- list()
            for(fold in seq_along(splits)) {
              split <- splits[[as.character(fold)]]
              q <- s4_conditioning_plan_draw(plans[[fold]],field_seed+fold)
              stopifnot(!length(intersect(q$sites,split$test)),
                min(as.matrix(dist(cal$xy))[q$sites,split$test,drop=FALSE])>split$buffer)
              spatial[split$test] <- q$draw[split$test]
              latent_mean[split$test] <- if(variant=="trend")
                m[split$test]+q$draw[split$test] else m[split$test]
              u[split$test] <- if(variant=="innovation")
                q$draw[split$test]+epsilon[split$test] else epsilon[split$test]
              supplied <- cal$data
              supplied$y <- m+q$draw+epsilon
              fold_supplied[[fold]] <- supplied
              observed_y[split$test] <- supplied$y[split$test]
              if(replication==1L) condition_checks[[length(condition_checks)+1L]] <-
                data.frame(dataset=id,generator=generator,variant=variant,
                  pi_s=p,range_fraction=r,fold=fold,n_anchor=length(q$sites),
                  n_test_anchor=length(intersect(q$sites,split$test)),
                  min_anchor_test_distance_m=min(as.matrix(dist(cal$xy))[
                    q$sites,split$test,drop=FALSE]),buffer_m=split$buffer,
                  max_honor_error=q$max_honor_error,
                  anchor_seed=950000L+match(id,s4_source_ids)*10000L+
                    match(generator,c("polynomial","forest"))*1000L+fold,
                  anchor_checksum=sum(q$observed^2))
            }
          }
          for(method in methods) {
            predicted <- rep(NA_real_,n); errors <- warnings_seen <- character()
            for(fold in 1:3) {
              split <- splits[[as.character(fold)]]
              fold_data <- fold_supplied[[fold]]
              train <- fold_data[split$train,,drop=FALSE]
              test <- fold_data[split$test,,drop=FALSE]
              prediction_seed <- 940300L+fold
              z <- withCallingHandlers(tryCatch(
                s4_predict_competitor(method,train,test,prediction_seed),
                error=function(e) {errors <<- c(errors,conditionMessage(e));
                                    rep(NA_real_,nrow(test))}),
                warning=function(w) {warnings_seen <<- c(warnings_seen,conditionMessage(w));
                                     invokeRestart("muffleWarning")})
              predicted[split$test] <- z
            }
            failed <- any(!is.finite(predicted))
            if(conditional && !failed) for(fold in seq_along(splits)) {
              split <- splits[[as.character(fold)]]
              d <- distance_by_fold[[fold]]
              cut <- median(d)
              for(bin in c("near","far")) {
                selected <- split$test[if(bin=="near") d<=cut else d>cut]
                distance_rows[[length(distance_rows)+1L]] <- data.frame(
                  dataset=id,generator=generator,variant=variant,
                  pi_s=p,range_fraction=r,replication=replication,
                  method=method,fold=fold,distance_bin=bin,n_sites=length(selected),
                  mean_distance_m=mean(d[match(selected,split$test)]),
                  mse=mean((predicted[selected]-latent_mean[selected])^2),
                  nmse=mean((predicted[selected]-latent_mean[selected])^2)/var(latent_mean))
              }
            }
            rows[[length(rows)+1L]] <- data.frame(dataset=id,generator=generator,
              variant=variant,pi_s=p,range_fraction=r,conditional=conditional,replication=replication,
              seed=seed,field_seed=if(variant=="trend") field_seed else seed,
              method=method,failed=failed,
              observed_checksum=if(conditional) sum(observed_y^2) else sum(supplied$y^2),
              latent_checksum=sum(latent_mean^2),
              nmse=if(failed) NA_real_ else mean((predicted-latent_mean)^2)/var(latent_mean),
              realized_noise_variance=var(u),
              realized_spatial_variance=var(spatial),
              max_abs_field_covariate_correlation=if(p==0) NA_real_ else
                max(abs(cor(spatial,cal$data[,c("x1","x2","z")]))),
              realized_moran=if(conditional) NA_real_ else
                moran_descriptive(if(variant=="trend") spatial else u,cal$W),
              error=paste(unique(errors),collapse=" | "),
              warning=paste(unique(warnings_seen),collapse=" | "))
          }
          if(repetitions>2L && replication%%10L==0L)
            message("S4 ",id,"/",generator,"/",variant,
                    " pi=",p," range=",r," rep=",replication,"/",repetitions)
        }
      }
    }
  }
  raw <- do.call(rbind,rows); diag <- do.call(rbind,diagnostics)
  split_summary <- do.call(rbind,split_checks)
  result <- list(config=list(schema="s4_review_pilot_v2",repetitions=repetitions,
    ranges=ranges,pis=pis,snr=snr,conditional=conditional,variants=variants,methods=methods,
    datasets=source_ids,source_md5=source_md5,source_metadata=source_metadata,
    script_md5=unname(tools::md5sum(file.path(pilot_dir,"scenario_s4_calibrated_fields.R"))),
    covariance="exponential + diagonal nugget; effective range at correlation 0.05",
    nugget="derived from common SNR and pi_s; not independently variable",
    gam_basis="x1/x2 smooths and interaction; z smooth if >=4 unique training values, otherwise parametric z (Banff LE binary)",
    split="three fixed east-west blocks; median nearest-neighbor metric buffer on training sites",
    conditioning=if(conditional) "field values fixed across replicates at every fifth buffered training site, separately by fold/configuration; shared anchor standard normals across spatial settings; exact latent-field conditioning; test fold never conditions" else "none",
    target="innovation: m(X); trend: m(X)+renewed g(s); same marginal observed Y law"),
    raw=raw,risk_summary=s4_summarize_risk(raw),
    paired_contrasts=if(any(raw$failed)) data.frame() else
      s4_factor_contrasts(raw,pis,ranges,methods),
    calibration=diag,split_checks=split_summary,
    condition_checks=if(conditional) do.call(rbind,condition_checks) else data.frame(),
    distance_risk=if(conditional) do.call(rbind,distance_rows) else data.frame(),
    parameters=calibrations,
    session_info=capture.output(sessionInfo()))
  if(save_output) saveRDS(result,file.path(output,"results.rds"))
  message(nrow(raw)," evaluations, ",sum(raw$failed)," failures")
  stopifnot(!any(raw$failed))
  invisible(result)
}

if(sys.nframe()==0L) run_s4()
