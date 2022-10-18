CREATE TRIGGER	gioiTinh_GIAOVIEN
ON GIAOVIEN
FOR insert, update
AS
	IF EXISTS(SELECT gv.GioiTinh FROM GIAOVIEN gv WHERE gv.GioiTinh != N'Nam' and gv.GioiTinh != N'Nữ')
	BEGIN
		raiserror(N'Lỗi: giới tính phải làm nam hoặc nữ',16,1)
		rollback
	END


CREATE TRIGGER luong_GIAOVIEN
ON GIAOVIEN
FOR insert, update
AS
	IF EXISTS(SELECT gv.luong from GIAOVIEN gv WHERE LEN(gv.luong) != 2)
	BEGIN
		raiserror(N'Lỗi: lương phải là số tròn chục',16,1)
		rollback
	END


CREATE TRIGGER tuoi_GIAOVIEN
on GIAOVIEN
FOR insert, update
AS
	IF(EXISTS(SELECT (year(GETDATE()) - year(gv.NgaySinh)) FROM GIAOVIEN gv 
	WHERE (year(GETDATE()) - year(gv.NgaySinh)) < 17 or (year(GETDATE()) - year(gv.NgaySinh)) > 60 ))
	BEGIN
		raiserror(N'Lỗi: tuổi của giáo viên phải từ 18 tới 60 tuổi')
		rollback
	END
