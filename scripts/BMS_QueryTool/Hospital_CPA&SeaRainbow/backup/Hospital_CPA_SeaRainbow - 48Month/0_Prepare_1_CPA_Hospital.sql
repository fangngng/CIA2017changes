
/*  
			医院数据： 每月的中旬更新一次 

前置依赖：
DB4.BMSChinaMRBI.dbo.inCPAData  --CPA数据 每月更新一次


db4.BMSChinaMRBI.dbo.tblMoleConfig  --include all Molecule CN-EN for in-line Market
db4.BMSChinaMRBI.dbo.tblProdConfig



*/
use BMSCNProc2
go


--backup
select * into BMSCNProc_bak.dbo.inCPAData_201212_all_20130329
from inCPAData
GO

--1. Hospital Inline Data Month - CPA/SeaRainbow
update tblDataPeriod set DataPeriod = '201301' where QType = 'HOSP_I'
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
select * into inCPAData
from DB4.BMSChinaMRBI.dbo.inCPAData




/*******************************************************************************************201211月数据导入临时处理：

/*第一步：导入非铂类的CPA数据*/

----CPA数据（施贵宝 --不包括铂类）  
select * into inCPAData
from DB4.BMSChinaMRBI.dbo.inCPAData
where Molecule not in (N'奈达铂',N'卡铂',N'顺铂')
go

/*第二步：导入铂类数据*/

--“130111CPA 铂类数据临时检索.xls”   --此数据给的箔类201210以前的数据  以后部分数据不会更新 
insert into inCPAData
select * from DB4.BMSChinaOtherDB.dbo.bolei
go

--CPA中：铂类201210以后的数据 
insert into inCPAData
select * from  
DB4.BMSChinaMRBI.dbo.inCPAData
where Molecule  in (N'奈达铂',N'卡铂',N'顺铂')
and ((y='2012' and m in ('11','12')) or y>'2012')
go
/*
查询产品数  11
select distinct product  from  
DB4.BMSChinaMRBI.dbo.inCPAData
where Molecule  in (N'奈达铂',N'卡铂',N'顺铂')
and ((y='2012' and m in ('11','12')) or y>'2012')   
*/


--2012年10及以前，在CPA中  而不在“130111CPA 铂类数据临时检索.xls”的铂类数据----7678
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
GO
insert into inCPAData select * from  bolei_OnlyInCPA
GO


*******************************************************************************************/



----药厂名字更新 特殊处理：
update inCPAData set Manufacture=N'江苏扬州奥赛康药业有限公司'
where [Product] =N'奥素'  and Y='2012' and m in ('8','9','10','11','12')
go
update inCPAData set Manufacture=N'江苏扬州奥赛康药业有限公司'
where [Product] =N'奥名润'  and Y='2012' 
go
update inCPAData set Manufacture=N'江苏扬州奥赛康药业有限公司'
where [Product] =N'吉西他滨'  and Y='2012' 
go
--
update inCPAData set Manufacture = N'山东威海迪沙药业有限公司'              where Molecule = N'硝苯地平' and Product=N'硝苯地平'           
update inCPAData set Manufacture = N'华北制药集团制剂有限公司'              where Molecule = N'卡托普利' and Product=N'卡托普利'
update inCPAData set Manufacture = N'上海九福药业有限公司'                  where Molecule = N'卡托普利' and Product=N'卡托普利'
update inCPAData set Manufacture = N'东北制药集团股份有限公司'              where Molecule = N'氨氯地平' and Product=N'伏络清'
update inCPAData set Manufacture = N'上海新亚药业有限公司'                  where Molecule = N'贝那普利' and Product=N'新亚利普'
update inCPAData set Manufacture = N'山东鲁南制药股份有限公司'              where Molecule = N'缬沙坦'   and Product=N'平欣'  
update inCPAData set Manufacture = N'百特集团'                              where Molecule = N'艾塞那肽' and Product=N'百泌达'
update inCPAData set Manufacture = N'华北制药集团制剂有限公司'              where Molecule = N'二甲双胍' and Product=N'二甲双胍'
update inCPAData set Manufacture = N'石家庄制药集团四药股份有限公司'        where Molecule = N'格列齐特' and Product=N'依利唐可'
update inCPAData set Manufacture = N'山东威海迪沙药业有限公司'              where Molecule = N'格列吡嗪' and Product=N'格列吡嗪'
update inCPAData set Manufacture = N'扬子江药业集团江苏制药股份有限公司'    where Molecule = N'格列吡嗪' and Product=N'秦苏'
update inCPAData set Manufacture = N'扬子江药业集团江苏制药股份有限公司'    where Molecule = N'格列美脲' and Product=N'佑苏'
update inCPAData set Manufacture = N'太极集团四川太极制药有限公司'          where Molecule = N'罗格列酮' and Product=N'太罗'
update inCPAData set Manufacture = N'北京双鹤药业股份有限公司'              where Molecule = N'吡格列酮' and Product=N'列洛'
update inCPAData set Manufacture = N'江苏南京思科药业有限公司'              where Molecule = N'紫杉醇'   and Product=N'力扑素'  
GO






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

