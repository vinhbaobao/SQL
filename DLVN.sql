drop database DLVN
create database DLVN
on
	name = 'DLVN_data', 
	filename = 'D:\Database\DLVN.MDF' 
)
log on
	name = 'DLVN_log', 
	filename = 'D:\Database\DLVN.LDF' 
)
use DLVN 
create table TINH_TP
(
	MA_T_TP		varchar(3) primary key, 
	TEN_T_TP	nvarchar(20),
	DT			float,
	DS			bigint,
	MIEN		nvarchar(10) check(MIEN in ('Nam','Trung',N'Bắc'))
)
create table BIENGIOI
(
	NUOC	nvarchar(15),
	MA_T_TP	varchar(3),	
	--khai báo khóa chính là 1 cặp thuộc tính
	primary key(NUOC, MA_T_TP),
	--khai 1 báo khóa ngoại, vì NUOC ko quản lý nên bỏ qua
	foreign key(MA_T_TP) references TINH_TP(MA_T_TP)
	on update cascade	--Khi sửa MA_T_TP ở TINH_TP thì MA_T_TP 
						--trong BIENGIOI sửa theo
	on delete no action	--Khi xóa MA_T_TP ở TINH_TP, nếu MA_T_TP 
						--trong BIENGIOI có tồn tại thì
						--ko cho phép xóa MA_T_TP trong TINH_TP
)
create table LANGGIENG
(
	MA_T_TP	varchar(3),	--PFK
	LG		varchar(3),	--PFK, chính là MA_T_TP nhưng vì trùng tên nên ta đặt
						--lại tên khác
	--định nghĩa khóa chính là một cặp thuộc tính
	primary key(MA_T_TP, LG),
	foreign key(MA_T_TP) references TINH_TP(MA_T_TP),
	foreign key(LG) references TINH_TP(MA_T_TP)

insert into TINH_TP values('AG', 'An Giang', 3406, 2142709, 'Nam')
select *
from TINH_TP

select	TT1, TT2,...
from	Bảng 1, Bảng 2,...
where	Kết bảng nếu có từ 2 Bảng trở lên VÀ lọc dữ liệu (nếu có)
group by	Thuộc tính cần gom nhóm
having	Điều kiện của nhóm
order by	Danh sách các thuộc tính cần sắp sếp ASC|DESC (mặc nhiên là ASC)

select	TEN_T_TP, DS 
from	TINH_TP 
where	DT>=5000 
use DLVN
--select	TEN_T_TP as N'Tên tỉnh, TP', DS as [Dân số]
--from	TINH_TP
--where	DT>=5000
--b) Có diện tích >= [input] (SV nhập một số bất kỳ từ bàn phím)
select	TEN_T_TP as N'Tên tỉnh, TP', DS as [Dân số]
from	TINH_TP
where	DT>=10000
--2. Xuất ra tên tỉnh, TP cùng với diện tích của tỉnh, TP:
--a) Thuộc miền Bắc
select	TEN_T_TP as N'Tên tỉnh, TP', DT as [Diện tích]
from	TINH_TP
where	MIEN=N'Bắc'

--Hoặc:
select TEN_T_TP, DT
from TINH_TP
where MIEN like N'Bắc' 
select TEN_T_TP, DT
from TINH_TP
where left(TEN_T_TP,1)='H'
--Hoặc:
select TEN_T_TP, DT
from TINH_TP
where TEN_T_TP like N'H%'	--Chú ý: % đại diện cho 0 hoặc n ký tự,
							--dấu _ đại diện cho 1 ký tự.
select TEN_T_TP, DT
from TINH_TP
where TEN_T_TP like N'H_______' --Hòa Bình/Hà Giang/Hưng Yên
--b) Thuộc miền [input] (SV nhập một miền bất kỳ từ bàn phím)
--3. Xuất ra các Tên tỉnh, TP biên giới thuộc miền [input] (SV cho một miền bất kỳ)
--4. Cho biết diện tích trung bình của các tỉnh, TP (Tổng DT/Tổng số tỉnh_TP).
select	sum(DT) --tổng DT
from TINH_TP
select	count(MA_T_TP)
from TINH_TP
select	count(TEN_T_TP) --tổng số tỉnh
from TINH_TP
select	count(MIEN) --tổng số tỉnh
from TINH_TP
select	count(*) --đếm số dòng, ko quan tâm đến cột
from TINH_TP

select	sum(DT)/count(*) as [Diện tích trung bình]
from	TINH_TP
--
--5. Cho biết dân số cùng với tên tỉnh của các tỉnh, TP có diện tích > 7000 Km2.
--6. Cho biết dân số cùng với tên tỉnh của các tỉnh miền ‘Bắc’.
--Chú ý:
select	* --Sẽ in ra bao nhiêu cột, dòng. Tại sao?
from	TINH_TP
--
select	* --Sẽ in ra bao nhiêu dòng. Tai sạo?
from	BIENGIOI
--
select	* --Sẽ in ra bao nhiêu cột, dòng. Tai sạo?
from	TINH_TP, BIENGIOI --select 64*14
--
select	TINH_TP.MA_T_TP, NUOC, BIENGIOI.MA_T_TP
from	TINH_TP, BIENGIOI --select 64*14
order by TEN_T_TP
--
for(int i=0;i<64;i++)
 for(int j=0;j<14;j++)
 {
	printf("\n %d %d", i, j);
 }--Tổ hợp
Khi chạy, in ra giá trị gì và in bao nhiêu dòng?
00
01
02
...
013
10
11
12
...
113

--7. Cho biết mã các nước là biên giới của các tỉnh miền ‘Nam’.
select	NUOC, TEN_T_TP, MIEN
from	TINH_TP, BIENGIOI
where	--kết bảng
		TINH_TP.MA_T_TP=BIENGIOI.MA_T_TP --các tỉnh có biên giới
		--lọc dl
		and MIEN='Nam'
--
select	NUOC as [Các nước giáp với tỉnh, TP thuộc miền Nam]
from	TINH_TP, BIENGIOI
where	--kết bảng
		TINH_TP.MA_T_TP=BIENGIOI.MA_T_TP --các tỉnh có biên giới
		--lọc dl
		and MIEN='Nam'
--Nhận xét: ta chỉ in ra CPC và LAO, 2 dòng thôi.
--Cách 1:
select	distinct NUOC	--distinct: nếu trùng nhau thì lấy 1 dòng đại diện
from	TINH_TP, BIENGIOI
where	--kết bảng
		TINH_TP.MA_T_TP=BIENGIOI.MA_T_TP
		--lọc dl
		and MIEN='Nam'
--Cách 2:
select	NUOC
from	TINH_TP, BIENGIOI
where	--kết bảng
		TINH_TP.MA_T_TP=BIENGIOI.MA_T_TP
		--lọc dl
		and MIEN='Nam'
group by NUOC --gom nhóm NUOC lại với nhau => 2 nhóm

--Hỏi: Có bao nhiêu tỉnh, TP giáp CPC? LAO? và TQ?
--Hiển thị ra màn hình: NUOC | [Số tỉnh, TP giáp]
--NUOC	[Số tỉnh, TP giáp]
--CPC			8
--LAO			4
--TQ			2
--Như vậy ta cần in ra bao nhiêu dòng, cột? => 3 dòng, 2 cột
--Như vậy, ta cần lấy bảng BIENGIOI, gom nhóm NUOC chung lại với nhau,
--đếm cột MA_T_TP.
select NUOC, count(MA_T_TP) as [Số tỉnh, TP giáp]
from BIENGIOI
group by NUOC
--Cách khác?
--Cách này gõ lệnh dài hơn và ko khoa học.
select count(MA_T_TP) as [Số tỉnh, TP giáp CPC]
from BIENGIOI
where NUOC='CPC'
--
select count(MA_T_TP) as [Số tỉnh, TP giáp LAO]
from BIENGIOI
where NUOC='LAO'
--
select count(MA_T_TP) as [Số tỉnh, TP giáp TQ]
from BIENGIOI
where NUOC='TQ'
--
--Khi gom nhóm trên 1 cột thuộc tính thì chú ý: các thuộc tính lân cận ta phải
--dùng các hàm kết hợp (agregate function) để xử lý: sum, count, min, max, avg.
--Giả sử có bảng: KETQUA(MSSV, MAMH, DIEM)
--Vd: MSSV	MAMH	DIEM
--	  sv1	M1		8
--	  sv1	M2		7
--	  sv2	M1		6
--	  sv3	M2		5
--	  sv3	M3		4
--Hỏi: 
--1) Khóa là gì?
--2) Mỗi SV đã học bao nhiêu môn, tổng điểm của các môn và điểm trung bình 
--của mỗi SV là bao nhiêu?
--Gom nhóm trên cột MSSV: sẽ tạo ra 3 nhóm là: sv1, sv2 và sv3.
--MSSV	MAMH	DIEM
--sv1	?		?
--sv2	?		?
--sv3	?		?
--MSSV	MAMH: ta xử lý ra sao?	DIEM: ta xử lý ra sao?
--sv1	count					sum|count|min|max|avg --5 hàm kết hợp
--sv2	count					sum|count|min|max|avg --(agregate function)	
--sv3	count					sum|count|min|max|avg				

--select MSSV, count(MAMH), sum(DIEM), avg(DIEM)
--from KETQUA
--group by MSSV

--8. Cho biết diện tích trung bình của các tỉnh, TP. (Sử dụng hàm)
select avg(DT) as [DT trung bình]
from TINH_TP
--9. Cho biết mật độ dân số (DS/DT) cùng với tên tỉnh, TP của tất cả 
--các tỉnh, TP.
select DS/DT as [Mật độ dân số]
from TINH_TP
--10. Cho biết tên các tỉnh, TP láng giềng của tỉnh ‘Long An’.
--Cách 1: Nhìn vào bảng LANGGIENG, cột LG có giá trị là 'LA' thì giá trị của cột
--MA_T_TP chính là láng giềng của Long An.
select TEN_T_TP as [Các tỉnh, TP là láng giềng của Long An]
from TINH_TP T, LANGGIENG L
where T.MA_T_TP=L.MA_T_TP and LG='LA' --Sao biết 'Long An' là 'LA'?
--Cách 2: Ta lấy MA_T_TP của TINH_TP kết với cột MA_T_TP bên LANGGIENG và 
--TEN_T_TP là 'Long An', lấy giá trị LG của bảng LANGGIENG ra.
select LG as [Các tỉnh, TP là láng giềng của Long An]
from TINH_TP T, LANGGIENG L
where T.MA_T_TP=L.MA_T_TP 
		and TEN_T_TP='Long An' --In ra tên tỉnh, TP sẽ in ra 4 dòng Long An
--Khắc phục:
--Cách 1:
select TEN_T_TP as [Các tỉnh, TP là láng giềng của Long An]
from TINH_TP T, LANGGIENG L
where T.MA_T_TP=L.MA_T_TP and LG= (select MA_T_TP
								  from TINH_TP
								  where TEN_T_TP='Long An')
--Cách 2:
select TEN_T_TP
from TINH_TP
where MA_T_TP IN
	(
		select LG as [Các tỉnh, TP là láng giềng của Long An]
		from TINH_TP T, LANGGIENG L
		where T.MA_T_TP=L.MA_T_TP 
				and TEN_T_TP='Long An'
	)


--Giải thích:								--Thứ tự xử lý
select TEN_T_TP	 as [Tỉnh, TP giáp Long An]	--Bước 3
from TINH_TP T, LANGGIENG L					--Bước 1
where T.MA_T_TP=L.MA_T_TP					--Bước 2
		and LG = (select MA_T_TP				--Bước 2.3
				 from TINH_TP					--Bước 2.1
				 where TEN_T_TP='Long An')		--Bước 2.2
--
select MA_T_TP, TEN_T_TP
from TINH_TP
where MA_T_TP IN --sau IN, select chỉ trả về 1 cột có cùng giá trị với
				 --cột trước IN
(--Lấy ra MA_T_TP giáp với Long An
	select L.MA_T_TP	--Ambiguous: mơ hồ
	from LANGGIENG L, TINH_TP T
	where L.LG=T.MA_T_TP
	and TEN_T_TP='Long An'
)
--11. Cho biết số lượng các tỉnh, TP giáp với ‘CPC’.
select count(MA_T_TP) as [Số tỉnh, TP giáp CPC]
from BIENGIOI
where NUOC='CPC'
--12. Cho biết tên những tỉnh, TP có diện tích lớn nhất.
--Xét cột DT, ta thấy đây là mảng 1 chiều gồm 64 phần tử kiểu số nguyên.
--Bài toán trở thành tìm phần tử lớn nhất của mảng 1 chiều.
--Thuật toán tìm phần tử lớn nhất của mảng 1 chiều A:
int max=A[0];
for(int i=1;i<n;i++)
	if (A[i]>max) max=A[i];
printf("Giá trị lớn nhất là %d: ", max);
--

--Cách 1: giống thuật toán ở trên
select TEN_T_TP, DT
from TINH_TP --tương đương với 1 vòng lặp for
where DT >= ALL --lới hơn hoạc bằng tất cả
	(select DT from TINH_TP) --tương đương với 1 vòng lặp for

--Diễn giải: >= ALL
--Cho 2 mảng A và B có giá trị như bên dưới.
--A=[2 5 3 6 9 3]
--B=[2 1 5 6 8 7 4]
--In ra giá trị của mảng A >= tất cả giá trị của mảng B. Trong C/C++, viết sao???
--Cách 1: 
	--B1: Tìm giá trị lớn nhất của B, đặt tên là max.
	--B2: Kiểm tra A, nếu phần tử nào >= max thì in ra.
--=> Xử lý qua 2 bước độc lập.
select TEN_T_TP, DT --Thứ tự 3
from TINH_TP --Thứ tự 1
where DT >= --B2: Kiểm tra A, nếu phần tử nào >= max thì in ra. --Thứ tự 2
	(--B1: Tìm giá trị lớn nhất của B.
		select max(DT) --Thứ tự 2.2
		from TINH_TP --Thứ tự 2.1
	)
--Cách 2: gom chung thành 1 xử lý.
for(int i=0;i<n;i++) --Mảng A
	for(int j=0;j<n;j++) --Nảng B
		if (A[i]>=B[j]) max=A[i];
select TEN_T_TP, DT --Thứ tự 3
from TINH_TP --Thứ tự 1
where DT>= ALL --Thứ tự 2
	(select DT --Thứ tự 2.2
	 from TINH_TP) --Thứ tự 2.1

--Cách 3: HUTECH. Dân lập trình hay xài.
--Ý tưởng: Sắp xếp DT giảm dần, lấy DT ở dòng đầu tiên => Lớn nhất.
select top 1 with ties TEN_T_TP, DT --3406
--with ties: kéo theo, nếu bằng nhau thì lấy tất cả
from TINH_TP
order by DT DESC --desc: descending, giảm dần | asc: ascending: tăng dần (mặc nhiên)

--13. Cho biết tỉnh, TP có mật độ DS đông nhất.

--14. Cho biết tên những tỉnh, TP giáp với hai nước khác nhau.
--Ý tưởng:
--Đếm số lần xuất hiện của mỗi phần tử trong mảng 1 chiều, nếu >=2 thì in ra.
for(int i=0;i<n;i++)
{
	int dem=0;
	for(int j=0;j<n;j++)
		if(A[i]=B[j]) dem++;
	if (dem>=2) printf("%d",A[i]);
}
--Trong CSDL, ta gom nhóm trên cột chứa phần tử cần xét. Cụ thể, xét bảng BIENGIOI,
--đếm xem MA_T_TP nào xuất hiện >= 2 lần thì in ra tên tỉnh, TP dó.
select MA_T_TP, count(NUOC) as [Số biên giới] --B4
from BIENGIOI --B1
where count(NUOC)>=2 --B2: tại Bước 2 này, SQL chưa biết hàm count(NUOC) là gì
group by MA_T_TP --B3
--Phải sửa lại:
select MA_T_TP, count(NUOC) as [Số biên giới] --B4
from BIENGIOI --B1
group by MA_T_TP --B3
having count(NUOC)>=2 --điều kiện của nhóm. Sau having phải là HÀM.

--Ví dụ khác: In ra tên tỉnh, TP có từ 5 láng giềng trở lên.
select TEN_T_TP, count(LG) as [Số láng giềng]
from TINH_TP T, LANGGIENG L
where T.MA_T_TP=L.MA_T_TP
group by TEN_T_TP
having count(LG)>=5
order by  [Số láng giềng] DESC --sau ORDER BY ta để tên HÀM hoặc tên CỘT đề được

--Nâng cao: In ra tên tỉnh, TP có nhiều láng giềng nhất.
--C1:
select TEN_T_TP, count(LG) as [Số láng giềng]
from TINH_TP T, LANGGIENG L
where T.MA_T_TP=L.MA_T_TP
group by TEN_T_TP
having count(LG) >= ALL
	(
		select count(LG) --Lấy ra 1 cột để so sánh
		from TINH_TP T, LANGGIENG L
		where T.MA_T_TP=L.MA_T_TP
		group by TEN_T_TP
	)
--C2:Tìm max của select con
select TEN_T_TP, count(LG) as [Số láng giềng]
from TINH_TP T, LANGGIENG L
where T.MA_T_TP=L.MA_T_TP  
group by TEN_T_TP
having  count(LG) = 
		(select max([Số LG]) 
		from (select count(LG) as [Số LG]--Lấy ra 1 cột để so sánh
			  from TINH_TP T, LANGGIENG L
			  where T.MA_T_TP=L.MA_T_TP
			  group by TEN_T_TP) as Temp)
--Hoặc:
select TEN_T_TP, [Số LG]
from TINH_TP T,  (select top 1 with ties T.MA_T_TP, count(LG) as [Số LG]
				  from TINH_TP T, LANGGIENG L
				  where T.MA_T_TP=L.MA_T_TP
				  group by T.MA_T_TP
				  order by  count(LG) DESC) as Temp
where T.MA_T_TP=Temp.MA_T_TP
--C3:
select top 1 with ties TEN_T_TP, count(LG) as [Số láng giềng]
from TINH_TP T, LANGGIENG L
where T.MA_T_TP=L.MA_T_TP
group by TEN_T_TP
order by count(LG) DESC

--
select TEN_T_TP, count(NUOC) as [Số nước giáp]
from TINH_TP T, BIENGIOI B
where T.MA_T_TP=B.MA_T_TP
group by TEN_T_TP --sau group by có thuộc tính gì thì sau group by
	--phải có thuộc tính đó, trừ hàm kết hợp (sum, count, avg, max, min)
having --điều kiện của nhóm
	count(NUOC)=2
--15. Cho biết danh sách các miền cùng với các tỉnh, TP trong các miền đó.
use DLVN
--
select TEN_T_TP, MIEN
from TINH_TP
order by MIEN --mặc nhiên tăng dần, asc: ascending
--16. Cho biết tên những tỉnh, TP có nhiều láng giềng nhất.
--Cách 1:
select TEN_T_TP, count(LG) as [Số LG]
from TINH_TP T, LANGGIENG L
where T.MA_T_TP=L.MA_T_TP
group by TEN_T_TP
having count(LG) >= ALL
	(
		select count(LG) as [Số LG]
		from LANGGIENG
		group by MA_T_TP
	)
--17. Cho biết những tỉnh, TP có diện tích nhỏ hơn diện tích trung bình 
--của tất cả tỉnh, TP.
--Thứ tự thi hành lệnh SQL: 
--1. from 
--2. where 
--3. group by 
--4. having 
--5. select 
--6. order by

select MA_T_TP, TEN_T_TP	--3
from TINH_TP				--1
where DT <					--2
	(
		select avg(DT)
		from TINH_TP
	)
--18. Cho biết tên những tỉnh, TP giáp với các tỉnh, TP ở miền ‘Nam’ 
--và không phải là miền ‘Nam’.
--Ý tưởng: Lấy trong bảng LANGGIENG cột MA_T_TP có LG thuộc miền Nam và miền
--của MA_T_TP ko thuộc miền Nam.
--MA_T_TP=Bình Thuận (Trung) giáp với LG=Đồng Nai (Nam)

select T.MA_T_TP, TEN_T_TP, MIEN
from TINH_TP T, LANGGIENG L
where T.MA_T_TP = L.MA_T_TP and MIEN<>'Nam' --Các tỉnh có láng giềng mà ko phải miền Nam					
	and LG in	--nhưng có LG là miền Nam
	(
		--các tỉnh có LG thuộc miền Nam
		select distinct LG
		from TINH_TP T, LANGGIENG L
		where T.MA_T_TP=L.LG and MIEN='Nam'
	)
--19. Cho biết tên những tỉnh, TP có diện tích lớn hơn tất cả các tỉnh, TP 
--láng giềng của nó.
select T1.Ten_T_TP
from TINH_TP T1
where T1.DT >= ALL
	(
		select T2.DT 
		from TINH_TP T2, LANGGIENG L
		where T2.Ma_T_TP=L.LG		--lấy ra DT của láng giềng tỉnh đang xét
		and L.Ma_T_TP=T1.Ma_T_TP	--so sánh với tỉnh ở select bên trên
	)
--20. Cho biết tên những tỉnh, TP mà ta có thể đến bằng cách 
--đi từ ‘TP.HCM’ xuyên qua ba tỉnh khác nhau và cũng khác với điểm 
--xuất phát, nhưng láng giềng với nhau.
TINH_TP		LANGGIENG	LANGGIENG	LANGGIENG
HCM			HCM|DN		DN|BTH		BTH|LD
			HCM|LA		LA|TG		TG|AG
select 'HCM' as [Xuất phát],L1.LG,L2.LG,L3.LG
from TINH_TP T, LANGGIENG L1, LANGGIENG L2, LANGGIENG L3
where T.MA_T_TP='HCM' and T.MA_T_TP=L1.MA_T_TP--xuất phát 
	and L1.LG=L2.MA_T_TP and L2.LG=L3.MA_T_TP
	--ko quay lại đích
	and L2.LG<>'HCM' and L3.LG<>'HCM' and L1.LG<>L3.LG