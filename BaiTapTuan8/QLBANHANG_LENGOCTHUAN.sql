CREATE TABLE hangsx (
    mahangsx VARCHAR2(10) CONSTRAINT pk_hangsx PRIMARY KEY,
    tenhang  VARCHAR2(30) NOT NULL,
    diachi   VARCHAR2(50),
    sodt     VARCHAR2(15),
    email    VARCHAR2(50)
);

CREATE TABLE sanpham (
    masp      VARCHAR2(10) CONSTRAINT pk_sanpham PRIMARY KEY,
    mahangsx  VARCHAR2(10) REFERENCES hangsx ( mahangsx ),
    tensp     VARCHAR2(50) NOT NULL,
    soluong   NUMBER(10),
    mausac    VARCHAR2(20),
    giaban    NUMBER(15, 2),
    donvitinh VARCHAR2(15),
    mota      CLOB
);

CREATE TABLE nhanvien (
    manv     VARCHAR2(10) CONSTRAINT pk_nhanvien PRIMARY KEY,
    tennv    VARCHAR2(50) NOT NULL,
    gioitinh VARCHAR2(10),
    diachi   VARCHAR2(100),
    sodt     VARCHAR2(15),
    email    VARCHAR2(50),
    tenphong VARCHAR2(30)
);

CREATE TABLE pnhap (
    sohdn    VARCHAR2(10) CONSTRAINT pk_pnhap PRIMARY KEY,
    ngaynhap DATE,
    manv     VARCHAR2(10) REFERENCES nhanvien ( manv )
);

CREATE TABLE nhap (
    sohdn    VARCHAR2(10) REFERENCES pnhap ( sohdn ),
    masp     VARCHAR2(10) REFERENCES sanpham ( masp ),
    soluongn NUMBER(10),
    dongian  NUMBER(15, 2),
    CONSTRAINT pk_nhap PRIMARY KEY ( sohdn, masp )
);

CREATE TABLE pxuat (
    sohdx    VARCHAR2(10) CONSTRAINT pk_pxuat PRIMARY KEY,
    ngayxuat DATE,
    manv     VARCHAR2(10) REFERENCES nhanvien ( manv )
);

CREATE TABLE xuat (
    sohdx    VARCHAR2(10) REFERENCES pxuat ( sohdx ),
    masp     VARCHAR2(10) REFERENCES sanpham ( masp ),
    soluongx NUMBER(10), CONSTRAINT pk_xuat PRIMARY KEY ( sohdx, masp )
);

CREATE OR REPLACE PROCEDURE sp_NhapHangSX (
    p_MaHangSX VARCHAR2, 
    p_TenHang VARCHAR2, 
    p_DiaChi VARCHAR2, 
    p_SoDT VARCHAR2, 
    p_Email VARCHAR2
) AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM HangSX WHERE TenHang = p_TenHang; 
    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Thông báo: Tên hãng sản xuất đã tồn tại.');
    ELSE
        INSERT INTO HangSX (MaHangSX, TenHang, DiaChi, SoDT, Email)
        VALUES (p_MaHangSX, p_TenHang, p_DiaChi, p_SoDT, p_Email);
        COMMIT;
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE sp_NhapSP (
    p_MaSP VARCHAR2, 
    p_TenHang VARCHAR2, 
    p_TenSP VARCHAR2, 
    p_SoLuong NUMBER, 
    p_MauSac VARCHAR2, 
    p_GiaBan NUMBER, 
    p_DonViTinh VARCHAR2, 
    p_MoTa CLOB
) AS
    v_MaHangSX VARCHAR2(10);
    v_count_sp NUMBER;
BEGIN
    BEGIN
        SELECT MaHangSX INTO v_MaHangSX 
        FROM HangSX 
        WHERE TenHang = p_TenHang;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Thông báo: Tên hãng không có trong bảng HangSX'); 
            RETURN;
    END;
    SELECT COUNT(*) INTO v_count_sp 
    FROM SanPham 
    WHERE MaSP = p_MaSP;
    IF v_count_sp > 0 THEN
        UPDATE SanPham 
        SET MaHangSX = v_MaHangSX, 
            TenSP = p_TenSP, 
            SoLuong = p_SoLuong, 
            MauSac = p_MauSac, 
            GiaBan = p_GiaBan, 
            DonViTinh = p_DonViTinh, 
            MoTa = p_MoTa
        WHERE MaSP = p_MaSP; 
        DBMS_OUTPUT.PUT_LINE('Đã cập nhật thông tin sản phẩm: ' || p_MaSP);
    ELSE
        INSERT INTO SanPham (MaSP, MaHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa)
        VALUES (p_MaSP, v_MaHangSX, p_TenSP, p_SoLuong, p_MauSac, p_GiaBan, p_DonViTinh, p_MoTa);
        DBMS_OUTPUT.PUT_LINE('Đã thêm mới sản phẩm: ' || p_MaSP);
    END IF;
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE sp_xoaHangSX (
    p_tenhang VARCHAR2
) AS
    v_mahangsx VARCHAR2(10);
BEGIN
    SELECT MaHangSX INTO v_mahangsx 
    FROM HangSX 
    WHERE TenHang = p_tenhang;
    DELETE FROM SanPham 
    WHERE MaHangSX = v_mahangsx; 
    DELETE FROM HangSX 
    WHERE MaHangSX = v_mahangsx;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Đã xóa thành công hãng sản xuất và các sản phẩm liên quan.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Thông báo: Tên hãng ' || p_tenhang || ' không tồn tại.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: ' || SQLERRM);
END sp_xoaHangSX;
/

CREATE OR REPLACE PROCEDURE sp_NhapNhanVien (
    p_MaNV VARCHAR2,
    p_TenNV VARCHAR2,
    p_GioiTinh VARCHAR2,
    p_DiaChi VARCHAR2,
    p_SoDT VARCHAR2,
    p_Email VARCHAR2,
    p_TenPhong VARCHAR2,
    p_Flag NUMBER
) AS
BEGIN
    IF p_Flag = 0 THEN
        UPDATE NhanVien 
        SET TenNV = p_TenNV, 
            GioiTinh = p_GioiTinh, 
            DiaChi = p_DiaChi, 
            SoDT = p_SoDT, 
            Email = p_Email, 
            TenPhong = p_TenPhong
        WHERE MaNV = p_MaNV;
        DBMS_OUTPUT.PUT_LINE('Thông báo: Đã cập nhật thông tin nhân viên ' || p_MaNV);
    ELSE
        INSERT INTO NhanVien (MaNV, TenNV, GioiTinh, DiaChi, SoDT, Email, TenPhong)
        VALUES (p_MaNV, p_TenNV, p_GioiTinh, p_DiaChi, p_SoDT, p_Email, p_TenPhong);
        DBMS_OUTPUT.PUT_LINE('Thông báo: Đã thêm mới nhân viên ' || p_MaNV);
    END IF;
    COMMIT;
END sp_NhapNhanVien;
/

CREATE OR REPLACE PROCEDURE sp_NhapLieuNhap (
    p_SoHDN VARCHAR2,
    p_MaSP VARCHAR2,
    p_MaNV VARCHAR2,
    p_NgayNhap DATE,
    p_SoLuongN NUMBER,
    p_DonGiaN NUMBER
) AS
    v_check_sp NUMBER;
    v_check_nv NUMBER;
    v_check_hd NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_check_sp FROM SanPham WHERE MaSP = p_MaSP;
    IF v_check_sp = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Thông báo: Mã sản phẩm ' || p_MaSP || ' không tồn tại.');
        RETURN;
    END IF;
    SELECT COUNT(*) INTO v_check_nv FROM NhanVien WHERE MaNV = p_MaNV;
    IF v_check_nv = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Thông báo: Mã nhân viên ' || p_MaNV || ' không tồn tại.');
        RETURN;
    END IF;
    SELECT COUNT(*) INTO v_check_hd FROM PNhap WHERE SoHDN = p_SoHDN;
    IF v_check_hd > 0 THEN
        UPDATE Nhap 
        SET SoLuongN = p_SoLuongN, 
            DonGiaN = p_DonGiaN 
        WHERE SoHDN = p_SoHDN AND MaSP = p_MaSP;
        DBMS_OUTPUT.PUT_LINE('Thông báo: Đã cập nhật chi tiết nhập cho hóa đơn ' || p_SoHDN);
    ELSE
        INSERT INTO PNhap (SoHDN, NgayNhap, MaNV) 
        VALUES (p_SoHDN, p_NgayNhap, p_MaNV);
        INSERT INTO Nhap (SoHDN, MaSP, SoLuongN, DonGiaN) 
        VALUES (p_SoHDN, p_MaSP, p_SoLuongN, p_DonGiaN);
        DBMS_OUTPUT.PUT_LINE('Thông báo: Đã thêm mới hóa đơn ' || p_SoHDN);
    END IF;
    COMMIT;
END sp_NhapLieuNhap;
/

CREATE OR REPLACE PROCEDURE sp_NhapLieuXuat (
    p_SoHDX VARCHAR2,
    p_MaSP VARCHAR2,
    p_MaNV VARCHAR2,
    p_NgayXuat DATE,
    p_SoLuongX NUMBER
) AS
    v_tonkho NUMBER;
    v_check_sp NUMBER;
    v_check_nv NUMBER;
    v_check_hd NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_check_sp FROM SanPham WHERE MaSP = p_MaSP;
    IF v_check_sp = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Thông báo: Mã sản phẩm ' || p_MaSP || ' không tồn tại.');
        RETURN;
    END IF;
    SELECT COUNT(*) INTO v_check_nv FROM NhanVien WHERE MaNV = p_MaNV;
    IF v_check_nv = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Thông báo: Mã nhân viên ' || p_MaNV || ' không tồn tại.');
        RETURN;
    END IF;
    SELECT SoLuong INTO v_tonkho FROM SanPham WHERE MaSP = p_MaSP;
    IF p_SoLuongX > v_tonkho THEN
        DBMS_OUTPUT.PUT_LINE('Thông báo: Số lượng xuất vượt quá tồn kho (Hiện có: ' || v_tonkho || ').');
        RETURN;
    END IF;
    SELECT COUNT(*) INTO v_check_hd FROM PXuat WHERE SoHDX = p_SoHDX;
    IF v_check_hd > 0 THEN
        UPDATE Xuat 
        SET SoLuongX = p_SoLuongX 
        WHERE SoHDX = p_SoHDX AND MaSP = p_MaSP;
        DBMS_OUTPUT.PUT_LINE('Thông báo: Đã cập nhật chi tiết xuất cho hóa đơn ' || p_SoHDX);
    ELSE
        INSERT INTO PXuat (SoHDX, NgayXuat, MaNV) 
        VALUES (p_SoHDX, p_NgayXuat, p_MaNV);
        INSERT INTO Xuat (SoHDX, MaSP, SoLuongX) 
        VALUES (p_SoHDX, p_MaSP, p_SoLuongX);
        DBMS_OUTPUT.PUT_LINE('Thông báo: Đã thêm mới hóa đơn xuất ' || p_SoHDX);
    END IF;
    COMMIT;
END sp_NhapLieuXuat;
/

CREATE OR REPLACE PROCEDURE sp_XoaNhanVien (
    p_MaNV VARCHAR2
) AS
    v_count NUMBER;
BEGIN 
    SELECT COUNT(*) INTO v_count FROM NhanVien WHERE MaNV = p_MaNV;
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Thông báo: Mã nhân viên ' || p_MaNV || ' không tồn tại.');
        RETURN;
    END IF;
    DELETE FROM Nhap WHERE SoHDN IN (SELECT SoHDN FROM PNhap WHERE MaNV = p_MaNV);

    DELETE FROM PNhap WHERE MaNV = p_MaNV;
    DELETE FROM Xuat WHERE SoHDX IN (SELECT SoHDX FROM PXuat WHERE MaNV = p_MaNV);
    DELETE FROM PXuat WHERE MaNV = p_MaNV;
    DELETE FROM NhanVien WHERE MaNV = p_MaNV; 
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Đã xóa thành công nhân viên ' || p_MaNV || ' và các dữ liệu liên quan.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Lỗi trong quá trình xóa: ' || SQLERRM);
END sp_XoaNhanVien;
/

CREATE OR REPLACE PROCEDURE sp_XoaSanPham (
    p_MaSP VARCHAR2
) AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM SanPham WHERE MaSP = p_MaSP;
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Thông báo: Mã sản phẩm ' || p_MaSP || ' không tồn tại.');
        RETURN;
    END IF;
    DELETE FROM Nhap WHERE MaSP = p_MaSP;
    DELETE FROM Xuat WHERE MaSP = p_MaSP;
    DELETE FROM SanPham WHERE MaSP = p_MaSP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Đã xóa thành công sản phẩm ' || p_MaSP || ' và các dữ liệu liên quan.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Lỗi trong quá trình xóa sản phẩm: ' || SQLERRM);
END sp_XoaSanPham;
/

CREATE OR REPLACE PROCEDURE sp_ThemNhanVien (
    p_MaNV VARCHAR2,
    p_TenNV VARCHAR2,
    p_GioiTinh VARCHAR2,
    p_DiaChi VARCHAR2,
    p_SoDT VARCHAR2,
    p_Email VARCHAR2,
    p_TenPhong VARCHAR2,
    p_Flag NUMBER,
    p_KQ OUT NUMBER
) AS
BEGIN
    IF p_GioiTinh <> 'Nam' AND p_GioiTinh <> 'Nữ' THEN
        p_KQ := 1;
        RETURN;
    END IF;
    IF p_Flag = 0 THEN
        INSERT INTO NhanVien (MaNV, TenNV, GioiTinh, DiaChi, SoDT, Email, TenPhong)
        VALUES (p_MaNV, p_TenNV, p_GioiTinh, p_DiaChi, p_SoDT, p_Email, p_TenPhong);
    ELSE
        UPDATE NhanVien
        SET TenNV = p_TenNV,
            GioiTinh = p_GioiTinh,
            DiaChi = p_DiaChi,
            SoDT = p_SoDT,
            Email = p_Email,
            TenPhong = p_TenPhong
        WHERE MaNV = p_MaNV;
    END IF;
    p_KQ := 0;
    COMMIT; 
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_KQ := -1;
END sp_ThemNhanVien;
/

CREATE OR REPLACE PROCEDURE sp_ThemMoiSP (
    p_MaSP VARCHAR2,
    p_TenHang VARCHAR2,
    p_TenSP VARCHAR2,
    p_SoLuong NUMBER,
    p_MauSac VARCHAR2,
    p_GiaBan NUMBER,
    p_DonViTinh VARCHAR2,
    p_MoTa CLOB,
    p_Flag NUMBER,
    p_KQ OUT NUMBER
) AS
    v_MaHangSX VARCHAR2(10);
BEGIN
    BEGIN
        SELECT MaHangSX INTO v_MaHangSX 
        FROM HangSX 
        WHERE TenHang = p_TenHang;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_KQ := 1; 
            RETURN;
    END;
    IF p_SoLuong < 0 THEN
        p_KQ := 2;
        RETURN;
    END IF;
    IF p_Flag = 0 THEN
        INSERT INTO SanPham (MaSP, MaHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa)
        VALUES (p_MaSP, v_MaHangSX, p_TenSP, p_SoLuong, p_MauSac, p_GiaBan, p_DonViTinh, p_MoTa);
    ELSE
        UPDATE SanPham 
        SET MaHangSX = v_MaHangSX,
            TenSP = p_TenSP,
            SoLuong = p_SoLuong,
            MauSac = p_MauSac,
            GiaBan = p_GiaBan,
            DonViTinh = p_DonViTinh,
            MoTa = p_MoTa
        WHERE MaSP = p_MaSP;
    END IF;
    p_KQ := 0;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_KQ := -1;
END sp_ThemMoiSP;
/


CREATE OR REPLACE PROCEDURE sp_XoaNhanVien_Out (
    p_MaNV VARCHAR2,
    p_KQ OUT NUMBER 
) AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM NhanVien WHERE MaNV = p_MaNV;
    IF v_count = 0 THEN 
        p_KQ := 1;
        RETURN;
    END IF;
    DELETE FROM Nhap WHERE SoHDN IN (SELECT SoHDN FROM PNhap WHERE MaNV = p_MaNV);
    DELETE FROM PNhap WHERE MaNV = p_MaNV;
    DELETE FROM Xuat WHERE SoHDX IN (SELECT SoHDX FROM PXuat WHERE MaNV = p_MaNV);
    DELETE FROM PXuat WHERE MaNV = p_MaNV;
    DELETE FROM NhanVien WHERE MaNV = p_MaNV;
    p_KQ := 0;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_KQ := -1;
END sp_XoaNhanVien_Out;
/


CREATE OR REPLACE PROCEDURE sp_XoaSanPham_Out (
    p_MaSP VARCHAR2,
    p_KQ OUT NUMBER
) AS
    v_count NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_count FROM SanPham WHERE MaSP = p_MaSP;
    IF v_count = 0 THEN
        p_KQ := 1; 
        RETURN;
    END IF;
    DELETE FROM Nhap WHERE MaSP = p_MaSP;
    DELETE FROM Xuat WHERE MaSP = p_MaSP; 
    DELETE FROM SanPham WHERE MaSP = p_MaSP;
    p_KQ := 0; 
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK; 
        p_KQ := -1; 
END sp_XoaSanPham_Out;
/


CREATE OR REPLACE PROCEDURE sp_NhapHangSX (
    p_MaHangSX VARCHAR2,
    p_TenHang VARCHAR2,
    p_DiaChi VARCHAR2,
    p_SoDT VARCHAR2,
    p_Email VARCHAR2,
    p_KQ OUT NUMBER
) AS
    v_count NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_count 
    FROM HangSX 
    WHERE TenHang = p_TenHang; 
    IF v_count > 0 THEN
        p_KQ := 1;
        RETURN;
    ELSE
        INSERT INTO HangSX (MaHangSX, TenHang, DiaChi, SoDT, Email)
        VALUES (p_MaHangSX, p_TenHang, p_DiaChi, p_SoDT, p_Email);
        p_KQ := 0;
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_KQ := -1;
END sp_NhapHangSX;
/


CREATE OR REPLACE PROCEDURE sp_NhapBangNhap_Out (
    p_SoHDN VARCHAR2,
    p_MaSP VARCHAR2,
    p_MaNV VARCHAR2,
    p_NgayNhap DATE,
    p_SoLuongN NUMBER,
    p_DonGiaN NUMBER,
    p_KQ OUT NUMBER
) AS
    v_count_sp NUMBER;
    v_count_nv NUMBER;
    v_count_hd NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count_sp FROM SanPham WHERE MaSP = p_MaSP;
    IF v_count_sp = 0 THEN
        p_KQ := 1;
        RETURN;
    END IF;
    SELECT COUNT(*) INTO v_count_nv FROM NhanVien WHERE MaNV = p_MaNV;
    IF v_count_nv = 0 THEN
        p_KQ := 2;
        RETURN;
    END IF;
    SELECT COUNT(*) INTO v_count_hd FROM PNhap WHERE SoHDN = p_SoHDN; 
    IF v_count_hd > 0 THEN
        UPDATE Nhap 
        SET SoLuongN = p_SoLuongN, 
            DonGiaN = p_DonGiaN 
        WHERE SoHDN = p_SoHDN AND MaSP = p_MaSP; 
    ELSE
        INSERT INTO PNhap (SoHDN, NgayNhap, MaNV) 
        VALUES (p_SoHDN, p_NgayNhap, p_MaNV);
        INSERT INTO Nhap (SoHDN, MaSP, SoLuongN, DonGiaN) 
        VALUES (p_SoHDN, p_MaSP, p_SoLuongN, p_DonGiaN);
    END IF;
    p_KQ := 0;
    COMMIT; 
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_KQ := -1;
END sp_NhapBangNhap_Out;
/


CREATE OR REPLACE PROCEDURE sp_NhapBangXuat_Out (
    p_SoHDX VARCHAR2,
    p_MaSP VARCHAR2,
    p_MaNV VARCHAR2,
    p_NgayXuat DATE,
    p_SoLuongX NUMBER,
    p_KQ OUT NUMBER
) AS
    v_count_sp NUMBER;
    v_count_nv NUMBER;
    v_count_hd NUMBER;
    v_soluong_ton NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count_sp FROM SanPham WHERE MaSP = p_MaSP; 
    IF v_count_sp = 0 THEN
        p_KQ := 1; 
        RETURN;  
    END IF;
    SELECT COUNT(*) INTO v_count_nv FROM NhanVien WHERE MaNV = p_MaNV; 
    IF v_count_nv = 0 THEN
        p_KQ := 2;
        RETURN;
    END IF;
    SELECT SoLuong INTO v_soluong_ton FROM SanPham WHERE MaSP = p_MaSP;
    IF p_SoLuongX > v_soluong_ton THEN
        p_KQ := 3;
        RETURN;
    END IF;
    SELECT COUNT(*) INTO v_count_hd FROM PXuat WHERE SoHDX = p_SoHDX;
    IF v_count_hd > 0 THEN
        UPDATE Xuat 
        SET SoLuongX = p_SoLuongX 
        WHERE SoHDX = p_SoHDX AND MaSP = p_MaSP;
    ELSE
        INSERT INTO PXuat (SoHDX, NgayXuat, MaNV) 
        VALUES (p_SoHDX, p_NgayXuat, p_MaNV);
        INSERT INTO Xuat (SoHDX, MaSP, SoLuongX) 
        VALUES (p_SoHDX, p_MaSP, p_SoLuongX);
    END IF;
    p_KQ := 0;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_KQ := -1; 
END sp_NhapBangXuat_Out;
/