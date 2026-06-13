-- =============================================================
--  PROJECT 3: HR Database
--  Dialect : MySQL 8.x
--  Author  : Vrushabh Patil
--  Topics  : Payroll & Salary Reports · Attendance & Leave
--            · Department Hierarchy (Self Join)
--            · Performance Reviews & Appraisals
--  Queries : 22
-- =============================================================


-- -------------------------------------------------------------
-- 0. DATABASE SETUP
-- -------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS hr_db;
USE hr_db;


-- -------------------------------------------------------------
-- 1. TABLE DEFINITIONS
-- -------------------------------------------------------------

-- 1a. departments
CREATE TABLE departments (
    dept_id   INT          PRIMARY KEY,
    dept_name VARCHAR(50),
    location  VARCHAR(50)
);

-- 1b. employees  (manager_id self-references employee_id)
CREATE TABLE employees (
    employee_id  INT          PRIMARY KEY,
    first_name   VARCHAR(50),
    last_name    VARCHAR(50),
    email        VARCHAR(80),
    phone        VARCHAR(15),
    hire_date    DATE,
    job_title    VARCHAR(60),
    dept_id      INT,
    manager_id   INT,                       -- self-referencing FK
    FOREIGN KEY (dept_id)    REFERENCES departments (dept_id),
    FOREIGN KEY (manager_id) REFERENCES employees   (employee_id)
);

-- 1c. salary  (one record per employee per period)
CREATE TABLE salary (
    salary_id    INT           PRIMARY KEY,
    employee_id  INT,
    base_salary  DECIMAL(10,2),
    bonus        DECIMAL(10,2) DEFAULT 0,
    deductions   DECIMAL(10,2) DEFAULT 0,
    pay_month    VARCHAR(7),               -- format: 'YYYY-MM'
    FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
);

-- 1d. attendance
CREATE TABLE attendance (
    attendance_id  INT     PRIMARY KEY,
    employee_id    INT,
    work_date      DATE,
    status         VARCHAR(10),   -- 'Present', 'Absent', 'Leave', 'Holiday'
    FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
);

-- 1e. leave_requests
CREATE TABLE leave_requests (
    leave_id     INT         PRIMARY KEY,
    employee_id  INT,
    leave_type   VARCHAR(30), -- 'Sick', 'Casual', 'Earned', 'Maternity'
    start_date   DATE,
    end_date     DATE,
    status       VARCHAR(15), -- 'Approved', 'Rejected', 'Pending'
    FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
);

-- 1f. performance_reviews
CREATE TABLE performance_reviews (
    review_id    INT           PRIMARY KEY,
    employee_id  INT,
    review_year  INT,
    rating       DECIMAL(3,1), -- 1.0 – 5.0
    reviewer_id  INT,          -- manager who gave the review
    comments     VARCHAR(200),
    FOREIGN KEY (employee_id) REFERENCES employees (employee_id),
    FOREIGN KEY (reviewer_id) REFERENCES employees (employee_id)
);


-- -------------------------------------------------------------
-- 2. SEED DATA
-- -------------------------------------------------------------

-- 2a. departments
INSERT INTO departments VALUES
    (10, 'Engineering',       'Pune'),
    (20, 'Human Resources',   'Mumbai'),
    (30, 'Finance',           'Delhi'),
    (40, 'Marketing',         'Bangalore'),
    (50, 'Operations',        'Hyderabad');

-- 2b. employees  (managers inserted before their reportees)
INSERT INTO employees VALUES
    (1,  'Rahul',    'Verma',   'rahul.v@hr.com',    '9000000001', '2018-03-01', 'CTO',                  10, NULL),
    (2,  'Sunita',   'Rao',     'sunita.r@hr.com',   '9000000002', '2018-06-15', 'HR Director',          20, NULL),
    (3,  'Deepak',   'Gupta',   'deepak.g@hr.com',   '9000000003', '2019-01-10', 'Finance Manager',      30, NULL),
    (4,  'Kavya',    'Nair',    'kavya.n@hr.com',    '9000000004', '2019-07-20', 'Marketing Head',       40, NULL),
    (5,  'Ajay',     'Joshi',   'ajay.j@hr.com',     '9000000005', '2019-11-05', 'Ops Manager',          50, NULL),
    (6,  'Priya',    'Sharma',  'priya.s@hr.com',    '9000000006', '2020-02-14', 'Senior Engineer',      10, 1),
    (7,  'Nikhil',   'Das',     'nikhil.d@hr.com',   '9000000007', '2020-05-01', 'Engineer',             10, 6),
    (8,  'Meera',    'Pillai',  'meera.p@hr.com',    '9000000008', '2020-08-19', 'HR Executive',         20, 2),
    (9,  'Aryan',    'Singh',   'aryan.s@hr.com',    '9000000009', '2021-01-03', 'Accountant',           30, 3),
    (10, 'Divya',    'Mehta',   'divya.m@hr.com',    '9000000010', '2021-04-22', 'Marketing Analyst',    40, 4),
    (11, 'Kunal',    'Iyer',    'kunal.i@hr.com',    '9000000011', '2021-09-10', 'Engineer',             10, 6),
    (12, 'Swati',    'Patil',   'swati.p@hr.com',    '9000000012', '2022-01-17', 'HR Trainee',           20, 8),
    (13, 'Ravi',     'Kumar',   'ravi.k@hr.com',     '9000000013', '2022-06-01', 'Finance Analyst',      30, 9),
    (14, 'Ananya',   'Bose',    'ananya.b@hr.com',   '9000000014', '2023-03-08', 'Marketing Executive',  40, 10),
    (15, 'Farhan',   'Sheikh',  'farhan.s@hr.com',   '9000000015', '2023-07-15', 'Ops Analyst',          50, 5);

-- 2c. salary  (April 2024 payroll)
INSERT INTO salary VALUES
    (1,  1,  180000, 50000, 15000, '2024-04'),
    (2,  2,  150000, 30000, 12000, '2024-04'),
    (3,  3,  140000, 25000, 11000, '2024-04'),
    (4,  4,  145000, 28000, 11500, '2024-04'),
    (5,  5,  130000, 20000, 10000, '2024-04'),
    (6,  6,  110000, 18000,  9000, '2024-04'),
    (7,  7,   85000, 10000,  7000, '2024-04'),
    (8,  8,   75000,  8000,  6000, '2024-04'),
    (9,  9,   80000,  9000,  6500, '2024-04'),
    (10, 10,  70000,  7000,  5500, '2024-04'),
    (11, 11,  88000, 11000,  7200, '2024-04'),
    (12, 12,  45000,  3000,  3500, '2024-04'),
    (13, 13,  72000,  7500,  5800, '2024-04'),
    (14, 14,  65000,  6000,  5200, '2024-04'),
    (15, 15,  60000,  5000,  4800, '2024-04');

-- 2d. attendance  (sample — April 2024, Mon–Fri)
INSERT INTO attendance VALUES
    (1,  1,  '2024-04-01', 'Present'), (2,  1,  '2024-04-02', 'Present'),
    (3,  1,  '2024-04-03', 'Leave'),   (4,  2,  '2024-04-01', 'Present'),
    (5,  2,  '2024-04-02', 'Absent'),  (6,  3,  '2024-04-01', 'Present'),
    (7,  3,  '2024-04-02', 'Present'), (8,  4,  '2024-04-01', 'Present'),
    (9,  4,  '2024-04-03', 'Absent'),  (10, 5,  '2024-04-01', 'Present'),
    (11, 6,  '2024-04-01', 'Present'), (12, 6,  '2024-04-02', 'Present'),
    (13, 7,  '2024-04-01', 'Leave'),   (14, 7,  '2024-04-02', 'Present'),
    (15, 8,  '2024-04-01', 'Present'), (16, 9,  '2024-04-01', 'Absent'),
    (17, 10, '2024-04-01', 'Present'), (18, 11, '2024-04-01', 'Present'),
    (19, 12, '2024-04-01', 'Leave'),   (20, 13, '2024-04-01', 'Present'),
    (21, 14, '2024-04-01', 'Present'), (22, 15, '2024-04-01', 'Absent');

-- 2e. leave_requests
INSERT INTO leave_requests VALUES
    (1,  1,  'Earned',    '2024-04-03', '2024-04-05', 'Approved'),
    (2,  2,  'Sick',      '2024-04-02', '2024-04-02', 'Approved'),
    (3,  7,  'Casual',    '2024-04-01', '2024-04-01', 'Approved'),
    (4,  9,  'Sick',      '2024-04-01', '2024-04-03', 'Pending'),
    (5,  12, 'Maternity', '2024-04-01', '2024-06-30', 'Approved'),
    (6,  15, 'Casual',    '2024-03-28', '2024-03-29', 'Rejected'),
    (7,  4,  'Earned',    '2024-05-10', '2024-05-15', 'Pending'),
    (8,  10, 'Sick',      '2024-04-08', '2024-04-09', 'Approved'),
    (9,  6,  'Casual',    '2024-04-15', '2024-04-15', 'Approved'),
    (10, 14, 'Earned',    '2024-04-20', '2024-04-22', 'Pending');

-- 2f. performance_reviews
INSERT INTO performance_reviews VALUES
    (1,  6,  2023, 4.5, 1,  'Excellent delivery on cloud migration project.'),
    (2,  7,  2023, 3.8, 6,  'Good progress, needs to improve documentation.'),
    (3,  8,  2023, 4.2, 2,  'Outstanding employee relations management.'),
    (4,  9,  2023, 3.5, 3,  'Meets expectations, scope for improvement.'),
    (5,  10, 2023, 4.0, 4,  'Strong campaign results in Q3.'),
    (6,  11, 2023, 4.7, 6,  'Best performer in the engineering team.'),
    (7,  12, 2023, 3.0, 8,  'Trainee — developing well.'),
    (8,  13, 2023, 3.8, 9,  'Good accuracy in financial reporting.'),
    (9,  14, 2023, 4.1, 10, 'Creative marketing ideas, high initiative.'),
    (10, 15, 2023, 3.2, 5,  'Improving, needs guidance on SLAs.'),
    (11, 6,  2024, 4.8, 1,  'Led team to on-time product launch.'),
    (12, 11, 2024, 4.9, 6,  'Top engineer, exceeded all OKRs.');


-- =============================================================
-- SECTION A · PAYROLL & SALARY REPORTS
-- =============================================================

-- Query 1: Net salary for all employees (base + bonus - deductions)
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name)   AS employee_name,
    e.job_title,
    s.base_salary,
    s.bonus,
    s.deductions,
    (s.base_salary + s.bonus - s.deductions) AS net_salary
FROM   employees e
JOIN   salary    s ON e.employee_id = s.employee_id
WHERE  s.pay_month = '2024-04'
ORDER BY net_salary DESC;


-- Query 2: Department-wise total payroll cost
SELECT
    d.dept_name,
    ROUND(SUM(s.base_salary + s.bonus - s.deductions), 2) AS total_payroll
FROM   departments d
JOIN   employees   e ON d.dept_id     = e.dept_id
JOIN   salary      s ON e.employee_id = s.employee_id
WHERE  s.pay_month = '2024-04'
GROUP BY d.dept_name
ORDER BY total_payroll DESC;


-- Query 3: Highest and lowest paid employee per department
SELECT
    d.dept_name,
    MAX(s.base_salary + s.bonus - s.deductions) AS highest_net,
    MIN(s.base_salary + s.bonus - s.deductions) AS lowest_net
FROM   departments d
JOIN   employees   e ON d.dept_id     = e.dept_id
JOIN   salary      s ON e.employee_id = s.employee_id
WHERE  s.pay_month = '2024-04'
GROUP BY d.dept_name;


-- Query 4: Employees earning above the company average net salary
WITH net_salaries AS (
    SELECT
        e.employee_id,
        CONCAT(e.first_name, ' ', e.last_name)     AS employee_name,
        (s.base_salary + s.bonus - s.deductions)   AS net_salary
    FROM employees e
    JOIN salary    s ON e.employee_id = s.employee_id
    WHERE s.pay_month = '2024-04'
)
SELECT employee_id, employee_name, net_salary
FROM   net_salaries
WHERE  net_salary > (SELECT AVG(net_salary) FROM net_salaries)
ORDER BY net_salary DESC;


-- Query 5: Salary rank within each department using RANK()
SELECT
    d.dept_name,
    CONCAT(e.first_name, ' ', e.last_name)   AS employee_name,
    (s.base_salary + s.bonus - s.deductions) AS net_salary,
    RANK() OVER (
        PARTITION BY d.dept_name
        ORDER BY (s.base_salary + s.bonus - s.deductions) DESC
    ) AS dept_salary_rank
FROM   departments d
JOIN   employees   e ON d.dept_id     = e.dept_id
JOIN   salary      s ON e.employee_id = s.employee_id
WHERE  s.pay_month = '2024-04';


-- Query 6: Bonus as percentage of base salary
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    s.base_salary,
    s.bonus,
    ROUND((s.bonus / s.base_salary) * 100, 2) AS bonus_pct
FROM employees e
JOIN salary    s ON e.employee_id = s.employee_id
WHERE s.pay_month = '2024-04'
ORDER BY bonus_pct DESC;


-- =============================================================
-- SECTION B · ATTENDANCE & LEAVE TRACKING
-- =============================================================

-- Query 7: Attendance summary per employee (April 2024)
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    SUM(a.status = 'Present') AS present_days,
    SUM(a.status = 'Absent')  AS absent_days,
    SUM(a.status = 'Leave')   AS leave_days
FROM   employees   e
JOIN   attendance  a ON e.employee_id = a.employee_id
GROUP BY e.employee_id, employee_name
ORDER BY absent_days DESC;


-- Query 8: Employees who were absent at least once
SELECT DISTINCT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.dept_id
FROM   employees  e
JOIN   attendance a ON e.employee_id = a.employee_id
WHERE  a.status = 'Absent';


-- Query 9: Leave requests by type and status breakdown
SELECT
    leave_type,
    status,
    COUNT(*) AS request_count
FROM   leave_requests
GROUP BY leave_type, status
ORDER BY leave_type, status;


-- Query 10: Employees with approved leaves longer than 5 days
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name)         AS employee_name,
    l.leave_type,
    l.start_date,
    l.end_date,
    DATEDIFF(l.end_date, l.start_date) + 1          AS leave_days
FROM   employees      e
JOIN   leave_requests l ON e.employee_id = l.employee_id
WHERE  l.status = 'Approved'
  AND  DATEDIFF(l.end_date, l.start_date) + 1 > 5
ORDER BY leave_days DESC;


-- Query 11: Pending leave requests with employee details
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    l.leave_type,
    l.start_date,
    l.end_date
FROM   employees      e
JOIN   leave_requests l ON e.employee_id = l.employee_id
WHERE  l.status = 'Pending';


-- Query 12: Attendance rate per employee (present / total records)
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name)            AS employee_name,
    COUNT(a.attendance_id)                             AS total_days_recorded,
    SUM(a.status = 'Present')                          AS present_days,
    ROUND(SUM(a.status = 'Present') * 100.0
          / COUNT(a.attendance_id), 1)                 AS attendance_rate_pct
FROM   employees  e
JOIN   attendance a ON e.employee_id = a.employee_id
GROUP BY e.employee_id, employee_name
ORDER BY attendance_rate_pct;


-- =============================================================
-- SECTION C · DEPARTMENT HIERARCHY (SELF JOIN)
-- =============================================================

-- Query 13: List each employee with their direct manager
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.job_title,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    m.job_title                             AS manager_title
FROM   employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY manager_name, employee_name;


-- Query 14: Top-level managers (no manager above them)
SELECT
    employee_id,
    CONCAT(first_name, ' ', last_name) AS name,
    job_title,
    dept_id
FROM employees
WHERE manager_id IS NULL;


-- Query 15: Direct reportees for each manager
SELECT
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    COUNT(e.employee_id)                   AS direct_reports
FROM   employees m
JOIN   employees e ON m.employee_id = e.manager_id
GROUP BY m.employee_id, manager_name
ORDER BY direct_reports DESC;


-- Query 16: Full 3-level hierarchy — Level 1 → Level 2 → Level 3
SELECT
    CONCAT(l1.first_name, ' ', l1.last_name) AS level1,
    CONCAT(l2.first_name, ' ', l2.last_name) AS level2,
    CONCAT(l3.first_name, ' ', l3.last_name) AS level3
FROM       employees l1
LEFT JOIN  employees l2 ON l2.manager_id = l1.employee_id
LEFT JOIN  employees l3 ON l3.manager_id = l2.employee_id
WHERE  l1.manager_id IS NULL
ORDER BY level1, level2, level3;


-- Query 17: Employees who are both a manager and a reportee (middle tier)
SELECT DISTINCT
    CONCAT(e.first_name, ' ', e.last_name) AS middle_manager,
    e.job_title
FROM employees e
WHERE e.manager_id IS NOT NULL
  AND e.employee_id IN (SELECT DISTINCT manager_id FROM employees WHERE manager_id IS NOT NULL);


-- =============================================================
-- SECTION D · PERFORMANCE REVIEWS & APPRAISALS
-- =============================================================

-- Query 18: Average performance rating per department
SELECT
    d.dept_name,
    ROUND(AVG(pr.rating), 2) AS avg_rating,
    COUNT(pr.review_id)      AS review_count
FROM   departments          d
JOIN   employees             e  ON d.dept_id     = e.dept_id
JOIN   performance_reviews   pr ON e.employee_id = pr.employee_id
GROUP BY d.dept_name
ORDER BY avg_rating DESC;


-- Query 19: Top performer per department (highest rating)
WITH ranked_reviews AS (
    SELECT
        e.employee_id,
        CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
        d.dept_name,
        pr.review_year,
        pr.rating,
        RANK() OVER (
            PARTITION BY d.dept_name
            ORDER BY pr.rating DESC
        ) AS rnk
    FROM   employees           e
    JOIN   departments         d  ON e.dept_id     = d.dept_id
    JOIN   performance_reviews pr ON e.employee_id = pr.employee_id
    WHERE  pr.review_year = 2023
)
SELECT dept_name, employee_name, rating
FROM   ranked_reviews
WHERE  rnk = 1;


-- Query 20: Year-over-year rating improvement per employee
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    pr1.review_year                         AS year_2023,
    pr1.rating                              AS rating_2023,
    pr2.review_year                         AS year_2024,
    pr2.rating                              AS rating_2024,
    ROUND(pr2.rating - pr1.rating, 1)       AS improvement
FROM   performance_reviews pr1
JOIN   performance_reviews pr2
    ON  pr1.employee_id = pr2.employee_id
    AND pr1.review_year = 2023
    AND pr2.review_year = 2024
JOIN   employees e ON pr1.employee_id = e.employee_id
ORDER BY improvement DESC;


-- Query 21: Employees with no performance review on record
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.job_title,
    e.hire_date
FROM   employees e
WHERE  e.employee_id NOT IN (SELECT DISTINCT employee_id FROM performance_reviews);


-- Query 22: Salary appraisal recommendation based on rating + tenure
--           Rating >= 4.5 and tenure >= 3 years → 'Promote'
--           Rating >= 4.0                       → 'Increment'
--           Rating <  4.0                       → 'Review'
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name)               AS employee_name,
    e.job_title,
    FLOOR(DATEDIFF(CURDATE(), e.hire_date) / 365)         AS tenure_years,
    pr.rating,
    (s.base_salary + s.bonus - s.deductions)              AS net_salary,
    CASE
        WHEN pr.rating >= 4.5
         AND FLOOR(DATEDIFF(CURDATE(), e.hire_date) / 365) >= 3 THEN 'Promote'
        WHEN pr.rating >= 4.0                                    THEN 'Increment'
        ELSE                                                          'Review'
    END AS appraisal_recommendation
FROM   employees           e
JOIN   performance_reviews pr ON e.employee_id = pr.employee_id
JOIN   salary              s  ON e.employee_id = s.employee_id
WHERE  pr.review_year  = 2023
  AND  s.pay_month     = '2024-04'
ORDER BY pr.rating DESC;
