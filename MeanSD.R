library(tidyverse)
library(caret)
library(MASS)


# Now we will repeat the exercise above but using larger 
# datasets. Write a function that takes a size n, then (1)
# builds a dataset using the code provided at the top of Q1 but 
# with n observations instead of 100 and without the set.seed(1), (2) 
# replicate() loop that you wrote to answer Q1, which builds 100 
# linear models and returns a vector of RMSEs, and (3) calculates 
# the mean and standard deviation of the 100 RMSEs.

# Set the seed to 1 and then use sapply() or map() to apply your 
# new function to n <- c(100, 500, 1000, 5000, 10000).

# Function to generate dataset, compute RMSEs, and return mean and SD of RMSEs
calculate_rmse_stats <- function(n) {
  # Generate dataset with n observations
  Sigma <- 9 * matrix(c(1.0, 0.5, 0.5, 1.0), 2, 2)
  dat <- MASS::mvrnorm(n = n, c(69, 69), Sigma) %>%
    data.frame() %>% setNames(c("x", "y"))
  
  # Function to calculate RMSE
  calculate_rmse <- function(train_indices, test_indices) {
    train_set <- dat[train_indices, ]
    test_set <- dat[test_indices, ]
    
    model <- lm(y ~ x, data = train_set)
    predictions <- predict(model, newdata = test_set)
    rmse <- sqrt(mean((test_set$y - predictions)^2))
    
    return(rmse)
  }
  
  # Replicate 100 times to get RMSE values
  rmse_values <- replicate(100, {
    indices <- createDataPartition(dat$y, p = 0.5, list = FALSE)
    train_indices <- indices
    test_indices <- setdiff(seq_len(n), train_indices)
    
    calculate_rmse(train_indices, test_indices)
  })
  
  # Calculate mean and standard deviation of RMSE values
  mean_rmse <- mean(rmse_values)
  sd_rmse <- sd(rmse_values)
  
  return(c(mean_rmse = mean_rmse, sd_rmse = sd_rmse))
}

# Set seed for reproducibility
set.seed(1)

# Apply the function to different sizes of n
n_values <- c(100, 500, 1000, 5000, 10000)
results <- sapply(n_values, calculate_rmse_stats)

# Print results
results_df <- as.data.frame(t(results))
colnames(results_df) <- c("Mean RMSE", "Standard Deviation of RMSE")
print(results_df)
