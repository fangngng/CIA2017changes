use BMSChinaQueryToolNew_test
go
exec BMSCNProc2.dbo.sp_Log_Event 'output','QT_MAX','99_Output_MAX.sql','Start',null,null


print '--tblOutput_MAX_ATC_RMB_MAT'
if object_id(N'tblOutput_MAX_ATC_RMB_MAT',N'U') is not null
	drop table tblOutput_MAX_ATC_RMB_MAT
go
select * into tblOutput_MAX_ATC_RMB_MAT
from BMSCNProc2.dbo.tblOutput_MAX_ATC_RMB_MAT
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_ATC_RMB_MAT')
	drop index idx_tblOutput_MAX_ATC_RMB_MAT on tblOutput_MAX_ATC_RMB_MAT
go
CREATE CLUSTERED INDEX idx_tblOutput_MAX_ATC_RMB_MAT ON [dbo].tblOutput_MAX_ATC_RMB_MAT 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]


	
print '--tblOutput_MAX_ATC_RMB_MQT'
if object_id(N'tblOutput_MAX_ATC_RMB_MQT',N'U') is not null
	drop table tblOutput_MAX_ATC_RMB_MQT
go
select * into tblOutput_MAX_ATC_RMB_MQT
from BMSCNProc2.dbo.tblOutput_MAX_ATC_RMB_MQT
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_ATC_RMB_MQT')
	drop index idx_tblOutput_MAX_ATC_RMB_MQT on tblOutput_MAX_ATC_RMB_MQT
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_ATC_RMB_MQT ON [dbo].tblOutput_MAX_ATC_RMB_MQT 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_ATC_RMB_MTH'
if object_id(N'tblOutput_MAX_ATC_RMB_MTH',N'U') is not null
	drop table tblOutput_MAX_ATC_RMB_MTH
go
select * into tblOutput_MAX_ATC_RMB_MTH
from BMSCNProc2.dbo.tblOutput_MAX_ATC_RMB_MTH
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_ATC_RMB_MTH')
drop index idx_tblOutput_MAX_ATC_RMB_MTH on tblOutput_MAX_ATC_RMB_MTH
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_ATC_RMB_MTH ON [dbo].tblOutput_MAX_ATC_RMB_MTH 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
print '--tblOutput_MAX_ATC_UNT_MAT'
if object_id(N'tblOutput_MAX_ATC_UNT_MAT',N'U') is not null
	drop table tblOutput_MAX_ATC_UNT_MAT
go
select * into tblOutput_MAX_ATC_UNT_MAT
from BMSCNProc2.dbo.tblOutput_MAX_ATC_UNT_MAT
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_ATC_UNT_MAT')
	drop index idx_tblOutput_MAX_ATC_UNT_MAT on tblOutput_MAX_ATC_UNT_MAT
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_ATC_UNT_MAT ON [dbo].tblOutput_MAX_ATC_UNT_MAT 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
print '--tblOutput_MAX_ATC_UNT_MQT'
if object_id(N'tblOutput_MAX_ATC_UNT_MQT',N'U') is not null
	drop table tblOutput_MAX_ATC_UNT_MQT
go
select * into tblOutput_MAX_ATC_UNT_MQT
from BMSCNProc2.dbo.tblOutput_MAX_ATC_UNT_MQT
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_ATC_UNT_MQT')
	drop index idx_tblOutput_MAX_ATC_UNT_MQT on tblOutput_MAX_ATC_UNT_MQT
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_ATC_UNT_MQT ON [dbo].tblOutput_MAX_ATC_UNT_MQT 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
print '--tblOutput_MAX_ATC_UNT_MTH'
if object_id(N'tblOutput_MAX_ATC_UNT_MTH',N'U') is not null
	drop table tblOutput_MAX_ATC_UNT_MTH
go
select * into tblOutput_MAX_ATC_UNT_MTH
from BMSCNProc2.dbo.tblOutput_MAX_ATC_UNT_MTH
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_ATC_UNT_MTH')
	drop index idx_tblOutput_MAX_ATC_UNT_MTH on tblOutput_MAX_ATC_UNT_MTH
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_ATC_UNT_MTH ON [dbo].tblOutput_MAX_ATC_UNT_MTH 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
print '--tblOutput_MAX_ATC_USD_MAT'
if object_id(N'tblOutput_MAX_ATC_USD_MAT',N'U') is not null
	drop table tblOutput_MAX_ATC_USD_MAT
go
select * into tblOutput_MAX_ATC_USD_MAT
from BMSCNProc2.dbo.tblOutput_MAX_ATC_USD_MAT
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_ATC_USD_MAT')
	drop index idx_tblOutput_MAX_ATC_USD_MAT on tblOutput_MAX_ATC_USD_MAT
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_ATC_USD_MAT ON [dbo].tblOutput_MAX_ATC_USD_MAT 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
print '--tblOutput_MAX_ATC_USD_MQT'
if object_id(N'tblOutput_MAX_ATC_USD_MQT',N'U') is not null
	drop table tblOutput_MAX_ATC_USD_MQT
go
select * into tblOutput_MAX_ATC_USD_MQT
from BMSCNProc2.dbo.tblOutput_MAX_ATC_USD_MQT
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_ATC_USD_MQT')
	drop index idx_tblOutput_MAX_ATC_USD_MQT on tblOutput_MAX_ATC_USD_MQT
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_ATC_USD_MQT ON [dbo].tblOutput_MAX_ATC_USD_MQT 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
print '--tblOutput_MAX_ATC_USD_MTH'
if object_id(N'tblOutput_MAX_ATC_USD_MTH',N'U') is not null
	drop table tblOutput_MAX_ATC_USD_MTH
go
select * into tblOutput_MAX_ATC_USD_MTH
from BMSCNProc2.dbo.tblOutput_MAX_ATC_USD_MTH
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_ATC_USD_MTH')
	drop index idx_tblOutput_MAX_ATC_USD_MTH on tblOutput_MAX_ATC_USD_MTH
go
CREATE CLUSTERED INDEX idx_tblOutput_MAX_ATC_USD_MTH ON [dbo].tblOutput_MAX_ATC_USD_MTH 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_RMB_MAT_Global'
if object_id(N'tblOutput_MAX_TA_RMB_MAT_Global',N'U') is not null
	drop table tblOutput_MAX_TA_RMB_MAT_Global
go
select * into tblOutput_MAX_TA_RMB_MAT_Global
from BMSCNProc2.dbo.tblOutput_MAX_TA_RMB_MAT_Global
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_RMB_MAT_Global')
	drop index idx_tblOutput_MAX_TA_RMB_MAT_Global on tblOutput_MAX_TA_RMB_MAT_Global
go
CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_RMB_MAT_Global ON [dbo].tblOutput_MAX_TA_RMB_MAT_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
print '--tblOutput_MAX_TA_RMB_MAT_Inline'
if object_id(N'tblOutput_MAX_TA_RMB_MAT_Inline',N'U') is not null
	drop table tblOutput_MAX_TA_RMB_MAT_Inline
go
select * into tblOutput_MAX_TA_RMB_MAT_Inline
from BMSCNProc2.dbo.tblOutput_MAX_TA_RMB_MAT_Inline
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_RMB_MAT_Inline')
	drop index idx_tblOutput_MAX_TA_RMB_MAT_Inline on tblOutput_MAX_TA_RMB_MAT_Inline
go
CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_RMB_MAT_Inline ON [dbo].tblOutput_MAX_TA_RMB_MAT_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
	
print '--tblOutput_MAX_TA_Master_Inline_Mkt'
if object_id(N'tblOutput_MAX_TA_Master_Inline_Mkt',N'U') is not null
	drop table tblOutput_MAX_TA_Master_Inline_Mkt
go
select * into tblOutput_MAX_TA_Master_Inline_Mkt
from BMSCNProc2.dbo.tblOutput_MAX_TA_Master_Inline_Mkt
go
print '--tblOutput_MAX_TA_RMB_MQT_Global'
if object_id(N'tblOutput_MAX_TA_RMB_MQT_Global',N'U') is not null
	drop table tblOutput_MAX_TA_RMB_MQT_Global
go
select * into tblOutput_MAX_TA_RMB_MQT_Global
from BMSCNProc2.dbo.tblOutput_MAX_TA_RMB_MQT_Global
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_RMB_MQT_Global')
	drop index idx_tblOutput_MAX_TA_RMB_MQT_Global on tblOutput_MAX_TA_RMB_MQT_Global
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_RMB_MQT_Global ON [dbo].tblOutput_MAX_TA_RMB_MQT_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_RMB_MQT_Inline'
if object_id(N'tblOutput_MAX_TA_RMB_MQT_Inline',N'U') is not null
	drop table tblOutput_MAX_TA_RMB_MQT_Inline
go
select * into tblOutput_MAX_TA_RMB_MQT_Inline
from BMSCNProc2.dbo.tblOutput_MAX_TA_RMB_MQT_Inline
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_RMB_MQT_Inline')
	drop index idx_tblOutput_MAX_TA_RMB_MQT_Inline on tblOutput_MAX_TA_RMB_MQT_Inline
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_RMB_MQT_Inline ON [dbo].tblOutput_MAX_TA_RMB_MQT_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_RMB_MTH_Global'
if object_id(N'tblOutput_MAX_TA_RMB_MTH_Global',N'U') is not null
	drop table tblOutput_MAX_TA_RMB_MTH_Global
go
select * into tblOutput_MAX_TA_RMB_MTH_Global
from BMSCNProc2.dbo.tblOutput_MAX_TA_RMB_MTH_Global
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_RMB_MTH_Global')
	drop index idx_tblOutput_MAX_TA_RMB_MTH_Global on tblOutput_MAX_TA_RMB_MTH_Global
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_RMB_MTH_Global ON [dbo].tblOutput_MAX_TA_RMB_MTH_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_RMB_MTH_Inline'
if object_id(N'tblOutput_MAX_TA_RMB_MTH_Inline',N'U') is not null
	drop table tblOutput_MAX_TA_RMB_MTH_Inline
go
select * into tblOutput_MAX_TA_RMB_MTH_Inline
from BMSCNProc2.dbo.tblOutput_MAX_TA_RMB_MTH_Inline
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_RMB_MTH_Inline')
    drop index idx_tblOutput_MAX_TA_RMB_MTH_Inline on tblOutput_MAX_TA_RMB_MTH_Inline
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_RMB_MTH_Inline ON [dbo].tblOutput_MAX_TA_RMB_MTH_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_UNT_MAT_Global'
if object_id(N'tblOutput_MAX_TA_UNT_MAT_Global',N'U') is not null
	drop table tblOutput_MAX_TA_UNT_MAT_Global
go
select * into tblOutput_MAX_TA_UNT_MAT_Global
from BMSCNProc2.dbo.tblOutput_MAX_TA_UNT_MAT_Global
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_UNT_MAT_Global')
drop index idx_tblOutput_MAX_TA_UNT_MAT_Global on tblOutput_MAX_TA_UNT_MAT_Global
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_UNT_MAT_Global ON [dbo].tblOutput_MAX_TA_UNT_MAT_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_UNT_MAT_Inline'
if object_id(N'tblOutput_MAX_TA_UNT_MAT_Inline',N'U') is not null
	drop table tblOutput_MAX_TA_UNT_MAT_Inline
go
select * into tblOutput_MAX_TA_UNT_MAT_Inline
from BMSCNProc2.dbo.tblOutput_MAX_TA_UNT_MAT_Inline
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_UNT_MAT_Inline')
drop index idx_tblOutput_MAX_TA_UNT_MAT_Inline on tblOutput_MAX_TA_UNT_MAT_Inline
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_UNT_MAT_Inline ON [dbo].tblOutput_MAX_TA_UNT_MAT_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_UNT_MQT_Global'
if object_id(N'tblOutput_MAX_TA_UNT_MQT_Global',N'U') is not null
	drop table tblOutput_MAX_TA_UNT_MQT_Global
go
select * into tblOutput_MAX_TA_UNT_MQT_Global
from BMSCNProc2.dbo.tblOutput_MAX_TA_UNT_MQT_Global
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_UNT_MQT_Global')
drop index idx_tblOutput_MAX_TA_UNT_MQT_Global on tblOutput_MAX_TA_UNT_MQT_Global
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_UNT_MQT_Global ON [dbo].tblOutput_MAX_TA_UNT_MQT_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_UNT_MQT_Inline'
if object_id(N'tblOutput_MAX_TA_UNT_MQT_Inline',N'U') is not null
	drop table tblOutput_MAX_TA_UNT_MQT_Inline
go
select * into tblOutput_MAX_TA_UNT_MQT_Inline
from BMSCNProc2.dbo.tblOutput_MAX_TA_UNT_MQT_Inline
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_UNT_MQT_Inline')
drop index idx_tblOutput_MAX_TA_UNT_MQT_Inline on tblOutput_MAX_TA_UNT_MQT_Inline
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_UNT_MQT_Inline ON [dbo].tblOutput_MAX_TA_UNT_MQT_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_UNT_MTH_Global'
if object_id(N'tblOutput_MAX_TA_UNT_MTH_Global',N'U') is not null
	drop table tblOutput_MAX_TA_UNT_MTH_Global
go
select * into tblOutput_MAX_TA_UNT_MTH_Global
from BMSCNProc2.dbo.tblOutput_MAX_TA_UNT_MTH_Global
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_UNT_MTH_Global')
drop index idx_tblOutput_MAX_TA_UNT_MTH_Global on tblOutput_MAX_TA_UNT_MTH_Global
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_UNT_MTH_Global ON [dbo].tblOutput_MAX_TA_UNT_MTH_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_UNT_MTH_Inline'
if object_id(N'tblOutput_MAX_TA_UNT_MTH_Inline',N'U') is not null
	drop table tblOutput_MAX_TA_UNT_MTH_Inline
go
select * into tblOutput_MAX_TA_UNT_MTH_Inline
from BMSCNProc2.dbo.tblOutput_MAX_TA_UNT_MTH_Inline
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_UNT_MTH_Inline')
drop index idx_tblOutput_MAX_TA_UNT_MTH_Inline on tblOutput_MAX_TA_UNT_MTH_Inline
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_UNT_MTH_Inline ON [dbo].tblOutput_MAX_TA_UNT_MTH_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_USD_MAT_Global'
if object_id(N'tblOutput_MAX_TA_USD_MAT_Global',N'U') is not null
	drop table tblOutput_MAX_TA_USD_MAT_Global
go
select * into tblOutput_MAX_TA_USD_MAT_Global
from BMSCNProc2.dbo.tblOutput_MAX_TA_USD_MAT_Global
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_USD_MAT_Global')
drop index idx_tblOutput_MAX_TA_USD_MAT_Global on tblOutput_MAX_TA_USD_MAT_Global
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_USD_MAT_Global ON [dbo].tblOutput_MAX_TA_USD_MAT_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_USD_MAT_Inline'
if object_id(N'tblOutput_MAX_TA_USD_MAT_Inline',N'U') is not null
	drop table tblOutput_MAX_TA_USD_MAT_Inline
go
select * into tblOutput_MAX_TA_USD_MAT_Inline
from BMSCNProc2.dbo.tblOutput_MAX_TA_USD_MAT_Inline
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_USD_MAT_Inline')
drop index idx_tblOutput_MAX_TA_USD_MAT_Inline on tblOutput_MAX_TA_USD_MAT_Inline
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_USD_MAT_Inline ON [dbo].tblOutput_MAX_TA_USD_MAT_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_USD_MQT_Global'
if object_id(N'tblOutput_MAX_TA_USD_MQT_Global',N'U') is not null
	drop table tblOutput_MAX_TA_USD_MQT_Global
go
select * into tblOutput_MAX_TA_USD_MQT_Global
from BMSCNProc2.dbo.tblOutput_MAX_TA_USD_MQT_Global
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_USD_MQT_Global')
drop index idx_tblOutput_MAX_TA_USD_MQT_Global on tblOutput_MAX_TA_USD_MQT_Global
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_USD_MQT_Global ON [dbo].tblOutput_MAX_TA_USD_MQT_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_USD_MQT_Inline'
if object_id(N'tblOutput_MAX_TA_USD_MQT_Inline',N'U') is not null
	drop table tblOutput_MAX_TA_USD_MQT_Inline
go
select * into tblOutput_MAX_TA_USD_MQT_Inline
from BMSCNProc2.dbo.tblOutput_MAX_TA_USD_MQT_Inline
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_USD_MQT_Inline')
drop index idx_tblOutput_MAX_TA_USD_MQT_Inline on tblOutput_MAX_TA_USD_MQT_Inline
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_USD_MQT_Inline ON [dbo].tblOutput_MAX_TA_USD_MQT_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_USD_MTH_Global'
if object_id(N'tblOutput_MAX_TA_USD_MTH_Global',N'U') is not null
	drop table tblOutput_MAX_TA_USD_MTH_Global
go
select * into tblOutput_MAX_TA_USD_MTH_Global
from BMSCNProc2.dbo.tblOutput_MAX_TA_USD_MTH_Global
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_USD_MTH_Global')
drop index idx_tblOutput_MAX_TA_USD_MTH_Global on tblOutput_MAX_TA_USD_MTH_Global
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_USD_MTH_Global ON [dbo].tblOutput_MAX_TA_USD_MTH_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_USD_MTH_Inline'
if object_id(N'tblOutput_MAX_TA_USD_MTH_Inline',N'U') is not null
	drop table tblOutput_MAX_TA_USD_MTH_Inline
go
select * into tblOutput_MAX_TA_USD_MTH_Inline
from BMSCNProc2.dbo.tblOutput_MAX_TA_USD_MTH_Inline
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_USD_MTH_Inline')
drop index idx_tblOutput_MAX_TA_USD_MTH_Inline on tblOutput_MAX_TA_USD_MTH_Inline
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_USD_MTH_Inline ON [dbo].tblOutput_MAX_TA_USD_MTH_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]







--YTD
print '--tblOutput_MAX_TA_RMB_YTD_Inline'
if object_id(N'tblOutput_MAX_TA_RMB_YTD_Inline',N'U') is not null
	drop table tblOutput_MAX_TA_RMB_YTD_Inline
go
select * into tblOutput_MAX_TA_RMB_YTD_Inline
from BMSCNProc2.dbo.tblOutput_MAX_TA_RMB_YTD_Inline
go

if exists(select * from sysindexes where name='idx_tblOutput_MAX_TA_RMB_YTD_Inline')
drop index idx_tblOutput_MAX_TA_RMB_YTD_Inline on tblOutput_MAX_TA_RMB_YTD_Inline
go
    CREATE CLUSTERED INDEX idx_tblOutput_MAX_TA_RMB_YTD_Inline ON [dbo].tblOutput_MAX_TA_RMB_YTD_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]


print '--tblOutput_MAX_TA_USD_YTD_Inline'
if object_id(N'tblOutput_MAX_TA_USD_YTD_Inline',N'U') is not null
	drop table tblOutput_MAX_TA_USD_YTD_Inline
go
select * into tblOutput_MAX_TA_USD_YTD_Inline
from BMSCNProc2.dbo.tblOutput_MAX_TA_USD_YTD_Inline
go

if exists(select * from sysindexes where name='tblOutput_MAX_TA_USD_YTD_Inline')
drop index tblOutput_MAX_TA_USD_YTD_Inline on tblOutput_MAX_TA_USD_YTD_Inline
go
    CREATE CLUSTERED INDEX tblOutput_MAX_TA_USD_YTD_Inline ON [dbo].tblOutput_MAX_TA_USD_YTD_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_UNT_YTD_Inline'
if object_id(N'tblOutput_MAX_TA_UNT_YTD_Inline',N'U') is not null
	drop table tblOutput_MAX_TA_UNT_YTD_Inline
go
select * into tblOutput_MAX_TA_UNT_YTD_Inline
from BMSCNProc2.dbo.tblOutput_MAX_TA_UNT_YTD_Inline
go

if exists(select * from sysindexes where name='tblOutput_MAX_TA_UNT_YTD_Inline')
drop index tblOutput_MAX_TA_UNT_YTD_Inline on tblOutput_MAX_TA_UNT_YTD_Inline
go
    CREATE CLUSTERED INDEX tblOutput_MAX_TA_UNT_YTD_Inline ON [dbo].tblOutput_MAX_TA_UNT_YTD_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_RMB_YTD_Global'
if object_id(N'tblOutput_MAX_TA_RMB_YTD_Global',N'U') is not null
	drop table tblOutput_MAX_TA_RMB_YTD_Global
go
select * into tblOutput_MAX_TA_RMB_YTD_Global
from BMSCNProc2.dbo.tblOutput_MAX_TA_RMB_YTD_Global
go

if exists(select * from sysindexes where name='tblOutput_MAX_TA_RMB_YTD_Global')
drop index tblOutput_MAX_TA_RMB_YTD_Global on tblOutput_MAX_TA_RMB_YTD_Global
go
    CREATE CLUSTERED INDEX tblOutput_MAX_TA_RMB_YTD_Global ON [dbo].tblOutput_MAX_TA_RMB_YTD_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_USD_YTD_Global'
if object_id(N'tblOutput_MAX_TA_USD_YTD_Global',N'U') is not null
	drop table tblOutput_MAX_TA_USD_YTD_Global
go
select * into tblOutput_MAX_TA_USD_YTD_Global
from BMSCNProc2.dbo.tblOutput_MAX_TA_USD_YTD_Global
go

if exists(select * from sysindexes where name='tblOutput_MAX_TA_USD_YTD_Global')
drop index tblOutput_MAX_TA_USD_YTD_Global on tblOutput_MAX_TA_USD_YTD_Global
go
    CREATE CLUSTERED INDEX tblOutput_MAX_TA_USD_YTD_Global ON [dbo].tblOutput_MAX_TA_USD_YTD_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_TA_UNT_YTD_Global'
if object_id(N'tblOutput_MAX_TA_UNT_YTD_Global',N'U') is not null
	drop table tblOutput_MAX_TA_UNT_YTD_Global
go
select * into tblOutput_MAX_TA_UNT_YTD_Global
from BMSCNProc2.dbo.tblOutput_MAX_TA_UNT_YTD_Global
go

if exists(select * from sysindexes where name='tblOutput_MAX_TA_UNT_YTD_Global')
drop index tblOutput_MAX_TA_UNT_YTD_Global on tblOutput_MAX_TA_UNT_YTD_Global
go
    CREATE CLUSTERED INDEX tblOutput_MAX_TA_UNT_YTD_Global ON [dbo].tblOutput_MAX_TA_UNT_YTD_Global 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_ATC_RMB_YTD'
if object_id(N'tblOutput_MAX_ATC_RMB_YTD',N'U') is not null
	drop table tblOutput_MAX_ATC_RMB_YTD
go
select * into tblOutput_MAX_ATC_RMB_YTD
from BMSCNProc2.dbo.tblOutput_MAX_ATC_RMB_YTD
go

if exists(select * from sysindexes where name='tblOutput_MAX_ATC_RMB_YTD')
drop index tblOutput_MAX_ATC_RMB_YTD on tblOutput_MAX_ATC_RMB_YTD
go
    CREATE CLUSTERED INDEX tblOutput_MAX_ATC_RMB_YTD ON [dbo].tblOutput_MAX_ATC_RMB_YTD 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_ATC_USD_YTD'
if object_id(N'tblOutput_MAX_ATC_USD_YTD',N'U') is not null
	drop table tblOutput_MAX_ATC_USD_YTD
go
select * into tblOutput_MAX_ATC_USD_YTD
from BMSCNProc2.dbo.tblOutput_MAX_ATC_USD_YTD
go

if exists(select * from sysindexes where name='tblOutput_MAX_ATC_USD_YTD')
drop index tblOutput_MAX_ATC_USD_YTD on tblOutput_MAX_ATC_USD_YTD
go
    CREATE CLUSTERED INDEX tblOutput_MAX_ATC_USD_YTD ON [dbo].tblOutput_MAX_ATC_USD_YTD 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

print '--tblOutput_MAX_ATC_UNT_YTD'
if object_id(N'tblOutput_MAX_ATC_UNT_YTD',N'U') is not null
	drop table tblOutput_MAX_ATC_UNT_YTD
go
select * into tblOutput_MAX_ATC_UNT_YTD
from BMSCNProc2.dbo.tblOutput_MAX_ATC_UNT_YTD
go

if exists(select * from sysindexes where name='tblOutput_MAX_ATC_UNT_YTD')
drop index tblOutput_MAX_ATC_UNT_YTD on tblOutput_MAX_ATC_UNT_YTD
go
    CREATE CLUSTERED INDEX tblOutput_MAX_ATC_UNT_YTD ON [dbo].tblOutput_MAX_ATC_UNT_YTD 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]







/*

tblQueryTool_MAX_ATC_List
tblQueryToolDriverMAX
tblQueryToolDriverATC
tblOutput_MAX_ATC_RMB_MAT
tblOutput_MAX_ATC_RMB_MQT
tblOutput_MAX_ATC_RMB_MTH
tblOutput_MAX_ATC_UNT_MAT
tblOutput_MAX_ATC_UNT_MQT
tblOutput_MAX_ATC_UNT_MTH
tblOutput_MAX_ATC_USD_MAT
tblOutput_MAX_ATC_USD_MQT
tblOutput_MAX_ATC_USD_MTH
tblOutput_MAX_TA_RMB_MAT_Global
tblOutput_MAX_TA_RMB_MAT_Inline
tblOutput_MAX_TA_RMB_MQT_Global
tblOutput_MAX_TA_RMB_MQT_Inline
tblOutput_MAX_TA_RMB_MTH_Global
tblOutput_MAX_TA_RMB_MTH_Inline
tblOutput_MAX_TA_UNT_MAT_Global
tblOutput_MAX_TA_UNT_MAT_Inline
tblOutput_MAX_TA_UNT_MQT_Global
tblOutput_MAX_TA_UNT_MQT_Inline
tblOutput_MAX_TA_UNT_MTH_Global
tblOutput_MAX_TA_UNT_MTH_Inline
tblOutput_MAX_TA_USD_MAT_Global
tblOutput_MAX_TA_USD_MAT_Inline
tblOutput_MAX_TA_USD_MQT_Global
tblOutput_MAX_TA_USD_MQT_Inline
tblOutput_MAX_TA_USD_MTH_Global
tblOutput_MAX_TA_USD_MTH_Inline



tblOutput_MAX_TA_RMB_YTD_Inline
tblOutput_MAX_TA_USD_YTD_Inline
tblOutput_MAX_TA_UNT_YTD_Inline
tblOutput_MAX_TA_RMB_YTD_Global
tblOutput_MAX_TA_USD_YTD_Global
tblOutput_MAX_TA_UNT_YTD_Global
tblOutput_MAX_ATC_RMB_YTD
tblOutput_MAX_ATC_USD_YTD
tblOutput_MAX_ATC_UNT_YTD


*/

--view:
--TA:

--MTH:

IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_TA_MTH_Inline')
    DROP VIEW tblOutput_MAX_TA_MTH_Inline
go
CREATE VIEW tblOutput_MAX_TA_MTH_Inline
as
select 'MTH' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code,
    a.VR_MTH_60,a.VR_MTH_59,a.VR_MTH_58,a.VR_MTH_57,a.VR_MTH_56,a.VR_MTH_55,a.VR_MTH_54,a.VR_MTH_53,a.VR_MTH_52,a.VR_MTH_51,a.VR_MTH_50,a.VR_MTH_49,a.VR_MTH_48,a.VR_MTH_47,a.VR_MTH_46,
    a.VR_MTH_45,a.VR_MTH_44,a.VR_MTH_43,a.VR_MTH_42,a.VR_MTH_41,a.VR_MTH_40,a.VR_MTH_39,a.VR_MTH_38,a.VR_MTH_37,a.VR_MTH_36,a.VR_MTH_35,a.VR_MTH_34,a.VR_MTH_33,a.VR_MTH_32,a.VR_MTH_31,
    a.VR_MTH_30,a.VR_MTH_29,a.VR_MTH_28,a.VR_MTH_27,a.VR_MTH_26,a.VR_MTH_25,a.VR_MTH_24,a.VR_MTH_23,a.VR_MTH_22,a.VR_MTH_21,a.VR_MTH_20,a.VR_MTH_19,a.VR_MTH_18,a.VR_MTH_17,a.VR_MTH_16,
    a.VR_MTH_15,a.VR_MTH_14,a.VR_MTH_13,a.VR_MTH_12,a.VR_MTH_11,a.VR_MTH_10,a.VR_MTH_9,a.VR_MTH_8,a.VR_MTH_7,a.VR_MTH_6,a.VR_MTH_5,a.VR_MTH_4,a.VR_MTH_3,a.VR_MTH_2,a.VR_MTH_1,
    a.VR_MTH_SHR_60,a.VR_MTH_SHR_59,a.VR_MTH_SHR_58,a.VR_MTH_SHR_57,a.VR_MTH_SHR_56,a.VR_MTH_SHR_55,a.VR_MTH_SHR_54,a.VR_MTH_SHR_53,a.VR_MTH_SHR_52,a.VR_MTH_SHR_51,a.VR_MTH_SHR_50,a.VR_MTH_SHR_49,a.VR_MTH_SHR_48,a.VR_MTH_SHR_47,a.VR_MTH_SHR_46,
    a.VR_MTH_SHR_45,a.VR_MTH_SHR_44,a.VR_MTH_SHR_43,a.VR_MTH_SHR_42,a.VR_MTH_SHR_41,a.VR_MTH_SHR_40,a.VR_MTH_SHR_39,a.VR_MTH_SHR_38,a.VR_MTH_SHR_37,a.VR_MTH_SHR_36,a.VR_MTH_SHR_35,a.VR_MTH_SHR_34,a.VR_MTH_SHR_33,a.VR_MTH_SHR_32,a.VR_MTH_SHR_31,
    a.VR_MTH_SHR_30,a.VR_MTH_SHR_29,a.VR_MTH_SHR_28,a.VR_MTH_SHR_27,a.VR_MTH_SHR_26,a.VR_MTH_SHR_25,a.VR_MTH_SHR_24,a.VR_MTH_SHR_23,a.VR_MTH_SHR_22,a.VR_MTH_SHR_21,a.VR_MTH_SHR_20,a.VR_MTH_SHR_19,a.VR_MTH_SHR_18,a.VR_MTH_SHR_17,a.VR_MTH_SHR_16,
    a.VR_MTH_SHR_15,a.VR_MTH_SHR_14,a.VR_MTH_SHR_13,a.VR_MTH_SHR_12,a.VR_MTH_SHR_11,a.VR_MTH_SHR_10,a.VR_MTH_SHR_9,a.VR_MTH_SHR_8,a.VR_MTH_SHR_7,a.VR_MTH_SHR_6,a.VR_MTH_SHR_5,a.VR_MTH_SHR_4,a.VR_MTH_SHR_3,a.VR_MTH_SHR_2,a.VR_MTH_SHR_1,
    b.VU_MTH_60,b.VU_MTH_59,b.VU_MTH_58,b.VU_MTH_57,b.VU_MTH_56,b.VU_MTH_55,b.VU_MTH_54,b.VU_MTH_53,b.VU_MTH_52,b.VU_MTH_51,b.VU_MTH_50,b.VU_MTH_49,b.VU_MTH_48,b.VU_MTH_47,b.VU_MTH_46,
    b.VU_MTH_45,b.VU_MTH_44,b.VU_MTH_43,b.VU_MTH_42,b.VU_MTH_41,b.VU_MTH_40,b.VU_MTH_39,b.VU_MTH_38,b.VU_MTH_37,b.VU_MTH_36,b.VU_MTH_35,b.VU_MTH_34,b.VU_MTH_33,b.VU_MTH_32,b.VU_MTH_31,
    b.VU_MTH_30,b.VU_MTH_29,b.VU_MTH_28,b.VU_MTH_27,b.VU_MTH_26,b.VU_MTH_25,b.VU_MTH_24,b.VU_MTH_23,b.VU_MTH_22,b.VU_MTH_21,b.VU_MTH_20,b.VU_MTH_19,b.VU_MTH_18,b.VU_MTH_17,b.VU_MTH_16,
    b.VU_MTH_15,b.VU_MTH_14,b.VU_MTH_13,b.VU_MTH_12,b.VU_MTH_11,b.VU_MTH_10,b.VU_MTH_9,b.VU_MTH_8,b.VU_MTH_7,b.VU_MTH_6,b.VU_MTH_5,b.VU_MTH_4,b.VU_MTH_3,b.VU_MTH_2,b.VU_MTH_1,
    b.VU_MTH_SHR_60,b.VU_MTH_SHR_59,b.VU_MTH_SHR_58,b.VU_MTH_SHR_57,b.VU_MTH_SHR_56,b.VU_MTH_SHR_55,b.VU_MTH_SHR_54,b.VU_MTH_SHR_53,b.VU_MTH_SHR_52,b.VU_MTH_SHR_51,b.VU_MTH_SHR_50,b.VU_MTH_SHR_49,b.VU_MTH_SHR_48,b.VU_MTH_SHR_47,b.VU_MTH_SHR_46,
    b.VU_MTH_SHR_45,b.VU_MTH_SHR_44,b.VU_MTH_SHR_43,b.VU_MTH_SHR_42,b.VU_MTH_SHR_41,b.VU_MTH_SHR_40,b.VU_MTH_SHR_39,b.VU_MTH_SHR_38,b.VU_MTH_SHR_37,b.VU_MTH_SHR_36,b.VU_MTH_SHR_35,b.VU_MTH_SHR_34,b.VU_MTH_SHR_33,b.VU_MTH_SHR_32,b.VU_MTH_SHR_31,
    b.VU_MTH_SHR_30,b.VU_MTH_SHR_29,b.VU_MTH_SHR_28,b.VU_MTH_SHR_27,b.VU_MTH_SHR_26,b.VU_MTH_SHR_25,b.VU_MTH_SHR_24,b.VU_MTH_SHR_23,b.VU_MTH_SHR_22,b.VU_MTH_SHR_21,b.VU_MTH_SHR_20,b.VU_MTH_SHR_19,b.VU_MTH_SHR_18,b.VU_MTH_SHR_17,b.VU_MTH_SHR_16,
    b.VU_MTH_SHR_15,b.VU_MTH_SHR_14,b.VU_MTH_SHR_13,b.VU_MTH_SHR_12,b.VU_MTH_SHR_11,b.VU_MTH_SHR_10,b.VU_MTH_SHR_9,b.VU_MTH_SHR_8,b.VU_MTH_SHR_7,b.VU_MTH_SHR_6,b.VU_MTH_SHR_5,b.VU_MTH_SHR_4,b.VU_MTH_SHR_3,b.VU_MTH_SHR_2,b.VU_MTH_SHR_1,
    c.UT_MTH_60,c.UT_MTH_59,c.UT_MTH_58,c.UT_MTH_57,c.UT_MTH_56,c.UT_MTH_55,c.UT_MTH_54,c.UT_MTH_53,c.UT_MTH_52,c.UT_MTH_51,c.UT_MTH_50,c.UT_MTH_49,c.UT_MTH_48,c.UT_MTH_47,c.UT_MTH_46,
    c.UT_MTH_45,c.UT_MTH_44,c.UT_MTH_43,c.UT_MTH_42,c.UT_MTH_41,c.UT_MTH_40,c.UT_MTH_39,c.UT_MTH_38,c.UT_MTH_37,c.UT_MTH_36,c.UT_MTH_35,c.UT_MTH_34,c.UT_MTH_33,c.UT_MTH_32,c.UT_MTH_31,
    c.UT_MTH_30,c.UT_MTH_29,c.UT_MTH_28,c.UT_MTH_27,c.UT_MTH_26,c.UT_MTH_25,c.UT_MTH_24,c.UT_MTH_23,c.UT_MTH_22,c.UT_MTH_21,c.UT_MTH_20,c.UT_MTH_19,c.UT_MTH_18,c.UT_MTH_17,c.UT_MTH_16,
    c.UT_MTH_15,c.UT_MTH_14,c.UT_MTH_13,c.UT_MTH_12,c.UT_MTH_11,c.UT_MTH_10,c.UT_MTH_9,c.UT_MTH_8,c.UT_MTH_7,c.UT_MTH_6,c.UT_MTH_5,c.UT_MTH_4,c.UT_MTH_3,c.UT_MTH_2,c.UT_MTH_1,
    c.UT_MTH_SHR_60,c.UT_MTH_SHR_59,c.UT_MTH_SHR_58,c.UT_MTH_SHR_57,c.UT_MTH_SHR_56,c.UT_MTH_SHR_55,c.UT_MTH_SHR_54,c.UT_MTH_SHR_53,c.UT_MTH_SHR_52,c.UT_MTH_SHR_51,c.UT_MTH_SHR_50,c.UT_MTH_SHR_49,c.UT_MTH_SHR_48,c.UT_MTH_SHR_47,c.UT_MTH_SHR_46,
    c.UT_MTH_SHR_45,c.UT_MTH_SHR_44,c.UT_MTH_SHR_43,c.UT_MTH_SHR_42,c.UT_MTH_SHR_41,c.UT_MTH_SHR_40,c.UT_MTH_SHR_39,c.UT_MTH_SHR_38,c.UT_MTH_SHR_37,c.UT_MTH_SHR_36,c.UT_MTH_SHR_35,c.UT_MTH_SHR_34,c.UT_MTH_SHR_33,c.UT_MTH_SHR_32,c.UT_MTH_SHR_31,
    c.UT_MTH_SHR_30,c.UT_MTH_SHR_29,c.UT_MTH_SHR_28,c.UT_MTH_SHR_27,c.UT_MTH_SHR_26,c.UT_MTH_SHR_25,c.UT_MTH_SHR_24,c.UT_MTH_SHR_23,c.UT_MTH_SHR_22,c.UT_MTH_SHR_21,c.UT_MTH_SHR_20,c.UT_MTH_SHR_19,c.UT_MTH_SHR_18,c.UT_MTH_SHR_17,c.UT_MTH_SHR_16,
    c.UT_MTH_SHR_15,c.UT_MTH_SHR_14,c.UT_MTH_SHR_13,c.UT_MTH_SHR_12,c.UT_MTH_SHR_11,c.UT_MTH_SHR_10,c.UT_MTH_SHR_9,c.UT_MTH_SHR_8,c.UT_MTH_SHR_7,c.UT_MTH_SHR_6,c.UT_MTH_SHR_5,c.UT_MTH_SHR_4,c.UT_MTH_SHR_3,c.UT_MTH_SHR_2,c.UT_MTH_SHR_1
from tblOutput_MAX_TA_RMB_MTH_Inline a
inner join tblOutput_MAX_TA_USD_MTH_Inline b
on a.mkt=b.mkt and a.geo=b.geo and a.class=b.class and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
    and case when a.corp_code is null then '' else a.corp_code end=case when b.corp_code is null then '' else b.corp_code end 
    and case when a.manuf_code is null then '' else a.manuf_code end =case when b.manuf_code is null then '' else b.manuf_code end
inner join tblOutput_MAX_TA_UNT_MTH_Inline c
on a.mkt=c.mkt and a.geo=c.geo and a.class=c.class and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
    and case when a.corp_code is null then '' else a.corp_code end=case when c.corp_code is null then '' else c.corp_code end 
    and case when a.manuf_code is null then '' else a.manuf_code end =case when c.manuf_code is null then '' else c.manuf_code end
GO





IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_TA_MTH_Global')
    DROP VIEW tblOutput_MAX_TA_MTH_Global
go
CREATE VIEW tblOutput_MAX_TA_MTH_Global
as
    select 'MTH' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code,
    a.VR_MTH_60,a.VR_MTH_59,a.VR_MTH_58,a.VR_MTH_57,a.VR_MTH_56,a.VR_MTH_55,a.VR_MTH_54,a.VR_MTH_53,a.VR_MTH_52,a.VR_MTH_51,a.VR_MTH_50,a.VR_MTH_49,a.VR_MTH_48,a.VR_MTH_47,a.VR_MTH_46,
    a.VR_MTH_45,a.VR_MTH_44,a.VR_MTH_43,a.VR_MTH_42,a.VR_MTH_41,a.VR_MTH_40,a.VR_MTH_39,a.VR_MTH_38,a.VR_MTH_37,a.VR_MTH_36,a.VR_MTH_35,a.VR_MTH_34,a.VR_MTH_33,a.VR_MTH_32,a.VR_MTH_31,
    a.VR_MTH_30,a.VR_MTH_29,a.VR_MTH_28,a.VR_MTH_27,a.VR_MTH_26,a.VR_MTH_25,a.VR_MTH_24,a.VR_MTH_23,a.VR_MTH_22,a.VR_MTH_21,a.VR_MTH_20,a.VR_MTH_19,a.VR_MTH_18,a.VR_MTH_17,a.VR_MTH_16,
    a.VR_MTH_15,a.VR_MTH_14,a.VR_MTH_13,a.VR_MTH_12,a.VR_MTH_11,a.VR_MTH_10,a.VR_MTH_9,a.VR_MTH_8,a.VR_MTH_7,a.VR_MTH_6,a.VR_MTH_5,a.VR_MTH_4,a.VR_MTH_3,a.VR_MTH_2,a.VR_MTH_1,
    b.VU_MTH_60,b.VU_MTH_59,b.VU_MTH_58,b.VU_MTH_57,b.VU_MTH_56,b.VU_MTH_55,b.VU_MTH_54,b.VU_MTH_53,b.VU_MTH_52,b.VU_MTH_51,b.VU_MTH_50,b.VU_MTH_49,b.VU_MTH_48,b.VU_MTH_47,b.VU_MTH_46,
    b.VU_MTH_45,b.VU_MTH_44,b.VU_MTH_43,b.VU_MTH_42,b.VU_MTH_41,b.VU_MTH_40,b.VU_MTH_39,b.VU_MTH_38,b.VU_MTH_37,b.VU_MTH_36,b.VU_MTH_35,b.VU_MTH_34,b.VU_MTH_33,b.VU_MTH_32,b.VU_MTH_31,
    b.VU_MTH_30,b.VU_MTH_29,b.VU_MTH_28,b.VU_MTH_27,b.VU_MTH_26,b.VU_MTH_25,b.VU_MTH_24,b.VU_MTH_23,b.VU_MTH_22,b.VU_MTH_21,b.VU_MTH_20,b.VU_MTH_19,b.VU_MTH_18,b.VU_MTH_17,b.VU_MTH_16,
    b.VU_MTH_15,b.VU_MTH_14,b.VU_MTH_13,b.VU_MTH_12,b.VU_MTH_11,b.VU_MTH_10,b.VU_MTH_9,b.VU_MTH_8,b.VU_MTH_7,b.VU_MTH_6,b.VU_MTH_5,b.VU_MTH_4,b.VU_MTH_3,b.VU_MTH_2,b.VU_MTH_1,
    c.UT_MTH_60,c.UT_MTH_59,c.UT_MTH_58,c.UT_MTH_57,c.UT_MTH_56,c.UT_MTH_55,c.UT_MTH_54,c.UT_MTH_53,c.UT_MTH_52,c.UT_MTH_51,c.UT_MTH_50,c.UT_MTH_49,c.UT_MTH_48,c.UT_MTH_47,c.UT_MTH_46,
    c.UT_MTH_45,c.UT_MTH_44,c.UT_MTH_43,c.UT_MTH_42,c.UT_MTH_41,c.UT_MTH_40,c.UT_MTH_39,c.UT_MTH_38,c.UT_MTH_37,c.UT_MTH_36,c.UT_MTH_35,c.UT_MTH_34,c.UT_MTH_33,c.UT_MTH_32,c.UT_MTH_31,
    c.UT_MTH_30,c.UT_MTH_29,c.UT_MTH_28,c.UT_MTH_27,c.UT_MTH_26,c.UT_MTH_25,c.UT_MTH_24,c.UT_MTH_23,c.UT_MTH_22,c.UT_MTH_21,c.UT_MTH_20,c.UT_MTH_19,c.UT_MTH_18,c.UT_MTH_17,c.UT_MTH_16,
    c.UT_MTH_15,c.UT_MTH_14,c.UT_MTH_13,c.UT_MTH_12,c.UT_MTH_11,c.UT_MTH_10,c.UT_MTH_9,c.UT_MTH_8,c.UT_MTH_7,c.UT_MTH_6,c.UT_MTH_5,c.UT_MTH_4,c.UT_MTH_3,c.UT_MTH_2,c.UT_MTH_1
from tblOutput_MAX_TA_RMB_MTH_Global a
inner join tblOutput_MAX_TA_USD_MTH_Global b
on a.mkt=b.mkt and a.geo=b.geo and a.class=b.class and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
    and case when a.corp_code is null then '' else a.corp_code end=case when b.corp_code is null then '' else b.corp_code end 
    and case when a.manuf_code is null then '' else a.manuf_code end =case when b.manuf_code is null then '' else b.manuf_code end
inner join tblOutput_MAX_TA_UNT_MTH_Global c
on a.mkt=c.mkt and a.geo=c.geo and a.class=c.class and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
    and case when a.corp_code is null then '' else a.corp_code end=case when c.corp_code is null then '' else c.corp_code end 
    and case when a.manuf_code is null then '' else a.manuf_code end =case when c.manuf_code is null then '' else c.manuf_code end
go


--MQT:

IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_TA_MQT_Inline')
DROP VIEW tblOutput_MAX_TA_MQT_Inline
go
CREATE VIEW tblOutput_MAX_TA_MQT_Inline
as
select 'MQT' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code,
    a.VR_MQT_60,a.VR_MQT_59,a.VR_MQT_58,a.VR_MQT_57,a.VR_MQT_56,a.VR_MQT_55,a.VR_MQT_54,a.VR_MQT_53,a.VR_MQT_52,a.VR_MQT_51,a.VR_MQT_50,a.VR_MQT_49,a.VR_MQT_48,a.VR_MQT_47,a.VR_MQT_46,
    a.VR_MQT_45,a.VR_MQT_44,a.VR_MQT_43,a.VR_MQT_42,a.VR_MQT_41,a.VR_MQT_40,a.VR_MQT_39,a.VR_MQT_38,a.VR_MQT_37,a.VR_MQT_36,a.VR_MQT_35,a.VR_MQT_34,a.VR_MQT_33,a.VR_MQT_32,a.VR_MQT_31,
    a.VR_MQT_30,a.VR_MQT_29,a.VR_MQT_28,a.VR_MQT_27,a.VR_MQT_26,a.VR_MQT_25,a.VR_MQT_24,a.VR_MQT_23,a.VR_MQT_22,a.VR_MQT_21,a.VR_MQT_20,a.VR_MQT_19,a.VR_MQT_18,a.VR_MQT_17,a.VR_MQT_16,
    a.VR_MQT_15,a.VR_MQT_14,a.VR_MQT_13,a.VR_MQT_12,a.VR_MQT_11,a.VR_MQT_10,a.VR_MQT_9,a.VR_MQT_8,a.VR_MQT_7,a.VR_MQT_6,a.VR_MQT_5,a.VR_MQT_4,a.VR_MQT_3,a.VR_MQT_2,a.VR_MQT_1,
    a.VR_MQT_SHR_60,a.VR_MQT_SHR_59,a.VR_MQT_SHR_58,a.VR_MQT_SHR_57,a.VR_MQT_SHR_56,a.VR_MQT_SHR_55,a.VR_MQT_SHR_54,a.VR_MQT_SHR_53,a.VR_MQT_SHR_52,a.VR_MQT_SHR_51,a.VR_MQT_SHR_50,a.VR_MQT_SHR_49,a.VR_MQT_SHR_48,a.VR_MQT_SHR_47,a.VR_MQT_SHR_46,
    a.VR_MQT_SHR_45,a.VR_MQT_SHR_44,a.VR_MQT_SHR_43,a.VR_MQT_SHR_42,a.VR_MQT_SHR_41,a.VR_MQT_SHR_40,a.VR_MQT_SHR_39,a.VR_MQT_SHR_38,a.VR_MQT_SHR_37,a.VR_MQT_SHR_36,a.VR_MQT_SHR_35,a.VR_MQT_SHR_34,a.VR_MQT_SHR_33,a.VR_MQT_SHR_32,a.VR_MQT_SHR_31,
    a.VR_MQT_SHR_30,a.VR_MQT_SHR_29,a.VR_MQT_SHR_28,a.VR_MQT_SHR_27,a.VR_MQT_SHR_26,a.VR_MQT_SHR_25,a.VR_MQT_SHR_24,a.VR_MQT_SHR_23,a.VR_MQT_SHR_22,a.VR_MQT_SHR_21,a.VR_MQT_SHR_20,a.VR_MQT_SHR_19,a.VR_MQT_SHR_18,a.VR_MQT_SHR_17,a.VR_MQT_SHR_16,
    a.VR_MQT_SHR_15,a.VR_MQT_SHR_14,a.VR_MQT_SHR_13,a.VR_MQT_SHR_12,a.VR_MQT_SHR_11,a.VR_MQT_SHR_10,a.VR_MQT_SHR_9,a.VR_MQT_SHR_8,a.VR_MQT_SHR_7,a.VR_MQT_SHR_6,a.VR_MQT_SHR_5,a.VR_MQT_SHR_4,a.VR_MQT_SHR_3,a.VR_MQT_SHR_2,a.VR_MQT_SHR_1,
    b.VU_MQT_60,b.VU_MQT_59,b.VU_MQT_58,b.VU_MQT_57,b.VU_MQT_56,b.VU_MQT_55,b.VU_MQT_54,b.VU_MQT_53,b.VU_MQT_52,b.VU_MQT_51,b.VU_MQT_50,b.VU_MQT_49,b.VU_MQT_48,b.VU_MQT_47,b.VU_MQT_46,
    b.VU_MQT_45,b.VU_MQT_44,b.VU_MQT_43,b.VU_MQT_42,b.VU_MQT_41,b.VU_MQT_40,b.VU_MQT_39,b.VU_MQT_38,b.VU_MQT_37,b.VU_MQT_36,b.VU_MQT_35,b.VU_MQT_34,b.VU_MQT_33,b.VU_MQT_32,b.VU_MQT_31,
    b.VU_MQT_30,b.VU_MQT_29,b.VU_MQT_28,b.VU_MQT_27,b.VU_MQT_26,b.VU_MQT_25,b.VU_MQT_24,b.VU_MQT_23,b.VU_MQT_22,b.VU_MQT_21,b.VU_MQT_20,b.VU_MQT_19,b.VU_MQT_18,b.VU_MQT_17,b.VU_MQT_16,
    b.VU_MQT_15,b.VU_MQT_14,b.VU_MQT_13,b.VU_MQT_12,b.VU_MQT_11,b.VU_MQT_10,b.VU_MQT_9,b.VU_MQT_8,b.VU_MQT_7,b.VU_MQT_6,b.VU_MQT_5,b.VU_MQT_4,b.VU_MQT_3,b.VU_MQT_2,b.VU_MQT_1,
    b.VU_MQT_SHR_60,b.VU_MQT_SHR_59,b.VU_MQT_SHR_58,b.VU_MQT_SHR_57,b.VU_MQT_SHR_56,b.VU_MQT_SHR_55,b.VU_MQT_SHR_54,b.VU_MQT_SHR_53,b.VU_MQT_SHR_52,b.VU_MQT_SHR_51,b.VU_MQT_SHR_50,b.VU_MQT_SHR_49,b.VU_MQT_SHR_48,b.VU_MQT_SHR_47,b.VU_MQT_SHR_46,
    b.VU_MQT_SHR_45,b.VU_MQT_SHR_44,b.VU_MQT_SHR_43,b.VU_MQT_SHR_42,b.VU_MQT_SHR_41,b.VU_MQT_SHR_40,b.VU_MQT_SHR_39,b.VU_MQT_SHR_38,b.VU_MQT_SHR_37,b.VU_MQT_SHR_36,b.VU_MQT_SHR_35,b.VU_MQT_SHR_34,b.VU_MQT_SHR_33,b.VU_MQT_SHR_32,b.VU_MQT_SHR_31,
    b.VU_MQT_SHR_30,b.VU_MQT_SHR_29,b.VU_MQT_SHR_28,b.VU_MQT_SHR_27,b.VU_MQT_SHR_26,b.VU_MQT_SHR_25,b.VU_MQT_SHR_24,b.VU_MQT_SHR_23,b.VU_MQT_SHR_22,b.VU_MQT_SHR_21,b.VU_MQT_SHR_20,b.VU_MQT_SHR_19,b.VU_MQT_SHR_18,b.VU_MQT_SHR_17,b.VU_MQT_SHR_16,
    b.VU_MQT_SHR_15,b.VU_MQT_SHR_14,b.VU_MQT_SHR_13,b.VU_MQT_SHR_12,b.VU_MQT_SHR_11,b.VU_MQT_SHR_10,b.VU_MQT_SHR_9,b.VU_MQT_SHR_8,b.VU_MQT_SHR_7,b.VU_MQT_SHR_6,b.VU_MQT_SHR_5,b.VU_MQT_SHR_4,b.VU_MQT_SHR_3,b.VU_MQT_SHR_2,b.VU_MQT_SHR_1,
    c.UT_MQT_60,c.UT_MQT_59,c.UT_MQT_58,c.UT_MQT_57,c.UT_MQT_56,c.UT_MQT_55,c.UT_MQT_54,c.UT_MQT_53,c.UT_MQT_52,c.UT_MQT_51,c.UT_MQT_50,c.UT_MQT_49,c.UT_MQT_48,c.UT_MQT_47,c.UT_MQT_46,
    c.UT_MQT_45,c.UT_MQT_44,c.UT_MQT_43,c.UT_MQT_42,c.UT_MQT_41,c.UT_MQT_40,c.UT_MQT_39,c.UT_MQT_38,c.UT_MQT_37,c.UT_MQT_36,c.UT_MQT_35,c.UT_MQT_34,c.UT_MQT_33,c.UT_MQT_32,c.UT_MQT_31,
    c.UT_MQT_30,c.UT_MQT_29,c.UT_MQT_28,c.UT_MQT_27,c.UT_MQT_26,c.UT_MQT_25,c.UT_MQT_24,c.UT_MQT_23,c.UT_MQT_22,c.UT_MQT_21,c.UT_MQT_20,c.UT_MQT_19,c.UT_MQT_18,c.UT_MQT_17,c.UT_MQT_16,
    c.UT_MQT_15,c.UT_MQT_14,c.UT_MQT_13,c.UT_MQT_12,c.UT_MQT_11,c.UT_MQT_10,c.UT_MQT_9,c.UT_MQT_8,c.UT_MQT_7,c.UT_MQT_6,c.UT_MQT_5,c.UT_MQT_4,c.UT_MQT_3,c.UT_MQT_2,c.UT_MQT_1,
    c.UT_MQT_SHR_60,c.UT_MQT_SHR_59,c.UT_MQT_SHR_58,c.UT_MQT_SHR_57,c.UT_MQT_SHR_56,c.UT_MQT_SHR_55,c.UT_MQT_SHR_54,c.UT_MQT_SHR_53,c.UT_MQT_SHR_52,c.UT_MQT_SHR_51,c.UT_MQT_SHR_50,c.UT_MQT_SHR_49,c.UT_MQT_SHR_48,c.UT_MQT_SHR_47,c.UT_MQT_SHR_46,
    c.UT_MQT_SHR_45,c.UT_MQT_SHR_44,c.UT_MQT_SHR_43,c.UT_MQT_SHR_42,c.UT_MQT_SHR_41,c.UT_MQT_SHR_40,c.UT_MQT_SHR_39,c.UT_MQT_SHR_38,c.UT_MQT_SHR_37,c.UT_MQT_SHR_36,c.UT_MQT_SHR_35,c.UT_MQT_SHR_34,c.UT_MQT_SHR_33,c.UT_MQT_SHR_32,c.UT_MQT_SHR_31,
    c.UT_MQT_SHR_30,c.UT_MQT_SHR_29,c.UT_MQT_SHR_28,c.UT_MQT_SHR_27,c.UT_MQT_SHR_26,c.UT_MQT_SHR_25,c.UT_MQT_SHR_24,c.UT_MQT_SHR_23,c.UT_MQT_SHR_22,c.UT_MQT_SHR_21,c.UT_MQT_SHR_20,c.UT_MQT_SHR_19,c.UT_MQT_SHR_18,c.UT_MQT_SHR_17,c.UT_MQT_SHR_16,
    c.UT_MQT_SHR_15,c.UT_MQT_SHR_14,c.UT_MQT_SHR_13,c.UT_MQT_SHR_12,c.UT_MQT_SHR_11,c.UT_MQT_SHR_10,c.UT_MQT_SHR_9,c.UT_MQT_SHR_8,c.UT_MQT_SHR_7,c.UT_MQT_SHR_6,c.UT_MQT_SHR_5,c.UT_MQT_SHR_4,c.UT_MQT_SHR_3,c.UT_MQT_SHR_2,c.UT_MQT_SHR_1
from tblOutput_MAX_TA_RMB_MQT_Inline a
inner join tblOutput_MAX_TA_USD_MQT_Inline b
on a.mkt=b.mkt and a.geo=b.geo and a.class=b.class and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
    and case when a.corp_code is null then '' else a.corp_code end=case when b.corp_code is null then '' else b.corp_code end 
    and case when a.manuf_code is null then '' else a.manuf_code end =case when b.manuf_code is null then '' else b.manuf_code end
inner join tblOutput_MAX_TA_UNT_MQT_Inline c
on a.mkt=c.mkt and a.geo=c.geo and a.class=c.class and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
    and case when a.corp_code is null then '' else a.corp_code end=case when c.corp_code is null then '' else c.corp_code end 
    and case when a.manuf_code is null then '' else a.manuf_code end =case when c.manuf_code is null then '' else c.manuf_code end
go




IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_TA_MQT_Global')
DROP VIEW tblOutput_MAX_TA_MQT_Global
go
CREATE VIEW tblOutput_MAX_TA_MQT_Global
as
select 'MQT' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code,
    a.VR_MQT_60,a.VR_MQT_59,a.VR_MQT_58,a.VR_MQT_57,a.VR_MQT_56,a.VR_MQT_55,a.VR_MQT_54,a.VR_MQT_53,a.VR_MQT_52,a.VR_MQT_51,a.VR_MQT_50,a.VR_MQT_49,a.VR_MQT_48,a.VR_MQT_47,a.VR_MQT_46,
    a.VR_MQT_45,a.VR_MQT_44,a.VR_MQT_43,a.VR_MQT_42,a.VR_MQT_41,a.VR_MQT_40,a.VR_MQT_39,a.VR_MQT_38,a.VR_MQT_37,a.VR_MQT_36,a.VR_MQT_35,a.VR_MQT_34,a.VR_MQT_33,a.VR_MQT_32,a.VR_MQT_31,
    a.VR_MQT_30,a.VR_MQT_29,a.VR_MQT_28,a.VR_MQT_27,a.VR_MQT_26,a.VR_MQT_25,a.VR_MQT_24,a.VR_MQT_23,a.VR_MQT_22,a.VR_MQT_21,a.VR_MQT_20,a.VR_MQT_19,a.VR_MQT_18,a.VR_MQT_17,a.VR_MQT_16,
    a.VR_MQT_15,a.VR_MQT_14,a.VR_MQT_13,a.VR_MQT_12,a.VR_MQT_11,a.VR_MQT_10,a.VR_MQT_9,a.VR_MQT_8,a.VR_MQT_7,a.VR_MQT_6,a.VR_MQT_5,a.VR_MQT_4,a.VR_MQT_3,a.VR_MQT_2,a.VR_MQT_1,
    b.VU_MQT_60,b.VU_MQT_59,b.VU_MQT_58,b.VU_MQT_57,b.VU_MQT_56,b.VU_MQT_55,b.VU_MQT_54,b.VU_MQT_53,b.VU_MQT_52,b.VU_MQT_51,b.VU_MQT_50,b.VU_MQT_49,b.VU_MQT_48,b.VU_MQT_47,b.VU_MQT_46,
    b.VU_MQT_45,b.VU_MQT_44,b.VU_MQT_43,b.VU_MQT_42,b.VU_MQT_41,b.VU_MQT_40,b.VU_MQT_39,b.VU_MQT_38,b.VU_MQT_37,b.VU_MQT_36,b.VU_MQT_35,b.VU_MQT_34,b.VU_MQT_33,b.VU_MQT_32,b.VU_MQT_31,
    b.VU_MQT_30,b.VU_MQT_29,b.VU_MQT_28,b.VU_MQT_27,b.VU_MQT_26,b.VU_MQT_25,b.VU_MQT_24,b.VU_MQT_23,b.VU_MQT_22,b.VU_MQT_21,b.VU_MQT_20,b.VU_MQT_19,b.VU_MQT_18,b.VU_MQT_17,b.VU_MQT_16,
    b.VU_MQT_15,b.VU_MQT_14,b.VU_MQT_13,b.VU_MQT_12,b.VU_MQT_11,b.VU_MQT_10,b.VU_MQT_9,b.VU_MQT_8,b.VU_MQT_7,b.VU_MQT_6,b.VU_MQT_5,b.VU_MQT_4,b.VU_MQT_3,b.VU_MQT_2,b.VU_MQT_1,
    c.UT_MQT_60,c.UT_MQT_59,c.UT_MQT_58,c.UT_MQT_57,c.UT_MQT_56,c.UT_MQT_55,c.UT_MQT_54,c.UT_MQT_53,c.UT_MQT_52,c.UT_MQT_51,c.UT_MQT_50,c.UT_MQT_49,c.UT_MQT_48,c.UT_MQT_47,c.UT_MQT_46,
    c.UT_MQT_45,c.UT_MQT_44,c.UT_MQT_43,c.UT_MQT_42,c.UT_MQT_41,c.UT_MQT_40,c.UT_MQT_39,c.UT_MQT_38,c.UT_MQT_37,c.UT_MQT_36,c.UT_MQT_35,c.UT_MQT_34,c.UT_MQT_33,c.UT_MQT_32,c.UT_MQT_31,
    c.UT_MQT_30,c.UT_MQT_29,c.UT_MQT_28,c.UT_MQT_27,c.UT_MQT_26,c.UT_MQT_25,c.UT_MQT_24,c.UT_MQT_23,c.UT_MQT_22,c.UT_MQT_21,c.UT_MQT_20,c.UT_MQT_19,c.UT_MQT_18,c.UT_MQT_17,c.UT_MQT_16,
    c.UT_MQT_15,c.UT_MQT_14,c.UT_MQT_13,c.UT_MQT_12,c.UT_MQT_11,c.UT_MQT_10,c.UT_MQT_9,c.UT_MQT_8,c.UT_MQT_7,c.UT_MQT_6,c.UT_MQT_5,c.UT_MQT_4,c.UT_MQT_3,c.UT_MQT_2,c.UT_MQT_1
from tblOutput_MAX_TA_RMB_MQT_Global a
inner join tblOutput_MAX_TA_USD_MQT_Global b
on a.mkt=b.mkt and a.geo=b.geo and a.class=b.class and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
    and case when a.corp_code is null then '' else a.corp_code end=case when b.corp_code is null then '' else b.corp_code end 
    and case when a.manuf_code is null then '' else a.manuf_code end =case when b.manuf_code is null then '' else b.manuf_code end
inner join tblOutput_MAX_TA_UNT_MQT_Global c
on a.mkt=c.mkt and a.geo=c.geo and a.class=c.class and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
    and case when a.corp_code is null then '' else a.corp_code end=case when c.corp_code is null then '' else c.corp_code end 
    and case when a.manuf_code is null then '' else a.manuf_code end =case when c.manuf_code is null then '' else c.manuf_code end
go

--MAT

IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_TA_MAT_Inline')
DROP VIEW tblOutput_MAX_TA_MAT_Inline
go
CREATE VIEW tblOutput_MAX_TA_MAT_Inline
as
select 'MAT' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code,
    a.VR_MAT_60,a.VR_MAT_59,a.VR_MAT_58,a.VR_MAT_57,a.VR_MAT_56,a.VR_MAT_55,a.VR_MAT_54,a.VR_MAT_53,a.VR_MAT_52,a.VR_MAT_51,a.VR_MAT_50,a.VR_MAT_49,a.VR_MAT_48,a.VR_MAT_47,a.VR_MAT_46,
    a.VR_MAT_45,a.VR_MAT_44,a.VR_MAT_43,a.VR_MAT_42,a.VR_MAT_41,a.VR_MAT_40,a.VR_MAT_39,a.VR_MAT_38,a.VR_MAT_37,a.VR_MAT_36,a.VR_MAT_35,a.VR_MAT_34,a.VR_MAT_33,a.VR_MAT_32,a.VR_MAT_31,
    a.VR_MAT_30,a.VR_MAT_29,a.VR_MAT_28,a.VR_MAT_27,a.VR_MAT_26,a.VR_MAT_25,a.VR_MAT_24,a.VR_MAT_23,a.VR_MAT_22,a.VR_MAT_21,a.VR_MAT_20,a.VR_MAT_19,a.VR_MAT_18,a.VR_MAT_17,a.VR_MAT_16,
    a.VR_MAT_15,a.VR_MAT_14,a.VR_MAT_13,a.VR_MAT_12,a.VR_MAT_11,a.VR_MAT_10,a.VR_MAT_9,a.VR_MAT_8,a.VR_MAT_7,a.VR_MAT_6,a.VR_MAT_5,a.VR_MAT_4,a.VR_MAT_3,a.VR_MAT_2,a.VR_MAT_1,
    a.VR_MAT_SHR_60,a.VR_MAT_SHR_59,a.VR_MAT_SHR_58,a.VR_MAT_SHR_57,a.VR_MAT_SHR_56,a.VR_MAT_SHR_55,a.VR_MAT_SHR_54,a.VR_MAT_SHR_53,a.VR_MAT_SHR_52,a.VR_MAT_SHR_51,a.VR_MAT_SHR_50,a.VR_MAT_SHR_49,a.VR_MAT_SHR_48,a.VR_MAT_SHR_47,a.VR_MAT_SHR_46,
    a.VR_MAT_SHR_45,a.VR_MAT_SHR_44,a.VR_MAT_SHR_43,a.VR_MAT_SHR_42,a.VR_MAT_SHR_41,a.VR_MAT_SHR_40,a.VR_MAT_SHR_39,a.VR_MAT_SHR_38,a.VR_MAT_SHR_37,a.VR_MAT_SHR_36,a.VR_MAT_SHR_35,a.VR_MAT_SHR_34,a.VR_MAT_SHR_33,a.VR_MAT_SHR_32,a.VR_MAT_SHR_31,
    a.VR_MAT_SHR_30,a.VR_MAT_SHR_29,a.VR_MAT_SHR_28,a.VR_MAT_SHR_27,a.VR_MAT_SHR_26,a.VR_MAT_SHR_25,a.VR_MAT_SHR_24,a.VR_MAT_SHR_23,a.VR_MAT_SHR_22,a.VR_MAT_SHR_21,a.VR_MAT_SHR_20,a.VR_MAT_SHR_19,a.VR_MAT_SHR_18,a.VR_MAT_SHR_17,a.VR_MAT_SHR_16,
    a.VR_MAT_SHR_15,a.VR_MAT_SHR_14,a.VR_MAT_SHR_13,a.VR_MAT_SHR_12,a.VR_MAT_SHR_11,a.VR_MAT_SHR_10,a.VR_MAT_SHR_9,a.VR_MAT_SHR_8,a.VR_MAT_SHR_7,a.VR_MAT_SHR_6,a.VR_MAT_SHR_5,a.VR_MAT_SHR_4,a.VR_MAT_SHR_3,a.VR_MAT_SHR_2,a.VR_MAT_SHR_1,
    b.VU_MAT_60,b.VU_MAT_59,b.VU_MAT_58,b.VU_MAT_57,b.VU_MAT_56,b.VU_MAT_55,b.VU_MAT_54,b.VU_MAT_53,b.VU_MAT_52,b.VU_MAT_51,b.VU_MAT_50,b.VU_MAT_49,b.VU_MAT_48,b.VU_MAT_47,b.VU_MAT_46,
    b.VU_MAT_45,b.VU_MAT_44,b.VU_MAT_43,b.VU_MAT_42,b.VU_MAT_41,b.VU_MAT_40,b.VU_MAT_39,b.VU_MAT_38,b.VU_MAT_37,b.VU_MAT_36,b.VU_MAT_35,b.VU_MAT_34,b.VU_MAT_33,b.VU_MAT_32,b.VU_MAT_31,
    b.VU_MAT_30,b.VU_MAT_29,b.VU_MAT_28,b.VU_MAT_27,b.VU_MAT_26,b.VU_MAT_25,b.VU_MAT_24,b.VU_MAT_23,b.VU_MAT_22,b.VU_MAT_21,b.VU_MAT_20,b.VU_MAT_19,b.VU_MAT_18,b.VU_MAT_17,b.VU_MAT_16,
    b.VU_MAT_15,b.VU_MAT_14,b.VU_MAT_13,b.VU_MAT_12,b.VU_MAT_11,b.VU_MAT_10,b.VU_MAT_9,b.VU_MAT_8,b.VU_MAT_7,b.VU_MAT_6,b.VU_MAT_5,b.VU_MAT_4,b.VU_MAT_3,b.VU_MAT_2,b.VU_MAT_1,
    b.VU_MAT_SHR_60,b.VU_MAT_SHR_59,b.VU_MAT_SHR_58,b.VU_MAT_SHR_57,b.VU_MAT_SHR_56,b.VU_MAT_SHR_55,b.VU_MAT_SHR_54,b.VU_MAT_SHR_53,b.VU_MAT_SHR_52,b.VU_MAT_SHR_51,b.VU_MAT_SHR_50,b.VU_MAT_SHR_49,b.VU_MAT_SHR_48,b.VU_MAT_SHR_47,b.VU_MAT_SHR_46,
    b.VU_MAT_SHR_45,b.VU_MAT_SHR_44,b.VU_MAT_SHR_43,b.VU_MAT_SHR_42,b.VU_MAT_SHR_41,b.VU_MAT_SHR_40,b.VU_MAT_SHR_39,b.VU_MAT_SHR_38,b.VU_MAT_SHR_37,b.VU_MAT_SHR_36,b.VU_MAT_SHR_35,b.VU_MAT_SHR_34,b.VU_MAT_SHR_33,b.VU_MAT_SHR_32,b.VU_MAT_SHR_31,
    b.VU_MAT_SHR_30,b.VU_MAT_SHR_29,b.VU_MAT_SHR_28,b.VU_MAT_SHR_27,b.VU_MAT_SHR_26,b.VU_MAT_SHR_25,b.VU_MAT_SHR_24,b.VU_MAT_SHR_23,b.VU_MAT_SHR_22,b.VU_MAT_SHR_21,b.VU_MAT_SHR_20,b.VU_MAT_SHR_19,b.VU_MAT_SHR_18,b.VU_MAT_SHR_17,b.VU_MAT_SHR_16,
    b.VU_MAT_SHR_15,b.VU_MAT_SHR_14,b.VU_MAT_SHR_13,b.VU_MAT_SHR_12,b.VU_MAT_SHR_11,b.VU_MAT_SHR_10,b.VU_MAT_SHR_9,b.VU_MAT_SHR_8,b.VU_MAT_SHR_7,b.VU_MAT_SHR_6,b.VU_MAT_SHR_5,b.VU_MAT_SHR_4,b.VU_MAT_SHR_3,b.VU_MAT_SHR_2,b.VU_MAT_SHR_1,
    c.UT_MAT_60,c.UT_MAT_59,c.UT_MAT_58,c.UT_MAT_57,c.UT_MAT_56,c.UT_MAT_55,c.UT_MAT_54,c.UT_MAT_53,c.UT_MAT_52,c.UT_MAT_51,c.UT_MAT_50,c.UT_MAT_49,c.UT_MAT_48,c.UT_MAT_47,c.UT_MAT_46,
    c.UT_MAT_45,c.UT_MAT_44,c.UT_MAT_43,c.UT_MAT_42,c.UT_MAT_41,c.UT_MAT_40,c.UT_MAT_39,c.UT_MAT_38,c.UT_MAT_37,c.UT_MAT_36,c.UT_MAT_35,c.UT_MAT_34,c.UT_MAT_33,c.UT_MAT_32,c.UT_MAT_31,
    c.UT_MAT_30,c.UT_MAT_29,c.UT_MAT_28,c.UT_MAT_27,c.UT_MAT_26,c.UT_MAT_25,c.UT_MAT_24,c.UT_MAT_23,c.UT_MAT_22,c.UT_MAT_21,c.UT_MAT_20,c.UT_MAT_19,c.UT_MAT_18,c.UT_MAT_17,c.UT_MAT_16,
    c.UT_MAT_15,c.UT_MAT_14,c.UT_MAT_13,c.UT_MAT_12,c.UT_MAT_11,c.UT_MAT_10,c.UT_MAT_9,c.UT_MAT_8,c.UT_MAT_7,c.UT_MAT_6,c.UT_MAT_5,c.UT_MAT_4,c.UT_MAT_3,c.UT_MAT_2,c.UT_MAT_1,
    c.UT_MAT_SHR_60,c.UT_MAT_SHR_59,c.UT_MAT_SHR_58,c.UT_MAT_SHR_57,c.UT_MAT_SHR_56,c.UT_MAT_SHR_55,c.UT_MAT_SHR_54,c.UT_MAT_SHR_53,c.UT_MAT_SHR_52,c.UT_MAT_SHR_51,c.UT_MAT_SHR_50,c.UT_MAT_SHR_49,c.UT_MAT_SHR_48,c.UT_MAT_SHR_47,c.UT_MAT_SHR_46,
    c.UT_MAT_SHR_45,c.UT_MAT_SHR_44,c.UT_MAT_SHR_43,c.UT_MAT_SHR_42,c.UT_MAT_SHR_41,c.UT_MAT_SHR_40,c.UT_MAT_SHR_39,c.UT_MAT_SHR_38,c.UT_MAT_SHR_37,c.UT_MAT_SHR_36,c.UT_MAT_SHR_35,c.UT_MAT_SHR_34,c.UT_MAT_SHR_33,c.UT_MAT_SHR_32,c.UT_MAT_SHR_31,
    c.UT_MAT_SHR_30,c.UT_MAT_SHR_29,c.UT_MAT_SHR_28,c.UT_MAT_SHR_27,c.UT_MAT_SHR_26,c.UT_MAT_SHR_25,c.UT_MAT_SHR_24,c.UT_MAT_SHR_23,c.UT_MAT_SHR_22,c.UT_MAT_SHR_21,c.UT_MAT_SHR_20,c.UT_MAT_SHR_19,c.UT_MAT_SHR_18,c.UT_MAT_SHR_17,c.UT_MAT_SHR_16,
    c.UT_MAT_SHR_15,c.UT_MAT_SHR_14,c.UT_MAT_SHR_13,c.UT_MAT_SHR_12,c.UT_MAT_SHR_11,c.UT_MAT_SHR_10,c.UT_MAT_SHR_9,c.UT_MAT_SHR_8,c.UT_MAT_SHR_7,c.UT_MAT_SHR_6,c.UT_MAT_SHR_5,c.UT_MAT_SHR_4,c.UT_MAT_SHR_3,c.UT_MAT_SHR_2,c.UT_MAT_SHR_1
from tblOutput_MAX_TA_RMB_MAT_Inline a
inner join tblOutput_MAX_TA_USD_MAT_Inline b
on a.mkt=b.mkt and a.geo=b.geo and a.class=b.class and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
and case when a.corp_code is null then '' else a.corp_code end=case when b.corp_code is null then '' else b.corp_code end 
and case when a.manuf_code is null then '' else a.manuf_code end =case when b.manuf_code is null then '' else b.manuf_code end
inner join tblOutput_MAX_TA_UNT_MAT_Inline c
on a.mkt=c.mkt and a.geo=c.geo and a.class=c.class and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
and case when a.corp_code is null then '' else a.corp_code end=case when c.corp_code is null then '' else c.corp_code end 
and case when a.manuf_code is null then '' else a.manuf_code end =case when c.manuf_code is null then '' else c.manuf_code end
GO





IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_TA_MAT_Global')
DROP VIEW tblOutput_MAX_TA_MAT_Global
go
CREATE VIEW tblOutput_MAX_TA_MAT_Global
as
select 'MAT' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code,
    a.VR_MAT_60,a.VR_MAT_59,a.VR_MAT_58,a.VR_MAT_57,a.VR_MAT_56,a.VR_MAT_55,a.VR_MAT_54,a.VR_MAT_53,a.VR_MAT_52,a.VR_MAT_51,a.VR_MAT_50,a.VR_MAT_49,a.VR_MAT_48,a.VR_MAT_47,a.VR_MAT_46,
    a.VR_MAT_45,a.VR_MAT_44,a.VR_MAT_43,a.VR_MAT_42,a.VR_MAT_41,a.VR_MAT_40,a.VR_MAT_39,a.VR_MAT_38,a.VR_MAT_37,a.VR_MAT_36,a.VR_MAT_35,a.VR_MAT_34,a.VR_MAT_33,a.VR_MAT_32,a.VR_MAT_31,
    a.VR_MAT_30,a.VR_MAT_29,a.VR_MAT_28,a.VR_MAT_27,a.VR_MAT_26,a.VR_MAT_25,a.VR_MAT_24,a.VR_MAT_23,a.VR_MAT_22,a.VR_MAT_21,a.VR_MAT_20,a.VR_MAT_19,a.VR_MAT_18,a.VR_MAT_17,a.VR_MAT_16,
    a.VR_MAT_15,a.VR_MAT_14,a.VR_MAT_13,a.VR_MAT_12,a.VR_MAT_11,a.VR_MAT_10,a.VR_MAT_9,a.VR_MAT_8,a.VR_MAT_7,a.VR_MAT_6,a.VR_MAT_5,a.VR_MAT_4,a.VR_MAT_3,a.VR_MAT_2,a.VR_MAT_1,
    b.VU_MAT_60,b.VU_MAT_59,b.VU_MAT_58,b.VU_MAT_57,b.VU_MAT_56,b.VU_MAT_55,b.VU_MAT_54,b.VU_MAT_53,b.VU_MAT_52,b.VU_MAT_51,b.VU_MAT_50,b.VU_MAT_49,b.VU_MAT_48,b.VU_MAT_47,b.VU_MAT_46,
    b.VU_MAT_45,b.VU_MAT_44,b.VU_MAT_43,b.VU_MAT_42,b.VU_MAT_41,b.VU_MAT_40,b.VU_MAT_39,b.VU_MAT_38,b.VU_MAT_37,b.VU_MAT_36,b.VU_MAT_35,b.VU_MAT_34,b.VU_MAT_33,b.VU_MAT_32,b.VU_MAT_31,
    b.VU_MAT_30,b.VU_MAT_29,b.VU_MAT_28,b.VU_MAT_27,b.VU_MAT_26,b.VU_MAT_25,b.VU_MAT_24,b.VU_MAT_23,b.VU_MAT_22,b.VU_MAT_21,b.VU_MAT_20,b.VU_MAT_19,b.VU_MAT_18,b.VU_MAT_17,b.VU_MAT_16,
    b.VU_MAT_15,b.VU_MAT_14,b.VU_MAT_13,b.VU_MAT_12,b.VU_MAT_11,b.VU_MAT_10,b.VU_MAT_9,b.VU_MAT_8,b.VU_MAT_7,b.VU_MAT_6,b.VU_MAT_5,b.VU_MAT_4,b.VU_MAT_3,b.VU_MAT_2,b.VU_MAT_1,
    c.UT_MAT_60,c.UT_MAT_59,c.UT_MAT_58,c.UT_MAT_57,c.UT_MAT_56,c.UT_MAT_55,c.UT_MAT_54,c.UT_MAT_53,c.UT_MAT_52,c.UT_MAT_51,c.UT_MAT_50,c.UT_MAT_49,c.UT_MAT_48,c.UT_MAT_47,c.UT_MAT_46,
    c.UT_MAT_45,c.UT_MAT_44,c.UT_MAT_43,c.UT_MAT_42,c.UT_MAT_41,c.UT_MAT_40,c.UT_MAT_39,c.UT_MAT_38,c.UT_MAT_37,c.UT_MAT_36,c.UT_MAT_35,c.UT_MAT_34,c.UT_MAT_33,c.UT_MAT_32,c.UT_MAT_31,
    c.UT_MAT_30,c.UT_MAT_29,c.UT_MAT_28,c.UT_MAT_27,c.UT_MAT_26,c.UT_MAT_25,c.UT_MAT_24,c.UT_MAT_23,c.UT_MAT_22,c.UT_MAT_21,c.UT_MAT_20,c.UT_MAT_19,c.UT_MAT_18,c.UT_MAT_17,c.UT_MAT_16,
    c.UT_MAT_15,c.UT_MAT_14,c.UT_MAT_13,c.UT_MAT_12,c.UT_MAT_11,c.UT_MAT_10,c.UT_MAT_9,c.UT_MAT_8,c.UT_MAT_7,c.UT_MAT_6,c.UT_MAT_5,c.UT_MAT_4,c.UT_MAT_3,c.UT_MAT_2,c.UT_MAT_1
from tblOutput_MAX_TA_RMB_MAT_Global a
inner join tblOutput_MAX_TA_USD_MAT_Global b
on a.mkt=b.mkt and a.geo=b.geo and a.class=b.class and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
and case when a.corp_code is null then '' else a.corp_code end=case when b.corp_code is null then '' else b.corp_code end 
and case when a.manuf_code is null then '' else a.manuf_code end =case when b.manuf_code is null then '' else b.manuf_code end
inner join tblOutput_MAX_TA_UNT_MAT_Global c
on a.mkt=c.mkt and a.geo=c.geo and a.class=c.class and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
and case when a.corp_code is null then '' else a.corp_code end=case when c.corp_code is null then '' else c.corp_code end 
and case when a.manuf_code is null then '' else a.manuf_code end =case when c.manuf_code is null then '' else c.manuf_code end
go


--YTD:



IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_TA_YTD_Inline')
DROP VIEW tblOutput_MAX_TA_YTD_Inline
go
CREATE VIEW tblOutput_MAX_TA_YTD_Inline
as
select 'YTD' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code,
    a.VR_YTD_60,a.VR_YTD_59,a.VR_YTD_58,a.VR_YTD_57,a.VR_YTD_56,a.VR_YTD_55,a.VR_YTD_54,a.VR_YTD_53,a.VR_YTD_52,a.VR_YTD_51,a.VR_YTD_50,a.VR_YTD_49,a.VR_YTD_48,a.VR_YTD_47,a.VR_YTD_46,
    a.VR_YTD_45,a.VR_YTD_44,a.VR_YTD_43,a.VR_YTD_42,a.VR_YTD_41,a.VR_YTD_40,a.VR_YTD_39,a.VR_YTD_38,a.VR_YTD_37,a.VR_YTD_36,a.VR_YTD_35,a.VR_YTD_34,a.VR_YTD_33,a.VR_YTD_32,a.VR_YTD_31,
    a.VR_YTD_30,a.VR_YTD_29,a.VR_YTD_28,a.VR_YTD_27,a.VR_YTD_26,a.VR_YTD_25,a.VR_YTD_24,a.VR_YTD_23,a.VR_YTD_22,a.VR_YTD_21,a.VR_YTD_20,a.VR_YTD_19,a.VR_YTD_18,a.VR_YTD_17,a.VR_YTD_16,
    a.VR_YTD_15,a.VR_YTD_14,a.VR_YTD_13,a.VR_YTD_12,a.VR_YTD_11,a.VR_YTD_10,a.VR_YTD_9,a.VR_YTD_8,a.VR_YTD_7,a.VR_YTD_6,a.VR_YTD_5,a.VR_YTD_4,a.VR_YTD_3,a.VR_YTD_2,a.VR_YTD_1,
    a.VR_YTD_SHR_60,a.VR_YTD_SHR_59,a.VR_YTD_SHR_58,a.VR_YTD_SHR_57,a.VR_YTD_SHR_56,a.VR_YTD_SHR_55,a.VR_YTD_SHR_54,a.VR_YTD_SHR_53,a.VR_YTD_SHR_52,a.VR_YTD_SHR_51,a.VR_YTD_SHR_50,a.VR_YTD_SHR_49,a.VR_YTD_SHR_48,a.VR_YTD_SHR_47,a.VR_YTD_SHR_46,
    a.VR_YTD_SHR_45,a.VR_YTD_SHR_44,a.VR_YTD_SHR_43,a.VR_YTD_SHR_42,a.VR_YTD_SHR_41,a.VR_YTD_SHR_40,a.VR_YTD_SHR_39,a.VR_YTD_SHR_38,a.VR_YTD_SHR_37,a.VR_YTD_SHR_36,a.VR_YTD_SHR_35,a.VR_YTD_SHR_34,a.VR_YTD_SHR_33,a.VR_YTD_SHR_32,a.VR_YTD_SHR_31,
    a.VR_YTD_SHR_30,a.VR_YTD_SHR_29,a.VR_YTD_SHR_28,a.VR_YTD_SHR_27,a.VR_YTD_SHR_26,a.VR_YTD_SHR_25,a.VR_YTD_SHR_24,a.VR_YTD_SHR_23,a.VR_YTD_SHR_22,a.VR_YTD_SHR_21,a.VR_YTD_SHR_20,a.VR_YTD_SHR_19,a.VR_YTD_SHR_18,a.VR_YTD_SHR_17,a.VR_YTD_SHR_16,
    a.VR_YTD_SHR_15,a.VR_YTD_SHR_14,a.VR_YTD_SHR_13,a.VR_YTD_SHR_12,a.VR_YTD_SHR_11,a.VR_YTD_SHR_10,a.VR_YTD_SHR_9,a.VR_YTD_SHR_8,a.VR_YTD_SHR_7,a.VR_YTD_SHR_6,a.VR_YTD_SHR_5,a.VR_YTD_SHR_4,a.VR_YTD_SHR_3,a.VR_YTD_SHR_2,a.VR_YTD_SHR_1,
    b.VU_YTD_60,b.VU_YTD_59,b.VU_YTD_58,b.VU_YTD_57,b.VU_YTD_56,b.VU_YTD_55,b.VU_YTD_54,b.VU_YTD_53,b.VU_YTD_52,b.VU_YTD_51,b.VU_YTD_50,b.VU_YTD_49,b.VU_YTD_48,b.VU_YTD_47,b.VU_YTD_46,
    b.VU_YTD_45,b.VU_YTD_44,b.VU_YTD_43,b.VU_YTD_42,b.VU_YTD_41,b.VU_YTD_40,b.VU_YTD_39,b.VU_YTD_38,b.VU_YTD_37,b.VU_YTD_36,b.VU_YTD_35,b.VU_YTD_34,b.VU_YTD_33,b.VU_YTD_32,b.VU_YTD_31,
    b.VU_YTD_30,b.VU_YTD_29,b.VU_YTD_28,b.VU_YTD_27,b.VU_YTD_26,b.VU_YTD_25,b.VU_YTD_24,b.VU_YTD_23,b.VU_YTD_22,b.VU_YTD_21,b.VU_YTD_20,b.VU_YTD_19,b.VU_YTD_18,b.VU_YTD_17,b.VU_YTD_16,
    b.VU_YTD_15,b.VU_YTD_14,b.VU_YTD_13,b.VU_YTD_12,b.VU_YTD_11,b.VU_YTD_10,b.VU_YTD_9,b.VU_YTD_8,b.VU_YTD_7,b.VU_YTD_6,b.VU_YTD_5,b.VU_YTD_4,b.VU_YTD_3,b.VU_YTD_2,b.VU_YTD_1,
    b.VU_YTD_SHR_60,b.VU_YTD_SHR_59,b.VU_YTD_SHR_58,b.VU_YTD_SHR_57,b.VU_YTD_SHR_56,b.VU_YTD_SHR_55,b.VU_YTD_SHR_54,b.VU_YTD_SHR_53,b.VU_YTD_SHR_52,b.VU_YTD_SHR_51,b.VU_YTD_SHR_50,b.VU_YTD_SHR_49,b.VU_YTD_SHR_48,b.VU_YTD_SHR_47,b.VU_YTD_SHR_46,
    b.VU_YTD_SHR_45,b.VU_YTD_SHR_44,b.VU_YTD_SHR_43,b.VU_YTD_SHR_42,b.VU_YTD_SHR_41,b.VU_YTD_SHR_40,b.VU_YTD_SHR_39,b.VU_YTD_SHR_38,b.VU_YTD_SHR_37,b.VU_YTD_SHR_36,b.VU_YTD_SHR_35,b.VU_YTD_SHR_34,b.VU_YTD_SHR_33,b.VU_YTD_SHR_32,b.VU_YTD_SHR_31,
    b.VU_YTD_SHR_30,b.VU_YTD_SHR_29,b.VU_YTD_SHR_28,b.VU_YTD_SHR_27,b.VU_YTD_SHR_26,b.VU_YTD_SHR_25,b.VU_YTD_SHR_24,b.VU_YTD_SHR_23,b.VU_YTD_SHR_22,b.VU_YTD_SHR_21,b.VU_YTD_SHR_20,b.VU_YTD_SHR_19,b.VU_YTD_SHR_18,b.VU_YTD_SHR_17,b.VU_YTD_SHR_16,
    b.VU_YTD_SHR_15,b.VU_YTD_SHR_14,b.VU_YTD_SHR_13,b.VU_YTD_SHR_12,b.VU_YTD_SHR_11,b.VU_YTD_SHR_10,b.VU_YTD_SHR_9,b.VU_YTD_SHR_8,b.VU_YTD_SHR_7,b.VU_YTD_SHR_6,b.VU_YTD_SHR_5,b.VU_YTD_SHR_4,b.VU_YTD_SHR_3,b.VU_YTD_SHR_2,b.VU_YTD_SHR_1,
    c.UT_YTD_60,c.UT_YTD_59,c.UT_YTD_58,c.UT_YTD_57,c.UT_YTD_56,c.UT_YTD_55,c.UT_YTD_54,c.UT_YTD_53,c.UT_YTD_52,c.UT_YTD_51,c.UT_YTD_50,c.UT_YTD_49,c.UT_YTD_48,c.UT_YTD_47,c.UT_YTD_46,
    c.UT_YTD_45,c.UT_YTD_44,c.UT_YTD_43,c.UT_YTD_42,c.UT_YTD_41,c.UT_YTD_40,c.UT_YTD_39,c.UT_YTD_38,c.UT_YTD_37,c.UT_YTD_36,c.UT_YTD_35,c.UT_YTD_34,c.UT_YTD_33,c.UT_YTD_32,c.UT_YTD_31,
    c.UT_YTD_30,c.UT_YTD_29,c.UT_YTD_28,c.UT_YTD_27,c.UT_YTD_26,c.UT_YTD_25,c.UT_YTD_24,c.UT_YTD_23,c.UT_YTD_22,c.UT_YTD_21,c.UT_YTD_20,c.UT_YTD_19,c.UT_YTD_18,c.UT_YTD_17,c.UT_YTD_16,
    c.UT_YTD_15,c.UT_YTD_14,c.UT_YTD_13,c.UT_YTD_12,c.UT_YTD_11,c.UT_YTD_10,c.UT_YTD_9,c.UT_YTD_8,c.UT_YTD_7,c.UT_YTD_6,c.UT_YTD_5,c.UT_YTD_4,c.UT_YTD_3,c.UT_YTD_2,c.UT_YTD_1,
    c.UT_YTD_SHR_60,c.UT_YTD_SHR_59,c.UT_YTD_SHR_58,c.UT_YTD_SHR_57,c.UT_YTD_SHR_56,c.UT_YTD_SHR_55,c.UT_YTD_SHR_54,c.UT_YTD_SHR_53,c.UT_YTD_SHR_52,c.UT_YTD_SHR_51,c.UT_YTD_SHR_50,c.UT_YTD_SHR_49,c.UT_YTD_SHR_48,c.UT_YTD_SHR_47,c.UT_YTD_SHR_46,
    c.UT_YTD_SHR_45,c.UT_YTD_SHR_44,c.UT_YTD_SHR_43,c.UT_YTD_SHR_42,c.UT_YTD_SHR_41,c.UT_YTD_SHR_40,c.UT_YTD_SHR_39,c.UT_YTD_SHR_38,c.UT_YTD_SHR_37,c.UT_YTD_SHR_36,c.UT_YTD_SHR_35,c.UT_YTD_SHR_34,c.UT_YTD_SHR_33,c.UT_YTD_SHR_32,c.UT_YTD_SHR_31,
    c.UT_YTD_SHR_30,c.UT_YTD_SHR_29,c.UT_YTD_SHR_28,c.UT_YTD_SHR_27,c.UT_YTD_SHR_26,c.UT_YTD_SHR_25,c.UT_YTD_SHR_24,c.UT_YTD_SHR_23,c.UT_YTD_SHR_22,c.UT_YTD_SHR_21,c.UT_YTD_SHR_20,c.UT_YTD_SHR_19,c.UT_YTD_SHR_18,c.UT_YTD_SHR_17,c.UT_YTD_SHR_16,
    c.UT_YTD_SHR_15,c.UT_YTD_SHR_14,c.UT_YTD_SHR_13,c.UT_YTD_SHR_12,c.UT_YTD_SHR_11,c.UT_YTD_SHR_10,c.UT_YTD_SHR_9,c.UT_YTD_SHR_8,c.UT_YTD_SHR_7,c.UT_YTD_SHR_6,c.UT_YTD_SHR_5,c.UT_YTD_SHR_4,c.UT_YTD_SHR_3,c.UT_YTD_SHR_2,c.UT_YTD_SHR_1
from tblOutput_MAX_TA_RMB_YTD_Inline a
inner join tblOutput_MAX_TA_USD_YTD_Inline b
on a.mkt=b.mkt and a.geo=b.geo and a.class=b.class and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
and case when a.corp_code is null then '' else a.corp_code end=case when b.corp_code is null then '' else b.corp_code end 
and case when a.manuf_code is null then '' else a.manuf_code end =case when b.manuf_code is null then '' else b.manuf_code end
inner join tblOutput_MAX_TA_UNT_YTD_Inline c
on a.mkt=c.mkt and a.geo=c.geo and a.class=c.class and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
and case when a.corp_code is null then '' else a.corp_code end=case when c.corp_code is null then '' else c.corp_code end 
and case when a.manuf_code is null then '' else a.manuf_code end =case when c.manuf_code is null then '' else c.manuf_code end
GO





IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_TA_YTD_Global')
DROP VIEW tblOutput_MAX_TA_YTD_Global
go
CREATE VIEW tblOutput_MAX_TA_YTD_Global
as
select 'YTD' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code,
    a.VR_YTD_60,a.VR_YTD_59,a.VR_YTD_58,a.VR_YTD_57,a.VR_YTD_56,a.VR_YTD_55,a.VR_YTD_54,a.VR_YTD_53,a.VR_YTD_52,a.VR_YTD_51,a.VR_YTD_50,a.VR_YTD_49,a.VR_YTD_48,a.VR_YTD_47,a.VR_YTD_46,
    a.VR_YTD_45,a.VR_YTD_44,a.VR_YTD_43,a.VR_YTD_42,a.VR_YTD_41,a.VR_YTD_40,a.VR_YTD_39,a.VR_YTD_38,a.VR_YTD_37,a.VR_YTD_36,a.VR_YTD_35,a.VR_YTD_34,a.VR_YTD_33,a.VR_YTD_32,a.VR_YTD_31,
    a.VR_YTD_30,a.VR_YTD_29,a.VR_YTD_28,a.VR_YTD_27,a.VR_YTD_26,a.VR_YTD_25,a.VR_YTD_24,a.VR_YTD_23,a.VR_YTD_22,a.VR_YTD_21,a.VR_YTD_20,a.VR_YTD_19,a.VR_YTD_18,a.VR_YTD_17,a.VR_YTD_16,
    a.VR_YTD_15,a.VR_YTD_14,a.VR_YTD_13,a.VR_YTD_12,a.VR_YTD_11,a.VR_YTD_10,a.VR_YTD_9,a.VR_YTD_8,a.VR_YTD_7,a.VR_YTD_6,a.VR_YTD_5,a.VR_YTD_4,a.VR_YTD_3,a.VR_YTD_2,a.VR_YTD_1,
    b.VU_YTD_60,b.VU_YTD_59,b.VU_YTD_58,b.VU_YTD_57,b.VU_YTD_56,b.VU_YTD_55,b.VU_YTD_54,b.VU_YTD_53,b.VU_YTD_52,b.VU_YTD_51,b.VU_YTD_50,b.VU_YTD_49,b.VU_YTD_48,b.VU_YTD_47,b.VU_YTD_46,
    b.VU_YTD_45,b.VU_YTD_44,b.VU_YTD_43,b.VU_YTD_42,b.VU_YTD_41,b.VU_YTD_40,b.VU_YTD_39,b.VU_YTD_38,b.VU_YTD_37,b.VU_YTD_36,b.VU_YTD_35,b.VU_YTD_34,b.VU_YTD_33,b.VU_YTD_32,b.VU_YTD_31,
    b.VU_YTD_30,b.VU_YTD_29,b.VU_YTD_28,b.VU_YTD_27,b.VU_YTD_26,b.VU_YTD_25,b.VU_YTD_24,b.VU_YTD_23,b.VU_YTD_22,b.VU_YTD_21,b.VU_YTD_20,b.VU_YTD_19,b.VU_YTD_18,b.VU_YTD_17,b.VU_YTD_16,
    b.VU_YTD_15,b.VU_YTD_14,b.VU_YTD_13,b.VU_YTD_12,b.VU_YTD_11,b.VU_YTD_10,b.VU_YTD_9,b.VU_YTD_8,b.VU_YTD_7,b.VU_YTD_6,b.VU_YTD_5,b.VU_YTD_4,b.VU_YTD_3,b.VU_YTD_2,b.VU_YTD_1,
    c.UT_YTD_60,c.UT_YTD_59,c.UT_YTD_58,c.UT_YTD_57,c.UT_YTD_56,c.UT_YTD_55,c.UT_YTD_54,c.UT_YTD_53,c.UT_YTD_52,c.UT_YTD_51,c.UT_YTD_50,c.UT_YTD_49,c.UT_YTD_48,c.UT_YTD_47,c.UT_YTD_46,
    c.UT_YTD_45,c.UT_YTD_44,c.UT_YTD_43,c.UT_YTD_42,c.UT_YTD_41,c.UT_YTD_40,c.UT_YTD_39,c.UT_YTD_38,c.UT_YTD_37,c.UT_YTD_36,c.UT_YTD_35,c.UT_YTD_34,c.UT_YTD_33,c.UT_YTD_32,c.UT_YTD_31,
    c.UT_YTD_30,c.UT_YTD_29,c.UT_YTD_28,c.UT_YTD_27,c.UT_YTD_26,c.UT_YTD_25,c.UT_YTD_24,c.UT_YTD_23,c.UT_YTD_22,c.UT_YTD_21,c.UT_YTD_20,c.UT_YTD_19,c.UT_YTD_18,c.UT_YTD_17,c.UT_YTD_16,
    c.UT_YTD_15,c.UT_YTD_14,c.UT_YTD_13,c.UT_YTD_12,c.UT_YTD_11,c.UT_YTD_10,c.UT_YTD_9,c.UT_YTD_8,c.UT_YTD_7,c.UT_YTD_6,c.UT_YTD_5,c.UT_YTD_4,c.UT_YTD_3,c.UT_YTD_2,c.UT_YTD_1
from tblOutput_MAX_TA_RMB_YTD_Global a
inner join tblOutput_MAX_TA_USD_YTD_Global b
on a.mkt=b.mkt and a.geo=b.geo and a.class=b.class and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
and case when a.corp_code is null then '' else a.corp_code end=case when b.corp_code is null then '' else b.corp_code end 
and case when a.manuf_code is null then '' else a.manuf_code end =case when b.manuf_code is null then '' else b.manuf_code end
inner join tblOutput_MAX_TA_UNT_YTD_Global c
on a.mkt=c.mkt and a.geo=c.geo and a.class=c.class and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
and case when a.corp_code is null then '' else a.corp_code end=case when c.corp_code is null then '' else c.corp_code end 
and case when a.manuf_code is null then '' else a.manuf_code end =case when c.manuf_code is null then '' else c.manuf_code end
go


--ATC:

--MTH:

IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_ATC_MTH')
DROP VIEW tblOutput_MAX_ATC_MTH
go
CREATE VIEW tblOutput_MAX_ATC_MTH
as

select 'MTH' as datatype,a.atc1_code,a.atc1_des,a.atc2_code,a.atc2_des,a.atc3_code,a.atc3_des,a.atc4_code,a.atc4_des,a.geo,a.geo_lvl,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code,
    a.VR_MTH_60,a.VR_MTH_59,a.VR_MTH_58,a.VR_MTH_57,a.VR_MTH_56,a.VR_MTH_55,a.VR_MTH_54,a.VR_MTH_53,a.VR_MTH_52,a.VR_MTH_51,a.VR_MTH_50,a.VR_MTH_49,a.VR_MTH_48,a.VR_MTH_47,a.VR_MTH_46,
    a.VR_MTH_45,a.VR_MTH_44,a.VR_MTH_43,a.VR_MTH_42,a.VR_MTH_41,a.VR_MTH_40,a.VR_MTH_39,a.VR_MTH_38,a.VR_MTH_37,a.VR_MTH_36,a.VR_MTH_35,a.VR_MTH_34,a.VR_MTH_33,a.VR_MTH_32,a.VR_MTH_31,
    a.VR_MTH_30,a.VR_MTH_29,a.VR_MTH_28,a.VR_MTH_27,a.VR_MTH_26,a.VR_MTH_25,a.VR_MTH_24,a.VR_MTH_23,a.VR_MTH_22,a.VR_MTH_21,a.VR_MTH_20,a.VR_MTH_19,a.VR_MTH_18,a.VR_MTH_17,a.VR_MTH_16,
    a.VR_MTH_15,a.VR_MTH_14,a.VR_MTH_13,a.VR_MTH_12,a.VR_MTH_11,a.VR_MTH_10,a.VR_MTH_9,a.VR_MTH_8,a.VR_MTH_7,a.VR_MTH_6,a.VR_MTH_5,a.VR_MTH_4,a.VR_MTH_3,a.VR_MTH_2,a.VR_MTH_1,
    b.VU_MTH_60,b.VU_MTH_59,b.VU_MTH_58,b.VU_MTH_57,b.VU_MTH_56,b.VU_MTH_55,b.VU_MTH_54,b.VU_MTH_53,b.VU_MTH_52,b.VU_MTH_51,b.VU_MTH_50,b.VU_MTH_49,b.VU_MTH_48,b.VU_MTH_47,b.VU_MTH_46,
    b.VU_MTH_45,b.VU_MTH_44,b.VU_MTH_43,b.VU_MTH_42,b.VU_MTH_41,b.VU_MTH_40,b.VU_MTH_39,b.VU_MTH_38,b.VU_MTH_37,b.VU_MTH_36,b.VU_MTH_35,b.VU_MTH_34,b.VU_MTH_33,b.VU_MTH_32,b.VU_MTH_31,
    b.VU_MTH_30,b.VU_MTH_29,b.VU_MTH_28,b.VU_MTH_27,b.VU_MTH_26,b.VU_MTH_25,b.VU_MTH_24,b.VU_MTH_23,b.VU_MTH_22,b.VU_MTH_21,b.VU_MTH_20,b.VU_MTH_19,b.VU_MTH_18,b.VU_MTH_17,b.VU_MTH_16,
    b.VU_MTH_15,b.VU_MTH_14,b.VU_MTH_13,b.VU_MTH_12,b.VU_MTH_11,b.VU_MTH_10,b.VU_MTH_9,b.VU_MTH_8,b.VU_MTH_7,b.VU_MTH_6,b.VU_MTH_5,b.VU_MTH_4,b.VU_MTH_3,b.VU_MTH_2,b.VU_MTH_1,
    c.UT_MTH_60,c.UT_MTH_59,c.UT_MTH_58,c.UT_MTH_57,c.UT_MTH_56,c.UT_MTH_55,c.UT_MTH_54,c.UT_MTH_53,c.UT_MTH_52,c.UT_MTH_51,c.UT_MTH_50,c.UT_MTH_49,c.UT_MTH_48,c.UT_MTH_47,c.UT_MTH_46,
    c.UT_MTH_45,c.UT_MTH_44,c.UT_MTH_43,c.UT_MTH_42,c.UT_MTH_41,c.UT_MTH_40,c.UT_MTH_39,c.UT_MTH_38,c.UT_MTH_37,c.UT_MTH_36,c.UT_MTH_35,c.UT_MTH_34,c.UT_MTH_33,c.UT_MTH_32,c.UT_MTH_31,
    c.UT_MTH_30,c.UT_MTH_29,c.UT_MTH_28,c.UT_MTH_27,c.UT_MTH_26,c.UT_MTH_25,c.UT_MTH_24,c.UT_MTH_23,c.UT_MTH_22,c.UT_MTH_21,c.UT_MTH_20,c.UT_MTH_19,c.UT_MTH_18,c.UT_MTH_17,c.UT_MTH_16,
    c.UT_MTH_15,c.UT_MTH_14,c.UT_MTH_13,c.UT_MTH_12,c.UT_MTH_11,c.UT_MTH_10,c.UT_MTH_9,c.UT_MTH_8,c.UT_MTH_7,c.UT_MTH_6,c.UT_MTH_5,c.UT_MTH_4,c.UT_MTH_3,c.UT_MTH_2,c.UT_MTH_1
from tblOutput_MAX_ATC_RMB_MTH a
inner join tblOutput_MAX_ATC_USD_MTH b
on a.atc1_code=b.atc1_code and  a.atc2_code=b.atc2_code and a.atc3_code=b.atc3_code and   a.atc4_code=b.atc4_code and a.geo=b.geo and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
and case when a.corp_code is null then '' else a.corp_code end=case when b.corp_code is null then '' else b.corp_code end 
and case when a.manuf_code is null then '' else a.manuf_code end =case when b.manuf_code is null then '' else b.manuf_code end
inner join tblOutput_MAX_ATC_UNT_MTH c
on a.atc1_code=c.atc1_code and  a.atc2_code=c.atc2_code and a.atc3_code=c.atc3_code and   a.atc4_code=c.atc4_code and a.geo=c.geo and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
and case when a.corp_code is null then '' else a.corp_code end=case when c.corp_code is null then '' else c.corp_code end 
and case when a.manuf_code is null then '' else a.manuf_code end =case when c.manuf_code is null then '' else c.manuf_code end
GO
--MQT:

IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_ATC_MQT')
DROP VIEW tblOutput_MAX_ATC_MQT
go
CREATE VIEW tblOutput_MAX_ATC_MQT
as

select 'MQT' as datatype,a.atc1_code,a.atc1_des,a.atc2_code,a.atc2_des,a.atc3_code,a.atc3_des,a.atc4_code,a.atc4_des,a.geo,a.geo_lvl,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code,
    a.VR_MQT_60,a.VR_MQT_59,a.VR_MQT_58,a.VR_MQT_57,a.VR_MQT_56,a.VR_MQT_55,a.VR_MQT_54,a.VR_MQT_53,a.VR_MQT_52,a.VR_MQT_51,a.VR_MQT_50,a.VR_MQT_49,a.VR_MQT_48,a.VR_MQT_47,a.VR_MQT_46,
    a.VR_MQT_45,a.VR_MQT_44,a.VR_MQT_43,a.VR_MQT_42,a.VR_MQT_41,a.VR_MQT_40,a.VR_MQT_39,a.VR_MQT_38,a.VR_MQT_37,a.VR_MQT_36,a.VR_MQT_35,a.VR_MQT_34,a.VR_MQT_33,a.VR_MQT_32,a.VR_MQT_31,
    a.VR_MQT_30,a.VR_MQT_29,a.VR_MQT_28,a.VR_MQT_27,a.VR_MQT_26,a.VR_MQT_25,a.VR_MQT_24,a.VR_MQT_23,a.VR_MQT_22,a.VR_MQT_21,a.VR_MQT_20,a.VR_MQT_19,a.VR_MQT_18,a.VR_MQT_17,a.VR_MQT_16,
    a.VR_MQT_15,a.VR_MQT_14,a.VR_MQT_13,a.VR_MQT_12,a.VR_MQT_11,a.VR_MQT_10,a.VR_MQT_9,a.VR_MQT_8,a.VR_MQT_7,a.VR_MQT_6,a.VR_MQT_5,a.VR_MQT_4,a.VR_MQT_3,a.VR_MQT_2,a.VR_MQT_1,
    b.VU_MQT_60,b.VU_MQT_59,b.VU_MQT_58,b.VU_MQT_57,b.VU_MQT_56,b.VU_MQT_55,b.VU_MQT_54,b.VU_MQT_53,b.VU_MQT_52,b.VU_MQT_51,b.VU_MQT_50,b.VU_MQT_49,b.VU_MQT_48,b.VU_MQT_47,b.VU_MQT_46,
    b.VU_MQT_45,b.VU_MQT_44,b.VU_MQT_43,b.VU_MQT_42,b.VU_MQT_41,b.VU_MQT_40,b.VU_MQT_39,b.VU_MQT_38,b.VU_MQT_37,b.VU_MQT_36,b.VU_MQT_35,b.VU_MQT_34,b.VU_MQT_33,b.VU_MQT_32,b.VU_MQT_31,
    b.VU_MQT_30,b.VU_MQT_29,b.VU_MQT_28,b.VU_MQT_27,b.VU_MQT_26,b.VU_MQT_25,b.VU_MQT_24,b.VU_MQT_23,b.VU_MQT_22,b.VU_MQT_21,b.VU_MQT_20,b.VU_MQT_19,b.VU_MQT_18,b.VU_MQT_17,b.VU_MQT_16,
    b.VU_MQT_15,b.VU_MQT_14,b.VU_MQT_13,b.VU_MQT_12,b.VU_MQT_11,b.VU_MQT_10,b.VU_MQT_9,b.VU_MQT_8,b.VU_MQT_7,b.VU_MQT_6,b.VU_MQT_5,b.VU_MQT_4,b.VU_MQT_3,b.VU_MQT_2,b.VU_MQT_1,
    c.UT_MQT_60,c.UT_MQT_59,c.UT_MQT_58,c.UT_MQT_57,c.UT_MQT_56,c.UT_MQT_55,c.UT_MQT_54,c.UT_MQT_53,c.UT_MQT_52,c.UT_MQT_51,c.UT_MQT_50,c.UT_MQT_49,c.UT_MQT_48,c.UT_MQT_47,c.UT_MQT_46,
    c.UT_MQT_45,c.UT_MQT_44,c.UT_MQT_43,c.UT_MQT_42,c.UT_MQT_41,c.UT_MQT_40,c.UT_MQT_39,c.UT_MQT_38,c.UT_MQT_37,c.UT_MQT_36,c.UT_MQT_35,c.UT_MQT_34,c.UT_MQT_33,c.UT_MQT_32,c.UT_MQT_31,
    c.UT_MQT_30,c.UT_MQT_29,c.UT_MQT_28,c.UT_MQT_27,c.UT_MQT_26,c.UT_MQT_25,c.UT_MQT_24,c.UT_MQT_23,c.UT_MQT_22,c.UT_MQT_21,c.UT_MQT_20,c.UT_MQT_19,c.UT_MQT_18,c.UT_MQT_17,c.UT_MQT_16,
    c.UT_MQT_15,c.UT_MQT_14,c.UT_MQT_13,c.UT_MQT_12,c.UT_MQT_11,c.UT_MQT_10,c.UT_MQT_9,c.UT_MQT_8,c.UT_MQT_7,c.UT_MQT_6,c.UT_MQT_5,c.UT_MQT_4,c.UT_MQT_3,c.UT_MQT_2,c.UT_MQT_1
from tblOutput_MAX_ATC_RMB_MQT a
inner join tblOutput_MAX_ATC_USD_MQT b
on a.atc1_code=b.atc1_code and  a.atc2_code=b.atc2_code and a.atc3_code=b.atc3_code and   a.atc4_code=b.atc4_code and a.geo=b.geo and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
and case when a.corp_code is null then '' else a.corp_code end=case when b.corp_code is null then '' else b.corp_code end 
and case when a.manuf_code is null then '' else a.manuf_code end =case when b.manuf_code is null then '' else b.manuf_code end
inner join tblOutput_MAX_ATC_UNT_MQT c
on a.atc1_code=c.atc1_code and  a.atc2_code=c.atc2_code and a.atc3_code=c.atc3_code and   a.atc4_code=c.atc4_code and a.geo=c.geo and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
and case when a.corp_code is null then '' else a.corp_code end=case when c.corp_code is null then '' else c.corp_code end 
and case when a.manuf_code is null then '' else a.manuf_code end =case when c.manuf_code is null then '' else c.manuf_code end
GO

--MAT:
IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_ATC_MAT')
DROP VIEW tblOutput_MAX_ATC_MAT
go
CREATE VIEW tblOutput_MAX_ATC_MAT
as

select 'MAT' as datatype,a.atc1_code,a.atc1_des,a.atc2_code,a.atc2_des,a.atc3_code,a.atc3_des,a.atc4_code,a.atc4_des,a.geo,a.geo_lvl,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code,
    a.VR_MAT_60,a.VR_MAT_59,a.VR_MAT_58,a.VR_MAT_57,a.VR_MAT_56,a.VR_MAT_55,a.VR_MAT_54,a.VR_MAT_53,a.VR_MAT_52,a.VR_MAT_51,a.VR_MAT_50,a.VR_MAT_49,a.VR_MAT_48,a.VR_MAT_47,a.VR_MAT_46,
    a.VR_MAT_45,a.VR_MAT_44,a.VR_MAT_43,a.VR_MAT_42,a.VR_MAT_41,a.VR_MAT_40,a.VR_MAT_39,a.VR_MAT_38,a.VR_MAT_37,a.VR_MAT_36,a.VR_MAT_35,a.VR_MAT_34,a.VR_MAT_33,a.VR_MAT_32,a.VR_MAT_31,
    a.VR_MAT_30,a.VR_MAT_29,a.VR_MAT_28,a.VR_MAT_27,a.VR_MAT_26,a.VR_MAT_25,a.VR_MAT_24,a.VR_MAT_23,a.VR_MAT_22,a.VR_MAT_21,a.VR_MAT_20,a.VR_MAT_19,a.VR_MAT_18,a.VR_MAT_17,a.VR_MAT_16,
    a.VR_MAT_15,a.VR_MAT_14,a.VR_MAT_13,a.VR_MAT_12,a.VR_MAT_11,a.VR_MAT_10,a.VR_MAT_9,a.VR_MAT_8,a.VR_MAT_7,a.VR_MAT_6,a.VR_MAT_5,a.VR_MAT_4,a.VR_MAT_3,a.VR_MAT_2,a.VR_MAT_1,
    b.VU_MAT_60,b.VU_MAT_59,b.VU_MAT_58,b.VU_MAT_57,b.VU_MAT_56,b.VU_MAT_55,b.VU_MAT_54,b.VU_MAT_53,b.VU_MAT_52,b.VU_MAT_51,b.VU_MAT_50,b.VU_MAT_49,b.VU_MAT_48,b.VU_MAT_47,b.VU_MAT_46,
    b.VU_MAT_45,b.VU_MAT_44,b.VU_MAT_43,b.VU_MAT_42,b.VU_MAT_41,b.VU_MAT_40,b.VU_MAT_39,b.VU_MAT_38,b.VU_MAT_37,b.VU_MAT_36,b.VU_MAT_35,b.VU_MAT_34,b.VU_MAT_33,b.VU_MAT_32,b.VU_MAT_31,
    b.VU_MAT_30,b.VU_MAT_29,b.VU_MAT_28,b.VU_MAT_27,b.VU_MAT_26,b.VU_MAT_25,b.VU_MAT_24,b.VU_MAT_23,b.VU_MAT_22,b.VU_MAT_21,b.VU_MAT_20,b.VU_MAT_19,b.VU_MAT_18,b.VU_MAT_17,b.VU_MAT_16,
    b.VU_MAT_15,b.VU_MAT_14,b.VU_MAT_13,b.VU_MAT_12,b.VU_MAT_11,b.VU_MAT_10,b.VU_MAT_9,b.VU_MAT_8,b.VU_MAT_7,b.VU_MAT_6,b.VU_MAT_5,b.VU_MAT_4,b.VU_MAT_3,b.VU_MAT_2,b.VU_MAT_1,
    c.UT_MAT_60,c.UT_MAT_59,c.UT_MAT_58,c.UT_MAT_57,c.UT_MAT_56,c.UT_MAT_55,c.UT_MAT_54,c.UT_MAT_53,c.UT_MAT_52,c.UT_MAT_51,c.UT_MAT_50,c.UT_MAT_49,c.UT_MAT_48,c.UT_MAT_47,c.UT_MAT_46,
    c.UT_MAT_45,c.UT_MAT_44,c.UT_MAT_43,c.UT_MAT_42,c.UT_MAT_41,c.UT_MAT_40,c.UT_MAT_39,c.UT_MAT_38,c.UT_MAT_37,c.UT_MAT_36,c.UT_MAT_35,c.UT_MAT_34,c.UT_MAT_33,c.UT_MAT_32,c.UT_MAT_31,
    c.UT_MAT_30,c.UT_MAT_29,c.UT_MAT_28,c.UT_MAT_27,c.UT_MAT_26,c.UT_MAT_25,c.UT_MAT_24,c.UT_MAT_23,c.UT_MAT_22,c.UT_MAT_21,c.UT_MAT_20,c.UT_MAT_19,c.UT_MAT_18,c.UT_MAT_17,c.UT_MAT_16,
    c.UT_MAT_15,c.UT_MAT_14,c.UT_MAT_13,c.UT_MAT_12,c.UT_MAT_11,c.UT_MAT_10,c.UT_MAT_9,c.UT_MAT_8,c.UT_MAT_7,c.UT_MAT_6,c.UT_MAT_5,c.UT_MAT_4,c.UT_MAT_3,c.UT_MAT_2,c.UT_MAT_1
from tblOutput_MAX_ATC_RMB_MAT a
inner join tblOutput_MAX_ATC_USD_MAT b
    on a.atc1_code=b.atc1_code and  a.atc2_code=b.atc2_code and a.atc3_code=b.atc3_code and   a.atc4_code=b.atc4_code and a.geo=b.geo and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
        and case when a.corp_code is null then '' else a.corp_code end=case when b.corp_code is null then '' else b.corp_code end 
        and case when a.manuf_code is null then '' else a.manuf_code end =case when b.manuf_code is null then '' else b.manuf_code end
inner join tblOutput_MAX_ATC_UNT_MAT c
    on a.atc1_code=c.atc1_code and  a.atc2_code=c.atc2_code and a.atc3_code=c.atc3_code and   a.atc4_code=c.atc4_code and a.geo=c.geo and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
        and case when a.corp_code is null then '' else a.corp_code end=case when c.corp_code is null then '' else c.corp_code end 
        and case when a.manuf_code is null then '' else a.manuf_code end =case when c.manuf_code is null then '' else c.manuf_code end

GO
--YTD:
IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_ATC_YTD')
DROP VIEW tblOutput_MAX_ATC_YTD
go
CREATE VIEW tblOutput_MAX_ATC_YTD
as

select 'YTD' as datatype,a.atc1_code,a.atc1_des,a.atc2_code,a.atc2_des,a.atc3_code,a.atc3_des,a.atc4_code,a.atc4_des,a.geo,a.geo_lvl,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code,
    a.VR_YTD_60,a.VR_YTD_59,a.VR_YTD_58,a.VR_YTD_57,a.VR_YTD_56,a.VR_YTD_55,a.VR_YTD_54,a.VR_YTD_53,a.VR_YTD_52,a.VR_YTD_51,a.VR_YTD_50,a.VR_YTD_49,a.VR_YTD_48,a.VR_YTD_47,a.VR_YTD_46,
    a.VR_YTD_45,a.VR_YTD_44,a.VR_YTD_43,a.VR_YTD_42,a.VR_YTD_41,a.VR_YTD_40,a.VR_YTD_39,a.VR_YTD_38,a.VR_YTD_37,a.VR_YTD_36,a.VR_YTD_35,a.VR_YTD_34,a.VR_YTD_33,a.VR_YTD_32,a.VR_YTD_31,
    a.VR_YTD_30,a.VR_YTD_29,a.VR_YTD_28,a.VR_YTD_27,a.VR_YTD_26,a.VR_YTD_25,a.VR_YTD_24,a.VR_YTD_23,a.VR_YTD_22,a.VR_YTD_21,a.VR_YTD_20,a.VR_YTD_19,a.VR_YTD_18,a.VR_YTD_17,a.VR_YTD_16,
    a.VR_YTD_15,a.VR_YTD_14,a.VR_YTD_13,a.VR_YTD_12,a.VR_YTD_11,a.VR_YTD_10,a.VR_YTD_9,a.VR_YTD_8,a.VR_YTD_7,a.VR_YTD_6,a.VR_YTD_5,a.VR_YTD_4,a.VR_YTD_3,a.VR_YTD_2,a.VR_YTD_1,
    b.VU_YTD_60,b.VU_YTD_59,b.VU_YTD_58,b.VU_YTD_57,b.VU_YTD_56,b.VU_YTD_55,b.VU_YTD_54,b.VU_YTD_53,b.VU_YTD_52,b.VU_YTD_51,b.VU_YTD_50,b.VU_YTD_49,b.VU_YTD_48,b.VU_YTD_47,b.VU_YTD_46,
    b.VU_YTD_45,b.VU_YTD_44,b.VU_YTD_43,b.VU_YTD_42,b.VU_YTD_41,b.VU_YTD_40,b.VU_YTD_39,b.VU_YTD_38,b.VU_YTD_37,b.VU_YTD_36,b.VU_YTD_35,b.VU_YTD_34,b.VU_YTD_33,b.VU_YTD_32,b.VU_YTD_31,
    b.VU_YTD_30,b.VU_YTD_29,b.VU_YTD_28,b.VU_YTD_27,b.VU_YTD_26,b.VU_YTD_25,b.VU_YTD_24,b.VU_YTD_23,b.VU_YTD_22,b.VU_YTD_21,b.VU_YTD_20,b.VU_YTD_19,b.VU_YTD_18,b.VU_YTD_17,b.VU_YTD_16,
    b.VU_YTD_15,b.VU_YTD_14,b.VU_YTD_13,b.VU_YTD_12,b.VU_YTD_11,b.VU_YTD_10,b.VU_YTD_9,b.VU_YTD_8,b.VU_YTD_7,b.VU_YTD_6,b.VU_YTD_5,b.VU_YTD_4,b.VU_YTD_3,b.VU_YTD_2,b.VU_YTD_1,
    c.UT_YTD_60,c.UT_YTD_59,c.UT_YTD_58,c.UT_YTD_57,c.UT_YTD_56,c.UT_YTD_55,c.UT_YTD_54,c.UT_YTD_53,c.UT_YTD_52,c.UT_YTD_51,c.UT_YTD_50,c.UT_YTD_49,c.UT_YTD_48,c.UT_YTD_47,c.UT_YTD_46,
    c.UT_YTD_45,c.UT_YTD_44,c.UT_YTD_43,c.UT_YTD_42,c.UT_YTD_41,c.UT_YTD_40,c.UT_YTD_39,c.UT_YTD_38,c.UT_YTD_37,c.UT_YTD_36,c.UT_YTD_35,c.UT_YTD_34,c.UT_YTD_33,c.UT_YTD_32,c.UT_YTD_31,
    c.UT_YTD_30,c.UT_YTD_29,c.UT_YTD_28,c.UT_YTD_27,c.UT_YTD_26,c.UT_YTD_25,c.UT_YTD_24,c.UT_YTD_23,c.UT_YTD_22,c.UT_YTD_21,c.UT_YTD_20,c.UT_YTD_19,c.UT_YTD_18,c.UT_YTD_17,c.UT_YTD_16,
    c.UT_YTD_15,c.UT_YTD_14,c.UT_YTD_13,c.UT_YTD_12,c.UT_YTD_11,c.UT_YTD_10,c.UT_YTD_9,c.UT_YTD_8,c.UT_YTD_7,c.UT_YTD_6,c.UT_YTD_5,c.UT_YTD_4,c.UT_YTD_3,c.UT_YTD_2,c.UT_YTD_1
from tblOutput_MAX_ATC_RMB_YTD a
inner join tblOutput_MAX_ATC_USD_YTD b
    on a.atc1_code=b.atc1_code and  a.atc2_code=b.atc2_code and a.atc3_code=b.atc3_code and   a.atc4_code=b.atc4_code and a.geo=b.geo and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
        and case when a.corp_code is null then '' else a.corp_code end=case when b.corp_code is null then '' else b.corp_code end 
        and case when a.manuf_code is null then '' else a.manuf_code end =case when b.manuf_code is null then '' else b.manuf_code end
inner join tblOutput_MAX_ATC_UNT_YTD c
    on a.atc1_code=c.atc1_code and  a.atc2_code=c.atc2_code and a.atc3_code=c.atc3_code and   a.atc4_code=c.atc4_code and a.geo=c.geo and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
        and case when a.corp_code is null then '' else a.corp_code end=case when c.corp_code is null then '' else c.corp_code end 
        and case when a.manuf_code is null then '' else a.manuf_code end =case when c.manuf_code is null then '' else c.manuf_code end
GO

------------------------------
-- MAX 
------------------------------

print '--tblOutput_MAX_TA_Master'
if object_id(N'tblOutput_MAX_TA_Master',N'U') is not null
	drop table tblOutput_MAX_TA_Master
go
select * into tblOutput_MAX_TA_Master
from BMSCNProc2.dbo.tblOutput_MAX_TA_Master
go

if exists(select * from sysindexes where name='tblOutput_MAX_TA_Master')
drop index tblOutput_MAX_TA_Master on tblOutput_MAX_TA_Master
go
    CREATE CLUSTERED INDEX tblOutput_MAX_TA_Master ON [dbo].tblOutput_MAX_TA_Master 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]


print '--tblOutput_MAX_ATC_Master'
if object_id(N'tblOutput_MAX_ATC_Master',N'U') is not null
	drop table tblOutput_MAX_ATC_Master
go
select * into tblOutput_MAX_ATC_Master
from BMSCNProc2.dbo.tblOutput_MAX_ATC_Master
go

if exists(select * from sysindexes where name='tblOutput_MAX_ATC_Master')
drop index tblOutput_MAX_ATC_Master on tblOutput_MAX_ATC_Master
go
    CREATE CLUSTERED INDEX tblOutput_MAX_ATC_Master ON [dbo].tblOutput_MAX_ATC_Master 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]


print '--tblOutput_MAX_TA_Master_Inline'
if object_id(N'tblOutput_MAX_TA_Master_Inline',N'U') is not null
	drop table tblOutput_MAX_TA_Master_Inline
go
select * into tblOutput_MAX_TA_Master_Inline
from BMSCNProc2.dbo.tblOutput_MAX_TA_Master_Inline
go

if exists(select * from sysindexes where name='tblOutput_MAX_TA_Master_Inline')
drop index tblOutput_MAX_TA_Master_Inline on tblOutput_MAX_TA_Master_Inline
go
    CREATE CLUSTERED INDEX tblOutput_MAX_TA_Master_Inline ON [dbo].tblOutput_MAX_TA_Master_Inline 
    (
    [geo] ASC,
    [prod_lvl] ASC,
	[package_code] ASC
    )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]



exec BMSCNProc2.dbo.sp_Log_Event 'output','QT_MAX','99_Output_MAX.sql','End',null,null
