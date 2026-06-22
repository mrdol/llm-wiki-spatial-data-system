Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

procella: Phylogeny and quantitative traits of birds

Phylogeny and quantitative traits of birds

Description

     This data set describes the phylogeny of 19 birds as reported by
     Bried et al. (2002). It also gives 6 traits corresponding to these
     19 species.

Usage

     data(procella)

Format

     ‘procella’ is a list containing the 2 following objects:

     tre is a character string giving the phylogenetic tree in Newick
          format.

     traits is a data frame with 19 species and 6 traits

Details

     Variables of ‘procella$traits’ are the following ones:
     site.fid: a numeric vector that describes the percentage of site
     fidelity
     mate.fid: a numeric vector that describes the percentage of mate
     fidelity
     mass: an integer vector that describes the adult body weight (g)
     ALE: a numeric vector that describes the adult life expectancy
     (years)
     BF: a numeric vector that describes the breeding frequencies
     col.size: an integer vector that describes the colony size (no
     nests monitored)

References

     Bried, J., Pontier, D. and Jouventin, P. (2002) Mate fidelity in
     monogamus birds: a re-examination of the Procellariiformes.
     _Animal Behaviour_, *65*, 235-246.

     See a data description at
     <http://pbil.univ-lyon1.fr/R/pdf/pps037.pdf> (in French).

Examples
Run this code

     data(procella)
     pro.phy <- newick2phylog(procella$tre)
     plot(pro.phy,clabel.n = 1, clabel.l = 1)
     wt <- procella$traits
     wt$site.fid[is.na(wt$site.fid)] <- mean(wt$site.fid[!is.na(wt$site.fid)])
     wt$site.fid <- asin(sqrt(wt$site.fid/100))
     wt$ALE[is.na(wt$ALE)] <- mean(wt$ALE[!is.na(wt$ALE)])
     wt$ALE <- sqrt(wt$ALE)
     wt$BF[is.na(wt$BF)] <- mean(wt$BF[!is.na(wt$BF)])
     wt$mass <- log(wt$mass)
     wt <- wt[, -6]
     table.phylog(scalewt(wt), pro.phy, csi = 2)
     gearymoran(pro.phy$Amat,wt,9999)

