# Amazon-brazil-to-india-analysis-using-SQL
End-to-end SQL analysis of Amazon Brazil e-commerce data to uncover customer behavior, sales trends, and payment insights. Provides data-driven recommendations for Amazon India using joins, CTEs, window functions, and business-focused analysis.

<div align="center">

<img src="https://upload.wikimedia.org/wikipedia/commons/a/a9/Amazon_logo.svg" alt="Amazon Logo" width="160"/>

# 🛒 Amazon Brazil → India Market Analysis
### SQL Data Analysis | Milestone 02

[![SQL](https://img.shields.io/badge/Language-SQL%20%28PostgreSQL%29-336791?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)](.)
[![Analysis](https://img.shields.io/badge/Analysis-3%20Phases-FF9900?style=for-the-badge)](.)
[![Queries](https://img.shields.io/badge/SQL%20Queries-17-blue?style=for-the-badge)](.)

> **Analyzing Amazon Brazil's e-commerce dataset to uncover trends, customer behaviors, and strategic insights applicable to the Indian market.**

---

**Author:** Nishant Kumar Mishra &nbsp;|&nbsp; **Domain:** E-Commerce Data Analytics &nbsp;|&nbsp; **Tool:** PostgreSQL / pgAdmin

</div>

---

## 📌 Table of Contents

- [Project Overview](#-project-overview)
- [Business Context](#-business-context)
- [Dataset and Schema](#%EF%B8%8F-dataset--schema)
- [Project Structure](#-project-structure)
- [Database Setup](#%EF%B8%8F-database-setup)
- [Analysis Breakdown](#-analysis-breakdown)
  - [Analysis I — Basic SQL](#analysis-i--basic-sql-7-questions)
  - [Analysis II — Joins](#analysis-ii--joins-5-questions)
  - [Analysis III — CTEs & Window Functions](#analysis-iii--ctes--window-functions-7-questions)
- [Key Findings](#-key-findings)
- [Business Recommendations](#-business-recommendations-for-amazon-india)
- [Presentation](#%EF%B8%8F-presentation)
- [How to Run](#%EF%B8%8F-how-to-run)

---

## 🧭 Project Overview

This project performs a **comprehensive SQL-based analysis** of Amazon Brazil's operational dataset across 6 interconnected tables. The goal is to extract actionable insights — on customer behavior, payment preferences, seasonal trends, product categories, and loyalty patterns — that Amazon India can use to drive growth and improve customer experience.

The analysis is divided into **3 progressive phases**, moving from basic aggregations to advanced window functions and CTEs.

---

## 💼 Business Context

Amazon has established a strong presence in markets like the US, Europe, and Brazil. Given the structural similarities between Brazil and India — **large populations, diverse consumer bases, and emerging digital economies** — there is a strong opportunity to replicate Brazil's success in India.

As a Data Analyst for **Amazon India**, the task is to:
- Identify **payment preferences** and optimize the checkout experience
- Discover **seasonal and monthly revenue patterns** for campaign planning
- Understand **customer loyalty segments** to build a retention program
- Highlight **top-performing product categories** for inventory and marketing focus
- Surface **data quality issues** that affect catalog integrity

---

## 🗄️ Dataset & Schema

The dataset consists of **6 CSV files** mapped to 6 PostgreSQL tables in the `amazon_brazil` schema.

```
amazon_analysis (database)
└── amazon_brazil (schema)
    ├── customers
    ├── orders
    ├── order_items
    ├── product
    ├── seller
    └── payments
```

### Table Overview

| Table | Key Columns | Purpose |
|-------|-------------|---------|
| `customers` | `customer_id` (PK), `customer_unique_id`, `customer_zip_code_prefix` | Customer demographics & behavior |
| `orders` | `order_id` (PK), `customer_id` (FK), `order_status`, `order_purchase_timestamp` | Order lifecycle tracking |
| `order_items` | `order_id` (FK), `product_id` (FK), `seller_id` (FK), `price`, `freight_value` | Item-level pricing & shipping |
| `product` | `product_id` (PK), `product_category_name`, `product_weight_g` | Product catalog & specs |
| `seller` | `seller_id` (PK), `seller_city`, `seller_state` | Seller location & performance |
| `payments` | `order_id` (FK), `payment_type`, `payment_value`, `payment_installments` | Transaction details |

### Schema Relationships

```
customers ──< orders ──< order_items >── product
                  │              └────── seller
                  └──< payments
```

> **One-to-Many:** One customer → Many orders | One order → Many items | One order → Many payments

---

## 📁 Project Structure

```
amazon-brazil-india-analysis/
│
├── 📂 data/                          # Raw CSV datasets
│   ├── customers.csv
│   ├── orders.csv
│   ├── order_items.csv
│   ├── product.csv
│   ├── seller.csv
│   └── payments.csv
│
├── 📂 sql/
│   └── Amazon_Analysis_Milestone_02.sql   # All 17 SQL queries (3 analyses)
│
├── 📂 outputs/
│   ├── Amazon_Analysis_milestone02_sheets.xlsx  # Query output results
│   └── Amazon_India_Analysis_Presentation.pdf   # Final presentation (10 slides)
│
├── 📂 assets/
│   └── schema_diagram.png            # ERD / Schema relationship diagram
│
└── README.md
```

---

## 🛠️ Database Setup

### Step 1 — Create Database & Schema

```sql
-- Create the database
CREATE DATABASE amazon_analysis;

-- Connect to it, then create schema
CREATE SCHEMA amazon_brazil;
```

### Step 2 — Create Tables

```sql
-- Customers
CREATE TABLE amazon_brazil.customers (
    customer_id              VARCHAR PRIMARY KEY,
    customer_unique_id       VARCHAR,
    customer_zip_code_prefix INTEGER
);

-- Orders
CREATE TABLE amazon_brazil.orders (
    order_id                        VARCHAR PRIMARY KEY,
    customer_id                     VARCHAR REFERENCES amazon_brazil.customers(customer_id),
    order_status                    VARCHAR,
    order_purchase_timestamp        TIMESTAMP,
    order_approved_at               TIMESTAMP,
    order_delivered_carrier_date    TIMESTAMP,
    order_delivered_customer_date   TIMESTAMP,
    order_estimated_delivery_date   TIMESTAMP
);

-- Order Items
CREATE TABLE amazon_brazil.order_items (
    order_id            VARCHAR REFERENCES amazon_brazil.orders(order_id),
    order_item_id       INTEGER,
    product_id          VARCHAR REFERENCES amazon_brazil.product(product_id),
    seller_id           VARCHAR REFERENCES amazon_brazil.seller(seller_id),
    shipping_limit_date TIMESTAMP,
    price               NUMERIC,
    freight_value       NUMERIC
);

-- Product
CREATE TABLE amazon_brazil.product (
    product_id                  VARCHAR PRIMARY KEY,
    product_category_name       VARCHAR,
    product_name_lenght         INTEGER,
    product_description_lenght  INTEGER,
    product_photos_qty          INTEGER,
    product_weight_g            INTEGER,
    product_length_cm           INTEGER,
    product_height_cm           INTEGER,
    product_width_cm            INTEGER
);

-- Seller
CREATE TABLE amazon_brazil.seller (
    seller_id              VARCHAR PRIMARY KEY,
    seller_zip_code_prefix INTEGER,
    seller_city            VARCHAR,
    seller_state           VARCHAR
);

-- Payments
CREATE TABLE amazon_brazil.payments (
    order_id               VARCHAR REFERENCES amazon_brazil.orders(order_id),
    payment_sequential     INTEGER,
    payment_type           VARCHAR,
    payment_installments   INTEGER,
    payment_value          NUMERIC
);
```

### Step 3 — Import CSV Data

In **pgAdmin**, for each table:
1. Right-click the table → **Import/Export**
2. Set Format: `CSV`, enable **Header**, Delimiter: `,`
3. Browse to the corresponding `.csv` file and click **OK**

---

## 📊 Analysis Breakdown

### Analysis I — Basic SQL (7 Questions)

> Aggregations, filtering, GROUP BY, HAVING, STDDEV

| # | Business Question | Key SQL Concepts | Output |
|---|-------------------|-----------------|--------|
| 1 | Standardize avg payment values per payment type | `ROUND`, `AVG`, `GROUP BY` | `payment_type, rounded_avg_payment` |
| 2 | Distribution of orders by payment type (%) | `COUNT`, subquery, `ROUND` | `payment_type, percentage_orders` |
| 3 | Products priced 100–500 BRL containing 'Smart' | `BETWEEN`, `LIKE`, `JOIN` | `product_id, price` |
| 4 | Top 3 months with highest total sales | `TO_CHAR`, `SUM`, `LIMIT` | `month, total_sales` |
| 5 | Categories with price difference > 500 BRL | `MAX - MIN`, `HAVING` | `product_category_name, price_difference` |
| 6 | Payment types with lowest transaction variance | `STDDEV_SAMP`, `ORDER BY` | `payment_type, std_deviation` |
| 7 | Products with NULL or single-char category names | `IS NULL`, `LIKE '_'` | `product_id, product_category_name` |

**Sample Query — Q2: Payment Distribution**
```sql
SELECT
    payment_type,
    ROUND(COUNT(payment_type) * 100.0 / (SELECT COUNT(*) FROM amazon_brazil.payments), 1) AS percentage_orders
FROM amazon_brazil.payments
GROUP BY payment_type
ORDER BY percentage_orders DESC;
```

---

### Analysis II — Joins (5 Questions)

> INNER JOIN, LEFT JOIN, GROUP BY, CASE, Temp Tables

| # | Business Question | Key SQL Concepts | Output |
|---|-------------------|-----------------|--------|
| 1 | Payment type popularity across order value segments (Low/Med/High) | `CASE`, `GROUP BY`, `COUNT` | `order_value_segment, payment_type, count` |
| 2 | Price range & average per product category | `MIN`, `MAX`, `AVG`, `LEFT JOIN` | `product_category_name, min_price, max_price, avg_price` |
| 3 | Customers with more than one order | `LEFT JOIN`, `HAVING COUNT > 1` | `customer_unique_id, total_orders` |
| 4 | Customer type segmentation (New/Returning/Loyal) | `CASE`, `COUNT`, `JOIN` | `customer_unique_id, customer_type` |
| 5 | Top 5 revenue-generating product categories | `SUM(price)`, `JOIN`, `LIMIT` | `product_category_name, total_revenue` |

**Sample Query — Q4: Customer Segmentation**
```sql
SELECT
    cust.customer_unique_id,
    CASE
        WHEN COUNT(cust.customer_id) = 1         THEN 'New'
        WHEN COUNT(cust.customer_id) BETWEEN 2 AND 4 THEN 'Returning'
        ELSE 'Loyal'
    END AS customer_type
FROM amazon_brazil.customers AS cust
LEFT JOIN amazon_brazil.orders AS ord ON cust.customer_id = ord.customer_id
GROUP BY cust.customer_unique_id;
```

---

### Analysis III — CTEs & Window Functions (7 Questions)

> Subqueries, CTEs, Recursive CTEs, RANK(), LAG(), SUM() OVER()

| # | Business Question | Key SQL Concepts | Output |
|---|-------------------|-----------------|--------|
| 1 | Total sales by season (Spring/Summer/Autumn/Winter) | `CASE`, `EXTRACT(MONTH)`, Subquery | `season, total_sales` |
| 2 | Products with sales volume above overall average | Nested subquery, `HAVING` | `product_id, total_quantity_sold` |
| 3 | Monthly revenue trend for 2018 | `WHERE YEAR = 2018`, `TO_CHAR`, `SUM` | `month, total_revenue` |
| 4 | Customer loyalty segments with CTE | CTE, `CASE`, `COUNT(*)` | `customer_type, count` |
| 5 | Top 20 high-value customers ranked by avg order value | `RANK() OVER`, `AVG`, `INNER JOIN` | `customer_id, avg_order_value, customer_rank` |
| 6 | Cumulative monthly sales per product | CTE + `SUM() OVER(PARTITION BY)` | `product_id, sale_month, total_sales` |
| 7 | Month-over-month payment growth (2018) | CTE + `LAG() OVER`, `NULLIF` | `payment_type, sale_month, monthly_total, monthly_change` |

**Sample Query — Q5: Top 20 High-Value Customers**
```sql
SELECT
    cust.customer_unique_id AS customer_id,
    ROUND(AVG(pymt.payment_value), 0) AS avg_order_value,
    RANK() OVER (ORDER BY AVG(pymt.payment_value) DESC) AS customer_rank
FROM amazon_brazil.customers AS cust
INNER JOIN amazon_brazil.orders AS ord ON cust.customer_id = ord.customer_id
INNER JOIN amazon_brazil.payments AS pymt ON ord.order_id = pymt.order_id
GROUP BY cust.customer_unique_id
ORDER BY avg_order_value DESC
LIMIT 20;
```

**Sample Query — Q7: Month-over-Month Payment Growth**
```sql
WITH monthly_sales AS (
    SELECT
        pymt.payment_type,
        TO_CHAR(ord.order_purchase_timestamp, 'Month') AS sale_month,
        ROUND(SUM(pymt.payment_value), 2) AS monthly_total
    FROM amazon_brazil.payments AS pymt
    LEFT JOIN amazon_brazil.orders AS ord ON pymt.order_id = ord.order_id
    WHERE EXTRACT(YEAR FROM ord.order_purchase_timestamp) = 2018
    GROUP BY pymt.payment_type, TO_CHAR(ord.order_purchase_timestamp, 'Month')
)
SELECT
    payment_type,
    sale_month,
    monthly_total,
    ROUND(
        (monthly_total - LAG(monthly_total) OVER (PARTITION BY payment_type ORDER BY sale_month))
        * 100.0 / NULLIF(LAG(monthly_total) OVER (PARTITION BY payment_type ORDER BY sale_month), 0),
    2) AS monthly_change
FROM monthly_sales
ORDER BY payment_type, sale_month;
```

---

## 🔍 Key Findings

### 💳 Payment Behavior
| Metric | Finding |
|--------|---------|
| Dominant payment method | **Credit Card — 73.9%** of all transactions |
| Most consistent payment | **Not Defined → Voucher → Boleto** (lowest std deviation) |
| Highest avg transaction | **Credit Card: BRL 163** |
| Cash-equivalent (Boleto) | **19%** — significant trust-based segment |

### 📅 Seasonal Trends
| Season | Total Sales (BRL) |
|--------|------------------|
| 🌸 Spring (Mar–May) | **42,16,722** ← Peak |
| ☀️ Summer (Jun–Aug) | 41,20,360 |
| ❄️ Winter (Dec–Feb) | 29,05,750 |
| 🍂 Autumn (Sep–Nov) | 23,48,813 ← Lowest |

**Top 3 months:** May (15,02,589) → August (14,28,658) → July (13,93,539)

### 🛍️ Top Revenue Categories (BRL)
| Rank | Category | Revenue |
|------|----------|---------|
| 1 | beleza_saude (Beauty & Health) | **12,57,865** |
| 2 | relogios_presentes (Watches & Gifts) | 12,03,060 |
| 3 | cama_mesa_banho (Home Linen) | 10,32,269 |
| 4 | esporte_lazer (Sports & Leisure) | 9,85,881 |
| 5 | informatica_acessorios (IT Accessories) | 9,10,605 |

### 👥 Customer Segmentation
| Segment | Count | % of Base |
|---------|-------|-----------|
| New (1 order) | 92,899 | 96.67% |
| Returning (2–4 orders) | 3,079 | 3.20% |
| Loyal (>4 orders) | 121 | 0.12% |

> **Loyalty Program Segments (Analysis III):**
> - Occasional (1–2 orders): **94,635** customers — 98.47%
> - Loyal (>5 orders): **1,128** — 1.17%
> - Regular (3–5 orders): **333** — 0.34%

### ⚠️ Data Quality
- **610 products** with NULL category names
- **4 products** with single-character category names (`'c'`, `'f'`, `'t'`, `'w'`)
- **Total: 614 products** needing catalog correction

---

## 💡 Business Recommendations for Amazon India

### 01 · Digital Payment Ecosystem
> Invest in **UPI, credit card EMI & BNPL partnerships**.  
> Model Brazil's 73.9% credit card dominance → translate to UPI/RuPay in India.  
> Maintain **COD (equivalent to Boleto)** as trust-building tool for Tier-2 & Tier-3 cities.

### 02 · Seasonal Campaign Calendar
> **Peak window:** Feb–May (pre-summer) & **Oct–Nov (Diwali)**.  
> Budget **60% of annual marketing spend** around these high-impact windows.  
> Use Brazil's Spring data to design India's pre-summer surge strategy.

### 03 · Loyalty Program Launch
> **96% of buyers are one-time** — the biggest untapped opportunity.  
> Implement a **Bronze → Silver → Gold** tiered program:
> - Bronze: post-purchase coupons for New customers
> - Silver: early sale access for Returning customers
> - Gold: free shipping + exclusive deals for Loyal customers (Amazon Prime equivalent)

### 04 · Category Prioritization
> Lead with India-localized versions of Brazil's top categories:
> - **Beauty & Health** → Skincare, Ayurveda, Personal care
> - **Watches & Gifts** → Festive gifting, Ethnic jewelry
> - **Home Linen** → Sarees, Ethnic home décor, Bedding

### 05 · Inventory & Supply Chain
> Pre-stock **top 10 fast-moving products** (by quantity sold) **6–8 weeks** before peak months.  
> Top product `422879e10f...` sold **793 units — 4× above average** — prioritize inventory.  
> Reduces stockout risk and maximizes revenue capture during peak seasons.

### 06 · Catalog Data Quality
> Fix **614 products** with NULL or invalid category names.  
> Enforce **data validation rules at seller onboarding** stage.  
> Improves search discoverability, recommendations, and conversion rates.

---

## 📽️ Presentation

The final 10-slide presentation (`Amazon_India_Analysis_Presentation.pdf`) covers:

| Slide | Content |
|-------|---------|
| 1 | Title — Amazon Brazil → India Strategic Analysis |
| 2 | Executive Summary — 4 KPIs + 5 Key Findings |
| 3 | Analysis I — Payment Behavior (bar chart + stats) |
| 4 | Analysis I — Seasonal Sales & Price Variation |
| 5 | Analysis II — Segments, Categories & Revenue |
| 6 | Analysis II — Customer Loyalty & High-Value Customers |
| 7 | Analysis III — Seasonal Trends & 2018 Monthly Revenue |
| 8 | Analysis III — Loyalty Segments & MoM Payment Growth |
| 9 | 6 Business Recommendations for Amazon India |
| 10 | Thank You — Nishant Kumar Mishra |

---

## ▶️ How to Run

### Prerequisites
- PostgreSQL 13+ / pgAdmin 4
- CSV files from the `data/` folder

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/your-username/amazon-brazil-india-analysis.git
cd amazon-brazil-india-analysis

# 2. Open pgAdmin → Create database: amazon_analysis
# 3. Create schema: amazon_brazil
# 4. Run table creation queries from sql/Amazon_Analysis_Milestone_02.sql
# 5. Import each CSV file into its respective table via pgAdmin Import tool
# 6. Run the analysis queries section by section
```

### Query Execution Order
```
1. Create tables (top of SQL file)
2. Import CSVs
3. Run Analysis I queries (Q1–Q7)
4. Run Analysis II queries (Q1–Q5)
5. Run Analysis III queries (Q1–Q7)
```

---

## 🧰 Tech Stack

| Tool | Purpose |
|------|---------|
| **PostgreSQL 15** | Primary database engine |
| **pgAdmin 4** | Query execution & data import |
| **SQL** | Data analysis (Aggregations, Joins, CTEs, Window Functions) |
| **Microsoft Excel / Google Sheets** | Output visualization & charts |
| **PowerPoint / PDF** | Final presentation |

---

## 📄 License

This project is submitted as part of an academic milestone assignment. Data sourced from Amazon Brazil's public e-commerce dataset.

---

<div align="center">

Made with ❤️ by **Nishant Kumar Mishra**

*"Data-driven decisions · Customer-first strategy · Market excellence"*

</div>







