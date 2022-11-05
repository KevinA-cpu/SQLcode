--Tạo role đối tác và khách hàng
CREATE ROLE DoiTac
CREATE ROLE KhachHang
--Cấp quyền cho từng role
GRANT SELECT, UPDATE ON HeThongOnline TO DoiTac
GRANT SELECT, INSERT, UPDATE, DELETE ON ThucDon TO DoiTac
GRANT SELECT, UPDATE ON DonDatHang TO DoiTac

--Tạo view số liệu cho đối tác
CREATE VIEW [SOLIEU] AS
SELECT * 
FROM DonDatHang ddh, Feedback fb, HeThongOnline hto
WHERE ddh.TenQuan = fb.TenQuan and ddh.TenQuan = hto.TenQuan

GRANT SELECT on [SOLIEU] To DoiTac

GRANT SELECT ON DoiTac TO KhachHang
GRANT SELECT ON MonAn TO KhachHang
GRANT SELECT, INSERT ON DonDatHang TO KhachHang

--Tạo view gồm những đơn hàng đang ở trạng thái chờ nhận khi người dùng có nhu cầu xóa đơn hàng
CREATE VIEW [DONDATHANG] AS
SELECT * 
FROM DonDatHang ddh
WHERE ddh.TrangThaiDonHang = N"Chờ nhận"
GRANT DELETE ON [DONDATHANG] TO KhachHang