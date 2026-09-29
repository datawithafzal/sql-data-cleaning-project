-- ============================================================
-- SQL Data Cleaning Project
-- PostgreSQL
--
-- File: 04_handle_nulls.sql
-- Purpose: Analyze missing values and document how NULLs
--          are handled in the cleaned dataset.
-- ============================================================


-- ============================================================
-- 1. TOTAL NUMBER OF ROWS
-- ============================================================

SELECT COUNT(*) AS total_rows
FROM world_layoffs.layoffs_staging2;


-- ============================================================
-- 2. CHECK NULL VALUES BY COLUMN
-- ============================================================

SELECT
    COUNT(*) FILTER (
        WHERE company IS NULL
    ) AS null_company,

    COUNT(*) FILTER (
        WHERE location IS NULL
    ) AS null_location,

    COUNT(*) FILTER (
        WHERE total_laid_off IS NULL
    ) AS null_total_laid_off,

    COUNT(*) FILTER (
        WHERE "date" IS NULL
    ) AS null_date,

    COUNT(*) FILTER (
        WHERE percentage_laid_off IS NULL
    ) AS null_percentage_laid_off,

    COUNT(*) FILTER (
        WHERE industry IS NULL
    ) AS null_industry,

    COUNT(*) FILTER (
        WHERE source IS NULL
    ) AS null_source,

    COUNT(*) FILTER (
        WHERE stage IS NULL
    ) AS null_stage,

    COUNT(*) FILTER (
        WHERE funds_raised IS NULL
    ) AS null_funds_raised,

    COUNT(*) FILTER (
        WHERE country IS NULL
    ) AS null_country,

    COUNT(*) FILTER (
        WHERE date_added IS NULL
    ) AS null_date_added

FROM world_layoffs.layoffs_staging2;


-- ============================================================
-- 3. CHECK EMPTY STRINGS
-- ============================================================

-- Empty strings are different from NULL in PostgreSQL.
-- Check text columns for empty or whitespace-only values.

SELECT
    COUNT(*) FILTER (
        WHERE TRIM(company) = ''
    ) AS empty_company,

    COUNT(*) FILTER (
        WHERE TRIM(location) = ''
    ) AS empty_location,

    COUNT(*) FILTER (
        WHERE TRIM(industry) = ''
    ) AS empty_industry,

    COUNT(*) FILTER (
        WHERE TRIM(source) = ''
    ) AS empty_source,

    COUNT(*) FILTER (
        WHERE TRIM(stage) = ''
    ) AS empty_stage,

    COUNT(*) FILTER (
        WHERE TRIM(country) = ''
    ) AS empty_country,

    COUNT(*) FILTER (
        WHERE TRIM(date_added) = ''
    ) AS empty_date_added

FROM world_layoffs.layoffs_staging2;


-- ============================================================
-- 4. CONVERT EMPTY TEXT VALUES TO NULL
-- ============================================================

UPDATE world_layoffs.layoffs_staging2
SET company = NULL
WHERE TRIM(company) = '';


UPDATE world_layoffs.layoffs_staging2
SET location = NULL
WHERE TRIM(location) = '';


UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE TRIM(industry) = '';


UPDATE world_layoffs.layoffs_staging2
SET source = NULL
WHERE TRIM(source) = '';


UPDATE world_layoffs.layoffs_staging2
SET stage = NULL
WHERE TRIM(stage) = '';


UPDATE world_layoffs.layoffs_staging2
SET country = NULL
WHERE TRIM(country) = '';


UPDATE world_layoffs.layoffs_staging2
SET date_added = NULL
WHERE TRIM(date_added) = '';


-- ============================================================
-- 5. REVIEW MISSING LAYOFF INFORMATION
-- ============================================================

-- Records where total_laid_off is missing.

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
ORDER BY "date";


-- Records where percentage_laid_off is missing.

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off IS NULL
ORDER BY "date";


-- ============================================================
-- 6. IDENTIFY RECORDS WITH BOTH VALUES MISSING
-- ============================================================

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL
ORDER BY "date";


-- Count records with both values missing.

SELECT COUNT(*) AS missing_layoff_information
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


-- ============================================================
-- 7. NULL HANDLING DECISION
-- ============================================================

-- We intentionally DO NOT replace NULL values with zero.
--
-- For example:
--
-- total_laid_off = NULL
--
-- does not necessarily mean:
--
-- total_laid_off = 0
--
-- It means the information is missing or unavailable.
--
-- Likewise, a NULL funds_raised value does not mean that the
-- company raised zero dollars.
--
-- Records containing useful information in at least one of
-- total_laid_off or percentage_laid_off are retained.
--
-- Records where BOTH are NULL will be removed in:
--
-- 05_remove_unusable_data.sql


-- ============================================================
-- 8. FINAL NULL SUMMARY
-- ============================================================

SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (
        WHERE total_laid_off IS NULL
    ) AS missing_total_laid_off,

    COUNT(*) FILTER (
        WHERE percentage_laid_off IS NULL
    ) AS missing_percentage_laid_off,

    COUNT(*) FILTER (
        WHERE industry IS NULL
    ) AS missing_industry,

    COUNT(*) FILTER (
        WHERE country IS NULL
    ) AS missing_country,

    COUNT(*) FILTER (
        WHERE funds_raised IS NULL
    ) AS missing_funds_raised,

    COUNT(*) FILTER (
        WHERE source IS NULL
    ) AS missing_source,

    COUNT(*) FILTER (
        WHERE stage IS NULL
    ) AS missing_stage,

    COUNT(*) FILTER (
        WHERE date_added IS NULL
    ) AS missing_date_added

FROM world_layoffs.layoffs_staging2;


-- ============================================================
-- NULL HANDLING COMPLETE
-- ============================================================