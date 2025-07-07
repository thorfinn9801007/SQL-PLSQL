SELECT * FROM HR.DEPARTMENTS;
SELECT * FROM HR.EMPLOYEES;
SELECT * FROM HR.JOBS;
SELECT * FROM HR.JOB_HISTORY;
SELECT * FROM HR.LOCATIONS;
SELECT * FROM HR.COUNTRIES;
SELECT * FROM HR.REGIONS;

--Write a SQL query to display employee_id,first_name&last_name as emp_name,job_id and department_id,department_name as"Dept"(example:50-Shipping).
--Sort the based department_id and salary as decendingorder.

SELECT e.employee_id,e.first_name||' '||e.last_name as emp_name,
e.job_id,e.department_id,d.department_name from hr.EMPLOYEES e
join hr.DEPARTMENTS d on 
e.DEPARTMENT_ID = d.DEPARTMENT_ID
order by department_id desc , salary desc;

--write a SQL query to find those employees whose first name contains the letter ‘z’. Return first name, last    name, department, city, and state province.
--Sort the employees based on firstname
WITH cte AS (
    SELECT 
        d.department_id,
        d.department_name,
        l.city,
        l.state_province
    FROM 
        hr.departments d 
    INNER JOIN 
        hr.locations l ON d.location_id = l.location_id
    ORDER BY 
        d.department_id ASC
)
SELECT e.first_name,e.last_name,c.department_name,c.city,c.state_province
from hr.EMPLOYEES e inner join cte c on e.DEPARTMENT_ID = c.department_id
where e.FIRST_NAME LIKE '%z%'
order by e.FIRST_NAME asc;


-- write a SQL query to find the employees and their managers.These managers do not work under any manager
-- Return the first name of the employee and manager

--write a SQL query to find all employees who joined on 1st January 2005 to 31th 2006  
--Display the employee_id,first_name, job title, department name and joining date of the job.

SELECT 
    e.employee_id,
    e.first_name,
    e.job_id,
    e.hire_date,
    d.department_name
FROM 
    HR.employees e 
INNER JOIN 
    HR.departments d ON e.department_id = d.department_id
WHERE 
    e.hire_date BETWEEN DATE '2015-01-01' AND DATE '2017-12-31';


-- write a SQL query to find all departments, including those without employees.
-- Return first name, last name, department ID, department name
select e.first_name,e.last_name,d.department_id,d.department_name 
from hr.DEPARTMENTS d left join hr.EMPLOYEES e on 
e.DEPARTMENT_ID = d.DEPARTMENT_ID;

--Write a SQL query to display the department name, city, and state province for each department. 
select d.department_name,c.city,c.state_province
from hr.departments d inner join hr.locations c on 
d.location_id = c.location_id;

--write a SQL query to find the employees and their managers. 
--Return the first name of the employee and manager's first_name and sort the record based on employee_id.
select e.employee_id,e.first_name,d.manager_id from
hr.EMPLOYEES e inner join hr.DEPARTMENTS d on
e.MANAGER_ID = d.MANAGER_ID
order by e.EMPLOYEE_ID asc;


SELECT
    D.DEPARTMENT_NAME,
    D.MANAGER_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    L.CITY
FROM
    HR.DEPARTMENTS D
    JOIN HR.LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
    JOIN HR.EMPLOYEES E ON D.MANAGER_ID = E.MANAGER_ID;

 







