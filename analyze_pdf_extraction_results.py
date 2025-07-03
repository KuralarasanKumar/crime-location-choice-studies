"""
Analysis of PDF-Extracted Methodological Information
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Load the extracted data
df_extracted = pd.read_csv("PDF_Extracted_Methodological_Info.csv")
df_merged = pd.read_csv("20250703_dataset_with_PDF_extraction.csv")

print("="*60)
print("PDF EXTRACTION RESULTS ANALYSIS")
print("="*60)

print(f"Total PDFs processed: {len(df_extracted)}")
print(
    f"Average text length per PDF: {df_extracted['Text_Length'].mean():,.0f} characters")

# Analyze extraction success rates
extraction_success = {}
for col in ['Statistical_Method', 'Alternative_Sampling', 'Number_of_Variables',
            'Sample_Size_Occasions', 'Scale_Justification_Provided', 'Software_Used']:

    if col in df_extracted.columns:
        total = len(df_extracted)

        if col in ['Number_of_Variables', 'Sample_Size_Occasions']:
            # Numeric columns
            success = df_extracted[col].notna().sum()
        else:
            # Text columns - exclude "Not Clear" and "Not Reported"
            success = df_extracted[
                (df_extracted[col].notna()) &
                (~df_extracted[col].isin(
                    ['Not Clear', 'Not Reported', 'Not Specified']))
            ].shape[0]

        extraction_success[col] = (success, total, success/total*100)

print(f"\nExtraction Success Rates:")
for col, (success, total, pct) in extraction_success.items():
    print(f"  {col}: {success}/{total} ({pct:.1f}%)")

# Analyze statistical methods
print(f"\nStatistical Methods Identified:")
methods = []
for method_list in df_extracted['Statistical_Method'].dropna():
    if method_list != 'Not Clear':
        methods.extend([m.strip() for m in method_list.split(',')])

method_counts = pd.Series(methods).value_counts()
for method, count in method_counts.head().items():
    print(f"  {method}: {count} studies")

# Analyze alternative sampling
print(f"\nAlternative Sampling Strategies:")
sampling_counts = df_extracted['Alternative_Sampling'].value_counts()
for strategy, count in sampling_counts.items():
    if strategy not in ['Not Clear']:
        print(f"  {strategy}: {count} studies")

# Analyze software usage
print(f"\nSoftware Usage:")
software_list = []
for software_entry in df_extracted['Software_Used'].dropna():
    if software_entry != 'Not Specified':
        software_list.extend([s.strip() for s in software_entry.split(',')])

software_counts = pd.Series(software_list).value_counts()
for software, count in software_counts.items():
    print(f"  {software}: {count} studies")

# Analyze variable counts
print(f"\nVariable Counts (where extracted):")
var_counts = df_extracted['Number_of_Variables'].dropna()
if len(var_counts) > 0:
    print(
        f"  Range: {var_counts.min():.0f} - {var_counts.max():.0f} variables")
    print(f"  Mean: {var_counts.mean():.1f} variables")
    print(f"  Studies with counts: {len(var_counts)}")

# Merge with original data for enhanced analysis
print(f"\n" + "="*60)
print("ENHANCED ANALYSIS WITH PDF DATA")
print("="*60)

# Check relationship between SUoA size and methods
df_merged['Primary_Statistical_Method'] = df_merged['Statistical_Method'].str.split(
    ',').str[0]

# Group by unit size categories
size_methods = df_merged.groupby(
    ['Size_group', 'Primary_Statistical_Method']).size().unstack(fill_value=0)
print(f"\nStatistical Methods by Unit Size:")
print(size_methods)

# Check sampling vs choice set size relationship
df_merged['Uses_Sampling'] = df_merged['Alternative_Sampling'].isin(
    ['Importance Sampling', 'Random Sampling', 'Stratified Sampling'])
df_merged['Large_Choice_Set'] = df_merged['No_of_units'] > 1000

sampling_analysis = df_merged.groupby(
    ['Large_Choice_Set', 'Uses_Sampling']).size().unstack(fill_value=0)
print(f"\nSampling Strategy vs Choice Set Size:")
print(sampling_analysis)

# Create visualization
fig, axes = plt.subplots(2, 2, figsize=(15, 10))

# Statistical methods distribution
clean_methods = df_extracted[df_extracted['Statistical_Method']
                             != 'Not Clear']['Statistical_Method']
method_counts_clean = pd.Series(
    [m.split(',')[0].strip() for m in clean_methods]).value_counts()

axes[0, 0].pie(method_counts_clean.values,
               labels=method_counts_clean.index, autopct='%1.1f%%')
axes[0, 0].set_title('Primary Statistical Methods\n(Auto-extracted from PDFs)')

# Alternative sampling distribution
sampling_clean = df_extracted[~df_extracted['Alternative_Sampling'].isin(
    ['Not Clear'])]['Alternative_Sampling']
sampling_counts_clean = sampling_clean.value_counts()

axes[0, 1].bar(range(len(sampling_counts_clean)), sampling_counts_clean.values)
axes[0, 1].set_xticks(range(len(sampling_counts_clean)))
axes[0, 1].set_xticklabels(sampling_counts_clean.index, rotation=45)
axes[0, 1].set_title('Alternative Sampling Strategies')
axes[0, 1].set_ylabel('Number of Studies')

# Software usage
axes[1, 0].bar(range(len(software_counts)), software_counts.values)
axes[1, 0].set_xticks(range(len(software_counts)))
axes[1, 0].set_xticklabels(software_counts.index, rotation=45)
axes[1, 0].set_title('Software Usage')
axes[1, 0].set_ylabel('Number of Studies')

# Extraction success rates
success_data = [v[2] for v in extraction_success.values()]
success_labels = list(extraction_success.keys())

axes[1, 1].bar(range(len(success_data)), success_data)
axes[1, 1].set_xticks(range(len(success_data)))
axes[1, 1].set_xticklabels([label.replace('_', '\n')
                           for label in success_labels], rotation=45)
axes[1, 1].set_title('PDF Extraction Success Rates')
axes[1, 1].set_ylabel('Success Percentage')
axes[1, 1].set_ylim(0, 100)

plt.tight_layout()
plt.savefig('PDF_extraction_analysis_results.png',
            dpi=300, bbox_inches='tight')
plt.show()

# Identify studies needing manual verification
print(f"\n" + "="*60)
print("STUDIES NEEDING MANUAL VERIFICATION")
print("="*60)

unclear_methods = df_extracted[df_extracted['Statistical_Method'] == 'Not Clear']
unclear_sampling = df_extracted[df_extracted['Alternative_Sampling'] == 'Not Clear']
missing_variables = df_extracted[df_extracted['Number_of_Variables'].isna()]

print(f"Studies with unclear statistical methods: {len(unclear_methods)}")
if len(unclear_methods) > 0:
    print("  Study IDs:", unclear_methods['Study_ID'].tolist())

print(f"Studies with unclear sampling strategies: {len(unclear_sampling)}")
if len(unclear_sampling) > 0:
    print("  Study IDs:", unclear_sampling['Study_ID'].tolist())

print(f"Studies missing variable counts: {len(missing_variables)}")

# Summary for Priority 1 columns
print(f"\n" + "="*60)
print("PRIORITY 1 ANALYSIS READINESS")
print("="*60)

priority1_complete = df_extracted[
    (df_extracted['Statistical_Method'] != 'Not Clear') &
    (df_extracted['Alternative_Sampling'] != 'Not Clear') &
    (df_extracted['Number_of_Variables'].notna())
]

print(
    f"Studies with all Priority 1 info extracted: {len(priority1_complete)}/{len(df_extracted)} ({len(priority1_complete)/len(df_extracted)*100:.1f}%)")
print(
    f"Ready for Questions 5-6 analysis: {'Yes' if len(priority1_complete) >= 30 else 'Partially'}")

if len(priority1_complete) >= 30:
    print("✅ Sufficient data for robust analysis of research questions 5-6!")
else:
    print("⚠️  May need some manual verification for complete analysis")

print(f"\nFiles created:")
print(f"- PDF_Extracted_Methodological_Info.csv: Raw extraction results")
print(f"- 20250703_dataset_with_PDF_extraction.csv: Merged with original data")
print(f"- PDF_extraction_analysis_results.png: Visualization of results")
