use BMSChina_ppt_test--172.20.0.82
go












--*********************************************************
--Predefined reports Hospital
--*********************************************************
delete -- select * from
BMSChina_ppt_test.dbo.Output_PPT 
where left(LinkChartCode,1) = 'R' and cast(Right(LinkChartCode,3) as int) between 340 and 369

delete -- select * from
BMSChina_ppt_test.dbo.Output_PPT 
where left(LinkChartCode,1) = 'R' and cast(Right(LinkChartCode,3) as int) between 661 and 668
go

insert into BMSChina_ppt_test.dbo.Output_PPT (DataSource,LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters,  IsShow, Color)
select 'RX', LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, 
	Currency, TimeFrame, X, XIdx, 
	cast(cast(Y as decimal(22,12)) as varchar), 
	LinkedY, 
	Size, OtherParameters,  IsShow, Color
from db4.BMSChinaMRBI.dbo.OutputRx 
where left(LinkChartCode,1) = 'R' and Right(LinkChartCode,3) between '340' and '369'

--Eliquis Market
insert into BMSChina_ppt_test.dbo.Output_PPT (DataSource,LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters,  IsShow, Color)
select 'RX', LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, 
	Currency, TimeFrame, X, XIdx, 
	cast(cast(Y as decimal(22,12)) as varchar), 
	LinkedY, 
	Size, OtherParameters,  IsShow, Color
from db4.BMSChinaMRBI.dbo.OutputRx 
where left(LinkChartCode,1) = 'R' and Right(LinkChartCode,3) between '661' and '668'
go

update BMSChina_ppt_test.dbo.Output_PPT set 
	r=b.r,
	g=b.g,
	b=b.b 
from BMSChina_ppt_test.dbo.Output_PPT A 
inner join  BMSChina_ppt_test.dbo.tblRGBToColor B on A.color=b.rgb 
where A.r is null
	and left(LinkChartCode,1) = 'R'
	and Right(LinkChartCode,3) between '340' and '369'
go


delete BMSChina_ppt_test.dbo.tblChartTitle where left(LinkChartCode,1) = 'R'
and Right(LinkChartCode,3) between '340' and '369'

delete BMSChina_ppt_test.dbo.tblChartTitle where left(LinkChartCode,1) = 'R'
and Right(LinkChartCode,3) between '661' and '668'
go

insert into BMSChina_ppt_test.dbo.tblChartTitle (DataSource,LinkChartCode, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame,Caption,SlideTitle)
select distinct 'RX', LinkChartCode, Category,Product, Lev, ParentGeo, Geo, Currency,TimeFrame,
	case 

	when LinkChartCode in ('R341','R342') then 
	case Product 
		when 'Onglyza'		then 'Hospital Department NIAD Class Rx Performance' 
		when 'Glucophage'	then 'Hospital Department NIAD Class Rx Performance' 
		when 'Monopril'		then 'Hospital Department Hypertension Class Rx Performance' 
		When 'Baraclude'	then 'Hospital Department HBV Rx Performance' 
		when 'Taxol'		then 'Hospital Department Oncology Rx Performance' 
	end

	when LinkChartCode in('R351','R352') then 
	case Product 
		when 'Onglyza'		then 'Hospital Department NIAD Brand Rx Performance' 
		when 'Glucophage'	then 'Hospital Department NIAD Brand Rx Performance' 
		when 'Monopril'		then 'Hospital Department Monopril Market Brand Rx Performance' 
		When 'Baraclude'	then 'Hospital Department ARV Brand Rx Performance' 
		when 'Taxol'		then 'Hospital Department Taxol Market Brand Rx Performance' 
		when 'Paraplatin'		then 'Hospital Department Platinum Market Brand Rx Performance' 
		when 'Coniel'		then 'Hospital Department Coniel Market Brand Rx Performance' 
	end 
	
	end,
	'(' + TimeFrame + ', Rx)' as SlideTitle
from db4.BMSChinaMRBI.dbo.OutputRx 
where left(LinkChartCode,1) = 'R' 
	and Right(LinkChartCode,3) between '340' and '369'
	and IsShow = 'Y'
	
	

insert into BMSChina_ppt_test.dbo.tblChartTitle (DataSource,LinkChartCode, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame,Caption,SlideTitle,SubCaption)
select distinct 'RX', LinkChartCode, Category,Product, Lev, ParentGeo, Geo, Currency,TimeFrame,
	case 	
	when LinkChartCode like 'R66%' and product='Eliquis' then 'Dept allocation of key brands'
	end as Caption,
	'(' + TimeFrame + ', Rx)' as SlideTitle,X as SubCaption
from db4.BMSChinaMRBI.dbo.OutputRx 
where left(LinkChartCode,1) = 'R' 
	and Right(LinkChartCode,3) between '661' and '668'
	and IsShow = 'Y'	
go






print 'over!'