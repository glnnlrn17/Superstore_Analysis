-- 04 Profit analysis 

SELECT category,
       ROUND(SUM(sales), 2)  AS sales,
       ROUND(SUM(profit), 2) AS profit,
       ROUND(SUM(profit) / SUM(sales), 4) AS profit_margin
FROM orders_clean
GROUP BY category
ORDER BY profit DESC;

-- profit_by_subcategory
SELECT sub_category, category,
       ROUND(SUM(sales), 2)  AS sales,
       ROUND(SUM(profit), 2) AS profit,
       ROUND(SUM(profit) / SUM(sales), 4) AS profit_margin,
       CASE WHEN SUM(profit) < 0 THEN 'Loss-making' ELSE 'Profitable' END AS status
FROM orders_clean
GROUP BY sub_category, category
ORDER BY profit ASC;

-- profit_by_discount_band
SELECT discount_band,
       COUNT(*) AS lines,
       ROUND(SUM(sales), 2)  AS sales,
       ROUND(SUM(profit), 2) AS profit,
       ROUND(SUM(profit) / SUM(sales), 4) AS profit_margin,
       ROUND(AVG(profit), 2) AS avg_profit_per_line
FROM orders_clean
GROUP BY discount_band
ORDER BY MIN(discount);

-- profit_by_discount_level
SELECT discount,
       COUNT(*) AS lines,
       ROUND(SUM(profit) / SUM(sales), 4) AS profit_margin
FROM orders_clean
GROUP BY discount
ORDER BY discount;

-- loss_making_lines
SELECT COUNT(*) AS loss_making_lines,
       ROUND(SUM(profit), 2) AS total_loss,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM orders_clean), 2) AS pct_of_lines
FROM orders_clean
WHERE profit < 0;

-- worst_10_products_by_profit
SELECT product_name, sub_category,
       ROUND(SUM(sales), 2)  AS sales,
       ROUND(SUM(profit), 2) AS profit,
       ROUND(SUM(profit) / SUM(sales), 4) AS profit_margin
FROM orders_clean
GROUP BY product_name, sub_category
ORDER BY profit ASC
LIMIT 10;
