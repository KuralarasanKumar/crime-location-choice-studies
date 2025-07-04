# EXAMPLE R CODE FOR PARSING CSV-OPTIMIZED ELICIT OUTPUT
# This shows how the new structured format makes parsing trivial

library(dplyr)
library(stringr)

# Function to parse structured Elicit output
parse_elicit_output <- function(elicit_text) {
  
  # Extract all FIELD_## entries using regex
  field_pattern <- "FIELD_(\\d+):\\s*(.+?)(?=FIELD_\\d+:|$)"
  matches <- str_match_all(elicit_text, field_pattern)[[1]]
  
  # Create a data frame with field numbers and values
  if(nrow(matches) > 0) {
    fields_df <- data.frame(
      field_num = as.numeric(matches[,2]),
      field_value = str_trim(matches[,3]),
      stringsAsFactors = FALSE
    )
    
    # Convert to named list for easy access
    field_list <- setNames(fields_df$field_value, paste0("FIELD_", sprintf("%02d", fields_df$field_num)))
    
    return(field_list)
  } else {
    return(NULL)
  }
}

# Function to parse variable lists (Fields 30-40)
parse_variable_list <- function(variable_string) {
  if(is.na(variable_string) || variable_string == "Not available" || variable_string == "") {
    return(data.frame())
  }
  
  # Split by semicolons to get individual variables
  variables <- str_split(variable_string, ";\\s*")[[1]]
  
  # Parse each variable (Variable|Description|Unit|Source)
  var_details <- map_dfr(variables, function(var) {
    parts <- str_split(var, "\\|")[[1]]
    data.frame(
      variable_name = ifelse(length(parts) >= 1, str_trim(parts[1]), ""),
      description = ifelse(length(parts) >= 2, str_trim(parts[2]), ""),
      unit = ifelse(length(parts) >= 3, str_trim(parts[3]), ""),
      source = ifelse(length(parts) >= 4, str_trim(parts[4]), ""),
      stringsAsFactors = FALSE
    )
  })
  
  return(var_details)
}

# Example usage:
elicit_output <- "
FIELD_01: Spatial Choice of Crime: A Case Study of Residential Burglary
FIELD_02: 2008
FIELD_03: John Smith; Jane Doe
FIELD_04: United States
FIELD_30: POPDENS|Population density|persons/km²|Census; MEDINC|Median income|dollars|ACS
FIELD_31: UNEMPRATE|Unemployment rate|percentage|BLS
"

# Parse the output
parsed_data <- parse_elicit_output(elicit_output)

# Access specific fields
study_title <- parsed_data$FIELD_01
publication_year <- parsed_data$FIELD_02
authors <- str_split(parsed_data$FIELD_03, ";\\s*")[[1]]

# Parse variable lists
demographic_vars <- parse_variable_list(parsed_data$FIELD_30)
economic_vars <- parse_variable_list(parsed_data$FIELD_31)

print("Demographic Variables:")
print(demographic_vars)

print("Economic Variables:")
print(economic_vars)

# Create final structured dataset
create_final_dataset <- function(parsed_elicit_data) {
  
  # Basic study info
  study_info <- data.frame(
    study_title = parsed_elicit_data$FIELD_01,
    publication_year = as.numeric(parsed_elicit_data$FIELD_02),
    authors = parsed_elicit_data$FIELD_03,
    country = parsed_elicit_data$FIELD_04,
    city_region = parsed_elicit_data$FIELD_05,
    crime_type = parsed_elicit_data$FIELD_06,
    study_period = parsed_elicit_data$FIELD_07,
    spatial_unit_type = parsed_elicit_data$FIELD_08,
    spatial_unit_size = parsed_elicit_data$FIELD_09,
    number_spatial_units = as.numeric(parsed_elicit_data$FIELD_10),
    study_area_size = parsed_elicit_data$FIELD_11,
    population_per_unit = parsed_elicit_data$FIELD_12,
    study_design = parsed_elicit_data$FIELD_13,
    statistical_method = parsed_elicit_data$FIELD_14,
    model_type = parsed_elicit_data$FIELD_15,
    sample_size = parsed_elicit_data$FIELD_16,
    software_used = parsed_elicit_data$FIELD_17,
    
    # Variable counts
    total_variables = as.numeric(parsed_elicit_data$FIELD_18),
    demographic_count = as.numeric(parsed_elicit_data$FIELD_19),
    economic_count = as.numeric(parsed_elicit_data$FIELD_20),
    landuse_count = as.numeric(parsed_elicit_data$FIELD_21),
    infrastructure_count = as.numeric(parsed_elicit_data$FIELD_22),
    distance_count = as.numeric(parsed_elicit_data$FIELD_23),
    opportunity_count = as.numeric(parsed_elicit_data$FIELD_24),
    social_count = as.numeric(parsed_elicit_data$FIELD_25),
    environmental_count = as.numeric(parsed_elicit_data$FIELD_26),
    temporal_count = as.numeric(parsed_elicit_data$FIELD_27),
    jurisdiction_count = as.numeric(parsed_elicit_data$FIELD_28),
    other_count = as.numeric(parsed_elicit_data$FIELD_29),
    
    # Quality and findings
    data_sources = parsed_elicit_data$FIELD_41,
    key_findings = parsed_elicit_data$FIELD_42,
    significant_predictors = parsed_elicit_data$FIELD_43,
    model_performance = parsed_elicit_data$FIELD_44,
    variable_quality = parsed_elicit_data$FIELD_45,
    missing_information = parsed_elicit_data$FIELD_46,
    extraction_confidence = parsed_elicit_data$FIELD_47,
    additional_notes = parsed_elicit_data$FIELD_48,
    data_collection_method = parsed_elicit_data$FIELD_49,
    validation_methods = parsed_elicit_data$FIELD_50,
    
    stringsAsFactors = FALSE
  )
  
  return(study_info)
}

# Example: Process multiple Elicit extractions
process_elicit_csv <- function(csv_file_path) {
  
  # Read the Elicit CSV (assuming it has a column with the structured output)
  elicit_data <- read.csv(csv_file_path, stringsAsFactors = FALSE)
  
  # Process each row (each paper)
  all_studies <- map_dfr(1:nrow(elicit_data), function(i) {
    
    # Extract the structured output (assuming it's in a column called "extraction_output")
    elicit_text <- elicit_data$extraction_output[i]
    
    # Parse the structured output
    parsed_data <- parse_elicit_output(elicit_text)
    
    if(!is.null(parsed_data)) {
      study_data <- create_final_dataset(parsed_data)
      study_data$row_id <- i
      return(study_data)
    } else {
      return(NULL)
    }
  })
  
  return(all_studies)
}

# Create comprehensive variable dataset
create_variable_dataset <- function(parsed_elicit_data) {
  
  variable_categories <- list(
    "Demographic" = parsed_elicit_data$FIELD_30,
    "Economic" = parsed_elicit_data$FIELD_31,
    "Land Use" = parsed_elicit_data$FIELD_32,
    "Infrastructure" = parsed_elicit_data$FIELD_33,
    "Distance/Accessibility" = parsed_elicit_data$FIELD_34,
    "Crime Opportunity" = parsed_elicit_data$FIELD_35,
    "Social/Behavioral" = parsed_elicit_data$FIELD_36,
    "Environmental" = parsed_elicit_data$FIELD_37,
    "Temporal/Control" = parsed_elicit_data$FIELD_38,
    "Jurisdiction/Policy" = parsed_elicit_data$FIELD_39,
    "Other" = parsed_elicit_data$FIELD_40
  )
  
  all_variables <- map_dfr(names(variable_categories), function(category) {
    vars <- parse_variable_list(variable_categories[[category]])
    if(nrow(vars) > 0) {
      vars$category <- category
      vars$study_title <- parsed_elicit_data$FIELD_01
      return(vars)
    } else {
      return(NULL)
    }
  })
  
  return(all_variables)
}

cat("
BENEFITS OF THE NEW CSV-OPTIMIZED FORMAT:

1. TRIVIAL PARSING: Simple regex patterns extract all fields
2. NO AMBIGUITY: Every field has a unique identifier
3. CONSISTENT SEPARATORS: Semicolons for lists, pipes for details
4. PROGRAMMATIC FRIENDLY: Easy to convert to data frames
5. VALIDATION READY: Can check if all 50 fields are present
6. SCALABLE: Works for any number of papers

The parsing code above shows how easy it is to:
- Extract all 50 fields with a single regex
- Parse complex variable lists into structured data
- Create publication-ready datasets
- Validate completeness and quality
")
