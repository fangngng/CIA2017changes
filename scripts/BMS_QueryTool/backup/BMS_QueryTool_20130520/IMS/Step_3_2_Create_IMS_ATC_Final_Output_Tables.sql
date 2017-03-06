use BMSCNProc2
go



--MTH:
truncate table tblOutput_IMS_ATC_RMB_MTH
go
Insert into tblOutput_IMS_ATC_RMB_MTH
select * from tblOutput_IMS_ATC_Master where DataType='MTHRMB'
go

truncate table tblOutput_IMS_ATC_USD_MTH
go
Insert into tblOutput_IMS_ATC_USD_MTH
select * from tblOutput_IMS_ATC_Master where DataType='MTHUSD' 
go

truncate table tblOutput_IMS_ATC_UNT_MTH
go
Insert into tblOutput_IMS_ATC_UNT_MTH
select * from tblOutput_IMS_ATC_Master where DataType='MTHUNT' 
go




--MQT:
truncate table tblOutput_IMS_ATC_RMB_MQT
go
Insert into tblOutput_IMS_ATC_RMB_MQT
select * from tblOutput_IMS_ATC_Master where DataType='MQTRMB' 
go

truncate table tblOutput_IMS_ATC_USD_MQT
go
Insert into tblOutput_IMS_ATC_USD_MQT
select * from tblOutput_IMS_ATC_Master where DataType='MQTUSD' 
go

truncate table tblOutput_IMS_ATC_UNT_MQT
go
Insert into tblOutput_IMS_ATC_UNT_MQT
select * from tblOutput_IMS_ATC_Master where DataType='MQTUNT' 
go




--MAT:
truncate table tblOutput_IMS_ATC_RMB_MAT
go
Insert into tblOutput_IMS_ATC_RMB_MAT
select * from tblOutput_IMS_ATC_Master where DataType='MATRMB' 
go

truncate table tblOutput_IMS_ATC_USD_MAT
go
Insert into tblOutput_IMS_ATC_USD_MAT
select * from tblOutput_IMS_ATC_Master where DataType='MATUSD' 
go

truncate table tblOutput_IMS_ATC_UNT_MAT
go
Insert into tblOutput_IMS_ATC_UNT_MAT
select * from tblOutput_IMS_ATC_Master where DataType='MATUNT' 



--YTD:
truncate table tblOutput_IMS_ATC_RMB_YTD
go
Insert into tblOutput_IMS_ATC_RMB_YTD
select * from tblOutput_IMS_ATC_Master where DataType='YTDRMB' 
go

truncate table tblOutput_IMS_ATC_USD_YTD
go
Insert into tblOutput_IMS_ATC_USD_YTD
select * from tblOutput_IMS_ATC_Master where DataType='YTDUSD' 
go

truncate table tblOutput_IMS_ATC_UNT_YTD
go
Insert into tblOutput_IMS_ATC_UNT_YTD
select * from tblOutput_IMS_ATC_Master where DataType='YTDUNT'





















