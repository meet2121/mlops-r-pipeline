# Evaluation Script
# Model testing + metrics logging

library(readr)
library(dplyr)
library(caret)
library(jsonlite)
library(gbm)

test_data <- read_csv("data/processed/test.csv", show_col_types = FALSE)
test_data <- test_data %>% mutate(across(where(is.character), as.factor))

# Load training data to get correct factor levels
train_data <- read_csv("data/processed/train.csv", show_col_types = FALSE)
train_data <- train_data %>% mutate(across(where(is.character), as.factor))

# Align factor levels
for(col in names(train_data)) {
  if(is.factor(train_data[[col]])) {
    test_data[[col]] <- factor(test_data[[col]], levels = levels(train_data[[col]]))
  }
}

cat("Factor levels aligned between train and test\n")

# Remove rows with unseen categories that became NA
before_rows <- nrow(test_data)
test_data <- na.omit(test_data)
test_data$income <- factor(test_data$income, levels = c("low", "high"))
after_rows <- nrow(test_data)

cat("Rows removed due to unseen categories:", before_rows - after_rows, "\n")


cat("Test data loaded\n")

# Load models
model_log <- readRDS("models/logistic_model.rds")
model_rf  <- readRDS("models/rf_model.rds")
model_gbm <- readRDS("models/gbm_model.rds")

cat("Models loaded\n")

# ---------------- Logistic ----------------
pred_log <- ifelse(predict(model_log, test_data, type = "response") > 0.5, "high", "low")
acc_log <- mean(pred_log == test_data$income)
cat("Logistic Accuracy:", acc_log, "\n")

# ---------------- Random Forest ----------------
pred_rf <- predict(model_rf, test_data)
acc_rf <- mean(pred_rf == test_data$income)
cat("RF Accuracy:", acc_rf, "\n")

# ---------------- GBM ----------------
test_data$income_num <- ifelse(test_data$income == "high", 1, 0)
pred_gbm_prob <- predict(model_gbm, test_data, n.trees = 50, type = "response")
pred_gbm <- ifelse(pred_gbm_prob > 0.5, 1, 0)
acc_gbm <- mean(pred_gbm == test_data$income_num)
cat("GBM Accuracy:", acc_gbm, "\n")

# Save metrics to JSON
metrics <- list(
  logistic_accuracy = acc_log,
  rf_accuracy = acc_rf,
  gbm_accuracy = acc_gbm
)

write_json(metrics, "metrics/metrics.json", pretty = TRUE)

cat("Metrics saved to metrics/metrics.json\n")
