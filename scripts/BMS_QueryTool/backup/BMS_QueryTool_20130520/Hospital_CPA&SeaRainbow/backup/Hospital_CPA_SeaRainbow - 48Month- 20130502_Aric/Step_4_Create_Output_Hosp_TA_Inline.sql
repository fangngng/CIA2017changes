use BMSCNProc2
go


--1.
truncate table tblOutput_Hosp_TA_RMB_MTH_Inline
go
Insert into tblOutput_Hosp_TA_RMB_MTH_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MTHRMB'
go
--2.
truncate table tblOutput_Hosp_TA_RMB_MQT_Inline
go
Insert into tblOutput_Hosp_TA_RMB_MQT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MQTRMB'
go
--3.
truncate table tblOutput_Hosp_TA_RMB_MAT_Inline
go
Insert into tblOutput_Hosp_TA_RMB_MAT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MATRMB'
go



--4.
truncate table tblOutput_Hosp_TA_USD_MTH_Inline
go
Insert into tblOutput_Hosp_TA_USD_MTH_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MTHUSD'
go
--5.
truncate table tblOutput_Hosp_TA_USD_MQT_Inline
go
Insert into tblOutput_Hosp_TA_USD_MQT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MQTUSD'
go
--6.
truncate table tblOutput_Hosp_TA_USD_MAT_Inline
go
Insert into tblOutput_Hosp_TA_USD_MAT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MATUSD'
go


--7.
truncate table tblOutput_Hosp_TA_UNT_MTH_Inline
go
Insert into tblOutput_Hosp_TA_UNT_MTH_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MTHUNT'
go
--8.
truncate table tblOutput_Hosp_TA_UNT_MQT_Inline
go
Insert into tblOutput_Hosp_TA_UNT_MQT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MQTUNT'
go
--9.
truncate table tblOutput_Hosp_TA_UNT_MAT_Inline
go
Insert into tblOutput_Hosp_TA_UNT_MAT_Inline
select * from tblOutput_Hosp_TA_Master_Inline where DataType='MATUNT'
























