CREATE TABLE KHOA (
    Makhoa VARCHAR2(20) PRIMARY KEY,
    Tenkhoa VARCHAR2(100) NOT NULL,
    Dienthoai VARCHAR2(20)
);

CREATE TABLE LOP (
    Malop VARCHAR2(20) PRIMARY KEY,
    Tenlop VARCHAR2(100) NOT NULL, 
    Khoa VARCHAR2(100),              
    Hedt VARCHAR2(50),               
    Namnhaphoc NUMBER,               
    Makhoa VARCHAR2(20),            
    CONSTRAINT FK_LOP_KHOA FOREIGN KEY (Makhoa) REFERENCES KHOA(Makhoa)
);
 
CREATE OR REPLACE PROCEDURE sp_ThemKhoa (
    p_makhoa IN VARCHAR2,
    p_tenkhoa IN VARCHAR2,
    p_dienthoai IN VARCHAR2
) AS
    v_dem NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem 
    FROM KHOA 
    WHERE Tenkhoa = p_tenkhoa;
    IF v_dem > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Tên khoa "' || p_tenkhoa || '" đã tồn tại trước đó!');
    ELSE
        INSERT INTO KHOA (Makhoa, Tenkhoa, Dienthoai)
        VALUES (p_makhoa, p_tenkhoa, p_dienthoai);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Đã thêm khoa "' || p_tenkhoa || '" thành công.');
    END IF;
END sp_ThemKhoa;
/


//test chua ton tai
SET SERVEROUTPUT ON;
BEGIN
    sp_ThemKhoa('CNTT', 'Cong nghe thong tin', '0123456789');
END;
/

//test da ton tai
BEGIN
    sp_ThemKhoa('CNTT02', 'Cong nghe thong tin', '0987654321');
END;
/

CREATE OR REPLACE PROCEDURE SP_ThemLop (
    p_malop IN VARCHAR2,
    p_tenlop IN VARCHAR2,
    p_khoa IN VARCHAR2,
    p_hedt IN VARCHAR2,
    p_namnhaphoc IN NUMBER,
    p_makhoa IN VARCHAR2
) AS
    v_demLop NUMBER := 0;
    v_demKhoa NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_demLop FROM LOP WHERE Tenlop = p_tenlop;
    SELECT COUNT(*) INTO v_demKhoa FROM KHOA WHERE Makhoa = p_makhoa;
    IF v_demLop > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: Tên lớp "' || p_tenlop || '" đã tồn tại!');
    ELSIF v_demKhoa = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: Mã khoa "' || p_makhoa || '" không có trong bảng KHOA!');
    ELSE
        INSERT INTO LOP (Malop, Tenlop, Khoa, Hedt, Namnhaphoc, Makhoa)
        VALUES (p_malop, p_tenlop, p_khoa, p_hedt, p_namnhaphoc, p_makhoa);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Thêm lớp mới thành công!');
    END IF;
END SP_ThemLop;
/

// test ma khoa da ton tai

BEGIN
    SP_ThemLop('L01', 'Lớp Công nghệ Thông Tin 1', 'Cong nghe thong tin', 'Đại học', 2022, 'CNTT');
END;
/

// test ma khoa khong ton tai

BEGIN
    SP_ThemLop('L01', 'Lớp Công nghệ Thông Tin 2', 'Cong nghe thong tin', 'Đại học', 2022, 'K12');
END;
/

CREATE OR REPLACE PROCEDURE sp_ThemKhoa_KQ (
    p_makhoa IN VARCHAR2,
    p_tenkhoa IN VARCHAR2,
    p_dienthoai IN VARCHAR2,
    p_ketqua OUT NUMBER
) AS
    v_dem NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem 
    FROM KHOA 
    WHERE Tenkhoa = p_tenkhoa;
    IF v_dem > 0 THEN
        p_ketqua := 0;
    ELSE
        INSERT INTO KHOA (Makhoa, Tenkhoa, Dienthoai)
        VALUES (p_makhoa, p_tenkhoa, p_dienthoai);
        COMMIT; 
        p_ketqua := 1;
    END IF;
END sp_ThemKhoa_KQ;
/


// test them khoa moi
SET SERVEROUTPUT ON;
DECLARE
    v_kq NUMBER;
BEGIN
    sp_ThemKhoa_KQ('K01', 'Khoa Moi Truong', '0111222333', v_kq);
    
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq); 
END;
/

//test them khoa ton tai
DECLARE
    v_kq NUMBER;
BEGIN
    sp_ThemKhoa_KQ('K02', 'Khoa Moi Truong', '0123459876', v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq); 
END;
/


CREATE OR REPLACE PROCEDURE SP_ThemLop_DS (
    p_malop IN VARCHAR2,
    p_tenlop IN VARCHAR2,
    p_khoa IN VARCHAR2,
    p_hedt IN VARCHAR2,
    p_namnhaphoc IN NUMBER,
    p_makhoa IN VARCHAR2,
    p_ketqua OUT NUMBER
) AS
    v_demLop NUMBER := 0;
    v_demKhoa NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_demLop FROM LOP WHERE Tenlop = p_tenlop;
    SELECT COUNT(*) INTO v_demKhoa FROM KHOA WHERE Makhoa = p_makhoa;
    IF v_demLop > 0 THEN
        p_ketqua := 0;
    ELSIF v_demKhoa = 0 THEN
        p_ketqua := 1;
    ELSE
        INSERT INTO LOP (Malop, Tenlop, Khoa, Hedt, Namnhaphoc, Makhoa)
        VALUES (p_malop, p_tenlop, p_khoa, p_hedt, p_namnhaphoc, p_makhoa);
        COMMIT;
        p_ketqua := 2;
    END IF;
END SP_ThemLop_DS;
/

// test cac truong hop
SET SERVEROUTPUT ON; 
DECLARE
    v_kq NUMBER; 
BEGIN

    SP_ThemLop_DS('L10', 'Lớp Công nghệ Thông Tin 1', 'CN', 'ĐH', 2022, 'CNTT', v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq);

    SP_ThemLop_DS('L11', 'Lớp Kinh Doanh', 'KD', 'ĐH', 2025, 'KHOA_KD', v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq); -- Mong đợi: 1

    SP_ThemLop_DS('L12', 'Lớp Công nghệ Thông Tin 3', 'CN', 'ĐH', 2022, 'CNTT', v_kq);
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq); -- Mong đợi: 2
END;
/

