use BMSChinaQueryToolNew
go


/*
================ HKAPI ================
*/

print '--tblQueryToolDriverHK'
if object_id(N'tblQueryToolDriverHK',N'U') is not null
	drop table tblQueryToolDriverHK
go
select * into tblQueryToolDriverHK
from db2.BMSCNProc2.dbo.tblQueryToolDriverHK
go

print '--tblOutput_HKAPI'
if object_id(N'tblOutput_HKAPI',N'U') is not null
	drop table tblOutput_HKAPI
go
select * into tblOutput_HKAPI
from db2.BMSCNProc2.dbo.tblOutput_HKAPI
go

