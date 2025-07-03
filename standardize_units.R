# Standardize spatial unit sizes to km²
rm(list=ls())
library(dplyr)

# Read input data
df_raw_data <- read.csv("20250702_Table.csv", stringsAsFactors = FALSE)

# Convert unit sizes to km², remove Note, sort, create Study_ID, rearrange columns
df_data_clean <- df_raw_data %>%
  mutate(
    Unit_size_km2 = case_when(
      Unit == "m2" ~ as.numeric(`Size_of_the_unit`) / 1e6,
      Unit == "km2" ~ as.numeric(`Size_of_the_unit`),
      TRUE ~ NA_real_
    )
  ) %>%
  select(-Note) %>%
  arrange(Unit_size_km2) %>%
  mutate(Study_ID = row_number()) %>%
  select(
    Study_ID, `Title_of_the_study`, Citation, `Size_of_the_unit`, Unit, 
    Unit_size_km2, `No_of_units`, `No_of_incidents`, `Name_of_the_unit`, `Inferred_size`
  )

# Save results with UTF-8 encoding
write.csv(df_data_clean, "20250703_standardized_unit_sizes.csv", row.names = FALSE, fileEncoding = "UTF-8")

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
    Unit_size_km2, Size_group, `Name_of_the_unit`, `No_of_units`, `No_of_incidents`, `Inferred_size`
  )
# Print frequency table for size groups
print(table(df_data_clean$Size_group))

# Optionally, save the updated data with the new column
write.csv(df_data_clean, "20250703_standardized_unit_sizes_with_groups.csv", row.names = FALSE, fileEncoding = "UTF-8")


