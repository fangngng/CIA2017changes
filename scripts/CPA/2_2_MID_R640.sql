
-----------------------------------
--	CIA-CV Modification: Slide 8
-----------------------------------

use BMSChinaMRBI
go
	
exec dbo.sp_Log_Event 'Mid R640','CIA_CPA','2_2_MID_R640.sql','Start',null,null

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'tempHospitalData_CIA_CV_Modification_Slide8') AND TYPE = 'U')
BEGIN
	DROP TABLE tempHospitalData_CIA_CV_Modification_Slide8
END

SELECT Datasource,Mkt,Prod,cpa_id,UYTD,UYTDStly,VYTD,VYTDStly
INTO tempHospitalData_CIA_CV_Modification_Slide8 
FROM tempHospitalData WHERE MKT= 'HYPFCS' AND Prod in ('100','200','700','800','000')

--INSERT INTO tempHospitalData_CIA_CV_Modification_Slide8(Datasource,Mkt,Prod,Cpa_id, UYTD,UYTDStly,VYTD,VYTDStly)
--SELECT DataSource,Mkt,'000',Cpa_id, SUM(UYTD),SUM(UYTDStly),SUM(VYTD),SUM(VYTDStly)
--FROM tempHospitalData WHERE MKT= 'HYPFCS' AND Prod in ('100','200','700','800')
--GROUP BY DataSource,Mkt,Cpa_id


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'dbo.OutputPerformanceByHosp_CV_Modi_Slide8') AND TYPE= 'U')
BEGIN
	DROP TABLE OutputPerformanceByHosp_CV_Modi_Slide8
END
--Total
SELECT CAST('Total' AS NVARCHAR(100)) AS Type,a.DataSource, a.Mkt, a.Prod,c.ProductName,
	   SUM(a.UYTD) AS UYTD,SUM(a.UYTDStly) AS UYTDStly,SUM(a.VYTD) AS VYTD,SUM(a.VYTDStly) AS VYTDStly,COUNT(DISTINCT a.Cpa_id) AS Hosp_Count
INTO OutputPerformanceByHosp_CV_Modi_Slide8
from dbo.tempHospitalData_CIA_CV_Modification_Slide8 a 
join
	(SELECT DISTINCT id,cpa_name,cpa_code FROM tblHospitalMaster) b on a.cpa_id = b.id 
join
	(SELECT DISTINCT MKT,PROD,ProductName FROM tblMktDefHospital) c on c.mkt = a.mkt and c.prod= a.prod 
join
(
	select distinct [cpa name] ,[CPA Code]
	from BMS_CPA_Hosp_Category 
	where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Monopril Hospital Category] <> '#N/A' 	
) d ON d.[cpa code]=b.cpa_code
where a.mkt = 'HYPFCS'
GROUP BY a.DataSource,a.Mkt, a.Prod,c.ProductName

--Monopril Hospital Category
INSERT INTO OutputPerformanceByHosp_CV_Modi_Slide8 (Type,DataSource, Mkt, Prod,ProductName,UYTD,UYTDStly,VYTD,VYTDStly,Hosp_Count)
select t1.Type,t1.DataSource,t1.Mkt,t1.prod,t1.ProductName,isnull(t2.UYTD,0) as UYTD,isnull(t2.UYTDStly,0) as UYTDStly,
	isnull(t2.VYTD,0) as VYTD,isnull(t2.VYTDStly,0) as VYTDStly,isnull(t2.Hosp_Count,0) as Hosp_Count
from (
	select distinct d.[Monopril Hospital Category] AS Type, a.DataSource,a.Mkt,a.Prod,c.productName
	FROM dbo.tempHospitalData_CIA_CV_Modification_Slide8 a join
	--(SELECT DISTINCT id,cpa_name,cpa_code FROM tblHospitalMaster) b on a.cpa_id = b.id  join
	(SELECT DISTINCT MKT,PROD,ProductName FROM tblMktDefHospital) c on c.mkt = a.mkt and c.prod= a.prod 
	cross join (
		select distinct [Monopril Hospital Category] 
		from BMS_CPA_Hosp_Category 
		where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Monopril Hospital Category] <> '#N/A' 
		--and [Monopril Hospital Category]='High productivity'
	) d
	where a.mkt='HYPFCS'
) t1 left join (
	SELECT d.[Monopril Hospital Category] AS Type,a.DataSource, a.Mkt, a.Prod,c.ProductName,
		   SUM(a.UYTD) AS UYTD,SUM(a.UYTDStly) AS UYTDStly,SUM(a.VYTD) AS VYTD,SUM(a.VYTDStly) AS VYTDStly,COUNT(DISTINCT a.Cpa_id) AS Hosp_Count
		   --select *
	FROM dbo.tempHospitalData_CIA_CV_Modification_Slide8 a join
	(SELECT DISTINCT id,cpa_name,cpa_code FROM tblHospitalMaster) b on a.cpa_id = b.id  join
	(SELECT DISTINCT MKT,PROD,ProductName FROM tblMktDefHospital) c on c.mkt = a.mkt and c.prod= a.prod  join
	(
		select distinct [cpa name] ,[Monopril Hospital Category] ,[CPA Code]
	from BMS_CPA_Hosp_Category 
	where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Monopril Hospital Category] <> '#N/A' 
		--and [Monopril Hospital Category]='High productivity'
	) d ON d.[cpa code]=b.cpa_code
	WHERE a.mkt = 'HYPFCS' 
	GROUP BY a.DataSource,a.Mkt, a.Prod,c.ProductName,d.[Monopril Hospital Category]
) t2 on t1.Type=t2.type and t1.datasource=t2.datasource and t1.mkt=t2.mkt and t1.prod=t2.prod and t1.productname=t2.productname

Go

/*
Prod	ProductName
100	Monopril
200	Acertil
700	Lotensin
800	Tritace
*/
IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'OutputPerformanceByHosp_CV_Modi_Slide8_Output') AND TYPE = 'U')
BEGIN
	DROP TABLE OutputPerformanceByHosp_CV_Modi_Slide8_Output
END

--Total
SELECT a.Type,a.DataSource,a.Mkt,a.Prod,a.Productname,c.Hosp_Count AS Hosp_Count,
	CASE WHEN b.VYTD= 0 OR b.VYTD IS NULL THEN 0 ELSE  1.0*a.VYTD/b.VYTD END AS MarketContr,
	CASE WHEN c.VYTD= 0 OR c.VYTD IS NULL THEN 0 ELSE  1.0*a.VYTD/c.VYTD END AS ProductMarketShare,
	CASE WHEN a.VYTDStly= 0 OR a.VYTDStly IS NULL THEN 0 ELSE 1.0*(a.VYTD-a.VYTDStly)/a.VYTDStly END AS ProductMarketGrowth
INTO OutputPerformanceByHosp_CV_Modi_Slide8_Output
FROM 
(
	SELECT * 
	FROM OutputPerformanceByHosp_CV_Modi_Slide8 WHERE Type = 'Total' and Prod in( '100','200','700','800')
) a join
(
	SELECT *
	FROM OutputPerformanceByHosp_CV_Modi_Slide8 WHERE Type = 'Total' and Prod in( '100','200','700','800')
) b on a.DataSource=b.DataSource and a.Mkt=b.Mkt and a.Prod=b.Prod join 
(
	SELECT *
	FROM OutputPerformanceByHosp_CV_Modi_Slide8 WHERE TYPE = 'Total' AND Prod='000'
) c on a.Type=c.Type and a.DataSource=c.DataSource and a.Mkt=c.Mkt


INSERT INTO OutputPerformanceByHosp_CV_Modi_Slide8_Output(Type,DataSource,Mkt,Prod,Productname,Hosp_Count,MarketContr,ProductMarketShare,ProductMarketGrowth)
SELECT a.Type,a.DataSource,a.Mkt,a.Prod,a.Productname,c.Hosp_Count AS Hosp_Count,
	CASE WHEN b.VYTD= 0 OR b.VYTD IS NULL THEN 0 ELSE  1.0*c.VYTD/b.VYTD END AS MarketContr,
	CASE WHEN c.VYTD= 0 OR c.VYTD IS NULL THEN 0 ELSE  1.0*a.VYTD/c.VYTD END AS ProductMarketShare,
	CASE WHEN a.VYTDStly= 0 OR a.VYTDStly IS NULL THEN 0 ELSE 1.0*(a.VYTD-a.VYTDStly)/a.VYTDStly END AS ProductMarketGrowth
FROM 
(
	SELECT * 
	FROM OutputPerformanceByHosp_CV_Modi_Slide8 WHERE Type <> 'Total' and Prod in( '100','200','700','800')
) a join
(
	SELECT *
	FROM OutputPerformanceByHosp_CV_Modi_Slide8 WHERE TYPE <> 'Total' AND Prod='000'
) c on a.Type=c.Type and a.DataSource=c.DataSource and a.Mkt=c.Mkt  join
(
	SELECT *
	FROM OutputPerformanceByHosp_CV_Modi_Slide8 WHERE Type = 'Total' and Prod ='000'
) b on c.DataSource=b.DataSource and c.Mkt=b.Mkt and c.Prod=b.Prod


GO
IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'OutputPerformanceByHosp_CV_Modi_Slide8_Mid') AND TYPE = 'U')
BEGIN
	DROP TABLE OutputPerformanceByHosp_CV_Modi_Slide8_Mid
END

select  Type,DataSource,Mkt,Prod,Productname,X,Y
into OutputPerformanceByHosp_CV_Modi_Slide8_Mid
	from
	 (
		select Type,DataSource,Mkt,Prod,Productname,
		cast(hosp_Count as float) as hosp_Count,cast(MarketContr as float) as MarketContr,
		cast(ProductMarketShare as float) ProductMarketShare ,cast(ProductMarketGrowth as float) as ProductMarketGrowth
		from OutputPerformanceByHosp_CV_Modi_Slide8_Output
	) t1 unpivot(
		Y for X in (hosp_Count,MarketContr, ProductMarketShare,ProductMarketGrowth )
	) t2

delete from OutputPerformanceByHosp_CV_Modi_Slide8_Mid
where Productname <> 'Monopril' and X in ('hosp_Count','MarketContr')







-----------------------------------
--	R640 Coniel
-----------------------------------

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'tempHospitalData_CIA_CV_Modification_Slide8_Coniel') AND TYPE = 'U')
BEGIN
	DROP TABLE tempHospitalData_CIA_CV_Modification_Slide8_Coniel
END

SELECT Datasource,Mkt,Prod,cpa_id,UYTD,UYTDStly,VYTD,VYTDStly
INTO tempHospitalData_CIA_CV_Modification_Slide8_Coniel
FROM tempHospitalData WHERE MKT= 'CCB' AND Prod in ('000','100','200','300','400','500','600','700')

--INSERT INTO tempHospitalData_CIA_CV_Modification_Slide8(Datasource,Mkt,Prod,Cpa_id, UYTD,UYTDStly,VYTD,VYTDStly)
--SELECT DataSource,Mkt,'000',Cpa_id, SUM(UYTD),SUM(UYTDStly),SUM(VYTD),SUM(VYTDStly)
--FROM tempHospitalData WHERE MKT= 'HYPFCS' AND Prod in ('100','200','700','800')
--GROUP BY DataSource,Mkt,Cpa_id


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'dbo.OutputPerformanceByHosp_CV_Modi_Slide8_Coniel') AND TYPE= 'U')
BEGIN
	DROP TABLE OutputPerformanceByHosp_CV_Modi_Slide8_Coniel
END
--Total
SELECT CAST('Total' AS NVARCHAR(100)) AS Type,a.DataSource, a.Mkt, a.Prod,c.ProductName,
	   SUM(a.UYTD) AS UYTD,SUM(a.UYTDStly) AS UYTDStly,SUM(a.VYTD) AS VYTD,SUM(a.VYTDStly) AS VYTDStly,COUNT(DISTINCT a.Cpa_id) AS Hosp_Count
INTO OutputPerformanceByHosp_CV_Modi_Slide8_Coniel
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

--Coniel Hospital Category
INSERT INTO OutputPerformanceByHosp_CV_Modi_Slide8_Coniel (Type,DataSource, Mkt, Prod,ProductName,UYTD,UYTDStly,VYTD,VYTDStly,Hosp_Count)
select t1.Type,t1.DataSource,t1.Mkt,t1.prod,t1.ProductName,isnull(t2.UYTD,0) as UYTD,isnull(t2.UYTDStly,0) as UYTDStly,
	isnull(t2.VYTD,0) as VYTD,isnull(t2.VYTDStly,0) as VYTDStly,isnull(t2.Hosp_Count,0) as Hosp_Count
from (
	select distinct d.[Coniel Hospital Category] AS Type, a.DataSource,a.Mkt,a.Prod,c.productName
	FROM dbo.tempHospitalData_CIA_CV_Modification_Slide8_Coniel a join
	--(SELECT DISTINCT id,cpa_name,cpa_code FROM tblHospitalMaster) b on a.cpa_id = b.id  join
	(SELECT DISTINCT MKT,PROD,ProductName FROM tblMktDefHospital) c on c.mkt = a.mkt and c.prod= a.prod 
	cross join (
		select distinct [Coniel Hospital Category] 
		from BMS_CPA_Hosp_Category 
		where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Coniel Hospital Category] <> '#N/A' 
		--and [Coniel Hospital Category]='High productivity'
	) d
	where a.mkt='CCB'
) t1 left join (
	SELECT d.[Coniel Hospital Category] AS Type,a.DataSource, a.Mkt, a.Prod,c.ProductName,
		   SUM(a.UYTD) AS UYTD,SUM(a.UYTDStly) AS UYTDStly,SUM(a.VYTD) AS VYTD,SUM(a.VYTDStly) AS VYTDStly,COUNT(DISTINCT a.Cpa_id) AS Hosp_Count
		   --select *
	FROM dbo.tempHospitalData_CIA_CV_Modification_Slide8_Coniel a join
	(SELECT DISTINCT id,cpa_name,cpa_code FROM tblHospitalMaster) b on a.cpa_id = b.id  join
	(SELECT DISTINCT MKT,PROD,ProductName FROM tblMktDefHospital) c on c.mkt = a.mkt and c.prod= a.prod  join
	(
		select distinct [cpa name],[cpa code],[Coniel Hospital Category] 
		from BMS_CPA_Hosp_Category 
		where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Coniel Hospital Category] <> '#N/A' 
		--and [Coniel Hospital Category]='High productivity'
	) d ON d.[cpa code]=b.cpa_code
	WHERE a.mkt = 'CCB' 
	GROUP BY a.DataSource,a.Mkt, a.Prod,c.ProductName,d.[Coniel Hospital Category]
) t2 on t1.Type=t2.type and t1.datasource=t2.datasource and t1.mkt=t2.mkt and t1.prod=t2.prod and t1.productname=t2.productname

Go

/*
Prod	ProductName
100	Monopril
200	Acertil
700	Lotensin
800	Tritace
*/
IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'OutputPerformanceByHosp_CV_Modi_Slide8_Output_Coniel') AND TYPE = 'U')
BEGIN
	DROP TABLE OutputPerformanceByHosp_CV_Modi_Slide8_Output_Coniel
END

--Total
SELECT a.Type,a.DataSource,a.Mkt,a.Prod,a.Productname,c.Hosp_Count AS Hosp_Count,
CASE WHEN b.VYTD= 0 OR b.VYTD IS NULL THEN 0 ELSE  1.0*a.VYTD/b.VYTD END AS MarketContr,
CASE WHEN c.VYTD= 0 OR c.VYTD IS NULL THEN 0 ELSE  1.0*a.VYTD/c.VYTD END AS ProductMarketShare,
CASE WHEN a.VYTDStly= 0 OR a.VYTDStly IS NULL THEN 0 ELSE 1.0*(a.VYTD-a.VYTDStly)/a.VYTDStly END AS ProductMarketGrowth
INTO OutputPerformanceByHosp_CV_Modi_Slide8_Output_Coniel
FROM 
(
	SELECT * 
	FROM OutputPerformanceByHosp_CV_Modi_Slide8_Coniel WHERE Type = 'Total' and Prod in('100','200','300','400','500','600','700')
) a join
(
	SELECT *
	FROM OutputPerformanceByHosp_CV_Modi_Slide8_Coniel WHERE Type = 'Total' and Prod in( '100','200','300','400','500','600','700')
) b on a.DataSource=b.DataSource and a.Mkt=b.Mkt and a.Prod=b.Prod join 
(
	SELECT *
	FROM OutputPerformanceByHosp_CV_Modi_Slide8_Coniel WHERE TYPE = 'Total' AND Prod='000'
) c on a.Type=c.Type and a.DataSource=c.DataSource and a.Mkt=c.Mkt



--TOP110
INSERT INTO OutputPerformanceByHosp_CV_Modi_Slide8_Output_Coniel(Type,DataSource,Mkt,Prod,Productname,Hosp_Count,MarketContr,ProductMarketShare,ProductMarketGrowth)
SELECT a.Type,a.DataSource,a.Mkt,a.Prod,a.Productname,c.Hosp_Count AS Hosp_Count,
CASE WHEN b.VYTD= 0 OR b.VYTD IS NULL THEN 0 ELSE  1.0*c.VYTD/b.VYTD END AS MarketContr,
CASE WHEN c.VYTD= 0 OR c.VYTD IS NULL THEN 0 ELSE  1.0*a.VYTD/c.VYTD END AS ProductMarketShare,
CASE WHEN a.VYTDStly= 0 OR a.VYTDStly IS NULL THEN 0 ELSE 1.0*(a.VYTD-a.VYTDStly)/a.VYTDStly END AS ProductMarketGrowth
FROM 
(
	SELECT * 
	FROM OutputPerformanceByHosp_CV_Modi_Slide8_Coniel WHERE Type <> 'Total' and Prod in( '100','200','300','400','500','600','700')
) a join
(
	SELECT *
	FROM OutputPerformanceByHosp_CV_Modi_Slide8_Coniel WHERE TYPE <> 'Total' AND Prod='000'
) c on a.Type=c.Type and a.DataSource=c.DataSource and a.Mkt=c.Mkt join
(
	SELECT *
	FROM OutputPerformanceByHosp_CV_Modi_Slide8_Coniel WHERE Type = 'Total' and Prod ='000'
) b on c.DataSource=b.DataSource and c.Mkt=b.Mkt and c.Prod=b.Prod

GO
IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'OutputPerformanceByHosp_CV_Modi_Slide8_Mid_Coniel') AND TYPE = 'U')
BEGIN
	DROP TABLE OutputPerformanceByHosp_CV_Modi_Slide8_Mid_Coniel
END

select  Type,DataSource,Mkt,Prod,Productname,X,Y
into OutputPerformanceByHosp_CV_Modi_Slide8_Mid_Coniel
	from
	 (
		select Type,DataSource,Mkt,Prod,Productname,
		cast(hosp_Count as float) as hosp_Count,cast(MarketContr as float) as MarketContr,
		cast(ProductMarketShare as float) ProductMarketShare ,cast(ProductMarketGrowth as float) as ProductMarketGrowth
		from OutputPerformanceByHosp_CV_Modi_Slide8_Output_Coniel
	) t1 unpivot(
		Y for X in (hosp_Count,MarketContr, ProductMarketShare,ProductMarketGrowth )
	) t2

delete from OutputPerformanceByHosp_CV_Modi_Slide8_Mid_Coniel
where Productname <> 'Coniel' and X in ('hosp_Count','MarketContr')



--log
exec dbo.sp_Log_Event 'Mid R640','CIA_CPA','2_2_MID_R640.sql','End',null,null
go




print 'over!'