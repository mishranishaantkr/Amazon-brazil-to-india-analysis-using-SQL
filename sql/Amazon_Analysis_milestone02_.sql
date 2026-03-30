------------------------------------------------------------------------------------------------------------------------------------------------
													-- ANALYSIS - I --
------------------------------------------------------------------------------------------------------------------------------------------------
-- QUESTION 1: To simplify its financial reports, Amazon India needs to standardize payment values.
/*
Round the average payment values to integer (no decimal) for each payment type and display the results sorted in ascending order.
Output: payment_type, rounded_avg_payment
*/

         -- Reference Table -- 
SELECT * FROM amazon_brazil.payments;

			-- QUERY --

SELECT  payment_type ,
		ROUND(AVG(payment_value),0) AS rounded_avg_payment
		
FROM 	amazon_brazil.payments

GROUP BY payment_type 

ORDER BY rounded_avg_payment ASC;

	
-- QUESTION 2: To refine its payment strategy, Amazon India wants to know the distribution of orders by payment type.
/*
Calculate the percentage of total orders for each payment type, round to one decimal place, and display them in descending order
Output: payment_type, percentage_orders
*/


-- Reference Table -- 
SELECT * FROM amazon_brazil.payments;

			-- QUERY --

SELECT
    payment_type,
    ROUND(COUNT(payment_type) * 100.0 / (SELECT COUNT(*) FROM amazon_brazil.payments), 1) AS percentage_orders
	
FROM amazon_brazil.payments

GROUP BY payment_type

ORDER BY percentage_orders DESC;




-- QUESTION 3: Amazon India seeks to create targeted promotions for products within specific price ranges. 
/*
Identify all products priced between 100 and 500 BRL that contain the word 'Smart' in their name.
Display these products, sorted by price in descending order. 
Output: product_id, price
*/

		-- Reference Table --
SELECT * FROM amazon_brazil.product
SELECT * FROM amazon_brazil.order_items


			-- QUERY --
			
SELECT 	pdt.product_id,
		odr_i.price
		-- pdt.product_category_name : uncomment to check product_category_name contains smart or not
		
FROM 	amazon_brazil.product AS pdt
LEFT JOIN amazon_brazil.order_items AS odr_i
			ON pdt.product_id = odr_i.product_id

WHERE 	pdt.product_category_name LIKE '%smart%'
		AND odr_i.price BETWEEN 100 AND 500

ORDER BY odr_i.price DESC;





-- QUESTION 4: To identify seasonal sales patterns, Amazon India needs to focus on the most successful months.
/*
Determine the top 3 months with the highest total sales value, rounded to the nearest integer.
Output: month, total_sales
*/


				-- Reference Table --
SELECT * FROM amazon_brazil.orders		--(order_purchase_timestamp)
SELECT * FROM amazon_brazil.order_items --(price)


					-- QUERY --
					
SELECT
		TO_CHAR(ord.order_purchase_timestamp, 'Month') AS month,
		ROUND(SUM(ord_i.price),0) AS total_sales
	
FROM amazon_brazil.orders AS ord

LEFT JOIN amazon_brazil.order_items AS ord_i 
			ON ord.order_id = ord_i.order_id

GROUP BY TO_CHAR(ord.order_purchase_timestamp, 'Month')
		

ORDER BY total_sales DESC

LIMIT 3;





-- QUESTION 5: Amazon India is interested in product categories with significant price variations. 
/*
Find categories where the difference between the maximum and minimum product prices is greater than 500 BRL.
Output: product_category_name, price_difference
*/

				-- Reference Table --
SELECT * FROM amazon_brazil.product;		--(product_category_name)
SELECT * FROM amazon_brazil.order_items;    --(price)

				-- QUERY --

SELECT 
		pdct.product_category_name,
		ROUND((MAX(ord_i.price)-MIN(ord_i.price)),0) AS price_difference
		
		
FROM 	amazon_brazil.order_items AS ord_i

LEFT JOIN amazon_brazil.product AS pdct
			ON ord_i.product_id = pdct.product_id

GROUP BY pdct.product_category_name

HAVING  (MAX(ord_i.price)-MIN(ord_i.price)) > 500

ORDER BY price_difference DESC;




-- QUESTION 6: To enhance the customer experience, Amazon India wants to find which payment types have the most consistent transaction amounts. 
/*
Identify the payment types with the least variance in transaction amounts, sorting by the smallest standard deviation first.
Output: payment_type, std_deviation
*/


			-- Reference Table --
SELECT * FROM amazon_brazil.payments;

			-- QUERY --
				
SELECT  
		pymt.payment_type, 
		ROUND(STDDEV_SAMP(pymt.payment_value),2) AS std_deviation

FROM 	amazon_brazil.payments AS pymt

GROUP BY pymt.payment_type

ORDER BY std_deviation ASC;





-- QUESTION 7: Amazon India wants to identify products that may have incomplete name in order to fix it from their end.
/*
Retrieve the list of products where the product category name is missing or contains only a single character.
Output: product_id, product_category_name
*/


		-- Reference Table --
SELECT * FROM amazon_brazil.product;

			-- QUERY --
			
SELECT	
		pdct.product_id,
		pdct.product_category_name 

FROM 	amazon_brazil.product AS pdct

WHERE 	pdct.product_category_name IS NULL 
		OR pdct.product_category_name LIKE '_'

ORDER BY pdct.product_category_name ASC;








------------------------------------------------------------------------------------------------------------------------------------------------
													-- ANALYSIS - II -- 
------------------------------------------------------------------------------------------------------------------------------------------------

-- QUESTION 1: Amazon India wants to understand which payment types are most popular across different 
 			-- order value segments (e.g., low, medium, high).
/*
Segment order values into three ranges: orders less than 200 BRL, between 200 and 1000 BRL, and over 1000 BRL.
Calculate the count of each payment type within these ranges and display the results in descending order of count
Output: order_value_segment, payment_type, count
*/
    -- Reference Table --
SELECT * FROM amazon_brazil.payments
					
			
			-- QUERY --


SELECT 
		CASE 																-- case for order value segmentation
			WHEN pymt.payment_value < 200 THEN 'low'
			WHEN pymt.payment_value BETWEEN 200 AND 1000 THEN 'medium'
			ELSE 'high'
		END AS order_value_segment,
		pymt.payment_type,
		COUNT(pymt.payment_type) AS count
		
FROM 	amazon_brazil.payments AS pymt

GROUP BY   order_value_segment,
		   pymt.payment_type

ORDER BY count DESC;
			
		

-- QUESTION 2: Amazon India wants to analyse the price range and average price for each product category.
/*
Calculate the minimum, maximum, and average price for each category, and list them in descending order by the average price.
Output: product_category_name, min_price, max_price, avg_price
*/
    -- Reference Table --
SELECT * FROM amazon_brazil.order_items
SELECT * FROM amazon_brazil.product
					
			
			-- QUERY --

SELECT 
		pdct.product_category_name,
		ROUND(MIN(ord_i.price),2) AS min_price,
		ROUND(MAX(ord_i.price),2) AS max_price,
		ROUND(AVG(ord_i.price),2) AS avg_price

FROM  amazon_brazil.order_items AS ord_i

LEFT JOIN amazon_brazil.product AS pdct
			ON ord_i.product_id = pdct.product_id

GROUP BY  pdct.product_category_name

ORDER BY avg_price DESC;




-- QUESTION 3: Amazon India wants to identify the customers who have placed multiple orders over time.
/*
Find all customers with more than one order, and display their customer unique IDs along with the total number of orders they have placed.
Output: customer_unique_id, total_orders
*/
    -- Reference Table --
SELECT * FROM amazon_brazil.customers
SELECT * FROM amazon_brazil.orders
					
			
			-- QUERY --

SELECT 
		cust.customer_unique_id,
		COUNT(ord.order_id) AS total_orders

FROM 	amazon_brazil.customers AS cust

LEFT JOIN amazon_brazil.orders AS ord
			ON cust.customer_id = ord.customer_id

GROUP BY cust.customer_unique_id

HAVING COUNT(cust.customer_id) > 1

ORDER BY total_orders DESC;





-- QUESTION 4: Amazon India wants to categorize customers into different types
			 --('New – order qty. = 1' ;  'Returning' –order qty. 2 to 4;  'Loyal' – order qty. >4) based on their purchase history. 
/*
Use a temporary table to define these categories and join it with the customers table to update and display the customer types.
Output: customer_unique_id, customer_type
*/
    -- Reference Table --
SELECT * FROM amazon_brazil.customers
SELECT * FROM amazon_brazil.orders
					
			
			-- QUERY --


SELECT 
		cust.customer_unique_id,                                        -- case for customer type segmentaion
		CASE 
			WHEN COUNT(cust.customer_id) = 1 THEN 'New'
			WHEN COUNT(cust.customer_id) BETWEEN 2 AND 4 THEN 'Returning'
			ELSE 'Loyal'
		END AS customer_type
		
FROM  amazon_brazil.customers AS cust

LEFT JOIN amazon_brazil.orders AS ord
			ON cust.customer_id = ord.customer_id

GROUP BY cust.customer_unique_id;





-- QUESTION 5: Amazon India wants to know which product categories generate the most revenue. 
/*
Use joins between the tables to calculate the total revenue for each product category. Display the top 5 categories.
Output: product_category_name, total_revenue
*/
    -- Reference Table --
SELECT * FROM amazon_brazil.order_items
SELECT * FROM amazon_brazil.product
SELECT * FROM amazon_brazil.payments	--FOR NETWORTH ONLY WE CAN CONSIDER THIS TABLE AS IT INCLUDES ALL CHARGES				
			
			-- QUERY --

-- Product revenue (per item) is calculated by order_items.price (net Revenue)
-- Total order payment (includes shipping etc.) is calculate by payments.payment_value

SELECT
    pdct.product_category_name,
    ROUND(SUM(ord_i.price), 2) AS total_revenue
	
FROM amazon_brazil.order_items AS ord_i

LEFT JOIN amazon_brazil.product AS pdct 
			ON ord_i.product_id = pdct.product_id
		
GROUP BY pdct.product_category_name
ORDER BY total_revenue DESC
LIMIT 5;







------------------------------------------------------------------------------------------------------------------------------------------------
													-- ANALYSIS - III -- 
------------------------------------------------------------------------------------------------------------------------------------------------

-- QUESTION 1: The marketing team wants to compare the total sales between different seasons.
/*
Use a subquery to calculate total sales for each season (Spring, Summer, Autumn, Winter) based on order purchase dates, and display the results. 
Spring is in the months of March, April and May. Summer is from June to August and Autumn is between September and November and rest months are Winter. 
Output: season, total_sales
*/
    -- Reference Table --
SELECT * FROM amazon_brazil.order_items
SELECT * FROM amazon_brazil.orders			
			
			-- QUERY --


SELECT 
        CASE																					-- case to define seasons
            WHEN EXTRACT(MONTH FROM ord.order_purchase_timestamp) IN (3,4,5) THEN 'Spring'
            WHEN EXTRACT(MONTH FROM ord.order_purchase_timestamp) IN (6,7,8) THEN 'Summer'
            WHEN EXTRACT(MONTH FROM ord.order_purchase_timestamp) IN (9,10,11) THEN 'Autumn'
            ELSE 'Winter'
        END AS season,
		ROUND(SUM(ord_i.price),0) AS total_sales
		
FROM amazon_brazil.orders AS ord

LEFT JOIN amazon_brazil.order_items AS ord_i
   			ON ord.order_id = ord_i.order_id
			   
GROUP BY season

ORDER BY total_sales DESC;






-- QUESTION 2: The inventory team is interested in identifying products that have sales volumes above the overall average. 
/*
Write a query that uses a subquery to filter products with a total quantity sold above the average quantity.
Output: product_id, total_quantity_sold
*/
    -- Reference Table --
SELECT * FROM amazon_brazil.order_items
		
			
			-- QUERY --

SELECT
    	product_id,
    	SUM(order_item_id) AS total_quantity_sold
FROM amazon_brazil.order_items
GROUP BY product_id
HAVING SUM(order_item_id) > (													
    							SELECT AVG(total_qty)							--subquery to get total qty per product_id
    							FROM 
								(
								 	SELECT product_id, 
			   							   SUM(order_item_id) AS total_qty
			   							   FROM amazon_brazil.order_items
        								   GROUP BY product_id
        
    							) AS subq
							)
ORDER BY total_quantity_sold DESC;







-- QUESTION 3: To understand seasonal sales patterns, the finance team is analysing the monthly revenue trends over the past year (year 2018). 
/*
Run a query to calculate total revenue generated each month and identify periods of peak and low sales.
"Export the data to Excel and create a graph to visually represent revenue changes across the months." 
Output: month, total_revenue
*/

    -- Reference Table --
SELECT * FROM amazon_brazil.order_items
SELECT * FROM amazon_brazil.orders			
			
			-- QUERY --


SELECT
    	TO_CHAR(ord.order_purchase_timestamp, 'Month') AS month,  
    	ROUND(SUM(ord_i.price), 2) AS total_revenue						-- revenue = SUM (price of product * product sold)
																		-- dont't confuse it with sum of payment_vlaue as that inclues all tax and fares
FROM amazon_brazil.orders AS ord

JOIN amazon_brazil.order_items AS ord_i 
    	ON ord.order_id = ord_i.order_id
		
WHERE EXTRACT(YEAR FROM ord.order_purchase_timestamp) = '2018'

GROUP BY 1, 
		 EXTRACT(MONTH FROM ord.order_purchase_timestamp)         -- 1 here refers to the first selected column (month), so groups by "month name" also by "numeric month" extracted from the timestamp

ORDER BY EXTRACT(MONTH FROM ord.order_purchase_timestamp);		  -- Order final output by the numeric month








-- QUESTION 4: A loyalty program is being designed  for Amazon India. 
/*
Create a segmentation based on purchase frequency: ‘Occasional’ for customers with 1-2 orders, ‘Regular’ for 3-5 orders, and ‘Loyal’ for more than 5 orders. 
Use a CTE to classify customers and their count and generate a chart in Excel to show the proportion of each segment.
Output: customer_type, count
*/


    -- Reference Table --
SELECT * FROM amazon_brazil.customers
SELECT * FROM amazon_brazil.orders			
			
			-- QUERY --

WITH customer_segments AS (
    						SELECT
        						cust.customer_unique_id,
        						COUNT(ord.order_id) AS order_count,
        						CASE																--case for segmentation
            						 WHEN COUNT(ord.order_id) BETWEEN 1 AND 2 THEN 'Occasional'
            						 WHEN COUNT(ord.order_id) BETWEEN 3 AND 5 THEN 'Regular'
            						 ELSE 'Loyal'
        						END AS customer_type
    						FROM amazon_brazil.customers AS cust
						
    						LEFT JOIN amazon_brazil.orders AS ord 
										ON cust.customer_id = ord.customer_id
    						GROUP BY cust.customer_unique_id
							ORDER BY order_count DESC
						)

SELECT
    customer_type,
    COUNT(*) AS count
FROM customer_segments
GROUP BY customer_type
ORDER BY count DESC;






-- QUESTION 5: Amazon wants to identify high-value customers to target for an exclusive rewards program.  
/*
You are required to rank customers based on their average order value (avg_order_value) to find the top 20 customers.
Output: customer_id, avg_order_value, and customer_rank
*/


    -- Reference Table --
SELECT * FROM amazon_brazil.customers
SELECT * FROM amazon_brazil.orders			
SELECT * FROM amazon_brazil.payments   --payment_value : order value
			  
			-- QUERY --

SELECT
    	cust.customer_unique_id AS customer_id,									 -- One person can have  → multiple customer_id values but same customer_unique_id
    	ROUND(AVG(pymt.payment_value), 0) AS avg_order_value,
    	RANK() OVER (ORDER BY AVG(pymt.payment_value) DESC) AS customer_rank

FROM amazon_brazil.customers AS cust

INNER JOIN amazon_brazil.orders AS ord 
    		ON cust.customer_id = ord.customer_id
INNER JOIN amazon_brazil.payments AS pymt 
    		ON ord.order_id = pymt.order_id
        
GROUP BY cust.customer_unique_id
ORDER BY avg_order_value DESC
LIMIT 20;





-- QUESTION 6: Amazon wants to analyze sales growth trends for its key products over their lifecycle.
/*
Calculate monthly cumulative sales for each product from the date of its first sale. 
Use a recursive CTE to compute the cumulative sales (total_sales) for each product month by month.
Output: product_id, sale_month, and total_sales
*/


    -- Reference Table --
SELECT * FROM amazon_brazil.order_items
SELECT * FROM amazon_brazil.orders			
			
			-- QUERY --


WITH monthly_sales AS (																	--CTE to get product_id ,sales month and monthly_sales 
    					SELECT
        						ord_i.product_id,
        						TO_CHAR(ord.order_purchase_timestamp, 'Month') AS sale_month,
        						SUM(ord_i.price) AS monthly_sales
    					FROM amazon_brazil.order_items AS ord_i
    					LEFT JOIN amazon_brazil.orders AS ord
        							ON ord_i.order_id = ord.order_id
    					GROUP BY ord_i.product_id, sale_month
					)

SELECT
    	product_id,
    	sale_month,
    	SUM(monthly_sales) OVER ( PARTITION BY product_id  ORDER BY sale_month ) AS total_sales
								
FROM monthly_sales
ORDER BY product_id, sale_month ASC;






-- QUESTION 7: To understand how different payment methods affect monthly sales growth, 
			  --Amazon wants to compute the total sales for each payment method and calculate the month-over-month growth rate for the past year (year 2018). 
/*
Write query to first calculate total monthly sales for each payment method, 
then compute the percentage change from the previous month.
Output: payment_type, sale_month, monthly_total, monthly_change.

*/


    -- Reference Table --
SELECT * FROM amazon_brazil.payments
SELECT * FROM amazon_brazil.orders			
			
			-- QUERY --


WITH monthly_sales AS (
												    -- Total sales per payment type per month in 2018
    					SELECT
        					 	pymt.payment_type,
        					 	TO_CHAR(ord.order_purchase_timestamp, 'Month') AS sale_month,				-- validation of year : put ('Month YYYY') to get year as well
        					 	ROUND(SUM(pymt.payment_value), 2) AS monthly_total
								 
    					FROM amazon_brazil.payments AS pymt
    					LEFT JOIN amazon_brazil.orders AS ord 
									ON pymt.order_id = ord.order_id
    					WHERE EXTRACT(YEAR FROM ord.order_purchase_timestamp) = 2018
    					GROUP BY pymt.payment_type, TO_CHAR(ord.order_purchase_timestamp, 'Month')   -- validation of year : put ('Month YYYY') to get year as well
					 )
					 
SELECT                          					-- month-over-month growth rate = (current Month - previous Month) / previous Month * 100
    payment_type,
    sale_month ,
    monthly_total,
    ROUND((monthly_total - LAG(monthly_total) OVER (PARTITION BY payment_type ORDER BY sale_month)) * 100.0
        / NULLIF(LAG(monthly_total) OVER (PARTITION BY payment_type ORDER BY sale_month), 0), 2) AS monthly_change       -- To avoid error in denominator of division by 0

FROM monthly_sales
ORDER BY payment_type, sale_month;






			