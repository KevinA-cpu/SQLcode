--QuanLyDeTai
--Q59
--SELECT DISTINCT dt.TenDT FROM DETAI dt join THAMGIADT tg on tg.MaDT = dt.MaDT where not exists(SELECT gv.MaGV from GIAOVIEN gv where gv.MaBM = 'HTTT' EXCEPT(
--												                                                SELECT gv2.MaGV from GIAOVIEN gv2 join THAMGIADT dt2 on dt2.MaGV = gv2.MaGV where dt2.MaDT = tg.MaDT))

--61
--SELECT gv.MaGV from GIAOVIEN gv where not exists(SELECT DISTINCT tg.MaDT from DETAI dt join THAMGIADT tg on tg.MaDT = dt.MaDT where dt.MaCD = 'QLGD' EXCEPT
--											    (SELECT tg2.MaDT from THAMGIADT tg2 where tg2.MaGV = gv.MaGV))

--63
--SELECT dt.TenDT from DETAI dt join THAMGIADT tg on tg.MaDT = dt.MaDT where not exists(SELECT gv2.MaGV from GIAOVIEN gv2 join THAMGIADT tg2 on tg2.MaGV = gv2.MaGV where tg2.MaDT = tg.MaDT except (SELECT gv.MaGV from GIAOVIEN gv where gv.MaBM = 'HHC'))

--65										
--SELECT tg.MaGV from THAMGIADT tg where not exists(SELECT tg2.MaDT from THAMGIADT tg2 where tg2.MaGV = tg.MaGV
--												EXCEPT(SELECT tg3.MaDT from THAMGIADT tg3 join DETAI dt on dt.MaDT = tg3.MaDT where dt.MaCD = 'UDCN'))

--67
--SELECT tg.MaGV from THAMGIADT tg where not exists(SELECT tg2.MaGV from (THAMGIADT tg2 join GIAOVIEN gv on gv.MaGV = tg2.MaGV) join BOMON bm on bm.MaBM = gv.MaBM where bm.MaKhoa = 'CNTT' 
--												  EXCEPT(SELECT tg3.MaDT from THAMGIADT tg3 where tg3.MaGV = tg.MaGV))

--69
--SELECT gv.HoTen from GIAOVIEN gv join THAMGIADT tg on tg.MaGV = gv.MaGV where not exists(SELECT dt.MaDT from DETAI dt where dt.KinhPhi > 100 EXCEPT(
--																						SELECT dt2.MaDT from DETAI dt2 join THAMGIADT tg2  on tg2.MaDT = dt2.MaDT where tg2.MaGV = tg.MaGV))

--71
--SELECT DISTINCT gv.MaGV, gv.HoTen, gv.NgaySinh from GIAOVIEN gv join THAMGIADT tg on tg.MaGV = gv.MaGV where not exists(SELECT cv.TenCV from CONGVIEC cv join DETAI dt on dt.MaDT = cv.MaDT where dt.TenDT = N'Ứng dụng hóa học xanh' EXCEPT(
--																		SELECT cv2.TenCV from CONGVIEC cv2 where tg.MaDT = cv2.MaDT))

--QuanLyChuyenBay
--Q51
--SELECT lb.MACB FROM  LICHBAY lb join LOAIMB lmb on lmb.MALOAI = lb.MALOAI where not exists(
--SELECT lmb2.MALOAI from LOAIMB lmb2 where lmb2.HANGSX = 'Boeing' 
--	EXCEPT
--		(SELECT lmb3.MALOAI from LOAIMB lmb3 where lmb3.MALOAI = lmb.MALOAI))

--Q52
--SELECT nv.MANV, nv.TEN FROM KHANANG kn join NHANVIEN nv on nv.MANV = kn.MANV where not exists(SELECT lmb2.MALOAI from LOAIMB lmb2 where lmb2.HANGSX = 'Airbus' EXCEPT
--																						      SELECT lmb3.MALOAI from LOAIMB lmb3 join KHANANG kn2 on kn2.MALOAI = lmb3.MALOAI where kn.MANV = kn2.MANV)

--Q53
--SELECT nv.TEN FROM NHANVIEN nv where nv.LOAINV = 'False' and not exists(SELECT pc.NGAYDI, pc.MACB from PHANCONG pc GROUP BY pc.NGAYDI, pc.MACB, pc.MANV HAVING pc.MACB = '100' EXCEPT
--																	(SELECT pc2.NGAYDI, pc2.MACB from PHANCONG pc2 WHERE pc2.MANV = nv.MANV and pc2.MACB = '100'))

--Q54
--SELECT lb.NGAYDI FROM LICHBAY lb where not exists(SELECT lmb2.MALOAI from LOAIMB lmb2 where lmb2.HANGSX = 'Boeing' EXCEPT(
--													SELECT lmb3.MALOAI from LOAIMB lmb3 join LICHBAY lb2 on lb2.MALOAI = lmb3.MALOAI where lb.NGAYDI = lb2.NGAYDI))

--Q55
--SELECT lmb.MALOAI FROM LOAIMB lmb where lmb.HANGSX = 'Boeing' and not exists(SELECT lb.NGAYDI FROM LICHBAY lb GROUP BY lb.NGAYDI EXCEPT
--																			(SELECT lb2.NGAYDI FROM LICHBAY lb2 where lb2.MALOAI = lmb.MALOAI))

--Q56
--SELECT DISTINCT kh.MAKH, kh.TEN FROM DATCHO dc join KHACHHANG kh on kh.MAKH = dc.MAKH where not exists(SELECT DISTINCT dc.NGAYDI FROM DATCHO dc where dc.NGAYDI >= '2000-10-31' and dc.NGAYDI <= '2000-11-01' EXCEPT(
--																								SELECT dc2.NGAYDI from DATCHO dc2 where dc2.MAKH = dc.MAKH))

--Q57
--SELECT DISTINCT nv.MANV, nv.TEN FROM KHANANG kn join NHANVIEN nv on nv.MANV = kn.MANV where exists(SELECT lmb.MALOAI from LOAIMB lmb where lmb.HANGSX = 'Airbus' EXCEPT
--																						SELECT lmb3.MALOAI from LOAIMB lmb3 join KHANANG kn2 on kn2.MALOAI = lmb3.MALOAI where kn.MANV = kn2.MANV)

--Q58
--SELECT * FROM CHUYENBAY cb join LICHBAY lb on lb.MACB = cb.MACB 
--SELECT cb.SBDI FROM CHUYENBAY cb join LICHBAY lb on lb.MACB = cb.MACB where not exists(SELECT lmb.MALOAI from LOAIMB lmb where lmb.HANGSX = 'Boeing' EXCEPT(
--																						SELECT lmb2.MALOAI from (LOAIMB lmb2 join LICHBAY lb2 on lb2.MALOAI = lmb2.MALOAI) join CHUYENBAY cb2 on cb2.MACB = lb2.MACB
--																						where cb2.SBDI = cb.SBDI))