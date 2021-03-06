
/*  

医院数据： 每月的中旬更新一次 

前置依赖：
DB4.BMSChinaMRBI.dbo.inCPAData      --不在出版目录中的医院不会包括在“DB4.BMSChinaMRBI.dbo.inCPAData”中
DB4.BMSChinaMRBI.dbo.inSeaRainbowData

*/

use BMSCNProc2
go

--1. Hospital Inline Data Month - CPA/SeaRainbow
update tblDataPeriod set DataPeriod = '201302' where QType = 'HOSP_I'
GO

--2. refresh the month list table
if object_id(N'tblDataMonthConv',N'U') is not null
	drop table tblDataMonthConv
go
CREATE TABLE [dbo].[tblDataMonthConv](
	[Y] [nvarchar](255) NULL,
	[M] [nvarchar](255) NULL,
	[MSeq] [int] NULL,
	[Datamonth] [nvarchar](510) NULL,
	[DM] [varchar](3) NOT NULL
)
go
declare @mth varchar(10), @idx int
select @mth =DataPeriod from tblDataPeriod where QType = 'HOSP_I'
set @idx = 1
while @idx <= 48
begin
	insert into tblDataMonthConv values(
	  left(@mth,4)
	, cast(right(@mth,2) as int)
	, cast(right(@mth,2) as int)
	, @mth
	, 'M' + cast(@idx as varchar))
	set @mth = convert(varchar(6),dateadd(month,-1,convert(datetime,@mth+'01',112)),112)
	set @idx = @idx + 1
end
go
update tblDataMonthConv set DM = left(DM,1) + '0' + right(DM,1)
where len(dm) = 2
go






--3. Implementation of new row data
if object_id(N'inCPAData',N'U') is not null
	drop table inCPAData
go
select * into inCPAData
from DB4.BMSChinaMRBI.dbo.inCPAData
go

if object_id(N'inSeaRainbowData',N'U') is not null
	drop table inSeaRainbowData
go
select * into inSeaRainbowData
from DB4.BMSChinaMRBI.dbo.inSeaRainbowData
go




