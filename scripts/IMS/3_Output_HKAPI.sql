USE BMSChinaCIA_IMS
GO

--------------------------------------------------------------------
--C100
--------------------------------------------------------------------
delete [output_stage] where LinkChartCode = 'C100'
declare @code varchar(10)
set @code = 'C100'
insert into [output_stage] (IsShow,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select IsShow,Period, @code as Code, a.Series,a.SeriesIdx,MoneyType,b.Corp_des,b.[CurrRank]
from (
	select 'MAT00' as Series,'Y' as IsShow,	2 as SeriesIdx union all
	select 'MAT12' as Series,'Y' ,1 as SeriesIdx union all
	select 'MAT00Growth' as Series,	'Y' ,	3 as SeriesIdx union all
	select 'CurrRank' as Series,	'D' ,	4 as SeriesIdx union all
	select 'ChangeRank' as Series,'D' ,	5 as SeriesIdx union all
    select 'Share' as Series,'D' ,	6 as SeriesIdx union all
    select 'ShareTotal' as Series,'N' ,	7 as SeriesIdx 
) a, (
	select distinct Period,MoneyType,Corp_des,[CurrRank] from dbo.OutputKeyMNCsPerformance_HKAPI 
where MoneyType<>'PN'
) b


DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select distinct Series  from dbo.[output_stage] where LinkChartCode=@code
DECLARE @Series varchar(100)
DECLARE @SQL2 VARCHAR(8000)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @Series
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @Series

		set @SQL2='
		update [output_stage]
		set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.OutputKeyMNCsPerformance_HKAPI B
		on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X=B.Corp_des
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series='+''''+@Series+''''
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go

--------------------------------------------------------------------
--C110
--------------------------------------------------------------------
delete [output_stage] where LinkChartCode = 'C110'
declare @code varchar(10)
set @code = 'C110'
insert into [output_stage] (IsShow,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select IsShow,Period, @code as Code, a.Series,a.SeriesIdx,MoneyType,b.Prod_des,b.[CurrRank]
from (
	select 'MAT00' as Series,'Y' as IsShow,2 as SeriesIdx union all
	select 'MAT12' as Series,'Y' ,1 as SeriesIdx union all
	select 'MAT00Growth' as Series,'Y',3 as SeriesIdx union all
	select 'CurrRank' as Series,'D',	4 as SeriesIdx union all
	select 'ChangeRank' as Series,'D',	5 as SeriesIdx union all
    select 'Share' as Series,'D',	6 as SeriesIdx union all
    select 'ShareTotal' as Series,'N' ,	7 as SeriesIdx 
) a, (
	select distinct Period,MoneyType,Prod_des,[CurrRank] from dbo.OutputKeyMNCsProdPerformance_HKAPI
where MoneyType<>'PN'
) b


DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select distinct Series  from dbo.[output_stage] where LinkChartCode=@code
DECLARE @Series varchar(100)
DECLARE @SQL2 VARCHAR(8000)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @Series
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @Series

		set @SQL2='
		update [output_stage]
		set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.OutputKeyMNCsProdPerformance_HKAPI B
		on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X=B.Prod_des
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series='+''''+@Series+''''
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
delete from output_stage where series='ShareTotal' and xidx<>1 and linkchartcode in ('C100','C110')
go
update output_stage
set timeframe=case timeframe when 'Rolling 3 Months' then 'MQT' else timeframe end
where LinkChartCode in ('C100','C110')
go
update [output_stage]
set series=	case series 
			when 'CurrRank' then 'Rank' 
			when 'ChangeRank' then 'Change in Rank' 
			when 'Share' then 'Contribution ('+case when timeFrame like '%Current 3 Month%' then 'Cur 3 M' 
													else timeframe end+')' 
			else series end
where linkchartcode in('C100','C110') and timeFrame='YTD'
go
update [output_stage]
set series=	case series 
			when 'CurrRank' then 'Rank' 
			when 'ChangeRank' then 'Change in Rank' 
			when 'Share' then 'Contribution ('+(select cast(year-1 as varchar(6)) from tblDateHKAPI)+')' 
			else series end
where linkchartcode in('C100','C110') and timeFrame='Last Year'


update [output_stage]
set LinkSeriesCode=LinkChartCode+timeframe+Series+cast(SeriesIdx as varchar(10))
where LinkChartCode in('C100','C110')
go
update [output_stage]
set Category=	case Currency 
				when 'UN' then 'Units' 
				else 'Value' end
where LinkChartCode in('C100','C110')
go
update [output_stage]
set Currency=	case Currency 
				when 'US' then 'USD' 
				when 'LC' then 'RMB' 
				when 'UN' then 'UNIT' 
				else Currency end 
where LinkChartCode in('C100','C110')
go



update [output_stage]
set series=	case series 
			when 'MAT00' then (select cast(year-1 as varchar(6)) from tblDateHKAPI)
			when 'MAT12' then (select cast(year-2 as varchar(6)) from tblDateHKAPI)
			when 'MAT00Growth' then  (select cast(year-1 as varchar(6)) from tblDateHKAPI)+' Growth'
			else series
			end 
where linkchartcode in('C100','C110')and timeFrame='Last Year'
go
update [output_stage]
set series=	case series 
			when 'MAT00' then 'YTD '+(select [Month]+''''+right(year,2) from tblDateHKAPI)
			when 'MAT12' then 'YTD '+(select [Month]+''''+right(year-1,2) from tblDateHKAPI)
			when 'MAT00Growth' then  'YTD '+(select [Month]+''''+right(year,2) from tblDateHKAPI)+' Growth'
			else series
end where linkchartcode in('C100','C110')and timeFrame='YTD'
go
update [output_stage]
set series=	case series 
			when 'MAT00' then 'MQT '+(select [MonthEN] from tblMonthList where monseq=1)
			when 'MAT12' then 'MQT '+(select [MonthEN] from tblMonthList where monseq=13)
			when 'MAT00Growth' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=1)+' Growth'
			when 'MAT12Growth' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=13)+' Growth'
			else series
end where linkchartcode in('C100','C110') and timeFrame='MQT'
go
update [output_stage]
set series= case series 
			when 'MAT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
			when 'MAT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)
			when 'MAT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)
			when 'MAT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)
			when 'MAT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)
			when 'MAT00Growth' then  TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)+' Growth'
			when 'MAT12Growth' then  TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)+' Growth'
			else series
end where LinkChartCode in('C100','C110') and timeFrame<>'Last Year'
go
update [output_stage]
set X= 	case X 
		when 'MAT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'MAT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'MAT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)
		when 'MAT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)
		when 'MAT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)
		else X
end where  LinkChartCode in('C100','C110') and timeFrame<>'Last Year'
go


update [output_stage]
set Product='Portfolio',
    Lev='Nation',
    geo='China'
where LinkChartCode in('C100','C110')
go






--C210   
delete from output_stage where linkchartcode='C210'

declare @code varchar(10)
set @code = 'C210'
insert into [output_stage] (Product,geo,lev,IsShow,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select B.market,'China','Nation',IsShow,Period, @code as Code,b.Product,b.ProdIdx,MoneyType, a.Series,a.SeriesIdx
from (
	select 'MAT00' as Series,'Y' as IsShow,	4 as SeriesIdx union all
	select 'MAT12' as Series,'Y' ,3 as SeriesIdx union all
    select 'MAT24' as Series,'Y' ,2 as SeriesIdx union all
    select 'MAT36' as Series,'Y' ,1 as SeriesIdx 
--	select 'Growth' as Series,	'Y' ,	5 as SeriesIdx union all
) a, (
	select distinct Market,Period,MoneyType,Product,ProdIdx from dbo.OutputCMLChina_HKAPI
) b

DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select distinct X  from dbo.[output_stage] where LinkChartCode=@code
DECLARE @Series varchar(100)
DECLARE @SQL2 VARCHAR(8000)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @Series
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @Series

		set @SQL2='
		update [output_stage]
		set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.OutputCMLChina_HKAPI B
		on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X='+''''+@Series+'''
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Product'
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR

insert into [output_stage] (Product,geo,lev,IsShow,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select B.market,'China','Nation',IsShow,Period, @code as Code, a.Series,a.SeriesIdx,MoneyType,b.Product,b.ProdIdx
from (
	select 'Qtr00' as Series,	'D' as IsShow ,	10 as SeriesIdx union all
    select 'Qtr01' as Series,	'D' ,	9 as SeriesIdx union all
    select 'Qtr02' as Series,	'D' ,	8 as SeriesIdx union all
	select 'Qtr03' as Series,	'D' ,	7 as SeriesIdx union all
	select 'Qtr04' as Series,	'D' ,	6 as SeriesIdx
	
) a, (
	select distinct Market,Period,MoneyType,Product,ProdIdx from dbo.OutputCMLChina_HKAPI
) b

DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select distinct Series  from dbo.[output_stage] where LinkChartCode=@code and isshow='D'
--DECLARE @Series varchar(100)
--DECLARE @SQL2 VARCHAR(8000)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @Series
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @Series

		set @SQL2='
		update [output_stage]
		set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.OutputCMLChina_HKAPI B
		on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X=B.Product
		and a.LinkChartCode = '+''''+@code+''''+' and a.isshow=''D'' and A.Series='+''''+@Series+''''
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
update [output_stage]
set X =	case X 
		when 'MAT00' then TimeFrame + (select ' '+right(year,2)+Qtr from tblDateHKAPI)
		when 'MAT12' then TimeFrame + (select ' '+right(year-1,2)+Qtr from tblDateHKAPI)
		when 'MAT24' then TimeFrame + (select ' '+right(year-2,2)+Qtr from tblDateHKAPI)
		when 'MAT36' then TimeFrame + (select ' '+right(year-3,2)+Qtr from tblDateHKAPI)
		when 'MAT48' then TimeFrame + (select ' '+right(year-4,2)+Qtr from tblDateHKAPI)
		when 'Qtr00' then '2016Q4'       --todo
		when 'Qtr01' then '2016Q3'
		when 'Qtr02' then '2016Q2'
		when 'Qtr03' then '2015Q1'
		when 'Qtr04' then '2015Q4'
		else X
end  where LinkChartCode in('C210')
go
update [output_stage]
set Series=	case Series 
			when 'MAT00' then TimeFrame + (select ' '+right(year-1,2)+Qtr from tblDateHKAPI)
			when 'MAT12' then TimeFrame + (select ' '+right(year-2,2)+Qtr from tblDateHKAPI)
			when 'MAT24' then TimeFrame + (select ' '+right(year-3,2)+Qtr from tblDateHKAPI)
			when 'MAT36' then TimeFrame + (select ' '+right(year-4,2)+Qtr from tblDateHKAPI)
			when 'MAT48' then TimeFrame + (select ' '+right(year-5,2)+Qtr from tblDateHKAPI)
			when 'Qtr00' then '2016Q4'      --todo
			when 'Qtr01' then '2016Q3'
			when 'Qtr02' then '2016Q2'
			when 'Qtr03' then '2015Q1'
			when 'Qtr04' then '2015Q4'
			else Series
end  where LinkChartCode in('C210')
go
update [output_stage]
set LinkSeriesCode=Product+'_'+LinkChartCode+Series+cast(SeriesIdx as varchar(10))+Currency where LinkChartCode in('C210')
go
update [output_stage]
set Category=case Currency when 'UN' then 'Units' else 'Value' end
where LinkChartCode in('C210')
go
update [output_stage]
set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' else Currency end 
where LinkChartCode in('C210')
go



--C220
delete from output_stage where linkchartcode='C220'

declare @code varchar(10)
set @code = 'C220'

insert into [output_stage] (Product,geo,lev,IsShow,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select B.market,'China','Nation',IsShow,'Quarter', @code as Code,b.Product,b.ProdIdx,MoneyType, a.Series,a.SeriesIdx
from (
	--Add Qtr04 by xiaoyu.chen 2013-08-19
	select 'Qtr00' as Series,	'Y' as IsShow ,	10 as SeriesIdx union all
	select 'Qtr01' as Series,	'Y' ,	9 as SeriesIdx union all
	select 'Qtr02' as Series,	'Y' ,	8 as SeriesIdx union all
	select 'Qtr03' as Series,	'Y' ,	7 as SeriesIdx union all
	select 'Qtr04' as Series,	'Y' ,	6 as SeriesIdx
	--   select 'Qtr00' as Series,	'Y' as IsShow ,	9 as SeriesIdx union all
	--   select 'Qtr01' as Series,	'Y' ,	8 as SeriesIdx union all
	--   select 'Qtr02' as Series,	'Y' ,	7 as SeriesIdx union all
	--select 'Qtr03' as Series,	'Y' ,	6 as SeriesIdx 
) a, (
	select distinct Market,MoneyType,Product,ProdIdx from dbo.OutputCMLChina_HKAPI
) b

insert into [output_stage] (Product,geo,lev,IsShow,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select B.market,'China','Nation',IsShow, b.Period, @code as Code,b.Product,b.ProdIdx,MoneyType, a.Series,a.SeriesIdx
from (
	--Add Qtr04 by xiaoyu.chen 2013-08-19
	select 'MAT00' as Series,	'Y' as IsShow ,	10 as SeriesIdx union all
	select 'MAT12' as Series,	'Y' ,	9 as SeriesIdx union all
	select 'MAT24' as Series,	'Y' ,	8 as SeriesIdx union all
	select 'MAT36' as Series,	'Y' ,	7 as SeriesIdx union all
	select 'MAT48' as Series,	'Y' ,	6 as SeriesIdx
	--   select 'Qtr00' as Series,	'Y' as IsShow ,	9 as SeriesIdx union all
	--   select 'Qtr01' as Series,	'Y' ,	8 as SeriesIdx union all
	--   select 'Qtr02' as Series,	'Y' ,	7 as SeriesIdx union all
	--select 'Qtr03' as Series,	'Y' ,	6 as SeriesIdx 
) a, (
	select distinct Market,Period,MoneyType,Product,ProdIdx from dbo.OutputCMLChina_HKAPI
) b


DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select distinct X  from dbo.[output_stage] where LinkChartCode=@code
DECLARE @Series varchar(100)
DECLARE @SQL2 VARCHAR(8000)

OPEN TMP_CURSOR

FETCH NEXT FROM TMP_CURSOR INTO @Series
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @Series

		set @SQL2='
		update [output_stage]
		set Y=B.'+@Series+ ' 
		from [output_stage] A 
		inner join dbo.OutputCMLChina_HKAPI B
		on A.Currency=B.MoneyType and A.X='+''''+@Series+'''  and a.TimeFrame = b.Period
			and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Product
			and a.TimeFrame <> ''Quarter''
		'
		print @SQL2
		exec( @SQL2)

		
		set @SQL2='
		update [output_stage]
		set Y=B.'+@Series+ ' 
		from [output_stage] A 
		inner join dbo.OutputCMLChina_HKAPI B
		on A.Currency=B.MoneyType and A.X='+''''+@Series+'''  
			and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Product
			and a.TimeFrame = ''Quarter''
		'
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR

update [output_stage]
set X=case X 
	when 'Qtr00' then '2016Q4'     -- todo  
	when 'Qtr01' then '2016Q3'   
	when 'Qtr02' then '2016Q2'   
	when 'Qtr03' then '2016Q1'   
	when 'Qtr04' then '2015Q4'   
	when 'MAT00' then  '2016Q4'  -- todo 
	when 'MAT12' then  '2015Q4' 
	when 'MAT24' then  '2014Q4' 
	when 'MAT36' then  '2013Q4' 
	when 'MAT48' then  '2012Q4' 
	else X
	end  
where LinkChartCode in('C220')
go

update [output_stage]
set LinkSeriesCode=Product+'_'+LinkChartCode+Series+cast(SeriesIdx as varchar(10))+Currency where LinkChartCode in('C220')
go
update [output_stage]
set Category=case Currency when 'UN' then 'Units' else 'Value' end
where LinkChartCode in('C220')
go
update [output_stage]
set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' else Currency end 
where LinkChartCode in('C220')
go







delete from output_stage where linkchartcode='R320'
go
declare @code varchar(10)
set @code = 'R320'
insert into [output_stage](isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select 'Y' as isshow,'China','China',Market,'China',Period, @code as Code, a.Series,a.SeriesIdx,MoneyType,b.Productname,b.CurrRank
from (
	select 'YTD00' as Series,'Y' as isshow,2 as SeriesIdx union all
	select 'YTD12' as Series,'Y',1 as SeriesIdx union all
	select 'Growth' as Series,'Y',	3 as SeriesIdx
) a, (
	select * from dbo.OutputPreHKAPIBrandPerformance
) b
where b.Market<>'Eliquis'

DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select distinct Series  from dbo.[output_stage] where LinkChartCode=@code
DECLARE @Series varchar(100)
DECLARE @SQL2 VARCHAR(8000)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @Series
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @Series

		set @SQL2='
		update [output_stage]
		set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.OutputPreHKAPIBrandPerformance B
		on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X=B.Productname and B.Market<>''Eliquis'' 
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series='+''''+@Series+''''
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go




update [output_stage]
set LinkSeriesCode=Product+LinkChartCode+Series+TimeFrame+cast(SeriesIdx as varchar(10))
where LinkChartCode='R320' 
go
update [output_stage]
set Category=case Currency when 'UN' then 'Units' else 'Value' end
where LinkChartCode='R320'
go
update [output_stage]
set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' else Currency end 
where LinkChartCode='R320'

update [output_stage]
set Series=case Series when 'YTD00' then TimeFrame + ' '+(select [Month]+''''+right(year,2) from tblDateHKAPI)
when 'YTD12' then TimeFrame +  ' '+(select [Month]+''''+right(year-1,2) from tblDateHKAPI)
when 'YTD00Growth' then  TimeFrame + ' '+(select [Month]+''''+right(year,2) from tblDateHKAPI)+' Growth'
else Series
end where  LinkChartCode ='R320'


update output_stage
set DataSource= 'HKAPI' 
where  linkchartcode in ('C100','C110','C210','C220','R320')