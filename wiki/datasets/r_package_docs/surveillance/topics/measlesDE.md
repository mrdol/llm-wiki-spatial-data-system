Rdocumentation
powered by

Search all packages and functions
surveillance (version 1.25.0)

measlesDE: Measles in the 16 states of Germany

Measles in the 16 states of Germany

Description

     Weekly number of measles cases in the 16 states (Bundeslaender) of
     Germany for years 2005 to 2007.

Usage

     data(measlesDE)

Format

     An ‘"sts"’ object containing 156 x 16 observations starting from
     week 1 in 2005.

     The ‘population’ slot contains the population fractions of each
     state at 31.12.2006, obtained from the Federal Statistical Office
     of Germany.

Source

     Robert Koch-Institut: SurvStat: <https://survstat.rki.de/>;
     Queried on 14 October 2009.

References

     Herzog, S. A., Paul, M. and Held, L. (2011): Heterogeneity in
     vaccination coverage explains the size and occurrence of measles
     epidemics in German surveillance data.  _Epidemiology and
     Infection_, *139*, 505-515.  doi:10.1017/S0950268810001664
     <https://doi.org/10.1017/S0950268810001664>

See Also

     ‘MMRcoverageDE’

Examples
Run this code

     data(measlesDE)
     plot(measlesDE)

     ## aggregate to bi-weekly intervals
     measles2w <- aggregate(measlesDE, nfreq = 26)
     plot(measles2w, ~time)

     ## use a date index for nicer x-axis plotting
     epoch(measles2w) <- seq(as.Date("2005-01-03"), by = "2 weeks",
                             length.out = nrow(measles2w))
     plot(measles2w, ~time)

