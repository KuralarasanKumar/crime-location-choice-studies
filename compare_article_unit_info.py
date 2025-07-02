import csv

# File paths
file_auto = 'article_unit_info.csv'
file_manual = '20250630_Table_standardized.csv'
output = 'comparison_output.csv'

# Read auto-extracted data
with open(file_auto, encoding='utf-8') as f:
    reader = csv.DictReader(f)
    auto_data = list(reader)

# Read manual data
with open(file_manual, encoding='utf-8') as f:
    reader = csv.DictReader(f)
    manual_data = list(reader)

# Build lookup for manual data by title (case-insensitive, stripped)


def normalize_title(title):
    return title.lower().strip().replace('"', '').replace("'", "")


manual_lookup = {normalize_title(
    row['Title of the study']): row for row in manual_data if 'Title of the study' in row}

# Prepare output
header = [
    'File', 'Auto_Size_of_the_unit', 'Auto_Unit', 'Auto_Unit_size_km2', 'Auto_No_of_units', 'Auto_No_of_incidents', 'Auto_Name_of_the_unit',
    'Manual_Title', 'Manual_Size_of_the_unit', 'Manual_Unit', 'Manual_Unit_size_km2', 'Manual_No_of_units', 'Manual_No_of_incidents', 'Manual_Name_of_the_unit',
    'Match_Status'
]
rows = []


def compare_field(val1, val2, tol=0.01):
    try:
        f1 = float(str(val1).replace(',', '').replace('km²', '').replace('km2', '').replace(
            'm²', '').replace('m2', '').replace('ha', '').replace('HA', '').replace(' ', ''))
        f2 = float(str(val2).replace(',', '').replace('km²', '').replace('km2', '').replace(
            'm²', '').replace('m2', '').replace('ha', '').replace('HA', '').replace(' ', ''))
        return abs(f1 - f2) < tol
    except Exception:
        return str(val1).strip().lower() == str(val2).strip().lower()


for auto in auto_data:
    # Try to match by file name to title (loose match)
    file_base = auto['File'].split('_')[1:5]  # take a few words from file name
    file_key = ' '.join(file_base).replace(
        '.pdf', '').replace('-', ' ').replace('_', ' ').lower()
    matched = None
    for title, manual in manual_lookup.items():
        if any(word in title for word in file_key.split() if word):
            matched = manual
            break
    if matched:
        # Compare key fields
        field_matches = []
        # Compare size of the unit
        field_matches.append(compare_field(
            auto['Size of the unit'], matched.get('Size of the unit', '')))
        # Compare unit
        field_matches.append(compare_field(
            auto['Unit'], matched.get('Unit', '')))
        # Compare unit size km2
        field_matches.append(compare_field(
            auto['Unit_size_km2'], matched.get('Unit_size_km2', '')))
        # Compare no of units
        field_matches.append(compare_field(
            auto['No of units'], matched.get('No of units', '')))
        # Compare no of incidents
        field_matches.append(compare_field(
            auto['No of incidents'], matched.get('No of incidents', '')))
        # Compare name of the unit
        field_matches.append(compare_field(
            auto['Name of the unit'], matched.get('Name of the unit', '')))

        if all(field_matches):
            status = 'Exact Match'
        elif any(field_matches):
            status = 'Partial Match'
        else:
            status = 'Mismatch'
        rows.append([
            auto['File'], auto['Size of the unit'], auto['Unit'], auto['Unit_size_km2'], auto[
                "No of units"], auto['No of incidents'], auto['Name of the unit'],
            matched.get('Title of the study', ''), matched.get(
                'Size of the unit', ''), matched.get('Unit', ''), matched.get('Unit_size_km2', ''),
            matched.get('No of units', ''), matched.get(
                'No of incidents', ''), matched.get('Name of the unit', ''), status
        ])
    else:
        status = 'No Match'
        rows.append([
            auto['File'], auto['Size of the unit'], auto['Unit'], auto['Unit_size_km2'], auto[
                "No of units"], auto['No of incidents'], auto['Name of the unit'],
            '', '', '', '', '', '', '', status
        ])

with open(output, 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerows(rows)

print(f'Comparison complete. Output saved to {output}')
