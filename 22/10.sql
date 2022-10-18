--Tạo role đối tác và khách hàng
CREATE ROLE DoiTac
CREATE ROLE KhachHang
--Cấp quyền cho từng role
GRANT SELECT, UPDATE ON CuaHang TO DoiTac
GRANT SELECT, INSERT, UPDATE, DELETE ON ThucDon TO DoiTac
GRANT SELECT, UPDATE ON DonHang TO DoiTac
GRANT SELECT on SoLieu To DoiTac

GRANT SELECT ON DoiTac TO KhachHang
GRANT SELECT ON MonAn TO KhachHang
GRANT SELECT, INSERT, DELETE ON DonHang TO KhachHang