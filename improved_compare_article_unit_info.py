import csv
import re
from fuzzywuzzy import fuzz
import pandas as pd
import os
import numpy as np

# File paths
file_auto = 'article_unit_info_improved.csv'
file_manual = '20250630_Table_standardized.csv'
output_file = 'comparison_improved.csv'


def compare_numeric_fields(auto_val, manual_val, tolerance_pct=20):
    """Compare numeric fields with a tolerance percentage"""
    auto_num = normalize_number(auto_val)
    manual_num = normalize_number(manual_val)

    if auto_num is None or manual_num is None:
        return 0  # No match if either value is missing

    if auto_num == manual_num:
        return 1.0  # Exact match

    # Handle potential unit conversions for unit sizes (detecting common values)
    # If we see a factor of ~1000 difference, could be m² vs km²
    ratio = max(auto_num, 0.001) / max(manual_num, 0.001)

    # Check if this might be a unit conversion issue (m² to km² or vice versa)
    if 800 < ratio < 1200 or 0.0008 < ratio < 0.0012:
        return 0.9  # Very likely a unit conversion
    elif 8 < ratio < 12 or 0.08 < ratio < 0.12:
        return 0.8  # Likely hectares vs km² conversion

    # Calculate percentage difference
    diff_pct = abs(auto_num - manual_num) / max(abs(manual_num), 0.001) * 100

    if diff_pct <= tolerance_pct:
        # Score based on how close the match is
        return 1.0 - (diff_pct / tolerance_pct)

    return 0  # No match if difference exceeds toleranceticle_unit_info_improved.csv'


file_manual = '20250630_Table_standardized.csv'
output_file = 'comparison_improved.csv'

# Configure conversion factors for unit standardization
UNIT_CONVERSIONS = {
    'm²': 0.000001,  # m² to km²
    'ha': 0.01,      # hectare to km²
    'km²': 1.0,      # km² to km²
}

# Define field mapping for matching
FIELD_MAPPING = {
    'Size of the unit': ['Size of the unit', 'size_of_the_unit', 'unit_size'],
    'Unit': ['Unit', 'unit'],
    'Unit_size_km2': ['Unit_size_km2', 'unit_size_km2', 'size_km2', 'area_km2', 'unit_size'],
    'No of units': ['No of units', 'no_of_units', 'units', 'unit_count'],
    'No of incidents': ['No of incidents', 'no_of_incidents', 'incidents', 'incident_count'],
    'Name of the unit': ['Name of the unit', 'name_of_the_unit', 'unit_name'],
}

# Configure field importance weights for overall matching
FIELD_WEIGHTS = {
    'Size of the unit': 0.15,
    'Unit': 0.1,
    'Unit_size_km2': 0.2,
    'No of units': 0.15,
    'No of incidents': 0.15,
    'Name of the unit': 0.25,
}


def normalize_title(title):
    """Normalize a title by removing special characters and lowercasing"""
    if not title:
        return ""
    return re.sub(r'[^\w\s]', '', title).lower().strip()


def normalize_number(value):
    """Extract numeric value from a string, handling commas, units, etc."""
    if not value or value == '':
        return None

    # Remove any non-numeric characters except dots and commas
    clean_value = re.sub(r'[^\d.,]', '', str(value).replace(',', '.'))

    # Handle multiple dots (keep only the last one as decimal separator)
    parts = clean_value.split('.')
    if len(parts) > 2:
        clean_value = ''.join(parts[:-1]) + '.' + parts[-1]

    try:
        return float(clean_value) if clean_value else None
    except (ValueError, TypeError):
        return None


def normalize_unit(unit_str):
    """Normalize unit string (km², m², ha, etc.)"""
    if not unit_str or unit_str == '':
        return None

    unit_str = str(unit_str).lower().strip()

    # Map various unit representations to standard form
    if re.search(r'km[²2]|square\s*k', unit_str):
        return 'km²'
    elif re.search(r'm[²2]|square\s*m', unit_str):
        return 'm²'
    elif re.search(r'ha|hectare', unit_str):
        return 'ha'

    return unit_str


def normalize_unit_name(name):
    """Normalize unit name by lowercasing and removing extra spaces"""
    if not name:
        return ""

    norm_name = name.lower().strip()

    # Map common variations to standardized names
    unit_mappings = {
        'census block': 'census block',
        'block': 'census block',
        'postal code': 'postal code area',
        'postal code area': 'postal code area',
        'postcode': 'postal code area',
        'postcode area': 'postal code area',
        'zip code': 'postal code area',
        'zip': 'postal code area',
        'statistical local area': 'statistical local area',
        'statistical area': 'statistical local area',
        'sla': 'statistical local area',
        'output area': 'output area',
        'neighbourhood': 'neighborhood',
        'residential suburb': 'residential suburb',
    }

    for key, value in unit_mappings.items():
        if key in norm_name:
            return value

    return norm_name


def compare_numeric_fields(auto_val, manual_val, tolerance_pct=10):
    """Compare numeric fields with percentage tolerance"""
    auto_num = normalize_number(auto_val)
    manual_num = normalize_number(manual_val)

    if auto_num is None or manual_num is None:
        return 0  # No match if either value is missing

    if auto_num == manual_num:
        return 1.0  # Exact match

    # Calculate percentage difference
    diff_pct = abs(auto_num - manual_num) / max(abs(manual_num), 0.001) * 100

    if diff_pct <= tolerance_pct:
        # Score based on how close the match is
        return 1.0 - (diff_pct / tolerance_pct)

    return 0  # No match if difference exceeds tolerance


def compare_unit_field(auto_val, manual_val):
    """Compare unit fields (m², km², ha)"""
    auto_unit = normalize_unit(auto_val)
    manual_unit = normalize_unit(manual_val)

    if auto_unit is None or manual_unit is None:
        return 0  # No match if either value is missing

    if auto_unit == manual_unit:
        return 1.0  # Exact match

    # Handle related units with lower score
    related_units = {
        'km²': ['m²', 'ha'],
        'm²': ['km²', 'ha'],
        'ha': ['m²', 'km²']
    }

    if auto_unit in related_units and manual_unit in related_units[auto_unit]:
        return 0.5  # Related units get partial credit

    return 0  # No match for different units


def compare_text_field(auto_val, manual_val, fuzzy_threshold=80):
    """Compare text fields using fuzzy matching"""
    if not auto_val or not manual_val:
        return 0  # No match if either value is missing

    auto_text = str(auto_val).lower().strip()
    manual_text = str(manual_val).lower().strip()

    if auto_text == manual_text:
        return 1.0  # Exact match

    # Use fuzzy matching for text fields
    ratio = fuzz.ratio(auto_text, manual_text)

    if ratio >= fuzzy_threshold:
        return ratio / 100  # Score based on fuzzy match ratio

    return 0  # No match if below threshold


def compare_unit_name_field(auto_val, manual_val):
    """Compare unit name fields with special handling"""
    if not auto_val or not manual_val:
        return 0  # No match if either value is missing

    auto_name = normalize_unit_name(str(auto_val))
    manual_name = normalize_unit_name(str(manual_val))

    if auto_name == manual_name:
        return 1.0  # Exact match

    # Check if one is contained in the other
    if auto_name in manual_name or manual_name in auto_name:
        return 0.8  # Substantial match

    # Check for specific unit types that are related
    related_terms = {
        'census block': ['block', 'census unit', 'unit'],
        'census tract': ['tract', 'census unit', 'unit'],
        'postal code area': ['postcode', 'zip code', 'pc4', 'code area'],
        'statistical local area': ['statistical area', 'sla', 'local area'],
        'output area': ['lsoa', 'msoa', 'super output area'],
        'neighborhood': ['neighbourhood', 'community', 'residential area'],
        'grid cell': ['cell', 'grid', 'unit'],
        'street segment': ['street', 'segment', 'road']
    }

    # Check for related terms
    for key, values in related_terms.items():
        if (key in auto_name and any(v in manual_name for v in values)) or \
           (key in manual_name and any(v in auto_name for v in values)):
            return 0.75  # Related unit types

    # Use multiple fuzzy matching algorithms for unit names
    ratio = fuzz.ratio(auto_name, manual_name)
    token_sort = fuzz.token_sort_ratio(auto_name, manual_name)
    token_set = fuzz.token_set_ratio(auto_name, manual_name)
    partial = fuzz.partial_ratio(auto_name, manual_name)

    # Take the best match from the different algorithms
    best_match = max(ratio, token_sort, token_set, partial)

    if best_match >= 70:  # Lower threshold for unit names
        return best_match / 100  # Score based on fuzzy match ratio

    return 0  # No match


def get_match_label(score):
    """Convert numerical match score to descriptive label"""
    if score >= 0.9:
        return "Exact Match"
    elif score >= 0.7:
        return "Strong Match"
    elif score >= 0.5:
        return "Moderate Match"
    elif score > 0:
        return "Weak Match"
    return "No Match"


def compare_article_data():
    """Compare auto-extracted data with manual reference data"""
    print("Loading data files...")

    # Read auto-extracted data
    try:
        auto_data = pd.read_csv(file_auto)
    except Exception as e:
        print(f"Error reading auto-extracted data: {e}")
        return

    # Read manual data
    try:
        manual_data = pd.read_csv(file_manual)
    except Exception as e:
        print(f"Error reading manual reference data: {e}")
        return

    print(
        f"Loaded {len(auto_data)} auto-extracted records and {len(manual_data)} manual records")

    # Normalize titles for matching
    manual_data['normalized_title'] = manual_data['Title of the study'].apply(
        normalize_title)

    # Initialize results DataFrame
    results = []

    for _, auto_row in auto_data.iterrows():
        file_name = auto_row['filename']
        file_id = auto_row['file_id']
        auto_ref_title = file_name  # Use filename as reference title

        best_match = None
        best_match_score = -1

        # Try to find matching manual record
        for _, manual_row in manual_data.iterrows():
            manual_title = manual_row['Title of the study']
            manual_norm_title = manual_row['normalized_title']

            # Calculate title match score
            if auto_ref_title:
                # If we already have a reference title, use it directly
                title_score = fuzz.ratio(normalize_title(
                    auto_ref_title), manual_norm_title) / 100
            else:
                # Try to extract title-like words from filename
                file_words = ' '.join(file_name.split('_')[
                                      1:]).replace('.pdf', '')
                title_score = fuzz.partial_ratio(
                    file_words.lower(), manual_norm_title) / 100

            if title_score >= 0.6:  # Threshold for considering a title match
                if title_score > best_match_score:
                    best_match = manual_row
                    best_match_score = title_score

        # If we found a match, compare fields
        comparison_row = {
            'File': file_name,
            'File_ID': file_id,
            'Auto_Title': auto_ref_title if auto_ref_title else 'Unknown',
            'Manual_Title': best_match['Title of the study'] if best_match is not None else 'No Match Found',
            'Title_Match_Score': round(best_match_score * 100) if best_match_score >= 0 else 0
        }

        field_scores = {}

        if best_match is not None:
            # Compare each field
            for field, aliases in FIELD_MAPPING.items():
                auto_value = next((auto_row.get(alias, '')
                                  for alias in aliases if alias in auto_row), '')
                manual_value = best_match.get(field, '')

                # Different comparison methods based on field type
                if field == 'Size of the unit' or field == 'Unit_size_km2':
                    score = compare_numeric_fields(auto_value, manual_value)
                elif field == 'Unit':
                    score = compare_unit_field(auto_value, manual_value)
                elif field == 'Name of the unit':
                    score = compare_unit_name_field(auto_value, manual_value)
                elif field in ['No of units', 'No of incidents']:
                    score = compare_numeric_fields(auto_value, manual_value)
                else:
                    score = compare_text_field(auto_value, manual_value)

                match_label = get_match_label(score)
                field_scores[field] = score

                # Add to comparison row
                comparison_row[f'Auto_{field}'] = auto_value
                comparison_row[f'Manual_{field}'] = manual_value
                comparison_row[f'{field}_Match'] = match_label
                comparison_row[f'{field}_Score'] = round(score * 100)
        else:
            # No match found, set all scores to 0
            for field in FIELD_MAPPING:
                auto_value = next((auto_row.get(
                    alias, '') for alias in FIELD_MAPPING[field] if alias in auto_row), '')
                comparison_row[f'Auto_{field}'] = auto_value
                comparison_row[f'Manual_{field}'] = 'N/A'
                comparison_row[f'{field}_Match'] = 'No Match'
                comparison_row[f'{field}_Score'] = 0
                field_scores[field] = 0

        # Calculate weighted overall score
        if best_match is not None:
            weighted_score = sum(
                score * FIELD_WEIGHTS[field] for field, score in field_scores.items())
            overall_score = weighted_score / sum(FIELD_WEIGHTS.values())
        else:
            overall_score = 0

        comparison_row['Overall_Match_Score'] = round(overall_score * 100)
        comparison_row['Overall_Match_Quality'] = f"{get_match_label(overall_score)} ({comparison_row['Overall_Match_Score']}%)"

        results.append(comparison_row)

    # Convert to DataFrame and save
    results_df = pd.DataFrame(results)

    # Reorder columns for better readability
    column_order = [
        'File', 'Auto_Title', 'Manual_Title', 'Title_Match_Score',
    ]

    for field in FIELD_MAPPING:
        column_order.extend(
            [f'Auto_{field}', f'Manual_{field}', f'{field}_Match', f'{field}_Score'])

    column_order.extend(['Overall_Match_Score', 'Overall_Match_Quality'])

    # Ensure all columns in column_order exist in results_df
    column_order = [col for col in column_order if col in results_df.columns]

    results_df = results_df[column_order]
    results_df.to_csv(output_file, index=False)

    print(f"Comparison completed. Results saved to {output_file}")

    # Summary statistics
    match_counts = results_df['Overall_Match_Quality'].str.split(
        ' ', n=1).str[0].value_counts()
    print("\nMatch Quality Summary:")
    for match_type, count in match_counts.items():
        print(f"{match_type}: {count}")


if __name__ == "__main__":
    compare_article_data()
