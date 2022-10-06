USE QLSV
GO
--QUERY
--4.1
SELECT * 
FROM SinhVien sv 
WHERE sv.ma in 
(SELECT sv2.ma 
FROM (SinhVien sv2 join Lop l on l.ma = sv2.maLop) join Khoa k on k.ma = l.maKhoa, KhoaHoc kh 
WHERE k.tenKhoa = N'Công nghệ thông tin' and kh.namBatDau = '2002' and kh.namKetThuc = '2006')

--4.2
SELECT sv.ma, sv.hoTen, sv.namSinh 
FROM SinhVien sv join lop l on l.ma = sv.maLop join KhoaHoc kh on kh.ma = l.maKhoaHoc
WHERE (kh.namBatDau - sv.namSinh) < 18

--4.3
SELECT * 
FROM SinhVien sv join lop l on l.ma = sv.maLop
WHERE l.maKhoa = 'CNTT' and l.maKhoaHoc = 'K2002' and N'Cấu trúc dữ liệu 1' not in 
(SELECT mh.tenMonHoc 
FROM MonHoc mh join KetQua kq on kq.maMonHoc = mh.ma 
WHERE kq.maSinhVien = sv.ma)

--4.4
SELECT * 
FROM SinhVien sv join KetQua kq on kq.maSinhVien = sv.ma join MonHoc mh on mh.ma = kq.maMonHoc
WHERE kq.diem < 5 and 1 = ALL(SELECT kq2.lanThi FROM KetQua kq2 WHERE kq2.maSinhVien = sv.ma) and mh.tenMonHoc = N'Cấu trúc dữ liệu 1'

--4.5
SELECT l.ma, l.maKhoaHoc, ct.tenChuongTrinh, COUNT(sv.ma) as N'Số sinh viên của lớp'
FROM Lop l join ChuongTrinh ct on ct.ma = l.maChuongTrinh join SinhVien sv on sv.maLop = l.ma
GROUP BY l.ma, l.maKhoa, l.maKhoaHoc, ct.tenChuongTrinh
HAVING l.maKhoa = 'CNTT'

--4.6
SELECT AVG(kq.diem) as N'Điểm trung bình' 
FROM SinhVien sv join KetQua kq on kq.maSinhVien = sv.ma
WHERE kq.lanThi >= ALL(SELECT kq2.lanThi FROM KetQua kq2 WHERE kq2.maSinhVien = sv.ma and kq2.maMonHoc = kq.maMonHoc) and sv.ma = '0212003'

--CREATE FUNCTION
--5.1 
CREATE FUNCTION dbo.F_KTSINHVIEN (@MSSV VARCHAR(7), @MAKHOA VARCHAR(10))
RETURNS VARCHAR(10)
AS
BEGIN
    IF (EXISTS(SELECT * 
        FROM SinhVien sv join Lop l on l.ma = sv.maLop 
        WHERE sv.ma = @MSSV and l.maKhoa = @MAKHOA))
    BEGIN
        RETURN N'Đúng'
    END
RETURN N'Sai'
END

--5.2
CREATE FUNCTION dbo.F_DTSINHVIEN(@MSSV VARCHAR(7), @MAMH VARCHAR(10))
RETURNS FLOAT
AS
BEGIN
RETURN (SELECT kq.diem 
        FROM SinhVien sv, KetQua kq 
        WHERE kq.maSinhVien = sv.ma and sv.ma = @MSSV and kq.maMonHoc = @MAMH
            and kq.lanThi >= ALL(
                SELECT kq2.lanThi 
                FROM KetQua kq2 
                WHERE kq2.maSinhVien = sv.ma and kq2.maMonHoc = kq.maMonHoc))
END

--5.3
CREATE FUNCTION dbo.F_DTBSINHVIEN(@MSSV VARCHAR(7))
RETURNS FLOAT
AS
BEGIN
    RETURN(SELECT AVG(dbo.F_DTSINHVIEN(@MSSV, Temp.maMonHoc)) 
            FROM (
                SELECT DISTINCT kq.maMonHoc
                FROM KetQua kq) as Temp)
END

--5.4
CREATE FUNCTION dbo.F_LTMONHOC(@MSSV VARCHAR(7), @MAMH VARCHAR(10))
RETURNS TABLE
AS
    RETURN(SELECT kq.diem, kq.lanThi 
            FROM KetQua kq 
            WHERE kq.maMonHoc = @MAMH and kq.maSinhVien = @MSSV)

--5.5
CREATE FUNCTION dbo.F_DSMONHOC(@MSSV VARCHAR(7))
RETURNS TABLE
AS
    RETURN(SELECT mh.ma, mh.tenMonHoc 
            FROM SinhVien sv, Lop l, MonHoc mh 
            WHERE l.ma = sv.maLop and l.maKhoa = mh.maKhoa and sv.ma = @MSSV)

--Stored Procedure
--6.1
CREATE PROCEDURE SP_DSSINHVIEN
    @MALOP VARCHAR(10)
AS
    SELECT * 
    FROM SinhVien sv 
    WHERE sv.maLop = @MALOP
GO

--6.2
CREATE PROCEDURE SP_SSSINHVIEN
    @SV1 VARCHAR(10),
    @SV2 VARCHAR(10),
    @MAMH VARCHAR(10)
AS
    DECLARE @DIEM1 FLOAT = (SELECT kq.diem 
                            FROM KetQua kq
                            WHERE kq.lanThi = 1 and kq.maMonHoc = @MAMH and kq.maSinhVien = @SV1)
    DECLARE @DIEM2 FLOAT = (SELECT kq.diem
                            FROM KetQua kq
                            WHERE kq.lanThi = 1 and kq.maMonHoc = @MAMH and kq.maSinhVien = @SV2)
    IF (@DIEM1 > @DIEM2)
    BEGIN
        PRINT N'Sinh viên ' + @SV1 + N' điểm môn ' + @MAMH + N' cao hơn sinh viên ' + @SV2 + '.'
    END
    ELSE IF (@DIEM2 > @DIEM1)
    BEGIN
        PRINT N'Sinh viên ' + @SV2 + N' điểm môn ' + @MAMH + N' cao hơn sinh viên ' + @SV1 + '.'
    END
    ELSE
    BEGIN
        PRINT N'Điểm hai sinh viên bằng nhau.'
    END
GO

--6.3
CREATE PROCEDURE SP_KTSVDAU
    @MASV VARCHAR(10),
    @MAMH VARCHAR(10)
AS
    DECLARE @DIEM FLOAT = (SELECT kq.diem
                            FROM KetQua kq
                            WHERE kq.maSinhVien = @MASV and kq.maMonHoc = @MAMH and kq.lanThi = 1)
    IF(@DIEM >= 5)
    BEGIN
        PRINT N'Đậu.'
    END
    ELSE
    BEGIN
        PRINT N'Không đậu.'
    END
GO

--6.4
CREATE PROCEDURE SP_KDSSINHVIEN
    @MAKHOA VARCHAR(10)
AS
    SELECT sv.ma, sv.hoTen, sv.namSinh 
    FROM SinhVien sv, Lop l, Khoa k
    WHERE sv.maLop = l.ma and k.ma = l.maKhoa and k.ma = @MAKHOA
GO

--6.5
ALTER PROCEDURE SP_DLTSINHVIEN
    @MSSV VARCHAR(10),
    @MAMH VARCHAR(10)
AS
    DECLARE @COUNT INT = 1
    WHILE EXISTS (SELECT COUNT(*) 
    FROM KetQua kq
    WHERE kq.maSinhVien = @MSSV and kq.maMonHoc = @MAMH and kq.lanThi = @COUNT)
    BEGIN
        DECLARE @LANTHI CHAR = CONVERT(CHAR, (SELECT kq.lanThi FROM KetQua kq
                                WHERE kq.maSinhVien = @MSSV and kq.maMonHoc = @MAMH and kq.lanThi = @COUNT))
        DECLARE @DIEMTHI VARCHAR(MAX) = CONVERT(VARCHAR(MAX),(SELECT kq.diem FROM KetQua kq
                                WHERE kq.maSinhVien = @MSSV and kq.maMonHoc = @MAMH and kq.lanThi = @COUNT))
        PRINT N'Lần ' + @LANTHI + ': ' + @DIEMTHI
        SET @COUNT = @COUNT + 1
    END
GO

--6.6
CREATE PROCEDURE SP_MHSINHVIEN
    @MSSV VARCHAR(10)
AS
    SELECT * 
    FROM MonHoc mh 
    WHERE mh.maKhoa = (SELECT l.maKhoa 
                        FROM SinhVien sv, Lop l
                        WHERE sv.ma = @MSSV and l.ma = sv.maLop)
GO

--6.7
CREATE PROCEDURE SP_SVDAUMHLANDAU
    @MAMH VARCHAR(10)
AS
    SELECT *
    FROM SinhVien sv
    WHERE sv.ma in (SELECT kq.maSinhVien 
                    FROM KetQua kq
                    WHERE kq.maMonHoc = @MAMH and kq.diem >= 5 and kq.lanThi = 1)

GO

--6.8
--6.8.1
CREATE PROCEDURE SP_MONHOC681
    @MSSV VARCHAR(10)
AS
    SELECT * 
    FROM KetQua kq 
    WHERE kq.maSinhVien = @MSSV and kq.lanThi >= ALL(
        SELECT kq2.lanThi 
        FROM KetQua kq2 
        WHERE kq2.maSinhVien = @MSSV and kq.maMonHoc = kq2.maMonHoc
    )
GO

--6.8.2
CREATE PROCEDURE SP_MONHOC682
    @MSSV VARCHAR(10)
AS
    SELECT sv.ma, mh.ma, dbo.F_DTSINHVIEN(@MSSV, mh.ma) AS N'Điểm thi'
    FROM (SinhVien sv 
    join lop l on sv.maLop = l.ma
    join MonHoc mh on mh.maKhoa = l.maKhoa)
    WHERE sv.ma = @MSSV
GO

--6.8.3
CREATE PROCEDURE SP_MONHOC683
    @MSSV VARCHAR(10)
AS
    SELECT sv.ma, mh.ma, 
    CASE 
        WHEN CONVERT(varchar(MAX), dbo.F_DTSINHVIEN(@MSSV, mh.ma)) IS NULL THEN N'<chưa có điểm>'
        ELSE CONVERT(varchar(MAX), dbo.F_DTSINHVIEN(@MSSV, mh.ma))
    END AS N'Điểm thi'
    FROM (SinhVien sv 
    join lop l on sv.maLop = l.ma
    join MonHoc mh on mh.maKhoa = l.maKhoa)
    WHERE sv.ma = @MSSV
GO

--Thêm quan hệ xếp loại
CREATE TABLE XepLoai(
    maSinhVien VARCHAR(7) PRIMARY KEY,
    diemTrungBinh FLOAT,
    ketQua NVARCHAR(10),
    hocLuc NVARCHAR(10)
)

--6.9
CREATE PROCEDURE SP_INSERTXEPLOAT
AS

    INSERT INTO XepLoai(maSinhVien, diemTrungBinh, ketQua)
    SELECT sv.ma, dbo.F_DTBSINHVIEN(sv.ma), 
    CASE
        WHEN (dbo.F_DTBSINHVIEN(sv.ma) >= 5 AND (SELECT COUNT(*)  FROM KetQua kq WHERE kq.lanThi >= ALL(
                        SELECT kq2.lanThi 
                        FROM KetQua kq2
                        WHERE kq2.maSinhVien = kq.maSinhVien
                        AND kq2.maMonHoc = kq.maMonHoc)
                        AND kq.diem < 4 
                        AND kq.maSinhVien = sv.ma) <= 2)
        THEN N'Đạt'
        WHEN dbo.F_DTBSINHVIEN(sv.ma) IS NULL THEN NULL
        ELSE N'Không đạt'
    END
    FROM SinhVien sv

    UPDATE XepLoai 
    SET hocLuc = N'Giỏi'
    WHERE KetQua = N'Đạt' AND diemTrungBinh >=8

    UPDATE XepLoai 
    SET hocLuc = N'Khá'
    WHERE KetQua = N'Đạt' AND diemTrungBinh >= 7 AND diemTrungBinh < 8

    UPDATE XepLoai 
    SET hocLuc = N'Trung bình'
    WHERE KetQua = N'Đạt' AND diemTrungBinh < 7
GO

--6.10
CREATE PROCEDURE SP_SVTHAMGIADU
AS
    SELECT dbo.F_DTBSINHVIEN(sv.ma) AS N'Sinh viên tham gia đầy đủ các môn học của khoa'
    FROM SinhVien sv 
        JOIN Lop l on l.ma =sv.maLop 
        JOIN MonHoc mh on mh.maKhoa = l.maKhoa
    WHERE NOT EXISTS(SELECT mh2.ma FROM MonHoc mh2 WHERE mh2.maKhoa = l.maKhoa
                        EXCEPT(SELECT kq.maMonHoc FROM KetQua kq WHERE kq.maSinhVien = sv.ma))
GO

--7.1
CREATE RULE listCT
AS
@list IN ('CQ','CD','TC')

EXEC sp_bindrule listCT, 'ChuongTrinh.ma'

--7.2
ALTER TABLE GiangKhoa
ADD CONSTRAINT CHK_HocKy CHECK (hocKy in (1,2))

--7.3
ALTER TABLE GiangKhoa
ADD CONSTRAINT CHK_soTietLyThuyet CHECK (soTietLyThuyet <= 120)

--7.4
ALTER TABLE GiangKhoa
ADD CONSTRAINT CHK_soTietThucHanh CHECK (soTietThucHanh <= 120)

--7.5
CREATE RULE sotinchi
AS
@range >= 0 and @range <= 6

EXEC sp_bindrule sotinchi, 'GiangKhoa.soTinChi'

--7.6
CREATE TRIGGER T_OPTION1DIEMTHI
ON ketQua
AFTER INSERT, UPDATE
AS
    --release the trigger for a command that doesn't change any rows
    IF (ROWCOUNT_BIG() = 0)
        RETURN;
    --supress 'rows affected' messages
    SET NOCOUNT ON

    --check insert table
    --check whether diem is between 0 and 10
    IF(EXISTS(SELECT i.diem FROM inserted i
                WHERE i.diem < 0 OR i.diem > 10))
    BEGIN
        RAISERROR(N'Điểm phải theo thang điểm 10', 16, 10)
        ROLLBACK TRANSACTION
        RETURN
    END

    --check for invalid decimal points
    IF(EXISTS(SELECT i.diem FROM inserted i
        WHERE ROUND(CAST(i.diem AS DECIMAL(18,1))*2, 0)/2 - i.diem < 0 OR
        ROUND(CAST(i.diem AS DECIMAL(18,1))*2, 0)/2 - i.diem > 0)
        )
    BEGIN
        RAISERROR(N'Điểm phải chính xác tới 0.5', 16, 10)
        ROLLBACK TRANSACTION
        RETURN
    END
GO

DROP TRIGGER T_OPTION1DIEMTHI

CREATE TRIGGER T_OPTION2DIEMTHI
ON ketQua
AFTER INSERT, UPDATE
AS
    --release the trigger for a command that doesn't change any rows
    IF (ROWCOUNT_BIG() = 0)
        RETURN;
    --supress 'rows affected' messages
    SET NOCOUNT ON

    --check insert table
    --check whether diem is between 0 and 10
    IF(EXISTS(SELECT i.diem FROM inserted i
                WHERE i.diem < 0 OR i.diem > 10))
    BEGIN
        RAISERROR(N'Điểm phải theo thang điểm 10', 16, 10)
        ROLLBACK TRANSACTION
        RETURN
    END

    --check for invalid decimal points
    IF(EXISTS(SELECT i.diem FROM inserted i
        WHERE ROUND(CAST(i.diem AS DECIMAL(18,1))*2, 0)/2 - i.diem < 0 OR
        ROUND(CAST(i.diem AS DECIMAL(18,1))*2, 0)/2 - i.diem > 0)
        )
    BEGIN
        PRINT N'Làm tròn điểm';
        UPDATE KetQua
        SET diem = ROUND(CAST(diem AS DECIMAL(18,1))*2, 0)/2
        WHERE maSinhVien in 
        (SELECT i.maSinhVien FROM inserted i
        WHERE ROUND(CAST(i.diem AS DECIMAL(18,1))*2, 0)/2 - i.diem < 0 OR
        ROUND(CAST(i.diem AS DECIMAL(18,1))*2, 0)/2 - i.diem > 0)
        RETURN
    END
GO

DROP TRIGGER T_OPTION2DIEMTHI

--7.7
ALTER TABLE KhoaHoc
ADD CONSTRAINT CHK_namKetThuc_namBatDau CHECK (namKetThuc >= namBatDau)

--7.8
ALTER TABLE GiangKhoa
ADD CONSTRAINT CHK_soTietLyThuyet_soTietThucHanh CHECK (soTietLyThuyet >= soTietThucHanh)

--7.9
ALTER TABLE ChuongTrinh
ADD CONSTRAINT UNI_tenChuongTrinh UNIQUE(tenChuongTrinh)

--7.10
ALTER TABLE khoa
ADD CONSTRAINT UNI_tenKhoa UNIQUE(tenKhoa)

--7.11
ALTER TABLE MonHoc
ADD CONSTRAINT UNI_tenMonHoc UNIQUE(tenMonHoc)

--7.12
ALTER TABLE KetQua
ADD CONSTRAINT CHK_lanThi CHECK(lanThi <= 2)

--7.14
CREATE TRIGGER T_LOPNAMKHOAHOC
ON Lop
AFTER INSERT, UPDATE
AS
    IF(EXISTS(SELECT * 
        FROM inserted i 
        JOIN KhoaHoc kh on kh.ma = i.maKhoaHoc
        JOIN Khoa k on k.ma = i.maKhoa
            WHERE kh.namBatDau < k.namThanhLap))
    BEGIN
        RAISERROR(N'Năm bắt đầu khóa học của một lớp không thể nhỏ hơn năm thành lặp khoa quản lý lớp đó.',16,10)
        ROLLBACK TRANSACTION
        RETURN
    END
GO

--7.15
CREATE TRIGGER T_SINHVIENMHHOPLE
ON ketQua
AFTER UPDATE, INSERT
AS
    IF(EXISTS(
        SELECT * 
        FROM inserted i
            JOIN GiangKhoa gk on gk.maMonHoc = i.maMonHoc
            JOIN SinhVien sv on sv.ma = i.maSinhVien
            JOIN Lop l on l.ma = sv.maLop
        WHERE gk.maChuongTrinh != l.maChuongTrinh OR gk.maKhoa != l.maKhoa
    ))
    BEGIN
        RAISERROR(N'Sinh viên chỉ có thể dự thi các môn học có trong chương trình và thuộc về khoa mà sinh viên đó đang theo học.', 16,10)
    END
GO
