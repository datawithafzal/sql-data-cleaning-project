-- ============================================================
-- SQL Data Cleaning Project
-- PostgreSQL
--
-- File: 05_remove_unusable_data.sql
-- Purpose: Remove records that contain no usable layoff
--          measurement.
-- ============================================================


-- ============================================================
-- 1. REVIEW RECORDS WITH NO LAYOFF INFORMATION
-- ============================================================

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL
ORDER BY "date";


-- ============================================================
-- 2. COUNT RECORDS BEFORE DELETION
-- ============================================================

SELECT COUNT(*) AS rows_to_remove
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


-- ============================================================
-- 3. REMOVE UNUSABLE RECORDS
-- ============================================================

DELETE FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


-- ============================================================
-- 4. VERIFY REMOVAL
-- ============================================================

SELECT COUNT(*) AS remaining_unusable_rows
FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


-- This should return:
--
-- remaining_unusable_rows
-- ----------------------
-- 0


-- ============================================================
-- 5. CHECK REMAINING ROW COUNT
-- ============================================================

SELECT COUNT(*) AS final_cleaned_rows
FROM world_layoffs.layoffs_staging2;


-- ============================================================
-- 6. REVIEW FINAL CLEANED DATA
-- ============================================================

SELECT *
FROM world_layoffs.layoffs_staging2
ORDER BY "date";


-- ============================================================
-- 7. CONFIRM RAW TABLE WAS NOT MODIFIED
-- ============================================================

SELECT COUNT(*) AS raw_rows
FROM world_layoffs.layoffs;


-- ============================================================
-- DATA REMOVAL COMPLETE
-- ============================================================
--
-- Only records with BOTH:
--
-- total_laid_off IS NULL
-- AND
-- percentage_laid_off IS NULL
--
-- were removed.
--
-- The raw table remains unchanged.
-- ============================================================