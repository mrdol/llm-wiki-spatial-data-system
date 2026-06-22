Rdocumentation
powered by

Search all packages and functions
surveillance (version 1.25.0)

hagelloch: 1861 Measles Epidemic in the City of Hagelloch, Germany

1861 Measles Epidemic in the City of Hagelloch, Germany

Description

     Data on the 188 cases in the measles outbreak among children in
     the German city of Hagelloch (near Tübingen) 1861. The data were
     originally collected by Dr. Albert Pfeilsticker (1863) and
     augmented and re-analysed by Dr. Heike Oesterle (1992).  This
     dataset is used to illustrate the ‘twinSIR’ model class in
     ‘vignette("twinSIR")’.

Usage

     data("hagelloch")

Format

     Loading ‘data("hagelloch")’ gives two objects: ‘hagelloch’ and
     ‘hagelloch.df’.  The latter is the original ‘data.frame’ of 188
     rows with individual information for each infected child.
     ‘hagelloch’ has been generated from ‘hagelloch.df’ via
     ‘as.epidata’ (see the Examples below) to obtain an ‘"epidata"’
     object for use with ‘twinSIR’.  It contains the entire SIR event
     history of the outbreak (but not all of the covariates).

     The covariate information in ‘hagelloch.df’ is as follows:

     PN: patient number

     NAME: patient name (as a factor)

     FN: family index

     HN: house number

     AGE: age in years

     SEX: gender of the individual (factor: male, female)

     PRO: ‘Date’ of prodromes

     ERU: ‘Date’ of rash

     CL: class (factor: preschool, 1st class, 2nd class)

     DEAD: ‘Date’ of death (with missings)

     IFTO: number of patient who is the putative source of infection (0
          = unknown)

     SI: serial interval = number of days between dates of prodromes of
          infection source and infected person

     C: complications (factor: no complications, bronchopneumonia,
          severe bronchitis, lobar pneumonia, pseudocroup, cerebral
          edema)

     PR: duration of prodromes in days

     CA: number of cases in family

     NI: number of initial cases

     GE: generation number of the case

     TD: day of max. fever (days after rush)

     TM: max. fever (degree Celsius)

     x.loc: x coordinate of house (in meters). Scaling in metres is
          obtained by multiplying the original coordinates by 2.5 (see
          details in Neal and Roberts (2004))

     y.loc: y coordinate of house (in meters). See also the above
          description of ‘x.loc’.

     tPRO: Time of prodromes (first symptoms) in days after the start
          of the epidemic (30 Oct 1861).

     tERU: Time upon which the rash first appears.

     tDEAD: Time of death, if available.

     tR: Time at which the infectious period of the individual is
          assumed to end. This unknown time is calculated as

                       tR[i] = min(tDEAD[i], tERU[i] + d0),

          where - as in Section 3.1 of Neal and Roberts (2004) - we use
          d0=3.

     tI: Time at which the individual is assumed to become infectious.
          Actually this time is unknown, but we use

                              tI[i] = tPRO[i] - d1,

          where d1=1 as in Neal and Roberts (2004).

     The time variables describe the transitions of the individual in
     an Susceptible-Infectious-Recovered (SIR) model.  Note that in
     order to avoid ties in the event times resulting from daily
     interval censoring, the times have been jittered uniformly within
     the respective day. The time point 0.5 would correspond to noon of
     30 Oct 1861.

     The ‘hagelloch’ ‘"epidata"’ object only retains some of the above
     covariates to save space. Apart from the usual ‘"epidata"’ event
     columns, ‘hagelloch’ contains a number of extra variables
     representing distance- and covariate-based weights for the force
     of infection:

     household: the number of currently infectious children in the same
          household (including the child itself if it is currently
          infectious).

     nothousehold: the number of currently infectious children outside
          the household.

     c1, c2: the number of children infectious during the respective
          time block and being members of class 1 and 2, respectively;
          but the value is 0 if the individual of the row is not
          herself a member of the respective class.

     Such epidemic covariates can been computed by specifying suitable
     ‘f’ and ‘w’ arguments in ‘as.epidata’ at conversion (see the code
     below), or at a later step via the ‘update’-method for
     ‘"epidata"’.

Source

     Thanks to Peter J. Neal, University of Manchester, for providing
     us with these data, which he again became from Niels Becker,
     Australian National University. To cite the data, the main
     references are Pfeilsticker (1863) and Oesterle (1992).

References

     Pfeilsticker, A. (1863). Beiträge zur Pathologie der Masern mit
     besonderer Berücksichtigung der statistischen Verhältnisse, M.D.
     Thesis, Eberhard-Karls-Universität Tübingen.  Available as
     <https://archive.org/details/beitrgezurpatho00pfeigoog>.

     Oesterle, H. (1992). Statistische Reanalyse einer Masernepidemie
     1861 in Hagelloch, M.D. Thesis, Eberhard-Karls-Universitäat
     Tübingen.

     Neal, P. J. and Roberts, G. O (2004). Statistical inference and
     model selection for the 1861 Hagelloch measles epidemic,
     Biostatistics 5(2):249-261

See Also

     data class: ‘epidata’

     point process model: ‘twinSIR’

     illustration with ‘hagelloch’: ‘vignette("twinSIR")’

Examples
Run this code

     data("hagelloch")
     head(hagelloch.df)   # original data documented in Oesterle (1992)
     head(as.data.frame(hagelloch))   # "epidata" event history format

     ## How the "epidata" 'hagelloch' was created from 'hagelloch.df'
     stopifnot(all.equal(hagelloch,
       as.epidata(
         hagelloch.df, t0 = 0, tI.col = "tI", tR.col = "tR",
         id.col = "PN", coords.cols = c("x.loc", "y.loc"),
         f = list(
             household    = function(u) u == 0,
             nothousehold = function(u) u > 0
         ),
         w = list(
             c1 = function (CL.i, CL.j) CL.i == "1st class" & CL.j == CL.i,
             c2 = function (CL.i, CL.j) CL.i == "2nd class" & CL.j == CL.i
         ),
         keep.cols = c("SEX", "AGE", "CL"))
     ))

     ### Basic plots produced from hagelloch.df

     # Show case locations as in Neal & Roberts (different scaling) using
     # the data.frame (promoted to a SpatialPointsDataFrame)
     coordinates(hagelloch.df) <- c("x.loc","y.loc")
     plot(hagelloch.df, xlab="x [m]", ylab="x [m]", pch=15, axes=TRUE,
          cex=sqrt(multiplicity(hagelloch.df)))

     # Epicurve
     hist(as.numeric(hagelloch.df$tI), xlab="Time (days)", ylab="Cases", main="")

     ### "epidata" summary and plot methods

     (s <- summary(hagelloch))
     head(s$byID)
     plot(s)

     ## Not run:

       # Show a dynamic illustration of the spread of the infection
       animate(hagelloch, time.spacing=0.1, sleep=1/100,
               legend.opts=list(x="topleft"))
     ## End(Not run)

