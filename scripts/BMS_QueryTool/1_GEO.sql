/*
手工脚本
*/


use BMSCNProc2
go




--backup
select * into BMSCNProc_bak.dbo.OutputGeo_20140523
from OutputGeo 
GO


truncate table OutputGeo
insert into OutputGeo
select ID,Geo,GeoName,Lev,Product,ParentGeo,GeoIDx 
from DB4.BMSChinaCIA_IMS.dbo.OutputGeo

update OutputGeo
set geoname=N'中国'
where geo='China'


GO

--  select * from OutputGeo











------------------------------------------------------------------------------------------------------
--   tblCityIMS ：
------------------------------------------------------------------------------------------------------

/*

一般不会更新，所以注释掉。

--backup
select * into BMSCNProc_bak.dbo.tblCityIMS_Aric20130509
from tblCityIMS 
GO

truncate table tblCityIMS
insert into tblCityIMS
select 
 City_ID
,City_Code+'_'
,City_Name
,City_Name_CH
,Tier
from DB4.BMSChinaCIA_IMS.dbo.Dim_City
GO


--2013/5/22 10:03:05
insert into BMSCNProc2.dbo.tblCityIMS values
('28','NCG_','Nanchang',N'南昌',2)
GO

--2013/5/23 10:52:23
update tblCityIMS set Geo_Lvl='1' where City_CN = N'中国'
update tblCityIMS set Geo_Lvl='2' where City_CN <> N'中国'

update tblCityIMS set City='CHINA' where City_CN = N'中国'
GO





*/