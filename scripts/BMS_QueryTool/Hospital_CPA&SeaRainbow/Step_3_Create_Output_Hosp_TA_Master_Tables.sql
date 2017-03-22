/*
Created on 12/22/2011
This SQL Script creates Hospital TA Output tables 
after CPA & Sea Rainbow data is loaded into tblHospitalDataCT
Refresh tblQueryToolDriverHosp with the latest market definitions
*/
--time:1:23:00
use BMSCNProc2
go

exec dbo.sp_Log_Event 'Process','QT_CPA_Inline','Step_3_Create_Output_Hosp_TA_Master_Tables.sql','Start',null,null


drop table tblQueryToolDriverHosp_Prod
go
select distinct 
  MktType, Mkt, MktName
  , Class
  , Prod_Des, Prod_Cod
  , null as Pack_Des, Pack_Cod
  , Manu_Des, Manu_Cod, MNC , rat
into tblQueryToolDriverHosp_Prod 
from tblQueryToolDriverHosp
go

drop table tblProdMoleCode_HS
go
select distinct Prod_Cod, Mole_Des, Mole_Cod, 'N' as Uniq_Prod 
into tblProdMoleCode_HS 
from tblQueryToolDriverHosp
go

drop table tblProdMoleUnique
go
select Prod_Cod, max(mole_Cod) as Mole_Cod 
into tblProdMoleUnique 
from tblProdMoleCode_HS group by Prod_Cod
go
Update t1 set t1.Uniq_Prod='Y' 
from tblProdMoleCode_HS t1 
inner join tblProdMoleUnique t2 
on t1.Mole_Cod=t2.Mole_cod and t1.Prod_Cod=t2.Prod_cod
go


truncate table tblOutput_Hosp_TA_Master
go

--if exists(select * from sysindexes where id=object_id(N'tblOutput_Hosp_TA_Master') and name='idxDataType')
--drop index tblOutput_Hosp_TA_Master.idxDataType 
--go
--Append Molecule/Package level data:

Insert into tblOutput_Hosp_TA_Master
select DataType, MktType, Mkt, MktName, City_EN as Geo, 
	'2' as Geo_Lvl, 'H' as Grp_Lvl, Hosp_ID, Hosp_Des_EN, 
	Tier, Class, Class as Class_Name
	, 'PK' as Prod_Lvl,'N', Mole_Des, 
	Mole_Cod, Prod_Des, Prod_Cod, Pack_Des, t1.Pack_Cod,  Manu_Des, Manu_Cod, MNC, 
	[M48]*rat,[M47]*rat,[M46]*rat,[M45]*rat,[M44]*rat,[M43]*rat,[M42]*rat,[M41]*rat,[M40]*rat,[M39]*rat,[M38]*rat,[M37]*rat,
	[M36]*rat,[M35]*rat,[M34]*rat,[M33]*rat,[M32]*rat,[M31]*rat,[M30]*rat,[M29]*rat,[M28]*rat,[M27]*rat,[M26]*rat,[M25]*rat,
	M24*rat, M23*rat, M22*rat, M21*rat, M20*rat, M19*rat, M18*rat, M17*rat, M16*rat, M15*rat, M14*rat, M13*rat, 
	M12*rat, M11*rat, M10*rat, M09*rat, M08*rat, M07*rat, M06*rat, M05*rat, M04*rat, M03*rat, M02*rat, M01*rat
from tblQueryToolDriverHosp t1
inner join tblHospitalDataCT t2 on t1.Pack_Cod=t2.Pack_Cod
inner join tblHospitalList t3 on t2.CPA_ID=t3.Hosp_ID
go
Update t1 
set t1.Uniq_Prod='Y' 
from tblOutput_Hosp_TA_Master t1 
inner join tblProdMoleUnique t2 on t1.Molecule_Code =t2.Mole_cod and t1.Product_Code=t2.Prod_cod
go

--Append Molecule/Product level data:
truncate table tblOutput_Hosp_TA_Product
go
Insert into tblOutput_Hosp_TA_Product
select DataType, MktType, Mkt, MktName, City_EN as Geo
	, '2' as Geo_Lvl, 'H' as Grp_Lvl, Hosp_ID, Hosp_Des_EN, 
	Tier, Class
	, 'PD' as Prod_Lvl, Prod_Des+' TOTAL', Prod_Cod, Manu_Des, Manu_Cod, MNC, 
	sum(M48*rat),sum(M47*rat),sum(M46*rat),sum(M45*rat),sum(M44*rat),sum(M43*rat),sum(M42*rat),sum(M41*rat),sum(M40*rat),sum(M39*rat),sum(M38*rat),sum(M37*rat),
	sum(M36*rat),sum(M35*rat),sum(M34*rat),sum(M33*rat),sum(M32*rat),sum(M31*rat),sum(M30*rat),sum(M29*rat),sum(M28*rat),sum(M27*rat),sum(M26*rat),sum(M25*rat),
	sum(M24*rat),sum(M23*rat),sum(M22*rat),sum(M21*rat),sum(M20*rat),sum(M19*rat),sum(M18*rat),sum(M17*rat),sum(M16*rat),sum(M15*rat),sum(M14*rat),sum(M13*rat), 
	sum(M12*rat), sum(M11*rat),sum(M10*rat),sum(M09*rat),sum(M08*rat),sum(M07*rat),sum(M06*rat),sum(M05*rat),sum(M04*rat),sum(M03*rat),sum(M02*rat),sum(M01*rat)
from tblQueryToolDriverHosp_Prod t1 
inner join tblHospitalDataCT t2 on t1.Pack_Cod=t2.Pack_Cod
inner join tblHospitalList t3 on t2.CPA_ID=t3.Hosp_ID
group by DataType, MktType, Mkt, MktName, City_EN, Hosp_ID, Hosp_Des_EN, Tier, Class, Prod_Des, Prod_Cod, Manu_Des, Manu_Cod, MNC
go
Insert into tblOutput_Hosp_TA_Master
select DataType, MktType, Mkt, Market_Name, Geo, Geo_Lvl, Grp_Lvl, Hosp_ID, Hosp_Des_EN, Tier, Class, Class as Class_Name, 
	Prod_Lvl, Uniq_Prod, Mole_Des, Mole_Cod, Product_Name, Product_Code, null, '0000000', Manuf_Name, Manuf_Code, MNC, 
	MTH_48,MTH_47,MTH_46,MTH_45,MTH_44,MTH_43,MTH_42,MTH_41,MTH_40,MTH_39,MTH_38,MTH_37,
	MTH_36,MTH_35,MTH_34,MTH_33,MTH_32,MTH_31,MTH_30,MTH_29,MTH_28,MTH_27,MTH_26,MTH_25,
	MTH_24, MTH_23, MTH_22, MTH_21, MTH_20, MTH_19, MTH_18, MTH_17, MTH_16, MTH_15, MTH_14, MTH_13, 
	MTH_12, MTH_11, MTH_10, MTH_9, MTH_8, MTH_7, MTH_6, MTH_5, MTH_4, MTH_3, MTH_2, MTH_1
from tblOutput_Hosp_TA_Product t1 
inner join tblProdMoleCode_HS t2 on t1.Product_Code=t2.Prod_Cod
go

--Append Molecule level data:
Insert into tblOutput_Hosp_TA_Master
select 
	DataType, MktType, Mkt, MktName, City_EN as Geo
	, '2' as Geo_Lvl, 'H' as Grp_Lvl
	, Hosp_ID, Hosp_Des_EN, Tier
	, 'NA' as Class, 'NA' as Class_Name
	, 'MO' as Prod_Lvl, 'N'
	,Mole_Des+' TOTAL', Mole_Cod
	, null, '000000000', null, '00000000000', null, null, null, 
	sum(M48*rat),sum(M47*rat),sum(M46*rat),sum(M45*rat),sum(M44*rat),sum(M43*rat),sum(M42*rat),sum(M41*rat),sum(M40*rat),sum(M39*rat),sum(M38*rat),sum(M37*rat),
	sum(M36*rat),sum(M35*rat),sum(M34*rat),sum(M33*rat),sum(M32*rat),sum(M31*rat),sum(M30*rat),sum(M29*rat),sum(M28*rat),sum(M27*rat),sum(M26*rat),sum(M25*rat),
	sum(M24*rat),sum(M23*rat),sum(M22*rat),sum(M21*rat),sum(M20*rat),sum(M19*rat),sum(M18*rat),sum(M17*rat),sum(M16*rat),sum(M15*rat),sum(M14*rat),sum(M13*rat), 
	sum(M12*rat),sum(M11*rat),sum(M10*rat),sum(M09*rat),sum(M08*rat),sum(M07*rat),sum(M06*rat),sum(M05*rat),sum(M04*rat),sum(M03*rat),sum(M02*rat),sum(M01*rat)
from (select distinct MktType, Mkt, MktName, Mole_Des, Mole_Cod,Pack_Cod,rat from tblQueryToolDriverHosp ) t1 
inner join tblHospitalDataCT t2 on t1.Pack_Cod=t2.Pack_Cod inner join tblHospitalList t3 on t2.CPA_ID=t3.Hosp_ID
group by DataType, MktType, Mkt, MktName, City_EN, Hosp_ID, Hosp_Des_EN, Tier, Mole_Des, Mole_Cod
go

--Append Class/Molecule level data:
Insert into tblOutput_Hosp_TA_Master
select 
	DataType, MktType, Mkt, MktName, City_EN as Geo
	, '2' as Geo_Lvl, 'H' as Grp_Lvl
	, Hosp_ID, Hosp_Des_EN, Tier
	, Class, Class as Class_Name
	, 'MO' as Prod_Lvl, 'N'
	, Mole_Des+' TOTAL', Mole_Cod
	, null, '000000000', null, '00000000000', null, null, null, 
	sum(M48*rat),sum(M47*rat),sum(M46*rat),sum(M45*rat),sum(M44*rat),sum(M43*rat),sum(M42*rat),sum(M41*rat),sum(M40*rat),sum(M39*rat),sum(M38*rat),sum(M37*rat),
	sum(M36*rat),sum(M35*rat),sum(M34*rat),sum(M33*rat),sum(M32*rat),sum(M31*rat),sum(M30*rat),sum(M29*rat),sum(M28*rat),sum(M27*rat),sum(M26*rat),sum(M25*rat),
	sum(M24*rat),sum(M23*rat),sum(M22*rat),sum(M21*rat),sum(M20*rat),sum(M19*rat),sum(M18*rat),sum(M17*rat),sum(M16*rat),sum(M15*rat),sum(M14*rat),sum(M13*rat), 
	sum(M12*rat),sum(M11*rat),sum(M10*rat),sum(M09*rat),sum(M08*rat),sum(M07*rat),sum(M06*rat),sum(M05*rat),sum(M04*rat),sum(M03*rat),sum(M02*rat),sum(M01*rat)
from (select distinct MktType, Mkt, MktName,Class, Mole_Des, Mole_Cod,Pack_Cod,rat from tblQueryToolDriverHosp ) t1 
inner join tblHospitalDataCT t2 on t1.Pack_Cod=t2.Pack_Cod inner join tblHospitalList t3 on t2.CPA_ID=t3.Hosp_ID
Where Mkt='NIAD'
group by DataType, MktType, Mkt, MktName, City_EN, Hosp_ID, Hosp_Des_EN, Tier, Class, Mole_Des, Mole_Cod
go

--Append Class level data:
Insert into tblOutput_Hosp_TA_Master
select DataType, MktType, Mkt, MktName, City_EN as Geo, '2' as Geo_Lvl, 'H' as Grp_Lvl, Hosp_ID, Hosp_Des_EN, 
	Tier, Class, Class + ' TOTAL' as Class_Name
	, 'CS' as Prod_Lvl, 'Y' as Uniq_Prod,
	null, '000000', null, '000000000', null, '00000000000', null, null, null, 
	sum(M48*rat),sum(M47*rat),sum(M46*rat),sum(M45*rat),sum(M44*rat),sum(M43*rat),sum(M42*rat),sum(M41*rat),sum(M40*rat),sum(M39*rat),sum(M38*rat),sum(M37*rat),
	sum(M36*rat),sum(M35*rat),sum(M34*rat),sum(M33*rat),sum(M32*rat),sum(M31*rat),sum(M30*rat),sum(M29*rat),sum(M28*rat),sum(M27*rat),sum(M26*rat),sum(M25*rat),
	sum(M24*rat),sum(M23*rat),sum(M22*rat),sum(M21*rat),sum(M20*rat),sum(M19*rat),sum(M18*rat),sum(M17*rat),sum(M16*rat),sum(M15*rat),sum(M14*rat),sum(M13*rat), 
	sum(M12*rat),sum(M11*rat),sum(M10*rat),sum(M09*rat),sum(M08*rat),sum(M07*rat),sum(M06*rat),sum(M05*rat),sum(M04*rat),sum(M03*rat),sum(M02*rat),sum(M01*rat)
from tblQueryToolDriverHosp_Prod t1 inner join tblHospitalDataCT t2 on t1.Pack_Cod=t2.Pack_Cod
inner join tblHospitalList t3 on t2.CPA_ID=t3.Hosp_ID
Where Mkt='NIAD'
group by DataType, MktType, Mkt, MktName, City_EN, Hosp_ID, Hosp_Des_EN, Tier, Class
go

--Append Manufacturer level data:
Insert into tblOutput_Hosp_TA_Master
select 
	DataType, MktType, Mkt, MktName, City_EN as Geo
	, '2' as Geo_Lvl, 'H' as Grp_Lvl
	, Hosp_ID, Hosp_Des_EN, Tier
	,  'MNF' as Class, null as Class_Name
	, 'MNF' as Prod_Lvl, 'Y' as Uniq_Prod
	,null, '000000', null, '000000000', null, '00000000000'
	,Manu_Des, Manu_Cod, MNC, 
	sum(M48*rat),sum(M47*rat),sum(M46*rat),sum(M45*rat),sum(M44*rat),sum(M43*rat),sum(M42*rat),sum(M41*rat),sum(M40*rat),sum(M39*rat),sum(M38*rat),sum(M37*rat),
	sum(M36*rat),sum(M35*rat),sum(M34*rat),sum(M33*rat),sum(M32*rat),sum(M31*rat),sum(M30*rat),sum(M29*rat),sum(M28*rat),sum(M27*rat),sum(M26*rat),sum(M25*rat),
	sum(M24*rat),sum(M23*rat),sum(M22*rat),sum(M21*rat),sum(M20*rat),sum(M19*rat),sum(M18*rat),sum(M17*rat),sum(M16*rat),sum(M15*rat),sum(M14*rat),sum(M13*rat), 
	sum(M12*rat),sum(M11*rat),sum(M10*rat),sum(M09*rat),sum(M08*rat),sum(M07*rat),sum(M06*rat),sum(M05*rat),sum(M04*rat),sum(M03*rat),sum(M02*rat),sum(M01*rat)
from tblQueryToolDriverHosp_Prod t1 
inner join tblHospitalDataCT t2 on t1.Pack_Cod=t2.Pack_Cod
inner join tblHospitalList t3 on t2.CPA_ID=t3.Hosp_ID
group by DataType, MktType, Mkt, MktName, City_EN
	, Hosp_ID, Hosp_Des_EN, Tier
	,Manu_Des, Manu_Cod, MNC
go

--Append Market level data:
Insert into tblOutput_Hosp_TA_Master
select DataType, MktType, Mkt, MktName+ ' TOTAL' as MktName
	, City_EN as Geo, '2' as Geo_Lvl, 'H' as Grp_Lvl
	, Hosp_ID, Hosp_Des_EN, Tier
	, 'MK' as Class, null as Class_Name, 'MK' as Prod_Lvl, 'Y' as Uniq_Prod,
	null, '000000', null, '000000000', null, '00000000000', null, null, null, 
	sum(M48*rat),sum(M47*rat),sum(M46*rat),sum(M45*rat),sum(M44*rat),sum(M43*rat),sum(M42*rat),sum(M41*rat),sum(M40*rat),sum(M39*rat),sum(M38*rat),sum(M37*rat),
	sum(M36*rat),sum(M35*rat),sum(M34*rat),sum(M33*rat),sum(M32*rat),sum(M31*rat),sum(M30*rat),sum(M29*rat),sum(M28*rat),sum(M27*rat),sum(M26*rat),sum(M25*rat),
	sum(M24*rat),sum(M23*rat),sum(M22*rat),sum(M21*rat),sum(M20*rat),sum(M19*rat),sum(M18*rat),sum(M17*rat),sum(M16*rat),sum(M15*rat),sum(M14*rat),sum(M13*rat), 
	sum(M12*rat),sum(M11*rat),sum(M10*rat),sum(M09*rat),sum(M08*rat),sum(M07*rat),sum(M06*rat),sum(M05*rat),sum(M04*rat),sum(M03*rat),sum(M02*rat),sum(M01*rat)
from (select distinct MktType, Mkt, MktName,Pack_Cod,rat from tblQueryToolDriverHosp_Prod) t1 
inner join tblHospitalDataCT t2 on t1.Pack_Cod=t2.Pack_Cod 
inner join tblHospitalList t3 on t2.CPA_ID=t3.Hosp_ID
group by DataType, MktType, Mkt, MktName, City_EN, Hosp_ID, Hosp_Des_EN, Tier
go

--Append Geo/Tier level data:
Insert into tblOutput_Hosp_TA_Master
select DataType, MktType, Mkt, Market_Name,  Geo, Geo_Lvl, 'G' as Grp_Lvl, '99999', null, Tier, Class, Class_Name, 
	Prod_Lvl, Uniq_Prod, Molecule_Name, Molecule_Code, Product_Name, Product_Code, Package_Name, Package_Code,  
	Manuf_Name, Manuf_Code, MNC, 
	sum(MTH_48),sum(MTH_47),sum(MTH_46),sum(MTH_45),sum(MTH_44),sum(MTH_43),sum(MTH_42),sum(MTH_41),sum(MTH_40),sum(MTH_39),sum(MTH_38),sum(MTH_37),
	sum(MTH_36),sum(MTH_35),sum(MTH_34),sum(MTH_33),sum(MTH_32),sum(MTH_31),sum(MTH_30),sum(MTH_29),sum(MTH_28),sum(MTH_27),sum(MTH_26),sum(MTH_25),
	sum(MTH_24),sum(MTH_23),sum(MTH_22),sum(MTH_21),sum(MTH_20),sum(MTH_19),sum(MTH_18),sum(MTH_17),sum(MTH_16),sum(MTH_15),sum(MTH_14),sum(MTH_13), 
	sum(MTH_12),sum(MTH_11),sum(MTH_10),sum(MTH_9),sum(MTH_8),sum(MTH_7),sum(MTH_6),sum(MTH_5),sum(MTH_4),sum(MTH_3),sum(MTH_2),sum(MTH_1)
from tblOutput_Hosp_TA_Master
group by DataType, MktType, Mkt, Market_Name,  Geo, Geo_Lvl, Tier, Class, Class_Name, Prod_Lvl, Uniq_Prod, Molecule_Name, 
	Molecule_Code, Product_Name, Product_Code, Package_Name, Package_Code,  Manuf_Name, Manuf_Code, MNC
go

--Append Geo level data:
Insert into tblOutput_Hosp_TA_Master
select DataType, MktType, Mkt, Market_Name,  Geo, Geo_Lvl, Grp_Lvl, '99999', null, 'TOTAL' as Tier, Class, Class_Name, Prod_Lvl, 
	Uniq_Prod, Molecule_Name, Molecule_Code, Product_Name, Product_Code, Package_Name, Package_Code,  Manuf_Name, Manuf_Code, MNC, 
	sum(MTH_48),sum(MTH_47),sum(MTH_46),sum(MTH_45),sum(MTH_44),sum(MTH_43),sum(MTH_42),sum(MTH_41),sum(MTH_40),sum(MTH_39),sum(MTH_38),sum(MTH_37),
	sum(MTH_36),sum(MTH_35),sum(MTH_34),sum(MTH_33),sum(MTH_32),sum(MTH_31),sum(MTH_30),sum(MTH_29),sum(MTH_28),sum(MTH_27),sum(MTH_26),sum(MTH_25),
	sum(MTH_24),sum(MTH_23),sum(MTH_22),sum(MTH_21),sum(MTH_20),sum(MTH_19),sum(MTH_18),sum(MTH_17),sum(MTH_16),sum(MTH_15),sum(MTH_14),sum(MTH_13), 
	sum(MTH_12),sum(MTH_11),sum(MTH_10),sum(MTH_9),sum(MTH_8),sum(MTH_7),sum(MTH_6),sum(MTH_5),sum(MTH_4),sum(MTH_3),sum(MTH_2),sum(MTH_1)
from tblOutput_Hosp_TA_Master 
where Grp_lvl='G'
group by DataType, MktType, Mkt, Market_Name, Geo, Geo_Lvl, Grp_Lvl, Class, Class_Name, Prod_Lvl, Uniq_Prod, Molecule_Name, 
	Molecule_Code, Product_Name, Product_Code, Package_Name, Package_Code, Manuf_Name, Manuf_Code, MNC
go

--Append China level data:
Insert into tblOutput_Hosp_TA_Master
select DataType, MktType, Mkt, Market_Name,  'CHINA' as Geo, 1 as Geo_Lvl, Grp_Lvl, '99999', null, Tier, Class, Class_Name, Prod_Lvl, 
	Uniq_Prod, Molecule_Name, Molecule_Code, Product_Name, Product_Code, Package_Name, Package_Code,  Manuf_Name, Manuf_Code, MNC, 
	sum(MTH_48),sum(MTH_47),sum(MTH_46),sum(MTH_45),sum(MTH_44),sum(MTH_43),sum(MTH_42),sum(MTH_41),sum(MTH_40),sum(MTH_39),sum(MTH_38),sum(MTH_37),
	sum(MTH_36),sum(MTH_35),sum(MTH_34),sum(MTH_33),sum(MTH_32),sum(MTH_31),sum(MTH_30),sum(MTH_29),sum(MTH_28),sum(MTH_27),sum(MTH_26),sum(MTH_25),
	sum(MTH_24),sum(MTH_23),sum(MTH_22),sum(MTH_21),sum(MTH_20),sum(MTH_19),sum(MTH_18),sum(MTH_17),sum(MTH_16),sum(MTH_15),sum(MTH_14),sum(MTH_13), 
	sum(MTH_12),sum(MTH_11),sum(MTH_10),sum(MTH_9),sum(MTH_8),sum(MTH_7),sum(MTH_6),sum(MTH_5),sum(MTH_4),sum(MTH_3),sum(MTH_2),sum(MTH_1)
from tblOutput_Hosp_TA_Master where Grp_Lvl='G'
group by DataType, MktType, Mkt, Market_Name, Grp_lvl, Tier, Class, Class_Name, Prod_Lvl, Uniq_Prod, Molecule_Name, 
	Molecule_Code, Product_Name, Product_Code, Package_Name, Package_Code, Manuf_Name, Manuf_Code, MNC
go
go

drop table tblOutput_Hosp_TA_Master_Inline_Mkt
go
select * into tblOutput_Hosp_TA_Master_Inline_Mkt from tblOutput_Hosp_TA_Master
where MktType='In-line Market' and Prod_Lvl='MK'
go
create index idxDataTypeInLineMkt 
on tblOutput_Hosp_TA_Master_InLine_Mkt(DataType, Mkt, Geo, Hosp_ID, Tier)
GO
--select top 10 * from tblOutput_Hosp_TA_Master_Inline(nolock)
--select * into tblOutput_Hosp_TA_Master_Inline_Staging from tblOutput_Hosp_TA_Master_Inline where 0=1

truncate table tblOutput_Hosp_TA_Master_Inline_Staging
go
Insert into tblOutput_Hosp_TA_Master_Inline_Staging
select *, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
from tblOutput_Hosp_TA_Master
where MktType='In-line Market'
go
Update tblOutput_Hosp_TA_Master_Inline_Staging
Set
	MTH_SHR_48 = (case t2.MTH_48 when 0 then 0 else t1.MTH_48*1.0/t2.MTH_48 end),
	MTH_SHR_47 = (case t2.MTH_47 when 0 then 0 else t1.MTH_47*1.0/t2.MTH_47 end),
	MTH_SHR_46 = (case t2.MTH_46 when 0 then 0 else t1.MTH_46*1.0/t2.MTH_46 end),
	MTH_SHR_45 = (case t2.MTH_45 when 0 then 0 else t1.MTH_45*1.0/t2.MTH_45 end),
	MTH_SHR_44 = (case t2.MTH_44 when 0 then 0 else t1.MTH_44*1.0/t2.MTH_44 end),
	MTH_SHR_43 = (case t2.MTH_43 when 0 then 0 else t1.MTH_43*1.0/t2.MTH_43 end),
	MTH_SHR_42 = (case t2.MTH_42 when 0 then 0 else t1.MTH_42*1.0/t2.MTH_42 end),
	MTH_SHR_41 = (case t2.MTH_41 when 0 then 0 else t1.MTH_41*1.0/t2.MTH_41 end),
	MTH_SHR_40 = (case t2.MTH_40 when 0 then 0 else t1.MTH_40*1.0/t2.MTH_40 end),
	MTH_SHR_39 = (case t2.MTH_39 when 0 then 0 else t1.MTH_39*1.0/t2.MTH_39 end),
	MTH_SHR_38 = (case t2.MTH_38 when 0 then 0 else t1.MTH_38*1.0/t2.MTH_38 end),
	MTH_SHR_37 = (case t2.MTH_37 when 0 then 0 else t1.MTH_37*1.0/t2.MTH_37 end),
	MTH_SHR_36 = (case t2.MTH_36 when 0 then 0 else t1.MTH_36*1.0/t2.MTH_36 end),
	MTH_SHR_35 = (case t2.MTH_35 when 0 then 0 else t1.MTH_35*1.0/t2.MTH_35 end),
	MTH_SHR_34 = (case t2.MTH_34 when 0 then 0 else t1.MTH_34*1.0/t2.MTH_34 end),
	MTH_SHR_33 = (case t2.MTH_33 when 0 then 0 else t1.MTH_33*1.0/t2.MTH_33 end),
	MTH_SHR_32 = (case t2.MTH_32 when 0 then 0 else t1.MTH_32*1.0/t2.MTH_32 end),
	MTH_SHR_31 = (case t2.MTH_31 when 0 then 0 else t1.MTH_31*1.0/t2.MTH_31 end),
	MTH_SHR_30 = (case t2.MTH_30 when 0 then 0 else t1.MTH_30*1.0/t2.MTH_30 end),
	MTH_SHR_29 = (case t2.MTH_29 when 0 then 0 else t1.MTH_29*1.0/t2.MTH_29 end),
	MTH_SHR_28 = (case t2.MTH_28 when 0 then 0 else t1.MTH_28*1.0/t2.MTH_28 end),
	MTH_SHR_27 = (case t2.MTH_27 when 0 then 0 else t1.MTH_27*1.0/t2.MTH_27 end),
	MTH_SHR_26 = (case t2.MTH_26 when 0 then 0 else t1.MTH_26*1.0/t2.MTH_26 end),
	MTH_SHR_25 = (case t2.MTH_25 when 0 then 0 else t1.MTH_25*1.0/t2.MTH_25 end),
	MTH_SHR_24 = (Case t2.MTH_24 When 0 Then 0 Else t1.MTH_24*1.0/t2.MTH_24 End), 
	MTH_SHR_23 = (Case t2.MTH_23 When 0 Then 0 Else t1.MTH_23*1.0/t2.MTH_23 End), 
	MTH_SHR_22 = (Case t2.MTH_22 When 0 Then 0 Else t1.MTH_22*1.0/t2.MTH_22 End), 
	MTH_SHR_21 = (Case t2.MTH_21 When 0 Then 0 Else t1.MTH_21*1.0/t2.MTH_21 End), 
	MTH_SHR_20 = (Case t2.MTH_20 When 0 Then 0 Else t1.MTH_20*1.0/t2.MTH_20 End), 
	MTH_SHR_19 = (Case t2.MTH_19 When 0 Then 0 Else t1.MTH_19*1.0/t2.MTH_19 End), 
	MTH_SHR_18 = (Case t2.MTH_18 When 0 Then 0 Else t1.MTH_18*1.0/t2.MTH_18 End), 
	MTH_SHR_17 = (Case t2.MTH_17 When 0 Then 0 Else t1.MTH_17*1.0/t2.MTH_17 End), 
	MTH_SHR_16 = (Case t2.MTH_16 When 0 Then 0 Else t1.MTH_16*1.0/t2.MTH_16 End), 
	MTH_SHR_15 = (Case t2.MTH_15 When 0 Then 0 Else t1.MTH_15*1.0/t2.MTH_15 End), 
	MTH_SHR_14 = (Case t2.MTH_14 When 0 Then 0 Else t1.MTH_14*1.0/t2.MTH_14 End), 
	MTH_SHR_13 = (Case t2.MTH_13 When 0 Then 0 Else t1.MTH_13*1.0/t2.MTH_13 End), 
	MTH_SHR_12 = (Case t2.MTH_12 When 0 Then 0 Else t1.MTH_12*1.0/t2.MTH_12 End), 
	MTH_SHR_11 = (Case t2.MTH_11 When 0 Then 0 Else t1.MTH_11*1.0/t2.MTH_11 End), 
	MTH_SHR_10 = (Case t2.MTH_10 When 0 Then 0 Else t1.MTH_10*1.0/t2.MTH_10 End), 
	MTH_SHR_9  = (Case t2.MTH_9  When 0 Then 0 Else t1.MTH_9*1.0/t2.MTH_9   End), 
	MTH_SHR_8  = (Case t2.MTH_8  When 0 Then 0 Else t1.MTH_8*1.0/t2.MTH_8   End), 
	MTH_SHR_7  = (Case t2.MTH_7  When 0 Then 0 Else t1.MTH_7*1.0/t2.MTH_7   End), 
	MTH_SHR_6  = (Case t2.MTH_6  When 0 Then 0 Else t1.MTH_6*1.0/t2.MTH_6   End), 
	MTH_SHR_5  = (Case t2.MTH_5  When 0 Then 0 Else t1.MTH_5*1.0/t2.MTH_5   End), 
	MTH_SHR_4  = (Case t2.MTH_4  When 0 Then 0 Else t1.MTH_4*1.0/t2.MTH_4   End), 
	MTH_SHR_3  = (Case t2.MTH_3  When 0 Then 0 Else t1.MTH_3*1.0/t2.MTH_3   End), 
	MTH_SHR_2  = (Case t2.MTH_2  When 0 Then 0 Else t1.MTH_2*1.0/t2.MTH_2   End), 
	MTH_SHR_1  = (Case t2.MTH_1  When 0 Then 0 Else t1.MTH_1*1.0/t2.MTH_1   End)
from tblOutput_Hosp_TA_Master_Inline_Staging t1 
inner join tblOutput_Hosp_TA_Master_InLine_Mkt t2
on t1.DataType=t2.DataType and t1.Mkt=t2.Mkt and t1.Geo=t2.Geo and t1.Hosp_ID=t2.Hosp_ID and t1.Tier=t2.Tier
go

--Add CPA_Code and DataSource column
--Alince Wang updated for adding PHA code for PHA datasource
if object_id(N'tblOutput_Hosp_TA_Master_Inline',N'U') is not null
	drop table tblOutput_Hosp_TA_Master_Inline
go	
select a.*, case when b.DataSource is not null then DataSource else null end as DataSource,
	case when b.DataSource ='Sea' then '#N/A'
		 when b.DataSource ='CPA' then cpa_code
		 when b.DataSource ='PHA' then (select CPA_CODE from tblHospitalMaster c where a.Hosp_Des_EN=c.cpa_name_english)
		 else null end as [CPA_Code(PHA_Code)]
into tblOutput_Hosp_TA_Master_Inline		 
from tblOutput_Hosp_TA_Master_Inline_Staging  a 
left join (select * from tblHospitalmaster where id is not null) b 
on case when a.Hosp_id='99999' then null else a.Hosp_id end=b.id
go

create nonclustered index idx_tblOutput_Hosp_TA_Master_Inline_DataType 
on tblOutput_Hosp_TA_Master_Inline (DataType)

exec dbo.sp_Log_Event 'Process','QT_CPA_Inline','Step_3_Create_Output_Hosp_TA_Master_Tables.sql','End',null,null
