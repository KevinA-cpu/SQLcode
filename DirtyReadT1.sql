USE GiaoDoAnABC
GO 

--Trường hợp 1:
--xóa dữ liệu ví dụ nếu cần
DELETE ChiTietHopDong WHERE MaSoThue = 'TEST'
--Insert ví dụ vào table
INSERT INTO ChiTietHopDong
VALUES ('TEST', 'Lau De A', 'Test', 5, N'Hết hạn', '2002-10-10', 250)
--T1:
BEGIN TRANSACTION
UPDATE ChiTietHopDong
SET TrangThaiHoatDong = N'Còn hiệu lực', PhiHoaHong = 200
WHERE MaSoThue = 'Test'
WAITFOR DELAY '00:00:10'
ROLLBACK TRANSACTION
--Kiểm tra 
SELECT * FROM ChiTietHopDong

--Trường hợp 2:
--xóa dữ liệu ví dụ nếu cần
DELETE DoiTac WHERE TenNguoiDaiDien = 'Nguyen Van A'
--Insert ví dụ vào table
INSERT INTO DoiTac 
VALUES('Nguyen Van A', 'Test', 'Test', 'Test', 'Test', 1, 'Test', 'Test', 'Test', 5, 'Test', 'Test', 'Lau De A', 'XYZ')
--T1
BEGIN TRANSACTION
INSERT INTO DonDatHang 
VALUES('Test', 200, N'Chờ nhận', NULL, NULL, 'Lau De A', 'XYZ', NULL, 5)
WAITFOR DELAY '00:00:10'
ROLLBACK TRANSACTION
--Kiểm tra 
SELECT * FROM DonDatHang

--Trường hợp 3:
--xóa dữ liệu ví dụ nếu cần
DELETE DoiTac WHERE TenNguoiDaiDien = 'Nguyen Van A'
DELETE DonDatHang WHERE MaDH = 'Test'
--Insert ví dụ vào table
INSERT INTO DoiTac 
VALUES('Nguyen Van A', 'Test', 'Test', 'Test', 'Test', 1, 'Test', 'Test', 'Test', 5, 'Test', 'Test', 'Lau De A', 'XYZ')
INSERT INTO DonDatHang 
VALUES('Test', 200, N'Chờ nhận', NULL, NULL, 'Lau De A', 'XYZ', NULL, 5)
--T1
BEGIN TRANSACTION
UPDATE DonDatHang
SET TrangThaiDonHang = N'Hủy đơn'
WHERE MaDH = 'Test'
WAITFOR DELAY '00:00:10'
ROLLBACK TRANSACTION
--Kiểm tra 
SELECT * FROM DonDatHang

--Trường hợp 4, 9:
--xóa dữ liệu ví dụ nếu cần
DELETE DoiTac WHERE TenNguoiDaiDien = 'Nguyen Van A'
DELETE DonDatHang WHERE MaDH = 'Test'
DELETE TaiXe WHERE MaTX = 'Test'
--Insert ví dụ vào table
INSERT INTO TaiXe 
VALUES('Test', 'Test', 'Test', 'Test', 'Test', 'Test', 'Test', 'Test', 200, 'Test')
INSERT INTO DoiTac 
VALUES('Nguyen Van A', 'Test', 'Test', 'Test', 'Test', 1, 'Test', 'Test', 'Test', 5, 'Test', 'Test', 'Lau De A', 'XYZ')
INSERT INTO DonDatHang 
VALUES('Test', 200, N'Chờ nhận', NULL, NULL, 'Lau De A', 'XYZ', NULL, 5)
--T1
BEGIN TRANSACTION
UPDATE DonDatHang
SET TrangThaiDonHang = N'Đã nhận đơn hàng', MaTX = 'Test'
WHERE MaDH = 'Test'
WAITFOR DELAY '00:00:10'
ROLLBACK TRANSACTION
--Kiểm tra 
SELECT * FROM DonDatHang

--Trường hợp 5:
--xóa dữ liệu ví dụ nếu cần
DELETE DoiTac WHERE TenNguoiDaiDien = 'Nguyen Van A'
DELETE KhachHang WHERE MaKH = 'Test'
--Insert ví dụ vào table
INSERT INTO KhachHang 
VALUES('Test', 'Test', 'Test', 'Test', 'Test', 'Test')
INSERT INTO DoiTac 
VALUES('Nguyen Van A', 'Test', 'Test', 'Test', 'Test', 1, 'Test', 'Test', 'Test', 5, 'Test', 'Test', 'Lau De A', 'XYZ')
--T1
BEGIN TRANSACTION
INSERT INTO Feedback 
VALUES('Test', 'Lau De A', 'XYZ', 'Test info')
WAITFOR DELAY '00:00:10'
ROLLBACK TRANSACTION
--Kiểm tra 
SELECT * FROM Feedback

--Trường hợp 6, 11:
--T1
BEGIN TRANSACTION
INSERT INTO DoiTac 
VALUES('Nguyen Van A', 'Test', 'Test', 'Test', 'Test', 1, 'Test', 'Test', 'Test', 5, 'Test', 'Test', 'Lau De A', 'XYZ')
WAITFOR DELAY '00:00:10'
ROLLBACK TRANSACTION
--Kiểm tra 
SELECT * FROM DoiTac

--Trường hợp 7:
--xóa dữ liệu ví dụ nếu cần
DELETE DoiTac WHERE TenNguoiDaiDien = 'Nguyen Van A'
--Insert ví dụ vào table
INSERT INTO DoiTac 
VALUES('Nguyen Van A', 'Test', 'Test', 'Test', 'Test', 1, 'Test', 'Test', 'Test', 5, 'Test', 'Test', 'Lau De A', 'XYZ')
--T1
BEGIN TRANSACTION
INSERT INTO MonAn 
VALUES('Lau De', 1, 2, 3, 200, N'Còn')
INSERT INTO ThucDon 
VALUES('Lau De A', 'XYZ', 'Lau De')
WAITFOR DELAY '00:00:10'
ROLLBACK TRANSACTION
--Kiểm tra 
SELECT * FROM MonAn, ThucDon

--Trường hợp 8:
--xóa dữ liệu ví dụ nếu cần
DELETE DoiTac WHERE TenNguoiDaiDien = 'Nguyen Van A'
DELETE DonDatHang WHERE MaDH = 'Test'
--Insert ví dụ vào table
INSERT INTO DoiTac 
VALUES('Nguyen Van A', 'Test', 'Test', 'Test', 'Test', 1, 'Test', 'Test', 'Test', 5, 'Test', 'Test', 'Lau De A', 'XYZ')
INSERT INTO DonDatHang 
VALUES('Test', 200, N'Chờ nhận', NULL, NULL, 'Lau De A', 'XYZ', NULL, 5)
--T1
BEGIN TRANSACTION
UPDATE DonDatHang
SET TrangThaiDonHang = N'Đang chuẩn bị'
WHERE MaDH = 'Test'
WAITFOR DELAY '00:00:10'
ROLLBACK TRANSACTION
--Kiểm tra 
SELECT * FROM DonDatHang

--Trường hợp 10:
--xóa dữ liệu ví dụ nếu cần
DELETE DoiTac WHERE TenNguoiDaiDien = 'Nguyen Van A'
DELETE DonDatHang WHERE MaDH = 'Test'
ALTER TABLE DonDatHang DROP COLUMN DiaChiGiaoHang
--Insert ví dụ vào table
--Bảng đơn đặt hàng của chúng em bị thiếu sót phần địa chỉ giao hàng
ALTER TABLE DonDatHang
ADD DiaChiGiaoHang NVARCHAR(100)
INSERT INTO DoiTac 
VALUES('Nguyen Van A', 'Test', 'Test', 'Test', 'Test', 1, 'Test', 'Test', 'Test', 5, 'Test', 'Test', 'Lau De A', 'XYZ')
INSERT INTO DonDatHang 
VALUES('Test', 200, N'Chờ nhận', NULL, NULL, 'Lau De A', 'XYZ', NULL, 5, 'KTX Khu B DHQG TPHCM')
--T1
BEGIN TRANSACTION
UPDATE DonDatHang
SET TrangThaiDonHang = N'Chấp nhận đơn hàng'
WHERE MaDH = 'Test'
WAITFOR DELAY '00:00:10'
ROLLBACK TRANSACTION
--Kiểm tra 
SELECT * FROM DonDatHang

--Trường hợp 12:
--xóa dữ liệu ví dụ nếu cần
DELETE ChiTietHopDong WHERE MaSoThue = '0001'
DELETE HopDong WHERE MaSoThue = '0001'
--T1
BEGIN TRANSACTION
INSERT INTO ChiTietHopDong VALUES('0001', 'Lau De A', 'Test', 5, N'Còn hạn', '2002-10-10', 250)
INSERT INTO HopDong VALUES('0001', 2, 'Test', 0008889182, 'Sacombank', 'Sai Gon')
WAITFOR DELAY '00:00:10'
ROLLBACK TRANSACTION
--Kiểm tra 
SELECT * FROM ChiTietHopDong, HopDong

--Trường hợp 13:
--xóa dữ liệu ví dụ nếu cần
DELETE ChiTietHopDong WHERE MaSoThue = '0001'
DELETE HopDong WHERE MaSoThue = '0001'
DELETE DoiTac WHERE TenNguoiDaiDien = 'Nguyen Van A'
--Insert ví dụ vào table
INSERT INTO DoiTac 
VALUES('Nguyen Van A', 'Test', 'Test', 'Test', 'Test', 1, 'Test', 'Test', 'Test', 5, 'Test', 'Test', 'Lau De A', 'XYZ')
--T1
BEGIN TRANSACTION
INSERT INTO ChiTietHopDong VALUES('0001', 'Lau De A', 'XYZ', 5, N'Còn hạn', '2002-10-10', 250)
INSERT INTO HopDong VALUES('0001', 2, 'Test', 0008889182, 'Sacombank', 'Sai Gon')
WAITFOR DELAY '00:00:10'
ROLLBACK TRANSACTION
--Kiểm tra 
SELECT * FROM ChiTietHopDong, HopDong
