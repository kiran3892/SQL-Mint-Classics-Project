-- Exploratory Data analysis for employee

-- 1. counting number of employees in Mint classic Company
select
count(employeeNumber)
from employees_cluster_view;
-- A total of 108 employees were working in Mint classics

-- 2. finding out the job titles designated in mint classics
select
distinct(jobTitle) as Designation
from employees_cluster_view;
-- A total of 7 job titles were found ('President', 'VP Sales', 'VP Marketing', 'Sales Manager (APAC)', 'Sale Manager (EMEA)', 'Sales Manager (NA)', 'Sales Rep')


-- 3. finding out the employee distribution across offices
select
officeCode,
count(distinct employeeNumber) as Employees
from employees_cluster_view
group by 1
order by 2 desc;
-- Office with code 1 has highest employess (6) followed by offfice code 4, 6
-- lowest number of employees were present in offices with code 2,3,5,7


-- 4. finding out the employees with no assigned customers
select 
concat(firstName,' ',lastName) as employeeName,
jobTitle
from employees_cluster_view
where customerNumber is null;
-- A total of 8 rows were returned among them 2 are sales representatives
-- hence, 2 sales reps were assigned no customers till now


-- 5. Employess without a proper Office
select
employeeNumber,
firstName, lastName
from employees_cluster_view
where officeCode is null;
-- the result was empty table, indicating that all employees were assigned to respective offices and no one is working without office


-- 6. Employess by country
select
country,
count(distinct customerNumber) as Number_of_employees
from employees_cluster_view
group by 1
order by 2 desc;
-- Country USA has more employess (39) eneged in mint classic company
-- country japan has  lowest employess (5) engaged in mint classics company


-- 7. customers managed by office locations
select 
city,
country,
count(customerNumber) as customers
from employees_cluster_view
group by 1,2
order by 3 desc;

-- paris is having more customers base (29) followed by London (17) , NewYorkCity(NYC) (15)
-- Tokyo from Japan is having lowest customer base (5)


-- 8. Ranking managers based on their reportess (Using self join)
select
m.employeeNumber as ID,
m.firstName as firstName,
m.lastName as lastName,
m.jobTitle as job_title,
count(e.employeeNumber) as totalReportees
from employees_cluster_view e
join employees_cluster_view m on e.reportsTo = m.employeeNumber
where m.reportsTo is not null
group by 1,2,3,4
order by 5 desc;
-- Manager named 'Gerard Bondur' is having highest number of reportees (46), followed by 'Anthony Bow' with 39 reportees



-- 9. Customerbase per employee
select 
distinct employeeNumber as EmpId,
concat(firstName, ' ', lastName) as employeeName,
count(distinct customerNumber) as customers
from employees_cluster_view
where customerNumber is not null
group by 1,2
order by 3 desc;
-- Employee 'Pamela Castillo' has highest customerbase (10)
