-- 01 Data quality checks
-- row_count
SELECT COUNT(*) AS total_rows FROM superstore_raw;

-- missing_values
SELECT
  SUM("Order ID" IS NULL OR TRIM("Order ID") = '')    AS missing_order_id,
  SUM("Order Date" IS NULL OR TRIM("Order Date") = '') AS missing_order_date,
  SUM("Ship Date" IS NULL OR TRIM("Ship Date") = '')   AS missing_ship_date,
  SUM("Customer ID" IS NULL OR TRIM("Customer ID") = '') AS missing_customer_id,
  SUM("Product ID" IS NULL OR TRIM("Product ID") = '') AS missing_product_id,
  SUM("Sales" IS NULL OR TRIM("Sales") = '')           AS missing_sales,
  SUM("Profit" IS NULL OR TRIM("Profit") = '')         AS missing_profit
FROM superstore_raw;

-- duplicate_row_ids
SELECT COUNT(*) AS duplicate_row_ids
FROM (SELECT "Row ID" FROM superstore_raw GROUP BY "Row ID" HAVING COUNT(*) > 1);

-- duplicate_order_lines
SELECT COUNT(*) AS duplicate_order_product_lines
FROM (SELECT "Order ID", "Product ID", COUNT(*) AS n FROM superstore_raw
      GROUP BY "Order ID", "Product ID" HAVING COUNT(*) > 1);

-- bad_date_format
SELECT
  SUM(LENGTH("Order Date") - LENGTH(REPLACE("Order Date", '/', '')) <> 2) AS bad_order_date_format,
  SUM(LENGTH("Ship Date")  - LENGTH(REPLACE("Ship Date",  '/', '')) <> 2) AS bad_ship_date_format
FROM superstore_raw;

-- invalid_numeric_values
SELECT
  SUM(CAST("Sales" AS REAL) <= 0)       AS non_positive_sales,
  SUM(CAST("Quantity" AS INTEGER) <= 0) AS non_positive_quantity,
  SUM(CAST("Discount" AS REAL) < 0 OR CAST("Discount" AS REAL) > 1) AS discount_out_of_range
FROM superstore_raw;

-- postal_code_length
SELECT LENGTH("Postal Code") AS postal_length, COUNT(*) AS rows
FROM superstore_raw GROUP BY LENGTH("Postal Code") ORDER BY postal_length;

-- distinct_values_check
SELECT 'Segment' AS field, COUNT(DISTINCT "Segment") AS distinct_values FROM superstore_raw
UNION ALL SELECT 'Region', COUNT(DISTINCT "Region") FROM superstore_raw
UNION ALL SELECT 'Category', COUNT(DISTINCT "Category") FROM superstore_raw
UNION ALL SELECT 'Sub-Category', COUNT(DISTINCT "Sub-Category") FROM superstore_raw
UNION ALL SELECT 'Ship Mode', COUNT(DISTINCT "Ship Mode") FROM superstore_raw
UNION ALL SELECT 'Country', COUNT(DISTINCT "Country") FROM superstore_raw;
