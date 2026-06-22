Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

tortues: Morphological Study of the Painted Turtle

Morphological Study of the Painted Turtle

Description

     This data set gives a morphological description (4 characters) of
     48 turtles.

Usage

     data(tortues)

Format

     a data frame with 48 rows and 4 columns (length (mm), maximum
     width(mm), height (mm), gender).

Source

     Jolicoeur, P. and Mosimann, J. E. (1960) Size and shape variation
     in the painted turtle. A principal component analysis. _Growth_,
     *24*, 339-354.


Variables detected from installed object

long: numeric ; missing=0 ; examples=93, 94, 96

larg: numeric ; missing=0 ; examples=74, 78, 80

haut: numeric ; missing=0 ; examples=37, 35

sexe: factor ; missing=0 ; examples=M

Examples
Run this code

     data(tortues)
     xyz <- as.matrix(tortues[, 1:3])
     ref <- -svd(xyz)$u[, 1]
     pch0 <- c(1, 20)[as.numeric(tortues$sexe)]
     plot(ref, xyz[, 1], ylim = c(40, 180), pch = pch0)
     abline(lm(xyz[, 1] ~ -1 + ref))
     points(ref,xyz[, 2], pch = pch0)
     abline(lm(xyz[, 2] ~ -1 + ref))
     points(ref,xyz[, 3], pch = pch0)
     abline(lm(xyz[, 3] ~ -1 + ref))

