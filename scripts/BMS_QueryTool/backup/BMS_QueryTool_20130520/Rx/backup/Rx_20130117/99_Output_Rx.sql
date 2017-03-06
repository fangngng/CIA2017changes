use BMSChinaQueryToolNew
go

print '--tblOutput_Rx_TA_RMB_6M_Global'
if object_id(N'tblOutput_Rx_TA_RMB_6M_Global',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_6M_Global
go
select * into tblOutput_Rx_TA_RMB_6M_Global
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_RMB_6M_Global
go

print '--tblOutput_Rx_TA_RMB_6M_Inline'
if object_id(N'tblOutput_Rx_TA_RMB_6M_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_6M_Inline
go
select * into tblOutput_Rx_TA_RMB_6M_Inline
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_RMB_6M_Inline
go

print '--tblOutput_Rx_TA_RMB_6M_Pipeline'
if object_id(N'tblOutput_Rx_TA_RMB_6M_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_6M_Pipeline
go
select * into tblOutput_Rx_TA_RMB_6M_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_RMB_6M_Pipeline
go

print '--tblOutput_Rx_TA_USD_6M_Global'
if object_id(N'tblOutput_Rx_TA_USD_6M_Global',N'U') is not null
	drop table tblOutput_Rx_TA_USD_6M_Global
go
select * into tblOutput_Rx_TA_USD_6M_Global
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_USD_6M_Global
go

print '--tblOutput_Rx_TA_USD_6M_Inline'
if object_id(N'tblOutput_Rx_TA_USD_6M_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_6M_Inline
go
select * into tblOutput_Rx_TA_USD_6M_Inline
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_USD_6M_Inline
go

print '--tblOutput_Rx_TA_USD_6M_Pipeline'
if object_id(N'tblOutput_Rx_TA_USD_6M_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_6M_Pipeline
go
select * into tblOutput_Rx_TA_USD_6M_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_USD_6M_Pipeline
go

print '--tblOutput_Rx_TA_Rx_6M_Global'
if object_id(N'tblOutput_Rx_TA_Rx_6M_Global',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_6M_Global
go
select * into tblOutput_Rx_TA_Rx_6M_Global
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_Rx_6M_Global
go

print '--tblOutput_Rx_TA_Rx_6M_Inline'
if object_id(N'tblOutput_Rx_TA_Rx_6M_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_6M_Inline
go
select * into tblOutput_Rx_TA_Rx_6M_Inline
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_Rx_6M_Inline
go

print '--tblOutput_Rx_TA_Rx_6M_Pipeline'
if object_id(N'tblOutput_Rx_TA_Rx_6M_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_6M_Pipeline
go
select * into tblOutput_Rx_TA_Rx_6M_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_Rx_6M_Pipeline
go

print '--tblOutput_Rx_TA_RMB_MAT_Global'
if object_id(N'tblOutput_Rx_TA_RMB_MAT_Global',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_MAT_Global
go
select * into tblOutput_Rx_TA_RMB_MAT_Global
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_RMB_MAT_Global
go

print '--tblOutput_Rx_TA_RMB_MAT_Inline'
if object_id(N'tblOutput_Rx_TA_RMB_MAT_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_MAT_Inline
go
select * into tblOutput_Rx_TA_RMB_MAT_Inline
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_RMB_MAT_Inline
go

print '--tblOutput_Rx_TA_RMB_MAT_Pipeline'
if object_id(N'tblOutput_Rx_TA_RMB_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_MAT_Pipeline
go
select * into tblOutput_Rx_TA_RMB_MAT_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_RMB_MAT_Pipeline
go

print '--tblOutput_Rx_TA_USD_MAT_Global'
if object_id(N'tblOutput_Rx_TA_USD_MAT_Global',N'U') is not null
	drop table tblOutput_Rx_TA_USD_MAT_Global
go
select * into tblOutput_Rx_TA_USD_MAT_Global
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_USD_MAT_Global
go

print '--tblOutput_Rx_TA_USD_MAT_Inline'
if object_id(N'tblOutput_Rx_TA_USD_MAT_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_MAT_Inline
go
select * into tblOutput_Rx_TA_USD_MAT_Inline
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_USD_MAT_Inline
go

print '--tblOutput_Rx_TA_USD_MAT_Pipeline'
if object_id(N'tblOutput_Rx_TA_USD_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_MAT_Pipeline
go
select * into tblOutput_Rx_TA_USD_MAT_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_USD_MAT_Pipeline
go

print '--tblOutput_Rx_TA_Rx_MAT_Global'
if object_id(N'tblOutput_Rx_TA_Rx_MAT_Global',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_MAT_Global
go
select * into tblOutput_Rx_TA_Rx_MAT_Global
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_Rx_MAT_Global
go

print '--tblOutput_Rx_TA_Rx_MAT_Inline'
if object_id(N'tblOutput_Rx_TA_Rx_MAT_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_MAT_Inline
go
select * into tblOutput_Rx_TA_Rx_MAT_Inline
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_Rx_MAT_Inline
go

print '--tblOutput_Rx_TA_Rx_MAT_Pipeline'
if object_id(N'tblOutput_Rx_TA_Rx_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_MAT_Pipeline
go
select * into tblOutput_Rx_TA_Rx_MAT_Pipeline
from db2.BMSCNProc2.dbo.tblOutput_Rx_TA_Rx_MAT_Pipeline
go

