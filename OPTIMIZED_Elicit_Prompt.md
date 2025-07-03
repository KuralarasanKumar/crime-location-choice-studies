# OPTIMIZED ELICIT PROMPT FOR SUoA CRIME STUDIES
*Focus on high-value information that cannot be automated effectively*

---

## 🎯 HIGH PRIORITY EXTRACTION (Focus 70% of effort here)

### 1. **Independent Variables - Detailed Breakdown** ⭐ CRITICAL
Please categorize ALL independent variables mentioned in the model into these specific categories and provide counts:

- **Demographic variables** (population density, age distribution, household composition, etc.): [Count: X variables]
- **Economic variables** (income, unemployment, property values, poverty rates, etc.): [Count: X variables]  
- **Land use variables** (residential density, commercial areas, mixed use, etc.): [Count: X variables]
- **Infrastructure variables** (roads, public transport, lighting, etc.): [Count: X variables]
- **Distance variables** (to city center, highways, transit, etc.): [Count: X variables]
- **Crime opportunity variables** (previous crimes, guardianship, targets, etc.): [Count: X variables]
- **Social variables** (social cohesion, collective efficacy, disorder, etc.): [Count: X variables]

**Total number of independent variables in final model: [X]**

### 2. **Study Area Size** ⭐ CRITICAL  
Total area of the study site in km² (or provide description if km² not available):
- Look for phrases like "study area," "total area," "city area," "coverage area"
- Convert other units to km² if possible (square miles × 2.59, hectares × 0.01)

### 3. **Data Sources for Variables** ⭐ CRITICAL
Primary data sources used for independent variables:
- Census data, Police records, Administrative data, Survey data, Remote sensing, Other (specify)
- Note if variables come from different temporal periods

### 4. **Sampling Strategy Details** ⭐ CRITICAL
Look carefully for:
- Explicit mentions of "sampling," "subset," "random selection of alternatives"
- Discussions of computational burden or large choice sets
- Choice set size (total number of spatial units considered)
- Any mention of reducing alternatives for computational reasons

### 5. **Population Information** 
- Population per spatial unit (average or range)
- Total population of study area
- Population density measures used

---

## 🔍 MEDIUM PRIORITY EXTRACTION (Focus 20% of effort here)

### 6. **SUoA Limitations and Trade-offs**
- Any explicit discussion of limitations in their spatial unit choice
- Mention of trade-offs between resolution and computational burden
- Discussion of sensitivity to scale choice
- Methodological limitations related to aggregation

### 7. **Key SUoA-Related Findings**
- Main results specifically about spatial unit size effects
- Model performance metrics (if related to scale choice)
- Any findings about optimal unit size or scale sensitivity

### 8. **Country/Location Verification** 
*Only for studies where location is unclear from title/citation*
- Specific city/region name
- Country (if not obvious from institutional affiliation)

---

## ⚡ LOW PRIORITY EXTRACTION (Focus 10% of effort here)

### 9. **Verification of Automated Extractions** 
*Only if you notice discrepancies*
- Double-check statistical method classification
- Verify crime type if title is ambiguous
- Confirm data collection year if citation is unclear

### 10. **Additional Methodological Details**
- Software packages used (if not obvious)
- Model convergence issues mentioned
- Specific estimation techniques beyond basic model type

---

## 📋 EXTRACTION GUIDELINES

**FOR VARIABLES:**
- Look in methodology sections, model specification tables, and results sections
- Count ALL variables in the final model, not preliminary analyses
- If a table lists variables, count them systematically
- Note if study uses multiple model specifications - focus on the main/preferred model

**FOR STUDY AREA:**
- Check introduction, study area descriptions, and methodology sections
- Look for maps with scale indicators
- Convert units consistently (prefer km²)

**FOR SAMPLING:**
- Often not explicitly labeled - look for indirect mentions
- Large choice sets (>1000 units) often imply sampling even if not stated
- Look for discussions of "computational feasibility" or "estimation time"

**FOR DATA SOURCES:**
- Usually described in data/methodology sections
- Note the temporal period if variables are from different years
- Distinguish between dependent variable data source and independent variable sources

---

## ⚠️ QUALITY CONTROL

- Mark items as "UNCLEAR" if information is ambiguous rather than guessing
- Indicate confidence level: HIGH/MEDIUM/LOW for each extracted item
- Note page numbers or section references for verification
- Flag unusual or innovative methodological approaches

---

## 🎯 EXPECTED IMPACT

This optimized approach will:
✅ Enable complete analysis of Research Question 6 (Variables & SUoA relationship)  
✅ Provide rich methodological insights about scale choice trade-offs  
✅ Require only ~400 manual data points vs 1,785 for complete manual extraction  
✅ Focus effort on information that automation cannot reliably extract  

**Focus your Elicit extraction on these high-value, hard-to-automate items for maximum research impact!**
