# Regenerate truth-only diagnostics from saved calibration without refitting competitors.
source("extensions_projet_2026-09/revue_donnees_semi_synthetiques/plasmode_pilot.R")
output <- file.path(pilot_dir,"pilot_output_2026-09-08")
result <- readRDS(file.path(output,"results.rds"))
for(i in seq_len(nrow(result$diagnostics))) {
  row <- result$diagnostics[i,]
  calibration <- readRDS(file.path(output,paste0(row$dataset,"_calibration.rds")))
  unexplained <- unexplained_signal(calibration,row$scenario)
  result$diagnostics$linear_unexplained_variance[i] <- var(unexplained)
  result$diagnostics$linear_unexplained_moran[i] <- moran_descriptive(unexplained,calibration$W)
}
saveRDS(result,file.path(output,"results.rds"))
jsonlite::write_json(result,file.path(output,"results.json"),auto_unbox=TRUE,pretty=TRUE,na="null",digits=10)
cat("Truth-only linear misspecification diagnostics refreshed.\n")
