# SQL-RETAIL-SALES-ANALYSIS-PROJECT

## Project Overview
This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore,
clean, and analyze retail sales data. The project involves using already made data to performing exploratory data analysis (EDA),
and answering specific business questions through SQL queries.

## Objectives
1. **Importing csv files**: Using the import wizard to import all my csv file to my database schemas.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3.**Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4.**Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

# Project Structure
1. # Database Setup
+ Database Setup: The project starts by importing all data csv files name `Customer`,`Orders`,`Products`
all linked by together.
+ Tables Sturcture: `Customers` table has a column name `customer_id` which is the primary key to `Customers`
and the foregin key to in the `Orders`, `Products` has a primary key `product_id` which is the foregin key in the `Orders`.


```sql
USE GITHUB_PROJECT;
SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;
SELECT * FROM PRODUCTS;
```

### 2. Data Exploration & Cleaning
```sql

```
- **Record Count**: Determine the total number of records in the dataset.
```sql
SELECT COUNT(*) FROM CUSTOMERS;
SELECT COUNT(*)  FROM ORDERS;
SELECT COUNT(*)  FROM PRODUCTS;
```
- **Customer Count**: Find out how many unique customers are in the dataset.
```sql
SELECT COUNT(DISTINCT CUSTOMER_ID) FROM CUSTOMERS;
```
- **Category Count**: Identify all unique product categories in the dataset.
```sql
SELECT DISTINCT category FROM products;
```
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
```sql
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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:
**Chaging date format from STR_TO_DATE**
```sql
UPDATE orders
SET order_date = STR_TO_DATE(order_date, '%d/%m/%Y');
select year(order_date) from orders;
```

1. **Write a SQL query to calculate the total sales (total_sale) for each category:**
```sql
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
```

2. **Write a SQL query to calculate Total revenue Per year**:
```sql
SELECT
	YEAR(ORDER_DATE) AS `YEAR`,
    ROUND(SUM(SALES),2) AS TOTALSALES
FROM 	
	ORDERS 
GROUP BY
	`YEAR`
ORDER BY 
	TOTALSALES DESC;
```

3. **Write a SQL query to calculate top 10 selling sub-category products.**:
```sql
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
WHERE `RANK` <=10
```

4. **Write a SQL query to find top 15 customers who spent the most, and provide their details.**:
```sql
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
```

5. **Write a SQL query to calculate monthly sales trend**:
```sql
SELECT 
  DATE_FORMAT(order_date, '%Y/%m') AS month, 
  ROUND(SUM(SALES),1) AS monthly_revenue 
FROM orders 
GROUP BY month 
ORDER BY month;
```

6. **Write a SQL query to find the best performing country**:
```sql
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
```

7. **Write a SQL query to find which products have never been purchased?**:
```sql
SELECT p.product_name 
FROM products p 
LEFT JOIN orders o ON p.product_id = o.product_id 
WHERE o.order_id IS NULL;
```

8. **Write a SQL query to find top 20 customers with the most orders**:
```sql
SELECT *
FROM (
  SELECT customer_id,
  COUNT(order_id) as CTNoFOrders,
  ROW_NUMBER() OVER(ORDER BY COUNT(order_id)DESC)`RANK`
  FROM orders 
  GROUP BY customer_id )T
  Where `RANK`<= 20;
```

9. **Write a SQL query to find the top 5 customers per country.**:
```sql
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
SELECT * FROM TOP_CTE WHERE `RANK` <=5
```

10. **Write a SQL query calculate the top 5 selling products**:
```sql
SELECT p.product_name, SUM(o.quantity) AS total_sold 
FROM orders o 
JOIN products p ON o.product_id = p.product_id 
GROUP BY p.product_name 
ORDER BY total_sold DESC 
LIMIT 5;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various countries, with sales distributed across different
 categories .
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and years.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts,data cleaning, exploratory data analysis,
and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior,
and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: 
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - David Fashakin

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles.

