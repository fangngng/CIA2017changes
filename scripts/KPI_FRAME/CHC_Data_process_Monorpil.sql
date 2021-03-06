use BMSChinaCIA_IMS
exec dbo.sp_Log_Event 'KPI Frame_2','CIA IMS','CHC_Data_process_Monorpil.sql','Start',null,null
go
update Retail_Monopril set product=molecule where product is null
update Retail_Monopril set product=molecule where product = ''
--check 是否所有产品为空的情况都update过来了
select min(len(product)) from Retail_Monopril --todo

go

if OBJECT_ID(N'inCMHdata_Monopril',N'U') is not null
drop table  inCMHdata_Monopril
go
select 'Product' as producttype,a.molecule as molecule_cn,a.product as product_cn,sum(a.value)/(select Rate from BMSChinaCIA_IMS.dbo.tblRate) as value,sum(a.volume) as volume,CAST( CAST(A.YM AS VARCHAR(6))+'01' AS DATETIME) AS X
into inCMHdata_Monopril
from Retail_Monopril a where 区域=N'全国'
group by a.molecule,a.product,A.ym 
union 
select 'Market' as producttype,'','',sum(value)/(select Rate from BMSChinaCIA_IMS.dbo.tblRate),sum(volume),CAST( CAST(A.YM AS VARCHAR(6))+'01' AS DATETIME) AS X
from Retail_Monopril a where 区域=N'全国'
group by A.YM
go
alter table inCMHdata_Monopril add molecule nvarchar(500),product nvarchar(500);
go

update a set a.molecule=b.mole_en,a.product=c.prod_en
from inCMHdata_Monopril a
left join BMSChinaMRBI.dbo.tblDefMolecule_CN_EN b
on a.molecule_cn=b.mole_cn
left join BMSChinaMRBI.dbo.tblDefProduct_CN_EN c
on a.product_cn=c.prod_cn
where a.producttype='Product'


--将市场的产品名和分子式名update成''
update inCMHdata_Monopril set molecule='', product='' where producttype='Market'
go

if OBJECT_ID(N'CMHData_MTH_Monopril',N'U') is not null
drop table  CMHData_MTH_Monopril
go

select * 
into CMHData_MTH_Monopril
from 
(
select * from inCMHdata_Monopril
) a
unpivot ( Y for category in ( value,volume )) t
GO


if OBJECT_ID(N'tblCMDData_Monopril',N'U') is not null
drop table  tblCMDData_Monopril
go

select 'MTH' as period_type,a1.producttype,cast('sales' as varchar(10)) as datatype,a1.molecule,a1.product,a1.category,a1.y,CONVERT(VARCHAR(6), A1.X, 112)  AS X
into tblCMDData_Monopril
from CMHData_MTH_Monopril a1
union all
SELECT 'YTD' as period_type,a1.producttype,'sales' as datatype,a1.molecule,a1.product,a1.category, SUM(A2.y),CONVERT(VARCHAR(6), A1.X, 112)  AS X
FROM CMHData_MTH_Monopril AS A1
JOIN CMHData_MTH_Monopril AS A2
ON ( A1.molecule = A2.molecule AND A1.product = A2.product and a1.producttype=a2.producttype and a1.category=a2.category
	AND (A2.x >= CAST(CAST(YEAR(A1.x) AS CHAR(4)) + '0101' AS DATETIME) AND A2.x <= A1.x) )		-- key condition
GROUP BY A1.molecule, A1.product,a1.producttype, A1.x,a1.category
union  all
SELECT 'MAT' as period_type,a1.producttype,'sales' as datatype,a1.molecule,a1.product,a1.category, SUM(A2.y),CONVERT(VARCHAR(6), A1.X, 112)  AS X
FROM CMHData_MTH_Monopril AS A1
JOIN CMHData_MTH_Monopril AS A2
ON ( A1.molecule = A2.molecule AND A1.product = A2.product  and a1.producttype=a2.producttype and a1.category=a2.category
	AND (A2.x >= DATEADD(Month, -11, A1.x) AND A2.x <= A1.x) )		-- key condition
GROUP BY A1.molecule, A1.product,a1.producttype, A1.x,a1.category

GO
alter table tblCMDData_Monopril add DM varchar(5);

go
update a set a.DM=b.DM
from tblCMDData_Monopril a
inner join db82.BMSCNProc2.dbo.tblDatamonthConv b
on a.x=b.datamonth

alter table tblCMDData_Monopril alter column X VARCHAR(20);

go
--share
insert into tblCMDData_Monopril
select a.period_type,a.producttype,'share' as datatype,a.molecule,a.product,a.category, case when b.y is null or b.y=0 then 0 else a.y/b.y end as y,a.x as x ,a.DM
 from tblCMDData_Monopril a
inner join tblCMDData_Monopril b
on a.period_type=b.period_type and a.producttype='product' and  b.producttype='Market' and a.x=b.x and a.category=b.category
union ALL
select a.period_type,a.producttype,'share' as datatype,a.molecule,a.product,a.category, case when b.y is null or b.y=0 then 0 else a.y/b.y end as y,a.x as x,a.DM
 from tblCMDData_Monopril a
inner join tblCMDData_Monopril b
on a.period_type=b.period_type and a.producttype='Market' and  b.producttype='Market' and a.x=b.x and a.category=b.category
go
--share_growth
insert into tblCMDData_Monopril
select a.period_type,a.producttype,'Growth' as datatype,a.molecule,a.product,a.category, case when b.y is null or b.y=0 then 0 else a.y/b.y end as y,a.period_type+' Share' as x ,a.DM
 from tblCMDData_Monopril a
inner join tblCMDData_Monopril b
on a.period_type=b.period_type and a.producttype='product' and  b.producttype='Market' and a.x=b.x and a.category=b.category and a.datatype=b.datatype
where a.DM IN ('M01','M12')  AND A.datatype='SALES'
union ALL
select a.period_type,a.producttype,'Growth' as datatype,a.molecule,a.product,a.category, case when b.y is null or b.y=0 then 0 else a.y/b.y end as y,a.period_type+' Share' as x,a.DM
 from tblCMDData_Monopril a
inner join tblCMDData_Monopril b
on a.period_type=b.period_type and a.producttype='Market' and  b.producttype='Market' and a.x=b.x and a.category=b.category and a.datatype=b.datatype
where a.DM IN ('M01','M12')  AND A.datatype='SALES'
go
--share change
insert into tblCMDData_Monopril
select a.period_type,a.producttype,'Growth' as datatype,a.molecule,a.product,a.category, a.y-b.y as y,a.period_type+' Share Change' as x ,a.DM
 from tblCMDData_Monopril a
inner join tblCMDData_Monopril b
on a.period_type=b.period_type and a.producttype=b.producttype and a.x=b.x and a.category=b.category and a.datatype=b.datatype and a.DM='M01' AND B.DM='M12' and a.product=b.product
where a.datatype='growth'
go
--growth

insert into tblCMDData_Monopril
select a.period_type,a.producttype,'Growth' as datatype,a.molecule,a.product,a.category, case when b.y is null or b.y=0 then 0 else (a.y-b.y)/b.y end as y,a.period_type+' Growth' as x,a.DM
 from tblCMDData_Monopril a
left join tblCMDData_Monopril b
on a.datatype=b.datatype and a.period_type=b.period_type and a.producttype=b.producttype and right(a.DM,2)+12=right(b.DM,2) and a.category=b.category and a.molecule=b.molecule and a.product=b.product
where a.datatype='sales'
go


--INDEX:
alter table tblCMDData_Monopril add series varchar(200),series_idx int null,x_idx int null,category_idx int null;

go

update tblCMDData_Monopril set series=product 
update tblCMDData_Monopril set series='Hypertension Market' where series=''
update tblCMDData_Monopril set series=case when product='TRITACE'  then 'Tritace' else series end --where category='value'
update tblCMDData_Monopril set series_idx=case when series='Hypertension Market' then 1
									  when series='Acertil'  then 2
									  when series='Lotensin'  then 3
									  when series='Monopril'  then 4
									  when series='Tritace'  then 5
									  else null end
go
update tblCMDData_Monopril set category_idx= case when category='value' then 1 else 2 end

go
update a set a.x_idx=b.monseq
from tblCMDData_Monopril a
inner join tblMonthList b
on a.x=b.date
go
update tblCMDData_Monopril set x_idx=case when x='MAT Growth' then 1
									  when x='YTD Growth'  then 2
									  when x='MTH Growth'  then 3
									  when x='YTD Share'  then 4
									  when x='YTD Share Change'  then 5
									  else x_idx end
go



delete from tblCMDData_Monopril where right(dm,2)>13 
delete from tblCMDData_Monopril where series_idx is null
delete from tblCMDData_Monopril where datatype='sales' and period_type<>'MTH'
delete from tblCMDData_Monopril where datatype='sales' and product <>''
delete from tblCMDData_Monopril where datatype='share' and period_type<>'MTH'
delete from tblCMDData_Monopril where datatype='share' and product =''
delete from tblCMDData_Monopril where datatype='growth' and DM<>'m01'
delete from tblCMDData_Monopril where datatype='growth' and x not in  ('MAT Growth','YTD Growth','MTH Growth','YTD Share','YTD Share Change')
go
update tblCMDData_Monopril set datatype='share' where datatype='sales'
update a set x=convert(varchar(5),b.year)+left(b.MonthEN,3)
from tblCMDData_Monopril a join tblMonthList b on a.X=b.date

exec dbo.sp_Log_Event 'KPI Frame_2','CIA IMS','CHC_Data_process_Monorpil.sql','End',null,null