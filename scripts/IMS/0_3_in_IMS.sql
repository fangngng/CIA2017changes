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
--exec('select * into Max_Data from BMSChinaCIARawdata.dbo.Max_201612')
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