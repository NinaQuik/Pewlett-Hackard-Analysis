# Pewlett-Hackard-Analysis
Module 7 - Employee database - data modeling, engineering and data analysis.

A fictional Human Resources Department at Pewlett Hackard is preparing for several retirements.  Using SQL, this analysis determines the number of retiring employees per title. It also identifies employees that are eligible to participate in a mentorship program so that management and HR can prepare for the upcoming wave of vacancies in the "silver tsunami". 

Additionally, more complex SQL analysis is used to perform the percentage of retirees per department and number of potential mentors to potential new hires.

## Overview

### Tools
- PostgreSQL version 12.9
- pgAdmin 4 version 6.1
- Quick DBD: https://www.quickdatabasediagrams.com/

### Data Set
Six .csv files imported via pgAdmin to create a PH-Employee-DB database in Postgres.

ERD Diagram:

![ERD](/Data/ERD.png)

### Definitions

Retirees: active employees (employed to_date = ‘9999-01-01’),  born between 1952 and 1955 (birth_date between '1952-01-01' AND '1955-12-31’)

Mentors: active employees (employed to_date = ‘9999-01-01’),  born in the year 1965 (birth_date BETWEEN '1965-01-01' AND '1965-12-31’)

## Results
- Using temp tables, and DISTINCT ON SQL queries, it was found that there are 72,458 employees nearing retirment (See "Retirees" definition above).
```
-- create a temp table of employees within retirement age 
SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date
INTO retirement_titles
FROM employees e
JOIN titles as t ON e.emp_no = t.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY e.emp_no;

-- show most recent title for active employees of retirement age
SELECT DISTINCT ON (rt.emp_no) rt.emp_no, rt.first_name, rt.last_name, rt.title
FROM retirement_titles rt
INTO unique_titles
LEFT JOIN dept_emp as de
ON rt.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01')
ORDER BY rt.emp_no, rt.to_date desc;
```
- A breakdown of retiree to current title is summarized below:

   ![retiringtitles](/Data/retiring_titles.png)
   
- A query is run to determine the number of mentors available (see mentor definition above) and the results are exported to csv: [mentorship](/Data/mentorship_eligibility.csv)
- There are 1549 potential mentors.
- A breakdown of mentors by title:
 
 ![mentortitles](/Data/mentor_titles.png)
