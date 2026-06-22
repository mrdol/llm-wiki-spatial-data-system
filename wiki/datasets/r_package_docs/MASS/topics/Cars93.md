Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

Cars93: Data from 93 Cars on Sale in the USA in 1993

Data from 93 Cars on Sale in the USA in 1993

Description

     The ‘Cars93’ data frame has 93 rows and 27 columns.

Usage

     Cars93

Format

     This data frame contains the following columns:

     ‘Manufacturer’ Manufacturer.

     ‘Model’ Model.

     ‘Type’ Type: a factor with levels ‘"Small"’, ‘"Sporty"’,
          ‘"Compact"’, ‘"Midsize"’, ‘"Large"’ and ‘"Van"’.

     ‘Min.Price’ Minimum Price (in $1,000): price for a basic version.

     ‘Price’ Midrange Price (in $1,000): average of ‘Min.Price’ and
          ‘Max.Price’.

     ‘Max.Price’ Maximum Price (in $1,000): price for “a premium
          version”.

     ‘MPG.city’ City MPG (miles per US gallon by EPA rating).

     ‘MPG.highway’ Highway MPG.

     ‘AirBags’ Air Bags standard. Factor: none, driver only, or driver
          & passenger.

     ‘DriveTrain’ Drive train type: rear wheel, front wheel or 4WD;
          (factor).

     ‘Cylinders’ Number of cylinders (missing for Mazda RX-7, which has
          a rotary engine).

     ‘EngineSize’ Engine size (litres).

     ‘Horsepower’ Horsepower (maximum).

     ‘RPM’ RPM (revs per minute at maximum horsepower).

     ‘Rev.per.mile’ Engine revolutions per mile (in highest gear).

     ‘Man.trans.avail’ Is a manual transmission version available? (yes
          or no, Factor).

     ‘Fuel.tank.capacity’ Fuel tank capacity (US gallons).

     ‘Passengers’ Passenger capacity (persons)

     ‘Length’ Length (inches).

     ‘Wheelbase’ Wheelbase (inches).

     ‘Width’ Width (inches).

     ‘Turn.circle’ U-turn space (feet).

     ‘Rear.seat.room’ Rear seat room (inches) (missing for 2-seater
          vehicles).

     ‘Luggage.room’ Luggage capacity (cubic feet) (missing for vans).

     ‘Weight’ Weight (pounds).

     ‘Origin’ Of non-USA or USA company origins? (factor).

     ‘Make’ Combination of Manufacturer and Model (character).

Details

     Cars were selected at random from among 1993 passenger car models
     that were listed in both the _Consumer Reports_ issue and the
     _PACE Buying Guide_.  Pickup trucks and Sport/Utility vehicles
     were eliminated due to incomplete information in the _Consumer
     Reports_ source.  Duplicate models (e.g., Dodge Shadow and
     Plymouth Sundance) were listed at most once.

     Further description can be found in Lock (1993).

Source

     Lock, R. H. (1993) 1993 New Car Data.  _Journal of Statistics
     Education_ *1*(1).  doi:10.1080/10691898.1993.11910459
     <https://doi.org/10.1080/10691898.1993.11910459>

References

     Venables, W. N. and Ripley, B. D. (2002) _Modern Applied
     Statistics with S-PLUS._ Fourth Edition. Springer.


Variables detected from installed object

Manufacturer: factor ; missing=0 ; examples=Acura, Audi

Model: factor ; missing=0 ; examples=Integra, Legend, 90

Type: factor ; missing=0 ; examples=Small, Midsize, Compact

Min.Price: numeric ; missing=0 ; examples=12.9, 29.2, 25.9

Price: numeric ; missing=0 ; examples=15.9, 33.9, 29.1

Max.Price: numeric ; missing=0 ; examples=18.8, 38.7, 32.3

MPG.city: integer ; missing=0 ; examples=25, 18, 20

MPG.highway: integer ; missing=0 ; examples=31, 25, 26

AirBags: factor ; missing=0 ; examples=None, Driver & Passenger, Driver only

DriveTrain: factor ; missing=0 ; examples=Front

Cylinders: factor ; missing=0 ; examples=4, 6

EngineSize: numeric ; missing=0 ; examples=1.8, 3.2, 2.8

Horsepower: integer ; missing=0 ; examples=140, 200, 172

RPM: integer ; missing=0 ; examples=6300, 5500

Rev.per.mile: integer ; missing=0 ; examples=2890, 2335, 2280

Man.trans.avail: factor ; missing=0 ; examples=Yes

Fuel.tank.capacity: numeric ; missing=0 ; examples=13.2, 18, 16.9

Passengers: integer ; missing=0 ; examples=5

Length: integer ; missing=0 ; examples=177, 195, 180

Wheelbase: integer ; missing=0 ; examples=102, 115

Width: integer ; missing=0 ; examples=68, 71, 67

Turn.circle: integer ; missing=0 ; examples=37, 38

Rear.seat.room: numeric ; missing=2 ; examples=26.5, 30, 28

Luggage.room: integer ; missing=11 ; examples=11, 15, 14

Weight: integer ; missing=0 ; examples=2705, 3560, 3375

Origin: factor ; missing=0 ; examples=non-USA

Make: factor ; missing=0 ; examples=Acura Integra, Acura Legend, Audi 90

