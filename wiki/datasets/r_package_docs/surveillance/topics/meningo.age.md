Rdocumentation
powered by

Search all packages and functions
surveillance (version 1.25.0)

meningo.age: Meningococcal infections in France 1985-1997

Meningococcal infections in France 1985-1997

Description

     Monthly counts of meningococcal infections in France 1985-1997.
     Here, the data is split into 4 age groups (<1, 1-5, 5-20, >20).

Usage

     data(meningo.age)

Format

     An object of class ‘disProg’ with 156 observations in each of 4
     age groups.

     week Month index

     observed Matrix with number of counts in the corresponding month
          and age group

     state Boolean whether there was an outbreak - dummy not
          implemented

     neighbourhood Neighbourhood matrix, all age groups are adjacent

     populationFrac Population fractions

Source

     ??

Examples
Run this code

     data(meningo.age)
     plot(meningo.age, title="Meningococcal infections in France 1985-97")
     plot(meningo.age, as.one=FALSE)

