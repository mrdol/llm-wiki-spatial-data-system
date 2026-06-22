Rdocumentation
powered by

Search all packages and functions
spaMM (version 4.6.65)

welding: Welding data set

Welding data set

Description

     The data give the results of an unreplicated experiment for
     factors affecting welding quality conducted by the National
     Railway Corporation of Japan (Taguchi and Wu, 1980, cited in Smyth
     et al., 2001). It is a toy example for heteroscedastic models and
     is also suitable for illustrating fit of overparameterized models.

Usage

     data("welding")

Format

     The data frame includes 16 observations on 10 variables:

     Strengh response variable;

     ... nine two-level factors.

Source

     The data were downloaded from
     http://www.statsci.org/data/general/welding.txt on 2014/08/19 and
     are consistent with those shown in table 5 of Bergman and Hynén
     (1997).

References

     Bergman B, Hynén A (1997) Dispersion effects from unreplicated
     designs in the 2^{k-p} series. Technometrics, 39, 191–98.

     Smyth GK, Huele AF, Verbyla AP (2001). Exact and approximate REML
     for heteroscedastic regression. Statistical Modelling 1, 161-175.

     Taguchi G, Wu Y (1980) Introduction to off-line quality control.
     Nagoya, Japan: Central Japan Quality Control Association.


Variables detected from installed object

Rods: integer ; missing=0 ; examples=-1

Drying: integer ; missing=0 ; examples=-1, 1

Material: integer ; missing=0 ; examples=-1, 1

Thickness: integer ; missing=0 ; examples=-1, 1

Angle: integer ; missing=0 ; examples=-1, 1

Opening: integer ; missing=0 ; examples=-1, 1

Current: integer ; missing=0 ; examples=-1

Method: integer ; missing=0 ; examples=-1, 1

Preheating: integer ; missing=0 ; examples=-1, 1

Strength: numeric ; missing=0 ; examples=43.7, 40.2, 42.4

Examples
Run this code

     data("welding")
     ## toy example from Smyth et al.
     fitme(Strength ~ Drying + Material,resid.model = ~ Material+Preheating ,data=welding, method="REML")
     ## toy example of overparameterized model
     fitme(Strength ~ Rods+Thickness*Angle+(1|Rods),resid.model = ~ Rods+Thickness*Angle ,data=welding)

