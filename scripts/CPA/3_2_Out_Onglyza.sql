-- /* �����ű�����Onglyza��Ʒ�������������� */



-- use BMSChinaMRBI
-- go

-- --Time:00:26
-- --04:58








-- --log
-- exec dbo.sp_Log_Event 'output','CIA_CPA','3_2_Out_Onglyza.sql','Start',null,null
-- go

-- -- select * into OutputHospital_Onglyza_201203_old from OutputHospital_Onglyza
-- truncate table OutputHospital_Onglyza
-- go

-- -- D050 region top NIAD hospital
-- -- D060 region top DPP-IV hospital
-- delete from OutputHospital_Onglyza where LinkChartCode in('D050','D060')
-- go
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'D050' AS LinkChartCode,
-- 	'D050' + cast(SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, b.Category, b.Product, 
-- 	b.Lev, b.Geo, b.Currency, b.TimeFrame,b.X, b.Xidx,0 as Y,'Y'
-- from (
-- 	select 'Market' Series,1 as SeriesIdx union all
-- 	select 'BMS Product' Series,2 as SeriesIdx union all
-- 	select 'Market Growth' Series,3 as SeriesIdx union all
-- 	select 'BMS Product Growth' Series,4 as SeriesIdx
-- ) a, (
-- 	select RankSource as Category, Mkt as Product,
-- 		Lev as Lev,Geo, RankSource as Currency, RankSource as TimeFrame,
-- 		CPA_id as X, Rank as Xidx
-- 	from OutputTopCPA where Lev = 'Region' and Mkt in ('NIAD','DPP4') and prod = '000'
-- )b
-- go

-- update OutputHospital_Onglyza set Y = case a.category when 'UC3M' then UR3M1 when 'VC3M' then VR3M1 when 'UYTD' then UYTD when 'VYTD' then VYTD end
-- from OutputHospital_Onglyza a
-- inner join tempHospitalDataByGeo b on b.Mkt = a.Product
-- 	and b.lev = a.lev and b.geo = a.geo and b.CPA_id = cast(a.x as int)
-- where a.LinkChartCode = 'D050' and a.SeriesIdx = 1 and b.Prod = '000'
-- go

-- update OutputHospital_Onglyza set Y = case a.category when 'UC3M' then UC3MGrowth when 'VC3M' then VC3MGrowth when 'UYTD' then UYTDGrowth when 'VYTD' then VYTDGrowth end
-- from OutputHospital_Onglyza a
-- inner join tempHospitalDataByGeo b on b.Mkt = a.Product
-- 	and b.lev = a.lev and b.geo = a.geo and b.CPA_id = cast(a.x as int)
-- where a.LinkChartCode = 'D050' and a.SeriesIdx = 3 and b.Prod = '000'
-- go

-- update OutputHospital_Onglyza set Y = case a.category when 'UC3M' then UR3M1 when 'VC3M' then VR3M1 when 'UYTD' then UYTD when 'VYTD' then VYTD end
-- from OutputHospital_Onglyza a
-- inner join tempHospitalDataByGeo b on b.Mkt = a.Product 
-- 	and b.lev = a.lev and b.geo = a.geo and b.CPA_id = cast(a.x as int)
-- where a.LinkChartCode = 'D050' and a.SeriesIdx = 2 and b.Prod = case when a.Product = 'NIAD' then '802' else '100' end
-- go

-- update OutputHospital_Onglyza set Y = case a.category when 'UC3M' then UC3MGrowth when 'VC3M' then VC3MGrowth when 'UYTD' then UYTDGrowth when 'VYTD' then VYTDGrowth end
-- from OutputHospital_Onglyza a
-- inner join tempHospitalDataByGeo b on b.Mkt = a.Product 
-- 	and a.lev = b.lev and a.geo = b.geo and a.x = b.CPA_id
-- where a.LinkChartCode = 'D050' and a.SeriesIdx = 4 and b.Prod = case when a.Product = 'NIAD' then '802' else '100' end
-- go

-- update OutputHospital_Onglyza set Series=
-- 	case Product 
-- 	when 'NIAD' then 'NIAD Market' 
-- 	when 'DPP4' then 'DPP-IV Class'
-- 	else Series end
-- where LinkChartCode = 'D050'  and Series = 'Market'
-- go

-- update OutputHospital_Onglyza set Series= 'Onglyza'
-- where LinkChartCode = 'D050'  and Series = 'BMS Product'
-- go

-- update OutputHospital_Onglyza set Series='Onglyza' + ' Growth'
-- where LinkChartCode = 'D050'  and Series = 'BMS Product Growth'
-- go

-- -- Market contribution in Region
-- -- BMS Product contribution in Region
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select LinkChartCode,LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, a.Category, a.Product, 
-- 	a.Lev, a.Geo, a.Currency, a.TimeFrame,a.X, a.Xidx,a.Y,'D' as IsShow
-- from OutputHospital_Onglyza a
-- where LinkChartCode = 'D050' and IsShow = 'Y' and SeriesIdx in(1,2)
-- go

-- update OutputHospital_Onglyza set Y = 
-- 	case when case a.category when 'UC3M' then UR3M1 when 'VC3M' then VR3M1 when 'UYTD' then UYTD when 'VYTD' then VYTD end = 0 then 0 else
-- 	cast(a.Y as float) / case a.category when 'UC3M' then UR3M1 when 'VC3M' then VR3M1 when 'UYTD' then UYTD when 'VYTD' then VYTD end end
-- from OutputHospital_Onglyza a inner join (
-- 	select Mkt, Prod, ParentGeo,Geo, 
-- 		sum(UR3M1) UR3M1,
-- 		sum(VR3M1) VR3M1,
-- 		sum(UYTD) UYTD,
-- 		sum(VYTD) VYTD
-- 	from tempHospitalDataByGeo
-- 	where lev  = 'Region' and Mkt in ('NIAD','DPP4') and Prod in('000','802','100')
-- 	group by Mkt, Prod, ParentGeo,Geo
-- ) b on a.Product = b.Mkt and 
-- 	case SeriesIdx 
-- 	when 1 then '000' 
-- 	else 
-- 		case when b.Mkt = 'NIAD' then '802' else '100' end 
-- 	end = b.Prod and a.Geo = b.geo
-- where a.LinkChartCode = 'D050' and a.IsShow = 'D'
-- go

-- update OutputHospital_Onglyza set Product = b.Product
-- from OutputHospital_Onglyza a 
-- inner join (
-- 	select distinct case when Mkt = 'DPP4' then 'Onglyza' else Product end Product,Mkt 
-- 	from tblMktDefHospital
-- ) b on a.Product = b.Mkt
-- where a.LinkChartCode = 'D050'
-- go

-- -- select * from OutputHospital_Onglyza where LinkChartCode = 'D050'
-- update OutputHospital_Onglyza set 
-- 	Category = case left(Category,1) when 'U' then 'Volume' when 'V' then 'Value' when 'P' then 'Adjusted patient number' end,
-- 	Currency = case left(Currency,1) when 'U' then 'UNIT' when 'P' then 'UNIT' WHEN  'V' THEN 'RMB' END,
-- 	TimeFrame = case right(TimeFrame,len(TimeFrame)-1) when 'YTD' THEN 'YTD' WHEN 'C3M' THEN 'MQT' END
-- where LinkChartCode in ('D050')
-- go

-- insert into OutputHospital_Onglyza (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
-- select LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, 'USD', TimeFrame, X, XIdx, 
-- 	case when SeriesIdx in (1,2) and IsShow <> 'D' then cast(Y as Float)/(select Rate from BMSChinaCIA_IMS.dbo.tblRate) else Y end, IsShow
-- from OutputHospital_Onglyza where LinkChartCode in ('D050') and Currency = 'RMB'
-- go

-- update OutputHospital_Onglyza set X = left(b.Cpa_Name_English,50)
-- from OutputHospital_Onglyza a
-- inner join tblHospitalMaster b on a.x = b.id
-- where a.LinkChartCode in ('D050')-- and IsShow = 'Y'
-- go

-- update OutputHospital_Onglyza set Series = 'Hospital Contrib. to ' + Series
-- where LinkChartCode = 'D050' and IsShow = 'D'
-- go

-- update OutputHospital_Onglyza set LinkChartCode = 'D060'
-- where LinkChartCode = 'D050' and Product = 'Onglyza'
-- go




-- print '-- Part 2: Hospital Performance'

-- -- R191
-- -- Top Dia Market Tier 3 Hospital Performance by Brand (NIAD)
-- delete OutputHospital_Onglyza where linkChartCode = 'R191'

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R191' AS LinkChartCode,
-- 	'R191' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
-- 	from dbo.tblMktDefHospital 
-- 	where mkt in ('NIAD') and Molecule = 'N' and Class = 'N' and Prod <> '000'
-- ) a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'Dia' and Tier = '3' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt, 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'Dia' and Tier = '3' and Prod = '000' and UMATRank <= 7
-- )b
-- where case when b.Mkt = 'Dia' then 'NIAD' else b.Mkt end = a.Product
-- go

-- -- table in R191
-- -- MAT Growth for each hospital
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R191' AS LinkChartCode,
-- 	'R191' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, b.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
-- from (
-- 	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
-- 	from dbo.tblMktDefHospital 
-- 	where mkt in ('niad') and Prod in('000','802','600')-- NIAD/ONGLYZA/JUNAVIA
-- )a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt in('Dia') and Tier = '3' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt, 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt in('Dia') and Tier = '3' and Prod = '000' and UMATRank <= 7
-- )b 
-- where case when b.Mkt = 'Dia' then 'NIAD' else b.Mkt end = a.Product
-- go


-- -- R251
-- -- Top Dia Market Tier 2 Hospital Performance by Brand (NIAD)
-- delete OutputHospital_Onglyza where linkChartCode = 'R251'

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R251' AS LinkChartCode,
-- 	'R251' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
-- 	from dbo.tblMktDefHospital 
-- 	where mkt in ('niad') and Molecule = 'N' and Class = 'N' and Prod <> '000'
-- ) a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt in('Dia') and Tier = '2' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt, 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt in('Dia') and Tier = '2' and Prod = '000' and UMATRank <= 7
-- )b
-- where case when b.Mkt = 'Dia' then 'NIAD' else b.Mkt end = a.Product
-- go

-- -- table in R251
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R251' AS LinkChartCode,
-- 	'R251' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, b.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
-- from (
-- 	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
-- 	from dbo.tblMktDefHospital 
-- 	where mkt in ('niad') and Prod in('000','802','600')
-- )a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt in('Dia') and Tier = '2' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt, 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt in('Dia') and Tier = '2' and Prod = '000' and UMATRank <= 7
-- )b
-- where  case when b.Mkt = 'Dia' then 'NIAD' else b.Mkt end = a.Product
-- go

-- -- R911
-- -- Top Dia Market Tier 3 Hospital Performance by Brand (DPP-IV)
-- delete OutputHospital_Onglyza where linkChartCode = 'R911'

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R911' AS LinkChartCode,
-- 	'R911' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
-- 	from dbo.tblMktDefHospital 
-- 	where mkt in ('DPP4') and Molecule = 'N' and Class = 'N' and Prod <> '000'
-- ) a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'Dia' and Tier = '3' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt, 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'Dia' and Tier = '3' and Prod = '000' and UMATRank <= 7
-- )b
-- go

-- -- table in R911
-- -- MAT Growth for each hospital
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R911' AS LinkChartCode,
-- 	'R911' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, b.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
-- from (
-- 	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
-- 	from dbo.tblMktDefHospital 
-- 	where mkt in ('DPP4') and Prod IN('000','100','200')-- DPP-IV/ONGLYZA/JUNAVIA
-- )a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt in('Dia') and Tier = '3' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt, 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt in('Dia') and Tier = '3' and Prod = '000' and UMATRank <= 7
-- )b
-- go


-- -- R971
-- -- Top Dia Market Tier 2 Hospital Performance by Brand (DPP-IV)
-- delete OutputHospital_Onglyza where linkChartCode = 'R971'

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R971' AS LinkChartCode,
-- 	'R971' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
-- 	from dbo.tblMktDefHospital 
-- 	where mkt in ('DPP4') and Molecule = 'N' and Class = 'N' and Prod <> '000'
-- ) a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt in('Dia') and Tier = '2' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt, 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt in('Dia') and Tier = '2' and Prod = '000' and UMATRank <= 7
-- )b
-- go
-- -- table in R971
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R971' AS LinkChartCode,
-- 	'R971' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, b.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
-- from (
-- 	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
-- 	from dbo.tblMktDefHospital 
-- 	where mkt in ('DPP4') and Prod in('000','100','200')
-- )a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt in('Dia') and Tier = '2' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt, 'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt in('Dia') and Tier = '2' and Prod = '000' and UMATRank <= 7
-- )b
-- go


-- -- R211
-- -- Top NIAD Tier 3 Hospital Performance by Brand (NIAD)
-- delete OutputHospital_Onglyza where linkChartCode = 'R211'
-- go
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R211' AS LinkChartCode,
-- 	'R211' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'NIAD' and Molecule = 'N' and Class = 'N' and Prod <> '000'
-- ) a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '000' and UMATRank <= 7
-- )b
-- where a.Product = b.Mkt
-- go
-- -- table in R211
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R211' AS LinkChartCode,
-- 	'R211' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, b.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
-- from (
-- 	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
-- 	from dbo.tblMktDefHospital where mkt in ('NIAD') and Prod in('000','802','600')
-- )a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '000' and UMATRank <= 7
-- )b
-- where a.Product = b.Mkt
-- go


-- -- R271
-- -- Top NIAD Tier 2 Hospital Performance by Brand (NIAD)
-- delete OutputHospital_Onglyza where linkChartCode = 'R271'
-- go
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R271' AS LinkChartCode,
-- 	'R271' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'NIAD' and Molecule = 'N' and Class = 'N' and Prod <> '000'
-- ) a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '000' and UMATRank <= 7
-- )b
-- where a.Product = b.Mkt
-- go
-- -- table in R271
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R271' AS LinkChartCode,
-- 	'R271' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, b.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
-- from (
-- 	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
-- 	from dbo.tblMktDefHospital where mkt = 'NIAD' and Prod in('000','802','600')
-- )a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '000' and UMATRank <= 7
-- )b
-- where a.Product = b.Mkt
-- GO

-- -- R221
-- -- Top dpp-iv Tier 3 Hospital Performance by Brand
-- delete OutputHospital_Onglyza where linkChartCode = 'R221'
-- go
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R221' AS LinkChartCode,
-- 	'R221' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'DPP4' and Molecule = 'N' and Class = 'N' and Prod <> '000'
-- ) a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '3' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '3' and Prod = '000' and UMATRank <= 7
-- )b
-- where a.Product = b.Mkt
-- go
-- -- table in R221
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R221' AS LinkChartCode,
-- 	'R221' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, b.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
-- from (
-- 	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
-- 	from dbo.tblMktDefHospital where mkt in ('DPP4') and Prod in('000','100','200')
-- )a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '3' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '3' and Prod = '000' and UMATRank <= 7
-- )b
-- where a.Product = b.Mkt
-- go


-- -- R281
-- -- Top dpp-iv Tier 2 Hospital Performance by Brand
-- delete OutputHospital_Onglyza where linkChartCode = 'R281'
-- go
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R281' AS LinkChartCode,
-- 	'R281' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'DPP4' and Molecule = 'N' and Class = 'N' and Prod <> '000'
-- ) a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '2' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '2' and Prod = '000' and UMATRank <= 7
-- )b
-- where a.Product = b.Mkt
-- go
-- -- table in R281
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R281' AS LinkChartCode,
-- 	'R281' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, b.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
-- from (
-- 	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
-- 	from dbo.tblMktDefHospital where mkt = 'DPP4' and Prod in('000','100','200')
-- )a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '2' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '2' and Prod = '000' and UMATRank <= 7
-- )b
-- where a.Product = b.Mkt
-- GO

-- -- R921
-- -- Top NIAD Tier 3 Hospital Performance by Brand (DPP-IV)
-- delete OutputHospital_Onglyza where linkChartCode = 'R921'
-- go
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R921' AS LinkChartCode,
-- 	'R921' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'DPP4' and Molecule = 'N' and Class = 'N' and Prod <> '000'
-- ) a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '000' and UMATRank <= 7
-- )b
-- go
-- -- table in R921
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R921' AS LinkChartCode,
-- 	'R921' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, b.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
-- from (
-- 	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
-- 	from dbo.tblMktDefHospital where mkt in ('DPP4') and Prod in('000','100','200')
-- )a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '000' and UMATRank <= 7
-- )b
-- go


-- -- R981
-- -- Top NIAD Tier 2 Hospital Performance by Brand (DPP-IV)
-- delete OutputHospital_Onglyza where linkChartCode = 'R981'
-- go
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R981' AS LinkChartCode,
-- 	'R981' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'DPP4' and Molecule = 'N' and Class = 'N' and Prod <> '000'
-- ) a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '000' and UMATRank <= 7
-- )b
-- go
-- -- table in R981
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R981' AS LinkChartCode,
-- 	'R981' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, b.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
-- from (
-- 	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
-- 	from dbo.tblMktDefHospital where mkt = 'DPP4' and Prod in('000','100','200')
-- )a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '000' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '000' and UMATRank <= 7
-- )b
-- GO

-- -- R231
-- -- Top Onglyza Tier 3 Hospital Performance by Brand (NIAD)
-- delete OutputHospital_Onglyza where linkChartCode = 'R231'
-- go
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R231' AS LinkChartCode,
-- 	'R231' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
-- 	from dbo.tblMktDefHospital where mkt = 'NIAD' and Molecule = 'N' and Class = 'N' and Prod <> '000'
-- ) a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD'  and Tier = '3' and Prod = '802' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD'  and Tier = '3' and Prod = '802' and UMATRank <= 7
-- )b
-- where a.Product = b.Mkt
-- go
-- -- table in R231
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R231' AS LinkChartCode,
-- 	'R231' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, b.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
-- from (
-- 	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
-- 	from dbo.tblMktDefHospital where mkt = 'NIAD' and Prod in('000','802','600')
-- )a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '802' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '802' and UMATRank <= 7
-- )b
-- where a.Product = b.Mkt
-- go

-- -- R291
-- -- Top Onglyza Tier 2 Hospital Performance by Brand (NIAD)
-- delete OutputHospital_Onglyza where linkChartCode = 'R291'

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R291' AS LinkChartCode,
-- 	'R291' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'NIAD' and Molecule = 'N' and Class = 'N' and Prod <> '000'
-- ) a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '802' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '802' and UMATRank <= 7
-- )b
-- where a.Product = b.Mkt
-- go
-- -- table in R291
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R291' AS LinkChartCode,
-- 	'R291' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, b.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
-- from (
-- 	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
-- 	from dbo.tblMktDefHospital where mkt = 'NIAD' and Prod in('000','600','802')
-- )a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '802' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '802' and UMATRank <= 7
-- )b
-- where a.Product = b.Mkt
-- go

-- -- R931
-- -- Top Onglyza Tier 3 Hospital ONGLYZA DPP-IV MARKET SHARE
-- delete OutputHospital_Onglyza where linkChartCode = 'R931'
-- go
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R931' AS LinkChartCode,
-- 	'R931' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
-- 	from dbo.tblMktDefHospital where mkt = 'DPP4' and Molecule = 'N' and Class = 'N' and Prod <> '000'
-- ) a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4'  and Tier = '3' and Prod = '100' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4'  and Tier = '3' and Prod = '100' and UMATRank <= 7
-- )b
-- where a.Product = b.Mkt
-- go
-- -- table in R931
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R931' AS LinkChartCode,
-- 	'R931' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, b.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
-- from (
-- 	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
-- 	from dbo.tblMktDefHospital where mkt = 'DPP4' and Prod in('000','100','200')
-- )a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '3' and Prod = '100' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '3' and Prod = '100' and UMATRank <= 7
-- )b
-- where a.Product = b.Mkt
-- go

-- -- R991
-- -- Top Onglyza Tier 2 Hospital ONGLYZA DPP-IV SHARE
-- delete OutputHospital_Onglyza where linkChartCode = 'R991'

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R991' AS LinkChartCode,
-- 	'R991' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,b.X, b.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product,ProductName Series, Prod SeriesIdx 
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'DPP4' and Molecule = 'N' and Class = 'N' and Prod <> '000'
-- ) a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '2' and Prod = '100' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '2' and Prod = '100' and UMATRank <= 7
-- )b
-- where a.Product = b.Mkt
-- go
-- -- table in R991
-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R991' AS LinkChartCode,
-- 	'R991' + cast(a.SeriesIdx as varchar) as LinkSeriesCode,
-- 	a.Series, a.SeriesIdx, b.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, b.Category, b.Category,b.X, b.Xidx,0 as Y,'D'
-- from (
-- 	select distinct Mkt Product,ProductName as Series, Prod as SeriesIdx
-- 	from dbo.tblMktDefHospital where mkt = 'DPP4' and Prod in('000','100','200')
-- )a, (
-- 	select Mkt,'VMAT' as Category,cpa_id as X,VMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '2' and Prod = '100' and VMATRank <= 7
-- 	Union all
-- 	select Mkt,'UMAT' as Category,cpa_id as X,UMATRank as XIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '2' and Prod = '100' and UMATRank <= 7
-- )b
-- where a.Product = b.Mkt
-- go

-- -- calculate the share
-- update OutputHospital_Onglyza set Y = case a.Category
-- 	when 'VMAT' then b.VMAT1
-- 	when 'UMAT' then b.UMAT1
-- 	when 'VR3M' then b.VR3M1
-- 	when 'UR3M' then b.UR3M1 end 
-- from OutputHospital_Onglyza a
-- inner join tempHospitalDataByTier b on
-- 	a.Product = b.Mkt and a.SeriesIdx = b.Prod and a.x = b.cpa_id
-- where a.LinkChartCode in ('R191','R251','R211','R271','R221','R281','R231','R291','R911','R971','R921','R981','R931','R991')
-- 	and a.IsShow = 'Y'
-- go

-- -- set the total to Additional Y
-- update OutputHospital_Onglyza set AddY = b.total
-- from OutputHospital_Onglyza a
-- inner join (
-- 	select LinkChartCode,CateGory,Product,Lev,ParentGeo,Geo,Currency,TimeFrame,xidx,
-- 		sum(cast(Y as float)) as total
-- 	from OutputHospital_Onglyza a
-- 	where a.LinkChartCode in ('R191','R251','R211','R271','R221','R281','R231','R291','R911','R971','R921','R981','R931','R991')
-- 	group by LinkChartCode,CateGory,Product,Lev,ParentGeo,Geo,Currency,TimeFrame,xidx
-- ) b on a.LinkChartCode = b.LinkChartCode and a.Category = b.Category and a.Product = b.Product 
-- 	and a.Lev = b.Lev and a.Currency = b.Currency 
-- 	and a.TimeFrame = b.TimeFrame and a.XIdx = b.XIdx
-- where a.LinkChartCode in ('R191','R251','R211','R271','R221','R281','R231','R291','R911','R971','R921','R981','R931','R991')
-- 	and a.IsShow = 'Y'
-- go

-- -- set market share
-- update OutputHospital_Onglyza set Y = case when AddY = 0 then 0 else cast(y as float) / AddY end
-- where LinkChartCode in ('R191','R251','R211','R271','R221','R281','R231','R291','R911','R971','R921','R981','R931','R991')
-- 	and IsShow = 'Y'
-- go

-- update OutputHospital_Onglyza set Y = null
-- where LinkChartCode in ('R191','R251','R211','R271','R221','R281','R231','R291','R911','R971','R921','R981','R931','R991')
-- 	and cast(Y as float) = 0
-- 	and IsShow = 'Y'
-- go

-- -- remove ARV other/NIAD Other
-- delete OutputHospital_Onglyza
-- where LinkChartCode in ('R191','R251','R211','R271','R221','R281','R231','R291','R911','R971','R921','R981','R931','R991')
-- 	and Series in('ARV Others','NIAD Others')
-- 	and IsShow = 'Y'
-- go

-- -- set the data in table
-- update OutputHospital_Onglyza set Y = case a.Category
-- 	when 'VMAT' then case when b.VMAT2 = 0 then null else b.VMAT1/b.VMAT2-1 end
-- 	when 'UMAT' then case when b.UMAT2 = 0 then null else b.UMAT1/b.UMAT2-1 end
-- 	end 
-- from OutputHospital_Onglyza a
-- inner join tempHospitalDataByTier b on
-- 	a.Product = b.Mkt and a.SeriesIdx = b.Prod and a.x = b.cpa_id
-- where a.LinkChartCode in ('R191','R251','R211','R271','R221','R281','R231','R291','R911','R971','R921','R981','R931','R991')
-- 	and a.IsShow = 'D'
-- go

-- update OutputHospital_Onglyza set 
-- 	Category = case left(Category,1) when 'U' then 'Volume' when 'V' then 'Value' end,
-- 	Currency = case left(Currency,1) when 'U' then 'UNIT' WHEN 'V' THEN 'RMB' END,
-- 	TimeFrame = case right(TimeFrame,len(TimeFrame)-1) when 'MAT' THEN 'MAT' WHEN 'R3M' THEN 'MQT' END
-- where LinkChartCode in ('R191','R251','R211','R271','R221','R281','R231','R291','R911','R971','R921','R981','R931','R991')
-- go

-- update OutputHospital_Onglyza set Product = b.Product
-- from OutputHospital_Onglyza a 
-- inner join (select distinct Product,Mkt from tblMktDefHospital) b on a.Product = b.Mkt
-- where a.LinkChartCode in ('R191','R251','R211','R271','R221','R281','R231','R291','R911','R971','R921','R981','R931','R991')
-- go

-- insert into OutputHospital_Onglyza (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y,AddY, IsShow)
-- select LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, 'USD', TimeFrame, X, XIdx, 
-- 	Y, 
-- 	AddY/ (select Rate from BMSChinaCIA_IMS.dbo.tblRate) as AddY, IsShow
-- from OutputHospital_Onglyza where LinkChartCode  in ('R191','R251','R211','R271','R221','R281','R231','R291','R911','R971','R921','R981','R931','R991')
-- 	and Currency = 'RMB'
-- go

-- update OutputHospital_Onglyza set LinkedY = convert(varchar(50),cast(round(AddY,0) as Money),1)
-- where LinkChartCode in ('R191','R251','R211','R271','R221','R281','R231','R291','R911','R971','R921','R981','R931','R991')
-- 	and IsShow = 'Y'
-- go

-- update OutputHospital_Onglyza set LinkedY = left(LinkedY,len(LinkedY)-3)
-- where LinkChartCode in ('R191','R251','R211','R271','R221','R281','R231','R291','R911','R971','R921','R981','R931','R991')
-- 	and IsShow = 'Y'
-- go

-- update OutputHospital_Onglyza set X = left(b.Cpa_Name_English,37) + ' (' + LinkedY + ')'
-- from OutputHospital_Onglyza a
-- inner join tblHospitalMaster b on a.x = b.id
-- where a.LinkChartCode in ('R191','R251','R211','R271','R221','R281','R231','R291','R911','R971','R921','R981','R931','R991') 
-- 	and isShow = 'Y'
-- go
-- update OutputHospital_Onglyza set X = left(b.Cpa_Name_English,50)
-- from OutputHospital_Onglyza a
-- inner join tblHospitalMaster b on a.x = b.id
-- where a.LinkChartCode in ('R191','R251','R211','R271','R221','R281','R231','R291','R911','R971','R921','R981','R931','R991') 
-- 	and IsShow = 'D'
-- go

-- -- data of The table in these slide are growth
-- update OutputHospital_Onglyza set Series = Series + ' GR'
-- where LinkChartCode in ('R191','R251','R211','R271','R221','R281','R231','R291','R911','R971','R921','R981','R931','R991')
-- 	and IsShow = 'D'
-- go













-- -- R192
-- -- Top DIA Market Tier 3 hospital ONGLYZA NIAD MARKET SHARE
-- delete OutputHospital_Onglyza where linkChartCode = 'R192'
-- go

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R192' AS LinkChartCode,
-- 	'R192' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
-- 	b.Series, b.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'NIAD' AND PROD = '802'
-- ) a, (
-- 	select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DIA' and Tier = '3' and Prod = '000' and VMATRANK <= 7
-- 	union all
-- 	select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DIA' and Tier = '3' and Prod = '000' and UMATRANK <= 7
-- )b, (
-- 	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
-- )c
-- where a.Product = case when b.Mkt ='Dia' then 'NIAD' when b.Mkt = 'HYP' then 'HYPFCS' else b.Mkt end
-- go

-- -- R252
-- -- Top Dia Market Tier 2 hospital ONGLYZA NIAD MARKET SHARE
-- delete OutputHospital_Onglyza where linkChartCode = 'R252'
-- go

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R252' AS LinkChartCode,
-- 	'R252' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
-- 	b.Series, b.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'NIAD' and Prod = '802'
-- ) a, (
-- 	select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DIA' and Tier = '2' and Prod = '000' and VMATRANK <= 7
-- 	union all
-- 	select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DIA' and Tier = '2' and Prod = '000' and UMATRANK <= 7
-- )b, (
-- 	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
-- )c
-- where a.Product = case when b.Mkt ='Dia' then 'NIAD' when b.Mkt = 'HYP' then 'HYPFCS' else b.Mkt end
-- go

-- -- R912
-- -- Top DIA Market Tier 3 hospital ONGLYZA DPP-IV MARKET SHARE
-- delete OutputHospital_Onglyza where linkChartCode = 'R912'
-- go

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R912' AS LinkChartCode,
-- 	'R912' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
-- 	b.Series, b.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product from dbo.tblMktDefHospital 
-- 	where mkt = 'DPP4' AND PROD = '100'
-- ) a, (
-- 	select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DIA' and Tier = '3' and Prod = '000' and VMATRANK <= 7
-- 	union all
-- 	select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DIA' and Tier = '3' and Prod = '000' and UMATRANK <= 7
-- )b, (
-- 	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
-- )c
-- go

-- -- R972
-- -- Top Dia Market Tier 2 hospital ONGLYZA DPP-IV MARKET SHARE
-- delete OutputHospital_Onglyza where linkChartCode = 'R972'
-- go

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R972' AS LinkChartCode,
-- 	'R972' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
-- 	b.Series, b.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product	from dbo.tblMktDefHospital 
-- 	where mkt = 'DPP4' and Prod = '100'
-- ) a, (
-- 	select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DIA' and Tier = '2' and Prod = '000' and VMATRANK <= 7
-- 	union all
-- 	select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DIA' and Tier = '2' and Prod = '000' and UMATRANK <= 7
-- )b, (
-- 	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
-- )c
-- go

-- -- R212
-- -- Top NIAD Tier 3 hospital ONGLYZA NIAD MARKET SHARE
-- delete OutputHospital_Onglyza where linkChartCode = 'R212'
-- go

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R212' AS LinkChartCode,
-- 	'R212' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
-- 	b.Series, b.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'NIAD' and FocusedBrand = 'Y' and Molecule = 'N' and Class = 'N' and Prod = '802'
-- ) a, (
-- 	select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '000' and VMATRANK <= 7
-- 	union all
-- 	select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '000' and UMATRANK <= 7
-- )b, (
-- 	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
-- )c
-- where a.Product = b.Mkt
-- go


-- -- R272
-- -- Top NIAD Tier 2 hospital ONGLYZA NIAD MARKET SHARE
-- delete OutputHospital_Onglyza where linkChartCode = 'R272'
-- go

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R272' AS LinkChartCode,
-- 	'R272' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
-- 	b.Series, b.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'NIAD' and FocusedBrand = 'Y' and Molecule = 'N' and Class = 'N' and Prod = '802'
-- ) a, (
-- 	select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '000' and VMATRANK <= 7
-- 	union all
-- 	select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '000' and UMATRANK <= 7
-- )b, (
-- 	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
-- )c
-- where a.Product = b.Mkt
-- go

-- -- R222
-- -- Top DPP-IV Tier 3 hospital ONGLYZA DPP-IV MARKET SHARE
-- delete OutputHospital_Onglyza where linkChartCode = 'R222'
-- go

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R222' AS LinkChartCode,
-- 	'R222' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
-- 	b.Series, b.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'DPP4' and FocusedBrand = 'Y' and Molecule = 'N' and Class = 'N' and Prod = '100'
-- ) a, (
-- 	select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '3' and Prod = '000' and VMATRANK <= 7
-- 	union all
-- 	select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '3' and Prod = '000' and UMATRANK <= 7
-- )b, (
-- 	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
-- )c
-- where a.Product = b.Mkt
-- go


-- -- R282
-- -- Top DPP-IV Tier 2 hospital ONGLYZA DPP-IV MARKET SHARE
-- delete OutputHospital_Onglyza where linkChartCode = 'R282'
-- go

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R282' AS LinkChartCode,
-- 	'R282' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
-- 	b.Series, b.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'DPP4' and FocusedBrand = 'Y' and Molecule = 'N' and Class = 'N' and Prod = '100'
-- ) a, (
-- 	select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '2' and Prod = '000' and VMATRANK <= 7
-- 	union all
-- 	select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'DPP4' and Tier = '2' and Prod = '000' and UMATRANK <= 7
-- )b, (
-- 	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
-- )c
-- where a.Product = b.Mkt
-- go


-- -- R922
-- -- Top NIAD Tier 3 hospital ONGLYZA DPP-IV MARKET SHARE
-- delete OutputHospital_Onglyza where linkChartCode = 'R922'
-- go

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R922' AS LinkChartCode,
-- 	'R922' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
-- 	b.Series, b.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product	from dbo.tblMktDefHospital 
-- 	where mkt = 'DPP4' and FocusedBrand = 'Y' and Molecule = 'N' and Class = 'N' and Prod = '100'
-- ) a, (
-- 	select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '000' and VMATRANK <= 7
-- 	union all
-- 	select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '000' and UMATRANK <= 7
-- )b, (
-- 	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
-- )c
-- go


-- -- R982
-- -- Top NIAD Tier 2 hospital ONGLYZA DPP-IV MARKET SHARE
-- delete OutputHospital_Onglyza where linkChartCode = 'R982'
-- go

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R982' AS LinkChartCode,
-- 	'R982' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
-- 	b.Series, b.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product	from dbo.tblMktDefHospital 
-- 	where mkt = 'DPP4' and FocusedBrand = 'Y' and Molecule = 'N' and Class = 'N' and Prod = '100'
-- ) a, (
-- 	select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '000' and VMATRANK <= 7
-- 	union all
-- 	select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '000' and UMATRANK <= 7
-- )b, (
-- 	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
-- )c
-- go

-- -- R232
-- -- Top ONGLYZA Tier 3 hospital ONGLYZA NIAD MARKET SHARE
-- delete OutputHospital_Onglyza where linkChartCode = 'R232'
-- go

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R232' AS LinkChartCode,
-- 	'R232' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
-- 	b.Series, b.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'NIAD' and FocusedBrand = 'Y' and Molecule = 'N' and Class = 'N' and Prod = '802'
-- ) a, (
-- 	select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '802' and VMATRANK <= 7
-- 	union all
-- 	select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '802' and UMATRANK <= 7
-- )b, (
-- 	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
-- )c
-- where a.Product = b.Mkt
-- go

-- -- R292
-- -- Top ONGLYZA Tier 2 hospital ONGLYZA NIAD MARKET SHARE
-- delete OutputHospital_Onglyza where linkChartCode = 'R292'
-- go

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R292' AS LinkChartCode,
-- 	'R292' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
-- 	b.Series, b.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'NIAD' and FocusedBrand = 'Y' and Molecule = 'N' and Class = 'N' and Prod = '802'
-- ) a, (
-- 	select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '802' and VMATRANK <= 7
-- 	union all
-- 	select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '802' and UMATRANK <= 7
-- )b, (
-- 	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
-- )c
-- where a.Product = b.Mkt
-- go


-- -- R932
-- -- Top ONGLYZA Tier 3 hospital ONGLYZA NIAD MARKET SHARE
-- delete OutputHospital_Onglyza where linkChartCode = 'R932'
-- go

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R932' AS LinkChartCode,
-- 	'R932' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
-- 	b.Series, b.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'DPP4' and FocusedBrand = 'Y' and Molecule = 'N' and Class = 'N' and Prod = '100'
-- ) a, (
-- 	select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '802' and VMATRANK <= 7
-- 	union all
-- 	select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '3' and Prod = '802' and UMATRANK <= 7
-- )b, (
-- 	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
-- )c
-- go


-- -- R992
-- -- Top ONGLYZA Tier 2 hospital ONGLYZA NIAD MARKET SHARE
-- delete OutputHospital_Onglyza where linkChartCode = 'R992'
-- go

-- insert into OutputHospital_Onglyza(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
-- select 'R992' AS LinkChartCode,
-- 	'R992' + cast(b.SeriesIdx as varchar) as LinkSeriesCode,
-- 	b.Series, b.SeriesIdx, B.Category, a.Product, 
-- 	'Nat' Lev, 'China' Geo, B.Category, B.Category,c.X, c.Xidx,0 as Y,'Y'
-- from (
-- 	select distinct Mkt Product
-- 	from dbo.tblMktDefHospital 
-- 	where mkt = 'DPP4' and FocusedBrand = 'Y' and Molecule = 'N' and Class = 'N' and Prod = '100'
-- ) a, (
-- 	select Mkt,'VR3M' as Category,cpa_id as Series,VMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '802' and VMATRANK <= 7
-- 	union all
-- 	select Mkt,'UR3M' as Category,cpa_id as Series,UMATRANK as SeriesIdx  
-- 	from tempHospitalDataByTier where Mkt = 'NIAD' and Tier = '2' and Prod = '802' and UMATRANK <= 7
-- )b, (
-- 	select idx XIdx,mth X from tblHospitalMthList where Idx <= 12
-- )c
-- go

-- -- set the data for tier 3/2 in China
-- declare @i int, @sql varchar(2000), @m varchar(6)
-- set @i = 1
-- while @i <= 12
-- begin
-- 	select @m = mth from tblHospitalMthList where Idx = @i
-- 	set @sql = '
-- update OutputHospital_Onglyza set Y = case a.Category
-- 	-- R3M Share
-- 	when ''VR3M'' then VR3MShr' + cast(@i as varchar) + '
-- 	when ''UR3M'' then UR3MShr' + cast(@i as varchar) + ' end
-- from OutputHospital_Onglyza a
-- inner join tempHospitalDataByTier b on a.Product = b.Mkt and a.Series =b.cpa_id
-- 	and b.Prod = CASE WHEN B.MKT = ''NIAD'' THEN ''802'' WHEN B.MKT = ''DPP4'' THEN ''100'' END
-- WHERE A.LinkChartCode in (''R192'',''R252'',''R212'',''R272'',''R222'',''R282'',''R232'',''R292'',''R912'',''R972'',''R922'',''R982'',''R932'',''R992'') 
-- 	AND a.IsShow = ''Y'' and A.x = ''' + @m + ''' and b.Lev = ''Nat'''
-- 	-- print @sql
-- 	exec(@sql)
-- set @i = @i + 1
-- end
-- go

-- delete OutputHospital_Onglyza
-- from --select * from 
-- OutputHospital_Onglyza a
-- where exists( 
-- 	select * from (
-- 		select LinkChartCode,Category, Product, Lev,ParentGeo,Geo,Currency,TimeFrame, Series
-- 		from OutputHospital_Onglyza
-- 		where LinkChartCode in ('R192','R252','R212','R272','R222','R282','R232','R292','R912','R972','R922','R982','R932','R992') 
-- 			and IsShow = 'Y' and y = '0'
-- 		group by LinkChartCode,Category, Product, Lev,ParentGeo,Geo,Currency,TimeFrame,Series
-- 		having count(*) = 12
-- 	) b 
-- 	where a.LinkChartCode =b.linkChartCode
-- 		and a.Category = b.Category
-- 		and a.Product = b.Product
-- 		and a.Lev = b.Lev
-- 		and a.Geo = b.Geo
-- 		and a.Currency = b.Currency
-- 		and a.TimeFrame = b.TimeFrame
-- 		and a.Series = b.Series
-- )
-- -- order by linkchartcode,product,category, currency, timeframe,seriesidx,xidx
-- go


-- -- Update the fields in tables: Cagetory/Currency/timeFrame/Product
-- update OutputHospital_Onglyza set 
-- 	Category = case left(Category,1) when 'U' then 'Volume' when 'V' then 'Value' end,
-- 	Currency = case left(Currency,1) when 'U' then 'UNIT' WHEN 'V' THEN 'RMB' END,
-- 	TimeFrame = case right(TimeFrame,len(TimeFrame)-1) when 'MAT' THEN 'MAT' WHEN 'R3M' THEN 'MQT' END
-- where LinkChartCode in ('R192','R252','R212','R272','R222','R282','R232','R292','R912','R972','R922','R982','R932','R992') 
-- go

-- update OutputHospital_Onglyza set Product = b.Product
-- from OutputHospital_Onglyza a 
-- inner join (select distinct Product,Mkt from tblMktDefHospital) b on a.Product = b.Mkt
-- where a.LinkChartCode in ('R192','R252','R212','R272','R222','R282','R232','R292','R912','R972','R922','R982','R932','R992') 
-- go

-- insert into OutputHospital_Onglyza (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
-- select LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, 'USD', TimeFrame, X, XIdx, 
-- 	Y, 
-- 	IsShow
-- from OutputHospital_Onglyza where LinkChartCode in ('R192','R252','R212','R272','R222','R282','R232','R292','R912','R972','R922','R982','R932','R992')  
-- 	and Currency = 'RMB'
-- go

-- update OutputHospital_Onglyza set Series = left(b.Cpa_Name_English,50) 
-- from OutputHospital_Onglyza a
-- inner join tblHospitalMaster b on a.Series = b.id
-- where a.LinkChartCode in ('R192','R252','R212','R272','R222','R282','R232','R292','R912','R972','R922','R982','R932','R992') 
-- 	and isShow = 'Y'
-- go

-- update OutputHospital_Onglyza set X = 'MQT ' + Replace(right(convert(varchar(11),convert(datetime,x +'01',112),6),6),' ','''')
-- where LinkChartCode in ('R192','R252','R212','R272','R222','R282','R232','R292','R912','R972','R922','R982','R932','R992') 
-- go

-- -- reverse the Month to ascending order
-- update OutputHospital_Onglyza set XIdx = 13 - Xidx
-- where LinkChartCode in ('R192','R252','R212','R272','R222','R282','R232','R292','R912','R972','R922','R982','R932','R992') 
-- go

-- update OutputHospital_Onglyza SET Product = 'Onglyza'
-- go


-- delete OutputHospital_Onglyza where LinkChartCode in( 'D110','D130')
-- 	and Product = 'Onglyza'
-- go
-- insert into OutputHospital_Onglyza (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
-- select LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, 
-- 	Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow
-- from OutputHospital_All where LinkChartCode in( 'D110','D130')
-- 	and Product = 'Onglyza'
-- go

-- -- Duplicate R160/R170 of Glucophage for Onglyza
-- insert into OutputHospital_Onglyza (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
-- select LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, 'Onglyza' as Product, 
-- 	Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow
-- from OutputHospital_All where (LinkChartCode like 'R16%' or LinkChartCode like 'R17%') and Product = 'Glucophage' 
-- go
-- -- NEW R180
-- insert into OutputHospital_Onglyza (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
-- select LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, 
-- 	Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow
-- from OutputHospital_All where LinkChartCode like 'R18%' and Product = 'Onglyza' 
-- go
-- -- NIAD Tier 3 Hospital Performance by Class
-- -- Duplicate WITH R200/R260 of Glucophage
-- insert into OutputHospital_Onglyza (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow)
-- select LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, 'Onglyza' as Product, 
-- 	Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, IsShow
-- from OutputHospital_All where (LinkChartCode like 'R20%' or LinkChartCode like 'R26%') 
-- 	and Product = 'Glucophage'
-- go

-- --log
-- exec dbo.sp_Log_Event 'output','CIA_CPA','3_2_Out_Onglyza.sql','End',null,null
-- go

-- print 'over!'