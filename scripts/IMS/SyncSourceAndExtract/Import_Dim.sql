-- current month	:    201508
-- Previous month	:    201507
-- txt文件目录      ：   D:\Projects\BMSChina\IMS\Data

--time 01:45




USE BMSChinaCIARawdata  --DB4
GO









--Dim_City
if object_id(N'Dim_City_201612', N'U') is not null
	drop table Dim_City_201612
go
create table dbo.Dim_City_201612(
	[City_ID]	varchar(10),
	[City_Code] varchar(10),
	[City_Name] varchar(50)
)
go
exec master..xp_cmdshell 'bcp BMSChinaCIARawdata.dbo.Dim_City_201612 in D:\Projects\BMSChina\IMS\Data\Dim_City.txt -b 100000 -c -F "1" -U"sa" -P"love2you"'  
go

--Dim_Fact_Sales
if object_id(N'Dim_Fact_Sales_201612', N'U') is not null
	drop table Dim_Fact_Sales_201612
go
create table dbo.Dim_Fact_Sales_201612(
	[Year]			int,
	[Month]			int,
	[Pack_ID]		varchar(20),
	[City_ID]		varchar(20),
	[Quantity_DT]	float,
	[Quantity_ST]	float,
	[Quantity_UN]	float,
	[Amount_IC]		float,
	[Amount_US]		float	
)
go
exec master..xp_cmdshell 'bcp BMSChinaCIARawdata.dbo.Dim_Fact_Sales_201612 in D:\Projects\BMSChina\IMS\Data\Dim_Fact_Sales.txt -b 100000 -c -F "1" -U"sa" -P"love2you"'  
go

--Dim_Manufacturer
if object_id(N'Dim_Manufacturer_201612', N'U') is not null
	drop table Dim_Manufacturer_201612
go
create table dbo.Dim_Manufacturer_201612(
	[Manufacturer_ID]		varchar(10),
	[Manufacturer_Code]		varchar(10),
	[Manufacturer_Name]		varchar(255),
	[Manufacturer_Abbr]		varchar(10),
	[ManufacturerType_ID]	varchar(10),
	[Corporation_ID]		varchar(10)
)
go
exec master..xp_cmdshell 'bcp BMSChinaCIARawdata.dbo.Dim_Manufacturer_201612 in D:\Projects\BMSChina\IMS\Data\Dim_Manufacturer.txt -b 100000 -c -F "1" -U"sa" -P"love2you"'  
go

--Dim_ManufacturerType
if object_id(N'Dim_ManufacturerType_201612', N'U') is not null
	drop table Dim_ManufacturerType_201612
go
create table dbo.Dim_ManufacturerType_201612(
	[ManufacturerType_ID]	varchar(20),
	[ManufacturerType_Code]	varchar(20),
	[ManufacturerType_Name]	varchar(50)
)
go
exec master..xp_cmdshell 'bcp BMSChinaCIARawdata.dbo.Dim_ManufacturerType_201612 in D:\Projects\BMSChina\IMS\Data\Dim_ManufacturerType.txt -b 100000 -c -F "1" -U"sa" -P"love2you"'  
go

--Dim_Molecule
if object_id(N'Dim_Molecule_201612', N'U') is not null
	drop table Dim_Molecule_201612
go
create table dbo.Dim_Molecule_201612(
	[Molecule_ID]	varchar(20),
	[Molecule_Code]	varchar(20),
	[Molecule_Name]	varchar(255)
)
go
exec master..xp_cmdshell 'bcp BMSChinaCIARawdata.dbo.Dim_Molecule_201612 in D:\Projects\BMSChina\IMS\Data\Dim_Molecule.txt -b 100000 -c -F "1" -U"sa" -P"love2you"'  
go

--Dim_New_Form_Class
if object_id(N'Dim_New_Form_Class_201612', N'U') is not null
	drop table Dim_New_Form_Class_201612
go
create table dbo.Dim_New_Form_Class_201612(
	[NewFormClass_ID]	varchar(20),
	[NewFormClass_Code] varchar(20),
	[NewFormClass_Name] varchar(255)
)
go
exec master..xp_cmdshell 'bcp BMSChinaCIARawdata.dbo.Dim_New_Form_Class_201612 in D:\Projects\BMSChina\IMS\Data\Dim_New_Form_Class.txt -b 100000 -c -F "1" -U"sa" -P"love2you"'  
go

--Dim_Pack
if object_id(N'Dim_Pack_201612', N'U') is not null
	drop table Dim_Pack_201612
go
create table dbo.Dim_Pack_201612(
	[Pack_ID] varchar(20),
	[Pack_Code] varchar(20),
	[Pack_Description] varchar(200),
	[Product_ID] varchar(20),
	[NewFormClass_ID] varchar(20),
	[Therapeutic_ID] varchar(20),
	[LaunchTime] varchar(20)
)
go
exec master..xp_cmdshell 'bcp BMSChinaCIARawdata.dbo.Dim_Pack_201612 in D:\Projects\BMSChina\IMS\Data\Dim_Pack.txt -b 100000 -c -F "1" -U"sa" -P"love2you"'  
go

--Dim_Product
if object_id(N'Dim_Product_201612', N'U') is not null
	drop table Dim_Product_201612
go
create table dbo.Dim_Product_201612(
	[Product_ID] varchar(20),
	[Product_Code] varchar(20),
	[Product_Name] varchar(255),
	[Manufacturer_ID] varchar(20),
	[LaunchTime] varchar(20)
)
go
exec master..xp_cmdshell 'bcp BMSChinaCIARawdata.dbo.Dim_Product_201612 in D:\Projects\BMSChina\IMS\Data\Dim_Product.txt -b 100000 -c -F "1" -U"sa" -P"love2you"'  
go

--Dim_Product_Molecule
if object_id(N'Dim_Product_Molecule_201612', N'U') is not null
	drop table Dim_Product_Molecule_201612
go
create table dbo.Dim_Product_Molecule_201612(
	Product_ID varchar(20),
	Molecule_ID varchar(20)
)
go
exec master..xp_cmdshell 'bcp BMSChinaCIARawdata.dbo.Dim_Product_Molecule_201612 in D:\Projects\BMSChina\IMS\Data\Dim_Product_Molecule.txt -b 100000 -c -F "1" -U"sa" -P"love2you"'  
go

--Dim_Therapeutic_Class
if object_id(N'Dim_Therapeutic_Class_201612', N'U') is not null
	drop table Dim_Therapeutic_Class_201612
go
create table dbo.Dim_Therapeutic_Class_201612(
	[Therapeutic_ID] varchar(20),
	[Therapeutic_Code] varchar(20),
	[Therapeutic_Name] varchar(255)
)
go
exec master..xp_cmdshell 'bcp BMSChinaCIARawdata.dbo.Dim_Therapeutic_Class_201612 in D:\Projects\BMSChina\IMS\Data\Dim_Therapeutic_Class.txt -b 100000 -c -F "1" -U"sa" -P"love2you"'  
go



print '------------ check rawdata -----------'

select count(*) as Dim_City from Dim_City_201612 union all
select count(*) as Dim_City from Dim_City_201611 

select count(*) as Dim_Fact_Sales from Dim_Fact_Sales_201612 union all
select count(*) as Dim_Fact_Sales from Dim_Fact_Sales_201611

select count(*) as Dim_Manufacturer from Dim_Manufacturer_201612 union all
select count(*) as Dim_Manufacturer from Dim_Manufacturer_201611

select count(*) as Dim_ManufacturerType from Dim_ManufacturerType_201612 union all
select count(*) as Dim_ManufacturerType from Dim_ManufacturerType_201611

select count(*) as Dim_Molecule from Dim_Molecule_201612 union all
select count(*) as Dim_Molecule from Dim_Molecule_201611

select count(*) as Dim_New_Form_Class from Dim_New_Form_Class_201612 union all
select count(*) as Dim_New_Form_Class from Dim_New_Form_Class_201611

select count(*) as Dim_Pack from Dim_Pack_201612 union all
select count(*) as Dim_Pack from Dim_Pack_201611

select count(*) as Dim_Product from Dim_Product_201612 union all
select count(*) as Dim_Product from Dim_Product_201611

select count(*) as Dim_Product_Molecule from Dim_Product_Molecule_201612 union all
select count(*) as Dim_Product_Molecule from Dim_Product_Molecule_201611

select count(*) as Dim_Therapeutic_Class from Dim_Therapeutic_Class_201612 union all
select count(*) as Dim_Therapeutic_Class from Dim_Therapeutic_Class_201611
go

print '------------------Each Month Fact Sales Check--------------------------'
select year,month,sum(quantity_dt)as quantity_dt,sum(quantity_st) as quantity_dt,sum(quantity_un) as quantity_un,
	sum(amount_ic) as amount_ic, sum(amount_us) as amount_us
from Dim_Fact_Sales_201612
group by year,Month
order by year,month

print '------------------Check change of city--------------------------'
SELECT * FROM DIM_CITY_201611 A FULL JOIN Dim_City_201612 B
ON A.CITY_ID=B.CITY_ID AND A.CITY_CODE=B.CITY_CODE
WHERE A.CITY_ID IS NULL OR B.CITY_ID IS NULL