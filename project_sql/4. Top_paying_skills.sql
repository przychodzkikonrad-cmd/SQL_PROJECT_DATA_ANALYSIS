
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

/*
An examination of the highest-paying skills for data analysts reveals a clear shift in what the market values most. The skills associated with the top salaries are no longer the traditional analytical tools such as Excel, SQL, or basic BI platforms. Instead, the most lucrative roles are built around technologies typically linked to data engineering, large-scale computation, machine learning workflows, and modern cloud infrastructure.

At the very top of the salary range we see skills like PySpark, Databricks, and Airflow — tools deeply rooted in the Big Data ecosystem. Their presence highlights an important trend: analysts who know how to work with distributed systems, large datasets, and automated data pipelines are crossing into territory that used to belong almost exclusively to data engineers. This intersection of roles dramatically increases compensation because it requires a blend of analytical thinking and engineering-level technical expertise.

Alongside big-data tools, high salaries are also associated with machine-learning libraries and advanced analytics environments. Skills such as Pandas, NumPy, scikit-learn, Jupyter, and even automated ML platforms like DataRobot consistently appear among the top earners. This suggests that analysts who can move beyond descriptive reporting and contribute to predictive modeling, statistical experimentation, and algorithmic workflows are significantly more valuable to employers.

Another striking trend is the appearance of DevOps-related tools among the top-paying skills. GitLab, Bitbucket, Jenkins, and Atlassian tools show up with impressive salary levels. These are not analytical tools in the classical sense — their high value reflects how the role of the analyst is evolving. In leading analytics teams, analysts are not isolated report builders; they work within software-engineering environments, collaborate through version control, deploy analytical products, and operate within structured development workflows. The market strongly rewards this ability to function inside modern, engineering-driven ecosystems.

Cloud technologies also play a major role in higher analyst compensation. Skills involving GCP, Kubernetes, Linux, and ElasticSearch appear among the most lucrative. Companies increasingly rely on scalable, cloud-native infrastructures, and analysts capable of navigating these environments are essential. These skills signal an analyst who is comfortable not just working with data, but working within distributed systems where data lives — a distinction that carries significant economic value.

Even specialized databases and modern query engines appear high on the list. Tools such as Couchbase, PostgreSQL, and ElasticSearch reinforce the idea that high-earning analysts are those who are able to handle data stored in diverse formats, at high scale, and in environments far more complex than a traditional relational database.

Taken together, these patterns point to a clear conclusion: the highest-paying data analyst roles look very different from the traditional image of an analyst generating dashboards and monthly reports. Instead, the best-compensated analysts operate at the intersection of analytics, engineering, and machine learning. They write production-grade code, work with massive datasets, understand cloud platforms, integrate with DevOps workflows, and support advanced analytical models.

In short, the market rewards analysts who have evolved into hybrid technical professionals. The more an analyst can operate like a data engineer — while still thinking analytically — the higher the salary ceiling becomes.
*/