# FOCUSED ELICIT PROMPT FOR REMAINING INFORMATION
*Extract only the missing high-value details from your SUoA studies*

---

## 🎯 **PRIORITY 1: Variable Categorization** ⭐ **MOST CRITICAL**

For each study, categorize ALL independent variables mentioned in the model into these specific categories:

### **Variable Categories with Counts:**

**Demographic Variables:** [Count: X]
- Population density, age distribution, household composition, residents per unit, demographic characteristics
- Examples: population density, median age, household size, number of residents

**Economic Variables:** [Count: X] 
- Income, unemployment, property values, poverty rates, economic indicators, affluence measures
- Examples: median income, unemployment rate, property values, deprivation index, SEIFA

**Land Use Variables:** [Count: X]
- Residential density, commercial areas, retail space, mixed use, zoning, land use types
- Examples: retail floor space, commercial density, residential units, land use mix

**Infrastructure Variables:** [Count: X]
- Roads, public transport, lighting, sidewalks, transportation infrastructure
- Examples: underground stations, road networks, transport hubs, street infrastructure

**Distance Variables:** [Count: X]
- Distance to city center, highways, transit, amenities, spatial proximity measures
- Examples: distance to city center, proximity to highways, distance to amenities

**Crime Opportunity Variables:** [Count: X]
- Previous crimes, guardianship, surveillance, targets, victimization history
- Examples: previous 24-hour offenses, surveillance cameras, guardianship measures

**Social Variables:** [Count: X]
- Social cohesion, collective efficacy, disorder, ethnic diversity, social disorganization
- Examples: ethnic diversity, population churn, social cohesion, disorder indicators

### **Total Independent Variables:** [X]

---

## 🎯 **PRIORITY 2: Study Area Sizes** ⭐ **IMPORTANT**

Convert study area descriptions to numeric values in km²:

**Total study area:** [X km²] or [description if km² not available]

### **Conversion Guide:**
- Look for explicit mentions: "150 km²", "5,386 square kilometers"
- Convert units: square miles × 2.59 = km², hectares × 0.01 = km²
- Use city/region names: "Greater London" ≈ 1,572 km², "City of Chicago" ≈ 606 km²
- Administrative areas: "Metropolitan area", "City limits", "Urban area"

---

## 🎯 **PRIORITY 3: Sampling Strategy Details** ⭐ **HELPFUL**

Clarify the alternative sampling approach used:

**Sampling Strategy:** [Select one]
- **Full choice set** - All spatial units included, no sampling
- **Random sampling** - Random subset of alternatives selected
- **Stratified sampling** - Sampling within defined strata/groups  
- **Importance sampling** - Biased sampling based on relevance
- **Other sampling** - [Specify method]

### **Look for clues:**
- "Full choice set", "complete set of alternatives" → Full choice set
- "Random sample", "randomly selected alternatives" → Random sampling
- "Computational burden", "large choice sets" → Likely sampling used
- Choice set size > 1000 units → Probably sampled

---

## 📋 **EXTRACTION GUIDELINES**

### **For Variables:**
- Count ALL variables in the **final model** (not preliminary analyses)
- Look in: methodology sections, model specifications, results tables
- Include control variables and main explanatory variables
- If multiple models tested, focus on the **main/preferred model**

### **For Study Areas:**
- Check: introduction, study area descriptions, methodology sections
- Look for: maps with scale indicators, administrative boundary descriptions
- Prefer: explicit km² measurements over estimates

### **For Sampling:**
- Often not explicitly stated - look for indirect evidence
- Search for: "computational feasibility", "estimation challenges", "choice set reduction"
- Large choice sets (>1000) usually require sampling even if not mentioned

---

## ⚠️ **QUALITY CONTROL**

- Mark **"UNCLEAR"** if information is ambiguous rather than guessing
- Indicate confidence: **HIGH/MEDIUM/LOW** for each extracted item
- Prefer explicit information over inferences
- Note page numbers for verification if needed

---

## 🎯 **EXPECTED OUTPUT FORMAT**

```
Study: [Title]

VARIABLES:
- Demographic Variables: [list] → Count: X
- Economic Variables: [list] → Count: X  
- Land Use Variables: [list] → Count: X
- Infrastructure Variables: [list] → Count: X
- Distance Variables: [list] → Count: X
- Crime Opportunity Variables: [list] → Count: X
- Social Variables: [list] → Count: X
Total Variables: X

STUDY AREA: X km² (or description)

SAMPLING: [Full choice set/Random/Stratified/Importance/Other]

CONFIDENCE: HIGH/MEDIUM/LOW
```

---

## 🚀 **WHY THIS APPROACH**

This focused prompt will:
✅ Complete Research Question 6 analysis (Variables & SUoA relationship)  
✅ Enable precise choice set density calculations  
✅ Clarify methodological approaches across studies  
✅ Require only ~3-5 minutes per study vs 15-20 for full extraction  

**Focus your effort on these high-impact items for maximum research value!**
