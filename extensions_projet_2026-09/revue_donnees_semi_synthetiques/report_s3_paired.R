# Report paired S3 contrasts from a completed central run; no estimator ranking.
source_path <- "extensions_projet_2026-09/revue_donnees_semi_synthetiques/scenario_s3_central_paired_2026-09-15/results.rds"
output <- dirname(source_path)
raw <- readRDS(source_path)$results$raw
stopifnot(!any(raw$failed),all(raw$density==.4),all(raw$measurement==0))
expected_seed <- 915000L+match(raw$dataset,c("georgia","meuse"))*100000L+
  match(raw$generator,c("polynomial","forest"))*10000L+raw$replication*1000000L
if("seed"%in%names(raw))stopifnot(identical(raw$seed,expected_seed))
raw$seed <- expected_seed

contrast <- function(first,second,first_filter,second_filter,keys,label) {
  a <- first_filter(raw); b <- second_filter(raw)
  joined <- merge(a,b,by=keys,suffixes=c("_first","_second"))
  stopifnot(nrow(joined)==1600L,all(joined$seed_first==joined$seed_second))
  joined$difference <- joined$nmse_mean_first-joined$nmse_mean_second
  groups <- split(joined,interaction(joined$dataset,joined$generator,
    joined[[if(label=="transfer_minus_known")"interpolation" else "task"]],
    joined$method,drop=TRUE))
  do.call(rbind,lapply(groups,function(d) data.frame(contrast=label,
    dataset=d$dataset[1],generator=d$generator[1],
    context=d[[if(label=="transfer_minus_known")"interpolation" else "task"]][1],
    method=d$method[1],repetitions=nrow(d),difference=mean(d$difference),
    mcse=sd(d$difference)/sqrt(nrow(d)))))
}

transfer <- contrast("transfer","known",
  function(d)subset(d,task=="geographic_transfer"),
  function(d)subset(d,task=="known_network"),
  c("dataset","generator","density","interpolation","measurement","replication","method"),
  "transfer_minus_known")
interpolation <- contrast("kriging","idw",
  function(d)subset(d,interpolation=="kriging"),
  function(d)subset(d,interpolation=="idw"),
  c("dataset","generator","density","task","measurement","replication","method"),
  "kriging_minus_idw")
result <- rbind(transfer,interpolation)
write.csv(result,file.path(output,"paired_contrasts.csv"),row.names=FALSE)
jsonlite::write_json(result,file.path(output,"paired_contrasts.json"),pretty=TRUE,
                     auto_unbox=TRUE,digits=12)
cat("PASS:",nrow(result),"paired contrasts; transfer gap positive in",
    sum(transfer$difference>0),"of",nrow(transfer),"settings\n")
