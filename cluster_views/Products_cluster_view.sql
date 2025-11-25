 -- product_cluster_view creation
select 
products.productCode,
products.productName,
productlines.productLine,
quantityInStock,
coalesce(buyPrice, 0) as buyPrice,
coalesce(orderdetails.eachPrice, 0) as Each_price,
coalesce((products.buyPrice - orderdetails.eachPrice),0) as profitperOrder,
orderdetails.orderedQuantity,
coalesce((orderdetails.orderedQuantity * orderdetails.eachPrice),0) as total_price,
coalesce(((products.buyPrice - orderdetails.eachPrice) * orderdetails.orderedQuantity),0) as totalprofitperOrder,
orders.orderNumber,
orders.orderedDate,
orders.shippedDate,
orders.status,
warehouses.warehouseCode,
warehouseCode,
warehouseName
from products
left join productlines on products.productLine = productlines.productLine
left join orderdetails on products.productCode = orderdetails.productCode
left join orders on orderdetails.orderNumber = orders.orderNumber
left join warehouses on products.productCode = warehouses.productCode
;



