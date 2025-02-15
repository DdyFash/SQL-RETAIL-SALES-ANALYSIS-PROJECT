-- CUSTOMER ANALYSIS PROJECT
USE GITHUB_PROJECT;
SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;
SELECT * FROM PRODUCTS;

-- 2 DATA EXPLRATIONS & CLEANING
-- RECORD COUNT: Determine the total number of records in the dataset
-- Customer Count: Find out how many unique customers are in the dataset.
SELECT COUNT(*) FROM CUSTOMERS;
SELECT COUNT(*)  FROM ORDERS;
SELECT COUNT(*)  FROM PRODUCTS;

SELECT COUNT(DISTINCT CUSTOMER_ID) FROM CUSTOMERS;
-- Category Count: Identify all unique countries and region in the dataset.
SELECT COUNT(distinct COUNTRY) FROM CUSTOMERS;


SELECT COUNT(distinct CATEGORY) FROM PRODUCTS;
SELECT COUNT(distinct SUB_CATEGORY) FROM PRODUCTS;

-- Null Value Check: Check for any null values in the dataset and delete records with missing data.
SELECT * FROM CUSTOMERS
WHERE 
	CUSTOMER_ID IS NULL OR FIRST_NAME IS NULL OR LAST_NAME IS NULL OR POSTAL_CODE IS NULL
    OR CITY IS NULL OR COUNTRY IS NULL OR SCORE IS NULL;
SELECT * FROM ORDERS
WHERE
	ORDER_ID IS NULL OR CUSTOMER_ID IS NULL OR PRODUCT_ID IS NULL OR ORDER_DATE IS NULL
    OR SHIPPING_DATE IS NULL OR SALES IS NULL OR QUANTITY IS NULL OR DISCOUNT IS NULL OR PROFIT IS NULL
    OR UNIT_PRICE IS NULL;
SELECT * FROM PRODUCTS
WHERE
	PRODUCT_ID IS NULL OR PRODUCT_NAME IS NULL OR CATEGORY IS NULL OR SUB_CATEGORY IS NULL;
    
-- 3 DATA ANALYSIS AND FINDINGS
-- Write a SQL query to calculate the total sales (total_sale) for each category:
UPDATE orders
SET order_date = STR_TO_DATE(order_date, '%d/%m/%Y');
select year(order_date) from orders;
SELECT 
	P. CATEGORY,
    ROUND(SUM(O.SALES),2) AS TOTALSALES
FROM ORDERS AS O
RIGHT JOIN 
	PRODUCTS AS P
ON 
	O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY 
	P. CATEGORY
ORDER BY 
	TOTALSALES DESC;

-- Total revenue Per year
SELECT
	YEAR(ORDER_DATE) AS `YEAR`,
    ROUND(SUM(SALES),2) AS TOTALSALES
FROM 	
	ORDERS 
GROUP BY
	`YEAR`
ORDER BY 
	TOTALSALES DESC;
 
 -- TOP 10 SELLING SUB-CATEGORY
 WITH RANK_CTE AS(
 SELECT 
	P.SUB_CATEGORY,
    ROUND(SUM(O.SALES),2) TOTALSALES,
ROW_NUMBER() OVER(ORDER BY ROUND(SUM(O.SALES),2) DESC) AS `RANK`
FROM ORDERS AS O
RIGHT JOIN 	PRODUCTS AS P
ON O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY 
	P.SUB_CATEGORY)

SELECT * FROM RANK_CTE
WHERE `RANK` <=10;

-- TOP 15 CUSTOMERS WHO SPENT THE MOST, AND PROVIDE THIER DETAILS
SELECT * FROM (
SELECT 
	C.CUSTOMER_ID,
    C.FIRST_NAME,
    C.LAST_NAME,
    ROUND(SUM(O.SALES),2) TOTALSALES,
RANK() OVER(ORDER BY ROUND(SUM(O.SALES),2)DESC)`RANK`
FROM CUSTOMERS AS C
LEFT JOIN ORDERS AS O
ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY 	
	C.CUSTOMER_ID,C.FIRST_NAME,C.LAST_NAME)T
WHERE `RANK` <= 15;
    
-- Monthly sales trend
SELECT 
  DATE_FORMAT(order_date, '%Y/%m') AS month, 
  ROUND(SUM(SALES),1) AS monthly_revenue 
FROM orders 
GROUP BY month 
ORDER BY month;

-- Best Performing country
SELECT 	
	C.COUNTRY,
    ROUND(SUM(O.SALES),1) AS TOTALSALES
FROM CUSTOMERS C
LEFT JOIN ORDERS O
ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY
	C.COUNTRY
ORDER BY
	TOTALSALES;


-- Products Never Ordered: Which products have never been purchased?
SELECT p.product_name 
FROM products p 
LEFT JOIN orders o ON p.product_id = o.product_id 
WHERE o.order_id IS NULL;
-- Repeat Purchase Rate: Top 20 customers With the most orders
SELECT *
FROM (
  SELECT customer_id,
  COUNT(order_id) as CTNoFOrders,
  ROW_NUMBER() OVER(ORDER BY COUNT(order_id)DESC)`RANK`
  FROM orders 
  GROUP BY customer_id )T
  Where `RANK`<= 20;
  
-- Customer Anlaysis: Show the top 5 customers per country
WITH TOP_CTE AS(
SELECT 
	C.CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    COUNTRY,
    ROUND(SUM(O.SALES),1) TOTALSALES,
ROW_NUMBER() OVER(PARTITION BY COUNTRY ORDER BY ROUND(SUM(O.SALES),1)DESC)`RANK`
FROM CUSTOMERS AS C
RIGHT JOIN ORDERS AS O
ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME, COUNTRY )
SELECT * FROM TOP_CTE WHERE `RANK` <=5;
-- Write a SQL query calculate the top 5 selling products
SELECT p.product_name, SUM(o.quantity) AS total_sold 
FROM orders o 
JOIN products p ON o.product_id = p.product_id 
GROUP BY p.product_name 
ORDER BY total_sold DESC 
LIMIT 5;



    
 
 
	
    




























