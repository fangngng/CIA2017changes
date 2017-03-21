/*
Created on 12/22/2011

creates Hospital TA Output pipeline table 
after CPA Quarterly pipeline data is loaded into tblHospitalDataCT_Pipeline

Refresh tblQueryToolDriverHosp_Pipeline with the latest market definitions

*/

use BMSCNProc2_test
go

exec dbo.sp_Log_Event 'Process','QT_CPA_Inline','Step_3_Create_Hosp_TA_Output_Master_Table.sql','Start',null,null


drop table tblQueryToolDriverHosp_Pipeline_Prod
go
select distinct 
	MktType, Mkt, MktName, Class, Prod_Des, Prod_Cod, Pack_Des, Pack_Cod, Manu_Des, Manu_Cod, MNC 
into tblQueryToolDriverHosp_Pipeline_Prod 
from tblQueryToolDriverHosp_Pipeline
go
drop table tblProdMoleCode_HSPipeline
go


select distinct 
	Prod_Cod, Mole_Des, Mole_Cod, 'N' as Uniq_Prod 
into tblProdMoleCode_HSPipeline 
from tblQueryToolDriverHosp_Pipeline
go


drop table tblProdMoleUnique
go
select Prod_Cod, max(mole_Cod) as Mole_Cod into tblProdMoleUnique 
from tblProdMoleCode_HSPipeline group by Prod_Cod
go
Update t1 set t1.Uniq_Prod='Y' 
from tblProdMoleCode_HSPipeline t1 
inner join tblProdMoleUnique t2 
on t1.Mole_Cod=t2.Mole_cod and t1.Prod_Cod=t2.Prod_cod
go




Print('------------------------------------------------
					tblOutput_Hosp_TA_Master_Pipeline_Staging
------------------------------------------------------')
truncate table tblOutput_Hosp_TA_Master_Pipeline_Staging
go

--Append Molecule/Package level data:
Insert into tblOutput_Hosp_TA_Master_Pipeline_Staging
select 
    DataType, MktType, Mkt, MktName
    , City_EN as Geo, '2' as Geo_Lvl, 'H' as Grp_Lvl, Hosp_ID, Hosp_Des_EN, Tier
    , Class
    , 'PK' as Prod_Lvl,'N'
    , Mole_Des, Mole_Cod
    , Prod_Des, Prod_Cod
    , Pack_Des, t1.Pack_Cod
    ,  Manu_Des, Manu_Cod, MNC, 
    M24, M23, M22, M21, M20, M19, M18, M17, M16, M15, M14, M13, 
    M12, M11, M10, M09, M08, M07, M06, M05, M04, M03, M02, M01
from tblQueryToolDriverHosp_Pipeline t1 
inner join tblHospitalDataCT_Pipeline t2 on t1.Pack_Cod=t2.Pack_Cod
inner join tblHospitalList_Pipeline t3 on t2.CPA_Code=t3.Hosp_ID
go
Update t1 set t1.Uniq_Prod='Y' 
from tblOutput_Hosp_TA_Master_Pipeline_Staging t1 
inner join tblProdMoleUnique t2 
on t1.Molecule_Code =t2.Mole_cod and t1.Product_Code=t2.Prod_cod
go


--Append Molecule/Product level data:
truncate table tblOutput_Hosp_TA_Product_Pipeline
go
Insert into tblOutput_Hosp_TA_Product_Pipeline
select 
    DataType, MktType, Mkt, MktName
    , City_EN as Geo, '2' as Geo_Lvl, 'H' as Grp_Lvl, Hosp_ID, Hosp_Des_EN, Tier
    , Class
    , 'PD' as Prod_Lvl, Prod_Des+' TOTAL', Prod_Cod
    , Manu_Des, Manu_Cod, MNC, 
    sum(M24), sum(M23), sum(M22), sum(M21), sum(M20), sum(M19), sum(M18), sum(M17), sum(M16), sum(M15), sum(M14), sum(M13), 
    sum(M12), sum(M11), sum(M10), sum(M09), sum(M08), sum(M07), sum(M06), sum(M05), sum(M04), sum(M03), sum(M02), sum(M01)
from tblQueryToolDriverHosp_Pipeline_Prod t1 
inner join tblHospitalDataCT_Pipeline t2 on t1.Pack_Cod=t2.Pack_Cod
inner join tblHospitalList_Pipeline t3 on t2.CPA_Code=t3.Hosp_ID
group by DataType, MktType, Mkt, MktName, City_EN, Hosp_ID, Hosp_Des_EN, Tier, Class, Prod_Des, Prod_Cod, Manu_Des, Manu_Cod, MNC
go
Insert into tblOutput_Hosp_TA_Master_Pipeline_Staging
select 
    DataType, MktType, Mkt, Market_Name, Geo, Geo_Lvl, Grp_Lvl, Hosp_ID, Hosp_Des_EN, Tier
    , Class
    , Prod_Lvl, Uniq_Prod
    , Mole_Des, Mole_Cod
    , Product_Name, Product_Code
    , null, '0000000'
    , Manuf_Name, Manuf_Code, MNC, 
    MTH_24, MTH_23, MTH_22, MTH_21, MTH_20, MTH_19, MTH_18, MTH_17, MTH_16, MTH_15, MTH_14, MTH_13, MTH_12, MTH_11, 
    MTH_10, MTH_9, MTH_8, MTH_7, MTH_6, MTH_5, MTH_4, MTH_3, MTH_2, MTH_1
from tblOutput_Hosp_TA_Product_Pipeline t1 
inner join tblProdMoleCode_HSPipeline t2 on t1.Product_Code=t2.Prod_Cod
go

--Append Molecule level data:
Insert into tblOutput_Hosp_TA_Master_Pipeline_Staging
select 
    DataType, MktType, Mkt, MktName
    , City_EN as Geo, '2' as Geo_Lvl, 'H' as Grp_Lvl, Hosp_ID, Hosp_Des_EN, Tier
    , 'NA' as Class
    , 'MO' as Prod_Lvl, 'N',
    Mole_Des+' TOTAL', Mole_Cod
    , null, '0000'
    , null, '000000'
    , null, null, null, 
sum(M24), sum(M23), sum(M22), sum(M21), sum(M20), sum(M19), sum(M18), sum(M17), sum(M16), sum(M15), sum(M14), sum(M13), 
sum(M12), sum(M11), sum(M10), sum(M09), sum(M08), sum(M07), sum(M06), sum(M05), sum(M04), sum(M03), sum(M02), sum(M01)
from tblQueryToolDriverHosp_Pipeline t1 
inner join tblHospitalDataCT_Pipeline t2 on t1.Pack_Cod=t2.Pack_Cod
inner join tblHospitalList_Pipeline t3 on t2.CPA_Code=t3.Hosp_ID
group by DataType, MktType, Mkt, MktName, City_EN, Hosp_ID, Hosp_Des_EN, Tier, Mole_Des, Mole_Cod
go

--Append Class/Molecule level data:
Insert into tblOutput_Hosp_TA_Master_Pipeline_Staging
select 
    DataType, MktType, Mkt, MktName
    , City_EN as Geo, '2' as Geo_Lvl, 'H' as Grp_Lvl, Hosp_ID, Hosp_Des_EN, Tier
    , Class
    , 'MO' as Prod_Lvl, 'N'
    , Mole_Des+' TOTAL', Mole_Cod
    , null, '0000'
    , null, '000000'
    , null, null, null, 
    sum(M24), sum(M23), sum(M22), sum(M21), sum(M20), sum(M19), sum(M18), sum(M17), sum(M16), sum(M15), sum(M14), sum(M13), 
    sum(M12), sum(M11), sum(M10), sum(M09), sum(M08), sum(M07), sum(M06), sum(M05), sum(M04), sum(M03), sum(M02), sum(M01)
from tblQueryToolDriverHosp_Pipeline t1 
inner join tblHospitalDataCT_Pipeline t2 on t1.Pack_Cod=t2.Pack_Cod
inner join tblHospitalList_Pipeline t3 on t2.CPA_Code=t3.Hosp_ID
Where Mkt='NIAD'
group by DataType, MktType, Mkt, MktName, City_EN, Hosp_ID, Hosp_Des_EN, Tier, Class, Mole_Des, Mole_Cod
go

--Append Class level data:
Insert into tblOutput_Hosp_TA_Master_Pipeline_Staging
select 
    DataType, MktType, Mkt, MktName
    , City_EN as Geo, '2' as Geo_Lvl, 'H' as Grp_Lvl, Hosp_ID, Hosp_Des_EN, Tier
    , Class
    , 'CS' as Prod_Lvl, 'Y' as Uniq_Prod
    , null, '000000'
    , null, '0000'
    , null, '000000'
    , null, null, null, 
    sum(M24), sum(M23), sum(M22), sum(M21), sum(M20), sum(M19), sum(M18), sum(M17), sum(M16), sum(M15), sum(M14), sum(M13), 
    sum(M12), sum(M11), sum(M10), sum(M09), sum(M08), sum(M07), sum(M06), sum(M05), sum(M04), sum(M03), sum(M02), sum(M01)
from tblQueryToolDriverHosp_Pipeline_Prod t1 
inner join tblHospitalDataCT_Pipeline t2 on t1.Pack_Cod=t2.Pack_Cod
inner join tblHospitalList_Pipeline t3 on t2.CPA_Code=t3.Hosp_ID
Where Mkt='NIAD'
group by DataType, MktType, Mkt, MktName, City_EN, Hosp_ID, Hosp_Des_EN, Tier, Class
go

--Append Market level data:
Insert into tblOutput_Hosp_TA_Master_Pipeline_Staging
select 
   DataType, MktType, Mkt, MktName+ ' TOTAL' as MktName
   , City_EN as Geo, '2' as Geo_Lvl, 'H' as Grp_Lvl, Hosp_ID, Hosp_Des_EN, 
   Tier, 'MK' as Class, 'MK' as Prod_Lvl, 'Y' as Uniq_Prod,
   null, '000000'
   , null, '0000'
   , null, '000000'
   , null, null, null, 
   sum(M24), sum(M23), sum(M22), sum(M21), sum(M20), sum(M19), sum(M18), sum(M17), sum(M16), sum(M15), sum(M14), sum(M13), 
   sum(M12), sum(M11), sum(M10), sum(M09), sum(M08), sum(M07), sum(M06), sum(M05), sum(M04), sum(M03), sum(M02), sum(M01)
from tblQueryToolDriverHosp_Pipeline_Prod t1 
inner join tblHospitalDataCT_Pipeline t2 on t1.Pack_Cod=t2.Pack_Cod
inner join tblHospitalList_Pipeline t3 on t2.CPA_Code=t3.Hosp_ID
group by DataType, MktType, Mkt, MktName, City_EN, Hosp_ID, Hosp_Des_EN, Tier
go


--Append Manufacturer level data:
Insert into tblOutput_Hosp_TA_Master_Pipeline_Staging
select 
   DataType, MktType, Mkt, Market_Name
   , Geo, Geo_Lvl, Grp_Lvl, Hosp_ID, Hosp_Des_EN, Tier
   , 'MNF' as Class
   , 'MNF' as Prod_Lvl
   , Uniq_Prod
   , null, '000000'
   , null, '0000'
   , null, '000000'
   ,  Manuf_Name, Manuf_Code, MNC, 
   sum(MTH_24), sum(MTH_23), sum(MTH_22), sum(MTH_21), sum(MTH_20), sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), 
   sum(MTH_12), sum(MTH_11), sum(MTH_10), sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_Hosp_TA_Master_Pipeline_Staging
where Prod_Lvl='PK'
group by  DataType, MktType, Mkt, Market_Name, Geo, Geo_Lvl, Grp_Lvl, Hosp_ID, Hosp_Des_EN, Tier,Uniq_Prod,  Manuf_Name, Manuf_Code, MNC
GO


--Append Geo/Tier level data:
Insert into tblOutput_Hosp_TA_Master_Pipeline_Staging
select 
   DataType, MktType, Mkt, Market_Name
   ,  Geo, Geo_Lvl, 'G' as Grp_Lvl, '99999', null, Tier
   , Class,  
   Prod_Lvl, Uniq_Prod
   , Molecule_Name, Molecule_Code
   , Product_Name, Product_Code
   , Package_Name, Package_Code,  
   Manuf_Name, Manuf_Code, MNC, 
   sum(MTH_24), sum(MTH_23), sum(MTH_22), sum(MTH_21), sum(MTH_20), sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), 
   sum(MTH_12), sum(MTH_11), sum(MTH_10), sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_Hosp_TA_Master_Pipeline_Staging
group by DataType, MktType, Mkt, Market_Name,  Geo, Geo_Lvl, Tier, Class, Prod_Lvl, Uniq_Prod, Molecule_Name, 
Molecule_Code, Product_Name, Product_Code, Package_Name, Package_Code,  Manuf_Name, Manuf_Code, MNC
go

--Append Geo level data:
Insert into tblOutput_Hosp_TA_Master_Pipeline_Staging
select 
    DataType, MktType, Mkt, Market_Name
    ,  Geo, Geo_Lvl, Grp_Lvl, '99999', null, 'TOTAL' as Tier
    , Class
    , Prod_Lvl, Uniq_Prod
    , Molecule_Name, Molecule_Code
    , Product_Name, Product_Code
    , Package_Name, Package_Code
    ,  Manuf_Name, Manuf_Code, MNC, 
    sum(MTH_24), sum(MTH_23), sum(MTH_22), sum(MTH_21), sum(MTH_20), sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), 
    sum(MTH_12), sum(MTH_11), sum(MTH_10), sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_Hosp_TA_Master_Pipeline_Staging
where Grp_lvl='G'
group by DataType, MktType, Mkt, Market_Name, Geo, Geo_Lvl, Grp_Lvl, Class, Prod_Lvl, Uniq_Prod, Molecule_Name, 
Molecule_Code, Product_Name, Product_Code, Package_Name, Package_Code, Manuf_Name, Manuf_Code, MNC
go

--Append China level data:
Insert into tblOutput_Hosp_TA_Master_Pipeline_Staging
select 
   DataType, MktType, Mkt, Market_Name
   ,  'CHINA' as Geo, 1 as Geo_Lvl, Grp_Lvl, '99999', null, Tier
   , Class
   , Prod_Lvl, Uniq_Prod
   , Molecule_Name, Molecule_Code
   , Product_Name, Product_Code
   , Package_Name, Package_Code
   ,  Manuf_Name, Manuf_Code, MNC, 
   sum(MTH_24), sum(MTH_23), sum(MTH_22), sum(MTH_21), sum(MTH_20), sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), 
   sum(MTH_12), sum(MTH_11), sum(MTH_10), sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_Hosp_TA_Master_Pipeline_Staging
where Grp_Lvl='G'
group by DataType, MktType, Mkt, Market_Name, Grp_lvl, Tier, Class, Prod_Lvl, Uniq_Prod, Molecule_Name, 
Molecule_Code, Product_Name, Product_Code, Package_Name, Package_Code, Manuf_Name, Manuf_Code, MNC
go

if object_id(N'tblOutput_Hosp_TA_Master_Pipeline',N'U') is not null
	drop table tblOutput_Hosp_TA_Master_Pipeline
go
select a.*,
b.DataSource,b.CPA_Code as [CPA_Code(PHA_Code)]
into tblOutput_Hosp_TA_Master_Pipeline
from tblOutput_Hosp_TA_Master_Pipeline_Staging a left join (
	select * from tblHospitalMaster where DataSource='CPA'
) b on a.Hosp_id=b.CPA_Code


exec dbo.sp_Log_Event 'Process','QT_CPA_Inline','Step_3_Create_Hosp_TA_Output_Master_Table.sql','End',null,null

