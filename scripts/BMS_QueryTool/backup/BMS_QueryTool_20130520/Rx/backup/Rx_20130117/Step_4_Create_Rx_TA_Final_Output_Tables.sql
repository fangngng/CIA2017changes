use BMSCNProc2
go

if object_id(N'tblOutput_Rx_TA_RMB_6M_Global',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_6M_Global
go
select * into tblOutput_Rx_TA_RMB_6M_Global
from tblOutput_Rx_TA_Master where DataType='6MRMB' and MktType='Global TA'
go

if object_id(N'tblOutput_Rx_TA_RMB_6M_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_6M_Inline
go
select * into tblOutput_Rx_TA_RMB_6M_Inline
from tblOutput_Rx_TA_Master where DataType='6MRMB' and MktType='In-line Market'
go

if object_id(N'tblOutput_Rx_TA_RMB_6M_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_6M_Pipeline
go
select * into tblOutput_Rx_TA_RMB_6M_Pipeline
from tblOutput_Rx_TA_Master where DataType='6MRMB' and MktType='Pipeline Market'
go


if object_id(N'tblOutput_Rx_TA_USD_6M_Global',N'U') is not null
	drop table tblOutput_Rx_TA_USD_6M_Global
go
select * into tblOutput_Rx_TA_USD_6M_Global
from tblOutput_Rx_TA_Master where DataType='6MUSD' and MktType='Global TA'
go

if object_id(N'tblOutput_Rx_TA_USD_6M_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_6M_Inline
go
select * into tblOutput_Rx_TA_USD_6M_Inline
from tblOutput_Rx_TA_Master where DataType='6MUSD' and MktType='In-line Market'
go

if object_id(N'tblOutput_Rx_TA_USD_6M_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_6M_Pipeline
go
select * into tblOutput_Rx_TA_USD_6M_Pipeline
from tblOutput_Rx_TA_Master where DataType='6MUSD' and MktType='Pipeline Market'
go



if object_id(N'tblOutput_Rx_TA_Rx_6M_Global',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_6M_Global
go
select * into tblOutput_Rx_TA_Rx_6M_Global
from tblOutput_Rx_TA_Master where DataType='6MRx' and MktType='Global TA'
go

if object_id(N'tblOutput_Rx_TA_Rx_6M_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_6M_Inline
go
select * into tblOutput_Rx_TA_Rx_6M_Inline
from tblOutput_Rx_TA_Master where DataType='6MRx' and MktType='In-line Market'
go

if object_id(N'tblOutput_Rx_TA_Rx_6M_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_6M_Pipeline
go
select * into tblOutput_Rx_TA_Rx_6M_Pipeline
from tblOutput_Rx_TA_Master where DataType='6MRx' and MktType='Pipeline Market'
go


if object_id(N'tblOutput_Rx_TA_RMB_MAT_Global',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_MAT_Global
go
select * into tblOutput_Rx_TA_RMB_MAT_Global
from tblOutput_Rx_TA_Master where DataType='MATRMB' and MktType='Global TA'
go

if object_id(N'tblOutput_Rx_TA_RMB_MAT_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_MAT_Inline
go
select * into tblOutput_Rx_TA_RMB_MAT_Inline
from tblOutput_Rx_TA_Master where DataType='MATRMB' and MktType='In-line Market'
go

if object_id(N'tblOutput_Rx_TA_RMB_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_MAT_Pipeline
go
select * into tblOutput_Rx_TA_RMB_MAT_Pipeline
from tblOutput_Rx_TA_Master where DataType='MATRMB' and MktType='Pipeline Market'
go


if object_id(N'tblOutput_Rx_TA_USD_MAT_Global',N'U') is not null
	drop table tblOutput_Rx_TA_USD_MAT_Global
go
select * into tblOutput_Rx_TA_USD_MAT_Global
from tblOutput_Rx_TA_Master where DataType='MATUSD' and MktType='Global TA'
go

if object_id(N'tblOutput_Rx_TA_USD_MAT_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_MAT_Inline
go
select * into tblOutput_Rx_TA_USD_MAT_Inline
from tblOutput_Rx_TA_Master where DataType='MATUSD' and MktType='In-line Market'
go

if object_id(N'tblOutput_Rx_TA_USD_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_MAT_Pipeline
go
select * into tblOutput_Rx_TA_USD_MAT_Pipeline
from tblOutput_Rx_TA_Master where DataType='MATUSD' and MktType='Pipeline Market'
go



if object_id(N'tblOutput_Rx_TA_Rx_MAT_Global',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_MAT_Global
go
select * into tblOutput_Rx_TA_Rx_MAT_Global
from tblOutput_Rx_TA_Master where DataType='MATRx' and MktType='Global TA'
go

if object_id(N'tblOutput_Rx_TA_Rx_MAT_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_MAT_Inline
go
select * into tblOutput_Rx_TA_Rx_MAT_Inline
from tblOutput_Rx_TA_Master where DataType='MATRx' and MktType='In-line Market'
go

if object_id(N'tblOutput_Rx_TA_Rx_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_MAT_Pipeline
go
select * into tblOutput_Rx_TA_Rx_MAT_Pipeline
from tblOutput_Rx_TA_Master where DataType='MATRx' and MktType='Pipeline Market'
go

