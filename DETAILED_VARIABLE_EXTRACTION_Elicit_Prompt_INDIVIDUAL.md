# DETAILED VARIABLE EXTRACTION PROMPT FOR ELICIT
## Extract Individual Variables from Crime Location Choice Studies

### TASK OBJECTIVE
Extract the complete list of individual independent variables used in each crime location choice study, with their exact names, descriptions, and categorization.

### EXTRACTION TEMPLATE
For each study, extract the following information in this exact format:

**Study Identification:**
- Title: [Full paper title]
- Year: [Publication year]
- Authors: [First author surname et al.]

**Individual Variables List:**
Please list EVERY individual independent variable mentioned in the study, using this format:

**DEMOGRAPHIC VARIABLES:**
1. Variable Name: [Exact name as used in paper] | Description: [Brief description] | Unit: [measurement unit if available]
2. Variable Name: [Exact name as used in paper] | Description: [Brief description] | Unit: [measurement unit if available]
[Continue for all demographic variables...]

**ECONOMIC VARIABLES:**
1. Variable Name: [Exact name as used in paper] | Description: [Brief description] | Unit: [measurement unit if available]
2. Variable Name: [Exact name as used in paper] | Description: [Brief description] | Unit: [measurement unit if available]
[Continue for all economic variables...]

**LAND USE VARIABLES:**
1. Variable Name: [Exact name as used in paper] | Description: [Brief description] | Unit: [measurement unit if available]
2. Variable Name: [Exact name as used in paper] | Description: [Brief description] | Unit: [measurement unit if available]
[Continue for all land use variables...]

**INFRASTRUCTURE VARIABLES:**
1. Variable Name: [Exact name as used in paper] | Description: [Brief description] | Unit: [measurement unit if available]
2. Variable Name: [Exact name as used in paper] | Description: [Brief description] | Unit: [measurement unit if available]
[Continue for all infrastructure variables...]

**DISTANCE/ACCESSIBILITY VARIABLES:**
1. Variable Name: [Exact name as used in paper] | Description: [Brief description] | Unit: [measurement unit if available]
2. Variable Name: [Exact name as used in paper] | Description: [Brief description] | Unit: [measurement unit if available]
[Continue for all distance/accessibility variables...]

**CRIME OPPORTUNITY VARIABLES:**
1. Variable Name: [Exact name as used in paper] | Description: [Brief description] | Unit: [measurement unit if available]
2. Variable Name: [Exact name as used in paper] | Description: [Brief description] | Unit: [measurement unit if available]
[Continue for all crime opportunity variables...]

**SOCIAL/BEHAVIORAL VARIABLES:**
1. Variable Name: [Exact name as used in paper] | Description: [Brief description] | Unit: [measurement unit if available]
2. Variable Name: [Exact name as used in paper] | Description: [Brief description] | Unit: [measurement unit if available]
[Continue for all social/behavioral variables...]

**OTHER/CONTROL VARIABLES:**
1. Variable Name: [Exact name as used in paper] | Description: [Brief description] | Unit: [measurement unit if available]
2. Variable Name: [Exact name as used in paper] | Description: [Brief description] | Unit: [measurement unit if available]
[Continue for all other variables...]

**SUMMARY COUNTS:**
- Total Independent Variables: [Number]
- Demographic Variables: [Number]
- Economic Variables: [Number]
- Land Use Variables: [Number]
- Infrastructure Variables: [Number]
- Distance/Accessibility Variables: [Number]
- Crime Opportunity Variables: [Number]
- Social/Behavioral Variables: [Number]
- Other/Control Variables: [Number]

---

### SPECIFIC INSTRUCTIONS

1. **Look for variable information in these sections:**
   - Methods/Methodology section
   - Data and Variables section
   - Model specification
   - Results tables (particularly regression tables)
   - Appendices with variable descriptions

2. **Variable naming conventions:**
   - Use the EXACT variable name as it appears in the paper
   - If the paper uses abbreviations, include both full name and abbreviation
   - If only abbreviations are given, provide them as-is

3. **Variable categorization guidelines:**
   - **Demographic**: Population density, age structure, gender ratios, household composition, education levels
   - **Economic**: Income, employment rates, poverty rates, business density, property values, retail activity
   - **Land Use**: Residential density, commercial area, industrial area, green space, mixed-use development
   - **Infrastructure**: Road density, public transportation, parking availability, lighting, building types
   - **Distance/Accessibility**: Distance to CBD, distance to transport hubs, accessibility indices, travel time
   - **Crime Opportunity**: Target density, guardianship measures, visibility, foot traffic, activity patterns
   - **Social/Behavioral**: Social cohesion, collective efficacy, mobility patterns, routine activities
   - **Other/Control**: Spatial lag variables, temporal controls, jurisdictional dummies, interaction terms

4. **What to include:**
   - ALL independent variables used in the main models
   - Control variables and fixed effects
   - Interaction terms and transformed variables
   - Spatial lag variables if used

5. **What to exclude:**
   - Dependent variables (crime counts, choice outcomes)
   - Model diagnostics or goodness-of-fit measures
   - Variables mentioned but not actually used in analysis

6. **Units and descriptions:**
   - Include measurement units when available (%, per km², log-transformed, etc.)
   - Provide brief but clear descriptions of what each variable measures
   - Note if variables are continuous, categorical, or binary

7. **If information is unclear:**
   - If variable category is ambiguous, place in "OTHER/CONTROL VARIABLES"
   - If exact variable names are not clear, note: "Variable names not clearly specified"
   - If only partial variable lists are available, note: "Partial variable list - full details not provided"

### EXAMPLE OUTPUT FORMAT

**Study Identification:**
- Title: Crime Location Choice in Urban Areas: A Discrete Choice Analysis
- Year: 2020
- Authors: Smith et al.

**DEMOGRAPHIC VARIABLES:**
1. Variable Name: Population_Density | Description: Residents per square kilometer | Unit: persons/km²
2. Variable Name: Elderly_Ratio | Description: Percentage of population over 65 years | Unit: percentage
3. Variable Name: Household_Size | Description: Average number of persons per household | Unit: persons

**ECONOMIC VARIABLES:**
1. Variable Name: Median_Income | Description: Median household income | Unit: dollars (log-transformed)
2. Variable Name: Unemployment_Rate | Description: Percentage of labor force unemployed | Unit: percentage
3. Variable Name: Business_Density | Description: Number of businesses per square kilometer | Unit: businesses/km²

[Continue for all categories...]

**SUMMARY COUNTS:**
- Total Independent Variables: 15
- Demographic Variables: 3
- Economic Variables: 3
- Land Use Variables: 4
- Infrastructure Variables: 2
- Distance/Accessibility Variables: 2
- Crime Opportunity Variables: 1
- Social/Behavioral Variables: 0
- Other/Control Variables: 0

---

### QUALITY CHECK
Before submitting, verify:
- [ ] All individual variables are listed with exact names
- [ ] Each variable has a description and unit when available
- [ ] Variables are properly categorized
- [ ] Summary counts match the individual lists
- [ ] No variables are double-counted across categories
- [ ] Paper title, year, and authors are correctly identified
