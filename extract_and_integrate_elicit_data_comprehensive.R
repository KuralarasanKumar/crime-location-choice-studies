#!/usr/bin/env Rscript
# Comprehensive R Script - Improved Simple Join with All Fields

suppressMessages({
  library(readr)
  library(dplyr)
  library(stringr)
  library(RecordLinkage)
})

# Helper functions
clean_title_for_matching <- function(title) {
  if (is.na(title)) return("")
  title <- tolower(as.character(title))
  title <- str_squish(title)
  title <- str_replace_all(title, "[^\\w\\s]", "")
  return(title)
}

find_best_title_match <- function(target_title, candidate_titles, threshold = 0.6) {
  target_clean <- clean_title_for_matching(target_title)
  best_match_idx <- NULL
  best_score <- 0
  
  for (i in seq_along(candidate_titles)) {
    candidate_clean <- clean_title_for_matching(candidate_titles[i])
    score <- jarowinkler(target_clean, candidate_clean)
    
    if (score > best_score && score >= threshold) {
      best_score <- score
      best_match_idx <- i
    }
  }
  
  # Manual matching for known cases
  if (is.null(best_match_idx)) {
    if (str_detect(target_clean, "discrete spatial choice model") && 
        str_detect(target_clean, "burglary target selection")) {
      for (i in seq_along(candidate_titles)) {
        if (str_detect(clean_title_for_matching(candidate_titles[i]), 
                      "residential burglary target selection")) {
          best_match_idx <- i
          best_score <- 0.75
          break
        }
      }
    }
  }
  
  return(list(index = best_match_idx, score = best_score))
}

# Improved extraction function that matches Python logic
extract_field <- function(core_info, field_name) {
  if (is.na(core_info)) return("")
  
  # Pattern that matches Python: **Field:** content until next ** or end
  pattern <- paste0("\\*\\*", str_replace_all(field_name, "([\\(\\)])", "\\\\\\1"), 
                   ":\\*\\*\\s*(.*?)(?=\\n\\*\\*|$)")
  
  match_result <- str_extract(core_info, regex(pattern, dotall = TRUE, ignore_case = TRUE))
  
  if (!is.na(match_result)) {
    content <- str_remove(match_result, paste0("\\*\\*", str_replace_all(field_name, "([\\(\\)])", "\\\\\\1"), ":\\*\\*\\s*"))
    content <- str_remove_all(content, "\\[.*?\\]")  # Remove [Not specified] etc
    content <- str_replace_all(content, "\\s+", " ")  # Normalize whitespace
    content <- str_trim(content)
    return(content)
  }
  return("")
}

# Extract variable counts like Python
extract_variable_counts <- function(core_info) {
  if (is.na(core_info)) return(rep(0, 10))
  
  # Find variable summary section
  pattern <- "## VARIABLE SUMMARY COUNTS(.*?)(?=## |$)"
  summary_section <- str_extract(core_info, regex(pattern, dotall = TRUE, ignore_case = TRUE))
  
  if (is.na(summary_section)) {
    return(rep(0, 10))
  }
  
  # Extract individual counts
  patterns <- list(
    "\\*\\*Total Independent Variables:\\*\\*\\s*(\\d+)",
    "\\*\\*Demographic Variables:\\*\\*\\s*(\\d+)",
    "\\*\\*Economic Variables:\\*\\*\\s*(\\d+)",
    "\\*\\*Land Use Variables:\\*\\*\\s*(\\d+)",
    "\\*\\*Infrastructure Variables:\\*\\*\\s*(\\d+)",
    "\\*\\*Distance[/\\\\]Accessibility Variables:\\*\\*\\s*(\\d+)",
    "\\*\\*Crime Opportunity Variables:\\*\\*\\s*(\\d+)",
    "\\*\\*Social[/\\\\]Behavioral Variables:\\*\\*\\s*(\\d+)",
    "\\*\\*Environmental Variables:\\*\\*\\s*(\\d+)",
    "\\*\\*Temporal[/\\\\]Control Variables:\\*\\*\\s*(\\d+)"
  )
  
  counts <- sapply(patterns, function(p) {
    match <- str_extract(summary_section, regex(p, ignore_case = TRUE))
    if (!is.na(match)) {
      num <- as.numeric(str_extract(match, "\\d+"))
      return(ifelse(is.na(num), 0, num))
    }
    return(0)
  })
  
  return(unname(counts))
}

# Main script
message("Reading data files...")
standardized_data <- read_csv("20250703_standardized_unit_sizes_with_groups.csv", show_col_types = FALSE)
elicit_data <- read_csv("Elicit - Extract from 49 papers - core infor.csv", show_col_types = FALSE)

# Clean titles for matching
standardized_data$title_clean <- sapply(standardized_data$Title_of_the_study, clean_title_for_matching)
elicit_data$title_clean <- sapply(elicit_data$Title, clean_title_for_matching)

message("Extracting comprehensive fields from Elicit data...")

# Extract all fields like Python does
elicit_extracted <- elicit_data %>%
  rowwise() %>%
  mutate(
    # Study context (NO ELICIT PREFIX - matching your request)
    Country = extract_field(.data[["core infor"]], "Country"),
    City_Region = extract_field(.data[["core infor"]], "City/Region"),
    Study_Area_Description = extract_field(.data[["core infor"]], "Study Area Description"),
    Crime_Type = extract_field(.data[["core infor"]], "Crime Type"),
    Study_Period = extract_field(.data[["core infor"]], "Study Period"),
    Data_Sources = extract_field(.data[["core infor"]], "Data Sources"),
    
    # Methodology
    Study_Design = extract_field(.data[["core infor"]], "Study Design"),
    Statistical_Method = extract_field(.data[["core infor"]], "Statistical Method"),
    Model_Type = extract_field(.data[["core infor"]], "Model Type"),
    Software_Used = extract_field(.data[["core infor"]], "Software Used"),
    Sampling_Approach = extract_field(.data[["core infor"]], "Sampling Approach"),
    Sample_Size = extract_field(.data[["core infor"]], "Sample Size"),
    Choice_Set_Definition = extract_field(.data[["core infor"]], "Choice Set Definition"),
    Estimation_Method = extract_field(.data[["core infor"]], "Estimation Method"),
    
    # Key findings
    Main_Results = extract_field(.data[["core infor"]], "Main Results"),
    Significant_Predictors = extract_field(.data[["core infor"]], "Significant Predictors"),
    Model_Performance = extract_field(.data[["core infor"]], "Model Performance"),
    Scale_Effects = extract_field(.data[["core infor"]], "Scale Effects"),
    
    # Data quality
    Variable_Info_Quality = extract_field(.data[["core infor"]], "Variable Information Quality"),
    Missing_Information = extract_field(.data[["core infor"]], "Missing Information"),
    Extraction_Confidence = extract_field(.data[["core infor"]], "Extraction Confidence")
  ) %>%
  ungroup()

# Add variable counts
message("Extracting variable counts...")
var_counts <- t(sapply(elicit_data$`core infor`, extract_variable_counts))
colnames(var_counts) <- c("Total_Variables", "Demographic_Vars", "Economic_Vars", 
                         "LandUse_Vars", "Infrastructure_Vars", "Distance_Vars",
                         "Crime_Opportunity_Vars", "Social_Vars", "Environmental_Vars", "Temporal_Vars")

elicit_extracted <- bind_cols(elicit_extracted, as.data.frame(var_counts))

# Select relevant columns for joining
elicit_extracted <- elicit_extracted %>%
  select(title_clean, Title, Authors, Year, Country, City_Region, Study_Area_Description,
         Crime_Type, Study_Period, Data_Sources, Study_Design, Statistical_Method,
         Model_Type, Software_Used, Sampling_Approach, Sample_Size, Choice_Set_Definition,
         Estimation_Method, Total_Variables, Demographic_Vars, Economic_Vars, LandUse_Vars,
         Infrastructure_Vars, Distance_Vars, Crime_Opportunity_Vars, Social_Vars,
         Environmental_Vars, Temporal_Vars, Main_Results, Significant_Predictors,
         Model_Performance, Scale_Effects, Variable_Info_Quality, Missing_Information,
         Extraction_Confidence)

message("Performing join...")
result <- standardized_data %>%
  left_join(elicit_extracted, by = "title_clean") %>%
  select(-title_clean)

# Rename Title columns to avoid confusion
result <- result %>%
  rename(
    Title_Elicit = Title,
    Year_Elicit = Year,
    Authors_Elicit = Authors
  )

# Handle multi-country studies
message("Handling multi-country studies...")
result <- result %>%
  mutate(
    # Update Country for multi-country studies based on study title
    Country = case_when(
      str_detect(Title_of_the_study, "Burglar Target Selection.*Cross-national.*\\(NL\\)") ~ "Netherlands",
      str_detect(Title_of_the_study, "Burglar Target Selection.*Cross-national.*\\(UK\\)") ~ "United Kingdom", 
      str_detect(Title_of_the_study, "Burglar Target Selection.*Cross-national.*\\(AU\\)") ~ "Australia",
      TRUE ~ Country
    ),
    # Update City_Region accordingly
    City_Region = case_when(
      str_detect(Title_of_the_study, "Burglar Target Selection.*Cross-national.*\\(NL\\)") ~ "Netherlands (multiple cities)",
      str_detect(Title_of_the_study, "Burglar Target Selection.*Cross-national.*\\(UK\\)") ~ "United Kingdom (multiple areas)",
      str_detect(Title_of_the_study, "Burglar Target Selection.*Cross-national.*\\(AU\\)") ~ "Australia (multiple cities)",
      TRUE ~ City_Region
    )
  )

# Save the comprehensive result
output_file <- "20250704_comprehensive_dataset_with_elicit_R_comprehensive.csv"
message(paste("Writing comprehensive output to:", output_file))
write_csv(result, output_file, na = "")

# Summary
message("Summary:")
message(paste("- Total rows:", nrow(result)))
message(paste("- Total columns:", ncol(result)))
message(paste("- Studies with Country data:", sum(!is.na(result$Country) & result$Country != "")))
message(paste("- Studies with Crime Type data:", sum(!is.na(result$Crime_Type) & result$Crime_Type != "")))
message(paste("- Studies with Statistical Method data:", sum(!is.na(result$Statistical_Method) & result$Statistical_Method != "")))
message(paste("- Studies with Elicit data:", sum(!is.na(result$Title_Elicit) & result$Title_Elicit != "")))

message("Comprehensive R script completed successfully!")
message("This output should closely match the Python version with all fields extracted.")
message("Column names are clean (no 'Elicit_' prefix for main fields like Country, Crime_Type, etc.)")
