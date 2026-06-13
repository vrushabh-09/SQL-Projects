-- =============================================================
--  PROJECT 1: Student Management System
--  Dialect : MySQL 8.x
--  Author  : Vrushabh Patil
--  Desc    : Full schema, seed data, and analytical queries
--            for a college student management database.
-- =============================================================


-- -------------------------------------------------------------
-- 0. DATABASE SETUP
-- -------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS mycollege;
USE mycollege;


-- -------------------------------------------------------------
-- 1. TABLE DEFINITIONS
-- Note: instructor is created before course because course
--       holds a FK reference to instructor.
-- -------------------------------------------------------------

-- 1a. instructor
CREATE TABLE instructor (
    instructor_id INT          PRIMARY KEY,
    name          VARCHAR(50),
    dept          VARCHAR(50)
);

-- 1b. student
CREATE TABLE student (
    student_id INT          PRIMARY KEY,
    first_name VARCHAR(50),
    last_name  VARCHAR(50),
    email      VARCHAR(30),
    DOB        DATE,
    city       VARCHAR(50)
);

-- 1c. course  (references instructor)
CREATE TABLE course (
    course_id     INT          PRIMARY KEY,
    course_name   VARCHAR(50),
    credits       INT,
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES instructor (instructor_id)
);

-- 1d. enrollment  (references student + course)
CREATE TABLE enrollment (
    enroll_id  INT        PRIMARY KEY,
    student_id INT,
    FOREIGN KEY (student_id) REFERENCES student  (student_id),
    course_id  INT,
    FOREIGN KEY (course_id)  REFERENCES course   (course_id),
    semester   INT,
    grade      VARCHAR(2)
);


-- -------------------------------------------------------------
-- 2. SEED DATA
-- -------------------------------------------------------------

-- 2a. instructor
INSERT INTO instructor (instructor_id, name, dept)
VALUES
    (301, 'Dr. Neha Jain',    'Computer Science'),
    (302, 'Prof. Rakesh Rao', 'Mathematics'),
    (303, 'Dr. Kavita Nair',  'Information Technology'),
    (304, 'Prof. Aamir Khan', 'Computer Science');

-- 2b. student
INSERT INTO student (student_id, first_name, last_name, email, DOB, city)
VALUES
    (101, 'Anil',    'Sharma', 'anil.sharma@email.com',    '2002-05-15', 'Pune'),
    (102, 'Bhumika', 'Verma',  'bhumika.verma@email.com',  '2001-09-20', 'Mumbai'),
    (103, 'Chetan',  'Mehta',  'chetan.mehta@email.com',   '2003-01-10', 'Delhi'),
    (104, 'Dhruv',   'Singh',  'dhruv.singh@email.com',    '2002-12-05', 'Delhi'),
    (105, 'Emanuel', 'Das',    'emanuel.das@email.com',    '2004-03-22', 'Chennai');

-- 2c. course
INSERT INTO course (course_id, course_name, credits, instructor_id)
VALUES
    (201, 'Data Structures',   4, 301),
    (202, 'Database Systems',  3, 301),
    (203, 'Operating Systems', 4, 303),
    (204, 'Web Development',   2, 304),
    (205, 'Mathematics',       3, 302);

-- 2d. enrollment
INSERT INTO enrollment (enroll_id, student_id, course_id, semester, grade)
VALUES
    (401, 101, 201, 1, 'B'),
    (402, 101, 202, 1, 'A'),
    (403, 102, 201, 1, 'A'),
    (404, 102, 203, 1, 'B'),
    (405, 103, 204, 1, 'C'),
    (406, 104, 202, 1, 'A'),
    (407, 105, 205, 1, 'D'),
    (408, 105, 203, 1, 'B');


-- -------------------------------------------------------------
-- 3. ANALYTICAL QUERIES
-- -------------------------------------------------------------

-- Query 1: Sort students by city (A → Z)
SELECT student_id, first_name, city
FROM   student
ORDER BY city ASC;


-- Query 2: Count students per city
SELECT   city, COUNT(first_name) AS number_of_students
FROM     student
GROUP BY city;


-- Query 3: Toppers — students with at least one Grade A
SELECT  a.student_id, a.first_name, b.grade
FROM    student     AS a
INNER JOIN enrollment AS b ON a.student_id = b.student_id
WHERE   b.grade = 'A';


-- Query 4: Students ordered by the course they enrolled in
SELECT  a.student_id, a.first_name, b.course_id
FROM    student     AS a
INNER JOIN enrollment AS b ON a.student_id = b.student_id
ORDER BY course_id;


-- Query 5: Students enrolled in more than one course
SELECT   student_id, COUNT(course_id) AS course_count
FROM     enrollment
GROUP BY student_id
HAVING   COUNT(course_id) > 1;


-- Query 6: Students who have never received Grade A
SELECT DISTINCT a.student_id, a.first_name
FROM    student    AS a
JOIN    enrollment AS b ON a.student_id = b.student_id
WHERE   b.grade != 'A';


-- Query 7: Full student profile — name + course + grade
SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    c.course_name,
    e.grade
FROM  student    s
JOIN  enrollment e ON s.student_id = e.student_id
JOIN  course     c ON e.course_id  = c.course_id;


-- Query 8: Average GPA per course  (A=4, B=3, C=2, D=1)
SELECT
    c.course_name,
    AVG(
        CASE e.grade
            WHEN 'A' THEN 4
            WHEN 'B' THEN 3
            WHEN 'C' THEN 2
            WHEN 'D' THEN 1
        END
    ) AS average_gpa
FROM  enrollment e
JOIN  course     c ON e.course_id = c.course_id
GROUP BY c.course_name;


-- Query 9: Total enrollments per course (including courses with 0)
SELECT   c.course_name, COUNT(e.student_id) AS total_students
FROM     course     c
LEFT JOIN enrollment e ON c.course_id = e.course_id
GROUP BY c.course_name;


-- Query 10: Students who received the lowest grade (D)
SELECT
    s.student_id,
    s.first_name,
    c.course_name,
    e.grade
FROM  student    s
JOIN  enrollment e ON s.student_id = e.student_id
JOIN  course     c ON e.course_id  = c.course_id
WHERE e.grade = 'D';


-- Query 11: Student ages derived from DOB
SELECT
    student_id,
    first_name,
    last_name,
    FLOOR(DATEDIFF(CURDATE(), DOB) / 365) AS age
FROM student;


-- Query 12: Students born after 2002
SELECT * FROM student
WHERE YEAR(DOB) > 2002;


-- Query 13: Students not enrolled in any course
SELECT * FROM student
WHERE student_id NOT IN (
    SELECT student_id FROM enrollment
);


-- Query 14: Courses with no enrollments
SELECT * FROM course
WHERE course_id NOT IN (
    SELECT course_id FROM enrollment
);


-- Query 15: All courses taught by each instructor
SELECT i.name AS instructor, c.course_name
FROM   instructor i
JOIN   course     c ON i.instructor_id = c.instructor_id;


-- Query 16: Full mapping — Student → Course → Instructor
SELECT
    s.first_name  AS student,
    c.course_name,
    i.name        AS instructor
FROM  student    s
JOIN  enrollment e ON s.student_id   = e.student_id
JOIN  course     c ON e.course_id    = c.course_id
LEFT JOIN instructor i ON c.instructor_id = i.instructor_id;
