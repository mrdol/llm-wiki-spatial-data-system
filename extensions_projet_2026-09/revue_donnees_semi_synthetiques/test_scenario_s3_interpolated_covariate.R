source("extensions_projet_2026-09/revue_donnees_semi_synthetiques/scenario_s3_interpolated_covariate.R")

for(id in c("georgia","meuse")) {
  cal <- calibrate_source(load_source(id))
  ordering <- maximin_order(cal$xy,23L)
  small <- network_indices(ordering,.2); medium <- network_indices(ordering,.4)
  large <- network_indices(ordering,.7)
  stopifnot(all(small%in%medium),all(medium%in%large),
            identical(ordering,maximin_order(cal$xy,23L)))
  for(interpolation in c("idw","kriging")) {
    known <- make_s3_surface(cal,ordering,.4,"known_network",interpolation,0,42L)
    stopifnot(max(abs(known$value[medium]-cal$data$z[medium]))<1e-10)
    transfer <- make_s3_surface(cal,ordering,.4,"geographic_transfer",interpolation,0,42L)
    for(k in 1:3) {
      stations <- transfer$models[[k]]$stations
      stopifnot(!any(cal$fold[stations]==k),
                all(is.finite(transfer$models[[k]]$value)))
    }
  }
  stations <- network_indices(ordering,.4)
  model <- kriging_surface(cal$xy,stations,cal$data$z[stations])
  conditional <- conditional_covariate_draws(cal$xy,stations,cal$data$z[stations],
    model$variogram,draws=30L,seed=91L)
  stopifnot(max(abs(conditional$draws[stations,]-cal$data$z[stations]))<1e-12,
            all(is.finite(conditional$draws)),
            max(abs(conditional$covariance-t(conditional$covariance)))<1e-10,
            identical(conditional$draws,conditional_covariate_draws(cal$xy,stations,
              cal$data$z[stations],model$variogram,draws=30L,seed=91L)$draws))
  # Test-region truth cannot change a transfer surface if permitted station values stay fixed.
  original <- make_s3_surface(cal,ordering,.4,"geographic_transfer","idw",0,42L)
  changed <- cal; changed$data$z[cal$fold==1L] <- 1e9
  altered <- make_s3_surface(changed,ordering,.4,"geographic_transfer","idw",0,42L)
  stopifnot(identical(original$models[[1]]$value,altered$models[[1]]$value))
}
cat("PASS: S3 nested maximin networks, measured-site recovery and geographic-transfer isolation.\n")
