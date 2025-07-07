--CREATE TABLE AUDIT_TABLE 
-- ( TABLE_NAME VARCHAR2(100), 
--USERID VARCHAR2(100), 
--OPERATION_DATE DATE, 
--OPERATION VARCHAR2(100)
-- );
--CREATE TABLE AUDIT_LOG 
-- ( USERID VARCHAR2(100), 
--OPERATION_DATE DATE, 
--B_CUSTOMERID NUMBER, 
--A_CUSTOMERID NUMBER, 
--B_FIRSTNAME VARCHAR2(100), 
--A_FIRSTNAME VARCHAR2(100)
-- );
INSERT INTO customer (customerID, firstname, lastname, email, phonenumber)
VALUES (5, 'Uday', 'Kiru', 'uday.kiran@example.com', '123-456-7890');


select * from audit_log;
select * from audit_table;
select * from customer;
create trigger customer_before_update
before update on customer

declare 
v_username varchar(20):= 'Customers';

begin

insert into audit_table(table_name,userid,operation_date,operation)
values
('customer',v_username,sysdate,'before update operation');
end;


update customer set lastname='Parker' where customerID = 3;
------------------------------------------------------
create trigger customer_after_action
after insert or  update  or delete
on customer
declare 
v_username varchar(20):= 'Customers';

begin
if inserting then 
    insert into audit_table(table_name,userid,operation_date,operation)
    values
    ('customer',v_username,sysdate,'Insert operation');
elsif updating then 
    insert into audit_table(table_name,userid,operation_date,operation)
    values
    ('customer',v_username,sysdate,'update operation');
elsif deleting then 
    insert into audit_table(table_name,userid,operation_date,operation)
    values
    ('customer',v_username,sysdate,'Delete operation');
end if;
end;

update customer set lastname='Parker' where customerID = 3;
---------------------------------------------------------------------
update customer set firstname = 'John' where firstname='John a';


create trigger customer_after_update_values
after update
on customer
 for each row

declare
  v_username varchar2(20);  
begin
    
    select user into v_username from dual;
    
insert into audit_log (userid,operation_date,B_CUSTOMERID,A_CUSTOMERID,B_FIRSTNAME,A_FIRSTNAME)
VALUES (v_username,sysdate,:OLD.customer_id,:NEW.customer_id,:OLD.first_name,:NEW.first_name);

end;



select * from emps;







