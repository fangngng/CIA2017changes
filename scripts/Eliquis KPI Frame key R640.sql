
--NOAC相关PPT数据检查
select * from BMSChinaCIA_IMS.dbo.output_stage  where linkchartcode='C121' and product='Eliquis NOAC' 

select * from BMSChinaCIA_IMS.dbo.output_stage  where linkchartcode='C131' and product='Eliquis NOAC' 

select * from BMSChinaCIA_IMS.dbo.output_stage  where linkchartcode='D023' and product='Eliquis NOAC' 

select * from BMSChinaCIA_IMS.dbo.output_stage  where linkchartcode='D024' and product='Eliquis NOAC' 

select * from BMSChinaCIA_IMS.dbo.output_stage  where linkchartcode='D085' and product='Eliquis NOAC' 

select * from BMSChinaCIA_IMS.dbo.output_stage  where linkchartcode='D086' and product='Eliquis NOAC'

select * from BMSChinaCIA_IMS.dbo.output_stage  where linkchartcode='D087' and product='Eliquis NOAC' 

select * from BMSChinaCIA_IMS.dbo.output_stage  where linkchartcode='D088' and product='Eliquis NOAC'  

--eliquis
select * from  Mid_KPIFrame_CPAPart_Eliquis where prod='000'
select * from OutputHospital_All where LinkChartCode = 'R640' and product='Eliquis VTEP' and x='Hosp. # matched with BMS hospital'

--Monopril
select * from Mid_KPIFrame_CPAPart_HYP where prod='000'
select * from OutputPerformanceByHosp_CV_Modi_Slide8_Mid where y>1
	 select * from OutputHospital_All where LinkChartCode = 'R640' and product='Monopril' and x='Hosp. # matched with BMS hospital'
--Coniel
	select* from Mid_KPIFrame_CPAPart_CCB where prod='000'
	 select * from OutputHospital_All where LinkChartCode = 'R640' and product='Coniel' and x='Hosp. # matched with BMS hospital'


	 SELECT CAST('Total' AS NVARCHAR(100)) AS Type,a.DataSource, a.Mkt, a.Prod,c.ProductName,
	   SUM(a.UYTD) AS UYTD,SUM(a.UYTDStly) AS UYTDStly,SUM(a.VYTD) AS VYTD,SUM(a.VYTDStly) AS VYTDStly,COUNT(DISTINCT a.Cpa_id) AS Hosp_Count
--INTO OutputPerformanceByHosp_CV_Modi_Slide8_Coniel
from dbo.tempHospitalData_CIA_CV_Modification_Slide8_Coniel a join
(SELECT DISTINCT id,cpa_name,cpa_code FROM tblHospitalMaster) b on a.cpa_id = b.id join
(SELECT DISTINCT MKT,PROD,ProductName FROM tblMktDefHospital) c on c.mkt = a.mkt and c.prod= a.prod join
(
	select distinct [cpa name] ,[CPA Code]
	from BMS_CPA_Hosp_Category 
	where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Coniel Hospital Category] <> '#N/A' 	
) d ON d.[cpa code]=b.cpa_code
where a.mkt = 'CCB'
GROUP BY a.DataSource,a.Mkt, a.Prod,c.ProductName

	 SELECT *
	FROM OutputPerformanceByHosp_CV_Modi_Slide8_Coniel WHERE TYPE = 'Total' AND Prod='000'

	 select Type,DataSource,Mkt,Prod,Productname,
		cast(hosp_Count as float) as hosp_Count,cast(MarketContr as float) as MarketContr,
		cast(ProductMarketShare as float) ProductMarketShare ,cast(ProductMarketGrowth as float) as ProductMarketGrowth
		from OutputPerformanceByHosp_CV_Modi_Slide8_Output_Coniel where prod=100