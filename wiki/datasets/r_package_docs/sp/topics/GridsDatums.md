Rdocumentation
powered by

Search all packages and functions
sp (version 2.2.1)

GridsDatums: Grids and Datums PE&RS listing

Grids and Datums PE&RS listing

Description

     A data.frame of years and months of Grids & Datums column
     publications by country and country code.

Usage

     data("GridsDatums")

Format

     A data frame with 241 observations on the following 4 variables.

     ‘country’ name of PE&RS column

     ‘month’ issue month

     ‘year’ publication year

     ‘ISO’ ISO code for country

Details

     The journal _Photogrammetric Engineering & Remote Sensing_, run by
     the American Society for Photogrammetry and Remote Sensing
     (ASPRS), began publishing a more-or-less monthly column on the
     spatial reference systems used in different countries, including
     their datums. The column first appeared in September 1997, and
     continued until March 2016; subsequent columns are updated
     reprints of previous ones. Some also cover other topics, such as
     world and Martian spatial reference systems. They are written by
     Clifford J. Mugnier, Louisiana State University, Fellow Emeritus
     ASPRS. To access the columns, visit
     ‘https:\/\/www.asprs.org/asprs-publications/grids-and-datums’.

Source

     ‘https:\/\/www.asprs.org/asprs-publications/grids-and-datums’


Variables detected from installed object

country: character ; missing=0 ; examples=Yugoslavia, Republic of Colombia, Canada

month: character ; missing=0 ; examples=(September), (November), (December)

year: numeric ; missing=0 ; examples=1997

ISO: character ; missing=8 ; examples=YUG, COL, CAN

Examples
Run this code

     data(GridsDatums)
     GridsDatums[grep("Norway", GridsDatums$country),]
     GridsDatums[grep("Google", GridsDatums$country),]
     GridsDatums[grep("^Mars$", GridsDatums$country),]

