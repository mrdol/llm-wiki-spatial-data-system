Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

hessling.argentina: Relation between wheat yield and weather in Argentina

Relation between wheat yield and weather in Argentina

Description

     Relation between wheat yield and weather in Argentina

Format

     A data frame with 30 observations on the following 15 variables.

     ‘yield’ average yield, kg/ha

     ‘year’ year

     ‘p05’ precipitation (mm) in May

     ‘p06’ precip in June

     ‘p07’ precip in July

     ‘p08’ precip in August

     ‘p09’ precip in Septempber

     ‘p10’ precip in October

     ‘p11’ precip in November

     ‘p12’ precip in December

     ‘t06’ june temperature deviation from normal, deg Celsius

     ‘t07’ july temp deviation

     ‘t08’ august temp deviation

     ‘t09’ september temp deviation

     ‘t10’ october temp deviation

     ‘t11’ november temp deviation

Details

     In Argentina wheat is typically sown May to August.  Harvest
     begins in November or December.

Source

     N. A. Hessling, 1922.  Relations between the weather and the yield
     of wheat in the Argentine republic, _Monthly Weather Review_, 50,
     302-308.
     https://doi.org/10.1175/1520-0493(1922)50<302:RBTWAT>2.0.CO;2


Variables detected from installed object

yield: integer ; missing=0 ; examples=703, 742, 996

year: integer ; missing=0 ; examples=1890, 1891, 1892

p05: integer ; missing=0 ; examples=26, 51, 11

p06: integer ; missing=0 ; examples=2, 43

p07: integer ; missing=0 ; examples=35, 53, 26

p08: integer ; missing=0 ; examples=25, 64, 56

p09: integer ; missing=0 ; examples=4, 21, 5

p10: integer ; missing=0 ; examples=31, 85, 87

p11: integer ; missing=0 ; examples=83, 67, 87

p12: integer ; missing=0 ; examples=88, 50

t06: numeric ; missing=0 ; examples=-1.2, 0.6, -2

t07: numeric ; missing=0 ; examples=0.2, -0.9, 0.5

t08: numeric ; missing=0 ; examples=-1.1, 0.8

t09: numeric ; missing=0 ; examples=-1.4, 0.2, -0.7

t10: numeric ; missing=0 ; examples=0.7, 0, 0.3

t11: numeric ; missing=0 ; examples=1.8, 0.2, -0.6

Examples
Run this code

     ## Not run:

     library(agridat)
     data(hessling.argentina)
     dat <- hessling.argentina

     # Fig 1 of Hessling.  Use avg Aug-Nov temp to predict yield
     dat <- transform(dat, avetmp=(t08+t09+t10+t11)/4) # Avg temp
     m0 <- lm(yield ~ avetmp, dat)
     plot(yield~year, dat, ylim=c(100,1500), type='l',
     main="hessling.argentina: observed (black) and predicted yield (blue)")
     lines(fitted(m0)~year, dat, col="blue")

     # A modern, PLS approach
     libs(pls)
     yld <- dat[,"yield",drop=FALSE]
     yld <- as.matrix(sweep(yld, 2, colMeans(yld)))
     cov <- dat[,c("p06","p07","p08","p09","p10","p11", "t08","t09","t10","t11")]
     cov <- as.matrix(scale(cov))
     m2 <- plsr(yld~cov)

     # biplot(m2, which="x", var.axes=TRUE, main="hessling.argentina")

     libs(corrgram)
     corrgram(dat, main="hessling.argentina - correlations of yield and covariates")
     ## End(Not run)

