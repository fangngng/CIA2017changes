use BMSCNProc2
go



--ȥ��
select distinct city,city_EN into tblCityRx1 from tblCityRx
drop table tblCityRx
EXEC sp_rename 'tblCityRx1', 'tblCityRx'

select distinct * into tblProductList_Rx1 from tblProductList_Rx 
drop table tblProductList_Rx
EXEC sp_rename 'tblProductList_Rx1', 'tblProductList_Rx'









--����
if object_id(N'tblRxProcessedRaw_bak',N'U') is not null
	drop table tblRxProcessedRaw_bak
go
select * into tblRxProcessedRaw_bak from tblRxProcessedRaw
go


if object_id(N'tblRxProcessedRaw',N'U') is not null
	drop table tblRxProcessedRaw
go
select City_EN as Geo, [DATE] as DQ, Department_EN as Dept, Pack_Cod, SUM(Rx) as Rx, SUM(Sales) Sales
into tblRxProcessedRaw

from inRx t1
inner join tblProductList_Rx t2 
on     t1.RxProd_Cod=t2.RxProd_Cod 
	 and t1.Product_CN=t2.Product_CN 
	 and t1.Strength=t2.Strength
	 and t1.Form=t2.Form 
	 
inner join tblCityRx t3 on t1.Area=t3.City 
inner join tblRxDepartment t4 on t1.Dpt=t4.Department
group by City_EN, [Date], Department_EN, Pack_Cod
go

select distinct DQ from tblRxProcessedRaw

if object_id(N'tblRxProcessedRawCT',N'U') is not null
	drop table tblRxProcessedRawCT
go

CREATE TABLE [dbo].[tblRxProcessedRawCT](
	[DataType] [nvarchar](255) NULL,
	[Geo] [nvarchar](50) NULL,
	[Dept] [nvarchar](255) NULL,
	[Pack_Cod] [nvarchar](255) NULL,
	[Mth_10] [float] null,
	[MTH_9] [float] NULL,
	[MTH_8] [float] NULL,
	[MTH_7] [float] NULL,
	[MTH_6] [float] NULL,
	[MTH_5] [float] NULL,
	[MTH_4] [float] NULL,
	[MTH_3] [float] NULL,
	[MTH_2] [float] NULL,
	[MTH_1] [float] NULL
) ON [PRIMARY]
go

insert into tblRxProcessedRawCT
select '6MRMB' as DataType, *
from (
	select Geo,DQ,Dept,Pack_cod, Sales from tblRxProcessedRaw 
) a pivot(
	sum(Sales) for DQ in ([07H2],[08H1],[08H2],[09H1],[09H2],[10H1],[10H2],[11H1],[11H2],[12H1])
) PVT
go
insert into tblRxProcessedRawCT
select '6MUSD' as DataType, *
from (
	select Geo,DQ,Dept,Pack_cod, Sales/6.34888 as Sales from tblRxProcessedRaw 
) a pivot(
	sum(Sales) for DQ in ([07H2],[08H1],[08H2],[09H1],[09H2],[10H1],[10H2],[11H1],[11H2],[12H1])
) PVT
go

insert into tblRxProcessedRawCT
select '6MRx' as DataType, *
from (
	select Geo,DQ,Dept,Pack_cod, RX  from tblRxProcessedRaw 
) a pivot(
	sum(RX) for DQ in ([07H2],[08H1],[08H2],[09H1],[09H2],[10H1],[10H2],[11H1],[11H2],[12H1])
) PVT
go

update tblRxProcessedRawCT set Mth_10 = 0 where Mth_10 is null
go
update tblRxProcessedRawCT set Mth_9 = 0 where Mth_9 is null
go
update tblRxProcessedRawCT set Mth_8 = 0 where Mth_8 is null
go
update tblRxProcessedRawCT set Mth_7 = 0 where Mth_7 is null
go
update tblRxProcessedRawCT set Mth_6 = 0 where Mth_6 is null
go
update tblRxProcessedRawCT set Mth_5 = 0 where Mth_5 is null
go
update tblRxProcessedRawCT set Mth_4 = 0 where Mth_4 is null
go
update tblRxProcessedRawCT set Mth_3 = 0 where Mth_3 is null
go
update tblRxProcessedRawCT set Mth_2 = 0 where Mth_2 is null
go
update tblRxProcessedRawCT set Mth_1 = 0 where Mth_1 is null
go

