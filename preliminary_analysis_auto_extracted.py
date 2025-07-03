"""
Preliminary Analysis with Auto-Extracted Data
This shows what can already be analyzed before manual coding
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Load the enhanced dataset with auto-extracted data
df = pd.read_csv("20250703_enhanced_dataset_with_auto_extraction.csv")

print("="*60)
print("PRELIMINARY ANALYSIS WITH AUTO-EXTRACTED DATA")
print("="*60)

print(f"\nDataset Overview:")
print(f"Total studies: {len(df)}")
print(f"Studies with publication year: {df['Publication_Year'].notna().sum()}")
print(f"Studies with identified country: {(df['Country'] != 'Unknown').sum()}")
print(f"Studies with crime type: {df['Primary_Crime_Type'].notna().sum()}")

# Enhanced temporal analysis
print(f"\n1. ENHANCED TEMPORAL TRENDS")
df_temporal = df.dropna(subset=['Publication_Year'])
print(
    f"Publication year range: {df_temporal['Publication_Year'].min()}-{df_temporal['Publication_Year'].max()}")

# Temporal trends by crime type
crime_by_year = df_temporal.groupby(
    ['Publication_Year', 'Primary_Crime_Type']).size().unstack(fill_value=0)
print(f"\nTemporal trends by crime type:")
print(crime_by_year.tail())

# Enhanced jurisdiction analysis
print(f"\n2. ENHANCED JURISDICTION ANALYSIS")
known_countries = df[df['Country'] != 'Unknown']
if len(known_countries) > 0:
    print(f"Mean SUoA size by country:")
    country_stats = known_countries.groupby(
        'Country')['Unit_size_km2'].agg(['count', 'mean', 'std'])
    print(country_stats.round(4))

# Enhanced crime type analysis
print(f"\n3. ENHANCED CRIME TYPE ANALYSIS")
crime_stats = df.groupby('Primary_Crime_Type')['Unit_size_km2'].agg(
    ['count', 'mean', 'median', 'std'])
print(f"SUoA size by crime type:")
print(crime_stats.round(4))

# Study area analysis
print(f"\n4. STUDY AREA ANALYSIS")
print(f"Study area statistics (km²):")
print(df['Study_Area_km2'].describe())

# Identify studies likely requiring special methodological approaches
print(f"\n5. METHODOLOGICAL IMPLICATIONS PREVIEW")
large_choice_sets = df[df['No_of_units'] > 1000]
very_small_units = df[df['Unit_size_km2'] < 0.01]
property_level = df[df['Name_of_the_unit'].str.contains(
    'property', case=False, na=False)]

print(f"\nStudies likely requiring alternative sampling:")
print(f"- Large choice sets (>1000 units): {len(large_choice_sets)} studies")
print(f"- Very small units (<0.01 km²): {len(very_small_units)} studies")
print(f"- Property-level studies: {len(property_level)} studies")

# Overlap analysis
overlap = len(set(large_choice_sets['Study_ID']) | set(
    very_small_units['Study_ID']) | set(property_level['Study_ID']))
print(
    f"- Total studies likely needing sampling: {overlap} studies ({overlap/len(df)*100:.1f}%)")

# Create visualizations with enhanced data
fig, axes = plt.subplots(2, 2, figsize=(15, 10))

# Enhanced temporal plot with crime types
if len(df_temporal) > 0:
    crime_type_colors = {'Burglary': 'red', 'Robbery': 'blue', 'General_crime': 'green',
                         'Theft': 'orange', 'Other': 'gray', 'Drug_crimes': 'purple',
                         'Graffiti': 'brown', 'Terrorism': 'pink'}

    for crime_type in df_temporal['Primary_Crime_Type'].unique():
        crime_data = df_temporal[df_temporal['Primary_Crime_Type'] == crime_type]
        color = crime_type_colors.get(crime_type, 'gray')
        axes[0, 0].scatter(crime_data['Publication_Year'], crime_data['Unit_size_km2'],
                           label=crime_type, alpha=0.7, color=color)

    axes[0, 0].set_xlabel('Publication Year')
    axes[0, 0].set_ylabel('Unit Size (km²)')
    axes[0, 0].set_title('SUoA Size Over Time by Crime Type')
    axes[0, 0].set_yscale('log')
    axes[0, 0].legend(bbox_to_anchor=(1.05, 1), loc='upper left')

# Crime type comparison
crime_means = df.groupby('Primary_Crime_Type')[
    'Unit_size_km2'].mean().sort_values()
axes[0, 1].barh(range(len(crime_means)), crime_means.values)
axes[0, 1].set_yticks(range(len(crime_means)))
axes[0, 1].set_yticklabels(crime_means.index)
axes[0, 1].set_xlabel('Mean Unit Size (km²)')
axes[0, 1].set_title('Mean SUoA Size by Crime Type')
axes[0, 1].set_xscale('log')

# Study area vs unit size
axes[1, 0].scatter(df['Unit_size_km2'], df['Study_Area_km2'], alpha=0.7)
axes[1, 0].set_xlabel('Unit Size (km²)')
axes[1, 0].set_ylabel('Total Study Area (km²)')
axes[1, 0].set_title('Unit Size vs Study Area')
axes[1, 0].set_xscale('log')
axes[1, 0].set_yscale('log')

# Methodological implications
method_categories = []
method_counts = []

# Categorize studies by likely methodological needs
full_choice_set = df[(df['No_of_units'] <= 500) & (df['Unit_size_km2'] >= 0.1)]
small_choice_set = df[(df['No_of_units'] <= 100)]
sampling_needed = df[(df['No_of_units'] > 1000) | (df['Unit_size_km2'] < 0.01)]
moderate_complexity = df[~df.index.isin(full_choice_set.index) &
                         ~df.index.isin(sampling_needed.index)]

method_categories = ['Full Choice Set\nLikely',
                     'Moderate\nComplexity', 'Sampling\nLikely Required']
method_counts = [len(full_choice_set), len(
    moderate_complexity), len(sampling_needed)]

axes[1, 1].pie(method_counts, labels=method_categories, autopct='%1.1f%%')
axes[1, 1].set_title('Predicted Methodological Approaches')

plt.tight_layout()
plt.savefig('preliminary_analysis_with_auto_extraction.png',
            dpi=300, bbox_inches='tight')
plt.show()

print(f"\n" + "="*60)
print("READY FOR MANUAL CODING")
print("="*60)
print(f"Next steps:")
print(f"1. Use 'Manual_Coding_Template_Streamlined.csv' for data entry")
print(f"2. Focus on Priority 1 columns (5 columns) first")
print(f"3. Use 'Coding_Guide_Streamlined.csv' for standardized values")
print(f"4. Start with a pilot of 5-10 studies to test the coding scheme")
print(f"\nFiles available:")
print(f"- Enhanced dataset: 20250703_enhanced_dataset_with_auto_extraction.csv")
print(f"- Manual coding template: Manual_Coding_Template_Streamlined.csv")
print(f"- Coding guide: Coding_Guide_Streamlined.csv")
print(f"- Analysis visualization: preliminary_analysis_with_auto_extraction.png")
