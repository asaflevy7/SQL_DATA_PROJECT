/*
Question: What are the most in-demand skills for data analysts?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market,
  providing insights into the most valuable skills for job seekers.
*/

SELECT 
    skills,
    count (job_postings_fact.job_id) as count
from job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY count DESC
LIMIT 5    

/*
Summary:
- This query finds the top 5 in-demand skills for Data Analyst roles across all postings.
- Results: SQL (92,628), Excel (67,031), Python (57,326), Tableau (46,554), Power BI (39,468).
- Takeaways: SQL is the clear must-have; Excel and Python follow. At least one BI tool (Tableau/Power BI) is also highly valued.
*/
