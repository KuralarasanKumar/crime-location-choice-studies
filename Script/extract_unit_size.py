import os
import re
from PyPDF2 import PdfReader

ARTICLES_DIR = r'c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\snatching\crime-location-choice-studies-4\Review_articles'

files_to_check = [
    "S06_effects_of_residential_history_on_commercial_robbe.pdf",
    "S13_a_sentimental_journey_to_crime_effects_of_reside.pdf",
    "S14_Modeling Micro-Level Crime Location Choice Applic.pdf",
    "S19_role_of_the_street_network_in_burglars_spatial_de.pdf",
    "S22_Testing Ecological Theories of Offender Spatial De.pdf",
    "S27_residential_burglary_target_selection_an_analysis.pdf",
    "S32_modelling_the_spatial_decision_making_of_terrorist.pdf",
    "S40_a_discrete_spatial_choice_model_of_burglary_target.pdf",
    "S46_Spatial analysis with preference specification of .pdf"
]

keywords = [
    "unit size", "area", "square", "km", "hectare", "block", "postcode", "tract", "number of units", "total area"
]


print("| Study ID | Unit of Analysis | Unit Size | Source (Page/Quote) |")
print("|---|---|---|---|")

for filename in files_to_check:
    path = os.path.join(ARTICLES_DIR, filename)
    study_id = filename.split('_')[0]
    try:
        reader = PdfReader(path)
        found = False
        total_area = None
        num_units = None
        total_area_line = None
        num_units_line = None
        for page_num, page in enumerate(reader.pages, 1):
            page_text = page.extract_text() or ""
            for line in page_text.splitlines():
                lower_line = line.lower()
                # Look for total area
                if re.search(r'(total|study) area', lower_line):
                    area_match = re.search(
                        r'(\d+[\d,.]*)\s*(km|hectare|sq|square|mile|m2|km2|ha)', lower_line)
                    if area_match:
                        total_area = area_match.group(0)
                        safe_line = line.strip().replace('|', '\\|')
                        total_area_line = f"Page {page_num}: {safe_line}"
                # Look for number of units
                if re.search(r'(number of|total) (units|areas|blocks|postcodes|tracts|households|properties|residents|addresses|output areas|LSOAs|block groups|small areas|streets)', lower_line):
                    num_match = re.search(r'(\d+[\d,.]*)', lower_line)
                    if num_match:
                        num_units = num_match.group(0)
                        safe_line = line.strip().replace('|', '\\|')
                        num_units_line = f"Page {page_num}: {safe_line}"
                # As before, look for direct unit size info
                if any(kw in lower_line for kw in keywords):
                    unit_line = line.strip().replace('|', '\\|')
                    match = re.search(
                        r'(\d+[\d,.]*\s*(?:km|hectare|block|postcode|tract|unit|area|household|resident|property|sq|square|mile|address|output area|LSOA|block group|small area|street))', unit_line, re.IGNORECASE)
                    unit_size = match.group(0) if match else "(see quote)"
                    unit_type_match = re.search(
                        r'(postcode|LSOA|block group|output area|tract|block|street|area|unit|household|property|resident|small area)', unit_line, re.IGNORECASE)
                    unit_type = unit_type_match.group(
                        0) if unit_type_match else "(see quote)"
                    print(
                        f"| {study_id} | {unit_type} | {unit_size} | Page {page_num}: {unit_line} |")
                    found = True
        # If both total_area and num_units found, calculate average unit size
        if total_area and num_units:
            # Try to extract numeric values and units
            area_val_match = re.search(r'(\d+[\d,.]*)', total_area)
            area_val = float(area_val_match.group(1).replace(
                ',', '')) if area_val_match else None
            unit_val_match = re.search(r'(\d+[\d,.]*)', num_units)
            unit_val = float(unit_val_match.group(1).replace(
                ',', '')) if unit_val_match else None
            area_unit_match = re.search(
                r'(km|hectare|sq|square|mile|m2|km2|ha)', total_area, re.IGNORECASE)
            area_unit = area_unit_match.group(
                1) if area_unit_match else "(unit)"
            if area_val and unit_val and unit_val != 0:
                avg_unit_size = area_val / unit_val
                avg_unit_size_str = f"{avg_unit_size:.2f} {area_unit} per unit"
                print(
                    f"| {study_id} | (calculated) | {avg_unit_size_str} | [Inferred: {total_area} / {num_units}] {total_area_line}; {num_units_line} |")
                found = True
        if not found:
            # Fallback: print first 200 chars of first page for manual review
            if reader.pages:
                first_page = reader.pages[0].extract_text() or ""
                context = first_page[:200].replace(
                    '\n', ' ').replace('|', '\\|')
                print(
                    f"| {study_id} | Not found | Not found | [Manual review needed] {context} ... |")
    except Exception as e:
        print(f"| {study_id} | Error | Error | Error reading {filename}: {e} |")
