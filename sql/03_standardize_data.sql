-- ============================================================
-- SQL Data Cleaning Project
-- PostgreSQL
--
-- File: 03_standardize_data.sql
-- Purpose: Standardize inconsistent text values and convert
--          the date column from text to DATE.
-- ============================================================


-- ============================================================
-- 1. REVIEW CURRENT DATA
-- ============================================================

SELECT *
FROM world_layoffs.layoffs_staging2
LIMIT 20;


-- ============================================================
-- 2. STANDARDIZE INDUSTRY VALUES
-- ============================================================

-- Review distinct industry values.

SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY industry;


-- Find missing or empty industry values.

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL
   OR TRIM(industry) = ''
ORDER BY company;


-- ============================================================
-- 3. CONVERT EMPTY INDUSTRY VALUES TO NULL
-- ============================================================

UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE TRIM(industry) = '';


-- Verify.

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL
ORDER BY company;


-- ============================================================
-- 4. POPULATE MISSING INDUSTRY VALUES
-- ============================================================

-- If another record for the same company has a known
-- industry, use that value to populate the missing value.

UPDATE world_layoffs.layoffs_staging2 AS t1
SET industry = t2.industry
FROM world_layoffs.layoffs_staging2 AS t2
WHERE t1.company = t2.company
  AND t1.industry IS NULL
  AND t2.industry IS NOT NULL;


-- Review remaining missing industries.

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL
ORDER BY company;


-- ============================================================
-- 5. STANDARDIZE CRYPTO INDUSTRY VALUES
-- ============================================================

SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
WHERE industry ILIKE '%crypto%'
ORDER BY industry;


-- Standardize known Crypto variations.

UPDATE world_layoffs.layoffs_staging2
SET industry = 'Crypto'
WHERE industry IN (
    'Crypto Currency',
    'CryptoCurrency'
);


-- Verify.

SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
WHERE industry ILIKE '%crypto%'
ORDER BY industry;


-- ============================================================
-- 6. STANDARDIZE COUNTRY VALUES
-- ============================================================

-- Review distinct country values.

SELECT DISTINCT country
FROM world_layoffs.layoffs_staging2
ORDER BY country;


-- Remove leading and trailing whitespace.

UPDATE world_layoffs.layoffs_staging2
SET country = TRIM(country);


-- Remove trailing periods.
--
-- Example:
-- United States. → United States

UPDATE world_layoffs.layoffs_staging2
SET country = RTRIM(country, '.');


-- Trim again in case cleaning created whitespace.

UPDATE world_layoffs.layoffs_staging2
SET country = TRIM(country);


-- Verify.

SELECT DISTINCT country
FROM world_layoffs.layoffs_staging2
ORDER BY country;


-- ============================================================
-- 7. REVIEW DATE VALUES BEFORE CONVERSION
-- ============================================================

SELECT DISTINCT "date"
FROM world_layoffs.layoffs_staging2
ORDER BY "date"
LIMIT 50;


-- ============================================================
-- 8. CHECK DATE FORMAT
-- ============================================================

-- Count values that are not in the expected MM/DD/YYYY format.
--
-- The raw dataset should contain dates such as:
-- 05/10/2022
-- 05/11/2022
--
-- NULL values are allowed.

SELECT COUNT(*) AS invalid_date_values
FROM world_layoffs.layoffs_staging2
WHERE "date" IS NOT NULL
  AND "date" !~ '^\d{1,2}/\d{1,2}/\d{4}$';


-- ============================================================
-- 9. CONVERT DATE FROM TEXT TO DATE
-- ============================================================

-- PostgreSQL uses TO_DATE() instead of MySQL's STR_TO_DATE().

ALTER TABLE world_layoffs.layoffs_staging2
ALTER COLUMN "date"
TYPE DATE
USING (
    CASE
        WHEN "date" IS NULL OR TRIM("date") = ''
            THEN NULL
        ELSE TO_DATE("date", 'MM/DD/YYYY')
    END
);


-- ============================================================
-- 10. VERIFY DATE CONVERSION
-- ============================================================

SELECT
    MIN("date") AS earliest_date,
    MAX("date") AS latest_date
FROM world_layoffs.layoffs_staging2;


-- Verify that PostgreSQL now recognizes the column as DATE.

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'world_layoffs'
  AND table_name = 'layoffs_staging2'
  AND column_name = 'date';


-- ============================================================
-- 11. REVIEW STANDARDIZED DATA
-- ============================================================

SELECT *
FROM world_layoffs.layoffs_staging2
ORDER BY "date";


-- ============================================================
-- STANDARDIZATION COMPLETE
-- ============================================================