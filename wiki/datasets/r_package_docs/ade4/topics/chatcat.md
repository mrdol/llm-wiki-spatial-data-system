Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

chatcat: Qualitative Weighted Variables

Qualitative Weighted Variables

Description

     This data set gives the age, the fecundity and the number of
     litters for 26 groups of cats.

Usage

     data(chatcat)

Format

     ‘chatcat’ is a list of two objects :

     tab is a data frame with 3 factors (age, feco, nport).

     eff is a vector of numbers.

Details

     One row of ‘tab’ corresponds to one group of cats.
     The value in ‘eff’ is the number of cats in this group.

Source

     Pontier, D. (1984) _Contribution à la biologie et à la génétique
     des populations de chats domestiques (Felis catus)._ Thèse de 3ème
     cycle. Université Lyon 1, p. 67.

Examples
Run this code

     data(chatcat)
     summary(chatcat$tab)
     w <- acm.disjonctif(chatcat$tab) #  Disjonctive table
     names(w) <- c(paste("A", 1:5, sep = ""), paste("B", 1:5, sep = ""),
         paste("C", 1:2, sep = ""))
     w <- t(w*chatcat$num) %*% as.matrix(w)
     w <- data.frame(w)
     w # BURT table

