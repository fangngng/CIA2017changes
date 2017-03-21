use BMSChinaQueryToolNew
go





exec BMSCNProc2_test.dbo.sp_Log_Event 'Output','QT_Rx','99_Output_Rx.sql','Start',null,null


IF OBJECT_ID(N'tblQueryToolDriverRx',N'U') IS NOT NULL
	DROP TABLE tblQueryToolDriverRx
GO
SELECT * INTO tblQueryToolDriverRx FROM BMSCNProc2_test.dbo.tblQueryToolDriverRx
go

------------------------------------------------------------------------
print '--tblOutput_Rx_TA_RMB_3M_Inline'
if object_id(N'tblOutput_Rx_TA_RMB_3M_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_3M_Inline
go
select * into tblOutput_Rx_TA_RMB_3M_Inline
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_RMB_3M_Inline
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_RMB_3M_Inline')
drop index tblOutput_Rx_TA_RMB_3M_Inline on tblOutput_Rx_TA_RMB_3M_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_RMB_3M_Inline ON [dbo].tblOutput_Rx_TA_RMB_3M_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_USD_3M_Inline'
if object_id(N'tblOutput_Rx_TA_USD_3M_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_3M_Inline
go
select * into tblOutput_Rx_TA_USD_3M_Inline
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_USD_3M_Inline
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_USD_3M_Inline')
drop index tblOutput_Rx_TA_USD_3M_Inline on tblOutput_Rx_TA_USD_3M_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_USD_3M_Inline ON [dbo].tblOutput_Rx_TA_USD_3M_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_Rx_3M_Inline'
if object_id(N'tblOutput_Rx_TA_Rx_3M_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_3M_Inline
go
select * into tblOutput_Rx_TA_Rx_3M_Inline
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_Rx_3M_Inline
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_Rx_3M_Inline')
drop index tblOutput_Rx_TA_Rx_3M_Inline on tblOutput_Rx_TA_Rx_3M_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_Rx_3M_Inline ON [dbo].tblOutput_Rx_TA_Rx_3M_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_RMB_MAT_Inline'
if object_id(N'tblOutput_Rx_TA_RMB_MAT_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_MAT_Inline
go
select * into tblOutput_Rx_TA_RMB_MAT_Inline
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_RMB_MAT_Inline
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_RMB_MAT_Inline')
drop index tblOutput_Rx_TA_RMB_MAT_Inline on tblOutput_Rx_TA_RMB_MAT_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_RMB_MAT_Inline ON [dbo].tblOutput_Rx_TA_RMB_MAT_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_USD_MAT_Inline'
if object_id(N'tblOutput_Rx_TA_USD_MAT_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_MAT_Inline
go
select * into tblOutput_Rx_TA_USD_MAT_Inline
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_USD_MAT_Inline
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_USD_MAT_Inline')
drop index tblOutput_Rx_TA_USD_MAT_Inline on tblOutput_Rx_TA_USD_MAT_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_USD_MAT_Inline ON [dbo].tblOutput_Rx_TA_USD_MAT_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_Rx_MAT_Inline'
if object_id(N'tblOutput_Rx_TA_Rx_MAT_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_MAT_Inline
go
select * into tblOutput_Rx_TA_Rx_MAT_Inline
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_Rx_MAT_Inline
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_Rx_MAT_Inline')
drop index tblOutput_Rx_TA_Rx_MAT_Inline on tblOutput_Rx_TA_Rx_MAT_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_Rx_MAT_Inline ON [dbo].tblOutput_Rx_TA_Rx_MAT_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO

-----------------
print '--tblOutput_Rx_TA_RMB_3M_Pipeline'
if object_id(N'tblOutput_Rx_TA_RMB_3M_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_3M_Pipeline
go
select * into tblOutput_Rx_TA_RMB_3M_Pipeline
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_RMB_3M_Pipeline
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_RMB_3M_Pipeline')
drop index tblOutput_Rx_TA_RMB_3M_Pipeline on tblOutput_Rx_TA_RMB_3M_Pipeline
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_RMB_3M_Pipeline ON [dbo].tblOutput_Rx_TA_RMB_3M_Pipeline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_USD_3M_Pipeline'
if object_id(N'tblOutput_Rx_TA_USD_3M_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_3M_Pipeline
go
select * into tblOutput_Rx_TA_USD_3M_Pipeline
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_USD_3M_Pipeline
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_USD_3M_Pipeline')
drop index tblOutput_Rx_TA_USD_3M_Pipeline on tblOutput_Rx_TA_USD_3M_Pipeline
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_USD_3M_Pipeline ON [dbo].tblOutput_Rx_TA_USD_3M_Pipeline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_Rx_3M_Pipeline'
if object_id(N'tblOutput_Rx_TA_Rx_3M_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_3M_Pipeline
go
select * into tblOutput_Rx_TA_Rx_3M_Pipeline
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_Rx_3M_Pipeline
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_Rx_3M_Pipeline')
drop index tblOutput_Rx_TA_Rx_3M_Pipeline on tblOutput_Rx_TA_Rx_3M_Pipeline
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_Rx_3M_Pipeline ON [dbo].tblOutput_Rx_TA_Rx_3M_Pipeline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_RMB_MAT_Pipeline'
if object_id(N'tblOutput_Rx_TA_RMB_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_MAT_Pipeline
go
select * into tblOutput_Rx_TA_RMB_MAT_Pipeline
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_RMB_MAT_Pipeline
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_RMB_MAT_Pipeline')
drop index tblOutput_Rx_TA_RMB_MAT_Pipeline on tblOutput_Rx_TA_RMB_MAT_Pipeline
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_RMB_MAT_Pipeline ON [dbo].tblOutput_Rx_TA_RMB_MAT_Pipeline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_USD_MAT_Pipeline'
if object_id(N'tblOutput_Rx_TA_USD_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_USD_MAT_Pipeline
go
select * into tblOutput_Rx_TA_USD_MAT_Pipeline
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_USD_MAT_Pipeline
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_USD_MAT_Pipeline')
drop index tblOutput_Rx_TA_USD_MAT_Pipeline on tblOutput_Rx_TA_USD_MAT_Pipeline
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_USD_MAT_Pipeline ON [dbo].tblOutput_Rx_TA_USD_MAT_Pipeline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO

print '--tblOutput_Rx_TA_Rx_MAT_Pipeline'
if object_id(N'tblOutput_Rx_TA_Rx_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_MAT_Pipeline
go
select * into tblOutput_Rx_TA_Rx_MAT_Pipeline
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_Rx_MAT_Pipeline
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_Rx_MAT_Pipeline')
drop index tblOutput_Rx_TA_Rx_MAT_Pipeline on tblOutput_Rx_TA_Rx_MAT_Pipeline
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_Rx_MAT_Pipeline ON [dbo].tblOutput_Rx_TA_Rx_MAT_Pipeline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
-----------------
print '--tblOutput_Rx_TA_RMB_3M_Global'
if object_id(N'tblOutput_Rx_TA_RMB_3M_Global',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_3M_Global
go
select * into tblOutput_Rx_TA_RMB_3M_Global
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_RMB_3M_Global
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_RMB_3M_Global')
drop index tblOutput_Rx_TA_RMB_3M_Global on tblOutput_Rx_TA_RMB_3M_Global
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_RMB_3M_Global ON [dbo].tblOutput_Rx_TA_RMB_3M_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_USD_3M_Global'
if object_id(N'tblOutput_Rx_TA_USD_3M_Global',N'U') is not null
	drop table tblOutput_Rx_TA_USD_3M_Global
go
select * into tblOutput_Rx_TA_USD_3M_Global
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_USD_3M_Global
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_USD_3M_Global')
drop index tblOutput_Rx_TA_USD_3M_Global on tblOutput_Rx_TA_USD_3M_Global
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_USD_3M_Global ON [dbo].tblOutput_Rx_TA_USD_3M_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_Rx_3M_Global'
if object_id(N'tblOutput_Rx_TA_Rx_3M_Global',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_3M_Global
go
select * into tblOutput_Rx_TA_Rx_3M_Global
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_Rx_3M_Global
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_Rx_3M_Global')
drop index tblOutput_Rx_TA_Rx_3M_Global on tblOutput_Rx_TA_Rx_3M_Global
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_Rx_3M_Global ON [dbo].tblOutput_Rx_TA_Rx_3M_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_RMB_MAT_Global'
if object_id(N'tblOutput_Rx_TA_RMB_MAT_Global',N'U') is not null
	drop table tblOutput_Rx_TA_RMB_MAT_Global
go
select * into tblOutput_Rx_TA_RMB_MAT_Global
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_RMB_MAT_Global
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_RMB_MAT_Global')
drop index tblOutput_Rx_TA_RMB_MAT_Global on tblOutput_Rx_TA_RMB_MAT_Global
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_RMB_MAT_Global ON [dbo].tblOutput_Rx_TA_RMB_MAT_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_USD_MAT_Global'
if object_id(N'tblOutput_Rx_TA_USD_MAT_Global',N'U') is not null
	drop table tblOutput_Rx_TA_USD_MAT_Global
go
select * into tblOutput_Rx_TA_USD_MAT_Global
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_USD_MAT_Global
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_USD_MAT_Global')
drop index tblOutput_Rx_TA_USD_MAT_Global on tblOutput_Rx_TA_USD_MAT_Global
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_USD_MAT_Global ON [dbo].tblOutput_Rx_TA_USD_MAT_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_Rx_MAT_Global'
if object_id(N'tblOutput_Rx_TA_Rx_MAT_Global',N'U') is not null
	drop table tblOutput_Rx_TA_Rx_MAT_Global
go
select * into tblOutput_Rx_TA_Rx_MAT_Global
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_Rx_MAT_Global
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_Rx_MAT_Global')
drop index tblOutput_Rx_TA_Rx_MAT_Global on tblOutput_Rx_TA_Rx_MAT_Global
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_Rx_MAT_Global ON [dbo].tblOutput_Rx_TA_Rx_MAT_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_Volume_3M_Inline'
if object_id(N'tblOutput_Rx_TA_Volume_3M_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_Volume_3M_Inline
go
select * into tblOutput_Rx_TA_Volume_3M_Inline
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_Volume_3M_Inline
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_Volume_3M_Inline')
drop index tblOutput_Rx_TA_Volume_3M_Inline on tblOutput_Rx_TA_Volume_3M_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_Volume_3M_Inline ON [dbo].tblOutput_Rx_TA_Volume_3M_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO

print '--tblOutput_Rx_TA_Volume_MAT_Inline'
if object_id(N'tblOutput_Rx_TA_Volume_MAT_Inline',N'U') is not null
	drop table tblOutput_Rx_TA_Volume_MAT_Inline
go
select * into tblOutput_Rx_TA_Volume_MAT_Inline
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_Volume_MAT_Inline
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_Volume_MAT_Inline')
drop index tblOutput_Rx_TA_Volume_MAT_Inline on tblOutput_Rx_TA_Volume_MAT_Inline
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_Volume_MAT_Inline ON [dbo].tblOutput_Rx_TA_Volume_MAT_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_Volume_3M_Pipeline'
if object_id(N'tblOutput_Rx_TA_Volume_3M_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_Volume_3M_Pipeline
go
select * into tblOutput_Rx_TA_Volume_3M_Pipeline
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_Volume_3M_Pipeline
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_Volume_3M_Pipeline')
drop index tblOutput_Rx_TA_Volume_3M_Pipeline on tblOutput_Rx_TA_Volume_3M_Pipeline
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_Volume_3M_Pipeline ON [dbo].tblOutput_Rx_TA_Volume_3M_Pipeline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO


print '--tblOutput_Rx_TA_Volume_MAT_Pipeline'
if object_id(N'tblOutput_Rx_TA_Volume_MAT_Pipeline',N'U') is not null
	drop table tblOutput_Rx_TA_Volume_MAT_Pipeline
go
select * into tblOutput_Rx_TA_Volume_MAT_Pipeline
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_Volume_MAT_Pipeline
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_Volume_MAT_Pipeline')
drop index tblOutput_Rx_TA_Volume_MAT_Pipeline on tblOutput_Rx_TA_Volume_MAT_Pipeline
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_Volume_MAT_Pipeline ON [dbo].tblOutput_Rx_TA_Volume_MAT_Pipeline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_Volume_3M_Global'
if object_id(N'tblOutput_Rx_TA_Volume_3M_Global',N'U') is not null
	drop table tblOutput_Rx_TA_Volume_3M_Global
go
select * into tblOutput_Rx_TA_Volume_3M_Global
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_Volume_3M_Global
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_Volume_3M_Global')
drop index tblOutput_Rx_TA_Volume_3M_Global on tblOutput_Rx_TA_Volume_3M_Global
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_Volume_3M_Global ON [dbo].tblOutput_Rx_TA_Volume_3M_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO
print '--tblOutput_Rx_TA_Volume_MAT_Global'
if object_id(N'tblOutput_Rx_TA_Volume_MAT_Global',N'U') is not null
	drop table tblOutput_Rx_TA_Volume_MAT_Global
go
select * into tblOutput_Rx_TA_Volume_MAT_Global
from BMSCNProc2_test.dbo.tblOutput_Rx_TA_Volume_MAT_Global
go
if exists(select * from sysindexes where name='tblOutput_Rx_TA_Volume_MAT_Global')
drop index tblOutput_Rx_TA_Volume_MAT_Global on tblOutput_Rx_TA_Volume_MAT_Global
go
    CREATE CLUSTERED INDEX tblOutput_Rx_TA_Volume_MAT_Global ON [dbo].tblOutput_Rx_TA_Volume_MAT_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
GO







--tblQueryToolDriverRx
--tblOutput_Rx_TA_RMB_3M_Inline
--tblOutput_Rx_TA_USD_3M_Inline
--tblOutput_Rx_TA_Rx_3M_Inline
--tblOutput_Rx_TA_RMB_MAT_Inline
--tblOutput_Rx_TA_USD_MAT_Inline
--tblOutput_Rx_TA_Rx_MAT_Inline
--tblOutput_Rx_TA_RMB_3M_Pipeline
--tblOutput_Rx_TA_USD_3M_Pipeline
--tblOutput_Rx_TA_Rx_3M_Pipeline
--tblOutput_Rx_TA_RMB_MAT_Pipeline
--tblOutput_Rx_TA_USD_MAT_Pipeline
--tblOutput_Rx_TA_Rx_MAT_Pipeline
--tblOutput_Rx_TA_RMB_3M_Global
--tblOutput_Rx_TA_USD_3M_Global
--tblOutput_Rx_TA_Rx_3M_Global
--tblOutput_Rx_TA_RMB_MAT_Global
--tblOutput_Rx_TA_USD_MAT_Global
--tblOutput_Rx_TA_Rx_MAT_Global





--view:
--inline:
--QTR:
IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_Rx_TA_3M_Inline')
DROP VIEW tblOutput_Rx_TA_3M_Inline
go
CREATE VIEW tblOutput_Rx_TA_3M_Inline
as

select 'Quarter' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.department,a.dept_code,a.class,a.class_name,a.dept_lvl,a.prod_lvl,a.uniq_prod,a.molecule_name,a.molecule_code,a.product_name,a.product_code,a.package_name,a.package_code,
a.VR_3M_20,a.VR_3M_19,a.VR_3M_18,a.VR_3M_17,a.VR_3M_16,a.VR_3M_15,a.VR_3M_14,a.VR_3M_13,a.VR_3M_12,a.VR_3M_11,a.VR_3M_10,a.VR_3M_9,a.VR_3M_8,a.VR_3M_7,a.VR_3M_6,a.VR_3M_5,a.VR_3M_4,a.VR_3M_3,a.VR_3M_2,a.VR_3M_1,
b.VU_3M_20,b.VU_3M_19,b.VU_3M_18,b.VU_3M_17,b.VU_3M_16,b.VU_3M_15,b.VU_3M_14,b.VU_3M_13,b.VU_3M_12,b.VU_3M_11,b.VU_3M_10,b.VU_3M_9,b.VU_3M_8,b.VU_3M_7,b.VU_3M_6,b.VU_3M_5,b.VU_3M_4,b.VU_3M_3,b.VU_3M_2,b.VU_3M_1,
c.Rx_3M_20,c.Rx_3M_19,c.Rx_3M_18,c.Rx_3M_17,c.Rx_3M_16,c.Rx_3M_15,c.Rx_3M_14,c.Rx_3M_13,c.Rx_3M_12,c.Rx_3M_11,c.Rx_3M_10,c.Rx_3M_9,c.Rx_3M_8,c.Rx_3M_7,c.Rx_3M_6,c.Rx_3M_5,c.Rx_3M_4,c.Rx_3M_3,c.Rx_3M_2,c.Rx_3M_1,
d.Un_3M_20,d.Un_3M_19,d.Un_3M_18,d.Un_3M_17,d.Un_3M_16,d.Un_3M_15,d.Un_3M_14,d.Un_3M_13,d.Un_3M_12,d.Un_3M_11,d.Un_3M_10,d.Un_3M_9,d.Un_3M_8,d.Un_3M_7,d.Un_3M_6,d.Un_3M_5,d.Un_3M_4,d.Un_3M_3,d.Un_3M_2,d.Un_3M_1
from tblOutput_Rx_TA_RMB_3M_Inline a
inner join tblOutput_Rx_TA_USD_3M_Inline b
on a.mkttype=b.mkttype and a.mkt=b.mkt and a.market_name=b.market_name and a.geo=b.geo and case when a.department is null then '' else a.department end=case when b.department is null then '' else b.department end 
and case when a.class is null then '' else a.class end=case when b.class is null then '' else b.class end and a.dept_lvl=b.dept_lvl and a.prod_lvl=b.prod_lvl 
and a.uniq_prod=b.uniq_prod and a.molecule_code=b.molecule_code and a.product_code=b.product_code and a.package_code=b.package_code
inner join tblOutput_Rx_TA_Rx_3M_Inline c
on a.mkttype=c.mkttype and a.mkt=c.mkt and a.market_name=c.market_name and a.geo=c.geo and case when a.department is null then '' else a.department end=case when c.department is null then '' else c.department end 
and case when a.class is null then '' else a.class end=case when c.class is null then '' else c.class end and a.dept_lvl=c.dept_lvl and a.prod_lvl=c.prod_lvl 
and a.uniq_prod=c.uniq_prod and a.molecule_code=c.molecule_code and a.product_code=c.product_code and a.package_code=c.package_code
inner join tblOutput_Rx_TA_Volume_3M_Inline d
on a.mkttype=d.mkttype and a.mkt=d.mkt and a.market_name=d.market_name and a.geo=d.geo and case when a.department is null then '' else a.department end=case when d.department is null then '' else d.department end 
and case when a.class is null then '' else a.class end=case when d.class is null then '' else d.class end and a.dept_lvl=d.dept_lvl and a.prod_lvl=d.prod_lvl 
and a.uniq_prod=d.uniq_prod and a.molecule_code=d.molecule_code and a.product_code=d.product_code and a.package_code=d.package_code
GO


--MAT:
IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_Rx_TA_MAT_Inline')
DROP VIEW tblOutput_Rx_TA_MAT_Inline
go
CREATE VIEW tblOutput_Rx_TA_MAT_Inline
as

select 'MAT' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.department,a.dept_code,a.class,a.class_name,a.dept_lvl,a.prod_lvl,a.uniq_prod,a.molecule_name,a.molecule_code,a.product_name,a.product_code,a.package_name,a.package_code,
a.VR_MAT_20,a.VR_MAT_19,a.VR_MAT_18,a.VR_MAT_17,a.VR_MAT_16,a.VR_MAT_15,a.VR_MAT_14,a.VR_MAT_13,a.VR_MAT_12,a.VR_MAT_11,a.VR_MAT_10,a.VR_MAT_9,a.VR_MAT_8,a.VR_MAT_7,a.VR_MAT_6,a.VR_MAT_5,a.VR_MAT_4,a.VR_MAT_3,a.VR_MAT_2,a.VR_MAT_1,
b.VU_MAT_20,b.VU_MAT_19,b.VU_MAT_18,b.VU_MAT_17,b.VU_MAT_16,b.VU_MAT_15,b.VU_MAT_14,b.VU_MAT_13,b.VU_MAT_12,b.VU_MAT_11,b.VU_MAT_10,b.VU_MAT_9,b.VU_MAT_8,b.VU_MAT_7,b.VU_MAT_6,b.VU_MAT_5,b.VU_MAT_4,b.VU_MAT_3,b.VU_MAT_2,b.VU_MAT_1,
c.Rx_MAT_20,c.Rx_MAT_19,c.Rx_MAT_18,c.Rx_MAT_17,c.Rx_MAT_16,c.Rx_MAT_15,c.Rx_MAT_14,c.Rx_MAT_13,c.Rx_MAT_12,c.Rx_MAT_11,c.Rx_MAT_10,c.Rx_MAT_9,c.Rx_MAT_8,c.Rx_MAT_7,c.Rx_MAT_6,c.Rx_MAT_5,c.Rx_MAT_4,c.Rx_MAT_3,c.Rx_MAT_2,c.Rx_MAT_1,
d.Un_MAT_20,d.Un_MAT_19,d.Un_MAT_18,d.Un_MAT_17,d.Un_MAT_16,d.Un_MAT_15,d.Un_MAT_14,d.Un_MAT_13,d.Un_MAT_12,d.Un_MAT_11,d.Un_MAT_10,d.Un_MAT_9,d.Un_MAT_8,d.Un_MAT_7,d.Un_MAT_6,d.Un_MAT_5,d.Un_MAT_4,d.Un_MAT_3,d.Un_MAT_2,d.Un_MAT_1
from tblOutput_Rx_TA_RMB_MAT_Inline a
inner join tblOutput_Rx_TA_USD_MAT_Inline b
on a.mkttype=b.mkttype and a.mkt=b.mkt and a.market_name=b.market_name and a.geo=b.geo and case when a.department is null then '' else a.department end=case when b.department is null then '' else b.department end 
and case when a.class is null then '' else a.class end=case when b.class is null then '' else b.class end and a.dept_lvl=b.dept_lvl and a.prod_lvl=b.prod_lvl 
and a.uniq_prod=b.uniq_prod and a.molecule_code=b.molecule_code and a.product_code=b.product_code and a.package_code=b.package_code
inner join tblOutput_Rx_TA_Rx_MAT_Inline c
on a.mkttype=c.mkttype and a.mkt=c.mkt and a.market_name=c.market_name and a.geo=c.geo and case when a.department is null then '' else a.department end=case when c.department is null then '' else c.department end 
and case when a.class is null then '' else a.class end=case when c.class is null then '' else c.class end and a.dept_lvl=c.dept_lvl and a.prod_lvl=c.prod_lvl 
and a.uniq_prod=c.uniq_prod and a.molecule_code=c.molecule_code and a.product_code=c.product_code and a.package_code=c.package_code
inner join tblOutput_Rx_TA_Volume_MAT_Inline d
on a.mkttype=d.mkttype and a.mkt=d.mkt and a.market_name=d.market_name and a.geo=d.geo and case when a.department is null then '' else a.department end=case when d.department is null then '' else d.department end 
and case when a.class is null then '' else a.class end=case when d.class is null then '' else d.class end and a.dept_lvl=d.dept_lvl and a.prod_lvl=d.prod_lvl 
and a.uniq_prod=d.uniq_prod and a.molecule_code=d.molecule_code and a.product_code=d.product_code and a.package_code=d.package_code
GO

--Pipeline
--3M:
IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_Rx_TA_3M_Pipeline')
DROP VIEW tblOutput_Rx_TA_3M_Pipeline
go
CREATE VIEW tblOutput_Rx_TA_3M_Pipeline
as

select 'Quarter' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.department,a.dept_code,a.class,a.class_name,a.dept_lvl,a.prod_lvl,a.uniq_prod,a.molecule_name,a.molecule_code,a.product_name,a.product_code,a.package_name,a.package_code,
a.VR_3M_20,a.VR_3M_19,a.VR_3M_18,a.VR_3M_17,a.VR_3M_16,a.VR_3M_15,a.VR_3M_14,a.VR_3M_13,a.VR_3M_12,a.VR_3M_11,a.VR_3M_10,a.VR_3M_9,a.VR_3M_8,a.VR_3M_7,a.VR_3M_6,a.VR_3M_5,a.VR_3M_4,a.VR_3M_3,a.VR_3M_2,a.VR_3M_1,
b.VU_3M_20,b.VU_3M_19,b.VU_3M_18,b.VU_3M_17,b.VU_3M_16,b.VU_3M_15,b.VU_3M_14,b.VU_3M_13,b.VU_3M_12,b.VU_3M_11,b.VU_3M_10,b.VU_3M_9,b.VU_3M_8,b.VU_3M_7,b.VU_3M_6,b.VU_3M_5,b.VU_3M_4,b.VU_3M_3,b.VU_3M_2,b.VU_3M_1,
c.Rx_3M_20,c.Rx_3M_19,c.Rx_3M_18,c.Rx_3M_17,c.Rx_3M_16,c.Rx_3M_15,c.Rx_3M_14,c.Rx_3M_13,c.Rx_3M_12,c.Rx_3M_11,c.Rx_3M_10,c.Rx_3M_9,c.Rx_3M_8,c.Rx_3M_7,c.Rx_3M_6,c.Rx_3M_5,c.Rx_3M_4,c.Rx_3M_3,c.Rx_3M_2,c.Rx_3M_1,
d.Un_3M_20,d.Un_3M_19,d.Un_3M_18,d.Un_3M_17,d.Un_3M_16,d.Un_3M_15,d.Un_3M_14,d.Un_3M_13,d.Un_3M_12,d.Un_3M_11,d.Un_3M_10,d.Un_3M_9,d.Un_3M_8,d.Un_3M_7,d.Un_3M_6,d.Un_3M_5,d.Un_3M_4,d.Un_3M_3,d.Un_3M_2,d.Un_3M_1
from tblOutput_Rx_TA_RMB_3M_Pipeline a
inner join tblOutput_Rx_TA_USD_3M_Pipeline b
on a.mkttype=b.mkttype and a.mkt=b.mkt and a.market_name=b.market_name and a.geo=b.geo and case when a.department is null then '' else a.department end=case when b.department is null then '' else b.department end 
and case when a.class is null then '' else a.class end=case when b.class is null then '' else b.class end and a.dept_lvl=b.dept_lvl and a.prod_lvl=b.prod_lvl 
and a.uniq_prod=b.uniq_prod and a.molecule_code=b.molecule_code and a.product_code=b.product_code and a.package_code=b.package_code
inner join tblOutput_Rx_TA_Rx_3M_Pipeline c
on a.mkttype=c.mkttype and a.mkt=c.mkt and a.market_name=c.market_name and a.geo=c.geo and case when a.department is null then '' else a.department end=case when c.department is null then '' else c.department end 
and case when a.class is null then '' else a.class end=case when c.class is null then '' else c.class end and a.dept_lvl=c.dept_lvl and a.prod_lvl=c.prod_lvl 
and a.uniq_prod=c.uniq_prod and a.molecule_code=c.molecule_code and a.product_code=c.product_code and a.package_code=c.package_code
inner join tblOutput_Rx_TA_Volume_3M_Pipeline d
on a.mkttype=d.mkttype and a.mkt=d.mkt and a.market_name=d.market_name and a.geo=d.geo and case when a.department is null then '' else a.department end=case when d.department is null then '' else d.department end 
and case when a.class is null then '' else a.class end=case when d.class is null then '' else d.class end and a.dept_lvl=d.dept_lvl and a.prod_lvl=d.prod_lvl 
and a.uniq_prod=d.uniq_prod and a.molecule_code=d.molecule_code and a.product_code=d.product_code and a.package_code=d.package_code
GO



--MAT:
IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_Rx_TA_MAT_Pipeline')
DROP VIEW tblOutput_Rx_TA_MAT_Pipeline
go
CREATE VIEW tblOutput_Rx_TA_MAT_Pipeline
as

select 'MAT' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.department,a.dept_code,a.class,a.class_name,a.dept_lvl,a.prod_lvl,a.uniq_prod,a.molecule_name,a.molecule_code,a.product_name,a.product_code,a.package_name,a.package_code,
a.VR_MAT_20,a.VR_MAT_19,a.VR_MAT_18,a.VR_MAT_17,a.VR_MAT_16,a.VR_MAT_15,a.VR_MAT_14,a.VR_MAT_13,a.VR_MAT_12,a.VR_MAT_11,a.VR_MAT_10,a.VR_MAT_9,a.VR_MAT_8,a.VR_MAT_7,a.VR_MAT_6,a.VR_MAT_5,a.VR_MAT_4,a.VR_MAT_3,a.VR_MAT_2,a.VR_MAT_1,
b.VU_MAT_20,b.VU_MAT_19,b.VU_MAT_18,b.VU_MAT_17,b.VU_MAT_16,b.VU_MAT_15,b.VU_MAT_14,b.VU_MAT_13,b.VU_MAT_12,b.VU_MAT_11,b.VU_MAT_10,b.VU_MAT_9,b.VU_MAT_8,b.VU_MAT_7,b.VU_MAT_6,b.VU_MAT_5,b.VU_MAT_4,b.VU_MAT_3,b.VU_MAT_2,b.VU_MAT_1,
c.Rx_MAT_20,c.Rx_MAT_19,c.Rx_MAT_18,c.Rx_MAT_17,c.Rx_MAT_16,c.Rx_MAT_15,c.Rx_MAT_14,c.Rx_MAT_13,c.Rx_MAT_12,c.Rx_MAT_11,c.Rx_MAT_10,c.Rx_MAT_9,c.Rx_MAT_8,c.Rx_MAT_7,c.Rx_MAT_6,c.Rx_MAT_5,c.Rx_MAT_4,c.Rx_MAT_3,c.Rx_MAT_2,c.Rx_MAT_1,
d.Un_MAT_20,d.Un_MAT_19,d.Un_MAT_18,d.Un_MAT_17,d.Un_MAT_16,d.Un_MAT_15,d.Un_MAT_14,d.Un_MAT_13,d.Un_MAT_12,d.Un_MAT_11,d.Un_MAT_10,d.Un_MAT_9,d.Un_MAT_8,d.Un_MAT_7,d.Un_MAT_6,d.Un_MAT_5,d.Un_MAT_4,d.Un_MAT_3,d.Un_MAT_2,d.Un_MAT_1
from tblOutput_Rx_TA_RMB_MAT_Pipeline a
inner join tblOutput_Rx_TA_USD_MAT_Pipeline b
on a.mkttype=b.mkttype and a.mkt=b.mkt and a.market_name=b.market_name and a.geo=b.geo and case when a.department is null then '' else a.department end=case when b.department is null then '' else b.department end 
and case when a.class is null then '' else a.class end=case when b.class is null then '' else b.class end and a.dept_lvl=b.dept_lvl and a.prod_lvl=b.prod_lvl 
and a.uniq_prod=b.uniq_prod and a.molecule_code=b.molecule_code and a.product_code=b.product_code and a.package_code=b.package_code
inner join tblOutput_Rx_TA_Rx_MAT_Pipeline c
on a.mkttype=c.mkttype and a.mkt=c.mkt and a.market_name=c.market_name and a.geo=c.geo and case when a.department is null then '' else a.department end=case when c.department is null then '' else c.department end 
and case when a.class is null then '' else a.class end=case when c.class is null then '' else c.class end and a.dept_lvl=c.dept_lvl and a.prod_lvl=c.prod_lvl 
and a.uniq_prod=c.uniq_prod and a.molecule_code=c.molecule_code and a.product_code=c.product_code and a.package_code=c.package_code
inner join tblOutput_Rx_TA_Volume_MAT_Pipeline d
on a.mkttype=d.mkttype and a.mkt=d.mkt and a.market_name=d.market_name and a.geo=d.geo and case when a.department is null then '' else a.department end=case when d.department is null then '' else d.department end 
and case when a.class is null then '' else a.class end=case when d.class is null then '' else d.class end and a.dept_lvl=d.dept_lvl and a.prod_lvl=d.prod_lvl 
and a.uniq_prod=d.uniq_prod and a.molecule_code=d.molecule_code and a.product_code=d.product_code and a.package_code=d.package_code
GO



--Global
--3M:
IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_Rx_TA_3M_Global')
DROP VIEW tblOutput_Rx_TA_3M_Global
go
CREATE VIEW tblOutput_Rx_TA_3M_Global
as

select 'Quarter' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.department,a.dept_code,a.class,a.class_name,a.dept_lvl,a.prod_lvl,a.uniq_prod,a.molecule_name,a.molecule_code,a.product_name,a.product_code,a.package_name,a.package_code,
a.VR_3M_20,a.VR_3M_19,a.VR_3M_18,a.VR_3M_17,a.VR_3M_16,a.VR_3M_15,a.VR_3M_14,a.VR_3M_13,a.VR_3M_12,a.VR_3M_11,a.VR_3M_10,a.VR_3M_9,a.VR_3M_8,a.VR_3M_7,a.VR_3M_6,a.VR_3M_5,a.VR_3M_4,a.VR_3M_3,a.VR_3M_2,a.VR_3M_1,
b.VU_3M_20,b.VU_3M_19,b.VU_3M_18,b.VU_3M_17,b.VU_3M_16,b.VU_3M_15,b.VU_3M_14,b.VU_3M_13,b.VU_3M_12,b.VU_3M_11,b.VU_3M_10,b.VU_3M_9,b.VU_3M_8,b.VU_3M_7,b.VU_3M_6,b.VU_3M_5,b.VU_3M_4,b.VU_3M_3,b.VU_3M_2,b.VU_3M_1,
c.Rx_3M_20,c.Rx_3M_19,c.Rx_3M_18,c.Rx_3M_17,c.Rx_3M_16,c.Rx_3M_15,c.Rx_3M_14,c.Rx_3M_13,c.Rx_3M_12,c.Rx_3M_11,c.Rx_3M_10,c.Rx_3M_9,c.Rx_3M_8,c.Rx_3M_7,c.Rx_3M_6,c.Rx_3M_5,c.Rx_3M_4,c.Rx_3M_3,c.Rx_3M_2,c.Rx_3M_1,
d.Un_3M_20,d.Un_3M_19,d.Un_3M_18,d.Un_3M_17,d.Un_3M_16,d.Un_3M_15,d.Un_3M_14,d.Un_3M_13,d.Un_3M_12,d.Un_3M_11,d.Un_3M_10,d.Un_3M_9,d.Un_3M_8,d.Un_3M_7,d.Un_3M_6,d.Un_3M_5,d.Un_3M_4,d.Un_3M_3,d.Un_3M_2,d.Un_3M_1
from tblOutput_Rx_TA_RMB_3M_Global a
inner join tblOutput_Rx_TA_USD_3M_Global b
on a.mkttype=b.mkttype and a.mkt=b.mkt and a.geo=b.geo and case when a.dept_code is null then '' else a.dept_code end=case when b.dept_code is null then '' else b.dept_code end
and a.prod_lvl=b.prod_lvl and a.molecule_code=b.molecule_code and a.product_code=b.product_code and a.package_code=b.package_code
inner join tblOutput_Rx_TA_Rx_3M_Global c
on a.mkttype=c.mkttype and a.mkt=c.mkt and a.geo=c.geo and case when a.dept_code is null then '' else a.dept_code end=case when c.dept_code is null then '' else c.dept_code end
and a.prod_lvl=c.prod_lvl and a.molecule_code=c.molecule_code and a.product_code=c.product_code and a.package_code=c.package_code
inner join tblOutput_Rx_TA_Volume_3M_Global d
on a.mkttype=d.mkttype and a.mkt=d.mkt and a.geo=d.geo and case when a.dept_code is null then '' else a.dept_code end=case when d.dept_code is null then '' else d.dept_code end
and a.prod_lvl=d.prod_lvl and a.molecule_code=d.molecule_code and a.product_code=d.product_code and a.package_code=d.package_code
GO


--MAT:
IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_Rx_TA_MAT_Global')
DROP VIEW tblOutput_Rx_TA_MAT_Global
go
CREATE VIEW tblOutput_Rx_TA_MAT_Global
as

select 'MAT' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.department,a.dept_code,a.class,a.class_name,a.dept_lvl,a.prod_lvl,a.uniq_prod,a.molecule_name,a.molecule_code,a.product_name,a.product_code,a.package_name,a.package_code,
a.VR_MAT_20,a.VR_MAT_19,a.VR_MAT_18,a.VR_MAT_17,a.VR_MAT_16,a.VR_MAT_15,a.VR_MAT_14,a.VR_MAT_13,a.VR_MAT_12,a.VR_MAT_11,a.VR_MAT_10,a.VR_MAT_9,a.VR_MAT_8,a.VR_MAT_7,a.VR_MAT_6,a.VR_MAT_5,a.VR_MAT_4,a.VR_MAT_3,a.VR_MAT_2,a.VR_MAT_1,
b.VU_MAT_20,b.VU_MAT_19,b.VU_MAT_18,b.VU_MAT_17,b.VU_MAT_16,b.VU_MAT_15,b.VU_MAT_14,b.VU_MAT_13,b.VU_MAT_12,b.VU_MAT_11,b.VU_MAT_10,b.VU_MAT_9,b.VU_MAT_8,b.VU_MAT_7,b.VU_MAT_6,b.VU_MAT_5,b.VU_MAT_4,b.VU_MAT_3,b.VU_MAT_2,b.VU_MAT_1,
c.Rx_MAT_20,c.Rx_MAT_19,c.Rx_MAT_18,c.Rx_MAT_17,c.Rx_MAT_16,c.Rx_MAT_15,c.Rx_MAT_14,c.Rx_MAT_13,c.Rx_MAT_12,c.Rx_MAT_11,c.Rx_MAT_10,c.Rx_MAT_9,c.Rx_MAT_8,c.Rx_MAT_7,c.Rx_MAT_6,c.Rx_MAT_5,c.Rx_MAT_4,c.Rx_MAT_3,c.Rx_MAT_2,c.Rx_MAT_1,
d.Un_MAT_20,d.Un_MAT_19,d.Un_MAT_18,d.Un_MAT_17,d.Un_MAT_16,d.Un_MAT_15,d.Un_MAT_14,d.Un_MAT_13,d.Un_MAT_12,d.Un_MAT_11,d.Un_MAT_10,d.Un_MAT_9,d.Un_MAT_8,d.Un_MAT_7,d.Un_MAT_6,d.Un_MAT_5,d.Un_MAT_4,d.Un_MAT_3,d.Un_MAT_2,d.Un_MAT_1
from tblOutput_Rx_TA_RMB_MAT_Global a
inner join tblOutput_Rx_TA_USD_MAT_Global b
on a.mkttype=b.mkttype and a.mkt=b.mkt and a.geo=b.geo and case when a.dept_code is null then '' else a.dept_code end=case when b.dept_code is null then '' else b.dept_code end
and a.prod_lvl=b.prod_lvl and a.molecule_code=b.molecule_code and a.product_code=b.product_code and a.package_code=b.package_code
inner join tblOutput_Rx_TA_Rx_MAT_Global c
on a.mkttype=c.mkttype and a.mkt=c.mkt and a.geo=c.geo and case when a.dept_code is null then '' else a.dept_code end=case when c.dept_code is null then '' else c.dept_code end
and a.prod_lvl=c.prod_lvl and a.molecule_code=c.molecule_code and a.product_code=c.product_code and a.package_code=c.package_code
inner join tblOutput_Rx_TA_Volume_MAT_Global d
on a.mkttype=d.mkttype and a.mkt=d.mkt and a.geo=d.geo and case when a.dept_code is null then '' else a.dept_code end=case when d.dept_code is null then '' else d.dept_code end
and a.prod_lvl=d.prod_lvl and a.molecule_code=d.molecule_code and a.product_code=d.product_code and a.package_code=d.package_code
GO

exec BMSCNProc2_test.dbo.sp_Log_Event 'Output','QT_Rx','99_Output_Rx.sql','End',null,null
