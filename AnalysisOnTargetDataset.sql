--Data type of all columns in the "customers" table.

SELECT column_name, data_type
FROM `Target_business_case`.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'customers';

--Get the time range between which the orders were placed.

SELECT 
  MIN(order_purchase_timestamp) AS first_order_date,
  MAX(order_purchase_timestamp) AS last_order_date
FROM `Target_business_case.orders`;

--Count the number of Cities and States in our dataset.

SELECT
  COUNT(DISTINCT geolocation_city) AS count_cities,
  COUNT(DISTINCT geolocation_state) AS count_states
FROM `Target_business_case.geolocation`;

--Is there a growing trend in the no. of orders placed over the past years?

SELECT 
  EXTRACT(YEAR FROM order_purchase_timestamp) AS year_of_order,
  EXTRACT(MONTH FROM order_purchase_timestamp) AS month_of_order,
  COUNT(order_id) AS no_of_orders
FROM `Target_business_case.orders`
GROUP BY year_of_order, month_of_order
ORDER BY year_of_order, month_of_order;

--Can we see some kind of monthly seasonality in terms of the no. of orders being placed?

SELECT 
  EXTRACT(MONTH FROM order_purchase_timestamp) AS month_of_order,
  COUNT(order_id) AS no_of_orders 
FROM `Target_business_case.orders`
GROUP BY month_of_order
ORDER BY month_of_order, no_of_orders DESC;

/* During what time of the day, do the Brazilian customers mostly place their orders? (Dawn, Morning, Afternoon or Night)
#0-6 hrs : Dawn
#7-12 hrs : Mornings
#13-18 hrs : Afternoon
#19-23 hrs : Night*/

SELECT
  CASE
    WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 0 AND 6
    THEN 'Dawn'
    WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 7 AND 12
    THEN 'Mornings'
    WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 13 AND 18
    THEN 'Afternoon'
    WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 19 AND 23
    THEN 'Night'
  END AS time_of_day,
  COUNT(DISTINCT order_id) AS no_of_unique_orders
FROM `Target_business_case.orders`
GROUP BY time_of_day
ORDER BY no_of_unique_orders DESC;

--Get the month on month no. of orders placed in each state.

SELECT
  c.customer_state,
  EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year_of_order,
  EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month_of_order,
  COUNT(DISTINCT o.order_id) AS no_of_orders
FROM `Target_business_case.orders` AS o
INNER JOIN `Target_business_case.customers` AS c
ON o.customer_id = c.customer_id
GROUP BY year_of_order, month_of_order, c.customer_state
ORDER BY c.customer_state, year_of_order, month_of_order;

--How are the customers distributed across all the states?

SELECT
  customer_state,
  COUNT(DISTINCT customer_id) AS no_of_customers
FROM `Target_business_case.customers`
GROUP BY customer_state
ORDER BY customer_state;

/* 4. Impact on Economy: Analyze the money movement by e-commerce by looking at order prices, freight and others.
      a. Get the % increase in the cost of orders from year 2017 to 2018 (include months between Jan to Aug only).
         You can use the "payment_value" column in the payments table to get the cost of orders.*/

WITH filter_cte AS (
  SELECT *
  FROM `Target_business_case.orders` AS o
  JOIN `Target_business_case.payments` AS p
  ON o.order_id = p.order_id
  WHERE EXTRACT(YEAR FROM o.order_purchase_timestamp) BETWEEN 2017 AND 2018
    AND EXTRACT(MONTH FROM o.order_purchase_timestamp) BETWEEN 1 AND 8
), yearwise_total AS (
  SELECT EXTRACT(YEAR FROM order_purchase_timestamp) AS Year,
    ROUND(SUM(payment_value),2) AS year_total
  FROM filter_cte
  GROUP BY Year
)

SELECT *,
  ROUND(((year_total - LAG(year_total) OVER(ORDER BY Year))/LAG(year_total) OVER(ORDER BY Year))*100, 2) AS Percent_increase
FROM yearwise_total
ORDER BY Year;

--  b. Calculate the Total & Average value of order price for each state.

SELECT
  c.customer_state AS State,
  ROUND(SUM(p.payment_value),2) AS total_value,
  ROUND(SUM(p.payment_value)/COUNT(DISTINCT p.order_id),2) AS average_value
FROM `Target_business_case.orders` AS o
INNER JOIN `Target_business_case.payments` AS p
ON o.order_id = p.order_id
INNER JOIN `Target_business_case.customers` AS c
ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY c.customer_state;

--  c. Calculate the Total & Average value of order freight for each state.

SELECT
  c.customer_state AS State,
  ROUND(SUM(oi.freight_value),2) AS total_value,
  ROUND(SUM(oi.freight_value)/COUNT(DISTINCT oi.freight_value),2) AS average_value
FROM `Target_business_case.orders` AS o
INNER JOIN `Target_business_case.order_items` AS oi
ON o.order_id = oi.order_id
INNER JOIN `Target_business_case.customers` AS c
ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY c.customer_state;


/* 5. Analysis based on sales, freight and delivery time.
      a. Find the no. of days taken to deliver each order from the order’s purchase date as delivery time.
        Also, calculate the difference (in days) between the estimated & actual delivery date of an order.
        Do this in a single query.

        You can calculate the delivery time and the difference between the estimated & actual delivery date using the given formula:
        time_to_deliver = order_delivered_customer_date - order_purchase_timestamp
        diff_estimated_delivery = order_estimated_delivery_date - order_delivered_customer_date  */

SELECT
  order_id,
  DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY) AS days_taken_to_deliver,
  DATE_DIFF(order_estimated_delivery_date, order_delivered_customer_date, DAY) AS diff_estimated_delivery 
FROM `Target_business_case.orders`
WHERE LOWER(order_status) = 'delivered';

--  b. Find out the top 5 states with the highest & lowest average freight value.
#------highest
SELECT
  c.customer_state AS State_high_avg_freight_val,
  ROUND(SUM(oi.freight_value)/COUNT(DISTINCT oi.order_id),2) AS average_value
FROM `Target_business_case.orders` AS o
INNER JOIN `Target_business_case.order_items` AS oi
ON o.order_id = oi.order_id
INNER JOIN `Target_business_case.customers` AS c
ON o.customer_id = c.customer_id
GROUP BY State_high_avg_freight_val
ORDER BY average_value DESC
LIMIT 5;

#------lowest
SELECT
  c.customer_state AS State_low_avg_freight_val,
  ROUND(SUM(oi.freight_value)/COUNT(DISTINCT oi.order_id),2) AS average_value
FROM `Target_business_case.orders` AS o
INNER JOIN `Target_business_case.order_items` AS oi
ON o.order_id = oi.order_id
INNER JOIN `Target_business_case.customers` AS c
ON o.customer_id = c.customer_id
GROUP BY State_low_avg_freight_val
ORDER BY average_value
LIMIT 5;

-- c. Find out the top 5 states with the highest & lowest average delivery time.

SELECT
  c.customer_state AS State_high_avg_delivery_time,
  ROUND(SUM(DATE_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, DAY))/COUNT(DISTINCT o.order_id),2) AS avg_time_to_deliver
FROM `Target_business_case.orders` AS o
INNER JOIN `Target_business_case.customers` AS c
ON o.customer_id = c.customer_id
WHERE LOWER(o.order_status) = 'delivered'
GROUP BY State_high_avg_delivery_time
ORDER BY avg_time_to_deliver DESC
LIMIT 5;

SELECT
  c.customer_state AS State_low_avg_delivery_time,
  ROUND(SUM(DATE_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, DAY))/COUNT(DISTINCT o.order_id),2) AS avg_time_to_deliver
FROM `Target_business_case.orders` AS o
INNER JOIN `Target_business_case.customers` AS c
ON o.customer_id = c.customer_id
WHERE LOWER(o.order_status) = 'delivered'
GROUP BY State_low_avg_delivery_time
ORDER BY avg_time_to_deliver
LIMIT 5;

/* d. Find out the top 5 states where the order delivery is really fast as compared to the estimated date of delivery.
You can use the difference between the averages of actual & estimated delivery date to figure out how fast the delivery was for each state.*/

SELECT
  c.customer_state AS State,
  ROUND(AVG(DATE_DIFF(o.order_estimated_delivery_date, o.order_purchase_timestamp, DAY)) - AVG(DATE_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, DAY)),2) AS avg_diff_delivery_days
FROM `Target_business_case.orders` AS o
INNER JOIN `Target_business_case.customers` AS c
ON o.customer_id = c.customer_id
WHERE LOWER(o.order_status) = 'delivered'
GROUP BY State
ORDER BY avg_diff_delivery_days DESC
LIMIT 5;


-- 6. Analysis based on the payments:
--    a. Find the month on month no. of orders placed using different payment types.

SELECT
  EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year_of_order,
  EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month_of_order,
  p.payment_type,
  COUNT(o.order_id) AS no_of_orders
FROM `Target_business_case.orders` AS o
INNER JOIN `Target_business_case.payments` AS p
ON o.order_id = p.order_id
GROUP BY year_of_order, month_of_order, p.payment_type
ORDER BY year_of_order, month_of_order, no_of_orders DESC;

-- b. Find the no. of orders placed on the basis of the payment installments that have been paid.

SELECT
  p.payment_installments,
  COUNT(DISTINCT o.order_id) AS count_of_orders
FROM `Target_business_case.orders` AS o
INNER JOIN `Target_business_case.payments` AS p
ON o.order_id = p.order_id
WHERE p.payment_installments > 1
GROUP BY p.payment_installments
ORDER BY p.payment_installments;



























