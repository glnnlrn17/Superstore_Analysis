-- 07 Regional analysis 

SELECT region,
       ROUND(SUM(sales), 2)  AS sales,
       ROUND(SUM(profit), 2) AS profit,
       ROUND(SUM(profit) / SUM(sales), 4) AS profit_margin,
       COUNT(DISTINCT customer_id) AS customers
FROM orders_clean
GROUP BY region
ORDER BY sales DESC;

-- state_ranking_top_and_bottom
WITH state_totals AS (
  SELECT state, region,
         ROUND(SUM(sales), 2) AS sales,
         ROUND(SUM(profit), 2) AS profit,
         ROUND(SUM(profit) / SUM(sales), 4) AS profit_margin
  FROM orders_clean GROUP BY state, region
)
SELECT * FROM (SELECT 'Top 10 by profit' AS group_name, * FROM state_totals ORDER BY profit DESC LIMIT 10)
UNION ALL
SELECT * FROM (SELECT 'Bottom 10 by profit' AS group_name, * FROM state_totals ORDER BY profit ASC LIMIT 10);

-- region_category_margin
SELECT region, category,
       ROUND(SUM(sales), 2)  AS sales,
       ROUND(SUM(profit), 2) AS profit,
       ROUND(SUM(profit) / SUM(sales), 4) AS profit_margin
FROM orders_clean
GROUP BY region, category
ORDER BY region, category;
