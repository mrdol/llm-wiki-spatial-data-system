Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

shuttle: Space Shuttle Autolander Problem

Space Shuttle Autolander Problem

Description

     The ‘shuttle’ data frame has 256 rows and 7 columns.  The first
     six columns are categorical variables giving example conditions;
     the seventh is the decision.  The first 253 rows are the training
     set, the last 3 the test conditions.

Usage

     shuttle

Format

     This data frame contains the following factor columns:

     ‘stability’ stable positioning or not (‘stab’ / ‘xstab’).

     ‘error’ size of error (‘MM’ / ‘SS’ / ‘LX’ / ‘XL’).

     ‘sign’ sign of error, positive or negative (‘pp’ / ‘nn’).

     ‘wind’ wind sign (‘head’ / ‘tail’).

     ‘magn’ wind strength (‘Light’ / ‘Medium’ / ‘Strong’ / ‘Out of
          Range’).

     ‘vis’ visibility (‘yes’ / ‘no’).

     ‘use’ use the autolander or not. (‘auto’ / ‘noauto’.)

Source

     D. Michie (1989) Problems of computer-aided concept formation. In
     _Applications of Expert Systems 2_, ed. J. R. Quinlan, Turing
     Institute Press / Addison-Wesley, pp. 310-333.

References

     Venables, W. N. and Ripley, B. D. (2002) _Modern Applied
     Statistics with S._ Fourth edition.  Springer.


Variables detected from installed object

stability: factor ; missing=0 ; examples=xstab

error: factor ; missing=0 ; examples=LX

sign: factor ; missing=0 ; examples=pp

wind: factor ; missing=0 ; examples=head

magn: factor ; missing=0 ; examples=Light, Medium, Strong

vis: factor ; missing=0 ; examples=no

use: factor ; missing=0 ; examples=auto

