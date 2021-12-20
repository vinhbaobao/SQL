--CAU 1
create or alter view v1
as
SELECT DISTINCT MAKH, TENKH, DIACHI, DT, EMAIL
FROM            dbo.KHACHHANG
WHERE        (DIACHI = N'Tân Bình')
go
--CAU2
create or alter view v2
as
SELECT DISTINCT MAKH, TENKH, DIACHI, EMAIL, DT
FROM            dbo.KHACHHANG
WHERE        (DT IS NULL)
go
--CAU3
create or alter view v3
as
SELECT DISTINCT MAKH, TENKH, DIACHI
FROM            dbo.KHACHHANG
WHERE        (DT IS NULL) AND (EMAIL IS NULL)
go
--CAU4
create or alter view v4
as
SELECT DISTINCT MAKH, TENKH, DIACHI, DT, EMAIL
FROM            dbo.KHACHHANG
WHERE        (NOT (DT IS NULL)) AND (NOT (EMAIL IS NULL))
go
--CAU5
create or alter view v5
as
SELECT DISTINCT MAVT, TENVT, GIAMUA
FROM            dbo.VATTU
WHERE        (DVT = N'Cái')
go
--cau6
create or alter view v6
as
SELECT DISTINCT MAVT, TENVT, DVT, GIAMUA
FROM            dbo.VATTU
WHERE        (GIAMUA > 25000)
go
--cau7 hien thi ten thi ta dung like va %
create or alter view v7
as
SELECT DISTINCT MAVT, TENVT, DVT, GIAMUA
FROM            dbo.VATTU
WHERE        (TENVT  like N'Gạch%')
go
--cau8
SELECT        MAVT, TENVT, DVT, GIAMUA
FROM            dbo.VATTU
WHERE        (GIAMUA BETWEEN 20000 AND 40000)
---
CREATE VIEW V8 AS
	SELECT MAVT,TENVT,DVT,GiaMua
	FROM VatTu
	WHERE GiaMua BETWEEN 20000 AND 40000
GO
--cau9
create or alter view v9
as
SELECT DISTINCT dbo.HOADON.MAHD, dbo.HOADON.NGAY, dbo.KHACHHANG.TENKH, dbo.KHACHHANG.DIACHI, dbo.KHACHHANG.DT
FROM            dbo.HOADON INNER JOIN
                         dbo.KHACHHANG ON dbo.HOADON.MAKH = dbo.KHACHHANG.MAKH
go
--cau10
create or alter view v10
as
SELECT DISTINCT dbo.HOADON.MAHD, dbo.KHACHHANG.TENKH, dbo.KHACHHANG.DIACHI, dbo.KHACHHANG.DT
FROM            dbo.HOADON INNER JOIN
                         dbo.KHACHHANG ON dbo.HOADON.MAKH = dbo.KHACHHANG.MAKH
WHERE        (dbo.HOADON.NGAY = CONVERT(DATETIME, '2010-05-25 00:00:00', 102))
go
--neu can thi xoa khang k co so dt 
SELECT DISTINCT dbo.HOADON.MAHD, dbo.KHACHHANG.TENKH, dbo.KHACHHANG.DIACHI, dbo.KHACHHANG.DT
FROM            dbo.HOADON INNER JOIN
                         dbo.KHACHHANG ON dbo.HOADON.MAKH = dbo.KHACHHANG.MAKH
WHERE        (dbo.HOADON.NGAY = CONVERT(DATETIME, '2010-05-25 00:00:00', 102)) AND (NOT (dbo.KHACHHANG.DT IS NULL))
--cau11
create or alter view v18
as
SELECT*
	FROM HoaDon,KhachHang
	WHERE HoaDon.MAKH = KhachHang.MAKH and  month(HoaDon.Ngay) = '6' and year(HoaDon.Ngay) ='2010'
GO
--cau12
create or alter view v12
as
SELECT        dbo.KHACHHANG.MAKH, dbo.KHACHHANG.TENKH, dbo.KHACHHANG.DIACHI, dbo.KHACHHANG.DT, dbo.KHACHHANG.EMAIL, dbo.HOADON.MAHD, dbo.HOADON.NGAY, dbo.HOADON.MAKH AS Expr1, dbo.HOADON.TONGTG
FROM            dbo.KHACHHANG INNER JOIN
                         dbo.HOADON ON dbo.KHACHHANG.MAKH = dbo.HOADON.MAKH
WHERE        (MONTH(dbo.HOADON.NGAY) = '6') AND (YEAR(dbo.HOADON.NGAY) = '2010')
go
--cau13
create or alter view v13
as
SELECT DISTINCT MAKH, TENKH, DIACHI, DT, EMAIL
FROM            dbo.KHACHHANG
WHERE        (MAKH NOT IN
                             (SELECT        MAKH
                               FROM            dbo.HOADON
                               WHERE        (MONTH(NGAY) = '6') AND (YEAR(NGAY) = '2010')))
go
--cau14
create or alter view v14
as
SELECT        c.MAHD, c.MAVT, v.TENVT, v.DVT, c.GIABAN, v.GIAMUA, c.SL, v.GIAMUA * c.SL AS [Tri gia mua], c.GIABAN * c.SL AS [TRI GIA BAN]
FROM            dbo.CTHD AS c INNER JOIN
                         dbo.VATTU AS v ON c.MAVT = v.MAVT
go
--cau15
create or alter view v15
as
SELECT CTHD.MAHD , VatTu.MAVT,TENVT,GiaBan,GiaMua,SL,(GiaMua*SL) as N'Trị Gia Mua',(GiaBan*SL) as N'Tri giá bán'
	FROM VatTu,CTHD
	WHERE VatTu.MAVT = CTHD.MAVT and GiaBan>=GiaMua
go
--cau16
SELECT        C.MAHD AS [Mã HD], C.MAVT AS [Mã VT], V.TENVT AS [Tên VT], V.DVT AS [Đơn vị tính], C.GIABAN AS [Giá bán], V.GIAMUA AS [Giá mua], C.SL AS [Số lượng], V.GIAMUA * C.SL AS [Trị giá mua], C.GIABAN * C.SL AS [Trị giá bán], 
                         CASE WHEN SL > 100 THEN (0.1 * C.SL * C.GIABAN) ELSE 0 END AS [Khuyến mãi]
FROM            dbo.CTHD AS C INNER JOIN
                         dbo.VATTU AS V ON C.MAVT = V.MAVT AND C.MAVT = V.MAVT
---
CREATE VIEW TTHD_06
AS
(
	SELECT C.MAHD [Mã HD], C.MAVT [Mã VT], V.TENVT [Tên VT], V.DVT [Đơn vị tính], C.GIABAN [Giá bán], V.GIAMUA [Giá mua], C.SL [Số lượng], (V.GIAMUA * C.SL) [Trị giá mua], (C.GIABAN * SL) [Trị giá bán], CASE WHEN SL > 100 THEN (0.1*C.SL*C.GIABAN) ELSE 0 END [Khuyến mãi]
	FROM dbo.CTHD C, dbo.VATTU V
	WHERE C.MAVT = V.MAVT
	)
	select*
	from TTHD_06
--cau17
SELECT        MAVT, TENVT, DVT, GIAMUA, SLTON
FROM            dbo.VATTU
WHERE        (MAVT NOT IN
                             (SELECT        MAVT
                               FROM            dbo.CTHD))
--cah khac
CREATE or alter view  v17 AS
SELECT*
	FROM VATTU
	WHERE MAVT not in(

	SELECT MAVT
	FROM CTHD)
GO
--cau18
create or alter view v18
as
SELECT        dbo.HOADON.MAHD, dbo.HOADON.NGAY, dbo.KHACHHANG.TENKH, dbo.KHACHHANG.DIACHI, dbo.KHACHHANG.DT, dbo.VATTU.TENVT, dbo.VATTU.DVT, dbo.VATTU.GIAMUA, dbo.CTHD.GIABAN
FROM            dbo.CTHD INNER JOIN
                         dbo.VATTU ON dbo.CTHD.MAVT = dbo.VATTU.MAVT INNER JOIN
                         dbo.HOADON ON dbo.CTHD.MAHD = dbo.HOADON.MAHD INNER JOIN
                         dbo.KHACHHANG ON dbo.HOADON.MAKH = dbo.KHACHHANG.MAKH
go
--cau19
create or alter view v19
as
	select CTHD.MAHD , VatTu.MAVT,TENVT,GiaBan,GiaMua,SL,(GiaMua*SL) as N'Trị Gia Mua',(GiaBan*SL) as N'Tri giá bán'
	from VatTu,CTHD
	where VatTu.MAVT = CTHD.MAVT and GiaBan>=GiaMua
go
--cau20
create or alter view v20
as
	select MAHD , VatTu.MAVT,TENVT,GiaBan,GiaMua,SL,(GiaMua*SL) as N'Trị Gia Mua',(GiaBan*SL) as N'Tri giá bán',KhuyenMai = case when (sl>100) then 0.1 else 0 end
	from VatTu,CTHD
	where VatTu.MAVT = CTHD.MAVT
go
--cau21
create or alter view v21
as
	select CTHD.MAHD, TENKH,DIACHI,sum(sl*GiaBan)
	from HOADON, KHACHHANG ,CTHD
	where HOADON.MAKH = KHACHHANG.MAKH and CTHD.MAHD = KHACHHANG.MAKH
	group by CTHD.MAHD,TENKH,DIACHI

	select*
	from CTHD
go
--cau22.Lấy ra hóa đơn có tổng trị giá lớn nhất gồm các thông tin: Số hóa đơn, ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của hóa đơn.
create view v22
as
	select top 1 with ties c.MAHD, Ngay,k.TENKH,DIACHI,sum(SL*GIABAN) as TONGTG
	from CTHD c, HOADON h, VATTU v, KHACHHANG k
	where  c.MAVT=v.MAVT and c.MAHD=h.MAHD and h.MAKH=k.MAKH
	group by c.MAHD,NGAY,k.TENKH,DIACHI
	order by sum(SL*GIABAN) desc
--cau23
create view v23
as
	select top 1 with ties c.MAHD,NGAY,k.TENKH,DIACHI,sum(SL*GIABAN) as TONGTG
	from CTHD c, HOADON h, VATTU v,KHACHHANG k
	where c.MAVT =v.MAVT and c.MAHD= h.MAHD and h.MAKH=k.MAKH and CONVERT(varchar(10),NGAY,103) like'_/05/2010'
	group by c.MAHD,NGAY,k.TENKH,DIACHI
	order by sum(SL*GIABAN) desc
--cau24
create view v24
as
select  KHACHHANG.MAKH, KHACHHANG.TENKH, COUNT(*) AS soluonghoadon
FROM            dbo.KHACHHANG INNER JOIN
                         dbo.HOADON ON dbo.KHACHHANG.MAKH = dbo.HOADON.MAKH
GROUP BY KHACHHANG.MAKH, KHACHHANG.TENKH
go
--cau25
create or alter view v25
as
SELECT k.MAKH,   k.TENKH, COUNT(h.MAHD) AS SOHOADON, MONTH(h.NGAY) AS THANG
FROM            dbo.KHACHHANG AS k INNER JOIN
                         dbo.HOADON AS h ON k.MAKH = h.MAKH
WHERE        (MONTH(h.NGAY) BETWEEN 1 AND 12)
GROUP BY K.MAKH,k.TENKH, MONTH(h.NGAY)
go
--cau26

create or alter view v26
as
	select top 1 with ties kh.MAKH, kh.TENKH, kh.DIACHI, kh.DT,kh.EMAIL,count(*)AS SLHDNN
	from KHACHHANG kh join HOADON hd
	on HD.MAKH=KH.MAKH
	group by kh.MAKH,kh.TENKH,kh.DIACHI,kh.DT,kh.EMAIL
	order by count(*)desc
go

--cau27
create or alter view v27
as
select TOP (1) WITH TIES k.TENKH, SUM(c.SL) AS SOLUONGHANG
FROM            dbo.KHACHHANG AS k INNER JOIN
                         dbo.HOADON AS h ON k.MAKH = h.MAKH INNER JOIN
                         dbo.CTHD AS c ON h.MAHD = c.MAHD
GROUP BY k.TENKH
ORDER BY SOLUONGHANG DESC
go
--Cau28
create or alter view v28

as
SELECT DISTINCT MAVT, TENVT, DVT, GIAMUA, SLTON
FROM            dbo.VATTU
WHERE        (MAVT IN
                             (SELECT        TOP (1) WITH TIES MAVT
                               FROM            dbo.CTHD AS C
                               GROUP BY MAVT
                               ORDER BY COUNT(MAHD) DESC))
go
--29
create or alter view V29
as
	select top 10 with ties A.MAVT, A.TENVT,A.DVT,A.GIAMUA,A.SLTON,SUM(B.sl) as[SoLuongDaBan]
	from VATTU A inner join CTHD B
	on A.MAVT = B.MAVT
	group by A.MAVT, A.TENVT,A.DVT,A.GIAMUA,A.SLTON
	order by SUM(B.sl) desc
--30
create or alter view v30
as
	select k.MAKH,TENKH,DIACHI,sum(SL*GIABAN) as TONGTG
	from KHACHHANG k,HOADON h,CTHD c
    where H.MAHD=C.MAHD and K.MAKH=H.MAKH
	group by k.MAKH ,TENKH,DIACHI
go
--Tạo các procedure sau:
--1
	create proc sp_DSKH(@X int)
	as
		begin
			select*
			from KHACHHANG,HOADON
			where KHACHHANG.MAKH = HOADON.MAHD and day(NGAY)=@X
		end
	exec  sp_DSKH 25
--2 lay da ds khach hang co tong gt don hang lon nhat 
create proc sp_DSKHtonglonnhat
as
begin
	select top 5 TongTG ,KHACHHANG.MAKH,TENKH
	from HOADON,KhachHang
	where HOADON.MAKH = KHACHHANG.MAKH
	order by TongTG desc
end
exec sp_DSKHtonglonnhat
		select*
		from HOADON
--4.	Lấy ra danh sách X mặt hàng có số lượng bán lớn nhất.
	create proc sp_dskhtonglonnhatx
	as
		begin
			select top 10 sl ,TENVT
			from CTHD,VatTu
			where CTHD.MAVT = VATTU.MAVT
			order by sl desc
		end
	exec sp_dskhtonglonnhatx
----5.	Lấy ra danh sách x mặt hàng bán ra có lãi ít nhất.
create proc sp_laiitnhat
as
	begin
		select top 10 sl ,TENVT
		from CTHD,VATTU
		where CTHD.MAVT = VATTU.MAVT
		order by sl asc
end
	select*
	from VATTU
	select*
	from CTHD
--6Lấy ra danh sách X đơn hàng có tổng trị giá lớn nhất (X là tham số).
CREATE PROC BANHANG_06 @X INT
AS
	BEGIN
		SELECT C.MAHD, SUM(C.SL*C.GIABAN) [TỔNG TRỊ GIÁ]
		FROM KHACHHANG K,HOADON H,CTHD C
		WHERE K.MAKH = H.MAKH AND C.MAHD = H.MAHD
		GROUP BY C.MAHD 
		HAVING SUM(SL*GIABAN) > @X
	END
--7	Tính giá trị cho cột khuyến mãi như sau: Khuyến mãi 5% nếu SL >100, 10% nếu SL>500.
create proc sp_capnhatkm
	as
		begin
			select MAHD,SL,KHUYENMAI = case when (sl>100 and sl<=500) then '5%' when (sl>500) then '10%' end 
			from  CTHD
			
		end
	update CTHD set SL=700 where MAHD=4
	exec sp_capnhatkm
--8	Tính số lại số lượng tồn cho tất cả các mặt hàng. (SLTON = SLTON – tổng sl bán được)
create proc sp_tongslban
as
	begin
		select VATTU.MAVT,TENVT,slton=(SlTon-sum(sl))
		from VATTU,CTHD
		where VATTU.MAVT = CTHD.MAVT
		group by VATTU.MAVT,TENVT,SlTon
end

	select*
	from CTHD
	select*
	from VATTU
--9	Tính trị giá cho mỗi hoá đơn.
create proc sp_trigia
	as
	begin
		select HOADON.MAHD,TONGTG=(sl*GIABAN)
		from HOADON,CTHD
		where HOADON.MAHD = CTHD.MAHD
		group by HOADON.MAHD,TONGTG,SL,GIABAN
	end
--10	Tạo ra table KH_VIP có cấu trúc giống với cấu trúc table KHACHHANG. Lưu các khách hàng có tổng trị giá của tất cả các đơn hàng >=10000000 vào table KH_VIP.
		
create table KH_VIP
(
MAKH int primary key,
TENKH nvarchar(50),
DIACHI nvarchar(50),
DT nvarchar(50),
EMAIL nvarchar(50)
)
drop table KH_VIP
drop proc KH_VIP
	select*
	from KH_VIP
	alter proc sp_tao_bang
	as
		begin
			declare @MAKH int
			declare @TENKH nvarchar(50)
			declare @diachi nvarchar(50)
			declare @DT nvarchar(50)
			declare @EMAIL nvarchar(50)

			select @MAKH=MAHD,@TENKH=TENKH,@DIACHI=DIACHI,@DT=DT,@EMAIL=EMAIL
			from HOADON,KHACHHANG
			where HOADON.MAKH= KHACHHANG.MAKH and TongTG>=10000000
			group by MAHD,TONGTG,TENKH,DIACHI,DT,EMAIL

			declare @i int
			set @i=0
			
			insert into KH_VIP values(@MAKH,@TENKH,@DIACHI,@DT,@EMAIL)
		end
		select*
		from HOADON,KHACHHANG
		where HOADON.MAKH= KHACHHANG.MAKH and TongTG>=10000000
		update HOADON set TONGTG=12000000 where makh=2

			select HOADON.mahd,TONGTG=(sl*GiaBan)
			from HOADON,CTHD
			where HOADON.MAHD = CTHD.MAHD
			group by HOADON.MAHD,TONGTG,sl,GiaBan

	exec  sp_tao_bang

	select*
	from KH_VIP
--Câu 4: Tạo các function sau:
--1.	Viết  hàm tính doanh thu cuả năm.. với năm là tham số truyền  vào.
	alter function fun_doanhthu_nam(@nam int)
	returns int
	as
	begin
			return (
					select sum(tongtg)
					from HoaDon
					where YEAR(Ngay)=@nam)
	end

	select dbo.fun_doanhthu_nam(2000)
--2.	Viết  hàm tính doanh thu cuả tháng .. với tháng là tham số truyền  vào.
	alter function fun_doanhthu_thang(@thang int)
	returns int
	as
	begin
			return (
					select sum(TONGTG)
					from HOADON
					where month(NGAY)=@thang)
	end

	select dbo.fun_doanhthu_thang(1)
	
--3.	Viết hàm tính doanh thu của khách hàng với  mã khách hàng là tham số truyền vào.
	create function fun_doanhthu_makh(@makh int)
	returns int
	as
	begin
			return (
					select sum(TONGTG)
					from HOADON
					where  HOADON.MAKH=@makh)
	end

	select dbo.fun_doanhthu_thang(1)
--4.	Viết hàm tính tổng số lượng bán được cho từng mặt hàng theo tháng với  mã hàng và thàng nhập vào,  nếu tháng không nhập vào tức là tính tất cả các tháng.
	alter function fun_doanhthu_tungmathang (@mavt int,@thang int)
	returns int
	as
	begin
		declare @tinhtong int
		
			if not exists(
								select *
								from HOADON
								where MONTH(NGAY) = @thang
							
			)
				
								set @tinhtong=(select sum(sl)
												from CTHD
												
												)
			
			else
				set @tinhtong=
				(select sum(sl)
				from CTHD,HOADON
				where CTHD.MAHD=HOADON.MAHD and MONTH(NGAY) = @thang and MAVT=@mavt
				group by month(NGAY)
				)
			return @tinhtong
		end			
	select dbo.fun_doanhthu_tungmathang (1,null)
--5.Viết hàm tính lãi ((giá bán – giá mua) * số lượng bán được) cho từng mặt hàng, với mã
--mặt hàng là tham số truyền vào. Nếu mã mặt hàng không truyền vào thì tính cho tất cả
--các mặt hàng.
CREATE FUNCTION	LAI (@MAVT INT)
RETURNS	INT
AS
BEGIN
	DECLARE @KQ INT
	 SELECT @KQ= SUM((C.GIABAN - V.GIAMUA) * C.SL) 
		  FROM VATTU V,CTHD C
		  WHERE V.MAVT = C.MAVT 
		  GROUP BY V.MAVT
		  RETURN @KQ
	END

--5Tạo các trigger để thực hiện các ràng buộc sau:
--1. Thực hiện việc kiểm tra các ràng buộc khóa ngoại.
CREATE TRIGGER T1 ON HOADON
FOR INSERT
AS 
BEGIN 
	DECLARE @MAKH VARCHAR(10), @MAHD VARCHAR(10), @NGAY DATE, @TONGTG FLOAT
	SELECT @MAKH = MAKH, @MAHD = MAHD, @NGAY = NGAY, @TONGTG = TONGTG FROM INSERTED
	IF ((SELECT count(*) FROM KHACHHANG WHERE @MAKH = KHACHHANG.MAKH) = 0)
	BEGIN
		PRINT(N'Không tồn tại mã khách hàng')
		ROLLBACK TRAN
	END 
	ELSE 
	BEGIN 
		INSERT dbo.HOADON
		values (@MAHD, @NGAY, @MAKH, @TONGTG)
	END
END 

SET DATEFORMAT DMY
INSERT dbo.HOADON VALUES('HD011',	'12/05/2010', 'KH01',	NULL)

--2. Không cho phép CASCADE DELETE trong các ràng buộc khóa ngoại. Ví dụ không 
--cho phép xóa các HOADON nào có SOHD còn trong table CTHD.
DROP TRIGGER tg2
CREATE trigger tg2 on HOADON
for delete
as
	declare @mahd char(10)
	select @mahd = MAHD from deleted
	if exists(
		select MAHD 
		from CTHD
		where MAHD = @mahd 
	)
	begin	
		print N'Không được xóa hóa đơn này'
		rollback tran
	end
DELETE HOADON where MAHD = 'HD001'
--3. Không cho phép user nhập vào hai vật tư có cùng tên.
create trigger tg3 on VATTU
for insert, update
as
	declare @MAVT char(5), @TENVT nvarchar(30)
	select @MAVT = MAVT, @TENVT = TENVT from inserted
	if exists(
		select  MAVT
		from  VATTU
		where MAVT <> @MAVT and TENVT = @TENVT
	)
	begin	
		print N'Không được nhập cùng tên'
		rollback tran
	end
--4. Khi user đặt hàng thì KHUYENMAI là 5% nếu SL > 100, 10% nếu SL > 500.
update CTHD
set KHUYENMAI = ( 
					select (case when SL>500 then 0.1*SL*GIABAN
					when SL > 100 then 0.05*SL*GIABAN else 0 end) 
					from  CTHD c
					where c.MAHD = CTHD.MAHD
					)
ALTER trigger T4 on CTHD
for insert, update
as
	declare @soluong int, @giaban float, @MAHD CHAR(10)
	select @soluong = SL, @giaban = GIABAN, @MAHD = MAHD from inserted
	update CTHD
	SET KHUYENMAI = ( SELECT (CASE WHEN SL>500 THEN 0.1*@soluong*@giaban 
								WHEN SL > 100 THEN 0.05*@soluong*@giaban ELSE 0 END)
					FROM CTHD C
					WHERE C.MAHD = @MAHD )
	WHERE MAHD = @MAHD
--5. Chỉ cho phép mua các mặt hàng có số lượng tồn lớn hơn hoặc bằng số lượng cần mua và 
--tính lại số lượng tồn mỗi khi có đơn hàng.
CREATE trigger T5 on CTHD 
for insert
as
	BEGIN
		DECLARE @SL INT, @MAVT CHAR(5)
		SELECT  @SL = SL,@MAVT = MAVT FROM INSERTED
		IF(@SL > (SELECT SLTON FROM VATTU WHERE @MAVT = MAVT))
		BEGIN
			PRINT N'CHỈ ĐƯỢC MUA MẶT HÀNG CÓ SLTON LỚN HƠN SL MUA'
			ROLLBACK TRAN
		END
	ELSE
		BEGIN
			UPDATE VATTU
			SET SLTON = SLTON - @SL 
			WHERE MAVT = @MaVT  
			PRINT N'CẬP NHẬT THÀNH CÔNG'
		END
	END
--7. Mỗi hóa đơn cho phép bán tối đa 5 mặt hàng.
CREATE trigger T7 on CTHD 
for insert
as
	BEGIN
		DECLARE @MAVT CHAR(5), @MAHD CHAR(10)
		SELECT @MAVT = MAVT, @MAHD = MAHD FROM INSERTED
		IF(EXISTS(SELECT COUNT() FROM CTHD WHERE @MaVT = MAVT AND @MAHD = MAHD GROUP BY MAHD HAVING COUNT() > 5))
			BEGIN
				PRINT N'CHỈ ĐƯỢC BÁN TỐI ĐA 5 MẶT HÀNG CHO 1 HÓA ĐƠN VUI LÒNG ĐỔI HÓA ĐƠN KHÁC'
				ROLLBACK TRAN
			END
	END
--8. Mỗi hóa đơn có tổng trị giá tối đa 50000000.
CREATE TRIGGER  T8 on CTHD
for insert, update
as
		BEGIN
				DECLARE @MAHD CHAR(10)
				SELECT @MAHD = MAHD FROM INSERTED
				IF((SELECT SUM(SL*GIABAN) FROM CTHD WHERE CTHD.MAHD = @MAHD)>50000000)
				BEGIN
					PRINT N'KHÔNG ĐƯỢC VƯỢT QUÁ 50000000'
					ROLLBACK TRAN
				END
		END

--9.	Không được phép bán hàng lỗ quá 50%.
CREATE TRIGGER T9 ON CTHD 
FOR INSERT, UPDATE 
AS 
	BEGIN
		DECLARE @tong float 
		DECLARE @sl int, @giaBan float, @mahd varchar(10), @maVT varchar(10)
		SELECT @sl = SL, @giaBan = GIABAN, @mahd = MAHD, @maVT = MAVT, @tong = (@sl*giaBan) - KHUYENMAI
		FROM INSERTED
		
		IF(@tong < (SELECT @sl*GIAMUA
					FROM VATTU
					WHERE VATTU.MAVT = @maVT
					)/2) 
			BEGIN 
				print(N'Không được bán mặt hàng lỗ hơn 50%')
				ROLLBACK TRAN
			END
	END