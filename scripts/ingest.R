# Ingest Script
# Downloads UCI Adult Dataset

library(readr)

# Dataset URL
url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data"

# Column names (since raw file has no header)
cols <- c("age", "workclass", "fnlwgt", "education", "education_num",
          "marital_status", "occupation", "relationship", "race",
          "sex", "capital_gain", "capital_loss", "hours_per_week",
          "native_country", "income")

# Download and save dataset
adult_data <- read_csv(url, col_names = cols)

# Save to raw data folder
write_csv(adult_data, "data/raw/adult.csv")

cat("Data ingestion complete. File saved to data/raw/adult.csv\n")
