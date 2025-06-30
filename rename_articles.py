import os
import re

folder = r'articles'
files = sorted([f for f in os.listdir(folder) if f.lower().endswith('.pdf')])

for idx, filename in enumerate(files, 1):
    # Try to extract the title after the year
    match = re.match(r".*? - (\d{4}) - (.+)\.pdf$", filename)
    if match:
        title = match.group(2).strip()
    else:
        # If no year, try to get after last dash
        parts = filename.rsplit(' - ', 1)
        title = parts[-1].replace('.pdf', '').strip() if len(
            parts) > 1 else filename.replace('.pdf', '').strip()
    # Clean up title for filename
    title_clean = re.sub(r'[^\w\s-]', '', title).replace(' ', '_')
    s_number = f"S{idx:02d}"
    new_name = f"{s_number}_{title_clean}.pdf"
    old_path = os.path.join(folder, filename)
    new_path = os.path.join(folder, new_name)
    if old_path != new_path:
        print(f"Renaming: {filename} -> {new_name}")
        os.rename(old_path, new_path)
