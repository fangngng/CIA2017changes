

--Created on 12/22/2011

--creates Rx Output tables after Rx data is loaded into 
--tblRxProcessedRawCT

--Refresh tblQueryToolDriverRx with the latest market definitions







use BMSCNProc2_test
go

exec dbo.sp_Log_Event 'Process','QT_Rx','Step_3_Create_Rx_TA_Output_Master_Tables.sql','Start',null,null

truncate table tblOutput_Rx_TA_Master
go



--Append Molecule/Package level data:
Insert into tblOutput_Rx_TA_Master(DataType,MktType,Mkt,Market_Name,Geo,Geo_Lvl,Department,Dept_Code,Class,Class_Name
		,Dept_Lvl,Prod_Lvl,Uniq_Prod,Molecule_Name,Molecule_Code,Product_Name,Product_Code,package_Name,Package_Code,Mth_20,
		Mth_19,Mth_18,Mth_17,Mth_16,Mth_15,Mth_14,Mth_13,Mth_12,Mth_11,
		Mth_10,Mth_9,Mth_8,Mth_7,Mth_6,Mth_5,Mth_4,Mth_3,Mth_2,Mth_1)
select 
     DataType
     , MktType, Mkt, MktName
     , Geo, 2 as Geo_Lvl
     , Dept as Department, Dept as Dept_Code
     , Class, Class as Class_Name
     , 'Y' as Dept_Lvl
     , 'PK' as Prod_Lvl,'Y'
     , Mole_Des, Mole_Cod
     , Prod_Des, Prod_Cod, 
     Pack_Des, t1.Pack_Cod,Mth_20
    ,Mth_19,Mth_18,Mth_17,Mth_16,Mth_15,Mth_14,Mth_13,Mth_12,Mth_11
     , Mth_10, MTH_9, MTH_8, MTH_7, MTH_6, MTH_5, MTH_4, MTH_3, MTH_2, MTH_1
from dbo.tblQueryToolDriverRx t1 
inner join tblRxProcessedRawCT t2 on t1.Pack_Cod=t2.Pack_Cod
go
Update t1 set t1.Uniq_Prod='Y' from tblOutput_Rx_TA_Master t1 
inner join tblProdMoleUnique t2 on t1.Molecule_Code =t2.Mole_cod and t1.Product_Code=t2.Prod_cod
go


--Append Molecule/Product Level Data:
Insert into tblOutput_Rx_TA_Master (DataType,MktType,Mkt,Market_Name,Geo,Geo_Lvl,Department,Dept_Code,Class,Class_Name
		,Dept_Lvl,Prod_Lvl,Uniq_Prod,Molecule_Name,Molecule_Code,Product_Name,Product_Code,package_Name,Package_Code,Mth_20,
	Mth_19,Mth_18,Mth_17,Mth_16,Mth_15,Mth_14,Mth_13,Mth_12,Mth_11,
		Mth_10,Mth_9,Mth_8,Mth_7,Mth_6,Mth_5,Mth_4,Mth_3,Mth_2,Mth_1)
select 
     DataType
     , MktType, Mkt, MktName
     , Geo, 2 as Geo_Lvl
     , Dept as Department, Dept as Dept_Code
     , Class, Class as Class_Name
     , 'Y' as Dept_lvl
     , 'PD' as Prod_Lvl, 'Y'
     , Mole_Des, Mole_Cod
     , Prod_Des+' TOTAL', Prod_Cod
     , null, '00000000',
     sum(MTH_20), sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11)
     ,sum(Mth_10),sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from 
(
select distinct MktType, Mkt, MktName, Class, Mole_Des, Mole_Cod , Prod_Des, Prod_Cod, Pack_Cod 
from dbo.tblQueryToolDriverRx
) t1 
inner join tblRxProcessedRawCT t2 on t1.Pack_Cod=t2.Pack_Cod
group by DataType, MktType, Mkt, MktName, Geo, Dept, Class, Mole_Des, Mole_Cod, Prod_Des, Prod_Cod 
go


--Append Molecule Level Data:
Insert into tblOutput_Rx_TA_Master (DataType,MktType,Mkt,Market_Name,Geo,Geo_Lvl,Department,Dept_Code,Class,Class_Name
		,Dept_Lvl,Prod_Lvl,Uniq_Prod,Molecule_Name,Molecule_Code,Product_Name,Product_Code,package_Name,Package_Code,Mth_20, 
		Mth_19,Mth_18,Mth_17,Mth_16,Mth_15,Mth_14,Mth_13,Mth_12,Mth_11,
		Mth_10,Mth_9,Mth_8,Mth_7,Mth_6,Mth_5,Mth_4,Mth_3,Mth_2,Mth_1)
select 
     DataType
     , MktType, Mkt, MktName
     , Geo, 2 as Geo_Lvl
     , Dept as Department, Dept as Dept_Code
     , 'NA' as Class, null as Class_Name
     , 'Y' as Dept_lvl
     , 'MO' as Prod_Lvl, 'Y'
     , Mole_Des+ ' TOTAL', Mole_Cod
     , null, '0000000'
     , null, '00000000' 
     ,sum(MTH_20),sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11)
     ,sum(Mth_10),sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from 
(select distinct MktType, Mkt, MktName, Mole_Des, Mole_Cod , Pack_Cod from dbo.tblQueryToolDriverRx) t1 
inner join tblRxProcessedRawCT t2 on t1.Pack_Cod=t2.Pack_Cod
group by DataType, MktType, Mkt, MktName, geo, Dept, Mole_Des, Mole_Cod
go
--Append Class/Molecule level data:
Insert into tblOutput_Rx_TA_Master (DataType,MktType,Mkt,Market_Name,Geo,Geo_Lvl,Department,Dept_Code,Class,Class_Name
		,Dept_Lvl,Prod_Lvl,Uniq_Prod,Molecule_Name,Molecule_Code,Product_Name,Product_Code,package_Name,Package_Code,Mth_20,
		Mth_19,Mth_18,Mth_17,Mth_16,Mth_15,Mth_14,Mth_13,Mth_12,Mth_11,
		Mth_10,Mth_9,Mth_8,Mth_7,Mth_6,Mth_5,Mth_4,Mth_3,Mth_2,Mth_1)
select 
     DataType
     , MktType, Mkt, MktName
     , Geo, 2 as Geo_Lvl
     , Dept as Department, Dept as Dept_Code
     , Class, Class as Class_Name
     , 'Y' as Dept_lvl
     , 'MO' as Prod_Lvl, 'Y'
     , Mole_Des+ ' TOTAL', Mole_Cod
     , null, '0000000'
     , null, '00000000',
     sum(MTH_20),sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11)
     ,sum(Mth_10),sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from 
(select distinct MktType, Mkt, MktName,Class, Mole_Des, Mole_Cod , Pack_Cod from dbo.tblQueryToolDriverRx) t1 
inner join tblRxProcessedRawCT t2 on t1.Pack_Cod=t2.Pack_Cod
where Mkt='NIAD'
group by DataType, MktType, Mkt, MktName, geo, Class, Dept, Mole_Des, Mole_Cod
go


--Append Class Level Data:
Insert into tblOutput_Rx_TA_Master (DataType,MktType,Mkt,Market_Name,Geo,Geo_Lvl,Department,Dept_Code,Class,Class_Name
		,Dept_Lvl,Prod_Lvl,Uniq_Prod,Molecule_Name,Molecule_Code,Product_Name,Product_Code,package_Name,Package_Code,Mth_20,
		Mth_19,Mth_18,Mth_17,Mth_16,Mth_15,Mth_14,Mth_13,Mth_12,Mth_11,
		Mth_10,Mth_9,Mth_8,Mth_7,Mth_6,Mth_5,Mth_4,Mth_3,Mth_2,Mth_1)
select 
    DataType
    , MktType, Mkt, MktName
    , Geo, 2 as Geo_Lvl
    , Dept as Department, Dept as Dept_Code
    , Class, Class+' TOTAL' as Class_Name
    , 'Y' as Dept_lvl
    , 'CS' as Prod_Lvl, 'Y'
    , null, '0000'
    , null, '0000000'
    , null,'00000000', 
    sum(MTH_20),sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11)
     ,sum(Mth_10),sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from 
(
select distinct MktType, Mkt, MktName, Class, Pack_Cod 
from dbo.tblQueryToolDriverRx
) t1
inner join tblRxProcessedRawCT t2 on t1.Pack_Cod=t2.Pack_Cod
where Mkt='NIAD'
group by DataType, MktType, Mkt, MktName, geo, Class, Dept
go


--Append Market Level Data:
Insert into tblOutput_Rx_TA_Master (DataType,MktType,Mkt,Market_Name,Geo,Geo_Lvl,Department,Dept_Code,Class,Class_Name
		,Dept_Lvl,Prod_Lvl,Uniq_Prod,Molecule_Name,Molecule_Code,Product_Name,Product_Code,package_Name,Package_Code,Mth_20,
		Mth_19,Mth_18,Mth_17,Mth_16,Mth_15,Mth_14,Mth_13,Mth_12,Mth_11,
		Mth_10,Mth_9,Mth_8,Mth_7,Mth_6,Mth_5,Mth_4,Mth_3,Mth_2,Mth_1)
select 
DataType
     , MktType, Mkt, MktName+' TOTAL' as MktName
     , Geo, 2 as Geo_Lvl
     , Dept as Department, Dept as Dept_Code
     , 'MK' as Class, null as Class_Name
     , 'Y' as Dept_lvl
     , 'MK' as Prod_Lvl, 'Y'
     , null, '0000'
     , null, '0000000'
     , null, '00000000', 
    sum(MTH_20),sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11)
     ,sum(Mth_10),sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from 
(
select distinct MktType, Mkt, MktName, Pack_Cod 
from dbo.tblQueryToolDriverRx
) t1
inner join tblRxProcessedRawCT t2 on t1.Pack_Cod=t2.Pack_Cod
group by DataType, MktType, Mkt, MktName, geo, Dept
go











--Append Geo Level Data:
Insert into tblOutput_Rx_TA_Master (DataType,MktType,Mkt,Market_Name,Geo,Geo_Lvl,Department,Dept_Code,Class,Class_Name
		,Dept_Lvl,Prod_Lvl,Uniq_Prod,Molecule_Name,Molecule_Code,Product_Name,Product_Code,package_Name,Package_Code,Mth_20,
		Mth_19,Mth_18,Mth_17,Mth_16,Mth_15,Mth_14,Mth_13,Mth_12,Mth_11,
		Mth_10,Mth_9,Mth_8,Mth_7,Mth_6,Mth_5,Mth_4,Mth_3,Mth_2,Mth_1)
select 
    DataType
    , MktType, Mkt, Market_Name
    , Geo, 2 as Geo_Lvl
    , Null as Department, Null as Dept_Code
    , Class, Class_Name
    , 'N' as Dept_lvl
    , Prod_Lvl, Uniq_Prod
    , Molecule_Name, Molecule_Code
    , Product_Name, Product_Code
    , Package_Name, Package_Code, 
sum(MTH_20),sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11)
     ,sum(Mth_10),sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_Rx_TA_Master
group by DataType, MktType, Mkt, Market_Name, geo, Class, Class_Name, Prod_Lvl, Uniq_Prod, Molecule_Name, 
Molecule_Code, Product_Name, Product_Code, Package_Name, Package_Code
go

--Append China Level Data:
Insert into tblOutput_Rx_TA_Master (DataType,MktType,Mkt,Market_Name,Geo,Geo_Lvl,Department,Dept_Code,Class,Class_Name
		,Dept_Lvl,Prod_Lvl,Uniq_Prod,Molecule_Name,Molecule_Code,Product_Name,Product_Code,package_Name,Package_Code,Mth_20,
		Mth_19,Mth_18,Mth_17,Mth_16,Mth_15,Mth_14,Mth_13,Mth_12,Mth_11,
		Mth_10,Mth_9,Mth_8,Mth_7,Mth_6,Mth_5,Mth_4,Mth_3,Mth_2,Mth_1)
select 
     DataType
     , MktType, Mkt, Market_Name
     , 'CHINA' as Geo, 1 as Geo_Lvl
     , Department, Dept_Code
     , Class, Class_Name
     , Dept_lvl
     , Prod_Lvl, Uniq_Prod
     , Molecule_Name, Molecule_Code
     , Product_Name, Product_Code
     , Package_Name, Package_Code, 
    sum(MTH_20),sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11)
     ,sum(Mth_10),sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_Rx_TA_Master
group by DataType, MktType, Mkt, Market_Name, Class, Department, Dept_Code, Class_Name, Dept_Lvl, Prod_Lvl, Uniq_Prod, Molecule_Name, 
Molecule_Code, Product_Name, Product_Code, Package_Name, Package_Code
go

exec dbo.sp_Log_Event 'Process','QT_Rx','Step_3_Create_Rx_TA_Output_Master_Tables.sql','End',null,null
