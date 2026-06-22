Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

arrival: Arrivals at an intensive care unit

Arrivals at an intensive care unit

Description

     This data set gives arrival times of 254 patients at an intensive
     care unit during one day.

Usage

     data(arrival)

Format

     ‘arrival’ is a list containing the 2 following objects :

     times is a vector giving the arrival times in the form HH:MM

     hours is a vector giving the number of arrivals per hour for the
          day considered

Source

     Data taken from the Oriana software developed by Warren L. Kovach
     <mailto:sales@kovcomp.com> starting from
     <https://www.kovcomp.co.uk/oriana/index.html>.

References

     Fisher, N. I. (1993) _Statistical Analysis of Circular Data_.
     Cambridge University Press.

Examples
Run this code

     data(arrival)
     dotcircle(arrival$hours, pi/2 + pi/12)

