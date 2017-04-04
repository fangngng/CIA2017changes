
-- import MAX Data 

IF OBJECT_ID(N'Max_Data',N'U') IS NOT NULL
    drop table Max_Data
go

-- import from RawData database for current month data 
declare @CurrMonth varchar(10)
select @CurrMonth = [Value] from Config where Parameter = 'MAXDATA'
-- select @CurrMonth = '201612'
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
	[Gene_Cod] [varchar] (1) ,
	[MNFL_COD] [varchar] (20)
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
	[Gene_Cod] = i.[Gene_Cod],
	[MNFL_COD] = f.[ManufacturerType_Code]
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

go 

-------------------------------
-- inMAXData
if exists (select * from dbo.sysobjects where id = object_id(N'inMAXData') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table inMAXData
go
select Province, City, Product, [剂型（标准_英文）] as Package, [药品规格（标准_英文）] as Specification,
	IMS_Manu, Final_Prod, IMS_Prod, ATC1_Cod, ATC1_Des, ATC2_Cod, ATC2_Des, ATC3_Cod, ATC3_Des, ATC4_Cod,
	ATC4_Des, Mole_cod, Mole_des, Prod_cod, Prod_Des, Pack_Cod, Pack_Des, Corp_cod, Corp_Des, manu_cod, Manu_des,
	MNC, Gene_Cod , MNFL_COD
into inMAXData 
from dbo.Max_Data
where 1 = 0
go 

declare @sql nvarchar(max) , @maxMonth int, @nowMonth varchar(10), @i int , @columnName varchar(20), @j int 

set @nowMonth = ( select value from dbo.Config where Parameter = 'MAXDATA')
set @maxMonth = ( select value from dbo.Config where Parameter = 'MaxMonth')


set @sql = '
alter table inMAXData
add '
set @sql = @sql + dbo.fnAddColumns('MTH', 'LC', @maxMonth - 1) + ','
set @sql = @sql + dbo.fnAddColumns('MTH', 'US', @maxMonth - 1) + ','
set @sql = @sql + dbo.fnAddColumns('MTH', 'UN', @maxMonth - 1) 
-- print @sql 
exec(@sql)

set @sql = N'insert into inMAXData 
select Province, City, Product, [剂型（标准_英文）] as Package, [药品规格（标准_英文）] as Specification,
	IMS_Manu, Final_Prod, IMS_Prod, ATC1_Cod, ATC1_Des, ATC2_Cod, ATC2_Des, ATC3_Cod, ATC3_Des, ATC4_Cod,
	ATC4_Des, Mole_cod, Mole_des, Prod_cod, Prod_Des, Pack_Cod, Pack_Des, Corp_cod, Corp_Des, manu_cod, Manu_des,
	MNC, Gene_Cod , MNFL_COD, 
'

set @j = 1
while @j <= 3 
begin
	set @i = 1 
	while @i <= @maxMonth 
	begin 
		declare @temp varchar(10)

		-- set @temp = (select case @j 
		-- 					when 1 then 'LC'
		-- 					when 2 then 'US'
		-- 					else 'UN'
		-- 					end
		-- )
		-- set @temp = '[MTH' + right( '00' + convert(varchar(2), @i), 2 ) + @temp + ']'
		set @columnName =  (select convert(varchar(10), Date) from tblMonthList where MonSeq = @i) +
			( select case @j 
						when 1 then ' Value（RMB）'
						when 2 then ' Value（USD）'
						when 3 then ' Dosage Unit'
						end 
			)

		if exists(
				SELECT a.name, b.name 
				from sys.columns as a 
				inner join sys.objects as b on a.object_id = b.object_id
				where b.name = 'Max_Data' and a.name = @columnName
		)
		begin 
			set @sql = @sql + ' isnull(abs([' + @columnName + ']), 0) , '
		end 
		else 
		begin
			set @sql = @sql + ' 0, '
		end
		set @i = @i + 1
	end 
	set @j = @j + 1
end
set @sql = left(@sql, len(@sql) - 1)
set @sql = @sql + '
from dbo.Max_Data
'

-- print @sql 
exec(@sql)

go 
declare @sql varchar(max)

-----------MAT 
set @sql = '
alter table inMAXData
add '
set @sql = @sql + dbo.fnAddColumns('MAT', 'LC', 48) + ','
set @sql = @sql + dbo.fnAddColumns('MAT', 'US', 48) + ','
set @sql = @sql + dbo.fnAddColumns('MAT', 'UN', 48) 
-- print @sql 
exec(@sql)

set @sql = '
update inMAXData
set ' 
set @sql = @sql + dbo.fnGetformulaMAT('LC', 48)  + ','
set @sql = @sql + dbo.fnGetformulaMAT('US', 48)  + ','
set @sql = @sql + dbo.fnGetformulaMAT('UN', 48) 
-- print @sql 
exec(@sql)

------------- MQT
set @sql = '
alter table inMAXData
add '
set @sql = @sql + dbo.fnAddColumns('R3M', 'LC', 48) + ','
set @sql = @sql + dbo.fnAddColumns('R3M', 'US', 48) + ','
set @sql = @sql + dbo.fnAddColumns('R3M', 'UN', 48) 
-- print @sql 
exec(@sql)

set @sql = '
update inMAXData
set ' 
set @sql = @sql + dbo.fnGetformulaR3M('LC', 48)  + ','
set @sql = @sql + dbo.fnGetformulaR3M('US', 48)  + ','
set @sql = @sql + dbo.fnGetformulaR3M('UN', 48) 
-- print @sql 
exec(@sql)

------------- YTD
set @sql = '
alter table inMAXData
add '
set @sql = @sql + dbo.fnAddColumns('YTD', 'LC', 48) + ','
set @sql = @sql + dbo.fnAddColumns('YTD', 'US', 48) + ','
set @sql = @sql + dbo.fnAddColumns('YTD', 'UN', 48) 
-- print @sql 
exec(@sql)

set @sql = '
update inMAXData
set ' 
set @sql = @sql + dbo.fnGetformulaYTD('LC', 48)  + ','
set @sql = @sql + dbo.fnGetformulaYTD('US', 48)  + ','
set @sql = @sql + dbo.fnGetformulaYTD('UN', 48) 
-- print @sql 
exec(@sql)

------------- QTR
set @sql = '
alter table inMAXData
add '
set @sql = @sql + dbo.fnAddColumns('QTR', 'LC', 19) + ','
set @sql = @sql + dbo.fnAddColumns('QTR', 'US', 19) + ','
set @sql = @sql + dbo.fnAddColumns('QTR', 'UN', 19) 
-- print @sql 
exec(@sql)

set @sql = '
update inMAXData
set ' 
set @sql = @sql + dbo.fnGetformulaQTR('LC', 19)  + ','
set @sql = @sql + dbo.fnGetformulaQTR('US', 19)  + ','
set @sql = @sql + dbo.fnGetformulaQTR('UN', 19) 
-- print @sql 
exec(@sql)

update inMAXData 
set city = replace(city, N'市', '')


go 

-- add max data to MTHCITY_PKAU
alter table MTHCITY_PKAU
alter column Audi_Cod varchar(50)
go

insert	into dbo.MTHCITY_PKAU ( CITY_ID, AUDI_COD, PACK_COD, PACK_DES, ATC1_COD, ATC2_COD, ATC3_COD, ATC4_COD, PROD_COD,
								MANU_COD, MNFL_COD, CORP_COD, MTH00UN, MTH01UN, MTH02UN, MTH03UN, MTH04UN, MTH05UN,
								MTH06UN, MTH07UN, MTH08UN, MTH09UN, MTH10UN, MTH11UN, MTH12UN, MTH13UN, MTH14UN, MTH15UN,
								MTH16UN, MTH17UN, MTH18UN, MTH19UN, MTH20UN, MTH21UN, MTH22UN, MTH23UN, MTH24UN, MTH25UN,
								MTH26UN, MTH27UN, MTH28UN, MTH29UN, MTH30UN, MTH31UN, MTH32UN, MTH33UN, MTH34UN, MTH35UN,
								MTH36UN, MTH37UN, MTH38UN, MTH39UN, MTH40UN, MTH41UN, MTH42UN, MTH43UN, MTH44UN, MTH45UN,
								MTH46UN, MTH47UN, MTH48UN, MTH49UN, MTH50UN, MTH51UN, MTH52UN, MTH53UN, MTH54UN, MTH55UN,
								MTH56UN, MTH57UN, MTH58UN, MTH59UN, MTH60UN, MTH61UN, MTH62UN, MTH63UN, MTH64UN, MTH65UN,
								MTH66UN, MTH67UN, MTH68UN, MTH69UN, MTH70UN, MTH71UN, MTH00LC, MTH01LC, MTH02LC, MTH03LC,
								MTH04LC, MTH05LC, MTH06LC, MTH07LC, MTH08LC, MTH09LC, MTH10LC, MTH11LC, MTH12LC, MTH13LC,
								MTH14LC, MTH15LC, MTH16LC, MTH17LC, MTH18LC, MTH19LC, MTH20LC, MTH21LC, MTH22LC, MTH23LC,
								MTH24LC, MTH25LC, MTH26LC, MTH27LC, MTH28LC, MTH29LC, MTH30LC, MTH31LC, MTH32LC, MTH33LC,
								MTH34LC, MTH35LC, MTH36LC, MTH37LC, MTH38LC, MTH39LC, MTH40LC, MTH41LC, MTH42LC, MTH43LC,
								MTH44LC, MTH45LC, MTH46LC, MTH47LC, MTH48LC, MTH49LC, MTH50LC, MTH51LC, MTH52LC, MTH53LC,
								MTH54LC, MTH55LC, MTH56LC, MTH57LC, MTH58LC, MTH59LC, MTH60LC, MTH61LC, MTH62LC, MTH63LC,
								MTH64LC, MTH65LC, MTH66LC, MTH67LC, MTH68LC, MTH69LC, MTH70LC, MTH71LC, MTH00US, MTH01US,
								MTH02US, MTH03US, MTH04US, MTH05US, MTH06US, MTH07US, MTH08US, MTH09US, MTH10US, MTH11US,
								MTH12US, MTH13US, MTH14US, MTH15US, MTH16US, MTH17US, MTH18US, MTH19US, MTH20US, MTH21US,
								MTH22US, MTH23US, MTH24US, MTH25US, MTH26US, MTH27US, MTH28US, MTH29US, MTH30US, MTH31US,
								MTH32US, MTH33US, MTH34US, MTH35US, MTH36US, MTH37US, MTH38US, MTH39US, MTH40US, MTH41US,
								MTH42US, MTH43US, MTH44US, MTH45US, MTH46US, MTH47US, MTH48US, MTH49US, MTH50US, MTH51US,
								MTH52US, MTH53US, MTH54US, MTH55US, MTH56US, MTH57US, MTH58US, MTH59US, MTH60US, MTH61US,
								MTH62US, MTH63US, MTH64US, MTH65US, MTH66US, MTH67US, MTH68US, MTH69US, MTH70US, MTH71US,
								MAT00US, MAT01US, MAT02US, MAT03US, MAT04US, MAT05US, MAT06US, MAT07US, MAT08US, MAT09US,
								MAT10US, MAT11US, MAT12US, MAT13US, MAT14US, MAT15US, MAT16US, MAT17US, MAT18US, MAT19US,
								MAT20US, MAT21US, MAT22US, MAT23US, MAT24US, MAT25US, MAT26US, MAT27US, MAT28US, MAT29US,
								MAT30US, MAT31US, MAT32US, MAT33US, MAT34US, MAT35US, MAT36US, MAT37US, MAT38US, MAT39US,
								MAT40US, MAT41US, MAT42US, MAT43US, MAT44US, MAT45US, MAT46US, MAT47US, MAT48US, MAT00LC,
								MAT01LC, MAT02LC, MAT03LC, MAT04LC, MAT05LC, MAT06LC, MAT07LC, MAT08LC, MAT09LC, MAT10LC,
								MAT11LC, MAT12LC, MAT13LC, MAT14LC, MAT15LC, MAT16LC, MAT17LC, MAT18LC, MAT19LC, MAT20LC,
								MAT21LC, MAT22LC, MAT23LC, MAT24LC, MAT25LC, MAT26LC, MAT27LC, MAT28LC, MAT29LC, MAT30LC,
								MAT31LC, MAT32LC, MAT33LC, MAT34LC, MAT35LC, MAT36LC, MAT37LC, MAT38LC, MAT39LC, MAT40LC,
								MAT41LC, MAT42LC, MAT43LC, MAT44LC, MAT45LC, MAT46LC, MAT47LC, MAT48LC, MAT00UN, MAT01UN,
								MAT02UN, MAT03UN, MAT04UN, MAT05UN, MAT06UN, MAT07UN, MAT08UN, MAT09UN, MAT10UN, MAT11UN,
								MAT12UN, MAT13UN, MAT14UN, MAT15UN, MAT16UN, MAT17UN, MAT18UN, MAT19UN, MAT20UN, MAT21UN,
								MAT22UN, MAT23UN, MAT24UN, MAT25UN, MAT26UN, MAT27UN, MAT28UN, MAT29UN, MAT30UN, MAT31UN,
								MAT32UN, MAT33UN, MAT34UN, MAT35UN, MAT36UN, MAT37UN, MAT38UN, MAT39UN, MAT40UN, MAT41UN,
								MAT42UN, MAT43UN, MAT44UN, MAT45UN, MAT46UN, MAT47UN, MAT48UN, R3M00US, R3M01US, R3M02US,
								R3M03US, R3M04US, R3M05US, R3M06US, R3M07US, R3M08US, R3M09US, R3M10US, R3M11US, R3M12US,
								R3M13US, R3M14US, R3M15US, R3M16US, R3M17US, R3M18US, R3M19US, R3M20US, R3M21US, R3M22US,
								R3M23US, R3M24US, R3M25US, R3M26US, R3M27US, R3M28US, R3M29US, R3M30US, R3M31US, R3M32US,
								R3M33US, R3M34US, R3M35US, R3M36US, R3M37US, R3M38US, R3M39US, R3M40US, R3M41US, R3M42US,
								R3M43US, R3M44US, R3M45US, R3M46US, R3M47US, R3M48US, R3M00LC, R3M01LC, R3M02LC, R3M03LC,
								R3M04LC, R3M05LC, R3M06LC, R3M07LC, R3M08LC, R3M09LC, R3M10LC, R3M11LC, R3M12LC, R3M13LC,
								R3M14LC, R3M15LC, R3M16LC, R3M17LC, R3M18LC, R3M19LC, R3M20LC, R3M21LC, R3M22LC, R3M23LC,
								R3M24LC, R3M25LC, R3M26LC, R3M27LC, R3M28LC, R3M29LC, R3M30LC, R3M31LC, R3M32LC, R3M33LC,
								R3M34LC, R3M35LC, R3M36LC, R3M37LC, R3M38LC, R3M39LC, R3M40LC, R3M41LC, R3M42LC, R3M43LC,
								R3M44LC, R3M45LC, R3M46LC, R3M47LC, R3M48LC, R3M00UN, R3M01UN, R3M02UN, R3M03UN, R3M04UN,
								R3M05UN, R3M06UN, R3M07UN, R3M08UN, R3M09UN, R3M10UN, R3M11UN, R3M12UN, R3M13UN, R3M14UN,
								R3M15UN, R3M16UN, R3M17UN, R3M18UN, R3M19UN, R3M20UN, R3M21UN, R3M22UN, R3M23UN, R3M24UN,
								R3M25UN, R3M26UN, R3M27UN, R3M28UN, R3M29UN, R3M30UN, R3M31UN, R3M32UN, R3M33UN, R3M34UN,
								R3M35UN, R3M36UN, R3M37UN, R3M38UN, R3M39UN, R3M40UN, R3M41UN, R3M42UN, R3M43UN, R3M44UN,
								R3M45UN, R3M46UN, R3M47UN, R3M48UN, QTR00US, QTR01US, QTR02US, QTR03US, QTR04US, QTR05US,
								QTR06US, QTR07US, QTR08US, QTR09US, QTR10US, QTR11US, QTR12US, QTR13US, QTR14US, QTR15US,
								QTR16US, QTR17US, QTR18US, QTR19US, QTR00LC, QTR01LC, QTR02LC, QTR03LC, QTR04LC, QTR05LC,
								QTR06LC, QTR07LC, QTR08LC, QTR09LC, QTR10LC, QTR11LC, QTR12LC, QTR13LC, QTR14LC, QTR15LC,
								QTR16LC, QTR17LC, QTR18LC, QTR19LC, QTR00UN, QTR01UN, QTR02UN, QTR03UN, QTR04UN, QTR05UN,
								QTR06UN, QTR07UN, QTR08UN, QTR09UN, QTR10UN, QTR11UN, QTR12UN, QTR13UN, QTR14UN, QTR15UN,
								QTR16UN, QTR17UN, QTR18UN, QTR19UN, YTD00US, YTD01US, YTD02US, YTD03US, YTD04US, YTD05US,
								YTD06US, YTD07US, YTD08US, YTD09US, YTD10US, YTD11US, YTD12US, YTD13US, YTD14US, YTD15US,
								YTD16US, YTD17US, YTD18US, YTD19US, YTD20US, YTD21US, YTD22US, YTD23US, YTD24US, YTD25US,
								YTD26US, YTD27US, YTD28US, YTD29US, YTD30US, YTD31US, YTD32US, YTD33US, YTD34US, YTD35US,
								YTD36US, YTD37US, YTD38US, YTD39US, YTD40US, YTD41US, YTD42US, YTD43US, YTD44US, YTD45US,
								YTD46US, YTD47US, YTD48US, YTD00LC, YTD01LC, YTD02LC, YTD03LC, YTD04LC, YTD05LC, YTD06LC,
								YTD07LC, YTD08LC, YTD09LC, YTD10LC, YTD11LC, YTD12LC, YTD13LC, YTD14LC, YTD15LC, YTD16LC,
								YTD17LC, YTD18LC, YTD19LC, YTD20LC, YTD21LC, YTD22LC, YTD23LC, YTD24LC, YTD25LC, YTD26LC,
								YTD27LC, YTD28LC, YTD29LC, YTD30LC, YTD31LC, YTD32LC, YTD33LC, YTD34LC, YTD35LC, YTD36LC,
								YTD37LC, YTD38LC, YTD39LC, YTD40LC, YTD41LC, YTD42LC, YTD43LC, YTD44LC, YTD45LC, YTD46LC,
								YTD47LC, YTD48LC, YTD00UN, YTD01UN, YTD02UN, YTD03UN, YTD04UN, YTD05UN, YTD06UN, YTD07UN,
								YTD08UN, YTD09UN, YTD10UN, YTD11UN, YTD12UN, YTD13UN, YTD14UN, YTD15UN, YTD16UN, YTD17UN,
								YTD18UN, YTD19UN, YTD20UN, YTD21UN, YTD22UN, YTD23UN, YTD24UN, YTD25UN, YTD26UN, YTD27UN,
								YTD28UN, YTD29UN, YTD30UN, YTD31UN, YTD32UN, YTD33UN, YTD34UN, YTD35UN, YTD36UN, YTD37UN,
								YTD38UN, YTD39UN, YTD40UN, YTD41UN, YTD42UN, YTD43UN, YTD44UN, YTD45UN, YTD46UN, YTD47UN,
								YTD48UN )
select	'', b.city, Pack_Cod, Pack_Des, ATC1_Cod, ATC2_Cod, ATC3_Cod, ATC4_Cod, Prod_cod, manu_cod, MNFL_COD,
		Corp_cod, MTH00UN, MTH01UN, MTH02UN, MTH03UN, MTH04UN, MTH05UN, MTH06UN, MTH07UN, MTH08UN, MTH09UN, MTH10UN,
		MTH11UN, MTH12UN, MTH13UN, MTH14UN, MTH15UN, MTH16UN, MTH17UN, MTH18UN, MTH19UN, MTH20UN, MTH21UN, MTH22UN,
		MTH23UN, MTH24UN, MTH25UN, MTH26UN, MTH27UN, MTH28UN, MTH29UN, MTH30UN, MTH31UN, MTH32UN, MTH33UN, MTH34UN,
		MTH35UN, MTH36UN, MTH37UN, MTH38UN, MTH39UN, MTH40UN, MTH41UN, MTH42UN, MTH43UN, MTH44UN, MTH45UN, MTH46UN,
		MTH47UN, MTH48UN, MTH49UN, MTH50UN, MTH51UN, MTH52UN, MTH53UN, MTH54UN, MTH55UN, MTH56UN, MTH57UN, MTH58UN,
		MTH59UN, MTH60UN, MTH61UN, MTH62UN, MTH63UN, MTH64UN, MTH65UN, MTH66UN, MTH67UN, MTH68UN, MTH69UN, MTH70UN,
		MTH71UN, MTH00LC, MTH01LC, MTH02LC, MTH03LC, MTH04LC, MTH05LC, MTH06LC, MTH07LC, MTH08LC, MTH09LC, MTH10LC,
		MTH11LC, MTH12LC, MTH13LC, MTH14LC, MTH15LC, MTH16LC, MTH17LC, MTH18LC, MTH19LC, MTH20LC, MTH21LC, MTH22LC,
		MTH23LC, MTH24LC, MTH25LC, MTH26LC, MTH27LC, MTH28LC, MTH29LC, MTH30LC, MTH31LC, MTH32LC, MTH33LC, MTH34LC,
		MTH35LC, MTH36LC, MTH37LC, MTH38LC, MTH39LC, MTH40LC, MTH41LC, MTH42LC, MTH43LC, MTH44LC, MTH45LC, MTH46LC,
		MTH47LC, MTH48LC, MTH49LC, MTH50LC, MTH51LC, MTH52LC, MTH53LC, MTH54LC, MTH55LC, MTH56LC, MTH57LC, MTH58LC,
		MTH59LC, MTH60LC, MTH61LC, MTH62LC, MTH63LC, MTH64LC, MTH65LC, MTH66LC, MTH67LC, MTH68LC, MTH69LC, MTH70LC,
		MTH71LC, MTH00US, MTH01US, MTH02US, MTH03US, MTH04US, MTH05US, MTH06US, MTH07US, MTH08US, MTH09US, MTH10US,
		MTH11US, MTH12US, MTH13US, MTH14US, MTH15US, MTH16US, MTH17US, MTH18US, MTH19US, MTH20US, MTH21US, MTH22US,
		MTH23US, MTH24US, MTH25US, MTH26US, MTH27US, MTH28US, MTH29US, MTH30US, MTH31US, MTH32US, MTH33US, MTH34US,
		MTH35US, MTH36US, MTH37US, MTH38US, MTH39US, MTH40US, MTH41US, MTH42US, MTH43US, MTH44US, MTH45US, MTH46US,
		MTH47US, MTH48US, MTH49US, MTH50US, MTH51US, MTH52US, MTH53US, MTH54US, MTH55US, MTH56US, MTH57US, MTH58US,
		MTH59US, MTH60US, MTH61US, MTH62US, MTH63US, MTH64US, MTH65US, MTH66US, MTH67US, MTH68US, MTH69US, MTH70US,
		MTH71US, MAT00US, MAT01US, MAT02US, MAT03US, MAT04US, MAT05US, MAT06US, MAT07US, MAT08US, MAT09US, MAT10US,
		MAT11US, MAT12US, MAT13US, MAT14US, MAT15US, MAT16US, MAT17US, MAT18US, MAT19US, MAT20US, MAT21US, MAT22US,
		MAT23US, MAT24US, MAT25US, MAT26US, MAT27US, MAT28US, MAT29US, MAT30US, MAT31US, MAT32US, MAT33US, MAT34US,
		MAT35US, MAT36US, MAT37US, MAT38US, MAT39US, MAT40US, MAT41US, MAT42US, MAT43US, MAT44US, MAT45US, MAT46US,
		MAT47US, MAT48US, MAT00LC, MAT01LC, MAT02LC, MAT03LC, MAT04LC, MAT05LC, MAT06LC, MAT07LC, MAT08LC, MAT09LC,
		MAT10LC, MAT11LC, MAT12LC, MAT13LC, MAT14LC, MAT15LC, MAT16LC, MAT17LC, MAT18LC, MAT19LC, MAT20LC, MAT21LC,
		MAT22LC, MAT23LC, MAT24LC, MAT25LC, MAT26LC, MAT27LC, MAT28LC, MAT29LC, MAT30LC, MAT31LC, MAT32LC, MAT33LC,
		MAT34LC, MAT35LC, MAT36LC, MAT37LC, MAT38LC, MAT39LC, MAT40LC, MAT41LC, MAT42LC, MAT43LC, MAT44LC, MAT45LC,
		MAT46LC, MAT47LC, MAT48LC, MAT00UN, MAT01UN, MAT02UN, MAT03UN, MAT04UN, MAT05UN, MAT06UN, MAT07UN, MAT08UN,
		MAT09UN, MAT10UN, MAT11UN, MAT12UN, MAT13UN, MAT14UN, MAT15UN, MAT16UN, MAT17UN, MAT18UN, MAT19UN, MAT20UN,
		MAT21UN, MAT22UN, MAT23UN, MAT24UN, MAT25UN, MAT26UN, MAT27UN, MAT28UN, MAT29UN, MAT30UN, MAT31UN, MAT32UN,
		MAT33UN, MAT34UN, MAT35UN, MAT36UN, MAT37UN, MAT38UN, MAT39UN, MAT40UN, MAT41UN, MAT42UN, MAT43UN, MAT44UN,
		MAT45UN, MAT46UN, MAT47UN, MAT48UN, R3M00US, R3M01US, R3M02US, R3M03US, R3M04US, R3M05US, R3M06US, R3M07US,
		R3M08US, R3M09US, R3M10US, R3M11US, R3M12US, R3M13US, R3M14US, R3M15US, R3M16US, R3M17US, R3M18US, R3M19US,
		R3M20US, R3M21US, R3M22US, R3M23US, R3M24US, R3M25US, R3M26US, R3M27US, R3M28US, R3M29US, R3M30US, R3M31US,
		R3M32US, R3M33US, R3M34US, R3M35US, R3M36US, R3M37US, R3M38US, R3M39US, R3M40US, R3M41US, R3M42US, R3M43US,
		R3M44US, R3M45US, R3M46US, R3M47US, R3M48US, R3M00LC, R3M01LC, R3M02LC, R3M03LC, R3M04LC, R3M05LC, R3M06LC,
		R3M07LC, R3M08LC, R3M09LC, R3M10LC, R3M11LC, R3M12LC, R3M13LC, R3M14LC, R3M15LC, R3M16LC, R3M17LC, R3M18LC,
		R3M19LC, R3M20LC, R3M21LC, R3M22LC, R3M23LC, R3M24LC, R3M25LC, R3M26LC, R3M27LC, R3M28LC, R3M29LC, R3M30LC,
		R3M31LC, R3M32LC, R3M33LC, R3M34LC, R3M35LC, R3M36LC, R3M37LC, R3M38LC, R3M39LC, R3M40LC, R3M41LC, R3M42LC,
		R3M43LC, R3M44LC, R3M45LC, R3M46LC, R3M47LC, R3M48LC, R3M00UN, R3M01UN, R3M02UN, R3M03UN, R3M04UN, R3M05UN,
		R3M06UN, R3M07UN, R3M08UN, R3M09UN, R3M10UN, R3M11UN, R3M12UN, R3M13UN, R3M14UN, R3M15UN, R3M16UN, R3M17UN,
		R3M18UN, R3M19UN, R3M20UN, R3M21UN, R3M22UN, R3M23UN, R3M24UN, R3M25UN, R3M26UN, R3M27UN, R3M28UN, R3M29UN,
		R3M30UN, R3M31UN, R3M32UN, R3M33UN, R3M34UN, R3M35UN, R3M36UN, R3M37UN, R3M38UN, R3M39UN, R3M40UN, R3M41UN,
		R3M42UN, R3M43UN, R3M44UN, R3M45UN, R3M46UN, R3M47UN, R3M48UN, QTR00US, QTR01US, QTR02US, QTR03US, QTR04US,
		QTR05US, QTR06US, QTR07US, QTR08US, QTR09US, QTR10US, QTR11US, QTR12US, QTR13US, QTR14US, QTR15US, QTR16US,
		QTR17US, QTR18US, QTR19US, QTR00LC, QTR01LC, QTR02LC, QTR03LC, QTR04LC, QTR05LC, QTR06LC, QTR07LC, QTR08LC,
		QTR09LC, QTR10LC, QTR11LC, QTR12LC, QTR13LC, QTR14LC, QTR15LC, QTR16LC, QTR17LC, QTR18LC, QTR19LC, QTR00UN,
		QTR01UN, QTR02UN, QTR03UN, QTR04UN, QTR05UN, QTR06UN, QTR07UN, QTR08UN, QTR09UN, QTR10UN, QTR11UN, QTR12UN,
		QTR13UN, QTR14UN, QTR15UN, QTR16UN, QTR17UN, QTR18UN, QTR19UN, YTD00US, YTD01US, YTD02US, YTD03US, YTD04US,
		YTD05US, YTD06US, YTD07US, YTD08US, YTD09US, YTD10US, YTD11US, YTD12US, YTD13US, YTD14US, YTD15US, YTD16US,
		YTD17US, YTD18US, YTD19US, YTD20US, YTD21US, YTD22US, YTD23US, YTD24US, YTD25US, YTD26US, YTD27US, YTD28US,
		YTD29US, YTD30US, YTD31US, YTD32US, YTD33US, YTD34US, YTD35US, YTD36US, YTD37US, YTD38US, YTD39US, YTD40US,
		YTD41US, YTD42US, YTD43US, YTD44US, YTD45US, YTD46US, YTD47US, YTD48US, YTD00LC, YTD01LC, YTD02LC, YTD03LC,
		YTD04LC, YTD05LC, YTD06LC, YTD07LC, YTD08LC, YTD09LC, YTD10LC, YTD11LC, YTD12LC, YTD13LC, YTD14LC, YTD15LC,
		YTD16LC, YTD17LC, YTD18LC, YTD19LC, YTD20LC, YTD21LC, YTD22LC, YTD23LC, YTD24LC, YTD25LC, YTD26LC, YTD27LC,
		YTD28LC, YTD29LC, YTD30LC, YTD31LC, YTD32LC, YTD33LC, YTD34LC, YTD35LC, YTD36LC, YTD37LC, YTD38LC, YTD39LC,
		YTD40LC, YTD41LC, YTD42LC, YTD43LC, YTD44LC, YTD45LC, YTD46LC, YTD47LC, YTD48LC, YTD00UN, YTD01UN, YTD02UN,
		YTD03UN, YTD04UN, YTD05UN, YTD06UN, YTD07UN, YTD08UN, YTD09UN, YTD10UN, YTD11UN, YTD12UN, YTD13UN, YTD14UN,
		YTD15UN, YTD16UN, YTD17UN, YTD18UN, YTD19UN, YTD20UN, YTD21UN, YTD22UN, YTD23UN, YTD24UN, YTD25UN, YTD26UN,
		YTD27UN, YTD28UN, YTD29UN, YTD30UN, YTD31UN, YTD32UN, YTD33UN, YTD34UN, YTD35UN, YTD36UN, YTD37UN, YTD38UN,
		YTD39UN, YTD40UN, YTD41UN, YTD42UN, YTD43UN, YTD44UN, YTD45UN, YTD46UN, YTD47UN, YTD48UN
from	inmaxdata as a
left join tblCityMAX as b on a.City = b.City_CN 

go
--create index idxPACK_cod on MTHCITY_PKAU(PACK_ID,PACK_COD,PACK_DES)

go 


