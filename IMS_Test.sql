


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

SELECT * FROM dbo.HKAPI_2016Q4STLY--HKAPI_2016Q3STLY

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
--insert into Config 
--select 'MAXDATA', 201612, 'Monthly update', '2016Q3', '2016Q4'

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

SELECT top 100 * FROM BMSChinaCIA_IMS.dbo.Max_Data 

SELECT top 100 * FROM dbo.inCPAData

SELECT * FROM dbo.maxcity

SELECT * FROM inMaxData 

SELECT * FROM dbo.Config

SELECT top 1 * FROM dbo.MTHCITY_PKAU
SELECT top 1 * FROM dbo.inmaxdata

SELECT a.name, b.name 
from sys.columns as a 
inner join sys.objects as b on a.object_id = b.object_id
where b.name = 'Max_Data'

select dbo.fnAddColumns('MTH', 'LC', 3)

SELECT * FROM dbo.Max_Data

SELECT * FROM dbo.tblMonthList

SELECT * FROM dbo.Dim_City

SELECT * FROM dbo.maxcity
SELECT * FROM dbo.outputgeo

SELECT * FROM dbo.Max_Data
select * FROM tblCityIMS 
SELECT * FROM BMSChinaCIARawdata.dbo.Dim_City_201507 

SELECT * FROM dbo.MAXRegionCity

SELECT distinct Geo FROM dbo.output_stage where LinkChartCode = 'd091' 

SELECT * FROM OutputCityPerformanceByBrand 

SELECT * FROM TempRegionCityDashboard 

SELECT * FROM TempCityDashboard 

SELECT top 1 * FROM mthcity_pkau 
SELECT top 1 * FROM inmaxdata

--insert	into dbo.MTHCITY_PKAU ( CITY_ID, AUDI_COD, PACK_COD, PACK_DES, ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, PROD_COD,
--								MANU_COD, MNFL_COD, CORP_COD, MTH00UN, MTH01UN, MTH02UN, MTH03UN, MTH04UN, MTH05UN,
--								MTH06UN, MTH07UN, MTH08UN, MTH09UN, MTH10UN, MTH11UN, MTH12UN, MTH13UN, MTH14UN, MTH15UN,
--								MTH16UN, MTH17UN, MTH18UN, MTH19UN, MTH20UN, MTH21UN, MTH22UN, MTH23UN, MTH24UN, MTH25UN,
--								MTH26UN, MTH27UN, MTH28UN, MTH29UN, MTH30UN, MTH31UN, MTH32UN, MTH33UN, MTH34UN, MTH35UN,
--								MTH36UN, MTH37UN, MTH38UN, MTH39UN, MTH40UN, MTH41UN, MTH42UN, MTH43UN, MTH44UN, MTH45UN,
--								MTH46UN, MTH47UN, MTH48UN, MTH49UN, MTH50UN, MTH51UN, MTH52UN, MTH53UN, MTH54UN, MTH55UN,
--								MTH56UN, MTH57UN, MTH58UN, MTH59UN, MTH60UN, MTH61UN, MTH62UN, MTH63UN, MTH64UN, MTH65UN,
--								MTH66UN, MTH67UN, MTH68UN, MTH69UN, MTH70UN, MTH71UN, MTH00LC, MTH01LC, MTH02LC, MTH03LC,
--								MTH04LC, MTH05LC, MTH06LC, MTH07LC, MTH08LC, MTH09LC, MTH10LC, MTH11LC, MTH12LC, MTH13LC,
--								MTH14LC, MTH15LC, MTH16LC, MTH17LC, MTH18LC, MTH19LC, MTH20LC, MTH21LC, MTH22LC, MTH23LC,
--								MTH24LC, MTH25LC, MTH26LC, MTH27LC, MTH28LC, MTH29LC, MTH30LC, MTH31LC, MTH32LC, MTH33LC,
--								MTH34LC, MTH35LC, MTH36LC, MTH37LC, MTH38LC, MTH39LC, MTH40LC, MTH41LC, MTH42LC, MTH43LC,
--								MTH44LC, MTH45LC, MTH46LC, MTH47LC, MTH48LC, MTH49LC, MTH50LC, MTH51LC, MTH52LC, MTH53LC,
--								MTH54LC, MTH55LC, MTH56LC, MTH57LC, MTH58LC, MTH59LC, MTH60LC, MTH61LC, MTH62LC, MTH63LC,
--								MTH64LC, MTH65LC, MTH66LC, MTH67LC, MTH68LC, MTH69LC, MTH70LC, MTH71LC, MTH00US, MTH01US,
--								MTH02US, MTH03US, MTH04US, MTH05US, MTH06US, MTH07US, MTH08US, MTH09US, MTH10US, MTH11US,
--								MTH12US, MTH13US, MTH14US, MTH15US, MTH16US, MTH17US, MTH18US, MTH19US, MTH20US, MTH21US,
--								MTH22US, MTH23US, MTH24US, MTH25US, MTH26US, MTH27US, MTH28US, MTH29US, MTH30US, MTH31US,
--								MTH32US, MTH33US, MTH34US, MTH35US, MTH36US, MTH37US, MTH38US, MTH39US, MTH40US, MTH41US,
--								MTH42US, MTH43US, MTH44US, MTH45US, MTH46US, MTH47US, MTH48US, MTH49US, MTH50US, MTH51US,
--								MTH52US, MTH53US, MTH54US, MTH55US, MTH56US, MTH57US, MTH58US, MTH59US, MTH60US, MTH61US,
--								MTH62US, MTH63US, MTH64US, MTH65US, MTH66US, MTH67US, MTH68US, MTH69US, MTH70US, MTH71US,
--								MAT00US, MAT01US, MAT02US, MAT03US, MAT04US, MAT05US, MAT06US, MAT07US, MAT08US, MAT09US,
--								MAT10US, MAT11US, MAT12US, MAT13US, MAT14US, MAT15US, MAT16US, MAT17US, MAT18US, MAT19US,
--								MAT20US, MAT21US, MAT22US, MAT23US, MAT24US, MAT25US, MAT26US, MAT27US, MAT28US, MAT29US,
--								MAT30US, MAT31US, MAT32US, MAT33US, MAT34US, MAT35US, MAT36US, MAT37US, MAT38US, MAT39US,
--								MAT40US, MAT41US, MAT42US, MAT43US, MAT44US, MAT45US, MAT46US, MAT47US, MAT48US, MAT00LC,
--								MAT01LC, MAT02LC, MAT03LC, MAT04LC, MAT05LC, MAT06LC, MAT07LC, MAT08LC, MAT09LC, MAT10LC,
--								MAT11LC, MAT12LC, MAT13LC, MAT14LC, MAT15LC, MAT16LC, MAT17LC, MAT18LC, MAT19LC, MAT20LC,
--								MAT21LC, MAT22LC, MAT23LC, MAT24LC, MAT25LC, MAT26LC, MAT27LC, MAT28LC, MAT29LC, MAT30LC,
--								MAT31LC, MAT32LC, MAT33LC, MAT34LC, MAT35LC, MAT36LC, MAT37LC, MAT38LC, MAT39LC, MAT40LC,
--								MAT41LC, MAT42LC, MAT43LC, MAT44LC, MAT45LC, MAT46LC, MAT47LC, MAT48LC, MAT00UN, MAT01UN,
--								MAT02UN, MAT03UN, MAT04UN, MAT05UN, MAT06UN, MAT07UN, MAT08UN, MAT09UN, MAT10UN, MAT11UN,
--								MAT12UN, MAT13UN, MAT14UN, MAT15UN, MAT16UN, MAT17UN, MAT18UN, MAT19UN, MAT20UN, MAT21UN,
--								MAT22UN, MAT23UN, MAT24UN, MAT25UN, MAT26UN, MAT27UN, MAT28UN, MAT29UN, MAT30UN, MAT31UN,
--								MAT32UN, MAT33UN, MAT34UN, MAT35UN, MAT36UN, MAT37UN, MAT38UN, MAT39UN, MAT40UN, MAT41UN,
--								MAT42UN, MAT43UN, MAT44UN, MAT45UN, MAT46UN, MAT47UN, MAT48UN, R3M00US, R3M01US, R3M02US,
--								R3M03US, R3M04US, R3M05US, R3M06US, R3M07US, R3M08US, R3M09US, R3M10US, R3M11US, R3M12US,
--								R3M13US, R3M14US, R3M15US, R3M16US, R3M17US, R3M18US, R3M19US, R3M20US, R3M21US, R3M22US,
--								R3M23US, R3M24US, R3M25US, R3M26US, R3M27US, R3M28US, R3M29US, R3M30US, R3M31US, R3M32US,
--								R3M33US, R3M34US, R3M35US, R3M36US, R3M37US, R3M38US, R3M39US, R3M40US, R3M41US, R3M42US,
--								R3M43US, R3M44US, R3M45US, R3M46US, R3M47US, R3M48US, R3M00LC, R3M01LC, R3M02LC, R3M03LC,
--								R3M04LC, R3M05LC, R3M06LC, R3M07LC, R3M08LC, R3M09LC, R3M10LC, R3M11LC, R3M12LC, R3M13LC,
--								R3M14LC, R3M15LC, R3M16LC, R3M17LC, R3M18LC, R3M19LC, R3M20LC, R3M21LC, R3M22LC, R3M23LC,
--								R3M24LC, R3M25LC, R3M26LC, R3M27LC, R3M28LC, R3M29LC, R3M30LC, R3M31LC, R3M32LC, R3M33LC,
--								R3M34LC, R3M35LC, R3M36LC, R3M37LC, R3M38LC, R3M39LC, R3M40LC, R3M41LC, R3M42LC, R3M43LC,
--								R3M44LC, R3M45LC, R3M46LC, R3M47LC, R3M48LC, R3M00UN, R3M01UN, R3M02UN, R3M03UN, R3M04UN,
--								R3M05UN, R3M06UN, R3M07UN, R3M08UN, R3M09UN, R3M10UN, R3M11UN, R3M12UN, R3M13UN, R3M14UN,
--								R3M15UN, R3M16UN, R3M17UN, R3M18UN, R3M19UN, R3M20UN, R3M21UN, R3M22UN, R3M23UN, R3M24UN,
--								R3M25UN, R3M26UN, R3M27UN, R3M28UN, R3M29UN, R3M30UN, R3M31UN, R3M32UN, R3M33UN, R3M34UN,
--								R3M35UN, R3M36UN, R3M37UN, R3M38UN, R3M39UN, R3M40UN, R3M41UN, R3M42UN, R3M43UN, R3M44UN,
--								R3M45UN, R3M46UN, R3M47UN, R3M48UN, QTR00US, QTR01US, QTR02US, QTR03US, QTR04US, QTR05US,
--								QTR06US, QTR07US, QTR08US, QTR09US, QTR10US, QTR11US, QTR12US, QTR13US, QTR14US, QTR15US,
--								QTR16US, QTR17US, QTR18US, QTR19US, QTR00LC, QTR01LC, QTR02LC, QTR03LC, QTR04LC, QTR05LC,
--								QTR06LC, QTR07LC, QTR08LC, QTR09LC, QTR10LC, QTR11LC, QTR12LC, QTR13LC, QTR14LC, QTR15LC,
--								QTR16LC, QTR17LC, QTR18LC, QTR19LC, QTR00UN, QTR01UN, QTR02UN, QTR03UN, QTR04UN, QTR05UN,
--								QTR06UN, QTR07UN, QTR08UN, QTR09UN, QTR10UN, QTR11UN, QTR12UN, QTR13UN, QTR14UN, QTR15UN,
--								QTR16UN, QTR17UN, QTR18UN, QTR19UN, YTD00US, YTD01US, YTD02US, YTD03US, YTD04US, YTD05US,
--								YTD06US, YTD07US, YTD08US, YTD09US, YTD10US, YTD11US, YTD12US, YTD13US, YTD14US, YTD15US,
--								YTD16US, YTD17US, YTD18US, YTD19US, YTD20US, YTD21US, YTD22US, YTD23US, YTD24US, YTD25US,
--								YTD26US, YTD27US, YTD28US, YTD29US, YTD30US, YTD31US, YTD32US, YTD33US, YTD34US, YTD35US,
--								YTD36US, YTD37US, YTD38US, YTD39US, YTD40US, YTD41US, YTD42US, YTD43US, YTD44US, YTD45US,
--								YTD46US, YTD47US, YTD48US, YTD00LC, YTD01LC, YTD02LC, YTD03LC, YTD04LC, YTD05LC, YTD06LC,
--								YTD07LC, YTD08LC, YTD09LC, YTD10LC, YTD11LC, YTD12LC, YTD13LC, YTD14LC, YTD15LC, YTD16LC,
--								YTD17LC, YTD18LC, YTD19LC, YTD20LC, YTD21LC, YTD22LC, YTD23LC, YTD24LC, YTD25LC, YTD26LC,
--								YTD27LC, YTD28LC, YTD29LC, YTD30LC, YTD31LC, YTD32LC, YTD33LC, YTD34LC, YTD35LC, YTD36LC,
--								YTD37LC, YTD38LC, YTD39LC, YTD40LC, YTD41LC, YTD42LC, YTD43LC, YTD44LC, YTD45LC, YTD46LC,
--								YTD47LC, YTD48LC, YTD00UN, YTD01UN, YTD02UN, YTD03UN, YTD04UN, YTD05UN, YTD06UN, YTD07UN,
--								YTD08UN, YTD09UN, YTD10UN, YTD11UN, YTD12UN, YTD13UN, YTD14UN, YTD15UN, YTD16UN, YTD17UN,
--								YTD18UN, YTD19UN, YTD20UN, YTD21UN, YTD22UN, YTD23UN, YTD24UN, YTD25UN, YTD26UN, YTD27UN,
--								YTD28UN, YTD29UN, YTD30UN, YTD31UN, YTD32UN, YTD33UN, YTD34UN, YTD35UN, YTD36UN, YTD37UN,
--								YTD38UN, YTD39UN, YTD40UN, YTD41UN, YTD42UN, YTD43UN, YTD44UN, YTD45UN, YTD46UN, YTD47UN,
--								YTD48UN )
--select	'', b.Audi_Cod, Pack_Cod, Pack_Des, ATC1_Cod, ATC2_Cod, ATC3_Cod, ATC4_Cod, Prod_cod, manu_cod, MNFL_COD,
--		Corp_cod, MTH00UN, MTH01UN, MTH02UN, MTH03UN, MTH04UN, MTH05UN, MTH06UN, MTH07UN, MTH08UN, MTH09UN, MTH10UN,
--		MTH11UN, MTH12UN, MTH13UN, MTH14UN, MTH15UN, MTH16UN, MTH17UN, MTH18UN, MTH19UN, MTH20UN, MTH21UN, MTH22UN,
--		MTH23UN, MTH24UN, MTH25UN, MTH26UN, MTH27UN, MTH28UN, MTH29UN, MTH30UN, MTH31UN, MTH32UN, MTH33UN, MTH34UN,
--		MTH35UN, MTH36UN, MTH37UN, MTH38UN, MTH39UN, MTH40UN, MTH41UN, MTH42UN, MTH43UN, MTH44UN, MTH45UN, MTH46UN,
--		MTH47UN, MTH48UN, MTH49UN, MTH50UN, MTH51UN, MTH52UN, MTH53UN, MTH54UN, MTH55UN, MTH56UN, MTH57UN, MTH58UN,
--		MTH59UN, MTH60UN, MTH61UN, MTH62UN, MTH63UN, MTH64UN, MTH65UN, MTH66UN, MTH67UN, MTH68UN, MTH69UN, MTH70UN,
--		MTH71UN, MTH00LC, MTH01LC, MTH02LC, MTH03LC, MTH04LC, MTH05LC, MTH06LC, MTH07LC, MTH08LC, MTH09LC, MTH10LC,
--		MTH11LC, MTH12LC, MTH13LC, MTH14LC, MTH15LC, MTH16LC, MTH17LC, MTH18LC, MTH19LC, MTH20LC, MTH21LC, MTH22LC,
--		MTH23LC, MTH24LC, MTH25LC, MTH26LC, MTH27LC, MTH28LC, MTH29LC, MTH30LC, MTH31LC, MTH32LC, MTH33LC, MTH34LC,
--		MTH35LC, MTH36LC, MTH37LC, MTH38LC, MTH39LC, MTH40LC, MTH41LC, MTH42LC, MTH43LC, MTH44LC, MTH45LC, MTH46LC,
--		MTH47LC, MTH48LC, MTH49LC, MTH50LC, MTH51LC, MTH52LC, MTH53LC, MTH54LC, MTH55LC, MTH56LC, MTH57LC, MTH58LC,
--		MTH59LC, MTH60LC, MTH61LC, MTH62LC, MTH63LC, MTH64LC, MTH65LC, MTH66LC, MTH67LC, MTH68LC, MTH69LC, MTH70LC,
--		MTH71LC, MTH00US, MTH01US, MTH02US, MTH03US, MTH04US, MTH05US, MTH06US, MTH07US, MTH08US, MTH09US, MTH10US,
--		MTH11US, MTH12US, MTH13US, MTH14US, MTH15US, MTH16US, MTH17US, MTH18US, MTH19US, MTH20US, MTH21US, MTH22US,
--		MTH23US, MTH24US, MTH25US, MTH26US, MTH27US, MTH28US, MTH29US, MTH30US, MTH31US, MTH32US, MTH33US, MTH34US,
--		MTH35US, MTH36US, MTH37US, MTH38US, MTH39US, MTH40US, MTH41US, MTH42US, MTH43US, MTH44US, MTH45US, MTH46US,
--		MTH47US, MTH48US, MTH49US, MTH50US, MTH51US, MTH52US, MTH53US, MTH54US, MTH55US, MTH56US, MTH57US, MTH58US,
--		MTH59US, MTH60US, MTH61US, MTH62US, MTH63US, MTH64US, MTH65US, MTH66US, MTH67US, MTH68US, MTH69US, MTH70US,
--		MTH71US, MAT00US, MAT01US, MAT02US, MAT03US, MAT04US, MAT05US, MAT06US, MAT07US, MAT08US, MAT09US, MAT10US,
--		MAT11US, MAT12US, MAT13US, MAT14US, MAT15US, MAT16US, MAT17US, MAT18US, MAT19US, MAT20US, MAT21US, MAT22US,
--		MAT23US, MAT24US, MAT25US, MAT26US, MAT27US, MAT28US, MAT29US, MAT30US, MAT31US, MAT32US, MAT33US, MAT34US,
--		MAT35US, MAT36US, MAT37US, MAT38US, MAT39US, MAT40US, MAT41US, MAT42US, MAT43US, MAT44US, MAT45US, MAT46US,
--		MAT47US, MAT48US, MAT00LC, MAT01LC, MAT02LC, MAT03LC, MAT04LC, MAT05LC, MAT06LC, MAT07LC, MAT08LC, MAT09LC,
--		MAT10LC, MAT11LC, MAT12LC, MAT13LC, MAT14LC, MAT15LC, MAT16LC, MAT17LC, MAT18LC, MAT19LC, MAT20LC, MAT21LC,
--		MAT22LC, MAT23LC, MAT24LC, MAT25LC, MAT26LC, MAT27LC, MAT28LC, MAT29LC, MAT30LC, MAT31LC, MAT32LC, MAT33LC,
--		MAT34LC, MAT35LC, MAT36LC, MAT37LC, MAT38LC, MAT39LC, MAT40LC, MAT41LC, MAT42LC, MAT43LC, MAT44LC, MAT45LC,
--		MAT46LC, MAT47LC, MAT48LC, MAT00UN, MAT01UN, MAT02UN, MAT03UN, MAT04UN, MAT05UN, MAT06UN, MAT07UN, MAT08UN,
--		MAT09UN, MAT10UN, MAT11UN, MAT12UN, MAT13UN, MAT14UN, MAT15UN, MAT16UN, MAT17UN, MAT18UN, MAT19UN, MAT20UN,
--		MAT21UN, MAT22UN, MAT23UN, MAT24UN, MAT25UN, MAT26UN, MAT27UN, MAT28UN, MAT29UN, MAT30UN, MAT31UN, MAT32UN,
--		MAT33UN, MAT34UN, MAT35UN, MAT36UN, MAT37UN, MAT38UN, MAT39UN, MAT40UN, MAT41UN, MAT42UN, MAT43UN, MAT44UN,
--		MAT45UN, MAT46UN, MAT47UN, MAT48UN, R3M00US, R3M01US, R3M02US, R3M03US, R3M04US, R3M05US, R3M06US, R3M07US,
--		R3M08US, R3M09US, R3M10US, R3M11US, R3M12US, R3M13US, R3M14US, R3M15US, R3M16US, R3M17US, R3M18US, R3M19US,
--		R3M20US, R3M21US, R3M22US, R3M23US, R3M24US, R3M25US, R3M26US, R3M27US, R3M28US, R3M29US, R3M30US, R3M31US,
--		R3M32US, R3M33US, R3M34US, R3M35US, R3M36US, R3M37US, R3M38US, R3M39US, R3M40US, R3M41US, R3M42US, R3M43US,
--		R3M44US, R3M45US, R3M46US, R3M47US, R3M48US, R3M00LC, R3M01LC, R3M02LC, R3M03LC, R3M04LC, R3M05LC, R3M06LC,
--		R3M07LC, R3M08LC, R3M09LC, R3M10LC, R3M11LC, R3M12LC, R3M13LC, R3M14LC, R3M15LC, R3M16LC, R3M17LC, R3M18LC,
--		R3M19LC, R3M20LC, R3M21LC, R3M22LC, R3M23LC, R3M24LC, R3M25LC, R3M26LC, R3M27LC, R3M28LC, R3M29LC, R3M30LC,
--		R3M31LC, R3M32LC, R3M33LC, R3M34LC, R3M35LC, R3M36LC, R3M37LC, R3M38LC, R3M39LC, R3M40LC, R3M41LC, R3M42LC,
--		R3M43LC, R3M44LC, R3M45LC, R3M46LC, R3M47LC, R3M48LC, R3M00UN, R3M01UN, R3M02UN, R3M03UN, R3M04UN, R3M05UN,
--		R3M06UN, R3M07UN, R3M08UN, R3M09UN, R3M10UN, R3M11UN, R3M12UN, R3M13UN, R3M14UN, R3M15UN, R3M16UN, R3M17UN,
--		R3M18UN, R3M19UN, R3M20UN, R3M21UN, R3M22UN, R3M23UN, R3M24UN, R3M25UN, R3M26UN, R3M27UN, R3M28UN, R3M29UN,
--		R3M30UN, R3M31UN, R3M32UN, R3M33UN, R3M34UN, R3M35UN, R3M36UN, R3M37UN, R3M38UN, R3M39UN, R3M40UN, R3M41UN,
--		R3M42UN, R3M43UN, R3M44UN, R3M45UN, R3M46UN, R3M47UN, R3M48UN, QTR00US, QTR01US, QTR02US, QTR03US, QTR04US,
--		QTR05US, QTR06US, QTR07US, QTR08US, QTR09US, QTR10US, QTR11US, QTR12US, QTR13US, QTR14US, QTR15US, QTR16US,
--		QTR17US, QTR18US, QTR19US, QTR00LC, QTR01LC, QTR02LC, QTR03LC, QTR04LC, QTR05LC, QTR06LC, QTR07LC, QTR08LC,
--		QTR09LC, QTR10LC, QTR11LC, QTR12LC, QTR13LC, QTR14LC, QTR15LC, QTR16LC, QTR17LC, QTR18LC, QTR19LC, QTR00UN,
--		QTR01UN, QTR02UN, QTR03UN, QTR04UN, QTR05UN, QTR06UN, QTR07UN, QTR08UN, QTR09UN, QTR10UN, QTR11UN, QTR12UN,
--		QTR13UN, QTR14UN, QTR15UN, QTR16UN, QTR17UN, QTR18UN, QTR19UN, YTD00US, YTD01US, YTD02US, YTD03US, YTD04US,
--		YTD05US, YTD06US, YTD07US, YTD08US, YTD09US, YTD10US, YTD11US, YTD12US, YTD13US, YTD14US, YTD15US, YTD16US,
--		YTD17US, YTD18US, YTD19US, YTD20US, YTD21US, YTD22US, YTD23US, YTD24US, YTD25US, YTD26US, YTD27US, YTD28US,
--		YTD29US, YTD30US, YTD31US, YTD32US, YTD33US, YTD34US, YTD35US, YTD36US, YTD37US, YTD38US, YTD39US, YTD40US,
--		YTD41US, YTD42US, YTD43US, YTD44US, YTD45US, YTD46US, YTD47US, YTD48US, YTD00LC, YTD01LC, YTD02LC, YTD03LC,
--		YTD04LC, YTD05LC, YTD06LC, YTD07LC, YTD08LC, YTD09LC, YTD10LC, YTD11LC, YTD12LC, YTD13LC, YTD14LC, YTD15LC,
--		YTD16LC, YTD17LC, YTD18LC, YTD19LC, YTD20LC, YTD21LC, YTD22LC, YTD23LC, YTD24LC, YTD25LC, YTD26LC, YTD27LC,
--		YTD28LC, YTD29LC, YTD30LC, YTD31LC, YTD32LC, YTD33LC, YTD34LC, YTD35LC, YTD36LC, YTD37LC, YTD38LC, YTD39LC,
--		YTD40LC, YTD41LC, YTD42LC, YTD43LC, YTD44LC, YTD45LC, YTD46LC, YTD47LC, YTD48LC, YTD00UN, YTD01UN, YTD02UN,
--		YTD03UN, YTD04UN, YTD05UN, YTD06UN, YTD07UN, YTD08UN, YTD09UN, YTD10UN, YTD11UN, YTD12UN, YTD13UN, YTD14UN,
--		YTD15UN, YTD16UN, YTD17UN, YTD18UN, YTD19UN, YTD20UN, YTD21UN, YTD22UN, YTD23UN, YTD24UN, YTD25UN, YTD26UN,
--		YTD27UN, YTD28UN, YTD29UN, YTD30UN, YTD31UN, YTD32UN, YTD33UN, YTD34UN, YTD35UN, YTD36UN, YTD37UN, YTD38UN,
--		YTD39UN, YTD40UN, YTD41UN, YTD42UN, YTD43UN, YTD44UN, YTD45UN, YTD46UN, YTD47UN, YTD48UN
--from	inmaxdata as a
--left join tblCityMAX as b on a.City = b.City_CN 


select * from output_stage where linkchartcode = 'd082'




--insert into OutputCityPerformanceByBrand(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],
--	audi_cod,audi_des,region, MTH00)

--select top 1 * from (
--	select [Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,
--		--case when mkt='arv' and MTH48<>0 then Power((MTH00/MTH48),1.0/4)-1
--		--	--when mkt='arv' and MTH48=0 and MTH36<>0 then Power((MTH00/MTH36),1.0/3)-1
--		--	--when mkt='arv' and MTH48=0 and MTH36=0 and MTH24<>0 then Power((MTH00/MTH24),1.0/2)-1
--		--	--when mkt='arv' and MTH48=0 and MTH36=0 and MTH24=0  and MTH12<>0  then Power((MTH00/MTH12),1.0/1)-1
--		--	--when mkt='arv' and MTH48=0 and MTH36=0 and MTH24=0 and MTH12=0 then 0
--		--	--else null
--		--end as MTH00	  , 
--		case when mkt='arv' and MTH48<>0 then MTH00 /MTH48 end as mth, mth00, mth48 
--		--, case when mkt='arv' and MTH48<>0 then power(MTH00 /MTH48, .25) end as mth
--	from OutputCityPerformanceByBrand A 
--	where Chart='Volume Trend' and audi_des = 'Linyi' 
--		and exists(
--			select * 
--			from (
--				select distinct Molecule,Class,mkt,Market,mktname,Moneytype,audi_cod,region
--				from OutputCityPerformanceByBrand where Chart='Volume Trend'
--					and R3M05<>0 and prod='000'
--			) B
--			where a.Molecule=b.Molecule and A.Class=B.Class and A.mkt=B.mkt and A.Market=B.Market
--				and A.Moneytype=B.moneytype 
--		) 
--) as a 
--where mth is not null order by mth desc 

select * from OutputCityPerformanceByBrand
where audi_des = 'Linyi' and market = 'baraclude' and prod = 600 and Chart='Volume Trend'

go 

select * from OutputCityPerformanceByBrand where prod = 200 and chart = 'Volume Trend' and audi_des = 'Linyi' and region = 'central' and moneytype = 'LC'

select mth00, mth05, * from TempRegionCityDashboard where prod = 200 and audi_des = 'Linyi' and moneytype = 'lc'

select mth00, mth05, * from TempCityDashboard where prod = 200 and audi_des = 'Linyi' and moneytype = 'lc'

select mth00lc, * from mthcity_pkau where audi_cod = 'LNY_'

select mth00lc, * from inmaxdata where city like N'%临沂%'

select * from tblcitymax where audi_cod = 'LNY_'

select abs(-6594.31355183151)

select * from output_stage where linkchartcode = 'd094' and TimeFrame = 'MAT' and currency = 'USD' and geo = 'shanghai'

SELECT * from dbo.inMAXData where City = N'东营'

SELECT * FROM dbo.tblcitymax where City_CN = N'东营'

--update dbo.tblcitymax
--set Audi_Cod = 'DNY_' 
--where City_CN = N'东营'

SELECT * FROM output_stage where LinkChartCode = 'c050'

SELECT * FROM OutputKeyMNCsProdPerformance WHERE [Period]='MAT' and MoneyType='LC'


-- update OutputKeyMNCsProdPerformance
-- set CurrRank=
select B.Rank , *
from OutputKeyMNCsProdPerformance A 
inner join (
	select RANK ( )OVER (order by sum(Mat00LC) desc ) as Rank,a.PROD_cod,sum(Mat00LC) as Mat00LC 
	from dbo.MTHCHPA_PKAU A 
	left join dbo.Dim_Product C on A.Prod_cod = c.Product_code
	where CORP_Cod in(
			select CORP_Cod from OutputKeyMNCsPerformance 
			where Period='MAT' and MoneyType='LC' )
		and c.Product_Name not in ('Albumin human', 'Pulmicort resp')
	group by a.PROD_cod
) B
on A.PROD_cod=B.PROD_cod and A.[Period]='MAT' and MoneyType='LC'

SELECT * FROM dbo.output_stage
WHERE LinkChartCode = 'c020' AND Series = 'MNCs Performance % of China Market'

SELECT * FROM dbo.output_stage WHERE LinkChartCode = 'c130' AND category = 'Value' AND Currency = 'rmb' AND Product = 'monopril'

---------------------------------------------------- check c140 non bal not match 
SELECT * FROM dbo.output_stage 
WHERE LinkChartCode = 'c140'

SELECT * FROM TempCityDashboard_For_OtherETV 

SELECT SUM(mth00) FROM TempCityDashboard_For_OtherETV 
WHERE prod = '000' AND audi_cod IN (SELECT geo FROM outputgeo WHERE ParentGeo = 'central')
	AND Molecule = 'N' AND prod = '000' AND Moneytype = 'un'

SELECT SUM(mth00) FROM TempCityDashboard 
WHERE prod = '000' AND audi_cod IN (SELECT geo FROM outputgeo WHERE ParentGeo = 'central')
	AND Molecule = 'N' AND prod = '000' AND Moneytype = 'un'

SELECT * FROM mthcity_pkau 
	

SELECT * from TempCityDashboard where not (mkt='arv' and productname in ('Other Entecavir','ARV Others'))

SELECT * FROM OutputGeoHBVSummaryT2_For_OtherETV 

SELECT SUM(mth00) FROM TempCityDashboard 
WHERE prod = '000' AND audi_cod IN ('wuhan')
	AND Molecule = 'N' AND prod = '000' AND Moneytype = 'un'

SELECT * FROM TempCityDashboard 
	--from mthcity_pkau A 
	--		inner join tblMktDef_MAX B
	--		on A.pack_cod=B.pack_cod 
	--		where B.Active=''Y'' and A.audi_cod<>''ZJH_'' and b.mkt not like''eliquis%''
	--		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname,A.audi_cod'

	select distinct MoneyType,mkt,Market,Prod,Productname,region
	from dbo.OutputKeyBrandPerformanceByRegion_For_OtherETV 
	where Class='N'
			
	SELECT DISTINCT prod, productname FROM TempRegionCityDashboard_For_OtherETV	
	SELECT DISTINCT prod, productname FROM TempCityDashboard_For_OtherETV		
	SELECT  DISTINCT prod, productname FROM TempCityDashboard 	where not (mkt='arv' and productname in ('Other Entecavir','ARV Others'))		
	SELECT DISTINCT prod, productname, pack_cod FROM tblMktDef_MRBIChina_For_OtherETV

	SELECT DISTINCT prod, productname, Pack_Cod FROM dbo.tblMktDef_MRBIChina WHERE mkt='arv'  and productname IN ('Other Entecavir','ARV Others')

SELECT mth00, * FROM TempRegionCityDashboard_For_OtherETV WHERE prod = '000' AND Moneytype = 'un' AND lev = 'region' AND molecule = 'N'
SELECT * FROM dbo.tblcaption WHERE LinkChartCode = 'd021'
--update tblcaption 
--SET subcaption = REPLACE(subcaption, '#Month', '')
--WHERE LinkChartCode = 'd021'
SELECT * FROM MAXDataNotInIMS 
SELECT * FROM Dim_Product WHERE product_name = 'ENTECAVIR'
SELECT * FROM dbo.Dim_Manufacturer WHERE Manufacturer_Name = 'QIANJINXIANGJIANG'
SELECT * FROM tblMAXProdUpdate 



SELECT * FROM tblMktDef_MAX WHERE prod = '010'
SELECT * FROM TempCityDashboard_For_OtherETV 

SELECT * FROM outputgeo WHERE ParentGeo = 'central'

SELECT  B.Molecule,B.Class,B.mkt,B.mktname,A.audi_cod, SUM(A.MTH00UN)
from mthcity_pkau A 
LEFT join tblMktDef_MAX B ON A.pack_cod=B.pack_cod 
WHERE B.Active='Y' and A.audi_cod<>'ZJH_' AND a.AUDI_COD IN ( SELECT geo FROM outputgeo WHERE ParentGeo = 'central')
group by B.Molecule,B.Class,B.mkt,B.mktname,A.audi_cod

--SELECT b.City, * FROM dbo.MAXRegionCity AS a 
--INNER JOIN dbo.tblcitymax AS b ON a.City = b.City_CN AND b.Geo_Lvl = 2
--WHERE a.Type = 'brand Report'
--SELECT * FROM TempCityDashboard 
--SELECT * FROM dbo.tblcitymax

SELECT a.PACK_COD, b.Pack_Cod, a.PACK_DES, a.PROD_COD FROM dbo.Max_Data AS  a
left join tblMktDef_MAX B on A.pack_cod=B.pack_cod 
WHERE b.Pack_Cod IS NULL 

SELECT * FROM MAXDataNotInIMS 
SELECT [Product Name (Mapping)], Final_Prod, IMS_Prod FROM Max_Data

SELECT MTH00, * FROM TempCityDashboard 
WHERE prod <> '000' AND audi_cod IN ( 'wuhan')
	AND Molecule = 'N' AND Moneytype = 'un'
--GROUP BY Audi_cod

SELECT SUM(mth00) 
--SELECT * 
FROM TempCityDashboard 
WHERE (mkt='arv' and productname in ('Other Entecavir','ARV Others')) 
	AND prod <> '000' AND Moneytype = 'un' AND audi_des = 'beijing' AND Molecule = 'N'

SELECT a.Pack_Cod, a.Pack_Des, b.pack_cod, b.pack_des FROM tblMktDef_MAX a 
inner join tblMktDef_MRBIChina_For_OtherETV B ON A.pack_cod=B.pack_cod 

SELECT * FROM tblMktDef_MAX 



IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'tblMktDef_MRBIChina_For_OtherETV_MAX') AND TYPE ='U')
BEGIN
	DROP TABLE tblMktDef_MRBIChina_For_OtherETV_MAX
END
SELECT distinct Mkt,MktName,
	case 
		when A.Prod_Name like '%HE EN%' then  '601'
		when A.Prod_Name like '%LEI YI DE%' then '602'
		when A.Prod_Name like '%WEI LI QING%' then '603'
		when A.Prod_Name like '%ENTECAVIR%' then '604'
		else '800' end as Prod ,
	case 
		when A.Prod_Name like '%HE EN%' then  'He En'
		when A.Prod_Name like '%LEI YI DE%' then 'Lei Yi De'
		when A.Prod_Name like '%WEI LI QING%' THEN 'Wei Li Qing'
		WHEN A.Prod_Name LIKE '%ENTECAVIR%' then 'Other Entecavir(prod)'
		else 'ARV Others'end  as Productname,
	'N' as Molecule, 'N' as Class,
	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
	pack_cod, Pack_des,Prod_cod,Prod_Name,
	Prod_Name + ' (' +Manu_cod +')' as Prod_FullName,
	'' Mole_cod,'' Mole_Name,
	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
	GetDate() as Date, '201307 add new products & packages' AS Comment
	,1 as Rat
INTO tblMktDef_MRBIChina_For_OtherETV_MAX	
FROM tblMktDef_MAX A 
WHERE A.MKT = 'ARV' AND A.prod = '700'
and NOT EXISTS(
	SELECT * FROM tblMktDef_MRBIChina B 
	WHERE B.MKT = 'ARV' AND B.Class='N' and molecule='N' and PROD between '100' and '500'
		AND A.PACK_COD = B.PACK_COD and a.atc3_cod=b.atc3_cod
)

insert into tblMktDef_MRBIChina_For_OtherETV_MAX
select * from tblMktDef_MAX where mkt='arv' and prod='800'
GO

select DISTINCT prod, productname, package from TempCityDashboard 
WHERE (mkt='arv' and productname in ('Other Entecavir','ARV Others'))



SELECT b.city,(sum([201612 Dosage Unit])) AS YTDUSD 
FROM db81.QABMSChina.[dbo].[in_Baraclude_new_data] a
INNER JOIN db81.QABMSChina.dbo.maxcity b ON source = 'Dashboard' AND a.city=b.city
group by b.city

SELECT * FROM db81.QABMSChina.dbo.maxcity

--1407286
--989469.31715042

--90978.8035442889
--62473.774975497

SELECT DISTINCT AUDI_COD FROM dbo.MTHCITY_PKAU 
SELECT mth00un, * FROM dbo.MTHCITY_PKAU WHERE audi_cod = 'Linyi'
---------------------------------------------------------------------------c140

SELECT * FROM OutputKeyBrandPerformanceByRegion_For_OtherETV WHERE Moneytype = 'lc' AND lev = 'region' AND Productname = 'baraclude'
SELECT mth00, * FROM OutputGeoHBVSummaryT2_For_OtherETV WHERE Moneytype = 'lc' AND lev = 'region'
SELECT mth00, * FROM TempRegionCityDashboard_For_OtherETV WHERE Moneytype = 'un' AND lev = 'region' AND Productname = 'baraclude'

SELECT SUM(mth00) FROM TempCityDashboard_For_OtherETV WHERE Moneytype = 'un'  AND Productname = 'baraclude'
and audi_des IN (
'Dongying',
'Linyi',
'Wuhan',
'Jinan',
'Zhengzhou')

SELECT * FROM TempCityDashboard_For_OtherETV WHERE lev = 'nation'


SELECT * FROM TempCityDashboard_For_OtherETV WHERE Moneytype = 'un'  AND Productname = 'baraclude'

SELECT * FROM dbo.tblcitymax 

SELECT * FROM TempCityDashboard where not (mkt='arv' and productname in ('Other Entecavir','ARV Others')) 
SELECT DISTINCT Audi_des FROM TempCityDashboard where not (mkt='arv' and productname in ('Other Entecavir','ARV Others')) 

SELECT * from 

SELECT distinct * FROM TempCityDashboard ORDER BY R3M00 DESC 

SELECT SUM(mth00), b.ParentGeo
FROM (
	SELECT COUNT(*)
	from mthcity_pkau A 
	--inner join tblMktDef_MRBIChina B
	--on A.pack_cod=B.pack_cod where B.Active='Y' and A.audi_cod <> 'ZJH_' and b.mkt not like 'eliquis%'
	group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname,a.audi_cod
) AS a 
INNER JOIN (
	SELECT geoname, geo, ParentGeo FROM dbo.outputgeo 
) AS b ON a.Audi_des = b.geo
WHERE a.Moneytype = 'un' and not (mkt='arv' and productname in ('Other Entecavir','ARV Others')) 
GROUP BY b.ParentGeo

SELECT a.PACK_COD, b.* 
from mthcity_pkau A 
inner join 
(	SELECT DISTINCT  * from tblMktDef_MRBIChina b
)B
on A.pack_cod=B.pack_cod AND a.PROD_COD = b.prod_Cod 
WHERE B.Active='Y' and A.audi_cod <> 'ZJH_' and b.mkt not like 'eliquis%'

SELECT DISTINCT Mkt, MktName,  Molecule, Class, ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des,
	   Prod_Cod, Prod_Name, Prod_FullName, Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD, Active, 
	   rat FROM tblMktDef_MRBIChina WHERE  PACK_COD = '1232002'

SELECT DISTINCT Mkt, MktName, Molecule, Class, ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des,
	   Prod_Cod, Prod_Name, Prod_FullName, Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD, Active, Date, Comment,
	   rat 
FROM tblMktDef_MRBIChina 

SELECT * FROM dbo.MTHCITY_PKAU WHERE PACK_COD = '1232002' and audi_cod IS NOT NULL AND audi_cod <> ''

SELECT distinct  FROM tblMktDef_MRBIChina


SELECT * FROM mthcity_pkau 

SELECT SUM(a.mth00UN), b.ParentGeo FROM (
	SELECT SUM(MTH00UN) AS mth00UN, a.AUDI_COD , b.City
	FROM dbo.MTHCITY_PKAU AS a 
	LEFT JOIN dbo.tblcitymax AS b ON a.AUDI_COD = b.Audi_Cod
	WHERE a.audi_cod IS NOT NULL AND a.AUDI_COD <> '' 
	GROUP BY a.AUDI_COD, b.City
) AS a 
INNER JOIN (
	SELECT geoname, geo, ParentGeo FROM dbo.outputgeo 
) AS b ON a.City = b.geo
GROUP BY b.ParentGeo

SELECT * FROM dbo.tblcitymax 
SELECT * FROM dbo.MAXRegionCity WHERE Region = 'central'
SELECT geoname, geo, ParentGeo FROM dbo.outputgeo WHERE ParentGeo = 'central'


SELECT SUM(mth00) FROM (SELECT DISTINCT * FROM TempCityDashboard_For_OtherETV ) AS  a
WHERE Market = 'baraclude' AND Moneytype = 'un' AND audi_des IN (
'Dongying',
'Linyi',
'Wuhan', 'Jinan', 'Zhengzhou') AND a.Molecule = 'Y' AND a.Class = 'N'

SELECT DISTINCT * FROM TempCityDashboard order BY R3M00
SELECT * FROM TempCityDashboard order BY R3M00

SELECT * FROM dbo.tblMktDef_MRBIChina

SELECT distinct B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname, b.Pack_Cod, b.Mole_Cod FROM dbo.tblMktDef_MRBIChina b
SELECT distinct b.Pack_Cod, b.Mole_Cod FROM dbo.tblMktDef_MRBIChina b

SELECT * FROM TempCityDashboard_For_OtherETV 

SELECT * FROM dbo.output_stage WHERE LinkChartCode = 'd091' AND geo = 'wuhan'  AND TimeFrame = 'mat' AND Category = 'value' AND Currency = 'usd'

SELECT * FROM dbo.output_stage WHERE LinkChartCode = 'c210'

SELECT * FROM OutputCityPerformanceByBrand WHERE  Audi_des = 'wuhan'  AND Moneytype = 'lc' AND Chart = 'Volume Trend'

SELECT * FROM TempRegionCityDashboard WHERE  Audi_des = 'wuhan'  AND Moneytype = 'lc'
SELECT * FROM TempCityDashboard  WHERE  Audi_des = 'wuhan'  AND Moneytype = 'lc'

SELECT mat48lc, * FROM mthcity_pkau WHERE  AUDI_COD = 'YZW_' 

SELECT mat37lc, mat26us, MTH49LC, * FROM dbo.inMAXData WHERE City = N'武汉'

SELECT [201212 Value（RMB）],* FROM dbo.Max_Data WHERE City = N'武汉市'

SELECT * FROM output_stage WHERE LinkChartCode = 'c130' AND Product = 'sprycel' AND Currency = 'RMB' AND x = '2016Q4'

SELECT * FROM OutputCMLChina_HKAPI 

SELECT * FROM dbo.WebChartTitle WHERE LinkChartCode = 'c220'

SELECT * FROM dbo.tblMonthList

SELECT * FROM OutputHospital_All WHERE LinkChartCode = 'c202'

SELECT * FROM tempHospitalRollupByTier 

select * from OutputKeyMNCsProdPerformance_HKAPI 

select * from inHKAPI_New 

select * from Dim_Product

select * from OutputCMLChinaMarketTrend 

SELECT * FROM dbo.output_stage WHERE LinkChartCode = 'd081' AND geo = 'dongying' AND IsShow = 'Y'

SELECT * FROM dbo.WebChartTitle WHERE LinkChartCode = 'D110' AND geo = 'dongying' 

SELECT * FROM OutputKeyMNCsProdPerformance_HKAPI 

select distinct case Chart when 'Volume Trend' then 'Y' else 'N' end as isshow,
			Region,Audi_des,MoneyType,market,Productname,Prod 
		from dbo.OutputCityPerformanceByBrand_For_OtherETV 
		where Chart in('Volume Trend','CAGR') and Class='N' and molecule='N' 
			and Mkt not in ('DPP4','Eliquis NOAC','Eliquis VTet')
			and not (mkt = 'Eliquis VTep' and Prod = '600'  )
			AND Audi_des = 'Dongying'

SELECT * FROM OutputCityPerformanceByBrand_For_OtherETV 

SELECT * FROM dbo.output_stage WHERE LinkChartCode = 'd084' AND geo = 'dongying'

SELECT DISTINCT LinkChartCode,LinkProductId,LinkGeoId,Category,TimeFrame,CategoryIdx,TimeFrameIdx FROM WebChartTitle 
WHERE LinkChartCode = 'D110'

SELECT * FROM dbo.WebChartTitle WHERE LinkChartCode = 'd081'

SELECT * FROM dbo.outputgeo

--INSERT INTO dbo.outputgeo ( Geo, GeoName, Lev, Product, ParentGeo, GeoIdx, ParentID, ProductID )
--SELECT 'BAL', 'BAL', 1, 'Baraclude', 'China', 39, 1, 1 

SELECT * FROM dbo.output_stage WHERE LinkChartCode = 'c140'

SELECT * FROM OutputKeyBrandPerformanceByRegion_For_OtherETV

SELECT * FROM dbo.output_stage
WHERE LinkChartCode = 'c210' AND TimeFrame = 'YTD' AND series = 'glivec'

SELECT * FROM OutputCMLChina_HKAPI 
SELECT * FROM inHKAPI_New 

select 'Sprycel','YTD',[Product Name] as Product,1,'RMB' as Moneytype,
	SUM(YTD36LC)*1000 as YTD36 
from BMSChinaOtherDB.dbo.inHKAPI_New 
where [Product Name] like '%spycel%' or  [Product Name] in(select distinct Prod_name from tblMktDef_MRBIChina where mkt='CML')
group by [Product Name]

--48290.6906241731 

SELECT ytd36lC, [Product Name], [YTD 13Q4LC], [13Q3LC], [13Q2LC], [13Q1LC], [14Q1LC], * 
FROM inHKAPI_New 
where [Product Name] like '%spycel%' or  [Product Name] in(select distinct Prod_name from tblMktDef_MRBIChina where mkt='CML')

SELECT [Product Name], [YTD 13Q4LC]
from BMSChinaOtherDB.dbo.inHKAPI_Linda 
where [Product Name] like '%spycel%' or  [Product Name] in(select distinct Prod_name from tblMktDef_MRBIChina where mkt='CML')


SELECT [Product Name], [YTD 13Q4LC]
from inHKAPI_New 
where [Product Name] like '%spycel%' or  [Product Name] in(select distinct Prod_name from tblMktDef_MRBIChina where mkt='CML')


SELECT * FROM dbo.output_stage WHERE LinkChartCode = 'C140'
	AND  product IN ('Taxol', 'Monopril')


SELECT MAT00, prod, * FROM TempRegionCityDashboard 
WHERE Moneytype = 'un' AND audi_des = 'dongying'  
	AND mkt = 'arv' AND prod = '000'

SELECT * FROM TempRegionCityDashboard 
WHERE Moneytype = 'un' AND audi_des = 'dongying'  

SELECT mat00,* FROM TempCityDashboard 
WHERE Moneytype = 'un' AND audi_des = 'dongying'  
	AND mkt = 'arv' AND prod = '000'

SELECT SUM(YTD00) FROM TempCityDashboard 
WHERE Moneytype = 'un' AND prod = '000' AND Audi_cod IN ('wuhan', 'jinan', 'linyi', 'dongying', 'zhengzhou')
	AND molecule = 'Y'

SELECT SUM(YTD01UN) FROM mthcity_pkau 
WHERE Audi_cod IN ('wuhan', 'jinan', 'linyi', 'dongying', 'zhengzhou')

SELECT * FROM dbo.inMAXData
WHERE city IN (N'武汉', N'济南', N'临沂', N'东营', N'郑州')

SELECT 
	SUM([201601 Dosage Unit] + [201602 Dosage Unit] + [201603 Dosage Unit] + [201604 Dosage Unit] + [201605 Dosage Unit] + [201606 Dosage Unit] + 
	[201607 Dosage Unit] + [201608 Dosage Unit] + [201609 Dosage Unit] + [201610 Dosage Unit] + [201611 Dosage Unit] + [201612 Dosage Unit] )
FROM BMSChinaCIARawdata.dbo.Max_201612
WHERE city IN (N'武汉市', N'济南市', N'临沂市', N'东营市', N'郑州市')


SELECT * 
FROM dbo.Max_Data 
WHERE city IN (N'青岛市')

SELECT * FROM dbo.maxcity

SELECT * FROM dbo.Dim_Product WHERE Product_Name = 'Gefitinib'


SELECT * FROM Dim_City 


SELECT * FROM dbo.MAXRegionCity

--SELECT  * FROM CMHrawdata_baraclude WHERE YM = '201701'
--SELECT TOP 100 * FROM tempRetail


--INSERT INTO dbo.CMHrawdata_baraclude ( YM, 数据范围,  产品ID, 中西药, 处方性质, 分类1, 分类2, 品牌, Molecule, 剂型,
-- 										Product, 品名, 厂家, 规格, 片, 城市数字铺货率, 城市加权铺货率,  单价, Value, [放大销售量（盒）], Volume )
--SELECT YM, 地区, 产品ID, ZX, OTC_Rx, SORT1, SORT2, 品牌, Molecule, JX, Product, PM,  CJ, GG, 片, 数字铺货率, 加权铺货率,    平均单价, Value,
--		[销售量（盒）], Volume  
--FROM tempRetail



SELECT * 
from mthcity_pkau A 
inner join tblMktDef_MRBIChina B
on A.pack_cod=B.pack_cod 
WHERE B.Active='Y' and A.audi_cod<>'ZJH_' and b.mkt not like'eliquis%'
	and a.audi_cod = 'dongying'
--group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname,A.audi_cod

SELECT DISTINCT ProductName FROM tblMktDef_MRBIChina WHERE mkt = 'arv' AND Molecule = 'N'

SELECT * FROM OutputKeyBrandPerformanceByRegion_For_OtherETV WHERE mkt = 'arv' AND Molecule = 'N'

SELECT  DISTINCT mkt, prod, Productname FROM TempCityDashboard_For_OtherETV WHERE mkt = 'arv' AND Molecule = 'N'

SELECT DISTINCT mkt, prod, Productname FROM TempCityDashboard WHERE mkt = 'arv' AND Molecule = 'N'

SELECT DISTINCT  mkt, prod, Productname FROM tblMktDef_MRBIChina_For_OtherETV WHERE mkt = 'arv' AND Molecule = 'N'

SELECT * FROM OutputCMLChina_HKAPI WHERE Moneytype = 'usd'

select distinct X , TimeFrame from dbo.[output_stage] where LinkChartCode= 'c220'
select * from dbo.[output_stage] where LinkChartCode= 'c220'

select distinct 
	a.ATC1_Cod, a.ATC1_Des,
	a.ATC2_Cod, a.ATC2_Des,
	a.ATC3_Cod, a.ATC3_Des,
	a.ATC4_Cod, a.ATC4_Des,
	a.Mole_cod, a.Mole_des,
	a.Prod_cod, a.Prod_Des,
	a.Pack_Cod, a.Pack_Des,
	a.Corp_cod, a.Corp_Des,
	a.manu_cod, a.Manu_des,
	a.MNC, a.Gene_Cod
from Max_Data as a 
left join tblMktDef_ATCDriver as b on a.pack_cod = b.Pack_Cod
where b.Pack_Cod is null 

SELECT * FROM Max_Data 
SELECT * FROM tblMktDef_ATCDriver 


 SELECT * FROM OutputKeyMNCsProdPerformance_HKAPI 

 select  'YTD','RMB', [Product name],1,1,sum(isnull([YTD00LC],0))*1000,sum(isnull([YTD12LC],0))*1000
from inHKAPI_New A 
--left join dbo.Dim_Product C on A.[Product name] = c.Product_Name 
where [Company name] in (select CORP_Cod from OutputKeyMNCsPerformance_HKAPI where Period='YTD')
    and [Product name] not in ('Albumin human', 'Pulmicort resp')
group by [Product name]
order by sum(isnull([YTD00LC],0)) DESC

SELECT * FROM dbo.inHKAPI_New
WHERE [Product Name] LIKE '%ADALAT%'

SELECT * FROM Dim_Product 
WHERE Product_Name LIKE '%ADALAT%' 

SELECT * FROM Dim_Product 
WHERE Product_Name = 'Albumin human'

SELECT mth00un, MTH01UN, * FROM dbo.MTHCHPA_PKAU WHERE PACK_ID = '100215'
SELECT mth00un, mth01un, * FROM BMSChinaCIA_IMS.dbo.MTHCHPA_PKAU WHERE PACK_ID = '100215'

SELECT [Value] from Config where Parameter = 'IMS'

SELECT * FROM OutputKeyMNCsProdPerformance_HKAPI 
SELECT * FROM inHKAPI_New WHERE [Product Name] LIKE '%Pulmicort%'

SELECT value FROM dbo.Config WHERE Parameter = 'HKAPI'
SELECT MonSeq FROM dbo.tblMonthList WHERE Date = (SELECT value FROM dbo.Config WHERE Parameter = 'HKAPI')

SELECT * FROM OutputCMLChina_HKAPI 
SELECT [16Q4US], YTD00US, MAT00US, * FROM inHKAPI_New 

SELECT * FROM OutputKeyMNCsProdPerformance_HKAPI

SELECT * FROM dbo.output_stage WHERE LinkChartCode = 'c220'
SELECT * FROM dbo.WebChartTitle WHERE LinkChartCode = 'c220'
SELECT * FROM dbo.WebChartSeries WHERE LinkChartCode = 'c220'

SELECT * FROM output_stage WHERE geo = 'east I' OR ParentGeo = 'east I'

SELECT * FROM db82.BMSChina_ppt.dbo.tblColorDef WHERE name = 'viread'

--INSERT INTO db82.BMSChina_ppt.dbo.tblColorDef 
--SELECT 'Prod', Abvgeo, Name, R, G, B, ColorName, RGB FROM db82.BMSChina_ppt.dbo.tblColorDef 
--WHERE name = 'viread'

SELECT * FROM OutputKeyMNCsPerformance_HKAPI 
SELECT * FROM output_stage WHERE LinkChartCode = 'c100' AND TimeFrame = 'MQT'
SELECT * FROM tblDateHKAPI 

SELECT * FROM dbo.output WHERE DataSource IS  null

SELECT * FROM KPI_Frame_MarketAnalyzer_IMSAudit_CHPA WHERE Sveries = 'glucophage'

select Series,X,Series_Idx,X_Idx,Y from KPI_Frame_MarketAnalyzer_XareltoValue_For_Eliquis where market='Eliquis' order by Series_Idx,X_Idx
select Category,Series,X,Series_Idx,Category_Idx,X_Idx,Y from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA where lev='Nation' and market='Glucophage' and DataType='Share' order by Category_Idx,Series_Idx,X_Idx

SELECT * FROM mthCHPA_pkau 
SELECT * FROM KPI_Frame_MarketAnalyzer_XareltoValue_For_Eliquis 

SELECT * FROM tblMktDef_MRBIChina_All WHERE ProductName LIKE '%glucophage%'

SELECT * FROM CMHrawdata_baraclude 
WHERE ym = '201612'

SELECT * FROM dbo.output_stage 
WHERE LinkChartCode = 'c020' AND TimeFrame = 'mth' AND currency = 'usd' AND 

SELECT * FROM dbo.output_stage WHERE LinkChartCode = 'd021'

SELECT * FROM OutputGeoHBVSummaryT1 

<<<<<<< HEAD
SELECT * FROM TempRegionCityDashboard 

SELECT * FROM TempCityDashboard WHERE moneytype <> 'pn'

SELECT * FROM mthcity_pkau WHERE AUDI_COD = 'Foshan'

SELECT * 
from mthcity_pkau A 
inner join tblMktDef_MAX B
on A.pack_cod=B.pack_cod 
where B.Active='Y' and A.audi_cod<>'ZJH_' and b.mkt not like'eliquis%'
=======
SELECT * FROM dbo.tblMktDef_MRBIChina
SELECT * FROM dbo.tblMktDef_MAX

SELECT * INTO Max_Data_20170404 FROM Max_Data
SELECT *  FROM Max_Data

--update a 
--set a.Pack_Cod = b.Pack_Cod,
--	a.Pack_Des = b.Pack_Des
--FROM dbo.Max_Data AS a
--INNER join (
--	SELECT distinct ATC1_COD, ATC2_COD,
--           ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_Name,
--           Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD FROM dbo.tblMktDef_MAX ) AS b 
--ON a.ATC1_COD = b.ATC1_COD
--	AND a.ATC2_COD = b.ATC2_COD
--	AND a.ATC3_COD = b.ATC3_COD
--	AND a.ATC4_COD = b.ATC4_COD
--	AND a.Prod_Cod = b.Prod_Cod
--	AND a.Corp_COD = b.Corp_COD
--	AND a.Manu_COD = b.Manu_COD
--	AND a.Gene_COD = b.Gene_COD
--	AND a.Mole_cod = b.Mole_Cod
--	AND a.Prod_Des + ' ' + a.[剂型（标准_英文）] + ' ' + a.[药品规格（标准_英文）]  = b.Pack_Des


SELECT  COUNT(*) FROM Max_Data AS a
WHERE a.ATC4_Cod = 'J05B1'

--INSERT INTO dbo.tblMktDef_MAX ( Mkt, MktName, Prod, ProductName, Molecule,
--                                 Class, ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD,
--                                 Pack_Cod, Pack_Des, Prod_Cod, Prod_Name,
--                                 Prod_FullName, Mole_Cod, Mole_Name, Corp_COD,
--                                 Manu_COD, Gene_COD, Active, Date, Comment,
--                                 rat )
--SELECT DISTINCT Mkt, MktName, Prod, ProductName, Molecule, Class, ATC1_COD, ATC2_COD,
--       ATC3_COD, ATC4_COD, NULL, NULL, Prod_Cod, Prod_Name,
--       Prod_FullName, Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD,
--       Active, Date, Comment, rat 
--FROM tblMktDef_MRBIChina 
--WHERE Mkt = 'arv'
-->>>>>>> a08fb735f5d0bce52fe0d7a9f15ba398261ccb2d

SELECT * FROM tblMktDef_MAX 

SELECT * FROM KPI_Frame_MAX_Region_Baraclude 

--<<<<<<< HEAD
--=======
--INSERT INTO dbo.tblMktDef_MAX ( Mkt, MktName, Prod, ProductName, Molecule,
--                                 Class, ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD,
--                                 Pack_Cod, Pack_Des, Prod_Cod, Prod_Name,
--                                 Prod_FullName, Mole_Cod, Mole_Name, Corp_COD,
--                                 Manu_COD, Gene_COD, Active, Date, Comment,
--                                 rat )
--SELECT a.Mkt, a.MktName, a.Prod, a.ProductName, a.Molecule, a.Class,
--       a.ATC1_COD, a.ATC2_COD, a.ATC3_COD, a.ATC4_COD, b.Pack_Cod, b.Pack_Des,
--       a.Prod_Cod, a.Prod_Name, a.Prod_FullName, b.Mole_Cod, b.Mole_Name,
--       a.Corp_COD, a.Manu_COD, a.Gene_COD, a.Active, a.Date, a.Comment, a.rat
--FROM (
--	SELECT DISTINCT Mkt, MktName, Prod, ProductName, Molecule, Class, ATC1_COD, ATC2_COD,
--       ATC3_COD, ATC4_COD, NULL AS Pack_Cod, NULL AS Pack_Des, Prod_Cod, Prod_Name,
--       Prod_FullName, Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD,
--       Active, Date, Comment, rat 
--	FROM tblMktDef_MRBIChina 
--	WHERE Mkt = 'arv'
--) AS a 
--RIGHT JOIN dbo.tblMktDef_MAX_temp AS b 
--ON a.ATC1_COD = b.ATC1_COD
--	AND a.ATC2_COD = b.ATC2_COD
--	AND a.ATC3_COD = b.ATC3_COD
--	AND a.ATC4_COD = b.ATC4_COD
--	AND a.Prod_Cod = b.Prod_Cod
--	AND a.Corp_COD = b.Corp_COD
--	AND a.Manu_COD = b.Manu_COD
--	AND a.Gene_COD = b.Gene_COD

	
-- SELECT * FROM dbo.tblMktDef_MAX		

SELECT * FROM tblMktDef_MRBIChina_For_OtherETV

SELECT *  
from mthcity_pkau A 
inner join tblMktDef_MAX B
on A.pack_cod=B.pack_cod 
where B.Active='Y' and A.audi_cod<>'ZJH_' and b.mkt not like'eliquis%'

SELECT * FROM tblMktDef_MAX 

SELECT * FROM dbo.output_stage
WHERE LinkChartCode = 'c020' AND Currency = 'RMB' AND TimeFrame = 'mth'

SELECT * FROM [OurputKey10TAVSTotalMkt] 
SELECT * FROM tblcaption WHERE LinkChartCode = 'd021'

--UPDATE dbo.tblcaption
--SET SubCaption = REPLACE(SubCaption, 'MAT' , '#TimeFrame')
--WHERE LinkChartCode = 'd021'



SELECT * FROM dbo.OutputHospital WHERE LinkChartCode = 'c170'

SELECT * FROM KPI_Frame_MAX_Region_Baraclude

	SELECT series, 
		(BaracludeMth00/Mth00 - BaracludeMth01/Mth01) as 'Baraclude Month Share Change vs. Last Mth',
		BaracludeMth00, Mth00  ,BaracludeMth01, Mth01
	from temp_KPI_Frame_MAX_Region_BAL 

SELECT b.YTD
from temp_KPI_Frame_MAX_Region_BAL as a 
inner join (
    select RMName as Series, sum(Value) as YTD 
    from temp_BAL_CPAData as a
    inner join (
        select distinct prod_Des_EN,Prod_Des_CN  from BMSChinaMRBI.dbo.tblMktDefHospital  where Mkt = 'Arv' 
    ) as b on a.Product = b.Prod_Des_CN
    inner join (
        select distinct prod_Des
        from tblMktDef_Inline_MAX 
    ) as c on b.prod_Des_EN = c.prod_Des 
    where  M = 12 and Y = 2016
        and c.Prod_Des = 'Baraclude'
    group by RMName 
) as b on a.Series = b.Series 

select Month from tblMonthList where MonSeq = 2 

SELECT * FROM dbo.tblcaption WHERE LinkChartCode = 'd021'

----UPDATE dbo.tblcaption
----SET SubCaption = REPLACE(SubCaption, 'MQT', '#TimeFrame')
----WHERE LinkChartCode = 'd021'

select * from KPI_Frame_MNC_Brand_Ranking_data  where product_name like '%GLUCOPHAGE%' and period='YTD'

	SELECT 'YTD',1,1,'06470',b.product_name, sum(YTD00US),sum(YTD12US)
	from dbo.MTHCHPA_PKAU A 
	inner join dim_product b on A.Prod_cod=B.Product_code
	where product_name like '%GLUCOPHAGE%'
	group by b.product_name

	--update a
	--set PrevRank=B.Rank 
	--from KPI_Frame_MNC_Brand_Ranking_data A 
	--inner join (
	--	SELECT RANK () OVER (ORDER by sum(MTH00US) desc ) as Rank, a.Prod_cod,b.product_name
	--	from MTHCHPA_PKAU  a
	--	inner join dim_product b on A.Prod_cod=B.product_code
	--	where exists(
	--			select * from MTHCHPA_PKAU B  
	--			where A.PROD_COD=B.PROD_COD and B.MNFL_COD IN ('I','J')
	--			) 
	--		and b.product_name not in ('PULMICORT RESP','ALBUMIN HUMAN')
	--	group by a.Prod_cod,b.product_name
	--) B
	--on A.PROD_COD=B.PROD_COD   and A.[Period]='YTD' 
	--where product_name like '%GLUCOPHAGE%' 

	SELECT * FROM MAXData_Rollup_Region_MAXMkt_Mid 
	SELECT * FROM KPI_Frame_MAX_Region_Baraclude 
	SELECT * FROM KPI_Frame_MAX_Region_BAL 

	select RMName as Series, c.mkt as X , sum(Value) as Y, null as Series_Idx, null as X_Idx 
	from temp_BAL_CPAData as a
	inner join (
			select distinct prod_Des_EN,Prod_Des_CN  from BMSChinaMRBI.dbo.tblMktDefHospital where Mkt = 'Arv' 
		) as b on a.Product = b.Prod_Des_CN
	inner join ( 
			select distinct prod_Des, mkt
			from tblMktDef_Inline_MAX 
		) as c on b.prod_Des_EN = c.prod_Des 
	where Y >= 2017 and M >= 1
	group by RMName , c.Mkt

	SELECT * FROM KPI_Frame_MAX_Region_BAL_Mid 
	SELECT * FROM KPI_Frame_MAX_Region_BAL
	
SELECT a.Y / b.Y , *
from KPI_Frame_MAX_Region_BAL as a 
inner join KPI_Frame_MAX_Region_BAL_Mid as b on a.Series = b.Series 


select RMName as Series, sum(Value) as YTD , SUM(volume) AS YTD2
--into temp_KPI_Frame_MAX_Region_BAL
from temp_BAL_CPAData as a
inner join (
    select distinct prod_Des_EN,Prod_Des_CN  from BMSChinaMRBI.dbo.tblMktDefHospital  where Mkt = 'Arv' 
) as b on a.Product = b.Prod_Des_CN
left join (
    select distinct prod_Des
	from tblMktDef_Inline_MAX 
) as c on b.prod_Des_EN = c.prod_Des 
where Y >= 2017 and M >= 1
group by RMName 

select distinct Prod_Cod, Prod_Des from tblQueryToolDriverIMS



	SELECT RMName as Series, sum(Value) as YTD , SUM(volume) AS YTD2
    from temp_BAL_CPAData as a
    inner join (
        select distinct prod_Des_EN,Prod_Des_CN  from BMSChinaMRBI.dbo.tblMktDefHospital  where Mkt = 'Arv' 
    ) as b on a.Product = b.Prod_Des_CN
    left join (
        select distinct prod_Des
        from tblMktDef_Inline_MAX 
    ) as c on b.prod_Des_EN = c.prod_Des 
    where Y >= 2016 and M >= 1 and Y < 2017 AND M <=1
    group by RMName 


SELECT * FROM temp_BAL_CPAData 
SELECT * FROM KPI_Frame_MAX_Region_BAL 

SELECT * FROM temp_BAL_CPAData 

SELECT DISTINCT Product FROM temp_BAL_CPAData 
WHERE RMName = 'VIR BAM II' AND y = 2016 AND m = 1 AND ATC_Code LIKE '%J05AF%'
EXCEPT
SELECT distinct Prod_Des_CN
FROM BMSChinaMRBI.dbo.tblMktDefHospital where Mkt = 'Arv' 

SELECT * FROM tblMktDef_Inline_MAX WHERE Prod_Des = 'Yi Lai Feng'

SELECT * FROM BMSChinaMRBI_Repository.dbo.tblMktDefHospital_201610	WHERE prod_des_cn = N'益平维'
SELECT * FROM BMSChinaMRBI_Repository.dbo.tblMktDefHospital_201612	WHERE mkt = 'arv'
SELECT * FROM BMSChinaMRBI.dbo.tblMktDefHospital					WHERE mkt = 'arv'
SELECT * FROM BMSChinaMRBI.dbo.tblMktDefHospital					WHERE Mole_Des_CN = N'拉米夫定' AND mkt = 'arv'

SELECT * FROM tblDefProduct_CN_EN WHERE Prod_CN = N'益平维'
SELECT * FROM inCPAData WHERE Product = N'益平维'

SELECT * FROM tblDefMolecule_CN_EN WHERE Mole_CN = N'拉米夫定'
 
select distinct Product from inCPAData 
where 
	Product not in (select Prod_CN from dbo.tblDefProduct_CN_EN) and 
	Molecule in (select Mole_CN from tblDefMolecule_CN_EN)
	AND Molecule = N'拉米夫定'


--UPDATE tblMktDefHospital
--SET Mkt = 'arv', mktname = ''
--WHERE Market = 'ARV Market'

SELECT * FROM tblCMDData_baraclude 
WHERE x IN ('YTD Growth', 'MTH Growth') AND category = 'value' AND period_type = 'ytd' AND producttype = 'product'

select Category,Series,X,Series_Idx,Category_Idx,X_Idx,Y from tblCMDData_baraclude where DataType='Share' order by Category_Idx ,Series_Idx,X_Idx DESC

--select Category,Series,X,Series_Idx,Category_Idx,X_Idx,Y,

SELECT period_type, producttype, datatype, molecule, product, category, y, X, DM, series, series_idx, x_idx,
	   category_idx from tblCMDData_baraclude where DataType='Growth' AND x = 'mth growth' AND category = 'value'
ORDER by Category_Idx ,Series_Idx,X_Idx DESC


	
select a.period_type,a.producttype,'Growth' as datatype,a.molecule,a.product,a.category, case when b.y is null or b.y=0 then 0 else (a.y-b.y)/b.y end as y,a.period_type+' Growth' as x,a.DM
 from tblCMDData_baraclude a
left join tblCMDData_baraclude b
on a.datatype=b.datatype and a.period_type=b.period_type and a.producttype=b.producttype and right(a.DM,2)+12=right(b.DM,2) and a.category=b.category and a.molecule=b.molecule and a.product=b.product
where a.datatype='sales'

SELECT * FROM BMSChinaMRBI_Repository.dbo.tblMktDefHospital_201612
SELECT * FROM  tblDSDates where Item = 'CPA' 

--INSERT INTO dbo.tblMktDefHospital ( Mkt, MktName, Prod, ProductName, Molecule, Class, ATC3_Cod, ATC_CPA, Mole_Des_CN,
--									 Mole_Des_EN, Prod_Des_CN, Prod_Des_EN, FocusedBrand, IMSMoleCode, IMSProdCode,
--									 Product, rat )
--SELECT Mkt, MktName, Prod, ProductName, Molecule, Class, ATC3_Cod, ATC_CPA, Mole_Des_CN, Mole_Des_EN, Prod_Des_CN,
--	   Prod_Des_EN, FocusedBrand, IMSMoleCode, IMSProdCode, Product, 1 FROM BMSChinaMRBI_Repository.dbo.tblMktDefHospital_201612
--WHERE prod_des_cn LIKE N'%韦瑞德%'


----------------------

SELECT Audi_cod FROM OutputPreCityPerformance 

SELECT * FROM output_stage WHERE LinkChartCode = 'c120'
SELECT * FROM output 

SELECT * FROM OutputKeyBrandPerformanceByRegionGrowth 

SELECT * FROM BMS_CPA_Hosp_Category 

SELECT * FROM dbo.tblDSDates

SELECT * FROM output_stage WHERE LinkChartCode = 'd020'

SELECT * FROM dbo.MTHCHPA_PKAU 
SELECT * FROM db82.TempOutput.dbo.MTHCHPA_PKAU

