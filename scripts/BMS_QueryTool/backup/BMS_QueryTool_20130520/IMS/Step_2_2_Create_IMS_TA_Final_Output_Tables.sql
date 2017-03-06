use BMSCNProc2
go

--MTH:
truncate table tblOutput_IMS_TA_RMB_MTH_Inline
go
Insert into tblOutput_IMS_TA_RMB_MTH_Inline
select * from tblOutput_IMS_TA_Master_Inline where DataType='MTHRMB' and Mkttype='In-line Market'
go
truncate table tblOutput_IMS_TA_USD_MTH_Inline
go
Insert into tblOutput_IMS_TA_USD_MTH_Inline
select * from tblOutput_IMS_TA_Master_Inline where DataType='MTHUSD' and Mkttype='In-line Market'
go
truncate table tblOutput_IMS_TA_UNT_MTH_Inline
go
Insert into tblOutput_IMS_TA_UNT_MTH_Inline
select * from tblOutput_IMS_TA_Master_Inline where DataType='MTHUNT' and Mkttype='In-line Market'
go
--
truncate table tblOutput_IMS_TA_RMB_MTH_Pipeline
go
Insert into tblOutput_IMS_TA_RMB_MTH_Pipeline
select * from tblOutput_IMS_TA_Master where DataType='MTHRMB' and Mkttype='Pipeline Market'
go
truncate table tblOutput_IMS_TA_USD_MTH_Pipeline
go
Insert into tblOutput_IMS_TA_USD_MTH_Pipeline
select * from tblOutput_IMS_TA_Master where DataType='MTHUSD' and Mkttype='Pipeline Market'
go
truncate table tblOutput_IMS_TA_UNT_MTH_Pipeline
go
Insert into tblOutput_IMS_TA_UNT_MTH_Pipeline
select * from tblOutput_IMS_TA_Master where DataType='MTHUNT' and Mkttype='Pipeline Market'
go
--
truncate table tblOutput_IMS_TA_RMB_MTH_Global
go
Insert into tblOutput_IMS_TA_RMB_MTH_Global
select * from tblOutput_IMS_TA_Master where DataType='MTHRMB' and Mkttype='Global TA'
go
truncate table tblOutput_IMS_TA_USD_MTH_Global
go
Insert into tblOutput_IMS_TA_USD_MTH_Global
select * from tblOutput_IMS_TA_Master where DataType='MTHUSD' and Mkttype='Global TA'
go
truncate table tblOutput_IMS_TA_UNT_MTH_Global
go
Insert into tblOutput_IMS_TA_UNT_MTH_Global
select * from tblOutput_IMS_TA_Master where DataType='MTHUNT' and Mkttype='Global TA'
go




--MQT:
truncate table tblOutput_IMS_TA_RMB_MQT_Inline
go
Insert into tblOutput_IMS_TA_RMB_MQT_Inline
select * from tblOutput_IMS_TA_Master_Inline where DataType='MQTRMB' and Mkttype='In-line Market'
go
truncate table tblOutput_IMS_TA_USD_MQT_Inline
go
Insert into tblOutput_IMS_TA_USD_MQT_Inline
select * from tblOutput_IMS_TA_Master_Inline where DataType='MQTUSD' and Mkttype='In-line Market'
go
truncate table tblOutput_IMS_TA_UNT_MQT_Inline
go
Insert into tblOutput_IMS_TA_UNT_MQT_Inline
select * from tblOutput_IMS_TA_Master_Inline where DataType='MQTUNT' and Mkttype='In-line Market'
go
--
truncate table tblOutput_IMS_TA_RMB_MQT_Pipeline
go
Insert into tblOutput_IMS_TA_RMB_MQT_Pipeline
select * from tblOutput_IMS_TA_Master where DataType='MQTRMB' and Mkttype='Pipeline Market'
go
truncate table tblOutput_IMS_TA_USD_MQT_Pipeline
go
Insert into tblOutput_IMS_TA_USD_MQT_Pipeline
select * from tblOutput_IMS_TA_Master where DataType='MQTUSD' and Mkttype='Pipeline Market'
go
truncate table tblOutput_IMS_TA_UNT_MQT_Pipeline
go
Insert into tblOutput_IMS_TA_UNT_MQT_Pipeline
select * from tblOutput_IMS_TA_Master where DataType='MQTUNT' and Mkttype='Pipeline Market'
go
--
truncate table tblOutput_IMS_TA_RMB_MQT_Global
go
Insert into tblOutput_IMS_TA_RMB_MQT_Global
select * from tblOutput_IMS_TA_Master where DataType='MQTRMB' and Mkttype='Global TA'
go
truncate table tblOutput_IMS_TA_USD_MQT_Global
go
Insert into tblOutput_IMS_TA_USD_MQT_Global
select * from tblOutput_IMS_TA_Master where DataType='MQTUSD' and Mkttype='Global TA'
go
truncate table tblOutput_IMS_TA_UNT_MQT_Global
go
Insert into tblOutput_IMS_TA_UNT_MQT_Global
select * from tblOutput_IMS_TA_Master where DataType='MQTUNT' and Mkttype='Global TA'
go




--MAT:
truncate table tblOutput_IMS_TA_RMB_MAT_Inline
go
Insert into tblOutput_IMS_TA_RMB_MAT_Inline
select * from tblOutput_IMS_TA_Master_Inline where DataType='MATRMB' and Mkttype='In-line Market'
go
truncate table tblOutput_IMS_TA_USD_MAT_Inline
go
Insert into tblOutput_IMS_TA_USD_MAT_Inline
select * from tblOutput_IMS_TA_Master_Inline where DataType='MATUSD' and Mkttype='In-line Market'
go
truncate table tblOutput_IMS_TA_UNT_MAT_Inline
go
Insert into tblOutput_IMS_TA_UNT_MAT_Inline
select * from tblOutput_IMS_TA_Master_Inline where DataType='MATUNT' and Mkttype='In-line Market'
go
--
truncate table tblOutput_IMS_TA_RMB_MAT_Pipeline
go
Insert into tblOutput_IMS_TA_RMB_MAT_Pipeline
select * from tblOutput_IMS_TA_Master where DataType='MATRMB' and Mkttype='Pipeline Market'
go
truncate table tblOutput_IMS_TA_USD_MAT_Pipeline
go
Insert into tblOutput_IMS_TA_USD_MAT_Pipeline
select * from tblOutput_IMS_TA_Master where DataType='MATUSD' and Mkttype='Pipeline Market'
go
truncate table tblOutput_IMS_TA_UNT_MAT_Pipeline
go
Insert into tblOutput_IMS_TA_UNT_MAT_Pipeline
select * from tblOutput_IMS_TA_Master where DataType='MATUNT' and Mkttype='Pipeline Market'
go
--
truncate table tblOutput_IMS_TA_RMB_MAT_Global
go
Insert into tblOutput_IMS_TA_RMB_MAT_Global
select * from tblOutput_IMS_TA_Master where DataType='MATRMB' and Mkttype='Global TA'
go
truncate table tblOutput_IMS_TA_USD_MAT_Global
go
Insert into tblOutput_IMS_TA_USD_MAT_Global
select * from tblOutput_IMS_TA_Master where DataType='MATUSD' and Mkttype='Global TA'
go
truncate table tblOutput_IMS_TA_UNT_MAT_Global
go
Insert into tblOutput_IMS_TA_UNT_MAT_Global
select * from tblOutput_IMS_TA_Master where DataType='MATUNT' and Mkttype='Global TA'
go



--YTD:
truncate table tblOutput_IMS_TA_RMB_YTD_Inline
go
Insert into tblOutput_IMS_TA_RMB_YTD_Inline
select * from tblOutput_IMS_TA_Master_Inline where DataType='YTDRMB' and Mkttype='In-line Market'
go
truncate table tblOutput_IMS_TA_USD_YTD_Inline
go
Insert into tblOutput_IMS_TA_USD_YTD_Inline
select * from tblOutput_IMS_TA_Master_Inline where DataType='YTDUSD' and Mkttype='In-line Market'
go
truncate table tblOutput_IMS_TA_UNT_YTD_Inline
go
Insert into tblOutput_IMS_TA_UNT_YTD_Inline
select * from tblOutput_IMS_TA_Master_Inline where DataType='YTDUNT' and Mkttype='In-line Market'
go
--
truncate table tblOutput_IMS_TA_RMB_YTD_Pipeline
go
Insert into tblOutput_IMS_TA_RMB_YTD_Pipeline
select * from tblOutput_IMS_TA_Master where DataType='YTDRMB' and Mkttype='Pipeline Market'
go
truncate table tblOutput_IMS_TA_USD_YTD_Pipeline
go
Insert into tblOutput_IMS_TA_USD_YTD_Pipeline
select * from tblOutput_IMS_TA_Master where DataType='YTDUSD' and Mkttype='Pipeline Market'
go
truncate table tblOutput_IMS_TA_UNT_YTD_Pipeline
go
Insert into tblOutput_IMS_TA_UNT_YTD_Pipeline
select * from tblOutput_IMS_TA_Master where DataType='YTDUNT' and Mkttype='Pipeline Market'
go
--
truncate table tblOutput_IMS_TA_RMB_YTD_Global
go
Insert into tblOutput_IMS_TA_RMB_YTD_Global
select * from tblOutput_IMS_TA_Master where DataType='YTDRMB' and Mkttype='Global TA'
go
truncate table tblOutput_IMS_TA_USD_YTD_Global
go
Insert into tblOutput_IMS_TA_USD_YTD_Global
select * from tblOutput_IMS_TA_Master where DataType='YTDUSD' and Mkttype='Global TA'
go
truncate table tblOutput_IMS_TA_UNT_YTD_Global
go
Insert into tblOutput_IMS_TA_UNT_YTD_Global
select * from tblOutput_IMS_TA_Master where DataType='YTDUNT' and Mkttype='Global TA'
go







































