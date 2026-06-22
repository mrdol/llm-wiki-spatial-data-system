Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

dendrite: Dendritic Spines Data

Dendritic Spines Data

Description

     Dendrites are branching filaments which extend from the main body
     of a neuron (nerve cell) to propagate electrochemical signals.
     Spines are small protrusions on the dendrites.

     This dataset gives the locations of 566 spines observed on one
     branch of the dendritic tree of a rat neuron.  The spines are
     classified according to their shape into three types: mushroom,
     stubby or thin.

     The data have been analysed in Jammalamadaka et al (2013) and
     Baddeley et al (2014). Please cite these papers and acknowledge
     the Kosik Lab, UC Santa Barbara, in any use of the data.

Usage

     data("dendrite")

Format

     Object of class ‘"lpp"’.  See ‘lpp’.

     Spatial coordinates are expressed in microns.

Source

     Kosik Lab, UC Santa Barbara (Dr Kenneth Kosik, Dr Sourav
     Banerjee).  Formatted for ‘spatstat’ by Dr Aruna Jammalamadaka.

References

     Baddeley, A, Jammalamadaka, A. and Nair, G. (2014) Multitype point
     process analysis of spines on the dendrite network of a neuron.
     _Applied Statistics_ (Journal of the Royal Statistical Society,
     Series C), *63*, 673-694.

     Jammalamadaka, A., Banerjee, S., Manjunath, B.S. and Kosik, K.
     (2013) Statistical Analysis of Dendritic Spine Distributions in
     Rat Hippocampal Cultures. _BMC Bioinformatics_ *14*, 287.

Examples
Run this code

       if(require(spatstat.linnet)) {
     plot(dendrite,leg.side="bottom", main="", cex=0.75, cols=2:4)
       }

