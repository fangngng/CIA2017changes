use BMSChinaMRBI


--log
exec dbo.sp_Log_Event 'output','CIA_CPA','3_5_Eliquis_NOAC_CPA.sql','Start',null,null
go
-- D051: Region Top 10 Hospital
delete from OutputHospital_All where LinkChartCode='D051'
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
  'D051' AS LinkChartCode
 , 'D051' + cast(SeriesIdx as varchar) as LinkSeriesCode
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
	from OutputTopCPA where Lev = 'Region' and Mkt in ('Eliquis NOAC') and prod = '000'
)b
go

update OutputHospital_All set Y = 
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
where a.LinkChartCode = 'D051' and a.SeriesIdx = 1 and b.Prod = '000'
go

update OutputHospital_All set Y = 
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
where a.LinkChartCode = 'D051' and a.SeriesIdx = 2 and b.Prod = '100'
go

update OutputHospital_All set Y = 
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
where a.LinkChartCode = 'D051' and a.SeriesIdx = 3 and b.Prod = '000'
go

update OutputHospital_All set Y = 
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
where a.LinkChartCode = 'D051' and a.SeriesIdx = 4 and b.Prod = '100'
go

update OutputHospital_All set Series=
	case Product 
	when 'HYPFCS' then 'Monopril Market' 
	when 'NIAD' then 'NIAD Market' 
	when 'ONCFCS' then 'Taxol Market' 
	when 'ARV' then 'ARV Market' 
	when 'Platinum' then 'Platinum Market' 
	when 'CCB' then 'Coniel Market'
	WHEN 'Eliquis NOAC' THEN 'Eliquis (NOAC) Market'
	else Series end
where LinkChartCode = 'D051'  and Series = 'Market'
go

update OutputHospital_All set Series=
	case Product 
	when 'HYPFCS' then 'Monopril' 
	when 'NIAD' then 'Glucophage' 
	when 'ONCFCS' then 'Taxol' 
	when 'ARV' then 'Baraclude' 
	when 'Platinum' then 'Paraplatin' 
	when 'CCB' then 'Coniel' 
	WHEN 'Eliquis NOAC' THEN 'Eliquis'
end
where LinkChartCode = 'D051'  and Series = 'BMS Product'
go

update OutputHospital_All set Series=
	case Product 
	when 'HYPFCS' then 'Monopril' 
	when 'NIAD' then 'Glucophage' 
	when 'ONCFCS' then 'Taxol' 
	when 'ARV' then 'Baraclude'
	when 'Platinum' then 'Paraplatin' 
	when 'CCB' then 'Coniel'
	WHEN 'Eliquis NOAC' THEN 'Eliquis'
	end + ' Growth'
where LinkChartCode = 'D051'  and Series = 'BMS Product Growth'
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
where LinkChartCode = 'D051' and IsShow = 'Y' and SeriesIdx in(1,2)
go

delete from OutputHospital_All where LinkChartCode = 'D051' and Product <> 'Platinum' and category like 'P%'
GO


update OutputHospital_All set Y = 
case when UR3M1=0 or VR3M1=0 or UYTD=0 or VYTD=0 then 0 
     else cast(a.Y as float) / case a.category when 'UC3M' then UR3M1 
                                               when 'VC3M' then VR3M1 
                                 
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

		sum(UYTD) UYTD,
		sum(VYTD) VYTD

	from tempHospitalDataByGeo
	where lev  = 'Region' and Mkt in ('Eliquis NOAC') and Prod in('000','100')
	group by Mkt, Prod, ParentGeo,Geo
) b 
on a.Product = b.Mkt and case SeriesIdx when 1 then '000' else '100' end = b.Prod and a.Geo = b.geo
where a.LinkChartCode = 'D051' and a.IsShow = 'D'
go


update OutputHospital_All set Product = b.Product
from OutputHospital_All a 
inner join (select distinct Product,Mkt from tblMktDefHospital) b on a.Product = b.Mkt
where a.LinkChartCode = 'D051'
go

-- select * from OutputHospital_All where LinkChartCode = 'D051'
update OutputHospital_All set 
	Category = case left(Category,1) when 'U' then 'Volume' when 'V' then 'Value' when 'P' then 'Adjusted patient number' end,
	Currency = case left(Currency,1) when 'U' then 'UNIT' WHEN 'V' THEN 'RMB' when 'P' then 'UNIT' END,
	TimeFrame = case right(TimeFrame,len(TimeFrame)-1) when 'YTD' THEN 'YTD' WHEN 'C3M' THEN 'MQT' END
where LinkChartCode in ('D051')
go

insert into OutputHospital_All (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
select LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, 'USD', TimeFrame, X, XIdx, 
	case when SeriesIdx in (1,2) and IsShow <> 'D' then cast(Y as Float)/(select Rate from BMSChinaCIA_IMS.dbo.tblRate) else Y end, IsShow
from OutputHospital_All where LinkChartCode in ('D051') and Currency = 'RMB'
go

update OutputHospital_All set X = left(b.Cpa_Name_English,50)
from OutputHospital_All a
inner join tblHospitalMaster b on a.x = b.id
where a.LinkChartCode in ('D051')-- and IsShow = 'Y'
go

update OutputHospital_All set Series = 'Hospital Contrib. to ' + Series
where LinkChartCode = 'D051' and IsShow = 'D'
go




-- D111: ARV/NIAD/ONCO/ANTI-Hyp/DPP4 Hospital Performance by City
delete from OutputHospital_All where LinkChartCode='D111'
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 
   'D111' AS LinkChartCode
 , 'D111' + cast(SeriesIdx as varchar) as LinkSeriesCode
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
and Mkt in ('Eliquis NOAC') and Prod = '000'
and exists(select * from tblSalesRegion b where a.Geo = b.imscity)
)b
--go
--update OutputHospital_All set product=case when product ='eliquis VTEP' then 'Eliquis' 
--							       when product ='eliquis NOAC' then 'Eliquis' 
--							  else product end
--					where LinkChartCode in ('D110','D111')
	go						
update OutputHospital_All set Y = case a.category 
when 'UC3M' then UR3M1 
when 'VC3M' then VR3M1
when 'PC3M' then PR3M1 
when 'UYTD' then UYTD 
when 'VYTD' then VYTD 
when 'PYTD' then PYTD end
from OutputHospital_All a
inner join tempHospitalDataByGeo b on b.Mkt = a.Product 
	and b.lev = a.lev and b.ParentGeo = a.ParentGeo and b.geo = a.geo and b.CPA_id = cast(a.x as int)
where a.LinkChartCode = 'D111' and a.SeriesIdx = 1 and b.Prod = '000'
go

update OutputHospital_All set Y = case a.category 
when 'UC3M' then UR3M1 
when 'VC3M' then VR3M1 
when 'PC3M' then PR3M1 
when 'UYTD' then UYTD 
when 'VYTD' then VYTD
when 'PYTD' then PYTD end
from OutputHospital_All a
inner join tempHospitalDataByGeo b on b.Mkt = a.Product 
	and b.lev = a.lev and b.ParentGeo = a.ParentGeo and b.geo = a.geo and b.CPA_id = cast(a.x as int)
where a.LinkChartCode = 'D111' and a.SeriesIdx = 2 and b.Prod = '100' 
go

update OutputHospital_All set Y = case a.category 
when 'UC3M' then UC3MGrowth 
when 'VC3M' then VC3MGrowth 
when 'PC3M' then PC3MGrowth 
when 'UYTD' then UYTDGrowth 
when 'VYTD' then VYTDGrowth
when 'PYTD' then PYTDGrowth end
from OutputHospital_All a
inner join tempHospitalDataByGeo b on b.Mkt = a.Product 
	and b.lev = a.lev and b.ParentGeo = a.ParentGeo and b.geo = a.geo and b.CPA_id = cast(a.x as int)
where a.LinkChartCode = 'D111' and a.SeriesIdx = 3 and b.Prod = '000'
go

update OutputHospital_All set Y = case a.category 
when 'UC3M' then UC3MGrowth 
when 'VC3M' then VC3MGrowth 
when 'PC3M' then PC3MGrowth 
when 'UYTD' then UYTDGrowth 
when 'VYTD' then VYTDGrowth 
when 'PYTD' then PYTDGrowth end
from OutputHospital_All a
inner join tempHospitalDataByGeo b on b.Mkt = a.Product 
	and a.lev = b.lev and b.ParentGeo = a.ParentGeo and a.geo = b.geo and a.x = b.CPA_id
where a.LinkChartCode = 'D111' and a.SeriesIdx = 4 and b.Prod = '100'
go

update OutputHospital_All set Series=
	case Product 
	when 'HYPFCS' then 'Monopril Market' 
	when 'NIAD' then 'NIAD Market' 
	when 'ONCFCS' then 'Taxol Market' 
	when 'ARV' then 'ARV Market'
	when 'DPP4' then 'DPP-IV Class'
	when 'Platinum' then 'Platinum Market'
	when 'CCB' then 'Coniel Market'
	when 'Eliquis NOAC' then 'Eliquis (NOAC) Market'
	else Series end
where LinkChartCode = 'D111'  and Series = 'Market'
go

update OutputHospital_All set Series=
	case Product 
	when 'HYPFCS' then 'Monopril' 
	when 'NIAD' then 'Glucophage' 
	when 'ONCFCS' then 'Taxol' 
	when 'ARV' then 'Baraclude' 
	when 'DPP4' then 'Onglyza'
	when 'Platinum' then 'Paraplatin' 
	when 'CCB' then 'Coniel'
	when 'Eliquis NOAC' then 'Eliquis NOAC'
  end
where LinkChartCode = 'D111'  and Series = 'BMS Product'
go

update OutputHospital_All set Series=
	case Product 
	when 'HYPFCS' then 'Monopril' 
	when 'NIAD' then 'Glucophage' 
	when 'ONCFCS' then 'Taxol' 
	when 'ARV' then 'Baraclude' 
	when 'DPP4' then 'Onglyza' 
	when 'Platinum' then 'Paraplatin' 
	when 'CCB' then 'Coniel'
	when 'Eliquis NOAC' then 'Eliquis NOAC'
   end + ' Growth'
where LinkChartCode = 'D111'  and Series = 'BMS Product Growth'
go

-- Market Share in City
-- BMS Product Share in City
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, 
	Category, Product, Lev,  ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select LinkChartCode,LinkSeriesCode,
	a.Series, a.SeriesIdx, a.Category, a.Product, 
	a.Lev, a.ParentGeo, a.Geo, a.Currency, a.TimeFrame,a.X, a.Xidx,a.Y,'D' as IsShow
from OutputHospital_All a
where LinkChartCode = 'D111' and IsShow = 'Y' and SeriesIdx in(1,2)
go


delete
from OutputHospital_All where LinkChartCode = 'D111' and Product <> 'Platinum' and category like 'P%'
GO


update OutputHospital_All set Y = 
	case when (case a.category when 'UC3M' then UR3M1 
                             when 'VC3M' then VR3M1 
                            
                             when 'UYTD' then UYTD 
                             when 'VYTD' then VYTD 
                            end ) = 0 then 0 
       else cast(a.Y as float) / case a.category  when 'UC3M' then UR3M1 
                                                  when 'VC3M' then VR3M1 
                                                  
                                                  when 'UYTD' then UYTD 
                                                  when 'VYTD' then VYTD
                                                  end 
  end
from OutputHospital_All a inner join (
	select Mkt,Prod, ParentGeo,Geo, 
		sum(UR3M1) UR3M1,
		sum(VR3M1) VR3M1,
      sum(PR3M1) PR3M1,
		sum(UYTD) UYTD,
		sum(VYTD) VYTD,
		sum(PYTD) PYTD
	from tempHospitalDataByGeo
	where lev  = 'city' and Mkt in ('Eliquis NOAC') and Prod in('000','100')
	group by Mkt,Prod, ParentGeo,Geo
) b on a.Product = b.Mkt and case a.seriesidx when 1 then '000' else '100' end = b.Prod
	and a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
where a.LinkChartCode = 'D111' and a.IsShow = 'D'
go


-- select * from OutputHospital_All where LinkChartCode = 'D111'
update OutputHospital_All set 
	Category = case left(Category,1) when 'U' then 'Volume' 
                                   when 'V' then 'Value'
                                   when 'P' then 'Adjusted patient number' end,
	Currency = case left(Currency,1) when 'U' then 'UNIT'
                                   WHEN 'V' THEN 'RMB'
                                   WHEN 'P' THEN 'UNIT' END,
	TimeFrame = case right(TimeFrame,len(TimeFrame)-1) when 'YTD' THEN 'YTD' 
                                                     WHEN 'C3M' THEN 'MQT' END
where LinkChartCode in ('D111')
go


insert into OutputHospital_All (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
select LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo
, 'USD', TimeFrame, X, XIdx, 
	case when SeriesIdx in (1,2) and IsShow <> 'D' then cast(Y as Float)/(select Rate from BMSChinaCIA_IMS.dbo.tblRate) else Y end, IsShow
from OutputHospital_All where LinkChartCode in ('D111') and Currency = 'RMB'
go

update OutputHospital_All set LinkSeriesCode = Product + '_' + LinkChartCode+'_' + Geo + IsShow + cast(SeriesIdx as varchar)
where LinkChartCode in ('D111')
go

update OutputHospital_All set X = left(b.Cpa_Name_English,50)
from OutputHospital_All a
inner join tblHospitalMaster b on a.x = b.id
where a.LinkChartCode in ('D111') -- and IsShow = 'Y'
go

update OutputHospital_All set Series = 'Hospital Contrib. to ' + Series
where LinkChartCode = 'D111' and IsShow = 'D'
go

exec dbo.sp_Log_Event 'output','CIA_CPA','3_5_Eliquis_NOAC_CPA.sql','End',null,null