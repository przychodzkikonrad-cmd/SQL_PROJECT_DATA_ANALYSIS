
SELECT
    skills_dim.skills,
    count(skills_job.job_id) AS demand_count


FROM   
    job_postings_fact AS job_postings
    INNER JOIN skills_job_dim AS skills_job ON job_postings.job_id = skills_job.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = '1'

GROUP BY
    Skills_dim.skills
ORDER BY
    demand_count DESC
LIMIT 5