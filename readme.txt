# Clothing Store Data Analysis | SQL Project

## Project Overview

This project focuses on analyzing a clothing store's sales data using SQL and MySQL. The goal is to clean raw data, prepare reliable datasets, and extract business insights to better understand sales performance, profitability, customer behavior, and product performance.

## Tools & Technologies

- MySQL
- MySQL Workbench
- SQL

## Database Tables

The project uses three main tables:

- **Sales:** Order information, dates, products, customers, quantities, discounts, payment methods, and sales channels.
- **Products:** Product names, categories, cost prices, and selling prices.
- **Customers:** Customer information, including names, gender, city, age, and joining dates.

## Project Workflow

### 1. Data Exploration & Profiling

- Explored the database structure and column data types.
- Checked total records and duplicate IDs.
- Identified missing and invalid values.
- Checked inconsistent date formats.
- Examined payment methods and sales channels.
- Identified suspicious quantities and invalid prices.
- Checked relationships between sales, products, and customers.

### 2. Data Cleaning

Cleaned the three datasets separately.

**Sales Data**
- Removed duplicate orders.
- Standardized payment methods and sales channels.
- Handled missing customer IDs.
- Replaced empty discount values with zero.
- Standardized date formats.
- Converted columns to appropriate data types.
- Identified suspicious quantities.

**Products Data**
- Converted price columns to DECIMAL.
- Added a primary key.
- Checked missing product information.
- Identified invalid prices and selling prices lower than cost prices.

**Customers Data**
- Checked missing values and duplicate IDs.
- Standardized data types.
- Converted joining dates.
- Checked unrealistic ages and missing customer names.

### 3. Data Transformation

Created a SQL view called `sales_enriched` by joining the cleaned sales, products, and customers tables.

Calculated:
- Revenue after discounts.
- Profit after discounts.

Excluded suspicious sales records from the analysis.

### 4. Business Analysis

Performed SQL analysis to answer business questions, including:

- What are the monthly revenue and profit trends?
- Which products generate the highest profits?
- Which products sell the most?
- How does seasonal performance differ across product categories?
- Which sales channels perform best in different cities?
- How do discounts affect revenue and profit margins?
- Who are the top 10 customers by revenue?
- What percentage of revenue comes from the top 10 customers?
- Which cities generate the highest revenue and profit?
- How much revenue is lost through discounts?

## SQL Concepts Practiced

- SELECT, WHERE, GROUP BY, ORDER BY
- Aggregate Functions (SUM, COUNT, AVG, MIN, MAX)
- CASE Statements
- Subqueries
- Common Table Expressions (CTEs)
- Window Functions
- JOINs (INNER JOIN, LEFT JOIN)
- Views
- Data Cleaning (UPDATE, DELETE, ALTER TABLE)
- Date Functions
- String Functions
- Data Type Conversion

## Project Structure

```text
Clothing-Store-Data-Analysis/
│
├── README.md
│
├── SQL/
│   ├── sales_problem_check.sql
│   ├── sales_clean.sql
│   ├── customers_clean.sql
│   ├── products_problem_check.sql
│   ├── products_clean.sql
│   └── business_insights.sql
│
└── Dataset/
    ├── sales.csv
    ├── products.csv
    └── customers.csv
```

## Key Learning Outcomes

Through this project, I practiced working with raw relational datasets, identifying data quality issues, cleaning and transforming data, joining multiple tables, and using SQL to answer business questions.

This project represents my practical SQL learning and the first step in building my Data Analytics portfolio.

## Next Step

Continue developing my Data Analytics skills through Excel, followed by data visualization and Python.
