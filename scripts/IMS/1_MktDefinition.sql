USE BMSChinaCIA_IMS
GO
--  这个脚本跑完以后，CPA 以及 QueryTool就可以开始跑了。



--7min
--3min







print (N'
---------------------------------------
             Dim_Gene  
---------------------------------------
')
if object_id(N'Dim_Gene', N'U') is not null 
	Drop table Dim_Gene
go

select distinct PROD_COD, GENE_COD 
into Dim_Gene 
from (
     select distinct PROD_COD, GENE_COD from DB82.TempOutput.DBO.MTHCHPA_PKAU
     union all
    --  select distinct PROD_COD, GENE_COD from DB82.TempOutput.DBO.MTHCITY_PKAU
     select distinct PROD_COD, GENE_COD from BMSChinaCIA_IMS.dbo.Max_Data
     ) a 
go





/*

处理时间：2013/6/14 10:21:11
处理内容：将Prod_Des='Anzatax'转换为竞品

insert into tblMktDef_MRBIChina_correct
select distinct 
    'ONCFCS' as Mkt,'Oncology Focused Brands' as MktName
  , '860' as Prod,Prod_Des as ProductName
  , 'N' as Molecule
  , 'N' as Class
  , ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
  , pack_cod,Pack_des
  , Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
  , '' as Mole_cod,'' as Mole_Name
  , Corp_cod
  , Manu_Cod
  , Gene_Cod
  , 'Y' as Active
  , GetDate() as Date, '201203 add new packages of focused brands' 
from tblMktDef_ATCDriver
where Prod_Des='Anzatax'


select * from tblMktDef_MRBIChina_correct 
where prod between '100' and '899' and productname not like '%other%' and Mkt = 'ONCFCS'
order by Prod

--added by Alince
insert into tblMktDef_MRBIChina_correct 
SELECT distinct 'NIAD' Mkt,'NIAD Market' MktName,
	'300' as Prod,'Byetta' as ProductName,
	'N' as Molecule, 'N' as Class,
	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
	'' Mole_cod,'' Mole_Name,
	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
	GetDate() as Date, '201203 add new products & packages'
	--,1--rat
FROM tblMktDef_Inline A 
WHERE A.MKT = 'NIAD' and prod_des like 'Byetta%' and not exists (select * from tblMktDef_MRBIChina_correct b where a.pack_cod=b.pack_cod)
--
insert into tblMktDef_MRBIChina_correct
select distinct 
    'ARV' as Mkt,'ARV mARKET' as MktName
  , '860' as Prod,Prod_Des as ProductName
  , 'N' as Molecule
  , 'N' as Class
  , ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
  , pack_cod,Pack_des
  , Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
  , '' as Mole_cod,'' as Mole_Name
  , Corp_cod
  , Manu_Cod
  , Gene_Cod
  , 'Y' as Active
  , GetDate() as Date, '' 
from tblMktDef_ATCDriver
where Prod_Des='viread'
*/



exec dbo.sp_Log_Event 'MktDef','CIA','1_MktDefinition.sql','tblMktDef_ATCDriver',null,null

print (N'
------------------------------------------------------------------------------------------------------------
1. tblMktDef_ATCDriver   : Including all prod,package
------------------------------------------------------------------------------------------------------------
')
IF OBJECT_ID(N'tblMktDef_ATCDriver',N'U') IS NOT NULL
  DROP TABLE tblMktDef_ATCDriver
GO
select distinct 
	left(h.Therapeutic_Code,1) ATC1_Cod,cast(null as varchar(255)) ATC1_Des,
	left(h.Therapeutic_Code,3) ATC2_Cod,cast(null as varchar(255)) ATC2_Des,
	left(h.Therapeutic_Code,4) ATC3_Cod,cast(null as varchar(255)) ATC3_Des,
	h.Therapeutic_Code ATC4_Cod, h.Therapeutic_Name ATC4_Des,
	d.Molecule_code Mole_cod, d.Molecule_Name Mole_des,
	b.Product_Code Prod_cod,b.Product_Name Prod_Des,
	a.Pack_Code Pack_Cod,b.Product_Name + ' ' + a.Pack_Description Pack_Des,
	g.manufacturer_abbr Corp_cod, g.Manufacturer_Name Corp_Des,
	e.manufacturer_abbr manu_cod, e.Manufacturer_Name Manu_des,
	case f.ManufacturerType_Code when 'L' then 'N' else 'Y' end MNC,
	'' as Gene_Cod
into tblMktDef_ATCDriver
from Dim_Pack a
inner join Dim_Product b on a.Product_id = b.Product_ID
inner join Dim_Product_Molecule c on b.Product_id = c.Product_id
inner join Dim_Molecule d on c.molecule_id = d.molecule_id
inner join Dim_Manufacturer e on b.Manufacturer_id = e.Manufacturer_id
inner join Dim_Manufacturer g on e.corporation_id = g.Manufacturer_ID
inner join Dim_ManufacturerType f on e.ManufacturerType_ID = f.ManufacturerType_ID
inner join Dim_Therapeutic_Class h on a.Therapeutic_ID = h.Therapeutic_ID
go

-- insert new data from maxdata 
-- insert into tblMktDef_ATCDriver 
-- select distinct 
-- 	a.ATC1_Cod, a.ATC1_Des,
-- 	a.ATC2_Cod, a.ATC2_Des,
-- 	a.ATC3_Cod, a.ATC3_Des,
-- 	a.ATC4_Cod, a.ATC4_Des,
-- 	a.Mole_cod, a.Mole_des,
-- 	a.Prod_cod, a.Prod_Des,
-- 	a.Pack_Cod, a.Pack_Des,
-- 	a.Corp_cod, a.Corp_Des,
-- 	a.manu_cod, a.Manu_des,
-- 	a.MNC, a.Gene_Cod
-- from Max_Data as a 
-- left join tblMktDef_ATCDriver as b on a.pack_cod = b.Pack_Cod
-- where b.Pack_Cod is null 

-- 20161102 添加分子式:LOW MOLECULAR WEIGHT HEPARIN CALCIUM
insert into dbo.tblMktDef_ATCDriver ( ATC1_Cod, ATC1_Des, ATC2_Cod, ATC2_Des, ATC3_Cod, ATC3_Des, ATC4_Cod, ATC4_Des,
									   Mole_cod, Mole_des, Prod_cod, Prod_Des, Pack_Cod, Pack_Des, Corp_cod, Corp_Des,
									   manu_cod, Manu_des, MNC, Gene_Cod )
select '', '', '', '', '', '', '', '', 
	'904100', 'LOW MOLECULAR WEIGHT HEPARIN CALCIUM', '', '', '', '', '', '',
	'', '', '', ''
go

update a set atc3_des = b.Therapeutic_Name
from tblMktDef_ATCDriver a
inner join Dim_Therapeutic_Class b on a.atc3_cod = b.Therapeutic_Code
go

update a set atc2_des = b.Therapeutic_Name
from tblMktDef_ATCDriver a
inner join Dim_Therapeutic_Class b on a.atc2_cod = b.Therapeutic_Code
go

update a set atc1_des = b.Therapeutic_Name
from tblMktDef_ATCDriver a
inner join Dim_Therapeutic_Class b on a.atc1_cod = b.Therapeutic_Code
go

update a set MNC = 'Y'
from tblMktDef_ATCDriver a
where exists(select * from tblMktDef_ATCDriver b where a.corp_cod = b.corp_cod and b.MNC='Y')
go

update tblMktDef_ATCDriver set Gene_Cod = 'U'
go

update a set Gene_cod = b.Gene_cod
from tblMktDef_ATCDriver a
inner join Dim_Gene b on A.PROD_COD=B.PROD_COD
go

create nonclustered index idx on tblMktDef_ATCDriver(pack_cod)
create nonclustered index idx_prod on tblMktDef_ATCDriver(prod_cod)
go
-- select top 100 * from tblMktDef_ATCDriver



exec dbo.sp_Log_Event 'MktDef','CIA','1_MktDefinition.sql','tblMktDef_Inline',null,null
print (N'
------------------------------------------------------------------------------------------------------------
2. tblMktDef_Inline
------------------------------------------------------------------------------------------------------------
')

--if object_id(N'tblMktDef_Inline_For_CCB',N'U') is not null
--  drop table tblMktDef_Inline_For_CCB
--go


if object_id(N'tblMktDef_Inline',N'U') is not null
  drop table tblMktDef_Inline
go

----1. HBV Market
select cast('HBV' as varchar(50)) as Mkt,cast('HBV Market' as varchar(50)) as MktName,* 
into tblMktDef_Inline
from tblMktDef_ATCDriver
where (ATC3_cod in ('L03B','A05B','J05B','L03A') and Mole_cod not in ( 
	'610925','210312','033500','707310','620000','397400','138632','508040',
	'631900','709942','508271','630280','092630','627920','628650','001212','385534','058650',
	'701103','057580','032300','077171','505500','415360','415180','029050','507991','163600',
	'108850','507996','405400','507317','092620','401600','615025','631050','413460','900163',
	'339200','415535','508561','415437','416955','413440','034200','400250','403600','413840',
	'418200','507929','415350','700720','508379','384635','900010'
	)) or (ATC3_Cod ='J05C' and mole_cod ='707580')  --todo 'TENOFOVIR DISOPROXIL' 的ATC3_Cod ='J05C' and mole_cod ='707580'
go

	---1.1 ARV Market
insert into tblMktDef_Inline
select 
	'ARV' as Mkt,'ARV Market' as MktName,
	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
	Mole_cod,Mole_des,
	Prod_cod,Prod_Des,
	Pack_Cod,Pack_Des,
	Corp_cod,Corp_Des,
	manu_cod,Manu_des,
	MNC,Gene_Cod      
from tblMktDef_Inline
where 
  Mkt = 'HBV' 
  and Mole_des in ('Entecavir','Lamivudine','Adefovir Dipivoxil','Telbivudine','Tenofovir Disoproxil')    --todo 20150115博路定市场定义新增分子式TENOFOVIR DISOPROXIL
  and Prod_des <> 'Epivir'
go

-- ----2. Diabetes Market
-- insert into tblMktDef_Inline
-- select cast('DIA' as varchar(50)) as Mkt,cast('Diabetes Market' as varchar(50)) as MktName,* 
-- from tblMktDef_ATCDriver
-- where ATC2_cod ='A10' 
-- 	and ATC3_cod <>'A10E' and ATC3_Cod<>'A10X' --Added by Xiaoyu.chen on 20131023
-- go

-- 	---2.1 Insulin Market
-- insert into tblMktDef_Inline
-- select 'Insulin' as Mkt,'Insulin Market' as MktName,
-- 	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
-- 	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
-- 	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
-- from tblMktDef_Inline
-- where Mkt = 'Dia' and ATC3_cod in ('A10C','A10D')--,'A10E'):Change this line scripts by Xiaoyu.Chen on 20131023
-- go

-- 	---2.2 NIAD Market
-- insert into tblMktDef_Inline
-- select 'NIAD' as Mkt,'NIAD Market' as MktName,
-- 	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
-- 	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
-- 	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
-- from tblMktDef_Inline
-- where Mkt = 'Dia' and ATC3_cod in ('A10S','A10N','A10M','A10L','A10K','A10J','A10H')
-- go

-- 		--2.2.1 AGI Class
-- insert into tblMktDef_Inline
-- select 'AGI' as Mkt,'AGI Class' as MktName,
-- 	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
-- 	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
-- 	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
-- from tblMktDef_Inline
-- where Mkt = 'NIAD' and ATC3_cod  = 'A10L'
-- go

-- 		--2.2.2 BI Class
-- insert into tblMktDef_Inline
-- select 'BI' as Mkt,'BI Class' as MktName,
-- 	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
-- 	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
-- 	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
-- from tblMktDef_Inline
-- where Mkt = 'NIAD' and ATC3_cod  = 'A10J'
-- go

-- 		--2.2.3 DPP4 Class
-- insert into tblMktDef_Inline
-- select 'DPP4' as Mkt,'DPP4 Class' as MktName,
-- 	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
-- 	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
-- 	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
-- from tblMktDef_Inline
-- where Mkt = 'NIAD' and ATC3_cod  = 'A10N'
-- go

-- 		--2.2.4 GLIN Class
-- insert into tblMktDef_Inline
-- select 'GLIN' as Mkt,'GLIN Class' as MktName,
-- 	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
-- 	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
-- 	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
-- from tblMktDef_Inline
-- where Mkt = 'NIAD' and ATC3_cod  = 'A10M'
-- go

-- 		--2.2.5 GLP1 Class
-- insert into tblMktDef_Inline
-- select 'GLP1' as Mkt,'GLP1 Class' as MktName,
-- 	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
-- 	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
-- 	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
-- from tblMktDef_Inline
-- where Mkt = 'NIAD' and ATC3_cod  = 'A10S'
-- go

-- 		--2.2.6 SU Class
-- insert into tblMktDef_Inline
-- select 'SU' as Mkt,'SU Class' as MktName,
-- 	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
-- 	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
-- 	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
-- from tblMktDef_Inline
-- where Mkt = 'NIAD' and ATC3_cod  = 'A10H'
-- go

-- 		--2.2.7 TZD Class
-- insert into tblMktDef_Inline
-- select 'TZD' as Mkt,'TZD Class' as MktName,
-- 	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
-- 	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
-- 	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
-- from tblMktDef_Inline
-- where Mkt = 'NIAD' and ATC3_cod  = 'A10K'
-- go

-- 	--2.3 OAD Market
-- insert into tblMktDef_Inline
-- select 'OAD' as Mkt,'OAD Market' as MktName,
-- 	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
-- 	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
-- 	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
-- from tblMktDef_Inline
-- where Mkt = 'Dia' and ATC3_cod in ('A10N','A10M','A10L','A10K','A10J','A10H')
-- go

----3. Hypertension Market
insert into tblMktDef_Inline
select cast('HYP' as varchar(50)) as Mkt,cast('Hypertension Market' as varchar(50)) as MktName,* 
from tblMktDef_ATCDriver
where ATC2_cod in('C03','C02','C07','C09','C08')
go

	--3.1 ACEI Class
insert into tblMktDef_Inline
select 'ACEI' as Mkt,'ACEI Class' as MktName,
	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
from tblMktDef_Inline
where Mkt = 'HYP' and ATC3_cod ='C09A'
go

	--3.2 ARB Class
insert into tblMktDef_Inline
select 'ARB' as Mkt,'ARB Class' as MktName,
	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
from tblMktDef_Inline
where Mkt = 'HYP' and ATC3_cod ='C09C'
go

	--3.3 BB Class
insert into tblMktDef_Inline
select 'BB' as Mkt,'BB Class' as MktName,
	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
from tblMktDef_Inline
where Mkt = 'HYP' and ATC3_cod in('C07A','C07B')
GO

	--3.4 CCB Class
insert into tblMktDef_Inline
select 'CCB' as Mkt,'CCB Class' as MktName,
	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
from tblMktDef_Inline
where Mkt = 'HYP' and ATC2_cod ='C08'
go

	--3.5 Monopril Focused Market
insert into tblMktDef_Inline
select 'Monopril' as Mkt,'Monopril Focused Market' as MktName,
	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
from tblMktDef_Inline
where Mkt = 'HYP' and Prod_cod in ('07279','02433','02380','11350')
go

----4. Oncology Market
insert into tblMktDef_Inline
select cast('ONC' as varchar(50)) as Mkt,cast('Oncology Market' as varchar(50)) as MktName,* 
from tblMktDef_ATCDriver
where ATC2_cod in('L01','L02')
go

	--4.1 Antineoplastics
insert into tblMktDef_Inline
select 'Antineoplastics' as Mkt,'Antineoplastics' as MktName,
	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
from tblMktDef_Inline
where Mkt = 'ONC' and ATC4_cod IN('L01A0','L01B0','L01C0','L01D0','L01X2')
go

	--4.2 Target Therapy
insert into tblMktDef_Inline
select 'Target Therapy' as Mkt,'Target Therapy' as MktName,
	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
from tblMktDef_Inline
where Mkt = 'ONC' and ATC4_cod IN('L01X3','L01X4')
go

	--4.3 ONC Others
insert into tblMktDef_Inline
select 'ONC Others' as Mkt,'ONC Others' as MktName,
	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
from tblMktDef_Inline
where Mkt = 'ONC' and ATC4_cod IN('L01X1','L01X9')
go

	--4.4 CHT
insert into tblMktDef_Inline
select 'CHT' as Mkt,'Cytostatic Hormone Therapy' as MktName,
	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
from tblMktDef_Inline
where Mkt = 'ONC' and ATC2_COD = 'L02'
go

	--4.5 ONCFCS
insert into tblMktDef_Inline
select 'ONCFCS' as Mkt,'Oncology Focused Brands' as MktName,
	ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des,
	Mole_cod,Mole_des,Prod_cod,Prod_Des,Pack_Cod,Pack_Des,
	Corp_cod,Corp_Des,manu_cod,Manu_des,MNC,Gene_Cod
from tblMktDef_Inline
where Mkt = 'ONC' and Mole_des in ('Paclitaxel','Docetaxel','Gemcitabine')
go

----5. CML
insert into tblMktDef_Inline
select cast('CML' as varchar(50)) as Mkt,cast('Sprycel Market' as varchar(50)) as MktName,* 
from tblMktDef_ATCDriver
where Mole_cod in ('706886','718136','716708')
go

-- ----6. Platinum Market
-- insert into tblMktDef_Inline
-- select cast('PLATINUM' as varchar(50)) as Mkt,cast('Platinum Market' as varchar(50)) as MktName,* 
-- from tblMktDef_ATCDriver
-- where Mole_cod in ('031172','501750','398650')
-- go

----7. Eliquis VTEp Market

/*
prod_cod	prod_des
06253	FRAXIPARINE
08621	CLEXANE
40785	XARELTO
53099	ELIQUIS
*/
--add new product for Eliquis VTEp market:( ARIXTRA)
-- insert into tblMktDef_Inline
-- select cast('ELIQUIS VTEp' as varchar(50)) as Mkt,cast('Eliquis (VTEp) Market' as varchar(50)) as MktName,* 
-- from tblMktDef_ATCDriver
-- where prod_cod in ('40785','06253','08621','53099','37977') 

-- 20161102 
-- modify the eliquis vtep market to contain these molecure: 
-- APIXABAN
-- RIVAROXABAN
-- DABIGATRAN ETEXILATE
-- ENOXAPARIN SODIUM
-- DALTEPARIN SODIUM
-- LOW MOLECULAR WEIGHT HEPARIN
-- HEPARIN
-- FONDAPARINUX SODIUM
-- NADROPARIN CALCIUM
-- and add new molecure: LOW MOLECULAR WEIGHT HEPARIN CALCIUM

-- insert into tblMktDef_Inline
-- select cast('ELIQUIS VTEp' as varchar(50)) as Mkt,cast('Eliquis (VTEp) Market' as varchar(50)) as MktName,* 
-- from tblMktDef_ATCDriver
-- where Mole_cod in ('406260','408800','408827','413885','703259','704307','711981','719372', '904100') 




-- ----7.1 Eliquis(NOAC) Market

-- --add new product for Eliquis NOAC market: ('Eliquis','XARELTO','PRADAXA')
-- insert into tblMktDef_Inline
-- select cast('ELIQUIS NOAC' as varchar(50)) as Mkt,cast('Eliquis (NOAC) Market' as varchar(50)) as MktName,* 
-- from tblMktDef_ATCDriver
-- where prod_cod in ('40785','52911','53099') 

-- -- 20161102 add VTEt
-- ----7.2 Eliquis(VTEt) Market
-- insert into tblMktDef_Inline
-- select cast('ELIQUIS VTEt' as varchar(50)) as Mkt,cast('Eliquis (VTEt) Market' as varchar(50)) as MktName,* 
-- from tblMktDef_ATCDriver
-- where Mole_cod in ('406260','408800','408827','413885','703259','704307','711981','239900', '904100') 


----8. OTC Markets



exec dbo.sp_Log_Event 'MktDef','CIA','1_MktDefinition.sql','tblMktDef_MRBIChina',null,null
print (N'
------------------------------------------------------------------------------------------------------------
3. tblMktDef_MRBIChina
------------------------------------------------------------------------------------------------------------
')


truncate table tblMktDef_MRBIChina
go
insert into tblMktDef_MRBIChina
select distinct 
    a.Mkt,a.MktName
  , a.Prod,a.ProductName
  , a.Molecule
  , a.Class
  , a.ATC1_Cod
  , a.ATC2_Cod
  , a.ATC3_Cod
  , a.ATC4_Cod
  , b.pack_cod, b.Pack_des
  , b.Prod_cod,b.Prod_des as Prod_Name
  , b.Prod_des + ' (' +b.Manu_cod +')' as Prod_FullName
  , '' as Mole_cod
  ,'' as Mole_Name
  , b.Corp_cod
  , b.Manu_Cod
  , b.Gene_Cod
  , 'Y' as Active
  , GetDate() as Date, '201203 add new packages of focused brands' 
  ,1--rat
from (
     select distinct 
		Mkt,MktName
		,Prod,dbo.fun_upperFirst(ProductName)  as ProductName
		,Molecule
		,Class
		,ATC1_cod,ATC2_cod,ATC3_cod,ATC4_cod
		,Prod_cod
	--     ,corp_cod
	--     ,manu_cod
	--     ,gene_cod
	--     ,active
     from tblMktDef_MRBIChina_correct d
     where prod between '100' and '899' and productname not like '%other%'
) a 
inner join tblMktDef_ATCDriver b 
on a.atc1_cod = b.atc1_cod
   and a.atc2_cod = b.atc2_cod
   and a.atc3_cod = b.atc3_cod
   and a.atc4_cod = b.atc4_cod
   and a.Prod_cod = b.Prod_cod
go
--CML 000
insert into tblMktDef_MRBIChina
SELECT distinct 
  Mkt,MktName
  ,'000' as Prod
  ,'Sprycel Market' as ProductName
  ,'Y' as Molecule
  ,'N' as Class
  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
  ,pack_cod, Pack_des
  ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
  ,'' Mole_cod,'' Mole_Name
  ,Corp_cod
  ,Manu_Cod
  ,Gene_Cod
  ,'Y' as Active
  ,GetDate() as Date, '201203 add new products & packages'
  ,1--rat
FROM tblMktDef_Inline A 
WHERE A.MKT = 'CML'
GO

go
-- CML: 010,020,030
insert into tblMktDef_MRBIChina
SELECT distinct 
  Mkt,MktName
  ,case a.Mole_des when 'DASATINIB' then '010'
                   when 'IMATINIB' then '020'
                   when 'NILOTINIB' then '030' end as  Prod
  ,a.Mole_des as ProductName
  ,'Y' as Molecule
  ,'N' as Class
  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
  ,pack_cod,Pack_des
  ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
  ,'' Mole_cod,'' Mole_Name
  ,Corp_cod
  ,Manu_Cod
  ,Gene_Cod
  ,'Y' as Active
  ,GetDate() as Date, '201203 add new products & packages'
  ,1--rat
FROM tblMktDef_Inline A 
WHERE A.MKT = 'CML' 
GO


--Onc 000
insert into tblMktDef_MRBIChina
SELECT distinct 
  'ONC' Mkt,'Oncology Market' MktName
  ,'000' as Prod,'Oncology Market' as ProductName
  ,'N' as Molecule
  ,'N' as Class
  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
  ,pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
  ,'' Mole_cod,'' Mole_Name
  ,Corp_cod
  , Manu_Cod
  , Gene_Cod
  , 'Y' as Active
  ,GetDate() as Date, '201203 add new products & packages'
  ,1--rat
FROM tblMktDef_Inline A 
WHERE A.MKT = 'onc' 
GO

--Onc 910--940
insert into tblMktDef_MRBIChina
SELECT distinct 
  'ONC' Mkt,'Oncology Market' MktName
  ,case a.Mkt when 'Antineoplastics' then '910' 
              when 'Target Therapy' then '920' 
              when 'CHT' then '930' 
              when 'ONC Others' then '940' end as Prod
  ,a.mkt as ProductName
  ,'N' as Molecule
  ,'Y' as Class
  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
  ,pack_cod, Pack_des
  ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
  ,'' Mole_cod
  ,'' Mole_Name
  ,Corp_cod
  , Manu_Cod
  , Gene_Cod
  , 'Y' as Active
  ,GetDate() as Date, '201203 add new products & packages'
  ,1--rat
FROM tblMktDef_Inline A 
WHERE A.MKT in('Antineoplastics','Target Therapy','CHT','ONC Others') 
GO

-- ONCFCS 000
insert into tblMktDef_MRBIChina
SELECT distinct 
  'ONCFCS' Mkt,'Oncology Focused Brands' MktName
  ,'000' as Prod,'Oncology Focused Brands' as ProductName
  ,'N' as Molecule
  ,'N' as Class
  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
  ,pack_cod, Pack_des
  ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
  ,'' Mole_cod
  ,'' Mole_Name
  ,Corp_cod
  ,Manu_Cod
  ,Gene_Cod
  ,'Y' as Active
  ,GetDate() as Date, '201203 add new products & packages' as Comment
  ,1--rat
FROM tblMktDef_Inline A WHERE A.MKT = 'ONCFCS'
GO
insert into tblMktDef_MRBIChina
SELECT distinct 
  'ONCFCS' Mkt,'Oncology Focused Brands' MktName
  ,'000' as Prod,'Oncology Focused Brands' as ProductName
  ,'Y' as Molecule
  ,'N' as Class
  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
  ,pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
  ,'' Mole_cod
  ,'' Mole_Name
  ,Corp_cod
  ,Manu_Cod
  ,Gene_Cod
  ,'Y' as Active
  ,GetDate() as Date, '201203 add new products & packages'
  ,1--rat
FROM tblMktDef_Inline A WHERE A.MKT = 'ONCFCS'
GO

-- ONCFCS 990
insert into tblMktDef_MRBIChina
SELECT distinct 
  'ONCFCS' Mkt,'Oncology Focused Brands' MktName
  ,'990' as Prod,'ONCFCS Others' as ProductName
  ,'N' as Molecule
  ,'N' as Class
  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
  ,pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
  ,'' Mole_cod,'' Mole_Name
  ,Corp_cod
  ,Manu_Cod
  ,Gene_Cod
  ,'Y' as Active
  ,GetDate() as Date, '201203 add new products & packages'
  ,1--rat
FROM tblMktDef_Inline A 
WHERE A.MKT = 'ONCFCS' and NOT EXISTS(
                                     SELECT * FROM tblMktDef_MRBIChina B 
                                     WHERE B.MKT = 'ONCFCS' 
                                     AND B.Class='N' and B.molecule='N' 
                                     AND B.PROD between '100' and '990'
                                     AND A.PACK_COD = B.PACK_COD and a.atc3_cod=b.atc3_cod
                                     )
GO
-- ONCFCS: 010,020,030
insert into tblMktDef_MRBIChina
SELECT distinct 
  Mkt,MktName
  ,case a.Mole_des when 'Gemcitabine' then '010'
                   when 'Docetaxel' then '020'
                   when 'Paclitaxel' then '030' end as  Prod
  ,a.Mole_des as ProductName
  ,'Y' as Molecule
  ,'N' as Class
  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
  ,pack_cod, Pack_des
  ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
  ,'' Mole_cod,'' Mole_Name
  ,Corp_cod
  ,Manu_Cod
  ,Gene_Cod
  ,'Y' as Active
  ,GetDate() as Date, '201203 add new products & packages'
  ,1--rat
FROM tblMktDef_Inline A 
WHERE A.MKT = 'ONCFCS' 
GO
update tblMktDef_MRBIChina set ProductName = 'Gemcitabine' where Prod = '010' and Mkt = 'ONCFCS'
go
update tblMktDef_MRBIChina set ProductName = 'Docetaxel' where Prod = '020' and Mkt = 'ONCFCS'
go
update tblMktDef_MRBIChina set ProductName = 'Paclitaxel' where Prod = '030' and Mkt = 'ONCFCS'
go





-- HBV 000
insert into tblMktDef_MRBIChina
SELECT distinct Mkt,MktName,'000' as Prod,'HBV Market' as ProductName,
	'N' as Molecule, 'N' as Class,
	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
	'' Mole_cod,'' Mole_Name,
	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
	GetDate() as Date, '201203 add new products & packages'
	,1--rat
FROM tblMktDef_Inline A 
WHERE A.MKT = 'HBV' 
GO

-- HBV 910
insert into tblMktDef_MRBIChina
SELECT distinct 'HBV','HBV Market','910' as Prod,'ARV Market' as ProductName,
	'N' as Molecule, 'Y' as Class,
	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
	'' Mole_cod,'' Mole_Name,
	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
	GetDate() as Date, '201203 add new products & packages'
	,1--rat
FROM tblMktDef_Inline A 
WHERE A.MKT = 'ARV' 
GO

-- ARV 000
if object_id(N'tmpMD',N'U') is not null
	drop table tmpMD
go
select * into tmpMD from (

	SELECT distinct Mkt,MktName,'000' as Prod,'ARV Market' as ProductName,
		'Y' as Molecule, 'N' as Class,
		ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
		pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
		Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
		'' Mole_cod,'' Mole_Name,
		Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
		GetDate() as Date, '201203 add new products & packages' as comment
		,1 as rat--rat
	FROM tblMktDef_Inline A 
	WHERE A.MKT = 'ARV'
	union all
	SELECT distinct Mkt,MktName,'000' as Prod,'ARV Market' as ProductName,
		'N' as Molecule, 'N' as Class,
		ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
		pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
		Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
		'' Mole_cod,'' Mole_Name,
		Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
		GetDate() as Date, '201203 add new products & packages' as comment
		,1 as rat--rat
	FROM tblMktDef_Inline A 
	WHERE A.MKT = 'ARV' 
) a
GO

insert into tblMktDef_MRBIChina
select * from tmpMD
go


-- ARV: 010,020,030,040,050 --todo add 050
insert into tblMktDef_MRBIChina
SELECT distinct Mkt,MktName,
	case a.Mole_des
	when 'Entecavir' then '010'
	when 'Adefovir Dipivoxil' then '020'
	when 'Lamivudine' then '030'
	when 'Telbivudine' then '040'
	when 'Tenofovir Disoproxil' then '050'
	end as  Prod,a.Mole_des as ProductName,
	'Y' as Molecule, 'N' as Class,
	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
	'' Mole_cod,'' Mole_Name,
	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
	GetDate() as Date, '201203 add new products & packages'
	,1--rat
FROM tblMktDef_Inline A 
WHERE A.MKT = 'ARV' 
GO
update tblMktDef_MRBIChina set ProductName = 'Entecavir' where Prod = '010' and Mkt = 'ARV'
go
update tblMktDef_MRBIChina set ProductName = 'Adefovir Dipivoxil' where Prod = '020' and Mkt = 'ARV'
go
update tblMktDef_MRBIChina set ProductName = 'Lamivudine' where Prod = '030' and Mkt = 'ARV'
go
update tblMktDef_MRBIChina set ProductName = 'Telbivudine' where Prod = '040' and Mkt = 'ARV'
go
update tblMktDef_MRBIChina set ProductName = 'Tenofovir Disoproxil' where Prod = '050' and Mkt = 'ARV'
go

-- ARV: Other Enecavir
insert into tblMktDef_MRBIChina
SELECT distinct Mkt,MktName,
	'700','Other Entecavir',
	'N' as Molecule, 'N' as Class,
	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
	'' Mole_cod,'' Mole_Name,
	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
	GetDate() as Date, '201203 add new products & packages'
	,1--rat
FROM tblMktDef_Inline A 
WHERE A.MKT = 'ARV' AND A.MOLE_DES = 'Entecavir'
and NOT EXISTS(
	SELECT * FROM tblMktDef_MRBIChina B 
	WHERE B.MKT = 'ARV' AND B.Class='N' and molecule='N' and PROD between '100' and '600'
		AND A.PACK_COD = B.PACK_COD and a.atc3_cod=b.atc3_cod
)
GO

-- ARV: 800 ARV others
insert into tblMktDef_MRBIChina
SELECT distinct Mkt,MktName,
	'800','ARV Others',
	'N' as Molecule, 'N' as Class,
	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
	'' Mole_cod,'' Mole_Name,
	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
	GetDate() as Date, '201203 add new products & packages'
	,1--rat
FROM tblMktDef_Inline A 
WHERE A.MKT = 'ARV' and NOT EXISTS(
	SELECT * FROM tblMktDef_MRBIChina B 
	WHERE B.MKT = 'ARV' AND B.Class='N' and molecule='N' and Prod between '100' and '700'
		AND A.PACK_COD = B.PACK_COD and a.atc3_cod=b.atc3_cod
)

-- -- Dia 000
-- insert into tblMktDef_MRBIChina
-- SELECT distinct 'DIA' Mkt,'Diabetes Market' MktName,
-- 	'000' as Prod,'Diabetes Market' as ProductName,
-- 	'N' as Molecule, 'N' as Class,
-- 	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
-- 	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
-- 	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
-- 	'' Mole_cod,'' Mole_Name,
-- 	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
-- 	GetDate() as Date, '201203 add new products & packages'
-- 	,1--rat
-- FROM tblMktDef_Inline A 
-- WHERE A.MKT = 'DIA' 
-- GO

-- -- Dia 910
-- insert into tblMktDef_MRBIChina
-- SELECT distinct 'DIA' Mkt,'Diabetes Market' MktName,
-- 	'910' as Prod,'NIAD' as ProductName,
-- 	'N' as Molecule, 'Y' as Class,
-- 	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
-- 	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
-- 	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
-- 	'' Mole_cod,'' Mole_Name,
-- 	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
-- 	GetDate() as Date, '201203 add new products & packages'
-- 	,1--rat
-- FROM tblMktDef_Inline A 
-- WHERE A.MKT = 'niad' 
-- GO
-- -- Dia 920
-- insert into tblMktDef_MRBIChina
-- SELECT distinct 'DIA' Mkt,'Diabetes Market' MktName,
-- 	'920' as Prod,'Insulin' as ProductName,
-- 	'N' as Molecule, 'Y' as Class,
-- 	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
-- 	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
-- 	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
-- 	'' Mole_cod,'' Mole_Name,
-- 	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
-- 	GetDate() as Date, '201203 add new products & packages'
-- 	,1--rat
-- FROM tblMktDef_Inline A 
-- WHERE A.MKT = 'Insulin' 
-- GO

-- -- DIA 990
-- insert into tblMktDef_MRBIChina
-- SELECT distinct 'DIA' Mkt,'Diabetes Market' MktName,
-- 	'990' as Prod,'DIA Others' as ProductName,
-- 	'N' as Molecule, 'Y' as Class,
-- 	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
-- 	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
-- 	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
-- 	'' Mole_cod,'' Mole_Name,
-- 	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
-- 	GetDate() as Date, '201203 add new products & packages'
-- 	,1--rat
-- FROM tblMktDef_Inline A 
-- WHERE A.MKT = 'dia' and NOT EXISTS(
-- 	SELECT * FROM tblMktDef_MRBIChina B 
-- 	WHERE B.MKT = 'dia' AND B.Class='Y' and molecule='N' and PROD in('910','920')
-- 		AND A.PACK_COD = B.PACK_COD and a.atc3_cod=b.atc3_cod
-- )
-- GO


-- -- DPP4 000
-- insert into tblMktDef_MRBIChina
-- SELECT distinct 'DPP4' Mkt,'DPP4 Market' MktName,
-- 	'000' as Prod,'DPP4 Market' as ProductName,
-- 	'N' as Molecule, 'N' as Class,
-- 	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
-- 	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
-- 	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
-- 	'' Mole_cod,'' Mole_Name,
-- 	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
-- 	GetDate() as Date, '201203 add new products & packages'
-- 	,1--rat
-- FROM tblMktDef_Inline A 
-- WHERE A.MKT = 'dpp4' 
-- GO

-- ACEI 000
insert into tblMktDef_MRBIChina
SELECT distinct 'ACE' Mkt,'ACEI Class' MktName,
	'000' as Prod,'ACEI Class' as ProductName,
	'N' as Molecule, 'N' as Class,
	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
	'' Mole_cod,'' Mole_Name,
	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
	GetDate() as Date, '201203 add new products & packages'
	,1--rat
FROM tblMktDef_Inline A 
WHERE A.MKT = 'acei' 
GO
-- ACEI Others
insert into tblMktDef_MRBIChina
SELECT distinct 'ACE' Mkt,'ACEI Class' MktName,
	'860' as Prod,'ACEI Others' as ProductName,
	'N' as Molecule, 'N' as Class,
	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
	'' Mole_cod,'' Mole_Name,
	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
	GetDate() as Date, '201203 add new products & packages'
	,1--rat
FROM tblMktDef_Inline A 
WHERE A.MKT = 'acei' AND NOT EXISTS(
	SELECT * FROM tblMktDef_MRBIChina B 
	WHERE B.MKT = 'ace' and Molecule='N' and class='N' AND B.PROD between '100' and '860'
		and a.atc3_cod=b.atc3_cod
		AND A.PACK_COD = B.PACK_COD
)

-- -- NIAD 000
-- if object_id(N'tmpMD',N'U') is not null
-- 	drop table tmpMD
-- go


-- select *
-- into tmpMD
-- from 
-- (
-- 	SELECT distinct 'NIAD' Mkt,'NIAD Market' MktName,
-- 		'000' as Prod,'NIAD Market' as ProductName,
-- 		'N' as Molecule, 'N' as Class,
-- 		ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
-- 		pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
-- 		Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
-- 		'' Mole_cod,'' Mole_Name,
-- 		Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
-- 		GetDate() as Date, '201203 add new products & packages' as comment
-- 		,1 as rat--rat
-- 	FROM tblMktDef_Inline A 
-- 	WHERE A.MKT = 'NIAD' 
-- 	union all
-- 	SELECT distinct 'NIAD' Mkt,'NIAD Market' MktName,
-- 		'000' as Prod,'NIAD Market' as ProductName,
-- 		'N' as Molecule, 'Y' as Class,
-- 		ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
-- 		pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
-- 		Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
-- 		'' Mole_cod,'' Mole_Name,
-- 		Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
-- 		GetDate() as Date, '201203 add new products & packages' as comment
-- 		,1 as rat--rat
-- 	FROM tblMktDef_Inline A 
-- 	WHERE A.MKT = 'NIAD' 
-- ) b
-- GO
-- insert into tblMktDef_MRBIChina
-- select * from tmpMD


-- -- NIAD 010
-- insert into tblMktDef_MRBIChina
-- SELECT distinct 'NIAD' Mkt,'NIAD Market' MktName,
-- 	'010' as Prod,'Metformin' as ProductName,
-- 	'Y' as Molecule, 'N' as Class,
-- 	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
-- 	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
-- 	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
-- 	'' Mole_cod,'' Mole_Name,
-- 	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
-- 	GetDate() as Date, '201203 add new products & packages'
-- 	,1--rat
-- FROM tblMktDef_Inline A 
-- WHERE A.MKT = 'NIAD' AND Mole_des = 'Metformin' 
-- GO

-- -- NIAD 810
-- insert into tblMktDef_MRBIChina
-- SELECT distinct 'NIAD' Mkt,'NIAD Market' MktName,
-- 	'810' as Prod,'NIAD Others' as ProductName,
-- 	'N' as Molecule, 'N' as Class,
-- 	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
-- 	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
-- 	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
-- 	'' Mole_cod,'' Mole_Name,
-- 	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
-- 	GetDate() as Date, '201203 add new products & packages'
-- 	,1--rat
-- FROM tblMktDef_Inline A 
-- WHERE A.MKT = 'NIAD' and NOT EXISTS(
-- 	SELECT * FROM tblMktDef_MRBIChina B 
-- 	WHERE B.MKT = 'NIAD' AND B.PROD between '100' and '809'
-- 		AND A.ATC3_COD = B.ATC3_COD
-- 		AND A.PACK_COD = B.PACK_COD
-- )
-- GO

-- -- NIAD 910--970
-- insert into tblMktDef_MRBIChina
-- SELECT distinct 'NIAD' Mkt,'NIAD Market' MktName,
-- 	case a.mkt 
-- 	when 'AGI' then '910'
-- 	when 'BI' then '920'
-- 	when 'DPP4' then '930'
-- 	when 'GLIN' then '940'
-- 	when 'GLP1' then '950'
-- 	when 'SU' then '960'
-- 	when 'TZD' then '970' end as Prod,Mkt as ProductName,
-- 	'N' as Molecule, 'Y' as Class,
-- 	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
-- 	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
-- 	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
-- 	'' Mole_cod,'' Mole_Name,
-- 	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
-- 	GetDate() as Date, '201203 add new products & packages'
-- 	,1--rat
-- FROM tblMktDef_Inline A 
-- WHERE a.Mkt in('AGI','BI','DPP4','GLIN','GLP1','SU','TZD') 
-- GO




-- HYP 000
if object_id(N'tmpMD',N'U') is not null
	drop table tmpMD
go


select *
into tmpMD
from 
(
	SELECT distinct 'HYP' Mkt,'Hypertension Market' MktName,
		'000' as Prod,'Hypertension Market' as ProductName,
		'N' as Molecule, 'N' as Class,
		ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
		pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
		Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
		'' Mole_cod,'' Mole_Name,
		Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
		GetDate() as Date, '201203 add new products & packages' as comment
		,1 as rat--rat
	FROM tblMktDef_Inline A 
	WHERE A.MKT = 'HYP' 
	union all
	SELECT distinct 'HYP' Mkt,'Hypertension Market' MktName,
		'000' as Prod,'Hypertension Market' as ProductName,
		'N' as Molecule, 'Y' as Class,
		ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
		pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
		Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
		'' Mole_cod,'' Mole_Name,
		Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
		GetDate() as Date, '201203 add new products & packages' as comment
		,1 as rat--rat
	FROM tblMktDef_Inline A 
	WHERE A.MKT = 'HYP' 
) b
GO

insert into tblMktDef_MRBIChina
select * from tmpMD
GO
TRUNCATE TABLE tmpMD
GO

-- hyp: 850 hyp others
insert into tblMktDef_MRBIChina
SELECT distinct Mkt,MktName,
	'850','HYP Others',
	'N' as Molecule, 'N' as Class,
	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
	'' Mole_cod,'' Mole_Name,
	Corp_cod, Manu_Cod, Gene_Cod, 'N' as Active,
	GetDate() as Date, '201203 add new products & packages'
	,1--rat
FROM tblMktDef_Inline A 
WHERE A.MKT = 'HYP' and NOT EXISTS(
	SELECT * FROM tblMktDef_MRBIChina B 
	WHERE B.MKT = 'HYP' AND B.Class='N' and molecule='N' and PROD between '100' and '800'
		AND A.PACK_COD = B.PACK_COD AND A.ATC3_COD=B.ATC3_COD
)
GO

-- Active in HYP market:
-- Y: focused brand
-- N: others

update tblMktDef_MRBIChina set Active = 'N'
where Mkt = 'Hyp' and prod = '850' and Active = 'Y'
go

update a set Active = 'N'
from tblMktDef_MRBIChina a
where a.Mkt = 'Hyp' and a.Prod = '000'
	and exists(
	select * from tblMktDef_MRBIChina b
	where a.mkt = b.mkt and b.prod = '850'
		and a.pack_cod = b.pack_cod
) and a.Active = 'Y' and molecule='N' and Class = 'N'
go


-- HYP 910--940
insert into tblMktDef_MRBIChina
SELECT distinct 'HYP' Mkt,'Hypertension Market' MktName,
	case a.mkt 
	when 'ACEI' then '910'
	when 'ARB' then '920'
	when 'BB' then '930'
	when 'CCB' then '940' end as Prod,Mkt as ProductName,
	'N' as Molecule, 'Y' as Class,
	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
	'' Mole_cod,'' Mole_Name,
	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
	GetDate() as Date, '201203 add new products & packages'
	,1--rat
FROM tblMktDef_Inline A 
WHERE a.Mkt in('ACEI','ARB','BB','CCB') 
GO

-- hyp 990
insert into tblMktDef_MRBIChina
SELECT distinct 'HYP' Mkt,'Hypertension Market' MktName,
	'990' Prod,'Other Class' ProductName,
	'N' as Molecule, 'Y' as Class,
	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
	'' Mole_cod,'' Mole_Name,
	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
	GetDate() as Date, '201203 add new products & packages'
	,1--rat
FROM tblMktDef_Inline A 
WHERE a.Mkt = 'HYP' and NOT EXISTS(
	SELECT * FROM tblMktDef_MRBIChina B 
	WHERE B.MKT = 'HYP' AND B.Class='Y' and molecule='N' and PROD between '910' and '950'
		AND A.PACK_COD = B.PACK_COD AND A.ATC3_COD=B.ATC3_COD
)
GO


-- ------------------------------------------------------
-- --	ELIQUIS VTEp : Add this market by Xiaoyu.Chen
-- ------------------------------------------------------
-- -- mkt
-- insert into tblMktDef_MRBIChina
-- SELECT distinct 
--   'Eliquis VTEp' Mkt,'Eliquis (VTEp) Market' MktName
--   ,'000' as Prod,'Eliquis (VTEp) Market' as ProductName
--   ,'N' as Molecule
--   ,'N' as Class
--   ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
--   ,pack_cod, Pack_des
--   ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
--   , Mole_cod
--   ,mole_des as Mole_Name
--   ,Corp_cod
--   ,Manu_Cod
--   ,Gene_Cod
--   ,'Y' as Active
--   ,GetDate() as Date, '201306 add new products & packages' as Comment
--   ,1--rat
-- FROM tblMktDef_Inline A WHERE A.MKT = 'Eliquis VTEp'
-- GO

-- --insert into tblMktDef_MRBIChina
-- --SELECT distinct 
-- --  'Eliquis VTEp' Mkt,'Eliquis (VTEp) Market' MktName
-- --  ,'000' as Prod,'Eliquis (VTEp) Market' as ProductName
-- --  ,'Y' as Molecule
-- --  ,'N' as Class
-- --  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
-- --  ,pack_cod, Pack_des
-- --  ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
-- --  , Mole_cod
-- --  ,mole_des as Mole_Name
-- --  ,Corp_cod
-- --  ,Manu_Cod
-- --  ,Gene_Cod
-- --  ,'Y' as Active
-- --  ,GetDate() as Date, '201306 add new products & packages' as Comment
-- --  ,1--rat
-- --FROM tblMktDef_Inline A WHERE A.MKT = 'Eliquis VTEp'
-- --GO

-- -- Prod

-- /*
-- 06253	FRAXIPARINE
-- 08621	CLEXANE
-- 40785	XARELTO
-- 53099	ELIQUIS
-- */
-- insert into tblMktDef_MRBIChina
-- SELECT distinct 
--    'Eliquis VTEp' as Mkt
--   ,'Eliquis (VTEp) Market' as MktName
--   ,case when a.Prod_Des='ELIQUIS' then '100'   
--         when a.Prod_Des='CLEXANE' then '200'     
--         when a.Prod_Des='XARELTO' then '300'        
--         when a.Prod_Des='FRAXIPARINE' then '400'   
-- 		when a.Prod_Des='ARIXTRA' then '500'  
-- 		else '600'
--         end   as [Prod]         
--   ,a.Prod_Des as ProductName
--   ,'N'        as Molecule
--   ,'N'        as Class 
--   ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
--   ,pack_cod, Pack_des
--   ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
--   , Mole_cod,Mole_Des as  Mole_Name
--   ,Corp_cod
--   ,Manu_Cod
--   ,Gene_Cod
--   ,'Y'       as Active
--   ,GetDate() as Date, '201306 add new products & packages'   --select * 
--   ,1--rat
-- FROM tblMktDef_Inline A 
-- WHERE A.MKT = 'Eliquis VTEp' 
-- GO


-- /*

-- prod_des	mole_des
-- CLEXANE	ENOXAPARIN SODIUM
-- ELIQUIS	APIXABAN
-- FRAXIPARINE	NADROPARIN CALCIUM
-- XARELTO	RIVAROXABAN
-- */

-- --Mole
-- --insert into tblMktDef_MRBIChina
-- --SELECT distinct 
-- --   'Eliquis VTEp' as Mkt
-- --  ,'Eliquis (VTEp) Market' as MktName
-- --  ,case when a.Prod_Des='ELIQUIS' then '100'   
-- --        when a.Prod_Des='CLEXANE' then '200'     
-- --        when a.Prod_Des='XARELTO' then '300'        
-- --        when a.Prod_Des='FRAXIPARINE' then '400'   
-- --		when a.Prod_Des='ARIXTRA' then '500'   
-- --        end   as [Prod]         
-- --  ,a.Mole_des as ProductName
-- --  ,'Y'        as Molecule
-- --  ,'N'        as Class 
-- --  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
-- --  ,pack_cod, Pack_des
-- --  ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
-- --  ,Mole_cod,Mole_Des as Mole_Name
-- --  ,Corp_cod
-- --  ,Manu_Cod
-- --  ,Gene_Cod
-- --  ,'Y'       as Active
-- --  ,GetDate() as Date, '201306 add new products & packages'  -- select * 
-- --  ,1--rat
-- --FROM tblMktDef_Inline A 
-- --WHERE A.MKT = 'Eliquis VTEp' 
-- --go

-- -- 20161103 change NOAC to VTEt
-- ------------------------------------------------------
-- --	ELIQUIS VTEt Market
-- ------------------------------------------------------
-- --mkt
-- insert into tblMktDef_MRBIChina
-- SELECT distinct 
--   'Eliquis VTEt' Mkt,'Eliquis (VTEt) Market' MktName
--   ,'000' as Prod,'Eliquis (VTEt) Market' as ProductName
--   ,'N' as Molecule
--   ,'N' as Class
--   ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
--   ,pack_cod, Pack_des
--   ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
--   , Mole_cod
--   ,mole_des as Mole_Name
--   ,Corp_cod
--   ,Manu_Cod
--   ,Gene_Cod
--   ,'Y' as Active
--   ,GetDate() as Date, '201306 add new products & packages' as Comment
--   ,1--rat
-- FROM tblMktDef_Inline A WHERE A.MKT = 'Eliquis VTEt'
-- GO

-- insert into tblMktDef_MRBIChina
-- SELECT distinct 
--   'Eliquis NOAC' Mkt,'Eliquis (NOAC) Market' MktName
--   ,'000' as Prod,'Eliquis (NOAC) Market' as ProductName
--   ,'N' as Molecule
--   ,'N' as Class
--   ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
--   ,pack_cod, Pack_des
--   ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
--   , Mole_cod
--   ,mole_des as Mole_Name
--   ,Corp_cod
--   ,Manu_Cod
--   ,Gene_Cod
--   ,'Y' as Active
--   ,GetDate() as Date, '201306 add new products & packages' as Comment
--   ,1--rat
-- FROM tblMktDef_Inline A WHERE A.MKT = 'Eliquis NOAC'
-- GO

-- --prod
-- insert into tblMktDef_MRBIChina
-- SELECT distinct 
--    'Eliquis VTEt' as Mkt
--   ,'Eliquis (VTEt) Market' as MktName
--   ,case when a.Prod_Des='ELIQUIS' then '100'   
--         when a.Prod_Des='CLEXANE' then '200'     
--         when a.Prod_Des='XARELTO' then '300'        
--         when a.Prod_Des='FRAXIPARINE' then '400'   
-- 		when a.Prod_Des='ARIXTRA' then '500'  
-- 		else '600'
--         end   as [Prod]         
--   ,a.Prod_Des as ProductName
--   ,'N'        as Molecule
--   ,'N'        as Class 
--   ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
--   ,pack_cod, Pack_des
--   ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
--   , Mole_cod,Mole_Des as  Mole_Name
--   ,Corp_cod
--   ,Manu_Cod
--   ,Gene_Cod
--   ,'Y'       as Active
--   ,GetDate() as Date, '201306 add new products & packages'   --select * 
--   ,1--rat
-- FROM tblMktDef_Inline A 
-- WHERE A.MKT = 'Eliquis VTEt' 
-- go

-- insert into tblMktDef_MRBIChina
-- SELECT distinct 
-- 	'Eliquis NOAC' as Mkt
-- 	,'Eliquis (NOAC) Market' as MktName
-- 	,case when a.Prod_Des='Eliquis' then '100'   
-- 		when a.Prod_Des='XARELTO' then '200'     
-- 		when a.Prod_Des='PRADAXA' then '300' 
-- 		end   as [Prod]         
-- 	,a.Prod_Des as ProductName
-- 	,'N'        as Molecule
-- 	,'N'        as Class 
-- 	,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
-- 	,pack_cod, Pack_des
-- 	,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
-- 	, Mole_cod,Mole_Des as  Mole_Name
-- 	,Corp_cod
-- 	,Manu_Cod
-- 	,Gene_Cod
-- 	,'Y'       as Active
-- 	,GetDate() as Date, '201306 add new products & packages'   --select * 
-- 	,1--rat
-- FROM tblMktDef_Inline A 
-- WHERE A.MKT = 'Eliquis NOAC' 
-- GO

-- -- 20161108 add a rat table 

-- -- vtep and vtet rat
-- update a
-- set a.rat = b.rat
-- from tblMktDef_MRBIChina  as a 
-- inner join dbo.inMktDef_MRBIChina_rat as b 
-- on a.Mkt = b.Mkt and a.Mole_Cod = b.Mole_Cod and b.IsMole = 'Y'

-- -- noac rat
-- update a
-- set a.rat = b.rat
-- from tblMktDef_MRBIChina  as a 
-- inner join dbo.inMktDef_MRBIChina_rat as b 
-- on a.Mkt = b.Mkt and a.ProductName = b.Prod_Des and b.IsProd = 'Y'


-- update tblMktDef_MRBIChina set rat=1
-- where mkt like 'eliquis VTEp' and prod_name='ARIXTRA'
-- update tblMktDef_MRBIChina set rat=1
-- where mkt like 'eliquis VTEp%' and prod_name='CLEXANE'
-- update tblMktDef_MRBIChina set rat=1
-- where mkt like 'eliquis VTEp%' and prod_name='ELIQUIS'
-- update tblMktDef_MRBIChina set rat=1
-- where mkt like 'eliquis VTEp%' and prod_name='FRAXIPARINE'
-- update tblMktDef_MRBIChina set rat=1
-- where mkt like 'eliquis VTEp%' and prod_name='XARELTO'

--NOAC
-- update tblMktDef_MRBIChina set rat=1
-- where mkt like 'eliquis noac' and prod_name='Eliquis'
-- update tblMktDef_MRBIChina set rat=1
-- where mkt like 'eliquis noac' and prod_name='Xarelto'
-- update tblMktDef_MRBIChina set rat=1
-- where mkt like 'eliquis noac' and prod_name='Pradaxa'



go
-- -----------------------------------------------
-- --			Coniel
-- -----------------------------------------------
-- --mkt
-- insert into tblMktDef_MRBIChina
-- SELECT distinct 
--   'CCB' Mkt,'CCB Market' MktName
--   ,'000' as Prod,'CCB Market' as ProductName
--   ,'N' as Molecule
--   ,'N' as Class
--   ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
--   ,pack_cod, Pack_des
--   ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
--   ,Mole_cod
--   ,Mole_des as Mole_Name
--   ,Corp_cod
--   ,Manu_Cod
--   ,Gene_Cod
--   ,'Y' as Active
--   ,GetDate() as Date, '201404 add new products & packages' as Comment
--   ,1--rat
-- FROM tblMktDef_Inline A WHERE A.MKT = 'CCB'
-- --GO

-- --insert into tblMktDef_MRBIChina
-- --SELECT distinct 
-- --  'CCB' Mkt,'CCB Market' MktName
-- --  ,'000' as Prod,'CCB Market' as ProductName
-- --  ,'Y' as Molecule
-- --  ,'N' as Class
-- --  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
-- --  ,pack_cod, Pack_des
-- --  ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
-- --  ,'' Mole_cod
-- --  ,'' Mole_Name
-- --  ,Corp_cod
-- --  ,Manu_Cod
-- --  ,Gene_Cod
-- --  ,'Y' as Active
-- --  ,GetDate() as Date, '201404 add new products & packages' as Comment
-- --FROM tblMktDef_Inline A WHERE A.MKT = 'CCB'
-- GO

-- -- Prod

-- insert into tblMktDef_MRBIChina
-- SELECT distinct 
--    'CCB' as Mkt
--   ,'CCB Market' as MktName
--   ,case when a.Prod_Des='Coniel'  then '100'   
-- 		when a.Prod_Des='YUAN ZHI' then '200' 
-- 		when a.Prod_Des='LACIPIL' then '300'
-- 		when a.Prod_Des='ZANIDIP' then '400'
-- 		when a.Prod_Des='NORVASC' then '500'
-- 		when a.Prod_Des='ADALAT'  then '600'
-- 		when a.Prod_Des='PLENDIL' then '700'
-- 		else '940'
--         end   as [Prod]         
--   ,
--   case when a.Prod_Des='Coniel'  then prod_des
-- 		when a.Prod_Des='YUAN ZHI' then prod_des
-- 		when a.Prod_Des='LACIPIL' then prod_des
-- 		when a.Prod_Des='ZANIDIP' then prod_des
-- 		when a.Prod_Des='NORVASC' then prod_des
-- 		when a.Prod_Des='ADALAT' then prod_des
-- 		when a.Prod_Des='PLENDIL' then prod_des
-- 		else 'CCB Others'
--         end   as ProductName
--   ,'N'        as Molecule
--   ,'N'        as Class 
--   ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
--   ,pack_cod, Pack_des
--   ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
--   ,Mole_cod
--   ,Mole_des as Mole_Name
--   ,Corp_cod
--   ,Manu_Cod
--   ,Gene_Cod
--   ,'Y'       as Active
--   ,GetDate() as Date, '201404 add new products & packages'  -- select * 
--   ,1--rat
-- FROM tblMktDef_Inline A 
-- WHERE A.MKT = 'CCB' 
-- GO

-- ------------------------------------------------------
-- -- Platinum
-- ------------------------------------------------------

-- -- mkt
-- insert into tblMktDef_MRBIChina
-- SELECT distinct 
--   'Platinum' Mkt,'Platinum Market' MktName
--   ,'000' as Prod,'Platinum Market' as ProductName
--   ,'N' as Molecule
--   ,'N' as Class
--   ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
--   ,pack_cod, Pack_des
--   ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
--   ,'' Mole_cod
--   ,'' Mole_Name
--   ,Corp_cod
--   ,Manu_Cod
--   ,Gene_Cod
--   ,'Y' as Active
--   ,GetDate() as Date, '201203 add new products & packages' as Comment
--   ,1--rat
-- FROM tblMktDef_Inline A WHERE A.MKT = 'Platinum'
-- GO

-- insert into tblMktDef_MRBIChina
-- SELECT distinct 
--   'Platinum' Mkt,'Platinum Market' MktName
--   ,'000' as Prod,'Platinum Market' as ProductName
--   ,'Y' as Molecule
--   ,'N' as Class
--   ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
--   ,pack_cod, Pack_des
--   ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
--   ,'' Mole_cod
--   ,'' Mole_Name
--   ,Corp_cod
--   ,Manu_Cod
--   ,Gene_Cod
--   ,'Y' as Active
--   ,GetDate() as Date, '201203 add new products & packages' as Comment
--   ,1--rat
-- FROM tblMktDef_Inline A WHERE A.MKT = 'Platinum'
-- GO

-- -- Mole
-- insert into tblMktDef_MRBIChina
-- SELECT distinct 
--   dbo.fun_upperFirst(a.Mkt)
--   ,MktName
--   ,case a.Mole_des when 'Carboplatin' then '010'
--                    when 'Cisplatin' then '020'
--                    when 'Nedaplatin' then '030' end as  Prod
--   ,a.Mole_des as ProductName
--   ,'Y' as Molecule
--   ,'N' as Class
--   ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
--   ,pack_cod, Pack_des
--   ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
--   ,'' Mole_cod,'' Mole_Name
--   ,Corp_cod
--   ,Manu_Cod
--   ,Gene_Cod
--   ,'Y' as Active
--   ,GetDate() as Date, '201203 add new products & packages'
--   ,1--rat
-- FROM tblMktDef_Inline A 
-- WHERE A.MKT = 'Platinum' 
-- GO


-- -- Prod
-- insert into tblMktDef_MRBIChina
-- SELECT distinct 
--    'Platinum' as Mkt
--   ,'Platinum Market' as MktName
--   ,case when a.Prod_Des='PARAPLATIN' then '100'   --N'伯尔定' 
--         when a.Prod_Des='BO BEI' then '200'       --N'波贝'   
--         when a.Prod_Des='NUO XIN' then '300'      --N'诺欣'   
--         when a.Prod_Des='CISPLATIN' then '400'    --N'顺铂'   
--         when a.Prod_Des='AO XIAN DA' then '500'   --N'奥先达' 
--         when a.Prod_Des='JIE BAI SHU' then '600'  --N'捷佰舒' 
--         when a.Prod_Des='LU BEI' then '700'       --N'鲁贝'   
--         else '990'                                --others
--         end   as [Prod]         
--   ,a.Prod_Des as ProductName
--   ,'N'        as Molecule
--   ,'N'        as Class 
--   ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
--   ,pack_cod, Pack_des
--   ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
--   ,'' Mole_cod,'' Mole_Name
--   ,Corp_cod
--   ,Manu_Cod
--   ,Gene_Cod
--   ,'Y'       as Active
--   ,GetDate() as Date, '201203 add new products & packages'  -- select * 
--   ,1--rat
-- FROM tblMktDef_Inline A 
-- WHERE A.MKT = 'Platinum' 
-- GO

-- update tblMktDef_MRBIChina set [ProductName] = 'Platinum Others'
-- where [Mkt] = 'Platinum' and [Prod] = '990'
-- GO

if object_id(N'tblMktDef_MRBIChina_All',N'U') is not null
	drop table tblMktDef_MRBIChina_All
select * into tblMktDef_MRBIChina_All from tblMktDef_MRBIChina
go

drop table tblMktDef_MRBIChina
go
SELECT 
distinct [Mkt] ,[MktName] ,[Prod],[ProductName] ,[Molecule] ,[Class] ,[ATC1_COD] ,[ATC2_COD]  ,[ATC3_COD] ,
			[ATC4_COD] ,[Pack_Cod]  ,[Pack_Des] ,[Prod_Cod] ,[Prod_Name],[Prod_FullName] ,
			convert(nvarchar(50),'') as [Mole_Cod], convert(nvarchar(50),'') as [Mole_Name],
			[Corp_COD],[Manu_COD] ,[Gene_COD] ,[Active],[Date] ,[Comment],rat
into tblMktDef_MRBIChina
from tblMktDef_MRBIChina_All

--update niad treatmentday
update a
set a.rat= case when b.DD=0 then 1 else b.DD end
--select *
from tblMktDef_MRBIChina a 
join dbo.inNIAD_Treatmentday b on a.pack_des=b.package
where a.mkt='niad'


go	

--delete from tblMktDef_MRBIChina where mkt='CCB'

/*
select count(*) from tblMktDef_MRBIChina_correct where not(mkt='ONCFCS' and molecule='Y')
and pack_cod in (select pack_code from dim_pack)
select count(*) from tblMktDef_MRBIChina where pack_cod in (select pack_code from dim_pack)

select * from tblMktDef_MRBIChina_correct A where 
not exists(select * from tblMktDef_MRBIChina B
where a.pack_cod=b.pack_cod and a.mkt=b.mkt and  a.atc1_cod = b.atc1_cod
	and a.atc2_cod = b.atc2_cod
	and a.atc3_cod = b.atc3_cod
	and a.atc4_cod = b.atc4_cod
	and a.Prod_cod = b.Prod_cod and A.PRODUCTNAME=B.PRODUCTNAME AND a.molecule=b.molecule and a.class=b.class AND A.PACK_COD=B.PACK_COD)
 and not(mkt='ONCFCS' and molecule='Y') and pack_cod in (select pack_code from dim_pack)

 order by pack_cod,mkt

select * from tblMktDef_MRBIChina A where 
not exists(select * from tblMktDef_MRBIChina_correct B
where a.pack_cod=b.pack_cod and a.mkt=b.mkt and  a.atc1_cod = b.atc1_cod
	and a.atc2_cod = b.atc2_cod
	and a.atc3_cod = b.atc3_cod
	and a.atc4_cod = b.atc4_cod
	and a.Prod_cod = b.Prod_cod  and A.PRODUCTNAME=B.PRODUCTNAME and a.molecule=b.molecule and a.class=b.class AND A.PACK_COD=B.PACK_COD)
and pack_cod in (select pack_code from dim_pack)
order by pack_cod,mkt

*/


exec dbo.sp_Log_Event 'MktDef','CIA','1_MktDefinition.sql','tblMktDef_MRBIChina_Mole',null,null
print (N'
------------------------------------------------------------------------------------------------------------
4. tblMktDef_MRBIChina_Mole
------------------------------------------------------------------------------------------------------------
')
--select * into dbo.tblMktDef_MRBIChina_Mole from dbo.tblMktDef_MRBIChina where 1=2
TRUNCATE TABLE tblMktDef_MRBIChina_Mole
go
-- --Metformin
-- insert into tblMktDef_MRBIChina_Mole
-- select  'Metformin','Metformin Market','000','Metformin Market','N','N',
-- ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_Name, Prod_FullName,
-- Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD, Active, Date, Comment,rat
-- from dbo.tblMktDef_MRBIChina where productname like 'Metformin'
-- GO
-- insert into tblMktDef_MRBIChina_Mole
-- select  'Metformin','Metformin Market',
-- 	CASE prod_name  WHEN 'Glucophage' THEN '100' 
-- 					WHEN 'jun li da' THEN '200' 
-- 					WHEN 'tai bai' THEN '300'
-- 					WHEN 'bei shun' THEN '400'
-- 					WHEN 'bo ke' THEN '500'
-- 					ELSE '600' END,
-- 	case WHEN prod_name in ('jun li da','tai bai','bei shun','bo ke','Glucophage') 
-- 		 then Prod_name else 'OTHERS' END,
-- 	'N','N',
-- 	ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_Name, 
-- 	Prod_FullName, Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD, Active, Date, Comment,rat
-- from dbo.tblMktDef_MRBIChina where productname like 'Metformin'
GO
--Entecavir
insert into tblMktDef_MRBIChina_Mole
select  'Entecavir','Entecavir Market','000','Entecavir Market','N','N',
	ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_Name, 
	Prod_FullName, Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD, Active, Date, Comment,rat
from dbo.tblMktDef_MRBIChina where productname like 'Entecavir'
GO
insert into tblMktDef_MRBIChina_Mole
select  'Entecavir','Entecavir Market',
	CASE prod_name  WHEN 'Baraclude' THEN '100' 
					WHEN 'WEI LI QING' THEN '200' 
					WHEN 'LEI YI DE' THEN '300'
					WHEN 'RUN ZHONG' THEN '400'
					ELSE '600' END,
	case WHEN prod_name in ('Baraclude','WEI LI QING','LEI YI DE','RUN ZHONG') then Prod_name else 'OTHERS' END,
	'N','N',
	ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, 
	Prod_Name, Prod_FullName, Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD, Active, Date, Comment,rat
from dbo.tblMktDef_MRBIChina where productname like 'Entecavir'


--ACEI
insert into tblMktDef_MRBIChina_Mole
select  'ACEI','ACEI Market','000','ACEI Market','N','N',
	ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_Name,
	Prod_FullName, Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD, Active, Date, Comment,rat
 from dbo.tblMktDef_MRBIChina where MKT='ACE' and Prod='000'
GO
insert into tblMktDef_MRBIChina_Mole
select  'ACEI','ACEI Market',
	Prod,ProductName,Molecule,Class,
	ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_Name, 
	Prod_FullName, Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD, Active, Date, Comment,rat
 from dbo.tblMktDef_MRBIChina where MKT='ACE' and Prod<>'000'
go
--insert into tblMktDef_MRBIChina_Mole
--select  'ACEI','ACEI Market',
--CASE prod_name WHEN 'Monopril' THEN '100' 
--WHEN 'Lotensin' THEN '200' 
--WHEN 'Acertil' THEN '300'
--WHEN 'YI SU' THEN '400'
--WHEN 'XIN DA YI' THEN '500'
--ELSE '600' END,
--case WHEN prod_name in ('Monopril','Lotensin','Acertil','YI SU','XIN DA YI') then Prod_name else 'OTHERS' END,
--'N','N',
--ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_Name, Prod_FullName, Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD, Active, Date, Comment
-- from dbo.tblMktDef_MRBIChina where MKT='ACE' and Prod='000'
-- --CCB
-- insert into tblMktDef_MRBIChina_Mole
-- select  'CCB','CCB Market','000','CCB Market','N','N',
-- 	ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_Name, 
-- 	Prod_FullName, Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD, Active, Date, Comment,rat
--  from dbo.tblMktDef_MRBIChina where MKT='CCB' and Prod='000'
-- GO
-- insert into tblMktDef_MRBIChina_Mole
-- select  'CCB','CCB Market',
-- 	Prod,ProductName,Molecule,Class,
-- 	ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_Name, 
-- 	Prod_FullName, Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD, Active, Date, Comment,rat
--  from dbo.tblMktDef_MRBIChina where MKT='CCB' and Prod<>'000'
-- go

--Paclitaxel
insert into tblMktDef_MRBIChina_Mole
select  'Paclitaxel','Paclitaxel Market','000','Paclitaxel Market','N','N',
	ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_Name, 
	Prod_FullName, Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD, Active, Date, Comment,rat
 from dbo.tblMktDef_MRBIChina where productname like 'Paclitaxel'
GO
insert into tblMktDef_MRBIChina_Mole
select  'Paclitaxel','Paclitaxel Market',
	CASE prod_name  WHEN 'Taxol' THEN '100' 
					WHEN 'LI PU SU' THEN '200' 
					WHEN 'Abraxane' THEN '300'
					ELSE '600' END,
	case WHEN prod_name in ('Taxol','LI PU SU','Abraxane') then Prod_name else 'OTHERS' END,
	'N','N',
	ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_Name, 
	Prod_FullName, Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD, Active, Date, Comment,rat
 from dbo.tblMktDef_MRBIChina where productname like 'Paclitaxel'
go
--todo
-- --Carboplatin
-- insert into tblMktDef_MRBIChina_Mole
-- select  'Carboplatin','Carboplatin Market','000','Carboplatin Market','N','N',
-- 	ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_Name, 
-- 	Prod_FullName, Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD, Active, Date, Comment,rat
--  from dbo.tblMktDef_MRBIChina where productname like 'Carboplatin'
-- GO
-- insert into tblMktDef_MRBIChina_Mole
-- select  'Carboplatin','Carboplatin Market',
-- 	CASE prod_name  WHEN 'Paraplatin' THEN '100' 
-- 					WHEN 'BO BEI' THEN '200' 
-- 					WHEN 'Carboplatin' THEN '300'
-- 					ELSE '600' END,
-- 	case WHEN prod_name in ('Paraplatin','BO BEI','Carboplatin') then Prod_name else 'Others' END,
-- 	'N','N',
-- 	ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_Name, 
-- 	Prod_FullName, Mole_Cod, Mole_Name, Corp_COD, Manu_COD, Gene_COD, Active, Date, Comment,rat
-- from dbo.tblMktDef_MRBIChina where productname like 'Carboplatin'
go


exec dbo.sp_Log_Event 'MktDef','CIA','1_MktDefinition.sql','tblMktDef_GlobalTA',null,null
print (N'
------------------------------------------------------------------------------------------------------------
5. tblMktDef_GlobalTA
------------------------------------------------------------------------------------------------------------
')
-- find the records can match atc3

--select distinct b.GTA,b.GTAname, b.ATC1_cod,b.ATC2_cod,b.ATC3_cod
--into tblMktDef_GlobalTA_OnlyATC from tblMktDef_GlobalTA b
--where GTA<>'OTH'
--order by gta

--SELECT * INTO dbo.tblMktDef_GlobalTA_201203 FROM dbo.tblMktDef_GlobalTA


truncate table dbo.tblMktDef_GlobalTA
go

insert	into tblMktDef_GlobalTA
select distinct
		b.GTA, b.GTAname, b.ATC1_cod, b.ATC2_cod, b.ATC3_cod, a.ATC3_Des, a.Prod_cod, a.Pack_cod,
		A.prod_des as Prod_Name, a.Pack_Des, Gene_cod, a.Manu_cod, a.MNC
from	tblMktDef_ATCDriver A
inner join tblMktDef_GlobalTA_OnlyATC B on a.atc3_cod = b.atc3_cod 
go

insert	into tblMktDef_GlobalTA
select distinct
		'OTH', 'All Others', A.ATC1_cod, A.ATC2_cod, A.ATC3_cod, a.ATC3_Des, a.Prod_cod, a.Pack_cod,
		A.prod_des as Prod_Name, a.Pack_Des, Gene_cod, a.Manu_cod, a.MNC
from	tblMktDef_ATCDriver A
where	not exists ( select	* from tblMktDef_GlobalTA_OnlyATC B where a.atc3_cod = b.atc3_cod )
go

delete	from tblMktDef_GlobalTA
where	gta = 'ALZ'
go

insert	into tblMktDef_GlobalTA
select  distinct
		'ALZ', 'Alzheimer''s', A.ATC1_cod, A.ATC2_cod, A.ATC3_cod, a.ATC3_Des, a.Prod_cod, a.Pack_cod,
		A.prod_des as Prod_Name, a.Pack_Des, Gene_cod, a.Manu_cod, a.MNC
from	tblMktDef_ATCDriver A
where	ATC3_COD in ( 'N07D' ) or Mole_des like '%HUPERZINE A%'
go


exec dbo.sp_Log_Event 'MktDef','CIA','1_MktDefinition.sql','tblMktDef_BMSFocused10Mkt',null,null
print (N'
------------------------------------------------------------------------------------------------------------
6. tblMktDef_BMSFocused10Mkt
------------------------------------------------------------------------------------------------------------
')

truncate table tblMktDef_BMSFocused10Mkt
go
--New BMS Focused Mkt Definition
insert	into tblMktDef_BMSFocused10Mkt
select distinct
		'AT', 'Atherosclerosis/Thrombosis', ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod,
		Prod_des, Prod_des, Corp_COD, Manu_COD, Gene_COD
from	tblMktDef_ATCDriver
where	ATC3_COD in ( 'B01A', 'B01B', 'B01C', 'B01D', 'B01E', 'B01X', 'C04A', 'C10A', 'C10B', 'C10C', 'C11A' )

insert	into tblMktDef_BMSFocused10Mkt
select distinct
		'HBV', 'Hepatitis', ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_des, Prod_des,
		Corp_COD, Manu_COD, Gene_COD
from	tblMktDef_ATCDriver
where	ATC3_COD in ( 'J05B', 'L03B' )

insert	into tblMktDef_BMSFocused10Mkt
select distinct
		'ONC', 'Oncology', ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_des, Prod_des,
		Corp_COD, Manu_COD, Gene_COD
from	tblMktDef_ATCDriver
where	ATC3_COD in ( 'L01A', 'L01B', 'L01C', 'L01D', 'L01X', 'L02A', 'L02B' ) 


insert	into tblMktDef_BMSFocused10Mkt
select distinct
		'RA', 'Rheumatoid Arthritis', ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_des,
		Prod_des, Corp_COD, Manu_COD, Gene_COD
from	tblMktDef_ATCDriver
where	Prod_Des in ( 'REMICADE' )
		and atc3_cod = 'L04B'
 
insert	into tblMktDef_BMSFocused10Mkt
select distinct
		'RA', 'Rheumatoid Arthritis', ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_des,
		Prod_des, Corp_COD, Manu_COD, Gene_COD
from	tblMktDef_ATCDriver
where	ATC3_COD = 'M01C'
 

--insert into tblMktDef_BMSFocused10Mkt
--select distinct 'PSY' as Mkt,'Affective & Psychiatrics' as MktName,
--ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_des Prod_Name,
-- Prod_des Prod_FullName, Corp_COD, Manu_COD, Gene_COD from tblMktDef_ATCDriver where ATC3_COD in 
--('N05A','N05B','N05C','N06A','N06B','N06C','N07B','N07E','N07F','N07X')
--go

--insert into tblMktDef_BMSFocused10Mkt
--select distinct 'ALZ','Alzheimer''s',
--ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_des,
-- Prod_des, Corp_COD, Manu_COD, Gene_COD from tblMktDef_ATCDriver where ATC3_COD in 
--('N07D')or Mole_des like '%HUPERZINE A%'
--go

--insert into tblMktDef_BMSFocused10Mkt
--select distinct 'AT','Atherosclerosis/Thrombosis',
--ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_des,
-- Prod_des, Corp_COD, Manu_COD, Gene_COD from tblMktDef_ATCDriver where ATC3_COD in 
--('B01A','B01B','B01C','B01D','B01E','B01X','C04A') or ATC2_COD in ('C10','C11')
--go

--insert into tblMktDef_BMSFocused10Mkt
--select distinct 'DIA','Diabetes',
--ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_des,
-- Prod_des, Corp_COD, Manu_COD, Gene_COD from tblMktDef_ATCDriver where ATC3_COD 
--between 'A10B' and 'A10X'
--go

--insert into tblMktDef_BMSFocused10Mkt
--select distinct 'HBV','Hepatitis',
--ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, '', Prod_Cod, '',
-- '', Corp_COD, Manu_COD, Gene_COD from DB82.TempOutput.DBO.MTHCHPA_PKAU where 
--cmps_cod in ('002403','002317','001106','001659','000420','000419','002315','002007','002401')
--go

----(atc3_cod='J05B' and Mole_des in ('ADEFOVIR DIPIVOXIL','ENTECAVIR','LAMIVUDINE'))
----or (atc3_cod='L03B' and (Mole_des like 'INTERFERON ALFA%'or Mole_des like 'INTERFERON (UNSPECIFIED)'))
----or (ATC3_COD='A11E' and prod_des='HAI WEI XIN')
----or (ATC3_COD='D06D' and prod_des='LI YA MEI')
----or (atc3_cod='G02X' and prod_des in('INTERFERON,ALPHA','OPIN'))
----or (ATC3_COD='J05C' and prod_des='EPIVIR')
----or (ATC3_COD='K04D' and prod_des='KAI WEI')
----or (ATC3_COD='L04X' and prod_des in ('RAPAMUNE','YI XIN KE','SAI ME SI','RUI PA MING','SIROLIMUS'))
----or (ATC3_COD='N07X' and prod_des in('XING TUO KANG','ANTIRADON','BU DUN'))
----or (ATC3_COD='S01D' and prod_des in('INTERFERON,ALPHA','DI NING'))


--insert into tblMktDef_BMSFocused10Mkt
--select distinct 'HIV','HIV',
--ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_des,
-- Prod_des, Corp_COD, Manu_COD, Gene_COD from tblMktDef_ATCDriver where ATC3_COD 
--in  ('J05C')
-- go

--insert into tblMktDef_BMSFocused10Mkt
--select distinct 'OBS','Obesity',
--ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_des,
-- Prod_des, Corp_COD, Manu_COD, Gene_COD from tblMktDef_ATCDriver where ATC3_COD 
--in  ('A08A') 
--go

--insert into tblMktDef_BMSFocused10Mkt
--select distinct 'ONC','Oncology',
--ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_des,
-- Prod_des, Corp_COD, Manu_COD, Gene_COD from tblMktDef_ATCDriver where ATC2_COD 
--in  ('L01','L02') 
--go

--insert into tblMktDef_BMSFocused10Mkt
--select distinct 'RA','Rheumatoid Arthritis',
--ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_des,
-- Prod_des, Corp_COD, Manu_COD, Gene_COD from tblMktDef_ATCDriver where ATC3_COD 
--in  ('M01C')
--go

--insert into tblMktDef_BMSFocused10Mkt
--select distinct 'RA','Rheumatoid Arthritis',
--ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_des,
-- Prod_des, Corp_COD, Manu_COD, Gene_COD from tblMktDef_ATCDriver where
-- Prod_Des in ('REMICADE') 
--go

--insert into tblMktDef_BMSFocused10Mkt
--select distinct 'RA','Rheumatoid Arthritis',
--ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_des,
-- Prod_des, Corp_COD, Manu_COD, Gene_COD from tblMktDef_ATCDriver where  mole_des='METHOTREXATE'
--go

--insert into tblMktDef_BMSFocused10Mkt
--select distinct 'SOT','Solid Organ Transplant',
--ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, Pack_Cod, Pack_Des, Prod_Cod, Prod_des,
-- Prod_des, Corp_COD, Manu_COD, Gene_COD from tblMktDef_ATCDriver where  atc2_des='IMMUNOSUPPRESSANTS'
--and   Prod_Des not in ('REMICADE') 
go

