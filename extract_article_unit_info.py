import os
import re
import pdfplumber
import csv

ARTICLES_DIR = r'c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\snatching\crime-location-choice-studies-1\Review_articles'
output_file = 'article_unit_info.csv'

keywords = [
    "unit size", "area", "square", "km", "hectare", "block", "postcode", "tract", "number of units", "total area",
    "incident", "property", "household", "street", "output area", "LSOA", "block group", "small area"
]

header = [
    "File", "Size of the unit", "Unit", "Unit_size_km2", "No of units", "No of incidents", "Name of the unit", "Notes"
]


def extract_info_from_text(text):
    # Initialize fields
    size_of_unit = unit = unit_size_km2 = no_of_units = no_of_incidents = name_of_unit = notes = ""
    # Try to find relevant info using regex and keyword search
    # (You can expand these patterns for more accuracy)
    size_match = re.search(
        r'(\d+[\d,.]*)\s*(km²|km2|m²|m2|mi²|mi2|hectare|ha|sq km|square km|square mile|block|property|household)', text, re.IGNORECASE)
    if size_match:
        size_of_unit = size_match.group(1)
        unit = size_match.group(2)
    units_match = re.search(
        r'(number of units|total units|blocks|postcodes|tracts|areas|properties|households|streets)[^\\d]*(\\d+)', text, re.IGNORECASE)
    if units_match:
        no_of_units = units_match.group(2)
    incidents_match = re.search(
        r'(number of incidents|crimes|cases|events)[^\\d]*(\\d+)', text, re.IGNORECASE)
    if incidents_match:
        no_of_incidents = incidents_match.group(2)
    # Name of the unit (look for common terms)
    name_match = re.search(
        r'(block|postcode|tract|property|household|street|output area|LSOA|block group|small area)', text, re.IGNORECASE)
    if name_match:
        name_of_unit = name_match.group(1)
    # Notes: grab the sentence or paragraph containing the keyword
    for kw in keywords:
        if kw in text.lower():
            notes = text
            break
    # Calculate km² if possible
    if size_of_unit and unit:
        try:
            val = float(size_of_unit.replace(',', ''))
            if unit.lower() in ['m²', 'm2']:
                unit_size_km2 = val / 1e6
            elif unit.lower() in ['km²', 'km2', 'sq km', 'square km']:
                unit_size_km2 = val
            elif unit.lower() in ['mi²', 'mi2', 'square mile']:
                unit_size_km2 = val * 2.58999
            elif unit.lower() in ['hectare', 'ha']:
                unit_size_km2 = val * 0.01
        except Exception:
            unit_size_km2 = ""
    return [size_of_unit, unit, unit_size_km2, no_of_units, no_of_incidents, name_of_unit, notes[:200]]


with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(header)
    for filename in os.listdir(ARTICLES_DIR):
        if filename.lower().endswith('.pdf'):
            path = os.path.join(ARTICLES_DIR, filename)
            try:
                with pdfplumber.open(path) as pdf:
                    full_text = ""
                    for page in pdf.pages:
                        page_text = page.extract_text() or ""
                        full_text += page_text + "\n"
                    info = extract_info_from_text(full_text)
                    writer.writerow([filename] + info)
            except Exception as e:
                writer.writerow([filename, "Error", "Error",
                                "Error", "Error", "Error", "Error", str(e)])

print(f"Extraction complete. Output saved to {output_file}")
