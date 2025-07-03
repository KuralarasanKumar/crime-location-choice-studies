# RESEARCH QUESTIONS MAPPING TO EXTRACTION FIELDS
## How the Comprehensive Elicit Prompt Addresses All Research Questions

### RESEARCH QUESTION 1: Distribution of SUoA Size Across Studies
**What is the distribution of the size of SUoA across the N selected studies?**

**Extracted Fields:**
- `SUoA Size` - Exact size with units (e.g., "500m x 500m", "0.25 km²", "varies 0.1-2.5 km²")
- `SUoA Description` - Detailed description of spatial units
- `Number of Units` - Total count of spatial units

**Analysis Capability:** ✅ COMPLETE
- Can calculate size distribution, mean, median, range
- Can standardize all sizes to km² for comparison
- Can create histograms and summary statistics

---

### RESEARCH QUESTION 2: SUoA Size Change Over Time
**Does the size of the SUoA change over calendar time? (Getting smaller in recent studies?)**

**Extracted Fields:**
- `Year` - Publication year
- `SUoA Size` - Exact size measurements
- `Study Period` - Years of data collection

**Analysis Capability:** ✅ COMPLETE
- Can plot SUoA size vs publication year
- Can test temporal trends with regression
- Can compare pre/post specific years (e.g., 2010, 2015)

---

### RESEARCH QUESTION 3: SUoA Size by Jurisdiction
**Does the size of the SUoA vary by jurisdiction? (Smaller in Anglo-Saxon/industrialized countries?)**

**Extracted Fields:**
- `Country` - Country where study conducted
- `City/Region` - Specific location
- `SUoA Size` - Size measurements

**Analysis Capability:** ✅ COMPLETE
- Can group by country/region
- Can classify into Anglo-Saxon vs other, industrialized vs developing
- Can compare mean SUoA sizes across jurisdictions

---

### RESEARCH QUESTION 4: SUoA Size by Crime Type
**Does the size of the SUoA vary by crime type studied?**

**Extracted Fields:**
- `Crime Type` - Primary crime type analyzed
- `Crime Types (All)` - All crime types if multiple
- `SUoA Size` - Size measurements

**Analysis Capability:** ✅ COMPLETE
- Can group by crime type (burglary, robbery, theft, etc.)
- Can compare SUoA sizes across different crime types
- Can handle studies with multiple crime types

---

### RESEARCH QUESTION 5: SUoA Size by Total Study Area
**Does the size of the SUoA vary by size of total study area? (Smaller areas → smaller SUoA?)**

**Extracted Fields:**
- `Study Area Size` - Total area in km²
- `Study Area Description` - Geographic scope details
- `SUoA Size` - Individual unit size

**Analysis Capability:** ✅ COMPLETE
- Can calculate correlation between total area and SUoA size
- Can create scatter plots and test relationships
- Can control for other factors in regression models

---

### RESEARCH QUESTION 6: SUoA Size and Discrete Choice Methods
**Is SUoA size related to discrete choice methods? (Smaller SUoA → sampling tricks, different logit models?)**

**Extracted Fields:**
- `Statistical Method` - Primary analytical method
- `Model Type` - Specific discrete choice model type
- `Sampling Approach` - How alternatives were sampled
- `Choice Set Definition` - How choice sets were constructed
- `Sample Size` - Number of observations
- `SUoA Size` - Unit size

**Analysis Capability:** ✅ COMPLETE
- Can test relationship between SUoA size and:
  - Use of sampling vs full choice sets
  - Model complexity (multinomial vs mixed vs latent class logit)
  - Sample size and choice set size
- Can identify methodological adaptations for smaller units

---

### RESEARCH QUESTION 7: SUoA Size and Variable Types
**Is SUoA size related to types/number of independent variables? (Fewer variables at finer scales?)**

**Extracted Fields:**
- **Complete Individual Variable Lists** - Every variable with category
- **Variable Summary Counts** - Counts by category:
  - Total Independent Variables
  - Demographic Variables
  - Economic Variables
  - Land Use Variables
  - Infrastructure Variables
  - Distance/Accessibility Variables
  - Crime Opportunity Variables
  - Social/Behavioral Variables
  - Environmental Variables
  - Temporal/Control Variables
- `Data Sources` - Where variables came from
- `SUoA Size` - Unit size

**Analysis Capability:** ✅ COMPLETE
- Can test correlation between SUoA size and:
  - Total number of variables
  - Number of variables by category
  - Variable diversity (number of categories used)
- Can identify which variable types are limited at finer scales
- Can analyze data source constraints at different scales

---

## ADDITIONAL RESEARCH CAPABILITIES ENABLED

### Scale Justification Analysis
**Extracted Fields:**
- `Justification for SUoA Choice` - Explicit reasons for scale selection

**New Research Questions:**
- What justifications do authors give for SUoA choices?
- Are smaller scales justified differently than larger scales?

### Data Availability Constraints
**Extracted Fields:**
- `Data Sources` - All data sources used
- Variable-level `Data_Source` information

**New Research Questions:**
- How do data availability constraints influence SUoA choice?
- Which data sources enable finer-scale analysis?

### Model Performance by Scale
**Extracted Fields:**
- `Model Performance` - R-squared, log-likelihood, AIC/BIC
- `Key Findings` - Results about scale effects

**New Research Questions:**
- Do models perform better at certain spatial scales?
- What scale effects do authors report?

---

## COMPREHENSIVE ANALYSIS PLAN

With the extracted data, you can perform:

### 1. **Descriptive Analysis**
- SUoA size distributions, trends, and patterns
- Cross-tabulations by country, crime type, time period

### 2. **Correlation Analysis**
- SUoA size vs total study area
- SUoA size vs variable counts (total and by category)
- SUoA size vs methodological choices

### 3. **Regression Models**
- Predict SUoA size from study characteristics
- Control for multiple factors simultaneously
- Test interaction effects

### 4. **Temporal Analysis**
- Time trends in SUoA size
- Changes in methodological approaches over time

### 5. **Comparative Analysis**
- Cross-country comparisons
- Crime type comparisons
- Methodological approach comparisons

---

## CONCLUSION

The comprehensive Elicit prompt will extract **ALL** the information needed to answer every research question completely. The structured format ensures:

✅ **Complete Coverage** - Every research question addressed
✅ **Quantitative Analysis** - Exact measurements for statistical testing
✅ **Categorical Analysis** - Proper groupings for comparisons
✅ **Temporal Analysis** - Time trends and changes
✅ **Methodological Analysis** - Relationship between scale and methods
✅ **Variable Analysis** - Detailed variable information by category

This single comprehensive extraction will provide a publication-ready dataset for your spatial unit of analysis research.
