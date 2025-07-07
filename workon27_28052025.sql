WITH employee_cte AS (
    SELECT
        employee_id,
        first_name,
        department_id,
        hire_date
    FROM hr.employees
)
SELECT
    employee_id,
    first_name,
    department_id,
    hire_date,
    ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY hire_date) AS hire_order
FROM employee_cte;



select salary,listagg(first_name,' ') within group (order by salary)
from hr.employees
group by salary;

SELECT  MAX(salary) AS max_salary, department_id
FROM hr.EMPLOYEES
GROUP BY department_id
order by department_id;

SELECT employee_id,department_id,MAX(salary) AS second_highest_salary
FROM hr.EMPLOYEES
WHERE salary < (SELECT MAX(salary) FROM hr.EMPLOYEES)
group by department_id
order by department_id;