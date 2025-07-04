#!/usr/bin/env Rscript
# Simple R Script - Join-based approach

# Suppress messages
suppressMessages({
  library(readr)
  library(dplyr)
  library(stringr)
})

# Read the data files
message("Reading data files...")
standardized_data <- read_csv("20250703_standardized_unit_sizes_with_groups.csv", show_col_types = FALSE)
elicit_data <- read_csv("Elicit - Extract from 49 papers - core infor.csv", show_col_types = FALSE)

# Clean titles for matching (vectorized like Python)
clean_title <- function(title) {
  sapply(title, function(t) {
    if (is.na(t)) return("")
    
    t <- str_to_lower(as.character(t))
    t <- str_squish(t)  # equivalent to ' '.join(title.split())
    t <- str_replace_all(t, "[^\\w\\s]", "")  # remove non-word, non-space chars
    return(t)
  }, USE.NAMES = FALSE)
}

# Add cleaned titles for matching
standardized_data$title_clean <- clean_title(standardized_data$Title_of_the_study)
elicit_data$title_clean <- clean_title(elicit_data$Title)

# Extract field from core info - matches Python logic exactly
extract_field <- function(core_info, field_name) {
  if (is.na(core_info)) return("")
  
  # Escape special regex characters in field name
  escaped_field <- str_replace_all(field_name, "([\\(\\)\\[\\]\\*\\+\\?\\{\\}\\|\\^\\$\\.])", "\\\\\\1")
  
  # Pattern that matches Python: **Field Name:** content until next ** or end
  pattern <- paste0("\\*\\*", escaped_field, ":\\*\\*\\s*(.*?)(?=\\n\\*\\*|$)")
  
  # Extract with multiline support
  match_result <- str_extract(core_info, regex(pattern, dotall = TRUE, ignore_case = TRUE))
  
  if (!is.na(match_result)) {
    # Extract just the content part (everything after the field name)
    content <- str_remove(match_result, paste0("\\*\\*", escaped_field, ":\\*\\*\\s*"))
    
    # Clean up content like Python does
    content <- str_remove_all(content, "\\[.*?\\]")  # Remove [Not specified] etc
    content <- str_replace_all(content, "\\s+", " ")  # Normalize whitespace
    content <- str_trim(content)
    
    return(content)
  }
  return("")
}

# Extract key fields from Elicit data
message("Extracting key fields from Elicit data...")
elicit_extracted <- elicit_data %>%
  mutate(
    Country = sapply(.data[["core infor"]], function(x) extract_field(x, "Country")),
    City_Region = sapply(.data[["core infor"]], function(x) extract_field(x, "City/Region")),
    Crime_Type = sapply(.data[["core infor"]], function(x) extract_field(x, "Crime Type")),
    Study_Period = sapply(.data[["core infor"]], function(x) extract_field(x, "Study Period"))
  ) %>%
  select(title_clean, Title, Authors, Year, Country, City_Region, Crime_Type, Study_Period)

# Right join based on title matching
message("Performing right join...")
result <- standardized_data %>%
  left_join(elicit_extracted, by = "title_clean") %>%
  select(-title_clean)

# Print column names for debugging
message("Available columns after join:")
message(paste(colnames(result), collapse = ", "))

# Check if Country extraction worked
message("Sample Country values:")
message(paste(head(result$Country, 10), collapse = " | "))

# Rename columns that exist
result <- result %>%
  rename(
    Title_Elicit = Title,
    Year_Elicit = Year,
    Authors_Elicit = Authors
  )

# Handle duplicated studies by adding country info to distinguish them
# Based on the conversation, there are 3 repeated studies that need country-specific handling
message("Handling repeated studies...")

# Handle multi-country studies like Python does
result <- result %>%
  mutate(
    # For multi-country studies, override with country-specific info
    Country = case_when(
      str_detect(Title_of_the_study, "Burglar Target Selection.*Cross-national.*NL") ~ "Netherlands",
      str_detect(Title_of_the_study, "Burglar Target Selection.*Cross-national.*UK") ~ "United Kingdom", 
      str_detect(Title_of_the_study, "Burglar Target Selection.*Cross-national.*AU") ~ "Australia",
      TRUE ~ Country
    ),
    City_Region = case_when(
      str_detect(Title_of_the_study, "Burglar Target Selection.*Cross-national.*NL") ~ "Netherlands (multiple cities)",
      str_detect(Title_of_the_study, "Burglar Target Selection.*Cross-national.*UK") ~ "United Kingdom (multiple areas)",
      str_detect(Title_of_the_study, "Burglar Target Selection.*Cross-national.*AU") ~ "Australia (multiple cities)",
      TRUE ~ City_Region
    ),
    Title_of_the_study = case_when(
      str_detect(Title_of_the_study, "Burglar Target Selection.*Cross-national.*NL") ~ 
        paste(Title_of_the_study, "(Netherlands)"),
      str_detect(Title_of_the_study, "Burglar Target Selection.*Cross-national.*UK") ~ 
        paste(Title_of_the_study, "(UK)"),
      str_detect(Title_of_the_study, "Burglar Target Selection.*Cross-national.*AU") ~ 
        paste(Title_of_the_study, "(Australia)"),
      TRUE ~ Title_of_the_study
    )
  )

# Clean up and ensure no "Elicit_" prefix
final_columns <- c(
  "Study_ID", "Title_of_the_study", "Citation", "Size_of_the_unit", "Unit", 
  "Unit_size_km2", "Size_group", "Name_of_the_unit", "No_of_units", 
  "No_of_incidents", "Inferred_size", "DOI", "ISSN", "Journal", "Volume", "Issue",
  "Country", "City_Region", "Crime_Type", "Study_Period",
  "Title_Elicit", "Year_Elicit", "Authors_Elicit"
)

# Create final dataset with clean column names
final_result <- result %>%
  select(any_of(final_columns))

# Write the result
output_file <- "20250704_comprehensive_dataset_with_elicit_R_simple.csv"
message(paste("Writing output to:", output_file))
write_csv(final_result, output_file, na = "")

# Print summary
message("Summary:")
message(paste("- Total rows:", nrow(final_result)))
message(paste("- Total columns:", ncol(final_result)))
message(paste("- Studies with Country data:", sum(!is.na(final_result$Country) & final_result$Country != "")))
message(paste("- Studies with Elicit data:", sum(!is.na(final_result$Title_Elicit) & final_result$Title_Elicit != "")))

message("Script completed successfully!")
