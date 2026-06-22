Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

nagai.strawberry.uniformity: Uniformity trial of strawberry

Uniformity trial of strawberry

Description

     Uniformity trial of strawberry in Brazil.

Usage

     data("nagai.strawberry.uniformity")

Format

     A data frame with 432 observations on the following 3 variables.

     ‘row’ row

     ‘col’ column

     ‘yield’ yield, grams/plot

Details

     A uniformity trial of strawberry, at Jundiai, Brazil, in April
     1976.

     The spacing between plants and rows was 0.3 m. Test area was
     233.34 m^2.  There were 18 rows of 144 plants. Each plat consisted
     of 6 consecutive plants.  There were 432 plats, each 0.54 m^2.

     Field length: 18 rows * 0.3 m = 5.4 m.

     Field width: 24 columns * 6 plants * 0.3 m = 43.2 m.

Source

     Violeta Nagai (1978).  Tamanho da parcela e numero de repeticoes
     em experimentos com morangueiro (Plot size and number of
     repetitions in experiments with strawberry).  Bragantia, 37,
     71-81. Table 2, page 75.
     https://dx.doi.org/10.1590/S0006-87051978000100009

References

     None


Variables detected from installed object

row: integer ; missing=0 ; examples=1, 2, 3

col: integer ; missing=0 ; examples=1

yield: integer ; missing=0 ; examples=1750, 1978, 1675

Examples
Run this code

     ## Not run:

     library(agridat)

       data(nagai.strawberry.uniformity)
       dat <- nagai.strawberry.uniformity

       # CV matches Nagai
       # with(dat, sd(yield)/mean(yield))
       # 23.42

       libs(desplot)
       desplot(dat, yield ~ col*row,
               flip=TRUE, aspect=(5.4)/(43.2), # true aspect
               main="nagai.strawberry.uniformity")
     ## End(Not run)

