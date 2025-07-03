"""
Basic PDF Information Extraction for SUoA Studies
Simplified version using built-in libraries first, then we'll add PDF extraction
"""

import os
import pandas as pd
import re
from pathlib import Path


def analyze_pdf_filenames_and_create_mapping():
    """Create mapping between PDF files and Study IDs"""

    # Load the current dataset
    try:
        df_current = pd.read_csv(
            "20250703_enhanced_dataset_with_auto_extraction.csv")
    except FileNotFoundError:
        print("Enhanced dataset not found. Please run the R script first.")
        return None

    # Directory containing PDFs
    pdf_dir = Path("Review_articles")

    # Get list of PDF files
    pdf_files = list(pdf_dir.glob("*.pdf"))
    pdf_files.sort()

    print(f"Found {len(pdf_files)} PDF files")
    print(f"Have data for {len(df_current)} studies")

    # Create mapping
    pdf_mapping = []

    for pdf_file in pdf_files:
        filename = pdf_file.stem
        study_match = re.search(r'^(\d+)', filename)

        if study_match:
            study_id = int(study_match.group(1))

            # Check if this study exists in our dataset
            if study_id in df_current['Study_ID'].values:
                study_info = df_current[df_current['Study_ID']
                                        == study_id].iloc[0]

                pdf_mapping.append({
                    'Study_ID': study_id,
                    'PDF_File': str(pdf_file),
                    'PDF_Name': pdf_file.name,
                    'Title': study_info['Title_of_the_study'],
                    'Citation': study_info['Citation'],
                    'File_Size_MB': pdf_file.stat().st_size / (1024*1024),
                    'Status': 'Ready for extraction'
                })
            else:
                pdf_mapping.append({
                    'Study_ID': study_id,
                    'PDF_File': str(pdf_file),
                    'PDF_Name': pdf_file.name,
                    'Title': 'NOT IN DATASET',
                    'Citation': 'NOT IN DATASET',
                    'File_Size_MB': pdf_file.stat().st_size / (1024*1024),
                    'Status': 'Study ID not found'
                })
        else:
            pdf_mapping.append({
                'Study_ID': None,
                'PDF_File': str(pdf_file),
                'PDF_Name': pdf_file.name,
                'Title': 'COULD NOT PARSE',
                'Citation': 'COULD NOT PARSE',
                'File_Size_MB': pdf_file.stat().st_size / (1024*1024),
                'Status': 'Could not extract Study ID'
            })

    df_mapping = pd.DataFrame(pdf_mapping)
    df_mapping.to_csv("PDF_Study_Mapping.csv", index=False)

    # Print summary
    print(f"\n" + "="*60)
    print("PDF-STUDY MAPPING ANALYSIS")
    print("="*60)

    status_counts = df_mapping['Status'].value_counts()
    print("Mapping status:")
    for status, count in status_counts.items():
        print(f"  {status}: {count}")

    print(
        f"\nReady for extraction: {len(df_mapping[df_mapping['Status'] == 'Ready for extraction'])}")
    print(f"Total file size: {df_mapping['File_Size_MB'].sum():.1f} MB")

    # Show sample of successful mappings
    ready_files = df_mapping[df_mapping['Status'] == 'Ready for extraction']
    if len(ready_files) > 0:
        print(f"\nSample of ready files:")
        sample_cols = ['Study_ID', 'PDF_Name', 'Citation']
        print(ready_files[sample_cols].head())

        # Check for missing Study IDs in PDFs
        missing_studies = []
        for study_id in df_current['Study_ID']:
            if study_id not in ready_files['Study_ID'].values:
                study_info = df_current[df_current['Study_ID']
                                        == study_id].iloc[0]
                missing_studies.append({
                    'Study_ID': study_id,
                    'Citation': study_info['Citation'],
                    'Title': study_info['Title_of_the_study'][:50] + "..."
                })

        if missing_studies:
            print(
                f"\nStudies without corresponding PDFs ({len(missing_studies)}):")
            for study in missing_studies[:5]:  # Show first 5
                print(f"  Study {study['Study_ID']}: {study['Citation']}")
            if len(missing_studies) > 5:
                print(f"  ... and {len(missing_studies) - 5} more")

    return df_mapping


def create_manual_extraction_template():
    """Create a template for manual extraction if PDF extraction fails"""

    # Load mapping
    try:
        df_mapping = pd.read_csv("PDF_Study_Mapping.csv")
    except FileNotFoundError:
        print("Run the mapping analysis first")
        return

    # Get studies ready for extraction
    ready_studies = df_mapping[df_mapping['Status'] == 'Ready for extraction']

    # Create manual template
    template_data = []
    for _, row in ready_studies.iterrows():
        template_data.append({
            'Study_ID': row['Study_ID'],
            'PDF_File': row['PDF_Name'],
            'Citation': row['Citation'],
            'Title': row['Title'][:60] + "..." if len(row['Title']) > 60 else row['Title'],

            # Priority 1 columns for manual extraction
            # Multinomial Logit/Mixed Logit/Latent Class/Nested Logit/Other
            'Statistical_Method': '',
            'Alternative_Sampling': '',  # None/Random/Stratified/Importance/Other
            'Number_of_Variables': '',  # Count
            'Sample_Size_Occasions': '',  # Count
            'Scale_Justification_Provided': '',  # Yes/No/Partial

            # Priority 2 columns
            'Software_Used': '',  # R/Stata/Python/Biogeme/Other
            'Convergence_Issues': '',  # Yes/No/Not Reported
            'Choice_Set_Strategy': '',  # Full/Sampled/Nested/Other

            # Notes
            'Extraction_Notes': '',
            'Pages_Checked': '',  # e.g., "Methods: p.5-7, Results: p.8-12"
            'Extraction_Date': '',
            'Extracted_By': ''
        })

    df_template = pd.DataFrame(template_data)
    df_template.to_csv("Manual_PDF_Extraction_Template.csv", index=False)

    print(
        f"Created manual extraction template with {len(df_template)} studies")
    print("File: Manual_PDF_Extraction_Template.csv")

    return df_template


def create_extraction_instructions():
    """Create detailed instructions for manual extraction"""

    instructions = """
# PDF Extraction Instructions for SUoA Methodological Review

## Overview
For each PDF, extract information about the discrete choice methodology used.
Focus on the Methods section, but also check Results and Data sections.

## Priority 1 Columns (Essential)

### 1. Statistical_Method
**What to look for:** Type of discrete choice model used
**Common terms:**
- "Multinomial Logit" → Enter: Multinomial Logit
- "Conditional Logit" → Enter: Multinomial Logit  
- "Mixed Logit", "Random Parameters Logit" → Enter: Mixed Logit
- "Latent Class", "Finite Mixture" → Enter: Latent Class
- "Nested Logit" → Enter: Nested Logit
- Other models → Enter: Other

### 2. Alternative_Sampling  
**What to look for:** How they handled the choice set
**Common terms:**
- "Full choice set", "All alternatives" → Enter: None
- "Random sample", "Randomly sampled alternatives" → Enter: Random
- "Stratified sample" → Enter: Stratified  
- "Importance sampling" → Enter: Importance
- If choice set >1000 units but no mention → Enter: Likely Sampled

### 3. Number_of_Variables
**What to look for:** Count of independent variables (covariates)
**Where to find:** Methods section, results tables
**Note:** Count unique variables, not coefficients (dummy variables count as 1)

### 4. Sample_Size_Occasions
**What to look for:** Number of choice occasions/observations  
**Common terms:** "observations", "choice occasions", "incidents"
**Note:** This is usually the number of crimes/events, not spatial units

### 5. Scale_Justification_Provided
**What to look for:** Explanation of why they chose their spatial unit
**Look for:** Discussion of "spatial unit", "unit of analysis", "scale"
- Explicit justification → Enter: Yes
- Brief mention without justification → Enter: Partial
- No discussion → Enter: No

## Priority 2 Columns (Important)

### 6. Software_Used
**Look for:** R, Stata, Python, Biogeme, SAS, SPSS
**Common phrases:** "estimated using", "analysis conducted in"

### 7. Convergence_Issues  
**Look for:** Mentions of convergence problems or success
- Problems mentioned → Enter: Yes
- Successful convergence mentioned → Enter: No
- No mention → Enter: Not Reported

### 8. Choice_Set_Strategy
**Look for:** How they structured the choice alternatives
- All units included → Enter: Full
- Subset of alternatives → Enter: Sampled
- Hierarchical structure → Enter: Nested

## Where to Look in Each Paper

1. **Abstract:** Quick overview of method
2. **Methods section:** Primary source for all information
3. **Data section:** Sample sizes, variable counts
4. **Results section:** Software, convergence, model fit
5. **Tables:** Variable lists, sample statistics

## Quality Control

- **Double-check numbers:** Ensure variable counts are reasonable (3-50)
- **Cross-reference:** Verify sample sizes match across sections
- **Note uncertainties:** Use Extraction_Notes for unclear cases
- **Record pages:** Note which pages you checked

## Time Estimate
- Experienced coder: 5-10 minutes per paper
- New coder: 10-15 minutes per paper  
- Total for 50 papers: 8-12 hours

## Common Challenges

1. **Multiple models:** If paper tests multiple models, record the main/final model
2. **Unclear methods:** Note in Extraction_Notes and mark as "Not Clear"
3. **Missing information:** Leave blank rather than guess
4. **Technical terms:** When in doubt, copy exact phrase to Notes

## Files to Use
- **Manual_PDF_Extraction_Template.csv:** Main data entry file
- **Coding_Guide_Streamlined.csv:** Standardized values reference
- **PDF_Study_Mapping.csv:** Study ID to PDF mapping
"""

    with open("PDF_Extraction_Instructions.md", "w", encoding='utf-8') as f:
        f.write(instructions)

    print("Created extraction instructions: PDF_Extraction_Instructions.md")


def main():
    """Main function"""
    print("="*60)
    print("PDF ANALYSIS AND EXTRACTION SETUP")
    print("="*60)

    # Step 1: Analyze PDF files and create mapping
    df_mapping = analyze_pdf_filenames_and_create_mapping()

    if df_mapping is not None:
        # Step 2: Create manual extraction template
        create_manual_extraction_template()

        # Step 3: Create extraction instructions
        create_extraction_instructions()

        print(f"\n" + "="*60)
        print("NEXT STEPS")
        print("="*60)
        print("1. ✅ PDF mapping complete - check PDF_Study_Mapping.csv")
        print("2. ✅ Manual template created - use Manual_PDF_Extraction_Template.csv")
        print("3. ✅ Instructions created - read PDF_Extraction_Instructions.md")
        print("\n4. 📄 START EXTRACTION:")
        print("   - Open Manual_PDF_Extraction_Template.csv")
        print("   - For each study, open the corresponding PDF")
        print("   - Extract methodological information")
        print("   - Focus on Priority 1 columns first")
        print("\n5. 🔍 PILOT APPROACH:")
        print("   - Start with 5-10 studies to test the process")
        print("   - Refine extraction guidelines if needed")
        print("   - Then scale up to all studies")


if __name__ == "__main__":
    main()
