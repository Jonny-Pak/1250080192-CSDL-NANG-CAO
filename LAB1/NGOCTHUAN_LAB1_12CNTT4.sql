CREATE TABLE s_region ( 
    id NUMBER(7) CONSTRAINT s_region_id_pk PRIMARY KEY, 
    name VARCHAR2(50) NOT NULL 
);

CREATE TABLE s_dept ( 
    id NUMBER(7) CONSTRAINT s_dept_id_pk PRIMARY KEY, 
    name VARCHAR2(25) NOT NULL, 
    region_id  NUMBER(7) CONSTRAINT s_dept_region_id_fk
    REFERENCES s_region(id) 
);

CREATE TABLE s_emp (
    id NUMBER(7) CONSTRAINT s_emp_id_pk PRIMARY KEY,
    last_name VARCHAR2(25) NOT NULL,
    first_name VARCHAR2(25),
    userid VARCHAR2(8) CONSTRAINT s_emp_userid_uk UNIQUE,
    start_date DATE,
    comments VARCHAR2(255),
    manager_id NUMBER(7) CONSTRAINT s_emp_mgr_fk REFERENCES s_emp(id),
    title VARCHAR2(25),
    dept_id NUMBER(7) CONSTRAINT s_emp_dept_id_fk REFERENCES s_dept(id),
    salary NUMBER(11, 2),
    commission_pct NUMBER(4, 2)
);

CREATE TABLE s_image (
    id NUMBER(7) CONSTRAINT s_image_id_pk PRIMARY KEY,
    format VARCHAR2(25),
    use_filename VARCHAR2(1),
    filename VARCHAR2(255),
    image BLOB
);

CREATE TABLE s_title (
    title VARCHAR2(25) CONSTRAINT s_title_pk PRIMARY KEY
);

CREATE TABLE s_longtext (
    id NUMBER(7) CONSTRAINT s_longtext_id_pk PRIMARY KEY,
    use_filename VARCHAR2(1),
    filename VARCHAR2(255),
    text CLOB
);

CREATE TABLE s_customer (
    id NUMBER(7) CONSTRAINT s_customer_id_pk PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    phone VARCHAR2(10),
    address VARCHAR2(400),
    city VARCHAR2(30),
    state VARCHAR2(20),
    country VARCHAR2(30),
    zip_code VARCHAR2(15),
    credit_rating VARCHAR2(9),
    sales_rep_id NUMBER(7) CONSTRAINT s_customer_rep_id_fk REFERENCES s_emp(id),
    region_id NUMBER(7) CONSTRAINT s_customer_reg_id_fk REFERENCES s_region(id),
    comments VARCHAR2(255)
);

CREATE TABLE s_product (
    id NUMBER(7) CONSTRAINT s_product_id_pk PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    short_desc VARCHAR2(255),
    longtext_id NUMBER(7),
    image_id NUMBER(7) CONSTRAINT s_product_image_id_fk REFERENCES s_image(id),
    suggested_whlsl_price NUMBER(11, 2),
    whlsl_units VARCHAR2(25)
);

CREATE TABLE s_ord (
    id NUMBER(7) CONSTRAINT s_ord_id_pk PRIMARY KEY,
    customer_id NUMBER(7) CONSTRAINT s_ord_cust_id_fk REFERENCES s_customer(id),
    date_ordered DATE,
    date_shipped DATE,
    sales_rep_id NUMBER(7) CONSTRAINT s_ord_rep_id_fk REFERENCES s_emp(id),
    total NUMBER(11, 2),
    payment_type VARCHAR2(15),
    order_filled VARCHAR2(1)
);

CREATE TABLE s_item (
    ord_id NUMBER(7) CONSTRAINT s_item_ord_id_fk REFERENCES s_ord(id),
    item_id NUMBER(7),
    product_id NUMBER(7) CONSTRAINT s_item_prod_id_fk REFERENCES s_product(id),
    price NUMBER(11, 2),
    quantity NUMBER(9),
    quantity_shipped NUMBER(9),
    CONSTRAINT s_item_pk PRIMARY KEY (ord_id, item_id)
);

CREATE TABLE s_warehouse (
    id NUMBER(7) CONSTRAINT s_warehouse_id_pk PRIMARY KEY,
    region_id NUMBER(7) CONSTRAINT s_warehouse_reg_id_fk REFERENCES s_region(id),
    address VARCHAR2(400),
    city VARCHAR2(30),
    state VARCHAR2(20),
    country VARCHAR2(30),
    zip_code VARCHAR2(15),
    phone VARCHAR2(25),
    manager_id NUMBER(7) CONSTRAINT s_warehouse_mgr_id_fk REFERENCES s_emp(id)
);

CREATE TABLE s_inventory (
    product_id NUMBER(7) CONSTRAINT s_inv_prod_id_fk REFERENCES s_product(id),
    warehouse_id NUMBER(7) CONSTRAINT s_inv_war_id_fk REFERENCES s_warehouse(id),
    amount_in_stock NUMBER(9),
    reorder_point NUMBER(9),
    max_in_stock NUMBER(9),
    out_of_stock_explanation VARCHAR2(255),
    restock_date DATE,
    CONSTRAINT s_inventory_pk PRIMARY KEY (product_id, warehouse_id)
);

DESC s_emp; 
DESC s_dept; 
SELECT table_name FROM user_tables ORDER BY table_name;

INSERT INTO s_region (id, name) VALUES (1, 'North America');
INSERT INTO s_region (id, name) VALUES (2, 'South America');
INSERT INTO s_region (id, name) VALUES (3, 'Asia');
INSERT INTO s_region (id, name) VALUES (4, 'Europe');
INSERT INTO s_region (id, name) VALUES (5, 'Africa');
COMMIT;

INSERT INTO s_title (title) VALUES ('President');
INSERT INTO s_title (title) VALUES ('VP, Sales');
INSERT INTO s_title (title) VALUES ('VP, Operations');
INSERT INTO s_title (title) VALUES ('Stock Clerk');
INSERT INTO s_title (title) VALUES ('Sales Representative');
COMMIT;

INSERT INTO s_dept VALUES (10, 'Finance', 1);
INSERT INTO s_dept VALUES (31, 'Sales North', 1);
INSERT INTO s_dept VALUES (42, 'Operations Asia', 3);
INSERT INTO s_dept VALUES (50, 'Marketing Europe', 4);
COMMIT;


INSERT INTO s_emp (id, last_name, first_name, userid, start_date, title, dept_id, salary) 
VALUES (1, 'Velasquez', 'Carmen', 'cvelasqu', TO_DATE('03/03/1990','DD/MM/YYYY'), 'President', 10, 2500);
INSERT INTO s_emp (id, last_name, first_name, userid, start_date, manager_id, title, dept_id, salary) 
VALUES (2, 'Nga', 'Tran', 'tnga', TO_DATE('14/05/1990','DD/MM/YYYY'), 1, 'VP, Sales', 31, 1500);
INSERT INTO s_emp (id, last_name, first_name, userid, start_date, manager_id, title, dept_id, salary) 
VALUES (3, 'Lan', 'Le', 'llan', TO_DATE('20/06/1991','DD/MM/YYYY'), 1, 'VP, Operations', 42, 1600);
INSERT INTO s_emp (id, last_name, first_name, userid, start_date, manager_id, title, dept_id, salary) 
VALUES (4, 'Tam', 'Nguyen Van', 'vtam', TO_DATE('26/05/1991','DD/MM/YYYY'), 1, 'VP, Sales', 50, 1550);
INSERT INTO s_emp (id, last_name, first_name, userid, start_date, manager_id, title, dept_id, salary) 
VALUES (5, 'Binh', 'Dang', 'dbinh', SYSDATE, 3, 'Stock Clerk', 42, 1100);
COMMIT;

INSERT INTO s_image (id, format) VALUES (1, 'JPG');
INSERT INTO s_longtext (id, text) VALUES (1, 'Detailed description for outdoor gear');
COMMIT;

INSERT INTO s_product (id, name, short_desc, suggested_whlsl_price) VALUES (10, 'Pro Bicycle', 'Racing bicycle', 500);
INSERT INTO s_product (id, name, short_desc, suggested_whlsl_price) VALUES (11, 'Mountain Ski', 'High performance ski', 300);
INSERT INTO s_product (id, name, short_desc, suggested_whlsl_price) VALUES (12, 'Pro Helmet', 'Safety helmet', 50);
COMMIT;

INSERT INTO s_warehouse (id, region_id, address, city) VALUES (1, 1, '123 Maple St', 'New York');
INSERT INTO s_warehouse (id, region_id, address, city) VALUES (2, 3, '456 Sakura Rd', 'Tokyo');
COMMIT;

INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (101, 'An Nam Corp', 'Vietnam', 1, 1, 'Good');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (102, 'Liberty Tech', 'USA', 1, 1, 'Excellent');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (103, 'London Trading', 'United Kingdom', 1, 1, 'Good');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (104, 'Tokyo Solar', 'Japan', 1, 1, 'Excellent');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (105, 'Paris Fashion', 'France', 1, 1, 'Good');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (106, 'Berlin Auto', 'Germany', 1, 1, 'Poor');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (107, 'Maple Leaf Co', 'Canada', 1, 1, 'Good');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (108, 'Sydney Marine', 'Australia', 1, 1, 'Excellent');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (109, 'Seoul Electronics', 'South Korea', 1, 1, 'Good');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (110, 'Singa Port', 'Singapore', 1, 1, 'Excellent');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (111, 'Bangkok Rice', 'Thailand', 1, 1, 'Good');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (112, 'Rio Carnival', 'Brazil', 1, 1, 'Poor');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (113, 'Mumbai Spice', 'India', 1, 1, 'Good');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (114, 'Beijing Silk', 'China', 1, 1, 'Excellent');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (115, 'Moscow Ice', 'Russia', 1, 1, 'Poor');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (116, 'Rome Marble', 'Italy', 1, 1, 'Good');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (117, 'Madrid Oil', 'Spain', 1, 1, 'Excellent');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (118, 'Mexico Salsa', 'Mexico', 1, 1, 'Good');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (119, 'Jakarta Tea', 'Indonesia', 1, 1, 'Good');
INSERT INTO s_customer (id, name, country, sales_rep_id, region_id, credit_rating) VALUES (120, 'Kuala Timber', 'Malaysia', 1, 1, 'Poor');
COMMIT;

INSERT INTO s_inventory (product_id, warehouse_id, amount_in_stock, reorder_point) VALUES (10, 1, 100, 20);
INSERT INTO s_inventory (product_id, warehouse_id, amount_in_stock, reorder_point) VALUES (11, 2, 50, 10);
COMMIT;

INSERT INTO s_ord (id, customer_id, date_ordered, sales_rep_id, total, payment_type) 
VALUES (101, 101, SYSDATE, 2, 120000, 'CASH');
INSERT INTO s_ord (id, customer_id, date_ordered, sales_rep_id, total, payment_type) 
VALUES (102, 102, SYSDATE, 4, 85000, 'CREDIT');
COMMIT;

INSERT INTO s_item (ord_id, item_id, product_id, price, quantity) VALUES (101, 1, 10, 500, 200);
INSERT INTO s_item (ord_id, item_id, product_id, price, quantity) VALUES (101, 2, 12, 50, 400);
INSERT INTO s_item (ord_id, item_id, product_id, price, quantity) VALUES (102, 1, 11, 300, 283);
COMMIT;

@D:\CSDL_NC\TH1\TH1_1250080192_BT1.sql;

SELECT name AS "Ten khach hang", 
       id   AS "Ma khach hang" 
FROM s_customer 
ORDER BY id DESC;

SELECT first_name || ' ' || last_name AS "Employees", 
       dept_id 
FROM s_emp 
WHERE dept_id IN (10, 50) 
ORDER BY first_name;

SELECT last_name, first_name 
FROM s_emp 
WHERE first_name LIKE '%T%' 
OR last_name  LIKE '%T%'; 
   
SELECT userid, start_date 
FROM s_emp 
WHERE start_date BETWEEN TO_DATE('14/05/1990','DD/MM/YYYY') 
AND TO_DATE('26/05/1991','DD/MM/YYYY');

SELECT last_name, salary 
FROM   s_emp 
WHERE  salary BETWEEN 1000 AND 2000;

SELECT last_name || ' ' || first_name AS "Employee Name", 
       salary                          AS "Monthly Salary" 
FROM s_emp 
WHERE dept_id IN (31, 42, 50) 
AND  salary  > 1350; 

SELECT last_name, start_date 
FROM   s_emp 
WHERE  TO_CHAR(start_date, 'YYYY') = '1991'; 

SELECT last_name, start_date 
FROM s_emp 
WHERE start_date BETWEEN TO_DATE('01/01/1991','DD/MM/YYYY') 
                     AND TO_DATE('31/12/1991','DD/MM/YYYY');
                     
SELECT last_name, first_name 
FROM s_emp 
WHERE id NOT IN (SELECT DISTINCT manager_id 
FROM s_emp WHERE  manager_id IS NOT NULL); 

SELECT name 
FROM s_product 
WHERE name LIKE 'Pro%' 
ORDER BY name ASC; 

SELECT name, short_desc 
FROM   s_product 
WHERE  LOWER(short_desc) LIKE '%bicycle%'; 

SELECT short_desc 
FROM s_product;

SELECT last_name || ' ' || first_name || ' (' || title || ')' AS "Nhan vien" 
FROM   s_emp; 

SELECT id, last_name, ROUND(salary * 1.15, 2) AS "Luong moi"
FROM s_emp; 

SELECT last_name, 
       start_date, 
       TO_CHAR( 
           NEXT_DAY(ADD_MONTHS(start_date, 6), 'MONDAY'), 
           'Ddspth "of" Month YYYY'
        ) AS "Ngay xet tang luong" 
FROM s_emp;

SELECT name 
FROM s_product 
WHERE LOWER(name) LIKE '%ski%'; 

SELECT last_name, 
ROUND(MONTHS_BETWEEN(SYSDATE, start_date)) AS "So thang tham nien" 
FROM   s_emp 
ORDER BY MONTHS_BETWEEN(SYSDATE, start_date) ASC; 

SELECT COUNT(DISTINCT manager_id) AS "So nguoi quan ly" 
FROM s_emp 
WHERE manager_id IS NOT NULL; 

SELECT MAX(total) AS "Highest", 
MIN(total) AS "Lowest" 
FROM s_ord;

SELECT p.name, 
       p.id, 
       i.quantity AS "ORDERED" 
FROM   s_product p, s_item i 
WHERE p.id    = i.product_id 
AND i.ord_id  = 101;

SELECT c.id  AS "Ma khach hang", 
       o.id  AS "Ma don hang" 
FROM   s_customer c, s_ord o 
WHERE  c.id = o.customer_id(+) 
ORDER BY c.id; 

SELECT c.id  AS "Ma khach hang", 
       o.id  AS "Ma don hang" 
FROM   s_customer c LEFT JOIN s_ord o 
ON c.id = o.customer_id 
ORDER BY c.id; 

SELECT o.customer_id, 
       i.product_id, 
       i.quantity 
FROM   s_ord  o, s_item i 
WHERE  o.id    = i.ord_id 
AND  o.total > 100000; 

SELECT manager_id  AS "Ma quan ly", 
       COUNT(id) AS "So nhan vien" 
FROM  s_emp 
WHERE  manager_id IS NOT NULL 
GROUP BY manager_id 
ORDER BY manager_id;

SELECT manager_id  AS "Ma quan ly",
COUNT(id) AS "So nhan vien" 
FROM   s_emp 
WHERE  manager_id IS NOT NULL 
GROUP BY manager_id 
HAVING COUNT(id) >= 20;

SELECT r.id  AS "Ma vung", 
       r.name AS "Ten vung", 
       COUNT(d.id) AS "So phong ban" 
FROM   s_region r, s_dept d 
WHERE  r.id = d.region_id 
GROUP BY r.id, r.name 
ORDER BY r.id;

SELECT c.name AS "Ten khach hang", 
COUNT(o.id) AS "So don dat hang" 
FROM s_customer c, s_ord o 
WHERE c.id = o.customer_id 
GROUP BY c.id, c.name 
ORDER BY c.name;

SELECT c.name, COUNT(o.id) AS "So don hang" 
FROM s_customer c, s_ord o 
WHERE c.id = o.customer_id 
GROUP BY c.id, c.name 
HAVING COUNT(o.id) = ( 
    SELECT MAX(COUNT(id)) 
    FROM   s_ord 
    GROUP BY customer_id 
);

SELECT c.name, SUM(o.total) AS "Tong tien" 
FROM s_customer c, s_ord o 
WHERE  c.id = o.customer_id 
GROUP BY c.id, c.name 
HAVING SUM(o.total) = ( 
    SELECT MAX(SUM(total)) 
    FROM   s_ord 
    GROUP BY customer_id 
);

SELECT last_name, first_name, start_date 
FROM   s_emp 
WHERE  dept_id = ( 
 SELECT dept_id 
 FROM   s_emp 
 WHERE  first_name = 'Lan' 
) 
AND first_name != 'Lan';

SELECT last_name, first_name, start_date 
FROM   s_emp 
WHERE  dept_id IN (SELECT dept_id FROM s_emp WHERE first_name = 'Lan') 
AND  first_name != 'Lan'; 

SELECT id, last_name, first_name, userid 
FROM   s_emp 
WHERE  salary > (SELECT AVG(salary) FROM s_emp); 

SELECT id, last_name, first_name 
FROM  s_emp 
WHERE salary > (SELECT AVG(salary) FROM s_emp) 
AND (UPPER(first_name) LIKE '%L%' 
OR UPPER(last_name)  LIKE '%L%'); 

SELECT name 
FROM s_customer 
WHERE id NOT IN ( 
    SELECT DISTINCT customer_id 
    FROM   s_ord 
    WHERE  customer_id IS NOT NULL 
); 

SELECT c.name 
FROM s_customer c 
WHERE  NOT EXISTS ( 
    SELECT 1 
    FROM   s_ord o 
    WHERE  o.customer_id = c.id 
);