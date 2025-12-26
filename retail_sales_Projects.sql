
CREATE TABLE retail_sales_clean AS
SELECT DISTINCT *
FROM sql_project_p1.retail_sales;

TRUNCATE TABLE sql_project_p1.retail_sales;

INSERT INTO sql_project_p1.retail_sales
SELECT * FROM retail_sales_clean;

DROP TABLE retail_sales_clean;

select * from sql_project_p1.retail_sales;


select * from retail_sales;

alter table sql_project_p1.retail_sales
rename column ï»¿transactions_id to transation_id;

select * from retail_sales
where
	transation_id is null
    or
    sale_date is null
    or
    sale_time is null
    or
    customer_id is null
    or 
    gender is null
    or
    age is null
    or
    category is null
    or
	quantity is null
    or
    price_per_unit is null
    or
    cogs is null
    or
    total_sale is null;
    
    -- data explorartion
    
    -- How many sales we have ?
    select count(*) as total_sales from retail_sales;
    
-- how many unique costumer we have ?
    select count(distinct customer_id) as total_sales from retail_sales;
    
-- how many category we have ?
    select distinct category  from retail_sales;
    
    -- Data Analysis & Business key Problems & Answer
 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
   
 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
    
select * 
from retail_sales
where sale_date = 2022-12-16;

DESC retail_sales;
ALTER TABLE retail_sales
MODIFY sale_date DATE,
MODIFY sale_time TIME;

ALTER TABLE retail_sales
ADD COLUMN sale_time_new TIME;

SET SQL_SAFE_UPDATES = 0;

UPDATE retail_sales
SET sale_time_new = STR_TO_DATE(sale_time, '%H:%i:%s');

SET SQL_SAFE_UPDATES = 1;


ALTER TABLE retail_sales
DROP COLUMN sale_time;

ALTER TABLE retail_sales
CHANGE sale_time_new sale_time TIME;

SET SQL_SAFE_UPDATES = 0;

UPDATE retail_sales
SET sale_date_new = STR_TO_DATE(sale_date, '%d-%m-%y');

SET SQL_SAFE_UPDATES = 1;

CREATE TABLE retail_sales_csv (
  transactions_id INT PRIMARY KEY,
  sale_date TEXT
);

ALTER TABLE retail_sales
add COLUMN sale_date date;

ALTER TABLE retail_sales
RENAME COLUMN transation_id TO transactions_id;


UPDATE retail_sales as r
JOIN retail_sales_csv as c
ON r.transactions_id = c.transactions_id
SET r.sale_date = STR_TO_DATE(c.sale_date, '%d-%m-%Y')
WHERE c.sale_date LIKE '__-__-____';

drop table retail_sales_csv;

 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

select * 
from retail_sales
where sale_date = '2022-12-16';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

select	* from retail_sales
where category = "clothing"
and	quantity > 3
and sale_date between '2022-11-01' and '2022-11-30';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category, 
SUM(total_sale) as total_sales
from retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
round(avg(age),2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * 
from retail_sales
where total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select 
gender,
category,
count(transactions_id) as total_transactions_id
from retail_sales
group by gender,category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select year, month, avg_monthly_sales
from (

		select 
				Year(sale_date) as year,
				MONTH(sale_date) as month,	
				avg(total_sale) as avg_monthly_sales,
                rank() over (
                partition by year(sale_date)
                order by avg(total_sale) desc
							) as rnk
		from retail_sales
		group by Year(sale_date),Month(sale_date)
        ) as t
        where rnk = 1 ;
	
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select 
	customer_id,
    sum(total_sale) as total_sales
 from retail_sales
 group by 1 
 order by 2 desc
 limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select 
	 count(distinct(customer_id)) as unique_id,
    category
 from retail_sales
 group by  category;
 
 
 -- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
 
 
select 
	case
		when hour(sale_time)<= 12 then 'Morning'
        when hour(sale_time)>12 and hour(sale_time) <17 Then 'Afternoon'
        else 'Evening'
        end as Shift,
       count(transactions_id) as 	Number_of_orders
       from retail_sales
       group by shift;
        
        -- End This Project....