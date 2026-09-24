# Run from repository root after priorites_plasmode.R.
base <- "extensions_projet_2026-09/revue_donnees_semi_synthetiques/priority_output_2026-09-09"
r <- readRDS(file.path(base,"results.rds"))$results
png(file.path(base,"sensibilite_et_observation.png"),width=1600,height=760,res=150)
par(mfrow=c(1,2),mar=c(4.5,8.2,4,1.2),mgp=c(2.8,.8,0))
d <- subset(r$paired_contrasts,contrast=="forest - polynomial")
d <- d[order(d$dataset,match(d$generator,c("polynomial","forest"))),]
y <- rev(seq_len(nrow(d))); colors <- ifelse(d$generator=="forest","#b65325","#236b9c")
lower <- d$difference-1.96*d$mcse; upper <- d$difference+1.96*d$mcse
plot(d$difference,y,xlim=range(c(lower,upper)),ylim=c(.5,4.5),yaxt="n",pch=19,col=colors,
     xlab="NMSE foret - NMSE polynome",ylab="",main="Sensibilite au generateur",cex.main=1.05)
axis(2,at=y,labels=paste(tools::toTitleCase(d$dataset),d$generator,sep=" / "),las=1,cex.axis=.85)
abline(v=0,lty=2,col="grey50")
segments(lower,y,upper,y,col=colors,lwd=2)
points(d$difference,y,pch=19,col=colors,cex=1.2)
mtext("40 repetitions ; barres = moyenne +/- 1,96 MCSE",side=3,line=.4,cex=.75)
par(mar=c(4.5,4.5,4,1.2))
plot(NA,xlim=c(0,.5),ylim=c(-.04,.43),xlab="Intensite du lissage alpha",ylab="Moran moyen du bruit observe",
     main="Covariance creee par l'observation",cex.main=1.05)
for(i in seq_along(c("georgia","meuse"))) {
  id <- c("georgia","meuse")[i]; z <- subset(r$smoothing,dataset==id)
  col <- c("#236b9c","#b65325")[i]
  lines(z$alpha,z$mean_moran,type="b",col=col,pch=c(16,17)[i],lwd=2)
  lines(z$alpha,z$independent_mean_moran,col=col,lty=2)
}
abline(h=0,lty=3,col="grey60")
legend("topleft",legend=c("Georgia : supports recouvrants","Meuse : supports recouvrants","Controles independants, memes variances"),
       col=c("#236b9c","#b65325","grey35"),lty=c(1,1,2),pch=c(16,17,NA),bty="n",cex=.77)
mtext("10 000 tirages ; mecanisme latent sans propagation",side=3,line=.4,cex=.75)
dev.off()
