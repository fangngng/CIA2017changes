
SELECT * FROM dbo.WebChartTitle
where Product not in ('baraclude', 'Monopril', 'Taxol', 'Sprycel' )


SELECT distinct LinkChartCode, Product FROM dbo.WebChartTitle
where Product not in ('baraclude', 'Monopril', 'Taxol', 'Sprycel' )

SELECT distinct Product FROM dbo.WebChartTitle

go 

SELECT * FROM tblPPTGraphDef 
SELECT * FROM tblPPTOutputCombine 

SELECT distinct Code
from tblPPTSection 
where Page = 'brandreport'
	and Product = 'baraclude'

SELECT * FROM tblPPTSection 
where Page = 'Dashboard'
	and Product in ('Portfolio', 'baraclude','Monopril', 'Taxol', 'Sprycel')
order by Page, Product, Lev 

SELECT * FROM dbo.tblPPTSection
where Page = 'brandreport' and Product in ('baraclude')

use BMSChina_ppt
go 


SELECT * FROM dbo.Output_PPT 
where LinkChartCode = 'r351'

SELECT * FROM tblPPTGraphDef 
where LinkChartCode = 'R350'

SELECT * FROM tblChartTitle 
where LinkChartCode = 'r351'



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

use BMSChina_staging_test 
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