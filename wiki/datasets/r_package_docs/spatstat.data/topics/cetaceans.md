Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

cetaceans: Point patterns of whale and dolphin sightings.

Point patterns of whale and dolphin sightings.

Description

     Nine (independent replicate) point patterns of whale and dolphin
     sightings obtained from aircraft flying along eight parallel
     transects in the region of Great Barrier Island, the Hauraki Gulf
     and the Coromandel Peninsula (New Zealand).  Most of the transects
     are interrupted by portions of land mass.  Observations were
     recorded within narrow rectangles of total width 840 metres (420
     metres on each side of the transect).

Usage

        data(cetaceans)

Format

     The object ‘cetaceans’ is a _hyperframe_ (see ‘hyperframe()’) with
     9 rows and 4 columns.  Each row of this hyperframe represents a
     replicate survey.  The columns are ‘whales’, ‘dolphins’, ‘fish’
     and ‘plankton’.

     Each entry in the hyperframe is a point pattern.  The ‘dolphins’
     column consists of marked patterns (with marks having levels ‘dd’
     and ‘tt’) while the other columns contain unmarked point patterns.

     The object ‘cetaceans.extra’ is a list containing auxiliary data.
     It currently contains only one entry, ‘patterns’, which contains
     the same information as ‘cetaceans’ in another form.  This is a
     list, of class ‘solist’ (“spatial object list”; see ‘solist()’,
     ‘as.solist()’).  It is a list of length 9, in which each entry is
     a marked point pattern, representing the result of one survey.
     Each pattern was obtained by superimposing the ‘whales’,
     ‘dolphins’, ‘fish’ and ‘plankton’ patterns from the corresponding
     row of ‘cetaceans’.  The marks of these patterns have levels ‘be’,
     ‘dd’, ‘fi’, ‘tt’ and ‘zo’.

Details

     The data were obtained from nine aerial surveys, conducted from
     02/12/2013 to 22/04/2014.  Each survey was conducted over the
     course of a single day.  The gap between successive surveys ranged
     from two to six weeks (making it “not unreasonable” to treat the
     patterns obtained as being independent).  The marks of the
     patterns referred to above may be interpreted as follows:

        * ‘be’: whales - Bryde's whale (Balaenoptera edeni)

        * ‘dd’: dolphins - Common dolphin (Delphinus delphis)

        * ‘fi’: fish - Any species that forms schools

        * ‘tt’: dolphins - Bottlenose dolphin (Tursiops truncatus)

        * ‘zo’: plankton - Zooplankton

     The window for the point patterns in these data sets is of type
     ‘polygonal’ and consists of a number of thin rectangular strips.
     These are arranged along eight parallel transects.

     The units in which the patterns are presented are kilometres.

     These data are rather “sparse”.  For example there are a total of
     only eight whale observations in the entire data set (all nine
     surveys).  Thus conclusions drawn from these data should be
     treated with even more than the usual amount of circumspection.

Source

     These data were kindly supplied by Lily Kozmian-Ledward, who
     studied them in the course of writing her Master's thesis at the
     University of Auckland, under the joint supervision of Dr.
     Rochelle Constantine, University of Auckland and Dr Leigh Torres,
     Oregon State University.

References

     Kozmian-Ledward, L. (2014).  _Spatial ecology of cetaceans in the
     Hauraki Gulf, New Zealand._ Unpublished MSc thesis, University of
     Auckland, New Zealand.

Examples
Run this code

       if(require(spatstat.model)) {
          cet <- cetaceans
          cet$dMplank <- with(cet, distfun(plankton, undef=20))
          cet$dMfish <- with(cet, distfun(fish, undef=20))
          fit.whales <- mppm(whales ~ dMplank + dMfish,data=cet)
          anova(fit.whales,test="Chi")
          # Note that inference is *conditional* on the fish and
          # plankton patterns.
          cetPats <- cetaceans.extra$patterns
          plot(Window(cetPats[[1]]),main="The window")
          plot(cetPats,nrows=3,main="All data")
       }

