SHOW USER;

CREATE TABLE REGIONS (
    region_id NUMBER PRIMARY KEY,
    region_name VARCHAR2(25)
);

CREATE TABLE COUNTRIES (
    country_id CHAR(2) PRIMARY KEY,
    country_name VARCHAR2(40),
    region_id NUMBER,
    CONSTRAINT fk_countries_regions FOREIGN KEY (region_id) REFERENCES REGIONS(region_id)
);

CREATE TABLE LOCATIONS (
    location_id NUMBER(4) PRIMARY KEY,
    street_address VARCHAR2(40),
    postal_code VARCHAR2(12),
    city VARCHAR2(30) NOT NULL,
    state_province VARCHAR2(25),
    country_id CHAR(2),
    CONSTRAINT fk_loc_countries FOREIGN KEY (country_id) REFERENCES COUNTRIES(country_id)
);

CREATE TABLE JOBS (
    job_id VARCHAR2(10) PRIMARY KEY,
    job_title VARCHAR2(35) NOT NULL,
    min_salary NUMBER(6),
    max_salary NUMBER(6)
);

CREATE TABLE DEPARTMENTS (
    department_id NUMBER(4) PRIMARY KEY,
    department_name VARCHAR2(30) NOT NULL,
    manager_id NUMBER(6),
    location_id NUMBER(4),
    CONSTRAINT fk_dept_loc FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id)
);

CREATE TABLE EMPLOYEES (
    employee_id NUMBER(6) PRIMARY KEY,
    first_name VARCHAR2(20),
    last_name VARCHAR2(25) NOT NULL,
    email VARCHAR2(25) NOT NULL,
    hire_date DATE NOT NULL,
    job_id VARCHAR2(10) NOT NULL,
    salary NUMBER(8, 2),
    commission_pct NUMBER(2, 2),
    manager_id NUMBER(6),
    department_id NUMBER(4),
    CONSTRAINT fk_emp_job FOREIGN KEY (job_id) REFERENCES JOBS(job_id),
    CONSTRAINT fk_emp_dept FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id),
    CONSTRAINT fk_emp_manager FOREIGN KEY (manager_id) REFERENCES EMPLOYEES(employee_id)
);

ALTER TABLE DEPARTMENTS 
ADD CONSTRAINT fk_dept_mgr FOREIGN KEY (manager_id) REFERENCES EMPLOYEES(employee_id);

CREATE TABLE JOB_HISTORY (
    employee_id NUMBER(6),
    start_date DATE,
    end_date DATE NOT NULL,
    job_id VARCHAR2(10) NOT NULL,
    department_id NUMBER(4),
    PRIMARY KEY (employee_id, start_date),
    CONSTRAINT fk_jh_emp FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id),
    CONSTRAINT fk_jh_job FOREIGN KEY (job_id) REFERENCES JOBS(job_id),
    CONSTRAINT fk_jh_dept FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id)
);

DESC s_emp; 
DESC s_dept; 
SELECT table_name FROM user_tables ORDER BY table_name;

INSERT INTO REGIONS VALUES (1, 'Europe');
INSERT INTO REGIONS VALUES (2, 'Americas');
INSERT INTO REGIONS VALUES (3, 'Asia');

INSERT INTO COUNTRIES VALUES ('US', 'United States of America', 2);
INSERT INTO COUNTRIES VALUES ('CA', 'Canada', 2);
INSERT INTO COUNTRIES VALUES ('UK', 'United Kingdom', 1);

INSERT INTO LOCATIONS VALUES (1700, '2004 Charade Rd', '98199', 'Seattle', 'California', 'US');
INSERT INTO LOCATIONS VALUES (1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA');

INSERT INTO JOBS VALUES ('AD_PRES', 'President', 20000, 40000);
INSERT INTO JOBS VALUES ('ST_MAN', 'Stock Manager', 5500, 8500);
INSERT INTO JOBS VALUES ('IT_PROG', 'Programmer', 4000, 10000);
INSERT INTO JOBS VALUES ('SA_REP', 'Sales representative', 6000, 12000);
INSERT INTO JOBS VALUES ('ST_CLERK', 'Stock clert', 2000, 5000);

INSERT INTO DEPARTMENTS VALUES (10, 'Administration', NULL, 1700);
INSERT INTO DEPARTMENTS VALUES (20, 'Marketing', NULL, 1800);
INSERT INTO DEPARTMENTS VALUES (50, 'Shipping', NULL, 1700);
INSERT INTO DEPARTMENTS VALUES (60, 'IT', NULL, 1700);
INSERT INTO DEPARTMENTS VALUES (80, 'Sales', NULL, 1700);
INSERT INTO DEPARTMENTS VALUES (500, 'Empty Dept', NULL, 1700);

INSERT INTO EMPLOYEES VALUES (100, 'Steven', 'King', 'SKING', TO_DATE('17-06-1987', 'DD-MM-YYYY'), 'AD_PRES', 24000, NULL, NULL, 10);
INSERT INTO EMPLOYEES VALUES (101, 'Curtis', 'Davies', 'CDAVIES', TO_DATE('29-01-1995', 'DD-MM-YYYY'), 'ST_MAN', 3100, NULL, 100, 50);
INSERT INTO EMPLOYEES VALUES (3, 'Temp', 'Name', 'TNAME', TO_DATE('01-01-1994', 'DD-MM-YYYY'), 'ST_CLERK', 850, NULL, 101, 50);
INSERT INTO EMPLOYEES VALUES (102, 'Eleni', 'Zlotkey', 'EZLOTKEY', TO_DATE('20-02-1998', 'DD-MM-YYYY'), 'SA_REP', 10500, 0.2, 100, 80);
INSERT INTO EMPLOYEES VALUES (103, 'Peter', 'Hall', 'PHALL', TO_DATE('20-03-1998', 'DD-MM-YYYY'), 'SA_REP', 9000, 0.1, 102, 80);
INSERT INTO EMPLOYEES VALUES (104, 'Kimberely', 'Grant', 'KGRANT', TO_DATE('15-12-1994', 'DD-MM-YYYY'), 'SA_REP', 7000, 0.15, 100, NULL);
INSERT INTO EMPLOYEES VALUES (105, 'Jennifer', 'Whalen', 'JWHALEN', TO_DATE('17-09-1987', 'DD-MM-YYYY'), 'IT_PROG', 4400, NULL, 101, 20);
INSERT INTO EMPLOYEES VALUES (106, 'Martha', 'Lorentz', 'MLORENTZ', TO_DATE('07-02-1998', 'DD-MM-YYYY'), 'IT_PROG', 4000, NULL, 103, 60);
INSERT INTO EMPLOYEES VALUES (107, 'Guy', 'Himuro', 'GHIMURO', TO_DATE('01-05-1994', 'DD-MM-YYYY'), 'ST_CLERK', 2600, NULL, 101, 50);

UPDATE DEPARTMENTS SET manager_id = 100 WHERE department_id = 10;
UPDATE DEPARTMENTS SET manager_id = 105 WHERE department_id = 20;
UPDATE DEPARTMENTS SET manager_id = 101 WHERE department_id = 50;

SELECT last_name, salary
FROM employees
WHERE salary > 12000;

SELECT last_name, salary
FROM employees
WHERE salary < 5000 OR salary > 12000;

SELECT last_name, job_id, hire_date
FROM employees
WHERE hire_date BETWEEN TO_DATE('20/02/1998','DD/MM/YYYY')
AND TO_DATE('01/05/1998','DD/MM/YYYY')
ORDER BY hire_date ASC;

SELECT last_name, department_id
FROM employees
WHERE department_id IN (20, 50)
ORDER BY last_name ASC;

SELECT last_name, hire_date
FROM employees
WHERE TO_CHAR(hire_date, 'YYYY') = '1994';

SELECT last_name, job_id
FROM employees
WHERE manager_id IS NULL;

SELECT last_name, salary, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary DESC, commission_pct DESC;

SELECT last_name
FROM employees
WHERE last_name LIKE '__a%';

SELECT last_name
FROM employees
WHERE last_name LIKE '%a%'
AND last_name LIKE '%e%';

SELECT last_name, job_id, salary
FROM employees
WHERE job_id IN ('SA_REP', 'ST_CLERK')
AND salary NOT IN (2500, 3500, 7000);

SELECT employee_id,last_name,
ROUND(salary * 1.15, 0) AS "New Salary"
FROM employees;

SELECT INITCAP(last_name) AS "Ten Nhan Vien",
LENGTH(last_name) AS "Chieu Dai"
FROM employees
WHERE SUBSTR(last_name, 1, 1) IN ('J','A','L','M')
ORDER BY last_name ASC;

SELECT last_name,
TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)) AS "So Thang Lam Viec"
FROM employees
ORDER BY MONTHS_BETWEEN(SYSDATE, hire_date) ASC;

SELECT last_name || ' earns '
    || TO_CHAR(salary, '$99,999') || ' monthly but wants '
    || TO_CHAR(salary*3, '$99,999') AS "Dream Salaries"
FROM employees;

SELECT last_name,
CASE WHEN commission_pct IS NULL THEN 'No commission'
ELSE TO_CHAR(commission_pct)
END AS "Commission"
FROM employees;

SELECT job_id,
       DECODE(job_id,
              'AD_PRES',  'A',
              'ST_MAN',   'B',
              'IT_PROG',  'C',
              'SA_REP',   'D',
              'ST_CLERK', 'E',
              '0') AS "GRADE"
FROM employees;

SELECT e.last_name, e.department_id, d.department_name
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id
AND UPPER(l.city) = 'TORONTO';

SELECT e.employee_id  AS "Ma NV",
       e.last_name AS "Ten NV",
       m.employee_id AS "Ma Quan Ly",
       m.last_name AS "Ten Quan Ly"
FROM  employees e, employees m
WHERE e.manager_id = m.employee_id;

SELECT e1.last_name AS "Nhan Vien 1",
       e2.last_name AS "Nhan Vien 2",
       e1.department_id AS "Phong Ban"
FROM   employees e1, employees e2
WHERE  e1.department_id = e2.department_id
  AND  e1.employee_id   < e2.employee_id
ORDER BY e1.department_id, e1.last_name;

SELECT last_name, hire_date
FROM employees
WHERE hire_date > (SELECT hire_date
FROM employees
WHERE last_name = 'Davies');

SELECT e.last_name   AS "Nhan Vien",
       e.hire_date   AS "Ngay Vao",
       m.last_name   AS "Quan Ly",
       m.hire_date   AS "Quan Ly Vao"
FROM   employees e, employees m
WHERE  e.manager_id = m.employee_id
  AND  e.hire_date  < m.hire_date;
  
SELECT job_id,
       MIN(salary) AS "Luong Thap Nhat",
       MAX(salary) AS "Luong Cao Nhat",
       ROUND(AVG(salary),2) AS "Luong Trung Binh",
       SUM(salary) AS "Tong Luong"
FROM   employees
GROUP BY job_id
ORDER BY job_id;

SELECT d.department_id,
d.department_name,
COUNT(e.employee_id) AS "So Nhan Vien"
FROM departments d LEFT JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY d.department_id;

SELECT COUNT(*) AS "Tong NV",
  SUM(CASE WHEN TO_CHAR(hire_date,'YYYY')='1995' THEN 1 ELSE 0 END) AS "Nam 1995",
  SUM(CASE WHEN TO_CHAR(hire_date,'YYYY')='1996' THEN 1 ELSE 0 END) AS "Nam 1996",
  SUM(CASE WHEN TO_CHAR(hire_date,'YYYY')='1997' THEN 1 ELSE 0 END) AS "Nam 1997",
  SUM(CASE WHEN TO_CHAR(hire_date,'YYYY')='1998' THEN 1 ELSE 0 END) AS "Nam 1998"
FROM employees;

SELECT last_name, hire_date
FROM employees
WHERE department_id = (SELECT department_id
FROM employees
WHERE last_name = 'Zlotkey')
AND last_name <> 'Zlotkey';

SELECT last_name, department_id, job_id
FROM employees
WHERE department_id IN (SELECT department_id
FROM departments
WHERE location_id = 1700);

SELECT last_name, manager_id
FROM employees
WHERE manager_id IN (SELECT employee_id
FROM employees
WHERE last_name = 'King');

SELECT last_name, salary, department_id
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
AND department_id IN (SELECT department_id
FROM employees
WHERE last_name LIKE '%n');

SELECT d.department_id, d.department_name, COUNT(e.employee_id) AS "So NV"
FROM departments d LEFT JOIN employees e
ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(e.employee_id) < 3
ORDER BY d.department_id;

SELECT department_id, COUNT(*) AS "So Nhan Vien", 'Dong nhat' AS "Loai"
FROM   employees
GROUP BY department_id
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM employees GROUP BY department_id)
UNION ALL
SELECT department_id, COUNT(*), 'It nhat'
FROM   employees
GROUP BY department_id
HAVING COUNT(*) = (SELECT MIN(COUNT(*)) FROM employees GROUP BY department_id);

SELECT last_name, hire_date,
       TO_CHAR(hire_date,'Day') AS "Thu trong tuan"
FROM   employees
WHERE  TO_CHAR(hire_date,'Day') IN (
    SELECT TO_CHAR(hire_date,'Day')
    FROM   employees
    GROUP BY TO_CHAR(hire_date,'Day')
    HAVING COUNT(*) = (
        SELECT MAX(COUNT(*))
        FROM   employees
        GROUP BY TO_CHAR(hire_date,'Day')
    )
);

SELECT last_name, salary
FROM (
SELECT last_name, salary
FROM employees
ORDER BY salary DESC
)
WHERE ROWNUM <= 3;

SELECT e.last_name, e.department_id
FROM employees e,
departments d,
locations l
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id
AND UPPER(l.state_province) = 'CALIFORNIA';

-- Kiem tra truoc
SELECT employee_id, last_name FROM employees WHERE employee_id = 3;
-- Cap nhat
UPDATE employees
SET last_name = 'Drexler'
WHERE employee_id = 3;
COMMIT;
-- Xac nhan sau khi cap nhat
SELECT employee_id, last_name FROM employees WHERE employee_id = 3;

SELECT e1.last_name, e1.salary, e1.department_id
FROM employees e1
WHERE e1.salary < (SELECT AVG(e2.salary)
FROM employees e2
WHERE e2.department_id = e1.department_id)
ORDER BY e1.department_id;

-- Kiem tra truoc: xem ai bi anh huong
SELECT employee_id, last_name, salary
FROM employees
WHERE salary < 900;
-- Tang luong
UPDATE employees
SET salary = salary + 100
WHERE salary < 900;
COMMIT;

-- Kiem tra: co nhan vien trong phong 500 khong?
SELECT COUNT(*) FROM employees WHERE department_id = 500;
-- Phong trong (khong co nhan vien)
DELETE FROM departments WHERE department_id = 500;
COMMIT;


DELETE FROM departments d
WHERE NOT EXISTS (
SELECT 1 FROM employees e
WHERE e.department_id = d.department_id
);
COMMIT;