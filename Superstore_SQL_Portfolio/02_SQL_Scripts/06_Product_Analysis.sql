-- 06 Product analysis (table: orders_clean)

-- @name product_count_by_category
SELECT category, COUNT(DISTINCT product_id) AS products,
       ROUND(SUM(sales) / COUNT(DISTINCT product_id), 2) AS sales_per_product
FROM orders_clean
GROUP BY category
ORDER BY sales_per_product DESC;

-- @name subcategory_sales_profit_units
SELECT sub_category, category,
       COUNT(DISTINCT product_id) AS products,
       SUM(quantity) AS units,
       ROUND(SUM(sales), 2) AS sales,
       ROUND(SUM(profit), 2) AS profit,
       ROUND(SUM(profit) / SUM(sales), 4) AS profit_margin,
       ROUND(AVG(discount), 3) AS avg_discount
FROM orders_clean
GROUP BY sub_category, category
ORDER BY sales DESC;

-- @name discount_vs_margin_by_category
SELECT category,
       ROUND(AVG(discount), 3) AS avg_discount,
       ROUND(SUM(profit) / SUM(sales), 4) AS profit_margin,
       ROUND(100.0 * SUM(CASE WHEN discount >= 0.3 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_lines_30pct_plus
FROM orders_clean
GROUP BY category
ORDER BY profit_margin;
