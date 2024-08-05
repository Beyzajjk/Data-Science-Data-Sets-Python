library(tidyverse)
library(caret)   #predictive models
library(dslabs)
data(heights)

# define the outcome and predictors
y <- heights$sex   #outcome
x <- heights$height    #predictors

# generate training and test sets
set.seed(2007)  # setting the seeds for random number generation
test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)
test_set <- heights[test_index, ]
train_set <- heights[-test_index, ]   ##splitting data into 2, test and train
# p = 0.5 means half of goes train other half goes to test

# guess the outcome
y_hat <- sample(c("Male", "Female"), length(test_index), replace = TRUE) %>% 
  factor(levels = levels(test_set$sex)) ##  y hat = guesses the sex for each entry 
# in the test set


# compute accuracy
mean(y_hat == test_set$sex)

# compare heights in males and females in our data set
heights %>% group_by(sex) %>% summarize(mean(height), sd(height))
# This code computes the mean and standard deviation of heights for each sex



# now try predicting "male" if the height is within 2 SD of the average male
y_hat <- ifelse(x > 62, "Male", "Female") %>% factor(levels = levels(test_set$sex))
mean(y == y_hat)
# y_hat: Predicts "Male" if the height is greater than 62 inches, otherwise "Female"


# examine the accuracy of 10 cutoffs
cutoff <- seq(61, 70)
accuracy <- map_dbl(cutoff, function(x){
  y_hat <- ifelse(train_set$height > x, "Male", "Female") 
    factor(levels = levels(test_set$sex))
  mean(y_hat == train_set$sex)
})
data.frame(cutoff, accuracy) %>% 
  ggplot(aes(cutoff, accuracy)) + 
  geom_point() + 
  geom_line() 
max(accuracy)

best_cutoff <- cutoff[which.max(accuracy)]
best_cutoff

y_hat <- ifelse(test_set$height > best_cutoff, "Male", "Female") %>% 
  factor(levels = levels(test_set$sex))
y_hat <- factor(y_hat)
mean(y_hat == test_set$sex)

# tabulate each combination of prediction and actual value
table(predicted = y_hat, actual = test_set$sex)
test_set %>% 
  mutate(y_hat = y_hat) %>%
  group_by(sex) %>% 
  summarize(accuracy = mean(y_hat == sex))
prev <- mean(y == "Male")

confusionMatrix(data = y_hat, reference = test_set$sex)


# Creates a confusion matrix, computes accuracy for each sex


# Sensitivity = known as the true positive rate or recall

# Specificity, also known as the true negative rate, is the,
# proportion of actual negative outcomes 

# Prevalence is defined as the proportion of positives


# get the metrics
cm <- confusionMatrix(data = y_hat, reference = test_set$sex)

# access specific metrics
cm$overall["Accuracy"]

cm$byClass[c("Sensitivity","Specificity", "Prevalence")]