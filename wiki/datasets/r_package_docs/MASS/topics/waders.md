Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

waders: Counts of Waders at 15 Sites in South Africa

Counts of Waders at 15 Sites in South Africa

Description

     The ‘waders’ data frame has 15 rows and 19 columns.  The entries
     are counts of waders in summer.

Usage

     waders

Format

     This data frame contains the following columns (species)

     ‘S1’ Oystercatcher

     ‘S2’ White-fronted Plover

     ‘S3’ Kitt Lutz's Plover

     ‘S4’ Three-banded Plover

     ‘S5’ Grey Plover

     ‘S6’ Ringed Plover

     ‘S7’ Bar-tailed Godwit

     ‘S8’ Whimbrel

     ‘S9’ Marsh Sandpiper

     ‘S10’ Greenshank

     ‘S11’ Common Sandpiper

     ‘S12’ Turnstone

     ‘S13’ Knot

     ‘S14’ Sanderling

     ‘S15’ Little Stint

     ‘S16’ Curlew Sandpiper

     ‘S17’ Ruff

     ‘S18’ Avocet

     ‘S19’ Black-winged Stilt

     The rows are the sites:

     A = Namibia North coast
     B = Namibia North wetland
     C = Namibia South coast
     D = Namibia South wetland
     E = Cape North coast
     F = Cape North wetland
     G = Cape West coast
     H = Cape West wetland
     I = Cape South coast
     J= Cape South wetland
     K = Cape East coast
     L = Cape East wetland
     M = Transkei coast
     N = Natal coast
     O = Natal wetland

Source

     J.C. Gower and D.J. Hand (1996) _Biplots_ Chapman & Hall Table
     9.1. Quoted as from:

     R.W. Summers, L.G. Underhill, D.J. Pearson and D.A. Scott (1987)
     Wader migration systems in south and eastern Africa and western
     Asia.  _Wader Study Group Bulletin_ *49* Supplement, 15-34.


Variables detected from installed object

S1: integer ; missing=0 ; examples=12, 99, 197

S2: integer ; missing=0 ; examples=2027, 2112, 160

S3: integer ; missing=0 ; examples=0, 9

S4: integer ; missing=0 ; examples=0, 87, 4

S5: integer ; missing=0 ; examples=2070, 3481, 126

S6: integer ; missing=0 ; examples=39, 470, 17

S7: integer ; missing=0 ; examples=219, 2063, 1

S8: integer ; missing=0 ; examples=153, 28, 32

S9: integer ; missing=0 ; examples=0, 17

S10: integer ; missing=0 ; examples=15, 145, 2

S11: integer ; missing=0 ; examples=51, 31, 9

S12: integer ; missing=0 ; examples=8336, 1515, 477

S13: integer ; missing=0 ; examples=2031, 1917, 1

S14: integer ; missing=0 ; examples=14941, 17321, 548

S15: integer ; missing=0 ; examples=19, 3378, 13

S16: integer ; missing=0 ; examples=3566, 20164, 273

S17: integer ; missing=0 ; examples=0, 177

S18: integer ; missing=0 ; examples=5, 1759, 0

S19: integer ; missing=0 ; examples=0, 53

Examples
Run this code

     plot(corresp(waders, nf=2))

