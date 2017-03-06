use BMSCNProc2
go

truncate table tblOutput_Hosp_TA_RMB_MTH_Inline
go
Insert into tblOutput_Hosp_TA_RMB_MTH_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MTHRMB'
go
truncate table tblOutput_Hosp_TA_RMB_MQT_Inline
go
Insert into tblOutput_Hosp_TA_RMB_MQT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MQTRMB'
go
truncate table tblOutput_Hosp_TA_RMB_MAT_Inline
go
Insert into tblOutput_Hosp_TA_RMB_MAT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MATRMB'
go
truncate table tblOutput_Hosp_TA_USD_MTH_Inline
go
Insert into tblOutput_Hosp_TA_USD_MTH_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MTHUSD'
go
truncate table tblOutput_Hosp_TA_USD_MQT_Inline
go
Insert into tblOutput_Hosp_TA_USD_MQT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MQTUSD'
go
truncate table tblOutput_Hosp_TA_USD_MAT_Inline
go
Insert into tblOutput_Hosp_TA_USD_MAT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MATUSD'
go
truncate table tblOutput_Hosp_TA_UNT_MTH_Inline
go
Insert into tblOutput_Hosp_TA_UNT_MTH_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MTHUNT'
go
truncate table tblOutput_Hosp_TA_UNT_MQT_Inline
go
Insert into tblOutput_Hosp_TA_UNT_MQT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MQTUNT'
go
truncate table tblOutput_Hosp_TA_UNT_MAT_Inline
go
Insert into tblOutput_Hosp_TA_UNT_MAT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MATUNT'
























