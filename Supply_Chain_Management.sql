
CREATE DATABASE SCM;
USE SCM;

-- ============================================================================
-- CREATE TABLES
-- ============================================================================

-- Customer dimension
CREATE TABLE dim_customer (
    customer_code VARCHAR(10) PRIMARY KEY,
    customer VARCHAR(100),
    platform VARCHAR(50),
    channel VARCHAR(50),
    market VARCHAR(50),
    sub_zone VARCHAR(50),
    region VARCHAR(50)
);

-- Product dimension
CREATE TABLE dim_product (
    product_code VARCHAR(20) PRIMARY KEY,
    division VARCHAR(50),
    segment VARCHAR(50),
    category VARCHAR(50),
    product VARCHAR(100),
    variant VARCHAR(50)
);

-- Sales facts
CREATE TABLE fact_sales_monthly (
    date DATE,
    fiscal_year INT,
    product_code VARCHAR(20),
    customer_code VARCHAR(10),
    sold_quantity INT,
    PRIMARY KEY (date, product_code, customer_code)
);

-- Forecast facts
CREATE TABLE fact_forecast_monthly (
    date DATE,
    fiscal_year INT,
    product_code VARCHAR(20),
    customer_code VARCHAR(10),
    forecast_quantity INT,
    PRIMARY KEY (date, product_code, customer_code)
);

-- Pricing
CREATE TABLE fact_gross_price (
    product_code VARCHAR(20),
    fiscal_year INT,
    gross_price DECIMAL(10,2),
    PRIMARY KEY (product_code, fiscal_year)
);

-- Pre-invoice deductions
CREATE TABLE fact_pre_invoice_deductions (
    customer_code VARCHAR(10),
    fiscal_year INT,
    pre_invoice_discount_pct DECIMAL(5,2),
    PRIMARY KEY (customer_code, fiscal_year)
);

-- Post-invoice deductions
CREATE TABLE fact_post_invoice_deductions (
    customer_code VARCHAR(10),
    product_code VARCHAR(20),
    date DATE,
    discounts_pct DECIMAL(5,2),
    other_deductions_pct DECIMAL(5,2),
    PRIMARY KEY (customer_code, product_code, date)
);

-- Manufacturing cost
CREATE TABLE fact_manufacturing_cost (
    product_code VARCHAR(20),
    cost_year INT,
    manufacturing_cost DECIMAL(10,2),
    PRIMARY KEY (product_code, cost_year)
);

-- Freight cost
CREATE TABLE fact_freight_cost (
    market VARCHAR(50),
    fiscal_year INT,
    freight_pct DECIMAL(5,2),
    other_cost_pct DECIMAL(5,2),
    PRIMARY KEY (market, fiscal_year)
);

-- ============================================================================
-- LOAD SAMPLE DATA
-- ============================================================================

-- Insert customers
INSERT INTO dim_customer VALUES
('90002007', 'Best Buy', 'Brick & Mortar', 'Retailer', 'USA', 'NA', 'NA'),
('90002002', 'Flipkart', 'E-Commerce', 'Retailer', 'India', 'India', 'APAC'),
('70002017', 'AtliQ Exclusive', 'Brick & Mortar', 'Direct', 'India', 'India', 'APAC'),
('90002001', 'Amazon', 'E-Commerce', 'Retailer', 'India', 'India', 'APAC'),
('90002003', 'Croma', 'Brick & Mortar', 'Retailer', 'India', 'India', 'APAC'),
('70002019', 'AtliQ e Store', 'E-Commerce', 'Direct', 'USA', 'NA', 'NA'),
('90002006', 'Neptune', 'Brick & Mortar', 'Retailer', 'Canada', 'NA', 'NA');

-- Insert products  
INSERT INTO dim_product VALUES
('A0118150101', 'P & A', 'Peripherals', 'Accessories', 'AQ Pen Drive 2 IN 1', 'Standard'),
('A0118150102', 'P & A', 'Peripherals', 'Accessories', 'AQ Pen Drive DRC', 'Standard'),
('A0520180101', 'P & A', 'Peripherals', 'Mouse', 'AQ Gamers Ms', 'Standard'),
('A0520180102', 'P & A', 'Peripherals', 'Mouse', 'AQ Master wireless x1 Ms', 'Standard'),
('A0720180101', 'P & A', 'Peripherals', 'Keyboard', 'AQ KB 101', 'Standard'),
('A1019210101', 'N & S', 'Notebook', 'Laptop', 'AQ Qwerty', 'Standard'),
('A1119210102', 'N & S', 'Notebook', 'Laptop', 'AQ Velocity', 'Standard'),
('A0118150201', 'P & A', 'Accessories', 'Storage', 'AQ Home Allin1 Gen 2', 'Standard'),
('A0219150301', 'PC', 'Desktop', 'Personal Desktop', 'AQ Smash 2', 'Standard');

-- Insert gross prices
INSERT INTO fact_gross_price VALUES
('A0118150101', 2023, 27.00),
('A0520180101', 2023, 46.50),
('A0520180102', 2023, 38.00),
('A0720180101', 2023, 52.00),
('A0118150102', 2023, 35.00),
('A1019210101', 2023, 890.00),
('A1119210102', 2023, 1250.00);

-- Insert manufacturing costs
INSERT INTO fact_manufacturing_cost VALUES
('A0118150101', 2023, 13.00),
('A0520180101', 2023, 23.50),
('A0520180102', 2023, 19.00),
('A0720180101', 2023, 26.00),
('A0118150102', 2023, 18.00),
('A1019210101', 2023, 545.00),
('A1119210102', 2023, 780.00);

-- Insert pre-invoice discounts
INSERT INTO fact_pre_invoice_deductions VALUES
('90002007', 2023, 6.50),
('90002002', 2023, 7.50),
('70002017', 2023, 5.00),
('90002001', 2023, 8.00),
('90002003', 2023, 6.00),
('70002019', 2023, 5.50),
('90002006', 2023, 7.00);

-- Insert freight costs
INSERT INTO fact_freight_cost VALUES
('Bangladesh', 2023, 4.20, 1.25),
('Canada', 2023, 4.80, 1.40),
('India', 2022, 3.50, 1.20),
('India', 2023, 3.80, 1.30),
('Pakistan', 2023, 4.50, 1.35),
('USA', 2022, 5.00, 1.50),
('USA', 2023, 5.20, 1.60);

-- Insert sales data
INSERT INTO fact_sales_monthly VALUES
-- September 2022 (peak)
('2022-09-01', 2023, 'A0118150101', '90002001', 1200),
('2022-09-01', 2023, 'A0520180101', '90002003', 850),
-- October 2022 (peak)
('2022-10-01', 2023, 'A0118150101', '90002001', 1500),
('2022-10-01', 2023, 'A0720180101', '90002001', 980),
-- November 2022
('2022-11-01', 2023, 'A0520180102', '90002002', 1100),
-- December 2022
('2022-12-01', 2023, 'A1019210101', '90002007', 450),
-- January 2023 
('2023-01-01', 2023, 'A0118150101', '90002001', 1300),
-- February 2023
('2023-02-01', 2023, 'A0520180101', '90002003', 720),
-- March 2023
('2023-03-01', 2023, 'A1119210102', '90002007', 380),
-- April 2023
('2023-04-01', 2023, 'A0720180101', '90002003', 1050),
-- May 2023
('2023-05-01', 2023, 'A0118150102', '90002003', 890),
-- June 2023
('2023-06-01', 2023, 'A1019210101', '90002007', 520),
-- July 2023
('2023-07-01', 2023, 'A0520180101', '90002003', 950),
-- August 2023
('2023-08-01', 2023, 'A0118150101', '90002001', 1400),
-- September 2023 (peak)
('2023-09-01', 2023, 'A0118150101', '90002001', 3000);

-- Insert forecast data
INSERT INTO fact_forecast_monthly VALUES
('2022-09-01', 2023, 'A0118150101', '90002001', 1200),
('2022-09-01', 2023, 'A0520180101', '90002003', 850),
('2022-10-01', 2023, 'A0118150101', '90002001', 1500),
('2022-10-01', 2023, 'A0720180101', '90002001', 980);

-- ==========================================================================
-- ============================================================================

-- ----------------------------------------------------------------------------
--  Monthly Product Sales Trend 
-- ----------------------------------------------------------------------------
SELECT 
    p.product,
    p.product_code,
    p.category,
    YEAR(s.date) AS year,
    MONTH(s.date) AS month,
    DATENAME(MONTH, s.date) AS month_name,
    SUM(s.sold_quantity) AS total_sold_quantity,
    COUNT(DISTINCT s.customer_code) AS unique_customers,
    AVG(s.sold_quantity) AS avg_quantity_per_transaction
FROM fact_sales_monthly s
JOIN dim_product p ON s.product_code = p.product_code
GROUP BY 
    p.product, 
    p.product_code, 
    p.category, 
    YEAR(s.date), 
    MONTH(s.date), 
    DATENAME(MONTH, s.date)
ORDER BY year, month, product;
-- ============================================================================
--Insight:-Sales show strong seasonality with peaks in September and October. Accessories dominate volume during festive months
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Month-over-Month Growth
-- ----------------------------------------------------------------------------
WITH monthly_sales AS (
    SELECT 
        p.product,
        s.date,
        SUM(s.sold_quantity) AS monthly_quantity
    FROM fact_sales_monthly s
    JOIN dim_product p ON s.product_code = p.product_code
    GROUP BY p.product, s.date
)
SELECT 
    product,
    date,
    monthly_quantity,
    LAG(monthly_quantity) OVER (PARTITION BY product ORDER BY date) AS previous_month_quantity,
    ROUND(((monthly_quantity - LAG(monthly_quantity) OVER (PARTITION BY product ORDER BY date)) / 
           LAG(monthly_quantity) OVER (PARTITION BY product ORDER BY date) * 100), 2) AS mom_growth_pct
FROM monthly_sales
ORDER BY date, product;

-- ============================================================================
--Insight:- Large positive spikes occur during festive demand, while off-season months show temporary declines.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Customer Segmentation 
-- ----------------------------------------------------------------------------
WITH customer_metrics AS (
    SELECT 
        c.customer_code,
        c.customer,
        c.channel,
        c.platform,
        c.market,
        c.region,
        COUNT(DISTINCT MONTH(s.date)) AS purchase_frequency,
        SUM(s.sold_quantity) AS total_quantity_purchased,
        SUM(s.sold_quantity * g.gross_price) AS unique_products_purchased,
        AVG(s.sold_quantity * g.gross_price) AS total_gross_revenue,
        SUM(s.sold_quantity * g.gross_price) AS revenue_contribution_pct
    FROM fact_sales_monthly s
    JOIN dim_customer c ON s.customer_code = c.customer_code
    JOIN fact_gross_price g ON s.product_code = g.product_code AND s.fiscal_year = g.fiscal_year
    GROUP BY c.customer_code, c.customer, c.channel, c.platform, c.market, c.region
)
SELECT 
    customer_code,
    customer,
    channel,
    platform,
    market,
    region,
    purchase_frequency,
    total_quantity_purchased,
    unique_products_purchased,
    total_gross_revenue,
    revenue_contribution_pct,
    CASE 
        WHEN total_gross_revenue > 500000 THEN 'High Value'
        WHEN total_gross_revenue > 200000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_metrics
ORDER BY total_gross_revenue DESC;


-- ============================================================================
--Insight:- High-value customers contribute a disproportionate share of revenue, creating concentration risk.
-- ============================================================================


-- ----------------------------------------------------------------------------
--  Product Performance Overview
-- ----------------------------------------------------------------------------
SELECT 
    p.product_code,
    p.product,
    p.category,
    p.segment,
    p.division,
    SUM(s.sold_quantity) AS total_quantity_sold,
    SUM(s.sold_quantity * g.gross_price) AS total_gross_revenue,
    AVG(g.gross_price) AS avg_gross_price,
    COUNT(DISTINCT s.customer_code) AS unique_customers,
    COUNT(DISTINCT MONTH(s.date)) AS sales_months
FROM fact_sales_monthly s
JOIN dim_product p ON s.product_code = p.product_code
JOIN fact_gross_price g ON s.product_code = g.product_code AND s.fiscal_year = g.fiscal_year
GROUP BY p.product_code, p.product, p.category, p.segment, p.division
ORDER BY total_gross_revenue DESC;


-- ============================================================================
--Insight:- Accessories and peripherals lead in volume, while laptops contribute higher margins per unit.
-- ============================================================================


-- ----------------------------------------------------------------------------
--Category & Division Performance
-- ----------------------------------------------------------------------------
-- By Division
SELECT 
    p.division,
    p.category,
    COUNT(DISTINCT p.product_code) AS product_count,
    SUM(s.sold_quantity) AS total_quantity_sold,
    SUM(s.sold_quantity * g.gross_price) AS total_revenue,
    AVG(g.gross_price) AS avg_price
FROM fact_sales_monthly s
JOIN dim_product p ON s.product_code = p.product_code
JOIN fact_gross_price g ON s.product_code = g.product_code AND s.fiscal_year = g.fiscal_year
GROUP BY p.division, p.category
ORDER BY p.division, total_revenue DESC;

-- By Product Detail
SELECT 
    p.product_code,
    p.product,
    p.category,
    SUM(s.sold_quantity) AS total_quantity_sold,
    SUM(s.sold_quantity * g.gross_price) AS total_gross_revenue
FROM fact_sales_monthly s
JOIN dim_product p ON s.product_code = p.product_code
JOIN fact_gross_price g ON s.product_code = g.product_code AND s.fiscal_year = g.fiscal_year
GROUP BY p.product_code, p.product, p.category
ORDER BY total_gross_revenue DESC;


-- ============================================================================
--Insight:-P&A; division drives volume, N&S; division drives profitability
-- ============================================================================


-- ----------------------------------------------------------------------------
--  Market Demand Forecast 
-- ----------------------------------------------------------------------------
SELECT 
    c.market,
    c.region,
    f.fiscal_year,
    SUM(f.forecast_quantity) AS total_forecast_quantity
FROM fact_forecast_monthly f
JOIN dim_customer c ON f.customer_code = c.customer_code
GROUP BY c.market, c.region, f.fiscal_year
ORDER BY total_forecast_quantity DESC;


-- ============================================================================
--Insight:- India leads forecast demand, followed by USA and Canada.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- Demand Fulfillment Analysis 
-- ----------------------------------------------------------------------------
SELECT 
    c.market,
    c.region,
    COUNT(DISTINCT c.customer_code) AS customer_count,
    SUM(f.forecast_quantity) AS total_forecast_demand,
    SUM(s.sold_quantity) AS total_actual_sales,
    SUM(f.forecast_quantity) - SUM(s.sold_quantity) AS unfulfilled_demand,
    ROUND((SUM(s.sold_quantity) / SUM(f.forecast_quantity) * 100), 2) AS demand_fulfillment_pct
FROM fact_forecast_monthly f
JOIN fact_sales_monthly s ON f.date = s.date 
    AND f.product_code = s.product_code 
    AND f.customer_code = s.customer_code
JOIN dim_customer c ON f.customer_code = c.customer_code
GROUP BY c.market, c.region
ORDER BY total_forecast_demand DESC;


-- ============================================================================
--Insight:-Fulfillment exceeds 94% across all markets, indicating strong supply chain execution
-- ============================================================================


-- ----------------------------------------------------------------------------
--  Profitability & Cost Analysis 
-- ----------------------------------------------------------------------------
SELECT 
    p.product_code,
    p.product,
    p.category,
    p.division,
    AVG(g.gross_price) AS avg_gross_price,
    AVG(m.manufacturing_cost) AS avg_manufacturing_cost,
    AVG(g.gross_price) - AVG(m.manufacturing_cost) AS avg_gross_margin,
    ROUND(((AVG(g.gross_price) - AVG(m.manufacturing_cost)) / AVG(g.gross_price) * 100), 2) AS gross_margin_pct
FROM dim_product p
JOIN fact_gross_price g ON p.product_code = g.product_code
JOIN fact_manufacturing_cost m ON p.product_code = m.product_code AND g.fiscal_year = m.cost_year
GROUP BY p.product_code, p.product, p.category, p.division
ORDER BY gross_margin_pct DESC;


-- ============================================================================
--Insight:- Accessories show 50%+ margins, while laptops deliver high absolute margins.
-- ============================================================================


-- ----------------------------------------------------------------------------
--  Discount Impact Analysis 
-- ----------------------------------------------------------------------------
SELECT 
    p.product,
    p.category,
    g.gross_price,
    m.manufacturing_cost,
    g.gross_price - m.manufacturing_cost AS gross_margin,
    ROUND(((g.gross_price - m.manufacturing_cost) / g.gross_price * 100), 2) AS margin_pct
FROM dim_product p
JOIN fact_gross_price g ON p.product_code = g.product_code
JOIN fact_manufacturing_cost m ON p.product_code = m.product_code
WHERE g.fiscal_year = 2023
ORDER BY margin_pct DESC;


-- ============================================================================
--Insight:- Medium discount tiers achieve the best balance between volume and revenue.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- Seasonal Sales Contribution 
-- ----------------------------------------------------------------------------
-- Monthly totals
SELECT 
    MONTH(date) AS month_number,
    MONTHNAME(date) AS month_name,
    SUM(sold_quantity) AS total_quantity,
    AVG(sold_quantity) AS avg_quantity,
    COUNT(*) AS transaction_count,
    ROUND((SUM(sold_quantity) / (SELECT SUM(sold_quantity) FROM fact_sales_monthly) * 100), 2) AS sales_contribution_pct
FROM fact_sales_monthly
GROUP BY MONTH(date), MONTHNAME(date)
ORDER BY month_number;

-- By category per month
SELECT 
    MONTH(s.date) AS month_number,
    MONTHNAME(s.date) AS month_name,
    p.category,
    SUM(s.sold_quantity) AS total_quantity
FROM fact_sales_monthly s
JOIN dim_product p ON s.product_code = p.product_code
GROUP BY MONTH(s.date), MONTHNAME(s.date), p.category
ORDER BY month_number, category;


-- ============================================================================
--Insight:- High discounts do not consistently increase volume; optimization is preferable
-- ============================================================================

-- ----------------------------------------------------------------------------
 
-- ============================================================================
--Category-wise Seasonal Trends
-- ============================================================================
 
-- Customer lifecycle details with loyalty segment classification
SELECT 
    c.customer_code,
    c.customer,
    c.channel,
    c.market,

    COUNT(DISTINCT s.date) AS purchase_months,
    MIN(s.date) AS first_purchase_date,
    MAX(s.date) AS last_purchase_date,
    DATEDIFF(MONTH, MIN(s.date), MAX(s.date)) + 1 AS customer_lifetime_months,

    SUM(s.sold_quantity) AS total_quantity_purchased,

    SUM(s.sold_quantity * g.gross_price) AS total_revenue,

    ROUND(
        SUM(s.sold_quantity * g.gross_price) / 
        NULLIF(COUNT(DISTINCT s.date), 0), 
    2) AS avg_revenue_per_month,

    CASE 
        WHEN COUNT(DISTINCT s.date) >= 6 THEN 'Loyal'
        WHEN COUNT(DISTINCT s.date) >= 3 THEN 'Moderate'
        ELSE 'New/Occasional'
    END AS loyalty_segment

FROM dim_customer c

JOIN fact_sales_monthly s 
    ON c.customer_code = s.customer_code

JOIN fact_gross_price g 
    ON s.product_code = g.product_code 
    AND s.fiscal_year = g.fiscal_year

GROUP BY 
    c.customer_code, 
    c.customer, 
    c.channel, 
    c.market

ORDER BY total_revenue DESC;
-- ============================================================================
--Insight:- Accessories dominate festive months while laptops peak toward year-end.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Discount Tier vs Sales Volume (PDF Page 13)
-- ----------------------------------------------------------------------------
WITH discount_data AS (
    SELECT 
        s.customer_code,
        s.sold_quantity,
        CASE 
            WHEN pre.pre_invoice_discount_pct >= 8 THEN 'High (8%+)'
            WHEN pre.pre_invoice_discount_pct >= 6 THEN 'Medium (6-8%)'
            ELSE 'Low (0-6%)'
        END AS discount_tier
    FROM fact_sales_monthly s
    JOIN fact_pre_invoice_deductions pre 
        ON s.customer_code = pre.customer_code 
        AND s.fiscal_year = pre.fiscal_year
)

SELECT 
    discount_tier,
    COUNT(DISTINCT customer_code) AS customer_count,
    SUM(sold_quantity) AS total_quantity_sold,
    ROUND(AVG(sold_quantity), 0) AS avg_quantity_per_transaction
FROM discount_data
GROUP BY discount_tier
ORDER BY total_quantity_sold DESC;

-- ============================================================================
--Insight:- Medium discounts generate the highest total volume, while high discounts increase order size but reduce customer count.
-- ============================================================================


 
-- ----------------------------------------------------------------------------
-- QUERY 12: Logistics Cost by Market (PDF Page 14)
-- ----------------------------------------------------------------------------
SELECT 
    market,
    fiscal_year,

    ROUND(AVG(freight_pct), 2) AS avg_freight_pct,
    ROUND(AVG(other_cost_pct), 2) AS avg_other_cost_pct,

    -- Better: calculate total first, then average
    ROUND(AVG(freight_pct + other_cost_pct), 2) AS total_logistics_cost_pct

FROM dbo.fact_freight_cost

GROUP BY 
    market, 
    fiscal_year

ORDER BY 
    market, 
    fiscal_year

-- ============================================================================
--Insight:-  USA and Canada show higher logistics costs compared to India, impacting margin planning
-- ============================================================================

-- ----------------------------------------------------------------------------
-- QUERY 13: Freight Cost Outlier Detection 
-- ----------------------------------------------------------------------------
WITH freight_stats AS (
    SELECT 
        AVG(freight_pct) AS avg_freight,
        STDDEV(freight_pct) AS stddev_freight
    FROM fact_freight_cost
)
SELECT 
    f.market,
    f.fiscal_year,
    f.freight_pct,
    ROUND(fs.avg_freight, 2) AS avg_freight,
    CASE 
        WHEN ABS(f.freight_pct - fs.avg_freight) > 2 * fs.stddev_freight THEN 'Outlier'
        ELSE 'Normal'
    END AS freight_cost_status
FROM fact_freight_cost f
CROSS JOIN freight_stats fs
ORDER BY f.fiscal_year, f.market;
 -- ============================================================================
--Insight:- No significant outliers detected, indicating stable logistics operations
-- ============================================================================
-- ----------------------------------------------------------------------------
--  Seasonal Sales Contribution 
-- ----------------------------------------------------------------------------
SELECT 
    MONTH(date) AS month_number,
    DATENAME(MONTH, date) AS month_name,

    SUM(sold_quantity) AS total_quantity,
    ROUND(AVG(sold_quantity), 0) AS avg_quantity,
    COUNT(*) AS transaction_count,

    ROUND(
        SUM(sold_quantity) * 100.0 / 
        (SELECT SUM(sold_quantity) FROM fact_sales_monthly), 
    2) AS sales_contribution_pct

FROM fact_sales_monthly

GROUP BY 
    MONTH(date), 
    DATENAME(MONTH, date)

ORDER BY month_number;;

 -- ============================================================================
--Insight:- September and October contribute over 45% of total annual volume, indicating strong seasonality
-- ============================================================================
-- ----------------------------------------------------------------------------
--  Channel Performance Comparison
-- ----------------------------------------------------------------------------
SELECT 
    c.channel,
    c.platform,

    COUNT(DISTINCT c.customer_code) AS total_customers,

    SUM(s.sold_quantity) AS total_quantity,

    SUM(CAST(s.sold_quantity * g.gross_price AS FLOAT)) AS total_revenue,

    ROUND(
        SUM(CAST(s.sold_quantity * g.gross_price AS FLOAT)) 
        / NULLIF(COUNT(DISTINCT c.customer_code), 0), 
    2) AS revenue_per_customer,

    ROUND(
        SUM(s.sold_quantity) * 1.0 
        / NULLIF(COUNT(DISTINCT c.customer_code), 0), 
    2) AS avg_quantity_per_customer

FROM fact_sales_monthly s

JOIN dim_customer c 
    ON s.customer_code = c.customer_code

JOIN fact_gross_price g 
    ON s.product_code = g.product_code 
    AND s.fiscal_year = g.fiscal_year

GROUP BY 
    c.channel, 
    c.platform

ORDER BY total_revenue DESC;

 -- ============================================================================
--Insight:- Retail Brick & Mortar dominates revenue, while E-commerce shows higher efficiency per customer.
-- ============================================================================


-- ----------------------------------------------------------------------------
--  Churn Risk Analysis
-- ---------------------------------------------------------------------------------------------------------

SELECT 
    c.customer_code,
    c.customer,
    c.channel,
    c.market,

    MAX(s.date) AS last_purchase_date,

    DATEDIFF(DAY, MAX(s.date), GETDATE()) AS days_since_last_purchase,

    COUNT(DISTINCT s.date) AS purchase_frequency,

    SUM(s.sold_quantity * g.gross_price) AS total_revenue,

    CASE 
        WHEN DATEDIFF(DAY, MAX(s.date), GETDATE()) > 180 THEN 'High Risk'
        WHEN DATEDIFF(DAY, MAX(s.date), GETDATE()) > 90 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS churn_risk_segment

FROM fact_sales_monthly s

JOIN dim_customer c 
    ON s.customer_code = c.customer_code

JOIN fact_gross_price g 
    ON s.product_code = g.product_code 
    AND s.fiscal_year = g.fiscal_year

GROUP BY 
    c.customer_code, 
    c.customer, 
    c.channel, 
    c.market

ORDER BY days_since_last_purchase DESC;

 -- ============================================================================
--Insight:- All listed customers show declining engagement, requiring targeted retention actions.
-- ============================================================================
 
-- ----------------------------------------------------------------------------
-- Category-wise Seasonal Trends
-- ----------------------------------------------------------------------------
SELECT 
    c.customer_code,
    c.customer,
    c.channel,
    c.market,
    COUNT(DISTINCT MONTH(s.date)) AS purchase_months,
    COUNT(DISTINCT s.date) AS total_unique_sale_dates,
    SUM(s.sold_quantity * g.gross_price) AS total_revenue,
    ROUND(AVG(s.sold_quantity * g.gross_price), 2) AS avg_revenue,
    CASE 
        WHEN COUNT(DISTINCT MONTH(s.date)) >= 3 THEN 'New/Occasional'
        ELSE 'Moderate'
    END AS loyalty_segment,
    ROUND((SUM(s.sold_quantity * g.gross_price) / COUNT(DISTINCT s.date)), 2) AS avg_revenue_per_month
FROM dim_customer c
JOIN fact_sales_monthly s ON c.customer_code = s.customer_code
JOIN fact_gross_price g ON s.product_code = g.product_code AND s.fiscal_year = g.fiscal_year
GROUP BY c.customer_code, c.customer, c.channel, c.market
ORDER BY purchase_months DESC;
  -- ============================================================================
--Insight:- Accessories dominate festive months while laptops peak toward year-end.
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Customer Loyalty & Retention
-- ----------------------------------------------------------------------------
SELECT 
    c.customer,
    c.market,
    c.channel,
    COUNT(DISTINCT MONTH(s.date)) AS active_months,
    COUNT(DISTINCT s.date) AS total_purchases,
    CASE 
        WHEN COUNT(DISTINCT MONTH(s.date)) >= 4 THEN 'Loyal'
        WHEN COUNT(DISTINCT MONTH(s.date)) >= 2 THEN 'Moderate'
        ELSE 'At Risk'
    END AS churn_risk
FROM dim_customer c
LEFT JOIN fact_sales_monthly s ON c.customer_code = s.customer_code
GROUP BY c.customer, c.market, c.channel
ORDER BY active_months DESC;
  -- ============================================================================
--Insight:-  Most customers fall under New/Occasional or Moderate segments, showing retention improvement opportunity.
-- ============================================================================



-- ============================================================================
 
-- ----------------------------------------------------------------------------
--Customer Lifetime Value (CLV) Analysis
-- ----------------------------------------------------------------------------
SELECT 
    c.channel,
    c.market,
    COUNT(DISTINCT c.customer_code) AS customer_count,
    ROUND(AVG(customer_revenue.total_revenue), 2) AS avg_order_value,
    ROUND(AVG(customer_revenue.purchase_frequency), 2) AS avg_purchase_frequency,
    ROUND(AVG(customer_revenue.total_revenue), 2) AS avg_total_revenue,
    ROUND(AVG(customer_revenue.total_revenue) * 3, 2) AS estimated_clv
FROM dim_customer c
JOIN (
    SELECT 
        customer_code,
        COUNT(DISTINCT date) AS purchase_frequency,
        SUM(s.sold_quantity * g.gross_price) AS total_revenue
    FROM fact_sales_monthly s
    JOIN fact_gross_price g ON s.product_code = g.product_code AND s.fiscal_year = g.fiscal_year
    GROUP BY customer_code
) AS customer_revenue ON c.customer_code = customer_revenue.customer_code
GROUP BY c.channel, c.market
ORDER BY estimated_clv DESC;
  -- ============================================================================
--Insight:-  Retail customers in India generate the highest CLV, indicating strong repeat purchase potential
-- ============================================================================
-- ----------------------------------------------------------------------------
-- QUERY 18: Inventory Classification & Safety Stock (PDF Page 25)
-- ----------------------------------------------------------------------------
WITH product_velocity AS (
    SELECT 
        p.product_code,
        p.product,
        p.category,
        SUM(s.sold_quantity) AS total_sold,
        SUM(f.forecast_quantity) AS total_forecast,
        COUNT(DISTINCT MONTH(s.date)) AS sales_months,
        ROUND(SUM(s.sold_quantity) / NULLIF(COUNT(DISTINCT MONTH(s.date)), 0), 2) AS avg_monthly_sales
    FROM dim_product p
    LEFT JOIN fact_sales_monthly s ON p.product_code = s.product_code
    LEFT JOIN fact_forecast_monthly f ON p.product_code = f.product_code
    GROUP BY p.product_code, p.product, p.category
)
SELECT 
    product_code,
    product,
    category,
    total_sold,
    total_forecast,
    sales_months,
    avg_monthly_sales,
    CASE 
        WHEN total_sold IS NULL THEN 'No Sales'
        WHEN avg_monthly_sales >= 1000 THEN 'Fast Moving'
        WHEN avg_monthly_sales >= 300 THEN 'Medium Moving'
        ELSE 'Slow Moving'
    END AS inventory_classification,
    CASE 
        WHEN total_sold IS NULL THEN NULL
        WHEN avg_monthly_sales >= 1000 THEN ROUND(avg_monthly_sales * 3, 2)
        WHEN avg_monthly_sales >= 300 THEN ROUND(avg_monthly_sales * 2, 2)
        ELSE ROUND(avg_monthly_sales * 1.5, 2)
    END AS recommended_safety_stock
FROM product_velocity
ORDER BY avg_monthly_sales DESC;
  -- ============================================================================
--Insight:-  Fast-moving products require higher safety stock, while no-sales items indicate dead inventory
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Monthly Product Ranking (Window Functions)
-- ----------------------------------------------------------------------------
WITH monthly_product_sales AS (
    SELECT 
        s.fiscal_year,
        MONTH(s.date) AS month_number,
        DATENAME(MONTH, s.date) AS month_name,
        s.product_code,
        SUM(s.sold_quantity) AS total_quantity
    FROM fact_sales_monthly s
    GROUP BY 
        s.fiscal_year,
        MONTH(s.date),
        DATENAME(MONTH, s.date),
        s.product_code
)

SELECT 
    fiscal_year,
    month_name,
    product_code,
    total_quantity,

    RANK() OVER (
        PARTITION BY fiscal_year, month_number 
        ORDER BY total_quantity DESC
    ) AS sales_rank,

    DENSE_RANK() OVER (
        PARTITION BY fiscal_year, month_number 
        ORDER BY total_quantity DESC
    ) AS dense_sales_rank,

    ROW_NUMBER() OVER (
        PARTITION BY fiscal_year, month_number 
        ORDER BY total_quantity DESC
    ) AS row_num

FROM monthly_product_sales

ORDER BY 
    fiscal_year, 
    month_number, 
    sales_rank;
  -- ============================================================================
--Insight:- Ranking identifies consistent top performers useful for promotion and inventory planning
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Customer-Product Relationship Mapping
-- ----------------------------------------------------------------------------
WITH distinct_customers AS (
    SELECT DISTINCT
        s.product_code,
        c.customer_code,
        c.customer
    FROM fact_sales_monthly s
    JOIN dim_customer c 
        ON s.customer_code = c.customer_code
)

SELECT 
    p.product_code,
    p.product,
    p.category,

    STRING_AGG(dc.customer, ', ') AS customers_list,

    COUNT(DISTINCT dc.customer_code) AS unique_customer_count

FROM distinct_customers dc

JOIN dim_product p 
    ON dc.product_code = p.product_code

GROUP BY 
    p.product_code, 
    p.product, 
    p.category

ORDER BY unique_customer_count DESC;
  -- ============================================================================
--Insight:- Products with broader customer reach are less risky and more scalable
-- ============================================================================
-- ----------------------------------------------------------------------------
--  Month-over-Month Sales Change (LEAD/LAG)
-- ----------------------------------------------------------------------------
WITH monthly_product_sales AS (
    SELECT 
        p.product,
        s.date,
        SUM(s.sold_quantity) AS current_month_sales
    FROM fact_sales_monthly s
    JOIN dim_product p ON s.product_code = p.product_code
    GROUP BY p.product, s.date
)
SELECT 
    product,
    date,
    current_month_sales,
    LAG(current_month_sales) OVER (PARTITION BY product ORDER BY date) AS previous_month_sales,
    LEAD(current_month_sales) OVER (PARTITION BY product ORDER BY date) AS next_month_sales,
    current_month_sales - LAG(current_month_sales) OVER (PARTITION BY product ORDER BY date) AS mom_change,
    ROUND(((current_month_sales - LAG(current_month_sales) OVER (PARTITION BY product ORDER BY date)) / 
           NULLIF(LAG(current_month_sales) OVER (PARTITION BY product ORDER BY date), 0) * 100), 2) AS mom_change_pct
FROM monthly_product_sales
ORDER BY product, date;
  -- ============================================================================
--Insight:- Sharp spikes highlight seasonal demand surges requiring proactive planning.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Top Selling Products by Market 
-- ----------------------------------------------------------------------------
WITH market_product_ranking AS (
    SELECT 
        c.market,
        p.product_code,
        p.product,
        p.category,
        SUM(s.sold_quantity) AS total_quantity,
        RANK() OVER (PARTITION BY c.market ORDER BY SUM(s.sold_quantity) DESC) AS rank_in_market
    FROM fact_sales_monthly s
    JOIN dim_product p ON s.product_code = p.product_code
    JOIN dim_customer c ON s.customer_code = c.customer_code
    GROUP BY c.market, p.product_code, p.product, p.category
)
SELECT 
    market,
    product_code,
    product,
    category,
    total_quantity,
    rank_in_market
FROM market_product_ranking
WHERE rank_in_market <= 3
ORDER BY market, rank_in_market;
  -- ============================================================================
--Insight:-  Market-level leaders differ, enabling localized assortment strategies.
-- ============================================================================
-- ----------------------------------------------------------------------------
-- Forecast Accuracy by Category and Quarter 
-- ----------------------------------------------------------------------------
-- Overall accuracy
SELECT 
    COUNT(*) AS total_forecasts,

    ROUND(
        AVG(
            (CAST(s.sold_quantity AS FLOAT) / NULLIF(f.forecast_quantity, 0)) * 100
        ), 
    2) AS overall_accuracy_pct,

    SUM(f.forecast_quantity) AS total_forecast_qty,
    SUM(s.sold_quantity) AS total_actual_qty,

    ABS(SUM(f.forecast_quantity) - SUM(s.sold_quantity)) AS total_variance,

    ROUND(
        (CAST(SUM(s.sold_quantity) AS FLOAT) / NULLIF(SUM(f.forecast_quantity), 0)) * 100,
    2) AS fulfillment_rate_pct

FROM fact_forecast_monthly f
JOIN fact_sales_monthly s 
    ON f.date = s.date 
    AND f.product_code = s.product_code 
    AND f.customer_code = s.customer_code;
-- By category
SELECT 
    p.category,

    COUNT(*) AS forecast_count,

    ROUND(
        AVG(
            (CAST(s.sold_quantity AS FLOAT) / NULLIF(f.forecast_quantity, 0)) * 100
        ),
    2) AS avg_accuracy_pct

FROM fact_forecast_monthly f
JOIN fact_sales_monthly s 
    ON f.date = s.date 
    AND f.product_code = s.product_code 
    AND f.customer_code = s.customer_code

JOIN dim_product p 
    ON f.product_code = p.product_code

GROUP BY p.category

ORDER BY avg_accuracy_pct DESC;
 
-- By fiscal quarter
SELECT 
    CASE 
        WHEN MONTH(f.date) IN (9, 10, 11) THEN 'Q1 (Sep-Nov)'
        WHEN MONTH(f.date) IN (12, 1, 2) THEN 'Q2 (Dec-Feb)'
        WHEN MONTH(f.date) IN (3, 4, 5) THEN 'Q3 (Mar-May)'
        WHEN MONTH(f.date) IN (6, 7, 8) THEN 'Q4 (Jun-Aug)'
    END AS fiscal_quarter,

    ROUND(
        AVG(
            (CAST(s.sold_quantity AS FLOAT) / NULLIF(f.forecast_quantity, 0)) * 100
        ),
    2) AS avg_accuracy_pct,

    COUNT(*) AS forecast_count

FROM fact_forecast_monthly f
JOIN fact_sales_monthly s 
    ON f.date = s.date 
    AND f.product_code = s.product_code 
    AND f.customer_code = s.customer_code

GROUP BY 
    CASE 
        WHEN MONTH(f.date) IN (9, 10, 11) THEN 'Q1 (Sep-Nov)'
        WHEN MONTH(f.date) IN (12, 1, 2) THEN 'Q2 (Dec-Feb)'
        WHEN MONTH(f.date) IN (3, 4, 5) THEN 'Q3 (Mar-May)'
        WHEN MONTH(f.date) IN (6, 7, 8) THEN 'Q4 (Jun-Aug)'
    END

ORDER BY avg_accuracy_pct DESC;
  -- ============================================================================
--Insight:- Overall forecast accuracy exceeds 95%, with Q4 showing the highest accuracy
 
-- ============================================================================

-- ----------------------------------------------------------------------------
--  Product Mix Optimization
-- ----------------------------------------------------------------------------
WITH product_metrics AS (
    SELECT 
        p.product_code,
        p.product,
        p.category,
        p.division,
        SUM(s.sold_quantity) AS total_sold,
        ROUND(AVG(g.gross_price), 2) AS avg_gross,
        ROUND(AVG(m.manufacturing_cost), 2) AS avg_cost,
        ROUND(AVG(g.gross_price) - AVG(m.manufacturing_cost), 2) AS avg_margin,
        ROUND(((AVG(g.gross_price) - AVG(m.manufacturing_cost)) / NULLIF(AVG(g.gross_price), 0) * 100), 2) AS margin_pct,
        ROUND(SUM(s.sold_quantity * (g.gross_price - m.manufacturing_cost)), 2) AS total_profit_contribution
    FROM fact_sales_monthly s
    JOIN dim_product p ON s.product_code = p.product_code
    JOIN fact_gross_price g ON s.product_code = g.product_code AND s.fiscal_year = g.fiscal_year
    JOIN fact_manufacturing_cost m ON s.product_code = m.product_code AND s.fiscal_year = m.cost_year
    GROUP BY p.product_code, p.product, p.category, p.division
)
SELECT 
    product_code,
    product,
    category,
    division,
    total_sold,
    avg_gross,
    avg_cost,
    avg_margin,
    margin_pct,
    total_profit_contribution,
    CASE 
        WHEN margin_pct > 45 AND total_sold > 2000 THEN 'Star Product'
        WHEN margin_pct > 45 THEN 'High Margin - Low Volume'
        WHEN total_sold > 2000 THEN 'High Volume - Low Margin'
        ELSE 'Optimize or Discontinue'
    END AS product_classification
FROM product_metrics
ORDER BY total_profit_contribution DESC;

  -- ============================================================================
--Insight:-  Star products combine high margins and high volume, while some products need portfolio rationalization
 
-- ============================================================================

 
 
-- ============================================================================
--MasterInsights Report
-- ===========================================================================================================================================
/*

Monthly Sales Trend Analysis
How do product sales vary across months and years?
Comprehensive Analysis: Sales show strong seasonality with peaks in September and October driven by festive
demand. Accessories dominate volumes, while laptops maintain steady but lower unit movement. This insight
supports demand forecasting, seasonal workforce planning, and inventory buildup strategies.


Month-over-Month Growth Analysis
How do product sales change month-over-month?
Comprehensive Analysis: Significant MoM spikes indicate promotions or festive demand, while declines represent
demand normalization. Tracking MoM trends enables early detection of volatility and proactive supply adjustments.


Customer Segmentation
How are customers segmented based on revenue contribution?
Comprehensive Analysis: A small group of high-value customers contributes a disproportionate share of revenue,
creating dependency risk. Medium- and low-value customers represent growth potential through targeted
engagement strategies.


Product Performance
Which products generate the highest sales and revenue?
Comprehensive Analysis: High-volume accessories ensure revenue stability, while laptops contribute higher
margins per unit. A balanced product portfolio optimizes both scale and profitability.



Category & Division Performance
How do categories and divisions perform overall?
Comprehensive Analysis: Peripherals and Accessories dominate sales volume, while Notebook & Storage
divisions generate higher unit value. Strategic focus should balance high-volume and high-margin segments.



Market Demand Forecast
Which markets show the highest forecasted demand?
Comprehensive Analysis: India leads forecasted demand, validating continued investment. USA and Canada
present selective growth opportunities requiring targeted expansion.



Demand Fulfillment Analysis
How effectively is forecasted demand fulfilled?
Comprehensive Analysis: Demand fulfillment exceeds 94% across all markets, reflecting strong coordination
between planning and execution



Cost & Profitability Analysis
Which products deliver the strongest profitability?
Comprehensive Analysis: Accessories achieve margins above 50%, while laptops generate high absolute profit
despite lower margin percentages. Pricing strategies should preserve margin while supporting volume.



Discount Impact Analysis
How do discounts affect revenue and volume?
Comprehensive Analysis: Medium discount levels deliver the optimal balance between volume growth and margin
protection. Excessive discounting increases volume but erodes profitability.



Seasonal Sales Patterns
Which months and categories contribute most to annual sales?
Comprehensive Analysis: September and October account for over 45% of annual volume, largely driven by
accessories. Seasonal planning should prioritize inventory and logistics readiness for these peak periods.



Customer Loyalty & Churn
Which customers are loyal and which are at risk of churn?
Comprehensive Analysis: Most customers fall into new or occasional segments, with several accounts at churn
risk. Retention initiatives and account-level engagement are critical.



Forecast Accuracy
How accurate are demand forecasts?
Comprehensive Analysis: Overall forecast accuracy exceeds 95%, with the highest accuracy in Q4. Forecast
models are reliable but require continuous monitoring.



Channel Performance
Which sales channels perform best?
Comprehensive Analysis: Retail Brick & Mortar generates the highest revenue, while E-commerce delivers
greater efficiency per customer.



Inventory Management
Which products are fast-, medium-, or slow-moving?
Comprehensive Analysis: Fast-moving products require higher safety stock, while no-sales items indicate dead
inventory that should be rationalized.



Product Mix Optimization
Which products should be prioritized in the portfolio?
Comprehensive Analysis: Star products combine high margin and high volume, forming the core portfolio.
Low-volume products require optimization or phase-out decisions.



Customer Lifetime Value
Which customers generate the highest lifetime value?
Comprehensive Analysis: Retail customers in India show the highest CLV, indicating strong long-term profitability
potential.  */


