Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

waterstriders: Waterstriders data.  Three independent replications of a point pattern formed by insects.

Waterstriders data.  Three independent replications of a point pattern
formed by insects.

Description

     The territorial behaviour of an insect group called waterstriders
     was studied in a series of laboratory experiments by Dr Matti
     Nummelin (University of Helskini). The data were analysed in the
     pioneering PhD thesis of Antti Penttinen (1984).

     The dataset ‘waterstriders’ is a list of three point patterns.
     Each point pattern gives the locations of larvae of the
     waterstrider _Limnoporus (Gerris) rufoscutellatus_ (larval stage
     V) in a homogeneous area about 48 cm square. The point patterns
     can be assumed to be independent.

     It is known that this species of waterstriders exhibits
     territorialism at older larvae stages and at the adult stage.
     Therefore, if any deviation from Complete Spatial Randomness
     exists in these three point patterns, it is expected to be towards
     inhibition.

     The data were obtained from photographs which were scanned
     manually.  The waterstriders are in a pool which is larger than
     the picture.  A guard area (width about 2.5 cm) has been deleted
     because it is a source of inhomogeneity to interactions.

     Penttinen (1984, chapter 5) fitted a pairwise interaction model
     with a Strauss/hardcore interaction (see ‘StraussHard’) with hard
     core radius 1.5 cm and interaction radius 4.5 cm.

Usage

     data(waterstriders)

Format

     ‘waterstriders’ is a list of three point patterns (objects of
     class ‘"ppp"’). It also has class ‘"listof"’ so that it can be
     plotted and printed directly. The point pattern coordinates are in
     centimetres.

Source

     Data were collected by Dr. Matti Nummelin (University of Helsinki,
     Finland).  Data kindly provided by Prof. Antti Penttinen,
     University of Jyv\"askyl\"a, Finland.

References

     Penttinen, A. (1984) Modelling interaction in spatial point
     patterns: parameter estimation by the maximum likelihood method.
     _Jyv\"askyl\"a Studies in Computer Science, Economics and
     Statistics_ *7*, University of Jyv\"askyl\"a, Finland.

