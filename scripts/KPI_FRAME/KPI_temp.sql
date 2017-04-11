

--HKAPI MNC Company and Brand Ranking 20170222
IF OBJECT_ID(N'KPI_Frame_MNC_Company_Ranking_RDPAC_data',N'U') IS NOT NULL
    DROP TABLE KPI_Frame_MNC_Company_Ranking_RDPAC_data
go

select distinct
    cast('YTD' as varchar(20)) as [Period], 1 as CurrRank, 1 as PrevRank, null as CORP_cod,
    b.[Company Name] as corp_des,
    sum(YTD00US) as YTD00US, sum(YTD12US) as YTD12US 
into KPI_Frame_MNC_Company_Ranking_RDPAC_data        
from dbo.inHKAPI_New a 
left JOIN BMSChinaOtherDB.dbo.HKAPI_CompanyName b 
    on a.[Company Name] = b.Abbreviation 
group by b.Abbreviation, b.[Company Name]
order by sum(YTD00US) desc
go

delete KPI_Frame_MNC_Company_Ranking_RDPAC_data 
where YTD00US = 0 and YTD12US = 0

-- delete KPI_Frame_MNC_Company_Ranking_RDPAC_data 
-- where CORP_cod is null

update a 
set CurrRank = B.Rank 
from KPI_Frame_MNC_Company_Ranking_RDPAC_data A 
inner join (
        select row_number() OVER (order by sum(YTD00US) desc ) as Rank, corp_des, sum(YTD00US) as YTD00US
        from dbo.KPI_Frame_MNC_Company_Ranking_RDPAC_data A 
        where corp_des is not null
        group by corp_des 
    ) B
on A.corp_des = B.corp_des and A.[Period]='YTD'


update a 
set PrevRank = B.Rank 
from KPI_Frame_MNC_Company_Ranking_RDPAC_data A 
inner join (
        select RANK ( )OVER (order by sum(YTD12US) desc ) as Rank, corp_des, sum(YTD12US) as YTD12US
        from dbo.KPI_Frame_MNC_Company_Ranking_RDPAC_data A 
        where corp_des is not null
        group by corp_des 
    ) B
on A.corp_des = B.corp_des and A.[Period]='YTD'


insert into KPI_Frame_MNC_Company_Ranking_RDPAC_data
select 'YTD', 99, 99, null, 'MNC Total', sum(YTD00US), sum(YTD12US)
from KPI_Frame_MNC_Company_Ranking_RDPAC_data 

delete KPI_Frame_MNC_Company_Ranking_RDPAC_data
where corp_des is null


ALTER TABLE KPI_Frame_MNC_Company_Ranking_RDPAC_data 
ADD Series_Idx varchar(10),
    X_Idx varchar(10),
    [Y2Y GR] float
go
update  KPI_Frame_MNC_Company_Ranking_RDPAC_data 
set [Y2Y GR] = (YTD00US-YTD12US)/YTD12US

update KPI_Frame_MNC_Company_Ranking_RDPAC_data 
set Series_Idx = currrank


alter table KPI_Frame_MNC_Company_Ranking_RDPAC_data alter column currRank int
alter table KPI_Frame_MNC_Company_Ranking_RDPAC_data alter column PrevRank int

delete KPI_Frame_MNC_Company_Ranking_RDPAC_data 
where CurrRank >15 and CurrRank <> 99

go 


IF OBJECT_ID(N'KPI_Frame_MNC_Company_Ranking_RDPAC_temp',N'U') IS NOT NULL
    drop table KPI_Frame_MNC_Company_Ranking_RDPAC_temp
go
SELECT period,CORP_cod,CORP_Des,x,y,series_Idx,X_idx,currRank,PrevRank
into KPI_Frame_MNC_Company_Ranking_RDPAC_temp
from (
        select period,currRank,PrevRank,CORP_cod,CORP_Des,YTD00US,YTD12US,[Y2Y GR],series_Idx,X_idx
        from KPI_Frame_MNC_Company_Ranking_RDPAC_data
    ) a
unpivot (
        Y  for X in (YTD00US,YTD12US,[Y2Y GR])
    ) T

IF OBJECT_ID(N'KPI_Frame_MNC_Company_Ranking_RDPAC_temp2',N'U') IS NOT NULL
    drop table KPI_Frame_MNC_Company_Ranking_RDPAC_temp2
go
select period,CORP_cod,CORP_Des,x,y,temp_x,temp_y,series_Idx,X_idx
into KPI_Frame_MNC_Company_Ranking_RDPAC_temp2
from (
        select * from KPI_Frame_MNC_Company_Ranking_RDPAC_temp 
) a
unpivot
(
    temp_y for temp_x IN(currRank,PrevRank)
) t

IF OBJECT_ID(N'KPI_Frame_MNC_Company_Ranking_RDPAC',N'U') IS NOT NULL
    drop table KPI_Frame_MNC_Company_Ranking_RDPAC
go
select period,corp_des,x,y,series_idx,x_idx 
into KPI_Frame_MNC_Company_Ranking_RDPAC 
from KPI_Frame_MNC_Company_Ranking_RDPAC_temp2 where 1=0

insert into KPI_Frame_MNC_Company_Ranking_RDPAC
select period,corp_des,x,y,series_Idx,X_Idx 
from KPI_Frame_MNC_Company_Ranking_RDPAC_temp2 
union 
select period,corp_des,temp_x,temp_y,series_Idx,X_Idx 
from KPI_Frame_MNC_Company_Ranking_RDPAC_temp2 

update a set x_idx=case when x='YTD00US' then 1
						when x='YTD12US' then 2
						when x='Y2Y GR' then 3
						when x='PrevRank' then 4
						when x='currRank' then 5
						end
from KPI_Frame_MNC_Company_Ranking_RDPAC a

update a set x=case when right(left(x,5),2)='00' then 'YTD Dec''16'  -- todo 
				  when right(left(x,5),2)='12' then 'YTD Dec''15'
				  when X='currRank' then period+' Dec''16 Ranking'
				  when X='PrevRank' then period+' Dec''15 Ranking'
				  else x end
from KPI_Frame_MNC_Company_Ranking_RDPAC a


alter table KPI_Frame_MNC_Company_Ranking_RDPAC alter column series_idx int
alter table KPI_Frame_MNC_Company_Ranking_RDPAC alter column x_idx int

-----------------------------------------------
-- -- HKAPI MNC Brand Ranking
IF OBJECT_ID(N'KPI_Frame_MNC_Brand_Ranking_RDPAC_data',N'U') IS NOT NULL
    DROP TABLE KPI_Frame_MNC_Brand_Ranking_RDPAC_data
go

select top 16 cast('YTD' as varchar(20)) as [Period],1 as CurrRank,1 as PrevRank,
    b.Product_code as PROD_COD, b.product_name,
    sum(YTD00US) as YTD00US ,sum(YTD12US) as YTD12US
into KPI_Frame_MNC_Brand_Ranking_RDPAC_data
from inHKAPI_New  a
inner join dim_product b
    on a.[Product Name] = B.Product_Name 
where b.product_name not in ('PULMICORT RESP','ALBUMIN HUMAN')
group by b.Product_code, b.product_name
order by sum(YTD00US) desc 

insert into KPI_Frame_MNC_Brand_Ranking_RDPAC_data 
select 'YTD', 99, 99, null, 'MNC Total', sum(YTD00US), sum(YTD12US)
from inHKAPI_New as a 
inner join dim_product b
    on a.[Product Name] = B.Product_Name 
where b.product_name not in ('PULMICORT RESP','ALBUMIN HUMAN')

if exists(
    select * from KPI_Frame_MNC_Brand_Ranking_RDPAC_data 
    where product_name like '%GLUCOPHAGE%' and period='YTD')
begin
    print 'GLUCOPHAGE in Top 15 MTH US'
end
else
begin
    insert into KPI_Frame_MNC_Brand_Ranking_RDPAC_data
    select 'YTD',1,1,b.Product_code, b.product_name,
        sum(YTD00US),sum(YTD12US)
    from dbo.inHKAPI_New A 
    inner join dim_product b
        on a.[Product Name] = B.Product_Name 
    where product_name like '%GLUCOPHAGE%'
    group by b.Product_code, b.product_name 
end


update KPI_Frame_MNC_Brand_Ranking_RDPAC_data
set CurrRank=B.Rank 
from KPI_Frame_MNC_Brand_Ranking_RDPAC_data A 
inner join (
    select dense_RANK ( )OVER (order by sum(YTD00US) desc ) as Rank, PROD_COD, sum(YTD00US) as YTD00US
    from dbo.KPI_Frame_MNC_Brand_Ranking_RDPAC_data A 
    where PROD_COD is not null
    group by PROD_COD ) B
on A.PROD_COD=B.PROD_COD and A.[Period]='YTD'

update KPI_Frame_MNC_Brand_Ranking_RDPAC_data
set PrevRank=B.Rank 
from KPI_Frame_MNC_Brand_Ranking_RDPAC_data A 
inner join (
    select dense_RANK ( )OVER (order by sum(YTD12US) desc ) as Rank, PROD_COD, sum(YTD12US) as YTD00US
    from dbo.KPI_Frame_MNC_Brand_Ranking_RDPAC_data A 
    where PROD_COD is not null
    group by PROD_COD ) B
on A.PROD_COD=B.PROD_COD and A.[Period]='YTD' 

ALTER TABLE KPI_Frame_MNC_Brand_Ranking_RDPAC_data ADD Series_Idx varchar(10),X_Idx varchar(10),[Y2Y GR] float
go
update  KPI_Frame_MNC_Brand_Ranking_RDPAC_data set [Y2Y GR] = (YTD00US-YTD12US)/YTD12US

update KPI_Frame_MNC_Brand_Ranking_RDPAC_data set Series_Idx = currrank

go

IF OBJECT_ID(N'KPI_Frame_MNC_Brand_Ranking_RDPAC_temp',N'U') IS NOT NULL
    drop table KPI_Frame_MNC_Brand_Ranking_RDPAC_temp
go
SELECT period,prod_cod,product_name,x,y,series_Idx,X_idx,currRank,PrevRank
into KPI_Frame_MNC_Brand_Ranking_RDPAC_temp
from
(
    select period,currRank,PrevRank,prod_cod,product_name,YTD00US,YTD12US,[Y2Y GR],series_Idx,X_idx
    from KPI_Frame_MNC_Brand_Ranking_RDPAC_data
)a
unpivot (
    Y  for X in (YTD00US,YTD12US,[Y2Y GR])
) T

IF OBJECT_ID(N'KPI_Frame_MNC_Brand_Ranking_RDPAC_temp2',N'U') IS NOT NULL
    drop table KPI_Frame_MNC_Brand_Ranking_RDPAC_temp2
go
select period,prod_cod,product_name,x,y,temp_x,temp_y,series_Idx,X_idx
into KPI_Frame_MNC_Brand_Ranking_RDPAC_temp2
from (
    select * from KPI_Frame_MNC_Brand_Ranking_RDPAC_temp 
)a
unpivot
(
    temp_y for temp_x IN(currRank,PrevRank)
) t

IF OBJECT_ID(N'KPI_Frame_MNC_Brand_Ranking_RDPAC',N'U') IS NOT NULL
    drop table KPI_Frame_MNC_Brand_Ranking_RDPAC
go
select period,product_name,x,y,series_idx,x_idx 
into KPI_Frame_MNC_Brand_Ranking_RDPAC 
from KPI_Frame_MNC_Brand_Ranking_RDPAC_temp2 where 1=0

insert into KPI_Frame_MNC_Brand_Ranking_RDPAC
select period,product_name,x,y,series_Idx,X_Idx from KPI_Frame_MNC_Brand_Ranking_RDPAC_temp2 
union 
select period,product_name,temp_x,temp_y,series_Idx,X_Idx from KPI_Frame_MNC_Brand_Ranking_RDPAC_temp2 
go
update a 
set x_idx=case when x='YTD00US' then 1
                when x='YTD12US' then 2
                when x='Y2Y GR' then 3
                when x='PrevRank' then 4
                when x='currRank' then 5
                end
from KPI_Frame_MNC_Brand_Ranking_RDPAC a

update a 
set x=case when right(left(x,5),2)='00' then 'YTD Dec''16' -- todo 
            when right(left(x,5),2)='12' then 'YTD Dec''15' 
            when X='currRank' then period+' YTD Dec''16 Ranking'
            when X='PrevRank' then period+' YTD Dec''15 Ranking'
            else x end
from KPI_Frame_MNC_Brand_Ranking_RDPAC a

alter table KPI_Frame_MNC_Brand_Ranking_RDPAC alter column series_idx int
alter table KPI_Frame_MNC_Brand_Ranking_RDPAC alter column x_idx int


go

----------------------------------------------------------------------------------
-- MKT & Brand Growth 

IF OBJECT_ID(N'KPI_Frame_MKTBrand_Growth',N'U') IS NOT NULL
    drop table KPI_Frame_MKTBrand_Growth
go

select * 
into KPI_Frame_MKTBrand_Growth
from KPI_Frame_ChinaMarket_Brandview
where X like '%growth%'
	and series in (
		'Total China Hospital Market',
		'Total MNC Company',
		'Company view:  BMS',
		'Brand view:  Baraclude'
		)

update KPI_Frame_MKTBrand_Growth
set series = case series 
            when 'Company view:  BMS' then 'BMS Company'
            when 'Brand view:  Baraclude' then 'Baraclude'
            else series 
            end ,
    X = case X 
            when 'Growth(Y2Y)(mth)' then 'Monthly Growth(Y2Y)'
            when 'Growth(Y2Y)(ytd)' then 'YTD Growth(Y2Y)'
            else X end 
GO

alter table KPI_Frame_MKTBrand_Growth
add X_Idx int 
go
 
update KPI_Frame_MKTBrand_Growth
set X_Idx = case
            when X like '%mth%' then 1
            when X like '%ytd%' then 2
            else 3 
            end 
           

go          

------------------------------------------------------------------------------------
-- IMS Audit - CHPA (both Volume and Value) -- Viread

IF OBJECT_ID(N'TempCHPAPreReports_For_Viread',N'U') IS NOT NULL
    drop table TempCHPAPreReports_For_Viread
go

declare @max_Year int , @YTD_mth int 
declare @sql varchar(8000);

set @max_Year = ( select max(Year) from tblMonthList )
set @YTD_mth = ( select count(*) from tblMonthList where Year = @max_Year )

SELECT * 
into TempCHPAPreReports_For_Viread
FROM TempCHPAPreReports_For_Baraclude 
where prod = 600

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_IMS_Audit_CHPA_Viread_Mid') and type='U')
BEGIN
	DROP TABLE KPI_Frame_IMS_Audit_CHPA_Viread_Mid
END

set @sql = '
select  ''VIREAD'' as series, a.Moneytype , '

declare @i int 
set @i = 0 
while @i < @YTD_mth + 1
begin
    set @sql = @sql + 'b.MTH' + right('00' + convert(varchar(2), @i), 2) + ', '
    set @i = @i + 1
end
set @sql = left(@sql , len(@sql) -1 )
set @sql = @sql + '
into KPI_Frame_IMS_Audit_CHPA_Viread_Mid
from TempCHPAPreReports_For_Viread a
inner join TempCHPAPreReports_For_Viread b
    on a.Market = b.Market and a.mkt = b.mkt and a.Moneytype = b.Moneytype 
        and a.Class = b.Class and A.Molecule=B.Molecule
		and A.Market=B.Market 
'
--print @sql 
exec(@sql)

set @sql = '
insert into KPI_Frame_IMS_Audit_CHPA_Viread_Mid
select ''Growth'', 
    a.Moneytype, '
set @i = 0
while @i < @YTD_mth 
begin 
    set @sql = @sql + 'b.MTH' + right('00' + convert(varchar(2), @i), 2) 
        + '/a.MTH' + right('00' + convert(varchar(2), @i + 1), 2) + ' - 1, '
    set @i = @i + 1
end 
set @sql = @sql + ' null 
from TempCHPAPreReports_For_Viread a
inner join TempCHPAPreReports_For_Viread b
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
		and A.Market=B.Market 
'
--print @sql 
exec(@sql)

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_IMS_Audit_CHPA_Viread') and type='U')
BEGIN
	DROP TABLE KPI_Frame_IMS_Audit_CHPA_Viread
END

set @sql = '
select  Moneytype, ''600'' as Prod, 
	convert(varchar(20), series) as series, 
	case Moneytype when ''LC'' then ''Value''
		when ''UN'' then ''Unit''
		end as DataType, X, Y , null as X_Idx, null as series_Idx 
into KPI_Frame_IMS_Audit_CHPA_Viread
from (
    select * from KPI_Frame_IMS_Audit_CHPA_Viread_Mid
    where Moneytype in (''LC'', ''UN'')
) as a
unpivot (
	Y for X in (
        '

set @i = 0
while @i < @YTD_mth 
begin 
    set @sql = @sql + 'MTH' + right('00' + convert(varchar(2), @i), 2)  + ', '
    set @i = @i + 1
end 
set @sql = left(@sql , len(@sql) -1 )
set @sql = @sql + '
	)
) as p '
--print @sql 
exec(@sql)

update a
set a.X = b.MonthEN,
    a.X_Idx = ( @YTD_mth + 1 - b.MonSeq) ,
    a.series = 
        case a.series when 'Growth' then 'Growth vs last month'
        else a.series end ,
    a.series_Idx = 
        case a.series when 'Growth' then 2
        else 1 end 
from KPI_Frame_IMS_Audit_CHPA_Viread as a
inner join tblMonthList as b on right(a.X, 2) = b.MonSeq - 1

go 
------------------------------------------------------------------------------------------------------
-- RDPAC 5 product 

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_IMS_RDPAC_5cites_temp') and type='U')
BEGIN
	DROP TABLE KPI_Frame_IMS_RDPAC_5cites_temp
END

declare @QtrNum int 
declare @Qtr varchar(10) , @sql varchar(8000);

set @QtrNum = (
    select distinct QtrSeq 
    from dbo.tblMonthList
    where year = '2015' and Quarter = 'Q1'
)

set @sql = 'SELECT [Product Name],'
declare @i int 
set @i = 0
while @i < @QtrNum
BEGIN
    set @Qtr = (    select distinct right(convert(varchar(4), year), 2) + quarter 
                    from dbo.tblMonthList where QtrSeq = @QtrNum - @i )
    set @sql = @sql + '[' + @Qtr + 'US] * 1000 as [' + @Qtr + 'US] , '
    set @i = @i + 1
END 
set @sql = @sql + 'YTD00US, YTD12US 
    into KPI_Frame_IMS_RDPAC_5cites_temp
    from inHKAPI_New 
    where [Product Name] in (
        ''baraclude'',
        ''Hepsera'',
        ''Heptodin'',
        ''Sebivo'',
        ''Viread''
        )' 
print @sql 
exec(@sql) 

set @sql = '
insert into KPI_Frame_IMS_RDPAC_5cites_temp 
select ''Total'', '

set @i = 0 
while @i < @QtrNum
BEGIN
    set @Qtr = (    select distinct right(convert(varchar(4), year), 2) + quarter 
                    from dbo.tblMonthList where QtrSeq = @QtrNum - @i )
    set @sql = @sql + 'sum([' + @Qtr + 'US])  as [' + @Qtr + 'US], '
    set @i = @i + 1
End 
set @sql = @sql + ' 0, 0 '
set @sql = @sql + ' from KPI_Frame_IMS_RDPAC_5cites_temp as a '
print @sql 
exec(@sql) 

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_IMS_RDPAC_5cites') and type='U')
BEGIN
	DROP TABLE KPI_Frame_IMS_RDPAC_5cites
END

set @sql = '
SELECT [Product Name] as series , X, Y, null as X_Idx, null as series_Idx 
into KPI_Frame_IMS_RDPAC_5cites
from KPI_Frame_IMS_RDPAC_5cites_temp 
unpivot (
	Y for X in ( '

set @i = 0 
while @i < @QtrNum
BEGIN
    set @Qtr = (    select distinct right(convert(varchar(4), year), 2) + quarter 
                    from dbo.tblMonthList where QtrSeq = @QtrNum - @i )
    set @sql = @sql + '[' + @Qtr + 'US], '
    set @i = @i + 1
End 
set @sql = left(@sql , len(@sql) -1 )
set @sql = @sql + ')
) as p'
print @sql 
exec(@sql)

update a 
set a.X_Idx = (@QtrNum + 1 - QtrSeq ) ,
    a.series_Idx = 
        case a.series 
            when 'Total' then 1
            when 'Baraclude' then 2
            when 'Hepsera' then 3
            when 'Heptodin' then 4
            when 'Sebivo' then 5
            when 'Viread' then 6
            else 99 end ,
    a.X = convert(varchar(4), b.Year ) + b.Quarter
from KPI_Frame_IMS_RDPAC_5cites as a 
inner join tblMonthList as b on left(a.X, 4) = right(convert(varchar(4), b.year), 2) + b.quarter 



IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_IMS_RDPAC_5cites_Y2Y') and type='U')
BEGIN
	DROP TABLE KPI_Frame_IMS_RDPAC_5cites_Y2Y
END


SELECT 'YTD Growth(Y2Y)' as series, 
	[Product Name] as X , (YTD00US / YTD12US) - 1 as Y,
	null as X_Idx, null as series_Idx 
into KPI_Frame_IMS_RDPAC_5cites_Y2Y
from KPI_Frame_IMS_RDPAC_5cites_temp 
where [Product Name] <> 'Total'

update a 
set a.X_Idx = 
        case a.X 
            when 'Baraclude' then 1
            when 'Hepsera' then 2
            when 'Heptodin' then 3
            when 'Sebivo' then 4
            when 'Viread' then 5
            else 99 end ,
    a.series_Idx = 1
from KPI_Frame_IMS_RDPAC_5cites_Y2Y as a 

GO
----------------------------------------------------------------------------------------------------
--KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'[KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]') and type='U')
BEGIN
	DROP TABLE [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
END
select * into [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel] 
from [KPI_Frame_MarketAnalyzer_PRDLProvince_For_Byetta] where 1=2
go


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'TempRDPACAudic') and type='U')
BEGIN
	DROP TABLE TempRDPACAudic
END
go
declare @LCQuerter varchar(max)
declare @sql varchar(max)

set @sql=' '
select @LCQuerter=stuff((
select ',['+right(convert(varchar(10),year),2)+Quarter+'LC]'
from (select distinct year,quarter from tblMonthList where qtrseq<>0) a 
for xml path(''))
,1,1,'')
print @LCQuerter

--set @LCQuerter=replace(@LCQuerter,',[14Q2LC]','')

set @sql='
select [Product Name] as ProductName,Y,X,left(X,2) as [Year],right(X,2) as MoneyType, 1 as ProdIdx
into TempRDPACAudic from
(select * from inHKAPI_New where [Product Name] in (''Glivec'',''Tasigna'',''Sprycel'',''SPYCEL'')) A
unpivot (
	Y for X in ( '+@LCQuerter+' ) 
 ) T
 '
 print @sql 
 Exec( @sql)
go
update TempRDPACAudic 
set Y=Y/2 where ProductName='GLIVEC'
go
update TempRDPACAudic
set ProductName='GLIVEC-CML' where ProductName='GLIVEC'
go
update TempRDPACAudic
set ProdIdx=case ProductName when 'GLIVEC-CML' then 1 when 'Tasigna' then '2' else 3 end
--select * from TempRDPACAudic
go


print 'Create Output table for RDPAC Audit'
go
truncate table [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
go
insert into [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
(Timeframe, MoneyType, Molecule, Class, mkt, mktname, market, prod, Series, DataType, Category, y, X, Series_idx, X_Idx)
select 'Year',Moneytype,'N','N','SPRYCEL','SPRYCEL Market','SPRYCEL',ProdIdx+'00',ProductName,'Sales','Value',sum(Y)*1000 as Y,[Year],ProdIdx,cast([year] as int)
from TempRDPACAudic 
where [year]>='08'
group by Moneytype,ProductName,[Year],ProdIdx
go
insert into [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
(Timeframe, MoneyType, Molecule, Class, mkt, mktname, market, prod, Series, DataType, Category, y, X, Series_idx, X_Idx)
select 'SoQtr',Moneytype,'N','N','SPRYCEL','SPRYCEL Market','SPRYCEL',ProdIdx+'00',ProductName,'Sales','Value',sum(Y)*1000 as Y,X,ProdIdx,cast([year]+left(right(X,3),1) as int)
from TempRDPACAudic 
where [year]>='12'
group by Moneytype,ProductName,X,[Year],ProdIdx
go
insert into [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
(Timeframe, MoneyType, Molecule, Class, mkt, mktname, market, prod, Series, DataType, Category, y, X, Series_idx, X_Idx)
select 'EaQtr',Moneytype,'N','N','SPRYCEL','SPRYCEL Market','SPRYCEL',ProdIdx+'00',ProductName,'Sales','Value',sum(Y)*1000 as Y,X,ProdIdx,cast([year]+left(right(X,3),1) as int)
from TempRDPACAudic A
where exists(
		select * 
		from (
			select ProductName,min(X) as MinX  
			from TempRDPACAudic
			where Y<>0
			group by Productname	) B 
		where A.ProductName=B.ProductName and A.X>=B.MinX	) 
	and ProductName in ('Tasigna','Sprycel') 
group by Moneytype,ProductName,X,[Year],ProdIdx
go
update [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
set X=replace(X,'LC','')
update [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
set X='20'+X where len(X)<=2
go
update [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
set series=A.series+' (Start from 20' +left(B.StartQtr,2)+''''+right(B.StartQtr,2)+')' 
from [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel] A inner join 
		(select timeframe,series,min(X) as StartQtr from [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
		where timeframe='EaQtr'
		group by timeframe,series) B
on A.series=b.series and a.timeframe=b.timeframe
go
delete from [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel] 
where timeframe='EaQtr' and series like '%TASIGNA%'
	and X not in
		(
			select distinct a.x from(
				select x,row_number() over(order by x) row_num from [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
				where timeframe='EaQtr' and series like '%TASIGNA%'
			) a join (
					select x,row_number() over(order by x) row_num from [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel] 
					where timeframe='EaQtr' and series like '%Sprycel%'
			) b on a.row_num=b.row_num	
		)
go
update [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
set X='L+'+cast(B.Rank as varchar(3))+'Q'
from [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel] A 
inner join 
(	select *,RANK() OVER (PARTITION BY  series order by X_idx) as RANK
	from [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel] where timeframe='EaQtr') B
on A.timeFrame=B.timeFrame and A.X=B.X and A.series=B.series
go
--select * from [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
 

-----------------------------------------------------------------------------
-- KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel_Mid') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel_Mid
END
go

select * 
into KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel_Mid
from KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel 
where 1 = 0

insert into [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel_Mid]
(Timeframe, MoneyType, Molecule, Class, mkt, mktname, market, prod, Series, 
    DataType, Category, y, X, Series_idx, X_Idx)
select 'YTD',Moneytype,'N','N','SPRYCEL','SPRYCEL Market','SPRYCEL',ProdIdx+'00',
    ProductName,'Sales','Growth',sum(Y)*1000 as Y,'20' + [Year],ProdIdx,cast([year] as int)
from TempRDPACAudic 
where [year]>='07'
group by Moneytype,ProductName,[Year],ProdIdx

insert into [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel_Mid]
(Timeframe, MoneyType, Molecule, Class, mkt, mktname, market, prod, Series, 
    DataType, Category, y, X, Series_idx, X_Idx)
select 'YTD',Moneytype,'N','N','SPRYCEL','SPRYCEL Market','SPRYCEL', '000',
    'Market', 'Sales','Growth',sum(Y)*1000 as Y, '20' + [Year],0,cast([year] as int)
from TempRDPACAudic 
where [year]>='07'
group by Moneytype,[Year]

update a 
set a.y = case when b.y = 0 then 0 else (a.y - b.y) / b.y end
from KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel_Mid  as a 
inner join KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel_Mid as b 
on a.TimeFrame = b.TimeFrame and a.MoneyType = b.MoneyType and a.Molecule = b.Molecule
	and a.Class = b.Class and a.Mkt = b.Mkt and a.Market = b.Market
	and a.Series = b.Series and a.DataType = b.DataType and a.Category = b.Category
	and convert(int, a.X ) = (convert(int, b.X ) + 1 )
where a.X >= '2008'

delete a 
from KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel_Mid as a
where a.X < '2008'

update a 
set a.series = case a.Series 
    when 'Market' then 'Market  GR(vs  last year)'
    when 'GLIVEC-CML' then 'Glivec GR(vs  last year)'
    when 'TASIGNA' then 'Tasigna GR(vs  last year)'
    when 'SPRYCEL' then 'Sprycel GR(vs  last year)'
    else a.series end 
from KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel_Mid  as a 


insert into [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
(Timeframe, MoneyType, Molecule, Class, mkt, mktname, market, prod, Series, 
	DataType, Category, y, X, Series_idx, X_Idx)
select * 
from KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel_Mid

alter table [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
alter column Y decimal(22,8) 
go 

-- add all market value 
insert into [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
(Timeframe, MoneyType, Molecule, Class, mkt, mktname, market, 
    prod, Series, DataType, Category, y, X, Series_idx, X_Idx)
SELECT TimeFrame, MoneyType, Molecule, Class, Mkt, Mktname, Market, 
	'000', 'Market', DataType, Category, sum(y), x, 0, X_Idx 
from KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel 
where Category <> 'growth'
group by timeframe, MoneyType, Molecule, Class, Mkt, Mktname, Market,
	 DataType, Category, x, X_Idx


delete
FROM KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel 
where TimeFrame in( 'eaqtr', 'SoQtr') and series = 'market'



----------------------------------------------------------
-- CPA BAL Hositals 

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_MarketAnalyzer_CPA_BAL_Hosp') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MarketAnalyzer_CPA_BAL_Hosp
END
go

-- exec sp_addlinkedserver 'DB36','','SQLOLEDB','172.20.0.36'
-- exec sp_addlinkedsrvlogin 'DB36', 'false', null, 'sa', 'love2you'

go

select * 
into KPI_Frame_MarketAnalyzer_CPA_BAL_Hosp
from DB36.[BMSChinaCSR_Testing].[dbo].[Output_Brand_Output_BALHospital] 
where brandcode='0156' 

alter table KPI_Frame_MarketAnalyzer_CPA_BAL_Hosp 
add Market varchar(50)
GO

update KPI_Frame_MarketAnalyzer_CPA_BAL_Hosp 
set market = 'Sprycel'
where brandcode = '0156'


go

---------------------------------------------------------
-- HCV-D 

-- insert into dbo.tblExcelBrandMaster ( BrandName, BrandCode, BrandIdx )
-- values	( 'HCV-D', -- BrandName - varchar(50)
-- 		  'HCV', -- BrandCode - varchar(50)
-- 		  13  -- BrandIdx - int
-- 		  )

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'tblMktDef_Inline_For_HCV') and type='U')
BEGIN
	DROP TABLE tblMktDef_Inline_For_HCV
END
go

SELECT 'HCV' as Mkt, 'HCV Market' as Mktname, * 
into tblMktDef_Inline_For_HCV 
FROM tblMktDef_ATCDriver
where Prod_Des in ('PEGASYS', 'PEG-INTRON')


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'temp_IMSAudit_CHPA_HCV') and type='U')
BEGIN
	DROP TABLE temp_IMSAudit_CHPA_HCV
END
go

declare @MthNum int 
declare @Qtr varchar(10) , @sql varchar(8000);

set @MthNum = (
    select distinct MonSeq 
    from dbo.tblMonthList
    where year = '2015' and Month = '1'
)

set @sql = 'SELECT b.Mole_cod, b.Mkt, b.Prod_cod, b.Prod_Des,'
declare @i int 
set @i = 0
while @i < @MthNum
BEGIN
    set @sql = @sql + 'sum([MTH' + right('00' + convert(varchar(5), @i), 2) 
        + 'US]) as [MTH' + right('00' + convert(varchar(5), @i), 2) + 'US]' + ' , '
    set @i = @i + 1
END 
set @sql = @sql + 'sum(YTD00US) as YTD00US , sum(YTD12US) as YTD12US, 
    sum(a.MAT00US) as MAT00US, sum(a.MAT12US) as MAT12US 	
    into temp_IMSAudit_CHPA_HCV 
    from dbo.MTHCHPA_PKAU as a
    inner join dbo.tblMktDef_Inline_For_HCV as b on a.PACK_COD = b.Pack_Cod
    group by b.Mole_cod, b.Mkt, b.Prod_cod, b.Prod_Des'
print @sql 
exec(@sql) 
GO

alter table temp_IMSAudit_CHPA_HCV 
add MonthlyGrowth float 
go 

update temp_IMSAudit_CHPA_HCV
set YTD00US = (YTD00US / YTD12US) - 1,
	MAT00US = (MAT00US / MAT12US) - 1,
    MonthlyGrowth = (MTH00US / MTH12US) - 1

go 


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_HCV') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_HCV
END
go

declare @MthNum int 
declare @Qtr varchar(10) , @sql varchar(8000);

set @MthNum = (
    select distinct MonSeq 
    from dbo.tblMonthList
    where year = '2015' and Month = '1'
)

set @sql = 'select Prod_Des as Series, X, Y,  convert(varchar(10), '''') as DataType, null Series_Idx, null as X_Idx 
into KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_HCV
from temp_IMSAudit_CHPA_HCV 
unpivot (
	Y for X in ('

declare @i int 
set @i = 0
while @i < @MthNum
BEGIN
    set @sql = @sql + '[MTH' + right('00' + convert(varchar(5), @i), 2) + 'US]' + ' , '
    set @i = @i + 1
END 
set @sql = @sql + ' [YTD00US], [MAT00US], [MonthlyGrowth])
) as p'
print @sql 
exec(@sql) 


update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_HCV 
set Series_Idx = 
    case Series 
    when 'PEGASYS' then 1
    when 'PEG-INTRON' then 2 
    else 99 end ,
    X_Idx = case when X like '%MTH%' then @MthNum - convert(int, substring(X, 4, 2)) 
        when X like '%YTD%' then 98
        when X like '%MAT%' then 97 
        else 99 end ,
    DataType = case when X like '%MTH%' then 'Value'
        else 'Growth' end 

update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_HCV 
set X = 
    case when X like '%MTH%' then (select MonthEN from tblMonthList where Monseq = convert(int, substring(X, 4, 2)) + 1 )
    when X like '%YTD%' then 'YTD Growth(Y2Y)' 
    when X like '%MAT%' then 'MAT Growth(Y2Y)' 
    when X like '%Monthly%' then 'Monthly Growth(Y2Y)'
    else X end 

--------------------------------------------------------------------
--- MAX Data 

----------------------------------------------------------
-- MAX data rollup for city, production, month 

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'MAXData_Rollup_CityProdMth') and type='U')
BEGIN
	DROP TABLE MAXData_Rollup_CityProdMth
END
go

declare @MthNum int , @QtrNum int, @YTDNum int 
declare @Mth varchar(10) , @sql varchar(8000);

set @MthNum = (
    select MonSeq 
    from dbo.tblMonthList
    where year = '2014' and Month = '1'
)
set @QtrNum = (
    select QtrSeq  
    from dbo.tblMonthList
    where year = '2014' and Month = '1'
)
set @YTDNum = (
    select max(MonSeq) 
    from dbo.tblMonthList
    where year = (select max(Year) from tblMonthList)
)


set @sql = 'SELECT a.Province, replace(a.city, N''市'', '''') as city, Prod_cod, Prod_Des, Mole_cod, Mole_des, Pack_Cod, Pack_des, 
 '
-- month 
declare @i int , @j int , @k int
set @i = 0   
while @i < @MthNum  
BEGIN
    set @Mth = ( select Date from tblMonthList where MonSeq = @i + 1 )
    set @sql = @sql + 'sum([' + @Mth + ' Dosage Unit]) as [' + @Mth +'US] , '
    set @i = @i + 1
END 

--print @sql 
print @QtrNum 

--quarter
set @i = 0  --  
while @i < @QtrNum 
begin  
    set @j = ( select count(*) from tblMonthList where QtrSeq = @i + 1 )
    set @k = 0
	set @sql = @sql + ' ('
    while @k < @j 
    begin 
        set @Mth = ( select Date from tblMonthList where MonSeq = @k + @i * 3 + 1 )
        set @sql = @sql + ' sum([' + @Mth + ' Dosage Unit]) + '
		set @k = @k + 1 
    end 
    set @sql = left(@sql, len(@sql) - 2) + ') as [' + (select distinct (convert(varchar(4), Year) + Quarter) from tblMonthList where QtrSeq = @i + 1) + 'US], '
    set @i = @i + 1
end 

-- YTD 
set @i = 0  --  
set @sql = @sql + ' ('
while @i < @YTDNum  
BEGIN
    set @Mth = ( select Date from tblMonthList where MonSeq = @i + 1 )
    set @sql = @sql + ' sum([' + @Mth + ' Dosage Unit]) + '
    set @i = @i + 1
END 
set @sql = left(@sql, len(@sql) - 1) + ') as [' + convert(varchar(4), (select max(Year) from tblMonthList)) + 'YTDUS], '

-- last Year YTD 
set @i = 0 --  
set @sql = @sql + ' ('
while @i < @YTDNum  
BEGIN
    set @Mth = ( select Date from tblMonthList where MonSeq = @i + 1 + 12 )
    set @sql = @sql + ' sum([' + @Mth + ' Dosage Unit]) + '
    set @i = @i + 1
END 
set @sql = left(@sql, len(@sql) - 1) + ') as [' + convert(varchar(4), (select max(Year) - 1 from tblMonthList)) + 'YTDUS]， '

-- last 2 Year YTD 
set @i = 0  --  
set @sql = @sql + ' ('
while @i < @YTDNum  
BEGIN
    set @Mth = ( select Date from tblMonthList where MonSeq = @i + 1 + 24 )
    set @sql = @sql + ' sum([' + @Mth + ' Dosage Unit]) + '
    set @i = @i + 1
END 
set @sql = left(@sql, len(@sql) - 1) + ') as [' + convert(varchar(4), (select max(Year) - 2 from tblMonthList)) + 'YTDUS] '

set @sql = @sql + ' 
into MAXData_Rollup_CityProdMth
from dbo.Max_Data as a 
inner join dbo.MaxCity as b on replace(a.city, N''市'', '''' ) = b.city
group by a.City, Prod_cod, Prod_Des, a.Province,Mole_cod, Mole_des, Pack_Cod, Pack_des '
print @sql 
exec(@sql) 

go 


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'MAXData_Rollup_ProvProd_ARV') and type='U')
BEGIN
	DROP TABLE MAXData_Rollup_ProvProd_ARV
END
go


declare @MthNum int , @QtrNum int
declare @Mth varchar(10) , @sql varchar(8000);

set @MthNum = (
    select MonSeq 
    from dbo.tblMonthList
    where year = '2014' and Month = '1'
)
set @QtrNum = (
    select QtrSeq  
    from dbo.tblMonthList
    where year = '2014' and Month = '1'
)


set @sql = 'SELECT a.Province, a.Prod_cod, a.Prod_Des, 
 '

-- month 
declare @i int , @j int , @k int
set @i = 0   -- 
while @i < @MthNum  
BEGIN
    set @Mth = ( select Date from tblMonthList where MonSeq = @i + 1 )
    set @sql = @sql + 'sum([' + @Mth +'US]) as [' + @Mth +'US] , '
    set @i = @i + 1
END 

--print @sql 
print @QtrNum 

-- quarter 
set @i = 0  --  
while @i < @QtrNum 
begin  
    set @j = ( select count(*) from tblMonthList where QtrSeq = @i + 1 )
    set @Mth = (select distinct (convert(varchar(4), Year) + Quarter) from tblMonthList where QtrSeq = @i + 1)
    set @sql = @sql + 'sum([' + @Mth +'US]) as [' + @Mth +'US] , '
    set @i = @i + 1
end 

set @sql = @sql + 'sum([' + convert(varchar(4), (select max(Year) from tblMonthList)) + 'YTDUS]) as [' + convert(varchar(4), (select max(Year) from tblMonthList)) + 'YTDUS], '
set @sql = @sql + 'sum([' + convert(varchar(4), (select max(Year) - 1 from tblMonthList)) + 'YTDUS]) as [' + convert(varchar(4), (select max(Year) - 1 from tblMonthList)) + 'YTDUS], '
set @sql = @sql + 'sum([' + convert(varchar(4), (select max(Year) - 2 from tblMonthList)) + 'YTDUS]) as [' + convert(varchar(4), (select max(Year) - 2 from tblMonthList)) + 'YTDUS] '
set @sql = @sql + '
into MAXData_Rollup_ProvProd_ARV
from MAXData_Rollup_CityProdMth as a 
inner join tblMktDef_Inline_MAX as b on a.Mole_cod = b.Mole_cod
	and a.Prod_cod = b.Prod_cod and a.Pack_Cod = b.Pack_Cod 
inner join MaxCity as c on replace(a.city, N''市'', '''' ) = c.city     
group by a.Province, a.Prod_Des, a.Prod_cod '
print @sql 
exec(@sql) 

go 

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_MAX_Province_Mid') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MAX_Province_Mid
END
go

declare @Year varchar(4), @sql varchar(8000), @LastYear varchar(4), @Last2Year varchar(4)

set @Year = (select max(Year) from tblMonthList) 
set @LastYear = (select max(Year) - 1 from tblMonthList) 
set @Last2Year = (select max(Year) - 2 from tblMonthList) 

set @sql = '
select a.Province, a.Prod_cod, a.Prod_Des, [' + @Year + 'YTDUS] , [' + @LastYear + 'YTDUS] , [' + @Last2Year + 'YTDUS] 
into KPI_Frame_MAX_Province_Mid
from MAXData_Rollup_ProvProd_ARV as a '
print @sql 
exec(@sql) 


set @sql = '
insert into KPI_Frame_MAX_Province_Mid
select ''ALL'', ''00000'', ''ALL'', sum([' + @Year + 'YTDUS]) , sum([' + @LastYear + 'YTDUS]) , sum([' + @Last2Year + 'YTDUS]) 
from MAXData_Rollup_ProvProd_ARV as a 
'
print @sql 
exec(@sql) 


set @sql = '
insert into KPI_Frame_MAX_Province_Mid
select a.Province, ''00000'', ''ALL'', sum([' + @Year + 'YTDUS]) , sum([' + @LastYear + 'YTDUS]) , sum([' + @Last2Year + 'YTDUS]) 
from MAXData_Rollup_ProvProd_ARV as a 
where province <> ''ALL''
group by Province '
print @sql 
exec(@sql) 


go 


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_MAX_Province_MS_Mid') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MAX_Province_MS_Mid
END
go

select * 
into KPI_Frame_MAX_Province_MS_Mid
from KPI_Frame_MAX_Province_Mid
where Prod_Des in ('BARACLUDE', 'ALL' )


declare @Year varchar(4), @sql varchar(8000), @LastYear varchar(4), @Last2Year varchar(4)

set @Year = (select max(Year) from tblMonthList) 
set @LastYear = (select max(Year) - 1 from tblMonthList) 
set @Last2Year = (select max(Year) - 2 from tblMonthList) 



set @sql = '
update a 
set a.[' + @Year + 'YTDUS] = a.[' + @Year + 'YTDUS] / b.[' + @Year + 'YTDUS] , 
    a.[' + @LastYear + 'YTDUS] = a.[' + @LastYear + 'YTDUS] / b.[' + @LastYear + 'YTDUS],
    a.[' + @Last2Year + 'YTDUS] = a.[' + @Last2Year + 'YTDUS] / b.[' + @Last2Year + 'YTDUS]
from KPI_Frame_MAX_Province_MS_Mid as a 
    , KPI_Frame_MAX_Province_MS_Mid as b 
where a.Province <> ''ALL'' and a.Prod_cod <> ''00000''
    and b.Province <> ''ALL'' and b.Prod_cod = ''00000''
    and a.Province = b.Province ' 
print @sql 
exec(@sql) 


set @sql = '
update a 
set a.[' + @Year + 'YTDUS] = a.[' + @Year + 'YTDUS] / b.[' + @Year + 'YTDUS] , 
    a.[' + @LastYear + 'YTDUS] = a.[' + @LastYear + 'YTDUS] / b.[' + @LastYear + 'YTDUS],
    a.[' + @Last2Year + 'YTDUS] = a.[' + @Last2Year + 'YTDUS] / b.[' + @Last2Year + 'YTDUS]
from KPI_Frame_MAX_Province_MS_Mid as a 
    , KPI_Frame_MAX_Province_MS_Mid as b 
where a.Province <> ''ALL'' and a.Prod_cod = ''00000''
    and b.Province = ''ALL'''
print @sql 
exec(@sql) 


set @sql = '
update a 
set a.[' + @Year + 'YTDUS] = 1 , 
    a.[' + @LastYear + 'YTDUS] = 1,
    a.[' + @Last2Year + 'YTDUS] = 1
from KPI_Frame_MAX_Province_MS_Mid as a 
where a.Province = ''ALL'''
print @sql 
exec(@sql) 

go 


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_MAX_Province_MS') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MAX_Province_MS
END
go


declare @Year varchar(4), @sql varchar(8000), @LastYear varchar(4)

set @Year = (select max(Year) from tblMonthList) 
set @LastYear = (select max(Year) - 1 from tblMonthList) 

set @sql = 'SELECT Province as Series, Prod_Des as DataType, Y, X, null as Series_Idx, null as X_Idx 
into KPI_Frame_MAX_Province_MS
from KPI_Frame_MAX_Province_MS_Mid 
unpivot (
	Y for X in ([' + @Year + 'YTDUS], [' + @LastYear + 'YTDUS] '
set @sql = @sql + ')
) as p'
exec(@sql)

delete KPI_Frame_MAX_Province_MS
where Series = 'ALL'

insert into KPI_Frame_MAX_Province_MS
select a.Series, 'ShareChange', a.Y - b.Y , a.X, null, null 
from KPI_Frame_MAX_Province_MS as a 
    , KPI_Frame_MAX_Province_MS as b 
where a.Series = b.Series and a.Datatype = b.Datatype and a.Datatype = 'baraclude'
    and a.X = @Year + 'YTDUS' and b.X = @LastYear + 'YTDUS'

delete KPI_Frame_MAX_Province_MS
where X = @LastYear + 'YTDUS'

update a
set a.Series_Idx = b.Idx 
from KPI_Frame_MAX_Province_MS as a,
(
	select Series, row_number() over(partition by X order by Y desc ) as Idx 
	from KPI_Frame_MAX_Province_MS as a 
	where Datatype = 'ALL'
) as b 
where a.series = b.series 

update KPI_Frame_MAX_Province_MS
set X = case Datatype when 'ALL' then 'ARV Contr. of National'
                            when 'BARACLUDE' then 'Baraclude Share'
                            when 'ShareChange' then 'Baraclude Share Change (Y2Y)'
                            else '' end,
    X_Idx = case Datatype when 'ALL' then 1 
                            when 'BARACLUDE' then 2
                            when 'ShareChange' then 3
                            else 4 end

--------------------------------------------------------------------------------------------
-- MAX tblMktDef_Inline_MAX

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'tblMktDef_Inline_MAX') and type='U')
BEGIN
	DROP TABLE tblMktDef_Inline_MAX
END
go

select distinct * , 0 as Idx , convert(varchar(50), '') as mkt, convert(varchar(50), '') as MktName
into tblMktDef_Inline_MAX 
FROM (
    select  distinct ATC1_Des, ATC2_Cod, ATC2_Des, ATC3_Cod, ATC3_Des, ATC4_Cod,
        ATC4_Des, Mole_cod, Mole_des, Prod_cod, Prod_Des, Pack_Cod, Pack_Des, 
        Corp_cod, Corp_Des, manu_cod, Manu_des,
        MNC, Gene_Cod
    from dbo.Max_Data
) as a 

update tblMktDef_Inline_MAX
set Mkt = 'BARACLUDE',
	MktName = 'BARACLUDE',
    Idx = 1
where prod_Des = 'BARACLUDE'

update tblMktDef_Inline_MAX
set Mkt = 'RUN ZHONG',
	MktName = 'RUN ZHONG',
    Idx = 2
where prod_Des = 'RUN ZHONG'

update tblMktDef_Inline_MAX
set Mkt = 'OTHER ETV',
	MktName = 'OTHER ETV',
    Idx = 3
where mole_des = 'ENTECAVIR'
	and prod_Des <> 'RUN ZHONG' 
	and prod_Des <> 'BARACLUDE'

update tblMktDef_Inline_MAX
set Mkt = 'Heptodin',
	MktName = 'Heptodin',
    Idx = 4
where prod_Des = 'Heptodin'

update tblMktDef_Inline_MAX
set Mkt = 'SEBIVO',
	MktName = 'SEBIVO',
    Idx = 5
where prod_Des = 'SEBIVO'


update tblMktDef_Inline_MAX
set Mkt = 'Viread',
	MktName = 'Viread',
    Idx = 6
where prod_Des = 'Viread'

update tblMktDef_Inline_MAX
set Mkt = 'Others',
	MktName = 'Others',
    Idx = 7
where prod_Des <> 'Viread'
	and prod_Des <> 'SEBIVO'
	and prod_Des <> 'Heptodin'
	and prod_Des <> 'BARACLUDE'
	and prod_Des <> 'RUN ZHONG'
	and mole_des <> 'ENTECAVIR'


go 
 

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'tblMaxCity_KeyCity') and type='U')
BEGIN
	DROP TABLE tblMaxCity_KeyCity
END
go

select * , 1 as Idx 
into tblMaxCity_KeyCity 
from MaxCity
where City in (N'北京' )

insert into tblMaxCity_KeyCity 
select * , 2 as Idx from MaxCity where City in (N'上海')

insert into tblMaxCity_KeyCity 
select * , 3 as Idx from MaxCity where City in (N'广州')

insert into tblMaxCity_KeyCity 
select * , 4 as Idx from MaxCity where City in (N'杭州')

insert into tblMaxCity_KeyCity 
select * , 5 as Idx from MaxCity where City in (N'武汉')

insert into tblMaxCity_KeyCity 
select * , 6 as Idx from MaxCity where City in (N'成都')

insert into tblMaxCity_KeyCity 
select * , 7 as Idx from MaxCity where City in (N'深圳')

insert into tblMaxCity_KeyCity 
select * , 8 as Idx from MaxCity where City in (N'南京')

insert into tblMaxCity_KeyCity 
select * , 9 as Idx from MaxCity where City in (N'重庆')

insert into tblMaxCity_KeyCity 
select * ,10 as Idx from MaxCity where City in (N'西安')

GO

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'MAXData_Rollup_KeyCity_MAXMkt_Mid') and type='U')
BEGIN
	DROP TABLE MAXData_Rollup_KeyCity_MAXMkt_Mid
END
go


declare @MthNum int , @QtrNum int
declare @Mth varchar(10) , @sql varchar(8000);

set @MthNum = (
    select MonSeq 
    from dbo.tblMonthList
    where year = '2015' and Month = '1'
)
set @QtrNum = (
    select QtrSeq  
    from dbo.tblMonthList
    where year = '2015' and Month = '1'
)


set @sql = 'SELECT a.City, b.Mkt, 
 '

set @sql = @sql + 'sum([' + convert(varchar(4), (select max(Year) from tblMonthList)) + 'YTDUS]) as [' + convert(varchar(4), (select max(Year) from tblMonthList)) + 'YTDUS] '
set @sql = @sql + '
into MAXData_Rollup_KeyCity_MAXMkt_Mid
from MAXData_Rollup_CityProdMth as a 
inner join (
    select distinct Mole_cod, Prod_cod, Pack_Cod, Mkt
	from tblMktDef_Inline_MAX 
) as b on a.Mole_cod = b.Mole_cod
	and a.Prod_cod = b.Prod_cod and a.Pack_Cod = b.Pack_Cod 
inner join tblMaxCity_KeyCity as c on replace(a.city, N''市'', '''' ) = c.city    
group by a.City, b.Mkt '
print @sql 
exec(@sql) 

go 


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'MAXData_Rollup_KeyCity_AllMkt_Mid') and type='U')
BEGIN
	DROP TABLE MAXData_Rollup_KeyCity_AllMkt_Mid
END
go


declare @Year varchar(4), @sql varchar(8000)
set @Year = ( select Year from tblMonthList where MonSeq = 1 )

set @sql = '
select City , sum([' + convert(varchar(4), @Year) + 'YTDUS]) as YTDUS 
into MAXData_Rollup_KeyCity_AllMkt_Mid
from MAXData_Rollup_KeyCity_MAXMkt_Mid
group by City
'
exec(@sql)



IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_MAX_KeyCity_MS') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MAX_KeyCity_MS
END
go

declare @Year varchar(4), @sql varchar(8000)
set @Year = ( select Year from tblMonthList where MonSeq = 1 )

set @sql = '
select City as Series, Mkt as X, [' + convert(varchar(4), @Year) + 'YTDUS] as Y,  null as Series_Idx, null as X_Idx 
into KPI_Frame_MAX_KeyCity_MS
from MAXData_Rollup_KeyCity_MAXMkt_Mid
'
print @sql 
exec(@sql)


update a 
set Y = a.Y / b.YTDUS
from KPI_Frame_MAX_KeyCity_MS as a 
inner join MAXData_Rollup_KeyCity_AllMkt_Mid as b on a.Series = b.City 


update a 
set Series_Idx = b.Idx 
from KPI_Frame_MAX_KeyCity_MS as a 
inner join tblMaxCity_KeyCity as b on a.Series = b.City

update a 
set X_Idx = b.Idx
from KPI_Frame_MAX_KeyCity_MS as a 
inner join tblMktDef_Inline_MAX as b on a.X = b.Mkt 

---------------------------------------------------------------------------------
--MAX region 

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'MAXData_Rollup_Region_MAXMkt_Mid') and type='U')
BEGIN
	DROP TABLE MAXData_Rollup_Region_MAXMkt_Mid
END
go


declare @MthNum int , @QtrNum int
declare @Mth varchar(10) , @sql varchar(8000);

set @MthNum = (
    select MonSeq 
    from dbo.tblMonthList
    where year = '2015' and Month = '1'
)
set @QtrNum = (
    select QtrSeq  
    from dbo.tblMonthList
    where year = '2015' and Month = '1'
)


set @sql = 'SELECT c.Region, b.Mkt, 
 '

-- todo 
set @sql = @sql + 'sum([' + convert(varchar(4), (select max(Year) from tblMonthList)) + 'YTDUS]) as [' + convert(varchar(4), (select max(Year) from tblMonthList)) + 'YTDUS], '
set @sql = @sql + 'sum([' + convert(varchar(4), (select max(Year) - 1 from tblMonthList)) + 'YTDUS]) as [' + convert(varchar(4), (select max(Year) - 1 from tblMonthList)) + 'YTDUS], '
set @sql = @sql + 'sum([' + convert(varchar(6), (select Date from tblMonthList where MonSeq = 1)) + 'US]) as [Mth00YTDUS], '
set @sql = @sql + 'sum([' + convert(varchar(6), (select Date from tblMonthList where MonSeq = 2)) + 'US]) as [Mth01YTDUS] '
set @sql = @sql + '
into MAXData_Rollup_Region_MAXMkt_Mid
from MAXData_Rollup_CityProdMth as a 
inner join (
    select distinct Mole_cod, Prod_cod, Pack_Cod, Mkt
	from tblMktDef_Inline_MAX 
)  as b on a.Mole_cod = b.Mole_cod
	and a.Prod_cod = b.Prod_cod and a.Pack_Cod = b.Pack_Cod 
inner join MAXRegionCity as c on replace(a.city, N''市'', '''' ) = c.city    and c.type = ''Dashboard''
group by c.Region, b.Mkt '
print @sql 
exec(@sql) 

go 

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'MAXData_Rollup_Region_All_Mid') and type='U')
BEGIN
	DROP TABLE MAXData_Rollup_Region_All_Mid
END
go


declare @Year varchar(4), @sql varchar(8000), @LastYear varchar(4)
set @Year = ( select Year from tblMonthList where MonSeq = 1 )
set @LastYear = ( select Year - 1 from tblMonthList where MonSeq = 1 )

set @sql = '
select Region, 
    sum([' + convert(varchar(4), @Year) + 'YTDUS]) as YTDUS,
    sum([' + convert(varchar(4), @LastYear) + 'YTDUS]) as LastYTDUS,
    sum([Mth00YTDUS]) as [Mth00YTDUS],
    sum([Mth01YTDUS]) as [Mth01YTDUS]
into MAXData_Rollup_Region_All_Mid
from MAXData_Rollup_Region_MAXMkt_Mid
group by Region 
'
print @sql 
exec(@sql)

go 


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_MAX_Region_MS') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MAX_Region_MS
END
go


declare @Year varchar(4), @sql varchar(8000)
set @Year = ( select Year from tblMonthList where MonSeq = 1 )

set @sql = '
select Region as Series, Mkt as X, [' + convert(varchar(4), @Year) + 'YTDUS] as Y,  null as Series_Idx, null as X_Idx 
into KPI_Frame_MAX_Region_MS
from MAXData_Rollup_Region_MAXMkt_Mid
'
print @sql 
exec(@sql)


update a 
set Y = a.Y / b.YTDUS
from KPI_Frame_MAX_Region_MS as a 
inner join MAXData_Rollup_Region_All_Mid as b on a.Series = b.Region 


update a 
set Series_Idx = b.Idx 
from KPI_Frame_MAX_Region_MS as a 
inner join MAXRegionCity as b on a.Series = b.Region and b.type = 'Dashboard'

update a 
set X_Idx = b.Idx
from KPI_Frame_MAX_Region_MS as a 
inner join tblMktDef_Inline_MAX as b on a.X = b.Mkt 

-----------------------------------------------------------
-- BAL Hospital 


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'temp_BAL_CPAData') and type='U')
BEGIN
	DROP TABLE temp_BAL_CPAData
END
go

-- tblBALHospital may need to update manually

declare @Year varchar(4), @sql varchar(8000), @LastYear varchar(4)
set @Year = ( select Year from tblMonthList where MonSeq = 1 )
set @LastYear = ( select Year - 1 from tblMonthList where MonSeq = 1 )


select a.HospitalCode, a.HospitalName, a.RMName, b.*
into temp_BAL_CPAData
from ( 
	SELECT b.HospitalCode, b.HospitalName, b.RMName, a.[CPA Code] as CPA_Code, a.[City(Chinese)] as City, a.Povince
	from BMSChinaMRBI.dbo.BMS_CPA_Hosp_Category as a
	inner join tblBALHospital as b on a.[BMS Code] = b.HospitalCode
) as a 
inner join BMSChinaMRBI.dbo.inCPAData as b on a.CPA_Code = b.CPA_Code
where a.CPA_Code <>'#N/A'
	and b.Y >= '2015' and b.M >= 1


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_MAX_Region_BAL_Mid') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MAX_Region_BAL_Mid
END
go


declare @Year varchar(4), @sql varchar(8000), @LastYear varchar(4)
set @Year = ( select Year from tblMonthList where MonSeq = 1 )

select RMName as Series, sum(Value) as Y 
into KPI_Frame_MAX_Region_BAL_Mid
from temp_BAL_CPAData as a
inner join (
        SELECT distinct Prod_Des_CN, Prod_Des_EN  FROM BMSChinaMRBI.dbo.tblMktDefHospital where Mkt = 'Arv' 
    ) as b on a.Product = b.Prod_Des_CN
-- inner join (
--     select distinct prod_Des
-- 	from tblMktDef_Inline 
-- )  as c on b.prod_Des_EN = c.prod_Des 
where Y >= @Year and M >= 1
group by RMName 

go

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_MAX_Region_BAL') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MAX_Region_BAL
END
go

declare @Year varchar(4), @sql varchar(8000), @LastYear varchar(4)
set @Year = ( select Year from tblMonthList where MonSeq = 1 )
set @LastYear = ( select Year - 1 from tblMonthList where MonSeq = 1 )

select RMName as Series, c.mkt as X , sum(Value) as Y, null as Series_Idx, null as X_Idx 
into KPI_Frame_MAX_Region_BAL
from temp_BAL_CPAData as a
inner join (
        select distinct prod_Des_EN,Prod_Des_CN  from BMSChinaMRBI.dbo.tblMktDefHospital where Mkt = 'Arv' 
    ) as b on a.Product = b.Prod_Des_CN
inner join ( 
        select distinct prod_Des, mkt
        from tblMktDef_Inline_MAX 
    ) as c on b.prod_Des_EN = c.prod_Des 
where Y >= @Year and M >= 1
group by RMName , c.Mkt

update a
set Series_Idx = 
    case Series when 'VIR BAM II' then 1
    when 'VIR BAM III' then 2
    when 'VIR BAM IV' then 3
    when 'VIR BAM V' then 4
    else 5
    end
    , X_Idx = b.Idx 
from KPI_Frame_MAX_Region_BAL as a
inner join dbo.tblMktDef_Inline_MAX as b on a.X = b.Mkt

update a 
set a.Y = a.Y / b.Y 
from KPI_Frame_MAX_Region_BAL as a 
inner join KPI_Frame_MAX_Region_BAL_Mid as b on a.Series = b.Series 

insert into KPI_Frame_MAX_Region_MS
select * 
from KPI_Frame_MAX_Region_BAL

---------------------------------------------------------------
--- KPI_Frame_MAX_Region_Baraclude

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'temp_KPI_Frame_MAX_Region_BAL') and type='U')
BEGIN
	DROP TABLE temp_KPI_Frame_MAX_Region_BAL
END
go

declare @Year varchar(4), @sql varchar(8000), @LastYear varchar(4), @currMth varchar(2), @YTDMth varchar(2), @LastMth varchar(2)
set @Year = ( select Year from tblMonthList where MonSeq = 1 )
set @LastYear = ( select Year - 1 from tblMonthList where MonSeq = 1 )
set @currMth = ( select Month from tblMonthList where MonSeq = 1 )
set @LastMth = ( select Month from tblMonthList where MonSeq = 2 )
set @YTDMth = ( select Month from tblMonthList where MonSeq = 13 )


-- BaracludeYTDShr 
SELECT a.BaracludeYTD / a.YTD 
from temp_KPI_Frame_MAX_Region_BAL as a 

select RMName as Series, sum(Value) as YTD 
into temp_KPI_Frame_MAX_Region_BAL
from temp_BAL_CPAData as a
inner join (
    select distinct prod_Des_EN,Prod_Des_CN  from BMSChinaMRBI.dbo.tblMktDefHospital  where Mkt = 'Arv' 
) as b on a.Product = b.Prod_Des_CN
left join (
    select distinct prod_Des
	from tblMktDef_Inline_MAX 
) as c on b.prod_Des_EN = c.prod_Des 
where Y >= @Year and M >= 1 
group by RMName 

alter table temp_KPI_Frame_MAX_Region_BAL 
add LastYearYTD float,
    BaracludeYTD float,
    BaracludeLastYearYTD float,
    BaracludeMth00 float,
    BaracludeMth01 float,
    BaracludeYTDShr float,
    BaracludeLastYearYTDShr float ,
    Mth00 float,
    Mth01 float 

-- last YTD 
update a 
set LastYearYTD = b.YTD
from temp_KPI_Frame_MAX_Region_BAL as a 
inner join (
    select RMName as Series, sum(Value) as YTD 
    from temp_BAL_CPAData as a
    inner join (
        select distinct prod_Des_EN,Prod_Des_CN  from BMSChinaMRBI.dbo.tblMktDefHospital  where Mkt = 'Arv' 
    ) as b on a.Product = b.Prod_Des_CN
    left join (
        select distinct prod_Des
        from tblMktDef_Inline_MAX 
    ) as c on b.prod_Des_EN = c.prod_Des 
    where Y >= @LastYear and M >= 1 and Y < @Year and M <= @currMth
    group by RMName 
) as b on a.Series = b.Series 

-- baracludeLastYearYTD
update a 
set BaracludeLastYearYTD = b.YTD
from temp_KPI_Frame_MAX_Region_BAL as a 
inner join (
    select RMName as Series, sum(Value) as YTD 
    from temp_BAL_CPAData as a
    inner join (
        select distinct prod_Des_EN,Prod_Des_CN  from BMSChinaMRBI.dbo.tblMktDefHospital  where Mkt = 'Arv' 
    ) as b on a.Product = b.Prod_Des_CN
    left join (
        select distinct prod_Des
        from tblMktDef_Inline_MAX 
    ) as c on b.prod_Des_EN = c.prod_Des 
    where Y >= @LastYear and M >= 1 and Y < @Year and M <= @currMth
        and c.Prod_Des = 'Baraclude'
    group by RMName 
) as b on a.Series = b.Series 


-- baracludeYTD
update a 
set BaracludeYTD = b.YTD
from temp_KPI_Frame_MAX_Region_BAL as a 
inner join (
    select RMName as Series, sum(Value) as YTD 
    from temp_BAL_CPAData as a
    inner join (
        select distinct prod_Des_EN,Prod_Des_CN  from BMSChinaMRBI.dbo.tblMktDefHospital  where Mkt = 'Arv' 
    ) as b on a.Product = b.Prod_Des_CN
    left join (
        select distinct prod_Des
        from tblMktDef_Inline_MAX 
    ) as c on b.prod_Des_EN = c.prod_Des 
    where  M >= 1 and Y >= @Year and M <= @currMth
        and c.Prod_Des = 'Baraclude'
    group by RMName 
) as b on a.Series = b.Series 

-- BaracludeMth00 
update a 
set BaracludeMth00 = b.YTD
from temp_KPI_Frame_MAX_Region_BAL as a 
inner join (
    select RMName as Series, sum(Value) as YTD 
    from temp_BAL_CPAData as a
    inner join (
        select distinct prod_Des_EN,Prod_Des_CN  from BMSChinaMRBI.dbo.tblMktDefHospital  where Mkt = 'Arv' 
    ) as b on a.Product = b.Prod_Des_CN
    left join (
        select distinct prod_Des
        from tblMktDef_Inline_MAX 
    ) as c on b.prod_Des_EN = c.prod_Des 
    where  M = @currMth and Y = @Year 
        and c.Prod_Des = 'Baraclude'
    group by RMName 
) as b on a.Series = b.Series 

-- BaracludeMth01
update a 
set BaracludeMth01 = b.YTD
from temp_KPI_Frame_MAX_Region_BAL as a 
inner join (
    select RMName as Series, sum(Value) as YTD 
    from temp_BAL_CPAData as a
    inner join (
        select distinct prod_Des_EN,Prod_Des_CN  from BMSChinaMRBI.dbo.tblMktDefHospital  where Mkt = 'Arv' 
    ) as b on a.Product = b.Prod_Des_CN
    left join (
        select distinct prod_Des
        from tblMktDef_Inline_MAX 
    ) as c on b.prod_Des_EN = c.prod_Des 
    where  M = @LastMth and Y = YEAR(DATEADD(MONTH, -1, CONVERT(DATETIME, @Year + '0101')))
        and c.Prod_Des = 'Baraclude'
    group by RMName 
) as b on a.Series = b.Series 

-- BaracludeYTDShr 
update a 
set BaracludeYTDShr = a.BaracludeYTD / a.YTD 
from temp_KPI_Frame_MAX_Region_BAL as a 

-- BaracludeLastYearYTDShr  
update a 
set BaracludeLastYearYTDShr = a.BaracludeLastYearYTD / a.LastYearYTD 
from temp_KPI_Frame_MAX_Region_BAL as a 

--Mth00 float
update a 
set Mth00 = b.YTD
from temp_KPI_Frame_MAX_Region_BAL as a 
inner join (
    select RMName as Series, sum(Value) as YTD 
    from temp_BAL_CPAData as a
    inner join (
        select distinct prod_Des_EN,Prod_Des_CN  from BMSChinaMRBI.dbo.tblMktDefHospital  where Mkt = 'Arv' 
    ) as b on a.Product = b.Prod_Des_CN
    inner join (
        select distinct prod_Des
        from tblMktDef_Inline_MAX 
    ) as c on b.prod_Des_EN = c.prod_Des 
    where  M = @currMth and Y = @Year
    group by RMName 
) as b on a.Series = b.Series 

--Mth01 float 
update a 
set Mth01 = b.YTD
from temp_KPI_Frame_MAX_Region_BAL as a 
inner join (
    select RMName as Series, sum(Value) as YTD 
    from temp_BAL_CPAData as a
    inner join (
        select distinct prod_Des_EN,Prod_Des_CN  from BMSChinaMRBI.dbo.tblMktDefHospital  where Mkt = 'Arv' 
    ) as b on a.Product = b.Prod_Des_CN
    inner join (
        select distinct prod_Des
        from tblMktDef_Inline_MAX 
    ) as c on b.prod_Des_EN = c.prod_Des 
    where  M = @LastMth and Y = YEAR(DATEADD(MONTH, -1, CONVERT(DATETIME, @Year + '0101')))
    group by RMName 
) as b on a.Series = b.Series 

go 

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_MAX_Region_Baraclude') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MAX_Region_Baraclude
END
go

select series, X, Y , null as Series_Idx, null as X_Idx 
into KPI_Frame_MAX_Region_Baraclude
from (
	SELECT series, 
		(BaracludeMth00/Mth00 - BaracludeMth01/Mth01) as 'Baraclude Month Share Change vs. Last Mth',
		(BaracludeYTD/YTD - BaracludeLastYearYTD/LastYearYTD) as 'Baraclude YTD share Change(Y2Y)',
		(BaracludeYTD / BaracludeLastYearYTD) - 1 as 'Baraclude YTD Growth(Y2Y)',
		(YTD / LastYearYTD) - 1 as 'Market YTD Growth(Y2Y)'
	from temp_KPI_Frame_MAX_Region_BAL 
) as a 
unpivot (
	Y for X in (
		[Baraclude Month Share Change vs. Last Mth],
		[Baraclude YTD share Change(Y2Y)],
		[Baraclude YTD Growth(Y2Y)],
		[Market YTD Growth(Y2Y)]
	)
) as p

declare @Year varchar(4), @sql varchar(8000), @LastYear varchar(4), @currMth varchar(2), @YTDMth varchar(2)
set @Year = ( select Year from tblMonthList where MonSeq = 1 )
set @LastYear = ( select Year - 1 from tblMonthList where MonSeq = 1 )

set @sql = '
insert into KPI_Frame_MAX_Region_Baraclude
select series, X, Y , null as Series_Idx, null as X_Idx  
from 
(
    SELECT a.Region as Series ,
        a.[Mth00YTDUS]/b.Mth00YTDUS - a.Mth01YTDUS/b.Mth01YTDUS as ''Baraclude Month Share Change vs. Last Mth'',
        a.[' + @Year + 'YTDUS]/b.YTDUS - a.[' + @LastYear + 'YTDUS]/b.LastYTDUS as ''Baraclude YTD share Change(Y2Y)'',
        (a.[' + @Year + 'YTDUS] / a.[' + @LastYear + 'YTDUS]) - 1 as ''Baraclude YTD Growth(Y2Y)'',
        (b.YTDUS / b.LastYTDUS) - 1 as ''Market YTD Growth(Y2Y)''
    from MAXData_Rollup_Region_MAXMkt_Mid as a
    inner join MAXData_Rollup_Region_All_Mid as b on a.Region = b.Region
    where a.mkt = ''BARACLUDE''
) as a 
unpivot (
	Y for X in (
		[Baraclude Month Share Change vs. Last Mth],
		[Baraclude YTD share Change(Y2Y)],
		[Baraclude YTD Growth(Y2Y)],
		[Market YTD Growth(Y2Y)]
	)
) as p
'
print @sql 
exec(@sql)

update a 
set Series_Idx = 
        case Series when 'VIR BAM II' then 1
                    when 'VIR BAM III' then 2
                    when 'VIR BAM IV' then 3
                    when 'VIR BAM V' then 4
                    when 'North' then 5
                    when 'North East' then 6
                    when 'Central' then 7
                    when 'West' then 8
                    when 'East I' then 9
                    when 'East II' then 10
                    when 'South' then 11
                    else 12 end 
        ,
    X_Idx = case X when 'Baraclude Month Share Change vs. Last Mth' then 1
                    when 'Baraclude YTD share Change(Y2Y)' then 2
                    when 'Baraclude YTD Growth(Y2Y)' then 3
                    when 'Market YTD Growth(Y2Y)' then 4
                    else 5 end 
from KPI_Frame_MAX_Region_Baraclude as a 


update KPI_Frame_MAX_Region_Baraclude 
set series = X,
	X = series,
	series_Idx = X_Idx,
	X_Idx = series_Idx 


-------------------------------------------------------------------------------------
--select	Category, Series, X, Series_Idx, Category_Idx, X_Idx, Y
--from	KPI_Frame_MarketAnalyzer_IMSAudit_CHPA
--where	market = 'Monopril'
--		and lev = 'FocusCity'
--		and DataType = 'Growth'
--order by Category_Idx, Series_Idx, X_Idx

--SELECT * FROM TempCityDashboard_For_Eliquis_NOAC 
--select * from inCV_Focus_City 

--select --a.City_Code,a.City_Name,a.City_Name_CH 
--	c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype,'FocusCity' as Audi_des,
--	sum(MTH00) AS MTH00, sum(MTH01) as MTH01,sum(MTH02) as MTH02,sum(MTH03) as MTH03,sum(MTH04) as MTH04,sum(MTH05) as MTH05,
--	sum(MTH06) AS MTH06, sum(MTH07) as MTH07,sum(MTH08) as MTH08,sum(MTH09) as MTH09,sum(MTH10) as MTH10,sum(MTH11) as MTH11, sum(MTH12) as MTH12,
--	sum(YTD00) as YTD00,sum(YTD12) as YTD12,sum(MAT00) AS MAT00,sum(MAT12) AS MAT12,sum(R3M00) AS R3M00,sum(R3M03) AS R3M03,sum(r3m12) as r3m12
--from dim_city a 
--join inCV_Focus_City b 
--on a.city_name_ch=b.city_cn
--join TempCityDashboard_For_Eliquis c on a.city_code+'_'=c.Audi_Cod and c.market=b.product
--group by c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype

----SELECT * FROM BMSChinaCIARawdata.dbo.Dim_City_201612
--SELECT * FROM dbo.Dim_City
--SELECT * FROM TempCityDashboard_For_Eliquis 
--SELECT * into MTHCITY_MAX FROM db82.BMSCNProc2.dbo.MTHCITY_MAX

--select * 
--from inmaxdata A inner join tblMktDef_MRBIChina_For_Eliquis B
--on A.pack_cod=B.pack_cod 
--where B.Active='Y' and  b.prod<>'000' and b.ProductName <>'Pradaxa'
--		SELECT * FROM tblMoneyType 
--SELECT * into tblMoneyType_201612 FROM tblMoneyType 		
--delete dbo.tblMoneyType where Type = 'PN'
--select cast('PRDL' as varchar(10)) as DataSource,'MTH' as [TimeFrame],cast('US' as varchar(5)) as MoneyType,
--	'N' as molecule,'N' as Class,'NIAD' as Mkt,'NIAD Market' as MktName,'Glucophage' as market,convert(varchar(5),'300') as Prod,
--	convert(varchar(30),'Byetta') as Series,cast('Sales' as Varchar(20)) as DataType,cast('Value' as varchar(20)) as Category, 
--	1 as [Series_Idx],
--	sum(MTH00US) as MTH00,
--	sum(MTH01US) as MTH01,
--	sum(MTH02US) as MTH02,
--	sum(MTH03US) as MTH03,
--	sum(MTH04US) as MTH04,
--	sum(MTH05US) as MTH05,
--	sum(MTH06US) as MTH06,
--	sum(MTH07US) as MTH07,
--	sum(MTH08US) as MTH08,
--	sum(MTH09US) as MTH09,
--	sum(MTH10US) as MTH10,
--	sum(MTH11US) as MTH11
----into TempPRDLProvince 
--from MTHCITY_MAX 
--where pack_cod in( 
--	select distinct pack_cod from tblMktDef_MRBIChina where Prod_Name in ('Byetta') and Molecule='N' and class='N'
--	and Mkt='NIAD') and city in
--	(select city from dbo.Dim_City where City_Name in
--	(select City_En from dbo.PRDL_Province_City_Mapping))
--go
--alter table Dim_City
--alter column city_name_CH nvarchar(20)

--select City_ID, City_Code, City_Name, '' as city_name_CH, null as Tier 
--into Dim_City 
--from BMSChinaCIARawdata.dbo.Dim_City_201612
--SELECT * FROM TempCHPAPreReports_For_Baraclude
--SELECT * FROM ByettaMarket_TempCityDashboard 
--SELECT * FROM TempCHPAPreReports_For_Baraclude 
--SELECT * FROM KPI_Frame_MarketAnalyzer_IMSAudit_CHPA 
--SELECT * FROM KPI_Frame_MNC_Company_Ranking 
--select * from dbo.tblMonthList
--SELECT * into tblmonthlist_20170321_2 FROM tblmonthlist
--SELECT * into tblmonthlist FROM tblMonthList_20170321
--select * from KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity 
--SELECT * FROM TempCityDashboard_For_KPI_FRAME 
--select * from tempCityDashboard_AllCity
--SELECT * FROM TempCityDashboard 
--SELECT * FROM dbo.Dim_City
--SELECT * FROM mthcity_pkau 
--select * from KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity 
--SELECT * FROM KPI_Frame_MarketAnalyzer_IMSAudit_CHPA 

--update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_HCV 
--set DataType = 'value'
--where DataType = 'volume'

--SELECT * FROM KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_HCV 
--SELECT * FROM dbo.tblMaxCity_KeyCity
--SELECT * FROM KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity


--alter table KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_HCV
--alter column Y decimal(26, 12)


--update dbo.Dim_City
--set City_Code = replace(City_Code, '"', ''),
--	City_Name = replace(City_Name, '"', '')

--update dbo.Dim_City
--set city_name_CH = b.City_CN
--from Dim_City as a
--inner join dbo.tblcitymax as b on a.City_Name = b.City

