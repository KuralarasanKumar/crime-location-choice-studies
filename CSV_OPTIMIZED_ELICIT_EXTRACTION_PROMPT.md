# CSV-OPTIMIZED ELICIT EXTRACTION PROMPT
## Crime Location Choice Studies - Maximum Information Extraction

### CRITICAL INSTRUCTIONS FOR ELICIT AI
You are extracting information from academic papers about crime location choice. Your response MUST follow the EXACT numbered format below. Each numbered item will become a separate CSV column. Use the EXACT format: "FIELD_##: [extracted information]" where ## is the two-digit field number.

**RESPONSE FORMAT REQUIREMENTS:**
- Start each line with "FIELD_" followed by two-digit number and colon
- Use consistent separators: semicolons (;) for lists, pipe (|) for variable details
- If information is not available, write "FIELD_##: Not available" or "FIELD_##: Not specified"
- Do not skip field numbers - include every field 01-50 even if empty

### STRUCTURED EXTRACTION FORMAT - FIELDS 01-50

**BASIC STUDY INFORMATION (Fields 01-07):**
FIELD_01: [Study Title - Full paper title]
FIELD_02: [Publication Year - 4-digit year]
FIELD_03: [All Authors - Separated by semicolons]
FIELD_04: [Country - Where study was conducted]
FIELD_05: [City/Region - Specific location studied]
FIELD_06: [Crime Type - Primary crime analyzed]
FIELD_07: [Study Period - Years of data coverage]

**SPATIAL ANALYSIS DETAILS (Fields 08-12):**
FIELD_08: [Spatial Unit Type - e.g., Census tract, Grid cell, Block group]
FIELD_09: [Spatial Unit Size - With units, e.g., "0.5 km²", "500m x 500m"]
FIELD_10: [Number of Spatial Units - Total count]
FIELD_11: [Study Area Size - Total area with units]
FIELD_12: [Population per Unit - Average or range]

**METHODOLOGY (Fields 13-17):**
FIELD_13: [Study Design - Cross-sectional, longitudinal, etc.]
FIELD_14: [Statistical Method - Primary analytical approach]
FIELD_15: [Model Type - Specific model used]
FIELD_16: [Sample Size - Number of observations/events]
FIELD_17: [Software Used - Statistical software]

**VARIABLE COUNTS BY CATEGORY (Fields 18-29):**
FIELD_18: [Total Independent Variables - Number only]
FIELD_19: [Demographic Variables Count - Number only]
FIELD_20: [Economic Variables Count - Number only]
FIELD_21: [Land Use Variables Count - Number only]
FIELD_22: [Infrastructure Variables Count - Number only]
FIELD_23: [Distance/Accessibility Variables Count - Number only]
FIELD_24: [Crime Opportunity Variables Count - Number only]
FIELD_25: [Social/Behavioral Variables Count - Number only]
FIELD_26: [Environmental Variables Count - Number only]
FIELD_27: [Temporal/Control Variables Count - Number only]
FIELD_28: [Jurisdiction/Policy Variables Count - Number only]
FIELD_29: [Other Variables Count - Number only]

**COMPLETE VARIABLE LISTS (Fields 30-40):**
FIELD_30: [Demographic Variables - Variable1|Description1|Unit1|Source1; Variable2|Description2|Unit2|Source2; etc.]
FIELD_31: [Economic Variables - Variable1|Description1|Unit1|Source1; Variable2|Description2|Unit2|Source2; etc.]
FIELD_32: [Land Use Variables - Variable1|Description1|Unit1|Source1; Variable2|Description2|Unit2|Source2; etc.]
FIELD_33: [Infrastructure Variables - Variable1|Description1|Unit1|Source1; Variable2|Description2|Unit2|Source2; etc.]
FIELD_34: [Distance/Accessibility Variables - Variable1|Description1|Unit1|Source1; Variable2|Description2|Unit2|Source2; etc.]
FIELD_35: [Crime Opportunity Variables - Variable1|Description1|Unit1|Source1; Variable2|Description2|Unit2|Source2; etc.]
FIELD_36: [Social/Behavioral Variables - Variable1|Description1|Unit1|Source1; Variable2|Description2|Unit2|Source2; etc.]
FIELD_37: [Environmental Variables - Variable1|Description1|Unit1|Source1; Variable2|Description2|Unit2|Source2; etc.]
FIELD_38: [Temporal/Control Variables - Variable1|Description1|Unit1|Source1; Variable2|Description2|Unit2|Source2; etc.]
FIELD_39: [Jurisdiction/Policy Variables - Variable1|Description1|Unit1|Source1; Variable2|Description2|Unit2|Source2; etc.]
FIELD_40: [Other Variables - Variable1|Description1|Unit1|Source1; Variable2|Description2|Unit2|Source2; etc.]

**DATA SOURCES & QUALITY (Fields 41-50):**
FIELD_41: [Data Sources - All sources separated by semicolons]
FIELD_42: [Key Findings - Brief summary of main results]
FIELD_43: [Significant Predictors - Variables with significant effects]
FIELD_44: [Model Performance - R², log-likelihood, or other fit measures]
FIELD_45: [Variable Information Quality - Complete/Partial/Limited]
FIELD_46: [Missing Information - What could not be extracted]
FIELD_47: [Extraction Confidence - High/Medium/Low]
FIELD_48: [Additional Notes - Any other relevant information]
FIELD_49: [Data Collection Method - How crime data was obtained]
FIELD_50: [Validation Methods - How results were validated or tested]

### DETAILED EXTRACTION INSTRUCTIONS

#### MAXIMUM VARIABLE EXTRACTION STRATEGY

**CRITICAL: You MUST read ALL of these sections in the paper:**

**PRIMARY EXTRACTION SOURCES (Read Intensively):**
1. **ALL TABLES** - Regression results, summary statistics, correlation matrices, appendix tables
2. **Methods/Methodology Section** - Variable definitions and construction
3. **Data Section** - Data sources and variable descriptions
4. **Results Section** - All tables and their footnotes
5. **Appendices** - Often contain complete variable lists and definitions

**SECONDARY SOURCES (Don't Miss):**
6. **Abstract** - Key variable mentions
7. **Introduction** - Important controls referenced
8. **Literature Review** - Variables from previous studies
9. **Discussion/Conclusion** - Variables mentioned in interpretation
10. **Footnotes** - Variable definitions often hidden here
11. **Table Notes** - Detailed variable descriptions
12. **Figure Captions** - Variable definitions for maps/charts

#### VARIABLE CATEGORIZATION GUIDE

**1. DEMOGRAPHIC VARIABLES:**
Population characteristics, age, gender, race/ethnicity, education, household composition
*Examples: population density, % under 18, % college educated, % Hispanic, household size*

**2. ECONOMIC VARIABLES:**
Income, employment, poverty, business activity, property values, economic indicators
*Examples: median income, unemployment rate, poverty rate, property values, business density*

**3. LAND USE VARIABLES:**
Zoning, development patterns, residential/commercial/industrial mix, density
*Examples: % commercial area, residential density, % green space, building height, mixed-use*

**4. INFRASTRUCTURE VARIABLES:**
Transportation, utilities, public facilities, built environment
*Examples: road density, public transit access, parking, street lighting, utilities*

**5. DISTANCE/ACCESSIBILITY VARIABLES:**
Spatial relationships, travel costs, connectivity, centrality
*Examples: distance to CBD, travel time, accessibility index, network centrality*

**6. CRIME OPPORTUNITY VARIABLES:**
Target availability, guardianship, visibility, activity patterns
*Examples: target density, foot traffic, cash businesses, nightlife, guardianship*

**7. SOCIAL/BEHAVIORAL VARIABLES:**
Social organization, community characteristics, routine activities
*Examples: social cohesion, collective efficacy, residential stability, civic participation*

**8. ENVIRONMENTAL VARIABLES:**
Physical environment, natural features, climate, geography
*Examples: terrain, vegetation, water bodies, climate, environmental quality*

**9. TEMPORAL/CONTROL VARIABLES:**
Time effects, spatial controls, model controls, interactions
*Examples: time trends, seasonal effects, spatial lags, fixed effects, interactions*

**10. JURISDICTION/POLICY VARIABLES:**
Administrative boundaries, policies, law enforcement
*Examples: police presence, policy changes, jurisdictional controls, enforcement levels*

#### VARIABLE FORMAT REQUIREMENTS

For Fields 30-40 (Variable Lists), use this EXACT format:
`VariableName|Description|Unit|DataSource; NextVariable|Description|Unit|DataSource`

**Examples:**
- `POPDENS|Population density|persons/km²|Census; MEDINC|Median income|dollars|ACS`
- `DISTCBD|Distance to CBD|kilometers|GIS; HIGHWAY|Highway access|binary|GIS`

#### EXTRACTION RULES

**DO Extract:**
✓ ALL variables from ANY table with coefficients or statistics
✓ Variables mentioned in methods even if not in tables
✓ Control variables, fixed effects, interaction terms
✓ Variables from robustness checks and appendices
✓ Transformed variables (log, square root, per capita)
✓ Variables marked as "not significant"

**DON'T Extract:**
✗ Dependent variables (crime rates, choice outcomes)
✗ Model statistics (R², AIC, sample size)
✗ Test statistics or p-values

**Handle Missing Information:**
- If variables mentioned but not detailed: "Variables included but not specified"
- If only abbreviations given: Extract abbreviations and note "Full definitions not provided"
- If partial information: Extract what's available and note limitations in FIELD_46

### EXAMPLE OUTPUT FORMAT

```
FIELD_01: Spatial Choice of Crime: A Case Study of Residential Burglary in Chicago
FIELD_02: 2008
FIELD_03: John Smith; Jane Doe; Robert Johnson
FIELD_04: United States
FIELD_05: Chicago, Illinois
FIELD_06: Residential burglary
FIELD_07: 2001-2005
FIELD_08: Census tracts
FIELD_09: 0.8 km² average
FIELD_10: 865
FIELD_11: 590 km²
FIELD_12: 3,200 average
FIELD_13: Cross-sectional
FIELD_14: Conditional logit
FIELD_15: Discrete choice model
FIELD_16: 12,000 burglaries
FIELD_17: Stata
FIELD_18: 15
FIELD_19: 4
FIELD_20: 3
FIELD_21: 2
FIELD_22: 1
FIELD_23: 2
FIELD_24: 1
FIELD_25: 2
FIELD_26: 0
FIELD_27: 0
FIELD_28: 0
FIELD_29: 0
FIELD_30: POPDENS|Population density|persons/km²|Census; PCTUNDER18|Percent under 18|percentage|Census; PCTHISP|Percent Hispanic|percentage|Census; PCTEDU|Percent college educated|percentage|ACS
FIELD_31: MEDINC|Median household income|dollars|ACS; UNEMPRATE|Unemployment rate|percentage|BLS; PCTPOV|Poverty rate|percentage|Census
FIELD_32: PCTCOMM|Percent commercial land|percentage|City planning; RESDENS|Residential density|units/km²|Assessor
FIELD_33: ROADDENS|Road density|km/km²|GIS
FIELD_34: DISTCBD|Distance to CBD|kilometers|GIS; ACCJOBS|Job accessibility index|index|GIS
FIELD_35: CASHBUS|Cash businesses per km²|count/km²|Business directory
FIELD_36: COLLEFF|Collective efficacy|scale 1-5|Survey; RESSTAB|Residential stability|factor score|Census
FIELD_37: Not available
FIELD_38: Not available
FIELD_39: Not available
FIELD_40: Not available
FIELD_41: U.S. Census; American Community Survey; Chicago Police Department; City planning department; Bureau of Labor Statistics
FIELD_42: Burglars prefer areas close to home with low collective efficacy and high residential density
FIELD_43: DISTCBD; COLLEFF; RESDENS; MEDINC; POPDENS
FIELD_44: Pseudo R² = 0.24
FIELD_45: Complete
FIELD_46: Environmental and temporal variables not included
FIELD_47: High
FIELD_48: Study uses 20 alternatives per choice set
FIELD_49: Police incident reports
FIELD_50: Cross-validation with separate time periods
```

### QUALITY CONTROL CHECKLIST

Before submitting, verify:
- [ ] All fields 01-50 are included with "FIELD_##:" prefix
- [ ] Used semicolons (;) to separate list items
- [ ] Used pipes (|) to separate variable details
- [ ] Read ALL tables, appendices, and methodology sections
- [ ] Extracted maximum possible variables from all sources
- [ ] Counted variables accurately
- [ ] Noted missing information honestly
- [ ] Used exact format for variable lists

**Remember: This extraction will be parsed programmatically, so EXACT format compliance is critical for successful CSV integration.**
