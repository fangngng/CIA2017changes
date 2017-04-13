
SELECT * FROM dbo.WebChartTitle
where Product not in ('baraclude', 'Monopril', 'Taxol', 'Sprycel' )


SELECT distinct LinkChartCode, Product FROM dbo.WebChartTitle
where Product not in ('baraclude', 'Monopril', 'Taxol', 'Sprycel' )

SELECT distinct Product FROM dbo.WebChartTitle

go 

SELECT * FROM tblPPTGraphDef 
SELECT * FROM tblPPTOutputCombine 

SELECT distinct Code
from BMSChina_ppt.dbo.tblPPTSection 
where Page = 'brandreport'
	and Product = 'baraclude'

SELECT * FROM BMSChina_ppt.dbo.tblPPTSection 
where Page = 'Dashboard'
	and Product in ('Portfolio', 'baraclude','Monopril', 'Taxol', 'Sprycel')
order by Page, Product, Lev 

SELECT * FROM dbo.tblPPTSection
where Page = 'brandreport' and Product in ('baraclude')

use BMSChina_ppt
GO 

-- c170

select distinct Product,Parentcode,parentgeo,Geo,
    Currency,TimeFrame,Category,outputname,Caption, case when Product='Baraclude' and ParentCode='D020' and TimeFrame='MTH' then replace( SlideTitle,'MQT/MTH','MTH' ) else SlideTitle end as SlideTitle ,case when parentcode='c160' then subCaption else '-' end as subCaption
from tblChartTitle A 
where ( exists (select * from outputgeo B where a.geo=b.geo and ( a.product=b.product or left(a.product,7)=b.product)) 
    or  a.linkchartcode  like'c%' or a.linkchartcode like 'r%' )
    and not (ParentCode in('R400','R410','R500') and Category in ( 'Dosing Units','Adjusted patient number') ) 
    AND A.ParentCode = 'c170'

--DELETE tblChartTitle WHERE ParentCode = 'c170' AND Product NOT IN ('baraclude')

SELECT * FROM dbo.Output_PPT 
where LinkChartCode = 'r351'

SELECT * FROM tblPPTGraphDef 
where LinkChartCode = 'R350'

SELECT * FROM tblChartTitle 
where LinkChartCode = 'r351'

SELECT * FROM tblPPTGraphDef 
SELECT * FROM Temp_DataSource 

select Mkt,'Units' as Category,Department as X,H1Rank as XIdx  
	from tempOutputRx where Lev  = 'Nat' and Mkt in('NIAD','HYPFCS','ARV','ONCFCS','Platinum','CCB') and Prod = '000' 

--select dbo.fnGetParameter(
--select dbo.fnAddColumns( 'MQT', 'lc', 24)
--select dbo.fnGetformulaMAT( 'LC', 24)
--select dbo.fnGetformulaR3M( 'LC', 24)
--select dbo.fnGetformulaQTR( 'LC', 2)
--select dbo.fnGetformulaYTD( 'LC', 24)
--select dbo.fun_upperFirst
--select dbo.fun_upperFirst

use BMSChina_staging 
go 

--select chartURL, highChartType, * from webchart
--go
--alter table webchart 
--add HighChartType varchar(50)
--go 

--update webchart 
--set HighchartType  = 'StackedColumn'
--where chartURL like '%Stacked%'

--update webchart 
--set HighchartType  = 'Line'
--where chartURL like '%Line%'

--update webchart 
--set HighchartType  = 'StackedColumnLineDY'
--where chartURL like '%Stacked%'
--	and chartURL like '%LineDY%'

--update webchart 
--set HighchartType  = 'StackedColumnLineDY'
--where chartURL not like '%Line%' and chartURL not like '%Stacked%'
SELECT *  FROM sys.objects as a 
inner join sys.syscomments as b on a.object_id = b.id 
where b.text like '%1%'

select distinct LinkChartCode,LinkProductId,LinkGeoId,Category,TimeFrame,CategoryIdx,TimeFrameIdx from WebChartTitle 
WHERE LinkChartCode = 'd081'

SELECT * FROM dbo.WebChartTitle WHERE LinkChartCode = 'c140'
SELECT * FROM dbo.WebChart WHERE Code = 'c140'

SELECT * FROM tblPPTOutputCombine 

 select distinct case left(OutputName,1) when 'R' then 'BrandReport' else 'Dashboard' end as Page,
   product,lev,parentgeo,geo 
   from tblPPTOutputCombine 
   where lev<>'' 

   SELECT * FROM tblPPTSection 

	SELECT a.Code, a.IsSection,a.IsCover,b.OutputName
     from (
       select Code,IsSection, IsCover,id from tblPPTSection
       where Page = 'Dashboard' and Product = 'Baraclude' and Lev = 'nation'
			AND Product IN ('Monopril', 'Taxol', 'Sprycel', 'Baraclude', 'Portfolio')
			AND code NOT IN ('c140', 'c170')
     ) a left join (
         select OutputName,OutputName4Rank
         From tblPPTOutputCombine
         where Product = 'Baraclude' and Lev = 'nation' and Parentgeo = 'China' and Geo = 'China'
               and outputname not like '%NOAC%' 
     ) b on a.code = left(b.OutputName,4)
     order by a.id,b.OutputName4Rank


SELECT * FROM tblcharttitle
SELECT * FROM tblPPTSection

DELETE tblPPtsection
WHERE (product NOT IN ('Monopril', 'Taxol', 'Sprycel', 'Baraclude', 'Portfolio') AND page = 'Dashboard')
	or (product NOT IN ('Baraclude') AND page = 'BrandReport')

DELETE tblPPTSection 
WHERE product NOT IN ('Baraclude') AND lev NOT IN ('Nation')

SELECT DISTINCT page, product FROM tblPPTSection 

 
 SELECT * FROM tblSlide 
 WHERE  SlideName like 'R170%' 
 and status='Y'

-- brand report need output 
  --select a.Code, a.IsSection,a.IsCover,b.OutputName
  select DISTINCT a.Code
    from (
      select Code,IsSection, IsCover,id from tblPPTSection
    ) a left join (
        select OutputName,OutputName4Rank
        From tblPPTOutputCombine
    ) b on a.code = left(b.OutputName,4)
    order by a.id,b.OutputName4Rank

	  select distinct case left(OutputName,1) when 'R' then 'BrandReport' else 'Dashboard' end as Page,
     product,lev,parentgeo,geo 
     from tblPPTOutputCombine 
     where lev<>'' 

	 delete  
	  FROM dbo.tblPPTOutputCombine
	 WHERE product NOT IN ('Monopril', 'Taxol', 'Sprycel', 'Baraclude', 'Portfolio')

	 SELECT * FROM tblpptsection
	 SELECT * FROM tblpptsection_bak_20170407

	 INSERT INTO tblpptsection
	 SELECT *
	 FROM		tblpptsection_bak_20170407
			  WHERE		Page = 'Dashboard'
						AND Product = 'Portfolio'
						AND Lev = 'Portfolio'
	 
	 select a.Code, a.IsSection,a.IsCover,b.OutputName from (   select Code,IsSection, IsCover,id from tblPPTSection   where Page = 'Dashboard' and Product = 'Portfolio' and Lev = 'Portfolio' ) a left join (     select OutputName,OutputName4Rank     From tblPPTOutputCombine     where Product = 'Portfolio' and Lev = 'Portfolio' and Parentgeo = 'China' and Geo = 'China'           and outputname not like '%NOAC%'  ) b on a.code = left(b.OutputName,4) order by a.id,b.OutputName4Rank


	  select a.Code, a.IsSection,a.IsCover,b.OutputName from (   select Code,IsSection, IsCover,id from tblPPTSection   where Page = 'Dashboard' and Product = 'Sprycel' and Lev = 'Nation' ) a left join (     select OutputName,OutputName4Rank     From tblPPTOutputCombine     where Product = 'Sprycel' and Lev = 'Nation' and Parentgeo = 'China' and Geo = 'China'           and outputname not like '%NOAC%'  ) b on a.code = left(b.OutputName,4) order by a.id,b.OutputName4Rank
	  select a.Code, a.IsSection,a.IsCover,b.OutputName from (   select Code,IsSection, IsCover,id from tblPPTSection   where Page = 'Dashboard' and Product = 'Sprycel' and Lev = 'Nation' ) a left join (     select OutputName,OutputName4Rank     From tblPPTOutputCombine     where Product = 'Sprycel' and Lev = 'Nation' and Parentgeo = 'China' and Geo = 'China'           and outputname not like '%NOAC%'  ) b on a.code = left(b.OutputName,4) order by a.id,b.OutputName4Rank


	  select * from tblPPTGraphDef where code IN ('c170' , 'c140')

	  select Distinct Series,SeriesIdx from output_ppt 
	  WHERE  IsShow = 'L' and LinkChartCode = 'c170' and Product='Baraclude' and parentgeo='China' and geo='China'  and Currency='USD'and Timeframe='MTH' and Category='Value' order by seriesidx

	  select Distinct Series,SeriesIdx from output_ppt 
	  WHERE  IsShow = 'L' and LinkChartCode = 'c140' and Product='Baraclude' and parentgeo='China' and geo='China'  and Currency='USD'and Timeframe='MTH' and Category='Value' order by seriesidx

	  --UPDATE tblpptsection 
	  --SET notes = 'MNCs Performance vs Total China Market'
	  --WHERE code = 'c020'

	  --UPDATE tblpptsection 
	  --SET notes = 'Top MNCs Performance - IMS'
	  --WHERE code = 'c040'

	  
	  --UPDATE tblpptsection 
	  --SET notes = 'Top MNCs Performance - RDPAC'
	  --WHERE code = 'c100'

	  
	  --UPDATE tblpptsection 
	  --SET notes = 'Top MNCs Products Performance - IMS'
	  --WHERE code = 'c050'

	  --UPDATE tblpptsection 
	  --SET notes = 'Top MNCs Products Performance - RDPAC'
	  --WHERE code = 'c110'


	  SELECT * FROM tblpptsection WHERE product = 'Portfolio'

