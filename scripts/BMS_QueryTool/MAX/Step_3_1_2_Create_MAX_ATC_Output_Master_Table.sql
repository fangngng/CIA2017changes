
use BMSCNProc2
go

exec dbo.sp_Log_Event 'Process','QT_IMS','Step_3_1_2_Create_MAX_ATC_Output_Master_Table.sql','Start',null,null


-------------------------------------------------
-- MAX 
------------------------------------------------


truncate table tblOutput_MAX_ATC_Master
go
drop index tblOutput_MAX_ATC_Master.idxDataType  
go


-- -- update GeoLevName 
-- alter table tblOutput_MAX_ATC_Master 
-- add GeoLevName varchar(20)
-- go 

--1. Append Package level data:
Insert into dbo.tblOutput_MAX_ATC_Master ( DataType, ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des,
											ATC4_Code, ATC4_Des, GEO, Geo_Lvl, Prod_Lvl, Uniq_Prod, Product_Name,
											Product_Code, CMPS_Name, CMPS_Code, Package_Name, Package_Code, Corp_Name,
											Corp_Code, Manuf_Name, Manuf_Code, MNC, Generic_Code, MTH_60, MTH_59, MTH_58,
											MTH_57, MTH_56, MTH_55, MTH_54, MTH_53, MTH_52, MTH_51, MTH_50, MTH_49,
											MTH_48, MTH_47, MTH_46, MTH_45, MTH_44, MTH_43, MTH_42, MTH_41, MTH_40,
											MTH_39, MTH_38, MTH_37, MTH_36, MTH_35, MTH_34, MTH_33, MTH_32, MTH_31,
											MTH_30, MTH_29, MTH_28, MTH_27, MTH_26, MTH_25, MTH_24, MTH_23, MTH_22,
											MTH_21, MTH_20, MTH_19, MTH_18, MTH_17, MTH_16, MTH_15, MTH_14, MTH_13,
											MTH_12, MTH_11, MTH_10, MTH_9, MTH_8, MTH_7, MTH_6, MTH_5, MTH_4, MTH_3,
											MTH_2, MTH_1 )
select 
    DataType
    , ATC1_Cod, ATC1_Des, ATC2_Cod, ATC2_Des, ATC3_Cod, ATC3_Des, ATC4_Cod, ATC4_Des
    , City as Geo, Geo_Lvl
    , 'PK' as Prod_Lvl,'Y' as Uniq_Prod
    , Prod_Des, Prod_Cod
    , CMPS_Name, CMPS_Code
    , Pack_Des, t1.Pack_Cod
    , Corp_Des, Corp_Cod
    , Manu_Des, Manu_Cod, MNC, Gene_cod,
    MTH_60, MTH_59, MTH_58, MTH_57, MTH_56, MTH_55, MTH_54, MTH_53, MTH_52, MTH_51, 
    MTH_50, MTH_49, MTH_48, MTH_47, MTH_46, MTH_45, MTH_44, MTH_43, MTH_42, MTH_41, 
    MTH_40, MTH_39, MTH_38, MTH_37, MTH_36, MTH_35, MTH_34, MTH_33, MTH_32, MTH_31, 
    MTH_30, MTH_29, MTH_28, MTH_27, MTH_26, MTH_25, MTH_24, MTH_23, MTH_22, MTH_21, 
    MTH_20, MTH_19, MTH_18, MTH_17, MTH_16, MTH_15, MTH_14, MTH_13, MTH_12, MTH_11, 
    MTH_10, MTH_9, MTH_8, MTH_7, MTH_6, MTH_5, MTH_4, MTH_3, MTH_2, MTH_1
from tblQueryToolDriverATC_Prod t1 
inner join tblMAXDataRaw t2 on t1.Pack_Cod=t2.Pack_Cod
inner join tblCityMax t3 on t2.Audi_Cod=t3.City 
go

--2. Append Product level data:
Insert into tblOutput_MAX_ATC_Master( DataType, ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des,
											ATC4_Code, ATC4_Des, GEO, Geo_Lvl, Prod_Lvl, Uniq_Prod, Product_Name,
											Product_Code, CMPS_Name, CMPS_Code, Package_Name, Package_Code, Corp_Name,
											Corp_Code, Manuf_Name, Manuf_Code, MNC, Generic_Code, MTH_60, MTH_59, MTH_58,
											MTH_57, MTH_56, MTH_55, MTH_54, MTH_53, MTH_52, MTH_51, MTH_50, MTH_49,
											MTH_48, MTH_47, MTH_46, MTH_45, MTH_44, MTH_43, MTH_42, MTH_41, MTH_40,
											MTH_39, MTH_38, MTH_37, MTH_36, MTH_35, MTH_34, MTH_33, MTH_32, MTH_31,
											MTH_30, MTH_29, MTH_28, MTH_27, MTH_26, MTH_25, MTH_24, MTH_23, MTH_22,
											MTH_21, MTH_20, MTH_19, MTH_18, MTH_17, MTH_16, MTH_15, MTH_14, MTH_13,
											MTH_12, MTH_11, MTH_10, MTH_9, MTH_8, MTH_7, MTH_6, MTH_5, MTH_4, MTH_3,
											MTH_2, MTH_1 )
select 
   DataType
   , ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des, ATC4_Code, ATC4_Des
   , Geo, Geo_Lvl
   , 'PD' as Prod_Lvl, Uniq_Prod
   , Product_Name, Product_Code
   , null as CMPS_Name, '000000' as CMPS_Code
   , null as Package_Name, '0000000' as Package_COde
   , Corp_Name, Corp_Code
   , Manuf_Name, Manuf_Code, MNC, Generic_Code, 
   sum(MTH_60), sum(MTH_59), sum(MTH_58), sum(MTH_57), sum(MTH_56), sum(MTH_55), sum(MTH_54), sum(MTH_53), sum(MTH_52), sum(MTH_51), 
   sum(MTH_50), sum(MTH_49), sum(MTH_48), sum(MTH_47), sum(MTH_46), sum(MTH_45), sum(MTH_44), sum(MTH_43), sum(MTH_42), sum(MTH_41), 
   sum(MTH_40), sum(MTH_39), sum(MTH_38), sum(MTH_37), sum(MTH_36), sum(MTH_35), sum(MTH_34), sum(MTH_33), sum(MTH_32), sum(MTH_31), 
   sum(MTH_30), sum(MTH_29), sum(MTH_28), sum(MTH_27), sum(MTH_26), sum(MTH_25), sum(MTH_24), sum(MTH_23), sum(MTH_22), sum(MTH_21), 
   sum(MTH_20), sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11), 
   sum(MTH_10), sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_MAX_ATC_Master
where Prod_Lvl='PK'
group by DataType, ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des, ATC4_Code, ATC4_Des, Geo, Geo_Lvl, Uniq_Prod
, Product_Name, Product_Code, Corp_Name, Corp_Code, Manuf_Name, Manuf_Code, MNC, Generic_Code
go


--3. Append Mloecule Composition level data:
Insert into tblOutput_MAX_ATC_Master( DataType, ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des,
											ATC4_Code, ATC4_Des, GEO, Geo_Lvl, Prod_Lvl, Uniq_Prod, Product_Name,
											Product_Code, CMPS_Name, CMPS_Code, Package_Name, Package_Code, Corp_Name,
											Corp_Code, Manuf_Name, Manuf_Code, MNC, Generic_Code, MTH_60, MTH_59, MTH_58,
											MTH_57, MTH_56, MTH_55, MTH_54, MTH_53, MTH_52, MTH_51, MTH_50, MTH_49,
											MTH_48, MTH_47, MTH_46, MTH_45, MTH_44, MTH_43, MTH_42, MTH_41, MTH_40,
											MTH_39, MTH_38, MTH_37, MTH_36, MTH_35, MTH_34, MTH_33, MTH_32, MTH_31,
											MTH_30, MTH_29, MTH_28, MTH_27, MTH_26, MTH_25, MTH_24, MTH_23, MTH_22,
											MTH_21, MTH_20, MTH_19, MTH_18, MTH_17, MTH_16, MTH_15, MTH_14, MTH_13,
											MTH_12, MTH_11, MTH_10, MTH_9, MTH_8, MTH_7, MTH_6, MTH_5, MTH_4, MTH_3,
											MTH_2, MTH_1 )
select 
       DataType
       , ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des, ATC4_Code, ATC4_Des
       , Geo, Geo_Lvl
       , 'CMPS' as Prod_Lvl, Uniq_Prod
       , null as Product_Name, '000000' as Product_Code
       , CMPS_Name, CMPS_Code
       , null as Package_Name, '0000000' as Package_COde
       , null as Corp_Name, null as Corp_Code
       , null as Manuf_Name, null as Manuf_Code
       , null as MNC, null as Generic_Code,
       sum(MTH_60), sum(MTH_59), sum(MTH_58), sum(MTH_57), sum(MTH_56), sum(MTH_55), sum(MTH_54), sum(MTH_53), sum(MTH_52), sum(MTH_51), 
       sum(MTH_50), sum(MTH_49), sum(MTH_48), sum(MTH_47), sum(MTH_46), sum(MTH_45), sum(MTH_44), sum(MTH_43), sum(MTH_42), sum(MTH_41), 
       sum(MTH_40), sum(MTH_39), sum(MTH_38), sum(MTH_37), sum(MTH_36), sum(MTH_35), sum(MTH_34), sum(MTH_33), sum(MTH_32), sum(MTH_31), 
       sum(MTH_30), sum(MTH_29), sum(MTH_28), sum(MTH_27), sum(MTH_26), sum(MTH_25), sum(MTH_24), sum(MTH_23), sum(MTH_22), sum(MTH_21), 
       sum(MTH_20), sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11), 
       sum(MTH_10), sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_MAX_ATC_Master
where Prod_Lvl='PK'
group by DataType, ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des, ATC4_Code, ATC4_Des, Geo, Geo_Lvl, Uniq_Prod
, CMPS_Name, CMPS_Code
go

--4. Append Manufacture level data:
Insert into tblOutput_MAX_ATC_Master( DataType, ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des,
											ATC4_Code, ATC4_Des, GEO, Geo_Lvl, Prod_Lvl, Uniq_Prod, Product_Name,
											Product_Code, CMPS_Name, CMPS_Code, Package_Name, Package_Code, Corp_Name,
											Corp_Code, Manuf_Name, Manuf_Code, MNC, Generic_Code, MTH_60, MTH_59, MTH_58,
											MTH_57, MTH_56, MTH_55, MTH_54, MTH_53, MTH_52, MTH_51, MTH_50, MTH_49,
											MTH_48, MTH_47, MTH_46, MTH_45, MTH_44, MTH_43, MTH_42, MTH_41, MTH_40,
											MTH_39, MTH_38, MTH_37, MTH_36, MTH_35, MTH_34, MTH_33, MTH_32, MTH_31,
											MTH_30, MTH_29, MTH_28, MTH_27, MTH_26, MTH_25, MTH_24, MTH_23, MTH_22,
											MTH_21, MTH_20, MTH_19, MTH_18, MTH_17, MTH_16, MTH_15, MTH_14, MTH_13,
											MTH_12, MTH_11, MTH_10, MTH_9, MTH_8, MTH_7, MTH_6, MTH_5, MTH_4, MTH_3,
											MTH_2, MTH_1 )
select 
    DataType
    , ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des, ATC4_Code, ATC4_Des
    , Geo, Geo_Lvl
    , 'MNF' as Prod_Lvl, Uniq_Prod
    , null as Product_Name, '000000' as Product_Code
    , null as CMPS_Name, '000000' as CMPS_Code
    , null as Package_Name, '0000000' as Package_COde
    , Corp_Name, Corp_Code
    , Manuf_Name, Manuf_Code
    , MNC, null as Generic_Code,
    sum(MTH_60), sum(MTH_59), sum(MTH_58), sum(MTH_57), sum(MTH_56), sum(MTH_55), sum(MTH_54), sum(MTH_53), sum(MTH_52), sum(MTH_51), 
    sum(MTH_50), sum(MTH_49), sum(MTH_48), sum(MTH_47), sum(MTH_46), sum(MTH_45), sum(MTH_44), sum(MTH_43), sum(MTH_42), sum(MTH_41), 
    sum(MTH_40), sum(MTH_39), sum(MTH_38), sum(MTH_37), sum(MTH_36), sum(MTH_35), sum(MTH_34), sum(MTH_33), sum(MTH_32), sum(MTH_31), 
    sum(MTH_30), sum(MTH_29), sum(MTH_28), sum(MTH_27), sum(MTH_26), sum(MTH_25), sum(MTH_24), sum(MTH_23), sum(MTH_22), sum(MTH_21), 
    sum(MTH_20), sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11), 
    sum(MTH_10), sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_MAX_ATC_Master
where Prod_Lvl='PK'
group by  DataType
    , ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des, ATC4_Code, ATC4_Des
    , Geo, Geo_Lvl
    , Uniq_Prod
    , Corp_Name, Corp_Code
    , Manuf_Name, Manuf_Code
    , MNC
go

--5. Append Company level data:
Insert into tblOutput_MAX_ATC_Master( DataType, ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des,
											ATC4_Code, ATC4_Des, GEO, Geo_Lvl, Prod_Lvl, Uniq_Prod, Product_Name,
											Product_Code, CMPS_Name, CMPS_Code, Package_Name, Package_Code, Corp_Name,
											Corp_Code, Manuf_Name, Manuf_Code, MNC, Generic_Code, MTH_60, MTH_59, MTH_58,
											MTH_57, MTH_56, MTH_55, MTH_54, MTH_53, MTH_52, MTH_51, MTH_50, MTH_49,
											MTH_48, MTH_47, MTH_46, MTH_45, MTH_44, MTH_43, MTH_42, MTH_41, MTH_40,
											MTH_39, MTH_38, MTH_37, MTH_36, MTH_35, MTH_34, MTH_33, MTH_32, MTH_31,
											MTH_30, MTH_29, MTH_28, MTH_27, MTH_26, MTH_25, MTH_24, MTH_23, MTH_22,
											MTH_21, MTH_20, MTH_19, MTH_18, MTH_17, MTH_16, MTH_15, MTH_14, MTH_13,
											MTH_12, MTH_11, MTH_10, MTH_9, MTH_8, MTH_7, MTH_6, MTH_5, MTH_4, MTH_3,
											MTH_2, MTH_1 )
select 
    DataType
    , ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des, ATC4_Code, ATC4_Des
    , Geo, Geo_Lvl
    , 'CMP' as Prod_Lvl, Uniq_Prod
    , null as Product_Name, '000000' as Product_Code
    , null as CMPS_Name, '000000' as CMPS_Code
    , null as Package_Name, '0000000' as Package_COde
    , Corp_Name, Corp_Code
    , null as Manuf_Name, null as Manuf_Code
    , null as MNC, null as Generic_Code,
    sum(MTH_60), sum(MTH_59), sum(MTH_58), sum(MTH_57), sum(MTH_56), sum(MTH_55), sum(MTH_54), sum(MTH_53), sum(MTH_52), sum(MTH_51), 
    sum(MTH_50), sum(MTH_49), sum(MTH_48), sum(MTH_47), sum(MTH_46), sum(MTH_45), sum(MTH_44), sum(MTH_43), sum(MTH_42), sum(MTH_41), 
    sum(MTH_40), sum(MTH_39), sum(MTH_38), sum(MTH_37), sum(MTH_36), sum(MTH_35), sum(MTH_34), sum(MTH_33), sum(MTH_32), sum(MTH_31), 
    sum(MTH_30), sum(MTH_29), sum(MTH_28), sum(MTH_27), sum(MTH_26), sum(MTH_25), sum(MTH_24), sum(MTH_23), sum(MTH_22), sum(MTH_21), 
    sum(MTH_20), sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11), 
    sum(MTH_10), sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_MAX_ATC_Master
where Prod_Lvl='PK'
group by  DataType
    , ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des, ATC4_Code, ATC4_Des
    , Geo, Geo_Lvl
    , Uniq_Prod
    , Corp_Name, Corp_Code
go

--6.1 Append ACT1 level data:
Insert into tblOutput_MAX_ATC_Master( DataType, ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des,
											ATC4_Code, ATC4_Des, GEO, Geo_Lvl, Prod_Lvl, Uniq_Prod, Product_Name,
											Product_Code, CMPS_Name, CMPS_Code, Package_Name, Package_Code, Corp_Name,
											Corp_Code, Manuf_Name, Manuf_Code, MNC, Generic_Code, MTH_60, MTH_59, MTH_58,
											MTH_57, MTH_56, MTH_55, MTH_54, MTH_53, MTH_52, MTH_51, MTH_50, MTH_49,
											MTH_48, MTH_47, MTH_46, MTH_45, MTH_44, MTH_43, MTH_42, MTH_41, MTH_40,
											MTH_39, MTH_38, MTH_37, MTH_36, MTH_35, MTH_34, MTH_33, MTH_32, MTH_31,
											MTH_30, MTH_29, MTH_28, MTH_27, MTH_26, MTH_25, MTH_24, MTH_23, MTH_22,
											MTH_21, MTH_20, MTH_19, MTH_18, MTH_17, MTH_16, MTH_15, MTH_14, MTH_13,
											MTH_12, MTH_11, MTH_10, MTH_9, MTH_8, MTH_7, MTH_6, MTH_5, MTH_4, MTH_3,
											MTH_2, MTH_1 )
select DataType, ATC1_Code, ATC1_Des, 'NA', 'NA', 'NA', 'NA', 'NA', 'NA', Geo, Geo_Lvl, 'ATC1' as Prod_Lvl, Uniq_Prod,
    null as Product_Name, '000000' as Product_Code, null as CMPS_Name, '000000' as CMPS_Code, null as Package_Name, '0000000' as Package_COde
    , null as Corp_Name, null as Corp_Code, null as Manuf_Name, null as Manuf_Code, null as MNC, null as Generic_Code,
    sum(MTH_60), sum(MTH_59), sum(MTH_58), sum(MTH_57), sum(MTH_56), sum(MTH_55), sum(MTH_54), sum(MTH_53), sum(MTH_52), sum(MTH_51), 
    sum(MTH_50), sum(MTH_49), sum(MTH_48), sum(MTH_47), sum(MTH_46), sum(MTH_45), sum(MTH_44), sum(MTH_43), sum(MTH_42), sum(MTH_41), 
    sum(MTH_40), sum(MTH_39), sum(MTH_38), sum(MTH_37), sum(MTH_36), sum(MTH_35), sum(MTH_34), sum(MTH_33), sum(MTH_32), sum(MTH_31), 
    sum(MTH_30), sum(MTH_29), sum(MTH_28), sum(MTH_27), sum(MTH_26), sum(MTH_25), sum(MTH_24), sum(MTH_23), sum(MTH_22), sum(MTH_21), 
    sum(MTH_20), sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11), 
    sum(MTH_10), sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_MAX_ATC_Master
where Prod_Lvl='PK'
group by DataType, ATC1_Code, ATC1_Des, Geo, Geo_Lvl, Uniq_Prod
go
--6.2 Append ACT2 level data:
Insert into tblOutput_MAX_ATC_Master( DataType, ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des,
											ATC4_Code, ATC4_Des, GEO, Geo_Lvl, Prod_Lvl, Uniq_Prod, Product_Name,
											Product_Code, CMPS_Name, CMPS_Code, Package_Name, Package_Code, Corp_Name,
											Corp_Code, Manuf_Name, Manuf_Code, MNC, Generic_Code, MTH_60, MTH_59, MTH_58,
											MTH_57, MTH_56, MTH_55, MTH_54, MTH_53, MTH_52, MTH_51, MTH_50, MTH_49,
											MTH_48, MTH_47, MTH_46, MTH_45, MTH_44, MTH_43, MTH_42, MTH_41, MTH_40,
											MTH_39, MTH_38, MTH_37, MTH_36, MTH_35, MTH_34, MTH_33, MTH_32, MTH_31,
											MTH_30, MTH_29, MTH_28, MTH_27, MTH_26, MTH_25, MTH_24, MTH_23, MTH_22,
											MTH_21, MTH_20, MTH_19, MTH_18, MTH_17, MTH_16, MTH_15, MTH_14, MTH_13,
											MTH_12, MTH_11, MTH_10, MTH_9, MTH_8, MTH_7, MTH_6, MTH_5, MTH_4, MTH_3,
											MTH_2, MTH_1 )
select DataType, ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, 'NA', 'NA', 'NA', 'NA', Geo, Geo_Lvl, 'ATC2' as Prod_Lvl, Uniq_Prod, 
    null as Product_Name, '000000' as Product_Code, null as CMPS_Name, '000000' as CMPS_Code, null as Package_Name, '0000000' as Package_COde
    , null as Corp_Name, null as Corp_Code, null as Manuf_Name, null as Manuf_Code, null as MNC, null as Generic_Code,
    sum(MTH_60), sum(MTH_59), sum(MTH_58), sum(MTH_57), sum(MTH_56), sum(MTH_55), sum(MTH_54), sum(MTH_53), sum(MTH_52), sum(MTH_51), 
    sum(MTH_50), sum(MTH_49), sum(MTH_48), sum(MTH_47), sum(MTH_46), sum(MTH_45), sum(MTH_44), sum(MTH_43), sum(MTH_42), sum(MTH_41), 
    sum(MTH_40), sum(MTH_39), sum(MTH_38), sum(MTH_37), sum(MTH_36), sum(MTH_35), sum(MTH_34), sum(MTH_33), sum(MTH_32), sum(MTH_31), 
    sum(MTH_30), sum(MTH_29), sum(MTH_28), sum(MTH_27), sum(MTH_26), sum(MTH_25), sum(MTH_24), sum(MTH_23), sum(MTH_22), sum(MTH_21), 
    sum(MTH_20), sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11), 
    sum(MTH_10), sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_MAX_ATC_Master
where Prod_Lvl='PK'
group by DataType, ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, Geo, Geo_Lvl, Uniq_Prod
go
--6.3 Append ACT3 level data:
Insert into tblOutput_MAX_ATC_Master( DataType, ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des,
											ATC4_Code, ATC4_Des, GEO, Geo_Lvl, Prod_Lvl, Uniq_Prod, Product_Name,
											Product_Code, CMPS_Name, CMPS_Code, Package_Name, Package_Code, Corp_Name,
											Corp_Code, Manuf_Name, Manuf_Code, MNC, Generic_Code, MTH_60, MTH_59, MTH_58,
											MTH_57, MTH_56, MTH_55, MTH_54, MTH_53, MTH_52, MTH_51, MTH_50, MTH_49,
											MTH_48, MTH_47, MTH_46, MTH_45, MTH_44, MTH_43, MTH_42, MTH_41, MTH_40,
											MTH_39, MTH_38, MTH_37, MTH_36, MTH_35, MTH_34, MTH_33, MTH_32, MTH_31,
											MTH_30, MTH_29, MTH_28, MTH_27, MTH_26, MTH_25, MTH_24, MTH_23, MTH_22,
											MTH_21, MTH_20, MTH_19, MTH_18, MTH_17, MTH_16, MTH_15, MTH_14, MTH_13,
											MTH_12, MTH_11, MTH_10, MTH_9, MTH_8, MTH_7, MTH_6, MTH_5, MTH_4, MTH_3,
											MTH_2, MTH_1 )
select DataType, ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des, 'NA', 'NA', Geo, Geo_Lvl, 'ATC3' as Prod_Lvl, Uniq_Prod, 
    null as Product_Name, '000000' as Product_Code, null as CMPS_Name, '000000' as CMPS_Code, null as Package_Name, '0000000' as Package_COde
    , null as Corp_Name, null as Corp_Code, null as Manuf_Name, null as Manuf_Code, null as MNC, null as Generic_Code,
    sum(MTH_60), sum(MTH_59), sum(MTH_58), sum(MTH_57), sum(MTH_56), sum(MTH_55), sum(MTH_54), sum(MTH_53), sum(MTH_52), sum(MTH_51), 
    sum(MTH_50), sum(MTH_49), sum(MTH_48), sum(MTH_47), sum(MTH_46), sum(MTH_45), sum(MTH_44), sum(MTH_43), sum(MTH_42), sum(MTH_41), 
    sum(MTH_40), sum(MTH_39), sum(MTH_38), sum(MTH_37), sum(MTH_36), sum(MTH_35), sum(MTH_34), sum(MTH_33), sum(MTH_32), sum(MTH_31), 
    sum(MTH_30), sum(MTH_29), sum(MTH_28), sum(MTH_27), sum(MTH_26), sum(MTH_25), sum(MTH_24), sum(MTH_23), sum(MTH_22), sum(MTH_21), 
    sum(MTH_20), sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11), 
    sum(MTH_10), sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_MAX_ATC_Master
where Prod_Lvl='PK'
group by DataType, ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des, Geo, Geo_Lvl, Uniq_Prod
go
--6.4 Append ACT4 level data:
Insert into tblOutput_MAX_ATC_Master( DataType, ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des,
											ATC4_Code, ATC4_Des, GEO, Geo_Lvl, Prod_Lvl, Uniq_Prod, Product_Name,
											Product_Code, CMPS_Name, CMPS_Code, Package_Name, Package_Code, Corp_Name,
											Corp_Code, Manuf_Name, Manuf_Code, MNC, Generic_Code, MTH_60, MTH_59, MTH_58,
											MTH_57, MTH_56, MTH_55, MTH_54, MTH_53, MTH_52, MTH_51, MTH_50, MTH_49,
											MTH_48, MTH_47, MTH_46, MTH_45, MTH_44, MTH_43, MTH_42, MTH_41, MTH_40,
											MTH_39, MTH_38, MTH_37, MTH_36, MTH_35, MTH_34, MTH_33, MTH_32, MTH_31,
											MTH_30, MTH_29, MTH_28, MTH_27, MTH_26, MTH_25, MTH_24, MTH_23, MTH_22,
											MTH_21, MTH_20, MTH_19, MTH_18, MTH_17, MTH_16, MTH_15, MTH_14, MTH_13,
											MTH_12, MTH_11, MTH_10, MTH_9, MTH_8, MTH_7, MTH_6, MTH_5, MTH_4, MTH_3,
											MTH_2, MTH_1 )
select DataType, ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des, ATC4_Code, ATC4_Des, Geo, Geo_Lvl, 'ATC4' as Prod_Lvl, Uniq_Prod, 
    null as Product_Name, '000000' as Product_Code, null as CMPS_Name, '000000' as CMPS_Code, null as Package_Name, '0000000' as Package_COde
    , null as Corp_Name, null as Corp_Code, null as Manuf_Name, null as Manuf_Code, null as MNC, null as Generic_Code,
    sum(MTH_60), sum(MTH_59), sum(MTH_58), sum(MTH_57), sum(MTH_56), sum(MTH_55), sum(MTH_54), sum(MTH_53), sum(MTH_52), sum(MTH_51), 
    sum(MTH_50), sum(MTH_49), sum(MTH_48), sum(MTH_47), sum(MTH_46), sum(MTH_45), sum(MTH_44), sum(MTH_43), sum(MTH_42), sum(MTH_41), 
    sum(MTH_40), sum(MTH_39), sum(MTH_38), sum(MTH_37), sum(MTH_36), sum(MTH_35), sum(MTH_34), sum(MTH_33), sum(MTH_32), sum(MTH_31), 
    sum(MTH_30), sum(MTH_29), sum(MTH_28), sum(MTH_27), sum(MTH_26), sum(MTH_25), sum(MTH_24), sum(MTH_23), sum(MTH_22), sum(MTH_21), 
    sum(MTH_20), sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11), 
    sum(MTH_10), sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_MAX_ATC_Master
where Prod_Lvl='PK'
group by DataType, ATC1_Code, ATC1_Des, ATC2_Code, ATC2_Des, ATC3_Code, ATC3_Des, ATC4_Code, ATC4_Des, Geo, Geo_Lvl, Uniq_Prod
go



update a 
set a.GeoLevName = b.GeoLev 
from tblOutput_MAX_ATC_Master as a 
inner join tblGeoLevList as b on a.geo_lvl = b.GeoLevID 
go 




create index idxDataType on tblOutput_MAX_ATC_Master(DataType)

