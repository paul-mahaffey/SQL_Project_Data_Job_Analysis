# Introduction
Hello! in this project, we're diving into the exciting world of data analytics. Specifically, the data analyst job market. We take an adventure of the highest demanded skills, top paying jobs, locations, and if a remote, hybrid, or onsite position is available.

Check out the queries here: [project_sql folder](/project_sql/)
# Background

As an aspiring data analyst, I thought this project would be a great way to learn the tools needed to be a successful data analyst and an introduction into the world of data analytics. This project assisted me in pinpointing areas of data analytics that I found interesting and I would excel (pun intended) in and enjoy!

This project assisted me in finding a lane that I found fun but challenging at the same time. There were bumps in the road, frustration, excitement and success. I'm happy to have gone through this project and the skills I've picked in this small but yet, my first project.

## Questions I wanted to answer through my analysis:

1. What are the top paying data analyst jobs?

2. What skills are required/needed for the top paying jobs and tools needed to be successful?

3. What are the most in demand skills in the data analytics field? Specifically for data analysts?

4. What are the top skills based on salary?

5. What are the most optimal skills to learn (aka it's in high demand and a high paying skill)?

# Tools I used

For my analysis into the data analyst job market, I used the following tools:

1. **SQL** , which was the foundation of my analysis. This allowed me query the database and uncover insights of the provided dataset.

2. **PostgresSQL** , was the database management system I chose. I used Microsoft SQL Server Management Studio 21, but found it easier to management in PostgresSQL since it is a smaller dataset.

3. **Git and Github** was the final tool used. This assisted in version control and sharing the SQL scripts I used in this project. Please feel free to poke around!

# The Analysis

Each query in this project evaluated the aspects of the data analyst job market. Here is the method used for the questions asked above:

### 1. Top Paying Data Analyst Jobs
To determine the top paying jobs. First, I filtered only titles that contained Data Analyst in the job_title_short column. Next, I am interested in remote work, so I filtered for Anywhere (which is remote in this dataset) in the job_location column. Finally, to determine the highest paying jobs, I sorted the dataset in designing order by the salary_year_avg column.
```SQL
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_location = 'Anywhere' 
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
```
Here is the breakdown from the data analyst jobs from 2023:

We can see from the dataset, that a Data analyst position offered by Mantys offers a salary of $650,000.00. A significant difference between the Director of Analytics position offered by Meta, with a salary of $336,500.00. Each position in this query is remote noted by "Anywhere" and full time. With a wide range od salary from $184,000.00 to $650,000.00.

### 2. Top Paying jobs by skills:

To determine the top paying jobs by skill, I created a CTE named top_paying_jobs containing a left join with job_posting_facts to company_dim on company_id from both tables. I then filtered for data analyst positions that are remote (denoted by Anywhere) and removed any jobs that had a null value. Lastly, I sorted the data set by salary_year_avg in descending order and limited to the top 10.

Once the CTE was complete, I selected all columns from the top_paying_jobs table and then performed two inner joins:
```SQL
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
```
and ordered by salary_year_avg in descending order.

```SQL
WITH top_paying_jobs AS (

    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' 
        AND job_location = 'Anywhere' 
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```

### 3. Top Demanded Skills

To determine the top demanded skills, I selected the column skills from the job_postings_fact and the column job_id from the skills_job_dim and counted the amount of times a skill was mentioned. Then I inner joined the tables skills_job_dim and skills_dim on job_postings_fact on job_id and skill_id respectively. I then filtered for data analyst jobs where work_from_home was True. Grouped it by skills and then ordered by demand_count in descending order and limited it to five.

From the results, SQL, Excel, Python, Tableau, and Power BI were the top five in demand skills for a data analyst. There is a significant difference between SQL and Excel. For someone entering the data analytics field, this would be a great foundation to start your career.

```SQL
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```

### 4. Top Paying Skills

Next I determined what skills were top paying amongst them. To do this, I selected skills and salary_year_avg columns from the job_postings_facts. For the salary_year_avg, I calculated the average and rounded to zero, then gave the alias as avg_salary. I then Inner joined the following:
```SQL
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
```
I filtered for data analyst roles and where the salary was null and work from home was true. Grouped this by skills and ordered by the average salary in descending order.

```SQL
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0)  AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25
```
From the result, the top five skills are pyspark, bitbucket, couchbase, watson, and datarobot. To further dive into this, we can determine the range of salary for each skill in this particular dataset.

### 5. What Are The Optimal Skills

Lastly, what were t he optimal skills for data analysts. This by far was the toughest query to build and provided a great challenge. Once the troubleshooting and the final query produce results, it was a great feeling and deserved a pat on the back.
```SQL
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
LIMIT 25WITH skills_demand AS (
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
```
From the results, SQL was the top skill that was demanded amongst all of the job postings in the dataset. Comparing this to the second query, top paying job skills SQL was also the top result for that as well. The top five were the same minus Power BI, which was jumped by R. Of the top 25 skills, from this, snowflake has the highest average salary of all the optimal skills.

# What I learned
- **Using SQL:** Is rewarding and challenging. From simple queries to complex ones, you learn through trial and error. Its okay to not have the results on the first try, that is the rewarding part once you figure it out.

- **Foot in the door:** My first and simple project helps me enter the world of data analytics, which I found my passion for while away from my current role. What seemed as failure was actually a opportunity to discover what I'm truly passionate about.

- **Excitement for the future:** I'll always remember building out this project and learning from it. In the way future, I want to come back to this project and see how far I've come. Future me, don't forget where home is!

# Conclusions

This project enhanced my SQL skills and showed the landscape fo the data analyst market. This provided me great insight on the skills to focus on in order to enter the analytics field. This also shows that no one analyst knows every tool, but should be familiar with the skills that aligns with their career goals. I hope this simple project helps out the next future data analyst!
