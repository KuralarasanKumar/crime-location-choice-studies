# Standardize spatial unit sizes in 20250630_Table.csv to km²
# Output: Adds a new column 'Unit_size_km2' to the table
rm(list=ls())
library(readr)
library(dplyr)
library(stringr)

# Read the CSV
df <- read_csv("20250630_Table.csv")


# Helper function to convert to km² (matches new, clean units: "km²", "m²", "mi²")
to_km2 <- function(size, unit) {
  size <- as.numeric(gsub(",", "", trimws(size)))
  unit <- trimws(unit)
  if (is.na(size) | is.na(unit) | unit == "") return(NA)
  if (unit == "km²") {
    return(size)
  } else if (unit == "m²") {
    return(size / 1e6)
  } else if (unit == "mi²") {
    return(size * 2.58999)
  } else {
    return(NA)
  }
}


# Apply conversion and place new column next to 'Unit'
df$Unit_size_km2 <- mapply(to_km2, df$`Size of the unit`, df$Unit)
# Reorder columns: place 'Unit_size_km2' after 'Unit'
unit_idx <- which(names(df) == "Unit")
if (length(unit_idx) == 1) {
  df <- df[, append(1:ncol(df), after = unit_idx, values = ncol(df))]
}

# Write to new CSV
write_csv(df, "20250630_Table_standardized.csv")

cat("Standardization complete. Output: 20250630_Table_standardized.csv\n")
