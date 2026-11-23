-- 03 Sales analysis 

SELECT
  ROUND(SUM(sales), 2)                          AS total_sales,
  ROUND(SUM(profit), 2)                         AS total_profit,
  COUNT(DISTINCT order_id)                      AS orders,
  COUNT(DISTINCT customer_id)                   AS customers,
  SUM(quantity)                                 AS units,
  ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS avg_order_value,
  ROUND(SUM(profit) / SUM(sales), 4)            AS profit_margin
FROM orders_clean;

-- sales_by_category
SELECT category,
       ROUND(SUM(sales), 2) AS sales,
       ROUND(100.0 * SUM(sales) / (SELECT SUM(sales) FROM orders_clean), 2) AS share_of_sales_pct,
       COUNT(DISTINCT order_id) AS orders
FROM orders_clean
GROUP BY category
ORDER BY sales DESC;

-- sales_by_subcategory
SELECT sub_category,
       category,
       ROUND(SUM(sales), 2) AS sales,
       SUM(quantity) AS units
FROM orders_clean
GROUP BY sub_category, category
ORDER BY sales DESC;

-- sales_by_segment
SELECT segment,
       ROUND(SUM(sales), 2) AS sales,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM orders_clean
GROUP BY segment
ORDER BY sales DESC;

-- sales_by_year_growth
WITH yearly AS (
  SELECT order_year AS year, SUM(sales) AS sales
  FROM orders_clean GROUP BY order_year
)
SELECT year,
       ROUND(sales, 2) AS sales,
       ROUND(100.0 * (sales - LAG(sales) OVER (ORDER BY year)) / LAG(sales) OVER (ORDER BY year), 2) AS growth_pct
FROM yearly
ORDER BY year;

-- top_10_products_by_sales
SELECT product_name, category, sub_category,
       ROUND(SUM(sales), 2) AS sales, SUM(quantity) AS units
FROM orders_clean
GROUP BY product_name, category, sub_category
ORDER BY sales DESC
LIMIT 10;
