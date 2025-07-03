# COMPREHENSIVE CRIME LOCATION CHOICE STUDY EXTRACTION PROMPT
## Extract ALL Required Information in One Complete Structured Output

### TASK OBJECTIVE
Extract comprehensive information from crime location choice studies including study characteristics, methodology, spatial units, complete individual variable lists, and findings in a single structured format that answers ALL research questions.

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

**OTHER VARIABLES:**
[List each variable: Variable_Name | Description | Unit | Data_Source]
1. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
2. [Exact name as used in paper] | [Brief description] | [measurement unit if available] | [data source]
[Continue for all other variables that don't fit the above 9 categories...]

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

#### 5. COMPLETE VARIABLE EXTRACTION

**Where to look for variables:**
- Methods/Methodology section
- Data and Variables section
- Model specification equations
- Results tables (especially regression tables)
- Variable description appendices
- Summary statistics tables

**Variable naming conventions:**
- Use the EXACT variable name as it appears in the paper
- If the paper uses abbreviations, include both full name and abbreviation
- If only abbreviations are given, provide them as-is

**Variable categorization guidelines (9 categories):**
- **Demographic**: Population density, age structure, gender ratios, household composition, education levels, ethnicity
- **Economic**: Income, employment rates, poverty rates, business density, property values, retail activity, economic indicators
- **Land Use**: Residential density, commercial area, industrial area, green space, mixed-use development, zoning
- **Infrastructure**: Road density, public transportation, parking availability, lighting, building types, utilities
- **Distance/Accessibility**: Distance to CBD, distance to transport hubs, accessibility indices, travel time, centrality measures
- **Crime Opportunity**: Target density, guardianship measures, visibility, foot traffic, activity patterns, crime attractors
- **Social/Behavioral**: Social cohesion, collective efficacy, mobility patterns, routine activities, social capital
- **Environmental**: Physical environment, weather, terrain, natural features, environmental quality, geographic barriers
- **Temporal/Control**: Time effects, seasonal controls, spatial lag variables, jurisdictional dummies, interaction terms

**Variable format requirements:**
For each variable, provide: `Variable_Name | Description | Unit | Data_Source`

Examples:
- `POP_DENSITY | Population per square kilometer | persons/km² | U.S. Census`
- `MEDIAN_INC | Median household income (log-transformed) | log(dollars) | American Community Survey`
- `DIST_CBD | Distance to central business district | kilometers | GIS calculation`
- `UNEMP_RATE | Unemployment rate | percentage | Bureau of Labor Statistics`

**What to include:**
- ALL independent variables used in the main models
- Control variables and fixed effects
- Interaction terms and transformed variables
- Spatial lag variables if used
- Dummy variables and categorical indicators

**What to exclude:**
- Dependent variables (crime counts, choice outcomes)
- Model diagnostics or goodness-of-fit measures
- Variables mentioned but not actually used in analysis

**Units and descriptions:**
- Include measurement units when available (%, per km², log-transformed, binary 0/1, index 0-10, etc.)
- Provide brief but clear descriptions of what each variable measures
- Note if variables are continuous, categorical, or binary
- Include data transformation information (log, square root, standardized, etc.)

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

### EXAMPLE COMPLETE OUTPUT

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
**Data Sources:** Chicago Police Department; U.S. Census Bureau; American Community Survey; City of Chicago GIS; NAVTEQ street network data

## SPATIAL UNIT OF ANALYSIS (SUoA)
**SUoA Type:** Census block groups
**SUoA Size:** Varies 0.1-2.5 km² (mean: 0.8 km²)
**SUoA Description:** Census-defined block groups containing 600-3000 people with natural boundaries
**Number of Units:** 2,847 block groups
**Population per Unit:** 600-3000 residents (mean: 1,200)
**Justification for SUoA Choice:** Balance between spatial detail and statistical reliability; matches available demographic data; appropriate scale for neighborhood effects

## METHODOLOGY
**Study Design:** Cross-sectional
**Statistical Method:** Conditional logit model with spatial lag
**Model Type:** Conditional logit with spatial autocorrelation correction
**Software Used:** R (mlogit package, spdep package)
**Sampling Approach:** Random sampling of 50 alternatives per burglary event
**Sample Size:** 15,000 choice observations (300 burglaries × 50 alternatives)
**Choice Set Definition:** 50 randomly selected block groups within 5km radius of each burglary location
**Estimation Method:** Maximum likelihood estimation with robust standard errors

## COMPLETE INDIVIDUAL VARIABLE LIST

**DEMOGRAPHIC VARIABLES:**
1. POP_DENSITY | Population per square kilometer | persons/km² | U.S. Census
2. PCT_YOUNG | Percentage of population aged 15-24 | percentage | American Community Survey
3. PCT_ELDERLY | Percentage of population aged 65 and over | percentage | American Community Survey
4. HOUSEHOLD_SIZE | Average number of persons per household | persons | American Community Survey
5. PCT_COLLEGE | Percentage with college education or higher | percentage | American Community Survey

**ECONOMIC VARIABLES:**
1. MEDIAN_INC | Median household income (log-transformed) | log(dollars) | American Community Survey
2. POVERTY_RATE | Percentage of households below poverty line | percentage | American Community Survey
3. UNEMP_RATE | Unemployment rate | percentage | American Community Survey
4. GINI_COEFF | Income inequality (Gini coefficient) | index 0-1 | American Community Survey

**LAND USE VARIABLES:**
1. RES_DENSITY | Residential units per square kilometer | units/km² | City of Chicago GIS
2. COMM_AREA | Commercial land use percentage | percentage | City of Chicago GIS
3. PARK_AREA | Public park and recreation area percentage | percentage | Chicago Park District

**INFRASTRUCTURE VARIABLES:**
1. ROAD_DENSITY | Total road length per square kilometer | km/km² | NAVTEQ street data
2. BUS_STOPS | Number of bus stops per square kilometer | stops/km² | Chicago Transit Authority

**DISTANCE/ACCESSIBILITY VARIABLES:**
1. DIST_CBD | Distance to central business district (Loop) | kilometers | GIS calculation
2. DIST_HIGHWAY | Distance to nearest highway entrance | kilometers | GIS calculation
3. ACCESS_INDEX | Public transportation accessibility index | index 0-10 | Calculated from CTA data

**CRIME OPPORTUNITY VARIABLES:**
1. TARGET_DENSITY | Single-family detached homes per square kilometer | homes/km² | City of Chicago GIS
2. STREET_LIGHTING | Average street lighting density | lights/km² | City of Chicago Department of Transportation

**SOCIAL/BEHAVIORAL VARIABLES:**
1. SOC_DISORG | Social disorganization index | index 0-10 | Composite measure from census data
2. RESIDENTIAL_STAB | Residential stability index | index 0-10 | Calculated from ACS mobility data

**ENVIRONMENTAL VARIABLES:**
1. TREE_COVER | Percentage of area covered by tree canopy | percentage | USGS National Land Cover Database

**TEMPORAL/CONTROL VARIABLES:**
1. SPATIAL_LAG | Spatial lag of burglary rate | events/km² | Calculated using queen contiguity
2. WEEKEND_DUMMY | Weekend occurrence indicator | binary 0/1 | Calculated from incident data

**OTHER VARIABLES:**
[None]

## VARIABLE SUMMARY COUNTS
**Total Independent Variables:** 18
**Demographic Variables:** 5
**Economic Variables:** 4
**Land Use Variables:** 3
**Infrastructure Variables:** 2
**Distance/Accessibility Variables:** 3
**Crime Opportunity Variables:** 2
**Social/Behavioral Variables:** 2
**Environmental Variables:** 1
**Temporal/Control Variables:** 2
**Other Variables:** 0

## KEY FINDINGS
**Main Results:** Burglars prefer areas with higher target density, lower median income, moderate accessibility to highways, and lower social organization
**Significant Predictors:** TARGET_DENSITY (+), MEDIAN_INC (-), DIST_HIGHWAY (curvilinear), SOC_DISORG (+), SPATIAL_LAG (+), ACCESS_INDEX (+)
**Model Performance:** Pseudo R² = 0.35, Log-likelihood = -8,245.3, AIC = 16,526.6
**Scale Effects:** Block group level provides optimal balance between spatial detail and model stability; finer scales (blocks) had insufficient variation in key variables

## DATA QUALITY NOTES
**Variable Information Quality:** Complete
**Missing Information:** None - all variables comprehensively documented with sources and transformations
**Extraction Confidence:** High

---

### QUALITY CHECK BEFORE SUBMISSION
Verify you have extracted:
- [ ] Complete bibliographic information including all authors
- [ ] All study context details (location, crime type, exact time period, data sources)
- [ ] Exact spatial unit specifications with precise sizes and justifications
- [ ] Complete methodology including sampling approach and model specifications
- [ ] Every individual variable with exact name, description, unit, and data source
- [ ] Accurate variable counts that match the individual lists exactly
- [ ] Key findings with specific variable names and model performance metrics
- [ ] Honest assessment of information quality and any missing details

This format ensures ALL critical information is captured in one comprehensive extraction that directly answers every research question and provides a complete, publication-ready dataset.
