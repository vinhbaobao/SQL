--Hãy thống kê kết quả học tập của toàn bộ SV. Hiển thị:
--MSSV, Họ và tên, Ngày sinh, Phái (Nam/Nữ), ĐTB.
select S.MSSV, HoTen as [Họ và tên],
		convert(varchar(10), NTNS, 103) as [Ngày sinh], 
		PHAI as [Phái], avg(DIEM) as [ĐTB]
from SINHVIEN S, DIEMSV D
where S.MSSV=D.MSSV
group by S.MSSV, HoTen, NTNS, PHAI
--Cải tiến:
select S.MSSV, HoTen as [Họ và tên],
		convert(varchar(10), NTNS, 103) as [Ngày sinh], 
		iif(PHAI=1,'Nam',N'Nữ') as [Phái], avg(DIEM) as [ĐTB]
from SINHVIEN S, DIEMSV D
where S.MSSV=D.MSSV
group by S.MSSV, HoTen, NTNS, PHAI
--Cải tiến: ĐTB lấy 2 số lẻ
select S.MSSV, HoTen as [Họ và tên],
		convert(varchar(10), NTNS, 103) as [Ngày sinh], 
		iif(PHAI=1,'Nam',N'Nữ') as [Phái],
		cast(avg(DIEM) as decimal(4,2)) as [ĐTB]
from SINHVIEN S, DIEMSV D
where S.MSSV=D.MSSV
group by S.MSSV, HoTen, NTNS, PHAI
--Nếu muốn lưu kết quả lại thì ta làm sao?
--Lưu vào excel, access...
--Cách 1: đổ dl vào 1 bảng lưu trữ
select S.MSSV, HoTen as [Họ và tên],
		convert(varchar(10), NTNS, 103) as [Ngày sinh], 
		iif(PHAI=1,'Nam',N'Nữ') as [Phái],
		cast(avg(DIEM) as decimal(4,2)) as [ĐTB]
into [Bảng thống kê] --tạo ra bảng mới
from SINHVIEN S, DIEMSV D
where S.MSSV=D.MSSV
group by S.MSSV, HoTen, NTNS, PHAI
--Kiểm tra lại
select *
from [Bảng thống kê]
--Nhận xét:
--Ưu điểm: lưu trữ lại dl thống kê rõ ràng, có thể tái sử dụng.
--Nhược điểm: tốn bộ nhớ, nhìn sẽ rối.

--Cách 2: dùng View
drop table [Bảng thống kê]
drop view Bang_Thong_Ke
--view có định nghĩa 5 tên cột
create view Bang_Thong_Ke(MSSV, [Họ và tên], [Ngày sinh], [Phái], [ĐTB])
as
	select S.MSSV, HoTen, convert(varchar(10), NTNS, 103), 
	iif(PHAI=1, 'Nam', N'Nữ'), cast(avg(DIEM) as decimal(4,2))
	from SINHVIEN S, DIEMSV D
	where S.MSSV=D.MSSV
	group by S.MSSV, HoTen, NTNS, PHAI
--Kiểm tra lại:
select *
from Bang_Thong_Ke
--view không có định nghĩa 5 tên cột trước mà viết trong thân của view
drop view Bang_Thong_Ke
--
create view Bang_Thong_Ke --ko cần chỉ ra tên cột ở đây
as
	select S.MSSV, HoTen as [Họ và tên], 
	convert(varchar(10), NTNS, 103) as [Ngày sinh], 
	iif(PHAI=1, 'Nam', N'Nữ') as [Phái],
	cast(avg(DIEM) as decimal(4,2)) as [ĐTB]
	from SINHVIEN S, DIEMSV D
	where S.MSSV=D.MSSV
	group by S.MSSV, HoTen, NTNS, PHAI
--Kiểm tra lại:
select *
from Bang_Thong_Ke
--
drop view Bang_Thong_Ke
--Mã hóa code trong thân view, ko cho coi
alter view Bang_Thong_Ke --ko cần chỉ ra tên cột ở đây
with encryption --mã hóa
as
	select S.MSSV, HoTen as [Họ và tên], 
	convert(varchar(10), NTNS, 103) as [Ngày sinh], 
	iif(PHAI=1, 'Nam', N'Nữ') as [Phái],
	cast(avg(DIEM) as decimal(4,2)) as [ĐTB]
	from SINHVIEN S, DIEMSV D
	where S.MSSV=D.MSSV
	group by S.MSSV, HoTen, NTNS, PHAI
--
--Viết view có tên Liet_Ke hiển thị Mã MH, Tên MH cùng tổng số SV đã dự thi 
--và đã có điểm
create view Liet_Ke
as
	select MH.MaMH as [Mã MH],TENMH as [Tên MH], COUNT (D.MSSV) as SLSV 
	from MONHOC MH, DIEMSV D
	where MH.MaMH = D.MaMH AND DIEM IS NOT NULL
	group by TENMH, MH.MaMH
--Kiểm tra:
select *
from Liet_Ke
--C/C++
#include <stdio.h>
#include <function.h>
bool	NguyenTo(int x); --trả về true (1)/false (0)
void	NguyenTo(int x); --ko trả về giá trị mà xử lý bên trong thân hàm
--CT con (sub-program)
--Viết view thống kê Mã MH, Tên MH và tổng số SV đã dự thi và đã có điểm,
--với Mã MH là tham số truyền vào. Vd: MAMH='COS202'
--=> Ta phải sửa lại view ở trên
alter view Liet_Ke
as
	select MH.MaMH as [Mã MH],TENMH AS[Tên MH], COUNT (D.MSSV) AS SLSV 
	from MONHOC MH, DIEMSV D
	where MH.MaMH = D.MaMH AND DIEM IS NOT NULL and D.MAMH='COS202'
	group by TENMH, MH.MaMH
--Kiểm tra lại:
select *
from Liet_Ke
--Khi yêu cầu MAMH khác thì ta phải vào sửa lại View.
--Ta nên xây dựng thành CT con, có đối số truyền vào là MAMH, mỗi lần thực thi
--ta sẽ truyền vào MAMH tương ứng. Khi đó, ta ko dùng VIEW được nữa.
--CT con trong SQL Server bao gồm: Stored Procedure và Function.
--Trong C|C++: Stored Procedure <=> void  Liet_Ke(char(6) MAMH)
--			   Function		    <=> float Liet_Ke(char(6) MAMH)
int Tong_2_so_C1(int x, int y)
{
	return (x+y); --Nhập x=3, y=5. Tong_2_so=8
}

void Tong_2_so_C2(int x, int y, int tong)
{
	tong=x+y; --Nhập x=3, y=5. tong=8???
}
void main()
{
	int t1,t2;
	t1=Tong_2_so_C1(3,5); printf("%d", t1); --In ra t1=8
	Tong_2_so_C2(3,5,t2); printf("%d", t2); --In ra t2=NULL
}
--Muốn biến tong có giá trị thay đổi theo khi kết thúc CT con, trong C|C++
--ta thêm dấu & vào trước biến
void Tong_2_so_C2(int x, int y, int &tong) --&tong là tham biến
{
	tong=x+y; --Nhập x=3, y=5. tong=8???
}
--Viết trong SQL Server:
create proc Tong_2_so @x int, @y int, @tong int
as
	set @tong=@x+@y --gán tong=x+y
--Gọi thủ tục
declare @t int
exec Tong_2_so 3, 5, @t
print @t --Nhận xét: ko in @t được vì @t có gía trị=NULL, do là tham trị
--Ta phải sửa lại @t là tham biến
alter proc Tong_2_so @x int, @y int, @tong int output
as
	set @tong=@x+@y
--Gọi thủ tục
declare @t int
exec Tong_2_so 3, 5, @t out
print @t 

--Viết thủ tục in ra MAMH, TenMH cùng tổng số SV đã dự thi và đã có điểm với
--MAMH là tham số truyền vào.
create proc pLiet_Ke @MAMH char(6)
as
	select MH.MaMH as [Mã MH],TENMH AS[Tên MH], COUNT (D.MSSV) AS SLSV 
	from MONHOC MH, DIEMSV D
	where MH.MaMH = D.MaMH AND DIEM IS NOT NULL and MH.MaMH=@MAMH
	group by TENMH, MH.MaMH
--Gọi thủ tục:
exec pLiet_Ke 'COS202'
exec pLiet_Ke 'COS203'
exec pLiet_Ke 'COS201'
--Viết thủ tục in ra thông tin của SV với tên là tham số truyền vào.
--Nếu ko tìm thấy thì thông báo 'Không có SV này'.
alter proc pIn_SV(@Ten nvarchar(10))
as
	select MSSV, HoTen
	from SINHVIEN
	where HoTen like N'%' + @Ten
--Gọi thủ tục
exec pIn_SV('An') --Viết hàm có cặp dấu ngoặc thì cho, gọi thì ko dùng ngoặc
exec pIn_SV 'An'
exec pIn_SV 'Hoa'
--Bổ sung: nếu ko tìm thấy thì thông báo 'Không có SV này'.
alter proc pIn_SV @Ten nvarchar(10)
as
	if exists (select * 
			   from SINHVIEN
			   where HoTen like N'%' + @Ten) --nếu có >=1 dòng thì exists là TRUE
		select MSSV, HoTen
		from SINHVIEN
		where HoTen like N'%' + @Ten
	else
		print(N'Không có SV tên này')
--Gọi thủ tục
exec pIn_SV 'Anh'
exec pIn_SV 'Vương'
--Về nhà:
--1) Viết thủ tục có tên Giai_Thua cho phép tính n! với n nguyên dương
--là tham số truyền vào.
--C|C++
--Hàm
long Giai_Thua(int n)
{
	long GT;
	if(n==0) GT=1;
	else
	{
		GT=1;
		for(int i=1;i<=n;i++) GT=GT*i;
	}
	return GT;
}
--Thủ tục:
void Giai_Thua(int n, long &GT)
{
	if(n==0) GT=1;
	else
	{
		GT=1;
		for(int i=1;i<=n;i++) GT=GT*i;
	}
}
--SQL:
alter proc pGiai_Thua @n int, @GT bigint output
as
begin
	declare @i int
	if(@n=0) set @GT=1
	else
	begin
		set @GT=1
		set @i=1
		while (@i<=@n)
		begin
			set @GT=@GT*@i
			set @i=@i+1
		end
	end
end
--gọi thủ tục
declare @G bigint
exec pGiai_Thua 5, @G out
print @G
--2) Viết thủ tục có tên Tim_SV_Theo_MH cho phép in ra SV đạt điểm MH
--lớn nhất với MAMH là tham số truyền vào.
create proc pTim_SV_Theo_MH @MAMH char(6)
as
	select S.MSSV, HoTen, Diem
	from SINHVIEN S, DIEMSV D
	where S.MSSV=D.MSSV and MAMH=@MAMH
	and DIEM = 
		(select max(Diem)
		from DIEMSV
		where MAMH=@MAMH)
--gọi thủ tục
exec  pTim_SV_Theo_MH 'COS201'
exec  pTim_SV_Theo_MH 'COS202'
--Nếu MAMH ko truyền vào thì in ra
--tất cả các môn học cùng SV đạt điểm cao nhất của các MH đó.
alter proc pTim_SV_Theo_MH @MAMH char(6)
as
	if @MAMH is null
		select S.MSSV, HoTen, MaMH, Diem
		from SINHVIEN S, DIEMSV D
		where S.MSSV=D.MSSV and DIEM = 
				(select max(Diem)
				from DIEMSV)
	else if (not exists (select * from MONHOC where MAMH=@MAMH))
			print N'Môn học này không tồn tại!'
	else
		select S.MSSV, HoTen, MaMH, Diem
		from SINHVIEN S, DIEMSV D
		where S.MSSV=D.MSSV and MAMH=@MAMH and DIEM = 
			(select max(Diem)
			from DIEMSV
			where MAMH=@MAMH)
--gọi thủ tục
exec  pTim_SV_Theo_MH 'COS201'
exec  pTim_SV_Theo_MH 'COS200'
exec  pTim_SV_Theo_MH null

--Viết thủ tục in ĐTB của SV với MSSV là tham số truyền vào.
--Nếu MSSV ko tồn tại/ko có thì in ra 0.
create proc pIn_DTB @Ma char(6)
as
	if not exists (select * from SINHVIEN
				   where MSSV=@Ma)
		print 0
	else
		select avg(Diem)
		from DIEMSV
		where MSSV=@Ma
--gọi thủ tục
exec pIn_DTB '17000'
exec pIn_DTB '170001'
--Nếu thủ tục yêu cầu trả điểm trung bình vào 1 biến thì ta sửa thủ tục trên
--như thế nào?
alter proc pIn_DTB @Ma char(6), @dtb float out
as
	if not exists (select * from SINHVIEN
				   where MSSV=@Ma)
		set @dtb=0
	else
		select @dtb=avg(Diem)
		from DIEMSV
		where MSSV=@Ma
--gọi thủ tục
declare @diem float
exec pIn_DTB '17000', @diem out
print @diem
--
declare @diem float
exec pIn_DTB '170001', @diem out
print @diem
--Viết hàm tính tổng của 2 số nguyên a, b (tham số truyền vào)
create function fTong(@a int, @b int)
returns int
as
begin
	return (@a+@b)
end
--gọi hàm
--Cách 1:
print dbo.fTong(3,8)
select dbo.fTong(3,8)
--Cách 2:
declare @t int
set @t=dbo.fTong(3,8)
print @t
--Viết hàm tính ĐTB của SV với MSSV là tham số truyền vào.
alter function fDIEMTB(@MSSV char(6))
returns float
as
begin
	declare @DTB float
	select @DTB=avg(Diem)
	from DIEMSV
	where MSSV=@MSSV
	return @DTB
end
--gọi hàm
--Cách 1:
print N'ĐTB của 170001= ' + str(dbo.fDIEMTB('170001'))
print N'ĐTB của 180002= ' + str(dbo.fDIEMTB('180002'))
--Cách 2:
select dbo.fDIEMTB('170001')
select dbo.fDIEMTB('180002')
select dbo.fDIEMTB('180003')
--Cách 2:
select dbo.fDIEMTB('170001')
--Viết hàm tính số môn học của SV đã đăng ký dự thi và đã có điểm, với MSSV
--là tham số truyền vào.
alter function fDEM_SO_MH(@MSSV char(6))
returns int
as
begin
	declare @Dem int
	select @Dem=count(MAMH)
	from DIEMSV
	where DIEM is not null and MSSV=@MSSV
	return @Dem
end
--gọi hàm:
print dbo.fDEM_SO_MH('170001')
select dbo.fDEM_SO_MH('170001')
--Viết hàm đếm tổng số SV đạt ĐTB từ 5 trở lên.
create function fDem_SV()
returns int
as
begin
	declare @Dem int
	select @Dem=count(*)
	from (select MSSV
		  from DIEMSV
		  group by MSSV
		  having avg(Diem)>=5) temp
	return @Dem
end
--gọi hàm
select dbo.fDem_SV()