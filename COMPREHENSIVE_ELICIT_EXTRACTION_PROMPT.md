# COMPREHENSIVE CRIME LOCATION CHOICE STUDY EXTRACTION PROMPT
## Extract ALL Required Information in One Structured Output

### TASK OBJECTIVE
Extract comprehensive information from crime location choice studies including study characteristics, methodology, spatial units, variables, and findings in a single structured format.

### COMPLETE EXTRACTION TEMPLATE
For each study, provide ALL information in this exact structured format:

---

## STUDY IDENTIFICATION
**Title:** [Full paper title]
**Year:** [Publication year]
**Authors:** [All authors, separated by semicolons]
**Journal:** [Journal name]
**DOI:** [DOI if available]
**Filename:** [PDF filename]

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

## COMPLETE VARIABLE LIST
**DEMOGRAPHIC VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. 
2. 
[Continue for all demographic variables...]

**ECONOMIC VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. 
2. 
[Continue for all economic variables...]

**LAND USE VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. 
2. 
[Continue for all land use variables...]

**INFRASTRUCTURE VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. 
2. 
[Continue for all infrastructure variables...]

**DISTANCE/ACCESSIBILITY VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. 
2. 
[Continue for all distance/accessibility variables...]

**CRIME OPPORTUNITY VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. 
2. 
[Continue for all crime opportunity variables...]

**SOCIAL/BEHAVIORAL VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. 
2. 
[Continue for all social/behavioral variables...]

**ENVIRONMENTAL VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. 
2. 
[Continue for all environmental variables...]

**TEMPORAL/CONTROL VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. 
2. 
[Continue for all temporal/control variables...]

**OTHER VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. 
2. 
[Continue for all other variables that don't fit the above 8 categories...]

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
**Other Variables:** [Number]

---

## KEY FINDINGS
**Main Results:** [Brief summary of key findings about location choice]
**Significant Predictors:** [Variables that were statistically significant]
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
- **Crime Type**: Be specific (e.g., "burglary" not just "property crime")
- **Study Period**: Extract exact years of data collection
- **Data Sources**: Include all mentioned sources (census, police records, GIS databases, etc.)

#### 3. SPATIAL UNIT OF ANALYSIS
- **SUoA Size**: Extract exact dimensions or area measurements
- **SUoA Description**: Include details about unit boundaries, how they were defined
- **Number of Units**: Total count of spatial units analyzed
- **Population per Unit**: Average population or range if provided
- **Justification**: Look for explicit reasons why this spatial scale was chosen

#### 4. METHODOLOGY
- **Statistical Method**: Be specific about model type and estimation approach
- **Sampling Approach**: How were choice sets constructed? Random sampling? All units?
- **Sample Size**: Number of choice observations, not just spatial units
- **Choice Set Definition**: How many alternatives per choice set? How were they selected?

#### 5. VARIABLE EXTRACTION
**Where to look for variables:**
- Methods/Data section
- Model specification equations
- Results tables (especially regression tables)
- Variable description appendices
- Summary statistics tables

**Variable categorization guidelines (9 categories):**
- **Demographic**: Population density, age structure, gender ratios, household composition, education, ethnicity
- **Economic**: Income, employment, poverty, business density, property values, retail activity, economic indicators
- **Land Use**: Residential density, commercial area, industrial area, green space, mixed-use, zoning
- **Infrastructure**: Road density, public transport, parking, lighting, building types, utilities
- **Distance/Accessibility**: Distance to CBD, transport hubs, accessibility indices, travel time, centrality
- **Crime Opportunity**: Target density, guardianship, visibility, foot traffic, activity patterns, attractors
- **Social/Behavioral**: Social cohesion, collective efficacy, mobility patterns, routine activities, social capital
- **Environmental**: Physical environment, weather, terrain, natural features, environmental quality
- **Temporal/Control**: Time effects, seasonal controls, spatial lags, jurisdictional dummies, interaction terms

**Variable format:**
For each variable, provide: `Variable_Name | Description | Unit | Data_Source`

Examples:
- `POP_DENSITY | Population per square kilometer | persons/km² | Census`
- `MEDIAN_INC | Median household income (log-transformed) | log(dollars) | ACS`
- `DIST_CBD | Distance to central business district | kilometers | GIS calculation`

#### 6. KEY FINDINGS
- Summarize main conclusions about location choice patterns
- Note which variables were most important predictors
- Include any model performance metrics reported
- Highlight any findings specifically about spatial scale effects

#### 7. QUALITY ASSESSMENT
- **Complete**: All variables clearly listed with descriptions
- **Partial**: Most variables described but some missing details
- **Limited**: Only partial variable information available
- Note specific information that could not be extracted

### EXAMPLE OUTPUT

---

## STUDY IDENTIFICATION
**Title:** Residential Burglary Location Choice: A Discrete Choice Analysis of Spatial Risk Factors
**Year:** 2020
**Authors:** Smith, J.A.; Johnson, M.B.; Williams, R.C.
**Journal:** Journal of Quantitative Criminology
**DOI:** 10.1007/s10940-020-12345-6
**Filename:** Smith_et_al_2020_Burglary_Choice.pdf

## STUDY CONTEXT
**Country:** United States
**City/Region:** Chicago, Illinois
**Study Area Size:** 589 km²
**Study Area Description:** City of Chicago municipal boundaries
**Crime Type:** Residential burglary
**Crime Types (All):** Residential burglary
**Study Period:** 2015-2017
**Data Sources:** Chicago Police Department; U.S. Census Bureau; American Community Survey; City of Chicago GIS

## SPATIAL UNIT OF ANALYSIS (SUoA)
**SUoA Type:** Census block groups
**SUoA Size:** Varies 0.1-2.5 km² (mean: 0.8 km²)
**SUoA Description:** Census-defined block groups containing 600-3000 people
**Number of Units:** 2,847 block groups
**Population per Unit:** 600-3000 residents (mean: 1,200)
**Justification for SUoA Choice:** Balance between spatial detail and statistical reliability; matches available demographic data

## METHODOLOGY
**Study Design:** Cross-sectional
**Statistical Method:** Conditional logit model
**Model Type:** Conditional logit with spatial lag
**Software Used:** R (mlogit package)
**Sampling Approach:** Random sampling of 50 alternatives per burglary event
**Sample Size:** 15,000 choice observations (300 burglaries × 50 alternatives)
**Choice Set Definition:** 50 randomly selected block groups within 5km of each burglary
**Estimation Method:** Maximum likelihood estimation

## COMPLETE VARIABLE LIST
**DEMOGRAPHIC VARIABLES:**
1. POP_DENSITY | Population per square kilometer | persons/km² | Census
2. PCT_YOUNG | Percentage population aged 15-24 | percentage | ACS
3. PCT_ELDERLY | Percentage population aged 65+ | percentage | ACS

**ECONOMIC VARIABLES:**
1. MEDIAN_INC | Median household income (log-transformed) | log(dollars) | ACS
2. POVERTY_RATE | Percentage below poverty line | percentage | ACS
3. UNEMP_RATE | Unemployment rate | percentage | ACS

**LAND USE VARIABLES:**
1. RES_DENSITY | Residential units per km² | units/km² | City GIS
2. COMM_AREA | Commercial area percentage | percentage | City GIS

**INFRASTRUCTURE VARIABLES:**
1. ROAD_DENSITY | Road length per km² | km/km² | City GIS

**DISTANCE/ACCESSIBILITY VARIABLES:**
1. DIST_CBD | Distance to central business district | kilometers | GIS calculation
2. ACCESS_HIGHWAY | Distance to nearest highway | kilometers | GIS calculation

**CRIME OPPORTUNITY VARIABLES:**
1. TARGET_DENSITY | Single-family homes per km² | homes/km² | City GIS

**SOCIAL/BEHAVIORAL VARIABLES:**
1. SOC_DISORG | Social disorganization index | index 0-10 | Composite measure

**TEMPORAL/CONTROL VARIABLES:**
1. SPATIAL_LAG | Spatial lag of burglary rate | events/km² | Calculated

**OTHER VARIABLES:**
[None]

## VARIABLE SUMMARY COUNTS
**Total Independent Variables:** 12
**Demographic Variables:** 3
**Economic Variables:** 3
**Land Use Variables:** 2
**Infrastructure Variables:** 1
**Distance/Accessibility Variables:** 2
**Crime Opportunity Variables:** 1
**Social/Behavioral Variables:** 1
**Environmental Variables:** 0
**Temporal/Control Variables:** 1
**Other Variables:** 0

## KEY FINDINGS
**Main Results:** Burglars prefer areas with higher target density, lower income, and moderate accessibility
**Significant Predictors:** TARGET_DENSITY (+), MEDIAN_INC (-), DIST_CBD (curvilinear), SOC_DISORG (+)
**Model Performance:** Pseudo R² = 0.35, Log-likelihood = -8,245
**Scale Effects:** Block group level provides optimal balance between detail and model stability

## DATA QUALITY NOTES
**Variable Information Quality:** Complete
**Missing Information:** None - all variables well documented
**Extraction Confidence:** High

---

### QUALITY CHECK BEFORE SUBMISSION
Verify you have extracted:
- [ ] Complete bibliographic information
- [ ] All study context details (location, crime type, time period)
- [ ] Exact spatial unit specifications with sizes
- [ ] Complete methodology including sampling approach
- [ ] Every individual variable with name, description, unit, and source
- [ ] Accurate variable counts that match the individual lists
- [ ] Key findings and model performance metrics
- [ ] Assessment of information quality and any missing details

This format ensures all critical information is captured in one comprehensive extraction that can be directly converted into our final dataset.
