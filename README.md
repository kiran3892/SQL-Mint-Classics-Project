<img width="2496" height="1664" alt="image" src="https://github.com/user-attachments/assets/6125f248-25ce-495d-9cbd-9f63c73522b7" />

# Data Analysis in Mint Classic Company Database
In this project, exploratory data analysis will be conducted for Mint Classics Company, a retailer of model cars. The company is looking to close one of its storage facilities. The objective is to recommend inventory reduction strategies that will not negatively impact customer service.

# Database overview
The database is a well-structured relational database the combines all operations of Mint Classics company. The database consists of multiple tables that are interrelated and represents entire operations of Mint classics Company. Each table contains specific information about the company operations and it is related with one or more tables using distinct Keys (Primary & foreign Keys).

# Key Objectives:
- Analyze product sales, inventory turnover, and warehouse utilization to recommend which facility to close.
- Identify underperforming products that could be discontinued.
- Examine customer purchasing behavior and suggest retention strategies.
- Evaluate the performance of sales representatives across regions.

# The database schema
The database consists of 9 tables that are interrelated and represents entire operations of Mint classics Company. 
Tha tables are as follows;
1. **products** - Related to available products and their supply line, how much quantity is there in stock, buying and MSRP prices
2. **productlines** - Explains each product line producing products with link and images
3. **warehouses** - Contain information about warehouse code, names and how much their storage is full
4. **orders** - Stores information about orders, dates of orders, shipment and status of shipment and customer Numbers
5. **orderdetails** - Stores info about orders, products, quantity ordered and price of products purchased and orderline
6. **customers** - Stores information about customers and their contact information and geographic distribution, credit limits, and their assigned sales rep
7. **payments** - Stores info related to payments amount, date of payment and the customer number who made the payment and details of check 
8. **employees** - Store employee names, contact info, reporting person details and their designation in company
9. **offices** - Store office codes, contact info and geographic distribution

# Filed and Folders
**1. Cluster_views**
   - product_cluster_view
   - customer_cluster_view
   - employees_cluster_view
   - warehouses_cluster_view

**2. Cluster_queries**
   - product_cluster_queries
   - customer_cluster_queries
   - employees_cluster_queries
   - warehouses_cluster_queries

**3. Project Report** - *Data Analysis in Mint Classic Company Database*
- This is the comprehensive report that summarizes the findings from the analysis, including recommendations for warehouse closure, inventory management, customer retention and employee management.

**4. mintclassics.mwb**
- A MySQL Workbench model file, which includes the database schema and an Extended Entity Relationship (EER) diagram.

**5.README.MD**
- This file provides an overview of the project, the dataset, and the included files.

**Key Finding**

After analyzing products, customers, employees’ clusters, here are some strategic recommendations to address the business problem in concern i.e., closure of a warehouse.

**1. Warehouse Closure:**
Closing warehouse South (D) is optimal decision due to its low orders, high stock, and moderate value products.

**2. Inventory Management**
Low demand or idle stock like 1985 Toyota Supra, 1966 Shelby Cobra 427/c should be replace with high demand fast selling products like 1968 Ford Mustang and 1960 Gold star DBD34.

**3. Warehouse storage optimization:**
The warehouse b stores more products compared to others. Hence, stock from this warehouse should be distributed to low traffic warehouse like South (b) for optimum space utilization.

**4. Customers retention strategy**
- Special focus should be given to high values customers and countries with most customers for better customer experience
- We must find better ways to sell product in regions with low customer base.

**5. Sales representatives training and improvement**
- Incentives and bonus should be given to high performing sales rep with higher customer base and high sale value.
- Trainings and performance improvement programmes should be arranged for low efficiency sales reps.
