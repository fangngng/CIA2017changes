
if exists(select 1 from sysobjects where name='ProcImportCIAIMSDim')
	drop proc ProcImportCIAIMSDim
go

create proc ProcImportCIAIMSDim
	--�˴洢������������IMS����Դ��10��Dim��ͷ��txt�ļ�
as
	--����ʱ������,��Config����ȡ��IMS�������ݵ��·�
	declare @IMSMonth char(6)
	select @IMSMonth=value from BMSChinaCIA_IMS_test.dbo.Config where Parameter='IMS' 

	--Dim_City
	if EXISTS(SELECT 1 FROM sysobjects WHERE name='Dim_City_'+@IMSMonth)
		begin
			exec('drop table Dim_City_'+@IMSMonth)
		end
	begin
		exec('create table dbo.Dim_City_'+@IMSMonth+'(
			[City_ID]	varchar(10),
			[City_Code] varchar(10),
			[City_Name] varchar(50)
		)')
	end
	begin
		exec('BULK INSERT BMSChinaCIARawdata.dbo.Dim_City_'+@IMSMonth+' FROM ''D:\Projects\BMSChina\IMS\Data\Dim_City.txt''')   
	end

	--Dim_Fact_Sales
	if EXISTS(SELECT 1 FROM sysobjects WHERE name='Dim_Fact_Sales_'+@IMSMonth)
		begin
			exec('drop table Dim_Fact_Sales_'+@IMSMonth)
		end
	begin
		exec('create table dbo.Dim_Fact_Sales_'+@IMSMonth+'(
				[Year]			int,
				[Month]			int,
				[Pack_ID]		varchar(20),
				[City_ID]		varchar(20),
				[Quantity_DT]	float,
				[Quantity_ST]	float,
				[Quantity_UN]	float,
				[Amount_IC]		float,
				[Amount_US]		float	
		)')
	end
	begin
		exec('BULK INSERT BMSChinaCIARawdata.dbo.Dim_Fact_Sales_'+@IMSMonth+' FROM ''D:\Projects\BMSChina\IMS\Data\Dim_Fact_Sales.txt''')   
	end

	--Dim_Manufacturer
	if EXISTS(SELECT 1 FROM sysobjects WHERE name='Dim_Manufacturer_'+@IMSMonth)
		begin
			exec('drop table Dim_Manufacturer_'+@IMSMonth)
		end
	begin
		exec('create table dbo.Dim_Manufacturer_'+@IMSMonth+'(
				[Manufacturer_ID]		varchar(10),
				[Manufacturer_Code]		varchar(10),
				[Manufacturer_Name]		varchar(255),
				[Manufacturer_Abbr]		varchar(10),
				[ManufacturerType_ID]	varchar(10),
				[Corporation_ID]		varchar(10)
		)')
	end
	begin
		exec('BULK INSERT BMSChinaCIARawdata.dbo.Dim_Manufacturer_'+@IMSMonth+' FROM ''D:\Projects\BMSChina\IMS\Data\Dim_Manufacturer.txt''')   
	end

	--Dim_ManufacturerType
	if EXISTS(SELECT 1 FROM sysobjects WHERE name='Dim_ManufacturerType_'+@IMSMonth)
		begin
			exec('drop table Dim_ManufacturerType_'+@IMSMonth)
		end
	begin
		exec('create table dbo.Dim_ManufacturerType_'+@IMSMonth+'(
				[ManufacturerType_ID]	varchar(20),
				[ManufacturerType_Code]	varchar(20),
				[ManufacturerType_Name]	varchar(50)
		)')
	end
	begin
		exec('BULK INSERT BMSChinaCIARawdata.dbo.Dim_ManufacturerType_'+@IMSMonth+' FROM ''D:\Projects\BMSChina\IMS\Data\Dim_ManufacturerType.txt''')   
	end

	--Dim_Molecule
	if EXISTS(SELECT 1 FROM sysobjects WHERE name='Dim_Molecule_'+@IMSMonth)
		begin
			exec('drop table Dim_Molecule_'+@IMSMonth)
		end
	begin
		exec('create table dbo.Dim_Molecule_'+@IMSMonth+'(
				[Molecule_ID]	varchar(20),
				[Molecule_Code]	varchar(20),
				[Molecule_Name]	varchar(255)
		)')
	end
	begin
		exec('BULK INSERT BMSChinaCIARawdata.dbo.Dim_Molecule_'+@IMSMonth+' FROM ''D:\Projects\BMSChina\IMS\Data\Dim_Molecule.txt''')   
	end

	--Dim_New_Form_Class
	if EXISTS(SELECT 1 FROM sysobjects WHERE name='Dim_New_Form_Class_'+@IMSMonth)
		begin
			exec('drop table Dim_New_Form_Class_'+@IMSMonth)
		end
	begin
		exec('create table dbo.Dim_New_Form_Class_'+@IMSMonth+'(
				[NewFormClass_ID]	varchar(20),
				[NewFormClass_Code] varchar(20),
				[NewFormClass_Name] varchar(255)
		)')
	end
	begin
		exec('BULK INSERT BMSChinaCIARawdata.dbo.Dim_New_Form_Class_'+@IMSMonth+' FROM ''D:\Projects\BMSChina\IMS\Data\Dim_New_Form_Class.txt''')   
	end

	--Dim_Pack
	if EXISTS(SELECT 1 FROM sysobjects WHERE name='Dim_Pack_'+@IMSMonth)
		begin
			exec('drop table Dim_Pack_'+@IMSMonth)
		end
	begin
		exec('create table dbo.Dim_Pack_'+@IMSMonth+'(
				[Pack_ID] varchar(20),
				[Pack_Code] varchar(20),
				[Pack_Description] varchar(200),
				[Product_ID] varchar(20),
				[NewFormClass_ID] varchar(20),
				[Therapeutic_ID] varchar(20),
				[LaunchTime] varchar(20)
		)')
	end
	begin
		exec('BULK INSERT BMSChinaCIARawdata.dbo.Dim_Pack_'+@IMSMonth+' FROM ''D:\Projects\BMSChina\IMS\Data\Dim_Pack.txt''')   
	end

	--Dim_Product
	if EXISTS(SELECT 1 FROM sysobjects WHERE name='Dim_Product_'+@IMSMonth)
		begin
			exec('drop table Dim_Product_'+@IMSMonth)
		end
	begin
		exec('create table dbo.Dim_Product_'+@IMSMonth+'(
				[Product_ID] varchar(20),
				[Product_Code] varchar(20),
				[Product_Name] varchar(255),
				[Manufacturer_ID] varchar(20),
				[LaunchTime] varchar(20)
		)')
	end
	begin
		exec('BULK INSERT BMSChinaCIARawdata.dbo.Dim_Product_'+@IMSMonth+' FROM ''D:\Projects\BMSChina\IMS\Data\Dim_Product.txt''')   
	end

	--Dim_Product_Molecule
	if EXISTS(SELECT 1 FROM sysobjects WHERE name='Dim_Product_Molecule_'+@IMSMonth)
		begin
			exec('drop table Dim_Product_Molecule_'+@IMSMonth)
		end
	begin
		exec('create table dbo.Dim_Product_Molecule_'+@IMSMonth+'(
				Product_ID varchar(20),
				Molecule_ID varchar(20)
		)')
	end
	begin
		exec('BULK INSERT BMSChinaCIARawdata.dbo.Dim_Product_Molecule_'+@IMSMonth+' FROM ''D:\Projects\BMSChina\IMS\Data\Dim_Product_Molecule.txt''')   
	end

	--Dim_Therapeutic_Class
	if EXISTS(SELECT 1 FROM sysobjects WHERE name='Dim_Therapeutic_Class_'+@IMSMonth)
		begin
			exec('drop table Dim_Therapeutic_Class_'+@IMSMonth)
		end
	begin
		exec('create table dbo.Dim_Therapeutic_Class_'+@IMSMonth+'(
				[Therapeutic_ID] varchar(20),
				[Therapeutic_Code] varchar(20),
				[Therapeutic_Name] varchar(255)
		)')
	end
	begin
		exec('BULK INSERT BMSChinaCIARawdata.dbo.Dim_Therapeutic_Class_'+@IMSMonth+' FROM ''D:\Projects\BMSChina\IMS\Data\Dim_Therapeutic_Class.txt''')   
	end



