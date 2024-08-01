library(dplyr)
library(dslabs)


## changing the data table by adding a new column
## or existing one we use mutate
## for filtering > filter

## sending the results of one func to anth > pipe operator

data("murders")

murders <- mutate(murders, rate = total / population * 100000)


head(murders)


filter(murders,rate <= 0.71)


new_table <- select(murders, state,region,rate)

filter(new_table, rate <= 0.71)


murders %>% select(state,region,rate) %>% filter (rate <= 0.71)


