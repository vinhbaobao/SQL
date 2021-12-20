--Hàm trả về bảng dữ liệu:
--1) Viết CT con trả về MSSV, Họ tên, NTNS, Phai, Lớp của 1 SV khi truyền vào
--MSSV.
--Cách 1: dùng stored procedure
create proc pCau1 @MSSV char(6)
as
begin
	select MSSV, HoTen, NTNS, Phai, MaLop
	from SINHVIEN
	where MSSV=@MSSV
end
--gọi thủ tục
exec pCau1 '170001'
exec pCau1 '180002'
--Cách 2: dùng function
create function fCau1(@MSSV char(6))
returns table
as			--sau return chỉ có đúng 1 lệnh select đặt giữa cặp dấu ngoặc
	return (select MSSV, HoTen, NTNS, Phai, MaLop
			from SINHVIEN
			where MSSV=@MSSV)
--gọi hàm
select * from dbo.fCau1('170001')
select * from dbo.fCau1('180002')
--Nhận xét: 2 cách viết trên là tương đương nhau, tùy thói quen của programmer
--2) Viết hàm trả về mã lớp và sĩ số SV của lớp đó với mã lớp là tham số
--truyền vào.
alter function fCau2(@MaLop char(7))
returns table
as
	return (select MaLop, count(MSSV) as [Sĩ số SV]
			from SINHVIEN
			where MaLop=@MaLop
			group by MaLop)
--gọi hàm
select * from dbo.fCau2('18DTH01')
select * from dbo.fCau2('18DTH02')
--Nếu câu trên yêu cầu viết thành procedure, nhận giá trị truyền vào là MaLop,
--nhận giá trị trả về là sĩ số của lớp đó thì viết lại như thế nào?
alter proc pCau2 @MaLop char(7), @SiSo int output
as
begin
	select @SiSo=count(MSSV)
	from SINHVIEN
	where MaLop=@MaLop
	group by MaLop
end
--gọi thủ tục
declare @ss int
exec pCau2 '18DTH01', @ss out
print @ss
--3) Hàm: Bổ sung câu 2, nếu mã lớp không truyền vào (NULL)
--thì in ra tất cả các lớp.
alter function fCau2(@MaLop char(7))
returns table
as
	return (if @MaLop is not null
				select MaLop, count(MSSV) as [Sĩ số SV]
				from SINHVIEN
				where MaLop=@MaLop
				group by MaLop
			else
				select MaLop, count(MSSV) as [Sĩ số SV]
				from SINHVIEN
				group by MaLop)
--Nhận xét: Ta ko thể dùng if-else vòng trong hàm dạng này. Phải tạo hàm mới
--theo cách khác.
--Còn nhớ???
insert into SINHVIEN values('200001', N'Trịnh Văn Cường',...)
--
insert into SINHVIEN
	select MSSV, HoTen,...
	from SV
--
create function fCau2_Tao_bang(@MaLop char(7))
returns @Tonghop table (MaLop char(7),
					   SiSO	int)
as
begin
	if @MaLop is not null
		insert into @Tonghop
			select MaLop, count(MSSV)
			from SINHVIEN
			where MaLop=@MaLop
			group by MaLop
	else --in tất cả các lớp
		insert into @Tonghop
			select MaLop, count(MSSV)
			from SINHVIEN
			group by MaLop
	return
end
--gọi hàm
select * from dbo.fCau2_Tao_bang('18DTH01')
select * from dbo.fCau2_Tao_bang(NULL)
--4) Viết hàm in ra MSSV, HoTen cùng Điểm trung bình của 1 SV với MSSV là
--tham số truyền vào, nếu ko truyền vào thì in ra tất cả các SV.
alter function fCau4(@MSSV char(6))
returns @Tonghop table (MSSV	char(6),
					    HoTen	nvarchar(50),
						ĐTB		decimal(4,2))
as
begin
	if @MSSV is not null
		insert into @Tonghop
			select S.MSSV, HoTen, avg(Diem)
			from SINHVIEN S, DIEMSV D
			where S.MSSV=D.MSSV and S.MSSV=@MSSV
			group by S.MSSV, HoTen
	else
		insert into @Tonghop
			select S.MSSV, HoTen, avg(Diem)
			from SINHVIEN S, DIEMSV D
			where S.MSSV=D.MSSV
			group by S.MSSV, HoTen
	return
end
--gọi hàm:
select * from dbo.fCau4('170001')
select * from dbo.fCau4('180002')
select * from dbo.fCau4(null)
--
set dateformat dmy
if dateadd(yy, 18, '19/10/2003') > getdate()
	print N'Chưa đủ 18 tuổi'
else
	print N'Đã đủ 18 tuổi'
--
--Ràng buộc không cho phép thêm, sửa cột MaLop ở bảng SINHVIEN nếu MaLop
--không có trong bảng LOP:
create trigger TONTAI_SV on SINHVIEN
for insert, update
as
	if NOT EXISTS (select * from INSERTED I,  LOP L
		           where I.MaLop = L.MaLop) 
 	begin 
		print N'Mã lớp chưa tồn tại'
		rollback tran
 	end
--Nhận xét: vì ràng buộc khóa ngoại chạy trước nên trigger ta bị vô hiệu hóa.
--Muốn trigger ta hoạt động thì ta phải bỏ ràng buộc khóa ngoại trong
--Diagram.
--
--1) Viết view V1 hiển thị thông tin MAMH, TENMH và tổng số SV đã 
--đăng ký học môn đó
--2) Viết thủ tục P1 nhận vào tham số là MSSV, trả về điểm TB
--của SV đó.
--3) Viết hàm F1 nhận vào tham số là MSSV, trả về điểm TB
--của SV đó.
--4) Viết hàm F2 nhận vào tham số là MAMH, in ra mã môn học và
--tổng số SV đã đăng ký học môn đó. Nếu MAMH truyền vào là NULL
--thì in ra tất cả các môn học cùng số SV đăng ký.
--
--5) Viết trigger cho phép tự động cập nhật sĩ số của 1 lớp khi
--người dùng thêm/xóa/sửa mã lớp của SV.
alter trigger Cap_Nhat_Si_So on SINHVIEN
for insert, update, delete
as
begin
	update LOP
	set SiSo = (select count(*)
				from SINHVIEN S
				where MaLop=(select MaLop from inserted)
				group by MaLop)
	where LOP.MaLop=(select MaLop from inserted)
	update LOP
	set SiSo = (select count(*)
				from SINHVIEN S
				where MaLop=(select MaLop from deleted)
				group by MaLop)
	where LOP.MaLop=(select MaLop from deleted)
end
--Xét bài quản lý bán hàng:
CTHD(MAHD varchar(10), MAVT varchar(5), SL int, GIABAN float, 
THANHTIEN float)
--Khi user nhập SL và GIABAN, tự động cập nhật cột THANHTIEN.
--Với THANHTIEN=SL*GIABAN
create trigger CapNhatThanhTien on CTHD
for insert, update
as
begin
	declare @MAHD varchar(10), @MAVT varchar(5),
			@SL int, @Gia float
	select @MAHD=MAHD, @MAVT=MAVT, @SL=SL, @Gia=GIABAN
	from inserted
	
	update CTHD
	set THANHTIEN = @SL*@Gia
	where MAHD=@MAHD and MAVT=@MAVT
end
--Cho 2 bảng: 
--DDH(MAHD char(5), NGAYLAP date)
--PHIEUXUAT(SOPX char(5), NGAYXUAT date, MAHD char(5))
--phiếu xuất cho hóa đơn
Hãy viết trigger với ràng buộc Ngày xuất của 1 phiếu xuất
luôn >= Ngày lập của đơn đặt hàng.
create trigger KT_Ngay on PHIEUXUAT
for insert, update
as
begin
	declare @MAHD char(5), @NX date
	select @MAHD=MAHD, @NX=NGAYXUAT
	from inserted
	if (select NGAYLAP
		from DDH
		where MAHD=@MAHD)>@NX
	begin
		print(N'Ngày lập phải <= Ngày xuất')
		rollback tran	
	end
end
