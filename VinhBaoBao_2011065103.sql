--2
CREATE VIEW V_GV 
AS
SELECT GIANGVIEN.MaGV AS [Mã GV], GIANGVIEN.HoLot AS [Họ Lót], GIANGVIEN.Ten AS Tên, KHOA.TenKhoa AS [Tên khoa], GIANGVIEN.LuongCB AS Lương, COUNT(GIANGDAY.MaMon) AS [Số môn giảng dạy]
FROM     KHOA INNER JOIN
                  GIANGVIEN ON KHOA.MaKhoa = GIANGVIEN.MaKhoa INNER JOIN
                  GIANGDAY ON GIANGVIEN.MaGV = GIANGDAY.MaGV
GROUP BY GIANGVIEN.MaGV, GIANGVIEN.HoLot, GIANGVIEN.Ten, KHOA.TenKhoa, GIANGVIEN.LuongCB
go
--3
create or alter view V_MH
as
SELECT MONHOC.MaMon AS [Mã môn học], MONHOC.TenMon AS [Tên môn học], KHOA.TenKhoa AS [Tên khoa], COUNT(GIANGDAY.MaGV) AS [Số lượng GV]
FROM     KHOA INNER JOIN
                  MONHOC ON KHOA.MaKhoa = MONHOC.MaKhoa INNER JOIN
                  GIANGDAY ON MONHOC.MaMon = GIANGDAY.MaMon
GROUP BY MONHOC.MaMon, MONHOC.TenMon, KHOA.TenKhoa
go
--4
CREATE VIEW MH_Khoa 
AS
SELECT KHOA.MaKhoa AS [Mã khoa], KHOA.TenKhoa AS [Tên khoa], COUNT(MONHOC.MaMon) AS [Số lượng môn học]
FROM     KHOA INNER JOIN
                  MONHOC ON KHOA.MaKhoa = MONHOC.MaKhoa
GROUP BY KHOA.MaKhoa, KHOA.TenKhoa
go

--5
CREATE VIEW GV_Khoa
AS
SELECT KHOA.MaKhoa AS [Mã khoa], KHOA.TenKhoa AS [Tên khoa], COUNT(GIANGVIEN.MaGV) AS [Số lượng giáo viên]
FROM     KHOA INNER JOIN
                  GIANGVIEN ON KHOA.MaKhoa = GIANGVIEN.MaKhoa
GROUP BY KHOA.MaKhoa, KHOA.TenKhoa
go
--6. Tạo function F1 để cho biết tên khoa phụ trách một môn học với mã môn học là tham số truyền vào.
CREATE FUNCTION F1(@MAMH int)
RETURNS TABLE
AS
	RETURN 
	(
		SELECT DISTINCT TENKHOA
		FROM KHOA K ,GIANGDAY GD, GIANGVIEN GV, MONHOC M
		WHERE M.MaMon = GD.MaMon AND GD.MaGV = GV.MaGV AND GV.MaKhoa = K.MaKhoa AND M.MaMon = @MAMH 
	)
SELECT * FROM F1(3)
--7. Tạo function F2 để trả về danh sách GV cùng khoa với GV có mã là tham số truyền vào.
CREATE FUNCTION F2(@MAGV int)
RETURNS TABLE
AS
	RETURN 
	(
		SELECT GV.MAGV,(HOLOT+TEN) HOTEN, TENKHOA, LUONGCB
		FROM GIANGVIEN GV, KHOA K
		WHERE GV.MaKhoa = K.MaKhoa AND GV.MaGV = @MAGV
	)
SELECT * FROM F2(3)
--8 Xây dựng hàm tên Fn_CacSoNT(@n) trả về chuỗi các số nguyên tố nằm trong
--khoảng từ 2 đến n. Ví dụ: In ra các số nguyên tố từ 2 đến 10
--DECLARE @Kq VARCHAR(1000)
--SET @Kq = dbo.Fn_CacSoNT(10)
--PRINT @Kq --In ra 2, 3, 5, 7

--9 Xây dựng hàm tên Fn_TongHaiSo(@So1, @So2) trả về tổng của hai số nguyên.
--Ví dụ:In ra tổng của hai số nguyên 10 và 15
--DECLARE @Kq INT
--SET @Kq = dbo.Fn_TongHaiSo(10,15)
--PRINT @Kq --In ra 25
CREATE FUNCTION Fn_TongHaiSo(@SO1 INT, @SO2 INT)
RETURNS INT
AS
BEGIN
	DECLARE @SUM INT
	SET @SUM = @SO1+@SO2
	RETURN @SUM
END
SELECT DBO.Fn_TongHaiSo(10,15)
--10 viết hàm xếp loại giảng viên nếu lương >=12.000.000 giảng viên chính, nếu lương >=10.000.000 giảng viên còn lại trợ giảng
CREATE PROC F10
AS
BEGIN
	SELECT (HOLOT + TEN) HOTEN, CASE WHEN GV.LUONGCB >= 12000000 THEN N'Giảng Viên Chính' 
			WHEN GV.LUONGCB >= 10000000 THEN N'Giảng Viên'  ELSE N'Trợ Giảng' END AS XEPLOAI
	FROM GIANGVIEN GV
END
EXEC F10