use BMSChinaCIA_IMS_test
GO


exec dbo.sp_Log_Event 'Output','CIA','3_1_Output_D_C121.sql','Start',null,null



---------------------------------------------------------
-- C121
---------------------------------------------------------
delete from output_stage where linkchartcode='C121'
GO

declare @code varchar(10)
set @code = 'C121'

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
	select 'MAT00' as Series,	12 as SeriesIdx union all
	select 'MAT12' as Series,	11 as SeriesIdx union all
	select 'MAT24' as Series,	10 as SeriesIdx union all
	select 'MAT36' as Series,	9 as SeriesIdx union all
	select 'MAT48' as Series,	8 as SeriesIdx union all
	select 'Mth06' as Series,	7 as SeriesIdx union all
	select 'Mth07' as Series,	6 as SeriesIdx union all
	select 'Mth08' as Series,	5 as SeriesIdx union all
	select 'Mth09' as Series,	4 as SeriesIdx union all
	select 'Mth10' as Series,	3 as SeriesIdx union all
	select 'Mth11' as Series,	2 as SeriesIdx union all
	select 'Mth12' as Series,	1 as SeriesIdx
) a, (
	select distinct [type], typeIdx,Period,MoneyType,market 
    from dbo.OutputProdSalesPerformanceInChina where market='ELIQUIS (NOAC)' and MoneyType<>'PN'
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
		--print @Series

		set @SQL2='
		update [output_stage]
		set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.OutputProdSalesPerformanceInChina B
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
set product='Eliquis NOAC'
where LinkChartCode='C121'

update output_stage
set timeframe=case timeframe when 'Rolling 3 Months' then 'MQT' else timeframe end
where LinkChartCode='C121'
go
update [output_stage]
set LinkSeriesCode=Product+'_'+LinkChartCode+Series+cast(SeriesIdx as varchar(10)) where LinkChartCode='C121'
go
update [output_stage]
set Category=case Currency when 'UN' then 'Units' when 'PN' then 'Adjusted patient number' else 'Value' end
where LinkChartCode='C121'
go
update [output_stage]
set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' when 'PN' then 'UNIT' 
else Currency end 
where LinkChartCode='C121'
go
delete from [output_stage] where LinkChartCode='C121' and timeFrame<>'Mth' and X like 'Mth%'
go

update [output_stage] set series=case series 
when 'MAT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
when 'MAT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)
when 'MAT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)
when 'MAT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)
when 'MAT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)
when 'MAT00Growth' then  TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)+' Growth'
when 'MAT12Growth' then  TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)+' Growth'
else series
end  where LinkChartCode='C121' and TimeFrame<>'MTH'
go
update [output_stage]
set X=case X when 'MAT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
when 'MAT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=13)
when 'MAT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=25)
when 'MAT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=37)
when 'MAT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=49)
else X
end  where LinkChartCode='C121' and TimeFrame<>'MTH'
go

update [output_stage]
set series=case series when 'MAT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
when 'MAT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=2)
when 'MAT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=3)
when 'MAT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=4)
when 'MAT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=5)
when 'Mth06' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=6)
when 'Mth07' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=7)
when 'Mth08' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=8)
when 'Mth09' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=9)
when 'Mth10' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=10)
when 'Mth11' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=11)
when 'Mth12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=12)
else series
end  where LinkChartCode='C121' and TimeFrame='MTH'
go
update [output_stage]
set X=case X when 'MAT00' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=1)
when 'MAT12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=2)
when 'MAT24' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=3)
when 'MAT36' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=4)
when 'MAT48' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=5)
when 'Mth06' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=6)
when 'Mth07' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=7)
when 'Mth08' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=8)
when 'Mth09' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=9)
when 'Mth10' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=10)
when 'Mth11' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=11)
when 'Mth12' then TimeFrame + ' '+(select [MonthEN] from tblMonthList where monseq=12)
else X
end  where LinkChartCode='C121' and TimeFrame='MTH'
go
update [output_stage]
set LinkedY=b.LinkY from [output_stage] A inner join(
select product,min(parentgeo) as LinkY  from outputgeo where lev=2
group by product) B
on A.product=B.product
where A.LinkChartCode='C121'
go
update [output_stage]
set LinkedY=b.LinkY from [output_stage] A inner join(
select product,min(parentgeo) as LinkY  from outputgeo where lev=2
group by product) B
on left(A.product,7)=B.product
where A.LinkChartCode='C121' and a.product like 'ELIQUIS%'
go
update [output_stage] set Category='Adjusted patient number'
from [output_stage] 
where Product ='Paraplatin' and LinkChartCode='C121' and Category='Dosing Units'








--------------------------------------------
-- C131
--------------------------------------------
delete from output_stage where linkchartcode='C131'
GO

declare @code varchar(10)
set @code = 'C131'

--正常MQT
insert into [output_stage] (Product,isshow,geo,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
select B.market, 'Y','China','Nation',Period, @code as Code, b.Productname,b.Prod,MoneyType, a.Series,a.SeriesIdx
from (
	select 'MAT00' as Series,	25 as SeriesIdx union all
	select 'MAT01' as Series,	24 as SeriesIdx union all
	select 'MAT02' as Series,   23 as SeriesIdx union all
	select 'MAT03' as Series,	22 as SeriesIdx union all
	select 'MAT04' as Series,	21 as SeriesIdx union all
	select 'MAT05' as Series,	20 as SeriesIdx union all
	select 'MAT06' as Series,	19 as SeriesIdx union all
	select 'MAT07' as Series,	18 as SeriesIdx union all
	select 'MAT08' as Series,	17 as SeriesIdx union all
	select 'MAT09' as Series,	16 as SeriesIdx union all
	select 'MAT10' as Series,	15 as SeriesIdx union all
	select 'MAT11' as Series,	14 as SeriesIdx union all
	select 'MAT12' as Series,	13 as SeriesIdx union all
	select 'MAT13' as Series,	12 as SeriesIdx union all
	select 'MAT14' as Series,	11 as SeriesIdx union all
	select 'MAT15' as Series,	10 as SeriesIdx union all
	select 'MAT16' as Series,	9 as SeriesIdx union all
	select 'MAT17' as Series,	8 as SeriesIdx union all
	select 'MAT18' as Series,	7 as SeriesIdx union all
	select 'MAT19' as Series,	6 as SeriesIdx union all
	select 'MAT20' as Series,	5 as SeriesIdx union all
	select 'MAT21' as Series,	4 as SeriesIdx union all
	select 'MAT22' as Series,	3 as SeriesIdx union all
	select 'MAT23' as Series,	2 as SeriesIdx union all
	select 'MAT24' as Series,	1 as SeriesIdx
) a, (
select distinct Productname, Prod,Period,MoneyType,market from dbo.OutputKeyBrandPerformance_For_OtherETV 
where market in ('ELIQUIS NOAC') and MoneyType<>'PN'
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
		set Y=B.'+@Series+ ' from [output_stage] A inner join dbo.OutputKeyBrandPerformance_For_OtherETV B
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
	set LinkSeriesCode=Product+'_'+LinkChartCode+Series+cast(SeriesIdx as varchar(10)) where LinkChartCode='C131'
	go
	update [output_stage]
	set Category=case Currency when 'UN' then 'Units' when 'PN' then 'Adjusted patient number' else 'Value' end
	where LinkChartCode='C131'
	go
	update [output_stage]
	set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' when 'PN' then 'UNIT'  else Currency end 
	where LinkChartCode='C131'
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
	end  where LinkChartCode=''C131'''
	exec(@sql)
	GO
--C141

	delete from output_stage where linkchartcode='C141'
	declare @code varchar(10),@i int,@sql varchar(8000)
	set @i=0
	set @code = 'C141'
	insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
	select 'Y',B.Period, @code as Code, A.Market,A.Productname,A.Prod,moneytype, a.Audi_des,a.Audi_cod,'China' as lev,'China'
	from (
	select A.*,b.Audi_cod,B.Audi_des from (
	select distinct MoneyType,mkt,Market,Prod,Productname,region
	 from dbo.OutputKeyBrandPerformanceByRegion_For_OtherETV where Class='N'
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
	(select distinct MoneyType,mkt,Market,Audi_cod,Audi_des,region
	 from dbo.OutputKeyBrandPerformanceByRegion_For_OtherETV where Class='N' ) B
	on A.moneytype=b.moneytype and a.mkt=b.mkt and a.market=b.market and a.region=b.region
	) a ,(					select 'MQT' as Period union all
							select 'MTH' as Period union all
							select 'MAT' as Period union all
							select 'YTD' as Period ) B
	where a.Market in ('Eliquis NOAC')

	update [output_stage]
	set Y=case B.type when 'Market Total' then convert(varchar(50),cast(B.R3M00 as float),1) else B.R3M00 end,
	IntY=case B.type when 'Market Total' then cast(B.R3M00 as float) end   from [output_stage] A inner join dbo.OutputKeyBrandPerformanceByRegion_For_OtherETV B
	on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
	and A.timeFrame='MQT'where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y'
	update [output_stage]
	set Y=case B.type when 'Market Total' then convert(varchar(50),cast(B.MTH00 as float),1) else B.MTH00 end,
	IntY=case B.type when 'Market Total' then cast(B.MTH00 as float) end  from [output_stage] A inner join dbo.OutputKeyBrandPerformanceByRegion_For_OtherETV B
	on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
	and A.timeFrame='MTH'where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y'
	update [output_stage]
	set Y=B.MAT00,
	IntY=B.MAT00 from [output_stage] A inner join dbo.OutputKeyBrandPerformanceByRegion_For_OtherETV B
	on A.X=B.audi_des and A.Series=B.Productname  and a.Product = B.market and A.Currency=B.moneytype
	and A.timeFrame='MAT' where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y'
	update [output_stage]
	set Y=B.YTD00,
	IntY=B.YTD00 from [output_stage] A inner join dbo.OutputKeyBrandPerformanceByRegion_For_OtherETV B
	on A.X=B.audi_des and A.Series=B.Productname  and a.Product = B.market and A.Currency=B.moneytype
	and A.timeFrame='YTD' where B.Class='N'and A.LinkChartCode=@code and A.ISshow='Y'

	insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
	select 'L',B.Period, @code as Code, A.Market,A.Productname,A.Prod,moneytype, a.Audi_des,a.Audi_cod,'China' as lev,'China'
	from (
	select A.*,b.Audi_cod,B.Audi_des from (
	select distinct MoneyType,mkt,Market,Prod,Productname,region
	 from dbo.OutputKeyBrandPerformanceByRegionGrowth where Class='N' --and Mkt<>'DPP4'
	) A inner join
	(select distinct MoneyType,mkt,Market,Audi_cod,Audi_des,region
	 from dbo.OutputKeyBrandPerformanceByRegionGrowth where Class='N') B
	on A.moneytype=b.moneytype and a.mkt=b.mkt and a.market=b.market and a.region=b.region
	) a ,(select 'MQT' as Period union all
								 select 'MTH' as Period union all
								 select 'MAT' as Period union all
								select 'YTD' as Period  ) B
	where a.Market IN ('Eliquis NOAC')					

	update [output_stage]
	set Y=B.R3M00,
	IntY=B.R3M00 from [output_stage] A inner join dbo.OutputKeyBrandPerformanceByRegionGrowth B
	on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
	and A.timeFrame='MQT'where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' --and B.Mkt<>'DPP4'
	update [output_stage]
	set Y=B.MTH00,
	IntY=B.MTH00 from [output_stage] A inner join dbo.OutputKeyBrandPerformanceByRegionGrowth B
	on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
	and A.timeFrame='MTH'where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' --and B.Mkt<>'DPP4'
	update [output_stage]
	set Y=B.MAT00,
	IntY=B.MAT00 from [output_stage] A inner join dbo.OutputKeyBrandPerformanceByRegionGrowth B
	on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
	and A.timeFrame='MAT' where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' --and B.Mkt<>'DPP4'
	update [output_stage]
	set Y=B.YTD00,
	IntY=B.YTD00 from [output_stage] A inner join dbo.OutputKeyBrandPerformanceByRegionGrowth B
	on A.X=B.audi_des and A.Series=B.Productname and a.Product = B.market and A.Currency=B.moneytype
	and A.timeFrame='YTD' where B.Class='N'and A.LinkChartCode=@code and A.ISshow='L' --and B.Mkt<>'DPP4'
 
go
	
--D023

delete from output_stage where linkchartcode in('D023')
declare @code varchar(10),@i int,@sql varchar(8000)
set @i=0
set @code = 'D023'
set @sql=''
set @sql=@sql+'insert into [output_stage] (isshow,TimeFrame,LinkChartCode,Product, Series, SeriesIdx,Currency, X, XIdx,lev,geo)
select isshow,A.Period, '+''''+@code+''''+' as Code, Market,B.Audi_des,B.Audi_cod,MoneyType,a.Series,a.SeriesIdx, ''Region'' as lev,B.region
from ('
while (@i<=11)
begin
set @sql=@sql+'
select  ''MQT'' as Period,'+''''+'R3M'+right('00'+cast(@i as varchar(3)),2)+''+''''+' as Series,''Y'' as isshow,'+cast(18-@i+1 as varchar(3))+' as SeriesIdx union all
select  ''MTH'' as Period,'+''''+'MTH'+right('00'+cast(@i as varchar(3)),2)+''+''''+' as Series,''Y'' as isshow,'+cast(18-@i+1 as varchar(3))+' as SeriesIdx union all
'
set @i=@i+1
end
set  @sql=left(@sql,len(@sql)-11)+' Union all
select  ''YTD'' as Period,''YTD00'' as series,''D'' as ishow,21 as SeriesIdx union all
select  ''YTD'' as Period,''YTD12'' as series,''D'' as ishow,20 as SeriesIdx) a, (
select distinct MoneyType,mkt,Market,Prod,Productname,Audi_cod,Audi_des,region 
from  dbo.OutputGeoHBVSummaryT1 where Class=''N'' and Market=''eliquis noac''
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
		set Y=B.['+@Series+ '] from [output_stage] A inner join dbo.OutputGeoHBVSummaryT1 B
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
go
update [output_stage]
set LinkSeriesCode=Product+'_'+LinkChartCode+'_'+geo+cast(SeriesIdx as varchar(10))+Isshow where LinkChartCode in('D023','D031','D041')
go
update [output_stage]
set Category=case Currency when 'UN' then 'Units' else 'Value' end
where LinkChartCode in('D023','D031','D041')
go
update [output_stage]
set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' else Currency end 
where LinkChartCode in('D023','D031','D041')
go

delete from [output_stage] 
where LinkChartCode in('D023') and Product in ('Taxol','paraplatin') and TimeFrame='MQT'
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
when 'YTD00' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=1)
when 'YTD12' then  'YTD '+(select [MonthEN] from tblMonthList where monseq=13)
else X
end  where LinkChartCode in('D023','D031','D041') and TimeFrame in ('MQT','YTD')
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
end  where LinkChartCode in('D023')  and TimeFrame='MTH'
go
--D024

	--------------------------------------------
	--D024
	--------------------------------------------
	delete from output_stage where linkchartcode  in('D024')
	GO

	declare @code varchar(10),@i int,@sql varchar(8000)
	set @i=0
	set @code = 'D024'

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
		   where Class = 'N' and Mkt ='eliquis noac'
		   ) A 
	  inner join
		  (
		   select distinct MoneyType,mkt,Market,Audi_cod,Audi_des,region
		   from dbo.OutputGeoHBVSummaryT2_For_OtherETV 
		   where Class = 'N' and Mkt ='eliquis noac'
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
			   from dbo.OutputGeoHBVSummaryGrowthT1 where Class='N' and Mkt='eliquis noac'
			  ) A 
		 inner join
			  (
			  select distinct MoneyType,mkt,Market,Audi_cod,Audi_des,region
			  from dbo.OutputGeoHBVSummaryGrowthT1 where Class='N' and Mkt='eliquis noac'
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

	Go
	update [output_stage]
	set series=series+' GR' where LinkChartCode in('D024','D032','D042','C141','C900') and isshow='L'
	go
	update [output_stage]
	set LinkSeriesCode=Product+'_'+LinkChartCode+'_'+geo+isshow+cast(SeriesIdx as varchar(10)) where LinkChartCode in('D024','D032','D042','C141','C900')	
	
	update [output_stage]
	set Category=case Currency when 'UN' then 'Units' else 'Value' end
	where LinkChartCode in('D024','D032','D042','C141','C900')
	update [output_stage]
	set Currency=case Currency when 'US' then 'USD' when 'LC' then 'RMB' when 'UN' then 'UNIT' else Currency end 
	where LinkChartCode in('D024','D032','D042','C141','C900')
	go
	update output_stage
	set LinkedY=X where (linkchartcode like 'D024%' or  linkchartcode like 'D032%' or linkchartcode like 'D042%' or linkchartcode like 'C141' or linkchartcode like 'C900')
	and isshow='Y'
	go
	if exists (select * from dbo.sysobjects where id = object_id(N'tblDivNumber_ForD022') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tblDivNumber_ForD022
	go
	select linkchartcode,currency,timeFrame,geo,Product,X, case --when max(cast(y as float)) between 5000 and 5000000 then 1000
	when max(cast(y as float)) between 5000 and 5000000000 then 1000000
	when max(cast(y as float)) >= 5000000000 then 1000000000 else 1 end as divide,
	case --when max(cast(y as float)) between 5000 and 5000000 then 'K'
	when max(cast(y as float)) between 5000 and 5000000000 then ' mio.'
	when max(cast(y as float)) >= 5000000000 then ' bn.' else '' end as Dol
	into tblDivNumber_ForD022 from output_stage A where seriesidx=0
	and linkchartcode in('D024','D032','D042','C141','C900')
	group by linkchartcode,currency,timeFrame,geo,Product,X
	go
	update output_stage
	set seriesidx=10000 where seriesidx=0
	and linkchartcode in('D024','D032','D042','C141','C900') and isshow='Y'

	go
	update output_stage
	set x=A.X+Char(13)+'('+left(convert(varchar(50),cast(cast(B.IntY as float) as money),1),len(convert(varchar(50),cast(cast(B.IntY as float) as money),1))-3)+')'--A.x+' ('+cast(round(cast(B.y as float)*1.0/C.divide,1) as varchar(20))+C.dol+')'
	FROM output_stage a INNER JOIN (select * from output_stage where seriesidx='10000') b
	ON A.linkchartcode=b.linkchartcode and a.product=b.product and a.lev=b.lev and a.geo=b.geo 
	and a.category=b.category and a.currency=b.currency and a.timeframe=b.timeframe
	AND A.X=B.X
	and isnull(a.isshow,'')=isnull(b.isshow,'')
	and a.isshow='Y' and A.linkchartcode in ('D024','D032','D042','C141','C900')
	left join tblDivNumber_ForD022 C
	on A.timeframe=C.timeframe and A.Currency=C.Currency
	and A.linkchartcode=C.linkchartcode and A.geo=C.geo and A.product=C.Product and A.X=C.X
	go
	DELETE FROM output_stage
	WHERE seriesidx='10000' and linkchartcode in ('D024','D032','D042','C141','C900')and isshow='Y'
	go	
	
--D085
delete from output_stage where linkchartcode='D085'

	declare @code varchar(10)
	set @code = 'D085'
	insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
	select isshow,Region,Audi_des,b.Market,'City',a.Period, @code as Code, B.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
	from (
		select 'MQT' as Period,'R3M00' as Series,					6 as SeriesIdx union all
		select 'MQT' as Period,'R3M01' as Series,				5 as SeriesIdx union all
		select 'MQT' as Period,'R3M02' as Series,		4 as SeriesIdx union all
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
	Region,Audi_des,MoneyType,market,Productname,Prod from dbo.OutputCityPerformanceByBrand_For_OtherETV where Chart in('Volume Trend','CAGR') and Class='N' and molecule='N' and Mkt='Eliquis NOAC'
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
			on case B.Chart when ''Volume Trend'' then ''Y'' else ''N'' end=A.isshow and A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'and B.Chart in(''Volume Trend'',''CAGR'') and B.Class=''N'' and B.molecule=''N'' and B.Mkt<>''DPP4''
			and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and A.ParentGeo=B.region and A.geo=B.audi_des'
			print @SQL2
			exec( @SQL2)

		END
		FETCH NEXT FROM TMP_CURSOR INTO @Series
	END
	CLOSE TMP_CURSOR
	DEALLOCATE TMP_CURSOR
	go
	delete output_stage where linkchartcode='D085' and isshow='N' and xidx<>6
	go
--D086
delete from output_stage where linkchartcode='D086'

	declare @code varchar(10)
	set @code = 'D086'
	insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
	select 'Y',Region,Audi_des,B.Market,'City',a.Period, @code as Code, b.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
	from (
		select 'MQT' as Period,'R3M00' as Series,					6 as SeriesIdx union all
		select 'MQT' as Period,'R3M01' as Series,				5 as SeriesIdx union all
		select 'MQT' as Period,'R3M02' as Series,		4 as SeriesIdx union all
		select 'MQT' as Period,'R3M03' as Series,	3 as SeriesIdx union all
		select 'MQT' as Period,'R3M04' as Series,	2 as SeriesIdx union all
		select 'MQT' as Period,'R3M05' as Series,	1 as SeriesIdx union all
		select 'YTD' as Period,'YTD00' as Series,	6 as SeriesIdx union all
		select 'YTD' as Period,'YTD12' as Series,	5 as SeriesIdx union all
		select 'YTD' as Period,'YTD24' as Series,	4 as SeriesIdx union all
		select 'YTD' as Period,'YTD36' as Series,	3 as SeriesIdx union all
		select 'YTD' as Period,'YTD48' as Series,	2 as SeriesIdx
	) a, (
		select distinct Region,Audi_des,MoneyType,market,Productname,prod from dbo.OutputCityPerformanceByBrand_For_OtherETV where Chart='Market Share Trend' and Class='N' and  molecule='N' and Mkt='Eliquis NOAC'
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
			on A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'and B.Chart=''Market Share Trend'' and B.Class=''N'' and  B.molecule=''N'' and B.mkt=''Eliquis NOAC''
			and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and A.ParentGeo=B.region and A.geo=B.audi_des'
			print @SQL2
			exec( @SQL2)

		END
		FETCH NEXT FROM TMP_CURSOR INTO @Series
	END
	CLOSE TMP_CURSOR
	DEALLOCATE TMP_CURSOR
	go
	
delete from  output_stage where linkchartcode='D087'
	declare @code varchar(10)
	set @code = 'D087'
	insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
	select 'Y',Region,Audi_des,b.Market,'City',a.Period, @code as Code, b.Productname,B.prod,MoneyType, a.Series,a.SeriesIdx
	from (
		select 'MQT' as Period,'R3M00' as Series,					6 as SeriesIdx union all
		select 'MQT' as Period,'R3M01' as Series,				5 as SeriesIdx union all
		select 'MQT' as Period,'R3M02' as Series,		4 as SeriesIdx union all
		select 'MQT' as Period,'R3M03' as Series,	3 as SeriesIdx union all
		select 'MQT' as Period,'R3M04' as Series,	2 as SeriesIdx union all
		select 'MQT' as Period,'R3M05' as Series,	1 as SeriesIdx union all
		select 'YTD' as Period,'YTD00' as Series,	6 as SeriesIdx union all
		select 'YTD' as Period,'YTD12' as Series,	5 as SeriesIdx union all
		select 'YTD' as Period,'YTD24' as Series,	4 as SeriesIdx union all
		select 'YTD' as Period,'YTD36' as Series,	3 as SeriesIdx union all
		select 'YTD' as Period,'YTD48' as Series,	2 as SeriesIdx
	) a, (
		select distinct Region,Audi_des,MoneyType,market,Productname,prod from dbo.OutputCityPerformanceByBrand_For_OtherETV where Chart='Growth Trend' and class='N' and  molecule='N' and Mkt='Eliquis NOAC'
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
			on A.Currency=B.MoneyType and A.X='+''''+@Series+''''+'and B.Chart=''Growth Trend'' and B.Class=''N'' and  B.molecule=''N'' and B.Mkt=''Eliquis NOAC''
			and a.LinkChartCode = '+''''+@code+''''+' and A.Series=B.Productname and A.ParentGeo=B.region and A.geo=B.audi_des'
			print @SQL2
			exec( @SQL2)

		END
		FETCH NEXT FROM TMP_CURSOR INTO @Series
	END
	CLOSE TMP_CURSOR
	DEALLOCATE TMP_CURSOR
	go
delete from output_stage where LinkChartCode='D088'
	declare @code varchar(10)
	set @code = 'D088'
	insert into [output_stage] (isshow,ParentGeo,Geo,Product,lev,TimeFrame,LinkChartCode, Series, SeriesIdx,Currency, X, XIdx)
	select 'Y',Region,Audi_des,b.Market,'City',a.Period, @code as Code,a.Series,a.SeriesIdx ,MoneyType,b.Productname,B.prod
	from (
		select 'MQT' as Period,'R3M00' as Series,	1 as SeriesIdx union all
		select 'YTD' as Period,'YTD00' as Series,	1 as SeriesIdx 
	) a, (
		select distinct Region,Audi_des,MoneyType,market,Productname,prod from dbo.OutputCityPerformanceByBrand_For_OtherETV where Chart='Share of Growth Trend' and Class='N' and  molecule='N' and Mkt='eliquis noac'
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
			on A.Currency=B.MoneyType and A.Series='+''''+@Series+''''+'and B.Chart=''Share of Growth Trend'' and B.Class=''N'' and  B.molecule=''N'' and B.Mkt=''eliquis noac''
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
	set LinkSeriesCode=Product+'_'+LinkChartCode+'_'+geo+Series+cast(SeriesIdx as varchar(10)) where  LinkChartCode like 'D08%' or LinkChartCode like 'D09%' or LinkChartCode like 'D10%'
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
	else X
	end where LinkChartCode like 'D08%' or LinkChartCode like 'D09%' or LinkChartCode like 'D10%'
	go
	update output_stage set Color='4E71D1' 
	where  LinkChartCode in ('D084','D094','D104')
	go

	delete from output_stage where series in('ARV Others','NIAD Others','ONCFCS Others')
	 and (LinkChartCode like 'D08%' or LinkChartCode like 'D09%' or LinkChartCode like 'D10%')
	go
	update output_stage
	set Y=0 where (linkchartcode='D081' or linkchartcode='D085' or linkchartcode='D091' or linkchartcode='D101') and (y is null or cast(y as float)=0)


go

update output_stage set datasource='IMS' where linkchartcode in ('C121','C131','C141','D023')