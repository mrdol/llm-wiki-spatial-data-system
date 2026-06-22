# sp package help

## Package Description

- Package: sp
- Title: Classes and Methods for Spatial Data
- Version: 2.2-1
- Description: Classes and methods for spatial
  data; the classes document where the spatial location information
  resides, for 2D or 3D data. Utility functions are provided, e.g. for
  plotting data as maps, spatial selection, as well as methods for
  retrieving coordinates, for subsetting, print, summary, etc. From this
  version, 'rgdal', 'maptools', and 'rgeos' are no longer used at all,
  see <https://r-spatial.org/r/2023/05/15/evolution4.html> for details.
- Authors@R: c(person("Edzer", "Pebesma", role = c("aut", "cre"),
				email = "edzer.pebesma@uni-muenster.de"),
			person("Roger", "Bivand", role = "aut",
            	email = "Roger.Bivand@nhh.no"),
			person("Barry", "Rowlingson", role = "ctb"),
			person("Virgilio", "Gomez-Rubio", role = "ctb"),
			person("Robert", "Hijmans", role = "ctb"),
			person("Michael", "Sumner", role = "ctb"),
			person("Don", "MacQueen", role = "ctb"),
			person("Jim", "Lemon", role = "ctb"),
                        person("Finn", "Lindgren", role = "ctb"),
			person("Josh", "O'Brien", role = "ctb"),
			person("Joseph", "O'Rourke", role = "ctb"),
            person("Patrick", "Hausmann", role = "ctb"),
            person("Sebastian", "Meyer", role = "ctb"))
- Author: Edzer Pebesma [aut, cre],
  Roger Bivand [aut],
  Barry Rowlingson [ctb],
  Virgilio Gomez-Rubio [ctb],
  Robert Hijmans [ctb],
  Michael Sumner [ctb],
  Don MacQueen [ctb],
  Jim Lemon [ctb],
  Finn Lindgren [ctb],
  Josh O'Brien [ctb],
  Joseph O'Rourke [ctb],
  Patrick Hausmann [ctb],
  Sebastian Meyer [ctb]
- Maintainer: Edzer Pebesma <edzer.pebesma@uni-muenster.de>
- Depends: R (>= 3.5.0), methods
- Imports: utils, stats, graphics, grDevices, lattice, grid
- Suggests: RColorBrewer, gstat, deldir, knitr, maps, mapview, rmarkdown,
sf, terra, raster
- License: GPL (>= 2)
- URL: https://github.com/edzer/sp/ https://edzer.github.io/sp/
- BugReports: https://github.com/edzer/sp/issues

## Help Pages

- 00sp: A package providing classes and methods for spatial data: points,

lines, polygons and grids
- addattr: constructs SpatialXxxDataFrame from geometry and attributes
- aggregate: aggregation of spatial objects
- as.SpatialPolygons.GridTopology: Make SpatialPolygons object from GridTopology object
- as.SpatialPolygons.PolygonsList: Making SpatialPolygons objects
- asciigrid: read/write to/from (ESRI) asciigrid format
- bbox: retrieve bbox from spatial data
- bpy.colors: blue-pink-yellow color scheme, which also prints well on 

black/white printers
- bubble: Create a bubble plot of spatial data
- char2dms: Convert character vector to DMS-class object
- compassRose: Display a compass rose.
- coordinates: set spatial coordinates to create a Spatial object, or retrieve

spatial coordinates from a Spatial object
- coordinates-methods: retrieve (or set) spatial coordinates
- coordnames-methods: retrieve or assign coordinate names for classes in sp
- CRS-class: Class "CRS" of coordinate reference system arguments
- degaxis: axis with degrees
- dimensions: retrieve spatial dimensions from spatial data
- disaggregate: disaggregate SpatialLines, SpatialLinesDataFrame, 

SpatialPolygons, or SpatialPolygonsDataFrame objects
- DMS-class: Class "DMS" for degree, minute, decimal second values
- elide-methods: Methods for Function elide in Package `maptools'
- flip: rearrange data in SpatialPointsDataFrame or SpatialGridDataFrame 

for plotting with spplot (levelplot/xyplot wrapper)
- geometry-methods: Methods for retrieving the geometry from a composite (geometry + attributes) object
- gridded-methods: specify spatial data as being gridded, or find out whether they are
- gridindex2nb: create neighbourhood (nb) object from grid geometry
- gridlines: Create N-S and E-W grid lines over a geographic region
- GridsDatums: Grids and Datums PE&RS listing
- GridTopology-class: Class "GridTopology"
- image: Image or contour method for gridded spatial data; convert to and from image data structure
- is.projected: Sets or retrieves projection attributes on classes extending

SpatialData
- Line: create objects of class Line or Lines
- Line-class: Class "Line"
- Lines-class: Class "Lines"
- loadmeuse: deprecated function to load the Meuse data set
- mapasp: Calculate aspect ratio for plotting geographic maps;

create nice degree axis labels
- merge: Merge a Spatial* object having attributes with a data.frame
- meuse: Meuse river data set
- meuse.grid: Prediction Grid for Meuse Data Set
- meuse.grid_ll: Prediction Grid for Meuse Data Set, geographical coordinates
- meuse.riv: River Meuse outline
- over: consistent spatial overlay for points, grids and polygons
- panel: panel and panel utility functions for spplot
- point.in.polygon: do point(s) fall in a given polygon?
- Polygon-class: Class "Polygon"
- polygons: sets spatial coordinates to create spatial data, or retrieves

spatial coordinates
- Polygons-class: Class "Polygons"
- polygons-methods: Retrieve polygons from SpatialPolygonsDataFrame object
- recenter-methods: Methods for Function recenter in Package `sp'
- Rlogo: Rlogo jpeg image
- select.spatial: select points spatially
- sp-deprecated: Deprecated functions in sp
- sp2Mondrian: write map data for Mondrian
- Spatial-class: Class "Spatial"
- SpatialGrid: define spatial grid
- SpatialGrid-class: Class "SpatialGrid"
- SpatialGridDataFrame: define spatial grid with attribute data
- SpatialGridDataFrame-class: Class "SpatialGridDataFrame"
- SpatialLines: create objects of class SpatialLines or SpatialLinesDataFrame
- SpatialLines-class: a class for spatial lines
- SpatialLinesDataFrame-class: a class for spatial lines with attributes
- SpatialMultiPoints: create objects of class SpatialMultiPoints or SpatialMultiPointsDataFrame
- SpatialMultiPoints-class: Class "SpatialMultiPoints"
- SpatialMultiPointsDataFrame-class: Class "SpatialMultiPointsDataFrame"
- SpatialPixels-class: Class "SpatialPixels"
- SpatialPixelsDataFrame-class: Class "SpatialPixelsDataFrame"
- SpatialPoints: create objects of class SpatialPoints or SpatialPointsDataFrame
- SpatialPoints-class: Class "SpatialPoints"
- SpatialPointsDataFrame-class: Class "SpatialPointsDataFrame"
- SpatialPolygons: create objects of class SpatialPolygons or SpatialPolygonsDataFrame
- SpatialPolygons-class: Class "SpatialPolygons"
- SpatialPolygonsDataFrame-class: Class "SpatialPolygonsDataFrame"
- spChFIDs-methods: change feature IDs in spatial objects
- spDistsN1: Euclidean or Great Circle distance between points
- spplot: Plot methods for spatial data with attributes
- spsample: sample point locations in (or on) a spatial object
- spTransform: spTransform for map projection and datum transformation
- stack: rearrange data in SpatialPointsDataFrame or SpatialGridDataFrame 

for plotting with spplot (levelplot/xyplot wrapper)
- surfaceArea: Compute surface area of a digital elevation model.
- zerodist: find point pairs with equal spatial coordinates

## Package Rd Help

No package-level Rd help page found.
