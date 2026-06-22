Rdocumentation
powered by

Search all packages and functions
HistData (version 1.0.0)

Halley's Breslau Life Table

Description

     Edmond Halley published his Breslau life table in 1693, which was
     arguably the first in the world based on population data. David
     Bellhouse (2011) resurrected the original sources of these data,
     collected by Caspar Neumann in the city of Breslau (now called
     Wroclaw), and then reconstructed in the 1880s by Jonas Graetzer,
     the medical officer in Breslau at that time.

Format

     A data frame with 100 observations on the following 8 variables.
     The ‘yearXXXX’ variables give the number of deaths for persons of
     a given ‘age’ recorded in that year.

     ‘age’ a numeric vector

     ‘year1687’ a numeric vector

     ‘year1688’ a numeric vector

     ‘year1689’ a numeric vector

     ‘year1690’ a numeric vector

     ‘year1691’ a numeric vector

     ‘total’ a numeric vector

     ‘average’ a numeric vector

Details

     The dataset here follows Graetzer, and gives the number of deaths
     at ages ‘1:100’ recorded in each of the years ‘1687:1691’.
     Halley's analysis was based on the total over those years.

     This dataset was kindly provided by David Bellhouse.

Source

     Bellhouse, D.R. (2011), A new look at Halley's life table.
     _Journal of the Royal Statistical Society_: Series A, *174*,
     823-832.  doi:10.1111/j.1467-985X.2010.00684.x
     <https://doi.org/10.1111/j.1467-985X.2010.00684.x>

References

     Halley, E. (1693). An estimate of the degrees of mortality of
     mankind, drawn from the curious tables of births and funerals in
     the City of Breslaw; with an attempt to ascertain the price of
     annuities upon lives. _Phil. Trans._, *17*, 596-610.

See Also

     ‘Arbuthnot’, ‘HalleyLifeTable’


Variables detected from installed object

age: numeric ; missing=0 ; examples=1, 2, 3

year1687: numeric ; missing=0 ; examples=317, 79, 44

year1688: numeric ; missing=0 ; examples=312, 80, 30

year1689: numeric ; missing=0 ; examples=319, 86, 47

year1690: numeric ; missing=0 ; examples=426, 116, 53

year1691: numeric ; missing=0 ; examples=391, 107, 49

total: numeric ; missing=0 ; examples=1765, 468, 223

average: numeric ; missing=0 ; examples=353, 93.6, 44.6

Examples
Run this code

     data(Breslau)

     # Reproduce Figure 1 in Bellhouse (2011)
     # He excluded age < 5 and made a point of the over-representation of deaths in quinquennial years.
     library(ggplot2)
     library(dplyr, warn.conflicts = FALSE)
     Breslau5 <- Breslau |>
       filter(age >= 5) |>
       mutate(div5 = factor(age %% 5 == 0))

     ggplot(Breslau5, aes(x=age, y=total), size=1.5) +
       geom_point(aes(color=div5)) +
       scale_color_manual(labels = c(FALSE, TRUE),
                          values = c("blue", "red")) +
       guides(color=guide_legend("Age divisible by 5")) +
       theme(legend.position = "top") +
       labs(x = "Age current at death",
            y = "Total number of deaths") +
       theme_bw()

