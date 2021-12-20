Câu 1) Viết thủ tục có tên P in ra Mã lớp cùng sĩ số SV thuộc 
lớp đó, với mã lớp là tham số truyền vào.
Nếu mã lớp khôn tồn tại thì in ra 0.
--Phân tích: Nếu ta in ra cả 1 bảng cũng dc, ko hay.
alter proc P @MaLop char(7), @SiSo int output
as
	if exists (select * from LOP
			   where MALOP=@MaLop)
		select @SiSo=count(*)
		from SINHVIEN S, LOP L
		where S.MALOP=L.MALOP and L.MALOP=@MaLop
		group by L.MALOP
	else set @SiSo=0 --gán bằng 0
--
declare @SS int
exec P '19DTH02', @SS out
print @SS

Câu 2) Viết hàm có tên F trả về sĩ số SV thuộc lớp đó, với mã lớp 
là tham số truyền vào.
Nếu mã lớp khôn tồn tại thì trả về 0.
create function F(@MaLop char(7))
returns int
as
begin
	declare @SiSo int
	if exists (select * from LOP	--nếu lớp đó tồn tại
			   where MALOP=@MaLop)
		select @SiSo=count(*)
		from SINHVIEN S, LOP L
		where S.MALOP=L.MALOP and L.MALOP=@MaLop
		group by L.MALOP
	else set @SiSo=0
	return @SiSo
end
--gọi hàm
print dbo.F('19DTH02')
print dbo.F('19DTH05')
--
Câu 2 nâng cao: Hàm có tên F trả về MÃ LỚP và SĨ SỐ sinh viên
thuộc lớp đó, với mã lớp là tham số truyền vào.
Nếu mã lớp không tồn tại thì trả về 0.
==> Ta phải sửa lại câu 2 như thế nào???
Nhận xét: Hàm sẽ trả về 2 cột dữ liệu, ta ko dùng hàm trả về
1 giá trị được nữa mà trả về bảng dữ liệu.
drop function F
--Ta ko dùng hàm có 1 lệnh Return được mà dùng hàm định nghĩa
--bảng dữ liệu
insert into LOP values('20DTHA5', N'Khóa 20', 50)
insert into LOP values('20DTHA6', N'Khóa 20', 45)
--Ta có 2 bảng LOP(MALOP, TENLOP, SISO) và 
--LOP1(MALOP, TENLOP, SISO)
insert into LOP
	select MALOP, TENLOP, SISO
	from LOP1
--
create function F(@MaLop char(7))
returns @TongHop table (MALOP	char(7),
						SISO	int)
as
begin
	if exists (select * from LOP	--nếu lớp đó tồn tại
			   where MALOP=@MaLop)
		insert into @TongHop
			select L.MALOP, count(*)
			from SINHVIEN S, LOP L
			where S.MALOP=L.MALOP and L.MALOP=@MaLop
			group by L.MALOP
	 else
		insert into @TongHop values(@MaLop,0)
	return
end
--gọi hàm
select * from dbo.F('19DTH01')
select * from dbo.F('19DTH02')
select * from dbo.F('19DTH05')
select * from dbo.F('ABCD')
--Viết hàm trả về Tên môn học và Tổng số SV đã dự thi môn học đó
--và đã có điểm. Nếu mã MH ko tồn tại hay truyền vào NULL thì
--in ra cho tất cả các môn học.
drop function dbo.F1
--
alter function F1(@MAMH char(6))
returns @bang table ([Tên môn học]	nvarchar(50),
					 [Tổng số SV]	int) 
begin
	if exists (select * from MONHOC --nếu MAMH tồn tại
			   where MAMH=@MAMH)
		insert into @bang
			select TENMH, count(MSSV)
			from MONHOC M, DIEMSV D
			where M.MAMH=D.MAMH and D.MAMH=@MAMH
					and Diem is not null --dã có điểm
			group by TENMH
		else
			insert into @bang values(@MAMH, 0)
	return
end
--
select * from dbo.F1('COS201')
select * from dbo.F1('COS204')
select * from dbo.F1('COS209')