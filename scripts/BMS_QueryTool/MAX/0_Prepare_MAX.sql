


--IMS Data 每月更新一次 保存处理最近60个月，5年的数据

-- 前置依赖：
-- TempOutput.dbo.MTHCHPA_PKML
-- TempOutput.dbo.MTHCITY_PKML

-- TempOutput.dbo.MTHCHPA_CMPS
-- TempOutput.dbo.MTHCITY_CMPS

-- Db4.BMSChinaCIA_IMS_test.dbo.MTHCHPA_PKAU
-- Db4.BMSChinaCIA_IMS_test.dbo.MTHCITY_PKAU

-- Db4.BMSChinaCIA_IMS_test.dbo.tblMktDef_ATCDriver
-- Db4.BMSChinaCIA_IMS_test.dbo.tblMktDef_GlobalTA


use BMSCNProc2
go
--


PRINT '(--------------------------------
              (4).importing   MAX
----------------------------------------)'

if object_id(N'MTHCITY_MAX',N'U') is not null
	drop table MTHCITY_MAX
go

select * into MTHCITY_MAX
from Db4.BMSChinaCIA_IMS_test.dbo.inMAXData
go
alter table MTHCITY_MAX 
add Audi_Cod varchar(20) 
go
update MTHCITY_MAX
set Audi_Cod = b.City
from MTHCITY_MAX as a 
inner join tblcitymax as b on replace(a.city, N'市', '') = b.city_CN
go
create nonclustered index idx on MTHCITY_MAX(Pack_cod)
go

--Update city table
insert into tblcitymax (City_ID,Audi_Cod,CIty,City_CN,Geo_Lvl)
select city_ID,city_code+'_',city_name,city_name_ch,2 
from db4.BMSChinaCIA_IMS_test.dbo.dim_city a
where not exists(select * from tblcitymax b where a.city_name=b.city or a.city_name_ch=b.city_cn)



exec dbo.sp_Log_Event 'Prepare','QT_MAX','0_Prepare_MAX.sql','End',null,null
