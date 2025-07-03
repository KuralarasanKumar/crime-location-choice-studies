"""
Prepare Data for Zotero Integration
Creates files to help merge Zotero journal/citation data with Elicit extraction
"""

import pandas as pd
import re
import numpy as np

print("="*80)
print("PREPARING DATA FOR ZOTERO INTEGRATION")
print("="*80)

# Load the comprehensive Elicit extraction
try:
    df = pd.read_csv(
        "2 Elicit - Extract from 49 papers - Main infor addtion info revised info Variables core infor.csv")
    print(f"✅ Loaded Elicit extraction: {len(df)} studies")
except Exception as e:
    print(f"❌ Error loading file: {e}")
    exit()

print(f"\n{'='*60}")
print("CURRENT CITATION INFORMATION")
print(f"{'='*60}")

# Check what citation info is already available
print("Current fields related to publication:")
pub_fields = ['Title', 'Authors', 'DOI',
              'DOI link', 'Venue', 'Citation count', 'Year']
for field in pub_fields:
    if field in df.columns:
        non_empty = df[field].notna().sum()
        print(
            f"  {field:15s}: {non_empty:2d}/{len(df)} ({non_empty/len(df)*100:5.1f}%)")

print(f"\n{'='*60}")
print("CREATING ZOTERO MATCHING FILE")
print(f"{'='*60}")

# Create a clean dataset for Zotero matching
zotero_matching_data = []

for idx, row in df.iterrows():
    # Helper function to safely get and strip values
    def safe_get(field, default=''):
        val = row.get(field, default)
        if pd.isna(val) or val is None:
            return ''
        return str(val).strip()

    study_data = {
        'Study_ID': idx + 1,
        'Title': safe_get('Title'),
        'Authors': safe_get('Authors'),
        'Year': safe_get('Year'),
        'Filename': safe_get('Filename'),
        'Current_DOI': safe_get('DOI'),
        'Current_Venue': safe_get('Venue'),
        'Current_Citation_Count': safe_get('Citation count'),
        'Title_for_Search': '',  # Clean title for Zotero search
        'Authors_Clean': '',     # Clean authors for matching
        'Search_Query': ''       # Suggested search query for Zotero
    }

    # Clean title for better Zotero matching
    title = study_data['Title']
    if title:
        # Remove special characters and normalize
        clean_title = re.sub(r'[^\w\s]', ' ', title)
        clean_title = re.sub(r'\s+', ' ', clean_title).strip()
        study_data['Title_for_Search'] = clean_title

        # Create search query (first 8-10 words of title)
        title_words = clean_title.split()[:8]
        study_data['Search_Query'] = ' '.join(title_words)

    # Clean authors
    authors = study_data['Authors']
    if authors:
        # Extract first author surname for matching
        first_author = authors.split(',')[0].strip(
        ) if ',' in authors else authors.split(';')[0].strip()
        study_data['Authors_Clean'] = first_author

    zotero_matching_data.append(study_data)

df_zotero = pd.DataFrame(zotero_matching_data)

# Save the Zotero matching file
df_zotero.to_csv("Zotero_Matching_Data.csv", index=False)
print(f"✅ Created Zotero_Matching_Data.csv with {len(df_zotero)} studies")

print(f"\n{'='*60}")
print("ZOTERO INTEGRATION INSTRUCTIONS")
print(f"{'='*60}")

print("""
STEP 1: EXPORT FROM ZOTERO DESKTOP
----------------------------------
1. Open Zotero Desktop on your device
2. Create a new collection called "Crime Location Choice Studies"
3. For each study in the Zotero_Matching_Data.csv file:
   a) Search using the 'Search_Query' column
   b) Look for matches using Title and first author
   c) Add the paper to your collection
4. Select all papers in the collection
5. Right-click → Export Collection
6. Choose format: "CSV" or "Tab Delimited"
7. Include fields: Title, Authors, Journal, Year, DOI, Volume, Issue, Pages, Citations
8. Save as "Zotero_Export.csv"

STEP 2: ALTERNATIVE - BATCH SEARCH
----------------------------------
If manual search is too time-consuming:
1. Copy titles from 'Title_for_Search' column
2. Use Zotero's "Add by Identifier" with DOIs if available
3. Or use Google Scholar to find DOIs, then import to Zotero
4. Export the collection as above

STEP 3: MERGE WITH ELICIT DATA
----------------------------------
1. Place the Zotero_Export.csv file in this folder
2. Run the merge script (I'll create this next)
3. Get complete dataset with journal info and citations
""")

print(f"\n{'='*60}")
print("SAMPLE SEARCH QUERIES FOR ZOTERO")
print(f"{'='*60}")

print("Here are sample search queries for the first 10 studies:")
for i, row in df_zotero.head(10).iterrows():
    print(f"{i+1:2d}. {row['Search_Query']}")
    if row['Authors_Clean']:
        print(f"    Author: {row['Authors_Clean']}")
    print()

print(f"\n{'='*60}")
print("MISSING INFORMATION TO GET FROM ZOTERO")
print(f"{'='*60}")

# Identify what's missing that Zotero can provide
missing_doi = len(df_zotero[df_zotero['Current_DOI'].isin(
    ['', '-', 'nan']) | df_zotero['Current_DOI'].isna()])
missing_venue = len(df_zotero[df_zotero['Current_Venue'].isin(
    ['', '-', 'nan']) | df_zotero['Current_Venue'].isna()])
missing_citations = len(df_zotero[df_zotero['Current_Citation_Count'].isin(
    ['', '-', 'nan']) | df_zotero['Current_Citation_Count'].isna()])

print(f"Studies needing journal information:")
print(f"  Missing DOI: {missing_doi}/{len(df_zotero)} studies")
print(f"  Missing Venue/Journal: {missing_venue}/{len(df_zotero)} studies")
print(
    f"  Missing Citation counts: {missing_citations}/{len(df_zotero)} studies")

print(f"\nZotero can provide:")
print(f"  ✅ Journal names and venues")
print(f"  ✅ DOI links for verification")
print(f"  ✅ Volume, Issue, Page numbers")
print(f"  ✅ Complete author lists")
print(f"  ✅ Publication years (verification)")
print(f"  ⚠️ Citation counts (may need Google Scholar for current counts)")

print(f"\n{'='*60}")
print("NEXT STEPS")
print(f"{'='*60}")

print("1. ✅ COMPLETED: Created Zotero_Matching_Data.csv")
print("2. 🔄 IN PROGRESS: Use Zotero Desktop to find and export papers")
print("3. ⏳ PENDING: Run merge script to combine Zotero + Elicit data")
print("4. ⏳ PENDING: Create final comprehensive dataset")

print(f"\n💡 TIP: If you have the PDFs in Zotero already, you can:")
print(f"   - Drag PDFs into Zotero to auto-extract metadata")
print(f"   - Use 'Retrieve Metadata for PDF' right-click option")
print(f"   - This will automatically get journal info and DOIs")

print(f"\n✅ Ready for Zotero export! Check Zotero_Matching_Data.csv file.")
