 SELECT
    job_id, 
    job_title, 
    job_location, 
    job_schedule_type,
    salary_year_avg, 
    job_posted_date,
    name as company_name
FROM job_postings_fact AS job_postings
    left join company_dim on company_dim.company_id = job_postings.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg is not NULL AND
    job_location = 'Anywhere'
GROUP BY
    job_id,
    company_name
ORDER BY
    salary_year_avg DESC
LIMIT 10