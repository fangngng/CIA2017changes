use BMSChinaQueryToolNew
go

/*
================ Hospital PipeLine ================
*/
IF OBJECT_ID(N'tblHospitalList_Pipeline',N'U') IS NOT NULL
	DROP TABLE tblHospitalList_Pipeline
GO
SELECT * INTO tblHospitalList_Pipeline FROM db2.BMSCNProc2.dbo.tblHospitalList_Pipeline
go


IF OBJECT_ID(N'tblQueryToolDriverHosp_Pipeline',N'U') IS NOT NULL
	DROP TABLE tblQueryToolDriverHosp_Pipeline
GO
SELECT * INTO tblQueryToolDriverHosp_Pipeline FROM db2.BMSCNProc2.dbo.tblQueryToolDriverHosp_Pipeline
go



--MQT
print '--tblOutput_Hosp_TA_RMB_QTR_Pipeline'
if object_id(N'tblOutput_Hosp_TA_RMB_QTR_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_RMB_QTR_Pipeline
go
select * into tblOutput_Hosp_TA_RMB_QTR_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_RMB_QTR_Pipeline
go

print '--tblOutput_Hosp_TA_USD_QTR_Pipeline'
go
if object_id(N'tblOutput_Hosp_TA_USD_QTR_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_USD_QTR_Pipeline
go
select * into tblOutput_Hosp_TA_USD_QTR_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_USD_QTR_Pipeline
go

print '--tblOutput_Hosp_TA_UNT_QTR_Pipeline'
if object_id(N'tblOutput_Hosp_TA_UNT_QTR_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_UNT_QTR_Pipeline
go
select * into tblOutput_Hosp_TA_UNT_QTR_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_UNT_QTR_Pipeline
go



--MAT
print '--tblOutput_Hosp_TA_RMB_MAT_Pipeline'
if object_id(N'tblOutput_Hosp_TA_RMB_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_RMB_MAT_Pipeline
go
select * into tblOutput_Hosp_TA_RMB_MAT_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_RMB_MAT_Pipeline
go

print '--tblOutput_Hosp_TA_USD_MAT_Pipeline'
if object_id(N'tblOutput_Hosp_TA_USD_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_USD_MAT_Pipeline
go

select * into tblOutput_Hosp_TA_USD_MAT_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_USD_MAT_Pipeline
go

print '--tblOutput_Hosp_TA_UNT_MAT_Pipeline'
if object_id(N'tblOutput_Hosp_TA_UNT_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_UNT_MAT_Pipeline
go
select * into tblOutput_Hosp_TA_UNT_MAT_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_UNT_MAT_Pipeline
go

--YTD
print '--tblOutput_Hosp_TA_RMB_YTD_Pipeline'
if object_id(N'tblOutput_Hosp_TA_RMB_YTD_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_RMB_YTD_Pipeline
go
select * into tblOutput_Hosp_TA_RMB_YTD_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_RMB_YTD_Pipeline
go

print '--tblOutput_Hosp_TA_USD_YTD_Pipeline'
if object_id(N'tblOutput_Hosp_TA_USD_YTD_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_USD_YTD_Pipeline
go
select * into tblOutput_Hosp_TA_USD_YTD_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_USD_YTD_Pipeline
go

print '--tblOutput_Hosp_TA_UNT_YTD_Pipeline'
if object_id(N'tblOutput_Hosp_TA_UNT_YTD_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_UNT_YTD_Pipeline
go
select * into tblOutput_Hosp_TA_UNT_YTD_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_Hosp_TA_UNT_YTD_Pipeline
go






/*

Hi Jay,

下面是Query Tool需要更新的表，请上传，谢谢！

tblHospitalList_Pipeline
tblQueryToolDriverHosp_Pipeline
tblOutput_Hosp_TA_RMB_MAT_Pipeline
tblOutput_Hosp_TA_RMB_QTR_Pipeline
table tblOutput_Hosp_TA_UNT_MAT_Pipeline
tblOutput_Hosp_TA_UNT_QTR_Pipeline
table tblOutput_Hosp_TA_USD_MAT_Pipeline
tblOutput_Hosp_TA_USD_QTR_Pipeline

tblOutput_Hosp_TA_RMB_YTD_Pipeline
tblOutput_Hosp_TA_USD_YTD_Pipeline
tblOutput_Hosp_TA_UNT_YTD_Pipeline

*/