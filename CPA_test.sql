

-------------------------------

SELECT distinct TimeFrame FROM dbo.OutputHospital_All
where LinkChartCode = 'd130'

SELECT * FROM dbo.OutputHospital_All where LinkChartCode = 'd130'

SELECT distinct CPA_id FROM OutputTopCPA 
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


if object_id(N'tblBALHospital',N'U') is not null
	drop table tblBALHospital
go 
SELECT * INTO tblBALHospital FROM DB36.[BMSChinaCSR_Testing].[dbo].Output_BAL_Hospital_ForCIA

SELECT product, parentGeo,  datasource, a.mkt, a.Prod , SUM(UM1)
FROM tempBALHospitalDataByGeo AS a 
INNER JOIN tblMktDef_MRBIChina AS b ON a.prod = b.prod AND a.mkt = b.mkt
WHERE b.mkt = 'arv'
GROUP BY Product, parentgeo, datasource, a.mkt, a.Prod 


SELECT * FROM dbo.tblMktDefHospital
SELECT * FROM tempBALHospitalDataByGeo 


if object_id(N'OutputBALHospitalDataByGeo',N'U') is not null
	drop table OutputBALHospitalDataByGeo
go 

declare @sql varchar(max), @i int 

set @sql = '
SELECT product, parentGeo,  datasource, a.mkt, a.Prod , 
  sum([UM1]) as [UM1], sum(VM1) as [VM1], 
  sum([UR3M1]) as [UR3M1], sum([VR3M1]) as [VR3M1],
  sum([UYTD]) as [UYTD], sum([VYTD]) as [VYTD],
  sum([UMAT1]) as [UMAT1], sum([VMAT1]) as [VMAT1]
  '
set @sql = @sql + '
into OutputBALHospitalDataByGeo
FROM tempBALHospitalDataByGeo AS a 
INNER JOIN tblMktDef_MRBIChina AS b ON a.prod = b.prod AND a.mkt = b.mkt
WHERE b.mkt = ''arv''
GROUP BY Product, parentgeo, datasource, a.mkt, a.Prod 
'
print @sql 
exec(@sql) 

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


























