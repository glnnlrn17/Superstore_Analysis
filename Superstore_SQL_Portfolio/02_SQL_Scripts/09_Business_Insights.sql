-- 09 Business insights: the queries behind the headline findings in the report and recommendations.

-- @name insight_headline_numbers
SELECT ROUND(SUM(sales), 0) AS sales, ROUND(SUM(profit), 0) AS profit,
       ROUND(SUM(profit) / SUM(sales), 4) AS margin FROM orders_clean;

-- @name insight_category_margin_gap
SELECT category, ROUND(SUM(profit) / SUM(sales), 4) AS margin FROM orders_clean GROUP BY category ORDER BY margin;

-- @name insight_discount_breakeven
SELECT discount_band, ROUND(SUM(profit) / SUM(sales), 4) AS margin FROM orders_clean GROUP BY discount_band ORDER BY MIN(discount);

-- @name insight_loss_makers
SELECT sub_category, ROUND(SUM(profit), 0) AS profit
FROM orders_clean GROUP BY sub_category HAVING SUM(profit) < 0 ORDER BY profit;

-- @name insight_repeat_rate
WITH pc AS (SELECT customer_id, COUNT(DISTINCT order_id) AS o FROM orders_clean GROUP BY customer_id)
SELECT ROUND(100.0 * SUM(CASE WHEN o > 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS repeat_rate_pct FROM pc;

-- @name insight_west_east_vs_south_central
SELECT region, ROUND(SUM(profit) / SUM(sales), 4) AS margin FROM orders_clean GROUP BY region ORDER BY margin DESC;
