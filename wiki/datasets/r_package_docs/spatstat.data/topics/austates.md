Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

austates: Australian States and Mainland Territories

Australian States and Mainland Territories

Description

     The states and large mainland territories of Australia are
     represented as polygonal regions forming a tessellation.

Usage

     data(austates)

Format

     Object of class ‘"tess"’.

Details

     Western Australia, South Australia, Queensland, New South Wales,
     Victoria and Tasmania (which are states of Australia) and the
     Northern Territory (which is a `territory' of Australia) are
     represented as polygonal regions.

     Offshore territories, and smaller mainland territories, are not
     shown.

     The dataset ‘austates’ is a tessellation object (class ‘"tess"’)
     whose tiles are the states and territories.

     The coordinates are latitude and longitude in degrees, so the
     space is effectively a Mercator projection of the earth.

Source

     Obtained from the ‘oz’ package and reformatted.

Examples
Run this code

       data(austates)
       if(require(spatstat.geom)) {
       plot(austates)
       }

