CREATE DATABASE grocery_store;

USE grocery_store;

SHOW DATABASES;

SELECT DATABASE();

CREATE TABLE supplier (
    sup_id TINYINT PRIMARY KEY AUTO_INCREMENT,
    sup_name VARCHAR(255),
    address TEXT
);

DESCRIBE supplier;

CREATE TABLE categories (
    cat_id TINYINT PRIMARY KEY AUTO_INCREMENT,
    cat_name VARCHAR(255)
);

DESCRIBE categories;

CREATE TABLE employees (
    emp_id TINYINT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(255),
    hire_date VARCHAR(255)
);

DESCRIBE employees;

CREATE TABLE customers (
    cust_id SMALLINT PRIMARY KEY AUTO_INCREMENT,
    cust_name VARCHAR(255),
    address TEXT
);

DESCRIBE customers;

CREATE TABLE products (
    prod_id TINYINT PRIMARY KEY AUTO_INCREMENT,
    prod_name VARCHAR(255),
    sup_id TINYINT,
    cat_id TINYINT,
    price DECIMAL(10,2),

    FOREIGN KEY (sup_id)
        REFERENCES supplier(sup_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (cat_id)
        REFERENCES categories(cat_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DESCRIBE products;

CREATE TABLE orders (
    ord_id SMALLINT PRIMARY KEY AUTO_INCREMENT,
    cust_id SMALLINT,
    emp_id TINYINT,
    order_date VARCHAR(255),

    FOREIGN KEY (cust_id)
        REFERENCES customers(cust_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (emp_id)
        REFERENCES employees(emp_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DESCRIBE orders;

CREATE TABLE order_details (
    ord_detID SMALLINT PRIMARY KEY AUTO_INCREMENT,
    ord_id SMALLINT,
    prod_id TINYINT,
    quantity TINYINT,
    each_price DECIMAL(10,2),
    total_price DECIMAL(10,2),

    FOREIGN KEY (ord_id)
        REFERENCES orders(ord_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (prod_id)
        REFERENCES products(prod_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

DESCRIBE order_details;

SHOW TABLES;

SHOW CREATE TABLE products;

SHOW CREATE TABLE orders;

SHOW CREATE TABLE order_details;

SELECT * FROM grocery_store.supplier;

SELECT * FROM categories;

SELECT * FROM employees;

SELECT * FROM customers;

SELECT * FROM products;

SELECT * FROM orders;

SELECT * FROM order_details;

SELECT 'supplier' AS table_name, COUNT(*) AS row_count
FROM supplier

UNION ALL

SELECT 'categories', COUNT(*)
FROM categories

UNION ALL

SELECT 'employees', COUNT(*)
FROM employees

UNION ALL

SELECT 'customers', COUNT(*)
FROM customers

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'order_details', COUNT(*)
FROM order_details;

DESCRIBE supplier;
DESCRIBE categories;
DESCRIBE employees;
DESCRIBE customers;
DESCRIBE products;
DESCRIBE orders;
DESCRIBE order_details;

-- Check duplicate Primary Keys --

SELECT sup_id, COUNT(*)
FROM supplier
GROUP BY sup_id
HAVING COUNT(*) > 1;

SELECT prod_id, COUNT(*)
FROM products
GROUP BY prod_id
HAVING COUNT(*) > 1;

SELECT ord_id, COUNT(*)
FROM orders
GROUP BY ord_id
HAVING COUNT(*) > 1;

-- Check NULL values --
SELECT *
FROM products
WHERE prod_id IS NULL
   OR prod_name IS NULL
   OR sup_id IS NULL
   OR cat_id IS NULL
   OR price IS NULL;
   
SELECT *
FROM orders
WHERE ord_id IS NULL
   OR cust_id IS NULL
   OR emp_id IS NULL
   OR order_date IS NULL;
   
SELECT *
FROM order_details
WHERE ord_id IS NULL
   OR prod_id IS NULL
   OR quantity IS NULL
   OR each_price IS NULL
   OR total_price IS NULL;
   
-- Check Foreign Key Relationships --

-- Check Products → Suppliers --
SELECT p.*
FROM products p
LEFT JOIN supplier s
    ON p.sup_id = s.sup_id
WHERE s.sup_id IS NULL;

-- Check Products → Categories --

SELECT p.*
FROM products p
LEFT JOIN categories c
    ON p.cat_id = c.cat_id
WHERE c.cat_id IS NULL;

-- Check Orders → Customers --

SELECT o.*
FROM orders o
LEFT JOIN customers c
    ON o.cust_id = c.cust_id
WHERE c.cust_id IS NULL;

-- Check Orders → Employees --

SELECT o.*
FROM orders o
LEFT JOIN employees e
    ON o.emp_id = e.emp_id
WHERE e.emp_id IS NULL;

-- Check Order Details → Orders --

SELECT od.*
FROM order_details od
LEFT JOIN orders o
    ON od.ord_id = o.ord_id
WHERE o.ord_id IS NULL;

-- Check Order Details → Products --

SELECT od.*
FROM order_details od
LEFT JOIN products p
    ON od.prod_id = p.prod_id
WHERE p.prod_id IS NULL;

-- Basic Data Preview --

SELECT *
FROM customers
LIMIT 10;

SELECT *
FROM products
LIMIT 10;

SELECT *
FROM orders
LIMIT 10;

SELECT *
FROM order_details
LIMIT 10;

-- Check Unique Values --

SELECT DISTINCT cat_id
FROM products;

SELECT DISTINCT sup_id
FROM products;

-- First JOIN — Test the Database --

-- Now let's do our first meaningful query. --

-- We want to see:--

-- Product name + Supplier name + Category name + Price --

SELECT
    p.prod_id,
    p.prod_name,
    s.sup_name,
    c.cat_name,
    p.price
FROM products p
JOIN supplier s
    ON p.sup_id = s.sup_id
JOIN categories c
    ON p.cat_id = c.cat_id;
    
    
    
 -- Analysis --
 
 -- CUSTOMER INSIGHTS -- 
 -- Question 1: How many unique customers have placed orders? --
 
 SELECT COUNT(DISTINCT cust_id) AS unique_customers
FROM orders;

-- Question 2: Which customers have placed the highest number of orders? -- 

SELECT
    c.cust_id,
    c.cust_name,
    COUNT(o.ord_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.cust_id = o.cust_id
GROUP BY
    c.cust_id,
    c.cust_name
ORDER BY total_orders DESC;

  -- To show only the top 5: --
  
  SELECT
    c.cust_id,
    c.cust_name,
    COUNT(o.ord_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.cust_id = o.cust_id
GROUP BY
    c.cust_id,
    c.cust_name
ORDER BY total_orders DESC
LIMIT 5;

-- Question 3: What is the total and average purchase value per customer? --

   -- Total purchase value --
   SELECT
    c.cust_id,
    c.cust_name,
    SUM(od.total_price) AS total_purchase_value
FROM customers c
JOIN orders o
    ON c.cust_id = o.cust_id
JOIN order_details od
    ON o.ord_id = od.ord_id
GROUP BY
    c.cust_id,
    c.cust_name
ORDER BY total_purchase_value DESC;

  -- Total + Average purchase value -- 
  
  SELECT
    c.cust_id,
    c.cust_name,
    SUM(od.total_price) AS total_purchase_value,
    AVG(od.total_price) AS average_purchase_value
FROM customers c
JOIN orders o
    ON c.cust_id = o.cust_id
JOIN order_details od
    ON o.ord_id = od.ord_id
GROUP BY
    c.cust_id,
    c.cust_name
ORDER BY total_purchase_value DESC;

-- Question 4: Who are the Top 5 customers by total purchase amount? -- 
 
SELECT
    c.cust_id,
    c.cust_name,
    SUM(od.total_price) AS total_purchase_amount
FROM customers c
JOIN orders o
    ON c.cust_id = o.cust_id
JOIN order_details od
    ON o.ord_id = od.ord_id
GROUP BY
    c.cust_id,
    c.cust_name
ORDER BY total_purchase_amount DESC
LIMIT 5;



-- PRODUCT PERFORMANCE -- 
-- Q5. How many products exist in each category? --


SELECT
    c.cat_id,
    c.cat_name,
    COUNT(p.prod_id) AS total_products
FROM categories c
LEFT JOIN products p
    ON c.cat_id = p.cat_id
GROUP BY
    c.cat_id,
    c.cat_name
ORDER BY total_products DESC;

-- Q6. What is the average price of products by category? -- 

SELECT
    c.cat_id,
    c.cat_name,
    ROUND(AVG(p.price), 2) AS average_price
FROM categories c
JOIN products p
    ON c.cat_id = p.cat_id
GROUP BY
    c.cat_id,
    c.cat_name
ORDER BY average_price DESC;

-- Q7. Which products have the highest total sales volume? -- 

SELECT
    p.prod_id,
    p.prod_name,
    SUM(od.quantity) AS total_quantity_sold
FROM products p
JOIN order_details od
    ON p.prod_id = od.prod_id
GROUP BY
    p.prod_id,
    p.prod_name
ORDER BY total_quantity_sold DESC;

    -- Top 5 --
    
SELECT
    p.prod_id,
    p.prod_name,
    SUM(od.quantity) AS total_quantity_sold
FROM products p
JOIN order_details od
    ON p.prod_id = od.prod_id
GROUP BY
    p.prod_id,
    p.prod_name
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- Q8. What is the total revenue generated by each product? --

SELECT
    p.prod_id,
    p.prod_name,
    ROUND(SUM(od.total_price), 2) AS total_revenue
FROM products p
JOIN order_details od
    ON p.prod_id = od.prod_id
GROUP BY
    p.prod_id,
    p.prod_name
ORDER BY total_revenue DESC;

-- Q9. How do product sales vary by category and supplier? --

SELECT
    c.cat_name,
    s.sup_name,
    SUM(od.quantity) AS total_quantity_sold,
    ROUND(SUM(od.total_price), 2) AS total_revenue
FROM order_details od
JOIN products p
    ON od.prod_id = p.prod_id
JOIN categories c
    ON p.cat_id = c.cat_id
JOIN supplier s
    ON p.sup_id = s.sup_id
GROUP BY
    c.cat_name,
    s.sup_name
ORDER BY total_revenue DESC;

-- SALES & ORDER TRENDS -- 
-- Q10. How many orders have been placed in total? --

SELECT COUNT(*) AS total_orders
FROM orders;

-- Q11. What is the average value per order? --

SELECT
    o.ord_id,
    SUM(od.total_price) AS order_value
FROM orders o
JOIN order_details od
    ON o.ord_id = od.ord_id
GROUP BY o.ord_id;

    -- calculate the average: --
    
SELECT
    ROUND(AVG(order_value), 2) AS average_order_value
FROM (
    SELECT
        o.ord_id,
        SUM(od.total_price) AS order_value
    FROM orders o
    JOIN order_details od
        ON o.ord_id = od.ord_id
    GROUP BY o.ord_id
) AS order_totals;

-- Q12. On which dates were the most orders placed? -- 

SELECT
    order_date,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_date
ORDER BY total_orders DESC;

       -- Top date only--

SELECT
    order_date,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_date
ORDER BY total_orders DESC
LIMIT 1;
 
 
SELECT order_date
FROM orders
LIMIT 10;

-- Q13. What are the monthly trends in order volume and revenue? --

SELECT
    DATE_FORMAT(
        STR_TO_DATE(o.order_date, '%Y-%m-%d'),
        '%Y-%m'
    ) AS month,

    COUNT(DISTINCT o.ord_id) AS total_orders,

    ROUND(SUM(od.total_price), 2) AS total_revenue

FROM orders o

JOIN order_details od
    ON o.ord_id = od.ord_id

GROUP BY month

ORDER BY month;

SELECT order_date
FROM orders
LIMIT 20;

SELECT
    DATE_FORMAT(
        STR_TO_DATE(o.order_date, '%m/%d/%Y'),
        '%Y-%m'
    ) AS month,

    COUNT(DISTINCT o.ord_id) AS total_orders,

    ROUND(SUM(od.total_price), 2) AS total_revenue

FROM orders o

JOIN order_details od
    ON o.ord_id = od.ord_id

GROUP BY month

ORDER BY month;


-- Q14. How do order patterns vary across weekdays and weekends? --

SELECT
    CASE
        WHEN DAYOFWEEK(
            STR_TO_DATE(order_date, '%m/%d/%Y')
        ) IN (1, 7)
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,

    COUNT(*) AS total_orders

FROM orders

GROUP BY day_type;

-- Better Version — Weekday vs Weekend Revenue--

SELECT
    CASE
        WHEN DAYOFWEEK(
            STR_TO_DATE(o.order_date, '%m/%d/%Y')
        ) IN (1, 7)
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,

    COUNT(DISTINCT o.ord_id) AS total_orders,

    ROUND(SUM(od.total_price), 2) AS total_revenue

FROM orders o

JOIN order_details od
    ON o.ord_id = od.ord_id

GROUP BY day_type;


-- SUPPLIER CONTRIBUTION --
-- Q15. How many suppliers are there in the database? --

SELECT COUNT(*) AS total_suppliers
FROM supplier;

-- Q16. Which supplier provides the most products? --

SELECT
    s.sup_id,
    s.sup_name,
    COUNT(p.prod_id) AS total_products
FROM supplier s
JOIN products p
    ON s.sup_id = p.sup_id
GROUP BY
    s.sup_id,
    s.sup_name
ORDER BY total_products DESC;

  -- only the #1 supplier: --
SELECT
    s.sup_id,
    s.sup_name,
    COUNT(p.prod_id) AS total_products
FROM supplier s
JOIN products p
    ON s.sup_id = p.sup_id
GROUP BY
    s.sup_id,
    s.sup_name
ORDER BY total_products DESC
LIMIT 1;


-- Q17. What is the average price of products from each supplier? -- 

SELECT
    s.sup_id,
    s.sup_name,
    ROUND(AVG(p.price), 2) AS average_product_price
FROM supplier s
JOIN products p
    ON s.sup_id = p.sup_id
GROUP BY
    s.sup_id,
    s.sup_name
ORDER BY average_product_price DESC;

-- Q18. Which suppliers contribute the most to total product sales by -- 

SELECT
    s.sup_id,
    s.sup_name,
    ROUND(SUM(od.total_price), 2) AS total_revenue
FROM supplier s
JOIN products p
    ON s.sup_id = p.sup_id
JOIN order_details od
    ON p.prod_id = od.prod_id
GROUP BY
    s.sup_id,
    s.sup_name
ORDER BY total_revenue DESC;

-- Employee Performance. --
-- Q19. How many employees have processed orders? --

SELECT COUNT(DISTINCT emp_id) AS employees_processed_orders
FROM orders;

-- Q20. Which employees have handled the most orders? -- 

SELECT
    e.emp_id,
    e.emp_name,
    COUNT(o.ord_id) AS total_orders
FROM employees e
JOIN orders o
    ON e.emp_id = o.emp_id
GROUP BY
    e.emp_id,
    e.emp_name
ORDER BY total_orders DESC;

-- If you want only the top employee: --

SELECT
    e.emp_id,
    e.emp_name,
    COUNT(o.ord_id) AS total_orders
FROM employees e
JOIN orders o
    ON e.emp_id = o.emp_id
GROUP BY
    e.emp_id,
    e.emp_name
ORDER BY total_orders DESC
LIMIT 1;

-- Q21. What is the total sales value processed by each employee?--

SELECT
    e.emp_id,
    e.emp_name,
    ROUND(SUM(od.total_price), 2) AS total_sales_value
FROM employees e
JOIN orders o
    ON e.emp_id = o.emp_id
JOIN order_details od
    ON o.ord_id = od.ord_id
GROUP BY
    e.emp_id,
    e.emp_name
ORDER BY total_sales_value DESC;

-- Q22. What is the average order value handled per employee? --

SELECT
    e.emp_id,
    e.emp_name,
    ROUND(AVG(order_total), 2) AS average_order_value
FROM employees e
JOIN (
    SELECT
        o.ord_id,
        o.emp_id,
        SUM(od.total_price) AS order_total
    FROM orders o
    JOIN order_details od
        ON o.ord_id = od.ord_id
    GROUP BY
        o.ord_id,
        o.emp_id
) AS order_values
    ON e.emp_id = order_values.emp_id
GROUP BY
    e.emp_id,
    e.emp_name
ORDER BY average_order_value DESC;

--  ORDER DETAILS DEEP DIVE--

-- Q23. Which products are most frequently ordered? --

SELECT
    p.prod_id,
    p.prod_name,
    COUNT(od.ord_id) AS times_ordered
FROM products p
JOIN order_details od
    ON p.prod_id = od.prod_id
GROUP BY
    p.prod_id,
    p.prod_name
ORDER BY times_ordered DESC;

--  Top 5 products --

SELECT
    p.prod_id,
    p.prod_name,
    COUNT(od.ord_id) AS times_ordered
FROM products p
JOIN order_details od
    ON p.prod_id = od.prod_id
GROUP BY
    p.prod_id,
    p.prod_name
ORDER BY times_ordered DESC
LIMIT 5;

-- Q24. What is the average quantity ordered per product? --

SELECT
    p.prod_id,
    p.prod_name,
    ROUND(AVG(od.quantity), 2) AS average_quantity
FROM products p
JOIN order_details od
    ON p.prod_id = od.prod_id
GROUP BY
    p.prod_id,
    p.prod_name
ORDER BY average_quantity DESC;