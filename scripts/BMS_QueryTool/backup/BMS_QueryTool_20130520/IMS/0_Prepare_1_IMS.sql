use BMSCNProc2
go

/*

1. IMS Data 每月更新一次	

保存处理最近60个月，5年的数据

*/
update tblDataPeriod set DataPeriod = '201302' --手工更新 IMS Data Month
where QType = 'IMS'
GO

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
update tblDataMonthConv_IMS set DM = left(DM,1) + '0' + right(DM,1)
where len(dm) = 2
go


/*

2.  Importing	IMS Row Data	


以下4个的源数据需要从Conan用.dbf格式的数据文件导的：
DB33.TempOutput.dbo.MTHCHPA_PKML
DB33.TempOutput.dbo.MTHCITY_PKML

DB33.TempOutput.dbo.MTHCHPA_CMPS
DB33.TempOutput.dbo.MTHCITY_CMPS


PKAU的数据不能用.dbf格式的数据，要用connan那边用.txt文件入库然后处理过的IMS数据：
DB4.IMSDBPlus.dbo.MTHCHPA_PKAU
DB4.IMSDBPlus.dbo.MTHCITY_PKAU


其它前置依赖外来表：
db4.IMSDBPlus.dbo.tblMktDef_ATCDriver
db4.IMSDBPlus.dbo.tblMktDef_GlobalTA
*/

PRINT '(--------------------------------
              (1).importing PKML
----------------------------------------)'
if object_id(N'inPKML',N'U') is not null
	drop table inPKML
go
select * into inPKML
from (
select * from DB33.TempOutput.dbo.MTHCHPA_PKML
union 
select * from DB33.TempOutput.dbo.MTHCITY_PKML
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
from DB33.TempOutput.dbo.MTHCHPA_CMPS
union 
select distinct CMPS_COD, CMPS_DES, CMPS_RES, NMOLECPS 
from DB33.TempOutput.dbo.MTHCITY_CMPS
) a
GO
/*
check CMPS_COD - cmps_des relations：is one to one ?

select CMPS_COD, count(cmps_des) from (
select distinct CMPS_COD, cmps_des from inCMPS
) a
group by CMPS_COD having count(cmps_des)>1

select count(distinct CMPS_COD) num , [CMPS_DES]
from [BMSCNProc2].[dbo].[inCMPS] 
group by [CMPS_DES]
having  count(1)>1

*/

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
/*
查看表中重要字段关系：

select distinct 
atc4_cod,cmps_cod,pack_cod,pkau_cod
from MTHCHPA_PKAU
order by atc4_cod,cmps_cod,pack_cod,pkau_cod

*/
if object_id(N'MTHCHPA_PKAU',N'U') is not null
	drop table MTHCHPA_PKAU
go
select * into MTHCHPA_PKAU
from DB4.IMSDBPlus.dbo.MTHCHPA_PKAU
go
create nonclustered index idx on MTHCHPA_PKAU(Pack_cod)
go
--
if object_id(N'MTHCITY_PKAU',N'U') is not null
	drop table MTHCITY_PKAU
go

select * into MTHCITY_PKAU
from DB4.IMSDBPlus.dbo.MTHCITY_PKAU
go
create nonclustered index idx on MTHCITY_PKAU(Pack_cod)
go
-------------------------------------------------------------------------------------------------------------











/*

3.  更新MktDefinition, 即将新增产品添加到市场定义中去。

*/

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
	from tblQueryToolDriverATC
	');
--市场定义表
exec('
if object_id(N''BMSCNProc_bak.dbo.tblQueryToolDriverIMS_'+@lastIMSMth+''',N''U'') is null
	select * into BMSCNProc_bak.dbo.tblQueryToolDriverIMS_'+@lastIMSMth+'
	from tblQueryToolDriverIMS
')
go


--3.1 refresh tblQueryToolDriverATC
truncate table tblQueryToolDriverATC
go
insert into tblQueryToolDriverATC
select distinct a.*, b.CMPS_Cod, b.CMPS_Des 
from db4.IMSDBPlus.dbo.tblMktDef_ATCDriver a inner join tblCmpsPack b
on a.Pack_Cod=b.Pack_Cod
go
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
from db4.IMSDBPlus.dbo.tblMktDef_GlobalTA a
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
where MktType = ''Global TA''
')
go



--3.3 Refresh the MD(MarketDefinition) for Inline Market 

/*

Focused Brands:

ARV
CML
HYPM
NIAD
ONCFCS
PLATINUM
hypertention market  --高血压

*/


print 'In-line Market PLATINUM'
declare @mth varchar(10)
select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
insert into tblQueryToolDriverIMS
select distinct 
   'In-line Market' as MktType
   , 'HYP' as Mkt
   , 'HYPERTENTION MARKET' as MktName,
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
from db4.imsdbplus.dbo.tblMktDef_Inline
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
	from db4.IMSDBPlus.dbo.tblMktDef_ATCDriver 
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
from db4.imsdbplus.dbo.tblMktDef_Inline
where mkt = 'arv'
go
delete a from tblQueryToolDriverIMS a 
where not exists(select * from mthchpa_pkau b where a.pack_cod = b.pack_cod)
	and not exists(select * from mthcity_pkau b where a.pack_cod = b.pack_cod)
	and a.MktType = ('In-line Market')
go


select N'比较前后2个月的 In-line  Market:' 
select count(*) from tblQueryToolDriverIMS where MktType = 'In-line Market'
declare @curIMSMth varchar(6), @lastIMSMth varchar(6)
select @curIMSMth= DataPeriod from tblDataPeriod where QType = 'IMS'
set @lastIMSMth = convert(varchar(6), dateadd(month, -1, cast(@curIMSMth+'01' as datetime)), 112)
exec('
select count(*) from BMSCNProc_bak.dbo.tblQueryToolDriverIMS_'+@lastIMSMth+'
where MktType = ''In-line Market''') 
go




--3.4 Pipeline market is based on molecule
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
where MktType = ''Pipeline Market''
')
go




/*Append CMPS info*/
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












/*Special deal*/
select * from tblCmpsPack where  PACK_COD in ('9702902','9702904','9702906')

insert into tblQueryToolDriverIMS
select 'In-line Market' MktType, 'CML' Mkt, 'SPRYCEL MARKET' MktName ,
	ATC3_Cod,'NA' Class, Mole_cod, Mole_des, Prod_cod, Prod_des + ' (' + Manu_cod + ')' as Prod_Des,
	Pack_cod, Pack_des,Corp_cod, Corp_des, Manu_cod, Manu_des,
	MNC, 'N' CLSInd, Gene_cod, '201206', '004157', 'DASATINIB'
from db4.IMSDBPlus.dbo.tblMktDef_ATCDriver 
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
