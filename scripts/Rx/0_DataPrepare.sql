/*

-------------------------------------
[Bug #2593 => Peter]
2013-05-24 07:46 Resolved as Fixed By Peter 

Changed Assigned To from "Active" to"peter"
Changed Resolve Build from "" to"2013-05-24"

Rx数据处理方式:
1.Rx数据为全量数据(可能包含3整年数据)
2.利用客户给到的数据,与现有的数据库中数据进行对比.在数据库中,去掉源数据所包含的月份,保留历史数据(源数据未提供的数据).
3.正常计算.


Hi Aric,
Rx数据处理方式(生效时间,下次更新Rx数据时.)
1.Rx数据为全量数据(可能包含3整年数据)
2.利用客户给到的数据,与现有的数据库中数据进行对比.在数据库中,去掉源数据所包含的月份,保留历史数据(源数据未提供的数据).
3.正常计算.
-------------------------------------



-- Aric 2013/5/24 16:48:56  对源数据进行清理：

数据检查:
select distinct date 		
from BMSChinaOtherDB.dbo.inRx_2012H2All
09Q1
09Q2
09Q3
09Q4
10Q1
10Q2
10Q3
10Q4
11Q1
11Q2
11Q3
11Q4
12Q1
12Q2
12Q3
12Q4

select distinct date 		
from inRx
07H1
07H2
08H1
08H2
09H1
09H2
10H1
10H2
11H1
11H2
12H1
12H2

处理方法：
--1.backup
select * into inRx_history_2012H2all_Aric20130524 from inRx
GO
--2.清空
truncate table inRx
GO
--3.导入客户未给到的历史数据
insert into inRx
select * from inRx_history_2012H2all_Aric20130524
where date in ('07H1','07H2','08H1','08H2')
GO
--4.导入新数据：
insert into inRx
select 
   a.Area
  ,case date when 



      as Date
  ,a.医院级别   as [level]
  ,a.科室名称   as Department
  ,a.处方来源   as source
  ,a.报销       as expense
 
  ,b.药品编码   as Mole_code
  ,b.中文通用名 as Molecule
  ,b.英文名称   as Molecule_en
  
  ,a.商品名称   as Product
  ,a.规格       as specifications
  ,a.给药途径   as [route]
  ,a.处方张数   as Rx
  ,a.取药数量   as num
  ,a.单价       as unit
  ,a.金额       as amount 	
-- select *			
from BMSChinaOtherDB.dbo.Rx2012H2All_Rawdata a
inner join BMSChinaOtherDB.dbo.inRx_MoleculeRef b on a.药品编码 = b.药品编码
GO


*/











/* 

前置依赖：

CAP: tblMktDefRx 


*/
use BMSChinaMRBI
go


update tblDSDates set Value1 = '2016Q1',Value2 = '20160331' where Item = 'RX'
go









--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
--第一步：            Import Rowdata
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
--select * into BMSChinaOtherDB.dbo.inRX_2013H1 from inRx

-- Using the indication data
--truncate table inRx --由于本月所给数据是2015年来的全量数据，而旧表是2015年之前的全量数据，所以本次刷新时，直接insert2015年的全量数据。
--GO
--备份
--select * into inRx_2015Q3 from inRx

delete [inRx] 
from [inRx] a 
where exists 
  ( select * from db4.BMSChinaOtherDB.dbo.inRx_MoleculeRef b 
    where a.Mole_code = b.药品编码 
      and b.中文通用名 in (N'阿德福韦酯',N'替诺福韦酯',N'替比夫定',N'拉米夫定',N'恩替卡韦')) 
  and left(a.date,2) >= 13

insert into inRx
select
   a.Area
  ,subString(date,1,2) + case when  subString(date,4,1) in (1,2) then 'H1' when  subString(date,4,1) in (3,4) then 'H2' end as Date
  ,a.医院级别   as [level]
  ,a.科室   as Department
  ,a.来源   as source
  ,a.报销       as expense
 
  ,b.药品编码   as Mole_code
  ,b.中文通用名 as Molecule
  ,b.英文名称   as Molecule_en
  
  ,a.商品名   as Product
  ,a.规格       as specifications
  ,a.给药途径   as [route]
  ,a.处方张数   as Rx
  ,a.取药数量   as num
  --,a.单价       as unit
  ,null as unit
  ,a.金额       as amount 	
-- select top 10 *			
from Tempoutput.dbo.RX_Raw_data_2016Q1 a --todo
inner join BMSChinaOtherDB.dbo.inRx_MoleculeRef b on a.code = b.药品编码


--insert into inRx
--select * from BMSChinaOtherDB.dbo.inRX_2014H1 where date in (--todo
-- '07H1'
--,'07H2'
--,'08H1'
--,'08H2'
--,'09H1'
--,'09H2'
--)








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









--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
--第二步：                   MktDefinition
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
truncate table tblMktDefRx
GO
--alter table tblMktDefRx add rat float
go
SET ansi_warnings OFF
insert into tblMktDefRx 
--select * from BMSChinaMRBI_Repository.dbo.tblMktDefHospital_201509--todos
--union 
select * from BMSChinaMRBI.dbo.tblMktDefHospital --where mkt='ccb'
GO
SET ansi_warnings On



print 'over!'