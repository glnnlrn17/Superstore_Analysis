# Superstore SQL Analysis

A SQL portfolio project on the Superstore sample dataset (9,994 order lines, orders from 2014 to 2017, United States).
The project covers data quality checks, cleaning, sales, profit, customer, product, regional and time analysis, and a
dashboard (Excel stand-in, Looker Studio link pending).

## Folder guide

| Folder | What is inside |
|---|---|
| 01_Dataset | Original CSV (`Superstore.csv`) and `Data_Dictionary.xlsx` (raw and cleaned fields). |
| 02_SQL_Scripts | Nine SQL scripts, run in order: quality checks, cleaning, then sales, profit, customer, product, regional, time and business insight queries. |
| 03_Cleaned_Data | `orders_clean.csv` (9,994 rows, 25 columns) and `Cleaning_Log.xlsx` with each cleaning decision and check. |
| 04_Analysis_Results | Four workbooks with the exported query results: Sales, Profit, Customer and Product, Regional and Time. |
| 05_Dashboard | `Superstore_Excel_Dashboard.xlsx` (interactive, five filters), `Dashboard_Export.pdf`, `Dashboard_Screenshot.png`, and `Dashboard_Link.txt` (Looker Studio link still to be added). |
| 06_Project_Documentation | This README, `Final_Project_Report.pdf`, and `Business_Recommendations.docx`. |

## How to run the SQL

The scripts use SQLite syntax.

1. Load `01_Dataset/Superstore.csv` into a table called `superstore_raw` with all columns as text.
2. Run `01_Data_Quality_Checks.sql` (every check should return 0 unless noted).
3. Run `02_Data_Cleaning.sql`. It builds the `orders_clean` table.
4. Run scripts 03 to 09. Each query is labelled with `-- @name` so you can find it easily.

## Key metrics

- Sales: 2,297,201. Profit: 286,397. Profit margin: 12.5%.
- Orders: 5,009. Customers: 793. Average order value: 458.61.
- Profit margin = SUM(profit) / SUM(sales).
- Repeat customer rate = customers with more than one order / all customers (98.5%).

## Notes

- Currency is not stated in the source file. Values are treated as USD.
- Customer Name is excluded from the cleaned table because it is personal data.
- The Excel dashboard is a stand-in for the Looker Studio dashboard. Replace the line in `Dashboard_Link.txt` after you publish.
