-- =============================================================
--  PROJECT 2: E-Commerce Order Analytics
--  Dialect : MySQL 8.x
--  Author  : Vrushabh Patil
--  Topics  : CTEs · Window Functions · Revenue & Sales Analysis
--            · Customer Segmentation
--  Queries : 22
-- =============================================================


-- -------------------------------------------------------------
-- 0. DATABASE SETUP
-- -------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;


-- -------------------------------------------------------------
-- 1. TABLE DEFINITIONS
-- -------------------------------------------------------------

-- 1a. customers
CREATE TABLE customers (
    customer_id   INT          PRIMARY KEY,
    first_name    VARCHAR(50),
    last_name     VARCHAR(50),
    email         VARCHAR(80),
    city          VARCHAR(50),
    signup_date   DATE
);

-- 1b. categories
CREATE TABLE categories (
    category_id   INT          PRIMARY KEY,
    category_name VARCHAR(50)
);

-- 1c. products
CREATE TABLE products (
    product_id    INT           PRIMARY KEY,
    product_name  VARCHAR(100),
    category_id   INT,
    price         DECIMAL(10,2),
    stock         INT,
    FOREIGN KEY (category_id) REFERENCES categories (category_id)
);

-- 1d. orders
CREATE TABLE orders (
    order_id      INT           PRIMARY KEY,
    customer_id   INT,
    order_date    DATE,
    status        VARCHAR(20),   -- 'Delivered', 'Pending', 'Cancelled'
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);

-- 1e. order_items
CREATE TABLE order_items (
    item_id       INT           PRIMARY KEY,
    order_id      INT,
    product_id    INT,
    quantity      INT,
    unit_price    DECIMAL(10,2),
    FOREIGN KEY (order_id)   REFERENCES orders   (order_id),
    FOREIGN KEY (product_id) REFERENCES products (product_id)
);


-- -------------------------------------------------------------
-- 2. SEED DATA
-- -------------------------------------------------------------

-- 2a. customers
INSERT INTO customers VALUES
    (1,  'Aanya',   'Iyer',     'aanya.iyer@mail.com',     'Mumbai',    '2021-03-10'),
    (2,  'Rohan',   'Mehta',    'rohan.mehta@mail.com',    'Delhi',     '2021-07-22'),
    (3,  'Sneha',   'Pillai',   'sneha.pillai@mail.com',   'Bangalore', '2022-01-05'),
    (4,  'Karan',   'Sharma',   'karan.sharma@mail.com',   'Pune',      '2022-04-18'),
    (5,  'Divya',   'Nair',     'divya.nair@mail.com',     'Chennai',   '2022-08-30'),
    (6,  'Arjun',   'Das',      'arjun.das@mail.com',      'Mumbai',    '2023-01-14'),
    (7,  'Priya',   'Singh',    'priya.singh@mail.com',    'Delhi',     '2023-05-09'),
    (8,  'Vikram',  'Joshi',    'vikram.joshi@mail.com',   'Hyderabad', '2023-09-21'),
    (9,  'Meena',   'Rao',      'meena.rao@mail.com',      'Bangalore', '2024-02-11'),
    (10, 'Nikhil',  'Verma',    'nikhil.verma@mail.com',   'Pune',      '2024-06-03');

-- 2b. categories
INSERT INTO categories VALUES
    (1, 'Electronics'),
    (2, 'Clothing'),
    (3, 'Books'),
    (4, 'Home & Kitchen'),
    (5, 'Sports');

-- 2c. products
INSERT INTO products VALUES
    (101, 'Wireless Headphones',  1, 2999.00,  50),
    (102, 'Smartphone Stand',     1,  499.00, 120),
    (103, 'Running Shoes',        5, 3499.00,  30),
    (104, 'Yoga Mat',             5,  799.00,  75),
    (105, 'Cotton T-Shirt',       2,  399.00, 200),
    (106, 'Denim Jacket',         2, 1799.00,  40),
    (107, 'SQL for Beginners',    3,  349.00,  90),
    (108, 'Data Science Handbook',3,  499.00,  60),
    (109, 'Air Fryer',            4, 4999.00,  25),
    (110, 'Blender',              4, 2199.00,  35);

-- 2d. orders
INSERT INTO orders VALUES
    (1001, 1,  '2023-01-15', 'Delivered'),
    (1002, 2,  '2023-02-20', 'Delivered'),
    (1003, 3,  '2023-03-05', 'Cancelled'),
    (1004, 4,  '2023-04-10', 'Delivered'),
    (1005, 5,  '2023-05-18', 'Delivered'),
    (1006, 1,  '2023-06-22', 'Delivered'),
    (1007, 2,  '2023-07-30', 'Pending'),
    (1008, 6,  '2023-08-14', 'Delivered'),
    (1009, 7,  '2023-09-09', 'Delivered'),
    (1010, 3,  '2023-10-01', 'Delivered'),
    (1011, 8,  '2023-11-11', 'Delivered'),
    (1012, 9,  '2023-12-05', 'Cancelled'),
    (1013, 10, '2024-01-20', 'Delivered'),
    (1014, 4,  '2024-02-14', 'Delivered'),
    (1015, 5,  '2024-03-08', 'Delivered'),
    (1016, 6,  '2024-04-25', 'Delivered'),
    (1017, 7,  '2024-05-13', 'Delivered'),
    (1018, 1,  '2024-06-30', 'Pending');

-- 2e. order_items
INSERT INTO order_items VALUES
    (1, 1001, 101, 1, 2999.00),
    (2, 1001, 107, 2,  349.00),
    (3, 1002, 103, 1, 3499.00),
    (4, 1002, 105, 3,  399.00),
    (5, 1003, 109, 1, 4999.00),
    (6, 1004, 102, 2,  499.00),
    (7, 1004, 108, 1,  499.00),
    (8, 1005, 104, 1,  799.00),
    (9, 1005, 105, 2,  399.00),
   (10, 1006, 110, 1, 2199.00),
   (11, 1007, 106, 1, 1799.00),
   (12, 1008, 101, 2, 2999.00),
   (13, 1009, 103, 1, 3499.00),
   (14, 1010, 107, 3,  349.00),
   (15, 1010, 108, 1,  499.00),
   (16, 1011, 109, 1, 4999.00),
   (17, 1012, 104, 2,  799.00),
   (18, 1013, 102, 1,  499.00),
   (19, 1013, 110, 1, 2199.00),
   (20, 1014, 101, 1, 2999.00),
   (21, 1015, 106, 1, 1799.00),
   (22, 1016, 103, 1, 3499.00),
   (23, 1017, 105, 4,  399.00),
   (24, 1018, 108, 2,  499.00);


-- =============================================================
-- SECTION A · REVENUE & SALES ANALYSIS
-- =============================================================

-- Query 1: Total revenue from delivered orders only
SELECT
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM   order_items oi
JOIN   orders      o  ON oi.order_id = o.order_id
WHERE  o.status = 'Delivered';


-- Query 2: Monthly revenue trend
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS monthly_revenue
FROM   orders      o
JOIN   order_items oi ON o.order_id = oi.order_id
WHERE  o.status = 'Delivered'
GROUP BY month
ORDER BY month;


-- Query 3: Revenue by product category
SELECT
    c.category_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS category_revenue
FROM   order_items oi
JOIN   products    p  ON oi.product_id   = p.product_id
JOIN   categories  c  ON p.category_id   = c.category_id
JOIN   orders      o  ON oi.order_id     = o.order_id
WHERE  o.status = 'Delivered'
GROUP BY c.category_name
ORDER BY category_revenue DESC;


-- Query 4: Top 5 best-selling products by revenue
SELECT
    p.product_name,
    SUM(oi.quantity)                            AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)  AS revenue
FROM   order_items oi
JOIN   products    p  ON oi.product_id = p.product_id
JOIN   orders      o  ON oi.order_id   = o.order_id
WHERE  o.status = 'Delivered'
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 5;


-- Query 5: Average order value per customer
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name)      AS customer_name,
    COUNT(DISTINCT o.order_id)                   AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)   AS total_spent,
    ROUND(
        SUM(oi.quantity * oi.unit_price) /
        COUNT(DISTINCT o.order_id), 2
    )                                            AS avg_order_value
FROM   customers   c
JOIN   orders      o  ON c.customer_id = o.customer_id
JOIN   order_items oi ON o.order_id    = oi.order_id
WHERE  o.status = 'Delivered'
GROUP BY c.customer_id, customer_name
ORDER BY avg_order_value DESC;


-- Query 6: Orders by status breakdown
SELECT
    status,
    COUNT(*) AS order_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM orders
GROUP BY status;


-- =============================================================
-- SECTION B · CTEs (COMMON TABLE EXPRESSIONS)
-- =============================================================

-- Query 7: CTE — revenue per order, then average over all orders
WITH order_totals AS (
    SELECT
        o.order_id,
        o.customer_id,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS order_value
    FROM   orders      o
    JOIN   order_items oi ON o.order_id = oi.order_id
    WHERE  o.status = 'Delivered'
    GROUP BY o.order_id, o.customer_id
)
SELECT
    AVG(order_value) AS avg_order_value,
    MAX(order_value) AS max_order_value,
    MIN(order_value) AS min_order_value
FROM order_totals;


-- Query 8: CTE — identify high-value orders (above average)
WITH order_totals AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_date,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS order_value
    FROM   orders      o
    JOIN   order_items oi ON o.order_id = oi.order_id
    WHERE  o.status = 'Delivered'
    GROUP BY o.order_id, o.customer_id, o.order_date
),
avg_cte AS (
    SELECT AVG(order_value) AS avg_val FROM order_totals
)
SELECT ot.order_id, ot.customer_id, ot.order_date, ot.order_value
FROM   order_totals ot, avg_cte
WHERE  ot.order_value > avg_cte.avg_val
ORDER BY ot.order_value DESC;


-- Query 9: CTE — products that have never been ordered
WITH ordered_products AS (
    SELECT DISTINCT product_id FROM order_items
)
SELECT p.product_id, p.product_name, p.price
FROM   products p
WHERE  p.product_id NOT IN (SELECT product_id FROM ordered_products);


-- Query 10: Recursive-style CTE — cumulative revenue by month
WITH monthly AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m')         AS month,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS monthly_revenue
    FROM   orders      o
    JOIN   order_items oi ON o.order_id = oi.order_id
    WHERE  o.status = 'Delivered'
    GROUP BY month
)
SELECT
    month,
    monthly_revenue,
    ROUND(SUM(monthly_revenue) OVER (ORDER BY month), 2) AS cumulative_revenue
FROM monthly;


-- =============================================================
-- SECTION C · WINDOW FUNCTIONS
-- =============================================================

-- Query 11: RANK customers by total spend
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_spent,
    RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS spend_rank
FROM   customers   c
JOIN   orders      o  ON c.customer_id = o.customer_id
JOIN   order_items oi ON o.order_id    = oi.order_id
WHERE  o.status = 'Delivered'
GROUP BY c.customer_id, customer_name;


-- Query 12: ROW_NUMBER — assign unique row numbers within each category by revenue
SELECT
    c.category_name,
    p.product_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue,
    ROW_NUMBER() OVER (
        PARTITION BY c.category_name
        ORDER BY SUM(oi.quantity * oi.unit_price) DESC
    ) AS row_num
FROM   order_items oi
JOIN   products    p  ON oi.product_id = p.product_id
JOIN   categories  c  ON p.category_id = c.category_id
JOIN   orders      o  ON oi.order_id   = o.order_id
WHERE  o.status = 'Delivered'
GROUP BY c.category_name, p.product_name;


-- Query 13: DENSE_RANK — top product per category (no rank gaps)
WITH ranked AS (
    SELECT
        c.category_name,
        p.product_name,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue,
        DENSE_RANK() OVER (
            PARTITION BY c.category_name
            ORDER BY SUM(oi.quantity * oi.unit_price) DESC
        ) AS dr
    FROM   order_items oi
    JOIN   products    p  ON oi.product_id = p.product_id
    JOIN   categories  c  ON p.category_id = c.category_id
    JOIN   orders      o  ON oi.order_id   = o.order_id
    WHERE  o.status = 'Delivered'
    GROUP BY c.category_name, p.product_name
)
SELECT category_name, product_name, revenue
FROM   ranked
WHERE  dr = 1;


-- Query 14: LAG — month-over-month revenue change
WITH monthly AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m')         AS month,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
    FROM   orders      o
    JOIN   order_items oi ON o.order_id = oi.order_id
    WHERE  o.status = 'Delivered'
    GROUP BY month
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month)                              AS prev_month_revenue,
    ROUND(revenue - LAG(revenue) OVER (ORDER BY month), 2)         AS revenue_change,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month)) /
        LAG(revenue) OVER (ORDER BY month) * 100, 2
    )                                                               AS pct_change
FROM monthly;


-- Query 15: LEAD — peek at the next month's revenue
WITH monthly AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m')         AS month,
        ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
    FROM   orders      o
    JOIN   order_items oi ON o.order_id = oi.order_id
    WHERE  o.status = 'Delivered'
    GROUP BY month
)
SELECT
    month,
    revenue,
    LEAD(revenue) OVER (ORDER BY month) AS next_month_revenue
FROM monthly;


-- Query 16: NTILE(4) — divide customers into revenue quartiles
SELECT
    CONCAT(c.first_name, ' ', c.last_name)     AS customer_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_spent,
    NTILE(4) OVER (
        ORDER BY SUM(oi.quantity * oi.unit_price)
    )                                           AS quartile
FROM   customers   c
JOIN   orders      o  ON c.customer_id = o.customer_id
JOIN   order_items oi ON o.order_id    = oi.order_id
WHERE  o.status = 'Delivered'
GROUP BY c.customer_id, customer_name;


-- =============================================================
-- SECTION D · CUSTOMER SEGMENTATION
-- =============================================================

-- Query 17: RFM — Recency, Frequency, Monetary values per customer
WITH rfm_base AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name)     AS customer_name,
        DATEDIFF(CURDATE(), MAX(o.order_date))      AS recency_days,
        COUNT(DISTINCT o.order_id)                  AS frequency,
        ROUND(SUM(oi.quantity * oi.unit_price), 2)  AS monetary
    FROM   customers   c
    JOIN   orders      o  ON c.customer_id = o.customer_id
    JOIN   order_items oi ON o.order_id    = oi.order_id
    WHERE  o.status = 'Delivered'
    GROUP BY c.customer_id, customer_name
)
SELECT *,
    CASE
        WHEN recency_days <= 90  AND frequency >= 3 AND monetary >= 5000 THEN 'Champions'
        WHEN recency_days <= 180 AND frequency >= 2                      THEN 'Loyal'
        WHEN recency_days <= 90                                          THEN 'Recent'
        WHEN recency_days > 365                                          THEN 'At Risk'
        ELSE 'Potential'
    END AS segment
FROM rfm_base
ORDER BY monetary DESC;


-- Query 18: Customers who have never placed an order
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.signup_date
FROM   customers c
WHERE  c.customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);


-- Query 19: Repeat customers — placed more than one delivered order
WITH delivered AS (
    SELECT customer_id, COUNT(*) AS order_count
    FROM   orders
    WHERE  status = 'Delivered'
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    d.order_count
FROM   customers c
JOIN   delivered d ON c.customer_id = d.customer_id
WHERE  d.order_count > 1
ORDER BY d.order_count DESC;


-- Query 20: City-wise customer spend summary
SELECT
    c.city,
    COUNT(DISTINCT c.customer_id)               AS customers,
    COUNT(DISTINCT o.order_id)                  AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)  AS total_revenue,
    ROUND(
        SUM(oi.quantity * oi.unit_price) /
        COUNT(DISTINCT c.customer_id), 2
    )                                           AS revenue_per_customer
FROM   customers   c
JOIN   orders      o  ON c.customer_id = o.customer_id
JOIN   order_items oi ON o.order_id    = oi.order_id
WHERE  o.status = 'Delivered'
GROUP BY c.city
ORDER BY total_revenue DESC;


-- Query 21: Product cross-sell — products frequently bought together
SELECT
    a.product_id   AS product_a,
    b.product_id   AS product_b,
    COUNT(*)       AS times_bought_together
FROM   order_items a
JOIN   order_items b
    ON  a.order_id   = b.order_id
    AND a.product_id < b.product_id    -- avoid duplicates
GROUP BY product_a, product_b
ORDER BY times_bought_together DESC;


-- Query 22: Customer cohort — revenue by signup year
SELECT
    YEAR(c.signup_date)                         AS cohort_year,
    COUNT(DISTINCT c.customer_id)               AS customers_in_cohort,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)  AS lifetime_revenue,
    ROUND(
        SUM(oi.quantity * oi.unit_price) /
        COUNT(DISTINCT c.customer_id), 2
    )                                           AS avg_ltv
FROM   customers   c
JOIN   orders      o  ON c.customer_id = o.customer_id
JOIN   order_items oi ON o.order_id    = oi.order_id
WHERE  o.status = 'Delivered'
GROUP BY cohort_year
ORDER BY cohort_year;
