USE BMSChinaCIA_IMS --db4
GO

if not exists(select 1 from   syscolumns   where   id=object_id('WebChartSeries')   and   name='DataSource' )
begin
	alter table WebChartSeries add DataSource nvarchar(20)
end	
go

if not exists(select 1 from   syscolumns   where   id=object_id('WebChartTitle')   and   name='DataSource' )
begin
	alter table WebChartTitle add DataSource nvarchar(20)
end	

-------------------------------------
-- WebChartSeries
-------------------------------------
truncate table WebChartSeries
go
insert into dbo.WebChartSeries (DataSource,geo,LinkChartCode,code,Series,SeriesIdx,Color)
select  distinct DataSource, geo,LinkChartCode,LinkSeriesCode,series,seriesidx,color
from dbo.[Output]
GO

update Webchartseries set parentyaxis='P' where linkchartcode in('D021','D023','D031','D041','D022','D024','D032','D042','C140','C141','C900')

update Webchartseries set AnchorSide='4',AnchorRadius='4',AnchorBorderThickness='1',ParentYAxis='S'
--select * from Webchartseries
where linkchartcode in (
                        select distinct Code from db82.BMSChina_staging.dbo.WebChart 
                        where charturl in( '../Charts/MSCombiDY2D.swf','../Charts/StackedColumn3DLineDY.swf', '../Charts/MSStackedColumn2DLineDY.swf')
                        )
	and (Series like '%Growth%' or Series like '%Share%')



update Webchartseries set AnchorSide='4',AnchorRadius='4',AnchorBorderThickness='1',ParentYAxis='S'
--select * from Webchartseries
where linkchartcode in (
	select distinct Code from db82.BMSChina_staging.dbo.WebChart where charturl = '../Charts/StackedColumn3DLineDY.swf'
)
	and Seriesidx=10000

update Webchartseries set AnchorSide='4',AnchorRadius='4',AnchorBorderThickness='1'
where linkchartcode in (
	select distinct Code from db82.BMSChina_staging.dbo.WebChart where charturl = '../Charts/MSLine.swf'
)

--only one series
update Webchartseries set IsSingle='Y' 
where linkchartcode in (
	select distinct Code from db82.BMSChina_staging.dbo.WebChart where charturl = '../Charts/Column2D.swf'
)

-- like %
update Webchartseries set ParentYAxis='P'
where linkchartcode in (
	select distinct Code from db82.BMSChina_staging.dbo.WebChart where charturl = '../Charts/MSLine.swf'
)

update webchartseries set parentyaxis='P' where linkchartcode in ('d084','d088','d094','d104')


update webchartseries
set Remark = case when Series='Eliquis Market' then 'Line' else null end
where LinkChartCode in ('C690','C691')

update webchartseries
set ParentYAxis = case when Series='Eliquis Market' then 'S' else 'P' end
where LinkChartCode in ('C690','C691')


update webchartseries
set Remark = case when Series in ('Eliquis (NOAC) Market','Eliquis (VTEP) Market') then 'Line' else null end
where LinkChartCode in ('C660','C661')

update webchartseries
set ParentYAxis = case when Series in ('Eliquis (NOAC) Market','Eliquis (VTEP) Market')then 'S' else 'P' end
where LinkChartCode in ('C660','C661')


update a 
set a.HighChartSeriesType = 
	case when a.series like '%growth%' or a.series like '%G R%' or a.series like '%share%' then 'line'
		 else 'StackedColumn' end 
from WebChartSeries as a
inner join db82.BMSChina_staging.dbo.WebChart as b on a.LinkChartCode = b.Code
where b.highChartType = 'StackedColumnLineDY'

-------------------------------------
-- WebChartTitle
-------------------------------------
truncate table WebChartTitle
go

insert into WebChartTitle (DataSource,ProductID,GeoID,[LinkChartCode]
	,[Category]
	,[Product]
	,[Lev],ParentGeo
	,[Geo]
	,[Currency]
	,[TimeFrame])
SELECT distinct DataSource,ProductID,GeoID, [LinkChartCode]
	,[Category]
	,[Product]
	,[Lev],ParentGeo
	,[Geo]
	,[Currency]
	,[TimeFrame]
FROM [dbo].[Output] where isshow='Y'
go
insert into WebChartTitle (DataSource,ProductID,GeoID,[LinkChartCode]
	,[Category]
	,[Product]
	,[Lev],ParentGeo
	,[Geo]
	,[Currency]
	,[TimeFrame])
SELECT distinct DataSource, ProductID,GeoID, [LinkChartCode]
	,[Category]
	,[Product]
	,[Lev],ParentGeo
	,[Geo]
	,[Currency]
	,[TimeFrame]
FROM [dbo].[Output] where LinkChartCode IN ('R610','R620','R630','R653','R654','R720','R730')

--Do not need the Units ppt.
--delete from webcharttitle where linkchartcode like 'R402%'
--delete from webcharttitle where linkchartcode like 'R412%' or linkchartcode like 'r502%'
--go
--where LinkChartCode between 'C010' and 'C120' or LinkChartCode like 'D02%' or LinkChartCode like 'D03%' or LinkChartCode like 'D04%'
--or LinkChartCode like 'D08%' or LinkChartCode like 'D09%' or LinkChartCode like 'D10%'
--go


-- select * from WebChartTitle
update WebChartTitle set CategoryIdx = 1 where Category='Value'
update WebChartTitle set CategoryIdx = 2 where Category='Dosing Units'
update WebChartTitle set CategoryIdx = 3 where Category='Adjusted patient number' -- todo
go
update webcharttitle set timeframeidx= 1 where timeframe= 'mat'
update webcharttitle set timeframeidx= 2 where timeframe= 'mqt'
update webcharttitle set timeframeidx= 3 where timeframe= 'ytd'
update webcharttitle set timeframeidx= 4 where timeframe= 'mth'
update webcharttitle set timeframeidx= 5 where timeframe= 'Last Year'
update webcharttitle set timeframeidx= 6 where timeframe= 'MAT Month'
update webcharttitle set timeframeidx= 7 where timeframe= 'MAT Quarter'
update webcharttitle set timeframeidx= 9 where timeframe= 'Quarter'--Sprycel C220
go

select * from webcharttitle where timeframeidx is null
go

update WebChartTitle set PYAxisName=Category+' (in '+ Currency+' Dollar)'
where Currency<>'UNIT'

update WebChartTitle set PYAxisName=Category+' (in Dollar)'
where Currency='UNIT'

update WebChartTitle set PYAxisName=
case when LinkChartCode in('D081','D085','D091','D101') then case Currency when 'UNIT' then Category+' (in Dollar)' else Category+' (in '+ Currency+' Dollar)' end
	when LinkChartCode in ('D082','D086','D092','D102') then 'Market Share %'
	when LinkChartCode in ('D083','D087','D093','D103') then 'Growth %'
	when LinkChartCode in ('D084','D088','D094','D104') then 'SOG %' end 
where (LinkChartCode like 'D08%' or LinkChartCode like 'D09%' or LinkChartCode like 'D10%')

update WebChartTitle set PYAxisName=''
where (LinkChartCode like 'D02%' or LinkChartCode like 'D03%' or LinkChartCode like 'D04%' or linkchartcode in('C140','C141') or LinkChartCode in( 'C900','C660','C690','C661','C691') or LinkChartCode = 'R777' or (Linkchartcode like 'R6%' AND LinkChartCode not in ('R670','R680')))
	or (linkchartcode between 'R400' and 'R520' and linkchartcode not in('R401','R402','R411','R412','R420','R440'))

--update WebChartTitle
--set PYAxisName=replace(PYAxisName,'Dollar',B.Dol)
--from WebChartTitle A inner join dbo.tblDivNumber B
--on A.linkchartcode=B.linkchartcode and A.timeframe=B.period and A.currency=b.Moneytype and A.geo=B.geo
--and A.ParentGeo=B.ParentGeo and A.product=B.product

go
update WebChartTitle
set PYAxisName= case Currency when 'UNIT' then Category+' (in Dollar)' else Category+' (in '+ Currency+' Dollar)' end
where  LinkChartCode='R320'
go
update WebChartTitle
set PYAxisName= case Currency when 'UNIT' then Category+' (in Dollar)' else Category+' (in '+ Currency+' Dollar)' end
where LinkChartCode between 'R010' and 'R110' and 
 (LinkChartCode not like 'R05%' and LinkChartCode not like 'R06%' and LinkChartCode not like 'R07%' and LinkChartCode not like 'R08%')

update WebChartTitle
set PYAxisName=
case when LinkChartCode in('R051','R061','R071','R081') then  
case Currency when 'UNIT' then Category+' (in Dollar)' else Category+' (in '+ Currency+' Dollar)' end
when LinkChartCode in ('R052','R062','R072','R082') then 'Market Share %'
when LinkChartCode in ('R053','R063','R073','R083') then 'Growth %'
when LinkChartCode in ('R054','R064','R074','R084') then 'SOG %' end 
where (LinkChartCode like 'R05%' or LinkChartCode like 'R06%' or LinkChartCode like 'R07%' or LinkChartCode like 'R08%')

update WebChartTitle
set PYAxisName='Market Share %' where linkchartcode in('R120','C130')

update WebChartTitle
set PYAxisName='Growth %' where linkchartcode in('R710')

update WebChartTitle
set PYAxisName=replace(PYAxisName,'Dollar',B.Dol)
from WebChartTitle A 
inner join dbo.tblDivNumber B
on A.linkchartcode=B.linkchartcode and A.timeframe=B.period and A.currency=b.Moneytype and A.geo=B.geo
	and A.ParentGeo=B.ParentGeo and A.product=B.product

go
update WebChartTitle
set PYAxisName=replace(PYAxisName,'Dollar',B.Dol)
from WebChartTitle A 
inner join dbo.tblDivNumber B
on A.linkchartcode=B.linkchartcode and A.timeframe=B.period and A.currency=b.Moneytype and A.geo=B.geo
	and A.ParentGeo=B.ParentGeo and A.product='Onglyza' and B.product='Glucophage'
where A.PYAxisName like '%Dollar%'
--WHERE A.LinkChartCode between 'R010' and 'R120' or A.LinkChartCode='R320'
go
update WebChartTitle
set PYAxisName=rtrim(replace(PYAxisName,'(in )','')) 
where PYAxisName like '%(in )%'
go











--update Caption:

--2013/7/19 16:02:48
--insert into tblcaption
--select 'C150','Taxol','Taxol Performance by region','' union all
--select 'C160','Taxol','Taxol City Performance','Brand Tracking-49 Cities-Market Data' 
--insert into tblcaption
--select 'R010','Taxol','Total Onco Market Trend','China Onco Market Sales from 2008-2012<br/>(IMS Hospital Data Projection)' union all
--select 'R520','Taxol','Top companies in China Onco Market (MNC + Local)','China Onco Market Top 10 Companies + BMS<br/>(IMS Hospital Data Projection)' 
--insert into tblcaption
--select 'R530','','Taxol key hospitals performance.',''

--insert into tblcaption
--select 'R777',null,'Baraclude Performance �CETV volume trend',null


--insert into tblcaption(LinkChartCode,Market,Caption,SubCaption)
--values('R610','Monopril','Monopril  Performance �C City Level','#TimeFrame & #Category')

--insert into tblcaption(LinkChartCode,Market,Caption,SubCaption)
--values('R620','Monopril','Monopril Top City Performance in IMS','#TimeFrame & #Category')

--insert into tblcaption(LinkChartCode,Market,Caption,SubCaption)
--values('R630','Monopril','Monopril Top City Performance in IMS','#TimeFrame & #Category')

--insert into tblcaption(LinkChartCode,Market,Caption,SubCaption)
--values('R640','Monopril','Monopril Performance �C Hospital Level',null)

--insert into tblcaption(LinkChartCode,Market,Caption,SubCaption)
--values('R651','Monopril','Monopril Performance �C National Level','Value Shares(#TimeFrame)')

--insert into tblcaption(LinkChartCode,Market,Caption,SubCaption)
--values('R652','Monopril','Monopril Performance �C National Level','Volume Shares(#TimeFrame)')

--insert into tblcaption(LinkChartCode,Market,Caption,SubCaption)
--values('R653','Monopril','Monopril Performance �C National Level',null)

--insert into tblcaption(LinkChartCode,Market,Caption,SubCaption)
--values('R654','Monopril','Monopril Performance �C National Level',null)

--insert into tblcaption(LinkChartCode,Market,Caption,SubCaption)
--values('C660','Eliquis','Eliquis Market Trend',null)

--insert into tblcaption(LinkChartCode,Market,Caption,SubCaption)
--values('C690','Eliquis','Eliquis Market Trend',null)

--insert into tblcaption(LinkChartCode,Market,Caption,SubCaption)
--values('R670','Eliquis','Eliquis Market Performance by City',null)

--insert into tblcaption(LinkChartCode,Market,Caption,SubCaption)
--values('R680','Eliquis','Eliquis Market Performance by City',null)

--Add C900 caption: Xiaoyu.Chen 2013-08-24
--insert into tblCaption (LinkChartCode,Market,Caption,SubCaption)
--values('C900',null,'Performance by Region',null)

--insert into tblcaption(LinkChartCode,Market,Caption,SubCaption)
--select 'R720',market,Caption,SubCaption from tblCaption where market='coniel' and LinkChartCode='R620'


--insert into tblcaption(LinkChartCode,Market,Caption,SubCaption)
--select 'R730',market,Caption,SubCaption from tblCaption where market='coniel' and LinkChartCode='R630'

declare @TaxolCityNum int
select @TaxolCityNum=count(distinct geo) from outputgeo where lev=2 and product='Taxol'

update tblcaption 
set subcaption='Brand Tracking-'+convert(varchar(3),@TaxolCityNum)+' Cities-Market Data'
where LinkChartCode='c160'

update WebChartTitle set Caption=B.caption 
from WebChartTitle A 
inner join dbo.tblcaption B --todo ����
on A.LinkChartCode=B.LinkChartCode
where B.Market is null


update WebChartTitle set Caption=B.caption 
from WebChartTitle A 
inner join dbo.tblcaption B --todo ����
on A.LinkChartCode=B.LinkChartCode and (A.Product=B.Market or left(A.Product,7)=B.Market)
where B.Market is not null

go

update  WebChartTitle set 
Caption=replace(Caption,'Taxol','Paraplatin')
,SubCaption=replace(SubCaption,'Taxol','Paraplatin')
-- select * from WebChartTitle 
where Product='Paraplatin' and linkchartcode in ('D022','D024')


update  WebChartTitle set 
Caption=replace(Caption,'Taxol','Platinum')
,SubCaption=replace(SubCaption,'Taxol','Paraplatin')
-- select * from WebChartTitle 
where Product='Paraplatin'   and ([Caption] like '%Taxol%' or SubCaption like '%Taxol%')
go


update WebChartTitle set 
YAxisName=replace(YAxisName,'Taxol','Paraplatin')
-- select * from WebChartTitle 
where Product='Paraplatin' and linkchartcode='C160'



update WebChartTitle
set Caption=replace(replace(B.caption,'#Market',Product),'#Category',A.Category),
   SubCaption=replace(B.SubCaption,'#Category',A.Category) 
from WebChartTitle A inner join dbo.tblcaption B
on A.LinkChartCode=B.LinkChartCode and A.Product=B.Market
where B.Market is not null
go


update WebChartTitle
set Caption=replace(replace(B.caption,'#Market',Product),'#Category',A.Category),
   SubCaption=replace(B.SubCaption,'#Category',A.Category) 
from WebChartTitle A inner join dbo.tblcaption B
on A.LinkChartCode=B.LinkChartCode 
where B.Market is  null
go


update WebChartTitle
set Caption=replace(caption,'#Class',case when Product in ('baraclude','Taxol') then 'Molecule' else 'Class' end)
where linkchartcode='R430'
go
update WebChartTitle
set Caption=replace(replace(caption,'#Product',Product),'#Molecule',
    case Product when 'Baraclude' then 'Entecavir' 
                 when 'Glucophage' then 'Metfomin'
				 when 'Monopril' then 'ACEI' 
				 when 'Taxol' then 'Paclitaxel' when 'Paraplatin' then 'Carboplatin' 
				 else Product end
				 )
where linkchartcode in('R511','R512')
go


update WebChartTitle
set Slidetitle='('+Timeframe +' '+(select [MonthEN] from tblMonthList where monseq=1)+', '+category+ case category when 'Dosing Units' then ')' else ' in '+Currency+')' end
go
update WebChartTitle
set Slidetitle='('+Timeframe +' '+(select [Month]+''''+right(year,2) from tblDateHKAPI)+', '+category+ case category when 'Dosing Units' then ')' else ' in '+Currency+')' end
where linkchartcode  in ('R320','C210','C220') or (linkchartcode in('C100','C110') and timeframe='YTD')
go

--todo
update WebChartTitle
set Slidetitle='(Year 2015, '+category+ case category when 'Dosing Units' then ')' else ' in '+Currency+')' end
where linkchartcode in('C100','C110') and timeframe='Last Year'
go


update WebChartTitle
set Caption=replace(replace(B.caption,'#Region',A.geo),'#City',A.geo),
    SubCaption=replace(replace(B.SubCaption,'#TimeFrame',A.Slidetitle),'#Category',A.Category) from WebChartTitle A inner join dbo.tblcaption
B
on A.LinkChartCode=B.LinkChartCode and A.product=B.Market
go
update WebChartTitle
set SubCaption=replace(B.SubCaption,'#Month',A.[Month])
from WebChartTitle B,tblMonthList A where Monseq=1 and B.SubCaption like '%#Month%'
go
update WebChartTitle
set Slidetitle=replace(Slidetitle,'(','(MQT/')
where (linkchartcode like 'D02%' or linkchartcode like 'D03%' or linkchartcode like 'D04%')
and Slidetitle not like '%MQT%'
go
update WebChartTitle
set Slidetitle=replace(Slidetitle,')','+Dosing Units)')
where linkchartcode in ('R401','R411','R501','R502') and Product<>'Paraplatin'
go
update WebChartTitle
set Slidetitle=replace(Slidetitle,')','+Adjusted patient number)')
where linkchartcode in ('R401','R411','R501','R502') and Product='Paraplatin'
go


declare @TaxolCityNum varchar(3)
select @TaxolCityNum=convert(varchar(3),count(distinct geo)) from outputgeo where lev=2 and product='Taxol'
--print @TaxolCityNum

update WebChartTitle
set SubCaption=replace(SubCaption,@TaxolCityNum,B.CityNum)
from WebChartTitle A 
inner join (
select ParentGeo,cast(count(distinct Geo) as nvarchar(10))  CityNum
from dbo.outputgeo where lev=2 and Product='taxol'
group by ParentGeo
) B
on A.Geo=B.ParentGeo
where  A.LinkChartCode ='C160'
go
--todo
update WebChartTitle set SYAxisName='Growth %'
where linkchartcode in (select code from db82.BMSChina_staging.dbo.Webchart where snumbersuffix='%')
go
update WebChartTitle
set SYAxisName='Market Growth %' where LinkChartCode IN ('C120','C121')
go
update WebChartTitle
set SYAxisName='Market Growth %' where LinkChartCode='R100' and Product='Glucophage'
go
update WebChartTitle
set SYAxisName='Growth %' where LinkChartCode between 'R010' and 'R120' or LinkChartCode IN ('R320','R670')

update WebChartTitle
set SYAxisName='' where LinkChartCode IN('R680','C660','C690','C661','C691')

update webcharttitle
set YAxisName=PYAxisName where linkchartcode in 
(select distinct Code from db82.BMSChina_staging.dbo.Webchart 
where ChartURL in('../Charts/Column2D.swf','../Charts/MSColumn2D.swf','../Charts/MSLine.swf','../Charts/StackedColumn3D.swf'))

update WebChartTitle
set subcaption=TimeFrame+' '+case Currency when 'Unit' then 'Volume' else 'Sales' end+' in '+
B.Dollar+' ('+Currency+')'
 from WebChartTitle A inner join dbo.tblDivNumber B
on A.linkchartcode=B.linkchartcode and A.timeframe=B.period and A.currency=b.Moneytype and A.geo=B.geo
and A.ParentGeo=B.ParentGeo and A.product=B.product
 where (A.LinkChartCode between 'R010' and 'R040' or
A.LinkChartCode between 'R080' and 'R120'  or A.LinkChartCode='R320') and (A.subcaption='' or A.subcaption is null)
go
update WebChartTitle
set subcaption=case TimeFrame when 'Qtr' then 'Quarterly' else TimeFrame end +' Market Share'
 from WebChartTitle A 
 where (A.LinkChartCode ='R120') and (A.subcaption='' or subcaption is null)
go
update WebChartTitle
set Caption=replace(Caption,'Pearl River Delta','PRD') where Caption like '%Pearl River Delta%'  
go



update WebChartTitle set ProductID=28 
where linkchartcode like 'R%' and Product='Paraplatin'

update WebChartTitle set ProductID=25  
where linkchartcode like 'R%' and Product='taxol'


update WebChartTitle set 
YAxisName='Sales: Bn  ' + t1.Currency
,PYAxisName='Sales: Bn  ' + t1.Currency
,SYAxisName=null
from WebChartTitle t1 
where t1.linkchartcode like 'R01%' and t1.Product='Taxol'







update  WebChartTitle set 
Caption=replace(Caption,'Taxol','Paraplatin')
,SubCaption=replace(SubCaption,'Taxol','Paraplatin')
-- select * from WebChartTitle 
where Product='Paraplatin' and linkchartcode in ('D022','D024')


update  WebChartTitle set 
Caption=replace(Caption,'Taxol','Platinum')
,SubCaption=replace(SubCaption,'Taxol','Paraplatin')
-- select * from WebChartTitle 
where Product='Paraplatin'   and ([Caption] like '%Taxol%' or SubCaption like '%Taxol%')


update WebChartTitle set 
Caption=replace(Caption,'Paraplatin Market','Platinum Market')
-- select * from WebChartTitle 
where Product='Paraplatin'   


update WebChartTitle set 
Caption=replace(Caption,'Platinum','Paraplatin')
where linkchartcode in ('C150','C160') and Product='Paraplatin'




delete from WebChartTitle  
where linkchartcode like 'D02%' and Product <> 'Baraclude' and TimeFrame = 'MTH'
go

update WebChartTitle set TimeFrameidx=
case TimeFrame when 'MTH' then 1
               when 'MQT' then 2
               when 'MAT' then 3
               when 'YTD' then 4 end 
where linkchartcode  like 'D02%' and Product ='Baraclude'

update WebChartTitle set 
SubCaption = replace(SubCaption,'MQT','MTH')
where linkchartcode  like 'D02%' and Product = 'Baraclude' and TimeFrame='MTH'
go
update WebChartTitle set 
caption = replace (caption,'value','Market')
where linkchartcode in ('C120','C121') and category='value' and product <> 'Paraplatin'
go
update WebChartTitle set 
caption = replace (caption,'Eliquis VTEP','Eliquis (VTEP)')
where linkchartcode in ('C130','C140') and  product ='Eliquis VTEP'

update WebChartTitle set 
PYAxisName='Market Share %'
where linkchartcode in ('C131')
update WebChartTitle set 
YAxisName='Market Share %'
where linkchartcode in ('C131')

update WebChartTitle set 
PYAxisName=''
where linkchartcode in ('C141')