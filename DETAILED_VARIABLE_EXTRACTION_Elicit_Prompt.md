# DETAILED VARIABLE EXTRACTION PROMPT FOR ELICIT

## PROMPT FOR ELICIT:

**Extract detailed variable information from each paper. For each study, provide:**

### INDEPENDENT VARIABLES - COMPLETE LIST:

**Format your response EXACTLY as follows for each paper:**

---
**PAPER: [Title/Filename]**

**DEMOGRAPHIC VARIABLES:**
- [Variable name]: [Brief description if provided]
- [Variable name]: [Brief description if provided]
- [etc.]

**ECONOMIC VARIABLES:**
- [Variable name]: [Brief description if provided]
- [Variable name]: [Brief description if provided]
- [etc.]

**LAND USE VARIABLES:**
- [Variable name]: [Brief description if provided]
- [Variable name]: [Brief description if provided]
- [etc.]

**INFRASTRUCTURE VARIABLES:**
- [Variable name]: [Brief description if provided]
- [Variable name]: [Brief description if provided]
- [etc.]

**DISTANCE/ACCESSIBILITY VARIABLES:**
- [Variable name]: [Brief description if provided]
- [Variable name]: [Brief description if provided]
- [etc.]

**CRIME OPPORTUNITY VARIABLES:**
- [Variable name]: [Brief description if provided]
- [Variable name]: [Brief description if provided]
- [etc.]

**SOCIAL/NEIGHBORHOOD VARIABLES:**
- [Variable name]: [Brief description if provided]
- [Variable name]: [Brief description if provided]
- [etc.]

**OTHER VARIABLES:**
- [Variable name]: [Brief description if provided]
- [Variable name]: [Brief description if provided]
- [etc.]

**TOTAL INDEPENDENT VARIABLES:** [Number]

---

### SPECIFIC INSTRUCTIONS:

1. **List EVERY independent variable mentioned** in the study - do not just count them
2. **Categorize each variable** into the appropriate category above
3. **Include variable names exactly as written** in the paper
4. **Add brief descriptions** when the paper provides them (measurement units, data source, etc.)
5. **Do not include dependent variables** (crime counts, crime rates, etc.)
6. **If a variable could fit multiple categories**, choose the most appropriate one
7. **If you cannot categorize a variable**, put it in "OTHER VARIABLES"

### EXAMPLES OF VARIABLE CATEGORIZATION:

**DEMOGRAPHIC:**
- Population density, Age distribution, Household size, Ethnicity percentages, Education levels

**ECONOMIC:**
- Median income, Unemployment rate, Property values, Business density, Economic disadvantage index

**LAND USE:**
- Residential area percentage, Commercial area percentage, Industrial zoning, Green space, Building density

**INFRASTRUCTURE:**
- Road density, Public transport access, Number of bus stops, Street lighting, Parking availability

**DISTANCE/ACCESSIBILITY:**
- Distance to CBD, Distance to main roads, Distance to public transport, Accessibility index

**CRIME OPPORTUNITY:**
- Number of bars/pubs, Nightlife density, Cash-based businesses, ATM density, Tourist attractions

**SOCIAL/NEIGHBORHOOD:**
- Social cohesion index, Neighborhood disorder, Collective efficacy, Social capital measures

### IMPORTANT NOTES:

- **Be comprehensive** - extract ALL variables, not just main ones
- **Use exact variable names** from the paper when possible
- **If a paper lists variables in a table or appendix**, extract from there too
- **Include control variables** if they are independent variables in the model
- **If variable categories are unclear**, make your best judgment based on the content

### OUTPUT FORMAT:
Please provide the extraction in a structured format that can be easily parsed and converted to a spreadsheet for analysis.

---

## ALTERNATIVE SIMPLIFIED PROMPT (if the above is too complex):

**For each paper, extract ALL independent variables used in the discrete choice model. List each variable name and categorize it as:**

- DEMOGRAPHIC (population, age, education, etc.)
- ECONOMIC (income, employment, property values, etc.)  
- LAND USE (residential, commercial, industrial areas, etc.)
- INFRASTRUCTURE (roads, transport, utilities, etc.)
- DISTANCE (to CBD, transport, facilities, etc.)
- CRIME OPPORTUNITY (bars, ATMs, entertainment, etc.)
- SOCIAL (cohesion, disorder, neighborhood characteristics, etc.)
- OTHER (variables that don't fit above categories)

**Format:**
Paper: [Title]
- DEMOGRAPHIC: [var1], [var2], [var3]...
- ECONOMIC: [var1], [var2], [var3]...
- [continue for all categories with variables]
- TOTAL VARIABLES: [number]

---

## USAGE INSTRUCTIONS:

1. **Copy the main prompt above** into Elicit
2. **Upload your 49 PDF papers** to Elicit
3. **Run the extraction** on all papers
4. **Export the results** as CSV
5. **Use the parsing script** (create_detailed_variable_parser.py) to convert the text results into a structured dataset

This will give you a comprehensive database of ALL variables used in each study, properly categorized for your analysis of how SUoA size relates to variable selection patterns.
