desc Sales;

select * from Sales;

select * from (
select area,idshopname,salesamount
from Sales
) pivot (
    sum(salesamount)
    for idshopname in
    ('shop01','shop02','shop03')
);


select * from (
    select area, idshopname, salesamount
    from Sales
)
PIVOT (
    SUM(salesamount)
    for idshopname in
    ( 'shop01' , 'shop02' , 'shop03' )
);

create table pros(
product varchar2(10),
quarter varchar2(10),
sales number
);


select * from pros;

select * from (
select product,quarter,sales 
from pros)
pivot (
sum(sales)
for quarter in ('Q1' as q1_sales,'Q2' as q2_sales,'Q3' as q3_sales)
);




