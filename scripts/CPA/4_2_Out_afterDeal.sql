use BMSChinaMRBI --DB4
go
exec dbo.sp_Log_Event 'output','CIA_CPA','4_2_Out_afterDeal.sql','Start',null,null
--Time:00:11

update OutputHospital
set SeriesIdx=case when Series='CCB Market' then 1
				   when Series='Norvasc' then 	2			   
				   when Series='Adalat' then 3
				   when Series='Plendil' then 4
				   when Series='Coniel' then 5
				   when Series='Yuan Zhi' then 6 
				   when Series='Lacipil' then 7 
				   when Series='Zanidip' then 8
				   when Series='CCB Others' then 9
			  end	   
where product='coniel' and LinkChartCode not in ('D050','D051') and LinkChartCode not in ('D110','D111')
and series in ('CCB Market','Norvasc','Adalat','Plendil','Coniel','Yuan Zhi','Lacipil','Zanidip','CCB Others')



select  distinct category,Currency from OutputHospital where  Product ='Paraplatin'

select  distinct category,Currency from OutputHospital where  Product <>'Paraplatin'



--
delete from OutputHospital where (category='Adjusted patient number' and Currency='UNIT') and Product <> 'Paraplatin'

delete from OutputHospital where (category='Volume' and Currency='UNIT') and Product = 'Paraplatin'
GO



delete from OutputHospital where Product='ParaPlatin' and (
    linkchartCode not like 'D05%' --CPA
and linkchartCode not like 'D11%'
and linkchartCode not like 'D13%'
and linkchartCode not like 'R53%'
)
GO





PRINT (N'-------------------------
 OutputHospital : 后期处理
---------------------------------')


update outputHospital set Category = 'Dosing Units' where Category = 'Volume'
update outputHospital set Category = 'Dosing Units' where Category = 'Units'
go





update OutputHospital set ParentGeo = 'China' where lev = 'region'
go
update OutputHospital set ParentGeo = 'China' where lev = 'Nat'
go
update OutputHospital set ParentGeo = 'China' where lev = 'Nation'
go
update OutputHospital set LinkSeriesCode = Product + '_' + LinkChartCode+'_' + Geo + IsShow + cast(SeriesIdx as varchar)
go

-- patch the data
--todo no growth for Onglyza
update OutputHospital set Y = null
where LinkChartCode in('D050','D051','D060','D110','D111') and Product = 'Onglyza' and SeriesIdx = 4
go
-- todo no growth for Onglyza/Galvus 
update OutputHospital set Y = null
where LinkChartCode in('R162','R164','R172','R174','R182','R184') and Series in('Onglyza','Galvus')
go

update OutputHospital set Y = null
where IsShow = 'D' and Product = 'Onglyza' and Series in ('Onglyza GR','Galvus GR')
go

update OutputHospital set Y = null
-- select * from OutputHospital
where (LinkChartCode like 'R17%' or LinkChartCode like 'R18%' or LinkChartCode like 'R16%' or LinkChartCode like 'R15%') and cast(Y as float) > 10
go





if object_id(N'tblHospDivNumber',N'U') is not null
	drop table tblHospDivNumber
go
select 
    Product
  , Category
  , TimeFrame
  , Currency
  , ParentGeo
  , Geo
  , LinkChartCode
  , case when max(cast(Y as float)) between 5000 and 5000000 then 1000
         when max(cast(Y as float)) between 5000000 and 5000000000 then 1000000
         when max(cast(Y as float)) >= 5000000000 then 1000000000 else 1 
    end as Divide
  , cast ('' as varchar(10)) Dollar
  , cast ('' as varchar(10)) Dol
into tblHospDivNumber
from OutputHospital
where  (LinkChartCode in ('D050','D051','D060','D110','D111') and SeriesIdx in (1,2)) or LinkChartCode ='R480' or (LinkChartCode = 'C202' and SeriesIdx in(10,20,30))
group by TimeFrame,Currency,Product,Category, ParentGeo,Geo,LinkChartCode
having max(cast(y as float))>=5000
go

update tblHospDivNumber set Dollar = 'Billion',Dol = 'bn.'  --1000000000	Billion	bil.
where Divide = 1000000000
go
update tblHospDivNumber set Dollar = 'Million',Dol = 'mio.' --1000000	Million	mil.
where Divide = 1000000
go
update tblHospDivNumber set Dollar = 'Thousand',Dol = '000' --1000	Thousand	000
where Divide = 1000
go


update OutputHospital set 
	Y = Y / b.divide
from OutputHospital a
inner join tblHospDivNumber b on 
	a.Product = b.Product
	and a.Category = b.Category
	and a.timeFrame = b.TimeFrame
	and a.Currency = b.Currency
	and a.parentGeo = b.ParentGeo
	and a.Geo = b.Geo
	and a.LinkChartcode = b.LinkChartCode
	and a.IsShow = 'Y'
where (a.LinkChartCode in ('D050','D051','D060','D110','D111') and SeriesIdx in (1,2) and a.Isshow = 'Y') 
	or a.LinkChartCode = 'R480'
	or (a.LinkChartCode = 'C202' and a.IsShow = 'Y' and SeriesIdx in(10,20,	30))
go

-- select * from OutputHospital where color is not null
update OutputHospital set 
	color=B.rgb,
	r=b.r,
	g=b.g,
	b=b.b 
from OutputHospital A 
inner join DB82.BMSChina_PPT.dbo.tblColorDef B on A.series=b.name
where a.IsShow = 'Y'
go

update OutputHospital set 
	color=B.rgb,
	r=b.r,
	g=b.g,
	b=b.b 
from OutputHospital A 
inner join DB82.BMSChina_PPT.dbo.tblColorDef B 
on b.Mkt = 'All' and A.seriesidx=b.name
where a.LinkChartCode in ('R192','R252','R202','R262','R212','R272','R222','R282','R232','R292','R242','R302','R902','R962','R912','R972','R922','R982','R932','R992') and a.IsShow = 'Y'
go

-- select count(*) from OutputHospital where color is  null

update OutputHospital set color='00FF00'
where linkchartcode ='R480'  and seriesidx='1'
go
update OutputHospital set color='00FF00'
where linkchartcode in('D050','D051','D060')  and seriesidx='1'
go
update OutputHospital set color='00CCFF'
where linkchartcode in('D050','D051','D060')  and seriesidx='2'
go
update OutputHospital set color='00CCFF'
where linkchartcode in('D050','D051','D060')  and seriesidx='3'
go
update OutputHospital set color='666699'
where linkchartcode in('D050','D051','D060')  and seriesidx='4'
go
update OutputHospital set color='00FF00'
where linkchartcode='d110'  and seriesidx='1'
go
update OutputHospital set color='00CCFF'
where linkchartcode='d110'  and seriesidx='2'
go
update OutputHospital set color='00CCFF'
where linkchartcode='d110'  and seriesidx='3'
go
update OutputHospital set color='666699'
where linkchartcode='d110'  and seriesidx='4'
go
update OutputHospital set color='00FF00'
where linkchartcode='d111'  and seriesidx='1'
go
update OutputHospital set color='00CCFF'
where linkchartcode='d111'  and seriesidx='2'
go
update OutputHospital set color='00CCFF'
where linkchartcode='d111'  and seriesidx='3'
go
update OutputHospital set color='666699'
where linkchartcode='d111'  and seriesidx='4'
go
update OutputHospital set color='00CCFF'
where linkchartcode='d130'  and seriesidx='1'
go
update OutputHospital set color='CCCCFF'
where linkchartcode='d130'  and seriesidx='2'
go
update OutputHospital set color='00CCFF'
where linkchartcode='d150'  and seriesidx='1'
go
update OutputHospital set color='CCCCFF'
where linkchartcode='d150'  and seriesidx='2'
go
exec dbo.sp_Log_Event 'output','CIA_CPA','4_2_Out_afterDeal.sql','End',null,null
