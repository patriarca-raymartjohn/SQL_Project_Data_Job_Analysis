CREATE TABLE january_jobs AS
  SELECT *
  FROM job_postings_fact
  WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
  SELECT *
  FROM job_postings_fact
  WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
  SELECT *
  FROM job_postings_fact
  WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT *
FROM march_jobs
ORDER BY job_posted_date ASC;

SELECT 
  job_title_short,
  job_location
FROM job_postings_fact;

/*

Label new colums as follows:
- 'Anywhere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- Otherwise 'Onsite'
*/

SELECT 
  job_title_short,
  job_location,
  CASE 
    WHEN job_location = 'Anywhere' THEN 'Remote'
    WHEN job_location = 'New York, NY' THEN 'Local'
    ELSE 'Onsite'
  END AS location_category
FROM job_postings_fact;

SELECT 
  COUNT(job_id) AS number_of_jobs,
  CASE 
    WHEN job_location = 'Anywhere' THEN 'Remote'
    WHEN job_location = 'New York, NY' THEN 'Local'
    ELSE 'Onsite'
  END AS location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_category;

SELECT *
FROM
  (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
  ) AS january_jobs;

SELECT
  company_id,
  name AS company_name
FROM
  company_dim
WHERE company_id IN (
  SELECT
    company_id
  FROM
    job_postings_fact
  WHERE
    job_no_degree_mention = true
  ORDER BY
    company_id
);


/*
FInd the companies that have the most job openings.
Get the total number if job postings per company id
Return the total number of jobs with the company name
*/

WITH company_job_count AS (
  SELECT
    company_id,
    COUNT(*) AS total_jobs
  FROM
    job_postings_fact
  GROUP BY
    company_id
)

SELECT 
  company_dim.name AS company_name,
  company_job_count.total_jobs

FROM company_dim
LEFT JOIN company_job_count
ON company_job_count.company_id = company_dim.company_id 
ORDER BY company_job_count.total_jobs DESC


