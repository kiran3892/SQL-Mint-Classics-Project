create view customers_cluster_view as
select
c.customerNumber,
c.customerName,
c.city,
c.state,
c.country,
c.creditLimit,
c.salesRepEmployeeNumber,
e.firstName,
e.lastName,
o.orderNumber,
p.productName,
od.quantityOrdered,
od.priceEach,
coalesce(sum((od.quantityOrdered * od.priceEach)),0) as order_amount,
coalesce(sum(py.amount),0) as paid_amount,
o.orderDate,
o.shippedDate,
o.Status,
max(py.paymentDate) as latest_paymentDate,
min(py.paymentDate) as first_paymentDate
from customers c
left join employees e on c.salesRepEmployeeNumber = e.employeeNumber
left join orders o on c.customerNumber = o.customerNumber
left join orderdetails od on o.orderNumber = od.orderNumber
left join products p on od.productCode = p.productCode
left join payments py on c.customerNumber = py.customerNumber
group by 
c.customerNumber, c.customerName, c.city, c.state, c.country, c.creditLimit, c.salesRepEmployeeNumber,
e.firstName, e.lastName, o.orderNumber, p.productName, od.quantityOrdered, od.priceEach, o.orderDate,
o.shippedDate, o.Status
;
