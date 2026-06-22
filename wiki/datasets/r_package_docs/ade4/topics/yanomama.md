Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

yanomama: Distance Matrices

Distance Matrices

Description

     This data set gives 3 matrices about geographical, genetic and
     anthropometric distances.

Usage

     data(yanomama)

Format

     ‘yanomama’ is a list of 3 components:

     geo is a matrix of 19-19 geographical distances

     gen is a matrix of 19-19 SFA (genetic) distances

     ant is a matrix of 19-19 anthropometric distances

Source

     Spielman, R.S. (1973) Differences among Yanomama Indian villages:
     do the patterns of allele frequencies, anthropometrics and map
     locations correspond?  _American Journal of Physical
     Anthropology_, *39*, 461-480.

References

     Table 7.2 Distance matrices for 19 villages of Yanomama Indians.
     All distances are as given by Spielman (1973), multiplied by 100
     for convenience in: Manly, B.F.J. (1991) _Randomization and Monte
     Carlo methods in biology_ Chapman and Hall, London, 1-281.

Examples
Run this code

         data(yanomama)
         gen <- quasieuclid(as.dist(yanomama$gen)) # depends of mva
         ant <- quasieuclid(as.dist(yanomama$ant)) # depends of mva
         par(mfrow = c(2,2))
         plot(gen, ant)
         t1 <- mantel.randtest(gen, ant, 99);
         plot(t1, main = "gen-ant-mantel") ; print(t1)
         t1 <- procuste.rtest(pcoscaled(gen), pcoscaled(ant), 99)
         plot(t1, main = "gen-ant-procuste") ; print(t1)
         t1 <- RV.rtest(pcoscaled(gen), pcoscaled(ant), 99)
         plot(t1, main = "gen-ant-RV") ; print(t1)

