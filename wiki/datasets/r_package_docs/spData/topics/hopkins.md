Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

hopkins: Hopkins burnt savanna herb remains

Hopkins burnt savanna herb remains

Description

     A 20m square is divided into 40 by 40 0.5m quadrats. Observations
     are in tens of grams of herb remains, 0 being from 0g to less than
     10g, and so on. Analysis was mostly conducted using the interior
     32 by 32 grid.

Usage

     hopkins

Format

     num [1:40, 1:40] 0 0 0 0 0 0 0 0 0 1 ...

Source

     Upton, G., Fingleton, B. 1985 Spatial data analysis by example:
     point pattern and quatitative data, Wiley, pp. 38-39.

References

     Hopkins, B., 1965 Observations on savanna burning in the Olokemeji
     Forest Reserve, Nigeria. Journal of Applied Ecology, 2, 367-381.


Variables detected from installed object

V1: numeric ; missing=0 ; examples=0

V2: numeric ; missing=0 ; examples=0, 2, 1

V3: numeric ; missing=0 ; examples=0, 1

V4: numeric ; missing=0 ; examples=0, 1, 3

V5: numeric ; missing=0 ; examples=1, 0

V6: numeric ; missing=0 ; examples=1, 0

V7: numeric ; missing=0 ; examples=2, 0, 1

V8: numeric ; missing=0 ; examples=0

V9: numeric ; missing=0 ; examples=0, 1

V10: numeric ; missing=0 ; examples=0

V11: numeric ; missing=0 ; examples=0, 3, 2

V12: numeric ; missing=0 ; examples=1, 0

V13: numeric ; missing=0 ; examples=0, 1

V14: numeric ; missing=0 ; examples=0, 1

V15: numeric ; missing=0 ; examples=2, 0

V16: numeric ; missing=0 ; examples=1, 0

V17: numeric ; missing=0 ; examples=0, 3, 1

V18: numeric ; missing=0 ; examples=2

V19: numeric ; missing=0 ; examples=1, 0

V20: numeric ; missing=0 ; examples=1, 0

V21: numeric ; missing=0 ; examples=1, 0

V22: numeric ; missing=0 ; examples=1, 0

V23: numeric ; missing=0 ; examples=0, 2

V24: numeric ; missing=0 ; examples=0, 4, 3

V25: numeric ; missing=0 ; examples=0, 1

V26: numeric ; missing=0 ; examples=1, 0

V27: numeric ; missing=0 ; examples=3, 0

V28: numeric ; missing=0 ; examples=0

V29: numeric ; missing=0 ; examples=2, 0

V30: numeric ; missing=0 ; examples=0, 2

V31: numeric ; missing=0 ; examples=0, 4, 2

V32: numeric ; missing=0 ; examples=0

V33: numeric ; missing=0 ; examples=0

V34: numeric ; missing=0 ; examples=0, 2

V35: numeric ; missing=0 ; examples=0, 1

V36: numeric ; missing=0 ; examples=0, 1

V37: numeric ; missing=0 ; examples=0, 2

V38: numeric ; missing=0 ; examples=0

V39: numeric ; missing=0 ; examples=0, 1

V40: numeric ; missing=0 ; examples=0, 1

Examples
Run this code

     data(hopkins)
     image(1:32, 1:32, hopkins[5:36,36:5], breaks=c(-0.5, 3.5, 20),
           col=c("white", "black"))

