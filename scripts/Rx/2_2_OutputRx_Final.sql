use BMSChinaMRBI
go








truncate table OutputRx
go
insert into OutputRx (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters, Color, R, G, B, IsShow)
select LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters, Color, R, G, B, IsShow 
from OutputRx_bak
go

update OutputRx set ParentGeo = 'China'
go
update OutputRx set Category = 'Units' where Category = 'Volume'
go

update OutputRx set LinkSeriesCode = Product + '_' + LinkChartCode+'_' + Geo + IsShow + cast(SeriesIdx as varchar)
go

update OutputRx set 
	color=B.rgb,
	r=b.r,
	g=b.g,
	b=b.b 
from OutputRx A 
inner join db82.BMSChina_PPT.dbo.tblColorDef B on A.series=b.name
where a.LinkChartCode in('R341','R351','R361')
go

update OutputRx set 
	color=B.rgb,
	r=b.r,
	g=b.g,
	b=b.b 
from OutputRx A 
inner join db82.BMSChina_PPT.dbo.tblColorDef B on b.Mkt = 'All' and A.seriesIdx=b.name
where a.LinkChartCode in('R342','R352','R362')
	and a.isShow = 'Y'
go

update OutputRx set 
	color=B.rgb,
	r=b.r,
	g=b.g,
	b=b.b 
from OutputRx A 
inner join db82.BMSChina_PPT.dbo.tblColorDef B on b.Mkt = 'All' and b.name = '5'
where a.LinkChartCode in('R342','R352','R362') and a.SeriesIdx = 99999
	and a.isShow = 'Y'
go

delete OutputRx 
where Series = 'Taxol Others'
go







delete from OutputRx  
where Product='ParaPlatin' and [LinkChartCode] not like 'R35%'--Rx




print 'over!'