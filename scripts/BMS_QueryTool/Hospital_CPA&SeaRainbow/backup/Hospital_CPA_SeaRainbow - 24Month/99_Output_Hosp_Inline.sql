use BMSChinaQueryToolNew
go

print '--tblHospitalList'
IF OBJECT_ID(N'tblHospitalList',N'U') IS NOT NULL
	DROP TABLE tblHospitalList
GO
SELECT * INTO tblHospitalList FROM db2.BMSCNProc2.dbo.tblHospitalList
go

print '--tblCityListForHospital'
if object_id(N'tblCityListForHospital',N'U') is not null
	drop table tblCityListForHospital
go
select * into tblCityListForHospital
from DB2.BMSCNProc2.dbo.tblCityListForHospital
go

print '--tblQueryToolDriverHosp'
if object_id(N'tblQueryToolDriverHosp',N'U') is not null
	drop table tblQueryToolDriverHosp
go
select * into tblQueryToolDriverHosp
from db2.BMSCNProc2.dbo.tblQueryToolDriverHosp
go

print '--tblOutput_Hosp_TA_RMB_MAT_Inline'
if object_id(N'tblOutput_Hosp_TA_RMB_MAT_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_RMB_MAT_Inline
go
select * into tblOutput_Hosp_TA_RMB_MAT_Inline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_RMB_MAT_Inline
go

print '--tblOutput_Hosp_TA_RMB_MQT_Inline'
if object_id(N'tblOutput_Hosp_TA_RMB_MQT_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_RMB_MQT_Inline
go
select * into tblOutput_Hosp_TA_RMB_MQT_Inline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_RMB_MQT_Inline
go

print '--tblOutput_Hosp_TA_RMB_MTH_Inline'
if object_id(N'tblOutput_Hosp_TA_RMB_MTH_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_RMB_MTH_Inline
go
select * into tblOutput_Hosp_TA_RMB_MTH_Inline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_RMB_MTH_Inline
go

print '--tblOutput_Hosp_TA_UNT_MAT_Inline'
if object_id(N'tblOutput_Hosp_TA_UNT_MAT_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_UNT_MAT_Inline
go
select * into tblOutput_Hosp_TA_UNT_MAT_Inline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_UNT_MAT_Inline
go

print '--tblOutput_Hosp_TA_UNT_MQT_Inline'
if object_id(N'tblOutput_Hosp_TA_UNT_MQT_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_UNT_MQT_Inline
go
select * into tblOutput_Hosp_TA_UNT_MQT_Inline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_UNT_MQT_Inline
go

print '--tblOutput_Hosp_TA_UNT_MTH_Inline'
if object_id(N'tblOutput_Hosp_TA_UNT_MTH_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_UNT_MTH_Inline
go

select * into tblOutput_Hosp_TA_UNT_MTH_Inline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_UNT_MTH_Inline
go

print '--tblOutput_Hosp_TA_USD_MAT_Inline'
if object_id(N'tblOutput_Hosp_TA_USD_MAT_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_USD_MAT_Inline
go

select * into tblOutput_Hosp_TA_USD_MAT_Inline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_USD_MAT_Inline
go


print '--tblOutput_Hosp_TA_USD_MQT_Inline'
if object_id(N'tblOutput_Hosp_TA_USD_MQT_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_USD_MQT_Inline
go

select * into tblOutput_Hosp_TA_USD_MQT_Inline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_USD_MQT_Inline
go


print '--tblOutput_Hosp_TA_USD_MTH_Inline'
if object_id(N'tblOutput_Hosp_TA_USD_MTH_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_USD_MTH_Inline
go
select * into tblOutput_Hosp_TA_USD_MTH_Inline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_USD_MTH_Inline
go



/*

Hi Jay,

下面是Query Tool\Hospitla 需要更新的表，请上传，谢谢！
 
OutputGeo
tblDataPeriod
tblDepartmentList
tblGeoList
tblHospitalList
tblCityListForHospital
tblQueryToolDriverHosp
tblOutput_Hosp_TA_RMB_MAT_Inline
tblOutput_Hosp_TA_RMB_MQT_Inline
tblOutput_Hosp_TA_RMB_MTH_Inline
tblOutput_Hosp_TA_UNT_MAT_Inline
tblOutput_Hosp_TA_UNT_MQT_Inline
tblOutput_Hosp_TA_UNT_MTH_Inline
tblOutput_Hosp_TA_USD_MAT_Inline
tblOutput_Hosp_TA_USD_MQT_Inline
tblOutput_Hosp_TA_USD_MTH_Inline

*/