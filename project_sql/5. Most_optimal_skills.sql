WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM
        job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_postings_fact.salary_year_avg IS NOT NULL
        AND job_postings_fact.job_work_from_home = True
    GROUP BY
        skills_dim.skill_id
), average_salary AS (
    SELECT
         skills_job_dim.skill_id,
        AVG(job_postings_fact.salary_year_avg) AS avg_salary
    FROM
        job_postings_fact
        INNER JOIN
                skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
           
    WHERE
            job_postings_fact.job_title_short = 'Data Analyst'
            AND job_postings_fact.salary_year_avg IS NOT NULL
            AND job_postings_fact.job_work_from_home = True
    GROUP BY
            skills_job_dim.skill_id
)
SELECT
    skills_demand.skills,
    skills_demand.demand_count,
    average_salary.avg_salary
FROM skills_demand
    INNER JOIN average_salary ON average_salary.skill_id = skills_demand.skill_id
WHERE
    demand_count > 10 

GROUP BY
    skills_demand.skills,
    skills_demand.demand_count,
    average_salary.avg_salary
ORDER BY
  demand_count DESC, 
	avg_salary DESC
LIMIT 10
