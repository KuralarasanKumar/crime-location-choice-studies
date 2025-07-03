"""
Enhanced PDF Information Extraction for SUoA Studies
Improved patterns and methods for better extraction accuracy
"""

import os
import pandas as pd
import PyPDF2
import pdfplumber
import re
from pathlib import Path
import warnings
import numpy as np
from collections import Counter
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

    return text.lower()


def extract_statistical_method(text):
    """Extract the statistical method used with enhanced patterns"""
    methods = {
        'multinomial logit': [
            'multinomial logit', 'conditional logit', 'mcfadden',
            'discrete choice model', 'choice model', 'multinomial choice'
        ],
        'mixed logit': [
            'mixed logit', 'random parameter', 'random coefficient',
            'random effects logit', 'heterogeneity', 'unobserved heterogeneity',
            'mixed multinomial', 'random parameter logit'
        ],
        'latent class': [
            'latent class', 'finite mixture', 'discrete mixture',
            'heterogeneous preferences', 'preference heterogeneity',
            'class membership'
        ],
        'nested logit': [
            'nested logit', 'hierarchical logit', 'tree structure',
            'nesting structure'
        ],
        'other': [
            'probit', 'ordered logit', 'binary logit', 'logistic regression',
            'regression analysis'
        ]
    }

    detected_methods = []
    for method_type, patterns in methods.items():
        for pattern in patterns:
            if re.search(rf'\b{pattern}\b', text):
                detected_methods.append(method_type)
                break

    if len(detected_methods) == 0:
        return "Not Clear"
    elif len(detected_methods) == 1:
        return detected_methods[0].title().replace('_', ' ')
    else:
        return ", ".join([m.title().replace('_', ' ') for m in detected_methods])


def extract_alternative_sampling(text):
    """Enhanced extraction of sampling strategies"""

    # Explicit sampling mentions
    sampling_patterns = {
        'importance sampling': [
            'importance sampling', 'biased sampling', 'weighted sampling'
        ],
        'random sampling': [
            'random sampling', 'randomly sampled', 'random subset',
            'random sample of alternatives', 'randomly selected alternatives',
            'random selection of', 'randomly chosen alternatives'
        ],
        'stratified sampling': [
            'stratified sampling', 'stratified sample', 'stratification'
        ],
        'none': [
            'full choice set', 'complete choice set', 'all alternatives',
            'entire choice set', 'complete set of alternatives',
            'all possible alternatives', 'entire set of'
        ]
    }

    for sampling_type, patterns in sampling_patterns.items():
        for pattern in patterns:
            if re.search(rf'\b{pattern}\b', text):
                return sampling_type.title()

    # Enhanced choice set size detection
    choice_set_patterns = [
        r'(\d+,?\d*)\s*(?:alternatives|choices|options|choice\s*alternatives)',
        r'choice\s*set\s*(?:of|with|containing)\s*(\d+,?\d*)',
        r'(\d+,?\d*)\s*possible\s*(?:locations|sites|alternatives)',
        r'(\d+,?\d*)\s*candidate\s*(?:locations|sites|alternatives)'
    ]

    choice_set_sizes = []
    for pattern in choice_set_patterns:
        matches = re.findall(pattern, text)
        if matches:
            for match in matches:
                try:
                    size = int(re.sub(r'[,\s]', '', match))
                    if 10 <= size <= 100000:  # Reasonable range
                        choice_set_sizes.append(size)
                except:
                    continue

    if choice_set_sizes:
        max_size = max(choice_set_sizes)
        # If large choice set mentioned but no explicit sampling strategy found
        if max_size > 1000:
            return "Likely Sampled (Large Choice Set)"
        elif max_size <= 100:
            return "Likely No Sampling (Small Choice Set)"

    return "Not Clear"


def extract_number_of_variables(text):
    """Enhanced extraction of variable counts"""

    # Look for various patterns
    variable_patterns = [
        # Direct mentions
        r'(\d+)\s*(?:independent\s*)?variables?\b',
        r'(\d+)\s*(?:explanatory|predictor)\s*variables?\b',
        r'(\d+)\s*covariates?\b',
        r'(\d+)\s*factors?\b',
        r'(\d+)\s*predictors?\b',

        # Table references
        r'table\s*\d+.*?(\d+)\s*variables?',
        r'(\d+)\s*variables?.*?table\s*\d+',

        # Model specifications
        r'model\s*(?:with|including|contains?)\s*(\d+)\s*variables?',
        r'(\d+)\s*variables?\s*(?:in|for)\s*(?:the\s*)?model',

        # Results sections
        r'results?.*?(\d+)\s*variables?',
        r'(\d+)\s*variables?.*?significant',
        r'(\d+)\s*(?:of\s*the\s*)?variables?\s*(?:were?|are)\s*significant',

        # Regression context
        r'regression\s*(?:with|including)\s*(\d+)\s*variables?',
        r'(\d+)\s*variables?\s*in\s*(?:the\s*)?regression'
    ]

    all_numbers = []
    for pattern in variable_patterns:
        matches = re.findall(pattern, text, re.IGNORECASE)
        if matches:
            for match in matches:
                try:
                    num = int(match)
                    if 3 <= num <= 100:  # Reasonable range for variables
                        all_numbers.append(num)
                except:
                    continue

    if all_numbers:
        # Use most common number, or if tie, use the largest reasonable one
        counter = Counter(all_numbers)
        most_common = counter.most_common()

        if len(most_common) == 1:
            return most_common[0][0]
        elif most_common[0][1] > most_common[1][1]:
            return most_common[0][0]
        else:
            # If tie, prefer numbers in reasonable range
            reasonable = [n for n in all_numbers if 5 <= n <= 50]
            if reasonable:
                return max(set(reasonable), key=reasonable.count)
            else:
                return most_common[0][0]

    return None


def extract_software_used(text):
    """Enhanced software detection"""
    software_patterns = {
        'R': [r'\br\b(?:\s+software)?', 'r statistical', 'cran', 'r package', 'r environment'],
        'Stata': ['stata'],
        'Python': ['python', 'biogeme'],
        'SAS': [r'\bsas\b'],
        'SPSS': ['spss'],
        'Biogeme': ['biogeme'],
        'NLOGIT': ['nlogit', 'n-logit'],
        'LIMDEP': ['limdep']
    }

    detected_software = []
    for software, patterns in software_patterns.items():
        for pattern in patterns:
            if re.search(pattern, text, re.IGNORECASE):
                detected_software.append(software)
                break

    if detected_software:
        return ", ".join(detected_software)
    return "Not Specified"


def extract_sample_size_occasions(text):
    """Enhanced extraction of choice occasions"""
    patterns = [
        r'(\d+,?\d*)\s*(?:choice\s*)?occasions?\b',
        r'(\d+,?\d*)\s*observations?\b',
        r'(\d+,?\d*)\s*(?:choice\s*)?sets?\b',
        r'(\d+,?\d*)\s*decisions?\b',
        r'(\d+,?\d*)\s*choices?\b',
        r'n\s*=\s*(\d+,?\d*)',
        r'sample\s*(?:of|size)\s*(\d+,?\d*)',
        r'(\d+,?\d*)\s*cases?\b'
    ]

    numbers = []
    for pattern in patterns:
        matches = re.findall(pattern, text, re.IGNORECASE)
        if matches:
            for match in matches:
                try:
                    num = int(re.sub(r'[,\s]', '', match))
                    if 10 <= num <= 1000000:  # Reasonable range
                        numbers.append(num)
                except:
                    continue

    if numbers:
        # Filter out very small numbers (likely page numbers, etc.)
        reasonable = [n for n in numbers if n >= 50]
        if reasonable:
            return max(set(reasonable), key=reasonable.count)
        else:
            return max(numbers)

    return None


def extract_scale_justification(text):
    """Extract whether scale choice is justified"""
    justification_patterns = [
        'scale.*?(?:justif|reason|rationale|chose|select)',
        '(?:unit|spatial).*?(?:size|scale).*?(?:justif|reason|chose|select)',
        'spatial.*?resolution.*?(?:justif|reason|chose|select)',
        'aggregation.*?level.*?(?:justif|reason|chose|select)',
        'grid.*?size.*?(?:justif|reason|chose|select)',
        '(?:why|because).*?(?:unit|scale|size)',
        'methodolog.*?(?:scale|unit|size)',
        'theoretical.*?(?:scale|unit|size)'
    ]

    for pattern in justification_patterns:
        if re.search(pattern, text, re.IGNORECASE):
            return "Yes"

    return "No"


def extract_convergence_issues(text):
    """Extract information about model convergence"""
    convergence_patterns = [
        'convergence',
        'converged',
        'iteration',
        'maximum likelihood',
        'optimization',
        'numerical issues',
        'estimation problems'
    ]

    for pattern in convergence_patterns:
        if re.search(pattern, text, re.IGNORECASE):
            return "Mentioned"

    return "Not Reported"


def main():
    """Main extraction function"""
    print("Enhanced PDF Extraction for SUoA Studies")
    print("="*50)

    # Set up paths
    review_folder = Path("Review_articles")
    if not review_folder.exists():
        print(f"Error: {review_folder} folder not found!")
        return

    # Get list of PDF files
    pdf_files = list(review_folder.glob("*.pdf"))
    print(f"Found {len(pdf_files)} PDF files")

    # Load existing mapping if available
    mapping_file = "study_pdf_mapping.csv"
    if os.path.exists(mapping_file):
        mapping_df = pd.read_csv(mapping_file)
        print(f"Loaded mapping for {len(mapping_df)} studies")
    else:
        print("Warning: No study-PDF mapping found. Creating basic mapping...")
        mapping_df = pd.DataFrame({
            'Study_ID': range(1, len(pdf_files) + 1),
            'PDF_File': [f.name for f in pdf_files]
        })

    # Extract information from each PDF
    results = []

    for idx, row in mapping_df.iterrows():
        study_id = row['Study_ID']
        pdf_file = row['PDF_File']
        pdf_path = review_folder / pdf_file

        print(f"\nProcessing Study {study_id}: {pdf_file}")

        if not pdf_path.exists():
            print(f"  Warning: PDF not found: {pdf_file}")
            continue

        # Extract text
        text = extract_text_from_pdf(pdf_path)
        if not text:
            print(f"  Error: Could not extract text from {pdf_file}")
            continue

        print(f"  Extracted {len(text):,} characters")

        # Extract information
        result = {
            'Study_ID': study_id,
            'PDF_File': pdf_file,
            'Statistical_Method': extract_statistical_method(text),
            'Alternative_Sampling': extract_alternative_sampling(text),
            'Number_of_Variables': extract_number_of_variables(text),
            'Sample_Size_Occasions': extract_sample_size_occasions(text),
            'Scale_Justification_Provided': extract_scale_justification(text),
            'Software_Used': extract_software_used(text),
            'Convergence_Issues': extract_convergence_issues(text),
            'Text_Length': len(text)
        }

        results.append(result)

        # Print extraction results
        print(f"  Statistical Method: {result['Statistical_Method']}")
        print(f"  Sampling: {result['Alternative_Sampling']}")
        print(f"  Variables: {result['Number_of_Variables']}")
        print(f"  Sample Size: {result['Sample_Size_Occasions']}")
        print(f"  Software: {result['Software_Used']}")

    # Save results
    results_df = pd.DataFrame(results)
    output_file = "Enhanced_PDF_Extracted_Methodological_Info.csv"
    results_df.to_csv(output_file, index=False)
    print(f"\n✅ Results saved to {output_file}")

    # Print summary statistics
    print(f"\n{'='*50}")
    print("ENHANCED EXTRACTION SUMMARY")
    print(f"{'='*50}")

    total = len(results_df)
    print(f"Total PDFs processed: {total}")

    # Calculate success rates
    for col in ['Statistical_Method', 'Alternative_Sampling', 'Number_of_Variables',
                'Sample_Size_Occasions', 'Software_Used']:
        if col in results_df.columns:
            if col in ['Number_of_Variables', 'Sample_Size_Occasions']:
                success = results_df[col].notna().sum()
            else:
                success = results_df[
                    (results_df[col].notna()) &
                    (~results_df[col].isin(
                        ['Not Clear', 'Not Reported', 'Not Specified']))
                ].shape[0]

            print(f"{col}: {success}/{total} ({success/total*100:.1f}%)")

    # Show improvements compared to original extraction
    if os.path.exists("PDF_Extracted_Methodological_Info.csv"):
        original_df = pd.read_csv("PDF_Extracted_Methodological_Info.csv")
        print(f"\n{'='*30}")
        print("IMPROVEMENTS OVER ORIGINAL:")
        print(f"{'='*30}")

        for col in ['Alternative_Sampling', 'Number_of_Variables', 'Sample_Size_Occasions']:
            if col in results_df.columns and col in original_df.columns:
                if col in ['Number_of_Variables', 'Sample_Size_Occasions']:
                    original_success = original_df[col].notna().sum()
                    new_success = results_df[col].notna().sum()
                else:
                    original_success = original_df[
                        (original_df[col].notna()) &
                        (~original_df[col].isin(
                            ['Not Clear', 'Not Reported', 'Not Specified']))
                    ].shape[0]
                    new_success = results_df[
                        (results_df[col].notna()) &
                        (~results_df[col].isin(
                            ['Not Clear', 'Not Reported', 'Not Specified']))
                    ].shape[0]

                improvement = new_success - original_success
                print(
                    f"{col}: +{improvement} studies ({improvement/total*100:.1f}% improvement)")


if __name__ == "__main__":
    main()
