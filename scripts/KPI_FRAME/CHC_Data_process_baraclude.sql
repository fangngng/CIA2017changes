use BMSChinaCIA_IMS
exec dbo.sp_Log_Event 'KPI Frame_2','CIA IMS','CHC_Data_process_baraclude.sql','Start',null,null
go
update CMHrawdata_baraclude set product=molecule where product is null
update CMHrawdata_baraclude set product=molecule where product = ''
--check 是否所有产品为空的情况都update过来了
select min(len(product)) from CMHrawdata_baraclude --todo

go

if OBJECT_ID(N'inCMHdata_baraclude',N'U') is not null
	drop table  inCMHdata_baraclude
go
--VIREAD 产品乘系数再group
select 'Product' as producttype,a.molecule as molecule_cn,
	a.product as product_cn, 
	sum(case when a.product = N'韦瑞德' then a.value * 1 else a.value end)/(select Rate from BMSChinaCIA_IMS.dbo.tblRate) as value,
	sum(case when a.product = N'韦瑞德' then a.volume * 1 else a.volume end) as volume,CAST( CAST(A.YM AS VARCHAR(6))+'01' AS DATETIME) AS X
into inCMHdata_baraclude
from CMHrawdata_baraclude a
group by a.molecule,a.product,A.ym 
union 
select 'Market' as producttype,'','',
	sum(case when a.product = N'韦瑞德' then a.value * 1 else a.value end)/(select Rate from BMSChinaCIA_IMS.dbo.tblRate),
	sum(case when a.product = N'韦瑞德' then a.volume * 1 else a.volume end),CAST( CAST(A.YM AS VARCHAR(6))+'01' AS DATETIME) AS X
from CMHrawdata_baraclude a
group by A.YM
go
alter table inCMHdata_baraclude add molecule nvarchar(500),product nvarchar(500);
go

update a set a.molecule=b.mole_en,a.product=c.prod_en
from inCMHdata_baraclude a
left join BMSChinaMRBI.dbo.tblDefMolecule_CN_EN b
on a.molecule_cn=b.mole_cn
left join BMSChinaMRBI.dbo.tblDefProduct_CN_EN c
on a.product_cn=c.prod_cn
where a.producttype='Product'

--没有英文翻译的产品名
select distinct product_cn from inCMHdata_baraclude where product is null and producttype='Product'

update inCMHdata_baraclude set product='Wan Sheng rick' where product_cn=N'万生力克'
update inCMHdata_baraclude set product='Qian li an' where product_cn=N'乾力安'
update inCMHdata_baraclude set product='Xian te' where product_cn=N'仙特'
update inCMHdata_baraclude set product='Bai tai ning' where product_cn=N'佰泰宁'
update inCMHdata_baraclude set product='Jian gan lin' where product_cn=N'健甘灵'
update inCMHdata_baraclude set product='He ding' where product_cn=N'和定'
update inCMHdata_baraclude set product='He en' where product_cn=N'和恩'
update inCMHdata_baraclude set product='Mu chang' where product_cn=N'木畅'
update inCMHdata_baraclude set product='Gan bei qing' where product_cn=N'甘倍轻'
update inCMHdata_baraclude set product='Gan ze' where product_cn=N'甘泽'
update inCMHdata_baraclude set product='Ai pu ding' where product_cn=N'艾普丁'
update inCMHdata_baraclude set product='Shuang bei ding' where product_cn=N'贝双定'

--检查是否所有产品都被翻译成英文
select * from inCMHdata_baraclude where product is null and producttype='product'--todo
--VIREAD 产品乘系数
-- update inCMHdata_baraclude set value=value*1,volume=volume*1 where product='VIREAD'
go

--将市场的产品名和分子式名update成''
update inCMHdata_baraclude set molecule='', product='' where producttype='Market'
go

if OBJECT_ID(N'CMHData_MTH_baraclude',N'U') is not null
drop table  CMHData_MTH_baraclude
go

select * 
into CMHData_MTH_baraclude
from 
(
	select * from inCMHdata_baraclude
) a
unpivot ( Y for category in ( value,volume )) t
GO


if OBJECT_ID(N'tblCMDData_baraclude',N'U') is not null
drop table  tblCMDData_baraclude
go

select 'MTH' as period_type,a1.producttype,cast('sales' as varchar(10)) as datatype,a1.molecule,a1.product,a1.category,a1.y,CONVERT(VARCHAR(6), A1.X, 112)  AS X
into tblCMDData_baraclude
from CMHData_MTH_baraclude a1
union all
SELECT 'YTD' as period_type,a1.producttype,'sales' as datatype,a1.molecule,a1.product,a1.category, SUM(A2.y),CONVERT(VARCHAR(6), A1.X, 112)  AS X
FROM CMHData_MTH_baraclude AS A1
JOIN CMHData_MTH_baraclude AS A2
ON ( A1.molecule = A2.molecule AND A1.product = A2.product and a1.producttype=a2.producttype and a1.category=a2.category
	AND (A2.x >= CAST(CAST(YEAR(A1.x) AS CHAR(4)) + '0101' AS DATETIME) AND A2.x <= A1.x) )		-- key condition
GROUP BY A1.molecule, A1.product,a1.producttype, A1.x,a1.category
union  all
SELECT 'MAT' as period_type,a1.producttype,'sales' as datatype,a1.molecule,a1.product,a1.category, SUM(A2.y),CONVERT(VARCHAR(6), A1.X, 112)  AS X
FROM CMHData_MTH_baraclude AS A1
JOIN CMHData_MTH_baraclude AS A2
ON ( A1.molecule = A2.molecule AND A1.product = A2.product  and a1.producttype=a2.producttype and a1.category=a2.category
	AND (A2.x >= DATEADD(Month, -11, A1.x) AND A2.x <= A1.x) )		-- key condition
GROUP BY A1.molecule, A1.product,a1.producttype, A1.x,a1.category

GO
alter table tblCMDData_baraclude add DM varchar(5);

go
update a set a.DM=b.DM
from tblCMDData_baraclude a
inner join db82.BMSCNProc2.dbo.tblDatamonthConv b
on a.x=b.datamonth

alter table tblCMDData_baraclude alter column X VARCHAR(20);

go
--share
insert into tblCMDData_baraclude
select a.period_type,a.producttype,'share' as datatype,a.molecule,a.product,a.category, case when b.y is null or b.y=0 then 0 else a.y/b.y end as y,a.x as x ,a.DM
 from tblCMDData_baraclude a
inner join tblCMDData_baraclude b
on a.period_type=b.period_type and a.producttype='product' and  b.producttype='Market' and a.x=b.x and a.category=b.category
union ALL
select a.period_type,a.producttype,'share' as datatype,a.molecule,a.product,a.category, case when b.y is null or b.y=0 then 0 else a.y/b.y end as y,a.x as x,a.DM
 from tblCMDData_baraclude a
inner join tblCMDData_baraclude b
on a.period_type=b.period_type and a.producttype='Market' and  b.producttype='Market' and a.x=b.x and a.category=b.category
go
--share_growth
insert into tblCMDData_baraclude
select a.period_type,a.producttype,'Growth' as datatype,a.molecule,a.product,a.category, case when b.y is null or b.y=0 then 0 else a.y/b.y end as y,a.period_type+' Share' as x ,a.DM
 from tblCMDData_baraclude a
inner join tblCMDData_baraclude b
on a.period_type=b.period_type and a.producttype='product' and  b.producttype='Market' and a.x=b.x and a.category=b.category and a.datatype=b.datatype
where a.DM IN ('M01','M12')  AND A.datatype='SALES'
union ALL
select a.period_type,a.producttype,'Growth' as datatype,a.molecule,a.product,a.category, case when b.y is null or b.y=0 then 0 else a.y/b.y end as y,a.period_type+' Share' as x,a.DM
 from tblCMDData_baraclude a
inner join tblCMDData_baraclude b
on a.period_type=b.period_type and a.producttype='Market' and  b.producttype='Market' and a.x=b.x and a.category=b.category and a.datatype=b.datatype
where a.DM IN ('M01','M12')  AND A.datatype='SALES'
go
--share change
insert into tblCMDData_baraclude
select a.period_type,a.producttype,'Growth' as datatype,a.molecule,a.product,a.category, a.y-b.y as y,a.period_type+' Share Change' as x ,a.DM
 from tblCMDData_baraclude a
inner join tblCMDData_baraclude b
on a.period_type=b.period_type and a.producttype=b.producttype and a.x=b.x and a.category=b.category and a.datatype=b.datatype and a.DM='M01' AND B.DM='M12' and a.product=b.product
where a.datatype='growth'
go
--growth

insert into tblCMDData_baraclude
select a.period_type,a.producttype,'Growth' as datatype,a.molecule,a.product,a.category, case when b.y is null or b.y=0 then 0 else (a.y-b.y)/b.y end as y,a.period_type+' Growth' as x,a.DM
 from tblCMDData_baraclude a
left join tblCMDData_baraclude b
on a.datatype=b.datatype and a.period_type=b.period_type and a.producttype=b.producttype and right(a.DM,2)+12=right(b.DM,2) and a.category=b.category and a.molecule=b.molecule and a.product=b.product
where a.datatype='sales'
go


--INDEX:
alter table tblCMDData_baraclude add series varchar(200),series_idx int null,x_idx int null,category_idx int null;

go

update tblCMDData_baraclude set series=product 
update tblCMDData_baraclude set series='ARV Market' where series=''
update tblCMDData_baraclude set series=case when product='Run Zhong'  then 'Entecavir Run Zhong' else series end --where category='value'
update tblCMDData_baraclude set series_idx=case when series='ARV Market' then 1
									  when series='Baraclude'  then 2
									  when series='Entecavir Run Zhong'  then 3
									  when series='Hepsera'  then 4
									  when series='Heptodin'  then 5
									  when series='Sebivo'  then 6
									  when series='Viread'  then 7
									  else null end
go
update tblCMDData_baraclude set category_idx= case when category='value' then 1 else 2 end

go
update a set a.x_idx=b.monseq
from tblCMDData_baraclude a
inner join tblMonthList b
on a.x=b.date
go
update tblCMDData_baraclude set x_idx=case when x='MAT Growth' then 1
									  when x='YTD Growth'  then 2
									  when x='MTH Growth'  then 3
									  when x='YTD Share'  then 4
									  when x='YTD Share Change'  then 5
									  else x_idx end
go



delete from tblCMDData_baraclude where right(dm,2)>13 
delete from tblCMDData_baraclude where series_idx is null
delete from tblCMDData_baraclude where datatype='sales' and period_type<>'MTH'
delete from tblCMDData_baraclude where datatype='sales' and product <>''
delete from tblCMDData_baraclude where datatype='share' and period_type<>'MTH'
delete from tblCMDData_baraclude where datatype='share' and product =''
delete from tblCMDData_baraclude where datatype='growth' and DM<>'m01'
delete from tblCMDData_baraclude where datatype='growth' and x not in  ('MAT Growth','YTD Growth','MTH Growth','YTD Share','YTD Share Change')
go
update tblCMDData_baraclude set datatype='share' where datatype='sales'
update a set x=convert(varchar(5),b.year)+left(b.MonthEN,3)
from tblCMDData_baraclude a join tblMonthList b on a.X=b.date


exec dbo.sp_Log_Event 'KPI Frame_2','CIA IMS','CHC_Data_process_baraclude.sql','End',null,null