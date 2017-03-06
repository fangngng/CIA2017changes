/*
Created on 12/22/2011

creates IMS TA Output tables after :tblIMSDataRaw

Refresh tblQueryToolDriverIMS with the latest market definitions


data level:	
Package;Product;Class;Market   
没有 molecule级别(这里指CMPS级别，即页面的Mloecule Composition)--20130313需求变动，又增加了。


*/

Use BMSCNProc2
go
--清空日志
dump transaction BMSCNProc2 with no_log


drop table tblQueryToolDriverIMS_Prod
go
select distinct 
   MktType, Mkt, MktName
   , Class
   , Prod_Des, Prod_Cod
   , CMPS_Name, CMPS_Code
   , Pack_Des, Pack_Cod
   , Corp_Des, Corp_Cod
   , Manu_Des, Manu_Cod
   , MNC, Gene_Cod 
into tblQueryToolDriverIMS_Prod 
from tblQueryToolDriverIMS
go



PRINT '(--------------------------------
          tblOutput_IMS_TA_Master
----------------------------------------)'
truncate table tblOutput_IMS_TA_Master
go
drop index tblOutput_IMS_TA_Master.idxDataType
go
drop index tblOutput_IMS_TA_Master.idxDataMktType
go

--Append Package level data:
Insert into tblOutput_IMS_TA_Master
select 
   DataType
   , MktType, Mkt, MktName
   , City as Geo, Geo_Lvl
   , Class, Class as Class_Name
   , 'PK' as Prod_Lvl,'Y' as Uniq_Prod
   , Prod_Des, Prod_Cod
   , CMPS_Name, CMPS_CODE
   , Pack_Des, t1.Pack_Cod
   , Corp_Des, Corp_Cod
   , Manu_Des, Manu_Cod
   , MNC, Gene_Cod,
   MTH_60, MTH_59, MTH_58, MTH_57, MTH_56, MTH_55, MTH_54, MTH_53, MTH_52, MTH_51, 
   MTH_50, MTH_49, MTH_48, MTH_47, MTH_46, MTH_45, MTH_44, MTH_43, MTH_42, MTH_41, 
   MTH_40, MTH_39, MTH_38, MTH_37, MTH_36, MTH_35, MTH_34, MTH_33, MTH_32, MTH_31, 
   MTH_30, MTH_29, MTH_28, MTH_27, MTH_26, MTH_25, MTH_24, MTH_23, MTH_22, MTH_21, 
   MTH_20, MTH_19, MTH_18, MTH_17, MTH_16, MTH_15, MTH_14, MTH_13, MTH_12, MTH_11, 
   MTH_10, MTH_9, MTH_8, MTH_7, MTH_6, MTH_5, MTH_4, MTH_3, MTH_2, MTH_1
from tblQueryToolDriverIMS_Prod t1 
inner join tblIMSDataRaw t2 on t1.Pack_Cod=t2.Pack_Cod
inner join tblCityIMS t3 on t2.Audi_Cod=t3.Audi_Cod
go

--Append Product level data:
Insert into tblOutput_IMS_TA_Master
select 
    DataType
    , MktType, Mkt, Market_Name
    , Geo, Geo_Lvl
    , Class, Class_Name
    , 'PD' as Prod_Lvl, Uniq_Prod
    , Product_Name, Product_Code
    , NULL as CMPS_Name, '000000' as CMPS_Code
    , null as Package_Name, '0000000' as Package_COde
    , Corp_Name, Corp_Code
    , Manuf_Name, Manuf_Code
    , MNC, Generic_Code,
    sum(MTH_60), sum(MTH_59), sum(MTH_58), sum(MTH_57), sum(MTH_56), sum(MTH_55), sum(MTH_54), sum(MTH_53), sum(MTH_52), sum(MTH_51), 
    sum(MTH_50), sum(MTH_49), sum(MTH_48), sum(MTH_47), sum(MTH_46), sum(MTH_45), sum(MTH_44), sum(MTH_43), sum(MTH_42), sum(MTH_41), 
    sum(MTH_40), sum(MTH_39), sum(MTH_38), sum(MTH_37), sum(MTH_36), sum(MTH_35), sum(MTH_34), sum(MTH_33), sum(MTH_32), sum(MTH_31), 
    sum(MTH_30), sum(MTH_29), sum(MTH_28), sum(MTH_27), sum(MTH_26), sum(MTH_25), sum(MTH_24), sum(MTH_23), sum(MTH_22), sum(MTH_21), 
    sum(MTH_20), sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11), 
    sum(MTH_10), sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_IMS_TA_Master 
where prod_Lvl='PK'
group by DataType, MktType, Mkt, Market_Name, Geo, Geo_Lvl, Class, Class_Name, Uniq_Prod
, Product_Name, Product_Code, Corp_Name, Corp_Code, Manuf_Name, Manuf_Code, MNC, Generic_Code
GO


--Append Mloecule Composition level data:
Insert into tblOutput_IMS_TA_Master
select 
    DataType
    , MktType, Mkt, Market_Name
    , Geo, Geo_Lvl
    , Class, Class_Name
    , 'CMPS' as Prod_Lvl, Uniq_Prod
    , null as Product_Name, '00000' as Product_Code
    , CMPS_Name, CMPS_Code
    , null as Package_Name, '0000000' as Package_COde
    , null as Corp_Name, null as Corp_Code
    , null as Manuf_Name,null as Manuf_Code
    , null as MNC, null as Generic_Code,
    sum(MTH_60), sum(MTH_59), sum(MTH_58), sum(MTH_57), sum(MTH_56), sum(MTH_55), sum(MTH_54), sum(MTH_53), sum(MTH_52), sum(MTH_51), 
    sum(MTH_50), sum(MTH_49), sum(MTH_48), sum(MTH_47), sum(MTH_46), sum(MTH_45), sum(MTH_44), sum(MTH_43), sum(MTH_42), sum(MTH_41), 
    sum(MTH_40), sum(MTH_39), sum(MTH_38), sum(MTH_37), sum(MTH_36), sum(MTH_35), sum(MTH_34), sum(MTH_33), sum(MTH_32), sum(MTH_31), 
    sum(MTH_30), sum(MTH_29), sum(MTH_28), sum(MTH_27), sum(MTH_26), sum(MTH_25), sum(MTH_24), sum(MTH_23), sum(MTH_22), sum(MTH_21), 
    sum(MTH_20), sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11), 
    sum(MTH_10), sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_IMS_TA_Master 
where prod_Lvl='PK'
group by DataType, MktType, Mkt, Market_Name, Geo, Geo_Lvl, Class, Class_Name, Uniq_Prod
, CMPS_Name, CMPS_Code
GO


--Append Class level data:
Insert into tblOutput_IMS_TA_Master
select 
    DataType
    , MktType, Mkt, Market_Name
    , Geo, Geo_Lvl
    , Class, Class_Name
    , 'CS' as Prod_Lvl, Uniq_Prod
    , null as Product_Name, '00000' as Product_Code
    , NULL as CMPS_Name, '000000' as CMPS_Code
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
from tblOutput_IMS_TA_Master 
where prod_Lvl='PK' and Mkt='NIAD'
group by DataType, MktType, Mkt, Market_Name, Geo, Geo_Lvl, Class, Class_Name, Uniq_Prod
go




-- Append Manufacture level data:
Insert into tblOutput_IMS_TA_Master
select 
    DataType
    , MktType, Mkt, Market_Name
    , Geo, Geo_Lvl
    , 'MNF' as Class, null as Class_Name
    , 'MNF' as Prod_Lvl, Uniq_Prod
    , null as Product_Name, '00000' as Product_Code
    , null as CMPS_Name, '000000' as CMPS_Code
    , null as Package_Name, '0000000' as Package_COde
    , Corp_Name, Corp_Code
    , Manuf_Name,Manuf_Code
    , MNC, null as Generic_Code,
    sum(MTH_60), sum(MTH_59), sum(MTH_58), sum(MTH_57), sum(MTH_56), sum(MTH_55), sum(MTH_54), sum(MTH_53), sum(MTH_52), sum(MTH_51), 
    sum(MTH_50), sum(MTH_49), sum(MTH_48), sum(MTH_47), sum(MTH_46), sum(MTH_45), sum(MTH_44), sum(MTH_43), sum(MTH_42), sum(MTH_41), 
    sum(MTH_40), sum(MTH_39), sum(MTH_38), sum(MTH_37), sum(MTH_36), sum(MTH_35), sum(MTH_34), sum(MTH_33), sum(MTH_32), sum(MTH_31), 
    sum(MTH_30), sum(MTH_29), sum(MTH_28), sum(MTH_27), sum(MTH_26), sum(MTH_25), sum(MTH_24), sum(MTH_23), sum(MTH_22), sum(MTH_21), 
    sum(MTH_20), sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11), 
    sum(MTH_10), sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_IMS_TA_Master 
where prod_Lvl='PK'
group by DataType
    , MktType, Mkt, Market_Name
    , Geo, Geo_Lvl
    , Uniq_Prod
    ,Corp_Name, Corp_Code
    , Manuf_Name,Manuf_Code
    , MNC
GO

-- Append Company level data:
Insert into tblOutput_IMS_TA_Master
select 
    DataType
    , MktType, Mkt, Market_Name
    , Geo, Geo_Lvl
    , 'CMP' as Class, null as Class_Name
    , 'CMP' as Prod_Lvl, Uniq_Prod
    , null as Product_Name, '00000' as Product_Code
    , null as CMPS_Name, '000000' as CMPS_Code
    , null as Package_Name, '0000000' as Package_COde
    , Corp_Name, Corp_Code
    , null as Manuf_Name,null as Manuf_Code
    , null as MNC, null as Generic_Code,
    sum(MTH_60), sum(MTH_59), sum(MTH_58), sum(MTH_57), sum(MTH_56), sum(MTH_55), sum(MTH_54), sum(MTH_53), sum(MTH_52), sum(MTH_51), 
    sum(MTH_50), sum(MTH_49), sum(MTH_48), sum(MTH_47), sum(MTH_46), sum(MTH_45), sum(MTH_44), sum(MTH_43), sum(MTH_42), sum(MTH_41), 
    sum(MTH_40), sum(MTH_39), sum(MTH_38), sum(MTH_37), sum(MTH_36), sum(MTH_35), sum(MTH_34), sum(MTH_33), sum(MTH_32), sum(MTH_31), 
    sum(MTH_30), sum(MTH_29), sum(MTH_28), sum(MTH_27), sum(MTH_26), sum(MTH_25), sum(MTH_24), sum(MTH_23), sum(MTH_22), sum(MTH_21), 
    sum(MTH_20), sum(MTH_19), sum(MTH_18), sum(MTH_17), sum(MTH_16), sum(MTH_15), sum(MTH_14), sum(MTH_13), sum(MTH_12), sum(MTH_11), 
    sum(MTH_10), sum(MTH_9), sum(MTH_8), sum(MTH_7), sum(MTH_6), sum(MTH_5), sum(MTH_4), sum(MTH_3), sum(MTH_2), sum(MTH_1)
from tblOutput_IMS_TA_Master 
where prod_Lvl='PK'
group by DataType
    , MktType, Mkt, Market_Name
    , Geo, Geo_Lvl, Uniq_Prod
    , Corp_Name, Corp_Code
GO


--Append Market level data:
Insert into tblOutput_IMS_TA_Master
select 
    DataType
    , MktType, Mkt, Market_Name
    , Geo, Geo_Lvl
    , 'MK' as Class, null as Class_Name
    , 'MK' as Prod_Lvl, Uniq_Prod
    , null as Product_Name, '00000' as Product_Code
    , NULL as CMPS_Name, '000000' as CMPS_Code
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
from tblOutput_IMS_TA_Master 
where prod_Lvl='PK'
group by DataType, MktType, Mkt, Market_Name, Geo, Geo_Lvl, Uniq_Prod
go




create index idxDataType on tblOutput_IMS_TA_Master(DataType)
go
create index idxDataMktType on tblOutput_IMS_TA_Master(DataType,MktType)
go


--Process Inline Market Data:
truncate table tblOutput_IMS_TA_Master_Inline
go
Insert into tblOutput_IMS_TA_Master_Inline
select *, 
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
from tblOutput_IMS_TA_Master
where MktType='In-line Market'
go

drop table tblOutput_IMS_TA_Master_Inline_Mkt
go
select * into tblOutput_IMS_TA_Master_Inline_Mkt from tblOutput_IMS_TA_Master 
where MktType='In-line Market' and Prod_Lvl='MK'
go
Update t1 
Set MTH_SHR_60=(Case t2.MTH_60 When 0 Then 0 Else t1.MTH_60*1.0/t2.MTH_60 END),
MTH_SHR_59=(Case t2.MTH_59 When 0 Then 0 Else t1.MTH_59*1.0/t2.MTH_59 End), 
MTH_SHR_58=(Case t2.MTH_58 When 0 Then 0 Else t1.MTH_58*1.0/t2.MTH_58 End), 
MTH_SHR_57=(Case t2.MTH_57 When 0 Then 0 Else t1.MTH_57*1.0/t2.MTH_57 End), 
MTH_SHR_56=(Case t2.MTH_56 When 0 Then 0 Else t1.MTH_56*1.0/t2.MTH_56 End), 
MTH_SHR_55=(Case t2.MTH_55 When 0 Then 0 Else t1.MTH_55*1.0/t2.MTH_55 End), 
MTH_SHR_54=(Case t2.MTH_54 When 0 Then 0 Else t1.MTH_54*1.0/t2.MTH_54 End), 
MTH_SHR_53=(Case t2.MTH_53 When 0 Then 0 Else t1.MTH_53*1.0/t2.MTH_53 End), 
MTH_SHR_52=(Case t2.MTH_52 When 0 Then 0 Else t1.MTH_52*1.0/t2.MTH_52 End), 
MTH_SHR_51=(Case t2.MTH_51 When 0 Then 0 Else t1.MTH_51*1.0/t2.MTH_51 End), 
MTH_SHR_50=(Case t2.MTH_50 When 0 Then 0 Else t1.MTH_50*1.0/t2.MTH_50 End), 
MTH_SHR_49=(Case t2.MTH_49 When 0 Then 0 Else t1.MTH_49*1.0/t2.MTH_49 End), 
MTH_SHR_48=(Case t2.MTH_48 When 0 Then 0 Else t1.MTH_48*1.0/t2.MTH_48 End), 
MTH_SHR_47=(Case t2.MTH_47 When 0 Then 0 Else t1.MTH_47*1.0/t2.MTH_47 End), 
MTH_SHR_46=(Case t2.MTH_46 When 0 Then 0 Else t1.MTH_46*1.0/t2.MTH_46 End), 
MTH_SHR_45=(Case t2.MTH_45 When 0 Then 0 Else t1.MTH_45*1.0/t2.MTH_45 End), 
MTH_SHR_44=(Case t2.MTH_44 When 0 Then 0 Else t1.MTH_44*1.0/t2.MTH_44 End), 
MTH_SHR_43=(Case t2.MTH_43 When 0 Then 0 Else t1.MTH_43*1.0/t2.MTH_43 End), 
MTH_SHR_42=(Case t2.MTH_42 When 0 Then 0 Else t1.MTH_42*1.0/t2.MTH_42 End), 
MTH_SHR_41=(Case t2.MTH_41 When 0 Then 0 Else t1.MTH_41*1.0/t2.MTH_41 End), 
MTH_SHR_40=(Case t2.MTH_40 When 0 Then 0 Else t1.MTH_40*1.0/t2.MTH_40 End), 
MTH_SHR_39=(Case t2.MTH_39 When 0 Then 0 Else t1.MTH_39*1.0/t2.MTH_39 End), 
MTH_SHR_38=(Case t2.MTH_38 When 0 Then 0 Else t1.MTH_38*1.0/t2.MTH_38 End), 
MTH_SHR_37=(Case t2.MTH_37 When 0 Then 0 Else t1.MTH_37*1.0/t2.MTH_37 End), 
MTH_SHR_36=(Case t2.MTH_36 When 0 Then 0 Else t1.MTH_36*1.0/t2.MTH_36 End), 
MTH_SHR_35=(Case t2.MTH_35 When 0 Then 0 Else t1.MTH_35*1.0/t2.MTH_35 End), 
MTH_SHR_34=(Case t2.MTH_34 When 0 Then 0 Else t1.MTH_34*1.0/t2.MTH_34 End), 
MTH_SHR_33=(Case t2.MTH_33 When 0 Then 0 Else t1.MTH_33*1.0/t2.MTH_33 End), 
MTH_SHR_32=(Case t2.MTH_32 When 0 Then 0 Else t1.MTH_32*1.0/t2.MTH_32 End), 
MTH_SHR_31=(Case t2.MTH_31 When 0 Then 0 Else t1.MTH_31*1.0/t2.MTH_31 End), 
MTH_SHR_30=(Case t2.MTH_30 When 0 Then 0 Else t1.MTH_30*1.0/t2.MTH_30 End), 
MTH_SHR_29=(Case t2.MTH_29 When 0 Then 0 Else t1.MTH_29*1.0/t2.MTH_29 End), 
MTH_SHR_28=(Case t2.MTH_28 When 0 Then 0 Else t1.MTH_28*1.0/t2.MTH_28 End), 
MTH_SHR_27=(Case t2.MTH_27 When 0 Then 0 Else t1.MTH_27*1.0/t2.MTH_27 End), 
MTH_SHR_26=(Case t2.MTH_26 When 0 Then 0 Else t1.MTH_26*1.0/t2.MTH_26 End), 
MTH_SHR_25=(Case t2.MTH_25 When 0 Then 0 Else t1.MTH_25*1.0/t2.MTH_25 End), 
MTH_SHR_24=(Case t2.MTH_24 When 0 Then 0 Else t1.MTH_24*1.0/t2.MTH_24 End), 
MTH_SHR_23=(Case t2.MTH_23 When 0 Then 0 Else t1.MTH_23*1.0/t2.MTH_23 End), 
MTH_SHR_22=(Case t2.MTH_22 When 0 Then 0 Else t1.MTH_22*1.0/t2.MTH_22 End), 
MTH_SHR_21=(Case t2.MTH_21 When 0 Then 0 Else t1.MTH_21*1.0/t2.MTH_21 End), 
MTH_SHR_20=(Case t2.MTH_20 When 0 Then 0 Else t1.MTH_20*1.0/t2.MTH_20 End), 
MTH_SHR_19=(Case t2.MTH_19 When 0 Then 0 Else t1.MTH_19*1.0/t2.MTH_19 End), 
MTH_SHR_18=(Case t2.MTH_18 When 0 Then 0 Else t1.MTH_18*1.0/t2.MTH_18 End), 
MTH_SHR_17=(Case t2.MTH_17 When 0 Then 0 Else t1.MTH_17*1.0/t2.MTH_17 End), 
MTH_SHR_16=(Case t2.MTH_16 When 0 Then 0 Else t1.MTH_16*1.0/t2.MTH_16 End), 
MTH_SHR_15=(Case t2.MTH_15 When 0 Then 0 Else t1.MTH_15*1.0/t2.MTH_15 End), 
MTH_SHR_14=(Case t2.MTH_14 When 0 Then 0 Else t1.MTH_14*1.0/t2.MTH_14 End), 
MTH_SHR_13=(Case t2.MTH_13 When 0 Then 0 Else t1.MTH_13*1.0/t2.MTH_13 End), 
MTH_SHR_12=(Case t2.MTH_12 When 0 Then 0 Else t1.MTH_12*1.0/t2.MTH_12 End), 
MTH_SHR_11=(Case t2.MTH_11 When 0 Then 0 Else t1.MTH_11*1.0/t2.MTH_11 End), 
MTH_SHR_10=(Case t2.MTH_10 When 0 Then 0 Else t1.MTH_10*1.0/t2.MTH_10 End), 
MTH_SHR_9=(Case t2.MTH_9 When 0 Then 0 Else t1.MTH_9*1.0/t2.MTH_9 End), 
MTH_SHR_8=(Case t2.MTH_8 When 0 Then 0 Else t1.MTH_8*1.0/t2.MTH_8 End), 
MTH_SHR_7=(Case t2.MTH_7 When 0 Then 0 Else t1.MTH_7*1.0/t2.MTH_7 End), 
MTH_SHR_6=(Case t2.MTH_6 When 0 Then 0 Else t1.MTH_6*1.0/t2.MTH_6 End), 
MTH_SHR_5=(Case t2.MTH_5 When 0 Then 0 Else t1.MTH_5*1.0/t2.MTH_5 End), 
MTH_SHR_4=(Case t2.MTH_4 When 0 Then 0 Else t1.MTH_4*1.0/t2.MTH_4 End), 
MTH_SHR_3=(Case t2.MTH_3 When 0 Then 0 Else t1.MTH_3*1.0/t2.MTH_3 End), 
MTH_SHR_2=(Case t2.MTH_2 When 0 Then 0 Else t1.MTH_2*1.0/t2.MTH_2 End), 
MTH_SHR_1=(Case t2.MTH_1 When 0 Then 0 Else t1.MTH_1*1.0/t2.MTH_1 End)
from tblOutput_IMS_TA_Master_Inline t1 inner join tblOutput_IMS_TA_Master_InLine_Mkt t2
on t1.DataType=t2.DataType and t1.Mkt=t2.Mkt and t1.Geo=t2.Geo
go
