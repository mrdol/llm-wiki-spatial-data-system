Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

house: Lucas county OH housing

Lucas county OH housing

Description

     Data on 25,357 single family homes sold in Lucas County, Ohio,
     1993-1998 from the county auditor, together with an ‘nb’ neighbour
     object constructed as a sphere of influence graph from projected
     coordinates.

Usage

     house

Format

     Formal class 'SpatialPointsDataFrame' [package "sp"] with 5 slots.
     The data slot is a data frame with 25357 observations on the
     following 24 variables.

        * price: a numeric vector

        * yrbuilt: a numeric vector

        * stories: a factor with levels ‘one’ ‘bilevel’ ‘multilvl’
          ‘one+half’ ‘two’ ‘two+half’ ‘three’

        * TLA: a numeric vector

        * wall: a factor with levels ‘stucdrvt’ ‘ccbtile’ ‘metlvnyl’
          ‘brick’ ‘stone’ ‘wood’ ‘partbrk’

        * beds: a numeric vector

        * baths: a numeric vector

        * halfbaths: a numeric vector

        * frontage: a numeric vector

        * depth: a numeric vector

        * garage: a factor with levels ‘no garage’ ‘basement’
          ‘attached’ ‘detached’ ‘carport’

        * garagesqft: a numeric vector

        * rooms: a numeric vector

        * lotsize: a numeric vector

        * sdate: a numeric vector

        * avalue: a numeric vector

        * s1993: a numeric vector

        * s1994: a numeric vector

        * s1995: a numeric vector

        * s1996: a numeric vector

        * s1997: a numeric vector

        * s1998: a numeric vector

        * syear: a factor with levels ‘1993’ ‘1994’ ‘1995’ ‘1996’
          ‘1997’ ‘1998’

        * age: a numeric vector

     Its projection is ‘CRS(+init=epsg:2834)’, the Ohio North State
     Plane.

Source

     Dataset included in the Spatial Econometrics toolbox for Matlab,
     formerly available from
     http://www.spatial-econometrics.com/html/jplv7.zip.

Examples
Run this code

     if (requireNamespace("sp", quietly = TRUE)) {
       library(sp)
       data(house)
       str(house)
       plot(house)
     }

