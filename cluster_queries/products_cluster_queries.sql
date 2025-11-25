------- A. General idea about the products ---------------------

-- 1. Total Products sold by Mint Classics Company
select * from products; -- A total of 110 products were sold


-- 2. Total stock of the comapny for all products included
select sum(quantityInStock) from products; -- Ans: 5,55,131 stock units
select distinct productLine, sum(distinct quantityInStock) as stock
from product_cluster_view group by 1 order by 2 desc; -- ProductLine classic Cars has highest stock in storage (2,19,183)

-- 3. Distribution of products across productlines
select productName from products
where productline is null; -- Returned a blank table indicationg products are distributed across productlines and no products is outside productline

-- 4. Distribution of products across warehouses
select productName from products
where warehouseCode is null; -- Returned a blank table indicationg products are distributed across productlines and no products is outside warehouse

-- 5. Products that are unsold or not getting orders from customers
select productCode, productName, quantityInStock, warehouseName from product_cluster_view
where orderNumber is null; -- The product '1985 Toyota Supra' with code 'S18_3233' with 7,733 stock units is being unsold by company and is stored at East Warehouse (code-b)

-------- 6. Timerange of product inventory and selling
select 
min(orderDate) as Start_date,
max(orderDate) as End_date
from product_cluster_view; -- The data time range is in between '2003-01-06' and '2005-05-31'

------------------------------------------------------------------
---------------- B. Space utilization ---------------------------

-- 1. identifying total stock store by each warehouse and rank them and also show theier stored capacity and leftout storage_space 
select 
pcv.warehouseCode, pcv.warehouseName, 
sum(distinct quantityInStock) as total_stock,
rank() over (order by sum(distinct quantityInStock) desc) as ranking,
w.warehousePctCap, (100 - w.warehousePctCap) as leftover_Pctspace
from product_cluster_view pcv
join warehouses w on pcv.warehouseCode = w.warehouseCode
group by pcv.warehouseCode, pcv.warehouseName, w.warehousePctCap
order by total_stock desc;

-- Finding:-
-- A. Warehouse 'East (b)' has more stocks stored with left over space 33%
-- B. Warehouse 'South (d)' has less stock store with highest stored percentcapacity and low left over storage space
-- C. Among all warehouses, warehouse 'West (c)' has more left over storage space and stock is also low compared to a & b wareouses




-- 2. finding out the productline wise total orders received and value of the orders (calculating onlly for complered orders(status:shipped, resolved, disputed)
select 
warehouseCode,
productLine,
sum(quantityOrdered) as totalOrders,
sum(Each_price*quantityOrdered) as orderValue
from product_cluster_view
where status in ('Shipped', 'Resolved', 'Disputed')
group by warehouseCode, productLine
order by 3 desc;

-- Finding:-
-- a. Productline classic Cars has more orders (33,817) and more ordervalue ($ 36,70,560) followed by vintage cars and motor cycles
-- b. all the products from warehouse d (south) has least orders and ordervalues (least is trains, followed by ships and Trucks & buses)
-- c. eventhough warehouse c has only one productline and product i.e., vintage cars, the orders and order value is second in poisition.



-- 3. Calculatin products turnover rate (convertion from stock to order)
select 
productCode, 
productName,
round(sum(quantityOrdered / quantityInStock),0) as productTurnover
from product_cluster_view
where status in ('Shipped', 'Resolved', 'Disputed') 
group by productCode, productName
order by 3 asc
;

with turnover as (
select 
productCode, 
productName,
round(sum(quantityOrdered / quantityInStock),0) as productTurnover
from product_cluster_view
where status in ('Shipped', 'Resolved', 'Disputed') 
group by productCode, productName
order by 3 asc
),
idlestock as (
select 
count(productCode) 
from turnover 
where productTurnover = 0)
select * from idlestock;

-- findings:-
-- a. the products with highest turnover ration are '1960 BSA Gold Star DBD34 (68%)','1968 Ford Mustang (13%)','1928 Ford Phaeton Deluxe (6%) ','1997 BMW F650 ST' (5%)
-- b. the higher turnover ratio indicates higher demand for those products
-- c. 89 products are sitting idle without any orders and wasting warehouse space.




-- 4. calcuating productline turover and deciding which product line has high and low customer demand
select
warehouseCode,
productLine,
round(sum(quantityOrdered / quantityInStock),0) as productTurnover
from product_cluster_view
group by productLine, warehouseCode
order by productTurnover desc, warehouseCode;

-- findings:-
-- a. productline motorcycles has highest turnover rate (77%) indicating that motorcycles has highest customerbase
-- b. loweest turnover rate is from ships, truck & buses and trains productline, which belongs to warehouse d 




-- 5. calcuating warehouse turover and deciding which warehouse products have high & low customer demand
select
warehouseCode,
warehouseName,
round(sum(quantityOrdered) / sum(distinct quantityInStock),2) as InventoryTurnover
from product_cluster_view
where status in ('Shipped', 'Resolved', 'Disputed') 
group by warehouseCode, warehouseName
order by 3 desc;

-- findings:-
-- a. warehouse d has higher inventory turnover rate (0.26) folloed by a (0.18) and C (0.17).
-- b. warehouse b has lowest inventory turnover rate  (0.16)




--- 5. deciding which products are to be liquidated based on the their orders, stock level and sale values
-- a. first identifying products orders and sales
-- b. identifying products stock
-- c. identifying product sale values
-- d. using NTILE function identify low ordered, high stock and low sale value products for liquidation

with totalOrders as (
select 
productCode,
productName,
sum(quantityOrdered) as totalOrders,
sum(Each_price * quantityOrdered) as totalSales
from product_cluster_view
where status in ('Shipped', 'Resolved', 'Disputed')
group by productCode, productName
),
totalStock as (
select 
productCode,
productName,
sum(quantityInStock) as totalStock
from product_cluster_view
group by productCode, productName
),
quartiles as (
select
ts.productCode,
ts.productName,
ts.totalStock,
coalesce(tr.totalOrders,0) as totalOrders,
coalesce(tr.totalSales,0) as totalSales,
ntile(4) over (order by ts.totalStock) as quartileStock,
ntile(4) over (order by tr.totalOrders) as quartileOrders,
ntile(4) over (order by tr.totalSales) as quartileSales
from totalOrders tr
right join totalStock ts on tr.productCode = ts.productCode)
select * from quartiles 
where quartileStock = 4 and quartileOrders <= 2 and quartileSales = 1;

-- Finding:-
-- Five candidates for discontinuation: '1966 Shelby Cobra 427 S/C', '1939 Chevrolet Deluxe Coupe', '1982 Lamborghini Diablo', '1982 Ducati 996 R', and '1950's Chicago Surface Lines Streetcar' 




--- 6. deciding which products are to be increased in stock based on the their orders, stock level and sale values
-- a. first identifying products orders and sales
-- b. identifying products stock
-- c. identifying product sale values
-- d. using NTILE function identify high ordered, low stock and High sale value products for increasing in inventory

with totalOrders as (
select 
productCode,
productName,
sum(quantityOrdered) as totalOrders,
sum(Each_price * quantityOrdered) as totalSales
from product_cluster_view
where status in ('Shipped', 'Resolved', 'Disputed')
group by productCode, productName
),
totalStock as (
select 
productCode,
productName,
sum(quantityInStock) as totalStock
from product_cluster_view
group by productCode, productName
),
quartiles as (
select
ts.productCode,
ts.productName,
ts.totalStock,
coalesce(tr.totalOrders,0) as totalOrders,
coalesce(tr.totalSales,0) as totalSales,
ntile(4) over (order by ts.totalStock) as quartileStock,
ntile(4) over (order by tr.totalOrders) as quartileOrders,
ntile(4) over (order by tr.totalSales) as quartileSales
from totalOrders tr
right join totalStock ts on tr.productCode = ts.productCode)
select * from quartiles 
where quartileStock = 1 and quartileOrders >= 2 and quartileSales = 4;

-- Finding:-
-- Five products for stock increase: '1968 Ford Mustang', '1962 Volkswagen Microbus', '1958 Setra Bus', '1969 Ford Falcon', and '1957 Corvette Convertible'




 -- 7. detecting product outliers across totalstock, totalorders, total sales
  -- 1. calculate products total orders and sales
  with product_orders_sales as (
  select
  productCode, productName,
  sum(quantityOrdered) as totalOrders,
  sum(Each_price * quantityOrdered) as totalSales
  from product_cluster_view
  where status in ('Shipped', 'Resolved', 'Disputed')
  group by productCode, productName
),
totalStock as (
select productCode, productName,
sum(quantityInStock) as totalStock
from product_cluster_view
group by productCode, productName
),
product_distribution as (
select
ts.productCode, ts.productName,
coalesce(pos.totalOrders,0) as totalOrders, row_number() over (order by totalOrders) as indexOrders,
coalesce(pos.totalSales,0) as totalSales, row_number() over (order by totalSales) as indexSales,
coalesce(ts.totalStock,0) as totalStock, row_number() over (order by totalStock) as indexStock
from totalStock ts
left join product_orders_sales pos on ts.productCode = pos.productCode
group by ts.productCode, ts.productName
),
products_stats as (
select 
min(totalStock) as minstock, max(totalStock) as maxStock,
(select totalStock from product_distribution where indexStock = 28) as Q1_stock,
(select totalStock from product_distribution where indexStock = 83) as Q3_stock,
(select totalStock from product_distribution where indexStock = 83)-(select totalStock from product_distribution where indexStock = 28) as IQR_Stock,
min(totalOrders) as minOrders, max(totalOrders) as maxOrders,
(select totalOrders from product_distribution where indexOrders = 28) as Q1_orders,
(select totalOrders from product_distribution where indexOrders = 83) as Q3_orders,
(select totalOrders from product_distribution where indexOrders = 83)-(select totalOrders from product_distribution where indexOrders = 28) as IQR_Orders,
min(totalSales) as minSales, max(totalSales) as maxSales,
(select totalSales from product_distribution where indexSales = 28) as Q1_sales,
(select totalSales from product_distribution where indexSales = 83) as Q3_sales,
(select totalSales from product_distribution where indexSales = 83)-(select totalSales from product_distribution where indexSales = 28) as IQR_sales
from product_distribution
),
outliers as (
select
pd.productCode, pd.productName, pd.totalStock, pd.totalOrders, pd.totalSales,
(Q1_stock - (1.5*IQR_stock)) as lowerStock,
(Q3_stock + (1.5*IQR_stock)) as UpperStock,
(Q1_orders - (1.5*IQR_orders)) as lowerorders,
(Q3_orders + (1.5*IQR_orders)) as Upperorders,
(Q1_sales - (1.5*IQR_sales)) as lowersales,
(Q3_sales + (1.5*IQR_sales)) as Uppersales
from product_distribution pd
cross join products_stats
where 
pd.totalStock < (Q1_stock - (1.5*IQR_stock)) or pd.totalStock > (Q3_stock + (1.5*IQR_stock)) or
pd.totalOrders < (Q1_orders - (1.5*IQR_orders)) or pd.totalOrders > (Q3_orders + (1.5*IQR_orders)) or 
pd.totalSales < (Q1_sales - (1.5*IQR_sales)) or pd.totalSales > (Q3_sales + (1.5*IQR_sales))
)
select * from outliers;

-- finding:-
-- got 4 outlier 
-- 1. '1985 Toyota Supra' - for zero orders and zero sales
-- 2. '1957 Ford Thunderbird' - for very samll orders
-- 3. '2001 Ferrari Enzo' - for very large totalSales
-- 4. '1992 Ferrari 360 Spider red' - for very large total orders and total Sales
 
