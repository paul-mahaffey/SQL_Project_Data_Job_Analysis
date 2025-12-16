/*
Answer: What are the most optimal skills to learn (aka it's in high demand and a high paying skill)?
- Identify skills in high demand and assoicated with high average salaries for Data Analyst roles.
- Concentrates on remote positions with specified salaries.
- Why? Target skills that offer job security (high demand) and financial benefits (high salaries),
    offering strategic insights for career development in data analysis.
*/

WITH skills_demand AS (
    SELECT
        sj.skill_id,
        s.skills,
        COUNT(sj.job_id) AS demand_count
    FROM job_postings_fact j
    INNER JOIN skills_job_dim sj
        ON j.job_id = sj.job_id
    INNER JOIN skills_dim s
        ON sj.skill_id = s.skill_id
    WHERE
        j.job_title_short = 'Data Analyst'
        AND j.salary_year_avg IS NOT NULL
        AND j.job_work_from_home = TRUE
    GROUP BY
        sj.skill_id, s.skills
),
average_salary AS (
    SELECT
        sj.skill_id,
        s.skills,
        ROUND(AVG(j.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact j
    INNER JOIN skills_job_dim sj
        ON j.job_id = sj.job_id
    INNER JOIN skills_dim s
        ON sj.skill_id = s.skill_id
    WHERE
        j.job_title_short = 'Data Analyst'
        AND j.salary_year_avg IS NOT NULL
        AND j.job_work_from_home = TRUE
    GROUP BY
        sj.skill_id, s.skills
)
SELECT
    sd.skill_id,
    sd.skills,
    sd.demand_count,
    a.avg_salary
FROM skills_demand sd
INNER JOIN average_salary a
    ON sd.skill_id = a.skill_id
ORDER BY
    sd.demand_count DESC
LIMIT 25