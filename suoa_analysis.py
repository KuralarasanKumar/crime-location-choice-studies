"""
Spatial Unit of Analysis (SUoA) Descriptive Review Analysis
Analysis of crime location choice studies' spatial unit characteristics
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime
import re
import warnings
warnings.filterwarnings('ignore')

# Set style for better plots
plt.style.use('default')
sns.set_palette("husl")


def extract_year_from_citation(citation):
    """Extract publication year from citation string"""
    if pd.isna(citation):
        return None

    # Look for patterns like (Author, YYYY) or (Author et al., YYYY)
    match = re.search(r'\(.*?(\d{4})\)', citation)
    if match:
        return int(match.group(1))
    return None


def infer_jurisdiction(citation, title):
    """Infer jurisdiction/country from study context"""
    text = str(citation).lower() + " " + str(title).lower()

    # Define jurisdiction patterns
    jurisdictions = {
        'Netherlands': ['netherlands', 'dutch', 'amsterdam', 'hague'],
        'UK': ['uk', 'britain', 'british', 'england', 'london', 'belfast'],
        'USA': ['chicago', 'richmond', 'tampa', 'virginia'],
        'Canada': ['canada', 'canadian'],
        'Australia': ['australia', 'australian'],
        'China': ['china', 'chinese', 'guangzhou', 'zg city'],
        'India': ['chennai', 'india'],
        'Japan': ['japan', 'japanese'],
        'New Zealand': ['new zealand'],
        'Belgium': ['belgium', 'belgian']
    }

    for country, keywords in jurisdictions.items():
        if any(keyword in text for keyword in keywords):
            return country

    return 'Unknown'


def extract_crime_type(title):
    """Extract crime type from study title"""
    title_lower = str(title).lower()

    crime_types = {
        'Burglary': ['burglary', 'burglar'],
        'Robbery': ['robbery', 'robber'],
        'Theft': ['theft', 'snatching'],
        'Drug crimes': ['drug', 'dealer'],
        'Graffiti': ['graffiti'],
        'Terrorism': ['terrorist', 'terrorism'],
        'General crime': ['crime', 'offend']
    }

    for crime_type, keywords in crime_types.items():
        if any(keyword in title_lower for keyword in keywords):
            return crime_type

    return 'Other'


def load_and_prepare_data(filepath):
    """Load and prepare the dataset for analysis"""
    df = pd.read_csv(filepath)

    # Clean and convert numeric columns to proper types
    df['Unit_size_km2'] = pd.to_numeric(df['Unit_size_km2'], errors='coerce')

    # Clean the No_of_units column (remove tabs and other whitespace)
    df['No_of_units'] = df['No_of_units'].astype(
        str).str.replace('\t', '').str.strip()
    df['No_of_units'] = pd.to_numeric(df['No_of_units'], errors='coerce')

    # Clean the No_of_incidents column
    df['No_of_incidents'] = df['No_of_incidents'].astype(
        str).str.replace('\t', '').str.strip()
    df['No_of_incidents'] = pd.to_numeric(
        df['No_of_incidents'], errors='coerce')

    # Extract years from citations
    df['Year'] = df['Citation'].apply(extract_year_from_citation)

    # Infer jurisdictions
    df['Jurisdiction'] = df.apply(lambda row: infer_jurisdiction(
        row['Citation'], row['Title_of_the_study']), axis=1)

    # Extract crime types
    df['Crime_Type'] = df['Title_of_the_study'].apply(extract_crime_type)

    # Calculate total study area (approximate) - handle missing values
    df['Total_Study_Area_km2'] = df['Unit_size_km2'] * df['No_of_units']

    # Create time periods
    df['Time_Period'] = pd.cut(df['Year'],
                               bins=[2002, 2010, 2015, 2020, 2025],
                               labels=['2003-2010', '2011-2015',
                                       '2016-2020', '2021-2025'],
                               include_lowest=True)

    return df


def analyze_suoa_distribution(df):
    """Analyze the distribution of SUoA sizes"""
    print("=== SUoA Size Distribution Analysis ===")
    print(f"Total number of studies: {len(df)}")
    print(f"\nUnit size (km²) statistics:")
    print(df['Unit_size_km2'].describe())

    print(f"\nSize group distribution:")
    print(df['Size_group'].value_counts())

    # Create distribution plot
    fig, axes = plt.subplots(2, 2, figsize=(15, 10))

    # Histogram of unit sizes (log scale)
    axes[0, 0].hist(df['Unit_size_km2'], bins=20, alpha=0.7, edgecolor='black')
    axes[0, 0].set_xlabel('Unit Size (km²)')
    axes[0, 0].set_ylabel('Frequency')
    axes[0, 0].set_title('Distribution of SUoA Sizes')
    axes[0, 0].set_yscale('log')

    # Box plot by size groups
    df.boxplot(column='Unit_size_km2', by='Size_group', ax=axes[0, 1])
    axes[0, 1].set_xlabel('Size Group')
    axes[0, 1].set_ylabel('Unit Size (km²)')
    axes[0, 1].set_title('SUoA Size by Group')
    axes[0, 1].set_yscale('log')

    # Pie chart of size groups
    size_counts = df['Size_group'].value_counts()
    axes[1, 0].pie(size_counts.values,
                   labels=size_counts.index, autopct='%1.1f%%')
    axes[1, 0].set_title('Proportion of Studies by Size Group')

    # Unit types distribution
    unit_counts = df['Name_of_the_unit'].value_counts().head(10)
    axes[1, 1].barh(range(len(unit_counts)), unit_counts.values)
    axes[1, 1].set_yticks(range(len(unit_counts)))
    axes[1, 1].set_yticklabels(unit_counts.index)
    axes[1, 1].set_xlabel('Number of Studies')
    axes[1, 1].set_title('Top 10 Unit Types Used')

    plt.tight_layout()
    plt.savefig('suoa_distribution_analysis.png', dpi=300, bbox_inches='tight')
    plt.show()


def analyze_temporal_trends(df):
    """Analyze how SUoA size changes over time"""
    print("\n=== Temporal Trends Analysis ===")

    # Remove rows with missing years
    df_temporal = df.dropna(subset=['Year'])

    print(f"Studies with publication year: {len(df_temporal)}")
    print(
        f"Year range: {df_temporal['Year'].min()} - {df_temporal['Year'].max()}")

    # Calculate correlation between year and unit size
    correlation = df_temporal['Year'].corr(
        np.log10(df_temporal['Unit_size_km2']))
    print(f"Correlation between year and log(unit size): {correlation:.3f}")

    # Create temporal analysis plots
    fig, axes = plt.subplots(2, 2, figsize=(15, 10))

    # Scatter plot: Year vs Unit Size
    axes[0, 0].scatter(df_temporal['Year'],
                       df_temporal['Unit_size_km2'], alpha=0.7)
    axes[0, 0].set_xlabel('Publication Year')
    axes[0, 0].set_ylabel('Unit Size (km²)')
    axes[0, 0].set_title('SUoA Size Over Time')
    axes[0, 0].set_yscale('log')

    # Add trend line
    z = np.polyfit(df_temporal['Year'], np.log10(
        df_temporal['Unit_size_km2']), 1)
    p = np.poly1d(z)
    axes[0, 0].plot(df_temporal['Year'], 10 **
                    p(df_temporal['Year']), "r--", alpha=0.8)

    # Box plot by time period
    df_temporal.boxplot(column='Unit_size_km2',
                        by='Time_Period', ax=axes[0, 1])
    axes[0, 1].set_xlabel('Time Period')
    axes[0, 1].set_ylabel('Unit Size (km²)')
    axes[0, 1].set_title('SUoA Size by Time Period')
    axes[0, 1].set_yscale('log')

    # Size group evolution over time
    size_time = df_temporal.groupby(
        ['Time_Period', 'Size_group']).size().unstack(fill_value=0)
    size_time_pct = size_time.div(size_time.sum(axis=1), axis=0) * 100
    size_time_pct.plot(kind='bar', stacked=True, ax=axes[1, 0])
    axes[1, 0].set_xlabel('Time Period')
    axes[1, 0].set_ylabel('Percentage of Studies')
    axes[1, 0].set_title('Size Group Distribution Over Time')
    axes[1, 0].legend(bbox_to_anchor=(1.05, 1), loc='upper left')

    # Mean unit size by year
    yearly_mean = df_temporal.groupby('Year')['Unit_size_km2'].mean()
    axes[1, 1].plot(yearly_mean.index, yearly_mean.values, 'o-')
    axes[1, 1].set_xlabel('Publication Year')
    axes[1, 1].set_ylabel('Mean Unit Size (km²)')
    axes[1, 1].set_title('Mean SUoA Size by Year')
    axes[1, 1].set_yscale('log')

    plt.tight_layout()
    plt.savefig('temporal_trends_analysis.png', dpi=300, bbox_inches='tight')
    plt.show()


def analyze_jurisdiction_patterns(df):
    """Analyze SUoA size variation by jurisdiction"""
    print("\n=== Jurisdiction Analysis ===")

    # Filter out unknown jurisdictions for main analysis
    df_known = df[df['Jurisdiction'] != 'Unknown']

    print(f"Studies with known jurisdiction: {len(df_known)}")
    print(f"\nJurisdiction distribution:")
    print(df['Jurisdiction'].value_counts())

    print(f"\nMean unit size by jurisdiction (km²):")
    jurisdiction_stats = df_known.groupby('Jurisdiction')['Unit_size_km2'].agg([
        'count', 'mean', 'median', 'std'])
    print(jurisdiction_stats.round(4))

    # Create jurisdiction analysis plots
    fig, axes = plt.subplots(2, 2, figsize=(15, 10))

    # Box plot by jurisdiction
    df_known.boxplot(column='Unit_size_km2', by='Jurisdiction', ax=axes[0, 0])
    axes[0, 0].set_xlabel('Jurisdiction')
    axes[0, 0].set_ylabel('Unit Size (km²)')
    axes[0, 0].set_title('SUoA Size by Jurisdiction')
    axes[0, 0].set_yscale('log')
    plt.setp(axes[0, 0].xaxis.get_majorticklabels(), rotation=45)

    # Bar plot of study counts by jurisdiction
    jurisdiction_counts = df['Jurisdiction'].value_counts()
    axes[0, 1].bar(range(len(jurisdiction_counts)), jurisdiction_counts.values)
    axes[0, 1].set_xticks(range(len(jurisdiction_counts)))
    axes[0, 1].set_xticklabels(jurisdiction_counts.index, rotation=45)
    axes[0, 1].set_xlabel('Jurisdiction')
    axes[0, 1].set_ylabel('Number of Studies')
    axes[0, 1].set_title('Study Count by Jurisdiction')

    # Size group distribution by jurisdiction
    size_jurisdiction = df_known.groupby(
        ['Jurisdiction', 'Size_group']).size().unstack(fill_value=0)
    size_jurisdiction_pct = size_jurisdiction.div(
        size_jurisdiction.sum(axis=1), axis=0) * 100
    size_jurisdiction_pct.plot(kind='bar', stacked=True, ax=axes[1, 0])
    axes[1, 0].set_xlabel('Jurisdiction')
    axes[1, 0].set_ylabel('Percentage of Studies')
    axes[1, 0].set_title('Size Group Distribution by Jurisdiction')
    axes[1, 0].legend(bbox_to_anchor=(1.05, 1), loc='upper left')
    plt.setp(axes[1, 0].xaxis.get_majorticklabels(), rotation=45)

    # Mean unit size by jurisdiction (bar plot)
    mean_sizes = df_known.groupby('Jurisdiction')[
        'Unit_size_km2'].mean().sort_values()
    axes[1, 1].bar(range(len(mean_sizes)), mean_sizes.values)
    axes[1, 1].set_xticks(range(len(mean_sizes)))
    axes[1, 1].set_xticklabels(mean_sizes.index, rotation=45)
    axes[1, 1].set_xlabel('Jurisdiction')
    axes[1, 1].set_ylabel('Mean Unit Size (km²)')
    axes[1, 1].set_title('Mean SUoA Size by Jurisdiction')
    axes[1, 1].set_yscale('log')

    plt.tight_layout()
    plt.savefig('jurisdiction_analysis.png', dpi=300, bbox_inches='tight')
    plt.show()


def analyze_crime_type_patterns(df):
    """Analyze SUoA size variation by crime type"""
    print("\n=== Crime Type Analysis ===")

    print(f"Crime type distribution:")
    print(df['Crime_Type'].value_counts())

    print(f"\nMean unit size by crime type (km²):")
    crime_stats = df.groupby('Crime_Type')['Unit_size_km2'].agg(
        ['count', 'mean', 'median', 'std'])
    print(crime_stats.round(4))

    # Create crime type analysis plots
    fig, axes = plt.subplots(2, 2, figsize=(15, 10))

    # Box plot by crime type
    df.boxplot(column='Unit_size_km2', by='Crime_Type', ax=axes[0, 0])
    axes[0, 0].set_xlabel('Crime Type')
    axes[0, 0].set_ylabel('Unit Size (km²)')
    axes[0, 0].set_title('SUoA Size by Crime Type')
    axes[0, 0].set_yscale('log')
    plt.setp(axes[0, 0].xaxis.get_majorticklabels(), rotation=45)

    # Bar plot of study counts by crime type
    crime_counts = df['Crime_Type'].value_counts()
    axes[0, 1].bar(range(len(crime_counts)), crime_counts.values)
    axes[0, 1].set_xticks(range(len(crime_counts)))
    axes[0, 1].set_xticklabels(crime_counts.index, rotation=45)
    axes[0, 1].set_xlabel('Crime Type')
    axes[0, 1].set_ylabel('Number of Studies')
    axes[0, 1].set_title('Study Count by Crime Type')

    # Size group distribution by crime type
    size_crime = df.groupby(['Crime_Type', 'Size_group']
                            ).size().unstack(fill_value=0)
    size_crime_pct = size_crime.div(size_crime.sum(axis=1), axis=0) * 100
    size_crime_pct.plot(kind='bar', stacked=True, ax=axes[1, 0])
    axes[1, 0].set_xlabel('Crime Type')
    axes[1, 0].set_ylabel('Percentage of Studies')
    axes[1, 0].set_title('Size Group Distribution by Crime Type')
    axes[1, 0].legend(bbox_to_anchor=(1.05, 1), loc='upper left')
    plt.setp(axes[1, 0].xaxis.get_majorticklabels(), rotation=45)

    # Mean unit size by crime type (bar plot)
    mean_sizes = df.groupby('Crime_Type')['Unit_size_km2'].mean().sort_values()
    axes[1, 1].bar(range(len(mean_sizes)), mean_sizes.values)
    axes[1, 1].set_xticks(range(len(mean_sizes)))
    axes[1, 1].set_xticklabels(mean_sizes.index, rotation=45)
    axes[1, 1].set_xlabel('Crime Type')
    axes[1, 1].set_ylabel('Mean Unit Size (km²)')
    axes[1, 1].set_title('Mean SUoA Size by Crime Type')
    axes[1, 1].set_yscale('log')

    plt.tight_layout()
    plt.savefig('crime_type_analysis.png', dpi=300, bbox_inches='tight')
    plt.show()


def analyze_study_area_relationship(df):
    """Analyze relationship between SUoA size and total study area"""
    print("\n=== Study Area Relationship Analysis ===")

    # Remove outliers for cleaner analysis
    df_clean = df[df['Total_Study_Area_km2'] <
                  df['Total_Study_Area_km2'].quantile(0.95)]

    correlation = df_clean['Unit_size_km2'].corr(
        df_clean['Total_Study_Area_km2'])
    print(
        f"Correlation between unit size and total study area: {correlation:.3f}")

    # Create study area analysis plots
    fig, axes = plt.subplots(2, 2, figsize=(15, 10))

    # Scatter plot: Unit size vs Total study area
    axes[0, 0].scatter(df_clean['Unit_size_km2'],
                       df_clean['Total_Study_Area_km2'], alpha=0.7)
    axes[0, 0].set_xlabel('Unit Size (km²)')
    axes[0, 0].set_ylabel('Total Study Area (km²)')
    axes[0, 0].set_title('Unit Size vs Total Study Area')
    axes[0, 0].set_xscale('log')
    axes[0, 0].set_yscale('log')

    # Add trend line
    valid_data = df_clean.dropna(
        subset=['Unit_size_km2', 'Total_Study_Area_km2'])
    if len(valid_data) > 1:
        z = np.polyfit(np.log10(valid_data['Unit_size_km2']),
                       np.log10(valid_data['Total_Study_Area_km2']), 1)
        p = np.poly1d(z)
        x_trend = np.logspace(np.log10(valid_data['Unit_size_km2'].min()),
                              np.log10(valid_data['Unit_size_km2'].max()), 100)
        axes[0, 0].plot(x_trend, 10**p(np.log10(x_trend)), "r--", alpha=0.8)

    # Number of units vs Unit size
    axes[0, 1].scatter(df['Unit_size_km2'], df['No_of_units'], alpha=0.7)
    axes[0, 1].set_xlabel('Unit Size (km²)')
    axes[0, 1].set_ylabel('Number of Units')
    axes[0, 1].set_title('Unit Size vs Number of Units')
    axes[0, 1].set_xscale('log')
    axes[0, 1].set_yscale('log')

    # Distribution of total study areas
    axes[1, 0].hist(df_clean['Total_Study_Area_km2'],
                    bins=20, alpha=0.7, edgecolor='black')
    axes[1, 0].set_xlabel('Total Study Area (km²)')
    axes[1, 0].set_ylabel('Frequency')
    axes[1, 0].set_title('Distribution of Total Study Areas')
    axes[1, 0].set_xscale('log')

    # Size group by study area quartiles
    df['Study_Area_Quartile'] = pd.qcut(
        df['Total_Study_Area_km2'], 4, labels=['Q1', 'Q2', 'Q3', 'Q4'])
    size_area = df.groupby(
        ['Study_Area_Quartile', 'Size_group']).size().unstack(fill_value=0)
    size_area_pct = size_area.div(size_area.sum(axis=1), axis=0) * 100
    size_area_pct.plot(kind='bar', stacked=True, ax=axes[1, 1])
    axes[1, 1].set_xlabel('Study Area Quartile')
    axes[1, 1].set_ylabel('Percentage of Studies')
    axes[1, 1].set_title('Size Group by Study Area Quartile')
    axes[1, 1].legend(bbox_to_anchor=(1.05, 1), loc='upper left')

    plt.tight_layout()
    plt.savefig('study_area_analysis.png', dpi=300, bbox_inches='tight')
    plt.show()


def create_summary_report(df):
    """Create a comprehensive summary report"""
    print("\n" + "="*60)
    print("COMPREHENSIVE SUoA ANALYSIS SUMMARY REPORT")
    print("="*60)

    print(f"\nDATASET OVERVIEW:")
    print(f"• Total studies analyzed: {len(df)}")
    print(
        f"• Publication years: {df['Year'].min():.0f} - {df['Year'].max():.0f}")
    print(
        f"• Unit size range: {df['Unit_size_km2'].min():.6f} - {df['Unit_size_km2'].max():.2f} km²")
    print(
        f"• Number of different unit types: {df['Name_of_the_unit'].nunique()}")

    print(f"\nKEY FINDINGS:")

    # Temporal trends
    df_temporal = df.dropna(subset=['Year'])
    correlation_time = df_temporal['Year'].corr(
        np.log10(df_temporal['Unit_size_km2']))
    trend_direction = "decreasing" if correlation_time < 0 else "increasing"
    print(
        f"• Temporal trend: SUoA sizes are {trend_direction} over time (r = {correlation_time:.3f})")

    # Jurisdiction patterns
    df_known = df[df['Jurisdiction'] != 'Unknown']
    if len(df_known) > 0:
        jurisdiction_means = df_known.groupby(
            'Jurisdiction')['Unit_size_km2'].mean()
        smallest_jurisdiction = jurisdiction_means.idxmin()
        largest_jurisdiction = jurisdiction_means.idxmax()
        print(
            f"• Jurisdiction with smallest avg SUoA: {smallest_jurisdiction} ({jurisdiction_means[smallest_jurisdiction]:.4f} km²)")
        print(
            f"• Jurisdiction with largest avg SUoA: {largest_jurisdiction} ({jurisdiction_means[largest_jurisdiction]:.4f} km²)")

    # Crime type patterns
    crime_means = df.groupby('Crime_Type')['Unit_size_km2'].mean()
    smallest_crime = crime_means.idxmin()
    largest_crime = crime_means.idxmax()
    print(
        f"• Crime type with smallest avg SUoA: {smallest_crime} ({crime_means[smallest_crime]:.4f} km²)")
    print(
        f"• Crime type with largest avg SUoA: {largest_crime} ({crime_means[largest_crime]:.4f} km²)")

    # Study area relationship
    df_clean = df[df['Total_Study_Area_km2'] <
                  df['Total_Study_Area_km2'].quantile(0.95)]
    correlation_area = df_clean['Unit_size_km2'].corr(
        df_clean['Total_Study_Area_km2'])
    relationship = "positive" if correlation_area > 0.1 else "negative" if correlation_area < -0.1 else "weak"
    print(
        f"• Relationship between SUoA and study area: {relationship} correlation (r = {correlation_area:.3f})")

    # Size distribution
    size_group_counts = df['Size_group'].value_counts()
    most_common_size = size_group_counts.index[0]
    print(
        f"• Most common size category: {most_common_size} ({size_group_counts[most_common_size]} studies, {size_group_counts[most_common_size]/len(df)*100:.1f}%)")

    print(f"\nMETHODOLOGICAL IMPLICATIONS:")
    print(
        f"• Studies using very small units (< 0.001 km²): {len(df[df['Unit_size_km2'] < 0.001])}")
    print(
        f"• Studies using large units (> 2 km²): {len(df[df['Unit_size_km2'] > 2])}")
    print(
        f"• Range spans {df['Unit_size_km2'].max() / df['Unit_size_km2'].min():.0f}x from smallest to largest")

    print("\n" + "="*60)


def main():
    """Main analysis function"""
    # Load and prepare data
    filepath = "20250703_standardized_unit_sizes_with_groups.csv"
    df = load_and_prepare_data(filepath)

    # Run all analyses
    analyze_suoa_distribution(df)
    analyze_temporal_trends(df)
    analyze_jurisdiction_patterns(df)
    analyze_crime_type_patterns(df)
    analyze_study_area_relationship(df)

    # Generate summary report
    create_summary_report(df)

    print(f"\nAnalysis complete! Check the generated PNG files for visualizations.")


if __name__ == "__main__":
    main()
