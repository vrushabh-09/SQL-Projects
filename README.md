# 📘 SQL-Projects

Welcome to my **SQL Projects** repository! This repository contains structured SQL projects, syntax references, and end-to-end data analysis exercises to practice, explore, and improve SQL skills across various dialects (**PostgreSQL / MySQL / SQL Server**).

---

## 📂 Repository Structure

```
SQL-Projects/
├── Project1.sql        # Student Management System — full schema + 16 queries
├── Project2.sql        # E-Commerce Order Analytics — CTEs, Window Functions, Segmentation (22 queries)
├── Project3.sql        # HR Database — Payroll, Attendance, Hierarchy, Appraisals (22 queries)
├── SQL-Syntax.sql      # SQL syntax practice, operators, joins, subqueries & more
└── README.md
```

---

## 📌 Project 1: Student Management System

A fully functional **MySQL** database project that models a college's student management workflow. It covers schema design with relational integrity, realistic seed data, and a rich query suite for analytical insights.

### 🔧 Schema — Tables

| Table | Description |
|---|---|
| `student` | Student details — name, email, DOB, city |
| `course` | Course catalogue with credits and instructor mapping |
| `instructor` | Instructor name and department |
| `enrollment` | Junction table — student ↔ course with semester and grade |

**ER relationships:**
- `enrollment.student_id` → `student.student_id`
- `enrollment.course_id` → `course.course_id`
- `course.instructor_id` → `instructor.instructor_id`

---

### 📊 Key Features

- **Relational design** using primary keys and foreign keys
- **Filtering & sorting** with `WHERE`, `ORDER BY`, `BETWEEN`, `IN`
- **Aggregations** using `COUNT`, `AVG`, `GROUP BY`, `HAVING`
- **Multi-table joins** — `INNER JOIN`, `LEFT JOIN` across 3–4 tables
- **Subqueries** for exclusion logic (`NOT IN`)
- **Date functions** — age calculation with `DATEDIFF` / `CURDATE`
- **Conditional expressions** — grade-to-GPA mapping with `CASE WHEN`

---

### 📄 Query Reference (16 Queries)

| # | Query Description |
|---|---|
| 1 | Sort students by city |
| 2 | Count students per city |
| 3 | List all Grade-A students (toppers) |
| 4 | Order students by enrolled course |
| 5 | Students enrolled in more than one course |
| 6 | Students who never received Grade A |
| 7 | Full profile — student + course name + grade |
| 8 | Average GPA per course (A=4, B=3, C=2, D=1) |
| 9 | Total enrollments per course |
| 10 | Students with lowest grade (D) |
| 11 | Student ages calculated from DOB |
| 12 | Students born after 2002 |
| 13 | Students not enrolled in any course |
| 14 | Courses with zero enrollments |
| 15 | All courses taught by each instructor |
| 16 | Student → Course → Instructor full mapping |

---

---

## 📌 Project 2: E-Commerce Order Analytics

A MySQL analytics project built on a realistic e-commerce schema — customers, products, orders, and order line-items. Focuses on advanced SQL techniques used in real data analyst roles.

### 🔧 Schema — Tables

| Table | Description |
|---|---|
| `customers` | Customer profiles with signup date and city |
| `categories` | Product category catalogue |
| `products` | Product details — price, stock, category |
| `orders` | Order header — customer, date, status |
| `order_items` | Line items — product, quantity, unit price |

### 📊 Key Features

- **CTEs** for multi-step logic (order totals, averages, product gaps)
- **Window Functions** — `RANK`, `DENSE_RANK`, `ROW_NUMBER`, `NTILE`, `LAG`, `LEAD`
- **Revenue analysis** — monthly trends, category breakdown, cumulative totals
- **Customer Segmentation** — RFM model (Recency, Frequency, Monetary), cohort analysis, repeat customers

### 📄 Query Reference (22 Queries)

| Section | Queries |
|---|---|
| **A · Revenue & Sales** | Total revenue, monthly trend, category revenue, top 5 products, avg order value, status breakdown |
| **B · CTEs** | Revenue per order, high-value orders, unordered products, cumulative monthly revenue |
| **C · Window Functions** | RANK by spend, ROW_NUMBER by category, DENSE_RANK top product, LAG/LEAD MoM change, NTILE quartiles |
| **D · Customer Segmentation** | RFM segments, never-ordered customers, repeat buyers, city-wise spend, cross-sell pairs, cohort LTV |

---

## 📌 Project 3: HR Database

A comprehensive HR system covering the full employee lifecycle — from org hierarchy and payroll to attendance tracking and performance appraisals.

### 🔧 Schema — Tables

| Table | Description |
|---|---|
| `departments` | Department names and locations |
| `employees` | Employee records with self-referencing `manager_id` |
| `salary` | Monthly payroll — base, bonus, deductions |
| `attendance` | Daily attendance status per employee |
| `leave_requests` | Leave applications with type, dates, and approval status |
| `performance_reviews` | Annual ratings with reviewer and comments |

### 📊 Key Features

- **Self Join** for full org hierarchy (3 levels deep)
- **Payroll reports** — net salary, dept totals, salary rankings with `RANK()`
- **Attendance & Leave** — absenteeism tracking, leave duration, approval status
- **Appraisal engine** — YoY rating comparison, top performers, promotion recommendation using `CASE WHEN`

### 📄 Query Reference (22 Queries)

| Section | Queries |
|---|---|
| **A · Payroll & Salary** | Net salary, dept payroll cost, highest/lowest paid, above-average earners, salary rank, bonus % |
| **B · Attendance & Leave** | Attendance summary, absentee list, leave type breakdown, long leaves, pending requests, attendance rate |
| **C · Department Hierarchy** | Employee–manager pairs, top-level managers, direct reportee count, 3-level hierarchy, middle managers |
| **D · Performance & Appraisals** | Avg rating by dept, top performer per dept, YoY improvement, unreviewed employees, appraisal recommendation |

---

## 💡 SQL Syntax Examples — `SQL-Syntax.sql`

A comprehensive syntax reference covering:

| Category | Topics |
|---|---|
| **DDL** | `CREATE`, `DROP`, `ALTER`, `TRUNCATE` |
| **DML** | `INSERT`, `UPDATE`, `DELETE` |
| **DQL** | `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, `GROUP BY`, `HAVING` |
| **Constraints** | `PRIMARY KEY`, `FOREIGN KEY`, `CHECK`, `DEFAULT`, `NOT NULL` |
| **Operators** | `AND`, `OR`, `BETWEEN`, `IN`, `NOT`, `LIKE` |
| **Joins** | `INNER`, `LEFT`, `RIGHT`, `FULL`, `SELF`, exclusive joins |
| **Set ops** | `UNION`, `UNION ALL` |
| **Subqueries** | In `WHERE`, `FROM`; correlated subqueries |
| **String functions** | `LENGTH`, `LEFT`, `RIGHT`, `LIKE` patterns |
| **Math functions** | `ROUND`, `FLOOR`, `AVG`, `MAX` |
| **Null handling** | `IFNULL`, `COALESCE` |
| **Views** | `CREATE VIEW`, querying views |
| **Cascading** | `ON DELETE CASCADE`, `ON UPDATE CASCADE` |

---

## 🚀 Getting Started

```sql
-- 1. Clone the repo and open in MySQL Workbench / DBeaver / any SQL client
-- 2. Run Project1.sql to set up the Student Management System
CREATE DATABASE mycollege;
USE mycollege;
-- Then execute the rest of the file top to bottom

-- 3. Use SQL-Syntax.sql as a reference or sandbox
```

> **Note:** The project uses **MySQL** syntax. For PostgreSQL, minor adjustments may be needed (e.g., `CURDATE()` → `CURRENT_DATE`, backtick identifiers → double quotes).

---

## 🛠️ Tools & Dialect

- **Primary dialect:** MySQL 8.x
- **Compatible with:** MariaDB, with minor tweaks for PostgreSQL / SQL Server
- **Recommended clients:** MySQL Workbench · DBeaver · TablePlus · VS Code SQLTools

---

## 🤝 Contributing

Feel free to open an issue or PR if you spot a bug, want to add a query variant, or suggest a new project idea!

---

## 📜 Copyright Notice
PROPRIETARY SOFTWARE

Copyright (c) 2026 Vrushabh Patil. All Rights Reserved.

Contact: vrushabhpatil97711@gmail.com

This software is protected by copyright law and international treaties.
Unauthorized copying, distribution, modification, reverse engineering,
or redistribution of this software is strictly prohibited without
written permission from the copyright holder.
