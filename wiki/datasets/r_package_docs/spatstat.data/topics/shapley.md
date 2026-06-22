Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

shapley: Galaxies in the Shapley Supercluster

Galaxies in the Shapley Supercluster

Description

     A point pattern recording the sky positions of 4215 galaxies in
     the Shapley Supercluster.

Usage

     data(shapley)

Format

     ‘shapley’ is an object of class ‘"ppp"’ representing the point
     pattern of galaxy locations (see ‘ppp.object’).

     ‘shapley.extra’ is a list containing additional data described
     under Notes.

Notes:

     This dataset comes from a survey by Drinkwater et al (2004) of the
     Shapley Supercluster, one of the most massive concentrations of
     galaxies in the local universe. The data give the sky positions of
     4215 galaxies observed using the FLAIR-II spectrograph on the UK
     Schmidt Telescope (UKST). They were kindly provided by Dr Michael
     Drinkwater through the Centre for Astrostatistics at Penn State
     University.

     Sky positions are given using the coordinates Right Ascension
     (degrees from 0 to 360) and Declination (degrees from -90 to 90).

     The point pattern has three mark variables:

     Mag Galaxy magnitude (a negative logarithmic measure of visible
          brightness).

     V Recession velocity (km/sec) inferred from redshift, with
          corrections applied.

     SigV Estimated standard error for ‘V’.

     The region covered by the survey was approximately the UKST's
     standard quadrilateral survey fields 382 to 384 and 443 to 446.
     However, a few of the galaxy positions lie outside these fields.

     The point pattern dataset ‘shapley’ consists of all 4215 galaxy
     locations. The observation window for this pattern is a dilated
     copy of the convex hull of the galaxy positions, constructed so
     that all galaxies lie within the window.

     Note that the data contain duplicated points (two points at the
     same location). To determine which points are duplicates, use
     ‘duplicated.ppp’.  To remove the duplication, use ‘unique.ppp’.

     The auxiliary dataset ‘shapley.extra’ contains the following
     components:

     ‘UKSTfields’ a list of seven windows (objects of class ‘"owin"’)
          giving the UKST standard survey fields.

     ‘UKSTdomain’ the union of these seven fields, an object of class
          ‘"owin"’.

     ‘plotit’ a function (called without arguments) that will plot the
          data and the survey fields in the conventional astronomical
          presentation, in which Right Ascension is converted to hours
          and minutes (1 hour equals 15 degrees) and Right Ascension
          decreases as we move to the right of the plot.

Source

     M.J. Drinkwater, Department of Physics, University of Queensland

References

     Drinkwater, M.J., Parker, Q.A., Proust, D., Slezak, E.  and
     Quintana, H. (2004) The large scale distribution of galaxies in
     the Shapley Supercluster.  _Publications of the Astronomical
     Society of Australia_ *21*, 89-96. ‘DOI 10.1071/AS03057’

Examples
Run this code

       data(shapley)
       if(require(spatstat.geom)) {
       shapley.extra$plotit(main="Shapley Supercluster")
       }

