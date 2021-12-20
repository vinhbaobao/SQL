use DLVN
--Làm nhiều cách
--1) In ra Tên các tỉnh, TP thuộc miền Nam hoặc miền Trung.

select TEN_T_TP
from TINH_TP
where MIEN='Trung' or MIEN='Nam'
--Hoặc:
select TEN_T_TP
from TINH_TP
where MIEN in ('Trung', 'Nam')
--Hoặc:
select TEN_T_TP
from TINH_TP
where MIEN like 'Trung' or MIEN like 'Nam'

--Cách khác:
select TEN_T_TP
from TINH_TP		--R(MA_T_TP, TEN_T_TP, DT, DS, MIEN)
where MIEN='Trung'
UNION --phép hội
select TEN_T_TP
from TINH_TP		--S(MA_T_TP, TEN_T_TP, DT, DS, MIEN)
where MIEN='Nam'

--Cách khác:
select TEN_T_TP
from TINH_TP		--R(MA_T_TP, TEN_T_TP, DT, DS, MIEN)
EXCEPT --phép trừ
select TEN_T_TP
from TINH_TP		--S(MA_T_TP, TEN_T_TP, DT, DS, MIEN)
where MIEN=N'Bắc'
--2) In ra Tên các tỉnh, TP vừa giáp LAO và giáp CPC.
select TEN_T_TP 
from TINH_TP 
where MA_T_TP in 
	(select MA_T_TP from BIENGIOI where NUOC in ('LAO','CPC') 
	 group by MA_T_TP
	 having count(MA_T_TP)>=2)
--
select TEN_T_TP
from TINH_TP T, BIENGIOI B
where T.MA_T_TP=B.MA_T_TP 
	and NUOC='LAO' --Bến Tre, Gia Lai, Lai Châu, Ninh Thuận
INTERSECT --Phép giao
select TEN_T_TP
from TINH_TP T, BIENGIOI B
where T.MA_T_TP=B.MA_T_TP 
	and NUOC='CPC' --An Giang, Bình Phước, Đắc Lắc, Đồng Tháp, Gia Lai
					--Kiên Giang, Long An, Tây Ninh


--Phép chia:
--SQL: In ra màn hình tên các tỉnh, TP giáp với tất cả các nước là biên giới của VN.
--Q = R / S, với R là BIENGIOI, S là TINH_TP.
--Q = BIENGIOI/TINH_TP = NUOC.
--NUOC		TINH_TP
--------------------
--LAO		AG
--CPC		AG
--TQ		AG
--LAO		TN
--CPC		TN
--..................
--1123_Nguyễn Hữu Tiến10:15
select TEN_T_TP
from TINH_TP
where MA_T_TP in 
(
	select MA_T_TP from BIENGIOI where NUOC in ('LAO', 'CPC', 'TQ')
	group by MA_T_TP
	having count(MA_T_TP)>=3 --Làm sao biết 3 biên giới???
)
--0729_Nguyễn Xuân Nhân10:17
SELECT T.TEN_T_TP
FROM dbo.TINH_TP T, dbo.BIENGIOI B
GROUP BY T.TEN_T_TP
HAVING COUNT(DISTINCT B.NUOC) =
(
SELECT COUNT(B.NUOC)
FROM dbo.BIENGIOI B
)
--1142_Lê Trọng Tính10:24
select TEN_T_TP
from TINH_TP, dbo.BIENGIOI
where dbo.TINH_TP.MA_T_TP =ALL
(
	select DISTINCT NUOC
	FROM dbo.BIENGIOI
)

SELECT TEN_T_TP FROM TINH_TP WHERE MA_T_TP IN 
(
	SELECT MA_T_TP FROM BIENGIOI
	WHERE MA_T_TP NOT IN 
		(SELECT MA_T_TP FROM 
			(
				(SELECT MA_T_TP,NUOC FROM (SELECT distinct NUOC FROM BIENGIOI) AS B
					CROSS JOIN 
				(SELECT distinct MA_T_TP FROM BIENGIOI) AS G)
					EXCEPT
				(SELECT MA_T_TP, NUOC FROM BIENGIOI)
			) AS BG
		)
)
--
select TEN_T_TP, count(NUOC) as [Số biên giới]
from TINH_TP T, BIENGIOI B
where T.MA_T_TP=B.MA_T_TP
group by TEN_T_TP
having count(NUOC) = (select count(distinct NUOC) from BIENGIOI)
--Đếm xem VN có bao nhiêu biên giới? (Nhiều cách)
select count(distinct NUOC) as [Số biên giới của VN]
from BIENGIOI
--Cách khác:
select NUOC as [Số biên giới của VN]
from BIENGIOI
group by NUOC
--In ra tên các tỉnh, TP có biên giới
select distinct TEN_T_TP
from TINH_TP T, BIENGIOI B
where T.MA_T_TP=B.MA_T_TP
--Ứng dụng phép kết trái
--In ra tên các tỉnh, TP cùng biên giới giáp, nếu ko có biên giới thì để trống
--hoặc ghi NULL
select TEN_T_TP, NUOC
from TINH_TP T, BIENGIOI B
where T.MA_T_TP=B.MA_T_TP
union 
select TEN_T_TP, NULL
from TINH_TP
where MA_T_TP not in (select MA_T_TP from BIENGIOI)
--Ta dùng phép kết trái:
select TEN_T_TP, NUOC
from TINH_TP T left join BIENGIOI B
on T.MA_T_TP=B.MA_T_TP