"""
Supplementary Analysis: Methodological Patterns in SUoA Studies
This script provides additional analysis focusing on methodological aspects
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns


def create_methodological_recommendations(df):
    """Create recommendations for extending the analysis"""

    print("="*60)
    print("METHODOLOGICAL ANALYSIS EXTENSION RECOMMENDATIONS")
    print("="*60)

    print("\n1. DISCRETE CHOICE METHODS ANALYSIS")
    print("   To analyze the relationship between SUoA size and choice methods:")
    print("   - Code each study for statistical method used:")
    print("     * Multinomial logit")
    print("     * Mixed (random parameters) logit")
    print("     * Latent class logit")
    print("     * Nested logit")
    print("   - Code for alternative sampling strategy:")
    print("     * Full choice set")
    print("     * Random sampling")
    print("     * Stratified sampling")
    print("     * Importance sampling")

    # Predict patterns based on current data
    very_small = len(df[df['Unit_size_km2'] < 0.001])
    small = len(df[(df['Unit_size_km2'] >= 0.001)
                & (df['Unit_size_km2'] < 1.0)])
    large = len(df[df['Unit_size_km2'] >= 2.0])

    print(f"\n   Expected patterns based on current data:")
    print(
        f"   - Very small units ({very_small} studies): Likely use alternative sampling")
    print(f"   - Small units ({small} studies): Mixed approaches")
    print(f"   - Large units ({large} studies): Likely use full choice sets")

    print("\n2. INDEPENDENT VARIABLES ANALYSIS")
    print("   To analyze variable availability by scale:")
    print("   - Code variables into categories:")
    print("     * Demographic variables")
    print("     * Economic variables")
    print("     * Land use variables")
    print("     * Infrastructure variables")
    print("     * Crime opportunity variables")
    print("     * Distance/accessibility variables")

    print(f"\n   Expected patterns:")
    print(f"   - Micro-scale studies: Fewer demographic variables")
    print(f"   - Macro-scale studies: More administrative data available")

    print("\n3. RECOMMENDED ADDITIONAL DATA COLLECTION")
    print("   For each study, extract:")
    print("   - Number of independent variables")
    print("   - Data sources used")
    print("   - Sample size (choice occasions)")
    print("   - Computational approach mentioned")
    print("   - Justification for scale choice")

    return None


def analyze_study_scale_efficiency(df):
    """Analyze the efficiency implications of different scales"""

    print("\n4. SCALE EFFICIENCY ANALYSIS")
    print("   Based on current data:")

    # Calculate choice set sizes (approximate)
    df['Choice_Set_Size'] = df['No_of_units']
    df['Sample_Efficiency'] = df['No_of_incidents'] / df['No_of_units']

    # Group by size categories for efficiency analysis
    efficiency_stats = df.groupby('Size_group').agg({
        'Choice_Set_Size': ['mean', 'median', 'std'],
        'Sample_Efficiency': ['mean', 'median', 'std'],
        'No_of_incidents': ['mean', 'median'],
        'Unit_size_km2': ['mean', 'median']
    }).round(3)

    print("\n   Efficiency metrics by size group:")
    print(efficiency_stats)

    # Create efficiency visualization
    fig, axes = plt.subplots(2, 2, figsize=(15, 10))

    # Choice set size vs efficiency
    axes[0, 0].scatter(df['Choice_Set_Size'], df['Sample_Efficiency'],
                       c=np.log10(df['Unit_size_km2']), cmap='viridis', alpha=0.7)
    axes[0, 0].set_xlabel('Choice Set Size (Number of Units)')
    axes[0, 0].set_ylabel('Sample Efficiency (Incidents/Unit)')
    axes[0, 0].set_title('Sample Efficiency vs Choice Set Size')
    axes[0, 0].set_xscale('log')
    axes[0, 0].set_yscale('log')

    # Box plot of choice set sizes by group
    df.boxplot(column='Choice_Set_Size', by='Size_group', ax=axes[0, 1])
    axes[0, 1].set_xlabel('Size Group')
    axes[0, 1].set_ylabel('Choice Set Size')
    axes[0, 1].set_title('Choice Set Size by Unit Size Group')
    axes[0, 1].set_yscale('log')

    # Sample efficiency by group
    df.boxplot(column='Sample_Efficiency', by='Size_group', ax=axes[1, 0])
    axes[1, 0].set_xlabel('Size Group')
    axes[1, 0].set_ylabel('Sample Efficiency')
    axes[1, 0].set_title('Sample Efficiency by Unit Size Group')
    axes[1, 0].set_yscale('log')

    # Unit size vs incidents
    axes[1, 1].scatter(df['Unit_size_km2'], df['No_of_incidents'], alpha=0.7)
    axes[1, 1].set_xlabel('Unit Size (km²)')
    axes[1, 1].set_ylabel('Number of Incidents')
    axes[1, 1].set_title('Incidents vs Unit Size')
    axes[1, 1].set_xscale('log')
    axes[1, 1].set_yscale('log')

    plt.tight_layout()
    plt.savefig('methodological_efficiency_analysis.png',
                dpi=300, bbox_inches='tight')
    plt.show()

    return efficiency_stats


def create_data_collection_template(df):
    """Create a template for collecting additional methodological data"""

    # Create a template dataframe with the current studies
    template = df[['Study_ID', 'Title_of_the_study',
                   'Citation', 'Unit_size_km2', 'Size_group']].copy()

    # Add empty columns for methodological coding
    methodological_columns = [
        'Statistical_Method',
        'Alternative_Sampling',
        'Number_of_Variables',
        'Variable_Types',
        'Data_Sources',
        'Sample_Size_Choice_Occasions',
        'Computational_Approach',
        'Scale_Justification',
        'Software_Used',
        'Estimation_Time_Mentioned',
        'Convergence_Issues',
        'Model_Fit_Reported'
    ]

    for col in methodological_columns:
        template[col] = ''

    # Save template
    template.to_csv('Methodological_Coding_Template.csv', index=False)

    print("\n5. DATA COLLECTION TEMPLATE CREATED")
    print("   File: 'Methodological_Coding_Template.csv'")
    print("   This template can be used to systematically code:")
    print("   - Statistical methods used")
    print("   - Alternative sampling strategies")
    print("   - Variable types and counts")
    print("   - Data sources")
    print("   - Computational details")
    print("   - Scale choice justifications")

    return template


def analyze_potential_patterns(df):
    """Analyze potential patterns that might exist"""

    print("\n6. POTENTIAL PATTERN IDENTIFICATION")

    # Look for studies that might use alternative sampling
    large_choice_sets = df[df['No_of_units']
                           > df['No_of_units'].quantile(0.75)]
    small_units = df[df['Unit_size_km2'] < 0.01]

    print(f"\n   Studies likely using alternative sampling:")
    print(
        f"   - Large choice sets (>{df['No_of_units'].quantile(0.75):.0f} units): {len(large_choice_sets)} studies")
    print(f"   - Very small units (<0.01 km²): {len(small_units)} studies")

    # Studies that might have computational constraints
    potential_sampling = df[(df['No_of_units'] > 1000)
                            | (df['Unit_size_km2'] < 0.01)]

    print(f"\n   Studies with potential computational constraints:")
    for idx, row in potential_sampling.iterrows():
        print(
            f"   - {row['Citation']}: {row['No_of_units']:.0f} units, {row['Unit_size_km2']:.6f} km²")

    # Look for temporal patterns in methodology (proxy analysis)
    if 'Year' in df.columns:
        recent_studies = df[df['Year'] >= 2015].dropna(subset=['Year'])
        older_studies = df[df['Year'] < 2015].dropna(subset=['Year'])

        if len(recent_studies) > 0 and len(older_studies) > 0:
            print(f"\n   Temporal patterns (proxy indicators):")
            print(
                f"   - Recent studies (2015+): Mean {recent_studies['No_of_units'].mean():.0f} units")
            print(
                f"   - Older studies (<2015): Mean {older_studies['No_of_units'].mean():.0f} units")
            print(
                f"   - Recent studies use {'larger' if recent_studies['No_of_units'].mean() > older_studies['No_of_units'].mean() else 'smaller'} choice sets on average")

    return potential_sampling


def main():
    """Run the supplementary methodological analysis"""

    # Load the data
    df = pd.read_csv("20250703_standardized_unit_sizes_with_groups.csv")

    # Clean data
    df['Unit_size_km2'] = pd.to_numeric(df['Unit_size_km2'], errors='coerce')
    df['No_of_units'] = df['No_of_units'].astype(
        str).str.replace('\t', '').str.strip()
    df['No_of_units'] = pd.to_numeric(df['No_of_units'], errors='coerce')
    df['No_of_incidents'] = df['No_of_incidents'].astype(
        str).str.replace('\t', '').str.strip()
    df['No_of_incidents'] = pd.to_numeric(
        df['No_of_incidents'], errors='coerce')

    # Extract years from citations
    import re

    def extract_year_from_citation(citation):
        if pd.isna(citation):
            return None
        match = re.search(r'\(.*?(\d{4})\)', citation)
        if match:
            return int(match.group(1))
        return None

    df['Year'] = df['Citation'].apply(extract_year_from_citation)

    # Run analyses
    create_methodological_recommendations(df)
    efficiency_stats = analyze_study_scale_efficiency(df)
    template = create_data_collection_template(df)
    potential_patterns = analyze_potential_patterns(df)

    print("\n" + "="*60)
    print("SUPPLEMENTARY ANALYSIS COMPLETE")
    print("="*60)
    print("Files created:")
    print("- methodological_efficiency_analysis.png")
    print("- Methodological_Coding_Template.csv")


if __name__ == "__main__":
    main()
