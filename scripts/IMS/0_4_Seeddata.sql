/* 生成MTHCHPA_PKAU和MTHCITY_PKAU */
USE BMSChinaCIA_IMS
go
--需25分钟
--1h6min
--45分钟，2013-08-19跑上半年数据（H1&Q2）
--47min,2013-09-10跑7月份的数据
--Time:19:57 201603






exec dbo.sp_Log_Event 'SeedData','CIA','0_4_Seeddata.sql','inMonthlySales',null,null
print (N'
-----------------------------------------------------------
                   inMonthlySales
-----------------------------------------------------------
')
if object_id(N'inMonthlySales', N'U') is not null 
  Drop table inMonthlySales
GO
select 
    a.[Year]      --
  , a.[Month]     --
  , i.[MonSeq]
  , a.Quantity_DT --UN1
  , a.Quantity_ST --UN2
  , a.Quantity_UN --UN3
  , convert(float, 0) as Quantity_DosingUnits   --UN
  , convert(float, 0) as Quantity_PatientNumber --PN
  , a.AMOUNT_IC                                 --RMB
  , a.AMOUNT_US                                 --USD
  , a.City_ID     --
  , a.Pack_ID     --
  , b.City_Code
  , b.City_Name
  , b.City_Name_CH
  , b.Tier
  , c.Pack_Code
  , c.Pack_Description
  , c.Product_ID
  , c.Therapeutic_ID
  , d.Product_Code
  , d.Product_Name
  , d.Manufacturer_ID
  , e.Manufacturer_Code
  , e.Corporation_ID
  , e.ManufacturerType_ID
  , f.ManufacturerType_Code
  , g.Therapeutic_Code
into inMonthlySales 
from Dim_Fact_Sales a 
left join Dim_City b on a.City_ID = b.City_ID
left join Dim_Pack c on a.Pack_ID = c.Pack_ID
left join Dim_Product d on c.Product_ID = d.Product_ID 
left join Dim_Manufacturer e on d.Manufacturer_ID = e.Manufacturer_ID
left join Dim_ManufacturerType f on e.ManufacturerType_ID = f.ManufacturerType_ID
left join Dim_Therapeutic_Class g on c.Therapeutic_ID = g.Therapeutic_ID
left join tblMonthList i on a.[Year] = i.[Year] and a.[Month] = i.[Month]
GO


alter table inMonthlySales add
CUF float not null default 0,
SUF float not null default 0,
AUDI_COD varchar(10),
PACK_COD varchar(10),
PACK_DES varchar(200),
PROD_COD varchar(10),
ATC1_COD varchar(10),
ATC2_COD varchar(10),
ATC3_COD varchar(10),
ATC4_COD varchar(10),
MANU_ID  varchar(20),
MANU_COD varchar(20),
MNFL_ID  varchar(20),
MNFL_COD varchar(20),
CORP_ID  varchar(20),
CORP_COD varchar(20)
GO

--SUF/CUF
update inMonthlySales set SUF = Quantity_ST/Quantity_DT where Quantity_DT <> 0 
update inMonthlySales set CUF = Quantity_ST/Quantity_UN where Quantity_UN <> 0 
update inMonthlySales set Quantity_DosingUnits = Quantity_UN * CUF/SUF where SUF <> 0 
go


update inMonthlySales set 
AUDI_COD = City_Code + '_',
PACK_COD = Pack_Code, 
PACK_DES = Pack_Description,
PROD_COD = Product_Code,
MANU_ID  = Manufacturer_ID,
MANU_COD = Manufacturer_Code,
ATC4_COD = Therapeutic_Code,
ATC3_COD = left(Therapeutic_Code,4),
ATC2_COD = left(Therapeutic_Code,3),
ATC1_COD = left(Therapeutic_Code,1),
CORP_ID  = Corporation_ID,
CORP_COD = Corporation_ID,
MNFL_ID  = ManufacturerType_ID,
MNFL_COD = ManufacturerType_Code
go


-- Add history data of Nanchang city, from 201212 rawdata
update inMonthlySales_NanChang set MonSeq = b.MonSeq 
from inMonthlySales_NanChang a 
left join tblMonthList b on a.[Year] = b.[Year] and a.[Month] = b.[Month]
--go

--update inMonthlySales_NanChang set city_id=g.city_id,pack_id=b.pack_id,Therapeutic_ID=b.Therapeutic_ID,Manufacturer_ID=c.Manufacturer_ID,Manufacturer_Code=d.Manufacturer_Code,Corporation_ID=d.Corporation_ID,
--ManufacturerType_ID=d.ManufacturerType_ID,ManufacturerType_Code=e.ManufacturerType_Code,Therapeutic_Code=f.Therapeutic_Code
--from inMonthlySales_NanChang a
--inner join Dim_City g
--on a.city_name=g.city_name
--inner join Dim_Pack b
--on a.pack_code=b.pack_code
--inner join Dim_Product c
--on b.Product_ID=c.Product_ID and a.Product_ID=c.Product_ID
--inner join Dim_Manufacturer d
--on d.Manufacturer_ID=c.Manufacturer_ID
--inner join Dim_ManufacturerType e
--on d.ManufacturerType_ID=e.ManufacturerType_ID
--inner join Dim_Therapeutic_Class f
--on b.Therapeutic_ID=f.Therapeutic_ID



--update inMonthlySales_NanChang set 
----AUDI_COD = City_Code + '_',
--PACK_COD = Pack_Code, 
--PACK_DES = Pack_Description,
--PROD_COD = Product_Code,
--MANU_ID  = Manufacturer_ID,
--MANU_COD = Manufacturer_Code,
--ATC4_COD = Therapeutic_Code,
--ATC3_COD = left(Therapeutic_Code,4),
--ATC2_COD = left(Therapeutic_Code,3),
--ATC1_COD = left(Therapeutic_Code,1),
--CORP_ID  = Corporation_ID,
--CORP_COD = Corporation_ID,
--MNFL_ID  = ManufacturerType_ID,
--MNFL_COD = ManufacturerType_Code
--go

--insert into inMonthlySales (
--       [Year]
--      ,[Month]
--      ,[MonSeq]
--      ,[Quantity_DT]
--      ,[Quantity_ST]
--      ,[Quantity_UN]
--      ,[Quantity_DosingUnits]
--      ,[AMOUNT_IC]
--      ,[AMOUNT_US]
--      ,[City_ID]
--      ,[Pack_ID]
--      ,[City_Code]
--      ,[City_Name]
--      ,[City_Name_CH]
--      ,[Tier]
--      ,[Pack_Code]
--      ,[Pack_Description]
--      ,[Product_ID]
--      ,[Therapeutic_ID]
--      ,[Product_Code]
--      ,[Product_Name]
--      ,[Manufacturer_ID]
--      ,[Manufacturer_Code]
--      ,[Corporation_ID]
--      ,[ManufacturerType_ID]
--      ,[ManufacturerType_Code]
--      ,[Therapeutic_Code]
--      ,[CUF]
--      ,[SUF]
--      ,[AUDI_COD]
--      ,[PACK_COD]
--      ,[PACK_DES]
--      ,[PROD_COD]
--      ,[ATC1_COD]
--      ,[ATC2_COD]
--      ,[ATC3_COD]
--      ,[ATC4_COD]
--      ,[MANU_ID]
--      ,[MANU_COD]
--      ,[MNFL_ID]
--      ,[MNFL_COD]
--      ,[CORP_ID]
--      ,[CORP_COD]
--      ,[Quantity_PatientNumber]
--)
--select * from [inMonthlySales_NanChang]
--GO



--PatientNumber
update inMonthlySales set Quantity_PatientNumber = t1.Quantity_DosingUnits*t2.Pack_quantity/t2.AvgPatientMG
from inMonthlySales t1
inner join  D_AdjustedPatientNumber t2
on t1.Pack_Cod=t2.Pack_Cod
GO

update inMonthlySales set Quantity_PatientNumber = 0 
where Quantity_PatientNumber is null
GO



create index [idx_MonSeq] on inMonthlySales (MonSeq)
go





print (N'
-----------------------------------------------------------
                   tempFactSales
-----------------------------------------------------------
')
exec dbo.sp_Log_Event 'SeedData','CIA','0_4_Seeddata.sql','tempFactSales',null,null

if object_id(N'tempFactSales', N'U') is not null 
  Drop table tempFactSales
go

declare @i int
declare @sql1 varchar(8000), @sql2 varchar(8000), @sql3 varchar(8000) ,@sql4 varchar(8000) 
set @sql1 = ''
set @sql2 = ''
set @sql3 = ''
set @sql4 = ''
set @i = 1
while (@i<= dbo.fnGetParameter('MaxMonth'))
begin
   set @sql1 = @sql1 + '
   sum(case when MonSeq = ' + cast(@i as varchar) + ' then Quantity_DosingUnits else 0 end) as MTH' + right('0' + cast(@i - 1 as varchar),2) + 'UN,'
      
   set @sql4 = @sql4 + '
   sum(case when MonSeq = ' + cast(@i as varchar) + ' then Quantity_PatientNumber else 0 end) as MTH' + right('0' + cast(@i - 1 as varchar),2) + 'PN,'
   
   set @sql2 = @sql2 + '
   sum(case when MonSeq = ' + cast(@i as varchar) + ' then Amount_IC else 0 end) as MTH' + right('0' + cast(@i - 1 as varchar),2) + 'LC,'
   
   set @sql3 = @sql3 + '
   sum(case when MonSeq = ' + cast(@i as varchar) + ' then Amount_US else 0 end) as MTH' + right('0' + cast(@i - 1 as varchar),2) + 'US,'
   
   set @i=@i+1
end
set @sql3 = left(@sql3, len(@sql3) - 1)
--print @sql1
--print @sql2
--print @sql3


exec('select CITY_ID,AUDI_COD,PACK_ID,PACK_COD,PACK_DES,ATC1_COD,ATC2_COD,ATC3_COD,ATC4_COD,
	Product_ID,PROD_COD, MANU_ID,MANU_COD,MNFL_ID,MNFL_COD,CORP_ID,CORP_COD,
	' + @sql1 + @sql4+@sql2 + @sql3 + '
	into tempFactSales from inMonthlySales 
	group by CITY_ID,AUDI_COD,PACK_ID,PACK_COD,PACK_DES, ATC1_COD,ATC2_COD,ATC3_COD,ATC4_COD,
	Product_ID,PROD_COD, MANU_ID,MANU_COD,MNFL_ID,MNFL_COD,CORP_ID,CORP_COD')
go

exec dbo.sp_Log_Event 'SeedData','CIA','0_4_Seeddata.sql','MTHCHPA_PKAU & MTHCITY_PKAU',null,null


print (N'
-----------------------------------------------------------
                MTHCHPA_PKAU & MTHCITY_PKAU
-----------------------------------------------------------
')
if object_id(N'MTHCHPA_PKAU', N'U') is not null 
  Drop table MTHCHPA_PKAU
GO
if object_id(N'MTHCITY_PKAU', N'U') is not null 
  Drop table MTHCITY_PKAU
GO


select * into MTHCHPA_PKAU from tempFactSales where AUDI_COD = 'CHT_'
GO

select * into MTHCITY_PKAU from 
(
  select * from tempFactSales where AUDI_COD <> 'CHT_'
)a
GO

--MTHCHPA_PKAU
declare @sql varchar(8000), @sql1 varchar(8000), @sql2 varchar(8000), @sql3 varchar(8000),@sql4 varchar(8000) 
set @sql = 'Alter table MTHCHPA_PKAU add '  
set @sql1 = dbo.fnAddColumns('MAT', 'US', 48) + ',' + dbo.fnAddColumns('MAT', 'LC', 48) + ',' + dbo.fnAddColumns('MAT', 'UN', 48) + ',' + dbo.fnAddColumns('MAT', 'PN', 48) + ','
set @sql2 = dbo.fnAddColumns('R3M', 'US', 48) + ',' + dbo.fnAddColumns('R3M', 'LC', 48) + ',' + dbo.fnAddColumns('R3M', 'UN', 48) + ',' + dbo.fnAddColumns('R3M', 'PN', 48) + ','
set @sql3 = dbo.fnAddColumns('QTR', 'US', 19) + ',' + dbo.fnAddColumns('QTR', 'LC', 19) + ',' + dbo.fnAddColumns('QTR', 'UN', 19) + ',' + dbo.fnAddColumns('QTR', 'PN', 19) + ','
set @sql4 = dbo.fnAddColumns('YTD', 'US', 48) + ',' + dbo.fnAddColumns('YTD', 'LC', 48) + ',' + dbo.fnAddColumns('YTD', 'UN', 48) + ',' + dbo.fnAddColumns('YTD', 'PN', 48) + ''
exec (@sql + @sql1 + @sql2 + @sql3 + @sql4)
go

declare @sql varchar(8000),@sql1 varchar(8000),@sql2 varchar(8000),@sql3 varchar(8000),@sql4 varchar(8000) 
set @sql = 'Update MTHCHPA_PKAU set ' 
set @sql1 = dbo.fnGetformulaMAT('US', 48)+ ','
set @sql2 = dbo.fnGetformulaR3M('US', 48)+ ','
set @sql3 = dbo.fnGetformulaQtr('US', 19)+ ','
set @sql4 = dbo.fnGetformulaYTD('US', 48)+ ''
exec (@sql + @sql1 + @sql2 + @sql3 + @sql4)
go

declare @sql varchar(8000),@sql1 varchar(8000),@sql2 varchar(8000),@sql3 varchar(8000),@sql4 varchar(8000) 
set @sql = 'Update MTHCHPA_PKAU set ' 
set @sql1 = dbo.fnGetformulaMAT('LC', 48)+ ','
set @sql2 = dbo.fnGetformulaR3M('LC', 48)+ ','
set @sql3 = dbo.fnGetformulaQtr('LC', 19)+ ','
set @sql4 = dbo.fnGetformulaYTD('LC', 48)+ ''
exec (@sql + @sql1 + @sql2 + @sql3 + @sql4)
go

declare @sql varchar(8000),@sql1 varchar(8000),@sql2 varchar(8000),@sql3 varchar(8000),@sql4 varchar(8000) 
set @sql = 'Update MTHCHPA_PKAU set ' 
set @sql1 = dbo.fnGetformulaMAT('UN', 48)+ ','
set @sql2 = dbo.fnGetformulaR3M('UN', 48)+ ','
set @sql3 = dbo.fnGetformulaQtr('UN', 19)+ ','
set @sql4 = dbo.fnGetformulaYTD('UN', 48)+ ''
exec (@sql + @sql1 + @sql2 + @sql3 + @sql4)
go

declare @sql varchar(8000),@sql1 varchar(8000),@sql2 varchar(8000),@sql3 varchar(8000),@sql4 varchar(8000) 
set @sql = 'Update MTHCHPA_PKAU set ' 
set @sql1 = dbo.fnGetformulaMAT('PN', 48)+ ','
set @sql2 = dbo.fnGetformulaR3M('PN', 48)+ ','
set @sql3 = dbo.fnGetformulaQtr('PN', 19)+ ','
set @sql4 = dbo.fnGetformulaYTD('PN', 48)+ ''
exec (@sql + @sql1 + @sql2 + @sql3 + @sql4)
go


--MTHCITY_PKAU
declare @sql varchar(8000), @sql1 varchar(8000), @sql2 varchar(8000), @sql3 varchar(8000),@sql4 varchar(8000) 
set @sql = 'Alter table MTHCITY_PKAU add '  
set @sql1 = dbo.fnAddColumns('MAT', 'US', 48) + ',' + dbo.fnAddColumns('MAT', 'LC', 48) + ',' + dbo.fnAddColumns('MAT', 'UN', 48) + ','  + dbo.fnAddColumns('MAT', 'PN', 48) + ',' 
set @sql2 = dbo.fnAddColumns('R3M', 'US', 48) + ',' + dbo.fnAddColumns('R3M', 'LC', 48) + ',' + dbo.fnAddColumns('R3M', 'UN', 48) + ','  + dbo.fnAddColumns('R3M', 'PN', 48) + ',' 
set @sql3 = dbo.fnAddColumns('QTR', 'US', 19) + ',' + dbo.fnAddColumns('QTR', 'LC', 19) + ',' + dbo.fnAddColumns('QTR', 'UN', 19) + ','  + dbo.fnAddColumns('QTR', 'PN', 19) + ',' 
set @sql4 = dbo.fnAddColumns('YTD', 'US', 48) + ',' + dbo.fnAddColumns('YTD', 'LC', 48) + ',' + dbo.fnAddColumns('YTD', 'UN', 48) + ','  + dbo.fnAddColumns('YTD', 'PN', 48) + ''  
exec (@sql + @sql1 + @sql2 + @sql3 + @sql4)
go


declare @sql varchar(8000),@sql1 varchar(8000),@sql2 varchar(8000),@sql3 varchar(8000),@sql4 varchar(8000) 
set @sql = 'Update MTHCITY_PKAU set ' 
set @sql1 = dbo.fnGetformulaMAT('US', 48)+ ','
set @sql2 = dbo.fnGetformulaR3M('US', 48)+ ','
set @sql3 = dbo.fnGetformulaQtr('US', 19)+ ','
set @sql4 = dbo.fnGetformulaYTD('US', 48)+ ''
exec (@sql + @sql1 + @sql2 + @sql3 + @sql4)
go

declare @sql varchar(8000),@sql1 varchar(8000),@sql2 varchar(8000),@sql3 varchar(8000),@sql4 varchar(8000) 
set @sql = 'Update MTHCITY_PKAU set ' 
set @sql1 = dbo.fnGetformulaMAT('LC', 48)+ ','
set @sql2 = dbo.fnGetformulaR3M('LC', 48)+ ','
set @sql3 = dbo.fnGetformulaQtr('LC', 19)+ ','
set @sql4 = dbo.fnGetformulaYTD('LC', 48)+ ''
exec (@sql + @sql1 + @sql2 + @sql3 + @sql4)
go

declare @sql varchar(8000),@sql1 varchar(8000),@sql2 varchar(8000),@sql3 varchar(8000),@sql4 varchar(8000) 
set @sql = 'Update MTHCITY_PKAU set ' 
set @sql1 = dbo.fnGetformulaMAT('UN', 48)+ ','
set @sql2 = dbo.fnGetformulaR3M('UN', 48)+ ','
set @sql3 = dbo.fnGetformulaQtr('UN', 19)+ ','
set @sql4 = dbo.fnGetformulaYTD('UN', 48)+ ''
exec (@sql + @sql1 + @sql2 + @sql3 + @sql4)
go

declare @sql varchar(8000),@sql1 varchar(8000),@sql2 varchar(8000),@sql3 varchar(8000),@sql4 varchar(8000) 
set @sql = 'Update MTHCITY_PKAU set ' 
set @sql1 = dbo.fnGetformulaMAT('PN', 48)+ ','
set @sql2 = dbo.fnGetformulaR3M('PN', 48)+ ','
set @sql3 = dbo.fnGetformulaQtr('PN', 19)+ ','
set @sql4 = dbo.fnGetformulaYTD('PN', 48)+ ''
print (@sql + @sql1)
exec (@sql + @sql1 + @sql2 + @sql3 + @sql4)
go


create index idxPACK_cod on MTHCHPA_PKAU(PACK_ID,PACK_COD,PACK_DES)
go
create index idxPACK_cod on MTHCITY_PKAU(PACK_ID,PACK_COD,PACK_DES)
go
