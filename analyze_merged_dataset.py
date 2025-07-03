#!/usr/bin/env python3
"""
Script to analyze the completeness of the merged bibliographic dataset
and prepare it for final analysis.
"""

import pandas as pd
import numpy as np


def main():
    """Analyze the merged dataset."""

    # Read the merged dataset
    print("Reading merged dataset...")
    df = pd.read_csv('20250703_Table_with_bibliographic_info.csv')

    print(f"Dataset contains {len(df)} studies")
    print(f"{'='*60}")

    # Analyze bibliographic information completeness
    print("BIBLIOGRAPHIC INFORMATION COMPLETENESS:")
    print(f"{'='*60}")

    fields = ['DOI', 'ISSN', 'Journal', 'Volume', 'Issue']
    for field in fields:
        non_empty = (df[field].notna() & (df[field] != '')).sum()
        percentage = (non_empty / len(df)) * 100
        print(f"{field:10}: {non_empty:2}/{len(df)} ({percentage:5.1f}%)")

    # Show studies missing critical information
    print(f"\n{'='*60}")
    print("STUDIES MISSING CRITICAL INFORMATION:")
    print(f"{'='*60}")

    # Studies without DOI
    missing_doi = df[df['DOI'].isna() | (df['DOI'] == '')]
    if len(missing_doi) > 0:
        print(f"\nStudies without DOI ({len(missing_doi)}):")
        for idx, row in missing_doi.iterrows():
            print(f"  {row['S_No']:2}. {row['Title_of_the_study'][:60]}...")
            print(f"      Journal: {row['Journal']}")
            print(f"      Year: {row['Citation']}")

    # Studies without Journal
    missing_journal = df[df['Journal'].isna() | (df['Journal'] == '')]
    if len(missing_journal) > 0:
        print(f"\nStudies without Journal ({len(missing_journal)}):")
        for idx, row in missing_journal.iterrows():
            print(f"  {row['S_No']:2}. {row['Title_of_the_study'][:60]}...")

    # Low confidence matches
    low_confidence = df[df['Match_Score'] < 0.8]
    if len(low_confidence) > 0:
        print(
            f"\nLow confidence matches (score < 0.8) - REVIEW RECOMMENDED ({len(low_confidence)}):")
        for idx, row in low_confidence.iterrows():
            print(f"  {row['S_No']:2}. Score: {row['Match_Score']:.3f}")
            print(f"      Original: {row['Title_of_the_study'][:60]}...")
            print(f"      Matched:  {row['Matched_Title'][:60]}...")

    # Analyze journal distribution
    print(f"\n{'='*60}")
    print("JOURNAL DISTRIBUTION:")
    print(f"{'='*60}")

    journal_counts = df[df['Journal'].notna() & (
        df['Journal'] != '')]['Journal'].value_counts()
    print(f"Total unique journals: {len(journal_counts)}")
    print("\nTop 10 journals by number of studies:")
    for i, (journal, count) in enumerate(journal_counts.head(10).items(), 1):
        print(f"  {i:2}. {journal} ({count} studies)")

    # Analyze year distribution from citations
    print(f"\n{'='*60}")
    print("TEMPORAL DISTRIBUTION:")
    print(f"{'='*60}")

    # Extract years from citations
    df['Year_extracted'] = df['Citation'].str.extract(r'(\d{4})')
    year_counts = df['Year_extracted'].value_counts().sort_index()
    print("Studies by year:")
    for year, count in year_counts.items():
        if pd.notna(year):
            print(f"  {year}: {count} studies")

    # Create a summary for export
    summary_stats = {
        'Total_Studies': len(df),
        'Studies_with_DOI': (df['DOI'].notna() & (df['DOI'] != '')).sum(),
        'Studies_with_Journal': (df['Journal'].notna() & (df['Journal'] != '')).sum(),
        'Studies_with_ISSN': (df['ISSN'].notna() & (df['ISSN'] != '')).sum(),
        'Perfect_Matches': (df['Match_Score'] == 1.0).sum(),
        'High_Confidence_Matches': (df['Match_Score'] >= 0.8).sum(),
        'Low_Confidence_Matches': (df['Match_Score'] < 0.8).sum(),
        'Unique_Journals': len(journal_counts),
        'Year_Range': f"{year_counts.index.min()}-{year_counts.index.max()}" if len(year_counts) > 0 else "N/A"
    }

    # Save summary
    summary_df = pd.DataFrame([summary_stats])
    summary_df.to_csv('20250703_dataset_completeness_summary.csv', index=False)
    print(f"\nSaved completeness summary to: 20250703_dataset_completeness_summary.csv")

    # Check data quality
    print(f"\n{'='*60}")
    print("DATA QUALITY ASSESSMENT:")
    print(f"{'='*60}")

    print(
        f"Perfect title matches: {(df['Match_Score'] == 1.0).sum()}/{len(df)} ({(df['Match_Score'] == 1.0).sum()/len(df)*100:.1f}%)")
    print(
        f"High confidence matches (≥0.8): {(df['Match_Score'] >= 0.8).sum()}/{len(df)} ({(df['Match_Score'] >= 0.8).sum()/len(df)*100:.1f}%)")
    print(
        f"Complete bibliographic info: {((df['DOI'].notna() & (df['DOI'] != '')) & (df['Journal'].notna() & (df['Journal'] != ''))).sum()}/{len(df)} studies")

    # Suggest next steps
    print(f"\n{'='*60}")
    print("NEXT STEPS:")
    print(f"{'='*60}")
    print("1. Review low-confidence matches manually")
    print("2. Search for missing DOIs manually if needed")
    print("3. Standardize journal names if necessary")
    print("4. Proceed with unit size standardization")
    print("5. Begin statistical analysis")

    print(f"\n{'='*60}")
    print("DATASET READY FOR ANALYSIS!")
    print(f"The merged dataset '20250703_Table_with_bibliographic_info.csv' contains:")
    print(f"  • {len(df)} crime location choice studies")
    print(f"  • {(df['DOI'].notna() & (df['DOI'] != '')).sum()} studies with DOIs ({(df['DOI'].notna() & (df['DOI'] != '')).sum()/len(df)*100:.1f}%)")
    print(f"  • {(df['Journal'].notna() & (df['Journal'] != '')).sum()} studies with journal information ({(df['Journal'].notna() & (df['Journal'] != '')).sum()/len(df)*100:.1f}%)")
    print(f"  • Studies from {len(journal_counts)} different journals")
    print(
        f"  • Publication years spanning {year_counts.index.min()}-{year_counts.index.max()}")
    print(f"{'='*60}")


if __name__ == "__main__":
    main()
