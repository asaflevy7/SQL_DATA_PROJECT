/*
Question: What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries),
  offering strategic insights for career development in data analysis
*/

WITH skills_demand AS (
  SELECT
    sd.skill_id,
    sd.skills,
    COUNT(jpf.job_id) AS demand_count
  FROM public.job_postings_fact AS jpf
  INNER JOIN public.skills_job_dim AS sjd   ON jpf.job_id = sjd.job_id
  INNER JOIN public.skills_dim AS sd  ON sjd.skill_id = sd.skill_id
  WHERE jpf.job_title_short = 'Data Analyst'  AND jpf.salary_year_avg IS NOT NULL
  GROUP BY sd.skill_id, sd.skills
),
average_salary AS (
  SELECT
    sd.skill_id,
    sd.skills,
    ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
  FROM public.job_postings_fact AS jpf
  INNER JOIN public.skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
  INNER JOIN public.skills_dim AS sd  ON sjd.skill_id = sd.skill_id
  WHERE jpf.job_title_short = 'Data Analyst'  AND jpf.salary_year_avg IS NOT NULL
  GROUP BY sd.skill_id, sd.skills
)

SELECT
  skills_demand.skill_id,
  skills_demand.skills,
  skills_demand.demand_count,
  average_salary.avg_salary
FROM skills_demand 
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE skills_demand.demand_count >= 10
ORDER BY skills_demand.demand_count DESC, average_salary.avg_salary DESC
LIMIT 50


/*
Summary:
- Goal: surface “optimal” skills—those with both high demand and strong average salary for Data Analyst roles.
- Method: compute per-skill demand_count (postings count) and avg_salary (avg stated yearly pay), then join the two CTEs; keep skills with demand_count ≥ 10.
- Reading the result: skills like SQL, Excel, Python, Tableau, R, and Power BI rank highly; generic tools (e.g., Word/PowerPoint) can be filtered out if undesired.
- Use: prioritize learning paths that balance market demand and pay; sanity-check sample sizes and outliers before publishing.
*/
