# SQL Project: Data Analyst Job Market Analysis

## Introduction
This project explores the data analyst job market through the lens of SQL. By analyzing real-world job postings, I aimed to uncover the most lucrative opportunities, identify essential skills, and understand the intersection of high demand and high salary in data analytics.

## Background
The driving force behind this project was a desire to navigate the job market with data-backed confidence. Rather than guessing, I wanted to identify exactly which skills are most valued and highly paid.

The dataset comes from **Luke Barousse’s SQL Course** (https://www.lukebarousse.com/sql). It provides granular data on job titles, salaries, locations, and required skills.

### Key Questions
My analysis focused on answering the following:
1. What are the **highest-paying** data analyst roles?
2. What **skills** are required for these top-tier jobs?
3. Which skills are most **in-demand**?
4. Which skills correlate with **higher salaries**?
5. What are the **optimal skills** to learn for maximum market value?

## Tools Used
* **SQL:** The core tool for querying the database and extracting insights.
* **PostgreSQL:** The database management system used to handle the job data.
* **Visual Studio Code:** The environment used for database management and query execution.
* **Git & GitHub:** For version control and project sharing.

## Analysis
Each query below targets a specific aspect of the job market.

### 1. Top Paying Data Analyst Jobs
To find the earning ceiling, I filtered Data Analyst positions by average yearly salary and location, specifically looking for remote opportunities. This highlights the highest-paying roles available globally.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
WHERE
    job_title = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_location = 'Anywhere'
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
![top_paying_jobs](assets\top_paying_jobs.png)

### 2. Skills for Top Paying Jobs
Identifying high salaries is only half the battle; understanding *why* they are paid so well is crucial. To uncover this, I joined the job postings with the skills table to reveal the specific technical requirements for these top-tier roles.

```sql
WITH top_paying_jobs AS (
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
)
SELECT
    top_paying_jobs.job_id,
    top_paying_jobs.job_title,
    top_paying_jobs.salary_year_avg,
    skills_dim.skills
FROM   
    skills_job_dim AS skills_job
    INNER JOIN top_paying_jobs ON top_paying_jobs.job_id = skills_job.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job.skill_id
    
```
![top_paying_jobs](assets\top_paying_skills.png)
    
### 3. In-Demand Skills for Data Analysts
To understand the foundational requirements of the industry, I analyzed which skills appear most frequently in job postings. This query helps identify the must-have tools that offer the highest job security.

```sql
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
```
### 4. Skills Based on Salary
To identify skills that command a financial premium, I calculated the average annual salary associated with each required technical ability. This analysis helps distinguish high-value specializations within the Data Analyst role.

```sql
SELECT
 	skills_dim.skills,
 	ROUND(avg(job_postings.salary_year_avg),0) AS Salary
FROM 	
 	job_postings_fact AS job_postings
 	INNER JOIN skills_job_dim AS skills_job ON job_postings.job_id = skills_job.job_id
 	INNER JOIN skills_dim ON skills_dim.skill_id = skills_job.skill_id
WHERE
 	job_title_short = 'Data Analyst' AND
 	job_work_from_home = '1' AND
 	salary_year_avg IS NOT NULL

GROUP BY
 	Skills_dim.skills
ORDER BY
 	Salary DESC
LIMIT 25
```

### 5. Most Optimal Skills to Learn
The final piece of the puzzle was to identify the "sweet spot"—skills that offer both high demand (job security) and high financial rewards. This query identifies the most optimal technical skills to learn for maximizing career value.

```sql
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
        skills_dim.skill_id), average_salary AS (
    SELECT
         skills_job_dim.skill_id,
        AVG(job_postings_fact.salary_year_avg) AS avg_salary
    FROM
        job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
           
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_postings_fact.salary_year_avg IS NOT NULL
        AND job_postings_fact.job_work_from_home = True
    GROUP BY
            skills_job_dim.skill_id)
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

```
## What I Learned
This project served as a practical playground to advance my SQL capabilities. Moving beyond basic syntax, I focused on solving real-world problems using data.

* **Advanced Query Development:** I mastered the art of complex query construction, utilizing **Common Table Expressions (CTEs)** and multiple **JOINs** to organize and merge data efficiently.
* **Data Summarization:** I honed my ability to extract meaningful trends from raw data using aggregate functions like `COUNT()` and `AVG()` combined with `GROUP BY` clauses.
* **Analytical Problem Solving:** The biggest takeaway was learning how to translate abstract career questions (e.g., "What skill pays the best?") into precise, executable SQL logic.

## Key Insights
My analysis of the job market revealed several critical trends for aspiring data analysts:

1.  **Remote Work Pays:** The highest-paying data analyst roles are often remote-friendly, with top salaries peaking at an impressive **$650,000**.
2.  **SQL is Non-Negotiable:** SQL is not just a basic requirement; it is the most in-demand skill and a prerequisite for nearly all top-tier, high-paying positions.
3.  **The "Sweet Spot" for Learners:** For those starting out, **SQL** represents the optimal balance of high market demand and strong salary potential, making it the best first skill to master.
4.  **Niche Skills Command Premiums:** While foundational skills get you the job, specialized knowledge in areas like **SVN** or **Solidity** is associated with the highest average salaries, rewarding those with niche expertise.

## Conclusion
This project was more than just a coding exercise; it was a strategic analysis of the data analytics career landscape. The insights gained here provide a data-driven roadmap for skill acquisition.

By prioritizing high-value skills like SQL and understanding market trends, aspiring analysts can position themselves effectively for both job security and financial growth. This exploration underscores the importance of continuous learning in a field that rewards adaptability.
