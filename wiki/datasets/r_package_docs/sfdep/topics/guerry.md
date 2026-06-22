Rdocumentation
powered by

Search all packages and functions
sfdep (version 0.2.5)

guerry: "Essay on the Moral Statistics of France" data set.

"Essay on the Moral Statistics of France" data set.

Description

     This dataset has been widely used to demonstrate geospatial
     methods and techniques. As such it is useful for inclusion to this
     R package for the purposes of example. The dataset in this package
     is modified from Guerry by Michael Friendly.

Usage

     guerry

     guerry_nb

Format

     An object of class ‘sf’ (inherits from ‘tbl_df’, ‘tbl’,
     ‘data.frame’) with 85 rows and 27 columns.

     ‘guerry’ an sf object with 85 observations and 27 variables.
     ‘guerry_nb’ has 2 additional variables created by ‘sfdep’.

Details

     ‘guerry’ and ‘guerry_nb’ objects are sf class objects. These are
     polygons of the boundaries of France (excluding Corsica) as they
     were in 1830.

Source

     ‘Guerry::gfrance85’


Variables detected from installed object

code_dept: factor ; missing=0 ; examples=01, 02, 03

count: numeric ; missing=0 ; examples=1

ave_id_geo: numeric ; missing=0 ; examples=49, 812, 1418

dept: integer ; missing=0 ; examples=1, 2, 3

region: factor ; missing=0 ; examples=E, N, C

department: factor ; missing=0 ; examples=Ain, Aisne, Allier

crime_pers: integer ; missing=0 ; examples=28870, 26226, 26747

crime_prop: integer ; missing=0 ; examples=15890, 5521, 7925

literacy: integer ; missing=0 ; examples=37, 51, 13

donations: integer ; missing=0 ; examples=5098, 8901, 10973

infants: integer ; missing=0 ; examples=33120, 14572, 17044

suicides: integer ; missing=0 ; examples=35039, 12831, 114121

main_city: ordered/factor ; missing=0 ; examples=2:Med

wealth: integer ; missing=0 ; examples=73, 22, 61

commerce: integer ; missing=0 ; examples=58, 10, 66

clergy: integer ; missing=0 ; examples=11, 82, 68

crime_parents: integer ; missing=0 ; examples=71, 4, 46

infanticide: integer ; missing=0 ; examples=60, 82, 42

donation_clergy: integer ; missing=0 ; examples=69, 36, 76

lottery: integer ; missing=0 ; examples=41, 38, 66

desertion: integer ; missing=0 ; examples=55, 82, 16

instruction: integer ; missing=0 ; examples=46, 24, 85

prostitutes: integer ; missing=0 ; examples=13, 327, 34

distance: numeric ; missing=0 ; examples=218.372, 65.945, 161.927

area: integer ; missing=0 ; examples=5762, 7369, 7340

pop1831: numeric ; missing=0 ; examples=346.03, 513, 298.26

geometry: sfc_MULTIPOLYGON/sfc ; missing=0

