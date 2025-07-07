select * from employees where department_id in (30,50,70,90);



select city from locations where location_id in (select location_id from departments);

select d.department_id,l.city from locations l join departments d on l.location_id = d.location_id;

select * from departments;

select employee_id,first_name,job_id,department_id from employees where employee_id in (select manager_id from employees);
---------1----------


select employee_id,first_name,salary , salary+salary*0.2 as hike_salary from emps26
where salary+salary*0.2 > 10000;


--------2----------------
select e.employee_id,e.first_name,d.department_name,d.department_id,e.job_id,l.city from 
employees e 
    join departments d on e.department_id = d.department_id
    join locations l on l.location_id= d.location_id
    where e.department_id in (30,50,50,90)
    order by e.first_name;
    
------------3-----------------
select * from employees;
select * from departments;

SELECT
    d.department_name,
    COUNT(e.employee_id) AS NO_Emp
FROM
    departments d
LEFT JOIN
    employees e ON d.department_id = e.department_id
GROUP BY
    d.department_name
ORDER BY
    NO_Emp DESC;
    
-------------4------------
select * from employees;

with cte as (
select job_id,count(employee_id) as no_emp 
from employees group by job_id
order by no_emp desc
)

select job_id,no_emp from cte where no_emp = (select max(no_emp) from cte);

				(OR)

select job_id, count(employee_id) as "No_Emps"
from employees
group by job_id 
having count(employee_id) >= all(select count(employee_id) from employees group by job_id)
order by job_id;

---------5-----
select location_id,count(department_id) as no_dept from departments where location_id = 1700 group by location_id  order by no_dept desc;

select employee_id, first_name, job_id ,salary from employees where department_id in (select department_id from departments where department_name = 'IT');
   
   
----------------procedure 1--------------------

create or replace procedure dept_loc(loc_id in number ) as
dept_count number;
begin
    select count(department_id) into dept_count from departments 
    where location_id = loc_id;
    dbms_output.put_line('Number of Department in location id [ '|| loc_id ||']' ||'is ['||dept_count||']');
end;
/


set serveroutput on;
   
execute dept_loc(1700);

-----------------------procedure 2-------------------------
create or replace procedure mgrnemp as
cursor c is select employee_id,first_name,job_id,department_id from employees where employee_id in (select manager_id from employees);
r_rec c%rowtype;
row_count number:=0;
begin
open c;
loop
    fetch c into r_rec;
    exit when c%notfound;
        insert into manageremps values (r_rec.employee_id,r_rec.first_name,r_rec.job_id,r_rec.department_id);
        row_count := row_count+1;
end loop;
    close c;
    dbms_output.put_line('Number of record is copied is'||row_count);
end;
/


execute mgrnemp;

select * from employees;

-------------function 1---------------
create or replace function salcals (sal number,comm number) return number as 
v_sal number:=sal;
v_comm number:=comm;
v_taxrate number;
v_totsal number;

begin 
    
    v_totsal := v_sal + nvl(v_sal*v_comm,0);
    if v_totsal > 150000 then
        v_taxrate :=0.6;
    elsif v_totsal < 150000 then
        v_taxrate :=0.25;
    end if;
    
    v_totsal := v_totsal - v_totsal*v_taxrate;
    
return v_totsal;
end;


select employee_id,first_name,salcals(salary,commission_pct) as TOT_SAL from emps26;
   
   
   
    
    
select * from emps26;
select * from empoldsal;

create or replace trigger oldsal 
before update on emps26 for each row 
declare
begin
    insert into empoldsal values(:old.employee_id,:old.first_name,:old.salary);
end;


update emps26 set salary = salary+1 where employee_id = 204;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


    
select * from emps26;


select first_name,job_id,hire_date,Extract(year from hire_date) from emps26 where 
Extract(year from hire_date) in (2004,2005,2006);

SELECT  first_name, UNIQUE(salary)
FROM (SELECT first_name, salary FROM emps26 ORDER BY salary DESC)
WHERE ROWNUM <= 5;


select last_name,count(*) as no_emp,avg(salary) from employees 
group by last_name
having count(*) >1;


select department_id,round(avg(salary),0) from emps26
group by department_id 
having round(avg(salary),0) > 8000
order by department_id;


select * from departments;

select * from jobs;

 
    