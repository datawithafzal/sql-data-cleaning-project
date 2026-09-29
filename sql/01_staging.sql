-- ============================================================
-- SQL Data Cleaning Project
-- PostgreSQL
--
-- File: 01_staging.sql
-- Purpose: Create staging tables so the raw dataset remains
--          unchanged during the cleaning process.
-- ============================================================


-- ============================================================
-- 1. REVIEW RAW DATA
-- ============================================================

SELECT *
FROM world_layoffs.layoffs;


-- ============================================================
-- 2. CREATE FIRST STAGING TABLE
-- ============================================================

DROP TABLE IF EXISTS world_layoffs.layoffs_staging;

CREATE TABLE world_layoffs.layoffs_staging
(LIKE world_layoffs.layoffs INCLUDING ALL);


-- Copy the raw data into the staging table.

INSERT INTO world_layoffs.layoffs_staging
SELECT *
FROM world_layoffs.layoffs;


-- ============================================================
-- 3. VERIFY FIRST STAGING TABLE
-- ============================================================

SELECT *
FROM world_layoffs.layoffs_staging
LIMIT 20;


SELECT COUNT(*) AS staging_row_count
FROM world_layoffs.layoffs_staging;


-- ============================================================
-- 4. CREATE SECOND STAGING TABLE
-- ============================================================

DROP TABLE IF EXISTS world_layoffs.layoffs_staging2;

CREATE TABLE world_layoffs.layoffs_staging2
(LIKE world_layoffs.layoffs_staging INCLUDING ALL);


-- Copy the staging data into the second staging table.

INSERT INTO world_layoffs.layoffs_staging2
SELECT *
FROM world_layoffs.layoffs_staging;


-- ============================================================
-- 5. VERIFY SECOND STAGING TABLE
-- ============================================================

SELECT *
FROM world_layoffs.layoffs_staging2
LIMIT 20;


SELECT COUNT(*) AS staging2_row_count
FROM world_layoffs.layoffs_staging2;


-- ============================================================
-- 6. CHECK STAGING TABLE STRUCTURE
-- ============================================================

SELECT
    ordinal_position,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'world_layoffs'
  AND table_name = 'layoffs_staging2'
ORDER BY ordinal_position;


-- ============================================================
-- STAGING COMPLETE
-- ============================================================
--
-- Raw table:
--     world_layoffs.layoffs
--
-- Working table:
--     world_layoffs.layoffs_staging2
--
-- The raw table has not been modified.
-- ============================================================