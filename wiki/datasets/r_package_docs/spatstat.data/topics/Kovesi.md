Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

Kovesi: Colour Sequences with Uniform Perceptual Contrast

Colour Sequences with Uniform Perceptual Contrast

Description

     A collection of 41 different sequences of colours, each sequence
     having a uniform perceptual contrast over its whole range. These
     sequences make very good colour maps which avoid introducing
     artefacts when displaying image data.

Usage

     data(Kovesi)

Format

     A ‘hyperframe’ with the following columns:

       ‘linear’       Logical: whether the sequence is linear.
       ‘diverging’    Logical: whether the sequence is diverging.
       ‘rainbow’      Logical: whether the sequence is a rainbow.
       ‘cyclic’       Logical: whether the sequence is cyclic.
       ‘isoluminant’  Logical: whether the sequence is isoluminant.
       ‘ternary’      Logical: whether the sequence is ternary.
       ‘colsig’       Character: colour signature (see Details)
       ‘l1’, ‘l2’     Numeric: lightness parameters
       ‘chro’         Numeric: average chroma (percent)
       ‘n’            Numeric: length of colour sequence
       ‘cycsh’        Numeric: cyclic shift (percent)
       ‘values’       : Character: the colour values.

Details

     Kovesi (2014, 2015) presented a collection of colour sequences
     that have uniform perceptual contrast over their whole range.

     The dataset ‘Kovesi’ provides these data. It is a ‘hyperframe’
     with 41 rows, in which each row provides information about one
     colour sequence.

     Additional information in each row specifies whether the colour
     sequence is ‘linear’, ‘diverging’, ‘rainbow’, ‘cyclic’,
     ‘isoluminant’ and/or ‘ternary’ as defined by Kovesi (2014, 2015).

     The ‘colour signature’ is a string composed of letters
     representing the successive hues, using the following code:

       r  red
       g  green
       b  blue
       c  cyan
       m  magenta
       y  yellow
       o  orange
       v  violet
       k  black
       w  white
       j  grey (j rhymes with grey)

     For example ‘kryw’ is the sequence from black to red to yellow to
     white.

     The column ‘values’ contains the colour data themselves.  The
     ‘i’th colour sequence is ‘Kovesi$values[[i]]’, a character vector
     of length 256.

Source

     Dr Peter Kovesi, Centre for Exploration Targeting, University of
     Western Australia.

References

     Kovesi, P. (2014) Website _CET Uniform Perceptual Contrast Colour
     Maps_ <https://www.peterkovesi.com/projects/colourmaps/>

     Kovesi, P. (2015) Good Colour Maps: How to Design Them.
     ‘arXiv:1509.03700 [cs.GR]’

Examples
Run this code

       Kovesi
       LinearBMW <- Kovesi$values[[28]]
       if(require(spatstat.geom)) {
       plot(colourmap(LinearBMW, range=c(0,1)))

       ## The following would be suitable for spatstat.options(image.colfun)
       BMWfun <- function(n) { interp.colours(LinearBMW, n) }
       }

