use BMSCNProc2
go

exec dbo.sp_Log_Event 'Process','QT_IMS','Step_3_2_2_Create_MAX_ATC_Final_Output_Tables.sql','Start',null,null

--------------------------------
---MAX 
--------------------------------


--MTH:

if object_id(N'tblOutput_MAX_ATC_RMB_MTH',N'U') is not null
	drop table tblOutput_MAX_ATC_RMB_MTH
go  
select * into tblOutput_MAX_ATC_RMB_MTH  from tblOutput_MAX_ATC_Master where DataType='MTHRMB'
go

if object_id(N'tblOutput_MAX_ATC_USD_MTH',N'U') is not null
	drop table tblOutput_MAX_ATC_USD_MTH
go  
select * into tblOutput_MAX_ATC_USD_MTH  from tblOutput_MAX_ATC_Master where DataType='MTHUSD' 
go

if object_id(N'tblOutput_MAX_ATC_UNT_MTH',N'U') is not null
	drop table tblOutput_MAX_ATC_UNT_MTH
go  
select * into tblOutput_MAX_ATC_UNT_MTH  from tblOutput_MAX_ATC_Master where DataType='MTHUNT' 
go




--MQT:

if object_id(N'tblOutput_MAX_ATC_RMB_MQT',N'U') is not null
	drop table tblOutput_MAX_ATC_RMB_MQT
go   
select * into tblOutput_MAX_ATC_RMB_MQT  from tblOutput_MAX_ATC_Master where DataType='MQTRMB' 
go

if object_id(N'tblOutput_MAX_ATC_USD_MQT',N'U') is not null
	drop table tblOutput_MAX_ATC_USD_MQT
go  
select * into tblOutput_MAX_ATC_USD_MQT  from tblOutput_MAX_ATC_Master where DataType='MQTUSD' 
go

if object_id(N'tblOutput_MAX_ATC_UNT_MQT',N'U') is not null
	drop table tblOutput_MAX_ATC_UNT_MQT
go  
 select * into tblOutput_MAX_ATC_UNT_MQT from tblOutput_MAX_ATC_Master where DataType='MQTUNT' 
go




--MAT:

if object_id(N'tblOutput_MAX_ATC_RMB_MAT',N'U') is not null
	drop table tblOutput_MAX_ATC_RMB_MAT
go  
 select * into tblOutput_MAX_ATC_RMB_MAT from tblOutput_MAX_ATC_Master where DataType='MATRMB' 
go

if object_id(N'tblOutput_MAX_ATC_USD_MAT',N'U') is not null
	drop table tblOutput_MAX_ATC_USD_MAT
go  
 select * into tblOutput_MAX_ATC_USD_MAT from tblOutput_MAX_ATC_Master where DataType='MATUSD' 
go

if object_id(N'tblOutput_MAX_ATC_UNT_MAT',N'U') is not null
	drop table tblOutput_MAX_ATC_UNT_MAT
go  
 select * into tblOutput_MAX_ATC_UNT_MAT from tblOutput_MAX_ATC_Master where DataType='MATUNT' 
GO


--YTD:

if object_id(N'tblOutput_MAX_ATC_RMB_YTD',N'U') is not null
	drop table tblOutput_MAX_ATC_RMB_YTD
go  
 select * into tblOutput_MAX_ATC_RMB_YTD from tblOutput_MAX_ATC_Master where DataType='YTDRMB' 
go

if object_id(N'tblOutput_MAX_ATC_USD_YTD',N'U') is not null
	drop table tblOutput_MAX_ATC_USD_YTD
go  
select * into tblOutput_MAX_ATC_USD_YTD  from tblOutput_MAX_ATC_Master where DataType='YTDUSD' 
go

if object_id(N'tblOutput_MAX_ATC_UNT_YTD',N'U') is not null
	drop table tblOutput_MAX_ATC_UNT_YTD
go  
select * into tblOutput_MAX_ATC_UNT_YTD from tblOutput_MAX_ATC_Master where DataType='YTDUNT'
go


exec dbo.sp_Log_Event 'Process','QT_IMS','Step_3_2_Create_IMS_ATC_Final_Output_Tables.sql','End',null,null

















