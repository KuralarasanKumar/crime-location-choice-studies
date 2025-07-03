"""
Simple Merge Script for Zotero Export with Elicit Data
Works without additional libraries - uses basic string matching
"""

import pandas as pd
import numpy as np
import re

print("="*80)
print("SIMPLE ZOTERO + ELICIT MERGE")
print("="*80)


def simple_title_clean(title):
    """Simple title cleaning for matching"""
    if pd.isna(title) or title == '':
        return ''
    # Convert to lowercase, remove punctuation, normalize spaces
    clean = re.sub(r'[^\w\s]', ' ', str(title).lower())
    clean = re.sub(r'\s+', ' ', clean).strip()
    return clean


def simple_match(title1, title2, min_words=3):
    """Simple word-based matching"""
    clean1 = simple_title_clean(title1)
    clean2 = simple_title_clean(title2)

    if not clean1 or not clean2:
        return 0

    words1 = set(clean1.split())
    words2 = set(clean2.split())

    # Remove common words that don't help matching
    stop_words = {'a', 'an', 'the', 'and', 'or', 'but', 'in',
                  'on', 'at', 'to', 'for', 'of', 'with', 'by', 'from'}
    words1 = words1 - stop_words
    words2 = words2 - stop_words

    if len(words1) < min_words or len(words2) < min_words:
        return 0

    # Calculate overlap percentage
    intersection = len(words1.intersection(words2))
    union = len(words1.union(words2))

    if union == 0:
        return 0

    return (intersection / union) * 100


# Load Elicit data
try:
    elicit_df = pd.read_csv(
        "2 Elicit - Extract from 49 papers - Main infor addtion info revised info Variables core infor.csv")
    print(f"✅ Loaded Elicit data: {len(elicit_df)} studies")
except Exception as e:
    print(f"❌ Error loading Elicit file: {e}")
    exit()

# Try to load Zotero export
zotero_files = ['Zotero_Export.csv', 'zotero_export.csv',
                'Zotero_Collection_Export.csv', 'export.csv']
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
        print(f"❌ Error with {filename}: {e}")
        continue

if zotero_df is None:
    print(f"\n❌ NO ZOTERO EXPORT FOUND!")
    print(f"\nTo complete the merge:")
    print(f"1. Open Zotero Desktop")
    print(f"2. Create collection 'Crime Location Choice Studies'")
    print(f"3. Add papers using titles from Zotero_Matching_Data.csv")
    print(f"4. Export collection as CSV")
    print(f"5. Save as 'Zotero_Export.csv' in this folder")
    print(f"6. Re-run this script")

    print(f"\n📋 USE THESE SEARCH QUERIES IN ZOTERO:")
    print(f"="*50)

    # Load matching data to show search queries
    try:
        matching_df = pd.read_csv("Zotero_Matching_Data.csv")
        for i, row in matching_df.head(15).iterrows():
            print(f"{i+1:2d}. {row['Search_Query']}")
            if pd.notna(row['Authors_Clean']) and row['Authors_Clean']:
                print(f"    👤 {row['Authors_Clean']}")
            print()
    except Exception as e:
        print(f"Error loading matching data: {e}")

    exit()

print(f"\n{'='*60}")
print("ANALYZING ZOTERO EXPORT")
print(f"{'='*60}")

print("Available Zotero columns:")
for i, col in enumerate(zotero_df.columns):
    print(f"  {i+1:2d}. {col}")

# Identify title column in Zotero export
title_col = None
for col in ['Title', 'title', 'Publication Title', 'Item Title']:
    if col in zotero_df.columns:
        title_col = col
        break

if title_col is None:
    print(f"\n⚠️ Cannot find title column in Zotero export!")
    print(f"Available columns: {list(zotero_df.columns)}")
    print(f"Please rename the title column to 'Title' and re-run")
    exit()

print(f"\n✅ Using '{title_col}' as title column")

print(f"\n{'='*60}")
print("MATCHING STUDIES")
print(f"{'='*60}")

# Match studies
matches = []
match_threshold = 30  # Lower threshold for simple matching

for elicit_idx, elicit_row in elicit_df.iterrows():
    elicit_title = elicit_row.get('Title', '')

    best_match_idx = None
    best_score = 0

    for zotero_idx, zotero_row in zotero_df.iterrows():
        zotero_title = zotero_row.get(title_col, '')

        score = simple_match(elicit_title, zotero_title)

        if score > best_score and score >= match_threshold:
            best_score = score
            best_match_idx = zotero_idx

    if best_match_idx is not None:
        matches.append({
            'elicit_idx': elicit_idx,
            'zotero_idx': best_match_idx,
            'score': best_score
        })

print(f"Matching results:")
print(
    f"  ✅ Matched: {len(matches)}/{len(elicit_df)} studies ({len(matches)/len(elicit_df)*100:.1f}%)")
print(f"  ❓ Unmatched: {len(elicit_df) - len(matches)} studies")

print(f"\nTop 10 matches:")
for i, match in enumerate(sorted(matches, key=lambda x: x['score'], reverse=True)[:10]):
    elicit_title = elicit_df.iloc[match['elicit_idx']]['Title']
    zotero_title = zotero_df.iloc[match['zotero_idx']][title_col]
    print(f"{i+1:2d}. Score {match['score']:5.1f}%")
    print(f"    Elicit: {str(elicit_title)[:60]}...")
    print(f"    Zotero: {str(zotero_title)[:60]}...")

print(f"\n{'='*60}")
print("CREATING MERGED DATASET")
print(f"{'='*60}")

# Create merged dataset
merged_data = []

for elicit_idx, elicit_row in elicit_df.iterrows():
    # Start with Elicit data
    merged_row = elicit_row.to_dict()

    # Add Zotero data if matched
    match = next((m for m in matches if m['elicit_idx'] == elicit_idx), None)

    if match:
        zotero_row = zotero_df.iloc[match['zotero_idx']]

        # Add all Zotero columns with prefix
        for col in zotero_df.columns:
            merged_row[f'Zotero_{col}'] = zotero_row[col]

        merged_row['Zotero_Match_Score'] = match['score']
        merged_row['Zotero_Matched'] = 'Yes'
    else:
        merged_row['Zotero_Match_Score'] = 0
        merged_row['Zotero_Matched'] = 'No'

    merged_data.append(merged_row)

# Save merged dataset
merged_df = pd.DataFrame(merged_data)
output_file = "Merged_Elicit_Zotero_Dataset.csv"
merged_df.to_csv(output_file, index=False)

print(f"✅ Created: {output_file}")
print(f"   Total studies: {len(merged_df)}")
print(f"   Matched with Zotero: {len(matches)}")

print(f"\n{'='*60}")
print("DATA IMPROVEMENTS")
print(f"{'='*60}")

# Check what new info we got from Zotero
zotero_columns = [col for col in merged_df.columns if col.startswith(
    'Zotero_') and col not in ['Zotero_Match_Score', 'Zotero_Matched']]

print(f"New fields from Zotero ({len(zotero_columns)} total):")
for col in sorted(zotero_columns)[:10]:  # Show first 10
    non_empty = merged_df[col].notna().sum()
    print(f"  {col:30s}: {non_empty:2d}/{len(matches)} matched studies")

if len(zotero_columns) > 10:
    print(f"  ... and {len(zotero_columns)-10} more fields")

# Check specific improvements
if 'Zotero_Title' in merged_df.columns:
    title_verification = (merged_df['Zotero_Matched'] == 'Yes').sum()
    print(f"\n📊 Quality checks:")
    print(f"  Title verification: {title_verification} studies")

journal_fields = [col for col in zotero_columns if 'journal' in col.lower(
) or 'publication' in col.lower()]
if journal_fields:
    for field in journal_fields[:3]:
        journal_count = merged_df[field].notna().sum()
        print(f"  Journal info ({field}): {journal_count} studies")

print(f"\n{'='*60}")
print("UNMATCHED STUDIES")
print(f"{'='*60}")

unmatched_indices = [i for i in range(len(elicit_df)) if not any(
    m['elicit_idx'] == i for m in matches)]

if len(unmatched_indices) > 0:
    print(f"⚠️ {len(unmatched_indices)} studies not matched with Zotero:")
    for i, idx in enumerate(unmatched_indices[:10]):
        title = elicit_df.iloc[idx]['Title']
        print(f"  {i+1:2d}. {str(title)[:70]}...")

    if len(unmatched_indices) > 10:
        print(f"  ... and {len(unmatched_indices)-10} more")

    print(f"\n💡 To improve matching:")
    print(f"  1. Manually add these papers to Zotero")
    print(f"  2. Check for title variations in Zotero")
    print(f"  3. Re-export and re-run this script")

print(f"\n{'='*60}")
print("SUCCESS! READY FOR ANALYSIS")
print(f"{'='*60}")

print(f"✅ Final dataset: {output_file}")
print(f"✅ {len(elicit_df)} total studies")
print(f"✅ {len(matches)} studies with Zotero data ({len(matches)/len(elicit_df)*100:.1f}%)")
print(f"✅ {len(zotero_columns)} additional data fields from Zotero")

print(f"\n🔄 Next steps:")
print(f"1. Review {output_file} for data quality")
print(f"2. Begin statistical analysis of research questions")
print(f"3. Standardize SUoA sizes and country names")
print(f"4. Create visualizations and summary reports")

print(f"\n🎉 Integration complete!")
