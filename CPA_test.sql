

-------------------------------


SELECT * FROM dbo.OutputHospital_All where LinkChartCode = 'd050'
SELECT DISTINCT LinkChartCode, TimeFrame FROM dbo.OutputHospital_All where LinkChartCode = 'd050'

SELECT * FROM OutputTopCPA 
SELECT * FROM tempHospitalDataByGeo 
SELECT distinct Product FROM tblMktDefHospital 
SELECT distinct cpa_id FROM tempHospitalDataByMth 

select * from tblSalesRegion order by id
select * FROM BMSChinaCIA_IMS.dbo.maxcity

SELECT * FROM tempHospitalDataByGeo 

SELECT distinct Mkt, MktName, ProductName FROM tblMktDefHospital 
SELECT * FROM tblMktDefHospital where ProductName like '%sprycel%'

SELECT * FROM tblSalesRegion 

SELECT * FROM BMSChinaCIA_IMS.dbo.tblcitymax 

SELECT * FROM OutputTopCPA 

SELECT * FROM dbo.OutputHospital_All 

SELECT * FROM tempHospitalDataByGeo 
SELECT * FROM tempHospitalData 

SELECT c.* 
into tempBALHospitalDataByGeo
FROM tblHospitalMaster AS a
RIGHT JOIN tblBALHospital AS b ON a.BMS_Code = b.HospitalCode
INNER JOIN tempHospitalDataByGeo AS c ON a.id = c.Cpa_id

SELECT * FROM tempBALHospitalDataByGeo 

SELECT * FROM tblMktDef_MRBIChina 
SELECT * FROM tblBALHospital 

SELECT * INTO tblHospitalMaster FROM BMSChinaMRBI.dbo.tblHospitalMaster 

SELECT * FROM tblHospitalMaster 
SELECT * FROM dbo.tblBALHospital



SELECT * FROM dbo.tblMktDefHospital
SELECT * FROM tempBALHospitalDataByGeo 



SELECT * FROM OutputBALHospitalDataByGeo 



SELECT * FROM tblSalesRegion 

SELECT region AS x, RANK() OVER( ORDER BY  region) as XIdx 
FROM (
	SELECT DISTINCT region  from tblSalesRegion 
) AS a 


SELECT * FROM dbo.OutputHospital_All

SELECT * FROM OutputHospital_All WHERE LinkChartCode = 'c150'

SELECT * FROM OutputBALHospitalDataByGeo 
SELECT * FROM OutputBALHospitalDataRullupByProd 

SELECT * FROM dbo.OutputHospital WHERE LinkChartCode = 'c170'

UPDATE dbo.OutputHospital_All SET LinkChartCode = 'c170' WHERE LinkChartCode = 'c150'

SELECT * FROM OutputHospital_All WHERE LinkChartCode = 'c170'

SELECT DISTINCT Prod FROM tempHospitalDataByGeo WHERE mkt = 'arv'

	SELECT distinct Prod as SeriesIdx,ProductName as Series
    from tblMktDefHospital
    where Mkt = 'ARV' and Molecule = 'N'

	SELECT DISTINCT Prod, Productname FROM tblMktDef_MRBIChina WHERE mkt = 'arv' AND Molecule = 'N'

	SELECT distinct Prod as SeriesIdx,ProductName as Series
    from tblMktDef_MRBIChina
    where Mkt = 'ARV' and Molecule = 'N' AND prod NOT IN ('700', '800')
    UNION all
    SELECT DISTINCT prod, Productname 
    FROM BMSChinaCIA_IMS.dbo.tblMktDef_MRBIChina_For_OtherETV 

	SELECT * FROM tempBALHospitalDataByGeo WHERE mkt = 'arv'

	SELECT * FROM dbo.tblMktDefHospital WHERE mkt = 'arv' AND Molecule = 'N'
	
	
 update OutputHospital_All
 set geo = case geo when 'EastI' then 'East I' when 'EastII' then 'East II' else geo end ,
     ParentGeo = case ParentGeo when 'EastI' then 'East I' when 'EastII' then 'East II' else ParentGeo end  
 where LinkChartCode = 'D050'

 SELECT * FROM tempHospitalData_All 

 SELECT * FROM tempHospitalData_All_For_KPI_Frame 
 SELECT * FROM TempKPIFrame_CPAPart WHERE mkt LIKE '%NIAD%'
 SELECT * FROM Output_KPI_Frame_CPAPart WHERE mkt LIKE '%NIAD%'
 SELECT * FROM Mid_KPIFrame_CPAPart_NIAD 
 SELECT * FROM tblHospitalMaster 
 SELECT * FROM BMS_CPA_Hosp_Category 
 
 SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA' 

 SELECT * FROM KPI_Frame_CPA_Part_Market_Product_Mapping 
 SELECT Mkt, MktName, Prod, ProductName, Molecule, Class, ATC3_Cod, ATC_CPA, Mole_Des_CN, Mole_Des_EN, Prod_Des_CN,
		Prod_Des_EN, FocusedBrand, IMSMoleCode, IMSProdCode, Product, rat FROM tblMktDefHospital WHERE mkt LIKE '%NIAD%' 
 

 select Series,X,Series_Idx,X_Idx,Y from KPI_Frame_AnalyzerMarket_HospitalPerformance where market='Glucophage' and x not like 'oncology%' order by Series_Idx,X_Idx

 SELECT * FROM tblPackageXRefHosp WHERE Molecule_EN LIKE '%Glucophage%'
 SELECT * FROM tblMktDefHospital WHERE ProductName LIKE '%Glucophage%'
 SELECT * FROM tblMktDefHospital WHERE Mkt LIKE '%NIAD%'

 SELECT * FROM tblHospitalMaster 
 SELECT * FROM tblMktDefHospital 

 SELECT * FROM BMSChinaMRBI_Repository.dbo.tblMktDefHospital_201611 WHERE mkt LIKE '%NIAD%' 
 SELECT * INTO tblMktDefHospital_20170330 FROM tblMktDefHospital
 TRUNCATE TABLE tblMktDefHospital 
 INSERT INTO tblMktDefHospital SELECT Mkt, MktName, Prod, ProductName, Molecule, Class, ATC3_Cod, ATC_CPA, Mole_Des_CN, Mole_Des_EN, Prod_Des_CN,
									  Prod_Des_EN, FocusedBrand, IMSMoleCode, IMSProdCode, Product, 1 AS rat  FROM BMSChinaMRBI_Repository.dbo.tblMktDefHospital_201611

TRUNCATE TABLE tblHospitalMaster 
INSERT INTO dbo.tblHospitalMaster ( id, DataSource, CPA_Code, CPA_Code_Old, CPA_Name, CPA_Name_English, Tier,
									 Province, City, city_en, BMS_Code, BMS_Hosp_Name )
SELECT id, DataSource, CPA_Code_Old, CPA_Code, Hos_Name, Hos_Name_English, Tier, Province, City, city_en, BMS_Code,
									 BMS_Hosp_Name 
FROM  [tblHospitalMaster_2016] 

SELECT * FROM dbo.OutputHospital_All WHERE LinkChartCode = 'd090'

SELECT * FROM tempHospitalDataByGeo 
SELECT * FROM tempHospitalData 
SELECT * FROM tempHospitalDataByMth 
SELECT * FROM inCPAData 

SELECT * FROM BMSChinaOtherDB.dbo.inCPAData_201701_all
SELECT  Value1 from tblDSDates where Item = 'CPA' 

SELECT * INTO tblHospitalMaster_201612_1  FROM tblHospitalMaster 

SELECT * FROM temptblHospitalMaster 

SELECT * FROM dbo.tblMktDefHospital

SELECT * FROM db81.[QABMSChina].[dbo].[tblHospitalMaster]  

DROP TABLE tblHospitalMaster 


SELECT * INTO tblHospitalMaster  FROM db81.[QABMSChina].[dbo].[tblHospitalMaster] 
				 

SELECT * INTO temptblHospitalMaster FROM tblHospitalMaster_2016 

SELECT * FROM tblHospitalMaster_bk20160319 
SELECT * FROM tblHospitalMaster_201503 

SELECT * FROM BMSCNProc_bak.dbo.tblHospitalMaster_201501 

SELECT * FROM BMSCNProc_bak.dbo.tblHospitalMaster


SELECT * FROM BMSChinaOtherDB.dbo.tblAllHospital_2014

SELECT * FROM dbo.tblHospitalMaster






SELECT * FROM dbo.OutputHospital_All
WHERE LinkChartCode = 'c170' AND TimeFrame = 'mth' AND Category = 'Volume' AND x LIKE 'VIR BAM II%'

SELECT * FROM OutputBALHospitalDataByGeo 

SELECT * FROM dbo.OutputHospital
WHERE LinkChartCode = 'c170' AND TimeFrame = 'mth' AND Category = 'Volume' AND x LIKE 'VIR BAM II%'

SELECT SUM(um1) FROM OutputBALHospitalDataByGeo WHERE RMNAme = 'VIR BAM II' AND prod <> '000' 
SELECT * FROM OutputBALHospitalDataByGeo WHERE RMNAme = 'VIR BAM II' AND prod <> '000' 

-- SELECT distinct prod FROM tempBALHospitalDataByGeo where mkt = 'arv'
-- SELECT * FROM tempBALHospitalDataByGeo  where mkt = 'arv'
-- SELECT distinct product FROM tempHospitalDataByGeo  where mkt = 'arv'

SELECT product, RMName,  datasource, a.mkt, 
  sum(Vm1) as [VM1]
FROM tempBALHospitalDataByGeo AS a 
INNER JOIN ( SELECT distinct  Prod  from BMSChinaMRBI.dbo.tblMktDefHospital  where Mkt = 'Arv' AND Molecule = 'N' AND prod <> '000' ) AS b 
ON a.prod = b.prod
WHERE a.mkt = 'arv' and a.lev = 'nat' and product = 'Baraclude'
GROUP BY Product, RMName, datasource, a.mkt


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'temp_BAL_CPAData') and type='U')
BEGIN
	DROP TABLE temp_BAL_CPAData
END
go

select a.HospCode, a.HospName, a.RMName, b.*
into temp_BAL_CPAData
from ( 
	SELECT b.HospCode, b.HospName, b.RMName, a.[CPA Code] as CPA_Code, a.[City(Chinese)] as City, a.Povince
	from BMSChinaMRBI.dbo.BMS_CPA_Hosp_Category as a
	inner join tblBALHospital as b on a.[BMS Code] = b.HospCode
) as a 
inner join BMSChinaMRBI.dbo.inCPAData as b on a.CPA_Code = b.CPA_Code
where a.CPA_Code <>'#N/A'

SELECT * FROM temp_bal_cpaData

SELECT SUM(vm1) FROM tempHospitalDataByGeo WHERE Cpa_id IN (119, 152) AND mkt = 'arv' AND prod IN (100, 200, 300, 400, 500, 600, 700) AND Product = 'baraclude' AND lev = 'nat'
SELECT * FROM tempHospitalDataByGeo WHERE Cpa_id IN (119, 152) and mkt = 'arv' AND prod IN (100, 200, 300, 400, 500, 600, 700) AND Product = 'baraclude' AND lev = 'nat'
SELECT SUM(sales) FROM tempHospitalDataByMth WHERE Cpa_id IN (119, 152) and mkt = 'arv' AND prod IN (100, 200, 300, 400, 500, 600, 700) AND mth = '201701'


select 
   	DISTINCT a.Product, a.Molecule
		, c.Prod, c.rat
from inCPAData a
inner join tblMktDefHospital c  on a.Molecule = c.Mole_Des_CN and a.Product = c.Prod_Des_CN
where  a.cpa_id IN (119, 152) AND c.Mkt = 'arv' AND a.M = '1' AND a.Y = '2017' AND c.Molecule = 'N' AND c.Prod = '000'

SELECT * FROM tblMktDefHospital WHERE mkt = 'arv' AND Prod_Des_CN =	N'Î¤ÈðµÂ'
INSERT INTO dbo.tblMktDefHospital ( Mkt, MktName, Prod, ProductName, Molecule, Class, ATC3_Cod, ATC_CPA, Mole_Des_CN,
									 Mole_Des_EN, Prod_Des_CN, Prod_Des_EN, FocusedBrand, IMSMoleCode, IMSProdCode,
									 Product, rat )
SELECT Mkt, MktName, '700', 'ARV Others', Molecule, Class, ATC3_Cod, ATC_CPA, Mole_Des_CN, Mole_Des_EN, Prod_Des_CN,
	   Prod_Des_EN, FocusedBrand, IMSMoleCode, IMSProdCode, Product, rat 
FROM tblMktDefHospital WHERE mkt = 'arv' AND Prod_Des_CN =	N'Î¤ÈðµÂ' AND Molecule = 'N'
SELECT * FROM tblMktDefHospital WHERE mkt = 'arv' AND prod = '700'


select 
   	'CPA' as DataSource
	, c.Mkt
	, c.Prod
	, a.cpa_id
	, a.Tier
	, convert(varchar(6),convert(Datetime,a.M+'/1/'+Y,101),112) as Mth
	, sum(Value*c.rat)  as Sales
	, sum(Volume*c.rat) as Units
	, sum(Volume*cast(subString(Specification,1,charindex(' ',Specification)) as float)/AvgPatientMG) as Adjusted_PatientNumber
from inCPAData a
left join tblMktDefHospital c  on a.Molecule = c.Mole_Des_CN and a.Product = c.Prod_Des_CN
where  a.cpa_id IN (119, 152) AND c.Mkt = 'arv'  AND a.M = '1' AND a.Y = '2017' AND c.Molecule = 'N'
group by c.Mkt,c.Prod,a.cpa_id, a.Tier,a.M+'/1/'+Y

SELECT DISTINCT a.Molecule , a.Product FROM inCPAData AS a
WHERE cpa_id IN (119, 152) AND a.M = '1' AND a.Y = '2017' AND a.ATC_Code LIKE '%J05AF%'


SELECT * FROM tblBALHospital 
--119 152

SELECT b.RMName, c.* 
FROM tblHospitalMaster AS a
RIGHT JOIN tblBALHospital AS b ON a.BMS_Code = b.HospCode
INNER JOIN tempHospitalDataByGeo AS c ON a.id = c.Cpa_id


SELECT product, RMName,  datasource, a.mkt , 
  sum([UM1]) as [UM1], sum(VM1) as [VM1], 
  sum([UR3M1]) as [UR3M1], sum([VR3M1]) as [VR3M1],
  sum([UYTD]) as [UYTD], sum([VYTD]) as [VYTD],
  sum([UMAT1]) as [UMAT1], sum([VMAT1]) as [VMAT1]
  
--into OutputBALHospitalDataRullupByProd
FROM OutputBALHospitalDataByGeo AS a 
WHERE  prod <> '000'
GROUP BY product, RMName,  datasource, a.mkt 

SELECT * FROM OutputBALHospitalDataByGeo WHERE RMName = 'VIR BAM II'

---------------------------------------------------------------------
SELECT Rate FROM BMSChinaCIA_IMS.dbo.tblRate
SELECT * FROM dbo.OutputHospital_All WHERE LinkChartCode = 'c170' AND Currency = 'Usd' AND TimeFrame = 'MTH'
SELECT * FROM dbo.OutputHospital WHERE LinkChartCode = 'd050'
SELECT * FROM tempHospitalDataByGeo WHERE lev = 'region'

select distinct mkt, product  from tblMktDefHospital WHERE mkt = 'arv'

UPDATE dbo.tblMktDefHospital
SET product = 'Baraclude'
WHERE mkt = 'arv'

select 
case a.category 
  when 'UC3M' then UR3M1 
  when 'VC3M' then VR3M1 
  when 'PC3M' then PR3M1
  when 'UYTD' then UYTD 
  when 'VYTD' then VYTD
  when 'PYTD' then PYTD END, *
from OutputHospital_All a
inner join tempHospitalDataByGeo b on b.Mkt = a.Product 
	and b.lev = a.lev and b.geo = a.geo and b.CPA_id = cast(a.x as int)
where a.LinkChartCode = 'D050' and a.SeriesIdx = 2 and b.Prod = '100'

SELECT DISTINCT x FROM OutputHospital_All WHERE LinkChartCode = 'D050'

SELECT DISTINCT ParentGeo, geo FROM tempHospitalDataByGeo 

----------

SELECT product, RMName,  datasource, a.mkt, a.Prod , *
FROM tempBALHospitalDataByGeo AS a 
INNER JOIN (select distinct prod_Des_EN,Prod_Des_CN, Prod  from BMSChinaMRBI.dbo.tblMktDefHospital  where Mkt = 'Arv' AND Molecule = 'N' ) AS b 
ON a.Product = b.Prod_Des_EN AND a.prod = b.prod
WHERE a.mkt = 'arv' and a.lev = 'nat' 

select distinct prod_Des_EN,Prod_Des_CN , Prod  from BMSChinaMRBI.dbo.tblMktDefHospital  where Mkt = 'Arv' AND Molecule = 'N' 

SELECT DISTINCT mkt, prod, ProductName, Prod_Des_CN FROM db4.BMSChinaMRBI.dbo.tblMktDefHospital WHERE mkt = 'arv' 

SELECT * FROM dbo.OutputHospital_All 
WHERE LinkChartCode = 'c170' AND TimeFrame = 'ytd' AND currency in ('RMB', 'USD') AND SeriesIdx = '100'
	AND x LIKE '%VIR BAM II%'

SELECT DISTINCT TimeFrame FROM dbo.OutputHospital_All WHERE LinkChartCode = 'd110'
SELECT DISTINCT RankSource FROM dbo.OutputTopCPA
SELECT * FROM tempHospitalDataByGeo


SELECT * FROM OutputBALHospitalDataByGeo
SELECT * FROM tempBALHospitalDataByGeo
SELECT * FROM OutputBALHospitalDataGrowth 

SELECT * FROM OutputHospital_All WHERE LinkChartCode = 'c170'

SELECT	LinkChartCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, 'L'
FROM	OutputHospital_All
WHERE	LinkChartCode IN ( 'C170' ) 

SELECT 
CASE  
		WHEN a.category = 'Value' 	AND a.TimeFrame = 'MAT' AND a.Currency = 'RMB'  THEN b.vmat1 
		WHEN a.category = 'Value' 	AND a.TimeFrame = 'MAT' AND a.Currency = 'USD'  THEN b.vmat1 
		WHEN a.category = 'Volume' 	AND a.TimeFrame = 'MAT' AND a.Currency = 'UNIT'  THEN b.UMat1  
		WHEN a.category = 'Value' 	AND a.TimeFrame = 'YTD' AND a.Currency = 'RMB'  THEN b.VYTD 
		WHEN a.category = 'Value' 	AND a.TimeFrame = 'YTD' AND a.Currency = 'USD'  THEN b.VYTD 
		WHEN a.category = 'Volume' 	AND a.TimeFrame = 'YTD' AND a.Currency = 'UNIT'  THEN b.UYTD 
		WHEN a.category = 'Value' 	AND a.TimeFrame = 'MQT' AND a.Currency = 'RMB'  THEN b.VR3M1  
		WHEN a.category = 'Value' 	AND a.TimeFrame = 'MQT' AND a.Currency = 'USD'  THEN b.VR3M1  
		WHEN a.category = 'Volume' 	AND a.TimeFrame = 'MQT' AND a.Currency = 'UNIT'  THEN b.UR3M1  
		WHEN a.category = 'Value' 	AND a.TimeFrame = 'MTH' AND a.Currency = 'RMB'  THEN b.VM1
		WHEN a.category = 'Value' 	AND a.TimeFrame = 'MTH' AND a.Currency = 'USD'  THEN b.VM1
		WHEN a.category = 'Volume' 	AND a.TimeFrame = 'MTH' AND a.Currency = 'UNIT'  THEN b.UM1 
	END, * 		
from OutputHospital_All as a
inner join OutputBALHospitalDataGrowth b on  a.Product = b.Mkt  and a.X = b.RMName AND a.SeriesIdx = b.Prod
where a.IsShow = 'L' and a.LinkChartCode = 'C170' AND a.Currency = 'UNIT'

SELECT * FROM OutputHospital_All WHERE LinkChartCode = 'c170' AND IsShow = 'L'

SELECT * FROM OutputHospital_All WHERE LinkChartCode = 'c202'

SELECT * FROM dbo.tblMktDefHospital

