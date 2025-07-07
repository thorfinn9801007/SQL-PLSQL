select * from customers;
select * from contacts;
select * from orders;
--1.  Find the names of customers who have placed more than 2 orders in total.
    select first_name from contacts where customer_id in (
    select customer_id from orders 
        group by customer_id 
        having count(*) > 2);
--2.  List the cities where the average order amount is greater than 1000.  
        SELECT TO_DATE('2023-10-26', 'YYYY-MON-DD') FROM dual;
         SELECT TO_CHAR('2023-10-26', 'YYYY-MM-DD') FROM dual;
         SELECT TO_CHAR(SYSDATE, 'DD Day Mon YYYY ') FROM dual;
--3.  Retrieve the `CustomerID` and the latest `OrderDate` for each customer who has placed at least one order.     
--4.  Identify the customers who have placed orders with a total amount greater than the average total amount of all orders.
--5.  Find the names of categories where the average product price is greater than 50.
--6.  List the names of products that belong to a category with more than 5 products.
--7.  Retrieve the `CategoryName` and the most expensive `ProductName` within each category.
--8.  Identify the categories where all products have a price greater than 20.
--9.  Find the names of departments that have more than 3 employees.
--10. List the names of employees who work in a department with an average salary greater than 60000.
--11. Retrieve the `DepartmentName` and the highest `Salary` within each department.
--12. Identify the departments where the minimum salary of an employee is greater than the average salary of all employees.


select * from orders;
select * from order_items;

-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
select product_id,product_name
from products p 
where not exists (select product_id from order_items oi where oi.product_id = p.product_id);






select 
     p.product_id,p.product_name
from products p 
LEFT join order_items oi on p.product_id = oi.product_id
where oi.product_id is NULL;


select t.cust_id,sum(t.tot_amt) as tot
from 
(
select o.customer_id as cust_id,
    (select sum(oi.quantity*oi.unit_price) from order_items oi where oi.order_id = o.order_id) as tot_amt
from orders o
order by o.customer_id)  t
where t.tot_amt > 50000
group by t.cust_id
order by t.cust_id;



with cte as (
select o.customer_id as cust_id,
    (select sum(oi.quantity*oi.unit_price) from order_items oi where oi.order_id = o.order_id) as tot_amt
from orders o
order by o.customer_id
)
select customer_id,
    (select sum(tot_amt) from cte where tot_amt > 50000 and cust_id = customer_id group by cust_id ) as tot
from orders; 



--Find the names of all products that have been ordered at least once.

SELECT * FROM PRODUCTS;

SELECT * FROM ORDER_ITEMS;
SELECT * FROM ORDERS;

SELECT P.PRODUCT_NAME FROM PRODUCTS P
JOIN ORDER_ITEMS OI ON P.PRODUCT_ID = OI.PRODUCT_ID
GROUP BY P.PRODUCT_NAME
HAVING COUNT(OI.ORDER_ID) > 1;



SELECT PRODUCT_ID FROM ORDER_ITEMS
GROUP BY PRODUCT_ID 
HAVING COUNT(ORDER_ID) > 1
ORDER BY PRODUCT_ID;

--List the order ID and the total amount for each order. 
--The total amount for an order is the sum of (quantity * unit_price) for all items in that order.

SELECT * FROM ORDER_ITEMS ORDER BY ORDER_ID;

SELECT ORDER_ID,COUNT(ITEM_ID) AS CT 
FROM ORDER_ITEMS GROUP BY ORDER_ID;

SELECT ORDER_ID , SUM(QUANTITY*UNIT_PRICE) AS TOT_AMT
FROM ORDER_ITEMS GROUP BY ORDER_ID
ORDER BY ORDER_ID ASC;



--Retrieve the names of customers who have placed more than one order. 
--(Assume you have a CUSTOMERS table with customer_id and customer_name columns).

SELECT * FROM CONTACTS;
SELECT * FROM ORDER_ITEMS;

SELECT C.FIRST_NAME 
FROM  CONTACTS C JOIN ORDERS    
OI ON C.CUSTOMER_ID = OI.CUSTOMER_ID;



==Find the names of all products in the 'Electronics' category that have a price greater than the average price of all products.
   
   
   SELECT * FROM PRODUCTS;
   SELECT * FROM PRODUCT_CATEGORIES;
   
For each product category, find the average price of the products in that category. Only include categories where the average price is greater than 50.

SELECT * FROM PRODUCT_CATEGORIES;

SELECT CATEGORY_ID , SUM(LIST_PRICE) AS PRICE
FROM PRODUCTS GROUP BY CATEGORY_ID;

List the order IDs and the number of distinct products in each order.

Find the names of products that have never been ordered.

Retrieve the names of categories where at least one product has a price greater than 100.

For each customer, find the total amount they have spent across all their orders. (Again, assume a CUSTOMERS table).

Find the names of products that were included in orders placed in January 2024.