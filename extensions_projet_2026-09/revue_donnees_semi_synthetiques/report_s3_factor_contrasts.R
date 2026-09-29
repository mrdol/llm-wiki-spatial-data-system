# Paired comparisons for the S3 density/measurement experiment.
path <- "extensions_projet_2026-09/revue_donnees_semi_synthetiques/scenario_s3_network_noise_2026-09-15/results.rds"
raw <- readRDS(path)$results$raw
stopifnot(!any(raw$failed),nrow(raw)==12800L,"seed"%in%names(raw))

paired <- function(first,second,keys,context,label) {
  a <- first(raw); b <- second(raw)
  joined <- merge(a,b,by=keys,suffixes=c("_first","_second"))
  stopifnot(nrow(joined)>0L,all(joined$seed_first==joined$seed_second))
  joined$difference <- joined$nmse_mean_first-joined$nmse_mean_second
  groups <- split(joined,interaction(joined$dataset,joined$generator,
    joined[[context]],joined$method,drop=TRUE))
  do.call(rbind,lapply(groups,function(d)data.frame(contrast=label,
    dataset=d$dataset[1],generator=d$generator[1],context=d[[context]][1],
    method=d$method[1],repetitions=nrow(d),difference=mean(d$difference),
    mcse=sd(d$difference)/sqrt(nrow(d)))))
}

# Each context row averages over the other two controlled factors; all draws remain paired.
transfer <- paired(function(d)subset(d,task=="geographic_transfer"),
  function(d)subset(d,task=="known_network"),
  c("dataset","generator","density","interpolation","measurement","replication","method"),
  "density","transfer_minus_known")
high_density <- paired(function(d)subset(d,density==.7),
  function(d)subset(d,density==.2),
  c("dataset","generator","task","interpolation","measurement","replication","method"),
  "task","density_70_minus_20")
noisy <- paired(function(d)subset(d,measurement==.25),
  function(d)subset(d,measurement==0),
  c("dataset","generator","density","task","interpolation","replication","method"),
  "task","noisy_minus_exact")
result <- rbind(transfer,high_density,noisy)
out <- dirname(path)
write.csv(result,file.path(out,"factor_contrasts.csv"),row.names=FALSE)
jsonlite::write_json(result,file.path(out,"factor_contrasts.json"),pretty=TRUE,
                     auto_unbox=TRUE,digits=12)
cat("PASS:",nrow(result),"paired factor contrasts; transfer gap positive in",
    sum(transfer$difference>0),"of",nrow(transfer),"contexts\n")
