codes <- c(380,124,818)

country <- c("italy", "canada","turkey")

codes

country

class (codes)

class(country)

names(codes)

seq(1,10) # sequence

seq(1,10,2) ##odd numbers

1:10  # another way

codes [2]

codes[c(1,3)]

codes[1:2]

codes["canada"]

## IMPORTANT CONVERTION , NUMERIC TO STRING, 
## STRING TO NUMERICAL

x <- c(1,"canada",3)

x

class(x) ## 1 and 3 as a char

x <- 1:5 

x

y <- as.character(x) # convertion

y

y <- as.numeric(y)  # again to numeric

y

