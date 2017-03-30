--Ensure linked with server 172.20.0.82
if not exists(select 1 from master.dbo.sysdatabases where name='BMSChina_ppt')
BEGIN
	RAISERROR ('The connection server is not 172.20.0.82, please re-connect the correct server!!',21,1) with log
END

--DB82
print (N'
------------------------------------------------------------------------------------------------------------
1.                  备份
------------------------------------------------------------------------------------------------------------
')
USE BMSChina_bk
GO

--backup
declare @curDate_IMS varchar(6), @lastDate_IMS varchar(6)
  
select @curDate_IMS= [Value] from DB4.BMSChinaCIA_IMS.dbo.Config where Parameter = 'IMS'
set @lastDate_IMS = convert(varchar(6), dateadd(month, -1, cast(@curDate_IMS+'01' as datetime)), 112)
--staging
exec('
if object_id(N''output_'+@lastDate_IMS+''',N''U'') is null
   select * into output_'+@lastDate_IMS+'
   from BMSChina_staging.dbo.output
');
exec('
if object_id(N''WebChartTitle_'+@lastDate_IMS+''',N''U'') is null
   select * into WebChartTitle_'+@lastDate_IMS+'
   from BMSChina_staging.dbo.WebChartTitle
');
exec('
if object_id(N''WebChartSeries_'+@lastDate_IMS+''',N''U'') is null
   select * into WebChartSeries_'+@lastDate_IMS+'
   from BMSChina_staging.dbo.WebChartSeries
');
exec('
if object_id(N''Outputgeo_'+@lastDate_IMS+''',N''U'') is null
   select * into Outputgeo_'+@lastDate_IMS+'
   from BMSChina_staging.dbo.Outputgeo
');
--PPT
exec('
if object_id(N''output_ppt_'+@lastDate_IMS+''',N''U'') is null
   select * into output_ppt_'+@lastDate_IMS+'
   from BMSChina_ppt.dbo.output_ppt
');
exec('
if object_id(N''tblcharttitle_'+@lastDate_IMS+''',N''U'') is null
   select * into tblcharttitle_'+@lastDate_IMS+'
   from BMSChina_ppt.dbo.tblcharttitle
')
GO









print (N'
------------------------------------------------------------------------------------------------------------
2.                  导入staging
------------------------------------------------------------------------------------------------------------
')
USE BMSChina_staging
GO

if not exists(select 1 from   syscolumns   where   id=object_id('[output]')   and   name='DataSource' )
begin
	alter table [output] add DataSource nvarchar(20)
end	
go

if not exists(select 1 from   syscolumns   where   id=object_id('[webChartTitle]')   and   name='DataSource' )
begin
	alter table webChartTitle add DataSource nvarchar(20)
end	
go

if not exists(select 1 from   syscolumns   where   id=object_id('WebChartSeries')   and   name='DataSource' )
begin
	alter table WebChartSeries add DataSource nvarchar(20)
end	
go


truncate table [output]
truncate table webChartTitle
truncate table webChartSeries
truncate table webOutputGeo
go

insert into dbo.output(DataSource,LinkGeoID,LinkProductID,[LinkChartCode],[LinkSeriesCode],[Series] ,[SeriesIdx],[Category],[Product],[Lev],[ParentGeo],[Geo],[Currency],[TimeFrame],[X],[XIdx],[Y],[LinkedY],[Size],[OtherParameters],[Color] ,[R],[G],[B] ,[IsShow])
select 
      DataSource
      ,GeoID
      ,ProductID
      ,[LinkChartCode]
      ,[LinkSeriesCode]
      ,[Series] 
      ,[SeriesIdx]
      ,[Category]
      ,[Product]
      ,[Lev]
      ,[ParentGeo]
      ,[Geo]
      ,[Currency]
      ,[TimeFrame]
      ,[X]
      ,[XIdx]
      ,cast(cast([Y] as decimal(26,12)) as varchar)
      ,[LinkedY]
      ,[Size]
      ,[OtherParameters]
      ,[Color] 
      ,[R]
      ,[G]
      ,[B] 
      ,[IsShow] 
from db4.BMSChinaCIA_IMS.dbo.output
where linkchartcode not like 'R%'
go

--delete from  dbo.output 
--where (LinkChartCode like 'D08%' or LinkChartCode like 'D09%' or LinkChartCode like 'D10%') and Y is null
--go

DELETE FROM dbo.output 
WHERE LINKCHARTCODE in('D084','D094','D104','R054','R064','R074','R084') AND y IS NULL
go


update dbo.output set Y=null 
where cast(y as float)=0 and series<>'Change in Rank' and linkchartcode in (
'C140','C141','C900','D022','D024','D032','D042','R030','D021','D023','D031','D041','D081','D085','D082','D086','D091','D092','D101','D102','D083','D087','D087','D093','D103'
)

update output set Y=null 
where linkchartcode in (
'C140','C141','C900','D021','D023','D022','D024','D031','D032','D041','D042',
'D083','D087','D093','D103','R053','R063','R073','R083'
) 
and isshow='Y' and cast(Y as float)>10
go

update output
set Y=OtherParameters where linkchartcode in ('R420','R430') and isshow='N'




--delete from db102.BMSChina.dbo.webChartTitle
--where linkchartcode in (select linkchartcode from tblOutputlinkchartcode)

insert into dbo.webChartTitle(LinkGeoID,LinkProductID,[LinkChartCode],[Category],[Product],[Lev] ,ParentGeo,[Geo],[Currency],[TimeFrame] ,[Caption],[SubCaption],slidetitle,YAxisName,[PYAxisName],[SYAxisName] ,[Templatename],[Outputname],[ParentCode],[CategoryIdx],TimeFrameIdx,DataSource)
select * from db4.BMSChinaCIA_IMS.dbo.WebChartTitle





--delete from db102.BMSChina.dbo.webChartSeries
--where linkchartcode in (select linkchartcode from tblOutputlinkchartcode)

-- select * from webChartSeries
select  
      code
      ,count( code)
from db4.BMSChinaCIA_IMS.dbo.WebChartSeries
group by code having count( code)>1

insert into dbo.webChartSeries(DataSource,[Code]
      ,[LinkChartCode]
      ,[Geo]
      ,[Series]
      ,[SeriesIdx]
      ,[Color]
      ,[ParentYAxis]
      ,[AnchorSide]
      ,[AnchorRadius]
      ,[AnchorBorderThickness]
      ,[IsSingle]
      ,[Remark])
select  DataSource,
       [Code]
      ,[LinkChartCode]
      ,[Geo]
      ,[Series]
      ,[SeriesIdx]
      ,[Color]
      ,[ParentYAxis]
      ,[AnchorSide]
      ,[AnchorRadius]
      ,[AnchorBorderThickness]
      ,[IsSingle]
      ,[Remark]  
from db4.BMSChinaCIA_IMS.dbo.WebChartSeries

go
print 'webchartseries'

update a 
set a.HighChartSeriesType = 
	case when a.series like '%growth%' 
                  or a.series like '%G R%' 
                  or a.series like '%share%' 
                  or a.series like '%CAGR%' 
                  then 'line'
		 else 'StackedColumn' end 
from BMSChina_staging.dbo.WebChartSeries as a
inner join BMSChina_staging.dbo.WebChart as b on a.LinkChartCode = b.Code
where b.highChartType = 'StackedColumnLineDY'
      or b.HighChartType = 'ColumnLineDY'
go 



insert into dbo.weboutputgeo
      (ID,geo,geoname,lev,idx,Parentid,ParentGeo,linkproductid,Product)
select id,geo,geoname,lev,geoIDx,Parentid,ParentGeo,productid ,Product
from  db4.BMSChinaCIA_IMS.dbo.outputgeo




delete FROM [BMSChina_staging].[dbo].[WebChartTitle] 
where linkchartcode IN('R401','R411') and timeframe='MTH' and Product in ('Taxol','Paraplatin')

UPDATE [BMSChina_staging].[dbo].[WebChartTitle] 
SET SubCaption = 'RDPAC'
WHERE SubCaption LIKE '%HKAPI%'


print (N'
------------------------------------------------------------------------------------------------------------
3.                  导入PPT
------------------------------------------------------------------------------------------------------------
')
use BMSChina_ppt
go

if not exists(select 1 from   syscolumns   where   id=object_id('[output_ppt]')   and   name='DataSource' )
begin
	alter table output_ppt add DataSource nvarchar(20)
end

if not exists(select 1 from   syscolumns   where   id=object_id('[tblChartTitle]')   and   name='DataSource' )
begin
	alter table tblChartTitle add DataSource nvarchar(20)
end

truncate table output_ppt
go
truncate table tblChartTitle
go
truncate table outputgeo
go
insert into dbo.output_ppt(DataSource,[LinkChartCode],[LinkSeriesCode],[Series] ,[SeriesIdx],[Category],[Product],[Lev],[ParentGeo],[Geo],[Currency],[TimeFrame],[X],[XIdx],y,[LinkedY],[Size],[OtherParameters],[Color] ,[R],[G],[B] ,[IsShow])
select DataSource,
      [LinkChartCode]
      ,[LinkSeriesCode]
      ,[Series] 
      ,[SeriesIdx]
      ,[Category]
      ,[Product]
      ,[Lev]
      ,[ParentGeo]
      ,[Geo]
      ,[Currency]
      ,[TimeFrame]
      ,[X]
      ,[XIdx]
      ,cast(cast([Y] as decimal(26,12)) as nvarchar)
      ,[LinkedY]
      ,[Size]
      ,[OtherParameters]
      ,[Color] 
      ,[R]
      ,[G]
      ,[B] 
      ,[IsShow] 
from db4.BMSChinaCIA_IMS.dbo.output 


DELETE FROM dbo.output_ppt 
WHERE LINKCHARTCODE in('D084','D094','D104','R054','R064','R074','R084') AND y IS NULL

delete  from output_ppt where linkchartCode='r010' and product='taxol' and isShow='N' and y is null
go

update dbo.output_ppt
set Y=null 
where cast(y as float)=0 and series<>'Change in Rank'
      and linkchartcode in ('C140','C900','D022','D024','D032','D042','R030','D021','D023','D031','D041','D081','D085','D082','D086','D091','D092','D101','D102','D083','D087','D087','D093','D103','R051','R052','R053','R061','R062','R063','R071','R072','R073','R081','R082','R083')
go

update output_ppt 
set Y=null 
where linkchartcode in (
      'C140','C900','D021','D023','D022','D024','D031','D032','D041','D042','D083','D087','D093','D103','R053','R063','R073','R083'
      ) 
      and isshow='Y' and cast(Y as float)>10

update output_ppt set Y=OtherParameters 
where linkchartcode in ('R420','R430') and isshow='N'


--Add Region on R630 & R620 PPT
insert into dbo.output_ppt(DataSource,[LinkChartCode],[LinkSeriesCode],[Series] ,[SeriesIdx],[Category],[Product],[Lev],[ParentGeo],[Geo],[Currency],[TimeFrame],[X],[XIdx],y,[IsShow])
select distinct DataSource,
      [LinkChartCode]
      ,[LinkSeriesCode]
      ,[Series] 
      ,[SeriesIdx]
      ,[Category]
      ,[Product]
      ,[Lev]
      ,[ParentGeo]
      ,[Geo]
      ,[Currency]
      ,[TimeFrame]
      ,'Region' as [X]
      , 1 as [XIdx]
      , b.Region as Y
      ,[IsShow] 
from db4.BMSChinaCIA_IMS.dbo.output a 
join (
	select Geo as city, ParentGeo as Region 
	from db4.BMSChinaCIA_IMS.dbo.outputgeo 
      where (product='coniel' and lev=2) or parentgeo is null
) b  on a.Series= case when b.city='China' then 'China(CHPA)' else b.city end
where a.LinkChartCode in ('R630','R620','R720','R730')

go



insert into dbo.tblChartTitle(DataSource,[LinkChartCode],[Category],[Product],[Lev] ,Parentgeo,[Geo],[Currency],[TimeFrame] ,[Caption],[SubCaption],slidetitle,[PYAxisName],[SYAxisName] ,[Templatename],[Outputname],[ParentCode],[CategoryIdx])
select DataSource,
      [LinkChartCode]
      ,[Category]
      ,[Product]
      ,[Lev] 
      ,Parentgeo,[Geo]
      ,[Currency]
      ,[TimeFrame] 
      ,[Caption]
      ,[SubCaption]
      ,slidetitle
      ,[PYAxisName]
      ,[SYAxisName] 
      ,[Templatename]
      ,[Outputname]
      ,[ParentCode]
      ,[CategoryIdx] 
from db4.BMSChinaCIA_IMS.dbo.WebChartTitle
go

insert into dbo.outputgeo(ID,geo,geoname,lev,product,ParentGeo,Geoidx)
select 
      ID
      ,geo
      ,geoname
      ,lev
      ,product
      ,ParentGeo
      ,Geoidx 
from db4.BMSChinaCIA_IMS.dbo.outputgeo











print (N'
------------------------------------------------------------------------------------------------------------
4.                  更新 datasource
------------------------------------------------------------------------------------------------------------
--')

use BMSChina_staging
go

--insert into webchartexplain (Code ,timeframe,productID,Product,DataSource,DataSource_CN,Explain,Explain_CN)
--values ('r710',null,14,'Monopril','Data Source: IMS CHPA Oct''13','Data Source: IMS CHPA Oct''13',null,null)

--insert into WebChartExplain (Code, TimeFrame,ProductID,Product,DataSource,DataSource_CN)
--values('R777','MTH',12,'Baraclude','Data Source: IMS July''13','Data Source: IMS July''13')

--insert into webchartexplain (Code ,timeframe,productID,Product,DataSource,DataSource_CN,Explain,Explain_CN)
--values ('r610',null,14,'Monopril','Data Source: IMS CHPA Oct''13','Data Source: IMS CHPA Oct''13',null,null)

--insert into webchartexplain (Code ,timeframe,productID,Product,DataSource,DataSource_CN,Explain,Explain_CN)
--values ('r610',null,20,'Coniel','Data Source: IMS CHPA Oct''13','Data Source: IMS CHPA Oct''13',null,null)

--下载数据：--todo
update webpage 
set ImageURL = replace(imageurl,'2016 Dec','2017 Jan')    
where id in (248,293,307)

-- update tblVersionInfo 
-- set CN = N'数据月: 2016年11月', EN = 'Data Month: Dec.-16' where Name = 'DataMonth'
-- select * from tblVersionInfo where Name = 'DataMonth'
GO


-- todo
--每月修改
update dbo.WebChartExplain
set datasource=replace(datasource,'Dec''16','Jan''17'),
	datasource_cn=replace(datasource_cn,'Dec''16','Jan''17')
where datasource like '%IMS%'
select * from WebChartExplain where datasource like '%ims%' order  by code

update WebChartExplain set 
	DataSource='Data Source: IMS CHPA CITY Jan''17',
	DataSource_CN='Data Source: IMS CHPA CITY Jan''17'
where code like 'C16%' 
and Product in ('Paraplatin')


--每个季度末才修改
update dbo.WebChartExplain
set datasource=replace(datasource,'Sep''16','Jan''17'),
	datasource_cn=replace(datasource_cn,'Sep''16','Jan''17')
where datasource like '%RDPAC%'
select * from WebChartExplain where datasource like '%RDPAC%' order  by code

--RX
update dbo.WebChartExplain
set datasource=replace(datasource,'2014 H2','2016 H1'),
	datasource_cn=replace(datasource_cn,'2014 H2','2016 H1')
where datasource like '%Rx%'

-- todo
update tbldates set DateValue='Jan''17' where DateSource='MonthDate' --每月修改

update tbldates set DateValue='Jan''16' where DateSource='HKAPITime'  --每个季度末才修改

update tbldates set DateValue='MAT Jan''13 to MAT Jan''17' where DateSource='CAGRMATDate' --每月修改

update tbldates set DateValue='MQT Jun''14 to MQT Jan''17' where DateSource='CAGR3MthsDate' --每月修改

update tbldates set DateValue= 'Jan''17 vs. Jan''16' where DateSource='CurrVSLast'  --每月修改

update tbldates set DateValue='MAT 12Q4 to MAT 16Q4' where DateSource='CAGRMATQuarterDate' --每个季度末才修改

--每月修改 --todo
update tbldates 
set DateValue='201612'                            
where DateSource in  
      ('CurrentMonthlyDate',
      'Onglyza',
      'Baraclude',
      'Monopril',
      'Taxol',
      'Paraplatin',
      'Onglyza',
      'Glucophage',
      'Sprycel',
      'Eliquis',
      'Coniel')
go
select * from tbldates







use BMSChina_ppt
GO


update tbldates set DateValue='Jan''17' where DateSource='MonthDate'  --每月修改

update tbldates set DateValue='Jan''17' where DateSource='HKAPITime' --只有在一个季度的最后一个月才需要修改

--insert into tbldates ( DateSource , DateValue ) --Added by Xiaoyu.Chen on 20130906
--values('CurrVSLast','Jun''13 vs. Jun''12')

update tbldates set DateValue= 'Jan''17 vs. Jan''16' where DateSource='CurrVSLast'  --每月修改

update tbldates set DateValue='MAT Jan''13 to MAT Jan''17' where DateSource='CAGRMATDate'  --每月修改

update tbldates set DateValue='MQT Jun''14 to MQT Jan''17' where DateSource='CAGR3MthsDate'  --每月修改

update tbldates set DateValue='MAT 12Q4 to MAT 16Q4' where DateSource='CAGRMATQuarterDate'	--todo 只有在一个季度的最后一个月才需要修改

--每月修改 --todo
update tbldates 
set DateValue='201612'                                  
where DateSource in                         
      ('CurrentMonthlyDate',
      'Onglyza',
      'Baraclude',
      'Monopril',
      'Taxol',
      'Paraplatin',
      'Onglyza',
      'Glucophage',
      'Sprycel',
      'Eliquis',
      'Coniel')
go
select * from tbldates








