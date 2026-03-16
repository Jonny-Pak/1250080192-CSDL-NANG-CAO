CREATE TABLE Hang (
    Mahang VARCHAR2(10) PRIMARY KEY, 
    Tenhang VARCHAR2(50) NOT NULL,  
    Soluong NUMBER(10) DEFAULT 0,     
    Giaban  NUMBER(15, 2)           
);

CREATE TABLE Hoadon (
    Mahd VARCHAR2(10) PRIMARY KEY,       
    Mahang VARCHAR2(10),                 
    Soluongban NUMBER(10),               
    Ngayban DATE DEFAULT SYSDATE,        
    CONSTRAINT fk_hoadon_hang FOREIGN KEY (Mahang) REFERENCES Hang(Mahang)
);

INSERT INTO Hang (Mahang, Tenhang, Soluong, Giaban) 
VALUES ('H01', 'iPhone 15 Pro', 100, 28000000);
INSERT INTO Hoadon (Mahd, Mahang, Soluongban, Ngayban) 
VALUES ('HD001', 'H01', 10, SYSDATE);


CREATE OR REPLACE TRIGGER trg_hoadon_insert
BEFORE INSERT ON Hoadon
FOR EACH ROW
DECLARE
    v_tonkho NUMBER;
    v_dem    NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem 
    FROM Hang 
    WHERE Mahang = :NEW.Mahang;
    IF v_dem = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Loi: Ma hang khong ton tai trong bang HANG!');
    END IF;
    
    SELECT Soluong INTO v_tonkho 
    FROM Hang 
    WHERE Mahang = :NEW.Mahang;
    IF :NEW.Soluongban > v_tonkho THEN
        RAISE_APPLICATION_ERROR(-20002, 'Loi: So luong ban vuot qua ton kho!');
    END IF;
    
    UPDATE Hang 
    SET Soluong = Soluong - :NEW.Soluongban 
    WHERE Mahang = :NEW.Mahang;
END;
/

SELECT * FROM Hoadon WHERE Mahd = 'HD001';
SELECT * FROM Hang WHERE Mahang = 'H01';

CREATE OR REPLACE TRIGGER trg_hoadon_delete 
AFTER DELETE ON Hoadon 
FOR EACH ROW 
BEGIN
    UPDATE Hang 
    SET Soluong = Soluong + :OLD.Soluongban 
    WHERE Mahang = :OLD.Mahang; 
END;
/

SELECT * FROM Hang WHERE Mahang = 'H01';
DELETE FROM Hoadon WHERE Mahd = 'HD001';

CREATE OR REPLACE TRIGGER trg_hoadon_update 
AFTER UPDATE OF Soluongban ON Hoadon 
FOR EACH ROW 
BEGIN
    UPDATE Hang 
    SET Soluong = Soluong - (:NEW.Soluongban - :OLD.Soluongban) 
    WHERE Mahang = :NEW.Mahang; 
END;
/

UPDATE Hoadon 
SET Soluongban = 8 
WHERE Mahd = 'HD001';

SELECT * FROM Hang WHERE Mahang = 'H01';
SELECT * FROM Hoadon WHERE Mahd = 'HD001';


