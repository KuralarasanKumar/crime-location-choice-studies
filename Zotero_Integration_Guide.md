# Zotero Integration Guide
*Complete Step-by-Step Instructions for Merging Journal/Citation Data*

## 📋 Overview
You have **49 crime location choice studies** from your Elicit extraction. To complete your dataset, you need to add journal names, DOIs, and citation information from Zotero Desktop.

## 🎯 What You'll Get
- **Journal names** for publication venue analysis
- **DOI links** for verification and access
- **Volume/Issue/Page numbers** for complete citations
- **Publisher information** for additional analysis
- **Verified author lists** for quality control

---

## 📚 STEP 1: Prepare Zotero Desktop

### 1.1 Open Zotero Desktop
- Launch Zotero Desktop on your computer
- Make sure you're logged into your Zotero account (if applicable)

### 1.2 Create New Collection
- Right-click in the Collections panel (left side)
- Select "New Collection"
- Name it: **"Crime Location Choice Studies"**

---

## 🔍 STEP 2: Add Papers to Zotero

### Method A: Quick Search (Recommended)
Use the search queries from `Zotero_Matching_Data.csv`:

**For each study (49 total):**
1. Copy the search query from the CSV file
2. In Zotero, use the search bar at the top
3. Look for papers matching:
   - Similar title
   - Matching first author
4. Add to your "Crime Location Choice Studies" collection

**Example searches:**
```
1. "TARGET CHOICE DURING EXTREME EVENTS DISCRETE SPATIAL" + "Peter Baudains"
2. "Formal Evaluation Impact Barriers Connectors" + "Joseph Clare"  
3. "Investigating effect people street streetscape" + "Han Yue"
```

### Method B: DOI Import (If Available)
1. Check if the study has a DOI in your current data
2. In Zotero: click the "Add by Identifier" button (magic wand icon)
3. Paste the DOI
4. Zotero will automatically import the full record

### Method C: PDF Import (If You Have PDFs)
1. Drag PDF files from `Review_articles/` folder into Zotero
2. Right-click on PDF → "Retrieve Metadata for PDF"
3. Zotero will extract bibliographic information automatically

---

## 📤 STEP 3: Export Collection from Zotero

### 3.1 Select All Studies
- Click on your "Crime Location Choice Studies" collection
- Select all items (Ctrl+A / Cmd+A)

### 3.2 Export Collection
- Right-click on the selected items
- Choose **"Export Items..."**
- Select format: **"CSV"**
- Check these options:
  ✅ Include Notes
  ✅ Include Extra fields
  ✅ Export Collections

### 3.3 Choose Export Fields
Make sure to include:
- **Title**
- **Authors** 
- **Journal/Publication Title**
- **Year**
- **DOI**
- **Volume**
- **Issue** 
- **Pages**
- **Publisher**
- **URL**

### 3.4 Save Export File
- Save as: **`Zotero_Export.csv`**
- Location: Your project folder (`crime-location-choice-studies-2`)

---

## 🔄 STEP 4: Run Merge Script

Once you have `Zotero_Export.csv` in your project folder:

```bash
python simple_merge_zotero_elicit.py
```

This will:
- ✅ Match Zotero records with your Elicit data
- ✅ Create `Merged_Elicit_Zotero_Dataset.csv`
- ✅ Show matching statistics and data improvements

---

## 🎯 Expected Results

### Matching Success
- **Target**: 40-45 out of 49 studies matched (80-90%)
- **Realistic**: 35-40 studies matched (70-80%)
- **Minimum**: 30+ studies matched (60%+)

### Data Improvements
- **Journal names**: +15-20 additional venues identified
- **DOI links**: +20-30 additional DOIs
- **Complete citations**: Volume/Issue/Pages for most studies
- **Author verification**: Cross-check author spellings

---

## ⚠️ Troubleshooting

### If Matching is Low (<70%)
1. **Check title variations**: Some papers may have slightly different titles
2. **Manual verification**: Review unmatched studies in the output
3. **Alternative titles**: Search using alternative phrasings
4. **Conference vs Journal**: Some studies might be conference papers

### If Papers Not Found in Zotero
1. **Google Scholar search**: Find the paper online first
2. **Import via DOI**: Copy DOI from Google Scholar to Zotero
3. **Manual entry**: Create entry manually in Zotero
4. **Publisher websites**: Check journal websites directly

### If Export Fails
1. **File permissions**: Make sure you can write to the project folder
2. **CSV format**: Ensure you selected CSV (not RIS or other formats)
3. **Column names**: Check that Title, Authors, Journal columns exist

---

## 📊 Quality Control

After merging, check:
- **Duplicate detection**: Any papers matched multiple times?
- **Title verification**: Do Elicit and Zotero titles match reasonably?
- **Author consistency**: Are author names consistent?
- **Year verification**: Do publication years match?

---

## 🚀 Next Steps After Integration

1. **Review merged dataset**: Check `Merged_Elicit_Zotero_Dataset.csv`
2. **Standardize units**: Convert all SUoA sizes to km²
3. **Begin analysis**: Run statistical analysis on research questions
4. **Create visualizations**: Generate plots and summary tables

---

## 💡 Pro Tips

### Zotero Efficiency
- **Browser connector**: Install Zotero browser extension for easier paper capture
- **Bulk import**: Use DOI batch import for multiple papers
- **PDF organization**: Keep PDFs organized in Zotero for future reference

### Search Strategies
- **Partial titles**: Use key words from titles rather than full titles
- **Author + year**: Combine first author with publication year
- **Journal browsing**: Browse specific criminology journals for relevant papers

### Backup Strategy
- **Export backup**: Keep a backup of your Zotero collection
- **Version control**: Save intermediate files with timestamps
- **Multiple formats**: Export in both CSV and RIS for flexibility

---

## 📋 Checklist

- [ ] Zotero Desktop installed and running
- [ ] "Crime Location Choice Studies" collection created
- [ ] Papers searched and added to collection (target: 40+ papers)
- [ ] Collection exported as `Zotero_Export.csv`
- [ ] Merge script run successfully
- [ ] Results reviewed in `Merged_Elicit_Zotero_Dataset.csv`
- [ ] Quality control checks completed
- [ ] Ready for statistical analysis

---

*🎉 Once complete, you'll have a comprehensive dataset ready for your systematic review analysis!*
