# sf package help

## Package Description

- Package: sf
- Title: Simple Features for R
- Version: 1.1-0
- Description: Support for simple feature access, a standardized way to
    encode and analyze spatial vector data. Binds to 'GDAL' 
	<doi:10.5281/zenodo.5884351> for reading and writing data, to 'GEOS'
    <doi:10.5281/zenodo.11396894> for geometrical operations,
    and to 'PROJ' <doi:10.5281/zenodo.5884394> for projection
    conversions and datum transformations. Uses by default the 's2'
    package for geometry operations on geodetic (long/lat degree)
	coordinates.
- Authors@R: 
    c(person(given = "Edzer",
             family = "Pebesma",
             role = c("aut", "cre"),
             email = "edzer.pebesma@uni-muenster.de",
             comment = c(ORCID = "0000-0001-8049-7069")),
      person(given = "Roger",
             family = "Bivand",
             role = "ctb",
             comment = c(ORCID = "0000-0003-2392-6140")),
      person(given = "Etienne",
             family = "Racine",
             role = "ctb"),
      person(given = "Michael",
             family = "Sumner",
             role = "ctb"),
      person(given = "Ian",
             family = "Cook",
             role = "ctb"),
      person(given = "Tim",
             family = "Keitt",
             role = "ctb"),
      person(given = "Robin",
             family = "Lovelace",
             role = "ctb"),
      person(given = "Hadley",
             family = "Wickham",
             role = "ctb"),
      person(given = "Jeroen",
             family = "Ooms",
             role = "ctb",
             comment = c(ORCID = "0000-0002-4035-0289")),
      person(given = "Kirill",
             family = "M\u00fcller",
             role = "ctb"),
      person(given = "Thomas Lin",
             family = "Pedersen",
             role = "ctb"),
      person(given = "Dan",
             family = "Baston",
             role = "ctb"),
      person(given = "Dewey",
             family = "Dunnington",
             role = "ctb",
             comment = c(ORCID = "0000-0002-9415-4582"))
			 )
- Author: Edzer Pebesma [aut, cre] (ORCID:
    <https://orcid.org/0000-0001-8049-7069>),
  Roger Bivand [ctb] (ORCID: <https://orcid.org/0000-0003-2392-6140>),
  Etienne Racine [ctb],
  Michael Sumner [ctb],
  Ian Cook [ctb],
  Tim Keitt [ctb],
  Robin Lovelace [ctb],
  Hadley Wickham [ctb],
  Jeroen Ooms [ctb] (ORCID: <https://orcid.org/0000-0002-4035-0289>),
  Kirill Müller [ctb],
  Thomas Lin Pedersen [ctb],
  Dan Baston [ctb],
  Dewey Dunnington [ctb] (ORCID: <https://orcid.org/0000-0002-9415-4582>)
- Maintainer: Edzer Pebesma <edzer.pebesma@uni-muenster.de>
- Depends: methods, R (>= 3.3.0)
- Imports: classInt (>= 0.4-1), DBI (>= 0.8), graphics, grDevices, grid,
magrittr, s2 (>= 1.1.0), stats, tools, units (>= 0.7-0), utils
- Suggests: blob, nanoarrow, covr, dplyr (>= 1.0.0), ggplot2, knitr,
lwgeom (>= 0.2-14), maps, mapview, Matrix, microbenchmark,
odbc, pbapply, pillar, pool, raster, rlang, rmarkdown,
RPostgres (>= 1.1.0), RPostgreSQL, RSQLite, sp (>= 1.2-4),
spatstat (>= 2.0-1), spatstat.geom, spatstat.random,
spatstat.linnet, spatstat.utils, stars (>= 0.6-0), terra,
testthat (>= 3.0.0), tibble (>= 1.4.1), tidyr (>= 1.2.0),
tidyselect (>= 1.0.0), tmap (>= 2.0), vctrs, wk (>= 0.9.0)
- License: GPL-2 | MIT + file LICENSE
- URL: https://r-spatial.github.io/sf/, https://github.com/r-spatial/sf
- BugReports: https://github.com/r-spatial/sf/issues

## Help Pages

- aggregate.sf: aggregate an 
list("sf")
 object
- bind: Bind rows (features) of sf objects
- coerce-methods: Methods to coerce simple features to 
list("Spatial*")
 and 
list("Spatial*DataFrame")
 objects
- db_drivers: Drivers for which update should be 
list("TRUE")
 by default
- dbDataType: Determine database type for R vector
- dbWriteTable: Write 
list("sf")
 object to Database
- dot-stop_geos: Internal functions
- extension_map: Map extension to driver
- gdal: functions to interact with gdal not meant to be called directly by users (but e.g. by stars::read_stars)
- gdal_addo: Add or remove overviews to/from a raster image
- gdal_compressors: List GDAL compressors and decompressors
- gdal_utils: Native interface to gdal utils
- geos_binary_ops: Geometric operations on pairs of simple feature geometry sets
- geos_binary_pred: Geometric binary predicates on pairs of simple feature geometry sets
- geos_combine: Combine or union feature geometries
- geos_measures: Compute geometric measurements
- geos_query: Dimension, simplicity, validity or is_empty queries on simple feature geometries
- geos_unary: Geometric unary operations on simple feature geometry sets
- interpolate_aw: Areal-weighted interpolation of polygon data
- is_driver_available: Check if driver is available
- is_driver_can: Check if a driver can perform an action
- is_geometry_column: Check if the columns could be of a coercable type for sf
- merge.sf: merge method for sf and data.frame object
- nc: North Carolina SIDS data
- Ops: Arithmetic operators for simple feature geometries
- plot: plot sf object
- prefix_map: Map prefix to driver
- proj_tools: Manage PROJ settings
- rawToHex: Convert raw vector(s) into hexadecimal character string(s)
- reexports: Objects exported from other packages
- s2: functions for spherical geometry, using s2 package
- sf: Create sf object
- sf-defunct: Deprecated functions in 
list("sf")
- sf-package: sf: Simple Features for R
- sf_extSoftVersion: Provide the external dependencies versions of the libraries linked to sf
- sf_project: directly transform a set of coordinates
- sfc: Create simple feature geometry list column
- sgbp: Methods for dealing with sparse geometry binary predicate lists
- st: Create simple feature from a numeric vector, matrix or list
- st_agr: get or set relation_to_geometry attribute of an 
list("sf")
 object
- st_as_binary: Convert sfc object to an WKB object
- st_as_grob: Convert sf* object to a grob
- st_as_sf: Convert foreign object to an sf object
- st_as_sfc: Convert foreign geometry object to an sfc object
- st_as_text: Return Well-known Text representation of simple feature geometry or coordinate reference system
- st_bbox: Return bounding of a simple feature or simple feature set
- st_break_antimeridian: Break antimeridian for plotting not centred on Greenwich
- st_cast: Cast geometry to another type: either simplify, or cast explicitly
- st_cast_sfc_default: Coerce geometry to MULTI* geometry
- st_collection_extract: Given an object with geometries of type 
list("GEOMETRY")
 or 
list("GEOMETRYCOLLECTION")
,

return an object consisting only of elements of the specified type.
- st_coordinates: retrieve coordinates in matrix form
- st_crop: crop an sf object to a specific rectangle
- st_crs: Retrieve coordinate reference system from object
- st_drivers: Get GDAL drivers
- st_geometry: Get, set, replace or rename geometry from an sf object
- st_geometry_type: Return geometry type of an object
- st_graticule: Compute graticules and their parameters
- st_is: test equality between the geometry type and a class or set of classes
- st_is_full: predicate whether a geometry is equal to a POLYGON FULL
- st_is_longlat: Assert whether simple feature coordinates are longlat degrees
- st_jitter: jitter geometries
- st_join: spatial join, spatial filter
- st_layers: Return properties of layers in a datasource
- st_line_project_point: Project point on linestring, interpolate along a linestring
- st_line_sample: Sample points on a linear geometry
- st_m_range: Return 'm' range of a simple feature or simple feature set
- st_make_grid: Create a regular tesselation over the bounding box of an sf or sfc object
- st_nearest_feature: get index of nearest feature
- st_nearest_points: get nearest points between pairs of geometries
- st_normalize: Normalize simple features
- st_precision: Get precision
- st_read: Read simple features or layers from file or database
- st_relate: Compute DE9-IM relation between pairs of geometries, or match it to a given pattern
- st_sample: sample points on or in (sets of) spatial features
- st_shift_longitude: Shift or re-center geographical coordinates for a Pacific view
- st_transform: Transform or convert coordinates of simple feature
- st_viewport: Create viewport from sf, sfc or sfg object
- st_write: Write simple features object to file or database
- st_z_range: Return 'z' range of a simple feature or simple feature set
- st_zm: Drop or add Z and/or M dimensions from feature geometries
- stars: functions only exported to be used internally by stars
- summary.sfc: Summarize simple feature column
- tibble: Summarize simple feature type for tibble
- tidyverse: Tidyverse methods for sf objects
- transform.sf: transform method for sf objects
- valid: Check validity or make an invalid geometry valid

## Package Rd Help

sf: Simple Features for R

Description

     Support for simple feature access, a standardized way to encode
     and analyze spatial vector data. Binds to 'GDAL'
     doi:10.5281/zenodo.5884351
     <https://doi.org/10.5281/zenodo.5884351> for reading and writing
     data, to 'GEOS' doi:10.5281/zenodo.11396894
     <https://doi.org/10.5281/zenodo.11396894> for geometrical
     operations, and to 'PROJ' doi:10.5281/zenodo.5884394
     <https://doi.org/10.5281/zenodo.5884394> for projection
     conversions and datum transformations. Uses by default the 's2'
     package for geometry operations on geodetic (long/lat degree)
     coordinates.

Author(s):

     *Maintainer*: Edzer Pebesma <mailto:edzer.pebesma@uni-muenster.de>
     (ORCID)

     Other contributors:

        * Roger Bivand (ORCID) [contributor]

        * Etienne Racine [contributor]

        * Michael Sumner [contributor]

        * Ian Cook [contributor]

        * Tim Keitt [contributor]

        * Robin Lovelace [contributor]

        * Hadley Wickham [contributor]

        * Jeroen Ooms (ORCID) [contributor]

        * Kirill Müller [contributor]

        * Thomas Lin Pedersen [contributor]

        * Dan Baston [contributor]

        * Dewey Dunnington (ORCID) [contributor]

References

     Pebesma, E. and Bivand, R. (2023). Spatial Data Science: With
     Applications in R. Chapman and Hall/CRC. doi:10.1201/9780429459016
     <https://doi.org/10.1201/9780429459016> which is also found freely
     online at <https://r-spatial.org/book/>

     Pebesma, E., 2018. Simple Features for R: Standardized Support for
     Spatial Vector Data. The R Journal 10 (1), 439-446,
     doi:10.32614/RJ-2018-009 <https://doi.org/10.32614/RJ-2018-009>
     (open access)

See Also

     Useful links:

        * <https://r-spatial.github.io/sf/>

        * <https://github.com/r-spatial/sf>

        * Report bugs at <https://github.com/r-spatial/sf/issues>

