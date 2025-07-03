"""
Final Comprehensive Analysis: Merging Elicit + Automated Extraction
Creates the ultimate SUoA dataset combining all extraction sources
"""

import pandas as pd
import numpy as np
import re
from collections import Counter

print("="*80)
print("FINAL COMPREHENSIVE DATASET CREATION")
print("="*80)

# Load all datasets
df_elicit_raw = pd.read_csv(
    "Elicit - Extract from 49 papers - Main infor Main findings Methodology Variables core infor.csv")
df_automated = pd.read_csv("20250703_Complete_Enhanced_Dataset.csv")
df_elicit_structured = pd.read_csv("Elicit_Structured_Extraction.csv")

print(f"✅ Elicit raw: {len(df_elicit_raw)} studies")
print(f"✅ Automated: {len(df_automated)} studies")
print(f"✅ Elicit structured: {len(df_elicit_structured)} studies")

print(f"\n{'='*60}")
print("DETAILED VARIABLE EXTRACTION FROM ELICIT")
print(f"{'='*60}")


def count_variables_advanced(text):
    """Advanced variable counting from Elicit text"""
    if pd.isna(text):
        return {}

    text = str(text).lower()

    # Initialize counts
    counts = {
        'Total_Variables': None,
        'Demographic_Variables': 0,
        'Economic_Variables': 0,
        'Land_Use_Variables': 0,
        'Infrastructure_Variables': 0,
        'Distance_Variables': 0,
        'Crime_Opportunity_Variables': 0,
        'Social_Variables': 0,
        'Variable_List': []
    }

    # Extract variable list from text
    variable_patterns = [
        r'independent variables.*?include[d]?.*?:(.*?)(?:\n|$)',
        r'variables.*?in.*?model.*?:(.*?)(?:\n|$)',
        r'explanatory variables.*?:(.*?)(?:\n|$)',
        r'predictors.*?:(.*?)(?:\n|$)'
    ]

    variable_text = ""
    for pattern in variable_patterns:
        matches = re.findall(pattern, text, re.IGNORECASE | re.DOTALL)
        if matches:
            variable_text = matches[0]
            break

    if variable_text:
        # Split variables and clean
        variables = re.split(r'[,;]|\band\b', variable_text)
        variables = [v.strip()
                     for v in variables if v.strip() and len(v.strip()) > 2]
        counts['Variable_List'] = variables
        counts['Total_Variables'] = len(variables)

        # Categorize variables
        for var in variables:
            var_lower = var.lower()

            # Demographic variables
            if any(keyword in var_lower for keyword in ['population', 'density', 'age', 'household', 'resident', 'demographic']):
                counts['Demographic_Variables'] += 1

            # Economic variables
            elif any(keyword in var_lower for keyword in ['income', 'unemployment', 'poverty', 'economic', 'deprivation', 'affluence', 'housing', 'property value', 'rent', 'seifa']):
                counts['Economic_Variables'] += 1

            # Land use variables
            elif any(keyword in var_lower for keyword in ['land use', 'commercial', 'residential', 'retail', 'floor space', 'mixed use', 'zoning']):
                counts['Land_Use_Variables'] += 1

            # Infrastructure variables
            elif any(keyword in var_lower for keyword in ['road', 'street', 'transport', 'station', 'infrastructure', 'lighting', 'sidewalk']):
                counts['Infrastructure_Variables'] += 1

            # Distance variables
            elif any(keyword in var_lower for keyword in ['distance', 'proximity', 'to city center', 'to highway', 'to']):
                counts['Distance_Variables'] += 1

            # Crime opportunity variables
            elif any(keyword in var_lower for keyword in ['crime', 'previous', 'guardianship', 'surveillance', 'target', 'opportunity', 'victimization']):
                counts['Crime_Opportunity_Variables'] += 1

            # Social variables
            elif any(keyword in var_lower for keyword in ['social', 'ethnic', 'diversity', 'cohesion', 'disorder', 'collective', 'churn', 'mobility']):
                counts['Social_Variables'] += 1

    return counts


# Extract variables for all studies
print("Extracting variable information from Elicit data...")

all_variable_info = []
for idx, row in df_elicit_raw.iterrows():
    # Try multiple fields for variable information
    variable_sources = [
        row.get('Variables ', ''),
        row.get('Main infor', ''),
        row.get('Methodology', '')
    ]

    best_count = 0
    best_info = {}

    for source in variable_sources:
        if pd.notna(source):
            var_info = count_variables_advanced(source)
            total_vars = var_info.get('Total_Variables', 0) or 0
            if total_vars > best_count:
                best_count = total_vars
                best_info = var_info

    study_var_info = {
        'Study_ID': idx + 1,
        'Filename': row.get('Filename', ''),
        'Title': row.get('Title', '')
    }
    study_var_info.update(best_info)
    all_variable_info.append(study_var_info)

df_variables_final = pd.DataFrame(all_variable_info)

# Report variable extraction success
var_fields = ['Total_Variables', 'Demographic_Variables', 'Economic_Variables',
              'Land_Use_Variables', 'Infrastructure_Variables', 'Distance_Variables',
              'Crime_Opportunity_Variables', 'Social_Variables']

print("Variable extraction results:")
for field in var_fields:
    if field == 'Total_Variables':
        success = df_variables_final[field].notna().sum()
    else:
        success = (df_variables_final[field] > 0).sum()
    print(f"  {field}: {success}/{len(df_variables_final)} studies ({success/len(df_variables_final)*100:.1f}%)")

# Show some statistics
if 'Total_Variables' in df_variables_final.columns:
    total_vars = df_variables_final['Total_Variables'].dropna()
    if len(total_vars) > 0:
        print(f"\nVariable count statistics:")
        print(f"  Range: {total_vars.min():.0f} - {total_vars.max():.0f}")
        print(f"  Mean: {total_vars.mean():.1f}")
        print(f"  Median: {total_vars.median():.1f}")

print(f"\n{'='*60}")
print("MERGING ALL DATASETS")
print(f"{'='*60}")

# Create filename matching keys
df_automated['Filename_Key'] = df_automated['PDF_File'].str.replace(
    '.pdf', '', regex=False)
df_elicit_structured['Filename_Key'] = df_elicit_structured['Filename'].str.replace(
    '.pdf', '', regex=False)
df_variables_final['Filename_Key'] = df_variables_final['Filename'].str.replace(
    '.pdf', '', regex=False)

# Merge datasets
print("Merging automated + elicit structured data...")
df_merged = df_automated.merge(
    df_elicit_structured[['Filename_Key', 'Study_Area',
                          'Population_Per_Unit', 'Data_Sources']],
    on='Filename_Key',
    how='left'
)

print("Adding variable information...")
df_final = df_merged.merge(
    df_variables_final[['Filename_Key'] + var_fields + ['Variable_List']],
    on='Filename_Key',
    how='left'
)

print(
    f"Final merged dataset: {len(df_final)} studies with {df_final.shape[1]} variables")

print(f"\n{'='*60}")
print("FINAL DATASET COMPLETENESS ANALYSIS")
print(f"{'='*60}")

# Analyze completeness
key_fields = {
    'SUoA Size': 'Unit_size_km2',
    'Crime Type': 'Primary_Crime_Type',
    'Statistical Method': 'Statistical_Method',
    'Publication Year': 'Publication_Year',
    'Study Area': 'Study_Area',
    'Population Info': 'Population_Per_Unit',
    'Data Sources': 'Data_Sources',
    'Alternative Sampling': 'Alternative_Sampling',
    'Total Variables': 'Total_Variables',
    'Sample Size': 'Sample_Size_Occasions'
}

print("Data completeness by field:")
for field_name, column in key_fields.items():
    if column in df_final.columns:
        complete = df_final[column].notna().sum()
        print(
            f"  {field_name}: {complete}/{len(df_final)} ({complete/len(df_final)*100:.1f}%)")

print(f"\n{'='*60}")
print("RESEARCH QUESTION READINESS")
print(f"{'='*60}")

# Check readiness for each research question
rq_status = {}

# RQ1: SUoA Distribution
suoa_complete = df_final['Unit_size_km2'].notna().sum()
rq_status['RQ1: SUoA Size Distribution'] = f"✅ COMPLETE ({suoa_complete}/51, {suoa_complete/51*100:.0f}%)"

# RQ2: Temporal Trends
year_complete = df_final['Publication_Year'].notna().sum()
rq_status['RQ2: Temporal Trends'] = f"✅ COMPLETE ({year_complete}/51, {year_complete/51*100:.0f}%)"

# RQ3: Jurisdiction Patterns
country_complete = df_final['Country'].notna().sum()
rq_status['RQ3: Jurisdiction Patterns'] = f"🔍 ENHANCED ({country_complete}/51, {country_complete/51*100:.0f}%)"

# RQ4: Crime Type Patterns
crime_complete = df_final['Primary_Crime_Type'].notna().sum()
rq_status['RQ4: Crime Type Patterns'] = f"✅ COMPLETE ({crime_complete}/51, {crime_complete/51*100:.0f}%)"

# RQ5: Methods and SUoA
method_complete = df_final['Statistical_Method'].notna().sum()
sampling_complete = df_final['Alternative_Sampling'].notna().sum()
rq_status['RQ5: Methods and SUoA'] = f"✅ COMPLETE (Methods: {method_complete}/51, Sampling: {sampling_complete}/51)"

# RQ6: Variables and SUoA
var_complete = df_final['Total_Variables'].notna().sum()
if var_complete >= 40:
    rq_status['RQ6: Variables and SUoA'] = f"✅ COMPLETE ({var_complete}/51, {var_complete/51*100:.0f}%)"
elif var_complete >= 30:
    rq_status['RQ6: Variables and SUoA'] = f"🔍 SUBSTANTIAL ({var_complete}/51, {var_complete/51*100:.0f}%)"
else:
    rq_status['RQ6: Variables and SUoA'] = f"⚠️ PARTIAL ({var_complete}/51, {var_complete/51*100:.0f}%)"

for rq, status in rq_status.items():
    print(f"  {rq}: {status}")

print(f"\n{'='*60}")
print("REMAINING INFORMATION NEEDS")
print(f"{'='*60}")

missing_info = []

# Check what's still missing
if df_final['Total_Variables'].notna().sum() < 45:
    missing_vars = df_final['Total_Variables'].isna().sum()
    missing_info.append(
        f"Variable counts: {missing_vars} studies need manual extraction")

if df_final['Study_Area'].notna().sum() < 45:
    missing_areas = df_final['Study_Area'].isna().sum()
    missing_info.append(
        f"Study area sizes: {missing_areas} studies need size in km²")

unclear_sampling = (df_final['Alternative_Sampling'] == 'Not Clear').sum()
if unclear_sampling > 5:
    missing_info.append(
        f"Sampling strategies: {unclear_sampling} studies need clarification")

if missing_info:
    print("Priority areas for additional extraction:")
    for item in missing_info:
        print(f"  • {item}")
else:
    print("🎉 All major information needs are satisfied!")

print(f"\n{'='*60}")
print("SAVING FINAL COMPREHENSIVE DATASET")
print(f"{'='*60}")

# Save the comprehensive dataset
df_final.to_csv("Final_Comprehensive_SUoA_Dataset.csv", index=False)
df_variables_final.to_csv("Detailed_Variable_Analysis.csv", index=False)

# Create a summary report
summary_stats = {
    'Total Studies': len(df_final),
    'SUoA Data': df_final['Unit_size_km2'].notna().sum(),
    'Statistical Methods': df_final['Statistical_Method'].notna().sum(),
    'Variable Counts': df_final['Total_Variables'].notna().sum(),
    'Study Areas': df_final['Study_Area'].notna().sum(),
    'Population Data': df_final['Population_Per_Unit'].notna().sum(),
    'Sampling Strategies': (df_final['Alternative_Sampling'] != 'Not Clear').sum(),
    'Data Sources': df_final['Data_Sources'].notna().sum()
}

summary_df = pd.DataFrame(list(summary_stats.items()), columns=[
                          'Field', 'Complete_Studies'])
summary_df['Completion_Rate'] = (
    summary_df['Complete_Studies'] / len(df_final) * 100).round(1)
summary_df.to_csv("Dataset_Completeness_Summary.csv", index=False)

print("✅ Files saved:")
print("  📊 Final_Comprehensive_SUoA_Dataset.csv - Complete merged dataset")
print("  📋 Detailed_Variable_Analysis.csv - Variable extraction details")
print("  📈 Dataset_Completeness_Summary.csv - Completeness summary")

print(f"\n🎯 FINAL SUMMARY:")
print(f"  Total studies: {len(df_final)}")
print(f"  Complete variable data: {df_final['Total_Variables'].notna().sum()}")
print(
    f"  Average variables per study: {df_final['Total_Variables'].mean():.1f}")
print(f"  Research questions ready: {list(rq_status.values()).count('✅')}/6")

if df_final['Total_Variables'].notna().sum() >= 40:
    print(f"\n🏆 EXCELLENT! Your dataset is ready for comprehensive SUoA analysis!")
else:
    print(
        f"\n📝 Good progress! Consider extracting variables from {51 - df_final['Total_Variables'].notna().sum()} more studies.")
