
# PDF Extraction Instructions for SUoA Methodological Review

## Overview
For each PDF, extract information about the discrete choice methodology used.
Focus on the Methods section, but also check Results and Data sections.

## Priority 1 Columns (Essential)

### 1. Statistical_Method
**What to look for:** Type of discrete choice model used
**Common terms:**
- "Multinomial Logit" → Enter: Multinomial Logit
- "Conditional Logit" → Enter: Multinomial Logit  
- "Mixed Logit", "Random Parameters Logit" → Enter: Mixed Logit
- "Latent Class", "Finite Mixture" → Enter: Latent Class
- "Nested Logit" → Enter: Nested Logit
- Other models → Enter: Other

### 2. Alternative_Sampling  
**What to look for:** How they handled the choice set
**Common terms:**
- "Full choice set", "All alternatives" → Enter: None
- "Random sample", "Randomly sampled alternatives" → Enter: Random
- "Stratified sample" → Enter: Stratified  
- "Importance sampling" → Enter: Importance
- If choice set >1000 units but no mention → Enter: Likely Sampled

### 3. Number_of_Variables
**What to look for:** Count of independent variables (covariates)
**Where to find:** Methods section, results tables
**Note:** Count unique variables, not coefficients (dummy variables count as 1)

### 4. Sample_Size_Occasions
**What to look for:** Number of choice occasions/observations  
**Common terms:** "observations", "choice occasions", "incidents"
**Note:** This is usually the number of crimes/events, not spatial units

### 5. Scale_Justification_Provided
**What to look for:** Explanation of why they chose their spatial unit
**Look for:** Discussion of "spatial unit", "unit of analysis", "scale"
- Explicit justification → Enter: Yes
- Brief mention without justification → Enter: Partial
- No discussion → Enter: No

## Priority 2 Columns (Important)

### 6. Software_Used
**Look for:** R, Stata, Python, Biogeme, SAS, SPSS
**Common phrases:** "estimated using", "analysis conducted in"

### 7. Convergence_Issues  
**Look for:** Mentions of convergence problems or success
- Problems mentioned → Enter: Yes
- Successful convergence mentioned → Enter: No
- No mention → Enter: Not Reported

### 8. Choice_Set_Strategy
**Look for:** How they structured the choice alternatives
- All units included → Enter: Full
- Subset of alternatives → Enter: Sampled
- Hierarchical structure → Enter: Nested

## Where to Look in Each Paper

1. **Abstract:** Quick overview of method
2. **Methods section:** Primary source for all information
3. **Data section:** Sample sizes, variable counts
4. **Results section:** Software, convergence, model fit
5. **Tables:** Variable lists, sample statistics

## Quality Control

- **Double-check numbers:** Ensure variable counts are reasonable (3-50)
- **Cross-reference:** Verify sample sizes match across sections
- **Note uncertainties:** Use Extraction_Notes for unclear cases
- **Record pages:** Note which pages you checked

## Time Estimate
- Experienced coder: 5-10 minutes per paper
- New coder: 10-15 minutes per paper  
- Total for 50 papers: 8-12 hours

## Common Challenges

1. **Multiple models:** If paper tests multiple models, record the main/final model
2. **Unclear methods:** Note in Extraction_Notes and mark as "Not Clear"
3. **Missing information:** Leave blank rather than guess
4. **Technical terms:** When in doubt, copy exact phrase to Notes

## Files to Use
- **Manual_PDF_Extraction_Template.csv:** Main data entry file
- **Coding_Guide_Streamlined.csv:** Standardized values reference
- **PDF_Study_Mapping.csv:** Study ID to PDF mapping
