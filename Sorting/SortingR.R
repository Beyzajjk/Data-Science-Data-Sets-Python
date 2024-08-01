## func sort

library(dslabs)

data(murders)

sort(murders$total)

## how to sort states

x <- c(31,4,15,92,65) 

x

sort(x)


index <- order(x)

x[index]

x

order(x)  ## this is index puts the vect. x in order


murders$state[1:10]


murders$abb[1:10]

index <- order(murders$total)


murders$abb[index]


class(index)

max(murders$total)

i_max <- which.max(murders$total)  ## 

i_max

murders$state[i_max] # CALIFORNIA has max murders


x

rank(x) #index for original numbers

