use BMSChinaQueryToolNew
go


print '--tblQueryTool_IMS_ATC_List'
IF OBJECT_ID(N'tblQueryTool_IMS_ATC_List',N'U') IS NOT NULL
	DROP TABLE tblQueryTool_IMS_ATC_List
GO
SELECT * INTO tblQueryTool_IMS_ATC_List FROM db2.BMSCNProc2.dbo.tblQueryTool_IMS_ATC_List
go

print '--tblQueryToolDriverIMS'
if object_id(N'tblQueryToolDriverIMS',N'U') is not null
	drop table tblQueryToolDriverIMS
go
select * into tblQueryToolDriverIMS
from db2.BMSCNProc2.dbo.tblQueryToolDriverIMS
go

print '--tblQueryToolDriverATC'
if object_id(N'tblQueryToolDriverATC',N'U') is not null
	drop table tblQueryToolDriverATC
go
select * into tblQueryToolDriverATC
from db2.BMSCNProc2.dbo.tblQueryToolDriverATC
go

print '--tblOutput_IMS_ATC_RMB_MAT'
if object_id(N'tblOutput_IMS_ATC_RMB_MAT',N'U') is not null
	drop table tblOutput_IMS_ATC_RMB_MAT
go
select * into tblOutput_IMS_ATC_RMB_MAT
from db2.BMSCNProc2.dbo.tblOutput_IMS_ATC_RMB_MAT
go

print '--tblOutput_IMS_ATC_RMB_MQT'
if object_id(N'tblOutput_IMS_ATC_RMB_MQT',N'U') is not null
	drop table tblOutput_IMS_ATC_RMB_MQT
go
select * into tblOutput_IMS_ATC_RMB_MQT
from db2.BMSCNProc2.dbo.tblOutput_IMS_ATC_RMB_MQT
go

print '--tblOutput_IMS_ATC_RMB_MTH'
if object_id(N'tblOutput_IMS_ATC_RMB_MTH',N'U') is not null
	drop table tblOutput_IMS_ATC_RMB_MTH
go
select * into tblOutput_IMS_ATC_RMB_MTH
from db2.BMSCNProc2.dbo.tblOutput_IMS_ATC_RMB_MTH
go

print '--tblOutput_IMS_ATC_UNT_MAT'
if object_id(N'tblOutput_IMS_ATC_UNT_MAT',N'U') is not null
	drop table tblOutput_IMS_ATC_UNT_MAT
go
select * into tblOutput_IMS_ATC_UNT_MAT
from db2.BMSCNProc2.dbo.tblOutput_IMS_ATC_UNT_MAT
go

print '--tblOutput_IMS_ATC_UNT_MQT'
if object_id(N'tblOutput_IMS_ATC_UNT_MQT',N'U') is not null
	drop table tblOutput_IMS_ATC_UNT_MQT
go
select * into tblOutput_IMS_ATC_UNT_MQT
from db2.BMSCNProc2.dbo.tblOutput_IMS_ATC_UNT_MQT
go

print '--tblOutput_IMS_ATC_UNT_MTH'
if object_id(N'tblOutput_IMS_ATC_UNT_MTH',N'U') is not null
	drop table tblOutput_IMS_ATC_UNT_MTH
go
select * into tblOutput_IMS_ATC_UNT_MTH
from db2.BMSCNProc2.dbo.tblOutput_IMS_ATC_UNT_MTH
go

print '--tblOutput_IMS_ATC_USD_MAT'
if object_id(N'tblOutput_IMS_ATC_USD_MAT',N'U') is not null
	drop table tblOutput_IMS_ATC_USD_MAT
go
select * into tblOutput_IMS_ATC_USD_MAT
from db2.BMSCNProc2.dbo.tblOutput_IMS_ATC_USD_MAT
go

print '--tblOutput_IMS_ATC_USD_MQT'
if object_id(N'tblOutput_IMS_ATC_USD_MQT',N'U') is not null
	drop table tblOutput_IMS_ATC_USD_MQT
go
select * into tblOutput_IMS_ATC_USD_MQT
from db2.BMSCNProc2.dbo.tblOutput_IMS_ATC_USD_MQT
go

print '--tblOutput_IMS_ATC_USD_MTH'
if object_id(N'tblOutput_IMS_ATC_USD_MTH',N'U') is not null
	drop table tblOutput_IMS_ATC_USD_MTH
go
select * into tblOutput_IMS_ATC_USD_MTH
from db2.BMSCNProc2.dbo.tblOutput_IMS_ATC_USD_MTH
go


print '--tblOutput_IMS_TA_RMB_MAT_Global'
if object_id(N'tblOutput_IMS_TA_RMB_MAT_Global',N'U') is not null
	drop table tblOutput_IMS_TA_RMB_MAT_Global
go
select * into tblOutput_IMS_TA_RMB_MAT_Global
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_RMB_MAT_Global
go

print '--tblOutput_IMS_TA_RMB_MAT_Inline'
if object_id(N'tblOutput_IMS_TA_RMB_MAT_Inline',N'U') is not null
	drop table tblOutput_IMS_TA_RMB_MAT_Inline
go
select * into tblOutput_IMS_TA_RMB_MAT_Inline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_RMB_MAT_Inline
go

print '--tblOutput_IMS_TA_Master_Inline_Mkt'
if object_id(N'tblOutput_IMS_TA_Master_Inline_Mkt',N'U') is not null
	drop table tblOutput_IMS_TA_Master_Inline_Mkt
go
select * into tblOutput_IMS_TA_Master_Inline_Mkt
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_Master_Inline_Mkt
go

print '--tblOutput_IMS_TA_RMB_MAT_Pipeline'
if object_id(N'tblOutput_IMS_TA_RMB_MAT_Pipeline',N'U') is not null
	drop table tblOutput_IMS_TA_RMB_MAT_Pipeline
go
select * into tblOutput_IMS_TA_RMB_MAT_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_RMB_MAT_Pipeline
go

print '--tblOutput_IMS_TA_RMB_MQT_Global'
if object_id(N'tblOutput_IMS_TA_RMB_MQT_Global',N'U') is not null
	drop table tblOutput_IMS_TA_RMB_MQT_Global
go
select * into tblOutput_IMS_TA_RMB_MQT_Global
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_RMB_MQT_Global
go

print '--tblOutput_IMS_TA_RMB_MQT_Inline'
if object_id(N'tblOutput_IMS_TA_RMB_MQT_Inline',N'U') is not null
	drop table tblOutput_IMS_TA_RMB_MQT_Inline
go
select * into tblOutput_IMS_TA_RMB_MQT_Inline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_RMB_MQT_Inline
go

print '--tblOutput_IMS_TA_RMB_MQT_Pipeline'
if object_id(N'tblOutput_IMS_TA_RMB_MQT_Pipeline',N'U') is not null
	drop table tblOutput_IMS_TA_RMB_MQT_Pipeline
go
select * into tblOutput_IMS_TA_RMB_MQT_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_RMB_MQT_Pipeline
go

print '--tblOutput_IMS_TA_RMB_MTH_Global'
if object_id(N'tblOutput_IMS_TA_RMB_MTH_Global',N'U') is not null
	drop table tblOutput_IMS_TA_RMB_MTH_Global
go
select * into tblOutput_IMS_TA_RMB_MTH_Global
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_RMB_MTH_Global
go

print '--tblOutput_IMS_TA_RMB_MTH_Inline'
if object_id(N'tblOutput_IMS_TA_RMB_MTH_Inline',N'U') is not null
	drop table tblOutput_IMS_TA_RMB_MTH_Inline
go
select * into tblOutput_IMS_TA_RMB_MTH_Inline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_RMB_MTH_Inline
go

print '--tblOutput_IMS_TA_RMB_MTH_Pipeline'
if object_id(N'tblOutput_IMS_TA_RMB_MTH_Pipeline',N'U') is not null
	drop table tblOutput_IMS_TA_RMB_MTH_Pipeline
go
select * into tblOutput_IMS_TA_RMB_MTH_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_RMB_MTH_Pipeline
go

print '--tblOutput_IMS_TA_UNT_MAT_Global'
if object_id(N'tblOutput_IMS_TA_UNT_MAT_Global',N'U') is not null
	drop table tblOutput_IMS_TA_UNT_MAT_Global
go
select * into tblOutput_IMS_TA_UNT_MAT_Global
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_UNT_MAT_Global
go

print '--tblOutput_IMS_TA_UNT_MAT_Inline'
if object_id(N'tblOutput_IMS_TA_UNT_MAT_Inline',N'U') is not null
	drop table tblOutput_IMS_TA_UNT_MAT_Inline
go
select * into tblOutput_IMS_TA_UNT_MAT_Inline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_UNT_MAT_Inline
go

print '--tblOutput_IMS_TA_UNT_MAT_Pipeline'
if object_id(N'tblOutput_IMS_TA_UNT_MAT_Pipeline',N'U') is not null
	drop table tblOutput_IMS_TA_UNT_MAT_Pipeline
go
select * into tblOutput_IMS_TA_UNT_MAT_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_UNT_MAT_Pipeline
go

print '--tblOutput_IMS_TA_UNT_MQT_Global'
if object_id(N'tblOutput_IMS_TA_UNT_MQT_Global',N'U') is not null
	drop table tblOutput_IMS_TA_UNT_MQT_Global
go
select * into tblOutput_IMS_TA_UNT_MQT_Global
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_UNT_MQT_Global
go

print '--tblOutput_IMS_TA_UNT_MQT_Inline'
if object_id(N'tblOutput_IMS_TA_UNT_MQT_Inline',N'U') is not null
	drop table tblOutput_IMS_TA_UNT_MQT_Inline
go
select * into tblOutput_IMS_TA_UNT_MQT_Inline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_UNT_MQT_Inline
go

print '--tblOutput_IMS_TA_UNT_MQT_Pipeline'
if object_id(N'tblOutput_IMS_TA_UNT_MQT_Pipeline',N'U') is not null
	drop table tblOutput_IMS_TA_UNT_MQT_Pipeline
go
select * into tblOutput_IMS_TA_UNT_MQT_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_UNT_MQT_Pipeline
go

print '--tblOutput_IMS_TA_UNT_MTH_Global'
if object_id(N'tblOutput_IMS_TA_UNT_MTH_Global',N'U') is not null
	drop table tblOutput_IMS_TA_UNT_MTH_Global
go
select * into tblOutput_IMS_TA_UNT_MTH_Global
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_UNT_MTH_Global
go

print '--tblOutput_IMS_TA_UNT_MTH_Inline'
if object_id(N'tblOutput_IMS_TA_UNT_MTH_Inline',N'U') is not null
	drop table tblOutput_IMS_TA_UNT_MTH_Inline
go
select * into tblOutput_IMS_TA_UNT_MTH_Inline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_UNT_MTH_Inline
go

print '--tblOutput_IMS_TA_UNT_MTH_Pipeline'
if object_id(N'tblOutput_IMS_TA_UNT_MTH_Pipeline',N'U') is not null
	drop table tblOutput_IMS_TA_UNT_MTH_Pipeline
go
select * into tblOutput_IMS_TA_UNT_MTH_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_UNT_MTH_Pipeline
go

print '--tblOutput_IMS_TA_USD_MAT_Global'
if object_id(N'tblOutput_IMS_TA_USD_MAT_Global',N'U') is not null
	drop table tblOutput_IMS_TA_USD_MAT_Global
go
select * into tblOutput_IMS_TA_USD_MAT_Global
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_USD_MAT_Global
go

print '--tblOutput_IMS_TA_USD_MAT_Inline'
if object_id(N'tblOutput_IMS_TA_USD_MAT_Inline',N'U') is not null
	drop table tblOutput_IMS_TA_USD_MAT_Inline
go
select * into tblOutput_IMS_TA_USD_MAT_Inline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_USD_MAT_Inline
go

print '--tblOutput_IMS_TA_USD_MAT_Pipeline'
if object_id(N'tblOutput_IMS_TA_USD_MAT_Pipeline',N'U') is not null
	drop table tblOutput_IMS_TA_USD_MAT_Pipeline
go
select * into tblOutput_IMS_TA_USD_MAT_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_USD_MAT_Pipeline
go

print '--tblOutput_IMS_TA_USD_MQT_Global'
if object_id(N'tblOutput_IMS_TA_USD_MQT_Global',N'U') is not null
	drop table tblOutput_IMS_TA_USD_MQT_Global
go
select * into tblOutput_IMS_TA_USD_MQT_Global
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_USD_MQT_Global
go

print '--tblOutput_IMS_TA_USD_MQT_Inline'
if object_id(N'tblOutput_IMS_TA_USD_MQT_Inline',N'U') is not null
	drop table tblOutput_IMS_TA_USD_MQT_Inline
go
select * into tblOutput_IMS_TA_USD_MQT_Inline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_USD_MQT_Inline
go

print '--tblOutput_IMS_TA_USD_MQT_Pipeline'
if object_id(N'tblOutput_IMS_TA_USD_MQT_Pipeline',N'U') is not null
	drop table tblOutput_IMS_TA_USD_MQT_Pipeline
go
select * into tblOutput_IMS_TA_USD_MQT_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_USD_MQT_Pipeline
go

print '--tblOutput_IMS_TA_USD_MTH_Global'
if object_id(N'tblOutput_IMS_TA_USD_MTH_Global',N'U') is not null
	drop table tblOutput_IMS_TA_USD_MTH_Global
go
select * into tblOutput_IMS_TA_USD_MTH_Global
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_USD_MTH_Global
go

print '--tblOutput_IMS_TA_USD_MTH_Inline'
if object_id(N'tblOutput_IMS_TA_USD_MTH_Inline',N'U') is not null
	drop table tblOutput_IMS_TA_USD_MTH_Inline
go
select * into tblOutput_IMS_TA_USD_MTH_Inline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_USD_MTH_Inline
go

print '--tblOutput_IMS_TA_USD_MTH_Pipeline'
if object_id(N'tblOutput_IMS_TA_USD_MTH_Pipeline',N'U') is not null
	drop table tblOutput_IMS_TA_USD_MTH_Pipeline
go
select * into tblOutput_IMS_TA_USD_MTH_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_IMS_TA_USD_MTH_Pipeline
go



/*

tblQueryTool_IMS_ATC_List
tblQueryToolDriverIMS
tblQueryToolDriverATC
tblOutput_IMS_ATC_RMB_MAT
tblOutput_IMS_ATC_RMB_MQT
tblOutput_IMS_ATC_RMB_MTH
tblOutput_IMS_ATC_UNT_MAT
tblOutput_IMS_ATC_UNT_MQT
tblOutput_IMS_ATC_UNT_MTH
tblOutput_IMS_ATC_USD_MAT
tblOutput_IMS_ATC_USD_MQT
tblOutput_IMS_ATC_USD_MTH
tblOutput_IMS_TA_RMB_MAT_Global
tblOutput_IMS_TA_RMB_MAT_Inline
tblOutput_IMS_TA_Master_Inline_Mkt
tblOutput_IMS_TA_RMB_MAT_Pipeline
tblOutput_IMS_TA_RMB_MQT_Global
tblOutput_IMS_TA_RMB_MQT_Inline
tblOutput_IMS_TA_RMB_MQT_Pipeline
tblOutput_IMS_TA_RMB_MTH_Global
tblOutput_IMS_TA_RMB_MTH_Inline
tblOutput_IMS_TA_RMB_MTH_Pipeline
tblOutput_IMS_TA_UNT_MAT_Global
tblOutput_IMS_TA_UNT_MAT_Inline
tblOutput_IMS_TA_UNT_MAT_Pipeline
tblOutput_IMS_TA_UNT_MQT_Global
tblOutput_IMS_TA_UNT_MQT_Inline
tblOutput_IMS_TA_UNT_MQT_Pipeline
tblOutput_IMS_TA_UNT_MTH_Global
tblOutput_IMS_TA_UNT_MTH_Inline
tblOutput_IMS_TA_UNT_MTH_Pipeline
tblOutput_IMS_TA_USD_MAT_Global
tblOutput_IMS_TA_USD_MAT_Inline
tblOutput_IMS_TA_USD_MAT_Pipeline
tblOutput_IMS_TA_USD_MQT_Global
tblOutput_IMS_TA_USD_MQT_Inline
tblOutput_IMS_TA_USD_MQT_Pipeline
tblOutput_IMS_TA_USD_MTH_Global
tblOutput_IMS_TA_USD_MTH_Inline
tblOutput_IMS_TA_USD_MTH_Pipeline



3月20号Pipeline临时上传
tblQueryToolDriverIMS
tblOutput_IMS_TA_Master_Inline_Mkt
tblOutput_IMS_TA_RMB_MAT_Pipeline
tblOutput_IMS_TA_RMB_MQT_Pipeline
tblOutput_IMS_TA_RMB_MTH_Pipeline
tblOutput_IMS_TA_UNT_MAT_Pipeline
tblOutput_IMS_TA_UNT_MQT_Pipeline
tblOutput_IMS_TA_UNT_MTH_Pipeline
tblOutput_IMS_TA_USD_MAT_Pipeline
tblOutput_IMS_TA_USD_MQT_Pipeline
tblOutput_IMS_TA_USD_MTH_Pipeline

*/