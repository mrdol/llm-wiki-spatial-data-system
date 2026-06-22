Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

gorillas: Gorilla Nesting Sites

Gorilla Nesting Sites

Description

     Locations of nesting sites of gorillas, and associated covariates,
     in a National Park in Cameroon.

Usage

     data(gorillas)

Format

     ‘gorillas’ is a marked point pattern (object of class ‘"ppp"’)
     representing nest site locations.

     ‘gorillas.extra’ is a named list of 7 pixel images (objects of
     class ‘"im"’) containing spatial covariates.  It also belongs to
     the class ‘"listof"’.

     All spatial coordinates are in metres.  The coordinate reference
     system is ‘WGS_84_UTM_Zone_32N’.

Details

     These data come from a study of gorillas in the Kagwene Gorilla
     Sanctuary, Cameroon, by the Wildlife Conservation Society
     Takamanda-Mone Landscape Project (WCS-TMLP). A detailed
     description and analysis of the data is reported in Funwi-Gabga
     and Mateu (2012).

     The dataset ‘gorillas’ is a marked point pattern (object of class
     ‘"ppp"’) giving the spatial locations of 647 nesting sites of
     gorilla groups observed in the sanctuary over time.  Locations are
     given as UTM (Zone 32N) coordinates in metres.  The observation
     window is the boundary of the sanctuary, represented as a polygon.
     Marks attached to the points are:

     group Identifier of the gorilla group that constructed the nest
          site: a categorical variable with values ‘major’ or ‘minor’.

     season Season in which data were collected: categorical, either
          ‘rainy’ or ‘dry’.

     date Day of observation. A value of class ‘"Date"’.

     Note that the data contain duplicated points (two points at the
     same location). To determine which points are duplicates, use
     ‘duplicated.ppp’.  To remove the duplication, use ‘unique.ppp’.

     The accompanying dataset ‘gorillas.extra’ contains spatial
     covariate information. It is a named list containing seven pixel
     images (objects of class ‘"im"’) giving the values of seven
     covariates over the study region. It also belongs to the class
     ‘"listof"’ so that it can be plotted.  The component images are:

     aspect Compass direction of the terrain slope.  Categorical, with
          levels ‘N’, ‘NE’, ‘E’, ‘SE’, ‘S’, ‘SW’, ‘W’ and ‘NW’.

     elevation Digital elevation of terrain, in metres.

     heat Heat Load Index at each point on the surface (Beer's aspect),
          discretised. Categorical with values ‘Warmest’ (Beer's aspect
          between 0 and 0.999), ‘Moderate’ (Beer's aspect between 1 and
          1.999), ‘Coolest’ (Beer's aspect equals 2).

     slopeangle Terrain slope, in degrees.

     slopetype Type of slope.  Categorical, with values ‘Valley’, ‘Toe’
          (toe slope), ‘Flat’, ‘Midslope’, ‘Upper’ and ‘Ridge’.

     vegetation Vegetation or cover type.  Categorical, with values
          ‘Disturbed’ (highly disturbed forest), ‘Colonising’
          (colonising forest), ‘Grassland’ (savannah), ‘Primary’
          (primary forest), ‘Secondary’ (secondary forest), and
          ‘Transition’ (transitional vegetation).

     waterdist Euclidean distance from nearest water body, in metres.

     For further information see Funwi-Gabga and Mateu (2012).

Raw Data:

     For demonstration and training purposes, the raw data file for the
     ‘vegetation’ covariate is also provided in the ‘spatstat.data’
     package installation, as the file ‘vegetation.asc’ in the folder
     ‘rawdata/gorillas’.  Use ‘system.file’ to obtain the file path:
     ‘system.file("rawdata/gorillas/vegetation.asc",
     package="spatstat.data")’.  This is a text file in the simple
     ASCII file format of the geospatial library ‘GDAL’. The file can
     be read by the function ‘readGDAL’ in the ‘rgdal’ package, or
     alternatively read directly using ‘scan’.

Source

     Field data collector: Wildlife Conservation Society Takamanda-Mone
     Landscape Project (WCS-TMLP).  _Please acknowledge WCS-TMLP in any
     use of these data._

     Data kindly provided by Funwi-Gabga Neba, Data Coordinator of
     A.P.E.S.  Database Project, Department of Primatology, Max Planck
     Institute for Evolutionary Anthropology, Leipzig, Germany.

     The collaboration of Prof Jorge Mateu, Universitat Jaume I,
     Castellon, Spain is gratefully acknowledged.

References

     Funwi-Gabga, N. (2008) _A pastoralist survey and fire impact
     assessment in the Kagwene Gorilla Sanctuary, Cameroon_. M.Sc.
     thesis, Geology and Environmental Science, University of Buea,
     Cameroon.

     Funwi-Gabga, N. and Mateu, J. (2012) Understanding the nesting
     spatial behaviour of gorillas in the Kagwene Sanctuary, Cameroon.
     _Stochastic Environmental Research and Risk Assessment_ *26* (6),
     793-811.

Examples
Run this code

       if(require(spatstat.geom)) {
       summary(gorillas)
       plot(gorillas)
       plot(gorillas.extra)
       }

