use BMSChina_staging
go


-- select * from BMSChina_ppt.dbo.OUTPUT_ppt -- 186117










delete OUTPUT where LinkChartCode in('C202','D050','D051','D060','D110','D111','D130','D150')
go
 
insert into dbo.OUTPUT(DataSource,LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters, Color, R, G, B, IsShow)
select DataSource, LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters, Color, R, G, B, IsShow
from BMSChina_ppt.dbo.OUTPUT_ppt
where  LinkChartCode in('C202','D050','D051','D060','D110','D111','D130','D150', 'C170')
go

update dbo.OUTPUT set LinkedY = null
where LinkChartCode in('C202','D050','D051','D060','D110','D111','D130','D150', 'C170') and linkedY is not null
go

--update ProudctId and Geoid 20120214
update Output set LinkProductID =B.ID 
from Output A inner join( 
	select * from dbo.WebPage
	where ParentID =( select ID from WebPage where Code= 'Dashboard')
) B on A.Product=B.Code
go
--Add geo ppt for eliquis
update Output set LinkProductID =B.ID 
from Output A inner join( 
	select * from dbo.WebPage
	where ParentID =( select ID from WebPage where Code= 'Dashboard')
) B on left(A.Product,7)=B.Code where a.product like 'Eliquis%'
go


update output set LinkGeoID = null
go

update output
set LinkGeoID=B.ID 
from output A 
inner join  Db4.BMSChinaCIA_IMS.dbo.Outputgeo B
on A.Geo=B.Geo and A.ParentGeo=B.ParentGeo and A.Product=B.Product
go
update output
set LinkGeoID=B.ID 
from output A 
inner join  Db4.BMSChinaCIA_IMS.dbo.Outputgeo B
on A.Geo=B.Geo and A.ParentGeo=B.ParentGeo and left(A.Product,7)=B.Product
where a.product in ('eliquis vtep','eliquis noac')
go

update output
set LinkGeoID=B.ID 
from output A 
inner join  Db4.BMSChinaCIA_IMS.dbo.Outputgeo B
on A.Geo=B.Geo where A.geo= 'China' and A. LinkGeoID is null
go


delete WebChartTitle
where LinkChartCode in('C202','D050','D051','D060','D110','D111','D130','D150', 'C170')
go
insert into WebChartTitle(DataSource,LinkChartCode, Category, Product, Lev, Geo, ParentGeo, Currency, TimeFrame, Caption, SubCaption, SlideTitle, PYAxisName, SYAxisName, Templatename, Outputname, ParentCode, CategoryIdx)
select DataSource, LinkChartCode, Category, Product, Lev, Geo, ParentGeo, Currency, TimeFrame, Caption, SubCaption, SlideTitle, PYAxisName, SYAxisName, Templatename, Outputname, ParentCode, CategoryIdx
from BMSChina_ppt.dbo.tblChartTitle
where LinkChartCode in('C202','D050','D051','D060','D110','D111','D130','D150', 'C170')
go

update WebChartTitle 
set LinkProductID =B.ID 
from WebChartTitle A 
inner join( 
	select * from dbo.WebPage
	where ParentID =( select ID from WebPage where Code= 'Dashboard')
) B on A.Product=B.Code
where a.LinkChartCode in('C202','D050','D051','D060','D110','D111','D130','D150', 'C170')
go

update WebChartTitle set LinkProductID =B.ID 
from WebChartTitle A inner join( 
	select * from dbo.WebPage
	where ParentID =( select ID from WebPage where Code= 'Dashboard')
) B on left(A.Product,7)=B.Code
where a.LinkChartCode in('D050','D051','D110','D111') and a.product like'eliquis%'

update WebChartTitle 
set LinkGeoID=B.ID 
from WebChartTitle A 
inner join  Db4.BMSChinaCIA_IMS.dbo.Outputgeo B
on A.Geo=B.Geo and A.ParentGeo=B.ParentGeo and A.Product=B.Product
where a.LinkChartCode in('C202','D050','D051','D060','D110','D111','D130','D150', 'C170')
go
update WebChartTitle 
set LinkGeoID=B.ID 
from WebChartTitle A 
inner join  Db4.BMSChinaCIA_IMS.dbo.Outputgeo B
on A.Geo=B.Geo and A.ParentGeo=B.ParentGeo and left(A.Product,7)=B.Product
where a.LinkChartCode in('D050','D051','D110','D111') and a.product like'eliquis%'
go

update WebChartTitle
set LinkGeoID=B.ID 
from WebChartTitle A 
inner join  Db4.BMSChinaCIA_IMS.dbo.Outputgeo B
	on A.Geo=B.Geo
where  A.geo= 'China' and A. LinkGeoID is null
	and a.LinkChartCode in('C202','D050','D051','D060','D110','D111','D130','D150', 'C170')
go
delete WebChartSeries  where LinkChartCode = 'c202'

insert into WebChartSeries (DataSource,Code,linkChartCode,Geo,Series,SeriesIdx,Color)
select distinct DataSource, LinkSeriesCode, LinkChartCode,Geo,Series,SeriesIdx,Color
from BMSChina_ppt.dbo.Output_PPT 
where LinkChartCode = 'c202'
go

delete WebChartSeries  where LinkChartCode in( 'd050','D051')

insert into WebChartSeries (DataSource,Code,linkChartCode,Geo,Series,SeriesIdx,Color)
select distinct DataSource, LinkSeriesCode, LinkChartCode,Geo,Series,SeriesIdx,Color
from BMSChina_ppt.dbo.Output_PPT 
where LinkChartCode in ('D050','D051')
go

delete WebChartSeries  where LinkChartCode = 'D060'

insert into WebChartSeries ( DataSource,Code,linkChartCode,Geo,Series,SeriesIdx,Color)
select distinct DataSource, LinkSeriesCode, LinkChartCode,Geo,Series,SeriesIdx,Color
from BMSChina_ppt.dbo.Output_PPT 
where LinkChartCode = 'D060'
go

delete WebChartSeries  where LinkChartCode in ('D110','D111')
go

insert into WebChartSeries ( DataSource,Code,linkChartCode,Geo,Series,SeriesIdx,Color)
select distinct DataSource, LinkSeriesCode, LinkChartCode,Geo,Series,SeriesIdx,Color
from BMSChina_ppt.dbo.Output_PPT 
where LinkChartCode in ('D110','D111')
go

delete WebChartSeries  where LinkChartCode = 'D130'
go

insert into WebChartSeries (DataSource,Code,linkChartCode,Geo,Series,SeriesIdx,Color)
select distinct DataSource, LinkSeriesCode, LinkChartCode,Geo,Series,SeriesIdx,Color
from BMSChina_ppt.dbo.Output_PPT 
where LinkChartCode = 'D130'
go

delete WebChartSeries  where LinkChartCode = 'D150'
go

insert into WebChartSeries ( DataSource,Code,linkChartCode,Geo,Series,SeriesIdx,Color)
select distinct DataSource, LinkSeriesCode, LinkChartCode,Geo,Series,SeriesIdx,Color
from BMSChina_ppt.dbo.Output_PPT 
where LinkChartCode = 'D150'
go
delete WebChartSeries  where LinkChartCode = 'c170'

insert into WebChartSeries (DataSource,Code,linkChartCode,Geo,Series,SeriesIdx,Color)
select distinct DataSource, LinkSeriesCode, LinkChartCode,Geo,Series,SeriesIdx,Color
from BMSChina_ppt.dbo.Output_PPT 
where LinkChartCode = 'c170'

update webchartseries set parentyaxis='P' where linkchartcode='d130'
update webchartseries set parentyaxis='P' where linkchartcode='c170'
go


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


update webcharttitle set YAxisName=PYAxisName 
where linkchartcode in('D130','D150')
go


update webcharttitle set timeframeidx=1 where timeframe='mat'
go
update webcharttitle set timeframeidx=2 where timeframe='mqt'
go
update webcharttitle set timeframeidx=3 where timeframe='ytd'
go
update webcharttitle set timeframeidx=4 where timeframe='mth'
go
update webcharttitle set timeframeidx=5 where timeframe='Last Year'
go
update webcharttitle set timeframeidx=6 where timeframe='MAT Month'
go
update webcharttitle set timeframeidx=7 where timeframe='MAT Quarter'
go



--select * from WebChartTitle 
--where category = 'volume' and linkchartcode = 'd110' and geo = 'shanghai' and product = 'baraclude'

--select * from Output 
--where category = 'volume' and linkchartcode = 'd110' 
--	and geo = 'shanghai' and product = 'baraclude' and timeframe = 'mqt'
--	and parentgeo = 'east- I' and currency = 'unit'

--select * from Output
--where linkchartCode = 'D050'
--	and geo = 'east- i' 




update WebChartSeries set AnchorSide='4',AnchorRadius='4',AnchorBorderThickness='1',ParentYAxis='S'
--select * from WebChartSeries
where linkchartcode in (select distinct chartcode from tblpagecharts where charturl in( '../Charts/MSCombiDY2D.swf', '../Charts/MSStackedColumn2DLineDY.swf'))
and Series like '%Growth%'
and LinkChartCode in('D130','D110','D111','D150','D050','D051','D060')

update WebChartSeries set AnchorSide='4',AnchorRadius='4',AnchorBorderThickness='1',ParentYAxis='S'
--select * from WebChartSeries
where linkchartcode in (select distinct chartcode from tblpagecharts where charturl = '../Charts/StackedColumn3DLineDY.swf')
and Seriesidx=10000-- like '%Total%'
and LinkChartCode in('D130','D110','D111','D150','D050','D051','D060')

update WebChartSeries set AnchorSide='4',AnchorRadius='4',AnchorBorderThickness='1'
where linkchartcode in (select distinct chartcode from tblpagecharts where charturl = '../Charts/MSLine.swf')
and LinkChartCode in('D130','D110','D111','D150','D050','D051','D060')

--only one series
update WebChartSeries set IsSingle='Y' 
where linkchartcode in (select distinct chartcode from tblpagecharts where charturl = '../Charts/Column2D.swf')
and LinkChartCode in('D130','D110','D111','D150','D050','D051','D060')

update output set Color='4E71D1' 
where linkchartcode in (select distinct chartcode from tblpagecharts where charturl = '../Charts/Column2D.swf')
and LinkChartCode in('D130','D110','D111','D150','D050','D051','D060')

-- like %
update WebChartSeries set ParentYAxis='P'
where linkchartcode in (select distinct chartcode from tblpagecharts where charturl = '../Charts/MSLine.swf')
and LinkChartCode in('D130','D110','D111','D150','D050','D051','D060')
go
update webchartseries set ParentYAxis = 'P' where linkchartcode = 'd150'
go


update Webchartseries set AnchorSide='4',AnchorRadius='4',AnchorBorderThickness='1',ParentYAxis='S'
where linkchartcode in ('C202')
and (Series like '%Growth%' or Series like '%Share%')
GO

update webChartSeries set Remark='Bubble' ,ParentYAxis='P'
where linkchartcode='C160'


--------------------------------------------------
update webChartTitle set YAxisName='Market Share%'
where  linkchartcode='C150'



update webChartTitle set YAxisName= 
case when TimeFrame='MTH' then 'Taxol MTH Growth(%)'
     when TimeFrame='MQT' then 'Taxol MQT Growth(%)'
     when TimeFrame='MAT' then 'Taxol MAT Growth(%)' end 
,XAxisName='Taxol market share of city(%)'
-- select * from webChartTitle --where  linkchartcode='C130'
where  linkchartcode='C160'
go

update webChartTitle set YAxisName= 
case when TimeFrame='MTH' then 'Taxol MTH Growth(%)'
     when TimeFrame='MQT' then 'Taxol MQT Growth(%)'
     when TimeFrame='MAT' then 'Taxol MAT Growth(%)' end 
,XAxisName='Taxol market share of city(%)'
-- select * from webChartTitle --where  linkchartcode='C130'
where  linkchartcode='C160' and Product='Taxol'


update webChartTitle set YAxisName= 
case when TimeFrame='MTH' then 'Paraplatin MTH Growth(%)'
     when TimeFrame='MQT' then 'Paraplatin MQT Growth(%)'
     when TimeFrame='MAT' then 'Paraplatin MAT Growth(%)' end 
,XAxisName='Paraplatin market share of city(%)'
-- select * from webChartTitle --where  linkchartcode='C130'
where  linkchartcode='C160' and Product='Paraplatin'
go


update WebChartExplain set Explain='MAT: Moving Annual Total.',Explain_CN=N'MAT: Moving Annual Total.'
where TimeFrame='MAT' 

update WebChartExplain set Explain='Bubble size: Taxol Value',Explain_CN=N'Bubble size: Taxol Value'
where code like 'C160'  and Product = 'Taxol'
update WebChartExplain set Explain='Bubble size: Paraplatin Value',Explain_CN=N'Bubble size: Paraplatin Value'
where code like 'C160'  and Product = 'Paraplatin'

update WebChartExplain set 
 Explain='MAT: Moving Annual Total.  || MNC: Gemcitabine;Docetaxel; Paclitaxel'
,Explain_CN=N'MAT: Moving Annual Total.  || MNC: Gemcitabine;Docetaxel; Paclitaxel'
where code like 'R420' and Product = 'Taxol'
update WebChartExplain set 
 Explain='MAT: Moving Annual Total.  || MNC: Carboplatin ;Cisplatin ; Nedaplatin'
,Explain_CN=N'MAT: Moving Annual Total.  || MNC: Carboplatin ;Cisplatin ; Nedaplatin'
where code like 'R420' and Product = 'Paraplatin'


update WebChartExplain set 
 Explain='MAT: Moving Annual Total.  || [Gemcitabine:Gemzar] [Docetaxel  :Taxotere] [Paclitaxel :Taxol,Abraxane,Anzatax]'
,Explain_CN=N'MAT: Moving Annual Total.  || [Gemcitabine:Gemzar] [Docetaxel  :Taxotere] [Paclitaxel :Taxol,Abraxane,Anzatax]'
where code like 'R430' and Product = 'Taxol'
update WebChartExplain set 
 Explain='MAT: Moving Annual Total.  || [Carboplatin:Paraplatin,Loca] [Cisplatin  :Bo Long,Cisplatin,Fang Tan,Jin Shun,Nuo Xin] [Nedaplatin :Ao Xian Da,Jie Bai Shu,Lu Bei,Quan Bo]'
,Explain_CN=N'MAT: Moving Annual Total.  || [Carboplatin:Paraplatin,Loca] [Cisplatin  :Bo Long,Cisplatin,Fang Tan,Jin Shun,Nuo Xin] [Nedaplatin :Ao Xian Da,Jie Bai Shu,Lu Bei,Quan Bo]'
where code like 'R430' and Product = 'Paraplatin'















-- patch
delete --  select * 
from WebChartExplain 
where (
        code like 'R40%' 
        or code like 'R41%') -- web Dashboard datasource/ppt datasource
    and timeframe='MTH' and Product in ('Taxol','Paraplatin')

delete --  select * 
from tblSlide 
where (
        slidename like 'R40%'
        or slidename like '%R41%') -- web brand report/web shopping cart
    and SlideName like '%MTH%'  and (SlideCode like 'Taxol%' or SlideCode like 'Paraplatin')

delete --  select * 
from WebChartTitle where (
        linkchartcode like 'R40%'
        or linkchartCode like 'R41%'
    )-- web dashboard
    and timeframe='MTH' and  Product in ('Taxol','Paraplatin')

--update output set XIdx=5-XIdx -- select * 
--from output where linkchartcode = 'C150' and IsShow='Y'



update WebChartTitle
set SubCaption=replace(SubCaption,'49',B.CityNum)--todo:当Taxol的区域划分有变化时，改动数字
from WebChartTitle A 
inner join (
select ParentGeo,cast(count(distinct Geo) as nvarchar(10))  CityNum
from DB4.BMSChinaCIA_IMS.dbo.outputgeo where lev=2 and Product='taxol'
group by ParentGeo
) B
on A.Geo=B.ParentGeo
where  A.LinkChartCode ='C160'
go







update output set linkproductid=18
--select * 
from output where Product ='Paraplatin' and LinkChartCode not like 'R%'


update webcharttitle set LinkProductId=18 
-- select *
from webcharttitle where product='Paraplatin' and LinkChartCode not like 'R%'


update output set linkproductid=28
--select * 
from output where Product ='Paraplatin' and LinkChartCode  like 'R%'


update webcharttitle set LinkProductId=28 
-- select *
from webcharttitle where product='Paraplatin' and LinkChartCode  like 'R%'


delete --  select *
from tblSlide 
where slidename like 'R41%' and slidename like '%MTH%' and (slidecode like 'Taxol%' or slidecode like 'ParaPlatin%')

update WebChartTitle set TimeFrameidx=
case TimeFrame when 'MTH' then 1
               when 'MQT' then 2
               when 'MAT' then 3
               when 'YTD' then 4 end 
where linkchartcode  like 'D02%' and Product ='Baraclude'


update webcharttitle set CategoryIdx = 3 where Category='Adjusted patient number' and LinkChartCode in ('D050','D051','D110','D111','D130')

-- 20161115 delete Eliquis NOAC 
delete [BMSChina_staging].[dbo].[WebChartTitle]
where Caption like '%NOAC%'

--------------------------------------------------
-- webChart
--------------------------------------------------
--2013/7/26 15:36:23
-- webchart 表需要加多几个字段，如下所述
--  xAxisMinValue(X轴最小值) 
--, xAxisMaxValue(X轴最大值)
--, yNumberPrefix(Y轴的前缀)
--, yNumberSuffix(y轴后缀)
--, xNumberPrefix(X轴前缀) 
--,xNumberSuffix(X轴后缀)
--, xAxisValueDecimals（X轴的精度）


--update webChart set
-- xAxisMaxValue=35
---- select * from webChart
--where code='C160'







--
--insert into webChart 
--select 
--'C150'
--,'Taxol Performance by region'
--,[ChartURL]
--      ,[ShowNames]
--      ,[ShowValues]
--      ,[ZoomInShowMaxNum]
--      ,[ShowXOrder]
--      ,[Conditions]
--      ,[YAxisMaxValue]
--      ,[YAxisMinValue]
--      ,[RotateName]
--      ,[DecimalPrecision]
--      ,[ShowLegend]
--      ,[FormatNumberScale]
--      ,[NumberPrefix]
--      ,[NumberSuffix]
--      ,[SNumberPrefix]
--      ,[SNumberSuffix]
--      ,[UseRoundEdges]
--      ,[IsExpanded]
--      ,[IsZoomOut]
--      ,[IsZoomIn]
--      ,[IsShoppingCart]
--      ,[IsDownTable]
--      ,[ShowBorder]
--      ,[BorderColor]
--      ,[MaxColWidth]
--      ,[FirstColumnWidth]
--      ,[DownTableColWidth]
--from webChart where Code='C130'
--
--
--insert into webChart 
--select 
--'C160'
--,'Taxol City Performance'
--,'../Charts/Bubble.swf'
--      ,[ShowNames]
--      ,[ShowValues]
--      ,[ZoomInShowMaxNum]
--      ,[ShowXOrder]
--      ,[Conditions]
--      ,[YAxisMaxValue]
--      ,[YAxisMinValue]
--      ,[RotateName]
--      ,[DecimalPrecision]
--      ,[ShowLegend]
--      ,[FormatNumberScale]
--      ,[NumberPrefix]
--      ,[NumberSuffix]
--      ,[SNumberPrefix]
--      ,[SNumberSuffix]
--      ,[UseRoundEdges]
--      ,[IsExpanded]
--      ,[IsZoomOut]
--      ,[IsZoomIn]
--      ,[IsShoppingCart]
--      ,[IsDownTable]
--      ,[ShowBorder]
--      ,[BorderColor]
--      ,[MaxColWidth]
--      ,[FirstColumnWidth]
--      ,[DownTableColWidth] -- select * 
--from webChart where Code='C130'

-- delete Eliquis NOAC chart
-- delete	[BMSChina_staging].[dbo].[WebChart]
-- where code in (
-- 	select distinct LinkChartCode
-- 	from [BMSChina_staging].[dbo].[WebChartTitle]
-- 	where Caption like '%NOAC%'
-- )

-- 20170316 add new column HighChartType 
-- select chartURL, highChartType, * from webchart
-- go
-- alter table webchart 
-- add HighChartType varchar(50)
-- go 

-- update webchart 
-- set HighchartType  = 'StackedColumn'
-- where chartURL like '%Stacked%'

-- update webchart 
-- set HighchartType  = 'Line'
-- where chartURL like '%Line%'

-- update webchart 
-- set HighchartType  = 'StackedColumnLineDY2D'
-- where chartURL like '%Stacked%'
-- 	and chartURL like '%LineDY%'

-- update webchart 
-- set HighchartType  = 'StackedColumnLineDY2D'
-- where HighChartType is null 

-- go

                                                  
--------------------------------------------------
-- WebPageChart                                       
--------------------------------------------------

--insert into WebPageChart
--select 
--15,'C150',4,null,'Y'
--
--insert into WebPageChart
--select 
--15,'C160',5,null,'Y'




--------------------------------------------------
-- WebChartExplain                                       
--------------------------------------------------
--insert into WebChartExplain
--select 'C150','MTH',15,'Taxol','Data Source: IMS CHPA May''13','Data Source: IMS CHPA May''13',null,null union all
--select 'C150','MQT',15,'Taxol','Data Source: IMS CHPA May''13','Data Source: IMS CHPA May''13',null,null union all
--select 'C150','MAT',15,'Taxol','Data Source: IMS CHPA May''13','Data Source: IMS CHPA May''13',null,null union all
--select 'C150','YTD',15,'Taxol','Data Source: IMS CHPA May''13','Data Source: IMS CHPA May''13',null,null
--

--insert into webchartexplain (code,Timeframe,ProductID,Product,DataSource,DataSource_CN,Explain,Explain_CN)
--select 'c900',Timeframe,ProductID,Product,DataSource,DataSource_CN,Explain,Explain_CN
--from webchartexplain 
--where code = 'c140' and product = 'baraclude'



--insert into WebChartExplain
--select 'C160','MTH',15,'Taxol','Data Source: IMS CHPA CITY','Data Source: IMS CHPA CITY',null,null union all
--select 'C160','MQT',15,'Taxol','Data Source: IMS CHPA CITY','Data Source: IMS CHPA CITY',null,null union all
--select 'C160','MAT',15,'Taxol','Data Source: IMS CHPA CITY','Data Source: IMS CHPA CITY',null,null



----新增伯尔定的logo
--update webpage set IsShow='Y'
--where ImageURL like '%Paraplatin%'



--2013/8/6 11:29:52
--insert into webPageChart
--SELECT 18
--      ,[LinkChartCode]
--      ,[ChartIdx]
--      ,[SectionId]
--      ,[IsShow]
--  FROM [BMSChina_staging].[dbo].[WebPageChart]
-- where LinkPageID=15
--
--
--update output set linkproductid=18
----select * 
--from output where Product ='Paraplatin'



select 'Finish at',getdate()
go



print 'over!'