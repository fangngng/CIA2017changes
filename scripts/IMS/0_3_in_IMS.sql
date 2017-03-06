USE BMSChinaCIA_IMS
go

--Time:00:19


exec dbo.sp_Log_Event 'In','CIA','0_3_in_IMS.sql','Start',null,null


--1. Dim table
drop table Dim_City
drop table Dim_Fact_Sales
drop table Dim_Manufacturer
drop table Dim_ManufacturerType
drop table Dim_Molecule
drop table Dim_New_Form_Class
drop table Dim_Pack
drop table Dim_Product
drop table Dim_Product_Molecule
--drop table Dim_Region
drop table Dim_Therapeutic_Class
drop table Max_Data
go

declare @CurrMonth varchar(10)
select @CurrMonth = [Value] from Config where Parameter = 'IMS'
print @CurrMonth
exec('select * into Dim_City from BMSChinaCIARawdata.dbo.Dim_City_' + @CurrMonth)
exec('select * into Dim_Fact_Sales from BMSChinaCIARawdata.dbo.Dim_Fact_Sales_' + @CurrMonth)
exec('select * into Dim_Manufacturer from BMSChinaCIARawdata.dbo.Dim_Manufacturer_' + @CurrMonth)
exec('select * into Dim_ManufacturerType from BMSChinaCIARawdata.dbo.Dim_ManufacturerType_' + @CurrMonth)
exec('select * into Dim_Molecule from BMSChinaCIARawdata.dbo.Dim_Molecule_' + @CurrMonth)
exec('select * into Dim_New_Form_Class from BMSChinaCIARawdata.dbo.Dim_New_Form_Class_' + @CurrMonth)
exec('select * into Dim_Pack from BMSChinaCIARawdata.dbo.Dim_Pack_' + @CurrMonth)
exec('select * into Dim_Product from BMSChinaCIARawdata.dbo.Dim_Product_' + @CurrMonth)
exec('select * into Dim_Product_Molecule from BMSChinaCIARawdata.dbo.Dim_Product_Molecule_' + @CurrMonth)
exec('select * into Dim_Therapeutic_Class from BMSChinaCIARawdata.dbo.Dim_Therapeutic_Class_' + @CurrMonth)
exec('select * into Max_Data from BMSChinaCIARawdata.dbo.Max_' + @CurrMonth)
go


-- create table tblMAXProdUpdate 
-- (	IMS_Manu varchar(255),
-- 	MoleculeName varchar(255),
-- 	ProductName varchar(255),
-- 	IMSProduct varchar(255)
-- )
-- go

-- insert into tblMAXProdUpdate
-- select 'BJ.YOUCARE PHARM' 	,'ADEFOVIR DIPIVOXIL', 	'YUE KANG PU XIN' 	,'YUE KANG PU XIN'
-- union 
-- select 'SC.BEAUTY SPORT HU' ,'ADEFOVIR DIPIVOXIL', 	'SHU TAI' 			,'SHU TAI'
-- union 
-- select 'CHANGZHEN XINKAI' 	,'ADEFOVIR DIPIVOXIL',	'AI LU WEI' 		,'AI LU WEI'
-- union 
-- select 'SD.LUKANG PHARM' 	,'ENTECAVIR' 	 ,'ENTECAVIR' 				,'MU CHANG'
-- union 
-- select 'HAINAN ZHONGHE PH' 	,'ENTECAVIR' 	 ,'ENTECAVIR' 				,'HE EN'
-- union 
-- select 'SC.HAISICO PHARM' 	,'ENTECAVIR' 	 ,'ENTECAVIR' 				,'GAN BEI QING'
-- union 
-- select 'FJ.COSUNTER PHARM' 	,'ENTECAVIR' 	 ,'EN GAN DING' 			,'EN GAN DING'
-- union 
-- select 'QIANJINXIANGJIANG' 	,'ENTECAVIR' 	 ,'ENTECAVIR' 				,'ENTECAVIR'
-- union 
-- select 'BJ.WANSHENG PH'	 ,'LAMIVUDINE' 	 ,'LAMIVUDINE' 					,'WAN SHENG LI KE'


-- 检查MAX数据是否有增加新的manu或Production -- todo 

-- MAX数据添加IMS_Manu, IMSProd
alter table Max_Data 
add IMS_Manu varchar(255),
	IMS_Prod varchar(255)
go 

update a 
set a.IMS_Manu = b.IMS_Manu
from Max_Data as a 
inner join 	tblMAXManuDef as b 
on a.[生产厂家（标准_英文）] = b.name and a.[生产厂家（标准_中文）] = b.namec

update a 
set a.IMS_Prod = b.IMSProduct
from Max_Data as a 
inner join 	tblMAXProdUpdate as b 
on a.IMS_Manu = b.IMS_Manu and a.[通用名（标准_英文）] = b.MoleculeName 
	and a.[商品名（标准_英文）] = b.ProductName

update a 
set a.IMS_Prod = a.[商品名（标准_英文）]
from Max_Data as a 
where a.IMS_Prod = '' or a.IMS_Prod is null
	
-- MAX数据添加 ATC1_Cod,ATC1_Des,ATC2_Cod,ATC2_Des,ATC3_Cod,ATC3_Des,ATC4_Cod,ATC4_Des, Corp_Name, 
-- MNC, Generic_Code
alter table Max_Data
add ATC1_Cod varchar(1),
	ATC1_Des varchar(255)	,
	ATC2_Cod varchar(3)	,
	ATC2_Des varchar(255)	,
	ATC3_Cod varchar(4)	,
	ATC3_Des varchar(255)	,
	ATC4_Cod varchar(20)	,
	ATC4_Des varchar(255)	,
	Corp_Desc varchar(255) ,
	MNC varchar(1) ,
	Gene_Code varchar(1)
GO

update l
set ATC1_Cod  = i.ATC1_Cod,
	ATC1_Des  = i.ATC1_Des,
	ATC2_Cod  = i.ATC2_Cod,
	ATC2_Des  = i.ATC2_Des,
	ATC3_Cod  = i.ATC3_Cod,
	ATC3_Des  = i.ATC3_Des,
	ATC4_Cod  = i.ATC4_Cod, 
	ATC4_Des  = i.ATC4_Des,
	Corp_Desc = g.Manufacturer_name,
	MNC = i.MNC
-- select distinct
-- 		i.ATC1_Cod, i.ATC1_Des, i.ATC2_Cod, i.ATC2_Des, i.ATC3_Cod, i.ATC3_Des, i.ATC4_Cod, i.ATC4_Des,
-- 		e.Manufacturer_name as [MANUFACT. DESC], g.Manufacturer_name as [CORPORATE DESC], j.CMPS_COD as [COMPS ABBR],
-- 		K.CMPS_des as [COMPS DESC], Product_name as [PRODUCT DESC], l.* 
from	Dim_Pack a
inner join Dim_Product b on a.Product_id = b.Product_ID
inner join Dim_Product_Molecule c on b.Product_id = c.Product_id
inner join Dim_Molecule d on c.molecule_id = d.molecule_id
inner join Dim_Manufacturer e on b.Manufacturer_id = e.Manufacturer_id
inner join Dim_Manufacturer g on e.corporation_id = g.Manufacturer_ID
inner join Dim_ManufacturerType f on e.ManufacturerType_ID = f.ManufacturerType_ID
inner join Dim_Therapeutic_Class h on a.Therapeutic_ID = h.Therapeutic_ID
inner join tblMktDef_ATCDriver i on a.pack_code = i.Pack_Cod
right join Max_Data as l
	on d.Molecule_Name = l.[通用名（标准_英文）]
		   and b.Product_Name = l.[商品名（标准_英文）]
		   and e.Manufacturer_name = l.[IMS_Manu]
--where	l.[通用名（标准_英文）] in ( 'ADEFOVIR DIPIVOXIL', 'LAMIVUDINE', 'TENOFOVIR DISOPROXIL', 'TELBIVUDINE', 'ENTECAVIR' )



--2. 去除引号
update Dim_City set 
	City_Code = replace(City_Code,'"',''),
	City_Name = replace(City_Name,'"','')
go
update Dim_Manufacturer set 
	Manufacturer_Code = replace(Manufacturer_Code,'"',''),
	Manufacturer_Name = replace(Manufacturer_Name,'"',''),
	Manufacturer_Abbr = replace(Manufacturer_Abbr,'"','')
go
update Dim_ManufacturerType set 
	ManufacturerType_Code = replace(ManufacturerType_Code,'"',''),
	ManufacturerType_Name = replace(ManufacturerType_Name,'"','')
go
update Dim_Molecule set 
	Molecule_code = replace(Molecule_code,'"',''),
	Molecule_name = replace(Molecule_name,'"','')
go
update Dim_New_Form_Class set 
	NewFormClass_Code = replace(NewFormClass_Code,'"',''),
	NewFormClass_Name = replace(NewFormClass_Name,'"','')
go
update Dim_Pack set 
	Pack_Code = replace(Pack_Code,'"',''),
	Pack_Description = replace(Pack_Description,'"',''),
	LaunchTime = replace(LaunchTime,'"','')
go
update Dim_Product set 
	Product_Code = replace(Product_Code,'"',''),
	Product_Name = replace(Product_Name,'"',''),
	LaunchTime = replace(LaunchTime,'"','')
go
update Dim_Therapeutic_Class set 
	Therapeutic_Code = replace(Therapeutic_Code,'"',''),
	Therapeutic_Name = replace(Therapeutic_Name,'"','')
GO
update dim_city
set city_name =replace(city_name,' *','')
where city_name like '% *%'



--3. Dim_City
alter table Dim_City add City_Name_CH nvarchar(50), Tier int
go
update Dim_City set City_Name = 'Pearl River delta' where City_Name = 'PRD'
update Dim_City set City_Name = 'Xian' where City_Name = 'Xi''an'
go
update Dim_City set Tier = b.Tier, City_Name_CH = b.City_Name_CH
from Dim_City a inner join tblCityInfo b on a.City_Name = b.City_Name
go

update dim_city
set City_Name_CH=N'广东'
where city_name='Guangdong'

update dim_city
set City_Name_CH=N'浙江'
where city_name='Zhejiang'

exec dbo.sp_Log_Event 'In','CIA','0_3_in_IMS.sql','End',null,null
--delete from dim_city where city_name='Guangdong'
--select * from dim_city