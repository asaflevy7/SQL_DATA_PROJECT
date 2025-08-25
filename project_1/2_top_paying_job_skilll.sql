/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills,
  helping job seekers understand which skills to develop that align with top salaries
*/

with top_10_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        name as company_name,
        salary_year_avg,
        job_posted_date
    from job_postings_fact
    left JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    where 
        job_title_short = 'Data Analyst'  AND
        job_location = 'Anywhere' AND 
        salary_year_avg is NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_10_paying_jobs.*,
    skills
from top_10_paying_jobs
INNER JOIN skills_job_dim on top_10_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC

/*
So our conclusions about the most important skills for the highest-paying jobs are:
SQL is leading with a bold count of 8.
Python follows closely with a bold count of 7.
Tableau is also highly sought after, with a bold count of 6.
Other skills like R, Snowflake, Pandas, and Excel show varying degrees of demand.
*/
