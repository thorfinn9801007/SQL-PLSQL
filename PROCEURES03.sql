create or replace procedure get_employees
(
    emp_id in number
)
as
    TYPE EmpRecord IS RECORD (
        FIRST_NAME varchar2(20),
        LAST_NAME varchar2(20)
    );
    emp_rec EmpRecord; -- Declare emp_rec as the user-defined record type
    ex_emp_id EXCEPTION;
begin
    if emp_id > 206 then
        raise ex_emp_id;
    end if;
    select FIRST_NAME, LAST_NAME
    into emp_rec.FIRST_NAME, emp_rec.LAST_NAME -- Populate the fields of the record
    from employees
    where employee_id = emp_id;

    dbms_output.put_line('Employee Name: ' || emp_rec.FIRST_NAME);
    dbms_output.put_line('Last Name: ' || emp_rec.LAST_NAME);

exception
    when ex_emp_id then
        dbms_output.put_line('Error: Employee ID must be less than or equal to 206.');
    when no_data_found then
        dbms_output.put_line('Error: Employee with ID ' || emp_id || ' not found.');
    when others then
        dbms_output.put_line('An unexpected error occurred.');
    when INVALID_NUMBER then
        dbms_output.put_line('Enter the correct number');
end;
/

-- Example of how to execute the procedure:
set serveroutput on;
begin
    get_employees(100); -- Example with a valid employee ID
    get_employees(207); -- Example with an employee ID that will raise the custom exception
    get_employees(999); -- Example with an employee ID that might not exist
end;
/