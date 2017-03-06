/*
outputgeo表一般不会变，只有客户需要变动的时候才手工处理一下。

*/
use BMSChinaCIA_IMS --db4
GO




--
--
--
----backup
--
--
--select * into BMSChinaMRBI_Repository.dbo.outputgeo_201303
--from outputgeo
--
----
--truncate table outputgeo
--go
---- 281条记录
--
--
--insert outputgeo(Geo,Geoname,lev,Product,parentGeo,Geoidx)
--select  distinct IMSCity as geo,IMSCity as GeoName,2 as lev,Product,Region as ParentGeo,1 from BMSChinaMRBI.dbo.tblSalesRegion
--where IMSCity is not null
--
--insert outputgeo(Geo,Geoname,lev,Product,parentGeo,Geoidx)
--select distinct Region,Region,1,Product,'China' ,1 from BMSChinaMRBI.dbo.tblSalesRegion
--where IMSCity is not null
--go
--insert outputgeo(Geo,Geoname,lev,Product,parentGeo,Geoidx)
--select Geo,Geoname,lev,'Onglyza',parentGeo,Geoidx from outputgeo where product='glucophage'
--go
--insert outputgeo(Geo,Geoname,lev)
--select 'China','China','0'
--go
----
--update outputgeo
--set geoname=B.geoname from outputgeo A inner join BMSChinaCIA_IMS_201109.dbo.outputgeo B
--on A.geo=B.geo
--go
--update outputgeo
--set geoname=B.Region_Name_CH from outputgeo A inner join dbo.Dim_Region B
--on A.geo=B.Region_Name
--
--update outputgeo
--set geoname=B.City_Name_CH from outputgeo A inner join dbo.Dim_City B
--on A.geo=B.City_Name
--go
--
--update OutputGeo set GeoName = b.GeoName from OutputGeo a inner join tblSpecialGeoName b
--on a.Product = b.Product and a.Geo = b.Geo
--go
--
--update outputgeo
--set Geo=upper(left(Geo,1))+lower(right(Geo,len(Geo)-1)) where lev=2 and geo not like '%Pearl%'
--go
----Alter table outputgeo
----add GeoIdx int
----go
--update outputgeo
--set GeoIdx=B.Rank from outputgeo A inner join (
--select A.*,dense_Rank ( )OVER (PARTITION BY ParentGeo order by lev,geo) as Rank from outputgeo A) B
--on A.id=B.id
--go
--update OutputGeo
--set ParentID=B.ID from Outputgeo A inner join (select * from outputgeo) B
--on A.ParentGeo=B.geo and A.Product=B.Product
--go
--update OutputGeo
--set ParentID=B.ID from Outputgeo A inner join (select * from outputgeo) B
--on A.ParentGeo=B.geo where A.ParentID is null
--go
--update OutputGeo
--set ProductID=B.ID from Outputgeo A inner join
--   (select * from db33.BMSChina_staging.dbo.WebPage 
--         where ParentID=(select ID from db33.BMSChina_staging.dbo.WebPage 
--                           where Code='DashBoard')) B
--on A.Product=B.Code 
--go





--2013/7/29 13:48:40

--drop table outputgeo
--select  * into outputgeo
--from dbo.outputgeo_bak_20130729
--
--insert into [outputgeo]
--SELECT [Geo]
--      ,[GeoName]
--      ,[Lev]
--      ,'Paraplatin'
--      ,[ParentGeo]
--      ,[GeoIdx]
--      ,[ParentID]
--      ,[ProductID]
--FROM [BMSChinaCIA_IMS].[dbo].[outputgeo]
--where Product = 'Taxol'
--
--2013/8/6 17:34:22
--update outputgeo set ProductID=18 
----  select  * from outputgeo
--where  product= 'Paraplatin'

--update dbo.outputgeo set ParentID=331 where product= 'Paraplatin' and ParentGeo='East-1'
--update dbo.outputgeo set ParentID=332 where product= 'Paraplatin' and ParentGeo='East-2'
--update dbo.outputgeo set ParentID=333 where product= 'Paraplatin' and ParentGeo='North'
--update dbo.outputgeo set ParentID=334 where product= 'Paraplatin' and ParentGeo='South'
--update dbo.outputgeo set ParentID=335 where product= 'Paraplatin' and ParentGeo='West'

--Add Eliquis's Geo Information

--insert into bmsChinaCIA_IMS.dbo.outputgeo (Geo,GeoName,Lev,Product,ParentGeo,GeoIdx,parentID,ProductID)
--select 
--Geo,GeoName,Lev,'Eliquis',ParentGeo,GeoIdx,parentID,19 as ProductID
--from bmsChinaCIA_IMS.dbo.outputgeo where product='Monopril'




--2013/8/12 10:20:50
--由于多次出现此表被改动导致web数据出不来等等
--于是将此表先设置为只读:

--CREATE TRIGGER trReadOnly_outputgeo ON outputgeo  
--    INSTEAD OF INSERT,   
--               UPDATE,  
--               DELETE  
--AS  
--BEGIN  
--    RAISERROR( 'outputgeo table is read only!', 16, 1 )  
--    ROLLBACK TRANSACTION  
--END  
--
--
----取消
--drop TRIGGER trReadOnly_outputgeo 


