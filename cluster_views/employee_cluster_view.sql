create view employees_cluster_view as
select 
e.employeeNumber,
e.lastName,
e.firstName,
e.jobTitle,
e.reportsTo,
m.firstName as Manager_firstName,
m.lastName as Manager_lastName,
e.officeCode,
o.city,
o.state,
o.country,
c.customerNumber,
c.customerName,
c.city as customer_city,
c.state as customer_state,
c.country as customer_country
from
employees e
left join employees m on e.reportsTo = m.employeeNumber
left join offices o on e.officeCode = o.officeCode
left join customers c on e.employeeNumber = c.salesRepEmployeeNumber
order by e.employeeNumber;
select * from employees_cluster_view

