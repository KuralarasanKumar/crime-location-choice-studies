"""
Analysis of Elicit Extraction Results vs Automated Extraction
Identifies gaps and completeness of information extraction
"""

import pandas as pd
import numpy as np
import re
from collections import Counter

print("="*80)
print("ANALYSIS: ELICIT EXTRACTION vs AUTOMATED EXTRACTION")
print("="*80)

# Load the Elicit extraction results
try:
    elicit_file = "Elicit - Extract from 49 papers - Main infor Main findings Methodology Variables core infor.csv"
    df_elicit = pd.read_csv(elicit_file)
    print(f"✅ Loaded Elicit extraction: {len(df_elicit)} studies")
except Exception as e:
    print(f"❌ Error loading Elicit file: {e}")
    exit()

# Load our automated extraction results
try:
    df_automated = pd.read_csv("20250703_Complete_Enhanced_Dataset.csv")
    print(f"✅ Loaded automated extraction: {len(df_automated)} studies")
except Exception as e:
    print(f"❌ Error loading automated file: {e}")
    exit()

print(f"\n{'='*60}")
print("ELICIT EXTRACTION ANALYSIS")
print(f"{'='*60}")

# Analyze the structure of Elicit data
print(f"Columns in Elicit data: {list(df_elicit.columns)}")
print(f"Key extraction columns:")
for col in ['Main infor', 'Main findings', 'Methodology', 'Variables ', 'core infor']:
    if col in df_elicit.columns:
        non_empty = df_elicit[col].notna().sum()
        print(f"  {col}: {non_empty}/{len(df_elicit)} studies ({non_empty/len(df_elicit)*100:.1f}%)")

print(f"\n{'='*60}")
print("DETAILED INFORMATION EXTRACTION FROM ELICIT")
print(f"{'='*60}")

# Function to extract specific information from the "Main infor" field
def extract_info_from_main_infor(text):
    """Extract structured information from the Main infor field"""
    if pd.isna(text):
        return {}
    
    info = {}
    
    # Extract SUoA size
    suoa_pattern = r"Size of the spatial unit.*?SUoA\):?\s*([^-\n]+)"
    suoa_match = re.search(suoa_pattern, text, re.IGNORECASE | re.DOTALL)
    if suoa_match:
        info['SUoA_Description'] = suoa_match.group(1).strip()
    
    # Extract study area
    area_pattern = r"Total area of.*?study site:?\s*([^-\n]+)"
    area_match = re.search(area_pattern, text, re.IGNORECASE | re.DOTALL)
    if area_match:
        info['Study_Area'] = area_match.group(1).strip()
    
    # Extract country
    country_pattern = r"Country.*?conducted:?\s*([^-\n]+)"
    country_match = re.search(country_pattern, text, re.IGNORECASE | re.DOTALL)
    if country_match:
        info['Country'] = country_match.group(1).strip()
    
    # Extract crime type
    crime_pattern = r"Type of crime analyzed:?\s*([^-\n]+)"
    crime_match = re.search(crime_pattern, text, re.IGNORECASE | re.DOTALL)
    if crime_match:
        info['Crime_Type'] = crime_match.group(1).strip()
    
    # Extract model type
    model_pattern = r"Type of discrete choice model.*?:?\s*([^-\n]+)"
    model_match = re.search(model_pattern, text, re.IGNORECASE | re.DOTALL)
    if model_match:
        info['Model_Type'] = model_match.group(1).strip()
    
    # Extract sampling approach
    sampling_pattern = r"Sampling approach.*?:?\s*([^-\n]+)"
    sampling_match = re.search(sampling_pattern, text, re.IGNORECASE | re.DOTALL)
    if sampling_match:
        info['Sampling_Approach'] = sampling_match.group(1).strip()
    
    # Extract population info
    pop_pattern = r"Population per spatial unit:?\s*([^-\n]+)"
    pop_match = re.search(pop_pattern, text, re.IGNORECASE | re.DOTALL)
    if pop_match:
        info['Population_Per_Unit'] = pop_match.group(1).strip()
    
    # Extract data sources
    data_pattern = r"Data sources used:?\s*([^-\n]+)"
    data_match = re.search(data_pattern, text, re.IGNORECASE | re.DOTALL)
    if data_match:
        info['Data_Sources'] = data_match.group(1).strip()
    
    return info

# Extract structured information from all studies
elicit_structured = []
for idx, row in df_elicit.iterrows():
    study_info = {
        'Study_ID': idx + 1,
        'Title': row.get('Title', ''),
        'Year': row.get('Year', ''),
        'Filename': row.get('Filename', '')
    }
    
    # Extract from Main infor field
    main_info = extract_info_from_main_infor(row.get('Main infor', ''))
    study_info.update(main_info)
    
    # Store raw fields for analysis
    study_info['Raw_Main_Infor'] = row.get('Main infor', '')
    study_info['Raw_Variables'] = row.get('Variables ', '')
    study_info['Raw_Methodology'] = row.get('Methodology', '')
    
    elicit_structured.append(study_info)

df_elicit_clean = pd.DataFrame(elicit_structured)

print(f"Structured extraction from {len(df_elicit_clean)} studies:")

# Analyze extraction success rates
extraction_fields = ['SUoA_Description', 'Study_Area', 'Country', 'Crime_Type', 
                    'Model_Type', 'Sampling_Approach', 'Population_Per_Unit', 'Data_Sources']

for field in extraction_fields:
    if field in df_elicit_clean.columns:
        success = df_elicit_clean[field].notna().sum()
        print(f"  {field}: {success}/{len(df_elicit_clean)} ({success/len(df_elicit_clean)*100:.1f}%)")

print(f"\n{'='*60}")
print("VARIABLE EXTRACTION ANALYSIS")
print(f"{'='*60}")

# Analyze variable information
def extract_variable_counts(text):
    """Extract variable counts from text"""
    if pd.isna(text):
        return {}
    
    # Look for explicit variable counts
    counts = {}
    
    # Try to find total variables
    total_pattern = r"(\d+)\s*(?:total\s*)?(?:independent\s*)?variables?"
    total_matches = re.findall(total_pattern, text, re.IGNORECASE)
    if total_matches:
        counts['Total_Variables'] = int(total_matches[-1])  # Take the last match
    
    # Look for category-specific counts
    categories = {
        'Demographic': r"(\d+)\s*demographic",
        'Economic': r"(\d+)\s*economic", 
        'Land_Use': r"(\d+)\s*land\s*use",
        'Infrastructure': r"(\d+)\s*infrastructure",
        'Distance': r"(\d+)\s*distance",
        'Crime_Opportunity': r"(\d+)\s*crime\s*opportunity",
        'Social': r"(\d+)\s*social"
    }
    
    for category, pattern in categories.items():
        matches = re.findall(pattern, text, re.IGNORECASE)
        if matches:
            counts[f'{category}_Variables'] = int(matches[0])
    
    return counts

# Extract variable information
variable_info = []
for idx, row in df_elicit_clean.iterrows():
    var_counts = extract_variable_counts(row.get('Raw_Variables', ''))
    var_info = {'Study_ID': idx + 1, 'Filename': row.get('Filename', '')}
    var_info.update(var_counts)
    variable_info.append(var_info)

df_variables = pd.DataFrame(variable_info)

print(f"Variable extraction analysis:")
var_fields = ['Total_Variables', 'Demographic_Variables', 'Economic_Variables', 
             'Land_Use_Variables', 'Infrastructure_Variables', 'Distance_Variables',
             'Crime_Opportunity_Variables', 'Social_Variables']

for field in var_fields:
    if field in df_variables.columns:
        success = df_variables[field].notna().sum()
        print(f"  {field}: {success}/{len(df_variables)} ({success/len(df_variables)*100:.1f}%)")

print(f"\n{'='*60}")
print("COMPARISON WITH AUTOMATED EXTRACTION")
print(f"{'='*60}")

# Compare key fields
comparison_results = {}

# Match studies by filename (remove extensions for comparison)
df_elicit_clean['Filename_Clean'] = df_elicit_clean['Filename'].str.replace('.pdf', '', regex=False)
df_automated['PDF_File_Clean'] = df_automated['PDF_File'].str.replace('.pdf', '', regex=False)

# Create comparison for overlapping studies
merged_comparison = df_elicit_clean.merge(
    df_automated, 
    left_on='Filename_Clean', 
    right_on='PDF_File_Clean', 
    how='inner'
)

print(f"Studies matched between Elicit and Automated: {len(merged_comparison)}")

if len(merged_comparison) > 0:
    print(f"\nComparison results:")
    
    # Compare crime types
    crime_match = 0
    for idx, row in merged_comparison.iterrows():
        elicit_crime = str(row.get('Crime_Type', '')).lower()
        auto_crime = str(row.get('Primary_Crime_Type', '')).lower()
        if elicit_crime and auto_crime:
            if any(keyword in elicit_crime for keyword in auto_crime.split('_')):
                crime_match += 1
    
    print(f"  Crime type consistency: {crime_match}/{len(merged_comparison)} ({crime_match/len(merged_comparison)*100:.1f}%)")
    
    # Compare model types
    model_match = 0
    for idx, row in merged_comparison.iterrows():
        elicit_model = str(row.get('Model_Type', '')).lower()
        auto_model = str(row.get('Statistical_Method', '')).lower()
        if elicit_model and auto_model:
            if 'logit' in elicit_model and 'logit' in auto_model:
                model_match += 1
    
    print(f"  Model type consistency: {model_match}/{len(merged_comparison)} ({model_match/len(merged_comparison)*100:.1f}%)")

print(f"\n{'='*60}")
print("INFORMATION GAPS ANALYSIS")
print(f"{'='*60}")

# Identify what information is still missing
print("HIGH-VALUE INFORMATION SUCCESSFULLY EXTRACTED BY ELICIT:")

# Study area information
study_areas = df_elicit_clean['Study_Area'].dropna()
print(f"✅ Study area sizes: {len(study_areas)} studies")
if len(study_areas) > 0:
    print("   Sample study areas:")
    for area in study_areas.head(3):
        print(f"     - {area}")

# Population information  
population_info = df_elicit_clean['Population_Per_Unit'].dropna()
print(f"✅ Population per unit: {len(population_info)} studies")

# Data sources
data_sources = df_elicit_clean['Data_Sources'].dropna()
print(f"✅ Data sources: {len(data_sources)} studies")

# Variable information
total_vars = df_variables['Total_Variables'].dropna()
print(f"✅ Total variable counts: {len(total_vars)} studies")
if len(total_vars) > 0:
    print(f"   Range: {total_vars.min()}-{total_vars.max()} variables")
    print(f"   Mean: {total_vars.mean():.1f} variables")

print(f"\nSTILL MISSING OR INCOMPLETE:")

# Check what's still needed
missing_items = []

if len(study_areas) < len(df_elicit_clean) * 0.8:
    missing_items.append(f"Study area sizes: {len(df_elicit_clean) - len(study_areas)} studies missing")

if len(total_vars) < len(df_elicit_clean) * 0.8:
    missing_items.append(f"Variable counts: {len(df_elicit_clean) - len(total_vars)} studies missing")

if len(population_info) < len(df_elicit_clean) * 0.5:
    missing_items.append(f"Population information: {len(df_elicit_clean) - len(population_info)} studies missing")

sampling_info = df_elicit_clean['Sampling_Approach'].dropna()
if len(sampling_info) < len(df_elicit_clean) * 0.8:
    missing_items.append(f"Sampling strategies: {len(df_elicit_clean) - len(sampling_info)} studies missing")

for item in missing_items:
    print(f"⚠️ {item}")

print(f"\n{'='*60}")
print("RECOMMENDED NEXT STEPS")
print(f"{'='*60}")

print("1. MERGE ELICIT WITH AUTOMATED DATA:")
print("   - Combine Elicit variable counts with our automated extraction")
print("   - Use Elicit for study areas, population, and data sources")
print("   - Keep automated extraction for SUoA sizes, statistical methods, and sampling")

print(f"\n2. FOCUS ADDITIONAL ELICIT EXTRACTION ON:")
remaining_needs = []

if len(total_vars) < 40:
    remaining_needs.append("Variable counts and categorization (if < 40 studies)")

if len(study_areas) < 40:
    remaining_needs.append("Study area sizes in km² (if < 40 studies)")

if len(sampling_info) < 40:
    remaining_needs.append("Detailed sampling strategies (if < 40 studies)")

for need in remaining_needs:
    print(f"   - {need}")

print(f"\n3. CREATE FINAL MERGED DATASET:")
print("   - Combine all extraction sources")
print("   - Resolve conflicts between automated and manual extraction") 
print("   - Fill remaining gaps with targeted extraction")

# Save analysis results
df_elicit_clean.to_csv("Elicit_Structured_Extraction.csv", index=False)
df_variables.to_csv("Elicit_Variable_Analysis.csv", index=False)

print(f"\n✅ Analysis complete! Files saved:")
print(f"   - Elicit_Structured_Extraction.csv")
print(f"   - Elicit_Variable_Analysis.csv")

print(f"\n📊 SUMMARY:")
print(f"   Total studies analyzed: {len(df_elicit_clean)}")
print(f"   Studies with variable info: {len(total_vars)}")
print(f"   Studies with study areas: {len(study_areas)}")
print(f"   Studies with population data: {len(population_info)}")
print(f"   Studies with data sources: {len(data_sources)}")
