# 🛒 Grocery Store SQL Analysis

## 📌 Project Overview

This project focuses on analyzing grocery store sales and operational data using **MySQL**.

A relational database was designed to manage information about suppliers, categories, products, customers, employees, orders, and order details. SQL queries were then used to explore the data, identify purchasing patterns, analyze product and supplier performance, and evaluate employee sales performance.

The project demonstrates practical knowledge of **SQL, relational database concepts, JOINs, aggregations, subqueries, data-quality checks, and business-oriented analysis**.

---

## 🎯 Objectives

The main objectives of this project are to:

- Analyze customer purchasing behavior
- Identify customers with the highest number of orders
- Calculate total and average purchase values
- Analyze product sales and revenue
- Compare product categories
- Evaluate supplier performance
- Analyze employee order and sales performance
- Identify frequently ordered products
- Analyze daily, monthly, weekday, and weekend order patterns
- Perform database and data-quality checks

---

## 🛠️ Technologies Used

- **MySQL**
- **MySQL Workbench**
- **SQL**
- Relational Database Management System (RDBMS)

---

## 🗄️ Database Structure

The project uses the following tables:

| Table | Description |
|---|---|
| `supplier` | Stores supplier information |
| `categories` | Stores product category information |
| `employees` | Stores employee information |
| `customers` | Stores customer information |
| `products` | Stores product details, prices, suppliers, and categories |
| `orders` | Stores customer orders and employee information |
| `order_details` | Stores products and quantities associated with each order |

---

## 🔗 Table Relationships

The database follows a relational structure:

```text
Supplier
   │
   └── Products
          │
          ├── Categories
          │
          └── Order Details
                    │
                    └── Orders
                          │
                          ├── Customers
                          │
                          └── Employees
