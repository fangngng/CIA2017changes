
/*  
			医院数据： 每月的中旬更新一次 

前置依赖：
DB4.BMSChinaMRBI.dbo.inCPAData      --CPA数据 每月更新一次
                                    --不在出版目录中的医院不会包括在“DB4.BMSChinaMRBI.dbo.inCPAData”中


db4.BMSChinaMRBI.dbo.tblMoleConfig  --include all Molecule CN-EN for in-line Market   --记录数 123
db4.BMSChinaMRBI.dbo.tblProdConfig  --Product CN-EN for in-line Market                --记录数 609


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
3.1         CPA( by Frank)
----------------------------------------)'
-- Backup 
declare @curHOSP_I varchar(6), @lastHOSP_I varchar(6)
select @curHOSP_I= DataPeriod from tblDataPeriod where QType = 'HOSP_I'
set @lastHOSP_I = convert(varchar(6), dateadd(month, -1, cast(@curHOSP_I+'01' as datetime)), 112)
exec('
if object_id(N''BMSCNProc_bak.dbo.inCPAData_'+@lastHOSP_I+''',N''U'') is null
   select * into BMSCNProc_bak.dbo.inCPAData_'+@lastHOSP_I+'
   from inCPAData
')
GO
-- refresh row data
if object_id(N'inCPAData',N'U') is not null
	drop table inCPAData
go
select * into inCPAData
from DB4.BMSChinaMRBI.dbo.inCPAData --不在出版目录中的医院不会包括在“DB4.BMSChinaMRBI.dbo.inCPAData”中



-- 特殊处理,同一个厂商的 药厂名字更新：
update inCPAData set Manufacture=N'江苏扬州奥赛康药业有限公司' where [Product] =N'奥素'  and Y='2012' and m in ('8','9','10','11','12')
go
update inCPAData set Manufacture=N'江苏扬州奥赛康药业有限公司' where [Product] =N'奥名润'  and Y='2012' 
go
update inCPAData set Manufacture=N'江苏扬州奥赛康药业有限公司' where [Product] =N'吉西他滨'  and Y='2012' 
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
--2013/4/2 15:57:49
update inCPAData set Manufacture = N'中美上海施贵宝制药有限公司'            where Molecule = N'卡铂'   and Product=N'伯尔定'  
GO
--2013/4/21 21:43:04
update inCPAData set Manufacture=N'珠海联邦制药股份有限公司中山分公司'
where Manufacture=N'珠海联邦制药股份有限公司'
GO


PRINT '(--------------------------------
3.2         SeaRainbow(by Frank)
----------------------------------------)'
-- Backup 
declare @curHOSP_I varchar(6), @lastHOSP_I varchar(6)
select @curHOSP_I= DataPeriod from tblDataPeriod where QType = 'HOSP_I'
set @lastHOSP_I = convert(varchar(6), dateadd(month, -1, cast(@curHOSP_I+'01' as datetime)), 112)
exec('
if object_id(N''BMSCNProc_bak.dbo.inSeaRainbowData_'+@lastHOSP_I+''',N''U'') is null
   select * into BMSCNProc_bak.dbo.inSeaRainbowData_'+@lastHOSP_I+'
   from inSeaRainbowData
')
GO

--	BMS-12月检索数据.mdb
if object_id(N'inSeaRainbowData',N'U') is not null
	drop table inSeaRainbowData
go
select * 
into inSeaRainbowData
from DB4.BMSChinaMRBI.dbo.inSeaRainbowData
go


-- 不良数据处理
update inSeaRainbowData set Manufacture=N'德国勃林格殷格翰国际公司Boehringer Ingelheim Pharma GmbH & Co.KG'
where Manufacture=N'德国勃林格殷格翰国际公司Boehringer Ingelheim Pharma GmbH & Co. KG'
GO
update inSeaRainbowData set Manufacture=N'海口奇力制药有限公司'
where Manufacture=N'海口奇力制药股份有限公司'
GO
update inSeaRainbowData set Manufacture=N'上海实业联合集团长城制药有限公司'
where Manufacture=N'上海实业联合集团长城药业有限公司'
GO
update inSeaRainbowData set Manufacture=N'上海信谊医药有限公司'
where Manufacture=N'上海信谊药厂有限公司'
GO
update inSeaRainbowData set Manufacture=N'珠海润都制药有限公司'
where Manufacture=N'珠海润都制药股份有限公司'
GO
