# Improved Elicit Prompt for SUoA Crime Location Choice Studies

Based on our automated PDF extraction analysis, here's an enhanced prompt that prioritizes the most critical information and addresses common extraction challenges:

## CRITICAL INFORMATION (Always extract these)

**1. Spatial Unit of Analysis (SUoA) Details:**
- Exact size of spatial unit (provide number + unit: m², km², hectares)
- Type of spatial unit (grid cell, census block, street segment, administrative boundary, etc.)
- Total number of spatial units in choice set
- Study area coverage (total km² or description like "entire city of Chicago")

**2. Statistical Methodology:**
- Primary discrete choice model type: conditional/multinomial logit, mixed logit, latent class logit, nested logit, probit, other
- Alternative sampling strategy (CRITICAL): full choice set, random sampling, stratified sampling, importance sampling, or other sampling method
- Sample size/number of choice occasions (how many decisions/observations analyzed)
- Software used for analysis (R, Stata, Python/Biogeme, SAS, etc.)

**3. Study Context:**
- Data collection year(s) or study period
- Country and specific city/region
- Crime type(s) analyzed (be specific: residential burglary, street robbery, drug dealing, etc.)

**4. Variable Information (Very Important):**
- Total number of independent variables in final model
- List key variable categories with counts where possible:
  * Demographic variables (population, age, income, etc.)
  * Economic variables (unemployment, property values, etc.)
  * Land use/physical environment (commercial density, parks, etc.)
  * Infrastructure (transportation, lighting, etc.)
  * Distance measures (to highways, city center, etc.)
  * Crime opportunity variables (previous crimes, guardianship, etc.)
  * Social disorganization variables (social cohesion, etc.)

## IMPORTANT METHODOLOGICAL DETAILS

**5. Scale Justification:**
- Is the choice of spatial unit size explicitly justified? (Yes/No)
- What reasoning is provided? (theoretical, data availability, computational, previous studies, etc.)
- Any mention of sensitivity testing with different unit sizes?

**6. Data Sources:**
- Primary data sources (police records, census, administrative data, surveys, etc.)
- Any mention of data aggregation methods or temporal aggregation

**7. Model Performance & Limitations:**
- Any convergence issues or computational challenges mentioned?
- Model fit statistics reported? (pseudo R², log-likelihood, etc.)
- Limitations related to spatial unit choice discussed?

## ENHANCED EXTRACTION GUIDELINES

**For Variables:** Look for phrases like "X variables," "X covariates," "X predictors," or tables listing variables. Pay attention to methodology sections and results tables.

**For Sampling:** Look carefully for mentions of "sampling," "subset," "random selection," or discussions of computational burden with large choice sets. Note if choice set size > 1000 units.

**For Scale Justification:** Search for discussions of "why," "rationale," "theoretical," or "methodological considerations" related to unit selection.

**For Model Type:** Look for specific technique names in methodology sections, not just "discrete choice" or "logit" generically.

**For Sample Size:** Distinguish between number of spatial units (choice set size), number of choice occasions/decisions, and number of individual offenders.

## QUALITY CONTROL NOTES

- If information is unclear or contradictory, note "UNCLEAR" rather than guessing
- For variable counts, prefer explicit numbers over estimates
- Note if study uses multiple models or sensitivity analyses
- Flag any unusual methodological approaches
- Indicate confidence level for extracted information (High/Medium/Low)

## SPECIFIC EXTRACTION CHALLENGES TO WATCH FOR

1. **Variable counting:** Authors often mention variables informally in text - look for formal model specifications
2. **Sampling strategies:** Often not explicitly labeled - infer from discussions of computational burden or large choice sets
3. **Unit sizes:** May be described indirectly (e.g., "city blocks averaged 0.5 hectares")
4. **Multiple models:** Studies may test several approaches - focus on main/preferred model

This enhanced prompt should significantly improve extraction accuracy for the most critical information needed for your SUoA analysis.
