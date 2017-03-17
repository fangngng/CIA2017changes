


SELECT distinct Product FROM output_stage where LinkChartCode = 'r020'

SELECT * FROM OurputPreMarketTrendT1 

select distinct Period,MoneyType,Market,mkt,productname,Audi_des,
	case when CurrRank is null then RANK ( )OVER (PARTITION BY Period,MoneyType,Market,mkt,productname order by Qtr00 desc )+100 else CurrRank end as CurrRank 
from OutputPreCityPerformance 
where Period in('MQT', 'YTD') and Moneytype<>'UN' and mkt not in ('Dia','ACE','DPP4') and prod='000'

select distinct MoneyType,mkt,Market,Prod,Productname,Audi_cod,Audi_des,region 
from  dbo.OutputGeoHBVSummaryT1 where Class='N' and Mkt<>'DPP4' and mkt <> 'Eliquis NOAC' and Market<>'Paraplatin'
union all
select distinct MoneyType,mkt,Market,Prod,Productname,Audi_cod,Audi_des,region 
from  dbo.OutputGeoHBVSummaryT1 where Class='N' and Mkt<>'DPP4' and mkt <> 'Eliquis NOAC' and Market='Paraplatin' and prod='100'

SELECT * FROM tblMktDef_MRBIChina B
 where B.Active='Y' and b.mkt not like'eliquis%'

 SELECT distinct AUDI_COD FROM mthcity_pkau

 SELECT * FROM TempCityDashboard 

 SELECT distinct AUDI_COD FROM tempFactSales 

 SELECT * FROM dbo.Max_Data

 SELECT distinct city_ID FROM Dim_Fact_Sales 

 SELECT * FROM dbo.Dim_City

select distinct  case Chart when 'Volume Trend' then 'Y' else 'N' end as isshow,
	Region,Audi_des,MoneyType,market,Productname,Prod 
from dbo.OutputCityPerformanceByBrand 
where (Chart in('Volume Trend','CAGR') and (Class='Y' or molecule='Y')) 

select distinct X  from dbo.[output_stage] where LinkChartCode= 'd091'
select *  from dbo.[output_stage] where LinkChartCode= 'd091' and geo = 'shanghai'

select TimeFrame FROM WebChartTitle where LinkChartCode = 'd091'

SELECT distinct TimeFrame FROM output where LinkChartCode = 'd091'

SELECT * FROM dbo.tblcaption

SELECT * FROM OutputCityPerformanceByBrand 

SELECT * FROM TempRegionCityDashboard 

SELECT * FROM OutputGeoHBVSummaryT1 

SELECT * FROM OutputCityPerformanceByBrand_For_OtherETV 

select B.*
from [output_stage] A 
inner join dbo.OutputCityPerformanceByBrand_For_OtherETV B
on A.Currency=B.MoneyType and A.X='MAT00'and B.Chart='Market Share Trend' and B.Class='N' and  B.molecule='N' 
	and B.mkt NOT in('DPP4','Eliquis NOAC','Eliquis VTet') and not (mkt = 'Eliquis VTep' and Prod = '600'  )
	and a.LinkChartCode = 'D082' and A.Series=B.Productname and A.ParentGeo=B.region and A.geo=B.audi_des

SELECT * FROM MID_TopIL_CompaniesPerformance 

SELECT * FROM dbo.output_stage where LinkChartCode = 'r520'

SELECT * FROM OurputPreMarketTrendT1 

select * from WebChartTitle 

SELECT * FROM OutputPreCityPerformance 

SELECT * FROM dbo.output_stage where LinkChartCode = 'c020'
select distinct X  from dbo.[output_stage] where LinkChartCode= 'c020'
SELECT * FROM OurputKey10TAVSTotalMkt 

SELECT * FROM dbo.output_stage
where LinkChartCode = 'c040'

SELECT * FROM OutputKeyMNCsPerformance

SELECT *  
from dbo.MTHCHPA_PKAU A 
where exists(select * from MTHCHPA_PKAU B where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD='I')


select co 
from dbo.MTHCHPA_PKAU A 
where MNFL_COD='I'

SELECT * FROM tblMktDef_BMSFocused10Mkt 

SELECT * FROM dbo.inHKAPI_New

SELECT convert(varchar(10), year) + Quarter FROM dbo.tblMonthList
where MonSeq = 1

SELECT * FROM tblMonthList 

SELECT * FROM dbo.WebChartTitle where LinkChartCode = 'c201'

SELECT * FROM dbo.output_stage
where LinkChartCode = 'c020' and TimeFrame = 'mth' and Currency = 'usd'
	and Product = 'taxol' and Category = 'value' and lev = 'nation' and Currency = 'usd'

select distinct Productname, Prod,Period,MoneyType,market 
from dbo.OutputKeyBrandPerformance_For_OtherETV 
where market = 'Taxol' and Period<>'MQT' and MoneyType<>'PN' 

SELECT * FROM OutputCMLChinaMarketTrend

select distinct market,[type],Period,MoneyType,case [type] when 'Sales' then Productname else Productname+' '+[Type] end as Productname,ProdIdx 
from dbo.OutputCMLChinaMarketTrend where market<>'Paraplatin' and MoneyType<>'PN'

SELECT * FROM OutputCMLChina_HKAPI 

SELECT * FROM inHKAPI_New 
SELECT * FROM OutputCMLChina_HKAPI 

SELECT * FROM OurputKey10TAVSTotalMkt 

SELECT * FROM dbo.HKAPI_2016Q4STLY-HKAPI_2016Q3STLY

SELECT * FROM output 

SELECT * FROM OutputPreCityPerformance 

SELECT Molecule, Class, mkt, mktname, Market, prod, Productname, Moneytype, Audi_cod, Audi_des, Lev, Tier, R3M00, R3M01,
	   R3M02, R3M03, R3M04, R3M05, R3M06, R3M07, R3M08, R3M09, R3M10, R3M11, R3M12, R3M13, R3M14, R3M15, R3M16, R3M17,
	   R3M18, R3M19, R3M20, R3M21, R3M22, R3M23, R3M24, R3M25, R3M26, R3M27, R3M28, R3M29, R3M30, R3M31, R3M32, R3M33,
	   R3M34, R3M35, R3M36, R3M37, R3M38, R3M39, R3M40, R3M41, R3M42, R3M43, R3M44, R3M45, MTH00, MTH01, MTH02, MTH03,
	   MTH04, MTH05, MTH06, MTH07, MTH08, MTH09, MTH10, MTH11, MTH12, MTH13, MTH14, MTH15, MTH16, MTH17, MTH18, MTH19,
	   MTH20, MTH21, MTH22, MTH23, MTH24, MTH25, MTH26, MTH27, MTH28, MTH29, MTH30, MTH31, MTH32, MTH33, MTH34, MTH35,
	   MTH36, MTH37, MTH38, MTH39, MTH40, MTH41, MTH42, MTH43, MTH44, MTH45, MTH46, MTH47, MTH48, MAT00, MAT01, MAT02,
	   MAT03, MAT04, MAT05, MAT06, MAT07, MAT08, MAT09, MAT10, MAT11, MAT12, MAT13, MAT14, MAT15, MAT16, MAT17, MAT18,
	   MAT19, MAT20, MAT21, MAT22, MAT23, MAT24, MAT25, MAT26, MAT27, MAT28, MAT29, MAT30, MAT31, MAT32, MAT33, MAT34,
	   MAT35, MAT36, MAT37, MAT38, MAT39, MAT40, MAT41, MAT42, MAT43, MAT44, MAT45, MAT46, MAT47, MAT48, YTD00, YTD01,
	   YTD02, YTD03, YTD04, YTD05, YTD06, YTD07, YTD08, YTD09, YTD10, YTD11, YTD12, YTD13, YTD14, YTD15, YTD16, YTD17,
	   YTD18, YTD19, YTD20, YTD21, YTD22, YTD23, YTD24, YTD25, YTD26, YTD27, YTD28, YTD29, YTD30, YTD31, YTD32, YTD33,
	   YTD34, YTD35, YTD36, YTD37, YTD38, YTD39, YTD40, YTD41, YTD42, YTD43, YTD44, YTD45, YTD46, YTD47, YTD48, Qtr00,
	   Qtr01, Qtr02, Qtr03, Qtr04, Qtr05, Qtr06, Qtr07, Qtr08, Qtr09, Qtr10, Qtr11, Qtr12, Qtr13, Qtr14, Qtr15, Qtr16,
	   Qtr17, Qtr18, Qtr19 
from TempCityDashboard_forPre 

SELECT * FROM Config 
insert into Config 
select 'MAXDATA', 201612, 'Monthly update', '2016Q3', '2016Q4'

--SELECT Province, City, Product,  [剂型（标准_英文）] as Package, [药品规格（标准_英文）] as Specification, 
--	   [201201 Value（RMB）] as [201201LC], [201202 Value（RMB）] as [201202LC], [201203 Value（RMB）] as [201203LC], [201204 Value（RMB）] as [201204LC], [201205 Value（RMB）] as [201205LC],
--	   [201206 Value（RMB）] as [201206LC], [201207 Value（RMB）] as [201207LC], [201208 Value（RMB）] as [201208LC], [201209 Value（RMB）] as [201209LC], [201210 Value（RMB）] as [201210LC],
--	   [201211 Value（RMB）] as [201211LC], [201212 Value（RMB）] as [201212LC], [201301 Value（RMB）] as [201301LC], [201302 Value（RMB）] as [201302LC], [201303 Value（RMB）] as [201303LC],
--	   [201304 Value（RMB）] as [201304LC], [201305 Value（RMB）] as [201305LC], [201306 Value（RMB）] as [201306LC], [201307 Value（RMB）] as [201307LC], [201308 Value（RMB）] as [201308LC],
--	   [201309 Value（RMB）] as [201309LC], [201310 Value（RMB）] as [201310LC], [201311 Value（RMB）] as [201311LC], [201312 Value（RMB）] as [201312LC], [201401 Value（RMB）] as [201401LC],
--	   [201402 Value（RMB）] as [201402LC], [201403 Value（RMB）] as [201403LC], [201404 Value（RMB）] as [201404LC], [201405 Value（RMB）] as [201405LC], [201406 Value（RMB）] as [201406LC],
--	   [201407 Value（RMB）] as [201407LC], [201408 Value（RMB）] as [201408LC], [201409 Value（RMB）] as [201409LC], [201410 Value（RMB）] as [201410LC], [201411 Value（RMB）] as [201411LC],
--	   [201412 Value（RMB）] as [201412LC], [201501 Value（RMB）] as [201501LC], [201502 Value（RMB）] as [201502LC], [201503 Value（RMB）] as [201503LC], [201504 Value（RMB）] as [201504LC],
--	   [201505 Value（RMB）] as [201505LC], [201506 Value（RMB）] as [201506LC], [201507 Value（RMB）] as [201507LC], [201508 Value（RMB）] as [201508LC], [201509 Value（RMB）] as [201509LC],
--	   [201510 Value（RMB）] as [201510LC], [201511 Value（RMB）] as [201511LC], [201512 Value（RMB）] as [201512LC], [201601 Value（RMB）] as [201601LC], [201602 Value（RMB）] as [201602LC],
--	   [201603 Value（RMB）] as [201603LC], [201604 Value（RMB）] as [201604LC], [201605 Value（RMB）] as [201605LC], [201606 Value（RMB）] as [201606LC], [201607 Value（RMB）] as [201607LC],
--	   [201608 Value（RMB）] as [201608LC], [201609 Value（RMB）] as [201609LC], [201610 Value（RMB）] as [201610LC], [201611 Value（RMB）] as [201611LC], [201612 Value（RMB）] as [201612LC],

--	   [201201 Value（USD）] as [201201US], [201202 Value（USD）] as [201202US], [201203 Value（USD）] as [201203US], [201204 Value（USD）] as [201204US], [201205 Value（USD）] as [201205US],
--	   [201206 Value（USD）] as [201206US], [201207 Value（USD）] as [201207US], [201208 Value（USD）] as [201208US], [201209 Value（USD）] as [201209US], [201210 Value（USD）] as [201210US],
--	   [201211 Value（USD）] as [201211US], [201212 Value（USD）] as [201212US], [201301 Value（USD）] as [201301US], [201302 Value（USD）] as [201302US], [201303 Value（USD）] as [201303US],
--	   [201304 Value（USD）] as [201304US], [201305 Value（USD）] as [201305US], [201306 Value（USD）] as [201306US], [201307 Value（USD）] as [201307US], [201308 Value（USD）] as [201308US],
--	   [201309 Value（USD）] as [201309US], [201310 Value（USD）] as [201310US], [201311 Value（USD）] as [201311US], [201312 Value（USD）] as [201312US], [201401 Value（USD）] as [201401US],
--	   [201402 Value（USD）] as [201402US], [201403 Value（USD）] as [201403US], [201404 Value（USD）] as [201404US], [201405 Value（USD）] as [201405US], [201406 Value（USD）] as [201406US],
--	   [201407 Value（USD）] as [201407US], [201408 Value（USD）] as [201408US], [201409 Value（USD）] as [201409US], [201410 Value（USD）] as [201410US], [201411 Value（USD）] as [201411US],
--	   [201412 Value（USD）] as [201412US], [201501 Value（USD）] as [201501US], [201502 Value（USD）] as [201502US], [201503 Value（USD）] as [201503US], [201504 Value（USD）] as [201504US],
--	   [201505 Value（USD）] as [201505US], [201506 Value（USD）] as [201506US], [201507 Value（USD）] as [201507US], [201508 Value（USD）] as [201508US], [201509 Value（USD）] as [201509US],
--	   [201510 Value（USD）] as [201510US], [201511 Value（USD）] as [201511US], [201512 Value（USD）] as [201512US], [201601 Value（USD）] as [201601US], [201602 Value（USD）] as [201602US],
--	   [201603 Value（USD）] as [201603US], [201604 Value（USD）] as [201604US], [201605 Value（USD）] as [201605US], [201606 Value（USD）] as [201606US], [201607 Value（USD）] as [201607US],
--	   [201608 Value（USD）] as [201608US], [201609 Value（USD）] as [201609US], [201610 Value（USD）] as [201610US], [201611 Value（USD）] as [201611US], [201612 Value（USD）] as [201612US],

--	   [201201 Dosage Unit] as [201201UN], [201202 Dosage Unit] as [201202UN], [201203 Dosage Unit] as [201203UN], [201204 Dosage Unit] as [201204UN], [201205 Dosage Unit] as [201205UN],
--	   [201206 Dosage Unit] as [201206UN], [201207 Dosage Unit] as [201207UN], [201208 Dosage Unit] as [201208UN], [201209 Dosage Unit] as [201209UN], [201210 Dosage Unit] as [201210UN],
--	   [201211 Dosage Unit] as [201211UN], [201212 Dosage Unit] as [201212UN], [201301 Dosage Unit] as [201301UN], [201302 Dosage Unit] as [201302UN], [201303 Dosage Unit] as [201303UN],
--	   [201304 Dosage Unit] as [201304UN], [201305 Dosage Unit] as [201305UN], [201306 Dosage Unit] as [201306UN], [201307 Dosage Unit] as [201307UN], [201308 Dosage Unit] as [201308UN],
--	   [201309 Dosage Unit] as [201309UN], [201310 Dosage Unit] as [201310UN], [201311 Dosage Unit] as [201311UN], [201312 Dosage Unit] as [201312UN], [201401 Dosage Unit] as [201401UN],
--	   [201402 Dosage Unit] as [201402UN], [201403 Dosage Unit] as [201403UN], [201404 Dosage Unit] as [201404UN], [201405 Dosage Unit] as [201405UN], [201406 Dosage Unit] as [201406UN],
--	   [201407 Dosage Unit] as [201407UN], [201408 Dosage Unit] as [201408UN], [201409 Dosage Unit] as [201409UN], [201410 Dosage Unit] as [201410UN], [201411 Dosage Unit] as [201411UN],
--	   [201412 Dosage Unit] as [201412UN], [201501 Dosage Unit] as [201501UN], [201502 Dosage Unit] as [201502UN], [201503 Dosage Unit] as [201503UN], [201504 Dosage Unit] as [201504UN],
--	   [201505 Dosage Unit] as [201505UN], [201506 Dosage Unit] as [201506UN], [201507 Dosage Unit] as [201507UN], [201508 Dosage Unit] as [201508UN], [201509 Dosage Unit] as [201509UN],
--	   [201510 Dosage Unit] as [201510UN], [201511 Dosage Unit] as [201511UN], [201512 Dosage Unit] as [201512UN], [201601 Dosage Unit] as [201601UN], [201602 Dosage Unit] as [201602UN],
--	   [201603 Dosage Unit] as [201603UN], [201604 Dosage Unit] as [201604UN], [201605 Dosage Unit] as [201605UN], [201606 Dosage Unit] as [201606UN], [201607 Dosage Unit] as [201607UN],
--	   [201608 Dosage Unit] as [201608UN], [201609 Dosage Unit] as [201609UN], [201610 Dosage Unit] as [201610UN], [201611 Dosage Unit] as [201611UN], [201612 Dosage Unit] as [201612UN],
--	   IMS_Manu, Final_Prod, IMS_Prod, ATC1_Cod, ATC1_Des, ATC2_Cod, ATC2_Des, ATC3_Cod, ATC3_Des, ATC4_Cod,
--	   ATC4_Des, Mole_cod, Mole_des, Prod_cod, Prod_Des, Pack_Cod, Pack_Des, Corp_cod, Corp_Des, manu_cod, Manu_des,
--	   MNC, Gene_Cod 
----into inMaxData
--from dbo.Max_Data

SELECT top 100 * FROM BMSChinaCIA_IMS_test.dbo.Max_Data 

SELECT top 100 * FROM dbo.inCPAData

SELECT * FROM dbo.maxcity

