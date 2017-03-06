use BMSChinaCIA_IMS --db4
GO
--2分23秒
exec dbo.sp_Log_Event 'Output','CIA','3_3_OutPut_afterDeal.sql','Start',null,null

update output_stage
set DataSource= case when linkchartcode in ('C100','C110','C210','C220','R320') then 'HKAPI' else 'IMS' end
go
if object_id(N'output',N'U') is not null
	drop table output
select * into output from output_stage	

update output
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
where product='coniel'
and series in ('CCB Market','Norvasc','Adalat','Plendil','Coniel','Yuan Zhi','Lacipil','Zanidip','CCB Others')

update output
set xIdx=case when x='CCB Market' then 1
				   when x='Norvasc' then 	2			   
				   when x='Adalat' then 3
				   when x='Plendil' then 4
				   when x='Coniel' then 5
				   when x='Yuan Zhi' then 6 
				   when x='Lacipil' then 7 
				   when x='Zanidip' then 8
				   when x='CCB Others' then 9
			  end	   
where product='coniel' and ( linkChartCode like 'd08%' or linkChartCode like 'R05%')
and x in ('CCB Market','Norvasc','Adalat','Plendil','Coniel','Yuan Zhi','Lacipil','Zanidip','CCB Others')


-----------------------------------------------------
-- delete
-----------------------------------------------------
--delete 
--from dbo.Output where linkchartcode in ('D021','D022') and product='Eliquis'


delete -- select * 
from [dbo].[Output] where linkchartcode  like 'D02%' 
and Product <> 'Baraclude' and TimeFrame='MTH'
GO

delete FROM [dbo].[Output] 
where [LinkChartCode] like 'R051'  and Product='ParaPlatin' and Series not in ('PARAPLATIN','Platinum Market')

delete 
FROM [dbo].[Output] 
where [LinkChartCode] like 'D02%' and Geo='China'


delete from [output] where Product='ParaPlatin' and (
    linkchartCode not like 'C12%' --IMS
and linkchartCode not like 'C13%'
and linkchartCode not like 'C14%'
and linkchartCode not like 'C15%'
and linkchartCode not like 'C16%'
and linkchartCode not like 'D02%'
and linkchartCode not like 'D08%'
and linkchartCode not like 'R04%'

and linkchartCode not like 'R40%'
and linkchartCode not like 'R05%'
and linkchartCode not like 'R41%'
and linkchartCode not like 'R46%'
and linkchartCode not like 'R49%'
and linkchartCode not like 'R50%'
and linkchartCode not like 'R51%'

--and linkchartCode not like 'R32%'--HKAPI
)



--todo : YTD
--delete others YTD
delete from [output] 
where linkChartCode in(
'C130','C140','C131','C141','D081','D082','D083','D084','D085','D086','D087','D088','D091','D092','D093','D094'
,'R020','R040','R090','R420','R430','R440','R451','R452','R460','R471'
,'R472','R491','R492'
)
and TimeFrame = 'YTD' and Product <> 'Baraclude'



delete from [output]
where (linkchartCode like 'R05%' 
or linkchartCode like 'R06%'
or linkchartCode like 'R40%'
or linkchartCode like 'R41%'
or linkchartCode like 'R50%')
and TimeFrame = 'YTD' and Product <> 'Baraclude'
GO


--Taxol
delete from [output] 
where linkChartCode in('R440') and TimeFrame = 'MQT' and Product  in ('Taxol','ParaPlatin')
delete from [output] 
where linkChartCode like 'R41%' and TimeFrame = 'MQT' and Product in ('Taxol','ParaPlatin')
delete from [output] 
where linkChartCode like 'R47%' and Product = 'Taxol' and Currency='RMB'
delete from [output] 
where linkChartCode in('R492') and Product = 'Taxol' and Currency='RMB' and TimeFrame = 'MQT' 
delete from [output] -- select *  from [output] 
where linkChartCode like 'R40%' and TimeFrame = 'MTH' and Product in ('Taxol','ParaPlatin')


--Paraplatin
delete from output where (category='Units' and Currency = 'UNIT') and Product = 'Paraplatin'
go
delete from output where (category='Adjusted patient number' or Currency = 'PN') and Product <> 'Paraplatin'
GO









---------------------------------------------------------------------------------------
-- update
---------------------------------------------------------------------------------------

--
select distinct Category,currency from output  where Product ='Paraplatin'

select distinct Category,currency from output  where Product <>'Paraplatin'
--

update output set Category='Value' where currency in ('RMB','USD') and linkchartCode not in ('C120','C121')
go

update output set Category='Adjusted patient number' 
where Product ='Paraplatin' and currency='PN'


update output set currency = 'UNIT' 
where Product ='Paraplatin' and Category='Adjusted patient number' and currency='PN'
go



-- select distinct Category,currency from output  where [LinkChartCode] like 'D08%' and  Product ='Paraplatin'
update output set Category='Dosing Units' where Category='Units' and Product <> 'Paraplatin'
go
update [output] set Category=case Currency 
when 'UN' then 'Dosing Units' 
when 'UNIT' then 'Dosing Units' 
else 'Value' end
where Product <> 'Paraplatin'
go





update [output]  
set LinkSeriesCode=Product+'_'+LinkChartCode+'_'+geo+cast(SeriesIdx as varchar(10))+Isshow 
--  select * from [output]
where LinkChartCode in ('C160') 
go


update output set timeframe = case timeframe when 'Rolling 3 Months' then 'MQT' else timeframe end
go

update output set Parentgeo='China'
where lev in('Region','China','Nation')
go

delete from output 
where series in('ARV Others','NIAD Others','ONCFCS Others') and LinkChartCode not in('C140','C141','D022','D024','D032','D042','R491','R492','R501','R502','C900')
go
delete from output
where X in('ARV Others','NIAD Others','ONCFCS Others') and LinkChartCode not in('C140','C141','D022','D024','D032','D042','R491','R492','R501','R502','C900')
go


update output set series='Total Contribution' where series like 'TotalContribution'
go
update output set series=replace(series,'Contribution','Contrib.') where series like '%Contrib%'
go
update output set series=replace(series,'DPP4','DPP-IV') where series like '%DPP4%'
go



IF EXISTS(
	SELECT 1 
	FROM OUTPUT A
	WHERE  (A.linkchartcode in ('C020','C030','C040','C050','C100','C110','R040','R320') and A.seriesidx in (1,2) and A.isshow='Y')
	or (A.linkchartcode in ('C060','C070','C080','C120','C121','R090') and A.seriesidx in (1))
	or (A.linkchartcode in('D081','D085','D091','D101','R030','R051','R061','R071','R081') and A.isshow='Y')
	or (A.linkchartcode ='R100' and A.product<>'Glucophage' and  A.seriesidx in (1))
	or (A.linkchartcode ='R110' and  A.seriesidx in (1))
	or (A.linkchartcode ='R100' and A.product='Glucophage' and  A.seriesidx in (1,2))
	or (A.linkchartcode ='R020' and A.product='Baraclude' and  A.series not like '%Growth%'and A.isshow='Y')
	or (A.linkchartcode ='R020' and A.product<>'Baraclude'and A.isshow='Y')
	or (A.linkchartcode  in('R401','R402','R411','R412') and A.isshow='Y')
	or (A.linkchartcode ='R420' and A.seriesidx in (1,2))
	or (A.linkchartcode ='R440' and A.seriesidx in (0))
	or (A.linkchartcode ='C201' and A.seriesidx <100)
	or (A.linkchartcode ='C210' and A.X not like '%Growth%')
	or (A.linkchartcode ='C220')
	or (A.linkchartcode in ('R670','R680') and A.seriesidx =1 and A.isshow='Y')
	or (A.linkchartcode in ('C120','C121') and A.seriesidx in (3))	
	GROUP BY linkchartcode,currency,ParentGeo,Geo,timeFrame,Product HAVING max(cast(y as float)) >5000
)
BEGIN
	truncate table tbldivnumber
	
	insert into tbldivnumber (linkchartcode,Moneytype,ParentGeo,Geo,Period,Product,Divide)
	select linkchartcode,currency,ParentGeo,Geo,timeFrame,Product, case when max(cast(y as float)) between 5000 and 5000000 then 1000
	when max(cast(y as float)) between 5000000 and 5000000000 then 1000000
	when max(cast(y as float)) >= 5000000000 then 1000000000 else 1 end
	 from output A where  (A.linkchartcode in ('C020','C030','C040','C050','C100','C110','R040','R320') and A.seriesidx in (1,2) and A.isshow='Y')
	or (A.linkchartcode in ('C060','C070','C080','C120','C121','R090') and A.seriesidx in (1))
	or (A.linkchartcode in('D081','D085','D091','D101','R030','R051','R061','R071','R081') and A.isshow='Y')
	or (A.linkchartcode ='R100' and A.product<>'Glucophage' and  A.seriesidx in (1))
	or (A.linkchartcode ='R110' and  A.seriesidx in (1))
	or (A.linkchartcode ='R100' and A.product='Glucophage' and  A.seriesidx in (1,2))
	or (A.linkchartcode ='R020' and A.product='Baraclude' and  A.series not like '%Growth%'and A.isshow='Y')
	or (A.linkchartcode ='R020' and A.product<>'Baraclude'and A.isshow='Y')
	or (A.linkchartcode  in('R401','R402','R411','R412') and A.isshow='Y')
	or (A.linkchartcode ='R420' and A.seriesidx in (1,2))
	or (A.linkchartcode ='R440' and A.seriesidx in (0))
	or (A.linkchartcode ='C201' and A.seriesidx <100)
	or (A.linkchartcode ='C210' and A.X not like '%Growth%')
	or (A.linkchartcode ='C220')
	or (A.linkchartcode in ('R670','R680') and A.seriesidx =1 and A.isshow='Y')
	or (A.linkchartcode in ('C120','C121') and A.seriesidx in (3))	
	group by linkchartcode,currency,ParentGeo,Geo,timeFrame,Product order by linkchartcode,currency,timeFrame

	update tbldivnumber
	set Dollar=case Divide when '1000' then 'Thousand' when '1000000' then 'Million' when '1000000000' then 'Billion'
	else '' end,
	Dol=case Divide when '1000' then '000' when '1000000' then 'mio.' when '1000000000' then 'bn.'
	else '' end
END	
go



update output set Color='4E71D1' 
where linkchartcode in (select distinct Code from db82.BMSChina_staging.dbo.WebChart where charturl = '../Charts/Column2D.swf')
go
update output
set color=B.rgb,
   r=b.r,
g=b.g,
b=b.b 
from output A inner join   db82.BMSChina_ppt.dbo.tblColorDef B
on replace(replace(A.series,' contrib.',''),' value','')=b.name where B.mkt='Prod'
go
update output
set color=B.rgb,
   r=b.r,
g=b.g,
b=b.b from output A inner join   db82.BMSChina_ppt.dbo.tblColorDef B
on A.series=b.name where B.mkt='Prod'
go
update output
set color=B.rgb,
   r=b.r,
g=b.g,
b=b.b from output A inner join   db82.BMSChina_ppt.dbo.tblColorDef B
on A.seriesidx=b.name 
where B.mkt='ALL' and A.series in(select geo from outputgeo)
go
update output
set color='4E71D1' where seriesidx=1 and LinkChartCode in('R090','R100','R110')
update output
set color='FF00FF' where series like '%Growth' and series not like '%Avg. Growth%' and LinkChartCode in('R090','R100','R110')
update output
set color='FF9900' where series like '%Avg. Growth%' and LinkChartCode in('R090','R100','R110')
update output
set color='4E71D1' where LinkChartCode in('R100') and Product='Glucophage' and Seriesidx in (1) 
update output
set color='CCCCFF' where LinkChartCode in('R100') and Product='Glucophage' and Seriesidx in (2)
update output
set color='FF00FF' where series like '%Growth' and series not like '%Avg. Growth%' and LinkChartCode in('R100')and Product='Glucophage' and Seriesidx in (2,4,6)
update output
set color='00FF00' where series like '%Avg. Growth%' and LinkChartCode in('R100') 
and Product='Glucophage' and Seriesidx in (4,6)
GO
update output
set color='4E71D1' where seriesidx=911000 and LinkChartCode in('R020')
update output
set color='666699' where seriesidx in(1000) and LinkChartCode in('R020')
go
update output
set color='00FF00' where seriesidx=2 and LinkChartCode in('R320','R040')
update output
set color='4E71D1' where seriesidx in(1) and LinkChartCode in('R320','R040')
update output
set color='FF00FF' where seriesidx=3 and LinkChartCode in('R320','R040')
go
update [Output]
set color='4E71D1' where series like 'China Market%' and LinkChartCode='C020'
update [Output]
set color='CCCCFF' where series like 'BMS Focus Market%' and LinkChartCode='C020'
go
update [Output]
set color='4E71D1' where series like 'Market%' and LinkChartCode='D050'
update [Output]
set color='CCCCFF' where series like 'BMS Product%' and LinkChartCode='D050'
go
update [Output]
set color='4E71D1' where series like 'Market%' and LinkChartCode='D051'
update [Output]
set color='CCCCFF' where series like 'BMS Product%' and LinkChartCode='D051'
GO
update [Output]
set color='00FF00' where seriesidx=2 and LinkChartCode='C030'
update [Output]
set color='4E71D1' where  seriesidx=1 and LinkChartCode='C030'
update [Output]
set color='00FF00' where  seriesidx=4 and LinkChartCode='C030'
update [Output]
set color='4E71D1' where seriesidx=3 and LinkChartCode='C030'
go
update [Output]
set color='00FF00' where seriesidx in(2,20) and LinkChartCode='R420'
update [Output]
set color='4E71D1' where  seriesidx in(1,10) and LinkChartCode='R420'
go
update [Output]
set color='00FF00' where seriesidx in(2,20) and LinkChartCode='R430'
update [Output]
set color='4E71D1' where  seriesidx in(1,10) and LinkChartCode='R430'
go
update [Output]
set color='00FF00' where seriesidx=2 and LinkChartCode in('C040','C050','C100')
update [Output]
set color='4E71D1' where seriesidx in(1) and LinkChartCode in('C040','C050','C100')
update [Output]
set color='FF00FF' where seriesidx=3 and LinkChartCode in('C040','C050','C100')
go
update [Output]
set color='4E71D1' where seriesidx=2 and LinkChartCode in('C110')
update [Output]
set color='CCCCFF' where seriesidx in(1) and LinkChartCode in('C110')
update [Output]
set color='FF00FF' where seriesidx=3 and LinkChartCode in('C110')
go
update [Output]
set color='4E71D1' where seriesidx=1 and LinkChartCode in('C060','C070') --series like '%Oct''11' and
update [Output]
set color='FF00FF' where series like 'Growth' and LinkChartCode in('C060','C070')
update [Output]
set color='FF9900' where series like '%Avg. Growth%' and LinkChartCode in('C060','C070')
go
update [Output]
set color='4E71D1' where series like 'Product Sales' and LinkChartCode in('C080')
update [Output]
set color='FF9900' where series like 'Product Growth' and LinkChartCode in('C080')
update [Output]
set color='FF00FF' where series like 'Market Growth' and LinkChartCode in('C080')
update [Output]
set color='34CD32' where series like 'Market Share' and LinkChartCode in('C080')
go
update [Output]
set color='4E71D1' where seriesidx=1 and LinkChartCode in('C120','c121')
update [Output]
set color='FF6600' where seriesidx in(4) and LinkChartCode in('C120','c121')
update [Output]
set color='34CD32' where seriesidx=5 and LinkChartCode in('C120','c121')
GO


update output
set color='CCCCFF' where seriesidx in (3) and linkchartcode in ('C120','C121')

update output
set 
   r=b.r,
g=b.g,
b=b.b from output A inner join   db82.BMSChina_ppt.dbo.tblRGBToColor B
on A.color=b.rgb 
go


IF EXISTS(
	SELECT 1 
	FROM OUTPUT A
	WHERE  (A.linkchartcode in ('C020','C030','C040','C050','C100','C110','R040','R320') and A.seriesidx in (1,2) and A.isshow='Y')
	or (A.linkchartcode in ('C060','C070','C080','C120','C121','R090') and A.seriesidx in (1))
	or (A.linkchartcode in('D081','D085','D091','D101','R030','R051','R061','R071','R081') and A.isshow='Y')
	or (A.linkchartcode ='R100' and A.product<>'Glucophage' and  A.seriesidx in (1))
	or (A.linkchartcode ='R110' and  A.seriesidx in (1))
	or (A.linkchartcode ='R100' and A.product='Glucophage' and  A.seriesidx in (1,2))
	or (A.linkchartcode ='R020' and A.product='Baraclude' and  A.series not like '%Growth%'and A.isshow='Y')
	or (A.linkchartcode ='R020' and A.product<>'Baraclude'and A.isshow='Y')
	or (A.linkchartcode  in('R401','R402','R411','R412') and A.isshow='Y')
	or (A.linkchartcode ='R420' and A.seriesidx in (1,2))
	or (A.linkchartcode ='R440' and A.seriesidx in (0))
	or (A.linkchartcode ='C201' and A.seriesidx <100)
	or (A.linkchartcode ='C210' and A.X not like '%Growth%')
	or (A.linkchartcode ='C220')
	or (A.linkchartcode in ('R670','R680') and A.seriesidx =1 and A.isshow='Y')
	GROUP BY linkchartcode,currency,ParentGeo,Geo,timeFrame,Product HAVING max(cast(y as float)) >5000
)
BEGIN
	update output set Y = cast(Y as float)/B.divide--round(cast(Y as float)/B.divide,1)
	from output A 
	left join tblDivNumber B 
	on 
		A.timeframe=B.Period and A.Currency=B.Moneytype
	and A.linkchartcode=B.linkchartcode and A.geo=B.geo 
	and A.Product=B.Product and A.ParentGeo=B.ParentGeo
	where 
	   (A.linkchartcode in ('C020','C030','C040','C050','C100','C110','R040','R320') and A.seriesidx in (1,2)and A.isshow='Y')
	or (A.linkchartcode in ('C060','C070','C080','C120','C121','R090') and A.seriesidx in (1))
	or (A.linkchartcode in('D081','D085','D091','D101','R030','R051','R061','R071','R081') and A.isshow='Y')
	or (A.linkchartcode ='R100' and A.product not in ('Glucophage','Onglyza') and  A.seriesidx in (1))
	or (A.linkchartcode ='R110' and  A.seriesidx in (1))
	or (A.linkchartcode ='R100' and A.product in('Glucophage','Onglyza') and  A.seriesidx in (1,2))
	or (A.linkchartcode ='R020' and A.product='Baraclude' and  A.series not like '%Growth%' and A.isshow='Y')
	or (A.linkchartcode ='R020' and A.product<>'Baraclude'and A.isshow='Y')
	or (A.linkchartcode  in('R401','R402','R411','R412') and A.isshow='Y')
	or (A.linkchartcode ='R420' and A.seriesidx in (1,2))
	or (A.linkchartcode ='R440' and A.seriesidx in (0))
	or (A.linkchartcode ='C201' and A.seriesidx <100)
	or (A.linkchartcode ='C210' and A.X not like '%Growth%')
	or (A.linkchartcode ='C220')
	or (A.linkchartcode in ('R670','R680') and A.seriesidx =1 and A.isshow='Y')
	or (A.linkchartcode in ('C120','C121') and A.seriesidx in (3))
	--Sprycel Market HKAPI table
	update Output set Series=Series+ ' ('+B.Dol+', '+B.Moneytype+')'
	from output A 
	inner join tblDivNumber B 
	on 
		A.timeframe=B.Period and A.Currency=B.Moneytype
	and A.linkchartcode=B.linkchartcode and A.geo=B.geo and A.Product=B.Product
	and A.ParentGeo=B.ParentGeo 
	where A.linkchartcode='C210' and A.ISshow='D'
	
END	
go



declare @n int 
select   @n=count(1)  from   syscolumns   where   id=object_id('output')   and   name='inty'  
if @n<>0 
begin 
alter table output drop column inty
end 
go



insert into Output
select DataSource
	  ,[GeoID]
      ,[ProductID]
      ,[LinkChartCode]
      ,replace([LinkSeriesCode],'Glucophage','Onglyza')
      ,[Series]
      ,[SeriesIdx]
      ,[Category]
      ,'Onglyza'
      ,[Lev]
      ,[ParentGeo]
      ,[Geo]
      ,[Currency]
      ,[TimeFrame]
      ,[X]
      ,[XIdx]
      ,[Y]
      ,[LinkedY]
      ,[Size]
      ,[OtherParameters]
      ,[Color]
      ,[R]
      ,[G]
      ,[B]
      ,[IsShow]
 from output where linkchartcode in (
select distinct linkchartcode from output where Product='Glucophage' and linkchartcode not in (
select distinct linkchartcode from output where Product='Onglyza') ) and Product='Glucophage' and linkchartcode not between 'R400' and 'R520' 
go
insert into tbldivnumber
select Period, Moneytype, 'Onglyza', ParentGeo, Geo, LinkchartCode, Divide, Dollar, Dol
 from tbldivnumber where linkchartcode in (
select distinct linkchartcode from tbldivnumber where Product='Glucophage' and linkchartcode not in (
select distinct linkchartcode from tbldivnumber where Product='Onglyza') ) and Product='Glucophage' and linkchartcode not between 'R400' and 'R520' 
go

--update output
--set OtherParameters=LinkedY
--go
update output
set LinkedY=B.ID from output A inner join dbo.outputgeo B
on A.LinkedY=B.geo and a.parentgeo=b.parentgeo and A.product=B.product
where A.linkchartcode in ('C120','C121')
 
update output
set LinkedY=B.ID from output A inner join outputgeo B
on A.LinkedY=B.geo and a.geo=b.parentgeo and A.product=B.product
where linkchartcode like 'D02%' or linkchartcode like 'D03%' or linkchartcode like 'D04%'
go
--update ProudctId and Geoid 20120214
update Output
set ProductID=B.ID from Output A inner join
   (select * from db82.BMSChina_staging.dbo.WebPage 
         where ParentID=(select ID from db82.BMSChina_staging.dbo.WebPage 
                           where Code='DashBoard')) B
on A.Product=B.Code 
go
update Output
set ProductID=B.ID from Output A inner join
   (select * from db82.BMSChina_staging.dbo.WebPage 
         where ParentID=(select ID from db82.BMSChina_staging.dbo.WebPage 
                           where Code='DashBoard')) B
on left(A.Product,7)=B.Code  where a.product like 'eliquis%'
go
update output
set GeoID=B.ID from output A inner join Outputgeo B
on A.Geo=B.Geo and A.ParentGeo=B.ParentGeo and A.Product=B.Product
go
update output
set GeoID=B.ID from output A inner join Outputgeo B
on A.Geo=B.Geo and A.ParentGeo=B.ParentGeo and left(A.Product,7)=B.Product
where a.product like 'eliquis%'
go
update output
set GeoID=B.ID from output A inner join Outputgeo B
on A.Geo=B.Geo where A.geo='China' and A.GeoID is null
go
select distinct geo,lev,parentgeo,product from output where geoid is null
GO





--颜色调整

update output set Color = 'CCCCFF' -- select  * from output
where LinkChartCode in ('D082','D084','R054') and Product = 'Taxol' and Series = 'ANZATAX'


update output set color='FF99CC' where Series='AO XIAN DA' and LinkChartCode in('C130','C140','C131','C141','C900')
update output set color='00CCFF' where Series='BO BEI' and LinkChartCode in('C130','C140','C131','C141','C900')
update output set color='FFCC99' where Series='CISPLATIN' and LinkChartCode in('C130','C140','C131','C141','C900')
update output set color='993366' where Series='JIE BAI SHU' and LinkChartCode in('C130','C140','C131','C141','C900')

update output set color='666699' where Series='LU BEI' and LinkChartCode in('C130','C140','C131','C141','C900')
update output set color='17B65F' where Series='NUO XIN' and LinkChartCode in('C130','C140','C131','C141','C900')
update output set color='C0C0C0' where Series='PARAPLATIN' and LinkChartCode in('C130','C140','C131','C141','C900')
update output set color='808080' where Series='Platinum Others' and LinkChartCode in('C130','C140','C131','C141','C900')

update OUTPUT
SET
color = 'FFFF00',
R=255,
G=255,
B=000
WHERE linkchartcode = 'c130' and series = 'Adefovir Dipivoxil'


update OUTPUT
SET
color = 'FF0000',
R=255,
G=000,
B=000
WHERE linkchartcode = 'c130' and series = 'Entecavir'

update output
set color=null,
R=null,
G=null,
B=null
where linkchartcode like 'R65%' and product='Coniel' and Series='CCB Market'

--

delete from output where  currency='UNIT' and category <>'Adjusted patient number' and Product = 'Paraplatin'


update output 
set X=X+' (K RMB)'
where linkchartcode in ('R620','R630','R720','R730') and X IN ('ACEI MS Size','CCB MS Size','VTEP MS Size')

exec dbo.sp_Log_Event 'Output','CIA','3_3_OutPut_afterDeal.sql','End',null,null