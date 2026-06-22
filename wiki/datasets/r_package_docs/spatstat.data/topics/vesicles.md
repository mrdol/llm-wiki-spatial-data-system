Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

vesicles: Vesicles Data

Vesicles Data

Description

     Point pattern of synaptic vesicles observed in rat brain tissue.

Usage

     data(vesicles)

Format

     The dataset ‘vesicles’ is a point pattern (object of class
     ‘"ppp"’) representing the location of the synaptic vesicles. The
     window of the point pattern represents the region of presynapse
     where synaptic vesicles were observed in this study.  There is a
     hole in the window, representing the region occupied by
     mitochondria, where synaptic vesicles do not occur.

     The dataset ‘vesicles.extra’ is a list with entries

       ‘presynapse’    outer polygonal boundary of presynapse
       ‘mitochondria’  polygonal boundary of mitochondria
       ‘mask’          binary mask representation of vesicles window
       ‘activezone’    line segment pattern representing
                       the active zone.

     All coordinates are in nanometres (nm).

Details

     As part of a study on the effects of stress on brain function,
     Khanmohammadi et al (2014) analysed the spatial pattern of
     synaptic vesicles in 45-nanometre-thick sections of rat brain
     tissue visualised in transmission electron microscopy.

     To investigate the influence of stress, Khanmohammadi et al (2014)
     study the distribution of the synaptic vesicles in the
     pre-synaptic neuron in relation to the active zone of the
     presynaptic membrane. They hypothesize that the synaptic vesicle
     density is a decreasing function of distance to the active zone.

     The boundaries for the active zone, mitochondria, pre- and post
     synaptic terminals, and the centre of the synaptic vesicles were
     annotated by hand on the image.

Raw Data:

     For demonstration and training purposes, the raw data files for
     this dataset are also provided in the ‘spatstat.data’ package
     installation:

       ‘vesicles.txt’       spatial locations of vesicles
       ‘presynapse.txt’     vertices of ‘presynapse’
       ‘mitochondria.txt’   vertices of ‘mitochondria’
       ‘vesiclesimage.tif’  greyscale microscope image
       ‘vesiclesmask.tif’   binary image of ‘mask’
       ‘activezone.txt’     coordinates of ‘activezone’

     The files are in the folder ‘rawdata/vesicles’ in the
     ‘spatstat.data’ installation directory. The precise location of
     the files can be obtained using ‘system.file’, as shown in the
     examples.

Source

     Nicoletta Nava, Mahdieh Khanmohammadi and Jens Randel Nyengaard.
     Experiment performed by Nicoletta Nava at the Stereology and
     Electron Microscopy Laboratory, Aarhus University, Denmark. Images
     were annotated by Mahdieh Khanmohammadi at the Department of
     Computer Science, University of Copenhagen.  Jens Randel Nyengaard
     provided supervision and guidance, and curated the data.

References

     Khanmohammadi, M., Waagepetersen, R., Nava, N., Nyengaard, J.R.
     and Sporring, J. (2014) Analysing the distribution of synaptic
     vesicles using a spatial point process model.  _5th ACM Conference
     on Bioinformatics, Computational Biology and Health Informatics_,
     Newport Beach, CA, USA, September 2014.

Examples
Run this code

       if(require(spatstat.geom)) {
     plot(vesicles)
     with(vesicles.extra,
          plot(activezone, add=TRUE, col="red"))
        }

     ## read coordinates of vesicles from raw data, for training purposes
     vf <- system.file("rawdata", "vesicles", "vesicles.txt",
                       package="spatstat.data")
     if(!any(nzchar(vf)))
        stop("Could not find raw data file vesicles.txt")
     vdf <- read.table(vf, header=TRUE)

