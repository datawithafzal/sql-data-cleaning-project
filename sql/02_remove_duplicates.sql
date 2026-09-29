-- ============================================================
-- SQL Data Cleaning Project
-- PostgreSQL
--
-- File: 02_remove_duplicates.sql
-- Purpose: Identify and remove exact duplicate records.
-- ============================================================


-- ============================================================
-- 1. REVIEW THE DATA
-- ============================================================

SELECT *
FROM world_layoffs.layoffs_staging2
LIMIT 20;


-- ============================================================
-- 2. CHECK FOR POTENTIAL DUPLICATES
-- ============================================================

-- First, look for repeated combinations of company,
-- industry, total layoffs, and date.

SELECT
    company,
    industry,
    total_laid_off,
    "date",
    COUNT(*) AS duplicate_count
FROM world_layoffs.layoffs_staging2
GROUP BY
    company,
    industry,
    total_laid_off,
    "date"
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- ============================================================
-- 3. IDENTIFY EXACT DUPLICATES
-- ============================================================

-- ROW_NUMBER() assigns a number to each identical record.
-- The first record receives row_number = 1.
-- Additional identical records receive 2, 3, etc.

SELECT *
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY
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
            ORDER BY company
        ) AS row_num
    FROM world_layoffs.layoffs_staging2
) duplicates
WHERE row_num > 1;


-- ============================================================
-- 4. COUNT EXACT DUPLICATES
-- ============================================================

SELECT COUNT(*) AS duplicate_rows
FROM (
    SELECT
        ROW_NUMBER() OVER (
            PARTITION BY
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
            ORDER BY company
        ) AS row_num
    FROM world_layoffs.layoffs_staging2
) duplicates
WHERE row_num > 1;


-- ============================================================
-- 5. REMOVE EXACT DUPLICATES
-- ============================================================

-- PostgreSQL does not have MySQL's DELETE JOIN syntax.
-- We use the system column ctid to identify the physical
-- rows that should be removed.
--
-- The first occurrence of each exact duplicate is retained.

DELETE FROM world_layoffs.layoffs_staging2
WHERE ctid IN (
    SELECT duplicate_ctid
    FROM (
        SELECT
            ctid AS duplicate_ctid,
            ROW_NUMBER() OVER (
                PARTITION BY
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
                ORDER BY ctid
            ) AS row_num
        FROM world_layoffs.layoffs_staging2
    ) duplicates
    WHERE row_num > 1
);


-- ============================================================
-- 6. VERIFY DUPLICATE REMOVAL
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


-- The query above should return zero rows.


-- ============================================================
-- 7. CHECK REMAINING ROW COUNT
-- ============================================================

SELECT COUNT(*) AS rows_after_duplicate_removal
FROM world_layoffs.layoffs_staging2;


-- ============================================================
-- DUPLICATE REMOVAL COMPLETE
-- ============================================================
