"""
PDF Information Extraction for SUoA Studies
Automatically extracts methodological information from the Review_articles PDFs
"""

import os
import pandas as pd
import PyPDF2
import pdfplumber
import re
from pathlib import Path
import warnings
warnings.filterwarnings('ignore')


def extract_text_from_pdf(pdf_path):
    """Extract text from PDF using multiple methods for robustness"""
    text = ""

    # Try pdfplumber first (better for complex layouts)
    try:
        with pdfplumber.open(pdf_path) as pdf:
            for page in pdf.pages:
                page_text = page.extract_text()
                if page_text:
                    text += page_text + "\n"
    except Exception as e:
        print(f"pdfplumber failed for {pdf_path}: {e}")

        # Fallback to PyPDF2
        try:
            with open(pdf_path, 'rb') as file:
                pdf_reader = PyPDF2.PdfReader(file)
                for page in pdf_reader.pages:
                    text += page.extract_text() + "\n"
        except Exception as e2:
            print(f"PyPDF2 also failed for {pdf_path}: {e2}")
            return ""

    return text.lower()  # Convert to lowercase for easier pattern matching


def extract_statistical_method(text):
    """Extract the statistical method used"""
    methods = {
        'multinomial logit': ['multinomial logit', 'conditional logit', 'mcfadden'],
        'mixed logit': ['mixed logit', 'random parameter', 'random coefficient', 'random effects logit'],
        'latent class': ['latent class', 'finite mixture', 'discrete mixture'],
        'nested logit': ['nested logit', 'hierarchical logit'],
        'other': ['probit', 'ordered logit', 'binary logit']
    }

    detected_methods = []
    for method_type, patterns in methods.items():
        for pattern in patterns:
            if re.search(pattern, text):
                detected_methods.append(method_type)
                break

    if len(detected_methods) == 0:
        return "Not Clear"
    elif len(detected_methods) == 1:
        return detected_methods[0].title()
    else:
        return ", ".join([m.title() for m in detected_methods])


def extract_alternative_sampling(text):
    """Extract information about alternative sampling strategies"""
    sampling_patterns = {
        'importance sampling': ['importance sampling'],
        'random sampling': ['random sampling', 'randomly sampled', 'random subset', 'random sample of alternatives'],
        'stratified sampling': ['stratified sampling', 'stratified sample'],
        'none': ['full choice set', 'complete choice set', 'all alternatives', 'entire choice set']
    }

    for sampling_type, patterns in sampling_patterns.items():
        for pattern in patterns:
            if re.search(pattern, text):
                return sampling_type.title()

    # Check for large choice sets which might imply sampling
    choice_set_mentions = re.findall(
        r'(\d+,?\d*)\s*(?:alternatives|choices|options|units)', text)
    if choice_set_mentions:
        numbers = [int(re.sub(',', '', match))
                   for match in choice_set_mentions]
        max_choice_set = max(numbers) if numbers else 0
        if max_choice_set > 1000:
            return "Likely Sampled"

    return "Not Clear"


def extract_number_of_variables(text):
    """Extract the number of independent variables"""
    # Look for explicit mentions
    variable_patterns = [
        r'(\d+)\s*(?:independent\s*)?variables',
        r'(\d+)\s*(?:explanatory|predictor)\s*variables',
        r'(\d+)\s*covariates',
        r'table\s*\d+.*?(\d+)\s*variables'
    ]

    numbers = []
    for pattern in variable_patterns:
        matches = re.findall(pattern, text)
        if matches:
            numbers.extend([int(match)
                           for match in matches if match.isdigit()])

    if numbers:
        # Return the most common number or the largest reasonable number
        reasonable_numbers = [n for n in numbers if 3 <=
                              n <= 50]  # Reasonable range
        if reasonable_numbers:
            return max(set(reasonable_numbers), key=reasonable_numbers.count)

    return None


def extract_software_used(text):
    """Extract the software used for analysis"""
    software_patterns = {
        'R': [r'\br\b', 'r software', 'r statistical', 'cran'],
        'Stata': ['stata'],
        'Python': ['python', 'biogeme'],
        'SAS': ['sas'],
        'SPSS': ['spss'],
        'Biogeme': ['biogeme']
    }

    detected_software = []
    for software, patterns in software_patterns.items():
        for pattern in patterns:
            if re.search(pattern, text):
                detected_software.append(software)
                break

    if detected_software:
        return ", ".join(detected_software)
    return "Not Specified"


def extract_sample_size_occasions(text):
    """Extract the number of choice occasions/observations"""
    patterns = [
        r'(\d+,?\d*)\s*(?:choice\s*)?occasions',
        r'(\d+,?\d*)\s*observations',
        r'(\d+,?\d*)\s*(?:choice\s*)?sets',
        r'(\d+,?\d*)\s*incidents?'
    ]

    numbers = []
    for pattern in patterns:
        matches = re.findall(pattern, text)
        if matches:
            numbers.extend([int(re.sub(',', '', match))
                           for match in matches if re.sub(',', '', match).isdigit()])

    if numbers:
        # Filter for reasonable sample sizes
        reasonable_numbers = [n for n in numbers if 50 <= n <= 100000]
        if reasonable_numbers:
            return max(reasonable_numbers)  # Usually the total sample size

    return None


def extract_scale_justification(text):
    """Check if scale choice is justified"""
    justification_patterns = [
        'spatial unit',
        'unit of analysis',
        'scale of analysis',
        'choice of unit',
        'unit selection',
        'spatial scale',
        'aggregation level'
    ]

    justification_found = False
    for pattern in justification_patterns:
        if re.search(pattern, text):
            # Look for justification within 100 characters
            context_pattern = f'.{{0,100}}{pattern}.{{0,100}}'
            matches = re.findall(context_pattern, text)
            if matches:
                # Check if it contains justification keywords
                justification_keywords = [
                    'because', 'due to', 'chosen', 'selected', 'appropriate', 'suitable']
                for match in matches:
                    if any(keyword in match for keyword in justification_keywords):
                        justification_found = True
                        break

    return "Yes" if justification_found else "No"


def extract_convergence_issues(text):
    """Check for mentions of convergence issues"""
    convergence_patterns = [
        'convergence',
        'converged',
        'failed to converge',
        'convergence problems',
        'estimation problems'
    ]

    for pattern in convergence_patterns:
        if re.search(pattern, text):
            # Check context for issues
            context_pattern = f'.{{0,50}}{pattern}.{{0,50}}'
            matches = re.findall(context_pattern, text)
            for match in matches:
                if any(word in match for word in ['problem', 'issue', 'failed', 'difficult']):
                    return "Yes"
                elif any(word in match for word in ['achieved', 'successful', 'reached']):
                    return "No"

    return "Not Reported"


def process_pdf_file(pdf_path, study_id):
    """Process a single PDF file and extract all information"""
    print(f"Processing Study {study_id}: {os.path.basename(pdf_path)}")

    text = extract_text_from_pdf(pdf_path)
    if not text:
        print(f"Could not extract text from {pdf_path}")
        return None

    extracted_info = {
        'Study_ID': study_id,
        'PDF_File': os.path.basename(pdf_path),
        'Statistical_Method': extract_statistical_method(text),
        'Alternative_Sampling': extract_alternative_sampling(text),
        'Number_of_Variables': extract_number_of_variables(text),
        'Sample_Size_Occasions': extract_sample_size_occasions(text),
        'Scale_Justification_Provided': extract_scale_justification(text),
        'Software_Used': extract_software_used(text),
        'Convergence_Issues': extract_convergence_issues(text),
        'Text_Length': len(text)
    }

    return extracted_info


def main():
    """Main function to process all PDFs"""
    # Load the current dataset to get Study_IDs and match with PDFs
    try:
        df_current = pd.read_csv(
            "20250703_enhanced_dataset_with_auto_extraction.csv")
    except FileNotFoundError:
        print("Enhanced dataset not found. Please run the R script first.")
        return

    # Directory containing PDFs
    pdf_dir = Path("Review_articles")

    # Get list of PDF files
    pdf_files = list(pdf_dir.glob("*.pdf"))
    pdf_files.sort()

    print(f"Found {len(pdf_files)} PDF files")
    print(f"Have data for {len(df_current)} studies")

    # Extract information from each PDF
    extracted_data = []

    for pdf_file in pdf_files:
        # Extract study number from filename
        filename = pdf_file.stem
        study_match = re.search(r'^(\d+)', filename)

        if study_match:
            study_id = int(study_match.group(1))

            # Check if this study exists in our dataset
            if study_id in df_current['Study_ID'].values:
                extracted_info = process_pdf_file(pdf_file, study_id)
                if extracted_info:
                    extracted_data.append(extracted_info)
            else:
                print(f"Study ID {study_id} not found in dataset")
        else:
            print(f"Could not extract study ID from filename: {filename}")

    # Convert to DataFrame
    df_extracted = pd.DataFrame(extracted_data)

    if len(df_extracted) > 0:
        # Save extracted information
        df_extracted.to_csv(
            "PDF_Extracted_Methodological_Info.csv", index=False)

        # Merge with existing dataset
        df_merged = df_current.merge(
            df_extracted, on='Study_ID', how='left', suffixes=('', '_PDF'))

        # Update the main columns with PDF-extracted information where available
        for col in ['Statistical_Method', 'Alternative_Sampling', 'Number_of_Variables',
                    'Sample_Size_Occasions', 'Scale_Justification_Provided', 'Software_Used', 'Convergence_Issues']:
            pdf_col = f"{col}_PDF" if f"{col}_PDF" in df_merged.columns else col
            if pdf_col in df_merged.columns:
                # Update null values with extracted information
                mask = df_merged[col].isna() & df_merged[pdf_col].notna()
                df_merged.loc[mask, col] = df_merged.loc[mask, pdf_col]

        # Save the updated dataset
        df_merged.to_csv(
            "20250703_dataset_with_PDF_extraction.csv", index=False)

        # Print summary
        print(f"\n" + "="*60)
        print("PDF EXTRACTION SUMMARY")
        print("="*60)
        print(f"Successfully processed: {len(df_extracted)} PDFs")
        print(f"Failed to process: {len(pdf_files) - len(df_extracted)} PDFs")

        # Show extraction success rates
        for col in ['Statistical_Method', 'Alternative_Sampling', 'Number_of_Variables',
                    'Sample_Size_Occasions', 'Scale_Justification_Provided']:
            if col in df_extracted.columns:
                success_rate = (df_extracted[col].notna() & (
                    df_extracted[col] != 'Not Clear')).sum()
                print(
                    f"{col}: {success_rate}/{len(df_extracted)} ({success_rate/len(df_extracted)*100:.1f}%)")

        # Show some examples
        print(f"\nSample of extracted data:")
        sample_cols = ['Study_ID', 'Statistical_Method',
                       'Alternative_Sampling', 'Number_of_Variables']
        print(df_extracted[sample_cols].head())

        print(f"\nFiles created:")
        print(f"- PDF_Extracted_Methodological_Info.csv (extracted data)")
        print(f"- 20250703_dataset_with_PDF_extraction.csv (merged dataset)")

    else:
        print("No data successfully extracted from PDFs")


if __name__ == "__main__":
    main()
