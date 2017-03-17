


--IMS Data 每月更新一次 保存处理最近60个月，5年的数据

-- 前置依赖：
-- TempOutput.dbo.MTHCHPA_PKML
-- TempOutput.dbo.MTHCITY_PKML

-- TempOutput.dbo.MTHCHPA_CMPS
-- TempOutput.dbo.MTHCITY_CMPS

-- Db4.BMSChinaCIA_IMS.dbo.MTHCHPA_PKAU
-- Db4.BMSChinaCIA_IMS.dbo.MTHCITY_PKAU

-- Db4.BMSChinaCIA_IMS.dbo.tblMktDef_ATCDriver
-- Db4.BMSChinaCIA_IMS.dbo.tblMktDef_GlobalTA


use BMSCNProc2
go
--


update tblDataPeriod set DataPeriod = '201612' --手工更新 IMS Data Month todo
where QType = 'IMS'
GO
exec dbo.sp_Log_Event 'Prepare','QT_IMS','0_Prepare_IMS.sql','Start',null,null

--源数据里面没有Suxi的数据，但是客户要求2012年之前的Suxi的数据要体现在QueryTool上
--计算当前月到201112年之前的月份相差了几个月
--现已停止加入suxi数据 20160809 此时的MTH_1表示2016年05
--declare @currentMonth varchar(10)
--declare @missMonthNum int
--select @currentMonth=DataPeriod from tblDataPeriod where QType='IMS'
--set @missMonthNum = datediff(m,convert(datetime,'20111201'),convert(datetime,@currentMonth+'01'))

--declare @sql varchar(max)
--declare @sqlShare varchar(max)
--declare @diffNum int
--declare @i int
--set @i=60
----计算201402月份和当前月差了几个月份
--set @diffNum =datediff(m,convert(datetime,'20140201'),convert(datetime,@currentMonth+'01'))
--set @sql=' '
--set @sqlShare=' '
--while @i>=1
--begin
--	if @i<=@missMonthNum
--		begin
--			set @sql=@sql+'0,'
--			set @sqlShare=@sqlShare+'0,'
--		end
--	else if @i>@missMonthNum
--		begin
--			set @sql=@sql +'MTH_'+convert(varchar(3),@i-@diffNum)+','
--			set @sqlShare=@sqlShare+'MTH_SHR_'+convert(varchar(3),@i-@diffNum)+','
--		end	
--	set @i=@i-1
--end
--set @sql = left(@sql,len(@sql)-1)
--set @sqlShare = left(@sqlShare,len(@sqlShare)-1)
--print @sql

--if object_id(N'dbo.tblOutput_IMS_ATC_Master_Suxi',N'U') is not null
--	drop table tblOutput_IMS_ATC_Master_Suxi
--select * into tblOutput_IMS_ATC_Master_Suxi from dbo.tblOutput_IMS_ATC_Master_201402_Suxi where 1=2
--declare @sqlATCMaster varchar(max)
--set @sqlATCMaster = ' 
--insert into tblOutput_IMS_ATC_Master_Suxi (
--[DataType],[ATC1_Code],[ATC1_Des],[ATC2_Code],[ATC2_Des],[ATC3_Code],[ATC3_Des],[ATC4_Code],
--[ATC4_Des],[GEO],[Geo_Lvl],[Prod_Lvl],[Uniq_Prod],[Product_Name],[Product_Code],[CMPS_Name],
--[CMPS_Code],[Package_Name],[Package_Code],[Corp_Name],[Corp_Code],[Manuf_Name],[Manuf_Code],[MNC],[Generic_Code],
--[MTH_60],[MTH_59],[MTH_58],[MTH_57],[MTH_56],[MTH_55],[MTH_54],[MTH_53],[MTH_52],[MTH_51],[MTH_50],[MTH_49],[MTH_48],
--[MTH_47],[MTH_46],[MTH_45],[MTH_44],[MTH_43],[MTH_42],[MTH_41],[MTH_40],[MTH_39],[MTH_38],[MTH_37],[MTH_36],[MTH_35],
--[MTH_34],[MTH_33],[MTH_32],[MTH_31],[MTH_30],[MTH_29],[MTH_28],[MTH_27],[MTH_26],[MTH_25],[MTH_24],[MTH_23],[MTH_22],
--[MTH_21],[MTH_20],[MTH_19],[MTH_18],[MTH_17],[MTH_16],[MTH_15],[MTH_14],[MTH_13],[MTH_12],[MTH_11],[MTH_10],[MTH_9],
--[MTH_8],[MTH_7],[MTH_6],[MTH_5],[MTH_4],[MTH_3],[MTH_2],[MTH_1]
--)
--select [DataType],[ATC1_Code],[ATC1_Des],[ATC2_Code],[ATC2_Des],[ATC3_Code],[ATC3_Des],[ATC4_Code],
--[ATC4_Des],[GEO],[Geo_Lvl],[Prod_Lvl],[Uniq_Prod],[Product_Name],[Product_Code],[CMPS_Name],
--[CMPS_Code],[Package_Name],[Package_Code],[Corp_Name],[Corp_Code],[Manuf_Name],[Manuf_Code],[MNC],[Generic_Code],
--'+@sql+' from tblOutput_IMS_ATC_Master_201402_Suxi'
--print @sqlATCMaster
--exec (@sqlATCMaster)

--if object_id(N'dbo.tblOutput_IMS_TA_Master_Inline_Suxi',N'U') is not null
--	drop table tblOutput_IMS_TA_Master_Inline_Suxi
--select * into tblOutput_IMS_TA_Master_Inline_Suxi from dbo.tblOutput_IMS_TA_Master_Inline_201402_Suxi where 1=2
--declare @sqlTAMasterInline varchar(max)
--set @sqlTAMasterInline= '
--insert into tblOutput_IMS_TA_Master_Inline_Suxi ([DataType],[MktType],[Mkt],[Market_Name],[GEO],[Geo_Lvl],[Class],[Class_Name],[Prod_Lvl],[Uniq_Prod],[Product_Name],[Product_Code],
--[CMPS_Name],[CMPS_Code],[Package_Name],[Package_Code],[Corp_Name],[Corp_Code],[Manuf_Name],[Manuf_Code],[MNC],[Generic_Code],
--[MTH_60],[MTH_59],[MTH_58],[MTH_57],[MTH_56],[MTH_55],[MTH_54],[MTH_53],[MTH_52],[MTH_51],[MTH_50],[MTH_49],[MTH_48],[MTH_47],
--[MTH_46],[MTH_45],[MTH_44],[MTH_43],[MTH_42],[MTH_41],[MTH_40],[MTH_39],[MTH_38],[MTH_37],[MTH_36],[MTH_35],[MTH_34],[MTH_33],
--[MTH_32],[MTH_31],[MTH_30],[MTH_29],[MTH_28],[MTH_27],[MTH_26],[MTH_25],[MTH_24],[MTH_23],[MTH_22],[MTH_21],[MTH_20],[MTH_19],
--[MTH_18],[MTH_17],[MTH_16],[MTH_15],[MTH_14],[MTH_13],[MTH_12],[MTH_11],[MTH_10],[MTH_9],[MTH_8],[MTH_7],[MTH_6],[MTH_5],[MTH_4],
--[MTH_3],[MTH_2],[MTH_1],[MTH_SHR_60],[MTH_SHR_59],[MTH_SHR_58],[MTH_SHR_57],[MTH_SHR_56],[MTH_SHR_55],[MTH_SHR_54],[MTH_SHR_53],
--[MTH_SHR_52],[MTH_SHR_51],[MTH_SHR_50],[MTH_SHR_49],[MTH_SHR_48],[MTH_SHR_47],[MTH_SHR_46],[MTH_SHR_45],[MTH_SHR_44],[MTH_SHR_43],
--[MTH_SHR_42],[MTH_SHR_41],[MTH_SHR_40],[MTH_SHR_39],[MTH_SHR_38],[MTH_SHR_37],[MTH_SHR_36],[MTH_SHR_35],[MTH_SHR_34],[MTH_SHR_33],
--[MTH_SHR_32],[MTH_SHR_31],[MTH_SHR_30],[MTH_SHR_29],[MTH_SHR_28],[MTH_SHR_27],[MTH_SHR_26],[MTH_SHR_25],[MTH_SHR_24],[MTH_SHR_23],
--[MTH_SHR_22],[MTH_SHR_21],[MTH_SHR_20],[MTH_SHR_19],[MTH_SHR_18],[MTH_SHR_17],[MTH_SHR_16],[MTH_SHR_15],[MTH_SHR_14],[MTH_SHR_13],
--[MTH_SHR_12],[MTH_SHR_11],[MTH_SHR_10],[MTH_SHR_9],[MTH_SHR_8],[MTH_SHR_7],[MTH_SHR_6],[MTH_SHR_5],[MTH_SHR_4],[MTH_SHR_3],
--[MTH_SHR_2],[MTH_SHR_1])
--select [DataType],[MktType],[Mkt],[Market_Name],[GEO],[Geo_Lvl],[Class],[Class_Name],[Prod_Lvl],[Uniq_Prod],[Product_Name],[Product_Code],
--[CMPS_Name],[CMPS_Code],[Package_Name],[Package_Code],[Corp_Name],[Corp_Code],[Manuf_Name],[Manuf_Code],[MNC],[Generic_Code],'+@sql+','+@sqlShare+'
--from tblOutput_IMS_TA_Master_Inline_201402_Suxi
--'
--print @sqlTAMasterInline
--exec(@sqlTAMasterInline)

--if object_id(N'dbo.tblOutput_IMS_TA_Master_Suxi',N'U') is not null
--	drop table tblOutput_IMS_TA_Master_Suxi
--select * into tblOutput_IMS_TA_Master_Suxi from dbo.tblOutput_IMS_TA_Master_201402_Suxi where 1=2
--declare @sqlTAMaster varchar(max)
--set @sqlTAMaster ='
--insert into tblOutput_IMS_TA_Master_Suxi(
--[DataType] ,[MktType] ,[Mkt] ,[Market_Name] ,[GEO] ,[Geo_Lvl] ,[Class] ,[Class_Name] ,[Prod_Lvl] ,[Uniq_Prod] ,[Product_Name] ,
--[Product_Code] ,[CMPS_Name] ,[CMPS_Code] ,[Package_Name] ,[Package_Code] ,[Corp_Name] ,[Corp_Code] ,[Manuf_Name] ,[Manuf_Code] ,[MNC] ,
--[Generic_Code] ,[MTH_60] ,[MTH_59] ,[MTH_58] ,[MTH_57] ,[MTH_56] ,[MTH_55] ,[MTH_54] ,[MTH_53] ,[MTH_52] ,[MTH_51] ,[MTH_50] ,[MTH_49] ,
--[MTH_48] ,[MTH_47] ,[MTH_46] ,[MTH_45] ,[MTH_44] ,[MTH_43] ,[MTH_42] ,[MTH_41] ,[MTH_40] ,[MTH_39] ,[MTH_38] ,[MTH_37] ,[MTH_36] ,[MTH_35] ,
--[MTH_34] ,[MTH_33] ,[MTH_32] ,[MTH_31] ,[MTH_30] ,[MTH_29] ,[MTH_28] ,[MTH_27] ,[MTH_26] ,[MTH_25] ,[MTH_24] ,[MTH_23] ,[MTH_22] ,[MTH_21] ,
--[MTH_20] ,[MTH_19] ,[MTH_18] ,[MTH_17] ,[MTH_16] ,[MTH_15] ,[MTH_14] ,[MTH_13] ,[MTH_12] ,[MTH_11] ,[MTH_10] ,[MTH_9] ,[MTH_8] ,[MTH_7] ,
--[MTH_6] ,[MTH_5] ,[MTH_4] ,[MTH_3] ,[MTH_2] ,[MTH_1])
--select 
--[DataType] ,[MktType] ,[Mkt] ,[Market_Name] ,[GEO] ,[Geo_Lvl] ,[Class] ,[Class_Name] ,[Prod_Lvl] ,[Uniq_Prod] ,[Product_Name] ,
--[Product_Code] ,[CMPS_Name] ,[CMPS_Code] ,[Package_Name] ,[Package_Code] ,[Corp_Name] ,[Corp_Code] ,[Manuf_Name] ,[Manuf_Code] ,[MNC] ,
--[Generic_Code] ,'+@sql+'
--from tblOutput_IMS_TA_Master_201402_Suxi
--'
--print @sqlTAMaster
--exec(@sqlTAMaster)

--go






------------------------------------------------------------------------------------------------------
--   配置表 ：
------------------------------------------------------------------------------------------------------
if object_id(N'tblDataMonthConv_IMS',N'U') is not null
	drop table tblDataMonthConv_IMS
go
CREATE TABLE [dbo].[tblDataMonthConv_IMS](
	[Y] [nvarchar](255) NULL,
	[M] [nvarchar](255) NULL,
	[MSeq] [int] NULL,
	[Datamonth] [nvarchar](510) NULL,
    [DM] [varchar](3) NOT NULL,
	[DMshow] [varchar](max) NOT NULL
)
go
declare @mth varchar(10), @idx int
select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
set @idx = 1
while @idx <= 60
begin
	insert into tblDataMonthConv_IMS values(
	  left(@mth,4)
	  ,cast(right(@mth,2) as int)
      ,cast(right(@mth,2) as int)
      ,@mth
      , 'M' + cast(@idx as varchar)
      , 'isnull(MTH_' + cast(@idx as varchar)+',0)'
    )
	set @mth = convert(varchar(6),dateadd(month,-1,convert(datetime,@mth+'01',112)),112)
	set @idx = @idx + 1
end
go
update tblDataMonthConv_IMS 
set DM = left(DM,1) + '0' + right(DM,1)
where len(dm) = 2
go








------------------------------------------------------------------------------------------------------
--   Importing	IMS Row Data	 ：
------------------------------------------------------------------------------------------------------

PRINT '(--------------------------------
              (1).importing PKML
----------------------------------------)'
if object_id(N'inPKML',N'U') is not null
	drop table inPKML
go
select * into inPKML
from (
	select * from TempOutput.dbo.MTHCHPA_PKML
	union 
	select * from TempOutput.dbo.MTHCITY_PKML
) a
GO

PRINT '(--------------------------------
              (2).importing CMPS
----------------------------------------)'
if object_id(N'inCMPS',N'U') is not null
	drop table inCMPS
go
select * into inCMPS
from (
	select distinct CMPS_COD, CMPS_DES, CMPS_RES, NMOLECPS 
	from TempOutput.dbo.MTHCHPA_CMPS
	union 
	select distinct CMPS_COD, CMPS_DES, CMPS_RES, NMOLECPS 
	from TempOutput.dbo.MTHCITY_CMPS
) a
GO

-- check CMPS_COD - cmps_des relations：is one to one ?

-- select CMPS_COD, count(cmps_des) from (
-- select distinct CMPS_COD, cmps_des from inCMPS
-- ) a
-- group by CMPS_COD having count(cmps_des)>1

-- select count(distinct CMPS_COD) num , [CMPS_DES]
-- from [BMSCNProc2].[dbo].[inCMPS] 
-- group by [CMPS_DES]
-- having  count(1)>1



if object_id(N'tblCmpsPack',N'U') is not null
	drop table tblCmpsPack
go
select a.CMPS_COD, a.CMPS_DES, b.PACK_COD
into tblCmpsPack
from inCMPS a inner join inPKML b
on a.CMPS_COD = b.CMPS_COD
GO



PRINT '(--------------------------------
              (3).importing   PKAU
----------------------------------------)'

-- 查看表中重要字段关系：

-- select distinct 
-- atc4_cod,cmps_cod,pack_cod,pkau_cod
-- from MTHCHPA_PKAU
-- order by atc4_cod,cmps_cod,pack_cod,pkau_cod


if object_id(N'MTHCHPA_PKAU',N'U') is not null
	drop table MTHCHPA_PKAU
go
select * into MTHCHPA_PKAU
from Db4.BMSChinaCIA_IMS.dbo.MTHCHPA_PKAU
go
create nonclustered index idx on MTHCHPA_PKAU(Pack_cod)
go
--
if object_id(N'MTHCITY_PKAU',N'U') is not null
	drop table MTHCITY_PKAU
go

select * into MTHCITY_PKAU
from Db4.BMSChinaCIA_IMS.dbo.MTHCITY_PKAU
go
create nonclustered index idx on MTHCITY_PKAU(Pack_cod)
go

--Update city table
insert into tblCityIMS (City_ID,Audi_Cod,CIty,City_CN,Geo_Lvl)
select city_ID,city_code+'_',city_name,city_name_ch,2 from db4.bmsChinaCIA_IMS.dbo.dim_city a
where not exists(select * from tblCityIMS b where a.city_name=b.city or a.city_name_ch=b.city_cn)

------------------------------------------------------------------------------------------------------
--   更新MktDefinition, 即将新增产品添加到市场定义中去。	 ：
------------------------------------------------------------------------------------------------------

PRINT '(--------------------------------
             tblQueryToolDriverATC
----------------------------------------)'

-- Backup driver tables
declare @curIMSMth varchar(6), @lastIMSMth varchar(6)
select @curIMSMth= DataPeriod from tblDataPeriod where QType = 'IMS'
set @lastIMSMth = convert(varchar(6), dateadd(month, -1, cast(@curIMSMth+'01' as datetime)), 112)
--产品表
exec('
if object_id(N''BMSCNProc_bak.dbo.tblQueryToolDriverATC_'+@lastIMSMth+''',N''U'') is null
	select * into BMSCNProc_bak.dbo.tblQueryToolDriverATC_'+@lastIMSMth+'
	from tblQueryToolDriverATC ');
--市场定义表
exec('
if object_id(N''BMSCNProc_bak.dbo.tblQueryToolDriverIMS_'+@lastIMSMth+''',N''U'') is null
	select * into BMSCNProc_bak.dbo.tblQueryToolDriverIMS_'+@lastIMSMth+'
	from tblQueryToolDriverIMS ');
go


--3.1 refresh tblQueryToolDriverATC
truncate table tblQueryToolDriverATC
go
insert into tblQueryToolDriverATC
select distinct a.*, b.CMPS_Cod, b.CMPS_Des 
from Db4.BMSChinaCIA_IMS.dbo.tblMktDef_ATCDriver a inner join tblCmpsPack b
on a.Pack_Cod=b.Pack_Cod
go

update tblQueryToolDriverATC set atc1_des='Z: NON ANATOMICAL CLASSIFICATION',atc2_des='Z98: NON ANATOMICAL CLASSIFICATION' ,atc3_des='Z98A: NON ANATOMICAL CLASSIFICATION'
where atc1_cod='Z' 

--删除部分问题数据
delete a  from tblQueryToolDriverATC a where ATC3_des is null
go
delete a from tblQueryToolDriverATC a 
where not exists(select * from mthchpa_pkau b where a.pack_cod = b.pack_cod)
	and not exists(select * from mthcity_pkau b where a.pack_cod = b.pack_cod)
go

update tblQueryToolDriverATC set Prod_Des = Prod_Des + ' (' + Manu_Cod + ')'
go

select N'比较前后2个月的 ATC数据:'
select count(*) from tblQueryToolDriverATC
declare @curIMSMth varchar(6), @lastIMSMth varchar(6)
select @curIMSMth= DataPeriod from tblDataPeriod where QType = 'IMS'
set @lastIMSMth = convert(varchar(6), dateadd(month, -1, cast(@curIMSMth+'01' as datetime)), 112)
exec('select count(*) from BMSCNProc_bak.dbo.tblQueryToolDriverATC_'+@lastIMSMth);
go

insert into tblQueryTool_IMS_ATC_List(atc1_cod,atc1_des,atc2_cod,atc2_des,atc3_cod,atc3_des,atc4_cod,atc4_des)
SELECT distinct atc1_cod,atc1_cod+': '+atc1_des as atc1_des,
				atc2_cod,atc2_cod+': '+atc2_des as atc2_des,
				atc3_cod,atc3_cod+': '+atc3_des as atc3_des,
				atc4_cod,atc4_cod+': '+atc4_des as atc4_des
FROM dbo.tblQueryToolDriverATC a
where not exists(select 1 from tblQueryTool_IMS_ATC_List b where a.atc4_cod=b.atc4_cod)
go






--3.2 Refresh the MD for Global TA
PRINT '(--------------------------------
             tblQueryToolDriverIMS
----------------------------------------)'
truncate table tblQueryToolDriverIMS
go

alter table tblQueryToolDriverIMS drop column CMPS_Code
GO
alter table tblQueryToolDriverIMS drop column CMPS_Name
GO

declare @mth varchar(10)
select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'

insert into tblQueryToolDriverIMS
select distinct  'Global TA' MktType,
	GTA Mkt, GTAName MktName,
	A.ATC3_Cod, 'NA' Class,
	b.Mole_cod, b.Mole_des,
	a.Prod_cod,b.Prod_des,
	a.Pack_cod,b.Pack_des,
	b.corp_cod, b.corp_des,
	b.Manu_cod, b.Manu_des,
	b.MNC,'N' CLSInd,b.Gene_cod, @mth as AddMonth
from Db4.BMSChinaCIA_IMS.dbo.tblMktDef_GlobalTA a
inner join tblQueryToolDriverATC b on a.pack_cod = b.Pack_cod
GO

delete a from tblQueryToolDriverIMS a 
where not exists(select * from mthchpa_pkau b where a.pack_cod = b.pack_cod)
	and not exists(select * from mthcity_pkau b where a.pack_cod = b.pack_cod)
	and MktType = 'Global TA'
go


select N'比较前后2个月的 Global Market:'
select count(*) from tblQueryToolDriverIMS where MktType = 'Global TA'
declare @curIMSMth varchar(6), @lastIMSMth varchar(6)
select @curIMSMth= DataPeriod from tblDataPeriod where QType = 'IMS'
set @lastIMSMth = convert(varchar(6), dateadd(month, -1, cast(@curIMSMth+'01' as datetime)), 112)
exec('
select count(*) from BMSCNProc_bak.dbo.tblQueryToolDriverIMS_'+@lastIMSMth+'
where MktType = ''Global TA'' ')
go



--3.3 Refresh the MD(MarketDefinition) for Inline Market 



-- Focused Brands:

-- ARV
-- CML
-- HYPM
-- NIAD
-- ONCFCS
-- PLATINUM
-- Hypertention market  --高血压




print 'In-line Market Hypertention'
declare @mth varchar(10)
select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
insert into tblQueryToolDriverIMS
select distinct 
   'In-line Market' as MktType
   , 'HYP' as Mkt
   , 'HYPERTENSION MARKET' as MktName,
   ATC3_Cod, 'NA' as Class, Mole_Cod,Mole_Des,
   Prod_Cod,Prod_Des as Prod_Des, 
   Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
   MNC, 'N' CLSInd,Gene_Cod, @mth as AddMonth
from tblQueryToolDriverATC
where ATC2_Cod in ('C02','C03','C07','C08','C09')
GO

print 'In-line Market PLATINUM'
declare @mth varchar(10)
select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
insert into tblQueryToolDriverIMS
select distinct 
   'In-line Market' as MktType
   , 'PLATINUM' as Mkt
   , 'PLATINUM MARKET' as MktName,
   ATC3_Cod, 'NA' as Class, Mole_Cod,Mole_Des,
   Prod_Cod,Prod_Des as Prod_Des, 
   Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
   MNC, 'N' CLSInd,Gene_Cod, @mth as AddMonth
from tblQueryToolDriverATC
where Mole_cod in ('031172','501750','398650')
go

print 'In-line Market ONCFCS'
declare @mth varchar(10)
select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
insert into tblQueryToolDriverIMS
select distinct 'In-line Market' as MktType, 
	'ONCFCS' as Mkt, 'TAXOL MARKET' as MktName,
	ATC3_Cod, 'NA' as Class, Mole_Cod,Mole_Des,
	Prod_Cod,Prod_Des as Prod_Des, 
	Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
	MNC, 'N' CLSInd,Gene_Cod, @mth as AddMonth
from tblQueryToolDriverATC
where Mole_cod in ('385082','392175','395667')
go

print 'In-line Market NIAD'
declare @mth varchar(10)
select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
insert into tblQueryToolDriverIMS
select distinct 'In-line Market' as MktType,
	'NIAD' as Mkt, 'GLUCOPHAGE MARKET' as MktName,
	ATC3_Cod, Mkt as Class, Mole_Cod, Mole_Des, 
	Prod_Cod, Prod_Des + ' (' + Manu_cod + ')' as Prod_Des, 
	Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
	MNC,'Y' CLSInd, Gene_Cod, @mth as AddMonth
from Db4.BMSChinaCIA_IMS.dbo.tblMktDef_Inline
where mkt in ('AGI','BI','DPP4','GLIN','GLP1','SU','TZD')
go

print 'In-line Market HYPM'
declare @mth varchar(10)
select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
insert into tblQueryToolDriverIMS
select distinct 'In-line Market' as MktType, 
	'HYPM' as Mkt, 'MONOPRIL MARKET' as MktName,
	ATC3_Cod, 'NA' as Class, Mole_Cod,Mole_Des,
	Prod_Cod,Prod_Des as Prod_Des, 
	Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
	MNC,'N' CLSInd, Gene_Cod, @mth as AddMonth
from tblQueryToolDriverATC
where Prod_cod in ('07279','02433','02380','11350')
go


print 'In-line Market CCB'
declare @mth varchar(10)
select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
insert into tblQueryToolDriverIMS
select distinct 'In-line Market' as MktType, 
	'CCB' as Mkt, 'CONIEL MARKET' as MktName,
	ATC3_Cod, 'NA' as Class, Mole_Cod,Mole_Des,
	Prod_Cod,Prod_Des as Prod_Des, 
	Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
	MNC,'N' CLSInd, Gene_Cod, @mth as AddMonth
from tblQueryToolDriverATC
where ATC2_cod ='C08'
go

print 'In-line Market CML'
declare @mth varchar(10)
select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
insert into tblQueryToolDriverIMS
select distinct 'In-line Market' as MktType, 
	'CML' as Mkt, 'SPRYCEL MARKET' as MktName,
	ATC3_Cod, 'NA' as Class, Mole_Cod,Mole_Des,
	Prod_Cod,Prod_Des as Prod_Des, 
	Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
	MNC,'N' CLSInd, Gene_Cod, @mth as AddMonth
from tblQueryToolDriverATC
where mole_cod in ('706886','718136','716708')
go
-- Patch Sprycel Market, manuly add Product Sprycel
if not exists(select * from tblQueryToolDriverIMS where Prod_cod = '97029')
begin
	insert into tblQueryToolDriverIMS
	select 'In-line Market' MktType, 'CML' Mkt, 'SPRYCEL MARKET' MktName ,
		ATC3_Cod,'NA' Class, Mole_cod, Mole_des, Prod_cod, Prod_des + ' (' + Manu_cod + ')' as Prod_Des,
		Pack_cod, Pack_des,Corp_cod, Corp_des, Manu_cod, Manu_des,
		MNC, 'N' CLSInd, Gene_cod, '201206'
	from Db4.BMSChinaCIA_IMS.dbo.tblMktDef_ATCDriver 
	where prod_cod = '97029'
end
go

print 'In-line Market ARV'
declare @mth varchar(10)
select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
insert into tblQueryToolDriverIMS
select distinct 'In-line Market' as MktType,
	'ARV' as Mkt, 'BARACLUDE MARKET' as MktName,
	ATC3_Cod, 'NA' as Class, Mole_Cod, Mole_Des, 
	Prod_Cod, Prod_Des + ' (' + Manu_cod + ')' as Prod_Des, 
	Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
	MNC,'N' CLSInd, Gene_Cod, @mth as AddMonth
from Db4.BMSChinaCIA_IMS.dbo.tblMktDef_Inline
where mkt = 'arv'
go
delete a from tblQueryToolDriverIMS a 
where not exists(select * from mthchpa_pkau b where a.pack_cod = b.pack_cod)
	and not exists(select * from mthcity_pkau b where a.pack_cod = b.pack_cod)
	and a.MktType = ('In-line Market')
go

SET ansi_warnings OFF

print 'In-line Market Eliquis(VTEp)'
declare @mth varchar(10)
select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
insert into tblQueryToolDriverIMS
select distinct 'In-line Market' as MktType, 
	'Eliquis(VTEp)' as Mkt, 'Eliquis(VTEp) MARKET' as MktName,
	ATC3_Cod, 'NA' as Class, Mole_Cod,Mole_Des,
	Prod_Cod,Prod_Des as Prod_Des, 
	Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
	MNC,'N' CLSInd, Gene_Cod, @mth as AddMonth
from tblQueryToolDriverATC
where Mole_cod in ('406260','408800','408827','413885','703259','704307','710047','711981','719372', '904100') 
	and Prod_cod <> '14146' -- 去掉复方

-- 20161102 modify VTEp market to APIXABAN,RIVAROXABAN,DABIGATRAN ETEXILATE,ENOXAPARIN SODIUM,DALTEPARIN SODIUM,
--	LOW MOLECULAR WEIGHT HEPARIN,HEPARIN,FONDAPARINUX SODIUM,NADROPARIN CALCIUM molecule
-- where Prod_cod in ('06253','08621','40785','53099','37977')
--FRAXIPARINE+CLEXANE+XARELTO+ELIQUIS+ARIXTRA（安卓）
go

-- print 'In-line Market Eliquis(NOAC)'
-- declare @mth varchar(10)
-- select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
-- insert into tblQueryToolDriverIMS
-- select distinct 'In-line Market' as MktType, 
-- 	'Eliquis(NOAC)' as Mkt, 'Eliquis(NOAC) MARKET' as MktName,
-- 	ATC3_Cod, 'NA' as Class, Mole_Cod,Mole_Des,
-- 	Prod_Cod,Prod_Des as Prod_Des, 
-- 	Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
-- 	MNC,'N' CLSInd, Gene_Cod, @mth as AddMonth
-- from tblQueryToolDriverATC
-- where Prod_cod in ('53099','40785','52911')
-- --Eliquis+XARELTO+PRADAXA（泰毕全）

-- 20161102 change NOAC to VTEt
print 'In-line Market Eliquis(VTEt)'
declare @mth varchar(10)
select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
insert into tblQueryToolDriverIMS
select distinct 'In-line Market' as MktType, 
	'Eliquis(VTEt)' as Mkt, 'Eliquis(VTEt) MARKET' as MktName,
	ATC3_Cod, 'NA' as Class, Mole_Cod,Mole_Des,
	Prod_Cod,Prod_Des as Prod_Des, 
	Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
	MNC,'N' CLSInd, Gene_Cod, @mth as AddMonth
from tblQueryToolDriverATC
where Mole_cod in ('406260','408800','408827','413885','703259','710047','704307','711981','719372','239900', '904100')
	and Prod_cod <> '14146' -- 去掉复方
go

SET ansi_warnings on

select N'比较前后2个月的 In-line  Market:' 
select count(*) from tblQueryToolDriverIMS where MktType = 'In-line Market'
declare @curIMSMth varchar(6), @lastIMSMth varchar(6)
select @curIMSMth= DataPeriod from tblDataPeriod where QType = 'IMS'
set @lastIMSMth = convert(varchar(6), dateadd(month, -1, cast(@curIMSMth+'01' as datetime)), 112)
exec('
select count(*) from BMSCNProc_bak.dbo.tblQueryToolDriverIMS_'+@lastIMSMth+' 
where MktType = ''In-line Market''' ) 
go




--3.4 Pipeline market is based on molecule

--Add by Xiaoyu.Chen on 20130911 to add APIXABAN to AF&VET/P Market(Pipeline market)
--insert into inPipelineMarketDefinition (Mktname,Molecule_EN)
--values('AF&VTE/P ','APIXABAN') 


print 'Refresh the MD for Pipeine Market'
go
declare @curIMSMth varchar(6), @lastIMSMth varchar(6)
select @curIMSMth= DataPeriod from tblDataPeriod where QType = 'IMS'
set @lastIMSMth = convert(varchar(6), dateadd(month, -1, cast(@curIMSMth+'01' as datetime)), 112)
exec('
insert into tblQueryToolDriverIMS
select distinct 
  ''Pipeline Market'' as MktType, 
  b.MktName as Mkt, b.MktName,
  ATC3_Cod, ''NA'' as Class, a.Mole_Cod,a.Mole_Des,
  a.Prod_Cod,a.Prod_Des, 
  a.Pack_Cod, a.Pack_Des,a.Corp_Cod, a.Corp_Des,a.Manu_Cod, a.Manu_Des,
  a.MNC, ''N'' as CLSInd,a.Gene_Cod, '+@curIMSMth+' as AddMonth
from tblQueryToolDriverATC a
right join inPipelineMarketDefinition b
on a.Mole_Des = b.Molecule_EN
where a.Mole_Des is not null
')
go

delete a from tblQueryToolDriverIMS a 
where not exists(select * from mthchpa_pkau b where a.pack_cod = b.pack_cod)
	and not exists(select * from mthcity_pkau b where a.pack_cod = b.pack_cod)
	and a.MktType = ('Pipeline Market')
go

select N'比较前后2个月的 Pipeine Market:' 
select count(*) from tblQueryToolDriverIMS where MktType = 'Pipeline Market'
declare @curIMSMth varchar(6), @lastIMSMth varchar(6)
select @curIMSMth= DataPeriod from tblDataPeriod where QType = 'IMS'
set @lastIMSMth = convert(varchar(6), dateadd(month, -1, cast(@curIMSMth+'01' as datetime)), 112)
exec('
select count(*) from BMSCNProc_bak.dbo.tblQueryToolDriverIMS_'+@lastIMSMth+' 
where MktType = ''Pipeline Market''')
go




-- Append CMPS info
alter table tblQueryToolDriverIMS add CMPS_Code varchar(10) null
go
alter table tblQueryToolDriverIMS add CMPS_Name varchar(255) null
GO
update tblQueryToolDriverIMS set Cmps_Code=b.CMPS_Cod, CMPS_Name=b.CMPS_DES
from tblQueryToolDriverIMS a inner join tblCmpsPack b
on a.Pack_Cod=b.Pack_Cod
GO
--Remove package which have no Comps code
delete from tblQueryToolDriverIMS where cmps_code is null
GO






--Special deal

-- select * from tblCmpsPack where  PACK_COD in ('9702902','9702904','9702906')
insert into tblQueryToolDriverIMS
select 'In-line Market' MktType, 'CML' Mkt, 'SPRYCEL MARKET' MktName ,
	ATC3_Cod,'NA' Class, Mole_cod, Mole_des, Prod_cod, Prod_des + ' (' + Manu_cod + ')' as Prod_Des,
	Pack_cod, Pack_des,Corp_cod, Corp_des, Manu_cod, Manu_des,
	MNC, 'N' CLSInd, Gene_cod, '201206', '004157', 'DASATINIB'
from Db4.BMSChinaCIA_IMS.dbo.tblMktDef_ATCDriver 
where prod_cod = '97029'
GO
--删除 箔类Mkt中Molecule Compsion 带“+”的
delete --select *
from tblQueryToolDriverIMS
where MktType='In-line Market' and Mkt='PLATINUM' and MktName='PLATINUM MARKET'
and Mole_cod in ('031172','501750','398650')
and PACK_COD='1512702'
GO
--删除 pipeline market 的 带“+”的
delete -- select *
from tblQueryToolDriverIMS
where MktType='Pipeline Market'
and CMPS_Name like '%+%'
GO


exec dbo.sp_Log_Event 'Prepare','QT_IMS','0_Prepare_IMS.sql','End',null,null
