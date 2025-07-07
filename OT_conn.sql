select * from contacts;
select * from countries;
select * from customers;
select * from employees;
select * from inventories;
select * from locations;
select * from order_items;
select * from orders;
select * from product_categories;
select * from products;
select * from regions;
select * from warehouses;


select * from tab;


--Diplay the order with  the order number, order date, customer number, and the day of the week 
--for all orders placed on a Saturday or Sunday during the year 2017.

select order_id,order_date,customer_id,to_char(order_date,'Day') as day_of_the_week 
from orders 
where to_char(order_date,'YYYY')='2017' and 
TO_CHAR(order_date, 'Dy') in ('Sun','Sat');




--Customer Order Tracking system must display order details including Order ID, Order Date, Shipped Date, 
--and Feedback Date for each customer order. The Feedback Date is determined through a two-step calculation:
--Shipped Date Calculation:
--	Each order is shipped 10 days after the Order Date.
--Feedback Date Calculation:
--	Once an order’s status is marked as "shipped", the Feedback Date is set to one month after the Shipped Date.
--
--The output should present all orders along with their Order ID, Order Date, Shipped Date, and Feedback Date only for the order's status is shipped.
SELECT ADD_MONTHS(SYSDATE, 1) FROM DUAL;

select order_date + 10 from orders;

select order_id,order_date,(order_date + 10) as shipped_date , add_months((order_date + 10),1) as feedback_date 
from orders where status = 'Shipped' order by order_id;


--Display the Order ID and corresponding Customer ID for all orders placed in the year 2017 that contain more than 5 individual items.
select * from orders;
select * from order_items order by order_id;


select order_id , customer_id from orders 
where to_char(order_date,'YYYY')='2017'
and order_id in 
(select order_id from order_items 
group by order_id 
having count(order_id) > 5)
order by order_id;


SELECT
    o.order_id,
    o.customer_id
FROM
    orders o
JOIN
    order_items oi ON o.order_id = oi.order_id
WHERE TO_CHAR(o.order_date, 'YYYY') = '2017'
GROUP BY o.order_id, o.customer_id
HAVING COUNT(oi.item_id) > 5
ORDER BY o.order_id;


select order_id,count(item_id) from order_items 
group by order_id 
having count(item_id) > 5 order by order_id;


-- Create a PL/SQL procedure that updates the list_price of products based on the following conditions:
-- If the difference between a product's standard_cost and its list_price is greater than $500, then apply a 10% discount to the list_price
--for products belonging to category_id equal to 1, if difference is not greater than $500 than apply a 4% discount to their list_price. 
--find the product catergory name and display number record update as 
--Output 1 : 
--	 "Number of Products update in category of CPU is 10
--
--Output 2 : 
--	"No update made for the category of CPU" (NOTE : OT SCHEMA)

select * from pro1;
select * from product_categories;
select * from products;

create table pro2  as (select * from products);



create or replace procedure proc1 as 
cursor c is select product_id,product_name,standard_cost,list_price,category_id from pro2 where category_id=1;
r_rec c%rowtype;
v_discount number;
v_count number:=0;
v_category product_categories.category_name%type;
begin
    open c;
    loop
    fetch c into r_rec;
    exit when c%notfound;
    if (r_rec.list_price - r_rec.standard_cost ) > 500 then
        v_discount := 0.10;
    elsif (r_rec.list_price - r_rec.standard_cost) < 500 then
        v_discount := 0.04;
    end if;
        update pro2 set list_price = list_price - list_price*v_discount where product_id = r_rec.product_id;
        v_count:=v_count+1;
     end loop;
     close c;
     
     select category_name into v_category 
     from product_categories 
     where category_id = 1;
     
     dbms_output.put_line('Number of Products update in category of '|| v_category||'is '||v_count);
     
     EXCEPTION 
        when no_data_found then 
            dbms_output.put_line('No update made for the category of CPU');
end;
/


set serveroutput on;

execute proc1;

select * from pro2;




--Create a PL/SQL function named calculate_total_order_amount that accepts a single input parameter: order_id (the unique identifier of an order).
--The function should perform the following calculation:
--	i) For the given order_id, retrieve all the individual items associated with that order.
--	ii) For each item, multiply its quantity by its unit price.
--	iii) Calculate the sum of these individual item amounts to determine the total amount for the entire order.
--	iv) The function should then return this calculated total order amount as its output. (NOTE : OT SCHEMA)


select order_id,count(item_id) as total_amount from order_items
 where order_id = 1
 group by order_id;
 
select sum(quantity*unit_price) as tot from order_items
where order_id = 2
group by order_id;

create or replace function calculate_total_order_amount (or_id in number) return number as 
v_total number;
begin
    select sum(quantity*unit_price) into v_total from order_items
    where order_id = or_id
    group by order_id;
        
return v_total;
end;
/

select DISTINCT order_id,calculate_total_order_amount(order_id) as total_amount from order_items order by order_id;


    --Develop a PL/SQL procedure to identify products  where ordered for more than once and insert this records into product_info table with product_id,
--Number of Orders  and sum of that product item. The procedure should also print the number of record as "Number of record insert into product_info tables is  12"
--If no products meet the criteria, handle the user define exception "err_no_product" by printing a message printing a message indicating that no products
--had orders more than onces  as "No Product ordered more than once".
--Write the procedure with named product_order using the basic loop with cursor.
--Note: Create the table "Product_info" with Column as 
--	product_id(number): ProductId 
--	No_Of_Ordered(number): Number of ordered made by each product
--	Sum_of_Cost (number): sum of unit_price * quantity by each product
--
DESC product_info;

select * from products order by product_id;

select * from orders;
select * from order_items;
select product_id,count(order_id)as no_of_orders,round(sum(quantity*unit_price),0) as sum_of_cost  from order_items 
group by product_id
having count(order_id) >1
order by product_id;

CREATE or replace procedure product_order  as 
cursor c is select product_id,count(order_id)as no_of_orders,round(sum(quantity*unit_price),0) as sum_of_cost from order_items group by product_id;
c_emp c%rowtype;
v_count number:=0;
err_no_product EXCEPTION;
begin 
    open c;
    loop
        fetch c into c_emp;
        exit when c%notfound;
        insert into product_info values(c_emp.product_id,c_emp.no_of_orders,c_emp.sum_of_cost);
        v_count := v_count + 1;
    end loop;
    close c;
    if v_count < 1 then 
        raise err_no_product;
    else dbms_output.put_line('Number of record insert into product_info tables is '||v_count);
    end if;
EXCEPTION 
    when err_no_product then 
        dbms_output.put_line('No Product ordered more than once');
end;
/


execute product_order;

select * from product_info order by product_id;



--Develop a PL/SQL function for the orders table that accepts a salesman_id as input and 
--returns the full name of the salesman in the format "First_Name Last_Name". If the salesman_id is NULL, 
--the function should handle this exception and return the string "Walk-in Customers".

select distinct salesman_id from orders;
select * from employees order by employee_id;



create or replace function  emp_name (salesman number) return varchar2 as 
v_firstname employees.first_name%type;
v_lastname employees.last_name%type;
str exception;
begin 
    select first_name,last_name into v_firstname,v_lastname from employees 
    where employee_id =  salesman;
    
    if salesman is null then raise str;
    else return v_firstname || ' '||v_lastname;
    end if;
    exception 
        when str then 
            return 'Walk-in Customers';
end;
/

select emp_name(employee_id) from employees where employee_id in (select salesman_id from orders);




--1) Write an SQL query to display the salesmen along with their salesman_id and the total number of orders they made in the year 2017. 
--The total number of orders should be displayed as No_Of_Orders. The results should be sorted in descending order based on No_Of_Orders.


select * from orders;
select * from employees order by employee_id;

select o.salesman_id,e.first_name,count(o.order_id) as No_Of_Orders from
orders o join employees e on o.salesman_id = e.employee_id 
where to_char(o.order_date,'YYYY') = 2017
group by o.salesman_id,e.first_name;


--2) Write an SQL query to display the orders with the following details: Order_id, order_date, customer_id, and salesman_id. 
--The query should include orders that were placed from January 2, 2017, to the next 100 days and are currently in a pending status.

select * from orders;

SELECT order_id, order_date, customer_id, salesman_id
FROM orders
WHERE order_date BETWEEN TO_DATE('02-01-2017', 'DD-MM-YYYY') AND (TO_DATE('02-01-2017', 'DD-MM-YYYY') + 100)
  AND status = 'Pending';

	
--3) Write an SQL query to display the details of orders that have been canceled. The query should include the order_id, customer_id, status, and order_date for each order. 
--Additionally, the query should only include orders from customers who have had more than one order canceled.

select * from orders;

select order_id,customer_id,status,order_date 
from orders
where status = 'Canceled'
and customer_id in (
select customer_id from orders where status = 'Canceled' group by customer_id having count(*) > 1);


--4) Write an SQL query to display the details of products that belong to the 'Mother Board' category and have been ordered in quantities greater than 140. 
--The query should include the product_id, product_name, standard_cost, and the quantity ordered. 
--The results should be sorted in descending order based on the quantity ordered.
	

select p.product_id,p.product_name,p.standard_cost,o.quantity
from products p 
    join product_categories pc on p.category_id = pc.category_id and pc.category_name = 'Mother Board'
    join order_items o on p.product_id = o.product_id and o.quantity > 140
    order by o.quantity desc;
    


select * from order_items;



--6\. Show total number of products in each category.
--7\. Display the maximum, minimum, and average `LIST_PRICE` of products.
--8\. List customers who haven’t placed any orders.
--9\. Show orders with order value greater than 1000 (assume order value = SUM of quantity × unit\_price).

select category_id,count(*) as no_of_Prods from products group by category_id;
select max(list_price),min(list_price),avg(list_price) from products;
select customer_id from customers where customer_id not in (select customer_id from orders);
select distinct order_id from order_items
where order_id in (
    select order_id from order_items group by order_id having sum(quantity*unit_price) > 1000
);


--1. Use `ROWNUM` to select the top 10 products by price.
--2. Use `RANK()` to rank employees based on their `HIRE_DATE`.
--3. Use `DENSE_RANK()` to rank products by `LIST_PRICE`.
--4. Use `LAG()` to find the previous `LIST_PRICE` of a product in the same category.
--5. Show each order and a running total of its item amounts per customer.
--
--**Intermediate:**
--6\. Use `LEAD()` to find the next product's name and price within the same category.
--7\. Partition employees by job title and rank them by hire date.
--8\. Calculate cumulative quantity ordered per product using `SUM() OVER()`.
--9\. Use `NTILE(4)` to divide employees into performance quartiles (assume a rating field).
--10\. Use analytic functions to compute the difference between a product’s list price and category average.

select * from products where rownum < 11 order by list_price desc;

select employee_id,first_name,hire_date,
RANK() OVER (ORDER BY hire_date desc) as rank_date
from employees;

select product_id,list_price,
DENSE_RANK() OVER (ORDER BY list_price desc) as rank_price
from products;

select product_id,list_price,
LAG(list_price,1,0) over (partition by category_id order by list_price) as previous_list_price
from products;

select * from employees;

select employee_id,first_name,job_title,
rank() over (partition by job_title order by hire_date desc) as rank_job
from employees;


---------JOINS---------------------
SELECT * FROM ORDERS;
SELECT * FROM CUSTOMERS;
SELECT * FROM CONTACTS;
SELECT * FROM PRODUCTS;
SELECT * FROM PRODUCT_CATEGORIES;
--1. List orders with their associated customer names.
select o.order_id,ct.first_name || ct.last_name as full_name 
from orders o
    join customers c on c.customer_id = o.customer_id
    join contacts ct on ct.customer_id = o.customer_id
    order by o.order_id;
--2. Display product names along with category names.
        SELECT P.PRODUCT_NAME,PC.CATEGORY_NAME FROM PRODUCTS P JOIN PRODUCT_CATEGORIES PC ON P.CATEGORY_ID = PC.CATEGORY_ID;
--3. Show employee names along with their manager’s name.
    SELECT E.FIRST_NAME,M.FIRST_NAME FROM EMPLOYEES E JOIN EMPLOYEES M ON E.EMPLOYEE_ID = M.MANAGER_ID;
    --SELECT EMPLOYEE_ID,FIRST_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (SELECT MANAGER_ID FROM EMPLOYEES);
--4. List warehouses with their location addresses.
    
--5. Show products with their inventory quantities at each warehouse.
SELECT * FROM WAREHOUSES;
SELECT * FROM INVENTORIES;

SELECT
    p.product_name,
    w.warehouse_name,
    i.quantity
FROM
    products p
JOIN
    inventorIES i ON p.product_id = i.product_id
JOIN
    warehouses w ON i.warehouse_id = w.warehouse_id
ORDER BY
    p.product_name,
    w.warehouse_name;



--
--**Intermediate:**
--6\. Find all customers who have placed more than 2 orders using `GROUP BY` and `JOIN`.

    SELECT * FROM CONTACTS;
    
    SELECT O.CUSTOMER_ID,C.FIRST_NAME,COUNT(O.ORDER_ID)AS NO_OF_ORDERS 
    FROM ORDERS O 
    JOIN CONTACTS C ON  O.CUSTOMER_ID = C.CUSTOMER_ID
    GROUP BY O.CUSTOMER_ID,C.FIRST_NAME 
    HAVING COUNT(O.ORDER_ID) > 2 ORDER BY O.CUSTOMER_ID ;


--7\. List contacts and their corresponding customer’s website.
  
    
    SELECT CT.CUSTOMER_ID,C.FIRST_NAME,C.LAST_NAME,C.EMAIL,C.PHONE FROM CUSTOMERS CT JOIN CONTACTS C ON CT.CUSTOMER_ID = C.CUSTOMER_ID;
--8\. Retrieve employees who have not placed any sales (no matching records in `ORDERS`).
        SELECT * FROM EMPLOYEES;
        SELECT * FROM ORDERS;
        
        SELECT EMPLOYEE_ID,FIRST_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (SELECT SALESMAN_ID FROM ORDERS);
        
--9\. Join `ORDERS`, `ORDER_ITEMS`, and `PRODUCTS` to show complete order details.

    SELECT * FROM ORDERS;
    SELECT * FROM ORDER_ITEMS;
    SELECT * FROM PRODUCTS;
    
--10\. Display warehouse names and their city and country using multi-level joins.


    


--1. Find customers whose credit limit is above the average credit limit.
SELECT CUSTOMER_ID,CREDIT_LIMIT FROM CUSTOMERS WHERE CREDIT_LIMIT > (SELECT AVG(CREDIT_LIMIT) FROM CUSTOMERS);
--2. Get product names that belong to the category with the highest number of products.
    
    SELECT * FROM PRODUCTS;
    

    SELECT COUNT(*)AS CT FROM PRODUCTS GROUP BY CATEGORY_ID;
    
    SELECT CATEGORY_ID,COUNT(*) AS CT 
    FROM PRODUCTS 
    GROUP BY CATEGORY_ID
    HAVING COUNT(*) >= (SELECT COUNT(*)AS CT FROM PRODUCTS );
    
    WITH CategoryProductCounts AS (
    SELECT category_id, COUNT(*) AS product_count
    FROM products
    GROUP BY category_id
),
MaxProductCount AS (
    SELECT MAX(product_count) AS max_count
    FROM CategoryProductCounts
),
HighestProductCategory AS (
    SELECT cpc.category_id
    FROM CategoryProductCounts cpc
    JOIN MaxProductCount mpc ON cpc.product_count = mpc.max_count
)
SELECT p.product_name
FROM products p
JOIN HighestProductCategory hpc ON p.category_id = hpc.category_id;
    
--3. Find orders where the total quantity ordered exceeds 100.
    
    SELECT * FROM ORDERS;
    SELECT * FROM ORDER_ITEMS;
    
    SELECT ORDER_ID,SUM(QUANTITY) AS TOT_QUAN FROM ORDER_ITEMS 
    GROUP BY ORDER_ID
    HAVING SUM(QUANTITY)>100
    ORDER BY ORDER_ID;
    
    
--4. Show employees whose salary is higher than their manager’s.
SELECT E.EMPLOYEE_ID,E.FIRST_NAME FROM EMPLOYEES E JOIN EMPLOYEES M ON E.EMPLOYEE_ID = M.MANAGER_ID
WHERE E.SALARY > M.SALARY;

SELECT * FROM EMPLOYEES;

--5. List products that were never sold (use `NOT IN` or `NOT EXISTS`).

    SELECT PRODUCT_ID,PRODUCT_NAME FROM PRODUCTS WHERE PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM ORDER_ITEMS);


--6\. Get the second highest `LIST_PRICE` using a subquery.
    SELECT MAX(LIST_PRICE) FROM PRODUCTS WHERE LIST_PRICE < (SELECT MAX(LIST_PRICE) FROM PRODUCTS);
--7\. Display names of employees who are managers (exist in `MANAGER_ID`).
        SELECT M.FIRST_NAME ||' ' || M.LAST_NAME AS MANAGER_NAME FROM EMPLOYEES E JOIN EMPLOYEES M ON E.EMPLOYEE_ID = M.MANAGER_ID;
--8\. List customers who placed an order in the last 7 days using a correlated subquery.

    SELECT * FROM ORDERS;
    SELECT
    c.customer_id
FROM
    customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.order_date >= TO_DATE('17-02-2025','DD-MM-YYYY') - INTERVAL '7' DAY
);
--9\. Find products whose price is above the average price in their category (correlated subquery).
        
--10\. Get the customer(s) who placed the highest number of orders.
        
        

--**Intermediate:**---------------------------------------------------------------------
--6\. Create a procedure that inserts a new employee and validates email uniqueness.
        select * from employees;
        
--7\. Develop a procedure to calculate total sales for a given order.
    SELECT * FROM ORDER_ITEMS;
--8\. Write a procedure to generate a report of employees grouped by job title. 
        select employee_id,job_title,first_name,last_name from employees group  by job_title,first_name,last_name,employee_id order by job_title;
--9\. Create a procedure to raise salary by 10% for employees in a specific department.

--10\. Develop a procedure to archive orders older than 1 year into a history table.


--6\. Create a function that returns the average order value for a customer.
with cte as ( 
        SELECT o.customer_id,o.order_id, SUM(oi.quantity * oi.unit_price) AS total_order_value
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        GROUP BY o.order_id,o.customer_id
)
select avg(total_order_value) from cte WHERE customer_id = 4;  
--7\. Write a function to return the number of employees under a specific manager.
with cte as (
select employee_id from employees 
where employee_id 
    in  
        (select manager_id from employees)
)
select first_name,last_name from employees;
--8\. Develop a function to return the top-performing salesman by total sales.
        
select salesman_id,sales,
rank() over ( order by sales ) 
from (
select o.salesman_id,round(sum(oi.quantity*oi.unit_price),0) as sales from orders o 
join order_items oi on o.order_id = oi.order_id group by o.salesman_id)
order by sales;
--9\. Create a function to get the reorder quantity based on current inventory.

    
--10\. Write a function that accepts an order ID and returns the order’s total amount.
    select * from order_items;
    
    select order_id,sum(quantity * unit_price) as tot_amount from order_items
    where order_id=70
    group by order_id;


select * from orders;

select * from customers;
select * from contacts;

select * from order_items;


select order_id from order_items 
where  sum(quantity*unit_price) > (select avg(quantity*unit_price) from order_items group by order_id)
group by order_id;



select co.contact_id,co.first_name 
from contacts co 
    join orders o on co.customer_id = o.customer_id
    where o.order_id in (
                    select order_id from order_items 
                    group by order_id
                    having  sum(quantity*unit_price) > (select avg(quantity*unit_price) from order_items group by order_id)
                    )
            order by contact_id;
            
select * from contacts;
select * from customers;


select c.first_name,o.order_id from orders o join contacts c on o.customer_id = c.customer_id
where o.order_id in (
SELECT
    order_id
FROM
    order_items
GROUP BY
    order_id
HAVING
    SUM(quantity * unit_price) > 
    (SELECT AVG(order_value) FROM (SELECT order_id, SUM(quantity * unit_price) AS order_value FROM order_items GROUP BY order_id))
)
order by order_id;

select product_name,list_price from products where product_id not in (select product_i);

select * from order_items;





--1) Create a PL/SQL procedure named cus_credit_update that takes a single input parameter: v_customer_id (the unique identifier of a customer).
--The procedure should update the customer's credit limit based on the total number of orders they have placed, according to the following rules:
--	i) 5 or more orders: Increase the customer's credit limit by 20%.
--	ii) Between 2 and 4 orders (inclusive): Increase the customer's credit limit by 10%.
--	iii) Exactly 1 order: Increase the customer's credit limit by 5%.
--	iv) 0 orders: Do not change the customer's existing credit limit. 
--In this case, raise a user-defined exception with the message "<Customer Name> never made an order so no credit limit update." 
--After a successful credit limit update, the procedure should display a message in the format: "<Customer Name> is updated with a credit limit of $<500>


select * from customers;
select * from contacts;
select * from orders;
select * from order_items;

select * from cust1 order by customer_id;
select customer_id,count(order_id) from orders 
where customer_id = 1 
group by  customer_id;


  select customer_id,count(order_id) from orders 
    group by  customer_id;

------------------------------------------------------------------
create or replace procedure cus_credit_update (v_customer_id IN number) as
v_credit number;
v_creditinc number;
v_order number;
v_custname varchar2(40);
no_order exception;
begin 
    select count(order_id) into v_order from orders 
    where customer_id = v_customer_id 
    group by  customer_id;
     case 
        when  v_order >= 5 then v_creditinc := 20;
        when  v_order >=2 and v_order <= 4  then v_creditinc := 10;
        when  v_order = 5 then v_creditinc := 5;
        when  v_order = 0 then raise no_order;
    end case;
    
    select credit_limit into v_credit from customers where customer_id = v_customer_id;
    update cust1 set credit_limit = credit_limit + credit_limit*(v_creditinc/100) where customer_id = v_customer_id;
    
    select first_name into v_custname from contacts where customer_id = v_customer_id;
    
    dbms_output.put_line(v_custname||' is updated with a credit limit of '||v_credit*(v_creditinc/100));
    exception
        when no_order then 
            dbms_output.put_line(v_custname ||' never made an order so no credit limit update.');
        when others then 
             dbms_output.put_line('An Error Occured');
end;
/

execute cus_credit_update(44);
-------------------------------------------------------------------------------------------


--Develop a PL/SQL procedure that takes a year (v_year IN) as an input parameter and determines the percentage of canceled orders for that year. 
--The procedure should follow these rules:
--Procedure Logic:
--	i) Calculate the percentage of canceled orders within the given year 
--	ii) If orders exist but none were canceled, display: "No orders were canceled."
--	iii) If no orders exist for the given year, handle the exception and display: "No orders found for the year."
--	iv) If canceled orders exist, display the result as: "Order cancellation status is 7%."

select count(order_id)  from orders
    where status='Canceled'
    group by status;

select sum(ct)  from (select count(order_id) as ct from orders
    where EXTRACT(YEAR FROM ORDER_DATE) = 2015
    group by status);
 select count(order_id) as ct from orders
    where EXTRACT(YEAR FROM ORDER_DATE) = 2015
    group by status;
    
    
create or replace procedure cancel_ords (v_year IN number) as
v_totcanords number;
v_cancelords number;
v_orders number;
v_perc number;
exc exception;
begin
    select count(order_id) into v_totcanords  from orders
    where status='Canceled'
    group by status;
    
    select sum(ct) into v_orders  from (select count(order_id) as ct from orders
    where EXTRACT(YEAR FROM ORDER_DATE) = v_year
    group by status);
    
    select count(order_id) into v_cancelords from orders
    where status='Canceled' and EXTRACT(YEAR FROM ORDER_DATE) = v_year
    group by status;
    
    
    if(v_orders is not null) then
        if(v_cancelords is null) then
            raise exc;
        end if;
    end if;
    v_perc := (v_cancelords/v_totcanords) * 100;
    dbms_output.put_line('Order cancellation status is '||v_perc||'%');
    exception 
        when no_data_found then 
            dbms_output.put_line('No orders found for the year'); 
        when exc then 
            dbms_output.put_line('No orders were canceled');
end;
/




set serveroutput on;
execute cancel_ords(2015);


--3) Develop a PL/SQL function named get_business_contact that takes a single input parameter: customer_id (the unique identifier of a customer).
--The function should:
--	i) Retrieve the first name and last name of the business contact person associated with the given customer_id.
--	ii) Concatenate these names into a single string following a specific format: first_name last_name
--	iii) Assume there is a title associated with the contact person (e.g., 'Mr.', 'Ms.', 'Mrs.'). example "Mr/Mrs. Nancy Jones"
--	For example, if the title is 'Mr.', the first name is 'FLOR', and the last name is 'STONE', the function should return the string "Mr. FLOR STONE".
--	The function should then return this formatted string containing the customer's business contact person's full name with the title  in capital letter.

    create or replace function get_business_contact (cust_id number) return varchar2 as
    v_first_name contacts.first_name%type; 
    v_last_name contacts.last_name%type;    
    v_str varchar2(200); 
begin
    select first_name, last_name
    into v_first_name, v_last_name 
    from contacts
    where customer_id = cust_id;

    v_str := 'Mr./Mrs. ' || UPPER(v_first_name) || ' ' || UPPER(v_last_name);

    return v_str;
end;
/
select get_business_contact(customer_id) from contacts; 



select * from contacts;

select * from employees;

--4) Write a PL/SQL program (specifically a function called warehouse_stock) that, 
--when you give it a product's unique ID, will tell you where that product is stored and how many are currently in stock. 
--The function should return this information as a single piece of text, like 'San Francisco-255', 
--where 'San Francisco' is the warehouse name and '255' is the number of that product in stock there. 



create or replace function warehouse_stock(p_id number) return varchar2 as 
v_str varchar2(100);
v_str1 varchar2(200);
v_qty number;
begin
    
select pc.category_name,sum(i.quantity) into v_str,v_qty from 
product_categories pc 
    join products p on pc.category_id = p.category_id
    join inventories i on p.product_id = i.product_id 
    where p.product_id = p_id
    group by pc.category_id,pc.category_name;
    v_str1 := v_str||'-'||v_qty;
    if v_str1 is not null then
        return v_str1;
    else 
    return 'No quants';
    end if;
end;


select warehouse_stock(product_id) as single_piece from products;





select * from products;

select pc.category_name,sum(i.quantity) from 
product_categories pc 
    join products p on pc.category_id = p.category_id
    join inventories i on p.product_id = i.product_id 
    where p.product_id = 7
    group by pc.category_name,pc.category_id;


 select * from products;
 select * from product_categories;
 select * from inventories;
 
 select * from contacts;
 
 
 

create or replace procedure cus_credit_update (v_customer_id number) as
  v_credit    number;
  v_creditinc number;
  v_order     number;
  v_custname  varchar2(40);
  no_order    exception;
begin
  select count(order_id)
  into   v_order
  from   orders
  where  customer_id = v_customer_id;

  if v_order = 0 then
    raise no_order;
  elsif v_order >= 5 then
    v_creditinc := 20;
  elsif v_order >= 2 and v_order <= 4 then
    v_creditinc := 10;
  elsif v_order = 1 then
    v_creditinc := 5;
  end if;

  select credit_limit
  into   v_credit
  from   customers
  where  customer_id = v_customer_id;

  update customers
  set    credit_limit = credit_limit + (credit_limit * (v_creditinc / 100))
  where  customer_id = v_customer_id;

  select first_name
  into   v_custname
  from   contacts
  where  customer_id = v_customer_id;

  dbms_output.put_line(v_custname || ' is updated with a credit limit of ' ||
                       v_credit * (v_creditinc / 100));
exception
  when no_order then
    dbms_output.put_line(v_custname ||
                         ' never made an order so no credit limit update.');
end;
/


execute cus_credit_update(1);


select * from contacts;
select * from countries;
select * from customers;
select * from employees;
select * from inventories;
select * from products;
select * from warehouses;
select * from orders;
select * from order_items;
select * from products;

--write an sql query to get product names that belong to the 
--category with the highest number of products.

select max(prod_ct) from 
(select category_id,count(*) as prod_ct from products 
group by category_id);

select p.product_name from products p
where p.category_id in (
    select category_id from products 
    group by category_id
    having count(*) = (
    select max(prod_ct) from 
(select category_id,count(*) as prod_ct from products 
group by category_id)
    )
);

 select category_id from products 
    group by category_id
    having count(*) = (
    select max(prod_ct) from 
(select category_id,count(*) as prod_ct from products 
group by category_id));
























    
    














