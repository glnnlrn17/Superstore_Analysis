-- 08 Time analysis 

-- monthly_trend
SELECT order_year AS year, order_month AS month,
       ROUND(SUM(sales), 2)  AS sales,
       ROUND(SUM(profit), 2) AS profit,
       COUNT(DISTINCT order_id) AS orders
FROM orders_clean
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

-- quarterly_sales_by_year
SELECT order_year AS year, order_quarter AS quarter,
       ROUND(SUM(sales), 2) AS sales,
       ROUND(SUM(profit), 2) AS profit
FROM orders_clean
GROUP BY order_year, order_quarter
ORDER BY order_year, order_quarter;

-- best_and_worst_months
SELECT order_month AS month,
       ROUND(AVG(sales), 2) AS avg_monthly_sales
FROM (SELECT order_year, order_month, SUM(sales) AS sales FROM orders_clean GROUP BY order_year, order_month)
GROUP BY order_month
ORDER BY avg_monthly_sales DESC;

-- ship_mode_lead_time
SELECT ship_mode,
       COUNT(*) AS lines,
       ROUND(AVG(ship_days), 2) AS avg_ship_days,
       ROUND(SUM(sales), 2) AS sales,
       ROUND(SUM(profit) / SUM(sales), 4) AS profit_margin
FROM orders_clean
GROUP BY ship_mode
ORDER BY avg_ship_days;
