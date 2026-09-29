# SQL Data Cleaning Project – 2022 Layoffs Dataset

## Overview
This project focuses on cleaning and preparing the [2022 Layoffs Dataset](https://www.kaggle.com/datasets/swaptr/layoffs-2022) sourced from Kaggle using **pure SQL**. The dataset contains data on employee layoffs across companies, countries, and industries, collected during the economic downturn of 2022.
The primary objective is to clean and structure the data using best practices in SQL so it's ready for analysis, reporting, or machine learning applications.

---

## Objectives
- Create a staging environment to preserve raw data.
- Identify and remove duplicate rows.
- Standardize inconsistent values (e.g., date formats, industry names, country names).
- Handle null and missing values appropriately.
- Drop or remove unusable rows and unnecessary columns.

---

## Dataset Source

- Kaggle Dataset: [Layoffs 2022](https://www.kaggle.com/datasets/swaptr/layoffs-2022)
- Format: CSV
- Imported into PostgreSQL for cleaning

---
## Project Structure
sql-data-cleaning-project/
│
├── layoffs.csv
├── README.md
│
└── sql/
    ├── 01_staging.sql
    ├── 02_remove_duplicates.sql
    ├── 03_standardize_data.sql
    ├── 04_handle_nulls.sql
    ├── 05_remove_unusable_data.sql
    └── 06_final_checks.sql

## Data Cleaning Steps
### 1. Data Staging
- Created a separate `layoffs_staging` and `layoffs_staging2` table to ensure raw data is not altered.
- All data cleaning steps were performed on staging tables.

### 2. Duplicate Removal
- Used the `ROW_NUMBER()` window function to detect true duplicates.
- Deleted rows with identical values across all relevant columns except for one.

### 3. Standardization
- **Industry Names:** Unified values like "Crypto Currency" and "CryptoCurrency" to "Crypto".
- **Country Names:** Trimmed trailing punctuation like "United States." → "United States".
- **Dates:** Converted date strings to `DATE` type using `STR_TO_DATE()`.

### 4. Handling Nulls and Empty Fields
- Replaced empty strings with `NULL` for consistency.
- Used self-joins to populate missing `industry` values where other records from the same company had it filled.
- Retained meaningful nulls in numeric fields for accurate calculations.

### 5. Removing Unusable Rows
- Deleted rows where both `total_laid_off` and `percentage_laid_off` were `NULL`.
- Dropped temporary columns (like `row_num`) used for cleaning operations.

---

## Final Schema Overview
| Column Name              | Description                                        |
|--------------------------|----------------------------------------------------|
| `company`                | Name of the company                                |
| `location`               | City or regional location of the company           |
| `industry`               | Industry segment the company belongs to            |
| `total_laid_off`         | Number of employees laid off                       |
| `percentage_laid_off`    | Percentage of employees laid off                   |
| `date`                   | Date of layoff event                               |
| `stage`                  | Company growth stage (e.g., Series A, Public)      |
| `country`                | Country where the company is located               |
| `funds_raised_millions`  | Total funds raised by the company (in millions USD)|
| `date_added`             | Date the record was added                          |

---

## Tools Used
- PostgreSQL
- SQL (Window Functions, CTEs, Date functions, Joins)
