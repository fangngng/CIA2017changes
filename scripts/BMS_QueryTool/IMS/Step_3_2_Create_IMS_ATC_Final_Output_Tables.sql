use BMSCNProc2
go
--18分钟
--1:32

exec dbo.sp_Log_Event 'Process','QT_IMS','Step_3_2_Create_IMS_ATC_Final_Output_Tables.sql','Start',null,null

insert into tblOutput_IMS_ATC_Master
select * from dbo.tblOutput_IMS_ATC_Master_Suxi


--MTH:
truncate table tblOutput_IMS_ATC_RMB_MTH
Insert into tblOutput_IMS_ATC_RMB_MTH select * from tblOutput_IMS_ATC_Master where DataType='MTHRMB'
go

truncate table tblOutput_IMS_ATC_USD_MTH
Insert into tblOutput_IMS_ATC_USD_MTH select * from tblOutput_IMS_ATC_Master where DataType='MTHUSD' 
go

truncate table tblOutput_IMS_ATC_UNT_MTH
Insert into tblOutput_IMS_ATC_UNT_MTH select * from tblOutput_IMS_ATC_Master where DataType='MTHUNT' 
go




--MQT:
truncate table tblOutput_IMS_ATC_RMB_MQT
Insert into tblOutput_IMS_ATC_RMB_MQT select * from tblOutput_IMS_ATC_Master where DataType='MQTRMB' 
go

truncate table tblOutput_IMS_ATC_USD_MQT
Insert into tblOutput_IMS_ATC_USD_MQT select * from tblOutput_IMS_ATC_Master where DataType='MQTUSD' 
go

truncate table tblOutput_IMS_ATC_UNT_MQT
Insert into tblOutput_IMS_ATC_UNT_MQT select * from tblOutput_IMS_ATC_Master where DataType='MQTUNT' 
go




--MAT:
truncate table tblOutput_IMS_ATC_RMB_MAT
Insert into tblOutput_IMS_ATC_RMB_MAT select * from tblOutput_IMS_ATC_Master where DataType='MATRMB' 
go

truncate table tblOutput_IMS_ATC_USD_MAT
Insert into tblOutput_IMS_ATC_USD_MAT select * from tblOutput_IMS_ATC_Master where DataType='MATUSD' 
go

truncate table tblOutput_IMS_ATC_UNT_MAT
Insert into tblOutput_IMS_ATC_UNT_MAT select * from tblOutput_IMS_ATC_Master where DataType='MATUNT' 
GO


--YTD:
truncate table tblOutput_IMS_ATC_RMB_YTD
Insert into tblOutput_IMS_ATC_RMB_YTD select * from tblOutput_IMS_ATC_Master where DataType='YTDRMB' 
go

truncate table tblOutput_IMS_ATC_USD_YTD
Insert into tblOutput_IMS_ATC_USD_YTD select * from tblOutput_IMS_ATC_Master where DataType='YTDUSD' 
go

truncate table tblOutput_IMS_ATC_UNT_YTD
Insert into tblOutput_IMS_ATC_UNT_YTD select * from tblOutput_IMS_ATC_Master where DataType='YTDUNT'
go

exec dbo.sp_Log_Event 'Process','QT_IMS','Step_3_2_Create_IMS_ATC_Final_Output_Tables.sql','End',null,null

















