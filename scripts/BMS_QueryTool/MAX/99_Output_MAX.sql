use BMSChinaQueryToolNew
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
declare @sql varchar(max), @i int 

set @sql = '
CREATE VIEW tblOutput_MAX_TA_MTH_Inline
as
select ''MTH'' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.GeoLevName,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code, '

set @i = 60
while @i >=1 
BEGIN
    set @sql = @sql + '
        a.MTH_' + cast(@i as varchar(10)) + ' as VR_MTH_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        a.MTH_SHR_' + cast(@i as varchar(10)) + ' as VR_MTH_SHR_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        b.MTH_' + cast(@i as varchar(10)) + ' as VU_MTH_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        b.MTH_SHR_' + cast(@i as varchar(10)) + ' as VU_MTH_SHR_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        c.MTH_' + cast(@i as varchar(10)) + ' as UT_MTH_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        c.MTH_SHR_' + cast(@i as varchar(10)) + ' as UT_MTH_SHR_' + cast(@i as varchar(10)) + ', '
    set @i = @i - 1
END
set @sql = left(@sql, len(@sql) - 1) + '
from tblOutput_MAX_TA_RMB_MTH_Inline a
inner join tblOutput_MAX_TA_USD_MTH_Inline b
on a.mkt=b.mkt and a.geo=b.geo and a.class=b.class and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when b.corp_code is null then '''' else b.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when b.manuf_code is null then '''' else b.manuf_code end
    AND a.Geo_Lvl = b.Geo_Lvl
inner join tblOutput_MAX_TA_UNT_MTH_Inline c
on a.mkt=c.mkt and a.geo=c.geo and a.class=c.class and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when c.corp_code is null then '''' else c.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when c.manuf_code is null then '''' else c.manuf_code end
    AND a.Geo_Lvl = c.Geo_Lvl
'
print @sql 
exec(@sql) 
GO





IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_TA_MTH_Global')
    DROP VIEW tblOutput_MAX_TA_MTH_Global
go

declare @sql varchar(max), @i int 

set @sql = '
CREATE VIEW tblOutput_MAX_TA_MTH_Global
as
select ''MTH'' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.GeoLevName,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code, '

set @i = 60
while @i >=1 
BEGIN
    set @sql = @sql + '
        a.MTH_' + cast(@i as varchar(10)) + ' as VR_MTH_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        b.MTH_' + cast(@i as varchar(10)) + ' as VU_MTH_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        c.MTH_' + cast(@i as varchar(10)) + ' as UT_MTH_' + cast(@i as varchar(10)) + ', '
    set @i = @i - 1
END
set @sql = left(@sql, len(@sql) - 1) + '
from tblOutput_MAX_TA_RMB_MTH_Global a
inner join tblOutput_MAX_TA_USD_MTH_Global b
on a.mkt=b.mkt and a.geo=b.geo and a.class=b.class and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when b.corp_code is null then '''' else b.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when b.manuf_code is null then '''' else b.manuf_code end
    AND a.Geo_Lvl = b.Geo_Lvl
inner join tblOutput_MAX_TA_UNT_MTH_Global c
on a.mkt=c.mkt and a.geo=c.geo and a.class=c.class and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when c.corp_code is null then '''' else c.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when c.manuf_code is null then '''' else c.manuf_code end
    AND a.Geo_Lvl = c.Geo_Lvl
'
print @sql 
exec(@sql) 
go 

--MQT:

IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_TA_MQT_Inline')
DROP VIEW tblOutput_MAX_TA_MQT_Inline
go

declare @sql varchar(max), @i int 

set @sql = '
CREATE VIEW tblOutput_MAX_TA_MQT_Inline
as
select ''MQT'' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.GeoLevName,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code, '

set @i = 60
while @i >=1 
BEGIN
    set @sql = @sql + '
        a.MTH_' + cast(@i as varchar(10)) + ' as VR_MQT_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        a.MTH_SHR_' + cast(@i as varchar(10)) + ' as VR_MQT_SHR_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        b.MTH_' + cast(@i as varchar(10)) + ' as VU_MQT_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        b.MTH_SHR_' + cast(@i as varchar(10)) + ' as VU_MQT_SHR_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        c.MTH_' + cast(@i as varchar(10)) + ' as UT_MQT_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        c.MTH_SHR_' + cast(@i as varchar(10)) + ' as UT_MQT_SHR_' + cast(@i as varchar(10)) + ', '
    set @i = @i - 1
END
set @sql = left(@sql, len(@sql) - 1) + '
from tblOutput_MAX_TA_RMB_MQT_Inline a
inner join tblOutput_MAX_TA_USD_MQT_Inline b
on a.mkt=b.mkt and a.geo=b.geo and a.class=b.class and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when b.corp_code is null then '''' else b.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when b.manuf_code is null then '''' else b.manuf_code end
    AND a.Geo_Lvl = b.Geo_Lvl
inner join tblOutput_MAX_TA_UNT_MQT_Inline c
on a.mkt=c.mkt and a.geo=c.geo and a.class=c.class and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when c.corp_code is null then '''' else c.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when c.manuf_code is null then '''' else c.manuf_code end
    AND a.Geo_Lvl = c.Geo_Lvl
'
print @sql 
exec(@sql) 
go 



IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_TA_MQT_Global')
    DROP VIEW tblOutput_MAX_TA_MQT_Global
go

declare @sql varchar(max), @i int 

set @sql = '
CREATE VIEW tblOutput_MAX_TA_MQT_Global
as
select ''MQT'' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.GeoLevName,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code, '

set @i = 60
while @i >=1 
BEGIN
    set @sql = @sql + '
        a.MTH_' + cast(@i as varchar(10)) + ' as VR_MQT_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        b.MTH_' + cast(@i as varchar(10)) + ' as VU_MQT_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        c.MTH_' + cast(@i as varchar(10)) + ' as UT_MQT_' + cast(@i as varchar(10)) + ', '
    set @i = @i - 1
END
set @sql = left(@sql, len(@sql) - 1) + '
from tblOutput_MAX_TA_RMB_MQT_Global a
inner join tblOutput_MAX_TA_USD_MQT_Global b
on a.mkt=b.mkt and a.geo=b.geo and a.class=b.class and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when b.corp_code is null then '''' else b.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when b.manuf_code is null then '''' else b.manuf_code end
    AND a.Geo_Lvl = b.Geo_Lvl
inner join tblOutput_MAX_TA_UNT_MQT_Global c
on a.mkt=c.mkt and a.geo=c.geo and a.class=c.class and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when c.corp_code is null then '''' else c.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when c.manuf_code is null then '''' else c.manuf_code end
    AND a.Geo_Lvl = c.Geo_Lvl
'
print @sql 
exec(@sql) 
go 


--MAT

IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_TA_MAT_Inline')
    DROP VIEW tblOutput_MAX_TA_MAT_Inline
go

declare @sql varchar(max), @i int 

set @sql = '
CREATE VIEW tblOutput_MAX_TA_MAT_Inline
as
select ''MAT'' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.GeoLevName,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code, '

set @i = 60
while @i >=1 
BEGIN
    set @sql = @sql + '
        a.MTH_' + cast(@i as varchar(10)) + ' as VR_MAT_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        a.MTH_SHR_' + cast(@i as varchar(10)) + ' as VR_MAT_SHR_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        b.MTH_' + cast(@i as varchar(10)) + ' as VU_MAT_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        b.MTH_SHR_' + cast(@i as varchar(10)) + ' as VU_MAT_SHR_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        c.MTH_' + cast(@i as varchar(10)) + ' as UT_MAT_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        c.MTH_SHR_' + cast(@i as varchar(10)) + ' as UT_MAT_SHR_' + cast(@i as varchar(10)) + ', '
    set @i = @i - 1
END
set @sql = left(@sql, len(@sql) - 1) + '
from tblOutput_MAX_TA_RMB_MAT_Inline a
inner join tblOutput_MAX_TA_USD_MAT_Inline b
on a.mkt=b.mkt and a.geo=b.geo and a.class=b.class and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when b.corp_code is null then '''' else b.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when b.manuf_code is null then '''' else b.manuf_code end
    AND a.Geo_Lvl = b.Geo_Lvl
inner join tblOutput_MAX_TA_UNT_MAT_Inline c
on a.mkt=c.mkt and a.geo=c.geo and a.class=c.class and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when c.corp_code is null then '''' else c.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when c.manuf_code is null then '''' else c.manuf_code end
    AND a.Geo_Lvl = c.Geo_Lvl
'
print @sql 
exec(@sql) 
go 



IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_TA_MAT_Global')
    DROP VIEW tblOutput_MAX_TA_MAT_Global
go

declare @sql varchar(max), @i int 

set @sql = '
CREATE VIEW tblOutput_MAX_TA_MAT_Global
as
select ''MAT'' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.GeoLevName,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code, '

set @i = 60
while @i >=1 
BEGIN
    set @sql = @sql + '
        a.MTH_' + cast(@i as varchar(10)) + ' as VR_MAT_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        b.MTH_' + cast(@i as varchar(10)) + ' as VU_MAT_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        c.MTH_' + cast(@i as varchar(10)) + ' as UT_MAT_' + cast(@i as varchar(10)) + ', '
    set @i = @i - 1
END
set @sql = left(@sql, len(@sql) - 1) + '
from tblOutput_MAX_TA_RMB_MAT_Global a
inner join tblOutput_MAX_TA_USD_MAT_Global b
on a.mkt=b.mkt and a.geo=b.geo and a.class=b.class and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when b.corp_code is null then '''' else b.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when b.manuf_code is null then '''' else b.manuf_code end
    AND a.Geo_Lvl = b.Geo_Lvl
inner join tblOutput_MAX_TA_UNT_MAT_Global c
on a.mkt=c.mkt and a.geo=c.geo and a.class=c.class and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when c.corp_code is null then '''' else c.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when c.manuf_code is null then '''' else c.manuf_code end
    AND a.Geo_Lvl = c.Geo_Lvl
'
print @sql 
exec(@sql) 
go 

--YTD:


IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_TA_YTD_Inline')
    DROP VIEW tblOutput_MAX_TA_YTD_Inline
go

declare @sql varchar(max), @i int 

set @sql = '
CREATE VIEW tblOutput_MAX_TA_YTD_Inline
as
select ''YTD'' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.GeoLevName,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code, '

set @i = 60
while @i >=1 
BEGIN
    set @sql = @sql + '
        a.MTH_' + cast(@i as varchar(10)) + ' as VR_YTD_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        a.MTH_SHR_' + cast(@i as varchar(10)) + ' as VR_YTD_SHR_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        b.MTH_' + cast(@i as varchar(10)) + ' as VU_YTD_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        b.MTH_SHR_' + cast(@i as varchar(10)) + ' as VU_YTD_SHR_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        c.MTH_' + cast(@i as varchar(10)) + ' as UT_YTD_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        c.MTH_SHR_' + cast(@i as varchar(10)) + ' as UT_YTD_SHR_' + cast(@i as varchar(10)) + ', '
    set @i = @i - 1
END
set @sql = left(@sql, len(@sql) - 1) + '
from tblOutput_MAX_TA_RMB_YTD_Inline a
inner join tblOutput_MAX_TA_USD_YTD_Inline b
on a.mkt=b.mkt and a.geo=b.geo and a.class=b.class and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when b.corp_code is null then '''' else b.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when b.manuf_code is null then '''' else b.manuf_code end
    AND a.Geo_Lvl = b.Geo_Lvl
inner join tblOutput_MAX_TA_UNT_YTD_Inline c
on a.mkt=c.mkt and a.geo=c.geo and a.class=c.class and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when c.corp_code is null then '''' else c.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when c.manuf_code is null then '''' else c.manuf_code end
    AND a.Geo_Lvl = c.Geo_Lvl
'
print @sql 
exec(@sql) 
go 




IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_TA_YTD_Global')
    DROP VIEW tblOutput_MAX_TA_YTD_Global
go

declare @sql varchar(max), @i int 

set @sql = '
CREATE VIEW tblOutput_MAX_TA_YTD_Global
as
select ''YTD'' as datatype,a.mkttype,a.mkt,a.market_name,a.geo,a.geo_lvl,a.GeoLevName,a.class,a.class_name,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code, '

set @i = 60
while @i >=1 
BEGIN
    set @sql = @sql + '
        a.MTH_' + cast(@i as varchar(10)) + ' as VR_YTD_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        b.MTH_' + cast(@i as varchar(10)) + ' as VU_YTD_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        c.MTH_' + cast(@i as varchar(10)) + ' as UT_YTD_' + cast(@i as varchar(10)) + ', '
    set @i = @i - 1
END
set @sql = left(@sql, len(@sql) - 1) + '
from tblOutput_MAX_TA_RMB_YTD_Global a
inner join tblOutput_MAX_TA_USD_YTD_Global b
on a.mkt=b.mkt and a.geo=b.geo and a.class=b.class and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when b.corp_code is null then '''' else b.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when b.manuf_code is null then '''' else b.manuf_code end
    AND a.Geo_Lvl = b.Geo_Lvl
inner join tblOutput_MAX_TA_UNT_YTD_Global c
on a.mkt=c.mkt and a.geo=c.geo and a.class=c.class and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when c.corp_code is null then '''' else c.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when c.manuf_code is null then '''' else c.manuf_code end
    AND a.Geo_Lvl = c.Geo_Lvl
'
print @sql 
exec(@sql) 
go 

--ATC:

--MTH:

IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_ATC_MTH')
    DROP VIEW tblOutput_MAX_ATC_MTH
go

declare @sql varchar(max), @i int 

set @sql = '
CREATE VIEW tblOutput_MAX_ATC_MTH
as
select ''MTH'' as datatype,a.atc1_code,a.atc1_des,a.atc2_code,a.atc2_des,a.atc3_code,a.atc3_des,a.atc4_code,a.atc4_des,a.geo,a.geo_lvl,a.GeoLevName,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code, '

set @i = 60
while @i >=1 
BEGIN
    set @sql = @sql + '
        a.MTH_' + cast(@i as varchar(10)) + ' as VR_MTH_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        b.MTH_' + cast(@i as varchar(10)) + ' as VU_MTH_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        c.MTH_' + cast(@i as varchar(10)) + ' as UT_MTH_' + cast(@i as varchar(10)) + ', '
    set @i = @i - 1
END
set @sql = left(@sql, len(@sql) - 1) + '
from tblOutput_MAX_ATC_RMB_MTH a
inner join tblOutput_MAX_ATC_USD_MTH b
on a.atc1_code=b.atc1_code and  a.atc2_code=b.atc2_code and a.atc3_code=b.atc3_code and   a.atc4_code=b.atc4_code and a.geo=b.geo and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when b.corp_code is null then '''' else b.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when b.manuf_code is null then '''' else b.manuf_code end
    AND a.Geo_Lvl = b.Geo_Lvl
inner join tblOutput_MAX_ATC_UNT_MTH c
on a.atc1_code=c.atc1_code and  a.atc2_code=c.atc2_code and a.atc3_code=c.atc3_code and   a.atc4_code=c.atc4_code and a.geo=c.geo and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when c.corp_code is null then '''' else c.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when c.manuf_code is null then '''' else c.manuf_code end
    AND a.Geo_Lvl = c.Geo_Lvl
'
print @sql 
exec(@sql) 
go 

--MQT:

IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_ATC_MQT')
    DROP VIEW tblOutput_MAX_ATC_MQT
go

declare @sql varchar(max), @i int 

set @sql = '
CREATE VIEW tblOutput_MAX_ATC_MQT
as
select ''MQT'' as datatype,a.atc1_code,a.atc1_des,a.atc2_code,a.atc2_des,a.atc3_code,a.atc3_des,a.atc4_code,a.atc4_des,a.geo,a.geo_lvl,a.GeoLevName,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code, '

set @i = 60
while @i >=1 
BEGIN
    set @sql = @sql + '
        a.MTH_' + cast(@i as varchar(10)) + ' as VR_MQT_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        b.MTH_' + cast(@i as varchar(10)) + ' as VU_MQT_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        c.MTH_' + cast(@i as varchar(10)) + ' as UT_MQT_' + cast(@i as varchar(10)) + ', '
    set @i = @i - 1
END
set @sql = left(@sql, len(@sql) - 1) + '
from tblOutput_MAX_ATC_RMB_MQT a
inner join tblOutput_MAX_ATC_USD_MQT b
on a.atc1_code=b.atc1_code and  a.atc2_code=b.atc2_code and a.atc3_code=b.atc3_code and   a.atc4_code=b.atc4_code and a.geo=b.geo and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when b.corp_code is null then '''' else b.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when b.manuf_code is null then '''' else b.manuf_code end
    AND a.Geo_Lvl = b.Geo_Lvl
inner join tblOutput_MAX_ATC_UNT_MQT c
on a.atc1_code=c.atc1_code and  a.atc2_code=c.atc2_code and a.atc3_code=c.atc3_code and   a.atc4_code=c.atc4_code and a.geo=c.geo and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
    and case when a.corp_code is null then '''' else a.corp_code end=case when c.corp_code is null then '''' else c.corp_code end 
    and case when a.manuf_code is null then '''' else a.manuf_code end =case when c.manuf_code is null then '''' else c.manuf_code end
    AND a.Geo_Lvl = c.Geo_Lvl
'
print @sql 
exec(@sql) 
go 

--MAT:
IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_ATC_MAT')
    DROP VIEW tblOutput_MAX_ATC_MAT
go

declare @sql varchar(max), @i int 

set @sql = '
CREATE VIEW tblOutput_MAX_ATC_MAT
as
select ''MAT'' as datatype,a.atc1_code,a.atc1_des,a.atc2_code,a.atc2_des,a.atc3_code,a.atc3_des,a.atc4_code,a.atc4_des,a.geo,a.geo_lvl,a.GeoLevName,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code, '

set @i = 60
while @i >=1 
BEGIN
    set @sql = @sql + '
        a.MTH_' + cast(@i as varchar(10)) + ' as VR_MAT_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        b.MTH_' + cast(@i as varchar(10)) + ' as VU_MAT_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        c.MTH_' + cast(@i as varchar(10)) + ' as UT_MAT_' + cast(@i as varchar(10)) + ', '
    set @i = @i - 1
END
set @sql = left(@sql, len(@sql) - 1) + '
from tblOutput_MAX_ATC_RMB_MAT a
inner join tblOutput_MAX_ATC_USD_MAT b
    on a.atc1_code=b.atc1_code and  a.atc2_code=b.atc2_code and a.atc3_code=b.atc3_code and   a.atc4_code=b.atc4_code and a.geo=b.geo and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
        and case when a.corp_code is null then '''' else a.corp_code end=case when b.corp_code is null then '''' else b.corp_code end 
        and case when a.manuf_code is null then '''' else a.manuf_code end =case when b.manuf_code is null then '''' else b.manuf_code end
        AND a.Geo_Lvl = b.Geo_Lvl
inner join tblOutput_MAX_ATC_UNT_MAT c
    on a.atc1_code=c.atc1_code and  a.atc2_code=c.atc2_code and a.atc3_code=c.atc3_code and   a.atc4_code=c.atc4_code and a.geo=c.geo and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
        and case when a.corp_code is null then '''' else a.corp_code end=case when c.corp_code is null then '''' else c.corp_code end 
        and case when a.manuf_code is null then '''' else a.manuf_code end =case when c.manuf_code is null then '''' else c.manuf_code end
        AND a.Geo_Lvl = c.Geo_Lvl
'
print @sql 
exec(@sql) 
go 

--YTD:
IF EXISTS(SELECT 1 FROM sys.views WHERE name='tblOutput_MAX_ATC_YTD')
    DROP VIEW tblOutput_MAX_ATC_YTD
go

declare @sql varchar(max), @i int 

set @sql = '
CREATE VIEW tblOutput_MAX_ATC_YTD
as
select ''YTD'' as datatype,a.atc1_code,a.atc1_des,a.atc2_code,a.atc2_des,a.atc3_code,a.atc3_des,a.atc4_code,a.atc4_des,a.geo,a.geo_lvl,a.GeoLevName,a.prod_lvl,a.uniq_prod,a.product_name,a.product_code,a.cmps_name,a.cmps_code,a.package_name,a.package_code,
    a.corp_name,a.corp_code,a.manuf_name,a.manuf_code,a.mnc,a.generic_code, '

set @i = 60
while @i >=1 
BEGIN
    set @sql = @sql + '
        a.MTH_' + cast(@i as varchar(10)) + ' as VR_YTD_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        b.MTH_' + cast(@i as varchar(10)) + ' as VU_YTD_' + cast(@i as varchar(10)) + ', '
    set @sql = @sql + '
        c.MTH_' + cast(@i as varchar(10)) + ' as UT_YTD_' + cast(@i as varchar(10)) + ', '
    set @i = @i - 1
END
set @sql = left(@sql, len(@sql) - 1) + '
from tblOutput_MAX_ATC_RMB_YTD a
inner join tblOutput_MAX_ATC_USD_YTD b
    on a.atc1_code=b.atc1_code and  a.atc2_code=b.atc2_code and a.atc3_code=b.atc3_code and   a.atc4_code=b.atc4_code and a.geo=b.geo and a.prod_lvl=b.prod_lvl and a.product_code=b.product_code and a.CMPS_code=b.CMPS_code and a.package_code=b.package_code 
        and case when a.corp_code is null then '''' else a.corp_code end=case when b.corp_code is null then '''' else b.corp_code end 
        and case when a.manuf_code is null then '''' else a.manuf_code end =case when b.manuf_code is null then '''' else b.manuf_code end
        AND a.Geo_Lvl = b.Geo_Lvl
inner join tblOutput_MAX_ATC_UNT_YTD c
    on a.atc1_code=c.atc1_code and  a.atc2_code=c.atc2_code and a.atc3_code=c.atc3_code and   a.atc4_code=c.atc4_code and a.geo=c.geo and a.prod_lvl=c.prod_lvl and a.product_code=c.product_code and a.CMPS_code=c.CMPS_code and a.package_code=c.package_code 
        and case when a.corp_code is null then '''' else a.corp_code end=case when c.corp_code is null then '''' else c.corp_code end 
        and case when a.manuf_code is null then '''' else a.manuf_code end =case when c.manuf_code is null then '''' else c.manuf_code end
        AND a.Geo_Lvl = c.Geo_Lvl
'
print @sql 
exec(@sql) 
go 

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
