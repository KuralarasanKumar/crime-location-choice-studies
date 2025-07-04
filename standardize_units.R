# Standardize spatial unit sizes to km²
rm(list=ls())
library(dplyr)

# Read input data - using the comprehensive dataset with Elicit data
df_raw_data <- read.csv("20250704_comprehensive_dataset_with_elicit.csv", stringsAsFactors = FALSE)

# Convert unit sizes to km², sort, create Study_ID (if not exists), rearrange columns
df_data_clean <- df_raw_data %>%
  mutate(
    Unit_size_km2 = case_when(
      Unit == "m2" ~ as.numeric(`Size_of_the_unit`) / 1e6,
      Unit == "km2" ~ as.numeric(`Size_of_the_unit`),
      TRUE ~ NA_real_
    )
  ) %>%
  arrange(Unit_size_km2) %>%
  # Only create Study_ID if it doesn't exist or renumber for sorting
  mutate(Study_ID = row_number()) %>%
  select(
    Study_ID, `Title_of_the_study`, Citation, `Size_of_the_unit`, Unit, 
    Unit_size_km2, `No_of_units`, `No_of_incidents`, `Name_of_the_unit`, `Inferred_size`,
    `DOI`, `ISSN`, `Journal`, `Volume`, `Issue`,
    # Key Elicit-derived variables for enhanced analysis
    `Elicit_Country`, `Elicit_City_Region`, `Elicit_Crime_Type`, `Elicit_Data_Sources`, 
    `Elicit_Sample_Size_Elicit`, `Elicit_Study_Period`, `Elicit_Statistical_Method`, `Elicit_Model_Type`,
    `Elicit_Main_Results`, `Elicit_Model_Performance`, `Elicit_Total_Variables`, `Elicit_Extraction_Confidence`
  )

# Save results with UTF-8 encoding - now includes Elicit data
write.csv(df_data_clean, "20250704_standardized_unit_sizes_with_elicit.csv", row.names = FALSE, fileEncoding = "UTF-8")

str(df_data_clean)

# Print summary statistics for Unit_size_km2
print(summary(df_data_clean$Unit_size_km2))

# Print frequency table for Name_of_the_unit
print(table(df_data_clean$Name_of_the_unit))

# Add size group column based on preferred breakpoints
size_breaks <- c(-Inf, 0.001, 1.2, 1.63293, 5, Inf)
size_labels <- c("very small", "small", "medium", "large", "very large")

# Add size group column and rearrange columns 
df_data_clean <- df_data_clean %>%
  mutate(
    Size_group = cut(
      Unit_size_km2,
      breaks = size_breaks,
      labels = size_labels,
      right = FALSE
    )
  ) %>%
  select(
    Study_ID, `Title_of_the_study`, Citation, `Size_of_the_unit`, Unit, 
    Unit_size_km2, Size_group, `Name_of_the_unit`, `No_of_units`, `No_of_incidents`, `Inferred_size`,
    `DOI`, `ISSN`, `Journal`, `Volume`, `Issue`,
    # Key Elicit-derived variables for enhanced analysis
    `Elicit_Country`, `Elicit_City_Region`, `Elicit_Crime_Type`, `Elicit_Data_Sources`, 
    `Elicit_Sample_Size_Elicit`, `Elicit_Study_Period`, `Elicit_Statistical_Method`, `Elicit_Model_Type`,
    `Elicit_Main_Results`, `Elicit_Model_Performance`, `Elicit_Total_Variables`, `Elicit_Extraction_Confidence`
  )
# Print frequency table for size groups
print(table(df_data_clean$Size_group))

# Additional analysis of Elicit-derived variables
cat("\n=== ELICIT DATA ANALYSIS ===\n")

# Geographic distribution
cat("\nCountry Distribution:\n")
print(table(df_data_clean$Elicit_Country, useNA = "ifany"))

# Crime type distribution
cat("\nCrime Type Distribution:\n")
print(table(df_data_clean$Elicit_Crime_Type, useNA = "ifany"))

# Statistical method distribution
cat("\nStatistical Method Distribution:\n")
print(table(df_data_clean$Elicit_Statistical_Method, useNA = "ifany"))

# Model type distribution
cat("\nModel Type Distribution:\n")
print(table(df_data_clean$Elicit_Model_Type, useNA = "ifany"))

# Extraction confidence summary
cat("\nExtraction Confidence Summary:\n")
print(summary(as.numeric(df_data_clean$Elicit_Extraction_Confidence)))

# Variable count summary
cat("\nTotal Variables Summary:\n")
print(summary(as.numeric(df_data_clean$Elicit_Total_Variables)))

# Data completeness for key Elicit fields
cat("\nData Completeness for Elicit Fields:\n")
elicit_fields <- c("Elicit_Country", "Elicit_Crime_Type", "Elicit_Data_Sources", 
                   "Elicit_Statistical_Method", "Elicit_Total_Variables", "Elicit_Extraction_Confidence")
for(field in elicit_fields) {
  non_na_count <- sum(!is.na(df_data_clean[[field]]) & df_data_clean[[field]] != "")
  total_count <- nrow(df_data_clean)
  cat(sprintf("%s: %d/%d (%.1f%%)\n", field, non_na_count, total_count, 
              100 * non_na_count / total_count))
}

# Optionally, save the updated data with the new column and Elicit data
write.csv(df_data_clean, "20250704_standardized_unit_sizes_with_groups_and_elicit.csv", row.names = FALSE, fileEncoding = "UTF-8")


str(df_data_clean)
