CREATE TABLE Phong (
    MaPhong CHAR(5) PRIMARY KEY,
    LoaiPhong NVARCHAR2(50),
    TrangThai NVARCHAR2(20) DEFAULT 'TRONG' 
        CHECK (TrangThai IN ('TRONG', 'DA_THUE', 'BAO_TRI')),
    GiaTheoGio NUMBER,
    GiaTheoNgay NUMBER,
    SoNguoiToiDa NUMBER
);

CREATE TABLE KhachHang (
    MaKH CHAR(10) PRIMARY KEY,
    HoTen NVARCHAR2(100),
    CCCD VARCHAR2(20),
    SoDT VARCHAR2(20),
    Email VARCHAR2(50),
    QuocTich NVARCHAR2(50)
);

CREATE TABLE HoaDon (
    MaHD CHAR(10) PRIMARY KEY,
    MaKH CHAR(10),
    MaPhong CHAR(5),
    NgayNhan DATE,
    NgayTra DATE,
    SoNguoi NUMBER,
    TongTien NUMBER DEFAULT 0,
    TrangThai NVARCHAR2(20) DEFAULT 'CHO_NHAN'
        CHECK (TrangThai IN ('CHO_NHAN', 'DANG_O', 'DA_TRA', 'HUY')),
    CONSTRAINT FK_HD_KhachHang FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    CONSTRAINT FK_HD_Phong FOREIGN KEY (MaPhong) REFERENCES Phong(MaPhong)
);

CREATE TABLE ChiPhiPhuThu (
    MaCP CHAR(10) PRIMARY KEY,
    MaHD CHAR(10),
    MoTa NVARCHAR2(200),
    SoTien NUMBER,
    ThoiGian TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_CP_HoaDon FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD)
);

CREATE TABLE LichSuPhong (
    MaLS CHAR(10) PRIMARY KEY,
    MaPhong CHAR(5),
    MaHD CHAR(10),
    NgayNhan DATE,
    NgayTra DATE,
    GhiChu NVARCHAR2(200),
    CONSTRAINT FK_LS_Phong FOREIGN KEY (MaPhong) REFERENCES Phong(MaPhong),
    CONSTRAINT FK_LS_HoaDon FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD)
);

CREATE OR REPLACE TRIGGER trg_DatPhong
BEFORE INSERT ON HoaDon
FOR EACH ROW
DECLARE
    v_demKH NUMBER := 0;
    v_demPhong NUMBER := 0;
    v_TrangThaiPhong NVARCHAR2(20);
    v_SoNguoiToiDa NUMBER;
    v_GiaTheoNgay NUMBER;
    v_SoNgay NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_demKH FROM KhachHang WHERE MaKH = :NEW.MaKH;
    IF v_demKH = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Lỗi: Mã khách hàng ' || :NEW.MaKH || ' không tồn tại.');
    END IF;
    SELECT COUNT(*) INTO v_demPhong FROM Phong WHERE MaPhong = :NEW.MaPhong;
    IF v_demPhong = 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'Lỗi: Mã phòng ' || :NEW.MaPhong || ' không tồn tại.');
    ELSE
        SELECT TrangThai, SoNguoiToiDa, GiaTheoNgay 
        INTO v_TrangThaiPhong, v_SoNguoiToiDa, v_GiaTheoNgay
        FROM Phong WHERE MaPhong = :NEW.MaPhong;
    END IF;
    IF v_TrangThaiPhong <> 'TRONG' THEN
        RAISE_APPLICATION_ERROR(-20012, 'Lỗi: Phòng ' || :NEW.MaPhong || ' hiện không trống (Trạng thái: ' || v_TrangThaiPhong || ').');
    END IF;
    IF :NEW.SoNguoi > v_SoNguoiToiDa THEN
        RAISE_APPLICATION_ERROR(-20013, 'Lỗi: Số người vượt quá số lượng tối đa cho phép (' || v_SoNguoiToiDa || ').');
    END IF;
    IF :NEW.NgayNhan >= :NEW.NgayTra THEN
        RAISE_APPLICATION_ERROR(-20014, 'Lỗi: Ngày nhận phải trước ngày trả.');
    END IF;
    IF :NEW.NgayNhan < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20015, 'Lỗi: Ngày nhận không được nhỏ hơn ngày hiện tại.');
    END IF;
    v_SoNgay := :NEW.NgayTra - :NEW.NgayNhan;
    IF v_SoNgay = 0 THEN v_SoNgay := 1; END IF; 
    :NEW.TongTien := v_SoNgay * v_GiaTheoNgay;
    UPDATE Phong 
    SET TrangThai = 'DA_THUE'
    WHERE MaPhong = :NEW.MaPhong;
    DBMS_OUTPUT.PUT_LINE('Đặt phòng thành công! Tổng tiền: ' || :NEW.TongTien);
END;
/


INSERT INTO Phong (MaPhong, LoaiPhong, TrangThai, GiaTheoGio, GiaTheoNgay, SoNguoiToiDa)
VALUES ('P101', 'Vip', 'TRONG', 100000, 800000, 2);

INSERT INTO KhachHang (MaKH, HoTen, CCCD, SoDT)
VALUES ('KH001', 'Tran Van B', '123456789', '0909123456');

INSERT INTO HoaDon (MaHD, MaKH, MaPhong, NgayNhan, NgayTra, SoNguoi, TrangThai)
VALUES ('HD01', 'KH001', 'P101', TRUNC(SYSDATE), TRUNC(SYSDATE) + 3, 2, 'CHO_NHAN');

SELECT MaHD, TongTien FROM HoaDon WHERE MaHD = 'HD01';
SELECT MaPhong, TrangThai FROM Phong WHERE MaPhong = 'P101';

CREATE OR REPLACE TRIGGER trg_CapNhatTrangThaiHD
BEFORE UPDATE OF TrangThai ON HoaDon
FOR EACH ROW
BEGIN
    IF :OLD.TrangThai = 'CHO_NHAN' THEN
        IF :NEW.TrangThai NOT IN ('DANG_O', 'HUY') THEN
            RAISE_APPLICATION_ERROR(-20020, 'Lỗi: Từ trạng thái Chờ nhận chỉ có thể chuyển sang Đang ở hoặc Hủy.');
        END IF;
    ELSIF :OLD.TrangThai = 'DANG_O' THEN
        IF :NEW.TrangThai <> 'DA_TRA' THEN
            RAISE_APPLICATION_ERROR(-20021, 'Lỗi: Khách đang ở chỉ có thể chuyển sang trạng thái Đã trả phòng.');
        END IF;
    ELSIF :OLD.TrangThai IN ('DA_TRA', 'HUY') THEN
        RAISE_APPLICATION_ERROR(-20022, 'Lỗi: Hóa đơn đã kết thúc (Đã trả hoặc Đã hủy), không thể thay đổi trạng thái nữa.');
    END IF;
    IF :NEW.TrangThai = 'DA_TRA' THEN
        UPDATE Phong SET TrangThai = 'TRONG' WHERE MaPhong = :OLD.MaPhong;
        
        INSERT INTO LichSuPhong (MaLS, MaPhong, MaHD, NgayNhan, NgayTra, GhiChu)
        VALUES ('LS' || TO_CHAR(SYSDATE, 'SSSSS'), :OLD.MaPhong, :OLD.MaHD, :OLD.NgayNhan, SYSDATE, 'Khách trả phòng đúng hạn');
    ELSIF :NEW.TrangThai = 'HUY' THEN
        UPDATE Phong SET TrangThai = 'TRONG' WHERE MaPhong = :OLD.MaPhong;
    END IF;
END;
/

CREATE OR REPLACE VIEW vw_HoaDon_Active AS
SELECT * FROM HoaDon WHERE TrangThai IN ('CHO_NHAN', 'DANG_O');

CREATE OR REPLACE TRIGGER trg_vwHoaDonActive_upd
INSTEAD OF UPDATE ON vw_HoaDon_Active
FOR EACH ROW
BEGIN
    UPDATE HoaDon
    SET TrangThai = :NEW.TrangThai
    WHERE MaHD = :OLD.MaHD;
    
    DBMS_OUTPUT.PUT_LINE('Đã cập nhật trạng thái cho hóa đơn: ' || :OLD.MaHD);
END;
/

UPDATE HoaDon SET TrangThai = 'DANG_O' WHERE MaHD = 'HD01';
UPDATE HoaDon SET TrangThai = 'HUY' WHERE MaHD = 'HD01';
SELECT * FROM LichSuPhong;
SELECT MaPhong, TrangThai FROM Phong WHERE MaPhong = (SELECT MaPhong FROM HoaDon WHERE MaHD = 'HD01');


CREATE OR REPLACE TRIGGER trg_SuaChiPhi
FOR INSERT OR UPDATE ON ChiPhiPhuThu
COMPOUND TRIGGER
    TYPE t_mahd_list IS TABLE OF NUMBER INDEX BY VARCHAR2(10);
    v_mahd_list t_mahd_list;
    v_row_count NUMBER := 0;
    BEFORE STATEMENT IS
    BEGIN
        v_row_count := 0;
        v_mahd_list.DELETE;
    END BEFORE STATEMENT;
    BEFORE EACH ROW IS
    BEGIN
        v_row_count := v_row_count + 1;
        IF v_row_count > 5 THEN
            RAISE_APPLICATION_ERROR(-20030, 'Lỗi: Không được thêm/sửa quá 5 chi phí trong một lần.');
        END IF;
        IF :NEW.SoTien <= 0 OR :NEW.SoTien >= 50000000 THEN
            RAISE_APPLICATION_ERROR(-20031, 'Lỗi: Số tiền phải > 0 và < 50,000,000 VNĐ.');
        END IF;
        v_mahd_list(:NEW.MaHD) := 1;
        IF UPDATING AND :OLD.MaHD <> :NEW.MaHD THEN
            v_mahd_list(:OLD.MaHD) := 1;
        END IF;
    END BEFORE EACH ROW;
    AFTER STATEMENT IS
    v_mahd VARCHAR2(10);
    v_tien_phong NUMBER;
    v_tien_phu_thu NUMBER;
    BEGIN
        v_mahd := v_mahd_list.FIRST;
        WHILE v_mahd IS NOT NULL LOOP
            SELECT (NgayTra - NgayNhan) * (SELECT GiaTheoNgay FROM Phong p WHERE p.MaPhong = h.MaPhong)
            INTO v_tien_phong
            FROM HoaDon h WHERE h.MaHD = v_mahd;
            SELECT NVL(SUM(SoTien), 0) INTO v_tien_phu_thu
            FROM ChiPhiPhuThu WHERE MaHD = v_mahd;
            UPDATE HoaDon 
            SET TongTien = v_tien_phong + v_tien_phu_thu
            WHERE MaHD = v_mahd;
            v_mahd := v_mahd_list.NEXT(v_mahd);
        END LOOP;
    END AFTER STATEMENT;

END trg_SuaChiPhi;
/

INSERT INTO ChiPhiPhuThu (MaCP, MaHD, MoTa, SoTien)
VALUES ('CP01', 'HD01', 'Nuoc uong mini bar', 50000);
SELECT MaHD, TongTien FROM HoaDon WHERE MaHD = 'HD01';


CREATE SEQUENCE SEQ_HD
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE OR REPLACE VIEW vw_PhongTrong AS
SELECT 
    MaPhong, 
    LoaiPhong, 
    GiaTheoNgay,
    CAST(NULL AS CHAR(10)) AS MaKH_Booking, 
    CAST(NULL AS DATE) AS NgayNhan_Booking, 
    CAST(NULL AS DATE) AS NgayTra_Booking,  
    0 AS SoNguoi_Booking                  
FROM Phong 
WHERE TrangThai = 'TRONG';

CREATE OR REPLACE TRIGGER trg_vwPhongTrong_ins
INSTEAD OF INSERT ON vw_PhongTrong
FOR EACH ROW
DECLARE
    v_MaHD VARCHAR2(10);
BEGIN
    v_MaHD := 'HD' || TO_CHAR(SEQ_HD.NEXTVAL, 'FM0000');
    INSERT INTO HoaDon (
        MaHD, 
        MaKH, 
        MaPhong, 
        NgayNhan, 
        NgayTra, 
        SoNguoi, 
        TrangThai
    )
    VALUES (
        v_MaHD, 
        :NEW.MaKH_Booking, 
        :NEW.MaPhong, 
        :NEW.NgayNhan_Booking, 
        :NEW.NgayTra_Booking, 
        :NEW.SoNguoi_Booking, 
        'CHO_NHAN'
    );
    DBMS_OUTPUT.PUT_LINE('Hệ thống đã tự động tạo hóa đơn: ' || v_MaHD);
END;
/

INSERT INTO vw_PhongTrong (MaPhong, MaKH_Booking, NgayNhan_Booking, NgayTra_Booking, SoNguoi_Booking)
VALUES ('P101', 'KH001', TO_DATE('2026-04-01', 'YYYY-MM-DD'), TO_DATE('2026-04-05', 'YYYY-MM-DD'), 2);
SELECT * FROM HoaDon WHERE MaPhong = 'P101';