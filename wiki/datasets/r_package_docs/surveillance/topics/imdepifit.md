Rdocumentation
powered by

Search all packages and functions
surveillance (version 1.25.0)

imdepifit: Example 'twinstim' Fit for the 'imdepi' Data

Example 'twinstim' Fit for the 'imdepi' Data

Description

     ‘data("imdepifit")’ is a ‘twinstim’ model fitted to the ‘imdepi’
     data.

Usage

     data("imdepifit")

Format

     an object of class ‘"twinstim"’ obtained from the following call
     using ‘data(imdepi)’:

     twinstim(endemic = addSeason2formula(~offset(log(popdensity)) +
         I(start/365 - 3.5), S = 1,
         period = 365, timevar = "start"),
         epidemic = ~type + agegrp,
         siaf = siaf.gaussian(),
         data = imdepi, subset = !is.na(agegrp),
         optim.args = list(control = list(reltol = sqrt(.Machine$double.eps))),
         model = FALSE, cumCIF = FALSE)

See Also

     common methods for ‘"twinstim"’ fits, exemplified using
     ‘imdepifit’, e.g., ‘summary.twinstim’, ‘plot.twinstim’, and
     ‘simulate.twinstim’

Examples
Run this code

     data("imdepi", "imdepifit")

     ## how this fit was obtained
     imdepifit$call

