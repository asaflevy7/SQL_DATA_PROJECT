/*
Question: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and
  helps identify the most financially rewarding skills to acquire or improve
*/


SELECT 
    skills,
    round (avg (job_postings_fact.salary_year_avg), 0)  as avg_salary
from job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' and salary_year_avg is NOT NULL
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 50

/*
Summary:
- Ranks skills by average stated salary for Data Analyst roles (salary present).
- Highest-paying examples in this run include: SVN (~$400k, likely an outlier), Solidity, Couchbase, DataRobot, Go, MXNet, Terraform, Twilio, GitLab, Kafka.
- Takeaways: niche/engineering or ML platform skills tend to command higher pay; check sample sizes and remove outliers before final reporting.
- Next step: combine with the “in-demand skills” query to find skills that are both high-paying and frequently requested.
*/
