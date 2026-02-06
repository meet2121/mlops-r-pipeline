# Validation Script
# Checks dataset schema and integrity

library(readr)
library(dplyr)

# Load dataset
data <- read_csv("data/raw/adult.csv", show_col_types = FALSE)

cat("Dataset loaded successfully\n")

# Expected columns
expected_cols <- c("age", "workclass", "fnlwgt", "education", "education_num",
                   "marital_status", "occupation", "relationship", "race",
                   "sex", "capital_gain", "capital_loss", "hours_per_week",
                   "native_country", "income")

# Column check
if(all(expected_cols %in% colnames(data))) {
  cat("Schema validation PASSED: All columns present\n")
} else {
  stop("Schema validation FAILED: Missing columns")
}

# Check number of columns
cat("Number of columns:", ncol(data), "\n")

# Missing value check
missing_total <- sum(is.na(data))
cat("Total missing values:", missing_total, "\n")

cat("Validation stage completed\n")
