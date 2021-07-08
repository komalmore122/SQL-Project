/*--------------------------------------------------------------SQL PROJECT - 2---------------------------------------------------------------------*/

/*----------------------------------------------------------KOMAL MORE - APR BATCH------------------------------------------------------------------*/

/*------------------------------------------------------Task 1 - Understanding the Data-------------------------------------------------------------*/


/* 1) Describe the data in hand in your own words. */

1. cust_dimen : Details of all the customers
- cust_dimen table contains the following columns:
    
        Customer_Name (TEXT) : Name of the customer
        Province (TEXT) : Province of the customer
        Region (TEXT) : Region of the customer
        Customer_Segment (TEXT) : Segment of the customer
        Cust_id (TEXT) : Unique Customer ID
        
2. market_fact : Details of every order item sold
- market_fact table contains the following columns:
    
        Ord_id (TEXT) : Order ID of Product
        Prod_id (TEXT) : Prod ID of Respective Product
        Ship_id (TEXT) : Shipment ID Respective Product
        Cust_id (TEXT) : Customer ID Respective Product
        Sales (DOUBLE) : Sales from the Item sold
        Discount (DOUBLE) : Discount on the Item sold
        Order_Quantity (INT) : Order Quantity of the Item sold
        Profit (DOUBLE) : Profit from the Item sold
        Shipping_Cost (DOUBLE) : Shipping Cost of the Item sold
        Product_Base_Margin (DOUBLE) : Product Base Margin on the Item sold
        
3. orders_dimen: Details of every order placed
- order_dimen table contains the following columns:

        Order_ID (INT) : Order ID Respective Product
        Order_Date (TEXT) : Order Date Respective Product
        Order_Priority (TEXT) : Priority of the Order
        Ord_id (TEXT) : Order ID Alphanumeric
	
4. prod_dimen: Details of product category and sub category
- prod_dimen table contains the following columns:

        Product_Category (TEXT) : Product Category
        Product_Sub_Category (TEXT) : Product Sub Category
        Prod_id (TEXT) : Unique Product ID
	
5. shipping_dimen: Details of shipping of orders
- shipping_dimen table contains the following columns:

        Order_ID (INT) : Order ID
        Ship_Mode (TEXT) : Shipping Mode
        Ship_Date (TEXT) : Shipping Date
        Ship_id (TEXT) : Unique Shipment ID
        
        
/* 2) Identify and list the Primary Keys and Foreign Keys for this dataset provided to you
      (In case you don’t find either primary or foreign key, then specially mention this in your answer)*/

1. cust_dimen 
        Primary Key : Cust_id
        Foreign Key : NA
	
2. market_fact
		Primary Key : NA
        Foreign Key : Ord_id, Prod_id, Ship_id, Cust_id
	
3. orders_dimen
		Primary Key : Ord_id
        Foreign Key : NA
	
4. prod_dimen
		Primary Key : Prod_id
        Foreign Key : NA
	
5. shipping_dimen
		Primary Key : Ship_id
        Foreign Key : Order_ID
        
/*--------------------------------------------------Task 2 - Basic & Advanced Analysis-------------------------------------------------------------*/ 

CREATE SCHEMA superstores;

USE superstores;

/* 1) Write a query to display the Customer_Name and Customer Segment using alias name “Customer Name", "Customer Segment" from table Cust_dimen.*/

SELECT Customer_Name AS 'Customer Name', Customer_Segment AS 'Customer Segment'
FROM Cust_dimen;

/* 2) Write a query to find all the details of the customer from the table cust_dimen order by desc.*/

SELECT *
FROM cust_dimen ORDER BY Customer_Name DESC;

/* 3) Write a query to get the Order ID, Order date from table orders_dimen where ‘Order Priority’ is high.*/

SELECT Order_ID, Order_Date
FROM orders_dimen
WHERE Order_Priority LIKE('High');

/* 4) Find the total and the average sales (display total_sales and avg_sales)*/

SELECT SUM(sales) AS 'total_sales', AVG(sales) AS 'avg_sales'
FROM market_fact;

/* 5) Write a query to get the maximum and minimum sales from maket_fact table.*/

SELECT MAX(sales) AS 'maximum sales', MIN(sales) AS 'minimum sales'
FROM market_fact;

/* 6) Display the number of customers in each region in decreasing order of no_of_customers. The result should contain columns Region, no_of_customers.*/

SELECT region, COUNT(*) AS no_of_customers
FROM cust_dimen GROUP BY region ORDER BY no_of_customers DESC;

/* 7) Find the region having maximum customers (display the region name and max(no_of_customers)*/

SELECT region, COUNT(Cust_id) AS 'no_of_customers'
FROM cust_dimen GROUP BY region ORDER BY no_of_customers DESC LIMIT 1;

/* 8) Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the number of tables purchased 
	  (display the customer name, no_of_tables purchased)*/

SELECT customer_name C, COUNT(*) no_of_tables_purchased
FROM market_fact AS m
INNER JOIN cust_dimen c ON m.cust_id  = c.cust_id
WHERE c.region = 'atlantic' 
AND m.prod_id = (SELECT prod_id
				 FROM prod_dimen
				 WHERE product_sub_category = 'tables')
GROUP BY m.cust_id, c.customer_name;

/* 9) Find all the customers from Ontario province who own Small Business. (display the customer name, no of small business owners)*/

SELECT Customer_Name, COUNT(Customer_Segment) AS 'no of small business owners'
FROM cust_dimen
WHERE Customer_Segment = 'SMALL BUSINESS' AND Province = 'ONTARIO' GROUP BY Customer_Name;

/* 10) Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products sold)*/

SELECT prod_id AS product_id, COUNT(*) AS no_of_products_sold
FROM market_fact GROUP BY prod_id ORDER BY no_of_products_sold DESC;

/* 11) Display product Id and product sub category whose produt category belongs to Furniture and Technlogy. 
       The result should contain columns product id, product sub category.*/

SELECT Prod_Id AS 'product id', Product_Sub_Category AS 'product sub category'
FROM prod_dimen
WHERE Product_Category = 'FURNITURE' OR Product_Category = 'TECHNOLOGY';

/* 12) Display the product categories in descending order of profits 
       (display the product category wise profits i.e. product_category, profits)*/

SELECT p.product_category, SUM(profit) AS profits
FROM market_fact m
INNER JOIN prod_dimen p ON m.prod_id = p.prod_id GROUP BY p.product_category ORDER BY profits DESC;

/* 13) Display the product category, product sub-category and the profit within each subcategory in three columns.*/

SELECT p.Product_Category, p.Product_Sub_Category, m.profit
FROM market_fact AS m
INNER JOIN prod_dimen AS p ON m.prod_id = p.prod_id GROUP BY Product_Sub_Category;

/* 14) Display the order date, order quantity and the sales for the order.*/

SELECT o.Order_Date, m.Order_Quantity, m.Sales
FROM market_fact AS m
INNER JOIN orders_dimen AS o ON m.ord_id = o.ord_id  ORDER BY Order_Date;

/* 15) Display the names of the customers whose name contains the 
       i) Second letter as ‘R’
       ii) Fourth letter as ‘D’ */
       
SELECT Customer_Name
FROM cust_dimen
WHERE Customer_Name LIKE '_R%' OR Customer_Name LIKE '___D%';

/* 16) Write a SQL query to to make a list with Cust_Id, Sales, Customer Name and their region where sales are between 1000 and 5000 */

SELECT c.Cust_Id, m.Sales, c.Customer_Name, c.Region
FROM cust_dimen AS c
INNER JOIN market_fact AS m ON m.Cust_id = c.Cust_id 
WHERE Sales BETWEEN 1000 AND 5000 ORDER BY Sales;

/* 17) Write a SQL query to find the 3rd highest sales.*/

SELECT a.cust_id, a.sales, a.rnk AS "rank"
FROM (SELECT cust_id, sum(sales) sales, ROW_NUMBER() OVER (ORDER BY sum(sales) DESC ) AS rnk
	  FROM market_fact GROUP BY cust_id ) AS a
WHERE a.rnk = 3;

/* 18) Where is the least profitable product subcategory shipped the most? For the least profitable product sub-category, display the region-wise 
       no_of_shipments and the profit made in each region in decreasing order of profits (i.e. region, no_of_shipments, profit_in_each_region) .
	   → Note: You can hardcode the name of the least profitable product subcategory */
 
SELECT p.product_sub_category, c.region, COUNT(ship_id) AS no_of_shipments, SUM(m.profit) AS profit_in_each_region
FROM market_fact m
INNER JOIN cust_dimen c ON m.Cust_id = c.Cust_id
INNER JOIN prod_dimen p ON m.prod_id = p.prod_id 
WHERE p.product_sub_category = (SELECT p.product_sub_category 
	                            FROM market_fact m
	                            JOIN prod_dimen p ON m.prod_id = p.prod_id GROUP BY p.product_sub_category  ORDER BY SUM(m.profit) LIMIT 1)  
GROUP BY c.region 
ORDER BY SUM(m.profit);