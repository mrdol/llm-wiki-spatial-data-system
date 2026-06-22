Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

oliveira.potato.uniformity: Uniformity trial of potato

Uniformity trial of potato

Description

     Uniformity trial of potato grown in Portugal

Usage

     data("oliveira.potato.uniformity")

Format

     A data frame with 200 observations on the following 3 variables.

     ‘row’ row ordinate

     ‘col’ column ordinate

     ‘yield’ yield per plot, decagrams

Details

     This uniformity trial was conducted in 1945-1946 at the National
     Agronomic Station (Sacavém) using a variety of potato known as
     "Batata Duas- Vezes".

     Plot yields are expressed in decagrams.

     Field length: 40 rows x 0.50 m = 20 m

     Field width: 5 columns x 5 m = 25 m

     See pages 329-333 for details.

     Translation from Google.

     Transcription details: OCR on Chart B in the original pdf. Checked
     by K.Wright.

Source

     de Oliveira, Augusto (1946).  Estudos de estatistica agronomica
     III Eficiencia relativa dos diversos delineamentos estatisticos
     usados na comparacao de grande numero de variedades.  Agronomia
     Lusitana, 8, 315-340.
     https://archive.org/details/agronomia-lusitana_1946_8_4/page/314/

References

     None


Variables detected from installed object

row: integer ; missing=0 ; examples=1, 2, 3

col: integer ; missing=0 ; examples=1

yield: integer ; missing=0 ; examples=70, 58, 55

Examples
Run this code

     ## Not run:

     library(agridat)
     data(oliveira.potato.uniformity)
     dat <- oliveira.potato.uniformity

     library(desplot)
     desplot(dat, yield ~ col*row,
             flip=TRUE, aspect=20/25, tick=TRUE,
             main="oliveira.potato.uniformity")
     ## End(Not run)

