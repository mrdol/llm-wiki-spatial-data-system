Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

monde84: Global State of the World in 1984

Global State of the World in 1984

Description

     The ‘monde84’ data frame gives five demographic variables for 48
     countries in the world.

Usage

     data(monde84)

Format

     This data frame contains the following columns:

       1. pib: Gross Domestic Product

       2. croipop: Growth of the population

       3. morta: Infant Mortality

       4. anal: Literacy Rate

       5. scol: Percentage of children in full-time education

Source

     Geze, F. and Coll., eds. (1984) _L'état du Monde 1984 : annuaire
     économique et géopolitique mondial_. La Découverte, Paris.


Variables detected from installed object

pib: numeric ; missing=0 ; examples=2680, 2266, 2264

croipop: numeric ; missing=0 ; examples=29, 12

morta: numeric ; missing=0 ; examples=89, 114, 44

anal: numeric ; missing=0 ; examples=50, 59, 5

scol: numeric ; missing=0 ; examples=19, 48, 70

Examples
Run this code

     data(monde84)
     X <- cbind.data.frame(lpib = log(monde84$pib), monde84$croipop)
     Y <- cbind.data.frame(lmorta = log(monde84$morta),
         lanal = log(monde84$anal + 1), rscol = sqrt(100 - monde84$scol))
     pcaY <- dudi.pca(Y, scan = FALSE)
     pcaiv1 <- pcaiv(pcaY, X0 <- scale(X), scan = FALSE)
     sum(cor(pcaiv1$l1[,1], Y0 <- scale(Y))^2)
     pcaiv1$eig[1] #the same

