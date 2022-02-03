

-- create a temp table of employees within retirement age 
SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date
INTO retirement_titles
FROM employees e
JOIN titles as t ON e.emp_no = t.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY e.emp_no

-- show most recent title for active employees of retirement age
SELECT DISTINCT ON (rt.emp_no) rt.emp_no, rt.first_name, rt.last_name, rt.title
FROM retirement_titles rt
INTO unique_titles
LEFT JOIN dept_emp as de
ON rt.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01')
ORDER BY rt.emp_no, rt.to_date desc

-- get a count of soon to retire employees by title
SELECT COUNT(title) as "employee_count", title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY "employee_count" desc
