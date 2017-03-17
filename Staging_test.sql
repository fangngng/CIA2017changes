
SELECT * FROM dbo.WebChartTitle 
where LinkChartCode = 'c120'

SELECT * FROM dbo.OUTPUT

select c.*,p.chartIdx,p.IsShow,wp.Code as SectionTitle 
from webpagechart p
inner join WebChart c on p.LinkChartCode=c.Code
left join WebPage wp on p.SectionId=wp.Id
where p.LinkPageId=11 and p.IsShow='y' and p.LinkChartCode in (select distinct LinkChartCode from WebChartTitle where LinkProductId=11 and LinkGeoId=445)
order by chartIdx

SELECT * FROM WebChart 

SELECT * FROM WebChartTitle 
where LinkProductId=11



select * from dbo.WebPage
	where ParentID =( select ID from WebPage where Code= 'Dashboard')


select B.ID, a.* 
from output A 
inner join  Db4.BMSChinaCIA_IMS_test.dbo.Outputgeo B
on A.Geo=B.Geo and A.ParentGeo=B.ParentGeo and A.Product=B.Product
where linkproductID = 11 and A.LinkGeoId = 445

SELECT * FROM Db4.BMSChinaCIA_IMS_test.dbo.Outputgeo 

SELECT distinct LinkChartCode FROM output 


select distinct g.* 
from WebPrivilege p
inner join WebOutputGeo g on p.LinkGeoId=g.Id
inner join WebUserPermit u on p.Id=u.LinkPrivilegeId
where u.LinkUserId=5 and p.LinkPageId=11
order by g.Lev,g.Idx 

SELECT * FROM WebUserPermit 

--SELECT * into WebOutputGeo FROM BMSChina_staging_test.dbo.WebOutputGeo 

--	SELECT * into WebOutputGeo_2016 FROM WebOutputGeo 
--	SELECT * into WebPrivilege_201703 FROM WebPrivilege 

SELECT * FROM  WebOutputGeo 
SELECT * FROM  WebOutputGeo_2016 

SELECT * FROM WebPrivilege where LinkPageId = 11
SELECT * FROM WebPrivilege where LinkGeoId = 445

update dbo.WebPrivilege set LinkGeoId = 1 
where LinkGeoId = 445


select distinct * 
from WebPrivilege p
inner join WebOutputGeo_2016 g on p.LinkGeoId=g.Id

SELECT *  
from weboutputgeo_2016 as a
inner join dbo.webOutputgeo as b on a.geoname = b.geoname and a.product = b.product 

SELECT * FROM dbo.WebPage

SELECT * FROM tblCondition where Code=@Code and VersionCode=@VersionCode

select distinct LinkChartCode,LinkProductId,LinkGeoId,Category,TimeFrame,CategoryIdx,TimeFrameIdx from WebChartTitle
where LinkChartCode='C020' and LinkProductId='11' and LinkGeoId='1'

select * FROM WebOutputGeo

select distinct * 
from WebPrivilege p 
inner join WebOutputGeo g on p.LinkGeoId=g.Id 
inner join WebUserPermit u on p.Id=u.LinkPrivilegeId 
where u.LinkUserId=5 and p.LinkPageId=12 
order by g.Lev,g.Idx

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
where LinkChartCode = 'c130' and Product = 'monopril'

delete OUTPUT
where LinkChartCode = 'c120' and y is null 


SELECT * FROM TempOutput.dbo.MTHCITY_CMPS

select distinct LinkChartCode,LinkProductId,LinkGeoId,Category,TimeFrame,CategoryIdx,TimeFrameIdx 
from WebChartTitle 
WHERE linkchartcode ='D091' 
AND LinkProductId= 12 
and LinkGeoId = 9

SELECT * FROM WebChartTitle 


SELECT * FROM dbo.output
where LinkChartCode = 'c020'

delete dbo.OUTPUT 
where LinkChartCode = 'c020'


insert	into dbo.output ( DataSource, LinkGeoID, LinkProductID, [LinkChartCode], [LinkSeriesCode], [Series], [SeriesIdx],
						  [Category], [Product], [Lev], [ParentGeo], [Geo], [Currency], [TimeFrame], [X], [XIdx], [Y],
						  [LinkedY], [Size], [OtherParameters], [Color], [R], [G], [B], [IsShow] )
select	DataSource, GeoID, ProductID, [LinkChartCode], [LinkSeriesCode], [Series], [SeriesIdx], [Category], [Product],
		[Lev], [ParentGeo], [Geo], [Currency], [TimeFrame], [X], [XIdx], cast(cast([Y] as decimal(25, 12)) as varchar),
		[LinkedY], [Size], [OtherParameters], [Color], [R], [G], [B], [IsShow]
from	db4.BMSChinaCIA_IMS_test.dbo.output_stage
where	linkchartcode = 'c020' 


select * from WebChartTitle 
where linkchartcode ='c201' 
	AND LinkProductId= 1
	and LinkGeoId = 1

--SELECT * FROM WebChartSeries as a
--SELECT * FROM dbo.WebChart as b
--go 

--alter table WebChartSeries
--add HighChartSeriesType varchar(50)
--go 

----SELECT a.*
--update a 
--set a.HighChartSeriesType = 
--	case when a.series like '%growth%' or a.series like '%G R%' or a.series like '%share%' then 'line'
--		 else 'StackedColumn' end 
--from WebChartSeries as a
--inner join dbo.WebChart as b on a.LinkChartCode = b.Code
--where b.highChartType = 'StackedColumnLineDY'

SELECT * FROM WebChartSeries 


--SELECT a.*