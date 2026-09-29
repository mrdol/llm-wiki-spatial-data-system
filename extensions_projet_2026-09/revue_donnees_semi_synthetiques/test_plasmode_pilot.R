source("extensions_projet_2026-09/revue_donnees_semi_synthetiques/plasmode_pilot.R")
for (id in c("georgia","meuse")) {
  c <- calibrate_source(load_source(id))
  stopifnot(!length(intersect(c$calibration,c$evaluation)),
            length(c$calibration)+length(c$evaluation)==nrow(c$source$data),
            max(abs(rowSums(c$W)-1))<1e-12,all(diag(c$W)==0),
            all(table(c$fold)>20),all(is.finite(coef(c$generator))))
  a <- generate_draw(c,"reference",17L)
  b <- generate_draw(c,"omitted_z",17L)
  stopifnot(identical(a,generate_draw(c,"reference",17L)),
            identical(a$m,b$m),identical(a$u,b$u),identical(a$observed$y,b$observed$y),
            !"z" %in% names(b$observed),"z" %in% names(b$latent),
            max(abs(a$observed$y-a$m-a$u))<1e-12)
  measured <- generate_draw(c,"measured_z",17L)
  stopifnot(identical(a$m,measured$m),identical(a$observed$y,measured$observed$y),
            !identical(a$observed$z,measured$observed$z),
            identical(measured$latent$z,a$latent$z))
  complete <- c$pieces$base+c$pieces$curvature+c$pieces$interaction
  stopifnot(max(abs(complete-as.numeric(predict(c$generator,c$data))))<1e-10)
  source_tampered <- c$source
  source_tampered$data$y[c$evaluation] <- 1e12
  stopifnot(identical(coef(c$generator),coef(calibrate_source(source_tampered)$generator)),
            max(abs(unexplained_signal(c,"reference")))<1e-10)
  for(scenario in c("reference","sem_positive","heteroskedastic_control")) {
    d <- generate_draw(c,scenario,3L)
    covariance <- d$sigma^2 * tcrossprod(d$B)
    stopifnot(abs(var(d$m)/mean(diag(covariance))-3)<1e-10)
    if(scenario=="heteroskedastic_control") {
      stopifnot(sd(diag(covariance))>0,max(abs(covariance[row(covariance)!=col(covariance)]))<1e-12)
    }
    if(scenario=="sem_positive") stopifnot(max(abs(covariance[row(covariance)!=col(covariance)]))>0)
  }
  # No held-out Y is used in fitting or predicting: perturb it and compare.
  train <- which(c$fold!=1); test <- which(c$fold==1)
  tampered <- b$observed[test,];tampered$y <- 1e12
  for(method in c("linear","gam_covariates","gam_spatial")) {
    p1 <- fit_predict(method,b$observed[train,],b$observed[test,])
    p2 <- fit_predict(method,b$observed[train,],tampered)
    stopifnot(identical(p1,p2),all(is.finite(p1)))
  }
}
cat("PASS: source alignment, disjoint calibration/evaluation, weights, reproducibility, omission/proxy invariants, generator truth, noise covariance/SNR and no test-Y leakage.\n")
