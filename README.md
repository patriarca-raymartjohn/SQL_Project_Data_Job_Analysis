# Introduction
What does the data analyst job market actually look like when you cut through the noise? That's the question I set out to answer with SQL — digging into real job postings to figure out which roles pay the most, which skills keep showing up, and where the overlap between "pays well" and "in demand" actually sits.

This is the capstone project from [Luke Barousse's SQL for Data Analytics course](https://lukebarousse.com/sql), tackled in my own way.

SQL Queries? Check them out here: [project_sql folder](/project_sql/)

# Background
I started this project as a way to sharpen my SQL while answering a question I actually cared about: if I were planning a career as a data analyst, where should I focus my energy? Job boards give you anecdotes; a database gives you patterns. So I worked through one.

The dataset comes from Luke Barousse's [SQL Course](https://lukebarousse.com/sql) and contains thousands of 2023 job postings with titles, salaries, locations, companies, and the skills attached to each role — enough to ask interesting questions and get answers that hold up.

### The questions I wanted to answer through my SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
- **SQL**: The main tool I leaned on — every insight in this project came from a query, from simple filters to multi-CTE joins.
- **PostgreSQL**: The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code**: My go-to for database management and executing SQL queries.
- **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Here's how I approached each question:

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

```sql
SELECT
    job_id,
    company_dim.name AS company_name,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN
    company_dim
    ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
Here's the breakdown of the top data analyst jobs in 2023:
- **Wide Salary Range:** Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety:** There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

See the full query: [1_top_paying_jobs.sql](/project_sql/1_top_paying_jobs.sql)

### 2. Skills For Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

```sql
WITH top_paying_jobs AS (
    SELECT
      job_id,
      job_title,
      salary_year_avg,
      company_dim.name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN
        company_dim
        ON company_dim.company_id = job_postings_fact.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
  salary_year_avg DESC;
```
Here's the breakdown of the most demanded skills for the top 10 highest paying data analyst jobs in 2023:
- **SQL** is leading with a bold count of 8.
- **Python** follows closely with a count of 7.
- **Tableau** is also highly sought after, with a count of 6.
- Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** show varying degrees of demand.

See the full query: [2_top_paying_job_skills.sql](/project_sql/2_top_paying_job_skills.sql)

### 3. In-Demand Skills for Data Analysts
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

```sql
SELECT
  skills,
  COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
  job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
```
Here's the breakdown of the most demanded skills for data analysts in 2023:
- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation.
- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

| Skill    | Demand Count |
|----------|--------------|
| SQL      | 92,628       |
| Excel    | 67,031       |
| Python   | 57,326       |
| Tableau  | 46,554       |
| Power BI | 39,468       |

See the full query: [3_top_demanded_skills.sql](/project_sql/3_top_demanded_skills.sql)

### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT
  skills,
  ROUND(AVG(salary_year_avg), 2) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
  job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY average_salary DESC
LIMIT 25;
```
Here's a breakdown of the results for top paying skills for Data Analysts:
- **High Demand for Big Data & ML Skills:** Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
- **Software Development & Deployment Proficiency:** Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
- **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

| Skill        | Average Salary ($) |
|--------------|--------------------|
| svn          | 400,000            |
| solidity     | 179,000            |
| couchbase    | 160,515            |
| datarobot    | 155,486            |
| golang       | 155,000            |
| mxnet        | 149,000            |
| dplyr        | 147,633            |
| vmware       | 147,500            |
| terraform    | 146,734            |
| twilio       | 138,500            |

See the full query: [4_top_paying_skills.sql](/project_sql/4_top_paying_skills.sql)

### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
WITH skills_demand AS (
    SELECT
      skills_job_dim.skill_id,
      skills_dim.skills,
      COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim
        ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim
        ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
      job_title_short = 'Data Analyst'
      AND salary_year_avg IS NOT NULL
      AND job_work_from_home = TRUE
    GROUP BY
      skills_job_dim.skill_id,
      skills_dim.skills
),

average_salary AS (
    SELECT
      skills_job_dim.skill_id,
      skills_dim.skills,
      ROUND(AVG(salary_year_avg), 2) AS average_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim
        ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim
        ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
      job_title_short = 'Data Analyst'
      AND salary_year_avg IS NOT NULL
      AND job_work_from_home = TRUE
    GROUP BY
      skills_job_dim.skill_id,
      skills_dim.skills
)

SELECT
  skills_demand.skill_id,
  skills_demand.skills,
  demand_count,
  average_salary.average_salary
FROM skills_demand
INNER JOIN average_salary
  ON skills_demand.skill_id = average_salary.skill_id
WHERE
  demand_count > 10
ORDER BY average_salary DESC, demand_count DESC
LIMIT 25;
```

| Skill ID | Skill      | Demand Count | Average Salary ($) |
|----------|------------|--------------|--------------------|
| 8        | go         | 27           | 115,320            |
| 234      | confluence | 11           | 114,210            |
| 97       | hadoop     | 22           | 113,193            |
| 80       | snowflake  | 37           | 112,948            |
| 74       | azure      | 34           | 111,225            |
| 77       | bigquery   | 13           | 109,654            |
| 76       | aws        | 32           | 108,317            |
| 4        | java       | 17           | 106,906            |
| 194      | ssis       | 12           | 106,683            |
| 233      | jira       | 20           | 104,918            |

Here's a breakdown of the most optimal skills for Data Analysts in 2023:
- **High-Demand Programming Languages:** Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
- **Cloud Tools and Technologies:** Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools:** Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
- **Database Technologies:** The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.

See the full query: [5_optimal_skills.sql](/project_sql/5_optimal_skills.sql)

# What I Learned
Working through this project strengthened my SQL fundamentals and gave me practical experience applying them to real analytical problems:
- **Advanced Query Construction:** Developed proficiency in writing complex queries, including multi-table joins and the use of common table expressions (CTEs) to structure intermediate results.
- **Data Aggregation:** Gained a working command of `GROUP BY` alongside aggregate functions such as `COUNT()` and `AVG()` to summarize large datasets effectively.
- **Analytical Problem-Solving:** Strengthened my ability to translate open-ended business questions into well-scoped SQL queries that produce clear, actionable insights.

# Conclusions

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs:** The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs:** High-paying data analyst jobs require advanced proficiency in SQL, suggesting it's a critical skill for earning a top salary.
3. **Most In-Demand Skills:** SQL is also the most demanded skill in the data analyst job market, making it essential for job seekers.
4. **Skills with Higher Salaries:** Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value:** SQL leads in demand and offers a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts
This project enhanced my SQL skills and provided valuable insights into the data analyst job market. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.
