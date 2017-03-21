use BMSChinaQueryToolNew
go

exec BMSCNProc2_test.dbo.sp_Log_Event 'Output','QT_HKAPI','99_Output_HKAPI.sql','Start',null,null



print '--tblQueryToolDriverHK'
if object_id(N'tblQueryToolDriverHK',N'U') is not null
	drop table tblQueryToolDriverHK
go
select * into tblQueryToolDriverHK
from BMSCNProc2_test.dbo.tblQueryToolDriverHK
go
print '--tblOutput_HKAPI'
if object_id(N'tblOutput_HKAPI',N'U') is not null
	drop table tblOutput_HKAPI
go
select * into tblOutput_HKAPI
from BMSCNProc2_test.dbo.tblOutput_HKAPI
go

exec BMSCNProc2_test.dbo.sp_Log_Event 'Output','QT_HKAPI','99_Output_HKAPI.sql','End',null,null