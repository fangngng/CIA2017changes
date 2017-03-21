use BMSChinaQueryToolNew
go

exec BMSCNProc2_test.dbo.sp_Log_Event 'Output','QT_CPA_Pipeline','99_Output_Hosp_Pipeline.sql','Start',null,null



/*
================ Hospital PipeLine ================
*/
IF OBJECT_ID(N'tblHospitalList_Pipeline',N'U') IS NOT NULL
	DROP TABLE tblHospitalList_Pipeline
GO
SELECT * INTO tblHospitalList_Pipeline FROM BMSCNProc2_test.dbo.tblHospitalList_Pipeline
go


IF OBJECT_ID(N'tblQueryToolDriverHosp_Pipeline',N'U') IS NOT NULL
	DROP TABLE tblQueryToolDriverHosp_Pipeline
GO
SELECT * INTO tblQueryToolDriverHosp_Pipeline FROM BMSCNProc2_test.dbo.tblQueryToolDriverHosp_Pipeline
go




if object_id(N'tblOutput_Hosp_TA_RMB_QTR_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_RMB_QTR_Pipeline
go
select * into tblOutput_Hosp_TA_RMB_QTR_Pipeline
from BMSCNProc2_test.dbo.tblOutput_Hosp_TA_RMB_QTR_Pipeline
go
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_RMB_QTR_Pipeline')
drop index tblOutput_Hosp_TA_RMB_QTR_Pipeline on tblOutput_Hosp_TA_RMB_QTR_Pipeline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_RMB_QTR_Pipeline ON [dbo].tblOutput_Hosp_TA_RMB_QTR_Pipeline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
if object_id(N'tblOutput_Hosp_TA_USD_QTR_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_USD_QTR_Pipeline
go
select * into tblOutput_Hosp_TA_USD_QTR_Pipeline
from BMSCNProc2_test.dbo.tblOutput_Hosp_TA_USD_QTR_Pipeline
go
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_USD_QTR_Pipeline')
drop index tblOutput_Hosp_TA_USD_QTR_Pipeline on tblOutput_Hosp_TA_USD_QTR_Pipeline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_USD_QTR_Pipeline ON [dbo].tblOutput_Hosp_TA_USD_QTR_Pipeline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
if object_id(N'tblOutput_Hosp_TA_UNT_QTR_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_UNT_QTR_Pipeline
go
select * into tblOutput_Hosp_TA_UNT_QTR_Pipeline
from BMSCNProc2_test.dbo.tblOutput_Hosp_TA_UNT_QTR_Pipeline
go
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_UNT_QTR_Pipeline')
drop index tblOutput_Hosp_TA_UNT_QTR_Pipeline on tblOutput_Hosp_TA_UNT_QTR_Pipeline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_UNT_QTR_Pipeline ON [dbo].tblOutput_Hosp_TA_UNT_QTR_Pipeline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO


if object_id(N'tblOutput_Hosp_TA_RMB_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_RMB_MAT_Pipeline
go
select * into tblOutput_Hosp_TA_RMB_MAT_Pipeline
from BMSCNProc2_test.dbo.tblOutput_Hosp_TA_RMB_MAT_Pipeline
go
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_RMB_MAT_Pipeline')
drop index tblOutput_Hosp_TA_RMB_MAT_Pipeline on tblOutput_Hosp_TA_RMB_MAT_Pipeline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_RMB_MAT_Pipeline ON [dbo].tblOutput_Hosp_TA_RMB_MAT_Pipeline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
if object_id(N'tblOutput_Hosp_TA_USD_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_USD_MAT_Pipeline
go

select * into tblOutput_Hosp_TA_USD_MAT_Pipeline
from BMSCNProc2_test.dbo.tblOutput_Hosp_TA_USD_MAT_Pipeline
go
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_USD_MAT_Pipeline')
drop index tblOutput_Hosp_TA_USD_MAT_Pipeline on tblOutput_Hosp_TA_USD_MAT_Pipeline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_USD_MAT_Pipeline ON [dbo].tblOutput_Hosp_TA_USD_MAT_Pipeline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO

if object_id(N'tblOutput_Hosp_TA_UNT_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_UNT_MAT_Pipeline
go
select * into tblOutput_Hosp_TA_UNT_MAT_Pipeline
from BMSCNProc2_test.dbo.tblOutput_Hosp_TA_UNT_MAT_Pipeline
go

if exists(select * from sysindexes where name='tblOutput_Hosp_TA_UNT_MAT_Pipeline')
drop index tblOutput_Hosp_TA_UNT_MAT_Pipeline on tblOutput_Hosp_TA_UNT_MAT_Pipeline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_UNT_MAT_Pipeline ON [dbo].tblOutput_Hosp_TA_UNT_MAT_Pipeline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
if object_id(N'tblOutput_Hosp_TA_RMB_YTD_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_RMB_YTD_Pipeline
go
select * into tblOutput_Hosp_TA_RMB_YTD_Pipeline
from BMSCNProc2_test.dbo.tblOutput_Hosp_TA_RMB_YTD_Pipeline
go
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_RMB_YTD_Pipeline')
drop index tblOutput_Hosp_TA_RMB_YTD_Pipeline on tblOutput_Hosp_TA_RMB_YTD_Pipeline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_RMB_YTD_Pipeline ON [dbo].tblOutput_Hosp_TA_RMB_YTD_Pipeline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
if object_id(N'tblOutput_Hosp_TA_USD_YTD_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_USD_YTD_Pipeline
go
select * into tblOutput_Hosp_TA_USD_YTD_Pipeline
from BMSCNProc2_test.dbo.tblOutput_Hosp_TA_USD_YTD_Pipeline
go
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_USD_YTD_Pipeline')
drop index tblOutput_Hosp_TA_USD_YTD_Pipeline on tblOutput_Hosp_TA_USD_YTD_Pipeline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_USD_YTD_Pipeline ON [dbo].tblOutput_Hosp_TA_USD_YTD_Pipeline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
if object_id(N'tblOutput_Hosp_TA_UNT_YTD_Pipeline',N'U') is not null
   drop table tblOutput_Hosp_TA_UNT_YTD_Pipeline
go
select * into tblOutput_Hosp_TA_UNT_YTD_Pipeline
from BMSCNProc2_test.dbo.tblOutput_Hosp_TA_UNT_YTD_Pipeline
go
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_UNT_YTD_Pipeline')
drop index tblOutput_Hosp_TA_UNT_YTD_Pipeline on tblOutput_Hosp_TA_UNT_YTD_Pipeline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_UNT_YTD_Pipeline ON [dbo].tblOutput_Hosp_TA_UNT_YTD_Pipeline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
--view：
--QTR:
IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_Hosp_TA_QTR_Pipeline')
DROP VIEW tblOutput_Hosp_TA_QTR_Pipeline
go
CREATE VIEW tblOutput_Hosp_TA_QTR_Pipeline
as

select 'QTR' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.grp_lvl,a.hosp_id,a.hosp_des_en,a.tier,a.class,a.prod_lvl,a.uniq_prod,a.molecule_name,a.molecule_code,a.product_name,
a.product_code,a.package_name,a.package_code,a.manuf_name,a.manuf_code,a.mnc,a.datasource,a.[CPA_CODE(PHA_CODE)],
a.VR_QTR_24,a.VR_QTR_23,a.VR_QTR_22,a.VR_QTR_21,a.VR_QTR_20,a.VR_QTR_19,a.VR_QTR_18,a.VR_QTR_17,a.VR_QTR_16,a.VR_QTR_15,a.VR_QTR_14,a.VR_QTR_13,
a.VR_QTR_12,a.VR_QTR_11,a.VR_QTR_10,a.VR_QTR_9,a.VR_QTR_8,a.VR_QTR_7,a.VR_QTR_6,a.VR_QTR_5,a.VR_QTR_4,a.VR_QTR_3,a.VR_QTR_2,a.VR_QTR_1,
b.UT_QTR_24,b.UT_QTR_23,b.UT_QTR_22,b.UT_QTR_21,b.UT_QTR_20,b.UT_QTR_19,b.UT_QTR_18,b.UT_QTR_17,b.UT_QTR_16,b.UT_QTR_15,b.UT_QTR_14,b.UT_QTR_13,
b.UT_QTR_12,b.UT_QTR_11,b.UT_QTR_10,b.UT_QTR_9,b.UT_QTR_8,b.UT_QTR_7,b.UT_QTR_6,b.UT_QTR_5,b.UT_QTR_4,b.UT_QTR_3,b.UT_QTR_2,b.UT_QTR_1,
c.VU_QTR_24,c.VU_QTR_23,c.VU_QTR_22,c.VU_QTR_21,c.VU_QTR_20,c.VU_QTR_19,c.VU_QTR_18,c.VU_QTR_17,c.VU_QTR_16,c.VU_QTR_15,c.VU_QTR_14,c.VU_QTR_13,
c.VU_QTR_12,c.VU_QTR_11,c.VU_QTR_10,c.VU_QTR_9,c.VU_QTR_8,c.VU_QTR_7,c.VU_QTR_6,c.VU_QTR_5,c.VU_QTR_4,c.VU_QTR_3,c.VU_QTR_2,c.VU_QTR_1
from tblOutput_Hosp_TA_RMB_QTR_Pipeline a
inner join tblOutput_Hosp_TA_UNT_QTR_Pipeline b
on a.mkt=b.mkt and a.geo=b.geo and a.grp_lvl=b.grp_lvl and a.tier=b.tier and a.hosp_id=b.hosp_id and case when a.class is null then '' else a.class end=case when b.class is null then '' else b.class end
and a.prod_lvl=b.prod_lvl and a.molecule_code=b.molecule_code and a.product_code=b.product_code and case when  a.manuf_name is null then '' else a.manuf_name end=case when b.manuf_name is null then '' else b.manuf_name end
and a.package_code=b.package_code and case when a.manuf_code is null then '' else a.manuf_code end =case when b.manuf_code  is null then '' else b.manuf_code end
inner join tblOutput_Hosp_TA_USD_QTR_Pipeline c
on a.mkt=c.mkt and a.geo=c.geo and a.grp_lvl=c.grp_lvl and a.tier=c.tier and a.hosp_id=c.hosp_id and case when a.class is null then '' else a.class end=case when c.class is null then '' else c.class end
and a.prod_lvl=c.prod_lvl and a.molecule_code=c.molecule_code and a.product_code=c.product_code and case when  a.manuf_name is null then '' else a.manuf_name end=case when c.manuf_name is null then '' else c.manuf_name end
and a.package_code=c.package_code and case when a.manuf_code is null then '' else a.manuf_code end =case when c.manuf_code  is null then '' else c.manuf_code end
GO

--MAT:
IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_Hosp_TA_MAT_Pipeline')
DROP VIEW tblOutput_Hosp_TA_MAT_Pipeline
go
CREATE VIEW tblOutput_Hosp_TA_MAT_Pipeline
as
select 'MAT' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.grp_lvl,a.hosp_id,a.hosp_des_en,a.tier,a.class,a.prod_lvl,a.uniq_prod,a.molecule_name,a.molecule_code,a.product_name,
a.product_code,a.package_name,a.package_code,a.manuf_name,a.manuf_code,a.mnc,a.datasource,a.[CPA_CODE(PHA_CODE)],
a.VR_MAT_24,a.VR_MAT_23,a.VR_MAT_22,a.VR_MAT_21,a.VR_MAT_20,a.VR_MAT_19,a.VR_MAT_18,a.VR_MAT_17,a.VR_MAT_16,a.VR_MAT_15,a.VR_MAT_14,a.VR_MAT_13,
a.VR_MAT_12,a.VR_MAT_11,a.VR_MAT_10,a.VR_MAT_9,a.VR_MAT_8,a.VR_MAT_7,a.VR_MAT_6,a.VR_MAT_5,a.VR_MAT_4,a.VR_MAT_3,a.VR_MAT_2,a.VR_MAT_1,
b.UT_MAT_24,b.UT_MAT_23,b.UT_MAT_22,b.UT_MAT_21,b.UT_MAT_20,b.UT_MAT_19,b.UT_MAT_18,b.UT_MAT_17,b.UT_MAT_16,b.UT_MAT_15,b.UT_MAT_14,b.UT_MAT_13,
b.UT_MAT_12,b.UT_MAT_11,b.UT_MAT_10,b.UT_MAT_9,b.UT_MAT_8,b.UT_MAT_7,b.UT_MAT_6,b.UT_MAT_5,b.UT_MAT_4,b.UT_MAT_3,b.UT_MAT_2,b.UT_MAT_1,
c.VU_MAT_24,c.VU_MAT_23,c.VU_MAT_22,c.VU_MAT_21,c.VU_MAT_20,c.VU_MAT_19,c.VU_MAT_18,c.VU_MAT_17,c.VU_MAT_16,c.VU_MAT_15,c.VU_MAT_14,c.VU_MAT_13,
c.VU_MAT_12,c.VU_MAT_11,c.VU_MAT_10,c.VU_MAT_9,c.VU_MAT_8,c.VU_MAT_7,c.VU_MAT_6,c.VU_MAT_5,c.VU_MAT_4,c.VU_MAT_3,c.VU_MAT_2,c.VU_MAT_1
from tblOutput_Hosp_TA_RMB_MAT_Pipeline a
inner join tblOutput_Hosp_TA_UNT_MAT_Pipeline b
on a.mkt=b.mkt and a.geo=b.geo and a.grp_lvl=b.grp_lvl and a.tier=b.tier and a.hosp_id=b.hosp_id and case when a.class is null then '' else a.class end=case when b.class is null then '' else b.class end
and a.prod_lvl=b.prod_lvl and a.molecule_code=b.molecule_code and a.product_code=b.product_code and case when  a.manuf_name is null then '' else a.manuf_name end=case when b.manuf_name is null then '' else b.manuf_name end
and a.package_code=b.package_code and case when a.manuf_code is null then '' else a.manuf_code end =case when b.manuf_code  is null then '' else b.manuf_code end
inner join tblOutput_Hosp_TA_USD_MAT_Pipeline c
on a.mkt=c.mkt and a.geo=c.geo and a.grp_lvl=c.grp_lvl and a.tier=c.tier and a.hosp_id=c.hosp_id and case when a.class is null then '' else a.class end=case when c.class is null then '' else c.class end
and a.prod_lvl=c.prod_lvl and a.molecule_code=c.molecule_code and a.product_code=c.product_code and case when  a.manuf_name is null then '' else a.manuf_name end=case when c.manuf_name is null then '' else c.manuf_name end
and a.package_code=c.package_code and case when a.manuf_code is null then '' else a.manuf_code end =case when c.manuf_code  is null then '' else c.manuf_code end
GO


--YTD:
IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_Hosp_TA_YTD_Pipeline')
DROP VIEW tblOutput_Hosp_TA_YTD_Pipeline
go
CREATE VIEW tblOutput_Hosp_TA_YTD_Pipeline
as
select 'YTD' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.grp_lvl,a.hosp_id,a.hosp_des_en,a.tier,a.class,a.prod_lvl,a.uniq_prod,a.molecule_name,a.molecule_code,a.product_name,
a.product_code,a.package_name,a.package_code,a.manuf_name,a.manuf_code,a.mnc,a.datasource,a.[CPA_CODE(PHA_CODE)],
a.VR_YTD_24,a.VR_YTD_23,a.VR_YTD_22,a.VR_YTD_21,a.VR_YTD_20,a.VR_YTD_19,a.VR_YTD_18,a.VR_YTD_17,a.VR_YTD_16,a.VR_YTD_15,a.VR_YTD_14,a.VR_YTD_13,
a.VR_YTD_12,a.VR_YTD_11,a.VR_YTD_10,a.VR_YTD_9,a.VR_YTD_8,a.VR_YTD_7,a.VR_YTD_6,a.VR_YTD_5,a.VR_YTD_4,a.VR_YTD_3,a.VR_YTD_2,a.VR_YTD_1,
b.UT_YTD_24,b.UT_YTD_23,b.UT_YTD_22,b.UT_YTD_21,b.UT_YTD_20,b.UT_YTD_19,b.UT_YTD_18,b.UT_YTD_17,b.UT_YTD_16,b.UT_YTD_15,b.UT_YTD_14,b.UT_YTD_13,
b.UT_YTD_12,b.UT_YTD_11,b.UT_YTD_10,b.UT_YTD_9,b.UT_YTD_8,b.UT_YTD_7,b.UT_YTD_6,b.UT_YTD_5,b.UT_YTD_4,b.UT_YTD_3,b.UT_YTD_2,b.UT_YTD_1,
c.VU_YTD_24,c.VU_YTD_23,c.VU_YTD_22,c.VU_YTD_21,c.VU_YTD_20,c.VU_YTD_19,c.VU_YTD_18,c.VU_YTD_17,c.VU_YTD_16,c.VU_YTD_15,c.VU_YTD_14,c.VU_YTD_13,
c.VU_YTD_12,c.VU_YTD_11,c.VU_YTD_10,c.VU_YTD_9,c.VU_YTD_8,c.VU_YTD_7,c.VU_YTD_6,c.VU_YTD_5,c.VU_YTD_4,c.VU_YTD_3,c.VU_YTD_2,c.VU_YTD_1
from tblOutput_Hosp_TA_RMB_YTD_Pipeline a
inner join tblOutput_Hosp_TA_UNT_YTD_Pipeline b
on a.mkt=b.mkt and a.geo=b.geo and a.grp_lvl=b.grp_lvl and a.tier=b.tier and a.hosp_id=b.hosp_id and case when a.class is null then '' else a.class end=case when b.class is null then '' else b.class end
and a.prod_lvl=b.prod_lvl and a.molecule_code=b.molecule_code and a.product_code=b.product_code and case when  a.manuf_name is null then '' else a.manuf_name end=case when b.manuf_name is null then '' else b.manuf_name end
and a.package_code=b.package_code and case when a.manuf_code is null then '' else a.manuf_code end =case when b.manuf_code  is null then '' else b.manuf_code end
inner join tblOutput_Hosp_TA_USD_YTD_Pipeline c
on a.mkt=c.mkt and a.geo=c.geo and a.grp_lvl=c.grp_lvl and a.tier=c.tier and a.hosp_id=c.hosp_id and case when a.class is null then '' else a.class end=case when c.class is null then '' else c.class end
and a.prod_lvl=c.prod_lvl and a.molecule_code=c.molecule_code and a.product_code=c.product_code and case when  a.manuf_name is null then '' else a.manuf_name end=case when c.manuf_name is null then '' else c.manuf_name end
and a.package_code=c.package_code and case when a.manuf_code is null then '' else a.manuf_code end =case when c.manuf_code  is null then '' else c.manuf_code end
GO

exec BMSCNProc2_test.dbo.sp_Log_Event 'Output','QT_CPA_Pipeline','99_Output_Hosp_Pipeline.sql','End',null,null

