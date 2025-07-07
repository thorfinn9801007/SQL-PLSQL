-- Display all employees (for context)
select * from employees;

-- Corrected procedure to retrieve details for a specific employee
create or replace procedure get_emp_details_by_id
(
    p_employee_id IN number, -- IN parameter to accept the employee ID
    p_emp_name    OUT varchar2,
    p_emp_date    OUT DATE,
    p_emp_salary  OUT number
)
as
    v_emp_id NUMBER; -- Local variable to store employee_id
begin
    select employee_id, first_name, hire_date, salary
    into v_emp_id, p_emp_name, p_emp_date, p_emp_salary
    from employees
    where employee_id = p_employee_id;

    dbms_output.put_line('Employee ID: ' || v_emp_id);
    dbms_output.put_line('Employee Name: ' || p_emp_name);
    dbms_output.put_line('Hire Date: ' || TO_CHAR(p_emp_date, 'YYYY-MM-DD'));
    dbms_output.put_line('Salary: ' || p_emp_salary);

exception
    when no_data_found then
        dbms_output.put_line('Employee with ID ' || p_employee_id || ' not found.');
        p_emp_name := null;
        p_emp_date := null;
        p_emp_salary := null;
    when too_many_rows then
        dbms_output.put_line('Error: Multiple employees found with ID ' || p_employee_id || ' (This should not happen with a primary key).');
        p_emp_name := null;
        p_emp_date := null;
        p_emp_salary := null;
end;
/

set serveroutput on;
DECLARE
    v_emp_id_to_find NUMBER := 105; -- Specify the employee ID you want to retrieve
    v_employee_name VARCHAR2(100);
    v_hire_date DATE;
    v_employee_salary NUMBER;
BEGIN
    get_emp_details_by_id(v_emp_id_to_find, v_employee_name, v_hire_date, v_employee_salary);

    IF v_employee_name IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('--- Employee Details ---');
        DBMS_OUTPUT.PUT_LINE('Name: ' || v_employee_name);
        DBMS_OUTPUT.PUT_LINE('Hire Date: ' || TO_CHAR(v_hire_date, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Salary: ' || v_employee_salary);
    END IF;
END;
/

create or replace function poweroftwo(
    num1 IN number,
    num2 in number
)
return number
as
begin
    return power(num1, num2);
end;
/


    set serveroutput on; -- Enable output to see dbms_output
declare
    num1 number := 10;
    num2 number := 3;
begin
    dbms_output.put_line(poweroftwo(num1, num2));
end;
/  




















