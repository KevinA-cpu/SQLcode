USE QLBanHang
GO
--câu 1
CREATE FUNCTION F_DEMSOMATHANG(@MANCC VARCHAR(6))
RETURNS INT
AS
BEGIN
    RETURN (
        SELECT COUNT(*) FROM CUNG_UNG c 
        WHERE c.MaNhaCungCap = @MANCC
    )
END

--câu 2
ALTER TRIGGER T_MHNHACUNGUNG
ON DAT_HANG
AFTER INSERT, UPDATE
AS
    IF(EXISTS(
        (SELECT * FROM inserted i JOIN CHI_TIET_DAT_HANG ctdh on ctdh.SoDatHang = i.So
        WHERE i.MaNhaCungCap != (SELECT c.MaNhaCungCap FROM CUNG_UNG c WHERE c.MaMatHang = ctdh.MaMatHang)
        )))
    BEGIN
        RAISERROR(N'Chỉ được đặt hàng mà nhà cung cấp có cung ứng.',16,10)
        ROLLBACK TRANSACTION
        RETURN
    END
GO


UPDATE DAT_HANG SET MaNhaCungCap = 'NCC002' WHERE So = 'DH0001' 

CREATE TRIGGER T_THANHTIENDATHANG
ON DAT_HANG
AFTER INSERT, UPDATE
AS
    
    IF(EXISTS(SELECT * FROM inserted i
                    WHERE i.ThanhTien != 
                    (SELECT SUM(ctdh.SoLuongDat*ctdh.DonGiaDat) FROM CHI_TIET_DAT_HANG ctdh
                    WHERE ctdh.SoDatHang = i.So)
                    ))
    BEGIN
        RAISERROR(N'Thành tiền trong đặt hàng phải = Tổng (Số lượng đặt * đơn giá đặt)', 16, 10)
        ROLLBACK TRANSACTION
        RETURN
    END
GO

--câu 3
CREATE PROCEDURE SP_GIAOHANG
@SODATHANG VARCHAR(6)
AS
    --Đếm từ bảng giao hàng có bao nhiêu đơn của sodathang
    IF((SELECT COUNT(*) FROM GIAO_HANG gh WHERE gh.SoDatHang = @SODATHANG) > 3)
    BEGIN
        PRINT N'Một số đặt hàng chỉ được giao tối đa 3 lần'
    END
    --Kiểm tra xem có mặt hàng nào trong chi tiết giao hàng không nằm trong số mặt hàng của chi tiết đặt hàng của sodathang đó hay không
    ELSE IF (EXISTS(
        SELECT * FROM GIAO_HANG gh JOIN CHI_TIET_GIAO_HANG ctgh on ctgh.SoGiaoHang = gh.So
        WHERE ctgh.MaMatHang NOT IN (SELECT ctdh.MaMatHang FROM DAT_HANG dh 
                                            JOIN CHI_TIET_DAT_HANG ctdh on dh.So = ctdh.SoDatHang
                                            WHERE dh.So = gh.SoDatHang)
    ))
    BEGIN
        PRINT N'Chỉ giao mặt hàng có đặt trong số đặt hàng đó'
    END
    --Kiểm tra xem số lượng giao có lớn hơn số lượng giao trong ctdh không
    ELSE IF (EXISTS(
        SELECT * FROM GIAO_HANG gh JOIN CHI_TIET_GIAO_HANG ctgh on ctgh.SoGiaoHang = gh.So
        WHERE ctgh.SoLuongGiao > (SELECT ctdh.SoLuongDat FROM CHI_TIET_DAT_HANG ctdh
                                            WHERE ctdh.SoDatHang = gh.SoDatHang and ctdh.MaMatHang = ctgh.MaMatHang
    )))
    BEGIN
        PRINT N'Số lượng mỗi mặt hàng giao không được vượt quá số lượng đặt của mặt hàng đó'
    END
    ELSE
    BEGIN
        PRINT N'Thực hiện giao hàng'
    END
GO

EXEC SP_GIAOHANG 'DH0002'