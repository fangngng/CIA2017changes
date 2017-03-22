use BMSCNProc2
go
exec dbo.sp_Log_Event 'Process','QT_CPA_Inline','Step_4_Create_Output_Hosp_TA_Inline.sql','Start',null,null
go
--remove error data from tblQueryToolDriverHosp
delete from tblQueryToolDriverHosp
where MktType='In-line Market' and mktName='Eliquis market' 
and mole_des not in ('APIXABAN','RIVAROXABAN')
go

SET ansi_warnings Off
truncate table tblOutput_Hosp_TA_UNT_MAT_Inline
Insert into tblOutput_Hosp_TA_UNT_MAT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MATUNT'
go
truncate table tblOutput_Hosp_TA_UNT_YTD_Inline
Insert into tblOutput_Hosp_TA_UNT_YTD_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='YTDUNT'
go
truncate table tblOutput_Hosp_TA_RMB_MQT_Inline
Insert into tblOutput_Hosp_TA_RMB_MQT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MQTRMB'
go
truncate table tblOutput_Hosp_TA_RMB_MAT_Inline
Insert into tblOutput_Hosp_TA_RMB_MAT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MATRMB'
go
truncate table tblOutput_Hosp_TA_RMB_YTD_Inline
Insert into tblOutput_Hosp_TA_RMB_YTD_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='YTDRMB'
go
truncate table tblOutput_Hosp_TA_UNT_MQT_Inline
Insert into tblOutput_Hosp_TA_UNT_MQT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MQTUNT'
go
truncate table tblOutput_Hosp_TA_RMB_MTH_Inline
Insert into tblOutput_Hosp_TA_RMB_MTH_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MTHRMB'
go
truncate table tblOutput_Hosp_TA_USD_MQT_Inline
Insert into tblOutput_Hosp_TA_USD_MQT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MQTUSD'
go
truncate table tblOutput_Hosp_TA_USD_MAT_Inline
Insert into tblOutput_Hosp_TA_USD_MAT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MATUSD'
go
truncate table tblOutput_Hosp_TA_USD_YTD_Inline
Insert into tblOutput_Hosp_TA_USD_YTD_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='YTDUSD'
go
truncate table tblOutput_Hosp_TA_USD_MTH_Inline
Insert into tblOutput_Hosp_TA_USD_MTH_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MTHUSD'
go
truncate table tblOutput_Hosp_TA_UNT_MTH_Inline
Insert into tblOutput_Hosp_TA_UNT_MTH_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MTHUNT'
go
SET ansi_warnings ON



exec dbo.sp_Log_Event 'Process','QT_CPA_Inline','Step_4_Create_Output_Hosp_TA_Inline.sql','End',null,null


















