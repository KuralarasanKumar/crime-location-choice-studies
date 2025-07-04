#!/usr/bin/env Rscript
# ===============================================================
#  Comprehensive Elicit Data Extraction & Integration (R version)
#  Author: <your name>, 2025-07-04
#  ---------------------------------------------------------------
#  1. Reads two CSVs:
#       • Elicit extraction file
#       • Standardised spatial-unit file
#  2. Parses the semi-structured "core infor" text
#  3. Matches studies across datasets by fuzzy title
#  4. Merges, cleans, and saves a publication-ready dataset
# ===============================================================

# ---- 0  Load packages ------------------------------------------------------
suppressPackageStartupMessages({
  library(data.table)      # fast fread/fwrite + := syntax
  library(stringr)         # tidy string utilities
  library(stringdist)      # fuzzy similarity (Jaro–Winkler)
  library(purrr)           # map / pmap helpers
})

# ---- 1  User-editable parameters ------------------------------------------
INPUT_ELICIT   <- "Elicit - Extract from 49 papers - core infor.csv"
INPUT_STANDARD <- "20250703_standardized_unit_sizes_with_groups.csv"
OUTPUT_MAIN    <- "20250704_comprehensive_dataset_with_elicit_FINAL.csv"
OUTPUT_MATCH   <- "20250704_elicit_matching_report_FINAL.csv"
OUTPUT_RAW     <- "20250704_elicit_extracted_data_FINAL.csv"

SIM_THRESHOLD  <- 0.60     # similarity cut-off (0–1)

# ---- 2  Helper functions ---------------------------------------------------

clean_title <- function(x) {
  x |>
    tolower() |>
    str_squish() |>
    str_replace_all("[^\\w\\s]", "")
}

best_match <- function(target, candidates, thr = SIM_THRESHOLD) {
  tc <- clean_title(target)
  cs <- clean_title(candidates)
  sims <- 1 - stringdist(tc, cs, method = "jw")
  best <- which.max(sims)
  score <- sims[best]
  
  # manual overrides
  if (score < thr) {
    if (str_detect(tc, "discrete spatial choice model") &&
        str_detect(tc, "burglary target selection")) {
      manual <- str_detect(cs, "residential burglary target selection")
      if (any(manual)) { best <- which(manual)[1]; score <- 0.75 }
    }
    if (str_detect(tc, "importance of importance sampling") &&
        str_detect(tc, "discrete choice models")) {
      manual <- str_detect(cs, "importance of importance sampling")
      if (any(manual)) { best <- which(manual)[1]; score <- 0.80 }
    }
  }
  
  if (score >= thr) list(idx = best, score = score) else list(idx = NA, score = 0)
}

# Exact replication of Python's extract_section_content function
extract_field <- function(txt, header) {
  if (is.na(txt)) return("")
  escaped_header <- str_replace_all(header, "([\\^$.*+?()\\[\\]{}|\\\\])", "\\\\1")
  # Exact pattern matching Python: \*\*header:\*\*\s*(.*?)(?=\n\*\*|$)
  pattern <- paste0("\\*\\*", escaped_header, ":\\*\\*\\s*(.*?)(?=\\n\\*\\*|$)")
  m <- str_match(txt, regex(pattern, ignore_case = TRUE, dotall = TRUE))
  if (is.na(m[2])) return("")
  
  content <- str_trim(m[2])
  # Clean up content like Python
  content <- str_replace_all(content, "\\[.*?\\]", "")  # Remove [Not specified] etc
  content <- str_replace_all(content, "\\s+", " ")      # Normalize whitespace
  return(content)
}

extract_variable_counts <- function(core) {
  out <- list(Total_Variables = 0L, Demographic_Vars = 0L, Economic_Vars = 0L,
              LandUse_Vars = 0L, Infrastructure_Vars = 0L, Distance_Vars = 0L,
              Crime_Opportunity_Vars = 0L, Social_Vars = 0L,
              Environmental_Vars = 0L, Temporal_Vars = 0L)
  
  block <- str_match(core, regex("##\\s*VARIABLE SUMMARY COUNTS(.*?)(?=## |$)",
                                 ignore_case=TRUE, dotall=TRUE))[2]
  if (is.na(block)) return(out)
  
  patterns <- c(
    Total_Variables        = "Total Independent Variables",
    Demographic_Vars       = "Demographic Variables",
    Economic_Vars          = "Economic Variables",
    LandUse_Vars           = "Land Use Variables",
    Infrastructure_Vars    = "Infrastructure Variables",
    Distance_Vars          = "Distance[/\\\\]Accessibility Variables",
    Crime_Opportunity_Vars = "Crime Opportunity Variables",
    Social_Vars            = "Social[/\\\\]Behavioral Variables",
    Environmental_Vars     = "Environmental Variables",
    Temporal_Vars          = "Temporal[/\\\\]Control Variables"
  )
  
  for (nm in names(patterns)) {
    pattern <- paste0("\\*\\*", patterns[[nm]], ":\\*\\*\\s*(\\d+)")
    val <- str_match(block, regex(pattern, ignore_case=TRUE))[2]
    out[[nm]] <- as.integer(val %||% 0L)
  }
  out
}

parse_core <- function(core) {
  c(
    # study identification
    list(
      Title_Elicit   = extract_field(core, "Title"),
      Year_Elicit    = extract_field(core, "Year"),
      Authors_Elicit = extract_field(core, "Authors"),
      Journal_Elicit = extract_field(core, "Journal"),
      DOI_Elicit     = extract_field(core, "DOI")
    ),
    # context
    list(
      Country               = extract_field(core, "Country"),
      City_Region           = extract_field(core, "City/Region"),
      Study_Area_Size       = extract_field(core, "Study Area Size"),
      Study_Area_Description= extract_field(core, "Study Area Description"),
      Crime_Type            = extract_field(core, "Crime Type"),
      Crime_Types_All       = extract_field(core, "Crime Types \\(All\\)"),
      Study_Period          = extract_field(core, "Study Period"),
      Data_Sources          = extract_field(core, "Data Sources")
    ),
    # spatial unit
    list(
      SUoA_Type             = extract_field(core, "SUoA Type"),
      SUoA_Size_Elicit      = extract_field(core, "SUoA Size"),
      SUoA_Description      = extract_field(core, "SUoA Description"),
      Number_of_Units_Elicit= extract_field(core, "Number of Units"),
      Population_per_Unit   = extract_field(core, "Population per Unit"),
      SUoA_Justification    = extract_field(core, "Justification for SUoA Choice")
    ),
    # methodology
    list(
      Study_Design          = extract_field(core, "Study Design"),
      Statistical_Method    = extract_field(core, "Statistical Method"),
      Model_Type            = extract_field(core, "Model Type"),
      Software_Used         = extract_field(core, "Software Used"),
      Sampling_Approach     = extract_field(core, "Sampling Approach"),
      Sample_Size_Elicit    = extract_field(core, "Sample Size"),
      Choice_Set_Definition = extract_field(core, "Choice Set Definition"),
      Estimation_Method     = extract_field(core, "Estimation Method")
    ),
    # variable counts
    extract_variable_counts(core),
    # findings
    list(
      Main_Results          = extract_field(core, "Main Results"),
      Significant_Predictors= extract_field(core, "Significant Predictors"),
      Model_Performance     = extract_field(core, "Model Performance"),
      Scale_Effects         = extract_field(core, "Scale Effects")
    ),
    # quality
    list(
      Variable_Info_Quality = extract_field(core, "Variable Information Quality"),
      Missing_Information   = extract_field(core, "Missing Information"),
      Extraction_Confidence = extract_field(core, "Extraction Confidence")
    )
  )
}

country_override <- function(row, std_title) {
  base <- "Burglar Target Selection: A Cross-national Comparison"
  if (!str_detect(str_to_lower(std_title), str_to_lower(base))) return(row)
  
  map <- c(NL = "Netherlands", UK = "United Kingdom", AU = "Australia")
  code <- names(map)[str_detect(std_title, fixed(paste0("(", names(map), ")")))]
  if (length(code)) {
    row$Country     <- map[code]
    row$City_Region <- switch(code,
                              NL = "Netherlands (multiple cities)",
                              UK = "United Kingdom (multiple areas)",
                              AU = "Australia (multiple cities)")
    row$Study_Area_Description <-
      paste0("Part of cross-national comparison focusing on ", row$Country, ". ",
             row$Study_Area_Description %||% "")
  }
  row
}

# ---- 3  Load datasets ------------------------------------------------------
message("Reading input files …")
elicit <- fread(INPUT_ELICIT, encoding = "UTF-8")
std    <- fread(INPUT_STANDARD, encoding = "UTF-8")
message(sprintf("   Elicit rows: %d | Standardised rows: %d",
                nrow(elicit), nrow(std)))

# ---- 4  Parse Elicit "core infor" -----------------------------------------
message("\nParsing core information …")
elist_parsed <- rbindlist(
  imap(split(elicit, seq_len(nrow(elicit))), function(row, idx) {
    fields <- parse_core(row$`core infor`)
    c(list(
      Elicit_Index          = as.integer(idx) - 1L,
      Title_Original_Elicit = row$Title,
      Authors_Original      = row$Authors,
      Year_Original         = row$Year,
      Citation_Count        = row$`Citation count`,
      Venue                 = row$Venue
    ), fields)
  }),
  fill = TRUE
)

# ---- 5  Match titles -------------------------------------------------------
message("\nMatching studies …")
match_dt <- rbindlist(
  imap(split(std, seq_len(nrow(std))), function(row, idx) {
    res <- best_match(row$Title_of_the_study, elicit$Title)
    data.table(
      Std_Index    = as.integer(idx) - 1L,
      Std_Title    = row$Title_of_the_study,
      Elicit_Index = res$idx,
      Elicit_Title = ifelse(is.na(res$idx), "NO MATCH", elicit$Title[res$idx]),
      Match_Score  = res$score
    )
  })
)

matched_n <- sum(match_dt$Match_Score > 0)
mean_score <- mean(match_dt$Match_Score[match_dt$Match_Score > 0])
message(sprintf("Matched %d/%d (avg score %.3f)",
                matched_n, nrow(std), mean_score))

# ---- 6  Merge (replicating Python exactly) --------------------------------
message("\nIntegrating data …")
std[, `:=`(Elicit_Match_Score = match_dt$Match_Score,
           Elicit_Matched_Title = match_dt$Elicit_Title)]

for (i in seq_len(nrow(match_dt))) {
  el_idx <- match_dt$Elicit_Index[i]
  if (!is.na(el_idx)) {
    e <- elist_parsed[Elicit_Index == el_idx]
    if (nrow(e) == 1) {
      e_list <- as.list(e)
      e_list <- country_override(e_list, match_dt$Std_Title[i])
      
      # Remove index and original title, then add Elicit_ prefix to all fields
      # (matching Python behavior exactly)
      e_list <- e_list[names(e_list) != "Elicit_Index" & names(e_list) != "Title_Original_Elicit"]
      names(e_list) <- paste0("Elicit_", names(e_list))
      
      for (nm in names(e_list)) {
        std[[nm]][i] <- e_list[[nm]]
      }
    }
  }
}

# ---- 7  Save outputs -------------------------------------------------------
fwrite(std,           OUTPUT_MAIN,  bom = TRUE)
fwrite(match_dt,      OUTPUT_MATCH, bom = TRUE)
fwrite(elist_parsed,  OUTPUT_RAW,   bom = TRUE)

# ---- 8  Summary ------------------------------------------------------------
message("\n------ SUMMARY ------")
message(sprintf("Output written to %s", OUTPUT_MAIN))
message(sprintf("Matching report:     %s", OUTPUT_MATCH))
message(sprintf("Parsed Elicit data:  %s", OUTPUT_RAW))
message(sprintf("Rows with Elicit data: %d (%.1f %%)",
                matched_n, matched_n/nrow(std)*100))
message("Done ✔")
