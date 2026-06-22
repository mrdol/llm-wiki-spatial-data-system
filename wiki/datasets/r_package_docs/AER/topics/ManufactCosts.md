Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

ManufactCosts: Manufacturing Costs Data

Manufacturing Costs Data

Description

     US time series data on prices and cost shares in manufacturing,
     1947-1971.

Usage

     data("ManufactCosts")

Format

     An annual multiple time series from 1947 to 1971 with 9 variables.

     cost Cost index.

     capitalcost Capital cost share.

     laborcost Labor cost share.

     energycost Energy cost share.

     materialscost Materials cost share.

     capitalprice Capital price.

     laborprice Labor price.

     energyprice Energy price.

     materialsprice Materials price.

Source

     Online complements to Greene (2003).

     <https://pages.stern.nyu.edu/~wgreene/Text/tables/tablelist5.htm>

References

     Berndt, E. and Wood, D. (1975). Technology, Prices, and the
     Derived Demand for Energy. _Review of Economics and Statistics_,
     *57*, 376-384.

     Greene, W.H. (2003). _Econometric Analysis_, 5th edition. Upper
     Saddle River, NJ: Prentice Hall.

See Also

     ‘Greene2003’


Variables detected from installed object

cost: numeric ; missing=0 ; examples=182.373, 183.161, 186.533

capitalcost: numeric ; missing=0 ; examples=0.05107, 0.05817, 0.04602

laborcost: numeric ; missing=0 ; examples=0.24727, 0.27716, 0.25911

energycost: numeric ; missing=0 ; examples=0.04253, 0.05127, 0.05075

materialscost: numeric ; missing=0 ; examples=0.65913, 0.6134, 0.64411

capitalprice: numeric ; missing=0 ; examples=1, 1.0027, 0.74371

laborprice: numeric ; missing=0 ; examples=1, 1.15457, 1.15584

energyprice: numeric ; missing=0 ; examples=1, 1.30258, 1.19663

materialsprice: numeric ; missing=0 ; examples=1, 1.05525, 1.06625

Examples
Run this code

     data("ManufactCosts")
     plot(ManufactCosts)

