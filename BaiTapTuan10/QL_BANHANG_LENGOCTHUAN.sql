CREATE TABLE HangSX (
    MaHangSX CHAR(10) PRIMARY KEY,
    TenHang NVARCHAR2(50),
    DiaChi NVARCHAR2(100),
    SoDT VARCHAR2(20),
    Email VARCHAR2(50)
);


CREATE TABLE SanPham (
    MaSP CHAR(10) PRIMARY KEY,
    MaHangSX CHAR(10),
    TenSP NVARCHAR2(50),
    SoLuong NUMBER,
    MauSac NVARCHAR2(20),
    GiaBan NUMBER,
    DonViTinh NVARCHAR2(20),
    MoTa NVARCHAR2(200),
    CONSTRAINT FK_SP_HangSX FOREIGN KEY (MaHangSX) REFERENCES HangSX(MaHangSX)
);


CREATE TABLE NhanVien (
    MaNV CHAR(10) PRIMARY KEY,
    TenNV NVARCHAR2(50),
    GioiTinh NVARCHAR2(10),
    DiaChi NVARCHAR2(100),
    SoDT VARCHAR2(20),
    Email VARCHAR2(50),
    TenPhong NVARCHAR2(50)
);


CREATE TABLE PNhap (
    SoHDN CHAR(10) PRIMARY KEY,
    NgayNhap DATE,
    MaNV CHAR(10),
    CONSTRAINT FK_PNhap_NV FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);


CREATE TABLE Nhap (
    SoHDN CHAR(10),
    MaSP CHAR(10),
    SoLuongN NUMBER,
    DonGiaN NUMBER,
    CONSTRAINT PK_Nhap PRIMARY KEY (SoHDN, MaSP),
    CONSTRAINT FK_Nhap_PNhap FOREIGN KEY (SoHDN) REFERENCES PNhap(SoHDN),
    CONSTRAINT FK_Nhap_SP FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);


CREATE TABLE PXuat (
    SoHDX CHAR(10) PRIMARY KEY,
    NgayXuat DATE,
    MaNV CHAR(10),
    CONSTRAINT FK_PXuat_NV FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);


CREATE TABLE Xuat (
    SoHDX CHAR(10),
    MaSP CHAR(10),
    SoLuongX NUMBER,
    CONSTRAINT PK_Xuat PRIMARY KEY (SoHDX, MaSP),
    CONSTRAINT FK_Xuat_PXuat FOREIGN KEY (SoHDX) REFERENCES PXuat(SoHDX),
    CONSTRAINT FK_Xuat_SP FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

CREATE OR REPLACE TRIGGER trg_Nhap
BEFORE INSERT ON Nhap
FOR EACH ROW
DECLARE
    v_dem NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem 
    FROM SanPham 
    WHERE MaSP = :NEW.MaSP;
    IF v_dem = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Lỗi: Mã sản phẩm ' || :NEW.MaSP || ' không tồn tại trong danh mục SanPham.');
    END IF;

    IF :NEW.SoLuongN <= 0 OR :NEW.DonGiaN <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Lỗi: Số lượng nhập và Đơn giá nhập phải lớn hơn 0.');
    END IF;
    UPDATE SanPham  SET SoLuong = SoLuong + :NEW.SoLuongN WHERE MaSP = :NEW.MaSP;
    
    DBMS_OUTPUT.PUT_LINE('Nhập hàng thành công. Đã cập nhật kho cho sản phẩm: ' || :NEW.MaSP);
END;
/

INSERT INTO HangSX (MaHangSX, TenHang, DiaChi, SoDT, Email)
VALUES ('H01', 'Samsung', 'Korea', '0123456789', 'ss@gmail.com');

INSERT INTO SanPham (MaSP, MaHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh)
VALUES ('SP01', 'H01', 'Galaxy S24', 10, 'Black', 20000000, 'Chiec');

INSERT INTO NhanVien (MaNV, TenNV, GioiTinh, DiaChi)
VALUES ('NV01', 'Nguyen Van A', 'Nam', 'Ha Noi');

INSERT INTO PNhap (SoHDN, NgayNhap, MaNV)
VALUES ('HDN01', SYSDATE, 'NV01');

INSERT INTO Nhap(SoHDN, MaSP, SoLuongN, DonGiaN) 
VALUES ('HDN01', 'SP01', 5, 150000);

SELECT MaSP, TenSP, SoLuong FROM SanPham WHERE MaSP = 'SP01';

CREATE OR REPLACE TRIGGER trg_xuat
BEFORE INSERT ON Xuat
FOR EACH ROW
DECLARE
    v_dem NUMBER := 0;
    v_SoLuongTon NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_dem 
    FROM SanPham 
    WHERE TRIM(MaSP) = TRIM(:NEW.MaSP);

    IF v_dem = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Lỗi: Mã sản phẩm ' || :NEW.MaSP || ' không tồn tại.');
    END IF;
    SELECT SoLuong INTO v_SoLuongTon 
    FROM SanPham 
    WHERE TRIM(MaSP) = TRIM(:NEW.MaSP);

    IF :NEW.SoLuongX > v_SoLuongTon THEN
        RAISE_APPLICATION_ERROR(-20004, 'Lỗi: Không đủ hàng! Trong kho hiện chỉ còn ' || v_SoLuongTon || ' sản phẩm.');
    END IF;
    UPDATE SanPham 
    SET SoLuong = SoLuong - :NEW.SoLuongX
    WHERE TRIM(MaSP) = TRIM(:NEW.MaSP);

    DBMS_OUTPUT.PUT_LINE('Xuất hàng thành công. Kho đã được trừ đi ' || :NEW.SoLuongX || ' sản phẩm.');
END;
/

INSERT INTO PXuat (SoHDX, NgayXuat, MaNV) VALUES ('HDX01', SYSDATE, 'NV01');
INSERT INTO Xuat(SoHDX, MaSP, SoLuongX) VALUES ('HDX01', 'SP01', 5);
SELECT MaSP, TenSP, SoLuong FROM SanPham WHERE MaSP = 'SP01';

CREATE OR REPLACE TRIGGER trg_XoaXuat
AFTER DELETE ON Xuat
FOR EACH ROW
BEGIN
    UPDATE SanPham 
    SET SoLuong = SoLuong + :OLD.SoLuongX
    WHERE TRIM(MaSP) = TRIM(:OLD.MaSP);

    DBMS_OUTPUT.PUT_LINE('Đã hủy phiếu xuất. Đã hoàn trả ' || :OLD.SoLuongX || ' sản phẩm vào kho.');
END;
/

SELECT MaSP, TenSP, SoLuong FROM SanPham WHERE MaSP = 'SP01';
SELECT * FROM Xuat WHERE SoHDX = 'HDX01' AND MaSP = 'SP01';
DELETE FROM Xuat WHERE SoHDX = 'HDX01' AND MaSP = 'SP01';

CREATE OR REPLACE PACKAGE pkg_state
AS
    g_row_count NUMBER := 0;
END pkg_state;
/

CREATE OR REPLACE TRIGGER trg_CapNhatXuat
FOR UPDATE ON Xuat
COMPOUND TRIGGER
    v_tonkho NUMBER;
    v_chenhlech NUMBER;
    BEFORE STATEMENT IS
    BEGIN
        pkg_state.g_row_count := 0;
    END BEFORE STATEMENT;
    BEFORE EACH ROW IS
    BEGIN
        pkg_state.g_row_count := pkg_state.g_row_count + 1;
        IF pkg_state.g_row_count > 1 THEN
            RAISE_APPLICATION_ERROR(-20005, 'Lỗi: Hệ thống chỉ cho phép cập nhật mỗi lần 1 bản ghi.');
        END IF;
        IF :NEW.SoLuongX <> :OLD.SoLuongX THEN
            SELECT SoLuong INTO v_tonkho FROM SanPham WHERE MaSP = :NEW.MaSP;
            v_chenhlech := :NEW.SoLuongX - :OLD.SoLuongX;
            IF v_chenhlech > v_tonkho THEN
                RAISE_APPLICATION_ERROR(-20006, 'Lỗi: Kho không đủ hàng để bù chênh lệch (Thiếu: ' || (v_chenhlech - v_tonkho) || ').');
            END IF;
            UPDATE SanPham 
            SET SoLuong = SoLuong - v_chenhlech
            WHERE MaSP = :NEW.MaSP;
        END IF;
    END BEFORE EACH ROW;

END trg_CapNhatXuat;
/

UPDATE Xuat SET SoLuongX = 7 WHERE SoHDX = 'HDX01' AND MaSP = 'SP01';
SELECT MaSP, SoLuong FROM SanPham WHERE MaSP = 'SP01';

CREATE OR REPLACE TRIGGER trg_CapNhatNhap
FOR UPDATE ON Nhap
COMPOUND TRIGGER
    v_chenhlech NUMBER;

    BEFORE STATEMENT IS
    BEGIN
        pkg_state.g_row_count := 0;
    END BEFORE STATEMENT;
    BEFORE EACH ROW IS
    BEGIN
        pkg_state.g_row_count := pkg_state.g_row_count + 1;
        IF pkg_state.g_row_count > 1 THEN
            RAISE_APPLICATION_ERROR(-20007, 'Lỗi: Không được phép cập nhật nhiều hơn 1 bản ghi nhập hàng cùng lúc.');
        END IF;
        IF :NEW.SoLuongN <> :OLD.SoLuongN THEN
            v_chenhlech := :NEW.SoLuongN - :OLD.SoLuongN;
            UPDATE SanPham 
            SET SoLuong = SoLuong + v_chenhlech
            WHERE MaSP = :NEW.MaSP;
            
            DBMS_OUTPUT.PUT_LINE('Cập nhật thành công. Chênh lệch kho: ' || v_chenhlech);
        END IF;
    END BEFORE EACH ROW;

END trg_CapNhatNhap;
/

UPDATE Nhap SET SoLuongN = 15 WHERE SoHDN = 'HDN01' AND MaSP = 'SP01';
SELECT MaSP, SoLuong FROM SanPham WHERE MaSP = 'SP01';

CREATE OR REPLACE TRIGGER trg_XoaNhap
AFTER DELETE ON Nhap
FOR EACH ROW
BEGIN
    UPDATE SanPham 
    SET SoLuong = SoLuong - :OLD.SoLuongN
    WHERE TRIM(MaSP) = TRIM(:OLD.MaSP);
    DBMS_OUTPUT.PUT_LINE('Đã xóa phiếu nhập. Đã trừ ' || :OLD.SoLuongN || ' sản phẩm khỏi bảng SanPham.');
END;
/

DELETE FROM Nhap WHERE SoHDN = 'HDN01' AND MaSP = 'SP01';
SELECT MaSP, SoLuong FROM SanPham WHERE MaSP = 'SP01';
