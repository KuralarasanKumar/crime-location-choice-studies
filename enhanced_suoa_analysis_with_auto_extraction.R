# Enhanced SUoA Analysis with Automatic Data Extraction
# This script automatically extracts information from existing columns
# and creates a streamlined template for manual data collection

rm(list=ls())
library(dplyr)
library(stringr)

# Read the existing data
df_data <- read.csv("20250703_standardized_unit_sizes_with_groups.csv", stringsAsFactors = FALSE)

# Function to extract publication year from citation
extract_year <- function(citation) {
  year_match <- str_extract(citation, "\\b(19|20)\\d{2}\\b")
  return(as.integer(year_match))
}

# Function to extract country/jurisdiction from citation and title
extract_country <- function(citation, title) {
  text_combined <- paste(tolower(citation), tolower(title), sep = " ")
  
  # Define country patterns (more comprehensive)
  country_patterns <- list(
    "Netherlands" = c("netherlands", "dutch", "amsterdam", "hague", "rotterdam", "utrecht", "nl\\b"),
    "UK" = c("\\buk\\b", "britain", "british", "england", "london", "belfast", "manchester", "birmingham", "leeds", "glasgow"),
    "USA" = c("\\busa\\b", "chicago", "richmond", "virginia", "tampa", "florida", "california", "texas", "new york", "detroit"),
    "Canada" = c("canada", "canadian", "toronto", "montreal", "vancouver", "ottawa"),
    "Australia" = c("australia", "australian", "sydney", "melbourne", "brisbane", "perth", "adelaide"),
    "China" = c("china", "chinese", "guangzhou", "beijing", "shanghai", "zg city", "hong kong"),
    "India" = c("india", "indian", "chennai", "mumbai", "delhi", "bangalore", "kolkata"),
    "Japan" = c("japan", "japanese", "tokyo", "osaka", "kyoto"),
    "New Zealand" = c("new zealand", "auckland", "wellington", "christchurch"),
    "Belgium" = c("belgium", "belgian", "brussels", "antwerp"),
    "Germany" = c("germany", "german", "berlin", "munich", "hamburg"),
    "France" = c("france", "french", "paris", "lyon", "marseille"),
    "Italy" = c("italy", "italian", "rome", "milan", "naples"),
    "Spain" = c("spain", "spanish", "madrid", "barcelona", "valencia"),
    "Sweden" = c("sweden", "swedish", "stockholm", "gothenburg"),
    "Norway" = c("norway", "norwegian", "oslo"),
    "Denmark" = c("denmark", "danish", "copenhagen"),
    "Switzerland" = c("switzerland", "swiss", "zurich", "geneva")
  )
  
  for (country in names(country_patterns)) {
    if (any(str_detect(text_combined, country_patterns[[country]]))) {
      return(country)
    }
  }
  return("Unknown")
}

# Function to extract primary crime type from title
extract_crime_type <- function(title) {
  title_lower <- tolower(title)
  
  # Define crime type patterns (more specific)
  crime_patterns <- list(
    "Burglary" = c("burglar", "burglary", "residential crime", "property crime", "break"),
    "Robbery" = c("robbery", "robber", "street robbery", "mugging"),
    "Theft" = c("theft", "snatching", "stealing", "larceny"),
    "Drug_crimes" = c("drug", "dealer", "narcotics", "trafficking"),
    "Graffiti" = c("graffiti", "vandalism", "tagging"),
    "Terrorism" = c("terrorist", "terrorism", "attack", "bombing"),
    "Violence" = c("violence", "assault", "homicide", "murder"),
    "Fraud" = c("fraud", "scam", "financial crime"),
    "General_crime" = c("crime", "offend", "criminal", "delinquen")
  )
  
  # Check specific crimes first, then general
  for (crime_type in names(crime_patterns)[1:8]) {  # Exclude general crime from first pass
    if (any(str_detect(title_lower, crime_patterns[[crime_type]]))) {
      return(crime_type)
    }
  }
  
  # If no specific crime found, check for general crime terms
  if (any(str_detect(title_lower, crime_patterns[["General_crime"]]))) {
    return("General_crime")
  }
  
  return("Other")
}

# Function to estimate study area from existing data
estimate_study_area <- function(unit_size_km2, no_of_units) {
  return(unit_size_km2 * no_of_units)
}

# Apply automatic extractions
df_enhanced <- df_data %>%
  mutate(
    # Convert character columns to numeric where needed
    No_of_units = as.numeric(str_replace_all(No_of_units, "[^0-9.]", "")),
    No_of_incidents = as.numeric(str_replace_all(No_of_incidents, "[^0-9.]", "")),
    
    # AUTO-EXTRACTED COLUMNS
    Publication_Year = extract_year(Citation),
    Country = mapply(extract_country, Citation, Title_of_the_study),
    Primary_Crime_Type = sapply(Title_of_the_study, extract_crime_type),
    Study_Area_km2 = estimate_study_area(Unit_size_km2, No_of_units),
    
    # MANUAL CODING REQUIRED (Priority 1)
    Statistical_Method = NA_character_,
    Alternative_Sampling = NA_character_,
    Number_of_Variables = NA_integer_,
    Sample_Size_Occasions = NA_integer_,
    Scale_Justification_Provided = NA_character_,
    
    # MANUAL CODING REQUIRED (Priority 2)
    Demographic_Variables = NA_integer_,
    Economic_Variables = NA_integer_,
    Land_Use_Variables = NA_integer_,
    Infrastructure_Variables = NA_integer_,
    Distance_Variables = NA_integer_,
    Crime_Opportunity_Variables = NA_integer_,
    Social_Variables = NA_integer_,
    Software_Used = NA_character_,
    Convergence_Issues = NA_character_,
    Data_Sources = NA_character_,
    Choice_Set_Strategy = NA_character_,
    Scale_Justification_Type = NA_character_
  )

# Display automatic extraction results
cat("=== AUTOMATIC EXTRACTION RESULTS ===\n")
cat("Publication Years extracted:\n")
print(table(df_enhanced$Publication_Year, useNA = "ifany"))

cat("\nCountries identified:\n") 
print(table(df_enhanced$Country, useNA = "ifany"))

cat("\nCrime types identified:\n")
print(table(df_enhanced$Primary_Crime_Type, useNA = "ifany"))

cat("\nStudy areas estimated (km²):\n")
print(summary(df_enhanced$Study_Area_km2))

# Save the enhanced dataset
write.csv(df_enhanced, "20250703_enhanced_dataset_with_auto_extraction.csv", row.names = FALSE, fileEncoding = "UTF-8")

# Create a manual coding template with only the columns that need manual input
manual_coding_template <- df_enhanced %>%
  select(
    # Identification columns
    Study_ID, Title_of_the_study, Citation, Unit_size_km2, Size_group,
    
    # Auto-extracted (for reference)
    Publication_Year, Country, Primary_Crime_Type,
    
    # Priority 1: Manual coding required
    Statistical_Method, Alternative_Sampling, Number_of_Variables, 
    Sample_Size_Occasions, Scale_Justification_Provided,
    
    # Priority 2: Manual coding required  
    Demographic_Variables, Economic_Variables, Land_Use_Variables,
    Infrastructure_Variables, Distance_Variables, Crime_Opportunity_Variables,
    Social_Variables, Software_Used, Convergence_Issues, Data_Sources,
    Choice_Set_Strategy, Scale_Justification_Type
  )

# Save manual coding template
write.csv(manual_coding_template, "Manual_Coding_Template_Streamlined.csv", row.names = FALSE, fileEncoding = "UTF-8")

# Create coding guide for categorical variables
coding_guide <- data.frame(
  Variable = c(
    rep("Statistical_Method", 6),
    rep("Alternative_Sampling", 5), 
    rep("Scale_Justification_Provided", 3),
    rep("Software_Used", 6),
    rep("Convergence_Issues", 3),
    rep("Choice_Set_Strategy", 4),
    rep("Scale_Justification_Type", 5)
  ),
  Allowed_Values = c(
    # Statistical_Method
    "Multinomial Logit", "Mixed Logit", "Latent Class", "Nested Logit", "Conditional Logit", "Other",
    # Alternative_Sampling  
    "None", "Random Sampling", "Stratified Sampling", "Importance Sampling", "Other",
    # Scale_Justification_Provided
    "Yes", "No", "Partial",
    # Software_Used
    "R", "Stata", "Python", "Biogeme", "SAS", "Other",
    # Convergence_Issues
    "Yes", "No", "Not Reported",
    # Choice_Set_Strategy
    "Full Choice Set", "Sampled", "Nested", "Other",
    # Scale_Justification_Type
    "Theoretical", "Practical", "Data-driven", "Literature-based", "None"
  ),
  Description = c(
    # Statistical_Method
    "Standard multinomial logit model", "Random parameters/mixed logit", "Latent class model", "Nested structure", "Fixed choice set conditional logit", "Other method specified",
    # Alternative_Sampling
    "Uses full choice set", "Random sample of alternatives", "Stratified by characteristics", "Importance sampling method", "Other sampling method",
    # Scale_Justification_Provided  
    "Clear justification given", "No justification provided", "Partial/brief justification",
    # Software_Used
    "R statistical software", "Stata", "Python (e.g., Biogeme)", "Biogeme specifically", "SAS", "Other software specified",
    # Convergence_Issues
    "Convergence problems mentioned", "No convergence issues", "Convergence not discussed",
    # Choice_Set_Strategy
    "All alternatives included", "Subset of alternatives", "Hierarchical/nested structure", "Other strategy",
    # Scale_Justification_Type
    "Based on theory", "Based on practical constraints", "Based on data availability", "Based on prior literature", "No justification provided"
  )
)

write.csv(coding_guide, "Coding_Guide_Streamlined.csv", row.names = FALSE, fileEncoding = "UTF-8")

# Print summary of what needs manual coding
cat("\n=== MANUAL CODING REQUIREMENTS ===\n")
cat("Total studies requiring coding: 51\n")
cat("Priority 1 columns (essential): 5 columns\n")  
cat("Priority 2 columns (important): 12 columns\n")
cat("Total manual coding effort: 17 columns × 51 studies = 867 data points\n")
cat("\nFiles created:\n")
cat("1. 20250703_enhanced_dataset_with_auto_extraction.csv - Full dataset with auto-extracted columns\n")
cat("2. Manual_Coding_Template_Streamlined.csv - Template for manual data entry\n") 
cat("3. Coding_Guide_Streamlined.csv - Standardized values for categorical variables\n")

# Show a sample of what automatic extraction found
cat("\n=== SAMPLE OF AUTO-EXTRACTED DATA ===\n")
sample_studies <- df_enhanced %>%
  select(Study_ID, Citation, Publication_Year, Country, Primary_Crime_Type) %>%
  head(10)
print(sample_studies)

cat("\n=== STUDIES NEEDING COUNTRY VERIFICATION ===\n")
unknown_countries <- df_enhanced %>%
  filter(Country == "Unknown") %>%
  select(Study_ID, Citation, Title_of_the_study)
print(unknown_countries)

str(df_enhanced)
