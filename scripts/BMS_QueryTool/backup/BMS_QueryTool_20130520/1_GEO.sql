/*
 ÷π§Ω≈±æ
*/


use BMSCNProc2
go


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
from DB4.IMSDBPlus.dbo.Dim_City
GO


--backup
select * into BMSCNProc_bak.dbo.OutputGeo_Aric20130509
from OutputGeo 
GO

truncate table OutputGeo
insert into OutputGeo
select ID,Geo,GeoName,Lev,Product,ParentGeo,GeoIDx 
from DB4.IMSDBPlus.dbo.OutputGeo
GO




--  select * from tblCityIMS
--  select * from OutputGeo

