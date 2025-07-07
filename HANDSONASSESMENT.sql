--First query
select employee_id,first_name,job_id,salary+(salary*commission_pct) as gross_salary 
from EMPLOYEES
where salary+(salary*NULLIF(commission_pct,0)) > 12000
order by employee_id asc;

--second query
select department_id , count(*) as employees_per_department 
from EMPLOYEES
group by DEPARTMENT_ID
having count(*) >= 10;

--THIRD QUERY 

SELECT
    D.DEPARTMENT_NAME,
    D.MANAGER_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    L.CITY
FROM
    DEPARTMENTS D
    JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
    JOIN EMPLOYEES E ON D.MANAGER_ID = E.MANAGER_ID;

--fourth query
select employee_id,first_name,job_id,salary,
        CASE 
            when salary > 20000 then salary - salary*0.1
            when salary between 15000 and 20000 then salary - salary*0.8
            when salary between 10000 and 14999 then salary - salary*0.6
            when salary between 8000 and 9999 then salary - salary*0.4
            when salary between 5000 and 7999 then salary - salary*0.2
            else salary
            end as net_salary 
from employees;

--FIFTH QUERY

SELECT e.employee_id,e.first_name||' '||e.last_name as emp_name,
e.job_id,e.department_id,d.department_name from EMPLOYEES e
join DEPARTMENTS d on 
e.DEPARTMENT_ID = d.DEPARTMENT_ID
order by department_id desc , salary desc;

--6TH QUERY
WITH cte AS (
    SELECT 
        d.department_id,
        d.department_name,
        l.city,
        l.state_province
    FROM 
        departments d 
    INNER JOIN 
        locations l ON d.location_id = l.location_id
    ORDER BY 
        d.department_id ASC
)
SELECT e.first_name,e.last_name,c.department_name,c.city,c.state_province
from EMPLOYEES e inner join cte c on e.DEPARTMENT_ID = c.department_id
where e.FIRST_NAME LIKE '%z%'
order by e.FIRST_NAME asc;

--7TH QUERY
SELECT E1.EMPLOYEE_ID,
    E1.FIRST_NAME || ' ' || E1.LAST_NAME AS FULL_NAME,
    E2.MANAGER_ID
    FROM EMPLOYEES E1
    JOIN EMPLOYEES E2 
    ON E1.EMPLOYEE_ID = E2.MANAGER_ID;
-------DOUBT------------
--     SELECT
--     e.FIRST_NAME AS EmployeeName,
--     m.FIRST_NAME AS ManagerName
-- FROM
--     EMPLOYEES e
-- LEFT JOIN
--     EMPLOYEES m ON e.MANAGER_ID = m.EMPLOYEE_ID
-- WHERE m.MANAGER_ID IS NULL;

--8TH QUERY
SELECT 
    e.employee_id,
    e.first_name,
    e.job_id,
    e.hire_date,
    d.department_name
FROM 
    employees e 
INNER JOIN 
    departments d ON e.department_id = d.department_id
WHERE 
    e.hire_date BETWEEN DATE '2005-01-01' AND DATE '2007-12-31';


--ninth query
SELECT
    employee_id,
    first_name || ' ' || last_name AS full_name,
    job_id,
    salary,
    (SELECT MAX(salary) FROM employees) - salary AS diff_salary
FROM
    employees
ORDER BY
    employee_id;

--tenth query
select job_id , avg(salary) from EMPLOYEES
group by JOB_ID;

--11th query 
select e.first_name,e.last_name,d.department_id,d.department_name 
from DEPARTMENTS d left join EMPLOYEES e on 
e.DEPARTMENT_ID = d.DEPARTMENT_ID;

--12th query
SELECT e1.employee_id, e1.first_name AS employee_name, e2.first_name AS manager_name
FROM employees e1
JOIN employees e2 ON e1.manager_id = e2.employee_id
order by e1.employee_id;

--13th query
select d.department_name,c.city,c.state_province
from departments d inner join locations c on 
d.location_id = c.location_id;

--14th query


--15th query
select employee_id,first_name,job_id,hire_date,department_id 
from EMPLOYEES
where salary+(salary*commission_pct) >= 12000
order by employee_id;



--16th query
select employee_id,first_name,job_id,hire_date,department_id,salary+(salary*commission_pct) as Net_sal
from EMPLOYEES
where salary+(salary*commission_pct) >= 15000
order by Net_sal asc;

--17th query
select employee_id,first_name,job_id,salary,
        CASE 
            when salary > 20000 then salary*0.1
            when salary between 15000 and 20000 then salary*0.8
            when salary between 10000 and 14999 then salary*0.6
            when salary between 8000 and 9999 then salary*0.4
            when salary between 5000 and 7999 then salary*0.2
            else salary*0
            end as Tax_Amt 
from employees;

--18th query
select employee_id ,first_name,job_id,
(salary + (salary * COALESCE(commission_pct,1))) as gross_salary
from employees;

--19th query
--19) write a SQL query to find the department name, full name (first and last name) of the manager and their city. where manager is managing more than 10 employees
select d.department_id,e.first_name||' '||e.last_name as full_name,l.city
from 
    departments d 
    join employees e on d.manager_id = e.employee_id
    join locations l on l.location_id = d.location_id
    where e.employee_id in(
    select manager_id
    from employees
    where manager_id is not null
    group by manager_id
    having count(*) >= 10
    );
    
    
--20th query
select e.employee_id,e.first_name,e.job_id,d.department_name 
from employees e join departments d on e.department_id = d.department_id 
where sysdate - e.hire_date >= 15
order by e.employee_id;

--21th query
SELECT DISTINCT
    department_id,
    round(AVG(salary),0) as avg_salary,
    COUNT(*) AS no_of_employees
FROM
    employees
WHERE
    COMMISSION_PCT IS NOT NULL
GROUP BY
    department_id
ORDER BY
    no_of_employees;
    
--22nd query
select d.department_name,l.city,l.country_id from 
departments d join locations l on d.location_id = l.location_id;

--23rd query
select d.department_name, e1.first_name||' '||e1.last_name as manager_name 
from 
    departments d
  JOIN employees e1 ON d.department_id = e1.department_id
    JOIN employees e2 ON d.manager_id = e2.employee_id;
--24th query
SELECT 
    job_id, 
    SUM(salary) AS Total_salary
FROM 
    employees
GROUP BY 
    job_id
HAVING 
    SUM(salary) > 50000;

--25th query
SELECT job_id, SUM(salary) AS Total_salary
FROM employees
GROUP BY job_id
ORDER BY Total_salary DESC;

--26th query
select e.employee_id, e.first_name,e.last_name,d.department_name,l.city
from 
    employees e
    join departments d on e.department_id = d.department_id
    join locations l on d.location_id = l.location_id
    order by e.employee_id asc;
        
--27th query


--28th query
SELECT
    e.job_id,
    d.department_name,
    AVG(e.salary) AS average_salary
FROM
    employees e
JOIN
    departments d ON e.department_id = d.department_id
GROUP BY
    d.department_id, e.job_id ,d.department_name
ORDER BY
    d.department_id;
    
--29th query
select EMPLOYEE_ID,job_id,FIRST_NAME,HIRE_DATE,DEPARTMENT_ID from 
employees
where salary > 12000
order by employee_id;

--30th query
select e.employee_id,e.first_name,e.last_name,d.department_id,d.department_name
from 
    employees e 
    join departments d on e.department_id = d.department_id
    where d.department_id in (90,50)
    order by d.department_id;