use BMSCNProc2
go
exec dbo.sp_Log_Event 'Process','QT_Rx','Step_4_Create_Rx_TA_Final_Output_Tables.sql','Start',null,null
go

delete from tblQueryToolDriverrx
where MktType='In-line Market' and mktName='Eliquis market' 
and mole_des not in ('APIXABAN','RIVAROXABAN')
go

if object_id(N'tblOutput_Rx_TA_RMB_3M_Global',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_3M_Global
go
select * into tblOutput_Rx_TA_RMB_3M_Global
from tblOutput_Rx_TA_Master where DataType='3MRMB' and MktType='Global TA'
go
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_20','VR_3M_20'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_19','VR_3M_19'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_18','VR_3M_18'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_17','VR_3M_17'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_16','VR_3M_16'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_15','VR_3M_15'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_14','VR_3M_14'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_13','VR_3M_13'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_12','VR_3M_12'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_11','VR_3M_11'

exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_10','VR_3M_10'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_9','VR_3M_9'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_8','VR_3M_8'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_7','VR_3M_7'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_6','VR_3M_6'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_5','VR_3M_5'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_4','VR_3M_4'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_3','VR_3M_3'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_2','VR_3M_2'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Global.MTH_1','VR_3M_1'

GO

if object_id(N'tblOutput_Rx_TA_RMB_3M_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_3M_Inline
go
select * into tblOutput_Rx_TA_RMB_3M_Inline
from tblOutput_Rx_TA_Master where DataType='3MRMB' and MktType='In-line Market'
go

exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_20','VR_3M_20'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_19','VR_3M_19'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_18','VR_3M_18'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_17','VR_3M_17'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_16','VR_3M_16'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_15','VR_3M_15'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_14','VR_3M_14'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_13','VR_3M_13'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_12','VR_3M_12'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_11','VR_3M_11'

exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_10','VR_3M_10'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_9','VR_3M_9'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_8','VR_3M_8'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_7','VR_3M_7'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_6','VR_3M_6'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_5','VR_3M_5'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_4','VR_3M_4'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_3','VR_3M_3'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_2','VR_3M_2'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Inline.MTH_1','VR_3M_1'

GO



if object_id(N'tblOutput_Rx_TA_RMB_3M_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_3M_Pipeline
go
select * into tblOutput_Rx_TA_RMB_3M_Pipeline
from tblOutput_Rx_TA_Master where DataType='3MRMB' and MktType='Pipeline Market'
go

exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_20','VR_3M_20'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_19','VR_3M_19'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_18','VR_3M_18'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_17','VR_3M_17'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_16','VR_3M_16'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_15','VR_3M_15'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_14','VR_3M_14'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_13','VR_3M_13'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_12','VR_3M_12'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_11','VR_3M_11'

exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_10','VR_3M_10'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_9','VR_3M_9'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_8','VR_3M_8'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_7','VR_3M_7'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_6','VR_3M_6'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_5','VR_3M_5'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_4','VR_3M_4'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_3','VR_3M_3'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_2','VR_3M_2'
exec sp_rename N'tblOutput_Rx_TA_RMB_3M_Pipeline.MTH_1','VR_3M_1'

GO


if object_id(N'tblOutput_Rx_TA_USD_3M_Global',N'U') is not null
	drop table tblOutput_Rx_TA_USD_3M_Global
go
select * into tblOutput_Rx_TA_USD_3M_Global
from tblOutput_Rx_TA_Master where DataType='3MUSD' and MktType='Global TA'
go

exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_20','VU_3M_20'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_19','VU_3M_19'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_18','VU_3M_18'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_17','VU_3M_17'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_16','VU_3M_16'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_15','VU_3M_15'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_14','VU_3M_14'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_13','VU_3M_13'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_12','VU_3M_12'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_11','VU_3M_11'

exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_10','VU_3M_10'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_9','VU_3M_9'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_8','VU_3M_8'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_7','VU_3M_7'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_6','VU_3M_6'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_5','VU_3M_5'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_4','VU_3M_4'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_3','VU_3M_3'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_2','VU_3M_2'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Global.MTH_1','VU_3M_1'
GO

if object_id(N'tblOutput_Rx_TA_USD_3M_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_3M_Inline
go
select * into tblOutput_Rx_TA_USD_3M_Inline
from tblOutput_Rx_TA_Master where DataType='3MUSD' and MktType='In-line Market'
go

exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_20','VU_3M_20'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_19','VU_3M_19'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_18','VU_3M_18'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_17','VU_3M_17'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_16','VU_3M_16'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_15','VU_3M_15'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_14','VU_3M_14'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_13','VU_3M_13'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_12','VU_3M_12'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_11','VU_3M_11'

exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_10','VU_3M_10'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_9','VU_3M_9'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_8','VU_3M_8'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_7','VU_3M_7'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_6','VU_3M_6'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_5','VU_3M_5'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_4','VU_3M_4'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_3','VU_3M_3'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_2','VU_3M_2'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Inline.MTH_1','VU_3M_1'
GO


if object_id(N'tblOutput_Rx_TA_USD_3M_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_3M_Pipeline
go
select * into tblOutput_Rx_TA_USD_3M_Pipeline
from tblOutput_Rx_TA_Master where DataType='3MUSD' and MktType='Pipeline Market'
go

exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_20','VU_3M_20'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_19','VU_3M_19'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_18','VU_3M_18'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_17','VU_3M_17'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_16','VU_3M_16'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_15','VU_3M_15'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_14','VU_3M_14'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_13','VU_3M_13'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_12','VU_3M_12'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_11','VU_3M_11'

exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_10','VU_3M_10'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_9','VU_3M_9'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_8','VU_3M_8'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_7','VU_3M_7'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_6','VU_3M_6'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_5','VU_3M_5'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_4','VU_3M_4'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_3','VU_3M_3'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_2','VU_3M_2'
exec sp_rename N'tblOutput_Rx_TA_USD_3M_Pipeline.MTH_1','VU_3M_1'
GO

if object_id(N'tblOutput_Rx_TA_Rx_3M_Global',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_3M_Global
go
select * into tblOutput_Rx_TA_Rx_3M_Global
from tblOutput_Rx_TA_Master where DataType='3MRx' and MktType='Global TA'
go

exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_20','Rx_3M_20'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_19','Rx_3M_19'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_18','Rx_3M_18'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_17','Rx_3M_17'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_16','Rx_3M_16'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_15','Rx_3M_15'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_14','Rx_3M_14'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_13','Rx_3M_13'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_12','Rx_3M_12'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_11','Rx_3M_11'

exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_10','Rx_3M_10'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_9','Rx_3M_9'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_8','Rx_3M_8'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_7','Rx_3M_7'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_6','Rx_3M_6'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_5','Rx_3M_5'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_4','Rx_3M_4'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_3','Rx_3M_3'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_2','Rx_3M_2'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Global.MTH_1','Rx_3M_1'
go

if object_id(N'tblOutput_Rx_TA_Rx_3M_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_3M_Inline
go
select * into tblOutput_Rx_TA_Rx_3M_Inline
from tblOutput_Rx_TA_Master where DataType='3MRx' and MktType='In-line Market'
go

exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_20','Rx_3M_20'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_19','Rx_3M_19'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_18','Rx_3M_18'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_17','Rx_3M_17'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_16','Rx_3M_16'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_15','Rx_3M_15'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_14','Rx_3M_14'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_13','Rx_3M_13'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_12','Rx_3M_12'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_11','Rx_3M_11'

exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_10','Rx_3M_10'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_9','Rx_3M_9'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_8','Rx_3M_8'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_7','Rx_3M_7'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_6','Rx_3M_6'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_5','Rx_3M_5'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_4','Rx_3M_4'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_3','Rx_3M_3'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_2','Rx_3M_2'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Inline.MTH_1','Rx_3M_1'
go



if object_id(N'tblOutput_Rx_TA_Rx_3M_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_3M_Pipeline
go
select * into tblOutput_Rx_TA_Rx_3M_Pipeline
from tblOutput_Rx_TA_Master where DataType='3MRx' and MktType='Pipeline Market'
go

exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_20','Rx_3M_20'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_19','Rx_3M_19'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_18','Rx_3M_18'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_17','Rx_3M_17'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_16','Rx_3M_16'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_15','Rx_3M_15'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_14','Rx_3M_14'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_13','Rx_3M_13'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_12','Rx_3M_12'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_11','Rx_3M_11'

exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_10','Rx_3M_10'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_9','Rx_3M_9'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_8','Rx_3M_8'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_7','Rx_3M_7'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_6','Rx_3M_6'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_5','Rx_3M_5'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_4','Rx_3M_4'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_3','Rx_3M_3'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_2','Rx_3M_2'
exec sp_rename N'tblOutput_Rx_TA_Rx_3M_Pipeline.MTH_1','Rx_3M_1'
go



if object_id(N'tblOutput_Rx_TA_RMB_MAT_Global',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_MAT_Global
go
select * into tblOutput_Rx_TA_RMB_MAT_Global
from tblOutput_Rx_TA_Master where DataType='MATRMB' and MktType='Global TA'
go

exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_20','VR_MAT_20'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_19','VR_MAT_19'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_18','VR_MAT_18'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_17','VR_MAT_17'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_16','VR_MAT_16'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_15','VR_MAT_15'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_14','VR_MAT_14'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_13','VR_MAT_13'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_12','VR_MAT_12'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Global.MTH_11','VR_MAT_11'

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

exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_20','VR_MAT_20'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_19','VR_MAT_19'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_18','VR_MAT_18'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_17','VR_MAT_17'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_16','VR_MAT_16'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_15','VR_MAT_15'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_14','VR_MAT_14'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_13','VR_MAT_13'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_12','VR_MAT_12'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Inline.MTH_11','VR_MAT_11'

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

exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_20','VR_MAT_20'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_19','VR_MAT_19'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_18','VR_MAT_18'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_17','VR_MAT_17'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_16','VR_MAT_16'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_15','VR_MAT_15'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_14','VR_MAT_14'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_13','VR_MAT_13'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_12','VR_MAT_12'
exec sp_rename N'tblOutput_Rx_TA_RMB_MAT_Pipeline.MTH_11','VR_MAT_11'

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

exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_20','VU_MAT_20'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_19','VU_MAT_19'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_18','VU_MAT_18'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_17','VU_MAT_17'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_16','VU_MAT_16'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_15','VU_MAT_15'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_14','VU_MAT_14'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_13','VU_MAT_13'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_12','VU_MAT_12'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Global.MTH_11','VU_MAT_11'

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
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_20','VU_MAT_20'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_19','VU_MAT_19'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_18','VU_MAT_18'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_17','VU_MAT_17'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_16','VU_MAT_16'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_15','VU_MAT_15'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_14','VU_MAT_14'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_13','VU_MAT_13'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_12','VU_MAT_12'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Inline.MTH_11','VU_MAT_11'

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

exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_20','VU_MAT_20'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_19','VU_MAT_19'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_18','VU_MAT_18'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_17','VU_MAT_17'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_16','VU_MAT_16'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_15','VU_MAT_15'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_14','VU_MAT_14'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_13','VU_MAT_13'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_12','VU_MAT_12'
exec sp_rename N'tblOutput_Rx_TA_USD_MAT_Pipeline.MTH_11','VU_MAT_11'

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
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_20','Rx_MAT_20'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_19','Rx_MAT_19'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_18','Rx_MAT_18'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_17','Rx_MAT_17'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_16','Rx_MAT_16'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_15','Rx_MAT_15'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_14','Rx_MAT_14'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_13','Rx_MAT_13'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_12','Rx_MAT_12'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Global.MTH_11','Rx_MAT_11'


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
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_20','Rx_MAT_20'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_19','Rx_MAT_19'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_18','Rx_MAT_18'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_17','Rx_MAT_17'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_16','Rx_MAT_16'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_15','Rx_MAT_15'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_14','Rx_MAT_14'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_13','Rx_MAT_13'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_12','Rx_MAT_12'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Inline.MTH_11','Rx_MAT_11'

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
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_20','Rx_MAT_20'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_19','Rx_MAT_19'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_18','Rx_MAT_18'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_17','Rx_MAT_17'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_16','Rx_MAT_16'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_15','Rx_MAT_15'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_14','Rx_MAT_14'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_13','Rx_MAT_13'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_12','Rx_MAT_12'
exec sp_rename N'tblOutput_Rx_TA_Rx_MAT_Pipeline.MTH_11','Rx_MAT_11'


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

------------------------------------------------------------------
--				Add Volume Output table
------------------------------------------------------------------

if object_id(N'tblOutput_Rx_TA_Volume_3M_Global',N'U') is not null
	drop table tblOutput_Rx_TA_Volume_3M_Global
go
select * into tblOutput_Rx_TA_Volume_3M_Global
from tblOutput_Rx_TA_Master where DataType='3MVol' and MktType='Global TA'
go

exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_20','Un_3M_20'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_19','Un_3M_19'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_18','Un_3M_18'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_17','Un_3M_17'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_16','Un_3M_16'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_15','Un_3M_15'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_14','Un_3M_14'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_13','Un_3M_13'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_12','Un_3M_12'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_11','Un_3M_11'

exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_10','Un_3M_10'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_9','Un_3M_9'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_8','Un_3M_8'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_7','Un_3M_7'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_6','Un_3M_6'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_5','Un_3M_5'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_4','Un_3M_4'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_3','Un_3M_3'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_2','Un_3M_2'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Global.MTH_1','Un_3M_1'
go

if object_id(N'tblOutput_Rx_TA_Volume_3M_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_Volume_3M_Inline
go
select * into tblOutput_Rx_TA_Volume_3M_Inline
from tblOutput_Rx_TA_Master where DataType='3MVol' and MktType='In-line Market'
go

exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_20','Un_3M_20'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_19','Un_3M_19'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_18','Un_3M_18'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_17','Un_3M_17'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_16','Un_3M_16'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_15','Un_3M_15'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_14','Un_3M_14'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_13','Un_3M_13'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_12','Un_3M_12'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_11','Un_3M_11'

exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_10','Un_3M_10'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_9','Un_3M_9'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_8','Un_3M_8'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_7','Un_3M_7'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_6','Un_3M_6'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_5','Un_3M_5'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_4','Un_3M_4'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_3','Un_3M_3'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_2','Un_3M_2'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Inline.MTH_1','Un_3M_1'
go



if object_id(N'tblOutput_Rx_TA_Volume_3M_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_Volume_3M_Pipeline
go
select * into tblOutput_Rx_TA_Volume_3M_Pipeline
from tblOutput_Rx_TA_Master where DataType='3MVol' and MktType='Pipeline Market'
go

exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_20','Un_3M_20'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_19','Un_3M_19'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_18','Un_3M_18'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_17','Un_3M_17'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_16','Un_3M_16'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_15','Un_3M_15'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_14','Un_3M_14'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_13','Un_3M_13'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_12','Un_3M_12'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_11','Un_3M_11'

exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_10','Un_3M_10'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_9','Un_3M_9'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_8','Un_3M_8'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_7','Un_3M_7'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_6','Un_3M_6'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_5','Un_3M_5'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_4','Un_3M_4'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_3','Un_3M_3'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_2','Un_3M_2'
exec sp_rename N'tblOutput_Rx_TA_Volume_3M_Pipeline.MTH_1','Un_3M_1'
go


------------------------------------------------------------------
--				MAT
------------------------------------------------------------------
if object_id(N'tblOutput_Rx_TA_Volume_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_Volume_MAT_Pipeline
go
select * into tblOutput_Rx_TA_Volume_MAT_Pipeline
from tblOutput_Rx_TA_Master where DataType='MATVOL' and MktType='Pipeline Market'
go

exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_20','UN_MAT_20'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_19','UN_MAT_19'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_18','UN_MAT_18'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_17','UN_MAT_17'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_16','UN_MAT_16'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_15','UN_MAT_15'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_14','UN_MAT_14'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_13','UN_MAT_13'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_12','UN_MAT_12'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_11','UN_MAT_11'

exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_10','UN_MAT_10'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_9','UN_MAT_9'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_8','UN_MAT_8'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_7','UN_MAT_7'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_6','UN_MAT_6'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_5','UN_MAT_5'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_4','UN_MAT_4'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_3','UN_MAT_3'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_2','UN_MAT_2'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Pipeline.MTH_1','UN_MAT_1'
GO


if object_id(N'tblOutput_Rx_TA_Volume_MAT_Global',N'U') is not null
	drop table tblOutput_Rx_TA_Volume_MAT_Global
go
select * into tblOutput_Rx_TA_Volume_MAT_Global
from tblOutput_Rx_TA_Master where DataType='MATVOL' and MktType='Global TA'
go
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_20','UN_MAT_20'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_19','UN_MAT_19'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_18','UN_MAT_18'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_17','UN_MAT_17'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_16','UN_MAT_16'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_15','UN_MAT_15'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_14','UN_MAT_14'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_13','UN_MAT_13'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_12','UN_MAT_12'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_11','UN_MAT_11'


exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_10','UN_MAT_10'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_9','UN_MAT_9'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_8','UN_MAT_8'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_7','UN_MAT_7'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_6','UN_MAT_6'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_5','UN_MAT_5'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_4','UN_MAT_4'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_3','UN_MAT_3'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_2','UN_MAT_2'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Global.MTH_1','UN_MAT_1'
go

if object_id(N'tblOutput_Rx_TA_Volume_MAT_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_Volume_MAT_Inline
go
select * into tblOutput_Rx_TA_Volume_MAT_Inline
from tblOutput_Rx_TA_Master where DataType='MATVOL' and MktType='In-line Market'
go
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_20','UN_MAT_20'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_19','UN_MAT_19'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_18','UN_MAT_18'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_17','UN_MAT_17'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_16','UN_MAT_16'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_15','UN_MAT_15'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_14','UN_MAT_14'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_13','UN_MAT_13'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_12','UN_MAT_12'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_11','UN_MAT_11'

exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_10','UN_MAT_10'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_9','UN_MAT_9'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_8','UN_MAT_8'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_7','UN_MAT_7'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_6','UN_MAT_6'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_5','UN_MAT_5'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_4','UN_MAT_4'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_3','UN_MAT_3'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_2','UN_MAT_2'
exec sp_rename N'tblOutput_Rx_TA_Volume_MAT_Inline.MTH_1','UN_MAT_1'
go

exec dbo.sp_Log_Event 'Process','QT_Rx','Step_4_Create_Rx_TA_Final_Output_Tables.sql','End',null,null


