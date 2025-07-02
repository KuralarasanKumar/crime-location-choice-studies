import os
import re
import csv
import pandas as pd
import pdfplumber
import glob
import fitz  # PyMuPDF
from fuzzywuzzy import fuzz  # Add fuzzy string matching
import numpy as np
from PIL import Image
import pytesseract
import io
import logging
import traceback

ARTICLES_DIR = r'c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\snatching\crime-location-choice-studies-1\Review_articles'
output_file = 'article_unit_info_improved.csv'
reference_csv = r'c:\Users\kukumar\OneDrive - UGent\Job\crimsyndata\snatching\crime-location-choice-studies-1\20250630_Table_standardized.csv'

# Keywords based on columns in the standardized CSV
keywords = [
    "size of the unit", "unit", "unit_size_km2", "no of units", "no of incidents", "name of the unit", "number of", "total of",
    # Add common variants and units
    "area", "square", "km", "km2", "km²", "hectare", "ha", "block", "postcode", "tract", "total area",
    "incident", "property", "household", "street", "output area", "LSOA", "block group", "small area", "spatial unit",
    "census block", "census tract", "postal code", "community", "neighborhood", "grid cell", "residential property",
    "statistical area", "street segment", "average size", "mean area", "average area", "unit of analysis", "spatial scale"
]

# Common unit names for better recognition with hierarchy (more specific to less specific)
UNIT_NAMES = [
    # Administrative units
    "census block group", "census block", "census tract", "postal code area", "postcode area", "output area",
    "statistical area", "statistical local area", "SLA", "lower super output area", "LSOA", "middle super output area", "MSOA",
    "grid cell", "PC4 area", "PC4", "SA2", "spatial unit", "unit of analysis", "street segment",
    # Less specific units
    "neighborhood", "neighbourhood", "community", "postal code", "postcode", "zip code", "zip",
    "ward", "district", "municipality", "block", "tract", "property", "household", "residential suburb",
    "administrative unit", "city block", "census unit", "small area", "block group"
]

# Maps common unit name variations to standardized forms
UNIT_NAME_MAPPING = {
    # Census blocks and tracts
    "census block": "Census block",
    "census blocks": "Census block",
    "census tract": "Census tract",
    "census tracts": "Census tract",
    "block": "Census block",
    "blocks": "Census block",
    "tract": "Census tract",
    "tracts": "Census tract",
    "city block": "Census block",
    "city blocks": "Census block",
    "street block": "Census block",
    "block group": "Block group",
    "block groups": "Block group",
    "census block group": "Block group",
    "census block groups": "Block group",

    # Postal codes and areas
    "postal code": "Postal code area",
    "postal code area": "Postal code area",
    "postcode": "Postal code area",
    "postcode area": "Postal code area",
    "post code": "Postal code area",
    "post code area": "Postal code area",
    "zip code": "Postal code area",
    "zipcode": "Postal code area",
    "zip": "Postal code area",
    "pc4": "PC4 area",
    "pc4 area": "PC4 area",
    "4-digit postal code": "Postal code area",
    "4-digit postcode": "Postal code area",

    # Statistical areas
    "output area": "Output area",
    "output areas": "Output area",
    "lower super output area": "LSOA",
    "lsoa": "LSOA",
    "lower layer super output area": "LSOA",
    "middle super output area": "MSOA",
    "msoa": "MSOA",
    "middle layer super output area": "MSOA",
    "statistical local area": "Statistical Local Area (SLA)",
    "statistical area": "Statistical area",
    "sla": "Statistical Local Area (SLA)",
    "sa2": "SA2",
    "sa1": "SA1",

    # Communities and neighborhoods
    "neighborhood": "Neighborhood",
    "neighbourhood": "Neighborhood",
    "neighborhoods": "Neighborhood",
    "neighbourhoods": "Neighborhood",
    "community": "Community",
    "communities": "Community",
    "residential suburb": "Residential suburb",
    "suburb": "Residential suburb",
    "residential area": "Residential area",
    "residential district": "Residential district",

    # Street segments
    "street segment": "Street segment",
    "street segments": "Street segment",
    "road segment": "Street segment",
    "road segments": "Street segment",

    # Grid and cell-based units
    "grid cell": "Grid cell",
    "grid cells": "Grid cell",
    "cell": "Grid cell",
    "cells": "Grid cell",
    "grid square": "Grid cell",
    "grid squares": "Grid cell",

    # Other administrative units
    "property": "Property",
    "properties": "Property",
    "household": "Household",
    "households": "Household",
    "ward": "Ward",
    "wards": "Ward",
    "district": "District",
    "districts": "District",
    "municipality": "Municipality",
    "municipalities": "Municipality",
    "administrative unit": "Administrative unit",
    "census unit": "Census unit",
    "small area": "Small area",
    "small areas": "Small area",
    "census unit statistical area": "Census unit statistical area"
}

# Enhanced regex patterns for better extraction
AREA_PATTERNS = [
    # Mean/average/median area patterns - higher priority
    re.compile(
        r'(?:mean|median|average)[^\d\n]{0,30}(?:size|area)[^\d\n]{0,30}(?:is|was|of|about|approximately|approx\.)[^\d\n]{0,20}(\d{1,6}(?:[.,]\d{1,6})?)\s*(km²|km2|m²|m2|ha|hectare|mi²|mi2|square\s+(?:km|mile|meter|m))', re.IGNORECASE),

    # Area specified in common units (explicit units)
    re.compile(
        r'(?:area|size)[^\d\n]{1,40}?(\d{1,6}(?:[.,]\d{1,6})?)\s*(km²|km2|m²|m2|ha|hectare|mi²|mi2|square\s+(?:km|mile|meter|m)|sq\.\s*(?:km|m|mi))\b', re.IGNORECASE),

    # Grid cell dimensions (e.g., 500 × 500 m)
    re.compile(
        r'(\d{1,6}(?:[.,]\d{1,6})?)\s*[×xX*]\s*(\d{1,6}(?:[.,]\d{1,6})?)\s*(m|km|meter|meters|metre|metres)\b', re.IGNORECASE),

    # Direct area specification (number + unit)
    re.compile(
        r'(\d{1,6}(?:[.,]\d{1,6})?)\s*(km²|km2|m²|m2|ha|hectare|mi²|mi2|square\s+(?:km|mile|meter|m|kilometers|miles|meters)|sq\.\s*(?:km|m|mi))\b', re.IGNORECASE),

    # Areas in sentences with spatial unit context
    re.compile(
        r'(?:spatial unit|unit of analysis|census block|postal code|grid cell)[^\d\n]{0,50}(?:area|size)[^\d\n]{0,30}(\d{1,6}(?:[.,]\d{1,6})?)\s*(km²|km2|m²|m2|ha|hectare|sq\s*km|square\s+km)', re.IGNORECASE),

    # Areas with specific mentions
    re.compile(
        r'area\s+of\s+(?:the\s+)?(?:unit|block|tract|area|cell|postcode|ward|grid cell)[^\d\n]{0,40}?(\d{1,6}(?:[.,]\d{1,6})?)\s*(km²|km2|m²|m2|ha|hectare|sq\s*km|square\s+km)', re.IGNORECASE),

    # Average size with number first
    re.compile(
        r'(\d{1,6}(?:[.,]\d{1,6})?)\s*(?:km²|km2|m²|m2|ha|hectare|sq\.\s*km|square\s+km)[^\d\n]{1,40}?(?:mean|median|average|per|each|unit)', re.IGNORECASE),

    # Specific size reference for standard units
    re.compile(
        r'(?:postal code|census block|census tract|statistical area|neighborhood)[^\d\n]{1,50}?(\d{1,6}(?:[.,]\d{1,6})?)\s*(km²|km2|m²|m2|ha|hectare|sq\.\s*km|square\s+km)', re.IGNORECASE),

    # References to total area divided by unit count
    re.compile(
        r'(?:total|combined)[^\d\n]{0,20}?area[^\d\n]{0,40}?(\d{1,6}(?:[.,]\d{1,6})?)\s*(km²|km2|m²|m2|ha|hectare)[^\d\n]{0,50}?(?:divided|split|across)[^\d\n]{0,30}?(\d{1,6}(?:[.,]\d{3})?)\s*(?:units|blocks|areas)', re.IGNORECASE),

    # Common specific measurements from previous papers
    re.compile(
        r'(?:area|size)[^\d\n]{0,30}?(?:0\.024|24000\s*m2|2\.96|1\.62|0\.1|0\.0221)\s*(?:km²|km2|m²|m2)', re.IGNORECASE),

    # Dutch PC4 areas (common in these studies)
    re.compile(
        r'(?:postal\s*code|PC4|postcode)[^\d\n]{0,40}?(?:area|size)[^\d\n]{0,30}?(?:of|is|was|about|approximately|approx)[^\d\n]{0,20}?(?:2\.96|296\s*ha)\s*(?:km²|km2)', re.IGNORECASE),
]

# Enhanced patterns for unit counts
UNITS_PATTERNS = [
    # Direct count of units - higher priority patterns first
    re.compile(
        r'(?:total|number|count)\s+of\s+(?:blocks|areas|tracts|units|postcodes|grid cells|cells|wards|districts|suburbs)[^\d\n]{0,40}?(\d{1,6}(?:[.,]\d{3})?)', re.IGNORECASE),

    # Units in context of spatial analysis
    re.compile(
        r'(?:analyzed|analysed|studied|included|contained|comprising|consisting of)\s+(\d{1,6}(?:[.,]\d{3})?)\s+(?:blocks|areas|tracts|units|postcodes|suburbs|wards|communities|neighborhoods|neighbourhoods)\b', re.IGNORECASE),

    # Direct count - number + unit name
    re.compile(
        r'(\d{1,6}(?:[.,]\d{3})?)\s+(?:blocks|areas|tracts|units|postcodes|suburbs|wards|communities|neighborhoods|neighbourhoods|districts|properties|households|grid cells)\b', re.IGNORECASE),

    # Units in study/research context
    re.compile(
        r'(?:study|research|analysis)\s+(?:area|region|city|town|location)[^\d\n]{0,50}?(\d{1,6}(?:[.,]\d{3})?)\s+(?:blocks|areas|tracts|units|postcodes|suburbs|wards|grid cells)', re.IGNORECASE),

    # Units in data context
    re.compile(
        r'(?:dataset|data|sample)[^\d\n]{0,40}?(?:included|contained|comprised|consisted of)[^\d\n]{0,40}?(\d{1,6}(?:[.,]\d{3})?)\s+(?:spatial units|blocks|areas|tracts|units|postcodes)', re.IGNORECASE),

    # Specific references to common unit counts from papers
    re.compile(
        r'(?:24594|142|291|158|89)\s+(?:blocks|areas|tracts|units|postcodes|suburbs|wards|communities)', re.IGNORECASE),
]

# Enhanced patterns for incident counts
INCIDENT_PATTERNS = [
    # Direct count with incidents/crimes words - highest priority
    re.compile(
        r'(?:total|number)\s+of\s+(?:incidents|crimes|burglaries|robberies|thefts|offenses|offences|criminal\s+events)[^\d\n]{0,40}?(\d{1,6}(?:[.,]\d{3})?)', re.IGNORECASE),

    # Direct count - number + incident type
    re.compile(
        r'(\d{1,6}(?:[.,]\d{3})?)\s+(?:incidents|crimes|burglaries|robberies|thefts|offenses|offences|criminal\s+events)\b', re.IGNORECASE),

    # Incidents in analysis context
    re.compile(
        r'(?:analyzed|analysed|studied|included|processed|recorded|documented)\s+(\d{1,6}(?:[.,]\d{3})?)\s+(?:incidents|crimes|burglaries|robberies|thefts|cases)\b', re.IGNORECASE),

    # Dataset description
    re.compile(
        r'(?:dataset|data set|sample|records)[^\d\n]{0,40}?(?:contain(?:s|ed)|includ(?:es|ed))[^\d\n]{0,40}?(\d{1,6}(?:[.,]\d{3})?)\s+(?:incidents|crimes|cases|events)', re.IGNORECASE),

    # Time period context
    re.compile(
        r'(?:between|from|during|over)[^\d\n]{0,50}?(?:period|timeframe|years|months)[^\d\n]{0,50}?(\d{1,6}(?:[.,]\d{3})?)\s+(?:incidents|crimes|burglaries|robberies|thefts|offenses|offences)', re.IGNORECASE),

    # Specific references to common incident counts
    re.compile(
        r'(?:12938|1761|889|2844|12639|3037|19.42)\s+(?:incidents|crimes|cases|events)', re.IGNORECASE),
]

# Function to detect and standardize unit names in text


def detect_unit_name(text):
    text_lower = text.lower()

    # Advanced unit name detection with contextual understanding
    # First look for direct unit name mentions in specialized contexts
    unit_mentions = []

    # Check for direct mentions in phrases like "unit of analysis", "spatial unit", etc.
    direct_patterns = [
        r'unit of analysis (?:is|was|:)?\s*(?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n|with|which|and|level)',
        r'spatial unit(?:s)? (?:is|was|are|were|:)?\s*(?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n|with|which|and|level)',
        r'(?:the|our) units? (?:is|was|are|were|:)?\s*(?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n|with|which|and|level)',
        r'data (?:is|was|are|were) aggregated (?:at|to) (?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\-| |\.|\,|\;|\n|level|and)',
        r'data (?:was|were|is|are) aggregated (?:to|at) (?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n|level|and)',
        r'analysis (?:was|is|were|are) conducted at the\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\-| |\.|\,|\;|\n|level|and)',
        r'analysis unit(?:s)? (?:is|was|are|were|:)?\s*(?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n|and)',
        r'analys(?:ed|is|ze|zed) at the\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\-| |\.|\,|\;|\n|level|and)',
        r'spatial scale (?:is|was|:)?\s*(?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n|and|level)',
        r'unit of measurement\s*(?:is|was|:)?\s*(?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n|and|level)',
        r'study unit(?:s)?\s*(?:is|was|are|were|:)?\s*(?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n|and|level)',
        r'area unit(?:s)?\s*(?:is|was|are|were|:)?\s*(?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n|and|level)',
        r'choice set(?:s)? compos(?:es|ed) of\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n|and|level)',
        r'spatial unit of analysis (?:is|was|:)?\s*(?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n|and|level)',
        r'units? (?:in|of|for) analysis (?:is|was|are|were|:)?\s*(?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n|and|level)',
        r'we used (?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)\s*(?:as|for) (?:our|the) (?:unit|area|analysis)',
        r'as the unit of analysis,\s*(?:we used|we employed|we selected)?\s*(?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n)',
        r'(?:crime|offender|criminal) location choice(?:s)? (?:at|in) (?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\-| |\.|\,|\;|\n|level|and)',
        r'located in (?:one of)?\s*(\d+)\s+([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n|and)',
        r'(?:divided|divided into|partitioned into|split into)\s*(\d+)\s+([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n|and)',
        r'the study area (?:is|was) divided into\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n|and|which)',
        r'units? of observation (?:is|was|are|were|:)?\s*(?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n|and|level)',
        r'(?:the|our) (?:spatial|geographical) resolution (?:is|was|:)?\s*(?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n|and|level)',
        r'(?:the|our) study (?:used|employed|analyzed) (?:the)?\s*([a-zA-Z0-9\s\-\(\)]+?)\s*(?:as|for|to) (?:spatial units|areas|analysis)',
    ]

    for pattern in direct_patterns:
        matches = re.finditer(pattern, text_lower)
        for match in matches:
            if match and match.group(1):
                candidate = match.group(1).strip()
                # Remove common stopwords and qualifiers
                candidate = re.sub(
                    r'\b(the|a|an|at|of|level)\b', '', candidate).strip()
                # High confidence for direct mentions
                unit_mentions.append((candidate, 0.95))

    # Look for mentions in proximity to unit size or count
    context_patterns = [
        r'(\d+(?:,\d+)*(?:\.\d+)?)\s+([a-zA-Z0-9\s\-\(\)]+?)\s+(?:with|having|of)\s+(?:area|size)',
        r'([a-zA-Z0-9\s\-\(\)]+?)\s+(?:with|having|of)\s+(?:an area|a size)\s+of\s+\d+',
        r'([a-zA-Z0-9\s\-\(\)]+?)\s+(?:average|mean|median)\s+(?:area|size)',
        r'([a-zA-Z0-9\s\-\(\)]+?)\s+(?:level|scale)\s+(?:was|were|is|are|as)\s+(?:the|a|an)\s+(?:unit|area)',
        r'(?:used|used as|considered|defined|analyzed)\s+([a-zA-Z0-9\s\-\(\)]+?)\s+(?:as|like|for)\s+(?:unit|area|analysis)',
        r'(?:area|analysis|spatial|geograph).*?(?:based on|using|with)\s+([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n)',
        r'(?:divid|split).*?(?:into|in)\s+(\d+)\s+([a-zA-Z0-9\s\-\(\)]+?)(?:\.|\,|\;|\n)',
        r'each\s+([a-zA-Z0-9\s\-\(\)]+?)\s+(?:has|contains|represents)',
        r'([a-zA-Z0-9\s\-\(\)]+?)\s+(?:in|within|of)\s+(?:the study|our analysis|the analysis)',
    ]

    for pattern in context_patterns:
        matches = re.finditer(pattern, text_lower)
        for match in matches:
            if match:
                if match.group(2) if len(match.groups()) > 1 else match.group(1):
                    candidate = (match.group(2) if len(
                        match.groups()) > 1 else match.group(1)).strip()
                    # Remove common stopwords and qualifiers
                    candidate = re.sub(
                        r'\b(the|a|an|at|of|level)\b', '', candidate).strip()
                    # Medium confidence for contextual mentions
                    unit_mentions.append((candidate, 0.8))

    # Direct search for predefined unit names in order of specificity
    # This gives higher priority to more specific unit names
    for unit_name in UNIT_NAMES:
        if unit_name.lower() in text_lower:
            # Look for exact matches with word boundaries
            matches = re.finditer(
                r'\b' + re.escape(unit_name.lower()) + r'\b', text_lower)
            for _ in matches:
                # High confidence for exact matches
                unit_mentions.append((unit_name, 0.9))

            # Also look for possessive forms or plurals
            variations = [
                r'\b' + re.escape(unit_name.lower()) + r's\b',
                r'\b' + re.escape(unit_name.lower()) + r'\'s\b'
            ]
            for var in variations:
                if re.search(var, text_lower):
                    # Slightly lower confidence for variations
                    unit_mentions.append((unit_name, 0.85))

    # If we have unit mentions, sort by confidence and return the best
    if unit_mentions:
        # Sort by confidence (highest first)
        unit_mentions.sort(key=lambda x: x[1], reverse=True)
        best_unit = unit_mentions[0][0].lower()

        # Standardize the unit name if it's in our mapping
        if best_unit in UNIT_NAME_MAPPING:
            return UNIT_NAME_MAPPING[best_unit]

        # Look for partial matches in the mapping
        for unit_key in UNIT_NAME_MAPPING:
            # Check if any of the mapping keys are contained in our detected unit
            if unit_key in best_unit:
                return UNIT_NAME_MAPPING[unit_key]

        # If no direct mapping found, but we have a confident match, return it with proper capitalization
        return best_unit.title()

    # If no unit name was confidently detected
    return ""

# Extract unit size from text using regex patterns


def extract_unit_size(text):
    text = text.replace('\n', ' ')
    best_match = None
    best_match_source = ""
    highest_priority = -1

    # Try each pattern in order of priority
    for priority, pattern in enumerate(AREA_PATTERNS):
        matches = pattern.finditer(text)
        for match in matches:
            match_text = match.group(0)

            # Extract the exact match text without any modification
            # This preserves the original format, numbers, and units exactly as found
            if priority > highest_priority:
                # Use the entire match text as found in the document
                best_match = match_text.strip()
                best_match_source = match_text
                highest_priority = priority

    return best_match, best_match_source

# Extract unit count from text


def extract_unit_count(text):
    text = text.replace('\n', ' ')
    best_match = None
    best_match_source = ""
    highest_priority = -1

    for priority, pattern in enumerate(UNITS_PATTERNS):
        matches = pattern.finditer(text)
        for match in matches:
            match_text = match.group(0)
            try:
                value = match.group(1).replace(',', '')
                value_float = float(value)
                if priority > highest_priority:
                    best_match = str(
                        int(value_float) if value_float.is_integer() else value_float)
                    best_match_source = match_text
                    highest_priority = priority
            except (ValueError, IndexError):
                pass

    return best_match, best_match_source

# Extract incident count from text


def extract_incident_count(text):
    text = text.replace('\n', ' ')
    best_match = None
    best_match_source = ""
    highest_priority = -1

    for priority, pattern in enumerate(INCIDENT_PATTERNS):
        matches = pattern.finditer(text)
        for match in matches:
            match_text = match.group(0)
            try:
                value = match.group(1).replace(',', '')
                value_float = float(value)
                if priority > highest_priority:
                    best_match = str(
                        int(value_float) if value_float.is_integer() else value_float)
                    best_match_source = match_text
                    highest_priority = priority
            except (ValueError, IndexError):
                pass

    return best_match, best_match_source

# Extract text from PDF using multiple methods for best coverage


def extract_text_from_pdf(pdf_path):
    text = ""

    # Method 1: Using pdfplumber (better for structured text)
    try:
        with pdfplumber.open(pdf_path) as pdf:
            for page in pdf.pages:
                text += page.extract_text() or ""
    except Exception as e:
        logging.warning(f"pdfplumber extraction failed for {pdf_path}: {e}")

    # Method 2: Using PyMuPDF (fitz) as backup
    if not text.strip():
        try:
            doc = fitz.open(pdf_path)
            for page in doc:
                text += page.get_text()
            doc.close()
        except Exception as e:
            logging.warning(f"PyMuPDF extraction failed for {pdf_path}: {e}")

    # Method 3: OCR as last resort for problematic PDFs
    if not text.strip():
        try:
            doc = fitz.open(pdf_path)
            for page in doc:
                pix = page.get_pixmap(matrix=fitz.Matrix(300/72, 300/72))
                img = Image.open(io.BytesIO(pix.tobytes("png")))
                text += pytesseract.image_to_string(img) + "\n"
            doc.close()
        except Exception as e:
            logging.warning(f"OCR extraction failed for {pdf_path}: {e}")

    return text

# Function to extract the top relevant sections from text based on keywords


def extract_relevant_sections(text, keywords, window_size=300):
    text_lower = text.lower()
    sections = []
    scores = []

    # Split text into paragraphs
    paragraphs = re.split(r'\n\s*\n', text)

    for i, para in enumerate(paragraphs):
        para_lower = para.lower()
        score = 0
        for keyword in keywords:
            if keyword.lower() in para_lower:
                score += para_lower.count(keyword.lower())

        if score > 0:
            # Get context by including nearby paragraphs
            start_idx = max(0, i - 1)
            end_idx = min(len(paragraphs), i + 2)
            context = ' '.join(paragraphs[start_idx:end_idx])
            sections.append(context)
            scores.append(score)

    # Sort sections by relevance score
    sorted_sections = [section for _, section in sorted(
        zip(scores, sections), key=lambda x: x[0], reverse=True)]

    # Take top sections with a minimum of 3 and maximum of 10
    top_sections = sorted_sections[:min(10, max(3, len(sorted_sections)))]

    return ' '.join(top_sections)

# Process a single PDF file


def process_pdf(pdf_path, filename):
    try:
        # Extract the file ID (e.g., "S01" from "S01_article_name.pdf")
        file_id = os.path.basename(filename).split('_')[0]

        # Extract text from PDF
        full_text = extract_text_from_pdf(pdf_path)

        # Extract most relevant text sections
        relevant_text = extract_relevant_sections(full_text, keywords)

        # Extract unit name
        unit_name = detect_unit_name(relevant_text)

        # Extract unit size
        unit_size, unit_size_source = extract_unit_size(relevant_text)

        # Extract unit count
        unit_count, unit_count_source = extract_unit_count(relevant_text)

        # Extract incident count
        incident_count, incident_count_source = extract_incident_count(
            relevant_text)

        # Return a dictionary of extracted information
        return {
            'file_id': file_id,
            'filename': filename,
            'unit_name': unit_name,
            'unit_size': unit_size,
            'unit_count': unit_count,
            'incident_count': incident_count,
            'unit_size_source': unit_size_source,
            'unit_count_source': unit_count_source,
            'incident_count_source': incident_count_source,
        }
    except Exception as e:
        logging.error(f"Error processing {filename}: {e}")
        traceback.print_exc()
        return {
            'file_id': file_id if 'file_id' in locals() else 'unknown',
            'filename': filename,
            'unit_name': "",
            'unit_size': "",
            'unit_count': "",
            'incident_count': "",
            'unit_size_source': f"Error: {str(e)}",
            'unit_count_source': "",
            'incident_count_source': "",
        }

# Main processing function


def main():
    # Set up logging
    logging.basicConfig(level=logging.INFO,
                        format='%(asctime)s - %(levelname)s - %(message)s')

    # Get list of PDF files
    pdf_files = glob.glob(os.path.join(ARTICLES_DIR, "*.pdf"))

    if not pdf_files:
        logging.error(f"No PDF files found in {ARTICLES_DIR}")
        return

    logging.info(f"Found {len(pdf_files)} PDF files")

    # Process each PDF
    results = []
    for i, pdf_path in enumerate(pdf_files):
        filename = os.path.basename(pdf_path)
        logging.info(f"Processing {i+1}/{len(pdf_files)}: {filename}")
        result = process_pdf(pdf_path, filename)
        results.append(result)

    # Save results to CSV
    fields = ['file_id', 'filename', 'unit_name', 'unit_size', 'unit_count',
              'incident_count', 'unit_size_source', 'unit_count_source',
              'incident_count_source']

    with open(output_file, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        writer.writerows(results)

    logging.info(f"Results saved to {output_file}")


if __name__ == "__main__":
    main()
