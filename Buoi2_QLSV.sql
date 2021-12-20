--Bài 2: Quản lý SV
--1) Tạo DB, tạo các bảng theo thứ tự với khóa ngoại tương ứng.
create database QLSV
on
(
	name='QLSV_Data',
	filename='D:\Database\QLSV.MDF'
)
log on
(
	name='QLSV_Log',
	filename='D:\Database\QLSV.LDF'
)
use QLSV
--2) Tạo các bảng
create table LOP
(
	MaLop	char(7)	primary key,
	TenLop	nvarchar(50),
	SiSo	tinyint check(SiSo>0) --ràng buộc toàn vẹn
)
drop table MONHOC
create table MONHOC
(
	MaMH	char(6)	primary key,
	TenMH	nvarchar(50),
	TCLT	tinyint	check(TCLT>0), --ràng buộc toàn vẹn
	TCTH	tinyint	check(TCTH>=0) --ràng buộc toàn vẹn
)
drop table SINHVIEN
create table SINHVIEN
(
	MSSV	char(6) primary key,
	HoTen	nvarchar(50),
	NTNS	date,
	Phai	bit default 1, --mặc định người dùng ko nhập thì ghi 1
	MaLop	char(7),
	--đ/n khóa ngoại
	foreign key (MaLop) references LOP(MaLop)
	on update cascade --Sửa Mã lớp trong LOP thì Mã lớp trong SV sửa theo
	on delete set null --Xóa Mã lớp trong LOP thì Mã lớp trong SV là null
)
drop table DIEMSV
create table DIEMSV
(
	MSSV	char(6),
	MaMH	char(6),
	--đ/n khóa chính là 1 cặp thuộc tính
	primary key (MSSV,MaMH),
	Diem	decimal(3,1) check (Diem between 0 and 10),
	--hoặc: check(Diem>=0 and Diem<=10)
	--decimal(3,1): số thực có độ dài=3, lấy 1 số lẻ,
	--và 1 dấu thập phân => phần nguyên còn 1 con số
	--đ/n 2 khóa ngoại
	foreign key (MSSV) references SINHVIEN(MSSV)
	on update cascade
	on delete cascade,
	foreign key (MaMH) references MONHOC(MaMH)
	on update cascade
	on delete cascade
)
--3) Tạo database diagram
--4) Nhập dữ liệu theo thứ tự các bảng đã tạo
--Nếu xóa dữ liệu thì xóa theo thứ tự ngược lại
delete from LOP
delete from SINHVIEN
delete from MONHOC
--Nhập liệu:
--Chú ý dữ liệu dạng số thập phân:
3.5				3,5
3,500,000		3.500.000
								--Anh/Mỹ		Pháp/Việt
--Dấu thập phân (decimal symbol):	.				,
--Dấu phân cách hàng  ngàn:			,				.
--(digits grouping symbol)
--Dấu phân cách giữa các đối số:	,				;
--(List separator)
--Pháp/Việt: if(A5>=9,5; "Xuất sắc"; if(A5>=8; "Giỏi"; ...)
--Anh/Mỹ: if(A5>=9.5, "Xuất sắc", if(A5>=8, "Giỏi", ...)
--5) Thực hiện các câu hỏi sau bằng ngôn ngữ SQL:

1-	Thêm một dòng mới vào bảng SINHVIEN với giá trị:
insert into SINHVIEN values('190001', N'Đào Thị Tuyết Hoa', 
							'08/03/2001', 0, '19DTH02')
--Ktra lại dl
select *
from SINHVIEN
--Nhận xét: dl Ngày nhập vào đang hiểu dưới dạng Tháng/Ngày/Năm
--Sửa lại bằng cách nào?
update SINHVIEN set NTNS='08/03/2001'
where NTNS='03/08/2001' and MSSV='190001'
--Vẫn ko update được. Tại sao? Vì ko có SV sinh ngày '08/03/2001'.
set dateformat dmy --chuyển trạng thái soạn thảo từ dạng
--tháng/ngày/năm sang ngày/tháng/năm. Chỉ chạy đúng 1 lần
--khi mới khởi động SQL.
update SINHVIEN set NTNS='08/03/2001'
where MSSV='190001'
2-	Hãy đổi tên môn học 'Lý thuyết đồ thị' thành 'Toán rời rạc'.
select *
from MONHOC
--
update MONHOC
set TENMH=N'Toán rời rạc'
where TENMH=N'Lý thuyết đồ thị'
--
3-	Hiển thị tên các môn học không có thực hành.
select TENMH
from MONHOC
where TCTH=0
4-	Hiển thị tên các môn học vừa có lý thuyết, vừa có thực hành.
select TENMH
from MONHOC
where TCLT>0 and TCTH>0
5-	In ra tên các môn học có ký tự đầu của tên là chữ 'C'.
select TENMH
from MONHOC
where TENMH like 'C%'
--Hoặc:
select TENMH
from MONHOC
where left(TENMH,1)='C' --giống excel
6-	Liệt kê thông tin những sinh viên mà họ chứa chữ 'Thị'.
select *
from SINHVIEN
where HoTen like N'%Thị%'
7-	In ra 2 lớp có sĩ số đông nhất (bằng nhiều cách). 
Hiển thị: Mã lớp, Tên lớp, Sĩ số. Nhận xét?
select *
from LOP
--Có 1 lớp sĩ số 55 và 2 lớp có sĩ số 50 => Lấy 3 lớp.
select top 2  *
from LOP
order by SiSo DESC --Lấy 2 lớp, bỏ 1 lớp
--Lấy hết
select top 2 with ties *
from LOP
order by SiSo DESC
--Ý tưởng khác: In ra các lớp có SiSo >= Sĩ số cao thứ nhì 
--của tất cả các lớp. => Tự làm ở nhà.
8-	In danh sách SV theo từng lớp: MSSV, Họ tên SV, Năm sinh, 
Phái (Nam/Nữ).
select MaLop, MSSV, HoTen, NTNS, Phai
from SINHVIEN
order by MaLop
--Nhận xét: NTNS hiển thị ko có dạng Ngày/Tháng/Năm
select getdate() --trả về năm-tháng-ngày của ngày hiện hành
--Định dạng:
select convert(varchar(10), getdate(), 101) --10/06/2021
select convert(varchar(10), getdate(), 102) --2021.10.06
select convert(varchar(10), getdate(), 103) --06/10/2021 (VN)
select convert(varchar(10), getdate(), 104) --06.10.2021
select convert(varchar(10), getdate(), 105) --06-10-2021
--Sửa lại:
select MaLop, MSSV, HoTen, convert(varchar(10), NTNS, 103) as NTNS, 
Phai
from SINHVIEN
order by MaLop
--Xử lý Phái là Nam hoặc Nữ:
--Cách 1:
select MaLop, MSSV, HoTen,convert(varchar(10), NTNS, 103) as NTNS, 
		case when Phai=0 then N'Nữ'
		else 'Nam'
		end as NTNS
from SINHVIEN
order by MaLop
--Cách 2:
select MaLop, MSSV, HoTen, convert(varchar(10), NTNS, 103) as NTNS, 
		iif(Phai=0, N'Nữ', 'Nam') as NTNS
from SINHVIEN
order by MaLop

9-	Cho biết những sinh viên có tuổi ≥ 20, thông tin gồm: 
Họ tên sinh viên, Ngày sinh, Tuổi.
--Tuổi=year(getdate())-year(NTNS)
select HoTen, NTNS, year(getdate())-year(NTNS) as [Tuổi]
from SINHVIEN
where year(getdate())-year(NTNS)>=20
--order by [Tuổi] DESC
--Cách khác:
select HoTen, NTNS, datediff(yy, NTNS, getdate()) as N'Tuổi'
from SINHVIEN
where year(getdate())-year(NTNS)>=20
--Giải thích:
set dateformat dmy --chuyển ngày sang dạng Ngày/Tháng/Năm
--Cú pháp:
--datediff(định dạng, Ngày BĐ, Ngày KT): khoảng cách giữa 2 ngày
--theo ngày (dd), tháng (mm) và năm (yy) 
select datediff(dd, '6/10/2002', getdate())
select datediff(mm, '6/10/2002', getdate())
select datediff(yy, '6/10/2002', getdate())
--Học thêm các hàm xử lý thời gian:
select datepart(dd, getdate()) --Ngày hiện hành
select datepart(mm, getdate()) --Tháng hiện hành
select datepart(yy, getdate()) --Năm hiện hành
select datepart(hh, getdate()) --Giờ hiện hành
select datepart(mi, getdate()) --Phút hiện hành
select datepart(ss, getdate()) --Ngày hiện hành
select datepart(qq, getdate()) --Quý hiện hành, q: quarter

10-	Liệt kê tên các môn học SV đã dự thi nhưng chưa có điểm.
select TenMH, DIEM
from MONHOC M, DIEMSV D
where M.MaMH=D.MaMH and DIEM IS NULL --is not null
11-	Liệt kê kết quả học tập của SV có mã số 170001. Hiển thị:
MSSV, HoTen, TenMH, Diem.
select S.MSSV, HoTen, TenMH, Diem
from SINHVIEN S, DIEMSV D, MONHOC M
where S.MSSV=D.MSSV and D.MaMH=M.MaMH and D.MSSV='170001'
12-	Liệt kê tên sinh viên và mã môn học mà sv đó đăng ký 
với điểm trên 7 điểm.
select HoTen, MaMH, Diem
from SINHVIEN S, DIEMSV D
where S.MSSV=D.MSSV and Diem>7
13-	Liệt kê tên môn học cùng số lượng SV đã học và đã có điểm.
select TenMH, count(MSSV) as [Số lượng SV đã học]
from MONHOC M, DiemSV D
where M.MaMH = D.MaMH and Diem is not null
group by TenMH
14-	Liệt kê tên SV và điểm trung bình của SV đó.
int x;
float y;
x=y; --x sẽ bị tràn vùng nhớ
x=(int) y; --ép kiểu
select HoTen, cast(avg(Diem) as decimal(4,2))  as [Diem Trung Binh]
--cast: chuyển DTB sang số thực với 1 con số ở phần lẻ, 1 dấu thập phân
--và 1 con số ở phần nguyên
from SinhVien S, DiemSV D
where S.MSSV = D.MSSV
group by HoTen
--
15-	Liệt kê tên sinh viên đạt điểm cao nhất của môn học 
'Kỹ thuật lập trình'.	--Hãy làm 3 cách
select HoTen
from SinhVien S, DiemSV D, MONHOC M
where S.MSSV = D.MSSV and D.MaMH=M.MaMH and TenMH = N'Kỹ Thuật Lập Trình'
and Diem = 
(	--lấy ra điểm cao nhất của môn KTLT
	select max(Diem)
	from DiemSV D, MONHOC M
	where D.MaMH = M.MaMH and TenMH = N'Kỹ Thuật Lập Trình'
)
--Cách khác:
select HoTen
from SinhVien S, DiemSV D, MONHOC M
where S.MSSV = D.MSSV and D.MaMH=M.MaMH and TenMH = N'Kỹ Thuật Lập Trình'
and Diem >= ALL
	(--lấy ra tất cả các điểm của SV đã thi môn KTLT
		select Diem
		from DiemSV D, MONHOC M
		where D.MaMH = M.MaMH and TenMH = N'Kỹ Thuật Lập Trình'
	)
--Cách khác:
select top 1 with ties HoTen
from SinhVien S, DiemSV D, MONHOC M
where S.MSSV = D.MSSV and D.MaMH=M.MaMH and TenMH = N'Kỹ Thuật Lập Trình'
order by Diem DESC
16-	Liệt kê tên SV có điểm trung bình cao nhất.
--Cách 1:
select HoTen, avg(Diem) as [ĐTB cao nhất]
from SinhVien S, DiemSV D
where S.MSSV = D.MSSV
group by HoTen
having avg(Diem) >= all
(--sau >=ALL thì select giống như trên nhưng chỉ lấy 1 cột để so sánh
	select avg(Diem)
	from SinhVien S, DiemSV D
	where S.MSSV = D.MSSV
	group by HoTen
)
--Cách 2:
select top 1 with ties HoTen, avg(Diem) as [ĐTB cao nhất]
from SinhVien S, DiemSV D
where S.MSSV = D.MSSV
group by HoTen
order by avg(Diem) DESC
17-	Liệt kê tên SV chưa học môn 'Toán rời rạc'.
--Cách 1: not in
select MSSV, HoTen
from SINHVIEN
where MSSV not in --MSSV ko nằm trong MSSV bên dưới là chưa học
	(
	--Ta lấy MSSV đã học môn Toán rời rạc,
	select S.MSSV
	from SINHVIEN S, DIEMSV D, MONHOC M
	where S.MSSV = D.MSSV and D.MaMH=M.MaMH and TenMH=N'Toán rời rạc'
	)
--Cách 2: not exists
select MSSV, HoTen
from SINHVIEN S
where not exists --ko tồn tại dòng nào bên dưới
	(--not exists trả về TRUE khi select bên dưới ko trả về dòng nào
	select *
	from DIEMSV D, MONHOC M
	where S.MSSV = D.MSSV and D.MaMH=M.MaMH and TenMH=N'Toán rời rạc'
	)
--Cách 3:
select MSSV, HoTen
from SINHVIEN S
where
	(--where là TRUE khi count(*) bên dưới = 0
	select count(*)
	from DIEMSV D, MONHOC M
	where S.MSSV = D.MSSV and D.MaMH=M.MaMH and TenMH=N'Toán rời rạc'
	)=0 --không có dòng nào, tức là ko học môn TRR
18-	Cho biết sinh viên có năm sinh cùng với sinh viên tên 'Danh'.
--Ý tưởng: ta cần lấy ra năm sinh của SV tên Danh,
--sau đó mới lọc ra các SV có cùng năm sinh với Danh
19-	Cho biết tổng sinh viên và tổng số sinh viên nữ.
select count(*) as [Tổng số SV],
	   count(iif(Phai=0,N'Nữ',NULL)) as [Số SV Nữ]
from SINHVIEN
--Hoặc:
select count(*) as [Tổng số SV],
	   count(case when Phai=0 then N'Nữ'
			 else NULL
			 end) as [Số SV Nữ]
from SINHVIEN
20-	Cho biết danh sách các sinh viên rớt ít nhất 1 môn.
select S.MSSV, HoTen, count(*) as[Số môn rớt]
from SINHVIEN S, DIEMSV D
where S.MSSV=D.MSSV and DIEM<5
group by S.MSSV, HoTen
having count(*)>=1
21-	Cho biết MSSV, Họ tên SV đã học và có điểm ít nhất 3 môn.
select S.MSSV, HoTen, count(*) as[Số môn rớt]
from SINHVIEN S, DIEMSV D
where S.MSSV=D.MSSV and DIEM is not null
group by S.MSSV, HoTen
having count(*)>=3
22-	In danh sách sinh viên có điểm môn 'Kỹ thuật lập trình' cao nhất 
theo từng lớp.
select MaLop, max(Diem) as [Điểm cao nhất của môn KTLT]
from SINHVIEN S, DIEMSV D, MONHOC M
where S.MSSV = D.MSSV and D.MaMH=M.MaMH and TenMH=N'Kỹ thuật lập trình'
group by MaLop
23-	In danh sách sinh viên có điểm cao nhất theo từng môn, từng lớp.
select TenMH, MaLop, max(Diem) as [Điểm cao nhất]
from SINHVIEN S, DIEMSV D, MONHOC M
where S.MSSV = D.MSSV and D.MaMH=M.MaMH
group by TenMH, MaLop
24-	Cho biết những sinh viên đạt điểm cao nhất của từng môn.
select S.HoTen, D.MaMH, D.Diem
from SinhVien S, DiemSV D,
(
	select max(Diem) as [MaxDiem], D.MaMH
	from DiemSV D
	group by D.MaMH
) as [MaxTheoMon]
where D.MaMH = MaxTheoMon.MaMH and D.Diem = MaxTheoMon.MaxDiem 
and S.MSSV = D.MSSV
25-	Cho biết MSSV, Họ tên SV chưa đăng ký học môn nào.
--Làm 3 cách
--Cách 1: not in
select MSSV, HoTen
from SINHVIEN
where MSSV not in
	(
		select distinct MSSV
		from DIEMSV
	)
--Cách 2: not exists
select MSSV, HoTen
from SINHVIEN S
where not exists --là TRUE khi select bên dươ1i ko trả về dòng nào
	(
		select *
		from DIEMSV D
		where S.MSSV=D.MSSV
	)
--Cách 3: count
select MSSV, HoTen
from SINHVIEN S
where 
	(
		select count(*)
		from DIEMSV D
		where S.MSSV=D.MSSV
	)=0 --=0 khi phép kết ở trên ko trả về dòng nào
26-	Danh sách sinh viên có tất cả các điểm đều 10.

27-	Đếm số sinh viên nam, nữ theo từng lớp.
28-	Cho biết những sinh viên đã học tất cả các môn nhưng 
không rớt môn nào. --Phép chia
select HoTen, count( D.MaMH) as [Tổng số môn đã học và Đậu]
from SINHVIEN S, DIEMSV D, MONHOC M
where S.MSSV = D.MSSV and D.MaMH=M.MaMH and Diem>=5
group by HoTen, Diem
having count(D.MaMH) = --Tổng số môn đã học và đậu bằng tổng số môn học
					   --thì SV đó đã học hết
	(select count(*)
	from MONHOC)
29-	Xóa tất cả những sinh viên chưa dự thi môn nào.
30-	Cho biết những môn đã được tất cả các sinh viên đăng ký học. --Phép chia

