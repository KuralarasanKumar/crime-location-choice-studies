# MAXIMUM EXTRACTION PROMPT FOR CRIME LOCATION CHOICE STUDIES
## Extract Every Possible Detail - Think Like a Research Assistant Reading Every Table and Section

### EXTRACTION PHILOSOPHY
You are a meticulous research assistant who reads EVERY section, table, and appendix. Your goal is to extract the MAXIMUM amount of information, especially variables, by looking in multiple places throughout the paper. Leave no stone unturned.

### COMPLETE EXTRACTION TEMPLATE
For each study, provide ALL information in this exact structured format:

---

## STUDY IDENTIFICATION
**Title:** [Full paper title]
**Year:** [Publication year]
**Authors:** [All authors, separated by semicolons]

---

## STUDY CONTEXT
**Country:** [Country where study was conducted]
**City/Region:** [Specific city or region studied]
**Study Area Size:** [Total area in km² or other units - extract exact value]
**Study Area Description:** [Brief description of geographic scope]
**Crime Type:** [Primary crime type analyzed - be specific]
**Crime Types (All):** [All crime types if multiple, separated by semicolons]
**Study Period:** [Time period of data - years covered]
**Data Sources:** [All data sources used, separated by semicolons]

---

## SPATIAL UNIT OF ANALYSIS (SUoA)
**SUoA Type:** [e.g., Census tract, Block group, Grid cell, Administrative unit]
**SUoA Size:** [Exact size with units - e.g., "500m x 500m", "0.25 km²", "varies 0.1-2.5 km²"]
**SUoA Description:** [Detailed description of spatial units used]
**Number of Units:** [Total number of spatial units in study]
**Population per Unit:** [Average or range of population per unit]
**Justification for SUoA Choice:** [Reasons given for choosing this spatial scale]

---

## METHODOLOGY
**Study Design:** [Cross-sectional, longitudinal, etc.]
**Statistical Method:** [Primary analytical method - be specific about model type]
**Model Type:** [Discrete choice model type - conditional logit, multinomial logit, etc.]
**Software Used:** [Statistical software mentioned]
**Sampling Approach:** [How spatial units or alternatives were sampled]
**Sample Size:** [Number of choice observations or events]
**Choice Set Definition:** [How choice sets were constructed]
**Estimation Method:** [Maximum likelihood, Bayesian, etc.]

---

## COMPLETE INDIVIDUAL VARIABLE LIST
Please list EVERY individual independent variable mentioned in the study, using this exact format:

**DEMOGRAPHIC VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
2. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
[Continue for all demographic variables...]

**ECONOMIC VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
2. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
[Continue for all economic variables...]

**LAND USE VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
2. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
[Continue for all land use variables...]

**INFRASTRUCTURE VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
2. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
[Continue for all infrastructure variables...]

**DISTANCE/ACCESSIBILITY VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
2. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
[Continue for all distance/accessibility variables...]

**CRIME OPPORTUNITY VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
2. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
[Continue for all crime opportunity variables...]

**SOCIAL/BEHAVIORAL VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
2. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
[Continue for all social/behavioral variables...]

**ENVIRONMENTAL VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
2. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
[Continue for all environmental variables...]

**TEMPORAL/CONTROL VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
2. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
[Continue for all temporal/control variables...]

**JURISDICTION/POLICY VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
2. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
[Continue for all jurisdiction/policy variables...]

**OTHER VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
2. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
[Continue for all other variables that don't fit the above 10 categories...]

---

## VARIABLE SUMMARY COUNTS
**Total Independent Variables:** [Number]
**Demographic Variables:** [Number]
**Economic Variables:** [Number]
**Land Use Variables:** [Number]
**Infrastructure Variables:** [Number]
**Distance/Accessibility Variables:** [Number]
**Crime Opportunity Variables:** [Number]
**Social/Behavioral Variables:** [Number]
**Environmental Variables:** [Number]
**Temporal/Control Variables:** [Number]
**Jurisdiction/Policy Variables:** [Number]
**Other Variables:** [Number]

---

## KEY FINDINGS
**Main Results:** [Brief summary of key findings about location choice]
**Significant Predictors:** [Variables that were statistically significant, list exact variable names]
**Model Performance:** [R-squared, log-likelihood, AIC/BIC if reported]
**Scale Effects:** [Any findings about spatial scale or SUoA size effects]

---

## DATA QUALITY NOTES
**Variable Information Quality:** [Complete/Partial/Limited - assess how well variables were described]
**Missing Information:** [Note any information that could not be extracted]
**Extraction Confidence:** [High/Medium/Low - your confidence in the extraction accuracy]

---

### DETAILED EXTRACTION INSTRUCTIONS

#### 1. STUDY IDENTIFICATION
- Extract complete bibliographic information
- Use filename exactly as provided
- Include all authors, not just first author

#### 2. STUDY CONTEXT
- **Study Area Size**: Look for total area in km², square miles, or other units. Convert to km² if possible.
- **Crime Type**: Be specific (e.g., "residential burglary" not just "property crime")
- **Study Period**: Extract exact years of data collection
- **Data Sources**: Include all mentioned sources (census, police records, GIS databases, etc.)

#### 3. SPATIAL UNIT OF ANALYSIS
- **SUoA Size**: Extract exact dimensions or area measurements with units
- **SUoA Description**: Include details about unit boundaries, how they were defined
- **Number of Units**: Total count of spatial units analyzed
- **Population per Unit**: Average population or range if provided
- **Justification**: Look for explicit reasons why this spatial scale was chosen

#### 4. METHODOLOGY
- **Statistical Method**: Be specific about model type and estimation approach
- **Sampling Approach**: How were choice sets constructed? Random sampling? All units?
- **Sample Size**: Number of choice observations, not just spatial units
- **Choice Set Definition**: How many alternatives per choice set? How were they selected?

#### 5. MAXIMUM VARIABLE EXTRACTION - READ EVERYTHING!

**Critical Instruction: Variables are often scattered throughout the paper. You MUST read ALL of these sections:**

**PRIMARY SOURCES (Read these sections intensively):**
1. **Methods/Methodology** - Variable definitions and data sources
2. **Data and Variables** - Comprehensive variable descriptions  
3. **Model Specification** - All variables in equations
4. **Results Tables** - EVERY regression table (Tables 1, 2, 3, etc.)
5. **Summary Statistics Tables** - Often contains complete variable lists
6. **Appendices** - Frequently contain detailed variable definitions
7. **Robustness Check Tables** - Additional variables often introduced

**SECONDARY SOURCES (Don't miss these):**
8. **Abstract** - Sometimes mentions key variable categories
9. **Introduction** - May reference important control variables
10. **Literature Review** - May mention variables used
11. **Discussion/Conclusion** - May reference variables in interpretation
12. **Footnotes** - Variable definitions often hidden here
13. **Figure Captions** - Variable definitions for maps/plots

**VARIABLE EXTRACTION STRATEGY:**

**Step 1: Find ALL Tables with Variables**
- Look for: "Table 1", "Table 2", "Table A1", "Appendix Table", etc.
- Regression tables typically show ALL variables used
- Summary statistics tables show variable ranges and means
- Correlation matrices show variable relationships

**Step 2: Scan Every Section for Variable Mentions**
- Search for phrases like: "control for", "include", "variables", "covariates", "predictors"
- Look for sentences like: "We control for population density, income, and road access"
- Don't miss lists in paragraph form: "Controls included age, gender, education, and employment status"

**Step 3: Extract Variable Details from Multiple Mentions**
- Variables often mentioned in methods but detailed in tables
- Combine information from different sections
- Note transformations: log, square root, standardized, per capita, etc.

**EXAMPLES OF MAXIMUM EXTRACTION:**

**Example 1 - From a Regression Table:**
```
Table 2: Conditional Logit Results
Variable                    Coefficient    SE
Population density (log)    0.234**       (0.089)
Median income (000s)       -0.156*        (0.067)
Distance to CBD (km)       -0.045***      (0.012)
Highway access (binary)     0.287**       (0.098)
Bus stops per km2           0.023         (0.019)
Commercial area %           0.067*        (0.031)
```

**Extract as:**
DEMOGRAPHIC VARIABLES:
1. Population density (log) | Log of population per square kilometer | log(persons/km²) | Census data

ECONOMIC VARIABLES:
1. Median income (000s) | Median household income in thousands | thousands USD | American Community Survey

DISTANCE/ACCESSIBILITY VARIABLES:
1. Distance to CBD (km) | Distance to central business district | kilometers | GIS calculation
2. Highway access (binary) | Within 1km of highway entrance | binary 0/1 | GIS analysis
3. Bus stops per km2 | Number of bus stops per square kilometer | stops/km² | Transit authority data

LAND USE VARIABLES:
1. Commercial area % | Percentage of area zoned commercial | percentage | City planning department

**Example 2 - From Methods Section:**
"We control for demographic characteristics including population density, age structure (percentage under 18 and over 65), racial composition (percentage white, black, Hispanic), and educational attainment (percentage with college degrees)."

**Extract as:**
DEMOGRAPHIC VARIABLES:
1. Population density | Population per unit area | persons/km² | Census
2. Percentage under 18 | Proportion of population aged 0-17 | percentage | Census  
3. Percentage over 65 | Proportion of population aged 65+ | percentage | Census
4. Percentage white | Proportion of white residents | percentage | Census
5. Percentage black | Proportion of black residents | percentage | Census
6. Percentage Hispanic | Proportion of Hispanic residents | percentage | Census
7. Percentage with college degrees | Proportion with bachelor's degree or higher | percentage | Census

**Example 3 - From Multiple Sources:**
Methods mentions: "economic controls"
Table shows: "Unemployment rate", "Poverty rate", "Median rent"
Appendix defines: "Unemployment rate measured as percentage of labor force unemployed"

**Extract as:**
ECONOMIC VARIABLES:
1. Unemployment rate | Percentage of labor force unemployed | percentage | Bureau of Labor Statistics
2. Poverty rate | Percentage of households below poverty line | percentage | Census
3. Median rent | Median monthly rental cost | dollars | American Community Survey

**DETAILED VARIABLE CATEGORIZATION - 10 Categories:**
**1. DEMOGRAPHIC VARIABLES:**
Population characteristics, age distributions, gender, race/ethnicity, household composition, education levels, family structure, migration patterns
*Examples: population density, % under 18, % over 65, % white/black/Hispanic, % college educated, household size, % foreign born*

**2. ECONOMIC VARIABLES:**  
Income, employment, poverty, wealth, business activity, property values, economic development indicators
*Examples: median income, unemployment rate, poverty rate, Gini coefficient, property values, business density, retail sales*

**3. LAND USE VARIABLES:**
How land is utilized, zoning, development patterns, residential/commercial/industrial mix
*Examples: residential density, % commercial area, % industrial, % green space, mixed-use development, building height*

**4. INFRASTRUCTURE VARIABLES:**
Transportation systems, utilities, public facilities, built environment features
*Examples: road density, public transit, parking availability, street lighting, broadband access, water/sewer systems*

**5. DISTANCE/ACCESSIBILITY VARIABLES:**
Spatial relationships, travel costs, connectivity, centrality measures  
*Examples: distance to CBD, distance to highways, travel time to work, accessibility index, network centrality*

**6. CRIME OPPORTUNITY VARIABLES:**
Target availability, guardianship, visibility, activity patterns that create crime opportunities
*Examples: target density, foot traffic, visibility, guardianship, cash businesses, nightlife establishments*

**7. SOCIAL/BEHAVIORAL VARIABLES:**
Social organization, community characteristics, routine activities, cultural factors
*Examples: social cohesion, collective efficacy, residential stability, civic participation, routine activity patterns*

**8. ENVIRONMENTAL VARIABLES:**
Physical environment, natural features, climate, geographic characteristics
*Examples: terrain, vegetation, water bodies, climate variables, environmental quality, natural barriers*

**9. TEMPORAL/CONTROL VARIABLES:**
Time-related variables, spatial controls, model controls, interaction terms
*Examples: time trends, seasonal effects, spatial lag terms, fixed effects, interaction variables*

**10. JURISDICTION/POLICY VARIABLES:**
Administrative boundaries, policy variables, law enforcement characteristics
*Examples: police presence, policy changes, jurisdictional dummies, enforcement levels, legal variables*

**Variable format requirements:**
For each variable, provide: `Variable_Name | Description | Unit | Data_Source`

Examples:
- `POP_DENSITY | Population per square kilometer | persons/km² | U.S. Census`
- `MEDIAN_INC | Median household income (log-transformed) | log(dollars) | American Community Survey`
- `DIST_CBD | Distance to central business district | kilometers | GIS calculation`
- `UNEMP_RATE | Unemployment rate | percentage | Bureau of Labor Statistics`

**COMPREHENSIVE SEARCH STRATEGY:**

**Phase 1: Table Hunting (Most Important)**
- Scan for ANY table with coefficients, variables, or statistics
- Look for table titles containing: "Results", "Regression", "Model", "Estimates", "Summary Statistics", "Descriptive", "Correlation"
- Check ALL appendix tables (often contain full variable lists)
- Don't miss supplementary tables or online appendices

**Phase 2: Section-by-Section Variable Mining**
```
Methods Section:
- Look for: "We control for...", "Variables include...", "Covariates are..."
- Search for: "demographic controls", "economic indicators", "spatial controls"

Data Section:  
- Often has comprehensive variable definitions
- Look for subsections on different data sources
- Check variable construction details

Results Section:
- Read table notes and footnotes carefully
- Variable definitions often in table footnotes
- Look for sensitivity analyses with additional variables

Appendices:
- Variable definition tables
- Robustness checks with extended variable sets
- Data source descriptions
```

**Phase 3: Context-Based Extraction**
- If paper mentions "demographic controls" but doesn't list them, note: "Demographic controls included but not specified"
- If table shows abbreviations without definitions, extract abbreviations and note: "Full definitions not provided"
- Always note when variable information is incomplete

**VARIABLE EXTRACTION RULES:**

**DO Extract:**
✓ ALL variables in ANY regression table
✓ Variables mentioned in methods even if not in tables  
✓ Control variables and fixed effects
✓ Interaction terms and transformations
✓ Variables from robustness checks
✓ Spatial lag and temporal controls
✓ Variables mentioned but marked as "not significant"

**DON'T Extract:**
✗ Dependent variables (crime rates, choice outcomes)
✗ Model fit statistics (R², AIC, log-likelihood)  
✗ Sample size or observation counts
✗ Test statistics or p-values

**HANDLE MISSING INFORMATION:**
- If variable categories mentioned but not detailed: "Variables included but not specified: [category]"
- If only partial lists available: "Partial variable list extracted - additional controls may be included"
- If variables are aggregated: Extract what's available and note limitations

#### 6. KEY FINDINGS
- Summarize main conclusions about location choice patterns
- Note which variables were most important predictors (use exact variable names)
- Include any model performance metrics reported
- Highlight any findings specifically about spatial scale effects

#### 7. QUALITY ASSESSMENT
- **Complete**: All variables clearly listed with descriptions and sources
- **Partial**: Most variables described but some missing details
- **Limited**: Only partial variable information available
- Note specific information that could not be extracted

**If information is unclear:**
- If variable category is ambiguous, place in "OTHER VARIABLES"
- If exact variable names are not clear, note: "Variable names not clearly specified"
- If only partial variable lists are available, note: "Partial variable list - full details not provided in paper"

### ENHANCED EXAMPLE WITH MAXIMUM EXTRACTION

---

## STUDY IDENTIFICATION
**Title:** Where Do Offenders Choose to Attack? A Discrete Choice Model of Robberies in Chicago
**Year:** 2009
**Authors:** Wim Bernasco; Richard Block
**Filename:** Bernasco_Block_2009_Chicago_Robberies.pdf

## STUDY CONTEXT
**Country:** United States
**City/Region:** Chicago, Illinois
**Study Area Size:** 589 km² (total Chicago land area)
**Study Area Description:** All census tracts within Chicago city boundaries
**Crime Type:** Street robbery
**Crime Types (All):** Street robbery
**Study Period:** 1996-1998
**Data Sources:** Chicago Police Department; U.S. Census Bureau; Chicago Public Schools; Claritas marketing data; Project on Human Development in Chicago Neighborhoods

## SPATIAL UNIT OF ANALYSIS (SUoA)
**SUoA Type:** Census tracts
**SUoA Size:** Mean area 0.7 km² (varies 0.1-15 km²)
**SUoA Description:** 844 census tracts with average population of 3,200 residents
**Number of Units:** 844 census tracts
**Population per Unit:** Range 200-15,000 (mean: 3,200)
**Justification for SUoA Choice:** Lowest aggregation level for which collective efficacy data was available; appropriate scale for neighborhood social processes

## METHODOLOGY
**Study Design:** Cross-sectional  
**Statistical Method:** Conditional logit discrete choice model
**Model Type:** Conditional logit with random sampling of alternatives
**Software Used:** Stata
**Sampling Approach:** Random sample of 50 alternative census tracts per robbery event  
**Sample Size:** 6,000 robberies with 50 alternatives each (300,000 choice observations)
**Choice Set Definition:** 50 randomly selected census tracts from all 844 tracts per robbery
**Estimation Method:** Maximum likelihood estimation with robust standard errors

## COMPLETE INDIVIDUAL VARIABLE LIST

**DEMOGRAPHIC VARIABLES:**
1. POPDENS | Population per square kilometer | persons/km² | U.S. Census
2. ETHNIC_DIV | Ethnic diversity index (Herfindahl) | index 0-1 | U.S. Census  
3. AGE_STRUCTURE | Proportion aged 15-29 | percentage | U.S. Census

**ECONOMIC VARIABLES:**
1. CONCENTRATED_DISADV | Concentrated disadvantage factor score | z-score | Composite from Census
2. RETAIL_EMPLOY | Retail employment per 1000 residents | jobs/1000 pop | U.S. Census

**LAND USE VARIABLES:**
1. COMMERCIAL_LAND | Percentage commercial land use | percentage | City of Chicago

**INFRASTRUCTURE VARIABLES:**
[None explicitly mentioned]

**DISTANCE/ACCESSIBILITY VARIABLES:**  
1. DISTANCE | Distance from offender residence to tract centroid (log) | log(kilometers) | GIS calculation

**CRIME OPPORTUNITY VARIABLES:**
1. HIGH_SCHOOL | Presence of high school (binary) | binary 0/1 | Chicago Public Schools
2. DRUG_ARRESTS | Drug arrest rate per 1000 residents | arrests/1000 pop | Chicago Police Department
3. PROSTITUTION_ARRESTS | Prostitution arrest rate per 1000 residents | arrests/1000 pop | Chicago Police Department

**SOCIAL/BEHAVIORAL VARIABLES:**
1. COLLECTIVE_EFFICACY | Collective efficacy scale score | scale 1-5 | PHDCN survey data
2. IMMIGRANT_CONC | Immigrant concentration factor score | z-score | Composite from Census
3. RESIDENTIAL_STABILITY | Residential stability factor score | z-score | Composite from Census

**ENVIRONMENTAL VARIABLES:**
[None explicitly mentioned]

**TEMPORAL/CONTROL VARIABLES:**
1. GANG_DISSIMILARITY | Gang territorial dissimilarity index | index 0-1 | Chicago Police Department
2. RACIAL_DISSIMILARITY | Racial dissimilarity between offender and tract | index 0-1 | Calculated from Census and police data

**JURISDICTION/POLICY VARIABLES:**
[None explicitly mentioned]

**OTHER VARIABLES:**
[None]

## VARIABLE SUMMARY COUNTS
**Total Independent Variables:** 13
**Demographic Variables:** 3
**Economic Variables:** 2  
**Land Use Variables:** 1
**Infrastructure Variables:** 0
**Distance/Accessibility Variables:** 1
**Crime Opportunity Variables:** 3
**Social/Behavioral Variables:** 3
**Environmental Variables:** 0
**Temporal/Control Variables:** 2
**Jurisdiction/Policy Variables:** 0
**Other Variables:** 0

## KEY FINDINGS
**Main Results:** Offenders select locations close to home, with high crime opportunities (schools, drug activity), low collective efficacy, and racial/ethnic similarity to offender characteristics
**Significant Predictors:** DISTANCE (-), HIGH_SCHOOL (+), DRUG_ARRESTS (+), COLLECTIVE_EFFICACY (-), RACIAL_DISSIMILARITY (-), GANG_DISSIMILARITY (-)
**Model Performance:** Pseudo R² = 0.31; Log-likelihood = -15,842.3
**Scale Effects:** Census tract level appropriate for capturing neighborhood social processes; finer scales would lose collective efficacy measures

## DATA QUALITY NOTES
**Variable Information Quality:** Complete - comprehensive documentation in methodology and appendices
**Missing Information:** Infrastructure variables not included; environmental variables limited
**Extraction Confidence:** High - all variables clearly documented with sources and measurement details

---

### FINAL EXTRACTION CHECKLIST - MAXIMUM INFORMATION CAPTURE

Before submitting, verify you have:

**Tables & Data Sources Reviewed:**
- [ ] Scanned ALL regression tables (main results, robustness, appendix)
- [ ] Checked summary statistics tables for complete variable lists  
- [ ] Reviewed ALL appendices and supplementary materials
- [ ] Read every table footnote and note for variable definitions
- [ ] Searched for online appendices or supplementary data files

**Text-Based Variable Mining:**
- [ ] Read methodology section completely for variable descriptions
- [ ] Scanned all "control variables" and "covariates" mentions
- [ ] Found variables in data/variables section
- [ ] Checked introduction and conclusion for additional variable mentions
- [ ] Reviewed all footnotes for variable definitions

**Completeness Verification:**
- [ ] Variable counts match the individual variable lists exactly
- [ ] Every category has at least attempted extraction (mark [None] if truly empty)
- [ ] Combined information from multiple sources (tables + text + appendices)
- [ ] Noted when information is incomplete or missing
- [ ] Extracted maximum possible detail given available information

**Quality Assessment:**
- [ ] Honestly assessed information quality (Complete/Partial/Limited)
- [ ] Listed specific missing information
- [ ] Provided confidence level based on source quality and completeness

**Maximum Extraction Achieved:**
- [ ] Extracted variables from primary results tables
- [ ] Found additional variables in robustness checks  
- [ ] Captured control variables mentioned in text
- [ ] Identified variables from appendix tables
- [ ] Combined abbreviated and full variable names
- [ ] Noted transformations and measurement units
- [ ] Documented all data sources mentioned

This prompt ensures NO variable or detail is missed and creates a comprehensive, research-grade extraction that captures everything available in the paper.
