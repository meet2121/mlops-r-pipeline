# Training Script
# Trains ML models

library(readr)
library(dplyr)
library(caret)
library(randomForest)
library(gbm)

set.seed(42)

# Load processed training data
train_data <- read_csv("data/processed/train.csv", show_col_types = FALSE)

cat("Training data loaded\n")

# Convert character columns back to factors
train_data <- train_data %>% mutate(across(where(is.character), as.factor))

# Ensure correct class order: low < high
train_data$income <- factor(train_data$income, levels = c("low", "high"))

cat("Data types corrected for training\n")

# ---------------- Logistic Regression ----------------
model_log <- glm(income ~ ., data = train_data, family = "binomial")
cat("Logistic Regression trained\n")

# ---------------- Random Forest ----------------
model_rf <- randomForest(income ~ ., data = train_data, ntree = 50)
cat("Random Forest trained\n")

# ---------------- Gradient Boosting ----------------
# Convert target to numeric 0/1 for gbm
train_data$income_num <- ifelse(train_data$income == "high", 1, 0)

model_gbm <- gbm(income_num ~ . - income,
                 data = train_data,
                 distribution = "bernoulli",
                 n.trees = 50,
                 interaction.depth = 3,
                 shrinkage = 0.1,
                 verbose = FALSE)

cat("GBM trained\n")

# Save models
saveRDS(model_log, "models/logistic_model.rds")
saveRDS(model_rf, "models/rf_model.rds")
saveRDS(model_gbm, "models/gbm_model.rds")

cat("All models saved in models/\n")
