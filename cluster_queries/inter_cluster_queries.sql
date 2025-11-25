--- finding the data by combining various clusters

-- 1. categorizing sales by each sale Representative
select
c.salesRepEmployeeNumber,
concat(c.firstName, ' ', c.lastName) as Sale_rep_Name,
sum(p.quantityOrdered * p.Each_price) as saleValue
from customers_cluster_view c
join product_cluster_view p on c.orderNumber = p.orderNumber
where c.Status in ('Shipped','Resolved','Disputed')
group by 1,2
order by 3 desc;

-- 'Gerard Hernandez' responsible for highest sale value ($ 132,19,788)
-- 'Leslie Thompson' responsible for lowest sale value ($ 40,41,827)



-- 2. warehouse utilization by customer region 
select
p.warehouseCode,
p.warehouseName,
count(distinct c.customerNumber) as customers,
sum(p.quantityOrdered) as stockOrdered
from product_cluster_view p
join customers_cluster_view c on p.orderNumber = c.orderNumber
where p.Status in ('Shipped','Resolved','Disputed')
group by 1,2
order by 4 desc;

-- warehouse East has more customer traffic (94) and orders (397356)
-- warehouse NOrth has lower customer traffic (70) and second highest orders (279654)
-- warehouse d South has moderate customer base but lowest orders from customers (244362)


-- 3. Popular products from each region
select
e.city,
e.country,
p.productLine,
count(distinct p.orderNumber) as orders,
sum(p.quantityOrdered) as totalProductsOrdered
from employees_cluster_view e
join customers_cluster_view c on e.employeeNumber = c.salesRepEmployeeNumber
join product_cluster_view p on c.orderNumber = p.orderNumber
group by 1,2,3
order by 4 desc, 5 desc; 

-- Most ordered products were classic and vintage cars from Francce, Uk, USA and Australia


-- 4. Customer Retention by Product Line: Customers having ordered items from a distinct product line more than once
with retaincustomers as (
select
c.customerNumber,
p.productLine, 
count(distinct p.orderNumber) as orders
from customers_cluster_view c
join product_cluster_view p on c.orderNumber = p.orderNumber
group by 1, 2
having count(distinct p.orderNumber) > 1
)
select 
productLine, 
count(distinct customerNumber) as customers
from retaincustomers
group by 1
order by 2 desc;
-- ProductLine 'Classic Cars has highest customer retention followed by vintage cars
-- lowest customer retention was from Train


-- 5. Data analysis of orders other than shipped and resolved status
select
distinct o.customerNumber,
c.customerName,
o.orderNumber,
o.status,
o.comments,
c.creditLimit,
ntile(4) over (order by creditLimit) as quartilecreditRange,
c.paid_amount
from orders o
join customers_cluster_view c on o.orderNumber = c.orderNumber
where o.status not in ('Shipped','Resolved');

-- the major reason for order on hold is due to crossing of customer credit limit



-- 6. Sales Rep Performance by Customer Retention: for all orders
select
e.employeeNumber,
e.firstName,
e.lastName,
count(distinct o.orderNumber) as orders,
count(distinct c.customerNumber) as customers
from employees_cluster_view e
join customers_cluster_view c on e.customerNumber = c.customerNumber
join orders o on c.orderNumber = o.orderNumber
group by 1,2,3
order by 5 desc;

-- employee Pamela Castillo has more customers (10)


