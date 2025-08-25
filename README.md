# Introduction

📈 Dive into the data job market! Focusing on **data analyst** roles, this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in data analytics.


# Background

Driven to navigate the data-analyst job market more effectively, I built this project to pinpoint **top-paid roles** and **in-demand skills**, helping others quickly find optimal opportunities.

### The questions I wanted to answer with SQL:

1. What are the **top-paying data analyst jobs**?
2. What **skills are required** for these top-paying jobs?
3. What **skills are most in demand** for data analysts?
4. Which **skills are associated with higher salaries**?
5. What are the **most optimal skills to learn** (high demand *and* high pay)?




# Tools I Used

- **SQL** – The backbone for querying and extracting insights.
- **PostgreSQL** – Database engine used for the job-posting data.
- **Visual Studio Code** – My go-to for managing the DB and running SQL.
- **Git & GitHub** – Version control and sharing scripts/analysis.


# The Analysis

Each query in this project explores a specific aspect of the data-analyst market. Here’s how I approached the first question.

### 1. Top-Paying Data Analyst Jobs

To identify the highest-paying roles, I filtered positions by **average yearly salary** and **location**, focusing on **remote jobs**. This query highlights high-paying opportunities in the field.

```sql
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
```
### 2. Skills Required for Top-Paying Data Analyst Jobs
We identify the skills used by the top 10 highest-paying remote Data Analyst roles. First we pull the top 10 by stated yearly salary, then join the job–skill mapping to list the skills for each role.

```sql
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
```

 This query lists the highest-paying roles and their required skills, highlighting a recurring core stack (SQL + scripting language + BI tool) in top-salary positions.

 ### 3. Most In-Demand Skills for Data Analysts
We identify the **top 5 most requested skills** across all Data Analyst postings. The query joins postings to the job–skill mapping and counts occurrences per skill.

```sql
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
```

Returns the five most in-demand skills by posting count—useful to prioritize learning the tools employers request most often.

### 4. Top Skills Based on Salary
We compute the **average stated yearly salary** for each skill in Data Analyst roles (only where salary is present), regardless of location. This highlights which skills correlate with higher compensation.

```sql
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
```

 Ranks skills by average salary; niche/engineering or ML-platform tools often appear near the top. Sanity-check sample sizes and remove outliers before final reporting.

### 5. Optimal Skills to Learn (High Demand × High Pay)
We surface skills that are both **highly demanded** and **high paying** for Data Analyst roles. We compute per-skill posting counts and average salary via two CTEs, then join and rank them.

```sql
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
```

This query highlights “optimal” skills—those combining strong demand with higher average salaries—helping prioritize learning paths; consider filtering tiny samples and outliers for final reporting.


# What I Learned

- **🧩 Complex Query Crafting:** Built advanced SQL with multi-table joins and `WITH` (CTE) patterns to answer real questions.
- **📊 Data Aggregation:** Used `GROUP BY`, `COUNT()`, `AVG()`, and filters to summarize and rank insights.
- **💡 Analytical Wizardry:** Translated business questions into actionable SQL, validating results and spotting outliers.

# Conclusions

### Insights
1. **Top-Paying Data Analyst Jobs:** Remote-friendly roles span a wide salary range, with the highest around **$650,000**.
2. **Skills for Top-Paying Jobs:** High-paying roles consistently require **strong SQL**, making it critical for top compensation.
3. **Most In-Demand Skills:** **SQL** also ranks as the most requested skill across postings—essential for job seekers.
4. **Skills with Higher Salaries:** Niche/specialized tech (e.g., **SVN**, **Solidity**) correlates with higher average salaries, reflecting a premium on expertise.
5. **Optimal Skills for Market Value:** **SQL** leads both in demand and average pay—one of the most optimal skills to learn to maximize market value.
