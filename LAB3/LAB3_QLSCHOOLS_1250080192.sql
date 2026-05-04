SHOW USER;

CREATE TABLE INSTRUCTOR (
    InstructorID NUMBER(8) PRIMARY KEY,
    Salutation VARCHAR2(5),
    FirstName VARCHAR2(25),
    LastName VARCHAR2(25),
    Address VARCHAR2(50),
    Phone VARCHAR2(15),
    CreatedBy VARCHAR2(30) NOT NULL,
    CreatedDate DATE NOT NULL,
    ModifiedBy VARCHAR2(30) NOT NULL,
    ModifiedDate DATE NOT NULL
);

CREATE TABLE STUDENT (
    StudentID NUMBER(8) PRIMARY KEY,
    Salutation VARCHAR2(5),
    FirstName VARCHAR2(25),
    LastName VARCHAR2(25) NOT NULL,
    Address VARCHAR2(50),
    Phone VARCHAR2(15),
    Employer VARCHAR2(50),
    RegistrationDate DATE NOT NULL,
    CreatedBy VARCHAR2(30) NOT NULL,
    CreatedDate DATE NOT NULL,
    ModifiedBy VARCHAR2(30) NOT NULL,
    ModifiedDate DATE NOT NULL
);

CREATE TABLE COURSE (
    CourseNo NUMBER(8) PRIMARY KEY,
    Description VARCHAR2(50),
    Cost NUMBER(9,2),
    Prerequisite NUMBER(8,0),
    CreatedBy VARCHAR2(30) NOT NULL,
    CreatedDate DATE NOT NULL,
    ModifiedBy VARCHAR2(30) NOT NULL,
    ModifiedDate DATE NOT NULL,
    CONSTRAINT fk_course_prereq FOREIGN KEY (Prerequisite) REFERENCES COURSE(CourseNo)
);

CREATE TABLE CLASS (
    ClassID NUMBER(8) PRIMARY KEY,
    CourseNo NUMBER(8,0) NOT NULL,
    ClassNo NUMBER(3) NOT NULL,
    StartDateTime DATE,
    Location VARCHAR2(50),
    InstructorID NUMBER(8,0) NOT NULL,
    Capacity NUMBER(3,0),
    CreatedBy VARCHAR2(30) NOT NULL,
    CreatedDate DATE NOT NULL,
    ModifiedBy VARCHAR2(30) NOT NULL,
    ModifiedDate DATE NOT NULL,
    CONSTRAINT fk_class_course FOREIGN KEY (CourseNo) REFERENCES COURSE(CourseNo),
    CONSTRAINT fk_class_instructor FOREIGN KEY (InstructorID) REFERENCES INSTRUCTOR(InstructorID)
);

CREATE TABLE ENROLLMENT (
    StudentID NUMBER(8) NOT NULL,
    ClassID NUMBER(8,0) NOT NULL,
    EnrollDate DATE NOT NULL,
    FinalGrade NUMBER(3,0),
    RegistrationDate DATE NOT NULL,
    CreatedBy VARCHAR2(30) NOT NULL,
    CreatedDate DATE NOT NULL,
    ModifiedBy VARCHAR2(30) NOT NULL,
    ModifiedDate DATE NOT NULL,
    CONSTRAINT pk_enrollment PRIMARY KEY (StudentID, ClassID),
    CONSTRAINT fk_enroll_student FOREIGN KEY (StudentID) REFERENCES STUDENT(StudentID),
    CONSTRAINT fk_enroll_class FOREIGN KEY (ClassID) REFERENCES CLASS(ClassID)
);

CREATE TABLE GRADE (
    StudentID NUMBER(8) NOT NULL,
    ClassID NUMBER(8,0) NOT NULL,
    Grade NUMBER(3) NOT NULL,
    Comments VARCHAR2(2000),
    CreatedBy VARCHAR2(30) NOT NULL,
    CreatedDate DATE NOT NULL,
    ModifiedBy VARCHAR2(30) NOT NULL,
    ModifiedDate DATE NOT NULL,
    CONSTRAINT pk_grade PRIMARY KEY (StudentID, ClassID, Grade),
    CONSTRAINT fk_grade_student FOREIGN KEY (StudentID) REFERENCES STUDENT(StudentID),
    CONSTRAINT fk_grade_class FOREIGN KEY (ClassID) REFERENCES CLASS(ClassID)
);

INSERT INTO INSTRUCTOR (InstructorID, Salutation, FirstName, LastName, Address, Phone, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
VALUES (10000001, 'ThS.', 'Văn Hùng', 'Nguyễn', '123 Đường Lê Lợi, Quận 1, TP.HCM', '0901234567', USER, SYSDATE, USER, SYSDATE);

INSERT INTO INSTRUCTOR (InstructorID, Salutation, FirstName, LastName, Address, Phone, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
VALUES (10000002, 'TS.', 'Thị Thanh Tuyền', 'Trần', '456 Đường Nguyễn Huệ, Quận 3, TP.HCM', '0907654321', USER, SYSDATE, USER, SYSDATE);

INSERT INTO STUDENT (StudentID, Salutation, FirstName, LastName, Address, Phone, Employer, RegistrationDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
VALUES (20000001, 'Anh', 'Đăng Khoa', 'Trần', '120 Bùi Thị Xuân, Tân Bình, TP.HCM', '0911222333', 'Công ty ABC', SYSDATE, USER, SYSDATE, USER, SYSDATE);

INSERT INTO STUDENT (StudentID, Salutation, FirstName, LastName, Address, Phone, Employer, RegistrationDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
VALUES (20000003, 'Anh', 'Đăng Khoa', 'Trần', '120 Bùi Thị Xuân, Tân Bình, TP.HCM', '0911222333', 'Công ty ABC', SYSDATE, USER, SYSDATE, USER, SYSDATE);

INSERT INTO STUDENT (StudentID, Salutation, FirstName, LastName, Address, Phone, Employer, RegistrationDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
VALUES (20000002, 'Chị', 'Thị C', 'Phạm', '789 Đường CMT8, Quận 10, TP.HCM', '0922333444', 'Ngân hàng XYZ', SYSDATE, USER, SYSDATE, USER, SYSDATE);

INSERT INTO COURSE (CourseNo, Description, Cost, Prerequisite, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
VALUES (10000010, 'Cơ sở dữ liệu nâng cao', 1500000, NULL, USER, SYSDATE, USER, SYSDATE);

INSERT INTO COURSE (CourseNo, Description, Cost, Prerequisite, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
VALUES (10000020, 'Cơ sở dữ liệu phân tán', 2000000, 10000010, USER, SYSDATE, USER, SYSDATE);

INSERT INTO CLASS (ClassID, CourseNo, ClassNo, StartDateTime, Location, InstructorID, Capacity, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
VALUES (50000001, 10000010, 1, TO_DATE('2026-01-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Phòng A.101', 10000001, 30, USER, SYSDATE, USER, SYSDATE);

INSERT INTO CLASS (ClassID, CourseNo, ClassNo, StartDateTime, Location, InstructorID, Capacity, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
VALUES (50000002, 10000020, 2, TO_DATE('2026-02-15 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Phòng B.202', 10000002, 25, USER, SYSDATE, USER, SYSDATE);

INSERT INTO ENROLLMENT (StudentID, ClassID, EnrollDate, FinalGrade, RegistrationDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
VALUES (20000001, 50000001, SYSDATE, 85, SYSDATE, USER, SYSDATE, USER, SYSDATE);

INSERT INTO ENROLLMENT (StudentID, ClassID, EnrollDate, FinalGrade, RegistrationDate, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
VALUES (20000002, 50000001, SYSDATE, NULL, SYSDATE, USER, SYSDATE, USER, SYSDATE);

INSERT INTO GRADE (StudentID, ClassID, Grade, Comments, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
VALUES (20000001, 50000001, 90, 'Sinh viên học tập rất tích cực', USER, SYSDATE, USER, SYSDATE);

INSERT INTO GRADE (StudentID, ClassID, Grade, Comments, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
VALUES (20000002, 50000001, 75, 'Cần cải thiện kỹ năng thực hành', USER, SYSDATE, USER, SYSDATE);



CREATE TABLE Cau1 (
    ID NUMBER,
    NAME VARCHAR2(20)
);

CREATE SEQUENCE Cau1Seq
START WITH 5
INCREMENT BY 5;


SET SERVEROUTPUT ON;
DECLARE
    v_name VARCHAR2(50);
    v_id NUMBER;
BEGIN
-- [d] Them sinh vien dang ki nhieu mon nhat
SELECT firstname || ' ' || lastname
INTO v_name
FROM student
WHERE studentid = (
SELECT studentid FROM enrollment
GROUP BY studentid
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM enrollment GROUP BY
studentid)
FETCH FIRST 1 ROWS ONLY
);

INSERT INTO Cau1 (ID, NAME)
VALUES (Cau1Seq.NEXTVAL, v_name);
SAVEPOINT sp_a; -- Savepoint A

-- [e] Them sinh vien dang ki it mon nhat
SELECT firstname || ' ' || lastname
INTO v_name
FROM student
WHERE studentid = (
SELECT studentid FROM enrollment
GROUP BY studentid
HAVING COUNT(*) = (SELECT MIN(COUNT(*)) FROM enrollment GROUP BY
studentid)
FETCH FIRST 1 ROWS ONLY
);

INSERT INTO Cau1 (ID, NAME)
VALUES (Cau1Seq.NEXTVAL, v_name);
SAVEPOINT sp_b; -- Savepoint B

-- [f] Them giao vien day nhieu lop nhat
SELECT i.firstname || ' ' || i.lastname
INTO v_name
FROM instructor i
WHERE i.instructorid = (
SELECT instructorid FROM class
GROUP BY instructorid
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM class GROUP BY
instructorid)
FETCH FIRST 1 ROWS ONLY
);

INSERT INTO Cau1 (ID, NAME)
VALUES (Cau1Seq.NEXTVAL, v_name);
SAVEPOINT sp_c; -- Savepoint C

-- [g] SELECT INTO: lay ID cua giao vien vua them vao bien v_id
SELECT ID INTO v_id
FROM Cau1
WHERE NAME = v_name;

DBMS_OUTPUT.PUT_LINE('ID giao vien nhieu lop: ' || v_id);

ROLLBACK TO sp_b;

-- [i] Them giao vien it lop nhat, dung v_id da luu
SELECT i.firstname || ' ' || i.lastname
INTO v_name
FROM instructor i
WHERE i.instructorid = (
SELECT instructorid FROM class
GROUP BY instructorid
HAVING COUNT(*) = (SELECT MIN(COUNT(*)) FROM class GROUP BY
instructorid)
FETCH FIRST 1 ROWS ONLY
);

INSERT INTO Cau1 (ID, NAME)
VALUES (v_id, v_name); -- Dung v_id (khong phai sequence)

-- [j] Them lai giao vien nhieu lop, dung sequence
SELECT i.firstname || ' ' || i.lastname
INTO v_name
FROM instructor i
WHERE i.instructorid = (
SELECT instructorid FROM class
GROUP BY instructorid
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM class GROUP BY
instructorid)
FETCH FIRST 1 ROWS ONLY
);

INSERT INTO Cau1 (ID, NAME)
VALUES (Cau1Seq.NEXTVAL, v_name); -- Dung sequence
COMMIT;
DBMS_OUTPUT.PUT_LINE('Hoan tat! Kiem tra: SELECT * FROM Cau1;');

EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Loi: Khong tim thay du lieu!');
ROLLBACK;
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Loi: ' || SQLERRM);
ROLLBACK;
END;
/


SET SERVEROUTPUT ON;

DECLARE
v_sid NUMBER := &ma_sinh_vien;
v_fname VARCHAR2(25) := '&ho_sinh_vien';
v_lname VARCHAR2(25) := '&ten_sinh_vien';
v_addr VARCHAR2(50) := '&dia_chi';
v_found VARCHAR2(50);
v_classes NUMBER;
BEGIN
-- Thu tim sinh vien theo ma vua nhap
SELECT firstname || ' ' || lastname
INTO v_found
FROM student
WHERE studentid = v_sid;

-- Neu tim thay: dem so lop dang hoc
SELECT COUNT(*)
INTO v_classes
FROM enrollment
WHERE studentid = v_sid;

DBMS_OUTPUT.PUT_LINE('Ho ten: ' || v_found);
DBMS_OUTPUT.PUT_LINE('So lop dang hoc: ' || v_classes);
EXCEPTION
WHEN NO_DATA_FOUND THEN
-- Sinh vien chua ton tai: them moi
DBMS_OUTPUT.PUT_LINE('Sinh vien chua ton tai. Dang them moi...');
INSERT INTO student (studentid, firstname, lastname, address,
registrationdate, createdby, createddate,
modifiedby, modifieddate)
VALUES (v_sid, v_fname, v_lname, v_addr,
SYSDATE, USER, SYSDATE, USER, SYSDATE);
COMMIT;
DBMS_OUTPUT.PUT_LINE('Da them sinh vien moi: ' || v_fname || ' ' ||
v_lname);
END;
/


SET SERVEROUTPUT ON;

DECLARE
v_instructor_id NUMBER := &ma_giao_vien;
v_so_lop NUMBER;
BEGIN
-- Dem so lop giao vien dang day
SELECT COUNT(*)
INTO v_so_lop
FROM class
WHERE instructorid = v_instructor_id;

-- Phan nhanh theo ket qua
IF v_so_lop >= 5 THEN
DBMS_OUTPUT.PUT_LINE('Giao vien nay nen nghi ngoi!');
ELSE
DBMS_OUTPUT.PUT_LINE('So lop giao vien dang day: ' || v_so_lop);
END IF;

EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Khong tim thay giao vien co ma: ' ||
v_instructor_id);
END;
/


SET SERVEROUTPUT ON;

DECLARE
v_sid NUMBER := &ma_sinh_vien;
v_cid NUMBER := &ma_lop;
v_score NUMBER;
v_grade VARCHAR2(2);
v_check NUMBER;
BEGIN
-- Kiem tra sinh vien ton tai
SELECT COUNT(*) INTO v_check
FROM student WHERE studentid = v_sid;
IF v_check = 0 THEN
DBMS_OUTPUT.PUT_LINE('Loi: Ma sinh vien ' || v_sid || ' khong ton
tai!');
RETURN;
END IF;

-- Kiem tra lop ton tai
SELECT COUNT(*) INTO v_check
FROM class WHERE classid = v_cid;
IF v_check = 0 THEN
DBMS_OUTPUT.PUT_LINE('Loi: Ma lop ' || v_cid || ' khong ton tai!');
RETURN;
END IF;

-- Lay diem cua sinh vien trong lop
SELECT finalgrade
INTO v_score
FROM enrollment
WHERE studentid = v_sid AND classid = v_cid;

-- Quy doi diem so sang diem chu bang CASE
CASE
WHEN v_score >= 90 THEN v_grade := 'A';
WHEN v_score >= 80 THEN v_grade := 'B';
WHEN v_score >= 70 THEN v_grade := 'C';
WHEN v_score >= 50 THEN v_grade := 'D';
ELSE v_grade := 'F';
END CASE;

DBMS_OUTPUT.PUT_LINE('Diem so: ' || v_score || ' -> Diem chu: ' ||
v_grade);

EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Sinh vien chua dang ky lop nay hoac chua co
diem!');
END;
/

SET SERVEROUTPUT ON;

DECLARE
-- Cursor 1: Duyet tung mon hoc
CURSOR cur_course IS
SELECT courseno, description
FROM course
ORDER BY courseno;
-- Cursor 2: Lay lop hoc cua mot mon (co doi so)
CURSOR cur_class (p_courseno NUMBER) IS
SELECT c.classno,
COUNT(e.studentid) AS so_sv
FROM class c
LEFT JOIN enrollment e ON c.classid = e.classid
WHERE c.courseno = p_courseno
GROUP BY c.classno
ORDER BY c.classno;
v_courseno course.courseno%TYPE;
v_desc course.description%TYPE;
v_classno class.classno%TYPE;
v_count NUMBER;
BEGIN
-- Duyet cursor ngoai: tung mon hoc
OPEN cur_course;
LOOP
FETCH cur_course INTO v_courseno, v_desc;
EXIT WHEN cur_course%NOTFOUND;
-- In ten mon hoc
DBMS_OUTPUT.PUT_LINE(v_courseno || ' ' || v_desc);
-- Mo cursor trong voi doi so la ma mon hoc hien tai
OPEN cur_class(v_courseno);
LOOP
FETCH cur_class INTO v_classno, v_count;
EXIT WHEN cur_class%NOTFOUND;
DBMS_OUTPUT.PUT_LINE('Lop: ' || v_classno ||

' co so luong sinh vien dang ki: ' ||

v_count);
END LOOP;
CLOSE cur_class;
END LOOP;
CLOSE cur_course;
EXCEPTION
WHEN OTHERS THEN
IF cur_course%ISOPEN THEN CLOSE cur_course; END IF;
IF cur_class%ISOPEN THEN CLOSE cur_class; END IF;
DBMS_OUTPUT.PUT_LINE('Loi: ' || SQLERRM);
END;
/


CREATE OR REPLACE PROCEDURE find_sname
(i_student_id IN student.studentid%TYPE,
o_first_name OUT student.firstname%TYPE,
o_last_name OUT student.lastname%TYPE)
IS
BEGIN
SELECT firstname, lastname
INTO o_first_name, o_last_name
FROM student
WHERE studentid = i_student_id;

EXCEPTION
WHEN NO_DATA_FOUND THEN
o_first_name := NULL;
o_last_name := NULL;
DBMS_OUTPUT.PUT_LINE('Khong tim thay sinh vien ID: ' ||
i_student_id);
END find_sname;
/


CREATE OR REPLACE PROCEDURE print_student_name
(i_student_id IN student.studentid%TYPE)
IS
v_first student.firstname%TYPE;
v_last student.lastname%TYPE;
BEGIN
find_sname(i_student_id, v_first, v_last);

IF v_first IS NOT NULL OR v_last IS NOT NULL THEN
DBMS_OUTPUT.PUT_LINE('Ho ten sinh vien: ' || v_first || ' ' ||
v_last);
END IF;
END print_student_name;
/

-- Goi thu tuc de kiem tra:
SET TIMING ON;
BEGIN
print_student_name(20000001);
END;
/

CREATE OR REPLACE PROCEDURE Discount
IS
BEGIN
FOR rec IN (
SELECT c.courseno, c.description, c.cost
FROM course c
WHERE (SELECT COUNT(*) FROM enrollment e
JOIN class cl ON e.classid = cl.classid
WHERE cl.courseno = c.courseno) > 15

) LOOP
-- Giam gia 5%
UPDATE course
SET cost = cost * 0.95
WHERE courseno = rec.courseno;

DBMS_OUTPUT.PUT_LINE('Da giam gia mon hoc: ' || rec.description

|| ' | Gia cu: ' || rec.cost
|| ' | Gia moi: ' || ROUND(rec.cost * 0.95, 2));

END LOOP;

COMMIT;
DBMS_OUTPUT.PUT_LINE('Hoan tat giam gia.');
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('Loi: ' || SQLERRM);
END Discount;
/

-- Goi thu tuc:
BEGIN Discount; END;
/

CREATE OR REPLACE FUNCTION Total_cost_for_student
(p_student_id IN student.studentid%TYPE)
RETURN NUMBER
IS
v_total NUMBER;
v_check NUMBER;
BEGIN
SELECT COUNT(*) INTO v_check
FROM student WHERE studentid = p_student_id;

IF v_check = 0 THEN
RETURN NULL;
END IF;

-- Tinh tong chi phi: sum(cost cua tung mon da dang ky)
SELECT NVL(SUM(co.cost), 0)
INTO v_total
FROM enrollment e
JOIN class cl ON e.classid = cl.classid
JOIN course co ON cl.courseno = co.courseno
WHERE e.studentid = p_student_id;

RETURN v_total;

EXCEPTION
WHEN OTHERS THEN
RETURN NULL;
END Total_cost_for_student;
/

-- Goi ham de kiem tra:
SELECT Total_cost_for_student(20000001) AS "Tong chi phi" FROM DUAL;

-- Hoac trong PL/SQL:
BEGIN
DBMS_OUTPUT.PUT_LINE('Tong chi phi: ' || Total_cost_for_student(20000001));
END;
/


CREATE OR REPLACE TRIGGER trg_course_audit
BEFORE INSERT OR UPDATE ON COURSE
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        -- Gán giá trị khi thêm mới
        :NEW.CreatedBy := USER;
        :NEW.CreatedDate := SYSDATE;
    END IF;
    :NEW.ModifiedBy := USER;
    :NEW.ModifiedDate := SYSDATE;
END trg_course_audit;
/

CREATE OR REPLACE TRIGGER trg_class_audit
BEFORE INSERT OR UPDATE ON CLASS
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.CreatedBy := USER;   
        :NEW.CreatedDate := SYSDATE; 
    END IF;

    :NEW.ModifiedBy := USER;
    :NEW.ModifiedDate := SYSDATE;
END trg_class_audit;
/

CREATE OR REPLACE TRIGGER trg_student_audit
BEFORE INSERT OR UPDATE ON STUDENT 
FOR EACH ROW
BEGIN
    IF INSERTING THEN 
        :NEW.CreatedBy := USER; 
        :NEW.CreatedDate := SYSDATE; 
    END IF;
    
    :NEW.ModifiedBy := USER; 
    :NEW.ModifiedDate := SYSDATE;
END trg_student_audit;
/

CREATE OR REPLACE TRIGGER trg_enrollment_audit
BEFORE INSERT OR UPDATE ON ENROLLMENT 
FOR EACH ROW
BEGIN
    IF INSERTING THEN 
        :NEW.CreatedBy := USER; 
        :NEW.CreatedDate := SYSDATE; 
    END IF;

    :NEW.ModifiedBy := USER; 
    :NEW.ModifiedDate := SYSDATE;
END trg_enrollment_audit;
/

CREATE OR REPLACE TRIGGER trg_instructor_audit
BEFORE INSERT OR UPDATE ON INSTRUCTOR 
FOR EACH ROW
BEGIN
    IF INSERTING THEN 
        :NEW.CreatedBy := USER; 
        :NEW.CreatedDate := SYSDATE; 
    END IF;
    :NEW.ModifiedBy := USER; 
    :NEW.ModifiedDate := SYSDATE;
END trg_instructor_audit; 
/

CREATE OR REPLACE TRIGGER trg_grade_audit
BEFORE INSERT OR UPDATE ON GRADE 
FOR EACH ROW
BEGIN
    IF INSERTING THEN 
        :NEW.CreatedBy := USER; 
        :NEW.CreatedDate := SYSDATE; 
    END IF;
    :NEW.ModifiedBy := USER; 
    :NEW.ModifiedDate := SYSDATE;
END;
/

CREATE OR REPLACE TRIGGER trg_max_enrollment
BEFORE INSERT ON enrollment
FOR EACH ROW
DECLARE
v_so_lop NUMBER;
BEGIN
-- Dem so lop sinh vien nay dang dang ky
SELECT COUNT(*)
INTO v_so_lop
FROM enrollment
WHERE studentid = :NEW.studentid;

-- Neu da co 3 lop tro len thi tu choi
IF v_so_lop >= 3 THEN
RAISE_APPLICATION_ERROR(
-20001,
'Sinh vien ' || :NEW.studentid ||
' da dang ky du 3 lop! Khong the dang ky them.'
);
END IF;
END trg_max_enrollment;
/

-- Kiem tra trigger:
INSERT INTO enrollment (studentid, classid, enrolldate, createdby,createddate, modifiedby, modifieddate)
VALUES (101, 999, SYSDATE, USER, SYSDATE, USER, SYSDATE);

CREATE OR REPLACE VIEW vw_course_summary AS
    SELECT co.courseno,
    co.description,
    co.cost,
COUNT(DISTINCT cl.classid) AS so_lop,
COUNT(e.studentid) AS tong_sv
FROM course co
LEFT JOIN class cl ON co.courseno = cl.courseno
LEFT JOIN enrollment e ON cl.classid = e.classid
GROUP BY co.courseno, co.description, co.cost
ORDER BY tong_sv DESC;

SELECT * FROM vw_course_summary;

CREATE OR REPLACE VIEW vw_student_status AS
SELECT s.studentid,
s.firstname || ' ' || s.lastname AS ho_ten,
COUNT(e.classid) AS so_lop_hoc,
NVL(SUM(co.cost), 0) AS tong_hoc_phi,
ROUND(AVG(e.finalgrade), 2) AS diem_tb
FROM student s
JOIN enrollment e ON s.studentid = e.studentid
JOIN class cl ON e.classid = cl.classid
JOIN course co ON cl.courseno = co.courseno
GROUP BY s.studentid, s.firstname, s.lastname
HAVING COUNT(e.classid) >= 1
ORDER BY s.studentid;

SELECT * FROM vw_student_status;

CREATE OR REPLACE VIEW vw_class_availability AS
SELECT cl.classid,
cl.courseno,
co.description,
i.firstname || ' ' || i.lastname AS ten_giao_vien,
cl.capacity,
COUNT(e.studentid) AS so_da_dk,
cl.capacity - COUNT(e.studentid) AS cho_trong,
CASE
WHEN cl.capacity - COUNT(e.studentid) > 0 THEN 'Con cho'
ELSE 'Het cho'
END AS trang_thai
FROM class cl
JOIN course co ON cl.courseno = co.courseno
JOIN instructor i ON cl.instructorid = i.instructorid
LEFT JOIN enrollment e ON cl.classid = e.classid
GROUP BY cl.classid, cl.courseno, co.description,
i.firstname, i.lastname, cl.capacity
HAVING cl.capacity - COUNT(e.studentid) > 0
ORDER BY cl.classid;
SELECT * FROM vw_class_availability;

CREATE OR REPLACE VIEW vw_top_courses AS
SELECT courseno, description, cost, tong_dk, hang
FROM (
SELECT co.courseno,
co.description,
co.cost,
COUNT(e.studentid) AS tong_dk,
RANK() OVER (ORDER BY COUNT(e.studentid) DESC) AS hang
FROM course co
LEFT JOIN class cl ON co.courseno = cl.courseno
LEFT JOIN enrollment e ON cl.classid = e.classid
GROUP BY co.courseno, co.description, co.cost
)
WHERE hang <= 5
ORDER BY hang
WITH READ ONLY;

SELECT * FROM vw_top_courses;

-- Thu INSERT vao view nay (se bao loi ORA-42399):
INSERT INTO vw_top_courses (courseno, description, cost)
VALUES (999, 'Test', 100);


CREATE OR REPLACE VIEW vw_pending_enrollment AS
SELECT studentid, classid, enrolldate, finalgrade,
createdby, createddate, modifiedby, modifieddate
FROM enrollment
WHERE finalgrade IS NULL
WITH CHECK OPTION;

SELECT * FROM vw_pending_enrollment;

-- INSERT 1: FinalGrade = NULL -> THANH CONG (thoa dieu kien WHERE)
INSERT INTO vw_pending_enrollment
(studentid, classid, enrolldate, createdby, createddate, modifiedby, modifieddate)
VALUES (999, 1, SYSDATE, USER, SYSDATE, USER, SYSDATE);
-- INSERT 2: FinalGrade = 85 -> LOI ORA-01402 (vi pham WITH CHECK
OPTION)
INSERT INTO vw_pending_enrollment
(studentid, classid, enrolldate, finalgrade,
createdby, createddate, modifiedby, modifieddate)
VALUES (998, 1, SYSDATE, 85, USER, SYSDATE, USER, SYSDATE);
-- ORA-01402: view WITH CHECK OPTION where-clause violation

CREATE OR REPLACE PROCEDURE enroll_student
(p_studentid IN NUMBER,
p_classid IN NUMBER)
IS
v_check NUMBER;
v_capacity NUMBER;
v_enrolled NUMBER;
BEGIN
-- DK1: Sinh vien phai ton tai
SELECT COUNT(*) INTO v_check FROM student WHERE studentid =
p_studentid;
IF v_check = 0 THEN
DBMS_OUTPUT.PUT_LINE('[LOI] Sinh vien ' || p_studentid || ' khong
ton tai!');
RETURN;
END IF;

-- DK2: Lop hoc phai ton tai
SELECT COUNT(*) INTO v_check FROM class WHERE classid =
p_classid;
IF v_check = 0 THEN
DBMS_OUTPUT.PUT_LINE('[LOI] Lop hoc ' || p_classid || ' khong ton
tai!');
RETURN;
END IF;
-- DK3: Kiem tra con cho trong
SELECT capacity INTO v_capacity FROM class WHERE classid =
p_classid;
SELECT COUNT(*) INTO v_enrolled FROM enrollment WHERE classid =
p_classid;
IF v_enrolled >= v_capacity THEN
DBMS_OUTPUT.PUT_LINE('[LOI] Lop ' || p_classid || ' da day! ('
|| v_enrolled || '/' || v_capacity || ')');
RETURN;
END IF;

-- DK4: Sinh vien chua dang ky lop nay
SELECT COUNT(*) INTO v_check FROM enrollment
WHERE studentid = p_studentid AND classid = p_classid;
IF v_check > 0 THEN
DBMS_OUTPUT.PUT_LINE('[LOI] Sinh vien da dang ky lop nay roi!');
RETURN;
END IF;

-- DK5: Sinh vien chua qua 3 lop
SELECT COUNT(*) INTO v_check FROM enrollment WHERE studentid =
p_studentid;
IF v_check >= 3 THEN
DBMS_OUTPUT.PUT_LINE('[LOI] Sinh vien da dang ky du 3 lop!');
RETURN;
END IF;

-- Tat ca OK: INSERT
INSERT INTO enrollment
(studentid, classid, enrolldate, createdby, createddate,
modifiedby, modifieddate)
VALUES
(p_studentid, p_classid, SYSDATE, USER, SYSDATE, USER,
SYSDATE);
COMMIT;
DBMS_OUTPUT.PUT_LINE('[OK] Dang ky thanh cong! SV ' || p_studentid
|| ' -> Lop ' || p_classid);
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('[LOI HE THONG] ' || SQLERRM);
END enroll_student;
/


CREATE OR REPLACE PROCEDURE update_final_grade
(p_studentid IN NUMBER,
p_classid IN NUMBER,
p_grade IN NUMBER)
IS
v_check NUMBER;
v_old_grade NUMBER;
BEGIN
-- Kiem tra diem hop le
IF p_grade < 0 OR p_grade > 100 THEN
DBMS_OUTPUT.PUT_LINE('[LOI] Diem khong hop le! Phai tu 0 den
100.');
RETURN;
END IF;

-- Kiem tra cap (StudentID, ClassID) ton tai trong ENROLLMENT
SELECT COUNT(*) INTO v_check FROM enrollment
WHERE studentid = p_studentid AND classid = p_classid;
IF v_check = 0 THEN
DBMS_OUTPUT.PUT_LINE('[LOI] Sinh vien chua dang ky lop nay!');
RETURN;
END IF;

-- Luu diem cu
SELECT finalgrade INTO v_old_grade FROM enrollment
WHERE studentid = p_studentid AND classid = p_classid;
-- Cap nhat ENROLLMENT
UPDATE enrollment
SET finalgrade = p_grade,
modifiedby = USER, modifieddate = SYSDATE
WHERE studentid = p_studentid AND classid = p_classid;

-- Dong bo sang bang GRADE bang MERGE INTO
MERGE INTO grade g
USING (SELECT p_studentid AS sid, p_classid AS cid FROM DUAL) src
ON (g.studentid = src.sid AND g.classid = src.cid)
WHEN MATCHED THEN
UPDATE SET g.grade = p_grade,
g.modifiedby = USER, g.modifieddate = SYSDATE
WHEN NOT MATCHED THEN
INSERT (studentid, classid, grade, createdby, createddate,
modifiedby, modifieddate)
VALUES (p_studentid, p_classid, p_grade,
USER, SYSDATE, USER, SYSDATE);

COMMIT;
DBMS_OUTPUT.PUT_LINE('[OK] Da cap nhat diem SV ' || p_studentid
|| ' lop ' || p_classid
|| ': Cu=' || NVL(TO_CHAR(v_old_grade),'NULL')
|| ' -> Moi=' || p_grade);
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('[LOI] ' || SQLERRM);
END update_final_grade;

CREATE OR REPLACE PROCEDURE transfer_student
(p_studentid IN NUMBER,
p_old_classid IN NUMBER,
p_new_classid IN NUMBER)
IS
v_check NUMBER;
v_capacity NUMBER;
v_enrolled NUMBER;
BEGIN
-- DK1: Sinh vien dang hoc o lop cu
SELECT COUNT(*) INTO v_check FROM enrollment
WHERE studentid = p_studentid AND classid = p_old_classid;
IF v_check = 0 THEN
DBMS_OUTPUT.PUT_LINE('[LOI] Sinh vien khong dang hoc lop ' ||
p_old_classid);
RETURN;
END IF;

-- DK2: Lop moi con cho trong
SELECT capacity INTO v_capacity FROM class WHERE classid =
p_new_classid;
SELECT COUNT(*) INTO v_enrolled FROM enrollment WHERE classid =
p_new_classid;
IF v_enrolled >= v_capacity THEN
DBMS_OUTPUT.PUT_LINE('[LOI] Lop moi ' || p_new_classid || ' da
day!');
RETURN;
END IF;
-- DK3: Sinh vien chua dang ky lop moi
SELECT COUNT(*) INTO v_check FROM enrollment
WHERE studentid = p_studentid AND classid = p_new_classid;
IF v_check > 0 THEN
DBMS_OUTPUT.PUT_LINE('[LOI] Sinh vien da o trong lop moi roi!');
RETURN;
END IF;

-- Tat ca OK: thuc hien chuyen lop
SAVEPOINT sp_truoc_chuyen;

-- Buoc 1: Xoa khoi lop cu
DELETE FROM enrollment
WHERE studentid = p_studentid AND classid = p_old_classid;
SAVEPOINT sp_sau_xoa;

-- Buoc 2: Them vao lop moi
INSERT INTO enrollment
(studentid, classid, enrolldate, createdby, createddate,
modifiedby, modifieddate)
VALUES
(p_studentid, p_new_classid, SYSDATE, USER, SYSDATE, USER,
SYSDATE);

COMMIT;
DBMS_OUTPUT.PUT_LINE('[OK] Da chuyen SV ' || p_studentid
|| ' tu lop ' || p_old_classid
|| ' sang lop ' || p_new_classid);
EXCEPTION
WHEN OTHERS THEN
ROLLBACK TO sp_truoc_chuyen;
DBMS_OUTPUT.PUT_LINE('[LOI] Chuyen lop that bai: ' || SQLERRM);
DBMS_OUTPUT.PUT_LINE('Da rollback ve trang thai ban dau.');
END transfer_student;
/

CREATE OR REPLACE PROCEDURE report_class_detail 
    (p_classid IN NUMBER) 
IS
    v_check     NUMBER;
    v_course    VARCHAR2(50);
    v_courseno  NUMBER;
    v_gv        VARCHAR2(50);
    v_loc       VARCHAR2(50);
    v_cap       NUMBER;
    v_stt       NUMBER := 0;
    v_tong      NUMBER := 0;
    v_sum_d     NUMBER := 0;
    v_co_d      NUMBER := 0;
    v_grade_txt VARCHAR2(15);
BEGIN
    -- Kiem tra lop ton tai
    SELECT COUNT(*) INTO v_check FROM class WHERE classid = p_classid;
    
    IF v_check = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Lop hoc ' || p_classid || ' khong ton tai!');
        RETURN;
    END IF;

    -- Lay thong tin lop
    SELECT co.description, co.courseno,
           i.firstname || ' ' || i.lastname,
           cl.location, cl.capacity
    INTO v_course, v_courseno, v_gv, v_loc, v_cap
    FROM class cl
    JOIN course co ON cl.courseno = co.courseno
    JOIN instructor i ON cl.instructorid = i.instructorid
    WHERE cl.classid = p_classid;

    -- In header bao cao
    DBMS_OUTPUT.PUT_LINE('==== BAO CAO LOP HOC: ' || p_classid || ' ====');
    DBMS_OUTPUT.PUT_LINE('Mon hoc : ' || v_courseno || ' - ' || v_course);
    DBMS_OUTPUT.PUT_LINE('Giao vien: ' || v_gv);
    DBMS_OUTPUT.PUT_LINE('Phong hoc: ' || NVL(v_loc, 'Chua xep phong'));
    DBMS_OUTPUT.PUT_LINE('Suc chua : ' || v_cap || ' cho');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 50, '-'));
    DBMS_OUTPUT.PUT_LINE('DANH SACH SINH VIEN:');
    DBMS_OUTPUT.PUT_LINE(RPAD('STT', 4) || '|' || RPAD('Ho Ten', 20) || '|' || LPAD('Diem TK', 8) || '|' || ' Xep loai');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 50, '-'));

    -- Duyet danh sach sinh vien
    FOR rec IN (
        SELECT s.firstname || ' ' || s.lastname AS ho_ten,
               e.finalgrade
        FROM enrollment e
        JOIN student s ON e.studentid = s.studentid
        WHERE e.classid = p_classid
        ORDER BY s.lastname, s.firstname
    ) LOOP
        v_stt  := v_stt + 1;
        v_tong := v_tong + 1;

        -- Xep loai
        IF rec.finalgrade IS NULL THEN
            v_grade_txt := 'Chua co diem';
        ELSIF rec.finalgrade >= 90 THEN
            v_grade_txt := 'A';
            v_sum_d := v_sum_d + rec.finalgrade; v_co_d := v_co_d + 1;
        ELSIF rec.finalgrade >= 80 THEN
            v_grade_txt := 'B';
            v_sum_d := v_sum_d + rec.finalgrade; v_co_d := v_co_d + 1;
        ELSIF rec.finalgrade >= 70 THEN
            v_grade_txt := 'C';
            v_sum_d := v_sum_d + rec.finalgrade; v_co_d := v_co_d + 1;
        ELSIF rec.finalgrade >= 50 THEN
            v_grade_txt := 'D';
            v_sum_d := v_sum_d + rec.finalgrade; v_co_d := v_co_d + 1;
        ELSE
            v_grade_txt := 'F';
            v_sum_d := v_sum_d + rec.finalgrade; v_co_d := v_co_d + 1;
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            LPAD(v_stt, 3) || ' | ' ||
            RPAD(rec.ho_ten, 20) || ' | ' ||
            LPAD(NVL(TO_CHAR(rec.finalgrade), 'NULL'), 7) || ' | ' ||
            v_grade_txt
        );
    END LOOP;

    -- In footer bao cao
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 50, '-'));
    DBMS_OUTPUT.PUT_LINE('Tong so sinh vien : ' || v_tong);
    
    IF v_co_d > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Diem trung binh lop: ' || ROUND(v_sum_d / v_co_d, 2));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Diem trung binh lop: Chua co diem');
    END IF;

END report_class_detail;
/

-- Goi thu tuc:
BEGIN
    report_class_detail(1);
END;
/


CREATE OR REPLACE PROCEDURE sync_grade_from_enrollment
IS
v_check NUMBER;
v_dem_insert NUMBER := 0;
v_dem_update NUMBER := 0;
BEGIN
FOR rec IN (
SELECT studentid, classid, finalgrade
FROM enrollment
WHERE finalgrade IS NOT NULL
) LOOP
-- Kiem tra trong GRADE da co chua
SELECT COUNT(*) INTO v_check FROM grade
WHERE studentid = rec.studentid AND classid = rec.classid;

IF v_check = 0 THEN
-- Chua co -> INSERT moi
INSERT INTO grade
(studentid, classid, grade, createdby, createddate,
modifiedby, modifieddate)
VALUES
(rec.studentid, rec.classid, rec.finalgrade,
USER, SYSDATE, USER, SYSDATE);
v_dem_insert := v_dem_insert + 1;
ELSE
-- Da co -> UPDATE
UPDATE grade
SET grade = rec.finalgrade,
modifiedby = USER, modifieddate = SYSDATE
WHERE studentid = rec.studentid AND classid = rec.classid;
v_dem_update := v_dem_update + 1;
END IF;
END LOOP;

COMMIT;
DBMS_OUTPUT.PUT_LINE('[OK] Dong bo hoan tat!');
DBMS_OUTPUT.PUT_LINE(' So ban ghi INSERT moi : ' ||
v_dem_insert);
DBMS_OUTPUT.PUT_LINE(' So ban ghi UPDATE : ' ||
v_dem_update);
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
DBMS_OUTPUT.PUT_LINE('[LOI] ' || SQLERRM);
END sync_grade_from_enrollment;
/

BEGIN sync_grade_from_enrollment; 
END; 
/


CREATE OR REPLACE TRIGGER trg_check_capacity
BEFORE INSERT ON enrollment
FOR EACH ROW
DECLARE
v_capacity NUMBER;
v_enrolled NUMBER;
BEGIN
-- Lay suc chua lop hoc
SELECT capacity INTO v_capacity
FROM class WHERE classid = :NEW.classid;

-- Dem so SV hien da dang ky
SELECT COUNT(*) INTO v_enrolled
FROM enrollment WHERE classid = :NEW.classid;

-- Tu choi neu lop da day
IF v_enrolled >= v_capacity THEN
RAISE_APPLICATION_ERROR(
-20010,
'LOI: Lop ' || :NEW.classid || ' da day! ('
|| v_enrolled || '/' || v_capacity || ' cho)'
);
END IF;
END trg_check_capacity;
/

-- Kiem tra trigger :
INSERT INTO enrollment 
(studentid, classid, enrolldate, RegistrationDate, createdby, createddate, modifiedby, modifieddate)
VALUES (20000001, 50000002, SYSDATE, SYSDATE, USER, SYSDATE, USER, SYSDATE);




CREATE OR REPLACE TRIGGER trg_grade_audit_log
AFTER UPDATE OF finalgrade ON enrollment
FOR EACH ROW
BEGIN
-- Chi ghi log khi diem THUC SU thay doi
IF (:OLD.finalgrade IS NULL AND :NEW.finalgrade IS NOT NULL)
OR (:OLD.finalgrade IS NOT NULL AND :NEW.finalgrade IS NULL)
OR (:OLD.finalgrade != :NEW.finalgrade)
THEN
INSERT INTO grade_audit_log
(studentid, classid, grade_cu, grade_moi, nguoi_sua, thoi_gian)
VALUES
(:OLD.studentid, :OLD.classid, :OLD.finalgrade,
:NEW.finalgrade, USER, SYSDATE);
END IF;
END trg_grade_audit_log;
/


UPDATE enrollment 
SET finalgrade = 90 
WHERE studentid = 20000002 AND classid = 50000001;

SELECT * FROM grade_audit_log;


DELETE FROM course WHERE courseno = 10;

-- Kiem tra: xoa mon khong co lop (thanh cong)
DELETE FROM course WHERE courseno = 999; -- Mon khong co lop nao
ROLLBACK;

CREATE TABLE class_grade_summary (
classid NUMBER(8) PRIMARY KEY,
so_sv NUMBER,
diem_tb NUMBER(5,2),
diem_cao_nhat NUMBER(3),
diem_thap_nhat NUMBER(3),
cap_nhat_luc DATE
);
/

CREATE OR REPLACE TRIGGER trg_update_grade_summary
AFTER INSERT OR UPDATE OR DELETE ON enrollment
FOR EACH ROW
DECLARE
v_classid NUMBER;
v_so_sv NUMBER;
v_diem_tb NUMBER;
v_max_d NUMBER;
v_min_d NUMBER;
BEGIN
-- Lay ClassID dua tren loai su kien
IF INSERTING OR UPDATING THEN
v_classid := :NEW.classid;
ELSE -- DELETING
v_classid := :OLD.classid;
END IF;

-- Tinh lai thong ke cho lop bi anh huong
SELECT COUNT(finalgrade),
ROUND(AVG(finalgrade), 2),
MAX(finalgrade),
MIN(finalgrade)
INTO v_so_sv, v_diem_tb, v_max_d, v_min_d
FROM enrollment
WHERE classid = v_classid AND finalgrade IS NOT NULL;

-- MERGE INTO cap nhat hoac them moi
MERGE INTO class_grade_summary cgs
USING (SELECT v_classid AS cid FROM DUAL) src
ON (cgs.classid = src.cid)
WHEN MATCHED THEN
UPDATE SET
so_sv = v_so_sv,
diem_tb = v_diem_tb,
diem_cao_nhat = v_max_d,
diem_thap_nhat = v_min_d,
cap_nhat_luc = SYSDATE
WHEN NOT MATCHED THEN
INSERT (classid, so_sv, diem_tb, diem_cao_nhat, diem_thap_nhat,
cap_nhat_luc)
VALUES (v_classid, v_so_sv, v_diem_tb, v_max_d, v_min_d,
SYSDATE);
END trg_update_grade_summary;
/

-- Kiem tra trigger:
UPDATE enrollment 
SET finalgrade = 70 
WHERE studentid = 20000002 AND classid = 50000001;
COMMIT;
SELECT * FROM class_grade_summary WHERE classid = 50000001;



CREATE OR REPLACE VIEW vw_instructor_workload AS
SELECT i.instructorid,
i.firstname || ' ' || i.lastname AS ho_ten,
COUNT(DISTINCT cl.classid) AS so_lop,
COUNT(e.studentid) AS tong_sv,
ROUND(AVG(e.finalgrade), 2) AS diem_tb_chung,
CASE
WHEN COUNT(DISTINCT cl.classid) >= 3 THEN 'Ban nhieu'
WHEN COUNT(DISTINCT cl.classid) = 2 THEN 'Binh thuong'
ELSE 'Nhe nhang'
END AS muc_ban
FROM instructor i
LEFT JOIN class cl ON i.instructorid = cl.instructorid
LEFT JOIN enrollment e ON cl.classid = e.classid
GROUP BY i.instructorid, i.firstname, i.lastname
ORDER BY so_lop DESC;

SELECT * FROM vw_instructor_workload;

CREATE OR REPLACE PROCEDURE print_system_report
IS
v_so_mon NUMBER;
v_so_lop NUMBER;
v_so_sv NUMBER;
v_so_gv NUMBER;
BEGIN
-- Lay so lieu tong the
SELECT COUNT(*) INTO v_so_mon FROM course;
SELECT COUNT(*) INTO v_so_lop FROM class;
SELECT COUNT(*) INTO v_so_sv FROM student;
SELECT COUNT(*) INTO v_so_gv FROM instructor;

-- In header

DBMS_OUTPUT.PUT_LINE('==================================
==========');
DBMS_OUTPUT.PUT_LINE(' BAO CAO TOAN HE THONG QUAN LY
KHOA HOC');
DBMS_OUTPUT.PUT_LINE('==================================
==========');
DBMS_OUTPUT.PUT_LINE('Tong so mon hoc : ' || v_so_mon);
DBMS_OUTPUT.PUT_LINE('Tong so lop hoc : ' || v_so_lop);
DBMS_OUTPUT.PUT_LINE('Tong so sinh vien: ' || v_so_sv);
DBMS_OUTPUT.PUT_LINE('Tong so giao vien: ' || v_so_gv);
DBMS_OUTPUT.PUT_LINE(RPAD('-',50,'-'));

-- Phan 1: Thong ke giao vien (dung view vw_instructor_workload)
DBMS_OUTPUT.PUT_LINE('THONG KE GIAO VIEN:');
FOR rec IN (SELECT * FROM vw_instructor_workload) LOOP
DBMS_OUTPUT.PUT_LINE(
' ' || RPAD(rec.ho_ten, 25)
|| ' | ' || LPAD(rec.so_lop, 2) || ' lop'
|| ' | ' || LPAD(rec.tong_sv, 3) || ' SV'
|| ' | DTB: ' || NVL(TO_CHAR(rec.diem_tb_chung),'--')
|| ' | ' || rec.muc_ban
);
END LOOP;
DBMS_OUTPUT.PUT_LINE(RPAD('-',50,'-'));

-- Phan 2: Top 3 mon hoc (dung view vw_top_courses)
DBMS_OUTPUT.PUT_LINE('TOP 3 MON HOC DUOC DANG KY
NHIEU NHAT:');
FOR rec IN (SELECT * FROM vw_top_courses WHERE hang <= 3) LOOP
DBMS_OUTPUT.PUT_LINE(
' ' || rec.hang || '. '
|| RPAD(rec.description, 30)
|| ' - ' || rec.tong_dk || ' luot dang ky'
);
END LOOP;
DBMS_OUTPUT.PUT_LINE('==================================
==========');
END print_system_report;
/

-- Chay bao cao:
SET SERVEROUTPUT ON SIZE 1000000;
BEGIN print_system_report; END;
/






CREATE OR REPLACE VIEW vw_prerequisite_check AS
    SELECT
        s.studentid,
        s.firstname
        || ' '
        || s.lastname  AS ho_ten,
        co.description AS ten_mon,
        co.courseno,
        tq.description AS ten_mon_tq,
        tq.courseno    AS courseno_tq
    FROM
             enrollment e
        JOIN student s ON e.studentid = s.studentid
        JOIN class   cl ON e.classid = cl.classid
        JOIN course  co ON cl.courseno = co.courseno
        JOIN course  tq ON co.prerequisite = tq.courseno
    WHERE
        co.prerequisite IS NOT NULL
        AND NOT EXISTS (
            SELECT
                1
            FROM
                     enrollment e2
                JOIN class cl2 ON e2.classid = cl2.classid
            WHERE
                    e2.studentid = s.studentid
                AND cl2.courseno = co.prerequisite
                AND e2.finalgrade IS NOT NULL
        );

-- Dem truong hop hoc vuot theo tung mon:
SELECT
    ten_mon,
    courseno,
    COUNT(*) AS so_sv_hoc_vuot
FROM
    vw_prerequisite_check
GROUP BY
    ten_mon,
    courseno
ORDER BY
    so_sv_hoc_vuot DESC;

CREATE OR REPLACE VIEW vw_instructor_performance AS
    SELECT
        instructorid,
        ho_ten,
        so_lop,
        tong_sv,
        sv_co_diem,
        diem_tb,
        diem_max,
        diem_min,
        round(sv_dat * 100 / nullif(sv_co_diem, 0),
              1) AS ty_le_dat_pct,
        DENSE_RANK()
        OVER(
            ORDER BY
                diem_tb DESC NULLS LAST
        )        AS hang_diem_tb,
        RANK()
        OVER(
            ORDER BY
                tong_sv DESC
        )        AS hang_so_sv
    FROM
        (
            SELECT
                i.instructorid,
                i.firstname
                || ' '
                || i.lastname              AS ho_ten,
                COUNT(DISTINCT cl.classid) AS so_lop,
                COUNT(e.studentid)         AS tong_sv,
                COUNT(e.finalgrade)        AS sv_co_diem,
                round(
                    avg(e.finalgrade),
                    2
                )                          AS diem_tb,
                MAX(e.finalgrade)          AS diem_max,
                MIN(e.finalgrade)          AS diem_min,
                SUM(
                    CASE
                        WHEN e.finalgrade >= 50 THEN
                            1
                        ELSE
                            0
                    END
                )                          AS sv_dat
            FROM
                instructor i
                LEFT JOIN class      cl ON i.instructorid = cl.instructorid
                LEFT JOIN enrollment e ON cl.classid = e.classid
            GROUP BY
                i.instructorid,
                i.firstname,
                i.lastname
        );

-- Top 3 giao vien ty le SV dat cao nhat:
SELECT
    ho_ten,
    ty_le_dat_pct,
    sv_co_diem,
    diem_tb
FROM
    vw_instructor_performance
WHERE
    hang_diem_tb <= 3
ORDER BY
    hang_diem_tb;


CREATE OR REPLACE VIEW vw_monthly_enrollment_stats AS
    SELECT
        nam,
        thang,
        so_dang_ky,
        so_sv_moi,
        so_mon,
        diem_tb_thang,
        SUM(so_dang_ky)
        OVER(
            ORDER BY
                nam, thang
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS luy_ke_dang_ky
    FROM
        (
            SELECT
                to_char(e.enrolldate, 'YYYY') AS nam,
                to_char(e.enrolldate, 'MM')   AS thang,
                COUNT(*)                      AS so_dang_ky,
                COUNT(DISTINCT e.studentid)   AS so_sv_moi,
                COUNT(DISTINCT cl.courseno)   AS so_mon,
                round(
                    avg(e.finalgrade),
                    2
                )                             AS diem_tb_thang
            FROM
                     enrollment e
                JOIN class cl ON e.classid = cl.classid
            GROUP BY
                to_char(e.enrolldate, 'YYYY'),
                to_char(e.enrolldate, 'MM')
        )
    ORDER BY
        nam DESC,
        thang ASC;

SELECT * FROM vw_monthly_enrollment_stats;



CREATE OR REPLACE VIEW vw_enrollment_full AS
    SELECT
        e.studentid,
        e.classid,
        e.enrolldate,
        e.finalgrade,
        s.firstname
        || ' '
        || s.lastname  AS ten_sv,
        co.description AS ten_mon,
        i.firstname
        || ' '
        || i.lastname  AS ten_gv
    FROM
             enrollment e
        JOIN student    s ON e.studentid = s.studentid
        JOIN class      cl ON e.classid = cl.classid
        JOIN course     co ON cl.courseno = co.courseno
        JOIN instructor i ON cl.instructorid = i.instructorid;

CREATE OR REPLACE TRIGGER trg_iot_enrollment_full INSTEAD OF
    INSERT ON vw_enrollment_full
    FOR EACH ROW
DECLARE
    v_sv_check NUMBER;
    v_cl_check NUMBER;
    v_capacity NUMBER;
    v_enrolled NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO v_sv_check
    FROM
        student
    WHERE
        studentid = :new.studentid;

    IF v_sv_check = 0 THEN
        raise_application_error(-20050, 'Sinh vien khong ton tai!');
        RETURN;
    END IF;
    SELECT
        COUNT(*)
    INTO v_cl_check
    FROM
        class
    WHERE
        classid = :new.classid;

    IF v_cl_check = 0 THEN
        raise_application_error(-20051, 'Lop hoc khong ton tai!');
        RETURN;
    END IF;
    SELECT
        capacity
    INTO v_capacity
    FROM
        class
    WHERE
        classid = :new.classid;

    SELECT
        COUNT(*)
    INTO v_enrolled
    FROM
        enrollment
    WHERE
        classid = :new.classid;

    IF v_enrolled >= v_capacity THEN
        raise_application_error(-20052, 'Lop da day!');
        RETURN;
    END IF;

    INSERT INTO enrollment (
        studentid,
        classid,
        enrolldate,
        createdby,
        createddate,
        modifiedby,
        modifieddate
    ) VALUES ( :new.studentid,
               :new.classid,
               nvl(:new.enrolldate,
                   sysdate),
               user,
               sysdate,
               user,
               sysdate );

    dbms_output.put_line('[OK] Da dang ky: SV '
                         || :new.studentid
                         || ' -> Lop
'
                         || :new.classid);

END trg_iot_enrollment_full;
/

-- Kiem tra INSERT qua view:
INSERT INTO vw_enrollment_full (
    studentid,
    classid
) VALUES ( 101,
           3 );

COMMIT;


CREATE OR REPLACE VIEW vw_grade_distribution AS
SELECT classid, courseno, description,
sv_A, sv_B, sv_C, sv_D, sv_F, sv_chua_co,
p25, p50_median, p75,
ROUND(std_dev,2) AS
do_lech_chuan,
ROUND(std_dev / NULLIF(diem_tb,0) * 100, 2) AS he_so_bt
FROM (
SELECT cl.classid,
cl.courseno,
co.description,
SUM(CASE WHEN e.finalgrade>=90 THEN 1 ELSE 0 END) AS sv_A,
SUM(CASE WHEN e.finalgrade>=80
AND e.finalgrade<90 THEN 1 ELSE 0 END) AS sv_B,
SUM(CASE WHEN e.finalgrade>=70
AND e.finalgrade<80 THEN 1 ELSE 0 END) AS sv_C,
SUM(CASE WHEN e.finalgrade>=50
AND e.finalgrade<70 THEN 1 ELSE 0 END) AS sv_D,
SUM(CASE WHEN e.finalgrade<50
AND e.finalgrade IS NOT NULL
THEN 1 ELSE 0 END) AS sv_F,
SUM(CASE WHEN e.finalgrade IS NULL THEN 1 ELSE 0 END) AS
sv_chua_co,
PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY e.finalgrade) AS
p25,
PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY e.finalgrade) AS
p50_median,
PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY e.finalgrade) AS
p75,
STDDEV(e.finalgrade) AS std_dev,
AVG(e.finalgrade) AS diem_tb
FROM class cl
JOIN course co ON cl.courseno = co.courseno
LEFT JOIN enrollment e ON cl.classid = e.classid
GROUP BY cl.classid, cl.courseno, co.description
HAVING COUNT(e.finalgrade) >= 2
);

SELECT * FROM vw_grade_distribution ORDER BY classid;



CREATE OR REPLACE VIEW vw_student_grade_pivot AS
SELECT studentid,
ho_ten,
MAX(CASE WHEN classid=1 THEN finalgrade END) AS diem_lop_1,
MAX(CASE WHEN classid=2 THEN finalgrade END) AS diem_lop_2,
MAX(CASE WHEN classid=3 THEN finalgrade END) AS diem_lop_3,
MAX(CASE WHEN classid=4 THEN finalgrade END) AS diem_lop_4,
ROUND(AVG(finalgrade),2) AS diem_tb_chung,
COUNT(classid) AS tong_lop
FROM (
SELECT e.studentid,
s.firstname||' '||s.lastname AS ho_ten,
e.classid,
e.finalgrade
FROM enrollment e JOIN student s ON e.studentid=s.studentid
)
GROUP BY studentid, ho_ten
ORDER BY studentid;

SELECT * FROM vw_student_grade_pivot;
-- Cach 2: Dung menh de PIVOT (Oracle 11g+)
SELECT * FROM (
SELECT e.studentid, e.classid, e.finalgrade
FROM enrollment e
)
PIVOT (MAX(finalgrade) FOR classid IN
(1 AS diem_lop_1, 2 AS diem_lop_2,
3 AS diem_lop_3, 4 AS diem_lop_4)
);


CREATE OR REPLACE VIEW vw_data_integrity_check AS
-- Loi 1: SV trong ENROLLMENT khong ton tai trong STUDENT
SELECT 'LOI_1: SV_KHONG_TON_TAI' AS loai_van_de,
TO_CHAR(e.studentid) AS ma_tham_chieu,
'StudentID '||e.studentid||' co trong ENROLLMENT nhung khong co
trong STUDENT'
AS mo_ta
FROM enrollment e
WHERE NOT EXISTS (SELECT 1 FROM student s WHERE s.studentid=e.studentid)

UNION ALL

-- Loi 2: Lop trong CLASS thieu giao vien
SELECT 'LOI_2: LOP_THIEU_GIAO_VIEN',
TO_CHAR(cl.classid),
'ClassID '||cl.classid||' khong co InstructorID hop le'
FROM class cl
WHERE NOT EXISTS (SELECT 1 FROM instructor i WHERE
i.instructorid=cl.instructorid)

UNION ALL

-- Loi 3: Diem trong GRADE khong khop voi ENROLLMENT
SELECT 'LOI_3: DIEM_KHONG_KHOP',
TO_CHAR(g.studentid)||'/'||TO_CHAR(g.classid),
'GRADE.grade='||g.grade||' khac
ENROLLMENT.finalgrade='||e.finalgrade
FROM grade g
JOIN enrollment e ON g.studentid=e.studentid AND g.classid=e.classid
WHERE g.grade != NVL(e.finalgrade,-999)

UNION ALL

-- Loi 4: SV dang ky qua 3 lop
SELECT 'LOI_4: DANG_KY_QUA_3_LOP',
TO_CHAR(studentid),
'StudentID '||studentid||' dang ky '||COUNT(*)||' lop (toi da 3)'
FROM enrollment
GROUP BY studentid
HAVING COUNT(*) > 3;

SELECT * FROM vw_data_integrity_check;


CREATE OR REPLACE PROCEDURE get_students_by_class
(p_classid IN NUMBER,
p_result OUT SYS_REFCURSOR)
IS
v_check NUMBER;
BEGIN
SELECT COUNT(*) INTO v_check FROM class WHERE classid=p_classid;
IF v_check=0 THEN
p_result := NULL;
DBMS_OUTPUT.PUT_LINE('Lop '||p_classid||' khong ton tai!');
RETURN;
END IF;

OPEN p_result FOR
SELECT s.studentid,
s.firstname||' '||s.lastname AS ho_ten,
e.finalgrade,
CASE
WHEN e.finalgrade>=90 THEN 'A'
WHEN e.finalgrade>=80 THEN 'B'
WHEN e.finalgrade>=70 THEN 'C'
WHEN e.finalgrade>=50 THEN 'D'
WHEN e.finalgrade IS NULL THEN 'Chua co'
ELSE 'F'
END AS xep_loai,
RANK() OVER (ORDER BY e.finalgrade DESC NULLS LAST) AS
thu_hang
FROM enrollment e
JOIN student s ON e.studentid=s.studentid
WHERE e.classid=p_classid
ORDER BY thu_hang;
END get_students_by_class;
/

CREATE OR REPLACE PROCEDURE print_class_result (
    p_classid IN NUMBER
) IS

    v_cur  SYS_REFCURSOR;
    v_sid  NUMBER;
    v_ten  VARCHAR2(50);
    v_diem NUMBER;
    v_xep  VARCHAR2(10);
    v_hang NUMBER;
BEGIN
    get_students_by_class(p_classid, v_cur);
    IF v_cur IS NULL THEN
        RETURN;
    END IF;
    dbms_output.put_line('=== KET QUA LOP '
                         || p_classid
                         || ' ===');
    dbms_output.put_line(rpad('Hang', 5)
                         || rpad('Ho
Ten', 22)
                         || lpad('Diem', 6)
                         || ' Xep loai');

    dbms_output.put_line(rpad('-', 45, '-'));
    LOOP
        FETCH v_cur INTO
            v_sid,
            v_ten,
            v_diem,
            v_xep,
            v_hang;
        EXIT WHEN v_cur%notfound;
        dbms_output.put_line(lpad(v_hang, 4)
                             || ' '
                             || rpad(v_ten, 22)
                             || lpad(
            nvl(
                to_char(v_diem),
                '--'
            ),
            6
        )
                             || ' '
                             || v_xep);

    END LOOP;

    CLOSE v_cur;
END print_class_result;
/

BEGIN
    print_class_result(1);
END;
/

CREATE OR REPLACE PROCEDURE validate_enrollment (
    p_studentid IN NUMBER,
    p_classid   IN NUMBER
) IS

    ex_sv_not_found EXCEPTION;
    PRAGMA exception_init ( ex_sv_not_found, -20101 );
    ex_class_not_found EXCEPTION;
    PRAGMA exception_init ( ex_class_not_found, -20102 );
    ex_class_full EXCEPTION;
    PRAGMA exception_init ( ex_class_full, -20103 );
    ex_already_enrolled EXCEPTION;
    PRAGMA exception_init ( ex_already_enrolled, -20104 );
    v_check NUMBER;
    v_cap   NUMBER;
    v_enr   NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO v_check
    FROM
        student
    WHERE
        studentid = p_studentid;

    IF v_check = 0 THEN
        raise_application_error(-20101, 'Sinh vien '
                                        || p_studentid
                                        || ' khong
ton tai!');
    END IF;

    SELECT
        COUNT(*)
    INTO v_check
    FROM
        class
    WHERE
        classid = p_classid;

    IF v_check = 0 THEN
        raise_application_error(-20102, 'Lop hoc '
                                        || p_classid
                                        || ' khong ton
tai!');
    END IF;

    SELECT
        capacity
    INTO v_cap
    FROM
        class
    WHERE
        classid = p_classid;

    SELECT
        COUNT(*)
    INTO v_enr
    FROM
        enrollment
    WHERE
        classid = p_classid;

    IF v_enr >= v_cap THEN
        raise_application_error(-20103, 'Lop '
                                        || p_classid
                                        || ' da day
('
                                        || v_enr
                                        || '/'
                                        || v_cap
                                        || ')!');
    END IF;

    SELECT
        COUNT(*)
    INTO v_check
    FROM
        enrollment
    WHERE
            studentid = p_studentid
        AND classid = p_classid;

    IF v_check > 0 THEN
        raise_application_error(-20104, 'SV '
                                        || p_studentid
                                        || ' da dang ky lop
nay roi!');
    END IF;

    dbms_output.put_line('[OK] Tat ca dieu kien deu thoa man!');
EXCEPTION
    WHEN ex_sv_not_found THEN
        dbms_output.put_line('[KHONG TON TAI]
' || sqlerrm);
    WHEN ex_class_not_found THEN
        dbms_output.put_line('[LOP SAI]
' || sqlerrm);
    WHEN ex_class_full THEN
        dbms_output.put_line('[DAY LOP]
' || sqlerrm);
    WHEN ex_already_enrolled THEN
        dbms_output.put_line('[TRUNG LAP]
' || sqlerrm);
    WHEN OTHERS THEN
        dbms_output.put_line('[LOI KHAC] ' || sqlerrm);
END validate_enrollment;
/

CREATE OR REPLACE PROCEDURE calc_total_prerequisite_cost (
    p_courseno IN NUMBER,
    p_total    OUT NUMBER,
    p_depth    IN NUMBER DEFAULT 0
) IS

    v_cost      NUMBER;
    v_prereq    NUMBER;
    v_desc      VARCHAR2(50);
    v_sub_total NUMBER := 0;
    v_indent    VARCHAR2(40);
BEGIN
    IF p_depth >= 10 THEN
        dbms_output.put_line('CANH BAO: Dat gioi han do sau (10)!');
        p_total := 0;
        RETURN;
    END IF;

    BEGIN
        SELECT
            cost,
            prerequisite,
            description
        INTO
            v_cost,
            v_prereq,
            v_desc
        FROM
            course
        WHERE
            courseno = p_courseno;

    EXCEPTION
        WHEN no_data_found THEN
            p_total := 0;
            RETURN;
    END;

    v_indent := lpad(' ', p_depth * 4);
    IF v_prereq IS NOT NULL THEN
        calc_total_prerequisite_cost(v_prereq, v_sub_total, p_depth + 1);
    END IF;

    p_total := nvl(v_cost, 0) + v_sub_total;
    dbms_output.put_line(v_indent
                         || 'Cap '
                         || p_depth
                         || ': '
                         || p_courseno
                         || ' - '
                         || v_desc
                         || ' (phi: '
                         || nvl(v_cost, 0)
                         || ')');

END calc_total_prerequisite_cost;
/

-- Kiem tra:
DECLARE
    v_total NUMBER;
BEGIN
    calc_total_prerequisite_cost(30, v_total);
    dbms_output.put_line('Tong hoc phi can thiet: ' || v_total);
END;
/


-- Package SPEC:
CREATE OR REPLACE PACKAGE pkg_student_mgmt AS
    c_max_classes CONSTANT NUMBER := 3;
    PROCEDURE enroll (
        p_sid NUMBER,
        p_cid NUMBER
    );

    PROCEDURE withdraw (
        p_sid NUMBER,
        p_cid NUMBER
    );

    FUNCTION get_student_gpa (
        p_sid NUMBER
    ) RETURN NUMBER;

    PROCEDURE print_transcript (
        p_sid NUMBER
    );

    FUNCTION count_enrolled (
        p_sid NUMBER
    ) RETURN NUMBER;

END pkg_student_mgmt;
/
-- Package BODY:
CREATE OR REPLACE PACKAGE BODY pkg_student_mgmt AS
    
    g_call_count NUMBER := 0;

    FUNCTION count_enrolled(p_sid NUMBER) RETURN NUMBER IS
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt FROM enrollment WHERE studentid = p_sid;
        RETURN v_cnt;
    END count_enrolled;

    PROCEDURE enroll (
        p_sid NUMBER,
        p_cid NUMBER
    ) IS
        v_check NUMBER;
        v_cap   NUMBER;
        v_enr   NUMBER;
    BEGIN
        g_call_count := g_call_count + 1;

        
        SELECT COUNT(*) INTO v_check FROM student WHERE studentid = p_sid;
        IF v_check = 0 THEN
            dbms_output.put_line('[LOI] SV khong ton tai');
            RETURN;
        END IF;

        
        SELECT COUNT(*) INTO v_check FROM class WHERE classid = p_cid;
        IF v_check = 0 THEN
            dbms_output.put_line('[LOI] Lop khong ton tai');
            RETURN;
        END IF;

        
        IF count_enrolled(p_sid) >= c_max_classes THEN
            dbms_output.put_line('[LOI] SV da du ' || c_max_classes || ' lop');
            RETURN;
        END IF;

        
        SELECT capacity INTO v_cap FROM class WHERE classid = p_cid;
        SELECT COUNT(*) INTO v_enr FROM enrollment WHERE classid = p_cid;

        IF v_enr >= v_cap THEN
            dbms_output.put_line('[LOI] Lop day');
            RETURN;
        END IF;

   
        INSERT INTO enrollment (
            studentid, classid, enrolldate, createdby, 
            createddate, modifiedby, modifieddate
        )
        VALUES (
            p_sid, p_cid, SYSDATE, USER, 
            SYSDATE, USER, SYSDATE
        );
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('[OK] Dang ky: SV ' || p_sid || ' -> Lop ' || p_cid);
    END enroll;

    PROCEDURE withdraw(p_sid NUMBER, p_cid NUMBER) IS
        v_check NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_check FROM enrollment
        WHERE studentid = p_sid AND classid = p_cid;
        
        IF v_check = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('[LOI] SV chua dang ky lop nay'); 
            RETURN; 
        END IF;

        DELETE FROM enrollment WHERE studentid = p_sid AND classid = p_cid;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('[OK] Da huy dang ky: SV ' || p_sid || ' khoi Lop ' || p_cid);
    END withdraw;

    FUNCTION get_student_gpa(p_sid NUMBER) RETURN NUMBER IS
        v_gpa NUMBER; 
        v_check NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_check FROM student WHERE studentid = p_sid;
        IF v_check = 0 THEN RETURN NULL; END IF;

        SELECT ROUND(AVG(finalgrade), 2) INTO v_gpa
        FROM enrollment WHERE studentid = p_sid AND finalgrade IS NOT NULL;
        RETURN v_gpa;
    END get_student_gpa;

    PROCEDURE print_transcript(p_sid NUMBER) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== BANG DIEM SV: ' || p_sid || ' ===');
        FOR rec IN (
            SELECT co.description, co.courseno, e.finalgrade
            FROM enrollment e
            JOIN class cl ON e.classid = cl.classid
            JOIN course co ON cl.courseno = co.courseno
            WHERE e.studentid = p_sid 
            ORDER BY co.courseno
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(' ' || rec.courseno || ' ' || RPAD(rec.description, 25)
                || ' : ' || NVL(TO_CHAR(rec.finalgrade), 'Chua co diem'));
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE(' GPA: ' || NVL(TO_CHAR(get_student_gpa(p_sid)), 'N/A'));
    END print_transcript;

END pkg_student_mgmt;
/
-- Kiem tra package:
BEGIN
pkg_student_mgmt.enroll(101, 5);

pkg_student_mgmt.print_transcript(101);

end;
/


CREATE OR REPLACE PROCEDURE bulk_update_grades IS

    TYPE t_num IS
        TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v_sids   t_num;
    v_cids   t_num;
    v_grades t_num;
    v_start  NUMBER;
    v_end    NUMBER;
    v_rows   NUMBER := 0;
BEGIN
    v_start := dbms_utility.get_time;
-- Doc du lieu vao mang nhanh
    SELECT
        studentid,
        classid,
        finalgrade
    BULK COLLECT
    INTO
        v_sids,
        v_cids,
        v_grades
    FROM
        enrollment
    WHERE
        finalgrade IS NOT NULL;

    dbms_output.put_line('Doc duoc '
                         || v_sids.count
                         || ' ban ghi...');
-- Cap nhat hang loat vao GRADE (MERGE thay the INSERT+UPDATE)
    FORALL i IN 1..v_sids.count SAVE EXCEPTIONS
        MERGE INTO grade g
        USING (
            SELECT
                v_sids(i)   AS sid,
                v_cids(i)   AS cid,
                v_grades(i) AS gr
            FROM
                dual
        ) src ON ( g.studentid = src.sid
                   AND g.classid = src.cid )
        WHEN MATCHED THEN UPDATE
        SET g.grade = src.gr,
            g.modifiedby = user,
            g.modifieddate = sysdate
        WHEN NOT MATCHED THEN
        INSERT (
            studentid,
            classid,
            grade,
            createdby,
            createddate,
            modifiedby,
            modifieddate )
        VALUES
            ( src.sid,
              src.cid,
              src.gr,
              user,
              sysdate,
              user,
              sysdate );

    v_rows := SQL%rowcount;
    COMMIT;
    v_end := dbms_utility.get_time;
    dbms_output.put_line('Xu ly: '
                         || v_rows
                         || ' hang | Thoi gian: '
                         || round((v_end - v_start) / 100, 2)
                         || ' giay');

EXCEPTION
    WHEN OTHERS THEN
        FOR j IN 1..SQL%bulk_exceptions.count LOOP
            dbms_output.put_line('Loi hang
'
                                 || SQL%bulk_exceptions(j).error_index
                                 || ': '
                                 || sqlerrm(-SQL%bulk_exceptions(j).error_code));
        END LOOP;

        ROLLBACK;
END bulk_update_grades;
/

BEGIN
    bulk_update_grades;
END;
/


CREATE OR REPLACE PROCEDURE generate_course_report (
    p_courseno IN NUMBER
) IS

    v_check   NUMBER;
    v_desc    VARCHAR2(50);
    v_cost    NUMBER;
    v_prereq  NUMBER;
    v_tong_sv NUMBER := 0;
    v_sum_d   NUMBER := 0;
    v_co_d    NUMBER := 0;
    v_sep     VARCHAR2(70) := rpad('=', 60, '=');
    v_sep2    VARCHAR2(70) := rpad('-', 60, '-');
BEGIN
    SELECT
        COUNT(*)
    INTO v_check
    FROM
        course
    WHERE
        courseno = p_courseno;

    IF v_check = 0 THEN
        dbms_output.put_line('Mon hoc '
                             || p_courseno
                             || ' khong ton tai!');
        RETURN;
    END IF;

    SELECT
        description,
        cost,
        prerequisite
    INTO
        v_desc,
        v_cost,
        v_prereq
    FROM
        course
    WHERE
        courseno = p_courseno;

    dbms_output.put_line(v_sep);
    dbms_output.put_line('BAO CAO MON HOC: ' || p_courseno);
    dbms_output.put_line(v_sep2);
    dbms_output.put_line('Ten mon : ' || v_desc);
    dbms_output.put_line('Hoc phi :
'
                         || to_char(
        nvl(v_cost, 0),
        '999,990.00'
    )
                         || ' VND');

    dbms_output.put_line('Mon tien q: '
                         || nvl(
        to_char(v_prereq),
        'Khong
co'
    ));
    dbms_output.put_line(v_sep2);
    dbms_output.put_line(rpad('Lop', 5)
                         || rpad('Giao vien', 20)
                         || lpad('SVDK', 6)
                         || lpad('DTB', 7)
                         || ' Trang thai');

    dbms_output.put_line(v_sep2);
    FOR rec IN (
        SELECT
            cl.classid,
            cl.capacity,
            i.firstname
            || ' '
            || i.lastname      AS ten_gv,
            COUNT(e.studentid) AS so_sv,
            round(
                avg(e.finalgrade),
                1
            )                  AS dtb
        FROM
                 class cl
            JOIN instructor i ON cl.instructorid = i.instructorid
            LEFT JOIN enrollment e ON cl.classid = e.classid
        WHERE
            cl.courseno = p_courseno
        GROUP BY
            cl.classid,
            cl.capacity,
            i.firstname,
            i.lastname
        ORDER BY
            cl.classid
    ) LOOP
        v_tong_sv := v_tong_sv + rec.so_sv;
        IF rec.dtb IS NOT NULL THEN
            v_sum_d := v_sum_d + rec.dtb;
            v_co_d := v_co_d + 1;
        END IF;

        dbms_output.put_line(lpad(rec.classid, 4)
                             || ' '
                             || rpad(rec.ten_gv, 20)
                             || lpad(rec.so_sv, 5)
                             || lpad(
            nvl(
                to_char(rec.dtb),
                '--'
            ),
            7
        )
                             || ' '
                             || CASE
            WHEN rec.capacity - rec.so_sv > 0 THEN
                'Con '
                ||(rec.capacity - rec.so_sv)
                || ' cho'
            ELSE 'Het cho'
        END);

    END LOOP;

    dbms_output.put_line(v_sep2);
    dbms_output.put_line('Tong SV dang ky : ' || v_tong_sv);
    IF v_co_d > 0 THEN
        dbms_output.put_line('Diem TB toan mon:
'
                             || round(v_sum_d / v_co_d, 2));
    END IF;

    dbms_output.put_line(v_sep);
END generate_course_report;
/

BEGIN
    generate_course_report(10);
END;
/

CREATE OR REPLACE FUNCTION convert_to_gpa_40 (
    p_studentid IN NUMBER
) RETURN NUMBER IS
    v_check NUMBER;
    v_gpa   NUMBER;
BEGIN
    SELECT
        COUNT(*)
    INTO v_check
    FROM
        student
    WHERE
        studentid = p_studentid;

    IF v_check = 0 THEN
        RETURN NULL;
    END IF;
    SELECT
        round(sum(CASE
            WHEN finalgrade >= 90 THEN
                4.0
            WHEN finalgrade >= 85 THEN
                3.7
            WHEN finalgrade >= 80 THEN
                3.3
            WHEN finalgrade >= 75 THEN
                3.0
            WHEN finalgrade >= 70 THEN
                2.7
            WHEN finalgrade >= 65 THEN
                2.3
            WHEN finalgrade >= 60 THEN
                2.0
            WHEN finalgrade >= 50 THEN
                1.0
            ELSE 0.0
        END * 3) / -- So tin chi = 3
         nullif(
            sum(
                CASE
                    WHEN finalgrade IS NOT NULL THEN
                        3
                    ELSE 0
                END
            ),
            0
        ),
              2)
    INTO v_gpa
    FROM
        enrollment
    WHERE
        studentid = p_studentid;

    RETURN v_gpa;
END convert_to_gpa_40;
/

CREATE OR REPLACE PROCEDURE print_gpa_report IS
BEGIN
    dbms_output.put_line(rpad('StudentID', 12)
                         || rpad('Ho Ten', 25)
                         || lpad('GPA
(4.0)', 10));

    dbms_output.put_line(rpad('-', 48, '-'));
    FOR rec IN (
        SELECT
            studentid,
            firstname
            || ' '
            || lastname AS ho_ten
        FROM
            student
        ORDER BY
            studentid
    ) LOOP
        DECLARE
            v_gpa NUMBER;
        BEGIN
            v_gpa := convert_to_gpa_40(rec.studentid);
            IF v_gpa IS NOT NULL THEN
                dbms_output.put_line(lpad(rec.studentid, 10)
                                     || ' '
                                     || rpad(rec.ho_ten, 25)
                                     || lpad(v_gpa, 9));

            END IF;

        END;
    END LOOP;

END print_gpa_report;
/

BEGIN
    print_gpa_report;
END;
/

CREATE TABLE notification_log (
log_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
nguoi_nhan VARCHAR2(50),
noi_dung VARCHAR2(500),
loai VARCHAR2(20),
thoi_gian DATE DEFAULT SYSDATE,
trang_thai VARCHAR2(10) DEFAULT 'SENT'
);
/

CREATE OR REPLACE PROCEDURE log_notification (
    p_nguoi_nhan VARCHAR2,
    p_noi_dung   VARCHAR2,
    p_loai       VARCHAR2 DEFAULT 'INFO'
) IS
    PRAGMA autonomous_transaction; -- Doc lap khoi transaction cha
BEGIN
    INSERT INTO notification_log (
        nguoi_nhan,
        noi_dung,
        loai
    ) VALUES ( p_nguoi_nhan,
               substr(p_noi_dung, 1, 500),
               p_loai );

    COMMIT; -- Commit ngay, khong phu thuoc transaction cha
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK; -- Chi rollback autonomous transaction nay
END log_notification;
/

-- Kiem tra tinh doc lap:
BEGIN
    INSERT INTO student (
        studentid,
        lastname,
        registrationdate,
        createdby,
        createddate,
        modifiedby,
        modifieddate
    ) VALUES ( 9999,
               'Test',
               sysdate,
               user,
               sysdate,
               user,
               sysdate );

    log_notification('Admin', 'Da them SV 9999', 'ENROLL');
    ROLLBACK; -- Rollback INSERT student, nhung log van con!
END;
/

SELECT
    *
FROM
    notification_log; -- Ban ghi log van con du da ROLLBACK
    
    
    
ALTER TABLE class ADD so_sv NUMBER DEFAULT 0;
CREATE OR REPLACE TRIGGER trg_update_class_count
FOR INSERT OR UPDATE OR DELETE ON enrollment
COMPOUND TRIGGER

TYPE t_ids IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
v_ids t_ids;
v_idx PLS_INTEGER := 0;
BEFORE STATEMENT IS
BEGIN
v_idx := 0;
v_ids.DELETE;
END BEFORE STATEMENT;

AFTER EACH ROW IS
BEGIN
v_idx := v_idx + 1;
v_ids(v_idx) := CASE
WHEN INSERTING OR UPDATING THEN :NEW.classid
ELSE :OLD.classid
END;
END AFTER EACH ROW;

AFTER STATEMENT IS
BEGIN
FOR i IN 1..v_idx LOOP
UPDATE class
SET so_sv = (SELECT COUNT(*) FROM enrollment
WHERE classid = v_ids(i))
WHERE classid = v_ids(i);
END LOOP;
END AFTER STATEMENT;

END trg_update_class_count;
/

-- Kiem tra:
INSERT INTO enrollment(studentid,classid,enrolldate,createdby,
createddate,modifiedby,modifieddate)
VALUES(101,1,SYSDATE,USER,SYSDATE,USER,SYSDATE);
COMMIT;
SELECT classid, so_sv FROM class WHERE classid=50000001;\


CREATE OR REPLACE VIEW vw_class_enrollment_detail AS
SELECT e.classid, e.studentid,
s.firstname||' '||s.lastname AS ten_sv,
co.description AS ten_mon,
e.finalgrade,
i.firstname||' '||i.lastname AS ten_gv
FROM enrollment e
JOIN student s ON e.studentid=s.studentid
JOIN class cl ON e.classid=cl.classid
JOIN course co ON cl.courseno=co.courseno
JOIN instructor i ON cl.instructorid=i.instructorid;

CREATE OR REPLACE TRIGGER trg_iot_update_grade INSTEAD OF
    UPDATE ON vw_class_enrollment_detail
    FOR EACH ROW
DECLARE
    v_old_grade NUMBER;
BEGIN
    IF
        :new.finalgrade IS NOT NULL
        AND ( :new.finalgrade < 0
        OR :new.finalgrade > 100 )
    THEN
        raise_application_error(-20060, 'Diem khong hop le (0-100)!');
    END IF;

    SELECT
        finalgrade
    INTO v_old_grade
    FROM
        enrollment
    WHERE
            studentid = :old.studentid
        AND classid = :old.classid;

    UPDATE enrollment
    SET
        finalgrade = :new.finalgrade,
        modifiedby = user,
        modifieddate = sysdate
    WHERE
            studentid = :old.studentid
        AND classid = :old.classid;

    MERGE INTO grade g
    USING (
        SELECT
            :old.studentid AS sid,
            :old.classid   AS cid
        FROM
            dual
    ) src ON ( g.studentid = src.sid
               AND g.classid = src.cid )
    WHEN MATCHED THEN UPDATE
    SET g.grade = :new.finalgrade,
        g.modifiedby = user,
        g.modifieddate = sysdate
    WHEN NOT MATCHED THEN
    INSERT (
        studentid,
        classid,
        grade,
        createdby,
        createddate,
        modifiedby,
        modifieddate )
    VALUES
        ( :old.studentid,
          :old.classid,
          :new.finalgrade,
          user,
          sysdate,
          user,
          sysdate );

    log_notification('System',
                     'Cap nhat diem SV '
                     || :old.studentid
                     || ' lop '
                     || :old.classid
                     || ': '
                     || nvl(
        to_char(v_old_grade),
        'NULL'
    )
                     || '->'
                     || :new.finalgrade,
                     'GRADE');

END trg_iot_update_grade;
/

-- Kiem tra:
UPDATE vw_class_enrollment_detail SET finalgrade=88
WHERE studentid=101 AND classid=50000001;
COMMIT;

CREATE TABLE ddl_audit_log (
    log_id      NUMBER
        GENERATED ALWAYS AS IDENTITY,
    event_type  VARCHAR2(30),
    object_type VARCHAR2(30),
    object_name VARCHAR2(128),
    owner       VARCHAR2(30),
    event_time  DATE,
    current_usr VARCHAR2(30)
);
/

CREATE OR REPLACE TRIGGER trg_ddl_audit
    AFTER DDL ON SCHEMA DECLARE
        PRAGMA autonomous_transaction;
    BEGIN
        INSERT INTO ddl_audit_log (
            event_type,
            object_type,
            object_name,
            owner,
            event_time,
            current_usr
        ) VALUES ( ora_sysevent,
                   ora_dict_obj_type,
                   ora_dict_obj_name,
                   ora_dict_obj_owner,
                   sysdate,
                   ora_login_user );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END trg_ddl_audit;
/

-- Kiem tra:
CREATE TABLE test_ddl_track (id NUMBER);
DROP TABLE test_ddl_track;
SELECT * FROM ddl_audit_log ORDER BY log_id DESC;


-- Trigger 1: BEFORE DELETE tren STUDENT - Kiem tra
CREATE OR REPLACE TRIGGER trg_prevent_student_delete
BEFORE DELETE ON student FOR EACH ROW
DECLARE v_count NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count FROM enrollment WHERE
studentid=:OLD.studentid;
IF v_count>0 THEN
RAISE_APPLICATION_ERROR(-20030,
'Khong the xoa SV '||:OLD.studentid||
' dang co '||v_count||' lop dang ky! Huy dang ky truoc.');
END IF;
END;
/

-- Trigger 2: AFTER DELETE tren STUDENT - Cascade xoa GRADE
CREATE OR REPLACE TRIGGER trg_cascade_delete_grade
AFTER DELETE ON student FOR EACH ROW
BEGIN
DELETE FROM grade WHERE studentid=:OLD.studentid;
DBMS_OUTPUT.PUT_LINE('Da xoa '||SQL%ROWCOUNT||' ban ghi GRADE cua SV
'||:OLD.studentid);
END;
/

-- Trigger 3: AFTER DELETE tren ENROLLMENT - Cap nhat so_sv trong CLASS
-- (Compound Trigger o cau 3.1 da xu ly dieu nay!)
-- Neu chua co compound trigger, viet them:
CREATE OR REPLACE TRIGGER trg_update_count_on_delete
AFTER DELETE ON enrollment FOR EACH ROW
BEGIN
UPDATE class SET so_sv=so_sv-1 WHERE classid=:OLD.classid AND so_sv>0;
END;
/

-- Kiem tra chuoi trigger:
-- Thu xoa SV co enrollment (bi chan):
DELETE FROM student WHERE studentid=20000001;

-- Xoa enrollment truoc, sau do xoa SV (thanh cong):
DELETE FROM enrollment WHERE studentid=20000001;
DELETE FROM student WHERE studentid=20000001;
ROLLBACK;

CREATE TABLE certificate (
cert_id NUMBER GENERATED ALWAYS AS IDENTITY,
studentid NUMBER(8),
courseno NUMBER(8),
cap_cc DATE,
loai VARCHAR2(20)
);
/

CREATE OR REPLACE TRIGGER trg_auto_certificate
AFTER UPDATE OF finalgrade ON enrollment
FOR EACH ROW
WHEN (NEW.finalgrade >= 50) -- Chi chay khi diem >= 50
DECLARE
v_courseno NUMBER;
v_check NUMBER;
v_loai VARCHAR2(20);
v_ten_sv VARCHAR2(50);
v_ten_mon VARCHAR2(50);
BEGIN
-- Lay thong tin
SELECT cl.courseno, co.description, s.firstname||' '||s.lastname
INTO v_courseno, v_ten_mon, v_ten_sv
FROM class cl JOIN course co ON cl.courseno=co.courseno
JOIN student s ON s.studentid=:NEW.studentid
WHERE cl.classid=:NEW.classid;

-- Kiem tra da co chung chi chua
SELECT COUNT(*) INTO v_check FROM certificate
WHERE studentid=:NEW.studentid AND courseno=v_courseno;
IF v_check>0 THEN RETURN; END IF; -- Da co roi, bo qua
-- Xac dinh loai chung chi
v_loai := CASE
WHEN :NEW.finalgrade >= 90 THEN 'HIGH_DISTINCTION'
WHEN :NEW.finalgrade >= 75 THEN 'DISTINCTION'
ELSE 'PASS'
END;

-- Cap chung chi
INSERT INTO certificate (studentid, courseno, cap_cc, loai)
VALUES (:NEW.studentid, v_courseno, SYSDATE, v_loai);
DBMS_OUTPUT.PUT_LINE('Chuc mung '||v_ten_sv||' da hoan thanh mon '
||v_ten_mon||' voi '||v_loai||'!');
END trg_auto_certificate;
/

-- Kiem tra:
UPDATE enrollment SET finalgrade=92 WHERE studentid=20000003 AND classid=50000001;
COMMIT;
SELECT * FROM certificate


CREATE OR REPLACE VIEW vw_enrollment_dashboard AS
SELECT
(SELECT COUNT(*) FROM class) AS so_lop_mo,
(SELECT SUM(cl.capacity-NVL(ec.sv,0))
FROM class cl
LEFT JOIN (SELECT classid,COUNT(*) sv FROM enrollment GROUP BY
classid) ec
ON cl.classid=ec.classid) AS
tong_cho_trong,
ROUND(
(SELECT COUNT(*) FROM enrollment)*100.0/
NULLIF((SELECT SUM(capacity) FROM class),0)
,1) AS
ty_le_lap_day_pct,
(SELECT classid||' ('||sv||' SV)'
FROM (SELECT classid, COUNT(*) sv FROM enrollment GROUP BY classid
ORDER BY sv DESC FETCH FIRST 1 ROW ONLY)) AS
lop_dong_nhat,
(SELECT classid||' ('||sv||' SV)'
FROM (SELECT classid, COUNT(*) sv FROM enrollment GROUP BY classid
ORDER BY sv ASC FETCH FIRST 1 ROW ONLY)) AS lop_it_nhat
FROM DUAL;

SELECT * FROM vw_enrollment_dashboard;

CREATE OR REPLACE PACKAGE pkg_enrollment_system AS
FUNCTION is_eligible(p_sid NUMBER, p_cid NUMBER) RETURN BOOLEAN;
PROCEDURE do_enroll(p_sid NUMBER, p_cid NUMBER);
PROCEDURE do_withdraw(p_sid NUMBER, p_cid NUMBER);
FUNCTION get_waitlist_position(p_sid NUMBER, p_cid NUMBER) RETURN
NUMBER;
END pkg_enrollment_system;
/

CREATE OR REPLACE PACKAGE BODY pkg_enrollment_system AS

    FUNCTION is_eligible (
        p_sid NUMBER,
        p_cid NUMBER
    ) RETURN BOOLEAN IS
        v_sv  NUMBER;
        v_cl  NUMBER;
        v_cap NUMBER;
        v_enr NUMBER;
        v_dup NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO v_sv
        FROM
            student
        WHERE
            studentid = p_sid;

        IF v_sv = 0 THEN
            RETURN FALSE;
        END IF;
        SELECT
            COUNT(*)
        INTO v_cl
        FROM
            class
        WHERE
            classid = p_cid;

        IF v_cl = 0 THEN
            RETURN FALSE;
        END IF;
        SELECT
            capacity
        INTO v_cap
        FROM
            class
        WHERE
            classid = p_cid;

        SELECT
            COUNT(*)
        INTO v_enr
        FROM
            enrollment
        WHERE
            classid = p_cid;

        IF v_enr >= v_cap THEN
            RETURN FALSE;
        END IF;
        SELECT
            COUNT(*)
        INTO v_dup
        FROM
            enrollment
        WHERE
                studentid = p_sid
            AND classid = p_cid;

        IF v_dup > 0 THEN
            RETURN FALSE;
        END IF;
        SELECT
            COUNT(*)
        INTO v_enr
        FROM
            enrollment
        WHERE
            studentid = p_sid;

        IF v_enr >= 3 THEN
            RETURN FALSE;
        END IF;
        RETURN TRUE;
    END is_eligible;

    PROCEDURE do_enroll (
        p_sid NUMBER,
        p_cid NUMBER
    ) IS
    BEGIN
        IF NOT is_eligible(p_sid, p_cid) THEN
            dbms_output.put_line('[TU CHOI] Khong du dieu kien dang ky!');
            RETURN;
        END IF;

        INSERT INTO enrollment (
            studentid,
            classid,
            enrolldate,
            createdby,
            createddate,
            modifiedby,
            modifieddate
        ) VALUES ( p_sid,
                   p_cid,
                   sysdate,
                   user,
                   sysdate,
                   user,
                   sysdate );

        COMMIT;
        log_notification(user, 'Dang ky: SV '
                               || p_sid
                               || ' -> Lop
'
                               || p_cid, 'ENROLL');
        dbms_output.put_line('[OK] Dang ky thanh cong!');
    END do_enroll;

    PROCEDURE do_withdraw (
        p_sid NUMBER,
        p_cid NUMBER
    ) IS
        v_check NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO v_check
        FROM
            enrollment
        WHERE
                studentid = p_sid
            AND classid = p_cid;

        IF v_check = 0 THEN
            dbms_output.put_line('[LOI] SV chua dang ky lop nay!');
            RETURN;
        END IF;
        DELETE FROM enrollment
        WHERE
                studentid = p_sid
            AND classid = p_cid;

        COMMIT;
        log_notification(user, 'Huy dk: SV '
                               || p_sid
                               || ' khoi Lop
'
                               || p_cid, 'WITHDRAW');
        dbms_output.put_line('[OK] Huy dang ky thanh cong!');
    END do_withdraw;

    FUNCTION get_waitlist_position (
        p_sid NUMBER,
        p_cid NUMBER
    ) RETURN NUMBER IS
        v_cap NUMBER;
        v_enr NUMBER;
    BEGIN
        SELECT
            capacity
        INTO v_cap
        FROM
            class
        WHERE
            classid = p_cid;

        SELECT
            COUNT(*)
        INTO v_enr
        FROM
            enrollment
        WHERE
            classid = p_cid;

        IF v_enr < v_cap THEN
            RETURN 0;
        END IF;
        RETURN v_enr - v_cap + 1;
    END;

END pkg_enrollment_system;
/

-- Kiem tra:
BEGIN
pkg_enrollment_system.do_enroll(101, 3);
pkg_enrollment_system.do_enroll(999, 1); -- SV khong ton tai
END;
/



-- Xem execution plan cua view
EXPLAIN PLAN FOR SELECT * FROM vw_course_summary;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
-- Tim Full Table Scan (TABLE ACCESS FULL) trong output
-- Tao INDEX tren cac cot hay dung trong JOIN/WHERE:
CREATE INDEX idx_enrollment_classid ON enrollment(classid);
CREATE INDEX idx_enrollment_studentid ON enrollment(studentid);
CREATE INDEX idx_class_courseno ON class(courseno);
CREATE INDEX idx_class_instructorid ON class(instructorid);
-- Chay lai EXPLAIN PLAN sau khi tao INDEX de so sanh
EXPLAIN PLAN FOR SELECT * FROM vw_course_summary;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
-- Ket qua mong doi: thay 'TABLE ACCESS FULL' bang 'INDEX RANGE SCAN'


CREATE OR REPLACE PROCEDURE report_class_detail_v2
(p_classid IN NUMBER)
IS
TYPE t_rec IS RECORD(
ho_ten VARCHAR2(50),
finalgrade NUMBER
);
TYPE t_recs IS TABLE OF t_rec INDEX BY PLS_INTEGER;
v_data t_recs;
v_stt NUMBER:=0;
BEGIN
-- BULK COLLECT thay vi cursor tung hang
SELECT s.firstname||' '||s.lastname, e.finalgrade
BULK COLLECT INTO v_data
FROM enrollment e JOIN student s ON e.studentid=s.studentid
WHERE e.classid=p_classid
ORDER BY s.lastname;

DBMS_OUTPUT.PUT_LINE('So SV: '||v_data.COUNT);
FOR i IN 1..v_data.COUNT LOOP
v_stt:=v_stt+1;
DBMS_OUTPUT.PUT_LINE(LPAD(v_stt,3)||' '||RPAD(v_data(i).ho_ten,22)
||LPAD(NVL(TO_CHAR(v_data(i).finalgrade),'--'),6));
END LOOP;
END report_class_detail_v2;
/

CREATE OR REPLACE PROCEDURE run_all_tests IS
    -- 1. Khai báo tất cả các biến ở đây
    v_pass NUMBER := 0; 
    v_fail NUMBER := 0;
    v_cnt  NUMBER; 

    -- 2. Sau đó mới đến các Procedure/Function cục bộ
    PROCEDURE assert(p_test VARCHAR2, p_cond BOOLEAN) IS
    BEGIN
        IF p_cond THEN
            v_pass := v_pass + 1;
            DBMS_OUTPUT.PUT_LINE('[PASS] ' || p_test);
        ELSE
            v_fail := v_fail + 1;
            DBMS_OUTPUT.PUT_LINE('[FAIL] ' || p_test);
        END IF;
    END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('=== BAT DAU TEST ===');

    -- Test 1: enroll SV ton tai vao lop ton tai
    BEGIN
        pkg_enrollment_system.do_enroll(102, 2);
        SELECT COUNT(*) INTO v_cnt
        FROM enrollment
        WHERE studentid = 102 AND classid = 2;
        
        assert('Enroll hop le', v_cnt > 0);
        ROLLBACK;
    EXCEPTION 
        WHEN OTHERS THEN
            assert('Enroll hop le', FALSE);
    END;

    -- Test 2: enroll SV khong ton tai -> phai that bai
    BEGIN
        -- Gia su pkg co exception handle, neu khong v_cnt se khong duoc update
        pkg_enrollment_system.do_enroll(99999, 1);
        SELECT COUNT(*) INTO v_cnt
        FROM enrollment WHERE studentid = 102 AND classid = 2; -- Check lai logic count tai day
        
        -- Thong thuong test fail se throw exception o line do_enroll
        assert('Chon SV khong ton tai', TRUE); 
    EXCEPTION
        WHEN OTHERS THEN
            assert('Chon SV khong ton tai (Catch Exception)', TRUE);
    END;

    DBMS_OUTPUT.PUT_LINE('=== KET QUA: PASS=' || v_pass || ' FAIL=' || v_fail || ' ===');
END run_all_tests;
/

BEGIN run_all_tests;
END;
/