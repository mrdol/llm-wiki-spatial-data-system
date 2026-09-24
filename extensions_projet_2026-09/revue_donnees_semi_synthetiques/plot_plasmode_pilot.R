# Standalone scientific figure; whiskers show +/- one Monte Carlo standard error.
output <- "extensions_projet_2026-09/revue_donnees_semi_synthetiques/pilot_output_2026-09-08"
result <- readRDS(file.path(output,"results.rds"))
scenarios <- c("reference","omitted_z","curvature","interaction","measured_z","sem_positive","heteroskedastic_control")
labels <- c("Reference","Z omise","Courbure","Interaction","Z degradee","Bruit SEM","Variance variable")
methods <- c("linear","gam_covariates","gam_spatial")
colors <- c("#395e83","#ba6d2f","#288475")
png(file.path(output,"performance_pilote.png"),width=1600,height=1120,res=160)
par(mfrow=c(2,1),mar=c(4.2,5,3.2,1.5),oma=c(2,0,3,0),family="sans")
for(dataset in c("georgia","meuse")) {
  # Explicit indexing avoids data-mask ambiguity with the loop variable.
  all <- result$summary[result$summary$dataset==dataset & result$summary$role=="competitor",]
  plot(NA,xlim=c(.6,7.4),ylim=c(0,max(all$nmse_mean+all$mcse)*1.1),xaxt="n",
       xlab="",ylab="MSE / variance de la moyenne vraie",main=if(dataset=="georgia")"Georgia" else "Meuse")
  abline(h=pretty(c(0,max(all$nmse_mean+all$mcse))),col="#e5e5e5",lwd=.6)
  axis(1,at=1:7,labels=labels,cex.axis=.82)
  for(j in seq_along(methods)) {
    d <- all[all$method==methods[j],];d <- d[match(scenarios,d$scenario),]
    x <- seq_along(scenarios)+(j-2)*.14
    arrows(x,d$nmse_mean-d$mcse,x,d$nmse_mean+d$mcse,angle=90,code=3,length=.035,col=colors[j])
    points(x,d$nmse_mean,pch=15+j,col=colors[j],cex=1.05)
  }
  legend("topright",legend=c("Lineaire","GAM covariables","GAM + espace"),col=colors,pch=16:18,bty="n",cex=.9)
}
mtext("Plasmode : premiere evaluation par bandes spatiales",outer=TRUE,side=3,line=.6,font=2,cex=1.15)
mtext("20 repetitions ; barres = +/- 1 erreur standard Monte Carlo. Reference privilegiee exclue. Pas de verdict de superiorite.",outer=TRUE,side=1,line=.6,cex=.78)
dev.off()
cat("Figure written: performance_pilote.png\n")
