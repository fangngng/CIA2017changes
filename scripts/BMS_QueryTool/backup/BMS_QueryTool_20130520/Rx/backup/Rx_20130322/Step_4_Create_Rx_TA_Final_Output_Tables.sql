use BMSCNProc2
go

if object_id(N'tblOutput_Rx_TA_RMB_6M_Global',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_6M_Global
go
select * into tblOutput_Rx_TA_RMB_6M_Global
from tblOutput_Rx_TA_Master where DataType='6MRMB' and MktType='Global TA'
go

exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Global.MTH_10','VR_6M_10'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Global.MTH_9','VR_6M_9'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Global.MTH_8','VR_6M_8'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Global.MTH_7','VR_6M_7'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Global.MTH_6','VR_6M_6'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Global.MTH_5','VR_6M_5'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Global.MTH_4','VR_6M_4'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Global.MTH_3','VR_6M_3'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Global.MTH_2','VR_6M_2'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Global.MTH_1','VR_6M_1'

GO

if object_id(N'tblOutput_Rx_TA_RMB_6M_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_6M_Inline
go
select * into tblOutput_Rx_TA_RMB_6M_Inline
from tblOutput_Rx_TA_Master where DataType='6MRMB' and MktType='In-line Market'
go

exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Inline.MTH_10','VR_6M_10'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Inline.MTH_9','VR_6M_9'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Inline.MTH_8','VR_6M_8'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Inline.MTH_7','VR_6M_7'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Inline.MTH_6','VR_6M_6'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Inline.MTH_5','VR_6M_5'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Inline.MTH_4','VR_6M_4'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Inline.MTH_3','VR_6M_3'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Inline.MTH_2','VR_6M_2'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Inline.MTH_1','VR_6M_1'

GO



if object_id(N'tblOutput_Rx_TA_RMB_6M_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_6M_Pipeline
go
select * into tblOutput_Rx_TA_RMB_6M_Pipeline
from tblOutput_Rx_TA_Master where DataType='6MRMB' and MktType='Pipeline Market'
go

exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Pipeline.MTH_10','VR_6M_10'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Pipeline.MTH_9','VR_6M_9'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Pipeline.MTH_8','VR_6M_8'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Pipeline.MTH_7','VR_6M_7'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Pipeline.MTH_6','VR_6M_6'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Pipeline.MTH_5','VR_6M_5'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Pipeline.MTH_4','VR_6M_4'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Pipeline.MTH_3','VR_6M_3'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Pipeline.MTH_2','VR_6M_2'
exec sp_rename N'tblOutput_Rx_TA_RMB_6M_Pipeline.MTH_1','VR_6M_1'

GO


if object_id(N'tblOutput_Rx_TA_USD_6M_Global',N'U') is not null
	drop table tblOutput_Rx_TA_USD_6M_Global
go
select * into tblOutput_Rx_TA_USD_6M_Global
from tblOutput_Rx_TA_Master where DataType='6MUSD' and MktType='Global TA'
go

exec sp_rename N'tblOutput_Rx_TA_USD_6M_Global.MTH_10','VU_6M_10'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Global.MTH_9','VU_6M_9'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Global.MTH_8','VU_6M_8'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Global.MTH_7','VU_6M_7'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Global.MTH_6','VU_6M_6'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Global.MTH_5','VU_6M_5'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Global.MTH_4','VU_6M_4'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Global.MTH_3','VU_6M_3'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Global.MTH_2','VU_6M_2'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Global.MTH_1','VU_6M_1'
GO

if object_id(N'tblOutput_Rx_TA_USD_6M_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_6M_Inline
go
select * into tblOutput_Rx_TA_USD_6M_Inline
from tblOutput_Rx_TA_Master where DataType='6MUSD' and MktType='In-line Market'
go

exec sp_rename N'tblOutput_Rx_TA_USD_6M_Inline.MTH_10','VU_6M_10'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Inline.MTH_9','VU_6M_9'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Inline.MTH_8','VU_6M_8'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Inline.MTH_7','VU_6M_7'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Inline.MTH_6','VU_6M_6'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Inline.MTH_5','VU_6M_5'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Inline.MTH_4','VU_6M_4'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Inline.MTH_3','VU_6M_3'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Inline.MTH_2','VU_6M_2'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Inline.MTH_1','VU_6M_1'
GO


if object_id(N'tblOutput_Rx_TA_USD_6M_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_6M_Pipeline
go
select * into tblOutput_Rx_TA_USD_6M_Pipeline
from tblOutput_Rx_TA_Master where DataType='6MUSD' and MktType='Pipeline Market'
go

exec sp_rename N'tblOutput_Rx_TA_USD_6M_Pipeline.MTH_10','VU_6M_10'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Pipeline.MTH_9','VU_6M_9'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Pipeline.MTH_8','VU_6M_8'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Pipeline.MTH_7','VU_6M_7'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Pipeline.MTH_6','VU_6M_6'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Pipeline.MTH_5','VU_6M_5'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Pipeline.MTH_4','VU_6M_4'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Pipeline.MTH_3','VU_6M_3'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Pipeline.MTH_2','VU_6M_2'
exec sp_rename N'tblOutput_Rx_TA_USD_6M_Pipeline.MTH_1','VU_6M_1'
GO

if object_id(N'tblOutput_Rx_TA_Rx_6M_Global',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_6M_Global
go
select * into tblOutput_Rx_TA_Rx_6M_Global
from tblOutput_Rx_TA_Master where DataType='6MRx' and MktType='Global TA'
go

exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Global.MTH_10','Rx_6M_10'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Global.MTH_9','Rx_6M_9'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Global.MTH_8','Rx_6M_8'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Global.MTH_7','Rx_6M_7'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Global.MTH_6','Rx_6M_6'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Global.MTH_5','Rx_6M_5'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Global.MTH_4','Rx_6M_4'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Global.MTH_3','Rx_6M_3'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Global.MTH_2','Rx_6M_2'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Global.MTH_1','Rx_6M_1'
go

if object_id(N'tblOutput_Rx_TA_Rx_6M_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_6M_Inline
go
select * into tblOutput_Rx_TA_Rx_6M_Inline
from tblOutput_Rx_TA_Master where DataType='6MRx' and MktType='In-line Market'
go

exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Inline.MTH_10','Rx_6M_10'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Inline.MTH_9','Rx_6M_9'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Inline.MTH_8','Rx_6M_8'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Inline.MTH_7','Rx_6M_7'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Inline.MTH_6','Rx_6M_6'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Inline.MTH_5','Rx_6M_5'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Inline.MTH_4','Rx_6M_4'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Inline.MTH_3','Rx_6M_3'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Inline.MTH_2','Rx_6M_2'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Inline.MTH_1','Rx_6M_1'
go



if object_id(N'tblOutput_Rx_TA_Rx_6M_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_6M_Pipeline
go
select * into tblOutput_Rx_TA_Rx_6M_Pipeline
from tblOutput_Rx_TA_Master where DataType='6MRx' and MktType='Pipeline Market'
go

exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Pipeline.MTH_10','Rx_6M_10'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Pipeline.MTH_9','Rx_6M_9'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Pipeline.MTH_8','Rx_6M_8'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Pipeline.MTH_7','Rx_6M_7'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Pipeline.MTH_6','Rx_6M_6'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Pipeline.MTH_5','Rx_6M_5'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Pipeline.MTH_4','Rx_6M_4'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Pipeline.MTH_3','Rx_6M_3'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Pipeline.MTH_2','Rx_6M_2'
exec sp_rename N'tblOutput_Rx_TA_Rx_6M_Pipeline.MTH_1','Rx_6M_1'
go



if object_id(N'tblOutput_Rx_TA_RMB_MAT_Global',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_MAT_Global
go
select * into tblOutput_Rx_TA_RMB_MAT_Global
from tblOutput_Rx_TA_Master where DataType='MATRMB' and MktType='Global TA'
go

exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_10','VR_MAT_10'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_9','VR_MAT_9'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_8','VR_MAT_8'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_7','VR_MAT_7'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_6','VR_MAT_6'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_5','VR_MAT_5'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_4','VR_MAT_4'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_3','VR_MAT_3'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_2','VR_MAT_2'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_1','VR_MAT_1'
go

if object_id(N'tblOutput_Rx_TA_RMB_MAT_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_MAT_Inline
go
select * into tblOutput_Rx_TA_RMB_MAT_Inline
from tblOutput_Rx_TA_Master where DataType='MATRMB' and MktType='In-line Market'
go

exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_10','VR_MAT_10'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_9','VR_MAT_9'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_8','VR_MAT_8'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_7','VR_MAT_7'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_6','VR_MAT_6'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_5','VR_MAT_5'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_4','VR_MAT_4'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_3','VR_MAT_3'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_2','VR_MAT_2'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_1','VR_MAT_1'
go


if object_id(N'tblOutput_Rx_TA_RMB_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_MAT_Pipeline
go
select * into tblOutput_Rx_TA_RMB_MAT_Pipeline
from tblOutput_Rx_TA_Master where DataType='MATRMB' and MktType='Pipeline Market'
go

exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_10','VR_MAT_10'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_9','VR_MAT_9'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_8','VR_MAT_8'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_7','VR_MAT_7'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_6','VR_MAT_6'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_5','VR_MAT_5'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_4','VR_MAT_4'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_3','VR_MAT_3'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_2','VR_MAT_2'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_1','VR_MAT_1'
go

if object_id(N'tblOutput_Rx_TA_USD_MAT_Global',N'U') is not null
	drop table tblOutput_Rx_TA_USD_MAT_Global
go
select * into tblOutput_Rx_TA_USD_MAT_Global
from tblOutput_Rx_TA_Master where DataType='MATUSD' and MktType='Global TA'
go

exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_10','VU_MAT_10'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_9','VU_MAT_9'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_8','VU_MAT_8'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_7','VU_MAT_7'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_6','VU_MAT_6'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_5','VU_MAT_5'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_4','VU_MAT_4'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_3','VU_MAT_3'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_2','VU_MAT_2'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_1','VU_MAT_1'
GO

if object_id(N'tblOutput_Rx_TA_USD_MAT_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_MAT_Inline
go
select * into tblOutput_Rx_TA_USD_MAT_Inline
from tblOutput_Rx_TA_Master where DataType='MATUSD' and MktType='In-line Market'
go
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_10','VU_MAT_10'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_9','VU_MAT_9'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_8','VU_MAT_8'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_7','VU_MAT_7'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_6','VU_MAT_6'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_5','VU_MAT_5'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_4','VU_MAT_4'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_3','VU_MAT_3'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_2','VU_MAT_2'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_1','VU_MAT_1'
GO


if object_id(N'tblOutput_Rx_TA_USD_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_MAT_Pipeline
go
select * into tblOutput_Rx_TA_USD_MAT_Pipeline
from tblOutput_Rx_TA_Master where DataType='MATUSD' and MktType='Pipeline Market'
go

exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_10','VU_MAT_10'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_9','VU_MAT_9'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_8','VU_MAT_8'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_7','VU_MAT_7'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_6','VU_MAT_6'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_5','VU_MAT_5'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_4','VU_MAT_4'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_3','VU_MAT_3'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_2','VU_MAT_2'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_1','VU_MAT_1'
GO


if object_id(N'tblOutput_Rx_TA_Rx_MAT_Global',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_MAT_Global
go
select * into tblOutput_Rx_TA_Rx_MAT_Global
from tblOutput_Rx_TA_Master where DataType='MATRx' and MktType='Global TA'
go

exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_10','Rx_MAT_10'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_9','Rx_MAT_9'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_8','Rx_MAT_8'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_7','Rx_MAT_7'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_6','Rx_MAT_6'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_5','Rx_MAT_5'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_4','Rx_MAT_4'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_3','Rx_MAT_3'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_2','Rx_MAT_2'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_1','Rx_MAT_1'
go

if object_id(N'tblOutput_Rx_TA_Rx_MAT_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_MAT_Inline
go
select * into tblOutput_Rx_TA_Rx_MAT_Inline
from tblOutput_Rx_TA_Master where DataType='MATRx' and MktType='In-line Market'
go
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_10','Rx_MAT_10'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_9','Rx_MAT_9'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_8','Rx_MAT_8'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_7','Rx_MAT_7'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_6','Rx_MAT_6'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_5','Rx_MAT_5'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_4','Rx_MAT_4'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_3','Rx_MAT_3'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_2','Rx_MAT_2'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_1','Rx_MAT_1'
go



if object_id(N'tblOutput_Rx_TA_Rx_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_MAT_Pipeline
go
select * into tblOutput_Rx_TA_Rx_MAT_Pipeline
from tblOutput_Rx_TA_Master where DataType='MATRx' and MktType='Pipeline Market'
go

exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_10','Rx_MAT_10'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_9','Rx_MAT_9'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_8','Rx_MAT_8'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_7','Rx_MAT_7'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_6','Rx_MAT_6'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_5','Rx_MAT_5'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_4','Rx_MAT_4'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_3','Rx_MAT_3'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_2','Rx_MAT_2'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_1','Rx_MAT_1'
go