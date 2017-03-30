use BMSCNProc2
go
--time:42min

exec dbo.sp_Log_Event 'Process','QT_Rx','Step_1_Create_tblRxProcessRaw.sql','Start',null,null
go
select distinct city,city_EN into tblCityRx1 from tblCityRx
drop table tblCityRx
EXEC sp_rename 'tblCityRx1', 'tblCityRx'

select distinct * into tblProductList_Rx1 from tblProductList_Rx 
drop table tblProductList_Rx
EXEC sp_rename 'tblProductList_Rx1', 'tblProductList_Rx'





if object_id(N'tblRxProcessedRaw',N'U') is not null
	drop table tblRxProcessedRaw
go
select 
  City_EN         as Geo
  , [DATE]        as DQ
  , Department_EN as Dept
  , Pack_Cod      as Pack_Cod
  , SUM(Rx)       as Rx
  , SUM(Sales)    as Sales
  , SUM([ȡҩ����]) as Volume
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



if object_id(N'tblRxProcessedRawCT',N'U') is not null
	drop table tblRxProcessedRawCT
go

CREATE TABLE [dbo].[tblRxProcessedRawCT](
	[DataType] [nvarchar](255) NULL,
	[Geo] [nvarchar](50) NULL,
	[Dept] [nvarchar](255) NULL,
	[Pack_Cod] [nvarchar](255) NULL,
	[Mth_20] [float] null,
	[MTH_19] [float] NULL,
	[MTH_18] [float] NULL,
	[MTH_17] [float] NULL,
	[MTH_16] [float] NULL,
	[MTH_15] [float] NULL,
	[MTH_14] [float] NULL,
	[MTH_13] [float] NULL,
	[MTH_12] [float] NULL,
	[MTH_11] [float] NULL,
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



--> select distinct DQ from tblRxProcessedRaw :
insert into tblRxProcessedRawCT (DataType,Geo,Dept,Pack_Cod,[Mth_20],
[Mth_19],[Mth_18],[Mth_17],[Mth_16],[Mth_15],[Mth_14],[Mth_13],[Mth_12],[Mth_11],
[Mth_10],[Mth_9],[Mth_8],[Mth_7],[Mth_6],[Mth_5],[Mth_4],[Mth_3],[Mth_2],[Mth_1])
select '3MRMB' as DataType, Geo,Dept,Pack_cod,
[11Q2],[11Q3],[11Q4],[12Q1],[12Q2],[12Q3],[12Q4],[13Q1],[13Q2],[13Q3],[13Q4],[14Q1],[14Q2],[14Q3],[14Q4],[15Q1],[15Q2],[15Q3],[15Q4],[16Q1]
from (
	select Geo,DQ,Dept,Pack_cod, Sales from tblRxProcessedRaw 
) a pivot(
	sum(Sales) for DQ in (
	[11Q2],[11Q3],[11Q4],[12Q1],[12Q2],[12Q3],[12Q4],[13Q1],[13Q2],[13Q3],[13Q4],[14Q1],[14Q2],[14Q3],[14Q4],[15Q1],[15Q2],[15Q3],[15Q4],[16Q1])  --todo :ֻҪ5������
) PVT
go
insert into tblRxProcessedRawCT (DataType,Geo,Dept,Pack_Cod,[Mth_20],
[Mth_19],[Mth_18],[Mth_17],[Mth_16],[Mth_15],[Mth_14],[Mth_13],[Mth_12],[Mth_11],
[Mth_10],[Mth_9],[Mth_8],[Mth_7],[Mth_6],[Mth_5],[Mth_4],[Mth_3],[Mth_2],[Mth_1])
select '3MUSD' as DataType, Geo,Dept,Pack_cod,
[11Q2],[11Q3],[11Q4],[12Q1],[12Q2],[12Q3],[12Q4],[13Q1],[13Q2],[13Q3],[13Q4],[14Q1],[14Q2],[14Q3],[14Q4],[15Q1],[15Q2],[15Q3],[15Q4],[16Q1]
from (
	select Geo,DQ,Dept,Pack_cod, Sales/(select rate from db4.bmschinacia_ims.dbo.tblrate) as Sales from tblRxProcessedRaw 
) a pivot(
	sum(Sales) for DQ in ([11Q2],[11Q3],[11Q4],[12Q1],[12Q2],[12Q3],[12Q4],[13Q1],[13Q2],[13Q3],[13Q4],[14Q1],[14Q2],[14Q3],[14Q4],[15Q1],[15Q2],[15Q3],[15Q4],[16Q1])  --todo :ֻҪ5������
) PVT
go

insert into tblRxProcessedRawCT  (DataType,Geo,Dept,Pack_Cod,[Mth_20],
[Mth_19],[Mth_18],[Mth_17],[Mth_16],[Mth_15],[Mth_14],[Mth_13],[Mth_12],[Mth_11],
[Mth_10],[Mth_9],[Mth_8],[Mth_7],[Mth_6],[Mth_5],[Mth_4],[Mth_3],[Mth_2],[Mth_1])
select '3MRx' as DataType,  Geo,Dept,Pack_cod,
[11Q2],[11Q3],[11Q4],[12Q1],[12Q2],[12Q3],[12Q4],[13Q1],[13Q2],[13Q3],[13Q4],[14Q1],[14Q2],[14Q3],[14Q4],[15Q1],[15Q2],[15Q3],[15Q4],[16Q1]
from (
	select Geo,DQ,Dept,Pack_cod, RX  from tblRxProcessedRaw 
) a pivot(
	sum(RX) for DQ in ([11Q2],[11Q3],[11Q4],[12Q1],[12Q2],[12Q3],[12Q4],[13Q1],[13Q2],[13Q3],[13Q4],[14Q1],[14Q2],[14Q3],[14Q4],[15Q1],[15Q2],[15Q3],[15Q4],[16Q1])  --todo :ֻҪ5������
) PVT
go

insert into tblRxProcessedRawCT  (DataType,Geo,Dept,Pack_Cod,[Mth_20],
[Mth_19],[Mth_18],[Mth_17],[Mth_16],[Mth_15],[Mth_14],[Mth_13],[Mth_12],[Mth_11],
[Mth_10],[Mth_9],[Mth_8],[Mth_7],[Mth_6],[Mth_5],[Mth_4],[Mth_3],[Mth_2],[Mth_1])
select '3MVol' as DataType,  Geo,Dept,Pack_cod,
[11Q2],[11Q3],[11Q4],[12Q1],[12Q2],[12Q3],[12Q4],[13Q1],[13Q2],[13Q3],[13Q4],[14Q1],[14Q2],[14Q3],[14Q4],[15Q1],[15Q2],[15Q3],[15Q4],[16Q1]
from (
	select Geo,DQ,Dept,Pack_cod, Volume  from tblRxProcessedRaw 
) a pivot(
	sum(Volume) for DQ in ([11Q2],[11Q3],[11Q4],[12Q1],[12Q2],[12Q3],[12Q4],[13Q1],[13Q2],[13Q3],[13Q4],[14Q1],[14Q2],[14Q3],[14Q4],[15Q1],[15Q2],[15Q3],[15Q4],[16Q1])  --todo :ֻҪ5������
) PVT
go



update tblRxProcessedRawCT set Mth_20 = 0 where Mth_20 is null
go
update tblRxProcessedRawCT set Mth_19 = 0 where Mth_19 is null
go
update tblRxProcessedRawCT set Mth_18 = 0 where Mth_18 is null
go
update tblRxProcessedRawCT set Mth_17 = 0 where Mth_17 is null
go
update tblRxProcessedRawCT set Mth_16 = 0 where Mth_16 is null
go
update tblRxProcessedRawCT set Mth_15 = 0 where Mth_15 is null
go
update tblRxProcessedRawCT set Mth_14 = 0 where Mth_14 is null
go
update tblRxProcessedRawCT set Mth_13 = 0 where Mth_13 is null
go
update tblRxProcessedRawCT set Mth_12 = 0 where Mth_12 is null
go
update tblRxProcessedRawCT set Mth_11 = 0 where Mth_11 is null
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
exec dbo.sp_Log_Event 'Process','QT_Rx','Step_1_Create_tblRxProcessRaw.sql','End',null,null
