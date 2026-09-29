-- ============================================================
-- SQL Data Cleaning Project
-- PostgreSQL
--
-- File: 06_final_checks.sql
-- Purpose: Validate the final cleaned dataset.
-- ============================================================


-- ============================================================
-- 1. FINAL ROW COUNT
-- ============================================================

SELECT COUNT(*) AS final_row_count
FROM world_layoffs.layoffs_staging2;


-- ============================================================
-- 2. VERIFY RAW DATA WAS NOT MODIFIED
-- ============================================================

SELECT COUNT(*) AS raw_row_count
FROM world_layoffs.layoffs;


-- ============================================================
-- 3. CHECK FOR EXACT DUPLICATES
-- ============================================================

SELECT
    company,
    location,
    total_laid_off,
    "date",
    percentage_laid_off,
    industry,
    source,
    stage,
    funds_raised,
    country,
    date_added,
    COUNT(*) AS duplicate_count

FROM world_layoffs.layoffs_staging2

GROUP BY
    company,
    location,
    total_laid_off,
    "date",
    percentage_laid_off,
    industry,
    source,
    stage,
    funds_raised,
    country,
    date_added

HAVING COUNT(*) > 1;


-- Expected result:
-- Zero rows.


-- ============================================================
-- 4. CHECK FOR EMPTY STRINGS
-- ============================================================

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE TRIM(COALESCE(company, '')) = ''
   OR TRIM(COALESCE(location, '')) = ''
   OR TRIM(COALESCE(industry, '')) = ''
   OR TRIM(COALESCE(source, '')) = ''
   OR TRIM(COALESCE(stage, '')) = ''
   OR TRIM(COALESCE(country, '')) = ''
   OR TRIM(COALESCE(date_added, '')) = '';


-- Expected result:
-- Zero rows.


-- ============================================================
-- 5. CHECK ROWS WITH NO LAYOFF INFORMATION
-- ============================================================

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


-- Expected result:
-- Zero rows.


-- ============================================================
-- 6. CHECK DATE DATA TYPE
-- ============================================================

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'world_layoffs'
  AND table_name = 'layoffs_staging2'
ORDER BY ordinal_position;


-- The "date" column should have:
--
-- data_type = date


-- ============================================================
-- 7. CHECK DATE RANGE
-- ============================================================

SELECT
    MIN("date") AS earliest_layoff_date,
    MAX("date") AS latest_layoff_date
FROM world_layoffs.layoffs_staging2;


-- ============================================================
-- 8. CHECK NEGATIVE LAYOFF VALUES
-- ============================================================

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off < 0;


-- Expected result:
-- Zero rows.


-- ============================================================
-- 9. CHECK NEGATIVE FUNDING VALUES
-- ============================================================

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE funds_raised < 0;


-- Expected result:
-- Zero rows.


-- ============================================================
-- 10. CHECK PERCENTAGE VALUES
-- ============================================================

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off < 0
   OR percentage_laid_off > 1;


-- Expected result:
-- Zero rows for percentages stored between 0 and 1.


-- ============================================================
-- 11. CHECK MISSING VALUES
-- ============================================================

SELECT
    COUNT(*) AS total_rows,

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
-- 12. CHECK STANDARDIZED INDUSTRY VALUES
-- ============================================================

SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
ORDER BY industry;


-- ============================================================
-- 13. CHECK STANDARDIZED COUNTRY VALUES
-- ============================================================

SELECT DISTINCT country
FROM world_layoffs.layoffs_staging2
ORDER BY country;


-- ============================================================
-- 14. CHECK CRYPTO STANDARDIZATION
-- ============================================================

SELECT DISTINCT industry
FROM world_layoffs.layoffs_staging2
WHERE industry ILIKE '%crypto%'
ORDER BY industry;


-- Expected:
-- Crypto


-- ============================================================
-- 15. FINAL SAMPLE
-- ============================================================

SELECT *
FROM world_layoffs.layoffs_staging2
ORDER BY "date"
LIMIT 20;


-- ============================================================
-- CLEANING VALIDATION COMPLETE
-- ============================================================
--
-- Raw table:
--     world_layoffs.layoffs
--
-- Cleaned table:
--     world_layoffs.layoffs_staging2
--
-- Cleaning steps:
--
-- 1. Created staging tables
-- 2. Identified duplicate records
-- 3. Removed exact duplicates
-- 4. Standardized industry values
-- 5. Standardized country values
-- 6. Converted date from VARCHAR to DATE
-- 7. Converted empty strings to NULL
-- 8. Reviewed missing values
-- 9. Removed records with no layoff information
-- 10. Performed final data quality checks
--
-- ============================================================