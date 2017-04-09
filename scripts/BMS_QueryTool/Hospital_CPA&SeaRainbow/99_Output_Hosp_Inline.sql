use BMSChinaQueryToolNew
go
exec BMSCNProc2.dbo.sp_Log_Event 'Output','QT_CPA_Inline','99_Output_Hosp_Inline.sql','Start',null,null


print '--tblDataMonthConv'
IF OBJECT_ID(N'tblDataMonthConv',N'U') IS NOT NULL
	DROP TABLE tblDataMonthConv
GO
SELECT * INTO tblDataMonthConv FROM BMSCNProc2.dbo.tblDataMonthConv
go
print '--tblCityListForHospital'
if object_id(N'tblCityListForHospital',N'U') is not null
	drop table tblCityListForHospital
go
select * into tblCityListForHospital
from BMSCNProc2.dbo.tblCityListForHospital
go
print '--tblQueryToolDriverHosp'
if object_id(N'tblQueryToolDriverHosp',N'U') is not null
	drop table tblQueryToolDriverHosp
go
select * into tblQueryToolDriverHosp
from BMSCNProc2.dbo.tblQueryToolDriverHosp
go
print '--tblHospitalList'
IF OBJECT_ID(N'tblHospitalList',N'U') IS NOT NULL
	DROP TABLE tblHospitalList
GO
SELECT * INTO tblHospitalList FROM BMSCNProc2.dbo.tblHospitalList
go
print '--tblOutput_Hosp_TA_UNT_MTH_Inline'
if object_id(N'tblOutput_Hosp_TA_UNT_MTH_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_UNT_MTH_Inline
go
select * into tblOutput_Hosp_TA_UNT_MTH_Inline
from BMSCNProc2.dbo.tblOutput_Hosp_TA_UNT_MTH_Inline
GO
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_UNT_MTH_Inline')
drop index tblOutput_Hosp_TA_UNT_MTH_Inline on tblOutput_Hosp_TA_UNT_MTH_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_UNT_MTH_Inline ON [dbo].tblOutput_Hosp_TA_UNT_MTH_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

go
print '9--tblOutput_Hosp_TA_USD_MTH_Inline'
if object_id(N'tblOutput_Hosp_TA_USD_MTH_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_USD_MTH_Inline
go
select * into tblOutput_Hosp_TA_USD_MTH_Inline
from BMSCNProc2.dbo.tblOutput_Hosp_TA_USD_MTH_Inline
GO
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_USD_MTH_Inline')
drop index tblOutput_Hosp_TA_USD_MTH_Inline on tblOutput_Hosp_TA_USD_MTH_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_USD_MTH_Inline ON [dbo].tblOutput_Hosp_TA_USD_MTH_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
go
print '--tblOutput_Hosp_TA_UNT_MAT_Inline'
if object_id(N'tblOutput_Hosp_TA_UNT_MAT_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_UNT_MAT_Inline
go
select * into tblOutput_Hosp_TA_UNT_MAT_Inline
from BMSCNProc2.dbo.tblOutput_Hosp_TA_UNT_MAT_Inline
GO
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_UNT_MAT_Inline')
drop index tblOutput_Hosp_TA_UNT_MAT_Inline on tblOutput_Hosp_TA_UNT_MAT_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_UNT_MAT_Inline ON [dbo].tblOutput_Hosp_TA_UNT_MAT_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
go
print '--tblOutput_Hosp_TA_RMB_MQT_Inline'
if object_id(N'tblOutput_Hosp_TA_RMB_MQT_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_RMB_MQT_Inline
go
select * into tblOutput_Hosp_TA_RMB_MQT_Inline
from BMSCNProc2.dbo.tblOutput_Hosp_TA_RMB_MQT_Inline
GO
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_RMB_MQT_Inline')
drop index tblOutput_Hosp_TA_RMB_MQT_Inline on tblOutput_Hosp_TA_RMB_MQT_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_RMB_MQT_Inline ON [dbo].tblOutput_Hosp_TA_RMB_MQT_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
go
print '--tblOutput_Hosp_TA_UNT_MQT_Inline'
if object_id(N'tblOutput_Hosp_TA_UNT_MQT_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_UNT_MQT_Inline
go
select * into tblOutput_Hosp_TA_UNT_MQT_Inline
from BMSCNProc2.dbo.tblOutput_Hosp_TA_UNT_MQT_Inline
GO
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_UNT_MQT_Inline')
drop index tblOutput_Hosp_TA_UNT_MQT_Inline on tblOutput_Hosp_TA_UNT_MQT_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_UNT_MQT_Inline ON [dbo].tblOutput_Hosp_TA_UNT_MQT_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
go
print '--tblOutput_Hosp_TA_USD_MQT_Inline'
if object_id(N'tblOutput_Hosp_TA_USD_MQT_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_USD_MQT_Inline
go
select * into tblOutput_Hosp_TA_USD_MQT_Inline
from BMSCNProc2.dbo.tblOutput_Hosp_TA_USD_MQT_Inline
GO
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_USD_MQT_Inline')
drop index tblOutput_Hosp_TA_USD_MQT_Inline on tblOutput_Hosp_TA_USD_MQT_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_USD_MQT_Inline ON [dbo].tblOutput_Hosp_TA_USD_MQT_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
go
print '--tblOutput_Hosp_TA_USD_YTD_Inline'
if object_id(N'tblOutput_Hosp_TA_USD_YTD_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_USD_YTD_Inline
go
select * into tblOutput_Hosp_TA_USD_YTD_Inline
from BMSCNProc2.dbo.tblOutput_Hosp_TA_USD_YTD_Inline
GO
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_USD_YTD_Inline')
drop index tblOutput_Hosp_TA_USD_YTD_Inline on tblOutput_Hosp_TA_USD_YTD_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_USD_YTD_Inline ON [dbo].tblOutput_Hosp_TA_USD_YTD_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
go
print '--tblOutput_Hosp_TA_UNT_YTD_Inline'
if object_id(N'tblOutput_Hosp_TA_UNT_YTD_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_UNT_YTD_Inline
go
select * into tblOutput_Hosp_TA_UNT_YTD_Inline
from BMSCNProc2.dbo.tblOutput_Hosp_TA_UNT_YTD_Inline
GO
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_UNT_YTD_Inline')
drop index tblOutput_Hosp_TA_UNT_YTD_Inline on tblOutput_Hosp_TA_UNT_YTD_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_UNT_YTD_Inline ON [dbo].tblOutput_Hosp_TA_UNT_YTD_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
go
print '--tblOutput_Hosp_TA_RMB_MAT_Inline'
if object_id(N'tblOutput_Hosp_TA_RMB_MAT_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_RMB_MAT_Inline
go
select * into tblOutput_Hosp_TA_RMB_MAT_Inline
from BMSCNProc2.dbo.tblOutput_Hosp_TA_RMB_MAT_Inline
GO
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_RMB_MAT_Inline')
drop index tblOutput_Hosp_TA_RMB_MAT_Inline on tblOutput_Hosp_TA_RMB_MAT_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_RMB_MAT_Inline ON [dbo].tblOutput_Hosp_TA_RMB_MAT_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
go
print '--tblOutput_Hosp_TA_USD_MAT_Inline'
if object_id(N'tblOutput_Hosp_TA_USD_MAT_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_USD_MAT_Inline
go
select * into tblOutput_Hosp_TA_USD_MAT_Inline
from BMSCNProc2.dbo.tblOutput_Hosp_TA_USD_MAT_Inline
GO
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_USD_MAT_Inline')
drop index tblOutput_Hosp_TA_USD_MAT_Inline on tblOutput_Hosp_TA_USD_MAT_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_USD_MAT_Inline ON [dbo].tblOutput_Hosp_TA_USD_MAT_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
go
print '--tblOutput_Hosp_TA_RMB_YTD_Inline'
if object_id(N'tblOutput_Hosp_TA_RMB_YTD_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_RMB_YTD_Inline
go
select * into tblOutput_Hosp_TA_RMB_YTD_Inline
from BMSCNProc2.dbo.tblOutput_Hosp_TA_RMB_YTD_Inline
GO
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_RMB_YTD_Inline')
drop index tblOutput_Hosp_TA_RMB_YTD_Inline on tblOutput_Hosp_TA_RMB_YTD_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_RMB_YTD_Inline ON [dbo].tblOutput_Hosp_TA_RMB_YTD_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
go
print '--tblOutput_Hosp_TA_RMB_MTH_Inline'
if object_id(N'tblOutput_Hosp_TA_RMB_MTH_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_RMB_MTH_Inline
go
select * into tblOutput_Hosp_TA_RMB_MTH_Inline
from BMSCNProc2.dbo.tblOutput_Hosp_TA_RMB_MTH_Inline
GO
if exists(select * from sysindexes where name='tblOutput_Hosp_TA_RMB_MTH_Inline')
drop index tblOutput_Hosp_TA_RMB_MTH_Inline on tblOutput_Hosp_TA_RMB_MTH_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Hosp_TA_RMB_MTH_Inline ON [dbo].tblOutput_Hosp_TA_RMB_MTH_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]


--view:

--MTH:
IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_Hosp_TA_MTH_Inline')
	DROP VIEW tblOutput_Hosp_TA_MTH_Inline
go
CREATE VIEW tblOutput_Hosp_TA_MTH_Inline
as
select 'MTH' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.grp_lvl,a.hosp_id,a.hosp_des_en,a.tier,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.molecule_name,a.molecule_code,
	a.product_name,a.product_code,a.package_name,a.package_code,a.manuf_name,a.manuf_code,a.mnc,a.datasource,a.[CPA_CODE(PHA_CODE)],
	a.UT_MTH_48,a.UT_MTH_47,a.UT_MTH_46,a.UT_MTH_45,a.UT_MTH_44,a.UT_MTH_43,a.UT_MTH_42,a.UT_MTH_41,a.UT_MTH_40,a.UT_MTH_39,a.UT_MTH_38,a.UT_MTH_37,
	a.UT_MTH_36,a.UT_MTH_35,a.UT_MTH_34,a.UT_MTH_33,a.UT_MTH_32,a.UT_MTH_31,a.UT_MTH_30,a.UT_MTH_29,a.UT_MTH_28,a.UT_MTH_27,a.UT_MTH_26,a.UT_MTH_25,
	a.UT_MTH_24,a.UT_MTH_23,a.UT_MTH_22,a.UT_MTH_21,a.UT_MTH_20,a.UT_MTH_19,a.UT_MTH_18,a.UT_MTH_17,a.UT_MTH_16,a.UT_MTH_15,a.UT_MTH_14,a.UT_MTH_13,
	a.UT_MTH_12,a.UT_MTH_11,a.UT_MTH_10,a.UT_MTH_9,a.UT_MTH_8,a.UT_MTH_7,a.UT_MTH_6,a.UT_MTH_5,a.UT_MTH_4,a.UT_MTH_3,a.UT_MTH_2,a.UT_MTH_1,
	a.UT_MTH_SHR_48,a.UT_MTH_SHR_47,a.UT_MTH_SHR_46,a.UT_MTH_SHR_45,a.UT_MTH_SHR_44,a.UT_MTH_SHR_43,a.UT_MTH_SHR_42,a.UT_MTH_SHR_41,a.UT_MTH_SHR_40,a.UT_MTH_SHR_39,a.UT_MTH_SHR_38,a.UT_MTH_SHR_37,
	a.UT_MTH_SHR_36,a.UT_MTH_SHR_35,a.UT_MTH_SHR_34,a.UT_MTH_SHR_33,a.UT_MTH_SHR_32,a.UT_MTH_SHR_31,a.UT_MTH_SHR_30,a.UT_MTH_SHR_29,a.UT_MTH_SHR_28,a.UT_MTH_SHR_27,a.UT_MTH_SHR_26,a.UT_MTH_SHR_25,
	a.UT_MTH_SHR_24,a.UT_MTH_SHR_23,a.UT_MTH_SHR_22,a.UT_MTH_SHR_21,a.UT_MTH_SHR_20,a.UT_MTH_SHR_19,a.UT_MTH_SHR_18,a.UT_MTH_SHR_17,a.UT_MTH_SHR_16,a.UT_MTH_SHR_15,a.UT_MTH_SHR_14,a.UT_MTH_SHR_13,
	a.UT_MTH_SHR_12,a.UT_MTH_SHR_11,a.UT_MTH_SHR_10,a.UT_MTH_SHR_9,a.UT_MTH_SHR_8,a.UT_MTH_SHR_7,a.UT_MTH_SHR_6,a.UT_MTH_SHR_5,a.UT_MTH_SHR_4,a.UT_MTH_SHR_3,a.UT_MTH_SHR_2,a.UT_MTH_SHR_1,
	b.VR_MTH_48,b.VR_MTH_47,b.VR_MTH_46,b.VR_MTH_45,b.VR_MTH_44,b.VR_MTH_43,b.VR_MTH_42,b.VR_MTH_41,b.VR_MTH_40,b.VR_MTH_39,b.VR_MTH_38,b.VR_MTH_37,
	b.VR_MTH_36,b.VR_MTH_35,b.VR_MTH_34,b.VR_MTH_33,b.VR_MTH_32,b.VR_MTH_31,b.VR_MTH_30,b.VR_MTH_29,b.VR_MTH_28,b.VR_MTH_27,b.VR_MTH_26,b.VR_MTH_25,
	b.VR_MTH_24,b.VR_MTH_23,b.VR_MTH_22,b.VR_MTH_21,b.VR_MTH_20,b.VR_MTH_19,b.VR_MTH_18,b.VR_MTH_17,b.VR_MTH_16,b.VR_MTH_15,b.VR_MTH_14,b.VR_MTH_13,
	b.VR_MTH_12,b.VR_MTH_11,b.VR_MTH_10,b.VR_MTH_9,b.VR_MTH_8,b.VR_MTH_7,b.VR_MTH_6,b.VR_MTH_5,b.VR_MTH_4,b.VR_MTH_3,b.VR_MTH_2,b.VR_MTH_1,
	b.VR_MTH_SHR_48,b.VR_MTH_SHR_47,b.VR_MTH_SHR_46,b.VR_MTH_SHR_45,b.VR_MTH_SHR_44,b.VR_MTH_SHR_43,b.VR_MTH_SHR_42,b.VR_MTH_SHR_41,b.VR_MTH_SHR_40,b.VR_MTH_SHR_39,b.VR_MTH_SHR_38,b.VR_MTH_SHR_37,
	b.VR_MTH_SHR_36,b.VR_MTH_SHR_35,b.VR_MTH_SHR_34,b.VR_MTH_SHR_33,b.VR_MTH_SHR_32,b.VR_MTH_SHR_31,b.VR_MTH_SHR_30,b.VR_MTH_SHR_29,b.VR_MTH_SHR_28,b.VR_MTH_SHR_27,b.VR_MTH_SHR_26,b.VR_MTH_SHR_25,
	b.VR_MTH_SHR_24,b.VR_MTH_SHR_23,b.VR_MTH_SHR_22,b.VR_MTH_SHR_21,b.VR_MTH_SHR_20,b.VR_MTH_SHR_19,b.VR_MTH_SHR_18,b.VR_MTH_SHR_17,b.VR_MTH_SHR_16,b.VR_MTH_SHR_15,b.VR_MTH_SHR_14,b.VR_MTH_SHR_13,
	b.VR_MTH_SHR_12,b.VR_MTH_SHR_11,b.VR_MTH_SHR_10,b.VR_MTH_SHR_9,b.VR_MTH_SHR_8,b.VR_MTH_SHR_7,b.VR_MTH_SHR_6,b.VR_MTH_SHR_5,b.VR_MTH_SHR_4,b.VR_MTH_SHR_3,b.VR_MTH_SHR_2,b.VR_MTH_SHR_1,
	c.VU_MTH_48,c.VU_MTH_47,c.VU_MTH_46,c.VU_MTH_45,c.VU_MTH_44,c.VU_MTH_43,c.VU_MTH_42,c.VU_MTH_41,c.VU_MTH_40,c.VU_MTH_39,c.VU_MTH_38,c.VU_MTH_37,
	c.VU_MTH_36,c.VU_MTH_35,c.VU_MTH_34,c.VU_MTH_33,c.VU_MTH_32,c.VU_MTH_31,c.VU_MTH_30,c.VU_MTH_29,c.VU_MTH_28,c.VU_MTH_27,c.VU_MTH_26,c.VU_MTH_25,
	c.VU_MTH_24,c.VU_MTH_23,c.VU_MTH_22,c.VU_MTH_21,c.VU_MTH_20,c.VU_MTH_19,c.VU_MTH_18,c.VU_MTH_17,c.VU_MTH_16,c.VU_MTH_15,c.VU_MTH_14,c.VU_MTH_13,
	c.VU_MTH_12,c.VU_MTH_11,c.VU_MTH_10,c.VU_MTH_9,c.VU_MTH_8,c.VU_MTH_7,c.VU_MTH_6,c.VU_MTH_5,c.VU_MTH_4,c.VU_MTH_3,c.VU_MTH_2,c.VU_MTH_1,
	c.VU_MTH_SHR_48,c.VU_MTH_SHR_47,c.VU_MTH_SHR_46,c.VU_MTH_SHR_45,c.VU_MTH_SHR_44,c.VU_MTH_SHR_43,c.VU_MTH_SHR_42,c.VU_MTH_SHR_41,c.VU_MTH_SHR_40,c.VU_MTH_SHR_39,c.VU_MTH_SHR_38,c.VU_MTH_SHR_37,
	c.VU_MTH_SHR_36,c.VU_MTH_SHR_35,c.VU_MTH_SHR_34,c.VU_MTH_SHR_33,c.VU_MTH_SHR_32,c.VU_MTH_SHR_31,c.VU_MTH_SHR_30,c.VU_MTH_SHR_29,c.VU_MTH_SHR_28,c.VU_MTH_SHR_27,c.VU_MTH_SHR_26,c.VU_MTH_SHR_25,
	c.VU_MTH_SHR_24,c.VU_MTH_SHR_23,c.VU_MTH_SHR_22,c.VU_MTH_SHR_21,c.VU_MTH_SHR_20,c.VU_MTH_SHR_19,c.VU_MTH_SHR_18,c.VU_MTH_SHR_17,c.VU_MTH_SHR_16,c.VU_MTH_SHR_15,c.VU_MTH_SHR_14,c.VU_MTH_SHR_13,
	c.VU_MTH_SHR_12,c.VU_MTH_SHR_11,c.VU_MTH_SHR_10,c.VU_MTH_SHR_9,c.VU_MTH_SHR_8,c.VU_MTH_SHR_7,c.VU_MTH_SHR_6,c.VU_MTH_SHR_5,c.VU_MTH_SHR_4,c.VU_MTH_SHR_3,c.VU_MTH_SHR_2,c.VU_MTH_SHR_1
from tblOutput_Hosp_TA_UNT_MTH_Inline a
inner join tblOutput_Hosp_TA_RMB_MTH_Inline b
on a.mkt=b.mkt and a.geo=b.geo AND a.Geo_Lvl = b.Geo_Lvl and a.grp_lvl=b.grp_lvl and a.tier=b.tier and a.hosp_id=b.hosp_id and a.class=b.class and a.prod_lvl=b.prod_lvl and a.molecule_code=b.molecule_code and a.product_code=b.product_code 
	and a.package_code=b.package_code and case when a.manuf_code is null then '' else a.manuf_code end = case when b.manuf_code is null then '' else b.manuf_code end
inner join tblOutput_Hosp_TA_USD_MTH_Inline c
on a.mkt=c.mkt and a.geo=c.geo AND a.Geo_Lvl = c.Geo_Lvl and a.grp_lvl=c.grp_lvl and a.tier=c.tier and a.hosp_id=c.hosp_id and a.class=c.class and a.prod_lvl=c.prod_lvl and a.molecule_code=c.molecule_code and a.product_code=c.product_code 
	and a.package_code=c.package_code and case when a.manuf_code is null then '' else a.manuf_code end = case when c.manuf_code is null then '' else c.manuf_code end

go
--MAT:
IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_Hosp_TA_MAT_Inline')
	DROP VIEW tblOutput_Hosp_TA_MAT_Inline
go
CREATE VIEW tblOutput_Hosp_TA_MAT_Inline
as
select 'MAT' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.grp_lvl,a.hosp_id,a.hosp_des_en,a.tier,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.molecule_name,a.molecule_code,
	a.product_name,a.product_code,a.package_name,a.package_code,a.manuf_name,a.manuf_code,a.mnc,a.datasource,a.[CPA_CODE(PHA_CODE)],
	a.UT_MAT_48,a.UT_MAT_47,a.UT_MAT_46,a.UT_MAT_45,a.UT_MAT_44,a.UT_MAT_43,a.UT_MAT_42,a.UT_MAT_41,a.UT_MAT_40,a.UT_MAT_39,a.UT_MAT_38,a.UT_MAT_37,
	a.UT_MAT_36,a.UT_MAT_35,a.UT_MAT_34,a.UT_MAT_33,a.UT_MAT_32,a.UT_MAT_31,a.UT_MAT_30,a.UT_MAT_29,a.UT_MAT_28,a.UT_MAT_27,a.UT_MAT_26,a.UT_MAT_25,
	a.UT_MAT_24,a.UT_MAT_23,a.UT_MAT_22,a.UT_MAT_21,a.UT_MAT_20,a.UT_MAT_19,a.UT_MAT_18,a.UT_MAT_17,a.UT_MAT_16,a.UT_MAT_15,a.UT_MAT_14,a.UT_MAT_13,
	a.UT_MAT_12,a.UT_MAT_11,a.UT_MAT_10,a.UT_MAT_9,a.UT_MAT_8,a.UT_MAT_7,a.UT_MAT_6,a.UT_MAT_5,a.UT_MAT_4,a.UT_MAT_3,a.UT_MAT_2,a.UT_MAT_1,
	a.UT_MAT_SHR_48,a.UT_MAT_SHR_47,a.UT_MAT_SHR_46,a.UT_MAT_SHR_45,a.UT_MAT_SHR_44,a.UT_MAT_SHR_43,a.UT_MAT_SHR_42,a.UT_MAT_SHR_41,a.UT_MAT_SHR_40,a.UT_MAT_SHR_39,a.UT_MAT_SHR_38,a.UT_MAT_SHR_37,
	a.UT_MAT_SHR_36,a.UT_MAT_SHR_35,a.UT_MAT_SHR_34,a.UT_MAT_SHR_33,a.UT_MAT_SHR_32,a.UT_MAT_SHR_31,a.UT_MAT_SHR_30,a.UT_MAT_SHR_29,a.UT_MAT_SHR_28,a.UT_MAT_SHR_27,a.UT_MAT_SHR_26,a.UT_MAT_SHR_25,
	a.UT_MAT_SHR_24,a.UT_MAT_SHR_23,a.UT_MAT_SHR_22,a.UT_MAT_SHR_21,a.UT_MAT_SHR_20,a.UT_MAT_SHR_19,a.UT_MAT_SHR_18,a.UT_MAT_SHR_17,a.UT_MAT_SHR_16,a.UT_MAT_SHR_15,a.UT_MAT_SHR_14,a.UT_MAT_SHR_13,
	a.UT_MAT_SHR_12,a.UT_MAT_SHR_11,a.UT_MAT_SHR_10,a.UT_MAT_SHR_9,a.UT_MAT_SHR_8,a.UT_MAT_SHR_7,a.UT_MAT_SHR_6,a.UT_MAT_SHR_5,a.UT_MAT_SHR_4,a.UT_MAT_SHR_3,a.UT_MAT_SHR_2,a.UT_MAT_SHR_1,
	b.VR_MAT_48,b.VR_MAT_47,b.VR_MAT_46,b.VR_MAT_45,b.VR_MAT_44,b.VR_MAT_43,b.VR_MAT_42,b.VR_MAT_41,b.VR_MAT_40,b.VR_MAT_39,b.VR_MAT_38,b.VR_MAT_37,
	b.VR_MAT_36,b.VR_MAT_35,b.VR_MAT_34,b.VR_MAT_33,b.VR_MAT_32,b.VR_MAT_31,b.VR_MAT_30,b.VR_MAT_29,b.VR_MAT_28,b.VR_MAT_27,b.VR_MAT_26,b.VR_MAT_25,
	b.VR_MAT_24,b.VR_MAT_23,b.VR_MAT_22,b.VR_MAT_21,b.VR_MAT_20,b.VR_MAT_19,b.VR_MAT_18,b.VR_MAT_17,b.VR_MAT_16,b.VR_MAT_15,b.VR_MAT_14,b.VR_MAT_13,
	b.VR_MAT_12,b.VR_MAT_11,b.VR_MAT_10,b.VR_MAT_9,b.VR_MAT_8,b.VR_MAT_7,b.VR_MAT_6,b.VR_MAT_5,b.VR_MAT_4,b.VR_MAT_3,b.VR_MAT_2,b.VR_MAT_1,
	b.VR_MAT_SHR_48,b.VR_MAT_SHR_47,b.VR_MAT_SHR_46,b.VR_MAT_SHR_45,b.VR_MAT_SHR_44,b.VR_MAT_SHR_43,b.VR_MAT_SHR_42,b.VR_MAT_SHR_41,b.VR_MAT_SHR_40,b.VR_MAT_SHR_39,b.VR_MAT_SHR_38,b.VR_MAT_SHR_37,
	b.VR_MAT_SHR_36,b.VR_MAT_SHR_35,b.VR_MAT_SHR_34,b.VR_MAT_SHR_33,b.VR_MAT_SHR_32,b.VR_MAT_SHR_31,b.VR_MAT_SHR_30,b.VR_MAT_SHR_29,b.VR_MAT_SHR_28,b.VR_MAT_SHR_27,b.VR_MAT_SHR_26,b.VR_MAT_SHR_25,
	b.VR_MAT_SHR_24,b.VR_MAT_SHR_23,b.VR_MAT_SHR_22,b.VR_MAT_SHR_21,b.VR_MAT_SHR_20,b.VR_MAT_SHR_19,b.VR_MAT_SHR_18,b.VR_MAT_SHR_17,b.VR_MAT_SHR_16,b.VR_MAT_SHR_15,b.VR_MAT_SHR_14,b.VR_MAT_SHR_13,
	b.VR_MAT_SHR_12,b.VR_MAT_SHR_11,b.VR_MAT_SHR_10,b.VR_MAT_SHR_9,b.VR_MAT_SHR_8,b.VR_MAT_SHR_7,b.VR_MAT_SHR_6,b.VR_MAT_SHR_5,b.VR_MAT_SHR_4,b.VR_MAT_SHR_3,b.VR_MAT_SHR_2,b.VR_MAT_SHR_1,
	c.VU_MAT_48,c.VU_MAT_47,c.VU_MAT_46,c.VU_MAT_45,c.VU_MAT_44,c.VU_MAT_43,c.VU_MAT_42,c.VU_MAT_41,c.VU_MAT_40,c.VU_MAT_39,c.VU_MAT_38,c.VU_MAT_37,
	c.VU_MAT_36,c.VU_MAT_35,c.VU_MAT_34,c.VU_MAT_33,c.VU_MAT_32,c.VU_MAT_31,c.VU_MAT_30,c.VU_MAT_29,c.VU_MAT_28,c.VU_MAT_27,c.VU_MAT_26,c.VU_MAT_25,
	c.VU_MAT_24,c.VU_MAT_23,c.VU_MAT_22,c.VU_MAT_21,c.VU_MAT_20,c.VU_MAT_19,c.VU_MAT_18,c.VU_MAT_17,c.VU_MAT_16,c.VU_MAT_15,c.VU_MAT_14,c.VU_MAT_13,
	c.VU_MAT_12,c.VU_MAT_11,c.VU_MAT_10,c.VU_MAT_9,c.VU_MAT_8,c.VU_MAT_7,c.VU_MAT_6,c.VU_MAT_5,c.VU_MAT_4,c.VU_MAT_3,c.VU_MAT_2,c.VU_MAT_1,
	c.VU_MAT_SHR_48,c.VU_MAT_SHR_47,c.VU_MAT_SHR_46,c.VU_MAT_SHR_45,c.VU_MAT_SHR_44,c.VU_MAT_SHR_43,c.VU_MAT_SHR_42,c.VU_MAT_SHR_41,c.VU_MAT_SHR_40,c.VU_MAT_SHR_39,c.VU_MAT_SHR_38,c.VU_MAT_SHR_37,
	c.VU_MAT_SHR_36,c.VU_MAT_SHR_35,c.VU_MAT_SHR_34,c.VU_MAT_SHR_33,c.VU_MAT_SHR_32,c.VU_MAT_SHR_31,c.VU_MAT_SHR_30,c.VU_MAT_SHR_29,c.VU_MAT_SHR_28,c.VU_MAT_SHR_27,c.VU_MAT_SHR_26,c.VU_MAT_SHR_25,
	c.VU_MAT_SHR_24,c.VU_MAT_SHR_23,c.VU_MAT_SHR_22,c.VU_MAT_SHR_21,c.VU_MAT_SHR_20,c.VU_MAT_SHR_19,c.VU_MAT_SHR_18,c.VU_MAT_SHR_17,c.VU_MAT_SHR_16,c.VU_MAT_SHR_15,c.VU_MAT_SHR_14,c.VU_MAT_SHR_13,
	c.VU_MAT_SHR_12,c.VU_MAT_SHR_11,c.VU_MAT_SHR_10,c.VU_MAT_SHR_9,c.VU_MAT_SHR_8,c.VU_MAT_SHR_7,c.VU_MAT_SHR_6,c.VU_MAT_SHR_5,c.VU_MAT_SHR_4,c.VU_MAT_SHR_3,c.VU_MAT_SHR_2,c.VU_MAT_SHR_1
from tblOutput_Hosp_TA_UNT_MAT_Inline a
inner join tblOutput_Hosp_TA_RMB_MAT_Inline b
on a.mkt=b.mkt and a.geo=b.geo AND a.Geo_Lvl = b.Geo_Lvl and a.grp_lvl=b.grp_lvl and a.tier=b.tier and a.hosp_id=b.hosp_id and a.class=b.class and a.prod_lvl=b.prod_lvl and a.molecule_code=b.molecule_code and a.product_code=b.product_code 
	and a.package_code=b.package_code and case when a.manuf_code is null then '' else a.manuf_code end = case when b.manuf_code is null then '' else b.manuf_code end
inner join tblOutput_Hosp_TA_USD_MAT_Inline c
on a.mkt=c.mkt and a.geo=c.geo AND a.Geo_Lvl = c.Geo_Lvl and a.grp_lvl=c.grp_lvl and a.tier=c.tier and a.hosp_id=c.hosp_id and a.class=c.class and a.prod_lvl=c.prod_lvl and a.molecule_code=c.molecule_code and a.product_code=c.product_code 
	and a.package_code=c.package_code and case when a.manuf_code is null then '' else a.manuf_code end = case when c.manuf_code is null then '' else c.manuf_code end

GO

--MQT:
IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_Hosp_TA_MQT_Inline')
DROP VIEW tblOutput_Hosp_TA_MQT_Inline
go
CREATE VIEW tblOutput_Hosp_TA_MQT_Inline
as
select 'MQT' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.grp_lvl,a.hosp_id,a.hosp_des_en,a.tier,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.molecule_name,a.molecule_code,
	a.product_name,a.product_code,a.package_name,a.package_code,a.manuf_name,a.manuf_code,a.mnc,a.datasource,a.[CPA_CODE(PHA_CODE)],
	a.UT_MQT_48,a.UT_MQT_47,a.UT_MQT_46,a.UT_MQT_45,a.UT_MQT_44,a.UT_MQT_43,a.UT_MQT_42,a.UT_MQT_41,a.UT_MQT_40,a.UT_MQT_39,a.UT_MQT_38,a.UT_MQT_37,
	a.UT_MQT_36,a.UT_MQT_35,a.UT_MQT_34,a.UT_MQT_33,a.UT_MQT_32,a.UT_MQT_31,a.UT_MQT_30,a.UT_MQT_29,a.UT_MQT_28,a.UT_MQT_27,a.UT_MQT_26,a.UT_MQT_25,
	a.UT_MQT_24,a.UT_MQT_23,a.UT_MQT_22,a.UT_MQT_21,a.UT_MQT_20,a.UT_MQT_19,a.UT_MQT_18,a.UT_MQT_17,a.UT_MQT_16,a.UT_MQT_15,a.UT_MQT_14,a.UT_MQT_13,
	a.UT_MQT_12,a.UT_MQT_11,a.UT_MQT_10,a.UT_MQT_9,a.UT_MQT_8,a.UT_MQT_7,a.UT_MQT_6,a.UT_MQT_5,a.UT_MQT_4,a.UT_MQT_3,a.UT_MQT_2,a.UT_MQT_1,
	a.UT_MQT_SHR_48,a.UT_MQT_SHR_47,a.UT_MQT_SHR_46,a.UT_MQT_SHR_45,a.UT_MQT_SHR_44,a.UT_MQT_SHR_43,a.UT_MQT_SHR_42,a.UT_MQT_SHR_41,a.UT_MQT_SHR_40,a.UT_MQT_SHR_39,a.UT_MQT_SHR_38,a.UT_MQT_SHR_37,
	a.UT_MQT_SHR_36,a.UT_MQT_SHR_35,a.UT_MQT_SHR_34,a.UT_MQT_SHR_33,a.UT_MQT_SHR_32,a.UT_MQT_SHR_31,a.UT_MQT_SHR_30,a.UT_MQT_SHR_29,a.UT_MQT_SHR_28,a.UT_MQT_SHR_27,a.UT_MQT_SHR_26,a.UT_MQT_SHR_25,
	a.UT_MQT_SHR_24,a.UT_MQT_SHR_23,a.UT_MQT_SHR_22,a.UT_MQT_SHR_21,a.UT_MQT_SHR_20,a.UT_MQT_SHR_19,a.UT_MQT_SHR_18,a.UT_MQT_SHR_17,a.UT_MQT_SHR_16,a.UT_MQT_SHR_15,a.UT_MQT_SHR_14,a.UT_MQT_SHR_13,
	a.UT_MQT_SHR_12,a.UT_MQT_SHR_11,a.UT_MQT_SHR_10,a.UT_MQT_SHR_9,a.UT_MQT_SHR_8,a.UT_MQT_SHR_7,a.UT_MQT_SHR_6,a.UT_MQT_SHR_5,a.UT_MQT_SHR_4,a.UT_MQT_SHR_3,a.UT_MQT_SHR_2,a.UT_MQT_SHR_1,
	b.VR_MQT_48,b.VR_MQT_47,b.VR_MQT_46,b.VR_MQT_45,b.VR_MQT_44,b.VR_MQT_43,b.VR_MQT_42,b.VR_MQT_41,b.VR_MQT_40,b.VR_MQT_39,b.VR_MQT_38,b.VR_MQT_37,
	b.VR_MQT_36,b.VR_MQT_35,b.VR_MQT_34,b.VR_MQT_33,b.VR_MQT_32,b.VR_MQT_31,b.VR_MQT_30,b.VR_MQT_29,b.VR_MQT_28,b.VR_MQT_27,b.VR_MQT_26,b.VR_MQT_25,
	b.VR_MQT_24,b.VR_MQT_23,b.VR_MQT_22,b.VR_MQT_21,b.VR_MQT_20,b.VR_MQT_19,b.VR_MQT_18,b.VR_MQT_17,b.VR_MQT_16,b.VR_MQT_15,b.VR_MQT_14,b.VR_MQT_13,
	b.VR_MQT_12,b.VR_MQT_11,b.VR_MQT_10,b.VR_MQT_9,b.VR_MQT_8,b.VR_MQT_7,b.VR_MQT_6,b.VR_MQT_5,b.VR_MQT_4,b.VR_MQT_3,b.VR_MQT_2,b.VR_MQT_1,
	b.VR_MQT_SHR_48,b.VR_MQT_SHR_47,b.VR_MQT_SHR_46,b.VR_MQT_SHR_45,b.VR_MQT_SHR_44,b.VR_MQT_SHR_43,b.VR_MQT_SHR_42,b.VR_MQT_SHR_41,b.VR_MQT_SHR_40,b.VR_MQT_SHR_39,b.VR_MQT_SHR_38,b.VR_MQT_SHR_37,
	b.VR_MQT_SHR_36,b.VR_MQT_SHR_35,b.VR_MQT_SHR_34,b.VR_MQT_SHR_33,b.VR_MQT_SHR_32,b.VR_MQT_SHR_31,b.VR_MQT_SHR_30,b.VR_MQT_SHR_29,b.VR_MQT_SHR_28,b.VR_MQT_SHR_27,b.VR_MQT_SHR_26,b.VR_MQT_SHR_25,
	b.VR_MQT_SHR_24,b.VR_MQT_SHR_23,b.VR_MQT_SHR_22,b.VR_MQT_SHR_21,b.VR_MQT_SHR_20,b.VR_MQT_SHR_19,b.VR_MQT_SHR_18,b.VR_MQT_SHR_17,b.VR_MQT_SHR_16,b.VR_MQT_SHR_15,b.VR_MQT_SHR_14,b.VR_MQT_SHR_13,
	b.VR_MQT_SHR_12,b.VR_MQT_SHR_11,b.VR_MQT_SHR_10,b.VR_MQT_SHR_9,b.VR_MQT_SHR_8,b.VR_MQT_SHR_7,b.VR_MQT_SHR_6,b.VR_MQT_SHR_5,b.VR_MQT_SHR_4,b.VR_MQT_SHR_3,b.VR_MQT_SHR_2,b.VR_MQT_SHR_1,
	c.VU_MQT_48,c.VU_MQT_47,c.VU_MQT_46,c.VU_MQT_45,c.VU_MQT_44,c.VU_MQT_43,c.VU_MQT_42,c.VU_MQT_41,c.VU_MQT_40,c.VU_MQT_39,c.VU_MQT_38,c.VU_MQT_37,
	c.VU_MQT_36,c.VU_MQT_35,c.VU_MQT_34,c.VU_MQT_33,c.VU_MQT_32,c.VU_MQT_31,c.VU_MQT_30,c.VU_MQT_29,c.VU_MQT_28,c.VU_MQT_27,c.VU_MQT_26,c.VU_MQT_25,
	c.VU_MQT_24,c.VU_MQT_23,c.VU_MQT_22,c.VU_MQT_21,c.VU_MQT_20,c.VU_MQT_19,c.VU_MQT_18,c.VU_MQT_17,c.VU_MQT_16,c.VU_MQT_15,c.VU_MQT_14,c.VU_MQT_13,
	c.VU_MQT_12,c.VU_MQT_11,c.VU_MQT_10,c.VU_MQT_9,c.VU_MQT_8,c.VU_MQT_7,c.VU_MQT_6,c.VU_MQT_5,c.VU_MQT_4,c.VU_MQT_3,c.VU_MQT_2,c.VU_MQT_1,
	c.VU_MQT_SHR_48,c.VU_MQT_SHR_47,c.VU_MQT_SHR_46,c.VU_MQT_SHR_45,c.VU_MQT_SHR_44,c.VU_MQT_SHR_43,c.VU_MQT_SHR_42,c.VU_MQT_SHR_41,c.VU_MQT_SHR_40,c.VU_MQT_SHR_39,c.VU_MQT_SHR_38,c.VU_MQT_SHR_37,
	c.VU_MQT_SHR_36,c.VU_MQT_SHR_35,c.VU_MQT_SHR_34,c.VU_MQT_SHR_33,c.VU_MQT_SHR_32,c.VU_MQT_SHR_31,c.VU_MQT_SHR_30,c.VU_MQT_SHR_29,c.VU_MQT_SHR_28,c.VU_MQT_SHR_27,c.VU_MQT_SHR_26,c.VU_MQT_SHR_25,
	c.VU_MQT_SHR_24,c.VU_MQT_SHR_23,c.VU_MQT_SHR_22,c.VU_MQT_SHR_21,c.VU_MQT_SHR_20,c.VU_MQT_SHR_19,c.VU_MQT_SHR_18,c.VU_MQT_SHR_17,c.VU_MQT_SHR_16,c.VU_MQT_SHR_15,c.VU_MQT_SHR_14,c.VU_MQT_SHR_13,
	c.VU_MQT_SHR_12,c.VU_MQT_SHR_11,c.VU_MQT_SHR_10,c.VU_MQT_SHR_9,c.VU_MQT_SHR_8,c.VU_MQT_SHR_7,c.VU_MQT_SHR_6,c.VU_MQT_SHR_5,c.VU_MQT_SHR_4,c.VU_MQT_SHR_3,c.VU_MQT_SHR_2,c.VU_MQT_SHR_1
from tblOutput_Hosp_TA_UNT_MQT_Inline a
inner join tblOutput_Hosp_TA_RMB_MQT_Inline b
on a.mkt=b.mkt and a.geo=b.geo AND a.Geo_Lvl = b.Geo_Lvl and a.grp_lvl=b.grp_lvl and a.tier=b.tier and a.hosp_id=b.hosp_id and a.class=b.class and a.prod_lvl=b.prod_lvl and a.molecule_code=b.molecule_code and a.product_code=b.product_code 
	and a.package_code=b.package_code and case when a.manuf_code is null then '' else a.manuf_code end = case when b.manuf_code is null then '' else b.manuf_code end
inner join tblOutput_Hosp_TA_USD_MQT_Inline c
on a.mkt=c.mkt and a.geo=c.geo AND a.Geo_Lvl = c.Geo_Lvl and a.grp_lvl=c.grp_lvl and a.tier=c.tier and a.hosp_id=c.hosp_id and a.class=c.class and a.prod_lvl=c.prod_lvl and a.molecule_code=c.molecule_code and a.product_code=c.product_code 
	and a.package_code=c.package_code and case when a.manuf_code is null then '' else a.manuf_code end = case when c.manuf_code is null then '' else c.manuf_code end

GO


--YTD:
IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_Hosp_TA_YTD_Inline')
DROP VIEW tblOutput_Hosp_TA_YTD_Inline
go
CREATE VIEW tblOutput_Hosp_TA_YTD_Inline
as
select 'YTD' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.grp_lvl,a.hosp_id,a.hosp_des_en,a.tier,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.molecule_name,a.molecule_code,
	a.product_name,a.product_code,a.package_name,a.package_code,a.manuf_name,a.manuf_code,a.mnc,a.datasource,a.[CPA_CODE(PHA_CODE)],
	a.UT_YTD_48,a.UT_YTD_47,a.UT_YTD_46,a.UT_YTD_45,a.UT_YTD_44,a.UT_YTD_43,a.UT_YTD_42,a.UT_YTD_41,a.UT_YTD_40,a.UT_YTD_39,a.UT_YTD_38,a.UT_YTD_37,
	a.UT_YTD_36,a.UT_YTD_35,a.UT_YTD_34,a.UT_YTD_33,a.UT_YTD_32,a.UT_YTD_31,a.UT_YTD_30,a.UT_YTD_29,a.UT_YTD_28,a.UT_YTD_27,a.UT_YTD_26,a.UT_YTD_25,
	a.UT_YTD_24,a.UT_YTD_23,a.UT_YTD_22,a.UT_YTD_21,a.UT_YTD_20,a.UT_YTD_19,a.UT_YTD_18,a.UT_YTD_17,a.UT_YTD_16,a.UT_YTD_15,a.UT_YTD_14,a.UT_YTD_13,
	a.UT_YTD_12,a.UT_YTD_11,a.UT_YTD_10,a.UT_YTD_9,a.UT_YTD_8,a.UT_YTD_7,a.UT_YTD_6,a.UT_YTD_5,a.UT_YTD_4,a.UT_YTD_3,a.UT_YTD_2,a.UT_YTD_1,
	a.UT_YTD_SHR_48,a.UT_YTD_SHR_47,a.UT_YTD_SHR_46,a.UT_YTD_SHR_45,a.UT_YTD_SHR_44,a.UT_YTD_SHR_43,a.UT_YTD_SHR_42,a.UT_YTD_SHR_41,a.UT_YTD_SHR_40,a.UT_YTD_SHR_39,a.UT_YTD_SHR_38,a.UT_YTD_SHR_37,
	a.UT_YTD_SHR_36,a.UT_YTD_SHR_35,a.UT_YTD_SHR_34,a.UT_YTD_SHR_33,a.UT_YTD_SHR_32,a.UT_YTD_SHR_31,a.UT_YTD_SHR_30,a.UT_YTD_SHR_29,a.UT_YTD_SHR_28,a.UT_YTD_SHR_27,a.UT_YTD_SHR_26,a.UT_YTD_SHR_25,
	a.UT_YTD_SHR_24,a.UT_YTD_SHR_23,a.UT_YTD_SHR_22,a.UT_YTD_SHR_21,a.UT_YTD_SHR_20,a.UT_YTD_SHR_19,a.UT_YTD_SHR_18,a.UT_YTD_SHR_17,a.UT_YTD_SHR_16,a.UT_YTD_SHR_15,a.UT_YTD_SHR_14,a.UT_YTD_SHR_13,
	a.UT_YTD_SHR_12,a.UT_YTD_SHR_11,a.UT_YTD_SHR_10,a.UT_YTD_SHR_9,a.UT_YTD_SHR_8,a.UT_YTD_SHR_7,a.UT_YTD_SHR_6,a.UT_YTD_SHR_5,a.UT_YTD_SHR_4,a.UT_YTD_SHR_3,a.UT_YTD_SHR_2,a.UT_YTD_SHR_1,
	b.VR_YTD_48,b.VR_YTD_47,b.VR_YTD_46,b.VR_YTD_45,b.VR_YTD_44,b.VR_YTD_43,b.VR_YTD_42,b.VR_YTD_41,b.VR_YTD_40,b.VR_YTD_39,b.VR_YTD_38,b.VR_YTD_37,
	b.VR_YTD_36,b.VR_YTD_35,b.VR_YTD_34,b.VR_YTD_33,b.VR_YTD_32,b.VR_YTD_31,b.VR_YTD_30,b.VR_YTD_29,b.VR_YTD_28,b.VR_YTD_27,b.VR_YTD_26,b.VR_YTD_25,
	b.VR_YTD_24,b.VR_YTD_23,b.VR_YTD_22,b.VR_YTD_21,b.VR_YTD_20,b.VR_YTD_19,b.VR_YTD_18,b.VR_YTD_17,b.VR_YTD_16,b.VR_YTD_15,b.VR_YTD_14,b.VR_YTD_13,
	b.VR_YTD_12,b.VR_YTD_11,b.VR_YTD_10,b.VR_YTD_9,b.VR_YTD_8,b.VR_YTD_7,b.VR_YTD_6,b.VR_YTD_5,b.VR_YTD_4,b.VR_YTD_3,b.VR_YTD_2,b.VR_YTD_1,
	b.VR_YTD_SHR_48,b.VR_YTD_SHR_47,b.VR_YTD_SHR_46,b.VR_YTD_SHR_45,b.VR_YTD_SHR_44,b.VR_YTD_SHR_43,b.VR_YTD_SHR_42,b.VR_YTD_SHR_41,b.VR_YTD_SHR_40,b.VR_YTD_SHR_39,b.VR_YTD_SHR_38,b.VR_YTD_SHR_37,
	b.VR_YTD_SHR_36,b.VR_YTD_SHR_35,b.VR_YTD_SHR_34,b.VR_YTD_SHR_33,b.VR_YTD_SHR_32,b.VR_YTD_SHR_31,b.VR_YTD_SHR_30,b.VR_YTD_SHR_29,b.VR_YTD_SHR_28,b.VR_YTD_SHR_27,b.VR_YTD_SHR_26,b.VR_YTD_SHR_25,
	b.VR_YTD_SHR_24,b.VR_YTD_SHR_23,b.VR_YTD_SHR_22,b.VR_YTD_SHR_21,b.VR_YTD_SHR_20,b.VR_YTD_SHR_19,b.VR_YTD_SHR_18,b.VR_YTD_SHR_17,b.VR_YTD_SHR_16,b.VR_YTD_SHR_15,b.VR_YTD_SHR_14,b.VR_YTD_SHR_13,
	b.VR_YTD_SHR_12,b.VR_YTD_SHR_11,b.VR_YTD_SHR_10,b.VR_YTD_SHR_9,b.VR_YTD_SHR_8,b.VR_YTD_SHR_7,b.VR_YTD_SHR_6,b.VR_YTD_SHR_5,b.VR_YTD_SHR_4,b.VR_YTD_SHR_3,b.VR_YTD_SHR_2,b.VR_YTD_SHR_1,
	c.VU_YTD_48,c.VU_YTD_47,c.VU_YTD_46,c.VU_YTD_45,c.VU_YTD_44,c.VU_YTD_43,c.VU_YTD_42,c.VU_YTD_41,c.VU_YTD_40,c.VU_YTD_39,c.VU_YTD_38,c.VU_YTD_37,
	c.VU_YTD_36,c.VU_YTD_35,c.VU_YTD_34,c.VU_YTD_33,c.VU_YTD_32,c.VU_YTD_31,c.VU_YTD_30,c.VU_YTD_29,c.VU_YTD_28,c.VU_YTD_27,c.VU_YTD_26,c.VU_YTD_25,
	c.VU_YTD_24,c.VU_YTD_23,c.VU_YTD_22,c.VU_YTD_21,c.VU_YTD_20,c.VU_YTD_19,c.VU_YTD_18,c.VU_YTD_17,c.VU_YTD_16,c.VU_YTD_15,c.VU_YTD_14,c.VU_YTD_13,
	c.VU_YTD_12,c.VU_YTD_11,c.VU_YTD_10,c.VU_YTD_9,c.VU_YTD_8,c.VU_YTD_7,c.VU_YTD_6,c.VU_YTD_5,c.VU_YTD_4,c.VU_YTD_3,c.VU_YTD_2,c.VU_YTD_1,
	c.VU_YTD_SHR_48,c.VU_YTD_SHR_47,c.VU_YTD_SHR_46,c.VU_YTD_SHR_45,c.VU_YTD_SHR_44,c.VU_YTD_SHR_43,c.VU_YTD_SHR_42,c.VU_YTD_SHR_41,c.VU_YTD_SHR_40,c.VU_YTD_SHR_39,c.VU_YTD_SHR_38,c.VU_YTD_SHR_37,
	c.VU_YTD_SHR_36,c.VU_YTD_SHR_35,c.VU_YTD_SHR_34,c.VU_YTD_SHR_33,c.VU_YTD_SHR_32,c.VU_YTD_SHR_31,c.VU_YTD_SHR_30,c.VU_YTD_SHR_29,c.VU_YTD_SHR_28,c.VU_YTD_SHR_27,c.VU_YTD_SHR_26,c.VU_YTD_SHR_25,
	c.VU_YTD_SHR_24,c.VU_YTD_SHR_23,c.VU_YTD_SHR_22,c.VU_YTD_SHR_21,c.VU_YTD_SHR_20,c.VU_YTD_SHR_19,c.VU_YTD_SHR_18,c.VU_YTD_SHR_17,c.VU_YTD_SHR_16,c.VU_YTD_SHR_15,c.VU_YTD_SHR_14,c.VU_YTD_SHR_13,
	c.VU_YTD_SHR_12,c.VU_YTD_SHR_11,c.VU_YTD_SHR_10,c.VU_YTD_SHR_9,c.VU_YTD_SHR_8,c.VU_YTD_SHR_7,c.VU_YTD_SHR_6,c.VU_YTD_SHR_5,c.VU_YTD_SHR_4,c.VU_YTD_SHR_3,c.VU_YTD_SHR_2,c.VU_YTD_SHR_1
from tblOutput_Hosp_TA_UNT_YTD_Inline a
inner join tblOutput_Hosp_TA_RMB_YTD_Inline b
on a.mkt=b.mkt and a.geo=b.geo AND a.Geo_Lvl = b.Geo_Lvl and a.grp_lvl=b.grp_lvl and a.tier=b.tier and a.hosp_id=b.hosp_id and a.class=b.class and a.prod_lvl=b.prod_lvl and a.molecule_code=b.molecule_code and a.product_code=b.product_code 
	and a.package_code=b.package_code and case when a.manuf_code is null then '' else a.manuf_code end = case when b.manuf_code is null then '' else b.manuf_code end
inner join tblOutput_Hosp_TA_USD_YTD_Inline c
on a.mkt=c.mkt and a.geo=c.geo AND a.Geo_Lvl = c.Geo_Lvl and a.grp_lvl=c.grp_lvl and a.tier=c.tier and a.hosp_id=c.hosp_id and a.class=c.class and a.prod_lvl=c.prod_lvl and a.molecule_code=c.molecule_code and a.product_code=c.product_code 
	and a.package_code=c.package_code and case when a.manuf_code is null then '' else a.manuf_code end = case when c.manuf_code is null then '' else c.manuf_code end

GO

exec BMSCNProc2.dbo.sp_Log_Event 'Output','QT_CPA_Inline','99_Output_Hosp_Inline.sql','End',null,null

