


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

update tblDataPeriod set DataPeriod = '201701' --手工更新 MAX Data Month todo
where QType = 'MAX'
go 

PRINT '(--------------------------------
              (4).importing   MAX
----------------------------------------)'

if object_id(N'MTHCITY_MAX',N'U') is not null
	drop table MTHCITY_MAX
go

select * into MTHCITY_MAX
from Db4.BMSChinaCIA_IMS.dbo.inMAXData
go
alter table MTHCITY_MAX 
add Audi_Cod varchar(20) 
go
update MTHCITY_MAX
set Audi_Cod = b.City
from MTHCITY_MAX as a 
inner join tblcitymax as b on replace(a.city, N'市', '') = b.city_CN
go
create nonclustered index idx on MTHCITY_MAX(Pack_cod)
go

--Update city table
insert into tblcitymax (City_ID,Audi_Cod,CIty,City_CN,Geo_Lvl)
select city_ID,city_code+'_',city_name,city_name_ch,2 
from db4.BMSChinaCIA_IMS.dbo.dim_city a
where not exists(select * from tblcitymax b where a.city_name=b.city or a.city_name_ch=b.city_cn)


------------------------------------------------------------------------------------------------------
--   更新MktDefinition, 即将新增产品添加到市场定义中去。	 ：
------------------------------------------------------------------------------------------------------

PRINT '(--------------------------------
             tblQueryToolDriverATC
----------------------------------------)'

-- Backup driver tables
declare @curIMSMth varchar(6), @lastIMSMth varchar(6)
select @curIMSMth= DataPeriod from tblDataPeriod where QType = 'MAX'
set @lastIMSMth = convert(varchar(6), dateadd(month, -1, cast(@curIMSMth+'01' as datetime)), 112)
--市场定义表
exec('
if object_id(N''BMSCNProc_bak.dbo.tblQueryToolDriverIMS_'+@lastIMSMth+''',N''U'') is null
	select * into BMSCNProc_bak.dbo.tblQueryToolDriverIMS_'+@lastIMSMth+'
	from tblQueryToolDriverMAX ');
go




--3.2 Refresh the MD for Global TA
PRINT '(--------------------------------
             tblQueryToolDriverMAX
----------------------------------------)'
truncate table tblQueryToolDriverMAX
go

alter table tblQueryToolDriverMAX drop column CMPS_Code
GO
alter table tblQueryToolDriverMAX drop column CMPS_Name
GO

declare @mth varchar(10)
select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'

insert into tblQueryToolDriverMAX
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

delete a from tblQueryToolDriverMAX a 
where not exists(select * from mthchpa_pkau b where a.pack_cod = b.pack_cod)
	-- and not exists(select * from mthcity_pkau b where a.pack_cod = b.pack_cod)
	and not exists(select * from MTHCITY_MAX b where a.pack_cod = b.pack_cod)
	and MktType = 'Global TA'
go


select N'比较前后2个月的 Global Market:'
select count(*) from tblQueryToolDriverMAX where MktType = 'Global TA'
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




-- print 'In-line Market Hypertention'
-- declare @mth varchar(10)
-- select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
-- insert into tblQueryToolDriverMAX
-- select distinct 
--    'In-line Market' as MktType
--    , 'HYP' as Mkt
--    , 'HYPERTENSION MARKET' as MktName,
--    ATC3_Cod, 'NA' as Class, Mole_Cod,Mole_Des,
--    Prod_Cod,Prod_Des as Prod_Des, 
--    Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
--    MNC, 'N' CLSInd,Gene_Cod, @mth as AddMonth
-- from tblQueryToolDriverATC
-- where ATC2_Cod in ('C02','C03','C07','C08','C09')
GO

-- print 'In-line Market PLATINUM'
-- declare @mth varchar(10)
-- select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
-- insert into tblQueryToolDriverMAX
-- select distinct 
--    'In-line Market' as MktType
--    , 'PLATINUM' as Mkt
--    , 'PLATINUM MARKET' as MktName,
--    ATC3_Cod, 'NA' as Class, Mole_Cod,Mole_Des,
--    Prod_Cod,Prod_Des as Prod_Des, 
--    Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
--    MNC, 'N' CLSInd,Gene_Cod, @mth as AddMonth
-- from tblQueryToolDriverATC
-- where Mole_cod in ('031172','501750','398650')
go

print 'In-line Market ONCFCS'
declare @mth varchar(10)
select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
insert into tblQueryToolDriverMAX
select distinct 'In-line Market' as MktType, 
	'ONCFCS' as Mkt, 'TAXOL MARKET' as MktName,
	ATC3_Cod, 'NA' as Class, Mole_Cod,Mole_Des,
	Prod_Cod,Prod_Des as Prod_Des, 
	Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
	MNC, 'N' CLSInd,Gene_Cod, @mth as AddMonth
from tblQueryToolDriverATC
where Mole_cod in ('385082','392175','395667')
go

-- print 'In-line Market NIAD'
-- declare @mth varchar(10)
-- select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
-- insert into tblQueryToolDriverMAX
-- select distinct 'In-line Market' as MktType,
-- 	'NIAD' as Mkt, 'GLUCOPHAGE MARKET' as MktName,
-- 	ATC3_Cod, Mkt as Class, Mole_Cod, Mole_Des, 
-- 	Prod_Cod, Prod_Des + ' (' + Manu_cod + ')' as Prod_Des, 
-- 	Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
-- 	MNC,'Y' CLSInd, Gene_Cod, @mth as AddMonth
-- from Db4.BMSChinaCIA_IMS.dbo.tblMktDef_Inline
-- where mkt in ('AGI','BI','DPP4','GLIN','GLP1','SU','TZD')
go

print 'In-line Market HYPM'
declare @mth varchar(10)
select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
insert into tblQueryToolDriverMAX
select distinct 'In-line Market' as MktType, 
	'HYPM' as Mkt, 'MONOPRIL MARKET' as MktName,
	ATC3_Cod, 'NA' as Class, Mole_Cod,Mole_Des,
	Prod_Cod,Prod_Des as Prod_Des, 
	Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
	MNC,'N' CLSInd, Gene_Cod, @mth as AddMonth
from tblQueryToolDriverATC
where Prod_cod in ('07279','02433','02380','11350')
go


-- print 'In-line Market CCB'
-- declare @mth varchar(10)
-- select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
-- insert into tblQueryToolDriverMAX
-- select distinct 'In-line Market' as MktType, 
-- 	'CCB' as Mkt, 'CONIEL MARKET' as MktName,
-- 	ATC3_Cod, 'NA' as Class, Mole_Cod,Mole_Des,
-- 	Prod_Cod,Prod_Des as Prod_Des, 
-- 	Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
-- 	MNC,'N' CLSInd, Gene_Cod, @mth as AddMonth
-- from tblQueryToolDriverATC
-- where ATC2_cod ='C08'
go

print 'In-line Market CML'
declare @mth varchar(10)
select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
insert into tblQueryToolDriverMAX
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
if not exists(select * from tblQueryToolDriverMAX where Prod_cod = '97029')
begin
	insert into tblQueryToolDriverMAX
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
insert into tblQueryToolDriverMAX
select distinct 'In-line Market' as MktType,
	'ARV' as Mkt, 'BARACLUDE MARKET' as MktName,
	ATC3_Cod, 'NA' as Class, Mole_Cod, Mole_Des, 
	Prod_Cod, Prod_Des + ' (' + Manu_cod + ')' as Prod_Des, 
	Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
	MNC,'N' CLSInd, Gene_Cod, @mth as AddMonth
from Db4.BMSChinaCIA_IMS.dbo.tblMktDef_Inline
where mkt = 'arv'
go
delete a from tblQueryToolDriverMAX a 
where not exists(select * from mthchpa_pkau b where a.pack_cod = b.pack_cod)
	and not exists(select * from mthcity_pkau b where a.pack_cod = b.pack_cod)
	-- and not exists(select * from MTHCITY_MAX b where a.pack_cod = b.pack_cod)
	and a.MktType = ('In-line Market')
go

SET ansi_warnings OFF

-- print 'In-line Market Eliquis(VTEp)'
-- declare @mth varchar(10)
-- select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
-- insert into tblQueryToolDriverMAX
-- select distinct 'In-line Market' as MktType, 
-- 	'Eliquis(VTEp)' as Mkt, 'Eliquis(VTEp) MARKET' as MktName,
-- 	ATC3_Cod, 'NA' as Class, Mole_Cod,Mole_Des,
-- 	Prod_Cod,Prod_Des as Prod_Des, 
-- 	Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
-- 	MNC,'N' CLSInd, Gene_Cod, @mth as AddMonth
-- from tblQueryToolDriverATC
-- where Mole_cod in ('406260','408800','408827','413885','703259','704307','710047','711981','719372', '904100') 
-- 	and Prod_cod <> '14146' -- 去掉复方

-- 20161102 modify VTEp market to APIXABAN,RIVAROXABAN,DABIGATRAN ETEXILATE,ENOXAPARIN SODIUM,DALTEPARIN SODIUM,
--	LOW MOLECULAR WEIGHT HEPARIN,HEPARIN,FONDAPARINUX SODIUM,NADROPARIN CALCIUM molecule
-- where Prod_cod in ('06253','08621','40785','53099','37977')
--FRAXIPARINE+CLEXANE+XARELTO+ELIQUIS+ARIXTRA（安卓）
go

-- print 'In-line Market Eliquis(NOAC)'
-- declare @mth varchar(10)
-- select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
-- insert into tblQueryToolDriverMAX
-- select distinct 'In-line Market' as MktType, 
-- 	'Eliquis(NOAC)' as Mkt, 'Eliquis(NOAC) MARKET' as MktName,
-- 	ATC3_Cod, 'NA' as Class, Mole_Cod,Mole_Des,
-- 	Prod_Cod,Prod_Des as Prod_Des, 
-- 	Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
-- 	MNC,'N' CLSInd, Gene_Cod, @mth as AddMonth
-- from tblQueryToolDriverATC
-- where Prod_cod in ('53099','40785','52911')
-- --Eliquis+XARELTO+PRADAXA（泰毕全）

-- -- 20161102 change NOAC to VTEt
-- print 'In-line Market Eliquis(VTEt)'
-- declare @mth varchar(10)
-- select @mth =DataPeriod from tblDataPeriod where QType = 'IMS'
-- insert into tblQueryToolDriverMAX
-- select distinct 'In-line Market' as MktType, 
-- 	'Eliquis(VTEt)' as Mkt, 'Eliquis(VTEt) MARKET' as MktName,
-- 	ATC3_Cod, 'NA' as Class, Mole_Cod,Mole_Des,
-- 	Prod_Cod,Prod_Des as Prod_Des, 
-- 	Pack_Cod, Pack_Des,Corp_Cod, Corp_Des,Manu_Cod, Manu_Des,
-- 	MNC,'N' CLSInd, Gene_Cod, @mth as AddMonth
-- from tblQueryToolDriverATC
-- where Mole_cod in ('406260','408800','408827','413885','703259','710047','704307','711981','719372','239900', '904100')
-- 	and Prod_cod <> '14146' -- 去掉复方
go

SET ansi_warnings on

select N'比较前后2个月的 In-line  Market:' 
select count(*) from tblQueryToolDriverMAX where MktType = 'In-line Market'
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
insert into tblQueryToolDriverMAX
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

delete a from tblQueryToolDriverMAX a 
where not exists(select * from mthchpa_pkau b where a.pack_cod = b.pack_cod)
	-- and not exists(select * from mthcity_pkau b where a.pack_cod = b.pack_cod)
	and not exists(select * from MTHCITY_MAX b where a.pack_cod = b.pack_cod)
	and a.MktType = ('Pipeline Market')
go

select N'比较前后2个月的 Pipeine Market:' 
select count(*) from tblQueryToolDriverMAX where MktType = 'Pipeline Market'
declare @curIMSMth varchar(6), @lastIMSMth varchar(6)
select @curIMSMth= DataPeriod from tblDataPeriod where QType = 'IMS'
set @lastIMSMth = convert(varchar(6), dateadd(month, -1, cast(@curIMSMth+'01' as datetime)), 112)
exec('
select count(*) from BMSCNProc_bak.dbo.tblQueryToolDriverIMS_'+@lastIMSMth+' 
where MktType = ''Pipeline Market''')
go




-- Append CMPS info
alter table tblQueryToolDriverMAX add CMPS_Code varchar(10) null
go
alter table tblQueryToolDriverMAX add CMPS_Name varchar(255) null
GO
update tblQueryToolDriverMAX 
set Cmps_Code=b.CMPS_Cod, CMPS_Name=b.CMPS_DES
from tblQueryToolDriverMAX a 
inner join tblCmpsPack b
on a.Pack_Cod=b.Pack_Cod
GO
--Remove package which have no Comps code
delete from tblQueryToolDriverMAX where cmps_code is null
GO






--Special deal

-- select * from tblCmpsPack where  PACK_COD in ('9702902','9702904','9702906')
insert into tblQueryToolDriverMAX
select 'In-line Market' MktType, 'CML' Mkt, 'SPRYCEL MARKET' MktName ,
	ATC3_Cod,'NA' Class, Mole_cod, Mole_des, Prod_cod, Prod_des + ' (' + Manu_cod + ')' as Prod_Des,
	Pack_cod, Pack_des,Corp_cod, Corp_des, Manu_cod, Manu_des,
	MNC, 'N' CLSInd, Gene_cod, '201206', '004157', 'DASATINIB'
from Db4.BMSChinaCIA_IMS.dbo.tblMktDef_ATCDriver 
where prod_cod = '97029'
GO
--删除 箔类Mkt中Molecule Compsion 带“+”的
delete --select *
from tblQueryToolDriverMAX
where MktType='In-line Market' and Mkt='PLATINUM' and MktName='PLATINUM MARKET'
and Mole_cod in ('031172','501750','398650')
and PACK_COD='1512702'
GO
--删除 pipeline market 的 带“+”的
delete -- select *
from tblQueryToolDriverMAX
where MktType='Pipeline Market'
and CMPS_Name like '%+%'
GO

-- queryTool only need Sprycel, Taxol, Monopril, baraclude market
delete 
from tblQueryToolDriverMAX
where mkt not in ('ONCFCS', 'HYPM', 'CML', 'ARV')


exec dbo.sp_Log_Event 'Prepare','QT_MAX','0_Prepare_MAX.sql','End',null,null
