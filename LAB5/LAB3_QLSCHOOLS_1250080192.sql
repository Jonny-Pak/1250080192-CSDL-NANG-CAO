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

