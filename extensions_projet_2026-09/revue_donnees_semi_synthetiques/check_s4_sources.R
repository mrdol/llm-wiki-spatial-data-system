# Check the S4 field generator on actual Georgia/Meuse supports, independently
# of estimator fits. Run from repository root.
source("extensions_projet_2026-09/revue_donnees_semi_synthetiques/scenario_s4_calibrated_fields.R")

s4_variogram_checks <- function(xy,C,U,variant,breaks=c(0,.05,.15,.35,1.000001)) {
  D <- as.matrix(dist(xy)); diameter <- max(D); n <- nrow(D)
  stopifnot(nrow(C)==n,nrow(U)==n)
  out <- list()
  for(b in seq_len(length(breaks)-1L)) {
    edges <- which(upper.tri(D) & D>=breaks[b]*diameter &
                   D<breaks[b+1L]*diameter,arr.ind=TRUE)
    if(nrow(edges)==0L) next
    i <- edges[,1]; j <- edges[,2]; count <- nrow(edges)
    Q <- matrix(0,n,n)
    diag(Q) <- tabulate(c(i,j),nbins=n)
    Q[cbind(i,j)] <- -1; Q[cbind(j,i)] <- -1
    gamma_draw <- colSums(U*(Q%*%U))/(2*count)
    expected <- sum(Q*C)/(2*count)
    observed <- mean(gamma_draw)
    mcse <- sd(gamma_draw)/sqrt(ncol(U))
    out[[length(out)+1L]] <- data.frame(variant=variant,
      distance_lower_fraction=breaks[b],distance_upper_fraction=breaks[b+1L],
      n_pairs=count,draws=ncol(U),expected_semivariance=expected,
      observed_semivariance=observed,mcse_semivariance=mcse,
      gap_over_mcse=(observed-expected)/mcse,
      required_draws_for_5pct_relative_mcse=ceiling(ncol(U)*
        (mcse/(.05*expected))^2))
  }
  do.call(rbind,out)
}

check_s4_sources <- function(draws=3000L,
  output=file.path(pilot_dir,"scenario_s4_source_checks_validation_2026-09-15")) {
  stopifnot(draws>=100L,!dir.exists(output))
  dir.create(output,recursive=TRUE)
  rows <- list(); conditionals <- variograms <- list()
  for(id in c("georgia","meuse")) {
    cal <- calibrate_source(load_source(id)); generators <- build_generators(cal)
    n <- nrow(cal$xy)
    # Conditioning sites come only from buffered training sites for fold 3.
    split <- s4_buffer_splits(cal$xy,cal$fold)[["3"]]
    sites <- split$train[split$train%%5L==0L]
    stopifnot(length(sites)>=3L,all(cal$fold[sites]!=3L))
    D <- as.matrix(dist(cal$xy))
    min_site_test_distance <- min(D[sites,split$test,drop=FALSE])
    stopifnot(min_site_test_distance>split$buffer)
    for(generator in c("polynomial","forest")) {
      m <- generators$means[[generator]]
      for(p in c(.1,.2)) for(r in c(.1,.3)) {
        field <- s4_calibrate(cal$xy,m,3,p,r)
        set.seed(970000L+match(id,c("georgia","meuse"))*1000L+
          match(generator,c("polynomial","forest"))*100L+round(p*10)*10L+round(r*10))
        Z <- matrix(rnorm(n*draws),n,draws)
        U <- t(chol(field$covariance))%*%Z
        S <- t(chol(field$spatial_covariance))%*%Z
        empirical <- tcrossprod(sweep(U,1,rowMeans(U),"-"))/(draws-1)
        realized_var <- apply(U,2,var)
        realized_moran <- apply(U,2,moran_descriptive,W=cal$W)
        observed_mean_moran <- mean(realized_moran)
        # The ratio of expectations is a covariance diagnostic, not generally
        # identical to the expectation of Moran's random denominator.
        rows[[length(rows)+1L]] <- data.frame(dataset=id,generator=generator,
          pi_s=p,range_fraction=r,draws=draws,n_sites=n,
          expected_snr=field$expected_snr,expected_pi_s=field$expected_pi_s,
          expected_total_variance=field$expected_total_variance,
          mean_realized_total_variance=mean(realized_var),
          mcse_realized_total_variance=sd(realized_var)/sqrt(draws),
          required_draws_for_2pct_variance_mcse=ceiling(draws*
            (sd(realized_var)/sqrt(draws)/(.02*field$expected_total_variance))^2),
          covariance_relative_mc_error=norm(empirical-field$covariance,"F")/
            norm(field$covariance,"F"),
          required_draws_for_20pct_covariance_relative_error=ceiling(draws*
            (norm(empirical-field$covariance,"F")/
             norm(field$covariance,"F")/.20)^2),
          covariance_max_diagonal_relative_error=max(abs(diag(empirical)-
            diag(field$covariance)))/max(diag(field$covariance)),
          expected_moran_covariance_ratio=s4_moran_expected(field$covariance,cal$W),
          mean_realized_moran=observed_mean_moran,
          mcse_realized_moran=sd(realized_moran)/sqrt(draws),
          max_abs_covariate_field_correlation_mean=mean(apply(U,2,function(u)
            max(abs(cor(u,cal$data[,c("x1","x2","z")]))))))
        for(kind in c("innovation","trend")) {
          C <- if(kind=="innovation") field$covariance else field$spatial_covariance
          V <- if(kind=="innovation") U else S
          vb <- s4_variogram_checks(cal$xy,C,V,kind)
          vb$dataset <- id; vb$generator <- generator
          vb$pi_s <- p; vb$range_fraction <- r
          variograms[[length(variograms)+1L]] <- vb
        }
        # Condition both full innovation and latent spatial trend on selected
        # training-region sites, with no imposed value in held-out fold 3.
        for(kind in c("innovation","trend")) {
          target_C <- if(kind=="innovation") field$covariance else field$spatial_covariance
          observed <- s4_draw(target_C,970200L)[sites]
          q <- s4_conditional_draw(target_C,sites,observed,980000L)
          stopifnot(q$max_honor_error==0,all(cal$fold[q$sites]!=3L))
          set.seed(980100L)
          Q <- matrix(rnorm(length(q$free)*draws),length(q$free),draws)
          conditional_U <- q$conditional_mean+t(chol(q$conditional_covariance))%*%Q
          empirical_conditional_mean <- rowMeans(conditional_U)
          conditionals[[length(conditionals)+1L]] <- data.frame(dataset=id,
            generator=generator,variant=kind,pi_s=p,range_fraction=r,
            n_conditioning_sites=length(sites),n_test_region_conditioning_sites=0L,
            buffer_m=split$buffer,
            min_conditioning_test_distance_m=min_site_test_distance,
            max_honor_error=q$max_honor_error,
            max_conditional_mean_mc_error=max(abs(empirical_conditional_mean-
              q$conditional_mean)),
            mean_conditional_variance_expected=mean(diag(q$conditional_covariance)),
            mean_conditional_variance_empirical=mean(apply(conditional_U,1,var)),
            min_conditional_eigenvalue=min(eigen(q$conditional_covariance,
              symmetric=TRUE,only.values=TRUE)$values))
        }
      }
    }
  }
  summary <- do.call(rbind,rows); conditional <- do.call(rbind,conditionals)
  variogram <- do.call(rbind,variograms)
  write.csv(summary,file.path(output,"field_checks.csv"),row.names=FALSE)
  write.csv(conditional,file.path(output,"conditional_checks.csv"),row.names=FALSE)
  write.csv(variogram,file.path(output,"variogram_checks.csv"),row.names=FALSE)
  saveRDS(list(summary=summary,conditional=conditional,variogram=variogram),
          file.path(output,"results.rds"))
  writeLines(capture.output(sessionInfo()),file.path(output,"sessionInfo.txt"))
  stopifnot(all(conditional$max_honor_error==0),
            all(conditional$n_test_region_conditioning_sites==0),
            all(conditional$min_conditioning_test_distance_m>conditional$buffer_m),
            all(conditional$min_conditional_eigenvalue>0),
            all(is.finite(variogram$expected_semivariance)),
            all(is.finite(variogram$mcse_semivariance)))
  if(draws>=3000L) stopifnot(
    all(summary$mcse_realized_total_variance/
        summary$expected_total_variance<=.02),
    all(variogram$mcse_semivariance/
        variogram$expected_semivariance<=.05),
    all(summary$covariance_relative_mc_error<=.20))
  message(nrow(summary)," S4 source field checks; ",nrow(conditional),
          " conditional checks; ",nrow(variogram)," variogram bins; metric buffer")
  invisible(list(summary=summary,conditional=conditional,variogram=variogram))
}

if(sys.nframe()==0L) check_s4_sources()
