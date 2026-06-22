Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

USCrudes: US Crudes Data

US Crudes Data

Description

     Cross-section data originating from 99 US oil field postings.

Usage

     data("USCrudes")

Format

     A data frame containing 99 observations on 3 variables.

     price Crude prices (USD/barrel).

     gravity Gravity (degree API).

     sulphur Sulphur (in %).

Source

     The data is from Baltagi (2002).

References

     Baltagi, B.H. (2002). _Econometrics_, 3rd ed. Berlin, Springer.

See Also

     ‘Baltagi2002’


Variables detected from installed object

price: numeric ; missing=0 ; examples=13.86, 16.82, 13.65

gravity: numeric ; missing=0 ; examples=14.8, 31.7, 13.7

sulphur: numeric ; missing=0 ; examples=2, 0.7, 1

Examples
Run this code

     data("USCrudes")
     plot(price ~ gravity, data = USCrudes)
     plot(price ~ sulphur, data = USCrudes)
     fm <- lm(price ~ sulphur + gravity, data = USCrudes)

     ## 3D Visualization
     library("scatterplot3d")
     s3d <- scatterplot3d(USCrudes[, 3:1], pch = 16)
     s3d$plane3d(fm, lty.box = "solid", col = 4)

