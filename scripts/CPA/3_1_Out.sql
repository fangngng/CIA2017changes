/* 

修改人  ： Aric
修改时间： 2013/5/15 15:26:42

说    明：
          这个脚本生成大部分Dashboar/Brand Report中的输出表的数据 

*/



use BMSChinaMRBI
go

--Time:23:22
--1:30:28





--log
exec dbo.sp_Log_Event 'Output','CIA_CPA','3_1_Out.sql','Start',null,null
go

--backup
declare @lmth varchar(6),@sql varchar(max)
select @lmth=convert(varchar(6),dateadd(m,-1,convert(datetime,value1+'01',112)),112) from tblDsdates where item = 'cpa'
set @sql = '
if object_id(N''BMSChinaMRBI_Repository..OutputHospital_All_' + @lMth + ''',N''U'') is null
	select * into BMSChinaMRBI_Repository..OutputHospital_All_' + @lMth + ' from OutputHospital_All
'
exec (@sql)
go

--清除历史数据
truncate table OutputHospital_All
GO





/**************************************************************************************************************
                                 1.1       Output for Nation Dashboard
**************************************************************************************************************/

--log
insert into Logs 
select 'CPA' as 项目,'Output for Nation Dashboard' as 处理内容,'start' as 标示,getdate() as 时间 
go

--C202: Tier III Hospital's Sprycel Market Trend
insert into OutputHospital_All(LinkChartCode, Series, SeriesIdx, Category, Product, Lev, Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
   'C202' AS LinkChartCode   -- LinkChartCode
   ,a.Series                 -- Series       
   ,a.SeriesIdx              -- SeriesIdx    
   ,c.Category               -- Category     
   ,'CML' as Product         -- Product      
   ,'Nation' as Lev          -- Lev          
   ,'China' as Geo           -- Geo          
   ,c.Currency               -- Currency     
   ,'MAT Month'              -- TimeFrame    
   ,b.X                      -- X            
   ,b.Xidx                   -- XIdx         
   ,null                     -- Y             
   ,'Y'                      -- IsShow       
from 
  (
    select distinct Prod as SeriesIdx,ProductName as Series
    from tblMktDefHospital
    where Mkt = 'CML' and Molecule = 'Y'
    union all
    select '999' as SeriesIdx, 'Sprycel Market Growth' as Series
  ) a, 
  (
    select [Value1] as X, 1 as XIdx from tblDsDates where Item = 'CPA' 
    union all
    select convert(varchar(6),dateadd(m,-12,convert(datetime,[Value1]+'01',112)),112) as X
           , 2 as XIdx 
    from tblDsDates where Item = 'CPA' 
    union all
    select convert(varchar(6),dateadd(m,-24,convert(datetime,[Value1]+'01',112)),112) as X
           , 3 as XIdx 
    from tblDsDates where Item = 'CPA'  
  ) b, 
  (
    select 'Value' as Category, 'RMB' as Currency 
    union all
    select 'Volume' as Category,'UNIT' as Currency 
  ) c
go
declare @i int, @sql varchar(800)
set @i= 1
while @i <= 3
  begin
  set @sql = '
  update OutputHospital_All 
  set Y = 
  	case a.category when ''Value'' then VMat' + cast(@i as varchar) + '
                    when ''Volume'' then UMat' + cast(@i as varchar) + ' 
    end
  from OutputHospital_All a
  inner join tempHospitalRollupByTier b 
  on b.Tier = ''3'' and a.Product = b.Mkt and a.SeriesIdx = cast(b.Prod as int)
  where a.LinkChartCode = ''C202'' and a.XIdx = ' + cast(@i as varchar)  
  exec (@sql)
  set @i = @i + 1
  end
go
update OutputHospital_All set Y = 
	case a.category 
	when 'Value' then  case when vmat2 = 0 then null else VMat1/vmat2-1 end
	when 'Volume' then case when umat2 = 0 then null else umat1/umat2-1 end end
from OutputHospital_All a
inner join tempHospitalRollupByTier b 
on b.Tier = '3' and b.Prod = '000' and a.Product = b.Mkt and a.SeriesIdx = 999
where a.LinkChartCode = 'C202' and a.XIdx = 1
go
update OutputHospital_All set Y = 
	case a.category 
	when 'Value' then  case when vmat3 = 0 then null else VMat2/vmat3-1 end
	when 'Volume' then case when umat3 = 0 then null else umat2/umat3-1 end end
from OutputHospital_All a
inner join tempHospitalRollupByTier b 
on b.Tier = '3' and b.Prod = '000' and a.Product = b.Mkt  and a.SeriesIdx = 999
where a.LinkChartCode = 'C202' and a.XIdx = 2
go
update OutputHospital_All set 
  Product = b.Product
from OutputHospital_All a 
inner join (select distinct Product,Mkt from tblMktDefHospital) b on a.Product = b.Mkt
where a.LinkChartCode = 'C202'
go
insert into OutputHospital_All (LinkChartCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
select 
    LinkChartCode
  , Series
  , SeriesIdx
  , Category
  , Product
  , Lev
  , ParentGeo
  , Geo
  , 'USD'
  , TimeFrame
  , X
  , XIdx
  , case when SeriesIdx <> 999 then cast(Y as Float)/(select Rate from BMSChinaCIA_IMS.dbo.tblRate) else Y end
  , IsShow
from OutputHospital_All 
where LinkChartCode in ('C202') and Currency = 'RMB'
go
update OutputHospital_All 
set X = 'MAT ' + Replace(right(convert(varchar(11),convert(datetime,x +'01',112),6),6),' ','''')
where LinkChartCode ='C202'
go
-- CAGR【复合年增长率(Compound Average Growth Rate)】 calculation
insert into OutputHospital_All (LinkChartCode,  Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
select 
   a.*
  ,case when a.Category = 'Value' then b.VCAGR else b.UCAGR end as Y,'N' as isShow
from 
(
  select distinct 
    LinkChartCode
    ,'Sprycel Market CAGR' as Series
    ,1 as SeriesIdx
    ,category
    ,Product
    ,lev
    ,parentgeo
    ,geo
    ,currency
    ,timeframe
    ,'cagr' as X
    ,1 as XIdx
  from OutputHospital_All
  where LinkChartCode ='C202'
) a ,
(
  select 
  	power((vmat1/vmat3),1.0/2) as VCAGR,
  	power((umat1/umat3),1.0/2) as UCAGR
  from tempHospitalRollupByTier
  where Product = 'Sprycel' and Mkt = 'CML' and Prod = '000' and Tier = '3'
) b 
go

-- insert mat quarter data
if exists(select * from tblDsDates where Item = 'CPA' and right(Value1,2) in('03','06','09','12'))
begin
	print '--C202: duplicate mat monthly to mat quarterly'
	
	insert into OutputHospital_All (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
	select LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, 
		Lev, ParentGeo, Geo, Currency, 'MAT Quarter' as TimeFrame, X, XIdx, Y, IsShow
	from OutputHospital_All 
  where LinkChartCode in ('C202') and TimeFrame = 'MAT Month'

	update OutputHospital_All set X = 'MAT ' + Right(X,2) + case substring(X,5,3) when 'Mar' then 'Q1' when 'May' then 'Q2' when 'Jun' then 'Q2' when 'Sep' then 'Q3' when 'Dec' then 'Q4' end
	where LinkChartCode ='C202' and TimeFrame = 'MAT Quarter' and IsShow = 'Y'

	-- reverse the order of Time period
	update OutputHospital_All set XIdx = 4 - Xidx
	where LinkChartCode ='C202' and IsShow ='Y'
end 
else
begin 
	-- reverse the order of Time period
	update OutputHospital_All set XIdx = 4 - Xidx
	where LinkChartCode ='C202' and IsShow ='Y'

	print '--C202: copy mat quarterly from history'
	
	declare @lmth varchar(6),@sql varchar(max)
	select @lmth=convert(varchar(6),dateadd(m,-1,convert(datetime,value1+'01',112)),112) from tblDsdates where item = 'cpa'
	set @sql = '
	insert into OutputHospital_All (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
	select LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, 
		Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow
	from BMSChinaMRBI_Repository..OutputHospital_All_' + @lmth + ' 
	where LinkChartCode in (''C202'') and TimeFrame = ''MAT Quarter''
	'
	exec (@sql)
end
go
-- remove the DASATINIB when there is no sprycel sales
if (select sum(sales) from tempHospitalDataByMth b where b.Mkt = 'cml' and b.prod = '100') =0 
begin
	--remove the DASATINIB series because there is no sprycel sales
	delete from OutputHospital_All where LinkChartCode ='C202' and SeriesIdx = '010'
end
go

--log
insert into Logs 
select 'CPA' as 项目,'Output for Nation Dashboard' as 处理内容,'end' as 标示,getdate() as 时间 
go












/**************************************************************************************************************
                                 1.2       Output for Region Dashboard

说明：
For Onglyza, it still in NIAD market. 
So it make thing complex
**************************************************************************************************************/

--log
insert into Logs 
select 'CPA' as 项目,'Output for Region Dashboard' as 处理内容,'start' as 标示,getdate() as 时间 
go


-- D050: Region Top 10 Hospital
delete from OutputHospital_All where LinkChartCode='D050'
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
    'D050' AS LinkChartCode
  , 'D050' + cast(SeriesIdx as varchar) as LinkSeriesCode
  , a.Series
  , a.SeriesIdx
  , b.Category
  , b.Product
  , b.Lev
  , b.Geo
  , b.Currency
  , b.TimeFrame
  , b.X
  , b.Xidx
  , 0 as Y
  , 'Y'
from (
	select 'Market' Series,1 as SeriesIdx union all
	select 'BMS Product' Series,2 as SeriesIdx union all
	select 'Market Growth' Series,3 as SeriesIdx union all
	select 'BMS Product Growth' Series,4 as SeriesIdx
) a, (
  select RankSource as Category, Mkt as Product,
    Lev as Lev,Geo, RankSource as Currency, RankSource as TimeFrame,
    CPA_id as X, Rank as Xidx
  from OutputTopCPA 
  where Lev = 'Region' and Mkt in ('ARV','NIAD','HYPFCS','ONCFCS','Platinum','CCB','Eliquis VTEP') and prod = '000'
)b
go

update OutputHospital_All 
set Y = 
    case a.category 
      when 'UC3M' then UR3M1 
      when 'VC3M' then VR3M1 
      when 'PC3M' then PR3M1 
      when 'UYTD' then UYTD 
      when 'VYTD' then VYTD
      when 'PYTD' then PYTD end
from OutputHospital_All a
inner join tempHospitalDataByGeo b on b.Mkt = a.Product 
	and b.lev = a.lev and b.geo = a.geo and b.CPA_id = cast(a.x as int)
where a.LinkChartCode = 'D050' and a.SeriesIdx = 1 and b.Prod = '000'
go

update OutputHospital_All 
set Y = 
  case a.category 
  when 'UC3M' then UR3M1 
  when 'VC3M' then VR3M1 
  when 'PC3M' then PR3M1
  when 'UYTD' then UYTD 
  when 'VYTD' then VYTD
  when 'PYTD' then PYTD end
from OutputHospital_All a
inner join tempHospitalDataByGeo b on b.Mkt = a.Product 
	and b.lev = a.lev and b.geo = a.geo and b.CPA_id = cast(a.x as int)
where a.LinkChartCode = 'D050' and a.SeriesIdx = 2 and b.Prod = '100'
go

update OutputHospital_All 
set Y = 
  case a.category 
  when 'UC3M' then UC3MGrowth 
  when 'VC3M' then VC3MGrowth 
  when 'PC3M' then PC3MGrowth 
  when 'UYTD' then UYTDGrowth 
  when 'VYTD' then VYTDGrowth 
  when 'PYTD' then PYTDGrowth end
from OutputHospital_All a
inner join tempHospitalDataByGeo b on b.Mkt = a.Product 
	and b.lev = a.lev and b.geo = a.geo and b.CPA_id = cast(a.x as int)
where a.LinkChartCode = 'D050' and a.SeriesIdx = 3 and b.Prod = '000'
go

update OutputHospital_All 
set Y = 
  case a.category 
  when 'UC3M' then UC3MGrowth 
  when 'VC3M' then VC3MGrowth 
  when 'PC3M' then PC3MGrowth 
  when 'UYTD' then UYTDGrowth 
  when 'VYTD' then VYTDGrowth
  when 'PYTD' then PYTDGrowth end
from OutputHospital_All a
inner join tempHospitalDataByGeo b on b.Mkt = a.Product 
	and a.lev = b.lev and a.geo = b.geo and a.x = b.CPA_id
where a.LinkChartCode = 'D050' and a.SeriesIdx = 4 and b.Prod = '100'
go

update OutputHospital_All 
set Series=
	case Product 
	when 'HYPFCS' then 'Monopril Market' 
	when 'NIAD' then 'NIAD Market' 
	when 'ONCFCS' then 'Taxol Market' 
	when 'ARV' then 'ARV Market' 
	when 'Platinum' then 'Platinum Market' 
	when 'CCB' then 'Coniel Market'
	WHEN 'Eliquis VTEP' THEN 'Eliquis (VTEP) Market'
	else Series end
where LinkChartCode = 'D050'  and Series = 'Market'
go

update OutputHospital_All 
set Series=
	case Product 
	when 'HYPFCS' then 'Monopril' 
	when 'NIAD' then 'Glucophage' 
	when 'ONCFCS' then 'Taxol' 
	when 'ARV' then 'Baraclude' 
	when 'Platinum' then 'Paraplatin' 
	when 'CCB' then 'Coniel' 
	WHEN 'Eliquis VTEP' THEN 'Eliquis'
end
where LinkChartCode = 'D050'  and Series = 'BMS Product'
go

update OutputHospital_All 
set Series=
	case Product 
	when 'HYPFCS' then 'Monopril' 
	when 'NIAD' then 'Glucophage' 
	when 'ONCFCS' then 'Taxol' 
	when 'ARV' then 'Baraclude'
	when 'Platinum' then 'Paraplatin' 
	when 'CCB' then 'Coniel'
	WHEN 'Eliquis VTEP' THEN 'Eliquis'
	end + ' Growth'
where LinkChartCode = 'D050'  and Series = 'BMS Product Growth'
go

-- Market contribution in Region
-- BMS Product contribution in Region
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
    LinkChartCode
  , LinkSeriesCode
  , a.Series
  , a.SeriesIdx
  , a.Category
  , a.Product
  , a.Lev
  , a.Geo
  , a.Currency
  , a.TimeFrame
  , a.X
  , a.Xidx
  , a.Y
  ,'D' as IsShow
from OutputHospital_All a
where LinkChartCode = 'D050' and IsShow = 'Y' and SeriesIdx in(1,2)
go

delete from OutputHospital_All where LinkChartCode = 'D050' and Product <> 'Platinum' and category like 'P%'
GO


update OutputHospital_All set Y = 
case when UR3M1=0 or VR3M1=0 or UYTD=0 or VYTD=0 then 0 
     else cast(a.Y as float) / case a.category 
                                when 'UC3M' then UR3M1 
                                when 'VC3M' then VR3M1 

                                when 'UM' then UM1 
                                when 'VM' then VM1 

                                when 'UMAT' then UMAT1 
                                when 'VMAT' then VMAT1 
                  
                                when 'UYTD' then UYTD 
                                when 'VYTD' then VYTD

                                end
     end 
from OutputHospital_All a 
inner join (
	select 
	    Mkt, Prod, ParentGeo,Geo, 
		sum(UR3M1) UR3M1,
		sum(VR3M1) VR3M1,

    sum(UM1) UM1,
		sum(VM1) VM1,

    sum(UMAT1) UMAT1,
		sum(VMAT1) VMAT1,

		sum(UYTD) UYTD,
		sum(VYTD) VYTD

	from tempHospitalDataByGeo
	where lev  = 'Region' and Mkt in ('ARV','NIAD','HYPFCS','ONCFCS','CCB','Eliquis VTEP') and Prod in('000','100')
	group by Mkt, Prod, ParentGeo,Geo
) b 
on a.Product = b.Mkt and case SeriesIdx when 1 then '000' else '100' end = b.Prod and a.Geo = b.geo
where a.LinkChartCode = 'D050' and a.IsShow = 'D'
go

update OutputHospital_All 
set Y = 
  case when VR3M1=0 or PR3M1=0 or VYTD=0 or PYTD=0 then 0 
      else cast(a.Y as float) / case a.category 
                                  when 'VC3M' then VR3M1 
                                  when 'PC3M' then PR3M1
                                
                                  when 'UM' then UM1 
                                  when 'VM' then VM1 

                                  when 'UMAT' then UMAT1 
                                  when 'VMAT' then VMAT1 
                    
                                  when 'VYTD' then VYTD
                                  when 'PYTD' then PYTD end
      end 
from OutputHospital_All a 
inner join (
	select 
	    Mkt, Prod, ParentGeo,Geo, 
		
		  sum(VR3M1) VR3M1,
      sum(PR3M1) PR3M1,
	
      sum(UM1) UM1,
      sum(VM1) VM1,

      sum(UMAT1) UMAT1,
      sum(VMAT1) VMAT1,

		  sum(VYTD) VYTD,
      sum(PYTD) PYTD
	from tempHospitalDataByGeo
	where lev  = 'Region' and Mkt in ('Platinum') and Prod in('000','100')
	group by Mkt, Prod, ParentGeo,Geo
) b 
on a.Product = b.Mkt and case SeriesIdx when 1 then '000' else '100' end = b.Prod and a.Geo = b.geo
where a.LinkChartCode = 'D050' and a.IsShow = 'D'
go


update OutputHospital_All 
set Product = b.Product
from OutputHospital_All a 
inner join (select distinct Product,Mkt from tblMktDefHospital) b on a.Product = b.Mkt
where a.LinkChartCode = 'D050'
go

-- select * from OutputHospital_All where LinkChartCode = 'D050'
update OutputHospital_All set 
	Category = case left(Category,1) when 'U' then 'Volume' when 'V' then 'Value' when 'P' then 'Adjusted patient number' end,
	Currency = case left(Currency,1) when 'U' then 'UNIT' WHEN 'V' THEN 'RMB' when 'P' then 'UNIT' END,
	TimeFrame = case right(TimeFrame,len(TimeFrame)-1) when 'YTD' THEN 'YTD' WHEN 'C3M' THEN 'MQT' WHEN 'MAT' THEN 'MAT' WHEN 'M' THEN 'MTH' END
where LinkChartCode in ('D050')
go

insert into OutputHospital_All (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
select LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, 'USD', TimeFrame, X, XIdx, 
	case when SeriesIdx in (1,2) and IsShow <> 'D' then cast(Y as Float)/(select Rate from BMSChinaCIA_IMS.dbo.tblRate) else Y end, IsShow
from OutputHospital_All 
where LinkChartCode in ('D050') and Currency = 'RMB'
go

update OutputHospital_All 
set X = left(b.Cpa_Name_English,50)
from OutputHospital_All a
inner join tblHospitalMaster b on a.x = b.id
where a.LinkChartCode in ('D050')-- and IsShow = 'Y'
go

update OutputHospital_All 
set Series = 'Hospital Contrib. to ' + Series
where LinkChartCode = 'D050' and IsShow = 'D'
go




--select * -- select distinct category ,Currency
----  select distinct TimeFrame
--from OutputHospital_All
--where LinkChartCode = 'D050' and IsShow = 'D' and Product ='paraplatin' 

update OutputHospital_All
set geo = case geo when 'East1' then 'East I'  
                    when 'EastI' then 'East I' 
                    when 'East2' then 'East II'
                    when 'EastII' then 'East II'  else geo end ,
    ParentGeo = case ParentGeo 
                    when 'East1' then 'East I'  
                    when 'EastI' then 'East I' 
                    when 'East2' then 'East II'
                    when 'EastII' then 'East II' else ParentGeo end  
where LinkChartCode = 'D050'
go



--log
insert into Logs 
select 'CPA' as 项目,'Output for Region Dashboard' as 处理内容,'end' as 标示,getdate() as 时间 
go





/**************************************************************************************************************
                                 1.3       Output for City Dashboard

说明：
For Onglyza, it still in NIAD market. 
So it make thing complex
**************************************************************************************************************/

--log
insert into Logs 
select 'CPA' as 项目,'Output for City Dashboard' as 处理内容,'start' as 标示,getdate() as 时间 
go


------------------------------------
-- D110: ARV/NIAD/ONCO/ANTI-Hyp/DPP4 Hospital Performance by City
------------------------------------
delete from OutputHospital_All where LinkChartCode='D110'
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
    'D110' AS LinkChartCode
    , 'D110' + cast(SeriesIdx as varchar) as LinkSeriesCode
    , a.Series
    , a.SeriesIdx
    , b.Category
    , b.Product
    , b.Lev
    , b.ParentGeo
    , b.Geo
    , b.Currency
    , b.TimeFrame
    , b.X
    , b.Xidx
    , 0 as Y
    , 'Y'
from (
	select 'Market' Series,1 as SeriesIdx union all
	select 'BMS Product' Series,2 as SeriesIdx union all
	select 'Market Growth' Series,3 as SeriesIdx union all
	select 'BMS Product Growth' Series,4 as SeriesIdx
) a, 
(
	select 
		RankSource as Category
		, Mkt as Product
		, Lev
		, ParentGeo
		, Geo
		, RankSource as Currency
		, RankSource as TimeFrame
		, CPA_id as X
		, Rank as Xidx
	from OutputTopCPA a 
	where Lev = 'City' and Product <> 'All' 
	and Mkt in ('ARV','NIAD','HYPFCS','ONCFCS','DPP4','Platinum','CCB','Eliquis VTEP') and Prod = '000'
	and exists(select * from tblSalesRegion b where a.Geo = b.imscity)
)b
go

update OutputHospital_All 
set Y = case a.category 
          when 'UC3M' then UR3M1 
          when 'VC3M' then VR3M1
          when 'PC3M' then PR3M1 
          when 'UM' then UM1 
          when 'VM' then VM1
          when 'PM' then PM1 
          when 'UMAT' then UMAT1 
          when 'VMAT' then VMAT1
          when 'PMAT' then PMAT1 
          when 'UYTD' then UYTD 
          when 'VYTD' then VYTD 
          when 'PYTD' then PYTD end
from OutputHospital_All a
inner join tempHospitalDataByGeo b on b.Mkt = a.Product 
	and b.lev = a.lev and b.ParentGeo = a.ParentGeo and b.geo = a.geo and b.CPA_id = cast(a.x as int)
where a.LinkChartCode = 'D110' and a.SeriesIdx = 1 and b.Prod = '000'
go

update OutputHospital_All 
set Y = case a.category 
        when 'UC3M' then UR3M1 
        when 'VC3M' then VR3M1 
        when 'PC3M' then PR3M1 
        when 'UMTH' then UM1 
        when 'VMTH' then VM1 
        when 'PMTH' then PM1 
        when 'UMAT' then UMAT1 
        when 'VMAT' then VMAT1 
        when 'PMAT' then PMAT1 
        when 'UYTD' then UYTD 
        when 'VYTD' then VYTD
        when 'PYTD' then PYTD end
from OutputHospital_All a
inner join tempHospitalDataByGeo b on b.Mkt = a.Product 
	and b.lev = a.lev and b.ParentGeo = a.ParentGeo and b.geo = a.geo and b.CPA_id = cast(a.x as int)
where a.LinkChartCode = 'D110' and a.SeriesIdx = 2 and b.Prod = '100' 
go

update OutputHospital_All 
set Y = case a.category 
  when 'UC3M' then UC3MGrowth 
  when 'VC3M' then VC3MGrowth 
  when 'PC3M' then PC3MGrowth
  when 'UMTH' then UMGrowth1 
  when 'VMTH' then VMGrowth1 
  when 'PMTH' then PMGrowth1 
  when 'UMAT' then UMATGrowth 
  when 'VMAT' then VMATGrowth 
  when 'PMAT' then PMATGrowth  
  when 'UYTD' then UYTDGrowth 
  when 'VYTD' then VYTDGrowth
  when 'PYTD' then PYTDGrowth end
from OutputHospital_All a
inner join tempHospitalDataByGeo b on b.Mkt = a.Product 
	and b.lev = a.lev and b.ParentGeo = a.ParentGeo and b.geo = a.geo and b.CPA_id = cast(a.x as int)
where a.LinkChartCode = 'D110' and a.SeriesIdx = 3 and b.Prod = '000'
go

update OutputHospital_All 
set Y = case a.category 
  when 'UC3M' then UC3MGrowth 
  when 'VC3M' then VC3MGrowth 
  when 'PC3M' then PC3MGrowth
  when 'UMTH' then UMGrowth1 
  when 'VMTH' then VMGrowth1 
  when 'PMTH' then PMGrowth1 
  when 'UMAT' then UMATGrowth 
  when 'VMAT' then VMATGrowth 
  when 'PMAT' then PMATGrowth 
  when 'UYTD' then UYTDGrowth 
  when 'VYTD' then VYTDGrowth 
  when 'PYTD' then PYTDGrowth end
from OutputHospital_All a
inner join tempHospitalDataByGeo b on b.Mkt = a.Product 
	and a.lev = b.lev and b.ParentGeo = a.ParentGeo and a.geo = b.geo and a.x = b.CPA_id
where a.LinkChartCode = 'D110' and a.SeriesIdx = 4 and b.Prod = '100'
go

update OutputHospital_All 
set Series=
	case Product 
    when 'HYPFCS' then 'Monopril Market' 
    when 'NIAD' then 'NIAD Market' 
    when 'ONCFCS' then 'Taxol Market' 
    when 'ARV' then 'ARV Market'
    when 'DPP4' then 'DPP-IV Class'
    when 'Platinum' then 'Platinum Market'
    when 'CCB' then 'Coniel Market'
    when 'Eliquis VTEP' then 'Eliquis (VTEP) Market'
    else Series end
where LinkChartCode = 'D110'  and Series = 'Market'
go

update OutputHospital_All 
set Series=
	case Product 
    when 'HYPFCS' then 'Monopril' 
    when 'NIAD' then 'Glucophage' 
    when 'ONCFCS' then 'Taxol' 
    when 'ARV' then 'Baraclude' 
    when 'DPP4' then 'Onglyza'
    when 'Platinum' then 'Paraplatin' 
    when 'CCB' then 'Coniel'
    when 'Eliquis VTEP' then 'Eliquis VTEP'
  end
where LinkChartCode = 'D110'  and Series = 'BMS Product'
go

update OutputHospital_All 
set Series=
	case Product 
    when 'HYPFCS' then 'Monopril' 
    when 'NIAD' then 'Glucophage' 
    when 'ONCFCS' then 'Taxol' 
    when 'ARV' then 'Baraclude' 
    when 'DPP4' then 'Onglyza' 
    when 'Platinum' then 'Paraplatin' 
    when 'CCB' then 'Coniel'
    when 'Eliquis VTEP' then 'Eliquis VTEP'
   end + ' Growth'
where LinkChartCode = 'D110'  and Series = 'BMS Product Growth'
go

-- Market Share in City
-- BMS Product Share in City
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, 
	Category, Product, Lev,  ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select LinkChartCode,LinkSeriesCode,
	a.Series, a.SeriesIdx, a.Category, a.Product, 
	a.Lev, a.ParentGeo, a.Geo, a.Currency, a.TimeFrame,a.X, a.Xidx,a.Y,'D' as IsShow
from OutputHospital_All a
where LinkChartCode = 'D110' and IsShow = 'Y' and SeriesIdx in(1,2)
go


delete
from OutputHospital_All where LinkChartCode = 'D110' and Product <> 'Platinum' and category like 'P%'
GO


update OutputHospital_All set Y = 
	case when (case a.category when 'UC3M' then UR3M1 
                             when 'VC3M' then VR3M1

                             when 'UMTH' then UM1 
                             when 'VMTH' then VM1 

                             when 'UMAT' then UMAT1 
                             when 'VMAT' then VMAT1  
                            
                             when 'UYTD' then UYTD 
                             when 'VYTD' then VYTD 
                            end ) = 0 then 0 
       else cast(a.Y as float) / case a.category  when 'UC3M' then UR3M1 
                                                  when 'VC3M' then VR3M1 
                                                  
                                                  when 'UMTH' then UM1 
                                                  when 'VMTH' then VM1 

                                                  when 'UMAT' then UMAT1 
                                                  when 'VMAT' then VMAT1  
                                                  
                                                  when 'UYTD' then UYTD 
                                                  when 'VYTD' then VYTD
                                                  end 
  end
from OutputHospital_All a inner join (
	select Mkt,Prod, ParentGeo,Geo, 
		sum(UR3M1) UR3M1,
		sum(VR3M1) VR3M1,
    sum(PR3M1) PR3M1,

    sum(UM1) UM1,
		sum(VM1) VM1,
    sum(PM1) PM1,

    sum(UMAT1) UMAT1,
		sum(VMAT1) VMAT1,
    sum(PMAT1) PMAT1,

		sum(UYTD) UYTD,
		sum(VYTD) VYTD,
		sum(PYTD) PYTD
	from tempHospitalDataByGeo
	where lev  = 'city' and Mkt in ('ARV','NIAD','HYPFCS','ONCFCS','DPP4','CCB','Eliquis VTEP') and Prod in('000','100')
	group by Mkt,Prod, ParentGeo,Geo
) b on a.Product = b.Mkt and case a.seriesidx when 1 then '000' else '100' end = b.Prod
	and a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
where a.LinkChartCode = 'D110' and a.IsShow = 'D'
go


update OutputHospital_All set Y = 
	case when (case a.category 
                             when 'VC3M' then VR3M1 
                             when 'PC3M' then PR3M1 
                            
                             when 'UMTH' then UM1 
                             when 'VMTH' then VM1 

                             when 'UMAT' then UMAT1 
                             when 'VMAT' then VMAT1  
                            
                             when 'VYTD' then VYTD 
                             when 'PYTD' then PYTD end ) = 0 then 0 
       else cast(a.Y as float) / case a.category  
                                                  when 'VC3M' then VR3M1 
                                                  when 'PC3M' then PR3M1
                                                 
                                                  when 'UMTH' then UM1 
                                                  when 'VMTH' then VM1 

                                                  when 'UMAT' then UMAT1 
                                                  when 'VMAT' then VMAT1  
                                                  
                                                  when 'VYTD' then VYTD
                                                  when 'PYTD' then PYTD end 
  end
from OutputHospital_All a inner join (
	select Mkt,Prod, ParentGeo,Geo, 
		sum(UR3M1) UR3M1,
		sum(VR3M1) VR3M1,
    sum(PR3M1) PR3M1,
    
    sum(UM1) UM1,
		sum(VM1) VM1,
    sum(PM1) PM1,

    sum(UMAT1) UMAT1,
		sum(VMAT1) VMAT1,
    sum(PMAT1) PMAT1,

		sum(UYTD) UYTD,
		sum(VYTD) VYTD,
		sum(PYTD) PYTD
	from tempHospitalDataByGeo
	where lev  = 'city' and Mkt in ('Platinum') and Prod in('000','100')
	group by Mkt,Prod, ParentGeo,Geo
) b on a.Product = b.Mkt and case a.seriesidx when 1 then '000' else '100' end = b.Prod
	and a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
where a.LinkChartCode = 'D110' and a.IsShow = 'D'
go


-- select * from OutputHospital_All where LinkChartCode = 'D110'
update OutputHospital_All set 
	Category = case left(Category,1) when 'U' then 'Volume' 
                                   when 'V' then 'Value'
                                   when 'P' then 'Adjusted patient number' end,
	Currency = case left(Currency,1) when 'U' then 'UNIT'
                                   WHEN 'V' THEN 'RMB'
                                   WHEN 'P' THEN 'UNIT' END,
	TimeFrame = case right(TimeFrame,len(TimeFrame)-1) when 'YTD' THEN 'YTD' 
                                                     WHEN 'C3M' THEN 'MQT'
                                                     WHEN 'M' THEN 'MTH'
                                                     WHEN 'MAT' THEN 'MAT' END
where LinkChartCode in ('D110')
go

update OutputHospital_All set Product = b.Product
from OutputHospital_All a 
inner join (
	select distinct case when mkt = 'DPP4' then 'Onglyza' else Product end as Product,Mkt 
	from tblMktDefHospital
) b on a.Product = b.Mkt
where a.LinkChartCode = 'D110'
go

insert into OutputHospital_All (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
select LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo
, 'USD', TimeFrame, X, XIdx, 
	case when SeriesIdx in (1,2) and IsShow <> 'D' then cast(Y as Float)/(select Rate from BMSChinaCIA_IMS.dbo.tblRate) else Y end, IsShow
from OutputHospital_All where LinkChartCode in ('D110') and Currency = 'RMB'
go

update OutputHospital_All set LinkSeriesCode = Product + '_' + LinkChartCode+'_' + Geo + IsShow + cast(SeriesIdx as varchar)
where LinkChartCode in ('D110')
go

update OutputHospital_All set X = left(b.Cpa_Name_English,50)
from OutputHospital_All a
inner join tblHospitalMaster b on a.x = b.id
where a.LinkChartCode in ('D110') -- and IsShow = 'Y'
go

update OutputHospital_All set Series = 'Hospital Contrib. to ' + Series
where LinkChartCode = 'D110' and IsShow = 'D'
go

------------------------------------
-- D130: Baraclude/Glucophage/Taxol/Onglyza Hospital Performance
------------------------------------
delete from OutputHospital_All where LinkChartCode='D130'
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  ParentGeo,Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'D130' AS LinkChartCode,
	'D130' + cast(SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, b.Category, b.Product, 
	b.Lev, b.ParentGeo, b.Geo, b.Currency, b.TimeFrame,b.X, b.Xidx,0 as Y,'Y'
from (
	select 'BMS Product' Series,1 as SeriesIdx union all
	select 'Generics' Series,2 as SeriesIdx
) a, (
	select distinct RankSource as Category, Mkt as Product, Lev as Lev,ParentGeo,Geo, 
		RankSource as Currency, RankSource as TimeFrame,
		CPA_id as X, Rank as Xidx
	from OutputTopCPA a 
	where mkt in('ARV','NIAD','ONCFCS','Platinum') and Prod = '100' and Lev = 'City'
		and exists(select * from tblSalesRegion b where a.Geo = b.imscity)
)b
go

delete -- select * from
OutputHospital_All 
where LinkChartCode = 'D130' and Product = 'ONCFCS' and Seriesidx = 2
go

update OutputHospital_All 
set Y = case a.category 
  when 'UC3M' then UC3MShare 
  when 'VC3M' then VC3MShare 
  when 'PC3M' then PC3MShare 

  when 'UM' then UMShare1 
  when 'VM' then VMShare1 
  when 'PM' then PMShare1 

  when 'UMAT' then UMATShare 
  when 'VMAT' then VMATShare 
  when 'PMAT' then PMATShare 

  when 'UYTD' then UYTDShare 
  when 'VYTD' then VYTDShare
  when 'PYTD' then PYTDShare end
from OutputHospital_All a
inner join tempHospitalDataByGeo b on b.Mkt = a.Product 
	and b.lev = a.lev and b.ParentGeo = a.ParentGeo and b.geo = a.geo and b.CPA_id = cast(a.x as int)
where a.LinkChartCode = 'D130' and a.SeriesIdx = 1 and b.Prod = '100'
go

update OutputHospital_All 
set Y = case a.category 
  when 'UC3M' then UC3MShare 
  when 'VC3M' then VC3MShare 
  when 'PC3M' then PC3MShare
  
  when 'UM' then UMShare1 
  when 'VM' then VMShare1 
  when 'PM' then PMShare1 

  when 'UMAT' then UMATShare 
  when 'VMAT' then VMATShare 
  when 'PMAT' then PMATShare 

  when 'UYTD' then UYTDShare 
  when 'VYTD' then VYTDShare
  when 'PYTD' then PYTDShare end
from OutputHospital_All a
inner join tempHospitalDataByGeo b on b.Mkt = a.Product 
	and b.lev = a.lev and b.ParentGeo = a.ParentGeo and b.geo = a.geo and b.CPA_id = cast(a.x as int)
where a.LinkChartCode = 'D130' and a.SeriesIdx = 2 and b.Prod = '010'
go

update OutputHospital_All set y = cast(a.y as float) - cast(b.y as float)
from OutputHospital_All a
inner join (
	select * from OutputHospital_All where LinkChartCode = 'D130' and SeriesIdx = 1-- BMS Prod
) b on a.category = b.category and a.product = b.product 
	and a.lev = b.lev and a.parentgeo = b.parentgeo
	and a.geo = b.geo and a.currency = b.currency 
	and a.timeframe = b.timeframe and a.xidx = b.xidx
where a.LinkChartCode = 'D130' and a.SeriesIdx = 2-- Generic
go


/*
Entecavir Generics
Metformin Generics
*/

update OutputHospital_All set Series=
	case Product 
	when 'HYPFCS' then 'Monopril' 
	when 'NIAD' then 'Glucophage' 
	when 'ONCFCS' then 'Taxol' 
	when 'ARV' then 'Baraclude' 
	when 'DPP4' THEN 'Onglyza' 
	when 'Platinum' THEN 'Paraplatin'
	end
where LinkChartCode = 'D130'  and Series = 'BMS Product'
go

update OutputHospital_All set Series=
	case Product 
	when 'NIAD' then 'Metformin Generics' 
	when 'ARV' then 'Entecavir Generics' end
where LinkChartCode = 'D130'  and Series = 'Generics'
go

-- SET THE CURRENCY,CATEGORY, TIMEFRAME
update OutputHospital_All set 
	Category = case left(Category,1) when 'U' then 'Volume' when 'V' then 'Value' when 'P' then 'Adjusted patient number' end,
	Currency = case left(Currency,1) when 'U' then 'UNIT' WHEN 'V' THEN 'RMB' when 'P' then 'UNIT' END,
	TimeFrame = case right(TimeFrame,len(TimeFrame)-1) when 'YTD' THEN 'YTD' WHEN 'C3M' THEN 'MQT' when 'M' THEN 'MTH' WHEN 'MAT' THEN 'MAT' END
where LinkChartCode in ('D130')
go

update OutputHospital_All 
set Product = b.Product
from OutputHospital_All a 
inner join (
	select distinct case when Mkt = 'DPP4' then 'Onglyza' else Product end Product,Mkt from tblMktDefHospital
) b on a.Product = b.Mkt
where a.LinkChartCode = 'D130'
go
insert into OutputHospital_All (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow,LinkedY)
select LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo
  , 'USD', TimeFrame, X, XIdx, Y, IsShow,
	-- cast(LinkedY as float) / (select Rate from BMSChinaCIA_IMS.dbo.tblRate) as 
	LinkedY
from OutputHospital_All 
where LinkChartCode in ('D130') and Currency = 'RMB'
go

update OutputHospital_All 
set X = left(b.Cpa_Name_English,50)-- + ' (' + LinkedY + ')'
from OutputHospital_All a
inner join tblHospitalMaster b on a.x = b.id
where a.LinkChartCode in ('D130')
go


update OutputHospital_All 
set ParentGeo = replace(replace(ParentGeo, 'East1', 'East I'), 'East2', 'East II')
where linkChartCode in ('D110', 'D130')

update OutputHospital_All 
set ParentGeo = replace(replace(ParentGeo, 'EastI', 'East I'), 'EastII', 'East II')
where linkChartCode in ('D110', 'D130')
go 


------------------------------
-- D150: Monopril Hospital Performance by City
------------------------------
delete from OutputHospital_All where LinkChartCode = 'D150'
go

insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'D150' AS LinkChartCode,
	'D150' + cast(SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, b.Category, b.Product, 
	b.Lev, b.ParentGeo, b.Geo, b.Currency, b.TimeFrame,b.X, b.Xidx,0 as Y,'Y'
from (
	select 'Monopril Share in Monopril Market' Series,1 as SeriesIdx union all
	select 'Monopril Share in ACEI Class' Series,2 as SeriesIdx
) a, (
	select distinct RankSource as Category, Mkt as Product, Lev as Lev,ParentGeo, Geo, 
		RankSource as Currency, RankSource as TimeFrame,
		CPA_id as X, Rank as Xidx
	from OutputTopCPA a
	where mkt ='HYPFCS' and Prod = '100' and Lev = 'City'
		and exists(select * from tblSalesRegion b where a.Geo = b.imscity)
)b
go

update OutputHospital_All 
set Y = case a.category 
        when 'UC3M' then UC3MShare 
        when 'VC3M' then VC3MShare 
        
        when 'UM' then UMShare1 
        when 'VM' then VMShare1 
        
        when 'UMAT' then UMATShare 
        when 'VMAT' then VMATShare 

        when 'UYTD' then UYTDShare 
        when 'VYTD' then VYTDShare end
from OutputHospital_All a
inner join tempHospitalDataByGeo b on b.Mkt = 'HYPFCS'
	and b.lev = a.lev and b.ParentGeo = b.ParentGeo and b.geo = a.geo and b.CPA_id = cast(a.x as int)
where a.LinkChartCode = 'D150' and a.SeriesIdx = 1 and b.Prod = '100'
go
update OutputHospital_All 
set Y = case a.category 
        when 'UC3M' then UC3MShare 
        when 'VC3M' then VC3MShare 
        
        when 'UM' then UMShare1 
        when 'VM' then VMShare1 
        
        when 'UMAT' then UMATShare 
        when 'VMAT' then VMATShare 

        when 'UYTD' then UYTDShare 
        when 'VYTD' then VYTDShare end
from OutputHospital_All a
inner join tempHospitalDataByGeo b on b.Mkt = 'ACE'
	and b.lev = a.lev and b.ParentGeo = b.ParentGeo and b.geo = a.geo and b.CPA_id = cast(a.x as int)
where a.LinkChartCode = 'D150' and a.SeriesIdx = 2 and b.Prod = '100'
go

-- set the currency,category, timeframe
update OutputHospital_All set 
Category = case left(Category,1) when 'U' then 'Volume' when 'V' then 'Value' when 'P' then 'Adjusted patient number' end,
Currency = case left(Currency,1) when 'U' then 'UNIT' when 'P' then 'UNIT' WHEN  'V' THEN 'RMB' END,
	TimeFrame = case right(TimeFrame,len(TimeFrame)-1) when 'YTD' THEN 'YTD' WHEN 'C3M' THEN 'MQT' when 'M' THEN 'MTH' WHEN 'MAT' THEN 'MAT'  END
where LinkChartCode in ('D150')
go

update OutputHospital_All set Product = b.Product
-- select distinct a.Product,b.mkt,b.Product
from OutputHospital_All a
inner join (select distinct Product,Mkt from tblMktDefHospital) b on a.Product = b.Mkt
where LinkChartCode in ('D150')
go

insert into OutputHospital_All (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow,LinkedY)
select 
    LinkChartCode
  , LinkSeriesCode
  , Series
  , SeriesIdx
  , Category
  , Product
  , Lev
  , ParentGeo
  , Geo
  , 'USD'
  , TimeFrame
  , X
  , XIdx
  , Y
  , IsShow
  , LinkedY
from OutputHospital_All where LinkChartCode in ('D150') and Currency = 'RMB'
go

update OutputHospital_All 
set X = left(b.Cpa_Name_English,50)
from OutputHospital_All a
inner join tblHospitalMaster b on a.x = b.id
where a.LinkChartCode in ('D150')
go

--log
insert into Logs 
select 'CPA' as 项目,'Output for City Dashboard' as 处理内容,'end' as 标示,getdate() as 时间 
go












/**************************************************************************************************************
                                 2.1       Output for Brand Report: Tier Performance
**************************************************************************************************************/

--log
insert into Logs 
select 'CPA' as 项目,'Output for Brand Report: Tier Performance' as 处理内容,'start' as 标示,getdate() as 时间 
go

-- 'R15%'
/*
Diabetes Market Performance by Hospital Tier
Hypertension Class Performance by Hospital Tier: 

	Tier 3 Hospital Class Share & Monthly Growth
	Tier 2 Hospital Class Share & Monthly Growth
	Dia/NIAD/Insulin
*/

-- R151: Tier 3 Hospital Class Share
-- R152: Tier 3 Hospital Class Monthly Growth
-- R153: Tier 2 Hospital Class Share
-- R154: Tier 2 Hospital Class Monthly Growth
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
    d.code AS LinkChartCode                                   -- LinkChartCode 
  , d.Code + cast(SeriesIdx as varchar) as LinkSeriesCode     -- LinkSeriesCode
  , a.Series                                                  -- Series        
  , a.SeriesIdx                                               -- SeriesIdx     
  , c.Category                                                -- Category      
  , a.Product                                                 -- Product       
  , 'Nat' Lev                                                 -- Lev           
  , 'China' Geo                                               -- Geo           
  , c.Category                                                -- Currency      
  , c.Category                                                -- TimeFrame     
  , b.X                                                       -- X             
  , b.Xidx                                                    -- XIdx          
  , 0 as Y                                                    -- Y             
  , 'Y'                                                       -- IsShow        
from (
	select distinct Mkt as Product,ProductName Series, Prod SeriesIdx 
	from dbo.tblMktDefHospital 
	where Mkt = 'HYP' and Class = 'Y' and Prod <>'000'
) a, 
(
	select Mth as X, idx as XIdx from tblHospitalMthList where Idx <= 12
)b,
(
	select 'UM' as Category union all
	select 'VM' as category
) c, 
(
	select 'R151' as Code union all
	select 'R152' as Code union all
	select 'R153' as Code union all
	select 'R154' as Code
) d
go

declare @i int, @sql varchar(2000), @m varchar(6)
set @i = 1
while @i <= 12
begin
	select @m = mth from tblHospitalMthList where Idx = @i
	-- Share
	set @sql = '
update OutputHospital_All set Y = case a.Category 
	when ''UM'' then UMS' + cast(@i as varchar) + '
	when ''VM'' then VMS' + cast(@i as varchar) + ' end
from OutputHospital_All a
inner join tempHospitalRollupByTier b on a.Product = b.Mkt and b.Prod <>''All'' and a.SeriesIdx =cast(b.Prod as int)
WHERE A.LinkChartCode in(''R151'',''R153'') and A.x = ''' + @m + '''
	and B.Tier = case when LinkChartCode in(''R151'',''R152'') THEN ''3'' else ''2'' end
	and b.Lev = ''Nat''
'
	-- Growth
	if @i <= 12
set @sql = @sql + '
update OutputHospital_All set Y = case a.Category 
	when ''UM'' then UMG' + cast(@i as varchar) + '
	when ''VM'' then VMG' + cast(@i as varchar) + ' end 
from OutputHospital_All a
inner join tempHospitalRollupByTier b on a.Product = b.Mkt and b.Prod <>''All'' and a.SeriesIdx =cast(b.Prod as int)
WHERE A.LinkChartCode in(''R152'',''R154'') and A.x = ''' + @m + '''
	and B.Tier = case when LinkChartCode in(''R151'',''R152'') THEN ''3'' else ''2'' end 
	and b.Lev = ''Nat'''
	-- print @sql
	exec(@sql)
set @i = @i + 1
end
go



-- 'R16%'
/*
NIAD Class Performance by Hospital Tier: 
	Tier 3 Hospital Class Share & Monthly Growth
	Tier 2 Hospital Class Share & Monthly Growth
	Dia/NIAD/Insulin
*/

-- R161: Tier 3 Hospital Class Share
-- R162: Tier 3 Hospital Class Monthly Growth
-- R163: Tier 2 Hospital Class Share
-- R164: Tier 2 Hospital Class Monthly Growth
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select d.code AS LinkChartCode,
	d.Code + cast(SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, c.Category, a.Product, 
	'Nat' Lev, 'China' Geo, c.Category, c.Category,b.X, b.Xidx,0 as Y,'Y'
from (
	-- Diabetes Market
	select distinct Mkt as Product,ProductName Series, Prod SeriesIdx 
	from dbo.tblMktDefHospital 
	where Mkt in('NIAD','ARV') and Class = 'Y' and Prod <>'000'
) a, (
	select Mth as X, idx as XIdx from tblHospitalMthList where Idx <= 12
)b,(
	select 'UM' as Category union all
	select 'VM' as category
) c, (
	select 'R161' as Code union all
	select 'R162' as Code union all
	select 'R163' as Code union all
	select 'R164' as Code
) d
go

declare @i int, @sql varchar(2000), @m varchar(6)
set @i = 1
while @i <= 12
begin
	select @m = mth from tblHospitalMthList where Idx = @i
	-- Share
	set @sql = '
update OutputHospital_All set Y = case a.Category 
	when ''UM'' then UMS' + cast(@i as varchar) + ' 
	when ''VM'' then VMS' + cast(@i as varchar) + ' 
	end
from OutputHospital_All a
inner join tempHospitalRollupByTier b on a.Product = b.Mkt and b.Prod <>''All'' and a.SeriesIdx =cast(b.Prod as int)
WHERE A.LinkChartCode in(''R161'',''R163'') and A.x = ''' + @m + '''
	and B.Tier = case when LinkChartCode in(''R161'',''R162'') THEN ''3'' else ''2'' end
	and b.Lev = ''Nat''
'
	-- Growth mth<=23
	if @i <= 12
set @sql = @sql + '
update OutputHospital_All set Y = case a.Category 
	when ''UM'' then UMG' + cast(@i as varchar) + '
	when ''VM'' then VMG' + cast(@i as varchar) + ' end 
from OutputHospital_All a
inner join tempHospitalRollupByTier b on a.Product = b.Mkt and b.Prod <>''All'' and a.SeriesIdx =cast(b.Prod as int)
WHERE A.LinkChartCode in(''R162'',''R164'') and A.x = ''' + @m + '''
	and B.Tier = case when LinkChartCode in(''R161'',''R162'') THEN ''3'' else ''2'' end 
	and b.Lev = ''Nat'''
	exec(@sql)
set @i = @i + 1
end



-- 'R17%'
/*
NIAD Brand Performance by Hospital Tier
/ARV Brand Performance by Hospital Tier 
/ Hypertension Focused Brand Performance by Hospital Tier
/ Oncology Focused Brand Performance by Hospital
: 
	Tier 3 Hospital Class Share & Monthly Growth
	Tier 2 Hospital Class Share & Monthly Growth
	Dia/NIAD/Insulin
*/

-- R171: Tier 3 Hospital Class Share
-- R172: Tier 3 Hospital Class Monthly Growth
-- R173: Tier 2 Hospital Class Share
-- R174: Tier 2 Hospital Class Monthly Growth
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select d.code AS LinkChartCode,
	d.Code + cast(SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, c.Category, a.Product, 
	'Nat' Lev, 'China' Geo, c.Category, c.Category,b.X, b.Xidx,0 as Y,'Y'
from (
	select distinct Mkt as Product,ProductName Series, Prod SeriesIdx 
	from dbo.tblMktDefHospital 
	where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and FocusedBrand ='Y' and Class = 'N' and Molecule = 'N' and Prod <>'000'
) a, (
	select Mth as X, idx as XIdx from tblHospitalMthList where Idx <= 12
)b,(
	select 'UM' as Category union all
	select 'VM' as category
) c, (
	select 'R171' as Code union all
	select 'R172' as Code union all
	select 'R173' as Code union all
	select 'R174' as Code
) d
go

declare @i int, @sql varchar(2000), @m varchar(6)
set @i = 1
while @i <= 12
begin
	select @m = mth from tblHospitalMthList where Idx = @i
	-- Share
	set @sql = '
update OutputHospital_All set Y = case a.Category 
	when ''UM'' then UMS' + cast(@i as varchar) + '
	when ''VM'' then VMS' + cast(@i as varchar) + ' end
from OutputHospital_All a
inner join tempHospitalRollupByTier b on a.Product = b.Mkt and b.Prod <>''All'' and a.SeriesIdx =cast(b.Prod as int)
WHERE A.LinkChartCode in(''R171'',''R173'') and A.x = ''' + @m + '''
	and B.Tier = case when LinkChartCode in(''R171'',''R172'') THEN ''3'' else ''2'' end
	and b.Lev = ''Nat''
'
	-- Growth
	if @i <= 12
set @sql = @sql + '
update OutputHospital_All set Y = case a.Category 
	when ''UM'' then UMG' + cast(@i as varchar) + '
	when ''VM'' then VMG' + cast(@i as varchar) + ' end 
from OutputHospital_All a
inner join tempHospitalRollupByTier b on a.Product = b.Mkt and b.Prod <>''All'' and a.SeriesIdx =cast(b.Prod as int)
WHERE A.LinkChartCode in(''R172'',''R174'') and A.x = ''' + @m + '''
	and B.Tier = case when LinkChartCode in(''R171'',''R172'') THEN ''3'' else ''2'' end 
	and b.Lev = ''Nat'''
	print @sql
	exec(@sql)
set @i = @i + 1
end
go



-- 'R18%'
/*
DPP-IV Performance by Hospital Tier
ACEI Class Brand Performance by Hospital Tier

	Tier 3 Hospital Class Share & Monthly Growth
	Tier 2 Hospital Class Share & Monthly Growth
	Dia/NIAD/Insulin
*/

-- R181: Tier 3 Hospital Class Share
-- R182: Tier 3 Hospital Class Monthly Growth
-- R183: Tier 2 Hospital Class Share
-- R184: Tier 2 Hospital Class Monthly Growth

insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select d.code AS LinkChartCode,
	d.Code + cast(SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, c.Category, a.Product, 
	'Nat' Lev, 'China' Geo, c.Category, c.Category,b.X, b.Xidx,0 as Y,'Y'
from (
	-- Add DPP-v when onglyza is available
	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
	from dbo.tblMktDefHospital 
	where Mkt in('ACE','DPP4') and FocusedBrand ='Y' and Class = 'N' and Molecule = 'N' and Prod <>'000'
) a, (
	select Mth as X, idx as XIdx from tblHospitalMthList where Idx <= 12
)b,(
	select 'UM' as Category union all
	select 'VM' as category
) c, (
	select 'R181' as Code union all
	select 'R182' as Code union all
	select 'R183' as Code union all
	select 'R184' as Code
) d
go

declare @i int, @sql varchar(2000), @m varchar(6)
set @i = 1
while @i <= 12
begin
	select @m = mth from tblHospitalMthList where Idx = @i
	-- Share
	set @sql = '
update OutputHospital_All set Y = case a.Category 
	when ''UM'' then UMS' + cast(@i as varchar) + '
	when ''VM'' then VMS' + cast(@i as varchar) + ' end
from OutputHospital_All a
inner join tempHospitalRollupByTier b on a.Product = b.Mkt and b.Prod <>''All'' and a.SeriesIdx =cast(b.Prod as int)
WHERE A.LinkChartCode in(''R181'',''R183'') and A.x = ''' + @m + '''
	and B.Tier = case when LinkChartCode in(''R181'',''R182'') THEN ''3'' else ''2'' end
	and b.Lev = ''Nat''
'
	-- Growth
	if @i <= 12
set @sql = @sql + '
update OutputHospital_All set Y = case a.Category 
	when ''UM'' then UMG' + cast(@i as varchar) + '
	when ''VM'' then VMG' + cast(@i as varchar) + ' end 
from OutputHospital_All a
inner join tempHospitalRollupByTier b on a.Product = b.Mkt and b.Prod <>''All'' and a.SeriesIdx =cast(b.Prod as int)
WHERE A.LinkChartCode in(''R182'',''R184'') and A.x = ''' + @m + '''
	and B.Tier = case when LinkChartCode in(''R181'',''R182'') THEN ''3'' else ''2'' end 
	and b.Lev = ''Nat'''
	exec(@sql)
set @i = @i + 1
end
go

-- set the currency,category, timeframe
update OutputHospital_All set 
Category = case left(Category,1) when 'U' then 'Volume' when 'V' then 'Value' when 'P' then 'Adjusted patient number' end,
Currency = case left(Currency,1) when 'U' then 'UNIT' when 'P' then 'UNIT' WHEN  'V' THEN 'RMB' END,
	TimeFrame = 'MTH'
where LinkChartCode like 'R15%' or LinkChartCode like 'R16%' or LinkChartCode like 'R17%' or LinkChartCode like 'R18%'
go

update OutputHospital_All set Product  = b.Product
from OutputHospital_All a 
inner join (select distinct Product, Mkt from tblMktDefHospital) b on a.Product = b.Mkt
where LinkChartCode like 'R15%' or LinkChartCode like 'R16%' or LinkChartCode like 'R17%' or LinkChartCode like 'R18%'
go

insert into OutputHospital_All (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
select 
    LinkChartCode
  , LinkSeriesCode
  , Series
  , SeriesIdx
  , Category
  , Product
  , Lev
  , ParentGeo
  , Geo
  , 'USD'
  , TimeFrame
  , X
  , XIdx
  , Y
  , IsShow
from OutputHospital_All 
where 
  (LinkChartCode like 'R15%' or LinkChartCode like 'R16%' or LinkChartCode like 'R17%' or LinkChartCode like 'R18%') 
  and Currency = 'RMB'
go

update OutputHospital_All set X = 
  (
    select replace(right(convert(varchar(11),convert(datetime,Mth +'01',112),6),6),' ','''') 
    from tblHospitalMthList where Idx = Xidx
  )
where LinkChartCode like 'R15%' or LinkChartCode like 'R16%' or LinkChartCode like 'R17%' or LinkChartCode like 'R18%'
go
update OutputHospital_All set XIdx = 13 - Xidx
where LinkChartCode like 'R15%' or LinkChartCode like 'R16%' or LinkChartCode like 'R17%' or LinkChartCode like 'R18%'
go
update OutputHospital_All set Product = 'Onglyza' where Product = 'Glucophage' and LinkChartCode like 'R18%'
go

--log
insert into Logs 
select 'CPA' as 项目,'Output for Brand Report: Tier Performance' as 处理内容,'end' as 标示,getdate() as 时间 
go







/**************************************************************************************************************
                                 2.2       Output for Brand Report: Hospital Performance
**************************************************************************************************************/

--log
insert into Logs 
select 'CPA' as 项目,'Output for Brand Report: Hospital Performance' as 处理内容,'start' as 标示,getdate() as 时间 
go


-- R191
-- Top DIA/HYPFCS Market Tier 3 Hospital Performance by Brands
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
   'R191' AS LinkChartCode                                     -- LinkChartCode 
  ,'R191' + cast(a.SeriesIdx as varchar) as LinkSeriesCode     -- LinkSeriesCode
  , a.Series                                                   -- Series        
  , a.SeriesIdx                                                -- SeriesIdx     
  , B.Category                                                 -- Category      
  , a.Product                                                  -- Product       
  , 'Nat' Lev                                                  -- Lev           
  , 'China' Geo                                                -- Geo           
  , B.Category                                                 -- Currency      
  , B.Category                                                 -- TimeFrame     
  , b.X                                                        -- X             
  , b.Xidx                                                     -- XIdx          
  , 0 as Y                                                     -- Y             
  , 'Y'                                                        -- IsShow        
from (
	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
	from dbo.tblMktDefHospital 
	where mkt in ('NIAD','HYPFCS','CCB') and Molecule = 'N' and Class = 'N' and Prod <> '000'
) a, (
  select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('DIA','HYPFCS','CCB') and Tier = '3' and Prod = '000' and VMATRank <= 7
  Union all
  select Mkt, 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('DIA','HYPFCS','CCB') and Tier = '3' and Prod = '000' and UMATRank <= 7
  Union all
  select Mkt,'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('DIA','HYPFCS','CCB') and Tier = '3' and Prod = '000' and VYTDRANK <= 7
  Union all
  select Mkt, 'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('DIA','HYPFCS','CCB') and Tier = '3' and Prod = '000' and UYTDRANK <= 7
)b
where case when b.Mkt = 'Dia' then 'NIAD' else b.Mkt end = a.Product
go
-- table in R191
-- MAT Growth for each hospital
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
    'R191' AS LinkChartCode
  , 'R191' + cast(a.SeriesIdx as varchar) as LinkSeriesCode
  , a.Series
  , a.SeriesIdx
  , b.Category
  , a.Product
  , 'Nat' Lev
  , 'China' Geo
  , b.Category
  , b.Category
  , b.X
  , b.Xidx
  , 0 as Y
  , 'D'
from 
(
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital 
	where mkt in ('NIAD') and Prod in('000','100','500')
	union all
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital 
	where mkt in ('HYPFCS') and Prod in('000','100','600')
	union all
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital 
	where mkt in ('CCB') and Prod in('000','100')
)a, 
(
	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
	from tempHospitalDataByTier where Mkt in('Dia','HYPFCS','CCB') and Tier = '3' and Prod = '000' and VMATRank <= 7
	Union all
	select Mkt, 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
	from tempHospitalDataByTier where Mkt in('Dia','HYPFCS','CCB') and Tier = '3' and Prod = '000' and UMATRank <= 7
	Union all
	select Mkt,'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
	from tempHospitalDataByTier where Mkt in('Dia','HYPFCS','CCB') and Tier = '3' and Prod = '000' and VYTDRANK <= 7
	Union all
	select Mkt, 'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
	from tempHospitalDataByTier where Mkt in('Dia','HYPFCS','CCB') and Tier = '3' and Prod = '000' and UYTDRANK <= 7
)b 
where case when b.Mkt = 'DIA' then 'NIAD' else b.Mkt end = a.Product
go


-- R251
-- Top DIA/HYP Market Tier 2 Hospital Performance by Brands
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R251' AS LinkChartCode,
	'R251' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, B.Category, a.Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
from (
	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
	from dbo.tblMktDefHospital 
	where mkt in ('niad','HYPFCS','CCB') and Molecule = 'N' and Class = 'N' and Prod <> '000'
) a, (
	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
	from tempHospitalDataByTier where Mkt in('Dia','HYPFCS','CCB') and Tier = '2' and Prod = '000' and VMATRank <= 7
	Union all
	select Mkt, 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
	from tempHospitalDataByTier where Mkt in('Dia','HYPFCS','CCB') and Tier = '2' and Prod = '000' and UMATRank <= 7
	Union all
	select Mkt,'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('DIA','HYPFCS','CCB') and Tier = '2' and Prod = '000' and VYTDRANK <= 7
  Union all
  select Mkt,'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('DIA','HYPFCS','CCB') and Tier = '2' and Prod = '000' and UYTDRANK <= 7
)b
where case when b.Mkt = 'Dia' then 'NIAD' else b.Mkt end = a.Product
go
-- table in R251
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R251' AS LinkChartCode,
	'R251' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, b.Category, a.Product, 
	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
from (
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital 
	where mkt in ('niad') and Prod in('000','100','500')
	union all
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital 
	where mkt in ('HYPFCS') and Prod in('000','100','600')
	union all
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital 
	where mkt in ('CCB') and Prod in('000','100')
)a, (
	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
	from tempHospitalDataByTier where Mkt in('Dia','HYPFCS','CCB') and Tier = '2' and Prod = '000' and VMATRank <= 7
	Union all
	select Mkt, 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
	from tempHospitalDataByTier where Mkt in('Dia','HYPFCS','CCB') and Tier = '2' and Prod = '000' and UMATRank <= 7
	Union all
	select Mkt,'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('DIA','HYPFCS','CCB') and Tier = '2' and Prod = '000' and VYTDRANK <= 7
  Union all
  select Mkt,'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('DIA','HYPFCS','CCB') and Tier = '2' and Prod = '000' and UYTDRANK <= 7
)b
where  case when b.Mkt = 'Dia' then 'NIAD' else b.Mkt end = a.Product
go

-- R901
-- HYP Tier 3 Hospital Performance by Class
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R901' AS LinkChartCode,
	'R901' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, B.Category, a.Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
from (
	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
	from dbo.tblMktDefHospital where mkt in ('HYP') and Molecule = 'N' and Class = 'Y' and Prod <> '000' and prod <> '850'
) a, (
	select 'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
	from tempHospitalDataByTier where Mkt in('HYP') and Tier = '3' and Prod = '000' and VMATRank <= 7
	Union all
	select 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
	from tempHospitalDataByTier where Mkt in('HYP') and Tier = '3' and Prod = '000' and UMATRank <= 7
	Union all
	select 'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('HYP')  and Tier = '3' and Prod = '000' and VYTDRANK <= 7
  Union all
  select 'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('HYP')  and Tier = '3' and Prod = '000' and UYTDRANK <= 7
)b
go
-- table in R901
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R901' AS LinkChartCode,
	'R901' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, b.Category, a.Product, 
	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
from (
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital 
	where mkt in ('HYP') and Prod in('000','910','920')
)a, (
  select 'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('HYP') and Tier = '3' and Prod = '000' and VMATRank <= 7
  Union all
  select 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('HYP') and Tier = '3' and Prod = '000' and UMATRank <= 7
  Union all
  select 'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('HYP')  and Tier = '3' and Prod = '000' and VYTDRANK <= 7
  Union all
  select 'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('HYP')  and Tier = '3' and Prod = '000' and UYTDRANK <= 7
)b
go

-- R961
-- HYP Tier 2 Hospital Performance by Class
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R961' AS LinkChartCode,
	'R961' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, B.Category, a.Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
from (
	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
	from dbo.tblMktDefHospital 
	where mkt in ('HYP') and Molecule = 'N' and Class = 'Y' and Prod <> '000' and  prod <> '850'
) a, (
  select 'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('HYP') and Tier = '2' and Prod = '000' and VMATRank <= 7
  Union all
  select 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('HYP') and Tier = '2' and Prod = '000' and UMATRank <= 7
  Union all
  select 'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('HYP')  and Tier = '2' and Prod = '000' and VYTDRANK <= 7
  Union all
  select 'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('HYP')  and Tier = '2' and Prod = '000' and UYTDRANK <= 7
)b
go
-- table in R961
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R961' AS LinkChartCode,
	'R961' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, b.Category, a.Product, 
	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
from (
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital 
	where mkt in ('HYP') and Prod in('000','910','920')
)a, (
  select 'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('HYP') and Tier = '2' and Prod = '000' and VMATRank <= 7
  Union all
  select 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('HYP') and Tier = '2' and Prod = '000' and UMATRank <= 7   
  Union all
  select 'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('HYP')  and Tier = '2' and Prod = '000' and VYTDRANK <= 7
  Union all
  select 'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('HYP')  and Tier = '2' and Prod = '000' and UYTDRANK <= 7
)b
go


-- R201
-- NIAD Tier 3 Hospital Performance by Class
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R201' AS LinkChartCode,
	'R201' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, B.Category, a.Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
from (
	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
	from dbo.tblMktDefHospital where mkt in ('NIAD') and Molecule = 'N' and Class = 'Y' and Prod <> '000'
) a, (
  select 'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD') and Tier = '3' and Prod = '000' and VMATRank <= 7
  Union all
  select 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD') and Tier = '3' and Prod = '000' and UMATRank <= 7
  Union all
  select 'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD')  and Tier = '3' and Prod = '000' and VYTDRANK <= 7
  Union all
  select 'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD')  and Tier = '3' and Prod = '000' and UYTDRANK <= 7
)b
go
-- table in R201
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R201' AS LinkChartCode,
	'R201' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, b.Category, a.Product, 
	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
from (
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital 
	where mkt in ('niad') and Prod in('000','930')
)a, (
  select 'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD') and Tier = '3' and Prod = '000' and VMATRank <= 7
  Union all
  select 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD') and Tier = '3' and Prod = '000' and UMATRank <= 7
  Union all
  select 'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD')  and Tier = '3' and Prod = '000' and VYTDRANK <= 7
  Union all
  select 'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD')  and Tier = '3' and Prod = '000' and UYTDRANK <= 7
)b
go


-- R261
-- NIAD Tier 2 Hospital Performance by Class
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R261' AS LinkChartCode,
	'R261' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, B.Category, a.Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
from (
	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
	from dbo.tblMktDefHospital 
	where mkt in ('niad') and Molecule = 'N' and Class = 'Y' and Prod <> '000'
) a, (
  select 'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD') and Tier = '2' and Prod = '000' and VMATRank <= 7
  Union all
  select 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD') and Tier = '2' and Prod = '000' and UMATRank <= 7
  Union all
  select 'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD')  and Tier = '2' and Prod = '000' and VYTDRANK <= 7
  Union all
  select 'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD')  and Tier = '2' and Prod = '000' and UYTDRANK <= 7
)b
go
-- table in R261
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R261' AS LinkChartCode,
	'R261' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, b.Category, a.Product, 
	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
from (
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital 
	where mkt in ('niad') and Prod in('000','930')
)a, (
  select 'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD') and Tier = '2' and Prod = '000' and VMATRank <= 7
  Union all
  select 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD') and Tier = '2' and Prod = '000' and UMATRank <= 7
  Union all
  select 'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD')  and Tier = '2' and Prod = '000' and VYTDRANK <= 7
  Union all
  select 'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD')  and Tier = '2' and Prod = '000' and UYTDRANK <= 7
)b
go


-- R211
-- NIAD/ACE/ARV/ONCFCS Tier 3 Hospital Performance by Brands
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
  'R211' AS LinkChartCode
 , 'R211' + cast(a.SeriesIdx as varchar) as LinkSeriesCode
 , a.Series
 , a.SeriesIdx
 , B.Category
 , a.Product
 , 'Nat' Lev
 , 'China' Geo
 , B.Category
 , B.Category
 , b.X
 , b.Xidx
 , 0 as Y
 , 'Y'
from (
	select distinct Mkt Product,ProductName as  Series, Prod as SeriesIdx 
	from dbo.tblMktDefHospital 
	where mkt in ('NIAD','ACE','ARV','ONCFCS') and Molecule = 'N' and Class = 'N' and Prod <> '000'
) a, (
  select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '3' and Prod = '000' and VMATRank <= 7
  Union all
  select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '3' and Prod = '000' and UMATRank <= 7 
  Union all
  select Mkt,'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '3' and Prod = '000' and VYTDRANK <= 7 
  Union all
  select Mkt,'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '3' and Prod = '000' and UYTDRANK <= 7 
  
)b
where a.Product = b.Mkt
go
-- table in R211
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R211' AS LinkChartCode,
	'R211' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, b.Category, a.Product, 
	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
from (
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital where mkt in ('NIAD') and Prod in('000','100','500')
	union all
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital where mkt in ('ONCFCS') and Prod in('000','100','800')
	union all
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital where mkt in ('ARV') and Prod in('000','100','300')
	union all
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital where mkt in ('ACE') and Prod in('000','100','700')
)a, (
	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
	from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '3' and Prod = '000' and VMATRank <= 7
	Union all
	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
	from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '3' and Prod = '000' and UMATRank <= 7
	Union all
  select Mkt,'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '3' and Prod = '000' and VYTDRANK <= 7 
  Union all
  select Mkt,'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '3' and Prod = '000' and UYTDRANK <= 7
)b
where a.Product = b.Mkt
go


-- R271
-- 上图：NIAD/ACE/ARV/ONCFCS Tier 2 Hospital Performance by Brands
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
    'R271' AS LinkChartCode                                 -- LinkChartCode 
  , 'R271' + cast(a.SeriesIdx as varchar) as LinkSeriesCode -- LinkSeriesCode
  , a.Series                                                -- Series        
  , a.SeriesIdx                                             -- SeriesIdx     
  , B.Category                                              -- Category      
  , a.Product                                               -- Product       
  , 'Nat' Lev                                               -- Lev           
  , 'China' Geo                                             -- Geo           
  , B.Category                                              -- Currency      
  , B.Category                                              -- TimeFrame     
  , b.X                                                     -- X             
  , b.Xidx                                                  -- XIdx          
  , 0 as Y                                                  -- Y             
  , 'Y'                                                     -- IsShow        
from (
  select distinct 
    Mkt Product
    ,ProductName Series
    , Prod SeriesIdx 
  from dbo.tblMktDefHospital 
  where mkt in ('NIAD','ACE','ARV','ONCFCS') and Molecule = 'N' and Class = 'N' and Prod <> '000'
) a, (
  select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '2' and Prod = '000' and VMATRank <= 7
  Union all
  select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '2' and Prod = '000' and UMATRank <= 7
  Union all
  select Mkt,'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '2' and Prod = '000' and VYTDRANK <= 7
  Union all
  select Mkt,'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '2' and Prod = '000' and UYTDRANK <= 7
)b
where a.Product = b.Mkt
go
-- 下表：table in R271
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
    'R271' AS LinkChartCode
  , 'R271' + cast(a.SeriesIdx as varchar) as LinkSeriesCode
  , a.Series
  , a.SeriesIdx
  , b.Category
  , a.Product
  , 'Nat' Lev
  , 'China' Geo
  , b.Category
  , b.Category
  , b.X
  , b.Xidx
  , 0 as Y
  , 'D'
from (
  select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
  from dbo.tblMktDefHospital where mkt in ('NIAD') and Prod in('000','100','500')
  union all
  select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
  from dbo.tblMktDefHospital where mkt in ('ONCFCS') and Prod in('000','100','800')
  union all
  select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
  from dbo.tblMktDefHospital where mkt in ('ARV') and Prod in('000','100','300')
  union all
  select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
  from dbo.tblMktDefHospital where mkt in ('ACE') and Prod in('000','100','700')
)a, (
  select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '2' and Prod = '000' and VMATRank <= 7
  Union all
  select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '2' and Prod = '000' and UMATRank <= 7
  Union all
  select Mkt,'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '2' and Prod = '000' and VYTDRANK <= 7
  Union all
  select Mkt,'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '2' and Prod = '000' and UYTDRANK <= 7
)b
where a.Product = b.Mkt
go

-- R272
-- Top NIAD/ACE/ARV/ONCFCS Tier 3 hospital Performance by BMS Product
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R272' AS LinkChartCode,
	'R272' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
	b.Series, b.SeriesIdx, B.Category, a.Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
from 
(
	select distinct Mkt Product
	from dbo.tblMktDefHospital 
	where mkt in ('NIAD','ACE','ARV','ONCFCS') and FocusedBrand = 'Y' and Molecule = 'N' and Class = 'N' and Prod = '100'
) a, 
(
  select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '2' and Prod = '000' and VMATRANK <= 7
  union all
  select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '2' and Prod = '000' and UMATRANK <= 7
  union all
  select Mkt,'VYTD' as Category,cpa_id as Series,VYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '2' and Prod = '000' and VYTDRANK <= 7
  union all
  select Mkt,'UYTD' as Category,cpa_id as Series,UYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '2' and Prod = '000' and UYTDRANK <= 7
)b, 
(
	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
)c
where a.Product = b.Mkt
go

-- R231
-- Glocuphage/Baraclude/Taxol/Monopril Tier 3 Hospital Performance by Brands
delete OutputHospital_All where linkChartCode = 'R231'
go
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R231' AS LinkChartCode,
	'R231' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, B.Category, a.Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
from (
	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
	from dbo.tblMktDefHospital where mkt in ('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Molecule = 'N' and Class = 'N' and Prod <> '000'
) a, (
  select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '3' and Prod = '100' and VMATRank <= 7
  Union all
  select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '3' and Prod = '100' and UMATRank <= 7   
  Union all
  select Mkt,'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '3' and Prod = '000' and VYTDRANK <= 7
  Union all
  select Mkt,'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '3' and Prod = '000' and UYTDRANK <= 7
)b
where a.Product = b.Mkt
go
-- table in R231
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R231' AS LinkChartCode,
	'R231' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
	a.Series, a.SeriesIdx, b.Category, a.Product, 
	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
from (
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital where mkt in ('NIAD') and Prod in('000','100','500')
	union all
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital where mkt in ('ONCFCS') and Prod in('000','100','800')
	union all
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital where mkt in ('ARV') and Prod in('000','100','300')
	union all
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital where mkt in ('HYPFCS') and Prod in('000','100','700')
	union all
	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
	from dbo.tblMktDefHospital where mkt in ('CCB') and Prod in('000','100')
)a, (
  select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '3' and Prod = '100' and VMATRank <= 7
  Union all
  select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '3' and Prod = '100' and UMATRank <= 7
  Union all
  select Mkt,'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '3' and Prod = '000' and VYTDRANK <= 7
  Union all
  select Mkt,'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '3' and Prod = '000' and UYTDRANK <= 7
)b
where a.Product = b.Mkt
go


-- R291
--上图： Glocuphage/Baraclude/Taxol/Monopril Tier 2 Hospital Performance by Brands
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
   'R291' AS LinkChartCode
  , 'R291' + cast(a.SeriesIdx as varchar) as LinkSeriesCode
  , a.Series
  , a.SeriesIdx
  , B.Category
  , a.Product
  , 'Nat' Lev
  , 'China' Geo
  , B.Category
  , B.Category
  , b.X
  , b.Xidx
  , 0 as Y
  , 'Y'
from (
	select distinct 
	 Mkt Product,ProductName Series, Prod SeriesIdx 
	from dbo.tblMktDefHospital 
	where mkt in ('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Molecule = 'N' and Class = 'N' and Prod <> '000'
) a, (
	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
	from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '2' and Prod = '100' and VMATRank <= 7
	Union all
	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
	from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '2' and Prod = '100' and UMATRank <= 7
	Union all
  select Mkt,'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '2' and Prod = '000' and VYTDRANK <= 7
  Union all
  select Mkt,'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '2' and Prod = '000' and UYTDRANK <= 7
)b
where a.Product = b.Mkt
go
--下表： table in R291
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
    'R291' AS LinkChartCode
  , 'R291' + cast(a.SeriesIdx as varchar) as LinkSeriesCode
  , a.Series
  , a.SeriesIdx
  , b.Category
  , a.Product
  , 'Nat' Lev
  , 'China' Geo
  , b.Category
  , b.Category
  , b.X
  , b.Xidx
  , 0 as Y
  , 'D'
from (
  select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
  from dbo.tblMktDefHospital where mkt in ('NIAD') and Prod in('000','100','500')
  union all
  select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
  from dbo.tblMktDefHospital where mkt in ('ONCFCS') and Prod in('000','100','800')
  union all
  select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
  from dbo.tblMktDefHospital where mkt in ('ARV') and Prod in('000','100','300')
  union all
  select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
  from dbo.tblMktDefHospital where mkt in ('HYPFCS') and Prod in('000','100','700')
  union all
  select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
  from dbo.tblMktDefHospital where mkt in ('CCB') and Prod in('000','100')
)a, (
  select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '2' and Prod = '100' and VMATRank <= 7
  Union all
  select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '2' and Prod = '100' and UMATRank <= 7
  Union all
  select Mkt,'VYTD' as Category,cpa_id as X,[VYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '2' and Prod = '000' and VYTDRANK <= 7
  Union all
  select Mkt,'UYTD' as Category,cpa_id as X,[UYTDRANK] as XIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '2' and Prod = '000' and UYTDRANK <= 7
)b
where a.Product = b.Mkt
go

-- calculate the share
update OutputHospital_All 
set Y = 
  case a.Category when 'VMAT' then b.VMAT1
                  when 'UMAT' then b.UMAT1
                  when 'VR3M' then b.VR3M1
                  when 'UR3M' then b.UR3M1
                  when 'VYTD' then b.VYTD
                  when 'UYTD' then b.UYTD 
  end 
from OutputHospital_All a
inner join tempHospitalDataByTier b 
on a.Product = b.Mkt and a.SeriesIdx = b.Prod and a.x = b.cpa_id
where a.LinkChartCode in('R191','R251','R201','R261','R211','R271','R221','R281','R231','R291','R241','R301','R901','R961')
	and a.IsShow = 'Y'
go

-- set the total to Additional Y
update OutputHospital_All 
set AddY = b.total
from OutputHospital_All a
inner join 
    (
      select LinkChartCode,CateGory,Product,Lev,ParentGeo,Geo,Currency,TimeFrame,xidx,
      	sum(cast(Y as float)) as total
      from OutputHospital_All a
      where a.LinkChartCode in('R191','R251','R201','R261','R211','R271','R221','R281','R231','R291','R241','R301','R901','R961')
      group by LinkChartCode,CateGory,Product,Lev,ParentGeo,Geo,Currency,TimeFrame,xidx
    ) b 
on 
  a.LinkChartCode = b.LinkChartCode and a.Category = b.Category and a.Product = b.Product 
  and a.Lev = b.Lev and a.Currency = b.Currency 
  and a.TimeFrame = b.TimeFrame and a.XIdx = b.XIdx
where a.LinkChartCode in('R191','R251','R201','R261','R211','R271','R221','R281','R231','R291','R241','R301','R901','R961')	
      and a.IsShow = 'Y'
go

-- set market share
update OutputHospital_All 
set Y = case when AddY = 0 then 0 else cast(y as float) / AddY end
where LinkChartCode in('R191','R251','R201','R261','R211','R271','R221','R281','R231','R291','R241','R301','R901','R961')
	and IsShow = 'Y'
go

update OutputHospital_All 
set Y = null
where LinkChartCode in('R191','R251','R201','R261','R211','R271','R221','R281','R231','R291','R241','R301','R901','R961')
	and cast(Y as float) = 0
	and IsShow = 'Y'
go

-- remove Taxol Others
-- remove ARV other/NIAD Other
delete OutputHospital_All
where LinkChartCode in('R191','R251','R201','R261','R211','R271','R221','R281','R231','R291','R241','R301','R901','R961')
	and Series in('ARV Others','NIAD Others','Taxol Others')
	and IsShow = 'Y'
go

-- set the data in table
update OutputHospital_All 
set Y = case a.Category
        when 'VMAT' then case when b.VMAT2 = 0 then null else b.VMAT1/b.VMAT2-1 end
        when 'UMAT' then case when b.UMAT2 = 0 then null else b.UMAT1/b.UMAT2-1 end
        when 'VYTD' then case when b.[VYTDStly] = 0 then null else b.[VYTD]/b.[VYTDStly]-1 end
        when 'UYTD' then case when b.[UYTDStly] = 0 then null else b.[UYTD]/b.[UYTDStly]-1 end
        end 
from OutputHospital_All a
inner join tempHospitalDataByTier b on
	a.Product = b.Mkt and a.SeriesIdx = b.Prod and a.x = b.cpa_id
where a.LinkChartCode in('R191','R251','R201','R261','R211','R271','R221','R281','R231','R291','R241','R301','R901','R961')
	and a.IsShow = 'D'
go

update OutputHospital_All set 
Category = case left(Category,1) when 'U' then 'Volume' when 'V' then 'Value' when 'P' then 'Adjusted patient number' end,
Currency = case left(Currency,1) when 'U' then 'UNIT' when 'P' then 'UNIT' WHEN  'V' THEN 'RMB' END,


	TimeFrame = case right(TimeFrame,len(TimeFrame)-1) 
              when 'MAT' THEN 'MAT' 
              WHEN 'R3M' THEN 'MQT' 
              WHEN 'YTD' THEN 'YTD' END
where LinkChartCode in('R191','R251','R201','R261','R211','R271','R221','R281','R231','R291','R241','R301','R901','R961')
go

update OutputHospital_All set Product = b.Product
from OutputHospital_All a 
inner join (select distinct Product,Mkt from tblMktDefHospital) b on a.Product = b.Mkt
where a.LinkChartCode in('R191','R251','R201','R261','R211','R271','R221','R281','R231','R291','R241','R301','R901','R961')
go

insert into OutputHospital_All (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y,AddY, IsShow)
select 
    LinkChartCode
  , LinkSeriesCode
  , Series
  , SeriesIdx
  , Category
  , Product
  , Lev
  , ParentGeo
  , Geo
  , 'USD'
  , TimeFrame
  , X
  , XIdx
  , Y
  , AddY/ (select Rate from BMSChinaCIA_IMS.dbo.tblRate) as AddY
  , IsShow
from OutputHospital_All 
where LinkChartCode  in('R191','R251','R201','R261','R211','R271','R221','R281','R231','R291','R241','R301','R901','R961') 
      and Currency = 'RMB'
go

update OutputHospital_All set LinkedY = convert(varchar(50),cast(round(AddY,0) as Money),1)
where LinkChartCode in('R191','R251','R201','R261','R211','R271','R221','R281','R231','R291','R241','R301','R901','R961')
	and IsShow = 'Y'
go

update OutputHospital_All set LinkedY = left(LinkedY,len(LinkedY)-3)
where LinkChartCode in('R191','R251','R201','R261','R211','R271','R221','R281','R231','R291','R241','R301','R901','R961')
	and IsShow = 'Y'
go
update OutputHospital_All set X = left(b.Cpa_Name_English,37) + ' (' + LinkedY + ')'
from OutputHospital_All a
inner join tblHospitalMaster b on a.x = b.id
where a.LinkChartCode in ('R191','R251','R201','R261','R211','R271','R221','R281','R231','R291','R241','R301','R901','R961') and isShow = 'Y'
	and IsShow = 'Y'
go
update OutputHospital_All set X = left(b.Cpa_Name_English,50)
from OutputHospital_All a
inner join tblHospitalMaster b on a.x = b.id
where a.LinkChartCode in ('R191','R251','R201','R261','R211','R271','R221','R281','R231','R291','R241','R301','R901','R961') and isShow = 'Y'
	and IsShow = 'D'
go

-- data of The table in these slide are growth
update OutputHospital_All set Series = Series + ' GR'
where LinkChartCode IN('R191','R251','R201','R261','R211','R271','R221','R281','R231','R291','R241','R301','R901','R961')
	and IsShow = 'D'
go



-- R192
-- Top Dia/HYP Market Tier 3 hospital Performance by BMS Product
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R192' AS LinkChartCode,
	'R192' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
	b.Series, b.SeriesIdx, B.Category, a.Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
from (
	select distinct Mkt Product
	from dbo.tblMktDefHospital 
	where mkt in ('NIAD','HYPFCS','CCB') and FocusedBrand = 'Y' and Molecule = 'N' and Class = 'N' and Prod = '100'
) a, (
	select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
	from tempHospitalDataByTier where Mkt in('DIA','HYPFCS','CCB') and Tier = '3' and Prod = '000' and VMATRANK <= 7
	union all
	select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
	from tempHospitalDataByTier where Mkt in('DIA','HYPFCS','CCB') and Tier = '3' and Prod = '000' and UMATRANK <= 7
	union all
  select Mkt,'VYTD' as Category,cpa_id as Series,VYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('Dia','HYPFCS','CCB') and Tier = '3' and Prod = '000' and VYTDRANK <= 7
  Union all
  select Mkt,'UYTD' as Category,cpa_id as Series,UYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('Dia','HYPFCS','CCB') and Tier = '3' and Prod = '000' and UYTDRANK <= 7
)b, (
	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
)c
where a.Product = case when b.Mkt ='Dia' then 'NIAD' when b.Mkt = 'HYP' then 'HYPFCS' else b.Mkt end
go

-- R252
-- Top Dia/HYP Market Tier 2 hospital Performance by BMS Product
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R252' AS LinkChartCode,
	'R252' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
	b.Series, b.SeriesIdx, B.Category, a.Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
from (
	select distinct Mkt Product
	from dbo.tblMktDefHospital 
	where mkt in ('niad','HYPFCS','CCB') and FocusedBrand = 'Y' and Molecule = 'N' and Class = 'N' and Prod = '100'
) a, (
	select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
	from tempHospitalDataByTier where Mkt in('Dia','HYPFCS','CCB') and Tier = '2' and Prod = '000' and VMATRANK <= 7
	union all
	select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
	from tempHospitalDataByTier where Mkt in('Dia','HYPFCS','CCB') and Tier = '2' and Prod = '000' and UMATRANK <= 7
	union all
  select Mkt,'VYTD' as Category,cpa_id as Series,VYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('Dia','HYPFCS','CCB') and Tier = '2' and Prod = '000' and VYTDRANK <= 7
  Union all
  select Mkt,'UYTD' as Category,cpa_id as Series,UYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('Dia','HYPFCS','CCB') and Tier = '2' and Prod = '000' and UYTDRANK <= 7
)b, (
	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
)c
where a.Product = case when b.Mkt ='Dia' then 'NIAD' when b.Mkt = 'HYP' then 'HYPFCS' else b.Mkt end
go

-- R902
-- Top HYP Market Tier 3 hospital Performance by Class
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R902' AS LinkChartCode,
	'R902' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
	b.Series, b.SeriesIdx, B.Category, a.Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
from (
	select distinct Mkt Product
	from dbo.tblMktDefHospital 
	where mkt in ('HYP') and FocusedBrand = 'N' and Molecule = 'N' and Class = 'Y' and prod ='910'
) a, (
  select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('HYP') and Tier = '3' and Prod = '000' and VMATRANK <= 7
  union all
  select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('HYP') and Tier = '3' and Prod = '000' and UMATRANK <= 7
  union all
  select Mkt,'VYTD' as Category,cpa_id as Series,VYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('HYP') and Tier = '3' and Prod = '000' and VYTDRANK <= 7
  Union all
  select Mkt,'UYTD' as Category,cpa_id as Series,UYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('HYP') and Tier = '3' and Prod = '000' and UYTDRANK <= 7
)b, (
	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
)c
where a.Product = b.Mkt
go


-- R962
-- Top HYP Market Tier 2 hospital Performance by Class
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R962' AS LinkChartCode,
	'R962' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
	b.Series, b.SeriesIdx, B.Category, a.Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
from (
	select distinct Mkt Product
	from dbo.tblMktDefHospital 
	where mkt in ('HYP') and FocusedBrand = 'N' and Molecule = 'N' and Class = 'Y' and prod ='910'
) a, (
	select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
	from tempHospitalDataByTier where Mkt in('HYP') and Tier = '2' and Prod = '000' and VMATRANK <= 7
	union all
	select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
	from tempHospitalDataByTier where Mkt in('HYP') and Tier = '2' and Prod = '000' and UMATRANK <= 7
	union all
  select Mkt,'VYTD' as Category,cpa_id as Series,VYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('HYP') and Tier = '2' and Prod = '000' and VYTDRANK <= 7
  Union all
  select Mkt,'UYTD' as Category,cpa_id as Series,UYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('HYP') and Tier = '2' and Prod = '000' and UYTDRANK <= 7
)b, (
	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
)c
where a.Product = b.Mkt
go


-- R202
-- Top NIAD Market Tier 3 hospital DPP-IV Performance
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R202' AS LinkChartCode,
	'R202' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
	b.Series, b.SeriesIdx, B.Category, a.Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
from (
	select distinct Mkt Product
	from dbo.tblMktDefHospital 
	where mkt in ('NIAD') and FocusedBrand = 'N' and Molecule = 'N' and Class = 'Y'
) a, (
  select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD') and Tier = '3' and Prod = '000' and VMATRANK <= 7
  union all
  select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD') and Tier = '3' and Prod = '000' and UMATRANK <= 7
  union all
  select Mkt,'VYTD' as Category,cpa_id as Series,VYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD') and Tier = '3' and Prod = '000' and VYTDRANK <= 7
  Union all
  select Mkt,'UYTD' as Category,cpa_id as Series,UYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD') and Tier = '3' and Prod = '000' and UYTDRANK <= 7
)b, (
	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
)c
where a.Product = b.Mkt
go


-- R262
-- Top NIAD Market Tier 2 hospital DPP-IV Performance
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R262' AS LinkChartCode,
	'R262' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
	b.Series, b.SeriesIdx, B.Category, a.Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
from (
	select distinct Mkt Product
	from dbo.tblMktDefHospital 
	where mkt in ('NIAD') and FocusedBrand = 'N' and Molecule = 'N' and Class = 'Y'
) a, (
  select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD') and Tier = '2' and Prod = '000' and VMATRANK <= 7
  union all
  select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD') and Tier = '2' and Prod = '000' and UMATRANK <= 7
  union all
  select Mkt,'VYTD' as Category,cpa_id as Series,VYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD') and Tier = '3' and Prod = '000' and VYTDRANK <= 7
  Union all
  select Mkt,'UYTD' as Category,cpa_id as Series,UYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD') and Tier = '3' and Prod = '000' and UYTDRANK <= 7
)b, (
	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
)c
where a.Product = b.Mkt
go


-- R212
-- Top NIAD/ACE/ARV/ONCFCS Tier 3 hospital Performance by BMS Product
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R212' AS LinkChartCode,
  'R212' + cast(b.SeriesIdx as varchar) as LinkSeriesCode
  ,b.Series, b.SeriesIdx, B.Category, a.Product, 
  'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
from (
	select distinct Mkt Product
	from dbo.tblMktDefHospital 
	where mkt in ('NIAD','ACE','ARV','ONCFCS') and FocusedBrand = 'Y' and Molecule = 'N' and Class = 'N' and Prod = '100'
) a, (
  select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '3' and Prod = '000' and VMATRANK <= 7
  union all
  select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '3' and Prod = '000' and UMATRANK <= 7
  union all
  select Mkt,'VYTD' as Category,cpa_id as Series,VYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '3' and Prod = '000' and VYTDRANK <= 7
  Union all
  select Mkt,'UYTD' as Category,cpa_id as Series,UYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','ACE','ARV','ONCFCS') and Tier = '3' and Prod = '000' and UYTDRANK <= 7
)b, (
	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
)c
where a.Product = b.Mkt
go

-- R232
-- Top Glocuphage/Baraclude/Taxol/Monopril Tier 3 hospital Performance by Brands
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R232' AS LinkChartCode,
	'R232' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
	b.Series, b.SeriesIdx, B.Category, a.Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
from (
	select distinct Mkt Product
	from dbo.tblMktDefHospital 
	where mkt in ('NIAD','HYPFCS','ARV','ONCFCS','CCB') and FocusedBrand = 'Y' and Molecule = 'N' and Class = 'N' and Prod = '100'
) a, (
  select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '3' and Prod = '100' and VMATRANK <= 7
  union all
  select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '3' and Prod = '100' and UMATRANK <= 7
  union all
  select Mkt,'VYTD' as Category,cpa_id as Series,VYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '3' and Prod = '100' and VYTDRANK <= 7
  Union all
  select Mkt,'UYTD' as Category,cpa_id as Series,UYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '3' and Prod = '100' and UYTDRANK <= 7
)b, (
	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
)c
where a.Product = b.Mkt
go


-- R292
-- Top Dia/HYP Market Tier 2 hospital Performance by BMS Product
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R292' AS LinkChartCode,
	'R292' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
	b.Series, b.SeriesIdx, B.Category, a.Product, 
	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
from (
	select distinct Mkt Product
	from dbo.tblMktDefHospital 
	where mkt in ('NIAD','HYPFCS','ARV','ONCFCS','CCB') and FocusedBrand = 'Y' and Molecule = 'N' and Class = 'N' and Prod = '100'
) a, (
  select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '2' and Prod = '100' and VMATRANK <= 7
  union all
  select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '2' and Prod = '100' and UMATRANK <= 7
  union all
  select Mkt,'VYTD' as Category,cpa_id as Series,VYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '3' and Prod = '100' and VYTDRANK <= 7
  Union all
  select Mkt,'UYTD' as Category,cpa_id as Series,UYTDRANK as SeriesIdx  
  from tempHospitalDataByTier where Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Tier = '3' and Prod = '100' and UYTDRANK <= 7
)b, (
	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
)c
where a.Product = b.Mkt
go


-- set the data for tier 3/2 in China
declare @i int, @sql varchar(2000), @m varchar(6)
set @i = 1
while @i <= 12
begin
	select @m = mth from tblHospitalMthList where Idx = @i
	set @sql = '
update OutputHospital_All set Y = case a.Category
	-- R3M Share
	when ''VR3M'' then VR3MShr' + cast(@i as varchar) + '
	when ''UR3M'' then UR3MShr' + cast(@i as varchar) + ' end
from OutputHospital_All a
inner join tempHospitalDataByTier b on a.Product = b.Mkt  and a.Series =b.cpa_id
	and b.Prod = case when a.LinkChartCode in(''R902'',''R962'') then ''910'' when a.LinkChartCode in(''R202'',''R262'') then ''930'' else ''100'' end
WHERE A.LinkChartCode in (''R192'',''R202'',''R212'',''R222'',''R232'',''R242'',''R902'',''R252'',''R262'',''R272'',''R282'',''R292'',''R302'',''R962'') 
	AND a.IsShow = ''Y'' and A.x = ''' + @m + ''' and b.Lev = ''Nat'''
	-- print @sql
	exec(@sql)
set @i = @i + 1
end
go


delete OutputHospital_All
from --select * from 
OutputHospital_All a
where exists( 
select * from (
               select LinkChartCode,Category, Product, Lev,ParentGeo,Geo,Currency,TimeFrame, Series
               from OutputHospital_All
               where LinkChartCode in ('R192','R252','R202','R262','R212','R272','R222','R282','R232','R292','R242','R302','R902','R962')
               	and IsShow = 'Y' and y = '0'
               group by LinkChartCode,Category, Product, Lev,ParentGeo,Geo,Currency,TimeFrame,Series
               having count(*) = 12
              ) b 
where 
a.LinkChartCode =b.linkChartCode
and a.Category = b.Category
and a.Product = b.Product
and a.Lev = b.Lev
and a.Geo = b.Geo
and a.Currency = b.Currency
and a.TimeFrame = b.TimeFrame
and a.Series = b.Series
)
-- order by linkchartcode,product,category, currency, timeframe,seriesidx,xidx
go


-- R480 Top 20 CPA Hospitals
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
    'R480' AS LinkChartCode
  , 'R480' + cast(1 as varchar) as LinkSeriesCode
  , 'MAT' as Series, 1 AS SeriesIdx
  , B.Category
  , B.Mkt as Product
  , 'Nat' Lev
  , 'China' Geo
  , B.Category
  , B.Category
  , B.X
  , B.Xidx
  ,MAT as Y
  , 'Y'
from (
  select Mkt,'VMAT' as Category,cpa_id as X,VMAT1 MAT,VMATDSRANK as XIdx  
  from tempHospitalDataByTier where DataSource = 'CPA' and Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and Prod = '000' and VMATDSRANK <= 20
  union all
  select Mkt,'UMAT' as Category,cpa_id as X,UMAT1 MAT, UMATDSRANK as XIdx  
  from tempHospitalDataByTier where DataSource = 'CPA' and Mkt in('NIAD','HYPFCS','ARV','ONCFCS','CCB') and  Prod = '000' and UMATDSRANK <= 20
  --?
)b
go


-- Update the fields in tables: Cagetory/Currency/timeFrame/Product
update OutputHospital_All set 
Category = case left(Category,1) when 'U' then 'Volume' when 'V' then 'Value' when 'P' then 'Adjusted patient number' end,
Currency = case left(Currency,1) when 'U' then 'UNIT' when 'P' then 'UNIT' WHEN  'V' THEN 'RMB' END,
	TimeFrame = case right(TimeFrame,len(TimeFrame)-1) when 'MAT' THEN 'MAT' 
	                                                   WHEN 'R3M' THEN 'MQT' 
	                                                   WHEN 'YTD' THEN 'YTD' END
where LinkChartCode in ('R192','R252','R202','R262','R212','R272','R222','R282','R232','R292','R242','R302','R902','R962','R480')
go
update OutputHospital_All set Product = b.Product
from OutputHospital_All a 
inner join (select distinct Product,Mkt from tblMktDefHospital) b 
on a.Product = b.Mkt
where a.LinkChartCode in ('R192','R252','R202','R262','R212','R272','R222','R282','R232','R292','R242','R302','R902','R962','R480')
go
insert into OutputHospital_All (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
select 
    LinkChartCode
  , LinkSeriesCode
  , Series
  , SeriesIdx
  , Category
  , Product
  , Lev
  , ParentGeo
  , Geo
  , 'USD'
  , TimeFrame
  , X
  , XIdx
  , Y
  , IsShow
from OutputHospital_All 
where LinkChartCode in ('R192','R252','R202','R262','R212','R272','R222','R282','R232','R292','R242','R302','R902','R962') and Currency = 'RMB'
go
insert into OutputHospital_All (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
select 
    LinkChartCode
  , LinkSeriesCode
  , Series
  , SeriesIdx
  , Category
  , Product
  , Lev
  , ParentGeo
  , Geo
  , 'USD'
  , TimeFrame
  , X
  , XIdx
  , cast(Y as Float)/(select Rate from BMSChinaCIA_IMS.dbo.tblRate) AS y
  , IsShow
from OutputHospital_All where LinkChartCode ='R480' and Currency = 'RMB'
go
update OutputHospital_All set Series = left(b.Cpa_Name_English,50) 
from OutputHospital_All a
inner join tblHospitalMaster b on a.Series = b.id
where a.LinkChartCode in ('R192','R252','R202','R262','R212','R272','R222','R282','R232','R292','R242','R302','R902','R962') and isShow = 'Y'
go
update OutputHospital_All set X = left(b.Cpa_Name_English,50) 
from OutputHospital_All a
inner join tblHospitalMaster b on a.X = b.id
where a.LinkChartCode ='R480' and isShow = 'Y'
go
update OutputHospital_All set X = 'MQT ' + Replace(right(convert(varchar(11),convert(datetime,x +'01',112),6),6),' ','''')
where LinkChartCode IN('R192','R252','R202','R262','R212','R272','R222','R282','R232','R292','R242','R302','R902','R962')
go
-- reverse the Month to ascending order
update OutputHospital_All set XIdx = 13 - Xidx
where LinkChartCode IN('R192','R252','R202','R262','R212','R272','R222','R282','R232','R292','R242','R302','R902','R962')
go




---------------------------------
-- C170 -- baraclude nation BAL hospital data 
---------------------------------


if object_id(N'tempBALHospitalDataByGeo',N'U') is not null
	drop table tempBALHospitalDataByGeo
go 

SELECT b.RMName, c.* 
into tempBALHospitalDataByGeo
FROM tblHospitalMaster AS a
RIGHT JOIN tblBALHospital AS b ON a.BMS_Code = b.HospCode
INNER JOIN tempHospitalDataByGeo AS c ON a.id = c.Cpa_id


update tempBALHospitalDataByGeo 
set geo = case geo when 'East1' then 'East I' when 'East2' then 'East II' else geo end ,
    ParentGeo = case ParentGeo when 'East1' then 'East I' when 'East2' then 'East II' else ParentGeo end 

go 

if object_id(N'OutputBALHospitalDataByGeo',N'U') is not null
	drop table OutputBALHospitalDataByGeo
go 

SELECT product, RMName,  datasource, a.mkt, a.Prod , 
  sum([UM1]) as [UM1], sum(VM1) as [VM1], 
  sum([UM12]) as [UM12], sum(VM12) as [VM12], 
  sum([UR3M1]) as [UR3M1], sum([VR3M1]) as [VR3M1],
  sum([UR3M12]) as [UR3M12], sum([VR3M12]) as [VR3M12],
  sum([UYTD]) as [UYTD], sum([VYTD]) as [VYTD],
  sum([UYTDStly]) as [UYTDStly], sum([VYTDStly]) as [VYTDStly],
  sum([UMAT1]) as [UMAT1], sum([VMAT1]) as [VMAT1],
  sum([UMAT2]) as [UMAT2], sum([VMAT2]) as [VMAT2]
into OutputBALHospitalDataByGeo
FROM tempBALHospitalDataByGeo AS a 
INNER JOIN (select distinct Prod  from BMSChinaMRBI.dbo.tblMktDefHospital  where Mkt = 'Arv' and molecule = 'N' ) AS b 
ON a.prod = b.prod 
WHERE a.mkt = 'arv' and a.lev = 'nat' and product = 'Baraclude'
GROUP BY Product, RMName, datasource, a.mkt, a.Prod 

go 


if object_id(N'OutputBALHospitalDataRullupByProd',N'U') is not null
	drop table OutputBALHospitalDataRullupByProd
go 

SELECT product, RMName,  datasource, a.mkt , 
  sum([UM1]) as [UM1], sum(VM1) as [VM1], 
  sum([UR3M1]) as [UR3M1], sum([VR3M1]) as [VR3M1],
  sum([UYTD]) as [UYTD], sum([VYTD]) as [VYTD],
  sum([UMAT1]) as [UMAT1], sum([VMAT1]) as [VMAT1]
into OutputBALHospitalDataRullupByProd
FROM OutputBALHospitalDataByGeo AS a 
WHERE  prod <> '000'
GROUP BY product, RMName,  datasource, a.mkt 

go 


if object_id(N'OutputBALHospitalDataGrowth',N'U') is not null
	drop table OutputBALHospitalDataGrowth
go 


SELECT product, RMName,  datasource, a.mkt ,  a.Prod , 
  [UM1]/[UM12] - 1 as [UM1], VM1/VM12 - 1 as [VM1], 
  [UR3M1]/[UR3M12] - 1 as [UR3M1], [VR3M1]/[VR3M12] - 1 as [VR3M1],
  [UYTD]/[UYTDStly] - 1 as [UYTD], [VYTD]/[VYTDStly] - 1 as [VYTD],
  [UMAT1]/[UMAT2] - 1 as [UMAT1], [VMAT1]/[VMAT2] - 1 as [VMAT1]
into OutputBALHospitalDataGrowth
FROM OutputBALHospitalDataByGeo AS a 


go

DELETE OutputHospital_All WHERE LinkChartCode = 'C170'
go
insert into OutputHospital_All(LinkChartCode, Series, SeriesIdx, Category, Product, Lev, Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
   'C170' AS LinkChartCode   -- LinkChartCode
   ,a.Series                 -- Series       
   ,a.SeriesIdx              -- SeriesIdx    
   ,c.Category               -- Category     
   ,'ARV' as Product         -- Product      
   ,'Nation' as Lev          -- Lev          
   ,'China' as Geo           -- Geo          
   ,c.Currency               -- Currency     
   ,'MAT'              -- TimeFrame    
   ,b.X                      -- X            
   ,b.Xidx                   -- XIdx         
   ,null                     -- Y             
   ,'Y'                      -- IsShow       
from 
  (
    select distinct Prod as SeriesIdx,ProductName as Series
    from tblMktDefHospital
    where Mkt = 'ARV' and Molecule = 'N' AND prod NOT IN ('000')

  ) a, 
  (
    SELECT RMName AS x, RANK() OVER( ORDER BY  RMName) as XIdx 
    FROM (
      SELECT DISTINCT RMName  from OutputBALHospitalDataByGeo 
    ) AS a 
  ) b, 
  (
    select 'Value' as Category, 'RMB' as Currency 
    union all
    select 'Volume' as Category,'UNIT' as Currency 
  ) c


insert into OutputHospital_All(LinkChartCode, Series, SeriesIdx, Category, Product, Lev, Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
   'C170' AS LinkChartCode   -- LinkChartCode
   ,a.Series                 -- Series       
   ,a.SeriesIdx              -- SeriesIdx    
   ,c.Category               -- Category     
   ,'ARV' as Product         -- Product      
   ,'Nation' as Lev          -- Lev          
   ,'China' as Geo           -- Geo          
   ,c.Currency               -- Currency     
   ,'MQT'              -- TimeFrame    
   ,b.X                      -- X            
   ,b.Xidx                   -- XIdx         
   ,null                     -- Y             
   ,'Y'                      -- IsShow       
from 
  (
    select distinct Prod as SeriesIdx,ProductName as Series
    from tblMktDefHospital
    where Mkt = 'ARV' and Molecule = 'N' AND prod NOT IN ('000')
  ) a, 
  (
    SELECT RMName AS x, RANK() OVER( ORDER BY  RMName) as XIdx 
    FROM (
      SELECT DISTINCT RMName  from OutputBALHospitalDataByGeo 
    ) AS a 
  ) b, 
  (
    select 'Value' as Category, 'RMB' as Currency 
    union all
    select 'Volume' as Category,'UNIT' as Currency 
  ) c


insert into OutputHospital_All(LinkChartCode, Series, SeriesIdx, Category, Product, Lev, Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
   'C170' AS LinkChartCode   -- LinkChartCode
   ,a.Series                 -- Series       
   ,a.SeriesIdx              -- SeriesIdx    
   ,c.Category               -- Category     
   ,'ARV' as Product         -- Product      
   ,'Nation' as Lev          -- Lev          
   ,'China' as Geo           -- Geo          
   ,c.Currency               -- Currency     
   ,'MTH'              -- TimeFrame    
   ,b.X                      -- X            
   ,b.Xidx                   -- XIdx         
   ,null                     -- Y             
   ,'Y'                      -- IsShow       
from 
  (
    select distinct Prod as SeriesIdx,ProductName as Series
    from tblMktDefHospital
    where Mkt = 'ARV' and Molecule = 'N' AND prod NOT IN ('000')
  ) a, 
  (
    SELECT RMName AS x, RANK() OVER( ORDER BY  RMName) as XIdx 
    FROM (
      SELECT DISTINCT RMName  from OutputBALHospitalDataByGeo 
    ) AS a 
  ) b, 
  (
    select 'Value' as Category, 'RMB' as Currency 
    union all
    select 'Volume' as Category,'UNIT' as Currency 
  ) c


insert into OutputHospital_All(LinkChartCode, Series, SeriesIdx, Category, Product, Lev, Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
   'C170' AS LinkChartCode   -- LinkChartCode
   ,a.Series                 -- Series       
   ,a.SeriesIdx              -- SeriesIdx    
   ,c.Category               -- Category     
   ,'ARV' as Product         -- Product      
   ,'Nation' as Lev          -- Lev          
   ,'China' as Geo           -- Geo          
   ,c.Currency               -- Currency     
   ,'YTD'              -- TimeFrame    
   ,b.X                      -- X            
   ,b.Xidx                   -- XIdx         
   ,null                     -- Y             
   ,'Y'                      -- IsShow       
from 
  (
    select distinct Prod as SeriesIdx,ProductName as Series
    from tblMktDefHospital
    where Mkt = 'ARV' and Molecule = 'N' AND prod NOT IN ('000')
  ) a, 
  (
    SELECT RMName AS x, RANK() OVER( ORDER BY  RMName) as XIdx 
    FROM (
        SELECT DISTINCT RMName  from OutputBALHospitalDataByGeo 
      ) AS a 
  ) b, 
  (
    select 'Value' as Category, 'RMB' as Currency 
    union all
    select 'Volume' as Category,'UNIT' as Currency 
  ) c
go

update OutputHospital_All 
set Y = 
  case when a.category = 'Value' and a.TimeFrame = 'MAT' then VMat1 
        when a.category = 'Volume' and a.TimeFrame = 'MAT' then UMat1 
        when a.category = 'Value' and a.TimeFrame = 'YTD' then VYTD
        when a.category = 'Volume' and a.TimeFrame = 'YTD' then UYTD
        when a.category = 'Value' and a.TimeFrame = 'MQT' then VR3M1 
        when a.category = 'Volume' and a.TimeFrame = 'MQT' then UR3M1 
        when a.category = 'Value' and a.TimeFrame = 'MTH' then VM1 
        when a.category = 'Volume' and a.TimeFrame = 'MTH' then UM1 
  end
from OutputHospital_All a
inner join OutputBALHospitalDataByGeo b on a.Product = b.mkt and a.SeriesIdx = cast(b.Prod as int) and a.X = b.RMName 
where a.LinkChartCode = 'C170' 

go 

-- update OutputHospital_All 
-- set X = X + '(' + CONVERT(VARCHAR(20), CONVERT(DECIMAL(22,6), Y)) + ')' 
-- where LinkChartCode ='C170'
GO 

update OutputHospital_All 
set Y = 
	case  
   when a.category = 'Value' and a.TimeFrame = 'MAT'  then case when b.vmat1 = 0 then null else a.Y/b.vmat1 end
   when a.category = 'Volume' and a.TimeFrame = 'MAT'  then case when b.UMat1 = 0 then null else a.Y/b.UMat1 end
   when a.category = 'Value' and a.TimeFrame = 'YTD'  then case when b.VYTD = 0 then null else a.Y/b.VYTD end
   when a.category = 'Volume' and a.TimeFrame = 'YTD'  then case when b.UYTD = 0 then null else a.Y/b.UYTD end
   when a.category = 'Value' and a.TimeFrame = 'MQT' then case when b.VR3M1 = 0 then null else a.Y/b.VR3M1 end
   when a.category = 'Volume' and a.TimeFrame = 'MQT' then case when b.UR3M1 = 0 then null else a.Y/b.UR3M1 end
   when a.category = 'Value' and a.TimeFrame = 'MTH' then case when b.VM1 = 0 then null else a.Y/b.VM1 end
   when a.category = 'Volume' and a.TimeFrame = 'MTH' then case when b.UM1 = 0 then null else a.Y/b.UM1 end 
   end 
from OutputHospital_All a
inner join OutputBALHospitalDataRullupByProd b on  a.Product = b.Mkt  and a.X = b.RMName 
where a.LinkChartCode = 'C170' 
go

-- insert USD records according RMB 
insert into OutputHospital_All (LinkChartCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
SELECT	LinkChartCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, 'USD', TimeFrame, X, XIdx, Y, IsShow
FROM	OutputHospital_All
WHERE	LinkChartCode IN ( 'C170' )
		AND Currency = 'RMB'
go


-- insert brandreport data about growth 
insert into OutputHospital_All (LinkChartCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
SELECT	LinkChartCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, 'L'
from OutputHospital_All 
where LinkChartCode in ('C170') 
go 


update a
set Y = 
	case  
		when a.category = 'Value' 	and a.TimeFrame = 'MAT' and a.Currency = 'RMB'  then b.vmat1 
		when a.category = 'Value' 	and a.TimeFrame = 'MAT' and a.Currency = 'USD'  then b.vmat1 
		when a.category = 'Volume' 	and a.TimeFrame = 'MAT' and a.Currency = 'UNIT'  then b.UMat1  
		when a.category = 'Value' 	and a.TimeFrame = 'YTD' and a.Currency = 'RMB'  then b.VYTD 
		when a.category = 'Value' 	and a.TimeFrame = 'YTD' and a.Currency = 'USD'  then b.VYTD 
		when a.category = 'Volume' 	and a.TimeFrame = 'YTD' and a.Currency = 'UNIT'  then b.UYTD 
		when a.category = 'Value' 	and a.TimeFrame = 'MQT' and a.Currency = 'RMB'  then b.VR3M1  
		when a.category = 'Value' 	and a.TimeFrame = 'MQT' and a.Currency = 'USD'  then b.VR3M1  
		when a.category = 'Volume' 	and a.TimeFrame = 'MQT' and a.Currency = 'UNIT'  then b.UR3M1  
		when a.category = 'Value' 	and a.TimeFrame = 'MTH' and a.Currency = 'RMB'  then b.VM1
		when a.category = 'Value' 	and a.TimeFrame = 'MTH' and a.Currency = 'USD'  then b.VM1
		when a.category = 'Volume' 	and a.TimeFrame = 'MTH' and a.Currency = 'UNIT'  then b.UM1 
	end
from OutputHospital_All as a
inner join OutputBALHospitalDataGrowth b on  a.Product = b.Mkt  and a.X = b.RMName AND a.SeriesIdx = b.Prod
where a.IsShow = 'L' and a.LinkChartCode = 'C170' 

go 

declare @rate float 
set @rate = ( SELECT Rate FROM BMSChinaCIA_IMS.dbo.tblRate ) 

update OutputHospital_All 
set X =
	case  
	   when a.category = 'Value' and a.Currency = 'USD' and a.TimeFrame = 'MAT'  then   X + '(' + convert(varchar(20), convert(decimal(22, 0), b.vmat1/@rate )) + ')'  
	   when a.category = 'Value' and a.Currency = 'USD' and a.TimeFrame = 'YTD'  then   X + '(' + convert(varchar(20), convert(decimal(22, 0), b.VYTD/@rate  )) + ')'  
	   when a.category = 'Value' and a.Currency = 'USD' and a.TimeFrame = 'MQT'  then   X + '(' + convert(varchar(20), convert(decimal(22, 0), b.VR3M1/@rate )) + ')'  
	   when a.category = 'Value' and a.Currency = 'USD' and a.TimeFrame = 'MTH'  then   X + '(' + convert(varchar(20), convert(decimal(22, 0), b.VM1/@rate   )) + ')'  
	   when a.category = 'Value' and a.Currency = 'RMB' and a.TimeFrame = 'MAT'  then   X + '(' + convert(varchar(20), convert(decimal(22, 0), b.vmat1 )) + ')'  
	   when a.category = 'Volume' and a.TimeFrame = 'MAT' then   X + '(' + convert(varchar(20), convert(decimal(22, 0), b.UMat1 )) + ')'  
	   when a.category = 'Value' and a.Currency = 'RMB' and a.TimeFrame = 'YTD'  then   X + '(' + convert(varchar(20), convert(decimal(22, 0), b.VYTD  )) + ')'  
	   when a.category = 'Volume' and a.TimeFrame = 'YTD' then   X + '(' + convert(varchar(20), convert(decimal(22, 0), b.UYTD  )) + ')'  
	   when a.category = 'Value' and a.Currency = 'RMB' and a.TimeFrame = 'MQT'  then   X + '(' + convert(varchar(20), convert(decimal(22, 0), b.VR3M1 )) + ')'  
	   when a.category = 'Volume' and a.TimeFrame = 'MQT' then   X + '(' + convert(varchar(20), convert(decimal(22, 0), b.UR3M1 )) + ')'  
	   when a.category = 'Value' and a.Currency = 'RMB' and a.TimeFrame = 'MTH'  then   X + '(' + convert(varchar(20), convert(decimal(22, 0), b.VM1   )) + ')'  
	   when a.category = 'Volume' and a.TimeFrame = 'MTH' then   X + '(' + convert(varchar(20), convert(decimal(22, 0), b.UM1   )) + ')'   
	   END 
from OutputHospital_All a
inner join OutputBALHospitalDataRullupByProd b on  a.Product = b.Mkt  and a.X = b.RMName 
where a.LinkChartCode = 'C170' 
go 

update OutputHospital_All 
set Product = b.Product
from OutputHospital_All a 
inner join (select distinct Product,Mkt from tblMktDefHospital) b on a.Product = b.Mkt
where a.LinkChartCode = 'C170'
go 




-- 通常要半小时多
exec dbo.sp_Log_Event 'Output','CIA_CPA','3_1_Out.sql','End',null,null





print 'over!'