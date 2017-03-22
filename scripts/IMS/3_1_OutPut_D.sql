/*

注意：所有3打头的脚本如果要重跑,必须一起都跑！

*/

USE BMSChinaCIA_IMS_test --db4
GO
--28分钟
--27分钟2013年7月份数据




exec dbo.sp_Log_Event 'Output','CIA','3_1_Output_D.sql','Start',null,null



truncate table [output_stage]
go
if not exists(select 1 from   syscolumns   where   id=object_id('output_stage')   and   name='inty' )
begin
	alter table output_stage add inty float
end	
go






-------------------------------------------
-- C020
-------------------------------------------
delete [output_stage] where LinkChartCode = 'C020'
declare @code varchar(10)
set @code = 'C020'
insert into [output_stage] (TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select Period, 'c020' as Code, b.market,b.marketidx,MoneyType, a.Series,a.SeriesIdx
from (
	select 'MAT00' as Series,	5 as SeriesIdx union all
	select 'MAT12' as Series,	4 as SeriesIdx union all
	select 'MAT24' as Series,	3 as SeriesIdx union all
	select 'MAT36' as Series,	2 as SeriesIdx union all
	select 'MAT48' as Series,	1 as SeriesIdx

	--select 'YTD00' as Series,	5 as SeriesIdx union all
	--select 'YTD12' as Series,	4 as SeriesIdx union all
	--select 'YTD24' as Series,	3 as SeriesIdx union all
	--select 'YTD36' as Series,	2 as SeriesIdx union all
	--select 'YTD48' as Series,	1 as SeriesIdx union all

	--select 'MQT00' as Series,	5 as SeriesIdx union all
	--select 'MQT12' as Series,	4 as SeriesIdx union all
	--select 'MQT24' as Series,	3 as SeriesIdx union all
	--select 'MQT36' as Series,	2 as SeriesIdx union all
	--select 'MQT48' as Series,	1 as SeriesIdx 
) a, (
	select distinct Period,MoneyType,market,marketidx from dbo.[OurputKey10TAVSTotalMkt] 
    where MoneyType<>'PN' and Period <> 'MTH'
) b
where (B.market like '%CAGR%' and A.Series='MAT00') or B.market not like '%CAGR%'

insert into [output_stage] (TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select Period, 'c020' as Code, b.market,b.marketidx,MoneyType, a.Series,a.SeriesIdx
from (
	select 'MTH00' as Series,	11 as SeriesIdx union all
	select 'MTH01' as Series,	10 as SeriesIdx union all
	select 'MTH02' as Series,	9 as SeriesIdx union all
	select 'MTH03' as Series,	8 as SeriesIdx union all
	select 'MTH04' as Series,	7 as SeriesIdx union all
	select 'MTH05' as Series,	6 as SeriesIdx union all
	select 'MTH06' as Series,	4 as SeriesIdx union all
	select 'MTH07' as Series,	3 as SeriesIdx union all
	select 'MTH08' as Series,	2 as SeriesIdx union all
	select 'MTH09' as Series,	1 as SeriesIdx union all
	select 'MTH10' as Series,	1 as SeriesIdx union all
	select 'MTH11' as Series,	1 as SeriesIdx
) a, (
	select distinct Period,MoneyType,market,marketidx from dbo.[OurputKey10TAVSTotalMkt] 
   where MoneyType<>'PN' and Period = 'MTH'
) b
where (B.market like '%CAGR%' and A.Series='MAT00') or B.market not like '%CAGR%'

DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select distinct X  from dbo.[output_stage] where LinkChartCode='c020'
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
		set Y=B.[' + @Series+ '] 
		from [output_stage] A 
		inner join dbo.[OurputKey10TAVSTotalMkt] B
		on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.market'
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
update output_stage
set isshow=case when seriesidx in (1,2,10,20) then 'Y' when seriesidx in (3) then 'D' else 'N' end
where linkchartcode='c020'
GO
update output_stage
set X = (select MonthEN from tblMonthList where MonSeq = convert(int, right(X, 2)))
from tblMonthList as b
where linkchartcode='c020' and TimeFrame = 'MTH'
GO


------------------------------------
--c030
------------------------------------
delete [output_stage] where LinkChartCode = 'c030'
declare @code varchar(10)
set @code = 'C030'
insert into [output_stage] (isshow,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select isshow,Period, @code as Code, a.Series,a.SeriesIdx,MoneyType,b.atc3_des,b.[Rank]
from (
	select 'MAT00' as Series,'Y' as isshow,2 as SeriesIdx union all
	select 'MAT12' as Series,'Y',1 as SeriesIdx union all
	select 'MAT00Growth' as Series,'Y',4 as SeriesIdx union all
	select 'MAT12Growth' as Series,'Y',	3 as SeriesIdx
) a, (
	select distinct Period,MoneyType,atc3_des,[Rank] from dbo.OutputTop10TAPerformance
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
			set Y=B.['+@Series+ '] 
			from [output_stage] A 
			inner join dbo.OutputTop10TAPerformance B
			on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X=B.atc3_des
			and a.LinkChartCode = '+''''+@code+''''+' and A.Series='+''''+@Series+''''
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go


------------------------------------
-- C040
------------------------------------
delete [output_stage] where LinkChartCode = 'C040'
declare @code varchar(10)
set @code = 'C040'
insert into [output_stage] (IsShow,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select IsShow,Period, @code as Code, a.Series,a.SeriesIdx,MoneyType,b.Corp_des,b.[CurrRank]
from (
	select 'MAT00' as Series,'Y' as IsShow,	2 as SeriesIdx union all
	select 'MAT12' as Series,'Y' ,1 as SeriesIdx union all
	select 'MAT00Growth' as Series,	'Y' ,	3 as SeriesIdx union all
	select 'CurrRank' as Series,	'D' ,	4 as SeriesIdx union all
	select 'ChangeRank' as Series,'D' ,	5 as SeriesIdx union all
    select 'Share' as Series,'D' ,	6 as SeriesIdx union all
    select 'ShareTotal' as Series, 'N' ,	7 as SeriesIdx
) a, (
	select distinct Period,MoneyType,Corp_des,[CurrRank] from dbo.OutputKeyMNCsPerformance
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
			set Y=B.['+@Series+ '] from [output_stage] A inner join dbo.OutputKeyMNCsPerformance B
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
update [output_stage]
set series=case series when 'CurrRank' then 'Rank' when 'ChangeRank' then 'Change in Rank' when 'Share' then 'Contribution ('+case when timeFrame like '%Current 3 Month%' then 'Cur 3 M' else timeframe end+')' else series end
where linkchartcode='C040'
go
--------------------------------------------------
--C050
--------------------------------------------------
delete [output_stage] where LinkChartCode = 'C050'
declare @code varchar(10)
set @code = 'C050'
insert into [output_stage] (IsShow,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select IsShow,Period, @code as Code, a.Series,a.SeriesIdx,MoneyType,b.Prod_des,b.[CurrRank]
from (
	select 'MAT00' as Series,'Y' as IsShow,2 as SeriesIdx union all
	select 'MAT12' as Series,'Y' ,1 as SeriesIdx union all
	select 'MAT00Growth' as Series,'Y',3 as SeriesIdx union all
	select 'CurrRank' as Series,'D',	4 as SeriesIdx union all
	select 'ChangeRank' as Series,'D',	5 as SeriesIdx union all
    select 'Share' as Series,'D',	6 as SeriesIdx union all
    select 'ShareTotal' as Series, 'N' ,	7 as SeriesIdx
) a, (
	select distinct Period,MoneyType,Prod_des,[CurrRank] 
	from dbo.OutputKeyMNCsProdPerformance
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
			set Y=B.['+@Series+ '] 
			from [output_stage] A 
			inner join dbo.OutputKeyMNCsProdPerformance B
			on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X=B.Prod_des and A.Xidx=B.[CurrRank]
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
set series=case series when 'CurrRank' then 'Rank' when 'ChangeRank' then 'Change in Rank' when 'Share' then 'Contribution ('+case when timeFrame like '%Current 3 Month%' then 'Cur 3 M' else timeframe end+')' else series end
where linkchartcode='C050'
go
delete from output_stage where series='ShareTotal' and xidx<>1 and linkchartcode in('C040','C050')

-- ----------------------------------------
-- -- --C060
-- -----------------------------------------
-- delete [output_stage] where LinkChartCode = 'C060'
-- declare @code varchar(10)
-- set @code = 'C060'
-- delete from output_stage where LinkChartCode='C060'
-- insert into [output_stage] (IsShow,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
-- select IsShow,Period, @code as Code, a.Series,a.SeriesIdx,MoneyType,b.Audi_des,b.CurrRank
-- from (
-- 	select 'MAT00' as Series,'Y' as IsShow,1 as SeriesIdx union all
-- 	select 'Growth' as Series,'Y' ,2 as SeriesIdx union all
--     select 'Avg.Growth' as Series,'Y' ,3 as SeriesIdx union all
-- 	select 'CurrRank' as Series,'D',	4 as SeriesIdx union all
-- 	select 'ChangeRank' as Series,'D',	5 as SeriesIdx union all
-- 	select 'Contribution' as Series,'D' ,6 as SeriesIdx union all
-- 	select 'TotalContribution' as Series,'N' ,7 as SeriesIdx
-- ) a, (
-- 	select distinct Period,MoneyType,Audi_des,case when CurrRank is null then RANK ( )OVER (PARTITION BY Period,MoneyType order by MAT00 desc )+100 else CurrRank end as CurrRank 
-- 	from dbo.OutputCityPerformance where MoneyType<>'PN'
-- ) b


-- DECLARE TMP_CURSOR CURSOR
-- READ_ONLY
-- FOR select distinct Series  from dbo.[output_stage] where LinkChartCode=@code
-- DECLARE @Series varchar(100)
-- DECLARE @SQL2 VARCHAR(8000)
	
-- OPEN TMP_CURSOR
	
-- FETCH NEXT FROM TMP_CURSOR INTO @Series
-- WHILE (@@FETCH_STATUS <> -1)
-- BEGIN

-- 	IF (@@FETCH_STATUS <> -2)
-- 	BEGIN
-- 		print @Series

-- 		set @SQL2='
-- 			update [output_stage]
-- 			set Y=B.['+@Series+ '] from [output_stage] A inner join dbo.OutputCityPerformance B
-- 			on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X=B.Audi_des
-- 			and a.LinkChartCode = '+''''+@code+''''+' and A.Series='+''''+@Series+''''
-- 		print @SQL2
-- 		exec( @SQL2)

-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
-- go




-- -------------------------
-- --C070
-- -----------------------------
-- delete [output_stage] where LinkChartCode = 'C070'
-- declare @code varchar(10)
-- set @code = 'C070'
-- delete from output_stage where LinkChartCode='C070'
-- insert into [output_stage] (IsShow,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
-- select IsShow,Period, @code as Code, a.Series,a.SeriesIdx,MoneyType,b.Audi_des,b.CurrRank
-- from (
-- 	select 'MAT00' as Series,'Y' as IsShow,1 as SeriesIdx union all
-- 	select 'Growth' as Series,'Y' ,2 as SeriesIdx union all
--     select 'Avg.Growth' as Series,'Y' ,3 as SeriesIdx union all
-- 	select 'CurrRank' as Series,'D',	4 as SeriesIdx union all
-- 	select 'ChangeRank' as Series,'D',	5 as SeriesIdx union all
-- 	select 'Contribution' as Series,'D' ,6 as SeriesIdx union all
-- 	select 'TotalContribution' as Series,'N' ,7 as SeriesIdx
-- ) a, (
-- 	select distinct Period,MoneyType,Audi_des,case when CurrRank is null then RANK ( )OVER (PARTITION BY Period,MoneyType order by MAT00 desc )+100 else CurrRank end as CurrRank 
-- 	from dbo.OutputCityPerformance_BMS10TA where MoneyType<>'PN'
-- ) b


-- DECLARE TMP_CURSOR CURSOR
-- READ_ONLY
-- FOR select distinct Series  from dbo.[output_stage] where LinkChartCode=@code
-- DECLARE @Series varchar(100)
-- DECLARE @SQL2 VARCHAR(8000)
	
-- OPEN TMP_CURSOR
	
-- FETCH NEXT FROM TMP_CURSOR INTO @Series
-- WHILE (@@FETCH_STATUS <> -1)
-- BEGIN

-- 	IF (@@FETCH_STATUS <> -2)
-- 	BEGIN
-- 		print @Series

-- 		set @SQL2='
-- 			update [output_stage]
-- 			set Y=B.['+@Series+ '] from [output_stage] A inner join dbo.OutputCityPerformance_BMS10TA B
-- 			on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X=B.Audi_des
-- 			and a.LinkChartCode = '+''''+@code+''''+' and A.Series='+''''+@Series+''''
-- 		print @SQL2
-- 		exec( @SQL2)

-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
-- go

-- delete from output_stage where series='totalcontribution' and xidx<>1 and linkchartcode in('C060','C070')
-- go

-- ----------------------------
-- --C080
-- ----------------------------
-- delete [output_stage] where LinkChartCode = 'C080'
-- declare @code varchar(10)
-- set @code = 'C080'
-- insert into [output_stage] (IsShow,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
-- select IsShow,Period, @code as Code, a.Series,a.SeriesIdx,MoneyType,b.Prod_des,b.Prod_cod
-- from (
-- 	select 'Product Sales' as Series,'Y' as Isshow,1 as SeriesIdx union all
-- 	select 'Product Growth' as Series,'Y',2 as SeriesIdx union all
-- 	select 'Market Growth' as Series,'Y',3 as SeriesIdx union all
-- 	select 'Market Share' as Series,'Y',4 as SeriesIdx
-- ) a, (
-- 	select distinct Period,MoneyType,Prod_des,Prod_cod 
-- 	from dbo.OutputBMSProdSummaryInChina where [Type]='Market' and MoneyType<>'PN'
-- ) b

-- update [output_stage]
-- set Y=B.MAT00 
-- from [output_stage] A 
-- inner join dbo.OutputBMSProdSummaryInChina B
-- on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X=B.Prod_des
-- 	and a.LinkChartCode =@code and A.Series='Product Sales' and B.[Type]='Product'

-- update [output_stage]
-- set Y=B.Growth 
-- from [output_stage] A 
-- inner join dbo.OutputBMSProdSummaryInChina B
-- on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X=B.Prod_des
-- 	and a.LinkChartCode =@code and A.Series='Product Growth' and B.[Type]='Product'

-- update [output_stage]
-- set Y=B.Growth 
-- from [output_stage] A 
-- inner join dbo.OutputBMSProdSummaryInChina B
-- on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X=B.Prod_des
-- 	and a.LinkChartCode =@code and A.Series='Market Growth' and B.[Type]='Market'

-- update [output_stage]
-- set Y=B.MarketShare 
-- from [output_stage] A 
-- inner join dbo.OutputBMSProdSummaryInChina B
-- on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X=B.Prod_des
-- 	and a.LinkChartCode =@code and A.Series='Market Share' and B.[Type]='Market'




-- go


--------------------------------------------------------------------
--C100
--------------------------------------------------------------------
delete from output_stage where linkchartcode='C100'
go 
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
			set Y=B.['+@Series+ '] from [output_stage] A inner join dbo.OutputKeyMNCsPerformance_HKAPI B
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
delete from output_stage where linkchartcode='C110'
go

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
			set Y=B.['+@Series+ '] 
			from [output_stage] A 
			inner join dbo.OutputKeyMNCsProdPerformance_HKAPI B
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
set timeframe = case timeframe when 'Rolling 3 Months' then 'MQT' else timeframe end
where LinkChartCode between 'C010' and 'C110'
go
update [output_stage]
set series=
	case series 
	when 'CurrRank' then 'Rank' 
	when 'ChangeRank' then 'Change in Rank' 
	when 'Share' then 'Contribution ('+
		case when timeFrame like '%Current 3 Month%' then 'Cur 3 M' 
		else timeframe 
		end+')' 
	else series 
	end
where linkchartcode in('C100','C110') and timeFrame in ('YTD', 'MAT', 'MQT', 'MTH')
go
update [output_stage]
set series=
	case series 
	when 'CurrRank' then 'Rank' 
	when 'ChangeRank' then 'Change in Rank' 
	when 'Share' then 'Contribution ('+(select cast(year-1 as varchar(6)) from tblDateHKAPI)+')' 
	else series 
	end
where linkchartcode in('C100','C110') and timeFrame='Last Year'
go
update [output_stage]
set series=
	case series 
	when 'Avg.Growth' then 'Avg. Growth' 
	when 'CurrRank' then 'Rank' 
	when 'ChangeRank' then 'Change in Rank' 
	when 'Contribution' then 'Contribution ('+
		case when timeFrame like '%Current 3 Month%' then 'Cur 3 M' 
		else timeframe 
		end+')' 
	else series 
	end
where linkchartcode in('C060','C070')
go
update [output_stage]
set LinkSeriesCode=LinkChartCode+timeframe+Series+cast(SeriesIdx as varchar(10))
where LinkChartCode between 'C010' and 'C110'
go
update [output_stage]
set Category=case Currency when 'UN' then 'Units' else 'Value' end
where LinkChartCode between 'C010' and 'C110'
go
update [output_stage]
set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' else Currency end 
where LinkChartCode between 'C010' and 'C110'
go
update [output_stage]
set series=
	case series 
		when 'MAT00' then (select cast(year-1 as varchar(6)) from tblDateHKAPI)
		when 'MAT12' then (select cast(year-2 as varchar(6)) from tblDateHKAPI)
		when 'MAT00Growth' then  (select cast(year-1 as varchar(6)) from tblDateHKAPI)+' Growth'
		else series
	end 
where linkchartcode in('C100','C110')and timeFrame='Last Year'
go
update [output_stage]
set series=
	case series when 'MAT00' then 'YTD '+(select [Month]+''''+right(year,2) from tblDateHKAPI)
		when 'MAT12' then 'YTD '+(select [Month]+''''+right(year-1,2) from tblDateHKAPI)
		when 'MAT00Growth' then  'YTD '+(select [Month]+''''+right(year,2) from tblDateHKAPI)+' Growth'
		else series
	end 
where linkchartcode in('C100','C110') and timeFrame in ('YTD', 'MAT', 'MTH')
go
update [output_stage]
set series=
	case series when 'MAT00' then 'MQT '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'MAT12' then 'MQT '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'MAT00Growth' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=1)+' Growth'
		when 'MAT12Growth' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=13)+' Growth'
		else series
	end 
where linkchartcode between 'C010' and 'C110' and timeFrame='MQT'
go
update [output_stage]
set series=
	case series 
		when 'MAT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'MAT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'MAT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)
		when 'MAT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)
		when 'MAT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)
		when 'MAT00Growth' then  TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)+' Growth'
		when 'MAT12Growth' then  TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)+' Growth'
		else series
	end 
where LinkChartCode between 'C010' and 'C110' and timeFrame<>'Last Year'
go
update [output_stage]
set X=
	case X when 'MAT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'MAT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'MAT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)
		when 'MAT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)
		when 'MAT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)
		else X
	end 
where  LinkChartCode between 'C010' and 'C110' and timeFrame<>'Last Year'
go


update [output_stage]
set Product='Portfolio',
    Lev='Nation',
    geo='China'
where LinkChartCode between 'C010' and 'C110'
go




---------------------------------------------------------
-- C120
---------------------------------------------------------
delete from output_stage where linkchartcode='C120'
GO

declare @code varchar(10)
set @code = 'C120'

insert into [output_stage] (Product,isshow,geo,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select 
	B.market            --Product      
	, 'Y'               --isshow       
	,'China'            --geo          
	,'Nation'           --lev          
	,Period             --TimeFrame    
	, @code as Code     --LinkChartCode
	, b.[type]          -- Series      
	,b.typeIdx          -- SeriesIdx   
	,MoneyType          --Currency     
	, a.Series          -- X           
	,a.SeriesIdx        -- XIdx        
from (
	select 'MAT00' as Series,	22 as SeriesIdx union all
	select 'MAT12' as Series,	21 as SeriesIdx union all
	select 'MAT24' as Series,	20 as SeriesIdx union all
	select 'MAT36' as Series,	19 as SeriesIdx union all
	select 'MAT48' as Series,	18 as SeriesIdx union all

	select 'Mth06' as Series,	7 as SeriesIdx union all
	select 'Mth07' as Series,	6 as SeriesIdx union all
	select 'Mth08' as Series,	5 as SeriesIdx union all
	select 'Mth09' as Series,	4 as SeriesIdx union all
	select 'Mth10' as Series,	3 as SeriesIdx union all
	select 'Mth11' as Series,	2 as SeriesIdx union all
	select 'Mth12' as Series,	1 as SeriesIdx
) a, (
	select distinct [type], typeIdx,Period,MoneyType,market 
    from dbo.OutputProdSalesPerformanceInChina where market<>'Paraplatin' and MoneyType<>'PN'
    union all
    select distinct [type], typeIdx,Period,MoneyType,market 
    from dbo.OutputProdSalesPerformanceInChina where market='Paraplatin'  and MoneyType<>'UN'
) b
where b.market not in ( 'Eliquis (NOAC)','Eliquis (VTet)')

update [dbo].[output_stage]
set X = case 
	when TimeFrame = 'YTD' and X not like 'Mth%' then 'YTD' + right(X, 2) 
	when TimeFrame = 'MQT' and X not like 'Mth%' then 'MQT' + right(X, 2) 
	else X end 
where LinkChartCode = @code

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
		--print @Series

		set @SQL2='
		update [output_stage]
		set Y=B.['+@Series+ '] 
		from [output_stage] A 
		inner join dbo.OutputProdSalesPerformanceInChina B
		on A.TimeFrame=B.Period and A.Currency=B.MoneyType  and A.Product=B.Market and A.X='+''''+@Series+''''+'
			and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.[type]'
		--print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
update [output_stage] 
set product='Eliquis VTEP'
from [output_stage] 
where Product ='ELIQUIS (VTEP)' and LinkChartCode='C120'

update output_stage
set timeframe=case timeframe when 'Rolling 3 Months' then 'MQT' else timeframe end
where LinkChartCode='C120'
go
update [output_stage]
set LinkSeriesCode=Product+'_'+LinkChartCode+Series+cast(SeriesIdx as varchar(10)) 
where LinkChartCode='C120'
go
update [output_stage]
set Category=case Currency when 'UN' then 'Units' when 'PN' then 'Adjusted patient number' else 'Value' end
where LinkChartCode='C120'
go
update [output_stage]
set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' when 'PN' then 'UNIT' 
else Currency end 
where LinkChartCode='C120'
go
delete from [output_stage] where LinkChartCode='C120' and timeFrame<>'Mth' and X like 'Mth%'
go

update [output_stage] 
set series=case series 
	when 'MAT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
	when 'MAT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)
	when 'MAT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)
	when 'MAT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)
	when 'MAT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)
	when 'MAT00Growth' then  TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)+' Growth'
	when 'MAT12Growth' then  TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)+' Growth'
	
	when 'YTD00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
	when 'YTD12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)
	when 'YTD24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)
	when 'YTD36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)
	when 'YTD48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)
	when 'YTD00Growth' then  TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)+' Growth'
	when 'YTD12Growth' then  TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)+' Growth'
	
	when 'MQT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
	when 'MQT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)
	when 'MQT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)
	when 'MQT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)
	when 'MQT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)
	when 'MQT00Growth' then  TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)+' Growth'
	when 'MQT12Growth' then  TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)+' Growth'
else series
end  where LinkChartCode='C120' and TimeFrame<>'MTH'
go
update [output_stage]
set X=case X 
		when 'MAT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'MAT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'MAT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)
		when 'MAT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)
		when 'MAT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)

		
		when 'MQT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'MQT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'MQT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)
		when 'MQT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)
		when 'MQT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)

		
		when 'YTD00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'YTD12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'YTD24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)
		when 'YTD36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)
		when 'YTD48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)
		else X
	end  
where LinkChartCode='C120' and TimeFrame<>'MTH'
go

update [output_stage]
set series=case series 
			when 'MAT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
			when 'MAT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=2)
			when 'MAT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=3)
			when 'MAT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=4)
			when 'MAT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=5)
			
			when 'MQT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
			when 'MQT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=2)
			when 'MQT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=3)
			when 'MQT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=4)
			when 'MQT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=5)
			
			when 'YTD00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
			when 'YTD12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=2)
			when 'YTD24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=3)
			when 'YTD36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=4)
			when 'YTD48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=5)

			when 'Mth06' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=6)
			when 'Mth07' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=7)
			when 'Mth08' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=8)
			when 'Mth09' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=9)
			when 'Mth10' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=10)
			when 'Mth11' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=11)
			when 'Mth12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=12)
			else series
			end  
where LinkChartCode='C120' and TimeFrame='MTH'
go
update [output_stage]
set X=case X 
		when 'MAT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'MAT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=2)
		when 'MAT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=3)
		when 'MAT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=4)
		when 'MAT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=5)
		
		when 'MQT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'MQT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=2)
		when 'MQT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=3)
		when 'MQT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=4)
		when 'MQT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=5)
		
		when 'YTD00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'YTD12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=2)
		when 'YTD24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=3)
		when 'YTD36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=4)
		when 'YTD48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=5)

		when 'Mth06' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=6)
		when 'Mth07' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=7)
		when 'Mth08' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=8)
		when 'Mth09' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=9)
		when 'Mth10' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=10)
		when 'Mth11' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=11)
		when 'Mth12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=12)
		else X
		end  
where LinkChartCode='C120' and TimeFrame='MTH'
go
update [output_stage]
set LinkedY=b.LinkY 
from [output_stage] A 
inner join
(
	select product,min(parentgeo) as LinkY  
	from outputgeo 
	where lev=2
	group by product
) B
on A.product=B.product
where A.LinkChartCode='C120'
go
update [output_stage]
set LinkedY=b.LinkY 
from [output_stage] A 
inner join(
	select product,min(parentgeo) as LinkY  from outputgeo where lev=2
	group by product) B
on left(A.product,7)=B.product
where A.LinkChartCode='C120' and a.product like 'ELIQUIS%'
go
update [output_stage] 
set Category='Adjusted patient number'
from [output_stage] 
where Product ='Paraplatin' and LinkChartCode='C120' and Category='Dosing Units'










--------------------------------------------
-- C130
--------------------------------------------
delete from output_stage where linkchartcode='C130'
GO

declare @code varchar(10)
set @code = 'C130'

--正常MQT
insert into [output_stage] (Product,isshow,geo,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select B.market, 'Y','China','Nation',Period, @code as Code, b.Productname,b.Prod,MoneyType, a.Series,a.SeriesIdx
from (
	select 'MAT00' as Series,	5 as SeriesIdx union all
	select 'MAT12' as Series,	4 as SeriesIdx union all
	select 'MAT24' as Series,	3 as SeriesIdx union all
	select 'MAT36' as Series,	2 as SeriesIdx union all
	select 'MAT48' as Series,	1 as SeriesIdx
) a, (
		select distinct Productname, Prod,Period,MoneyType,market 
		from dbo.OutputKeyBrandPerformance_For_OtherETV 
		where market not in ('Taxol','Paraplatin','eliquis noac','Eliquis VTEt') 
			and not (market = 'Eliquis VTep' and Prod = '600' ) and MoneyType<>'PN'
	union all
		select distinct Productname, Prod,Period,MoneyType,market 
		from dbo.OutputKeyBrandPerformance_For_OtherETV 
		where market = 'Taxol' and Period<>'MQT' and MoneyType<>'PN' 
	union all
		select distinct Productname, Prod,Period,MoneyType,market 
		from dbo.OutputKeyBrandPerformance_For_OtherETV 
		where market = 'Paraplatin' and Period<>'MQT' and MoneyType<>'UN' 
) b



--间隔的MQT
insert into [output_stage] (Product,isshow,geo,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select B.market, 'Y','China','Nation',Period, @code as Code, b.Productname,b.Prod,MoneyType, a.Series,a.SeriesIdx
from (
	select 'MAT00' as Series,	5 as SeriesIdx union all
	select 'MAT12' as Series,	4 as SeriesIdx union all
	select 'MAT24' as Series,	3 as SeriesIdx union all
	select 'MAT36' as Series,	2 as SeriesIdx union all
	select 'MAT48' as Series,	1 as SeriesIdx
) a, (
	select distinct Productname, Prod,Period,MoneyType,market 
	from dbo.OutputKeyBrandPerformance_For_OtherETV 
    where market = 'Taxol' and Period = 'MQT' and MoneyType<>'PN' 
	union all
	select distinct Productname, Prod,Period,MoneyType,market 
	from dbo.OutputKeyBrandPerformance_For_OtherETV 
    where market = 'Paraplatin' and Period = 'MQT' and MoneyType<>'UN' 
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
		inner join dbo.OutputKeyBrandPerformance_For_OtherETV B
		on A.TimeFrame=B.Period and A.Currency=B.MoneyType  and A.Product=B.Market and A.X='+''''+@Series+''''+'
			and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname'
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go

declare @code varchar(10)
set @code = 'C130'
---Baraclude Modification: Add two line('Entecavir','Adefovir Dipivoxil')
insert into [output_stage] (Product,isshow,geo,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select B.market, 'Y','China','Nation',Period, @code as Code, b.Productname,b.Prod,MoneyType, a.Series,a.SeriesIdx
from (
	select 'MAT00' as Series,	5 as SeriesIdx union all
	select 'MAT12' as Series,	4 as SeriesIdx union all
	select 'MAT24' as Series,	3 as SeriesIdx union all
	select 'MAT36' as Series,	2 as SeriesIdx union all
	select 'MAT48' as Series,	1 as SeriesIdx
) a, (
	select distinct Productname, Prod,Period,MoneyType,market from dbo.OutputKeyBrandPerformance_For_Baraclude_Modify 
	where MoneyType<>'PN'
) b


DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR 
select distinct X  
from dbo.[output_stage] 
where LinkChartCode=@code and product = 'Baraclude' and series in ('Entecavir','Adefovir Dipivoxil')
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
			set Y=B.'+@Series+ ' from [output_stage] A 
			inner join dbo.OutputKeyBrandPerformance_For_Baraclude_Modify B
			on A.TimeFrame=B.Period and A.Currency=B.MoneyType  and A.Product=B.Market and A.X='+''''+@Series+''''+'
				and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname'
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go


update [output_stage]
set LinkSeriesCode=Product+'_'+LinkChartCode+Series+cast(SeriesIdx as varchar(10)) 
where LinkChartCode='C130'
go
update [output_stage]
set Category=case Currency when 'UN' then 'Units' when 'PN' then 'Adjusted patient number' else 'Value' end
where LinkChartCode='C130'
go
update [output_stage]
set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' when 'PN' then 'UNIT'  else Currency end 
where LinkChartCode='C130'
go
go
declare @i int,@sql varchar(8000)
set @i=0
set @sql='update [output_stage]
set X=case X '
while (@i<=24)
begin
	set @sql=@sql+'
	when ''MAT'+right('00'+cast(@i as varchar(2)),2)+''' then TimeFrame + '' ''+(select [MonthEN] from tblMonthList where monseq='+cast(@i+1 as varchar(2))+')'
	set @i=@i+1
end
set @sql=@sql+'else X
end  where LinkChartCode=''C130'''
exec(@sql)
GO


	--
	--select distinct Category,[Currency]
	--FROM output_stage where [LinkChartCode]='C130'  and Product ='Paraplatin'
	--
	--
	--select distinct Category,[Currency]
	--FROM output_stage where [LinkChartCode]='C130'  and Product <> 'Paraplatin'










------------------------------------------------------
-- C201
------------------------------------------------------
delete [output_stage] where LinkChartCode = 'C201'

declare @code varchar(10)
set @code = 'C201'

insert into [output_stage] (Product,geo,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select B.market,'China','Nation',Period, @code as Code, b.ProductName,b.ProdIdx,MoneyType, a.Series,a.SeriesIdx
from (
	select 'MAT00' as Series,	5 as SeriesIdx union all
	select 'MAT12' as Series,	4 as SeriesIdx union all
	select 'MAT24' as Series,	3 as SeriesIdx union all
	select 'MAT36' as Series,	2 as SeriesIdx union all
	select 'MAT48' as Series,	1 as SeriesIdx
) a, (
	select distinct market,[type],Period,MoneyType,case [type] when 'Sales' then Productname else Productname+' '+[Type] end as Productname,ProdIdx 
	from dbo.OutputCMLChinaMarketTrend where market<>'Paraplatin' and MoneyType<>'PN'
	union all
	select distinct market,[type],Period,MoneyType,case [type] when 'Sales' then Productname else Productname+' '+[Type] end as Productname,ProdIdx 
	from dbo.OutputCMLChinaMarketTrend where market='Paraplatin'
) b
where (B.[Type] like '%CAGR%' and A.Series='MAT00') or B.[type] not like '%CAGR%'

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
		inner join dbo.OutputCMLChinaMarketTrend B
		on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=case B.[type] when ''Sales'' then B.Productname else B.Productname+'' ''+B.[Type] end and A.SeriesIdx=B.ProdIdx'
--		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
update output_stage
set isshow=case when seriesidx in (900) then 'N' else 'Y' end
where linkchartcode='C201'
GO

update [output_stage]
set X=case 
	when X = 'MAT00' and TimeFrame = 'MAT' then 'MAT' + ' '+(select [MonthEN] from tblMonthList where monseq=1)
	when X = 'MAT12' and TimeFrame = 'MAT' then 'MAT' + ' '+(select [MonthEN] from tblMonthList where monseq=13)
	when X = 'MAT24' and TimeFrame = 'MAT' then 'MAT' + ' '+(select [MonthEN] from tblMonthList where monseq=25)
	when X = 'MAT36' and TimeFrame = 'MAT' then 'MAT' + ' '+(select [MonthEN] from tblMonthList where monseq=37)
	when X = 'MAT48' and TimeFrame = 'MAT' then 'MAT' + ' '+(select [MonthEN] from tblMonthList where monseq=49)
 
	when X = 'MAT00' and TimeFrame = 'MTH' then 'MTH' + ' '+(select [MonthEN] from tblMonthList where monseq=1)
	when X = 'MAT12' and TimeFrame = 'MTH' then 'MTH' + ' '+(select [MonthEN] from tblMonthList where monseq=13)
	when X = 'MAT24' and TimeFrame = 'MTH' then 'MTH' + ' '+(select [MonthEN] from tblMonthList where monseq=25)
	when X = 'MAT36' and TimeFrame = 'MTH' then 'MTH' + ' '+(select [MonthEN] from tblMonthList where monseq=37)
	when X = 'MAT48' and TimeFrame = 'MTH' then 'MTH' + ' '+(select [MonthEN] from tblMonthList where monseq=49)
 
	when X = 'MAT00' and TimeFrame = 'MQT' then 'MQT' + ' '+(select [MonthEN] from tblMonthList where monseq=1)
	when X = 'MAT12' and TimeFrame = 'MQT' then 'MQT' + ' '+(select [MonthEN] from tblMonthList where monseq=13)
	when X = 'MAT24' and TimeFrame = 'MQT' then 'MQT' + ' '+(select [MonthEN] from tblMonthList where monseq=25)
	when X = 'MAT36' and TimeFrame = 'MQT' then 'MQT' + ' '+(select [MonthEN] from tblMonthList where monseq=37)
	when X = 'MAT48' and TimeFrame = 'MQT' then 'MQT' + ' '+(select [MonthEN] from tblMonthList where monseq=49)
	
	when X = 'MAT00' and TimeFrame = 'YTD' then 'YTD' + ' '+(select [MonthEN] from tblMonthList where monseq=1)
	when X = 'MAT12' and TimeFrame = 'YTD' then 'YTD' + ' '+(select [MonthEN] from tblMonthList where monseq=13)
	when X = 'MAT24' and TimeFrame = 'YTD' then 'YTD' + ' '+(select [MonthEN] from tblMonthList where monseq=25)
	when X = 'MAT36' and TimeFrame = 'YTD' then 'YTD' + ' '+(select [MonthEN] from tblMonthList where monseq=37)
	when X = 'MAT48' and TimeFrame = 'YTD' then 'YTD' + ' '+(select [MonthEN] from tblMonthList where monseq=49)
	else X
	end  
where LinkChartCode in('C201') and timeFrame in ('MAT Month', 'MTH', 'MQT', 'YTD')
go
update [output_stage]
set X=case X 
	when 'MAT00' then 'MAT' + ' '+(select top 1 right([year],2)+'Q'+cast((Month)/3 as varchar(3)) from tblmonthlist where (Month)/3<>0 order by monseq)
	when 'MAT12' then 'MAT' + ' '+(select top 1 right([year]-1,2)+'Q'+cast((Month)/3 as varchar(3)) from tblmonthlist where (Month)/3<>0 order by monseq)
	when 'MAT24' then 'MAT' + ' '+(select top 1 right([year]-2,2)+'Q'+cast((Month)/3 as varchar(3)) from tblmonthlist where (Month)/3<>0 order by monseq)
	when 'MAT36' then 'MAT' + ' '+(select top 1 right([year]-3,2)+'Q'+cast((Month)/3 as varchar(3)) from tblmonthlist where (Month)/3<>0 order by monseq)
	when 'MAT48' then 'MAT' + ' '+(select top 1 right([year]-4,2)+'Q'+cast((Month)/3 as varchar(3)) from tblmonthlist where (Month)/3<>0 order by monseq)
	else X
	end  
where LinkChartCode in('C201') and timeFrame='MAT Quarter'
go



-----------------------------
--C210   
-----------------------------
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
			set Y=B.'+@Series+ ' 
			from [output_stage] A 
			inner join dbo.OutputCMLChina_HKAPI B
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
set X=case X 
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
	end  
where LinkChartCode in('C210')
go
update [output_stage]
set Series=case Series when 'MAT00' then TimeFrame + (select ' '+right(year-1,2)+'Q4' from tblDateHKAPI)
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
	end  
where LinkChartCode in('C210')
go
update [output_stage]
set LinkSeriesCode=Product+'_'+LinkChartCode+Series+cast(SeriesIdx as varchar(10))+Currency 
where LinkChartCode in('C201','C210')
go
update [output_stage]
set Category=case Currency when 'UN' then 'Units' else 'Value' end
where LinkChartCode in('C201','C210')
go
update [output_stage]
set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' else Currency end 
where LinkChartCode in('C201','C210')
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
		on A.Currency=B.MoneyType and A.X='+''''+@Series+'''
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Product'
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR

update [output_stage]
set X=case X 
	when 'Qtr00' then '2016Q4'      --todo --Modify by xiaoyu.chen 20130=-08-19
	when 'Qtr01' then '2016Q3'
	when 'Qtr02' then '2016Q2'
	when 'Qtr03' then '2015Q1'
	when 'Qtr04' then '2015Q4'
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



---------------------------------------------------
-- D021 D031 D041 
---------------------------------------------------

delete from output_stage where linkchartcode in('D021','D031','D041')
--exclude Onglyza
declare @code varchar(10),@i int,@sql varchar(8000)
set @i=0
set @code = 'D021'
set @sql=''
set @sql=@sql+'insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
select isshow,A.Period, '+''''+@code+''''+' as Code, Market,B.Audi_des,B.Audi_cod,MoneyType,a.Series,a.SeriesIdx, ''Region'' as lev,B.region
from ('
while (@i<=11)
begin
	set @sql=@sql+'
	select  ''MQT'' as Period,'+''''+'R3M'+right('00'+cast(@i as varchar(3)),2)+''+''''+' as Series,''Y'' as isshow,'+cast(18-@i+1 as varchar(3))+' as SeriesIdx union all
	select  ''MTH'' as Period,'+''''+'MTH'+right('00'+cast(@i as varchar(3)),2)+''+''''+' as Series,''Y'' as isshow,'+cast(18-@i+1 as varchar(3))+' as SeriesIdx union all
	select  ''MAT'' as Period,'+''''+'MAT'+right('00'+cast(@i as varchar(3)),2)+''+''''+' as Series,''Y'' as isshow,'+cast(18-@i+1 as varchar(3))+' as SeriesIdx union all
	select  ''YTD'' as Period,'+''''+'YTD'+right('00'+cast(@i as varchar(3)),2)+''+''''+' as Series,''Y'' as isshow,'+cast(18-@i+1 as varchar(3))+' as SeriesIdx union all
	'
	set @i=@i+1
end
set  @sql=left(@sql,len(@sql)-12)+' 
	Union all
	select  ''YTD'' as Period,''YTD00'' as series,''D'' as ishow,21 as SeriesIdx union all
	select  ''YTD'' as Period,''YTD12'' as series,''D'' as ishow,20 as SeriesIdx
	) a, (
		select distinct MoneyType,mkt,Market,Prod,Productname,Audi_cod,Audi_des,region 
		from  dbo.OutputGeoHBVSummaryT1 where Class=''N'' and Mkt<>''DPP4'' and mkt <> ''Eliquis NOAC'' and Market<>''Paraplatin''
		union all
		select distinct MoneyType,mkt,Market,Prod,Productname,Audi_cod,Audi_des,region 
		from  dbo.OutputGeoHBVSummaryT1 where Class=''N'' and Mkt<>''DPP4'' and mkt <> ''Eliquis NOAC'' and Market=''Paraplatin'' and prod=''100''
	) b'
print @sql
exec (@sql)

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
			set Y=B.['+@Series+ '] 
			from [output_stage] A 
			inner join dbo.OutputGeoHBVSummaryT1 B
			on A.Product=B.Market and A.X='+''''+@Series+''''+' and A.currency=b.Moneytype
				and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Audi_des and A.geo=B.region and B.Class=''N'' and Mkt<>''DPP4''
				'
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go

delete from output_stage where linkchartcode in('D021') and Product <> 'Baraclude' and TimeFrame = 'MTH'
go

-- --Onglyza DPP4
-- declare @code varchar(10),@i int,@sql varchar(8000)
-- set @i=0
-- set @code = 'D041'
-- set @sql=''
-- set @sql=@sql+'insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
-- select isshow,A.Period, '+''''+@code+''''+' as Code, Market,B.Audi_des,B.Audi_cod,MoneyType,a.Series,a.SeriesIdx, ''Region'' as lev,B.region
-- from ('
-- --print @sql
-- while (@i<=11)
-- begin
-- set @sql=@sql+'select  ''MQT'' as Period,'+''''+'R3M'+right('00'+cast(@i as varchar(3)),2)+''+''''+' as Series,''Y'' as isshow,'+cast(18-@i+1 as varchar(3))+' as SeriesIdx union all
-- '
-- set @i=@i+1
-- end
-- set  @sql=left(@sql,len(@sql)-12)+' Union all
-- select  ''YTD'' as Period,''YTD00'' as series,''D'' as ishow,21 as SeriesIdx union all
-- select  ''YTD'' as Period,''YTD12'' as series,''D'' as ishow,20 as SeriesIdx) a, (
-- 	select distinct MoneyType,mkt,Market,Prod,Productname,Audi_cod,Audi_des,region from  dbo.OutputGeoHBVSummaryT1 where Class=''N'' and Mkt=''DPP4''
-- ) b'
-- print @sql
-- exec (@sql)

-- DECLARE TMP_CURSOR CURSOR
-- READ_ONLY
-- FOR select distinct X  from dbo.[output_stage] where LinkChartCode=@code
-- DECLARE @Series varchar(100)
-- DECLARE @SQL2 VARCHAR(8000)
	
-- OPEN TMP_CURSOR
	
-- FETCH NEXT FROM TMP_CURSOR INTO @Series
-- WHILE (@@FETCH_STATUS <> -1)
-- BEGIN

-- 	IF (@@FETCH_STATUS <> -2)
-- 	BEGIN
-- 		print @Series

-- 		set @SQL2='
-- 		update [output_stage]
-- 		set Y=B.['+@Series+ '] from [output_stage] A inner join dbo.OutputGeoHBVSummaryT1 B
-- 		on A.Product=B.Market and A.X='+''''+@Series+''''+' and A.currency=b.Moneytype
-- 		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Audi_des and A.geo=B.region and B.Class=''N'' and Mkt=''DPP4'''
-- 		print @SQL2
-- 		exec( @SQL2)

-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR

-- go

delete from output_stage where linkchartcode='D031'
declare @code varchar(10),@i int,@sql varchar(8000)
set @i=0
set @code = 'D031'
set @sql=''
set @sql=@sql+'insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
select isshow,A.Period, '+''''+@code+''''+' as Code, Market,B.Audi_des,B.Audi_cod,MoneyType,a.Series,a.SeriesIdx, ''Region'' as lev,B.region
from ('
--print @sql
while (@i<=11)
begin
set @sql=@sql+'
select  ''MQT'' as Period,'+''''+'R3M'+right('00'+cast(@i as varchar(3)),2)+''+''''+' as Series,''Y'' as isshow,'+cast(18-@i+1 as varchar(3))+' as SeriesIdx union all
select  ''MAT'' as Period,'+''''+'MAT'+right('00'+cast(@i as varchar(3)),2)+''+''''+' as Series,''Y'' as isshow,'+cast(18-@i+1 as varchar(3))+' as SeriesIdx union all
select  ''MTH'' as Period,'+''''+'MTH'+right('00'+cast(@i as varchar(3)),2)+''+''''+' as Series,''Y'' as isshow,'+cast(18-@i+1 as varchar(3))+' as SeriesIdx union all
'
set @i=@i+1
end
set  @sql=left(@sql,len(@sql)-11)+' Union all
select  ''YTD'' as Period,''YTD00'' as series,''D'' as ishow,21 as SeriesIdx union all
select  ''YTD'' as Period,''YTD12'' as series,''D'' as ishow,20 as SeriesIdx) a, (
	select distinct MoneyType,mkt,Market,Prod,Productname,Audi_cod,Audi_des,region from  dbo.OutputGeoHBVSummaryT1 where Class=''Y''
) b'
print @sql
exec (@sql)

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
		set Y=B.['+@Series+ '] 
		from [output_stage] A 
		inner join dbo.OutputGeoHBVSummaryT1 B
		on A.Product=B.Market and A.X='+''''+@Series+''''+' and A.currency=b.Moneytype
			and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Audi_des and A.geo=B.region and B.Class=''Y'''
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR

go
update [output_stage]
set LinkSeriesCode=Product+'_'+LinkChartCode+'_'+geo+cast(SeriesIdx as varchar(10))+Isshow 
where LinkChartCode in('D021','D031','D041')
go
update [output_stage]
set Category=case Currency when 'UN' then 'Units' else 'Value' end
where LinkChartCode in('D021','D031','D041')
go
update [output_stage]
set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' else Currency end 
where LinkChartCode in('D021','D031','D041')
go

delete from [output_stage] 
where LinkChartCode in('D021') and Product in ('Taxol','paraplatin') and TimeFrame='MQT'
	and x not in(
		'R3M00','R3M03','R3M06','R3M09','R3M12','R3M15','R3M18'
	)
GO

update [output_stage]
set X=case X 
		when 'R3M00' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'R3M01' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=2)
		when 'R3M02' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=3)
		when 'R3M03' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=4)
		when 'R3M04' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=5)
		when 'R3M05' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=6)
		when 'R3M06' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=7)
		when 'R3M07' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=8)
		when 'R3M08' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=9)
		when 'R3M09' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=10)
		when 'R3M10' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=11)
		when 'R3M11' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=12)
		when 'R3M12' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'R3M13' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=14)
		when 'R3M14' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=15)
		when 'R3M15' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=16)
		when 'R3M16' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=17)
		when 'R3M17' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=18)
		when 'R3M18' then  'MQT '+(select [MonthEN] from tblMonthList where monseq=19)

		when 'MTH00' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'MTH01' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=2)
		when 'MTH02' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=3)
		when 'MTH03' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=4)
		when 'MTH04' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=5)
		when 'MTH05' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=6)
		when 'MTH06' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=7)
		when 'MTH07' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=8)
		when 'MTH08' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=9)
		when 'MTH09' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=10)
		when 'MTH10' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=11)
		when 'MTH11' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=12)
		when 'MTH12' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'MTH13' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=14)
		when 'MTH14' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=15)
		when 'MTH15' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=16)
		when 'MTH16' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=17)
		when 'MTH17' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=18)
		when 'MTH18' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=19)

		when 'MAT00' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'MAT01' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=2)
		when 'MAT02' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=3)
		when 'MAT03' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=4)
		when 'MAT04' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=5)
		when 'MAT05' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=6)
		when 'MAT06' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=7)
		when 'MAT07' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=8)
		when 'MAT08' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=9)
		when 'MAT09' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=10)
		when 'MAT10' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=11)
		when 'MAT11' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=12)
		when 'MAT12' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'MAT13' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=14)
		when 'MAT14' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=15)
		when 'MAT15' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=16)
		when 'MAT16' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=17)
		when 'MAT17' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=18)
		when 'MAT18' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=19)

		when 'YTD00' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'YTD12' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=13)
		else X
end  where LinkChartCode in('D021','D031','D041') and TimeFrame in ('MQT','YTD', 'MAT', 'MTH')
go

update [output_stage]
set X=case X 
		when 'MTH00' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'MTH01' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=2)
		when 'MTH02' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=3)
		when 'MTH03' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=4)
		when 'MTH04' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=5)
		when 'MTH05' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=6)
		when 'MTH06' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=7)
		when 'MTH07' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=8)
		when 'MTH08' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=9)
		when 'MTH09' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=10)
		when 'MTH10' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=11)
		when 'MTH11' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=12)
		when 'MTH12' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'MTH13' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=14)
		when 'MTH14' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=15)
		when 'MTH15' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=16)
		when 'MTH16' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=17)
		when 'MTH17' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=18)
		when 'MTH18' then  'MTH '+(select [MonthEN] from tblMonthList where monseq=19)
		when 'YTD00' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'YTD12' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=13)
		else X
end  where LinkChartCode in('D021')  and TimeFrame='MTH'
go


	--------------------------------------------
	--D022
	--------------------------------------------
	delete from output_stage where linkchartcode  in('D022','D032','D042')
	GO

	declare @code varchar(10),@i int,@sql varchar(8000)
	set @i=0
	set @code = 'D022'

	----1. 'Y' 
	insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
	select 
	  'Y'               --isshow          
	 , B.Period         --TimeFrame      
	 , @code as Code    --LinkChartCode  
	 , A.Market         --Product        
	 , A.Productname    --Series         
	 , A.Prod           --SeriesIdx      
	 , moneytype        --Currency       
	 , a.Audi_des       --X              
	 , a.Audi_cod       --XIdx           
	 , 'Region' as lev  --lev            
	 , A.region         --geo            
	from 
	(
	  select 
		A.*
	   ,b.Audi_cod
	   ,B.Audi_des 
	  from (
		   select distinct MoneyType,mkt,Market,Prod,Productname,region
		   from dbo.OutputGeoHBVSummaryT2_For_OtherETV 
		   where Class = 'N' and Mkt not in ('DPP4','eliquis noac','Eliquis VTet') and not (mkt = 'Eliquis VTep' and Prod = '600'  )
		   ) A 
	  inner join
		  (
		   select distinct MoneyType,mkt,Market,Audi_cod,Audi_des,region
		   from dbo.OutputGeoHBVSummaryT2_For_OtherETV 
		   where Class = 'N' and Mkt not in ('DPP4','eliquis noac','Eliquis VTet') and not (mkt = 'Eliquis VTep' and Prod = '600'  )
		   ) B
	  on A.moneytype=b.moneytype and a.mkt=b.mkt and a.market=b.market and a.region=b.region
	) a ,
	(
	  select 'MQT' as Period union all 
	  select 'YTD' as Period union all 
	  select 'MAT' as Period union all 
	  select 'MTH' as Period 
	) B

	--1.1 MQT
	update [output_stage] set 
	  Y = case B.type when 'Market Total' then convert(varchar(50),cast(B.R3M00 as float),1) 
					  else B.R3M00 end
	 ,IntY = case B.type when 'Market Total' then cast(B.R3M00 as float) end   
	from [output_stage] A inner join dbo.OutputGeoHBVSummaryT2_For_OtherETV B
	on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
	and A.timeFrame='MQT'where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y' and B.Mkt<>'DPP4'

	--1.2 YTD
	update [output_stage] set 
	  Y = case B.type when 'Market Total' then convert(varchar(50),cast(B.YTD00 as float),1) 
					  else B.YTD00 end
	 ,IntY = case B.type when 'Market Total' then cast(B.YTD00 as float) end  
	from [output_stage] A inner join dbo.OutputGeoHBVSummaryT2_For_OtherETV B
	on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
	and A.timeFrame='YTD'where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y' and B.Mkt<>'DPP4'

	--1.3 MAT
	update [output_stage] set 
	  Y = case B.type when 'Market Total' then convert(varchar(50),cast(B.MAT00 as float),1) 
					  else B.MAT00 end
	 ,IntY = case B.type when 'Market Total' then cast(B.MAT00 as float) end  
	from [output_stage] A inner join dbo.OutputGeoHBVSummaryT2_For_OtherETV B
	on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
	and A.timeFrame='MAT' where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y' and B.Mkt<>'DPP4'

	--1.4 MTH
	update [output_stage] set 
	  Y = case B.type when 'Market Total' then convert(varchar(50),cast(B.MTH00 as float),1) 
					  else B.MTH00 end
	 ,IntY = case B.type when 'Market Total' then cast(B.MTH00 as float) end  
	from [output_stage] A inner join dbo.OutputGeoHBVSummaryT2_For_OtherETV B
	on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
	and A.timeFrame='MTH' where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y' and B.Mkt<>'DPP4'


	----2. 'L'
	insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
	select 
	  'L'                --isshow         
	 , B.Period          --TimeFrame      
	 , @code as Code     --LinkChartCode  
	 , A.Market          --Product        
	 , A.Productname     --Series         
	 , A.Prod            --SeriesIdx      
	 , moneytype         --Currency       
	 , a.Audi_des        --X              
	 , a.Audi_cod        --XIdx           
	 , 'Region' as lev   --lev            
	 , A.region          --geo            
	from 
	  (
		 select 
		   A.*
		  ,b.Audi_cod
		  ,B.Audi_des 
		 from (
			   select distinct MoneyType,mkt,Market,Prod,Productname,region
			   from dbo.OutputGeoHBVSummaryGrowthT1 
			   where Class='N' and Mkt not in ('DPP4','eliquis noac','Eliquis VTet') and not (mkt = 'Eliquis VTep' and Prod = '600'  )
			  ) A 
		 inner join
			  (
			  select distinct MoneyType,mkt,Market,Audi_cod,Audi_des,region
			  from dbo.OutputGeoHBVSummaryGrowthT1 
			  where Class='N' and Mkt not in ('DPP4','eliquis noac','Eliquis VTet') and not (mkt = 'Eliquis VTep' and Prod = '600'  )
			  ) B
		 on A.moneytype=b.moneytype and a.mkt=b.mkt and a.market=b.market and a.region=b.region
	  ) a ,
	  (
	  select 'MQT' as Period union all
	  select 'YTD' as Period union all
	  select 'MAT' as Period  union all
	  select 'MTH' as Period 
	  ) B
  
	--2.1 MQT
	update [output_stage] set 
	  Y=B.R3M00,
	  IntY=B.R3M00 
	from [output_stage] A inner join dbo.OutputGeoHBVSummaryGrowthT1 B
	on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
	and A.timeFrame='MQT'where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' and B.Mkt<>'DPP4'

	--2.2 YTD
	update [output_stage] set 
	  Y=B.YTD00,
	  IntY=B.YTD00 
	from [output_stage] A inner join dbo.OutputGeoHBVSummaryGrowthT1 B
	on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
	and A.timeFrame='YTD'where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' and B.Mkt<>'DPP4'

	-- 2.3 MAT
	update [output_stage] set 
	  Y=B.MAT00,
	  IntY=B.MAT00 
	from [output_stage] A inner join dbo.OutputGeoHBVSummaryGrowthT1 B
	on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
	and A.timeFrame='MAT' where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' and B.Mkt<>'DPP4'

	-- 2.4 MTH
	update [output_stage] set 
	  Y=B.MTH00,
	  IntY=B.MTH00 
	from [output_stage] A inner join dbo.OutputGeoHBVSummaryGrowthT1 B
	on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
	and A.timeFrame='MTH' where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' and B.Mkt<>'DPP4'
	GO

	-- --------------------------------------------
	-- --D042                                      
	-- --------------------------------------------
	delete from output_stage where linkchartcode='D042'
	-- declare @code varchar(10),@i int,@sql varchar(8000)
	-- set @i=0
	-- set @code = 'D042'
	-- insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
	-- select 'Y',B.Period, @code as Code, A.Market,A.Productname,A.Prod,moneytype, a.Audi_des,a.Audi_cod,'Region' as lev,A.region
	-- from (
	-- select A.*,b.Audi_cod,B.Audi_des from (
	-- select distinct MoneyType,mkt,Market,Prod,Productname,region
	--  from dbo.OutputGeoHBVSummaryT2 where Class='N' and Mkt='DPP4'
	-- ) A inner join
	-- (select distinct MoneyType,mkt,Market,Audi_cod,Audi_des,region
	--  from dbo.OutputGeoHBVSummaryT2 where Class='N' and Mkt='DPP4') B
	-- on A.moneytype=b.moneytype and a.mkt=b.mkt and a.market=b.market and a.region=b.region
	-- ) a ,(select 'MQT' as Period union all
	-- 							 select 'YTD' as Period union all
	-- 							 select 'MAT' as Period ) B

	-- update [output_stage]
	-- set Y=case B.type when 'Market Total' then convert(varchar(50),cast(B.R3M00 as float),1) else B.R3M00 end,
	-- IntY=case B.type when 'Market Total' then cast(B.R3M00 as float) end   from [output_stage] A inner join dbo.OutputGeoHBVSummaryT2 B
	-- on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
	-- and A.timeFrame='MQT'where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y' and B.Mkt='DPP4'
	-- update [output_stage]
	-- set Y=case B.type when 'Market Total' then convert(varchar(50),cast(B.YTD00 as float),1) else B.YTD00 end,
	-- IntY=case B.type when 'Market Total' then cast(B.YTD00 as float) end  from [output_stage] A inner join dbo.OutputGeoHBVSummaryT2 B
	-- on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
	-- and A.timeFrame='YTD'where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y' and B.Mkt='DPP4'
	-- update [output_stage]
	-- set Y=case B.type when 'Market Total' then convert(varchar(50),cast(B.MAT00 as float),1) else B.MAT00 end,
	-- IntY=case B.type when 'Market Total' then cast(B.MAT00 as float) end  from [output_stage] A inner join dbo.OutputGeoHBVSummaryT2 B
	-- on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
	-- and A.timeFrame='MAT' where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y' and B.Mkt='DPP4'


	-- insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
	-- select 'L',B.Period, @code as Code, A.Market,A.Productname,A.Prod,moneytype, a.Audi_des,a.Audi_cod,'Region' as lev,A.region
	-- from (
	-- select A.*,b.Audi_cod,B.Audi_des from (
	-- select distinct MoneyType,mkt,Market,Prod,Productname,region
	--  from dbo.OutputGeoHBVSummaryGrowthT1 where Class='N' and Mkt='DPP4'
	-- ) A inner join
	-- (select distinct MoneyType,mkt,Market,Audi_cod,Audi_des,region
	--  from dbo.OutputGeoHBVSummaryGrowthT1 where Class='N' and Mkt='DPP4') B
	-- on A.moneytype=b.moneytype and a.mkt=b.mkt and a.market=b.market and a.region=b.region
	-- ) a ,(select 'MQT' as Period union all
	-- 							 select 'YTD' as Period union all
	-- 							 select 'MAT' as Period ) B

	-- update [output_stage]
	-- set Y=B.R3M00,
	-- IntY=B.R3M00 from [output_stage] A inner join dbo.OutputGeoHBVSummaryGrowthT1 B
	-- on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
	-- and A.timeFrame='MQT'where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' and B.Mkt='DPP4'
	-- update [output_stage]
	-- set Y=B.YTD00,
	-- IntY=B.YTD00 from [output_stage] A inner join dbo.OutputGeoHBVSummaryGrowthT1 B
	-- on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
	-- and A.timeFrame='YTD'where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' and B.Mkt='DPP4'
	-- update [output_stage]
	-- set Y=B.MAT00,
	-- IntY=B.MAT00 from [output_stage] A inner join dbo.OutputGeoHBVSummaryGrowthT1 B
	-- on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
	-- and A.timeFrame='MAT' where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' and B.Mkt='DPP4'
	/*
	insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
	select isshow,B.Period, @code as Code, A.Market, A.Product,A.ProdIdx,'US',a.Series,a.SeriesIdx,'Region' as lev,A.region
	from (
	select  'D' as isshow,market,region,audi_des as  Series,
	dense_RANK ( )OVER (PARTITION BY market,region order by audi_des ) as SeriesIdx,Product,ProdIdx
	 from
	 (select distinct  market,region,audi_des,Product+' Growth' as Product,Prodidx from dbo.OutputGeoHBVSummaryT2  where datatype<>'Share' and type='Market'
	) A
	) a ,(select 'Rolling 3 Months' as Period union all
								 select 'YTD' as Period union all
								 select 'MAT' as Period ) B

	update [output_stage]
	set Y=B.R3M00Growth from [output_stage] A inner join dbo.OutputGeoHBVSummaryT2 B
	on A.Series=B.Product+' Growth' and A.X=B.audi_des and A.geo=B.region and a.Product = B.market
	and A.timeFrame='Rolling 3 Months' where B.datatype<>'Share' and B.type='Market'
	update [output_stage]
	set Y=B.YTD00Growth from [output_stage] A inner join dbo.OutputGeoHBVSummaryT2 B
	on A.Series=B.Product+' Growth' and A.X=B.audi_des and A.geo=B.region and a.Product = B.market
	and A.timeFrame='YTD'where B.datatype<>'Share' and B.type='Market'
	update [output_stage]
	set Y=B.MAT00Growth from [output_stage] A inner join dbo.OutputGeoHBVSummaryT2 B
	on A.Series=B.Product+' Growth' and A.X=B.audi_des and A.geo=B.region and a.Product = B.market
	and A.timeFrame='MAT'where B.datatype<>'Share' and B.type='Market'

	*/
	go
	delete from output_stage where linkchartcode='D032'
	declare @code varchar(10),@i int,@sql varchar(8000)
	set @i=0
	set @code = 'D032'
	insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
	select 'Y',B.Period, @code as Code, A.Market,A.Productname,A.Prod,moneytype, a.Audi_des,a.Audi_cod,'Region' as lev,A.region
	from (
	select A.*,b.Audi_cod,B.Audi_des from (
	select distinct MoneyType,mkt,Market,Prod,Productname,region
	 from dbo.OutputGeoHBVSummaryT2 where Class='Y'
	) A inner join
	(select distinct MoneyType,mkt,Market,Audi_cod,Audi_des,region
	 from dbo.OutputGeoHBVSummaryT2 where Class='Y') B
	on A.moneytype=b.moneytype and a.mkt=b.mkt and a.market=b.market and a.region=b.region
	) a ,(select 'MQT' as Period union all
								 select 'YTD' as Period union all
								 select 'MAT' as Period ) B

	update [output_stage]
	set Y=case B.type when 'Market Total' then convert(varchar(50),cast(B.R3M00 as float),1) else B.R3M00 end,
		IntY=case B.type when 'Market Total' then cast(B.R3M00 as float) end from [output_stage] A inner join dbo.OutputGeoHBVSummaryT2 B
	on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
		and A.timeFrame='MQT'where B.Class='Y' and A.LinkChartCode=@code and A.isshow='Y'

	update [output_stage]
	set Y=case B.type when 'Market Total' then convert(varchar(50),cast(B.YTD00 as float),1)else B.YTD00 end,
		IntY=case B.type when 'Market Total' then cast(B.YTD00 as float) end from [output_stage] A inner join dbo.OutputGeoHBVSummaryT2 B
	on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
		and A.timeFrame='YTD'where B.Class='Y'and A.LinkChartCode=@code and A.isshow='Y'

	update [output_stage]
	set Y=case B.type when 'Market Total' then convert(varchar(50),cast(B.MAT00 as float),1) else B.MAT00 end,
		IntY=case B.type when 'Market Total' then cast(B.MAT00 as float) end from [output_stage] A inner join dbo.OutputGeoHBVSummaryT2 B
	on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
		and A.timeFrame='MAT' where B.Class='Y' and A.LinkChartCode=@code and A.isshow='Y'

	insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
	select 'L',B.Period, @code as Code, A.Market,A.Productname,A.Prod,moneytype, a.Audi_des,a.Audi_cod,'Region' as lev,A.region
	from (
			select A.*,b.Audi_cod,B.Audi_des 
			from (
				select distinct MoneyType,mkt,Market,Prod,Productname,region
				from dbo.OutputGeoHBVSummaryGrowthT1 where Class='Y'
			) A inner join
			(	select distinct MoneyType,mkt,Market,Audi_cod,Audi_des,region
				from dbo.OutputGeoHBVSummaryGrowthT1 where Class='Y'
			) B
			on A.moneytype=b.moneytype and a.mkt=b.mkt and a.market=b.market and a.region=b.region
		) a , (	select 'MQT' as Period 
				union all
				select 'YTD' as Period union all
				select 'MAT' as Period ) B

	update [output_stage]
	set Y=B.R3M00,
		IntY=B.R3M00 from [output_stage] A inner join dbo.OutputGeoHBVSummaryGrowthT1 B
	on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
		and A.timeFrame='MQT'where B.Class='Y' and A.LinkChartCode=@code and A.isshow='L'

	update [output_stage]
	set Y=B.YTD00,
		IntY=B.YTD00 from [output_stage] A inner join dbo.OutputGeoHBVSummaryGrowthT1 B
	on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
		and A.timeFrame='YTD'where B.Class='Y'and A.LinkChartCode=@code and A.isshow='L'

	update [output_stage]
	set Y=B.MAT00,
		IntY=B.MAT00 from [output_stage] A inner join dbo.OutputGeoHBVSummaryGrowthT1 B
	on A.X=B.audi_des and A.Series=B.Productname and A.geo=B.region and a.Product = B.market and A.Currency=B.moneytype
		and A.timeFrame='MAT' where B.Class='Y' and A.LinkChartCode=@code and A.isshow='L'
	GO

	----------------------------
	-- C140
	----------------------------
	delete from output_stage where linkchartcode='C140'
	declare @code varchar(10),@i int,@sql varchar(8000)
	set @i=0
	set @code = 'C140'
	insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
	select 'Y',B.Period, @code as Code, A.Market,A.Productname,A.Prod,moneytype, a.Audi_des,a.Audi_cod,'China' as lev,'China'
	from (
		select A.*,b.Audi_cod,B.Audi_des 
		from (
			select distinct MoneyType,mkt,Market,Prod,Productname,region
			from dbo.OutputKeyBrandPerformanceByRegion_For_OtherETV 
			where Class='N'
			--避免产生he en没有region数据而造成ppt塞数据时数据错位
			union    select 'LC','ARV','Baraclude','601','He En','China'
			union    select 'LC','ARV','Baraclude','601','He En','E1'
			union    select 'LC','ARV','Baraclude','601','He En','E2'
			union    select 'LC','ARV','Baraclude','601','He En','E3'
			union    select 'LC','ARV','Baraclude','601','He En','E4'
			union    select 'LC','ARV','Baraclude','601','He En','N1'
			union    select 'LC','ARV','Baraclude','601','He En','N2'
			union    select 'LC','ARV','Baraclude','601','He En','N3'
			union    select 'LC','ARV','Baraclude','601','He En','N4'
			union    select 'LC','ARV','Baraclude','601','He En','N5'
			union    select 'LC','ARV','Baraclude','601','He En','S1'
			union    select 'LC','ARV','Baraclude','601','He En','S2'
			union    select 'LC','ARV','Baraclude','601','He En','S3'
			union    select 'LC','ARV','Baraclude','601','He En','S4'
			union    select 'UN','ARV','Baraclude','601','He En','China'
			union    select 'UN','ARV','Baraclude','601','He En','E1'
			union    select 'UN','ARV','Baraclude','601','He En','E2'
			union    select 'UN','ARV','Baraclude','601','He En','E3'
			union    select 'UN','ARV','Baraclude','601','He En','E4'
			union    select 'UN','ARV','Baraclude','601','He En','N1'
			union    select 'UN','ARV','Baraclude','601','He En','N2'
			union    select 'UN','ARV','Baraclude','601','He En','N3'
			union    select 'UN','ARV','Baraclude','601','He En','N4'
			union    select 'UN','ARV','Baraclude','601','He En','N5'
			union    select 'UN','ARV','Baraclude','601','He En','S1'
			union    select 'UN','ARV','Baraclude','601','He En','S2'
			union    select 'UN','ARV','Baraclude','601','He En','S3'
			union    select 'UN','ARV','Baraclude','601','He En','S4'
			union    select 'US','ARV','Baraclude','601','He En','China'
			union    select 'US','ARV','Baraclude','601','He En','E1'
			union    select 'US','ARV','Baraclude','601','He En','E2'
			union    select 'US','ARV','Baraclude','601','He En','E3'
			union    select 'US','ARV','Baraclude','601','He En','E4'
			union    select 'US','ARV','Baraclude','601','He En','N1'
			union    select 'US','ARV','Baraclude','601','He En','N2'
			union    select 'US','ARV','Baraclude','601','He En','N3'
			union    select 'US','ARV','Baraclude','601','He En','N4'
			union    select 'US','ARV','Baraclude','601','He En','N5'
			union    select 'US','ARV','Baraclude','601','He En','S1'
			union    select 'US','ARV','Baraclude','601','He En','S2'
			union    select 'US','ARV','Baraclude','601','He En','S3'
			union    select 'US','ARV','Baraclude','601','He En','S4'
		) A inner join
		(	select distinct MoneyType,mkt,Market,Audi_cod,Audi_des,region
			from dbo.OutputKeyBrandPerformanceByRegion_For_OtherETV where Class='N' 
		) B
		on A.moneytype=b.moneytype and a.mkt=b.mkt and a.market=b.market and a.region=b.region
	) a ,
	(	select 'MQT' as Period union all
		select 'MTH' as Period union all
		select 'MAT' as Period union all
		select 'YTD' as Period 
	) B
	where a.Market<>'Eliquis NOAC' and a.Market<>'Eliquis VTet'	
		and not (a.Market = 'Eliquis VTep' and a.Prod = '600'  )								

	update [output_stage]
	set Y=case B.type when 'Market Total' then convert(varchar(50),cast(B.R3M00 as float),1) else B.R3M00 end,
		IntY=case B.type when 'Market Total' then cast(B.R3M00 as float) end   
	from [output_stage] A 
	inner join dbo.OutputKeyBrandPerformanceByRegion_For_OtherETV B
	on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
		and A.timeFrame='MQT'
	where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y'

	update [output_stage]
	set Y=case B.type when 'Market Total' then convert(varchar(50),cast(B.MTH00 as float),1) else B.MTH00 end,
		IntY=case B.type when 'Market Total' then cast(B.MTH00 as float) end  
	from [output_stage] A 
	inner join dbo.OutputKeyBrandPerformanceByRegion_For_OtherETV B
	on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
		and A.timeFrame='MTH'
	where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y'

	update [output_stage]
	set Y=B.MAT00,
		IntY=B.MAT00 
	from [output_stage] A  
	inner join dbo.OutputKeyBrandPerformanceByRegion_For_OtherETV B
	on A.X=B.audi_des and A.Series=B.Productname  and a.Product = B.market and A.Currency=B.moneytype
		and A.timeFrame='MAT' 
	where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y'

	update [output_stage]
	set Y=B.YTD00,
		IntY=B.YTD00 
	from [output_stage] A 
	inner join dbo.OutputKeyBrandPerformanceByRegion_For_OtherETV B
	on A.X=B.audi_des and A.Series=B.Productname  and a.Product = B.market and A.Currency=B.moneytype
		and A.timeFrame='YTD' 
	where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y'

	insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
	select 'L',B.Period, @code as Code, A.Market,A.Productname,A.Prod,moneytype, a.Audi_des,a.Audi_cod,'China' as lev,'China'
	from (
		select A.*,b.Audi_cod,B.Audi_des 
		from (
			select distinct MoneyType,mkt,Market,Prod,Productname,region
			from dbo.OutputKeyBrandPerformanceByRegionGrowth where Class='N' --and Mkt<>'DPP4'
		) A 
		inner join
		(	select distinct MoneyType,mkt,Market,Audi_cod,Audi_des,region
			from dbo.OutputKeyBrandPerformanceByRegionGrowth where Class='N') B
		on A.moneytype=b.moneytype and a.mkt=b.mkt and a.market=b.market and a.region=b.region
	) a ,
	(		select 'MQT' as Period union all
			select 'MTH' as Period union all
			select 'MAT' as Period union all
			select 'YTD' as Period  ) B
	where a.Market<>'Eliquis noac'  and a.Market<>'Eliquis VTet'	
		and not (a.Market = 'Eliquis VTep' and a.Prod = '600'  )							

	update [output_stage]
	set Y=B.R3M00,
		IntY=B.R3M00 
	from [output_stage] A 
	inner join dbo.OutputKeyBrandPerformanceByRegionGrowth B
	on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
		and A.timeFrame='MQT'where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' --and B.Mkt<>'DPP4'
	
	update [output_stage]
	set Y=B.MTH00,
		IntY=B.MTH00 
	from [output_stage] A 
	inner join dbo.OutputKeyBrandPerformanceByRegionGrowth B
	on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
		and A.timeFrame='MTH'where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' --and B.Mkt<>'DPP4'
	
	update [output_stage]
	set Y=B.MAT00,
		IntY=B.MAT00 
	from [output_stage] A 
	inner join dbo.OutputKeyBrandPerformanceByRegionGrowth B
	on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
		and A.timeFrame='MAT' where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' --and B.Mkt<>'DPP4'
	
	update [output_stage]
	set Y=B.YTD00,
		IntY=B.YTD00 
	from [output_stage] A 
	inner join dbo.OutputKeyBrandPerformanceByRegionGrowth B
	on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
		and A.timeFrame='YTD' where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' --and B.Mkt<>'DPP4'


	Go


	-- -----------------------------------------------------------------------------------
	-- --			C900: Baraclude Modification Slide6( Merge 13 Audi to 3 <East,North,South>)
	-- -----------------------------------------------------------------------------------

	-- delete from output_stage where linkchartcode='c900'
	-- declare @code varchar(10),@i int,@sql varchar(8000)
	-- set @i=0
	-- set @code = 'c900'
	-- insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
	-- select 'Y',B.Period, @code as Code, A.Market,A.Productname,A.Prod,moneytype, a.Audi_des, isnull(a.Audi_cod, 11),'China' as lev,'China'
	-- from (
	-- 	select A.*,b.Audi_cod,B.Audi_des 
	-- 	from (
	-- 		select distinct MoneyType,mkt,Market,Prod,Productname,region
	-- 		from dbo.OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6 
	-- 		where Class='N'
	-- 	) A 
	-- 	inner join
	-- 	(	select distinct MoneyType,mkt,Market,Audi_cod,Audi_des,region
	-- 		from dbo.OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6 
	-- 		where Class='N' 
	-- 	) B
	-- 	on A.moneytype=b.moneytype and a.mkt=b.mkt and a.market=b.market and a.region=b.region
	-- ) a ,(					
	-- 	select 'MQT' as Period union all
	-- 	select 'MTH' as Period union all
	-- 	select 'MAT' as Period union all
	-- 	select 'YTD' as Period 
	-- ) B

	-- update [output_stage]
	-- set Y=case B.type when 'Market Total' then convert(varchar(50),cast(B.R3M00 as float),1) else B.R3M00 end,
	-- 	IntY=case B.type when 'Market Total' then cast(B.R3M00 as float) end   
	-- from [output_stage] A 
	-- inner join dbo.OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6 B
	-- on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
	-- 	and A.timeFrame='MQT'
	-- where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y'

	-- update [output_stage]
	-- set Y=case B.type when 'Market Total' then convert(varchar(50),cast(B.MTH00 as float),1) else B.MTH00 end,
	-- 	IntY=case B.type when 'Market Total' then cast(B.MTH00 as float) end  
	-- from [output_stage] A 
	-- inner join dbo.OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6 B
	-- on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
	-- 	and A.timeFrame='MTH'
	-- where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y'

	-- update [output_stage]
	-- set Y=B.MAT00,
	-- IntY=B.MAT00 from [output_stage] A 
	-- inner join dbo.OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6 B
	-- on A.X=B.audi_des and A.Series=B.Productname  and a.Product = B.market and A.Currency=B.moneytype
	-- and A.timeFrame='MAT' 
	-- where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y'

	-- update [output_stage]
	-- set Y=B.YTD00,
	-- IntY=B.YTD00 from [output_stage] A 
	-- inner join dbo.OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6 B
	-- on A.X=B.audi_des and A.Series=B.Productname  and a.Product = B.market and A.Currency=B.moneytype
	-- and A.timeFrame='YTD'
	-- where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y'

	-- insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
	-- select 'L',B.Period, @code as Code, A.Market,A.Productname,A.Prod,moneytype, a.Audi_des,a.Audi_cod,'China' as lev,'China'
	-- from (
	-- 	select A.*,b.Audi_cod,B.Audi_des 
	-- 	from (
	-- 		select distinct MoneyType,mkt,Market,Prod,Productname,region
	-- 		from dbo.OutputKeyBrandPerformanceByRegionGrowth_For_Baraclude_Slide6 where Class='N' --and Mkt<>'DPP4'
	-- 	) A inner join
	-- 	(	select distinct MoneyType,mkt,Market,Audi_cod,Audi_des,region
	-- 		from dbo.OutputKeyBrandPerformanceByRegionGrowth_For_Baraclude_Slide6 where Class='N'
	-- 	) B
	-- 	on A.moneytype=b.moneytype and a.mkt=b.mkt and a.market=b.market and a.region=b.region
	-- ) a ,(	select 'MQT' as Period union all
	-- 		select 'MTH' as Period union all
	-- 		select 'MAT' as Period union all
	-- 		select 'YTD' as Period  
	-- ) B

	-- update [output_stage]
	-- set Y=B.R3M00,
	-- 	IntY=B.R3M00 
	-- from [output_stage] A 
	-- inner join dbo.OutputKeyBrandPerformanceByRegionGrowth_For_Baraclude_Slide6 B
	-- on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
	-- 	and A.timeFrame='MQT'
	-- where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' --and B.Mkt<>'DPP4'
	
	-- update [output_stage]
	-- set Y=B.MTH00,
	-- 	IntY=B.MTH00 
	-- from [output_stage] A 
	-- inner join dbo.OutputKeyBrandPerformanceByRegionGrowth_For_Baraclude_Slide6 B
	-- on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
	-- 	and A.timeFrame='MTH'
	-- where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' --and B.Mkt<>'DPP4'

	-- update [output_stage]
	-- set Y=B.MAT00,
	-- 	IntY=B.MAT00 
	-- from [output_stage] A inner join dbo.OutputKeyBrandPerformanceByRegionGrowth_For_Baraclude_Slide6 B
	-- on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
	-- 	and A.timeFrame='MAT' 
	-- where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' --and B.Mkt<>'DPP4'

	-- update [output_stage]
	-- set Y=B.YTD00,
	-- 	IntY=B.YTD00 
	-- from [output_stage] A 
	-- inner join dbo.OutputKeyBrandPerformanceByRegionGrowth_For_Baraclude_Slide6 B
	-- on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
	-- 	and A.timeFrame='YTD' 
	-- where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' --and B.Mkt<>'DPP4'



	GO
	update [output_stage]
	set series = case when right(series,2) <> 'GR' then series+' GR' end 
	where LinkChartCode in('D022','D032','D042','C140','C900') and isshow='L'
	/*
	insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
	select isshow,B.Period, @code as Code, A.Market, A.Product,A.ProdIdx,'US',a.Series,a.SeriesIdx,'Region' as lev,A.region
	from (
	select  'D' as isshow,market,region,audi_des as  Series,
	dense_RANK ( )OVER (PARTITION BY market,region order by audi_des ) as SeriesIdx,Product,ProdIdx
	 from
	 (select distinct  market,region,audi_des,Product+' Growth' as Product,Prodidx from dbo.OutputGeoHBVSummaryT2  where datatype<>'Share' and type='Brand'
	) A
	) a ,(select 'Rolling 3 Months' as Period union all
								 select 'YTD' as Period union all
								 select 'MAT' as Period ) B

	update [output_stage]
	set Y=B.R3M00Growth from [output_stage] A inner join dbo.OutputGeoHBVSummaryT2 B
	on A.Series=B.Product+' Growth' and A.X=B.audi_des and A.geo=B.region and a.Product = B.market
	and A.timeFrame='Rolling 3 Months' where B.datatype<>'Share' and B.type='Brand'
	update [output_stage]
	set Y=B.YTD00Growth from [output_stage] A inner join dbo.OutputGeoHBVSummaryT2 B
	on A.Series=B.Product+' Growth' and A.X=B.audi_des and A.geo=B.region and a.Product = B.market
	and A.timeFrame='YTD'where B.datatype<>'Share' and B.type='Brand'
	update [output_stage]
	set Y=B.MAT00Growth from [output_stage] A inner join dbo.OutputGeoHBVSummaryT2 B
	on A.Series=B.Product+' Growth' and A.X=B.audi_des and A.geo=B.region and a.Product = B.market
	and A.timeFrame='MAT'where B.datatype<>'Share' and B.type='Brand'

	*/

	go
	update [output_stage]
	set LinkSeriesCode=Product+'_'+LinkChartCode+'_'+geo+isshow+cast(SeriesIdx as varchar(10)) where LinkChartCode in('D022','D032','D042','C140','C900')
	go
	update [output_stage]
	set Category=case Currency when 'UN' then 'Units' else 'Value' end
	where LinkChartCode in('D022','D032','D042','C140','C900')
	go
	update [output_stage]
	set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' else Currency end 
	where LinkChartCode in('D022','D032','D042','C140','C900')
	go
	update output_stage
	set LinkedY=series where (linkchartcode like 'D021%' or  linkchartcode like 'D031%' or linkchartcode like 'D041%')
	and isshow='Y'
	go
	update output_stage
	set LinkedY=X where (linkchartcode like 'D022%' or  linkchartcode like 'D032%' or linkchartcode like 'D042%' or linkchartcode like 'C140' or linkchartcode like 'C900')
	and isshow='Y'
	go

	if exists (select * from dbo.sysobjects where id = object_id(N'tblDivNumber_ForD022') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tblDivNumber_ForD022
	go
	select linkchartcode,currency,timeFrame,geo,Product,X, 
		case --when max(cast(y as float)) between 5000 and 5000000 then 1000
			when max(cast(y as float)) between 5000 and 5000000000 then 1000000
			when max(cast(y as float)) >= 5000000000 then 1000000000 else 1 end as divide,
		case --when max(cast(y as float)) between 5000 and 5000000 then 'K'
			when max(cast(y as float)) between 5000 and 5000000000 then ' mio.'
			when max(cast(y as float)) >= 5000000000 then ' bn.' else '' end as Dol
	into tblDivNumber_ForD022 
	from output_stage A 
	where seriesidx=0 and linkchartcode in('D022','D032','D042','C140','C900')
	group by linkchartcode,currency,timeFrame,geo,Product,X
	go
	update output_stage
	set seriesidx=10000 
	where seriesidx=0 and linkchartcode in('D022','D032','D042','C140','C900') and isshow='Y'

	go
	update output_stage
	set x=A.X+Char(13)+'('+left(convert(varchar(50),cast(cast(B.IntY as float) as money),1),len(convert(varchar(50),cast(cast(B.IntY as float) as money),1))-3)+')'--A.x+' ('+cast(round(cast(B.y as float)*1.0/C.divide,1) as varchar(20))+C.dol+')'
	FROM output_stage a 
	INNER JOIN (select * from output_stage where seriesidx='10000') b
	ON A.linkchartcode=b.linkchartcode and a.product=b.product and a.lev=b.lev and a.geo=b.geo 
		and a.category=b.category and a.currency=b.currency and a.timeframe=b.timeframe
		AND A.X=B.X
		and isnull(a.isshow,'')=isnull(b.isshow,'')
		and a.isshow='Y' and A.linkchartcode in ('D022','D032','D042','C140','C900')
	left join tblDivNumber_ForD022 C
	on A.timeframe=C.timeframe and A.Currency=C.Currency
		and A.linkchartcode=C.linkchartcode and A.geo=C.geo and A.product=C.Product and A.X=C.X
	go
	DELETE FROM output_stage
	WHERE seriesidx='10000' and linkchartcode in ('D022','D032','D042','C140','C900')and isshow='Y'
	go
	--select * from output_stage where linkchartcode='D022'


	delete from output_stage where linkchartcode='D081'

	declare @code varchar(10)
	set @code = 'D081'
	insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
	select isshow,Region,Audi_des,b.Market,'City',a.Period, @code as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
	from (
		select 'MQT' as Period,'R3M00' as Series,	6 as SeriesIdx union all
		select 'MQT' as Period,'R3M01' as Series,	5 as SeriesIdx union all
		select 'MQT' as Period,'R3M02' as Series,	4 as SeriesIdx union all
		select 'MQT' as Period,'R3M03' as Series,	3 as SeriesIdx union all
		select 'MQT' as Period,'R3M04' as Series,	2 as SeriesIdx union all
		select 'MQT' as Period,'R3M05' as Series,	1 as SeriesIdx union all
		select 'YTD' as Period,'YTD00' as Series,	6 as SeriesIdx union all
		select 'YTD' as Period,'YTD12' as Series,	5 as SeriesIdx union all
		select 'YTD' as Period,'YTD24' as Series,	4 as SeriesIdx union all
		select 'YTD' as Period,'YTD36' as Series,	3 as SeriesIdx union all
		select 'YTD' as Period,'YTD48' as Series,	2 as SeriesIdx 
	) a, (
		select distinct case Chart when 'Volume Trend' then 'Y' else 'N' end as isshow,
			Region,Audi_des,MoneyType,market,Productname,Prod 
		from dbo.OutputCityPerformanceByBrand_For_OtherETV 
		where Chart in('Volume Trend','CAGR') and Class='N' and molecule='N' 
			and Mkt not in ('DPP4','Eliquis NOAC','Eliquis VTet')
			and not (mkt = 'Eliquis VTep' and Prod = '600'  )
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
			inner join dbo.OutputCityPerformanceByBrand_For_OtherETV B
			on case B.Chart when ''Volume Trend'' then ''Y'' else ''N'' end=A.isshow and A.Currency=B.MoneyType and A.X='
			+''''+@Series+''''+'and B.Chart in(''Volume Trend'',''CAGR'') and B.Class=''N'' and B.molecule=''N'' 
			and B.Mkt NOT in(''DPP4'',''Eliquis NOAC'',''Eliquis VTet'') and not (B.mkt = ''Eliquis VTep'' and B.Prod = ''600''  )
			and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and A.ParentGeo=B.region and A.geo=B.audi_des'
			print @SQL2
			exec( @SQL2)

		END
		FETCH NEXT FROM TMP_CURSOR INTO @Series
	END
	CLOSE TMP_CURSOR
	DEALLOCATE TMP_CURSOR
	go
	delete output_stage where linkchartcode='D081' and isshow='N' and xidx<>6
	go
	-- --Onglyza DPP4
	delete from output_stage where linkchartcode='D101'

	-- declare @code varchar(10)
	-- set @code = 'D101'
	-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
	-- select isshow,Region,Audi_des,b.Market,'City',Period, @code as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
	-- from (
	-- 	select 'R3M00' as Series,					6 as SeriesIdx union all
	-- 	select 'R3M01' as Series,				5 as SeriesIdx union all
	-- 	select 'R3M02' as Series,		4 as SeriesIdx union all
	-- 	select 'R3M03' as Series,	3 as SeriesIdx union all
	-- 	select 'R3M04' as Series,	2 as SeriesIdx union all
	-- 	select 'R3M05' as Series,	1 as SeriesIdx
	-- ) a, (
	-- 	select distinct case Chart when 'Volume Trend' then 'Y' else 'N' end as isshow,
	-- Region,Audi_des,'MQT' as Period,MoneyType,market,Productname,Prod from dbo.OutputCityPerformanceByBrand where Chart in('Volume Trend','CAGR') and Class='N' and molecule='N' and Mkt='DPP4'
	-- ) b

	-- DECLARE TMP_CURSOR CURSOR
	-- READ_ONLY
	-- FOR select distinct X  from dbo.[output_stage] where LinkChartCode=@code
	-- DECLARE @Series varchar(100)
	-- DECLARE @SQL2 VARCHAR(8000)
	
	-- OPEN TMP_CURSOR
	
	-- FETCH NEXT FROM TMP_CURSOR INTO @Series
	-- WHILE (@@FETCH_STATUS <> -1)
	-- BEGIN

	-- 	IF (@@FETCH_STATUS <> -2)
	-- 	BEGIN
	-- 		print @Series

	-- 		set @SQL2='
	-- 		update [output_stage]
	-- 		set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.OutputCityPerformanceByBrand B
	-- 		on case B.Chart when ''Volume Trend'' then ''Y'' else ''N'' end=A.isshow and A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'and B.Chart in(''Volume Trend'',''CAGR'') and B.Class=''N'' and B.molecule=''N'' and B.Mkt=''DPP4''
	-- 		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and A.ParentGeo=B.region and A.geo=B.audi_des'
	-- 		print @SQL2
	-- 		exec( @SQL2)

	-- 	END
	-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
	-- END
	-- CLOSE TMP_CURSOR
	-- DEALLOCATE TMP_CURSOR
	-- go
	delete output_stage where linkchartcode='D101' and isshow='N' and xidx<>6
	go

	--------------------------------
	-- D090
	--------------------------------
	delete from output_stage where linkchartcode='D091'

	declare @code varchar(10)
	set @code = 'D091'
	insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
	select isshow,Region,Audi_des,b.Market,'City',a.Period, @code as Code, B.Productname,Prod,MoneyType,a.Series,a.SeriesIdx
	from (
		select 'MQT' as Period,'R3M00' as Series,	6 as SeriesIdx union all
		select 'MQT' as Period,'R3M01' as Series,	5 as SeriesIdx union all
		select 'MQT' as Period,'R3M02' as Series,	4 as SeriesIdx union all
		select 'MQT' as Period,'R3M03' as Series,	3 as SeriesIdx union all
		select 'MQT' as Period,'R3M04' as Series,	2 as SeriesIdx union all
		select 'MQT' as Period,'R3M05' as Series,	1 as SeriesIdx union all
		select 'YTD' as Period,'YTD00' as Series,	6 as SeriesIdx union all
		select 'YTD' as Period,'YTD12' as Series,	5 as SeriesIdx union all
		select 'YTD' as Period,'YTD24' as Series,	4 as SeriesIdx union all
		select 'YTD' as Period,'YTD36' as Series,	3 as SeriesIdx union all
		select 'YTD' as Period,'YTD48' as Series,	2 as SeriesIdx union all
		select 'MAT' as Period,'MAT00' as Series,	6 as SeriesIdx union all
		select 'MAT' as Period,'MAT12' as Series,	5 as SeriesIdx union all
		select 'MAT' as Period,'MAT24' as Series,	4 as SeriesIdx union all
		select 'MAT' as Period,'MAT36' as Series,	3 as SeriesIdx union all
		select 'MAT' as Period,'MAT48' as Series,	2 as SeriesIdx union all
		select 'MTH' as Period,'MTH00' as Series,	6 as SeriesIdx union all
		select 'MTH' as Period,'MTH12' as Series,	5 as SeriesIdx union all
		select 'MTH' as Period,'MTH24' as Series,	4 as SeriesIdx union all
		select 'MTH' as Period,'MTH36' as Series,	3 as SeriesIdx union all
		select 'MTH' as Period,'MTH48' as Series,	2 as SeriesIdx
	) a, (
		select distinct  case Chart when 'Volume Trend' then 'Y' else 'N' end as isshow,
			Region,Audi_des,MoneyType,market,Productname,Prod 
		from dbo.OutputCityPerformanceByBrand 
		where (Chart in('Volume Trend','CAGR') and (Class='Y' or molecule='Y')) 
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
				inner join dbo.OutputCityPerformanceByBrand B
				on case B.Chart when ''Volume Trend'' then ''Y'' else ''N'' end=A.isshow and A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'and ((B.Chart in(''Volume Trend'',''CAGR'') and (B.Class=''Y'' or B.molecule=''Y'')))
				and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and A.ParentGeo=B.region and A.geo=B.audi_des'
			print @SQL2
			exec( @SQL2)

		END
		FETCH NEXT FROM TMP_CURSOR INTO @Series
	END
	CLOSE TMP_CURSOR
	DEALLOCATE TMP_CURSOR
	go
	delete output_stage where linkchartcode='D091' and isshow='N' and xidx<>6
	go

	delete from output_stage where linkchartcode='D082'

	declare @code varchar(10)
	set @code = 'D082'
	insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
	select 'Y',Region,Audi_des,B.Market,'City',a.Period, @code as Code, b.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
	from (
		select 'MQT' as Period,'R3M00' as Series,	6 as SeriesIdx union all
		select 'MQT' as Period,'R3M01' as Series,	5 as SeriesIdx union all
		select 'MQT' as Period,'R3M02' as Series,	4 as SeriesIdx union all
		select 'MQT' as Period,'R3M03' as Series,	3 as SeriesIdx union all
		select 'MQT' as Period,'R3M04' as Series,	2 as SeriesIdx union all
		select 'MQT' as Period,'R3M05' as Series,	1 as SeriesIdx union all

		select 'YTD' as Period,'YTD00' as Series,	6 as SeriesIdx union all
		select 'YTD' as Period,'YTD12' as Series,	5 as SeriesIdx union all
		select 'YTD' as Period,'YTD24' as Series,	4 as SeriesIdx union all
		select 'YTD' as Period,'YTD36' as Series,	3 as SeriesIdx union all
		select 'YTD' as Period,'YTD48' as Series,	2 as SeriesIdx union all
		
		select 'MAT' as Period,'MAT00' as Series,	6 as SeriesIdx union all
		select 'MAT' as Period,'MAT12' as Series,	5 as SeriesIdx union all
		select 'MAT' as Period,'MAT24' as Series,	4 as SeriesIdx union all
		select 'MAT' as Period,'MAT36' as Series,	3 as SeriesIdx union all
		select 'MAT' as Period,'MAT48' as Series,	2 as SeriesIdx union all
		
		select 'MTH' as Period,'MTH00' as Series,	6 as SeriesIdx union all
		select 'MTH' as Period,'MTH12' as Series,	5 as SeriesIdx union all
		select 'MTH' as Period,'MTH24' as Series,	4 as SeriesIdx union all
		select 'MTH' as Period,'MTH36' as Series,	3 as SeriesIdx union all
		select 'MTH' as Period,'MTH48' as Series,	2 as SeriesIdx
	) a, (
		select distinct Region,Audi_des,MoneyType,market,Productname,prod 
		from dbo.OutputCityPerformanceByBrand_For_OtherETV 
		where Chart='Market Share Trend' and Class='N' and  molecule='N' 
			and mkt NOT in('DPP4','Eliquis NOAC','Eliquis VTet') and not (mkt = 'Eliquis VTep' and Prod = '600'  )
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
				inner join dbo.OutputCityPerformanceByBrand_For_OtherETV B
				on A.Currency=B.MoneyType and A.X='
				+''''+@Series+''''+'and B.Chart=''Market Share Trend'' and B.Class=''N'' and  B.molecule=''N'' 
				and B.mkt NOT in(''DPP4'',''Eliquis NOAC'',''Eliquis VTet'') and not (mkt = ''Eliquis VTep'' and Prod = ''600''  )
				and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and A.ParentGeo=B.region and A.geo=B.audi_des'
			print @SQL2
			exec( @SQL2)

		END
		FETCH NEXT FROM TMP_CURSOR INTO @Series
	END
	CLOSE TMP_CURSOR
	DEALLOCATE TMP_CURSOR
	go
	-- --Onglyza DPP4

	delete from output_stage where linkchartcode='D102'

	-- declare @code varchar(10)
	-- set @code = 'D102'
	-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
	-- select 'Y',Region,Audi_des,B.Market,'City',Period, @code as Code, b.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
	-- from (
	-- 	select 'R3M00' as Series,	6 as SeriesIdx union all
	-- 	select 'R3M01' as Series,	5 as SeriesIdx union all
	-- 	select 'R3M02' as Series,	4 as SeriesIdx union all
	-- 	select 'R3M03' as Series,	3 as SeriesIdx union all
	-- 	select 'R3M04' as Series,	2 as SeriesIdx union all
	-- 	select 'R3M05' as Series,	1 as SeriesIdx
	-- ) a, (
	-- 	select distinct Region,Audi_des,'MQT' as Period,MoneyType,market,Productname,prod 
	-- 	from dbo.OutputCityPerformanceByBrand 
	-- 	where Chart='Market Share Trend' and Class='N' and  molecule='N' and mkt='DPP4'
	-- ) b

	-- DECLARE TMP_CURSOR CURSOR
	-- READ_ONLY
	-- FOR select distinct X  from dbo.[output_stage] where LinkChartCode=@code
	-- DECLARE @Series varchar(100)
	-- DECLARE @SQL2 VARCHAR(8000)
	
	-- OPEN TMP_CURSOR
	
	-- FETCH NEXT FROM TMP_CURSOR INTO @Series
	-- WHILE (@@FETCH_STATUS <> -1)
	-- BEGIN

	-- 	IF (@@FETCH_STATUS <> -2)
	-- 	BEGIN
	-- 		print @Series

	-- 		set @SQL2='
	-- 			update [output_stage]
	-- 			set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.OutputCityPerformanceByBrand B
	-- 			on A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'and B.Chart=''Market Share Trend'' and B.Class=''N'' and  B.molecule=''N'' and B.Mkt=''DPP4''
	-- 			and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and A.ParentGeo=B.region and A.geo=B.audi_des'
	-- 		print @SQL2
	-- 		exec( @SQL2)

	-- 	END
	-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
	-- END
	-- CLOSE TMP_CURSOR
	-- DEALLOCATE TMP_CURSOR
	-- go


	delete from output_stage where linkchartcode='D092'

	declare @code varchar(10)
	set @code = 'D092'
	insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
	select 'Y',Region,Audi_des,B.Market,'City',a.Period, @code as Code, b.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
	from (
		select 'MQT' as Period, 'R3M00' as Series,	6 as SeriesIdx union all
		select 'MQT' as Period, 'R3M01' as Series,	5 as SeriesIdx union all
		select 'MQT' as Period, 'R3M02' as Series,	4 as SeriesIdx union all
		select 'MQT' as Period, 'R3M03' as Series,	3 as SeriesIdx union all
		select 'MQT' as Period, 'R3M04' as Series,	2 as SeriesIdx union all
		select 'MQT' as Period, 'R3M05' as Series,	1 as SeriesIdx union all
		select 'YTD' as Period, 'YTD00' as Series,	6 as SeriesIdx union all
		select 'YTD' as Period, 'YTD12' as Series,	5 as SeriesIdx union all
		select 'YTD' as Period, 'YTD24' as Series,	4 as SeriesIdx union all
		select 'YTD' as Period, 'YTD36' as Series,	3 as SeriesIdx union all
		select 'YTD' as Period, 'YTD48' as Series,	2 as SeriesIdx union all

		select 'MAT' as Period, 'MAT00' as Series,	6 as SeriesIdx union all
		select 'MAT' as Period, 'MAT12' as Series,	5 as SeriesIdx union all
		select 'MAT' as Period, 'MAT24' as Series,	4 as SeriesIdx union all
		select 'MAT' as Period, 'MAT36' as Series,	3 as SeriesIdx union all
		select 'MAT' as Period, 'MAT48' as Series,	2 as SeriesIdx union all

		select 'MTH' as Period, 'MTH00' as Series,	6 as SeriesIdx union all
		select 'MTH' as Period, 'MTH12' as Series,	5 as SeriesIdx union all
		select 'MTH' as Period, 'MTH24' as Series,	4 as SeriesIdx union all
		select 'MTH' as Period, 'MTH36' as Series,	3 as SeriesIdx union all
		select 'MTH' as Period, 'MTH48' as Series,	2 as SeriesIdx
	) a, (
		select distinct Region,Audi_des,MoneyType,market,Productname,prod 
		from dbo.OutputCityPerformanceByBrand 
		where Chart='Market Share Trend' and (Class='Y' or  molecule='Y')
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
				inner join dbo.OutputCityPerformanceByBrand B
				on A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'and B.Chart=''Market Share Trend'' and (B.Class=''Y'' or  B.molecule=''Y'')
					and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and A.ParentGeo=B.region and A.geo=B.audi_des'
			print @SQL2
			exec( @SQL2)

		END
		FETCH NEXT FROM TMP_CURSOR INTO @Series
	END
	CLOSE TMP_CURSOR
	DEALLOCATE TMP_CURSOR
	go

	delete from [output_stage] where LinkChartCode= 'D083'
	declare @code varchar(10)
	set @code = 'D083'
	insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
	select 'Y',Region,Audi_des,b.Market,'City',a.Period, @code as Code, b.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
	from (
		select 'MQT' as Period,'R3M00' as Series,	6 as SeriesIdx union all
		select 'MQT' as Period,'R3M01' as Series,	5 as SeriesIdx union all
		select 'MQT' as Period,'R3M02' as Series,	4 as SeriesIdx union all
		select 'MQT' as Period,'R3M03' as Series,	3 as SeriesIdx union all
		select 'MQT' as Period,'R3M04' as Series,	2 as SeriesIdx union all
		select 'MQT' as Period,'R3M05' as Series,	1 as SeriesIdx union all
		select 'YTD' as Period,'YTD00' as Series,	6 as SeriesIdx union all
		select 'YTD' as Period,'YTD12' as Series,	5 as SeriesIdx union all
		select 'YTD' as Period,'YTD24' as Series,	4 as SeriesIdx union all
		select 'YTD' as Period,'YTD36' as Series,	3 as SeriesIdx union all
		select 'YTD' as Period,'YTD48' as Series,	2 as SeriesIdx union all

		select 'MAT' as Period,'MAT00' as Series,	6 as SeriesIdx union all
		select 'MAT' as Period,'MAT12' as Series,	5 as SeriesIdx union all
		select 'MAT' as Period,'MAT24' as Series,	4 as SeriesIdx union all
		select 'MAT' as Period,'MAT36' as Series,	3 as SeriesIdx union all
		select 'MAT' as Period,'MAT48' as Series,	2 as SeriesIdx union all

		select 'MTH' as Period,'MTH00' as Series,	6 as SeriesIdx union all
		select 'MTH' as Period,'MTH12' as Series,	5 as SeriesIdx union all
		select 'MTH' as Period,'MTH24' as Series,	4 as SeriesIdx union all
		select 'MTH' as Period,'MTH36' as Series,	3 as SeriesIdx union all
		select 'MTH' as Period,'MTH48' as Series,	2 as SeriesIdx
	) a, (
		select distinct Region,Audi_des,MoneyType,market,Productname,prod 
		from dbo.OutputCityPerformanceByBrand_For_OtherETV 
		where Chart='Growth Trend' and class='N' and  molecule='N' and Mkt NOT in('DPP4','Eliquis NOAC','Eliquis VTet') and not (mkt = 'Eliquis VTep' and Prod = '600'  )
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
				set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.OutputCityPerformanceByBrand_For_OtherETV B
				on A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'and B.Chart=''Growth Trend'' and B.Class=''N'' 
				and  B.molecule=''N'' and B.Mkt NOT in(''DPP4'',''Eliquis NOAC'',''Eliquis VTet'') and not (mkt = ''Eliquis VTep'' and Prod = ''600''  )
				and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and A.ParentGeo=B.region and A.geo=B.audi_des'
			print @SQL2
			exec( @SQL2)

		END
		FETCH NEXT FROM TMP_CURSOR INTO @Series
	END
	CLOSE TMP_CURSOR
	DEALLOCATE TMP_CURSOR
	go

	-- declare @code varchar(10)
	-- set @code = 'D103'
	-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
	-- select 'Y',Region,Audi_des,b.Market,'City',Period, @code as Code, b.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
	-- from (
	-- 	select 'R3M00' as Series,	6 as SeriesIdx union all
	-- 	select 'R3M01' as Series,	5 as SeriesIdx union all
	-- 	select 'R3M02' as Series,	4 as SeriesIdx union all
	-- 	select 'R3M03' as Series,	3 as SeriesIdx union all
	-- 	select 'R3M04' as Series,	2 as SeriesIdx union all
	-- 	select 'R3M05' as Series,	1 as SeriesIdx
	-- ) a, (
	-- 	select distinct Region,Audi_des,'MQT' as Period,MoneyType,market,Productname,prod 
	-- 	from dbo.OutputCityPerformanceByBrand 
	-- 	where Chart='Growth Trend' and class='N' and  molecule='N' and Mkt='DPP4'
	-- ) b

	-- DECLARE TMP_CURSOR CURSOR
	-- READ_ONLY
	-- FOR select distinct X  from dbo.[output_stage] where LinkChartCode=@code
	-- DECLARE @Series varchar(100)
	-- DECLARE @SQL2 VARCHAR(8000)
	
	-- OPEN TMP_CURSOR
	
	-- FETCH NEXT FROM TMP_CURSOR INTO @Series
	-- WHILE (@@FETCH_STATUS <> -1)
	-- BEGIN

	-- 	IF (@@FETCH_STATUS <> -2)
	-- 	BEGIN
	-- 		print @Series

	-- 		set @SQL2='
	-- 			update [output_stage]
	-- 			set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.OutputCityPerformanceByBrand B
	-- 			on A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'and B.Chart=''Growth Trend'' and B.Class=''N'' and  B.molecule=''N'' and B.Mkt=''DPP4''
	-- 			and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and A.ParentGeo=B.region and A.geo=B.audi_des'
	-- 		print @SQL2
	-- 		exec( @SQL2)

	-- 	END
	-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
	-- END
	-- CLOSE TMP_CURSOR
	-- DEALLOCATE TMP_CURSOR
	-- go
	delete from [output_stage] where LinkChartCode='D093'
	declare @code varchar(10)
	set @code = 'D093'
	insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
	select 'Y',Region,Audi_des,b.Market,'City',a.Period, @code as Code, b.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
	from (
		select 'MQT' as Period, 'R3M00' as Series,	6 as SeriesIdx union all
		select 'MQT' as Period, 'R3M01' as Series,	5 as SeriesIdx union all
		select 'MQT' as Period, 'R3M02' as Series,	4 as SeriesIdx union all
		select 'MQT' as Period, 'R3M03' as Series,	3 as SeriesIdx union all
		select 'MQT' as Period, 'R3M04' as Series,	2 as SeriesIdx union all
		select 'MQT' as Period, 'R3M05' as Series,	1 as SeriesIdx union all
		select 'YTD' as Period, 'YTD00' as Series,	6 as SeriesIdx union all
		select 'YTD' as Period, 'YTD12' as Series,	5 as SeriesIdx union all
		select 'YTD' as Period, 'YTD24' as Series,	4 as SeriesIdx union all
		select 'YTD' as Period, 'YTD36' as Series,	3 as SeriesIdx union all
		select 'YTD' as Period, 'YTD48' as Series,	2 as SeriesIdx union all

		select 'MAT' as Period,'MAT00' as Series,	6 as SeriesIdx union all
		select 'MAT' as Period,'MAT12' as Series,	5 as SeriesIdx union all
		select 'MAT' as Period,'MAT24' as Series,	4 as SeriesIdx union all
		select 'MAT' as Period,'MAT36' as Series,	3 as SeriesIdx union all
		select 'MAT' as Period,'MAT48' as Series,	2 as SeriesIdx union all

		select 'MTH' as Period,'MTH00' as Series,	6 as SeriesIdx union all
		select 'MTH' as Period,'MTH12' as Series,	5 as SeriesIdx union all
		select 'MTH' as Period,'MTH24' as Series,	4 as SeriesIdx union all
		select 'MTH' as Period,'MTH36' as Series,	3 as SeriesIdx union all
		select 'MTH' as Period,'MTH48' as Series,	2 as SeriesIdx 
	) a, (
		select distinct Region,Audi_des,MoneyType,market,Productname,prod 
		from dbo.OutputCityPerformanceByBrand 
		where Chart='Growth Trend' and (Class='Y' or  molecule='Y')
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
			set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.OutputCityPerformanceByBrand B
			on A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'and B.Chart=''Growth Trend'' and (B.Class=''Y'' or  B.molecule=''Y'')
			and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and A.ParentGeo=B.region and A.geo=B.audi_des'
			print @SQL2
			exec( @SQL2)

		END
		FETCH NEXT FROM TMP_CURSOR INTO @Series
	END
	CLOSE TMP_CURSOR
	DEALLOCATE TMP_CURSOR
	go

	delete from [output_stage] where LinkChartCode= 'D084'
	declare @code varchar(10)
	set @code = 'D084'
	insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
	select 'Y',Region,Audi_des,b.Market,'City',a.Period, @code as Code,a.Series,a.SeriesIdx ,MoneyType,b.Productname,B.prod
	from (
		select 'MQT' as Period,'R3M00' as Series,	1 as SeriesIdx union all
		select 'YTD' as Period,'YTD00' as Series,	1 as SeriesIdx union all
		select 'MAT' as Period,'MAT00' as Series,	1 as SeriesIdx union all
		select 'MTH' as Period,'MTH00' as Series,	1 as SeriesIdx 
	) a, (
		select distinct Region,Audi_des,MoneyType,market,Productname,prod 
		from dbo.OutputCityPerformanceByBrand_For_OtherETV 
		where Chart='Share of Growth Trend' and Class='N' and  molecule='N' and Mkt NOT in('DPP4','Eliquis NOAC','Eliquis VTet') and not (mkt = 'Eliquis VTep' and Prod = '600'  )
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
				set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.OutputCityPerformanceByBrand_For_OtherETV B
				on A.Currency=B.MoneyType and A.Series='+''''+@Series+''''+'and B.Chart=''Share of Growth Trend'' 
				and B.Class=''N'' and  B.molecule=''N'' and B.Mkt NOT in(''DPP4'',''Eliquis NOAC'',''Eliquis VTet'') and not (mkt = ''Eliquis VTep'' and Prod = ''600''  )
				and a.LinkChartCode = '+''''+@code+''''+' and A.X=B.Productname and A.ParentGeo=B.region and A.geo=B.audi_des'
			print @SQL2
			exec( @SQL2)

		END
		FETCH NEXT FROM TMP_CURSOR INTO @Series
	END
	CLOSE TMP_CURSOR
	DEALLOCATE TMP_CURSOR
	go


	-- declare @code varchar(10)
	-- set @code = 'D104'
	-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
	-- select 'Y',Region,Audi_des,b.Market,'City',Period, @code as Code,a.Series,a.SeriesIdx ,MoneyType,b.Productname,B.prod
	-- from (
	-- 	select 'R3M00' as Series, 1 as SeriesIdx
	-- ) a, (
	-- 	select distinct Region,Audi_des,'MQT' as Period,MoneyType,market,Productname,prod 
	-- 	from dbo.OutputCityPerformanceByBrand 
	-- 	where Chart='Share of Growth Trend' and Class='N' and  molecule='N' and Mkt='DPP4'
	-- ) b

	-- DECLARE TMP_CURSOR CURSOR
	-- READ_ONLY
	-- FOR select distinct Series  from dbo.[output_stage] where LinkChartCode=@code
	-- DECLARE @Series varchar(100)
	-- DECLARE @SQL2 VARCHAR(8000)
	
	-- OPEN TMP_CURSOR
	
	-- FETCH NEXT FROM TMP_CURSOR INTO @Series
	-- WHILE (@@FETCH_STATUS <> -1)
	-- BEGIN

	-- 	IF (@@FETCH_STATUS <> -2)
	-- 	BEGIN
	-- 		print @Series

	-- 		set @SQL2='
	-- 			update [output_stage]
	-- 			set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.OutputCityPerformanceByBrand B
	-- 			on A.Currency=B.MoneyType and A.Series='+''''+@Series+''''+'and B.Chart=''Share of Growth Trend'' and B.Class=''N'' and  B.molecule=''N'' and B.Mkt=''DPP4''
	-- 			and a.LinkChartCode = '+''''+@code+''''+' and A.X=B.Productname and A.ParentGeo=B.region and A.geo=B.audi_des'
	-- 		print @SQL2
	-- 		exec( @SQL2)

	-- 	END
	-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
	-- END
	-- CLOSE TMP_CURSOR
	-- DEALLOCATE TMP_CURSOR
	go
	delete from [output_stage] where LinkChartCode='D094'
	declare @code varchar(10)
	set @code = 'D094'
	insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
	select 'Y',Region,Audi_des,b.Market,'City',a.Period, @code as Code, a.Series,a.SeriesIdx,MoneyType, b.Productname,B.prod
	from (
		select 'MQT' as Period, 'R3M00' as Series, 1 as SeriesIdx union all
		select 'YTD' as Period, 'YTD00' as Series, 1 as SeriesIdx union all
		select 'MAT' as Period, 'MAT00' as Series, 1 as SeriesIdx union all
		select 'MTH' as Period, 'MTH00' as Series, 1 as SeriesIdx
	) a, (
		select distinct Region,Audi_des,MoneyType,market,Productname,prod 
		from dbo.OutputCityPerformanceByBrand 
		where Chart='Share of Growth Trend' and (Class='Y' or  molecule='Y')
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
				set Y=B.'+@Series+ ' 
				from [output_stage] A 
				inner join dbo.OutputCityPerformanceByBrand B
				on A.Currency=B.MoneyType and A.Series='+''''+@Series+''''+'and B.Chart=''Share of Growth Trend'' and (B.Class=''Y'' or  B.molecule=''Y'')
					and a.LinkChartCode = '+''''+@code+''''+' and A.X=B.Productname and A.ParentGeo=B.region and A.geo=B.audi_des'
			print @SQL2
			exec( @SQL2)

		END
		FETCH NEXT FROM TMP_CURSOR INTO @Series
	END
	CLOSE TMP_CURSOR
	DEALLOCATE TMP_CURSOR
	go

	update [output_stage]
	set LinkSeriesCode=Product+'_'+LinkChartCode+'_'+geo+Series+cast(SeriesIdx as varchar(10)) 
	where  LinkChartCode like 'D08%' or LinkChartCode like 'D09%' or LinkChartCode like 'D10%'
	go
	update [output_stage]
	set Category=case Currency when 'UN' then 'Units' else 'Value' end
	where LinkChartCode like 'D08%' or LinkChartCode like 'D09%' or LinkChartCode like 'D10%'
	go
	update [output_stage]
	set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' else Currency end 
	where  LinkChartCode like 'D08%' or LinkChartCode like 'D09%' or LinkChartCode like 'D10%'
	go
	update [output_stage]
	set X=case X 
		when 'R3M00' then 'MQT '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'R3M01' then 'MQT '+(select [MonthEN] from tblMonthList where monseq=4)
		when 'R3M02' then 'MQT '+(select [MonthEN] from tblMonthList where monseq=7)
		when 'R3M03' then 'MQT '+(select [MonthEN] from tblMonthList where monseq=10)
		when 'R3M04' then 'MQT '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'R3M05' then 'MQT '+(select [MonthEN] from tblMonthList where monseq=16)
		when 'YTD00' then 'YTD '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'YTD12' then 'YTD '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'YTD24' then 'YTD '+(select [MonthEN] from tblMonthList where monseq=25)
		when 'YTD36' then 'YTD '+(select [MonthEN] from tblMonthList where monseq=37)
		when 'YTD48' then 'YTD '+(select [MonthEN] from tblMonthList where monseq=49)

		when 'MAT00' then 'MAT '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'MAT12' then 'MAT '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'MAT24' then 'MAT '+(select [MonthEN] from tblMonthList where monseq=25)
		when 'MAT36' then 'MAT '+(select [MonthEN] from tblMonthList where monseq=37)
		when 'MAT48' then 'MAT '+(select [MonthEN] from tblMonthList where monseq=49)

		when 'MTH00' then 'MTH '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'MTH12' then 'MTH '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'MTH24' then 'MTH '+(select [MonthEN] from tblMonthList where monseq=25)
		when 'MTH36' then 'MTH '+(select [MonthEN] from tblMonthList where monseq=37)
		when 'MTH48' then 'MTH '+(select [MonthEN] from tblMonthList where monseq=49)
		else X
		end 
	where LinkChartCode like 'D08%' or LinkChartCode like 'D09%' or LinkChartCode like 'D10%'
	go
	update output_stage set Color='4E71D1' 
	where  LinkChartCode in ('D084','D094','D104')
	go

	delete from output_stage where series in('ARV Others','NIAD Others','ONCFCS Others')
	 and (LinkChartCode like 'D08%' or LinkChartCode like 'D09%' or LinkChartCode like 'D10%')
	go
	update output_stage
	set Y=0 
	where (linkchartcode='D081' or linkchartcode='D091' or linkchartcode='D101') and (y is null or cast(y as float)=0)

	update output_stage
	set series = case series
		when 'R3M00' then 'MQT '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'R3M01' then 'MQT '+(select [MonthEN] from tblMonthList where monseq=4)
		when 'R3M02' then 'MQT '+(select [MonthEN] from tblMonthList where monseq=7)
		when 'R3M03' then 'MQT '+(select [MonthEN] from tblMonthList where monseq=10)
		when 'R3M04' then 'MQT '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'R3M05' then 'MQT '+(select [MonthEN] from tblMonthList where monseq=16)
		when 'YTD00' then 'YTD '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'YTD12' then 'YTD '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'YTD24' then 'YTD '+(select [MonthEN] from tblMonthList where monseq=25)
		when 'YTD36' then 'YTD '+(select [MonthEN] from tblMonthList where monseq=37)
		when 'YTD48' then 'YTD '+(select [MonthEN] from tblMonthList where monseq=49)

		when 'MAT00' then 'MAT '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'MAT12' then 'MAT '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'MAT24' then 'MAT '+(select [MonthEN] from tblMonthList where monseq=25)
		when 'MAT36' then 'MAT '+(select [MonthEN] from tblMonthList where monseq=37)
		when 'MAT48' then 'MAT '+(select [MonthEN] from tblMonthList where monseq=49)

		when 'MTH00' then 'MTH '+(select [MonthEN] from tblMonthList where monseq=1)
		when 'MTH12' then 'MTH '+(select [MonthEN] from tblMonthList where monseq=13)
		when 'MTH24' then 'MTH '+(select [MonthEN] from tblMonthList where monseq=25)
		when 'MTH36' then 'MTH '+(select [MonthEN] from tblMonthList where monseq=37)
		when 'MTH48' then 'MTH '+(select [MonthEN] from tblMonthList where monseq=49)
		else series
		end 
	where LinkChartCode like 'D09%'
go
-- -----------------------------------------------------
-- --		CIA-CV_Modification(Eliquis) Slide2: Left part
-- -----------------------------------------------------
-- declare @code varchar(10)		
-- set @code='C660'
delete from output_stage where LinkChartCode='C660'

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- select 'Y' as IsShow,
-- 		'China','China',market,'China',left(X,3) as TimeFrame,@code,ProductName as Series,
-- 		case when ProductName='Eliquis (VTEP) Market' then 5
-- 		     when ProductName='ELIQUIS' then 1
-- 		     when ProductName='XARELTO' then 2
-- 		     when ProductName='FRAXIPARINE' then 3 
-- 		     when ProductName='CLEXANE' then 4
-- 			 when ProductName='ARIXTRA' then 5
-- 		end as SeriesIdx,
-- 		case when MoneyType='US' then 'USD' end as Currency,
-- 		X,
-- 		10-cast( right(X,1) as int) as XIdx,
-- 		 Y		
-- from Output_CIA_CV_Modification_Slide_2
-- where Productname  in ('Eliquis (VTEP) Market', 'ELIQUIS','XARELTO', 'FRAXIPARINE', 'CLEXANE', 'ARIXTRA')

-- update output_stage
-- set X= case when X LIKE 'MTH%' then (select distinct MonthEN from tblMonthList where MonSeq =cast( right(X,1) as int)+1) 
-- 			when X Like 'QTR%' then (select distinct cast([Year] as char(4))+Quarter  from 
-- 															(select distinct	year,quarter,
-- 															dense_rank() over(order by QtrSeq)	 as QtrSeq
-- 															from tblMonthList ) a
-- 													  where QtrSeq=cast( right(X,1) as int)+1 
-- 									  )
-- 			end 
	    	 
-- where LinkChartCode='C660'

-- update [output_stage]
-- set LinkSeriesCode=Product+'_'+LinkChartCode+Series+cast(SeriesIdx as varchar(10)) 
-- where LinkChartCode='C660' and IsShow = 'Y'

-- update [output_stage]
-- set LinkSeriesCode=Product+'_'+LinkChartCode+'_'+geo+isshow+cast(SeriesIdx as varchar(10)) 
-- where LinkChartCode = 'C660' and IsShow = 'L'

-- go

-- --c661
-- declare @code varchar(10)		
-- set @code='C661'
delete from output_stage where LinkChartCode='C661'

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- select 'Y' as IsShow,
-- 		'China','China',market,'China',left(X,3) as TimeFrame,@code,ProductName as Series,
-- 		case when ProductName='Eliquis (NOAC) Market' then 4
-- 		     when ProductName='ELIQUIS' then 1
-- 		     when ProductName='XARELTO' then 2
-- 		     when ProductName='PRADAXA' then 3 
-- 		end as SeriesIdx,
-- 		case when MoneyType='US' then 'USD' end as Currency,
-- 		X,
-- 		10-cast( right(X,1) as int) as XIdx,
-- 		 Y		
-- from Output_CIA_CV_Modification_Slide_2_NOAC

-- update output_stage
-- set X= case when X LIKE 'MTH%' then (select distinct MonthEN from tblMonthList where MonSeq =cast( right(X,1) as int)+1) 
-- 			when X Like 'QTR%' then (select distinct cast([Year] as char(4))+Quarter  from 
-- 															(select distinct	year,quarter,
-- 															dense_rank() over(order by QtrSeq)	 as QtrSeq
-- 															from tblMonthList ) a
-- 													  where QtrSeq=cast( right(X,1) as int)+1 
-- 									  )
-- 			end 
	    	 
-- where LinkChartCode='C661'

-- update [output_stage]
-- set LinkSeriesCode=Product+'_'+LinkChartCode+Series+cast(SeriesIdx as varchar(10)) 
-- where LinkChartCode='C661' and IsShow = 'Y'

-- update [output_stage]
-- set LinkSeriesCode=Product+'_'+LinkChartCode+'_'+geo+isshow+cast(SeriesIdx as varchar(10)) 
-- where LinkChartCode = 'C661' and IsShow = 'L'

-- go
-- --C661 END
-- -----------------------------------------------------
-- --		CIA-CV_Modification(Eliquis) Slide2: Right part
-- -----------------------------------------------------
declare @code varchar(10)
set @code='C690'
delete from output_stage where LinkChartCode=@code

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- select 'Y' as IsShow,
-- 		'China','China',market,'China',TimeFrame,@code,ProductName as Series,
-- 		case when ProductName='Eliquis Market' then 6
-- 		     when ProductName='ELIQUIS' then 1
-- 		     when ProductName='XARELTO' then 2
-- 		     when ProductName='FRAXIPARINE' then 3 
-- 		     when ProductName='CLEXANE' then 4
-- 			 when ProductName='ARIXTRA' then 5
-- 		end as SeriesIdx,
-- 		'USD' as Currency,
-- 		X,
-- 		XIdx,
-- 		Y		
-- from Output_CIA_CV_MODI_Slide2_Right	
-- where Type='ProductTreatmentDayShare' or (Type='TreatmentDay' and prod='000')



-- update [output_stage]
-- set LinkSeriesCode=Product+'_'+LinkChartCode+Series+cast(SeriesIdx as varchar(10)) 
-- where LinkChartCode='C690' and IsShow = 'Y'

-- update [output_stage]
-- set LinkSeriesCode=Product+'_'+LinkChartCode+'_'+geo+isshow+cast(SeriesIdx as varchar(10)) 
-- where LinkChartCode = 'C690' and IsShow = 'L'

 go
-- --Eliquis NOAC
declare @code varchar(10)
set @code='C691'
delete from output_stage where LinkChartCode=@code

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- select 'Y' as IsShow,
-- 		'China','China',market,'China',TimeFrame,@code,ProductName as Series,
-- 		case when ProductName='Eliquis Market' then 4
-- 		     when ProductName='ELIQUIS' then 1
-- 		     when ProductName='XARELTO' then 2
-- 		     when ProductName='PRADAXA' then 3 
-- 		end as SeriesIdx,
-- 		'USD' as Currency,
-- 		X,
-- 		XIdx,
-- 		Y		
-- from Output_CIA_CV_MODI_Slide2_Right_NOAC
-- where Type='ProductTreatmentDayShare' or (Type='TreatmentDay' and prod='000')



-- update [output_stage]
-- set LinkSeriesCode=Product+'_'+LinkChartCode+Series+cast(SeriesIdx as varchar(10)) 
-- where LinkChartCode='C691' and IsShow = 'Y'

-- update [output_stage]
-- set LinkSeriesCode=Product+'_'+LinkChartCode+'_'+geo+isshow+cast(SeriesIdx as varchar(10)) 
-- where LinkChartCode = 'C691' and IsShow = 'L'

-- go
-- --eliquis noac end

if exists (select * from dbo.sysobjects where id = object_id(N'output_stage_bk') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table output_stage_bk
go
select * into output_stage_bk from output_stage

/*

Alter table output_stage_bk drop column intY
truncate table output_stage
insert into output_stage
select * from output_stage_bk
alter table output_stage add inty float

*/

exec dbo.sp_Log_Event 'Output','CIA','3_1_Output_D.sql','End',null,null