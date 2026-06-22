Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

whiteside: House Insulation: Whiteside's Data

House Insulation: Whiteside's Data

Description

     Mr Derek Whiteside of the UK Building Research Station recorded
     the weekly gas consumption and average external temperature at his
     own house in south-east England for two heating seasons, one of 26
     weeks before, and one of 30 weeks after cavity-wall insulation was
     installed. The object of the exercise was to assess the effect of
     the insulation on gas consumption.

Usage

     whiteside

Format

     The ‘whiteside’ data frame has 56 rows and 3 columns.:

     ‘Insul’ A factor, before or after insulation.

     ‘Temp’ Purportedly the average outside temperature in degrees
          Celsius. (These values is far too low for any 56-week period
          in the 1960s in South-East England. It might be the weekly
          average of daily minima.)

     ‘Gas’ The weekly gas consumption in 1000s of cubic feet.

Source

     A data set collected in the 1960s by Mr Derek Whiteside of the UK
     Building Research Station. Reported by

     Hand, D. J., Daly, F., McConway, K., Lunn, D. and Ostrowski, E.
     eds (1993) _A Handbook of Small Data Sets._ Chapman & Hall, p. 69.

References

     Venables, W. N. and Ripley, B. D. (2002) _Modern Applied
     Statistics with S._ Fourth edition.  Springer.


Variables detected from installed object

Insul: factor ; missing=0 ; examples=Before

Temp: numeric ; missing=0 ; examples=-0.8, -0.7, 0.4

Gas: numeric ; missing=0 ; examples=7.2, 6.9, 6.4

Examples
Run this code

     require(lattice)
     xyplot(Gas ~ Temp | Insul, whiteside, panel =
       function(x, y, ...) {
         panel.xyplot(x, y, ...)
         panel.lmline(x, y, ...)
       }, xlab = "Average external temperature (deg. C)",
       ylab = "Gas consumption  (1000 cubic feet)", aspect = "xy",
       strip = function(...) strip.default(..., style = 1))

     gasB <- lm(Gas ~ Temp, whiteside, subset = Insul=="Before")
     gasA <- update(gasB, subset = Insul=="After")
     summary(gasB)
     summary(gasA)
     gasBA <- lm(Gas ~ Insul/Temp - 1, whiteside)
     summary(gasBA)

     gasQ <- lm(Gas ~ Insul/(Temp + I(Temp^2)) - 1, whiteside)
     coef(summary(gasQ))

     gasPR <- lm(Gas ~ Insul + Temp, whiteside)
     anova(gasPR, gasBA)
     options(contrasts = c("contr.treatment", "contr.poly"))
     gasBA1 <- lm(Gas ~ Insul*Temp, whiteside)
     coef(summary(gasBA1))

