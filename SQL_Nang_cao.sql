--SQL nâng cao:
--in, not in, exists, not exits, all

--Hãy thực hiện các câu sau đây bằng nhiều cách (nếu có thể):
--1) In ra tên các tỉnh, TP có biên giới.
--Cách 1: Xét MA_T_TP có tồn tại trong BIENGIOI hay ko?
select distinct TEN_T_TP --distinct: nếu có dòng trùng nau thì lấy 1 dòng đại diện
from TINH_TP T, BIENGIOI B
where T.MA_T_TP=B.MA_T_TP
--Hoặc:
select TEN_T_TP
from TINH_TP T, BIENGIOI B
where T.MA_T_TP=B.MA_T_TP
group by TEN_T_TP --phân nhóm thì có 12 nhóm, trong đó có 2 nhóm có 2 biên giới
--Cách 2: Duyệt qua các tỉnh, TP trong bảng TINH_TP, nếu MA_T_TP tồn tại trong BIENGIOI
--thì in ra.
--Giống trong C/C++: In ra các phần tử của mảng A có trong mảng B.
for(int i=0;i<n;i++)
 for(int j=0;j<m;j++)
	if(A[i]==B[j]) printf("%d ", A[i]);
--
select TEN_T_TP		--3
from TINH_TP		--1
where MA_T_TP IN	--2	Lưu ý: Thuộc tính trước IN và thuộc tính sau select phải
					--có cùng kiều dl mới so sánh được
	(
		select distinct MA_T_TP	--2.2	Sau select này chỉ chọn đúng 1 thuộc tính
		from BIENGIOI			--2.1
	)
--Cách 3: exists
select TEN_T_TP
from TINH_TP T
where exists --Tồn tại. Exists trả về TRUE nếu select bên dưới trả về ít nhất 1 dòng,
						--ngược lại rả về FALSE.
(
	select *
	from BIENGIOI B
	where B.MA_T_TP=T.MA_T_TP
)

--Cách 4: count
select TEN_T_TP
from TINH_TP T
where 
(
	select count(*) --đếm số dòng, =0, =1 hoặc =2
	from BIENGIOI B
	where B.MA_T_TP=T.MA_T_TP
)>0 --nếu có từ 1 biên giới
--2) In ra tên tỉnh, TP ko có biên giới.
--Cách 1: not in
select TEN_T_TP		--3
from TINH_TP		--1
where MA_T_TP NOT IN	--2	Lưu ý: Thuộc tính trước NOT IN và thuộc tính sau select phải
						--có cùng kiều dl mới so sánh được
	(
		select distinct MA_T_TP	--2.2	Sau select này chỉ chọn đúng 1 thuộc tính
		from BIENGIOI			--2.1
	)
--Cách 2: not exsts
select TEN_T_TP
from TINH_TP T
where not exists --Ko tn tại. Not Exists trả về TRUE nếu select bên dưới ko trả về 
					--dòng nào, ngược lại rả về FALSE.
(
	select *
	from BIENGIOI B
	where B.MA_T_TP=T.MA_T_TP
)
--Cách 3:
select TEN_T_TP
from TINH_TP T
where 
(
	select count(*) --đếm số dòng, =0, =1 hoặc =2
	from BIENGIOI B
	where B.MA_T_TP=T.MA_T_TP
)=0 --ko có biên giới

--Cách 4:
SELECT DISTINCT T.TEN_T_TP
FROM TINH_TP T --lấy tất cả các tỉnh, TP
	EXCEPT --trừ
SELECT DISTINCT T.TEN_T_TP
FROM TINH_TP T, BIENGIOI B
WHERE T.MA_T_TP = B.MA_T_TP --lấy ra các tỉnh, TP có biên giới

--3) Cho biết tên các tỉnh, TP láng giềng của tỉnh ‘Long An’.
--Cách 1: Xét bảng BIENGIOI, giá trị của cột MA_T_TP là 'LA' thì giá trị của cột
--LG là láng giềng của Long An.
select LG
from LANGGIENG
where MA_T_TP='LA'
--Nhận xét: Đề yc in ra tên tỉnh, TP chứ ko phải in MA_T_TP, và làm sao biết 'LA'
--là Long An?
select TEN_T_TP as [Láng giềng của Long An]
from TINH_TP
where MA_T_TP in
	(
		select LG
		from TINH_TP T, LANGGIENG L
		where T.MA_T_TP=L.MA_T_TP and TEN_T_TP='Long An'
	)

--Cách 2: Xem trong LANGGIENG, cột LG có giá trị là 'LA' thì giá rị của cột
---MA_T_TP là láng giềng của nó.
select TEN_T_TP as [Láng giềng của Long An]
from TINH_TP
where MA_T_TP in
	(	
		select L.MA_T_TP
		from TINH_TP T, LANGGIENG L
		where T.MA_T_TP=L.LG and TEN_T_TP='Long An'
	)
--4) In ra tên tỉnh TP có từ 5 láng giềng trở lên.
--Cách 1: Xét bảng LANGGIENG, gom nhóm trên cột MA_T_TP, count cột LG.
--Kiểm tra xem count có >=5 hay không.
select TEN_T_TP, count(LG) as [Số láng giềng]
from TINH_TP T, LANGGIENG L
where T.MA_T_TP=L.MA_T_TP
group by TEN_T_TP
having count(LG)>=5
--Cách 2:
select TEN_T_TP, count(LG) as [Số láng giềng]
from TINH_TP T, LANGGIENG L
where T.MA_T_TP=L.MA_T_TP and
(
	select count(LG)
	from LANGGIENG L1
	where T.MA_T_TP=L1.MA_T_TP
)>=5 --Làm sao in ra luôn số láng giềng?
group by TEN_T_TP
--5) In ra tên tỉnh, TP có nhiều láng giềng nhất.
--Cách 1: >=ALL
--Giống trong C/C++: Cho 2 mảng A[n] và B[m], hãy in các phần tử trong A mà lớn hơn
--tất cả các phần tử trong B.
bool check;
for(int i=0;i<n;i++) --duyệt mảng A
{
	check=true;
	for(int j=0;j<m;j++) --duyệt mảng B
		if(A[i]<B[j]) check=false;
	if (check)	printf("%d ", A[i]);
}
select TEN_T_TP, count(LG) as [Số láng giềng]
from TINH_TP T, LANGGIENG L
where T.MA_T_TP=L.MA_T_TP
group by TEN_T_TP
having count(LG)>=ALL
	(
		select count(LG)
		from TINH_TP T, LANGGIENG L
		where T.MA_T_TP=L.MA_T_TP
		group by TEN_T_TP
	)
--Cách 2: HUTECH
select top 1 with ties TEN_T_TP, count(LG) as [Số láng giềng]
from TINH_TP T, LANGGIENG L
where T.MA_T_TP=L.MA_T_TP
group by TEN_T_TP
order by count(LG) DESC

--6) In tên tỉnh giáp với tất cả các biên giới của Việt Nam.
--Ý tưởng: Đếm số biên giới của VN. Tính số biên giới của từng tỉnh, TP.
--Tỉnh, TP nào có số biên giới = Tổng số biên giới của VN thì in ra.
select TEN_T_TP, count(NUOC) as [Số biên giới]
from TINH_TP T, BIENGIOI B
where T.MA_T_TP=B.MA_T_TP
group by TEN_T_TP
having count(NUOC) =
	(--Đếm số biên giới của VN
		select count(distinct NUOC)
		from BIENGIOI
	)


