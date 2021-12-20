--cau1
create or alter view V1
SELECT        dbo.CTPX.MaSP, SUM(dbo.CTPX.SoLuong) AS TongSP, dbo.SanPham.TenSP, dbo.PhieuXuat.NgayLap
FROM            dbo.PhieuXuat INNER JOIN
                         dbo.CTPX ON dbo.PhieuXuat.MaPX = dbo.CTPX.MaPX INNER JOIN
                         dbo.SanPham ON dbo.CTPX.MaSP = dbo.SanPham.MaSP
GROUP BY dbo.CTPX.MaSP, dbo.SanPham.TenSP, dbo.PhieuXuat.NgayLap
HAVING        (YEAR(dbo.PhieuXuat.NgayLap) = 2010)
as

go
--cau2
create or alter view V2
as
SELECT       dbo.CTPX.MaSP,  dbo.SanPham.TenSP, dbo.Loai.TenLoai, dbo.PhieuXuat.NgayLap
FROM            dbo.PhieuXuat INNER JOIN
                         dbo.CTPX ON dbo.PhieuXuat.MaPX = dbo.CTPX.MaPX INNER JOIN
                         dbo.SanPham INNER JOIN
                         dbo.Loai ON dbo.SanPham.MaLoai = dbo.Loai.MaLoai ON dbo.CTPX.MaSP = dbo.SanPham.MaSP
WHERE        (dbo.PhieuXuat.NgayLap > CONVERT(DATETIME, '2010-01-01 00:00:00', 102)) AND (dbo.PhieuXuat.NgayLap < CONVERT(DATETIME, '2010-06-30 00:00:00', 102))
go
--cau3
create or alter view V3
as
SELECT        dbo.SanPham.MaLoai, dbo.Loai.TenLoai, dbo.CTPX.SoLuong
FROM            dbo.SanPham INNER JOIN
                         dbo.Loai ON dbo.SanPham.MaLoai = dbo.Loai.MaLoai INNER JOIN
                         dbo.CTPX ON dbo.SanPham.MaSP = dbo.CTPX.MaSP
go
--cau4
create or alter view V4
as
SELECT        MaPX, NgayLap
FROM            dbo.PhieuXuat
WHERE        (MONTH(NgayLap) = '6') AND (YEAR(NgayLap) = '2010')
go
--cau5
create or alter view V5
as
	SELECT        TOP (4) MaPX, MaNV
	FROM            dbo.PhieuXuat
	WHERE        (MaNV = 'NV01')
go
--6.Cho biết danh sách nhân viên nam có tuổi trên 25 nhưng dưới 30.
create view v6
as
	SELECT N.HoTen, N.MaNV, N.NgaySinh, N.Phai, YEAR(GETDATE())- YEAR(N.NgaySinh) AS [Tuổi]
	from  NhanVien N
	where YEAR(GETDATE())- YEAR(N.NgaySinh) BETWEEN 25 AND 30 
	AND Phai = 1 
select * from v6
--7.Thống kê số lượng phiếu xuất theo từng nhân viên.
create view v7
as
	select N.MaNV, N.HoTen, COUNT(P.MaPX) [SL PHIẾU XUẤT]
	from NhanVien N, PhieuXuat P, CTPX C
	where N.MaNV=P.MaNV AND P.MaPX=C.MaPX
	GROUP BY N.MaNV, N.HoTen
select * from v7
--8.Thống kê số lượng sản phẩm đã xuất theo từng sản phẩm.
create view v8
as
	select S.MaSP,S.TenSP, S.MaLoai, TB3.[SỐ LƯỢNG]
	from SanPham S,(select MaSP, SUM(C.SoLuong) AS [SỐ LƯỢNG]
					FROM CTPX C
					GROUP BY MaSP) AS TB3
	where S.MaSP=TB3.MaSP 
	group by S.MaSP,S.TenSP, S.MaLoai, TB3.[SỐ LƯỢNG]

select * from v8
--9.Lấy ra tên của nhân viên có số lượng phiếu xuất lớn nhất.
create view v9
as
	SELECT TOP 1 A.MaNV, HoTen, COUNT(B.MaPX) AS [SỐ LƯỢNG PHIẾU XUẤT]
	FROM NhanVien A, PhieuXuat B, CTPX C
	WHERE A.MaNV = B.MaNV AND B.MaPX = C.MaPX
	GROUP BY A.MaNV, HoTen
select * from v9
--10.Lấy ra tên sản phẩm được xuất nhiều nhất trong năm 2010.
create view v10
as
	SELECT TOP 1 TenSP, SUM(SOLUONG) AS [SỐ LƯỢNG ĐƯỢC XUẤT]
	FROM SanPham A, CTPX B, PhieuXuat C
	WHERE A.MaSP = B.MaSP AND B.MaPX = C.MaPX AND YEAR(NgayLap) = '2010'
	GROUP BY TenSP

	SELECT* FROM v10
go
--Tạo các Function sau:
--1Function F1 có 2 tham số vào là: tên sản phẩm, năm. Function cho biết: số lượng xuất
--kho của tên sản phẩm đó trong năm này. (Chú ý: Nếu tên sản phẩm đó không tồn tại thì
--phải trả về 0)
create function F1
(
	@tensp nvarchar(40)
	,@nam datetime
)
returns int
as
begin
	declare @sl int
	if @tensp is NULL
		return 0
	else
		select @sl = sum(SL)
		from CTPX a, PhieuXuat b, SanPham c
		where a.MaSP = c.MaSP and b.MaPX = a.MaPX and year(Ngaylap)=@nam and c.TenSP = @tensp
	return @sl;
end

select dbo.F1 (N'Gạch',2010) as [Số lượng xuất kho trong năm này]
drop function dbo.F1
--2Function F2 có 1 tham số nhận vào là mã nhân viên. Function trả về số lượng phiếu xuất của nhân viên truyền vào. Nếu nhân viên này không tồn tại thì trả về 0.
create function F2
(
	@manv char(5)
)
returns int
as
begin
	declare @sl int
	if @MaNV is NULL
		set @MaNV = 0
	else
		select @sl = count(c.MaPX)
		from NhanVien a, PhieuXuat c, CTPX b
		where a.MaNV = c.MaNV and b.MaPX = c.MaPX and a.MaNV = @manv
	return @sl;
end

select dbo.F2 ('NV01') as [Số lượng phiếu xuất của nhân viên]
drop function dbo.F2
--3.	Function F3 có 1 tham số vào là năm, trả về danh sách các sản phẩm được xuất trong năm truyền vào. 
create function F3
(
	@nam int
)
returns @SP table
(
	MaSP int,
	TenSP nvarchar(40),
	NgayLap datetime
)
as
begin
	insert into @SP
	select a.MaSP,TenSP,NgayLap
				from SanPham a , CTPX b, PhieuXuat c
				where a.MaSP = b.MaSP and b.MaPX = c.MaPX and year(NgayLap) = @nam
	return
end

select * from dbo.F3('2010') as [DS các sp được xuất trong năm]
drop function dbo.F3
--4.	Function F4 có một tham số vào là mã nhân viên để trả về danh sách các phiếu xuất của nhân viên đó. Nếu mã nhân viên không truyền vào thì trả về tất cả các phiếu xuất.
create function F4
(
	@manv char(5)
)
returns @PX table
(
	MaPX int,
	NgayLap datetime,
	MaNV char(5)
)
as
begin
		insert into @PX
		select b.MaPX,NgayLap,a.MaNV
		from NhanVien a, PhieuXuat b, CTPX c
		where a.MaNV = b.MaNV and b.MaPX = c.MaPX and a.MaNV = @manv
		return
end

select * from dbo.F4('NV01')
drop function dbo.F4
--5.	Function F5 để cho biết tên nhân viên của một phiếu xuất có mã phiếu xuất là tham số truyền vào.
create function F5
(
	@mapx int
)
returns nvarchar(40)
as
begin
	declare @tennv varchar(40) 
	set @tennv=(select HoTen from NhanVien a,PhieuXuat b where a.MaNV = b.MaNV and b.MaPX = @mapx)
	return @tennv
end

select dbo.F5(4)
drop function dbo.F5
--6.	Function F6 để cho biết danh sách các phiếu xuất từ ngày T1 đến ngày T2. (T1, T2 là tham số truyền vào). Chú ý: T1 <= T2.
CREATE FUNCTION F6(@T1 DATE, @T2 DATE)
returns @PHIEUXUAT TABLE
(
	MaPX INT,
	Ngaylap DATE,
	MaNV CHAR(5)
)
AS
BEGIN
	INSERT INTO @PHIEUXUAT
	select B.MaPX, Ngaylap, A.MaNV
	FROM NhanVien A, PhieuXuat B, CTPX C
	WHERE A.MaNV = B.MaNV and B.MaPX = C.MaPX and NgayLap between @T1 and @T2 and @T1 <= @T2
	RETURN
END

select * from dbo.F6 ('2010-02-03','2010-06-16')

--7.	Function F7 để cho biết ngày xuất của một phiếu xuất với mã phiếu xuất là tham số truyền vào.
create function F7
(
	@mapx int
)
returns date
as
begin
	declare @ngayxuat date
	set @ngayxuat = (select NgayLap
						from PhieuXuat a,CTPX b
						where a.MaPX=@mapx and a.MaPX = b.MaPX)
	return @ngayxuat
end

select dbo.F7 as [Ngày xuất của 1 phiếu]
drop function dbo.F7

-------------------------PROCEDUCE------------------
--1.	Procedure tên là P1 cho có 2 tham số sau:
--•	1 tham số nhận vào là: tên sản phẩm.
--•	1 tham số trả về cho biết: tổng số lượng xuất kho của tên sản phẩm này trong năm 2010 
--(Không viết lại truy vấn, hãy sử dụng Function F1 ở câu 4 để thực hiện)
CREATE PROC P1(@TENSP NVARCHAR(30))
AS
	BEGIN
		SELECT A.MaSP, TenSP, SUM(SOLUONG) as [TỔNG SỐ LƯỢNG XUẤT KHO]
		FROM SanPham A, CTPX B, PhieuXuat C
		WHERE A.MaSP = B.MaSP AND B.MaPX = C.MaPX AND YEAR(NgayLap) = '2010' AND TenSP = @TENSP
		GROUP BY A.MaSP, TenSP
	END

EXEC P1 N'Đậu xanh'		

--2.	Procedure tên là P2 có 2 tham số sau:
--•	1 tham số nhận vào là: tên sản phẩm.
--•	1 tham số trả về cho biết: tổng số lượng xuất kho của tên sản phẩm này trong khoảng thời gian từ đầu tháng 4/2010 đến hết tháng 6/2010 
--(Chú ý: Nếu tên sản phẩm này không tồn tại thì trả về 0)
CREATE PROC P2(@TENSP NVARCHAR(30))
AS
	BEGIN
		SELECT A.MaSP, TENSP, SUM(SOLUONG) as [TỔNG SỐ LƯỢNG XUẤT KHO]
		FROM SanPham A, CTPX B, PhieuXuat C
		WHERE A.MaSP = B.MaSP AND B.MaPX = C.MaPX AND CONVERT(nvarchar, NgayLap) BETWEEN '4/2010' AND '6/2010' AND TENSP = @TENSP
		GROUP BY A.MaSP, TenSP
	END
DROP PROC P2
EXEC P2 N'Gạch'

--3.	Procedure tên là P3 chỉ có duy nhất 1 tham số nhận vào là tên sản phẩm. 
--Trong Procedure này có khai báo 1 biến cục bộ được gán giá trị là: số lượng xuất kho của tên sản phẩm này trong khoảng thời gian từ đầu tháng 4/2010 đến hết tháng 6/2010. 
--Việc gán trị này chỉ được thực hiện bằng cách gọi Procedure P2.
CREATE PROC P2(@TENSP NVARCHAR(30))
AS
	BEGIN
		SELECT A.MaSP, TenSP, SUM(SOLUONG) as [TỔNG SỐ LƯỢNG XUẤT KHO]
		FROM SanPham A, CTPX B, PhieuXuat C
		WHERE A.MaSP = B.MaSP AND B.MaPX = C.MaPX AND CONVERT(nvarchar, NgayLap) BETWEEN '4/2010' AND '6/2010' AND TENSP = @TENSP
		GROUP BY A.MaSP, TenSP
	END
DROP PROC P2
EXEC P2 N'Xi măng'


--4.	Procedure P4 để INSERT một record vào trong table LOAI. Giá trị các field là tham số truyền vào.
CREATE PROCEDURE P4(@ MALOAI INT, @TENLOAI NVARCHAR)
AS 
BEGIN 
	INSERT INTO Loai(MaLoai, TenLoai) 
	VALUES (@MALOAI, @TENLOAI) 
END 
	
--5.	Procedure P5 để DELETE một record trong Table NhânViên theo mã nhân viên. Mã NV là tham số truyền vào.
CREATE PROCEDURE P5(@MANV CHAR(5)) 
AS 
BEGIN 
	DELETE FROM NhanVien
	WHERE MaNV = @MANV 
END 

--Viết các trigger để thực hiện các ràng buộc sau:
--1.	Chỉ cho phép một phiếu xuất có tối đa 5 chi tiết phiếu xuất.
CREATE TRIGGER T1 ON CTPX
FOR INSERT, UPDATE
AS
	IF(EXISTS (SELECT A.MaPX, COUNT(A.MaPX)
			   FROM CTPX A, inserted I
			   WHERE A.MaPX = I.MaPX
			   GROUP BY A.MaPX
			   HAVING COUNT(MaPX) > 5)
BEGIN
		PRINT 'MOI PHIEU XUAT CO TOI DA 5 CHI TIET PHIEU XUAT'
		ROLLBACK TRAN
END


--2.	Chỉ cho phép một nhân viên lập tối đa 10 phiếu xuất trong một ngày.
CREATE TRIGGER T1 ON PhieuXuat
FOR INSERT, UPDATE
AS
	IF(EXISTS (SELECT A.MaNV, COUNT(A.MaPX)
			   FROM PhieuXuat A, inserted I
			   WHERE A.MaPX = I.MaPX and DAY(NgayLap) = 1
			   GROUP BY A.MaPX
			   HAVING COUNT(MaPX) > 10) 
BEGIN
		PRINT 'MOI NHAN VIEN LAP TOI DA 10 PHIEU XUAT TRONG 1 NGAY'
		ROLLBACK TRAN
END


--3.	Khi người dùng viết 1 câu truy vấn nhập 1 dòng cho bảng chi tiết phiếu xuất thì CSDL kiểm tra, 
--nếu mã phiếu xuất mới đó chưa tồn tại trong bảng phiếu xuất thì CSDL sẽ không cho phép nhập và thông báo lỗi “Phiếu xuất này không tồn tại”. Hãy viết 1 trigger đảm bảo điều này.
CREATE TRIGGER T3 ON CTPX
FOR INSERT, UPDATE
AS
	IF EXISTS (SELECT *
			   FROM CTPX A, inserted I
			   WHERE A.MaPX = I.MaPX)
BEGIN
	PRINT N'PHIẾU XUẤT TRONG TỒN TẠI'
	ROLLBACK TRAN
END

INSERT INTO CTPX VALUES ('9', '6', '30')