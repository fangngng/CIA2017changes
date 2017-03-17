use BMSChinaMRBI_test
go






truncate table OutputRx
go
-- R341
-- Hospital Department NIAD Class/Hypertension class Rx Performance
delete OutputRx where linkChartCode = 'R341'
go
insert into OutputRx(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R341' AS LinkChartCode,
	'R341' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, B.Category, a.Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
from (
	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
	from dbo.tblMktDefRx 
	where mkt in ('NIAD','HYP') and Molecule = 'N' and Class = 'Y' and Prod <> '000'
) a, (
	select Mkt,'Units' as Category,Department as X,H1Rank as XIdx  
	from tempOutputRx where Lev = 'Nat' and Mkt in('NIAD','HYP') and Prod = '000' 
)b
where case when b.Mkt = 'Dia' then 'NIAD' else b.Mkt end = a.Product
go

-- R351
-- Hospital Department NIAD Brand/Monopril Market Brand/ARV Brand/Taxol Market Brand Rx Performance
delete OutputRx where linkChartCode = 'R351'
go
insert into OutputRx(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R351' AS LinkChartCode,
	'R351' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, B.Category, a.Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
from (
	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
	from dbo.tblMktDefRx 
	where mkt in ('NIAD','HYPFCS','ARV','ONCFCS','Platinum','CCB') and Molecule = 'N' and Class = 'N' and Prod <> '000'  
) a, (
	select Mkt,'Units' as Category,Department as X,H1Rank as XIdx  
	from tempOutputRx where Lev  = 'Nat' and Mkt in('NIAD','HYPFCS','ARV','ONCFCS','Platinum','CCB') and Prod = '000' 
)b
where B.mKT = a.Product
go


-- set the value
update OutputRx set Y = b.HS1
from OutputRx a
inner join tempOutputRx b on b.Lev = 'Nat' and a.Product = b.Mkt and a.SeriesIdx = cast(b.Prod as int) and a.X = b.Department
where a.LinkChartCode in('R341','R351')
go

update OutputRx set Y = null
where LinkChartCode in('R341','R351')
	and cast(Y as float) = 0
go

-- don't display ARV Others/NIAD Others
delete OutputRx
where LinkChartCode in('R341','R351') and Series in('ARV Others','NIAD Others')
go

-- set the total to Additional Y
update OutputRx set AddY = b.H1
from OutputRx a
inner join tempOutputRx b on b.Lev = 'Nat' and a.Product = b.Mkt and b.Prod = '000' and a.X = b.Department
where a.LinkChartCode in('R341','R351')
go



update OutputRx set
	Currency = 'UNIT',
	TimeFrame = (select left(Value1,4) + ' ' + right(Value1,2) from tblDSDates where item = 'rx')
where LinkChartCode in('R341','R351')
go


update OutputRx set Product = b.Product
from OutputRx a 
inner join (select distinct Product,Mkt from tblMktDefRx) b on a.Product = b.Mkt
where a.LinkChartCode in('R341','R351')
go

update OutputRx set LinkedY = convert(varchar(50),cast(round(AddY,0) as Money),1)
where LinkChartCode in('R341','R351')
go

update OutputRx set LinkedY = left(LinkedY,len(LinkedY)-3)
where LinkChartCode in('R341','R351')
go

update OutputRx set LinkSeriesCode = Product + '_' + LinkChartCode+'_' + Geo + IsShow + cast(SeriesIdx as varchar)
where LinkChartCode in('R341','R351')
go

update OutputRx set X = b.Department_en + ' (' + LinkedY + ')'
--select *
from OutputRx a
inner join tblRxDepartment b on a.x = b.id
where a.LinkChartCode in('R341','R351') and isShow = 'Y'
go

update OutputRx set X = 'All Others (' + LinkedY + ')'
from OutputRx a
where a.LinkChartCode in('R341','R351') and isShow = 'Y'
	and a.X = '9999'
go

-- Duplicate R351 of Glucophage for Onglyza
insert into OutputRx (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
select LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, 'Onglyza' as Product, 
	Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow
from OutputRx 
where LinkChartCode in('R341','R351') and Product = 'Glucophage' 
go


-- R342
-- Hospital Department NIAD Class/Hypertension class Rx Performance
delete OutputRx where linkChartCode = 'R342'
go
insert into OutputRx(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R342' AS LinkChartCode,
	'R342' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
	b.Series, b.SeriesIdx, B.Category, b.Mkt Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,a.X, a.Xidx,0 as Y,'Y'
from (
	select Idx as XIdx, H as X from tblRxHalfYearList where idx <= 12
) a, (
	select Mkt,'Units' as Category,Department as Series,H1Rank as SeriesIdx  
	from tempOutputRx where Lev = 'Nat' and Mkt in('NIAD','HYP') and Prod = '000' 
)b
go


declare @i int, @sql varchar(2000), @m varchar(6)
declare @cnt int
select @cnt=count(*)-1 from tblRxHalfYearList
set @i = 1
while @i <= @cnt
begin
	select @m = H from tblRxHalfYearList where Idx = @i
	set @sql = '
update OutputRx set Y = b.HS' + cast(@i as varchar) + '
from OutputRx a
inner join tempOutpuTRx b on 
	b.Lev = ''Nat'' and a.Product = b.Mkt 
	and b.Prod = case a.Product when ''NIAD'' then ''930'' when ''HYP'' then ''910'' END and a.Series =b.Department
WHERE A.LinkChartCode in (''R342'') AND a.IsShow = ''Y'' and A.x = ''' + @m + ''''
	exec(@sql)
set @i = @i + 1
end
go

-- R352
-- Hospital Department NIAD Brand/Hypertension Brand/ARV Brand/Onc focused Brand Rx Performance
delete OutputRx where linkChartCode = 'R352'
go
insert into OutputRx(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R352' AS LinkChartCode,
	'R352' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
	b.Series, b.SeriesIdx, B.Category, b.Mkt Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,a.X, a.Xidx,0 as Y,'Y'
from (
	select Idx as XIdx, H as X from tblRxHalfYearList
) a, (
	select Mkt,'Units' as Category,Department as Series,H1Rank as SeriesIdx  
	from tempOutputRx where Lev = 'Nat' and Mkt in('NIAD','HYPFCS','ARV','ONCFCS','DPP4','Platinum','CCB') and Prod = '000' 
)b
go


declare @i int, @sql varchar(2000), @m varchar(6),@cnt int
set @i = 1
select @cnt=count(*)-1 from tblRxHalfYearList
while @i <= @cnt
begin
	select @m = H from tblRxHalfYearList where Idx = @i
	set @sql = '
update OutputRx set Y = b.HS' + cast(@i as varchar) + '
from OutputRx a
inner join tempOutpuTRx b on b.Lev = ''Nat'' 
	and CASE WHEN a.Product =''DPP4'' then ''NIAD'' else a.Product end = b.Mkt 
	and CASE WHEN a.Product =''DPP4'' then ''802''  else ''100'' end = b.Prod
	and a.Series =b.Department
WHERE A.LinkChartCode in (''R352'') AND a.IsShow = ''Y'' and A.x = ''' + @m + ''''
	exec(@sql)
set @i = @i + 1
end
go

update OutputRx set 
	Category = 'Units',
	Currency = 'UNIT',
	TimeFrame = (select left(Value1,4) + ' ' + right(Value1,2) from db4.BMSChinaMRBI_test.dbo.tblDSDates where Item = 'Rx')
where LinkChartCode in ('R342','R352')
go

update OutputRx set Product = b.Product
from OutputRx a 
inner join (
	select distinct case when Mkt = 'dpp4' then 'Onglyza' else Product end Product,Mkt 
	from tblMktDefHospital
) b on a.Product = b.Mkt
where a.LinkChartCode in ('R342','R352')
go

update OutputRx set LinkSeriesCode = Product + '_' + LinkChartCode+'_' + Geo + IsShow + cast(SeriesIdx as varchar)
where LinkChartCode in ('R342','R352')
go

update OutputRx set X = b.Department_en
from OutputRx a
inner join tblRxDepartment b on a.X = b.id
where a.LinkChartCode in ('R342','R352') and IsShow = 'd' 
go

update OutputRx set X = 'All Others' where X = '9999' and LinkChartCode in ('R342','R352') and IsShow = 'd'
go

update OutputRx set series = b.Department_en
from OutputRx a
inner join tblRxDepartment b on a.series = b.id
where a.LinkChartCode in ('R342','R352') and IsShow = 'y'
go

update OutputRx set series = 'All Others' where series = '9999' and LinkChartCode in ('R342','R352') and IsShow = 'y'
go


update OutputRx set Series = Series + ' Growth'
from OutputRx a
where a.LinkChartCode in ('R342','R352','R362') and IsShow = 'D'
GO

-- reverse the Month to ascending order
update OutputRx set XIdx = 13 - Xidx
where LinkChartCode in ('R342','R352','R362') AND ISSHOW = 'Y'
go


-- Duplicate R342 of Glucophage for Onglyza
insert into OutputRx (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
select LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, 'Onglyza' as Product, 
	Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow
from OutputRx 
where LinkChartCode in('R342') and Product = 'Glucophage' 
go

-- 
update OutputRx set Y = Null
where LinkChartCode in ('R342','R352','R362') AND ISSHOW = 'Y'
	and XIdx = (select min(xidx) from OutputRx where linkchartcode in('R342','R352','R362') and IsShow = 'Y')
go

--Eliquis Market RX Dept allocation of key brands
--Current Year: XARELTO
delete from OutputRx where LinkChartCode='R661'
insert into OutputRx(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
'R661' as LinkChartCode,
'R661'+case when a.Department_en='Others' then '10' else convert(varchar(3),a.row_Num) end as LinkSeriesCode,
a.Department_en as Series,
case when a.Department_en='Others' then 10 else a.row_Num end as SeriesIdx,
'Units' as Category,
'Eliquis' as Product,
'Nat' as Lev,
'China' as Geo,
'UNIT' as Currency,
'2013H1' as TimeFrame,
a.ProductName+'_'+right(a.X,4)+left(a.X,2) as X,a.XIdx as XIdx,a.Y as Y,'Y' as IsShow	    
from (
	select *,row_number() over(partition by product,prod,x order by Y desc) as row_Num,
			dense_rank() over(partition by product,prod order by right(X,4) desc ) as XIdx 
	from Output_CIA_CV_Modification_Slide_1 where Type='ValueShare'
) a 
where a.ProductName='XARELTO' and a.XIdx=1


--Last Year: XARELTO
--r662
delete from OutputRx where LinkChartCode='R662'
insert into OutputRx(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
'R662' as LinkChartCode,
'R662'+case when a.Department_en='Others' then '10' else convert(varchar(3),a.row_Num) end as LinkSeriesCode,
a.Department_en as Series,
case when a.Department_en='Others' then 10 else a.row_Num end as SeriesIdx,
'Units' as Category,
'Eliquis' as Product,
'Nat' as Lev,
'China' as Geo,
'UNIT' as Currency,
'2013H1' as TimeFrame,
a.ProductName+'_'+right(a.X,4)+left(a.X,2) as X,a.XIdx as XIdx,a.Y as Y,'Y' as IsShow	    
from (
	select *,row_number() over(partition by product,prod,x order by Y desc) as row_Num,
			dense_rank() over(partition by product,prod order by right(X,4) desc ) as XIdx 
	from Output_CIA_CV_Modification_Slide_1 where Type='ValueShare'
) a 
where a.ProductName='XARELTO' and a.XIdx=2

--Current Year: FRAXIPARINE
--R663
delete from OutputRx where LinkChartCode='R663'
insert into OutputRx(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
'R663' as LinkChartCode,
'R663'+case when a.Department_en='Others' then '10' else convert(varchar(3),a.row_Num) end as LinkSeriesCode,
a.Department_en as Series,
case when a.Department_en='Others' then 10 else a.row_Num end as SeriesIdx,
'Units' as Category,
'Eliquis' as Product,
'Nat' as Lev,
'China' as Geo,
'UNIT' as Currency,
'2013H1' as TimeFrame,
a.ProductName+'_'+right(a.X,4)+left(a.X,2) as X,a.XIdx as XIdx,a.Y as Y,'Y' as IsShow	    
from (
	select *,row_number() over(partition by product,prod,x order by Y desc) as row_Num,
			dense_rank() over(partition by product,prod order by right(X,4) desc ) as XIdx 
	from Output_CIA_CV_Modification_Slide_1 where Type='ValueShare'
) a 
where a.ProductName='FRAXIPARINE' and a.XIdx=1


--Last Year: FRAXIPARINE
--R664
delete from OutputRx where LinkChartCode='R664'
insert into OutputRx(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
'R664' as LinkChartCode,
'R664'+case when a.Department_en='Others' then '10' else convert(varchar(3),a.row_Num) end as LinkSeriesCode,
a.Department_en as Series,
case when a.Department_en='Others' then 10 else a.row_Num end as SeriesIdx,
'Units' as Category,
'Eliquis' as Product,
'Nat' as Lev,
'China' as Geo,
'UNIT' as Currency,
'2013H1' as TimeFrame,
a.ProductName+'_'+right(a.X,4)+left(a.X,2) as X,a.XIdx as XIdx,a.Y as Y,'Y' as IsShow	    
from (
	select *,row_number() over(partition by product,prod,x order by Y desc) as row_Num,
			dense_rank() over(partition by product,prod order by right(X,4) desc ) as XIdx 
	from Output_CIA_CV_Modification_Slide_1 where Type='ValueShare'
) a 
where a.ProductName='FRAXIPARINE' and a.XIdx=2


--Current Year: CLEXANE
--R665
delete from OutputRx where LinkChartCode='R665'
insert into OutputRx(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
'R665' as LinkChartCode,
'R665'+case when a.Department_en='Others' then '10' else convert(varchar(3),a.row_Num) end as LinkSeriesCode,
a.Department_en as Series,
case when a.Department_en='Others' then 10 else a.row_Num end as SeriesIdx,
'Units' as Category,
'Eliquis' as Product,
'Nat' as Lev,
'China' as Geo,
'UNIT' as Currency,
'2013H1' as TimeFrame,
a.ProductName+'_'+right(a.X,4)+left(a.X,2) as X,a.XIdx as XIdx,a.Y as Y,'Y' as IsShow	    
from (
	select *,row_number() over(partition by product,prod,x order by Y desc) as row_Num,
			dense_rank() over(partition by product,prod order by right(X,4) desc ) as XIdx 
	from Output_CIA_CV_Modification_Slide_1 where Type='ValueShare'
) a 
where a.ProductName='CLEXANE' and a.XIdx=1


--Last Year: CLEXANE
--R666
delete from OutputRx where LinkChartCode='R666'
insert into OutputRx(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
'R666' as LinkChartCode,
'R666'+case when a.Department_en='Others' then '10' else convert(varchar(3),a.row_Num) end as LinkSeriesCode,
a.Department_en as Series,
case when a.Department_en='Others' then 10 else a.row_Num end as SeriesIdx,
'Units' as Category,
'Eliquis' as Product,
'Nat' as Lev,
'China' as Geo,
'UNIT' as Currency,
'2013H1' as TimeFrame,
a.ProductName+'_'+right(a.X,4)+left(a.X,2) as X,a.XIdx as XIdx,a.Y as Y,'Y' as IsShow	    
from (
	select *,row_number() over(partition by product,prod,x order by Y desc) as row_Num,
			dense_rank() over(partition by product,prod order by right(X,4) desc ) as XIdx 
	from Output_CIA_CV_Modification_Slide_1 where Type='ValueShare'
) a 
where a.ProductName='CLEXANE' and a.XIdx=2



--Current Year: ELIQUIS
--R667
delete from OutputRx where LinkChartCode='R667'
insert into OutputRx(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
'R667' as LinkChartCode,
'R667'+case when a.Department_en='Others' then '10' else convert(varchar(3),a.row_Num) end as LinkSeriesCode,
a.Department_en as Series,
case when a.Department_en='Others' then 10 else a.row_Num end as SeriesIdx,
'Units' as Category,
'Eliquis' as Product,
'Nat' as Lev,
'China' as Geo,
'UNIT' as Currency,
'2013H1' as TimeFrame,
a.ProductName+'_'+right(a.X,4)+left(a.X,2) as X,a.XIdx as XIdx,a.Y as Y,'Y' as IsShow	    
from (
	select *,row_number() over(partition by product,prod,x order by Y desc) as row_Num,
			dense_rank() over(partition by product,prod order by right(X,4) desc ) as XIdx 
	from Output_CIA_CV_Modification_Slide_1 where Type='ValueShare'
) a 
where a.ProductName='ELIQUIS' and a.XIdx=1


--Last Year: ELIQUIS
--R668
delete from OutputRx where LinkChartCode='R668'
insert into OutputRx(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
'R668' as LinkChartCode,
'R668'+case when a.Department_en='Others' then '10' else convert(varchar(3),a.row_Num) end as LinkSeriesCode,
a.Department_en as Series,
case when a.Department_en='Others' then 10 else a.row_Num end as SeriesIdx,
'Units' as Category,
'Eliquis' as Product,
'Nat' as Lev,
'China' as Geo,
'UNIT' as Currency,
'2013H1' as TimeFrame,
a.ProductName+'_'+right(a.X,4)+left(a.X,2) as X,a.XIdx as XIdx,a.Y as Y,'Y' as IsShow	    
from (
	select *,row_number() over(partition by product,prod,x order by Y desc) as row_Num,
			dense_rank() over(partition by product,prod order by right(X,4) desc ) as XIdx 
	from Output_CIA_CV_Modification_Slide_1 where Type='ValueShare'
) a 
where a.ProductName='ELIQUIS' and a.XIdx=2


update OutputRx set 
	Category = 'Units',
	Currency = 'UNIT',
	TimeFrame = (select left(Value1,4) + ' ' + right(Value1,2) from db4.BMSChinaMRBI_test.dbo.tblDSDates where Item = 'Rx')
where LinkChartCode in ('R661','R662','R663','R664','R665','R666','R667','R668')



if object_id(N'OutputRx_bak',N'U') is not null
	drop table OutputRx_Bak
go
select * into OutputRx_bak from OutputRx
go


-- select * from outputRx where linkchartcode = 'R351' and Product = 'ParaPlatin'

-- select * from outputRx where linkchartcode = 'R351' and Product = 'Onglyza'

-- select * from outputRx where linkchartcode = 'R352'and Product = 'Onglyza'

-- select * from outputRx where linkchartcode = 'R352'and Product = 'Glucophage'



print 'over!'