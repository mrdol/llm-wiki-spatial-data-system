Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

ships: Ships Damage Data

Ships Damage Data

Description

     Data frame giving the number of damage incidents and aggregate
     months of service by ship type, year of construction, and period
     of operation.

Usage

     ships

Format

     ‘type’ type: ‘"A"’ to ‘"E"’.

     ‘year’ year of construction: 1960-64, 65-69, 70-74, 75-79 (coded
          as ‘"60"’, ‘"65"’, ‘"70"’, ‘"75"’).

     ‘period’ period of operation : 1960-74, 75-79.

     ‘service’ aggregate months of service.

     ‘incidents’ number of damage incidents.

Source

     P. McCullagh and J. A. Nelder, (1983), _Generalized Linear
     Models._ Chapman & Hall, section 6.3.2, page 137


Variables detected from installed object

type: factor ; missing=0 ; examples=A

year: integer ; missing=0 ; examples=60, 65

period: integer ; missing=0 ; examples=60, 75

service: integer ; missing=0 ; examples=127, 63, 1095

incidents: integer ; missing=0 ; examples=0, 3

