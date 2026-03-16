CREATE TABLE Mathang ( 
Mahang   VARCHAR2(5)   CONSTRAINT pk_mathang PRIMARY KEY, 
Tenhang  VARCHAR2(50)  NOT NULL, 
Soluong  NUMBER(10) 
); 
CREATE TABLE Nhatkybanhang ( 
Stt      NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
Ngay     DATE, 
Nguoimua VARCHAR2(50), 
Mahang   VARCHAR2(5)   REFERENCES Mathang(Mahang), 
Soluong  NUMBER(10), 
Giaban   NUMBER(15,2) 
); -- Dữ liệu mẫu Mathang 
INSERT INTO Mathang VALUES ('1','Hang A', 100); 
INSERT INTO Mathang VALUES ('2','Hang B', 200); 
INSERT INTO Mathang VALUES ('3','Hang C', 150); 
COMMIT;

CREATE OR REPLACE TRIGGER trg_nhatkybanhang_insert
AFTER INSERT ON Nhatkybanhang
FOR EACH ROW
BEGIN
    UPDATE Mathang
    SET Soluong = Soluong - :NEW.Soluong
    WHERE Mahang = :NEW.Mahang;
END;
/

INSERT INTO Nhatkybanhang (Ngay, Nguoimua, Mahang, Soluong, Giaban) 
VALUES (SYSDATE, 'Le Ngoc Thuan', '1', 10, 2000000);
SELECT * FROM Mathang WHERE Mahang = '1';

CREATE OR REPLACE TRIGGER trg_nhatkybanhang_update_soluong 
AFTER UPDATE OF Soluong ON Nhatkybanhang
FOR EACH ROW
BEGIN
    UPDATE Mathang
    SET Soluong = Soluong - (:NEW.Soluong - :OLD.Soluong) 
    WHERE Mahang = :NEW.Mahang; 
END;
/
SELECT * FROM Nhatkybanhang;
UPDATE Nhatkybanhang 
SET Soluong = 15 
WHERE Stt = 1;
SELECT * FROM Mathang WHERE Mahang = '1';

CREATE OR REPLACE TRIGGER trg_nhatky_check_insert
BEFORE INSERT ON Nhatkybanhang
FOR EACH ROW
DECLARE
    v_tonkho NUMBER;
BEGIN
    SELECT Soluong INTO v_tonkho 
    FROM Mathang 
    WHERE Mahang = :NEW.Mahang;
    IF :NEW.Soluong > v_tonkho THEN
        RAISE_APPLICATION_ERROR(-20001, 'Lỗi: Số lượng bán vượt quá số lượng tồn kho!');
    ELSE
        UPDATE Mathang 
        SET Soluong = Soluong - :NEW.Soluong 
        WHERE Mahang = :NEW.Mahang;
    END IF;
END;
/

INSERT INTO Nhatkybanhang (Ngay, Nguoimua, Mahang, Soluong, Giaban) 
VALUES (SYSDATE, 'Nguyen Trong Thuan', '3', 200, 50000);
INSERT INTO Nhatkybanhang (Ngay, Nguoimua, Mahang, Soluong, Giaban) 
VALUES (SYSDATE, 'Nguyen Trong Thuan', '3', 50, 50000);
SELECT * FROM Mathang WHERE Mahang = '3';

CREATE OR REPLACE PACKAGE pkg_nhatky AS
    g_row_count NUMBER := 0; 
END pkg_nhatky;
/

CREATE OR REPLACE TRIGGER trg_nhatky_compound_update
FOR UPDATE OF Soluong ON Nhatkybanhang
COMPOUND TRIGGER
    BEFORE STATEMENT IS
    BEGIN
        pkg_nhatky.g_row_count := 0;
    END BEFORE STATEMENT;
    AFTER EACH ROW IS
    BEGIN
        pkg_nhatky.g_row_count := pkg_nhatky.g_row_count + 1;
        IF pkg_nhatky.g_row_count > 1 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Lỗi: Câu lệnh UPDATE không được tác động lên nhiều hơn 1 dòng!');
        END IF;
        UPDATE Mathang
        SET Soluong = Soluong - (:NEW.Soluong - :OLD.Soluong)
        WHERE Mahang = :NEW.Mahang;
    END AFTER EACH ROW;

END;
/

UPDATE Nhatkybanhang 
SET Soluong = 12 
WHERE Stt = 1;
SELECT * FROM Mathang;

UPDATE Nhatkybanhang 
SET Soluong = 20;

CREATE OR REPLACE TRIGGER trg_nhatky_delete_control
FOR DELETE ON Nhatkybanhang
COMPOUND TRIGGER
    BEFORE STATEMENT IS
    BEGIN
        pkg_nhatky.g_row_count := 0;
    END BEFORE STATEMENT;
    AFTER EACH ROW IS
    BEGIN
        pkg_nhatky.g_row_count := pkg_nhatky.g_row_count + 1;
        IF pkg_nhatky.g_row_count > 1 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Lỗi: Chỉ được phép xóa tối đa 1 bản ghi mỗi lần!');
        END IF;
        UPDATE Mathang
        SET Soluong = Soluong + :OLD.Soluong
        WHERE Mahang = :OLD.Mahang;
    END AFTER EACH ROW;

END;
/

SELECT * FROM Mathang;
DELETE FROM Nhatkybanhang WHERE Stt = 1;

CREATE OR REPLACE TRIGGER trg_nhatky_update_nang_cao
FOR UPDATE OF Soluong ON Nhatkybanhang
COMPOUND TRIGGER
    BEFORE STATEMENT IS
    BEGIN
        pkg_nhatky.g_row_count := 0;
    END BEFORE STATEMENT;
    AFTER EACH ROW IS
        v_tonkho NUMBER;
    BEGIN
        pkg_nhatky.g_row_count := pkg_nhatky.g_row_count + 1;
        IF pkg_nhatky.g_row_count > 1 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Lỗi: UPDATE > 1 bản ghi');
        END IF;
        SELECT Soluong INTO v_tonkho FROM Mathang WHERE Mahang = :NEW.Mahang;
        IF :NEW.Soluong < v_tonkho THEN 
            RAISE_APPLICATION_ERROR(-20002, 'Lỗi sai cập nhật');
            
        ELSIF :NEW.Soluong = v_tonkho THEN
            DBMS_OUTPUT.PUT_LINE('Thông báo: Không cần cập nhật');
            
        ELSE
            UPDATE Mathang 
            SET Soluong = Soluong - (:NEW.Soluong - :OLD.Soluong)
            WHERE Mahang = :NEW.Mahang;
        END IF;
    END AFTER EACH ROW;

END;
/

UPDATE Nhatkybanhang SET Soluong = 50;
UPDATE Nhatkybanhang SET Soluong = 120 WHERE Stt = 1;

CREATE OR REPLACE PROCEDURE sp_xoa_mathang (p_mahang IN VARCHAR2) AS
    v_ton_tai NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_ton_tai 
    FROM Mathang 
    WHERE Mahang = p_mahang;

    IF v_ton_tai = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Thông báo: Mã hàng ' || p_mahang || ' không tồn tại.');
    ELSE
        DELETE FROM Nhatkybanhang 
        WHERE Mahang = p_mahang;

        DELETE FROM Mathang 
        WHERE Mahang = p_mahang;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Đã xóa thành công mặt hàng ' || p_mahang || ' và các nhật ký liên quan.');
    END IF;
END;
/

EXEC sp_xoa_mathang('1');

CREATE OR REPLACE FUNCTION fn_TongTien_TheoTen (
    p_tenhang IN VARCHAR2 
) RETURN NUMBER AS
    v_tong NUMBER := 0; 
BEGIN
    SELECT SUM(nk.Soluong * nk.Giaban) INTO v_tong
    FROM Nhatkybanhang nk
    JOIN Mathang mh ON nk.Mahang = mh.Mahang 
    WHERE mh.Tenhang = p_tenhang;
    RETURN NVL(v_tong, 0);
END fn_TongTien_TheoTen;
/

SELECT fn_TongTien_TheoTen('Hang C') AS Tong_Tien_Ban_Duoc 
FROM DUAL;
