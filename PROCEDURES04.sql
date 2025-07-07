select * from emps25;


select employee_id,first_name,job_id from employees  where employee_id in (select manager_id from employees);

select * from emps;


create table empmgr(
    manager_id number,
    firstname varchar2(50),
    jobid varchar2(20),
    departmentid number
);

select * from employees;
select * from departments;
select * from locations;
select * from employees;
select * from empmgr;


SELECT location_id, COUNT(*) AS no_of_departments
FROM departments
GROUP BY location_id;





select department_id,department_name,location_id from departments 
where location_id in (select location_id from locations where country_id ='US');


select location_id from locations where country_id ='US';


create table Department_US (
    department_id number,
    department_name varchar2(20),
    location_id number
);

select * from Department_US;

create table empdelete1 as select * from employees;

select * from empdelete1;

select * from employees where job_id like 'IT%';

create table mgremp (
empid number,
first_name varchar2(30),
job_id varchar2(30),
department_id number
);


select * from mgremp;
truncate table mgremp;


select employee_id,first_name,job_id,department_id from employees where employee_id in (select manager_id from employees);

select employee_id,first_name,last_name,EMPNAME(employee_id) as Full_Name from employees;


SELECT d.department_name,l.city,l.country_id from 
departments d join locations l on d.location_id = l.location_id;


select  * FROM locations;

select department_id, DEPTLOC(department_id) from departments;




select employee_id,first_name,last_name,EMPEXP01(employee_id) as Experaince from employees;



select employee_id,first_name,last_name,salcal(salary,commission_pct) as total_salary from employees;



declare 
type names_list is table of varchar2(50);
names names_list;
begin
names := names_list('uday','kiran','kiru');

for i in 1 .. names.count loop
    DBMS_OUTPUT.PUT_LINE('Name at index ' || i || ': ' || names(i));
end loop;
end;

declare 
    type emp_sal is table  of number index by pls_integer;
    salaries emp_sal;
    emp_id number;
begin 
    salaries(100) := 24000;
    salaries(101) := 24500;
    salaries(102) := 25000;
    salaries(103) := 25500;
    emp_id := salaries.first;
    while emp_id is not null loop
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || emp_id || ', Salary: ' || salaries(emp_id));
        emp_id := salaries.next(emp_id);
    end loop;
end;



DECLARE
  TYPE employee_record_t IS RECORD (
    employee_id employees.employee_id%TYPE,
    first_name  employees.first_name%TYPE,
    last_name   employees.last_name%TYPE
  );
  TYPE employee_table_t IS TABLE OF employee_record_t;
  v_employees employee_table_t;
BEGIN
  -- Fetch all employees into the collection
  SELECT employee_id, first_name, last_name
  BULK COLLECT INTO v_employees
  FROM employees
  WHERE department_id = 80; -- Example department

  -- Process the fetched employees
  DBMS_OUTPUT.PUT_LINE('Number of employees in department 80: ' || v_employees.COUNT);
  FOR i IN 1..v_employees.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(v_employees(i).first_name || ' ' || v_employees(i).last_name || ' (ID: ' || v_employees(i).employee_id || ')');
  END LOOP;
END;




