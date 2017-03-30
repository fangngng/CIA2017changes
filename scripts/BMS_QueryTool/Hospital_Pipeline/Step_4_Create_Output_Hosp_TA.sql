use BMSCNProc2
go

exec dbo.sp_Log_Event 'Process','QT_CPA_Inline','Step_4_Create_Output_Hosp_TA.sql','Start',null,null

--MQT
truncate table tblOutput_Hosp_TA_RMB_QTR_Pipeline
go
Insert into tblOutput_Hosp_TA_RMB_QTR_Pipeline
select * from tblOutput_Hosp_TA_Master_Pipeline where DataType='MQTRMB' and Mkttype='Pipeline Market'
go

truncate table tblOutput_Hosp_TA_USD_QTR_Pipeline
go
Insert into tblOutput_Hosp_TA_USD_QTR_Pipeline
select * from tblOutput_Hosp_TA_Master_Pipeline where DataType='MQTUSD' and Mkttype='Pipeline Market'
go

truncate table tblOutput_Hosp_TA_UNT_QTR_Pipeline
go
Insert into tblOutput_Hosp_TA_UNT_QTR_Pipeline
select * from tblOutput_Hosp_TA_Master_Pipeline where DataType='MQTUNT' and Mkttype='Pipeline Market'
go



--MAT
truncate table tblOutput_Hosp_TA_RMB_MAT_Pipeline
go
Insert into tblOutput_Hosp_TA_RMB_MAT_Pipeline
select * from tblOutput_Hosp_TA_Master_Pipeline where DataType='MATRMB' and Mkttype='Pipeline Market'
go

truncate table tblOutput_Hosp_TA_USD_MAT_Pipeline
go
Insert into tblOutput_Hosp_TA_USD_MAT_Pipeline
select * from tblOutput_Hosp_TA_Master_Pipeline where DataType='MATUSD' and Mkttype='Pipeline Market'
go

truncate table tblOutput_Hosp_TA_UNT_MAT_Pipeline
go
Insert into tblOutput_Hosp_TA_UNT_MAT_Pipeline
select * from tblOutput_Hosp_TA_Master_Pipeline where DataType='MATUNT' and Mkttype='Pipeline Market'



--YTD
truncate table tblOutput_Hosp_TA_RMB_YTD_Pipeline
go
Insert into tblOutput_Hosp_TA_RMB_YTD_Pipeline
select * from tblOutput_Hosp_TA_Master_Pipeline where DataType='YTDRMB' and Mkttype='Pipeline Market'
go

truncate table tblOutput_Hosp_TA_USD_YTD_Pipeline
go
Insert into tblOutput_Hosp_TA_USD_YTD_Pipeline
select * from tblOutput_Hosp_TA_Master_Pipeline where DataType='YTDUSD' and Mkttype='Pipeline Market'
go

truncate table tblOutput_Hosp_TA_UNT_YTD_Pipeline
go
Insert into tblOutput_Hosp_TA_UNT_YTD_Pipeline
select * from tblOutput_Hosp_TA_Master_Pipeline where DataType='YTDUNT' and Mkttype='Pipeline Market'

exec dbo.sp_Log_Event 'Process','QT_CPA_Inline','Step_4_Create_Output_Hosp_TA.sql','End',null,null



















