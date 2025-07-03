#!/usr/bin/env python3
"""
Script to merge bibliographic information from the retrieved articles dataset 
with the main analysis table by matching study titles.

This script adds DOI, ISSN, journal name, volume, and issue information 
to the main analysis table.
"""

import pandas as pd
import numpy as np
from difflib import SequenceMatcher
import re


def clean_title(title):
    """Clean and normalize titles for better matching."""
    if pd.isna(title):
        return ""
    
    # Convert to lowercase
    title = str(title).lower()
    
    # Remove extra whitespace and normalize
    title = ' '.join(title.split())
    
    # Remove common punctuation that might differ between sources
    title = re.sub(r'[^\w\s]', '', title)
    
    return title


def similarity(a, b):
    """Calculate similarity between two strings."""
    return SequenceMatcher(None, a, b).ratio()


def find_best_match(target_title, candidate_titles, threshold=0.6):
    """Find the best matching title from candidates."""
    target_clean = clean_title(target_title)
    best_match = None
    best_score = 0
    best_idx = None
    
    for idx, candidate in enumerate(candidate_titles):
        candidate_clean = clean_title(candidate)
        score = similarity(target_clean, candidate_clean)
        
        if score > best_score and score >= threshold:
            best_score = score
            best_match = candidate
            best_idx = idx
    
    return best_idx, best_score


def main():
    """Main function to merge bibliographic data."""
    
    # Read the main analysis table
    print("Reading main analysis table...")
    main_df = pd.read_csv('20250702_Table.csv')
    
    # Read the bibliographic information
    print("Reading bibliographic information...")
    biblio_df = pd.read_csv('20250117_Unique_retrieved_articles.csv')
    
    print(f"Main table has {len(main_df)} studies")
    print(f"Bibliographic table has {len(biblio_df)} articles")
    
    # Initialize new columns in the main dataframe
    main_df['DOI'] = ''
    main_df['ISSN'] = ''
    main_df['Journal'] = ''
    main_df['Volume'] = ''
    main_df['Issue'] = ''
    main_df['Match_Score'] = 0.0
    main_df['Matched_Title'] = ''
    
    # Track matches
    matches_found = 0
    match_details = []
    
    print("\nMatching titles...")
    
    for idx, row in main_df.iterrows():
        study_title = row['Title_of_the_study']
        print(f"\nProcessing study {idx + 1}: {study_title[:60]}...")
        
        # Find best match in bibliographic data
        best_idx, score = find_best_match(
            study_title, 
            biblio_df['title'].tolist(),
            threshold=0.6
        )
        
        if best_idx is not None:
            matched_row = biblio_df.iloc[best_idx]
            
            # Update main dataframe with bibliographic information
            main_df.at[idx, 'DOI'] = matched_row.get('doi', '') if pd.notna(matched_row.get('doi', '')) else ''
            main_df.at[idx, 'ISSN'] = matched_row.get('issn', '') if pd.notna(matched_row.get('issn', '')) else ''
            main_df.at[idx, 'Journal'] = matched_row.get('journal', '') if pd.notna(matched_row.get('journal', '')) else ''
            main_df.at[idx, 'Volume'] = matched_row.get('volume', '') if pd.notna(matched_row.get('volume', '')) else ''
            main_df.at[idx, 'Issue'] = matched_row.get('issue', '') if pd.notna(matched_row.get('issue', '')) else ''
            main_df.at[idx, 'Match_Score'] = score
            main_df.at[idx, 'Matched_Title'] = matched_row.get('title', '')
            
            matches_found += 1
            
            match_details.append({
                'Study_ID': idx + 1,
                'Original_Title': study_title,
                'Matched_Title': matched_row.get('title', ''),
                'Match_Score': score,
                'DOI': matched_row.get('doi', ''),
                'Journal': matched_row.get('journal', ''),
                'Year': matched_row.get('year', '')
            })
            
            print(f"  ✓ Match found (score: {score:.3f})")
            print(f"    Journal: {matched_row.get('journal', 'N/A')}")
            print(f"    DOI: {matched_row.get('doi', 'N/A')}")
        else:
            print(f"  ✗ No match found")
            match_details.append({
                'Study_ID': idx + 1,
                'Original_Title': study_title,
                'Matched_Title': 'NO MATCH',
                'Match_Score': 0.0,
                'DOI': '',
                'Journal': '',
                'Year': ''
            })
    
    # Save the enhanced main table
    output_file = '20250703_Table_with_bibliographic_info.csv'
    main_df.to_csv(output_file, index=False)
    print(f"\nSaved enhanced table to: {output_file}")
    
    # Create match details report
    match_df = pd.DataFrame(match_details)
    match_report_file = '20250703_bibliographic_matching_report.csv'
    match_df.to_csv(match_report_file, index=False)
    print(f"Saved matching report to: {match_report_file}")
    
    # Print summary statistics
    print(f"\n{'='*50}")
    print("MATCHING SUMMARY")
    print(f"{'='*50}")
    print(f"Total studies in main table: {len(main_df)}")
    print(f"Studies with matches found: {matches_found}")
    print(f"Match rate: {matches_found/len(main_df)*100:.1f}%")
    
    # Count studies with complete bibliographic info
    has_doi = (main_df['DOI'] != '').sum()
    has_journal = (main_df['Journal'] != '').sum()
    has_issn = (main_df['ISSN'] != '').sum()
    
    print(f"\nBibliographic information coverage:")
    print(f"  Studies with DOI: {has_doi}/{len(main_df)} ({has_doi/len(main_df)*100:.1f}%)")
    print(f"  Studies with Journal: {has_journal}/{len(main_df)} ({has_journal/len(main_df)*100:.1f}%)")
    print(f"  Studies with ISSN: {has_issn}/{len(main_df)} ({has_issn/len(main_df)*100:.1f}%)")
    
    # Show studies without matches
    no_matches = main_df[main_df['Match_Score'] == 0.0]
    if len(no_matches) > 0:
        print(f"\nStudies without matches ({len(no_matches)}):")
        for idx, row in no_matches.iterrows():
            print(f"  {idx + 1}. {row['Title_of_the_study']}")
    
    # Show low-confidence matches
    low_confidence = main_df[(main_df['Match_Score'] > 0) & (main_df['Match_Score'] < 0.8)]
    if len(low_confidence) > 0:
        print(f"\nLow-confidence matches (score < 0.8) - please review ({len(low_confidence)}):")
        for idx, row in low_confidence.iterrows():
            print(f"  {idx + 1}. Score: {row['Match_Score']:.3f}")
            print(f"     Original: {row['Title_of_the_study']}")
            print(f"     Matched:  {row['Matched_Title']}")
            print()


if __name__ == "__main__":
    main()
