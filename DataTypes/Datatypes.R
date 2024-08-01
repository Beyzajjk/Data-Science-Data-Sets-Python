a <- 2
class(a)
library(dslabs)

data("murders")
class(murders)

str(murders)

head(murders)

murders$population 

names(murders)

## order of the entries in the list preserves

## In general they are vectors

pop <- murders$population 

length(pop)  # how many pop 

## we use quotes to distinguish btwn variable and chr

a <- 1
a

"a"

class(murders$state)   ## class of state is character

z <- 3 == 2 ## relational operator

z

class(z)

## factors

class(murders$region)

# Factors are useful for categorical data.

levels(murders$region)

?levels

