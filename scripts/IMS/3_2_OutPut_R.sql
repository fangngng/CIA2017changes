/*

前置依赖：
3_1_OutPut_D.sql

*/
use BMSChinaCIA_IMS_test --db4
GO
--6分钟
--5分钟

exec dbo.sp_Log_Event 'Output','CIA','3_2_Output_R.sql','Start',null,null





delete from output_stage where linkchartcode LIKE 'R%'
go

 



-- --------------------------------------------
-- -- R010
-- --------------------------------------------
-- delete from output_stage where linkchartcode='R010'
-- GO
-- declare @code varchar(10),@i int,@sql varchar(8000)
-- set @i=0
-- set @code = 'R010'
-- set @sql=''
-- set @sql=@sql+'insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
-- 	select isshow,A.Period, '+''''+@code+''''+' as Code, Market,B.Productname,B.prod,MoneyType,a.Series,a.SeriesIdx, ''China'',''China''
-- 	from (
-- 		select ''MAT'' as Period, ''MAT00'' as Series, 5 as SeriesIdx union all
-- 		select ''MAT'' as Period, ''MAT12'' as Series, 4 as SeriesIdx union all
-- 		select ''MAT'' as Period, ''MAT24'' as Series, 3 as SeriesIdx union all
-- 		select ''MAT'' as Period, ''MAT36'' as Series, 2 as SeriesIdx union all
-- 		select ''MAT'' as Period, ''MAT48'' as Series, 1 as SeriesIdx 
-- 	) a, (
-- 		select distinct case type when ''Sales'' then ''Y'' when ''Market Share'' then ''L'' when ''Growth'' then ''D'' else ''N'' end as isshow,MoneyType,mkt,Market,Prod,Productname 
--         from  [OurputPreMarketTrendT1_4_R010] where Market = ''Taxol'' and Productname = ''Oncology Market''
-- 	) b'
-- --print @sql
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

-- 		set @SQL2='
-- 		update [output_stage]
-- 		set Y=B.['+@Series+ '] from [output_stage] A inner join dbo.[OurputPreMarketTrendT1_4_R010] B
-- 		on case B.type when ''Sales'' then ''Y'' when ''Market Share'' then ''L'' when ''Growth'' then ''D'' else ''N'' end=A.isshow and A.Product=B.Market and A.X='+''''+@Series+''''+' and A.currency=b.Moneytype
-- 		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname  and  B.mkt<>''NIAD'''
-- --		print @SQL2
-- 		exec( @SQL2)

-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
-- go



--------------------------------------------
-- R520
--------------------------------------------
-- 清除历史冗余数据
delete from [output_stage] where LinkChartCode='R520'
GO
insert into [output_stage](LinkChartCode,Series,SeriesIdx,Product,lev,Geo,Currency,TimeFrame,X,XIdx,Y,Size,IsShow)
select 
 'R520'                                     --LinkChartCode
,CORP_des                                   --Series
,CurrRank                                   --SeriesIdx
,'Taxol'                                    --Product
,'Nation'                                   --lev
,'China'                                    --Geo
,MoneyType                                  --Currency
,Period                                     --TimeFrame
,Share                                      --X
,RANK() OVER (ORDER BY Share) AS Rank       --XIdx
,Mat00Growth                                --Y
,Mat00                                      --Size
,'Y'                                        --IsShow
from MID_TopIL_CompaniesPerformance  where MoneyType<>'PN'
GO


--后期处理
update [output_stage] set LinkedY=b.LinkY 
from [output_stage] A 
inner join(
select product,min(parentgeo) as LinkY  from outputgeo where lev=2
group by product
) B
on A.product=B.product
where A.LinkChartCode='R520'
go
update [output_stage] set LinkSeriesCode=Product+'_'+LinkChartCode+Series+cast(SeriesIdx as varchar(10)) where LinkChartCode='R520'
go
update [output_stage] set Category=case Currency when 'UN' then 'Dosing Units' else 'Value' end
where LinkChartCode='R520'
go
update [output_stage] set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' else Currency end 
where LinkChartCode='R520'
go

-- select * from [output_stage] where LinkChartCode='R520' 





--------------------------------------------
-- R020
--------------------------------------------
delete from output_stage where linkchartcode='R020'
declare @code varchar(10),@i int,@sql varchar(8000)
set @i=0
set @code = 'R020'
set @sql=''
set @sql=@sql+'insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
	select isshow,A.Period, '+''''+@code+''''+' as Code, Market,B.Productname,B.prod,MoneyType,a.Series,a.SeriesIdx, ''China'',''China''
	from (
		select ''MAT'' as Period, ''MAT00'' as Series, 5 as SeriesIdx union all
		select ''MAT'' as Period, ''MAT12'' as Series, 4 as SeriesIdx union all
		select ''MAT'' as Period, ''MAT24'' as Series, 3 as SeriesIdx union all
		select ''MAT'' as Period, ''MAT36'' as Series, 2 as SeriesIdx union all
		select ''MAT'' as Period, ''MAT48'' as Series, 1 as SeriesIdx union all
		select ''YTD'' as Period, ''YTD00'' as Series, 5 as SeriesIdx union all
		select ''YTD'' as Period, ''YTD12'' as Series, 4 as SeriesIdx union all
		select ''YTD'' as Period, ''YTD24'' as Series, 3 as SeriesIdx union all
		select ''YTD'' as Period, ''YTD36'' as Series, 2 as SeriesIdx union all
		select ''YTD'' as Period, ''YTD48'' as Series, 1 as SeriesIdx
	) a, (
		select distinct case type when ''Sales'' then ''Y'' when ''Market Share'' then ''L'' when ''Growth'' then ''D'' else ''N'' end as isshow,MoneyType,mkt,Market,Prod,Productname from  dbo.[OurputPreMarketTrendT1] where mkt<>''NIAD''
	) b where b.market not like ''Eliquis%'''
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
		set Y=B.['+@Series+ '] from [output_stage] A inner join dbo.[OurputPreMarketTrendT1] B
		on case B.type when ''Sales'' then ''Y'' when ''Market Share'' then ''L'' when ''Growth'' then ''D'' else ''N'' end=A.isshow and A.Product=B.Market and A.X='+''''+@Series+''''+' and A.currency=b.Moneytype
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname  and  B.mkt<>''NIAD'''
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
--delete from output_stage where linkchartcode='R020' and product='baraclude'
--and isshow='n' and X<>'MAT00'

delete from output_stage where linkchartcode='R020' and product='baraclude'
and isshow='n' and X<>'MAT00' AND x<>'YTD00'
go
update [output_stage]
set isshow='Y',
    Series=Series+' Growth',
    Seriesidx=(Seriesidx+1)*1000
where isshow='D' and linkchartcode='r020' and product='baraclude' 
go
update output_stage
set Series='Market Share % ARV Category' where linkchartcode='R020' and product='baraclude' and isshow='L'
go


-- --------------------------------------------
-- -- R030
-- --------------------------------------------
-- delete from output_stage where linkchartcode='R030'
-- declare @code varchar(10),@i int,@sql varchar(8000)
-- set @i=0
-- set @code = 'R030'
-- set @sql=''
-- set @sql=@sql+'insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
-- select isshow,A.Period, '+''''+@code+''''+' as Code, Market,B.Productname,B.prod,MoneyType,a.Series,a.SeriesIdx, ''China'',''China''
-- from ('
-- --print @sql
-- while (@i<=48)
-- begin
-- set @sql=@sql+'select  ''MAT'' as Period,'+''''+'MAT'+right('00'+cast(@i as varchar(3)),2)+''+''''+' as Series,'+cast(48-@i+1 as varchar(3))+' as SeriesIdx union all
-- '
-- set @i=@i+12
-- end
-- set  @sql=left(@sql,len(@sql)-11)+') a, (
-- 	select distinct case type when ''Sales'' then ''Y'' when ''Market Share'' then ''L'' when ''Growth'' then ''D'' else ''N'' end as isshow,MoneyType,mkt,Market,Prod,Productname from  dbo.[OurputPreMarketTrendT1] where mkt=''NIAD''
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
-- 		set Y=B.['+@Series+ '] from [output_stage] A inner join dbo.[OurputPreMarketTrendT1] B
-- 		on case B.type when ''Sales'' then ''Y'' when ''Market Share'' then ''L'' when ''Growth'' then ''D'' else ''N'' end=A.isshow and A.Product=B.Market and A.X='+''''+@Series+''''+' and A.currency=b.Moneytype
-- 		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname  and  B.mkt=''NIAD'''
-- 		print @SQL2
-- 		exec( @SQL2)

-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
-- go


--------------------------------------------
-- R040
--------------------------------------------
delete [output_stage] where LinkChartCode = 'R040'
declare @code varchar(10)
set @code = 'R040'
insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
select B.isshow,a.Period, @code as Code,B.market,a.Series,a.SeriesIdx,MoneyType,B.Productname,B.CurrRank,'China','China'
from (
	select 'MAT' as Period, 'MAT00' as Series,	2 as SeriesIdx union all
	select 'MAT' as Period, 'MAT12' as Series,	1 as SeriesIdx union all
	select 'MAT' as Period, 'MAT00Growth' as Series,	3 as SeriesIdx union all
	select 'YTD' as Period, 'YTD00' as Series,	2 as SeriesIdx union all
	select 'YTD' as Period, 'YTD12' as Series,	1 as SeriesIdx union all
	select 'YTD' as Period, 'YTD00Growth' as Series,	3 as SeriesIdx 
) a, (
	select distinct case type when 'Sales' then 'Y' when 'Market Share' then 'L' else 'N' end as isshow,MoneyType,mkt,Market,Prod,Productname,CurrRank from dbo.[OurputPreBrandTotalPerformance]
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
		set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.[OurputPreBrandTotalPerformance] B
		on case B.type when ''Sales'' then ''Y'' when ''Market Share'' then ''L'' else ''N'' end=A.isshow  and A.Currency=B.MoneyType and A.Series='+''''+@Series+''''+'
		and a.LinkChartCode = '+''''+@code+''''+' and A.X=B.productname'
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
delete from output_stage where linkchartcode='r040' and isshow='L'
and Seriesidx=3
go
update [output_stage]
set Series= case Series 
when 'MAT00' then 'Market Share ('+ TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)+')'
when 'MAT12' then 'Market Share ('+ TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)+')'
when 'MAT24' then 'Market Share ('+ TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)+')'
when 'MAT36' then 'Market Share ('+ TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)+')'
when 'MAT48' then 'Market Share ('+ TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)+')'
when 'YTD00' then 'Market Share ('+ TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)+')'
when 'YTD12' then 'Market Share ('+ TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)+')'
when 'YTD24' then 'Market Share ('+ TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)+')'
when 'YTD36' then 'Market Share ('+ TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)+')'
when 'YTD48' then 'Market Share ('+ TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)+')'
else Series
end where linkchartcode='R040' and isshow='L'



--------------------------------------------
-- R050
--------------------------------------------
delete from output_stage where linkchartcode='R051'

declare @code varchar(10)
set @code = 'R051'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select B.Isshow,'China','China',b.Market,'China',a.Period, @code as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
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
	select 'YTD' as Period, 'YTD48' as Series,	2 as SeriesIdx 
) a, (
	select distinct case type when 'sales' then 'Y' else 'N' end as isshow,MoneyType,market,mkt,Productname,Prod 
	from [OurputPreMarketPerformance] 
	where type in('Sales','CAGR') 
		and (molecule='N' and class='N') and mkt not in('Dia','ACE','DPP4')
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
		set Y=B.'+@Series+ ' from [output_stage] A inner join [OurputPreMarketPerformance] B 
		on case B.type when ''sales'' then ''Y'' else ''N'' end=A.isshow and A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and B.type in(''Sales'',''CAGR'') 
        and (molecule=''N'' and class=''N'') and mkt not in(''Dia'',''ACE'',''DPP4'')'
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
delete output_stage where linkchartcode='R051' and isshow='N' and xidx<>6


delete from output_stage where linkchartcode='R052'

declare @code varchar(10)
set @code = 'R052'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select B.Isshow,'China','China',b.Market,'China',a.Period, @code as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
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
	select 'YTD' as Period, 'YTD48' as Series,	2 as SeriesIdx 
) a, (
	select distinct 'Y' as isshow, MoneyType,market,mkt,Productname,Prod from [OurputPreMarketPerformance] where type in('Market Share') 
and (molecule='N' and class='N') and mkt not in('Dia','ACE','DPP4')
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
		set Y=B.'+@Series+ ' from [output_stage] A inner join [OurputPreMarketPerformance] B 
		on  A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and B.type in(''Market Share'') 
        and (molecule=''N'' and class=''N'') and mkt not in(''Dia'',''ACE'',''DPP4'')'
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go

delete from output_stage where linkchartcode='R053'

declare @code varchar(10)
set @code = 'R053'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select B.Isshow,'China','China',b.Market,'China',a.Period, @code as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
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
	select 'YTD' as Period, 'YTD48' as Series,	2 as SeriesIdx 
) a, (
	select distinct 'Y' as isshow, MoneyType,market,mkt,Productname,Prod from [OurputPreMarketPerformance] where type in('Growth') 
and (molecule='N' and class='N') and mkt not in('Dia','ACE','DPP4')
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
		set Y=B.'+@Series+ ' from [output_stage] A inner join [OurputPreMarketPerformance] B 
		on  A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and B.type in(''Growth'') 
        and (molecule=''N'' and class=''N'') and mkt not in(''Dia'',''ACE'',''DPP4'')'
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go

delete from output_stage where linkchartcode='R054'

declare @code varchar(10)
set @code = 'R054'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select B.Isshow,'China','China',b.Market,'China',Period, @code as Code,  a.Series,a.SeriesIdx,MoneyType,B.Productname,B.prod
from (
	select 'MQT' as Period, 'R3M00' as Series, 6 as SeriesIdx union all
	select 'YTD' as Period, 'YTD00' as Series, 6 as SeriesIdx 
) a, (
	select distinct 'Y' as isshow,MoneyType,market,mkt,Productname,Prod from [OurputPreMarketPerformance] where type in('Share of Growth') 
and (molecule='N' and class='N') and mkt not in('Dia','ACE','DPP4')
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
		set Y=B.'+@Series+ ' from [output_stage] A inner join [OurputPreMarketPerformance] B 
		on  A.Currency=B.MoneyType and A.Series='+''''+@Series+''''+'
		and a.LinkChartCode = '+''''+@code+''''+' and A.X=B.Productname and B.type in(''Share of Growth'') 
        and (molecule=''N'' and class=''N'') and mkt not in(''Dia'',''ACE'',''DPP4'')'
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go


-- --------------------------------------------
-- -- R080
-- --------------------------------------------
-- delete from output_stage where linkchartcode='R081'

-- declare @code varchar(10)
-- set @code = 'R081'
-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
-- select B.Isshow,'China','China',b.Market,'China',Period, @code as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
-- from (
-- 	select 'R3M00' as Series,					6 as SeriesIdx union all
-- 	select 'R3M01' as Series,				5 as SeriesIdx union all
-- 	select 'R3M02' as Series,		4 as SeriesIdx union all
-- 	select 'R3M03' as Series,	3 as SeriesIdx union all
-- 	select 'R3M04' as Series,	2 as SeriesIdx union all
-- 	select 'R3M05' as Series,	1 as SeriesIdx
-- ) a, (
-- 	select distinct case type when 'sales' then 'Y' else 'N' end as isshow,'MQT' as Period,MoneyType,market,mkt,Productname,Prod from [OurputPreMarketPerformance] where type in('Sales','CAGR') 
-- and (molecule='N' and class='N') and mkt ='DPP4'
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
-- 		set Y=B.'+@Series+ ' from [output_stage] A inner join [OurputPreMarketPerformance] B 
-- 		on case B.type when ''sales'' then ''Y'' else ''N'' end=A.isshow and A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'
-- 		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and B.type in(''Sales'',''CAGR'') 
--         and (molecule=''N'' and class=''N'') and mkt =''DPP4'''
-- 		print @SQL2
-- 		exec( @SQL2)

-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
-- go
-- delete output_stage where linkchartcode='R081' and isshow='N' and xidx<>6

go

delete from output_stage where linkchartcode='R061'

declare @code varchar(10)
set @code = 'R061'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select B.Isshow,'China','China',b.Market,'China',a.Period, @code as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
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
	select 'YTD' as Period, 'YTD48' as Series,	2 as SeriesIdx 

) a, (
	select distinct case type when 'sales' then 'Y' else 'N' end as isshow,MoneyType,market,mkt,Productname,Prod from [OurputPreMarketPerformance] where type in('Sales','CAGR') 
and (molecule='Y' or class='Y') and mkt not in('Dia','ACE','ONCFCS')) b

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
		set Y=B.'+@Series+ ' from [output_stage] A inner join [OurputPreMarketPerformance] B 
		on case B.type when ''sales'' then ''Y'' else ''N'' end=A.isshow and A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and B.type in(''Sales'',''CAGR'') 
        and (molecule=''Y'' or class=''Y'') and mkt not in(''Dia'',''ACE'',''ONCFCS'')'
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
delete output_stage where linkchartcode='R061' and isshow='N' and xidx<>6

go
-- delete from output_stage where linkchartcode='R071'

-- declare @code varchar(10)
-- set @code = 'R071'
-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
-- select B.Isshow,'China','China',b.Market,'China',Period, @code as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
-- from (
-- 	select 'R3M00' as Series,					6 as SeriesIdx union all
-- 	select 'R3M01' as Series,				5 as SeriesIdx union all
-- 	select 'R3M02' as Series,		4 as SeriesIdx union all
-- 	select 'R3M03' as Series,	3 as SeriesIdx union all
-- 	select 'R3M04' as Series,	2 as SeriesIdx union all
-- 	select 'R3M05' as Series,	1 as SeriesIdx
-- ) a, (
-- 	select distinct case type when 'sales' then 'Y' else 'N' end as isshow,'MQT' as Period,MoneyType,market,mkt,Productname,Prod from [OurputPreMarketPerformance] where type in('Sales','CAGR') 
--     and mkt in('Dia','ACE')) b

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
-- 		set Y=B.'+@Series+ ' from [output_stage] A inner join [OurputPreMarketPerformance] B 
-- 		on case B.type when ''sales'' then ''Y'' else ''N'' end=A.isshow and A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'
-- 		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and B.type in(''Sales'',''CAGR'') 
--         and mkt in(''Dia'',''ACE'')'
-- 		print @SQL2
-- 		exec( @SQL2)

-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
-- go
-- delete output_stage where linkchartcode='R071' and isshow='N' and xidx<>6


-- delete from output_stage where linkchartcode='R082'

-- declare @code varchar(10)
-- set @code = 'R082'
-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
-- select B.Isshow,'China','China',b.Market,'China',Period, @code as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
-- from (
-- 	select 'R3M00' as Series,					6 as SeriesIdx union all
-- 	select 'R3M01' as Series,				5 as SeriesIdx union all
-- 	select 'R3M02' as Series,		4 as SeriesIdx union all
-- 	select 'R3M03' as Series,	3 as SeriesIdx union all
-- 	select 'R3M04' as Series,	2 as SeriesIdx union all
-- 	select 'R3M05' as Series,	1 as SeriesIdx
-- ) a, (
-- 	select distinct 'Y' as isshow,'MQT' as Period,MoneyType,market,mkt,Productname,Prod from [OurputPreMarketPerformance] where type in('Market Share') 
-- and (molecule='N' and class='N') and mkt='DPP4'
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
-- 		set Y=B.'+@Series+ ' from [output_stage] A inner join [OurputPreMarketPerformance] B 
-- 		on  A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'
-- 		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and B.type in(''Market Share'') 
--         and (molecule=''N'' and class=''N'') and mkt=''DPP4'''
-- 		print @SQL2
-- 		exec( @SQL2)

-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
go

delete from output_stage where linkchartcode='R062'

declare @code varchar(10)
set @code = 'R062'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select B.Isshow,'China','China',b.Market,'China',a.Period, @code as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
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
	select 'YTD' as Period, 'YTD48' as Series,	2 as SeriesIdx 
) a, (
	select distinct 'Y' as isshow, MoneyType,market,mkt,Productname,Prod from [OurputPreMarketPerformance] where type in('Market Share') 
    and (molecule='Y' or class='Y') and mkt not in('Dia','ACE','ONCFCS')) b

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
		set Y=B.'+@Series+ ' from [output_stage] A inner join [OurputPreMarketPerformance] B 
		on A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and B.type in(''Market Share'') 
        and (molecule=''Y'' or class=''Y'') and mkt not in(''Dia'',''ACE'',''ONCFCS'')'
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
-- delete from output_stage where linkchartcode='R072'

-- declare @code varchar(10)
-- set @code = 'R072'
-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
-- select B.Isshow,'China','China',b.Market,'China',Period, @code as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
-- from (
-- 	select 'R3M00' as Series,					6 as SeriesIdx union all
-- 	select 'R3M01' as Series,				5 as SeriesIdx union all
-- 	select 'R3M02' as Series,		4 as SeriesIdx union all
-- 	select 'R3M03' as Series,	3 as SeriesIdx union all
-- 	select 'R3M04' as Series,	2 as SeriesIdx union all
-- 	select 'R3M05' as Series,	1 as SeriesIdx
-- ) a, (
-- 	select distinct 'Y' as isshow,'MQT' as Period,MoneyType,market,mkt,Productname,Prod from [OurputPreMarketPerformance] where type in('Market Share') 
--     and mkt in('Dia','ACE')) b

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
-- 		set Y=B.'+@Series+ ' from [output_stage] A inner join [OurputPreMarketPerformance] B 
-- 		on  A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'
-- 		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and B.type in(''Market Share'') 
--         and mkt in(''Dia'',''ACE'')'
-- 		print @SQL2
-- 		exec( @SQL2)

-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
go



-- delete from output_stage where linkchartcode='R083'

-- declare @code varchar(10)
-- set @code = 'R083'
-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
-- select B.Isshow,'China','China',b.Market,'China',Period, @code as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
-- from (
-- 	select 'R3M00' as Series,					6 as SeriesIdx union all
-- 	select 'R3M01' as Series,				5 as SeriesIdx union all
-- 	select 'R3M02' as Series,		4 as SeriesIdx union all
-- 	select 'R3M03' as Series,	3 as SeriesIdx union all
-- 	select 'R3M04' as Series,	2 as SeriesIdx union all
-- 	select 'R3M05' as Series,	1 as SeriesIdx
-- ) a, (
-- 	select distinct 'Y' as isshow,'MQT' as Period,MoneyType,market,mkt,Productname,Prod from [OurputPreMarketPerformance] where type in('Growth') 
-- and (molecule='N' and class='N') and mkt ='DPP4'
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
-- 		set Y=B.'+@Series+ ' from [output_stage] A inner join [OurputPreMarketPerformance] B 
-- 		on  A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'
-- 		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and B.type in(''Growth'') 
--         and (molecule=''N'' and class=''N'') and mkt =''DPP4'''
-- 		print @SQL2
-- 		exec( @SQL2)

-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
go

delete from output_stage where linkchartcode='R063'

declare @code varchar(10)
set @code = 'R063'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select B.Isshow,'China','China',b.Market,'China',a.Period, @code as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
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
	select 'YTD' as Period, 'YTD48' as Series,	2 as SeriesIdx 
) a, (
	select distinct 'Y' as isshow, MoneyType,market,mkt,Productname,Prod from [OurputPreMarketPerformance] where type in('Growth') 
    and (molecule='Y' or class='Y') and mkt not in('Dia','ACE','ONCFCS')) b

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
		set Y=B.'+@Series+ ' from [output_stage] A inner join [OurputPreMarketPerformance] B 
		on  A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and B.type in(''Growth'') 
        and (molecule=''Y'' or class=''Y'') and mkt not in(''Dia'',''ACE'',''ONCFCS'')'
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
-- delete from output_stage where linkchartcode='R073'

-- declare @code varchar(10)
-- set @code = 'R073'
-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
-- select B.Isshow,'China','China',b.Market,'China',Period, @code as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
-- from (
-- 	select 'R3M00' as Series,					6 as SeriesIdx union all
-- 	select 'R3M01' as Series,				5 as SeriesIdx union all
-- 	select 'R3M02' as Series,		4 as SeriesIdx union all
-- 	select 'R3M03' as Series,	3 as SeriesIdx union all
-- 	select 'R3M04' as Series,	2 as SeriesIdx union all
-- 	select 'R3M05' as Series,	1 as SeriesIdx
-- ) a, (
-- 	select distinct 'Y' as isshow,'MQT' as Period,MoneyType,market,mkt,Productname,Prod from [OurputPreMarketPerformance] where type in('Growth') 
--     and mkt in('Dia','ACE')) b

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
-- 		set Y=B.'+@Series+ ' from [output_stage] A inner join [OurputPreMarketPerformance] B 
-- 		on  A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'
-- 		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and B.type in(''Growth'') 
--         and mkt in(''Dia'',''ACE'')'
-- 		print @SQL2
-- 		exec( @SQL2)

-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
-- go

go
-- delete from output_stage where linkchartcode='R084'

-- declare @code varchar(10)
-- set @code = 'R084'
-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
-- select B.Isshow,'China','China',b.Market,'China',Period, @code as Code,  a.Series,a.SeriesIdx,MoneyType,B.Productname,B.prod
-- from (
-- 	select 'R3M00' as Series,					6 as SeriesIdx 
-- ) a, (
-- 	select distinct 'Y' as isshow,'MQT' as Period,MoneyType,market,mkt,Productname,Prod from [OurputPreMarketPerformance] where type in('Share of Growth') 
-- and (molecule='N' and class='N') and mkt ='DPP4'
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
-- 		update [output_stage]
-- 		set Y=B.'+@Series+ ' from [output_stage] A inner join [OurputPreMarketPerformance] B 
-- 		on  A.Currency=B.MoneyType and A.Series='+''''+@Series+''''+'
-- 		and a.LinkChartCode = '+''''+@code+''''+' and A.X=B.Productname and B.type in(''Share of Growth'') 
--         and (molecule=''N'' and class=''N'') and mkt=''DPP4'''
-- 		print @SQL2
-- 		exec( @SQL2)

-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
go
delete from output_stage where linkchartcode='R064'

declare @code varchar(10)
set @code = 'R064'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select B.Isshow,'China','China',b.Market,'China',a.Period, @code as Code, a.Series,a.SeriesIdx,MoneyType, B.Productname,B.prod
from (
	select 'MQT' as Period, 'R3M00' as Series, 6 as SeriesIdx union all
	select 'YTD' as Period, 'YTD00' as Series, 6 as SeriesIdx 
) a, (
	select distinct 'Y' as isshow,MoneyType,market,mkt,Productname,Prod from [OurputPreMarketPerformance] where type in('Share of Growth') 
    and (molecule='Y' or class='Y') and mkt not in('Dia','ACE','ONCFCS')) b

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
		set Y=B.'+@Series+ ' from [output_stage] A inner join [OurputPreMarketPerformance] B 
		on  A.Currency=B.MoneyType and A.Series='+''''+@Series+''''+'
		and a.LinkChartCode = '+''''+@code+''''+' and A.X=B.Productname and B.type in(''Share of Growth'') 
        and (molecule=''Y'' or class=''Y'') and mkt not in(''Dia'',''ACE'',''ONCFCS'')'
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
-- delete from output_stage where linkchartcode='R074'

-- declare @code varchar(10)
-- set @code = 'R074'
-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
-- select B.Isshow,'China','China',b.Market,'China',Period, @code as Code, a.Series,a.SeriesIdx,MoneyType, B.Productname,B.prod
-- from (
-- 	select 'R3M00' as Series,					6 as SeriesIdx
-- ) a, (
-- 	select distinct 'Y' as isshow,'MQT' as Period,MoneyType,market,mkt,Productname,Prod from [OurputPreMarketPerformance] where type in('Share of Growth') 
--     and mkt in('Dia','ACE')) b

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
-- 		update [output_stage]
-- 		set Y=B.'+@Series+ ' from [output_stage] A inner join [OurputPreMarketPerformance] B 
-- 		on  A.Currency=B.MoneyType and A.Series='+''''+@Series+''''+'
-- 		and a.LinkChartCode = '+''''+@code+''''+' and A.X=B.Productname and B.type in(''Share of Growth'') 
--         and mkt in(''Dia'',''ACE'')'
-- 		print @SQL2
-- 		exec( @SQL2)

-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
go

--R090
delete from output_stage where linkchartcode='R090'

declare @code varchar(10)
set @code = 'R090'



insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select IsShow,'China','China',Market,'China',Period, @code as Code, a.Series,a.SeriesIdx,MoneyType,b.Audi_des,b.[CurrRank]
from (
	select 'Qtr00' as Series,'Y' as IsShow,1 as SeriesIdx union all
	select 'Growth' as Series,'Y' ,2 as SeriesIdx union all
    select 'Avg.Growth' as Series,'Y' ,3 as SeriesIdx union all
	select 'CurrRank' as Series,'D',	4 as SeriesIdx union all
	select 'ChangeRank' as Series,'D',	5 as SeriesIdx union all
	select 'Contribution' as Series,'D' ,6 as SeriesIdx union all
	select 'TotalContribution' as Series,'N' ,7 as SeriesIdx
) a, (
	select distinct Period,MoneyType,Market,mkt,productname,Audi_des,
	case when CurrRank is null then RANK ( )OVER (PARTITION BY Period,MoneyType,Market,mkt,productname order by Qtr00 desc )+100 else CurrRank end as CurrRank from OutputPreCityPerformance 
    where Period in('MQT', 'YTD') and Moneytype<>'UN' and mkt not in ('Dia','ACE','DPP4') and prod='000'
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
		set Y=B.['+@Series+ '] from [output_stage] A inner join dbo.OutputPreCityPerformance B
		on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X=B.Audi_des and A.product=B.Market
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series='+''''+@Series+''''+' and mkt not in (''Dia'',''ACE'',''DPP4'') and prod=''000'''
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go

-- --ACE R100
-- delete from output_stage where linkchartcode='R100'

-- declare @code varchar(10)
-- set @code = 'R100'

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
-- select IsShow,'China','China',Market,'China',Period, @code as Code, a.Series,a.SeriesIdx,MoneyType,b.Audi_des,b.[CurrRank]
-- from (
-- 	select 'Qtr00' as Series,'Y' as IsShow,1 as SeriesIdx union all
-- 	select 'Growth' as Series,'Y' ,2 as SeriesIdx union all
--     select 'Avg.Growth' as Series,'Y' ,3 as SeriesIdx union all
-- 	select 'CurrRank' as Series,'D',	4 as SeriesIdx union all
-- 	select 'ChangeRank' as Series,'D',	5 as SeriesIdx union all
-- 	select 'Contribution' as Series,'D' ,6 as SeriesIdx union all
-- 	select 'TotalContribution' as Series,'N' ,7 as SeriesIdx
-- ) a, (
-- 	select distinct Period,MoneyType,Market,mkt,productname,Audi_des,case when CurrRank is null then RANK ( )OVER (PARTITION BY Period,MoneyType,Market,mkt,productname order by Qtr00 desc )+100 else CurrRank end as CurrRank from OutputPreCityPerformance 
--      where Period='MQT' and Moneytype<>'UN' and mkt in ('ACE') and prod='000'
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
-- 		update [output_stage]
-- 		set Y=B.['+@Series+ '] from [output_stage] A inner join dbo.OutputPreCityPerformance B
-- 		on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X=B.Audi_des and A.product=B.Market
-- 		and a.LinkChartCode = '+''''+@code+''''+' and A.Series='+''''+@Series+''''+' and mkt in (''ACE'') and prod=''000'''
-- 		print @SQL2
-- 		exec( @SQL2)

-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
-- go
-- --DIA R100
-- declare @code varchar(10)
-- set @code = 'R100'
-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
-- select distinct IsShow,'China','China',Market,'China',Period, @code as Code,a.Series,a.SeriesIdx,MoneyType,b.Audi_des,B.CurrRank
-- from (
-- 	select 'Qtr00' as Series,'Y' as IsShow,1 as SeriesIdx union all
-- --	select 'Growth' as Series,'Y' ,3 as SeriesIdx union all
-- --    select 'Avg.Growth' as Series,'Y' ,5 as SeriesIdx union all
-- 	select 'Qtr00' as Series,'Y' as IsShow,2 as SeriesIdx union all
-- 	select 'Growth' as Series,'Y' ,4 as SeriesIdx union all
--     select 'Avg.Growth' as Series,'Y' ,6 as SeriesIdx
-- ) a, (
-- 	select distinct Period,MoneyType,Market,mkt,Prod,productname,Audi_des, CurrRank
--  from OutputPreCityPerformance
--  where Period='MQT' and Moneytype<>'UN' and mkt='Dia' --Productname in ('NIAD Market','Insulin')
-- ) b


-- DECLARE TMP_CURSOR CURSOR
-- READ_ONLY
-- FOR select distinct Series  from dbo.[output_stage] where LinkChartCode=@code and Product='Glucophage'
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
-- 		set Y=B.['+@Series+ '] from [output_stage] A inner join dbo.OutputPreCityPerformance B
-- 		on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X=B.Audi_des and A.product=B.Market
-- 		and a.LinkChartCode = '+''''+@code+''''+' and A.Series='+''''+@Series+''''+'and 
--         case when A.Seriesidx in (1) then ''NIAD'' when A.Seriesidx in (2) then ''Insulin'' else ''Diabetes Market'' end=B.Productname and B.mkt=''Dia'''
-- 		print @SQL2
-- 		exec( @SQL2)

-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
-- go
-- go
-- update [output_stage]
-- set series=case series when 'Qtr00' then 'NIAD'
-- else series
-- end where LinkChartCode ='R100' and Product='Glucophage' and seriesidx in (1)
-- go
-- update [output_stage]
-- set series=case series when 'Qtr00' then 'Insulin'
-- else series
-- end where LinkChartCode ='R100' and Product='Glucophage' and seriesidx  in (2)
-- go
-- --DPP-IV R110
-- delete from output_stage where linkchartcode='R110'

-- declare @code varchar(10)
-- set @code = 'R110'

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
-- select IsShow,'China','China',Market,'China',Period, @code as Code, a.Series,a.SeriesIdx,MoneyType,b.Audi_des,b.[CurrRank]
-- from (
-- 	select 'Qtr00' as Series,'Y' as IsShow,1 as SeriesIdx union all
-- 	select 'Growth' as Series,'Y' ,2 as SeriesIdx union all
--     select 'Avg.Growth' as Series,'Y' ,3 as SeriesIdx union all
-- 	select 'CurrRank' as Series,'D',	4 as SeriesIdx union all
-- 	select 'ChangeRank' as Series,'D',	5 as SeriesIdx union all
-- 	select 'Contribution' as Series,'D' ,6 as SeriesIdx union all
-- 	select 'TotalContribution' as Series,'N' ,7 as SeriesIdx
-- ) a, (
-- 	select distinct Period,MoneyType,Market,mkt,productname,Audi_des,case when CurrRank is null then RANK ( )OVER (PARTITION BY Period,MoneyType,Market,mkt,productname order by Qtr00 desc )+100 else CurrRank end as CurrRank from OutputPreCityPerformance 
--      where Period='MQT' and Moneytype<>'UN' and productname like '%DPP%'
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
-- 		update [output_stage]
-- 		set Y=B.['+@Series+ '] from [output_stage] A inner join dbo.OutputPreCityPerformance B
-- 		on A.TimeFrame=B.Period and A.Currency=B.MoneyType and A.X=B.Audi_des and A.product=B.Market
-- 		and a.LinkChartCode = '+''''+@code+''''+' and A.Series='+''''+@Series+''''+' and B.productname like ''%DPP%'''
-- 		print @SQL2
-- 		exec( @SQL2)

-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @Series
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
go

delete from output_stage where linkchartcode='R120'

declare @code varchar(10)
set @code = 'R120'

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select 'Y','China','China',Market,'China',Period, @code as Code, Productname,Prod,MoneyType,b.Audi_des,CurrRank,share
from (
	select Period,MoneyType,Market,mkt,case when Productname like '%Generics%' then 10000 else Prod end as Prod,productname,Audi_des,share,CurrRank from OutputPreCityPerformance2
) b
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
where b.Market NOT LIKE 'Eliquis%'

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





---------------------------------------------
-- R401 R410
---------------------------------------------

delete from output_stage where linkchartcode='R401'

declare @i int,@sql varchar(8000),@code varchar(10)
set @code = 'R401'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select isshow,'China','China',b.Market,'China',Timeframe, @code as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
from (
	select 'R3M00' as Series,'Y' as isshow,19 as SeriesIdx union all
	select 'R3M01' as Series,'Y' as isshow,18 as SeriesIdx union all
	select 'R3M02' as Series,'Y' as isshow,17 as SeriesIdx union all
	select 'R3M03' as Series,'Y' as isshow,16 as SeriesIdx union all
	select 'R3M04' as Series,'Y' as isshow,15 as SeriesIdx union all
	select 'R3M05' as Series,'Y' as isshow,14 as SeriesIdx union all
	select 'R3M06' as Series,'Y' as isshow,13 as SeriesIdx union all
	select 'R3M07' as Series,'Y' as isshow,12 as SeriesIdx union all
	select 'R3M08' as Series,'Y' as isshow,11 as SeriesIdx union all
	select 'R3M09' as Series,'Y' as isshow,10 as SeriesIdx union all
	select 'R3M10' as Series,'Y' as isshow,9 as SeriesIdx union all
	select 'R3M11' as Series,'Y' as isshow,8 as SeriesIdx   union all
	select 'CAGR' as Series,'N' as isshow,100 as SeriesIdx
) a, (
select * from OutputKeyMoleculeBrandPerformance where Molecule='Y' and Market<>'Paraplatin' and MoneyType<>'PN'
union all
select * from OutputKeyMoleculeBrandPerformance where Molecule='Y' and Market='Paraplatin' and MoneyType<>'UN'
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
		set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.OutputKeyMoleculeBrandPerformance B
		on A.Product=B.Market and A.Currency=B.MoneyType and A.X='+''''+@Series+''''+' and B.molecule=''Y''
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and A.TimeFrame=B.TimeFrame'
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go



delete from output_stage where linkchartcode='R411'
GO

declare @i int,@sql varchar(8000),@code varchar(10)
set @code = 'R411'
set @i=0
set @sql=''
set @sql=@sql+'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select isshow,''China'',''China'',b.Market,''China'',Timeframe, '''+@code+''' as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
from ('
--print @sql
while (@i<=12)
begin
set @sql=@sql+'select '+''''+'R3M'+right('00'+cast(@i as varchar(3)),2)+''+''''+' as Series,''Y'' as isshow,'+cast(18-@i+1 as varchar(3))+' as SeriesIdx union all
'
set @i=@i+1
end
set  @sql=left(@sql,len(@sql)-11)+'  union all
select ''CAGR'' as Series,''N'' as isshow,100 as SeriesIdx
) a, (
select * from OutputKeyMoleculeBrandPerformance 
where Molecule=''N'' and class=''N''  and Market not in (''Taxol'',''Paraplatin'') and MoneyType<>''PN''
) b'
--print @sql
exec (@sql)
go

declare @i int,@sql varchar(8000),@code varchar(10)
set @code = 'R411'
set @i=0
set @sql=''
set @sql=@sql+'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select isshow,''China'',''China'',b.Market,''China'',Timeframe, '''+@code+''' as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
from ('
--print @sql
while (@i<=12)
begin
set @sql=@sql+'select '+''''+'R3M'+right('00'+cast(@i as varchar(3)),2)+''+''''+' as Series,''Y'' as isshow,'+cast(18-@i+1 as varchar(3))+' as SeriesIdx union all
'
set @i=@i+1
end
set  @sql=left(@sql,len(@sql)-11)+'  union all
select ''MonthGrowth'' as Series,''N'' as isshow,200 as SeriesIdx  
) a, (
select * from OutputKeyMoleculeBrandPerformance 
where Molecule=''N'' and class=''N''  and Market=''Taxol'' and MoneyType<>''PN''
union all 
select * from OutputKeyMoleculeBrandPerformance 
where Molecule=''N'' and class=''N''  and Market=''Paraplatin'' and MoneyType<>''UN''
) b'
--print @sql
exec (@sql)
go

declare @i int,@sql varchar(8000),@code varchar(10)
set @code = 'R411'
set @i=0
set @sql=''
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
		set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.OutputKeyMoleculeBrandPerformance B
		on A.Product=B.Market and A.Currency=B.MoneyType and A.X='+''''+@Series+''''+' and B.Molecule=''N'' and B.class=''N''
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and A.TimeFrame=B.TimeFrame'
		--print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
delete from output_stage where linkchartcode IN('R401','R411') and timeframe='MAT' and x>='R3M05'
delete from output_stage where linkchartcode IN('R401','R411') and timeframe='YTD' and x>='R3M05'
delete from output_stage where linkchartcode IN('R401','R411') and timeframe='MQT' and x>='R3M11'


delete from output_stage where linkchartcode IN('R401','R411') and timeframe='MTH' and Product not in ('Taxol','Paraplatin')
GO


update [output_stage]
set X=case X 
when 'R3M00' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=1)
when 'R3M01' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=13)
when 'R3M02' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=25)
when 'R3M03' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=37)
when 'R3M04' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=49)
else X
end  where linkchartcode IN('R401','R411') and timeframe = 'MAT'
go
update [output_stage]
set X=case X 
when 'R3M00' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=1)
when 'R3M01' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=13)
when 'R3M02' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=25)
when 'R3M03' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=37)
when 'R3M04' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=49)
else X
end  where linkchartcode IN('R401','R411') and timeframe = 'YTD'
go
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
else X
end where linkchartcode IN('R401','R411') and timeframe='MQT'
go

update [output_stage]
set X=case X 
when 'R3M00' then  'Mth '+(select [MonthEN] from tblMonthList where monseq=1)
when 'R3M01' then  'Mth '+(select [MonthEN] from tblMonthList where monseq=2)
when 'R3M02' then  'Mth '+(select [MonthEN] from tblMonthList where monseq=3)
when 'R3M03' then  'Mth '+(select [MonthEN] from tblMonthList where monseq=4)
when 'R3M04' then  'Mth '+(select [MonthEN] from tblMonthList where monseq=5)
when 'R3M05' then  'Mth '+(select [MonthEN] from tblMonthList where monseq=6)
when 'R3M06' then  'Mth '+(select [MonthEN] from tblMonthList where monseq=7)
when 'R3M07' then  'Mth '+(select [MonthEN] from tblMonthList where monseq=8)
when 'R3M08' then  'Mth '+(select [MonthEN] from tblMonthList where monseq=9)
when 'R3M09' then  'Mth '+(select [MonthEN] from tblMonthList where monseq=10)
when 'R3M10' then  'Mth '+(select [MonthEN] from tblMonthList where monseq=11)
when 'R3M11' then  'Mth '+(select [MonthEN] from tblMonthList where monseq=12)
when 'R3M12' then  'Mth '+(select [MonthEN] from tblMonthList where monseq=13)
else X
end where linkchartcode IN('R401','R411') and timeframe='MTH'
go


-- R402 R412
update output_stage
set linkchartcode='R402' where LinkChartCode in('R401') and Currency in ('UN','PN')
go
update output_stage
set linkchartcode='R412' where LinkChartCode in('R411') and Currency in ('UN','PN') and isshow='Y'
go


update output_stage
set X=X+' ('+case Currency 
when 'US' then 'USD' 
when 'LC' then 'RMB' 
when 'UN' then 'UNIT'
when 'PN' then 'Adjusted patient number'
 else Currency end +')'
where LinkChartCode in('R411') and isshow='N'
go


update output_stage set Currency='US', XIdx=200 
where Currency='UN' and  LinkChartCode in('R411') and isshow='N' and Product<>'Paraplatin'
go 
update output_stage set Currency='US', XIdx=200 
where Currency='PN' and  LinkChartCode in('R411') and isshow='N'  and Product='Paraplatin'
go 


insert into output_stage
select null,GeoID, ProductID, LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo
, 'LC', TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters, Color, R, G, B, IsShow, inty
from output_stage where LinkChartCode in('R411') and isshow='N' and X like '%UNIT%'  and Product<>'Paraplatin'
go
insert into output_stage
select null,GeoID, ProductID, LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo
, 'LC', TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters, Color, R, G, B, IsShow, inty
from output_stage where LinkChartCode in('R411') and isshow='N' and X like '%Adjusted patient number%'  and Product='Paraplatin'


update output_stage
set x=case when x like 'MonthGrowth%' then replace (x,'MonthGrowth',Timeframe+' Growth Rate') 
	 when x like 'CAGR%' then timeframe+' '+x else x end ,
	XIdx=case when x in ('MonthGrowth (RMB)','MonthGrowth (USD)') then 100 else Xidx end
where LINKCHARTCODE LIKE 'R41%' AND ISSHOW='N' 
go




--------------------------------------------
-- R420
--------------------------------------------
delete from output_stage where linkchartcode='R420'

declare @code varchar(10)
set @code = 'R420'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select 'Y','China','China',b.Market,'China',a.TimePeriod, @code as Code, B.MNFL_cod,B.MNFLIdx,MoneyType, a.Series,a.SeriesIdx
from (
	select 'MAT' as TimePeriod, 'MAT00' as Series,5 as SeriesIdx,'Y' as isshow union all
	select 'MAT' as TimePeriod, 'MAT12' as Series,4 as SeriesIdx,'Y' as isshow union all
	select 'MAT' as TimePeriod, 'MAT24' as Series,3 as SeriesIdx,'Y' as isshow union all
	select 'MAT' as TimePeriod, 'MAT36' as Series,2 as SeriesIdx,'Y' as isshow union all
	select 'MAT' as TimePeriod, 'MAT48' as Series,1 as SeriesIdx,'Y' as isshow union all
	select 'YTD' as TimePeriod, 'YTD00' as Series,5 as SeriesIdx,'Y' as isshow union all
	select 'YTD' as TimePeriod, 'YTD12' as Series,4 as SeriesIdx,'Y' as isshow union all
	select 'YTD' as TimePeriod, 'YTD24' as Series,3 as SeriesIdx,'Y' as isshow union all
	select 'YTD' as TimePeriod, 'YTD36' as Series,2 as SeriesIdx,'Y' as isshow union all
	select 'YTD' as TimePeriod, 'YTD48' as Series,1 as SeriesIdx,'Y' as isshow
) a, (
select * from OutputBrandvGene
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
		set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.OutputBrandvGene B
		on A.Product=B.Market and A.Currency=B.MoneyType and A.X='+''''+@Series+''''+' 
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.MNFL_cod'
		print @SQL2
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR

insert into [output_stage](isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency,OtherParameters,XIDX)
select 'N','China','China',b.Market,'China',Period, @code as Code, B.series,B.MNFLidx,MoneyType,Y,1
from OutputBrandvGeneRight B

update [output_stage]
set X=case X 
when 'MAT00' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=1)
when 'MAT12' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=13)
when 'MAT24' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=25)
when 'MAT36' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=37)
when 'MAT48' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=49)
when 'YTD00' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=1)
when 'YTD12' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=13)
when 'YTD24' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=25)
when 'YTD36' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=37)
when 'YTD48' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=49)
else X
end  where LinkChartCode in('R420')
go



update [output_stage]
set X=case X 
when 'YTD00' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=1)
when 'YTD12' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=13)
when 'YTD24' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=25)
when 'YTD36' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=37)
when 'YTD48' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=49)
else X
end  where linkchartcode in('R020', 'R040')
go

update [output_stage]
set series =case series 
when 'YTD00' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=1)
when 'YTD12' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=13)
when 'YTD24' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=25)
when 'YTD36' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=37)
when 'YTD48' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=49)
else series
end  where linkchartcode in('R020', 'R040')
go



--------------------------------------------
-- R430
--------------------------------------------
delete from output_stage where linkchartcode='R430'

declare @code varchar(10)
set @code = 'R430'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MAT', @code as Code, MNFL_cod,MNFLIdx,MoneyType,Productname,Prod, MAT00
from OutputBrandvGenebyClass 

insert into [output_stage](isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency,OtherParameters,XIDX)
select 'N','China','China',b.Market,'China','MAT', @code as Code, B.series,B.MNFLidx,MoneyType,Y,1
from OutputBrandvGeneRight B 
where period = 'MAT' and (series like '%MNC%' or series like '%Local%' or series like '%Facts%')

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','YTD', @code as Code, MNFL_cod,MNFLIdx,MoneyType,Productname,Prod, YTD00
from OutputBrandvGenebyClass 

insert into [output_stage](isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency,OtherParameters,XIDX)
select 'N','China','China',b.Market,'China','YTD', @code as Code, B.series,B.MNFLidx,MoneyType,Y,1
from OutputBrandvGeneRight B 
where period = 'YTD' and (series like '%MNC%' or series like '%Local%' or series like '%Facts%')

update [output_stage]
set X=case X 
when 'MAT00' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=1)
when 'MAT12' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=13)
when 'MAT24' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=25)
when 'MAT36' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=37)
when 'MAT48' then  'MAT '+(select [MonthEN] from tblMonthList where monseq=49)
when 'YTD00' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=1)
when 'YTD12' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=13)
when 'YTD24' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=25)
when 'YTD36' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=37)
when 'YTD48' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=49)
else X
end  where LinkChartCode in('R430')
go
update output_stage
set X=A.X+Char(13)+'('+left(convert(varchar(50),cast(cast(B.Y as float) as money),1),len(convert(varchar(50),cast(cast(B.Y as float) as money),1))-3)+')'--A.x+' ('+cast(round(cast(B.y as float)*1.0/C.divide,1) as varchar(20))+C.dol+')'
FROM output_stage a INNER JOIN (select * from output_stage where seriesidx='10') b
ON A.linkchartcode=b.linkchartcode and a.product=b.product and a.lev=b.lev and a.geo=b.geo 
and isnull(a.category,'')=isnull(b.category,'') and a.currency=b.currency and a.timeframe=b.timeframe
AND A.X=B.X
and isnull(a.isshow,'')=isnull(b.isshow,'')
and a.isshow='Y' and A.linkchartcode in ('R430')
go
DELETE FROM output_stage
WHERE seriesidx='10' and linkchartcode in ('R430')and isshow='Y'
go

delete from output_stage where linkchartcode='R440'

declare @code varchar(10)
set @code = 'R440'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MAT', @code as Code, Productname,Prod,MoneyType, audi_des,RankMAT,MAT00
from OutputKeyMarketPerfByCity 

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MQT', @code as Code, Productname,Prod,MoneyType, audi_des,RankMQT,R3M00
from OutputKeyMarketPerfByCity 

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','YTD', @code as Code, Productname,Prod,MoneyType, audi_des,RankMAT,YTD00
from OutputKeyMarketPerfByCity 

go

delete from output_stage where linkchartcode='R451'

declare @code varchar(10)
set @code = 'R451'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MAT', @code as Code, Productname,Prod,MoneyType, audi_des,RankMAT,MarketShareMAT
from OutputKeyBrandPerfByCity where tier in (1,2)

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MQT', @code as Code, Productname,Prod,MoneyType, audi_des,RankMQT,MarketShareMQT
from OutputKeyBrandPerfByCity where tier in (1,2)

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','YTD', @code as Code, Productname,Prod,MoneyType, audi_des,RankMQT,MarketShareYTD
from OutputKeyBrandPerfByCity where tier in (1,2)
go
delete from output_stage where linkchartcode='R452'

declare @code varchar(10)
set @code = 'R452'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MAT', @code as Code, Productname,Prod,MoneyType, audi_des,RankMAT,MarketShareMAT
from OutputKeyBrandPerfByCity where tier in (3,4)

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MQT', @code as Code, Productname,Prod,MoneyType, audi_des,RankMQT,MarketShareMQT
from OutputKeyBrandPerfByCity where tier in (3,4)

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','YTD', @code as Code, Productname,Prod,MoneyType, audi_des,RankMQT,MarketShareYTD
from OutputKeyBrandPerfByCity where tier in (3,4)
go

delete from output_stage where linkchartcode='R460'

declare @code varchar(10)
set @code = 'R460'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MAT', @code as Code, Productname,Prod,MoneyType, audi_des,RankMAT,CumShareMAT
from OutputCityCumShare

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','YTD', @code as Code, Productname,Prod,MoneyType, audi_des,RankYTD,CumShareYTD
from OutputCityCumShare
go

delete from output_stage where linkchartcode='R471'

declare @code varchar(10)
set @code = 'R471'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MAT', @code as Code,  audi_des,RankMAT,MoneyType,Productname,Prod,EIMAT
from OutputEIByCity where tier in (1,2)

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MQT', @code as Code, audi_des,RankMQT,MoneyType, Productname,Prod,EIMQT
from OutputEIByCity where tier in (1,2)

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','YTD', @code as Code, audi_des,RankMQT,MoneyType, Productname,Prod,EIYTD
from OutputEIByCity where tier in (1,2)
go
delete from output_stage where linkchartcode='R472'

declare @code varchar(10)
set @code = 'R472'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MAT', @code as Code,  audi_des,RankMAT,MoneyType,Productname,Prod,EIMAT
from OutputEIByCity where tier in (3,4)

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MQT', @code as Code,audi_des,RankMQT,MoneyType, Productname,Prod,EIMQT
from OutputEIByCity where tier in (3,4)

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','YTD', @code as Code,audi_des,RankMQT,MoneyType, Productname,Prod,EIYTD
from OutputEIByCity where tier in (3,4)
go
delete from output_stage where linkchartcode='R491'

declare @code varchar(10)
set @code = 'R491'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MAT', @code as Code, Productname,Prod,MoneyType, audi_des,RankMAT,MATShare
from OutputBrandShareByCity where tier in (1,2)

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MQT', @code as Code, Productname,Prod,MoneyType, audi_des,RankMAT,MQTShare
from OutputBrandShareByCity where tier in (1,2)

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','YTD', @code as Code, Productname,Prod,MoneyType, audi_des,RankMAT,YTDShare
from OutputBrandShareByCity where tier in (1,2)
go
delete from output_stage where linkchartcode='R492'

declare @code varchar(10)
set @code = 'R492'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MAT', @code as Code, Productname,Prod,MoneyType, audi_des,RankMAT,MATShare
from OutputBrandShareByCity where tier in (3,4)

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MQT', @code as Code, Productname,Prod,MoneyType, audi_des,RankMAT,MQTShare
from OutputBrandShareByCity where tier in (3,4)

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','YTD', @code as Code, Productname,Prod,MoneyType, audi_des,RankMAT,YTDShare
from OutputBrandShareByCity where tier in (3,4)
go
delete from output_stage where linkchartcode='R501'

declare @code varchar(10)
set @code = 'R501'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MAT', @code as Code, Productname,Prod,MoneyType, segment,SegIdx,MATShare
from OutputBrandShareByCitySeg

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','MQT', @code as Code, Productname,Prod,MoneyType, segment,SegIdx,MQTShare
from OutputBrandShareByCitySeg

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select distinct 'Y','China','China',Market,'China','YTD', @code as Code, Productname,Prod,MoneyType, segment,SegIdx,YTDShare
from OutputBrandShareByCitySeg
go
update output_stage
set linkchartcode='R502' where LinkChartCode in('R501') and Currency in ('UN','PN')
go

delete from output_stage where linkchartcode='R511'

declare @code varchar(10)
set @code = 'R511'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select 'Y','China','China',Market,'China','YTD', @code as Code, Productname,Prod,MoneyType, audi_des,idx,share
from OutputMoleBrandPerf where Type='Chart' and tier in (0,1,2)

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select 'N','China','China',Market,'China','YTD', @code as Code, type,typeIdx,MoneyType, audi_des,idx,share
from OutputMoleBrandPerf where Type<>'Chart' and tier in (0,1,2)

go
delete from output_stage where linkchartcode='R512'

declare @code varchar(10)
set @code = 'R512'
insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select 'Y','China','China',Market,'China','YTD', @code as Code, Productname,Prod,MoneyType, audi_des,idx,share
from OutputMoleBrandPerf where Type='Chart' and tier in (0,3,4)

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select 'N','China','China',Market,'China','YTD', @code as Code, type,typeIdx,MoneyType, audi_des,idx,share
from OutputMoleBrandPerf where Type<>'Chart' and tier in (0,3,4)




--select * from output_stage where linkchartcode='R472'
--select * from TempMoleBrandPerf where mkt='hyp' and moneytype='lc' order by rankmat 
--order by rankmat
update [output_stage]
set LinkSeriesCode=Product+'_'+LinkChartCode+'_'+geo+cast(SeriesIdx as varchar(10))+Isshow 
where LinkChartCode between 'R400' and 'R520'
go
update [output_stage]
set Category=case Currency when 'UN' then 'Units' else 'Value' end
where LinkChartCode between 'R400' and 'R520'
go
update [output_stage]
set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' else Currency end 
where LinkChartCode between 'R400' and 'R520'
go

update [output_stage]
set series=case series when 'Avg.Growth' then 'Avg. Growth' when 'CurrRank' then 'Rank' when 'ChangeRank' then 'Change in Rank' when 'Contribution' then 'Contribution ('+case when timeFrame like '%Current 3 Month%' then 'Cur 3 M' else timeframe end+')' else series end
where linkchartcode in('R090','R100','R110')
go
update [output_stage]
set LinkSeriesCode=Product+LinkChartCode+Series+TimeFrame+cast(SeriesIdx as varchar(10))
where LinkChartCode between 'R010' and 'R120' or LinkChartCode='R320' or linkchartcode between 'R400' and 'R520'
go
update [output_stage]
set Category=case Currency when 'UN' then 'Units' else 'Value' end
where LinkChartCode between 'R010' and 'R120'or LinkChartCode='R320'
go
update [output_stage]
set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' else Currency end 
where LinkChartCode between 'R010' and 'R120' or LinkChartCode='R320'
go

update [output_stage]
set Series=case Series 
when 'MAT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
when 'MAT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)
when 'MAT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)
when 'MAT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)
when 'MAT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)
when 'MAT00Growth' then  TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)+' Growth'
when 'YTD00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
when 'YTD12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)
when 'YTD24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)
when 'YTD36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)
when 'YTD48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)
when 'YTD00Growth' then  TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)+' Growth'
else Series
end where  LinkChartCode between 'R010' and 'R120'
go

--R090,R100,R110
update [output_stage]
set Series=case Series when 'Qtr00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
else Series
end where  LinkChartCode between 'R010' and 'R120'
go

update [output_stage]
set Series=case Series when 'YTD00' then TimeFrame + ' '+(select [Month]+''''+right(year,2) from tblDateHKAPI)
when 'YTD12' then TimeFrame +  ' '+(select [Month]+''''+right(year-1,2) from tblDateHKAPI)
when 'YTD00Growth' then  TimeFrame + ' '+(select [Month]+''''+right(year,2) from tblDateHKAPI)+' Growth'
else Series
end where  LinkChartCode ='R320'
go
--update [output_stage]
--set Series='Q3 2011' where series='Qtr00'
--go
update [output_stage]
set X=case X when 'MAT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
when 'MAT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)
when 'MAT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)
when 'MAT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)
when 'MAT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)
when 'MAT00Growth' then  TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)+' Growth'
when 'YTD12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)
when 'YTD24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)
when 'YTD36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)
when 'YTD48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)
when 'YTD00Growth' then  TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)+' Growth'
else X
end where  LinkChartCode between 'R010' and 'R120'
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
when 'YTD01' then 'YTD '+(select [MonthEN] from tblMonthList where monseq=4)
when 'YTD02' then 'YTD '+(select [MonthEN] from tblMonthList where monseq=7)
when 'YTD03' then 'YTD '+(select [MonthEN] from tblMonthList where monseq=10)
when 'YTD04' then 'YTD '+(select [MonthEN] from tblMonthList where monseq=13)
when 'YTD05' then 'YTD '+(select [MonthEN] from tblMonthList where monseq=16)
else X
end  where  LinkChartCode like 'R05%' or LinkChartCode like 'R06%' or LinkChartCode like 'R07%' or LinkChartCode like 'R08%'
go


-----------------------------------------------------------------
--	R777: Baraclude Modification Slide 7     2013_08_26
-----------------------------------------------------------------
delete from output_stage where linkchartcode='R777'
GO

declare @code varchar(10)
set @code = 'R777'

--正常MQT
insert into [output_stage] (Product,isshow,geo,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select b.market,'Y','China','Nation',b.Period,@code, b.Prod_des ,
case b.Prod_des when 'Entecavir Size' then 1	
			 when 'Baraclude MS(%)' then 2
			 when 'Run zhong MS(%)' then 3 end ,MoneyType, a.Series,a.SeriesIdx	
																			 			
from 
(
	select 'MTH00' as Series,	36 as SeriesIdx union all
	select 'MTH01' as Series,	35 as SeriesIdx union all
	select 'MTH02' as Series,   34 as SeriesIdx union all
	select 'MTH03' as Series,	33 as SeriesIdx union all
	select 'MTH04' as Series,	32 as SeriesIdx union all
	select 'MTH05' as Series,	31 as SeriesIdx union all
	select 'MTH06' as Series,	30 as SeriesIdx union all
	select 'MTH07' as Series,	29 as SeriesIdx union all
	select 'MTH08' as Series,	28 as SeriesIdx union all
	select 'MTH09' as Series,	27 as SeriesIdx union all
	select 'MTH10' as Series,	26 as SeriesIdx union all
	select 'MTH11' as Series,	25 as SeriesIdx union all
	select 'MTH12' as Series,	24 as SeriesIdx union all
	select 'MTH13' as Series,	23 as SeriesIdx union all
	select 'MTH14' as Series,	22 as SeriesIdx union all
	select 'MTH15' as Series,	21 as SeriesIdx union all
	select 'MTH16' as Series,	20 as SeriesIdx union all
	select 'MTH17' as Series,	19 as SeriesIdx union all
	select 'MTH18' as Series,	18 as SeriesIdx union all
	select 'MTH19' as Series,	17 as SeriesIdx union all
	select 'MTH20' as Series,	16 as SeriesIdx union all
	select 'MTH21' as Series,	15 as SeriesIdx union all
	select 'MTH22' as Series,   14 as SeriesIdx union all
	select 'MTH23' as Series,   13 as SeriesIdx union all
	select 'MTH24' as Series,	12 as SeriesIdx union all
	select 'MTH25' as Series,	11 as SeriesIdx union all
	select 'MTH26' as Series,	10 as SeriesIdx union all
	select 'MTH27' as Series,	9 as SeriesIdx union all
	select 'MTH28' as Series,	8 as SeriesIdx union all
	select 'MTH29' as Series,	7 as SeriesIdx union all
	select 'MTH30' as Series,	6 as SeriesIdx union all
	select 'MTH31' as Series,	5 as SeriesIdx union all
	select 'MTH32' as Series,	4 as SeriesIdx union all
	select 'MTH33' as Series,	3 as SeriesIdx union all
	select 'MTH34' as Series,	2 as SeriesIdx union all
	select 'MTH35' as Series,	1 as SeriesIdx 
)a,
(
	select distinct Prod_des,Prod_cod,Period,MoneyType,Market
	from MID_OutputProdSalesPerformanceInChina_R777 where Type in ('Molecule','ARV Market Share')
) b


insert into [output_stage] (Product,isshow,geo,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select b.market,'L','China','Nation',b.Period,@code, b.Prod_des ,
case b.Prod_des when 'BR Of Total ETV(%)' then 6	
			 when 'Baraclude MS(%)' then 4
			 when 'Run zhong MS(%)' then 5 end ,MoneyType, a.Series,a.SeriesIdx	
																			 			
from 
(
	select 'MTH00' as Series,	36 as SeriesIdx union all
	select 'MTH01' as Series,	35 as SeriesIdx union all
	select 'MTH02' as Series,   34 as SeriesIdx union all
	select 'MTH03' as Series,	33 as SeriesIdx union all
	select 'MTH04' as Series,	32 as SeriesIdx union all
	select 'MTH05' as Series,	31 as SeriesIdx union all
	select 'MTH06' as Series,	30 as SeriesIdx union all
	select 'MTH07' as Series,	29 as SeriesIdx union all
	select 'MTH08' as Series,	28 as SeriesIdx union all
	select 'MTH09' as Series,	27 as SeriesIdx union all
	select 'MTH10' as Series,	26 as SeriesIdx union all
	select 'MTH11' as Series,	25 as SeriesIdx union all
	select 'MTH12' as Series,	24 as SeriesIdx union all
	select 'MTH13' as Series,	23 as SeriesIdx union all
	select 'MTH14' as Series,	22 as SeriesIdx union all
	select 'MTH15' as Series,	21 as SeriesIdx union all
	select 'MTH16' as Series,	20 as SeriesIdx union all
	select 'MTH17' as Series,	19 as SeriesIdx union all
	select 'MTH18' as Series,	18 as SeriesIdx union all
	select 'MTH19' as Series,	17 as SeriesIdx union all
	select 'MTH20' as Series,	16 as SeriesIdx union all
	select 'MTH21' as Series,	15 as SeriesIdx union all
	select 'MTH22' as Series,   14 as SeriesIdx union all
	select 'MTH23' as Series,   13 as SeriesIdx union all
	select 'MTH24' as Series,	12 as SeriesIdx union all
	select 'MTH25' as Series,	11 as SeriesIdx union all
	select 'MTH26' as Series,	10 as SeriesIdx union all
	select 'MTH27' as Series,	9 as SeriesIdx union all
	select 'MTH28' as Series,	8 as SeriesIdx union all
	select 'MTH29' as Series,	7 as SeriesIdx union all
	select 'MTH30' as Series,	6 as SeriesIdx union all
	select 'MTH31' as Series,	5 as SeriesIdx union all
	select 'MTH32' as Series,	4 as SeriesIdx union all
	select 'MTH33' as Series,	3 as SeriesIdx union all
	select 'MTH34' as Series,	2 as SeriesIdx union all
	select 'MTH35' as Series,	1 as SeriesIdx 
)a,
(
	select distinct Prod_des,Prod_cod,Period,MoneyType,Market
	from MID_OutputProdSalesPerformanceInChina_R777 where Type in ( 'Baraclude Share Of ETV','ARV Market Share')
) b


--select Series, X,XIdx,Y from output_stage where linkchartcode = 'R777' ORDER BY Series, XIdx

DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select distinct X  from dbo.[output_stage] where LinkChartCode=@code and IsShow = 'Y'
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
		set Y=B.'+@Series+ ' from [output_stage] A inner join 
		(select * from dbo.MID_OutputProdSalesPerformanceInChina_R777 where type in (''Molecule'',''ARV Market Share'')
		 ) B
		on A.TimeFrame=B.Period and A.Currency=B.MoneyType  and A.Product=B.Market and A.X='+''''+@Series+''''+'
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Prod_des and A.Isshow = ''Y'''
		exec( @SQL2)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR



DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select distinct X  from dbo.[output_stage] where LinkChartCode=@code and IsShow = 'L'
DECLARE @Series2 varchar(100)
DECLARE @SQL3 VARCHAR(8000)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @Series2
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @Series2

		set @SQL3='
		update [output_stage]
		set Y=B.'+@Series2+ ' from [output_stage] A inner join 
		(select * from dbo.MID_OutputProdSalesPerformanceInChina_R777 where type in (''Baraclude Share Of ETV'',''ARV Market Share'')
		 ) B
		on A.TimeFrame=B.Period and A.Currency=B.MoneyType  and A.Product=B.Market and A.X='+''''+@Series2+''''+'
		and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Prod_des and A.Isshow = ''L'''
		exec( @SQL3)

	END
	FETCH NEXT FROM TMP_CURSOR INTO @Series2
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go

update [output_stage]
set LinkSeriesCode=Product+'_'+LinkChartCode+Series+cast(SeriesIdx as varchar(10)) where LinkChartCode='R777' and IsShow = 'Y'

update [output_stage]
set LinkSeriesCode=Product+'_'+LinkChartCode+'_'+geo+isshow+cast(SeriesIdx as varchar(10)) where LinkChartCode = 'R777' and IsShow = 'L'
go
update [output_stage]
set Category=case Currency when 'UN' then 'Units' when 'PN' then 'Adjusted patient number' else 'Value' end
where LinkChartCode='R777'
go
update [output_stage]
set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' when 'PN' then 'UNIT'  else Currency end 
where LinkChartCode='R777'
go
go
declare @i int,@sql varchar(8000)
set @i=0
set @sql='update [output_stage]
set X=case X '
while (@i<=35)
begin
set @sql=@sql+'
when ''MTH'+right('00'+cast(@i as varchar(2)),2)+''' then TimeFrame + '' ''+(select [MonthEN] from tblMonthList where monseq='+cast(@i+1 as varchar(2))+')'
set @i=@i+1
end
set @sql=@sql+'else X
end  where LinkChartCode=''R777'' and IsShow = ''Y'''
exec(@sql)
GO

-- -------------------------------------
-- --	CID-CV-Modification: Slide 6
-- -------------------------------------
-- DECLARE @CODE AS VARCHAR(30)
-- SET @CODE = 'R610'
-- DELETE FROM output_stage WHERE LinkChartCode = @CODE

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- SELECT 'D' AS IsShow,'China' AS ParentGeo,'China' AS Geo,Market,'China' AS lev,'MTH' AS TimeFrame,@CODE AS LinkChartCode,
-- CASE WHEN Chart ='Monopril Market Value GR' or Chart ='Coniel Market Value GR' THEN 'Value Market GR'

-- 	 WHEN Chart ='Monopril Product Value GR' THEN 'Value Monopril GR'
-- 	 WHEN Chart ='Coniel Product Value GR' THEN 'Value Coniel GR'
	 
-- 	 WHEN Chart ='Monopril Product Value Share' THEN 'Monopril Value Share'
-- 	 WHEN Chart ='Coniel Product Value Share' THEN 'Coniel Value Share'
	 
-- 	 WHEN Chart ='Monopril Product Value Share GR' THEN 'Monopril Share'
-- 	 WHEN Chart ='Coniel Product Value Share GR' THEN 'COniel Share' END AS Series,
	 
-- CASE WHEN Chart like '% Market Value GR' THEN 1
-- 	 WHEN Chart like '% Product Value GR' THEN 2
-- 	 WHEN Chart like '% Product Value Share' THEN 3
-- 	 WHEN Chart like '% Product Value Share GR' THEN 4 END AS SeriesIdx,
-- CASE WHEN Moneytype='US' THEN 'USD' ELSE MoneyType END AS Currency,
-- Audi_des as X,
-- CASE WHEN (mkt='HYP' and Audi_des = 'Beijing') or (mkt='CCB' and Audi_des='Beijing') THEN 1
-- 	 WHEN mkt='HYP' and Audi_des = 'Shanghai'  or (mkt='CCB' and Audi_des='Shanghai')THEN 2
-- 	 WHEN mkt='HYP' and Audi_des = 'FuXiaQuan' or (mkt='CCB' and Audi_des='Guangzhou')THEN 3
-- 	 WHEN mkt='HYP' and Audi_des = 'Guangzhou' or (mkt='CCB' and Audi_des='FuXiaQuan')THEN 4
-- 	 WHEN mkt='HYP' and Audi_des = 'Wuhan' or (mkt='CCB' and Audi_des='Hangzhou')THEN 5
-- 	 WHEN mkt='HYP' and Audi_des = 'Nanjing' or (mkt='CCB' and Audi_des='Shenyang')THEN 6 
-- 	 WHEN mkt='HYP' and Audi_des = 'Tianjin' or (mkt='CCB' and Audi_des='Jinan')THEN 7
-- 	 WHEN mkt='HYP' and Audi_des = 'Hangzhou' or (mkt='CCB' and Audi_des='Wulumuqi')THEN 8
-- 	 WHEN mkt='HYP' and Audi_des = 'Pearl River delta' or (mkt='CCB' and Audi_des='Qingdao')THEN 9
-- 	 WHEN mkt='HYP' and Audi_des = 'Shenyang' or (mkt='CCB' and Audi_des='Harbin')THEN 10
-- 	 WHEN mkt='HYP' and Audi_des = 'Chengdu' THEN 11
-- 	 WHEN mkt='HYP' and Audi_des = 'Wulumuqi' THEN 12
-- 	 WHEN Audi_des='Nation' THEN 13 END AS XIdx,
-- MTH00 AS Y
-- FROM OutputPerformanceByBrand_CV_Modi_Slide6 
-- WHERE CHART <> 'Volume Trend' AND (
-- 			(Audi_des in ('Beijing','Shanghai','FuXiaQuan','Guangzhou','Wuhan','Nanjing','Tianjin',
-- 			'Hangzhou','Pearl River delta','Shenyang','Chengdu','Wulumuqi','Nation') and mkt='HYP') or 
-- 			(Audi_des in ('Beijing','Shanghai','FuXiaQuan','Guangzhou','Hangzhou','Shenyang','Jinan',
-- 			'Wulumuqi','Qingdao','Harbin','Nation') and mkt='CCB')
-- )	

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- SELECT 'D' AS IsShow,'China' AS ParentGeo,'China' AS Geo,Market,'China' AS lev,'YTD' AS TimeFrame,@CODE AS LinkChartCode,
-- CASE WHEN Chart ='Monopril Market Value GR' or Chart ='Coniel Market Value GR' THEN 'Value Market GR'

-- 	 WHEN Chart ='Monopril Product Value GR' THEN 'Value Monopril GR'
-- 	 WHEN Chart ='Coniel Product Value GR' THEN 'Value Coniel GR'
	 
-- 	 WHEN Chart ='Monopril Product Value Share' THEN 'Monopril Value Share'
-- 	 WHEN Chart ='Coniel Product Value Share' THEN 'Coniel Value Share'
	 
-- 	 WHEN Chart ='Monopril Product Value Share GR' THEN 'Monopril Share'
-- 	 WHEN Chart ='Coniel Product Value Share GR' THEN 'COniel Share' END AS Series,
-- CASE WHEN Chart like '% Market Value GR' THEN 1
-- 	 WHEN Chart like '% Product Value GR' THEN 2
-- 	 WHEN Chart like '% Product Value Share' THEN 3
-- 	 WHEN Chart like '% Product Value Share GR' THEN 4 END AS SeriesIdx,
-- CASE WHEN Moneytype='US' THEN 'USD' ELSE MoneyType END AS Currency,
-- Audi_des as X,
-- CASE WHEN (mkt='HYP' and Audi_des = 'Beijing') or (mkt='CCB' and Audi_des='Beijing') THEN 1
-- 	 WHEN mkt='HYP' and Audi_des = 'Shanghai'  or (mkt='CCB' and Audi_des='Shanghai')THEN 2
-- 	 WHEN mkt='HYP' and Audi_des = 'FuXiaQuan' or (mkt='CCB' and Audi_des='Guangzhou')THEN 3
-- 	 WHEN mkt='HYP' and Audi_des = 'Guangzhou' or (mkt='CCB' and Audi_des='FuXiaQuan')THEN 4
-- 	 WHEN mkt='HYP' and Audi_des = 'Wuhan' or (mkt='CCB' and Audi_des='Hangzhou')THEN 5
-- 	 WHEN mkt='HYP' and Audi_des = 'Nanjing' or (mkt='CCB' and Audi_des='Shenyang')THEN 6 
-- 	 WHEN mkt='HYP' and Audi_des = 'Tianjin' or (mkt='CCB' and Audi_des='Jinan')THEN 7
-- 	 WHEN mkt='HYP' and Audi_des = 'Hangzhou' or (mkt='CCB' and Audi_des='Wulumuqi')THEN 8
-- 	 WHEN mkt='HYP' and Audi_des = 'Pearl River delta' or (mkt='CCB' and Audi_des='Qingdao')THEN 9
-- 	 WHEN mkt='HYP' and Audi_des = 'Shenyang' or (mkt='CCB' and Audi_des='Harbin')THEN 10
-- 	 WHEN mkt='HYP' and Audi_des = 'Chengdu' THEN 11
-- 	 WHEN mkt='HYP' and Audi_des = 'Wulumuqi' THEN 12
-- 	 WHEN Audi_des='Nation' THEN 13 END AS XIdx,
-- YTD00 AS Y
-- FROM OutputPerformanceByBrand_CV_Modi_Slide6 
-- WHERE CHART <> 'Volume Trend' AND (
-- 			(Audi_des in ('Beijing','Shanghai','FuXiaQuan','Guangzhou','Wuhan','Nanjing','Tianjin',
-- 			'Hangzhou','Pearl River delta','Shenyang','Chengdu','Wulumuqi','Nation') and mkt='HYP') or 
-- 			(Audi_des in ('Beijing','Shanghai','FuXiaQuan','Guangzhou','Hangzhou','Shenyang','Jinan',
-- 			'Wulumuqi','Qingdao','Harbin','Nation') and mkt='CCB')
-- )	
-- --更新表示颜色的列
-- update a
-- set R=case when a.Y<b.Y then 255 end,
-- 	G=case when a.Y<b.Y then 0 end,
-- 	B=case when a.Y<b.Y then 0 end
-- from output_stage a join (
-- 	select * from output_stage
-- 	where LinkChartCode='R610' and Series='Value Market GR'
-- ) b on a.LinkChartCode=b.LinkChartCode and a.product=b.product and a.Currency=b.Currency and a.TimeFrame=b.TimeFrame and a.x=b.x and a.xidx=b.xidx
-- 	 and a.isshow=b.isshow
-- where a.LinkChartCode='R610' and a.Series in ('Value Monopril GR','Value Coniel GR')

-- update output_stage
-- set R=255,G=0,B=0
-- where LinkChartCode='R610' and Series in ('Monopril Share','Coniel Share') and Y<0

-- UPDATE a
-- SET a.Series = a.Series+'('+a.TimeFrame+(select MonthEN from tblMonthList where monseq=1)+'vs. '+a.TimeFrame+(select MonthEN from tblMonthList where monseq=13)+')'+char(10)+'Average '+convert(varchar(5),convert(int,b.Y*100))+'%'
-- from output_stage a join (
-- 		select * from output_stage 
-- 		where Series in( 'Value Market GR','Value Monopril GR','Value Coniel GR') AND LinkchartCode='R610' and x='Nation' 
-- 	)b
-- on a.LinkChartCode=b.LinkChartCode and a.Series=b.Series and a.product=b.product and a.currency=b.currency and a.TimeFrame=b.TimeFrame
-- WHERE a.Series in( 'Value Market GR','Value Monopril GR','Value Coniel GR') AND a.LinkchartCode=@CODE and a.x<>'Nation'

-- UPDATE a
-- SET a.Series = a.Series+'('+a.TimeFrame+(select MonthEN from tblMonthList where monseq=1)+')'+char(10)+'Average '+convert(varchar(5),convert(int,b.Y*100))+'%'
-- from output_stage a join (
-- 		select * from output_stage 
-- 		where Series in( 'Monopril Value Share','Coniel Value Share') AND LinkchartCode='R610' and x='Nation' 
-- 	)b
-- on a.LinkChartCode=b.LinkChartCode and a.Series=b.Series and a.product=b.product and a.currency=b.currency and a.TimeFrame=b.TimeFrame
-- WHERE a.Series in( 'Monopril Value Share','Coniel Value Share') AND a.LinkchartCode=@CODE and a.x<>'Nation'

-- UPDATE a
-- SET a.Series = a.Series+'('+a.TimeFrame+(select MonthEN from tblMonthList where monseq=1)+'vs. '+a.TimeFrame+(select MonthEN from tblMonthList where monseq=13)+')'
-- from output_stage a join (
-- 		select * from output_stage 
-- 		where Series in( 'Monopril Share','Coniel Share') AND LinkchartCode='R610' and x='Nation' 
-- 	)b
-- on a.LinkChartCode=b.LinkChartCode and a.Series=b.Series and a.product=b.product and a.currency=b.currency and a.TimeFrame=b.TimeFrame
-- WHERE a.Series in( 'Monopril Share','Coniel Share') AND a.LinkchartCode=@CODE and a.x<>'Nation'


-- delete from output_stage where linkchartcode='R610' and x='Nation'

-- UPDATE output_stage
-- SET LinkSeriesCode=Product+'_'+LinkChartCode+Series+TimeFrame+cast(SeriesIdx as varchar(10))
-- WHERE LinkChartCode=@CODE

-- GO

-- -------------------------------------
-- --	CID-CV-Modification: Slide 7
-- -------------------------------------

-- DECLARE @CODE AS VARCHAR(30)
-- SET @CODE = 'R620'
-- DELETE FROM output_stage WHERE LinkChartCode = @CODE

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- select 'D' AS IsShow, 'China' as ParentGeo,'China' as Geo, a.Market AS Product,'China' as lev,'YTD' as TimeFrame,@CODE as LinkChartCode, 
-- case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end AS Series, b.row_Num as SeriesIdx,
-- case when a.MoneyType='LC' then 'RMB' else a.MoneyType end as Currency,
-- case when chart = 'City Market&Product Share' and prod = '000' then 'ACEI Con%'
-- 	 when chart = 'City Market&Product Share' and prod = '100' then 'Monopril MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '100' then 'Monopril GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '200' then 'Acertil MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '200' then 'Acertil GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '700' then 'Lotensin MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '700' then 'Lotensin GR%'
	 
-- 	 when chart = 'ACEI Market Size'          and prod = '910' then 'ACEI MS Size'
-- 	 when chart = 'ACEI Market GR'            and prod = '910' then 'ACEI GR%'
-- end as X,	 
-- case when chart = 'City Market&Product Share' and prod = '000' then 2
-- 	 when chart = 'City Market&Product Share' and prod = '100' then 3
-- 	 when chart = 'City Product Market GR'    and prod = '100' then 4
	 
-- 	 when chart = 'City Market&Product Share' and prod = '200' then 5
-- 	 when chart = 'City Product Market GR'    and prod = '200' then 6
	 
-- 	 when chart = 'City Market&Product Share' and prod = '700' then 7
-- 	 when chart = 'City Product Market GR'    and prod = '700' then 8
	 
-- 	 when chart = 'ACEI Market Size'          and prod = '910' then 9
-- 	 when chart = 'ACEI Market GR'            and prod = '910' then 10
-- end as XIdx,
-- case when chart = 'ACEI Market Size' then  1.0*YTD00/1000 else YTD00 end as Y
-- from OutputPerformanceByBrand_CV_Modi_Slide7 a join OutputPerformanceByBrand_CV_Modi_Slide7_Rank b on 
-- 		case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end  =b.Audi_des
-- where  a.market = 'monopril' and ( a.chart='ACEI Market GR' or a.chart='ACEI Market Size' or a.chart='City Market&Product Share'or
-- 			(a.chart='City Product Market GR' and prod<>'000') ) and prod in ('000','100','200','700','910') 
-- 			and b.row_Num between 1 and 25
-- order by  SeriesIdx,XIdx

-- ------------------------------------------------
-- --				Coniel
-- ------------------------------------------------

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- select 'D' AS IsShow, 'China' as ParentGeo,'China' as Geo, a.Market AS Product,'China' as lev,'YTD' as TimeFrame,@Code as LinkChartCode, 
-- case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end AS Series, b.row_Num as SeriesIdx,
-- case when a.MoneyType='LC' then 'RMB' else a.MoneyType end as Currency,
-- case when chart = 'City Market&Product Share' and prod = '000' then 'CCB Con%'
-- 	 when chart = 'City Market&Product Share' and prod = '100' then 'Coniel MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '100' then 'Coniel GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '200' then 'Yuan Zhi MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '200' then 'Yuan Zhi GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '300' then 'Lacipil MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '300' then 'Lacipil GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '400' then 'Zanidip MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '400' then 'Zanidip GR%'
-- 	 when chart = 'City Market&Product Share' and prod = '500' then 'Norvasc MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '500' then 'Norvasc GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '600' then 'Adalat MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '600' then 'Adalat GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '700' then 'Plendil MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '700' then 'Plendil GR%'

	 
-- 	 when chart = 'ccb Market Size'          and prod = '000' then 'CCB MS Size'
-- 	 when chart = 'ccb Market GR'            and prod = '000' then 'CCB GR%'
-- end as X,	 
-- case when chart = 'City Market&Product Share' and prod = '000' then 2
-- 	 when chart = 'City Market&Product Share' and prod = '100' then 3
-- 	 when chart = 'City Product Market GR'    and prod = '100' then 4
	 
-- 	 when chart = 'City Market&Product Share' and prod = '200' then 5
-- 	 when chart = 'City Product Market GR'    and prod = '200' then 6
	 
-- 	 when chart = 'City Market&Product Share' and prod = '300' then 7
-- 	 when chart = 'City Product Market GR'    and prod = '300' then 8
	 
-- 	 when chart = 'City Market&Product Share' and prod = '400' then 9
-- 	 when chart = 'City Product Market GR'    and prod = '400' then 10
-- 	 when chart = 'City Market&Product Share' and prod = '500' then 11
-- 	 when chart = 'City Product Market GR'    and prod = '500' then 12
	 
-- 	 when chart = 'City Market&Product Share' and prod = '600' then 13
-- 	 when chart = 'City Product Market GR'    and prod = '600' then 14
	 
-- 	 when chart = 'City Market&Product Share' and prod = '700' then 15
-- 	 when chart = 'City Product Market GR'    and prod = '700' then 16

	 
-- 	 when chart = 'ccb Market Size'          and prod = '000' then 17
-- 	 when chart = 'ccb Market GR'            and prod = '000' then 18
-- end as XIdx,
-- case when chart = 'ccb Market Size' then  1.0*YTD00/1000 else YTD00 end as Y
-- from OutputPerformanceByBrand_CV_Modi_Slide7 a join OutputPerformanceByBrand_CV_Modi_Slide7_Rank_Coniel b on 
-- 		case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end  =b.Audi_des
-- where  a.market = 'coniel' and ( a.chart='CCB Market GR' or a.chart='CCB Market Size' or a.chart='City Market&Product Share'or
-- 			(a.chart='City Product Market GR' and prod<>'000') ) and prod in ('000','100','200','300') 
-- 			and b.row_Num between 1 and 25
-- order by  SeriesIdx,XIdx


-- ------------------------------------------------
-- --				Eliquis
-- ------------------------------------------------

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- select 'D' AS IsShow, 'China' as ParentGeo,'China' as Geo, a.Market AS Product,'China' as lev,'YTD' as TimeFrame,@Code as LinkChartCode, 
-- case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end AS Series, b.row_Num as SeriesIdx,
-- case when a.MoneyType='LC' then 'RMB' else a.MoneyType end as Currency,
-- case when chart = 'City Market&Product Share' and prod = '000' then 'VTEP Con%'
-- 	 when chart = 'City Market&Product Share' and prod = '100' then 'Eliquis MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '100' then 'Eliquis GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '200' then 'Clexane MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '200' then 'Clexane GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '300' then 'Xarelto MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '300' then 'Xarelto GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '400' then 'Fraxiparine MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '400' then 'Fraxiparine GR%'
-- 	 when chart = 'City Market&Product Share' and prod = '500' then 'Arixtra MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '500' then 'Arixtra GR%'	 
-- 	 when chart = 'VTEP Market Size'          and prod = '000' then 'VTEP MS Size'
-- 	 when chart = 'VTEP Market GR'            and prod = '000' then 'VTEP GR%'
-- end as X,	 

-- case when chart = 'City Market&Product Share' and prod = '000' then 2
-- 	 when chart = 'City Market&Product Share' and prod = '100' then 3
-- 	 when chart = 'City Product Market GR'    and prod = '100' then 4	 
-- 	 when chart = 'City Market&Product Share' and prod = '200' then 5
-- 	 when chart = 'City Product Market GR'    and prod = '200' then 6	 
-- 	 when chart = 'City Market&Product Share' and prod = '300' then 7
-- 	 when chart = 'City Product Market GR'    and prod = '300' then 8	 
-- 	 when chart = 'City Market&Product Share' and prod = '400' then 9
-- 	 when chart = 'City Product Market GR'    and prod = '400' then 10
-- 	 when chart = 'City Market&Product Share' and prod = '500' then 11
-- 	 when chart = 'City Product Market GR'    and prod = '500' then 12		 
-- 	 when chart = 'VTEP Market Size'          and prod = '000' then 17
-- 	 when chart = 'VTEP Market GR'            and prod = '000' then 18
-- end as XIdx,
-- case when chart = 'VTEP Market Size' then  1.0*YTD00/1000 else YTD00 end as Y
-- from OutputPerformanceByBrand_CV_Modi_Slide7 a join OutputPerformanceByBrand_CV_Modi_Slide7_Rank_Eliquis b on 
-- 		case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end  =b.Audi_des
-- where  a.market = 'Eliquis VTEP' and ( a.chart='VTEP Market GR' or a.chart='VTEP Market Size' or a.chart='City Market&Product Share'or
-- 			(a.chart='City Product Market GR' and prod<>'000') ) and prod in ('000','100','200','300','400','500') 
-- 			and b.row_Num between 1 and 25
-- order by  SeriesIdx,XIdx



-- UPDATE output_stage
-- SET LinkSeriesCode=Product+'_'+LinkChartCode+Series+TimeFrame+cast(SeriesIdx as varchar(10))
-- WHERE LinkChartCode=@CODE			

GO



DECLARE @CODE AS VARCHAR(30)
SET @CODE = 'R630'
DELETE FROM output_stage WHERE LinkChartCode = @CODE

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select 'D' AS IsShow, 'China' as ParentGeo,'China' as Geo, a.Market AS Product,'China' as lev,'YTD' as TimeFrame,@CODE as LinkChartCode, 
case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end AS Series, b.row_Num as SeriesIdx,
case when a.MoneyType='LC' then 'RMB' else a.MoneyType end as Currency,
case when chart = 'City Market&Product Share' and prod = '000' then 'ACEI Con%'
	 when chart = 'City Market&Product Share' and prod = '100' then 'Monopril MS%'
	 when chart = 'City Product Market GR'    and prod = '100' then 'Monopril GR%'
	 
	 when chart = 'City Market&Product Share' and prod = '200' then 'Acertil MS%'
	 when chart = 'City Product Market GR'    and prod = '200' then 'Acertil GR%'
	 
	 when chart = 'City Market&Product Share' and prod = '700' then 'Lotensin MS%'
	 when chart = 'City Product Market GR'    and prod = '700' then 'Lotensin GR%'
	 
	 when chart = 'ACEI Market Size'          and prod = '910' then 'ACEI MS Size'
	 when chart = 'ACEI Market GR'            and prod = '910' then 'ACEI GR%'
end as X,	 
case when chart = 'City Market&Product Share' and prod = '000' then 2
	 when chart = 'City Market&Product Share' and prod = '100' then 3
	 when chart = 'City Product Market GR'    and prod = '100' then 4
	 
	 when chart = 'City Market&Product Share' and prod = '200' then 5
	 when chart = 'City Product Market GR'    and prod = '200' then 6
	 
	 when chart = 'City Market&Product Share' and prod = '700' then 7
	 when chart = 'City Product Market GR'    and prod = '700' then 8
	 
	 when chart = 'ACEI Market Size'          and prod = '910' then 9
	 when chart = 'ACEI Market GR'            and prod = '910' then 10
end as XIdx,
case when chart = 'ACEI Market Size' then  YTD00/1000 else YTD00 end as Y
from OutputPerformanceByBrand_CV_Modi_Slide7 a join OutputPerformanceByBrand_CV_Modi_Slide7_Rank b on 
		case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end  =b.Audi_des
where  a.market = 'monopril' and ( a.chart='ACEI Market GR' or a.chart='ACEI Market Size' or a.chart='City Market&Product Share'or
			(a.chart='City Product Market GR' and prod<>'000') ) and prod in ('000','100','200','700','910') 
			and b.row_Num between 26 and 50
order by  SeriesIdx,XIdx

--------------------------------------------------
---					Coniel
--------------------------------------------------

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select 'D' AS IsShow, 'China' as ParentGeo,'China' as Geo, a.Market AS Product,'China' as lev,'YTD' as TimeFrame,@Code as LinkChartCode, 
case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end AS Series, b.row_Num as SeriesIdx,
case when a.MoneyType='LC' then 'RMB' else a.MoneyType end as Currency,
case when chart = 'City Market&Product Share' and prod = '000' then 'CCB Con%'
	 when chart = 'City Market&Product Share' and prod = '100' then 'Coniel MS%'
	 when chart = 'City Product Market GR'    and prod = '100' then 'Coniel GR%'
	 
	 when chart = 'City Market&Product Share' and prod = '200' then 'Yuan Zhi MS%'
	 when chart = 'City Product Market GR'    and prod = '200' then 'Yuan Zhi GR%'
	 
	 when chart = 'City Market&Product Share' and prod = '300' then 'Lacipil MS%'
	 when chart = 'City Product Market GR'    and prod = '300' then 'Lacipil GR%'
	 
	 when chart = 'City Market&Product Share' and prod = '400' then 'Zanidip MS%'
	 when chart = 'City Product Market GR'    and prod = '400' then 'Zanidip GR%'
	 when chart = 'City Market&Product Share' and prod = '500' then 'Norvasc MS%'
	 when chart = 'City Product Market GR'    and prod = '500' then 'Norvasc GR%'
	 
	 when chart = 'City Market&Product Share' and prod = '600' then 'Adalat MS%'
	 when chart = 'City Product Market GR'    and prod = '600' then 'Adalat GR%'
	 
	 when chart = 'City Market&Product Share' and prod = '700' then 'Plendil MS%'
	 when chart = 'City Product Market GR'    and prod = '700' then 'Plendil GR%'

	 
	 when chart = 'ccb Market Size'          and prod = '000' then 'CCB MS Size'
	 when chart = 'ccb Market GR'            and prod = '000' then 'CCB GR%'
end as X,	 
case when chart = 'City Market&Product Share' and prod = '000' then 2
	 when chart = 'City Market&Product Share' and prod = '100' then 3
	 when chart = 'City Product Market GR'    and prod = '100' then 4
	 
	 when chart = 'City Market&Product Share' and prod = '200' then 5
	 when chart = 'City Product Market GR'    and prod = '200' then 6
	 
	 when chart = 'City Market&Product Share' and prod = '300' then 7
	 when chart = 'City Product Market GR'    and prod = '300' then 8
	 
	 when chart = 'City Market&Product Share' and prod = '400' then 9
	 when chart = 'City Product Market GR'    and prod = '400' then 10
	 when chart = 'City Market&Product Share' and prod = '500' then 11
	 when chart = 'City Product Market GR'    and prod = '500' then 12
	 
	 when chart = 'City Market&Product Share' and prod = '600' then 13
	 when chart = 'City Product Market GR'    and prod = '600' then 14
	 
	 when chart = 'City Market&Product Share' and prod = '700' then 15
	 when chart = 'City Product Market GR'    and prod = '700' then 16

	 
	 when chart = 'ccb Market Size'          and prod = '000' then 17
	 when chart = 'ccb Market GR'            and prod = '000' then 18
end as XIdx,
case when chart = 'ccb Market Size' then  1.0*YTD00/1000 else YTD00 end as Y
from OutputPerformanceByBrand_CV_Modi_Slide7 a join OutputPerformanceByBrand_CV_Modi_Slide7_Rank_Coniel b on 
		case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end  =b.Audi_des
where  a.market = 'coniel' and ( a.chart='CCB Market GR' or a.chart='CCB Market Size' or a.chart='City Market&Product Share'or
			(a.chart='City Product Market GR' and prod<>'000') ) and prod in ('000','100','200','300') 
			and b.row_Num between 26 and 50
order by  SeriesIdx,XIdx


------------------------------------------------
--				Eliquis
------------------------------------------------

insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
select 'D' AS IsShow, 'China' as ParentGeo,'China' as Geo, a.Market AS Product,'China' as lev,'YTD' as TimeFrame,@Code as LinkChartCode, 
case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end AS Series, b.row_Num as SeriesIdx,
case when a.MoneyType='LC' then 'RMB' else a.MoneyType end as Currency,
case when chart = 'City Market&Product Share' and prod = '000' then 'VTEP Con%'
	 when chart = 'City Market&Product Share' and prod = '100' then 'Eliquis MS%'
	 when chart = 'City Product Market GR'    and prod = '100' then 'Eliquis GR%'
	 
	 when chart = 'City Market&Product Share' and prod = '200' then 'Clexane MS%'
	 when chart = 'City Product Market GR'    and prod = '200' then 'Clexane GR%'
	 
	 when chart = 'City Market&Product Share' and prod = '300' then 'Xarelto MS%'
	 when chart = 'City Product Market GR'    and prod = '300' then 'Xarelto GR%'
	 
	 when chart = 'City Market&Product Share' and prod = '400' then 'Fraxiparine MS%'
	 when chart = 'City Product Market GR'    and prod = '400' then 'Fraxiparine GR%'
	 when chart = 'City Market&Product Share' and prod = '500' then 'Arixtra MS%'
	 when chart = 'City Product Market GR'    and prod = '500' then 'Arixtra GR%'	 
	 when chart = 'VTEP Market Size'          and prod = '000' then 'VTEP MS Size'
	 when chart = 'VTEP Market GR'            and prod = '000' then 'VTEP GR%'
end as X,	 

case when chart = 'City Market&Product Share' and prod = '000' then 2
	 when chart = 'City Market&Product Share' and prod = '100' then 3
	 when chart = 'City Product Market GR'    and prod = '100' then 4	 
	 when chart = 'City Market&Product Share' and prod = '200' then 5
	 when chart = 'City Product Market GR'    and prod = '200' then 6	 
	 when chart = 'City Market&Product Share' and prod = '300' then 7
	 when chart = 'City Product Market GR'    and prod = '300' then 8	 
	 when chart = 'City Market&Product Share' and prod = '400' then 9
	 when chart = 'City Product Market GR'    and prod = '400' then 10
	 when chart = 'City Market&Product Share' and prod = '500' then 11
	 when chart = 'City Product Market GR'    and prod = '500' then 12		 
	 when chart = 'VTEP Market Size'          and prod = '000' then 17
	 when chart = 'VTEP Market GR'            and prod = '000' then 18
end as XIdx,
case when chart = 'VTEP Market Size' then  1.0*YTD00/1000 else YTD00 end as Y
from OutputPerformanceByBrand_CV_Modi_Slide7 a join OutputPerformanceByBrand_CV_Modi_Slide7_Rank_Eliquis b on 
		case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end  =b.Audi_des
where  a.market = 'Eliquis VTEP' and ( a.chart='VTEP Market GR' or a.chart='VTEP Market Size' or a.chart='City Market&Product Share'or
			(a.chart='City Product Market GR' and prod<>'000') ) and prod in ('000','100','200','300','400','500') 
			and b.row_Num between 26 and 50
order by  SeriesIdx,XIdx


UPDATE output_stage
SET LinkSeriesCode=Product+'_'+LinkChartCode+Series+TimeFrame+cast(SeriesIdx as varchar(10))
WHERE LinkChartCode=@CODE



GO
-- ------------------------------------------------
-- --				Coniel
-- ------------------------------------------------
-- DECLARE @CODE AS VARCHAR(30)
-- SET @CODE = 'R720'
-- DELETE FROM output_stage WHERE LinkChartCode = @CODE

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- select 'D' AS IsShow, 'China' as ParentGeo,'China' as Geo, a.Market AS Product,'China' as lev,'YTD' as TimeFrame,@Code as LinkChartCode, 
-- case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end AS Series, b.row_Num as SeriesIdx,
-- case when a.MoneyType='LC' then 'RMB' else a.MoneyType end as Currency,
-- case when chart = 'City Market&Product Share' and prod = '000' then 'CCB Con%'
-- 	 when chart = 'City Market&Product Share' and prod = '100' then 'Coniel MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '100' then 'Coniel GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '200' then 'Yuan Zhi MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '200' then 'Yuan Zhi GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '300' then 'Lacipil MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '300' then 'Lacipil GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '400' then 'Zanidip MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '400' then 'Zanidip GR%'
-- 	 when chart = 'City Market&Product Share' and prod = '500' then 'Norvasc MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '500' then 'Norvasc GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '600' then 'Adalat MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '600' then 'Adalat GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '700' then 'Plendil MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '700' then 'Plendil GR%'

	 
-- 	 when chart = 'ccb Market Size'          and prod = '000' then 'CCB MS Size'
-- 	 when chart = 'ccb Market GR'            and prod = '000' then 'CCB GR%'
-- end as X,	 
-- case when chart = 'City Market&Product Share' and prod = '000' then 2
-- 	 when chart = 'City Market&Product Share' and prod = '100' then 3
-- 	 when chart = 'City Product Market GR'    and prod = '100' then 4
	 
-- 	 when chart = 'City Market&Product Share' and prod = '200' then 5
-- 	 when chart = 'City Product Market GR'    and prod = '200' then 6
	 
-- 	 when chart = 'City Market&Product Share' and prod = '300' then 7
-- 	 when chart = 'City Product Market GR'    and prod = '300' then 8
	 
-- 	 when chart = 'City Market&Product Share' and prod = '400' then 9
-- 	 when chart = 'City Product Market GR'    and prod = '400' then 10
-- 	 when chart = 'City Market&Product Share' and prod = '500' then 11
-- 	 when chart = 'City Product Market GR'    and prod = '500' then 12
	 
-- 	 when chart = 'City Market&Product Share' and prod = '600' then 13
-- 	 when chart = 'City Product Market GR'    and prod = '600' then 14
	 
-- 	 when chart = 'City Market&Product Share' and prod = '700' then 15
-- 	 when chart = 'City Product Market GR'    and prod = '700' then 16

	 
-- 	 when chart = 'ccb Market Size'          and prod = '000' then 17
-- 	 when chart = 'ccb Market GR'            and prod = '000' then 18
-- end as XIdx,
-- case when chart = 'ccb Market Size' then  1.0*YTD00/1000 else YTD00 end as Y
-- from OutputPerformanceByBrand_CV_Modi_Slide7 a join OutputPerformanceByBrand_CV_Modi_Slide7_Rank_Coniel b on 
-- 		case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end  =b.Audi_des
-- where  a.market = 'coniel' and ( a.chart='CCB Market GR' or a.chart='CCB Market Size' or a.chart='City Market&Product Share'or
-- 			(a.chart='City Product Market GR' and prod<>'000') ) and prod in ('000','400','500','600','700') 
-- 			and b.row_Num between 1 and 25
-- order by  SeriesIdx,XIdx


-- UPDATE output_stage
-- SET LinkSeriesCode=Product+'_'+LinkChartCode+Series+TimeFrame+cast(SeriesIdx as varchar(10))
-- WHERE LinkChartCode=@CODE			

GO

-- --------------------------------------------------
-- ---					Coniel
-- --------------------------------------------------

-- DECLARE @CODE AS VARCHAR(30)
-- SET @CODE = 'R730'
-- DELETE FROM output_stage WHERE LinkChartCode = @CODE

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- select 'D' AS IsShow, 'China' as ParentGeo,'China' as Geo, a.Market AS Product,'China' as lev,'YTD' as TimeFrame,@Code as LinkChartCode, 
-- case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end AS Series, b.row_Num as SeriesIdx,
-- case when a.MoneyType='LC' then 'RMB' else a.MoneyType end as Currency,
-- case when chart = 'City Market&Product Share' and prod = '000' then 'CCB Con%'
-- 	 when chart = 'City Market&Product Share' and prod = '100' then 'Coniel MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '100' then 'Coniel GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '200' then 'Yuan Zhi MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '200' then 'Yuan Zhi GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '300' then 'Lacipil MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '300' then 'Lacipil GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '400' then 'Zanidip MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '400' then 'Zanidip GR%'
-- 	 when chart = 'City Market&Product Share' and prod = '500' then 'Norvasc MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '500' then 'Norvasc GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '600' then 'Adalat MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '600' then 'Adalat GR%'
	 
-- 	 when chart = 'City Market&Product Share' and prod = '700' then 'Plendil MS%'
-- 	 when chart = 'City Product Market GR'    and prod = '700' then 'Plendil GR%'

	 
-- 	 when chart = 'ccb Market Size'          and prod = '000' then 'CCB MS Size'
-- 	 when chart = 'ccb Market GR'            and prod = '000' then 'CCB GR%'
-- end as X,	 
-- case when chart = 'City Market&Product Share' and prod = '000' then 2
-- 	 when chart = 'City Market&Product Share' and prod = '100' then 3
-- 	 when chart = 'City Product Market GR'    and prod = '100' then 4
	 
-- 	 when chart = 'City Market&Product Share' and prod = '200' then 5
-- 	 when chart = 'City Product Market GR'    and prod = '200' then 6
	 
-- 	 when chart = 'City Market&Product Share' and prod = '300' then 7
-- 	 when chart = 'City Product Market GR'    and prod = '300' then 8
	 
-- 	 when chart = 'City Market&Product Share' and prod = '400' then 9
-- 	 when chart = 'City Product Market GR'    and prod = '400' then 10
-- 	 when chart = 'City Market&Product Share' and prod = '500' then 11
-- 	 when chart = 'City Product Market GR'    and prod = '500' then 12
	 
-- 	 when chart = 'City Market&Product Share' and prod = '600' then 13
-- 	 when chart = 'City Product Market GR'    and prod = '600' then 14
	 
-- 	 when chart = 'City Market&Product Share' and prod = '700' then 15
-- 	 when chart = 'City Product Market GR'    and prod = '700' then 16

	 
-- 	 when chart = 'ccb Market Size'          and prod = '000' then 17
-- 	 when chart = 'ccb Market GR'            and prod = '000' then 18
-- end as XIdx,
-- case when chart = 'ccb Market Size' then  1.0*YTD00/1000 else YTD00 end as Y
-- from OutputPerformanceByBrand_CV_Modi_Slide7 a join OutputPerformanceByBrand_CV_Modi_Slide7_Rank_Coniel b on 
-- 		case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end  =b.Audi_des
-- where  a.market = 'coniel' and ( a.chart='CCB Market GR' or a.chart='CCB Market Size' or a.chart='City Market&Product Share'or
-- 			(a.chart='City Product Market GR' and prod<>'000') ) and prod in ('000','400','500','600','700') 
-- 			and b.row_Num between 26 and 50
-- order by  SeriesIdx,XIdx

-- UPDATE output_stage
-- SET LinkSeriesCode=Product+'_'+LinkChartCode+Series+TimeFrame+cast(SeriesIdx as varchar(10))
-- WHERE LinkChartCode=@CODE
-- GO


GO



-- ------------------------------------------
-- 	CIA-CV Monopril Modification: Slide 5
-- ------------------------------------------
-- -- --chart1: value
-- -- declare @code varchar(30)
-- -- set @code ='R651'
-- -- delete from output_stage where linkchartcode = @code

-- -- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- -- select 'Y' as IsShow,'China' as ParentGeo,'China' as Geo, Market AS Product,'China' as lev,'MTH' as TimeFrame,@code as LinkChartCod,
-- -- 	   case when market='Monopril' and prod= '000' then 'Total market'
-- -- 			when market='Monopril' and prod= '100' then 'Monopril'
-- -- 			when market='Monopril' and prod= '200' then 'Acertil'
-- -- 			when market='Monopril' and prod= '700' then 'Lotensin'
-- -- 			when market='Monopril' and prod= '800' then 'Tritace' 
-- -- 			when market='coniel' then productname
-- -- 	   end as Series,
-- -- 	   case when market='Monopril' and prod= '000' then 1			
-- -- 			when market='Monopril' and prod= '200' then 2
-- -- 			when market='Monopril' and prod= '700' then 3
-- -- 			when market='Monopril' and prod= '100' then 4
-- -- 			when market='Monopril' and prod= '800' then 5
-- -- 			when market='coniel' and prod= '000' then 1
-- -- 			when market='coniel' and prod= '100' then 2
-- -- 			when market='coniel' and prod= '200' then 3
-- -- 			when market='coniel' and prod= '300' then 4
-- -- 			when market='coniel' and prod= '400' then 5
-- -- 			when market='coniel' and prod= '500' then 6
-- -- 			when market='coniel' and prod= '600' then 7
-- -- 			when market='coniel' and prod= '700' then 8					
-- -- 	   end as SeriesIdx,
-- -- 	   case when MoneyType ='UN' then 'USD' --由于一张PPT里面要放Value 和 volume 的信息，所以要这么处理
-- -- 			when MoneyType ='US' then 'USD'
-- -- 	   end as Currency,
-- -- 	   X as X,
-- -- 	   row_number() over(partition by a.Type ,a.Prod,a.MoneyType,a.market order by b.monseq desc) as XIdx,
-- -- 	   Y as y	
-- -- from (
-- -- 		select * from OutputPerformanceByBrand_CV_Modi_Slide5_Output where TimeFrame='MTH' and MoneyType ='US' and prod<>'940'
-- -- 		) a join tblMonthList b on a.xidx=b.monseq
		
-- -- UPDATE output_stage
-- -- SET LinkSeriesCode=Product+'_'+LinkChartCode+Series+TimeFrame+cast(SeriesIdx as varchar(10))
-- -- WHERE LinkChartCode=@CODE					
		
-- go

-- --chart2: volume
-- declare @code varchar(30)
-- set @code ='R652'
-- delete from output_stage where linkchartcode = @code

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- select 'Y' as IsShow,'China' as ParentGeo,'China' as Geo, Market AS Product,'China' as lev,'MTH' as TimeFrame,@code as LinkChartCod,
-- 	  case when market='Monopril' and prod= '000' then 'Total market'
-- 			when market='Monopril' and prod= '100' then 'Monopril'
-- 			when market='Monopril' and prod= '200' then 'Acertil'
-- 			when market='Monopril' and prod= '700' then 'Lotensin'
-- 			when market='Monopril' and prod= '800' then 'Tritace' 
-- 			when market='coniel' then productname
-- 	   end as Series,
-- 	   case when market='Monopril' and prod= '000' then 1			
-- 			when market='Monopril' and prod= '200' then 2
-- 			when market='Monopril' and prod= '700' then 3
-- 			when market='Monopril' and prod= '100' then 4
-- 			when market='Monopril' and prod= '800' then 5
-- 			when market='coniel' and prod= '000' then 1
-- 			when market='coniel' and prod= '100' then 2
-- 			when market='coniel' and prod= '200' then 3
-- 			when market='coniel' and prod= '300' then 4
-- 			when market='coniel' and prod= '400' then 5
-- 			when market='coniel' and prod= '500' then 6
-- 			when market='coniel' and prod= '600' then 7
-- 			when market='coniel' and prod= '700' then 8					
-- 	   end as SeriesIdx,
-- 	   case when MoneyType ='UN' then 'USD' --由于一张PPT里面要放Value 和 volume 的信息，所以要这么处理
-- 			when MoneyType ='US' then 'USD'
-- 	   end as Currency,
-- 	   X as X,
-- 	   row_number() over(partition by a.Type ,a.Prod,a.MoneyType,a.market order by b.monseq desc) as XIdx,
-- 	   Y as y	
-- from (
-- 		select * from OutputPerformanceByBrand_CV_Modi_Slide5_Output where TimeFrame='MTH' and MoneyType ='UN'	and prod<>'940'
-- 		) a join tblMonthList b on  a.xidx=b.monseq
		
-- UPDATE output_stage
-- SET LinkSeriesCode=Product+'_'+LinkChartCode+Series+TimeFrame+cast(SeriesIdx as varchar(10))
-- WHERE LinkChartCode=@CODE							



-- GO

-- --Table1: Value Growth
-- declare @code varchar(30)
-- set @code ='R653'
-- delete from output_stage where linkchartcode = @code

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- select 'D' as IsShow,'China' as ParentGeo,'China' as Geo, Market AS Product,'China' as lev,'MTH' as TimeFrame,@code as LinkChartCod,
-- 	  case when market='Monopril' and prod= '000' then 'Total market'
-- 			when market='Monopril' and prod= '100' then 'Monopril'
-- 			when market='Monopril' and prod= '200' then 'Acertil'
-- 			when market='Monopril' and prod= '700' then 'Lotensin'
-- 			when market='Monopril' and prod= '800' then 'Tritace' 
-- 			when market='coniel' then productname
-- 	   end as Series,
-- 	   case when market='Monopril' and prod= '000' then 1			
-- 			when market='Monopril' and prod= '200' then 2
-- 			when market='Monopril' and prod= '700' then 3
-- 			when market='Monopril' and prod= '100' then 4
-- 			when market='Monopril' and prod= '800' then 5
-- 			when market='coniel' and prod= '000' then 1
-- 			when market='coniel' and prod= '100' then 2
-- 			when market='coniel' and prod= '200' then 3
-- 			when market='coniel' and prod= '300' then 4
-- 			when market='coniel' and prod= '400' then 5
-- 			when market='coniel' and prod= '500' then 6
-- 			when market='coniel' and prod= '600' then 7
-- 			when market='coniel' and prod= '700' then 8					
-- 	   end as SeriesIdx,
-- 	   case when MoneyType ='UN' then 'USD' --由于一张PPT里面要放Value 和 volume 的信息，所以要这么处理
-- 			when MoneyType ='US' then 'USD'
-- 	   end as Currency,
-- 	   case when X = 'mth00' then 'Monthly Growth'
-- 			when X = 'mat00' then 'MAT Growth'
-- 			when X = 'ytd00' then 'YTD Growth'
-- 	   end as X,
-- 	   case when X = 'mth00' then 1
-- 			when X = 'mat00' then 2
-- 			when X = 'ytd00' then 3
-- 	   end as XIdx,	
-- 	   Y as y	
-- from	   
-- (
-- 	select Type,Molecule,class,mkt,mktname,market,prod,productname,moneytype,mth00,mat00,ytd00
-- 	FROM OutputPerformanceByBrand_CV_Modi_Slide5
-- 	where   Type = 'Value GR'		and prod<>'940'
-- ) t unpivot (
-- 	Y for X in (mth00,mat00,ytd00)
-- ) a 

-- UPDATE output_stage
-- SET LinkSeriesCode=Product+'_'+LinkChartCode+Series+TimeFrame+cast(SeriesIdx as varchar(10))
-- WHERE LinkChartCode=@CODE			


-- go

-- --table2: volume Growth
-- declare @code varchar(30)
-- set @code ='R654'
-- delete from output_stage where linkchartcode = @code

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- select 'D' as IsShow,'China' as ParentGeo,'China' as Geo, Market AS Product,'China' as lev,'MTH' as TimeFrame,@code as LinkChartCod,
-- 	   case when market='Monopril' and prod= '000' then 'Total market'
-- 			when market='Monopril' and prod= '100' then 'Monopril'
-- 			when market='Monopril' and prod= '200' then 'Acertil'
-- 			when market='Monopril' and prod= '700' then 'Lotensin'
-- 			when market='Monopril' and prod= '800' then 'Tritace' 
-- 			when market='coniel' then productname
-- 	   end as Series,
-- 	   case when market='Monopril' and prod= '000' then 1			
-- 			when market='Monopril' and prod= '200' then 2
-- 			when market='Monopril' and prod= '700' then 3
-- 			when market='Monopril' and prod= '100' then 4
-- 			when market='Monopril' and prod= '800' then 5
-- 			when market='coniel' and prod= '000' then 1
-- 			when market='coniel' and prod= '100' then 2
-- 			when market='coniel' and prod= '200' then 3
-- 			when market='coniel' and prod= '300' then 4
-- 			when market='coniel' and prod= '400' then 5
-- 			when market='coniel' and prod= '500' then 6
-- 			when market='coniel' and prod= '600' then 7
-- 			when market='coniel' and prod= '700' then 8					
-- 	   end as SeriesIdx,
-- 	   case when MoneyType ='UN' then 'USD'  --由于一张PPT里面要放Value 和 volume 的信息，所以要这么处理
-- 			when MoneyType ='US' then 'USD'
-- 	   end as Currency,
-- 	   case when X = 'mth00' then 'Monthly Growth'
-- 			when X = 'mat00' then 'MAT Growth'
-- 			when X = 'ytd00' then 'YTD Growth'
-- 	   end as X,
-- 	   case when X = 'mth00' then 1
-- 			when X = 'mat00' then 2
-- 			when X = 'ytd00' then 3
-- 	   end as XIdx,	
-- 	   Y as y	
-- from	   
-- (
-- 	select Type,Molecule,class,mkt,mktname,market,prod,productname,moneytype,mth00,mat00,ytd00
-- 	FROM OutputPerformanceByBrand_CV_Modi_Slide5
-- 	where   Type = 'Volume GR'	and prod<>'940'
-- ) t unpivot (
-- 	Y for X in (mth00,mat00,ytd00)
-- ) a 

-- UPDATE output_stage
-- SET LinkSeriesCode=Product+'_'+LinkChartCode+Series+TimeFrame+cast(SeriesIdx as varchar(10))
-- WHERE LinkChartCode=@CODE			
-- GO


-- ------------------------------------------
-- --		CIA-CV_Modification(Eliquis) Slide3(R680) and Slide4(R670)
-- ------------------------------------------
-- --R670

-- declare @code varchar(20)
-- declare @currMonth varchar(20)
-- select @currMonth=MonthEN from tblMonthList where MonSeq=1
-- set @code='R670'	
-- delete from output_stage where linkchartcode =@code
-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- select 'Y','China','China', market,'China',TimeFrame,@code, 
-- 		case when Type='MarketValue' then TimeFrame +' '+@currMonth
-- 		     when Type='AvgMarketGrowth' then 'Avg .Growth ('+left(cast(Y*100 as varchar(20)),2) +'%)'
-- 		     when Type='MarketGrowth' then 'Market Growth' 
-- 		end as Series,
-- 		case when Type='MarketValue' then 1
-- 		     when Type='AvgMarketGrowth' then 3
-- 		     when Type='MarketGrowth' then 2 
-- 		end as SeriesIdx,		
-- 		case when MoneyType ='LC' then 'RMB'
-- 		     when MoneyType ='US' then 'USD'
-- 		     when MoneyType ='UN' then 'UNIT'
-- 		end as Currency,
-- 		Audi_des as X,
-- 		Audi_Rank as XIdx,
-- 		case when Type='MarketValue' then 1.0*Y
-- 			 else  round(Y,2) end as Y  		
-- from Output_CIA_CV_Modification_Slide_3And4
-- where type in ('MarketValue','AvgMarketGrowth','MarketGrowth')

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- select 'L','China','China', market,'China',TimeFrame, @code,
-- 		case when Type='ProductGrowth' then ProductName+' GR(%)' end as Series,
-- 		case when productName='ELIQUIS' then 1
-- 			 when productName='XARELTO' then 2
-- 			 when productName='FRAXIPARINE' then 3
-- 			 when productName='CLEXANE' then 4
-- 			 when productName='ARIXTRA' then 5	 
-- 	    end as SeriesIdx,
-- 		case when MoneyType ='LC' then 'RMB'
-- 		     when MoneyType ='US' then 'USD'
-- 		     when MoneyType ='UN' then 'UNIT'
-- 		end as Currency,
-- 		Audi_Rank as X,
-- 		Audi_Rank as XIdx,
-- 		cast(round(y,2)*100 as int) as Y
-- from Output_CIA_CV_Modification_Slide_3And4 
-- where Type='ProductGrowth' and productName in ('ELIQUIS','XARELTO','FRAXIPARINE','CLEXANE','ARIXTRA')


-- update [output_stage]
-- set LinkSeriesCode=Product+'_'+LinkChartCode+Series+cast(SeriesIdx as varchar(10)) where LinkChartCode='R670' and IsShow = 'Y'

-- update [output_stage]
-- set LinkSeriesCode=Product+'_'+LinkChartCode+'_'+geo+isshow+cast(SeriesIdx as varchar(10)) where LinkChartCode = 'R670' and IsShow = 'L'


-- GO

-- --R680

-- declare @code varchar(20)
-- declare @currMonth varchar(20)
-- select @currMonth=MonthEN from tblMonthList where MonSeq=1
-- set @code='R680'	
-- delete from output_stage where linkchartcode =@code
-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- select 'Y','China','China', market,'China',TimeFrame,@code, 
-- 		case when Type='MarketValue' then TimeFrame +' '+@currMonth
-- 		end as Series,
-- 		case when Type='MarketValue' then 1
-- 		end as SeriesIdx,		
-- 		case when MoneyType ='LC' then 'RMB'
-- 		     when MoneyType ='US' then 'USD'
-- 		     when MoneyType ='UN' then 'UNIT'
-- 		end as Currency,
-- 		Audi_des as X,
-- 		Audi_Rank as XIdx,
-- 		case when Type='MarketValue' then 1.0*Y
-- 			 else  round(Y,2) end as Y  		
-- from Output_CIA_CV_Modification_Slide_3And4
-- where type in ('MarketValue')

-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- select 'L','China','China', market,'China',TimeFrame, @code,
-- 		case when Type='ProductValueShare' then ProductName+' MS(%)' 
-- 			 when Type='MarketContribution' then 'Contri b.(%)'
-- 		end as Series,
-- 		case when  Type='MarketContribution' then 1
-- 		     when  Type='ProductValueShare' and productName='ELIQUIS' then 2
-- 			 when  Type='ProductValueShare' and productName='XARELTO' then 3
-- 			 when  Type='ProductValueShare' and productName='FRAXIPARINE' then 4
-- 			 when  Type='ProductValueShare' and productName='CLEXANE' then 5
-- 			 when  Type='ProductValueShare' and productName='ARIXTRA' then 6
-- 	    end as SeriesIdx,
-- 		case when MoneyType ='LC' then 'RMB'
-- 		     when MoneyType ='US' then 'USD'
-- 		     when MoneyType ='UN' then 'UNIT'
-- 		end as Currency,
-- 		Audi_Rank as X,
-- 		Audi_Rank as XIdx,
-- 		cast(round(y,2)*100 as int) as Y
-- from Output_CIA_CV_Modification_Slide_3And4
-- where Type in ('ProductValueShare','MarketContribution') 
-- 	and productName in ('ELIQUIS','XARELTO','FRAXIPARINE','CLEXANE','ARIXTRA','Eliquis (VTEp) Market')

-- update [output_stage]
-- set LinkSeriesCode=Product+'_'+LinkChartCode+Series+cast(SeriesIdx as varchar(10)) where LinkChartCode='R680' and IsShow = 'Y'

-- update [output_stage]
-- set LinkSeriesCode=Product+'_'+LinkChartCode+'_'+geo+isshow+cast(SeriesIdx as varchar(10)) where LinkChartCode = 'R680' and IsShow = 'L'

GO

-- ------------------------------------------------------------------------
-- --	Insert values into output_stage table: Growth Trend of Monopril Region
-- ------------------------------------------------------------------------
-- print ('
-- ------------------------------------------------------------------------
-- 	1. Insert valuse into output_stage table: Growth Trend of Monopril Region
-- ------------------------------------------------------------------------	
-- ')

-- delete from output_stage where LinkChartCode='R710'

-- declare @i int
-- declare @mqtList varchar(4000)
-- declare @mqt_GR varchar(4000)
-- set @i=0
-- set @mqtList=''
-- set @mqt_GR=''
-- while @i<=24
-- begin
-- 	set @mqtList=@mqtList+',[mqt'+right('0'+convert(varchar(2),@i),2)+']'
-- 	set @mqt_GR=@mqt_GR+',case when sum(r3m'+right('0'+convert(varchar(2),@i+12),2)+') =0 or sum(r3m'+right('0'+convert(varchar(2),@i+12),2)+') is null then 10000 else 1.0*(sum(r3m'+
-- 					right('0'+convert(varchar(2),@i),2)+') - SUM(r3m'+right('0'+convert(varchar(2),@i+12),2)+'))/sum(r3m'+right('0'+convert(varchar(2),@i+12),2)+') end as mqt'+right('0'+convert(varchar(2),@i),2)
-- 	set @i=@i+1
-- end
-- set @mqtList=right(@mqtList,len(@mqtList)-1)
-- print @mqtList
-- print @mqt_GR
-- declare @sql varchar(max)
-- set @sql='
-- insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx,Y)
-- select t.IsShow,t.ParentGeo,t.Geo,t.Product,t.Lev,t.TimeFrame,t.LinkChartCode,t.Series,
-- t.SeriesIdx,t.Currency,t2.X, 200- t2.Monseq as XIdx,t.y
-- from (
-- 	select ''Y'' as IsShow,''China'' as ParentGeo, b.Region as Geo,a.market as Product,''Region'' as Lev,''MQT'' as TimeFrame,
-- 	''r710'' as LinkChartCode,a.Productname as Series,a.prod as SeriesIdx, 
-- 	case when a.MoneyType = ''US'' then ''USD''
-- 		 when a.MoneyType = ''UN'' then ''UNIT''
-- 		 when a.MoneyType = ''LC'' then ''RMB'' end as Currency'+@mqt_GR+'
-- 	from tempCityDashboard_ForPre a join(
-- 			select Geo as city, ParentGeo as Region 
-- 			from db4.BMSChinaCIA_IMS_test.dbo.outputgeo where (product=''coniel'' and lev=2) or parentgeo is null
-- 	)b on a.Audi_des=b.city
-- 	where mkt in (''ACE'',''CCB'') AND MoneyType <>''PN'' 
-- 	group by molecule,class,a.mkt,a.mktname,a.market,a.prod,a.productname,b.Region,a.MoneyType
-- ) a unpivot (
-- 	Y for X in ('+@mqtList+')
-- ) t join (
-- 	select ''mqt''+right(''0''+convert(varchar(2),MonSeq-1),2) as mqt_name,Monseq,''MQT ''+MonthEN as X
-- 		from tblmonthList 
-- ) t2 on t.x=t2.mqt_name
-- '

-- exec (@sql)

-- update [output_stage]
-- set y =null
-- where linkchartcode='R710' and y=10000

-- update [output_stage]
-- set LinkSeriesCode=Product+'_'+LinkChartCode+'_'+Geo+'_'+Series+cast(SeriesIdx as varchar(10)) where LinkChartCode='R710' and IsShow = 'Y'


update output_stage
set DataSource= case when linkchartcode in ('C100','C110','C210','C220','R320') then 'HKAPI' else 'IMS' end

exec dbo.sp_Log_Event 'Output','CIA','3_2_Output_R.sql','End',null,null