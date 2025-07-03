# Enhanced Standardization Script with Methodological Columns
# Standardize spatial unit sizes to km² and add methodological coding columns
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

# ===== ADD METHODOLOGICAL COLUMNS FOR COMPLETE ANALYSIS =====

df_enhanced <- df_data_clean %>%
  mutate(
    # ===== PUBLICATION & GEOGRAPHIC INFORMATION =====
    Publication_Year = NA_integer_,
    Journal = NA_character_,
    Country = NA_character_,
    City_Region = NA_character_,
    Study_Area_km2 = NA_real_,
    
    # ===== CRIME TYPE CLASSIFICATION =====
    Primary_Crime_Type = NA_character_,       # "Burglary", "Robbery", "Theft", etc.
    Crime_Category = NA_character_,           # "Property", "Violent", "Drug", "Other"
    
    # ===== DISCRETE CHOICE METHODOLOGY =====
    Statistical_Method = NA_character_,       # "Multinomial Logit", "Mixed Logit", "Latent Class", "Nested Logit"
    Alternative_Sampling = NA_character_,     # "None", "Random", "Stratified", "Importance Sampling", "Other"
    Sample_Size_Occasions = NA_integer_,      # Number of choice occasions/observations
    Choice_Set_Strategy = NA_character_,      # "Full", "Sampled", "Nested", "Mixed"
    
    # ===== COMPUTATIONAL APPROACH =====
    Software_Used = NA_character_,            # "R", "Stata", "Python", "Biogeme", "SPSS", "Other"
    Estimation_Time = NA_character_,          # "< 1 hour", "1-24 hours", "> 24 hours", "Not reported"
    Convergence_Issues = NA_character_,       # "Yes", "No", "Not reported"
    Model_Fit_Reported = NA_character_,       # "Yes", "No", "Partial"
    
    # ===== INDEPENDENT VARIABLES INFORMATION =====
    Number_of_Variables = NA_integer_,
    Demographic_Variables = NA_integer_,      # Count of demographic variables
    Economic_Variables = NA_integer_,         # Count of economic variables  
    Land_Use_Variables = NA_integer_,         # Count of land use variables
    Infrastructure_Variables = NA_integer_,   # Count of infrastructure/built environment variables
    Distance_Variables = NA_integer_,         # Count of distance/accessibility variables
    Crime_Opportunity_Variables = NA_integer_, # Count of crime opportunity variables
    Social_Variables = NA_integer_,           # Count of social disorganization variables
    Data_Sources = NA_character_,             # "Census, Police, GIS, Survey" etc.
    
    # ===== SCALE CHOICE JUSTIFICATION =====
    Scale_Justification_Provided = NA_character_, # "Yes", "No", "Partial"
    Scale_Justification_Type = NA_character_,     # "Theoretical", "Practical", "Data-driven", "None"
    Multi_Scale_Analysis = NA_character_,         # "Yes", "No"
    Scale_Sensitivity_Test = NA_character_,       # "Yes", "No"
    
    # ===== STUDY DESIGN CHARACTERISTICS =====
    Cross_Sectional = NA_character_,          # "Yes", "No"
    Longitudinal = NA_character_,             # "Yes", "No"
    Comparative = NA_character_,              # "Yes", "No" (multiple cities/regions)
    Sample_Period = NA_character_,            # "< 1 year", "1-3 years", "> 3 years"
    
    # ===== OFFENDER CHARACTERISTICS =====
    Offender_Sample = NA_character_,          # "All", "First-time", "Repeat", "Mixed"
    Age_Groups = NA_character_,               # "Juvenile", "Adult", "Mixed", "Not specified"
    Individual_Level_Data = NA_character_     # "Yes", "No", "Partial"
  )

# Reorder columns for better organization
df_enhanced <- df_enhanced %>%
  select(
    # Basic study information
    Study_ID, Title_of_the_study, Citation, Publication_Year, Journal,
    
    # Geographic context
    Country, City_Region, Study_Area_km2,
    
    # Crime information
    Primary_Crime_Type, Crime_Category,
    
    # Spatial unit information
    Size_of_the_unit, Unit, Unit_size_km2, Size_group, Name_of_the_unit, 
    No_of_units, No_of_incidents,
    
    # Methodology
    Statistical_Method, Alternative_Sampling, Sample_Size_Occasions, Choice_Set_Strategy,
    
    # Computational
    Software_Used, Estimation_Time, Convergence_Issues, Model_Fit_Reported,
    
    # Variables
    Number_of_Variables, Demographic_Variables, Economic_Variables, Land_Use_Variables,
    Infrastructure_Variables, Distance_Variables, Crime_Opportunity_Variables, Social_Variables,
    Data_Sources,
    
    # Scale justification
    Scale_Justification_Provided, Scale_Justification_Type, Multi_Scale_Analysis, Scale_Sensitivity_Test,
    
    # Study design
    Cross_Sectional, Longitudinal, Comparative, Sample_Period,
    
    # Offender characteristics
    Offender_Sample, Age_Groups, Individual_Level_Data,
    
    # Other
    Inferred_size
  )

# Print summary of the enhanced structure
cat("=== ENHANCED DATA STRUCTURE ===\n")
cat("Total observations:", nrow(df_enhanced), "\n")
cat("Total variables:", ncol(df_enhanced), "\n\n")

cat("=== VARIABLE CATEGORIES ===\n")
cat("Basic Information (5):", "Study_ID, Title, Citation, Year, Journal\n")
cat("Geographic Context (3):", "Country, City_Region, Study_Area_km2\n") 
cat("Crime Information (2):", "Primary_Crime_Type, Crime_Category\n")
cat("Spatial Unit Info (6):", "Size, Unit, Unit_size_km2, Size_group, Name, No_units, No_incidents\n")
cat("Methodology (4):", "Statistical_Method, Alternative_Sampling, Sample_Size, Choice_Set_Strategy\n")
cat("Computational (4):", "Software, Estimation_Time, Convergence, Model_Fit\n")
cat("Variables (9):", "Number + 7 types + Data_Sources\n")
cat("Scale Justification (4):", "Provided, Type, Multi_Scale, Sensitivity\n")
cat("Study Design (4):", "Cross_Sectional, Longitudinal, Comparative, Period\n")
cat("Offender Info (3):", "Sample, Age_Groups, Individual_Level\n")

# Save the enhanced template
write.csv(df_enhanced, "20250703_enhanced_methodological_template.csv", row.names = FALSE, fileEncoding = "UTF-8")

# Also save the current version with groups (for immediate use)
write.csv(df_data_clean, "20250703_standardized_unit_sizes_with_groups.csv", row.names = FALSE, fileEncoding = "UTF-8")

# Print structure
str(df_enhanced)

# Create a coding guide
coding_guide <- data.frame(
  Variable = c(
    "Statistical_Method", "Alternative_Sampling", "Choice_Set_Strategy",
    "Primary_Crime_Type", "Crime_Category", "Software_Used",
    "Scale_Justification_Type", "Offender_Sample"
  ),
  Possible_Values = c(
    "Multinomial Logit | Mixed Logit | Latent Class | Nested Logit | Other",
    "None | Random | Stratified | Importance Sampling | Other | Not Reported",
    "Full | Sampled | Nested | Mixed | Not Reported", 
    "Burglary | Robbery | Theft | Drug | Vandalism | Terrorism | General | Other",
    "Property | Violent | Drug | Public Order | Other",
    "R | Stata | Python | Biogeme | SPSS | SAS | Other | Not Reported",
    "Theoretical | Practical | Data-driven | Not Provided",
    "All | First-time | Repeat | Mixed | Not Specified"
  )
)

write.csv(coding_guide, "coding_guide.csv", row.names = FALSE)

cat("\n=== FILES CREATED ===\n")
cat("1. 20250703_enhanced_methodological_template.csv - Full template for data entry\n")
cat("2. 20250703_standardized_unit_sizes_with_groups.csv - Current data with size groups\n") 
cat("3. coding_guide.csv - Guide for coding categorical variables\n")

cat("\n=== NEXT STEPS ===\n")
cat("1. Use the enhanced template to code each study's methodological details\n")
cat("2. Focus on these priority columns for your research questions:\n")
cat("   - Statistical_Method & Alternative_Sampling (Question 5)\n")
cat("   - Number_of_Variables & Variable types (Question 6)\n")
cat("   - Scale_Justification_Provided (General methodology)\n")
cat("3. Run updated analysis with methodological patterns\n")
