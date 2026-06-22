Rdocumentation
powered by

Search all packages and functions
spacetime (version 1.3.3)

air: Air quality data, rural background PM10 in Germany, daily averages 1998-2009

Air quality data, rural background PM10 in Germany, daily averages
1998-2009

Description

     Air quality data obtained from the airBase European air quality
     data base.  Daily averages for rural background stations in
     Germany, 1998-2009. In addition, NUTS1 regions (states, or
     Bundeslaender) for Germany to illustrate spatial aggregation over
     irregular regions.

Usage

     data(air)

Note:

     see vignette on overlay and spatio-temporal aggregation in this
     package; the vignette on using google charts shows where the
     ISO_3166_2_DE table comes from.

Author(s):

     air quality data compiled for R by Benedict Graeler; NUTS1 level
     data obtained from https://www.gadm.org/ .

References

     https://www.eionet.europa.eu/etcs/etc-acm/databases/airbase

Examples
Run this code

     data(air)
     rural = STFDF(stations, dates, data.frame(PM10 = as.vector(air)))
     # how DE was created from DE_NUTS1:
     #if (require(rgeos))
     #       DE = gUnionCascaded(DE_NUTS1)
     #

