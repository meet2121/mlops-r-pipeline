# Preprocessing Script
# Data cleaning, encoding, splitting

library(readr)
library(dplyr)
library(caret)

set.seed(42)

# Load data
data <- read_csv("data/raw/adult.csv", show_col_types = FALSE)

cat("Data loaded for preprocessing\n")

# Convert character columns to factors
data <- data %>% mutate(across(where(is.character), as.factor))

# Clean target column (remove spaces if any)
# Clean and format target variable
data$income <- trimws(data$income)
data$income <- ifelse(data$income == ">50K", "high", "low")
data$income <- as.factor(data$income)

cat("Target variable cleaned and converted to binary factor\n")

cat("Categorical encoding completed\n")

# Train-Test Split (80-20)
train_index <- createDataPartition(data$income, p = 0.8, list = FALSE)
train_data <- data[train_index, ]
test_data  <- data[-train_index, ]

# Save processed data
write_csv(train_data, "data/processed/train.csv")
write_csv(test_data, "data/processed/test.csv")

cat("Train-Test split done and files saved in data/processed/\n")
