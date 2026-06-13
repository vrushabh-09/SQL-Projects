-- =============================================================
--  SQL-Syntax.sql — Comprehensive SQL Syntax Reference
--  Dialect : MySQL 8.x  (notes added for PostgreSQL differences)
--  Author  : (your name)
--  Desc    : A single-file sandbox covering DDL, DML, DQL,
--            joins, subqueries, functions, views, and more.
-- =============================================================


-- =============================================================
-- SECTION 1 · DATABASE OPERATIONS
-- =============================================================

CREATE DATABASE college;
CREATE DATABASE IF NOT EXISTS college;   -- safe create

DROP DATABASE college;
DROP DATABASE IF EXISTS college;         -- safe drop

USE college;

SHOW DATABASES;   -- list all databases
SHOW TABLES;      -- list tables in current database


-- =============================================================
-- SECTION 2 · TABLE DEFINITION (DDL)
-- =============================================================

-- Basic table
CREATE TABLE student (
    rollno INT         PRIMARY KEY,
    name   VARCHAR(50),
    marks  INT         NOT NULL,
    grade  VARCHAR(1),
    city   VARCHAR(20)
);

-- Table with DEFAULT and CHECK constraints
CREATE TABLE student_v2 (
    rollno  INT         PRIMARY KEY,
    name    VARCHAR(50),
    age     INT         DEFAULT 18 CHECK (age >= 18),
    salary  INT         DEFAULT 25000,
    city    VARCHAR(50)
);

-- Multi-column CHECK
CREATE TABLE city_check (
    id   INT PRIMARY KEY,
    city VARCHAR(50),
    age  INT,
    CONSTRAINT age_check CHECK (age >= 18 AND city = 'Delhi')
);

-- Foreign key relationship
CREATE TABLE dept (
    id   INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE teacher (
    id      INT PRIMARY KEY,
    name    VARCHAR(50),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES dept (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- =============================================================
-- SECTION 3 · ALTER TABLE
-- =============================================================

ALTER TABLE student ADD COLUMN age INT NOT NULL DEFAULT 19;   -- add column
ALTER TABLE student DROP COLUMN age;                          -- remove column
ALTER TABLE student CHANGE name full_name VARCHAR(50);        -- rename + retype column
ALTER TABLE student MODIFY COLUMN age VARCHAR(2);             -- retype only
ALTER TABLE stu     RENAME TO student;                        -- rename table

TRUNCATE TABLE student;   -- delete all rows, keep structure


-- =============================================================
-- SECTION 4 · DML — INSERT / UPDATE / DELETE
-- =============================================================

-- INSERT
INSERT INTO student (rollno, name, marks, grade, city)
VALUES
    (101, 'Anil',    78, 'C', 'Pune'),
    (102, 'Bhumika', 93, 'A', 'Mumbai'),
    (103, 'Chetan',  85, 'B', 'Mumbai'),
    (104, 'Dhruv',   96, 'A', 'Delhi'),
    (105, 'Emanuel', 12, 'F', 'Delhi'),
    (106, 'Farah',   82, 'B', 'Delhi');

-- UPDATE  (disable safe-update mode first if needed)
SET SQL_SAFE_UPDATES = 0;

UPDATE student
SET    grade = 'O'
WHERE  grade = 'A';

-- DELETE
DELETE FROM student
WHERE marks < 33;


-- =============================================================
-- SECTION 5 · DQL — SELECT & FILTERING
-- =============================================================

SELECT *          FROM student;             -- all columns
SELECT age        FROM student;             -- specific column
SELECT * FROM student LIMIT 3;             -- first 3 rows

-- WHERE operators
SELECT * FROM student WHERE marks > 80;
SELECT * FROM student WHERE city = 'Mumbai';
SELECT * FROM student WHERE marks > 80 AND city  = 'Mumbai';
SELECT * FROM student WHERE marks > 80 OR  city  = 'Mumbai';
SELECT * FROM student WHERE marks BETWEEN 80 AND 90;
SELECT * FROM student WHERE city IN ('Delhi', 'Mumbai');
SELECT * FROM student WHERE city NOT IN ('Delhi', 'Mumbai');

-- ORDER BY
SELECT * FROM student ORDER BY city ASC;
SELECT * FROM student ORDER BY city DESC;


-- =============================================================
-- SECTION 6 · AGGREGATE FUNCTIONS & GROUP BY / HAVING
-- =============================================================

SELECT MAX(marks) FROM student;
SELECT AVG(marks) FROM student;

SELECT city, COUNT(name) AS count
FROM   student
GROUP BY city;

-- HAVING filters on aggregated results
SELECT COUNT(name) AS count, city
FROM   student
GROUP BY city
HAVING MAX(marks) > 90;

-- General SELECT clause order:
-- SELECT  → FROM  → WHERE  → GROUP BY  → HAVING  → ORDER BY


-- =============================================================
-- SECTION 7 · LIKE OPERATOR & PATTERN MATCHING
-- =============================================================

-- Starts with a vowel
SELECT DISTINCT city FROM city
WHERE  city LIKE 'a%' OR city LIKE 'e%' OR city LIKE 'i%'
    OR city LIKE 'o%' OR city LIKE 'u%';

-- Does NOT start with a vowel
SELECT DISTINCT city FROM city
WHERE  city NOT LIKE 'a%' AND city NOT LIKE 'e%' AND city NOT LIKE 'i%'
   AND city NOT LIKE 'o%' AND city NOT LIKE 'u%';

-- Ends with a vowel
SELECT DISTINCT city FROM city
WHERE  city LIKE '%a' OR city LIKE '%e' OR city LIKE '%i'
    OR city LIKE '%o' OR city LIKE '%u';

-- Starts AND ends with the same vowel
SELECT DISTINCT city FROM city
WHERE  city LIKE 'a%a' OR city LIKE 'e%e' OR city LIKE 'i%i'
    OR city LIKE 'o%o' OR city LIKE 'u%u';


-- =============================================================
-- SECTION 8 · STRING & MATH FUNCTIONS
-- =============================================================

-- LENGTH — find city with the longest name
SELECT city, LENGTH(city)
FROM   city
WHERE  LENGTH(city) = (SELECT MAX(LENGTH(city)) FROM city)
ORDER BY city ASC
LIMIT 1;

-- LEFT / RIGHT — trim and sort by prefix / suffix
SELECT name FROM student
WHERE  id IN (
    SELECT id FROM student WHERE marks >= 75
    ORDER BY LEFT(name, 3) ASC
);

SELECT name FROM student
WHERE  id IN (
    SELECT id FROM student WHERE marks >= 75
    ORDER BY RIGHT(name, 3) ASC
);

-- ROUND and FLOOR
SELECT ROUND(AVG(population), 0) AS population FROM city;
SELECT FLOOR(AVG(population))    AS population FROM city;

-- NULL handling
SELECT IFNULL(salary, 0)     FROM office;   -- replace NULL with 0
SELECT COALESCE(salary, 0)   FROM office;   -- same, ANSI standard


-- =============================================================
-- SECTION 9 · JOINS
-- =============================================================

-- Sample tables used in join examples
CREATE TABLE stu (
    student_id INT PRIMARY KEY,
    name       VARCHAR(50)
);
INSERT INTO stu VALUES (101, 'Adam'), (102, 'Bob'), (103, 'Casey');

CREATE TABLE course_join (
    student_id INT PRIMARY KEY,
    course     VARCHAR(50)
);
INSERT INTO course_join VALUES
    (102, 'English'), (105, 'Math'), (103, 'Science'), (107, 'Computer Science');

-- INNER JOIN — only matching rows
SELECT * FROM stu
INNER JOIN course_join ON stu.student_id = course_join.student_id;

-- LEFT JOIN — all left rows, matched right rows (NULLs for no match)
SELECT * FROM stu
LEFT JOIN course_join ON stu.student_id = course_join.student_id;

-- RIGHT JOIN — all right rows, matched left rows
SELECT * FROM stu
RIGHT JOIN course_join ON stu.student_id = course_join.student_id;

-- FULL JOIN (MySQL: emulated with UNION)
SELECT * FROM stu AS a LEFT  JOIN course_join AS b ON a.student_id = b.student_id
UNION
SELECT * FROM stu AS a RIGHT JOIN course_join AS b ON a.student_id = b.student_id;

-- LEFT EXCLUSIVE JOIN — rows only in the left table
SELECT * FROM stu AS a
LEFT JOIN course_join AS b ON a.student_id = b.student_id
WHERE b.student_id IS NULL;

-- RIGHT EXCLUSIVE JOIN — rows only in the right table
SELECT * FROM stu AS a
RIGHT JOIN course_join AS b ON a.student_id = b.student_id
WHERE a.student_id IS NULL;

-- SELF JOIN — employee ↔ manager
CREATE TABLE employee (
    id         INT PRIMARY KEY,
    name       VARCHAR(50),
    manager_id INT
);
INSERT INTO employee VALUES
    (101, 'Adam',   103),
    (102, 'Bob',    104),
    (103, 'Casey',  NULL),
    (104, 'Donald', 103);

SELECT a.name AS manager_name, b.name AS employee_name
FROM   employee AS a
JOIN   employee AS b ON a.id = b.manager_id;

-- Alias shorthand
SELECT * FROM stu AS s;


-- =============================================================
-- SECTION 10 · SET OPERATIONS
-- =============================================================

-- UNION — deduplicated results
SELECT name FROM employee
UNION
SELECT name FROM employee;

-- UNION ALL — keeps duplicates
SELECT name FROM employee
UNION ALL
SELECT name FROM employee;


-- =============================================================
-- SECTION 11 · SUBQUERIES
-- =============================================================

-- In WHERE — students above average marks
SELECT name, marks FROM student
WHERE  marks > (SELECT AVG(marks) FROM student);

-- In WHERE with IN — even roll numbers
SELECT name, rollno FROM student
WHERE  rollno IN (
    SELECT rollno FROM student WHERE rollno % 2 = 0
);

-- In FROM — max marks among Delhi students
SELECT MAX(marks) FROM (
    SELECT * FROM student WHERE city = 'Delhi'
) AS temp;


-- =============================================================
-- SECTION 12 · VIEWS
-- =============================================================

CREATE VIEW view1 AS
    SELECT rollno, name FROM student;

SELECT * FROM view1;


-- =============================================================
-- SECTION 13 · QUICK REFERENCE CARD
-- =============================================================

/*
DDL  : CREATE  |  DROP  |  ALTER  |  TRUNCATE
DML  : INSERT  |  UPDATE  |  DELETE
DQL  : SELECT  (+ WHERE / ORDER BY / GROUP BY / HAVING / LIMIT)
DCL  : GRANT  |  REVOKE
TCL  : COMMIT  |  ROLLBACK  |  SAVEPOINT

Clause execution order (logical):
  FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT

Useful functions:
  String  : LENGTH, LEFT, RIGHT, UPPER, LOWER, TRIM, CONCAT, SUBSTRING
  Math    : ROUND, FLOOR, CEIL, ABS, MOD, POWER
  Date    : NOW(), CURDATE(), YEAR(), MONTH(), DAY(), DATEDIFF()
  Null    : IFNULL, COALESCE, NULLIF, IS NULL, IS NOT NULL
  Agg     : COUNT, SUM, AVG, MAX, MIN
*/
