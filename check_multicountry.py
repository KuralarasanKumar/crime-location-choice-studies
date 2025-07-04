#!/usr/bin/env python3
import pandas as pd

# Check Elicit data
print("=== ELICIT DATA ===")
elicit_df = pd.read_csv('Elicit - Extract from 49 papers - core infor.csv')
print("Elicit titles containing 'Burglar Target Selection' or 'Target Selection':")
for i, title in enumerate(elicit_df['Title']):
    if 'Target Selection' in str(title):
        print(f"{i}: {title}")

print("\n=== STANDARDIZED DATA ===")
std_df = pd.read_csv('20250703_standardized_unit_sizes_with_groups.csv')
print("Studies 20, 36, 50 in standardized data:")
for i in [19, 35, 49]:  # 0-indexed
    print(f"Study {i+1}: {std_df.iloc[i]['Title_of_the_study']}")

print("\n=== CURRENT MATCHING RESULTS ===")
current_df = pd.read_csv('20250704_comprehensive_dataset_with_elicit.csv')
print("Current matching for studies 20, 36, 50:")
for i in [19, 35, 49]:  # 0-indexed
    row = current_df.iloc[i]
    print(f"Study {i+1}: {row['Title_of_the_study'][:60]}...")
    print(f"  Matched to: {row['Elicit_Matched_Title']}")
    print(f"  Score: {row['Elicit_Match_Score']}")
    print(f"  Country: {row['Elicit_Country']}")
    print()
