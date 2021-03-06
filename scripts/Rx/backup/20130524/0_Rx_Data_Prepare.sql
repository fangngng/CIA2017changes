/*

-- 疑问：
use BMSChinaOtherDB
go

SELECT date,count(*)
FROM [BMSChinaOtherDB].[dbo].[inRx]
where date is not null
group by date

SELECT date,count(*)
FROM BMSChinaMRBI.[dbo].[inRx]
group by date



*/



/* 

前置依赖：

CAP: tblMktDefRx 


*/
use BMSChinaMRBI
go

update tblDSDates set Value1 = '2012H2',Value2 = '201201231' where Item = 'RX'
go


-- Using the indication data
if object_id(N'inRx',N'U') is not null
	drop table inRx
go
insert into inRx
select 
   a.Area
  ,'12H2'       as Date
  ,a.医院级别   as level
  ,a.科室名称   as Department
  ,a.处方来源   as source
  ,a.报销       as expense
 
  ,b.药品编码   as Mole_code
  ,b.中文通用名 as Molecule
  ,b.英文名称   as Molecule_en
  
  ,a.商品名称   as Product
  ,a.规格       as specifications
  ,a.给药途径   as  route
  ,a.处方张数   as Rx
  ,a.取药数量   as num
  ,a.单价       as unit
  ,a.金额       as amount 				
from BMSChinaOtherDB.dbo.inRx_2012H2 a
inner join BMSChinaOtherDB.dbo.inRx_MoleculeRef b on a.药品编码 = b.药品编码
GO



if object_id(N'tblRxHalfYearList',N'U') is not null
	drop table tblRxHalfYearList
go

select row_number() over(order by date desc) Idx, Date as H 
into tblRxHalfYearList
from(
select distinct date from inRx
) a
go

select * from tblRxHalfYearList
go