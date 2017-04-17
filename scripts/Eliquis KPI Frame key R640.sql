
--NOAC相关PPT数据检查
SELECT *
FROM BMSChinaCIA_IMS.dbo.output_stage
WHERE linkchartcode='C121' AND product='Eliquis NOAC'

SELECT *
FROM BMSChinaCIA_IMS.dbo.output_stage
WHERE linkchartcode='C131' AND product='Eliquis NOAC'

SELECT *
FROM BMSChinaCIA_IMS.dbo.output_stage
WHERE linkchartcode='D023' AND product='Eliquis NOAC'

SELECT *
FROM BMSChinaCIA_IMS.dbo.output_stage
WHERE linkchartcode='D024' AND product='Eliquis NOAC'

SELECT *
FROM BMSChinaCIA_IMS.dbo.output_stage
WHERE linkchartcode='D085' AND product='Eliquis NOAC'

SELECT *
FROM BMSChinaCIA_IMS.dbo.output_stage
WHERE linkchartcode='D086' AND product='Eliquis NOAC'

SELECT *
FROM BMSChinaCIA_IMS.dbo.output_stage
WHERE linkchartcode='D087' AND product='Eliquis NOAC'

SELECT *
FROM BMSChinaCIA_IMS.dbo.output_stage
WHERE linkchartcode='D088' AND product='Eliquis NOAC'

--eliquis
SELECT *
FROM Mid_KPIFrame_CPAPart_Eliquis
WHERE prod='000'
SELECT *
FROM OutputHospital_All
WHERE LinkChartCode = 'R640' AND product='Eliquis VTEP' AND x='Hosp. # matched with BMS hospital'

--Monopril
SELECT *
FROM Mid_KPIFrame_CPAPart_HYP
WHERE prod='000'
SELECT *
FROM OutputPerformanceByHosp_CV_Modi_Slide8_Mid
WHERE y>1
SELECT *
FROM OutputHospital_All
WHERE LinkChartCode = 'R640' AND product='Monopril' AND x='Hosp. # matched with BMS hospital'

--Coniel
SELECT*
FROM Mid_KPIFrame_CPAPart_CCB
WHERE prod='000'
SELECT *
FROM OutputHospital_All
WHERE LinkChartCode = 'R640' AND product='Coniel' AND x='Hosp. # matched with BMS hospital'


SELECT CAST('Total' AS NVARCHAR(100)) AS Type, a.DataSource, a.Mkt, a.Prod, c.ProductName,
	SUM(a.UYTD) AS UYTD, SUM(a.UYTDStly) AS UYTDStly, SUM(a.VYTD) AS VYTD, SUM(a.VYTDStly) AS VYTDStly, COUNT(DISTINCT a.Cpa_id) AS Hosp_Count
--INTO OutputPerformanceByHosp_CV_Modi_Slide8_Coniel
FROM dbo.tempHospitalData_CIA_CV_Modification_Slide8_Coniel a JOIN
	(SELECT DISTINCT id, cpa_name, cpa_code
	FROM tblHospitalMaster) b ON a.cpa_id = b.id JOIN
	(SELECT DISTINCT MKT, PROD, ProductName
	FROM tblMktDefHospital) c ON c.mkt = a.mkt AND c.prod= a.prod JOIN
	(
	SELECT DISTINCT [cpa name] , [CPA Code]
	FROM BMS_CPA_Hosp_Category
	WHERE [cpa name]<> '#N/A' AND [cpa name] IS NOT NULL AND [cpa code] IS NOT NULL AND [Coniel Hospital Category] <> '#N/A' 	
) d ON d.[cpa code]=b.cpa_code
WHERE a.mkt = 'CCB'
GROUP BY a.DataSource,a.Mkt, a.Prod,c.ProductName

SELECT *
FROM OutputPerformanceByHosp_CV_Modi_Slide8_Coniel
WHERE TYPE = 'Total' AND Prod='000'

SELECT Type, DataSource, Mkt, Prod, Productname,
	cast(hosp_Count AS FLOAT) AS hosp_Count, cast(MarketContr AS FLOAT) AS MarketContr,
	cast(ProductMarketShare AS FLOAT) ProductMarketShare , cast(ProductMarketGrowth AS FLOAT) AS ProductMarketGrowth
FROM OutputPerformanceByHosp_CV_Modi_Slide8_Output_Coniel
WHERE prod=100
