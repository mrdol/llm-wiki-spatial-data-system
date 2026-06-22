Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

osteo: Osteocyte Lacunae Data: Replicated Three-Dimensional Point Patterns

Osteocyte Lacunae Data: Replicated Three-Dimensional Point Patterns

Description

     These data give the three-dimensional locations of osteocyte
     lacunae observed in rectangular volumes of solid bone using a
     confocal microscope.

     There were four samples of bone, and ten regions were mapped in
     each bone, yielding 40 spatial point patterns.  The data can be
     regarded as replicated observations of a three-dimensional point
     process, nested within bone samples.

Usage

     data(osteo)

Format

     A ‘hyperframe’ with the following columns:

       ‘id’       character string identifier of bone sample
       ‘shortid’  last numeral in ‘id’
       ‘brick’    serial number (1 to 10) of sampling volume within
                  this bone sample
       ‘pts’      three dimensional point pattern (class ‘pp3’)
       ‘depth’    the depth of the brick in microns

Details

     These data are three-dimensional point patterns representing the
     positions of _osteocyte lacunae_, holes in bone which were
     occupied by osteocytes (bone-building cells) during life.

     Observations were made on four different skulls of Macaque monkeys
     iusing a three-dimensional microscope.  From each skull,
     observations were collected in 10 separate sampling volumes.  In
     all, there are 40 three-dimensional point patterns in the dataset.

     The data were collected in 1984 by A. Baddeley, A. Boyde, C.V.
     Howard and S. Reid (see references) using the tandem-scanning
     reflected light microscope (TSRLM) at University College London.
     This was one of the first optical confocal microscopes available.

     Each point pattern dataset gives the (x,y,z) coordinates (in
     microns) of all points visible in a three-dimensional rectangular
     box (``brick'') of dimensions 81 * 100 * d microns, where d
     varies.  The z coordinate is depth into the bone (depth of the
     focal plane of the confocal microscope); the (x,y) plane is
     parallel to the exterior surface of the bone; the relative
     orientation of the x and y axes is not important.

     The bone samples were three intact skulls and one skull cap, all
     originally identified as belonging to the macaque monkey _Macaca
     fascicularis_, from the collection of the Department of Anatomy,
     University of London. Later analysis (Baddeley et al, 1993)
     suggested that the skull cap, given here as the first animal, was
     a different subspecies, and this was confirmed by anatomical
     inspection.

Sampling Procedure:

     The following extract from Baddeley et al (1987) describes the
     sampling procedure.

     The parietal bones of three fully articulated adult Macaque monkey
     _(Macaca fascicularis)_ skulls from the collection of University
     College London were used. The right parietal bone was examined, in
     each case, approximately 1 cm lateral to the sagittal suture and 2
     cm posterior to the coronal suture. The skulls were mounted on
     plasticine on a moving stage placed beneath the TSRLM.  Immersion
     oil was applied and a X 60, NA 1.0 oil immersion objective lens
     (Lomo) was focussed at 10 microns below the cranial surface. The
     TV image was produced by a Panasonic WB 1850/B camera on a Sony
     PVM 90CE TV monitor.

     A graduated rectangular counting frame 90 * 110 mm (representing
     82 * 100 microns in real units) was marked on a Perspex overlay
     and fixed to the screen. The area of tissue seen within the frame
     defined a subfield: a guard area of 10 mm width was visible on all
     sides of the frame. Ten subfields were examined, arranged
     approximately in a rectangular grid pattern, with at least one
     field width separating each pair of fields. The initial field
     position was determined randomly by applying a randomly-generated
     coordinate shift to the moving stage.  Subsequent fields were
     attained using the coarse controls of the microscope stage, in
     accordance with the rectangular grid pattern.

     For each subfield, the focal plane was racked down from its
     initial 10 micron depth until all visible osteocyte lacunae had
     been examined.  This depth d was recorded. The 3-dimensional
     sampling volume was therefore a rectangular box of dimensions 82 *
     100 * d microns, called a ``brick''.  For each visible lacuna, the
     fine focus racking control was adjusted until maximum brightness
     was obtained. The depth of the focal plane was then recorded as
     the $z$ coordinate of the ``centre point'' of the lacuna. Without
     moving the focal plane, the x and y coordinates of the centre of
     the lacunar image were read off the graduated counting frame.
     This required a subjective judgement of the position of the centre
     of the 2-dimensional image. Profiles were approximately elliptical
     and the centre was considered to be well-defined. Accuracy of the
     recording procedure was tested by independent repetition (by the
     same operator and by different operators) and found to be
     reproducible to plus or minus 2 mm on the screen.

     A lacuna was counted only if its (x, y) coordinates lay inside the
     90 * 110 mm counting frame.

Source

     Data were collected by Adrian Baddeley
     <mailto:Adrian.Baddeley@curtin.edu.au>.

References

     Baddeley, A.J., Howard, C.V, Boyde, A. and Reid, S.A. (1987) Three
     dimensional analysis of the spatial distribution of particles
     using the tandem-scanning reflected light microscope.  _Acta
     Stereologica_ *6* (supplement II) 87-100.

     Baddeley, A.J., Moyeed, R.A., Howard, C.V. and Boyde, A. (1993)
     Analysis of a three-dimensional point pattern with replication.
     _Applied Statistics_ *42* (1993) 641-668.

     Howard, C.V. and Reid, S. and Baddeley, A.J. and Boyde, A. (1985)
     Unbiased estimation of particle density in the tandem-scanning
     reflected light microscope.  _Journal of Microscopy_ *138*
     203-212.

Examples
Run this code

       data(osteo)
       if(require(spatstat.geom)) {
       osteo
       if(interactive()) {
         plot(osteo$pts[[1]], main="animal 1, brick 1")
         ape1 <- osteo[osteo$shortid==4, ]
         plot(ape1, tick.marks=FALSE)
         with(osteo, intensity(pts))
         plot(with(ape1, K3est(pts)))
       }
       }

