﻿USE QLSV
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

USE QLSV
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
ALTER PROCEDURE SP_MONHOC682
    @MSSV VARCHAR(10)
AS
    SELECT kq.maSinhVien, kq.maMonHoc, kq.diem 
    FROM MonHoc mh 
    LEFT JOIN KetQua kq on kq.maMonHoc = mh.ma
    WHERE (kq.maSinhVien = @MSSV and kq.lanThi >= ALL(
        SELECT kq2.lanThi 
        FROM KetQua kq2 
        WHERE kq2.maSinhVien = @MSSV and kq.maMonHoc = kq2.maMonHoc
    )) or kq.lanThi = 0
GO

EXEC SP_MONHOC682 '0212001'

SELECT *
    FROM MonHoc mh 
    LEFT JOIN KetQua kq on mh.ma = kq.maMonHoc
SELECT DISTINCT sv.ma, mh.ma, kq.lanThi, kq.diem 
FROM SinhVien sv 
RIGHT JOIN Lop l on l.ma = sv.maLop
RIGHT JOIN MonHoc mh on mh.maKhoa = l.maKhoa
LEFT JOIN KetQua kq on kq.maSinhVien = sv.ma

SELECT sv.ma, l.maKhoa
FROM SinhVien sv join Lop l on l.ma = sv.maLop


SELECT * 
FROM KetQua kq 
RIGHT JOIN MonHoc mh on kq.maMonHoc = mh.ma
LEFT JOIN SinhVien sv on kq.maSinhVien = sv.ma

SELECT sv.ma, mh.ma, (SELECT kq.lanThi 
                      FROM KetQua kq 
                      WHERE kq.maSinhVien = sv.ma and kq.lanThi >= ALL(
                        SELECT kq2.lanThi 
                        FROM KetQua kq2 
                        WHERE kq2.maSinhVien = sv.ma and kq2.maMonHoc = kq.maMonHoc))


-- SELECT CASE
--     WHEN kq.maSinhVien IS NULL THEN sv.ma
--     ELSE kq.maSinhVien
-- END AS maSinhVien,
SELECT DISTINCT sv.ma
,mh.ma,
CASE
    WHEN kq.lanThi >= 1 and mh.ma in
    (SELECT kq3.maMonHoc FROM KetQua kq3 WHERE kq3.maSinhVien = sv.ma 
        and kq3.lanThi = kq.lanThi 
        and kq3.diem = kq3.diem )
    THEN kq.lanThi
    ELSE NULL
END AS lanThi1
,CASE
    WHEN kq.diem >= 0 and mh.ma in
    (SELECT kq3.maMonHoc FROM KetQua kq3 WHERE kq3.maSinhVien = sv.ma
    and kq3.lanThi = kq.lanThi 
    and kq.diem = kq3.diem )
    THEN kq.diem
    ELSE NULL
END AS diemThi
FROM (SinhVien sv 
    join lop l on sv.maLop = l.ma
    join MonHoc mh on mh.maKhoa = l.maKhoa)
    LEFT JOIN KetQua kq on sv.ma = kq.maSinhVien
WHERE kq.lanThi >= ALL(SELECT kq2.lanThi 
                        FROM KetQua kq2 
                        WHERE
                        kq2.maMonHoc = kq.maMonHoc
                        and kq2.maSinhVien = kq.maSinhVien
                        ) and lanThi1 is not NULL
                        -- or (kq.lanThi IS NULL and mh.ma not in (
                        --     SELECT kq4.maMonHoc 
                        --     FROM KetQua kq4
                        --     WHERE kq4.maSinhVien = kq.maSinhVien
                        --     )) 
                        

SELECT sv.ma, mh.ma FROM SinhVien sv 
join lop l on l.ma = sv.maLop
join MonHoc mh on mh.maKhoa = l.maKhoa
