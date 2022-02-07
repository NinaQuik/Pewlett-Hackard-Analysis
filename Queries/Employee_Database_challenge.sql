

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

-- get a count of soon to retire employees by title
SELECT COUNT(title) as "employee_count", title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY "employee_count" desc;

--- Retrieve current information for employees eligible for mentorship (born in 1965)
SELECT DISTINCT ON (e.emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date, de.from_date, de.to_date, t.title
INTO mentorship_eligibility
FROM employees e
LEFT JOIN dept_emp as de 
ON (e.emp_no = de.emp_no)
JOIN titles as t 
ON (e.emp_no = t.emp_no)
WHERE e.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
AND de.to_date = ('9999-01-01')
ORDER BY e.emp_no, t.title;

--See number of soon to retire employees by department
SELECT  count(e.emp_no) as "employees", d.dept_name
INTO retirees_by_dept
FROM employees as e
LEFT JOIN dept_emp as de
ON e.emp_no = de.emp_no
JOIN departments as d
ON de.dept_no = d.dept_no
WHERE de.to_date = ('9999-01-01')
AND e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
GROUP BY d.dept_name;

--See number of potential mentors by department
SELECT  count(e.emp_no) as "employees", d.dept_name
INTO mentors_by_dept
FROM employees as e
LEFT JOIN dept_emp as de
ON e.emp_no = de.emp_no
JOIN departments as d
ON de.dept_no = d.dept_no
WHERE de.to_date = ('9999-01-01')
AND e.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
GROUP BY d.dept_name;

--Number of total employees by department
SELECT  count(e.emp_no) as "employees", d.dept_name
INTO employees_by_dept
FROM employees as e
LEFT JOIN dept_emp as de
ON e.emp_no = de.emp_no
JOIN departments as d
ON de.dept_no = d.dept_no
WHERE de.to_date = ('9999-01-01')
GROUP BY d.dept_name;

--Breakdown of future retirees and potential mentors per department
SELECT e.dept_name as "Department", 
	e.employees as "Total Employees",
	r.employees as "Retiring Employees", 
	m.employees as "Mentors", 
	ROUND((r.employees::decimal / e.employees)* 100, 2) as "Percentage retiring",
	CEIL(r.employees / m.employees) as "Mentors per open position"
FROM employees_by_dept as e
JOIN mentors_by_dept as m 
ON e.dept_name = m.dept_name
JOIN retirees_by_dept as r
ON e.dept_name = r.dept_name;
