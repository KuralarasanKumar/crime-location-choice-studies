"""
Merge Zotero Export with Elicit Extraction Data
Combines journal/citation info from Zotero with comprehensive study data from Elicit
"""

import pandas as pd
import numpy as np
from fuzzywuzzy import fuzz
import re

print("="*80)
print("MERGING ZOTERO EXPORT WITH ELICIT EXTRACTION")
print("="*80)


def clean_title_for_matching(title):
    """Clean title for better matching"""
    if pd.isna(title) or title == '':
        return ''
    # Remove special characters, normalize spacing
    clean = re.sub(r'[^\w\s]', ' ', str(title).lower())
    clean = re.sub(r'\s+', ' ', clean).strip()
    return clean


def find_best_match(elicit_title, zotero_titles, threshold=80):
    """Find best matching title using fuzzy matching"""
    elicit_clean = clean_title_for_matching(elicit_title)
    if not elicit_clean:
        return None, 0

    best_match = None
    best_score = 0

    for idx, zotero_title in enumerate(zotero_titles):
        zotero_clean = clean_title_for_matching(zotero_title)
        if not zotero_clean:
            continue

        # Try different fuzzy matching approaches
        ratio = fuzz.ratio(elicit_clean, zotero_clean)
        partial = fuzz.partial_ratio(elicit_clean, zotero_clean)
        token_sort = fuzz.token_sort_ratio(elicit_clean, zotero_clean)

        # Use the best score from different methods
        score = max(ratio, partial, token_sort)

        if score > best_score and score >= threshold:
            best_score = score
            best_match = idx

    return best_match, best_score


# Load the Elicit extraction data
try:
    elicit_df = pd.read_csv(
        "2 Elicit - Extract from 49 papers - Main infor addtion info revised info Variables core infor.csv")
    print(f"✅ Loaded Elicit extraction: {len(elicit_df)} studies")
except Exception as e:
    print(f"❌ Error loading Elicit file: {e}")
    exit()

# Load the Zotero matching data
try:
    matching_df = pd.read_csv("Zotero_Matching_Data.csv")
    print(f"✅ Loaded Zotero matching data: {len(matching_df)} studies")
except Exception as e:
    print(f"❌ Error loading matching file: {e}")
    exit()

# Try to load Zotero export
zotero_files = ['Zotero_Export.csv',
                'zotero_export.csv', 'Zotero_Collection_Export.csv']
zotero_df = None

for filename in zotero_files:
    try:
        zotero_df = pd.read_csv(filename)
        print(
            f"✅ Loaded Zotero export: {filename} with {len(zotero_df)} studies")
        break
    except FileNotFoundError:
        continue
    except Exception as e:
        print(f"❌ Error loading {filename}: {e}")
        continue

if zotero_df is None:
    print(f"\n⚠️ No Zotero export file found!")
    print(f"Expected files: {', '.join(zotero_files)}")
    print(f"\nPlease:")
    print(f"1. Export your collection from Zotero Desktop as CSV")
    print(f"2. Save as 'Zotero_Export.csv' in this folder")
    print(f"3. Re-run this script")

    # Show what we're ready to merge
    print(f"\n{'='*60}")
    print("READY FOR ZOTERO EXPORT")
    print(f"{'='*60}")
    print(f"✅ Elicit data ready: {len(elicit_df)} studies")
    print(f"✅ Matching file ready: {len(matching_df)} studies")
    print(f"⏳ Waiting for: Zotero_Export.csv")

    # Show sample search queries again
    print(f"\n{'='*60}")
    print("SEARCH THESE TITLES IN ZOTERO")
    print(f"{'='*60}")
    for i, row in matching_df.head(10).iterrows():
        print(f"{i+1:2d}. {row['Search_Query']}")
        if row['Authors_Clean']:
            print(f"    Author: {row['Authors_Clean']}")
        print()

    exit()

print(f"\n{'='*60}")
print("ANALYZING ZOTERO EXPORT")
print(f"{'='*60}")

print("Zotero columns found:")
for col in zotero_df.columns:
    print(f"  - {col}")

print(f"\nZotero data preview:")
print(zotero_df.head(3).to_string())

print(f"\n{'='*60}")
print("MATCHING ELICIT TO ZOTERO DATA")
print(f"{'='*60}")

# Prepare results
matches = []
unmatched_elicit = []
unmatched_zotero = list(range(len(zotero_df)))

# Try to match each Elicit study with Zotero
for idx, elicit_row in elicit_df.iterrows():
    elicit_title = elicit_row.get('Title', '')

    # Find best match in Zotero data
    zotero_titles = zotero_df.get(
        'Title', zotero_df.columns[0] if len(zotero_df.columns) > 0 else [])
    match_idx, score = find_best_match(elicit_title, zotero_titles)

    if match_idx is not None:
        matches.append({
            'elicit_idx': idx,
            'zotero_idx': match_idx,
            'score': score,
            'elicit_title': elicit_title[:60] + '...' if len(str(elicit_title)) > 60 else elicit_title,
            'zotero_title': str(zotero_titles.iloc[match_idx])[:60] + '...' if len(str(zotero_titles.iloc[match_idx])) > 60 else str(zotero_titles.iloc[match_idx])
        })
        if match_idx in unmatched_zotero:
            unmatched_zotero.remove(match_idx)
    else:
        unmatched_elicit.append({
            'idx': idx,
            'title': elicit_title[:80] + '...' if len(str(elicit_title)) > 80 else elicit_title
        })

print(f"Matching results:")
print(f"  ✅ Matched: {len(matches)} studies")
print(f"  ❓ Unmatched Elicit: {len(unmatched_elicit)} studies")
print(f"  ❓ Unmatched Zotero: {len(unmatched_zotero)} studies")

if len(matches) > 0:
    print(f"\nTop matches (score >= 80):")
    for match in sorted(matches, key=lambda x: x['score'], reverse=True)[:10]:
        print(f"  Score {match['score']:3d}: {match['elicit_title']}")
        print(f"           ↔ {match['zotero_title']}")

if len(unmatched_elicit) > 0:
    print(f"\nUnmatched Elicit studies (check manually):")
    for study in unmatched_elicit[:5]:
        print(f"  {study['idx']+1:2d}. {study['title']}")

print(f"\n{'='*60}")
print("CREATING MERGED DATASET")
print(f"{'='*60}")

# Create the merged dataset
merged_data = []

for idx, elicit_row in elicit_df.iterrows():
    # Start with all Elicit data
    merged_row = elicit_row.to_dict()

    # Add Zotero data if matched
    zotero_match = next((m for m in matches if m['elicit_idx'] == idx), None)

    if zotero_match:
        zotero_row = zotero_df.iloc[zotero_match['zotero_idx']]

        # Map common Zotero fields to our naming convention
        zotero_mapping = {
            'Title': 'Zotero_Title',
            'Author': 'Zotero_Authors',
            'Authors': 'Zotero_Authors',
            'Publication Title': 'Zotero_Journal',
            'Journal': 'Zotero_Journal',
            'Date': 'Zotero_Year',
            'Year': 'Zotero_Year',
            'DOI': 'Zotero_DOI',
            'URL': 'Zotero_URL',
            'Volume': 'Zotero_Volume',
            'Issue': 'Zotero_Issue',
            'Pages': 'Zotero_Pages',
            'Citations': 'Zotero_Citations',
            'Publisher': 'Zotero_Publisher'
        }

        # Add available Zotero fields
        for zotero_col in zotero_df.columns:
            if zotero_col in zotero_mapping:
                merged_row[zotero_mapping[zotero_col]] = zotero_row[zotero_col]
            else:
                merged_row[f'Zotero_{zotero_col}'] = zotero_row[zotero_col]

        merged_row['Match_Score'] = zotero_match['score']
        merged_row['Zotero_Matched'] = 'Yes'
    else:
        merged_row['Match_Score'] = 0
        merged_row['Zotero_Matched'] = 'No'

    merged_data.append(merged_row)

# Create merged DataFrame
merged_df = pd.DataFrame(merged_data)

# Save the merged dataset
output_filename = "Final_Merged_Elicit_Zotero_Dataset.csv"
merged_df.to_csv(output_filename, index=False)

print(f"✅ Created merged dataset: {output_filename}")
print(f"   Total studies: {len(merged_df)}")
print(
    f"   Zotero matched: {len([r for r in merged_data if r['Zotero_Matched'] == 'Yes'])}")

print(f"\n{'='*60}")
print("MERGED DATASET SUMMARY")
print(f"{'='*60}")

# Check data completeness
print("Field completeness (after merging):")

key_fields = ['Title', 'Authors', 'Year', 'Venue', 'DOI']
for field in key_fields:
    elicit_complete = merged_df[field].notna(
    ).sum() if field in merged_df.columns else 0
    zotero_complete = merged_df[f'Zotero_{field}'].notna(
    ).sum() if f'Zotero_{field}' in merged_df.columns else 0

    print(f"  {field:15s}: Elicit {elicit_complete:2d}/{len(merged_df)}, Zotero {zotero_complete:2d}/{len(merged_df)}")

# Show improvements
print(f"\nImprovements from Zotero:")
if 'Zotero_Journal' in merged_df.columns:
    journal_improvement = merged_df['Zotero_Journal'].notna(
    ).sum() - merged_df['Venue'].notna().sum()
    print(f"  Additional journals: +{max(0, journal_improvement)}")

if 'Zotero_DOI' in merged_df.columns:
    doi_improvement = merged_df['Zotero_DOI'].notna(
    ).sum() - merged_df['DOI'].notna().sum()
    print(f"  Additional DOIs: +{max(0, doi_improvement)}")

print(f"\n{'='*60}")
print("NEXT STEPS")
print(f"{'='*60}")

print(f"1. ✅ COMPLETED: Merged Elicit + Zotero data")
print(f"2. ✅ COMPLETED: Saved as '{output_filename}'")
print(f"3. 🔄 RECOMMENDED: Review unmatched studies manually")
print(f"4. ⏳ NEXT: Start analysis with complete dataset")

if len(unmatched_elicit) > 0:
    print(f"\n⚠️ MANUAL REVIEW NEEDED:")
    print(f"   {len(unmatched_elicit)} Elicit studies not matched")
    print(f"   Consider adding these manually to Zotero and re-running")

print(
    f"\n✅ Ready for analysis! Use '{output_filename}' as your final dataset.")
