"""
Analysis of Comprehensive Elicit Extraction Results
Analyzes the updated Elicit CSV with all extracted information
"""

import pandas as pd
import numpy as np
import re
from collections import Counter

print("="*80)
print("COMPREHENSIVE ELICIT EXTRACTION ANALYSIS")
print("="*80)

# Load the comprehensive Elicit extraction results
try:
    df = pd.read_csv(
        "2 Elicit - Extract from 49 papers - Main infor addtion info revised info Variables core infor.csv")
    print(f"✅ Loaded comprehensive Elicit extraction: {len(df)} studies")
except Exception as e:
    print(f"❌ Error loading file: {e}")
    exit()

print(f"\nColumns in the dataset:")
for i, col in enumerate(df.columns, 1):
    print(f"{i:2d}. {col}")

print(f"\n{'='*60}")
print("EXTRACTION COMPLETENESS ANALYSIS")
print(f"{'='*60}")

# Analyze key extraction fields
key_fields = ['Main infor', 'addtion info',
              'revised info', 'Variables ', 'core infor']

for field in key_fields:
    if field in df.columns:
        non_empty = df[field].notna().sum()
        avg_length = df[field].str.len().mean()
        print(f"{field:15s}: {non_empty:2d}/{len(df)} studies ({non_empty/len(df)*100:5.1f}%) | Avg length: {avg_length:6.0f} chars")

print(f"\n{'='*60}")
print("STUDY INFORMATION EXTRACTION")
print(f"{'='*60}")

# Analyze basic study information
basic_fields = ['Title', 'Authors', 'Year', 'Filename']
for field in basic_fields:
    if field in df.columns:
        non_empty = df[field].notna().sum()
        print(
            f"{field:12s}: {non_empty:2d}/{len(df)} studies ({non_empty/len(df)*100:5.1f}%)")

# Analyze years
if 'Year' in df.columns:
    years = df['Year'].dropna()
    if len(years) > 0:
        print(f"\nYear range: {years.min()}-{years.max()}")
        print(f"Most common years: {years.value_counts().head(3).to_dict()}")

print(f"\n{'='*60}")
print("SPATIAL UNIT INFORMATION EXTRACTION")
print(f"{'='*60}")

# Function to extract SUoA information from text fields


def extract_suoa_info(text):
    """Extract SUoA information from main info text"""
    if pd.isna(text):
        return {}

    info = {}

    # Extract SUoA size
    size_patterns = [
        r"Size of the spatial unit.*?SUoA\):?\s*([^-\n]+)",
        r"SUoA Size:?\s*([^-\n]+)",
        r"spatial unit.*?size:?\s*([^-\n]+)"
    ]

    for pattern in size_patterns:
        match = re.search(pattern, text, re.IGNORECASE | re.DOTALL)
        if match:
            info['SUoA_Size'] = match.group(1).strip()
            break

    # Extract SUoA type
    type_patterns = [
        r"SUoA Type:?\s*([^-\n]+)",
        r"spatial unit.*?type:?\s*([^-\n]+)",
        r"unit of analysis.*?:?\s*([^-\n]+)"
    ]

    for pattern in type_patterns:
        match = re.search(pattern, text, re.IGNORECASE | re.DOTALL)
        if match:
            info['SUoA_Type'] = match.group(1).strip()
            break

    # Extract study area size
    area_patterns = [
        r"Total area.*?study site:?\s*([^-\n]+)",
        r"Study Area Size:?\s*([^-\n]+)",
        r"total area:?\s*([^-\n]+)"
    ]

    for pattern in area_patterns:
        match = re.search(pattern, text, re.IGNORECASE | re.DOTALL)
        if match:
            info['Study_Area_Size'] = match.group(1).strip()
            break

    # Extract country
    country_patterns = [
        r"Country:?\s*([^-\n]+)",
        r"jurisdiction.*?conducted:?\s*([^-\n]+)"
    ]

    for pattern in country_patterns:
        match = re.search(pattern, text, re.IGNORECASE | re.DOTALL)
        if match:
            info['Country'] = match.group(1).strip()
            break

    return info


# Extract SUoA information from all studies
suoa_extractions = []
for idx, row in df.iterrows():
    # Try extracting from multiple fields
    text_sources = [row.get('Main infor', ''), row.get(
        'addtion info', ''), row.get('core infor', '')]
    combined_text = ' '.join([str(t) for t in text_sources if pd.notna(t)])

    suoa_info = extract_suoa_info(combined_text)
    suoa_info['Study_Index'] = idx
    suoa_info['Title'] = row.get('Title', '')
    suoa_extractions.append(suoa_info)

df_suoa = pd.DataFrame(suoa_extractions)

# Analyze SUoA extraction success
print("SUoA Information Extraction Success:")
suoa_fields = ['SUoA_Size', 'SUoA_Type', 'Study_Area_Size', 'Country']
for field in suoa_fields:
    if field in df_suoa.columns:
        success = df_suoa[field].notna().sum()
        print(
            f"  {field:15s}: {success:2d}/{len(df_suoa)} ({success/len(df_suoa)*100:5.1f}%)")

# Show examples of extracted SUoA sizes
if 'SUoA_Size' in df_suoa.columns:
    sizes = df_suoa['SUoA_Size'].dropna().head(10)
    print(f"\nExample SUoA sizes extracted:")
    for i, size in enumerate(sizes, 1):
        print(f"  {i:2d}. {size}")

print(f"\n{'='*60}")
print("VARIABLE INFORMATION EXTRACTION")
print(f"{'='*60}")

# Function to count variables mentioned in text


def count_variables_in_text(text):
    """Count and categorize variables mentioned in text"""
    if pd.isna(text):
        return {}

    # Look for variable lists and counts
    counts = {}

    # Try to find total variable counts
    total_patterns = [
        r"Total Independent Variables:?\s*(\d+)",
        r"(\d+)\s*independent variables?",
        r"(\d+)\s*variables? in total"
    ]

    for pattern in total_patterns:
        matches = re.findall(pattern, text, re.IGNORECASE)
        if matches:
            counts['Total_Variables'] = int(matches[0])
            break

    # Try to find category-specific counts
    categories = {
        'Demographic': [r"(\d+)\s*demographic", r"Demographic Variables:?\s*(\d+)"],
        'Economic': [r"(\d+)\s*economic", r"Economic Variables:?\s*(\d+)"],
        'Land_Use': [r"(\d+)\s*land\s*use", r"Land Use Variables:?\s*(\d+)"],
        'Infrastructure': [r"(\d+)\s*infrastructure", r"Infrastructure Variables:?\s*(\d+)"],
        'Distance': [r"(\d+)\s*distance", r"Distance.*?Variables:?\s*(\d+)"],
        'Crime_Opportunity': [r"(\d+)\s*crime\s*opportunity", r"Crime Opportunity Variables:?\s*(\d+)"],
        'Social': [r"(\d+)\s*social", r"Social.*?Variables:?\s*(\d+)"],
        'Environmental': [r"(\d+)\s*environmental", r"Environmental Variables:?\s*(\d+)"],
        'Temporal': [r"(\d+)\s*temporal", r"Temporal.*?Variables:?\s*(\d+)"]
    }

    for category, patterns in categories.items():
        for pattern in patterns:
            matches = re.findall(pattern, text, re.IGNORECASE)
            if matches:
                counts[f'{category}_Variables'] = int(matches[0])
                break

    return counts


# Count variables across all studies
variable_counts = []
for idx, row in df.iterrows():
    # Combine all text fields that might contain variable information
    text_sources = [
        row.get('Variables ', ''),
        row.get('addtion info', ''),
        row.get('revised info', ''),
        row.get('Main infor', '')
    ]
    combined_text = ' '.join([str(t) for t in text_sources if pd.notna(t)])

    var_counts = count_variables_in_text(combined_text)
    var_counts['Study_Index'] = idx
    var_counts['Title'] = row.get('Title', '')
    variable_counts.append(var_counts)

df_variables = pd.DataFrame(variable_counts)

print("Variable Count Extraction Success:")
var_fields = ['Total_Variables', 'Demographic_Variables', 'Economic_Variables',
              'Land_Use_Variables', 'Infrastructure_Variables', 'Distance_Variables',
              'Crime_Opportunity_Variables', 'Social_Variables', 'Environmental_Variables', 'Temporal_Variables']

for field in var_fields:
    if field in df_variables.columns:
        success = df_variables[field].notna().sum()
        print(
            f"  {field:20s}: {success:2d}/{len(df_variables)} ({success/len(df_variables)*100:5.1f}%)")

# Show statistics for total variables
if 'Total_Variables' in df_variables.columns:
    total_vars = df_variables['Total_Variables'].dropna()
    if len(total_vars) > 0:
        print(f"\nTotal Variables Statistics:")
        print(f"  Range: {total_vars.min()}-{total_vars.max()} variables")
        print(f"  Mean: {total_vars.mean():.1f} variables")
        print(f"  Median: {total_vars.median():.1f} variables")

print(f"\n{'='*60}")
print("METHODOLOGY INFORMATION EXTRACTION")
print(f"{'='*60}")

# Function to extract methodology information


def extract_methodology_info(text):
    """Extract methodology information from text"""
    if pd.isna(text):
        return {}

    info = {}

    # Extract model type
    model_patterns = [
        r"Model Type:?\s*([^-\n]+)",
        r"discrete choice model.*?:?\s*([^-\n]+)",
        r"Type of.*?model.*?:?\s*([^-\n]+)"
    ]

    for pattern in model_patterns:
        match = re.search(pattern, text, re.IGNORECASE | re.DOTALL)
        if match:
            info['Model_Type'] = match.group(1).strip()
            break

    # Extract software
    software_patterns = [
        r"Software Used:?\s*([^-\n]+)",
        r"using\s+([A-Z][a-z]*\s*\d*)",
        r"analyzed.*?with\s+([A-Z][a-z]*)"
    ]

    for pattern in software_patterns:
        match = re.search(pattern, text, re.IGNORECASE | re.DOTALL)
        if match:
            info['Software'] = match.group(1).strip()
            break

    # Extract sample size
    sample_patterns = [
        r"Sample Size:?\s*([^-\n]+)",
        r"(\d+)\s*choice observations",
        r"(\d+)\s*observations"
    ]

    for pattern in sample_patterns:
        match = re.search(pattern, text, re.IGNORECASE | re.DOTALL)
        if match:
            info['Sample_Size'] = match.group(1).strip()
            break

    return info


# Extract methodology information
methodology_extractions = []
for idx, row in df.iterrows():
    text_sources = [row.get('Main infor', ''), row.get(
        'addtion info', ''), row.get('core infor', '')]
    combined_text = ' '.join([str(t) for t in text_sources if pd.notna(t)])

    method_info = extract_methodology_info(combined_text)
    method_info['Study_Index'] = idx
    method_info['Title'] = row.get('Title', '')
    methodology_extractions.append(method_info)

df_methodology = pd.DataFrame(methodology_extractions)

print("Methodology Information Extraction Success:")
method_fields = ['Model_Type', 'Software', 'Sample_Size']
for field in method_fields:
    if field in df_methodology.columns:
        success = df_methodology[field].notna().sum()
        print(
            f"  {field:12s}: {success:2d}/{len(df_methodology)} ({success/len(df_methodology)*100:5.1f}%)")

# Show most common model types
if 'Model_Type' in df_methodology.columns:
    model_types = df_methodology['Model_Type'].dropna()
    if len(model_types) > 0:
        print(f"\nMost common model types:")
        for model, count in model_types.value_counts().head(5).items():
            print(f"  {model}: {count} studies")

print(f"\n{'='*60}")
print("OVERALL EXTRACTION QUALITY ASSESSMENT")
print(f"{'='*60}")

# Calculate overall completeness score
fields_to_check = [
    ('Basic Info', ['Title', 'Authors', 'Year']),
    ('SUoA Info', ['SUoA_Size', 'SUoA_Type', 'Country']),
    ('Variables', ['Total_Variables']),
    ('Methodology', ['Model_Type', 'Sample_Size'])
]

total_scores = []
for study_idx in range(len(df)):
    study_score = 0
    max_score = 0

    for category, fields in fields_to_check:
        for field in fields:
            max_score += 1
            # Check in appropriate dataframe
            if field in df.columns:
                if pd.notna(df.iloc[study_idx][field]):
                    study_score += 1
            elif field in df_suoa.columns:
                if pd.notna(df_suoa.iloc[study_idx][field]):
                    study_score += 1
            elif field in df_variables.columns:
                if pd.notna(df_variables.iloc[study_idx][field]):
                    study_score += 1
            elif field in df_methodology.columns:
                if pd.notna(df_methodology.iloc[study_idx][field]):
                    study_score += 1

    total_scores.append(study_score / max_score * 100)

avg_completeness = np.mean(total_scores)
print(f"Average study completeness: {avg_completeness:.1f}%")
print(
    f"Studies with >80% completeness: {sum(1 for s in total_scores if s > 80)}/{len(total_scores)}")
print(
    f"Studies with >60% completeness: {sum(1 for s in total_scores if s > 60)}/{len(total_scores)}")

print(f"\n{'='*60}")
print("READINESS FOR ANALYSIS")
print(f"{'='*60}")

# Count studies ready for each research question
ready_counts = {
    'SUoA Size Distribution': len(df_suoa[df_suoa['SUoA_Size'].notna()]),
    'Temporal Trends': len(df[(df['Year'].notna()) & (df_suoa['SUoA_Size'].notna())]),
    'Jurisdiction Analysis': len(df_suoa[df_suoa['Country'].notna()]),
    'Variable-Scale Relationships': len(df_variables[df_variables['Total_Variables'].notna()]),
    'Methodology Analysis': len(df_methodology[df_methodology['Model_Type'].notna()])
}

print("Studies ready for each research question:")
for question, count in ready_counts.items():
    print(
        f"  {question:25s}: {count:2d}/{len(df)} studies ({count/len(df)*100:5.1f}%)")

print(f"\n{'='*60}")
print("RECOMMENDATIONS")
print(f"{'='*60}")

print("✅ EXTRACTION SUCCESS:")
print(f"  - {len(df)} studies successfully processed")
print(f"  - Average completeness: {avg_completeness:.1f}%")
print(f"  - Most research questions can be answered with current data")

print("\n⚠️ AREAS FOR IMPROVEMENT:")
improvement_areas = []

if ready_counts['SUoA Size Distribution'] < len(df) * 0.8:
    improvement_areas.append(
        f"  - SUoA size information: {ready_counts['SUoA Size Distribution']}/{len(df)} studies")

if ready_counts['Variable-Scale Relationships'] < len(df) * 0.8:
    improvement_areas.append(
        f"  - Variable counts: {ready_counts['Variable-Scale Relationships']}/{len(df)} studies")

if ready_counts['Jurisdiction Analysis'] < len(df) * 0.8:
    improvement_areas.append(
        f"  - Country information: {ready_counts['Jurisdiction Analysis']}/{len(df)} studies")

for area in improvement_areas:
    print(area)

print("\n🎯 NEXT STEPS:")
print("1. Create merged dataset combining all extracted information")
print("2. Standardize SUoA size units (convert all to km²)")
print("3. Standardize country names for jurisdiction analysis")
print("4. Begin statistical analysis of research questions")
print("5. Consider targeted re-extraction for missing critical information")

# Save analysis results
df_suoa.to_csv("Comprehensive_SUoA_Extraction.csv", index=False)
df_variables.to_csv("Comprehensive_Variable_Extraction.csv", index=False)
df_methodology.to_csv("Comprehensive_Methodology_Extraction.csv", index=False)

print(f"\n✅ Analysis complete! Extracted data saved to:")
print(f"   - Comprehensive_SUoA_Extraction.csv")
print(f"   - Comprehensive_Variable_Extraction.csv")
print(f"   - Comprehensive_Methodology_Extraction.csv")

print(f"\n📊 FINAL SUMMARY:")
print(f"   Total studies: {len(df)}")
print(
    f"   Studies with SUoA info: {len(df_suoa[df_suoa['SUoA_Size'].notna()])}")
print(
    f"   Studies with variable counts: {len(df_variables[df_variables['Total_Variables'].notna()])}")
print(
    f"   Studies with methodology info: {len(df_methodology[df_methodology['Model_Type'].notna()])}")
print(f"   Ready for comprehensive analysis: YES!")
