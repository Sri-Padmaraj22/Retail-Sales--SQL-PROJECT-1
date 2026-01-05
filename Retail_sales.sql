--SQL Retail Sales Analysis -1

--Create table
DROP TABLE IF EXISTS retails_sales;
CREATE TABLE retails_sales
	(transactions_id INT PRIMARY KEY, 
	 sale_date DATE,
	 sale_time TIME,
	 customer_id INT,	
	 gender VARCHAR(15),
	 age INT,
	 category VARCHAR(15),	
	 quantiy INT,
	 price_per_unit FLOAT,	
	 cogs FLOAT,
	 total_sale FLOAT
    );
SELECT * FROM retails_sales
LIMIT 10;


--DATA CLEANING
SELECT * FROM retails_sales
WHERE 
		transactions_id IS NULL
		OR 
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR
		gender IS NULL
		OR
		category IS NULL
		OR
		quantity IS NULL
		OR 
		price_per_unit IS NULL
		OR
		cogs IS NULL
		OR
		total_sale is null;

DELETE FROM retails_sales
WHERE 
	transactions_id IS NULL
		OR 
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR
		gender IS NULL
		OR
		category IS NULL
		OR
		quantity IS NULL
		OR 
		price_per_unit IS NULL
		OR
		cogs IS NULL
		OR
		total_sale is null;
		
----DATA EXPLORATION

--How many sales we have?
SELECT COUNT(*) as total_sale FROM retails_sales;

--How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_customers FROM retails_sales;

SELECT DISTINCT category FROM retails_sales;

--DATA ANALYSIS & BUSINESS KEY PROBLEMS AND ANSWERS

-- Q.1: Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT 
    * 
FROM retails_sales
WHERE sale_date='2022-11-05';

-- Q.2: Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.
SELECT 
    *
FROM retails_sales
WHERE category='Clothing'
 AND 
 TO_CHAR(sale_date,'YYYY-MM')='2022-11'
 AND 
 quantity>=4
GROUP BY 1

-- Q.3: Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
 category,
 SUM(total_sale) as net_sale,
 COUNT(*) as total_orders
FROM retails_sales
GROUP BY category

-- Q.4: Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
ROUND(AVG(age),2) as average_age
FROM retails_sales
WHERE category='Beauty';

--Q.5: Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT 
*
FROM retails_sales
WHERE total_sale>1000;

--Q.6: Write a SQL query to find the total number of transaction(transaction_id) made by each gender in each category.
SELECT
	gender,
	category,
	COUNT(*) as total_transactions
FROM retails_sales
GROUP BY gender,category
ORDER BY 2

--Q.7: Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

SELECT year,month,avg_sale 
FROM
(
	SELECT
		EXTRACT(YEAR FROM sale_date) AS year,
	    EXTRACT(MONTH FROM sale_date) AS month,
	    AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC ) AS RANK
	FROM retails_sales
	GROUP BY 1,2
) as table1 
WHERE RANK=1;
--ORDER BY 1,3 DESC

--Q.8: Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retails_sales
GROUP BY 1
ORDER BY total_sales DESC
LIMIT 5;

--Q.9: Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	category,
	COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retails_sales
GROUP BY 1;

--Q.10: Write a SQL query to create each shift and number of orders (Example: Morning<12, Afternoon Between 12 & 17 , Evening>17)
WITH hourly_sale
AS
(
	SELECT
		*,
		CASE 
			WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END as shift
	FROM retails_sales
)

SELECT 
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

--END OF PROJECT


