Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

cpus: Performance of Computer CPUs

Performance of Computer CPUs

Description

     A relative performance measure and characteristics of 209 CPUs.

Usage

     cpus

Format

     The components are:

     ‘name’ manufacturer and model.

     ‘syct’ cycle time in nanoseconds.

     ‘mmin’ minimum main memory in kilobytes.

     ‘mmax’ maximum main memory in kilobytes.

     ‘cach’ cache size in kilobytes.

     ‘chmin’ minimum number of channels.

     ‘chmax’ maximum number of channels.

     ‘perf’ published performance on a benchmark mix relative to an IBM
          370/158-3.

     ‘estperf’ estimated performance (by Ein-Dor & Feldmesser).

Source

     P. Ein-Dor and J. Feldmesser (1987) Attributes of the performance
     of central processing units: a relative performance prediction
     model.  _Comm. ACM._ *30*, 308-317.

References

     Venables, W. N. and Ripley, B. D. (2002) _Modern Applied
     Statistics with S._ Fourth edition.  Springer.


Variables detected from installed object

name: factor ; missing=0 ; examples=ADVISOR 32/60, AMDAHL 470V/7, AMDAHL 470/7A

syct: integer ; missing=0 ; examples=125, 29

mmin: integer ; missing=0 ; examples=256, 8000

mmax: integer ; missing=0 ; examples=6000, 32000

cach: integer ; missing=0 ; examples=256, 32

chmin: integer ; missing=0 ; examples=16, 8

chmax: integer ; missing=0 ; examples=128, 32

perf: integer ; missing=0 ; examples=198, 269, 220

estperf: integer ; missing=0 ; examples=199, 253

