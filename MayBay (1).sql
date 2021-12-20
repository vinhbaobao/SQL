create database MAYBAY
on
(
	name='MayBay_Data',
	filename='D:\Database\MAYBAY.MDF'
)
log on
(
	name='MayBay_Log',
	filename='D:\Database\MAYBAY.LDF'
)
use MAYBAY
create table MAYBAY
(
	MaMB	int primary key,
	Loai	nvarchar(50),
	TamBay	int
)
create table CHUYENBAY
(
	MaCB	char(5) primary key,
	GaDi	varchar(50),
	GaDen	varchar(50),
	DoDai	int,
	GioDi	time,
	GioDen	time,
	ChiPhi	int,
	MaMB	int,
	foreign key(MaMB) references MAYBAY(MaMB)
	on update cascade
	on delete set null
)
create table NHANVIEN
(
	MaNV	char(9) primary key,
	Ten		nvarchar(50),
	Luong	int
)
create table CHUNGNHAN
(
	MaNV	char(9),
	MaMB	int,
	primary key(MaNV,MaMB),
	foreign key(MaNV) references NHANVIEN(MaNV)
	on update cascade
	on delete cascade,
	foreign key(MaMB) references MAYBAY(MaMB)
	on update cascade
	on delete cascade
)
--Tạo diagram
--Nhập dữ liệu
--Truy vấn:
--Cau1Cho biết các đường bay nào có thể đáp ứng yêu cầu đi thẳng từ ga A đến ga B rồi quay trở về ga A.
SELECT        A.MaCB AS Đi, A.GaDi, A.GaDen, B.MaCB AS [Khứ hồi], B.GaDi AS GaDiKh, B.GaDen AS GaDenKh
FROM            dbo.CHUYENBAY AS A INNER JOIN
                         dbo.CHUYENBAY AS B ON A.MaCB != B.MaCB AND A.GaDen = B.GaDi AND A.GaDi = B.GaDen
--Cau2Với mỗi loại máy bay có phi công lái cho biết mã số, loại máy báy và tổng số phi công có thể lái loại máy bay đó.
SELECT        M.Loai, COUNT(C.MaMB) AS [Số phi công lái máy bay đó]
FROM            dbo.MAYBAY AS M INNER JOIN
                         dbo.CHUNGNHAN AS C ON M.MAMB = C.MaMB
GROUP BY M.Loai
--Cau3Với mỗi ga có chuyến bay xuất phát từ đó cho biết tổng chi phí phải trả cho phi công lái các chuyến bay khởi hành từ ga đó.
SELECT        C.GaDi, SUM(N.Luong) AS [Tổng chi phí phải trả cho phi công]
FROM            dbo.CHUYENBAY AS C INNER JOIN
                         dbo.MAYBAY AS M ON C.MaMB = M.MAMB INNER JOIN
                         dbo.CHUNGNHAN AS CH ON M.MAMB = CH.MaMB INNER JOIN
                         dbo.NHANVIEN AS N ON CH.MaNV = N.MANV
GROUP BY C.GaDi
--cau4Cho biết mã số của các phi công chỉ lái được 3 loại máy bay.
SELECT        C.MaNV AS [Mã Phi Công Chỉ lái Được 3 loại máy bay]
FROM            dbo.CHUNGNHAN AS C INNER JOIN
                         dbo.MAYBAY AS M ON C.MaMB = M.MAMB
GROUP BY C.MaNV
HAVING        (COUNT(M.Loai) = 3)
--cau5Với mỗi phi công có thể lái nhiều hơn 3 loại máy bay, cho biết mã số phi công và tầm bay lớn nhất của các loại máy bay mà phi công đó có thể lái.
select MaNV, max(TamBay) as [Tầm bay lớn nhất]
from ChungNhan C, MayBay M
where C.MaMB=M.MaMB
group by MaNV
having count(Loai) > 3
--cau6Cho biết mã số của các phi công có thể lái được ít loại máy bay nhất.
SELECT        TOP (1) WITH TIES C.MaNV, COUNT(M.Loai) AS [Tổng số loại máy bay]
FROM            dbo.CHUNGNHAN AS C INNER JOIN
                         dbo.MAYBAY AS M ON C.MaMB = M.MAMB
GROUP BY C.MaNV
ORDER BY [Tổng số loại máy bay]
--cau7Tìm các nhân viên không phải là phi công.
select *
from NHANVIEN
where MaNV not in
	(
		select distinct MANV 
		from CHUNGNHAN
	)
--cau8Tìm các chuyến bay có thể được thực hiện bởi tất cả các loại máy bay Boeing.
SELECT        C.MaCB, M.Loai
FROM            dbo.CHUYENBAY AS C INNER JOIN
                         dbo.MAYBAY AS M ON C.MaMB = M.MAMB
WHERE        (M.Loai IN
                             (SELECT        Loai
                               FROM            dbo.MAYBAY AS L
                               WHERE        (Loai LIKE 'Boeing%')))
--cau9Cho biết tên các phi công có lương nhỏ hơn chi phí thấp nhất của đường bay từ Sài Gòn (SGN) đến Buôn Mê Thuộc (BMV).
SELECT DISTINCT N.Ten
FROM dbo.NHANVIEN N, dbo.CHUYENBAY C, dbo.CHUNGNHAN V
WHERE N.MaNV = V.MaNV AND V.MaMB = C.MaMB AND N.Luong < (SELECT MIN(C.ChiPhi)
							FROM dbo.CHUYENBAY C
							WHERE C.GaDi = 'SGN' AND C.GaDen = 'BMV')
--cau10Với mỗi nhân viên cho biết mã số, tên nhân viên và tổng số loại máy bay mà nhân viên đó có thể lái.
SELECT N.MaNV, Ten, COUNT(Loai) AS [Tổng số loại máy bay]
FROM NHANVIEN N, CHUNGNHAN C, MAYBAY M
WHERE N.MaNV=C.MaNV and C.MaMB=M.MaMB
GROUP BY N.MaNV, Ten
Gom nhóm:
18)	Với mỗi ga có chuyến bay xuất phát từ đó cho biết có bao nhiêu chuyến bay 
khởi hành từ ga đó.
select GaDi, count(MaCB) as [Số chuyến xuất phát]
from CHUYENBAY
group by GaDi
19)	Với mỗi ga có chuyến bay xuất phát từ đó cho biết tổng chi phí phải trả 
cho phi công lái các chuyến bay khởi hành từ ga đó.
select GaDi, sum(Luong) as [Tổng chi phí phải trả]
from CHUYENBAY C, MAYBAY M, CHUNGNHAN CH, NHANVIEN N
where C.MaMB=M.MaMB and M.MaMB=CH.MaMB and CH.MaNV=N.MaNV
group by GaDi
20)	Với mỗi địa điểm xuất phát cho biết có bao nhiêu chuyến bay có thể 
khởi hành trước 12:00.
select GaDi, count(MaCB) as [Số chuyến khởi hành]
from CHUYENBAY
where GioDi < '12:00'
group by GaDi
21)	Cho biết mã số của các phi công chỉ lái được 3 loại máy bay.
select MaNV, count(Loai) as [Loại máy bay]
from ChungNhan C, MayBay M
where C.MaMB=M.MaMB
group by MaNV
having count(Loai) = 3
22)	Với mỗi phi công có thể lái nhiều hơn 3 loại máy bay, cho biết mã số 
phi công và tầm bay lớn nhất của các loại máy bay mà phi công đó có thể lái.
select MaNV, max(TamBay) as [Tầm bay lớn nhất]
from ChungNhan C, MayBay M
where C.MaMB=M.MaMB
group by MaNV
having count(Loai) > 3
23)	Với mỗi phi công cho biết mã số phi công và tổng số loại máy bay mà 
phi công đó có thể lái.
select MaNV, count(Loai) as [Tổng số loại máy bay]
from ChungNhan C, MayBay M
where C.MaMB=M.MaMB
group by MaNV 
24)	Cho biết mã số của các phi công có thể lái được nhiều loại máy bay nhất.
--Cách 1: >=ALL
select MaNV, count(Loai) as [Tổng số loại máy bay]
from ChungNhan C, MayBay M
where C.MaMB=M.MaMB
group by MaNV 
having count(Loai) >= ALL
	(
		select count(Loai)
		from ChungNhan C, MayBay M
		where C.MaMB=M.MaMB
		group by MaNV
	)
--Cách 2:
select top 1 with ties MaNV, count(Loai) as [Tổng số loại máy bay]
from ChungNhan C, MayBay M
where C.MaMB=M.MaMB
group by MaNV
order by count(Loai) desc
25)	Cho biết mã số của các phi công có thể lái được ít loại máy bay nhất.
--Cách 1: >=ALL
select MaNV, count(Loai) as [Tổng số loại máy bay]
from ChungNhan C, MayBay M
where C.MaMB=M.MaMB
group by MaNV 
having count(Loai) <= ALL
	(
		select count(Loai)
		from ChungNhan C, MayBay M
		where C.MaMB=M.MaMB
		group by MaNV
	)
--Cách 2:
select top 1 with ties MaNV, count(Loai) as [Tổng số loại máy bay]
from ChungNhan C, MayBay M
where C.MaMB=M.MaMB
group by MaNV
order by count(Loai) asc --ko ghi asc cũng được, vì mặc nhiên là asc

Truy vấn lồng:
--Thực hiện các VIEW sau: (viết câu select xong => Tạo View)
26)	Tìm các nhân viên không phải là phi công.
--Làm 3 cách
27)	Cho biết mã số của các nhân viên có lương cao nhất.
--Làm 3 cách
--Cách 1: not in
select *
from NHANVIEN
where MaNV not in
	(
		select distinct MANV --có lái 1 máy bay thì là Phi công
		from CHUNGNHAN
	)
--Cách 2: not exists
select *
from NHANVIEN N
where not exists (select *
				  from CHUNGNHAN C
				  where N.MaNV=C.MaNV)
--Cách 3:
select *
from NHANVIEN N
where (select count(*)
	   from CHUNGNHAN C
	   where N.MaNV=C.MaNV)=0
--Ta mới tạo view:
create view V26 --Chọn 1 trong 3 cách trên để vào
as
	select *
	from NHANVIEN N
	where (select count(*)
		   from CHUNGNHAN C
	       where N.MaNV=C.MaNV)=0
27)	Cho biết mã số của các nhân viên có lương cao nhất.
--Cách 1:
select *
from NHANVIEN
where Luong = (select max(Luong) from NHANVIEN)
--Cách 2:
select *
from NHANVIEN
where Luong >= ALL
			(select Luong from NHANVIEN)
--Cách 3:
select top 1 with ties *
from NHANVIEN
order by Luong desc
--Tạo view:
create view V27
as
	select top 1 with ties *
	from NHANVIEN
	order by Luong desc
--gọi view:
select * from V27
28)	Cho biết tổng số lương phải trả cho các phi công.
select sum(Luong) as [Tổng lương trả cho các phi công]
from NHANVIEN N, CHUNGNHAN C
where N.MaNV=C.MaNV
29)	Tìm các chuyến bay có thể được thực hiện bởi tất cả các loại 
máy bay Boeing.
select MaCB
from CHUYENBAY C, MAYBAY M
where C.MaMB=M.MaMB and Loai like 'Boeing%'
30)	Cho biết mã số của các máy bay có thể được sử dụng để thực hiện 
chuyến bay từ Sài Gòn (SGN) đến Huế (HUI).
--
31)	Tìm các chuyến bay có thể được lái bởi các phi công có lương lớn hơn 
100,000.
32)	Cho biết tên các phi công có lương nhỏ hơn chi phí thấp nhất của đường bay 
từ Sài Gòn (SGN) đến Buôn Mê Thuộc (BMV).
33)	Cho biết mã số của các phi công có lương cao nhất.
34)	Cho biết mã số của các nhân viên có lương cao thứ nhì.
--3504_Danh Hoàng Tân13:27
select top 1 with ties MaNV, Luong
from NhanVien
where Luong < (
	select max(Luong)
	from NhanVien
)
order by Luong desc
--0692_Than Trấn Nghiệp13:33
select distinct MaNV,Luong from NHANVIEN
where Luong >= all
(select distinct Luong from NHANVIEN 
where Luong <> (select MAX(Luong) from NHANVIEN)) 
and Luong < (select MAX(Luong) from NHANVIEN)
--3 em đầu tiên
--8994_Trần Công Mạnh09:53
SELECT Top 1  *
FROM NHANVIEN NV
WHERE Luong < ( SELECT Top 1 with ties luong
                FROM NHANVIEN NV
                ORDER BY Luong DESC
                )
ORDER BY Luong DESC
--Phép trừ
select top 2 with ties Luong
from NHANVIEN
order by Luong DESC
except
select top 1 with ties Luong
from NHANVIEN
order by Luong DESC

35)	Cho biết mã số của các nhân viên có lương cao thứ nhất hoặc thứ nhì.
36)	Cho biết tên và lương của các nhân viên không phải là phi công 
và có lương lớn hơn lương trung bình của tất cả các phi công.

37)	Cho biết tên các phi công có thể lái các máy bay có tầm bay 
lớn hơn 4,800km nhưng không có chứng nhận lái máy bay Boeing.
select Ten, Loai
from NHANVIEN N, CHUNGNHAN C, MAYBAY M
where N.MaNV=C.MaNV and C.MaMB=M.MaMB and TamBay>4800
and Loai not like 'Boeing%'
38)	Cho biết tên các phi công lái ít nhất 3 loại máy bay có tầm bay 
xa hơn 3200km.
select Ten, count(Loai) as [Loại máy bay có thể lái > 3200 km]
from NHANVIEN N, CHUNGNHAN C, MAYBAY M
where N.MaNV=C.MaNV and C.MaMB=M.MaMB and TamBay>3200
group by Ten
having count(Loai)>=3
---
Kết ngoài:
39)	Với mỗi nhân viên cho biết mã số, tên nhân viên và tổng số loại máy bay mà 
nhân viên đó có thể lái.
select N.MaNV, Ten, count(Loai) as [Tổng số loại máy bay]
from NHANVIEN N, CHUNGNHAN C, MAYBAY M
where N.MaNV=C.MaNV and C.MaMB=M.MaMB
group by N.MaNV, Ten

40)	Với mỗi nhân viên cho biết mã số, tên nhân viên và tổng số loại máy bay 
Boeing mà nhân viên đó có thể lái.
select N.MaNV, Ten, count(Loai) as [Tổng số loại máy bay]
from NHANVIEN N, CHUNGNHAN C, MAYBAY M
where N.MaNV=C.MaNV and C.MaMB=M.MaMB and Loai like 'Boeing%'
group by N.MaNV, Ten

41)	Với mỗi loại máy bay cho biết loại máy bay và tổng số phi công có thể lái 
loại máy bay đó.
select Loai, count(C.MaNV) as [Tổng số phi công có thể lái]
from NHANVIEN N, CHUNGNHAN C, MAYBAY M
where N.MaNV=C.MaNV and C.MaMB=M.MaMB
group by Loai

42)	Với mỗi loại máy bay cho biết loại máy bay và tổng số chuyến bay 
không thể thực hiện bởi loại máy bay đó.
--Tân
select M.Loai, sum(G.Num) - count(C.MaMB) as [Số chuyến ko thể bay]
from MayBay M, ChuyenBay C, 
(
	select M1.Loai, count(C1.MaMB) as [Num]
	from MayBay M1,ChuyenBay C1
	where M1.MaMB = C1.MaMB 
	group by M1.Loai
) as G
where M.MaMB = C.MaMB 
group by M.Loai
43)	Với mỗi loại máy bay cho biết loại máy bay và tổng số phi công 
có lương lớn hơn 100,000 có thể lái loại máy bay đó.
44)	Với mỗi loại máy bay có tầm bay trên 3200km, cho biết tên của loại máy bay 
và lương trung bình của các phi công có thể lái loại máy bay đó.
45)	Với mỗi loại máy bay cho biết loại máy bay và tổng số nhân viên không thể 
lái loại máy bay đó.

Exists và các dạng khác:
55)	Một hành khách muốn đi từ Hà Nội (HAN) đến Nha Trang (CXR) mà 
không phải đổi chuyến bay quá một lần. Cho biết mã chuyến bay và 
thời gian khởi hành từ Hà Nội nếu hành khách muốn đến Nha Trang 
trước 16:00.
select MaCB, GaDi, GaDen, GioDi, GioDen
from CHUYENBAY
where GaDi='HAN' and GaDen='CXR' and GioDen<='16:00'
--hội
select C1.MaCB, C1.GaDi, C1.GaDen, C1.GioDi, C1.GioDen,
	   C2.MaCB, C2.GaDi, C2.GaDen, C2.GioDi, C2.GioDen
from CHUYENBAY C1, CHUYENBAY C2
where C1.GaDen=C2.GaDi --or C1.MaCB<>C2.MaCB
and C1.GaDi='HAN' and (C1.GaDen='CXR' or C2.GaDen='CXR')
and (C1.GioDen<='16:00' or C2.GioDen<='16:00')
and C2.GioDi>C1.GioDen --bổ sung trường hợp bay thẳng từ Hà Nội đến Cam Ranh
56)	Cho biết tên các loại máy bay mà tất cả các phi công có thể lái đều có 
lương lớn hơn 200,000.
57)	Cho biết thông tin của các đường bay mà tất cả các phi công có thể 
bay trên đường bay đó đều có lương lớn hơn 100,000.
58)	Cho biết tên các phi công chỉ lái các loại máy bay có tầm bay 
xa hơn 3200km.
59)	Cho biết tên các phi công chỉ lái các loại máy bay có tầm bay 
xa hơn 3200km và một trong số đó là Boeing.
60)	Tìm các phi công có thể lái tất cả các loại máy bay.
61)	Tìm các phi công có thể lái tất cả các loại máy bay Boeing.
