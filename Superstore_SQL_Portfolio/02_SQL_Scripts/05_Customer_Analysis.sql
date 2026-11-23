-- 05 Customer analysis 

WITH per_customer AS (
  SELECT customer_id, COUNT(DISTINCT order_id) AS orders, SUM(sales) AS sales, SUM(profit) AS profit
  FROM orders_clean GROUP BY customer_id
)
SELECT
  COUNT(*) AS customers,
  SUM(CASE WHEN orders = 1 THEN 1 ELSE 0 END) AS one_order_customers,
  SUM(CASE WHEN orders > 1 THEN 1 ELSE 0 END) AS repeat_customers,
  ROUND(100.0 * SUM(CASE WHEN orders > 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS repeat_rate_pct,
  ROUND(AVG(orders), 2) AS avg_orders_per_customer,
  ROUND(AVG(sales), 2) AS avg_sales_per_customer
FROM per_customer;

-- top_10_customers_by_sales
SELECT customer_id,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(sales), 2)  AS sales,
       ROUND(SUM(profit), 2) AS profit
FROM orders_clean
GROUP BY customer_id
ORDER BY sales DESC
LIMIT 10;

-- customer_value_tiers
WITH per_customer AS (
  SELECT customer_id, SUM(sales) AS sales FROM orders_clean GROUP BY customer_id
), ranked AS (
  SELECT customer_id, sales, NTILE(4) OVER (ORDER BY sales DESC) AS quartile FROM per_customer
)
SELECT quartile AS value_quartile,
       COUNT(*) AS customers,
       ROUND(SUM(sales), 2) AS sales,
       ROUND(100.0 * SUM(sales) / (SELECT SUM(sales) FROM orders_clean), 2) AS share_of_sales_pct
FROM ranked
GROUP BY quartile
ORDER BY quartile;

-- segment_customers_and_profit
SELECT segment,
       COUNT(DISTINCT customer_id) AS customers,
       ROUND(SUM(sales), 2)  AS sales,
       ROUND(SUM(profit), 2) AS profit,
       ROUND(SUM(profit) / SUM(sales), 4) AS profit_margin
FROM orders_clean
GROUP BY segment
ORDER BY sales DESC;
