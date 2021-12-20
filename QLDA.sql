create database QLDA
on
(
	name = 'QLDA_Data',
	filename = 'D:\Database\QLDA.MDF'
)
log on
(
	name = 'QLDA_Log',
	filename = 'D:\Database\QLDA.LDF'
)
use QLDA
create table NCC
(
	MaNCC	char(5)	primary key,
	Ten		nvarchar(40),
	Heso	int,
	ThPho	nvarchar(20)
)
create table VATTU
(
	MaVT	char(5)	primary key,
	Ten		nvarchar(40),
	Mau		nvarchar(15),
	TrLuong	float,
	ThPho	nvarchar(20)
)
create table DUAN
(
	MaDA	char(5)	primary key,
	Ten		nvarchar(40),
	ThPho	nvarchar(20)
)
create table CC
(
	MaNCC	char(5),
	MaVT	char(5),
	MaDA	char(5),
	SLuong	int,
	primary key(MaNCC, MaVT, MaDA), --PFK
	foreign key(MaNCC) references NCC(MaNCC)
	on update cascade
	on delete cascade,
	foreign key(MaVT) references VATTU(MaVT)
	on update cascade
	on delete cascade,
	foreign key(MaDA) references DUAN(MaDA)
	on update cascade
	on delete cascade
)
--Tạo diagram
--Nhập dữ liệu
--Thực hiện các truy vấn
1)	Cho biết quy cách màu và thành phố của các vật tư không được 
trữ tại Hà Nội có trọng lượng lớn hơn 10.
select Mau, ThPho
from VATTU
where ThPho <> N'Hà Nội' and TrLuong > 10
2)	Cho biết thông tin chi tiết của tất cả các dự án.
3)	Cho biết thông tin chi tiết của tất cả các dự án ở TP.HCM.
4)	Cho biết tên nhà cung cấp cung cấp vật tư cho dự án J1.
5)	Cho biết tên nhà cung cấp, tên vật tư và tên dự án mà số lượng 
vật tư được cung cấp cho dự án bởi nhà cung cấp lớn hơn 300 và 
nhỏ hơn 750.
6)	Cho biết thông tin chi tiết của các vật tư được cung cấp bởi 
các nhà cung cấp ở TP.HCM.
7)	Cho biết mã số các vật tư được cung cấp cho các dự án tại TP.HCM 
bởi các nhà cung cấp ở TP.HCM.
select MaVT
from DUAN D, CC C, NCC N
where D.MaDA=C.MaDA and C.MaNCC=N.MaNCC 
and D.ThPho='TP.HCM' and N.ThPho='TP.HCM'
8)	Liệt kê các cặp tên thành phố mà nhà cung cấp ở thành phố 
thứ nhất cung cấp vật tư được trữ tại thành phố thứ hai.
select distinct N.ThPho as [Nhà CC], V.ThPho as [DA tại TP]
from VATTU V, CC C, NCC N
where V.MaVT=C.MaVT and C.MaNCC=N.MaNCC 
and V.ThPho <> N.ThPho
9)	Liệt kê các cặp tên thành phố mà nhà cung cấp ở thành phố 
thứ nhất cung cấp vật tư cho dự án tại thành phố thứ hai.
select N.ThPho as [Nhà CC], D.ThPho as [DA tại TP]
from DUAN D, CC C, NCC N
where D.MaDA=C.MaDA and C.MaNCC=N.MaNCC 
and D.ThPho <> N.ThPho
10)	Liệt kê các cặp mã số nhà cung cấp ở cùng một thành phố.
select N1.MaNCC as [Nhà CC thứ nhất], N1.ThPho,
N2.MaNCC as [Nhà CC thứ hai], N2.ThPho
from NCC N1, NCC N2
where N1.ThPho = N2.ThPho and N1.MaNCC > N2.MaNCC
--
--14)Cho biết mã số các vật tư được cung cấp bởi nhiều hơn một nhà cung cấp.
select count (V.MaVT) as [số nhà cung cấp],V.MaVT
from VATTU V, NCC N,CC C 
where V.MaVT=C.MaVT and C.MaNCC=N.MaNCC 
group by V.MaVT
having count (V.MaVT) >=2
--15)Với mỗi vật tư cho biết mã số và tổng số lượng được cung cấp cho các dự án.

select MaVT, sum(Sluong) as [Tong so luong]
from CC
group by MAVT
--16)Cho biết tổng số các dự án được cung cấp vật tư bởi nhà cung cấp S1.
select COUNT(MaNCC) as [Số dự án s1 cung cấp]
from CC
where MaNCC = 'S1'
--17)Cho biết tổng số lượng vật tư P1 được cung bởi nhà cung cấp S1.
select SUM(SLuong)
from CC
where MaVT = 'P1' and MaNCC = 'S1'
--18)Với mỗi vật tư được cung cấp cho một dự án, cho biết mã số, tên vật tư, tên dự án và tổng số lượng vật tư tương ứng.
select V.MaVT, V.Ten as [tên vật liệu], D.Ten as [tên dự án], SUM(SLuong) as [tổng số lượng]
from VATTU V, CC C, DUAN D
where V.MaVT=C.MaVT and C.MaDA=D.MaDA
group by V.Ten,V.MaVT,D.ten
--19)Cho biết mã số, tên các vật tư và tên dự án có số lượng vật tư trung bình cung cấp cho dự án lớn hơn 350.
select C.MaVT,D.Ten,D.MaDA,avg (C.Sluong) as [tong vat tu trung binh]
from CC C,DUAN D,VATTU V
where C.MaDA =D.MaDA and V.MaVT=C.MaVT
group by D.Ten,D.MaDA,C.MAVT
having avg (C.Sluong)>350
--20)Cho biết tên các dự án được cung cấp vật tư bởi nhà cung cấp S1.
select D.Ten
from DUAN D, CC C
where MaNCC ='S1' and C.MaDA=D.MaDA
--
30)	Cho biết mã số và tên các nhà cung cấp cung cấp vật tư P1 cho 
một dự án nào đó với số lượng lớn hơn số lượng trung bình của vật tư 
P1 được cung cấp cho dự án đó.
select N.MaNCC, N.Ten, C.MaDA
from CC C, NCC N
where C.MaNCC = N.MaNCC and C.MaVT = 'P1' and
	C.SLuong > (
					select avg(SLuong)
					from CC
					where MaVT = 'P1'
				)
31)	Cho biết mã số và tên các dự án không được cung cấp vật tư nào 
có quy cách màu đỏ bởi một nhà cung cấp bất kỳ ở TP.HCM.
select distinct D.MaDA, D.Ten
from CC C, DuAn D
where C.MaDA = D.MaDA and
C.MaVT not in
	(
		select distinct C.MaVT
		from VatTu V, CC C, NCC N
		where V.MaVT=C.MaVT and C.MaNCC=N.MaNCC 
		and Mau=N'Đỏ' and N.ThPho='TP.HCM'
	)
32)	Cho biết mã số và tên các dự án được cung cấp toàn bộ vật tư bởi 
nhà cung cấp S1.
--Trong đại số quan hệ, đây chính là phép CHIA.
--Đếm xem mỗi dự án lấy bao nhiêu loại vật tư từ NCC S1
select D.MaDA, D.Ten, C.MaNCC, count(MaVT) as [Số loại VT cần cung cấp]
from DuAn D, CC C
where D.MaDA=C.MaDA and C.MaNCC='S1'
group by D.MaDA, D.Ten, C.MaNCC
having count(MaVT) =
	--Đếm xem nhà cung cấp S1 có thể cung cấp bao nhêu loại vật tư
	(select count(MaVT) --as [Khả năng cung cấp loại VT]
	from CC C, NCC N
	where C.MaNCC=N.MaNCC and N.MaNCC='S1'
	group by N.MaNCC, N.Ten)

33)	Cho biết tên các nhà cung cấp cung cấp tất cả các vật tư.
--Phép chia
--Khả năng cung cấp vật tư của các NCC
select N.MaNCC, N.Ten, count(distinct MaVT) as [Khả năng cung cấp loại VT]
from CC C, NCC N
where C.MaNCC=N.MaNCC
group by N.MaNCC, N.Ten 
having count(distinct MaVT) =
	--đếm xem có bao nhiêu vật tư
	(select count(*)
	 from VATTU)
34)	Cho biết mã số và tên các vật tư được cung cấp cho tất cả các 
dự án tại TP.HCM.
35)	Cho biết mã số và tên các nhà cung cấp cung cấp cùng một vật tư 
cho tất cả các dự án.
36)	Cho biết mã số và tên các dự án được cung cấp tất cả các vật tư 
có thể được cung cấp bởi nhà cung cấp S1.
37)	Cho biết tất cả các thành phố mà nơi đó có ít nhất một nhà 
cung cấp, trữ ít nhất một vật tư hoặc có ít nhất một dự án.
38)	Cho biết mã số các vật tư hoặc được cung cấp bởi một nhà 
cung cấp ở TP.HCM hoặc cung cấp cho một dự án tại TP.HCM.
39)	Liệt kê các cặp (mã số nhà cung cấp, mã số vật tư) mà nhà 
cung cấp không cấp vật tư.
40)	Liệt kê các cặp mã số nhà cung cấp có thể cung cấp cùng tất cả 
các loại vật tư.
41)	Cho biết tên các thành phố trữ nhiều hơn 5 vật tư có quy cách 
màu đỏ.
--


--33)
select N.Ten
from CungCap C, NhaCungCap N
where N.MaNCC = C.MaNCC
group by C.MaNCC, N.Ten
having count(distinct C.MaVT) = (select count(*) from VatTu)

--34)
select MAVT, Ten
from (
	select C.MaVT, V.Ten
	from CungCap C, VatTu V, (
		select MaDA 
		from DuAn
		where ThanhPho like 'TP.HCM'
	) as S
	where C.MaVT = V.MaVT and C.MaDA = S.MaDA
) as G
group by MaVT, Ten
having count(MaVT) = 2

