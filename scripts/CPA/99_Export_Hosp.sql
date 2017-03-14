

--1.导出数据到BMSChina_ppt_test数据库中

--2.对于数据在Web或者PPT中显示，进行了一些必要的格式化（设置Chart的标题，设置Chart的Y轴的标题，设置Chart类型等）



use BMSChina_ppt_test--82
go

--Time:00:19







--log
insert into Logs 
select 'CPA' as [项目], '3_2_Export_Output.sql' as [处理内容], 'start' as [标示], getdate() as [时间] 
go





--R530
delete from Output_PPT where LinkChartCode like 'R53%'
go
insert into Output_PPT (DataSource,LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters,  IsShow, Color)
select 'CPA',
	LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency
	, TimeFrame, X, XIdx, cast(cast(Y as decimal(22,12)) as varchar), LinkedY, Size, OtherParameters,  IsShow,Color
from DB4.BMSChinaMRBI.dbo.OutputHospital 
where LinkChartCode like 'R53%'
go

delete dbo.tblChartTitle where LinkChartCode like 'R53%'
go
insert into tblChartTitle (DataSource,LinkChartCode, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, Caption,SubCaption,SlideTitle,PYAxisName,SYAxisName)
select distinct 'CPA',
		LinkChartCode, Category,Product, Lev, ParentGeo,Geo, Currency,a.TimeFrame
	, 'Taxol key hospitals performance' as Caption
	,'' as Subcaption
	, '(' + isnull(b.TFValue, a.TimeFrame) + ', ' + Category + case when Currency = 'Unit' then'' else ' in ' + Currency end +')'
	, Category PYAxisName
	,null SYAxisName
from Output_PPT a
left join DB4.BMSChinaMRBI.dbo.tblTimeFrame b 
on b.DataSource = 'CPA' and a.TimeFrame = b.TimeFrame
where LinkChartCode like 'R53%'
go
update tblChartTitle set parentcode=LinkChartCode
where LinkChartCode like  'R53%'

-- Sprycel data
delete from Output_PPT where LinkChartCode = 'C202'
go
insert into Output_PPT (DataSource,LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters,  IsShow, Color)
select 'CPA',
	LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency
	, TimeFrame, X, XIdx, cast(cast(Y as decimal(22,12)) as varchar), LinkedY, Size, OtherParameters,  IsShow,Color
from DB4.BMSChinaMRBI.dbo.OutputHospital 
where LinkChartCode ='C202'
go

delete dbo.tblChartTitle where LinkChartCode = 'C202'
go
insert into tblChartTitle (DataSource,LinkChartCode, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, Caption,SubCaption,SlideTitle,PYAxisName,SYAxisName)
select distinct 'CPA',
		LinkChartCode, Category,Product, Lev, ParentGeo,Geo, Currency,a.TimeFrame
	, 'Sprycel Market Trend' as Caption,'Tier III Hospitals - CPA/Sea Rainbow Data' as Subcaption
	, '(' + isnull(b.TFValue, a.TimeFrame) + ', ' + Category + case when Currency = 'Unit' then'' else ' in ' + Currency end +')'
	, Category PYAxisName,null SYAxisName
from Output_PPT a
left join DB4.BMSChinaMRBI.dbo.tblTimeFrame b 
on b.DataSource = 'CPA' and a.TimeFrame = b.TimeFrame
where LinkChartCode = 'C202'
go



delete from Output_PPT where LinkChartCode in ('D050','D051','D060','D110','D111','D130','D150')
go
insert into Output_PPT (DataSource,LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters,  IsShow, Color)
select 'CPA',
	LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, 
	X, XIdx, cast(cast(Y as decimal(22,12)) as varchar), LinkedY, Size, OtherParameters,  IsShow,Color
from DB4.BMSChinaMRBI.dbo.OutputHospital 
where LinkChartCode in ('D050','D051','D060','D110','D111','D130','D150')
go

-- Chart Title: D110, D130, D150, D050
delete dbo.tblChartTitle where LinkChartCode in('D050','D051','D060')
go
insert into tblChartTitle (DataSource,LinkChartCode, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, Caption,SlideTitle,PYAxisName,SYAxisName)
select distinct 'CPA', LinkChartCode, Category,Product, Lev, ParentGeo,Geo, Currency,a.TimeFrame, 
	Geo + case Product 
			when 'Baraclude'	then ' Top 10 Hospital ARV Market Performance'
			when 'Onglyza'		then ' Top 10 Hospital NIAD Market Performance'
			when 'Glucophage'	then ' Top 10 Hospital NIAD Market Performance'
			when 'Taxol'		then ' Top 10 Hospital Taxol Market Performance'
			when 'Monopril'		then ' Top 10 Hospital Monopril Market Performance'
			when 'Coniel'		then ' Top 10 Hospital Coniel Market Performance'
			when 'Paraplatin'	then ' Top 10 Hospital Paraplatin Market Performance'
			when 'Eliquis VTEP'	then ' Top 10 Hospital Eliquis (VTEP) Market Performance'
			when 'Eliquis NOAC'	then ' Top 10 Hospital Eliquis (NOAC) Market Performance'		
		end as Caption,
	'(' + isnull(b.TFValue, a.TimeFrame) + ', ' + Category + case when Currency = 'Unit' then'' else ' in ' + Currency end +')',
	Category PYAxisName,
	'Growth %' SYAxisName
from Output_PPT a
left join DB4.BMSChinaMRBI.dbo.tblTimeFrame b on b.DataSource = 'CPA' and a.TimeFrame = b.TimeFrame
where LinkChartCode in('D050','D051')
go

insert into tblChartTitle (DataSource,LinkChartCode, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, Caption,SlideTitle,PYAxisName,SYAxisName)
select distinct 'CPA', LinkChartCode, Category,Product, Lev, ParentGeo,Geo, Currency,a.TimeFrame, 
	Geo + ' Top 10 Hospital DPP-IV Performance' AS Caption,
	'(' + isnull(b.TFValue, a.TimeFrame) + ', ' + Category + case when Currency = 'Unit' then'' else ' in ' + Currency end +')',
	Category PYAxisName,
	'Growth %' SYAxisName
from DB4.BMSChinaMRBI.dbo.OutputHospital a
left join DB4.BMSChinaMRBI.dbo.tblTimeFrame b on b.DataSource = 'CPA' and a.TimeFrame = b.TimeFrame
where LinkChartCode = 'D060'
go

-- title D110
delete tblChartTitle where LinkChartCode in( 'D110','D111')
go
insert into tblChartTitle (DataSource,LinkChartCode, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, Caption,SlideTitle,PYAxisName,SYAxisName)
select distinct 'CPA', LinkChartCode, Category,Product, Lev, ParentGeo, Geo, Currency,a.TimeFrame, 
	case Product 
		when 'Baraclude'	then 'ARV Market Hospital Performance'
		when 'Glucophage'	then 'NIAD Market Hospital Performance'
		when 'Taxol'		then 'Taxol Market Hospital Performance'
		when 'Monopril'		then 'Monopril Market Hospital Performance' 
		when 'Coniel'		then 'Coniel Market Hospital Performance' 
		when 'Eliquis VTEP'		then 'Eliquis (VTEP) Market Hospital Performance' 
		when 'Eliquis NOAC'		then 'Eliquis (NOAC) Market Hospital Performance' 		
		when 'Onglyza'		then 'DPP-IV Hospital Performance'
		when 'Paraplatin' then 'Platinum Market Hospital Performance'
	end + ': ' + Geo as Caption,
	'(' + isnull(b.TFValue, a.TimeFrame) + ', ' + Category + case when Currency = 'Unit' then'' else ' in ' + Currency end +')',
	Category PYAxisName,
	'Growth %' SYAxisName
from Output_PPT a
left join DB4.BMSChinaMRBI.dbo.tblTimeFrame b on b.DataSource = 'CPA' and a.TimeFrame = b.TimeFrame
where LinkChartCode in( 'D110','D111')
go

-- title D130
delete tblChartTitle where LinkChartCode = 'D130'
go
insert into tblChartTitle (DataSource,LinkChartCode, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, Caption,SlideTitle,PYAxisName)
select distinct 'CPA',LinkChartCode, Category,Product, Lev, ParentGeo, Geo, Currency,a.TimeFrame, 
	case Product 
	   when 'Baraclude' then 'Baraclude Hospital Performance'
		 when 'Glucophage' then 'Glucophage Hospital Performance'
		 when 'Taxol' then 'Taxol Hospital Performance'
		 when 'Monopril' then 'Monopril Hospital Performance' 
		 when 'Coniel' then 'Coniel Hospital Performance' 
		 when 'Onglyza' then 'Onglyza Hospital Performance'
		 when 'Paraplatin' then 'Paraplatin Hospital Performance'
	end + ': ' + Geo as Caption,
	'(' + isnull(b.TFValue, a.TimeFrame) + ', ' + Category + case when Currency = 'Unit' then'' else ' in ' + Currency end +')',
	case Product when 'Onglyza' then 'NIAD ' else '' end + 'Market Share %' PYAxisName
from Output_PPT  a
left join DB4.BMSChinaMRBI.dbo.tblTimeFrame b on b.DataSource = 'CPA' and a.TimeFrame = b.TimeFrame
where LinkChartCode = 'D130'
go

-- title D150
delete tblChartTitle where LinkChartCode = 'D150'
go
insert into tblChartTitle (DataSource,LinkChartCode, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, Caption,SlideTitle,PYAxisName)
select distinct 'CPA', LinkChartCode, Category,Product, Lev, ParentGeo, Geo, Currency,b.TimeFrame, 
	case Product when 'Baraclude' then 'Baraclude Hospital Performance'
		 when 'Glucophage' then 'Glucophage Hospital Performance'
		 when 'Taxol' then 'Taxol Hospital Performance'
		 when 'Monopril' then 'Monopril Hospital Performance' 
		 when 'Coniel' then 'Coniel Hospital Performance' 
		 when 'Onglyza' then 'Onglyza Hospital Performance'
         when 'Paraplatin' then 'Paraplatin Hospital Performance'
	end + ': ' + Geo as Caption,
	'(' + isnull(b.TFValue, a.TimeFrame) + ', ' + Category + case when Currency = 'Unit' then'' else ' in ' + Currency end +')',
	case Product when 'Onglyza' then 'NIAD ' else '' end + 'Market Share %' PYAxisName
from Output_PPT a
left join DB4.BMSChinaMRBI.dbo.tblTimeFrame b on b.DataSource = 'CPA' and a.TimeFrame = b.TimeFrame
where LinkChartCode = 'D150'
go



update Output_PPT 
set 
	r=b.r,
	g=b.g,
	b=b.b 
from Output_PPT A 
inner join tblRGBToColor B on A.color=b.rgb 
where A.r is null
	and  a.LinkChartCode in('D150','D130','D110','D111','D050','D051','D060')
go

-- Set the title of Y Axis
-- select * from tblHospDivNumber
update tblChartTitle 
set 
	PYAxisName= a.Category + ' (' + 
	case when b.Dol is null then '' else 'in ' end + 
	a.currency + 
	case when b.Dol is null then '' else ' '+ b.Dol end + ')'
from tblChartTitle A 
left join DB4.BMSChinaMRBI.dbo.tblHospDivNumber B on 
	a.Product = b.Product
	and a.Category = b.Category
	and a.timeFrame = b.TimeFrame
	and a.Currency = b.Currency
	and a.parentGeo = b.ParentGeo
	and a.Geo = b.Geo
	and a.LinkChartcode = b.LinkChartCode
where (a.LinkChartCode in('C202','D110','D111','D050','D051','D060') and a.category = 'Value')
go

update tblChartTitle 
set 
	PYAxisName= a.Category + case when b.dol is null then '' else ' (in ' + b.Dol + ')' end
from tblChartTitle A 
left join DB4.BMSChinaMRBI.dbo.tblHospDivNumber B on 
	a.Product = b.Product
	and a.Category = b.Category
	and a.timeFrame = b.TimeFrame
	and a.Currency = b.Currency
	and a.parentGeo = b.ParentGeo
	and a.Geo = b.Geo
	and a.LinkChartcode = b.LinkChartCode
where a.LinkChartCode in('C202','D110','D111','D050','D051','D060') and a.category <> 'Value' -- a.category = 'Dosing Units'
go




--*********************************************************
--Predefined reports Hospital
--*********************************************************
----------------------------------
--	CIA-CV Modification: Slide 8 Xiaoyu.chen 20130905
----------------------------------


delete from BMSChina_ppt_test.dbo.Output_PPT where LinkchartCode = 'R640' and Product in ('Monopril','Coniel','Eliquis VTEP')
insert into  BMSChina_ppt_test.dbo.Output_PPT (DataSource,LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, 
	Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters,  IsShow,Color)
select 'CPA', LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo,  Currency, TimeFrame, 
	X, XIdx, cast(cast(Y as decimal(22,12)) as varchar), LinkedY, Size, OtherParameters,  IsShow,Color
from DB4.bmschinamrbi.dbo.OutputHospital
where  LinkchartCode = 'R640' and Product in ('Monopril','Coniel','Eliquis VTEP')

delete from BMSChina_ppt_test.dbo.tblChartTitle where LinkchartCode='R640' and Product in ('Monopril','Coniel','Eliquis VTEP')
insert into BMSChina_ppt_test.dbo.tblChartTitle (DataSource,LinkChartCode, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame,Caption,SlideTitle)
select distinct 'CPA', LinkChartCode, Category,Product, Lev, ParentGeo, Geo, Currency,a.TimeFrame,
case when product='Monopril' then 'Monopril Performance – Hospital Level' 
	 when product='Coniel' then 'Coniel Performance – Hospital Level'
	 when product='Eliquis VTEP' then 'Eliquis VTEP Performance – Hospital Level' end as Caption,
'('  + (select TFValue from DB4.bmschinamrbi.dbo.tblTimeFrame where DataSource = 'CPA' and TimeFrame = 'ytd') + ', ' + Category + case when Currency = 'Unit' then'' else ' in ' + Currency end +')' as SlideTitle
from BMSChina_ppt_test.dbo.Output_PPT a where LinkchartCode='R640' and Product in ('Monopril','Coniel','Eliquis VTEP')

-- data
delete 
from BMSChina_ppt_test.dbo.Output_PPT 
where left(LinkChartCode,1) = 'R' 
	and (right(LinkChartCode,3) between '150' and '309'  or right(LinkChartCode,3) between '900' and '999')
go

insert into BMSChina_ppt_test.dbo.Output_PPT (DataSource,LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, 
	Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters,  IsShow,Color)
select 'CPA',LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo,  Currency, TimeFrame, 
	X, XIdx, cast(cast(Y as decimal(22,12)) as varchar), LinkedY, Size, OtherParameters,  IsShow,Color
from DB4.bmschinamrbi.dbo.OutputHospital 
where left(LinkChartCode,1) = 'R'
	and (right(LinkChartCode,3) between '150' and '309'  or right(LinkChartCode,3) between '900' and '999')
go


-- title 150-180
delete BMSChina_ppt_test.dbo.tblChartTitle 
where left(LinkChartCode,1) = 'R'
	and (right(LinkChartCode,3) between '150' and '189')
go

insert into BMSChina_ppt_test.dbo.tblChartTitle (DataSource,LinkChartCode, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame,Caption,SlideTitle)
select distinct 'CPA', LinkChartCode, Category,Product, Lev, ParentGeo, Geo, Currency,a.TimeFrame,
	case 
		when LinkChartCode like 'R15%' then case Product
		when 'Glucophage' then 'Diabetes Market' 
		when 'Monopril' then 'Hypertension Class' 
		When 'Baraclude' then 'HBV' 
		when 'Taxol' then 'Oncology'
		when 'Paraplatin' then 'Platinum' end + ' Performance by Hospital Tier'

		when LinkChartCode like 'R16%' then 'NIAD Class Performance by Hospital Tier'
		when LinkChartCode like 'R17%' then case Product 
		when 'Onglyza' then 'NIAD Brand' 
		when 'Glucophage' then 'NIAD Brand' 
		when 'Monopril' then 'Monopril Market Brand' 
		when 'Coniel' then 'Coniel Market Brand' 
		When 'Baraclude' then 'ARV Brand' 
		when 'Taxol' then 'Taxol Market'
		when 'Paraplatin' then 'Platinum Market' end + ' Performance by Hospital Tier'
		when LinkChartCode like 'R18%' then case Product 
		when 'Onglyza' then 'DPP-IV Brand' 
		when 'Monopril' then 'ACEI Class Brand' end + ' Performance by Hospital Tier' 
	end,
	'(' + isnull(b.TFValue, a.TimeFrame) + ', ' + Category + case when Currency = 'Unit' then'' else ' in ' + Currency end +')'
from Output_PPT a
left join DB4.bmschinamrbi.dbo.tblTimeFrame b on b.DataSource = 'CPA' and a.TimeFrame = b.TimeFrame
where left(LinkChartCode,1) = 'R' 
	and (right(LinkChartCode,3) between '150' and '189')
	and IsShow = 'Y'
go

-- title 190--300,900,960,91,97,92,98,93,99
delete BMSChina_ppt_test.dbo.tblChartTitle 
where left(LinkChartCode,1) = 'R'
	and (right(LinkChartCode,3) between '190' and '309'  or right(LinkChartCode,3) between '900' and '999')
go

insert into BMSChina_ppt_test.dbo.tblChartTitle (DataSource,LinkChartCode, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame,Caption,SlideTitle)
select distinct 'CPA', LinkChartCode, Category,Product, Lev, ParentGeo, Geo, Currency,a.TimeFrame,
	case 
	when LinkChartCode in ('R191','R192') then 
		case Product 
			when 'Onglyza'		then 'Top Diabetes Market Tier 3 Hospital Performance by Brand (NIAD)' 
			when 'Glucophage'	then 'Top Diabetes Market Tier 3 Hospital Performance by Brand' 
			when 'Monopril'		then 'Top Monopril Market Tier 3 Hospital Performance by Brand' 
			when 'Coniel'		then 'Top Coniel Market Tier 3 Hospital Performance by Brand' 
			When 'Baraclude'	then 'Top HBV Market Tier 3 Hospital Performance by Brand' 
			when 'Taxol'		then 'Top Oncology Market Tier 3 Hospital Performance by Brand' 
			when 'Paraplatin'	then 'Top Platinum Market Tier 3 Hospital Performance by Brand' 
		end

	when LinkChartCode in ('R251','R252') then 
		case Product 
			when 'Onglyza'		then 'Top Diabetes Market Tier 2 Hospital Performance by Brand (NIAD)' 
			when 'Glucophage'	then 'Top Diabetes Market Tier 2 Hospital Performance by Brand' 
			when 'Monopril'		then 'Top Monopril Market Tier 2 Hospital Performance by Brand' 
			when 'Coniel'		then 'Top Coniel Market Tier 2 Hospital Performance by Brand' 
			When 'Baraclude'	then 'Top HBV Market Tier 2 Hospital Performance by Brand' 
			when 'Taxol'		then 'Top Oncology Market Tier 2 Hospital Performance by Brand' 
			when 'Paraplatin'		then 'Top Platinum Market Tier 2 Hospital Performance by Brand' 
		end 
	
	
	when LinkChartCode in('R201','R202') then 
		case Product 
			when 'Onglyza'		then 'Top NIAD Market Tier 3 Hospital Performance by Class' 
			when 'Glucophage'	then 'Top NIAD Market Tier 3 Hospital Performance by Class' 
			when 'Monopril'		then 'Top Hypertension Market Tier 3 Hospital Performance by Class' 
			When 'Baraclude'	then 'Top HBV Market Tier 3 Hospital Performance by Class' 
			when 'Taxol'		then 'Top Oncology Market Tier 3 Hospital Performance by Class' 
			when 'Paraplatin'		then 'Top Platinum Market Tier 3 Hospital Performance by Class' 
		end 
	
	when LinkChartCode in('R261','R262') then 
		case Product 
			when 'Onglyza'		then 'Top NIAD Market Tier 2 Hospital Performance by Class' 
			when 'Glucophage'	then 'Top NIAD Market Tier 2 Hospital Performance by Class' 
			when 'Monopril'		then 'Top Hypertension Market Tier 2 Hospital Performance by Class' 
			When 'Baraclude'	then 'Top HBV Market Tier 2 Hospital Performance by Class' 
			when 'Taxol'		then 'Top Oncology Market Tier 2 Hospital Performance by Class' 
			when 'Paraplatin'		then 'Top Platinum Market Tier 2 Hospital Performance by Class' 
		end 


	-- 'NIAD','ACE','ARV','ONCFCS'
	when LinkChartCode in('R211','R212') then 
		case Product 
			when 'Onglyza'		then 'Top NIAD Tier 3 Hospital Performance by Brand (NIAD)'
			when 'Glucophage'	then 'Top NIAD Tier 3 Hospital Performance by Brand'
			when 'Monopril'		then 'Top ACEI Tier 3 Hospital Performance by Brand' 
			When 'Baraclude'	then 'Top ARV Tier 3 Hospital Performance by Brand' 
			when 'Taxol'		then 'Top Taxol Market Tier 3 Hospital Performance by Brand' 
			when 'Paraplatin'		then 'Top Paraplatin Market Tier 3 Hospital Performance by Brand' 
		end
	
	when LinkChartCode in('R271','R272') then 
		case Product 
			when 'Onglyza'		then 'Top NIAD Tier 2 Hospital Performance by Brand (NIAD)'
			when 'Glucophage'	then 'Top NIAD Tier 2 Hospital Performance by Brand'
			when 'Monopril'		then 'Top ACEI Tier 2 Hospital Performance by Brand' 
			When 'Baraclude'	then 'Top ARV Tier 2 Hospital Performance by Brand' 
			when 'Taxol'		then 'Top Taxol Market Tier 2 Hospital Performance by Brand' 
			when 'Paraplatin'		then 'Top Paraplatin Market Tier 2 Hospital Performance by Brand' 
		end
	
	-- DPP-4 ONLY
	when LinkChartCode IN('R221','R222') then 'Top DPP-IV Tier 3 Hospital Performance'

	when LinkChartCode IN('R281','R282') then 'Top DPP-IV Tier 2 Hospital Performance'
	
	
	-- Glocuphage/Baraclude/Taxol/Monopril
	when LinkChartCode in('R231','R232') then
		case Product 
			when 'Onglyza'		then 'Top Onglyza Tier 3 Hospital Performance (NIAD)'
			when 'Glucophage'	then 'Top Glucophage Tier 3 Hospital Performance'
			when 'Monopril'		then 'Top Monopril Tier 3 Hospital Performance' 
			when 'Coniel'		then 'Top Coniel Tier 3 Hospital Performance' 
			When 'Baraclude'	then 'Top Baraclude Tier 3 Hospital Performance' 
			when 'Taxol'		then 'Top Taxol Tier 3 Hospital Performance' 
			when 'Paraplatin'		then 'Top Paraplatin Tier 3 Hospital Performance' 
		end
	
	when LinkChartCode in('R291','R292') then
		case Product 
			when 'Onglyza'		then 'Top Onglyza Tier 2 Hospital Performance (NIAD)'
			when 'Glucophage'	then 'Top Glucophage Tier 2 Hospital Performance'
			when 'Monopril'		then 'Top Monopril Tier 2 Hospital Performance' 
			when 'Coniel'		then 'Top Coniel Tier 2 Hospital Performance' 
			When 'Baraclude'	then 'Top Baraclude Tier 2 Hospital Performance' 
			when 'Taxol'		then 'Top Taxol Tier 2 Hospital Performance' 
			when 'Paraplatin'		then 'Top Paraplatin Tier 2 Hospital Performance' 
		end
	
	
	-- ONGLYZA ONLY 
	-- not available
	when LinkChartCode='R241' then 'Top Onglyza Tier 3 Hospital Performance'
	when LinkChartCode='R242' then 'Top Onglyza Tier 3 Hospital Performance'
	when LinkChartCode='R301' then 'Top Onglyza Tier 2 Hospital Performance'
	when LinkChartCode='R302' then 'Top Onglyza Tier 2 Hospital Performance'
	
	
	when LinkChartCode in('R901','R902') then 'Top Hypertension Tier 3 Hospital Performance by Class'
	when LinkChartCode IN('R961','R962') then 'Top Hypertension Tier 2 Hospital Performance by Class'
	
	When LinkChartCode in('R911','R912') then 'Top Diabetes Market Tier 3 Hospital Performance by Brand (DPP-IV)'
	When LinkChartCode in('R971','R972') then 'Top Diabetes Market Tier 2 Hospital Performance by Brand (DPP-IV)'

	When LinkChartCode in('R921','R922') then 'Top NIAD Tier 3 Hospital Performance by Brand (DPP-IV)'
	When LinkChartCode in('R981','R982') then 'Top NIAD Tier 2 Hospital Performance by Brand (DPP-IV)'

	When LinkChartCode in('R931','R932') then 'Top Onglyza Tier 3 Hospital Performance (DPP-IV)'
	When LinkChartCode in('R991','R992') then 'Top Onglyza Tier 2 Hospital Performance (DPP-IV)'

	end,
	
	-- select TFValue from tblTimeFrame where DataSource = 'CPA' and TimeFrame = 'mqt'
	'(' + a.TimeFrame + '/' + (select TFValue from DB4.bmschinamrbi.dbo.tblTimeFrame where DataSource = 'CPA' and TimeFrame = 'mqt') + ', ' + Category + case when Currency = 'Unit' then'' else ' in ' + Currency end +')'

from Output_PPT a
where left(LinkChartCode,1) = 'R' 
	and (right(LinkChartCode,3) between '190' and '309'  or right(LinkChartCode,3) between '900' and '999')
	and IsShow = 'Y' and right(LinkChartCode,1) = '1'
go

insert into BMSChina_ppt_test.dbo.tblChartTitle (DataSource,LinkChartCode, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame,Caption,SlideTitle)
select distinct 'CPA', LinkChartCode, Category,Product, Lev, ParentGeo, Geo, Currency,case a.TimeFrame when 'MQT' then 'MAT' else a.TimeFrame end as TimeFrame,
	case 
	when LinkChartCode in ('R191','R192') then 
		case Product 
			when 'Onglyza'		then 'Top Diabetes Market Tier 3 Hospital Performance by Brand (NIAD)' 
			when 'Glucophage'	then 'Top Diabetes Market Tier 3 Hospital Performance by Brand' 
			when 'Monopril'		then 'Top Monopril Market Tier 3 Hospital Performance by Brand' 
			when 'Coniel'		then 'Top Coniel Market Tier 3 Hospital Performance by Brand' 
			When 'Baraclude'	then 'Top HBV Market Tier 3 Hospital Performance by Brand' 
			when 'Taxol'		then 'Top Oncology Market Tier 3 Hospital Performance by Brand' 
			when 'Paraplatin'		then 'Top Platinum Market Tier 3 Hospital Performance by Brand' 
		end

	when LinkChartCode in ('R251','R252') then 
		case Product 
			when 'Onglyza'		then 'Top Diabetes Market Tier 2 Hospital Performance by Brand (NIAD)' 
			when 'Glucophage'	then 'Top Diabetes Market Tier 2 Hospital Performance by Brand' 
			when 'Monopril'		then 'Top Monopril Market Tier 2 Hospital Performance by Brand' 
			when 'Coniel'		then 'Top Coniel Market Tier 2 Hospital Performance by Brand' 
			When 'Baraclude'	then 'Top HBV Market Tier 2 Hospital Performance by Brand' 
			when 'Taxol'		then 'Top Oncology Market Tier 2 Hospital Performance by Brand' 
			when 'Paraplatin'		then 'Top Platinum Market Tier 2 Hospital Performance by Brand' 
		end 
	
	
	when LinkChartCode in('R201','R202') then 
		case Product 
			when 'Onglyza'		then 'Top NIAD Market Tier 3 Hospital Performance by Class' 
			when 'Glucophage'	then 'Top NIAD Market Tier 3 Hospital Performance by Class' 
			when 'Monopril'		then 'Top Hypertension Market Tier 3 Hospital Performance by Class' 
			When 'Baraclude'	then 'Top HBV Market Tier 3 Hospital Performance by Class' 
			when 'Taxol'		then 'Top Oncology Market Tier 3 Hospital Performance by Class' 
			when 'Paraplatin'		then 'Top Platinum Market Tier 3 Hospital Performance by Class' 
		end 
	
	when LinkChartCode in('R261','R262') then 
		case Product 
			when 'Onglyza'		then 'Top NIAD Market Tier 2 Hospital Performance by Class' 
			when 'Glucophage'	then 'Top NIAD Market Tier 2 Hospital Performance by Class' 
			when 'Monopril'		then 'Top Hypertension Market Tier 2 Hospital Performance by Class' 
			When 'Baraclude'	then 'Top HBV Market Tier 2 Hospital Performance by Class' 
			when 'Taxol'		then 'Top Oncology Market Tier 2 Hospital Performance by Class' 
			when 'Paraplatin'		then 'Top Platinum Market Tier 2 Hospital Performance by Class' 
		end 


	-- 'NIAD','ACE','ARV','ONCFCS'
	when LinkChartCode in('R211','R212') then 
		case Product 
			when 'Onglyza'		then 'Top NIAD Tier 3 Hospital Performance by Brand (NIAD)'
			when 'Glucophage'	then 'Top NIAD Tier 3 Hospital Performance by Brand'
			when 'Monopril'		then 'Top ACEI Tier 3 Hospital Performance by Brand' 
			When 'Baraclude'	then 'Top ARV Tier 3 Hospital Performance by Brand' 
			when 'Taxol'		then 'Top Taxol Market Tier 3 Hospital Performance by Brand' 
		when 'Paraplatin'		then 'Top Paraplatin Market Tier 3 Hospital Performance by Brand' 
		end
	
	when LinkChartCode in('R271','R272') then 
		case Product 
			when 'Onglyza'		then 'Top NIAD Tier 2 Hospital Performance by Brand (NIAD)'
			when 'Glucophage'	then 'Top NIAD Tier 2 Hospital Performance by Brand'
			when 'Monopril'		then 'Top ACEI Tier 2 Hospital Performance by Brand' 
			When 'Baraclude'	then 'Top ARV Tier 2 Hospital Performance by Brand' 
			when 'Taxol'		then 'Top Taxol Market Tier 2 Hospital Performance by Brand' 
			when 'Paraplatin'		then 'Top Paraplatin Market Tier 2 Hospital Performance by Brand' 
		end
	
	-- DPP-4 ONLY
	when LinkChartCode IN('R221','R222') then 'Top DPP-IV Tier 3 Hospital Performance'

	when LinkChartCode IN('R281','R282') then 'Top DPP-IV Tier 2 Hospital Performance'
	
	
	-- Glocuphage/Baraclude/Taxol/Monopril
	when LinkChartCode in('R231','R232') then
		case Product 
			when 'Onglyza'		then 'Top Onglyza Tier 3 Hospital Performance (NIAD)'
			when 'Glucophage'	then 'Top Glucophage Tier 3 Hospital Performance'
			when 'Monopril'		then 'Top Monopril Tier 3 Hospital Performance' 
			when 'Coniel'		then 'Top Coniel Tier 3 Hospital Performance' 
			When 'Baraclude'	then 'Top Baraclude Tier 3 Hospital Performance' 
			when 'Taxol'		then 'Top Taxol Tier 3 Hospital Performance' 
			when 'Paraplatin'		then 'Top Paraplatin Tier 3 Hospital Performance' 
		end
	
	when LinkChartCode in('R291','R292') then
		case Product 
			when 'Onglyza'		then 'Top Onglyza Tier 2 Hospital Performance (NIAD)'
			when 'Glucophage'	then 'Top Glucophage Tier 2 Hospital Performance'
			when 'Monopril'		then 'Top Monopril Tier 2 Hospital Performance' 
			when 'Coniel'		then 'Top Coniel Tier 2 Hospital Performance' 
			When 'Baraclude'	then 'Top Baraclude Tier 2 Hospital Performance' 
			when 'Taxol'		then 'Top Taxol Tier 2 Hospital Performance' 
			when 'Paraplatin'		then 'Top Paraplatin Tier 2 Hospital Performance'
		end
	
	
	-- ONGLYZA ONLY 
	-- not available
	when LinkChartCode='R241' then 'Top Onglyza Tier 3 Hospital Performance'
	when LinkChartCode='R242' then 'Top Onglyza Tier 3 Hospital Performance'
	when LinkChartCode='R301' then 'Top Onglyza Tier 2 Hospital Performance'
	when LinkChartCode='R302' then 'Top Onglyza Tier 2 Hospital Performance'
	
	
	when LinkChartCode in('R901','R902') then 'Top Hypertension Tier 3 Hospital Performance by Class'
	when LinkChartCode IN('R961','R962') then 'Top Hypertension Tier 2 Hospital Performance by Class'
	
	When LinkChartCode in('R911','R912') then 'Top Diabetes Market Tier 3 Hospital Performance by Brand (DPP-IV)'
	When LinkChartCode in('R971','R972') then 'Top Diabetes Market Tier 2 Hospital Performance by Brand (DPP-IV)'

	When LinkChartCode in('R921','R922') then 'Top NIAD Tier 3 Hospital Performance by Brand (DPP-IV)'
	When LinkChartCode in('R981','R982') then 'Top NIAD Tier 2 Hospital Performance by Brand (DPP-IV)'

	When LinkChartCode in('R931','R932') then 'Top Onglyza Tier 3 Hospital Performance (DPP-IV)'
	When LinkChartCode in('R991','R992') then 'Top Onglyza Tier 2 Hospital Performance (DPP-IV)'

	end,
	
	-- select TFValue from tblTimeFrame where DataSource = 'CPA' and TimeFrame = 'mqt'
	'(' + 
	case a.TimeFrame when 'MQT' then 'MAT' else a.TimeFrame end + '/' + (select TFValue from DB4.bmschinamrbi.dbo.tblTimeFrame where DataSource = 'CPA' and TimeFrame = 'mqt') + ', ' + Category + case when Currency = 'Unit' then'' else ' in ' + Currency end +')'

from Output_PPT a
where left(LinkChartCode,1) = 'R' 
	and (right(LinkChartCode,3) between '190' and '309'  or right(LinkChartCode,3) between '900' and '999')
	and IsShow = 'Y' and right(LinkChartCode,1) = '2'
go

delete 
Output_PPT where LinkChartCode ='R480'
go

insert into Output_PPT (DataSource,LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters,  IsShow, Color)
select 'CPA', LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, 
	X, XIdx, cast(cast(Y as decimal(22,12)) as varchar), LinkedY, Size, OtherParameters,  IsShow,Color
from DB4.BMSChinaMRBI.dbo.OutputHospital where LinkChartCode ='R480'
go

delete dbo.tblChartTitle where LinkChartCode ='R480'
go

insert into tblChartTitle (DataSource,LinkChartCode, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, Caption,SlideTitle,PYAxisName,SYAxisName)
select distinct 'CPA', LinkChartCode, Category,Product, Lev, ParentGeo,Geo, Currency,a.TimeFrame, 
	case Product 
		when 'Baraclude'	then 'ARV Market: '
		when 'Glucophage'	then 'NIAD Market: '
		when 'Taxol'		then 'Taxol Market: '
		when 'Monopril'		then 'Monopril Market: '
		when 'Coniel'		then 'Coniel Market: '
		when 'Taxol'		then 'Platinum Market: '
	end + 'Top 20 Hospitals' as Caption,
	'(' + isnull(b.TFValue, a.TimeFrame) + ', ' + Category + case when Currency = 'Unit' then'' else ' in ' + Currency end +')',
	Category PYAxisName,
	'Growth %' SYAxisName
from Output_PPT a
left join DB4.BMSChinaMRBI.dbo.tblTimeFrame b on b.DataSource = 'CPA' and a.TimeFrame = b.TimeFrame
where LinkChartCode = 'R480'
go



update tblChartTitle 
set 
	PYAxisName= a.Category + ' (' + 
		case when b.Dol is null then '' else 'in ' end + 
		a.currency + 
		case when b.Dol is null then '' else ' '+ b.Dol end + ')'
from tblChartTitle A 
left join DB4.BMSChinaMRBI.dbo.tblHospDivNumber B on 
	a.Product = b.Product
	and a.Category = b.Category
	and a.timeFrame = b.TimeFrame
	and a.Currency = b.Currency
	and a.parentGeo = b.ParentGeo
	and a.Geo = b.Geo
	and a.LinkChartcode = b.LinkChartCode
where a.LinkChartCode = 'R480' and a.category = 'Value'
go


update tblChartTitle 
set 
	PYAxisName= a.Category + case when b.dol is null then '' else ' (in ' + b.Dol + ')' end
from tblChartTitle A 
left join DB4.BMSChinaMRBI.dbo.tblHospDivNumber B on 
	a.Product = b.Product
	and a.Category = b.Category
	and a.timeFrame = b.TimeFrame
	and a.Currency = b.Currency
	and a.parentGeo = b.ParentGeo
	and a.Geo = b.Geo
	and a.LinkChartcode = b.LinkChartCode
where a.LinkChartCode = 'R480' and a.category = 'Dosing Units'
go


update BMSChina_ppt_test.dbo.Output_PPT 
set 
	r=b.r,
	g=b.g,
	b=b.b 
from BMSChina_ppt_test.dbo.Output_PPT A 
inner join  BMSChina_ppt_test.dbo.tblRGBToColor B on A.color=b.rgb 
where A.r is null
	and left(LinkChartCode,1) = 'R' 
	and (right(LinkChartCode,3) between '150' and '309'  or right(LinkChartCode,3) between '900' and '999')
go

--log
insert into Logs 
select 'CPA' as [项目],'3_2_Export_Output.sql' as [处理内容],'end' as [标示],getdate() as [时间]
go







print 'over!'


