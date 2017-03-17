
SELECT * FROM outputgeo
SELECT * into outputgeo_1 FROM outputgeo
go 

alter table dbo.outputgeo_1
alter column GeoName varchar(50)

alter table dbo.outputgeo_1
alter column ParentGeo nvarchar(50)


select d.Geo, c.City, d.Lev, d.Product, d.ParentGeo, c.Region, c.Province
from (
	SELECT distinct Region, b.Province, replace(a.City, N'市', '') as City
	from dbo.MAXRegionCity as a 
	inner join dbo.maxcity as b on a.City = b.City
	where a.type = 'Dashboard'
	union 
	SELECT distinct Region, b.Province, replace(a.City, N'市', '')
	from dbo.MAXRegionCity as a 
	inner join dbo.maxcity as b on a.City = b.City
	where a.type = 'Brand Report'
) as c 
inner join dbo.outputgeo as d on c.City = d.GeoName

SELECT * FROM outputgeo_1 where lev = 2
SELECT * FROM outputgeo where Lev = 1

SELECT * FROM outputgeo_1 

 truncate table outputgeo_1
 insert into dbo.outputgeo_1 ( Geo, GeoName, Lev, Product, ParentGeo, GeoIdx, ParentID, ProductID )
 select 'China', 'China', 0, null, null, 1, null, null 

 insert into dbo.outputgeo_1 ( Geo, GeoName, Lev, Product, ParentGeo, GeoIdx, ParentID, ProductID )
 select a.Region, a.GeoName, 1, b.Product, '', 0, 0, b.ProdID
 from (
 	SELECT distinct  p.Region, q.GeoName
 	from (
 		SELECT distinct Region, b.Province as Province , replace(a.City, N'市', '') as City
 		from dbo.MAXRegionCity as a 
 		inner join dbo.maxcity as b on a.City = b.City
 		where a.type = 'Dashboard'
 		union 
 		SELECT distinct Region, b.Province, replace(a.City, N'市', '')
 		from dbo.MAXRegionCity as a 
 		inner join dbo.maxcity as b on a.City = b.City
 		where a.type = 'Brand Report'
 	) as p 
 	left join dbo.outputgeo as q on p.Region = q.Geo
 ) as a 
 ,(
 	select 'Baraclude' as Product, 1 as ProdID 
 	--union all 
 	--select 'Monopril' as Product, 2 as ProdID union all 
 	--select 'Taxol' as Product, 3 as ProdID union all 
 	--select 'Sprycel' as Product, 4 as ProdID 
 ) as b

 update a set geoname = N'东一区' from dbo.outputgeo_1 as a where geo = 'East I'
 update a set geoname = N'东二区' from dbo.outputgeo_1 as a where geo = 'East II'

 --insert into dbo.outputgeo_1 ( Geo, GeoName, Lev, Product, ParentGeo, GeoIdx, ParentID, ProductID )
 --select a.Geo, a.Province, 2, b.Product, '', 0, 0, b.ProdID
 --from (
 --	SELECT distinct  province , q.Geo
 --	from (
 --		SELECT distinct Region, b.Province as Province , replace(a.City, N'市', '') as City
 --		from dbo.MAXRegionCity as a 
 --		inner join dbo.maxcity as b on a.City = b.City
 --		where a.type = 'Dashboard'
 --		union 
 --		SELECT distinct Region, b.Province, replace(a.City, N'市', '')
 --		from dbo.MAXRegionCity as a 
 --		inner join dbo.maxcity as b on a.City = b.City
 --		where a.type = 'Brand Report'
 --	) as p 
 --	left join dbo.outputgeo as q on p.Province = q.GeoName
 --) as a 
 --,(
 --	select 'Baraclude' as Product, 1 as ProdID 
 --	--union all 
 --	--select 'Monopril' as Product, 2 as ProdID union all 
 --	--select 'Taxol' as Product, 3 as ProdID union all 
 --	--select 'Sprycel' as Product, 4 as ProdID 
 --) as b

 --update a set a.geo = 'Yunnan' from outputgeo_1 as a where lev = 2 and a.GeoName = N'云南'
 --update a set a.geo = 'Neimenggu' from outputgeo_1 as a where lev = 2 and a.GeoName = N'内蒙古'
 --update a set a.geo = 'Jilin' from outputgeo_1 as a where lev = 2 and a.GeoName = N'吉林'
 --update a set a.geo = 'Sichuan' from outputgeo_1 as a where lev = 2 and a.GeoName = N'四川'
 --update a set a.geo = 'Shandong' from outputgeo_1 as a where lev = 2 and a.GeoName = N'山东'
 --update a set a.geo = 'Shanxi' from outputgeo_1 as a where lev = 2 and a.GeoName = N'山西'
 --update a set a.geo = 'Guangdong' from outputgeo_1 as a where lev = 2 and a.GeoName = N'广东'
 --update a set a.geo = 'Xinjiang' from outputgeo_1 as a where lev = 2 and a.GeoName = N'新疆'
 --update a set a.geo = 'Hebei' from outputgeo_1 as a where lev = 2 and a.GeoName = N'河北'
 --update a set a.geo = 'Henan' from outputgeo_1 as a where lev = 2 and a.GeoName = N'河南'
 --update a set a.geo = 'Hubei' from outputgeo_1 as a where lev = 2 and a.GeoName = N'湖北'
 --update a set a.geo = 'Fujian' from outputgeo_1 as a where lev = 2 and a.GeoName = N'福建'
 --update a set a.geo = 'Liaoning' from outputgeo_1 as a where lev = 2 and a.GeoName = N'辽宁'
 --update a set a.geo = 'Shaanxi' from outputgeo_1 as a where lev = 2 and a.GeoName = N'陕西'
 --update a set a.geo = 'Heilongjiang' from outputgeo_1 as a where lev = 2 and a.GeoName = N'黑龙江'



 insert into dbo.outputgeo_1 ( Geo, GeoName, Lev, Product, ParentGeo, GeoIdx, ParentID, ProductID )
 select a.Geo, a.City, 2, b.Product, '', 0, 0, b.ProdID
 from (
 	SELECT distinct  p.City , q.Geo
 	from (
 		SELECT distinct Region, b.Province as Province , replace(a.City, N'市', '') as City
 		from dbo.MAXRegionCity as a 
 		inner join dbo.maxcity as b on a.City = b.City
 		where a.type = 'Dashboard'
 		union 
 		SELECT distinct Region, b.Province, replace(a.City, N'市', '')
 		from dbo.MAXRegionCity as a 
 		inner join dbo.maxcity as b on a.City = b.City
 		where a.type = 'Brand Report'
 	) as p 
 	left join dbo.outputgeo as q on p.City = q.GeoName
 ) as a 
 ,(
 	select 'Baraclude' as Product, 1 as ProdID 
 	--union all 
 	--select 'Monopril' as Product, 2 as ProdID union all 
 	--select 'Taxol' as Product, 3 as ProdID union all 
 	--select 'Sprycel' as Product, 4 as ProdID 
 ) as b

 update a set a.geo = 'Dongguan' from outputgeo_1 as a where lev = 2 and a.GeoName = N'东莞'
 update a set a.geo = 'Dongying' from outputgeo_1 as a where lev = 2 and a.GeoName = N'东营'
 update a set a.geo = 'Fuzhou' from outputgeo_1 as a where lev = 2 and a.GeoName = N'福州'
 update a set a.geo = 'Zhongshan' from outputgeo_1 as a where lev = 2 and a.GeoName = N'中山'
 update a set a.geo = 'Foshan' from outputgeo_1 as a where lev = 2 and a.GeoName = N'佛山'
 update a set a.geo = 'Karamay' from outputgeo_1 as a where lev = 2 and a.GeoName = N'克拉玛依'
 update a set a.geo = 'Xiamen' from outputgeo_1 as a where lev = 2 and a.GeoName = N'厦门'
 update a set a.geo = 'Hohehot' from outputgeo_1 as a where lev = 2 and a.GeoName = N'呼和浩特'
 update a set a.geo = 'Langfang' from outputgeo_1 as a where lev = 2 and a.GeoName = N'廊坊'
 update a set a.geo = 'Zhuhai' from outputgeo_1 as a where lev = 2 and a.GeoName = N'珠海'

 select * FROM outputgeo_1 where lev = 2
 --select * FROM outputgeo where lev = 3 and geo is null 
 --SELECT * FROM MAXRegionCity
 update a 
 set parentGeo = 'China' , parentID = 1
 from dbo.outputgeo_1 as a where lev = 1

 update a 
 set parentGeo = b.Region 
 	--select b.Region, *
 from dbo.outputgeo_1 as a 
 inner join (
 	select distinct Region, b.Province as Province 
 		, replace(a.City, N'市', '') as City
 	from dbo.MAXRegionCity as a 
 	inner join dbo.maxcity as b on a.City = b.City
 	where a.type = 'Dashboard'
 ) as b on a.geoname = b.City
 inner join dbo.outputgeo_1 as c on b.Region = c.Geo and a.Product = c.Product
 where a.lev = 2

 update a 
 set a.ParentID = b.Id 
  --select b.Id, a.*
 from dbo.outputgeo_1 as a 
 inner join dbo.outputgeo_1 as b on a.ParentGeo = b.Geo and a.Product = b.Product
 where a.Lev = 2

 SELECT * FROM outputgeo_1
 --update a 
 --set parentGeo = c.Geo 
 --	 --select b.Province, *
 --from dbo.outputgeo_1 as a 
 --inner join (
 --	select distinct Region,  b.Province as Province 
 --		, replace(a.City, N'市', '') as City
 --	from dbo.MAXRegionCity as a 
 --	inner join dbo.maxcity as b on a.City = b.City
 --	where a.type = 'Dashboard'
 --) as b on a.geoname = b.City
 --inner join dbo.outputgeo_1 as c on b.Province = c.GeoName and a.Product = c.Product
 --where a.lev = 3 and c.lev = 2

 --update a 
 --set a.ParentID = b.Id 
 -- --select b.Id, a.*
 --from dbo.outputgeo_1 as a 
 --inner join dbo.outputgeo_1 as b 
 --on a.ParentGeo = b.Geo and a.Product = b.Product
 --where a.Lev = 3 and b.Lev = 2

 update a 
 set GeoIdx = b.idx 
 from dbo.outputgeo_1 as a 
 inner join (
 	SELECT distinct geo, dense_rank() over( order by geo ) as idx
 	from dbo.outputgeo_1
 	where Lev = 1
 ) as b on a.Geo = b.geo 
 where Lev = 1


 update a 
 set GeoIdx = b.idx 
 from dbo.outputgeo_1 as a 
 inner join (
 	SELECT distinct geo, dense_rank() over( order by geo ) as idx
 	from dbo.outputgeo_1
 	where Lev = 2
 ) as b on a.Geo = b.geo 
 where Lev = 2


 --update a 
 --set GeoIdx = b.idx 
 --from dbo.outputgeo_1 as a 
 --inner join (
 --	SELECT distinct geo, dense_rank() over( order by geo ) as idx
 --	from dbo.outputgeo_1
 --	where Lev = 3
 --) as b on a.Geo = b.geo 
 --where Lev = 3


go 

drop table outputgeo 

select * into outputgeo  from dbo.outputgeo_1

SELECT * FROM dbo.outputgeo


----SELECT * into webOutputgeo_20170314 FROM dbo.webOutputgeo
--truncate table dbo.WebOutputGeo
--go 

--insert into dbo.weboutputgeo
--      (ID,geo,geoname,lev,idx,Parentid,ParentGeo,linkproductid,Product)
--select id,geo,geoname,lev,geoIDx,Parentid,ParentGeo,productid ,Product
--from  db4.BMSChinaCIA_IMS_test.dbo.outputgeo

SELECT * 
from WebPrivilege as a 
inner join dbo.WebPage as b on a.LinkPageId = b.ID and b.Lev = 2 
order by a.LinkPageId asc 

--SELECT * into WebUserPermit_20170314 from WebUserPermit 
SELECT * from WebUserPermit 
SELECT * FROM dbo.WebPage
select * from dbo.WebPage where Lev = 2 
SELECT * from WebPrivilege where LinkPageId = 12

SELECT * FROM dbo.webOutputgeo

SELECT * into WebPrivilege_20170314 from dbo.WebPrivilege

--truncate table dbo.WebPrivilege 

--insert into dbo.WebPrivilege ( LinkPageId, LinkGeoId, LinkChartCode, Permit )
--select LinkPageId, LinkGeoId, LinkChartCode, Permit from WebPrivilege_20170314 where LinkGeoId is null 
--go 

--insert into dbo.WebPrivilege ( LinkPageId, LinkGeoId, LinkChartCode, Permit )
--SELECT LinkPageId, LinkGeoId, LinkChartCode, Permit FROM WebPrivilege_20170314 where LinkPageId = 11
--go 


--insert into dbo.WebPrivilege ( LinkPageId, LinkGeoId, LinkChartCode, Permit )
--SELECT 12, a.Id, null, null 
--from dbo.WebOutputGeo as a 
--go 

--insert into dbo.WebPrivilege ( LinkPageId, LinkGeoId, LinkChartCode, Permit )
--SELECT a.ID, 1, null, null 
--from dbo.WebPage as a
--where Lev = 2 and a.ID not in (12, 11)
--go 

--truncate table dbo.WebUserPermit
--go 

--insert into dbo.WebUserPermit ( LinkUserId, LinkPrivilegeId )
--select a.Id, b.Id
--from dbo.WebUserInfo as a
--	, dbo.WebPrivilege as b 

SELECT * FROM dbo.OUTPUT 
where LinkChartCode = 'c020'

go 
-----------------------
--SELECT * FROM WebChart 
--WHERE ChartURL like '%3D%'  
--UPDATE WebChart SET 
--ChartURL = '../Charts/MSStackedColumn2DLineDY.swf' 
--WHERE 
--ChartURL = '../Charts/StackedColumn3DLineDY.swf' 
--UPDATE WebChart SET 
--ChartURL = ../Charts/StackedColumn2D.swf' 
--WHERE 
--ChartURL = '../Charts/StackedColumn3D.swf'

SELECT * FROM dbo.tblcaption order by LinkChartCode asc 

--update dbo.tblcaption 
--set Caption = 'MNCs Performance vs Total China Market'
--where LinkChartCode = 'c020'


--update dbo.tblcaption 
--set Caption = 'Top MNCs Performance – IMS'
--where LinkChartCode = 'c040'

--update dbo.tblcaption 
--set Caption = 'Top MNCs Performance – RDPAC'
--where LinkChartCode = 'c100'

--update dbo.tblcaption 
--set Caption = 'Top MNC Products Performance – IMS'
--where LinkChartCode = 'c050'

--update dbo.tblcaption 
--set Caption = 'Top MNC Products Performance – RDPAC'
--where LinkChartCode = 'c110'

--update dbo.tblcaption 
--set Caption = 'Baraclude Market: Key Brands’ Performance by Region - Non BAL'
--where LinkChartCode = 'c140'

use BMSChina_staging_test 
go 

select chartURL, highChartType, * from webchart
go
alter table webchart 
add HighChartType varchar(50)
go 

update webchart 
set HighchartType  = 'StackedColumn'
where chartURL like '%Stacked%'

update webchart 
set HighchartType  = 'Line'
where chartURL like '%Line%'

update webchart 
set HighchartType  = 'StackedColumnLineDY2D'
where chartURL like '%Stacked%'
	and chartURL like '%LineDY%'

update webchart 
set HighchartType  = 'StackedColumnLineDY2D'
where HighChartType is null 

go

alter table WebChartSeries
add HighChartSeriesType varchar(50)
go 

--SELECT a.*
update a 
set a.HighChartSeriesType = 
	case when a.series like '%growth%' or a.series like '%G R%' or a.series like '%share%' then 'line'
		 else 'StackedColumn' end 
from WebChartSeries as a
inner join dbo.WebChart as b on a.LinkChartCode = b.Code
where b.highChartType = 'StackedColumnLineDY'


update dbo.WebChartSeries 
set HighChartSeriesType = 'line'
where Series like '%growth%'


use BMSChinaMRBI_test
go 

SELECT * into tblSalesRegion FROM tblSalesRegion_201703

delete dbo.tblSalesRegion 
--SELECT * FROM tblSalesRegion
where Product not in ('Baraclude')

select * FROM BMSChinaCIA_IMS_test.dbo.outputgeo

SELECT *,  replace(b.City, N'市', '')
from tblSalesRegion as a 
left join BMSChinaCIA_IMS_test.dbo.maxcity as b 
on a.Province1 = b.Province and a.City1 = replace(b.City, N'市', '')

update  a 
set a.IMSCity1 = replace(b.City, N'市', '')
from tblSalesRegion as a 
left join BMSChinaCIA_IMS_test.dbo.maxcity as b 
on a.Province1 = b.Province and a.City1 = replace(b.City, N'市', '')

update a 
set a.IMSCity = a.City
from tblSalesRegion as a
where a.IMSCity1 is not null and a.IMSCity is null  

SELECT * FROM tblSalesRegion 
where city <> IMSCity

update a 
set IMSCity = a.City
from dbo.tblSalesRegion as a
where city in (
	'Foshan',
	'Dongguan',
	'Zhongshan',
	'Zhuhai',
	'Fuzhou',
	'Quanzhou',
	'Xiamen')

update a 
set a.IMSCity = null
from dbo.tblSalesRegion as a
where a.IMSCity1 is null
