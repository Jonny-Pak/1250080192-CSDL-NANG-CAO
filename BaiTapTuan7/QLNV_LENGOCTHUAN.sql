CREATE TABLE tblChucVu (
    MaCV VARCHAR2(10) PRIMARY KEY, 
    TenCV VARCHAR2(50) NOT NULL    
);

CREATE TABLE tblNhanVien (
    MaNV VARCHAR2(10) PRIMARY KEY,        
    MaCV VARCHAR2(10),                   
    TenNV VARCHAR2(100) NOT NULL,        
    NgaySinh DATE,                       
    LuongCanBan NUMBER(15, 2),          
    NgayCong NUMBER(2),                  
    PhuCap NUMBER(15, 2),                
    CONSTRAINT fk_NhanVien_ChucVu FOREIGN KEY (MaCV) REFERENCES tblChucVu(MaCV)
);

INSERT INTO tblChucVu (MaCV, TenCV) VALUES ('GD', 'Giám đốc');
INSERT INTO tblChucVu (MaCV, TenCV) VALUES ('TP', 'Trưởng phòng');
INSERT INTO tblChucVu (MaCV, TenCV) VALUES ('PP', 'Phó phòng');
INSERT INTO tblChucVu (MaCV, TenCV) VALUES ('NV', 'Nhân viên');

INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap) 
VALUES ('NV01', 'GD', 'Le Ngoc Thuan', TO_DATE('19/07/2005', 'DD/MM/YYYY'), 20000000, 22, 5000000);
INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap) 
VALUES ('NV02', 'TP', 'Tran Dang Khoa', TO_DATE('10/01/2005', 'DD/MM/YYYY'), 15000000, 24, 3000000);
INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap) 
VALUES ('NV03', 'NV', 'Vo Thanh Tung', TO_DATE('02/05/2005', 'DD/MM/YYYY'), 8000000, 26, 1000000);

CREATE OR REPLACE PROCEDURE SP_Them_Nhan_Vien (
    p_MaNV IN VARCHAR2,
    p_MaCV IN VARCHAR2,
    p_TenNV IN VARCHAR2,
    p_NgaySinh IN DATE,
    p_LuongCanBan IN NUMBER,
    p_NgayCong IN NUMBER,
    p_PhuCap IN NUMBER
) AS
    v_dem NUMBER := 0; 
BEGIN
    SELECT COUNT(*) INTO v_dem 
    FROM tblChucVu 
    WHERE MaCV = p_MaCV;
    IF v_dem > 0 THEN
        INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
        VALUES (p_MaNV, p_MaCV, p_TenNV, p_NgaySinh, p_LuongCanBan, p_NgayCong, p_PhuCap);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Thêm nhân viên thành công!'); 
    ELSE
        DBMS_OUTPUT.PUT_LINE('Lỗi: Mã chức vụ ' || p_MaCV || ' không tồn tại!');
    END IF;
END SP_Them_Nhan_Vien;
/

SET SERVEROUTPUT ON; 
BEGIN
    SP_Them_Nhan_Vien(
        'NV002', 
        'NV', 
        'Nguyen Van B', 
        TO_DATE('1990-01-01', 'YYYY-MM-DD'), 
        5000000, 
        24, 
        500000
    );
END;
/



CREATE OR REPLACE PROCEDURE SP_CapNhat_Nhan_Vien (
    p_MaNV IN VARCHAR2,        
    p_MaCV IN VARCHAR2,       
    p_TenNV IN VARCHAR2,
    p_NgaySinh IN DATE,
    p_LuongCB IN NUMBER,
    p_NgayCong IN NUMBER,
    p_PhuCap IN NUMBER
) AS
    v_dem NUMBER := 0;       
BEGIN
    SELECT COUNT(*) INTO v_dem 
    FROM tblChucVu 
    WHERE MaCV = p_MaCV;
    IF v_dem > 0 THEN
        UPDATE tblNhanVien
        SET MaCV = p_MaCV,
            TenNV = p_TenNV,
            NgaySinh = p_NgaySinh,
            LuongCanBan = p_LuongCB,
            NgayCong = p_NgayCong,
            PhuCap = p_PhuCap
        WHERE MaNV = p_MaNV;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Cap nhat thong tin nhan vien ' || p_MaNV || ' thanh cong.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Loi: Ma chuc vu ' || p_MaCV || ' khong ton tai trong he thong!');
    END IF;
END SP_CapNhat_Nhan_Vien;
/

SET SERVEROUTPUT ON; 
BEGIN
    -- Cập nhật nhân viên NV01 sang chức vụ mới (giả sử là 'TP')
    SP_CapNhat_Nhan_Vien(
        'NV01', 
        'TP', 
        'Le Ngoc Thuan', 
        TO_DATE('2005-07-19', 'YYYY-MM-DD'), 
        22000000, 
        25, 
        6000000
    );
END;
/

CREATE OR REPLACE PROCEDURE SP_LuongLN AS
BEGIN
    FOR nv IN (SELECT TenNV, LuongCanBan, NgayCong, PhuCap FROM tblNhanVien) LOOP
        DBMS_OUTPUT.PUT_LINE('Nhân viên: ' || nv.TenNV || ' - Lương: ' || (nv.LuongCanBan * nv.NgayCong + nv.PhuCap));
    END LOOP;
END SP_LuongLN;
/


SET SERVEROUTPUT ON; 
BEGIN
    SP_LuongLN; 
END;
/



CREATE OR REPLACE PROCEDURE sp_them_nhan_vien1 (
    p_MaNV IN VARCHAR2,
    p_MaCV IN VARCHAR2,
    p_TenNV IN VARCHAR2,
    p_NgaySinh IN DATE,
    p_LuongCB IN NUMBER,
    p_NgayCong IN NUMBER,
    p_PhuCap IN NUMBER,
    p_KetQua OUT NUMBER 
) AS
    v_demCV NUMBER := 0; 
BEGIN
    SELECT COUNT(*) INTO v_demCV 
    FROM tblChucVu 
    WHERE MaCV = p_MaCV;

    IF v_demCV = 0 THEN
        p_KetQua := 0;
    ELSE
        INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
        VALUES (p_MaNV, p_MaCV, p_TenNV, p_NgaySinh, p_LuongCB, p_NgayCong, p_PhuCap);
        COMMIT;
        p_KetQua := 1;
    END IF;
END sp_them_nhan_vien1;
/

SET SERVEROUTPUT ON; 
DECLARE
    v_ketqua_trave NUMBER; 
BEGIN
    sp_them_nhan_vien1(
        'NV10', 'KHONG_CO', 'Nguyen Thi No', 
        TO_DATE('2000-01-01', 'YYYY-MM-DD'), 5000000, 20, 500000, 
        v_ketqua_trave
    );
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_ketqua_trave);
END;
/


CREATE OR REPLACE PROCEDURE sp_them_nhan_vien_v2 (
    p_MaNV IN VARCHAR2,      
    p_MaCV IN VARCHAR2,
    p_TenNV IN VARCHAR2,
    p_NgaySinh IN DATE,
    p_LuongCB IN NUMBER,
    p_NgayCong IN NUMBER,
    p_PhuCap IN NUMBER,
    p_KetQua OUT NUMBER      
) AS
    v_demNV NUMBER := 0;      
    v_demCV NUMBER := 0;     
BEGIN

    SELECT COUNT(*) INTO v_demNV FROM tblNhanVien WHERE MaNV = p_MaNV;

    SELECT COUNT(*) INTO v_demCV FROM tblChucVu WHERE MaCV = p_MaCV;

    IF v_demNV > 0 THEN
        p_KetQua := 0;         
    ELSIF v_demCV = 0 THEN
        p_KetQua := 1;         
    ELSE
        INSERT INTO tblNhanVien (MaNV, MaCV, TenNV, NgaySinh, LuongCanBan, NgayCong, PhuCap)
        VALUES (p_MaNV, p_MaCV, p_TenNV, p_NgaySinh, p_LuongCB, p_NgayCong, p_PhuCap);
        COMMIT;               
        p_KetQua := 2;        
    END IF;                   
END sp_them_nhan_vien_v2;    
/

SET SERVEROUTPUT ON; 
DECLARE
    v_kq NUMBER; 
BEGIN
    sp_them_nhan_vien_v2(
        'NV09', 'NV', 'Tran Van Khoi', 
        TO_DATE('2004-02-01', 'YYYY-MM-DD'), 
        5000000, 22, 1000000, 
        v_kq
    );
    
    DBMS_OUTPUT.PUT_LINE('Ket qua: ' || v_kq);
END;
/


CREATE OR REPLACE PROCEDURE sp_CapNhat_NgaySinh (
    p_MaNV IN VARCHAR2,       
    p_NgaySinh IN DATE,       
    p_KetQua OUT NUMBER      
) AS
    v_dem NUMBER := 0;        
BEGIN
    SELECT COUNT(*) INTO v_dem 
    FROM tblNhanVien 
    WHERE MaNV = p_MaNV;

    IF v_dem = 0 THEN
        p_KetQua := 0;
    ELSE
        UPDATE tblNhanVien 
        SET NgaySinh = p_NgaySinh 
        WHERE MaNV = p_MaNV;
        COMMIT; 

        p_KetQua := 1;
    END IF;
END sp_CapNhat_NgaySinh;
/

SET SERVEROUTPUT ON; 
DECLARE
    v_kq NUMBER; 
BEGIN

    sp_CapNhat_NgaySinh('NV01', TO_DATE('2005-07-20', 'YYYY-MM-DD'), v_kq);

    IF v_kq = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ket qua: 0');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ket qua: 1');
    END IF;
END;
/