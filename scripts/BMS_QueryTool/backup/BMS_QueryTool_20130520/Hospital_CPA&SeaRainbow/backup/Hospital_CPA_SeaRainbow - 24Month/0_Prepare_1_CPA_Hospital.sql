
/*  医院数据： 每月的中旬更新一次 */
use BMSCNProc2
go







--1. Hospital Inline Data Month - CPA/SeaRainbow
update tblDataPeriod set DataPeriod = '201212' where QType = 'HOSP_I'
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
while @idx <= 24
begin
	insert into tblDataMonthConv 
	values(left(@mth,4),cast(right(@mth,2) as int),cast(right(@mth,2) as int),@mth, 'M' + cast(@idx as varchar))
	set @mth = convert(varchar(6),dateadd(month,-1,convert(datetime,@mth+'01',112)),112)
	set @idx = @idx + 1
end
go

update tblDataMonthConv set DM = left(DM,1) + '0' + right(DM,1)
where len(dm) = 2
go






--3. Implementation of new row data

PRINT '(--------------------------------
  CPA(It is responsible for processing by Frank)
----------------------------------------)'
if object_id(N'inCPAData',N'U') is not null
	drop table inCPAData
go

/*第一步：导入非铂类数据*/

--130220施贵宝12月底层检索   --不包括铂类
select * into inCPAData
from DB4.BMSChinaMRBI.dbo.inCPAData
where Molecule not in (N'奈达铂',N'卡铂',N'顺铂')
go


/*第二步：导入铂类数据*/

--“130111CPA 铂类数据临时检索.xls”
insert into inCPAData
select * from DB4.BMSChinaOtherDB.dbo.bolei
go

--CPA中：铂类2012年11，12月的数据 
insert into inCPAData
select * from  
DB4.BMSChinaMRBI.dbo.inCPAData
where Molecule  in (N'奈达铂',N'卡铂',N'顺铂')
and y='2012' and m in ('11','12')

/*查询产品数
select distinct product  from  
DB4.BMSChinaMRBI.dbo.inCPAData
where Molecule  in (N'奈达铂',N'卡铂',N'顺铂')
and y='2012' and m in ('11','12')
*/


--2012年10及以前，在CPA中  而不在“130111CPA 铂类数据临时检索.xls”的铂类数据
if object_id(N'bolei_OnlyInCPA',N'U') is not null
	drop table bolei_OnlyInCPA
go
select * 
into bolei_OnlyInCPA 
from 
(
select * from DB4.BMSChinaMRBI.dbo.inCPAData t1
where not exists  ( 
select * from  DB4.BMSChinaOtherDB.dbo.bolei t2
where  
	t1.[Area]         =t2.[地区]         
and t1.[Y]            =t2.[年]           
and t1.[Q]            =t2.[季_度]        
and t1.[M]            =t2.[月]           
and t1.[CPA_Code]     =t2.[医院_编码]    
and t1.[ATC_Code]     =t2.[ATC编码]      
and t1.[Molecule]     =t2.[药品名称]     
and t1.[Product]      =t2.[商品名]       
and t1.[Package]      =t2.[包_装]        
and t1.[Specification]=t2.[规格]         
and t1.[Package_Num]  =t2.[包装_数量]    
and t1.[Form]         =t2.[剂型]         
and t1.[Way]          =t2.[途径]         
and t1.[Manufacture]  =t2.[企业名称]     
and t1.[cpa_id]       =t2.[cpa_id]       
and t1.[tier]         =t2.[tier]         
)
) b
where ((Y='2012' and convert(int, M)<11) or convert(int, Y)<2012 )
and Molecule  in (N'奈达铂',N'卡铂',N'顺铂')

insert into inCPAData select * from  bolei_OnlyInCPA


--特殊处理：
update inCPAData set Manufacture=N'江苏扬州奥赛康药业有限公司'
where [Product] =N'奥素'  and Y='2012' and m in ('8','9','10','11','12')
go
update inCPAData set Manufacture=N'江苏扬州奥赛康药业有限公司'
where [Product] =N'奥名润'  and Y='2012' 
go
update inCPAData set Manufacture=N'江苏扬州奥赛康药业有限公司'
where [Product] =N'吉西他滨'  and Y='2012' 
go



PRINT '(--------------------------------
     SeaRainbow(It is responsible for processing by Conan)
----------------------------------------)'
--	BMS-12月检索数据.mdb
if object_id(N'inSeaRainbowData',N'U') is not null
	drop table inSeaRainbowData
go
select * 
into inSeaRainbowData
from DB4.BMSChinaMRBI.dbo.inSeaRainbowData
go

--检查SeaRain数据中有没有铂类数据(结果：没有这样的数据)
select * 
from DB4.BMSChinaMRBI.dbo.inSeaRainbowData
where Molecule  in (N'奈达铂',N'卡铂',N'顺铂')

