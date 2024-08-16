library(matrixStats)
library(tidyverse)
library(caret)
library(dslabs)
library(randomForest)

data(brca)

## Verinin yapisi ve özet bilgisi
str(brca)

summary(brca$x)

dim(brca$x)

brca$x <- scale(brca$x)

## lojistik regresyon modeli
model <- train(brca$x, brca$y, method = "glm", family = "binomial")

## malign tümörlerin orani hesaplaniyor
malignant_count <- sum(brca$y == "M")


total_samples <- length(brca$y)


proportion_malignant <- malignant_count / total_samples

proportion_malignant

## her kolonun ortalama ve standart sapmalari hesaplaniyor
column_means <- colMeans(brca$x)


max_mean_column <- which.max(column_means)

max_mean_column


## en kucuk standart sapmaya sahip kolonlar:
column_sds <- apply(brca$x, 2, sd)


min_sd_column <- which.min(column_sds)
min_sd_column


column_means <- colMeans(brca$x)
column_sds <- apply(brca$x, 2, sd)

# kolon ortalamalari bulunuyor, standart sapmalara bolunerek tekrar olceklendirme islemi
brca_scaled <- sweep(brca$x, 2, column_means, FUN = "-")

brca_scaled <- sweep(brca_scaled, 2, column_sds, FUN = "/")


first_column_sd <- sd(brca_scaled[, 1])
first_column_sd

column_means <- colMeans(brca$x)
column_sds <- apply(brca$x, 2, sd)


first_column_median <- median(brca_scaled[, 1])
first_column_median

## PCA, veri setindeki en fazla varyansi aciklayan bilesenleri buluyor
pca_result <- prcomp(brca_scaled)


pca_variance_explained <- pca_result$sdev^2 / sum(pca_result$sdev^2)


first_pc_variance <- pca_variance_explained[1]

first_pc_variance

pca_result <- prcomp(brca_scaled)


pca_variance_explained <- pca_result$sdev^2 / sum(pca_result$sdev^2)

## %90 inin aciklayan en az kac bilesen gerekiyor? Toplam varyansin
cumulative_variance_explained <- cumsum(pca_variance_explained)


num_components <- which(cumulative_variance_explained >= 0.90)[1]
num_components


pca_result <- prcomp(brca_scaled)

## Plot kullanarak veri gorsellestirme
pc_scores <- pca_result$x[, 1:2]


plot_data <- data.frame(PC1 = pc_scores[, 1], PC2 = pc_scores[, 2], TumorType = brca$y)


ggplot(plot_data, aes(x = PC1, y = PC2, color = TumorType)) +
  geom_point(alpha = 0.6) +
  labs(title = "PCA of Breast Cancer Data",
       x = "Benign",
       y = "Malignant",
       color = "Tumor Type") +
  theme_minimal()

pca_result <- prcomp(brca_scaled)


pc_scores <- pca_result$x[, 1:10]


plot_data <- data.frame(pc_scores, TumorType = brca$y)


plot_data_long <- gather(plot_data, key = "PC", value = "Score", -TumorType)


ggplot(plot_data_long, aes(x = PC, y = Score, fill = TumorType)) +
  geom_boxplot() +
  labs(title = "Boxplots of the First 10 Principal Components by Tumor Type",
       x = "Principal Component",
       y = "Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


## Random forest modeli, hiperparametre arama ile egitiliyor
set.seed(9)

tuning_grid <- expand.grid(mtry = c(3, 5, 7, 9))


rf_model <- train(
  train_x, train_y,
  method = "rf",
  tuneGrid = tuning_grid,
  importance = TRUE
)


best_mtry <- rf_model$bestTune$mtry
best_mtry


## tahmin etme islemi
rf_predictions <- predict(rf_model, test_x)

## rf accuracy
rf_accuracy <- mean(rf_predictions == test_y)
rf_accuracy

## feature larin modeldeki onemini hesaplama
importance_values <- varImp(rf_model)


print(importance_values)


most_important_var <- rownames(importance_values$importance)[which.max(importance_values$importance)]
most_important_var

logistic_predictions <- predict(logistic_model, test_x)
loess_predictions <- predict(loess_model, test_x)
knn_predictions <- predict(knn_model, test_x)
rf_predictions <- predict(rf_model, test_x)


predictions_matrix <- data.frame(
  logistic = logistic_predictions,
  loess = loess_predictions,
  knn = knn_predictions,
  rf = rf_predictions
)

## Birden fazla modelin tahminleri birlestirilerek toplu bir tahmin
ensemble_majority_vote <- apply(predictions_matrix, 1, function(row) {
  ifelse(sum(row == "M") > sum(row == "B"), "M", "B")
})

## accuracy hessaplama
ensemble_accuracy <- mean(ensemble_majority_vote == test_y)
ensemble_accuracy

