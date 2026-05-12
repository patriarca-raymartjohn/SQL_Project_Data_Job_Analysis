/*
Answer: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and
  help identify the most financially rewarding skills to acquire or improve
*/

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

/*
The highest-paying data analyst skills are increasingly centered around AI, cloud infrastructure, automation, 
  and big data engineering rather than traditional reporting tools.

AI + Engineering skills lead salaries — AI frameworks like PyTorch ($125k), TensorFlow ($121k), and Hugging Face ($124k) rank highly, alongside engineering tools such as Terraform ($147k) and Kafka ($130k).
Infrastructure and automation are highly rewarded — 8 of the top 25 skills are related to cloud, DevOps, or deployment systems, showing strong demand for scalable and automated data workflows.
Traditional analytics tools are no longer premium skills — Excel, Tableau, and Power BI are absent from the top 25, suggesting employers now pay more for analysts with AI, big data, and engineering capabilities.

[
  {
    "skills": "svn",
    "average_salary": "400000.00"
  },
  {
    "skills": "solidity",
    "average_salary": "179000.00"
  },
  {
    "skills": "couchbase",
    "average_salary": "160515.00"
  },
  {
    "skills": "datarobot",
    "average_salary": "155485.50"
  },
  {
    "skills": "golang",
    "average_salary": "155000.00"
  },
  {
    "skills": "mxnet",
    "average_salary": "149000.00"
  },
  {
    "skills": "dplyr",
    "average_salary": "147633.33"
  },
  {
    "skills": "vmware",
    "average_salary": "147500.00"
  },
  {
    "skills": "terraform",
    "average_salary": "146733.83"
  },
  {
    "skills": "twilio",
    "average_salary": "138500.00"
  },
  {
    "skills": "gitlab",
    "average_salary": "134126.00"
  },
  {
    "skills": "kafka",
    "average_salary": "129999.16"
  },
  {
    "skills": "puppet",
    "average_salary": "129820.00"
  },
  {
    "skills": "keras",
    "average_salary": "127013.33"
  },
  {
    "skills": "pytorch",
    "average_salary": "125226.20"
  },
  {
    "skills": "perl",
    "average_salary": "124685.75"
  },
  {
    "skills": "ansible",
    "average_salary": "124370.00"
  },
  {
    "skills": "hugging face",
    "average_salary": "123950.00"
  },
  {
    "skills": "tensorflow",
    "average_salary": "120646.83"
  },
  {
    "skills": "cassandra",
    "average_salary": "118406.68"
  },
  {
    "skills": "notion",
    "average_salary": "118091.67"
  },
  {
    "skills": "atlassian",
    "average_salary": "117965.60"
  },
  {
    "skills": "bitbucket",
    "average_salary": "116711.75"
  },
  {
    "skills": "airflow",
    "average_salary": "116387.26"
  },
  {
    "skills": "scala",
    "average_salary": "115479.53"
  }
]
*/