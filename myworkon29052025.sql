select * from hr.EMPLOYEES;

select e.employee_id,e.first_name,e.last_name,e.job_id,
        m.first_name as mgr_first_name,
        m.last_name as mgr_last_name,
        m.job_id as mgr_jobid
    from hr.employees e 
    left join 
    hr.employees m on
    e.employee_id = m.manager_id
    order by e.EMPLOYEE_ID;



select employee_id, first_name, last_name, LEVEL
from hr.employees
where LEVEL >= 2 
start with manager_id is NULL
connect by prior EMPLOYEE_ID = MANAGER_ID;


select to_char(hire_date,'YYYY') as YRS,count(EMPLOYEE_ID) as no_of_emps 
from hr.EMPLOYEES 
group by to_char(hire_date,'YYYY')
order by YRS;

select department_id,count(employee_id) as no_of_emp
from hr.EMPLOYEES
where COMMISSION_PCT is NULL 
group by DEPARTMENT_ID
order by DEPARTMENT_ID;

select manager_id,count(employee_id) as no_of_emps
from hr.EMPLOYEES
group by MANAGER_ID
HAVING count(EMPLOYEE_ID) > 5
order by MANAGER_ID;

select department_id,count(employee_id) as no_of_emps
from hr.EMPLOYEES
where to_char(hire_date,'YYYY') > 2004
group by DEPARTMENT_ID
having no_of_emps > 3
order by department_id;


