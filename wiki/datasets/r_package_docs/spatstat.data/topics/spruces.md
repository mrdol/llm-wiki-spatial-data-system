Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

spruces: Spruces Point Pattern

Spruces Point Pattern

Description

     The data give the locations of Norwegian spruce trees in a natural
     forest stand in Saxonia, Germany.  Each tree is marked with its
     diameter at breast height.

Usage

     data(spruces)

Format

     An object of class ‘"ppp"’ representing the point pattern of 134
     tree locations in a 56 x 38 metre sampling region. Each tree is
     marked with its diameter at breast height. All values are given in
     metres.

     See ‘ppp.object’ for details of the format of a point pattern
     object. The marks are numeric.

     These data have been analysed by Fiksel (1984, 1988), Stoyan et al
     (1987), Penttinen et al (1992) and Goulard et al (1996).

Source

     Stoyan et al (1987). Original source unknown.

References

     Fiksel, T. (1984) Estimation of parameterized pair potentials of
     marked and nonmarked Gibbsian point processes.  _Elektron.
     Informationsverarb. u. Kybernet._ *20*, 270-278.

     Fiksel, T. (1988) Estimation of interaction potentials of Gibbsian
     point processes.  _Statistics_ *19*, 77-86

     Goulard, M., S\"arkk\"a, A. and Grabarnik, P. (1996) Parameter
     estimation for marked Gibbs point processes through the maximum
     pseudolikelihood method.  _Scandinavian Journal of Statistics_
     *23*, 365-379.

     Penttinen, A., Stoyan, D. and Henttonen, H. (1992) Marked point
     processes in forest statistics.  _Forest Science_ *38*, 806-824.

     Stoyan, D., Kendall, W.S. and Mecke, J. (1987) _Stochastic
     Geometry and its Applications_.  Wiley.

Examples
Run this code

       if(require(spatstat.geom)) {
          plot(spruces)
          # To reproduce Goulard et al. Figure 3
          # (Goulard et al: "influence zone radius equals 5 * stem diameter")
          # (help(plot.ppp) says: "size of symbol = diameter")
          plot(spruces, maxsize=10*max(spruces$marks))
          plot(unmark(spruces), add=TRUE)
       }

