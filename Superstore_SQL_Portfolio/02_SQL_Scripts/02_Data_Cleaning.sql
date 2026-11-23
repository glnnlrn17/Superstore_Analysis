-- 02 Data cleaning

DROP TABLE IF EXISTS orders_clean;

CREATE TABLE orders_clean AS
WITH parsed AS (
  SELECT
    r.*,
    -- Order date parts (M/D/YYYY)
    CAST(SUBSTR("Order Date", 1, INSTR("Order Date", '/') - 1) AS INTEGER) AS o_m,
    CAST(SUBSTR(SUBSTR("Order Date", INSTR("Order Date", '/') + 1), 1, INSTR(SUBSTR("Order Date", INSTR("Order Date", '/') + 1), '/') - 1) AS INTEGER) AS o_d,
    CAST(SUBSTR(SUBSTR("Order Date", INSTR("Order Date", '/') + 1), INSTR(SUBSTR("Order Date", INSTR("Order Date", '/') + 1), '/') + 1) AS INTEGER) AS o_y,
    -- Ship date parts
    CAST(SUBSTR("Ship Date", 1, INSTR("Ship Date", '/') - 1) AS INTEGER) AS s_m,
    CAST(SUBSTR(SUBSTR("Ship Date", INSTR("Ship Date", '/') + 1), 1, INSTR(SUBSTR("Ship Date", INSTR("Ship Date", '/') + 1), '/') - 1) AS INTEGER) AS s_d,
    CAST(SUBSTR(SUBSTR("Ship Date", INSTR("Ship Date", '/') + 1), INSTR(SUBSTR("Ship Date", INSTR("Ship Date", '/') + 1), '/') + 1) AS INTEGER) AS s_y
  FROM superstore_raw r
)
SELECT
  CAST("Row ID" AS INTEGER)                              AS row_id,
  "Order ID"                                             AS order_id,
  printf('%04d-%02d-%02d', o_y, o_m, o_d)                AS order_date,
  printf('%04d-%02d-%02d', s_y, s_m, s_d)                AS ship_date,
  "Ship Mode"                                            AS ship_mode,
  "Customer ID"                                          AS customer_id,
  "Segment"                                              AS segment,
  "City"                                                 AS city,
  "State"                                                AS state,
  printf('%05d', CAST("Postal Code" AS INTEGER))         AS postal_code,
  "Region"                                               AS region,
  "Product ID"                                           AS product_id,
  "Category"                                             AS category,
  "Sub-Category"                                         AS sub_category,
  "Product Name"                                         AS product_name,
  CAST("Sales" AS REAL)                                  AS sales,
  CAST("Quantity" AS INTEGER)                            AS quantity,
  CAST("Discount" AS REAL)                               AS discount,
  CAST("Profit" AS REAL)                                 AS profit,
  o_y                                                    AS order_year,
  o_m                                                    AS order_month,
  ((o_m - 1) / 3) + 1                                    AS order_quarter,
  ROUND(julianday(printf('%04d-%02d-%02d', s_y, s_m, s_d)) - julianday(printf('%04d-%02d-%02d', o_y, o_m, o_d)), 0) AS ship_days,
  ROUND(CAST("Profit" AS REAL) / CAST("Sales" AS REAL), 4) AS profit_margin,
  CASE
    WHEN CAST("Discount" AS REAL) = 0 THEN '0%'
    WHEN CAST("Discount" AS REAL) <= 0.2 THEN '1-20%'
    WHEN CAST("Discount" AS REAL) < 0.3 THEN '21-29%'
    ELSE '30%+'
  END AS discount_band
FROM parsed;

-- Post-clean checks
-- clean_row_count
SELECT COUNT(*) AS clean_rows FROM orders_clean;

-- ship_before_order_check
SELECT COUNT(*) AS ship_before_order FROM orders_clean WHERE ship_date < order_date;

-- date_range_check
SELECT MIN(order_date) AS first_order, MAX(order_date) AS last_order, MIN(ship_days) AS min_ship_days, MAX(ship_days) AS max_ship_days FROM orders_clean;

-- postal_check
SELECT LENGTH(postal_code) AS postal_length, COUNT(*) AS rows FROM orders_clean GROUP BY LENGTH(postal_code);
