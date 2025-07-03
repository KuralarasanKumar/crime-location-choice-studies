import os
import csv
import re
from difflib import SequenceMatcher

# Define paths
csv_path = '20250703_standardized_unit_sizes_with_groups.csv'
review_articles_path = 'Review_articles'

# Read the CSV file to create a mapping between titles and study IDs
studies = {}
with open(csv_path, 'r', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        study_id = row['Study_ID']
        title = row['Title_of_the_study'].lower()
        citation = row['Citation']
        studies[study_id] = {
            'title': title,
            'citation': citation,
            'words': set(re.findall(r'\w+', title.lower()))
        }

# Get list of PDF files in the Review_articles directory
pdf_files = [f for f in os.listdir(review_articles_path) if f.endswith('.pdf')]
pdf_files.sort()

# Function to calculate the similarity between two strings
def similar(a, b):
    return SequenceMatcher(None, a, b).ratio()

# Process each file and suggest matches
matches = []
for pdf_file in pdf_files:
    # Extract the content part of the filename (remove leading number and extension)
    file_content = re.sub(r'^\d+_', '', pdf_file.lower().replace('.pdf', ''))
    
    # Calculate similarity scores for each study
    scores = []
    for study_id, study_info in studies.items():
        # Calculate similarity between file name and study title
        score = similar(file_content, study_info['title'][:len(file_content)])
        scores.append((study_id, score))
    
    # Sort by score in descending order
    scores.sort(key=lambda x: x[1], reverse=True)
    
    # Get the current number from the filename
    current_number = re.search(r'^(\d+)_', pdf_file)
    current_number = current_number.group(1) if current_number else None
    
    # Add to matches list
    matches.append({
        'file': pdf_file,
        'current_number': current_number,
        'top_matches': scores[:3]  # Keep top 3 matches for review
    })

# Print the matches for review
print("Review the suggested matches:\n")
print(f"{'File':<60} {'Current #':<10} {'Suggested Study ID':<20} {'Match Score':<15} {'Title'}")
print("-" * 120)

for match in matches:
    file = match['file']
    current_num = match['current_number'] if match['current_number'] else "N/A"
    
    if match['top_matches']:
        top_id, top_score = match['top_matches'][0]
        title = studies[top_id]['title']
        print(f"{file[:57]:<60} {current_num:<10} {top_id:<20} {top_score:.2f} {title[:50]}")
    else:
        print(f"{file[:57]:<60} {current_num:<10} {'No match':<20} {'N/A'} {'N/A'}")

# Create a manual mapping file
with open('study_id_mapping_manual.csv', 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['File', 'Current Number', 'Study ID', 'Title', 'Citation'])
    
    for match in matches:
        file = match['file']
        current_num = match['current_number'] if match['current_number'] else ""
        
        if match['top_matches']:
            top_id, _ = match['top_matches'][0]
            title = studies[top_id]['title']
            citation = studies[top_id]['citation']
        else:
            top_id = ""
            title = ""
            citation = ""
            
        writer.writerow([file, current_num, top_id, title, citation])

print("\nA file 'study_id_mapping_manual.csv' has been created.")
print("Please review and edit this file to correct any mismatches.")
print("After editing, run the rename_from_mapping.py script to rename the files.")

# Create a script to perform the renaming based on the manual mapping
with open('rename_from_mapping.py', 'w', encoding='utf-8') as script:
    script.write("""
import os
import csv
import shutil

# Define paths
mapping_file = 'study_id_mapping_manual.csv'
review_articles_path = 'Review_articles'

# Read the mapping file
rename_plan = []
with open(mapping_file, 'r', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        filename = row['File']
        study_id = row['Study ID']
        
        if study_id and study_id.strip():  # Only if a study ID has been assigned
            # Create the new filename
            new_filename = f"{study_id.zfill(2)}_{filename.split('_', 1)[1]}"
            if new_filename != filename:
                rename_plan.append((filename, new_filename))

# Print the rename plan
if rename_plan:
    print("\\nRename Plan:")
    for old_name, new_name in rename_plan:
        print(f"{old_name} -> {new_name}")
else:
    print("\\nNo files need to be renamed.")

# Ask for confirmation
if rename_plan:
    confirmation = input("\\nProceed with renaming? (yes/no): ")
    
    if confirmation.lower() == 'yes':
        # Execute the renaming
        for old_name, new_name in rename_plan:
            old_path = os.path.join(review_articles_path, old_name)
            new_path = os.path.join(review_articles_path, new_name)
            shutil.move(old_path, new_path)
        print("Renaming complete!")
    else:
        print("Renaming cancelled.")
""")

print("Also created 'rename_from_mapping.py' which you can run after editing the mapping file.")
