
-- import MAX Data 

IF OBJECT_ID(N'Max_Data',N'U') IS NOT NULL
    drop table Max_Data
go

-- import from RawData database for current month data 
declare @CurrMonth varchar(10)
select @CurrMonth = [Value] from Config where Parameter = 'IMS'
print @CurrMonth
exec('select * into Max_Data from BMSChinaCIARawdata.dbo.Max_' + @CurrMonth)

-- 检查MAX数据是否有增加新的manu或Production -- todo 
if exists(
        select * from Max_Data as a 
        left join tblMAXManuDef as b 
        on a.[生产厂家（标准_英文）] = b.name and a.[生产厂家（标准_中文）] = b.namec
            and a.[商品名（标准_英文）] = b.ProdName
        where b.name is null 
)
begin 
    select 'New Manu or Prod in MAXData. ' 
    
    select * from Max_Data as a 
        left join tblMAXManuDef as b 
        on a.[生产厂家（标准_英文）] = b.name and a.[生产厂家（标准_中文）] = b.namec
            and a.[商品名（标准_英文）] = b.ProdName
        where b.name is null 
end 

-- MAX数据添加IMS_Manu, IMSProd
alter table Max_Data 
add IMS_Manu varchar(255),
	Final_Prod varchar(255), -- 显示用商品名
	IMS_Prod varchar(255) -- IMS 数据中商品名
go 

update a 
set a.IMS_Manu = b.IMS_Manu
from Max_Data as a 
inner join 	tblMAXManuDef as b 
on a.[生产厂家（标准_英文）] = b.name and a.[生产厂家（标准_中文）] = b.namec
	and a.[商品名（标准_英文）] = b.ProdName

update a 
set a.Final_Prod = b.FinalProd
from Max_Data as a 
inner join 	tblMAXProdUpdate as b 
on a.IMS_Manu = b.IMS_Manu and a.[通用名（标准_英文）] = b.MoleculeName 
	and a.[商品名（标准_英文）] = b.ProductName

update a 
set a.IMS_Prod = a.[商品名（标准_英文）]
from Max_Data as a 
where a.IMS_Prod = '' or a.IMS_Prod is null

update a 
set a.Final_Prod = a.[商品名（标准_英文）]
from Max_Data as a 
where a.Final_Prod = '' or a.Final_Prod is null

update a 
set a.IMS_Prod = b.IMSProd
from Max_Data as a 
inner join 	tblMAXProdUpdate as b 
on a.IMS_Manu = b.IMS_Manu and a.[通用名（标准_英文）] = b.MoleculeName 
	and a.[商品名（标准_英文）] = b.ProductName


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
	[Mole_cod] [varchar] (20) ,
	[Mole_des] [varchar] (255),
	[Prod_cod] [varchar] (20) ,
	[Prod_Des] [varchar] (255),
	[Pack_Cod] [varchar] (20) ,
	[Pack_Des] [varchar] (456),
	[Corp_cod] [varchar] (10) ,
	[Corp_Des] [varchar] (255),
	[manu_cod] [varchar] (10) ,
	[Manu_des] [varchar] (255),
	[MNC] [varchar] (1) ,
	[Gene_Cod] [varchar] (1) 
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
	[Mole_cod] = i.[Mole_cod],
	[Mole_des] = i.[Mole_des],
	[Prod_cod] = i.[Prod_cod],
	[Prod_Des] = i.[Prod_Des],
	[Pack_Cod] = i.[Pack_Cod],
	[Pack_Des] = i.[Pack_Des],
	[Corp_cod] = i.[Corp_cod],
	[Corp_Des] = i.[Corp_Des],
	[manu_cod] = i.[manu_cod],
	[Manu_des] = i.[Manu_des],
	[MNC] 	   = i.[MNC] ,	 
	[Gene_Cod] = i.[Gene_Cod]
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
		   and b.Product_Name = l.IMS_Prod
		   and e.Manufacturer_name = l.[IMS_Manu]
--where	l.[通用名（标准_英文）] in ( 'ADEFOVIR DIPIVOXIL', 'LAMIVUDINE', 'TENOFOVIR DISOPROXIL', 'TELBIVUDINE', 'ENTECAVIR' )


if object_id(N'MAXDataNotInIMS',N'U') is not null
	drop table MAXDataNotInIMS
go

select distinct IMS_Prod, Product, final_Prod, IMS_Manu, [通用名（标准_英文）], 
	row_number() over(order by IMS_Manu) as Idx , 
	convert(varchar(20), '') as Prod_cod, 
	convert(varchar(20), '') as Pack_Cod,
	convert(varchar(20), '') as Corp_cod 
into MAXDataNotInIMS
from dbo.Max_Data
where ATC1_Cod is null 

update  MAXDataNotInIMS
set Prod_cod = 99999 - Idx,
	Pack_Cod = 9999999 - Idx
	

update l
set ATC1_Cod  = i.ATC1_Cod,
	ATC1_Des  = i.ATC1_Des,
	ATC2_Cod  = i.ATC2_Cod,
	ATC2_Des  = i.ATC2_Des,
	ATC3_Cod  = i.ATC3_Cod,
	ATC3_Des  = i.ATC3_Des,
	ATC4_Cod  = i.ATC4_Cod, 
	ATC4_Des  = i.ATC4_Des,
	[Mole_cod] = i.[Mole_cod],
	[Mole_des] = i.[Mole_des],
	[Prod_cod] = i.[Prod_cod],
	[Prod_Des] = isnull(i.[Prod_Des], l.Final_Prod),
	[Pack_Cod] = i.[Pack_Cod],
	[Pack_Des] = i.[Pack_Des],
	[Corp_cod] = i.[Corp_cod],
	[Corp_Des] = i.[Corp_Des],
	[manu_cod] = i.[manu_cod],
	[Manu_des] = isnull(i.[Manu_des], l.IMS_Manu),
	[MNC] 	   = i.[MNC] ,	 
	[Gene_Cod] = i.[Gene_Cod]
from	Max_Data as l
	, (
	select distinct
			a.[ATC1_Cod], a.[ATC1_Des], a.[ATC2_Cod], a.[ATC2_Des], a.[ATC3_Cod], a.[ATC3_Des], 
			a.[ATC4_Cod], a.[ATC4_Des], a.[Mole_cod], a.[Mole_des],
			c.Pack_cod as Pack_Cod, null as Pack_Des, c.Prod_cod as Prod_cod, null as Prod_Des, b.[Corp_cod], b.[Corp_Des],   
			b.[manu_cod], b.[Manu_des], b.[MNC],
			b.Gene_Cod, IMS_Manu, [通用名（标准_英文）], final_Prod
	from	MAXDataNotInIMS as c
	inner join dbo.[tblMktDef_Inline] as a on a.Mole_des = c.[通用名（标准_英文）]
	inner join dbo.[tblMktDef_Inline] as b on b.Manu_des = c.IMS_Manu 
	where b.Mkt in ( 'arv' )
	union all 
	select distinct
			a.[ATC1_Cod], a.[ATC1_Des], a.[ATC2_Cod], a.[ATC2_Des], a.[ATC3_Cod], a.[ATC3_Des], 
			a.[ATC4_Cod], a.[ATC4_Des], a.[Mole_cod], a.[Mole_des],
			c.Pack_Cod as Pack_Cod, null as Pack_Des, c.Prod_Cod as Prod_cod, null as Prod_Des, null as Corp_cod, null as Corp_Des,   
			null as manu_cod, null as Manu_des, '' as MNC,
			'N' as Gene_Cod, IMS_Manu, [通用名（标准_英文）], final_Prod
	from	MAXDataNotInIMS as c
	inner join dbo.[tblMktDef_Inline] as a on a.Mole_des = c.[通用名（标准_英文）]
	left join dbo.[tblMktDef_Inline] as b on b.Manu_des = c.IMS_Manu 
	where b.Manu_des is null 
) as  i
where l.IMS_Manu = i.IMS_Manu 
	 and l.[通用名（标准_英文）] = l.[通用名（标准_英文）]
	 and l.final_Prod = i.final_Prod

