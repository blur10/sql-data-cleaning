select * from layoffs;

-- 3. Null Values and Banck Values
-- 4. Remove any Column(s)

-- 1. Remove Duplicates
Create Table layoffs_staging
Like Layoffs;

INSERT layoffs_staging
SELECT * 
FROM layoffs;

SELECT * 
FROM layoffs_staging;

SELECT *,
ROW_NUMBER() OVER(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
) row_num
FROM layoffs_staging;

with duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
) row_num
FROM layoffs_staging
)
select * FROM duplicate_cte
where row_num >1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
) row_num
FROM layoffs_staging;

delete 
from layoffs_staging2
where row_num > 1;

select *
from layoffs_staging2

-- 2. Standardize Data

