CREATE DATABASE GiaoDoAnABC
GO
USE GiaoDoAnABC
GO


--- TẠO BẢNG ---
CREATE TABLE QuanTri (
	Ten NVARCHAR(30),
	DiaChi NVARCHAR(100),
	CCCD CHAR(12),
	SDT CHAR(10)
)


CREATE TABLE KhachHang (
	Ten NVARCHAR(30),
	DiaChi NVARCHAR(100),
	CCCD CHAR(12),
	SDT CHAR(10),
	Email VARCHAR(30),
	MaKH VARCHAR(8)

	CONSTRAINT PK_KhachHang PRIMARY KEY (MaKH)
)


CREATE TABLE TaiXe (
	Ten NVARCHAR(30),
	DiaChi NVARCHAR(100),
	CCCD CHAR(12),
	SDT CHAR(10),
	BienSoXe VARCHAR(15),
	KhuVucHoatDong NVARCHAR(100),
	Email VARCHAR(30),
	STKNganHang VARCHAR(15),
	PhiTheChan MONEY,
	MaTX VARCHAR(8)

	CONSTRAINT PK_TaiXe PRIMARY KEY (MaTX)
)

CREATE TABLE DoiTac (
	TenNguoiDaiDien NVARCHAR(30),
	DiaChi NVARCHAR(100),
	CCCD CHAR(12),
	SDT CHAR(10),
	Email VARCHAR(30),
	SoLuongChiNhanh INT,
	ThanhPho NVARCHAR(30),
	Quan NVARCHAR(30),
	Huyen NVARCHAR(30),
	SoLuongDonHangNgay INT,
	LoaiThucPham NVARCHAR(50),
	TaiKhoanNganHang VARCHAR(30),
	TenQuan NVARCHAR(30),
	DiaChiKinhDoanh NVARCHAR(100)

	CONSTRAINT PK_DoiTac PRIMARY KEY (TenQuan, DiaChiKinhDoanh)
)

CREATE TABLE DonDatHang (
	MaDH VARCHAR(8),
	TongTien MONEY,
	TrangThaiDonHang NVARCHAR(25),
	MaKH VARCHAR(8),
	MaTX VARCHAR(8),
	TenQuan NVARCHAR(30),
	DiaChiKinhDoanh NVARCHAR(100),
	TenMon NVARCHAR(30),
	SoLuongMon INT

	CONSTRAINT PK_DonDatHang PRIMARY KEY (MaDH)
)

CREATE TABLE HoaHong (
	MaDH VARCHAR(8),
	TenQuan NVARCHAR(30),
	DiaChiKinhDoanh NVARCHAR(100),
	TienHoaHong MONEY

	CONSTRAINT PK_HoaHong PRIMARY KEY (MaDH, TenQuan, DiaChiKinhDoanh)
)

CREATE TABLE Feedback (
	MaKH VARCHAR(8),
	TenQuan NVARCHAR(30),
	DiaChiKinhDoanh NVARCHAR(100),
	ThongTinFeedback NVARCHAR(500)

	CONSTRAINT PK_Feedback PRIMARY KEY (MaKH, TenQuan, DiaChiKinhDoanh)
)

CREATE TABLE MonAn (
	TenMon NVARCHAR(30),
	SoLuongDaBan INT,
	LuotLike INT,
	LuotDislike INT,
	DonGia MONEY,
	TinhTrangMon NVARCHAR(25)

	CONSTRAINT PK_MonAn PRIMARY KEY (TenMon)
)

CREATE TABLE TuyChonMonAn (
	TenMon NVARCHAR(30),
	TuyChon NVARCHAR(500)

	CONSTRAINT PK_TuyChonMonAn PRIMARY KEY (TenMon)
)

CREATE TABLE ThucDon (
	TenQuan NVARCHAR(30),
	DiaChiKinhDoanh NVARCHAR(100),
	MonAn NVARCHAR(30), -- !!!
)

CREATE TABLE HopDong (
	MaSoThue NVARCHAR(13),
	SoChiNhanhDangKy INT,
	DiaChiDangKyCacChiNhanh NVARCHAR(100),
	STKNganHang VARCHAR(15),
	NganHang NVARCHAR(50),
	ChiNhanh NVARCHAR(100)

	CONSTRAINT PK_HopDong PRIMARY KEY (MaSoThue)
)

CREATE TABLE ChiTietHopDong (
	MaSoThue NVARCHAR(7),
	TenQuan NVARCHAR(30),
	DiaChiKinhDoanh NVARCHAR(100),
	SoNamHoatDong INT,
	TrangThaiHoatDong NVARCHAR(25),
	NgayKyHopDong DATE,
	PhiHoaHong MONEY

	CONSTRAINT PK_ChiTietHopDong PRIMARY KEY (MaSoThue, TenQuan, DiaChiKinhDoanh)
)

CREATE TABLE PhiKichHoat (
	MaSoThue NVARCHAR(7),
	TenDoiTac NVARCHAR(30),
	SoTien MONEY

	CONSTRAINT PK_PhiKichHoat PRIMARY KEY (MaSoThue, TenDoiTac, SoTien)
)

CREATE TABLE HeThongOnline (
	TenQuan NVARCHAR(30),
	DiaChiKinhDoanh NVARCHAR(100),
	ThanhPho NVARCHAR(30),
	Quan NVARCHAR(30),
	Huyen NVARCHAR(30),
	TrangThaiHoatDong NVARCHAR(30)

	CONSTRAINT PK_HeThongOnline PRIMARY KEY (TenQuan, DiaChiKinhDoanh)
)





--- TẠO KHÓA NGOẠI ---

-- TABLE DonDatHang -- 
-- DonDatHang(MaKH) -> KhachHang(MaKH)
ALTER TABLE DonDatHang
ADD CONSTRAINT FK_DonDatHang_KhachHang FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
-- DonDatHang(MaTX) -> TaiXe(MaTX)
ALTER TABLE DonDatHang
ADD CONSTRAINT FK_DonDatHang_TaiXe FOREIGN KEY (MaTX) REFERENCES TaiXe(MaTX)
-- DonDatHang(TenQuan, DiaChiKinhDoanh) -> DoiTac(TenQuan, DiaChiKinhDoanh)
ALTER TABLE DonDatHang
ADD CONSTRAINT FK_DonDatHang_DoiTac FOREIGN KEY (TenQuan, DiaChiKinhDoanh) REFERENCES DoiTac(TenQuan, DiaChiKinhDoanh)
-- DonDatHang(TenMon) -> MonAn(TenMon)
ALTER TABLE DonDatHang
ADD CONSTRAINT FK_DonDatHang_MonAn FOREIGN KEY (TenMon) REFERENCES MonAn(TenMon)


-- TABLE Feedback -- 
-- Feedback(MaKH) -> KhachHang(MaKH)
ALTER TABLE Feedback
ADD CONSTRAINT FK_Feedback_KhachHang FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
-- Feedback(TenQuan, DiaChiKinhDoanh) -> DoiTac(TenQuan, DiaChiKinhDoanh)
ALTER TABLE Feedback
ADD CONSTRAINT FK_Feedback_DoiTac FOREIGN KEY (TenQuan, DiaChiKinhDoanh) REFERENCES DoiTac(TenQuan, DiaChiKinhDoanh)


-- TABLE HeThongOnline -- 
-- HeThongOnline(TenQuan, DiaChiKinhDoanh) -> DoiTac(TenQuan, DiaChiKinhDoanh)
ALTER TABLE HeThongOnline
ADD CONSTRAINT FK_HeThongOnline_DoiTac FOREIGN KEY (TenQuan, DiaChiKinhDoanh) REFERENCES DoiTac(TenQuan, DiaChiKinhDoanh)


-- TABLE ChiTietHopDong -- 
-- ChiTietHopDong(MaSoThue) -> HopDong(MaSoThue)
ALTER TABLE ChiTietHopDong
ADD CONSTRAINT FK_ChiTietHopDong_HopDong FOREIGN KEY (MaSoThue) REFERENCES HopDong(MaSoThue)
-- ChiTietHopDong(TenQuan, DiaChiKinhDoanh) -> DoiTac(TenQuan, DiaChiKinhDoanh)
ALTER TABLE ChiTietHopDong
ADD CONSTRAINT FK_ChiTietHopDong_DoiTac FOREIGN KEY (TenQuan, DiaChiKinhDoanh) REFERENCES DoiTac(TenQuan, DiaChiKinhDoanh)


-- TABLE HoaHong -- 
-- HoaHong(MaDH) -> DonDatHang(MaDH)
ALTER TABLE HoaHong
ADD CONSTRAINT FK_HoaHong_DonDatHang FOREIGN KEY (MaDH) REFERENCES DonDatHang(MaDH)
-- HoaHong(TenQuan, DiaChiKinhDoanh) -> DoiTac(TenQuan, DiaChiKinhDoanh)
ALTER TABLE HoaHong
ADD CONSTRAINT FK_HoaHong_DoiTac FOREIGN KEY (TenQuan, DiaChiKinhDoanh) REFERENCES DoiTac(TenQuan, DiaChiKinhDoanh)


-- TABLE TuyChonMonAn -- 
-- TuyChonMonAn(TenMon) -> MonAn(TenMon)
ALTER TABLE TuyChonMonAn
ADD CONSTRAINT FK_TuyChonMonAn_MonAn FOREIGN KEY (TenMon) REFERENCES MonAn(TenMon)


-- TABLE PhiKichHoat -- 
-- PhiKichHoat(MaSoThue) -> HopDong(MaSoThue)
ALTER TABLE PhiKichHoat
ADD CONSTRAINT FK_PhiKichHoat_HopDong FOREIGN KEY (MaSoThue) REFERENCES HopDong(MaSoThue)
-- PhiKichHoat(TenDoiTac) -> DoiTac(TenQuan)
--ALTER TABLE PhiKichHoat
--ADD CONSTRAINT FK_PhiKichHoat_DoiTac FOREIGN KEY (TenDoiTac) REFERENCES DoiTac(TenQuan)


-- TABLE ThucDon -- 
-- ThucDon(TenQuan, DiaChiKinhDoanh) -> DoiTac(TenQuan, DiaChiKinhDoanh)
ALTER TABLE ThucDon
ADD CONSTRAINT FK_ThucDon_DoiTac FOREIGN KEY (TenQuan, DiaChiKinhDoanh) REFERENCES DoiTac(TenQuan, DiaChiKinhDoanh)
-- ThucDon(MonAn) -> MonAn(TenMon)
ALTER TABLE ThucDon
ADD CONSTRAINT FK_ThucDon_MonAn FOREIGN KEY (MonAn) REFERENCES MonAn(TenMon)



