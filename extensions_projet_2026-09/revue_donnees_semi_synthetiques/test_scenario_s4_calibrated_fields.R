source("extensions_projet_2026-09/revue_donnees_semi_synthetiques/scenario_s4_calibrated_fields.R")
xy <- as.matrix(expand.grid(x=seq(0,1,length.out=5),y=seq(0,1,length.out=4)))
m <- seq_len(nrow(xy))+.2*sin(seq_len(nrow(xy)))
f <- s4_calibrate(xy,m,snr=3,pi_s=.2,range_fraction=.25)
stopifnot(abs(f$expected_snr-3)<1e-10,abs(f$expected_pi_s-.2)<1e-10,
          abs(f$effective_range/max(as.matrix(dist(xy)))-.25)<1e-10,
          f$min_eigenvalue>0,f$nugget_fraction>0)
f0 <- s4_calibrate(xy,m,snr=3,pi_s=0,range_fraction=.25)
stopifnot(max(abs(f0$spatial_covariance))==0,
          max(abs(f0$covariance-diag(f0$nugget,nrow(xy))))<1e-12)
bad <- try(s4_calibrate(xy,m,snr=3,pi_s=.5),silent=TRUE)
stopifnot(inherits(bad,"try-error"))
t <- s4_calibrate_trend(xy,m,snr=3,pi_s=.2,range_fraction=.25)
stopifnot(abs(t$expected_snr-3)<1e-10,abs(t$expected_pi_s-.2)<1e-10,
          abs(t$epsilon_variance-f$nugget)<1e-10,
          max(abs(t$covariance-f$covariance))<1e-10,
          min(eigen(t$trend_covariance,symmetric=TRUE,only.values=TRUE)$values)>0)
stopifnot(inherits(try(s4_calibrate_trend(xy,m,snr=3,pi_s=.5),silent=TRUE),"try-error"))
stopifnot(!identical(s4_draw(t$trend_covariance,940126L),
                     s4_draw(t$trend_covariance,940127L)))

a <- s4_draw(f$covariance,940123L)
stopifnot(identical(a,s4_draw(f$covariance,940123L)))
sites <- c(2L,7L,13L)
q <- s4_conditional_draw(f$covariance,sites,a[sites],940124L)
stopifnot(q$max_honor_error==0,
          identical(q$draw[sites],a[sites]),
          identical(q$draw,s4_conditional_draw(f$covariance,sites,a[sites],940124L)$draw),
          min(eigen(q$conditional_covariance,symmetric=TRUE,only.values=TRUE)$values)>0)

# Independent draws recover the designed covariance, including its off-diagonal structure.
set.seed(940125L)
Z <- matrix(rnorm(nrow(xy)*5000L),nrow(xy),5000L)
U <- t(chol(f$covariance))%*%Z
empirical <- tcrossprod(sweep(U,1,rowMeans(U),"-"))/(ncol(U)-1L)
stopifnot(norm(empirical-f$covariance,"F")/norm(f$covariance,"F")<.08)
for(id in c("georgia","meuse")) {
  cal <- calibrate_source(load_source(id))
  splits <- s4_buffer_splits(cal$xy,cal$fold)
  stopifnot(length(splits)==3L,all(vapply(splits,function(s)
    length(s$train)>=20L && s$min_train_test_distance>s$buffer,logical(1))))
  s <- splits[["3"]]
  for(fold in seq_along(splits)) {
    sf <- splits[[as.character(fold)]]
    field <- s4_calibrate(cal$xy,seq_len(nrow(cal$xy)),pi_s=.1)
    qf <- s4_conditional_field_by_fold(field$spatial_covariance,sf,
      940700L+fold,940800L+fold)
    plan <- s4_conditioning_plan(field$spatial_covariance,sf,940700L+fold)
    qp <- s4_conditioning_plan_draw(plan,940800L+fold)
    D <- as.matrix(dist(cal$xy))
    stopifnot(qf$max_honor_error==0,
      identical(qf$draw[qf$sites],qf$observed),
      !length(intersect(qf$sites,sf$test)),
      all(qf$sites %in% sf$train),
      min(D[qf$sites,sf$test,drop=FALSE])>sf$buffer,
      identical(qf$draw,s4_conditional_field_by_fold(
        field$spatial_covariance,sf,940700L+fold,940800L+fold)$draw),
      isTRUE(all.equal(qf$draw,qp$draw,tolerance=1e-12)),
      identical(qf$sites,qp$sites))
    q0 <- s4_conditional_field_by_fold(matrix(0,nrow(D),ncol(D)),sf,
      940700L+fold,940800L+fold)
    stopifnot(all(q0$draw==0),q0$max_honor_error==0)
  }
  train <- cal$data[s$train,,drop=FALSE]
  test <- cal$data[s$test,,drop=FALSE]
  a <- predict_competitor("linear",train,test,940301L)
  test$y <- 1e9
  stopifnot(identical(a,predict_competitor("linear",train,test,940301L)))
}
banff <- s4_load_source("banff")
stopifnot(banff$n_source==110L,
  identical(unname(banff$mapping),c("WaterTemp","Elev","RSlope","LE")),
  !anyDuplicated(as.data.frame(banff$xy)),
  all(complete.cases(banff$data,banff$xy)))
banff_cal <- calibrate_source(banff)
banff_splits <- s4_buffer_splits(banff_cal$xy,banff_cal$fold)
stopifnot(nrow(banff_cal$data)==74L,length(banff_splits)==3L,
  all(vapply(banff_splits,function(s) length(s$train)>=20L &&
    s$min_train_test_distance>s$buffer,logical(1))))
message("PASS: S4 calibration, conditioning, covariance, metric buffers and response isolation.")
