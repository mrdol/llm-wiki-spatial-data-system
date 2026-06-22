# spacetime package help

## Package Description

- Package: spacetime
- Title: Classes and Methods for Spatio-Temporal Data
- Version: 1.3-3
- Description: Classes and methods for spatio-temporal data, including space-time regular lattices, sparse lattices, irregular data, and trajectories; utility functions for plotting data as map sequences (lattice or animation) or multiple time series; methods for spatial and temporal selection and subsetting, as well as for spatial/temporal/spatio-temporal matching or aggregation, retrieving coordinates, print, summary, etc.
- Authors@R: c(person("Edzer",  "Pebesma", role = c("aut", "cre"), email = "edzer.pebesma@uni-muenster.de", comment = c(ORCID = "0000-0001-8049-7069")),
	person("Benedikt", "Graeler", role = "ctb"),
	person("Tom", "Gottfried", role = "ctb"),
	person("Robert J.", "Hijmans", role = "ctb"))
- Author: Edzer Pebesma [aut, cre] (<https://orcid.org/0000-0001-8049-7069>),
  Benedikt Graeler [ctb],
  Tom Gottfried [ctb],
  Robert J. Hijmans [ctb]
- Maintainer: Edzer Pebesma <edzer.pebesma@uni-muenster.de>
- Depends: R (>= 3.0.0)
- Imports: graphics, utils, stats, methods, lattice, sp (>= 1.1-0), zoo
(>= 1.7-9), xts (>= 0.8-8), intervals
- Suggests: adehabitatLT, cshapes (>= 2.0), foreign, googleVis, gstat (>=
1.0-16), maps, mapdata, plm, raster, RColorBrewer, rmarkdown,
RPostgreSQL, knitr, ISOcodes, markdown, sf, sftime, spdep
- License: GPL (>= 2)
- URL: https://github.com/edzer/spacetime
- BugReports: https://github.com/edzer/spacetime/issues

## Help Pages

- air: Air quality data, rural background PM10 in Germany, daily averages 1998-2009
- delta: find default time interval end points when intervals are regular
- eof: Compute spatial or temporal empirical orthogonal function (EOF)
- fires: Northern Los Angeles County Fires
- interval: retrieve, or set, information whether time reflects instance (FALSE) or intervals (TRUE)
- mnf: Generic mnf method
- na: replace NA attribute values; disaggregation time series
- nbmult: convert a spatial nb object to a matching STF object
- over: consistent spatio-temporal overlay for objects inheriting from ST
- ST-class: Class "ST"
- stbox: obtain ranges of space and time coordinates
- stconstruct: create ST* objects from long or wide tables
- STFDF-class: Class "STFDF"
- STIDF-class: Class "STIDF"
- stinteraction: subtract marginal (spatial and temporal) means from observations
- stplot: produce trellis plot for STxDF object
- STSDF-class: Class "STSDF"
- STTDF-class: Class "STTDF"
- tgrass: read or write tgrass (time-enabled grass) files
- timematch: match two (time) sequences
- unstack: write STFDF to table forms

## Package Rd Help

No package-level Rd help page found.
