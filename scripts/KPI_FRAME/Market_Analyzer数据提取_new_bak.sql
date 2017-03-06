


USE [BMSChinaCIA_IMS]
GO


if object_id(N'tblMktDef_Inline_For_CCB',N'U') is not null
  drop table tblMktDef_Inline_For_CCB
go
--CCB Market
select cast('CCB' as varchar(50)) as Mkt,cast('CCB Market' as varchar(50)) as MktName,* 
into tblMktDef_Inline_For_CCB
from tblMktDef_ATCDriver
where ATC2_cod ='C08' 

GO

if object_id(N'tblMktDef_MRBIChina_For_CCB',N'U') is not null
	drop table tblMktDef_MRBIChina_For_CCB
select * into tblMktDef_MRBIChina_For_CCB from tblMktDef_MRBIChina where 0=1

insert into tblMktDef_MRBIChina_For_CCB
SELECT distinct 
  'CCB' Mkt,'CCB Market' MktName
  ,'000' as Prod,'CCB Market' as ProductName
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
  ,GetDate() as Date, '201402 add new products & packages' as Comment
FROM tblMktDef_Inline_For_CCB A WHERE A.MKT = 'CCB'
GO

insert into tblMktDef_MRBIChina_For_CCB
SELECT distinct 
  'CCB' Mkt,'CCB Market' MktName
  ,'000' as Prod,'CCB Market' as ProductName
  ,'N' as Molecule
  ,'Y' as Class
  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
  ,pack_cod, Pack_des
  ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
  ,'' Mole_cod
  ,'' Mole_Name
  ,Corp_cod
  ,Manu_Cod
  ,Gene_Cod
  ,'Y' as Active
  ,GetDate() as Date, '201402 add new products & packages' as Comment
FROM tblMktDef_Inline_For_CCB A WHERE A.MKT = 'CCB'
GO

-- Prod

/*
06253	FRAXIPARINE
08621	CLEXANE
40785	XARELTO
53099	ELIQUIS
*/
insert into tblMktDef_MRBIChina_For_CCB
SELECT distinct 
   'CCB' as Mkt
  ,'CCB Market' as MktName
  ,case when a.Prod_Des='Coniel' and Manu_cod='KHK' then '100'   
		when a.Prod_Des='YUAN ZHI' and Manu_cod='S3D' then '200' 
		when a.Prod_Des='LACIPIL' and Manu_cod='GSK' then '300'
		when a.Prod_Des='ZANIDIP' and Manu_cod='REC' then '400'
		when a.Prod_Des='NORVASC' and Manu_cod='PZD' then '500'
		when a.Prod_Des='ADALAT' and Manu_cod='BY6' then '600'
		when a.Prod_Des='PLENDIL' and Manu_cod='AZX' then '700'
		else '940'
        end   as [Prod]         
  ,
  case when a.Prod_Des='Coniel' and Manu_cod='KHK' then prod_des
		when a.Prod_Des='YUAN ZHI' and Manu_cod='S3D' then prod_des
		when a.Prod_Des='LACIPIL' and Manu_cod='GSK' then prod_des
		when a.Prod_Des='ZANIDIP' and Manu_cod='REC' then prod_des
		when a.Prod_Des='NORVASC' and Manu_cod='PZD' then prod_des
		when a.Prod_Des='ADALAT' and Manu_cod='BY6' then prod_des
		when a.Prod_Des='PLENDIL' and Manu_cod='AZX' then prod_des
		else 'CCB Others'
        end   as ProductName
  ,'N'        as Molecule
  ,'N'        as Class 
  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
  ,pack_cod, Pack_des
  ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
  ,'' Mole_cod,'' Mole_Name
  ,Corp_cod
  ,Manu_Cod
  ,Gene_Cod
  ,'Y'       as Active
  ,GetDate() as Date, '201402 add new products & packages'  -- select * 
FROM tblMktDef_Inline_For_CCB A 
WHERE A.MKT = 'CCB' 
GO


if exists (select * from dbo.sysobjects where id = object_id(N'TempcityDashboard_For_CCB') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table TempcityDashboard_For_CCB
go

CREATE TABLE [dbo].[TempcityDashboard_For_CCB](
    [Molecule] [varchar](2)  NOT NULL,
    [Class] [varchar](2)  NOT NULL,
    [mkt] [varchar](50)  NULL,
	[mktname] [varchar](50)  NULL,
	[Market] [varchar](50)  NULL,
	[prod] [varchar](200)  NULL,
	[Productname] [varchar](200)  NULL,
	[Moneytype] [varchar](50)  NOT NULL,
	[Audi_cod] [varchar](200)  NULL,
	[Audi_des] [varchar](200)  NULL,
	[Lev] [varchar](200)  NULL,
	[Tier] [varchar](10)  NULL,
	[R3M00] float null default 0,
	[R3M01] float null default 0,
	[R3M02] float null default 0,
	[R3M03] float null default 0,
	[R3M04] float null default 0,
	[R3M05] float null default 0,
	[R3M06] float null default 0,
	[R3M07] float null default 0,
	[R3M08] float null default 0,
	[R3M09] float null default 0,
	[R3M10] float null default 0,
	[R3M11] float null default 0,
	[R3M12] float null default 0,
	[R3M13] float null default 0,
	[R3M14] float null default 0,
	[R3M15] float null default 0,
	[R3M16] float null default 0,
	[R3M17] float null default 0,
	[R3M18] float null default 0,
	[R3M19] float null default 0,
	[R3M20] float null default 0,
	[R3M21] float null default 0,
	[R3M22] float null default 0,
	[R3M23] float null default 0,
	[R3M24] float null default 0,
	[R3M25] float null default 0,
	[R3M26] float null default 0,
	[R3M27] float null default 0,
	[R3M28] float null default 0,
	[R3M29] float null default 0,
	[R3M30] float null default 0,
	[R3M31] float null default 0,
	[R3M32] float null default 0,
	[R3M33] float null default 0,
	[R3M34] float null default 0,
	[R3M35] float null default 0,
	[R3M36] float null default 0,
	[R3M37] float null default 0,
	[R3M38] float null default 0,
	[R3M39] float null default 0,
	[R3M40] float null default 0,
	[R3M41] float null default 0,
	[R3M42] float null default 0,
	[R3M43] float null default 0,
	[R3M44] float null default 0,
	[R3M45] float null default 0,
--	[R3M46] float null default 0,
--	[R3M47] float null default 0,
--	[R3M48] float null default 0,
--	[R3M49] float null default 0,
--	[R3M50] float null default 0,
--	[R3M51] float null default 0,
--	[R3M52] float null default 0,
--	[R3M53] float null default 0,
--	[R3M54] float null default 0,
--	[R3M55] float null default 0,
--	[R3M56] float null default 0,
--	[R3M57] float null default 0,
	[MTH00] [float] NULL default 0,
	[MTH01] [float] NULL default 0,
	[MTH02] [float] NULL default 0,
	[MTH03] [float] NULL default 0,
	[MTH04] [float] NULL default 0,
	[MTH05] [float] NULL default 0,
	[MTH06] [float] NULL default 0,
	[MTH07] [float] NULL default 0,
	[MTH08] [float] NULL default 0,
	[MTH09] [float] NULL default 0,
	[MTH10] [float] NULL default 0,
	[MTH11] [float] NULL default 0,
	[MTH12] [float] NULL default 0,
	[MTH13] [float] NULL default 0,
	[MTH14] [float] NULL default 0,
	[MTH15] [float] NULL default 0,
	[MTH16] [float] NULL default 0,
	[MTH17] [float] NULL default 0,
	[MTH18] [float] NULL default 0,
	[MTH19] [float] NULL default 0,
	[MTH20] [float] NULL default 0,
	[MTH21] [float] NULL default 0,
	[MTH22] [float] NULL default 0,
	[MTH23] [float] NULL default 0,
	[MTH24] [float] NULL default 0,
	[MTH25] [float] NULL default 0,
	[MTH26] [float] NULL default 0,
	[MTH27] [float] NULL default 0,
	[MTH28] [float] NULL default 0,
	[MTH29] [float] NULL default 0,
	[MTH30] [float] NULL default 0,
	[MTH31] [float] NULL default 0,
	[MTH32] [float] NULL default 0,
	[MTH33] [float] NULL default 0,
	[MTH34] [float] NULL default 0,
	[MTH35] [float] NULL default 0,
	[MTH36] [float] NULL default 0,
	[MTH37] [float] NULL default 0,
	[MTH38] [float] NULL default 0,
	[MTH39] [float] NULL default 0,
	[MTH40] [float] NULL default 0,
	[MTH41] [float] NULL default 0,
	[MTH42] [float] NULL default 0,
	[MTH43] [float] NULL default 0,
	[MTH44] [float] NULL default 0,
	[MTH45] [float] NULL default 0,
	[MTH46] [float] NULL default 0,
	[MTH47] [float] NULL default 0,
	[MTH48] [float] NULL default 0,
--	[MTH49] [float] NULL default 0,
--	[MTH50] [float] NULL default 0,
--	[MTH51] [float] NULL default 0,
--	[MTH52] [float] NULL default 0,
--	[MTH53] [float] NULL default 0,
--	[MTH54] [float] NULL default 0,
--	[MTH55] [float] NULL default 0,
--	[MTH56] [float] NULL default 0,
--	[MTH57] [float] NULL default 0,
--	[MTH58] [float] NULL default 0,
--	[MTH59] [float] NULL default 0,
	[MAT00] [float] NULL default 0,
	[MAT01] [float] NULL default 0,
	[MAT02] [float] NULL default 0,
	[MAT03] [float] NULL default 0,
	[MAT04] [float] NULL default 0,
	[MAT05] [float] NULL default 0,
	[MAT06] [float] NULL default 0,
	[MAT07] [float] NULL default 0,
	[MAT08] [float] NULL default 0,
	[MAT09] [float] NULL default 0,
	[MAT10] [float] NULL default 0,
	[MAT11] [float] NULL default 0,
	[MAT12] [float] NULL default 0,
	[MAT13] [float] NULL default 0,
	[MAT14] [float] NULL default 0,
	[MAT15] [float] NULL default 0,
	[MAT16] [float] NULL default 0,
	[MAT17] [float] NULL default 0,
	[MAT18] [float] NULL default 0,
	[MAT19] [float] NULL default 0,
	[MAT20] [float] NULL default 0,
	[MAT21] [float] NULL default 0,
	[MAT22] [float] NULL default 0,
	[MAT23] [float] NULL default 0,
	[MAT24] [float] NULL default 0,
	[MAT25] [float] NULL default 0,
	[MAT26] [float] NULL default 0,
	[MAT27] [float] NULL default 0,
	[MAT28] [float] NULL default 0,
	[MAT29] [float] NULL default 0,
	[MAT30] [float] NULL default 0,
	[MAT31] [float] NULL default 0,
	[MAT32] [float] NULL default 0,
	[MAT33] [float] NULL default 0,
	[MAT34] [float] NULL default 0,
	[MAT35] [float] NULL default 0,
	[MAT36] [float] NULL default 0,
	[MAT37] [float] NULL default 0,
	[MAT38] [float] NULL default 0,
	[MAT39] [float] NULL default 0,
	[MAT40] [float] NULL default 0,
	[MAT41] [float] NULL default 0,
	[MAT42] [float] NULL default 0,
	[MAT43] [float] NULL default 0,
	[MAT44] [float] NULL default 0,
	[MAT45] [float] NULL default 0,
	[MAT46] [float] NULL default 0,
	[MAT47] [float] NULL default 0,
	[MAT48] [float] NULL default 0,
	[YTD00] [float] NULL default 0,
	[YTD01] [float] NULL default 0,
	[YTD02] [float] NULL default 0,
	[YTD03] [float] NULL default 0,
	[YTD04] [float] NULL default 0,
	[YTD05] [float] NULL default 0,
	[YTD06] [float] NULL default 0,
	[YTD07] [float] NULL default 0,
	[YTD08] [float] NULL default 0,
	[YTD09] [float] NULL default 0,
	[YTD10] [float] NULL default 0,
	[YTD11] [float] NULL default 0,
	[YTD12] [float] NULL default 0,
	[YTD13] [float] NULL default 0,
	[YTD14] [float] NULL default 0,
	[YTD15] [float] NULL default 0,
	[YTD16] [float] NULL default 0,
	[YTD17] [float] NULL default 0,
	[YTD18] [float] NULL default 0,
	[YTD19] [float] NULL default 0,
	[YTD20] [float] NULL default 0,
	[YTD21] [float] NULL default 0,
	[YTD22] [float] NULL default 0,
	[YTD23] [float] NULL default 0,
	[YTD24] [float] NULL default 0,
	[YTD25] [float] NULL default 0,
	[YTD26] [float] NULL default 0,
	[YTD27] [float] NULL default 0,
	[YTD28] [float] NULL default 0,
	[YTD29] [float] NULL default 0,
	[YTD30] [float] NULL default 0,
	[YTD31] [float] NULL default 0,
	[YTD32] [float] NULL default 0,
	[YTD33] [float] NULL default 0,
	[YTD34] [float] NULL default 0,
	[YTD35] [float] NULL default 0,
	[YTD36] [float] NULL default 0,
	[YTD37] [float] NULL default 0,
	[YTD38] [float] NULL default 0,
	[YTD39] [float] NULL default 0,
	[YTD40] [float] NULL default 0,
	[YTD41] [float] NULL default 0,
	[YTD42] [float] NULL default 0,
	[YTD43] [float] NULL default 0,
	[YTD44] [float] NULL default 0,
	[YTD45] [float] NULL default 0,
	[YTD46] [float] NULL default 0,
	[YTD47] [float] NULL default 0,
	[YTD48] [float] NULL default 0,
--	[YTD49] [float] NULL default 0,
--	[YTD50] [float] NULL default 0,
--	[YTD51] [float] NULL default 0,
--	[YTD52] [float] NULL default 0,
--	[YTD53] [float] NULL default 0,
--	[YTD54] [float] NULL default 0,
--	[YTD55] [float] NULL default 0,
--	[YTD56] [float] NULL default 0,
--	[YTD57] [float] NULL default 0,
--	[YTD58] [float] NULL default 0,
--	[YTD59] [float] NULL default 0,
--	[YTD60] [float] NULL default 0,
    [Qtr00] [float] NULL default 0,
	[Qtr01] [float] NULL default 0,
	[Qtr02] [float] NULL default 0,
	[Qtr03] [float] NULL default 0,
	[Qtr04] [float] NULL default 0,
	[Qtr05] [float] NULL default 0,
	[Qtr06] [float] NULL default 0,
	[Qtr07] [float] NULL default 0,
	[Qtr08] [float] NULL default 0,
	[Qtr09] [float] NULL default 0,
	[Qtr10] [float] NULL default 0,
	[Qtr11] [float] NULL default 0,
	[Qtr12] [float] NULL default 0,
	[Qtr13] [float] NULL default 0,
	[Qtr14] [float] NULL default 0,
	[Qtr15] [float] NULL default 0,
	[Qtr16] [float] NULL default 0,
	[Qtr17] [float] NULL default 0,
	[Qtr18] [float] NULL default 0,
	[Qtr19] [float] NULL default 0
) ON [PRIMARY]

go
declare @i int,@sql varchar(8000),@sql1 varchar(8000),@sql3 varchar(8000),@sqlMAT varchar(2000),@sqlYTD varchar(2000),@sqlQtr varchar(2000)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(8000)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		set @i=0
		set @sql1=''
        set @sql3=''
--		while (@i<=57)
        while (@i<=45)
		begin
		set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end

        set @i=0    
--		while (@i<=59)
        while (@i<=48)
		begin
		set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
		set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
--		while (@i<=60)
while (@i<=48)
		begin
		set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
        set @sqlQtr=''
		while (@i<=19)
		begin
		set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
        set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		exec('insert into TempcityDashboard_For_CCB 
        select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,'+'''' +@MoneyType+''''+' as Moneytype, A.audi_cod,'''',''City'',null,'+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
		from mthcity_pkau A inner join tblMktDef_MRBIChina_For_CCB B
        on A.pack_cod=B.pack_cod where B.Active=''Y'' 
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname,A.audi_cod')
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
delete from TempcityDashboard_For_CCB where audi_cod='NCG_'

update TempcityDashboard_For_CCB
set AUDI_des=City_Name from TempcityDashboard_For_CCB A inner join dbo.Dim_City B
on A.AUDI_cod=B.City_Code+'_'
go

update TempcityDashboard_For_CCB
set Market=case  
when Market in ('HYP','ACE') then 'Monopril'
when Market in ('NIAD','DIA') then 'Glucophage'
when Market in ('ONC','ONCFCS') then 'Taxol' 
when Market in ('HBV','ARV') then 'Baraclude'
when Market in ('DPP4') then 'Onglyza' 
when Market in ('CML') then 'Sprycel' 
when Market in ('Platinum') then 'Paraplatin'
when Market in ('CCB') then 'Coniel'---Add for CCB Market
else Market end
go

insert into TempcityDashboard_For_CCB (Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
Audi_cod,audi_des,lev)
select  Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
Audi_cod,audi_des,lev from (
select A.*,Audi_cod,audi_des,lev from 
(select distinct Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype from TempcityDashboard_For_CCB) A
inner join
(select distinct  Molecule,Class,mkt,mktname,Market,Moneytype,Audi_cod,audi_des,lev from TempcityDashboard_For_CCB) B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
and a.Moneytype=b.Moneytype) A where not exists(select * from TempcityDashboard_For_CCB B
where a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and a.Prod=B.Prod)
go
update TempcityDashboard_For_CCB
set Tier=B.Tier from TempcityDashboard_For_CCB A inner join Dim_City B
on A.Audi_cod=B.CIty_Code+'_'
go


if exists (select * from dbo.sysobjects where id = object_id(N'TempCHPAPreReports_For_CCB') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table TempCHPAPreReports_For_CCB

go

CREATE TABLE [dbo].TempCHPAPreReports_For_CCB(
    [Molecule] [varchar](2)  NOT NULL,
    [Class] [varchar](2)  NOT NULL,
    [mkt] [varchar](50)  NULL,
	[mktname] [varchar](50)  NULL,
	[Market] [varchar](50)  NULL,
	[prod] [varchar](200)  NULL,
	[Productname] [varchar](200)  NULL,
	[MNFL_COD] [varchar](10)  NULL,
	[Moneytype] [varchar](2)  NOT NULL,
	[R3M00] [float] NULL default 0,
	[R3M01] [float] NULL default 0,
	[R3M02] [float] NULL default 0,
	[R3M03] [float] NULL default 0,
	[R3M04] [float] NULL default 0,
	[R3M05] [float] NULL default 0,
	[R3M06] [float] NULL default 0,
	[R3M07] [float] NULL default 0,
	[R3M08] [float] NULL default 0,
	[R3M09] [float] NULL default 0,
	[R3M10] [float] NULL default 0,
	[R3M11] [float] NULL default 0,
	[R3M12] [float] NULL default 0,
	[R3M13] [float] NULL default 0,
	[R3M14] [float] NULL default 0,
	[R3M15] [float] NULL default 0,
	[R3M16] [float] NULL default 0,
	[R3M17] [float] NULL default 0,
	[R3M18] [float] NULL default 0,
    [R3M19] float null default 0,
	[R3M20] float null default 0,
	[R3M21] float null default 0,
	[R3M22] float null default 0,
	[R3M23] float null default 0,
	[R3M24] float null default 0,
	[R3M25] float null default 0,
	[R3M26] float null default 0,
	[R3M27] float null default 0,
	[R3M28] float null default 0,
	[R3M29] float null default 0,
	[R3M30] float null default 0,
	[R3M31] float null default 0,
	[R3M32] float null default 0,
	[R3M33] float null default 0,
	[R3M34] float null default 0,
	[R3M35] float null default 0,
	[R3M36] float null default 0,
	[R3M37] float null default 0,
	[R3M38] float null default 0,
	[R3M39] float null default 0,
	[R3M40] float null default 0,
	[R3M41] float null default 0,
	[R3M42] float null default 0,
	[R3M43] float null default 0,
	[R3M44] float null default 0,
	[R3M45] float null default 0,
	[R3M46] float null default 0,
	[R3M47] float null default 0,
	[R3M48] float null default 0,
	[MTH00] [float] NULL default 0,
	[MTH01] [float] NULL default 0,
	[MTH02] [float] NULL default 0,
	[MTH03] [float] NULL default 0,
	[MTH04] [float] NULL default 0,
	[MTH05] [float] NULL default 0,
	[MTH06] [float] NULL default 0,
	[MTH07] [float] NULL default 0,
	[MTH08] [float] NULL default 0,
	[MTH09] [float] NULL default 0,
	[MTH10] [float] NULL default 0,
	[MTH11] [float] NULL default 0,
	[MTH12] [float] NULL default 0,
	[MTH13] [float] NULL default 0,
	[MTH14] [float] NULL default 0,
	[MTH15] [float] NULL default 0,
	[MTH16] [float] NULL default 0,
	[MTH17] [float] NULL default 0,
	[MTH18] [float] NULL default 0,
	[MTH19] [float] NULL default 0,
	[MTH20] [float] NULL default 0,
	[MTH21] [float] NULL default 0,
	[MTH22] [float] NULL default 0,
	[MTH23] [float] NULL default 0,
	[MTH24] [float] NULL default 0,
	[MTH25] [float] NULL default 0,
	[MTH26] [float] NULL default 0,
	[MTH27] [float] NULL default 0,
	[MTH28] [float] NULL default 0,
	[MTH29] [float] NULL default 0,
	[MTH30] [float] NULL default 0,
	[MTH31] [float] NULL default 0,
	[MTH32] [float] NULL default 0,
	[MTH33] [float] NULL default 0,
	[MTH34] [float] NULL default 0,
	[MTH35] [float] NULL default 0,
	[MTH36] [float] NULL default 0,
	[MTH37] [float] NULL default 0,
	[MTH38] [float] NULL default 0,
	[MTH39] [float] NULL default 0,
	[MTH40] [float] NULL default 0,
	[MTH41] [float] NULL default 0,
	[MTH42] [float] NULL default 0,
	[MTH43] [float] NULL default 0,
	[MTH44] [float] NULL default 0,
	[MTH45] [float] NULL default 0,
	[MTH46] [float] NULL default 0,
	[MTH47] [float] NULL default 0,
	[MTH48] [float] NULL default 0,
	[MAT00] [float] NULL default 0,
	[MAT01] [float] NULL default 0,
	[MAT02] [float] NULL default 0,
	[MAT03] [float] NULL default 0,
	[MAT04] [float] NULL default 0,
	[MAT05] [float] NULL default 0,
	[MAT06] [float] NULL default 0,
	[MAT07] [float] NULL default 0,
	[MAT08] [float] NULL default 0,
	[MAT09] [float] NULL default 0,
	[MAT10] [float] NULL default 0,
	[MAT11] [float] NULL default 0,
	[MAT12] [float] NULL default 0,
	[MAT13] [float] NULL default 0,
	[MAT14] [float] NULL default 0,
	[MAT15] [float] NULL default 0,
	[MAT16] [float] NULL default 0,
	[MAT17] [float] NULL default 0,
	[MAT18] [float] NULL default 0,
	[MAT19] [float] NULL default 0,
	[MAT20] [float] NULL default 0,
	[MAT21] [float] NULL default 0,
	[MAT22] [float] NULL default 0,
	[MAT23] [float] NULL default 0,
	[MAT24] [float] NULL default 0,
	[MAT25] [float] NULL default 0,
	[MAT26] [float] NULL default 0,
	[MAT27] [float] NULL default 0,
	[MAT28] [float] NULL default 0,
	[MAT29] [float] NULL default 0,
	[MAT30] [float] NULL default 0,
	[MAT31] [float] NULL default 0,
	[MAT32] [float] NULL default 0,
	[MAT33] [float] NULL default 0,
	[MAT34] [float] NULL default 0,
	[MAT35] [float] NULL default 0,
	[MAT36] [float] NULL default 0,
	[MAT37] [float] NULL default 0,
	[MAT38] [float] NULL default 0,
	[MAT39] [float] NULL default 0,
	[MAT40] [float] NULL default 0,
	[MAT41] [float] NULL default 0,
	[MAT42] [float] NULL default 0,
	[MAT43] [float] NULL default 0,
	[MAT44] [float] NULL default 0,
	[MAT45] [float] NULL default 0,
	[MAT46] [float] NULL default 0,
	[MAT47] [float] NULL default 0,
	[MAT48] [float] NULL default 0,
	[YTD00] [float] NULL default 0,
	[YTD01] [float] NULL default 0,
	[YTD02] [float] NULL default 0,
	[YTD03] [float] NULL default 0,
	[YTD04] [float] NULL default 0,
	[YTD05] [float] NULL default 0,
	[YTD06] [float] NULL default 0,
	[YTD07] [float] NULL default 0,
	[YTD08] [float] NULL default 0,
	[YTD09] [float] NULL default 0,
	[YTD10] [float] NULL default 0,
	[YTD11] [float] NULL default 0,
	[YTD12] [float] NULL default 0,
	[YTD13] [float] NULL default 0,
	[YTD14] [float] NULL default 0,
	[YTD15] [float] NULL default 0,
	[YTD16] [float] NULL default 0,
	[YTD17] [float] NULL default 0,
	[YTD18] [float] NULL default 0,
	[YTD19] [float] NULL default 0,
	[YTD20] [float] NULL default 0,
	[YTD21] [float] NULL default 0,
	[YTD22] [float] NULL default 0,
	[YTD23] [float] NULL default 0,
	[YTD24] [float] NULL default 0,
	[YTD25] [float] NULL default 0,
	[YTD26] [float] NULL default 0,
	[YTD27] [float] NULL default 0,
	[YTD28] [float] NULL default 0,
	[YTD29] [float] NULL default 0,
	[YTD30] [float] NULL default 0,
	[YTD31] [float] NULL default 0,
	[YTD32] [float] NULL default 0,
	[YTD33] [float] NULL default 0,
	[YTD34] [float] NULL default 0,
	[YTD35] [float] NULL default 0,
	[YTD36] [float] NULL default 0,
	[YTD37] [float] NULL default 0,
	[YTD38] [float] NULL default 0,
	[YTD39] [float] NULL default 0,
	[YTD40] [float] NULL default 0,
	[YTD41] [float] NULL default 0,
	[YTD42] [float] NULL default 0,
	[YTD43] [float] NULL default 0,
	[YTD44] [float] NULL default 0,
	[YTD45] [float] NULL default 0,
	[YTD46] [float] NULL default 0,
	[YTD47] [float] NULL default 0,
	[YTD48] [float] NULL default 0,
--	[YTD49] [float] NULL default 0,
--	[YTD50] [float] NULL default 0,
--	[YTD51] [float] NULL default 0,
--	[YTD52] [float] NULL default 0,
--	[YTD53] [float] NULL default 0,
--	[YTD54] [float] NULL default 0,
--	[YTD55] [float] NULL default 0,
--	[YTD56] [float] NULL default 0,
--	[YTD57] [float] NULL default 0,
--	[YTD58] [float] NULL default 0,
--	[YTD59] [float] NULL default 0,
--	[YTD60] [float] NULL default 0,
  [Qtr00] [float] NULL default 0,
	[Qtr01] [float] NULL default 0,
	[Qtr02] [float] NULL default 0,
	[Qtr03] [float] NULL default 0,
	[Qtr04] [float] NULL default 0,
	[Qtr05] [float] NULL default 0,
	[Qtr06] [float] NULL default 0,
	[Qtr07] [float] NULL default 0,
	[Qtr08] [float] NULL default 0,
	[Qtr09] [float] NULL default 0,
	[Qtr10] [float] NULL default 0,
	[Qtr11] [float] NULL default 0,
	[Qtr12] [float] NULL default 0,
	[Qtr13] [float] NULL default 0,
	[Qtr14] [float] NULL default 0,
	[Qtr15] [float] NULL default 0,
	[Qtr16] [float] NULL default 0,
	[Qtr17] [float] NULL default 0,
	[Qtr18] [float] NULL default 0,
	[Qtr19] [float] NULL default 0
) ON [PRIMARY]
Alter table TempCHPAPreReports_For_CCB drop column [MNFL_COD]


declare @i int,@sql varchar(8000),@sql1 varchar(8000),@sql3 varchar(8000),@sqlMAT varchar(2000),@sqlYTD varchar(2000),@sqlQtr varchar(2000)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(8000)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		set @i=0
		set @sql1=''
        set @sql3=''
		while (@i<=48)
		begin
		set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
		set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
		set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
		while (@i<=48)--todo
		begin
		set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
		set @sqlQtr=''
		while (@i<=19)
		begin
		set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		set @SQL2='insert into TempCHPAPreReports_For_CCB 
		select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,
--         A.MNFL_COD,B.Gene_cod,
        '+'''' +@MoneyType+''''+' as Moneytype, '+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
		from mthCHPA_pkau A inner join tblMktDef_MRBIChina_For_CCB B
        on A.pack_cod=B.pack_cod where B.Active=''Y''
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname'
       print @SQL2
		exec( @SQL2)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
update TempCHPAPreReports_For_CCB
set Market=case Market when 'ONC' then 'Taxol' 
when 'HYP' then 'Monopril'
when 'NIAD' then 'Glucophage'
when 'ACE' then 'Monopril'
when 'DIA' then 'Glucophage'
when 'ONCFCS' then 'Taxol'
when 'HBV' then 'Baraclude'
when 'ARV' then 'Baraclude' when 'DPP4' then 'Onglyza' when 'CML' then 'Sprycel' 
when 'Platinum' then 'Paraplatin'
when 'CCB' then 'Coniel'
else Market end
go

delete 
from TempCHPAPreReports_For_CCB
where Market <> 'Paraplatin' and MoneyType = 'PN'
go

------------------------------------------------------
--	Eliquis Market CHPA Middle Table
------------------------------------------------------
--Market Definition
if OBJECT_ID(N'tblMktDef_Inline_For_Eliquis',N'U') is not null
	drop table tblMktDef_Inline_For_Eliquis
go
select * into tblMktDef_Inline_For_Eliquis from tblMktDef_Inline where 1=2

insert into tblMktDef_Inline_For_Eliquis
select cast('ELIQUIS' as varchar(50)) as Mkt,cast('Eliquis Market' as varchar(50)) as MktName,* 
from tblMktDef_ATCDriver
where prod_des in ('Fraxiparine','Clexane','Xarelto','Arixtra','Eliquis')
go

if OBJECT_ID(N'tblMktDef_MRBIChina_For_Eliquis',N'U') is not null
	drop table tblMktDef_MRBIChina_For_Eliquis
go
select * into tblMktDef_MRBIChina_For_Eliquis from tblMktDef_MRBIChina where 1=2

insert into tblMktDef_MRBIChina_For_Eliquis
SELECT distinct 
  'Eliquis' Mkt,'Eliquis Market' MktName
  ,'000' as Prod,'VTEP Market' as ProductName
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
  ,GetDate() as Date, '201404 add new products & packages' as Comment
FROM tblMktDef_Inline_For_Eliquis A WHERE A.MKT = 'Eliquis'

insert into tblMktDef_MRBIChina_For_Eliquis
SELECT distinct 
   'Eliquis' as Mkt
  ,'Eliquis Market' as MktName
  ,case when a.Prod_Des='ELIQUIS' then '100'   
        when a.Prod_Des='CLEXANE' then '200'     
        when a.Prod_Des='XARELTO' then '300'        
        when a.Prod_Des='FRAXIPARINE' then '400'      
        when a.Prod_Des='ARIXTRA' then '500' 
        end   as [Prod]         
  ,a.Prod_Des as ProductName
  ,'N'        as Molecule
  ,'N'        as Class 
  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
  ,pack_cod, Pack_des
  ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
  ,'' Mole_cod,'' Mole_Name
  ,Corp_cod
  ,Manu_Cod
  ,Gene_Cod
  ,'Y'       as Active
  ,GetDate() as Date, '201404 add new products & packages'  -- select * 
FROM tblMktDef_Inline_For_Eliquis A 
WHERE A.MKT = 'Eliquis' 

alter table tblMktDef_MRBIChina_For_Eliquis add  Rat float
go
update tblMktDef_MRBIChina_For_Eliquis
set Rat = case when Prod_Name='Fraxiparine' then 0.0785
					 when Prod_Name='Clexane' then 0.0847
					 when Prod_Name='Xarelto' then 0.5918
					 when Prod_Name='Arixtra' then 0.0514
					 when Prod_Name='Eliquis' then 1.0 end

go

--CHPA Middle table

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'TempCHPAPreReports_For_Eliquis') AND TYPE ='U')
	DROP TABLE TempCHPAPreReports_For_Eliquis

select * into TempCHPAPreReports_For_Eliquis from TempCHPAPreReports where 1=2

declare @i int,@sql varchar(8000),@sql1 varchar(8000),@sql3 varchar(8000),@sqlMAT varchar(8000),@sqlYTD varchar(8000),@sqlQtr varchar(8000)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2_1 VARCHAR(max)
DECLARE @SQL2_2 VARCHAR(max)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		set @i=0
		set @sql1=''
        set @sql3=''
		while (@i<=48)
		begin
		set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*Rat as R3M'+right('00'+cast(@i as varchar(3)),2)+','
		set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*Rat as MTH'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
		set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*Rat as MAT'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
		while (@i<=48)--todo
		begin
		set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*Rat as YTD'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
		set @sqlQtr=''
		while (@i<=19)
		begin
		set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*Rat as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		set @SQL2_1='insert into TempCHPAPreReports_For_Eliquis 
		select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,
--         A.MNFL_COD,B.Gene_cod,
        '+'''' +@MoneyType+''''+' as Moneytype, '+@sql1+', '+@sql3+', '
        set @SQL2_2=@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
		from mthCHPA_pkau A inner join tblMktDef_MRBIChina_For_Eliquis B
        on A.pack_cod=B.pack_cod where B.Active=''Y'' and b.prod<>''000''
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname,B.Rat'
       print @SQL2_1+@SQL2_2
		exec( @SQL2_1+@SQL2_2)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
update TempCHPAPreReports_For_Eliquis
set Market=case Market when 'ONC' then 'Taxol' 
when 'HYP' then 'Monopril'
when 'NIAD' then 'Glucophage'
when 'ACE' then 'Monopril'
when 'DIA' then 'Glucophage'
when 'ONCFCS' then 'Taxol'
when 'HBV' then 'Baraclude'
when 'ARV' then 'Baraclude' when 'DPP4' then 'Onglyza' when 'CML' then 'Sprycel' 
when 'Platinum' then 'Paraplatin'
else Market end
go

delete 
from TempCHPAPreReports_For_Eliquis
where Market <> 'Paraplatin' and MoneyType = 'PN'
go
declare @i int,@sql varchar(8000),@sql1 varchar(8000),@sql3 varchar(8000),@sqlMAT varchar(8000),@sqlYTD varchar(8000),@sqlQtr varchar(8000)	

set @i=0
set @sql1=''
set @sql3=''
while (@i<=48)
begin
set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
set @i=@i+1
end
set @sql1=left(@sql1,len(@sql1)-1)
set @sql3=left(@sql3,len(@sql3)-1)

set @i=0
set @sqlMAT=''
while (@i<=48)
begin
set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
set @i=@i+1
end
set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

set @i=0
set @sqlYTD=''
while (@i<=48)--todo
begin
set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
set @i=@i+1
end
set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

set @i=0
set @sqlQtr=''
while (@i<=19)
begin
set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
set @i=@i+1
end
set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)

set @sql ='insert into TempCHPAPreReports_For_Eliquis 
		select Molecule,Class,mkt,mktname,Market,''000'',''VTEP Market'',MoneyType,'+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
		from TempCHPAPreReports_For_Eliquis
		group by Molecule,Class,mkt,mktname,Market,MoneyType			
	'
print @sql	
exec (@sql)
 

--go
--------------------------------------------------------
----	Eliquis Ending
--------------------------------------------------------

--go

-------------------------------------------------------
--	OTC: Include Cold and MV
-------------------------------------------------------
if object_id(N'tblMktDef_Inline_For_OTC',N'U') is not null
	drop table tblMktDef_Inline_For_OTC
go

select cast('Cold' as varchar(50)) as Mkt,cast('Cold Market' as varchar(50)) as MktName, b.*
into tblMktDef_Inline_For_OTC
from dbo.tblMkt_KPI_Frame_OTC_Cold a 
join tblMktDef_ATCDriver b on rtrim(left(a.product_name,len(a.product_name)-3))=b.prod_des and right(a.product_name,3)=b.manu_cod

insert into tblMktDef_Inline_For_OTC
select cast('MV' as varchar(50)) as Mkt,cast('MV Market' as varchar(50)) as MktName, b.*
from dbo.tblMkt_KPI_Frame_OTC_MV a 
join tblMktDef_ATCDriver b on rtrim(left(a.product_name,len(a.product_name)-3))=b.prod_des and right(a.product_name,3)=b.manu_cod
go

if object_id(N'tblMktDef_MRBIChina_For_OTC',N'U') is not null
	drop table tblMktDef_MRBIChina_For_OTC
go
select * into tblMktDef_MRBIChina_For_OTC from tblMktDef_MRBIChina where 0=1
go
--Cold Total Market
insert into tblMktDef_MRBIChina_For_OTC
SELECT distinct 
  convert(varchar(10),'Cold') as Mkt,'Cold Market' MktName
  ,'000' as Prod,'Cold Market' as ProductName
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
  ,GetDate() as Date, '201407 add new products & packages' as Comment
FROM tblMktDef_Inline_For_OTC A WHERE A.MKT = 'Cold'
GO

-- Cold Prod
insert into tblMktDef_MRBIChina_For_OTC
SELECT distinct 
   'Cold' as Mkt
  ,'Cold Market' as MktName
  ,case when a.Prod_Des='BUFFERIN COLD' then '100'   
		when a.Prod_Des='COLTALIN'  then '200' 
		when a.Prod_Des='CONTAC RED'  then '300'
		when a.Prod_Des='TYLENOL COLD'  then '400'
		when a.Prod_Des='WHITE & BLACK'  then '500'
		else '940'
        end   as [Prod]         
  ,
  case when a.Prod_Des='BUFFERIN COLD' then a.Prod_Des  
		when a.Prod_Des='COLTALIN'  then a.Prod_Des 
		when a.Prod_Des='CONTAC RED'  then a.Prod_Des
		when a.Prod_Des='TYLENOL COLD'  then a.Prod_Des
		when a.Prod_Des='WHITE & BLACK'  then a.Prod_Des
		else 'Cold Others'
        end   as ProductName
  ,'N'        as Molecule
  ,'N'        as Class 
  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
  ,pack_cod, Pack_des
  ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
  ,'' Mole_cod
  ,'' Mole_Name
  ,Corp_cod
  ,Manu_Cod
  ,Gene_Cod
  ,'Y'       as Active
  ,GetDate() as Date, '201406 add new products & packages'  -- select * 
FROM tblMktDef_Inline_For_OTC A 
WHERE A.MKT  = 'Cold'

GO


--MV Total Market
insert into tblMktDef_MRBIChina_For_OTC
SELECT distinct 
  'MV' Mkt,'MV Market' MktName
  ,'000' as Prod,'MV Market' as ProductName
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
  ,GetDate() as Date, '201407 add new products & packages' as Comment
FROM tblMktDef_Inline_For_OTC A WHERE A.MKT = 'MV'
GO

-- MV Prod
insert into tblMktDef_MRBIChina_For_OTC
SELECT distinct 
   'MV' as Mkt
  ,'MV Market' as MktName
  ,case when a.Prod_Des='21-SUPER VITA' then '100'   
		when a.Prod_Des='CENTRUM'  then '200' 
		when a.Prod_Des='CENTRUM SILVER'  then '300'
		when a.Prod_Des='GOLD THERAGRAN'  then '400'
		else '940'
        end   as [Prod]         
  ,
  case  when a.Prod_Des='21-SUPER VITA' then a.Prod_Des 
		when a.Prod_Des='CENTRUM' then a.Prod_Des
		when a.Prod_Des='CENTRUM SILVER' then a.Prod_Des
		when a.Prod_Des='GOLD THERAGRAN' then a.Prod_Des
		else 'MV Others'
        end   as ProductName
  ,'N'        as Molecule
  ,'N'        as Class 
  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
  ,pack_cod, Pack_des
  ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
  ,'' Mole_cod
  ,'' Mole_Name
  ,Corp_cod
  ,Manu_Cod
  ,Gene_Cod
  ,'Y'       as Active
  ,GetDate() as Date, '201406 add new products & packages'  -- select * 
FROM tblMktDef_Inline_For_OTC A 
WHERE A.MKT  = 'MV'
go

if object_id(N'TempCHPAPreReports_For_OTC',N'U') is not null
	drop table TempCHPAPreReports_For_OTC
go
select * into TempCHPAPreReports_For_OTC from TempCHPAPreReports	where 0=1
go
declare @i int,@sql varchar(8000),@sql1 varchar(8000),@sql3 varchar(8000),@sqlMAT varchar(2000),@sqlYTD varchar(2000),@sqlQtr varchar(2000)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(8000)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		set @i=0
		set @sql1=''
        set @sql3=''
		while (@i<=48)
		begin
		set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
		set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
		set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
		while (@i<=48)--todo
		begin
		set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
		set @sqlQtr=''
		while (@i<=19)
		begin
		set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		set @SQL2='insert into TempCHPAPreReports_For_OTC
		select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,
--         A.MNFL_COD,B.Gene_cod,
        '+'''' +@MoneyType+''''+' as Moneytype, '+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
		from mthCHPA_pkau A inner join tblMktDef_MRBIChina_For_OTC B
        on A.pack_cod=B.pack_cod where B.Active=''Y''
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname'
       print @SQL2
		exec( @SQL2)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
update TempCHPAPreReports_For_OTC
set Market=case Market when 'ONC' then 'Taxol' 
when 'HYP' then 'Monopril'
when 'NIAD' then 'Glucophage'
when 'ACE' then 'Monopril'
when 'DIA' then 'Glucophage'
when 'ONCFCS' then 'Taxol'
when 'HBV' then 'Baraclude'
when 'ARV' then 'Baraclude' when 'DPP4' then 'Onglyza' when 'CML' then 'Sprycel' 
when 'Platinum' then 'Paraplatin'
when 'CCB' then 'Coniel'
else Market end
go

delete 
from TempCHPAPreReports_For_OTC
where Market <> 'Paraplatin' and MoneyType = 'PN'
go

-------------------------------------------------------
--	OTC Ending
-------------------------------------------------------
go


update tblExcelConfig
set ConfigValue= (select max(date) from tblMonthList)
where configkey='DataMonth'
--KPI: IMS Audit - CHPA(both Volume and value)
IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_MarketAnalyzer_IMSAudit_CHPA') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MarketAnalyzer_IMSAudit_CHPA
END

go


--BaracludeValue
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,Series,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,case when prod='000' then convert(int,prod)+1 else convert(int,Prod)  end as Series_Idx
INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA
from (
	select convert(varchar(5),'MTH') as TimeFrame,B.Moneytype,A.Molecule,A.Class,B.Mkt,B.Mktname,B.Market,B.Prod,
	case when B.Productname = 'Adefovir Dipivoxil' then 'Total ADV'
		 when B.Productname = 'Entecavir' then 'Total ETV'
		 when B.Productname = 'Other Entecavir'	then 'Other ETV Total'
		 when B.Productname = 'Run Zhong' then 'Entecavir Run Zhong' else B.Productname end as Series,convert(varchar(50)
	,'Share') as DataType,
	case when b.MoneyType='US' then convert(varchar(50), 'Value' )
		 when b.MoneyType='UN' then convert(varchar(50), 'Volume') end as Category,	
	case sum(A.MTH00) when 0 then null else sum(B.MTH00)*1.0/sum(A.MTH00) end as MTH00,
	case sum(A.MTH01) when 0 then null else sum(B.MTH01)*1.0/sum(A.MTH01) end as MTH01,
	case sum(A.MTH02) when 0 then null else sum(B.MTH02)*1.0/sum(A.MTH02) end as MTH02,
	case sum(A.MTH03) when 0 then null else sum(B.MTH03)*1.0/sum(A.MTH03) end as MTH03,
	case sum(A.MTH04) when 0 then null else sum(B.MTH04)*1.0/sum(A.MTH04) end as MTH04,
	case sum(A.MTH05) when 0 then null else sum(B.MTH05)*1.0/sum(A.MTH05) end as MTH05,
	case sum(A.MTH06) when 0 then null else sum(B.MTH06)*1.0/sum(A.MTH06) end as MTH06,
	case sum(A.MTH07) when 0 then null else sum(B.MTH07)*1.0/sum(A.MTH07) end as MTH07,
	case sum(A.MTH08) when 0 then null else sum(B.MTH08)*1.0/sum(A.MTH08) end as MTH08,
	case sum(A.MTH09) when 0 then null else sum(B.MTH09)*1.0/sum(A.MTH09) end as MTH09,
	case sum(A.MTH10) when 0 then null else sum(B.MTH10)*1.0/sum(A.MTH10) end as MTH10,
	case sum(A.MTH11) when 0 then null else sum(B.MTH11)*1.0/sum(A.MTH11) end as MTH11,
	case sum(A.MTH12) when 0 then null else sum(B.MTH12)*1.0/sum(A.MTH12) end as MTH12
	from TempCHPAPreReports A inner join TempCHPAPreReports B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
	and A.Market=B.Market and A.prod='000' and B.prod<>'000'
	where ((B.class='N' and B.Molecule='N') or (b.molecule='Y' and b.class='N' and b.market='baraclude' and b.productname in ('Entecavir','Adefovir Dipivoxil'))) and b.Moneytype IN ('US','UN') and b.Mktname in ('ARV Market') and b.productname not in ('ARV Others')
	group by B.Moneytype,B.Mkt,A.Molecule,A.Class,B.Mktname,B.Market,B.Prod,B.Productname
	union all
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,A.Productname as Series,convert(varchar(50),'Share') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	sum(A.MTH00) as MTH00,
	sum(A.MTH01) as MTH01,
	sum(A.MTH02) as MTH02,
	sum(A.MTH03) as MTH03,
	sum(A.MTH04) as MTH04,
	sum(A.MTH05) as MTH05,
	sum(A.MTH06) as MTH06,
	sum(A.MTH07) as MTH07,
	sum(A.MTH08) as MTH08,
	sum(A.MTH09) as MTH09,
	sum(A.MTH10) as MTH10,
	sum(A.MTH11) as MTH11,
	sum(A.MTH12) as MTH12
	from TempCHPAPreReports A 
	where MoneyType IN ('US','UN') and a.prod='000' and molecule='N' and class='N' and a.Mktname in ('ARV Market')
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T
alter table KPI_Frame_MarketAnalyzer_IMSAudit_CHPA add Category_Idx int

--BaracludeGrowth
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] 
      ,case when X='MTH Growth(Y2Y)' then 1 
		    when X='MAT Growth' then 2 
		    when X='MTH Growth(vs. last Month)' then 3 
		    when X='YTD Growth' then 4
		    end as X_Idx      
      ,case when prod='000' then convert(int,prod)+1 else convert(int,Prod)  end as Series_Idx
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	case when A.Productname = 'Adefovir Dipivoxil' then 'Total ADV'
		 when A.Productname = 'Entecavir' then 'Total ETV'
		 when A.Productname = 'Other Entecavir'	then 'Other ETV Total' else A.Productname end as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth(Y2Y)],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(mth01) =0 or sum(mth01) is null then null else 1.0*(sum(mth00)-sum(mth01))/sum(mth01) end as [MTH Growth(vs. last Month)],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]
	from TempCHPAPreReports a
	where ((a.class='N' and a.Molecule='N') or (a.molecule='Y' and a.class='N' and a.market='baraclude' and a.productname in ('Entecavir','Adefovir Dipivoxil'))) and a.Moneytype IN ('US','UN') and a.Mktname in ('ARV Market') and a.prod<>'000' 
	AND A.Productname not in ('Other Entecavir','ARV Others')
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
	union
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	case when A.Productname = 'ARV Market' then 'Total Market' else A.Productname end as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth(Y2Y)],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(mth01) =0 or sum(mth01) is null then null else 1.0*(sum(mth00)-sum(mth01))/sum(mth01) end as [MTH Growth(vs. last Month)],	
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]
	from TempCHPAPreReports a
	where a.class='N' and a.Molecule='N' and a.Moneytype IN ('US','UN') and a.Mktname in ('ARV Market') and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth(Y2Y)],[MAT Growth],[MTH Growth(vs. last Month)],[YTD Growth])
)     t

go

--OTC: Cold and MV

--delete from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA where mkt='Cold'
--Cold Share


INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,Series,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='Cold Market' then 1
	 when Series='BUFFERIN COLD' then 2
	 when Series='COLTALIN' then 3
	 when Series='CONTAC RED' then 4 
	 when Series='TYLENOL COLD' then 5 
	 when Series='WHITE & BLACK' then 6
	 end
 as Series_Idx 
from (
	select convert(varchar(5),'MTH') as TimeFrame,B.Moneytype,A.Molecule,A.Class,B.Mkt,B.Mktname,B.Market,B.Prod,
    b.ProductName as Series,convert(varchar(50)
	,'Share') as DataType,
	case when b.MoneyType='US' then 'Value' 
		 when b.MoneyType='UN' then 'Volume' end as Category,	
	case sum(A.MTH00) when 0 then null else sum(B.MTH00)*1.0/sum(A.MTH00) end as MTH00,
	case sum(A.MTH01) when 0 then null else sum(B.MTH01)*1.0/sum(A.MTH01) end as MTH01,
	case sum(A.MTH02) when 0 then null else sum(B.MTH02)*1.0/sum(A.MTH02) end as MTH02,
	case sum(A.MTH03) when 0 then null else sum(B.MTH03)*1.0/sum(A.MTH03) end as MTH03,
	case sum(A.MTH04) when 0 then null else sum(B.MTH04)*1.0/sum(A.MTH04) end as MTH04,
	case sum(A.MTH05) when 0 then null else sum(B.MTH05)*1.0/sum(A.MTH05) end as MTH05,
	case sum(A.MTH06) when 0 then null else sum(B.MTH06)*1.0/sum(A.MTH06) end as MTH06,
	case sum(A.MTH07) when 0 then null else sum(B.MTH07)*1.0/sum(A.MTH07) end as MTH07,
	case sum(A.MTH08) when 0 then null else sum(B.MTH08)*1.0/sum(A.MTH08) end as MTH08,
	case sum(A.MTH09) when 0 then null else sum(B.MTH09)*1.0/sum(A.MTH09) end as MTH09,
	case sum(A.MTH10) when 0 then null else sum(B.MTH10)*1.0/sum(A.MTH10) end as MTH10,
	case sum(A.MTH11) when 0 then null else sum(B.MTH11)*1.0/sum(A.MTH11) end as MTH11,
	case sum(A.MTH12) when 0 then null else sum(B.MTH12)*1.0/sum(A.MTH12) end as MTH12
	from TempCHPAPreReports_For_OTC A inner join TempCHPAPreReports_For_OTC B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and  a.Class=b.Class and a.Molecule=b.Molecule
	and A.Market=B.Market and A.prod='000' and B.prod<>'000' and b.productname not like '%others%'
	where  b.Moneytype IN ('US','UN') and  b.mkt ='Cold'
           and b.Molecule='N' and b.Class='N'
	group by B.Moneytype,B.Mkt,A.Molecule,A.Class,B.Mktname,B.Market,B.Prod,B.Productname
	union all
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,A.Productname as Series,convert(varchar(50),'Share') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	sum(A.MTH00) as MTH00,
	sum(A.MTH01) as MTH01,
	sum(A.MTH02) as MTH02,
	sum(A.MTH03) as MTH03,
	sum(A.MTH04) as MTH04,
	sum(A.MTH05) as MTH05,
	sum(A.MTH06) as MTH06,
	sum(A.MTH07) as MTH07,
	sum(A.MTH08) as MTH08,
	sum(A.MTH09) as MTH09,
	sum(A.MTH10) as MTH10,
	sum(A.MTH11) as MTH11,
	sum(A.MTH12) as MTH12
	from TempCHPAPreReports_For_OTC A 
	where MoneyType IN ('US','UN') and a.prod='000' and molecule='N' and class='N' and a.mkt ='Cold'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T


--Cold Growth
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] 
      ,case when X='MTH Growth(Y2Y)' then 1 
		    when X='MAT Growth' then 2 
		    when X='MTH Growth(vs. last Month)' then 3 
		    when X='YTD Growth' then 4
		    end as X_Idx   
      ,case when Series='Cold Market' then 1
			when Series='BUFFERIN COLD' then 2
			when Series='COLTALIN' then 3
			when Series='CONTAC RED' then 4 
			when Series='TYLENOL COLD' then 5 
			when Series='WHITE & BLACK' then 6
	 end
 as Series_Idx
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.ProductName as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth(Y2Y)],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(mth01) =0 or sum(mth01) is null then null else 1.0*(sum(mth00)-sum(mth01))/sum(mth01) end as [MTH Growth(vs. last Month)],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]	
	from TempCHPAPreReports_For_OTC a
	where a.molecule='N' and a.class='N'  and a.Moneytype IN ('US','UN') and a.mkt='Cold'
	and a.prod<>'000'  and a.productname not like '%others%'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
	union
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.Productname as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth(Y2Y)],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(mth01) =0 or sum(mth01) is null then null else 1.0*(sum(mth00)-sum(mth01))/sum(mth01) end as [MTH Growth(vs. last Month)],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]
	from TempCHPAPreReports_For_OTC a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.mkt='Cold' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth(Y2Y)],[MAT Growth],[MTH Growth(vs. last Month)],[YTD Growth])
)     t

update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA
set y=null
where mkt='Cold' and Y=10000

GO


--delete from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA where mkt='MV'
--MV Share
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,Series,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='MV Market' then 1
	 when Series='21-SUPER VITA' then 2
	 when Series='CENTRUM' then 3
	 when Series='CENTRUM SILVER' then 4 
	 when Series='GOLD THERAGRAN' then 5 
	 end
 as Series_Idx 
from (
	select convert(varchar(5),'MTH') as TimeFrame,B.Moneytype,A.Molecule,A.Class,B.Mkt,B.Mktname,B.Market,B.Prod,
    b.ProductName as Series,convert(varchar(50)
	,'Share') as DataType,
	case when b.MoneyType='US' then 'Value' 
		 when b.MoneyType='UN' then 'Volume' end as Category,	
	case sum(A.MTH00) when 0 then null else sum(B.MTH00)*1.0/sum(A.MTH00) end as MTH00,
	case sum(A.MTH01) when 0 then null else sum(B.MTH01)*1.0/sum(A.MTH01) end as MTH01,
	case sum(A.MTH02) when 0 then null else sum(B.MTH02)*1.0/sum(A.MTH02) end as MTH02,
	case sum(A.MTH03) when 0 then null else sum(B.MTH03)*1.0/sum(A.MTH03) end as MTH03,
	case sum(A.MTH04) when 0 then null else sum(B.MTH04)*1.0/sum(A.MTH04) end as MTH04,
	case sum(A.MTH05) when 0 then null else sum(B.MTH05)*1.0/sum(A.MTH05) end as MTH05,
	case sum(A.MTH06) when 0 then null else sum(B.MTH06)*1.0/sum(A.MTH06) end as MTH06,
	case sum(A.MTH07) when 0 then null else sum(B.MTH07)*1.0/sum(A.MTH07) end as MTH07,
	case sum(A.MTH08) when 0 then null else sum(B.MTH08)*1.0/sum(A.MTH08) end as MTH08,
	case sum(A.MTH09) when 0 then null else sum(B.MTH09)*1.0/sum(A.MTH09) end as MTH09,
	case sum(A.MTH10) when 0 then null else sum(B.MTH10)*1.0/sum(A.MTH10) end as MTH10,
	case sum(A.MTH11) when 0 then null else sum(B.MTH11)*1.0/sum(A.MTH11) end as MTH11,
	case sum(A.MTH12) when 0 then null else sum(B.MTH12)*1.0/sum(A.MTH12) end as MTH12
	from TempCHPAPreReports_For_OTC A inner join TempCHPAPreReports_For_OTC B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and  a.Class=b.Class and a.Molecule=b.Molecule
	and A.Market=B.Market and A.prod='000' and B.prod<>'000' and b.productname not like '%others%'
	where  b.Moneytype IN ('US','UN') and  b.mkt ='MV'
           and b.Molecule='N' and b.Class='N'
	group by B.Moneytype,B.Mkt,A.Molecule,A.Class,B.Mktname,B.Market,B.Prod,B.Productname
	union all
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,A.Productname as Series,convert(varchar(50),'Share') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	sum(A.MTH00) as MTH00,
	sum(A.MTH01) as MTH01,
	sum(A.MTH02) as MTH02,
	sum(A.MTH03) as MTH03,
	sum(A.MTH04) as MTH04,
	sum(A.MTH05) as MTH05,
	sum(A.MTH06) as MTH06,
	sum(A.MTH07) as MTH07,
	sum(A.MTH08) as MTH08,
	sum(A.MTH09) as MTH09,
	sum(A.MTH10) as MTH10,
	sum(A.MTH11) as MTH11,
	sum(A.MTH12) as MTH12
	from TempCHPAPreReports_For_OTC A 
	where MoneyType IN ('US','UN') and a.prod='000' and molecule='N' and class='N' and a.mkt ='MV'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T


--MV Growth
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] 
      ,case when X='MTH Growth(Y2Y)' then 1 
		    when X='MAT Growth' then 2 
		    when X='MTH Growth(vs. last Month)' then 3 
		    when X='YTD Growth' then 4
		    end as X_Idx   
      ,case when Series='MV Market' then 1
			when Series='21-SUPER VITA' then 2
			when Series='CENTRUM' then 3
			when Series='CENTRUM SILVER' then 4 
			when Series='GOLD THERAGRAN' then 5 
	 end
 as Series_Idx
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.ProductName as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth(Y2Y)],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(mth01) =0 or sum(mth01) is null then null else 1.0*(sum(mth00)-sum(mth01))/sum(mth01) end as [MTH Growth(vs. last Month)],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]	
	from TempCHPAPreReports_For_OTC a
	where a.molecule='N' and a.class='N'  and a.Moneytype IN ('US','UN') and a.mkt='MV'
	and a.prod<>'000'  and a.productname not like '%others%'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
	union
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.Productname as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth(Y2Y)],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(mth01) =0 or sum(mth01) is null then null else 1.0*(sum(mth00)-sum(mth01))/sum(mth01) end as [MTH Growth(vs. last Month)],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]
	from TempCHPAPreReports_For_OTC a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.mkt='MV' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth(Y2Y)],[MAT Growth],[MTH Growth(vs. last Month)],[YTD Growth])
)     t

update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA
set y=null
where mkt='MV' and Y=10000

GO


--Eliquis Share
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,Series,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='VTEP Market' then 1
	 when Series='FRAXIPARINE' then 2
	 when Series='CLEXANE' then 3
	 when Series='XARELTO' then 4 
	 when Series='ARIXTRA' then 5 
	 when Series='ELIQUIS' then 6
	 end
 as Series_Idx 
from (
	select convert(varchar(5),'MTH') as TimeFrame,B.Moneytype,A.Molecule,A.Class,B.Mkt,B.Mktname,B.Market,B.Prod,
    b.ProductName as Series,convert(varchar(50)
	,'Share') as DataType,
	case when b.MoneyType='US' then 'Value' 
		 when b.MoneyType='UN' then 'Volume' end as Category,	
	case sum(A.MTH00) when 0 then null else sum(B.MTH00)*1.0/sum(A.MTH00) end as MTH00,
	case sum(A.MTH01) when 0 then null else sum(B.MTH01)*1.0/sum(A.MTH01) end as MTH01,
	case sum(A.MTH02) when 0 then null else sum(B.MTH02)*1.0/sum(A.MTH02) end as MTH02,
	case sum(A.MTH03) when 0 then null else sum(B.MTH03)*1.0/sum(A.MTH03) end as MTH03,
	case sum(A.MTH04) when 0 then null else sum(B.MTH04)*1.0/sum(A.MTH04) end as MTH04,
	case sum(A.MTH05) when 0 then null else sum(B.MTH05)*1.0/sum(A.MTH05) end as MTH05,
	case sum(A.MTH06) when 0 then null else sum(B.MTH06)*1.0/sum(A.MTH06) end as MTH06,
	case sum(A.MTH07) when 0 then null else sum(B.MTH07)*1.0/sum(A.MTH07) end as MTH07,
	case sum(A.MTH08) when 0 then null else sum(B.MTH08)*1.0/sum(A.MTH08) end as MTH08,
	case sum(A.MTH09) when 0 then null else sum(B.MTH09)*1.0/sum(A.MTH09) end as MTH09,
	case sum(A.MTH10) when 0 then null else sum(B.MTH10)*1.0/sum(A.MTH10) end as MTH10,
	case sum(A.MTH11) when 0 then null else sum(B.MTH11)*1.0/sum(A.MTH11) end as MTH11,
	case sum(A.MTH12) when 0 then null else sum(B.MTH12)*1.0/sum(A.MTH12) end as MTH12
	from TempCHPAPreReports_For_Eliquis A inner join TempCHPAPreReports_For_Eliquis B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and  a.Class=b.Class and a.Molecule=b.Molecule
	and A.Market=B.Market and A.prod='000' and B.prod<>'000'
	where  b.Moneytype IN ('US','UN') and  b.market='Eliquis' and b.mkt='Eliquis'
           and b.Molecule='N' and b.Class='N'
	group by B.Moneytype,B.Mkt,A.Molecule,A.Class,B.Mktname,B.Market,B.Prod,B.Productname
	union all
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,A.Productname as Series,convert(varchar(50),'Share') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	sum(A.MTH00) as MTH00,
	sum(A.MTH01) as MTH01,
	sum(A.MTH02) as MTH02,
	sum(A.MTH03) as MTH03,
	sum(A.MTH04) as MTH04,
	sum(A.MTH05) as MTH05,
	sum(A.MTH06) as MTH06,
	sum(A.MTH07) as MTH07,
	sum(A.MTH08) as MTH08,
	sum(A.MTH09) as MTH09,
	sum(A.MTH10) as MTH10,
	sum(A.MTH11) as MTH11,
	sum(A.MTH12) as MTH12
	from TempCHPAPreReports_For_Eliquis A 
	where MoneyType IN ('US','UN') and a.prod='000' and molecule='N' and class='N' and a.mkt ='Eliquis'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T


--Eliquis Growth
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] 
      ,case when X='MTH Growth(vs. last month)' then 1 
		    when X='MQT Growth(vs. last quarter)' then 2
		    when X='YTD Growth(Y2Y)' then 3 end as X_Idx      
      ,case when Series='VTEP Market' then 1
	 when Series='FRAXIPARINE' then 2
	 when Series='CLEXANE' then 3
	 when Series='XARELTO' then 4 
	 when Series='ARIXTRA' then 5 
	 when Series='ELIQUIS' then 6
	 end
 as Series_Idx
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.ProductName as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH01) =0 or sum(MTH01) is null then 10000 else 1.0*(sum(MTH00)-sum(MTH01))/sum(MTH01) end as [MTH Growth(vs. last month)],
	case when sum(r3m03) =0 or sum(r3m03) is null then 10000 else 1.0*(sum(r3m00)-sum(r3m03))/sum(r3m03) end as [MQT Growth(vs. last quarter)],
	case when sum(ytd12) =0 or sum(ytd12) is null then 10000 else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth(Y2Y)]	
	from TempCHPAPreReports_For_Eliquis a
	where a.molecule='N' and a.class='N'  and a.Moneytype IN ('US','UN') and a.market='Eliquis' and a.mkt='Eliquis'
	and a.prod<>'000' 
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
	union
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.Productname as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH01) =0 or sum(MTH01) is null then 10000 else 1.0*(sum(MTH00)-sum(MTH01))/sum(MTH01) end as [MTH Growth(vs. last month)],
	case when sum(r3m03) =0 or sum(r3m03) is null then 10000 else 1.0*(sum(r3m00)-sum(r3m03))/sum(r3m03) end as [MQT Growth(vs. last quarter)],
	case when sum(ytd12) =0 or sum(ytd12) is null then 10000 else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth(Y2Y)]	
	from TempCHPAPreReports_For_Eliquis a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.market='Eliquis' and a.mkt='Eliquis' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth(vs. last month)],[MQT Growth(vs. last quarter)],[YTD Growth(Y2Y)])
)     t

update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA
set y=null
where mkt='Eliquis' and Y=10000

GO


--Coniel Share
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,Series,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='CCB Market' then 1
	 when Series='CONIEL' then 2
	 when Series='YUAN ZHI' then 3
	 when Series='LACIPIL' then 4 
	 when Series='ZANIDIP' then 5 
	 when Series='NORVASC' then 6
	 when Series='ADALAT' then 7
	 when Series='PLENDIL' then 8
	 end
 as Series_Idx 
from (
	select convert(varchar(5),'MTH') as TimeFrame,B.Moneytype,A.Molecule,A.Class,B.Mkt,B.Mktname,B.Market,B.Prod,
    b.ProductName as Series,convert(varchar(50)
	,'Share') as DataType,
	case when b.MoneyType='US' then 'Value' 
		 when b.MoneyType='UN' then 'Volume' end as Category,	
	case sum(A.MTH00) when 0 then null else sum(B.MTH00)*1.0/sum(A.MTH00) end as MTH00,
	case sum(A.MTH01) when 0 then null else sum(B.MTH01)*1.0/sum(A.MTH01) end as MTH01,
	case sum(A.MTH02) when 0 then null else sum(B.MTH02)*1.0/sum(A.MTH02) end as MTH02,
	case sum(A.MTH03) when 0 then null else sum(B.MTH03)*1.0/sum(A.MTH03) end as MTH03,
	case sum(A.MTH04) when 0 then null else sum(B.MTH04)*1.0/sum(A.MTH04) end as MTH04,
	case sum(A.MTH05) when 0 then null else sum(B.MTH05)*1.0/sum(A.MTH05) end as MTH05,
	case sum(A.MTH06) when 0 then null else sum(B.MTH06)*1.0/sum(A.MTH06) end as MTH06,
	case sum(A.MTH07) when 0 then null else sum(B.MTH07)*1.0/sum(A.MTH07) end as MTH07,
	case sum(A.MTH08) when 0 then null else sum(B.MTH08)*1.0/sum(A.MTH08) end as MTH08,
	case sum(A.MTH09) when 0 then null else sum(B.MTH09)*1.0/sum(A.MTH09) end as MTH09,
	case sum(A.MTH10) when 0 then null else sum(B.MTH10)*1.0/sum(A.MTH10) end as MTH10,
	case sum(A.MTH11) when 0 then null else sum(B.MTH11)*1.0/sum(A.MTH11) end as MTH11,
	case sum(A.MTH12) when 0 then null else sum(B.MTH12)*1.0/sum(A.MTH12) end as MTH12
	from TempCHPAPreReports_For_CCB A inner join TempCHPAPreReports_For_CCB B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and  a.Class=b.Class and a.Molecule=b.Molecule
	and A.Market=B.Market and A.prod='000' and B.prod<>'000'
	where  b.Moneytype IN ('US','UN') and  b.market='Coniel' and b.mkt='CCB'
           and b.Molecule='N' and b.Class='N' and b.productname <>'CCB Others'
	group by B.Moneytype,B.Mkt,A.Molecule,A.Class,B.Mktname,B.Market,B.Prod,B.Productname
	union all
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,A.Productname as Series,convert(varchar(50),'Share') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	sum(A.MTH00) as MTH00,
	sum(A.MTH01) as MTH01,
	sum(A.MTH02) as MTH02,
	sum(A.MTH03) as MTH03,
	sum(A.MTH04) as MTH04,
	sum(A.MTH05) as MTH05,
	sum(A.MTH06) as MTH06,
	sum(A.MTH07) as MTH07,
	sum(A.MTH08) as MTH08,
	sum(A.MTH09) as MTH09,
	sum(A.MTH10) as MTH10,
	sum(A.MTH11) as MTH11,
	sum(A.MTH12) as MTH12
	from TempCHPAPreReports_For_CCB A 
	where MoneyType IN ('US','UN') and a.prod='000' and molecule='N' and class='N' and a.mkt ='ccb'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T


--Coniel Growth
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] 
      ,case when X='MTH Growth' then 1 
		    when X='MAT Growth' then 2
		    when X='YTD Growth' then 3 end as X_Idx      
      ,case when Series='CCB Market' then 1
	 when Series='CONIEL' then 2
	 when Series='YUAN ZHI' then 3
	 when Series='LACIPIL' then 4 
	 when Series='ZANIDIP' then 5 
	 when Series='NORVASC' then 6
	 when Series='ADALAT' then 7
	 when Series='PLENDIL' then 8
	 end
 as Series_Idx
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.ProductName as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]	
	from TempCHPAPreReports_For_CCB a
	where a.molecule='N' and a.class='N'  and a.Moneytype IN ('US','UN') and a.market='Coniel' and a.mkt='CCB'
	and a.productname <>'CCB Others'and a.prod<>'000' 
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
	union
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.Productname as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]	
	from TempCHPAPreReports_For_CCB a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.market='Coniel' and a.mkt='ccb' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth],[MAT Growth],[YTD Growth])
)     t

GO





--GlucophageValue
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,Series,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='NIAD Market' then 1
	 when Series='Glucophage' then 2
	 when Series='Glucobay' then 3
	 when Series='Novonorm' then 4
	 when Series='Diamicron' then 5
	 when Series='Amaryl' then 6
	 --when Series='Total Metformin' then 7 
	 end
 as Series_Idx 
from (
	select convert(varchar(5),'MTH') as TimeFrame,B.Moneytype,A.Molecule,A.Class,B.Mkt,B.Mktname,B.Market,B.Prod,
    case when B.Productname='Metformin' then 'Total Metformin' else b.ProductName end as Series,convert(varchar(50)
	,'Share') as DataType,
	case when b.MoneyType='US' then 'Value' 
		 when b.MoneyType='UN' then 'Volume' end as Category,	
	case sum(A.MTH00) when 0 then null else sum(B.MTH00)*1.0/sum(A.MTH00) end as MTH00,
	case sum(A.MTH01) when 0 then null else sum(B.MTH01)*1.0/sum(A.MTH01) end as MTH01,
	case sum(A.MTH02) when 0 then null else sum(B.MTH02)*1.0/sum(A.MTH02) end as MTH02,
	case sum(A.MTH03) when 0 then null else sum(B.MTH03)*1.0/sum(A.MTH03) end as MTH03,
	case sum(A.MTH04) when 0 then null else sum(B.MTH04)*1.0/sum(A.MTH04) end as MTH04,
	case sum(A.MTH05) when 0 then null else sum(B.MTH05)*1.0/sum(A.MTH05) end as MTH05,
	case sum(A.MTH06) when 0 then null else sum(B.MTH06)*1.0/sum(A.MTH06) end as MTH06,
	case sum(A.MTH07) when 0 then null else sum(B.MTH07)*1.0/sum(A.MTH07) end as MTH07,
	case sum(A.MTH08) when 0 then null else sum(B.MTH08)*1.0/sum(A.MTH08) end as MTH08,
	case sum(A.MTH09) when 0 then null else sum(B.MTH09)*1.0/sum(A.MTH09) end as MTH09,
	case sum(A.MTH10) when 0 then null else sum(B.MTH10)*1.0/sum(A.MTH10) end as MTH10,
	case sum(A.MTH11) when 0 then null else sum(B.MTH11)*1.0/sum(A.MTH11) end as MTH11,
	case sum(A.MTH12) when 0 then null else sum(B.MTH12)*1.0/sum(A.MTH12) end as MTH12
	from TempCHPAPreReports A inner join TempCHPAPreReports B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and  A.class = case when b.Productname='Metformin' then 'Y' else B.class end
	and A.Molecule= case when b.Productname='Metformin' then 'N' else  B.Molecule end
	and A.Market=B.Market and A.prod='000' and B.prod<>'000'
	where  b.Moneytype IN ('US','UN') and  b.market='Glucophage ' and b.mkt='NIAD'
           and (
					(b.Productname in ('Glucophage','Glucobay','Novonorm','Diamicron','Amaryl') and B.class='N' and B.Molecule='N') 
					--or(b.Productname='Metformin' and b.class='N' and b.molecule='Y')
				)	
	group by B.Moneytype,B.Mkt,A.Molecule,A.Class,B.Mktname,B.Market,B.Prod,B.Productname
	union all
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,A.Productname as Series,convert(varchar(50),'Share') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	sum(A.MTH00) as MTH00,
	sum(A.MTH01) as MTH01,
	sum(A.MTH02) as MTH02,
	sum(A.MTH03) as MTH03,
	sum(A.MTH04) as MTH04,
	sum(A.MTH05) as MTH05,
	sum(A.MTH06) as MTH06,
	sum(A.MTH07) as MTH07,
	sum(A.MTH08) as MTH08,
	sum(A.MTH09) as MTH09,
	sum(A.MTH10) as MTH10,
	sum(A.MTH11) as MTH11,
	sum(A.MTH12) as MTH12
	from TempCHPAPreReports A 
	where MoneyType IN ('US','UN') and a.prod='000' and molecule='N' and class='N' and a.Mktname in ('NIAD Market')
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T


--GlucophageGrowth
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] 
      ,case when X='MTH Growth' then 1 
		    when X='MAT Growth' then 2 
		    when X='YTD Growth' then 3
		    end as X_Idx      
      ,case when Series='NIAD Market' then 1
	 when Series='Glucophage' then 2
	 when Series='Glucobay' then 3
	 when Series='Novonorm' then 4
	 when Series='Diamicron' then 5
	 when Series='Amaryl' then 6
	 when Series='Total Metformin' then 7 end
 as Series_Idx
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	case when A.Productname='Metformin' then 'Total Metformin' else A.ProductName end as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]
	from TempCHPAPreReports a
	where (
					(a.Productname in ('Glucophage','Glucobay','Novonorm','Diamicron','Amaryl') and a.class='N' and a.Molecule='N') or
					(a.Productname='Metformin' and a.class='N' and a.molecule='Y')
				)  and a.Moneytype IN ('US','UN') and a.market='Glucophage ' and a.mkt='NIAD'and a.prod<>'000' 
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
	union
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.Productname as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]
	from TempCHPAPreReports a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.market='Glucophage ' and a.mkt='NIAD' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth],[MAT Growth],[YTD Growth])
)     t

GO

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'tblMktDef_MRBIChina_For_Onglyza') AND TYPE ='U')
	DROP TABLE tblMktDef_MRBIChina_For_Onglyza

SELECT * 
INTO tblMktDef_MRBIChina_For_Onglyza
FROM (
select distinct mkt,mktname,case when prod_name='Janumet' then '1000' else '1100' end as prod ,
case when prod_name='JANUMET' then 'Janumet' 
	 when prod_name='TRAJENTA' then 'Trajenta' end as ProductName,
molecule,class,atc1_cod,atc2_cod,atc3_cod,atc4_cod,pack_cod,pack_des,prod_cod,prod_name,prod_FullName,mole_cod,mole_name,corp_cod,manu_cod,gene_cod,active,date,comment
from tblMktDef_MRBIChina 
where prod_name in ('Janumet','Trajenta') and mkt='dpp4'
union
select mkt,mktname, prod ,ProductName,
molecule,class,atc1_cod,atc2_cod,atc3_cod,atc4_cod,pack_cod,pack_des,prod_cod,prod_name,prod_FullName,mole_cod,mole_name,corp_cod,manu_cod,gene_cod,active,date,comment 
from tblmktDef_MRBIChina where mkt='dpp4'
) A 

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'TempCHPAPreReports_FOR_Onglyza') AND TYPE ='U')
	DROP TABLE TempCHPAPreReports_FOR_Onglyza

select * into TempCHPAPreReports_FOR_Onglyza from TempCHPAPreReports where 1=2

declare @i int,@sql varchar(8000),@sql1 varchar(8000),@sql3 varchar(8000),@sqlMAT varchar(2000),@sqlYTD varchar(2000),@sqlQtr varchar(2000)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(8000)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		set @i=0
		set @sql1=''
        set @sql3=''
		while (@i<=48)
		begin
		set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
		set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
		set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
		while (@i<=48)--todo
		begin
		set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
		set @sqlQtr=''
		while (@i<=19)
		begin
		set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		set @SQL2='insert into TempCHPAPreReports_FOR_Onglyza 
		select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,
--         A.MNFL_COD,B.Gene_cod,
        '+'''' +@MoneyType+''''+' as Moneytype, '+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
		from mthCHPA_pkau A inner join tblMktDef_MRBIChina_For_Onglyza B
        on A.pack_cod=B.pack_cod where B.Active=''Y''
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname'
       print @SQL2
		exec( @SQL2)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
update TempCHPAPreReports_FOR_Onglyza
set Market=case Market when 'ONC' then 'Taxol' 
when 'HYP' then 'Monopril'
when 'NIAD' then 'Glucophage'
when 'ACE' then 'Monopril'
when 'DIA' then 'Glucophage'
when 'ONCFCS' then 'Taxol'
when 'HBV' then 'Baraclude'
when 'ARV' then 'Baraclude' when 'DPP4' then 'Onglyza' when 'CML' then 'Sprycel' 
when 'Platinum' then 'Paraplatin'
else Market end
go

delete 
from TempCHPAPreReports_FOR_Onglyza
where Market <> 'Paraplatin' and MoneyType = 'PN'

--OnglyzaShare
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,Series,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='DPP4 Market' then 1
	 when Series='Januvia' then 2
	 when Series='Onglyza' then 3
	 when Series='Galvus' then 4
	 when Series='Janumet' then 5
	 when Series='Trajenta' then 6 end
 as Series_Idx 
from (
	select convert(varchar(5),'MTH') as TimeFrame,B.Moneytype,A.Molecule,A.Class,B.Mkt,B.Mktname,B.Market,B.Prod,
    b.ProductName as Series,convert(varchar(50)
	,'Share') as DataType,
	case when b.MoneyType='US' then 'Value' 
		 when b.MoneyType='UN' then 'Volume' end as Category,	
	case sum(A.MTH00) when 0 then null else sum(B.MTH00)*1.0/sum(A.MTH00) end as MTH00,
	case sum(A.MTH01) when 0 then null else sum(B.MTH01)*1.0/sum(A.MTH01) end as MTH01,
	case sum(A.MTH02) when 0 then null else sum(B.MTH02)*1.0/sum(A.MTH02) end as MTH02,
	case sum(A.MTH03) when 0 then null else sum(B.MTH03)*1.0/sum(A.MTH03) end as MTH03,
	case sum(A.MTH04) when 0 then null else sum(B.MTH04)*1.0/sum(A.MTH04) end as MTH04,
	case sum(A.MTH05) when 0 then null else sum(B.MTH05)*1.0/sum(A.MTH05) end as MTH05,
	case sum(A.MTH06) when 0 then null else sum(B.MTH06)*1.0/sum(A.MTH06) end as MTH06,
	case sum(A.MTH07) when 0 then null else sum(B.MTH07)*1.0/sum(A.MTH07) end as MTH07,
	case sum(A.MTH08) when 0 then null else sum(B.MTH08)*1.0/sum(A.MTH08) end as MTH08,
	case sum(A.MTH09) when 0 then null else sum(B.MTH09)*1.0/sum(A.MTH09) end as MTH09,
	case sum(A.MTH10) when 0 then null else sum(B.MTH10)*1.0/sum(A.MTH10) end as MTH10,
	case sum(A.MTH11) when 0 then null else sum(B.MTH11)*1.0/sum(A.MTH11) end as MTH11,
	case sum(A.MTH12) when 0 then null else sum(B.MTH12)*1.0/sum(A.MTH12) end as MTH12
	from TempCHPAPreReports_FOR_Onglyza A inner join TempCHPAPreReports_FOR_Onglyza B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and  a.Class=b.Class and a.Molecule=b.Molecule
	and A.Market=B.Market and A.prod='000' and B.prod<>'000'
	where  b.Moneytype IN ('US','UN') and  b.market='Onglyza' and b.mkt='DPP4'
           and b.Molecule='N' and b.Class='N' and b.productname in ('Januvia','Onglyza','Galvus','Janumet','Trajenta')
	group by B.Moneytype,B.Mkt,A.Molecule,A.Class,B.Mktname,B.Market,B.Prod,B.Productname
	union all
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,A.Productname as Series,convert(varchar(50),'Share') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	sum(A.MTH00) as MTH00,
	sum(A.MTH01) as MTH01,
	sum(A.MTH02) as MTH02,
	sum(A.MTH03) as MTH03,
	sum(A.MTH04) as MTH04,
	sum(A.MTH05) as MTH05,
	sum(A.MTH06) as MTH06,
	sum(A.MTH07) as MTH07,
	sum(A.MTH08) as MTH08,
	sum(A.MTH09) as MTH09,
	sum(A.MTH10) as MTH10,
	sum(A.MTH11) as MTH11,
	sum(A.MTH12) as MTH12
	from TempCHPAPreReports_FOR_Onglyza A 
	where MoneyType IN ('US','UN') and a.prod='000' and molecule='N' and class='N' and a.Mktname in ('DPP4 Market')
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T


--OnglyzaGrowth
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],case when [Y]=0 then null else Y end as Y ,[X] 
      ,case when X='Quarterly Growth' then 1 
			when X='MTH Growth' then 2
			when X='MAT Growth' then 3
			when X='YTD Growth' then 4
      end as X_Idx      
      ,case when Series='DPP4 Market' then 1
	 when Series='Januvia' then 2
	 when Series='Onglyza' then 3
	 when Series='Galvus' then 4 
	 when Series='Janumet' then 5
	 when Series='Trajenta' then 6 end
 as Series_Idx
FROM (
	select 'QTR' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.ProductName as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	--case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	case when sum(r3m03) =0 or sum(r3m03) is null then 0 else 1.0*(sum(r3m00)-sum(r3m03))/sum(r3m03) end as [Quarterly Growth],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(mth12) =0 or sum(mth12) is null then null else 1.0*(sum(mth00)-sum(mth12))/sum(mth12) end as [MTH Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]
	from TempCHPAPreReports_FOR_Onglyza a
	where a.molecule='N' and a.class='N'  and a.Moneytype IN ('US','UN') and a.market='Onglyza' and a.mkt='DPP4'
           and a.productname in ('Januvia','Onglyza','Galvus','Janumet','Trajenta') and a.prod<>'000' 
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
	union
	select 'QTR' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.Productname as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	--case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	case when sum(r3m03) =0 or sum(r3m03) is null then 0 else 1.0*(sum(r3m00)-sum(r3m03))/sum(r3m03) end as [Quarterly Growth],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(mth12) =0 or sum(mth12) is null then null else 1.0*(sum(mth00)-sum(mth12))/sum(mth12) end as [MTH Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]
	from TempCHPAPreReports_FOR_Onglyza a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.market='Onglyza' and a.mkt='DPP4' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([Quarterly Growth],[MAT Growth],[MTH Growth],[YTD Growth])
	--([MTH Growth],[MAT Growth])
)     t

GO

--MonoprilShare
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,Series,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='Hypertension Market' then 1
	 when Series='Acertil' then 2
	 when Series='Lotensin' then 3
	 when Series='Monopril' then 4 
	 when Series='Tritace' then 5 end
 as Series_Idx 
from (
	select convert(varchar(5),'MTH') as TimeFrame,B.Moneytype,A.Molecule,A.Class,B.Mkt,B.Mktname,B.Market,B.Prod,
    b.ProductName as Series,convert(varchar(50)
	,'Share') as DataType,
	case when b.MoneyType='US' then 'Value' 
		 when b.MoneyType='UN' then 'Volume' end as Category,	
	case sum(A.MTH00) when 0 then null else sum(B.MTH00)*1.0/sum(A.MTH00) end as MTH00,
	case sum(A.MTH01) when 0 then null else sum(B.MTH01)*1.0/sum(A.MTH01) end as MTH01,
	case sum(A.MTH02) when 0 then null else sum(B.MTH02)*1.0/sum(A.MTH02) end as MTH02,
	case sum(A.MTH03) when 0 then null else sum(B.MTH03)*1.0/sum(A.MTH03) end as MTH03,
	case sum(A.MTH04) when 0 then null else sum(B.MTH04)*1.0/sum(A.MTH04) end as MTH04,
	case sum(A.MTH05) when 0 then null else sum(B.MTH05)*1.0/sum(A.MTH05) end as MTH05,
	case sum(A.MTH06) when 0 then null else sum(B.MTH06)*1.0/sum(A.MTH06) end as MTH06,
	case sum(A.MTH07) when 0 then null else sum(B.MTH07)*1.0/sum(A.MTH07) end as MTH07,
	case sum(A.MTH08) when 0 then null else sum(B.MTH08)*1.0/sum(A.MTH08) end as MTH08,
	case sum(A.MTH09) when 0 then null else sum(B.MTH09)*1.0/sum(A.MTH09) end as MTH09,
	case sum(A.MTH10) when 0 then null else sum(B.MTH10)*1.0/sum(A.MTH10) end as MTH10,
	case sum(A.MTH11) when 0 then null else sum(B.MTH11)*1.0/sum(A.MTH11) end as MTH11,
	case sum(A.MTH12) when 0 then null else sum(B.MTH12)*1.0/sum(A.MTH12) end as MTH12
	from TempCHPAPreReports A inner join TempCHPAPreReports B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and  a.Class=b.Class and a.Molecule=b.Molecule
	and A.Market=B.Market and A.prod='000' and B.prod<>'000'
	where  b.Moneytype IN ('US','UN') and  b.market='Monopril' and b.mkt='HYP'
           and b.Molecule='N' and b.Class='N' and b.productname in ('Acertil','Lotensin','Monopril','Tritace')
	group by B.Moneytype,B.Mkt,A.Molecule,A.Class,B.Mktname,B.Market,B.Prod,B.Productname
	union all
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,A.Productname as Series,convert(varchar(50),'Share') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	sum(A.MTH00) as MTH00,
	sum(A.MTH01) as MTH01,
	sum(A.MTH02) as MTH02,
	sum(A.MTH03) as MTH03,
	sum(A.MTH04) as MTH04,
	sum(A.MTH05) as MTH05,
	sum(A.MTH06) as MTH06,
	sum(A.MTH07) as MTH07,
	sum(A.MTH08) as MTH08,
	sum(A.MTH09) as MTH09,
	sum(A.MTH10) as MTH10,
	sum(A.MTH11) as MTH11,
	sum(A.MTH12) as MTH12
	from TempCHPAPreReports A 
	where MoneyType IN ('US','UN') and a.prod='000' and molecule='N' and class='N' and a.mkt ='hyp'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T


--MonoprilGrowth
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] 
      ,case when X='MTH Growth' then 1 
		    when X='MAT Growth' then 2
		    when X='YTD Growth' then 3 end as X_Idx      
      ,case when Series='Hypertension Market' then 1
	 when Series='Acertil' then 2
	 when Series='Lotensin' then 3
	 when Series='Monopril' then 4 
	 when Series='Tritace' then 5 end
 as Series_Idx
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.ProductName as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]	
	from TempCHPAPreReports a
	where a.molecule='N' and a.class='N'  and a.Moneytype IN ('US','UN') and a.market='Monopril' and a.mkt='HYP'
	and a.productname in ('Acertil','Lotensin','Monopril','Tritace')and a.prod<>'000' 
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
	union
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.Productname as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]	
	from TempCHPAPreReports a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.market='Monopril' and a.mkt='HYP' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth],[MAT Growth],[YTD Growth])
)     t

GO


--TaxolShare
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,
case when Series='Oncology Focused Brands' then 'Oncology Market' else Series end as Series
 ,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='Oncology Focused Brands' then 1
	 when Series='AI SU' then 2
	 when Series='ZE FEI' then 3
	 when Series='LI PU SU' then 4 
	 when Series='Taxotere' then 5 
	 when Series='Gemzar' then 6
	 when Series='Taxol' then 7
	 when Series='Abraxane' then 8
	 when Series='Anzatax' then 9
	 when Series='Total Paclitaxel' then 10 end	 
 as Series_Idx 
from (
	select convert(varchar(5),'MTH') as TimeFrame,B.Moneytype,A.Molecule,A.Class,B.Mkt,B.Mktname,B.Market,B.Prod,
    case when b.ProductName='Paclitaxel' then 'Total Paclitaxel' else b.ProductName end as Series,convert(varchar(50)
	,'Share') as DataType,
	case when b.MoneyType='US' then 'Value' 
		 when b.MoneyType='UN' then 'Volume' end as Category,	
	case sum(A.MTH00) when 0 then null else sum(B.MTH00)*1.0/sum(A.MTH00) end as MTH00,
	case sum(A.MTH01) when 0 then null else sum(B.MTH01)*1.0/sum(A.MTH01) end as MTH01,
	case sum(A.MTH02) when 0 then null else sum(B.MTH02)*1.0/sum(A.MTH02) end as MTH02,
	case sum(A.MTH03) when 0 then null else sum(B.MTH03)*1.0/sum(A.MTH03) end as MTH03,
	case sum(A.MTH04) when 0 then null else sum(B.MTH04)*1.0/sum(A.MTH04) end as MTH04,
	case sum(A.MTH05) when 0 then null else sum(B.MTH05)*1.0/sum(A.MTH05) end as MTH05,
	case sum(A.MTH06) when 0 then null else sum(B.MTH06)*1.0/sum(A.MTH06) end as MTH06,
	case sum(A.MTH07) when 0 then null else sum(B.MTH07)*1.0/sum(A.MTH07) end as MTH07,
	case sum(A.MTH08) when 0 then null else sum(B.MTH08)*1.0/sum(A.MTH08) end as MTH08,
	case sum(A.MTH09) when 0 then null else sum(B.MTH09)*1.0/sum(A.MTH09) end as MTH09,
	case sum(A.MTH10) when 0 then null else sum(B.MTH10)*1.0/sum(A.MTH10) end as MTH10,
	case sum(A.MTH11) when 0 then null else sum(B.MTH11)*1.0/sum(A.MTH11) end as MTH11,
	case sum(A.MTH12) when 0 then null else sum(B.MTH12)*1.0/sum(A.MTH12) end as MTH12
	from TempCHPAPreReports A inner join TempCHPAPreReports B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and  a.Class=b.Class and a.Molecule=b.Molecule
	and A.Market=B.Market and A.prod='000' and B.prod<>'000'
	where  b.Moneytype IN ('US','UN') and  b.Market='Taxol'  and b.mktName='Oncology Focused Brands'
           and (
				( b.Molecule='N' and b.Class='N' and b.productname in ('AI SU','ZE FEI','LI PU SU','Taxotere','Gemzar','Taxol','Abraxane','Anzatax') ) or
				( b.Molecule='Y' and b.Class='N' and b.productName in ('Paclitaxel'))
           )
	group by B.Moneytype,B.Mkt,A.Molecule,A.Class,B.Mktname,B.Market,B.Prod,B.Productname
	union all
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,A.Productname as Series,convert(varchar(50),'Share') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	sum(A.MTH00) as MTH00,
	sum(A.MTH01) as MTH01,
	sum(A.MTH02) as MTH02,
	sum(A.MTH03) as MTH03,
	sum(A.MTH04) as MTH04,
	sum(A.MTH05) as MTH05,
	sum(A.MTH06) as MTH06,
	sum(A.MTH07) as MTH07,
	sum(A.MTH08) as MTH08,
	sum(A.MTH09) as MTH09,
	sum(A.MTH10) as MTH10,
	sum(A.MTH11) as MTH11,
	sum(A.MTH12) as MTH12
	from TempCHPAPreReports A 
	where MoneyType IN ('US','UN') and a.prod='000' and molecule='N' and class='N' and a.mkt ='ONCFCS'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T


--TaxolGrowth
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,case when Series='Oncology Focused Brands' then 'Oncology Market' else Series end as Series ,[DataType] ,[Category],[Y] ,[X] 
      ,case when X='MTH Growth' then 1 
		    when X='MAT Growth' then 2
		    when X='YTD Growth' then 3 end as X_Idx      
      ,case when Series='Oncology Focused Brands' then 1
	 when Series='AI SU' then 2
	 when Series='ZE FEI' then 3
	 when Series='LI PU SU' then 4 
	 when Series='Taxotere' then 5 
	 when Series='Gemzar' then 6
	 when Series='Taxol' then 7
	 when Series='Abraxane' then 8
	 when Series='Anzatax' then 9
	 when Series='Total Paclitaxel' then 10 end	 
 as Series_Idx
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 case when a.ProductName='Paclitaxel' then 'Total Paclitaxel' else a.ProductName end as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]	
	from TempCHPAPreReports a
	where  a.Moneytype IN ('US','UN') and a.Market='Taxol'  and a.mktName='Oncology Focused Brands'
           and (
				( a.Molecule='N' and a.Class='N' and a.productname in ('AI SU','ZE FEI','LI PU SU','Taxotere','Gemzar','Taxol','Abraxane','Anzatax') ) or
				( a.Molecule='Y' and a.Class='N' and a.productName in ('Paclitaxel'))
           ) and a.prod<>'000' 
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
	union
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.Productname as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]	
	from TempCHPAPreReports a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.mkt ='ONCFCS' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth],[MAT Growth],[YTD Growth])
)  t

GO

--ParaplatinCHPAData

if exists (select * from dbo.sysobjects where id = object_id(N'TempCHPAPreReports_Paraplatin') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table TempCHPAPreReports_Paraplatin

select * into TempCHPAPreReports_Paraplatin from TempCHPAPreReports where 1=2

declare @i int,@sql varchar(8000),@sql1 varchar(8000),@sql3 varchar(8000),@sqlMAT varchar(2000),@sqlYTD varchar(2000),@sqlQtr varchar(2000)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(8000)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		set @i=0
		set @sql1=''
        set @sql3=''
		while (@i<=48)
		begin
		set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
		set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
		set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
		while (@i<=48)--todo
		begin
		set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
		set @sqlQtr=''
		while (@i<=19)
		begin
		set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		set @SQL2='insert into TempCHPAPreReports_Paraplatin 
		select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,
--         A.MNFL_COD,B.Gene_cod,
        '+'''' +@MoneyType+''''+' as Moneytype, '+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
		from mthCHPA_pkau A inner join tblMktDef_MRBIChina B
        on A.pack_cod=B.pack_cod where B.Active=''Y'' and b.mkt =''Platinum'' and b.productName=''CISPLATIN'' and b.Manu_COD=''SDQ'' AND b.MOLECULE=''N'' AND b.CLASS=''N''
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname'
       print @SQL2
		exec( @SQL2)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
update TempCHPAPreReports_Paraplatin
set Market=case Market when 'ONC' then 'Taxol' 
when 'HYP' then 'Monopril'
when 'NIAD' then 'Glucophage'
when 'ACE' then 'Monopril'
when 'DIA' then 'Glucophage'
when 'ONCFCS' then 'Taxol'
when 'HBV' then 'Baraclude'
when 'ARV' then 'Baraclude' when 'DPP4' then 'Onglyza' when 'CML' then 'Sprycel' 
when 'Platinum' then 'Paraplatin'
else Market end
go

delete 
from TempCHPAPreReports_Paraplatin
where Market <> 'Paraplatin' and MoneyType = 'PN'

insert into TempCHPAPreReports_Paraplatin
select * from TempCHPAPreReports where Market='Paraplatin' and Productname <> 'CISPLATIN'
go









--ParaplatinShare
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,
Series  as Series
 ,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='Platinum Market' then 1
	 when Series='AO XIAN DA' then 2
	 when Series='LU BEI' then 3
	 when Series='BO BEI' then 4 
	 when Series='JIE BAI SHU' then 5 
	 when Series='CISPLATIN(SDQ)' then 6
	 when Series='NUO XIN' then 7
	 when Series='PARAPLATIN' then 8
	 when Series='Total CARBOPLATIN' then 9 end
 as Series_Idx 
from (
	select convert(varchar(5),'MTH') as TimeFrame,B.Moneytype,A.Molecule,A.Class,B.Mkt,B.Mktname,B.Market,B.Prod,
    case when b.ProductName='CARBOPLATIN' then 'Total CARBOPLATIN' 
         when b.ProductName='CISPLATIN' then 'CISPLATIN(SDQ)' else b.ProductName end as Series,convert(varchar(50)
	,'Share') as DataType,
	case when b.MoneyType='US' then 'Value' 
		 when b.MoneyType='PN' then 'Adjust patient #' end as Category,	
	case sum(A.MTH00) when 0 then null else sum(B.MTH00)*1.0/sum(A.MTH00) end as MTH00,
	case sum(A.MTH01) when 0 then null else sum(B.MTH01)*1.0/sum(A.MTH01) end as MTH01,
	case sum(A.MTH02) when 0 then null else sum(B.MTH02)*1.0/sum(A.MTH02) end as MTH02,
	case sum(A.MTH03) when 0 then null else sum(B.MTH03)*1.0/sum(A.MTH03) end as MTH03,
	case sum(A.MTH04) when 0 then null else sum(B.MTH04)*1.0/sum(A.MTH04) end as MTH04,
	case sum(A.MTH05) when 0 then null else sum(B.MTH05)*1.0/sum(A.MTH05) end as MTH05,
	case sum(A.MTH06) when 0 then null else sum(B.MTH06)*1.0/sum(A.MTH06) end as MTH06,
	case sum(A.MTH07) when 0 then null else sum(B.MTH07)*1.0/sum(A.MTH07) end as MTH07,
	case sum(A.MTH08) when 0 then null else sum(B.MTH08)*1.0/sum(A.MTH08) end as MTH08,
	case sum(A.MTH09) when 0 then null else sum(B.MTH09)*1.0/sum(A.MTH09) end as MTH09,
	case sum(A.MTH10) when 0 then null else sum(B.MTH10)*1.0/sum(A.MTH10) end as MTH10,
	case sum(A.MTH11) when 0 then null else sum(B.MTH11)*1.0/sum(A.MTH11) end as MTH11,
	case sum(A.MTH12) when 0 then null else sum(B.MTH12)*1.0/sum(A.MTH12) end as MTH12	 
	--case when b.MoneyType='US' then (case sum(A.MTH00) when 0 then null else sum(B.MTH00)*1.0/sum(A.MTH00) end) 
	--	 when b.MoneyType='PN' then sum(b.MTH00) end as MTH00,
	--case when b.MoneyType='US' then (case sum(A.MTH01) when 0 then null else sum(B.MTH01)*1.0/sum(A.MTH01) end) 
	--	 when b.MoneyType='PN' then sum(b.MTH01) end as MTH01,
	--case when b.MoneyType='US' then (case sum(A.MTH02) when 0 then null else sum(B.MTH02)*1.0/sum(A.MTH02) end) 
	--	 when b.MoneyType='PN' then sum(b.MTH02) end as MTH02,
	--case when b.MoneyType='US' then (case sum(A.MTH03) when 0 then null else sum(B.MTH03)*1.0/sum(A.MTH03) end)
	--	 when b.MoneyType='PN' then sum(b.MTH03) end  as MTH03,
	--case when b.MoneyType='US' then (case sum(A.MTH04) when 0 then null else sum(B.MTH04)*1.0/sum(A.MTH04) end)
	--	 when b.MoneyType='PN' then sum(b.MTH04) end  as MTH04,
	--case when b.MoneyType='US' then (case sum(A.MTH05) when 0 then null else sum(B.MTH05)*1.0/sum(A.MTH05) end)
	--	 when b.MoneyType='PN' then sum(b.MTH05) end  as MTH05,
	--case when b.MoneyType='US' then (case sum(A.MTH06) when 0 then null else sum(B.MTH06)*1.0/sum(A.MTH06) end)
	--	 when b.MoneyType='PN' then sum(b.MTH06) end  as MTH06,
	--case when b.MoneyType='US' then (case sum(A.MTH07) when 0 then null else sum(B.MTH07)*1.0/sum(A.MTH07) end)
	--	 when b.MoneyType='PN' then sum(b.MTH07) end  as MTH07,
	--case when b.MoneyType='US' then (case sum(A.MTH08) when 0 then null else sum(B.MTH08)*1.0/sum(A.MTH08) end)
	--	 when b.MoneyType='PN' then sum(b.MTH08) end  as MTH08,
	--case when b.MoneyType='US' then (case sum(A.MTH09) when 0 then null else sum(B.MTH09)*1.0/sum(A.MTH09) end)
	--	 when b.MoneyType='PN' then sum(b.MTH09) end  as MTH09,
	--case when b.MoneyType='US' then (case sum(A.MTH10) when 0 then null else sum(B.MTH10)*1.0/sum(A.MTH10) end)
	--	 when b.MoneyType='PN' then sum(b.MTH10) end  as MTH10,
	--case when b.MoneyType='US' then (case sum(A.MTH11) when 0 then null else sum(B.MTH11)*1.0/sum(A.MTH11) end)
	--	 when b.MoneyType='PN' then sum(b.MTH11) end  as MTH11,
	--case when b.MoneyType='US' then (case sum(A.MTH12) when 0 then null else sum(B.MTH12)*1.0/sum(A.MTH12) end)
	--	 when b.MoneyType='PN' then sum(b.MTH12) end  as MTH12
	from TempCHPAPreReports_Paraplatin A inner join TempCHPAPreReports_Paraplatin B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and  a.Class=b.Class and a.Molecule=b.Molecule
	and A.Market=B.Market and A.prod='000' and B.prod<>'000'
	where  b.Moneytype IN ('US','PN') and  b.Market='PARAPLATIN'  and b.mktName='Platinum Market'
           and (
				( b.Molecule='N' and b.Class='N' and b.productname in ('AO XIAN DA','LU BEI','BO BEI','JIE BAI SHU','CISPLATIN','NUO XIN','PARAPLATIN') ) or
				( b.Molecule='Y' and b.Class='N' and b.productName in ('CARBOPLATIN'))
           )
	group by B.Moneytype,B.Mkt,A.Molecule,A.Class,B.Mktname,B.Market,B.Prod,B.Productname
	union all
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,A.Productname as Series,convert(varchar(50),'Share') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='PN' then 'Adjust patient #' end as Category,
	sum(A.MTH00) as MTH00,
	sum(A.MTH01) as MTH01,
	sum(A.MTH02) as MTH02,
	sum(A.MTH03) as MTH03,
	sum(A.MTH04) as MTH04,
	sum(A.MTH05) as MTH05,
	sum(A.MTH06) as MTH06,
	sum(A.MTH07) as MTH07,
	sum(A.MTH08) as MTH08,
	sum(A.MTH09) as MTH09,
	sum(A.MTH10) as MTH10,
	sum(A.MTH11) as MTH11,
	sum(A.MTH12) as MTH12
	from TempCHPAPreReports_Paraplatin A 
	where MoneyType IN ('US','PN') and a.prod='000' and molecule='N' and class='N' and  a.Market='PARAPLATIN'  and a.mktName='Platinum Market'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T


--ParaplatinGrowth
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,Series as Series ,[DataType] ,[Category],[Y] ,[X] 
      ,case when X='MTH Growth' then 1 
		    when X='MAT Growth' then 2 
		    when x='YTD Growth' then 3 
		    end as X_Idx      
      ,case when Series='Platinum Market' then 1
	 when Series='AO XIAN DA' then 2
	 when Series='LU BEI' then 3
	 when Series='BO BEI' then 4 
	 when Series='JIE BAI SHU' then 5 
	 when Series='CISPLATIN(SDQ)' then 6
	 when Series='NUO XIN' then 7
	 when Series='PARAPLATIN' then 8
	 when Series='Total CARBOPLATIN' then 9 end 
 as Series_Idx
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 case when a.ProductName='CARBOPLATIN' then 'Total CARBOPLATIN' 
         when a.ProductName='CISPLATIN' then 'CISPLATIN(SDQ)' else a.ProductName end as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='PN' then 'Adjust patient #' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]
	from TempCHPAPreReports_Paraplatin a
	where  a.Moneytype IN ('US','PN') and  a.Market='PARAPLATIN'  and a.mktName='Platinum Market'
           and (
				( a.Molecule='N' and a.Class='N' and a.productname in ('AO XIAN DA','LU BEI','BO BEI','JIE BAI SHU','CISPLATIN','NUO XIN','PARAPLATIN') ) or
				( a.Molecule='Y' and a.Class='N' and a.productName in ('CARBOPLATIN'))
           ) and a.prod<>'000' 
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
	union
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.Productname as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='PN' then 'Adjust patient #' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]
	from TempCHPAPreReports_Paraplatin a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','PN') and a.Market='PARAPLATIN'  and a.mktName='Platinum Market' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth],[MAT Growth],[YTD Growth])
)  t
GO
--Byetta
IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'ByettaMarket_TempCHPAPreReports') and type='U')
BEGIN
	DROP TABLE ByettaMarket_TempCHPAPreReports
END
declare @max_Mon int
select @max_Mon=max(monSeq)+12 from tblMonthList where date >=201201

declare @i int
declare @mqt varchar(max)
declare @mqt_un varchar(max)
declare @mqt_us varchar(max)
declare @mqt_sum varchar(max)
declare @mqt_insert varchar(max)
set @i=0
set @mqt=''
set @mqt_un=''
set @mqt_us=''
set @mqt_sum=''
set @mqt_insert=''
while @i<=@max_Mon
begin
	set @mqt=@mqt+',r3m'+right('0'+convert(varchar(2),@i),2)+' as mqt'+right('0'+convert(varchar(2),@i),2)
	set @mqt_un=@mqt_un+',sum(r3m'+right('0'+convert(varchar(2),@i),2)+'un) as mqt'+right('0'+convert(varchar(2),@i),2) 
	set @mqt_us=@mqt_us+',sum(r3m'+right('0'+convert(varchar(2),@i),2)+'us) as mqt'+right('0'+convert(varchar(2),@i),2) 
	set @mqt_sum=@mqt_sum+',sum(mqt'+right('0'+convert(varchar(2),@i),2)+') as mqt'+right('0'+convert(varchar(2),@i),2) 
	set @mqt_insert=@mqt_insert+',mqt'+right('0'+convert(varchar(2),@i),2)
	set @i=@i+1
end

print @mqt
print @mqt_un
print @mqt_us
print @mqt_sum
print @mqt_insert
declare @sql varchar(max)
set @sql =' '
--Glp1
set @sql ='
SELECT  *  
INTO ByettaMarket_TempCHPAPreReports
FROM (
	select ''N'' as  Molecule, ''N'' as class,mkt,mktname,''Byetta'' as market,prod,productname,moneytype, 
	MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12' + @mqt+'
	from TempCHPAPreReports where mkt=''NIAD'' and productName=''glp1'' and MoneyType in (''US'',''UN'')
) a	'
print @sql
exec (@sql)

--Two Byetta
set @sql=' insert into 	ByettaMarket_TempCHPAPreReports(Molecule,class,mkt,mktname,market,prod,productName,MoneyType,
	MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12'+@mqt_insert+')
	select B.Molecule,B.Class,B.mkt,B.mktname,''Byetta'' as market
	,case when b.pack_des=''BYETTA PRE-FILLED P 0.25MG/ML 2.4ML 1'' then ''1100''   when b.pack_des=''BYETTA PRE-FILLED P 0.25MG/ML 1.2ML 1'' then ''1200'' end as prod,
	 b.pack_des as ProductName
	,''UN'' AS MoneyType,
		sum(MTH00UN) AS MTH00,sum(MTH01UN) AS MTH01,sum(MTH02UN) AS MTH02,sum(MTH03UN) AS MTH03,
		sum(MTH04UN) AS MTH04,sum(MTH05UN) AS MTH05,sum(MTH06UN) AS MTH06,sum(MTH07UN) AS MTH07,
		sum(MTH08UN) AS MTH08,sum(MTH09UN) AS MTH09,sum(MTH10UN) AS MTH10,sum(MTH11UN) AS MTH11,
		sum(MTH12UN) AS MTH12'+@mqt_un+'
	from mthCHPA_pkau A inner join (select distinct Mkt,Mktname,Molecule,Class,pack_cod,Pack_des,prod_Name,Active
										from dbo.tblMktDef_MRBIChina 
											where mkt=''niad'' and prod_name=''byetta'' and Molecule=''N'' and Class=''N'')  B
			on A.pack_cod=B.pack_cod where B.Active=''Y''  and b.mkt=''niad'' and b.Molecule=''N'' and b.class=''N''
	group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod_name,b.pack_des      
	union        
	select B.Molecule,B.Class,B.mkt,B.mktname,''Byetta'' as market
	,case when b.pack_des=''BYETTA PRE-FILLED P 0.25MG/ML 2.4ML 1'' then ''1100'' 
		  when b.pack_des=''BYETTA PRE-FILLED P 0.25MG/ML 1.2ML 1'' then ''1200'' end as prod,
	 b.pack_des as ProductName
	 ,''US'' AS MoneyType,	
		sum(MTH00US) AS MTH00,sum(MTH01US) AS MTH01,sum(MTH02US) AS MTH02,sum(MTH03US) AS MTH03,
		sum(MTH04US) AS MTH04,sum(MTH05US) AS MTH05,sum(MTH06US) AS MTH06,sum(MTH07US) AS MTH07,
		sum(MTH08US) AS MTH08,sum(MTH09US) AS MTH09,sum(MTH10US) AS MTH10,sum(MTH11US) AS MTH11,
		sum(MTH12US) AS MTH12'+@mqt_us+'
	from mthCHPA_pkau A inner join (select distinct Mkt,Mktname,Molecule,Class,pack_cod,Pack_des,prod_Name,Active
										from dbo.tblMktDef_MRBIChina 
											where mkt=''niad'' and prod_name=''byetta'' and Molecule=''N'' and Class=''N'')   B
			on A.pack_cod=B.pack_cod where B.Active=''Y'' and b.mkt=''niad'' and b.Molecule=''N'' and b.class=''N''
	group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod_name ,b.pack_des
'	
print @sql
exec (@sql+' ')

--ByettaTotal
set @sql=' insert into 	ByettaMarket_TempCHPAPreReports(Molecule,class,mkt,mktname,market,prod,productName,MoneyType,
	MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12'+@mqt_insert+')
	select B.Molecule,B.Class,B.mkt,B.mktname,''Byetta'' as market
	,''100'' prod,
	 b.prod_name as ProductName
	,''UN'' AS MoneyType,
		sum(MTH00UN) AS MTH00,sum(MTH01UN) AS MTH01,sum(MTH02UN) AS MTH02,sum(MTH03UN) AS MTH03,
		sum(MTH04UN) AS MTH04,sum(MTH05UN) AS MTH05,sum(MTH06UN) AS MTH06,sum(MTH07UN) AS MTH07,
		sum(MTH08UN) AS MTH08,sum(MTH09UN) AS MTH09,sum(MTH10UN) AS MTH10,sum(MTH11UN) AS MTH11,
		sum(MTH12UN) AS MTH12'+@mqt_un+'
	from mthCHPA_pkau A inner join (select distinct Mkt,Mktname,Molecule,Class,pack_cod,Pack_des,prod_Name,Active
										from dbo.tblMktDef_MRBIChina 
											where mkt=''niad'' and prod_name=''byetta'' and Molecule=''N'' and Class=''N'')  B
			on A.pack_cod=B.pack_cod where B.Active=''Y''  and b.mkt=''niad'' and b.Molecule=''N'' and b.class=''N''
	group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod_name    
	union        
	select B.Molecule,B.Class,B.mkt,B.mktname,''Byetta'' as market
	,''100'' as prod,
	 b.prod_name as ProductName
	 ,''US'' AS MoneyType,	
		sum(MTH00US) AS MTH00,sum(MTH01US) AS MTH01,sum(MTH02US) AS MTH02,sum(MTH03US) AS MTH03,
		sum(MTH04US) AS MTH04,sum(MTH05US) AS MTH05,sum(MTH06US) AS MTH06,sum(MTH07US) AS MTH07,
		sum(MTH08US) AS MTH08,sum(MTH09US) AS MTH09,sum(MTH10US) AS MTH10,sum(MTH11US) AS MTH11,
		sum(MTH12US) AS MTH12'+@mqt_us+'
	from mthCHPA_pkau A inner join (select distinct Mkt,Mktname,Molecule,Class,pack_cod,Pack_des,prod_Name,Active
										from dbo.tblMktDef_MRBIChina 
											where mkt=''niad'' and prod_name=''byetta'' and Molecule=''N'' and Class=''N'')   B
			on A.pack_cod=B.pack_cod where B.Active=''Y'' and b.mkt=''niad'' and b.Molecule=''N'' and b.class=''N''
	group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod_name
'	
print @sql
exec (@sql+' ')


--Victoza
set @sql=' insert into 	ByettaMarket_TempCHPAPreReports(Molecule,class,mkt,mktname,market,prod,productName,MoneyType,
	MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12'+@mqt_insert+')
	select B.Molecule,B.Class,B.mkt,B.mktname,''Byetta'' as market,''1000'' as prod,b.prod_name as ProductName,''UN'' AS MoneyType,
		sum(MTH00UN) AS MTH00,sum(MTH01UN) AS MTH01,sum(MTH02UN) AS MTH02,sum(MTH03UN) AS MTH03,
		sum(MTH04UN) AS MTH04,sum(MTH05UN) AS MTH05,sum(MTH06UN) AS MTH06,sum(MTH07UN) AS MTH07,
		sum(MTH08UN) AS MTH08,sum(MTH09UN) AS MTH09,sum(MTH10UN) AS MTH10,sum(MTH11UN) AS MTH11,
		sum(MTH12UN) AS MTH12'+@mqt_un+'
	from mthCHPA_pkau A inner join tblMktDef_MRBIChina B
			on A.pack_cod=B.pack_cod where B.Active=''Y'' AND b.prod_name=''Victoza'' and b.mkt=''niad'' and b.Molecule=''N'' and b.class=''N''
			and b.prod=''000''
	group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod_name        
	union        
	select B.Molecule,B.Class,B.mkt,B.mktname,''Byetta'' as market,''1000'' as prod,b.prod_name as ProductName,''US'' AS MoneyType,	
		sum(MTH00US) AS MTH00,sum(MTH01US) AS MTH01,sum(MTH02US) AS MTH02,sum(MTH03US) AS MTH03,
		sum(MTH04US) AS MTH04,sum(MTH05US) AS MTH05,sum(MTH06US) AS MTH06,sum(MTH07US) AS MTH07,
		sum(MTH08US) AS MTH08,sum(MTH09US) AS MTH09,sum(MTH10US) AS MTH10,sum(MTH11US) AS MTH11,
		sum(MTH12US) AS MTH12'+@mqt_us+'
	from mthCHPA_pkau A inner join tblMktDef_MRBIChina B
			on A.pack_cod=B.pack_cod where B.Active=''Y'' AND b.prod_name=''Victoza'' and b.mkt=''niad'' and b.Molecule=''N'' and b.class=''N''
			and b.prod=''000''
	group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod_name           
'
print @sql
exec (@sql +' ')
--select * from ByettaMarket_TempCHPAPreReports
set @sql ='
insert into ByettaMarket_TempCHPAPreReports(Molecule,class,mkt,mktname,market,prod,productName,MoneyType,
	MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12'+@mqt_insert+')
select molecule,class,mkt,mktname,market,''000'' as prod,''Byetta Market'' as ProductName,MoneyType, 
	sum(MTH00) AS MTH00,sum(MTH01) AS MTH01,sum(MTH02) AS MTH02,sum(MTH03) AS MTH03,
	sum(MTH04) AS MTH04,sum(MTH05) AS MTH05,sum(MTH06) AS MTH06,sum(MTH07) AS MTH07,
	sum(MTH08) AS MTH08,sum(MTH09) AS MTH09,sum(MTH10) AS MTH10,sum(MTH11) AS MTH11,
	sum(MTH12) as MTH12'+@mqt_sum+'
from ByettaMarket_TempCHPAPreReports
where productname not in (''Glp1'',''Byetta'')
group by molecule,class,mkt,mktname,market,MoneyType
'
print @sql
exec (@sql+' ')
GO


--ByettaShare
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,
case when Series='Byetta Market' then Series else Series+' Share' end as Series,
DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='Byetta Market' then 1
	 when Series='Byetta' then 4
	 when Series='BYETTA PRE-FILLED P 0.25MG/ML 2.4ML 1' then 2
	 when Series='BYETTA PRE-FILLED P 0.25MG/ML 1.2ML 1' then 3
	 when Series='Victoza' then 5 end
 as Series_Idx 
from (
	select convert(varchar(5),'MTH') as TimeFrame,B.Moneytype,A.Molecule,A.Class,B.Mkt,B.Mktname,B.Market,B.Prod,
    b.ProductName as Series,convert(varchar(50)
	,'Share') as DataType,
	case when b.MoneyType='US' then 'Value' 
		 when b.MoneyType='UN' then 'Volume' end as Category,	
	case sum(A.MTH00) when 0 then null else sum(B.MTH00)*1.0/sum(A.MTH00) end as MTH00,
	case sum(A.MTH01) when 0 then null else sum(B.MTH01)*1.0/sum(A.MTH01) end as MTH01,
	case sum(A.MTH02) when 0 then null else sum(B.MTH02)*1.0/sum(A.MTH02) end as MTH02,
	case sum(A.MTH03) when 0 then null else sum(B.MTH03)*1.0/sum(A.MTH03) end as MTH03,
	case sum(A.MTH04) when 0 then null else sum(B.MTH04)*1.0/sum(A.MTH04) end as MTH04,
	case sum(A.MTH05) when 0 then null else sum(B.MTH05)*1.0/sum(A.MTH05) end as MTH05,
	case sum(A.MTH06) when 0 then null else sum(B.MTH06)*1.0/sum(A.MTH06) end as MTH06,
	case sum(A.MTH07) when 0 then null else sum(B.MTH07)*1.0/sum(A.MTH07) end as MTH07,
	case sum(A.MTH08) when 0 then null else sum(B.MTH08)*1.0/sum(A.MTH08) end as MTH08,
	case sum(A.MTH09) when 0 then null else sum(B.MTH09)*1.0/sum(A.MTH09) end as MTH09,
	case sum(A.MTH10) when 0 then null else sum(B.MTH10)*1.0/sum(A.MTH10) end as MTH10,
	case sum(A.MTH11) when 0 then null else sum(B.MTH11)*1.0/sum(A.MTH11) end as MTH11,
	case sum(A.MTH12) when 0 then null else sum(B.MTH12)*1.0/sum(A.MTH12) end as MTH12	
	from ByettaMarket_TempCHPAPreReports A inner join ByettaMarket_TempCHPAPreReports B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and  a.Class=b.Class and a.Molecule=b.Molecule
	and A.Market=B.Market and A.prod='000' and B.prod<>'000' 
	where  b.Moneytype IN ('US','UN') and  b.market='Byetta' 
           and b.Molecule='N' and b.Class='N' and  b.productname<>'GLP1'
	group by B.Moneytype,B.Mkt,A.Molecule,A.Class,B.Mktname,B.Market,B.Prod,B.Productname
	union all
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,A.Productname as Series,convert(varchar(50),'Share') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	sum(A.MTH00) as MTH00,
	sum(A.MTH01) as MTH01,
	sum(A.MTH02) as MTH02,
	sum(A.MTH03) as MTH03,
	sum(A.MTH04) as MTH04,
	sum(A.MTH05) as MTH05,
	sum(A.MTH06) as MTH06,
	sum(A.MTH07) as MTH07,
	sum(A.MTH08) as MTH08,
	sum(A.MTH09) as MTH09,
	sum(A.MTH10) as MTH10,
	sum(A.MTH11) as MTH11,
	sum(A.MTH12) as MTH12
	from ByettaMarket_TempCHPAPreReports A 
	where MoneyType IN ('US','UN') and a.prod='000' and molecule='N' and class='N' and a.market='Byetta'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T


declare @max_Mon int
select @max_Mon=max(monSeq) from tblMonthList where date >=201201
declare @i int
declare @mqt_Name varchar(4000)
declare @mqt_GR varchar(4000)
set @mqt_Name=' '
set @mqt_GR=' '
set @i=0
while @i<=@max_Mon
begin
	set @mqt_Name=@mqt_Name+'[mqt'+right('0'+convert(varchar(2),@i),2)+'],'
	set @mqt_GR=@mqt_GR+',case when sum(MQT'+right('0'+convert(varchar(2),@i+12),2)+') =0 or sum(MQT'+right('0'+convert(varchar(2),@i+12),2)+') is null then null else 1.0*(sum(MQT'+
					right('0'+convert(varchar(2),@i),2)+') - SUM(MQT'+right('0'+convert(varchar(2),@i+12),2)+'))/sum(mqt'+right('0'+convert(varchar(2),@i+12),2)+') end as mqt'+right('0'+convert(varchar(2),@i),2)				
	set @i=@i+1
end
set @mqt_Name=left(@mqt_name,len(@mqt_name)-1)
print @mqt_Name
print @mqt_GR
--case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],

--ByettaGrowth
declare @sql varchar(max)
set @sql = '
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx])
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,t2.Colume_name as [X] 
      ,50-t2.Monseq as X_Idx     
      ,case when Series=''GLP1'' then 1
			when Series=''Byetta'' then 4
			when Series=''BYETTA PRE-FILLED P 0.25MG/ML 2.4ML 1'' then 2
			when Series=''BYETTA PRE-FILLED P 0.25MG/ML 1.2ML 1'' then 3
			when Series=''Victoza'' then 5 end
 as Series_Idx
FROM (
	select ''MQT'' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.ProductName as Series,convert(varchar(50),''Growth'') as DataType,
	case when a.MoneyType=''US'' then ''Value'' 
		 when a.MoneyType=''UN'' then ''Volume'' end as Category'+@mqt_GR+'
	from ByettaMarket_TempCHPAPreReports a
	where a.Moneytype IN (''US'',''UN'') and  a.market=''Byetta'' 
           and a.Molecule=''N'' and a.Class=''N'' and a.prod<>''000'' 
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ('+@mqt_Name+')
)     t join (
		select ''mqt''+right(''0''+convert(varchar(2),MonSeq-1),2) as mqt_name,Monseq,
			case when date>201303 then convert(varchar(10),year)+''''''''+left(MonthEN,3) else 
			(case when QtrSeq<>0 then right(convert(varchar(4),year),2)+Quarter else convert(varchar(4),year)+''''+left(MonthEN,3) end  )
			end
			as Colume_name 
		from tblmonthList where ( date<=201303 and date>=201209 and (month%3=0 or QtrSeq=0)) or (date>201303)
) t2 on t.X=t2.mqt_name
'
print @sql
exec(' '+@sql)
GO


GO
--	KPI: IMS Audit - Key City(TOP 10 - 15 cities)
--Create Byetta market city temp table
IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'ByettaMarket_TempCityDashboard') and type='U')
BEGIN
	DROP TABLE ByettaMarket_TempCityDashboard
END


SELECT  *  
INTO ByettaMarket_TempCityDashboard
FROM (
	select Molecule,class,mkt,mktname,'Byetta' as market,prod,productname,moneytype, audi_cod,Audi_des,Lev,
	MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12,mat00,mat12
	from TempCityDashboard where mkt='NIAD' and productName='Byetta' and MoneyType in ('US','UN')
	UNION
	select B.Molecule,B.Class,B.mkt,B.mktname,'Byetta' as market,'1000' as prod,b.prod_name as ProductName,'UN' AS MoneyType,a.Audi_cod, convert(varchar(200),null) as Audi_des,'City' as Lev,
		sum(MTH00UN) AS MTH00,sum(MTH01UN) AS MTH01,sum(MTH02UN) AS MTH02,sum(MTH03UN) AS MTH03,
		sum(MTH04UN) AS MTH04,sum(MTH05UN) AS MTH05,sum(MTH06UN) AS MTH06,sum(MTH07UN) AS MTH07,
		sum(MTH08UN) AS MTH08,sum(MTH09UN) AS MTH09,sum(MTH10UN) AS MTH10,sum(MTH11UN) AS MTH11,
		sum(MTH12UN) AS MTH12,sum(mat00UN) as MAT00,sum(mat12UN) as MAT12
	 from mthcity_pkau A inner join tblMktDef_MRBIChina B
        on A.pack_cod=B.pack_cod where B.Active='Y' AND b.prod_name='Victoza' and b.mkt='niad' and b.Molecule='N' and b.class='N' 
        and b.prod='000'
	group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod_name ,a.Audi_cod       
	union        
	select B.Molecule,B.Class,B.mkt,B.mktname,'Byetta' as market,'1000' as prod,b.prod_name as ProductName,'US' AS MoneyType,a.Audi_cod, convert(varchar(200),null) as Audi_des,'City' as Lev,
		sum(MTH00US) AS MTH00,sum(MTH01US) AS MTH01,sum(MTH02US) AS MTH02,sum(MTH03US) AS MTH03,
		sum(MTH04US) AS MTH04,sum(MTH05US) AS MTH05,sum(MTH06US) AS MTH06,sum(MTH07US) AS MTH07,
		sum(MTH08US) AS MTH08,sum(MTH09US) AS MTH09,sum(MTH10US) AS MTH10,sum(MTH11US) AS MTH11,
		sum(MTH12US) AS MTH12,sum(mat00US) as MAT00,sum(mat12US) as MAT12
	 from mthcity_pkau A inner join tblMktDef_MRBIChina B
        on A.pack_cod=B.pack_cod where B.Active='Y' AND b.prod_name='Victoza' and b.mkt='niad' and b.Molecule='N' and b.class='N'
        and b.prod='000'
	group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod_name ,a.Audi_cod         
)  A
--select * from ByettaMarket_TempCityDashboard
insert into ByettaMarket_TempCityDashboard(Molecule,class,mkt,mktname,market,prod,productName,MoneyType,Audi_cod,Audi_des,Lev,
	MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12,MAT00,MAT12)
select molecule,class,mkt,mktname,market,'000' as prod,'Byetta Market' as ProductName,MoneyType, Audi_cod,null as Audi_des,Lev,
	sum(MTH00) AS MTH00,sum(MTH01) AS MTH01,sum(MTH02) AS MTH02,sum(MTH03) AS MTH03,
	sum(MTH04) AS MTH04,sum(MTH05) AS MTH05,sum(MTH06) AS MTH06,sum(MTH07) AS MTH07,
	sum(MTH08) AS MTH08,sum(MTH09) AS MTH09,sum(MTH10) AS MTH10,sum(MTH11) AS MTH11,
	sum(MTH12) as MTH12,sum(MAT00) as MAT00,sum(MAT12) as MAT12
from ByettaMarket_TempCityDashboard
group by molecule,class,mkt,mktname,market,MoneyType,Audi_cod,Lev

update ByettaMarket_TempCityDashboard
set AUDI_des=City_Name from ByettaMarket_TempCityDashboard A inner join dbo.Dim_City B
on A.AUDI_cod=B.City_Code+'_'


insert into ByettaMarket_TempCityDashboard (Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
Audi_cod,audi_des,lev)
select  Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
Audi_cod,audi_des,lev from (
select A.*,Audi_cod,audi_des,lev from 
(select distinct Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype from ByettaMarket_TempCityDashboard) A
inner join
(select distinct  Molecule,Class,mkt,mktname,Market,Moneytype,Audi_cod,audi_des,lev from ByettaMarket_TempCityDashboard) B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
and a.Moneytype=b.Moneytype) A where not exists(select * from ByettaMarket_TempCityDashboard B
where a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and a.Prod=B.Prod)

GO

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'TempCityDashboard_For_Onglyza') and type='U')
BEGIN
	DROP TABLE TempCityDashboard_For_Onglyza
END

select * into TempCityDashboard_For_Onglyza from tempCityDashboard where 1=2

declare @i int,@sql varchar(8000),@sql1 varchar(8000),@sql3 varchar(8000),@sqlMAT varchar(2000),@sqlYTD varchar(2000),@sqlQtr varchar(2000)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(8000)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		set @i=0
		set @sql1=''
        set @sql3=''
--		while (@i<=57)
        while (@i<=45)
		begin
		set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end

        set @i=0    
--		while (@i<=59)
        while (@i<=48)
		begin
		set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
		set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
--		while (@i<=60)
while (@i<=48)
		begin
		set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
        set @sqlQtr=''
		while (@i<=19)
		begin
		set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
        set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		exec('insert into TempCityDashboard_For_Onglyza 
        select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,'+'''' +@MoneyType+''''+' as Moneytype, A.audi_cod,'''',''City'',null,'+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
		from mthcity_pkau A inner join tblMktDef_MRBIChina_For_Onglyza B
        on A.pack_cod=B.pack_cod where B.Active=''Y''
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname,A.audi_cod')
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go

update TempCityDashboard_For_Onglyza
set AUDI_des=City_Name from TempCityDashboard_For_Onglyza A inner join dbo.Dim_City B
on A.AUDI_cod=B.City_Code+'_'
go

update TempCityDashboard_For_Onglyza
set Market=case  
when Market in ('HYP','ACE') then 'Monopril'
when Market in ('NIAD','DIA') then 'Glucophage'
when Market in ('ONC','ONCFCS') then 'Taxol' 
when Market in ('HBV','ARV') then 'Baraclude'
when Market in ('DPP4') then 'Onglyza' 
when Market in ('CML') then 'Sprycel' 
when Market in ('Platinum') then 'Paraplatin'
else Market end
go

insert into TempCityDashboard_For_Onglyza (Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
Audi_cod,audi_des,lev)
select  Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
Audi_cod,audi_des,lev from (
select A.*,Audi_cod,audi_des,lev from 
(select distinct Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype from TempCityDashboard_For_Onglyza) A
inner join
(select distinct  Molecule,Class,mkt,mktname,Market,Moneytype,Audi_cod,audi_des,lev from TempCityDashboard_For_Onglyza) B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
and a.Moneytype=b.Moneytype) A where not exists(select * from TempCityDashboard_For_Onglyza B
where a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and a.Prod=B.Prod)
go
update TempCityDashboard_For_Onglyza
set Tier=B.Tier from TempCityDashboard_For_Onglyza A inner join Dim_City B
on A.Audi_cod=B.CIty_Code+'_'
go

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'TempCityDashboard_For_KPI_FRAME') and type='U')
BEGIN
	DROP TABLE TempCityDashboard_For_KPI_FRAME
END
select * into TempCityDashboard_For_KPI_FRAME
from (
	select * from tempCityDashboard_AllCity where mkt NOT IN ('DPP4','CCB')
	UNION 
	select * from TempCityDashboard_For_Onglyza
	UNION
	select * from TempcityDashboard_For_CCB
) b


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'TempCHPAPreReports_For_KPI_FRAME') and type='U')
BEGIN
	DROP TABLE TempCHPAPreReports_For_KPI_FRAME
END
select * into TempCHPAPreReports_For_KPI_FRAME
from (
	select * from TempCHPAPreReports where mkt NOT IN ('DPP4','CCB')
	UNION 
	select * from TempCHPAPreReports_FOR_Onglyza
	union
	select * from TempCHPAPreReports_For_CCB
) b
Go


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity
END
GO

--Growth :
select 
case when mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then
		convert(varchar(5),'MAT') 
	 when mkt ='DPP4' then 
		convert(varchar(5),'MQT') 
	 when mkt IN('HYP','CCB') then 
		convert(varchar(5),'YTD') end as  TimeFrame,
MoneyType,
Molecule,
Class,
Mkt,
Mktname,
Market,
Prod,
case when Productname ='Oncology Focused Brands' then 'Oncology Market' else Productname end
 + case when mkt='dpp4' then ' GR(vs.last Quarter)' else  ' GR(Y2Y)' end as Series,
convert(varchar(50),'Growth') as DataType,
convert(varchar(20),'Value') as Category,
case when mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then
		convert(decimal(20,8), case when MAT12 is null or MAT12 = 0 then null else 1.0*(MAT00-MAT12)/MAT12 end) 
	 when mkt ='DPP4' then 
		convert(decimal(20,8), case when R3M03 is null or R3M03 = 0 then null else 1.0*(R3M00-R3M03)/R3M03 end) 
	 when mkt IN('HYP','CCB') then 
		convert(decimal(20,8), case when YTD12 is null or YTD12 = 0 then null else 1.0*(YTD00-YTD12)/YTD12 end)  end as Y, 
Audi_des as X,
row_number() over(partition by Molecule,class,mkt,mktname,market order by (
		case when mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then MAT00				
			 when mkt ='DPP4' then R3M00		
			 when mkt IN('HYP','CCB')  then YTD00 end) desc) as X_Idx,
case when prod='000' then convert(int,prod)+1	else convert(int,prod) end as Series_Idx
into KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity
from TempCityDashboard_For_KPI_FRAME where Mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS','DPP4','HYP','CCB')
and  MoneyType='US' and Molecule='N' and class='N' and Lev='City' and Prod='000'

--Taxol根据Taxol这个产品排序
update b
set b.x_idx =a.audi_Rank
from (
	select mkt,mktname,market,Audi_des,
	row_number() over(partition by Molecule,class,mkt,mktname,market  order by MAT00 desc) as audi_Rank
	from TempCityDashboard_For_KPI_FRAME where Mkt ='ONCFCS'
	and  MoneyType='US' and Molecule='N' and class='N' and Lev='City' and Prod='100'
) a join KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity b on a.mkt=b.mkt and a.mktname=b.mktname and a.market=b.market 
and a.Audi_des=b.x
where b.mkt='ONCFCS' and b.Series like 'Oncology Market%'


insert into KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
	DataType,Category,Y,X,X_Idx,Series_Idx)
select 
case when mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then
		convert(varchar(5),'MAT') 
	 when mkt ='DPP4' then 
		convert(varchar(5),'MQT') 
	 when mkt IN('HYP','CCB')  then 
		convert(varchar(5),'YTD') end as  TimeFrame,
MoneyType,
Molecule,
Class,
Mkt,
Mktname,
Market,
Prod,
Productname+ case when mkt='dpp4' then ' GR(vs.last Quarter)' else  ' GR(Y2Y)' end  as Series,
convert(varchar(50),'Growth') as DataType,
convert(varchar(20),'Value') as Category,
case when mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then
		convert(decimal(20,8), case when MAT12 is null or MAT12 = 0 then null else 1.0*(MAT00-MAT12)/MAT12 end) 
	 when mkt ='DPP4' then 
		convert(decimal(20,8), case when R3M03 is null or R3M03 = 0 then null else 1.0*(R3M00-R3M03)/R3M03 end) 
	 when mkt IN('HYP','CCB')  then 
		convert(decimal(20,8), case when YTD12 is null or YTD12 = 0 then null else 1.0*(YTD00-YTD12)/YTD12 end)  end as Y,
Audi_des as X,
null as X_Idx,
case when prod='000' then convert(int,prod)+1	else convert(int,prod) end as Series_Idx
from TempCityDashboard_For_KPI_FRAME where (
 (Mkt='ARV' and productName in ('Baraclude','Run Zhong','Heptodin','Sebivo') ) or
 (Mkt='DPP4' and productName in ('Onglyza ','Januvia','Galvus','TRAJENTA','JANUMET') ) or
 (Mkt='Eliquis' and productName in ('Eliquis','Xarelto') ) or
 (Mkt='HYP' and productName in ('Monopril','Lotensin','Acertil') ) or --Monopril ,Lotensin,Acertil
 (Mkt='NIAD' and productName in ('Glucophage','Glucobay','Amaryl') ) or --Glucophage,Glucobay,NovoNorm
 (Mkt='ONCFCS' and productName in ('Taxol','Taxotere','Gemzar')) or --Taxol ,Taxotere,Gemzar
 (Mkt='Platinum' and productName in ('PARAPLATIN') ) or-- 
 (Mkt='CCB' and productName in ('ADALAT','CONIEL','LACIPIL','NORVASC','PLENDIL','YUAN ZHI','ZANIDIP') ) 
)  --todo
and  MoneyType='US' and Molecule='N' and class='N' and Lev='City' and Prod<>'000'

--Share
declare @currentMonth varchar(10)
select @currentMonth=MonthEN from tblMonthList where MonSeq=1
insert into KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
	DataType,Category,Y,X,X_Idx,Series_Idx)
select 
case when a.mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then
		convert(varchar(5),'MAT') 
	 when a.mkt ='DPP4' then 
		convert(varchar(5),'MQT') 
	 when a.mkt in ('HYP','CCB') then 
		convert(varchar(5),'YTD') end as  TimeFrame,
a.MoneyType,a.molecule,a.class,a.mkt,a.Mktname,a.Market,a.Prod,
a.Productname+' Share('+  case when a.mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then 'MAT ' 
							   when a.mkt ='DPP4' then 'MQT '
							   when a.mkt in ('HYP','CCB') then 'YTD ' end +@currentMonth+')' as Series,
'Share' as DateType, 'Value' as Category,
case when a.mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then
		(case when b.MAT00 is null or b.MAT00 = 0 then 0 else 1.0*a.MAT00/b.MAT00 end)
	 when a.mkt ='DPP4' then 
		(case when b.R3M00 is null or b.R3M00 = 0 then 0 else 1.0*a.R3M00/b.R3M00 end)
	 when a.mkt in ('HYP','CCB') then 
		(case when b.YTD00 is null or b.YTD00 = 0 then 0 else 1.0*a.YTD00/b.YTD00 end)  end as Y,
a.Audi_des as X, null as X_Idx, convert(int,a.prod)+2 as Series_Idx
from (
	select *  
	from TempCityDashboard_For_KPI_FRAME 
	where (
	 (Mkt='ARV' and productName in ('Baraclude','Run Zhong','Heptodin','Sebivo') ) or
	 (Mkt='DPP4' and productName in ('Onglyza ','Januvia','Galvus','TRAJENTA','JANUMET') ) or
	 (Mkt='Eliquis' and productName in ('Eliquis','Xarelto') ) or
	 (Mkt='HYP' and productName in ('Monopril','Lotensin','Acertil') ) or --Monopril ,Lotensin,Acertil
	 (Mkt='NIAD' and productName in ('Glucophage','Glucobay','Amaryl') ) or --Glucophage,Glucobay,NovoNorm
	 (Mkt='ONCFCS' and productName in ('Taxol','Taxotere','Gemzar')) or --Taxol ,Taxotere,Gemzar
	 (Mkt='Platinum' and productName in ('PARAPLATIN') ) or
	 (Mkt='CCB' and productName in ('ADALAT','CONIEL','LACIPIL','NORVASC','PLENDIL','YUAN ZHI','ZANIDIP') ) -- 
)  and  MoneyType='US' and Molecule='N' and class='N' and prod <> '000' --todo
) a join (
	select *  
	from TempCityDashboard_For_KPI_FRAME 
	where Mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS','DPP4','HYP','CCB')  and  MoneyType='US' and Molecule='N' and class='N' and prod ='000' --todo
) b on a.Molecule=b.molecule and a.class=b.class and a.mkt=b.mkt and a.mktname=b.mktname and a.Market=b.Market 
	and a.MoneyType=b.MoneyType and a.Audi_des=b.Audi_des and a.Audi_cod=b.Audi_cod
	
--Current-Share vs. Last-Share	
insert into KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
	DataType,Category,Y,X,X_Idx,Series_Idx)
select 
case when a.mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then
		convert(varchar(5),'MAT') 
	 when a.mkt ='DPP4' then 
		convert(varchar(5),'MQT') 
	 when a.mkt in ('HYP','CCB') then 
		convert(varchar(5),'YTD') end as  TimeFrame,
a.MoneyType,a.molecule,a.class,a.mkt,a.Mktname,a.Market,a.Prod,
a.Productname+ case when a.mkt='dpp4' then ' Share Change(vs.last Quarter)' else  ' Share Change(Y2Y)' end as Series,'CurrShare vs. LastShare' as DateType, 'Value' as Category,
case when a.mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then
		(case when b.MAT00 is null or b.MAT00 = 0 then 0 else 1.0*a.MAT00/b.MAT00 end - case when b.MAT12 is null or b.MAT12=0 then 0 else 1.0*a.MAT12/b.MAT12 end)
	 when a.mkt ='DPP4' then 
		(case when b.R3M00 is null or b.R3M00 = 0 then 0 else 1.0*a.R3M00/b.R3M00 end - case when b.R3M03 is null or b.R3M03=0 then 0 else 1.0*a.R3M03/b.R3M03 end)
	 when a.mkt in ('HYP','CCB') then 
		(case when b.YTD00 is null or b.YTD00 = 0 then 0 else 1.0*a.YTD00/b.YTD00 end - case when b.YTD12 is null or b.YTD12=0 then 0 else 1.0*a.YTD12/b.YTD12 end)  end as Y,
a.Audi_des as X, null as X_Idx, convert(int,a.prod)+3 as Series_Idx
from (
	select *  
	from TempCityDashboard_For_KPI_FRAME 
	where ( (Mkt='arv' and prod='100') or (Mkt='Eliquis' and prod='100') or (Mkt='NIAD' and prod='100') 
			or  (Mkt='Platinum' and prod='100') or (Mkt='ONCFCS' and prod='100') or (Mkt='DPP4' and prod='100') 
			or (Mkt='HYP' and prod='100')  or (Mkt='CCB' and prod='100')
	) --todo 
	   and  MoneyType='US' and Molecule='N' and class='N' 
) a join (
	select *  
	from TempCityDashboard_For_KPI_FRAME 
	where Mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS','DPP4','HYP','CCB') and  MoneyType='US' and Molecule='N' and class='N' and prod ='000'
) b on a.Molecule=b.molecule and a.class=b.class and a.mkt=b.mkt and a.mktname=b.mktname and a.Market=b.Market 
	and a.MoneyType=b.MoneyType and a.Audi_des=b.Audi_des and a.Audi_cod=b.Audi_cod

GO
--National(Not include Byetta)
insert into KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
	DataType,Category,Y,X,X_Idx,Series_Idx)
select 
case when mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then
		convert(varchar(5),'MAT') 
	 when mkt ='DPP4' then 
		convert(varchar(5),'MQT') 
	 when mkt in ('HYP','CCB') then 
		convert(varchar(5),'YTD') end as  TimeFrame,
MoneyType,
Molecule,
Class,
Mkt,
Mktname,
Market,
Prod,
case when Productname ='Oncology Focused Brands' then 'Oncology Market' else Productname end
 + case when mkt='dpp4' then ' GR(vs.last Quarter)' else  ' GR(Y2Y)' end as Series,
convert(varchar(50),'Growth') as DataType,
convert(varchar(20),'Value') as Category,
case when mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then
		convert(decimal(20,8), case when MAT12 is null or MAT12 = 0 then null else 1.0*(MAT00-MAT12)/MAT12 end) 
	 when mkt ='DPP4' then 
		convert(decimal(20,8), case when R3M03 is null or R3M03 = 0 then null else 1.0*(R3M00-R3M03)/R3M03 end) 
	 when mkt in ('HYP','CCB') then 
		convert(decimal(20,8), case when YTD12 is null or YTD12 = 0 then null else 1.0*(YTD00-YTD12)/YTD12 end)  end as Y, 
'National' as X,
100 as X_Idx,
case when prod='000' then convert(int,prod)+1	else convert(int,prod) end as Series_Idx
from TempCHPAPreReports_For_KPI_FRAME where Mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS','DPP4','HYP','CCB')
and  MoneyType='US' and Molecule='N' and class='N'  and Prod='000'

insert into KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
	DataType,Category,Y,X,X_Idx,Series_Idx)
select 
case when mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then
		convert(varchar(5),'MAT') 
	 when mkt ='DPP4' then 
		convert(varchar(5),'MQT') 
	 when mkt in ('HYP','CCB') then 
		convert(varchar(5),'YTD') end as  TimeFrame,
MoneyType,
Molecule,
Class,
Mkt,
Mktname,
Market,
Prod,
Productname+ case when mkt='dpp4' then ' GR(vs.last Quarter)' else  ' GR(Y2Y)' end as Series,
convert(varchar(50),'Growth') as DataType,
convert(varchar(20),'Value') as Category,
case when mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then
		convert(decimal(20,8), case when MAT12 is null or MAT12 = 0 then null else 1.0*(MAT00-MAT12)/MAT12 end) 
	 when mkt ='DPP4' then 
		convert(decimal(20,8), case when R3M03 is null or R3M03 = 0 then null else 1.0*(R3M00-R3M03)/R3M03 end) 
	 when mkt in ('HYP','CCB') then 
		convert(decimal(20,8), case when YTD12 is null or YTD12 = 0 then null else 1.0*(YTD00-YTD12)/YTD12 end)  end as Y,
'National' as X,
100 as X_Idx,
case when prod='000' then convert(int,prod)+1	else convert(int,prod) end as Series_Idx
from TempCHPAPreReports_For_KPI_FRAME where (
 (Mkt='ARV' and productName in ('Baraclude','Run Zhong','Heptodin','Sebivo') ) or
 (Mkt='DPP4' and productName in ('Onglyza ','Januvia','Galvus','TRAJENTA','JANUMET') ) or
 (Mkt='Eliquis' and productName in ('Eliquis','Xarelto') ) or
 (Mkt='HYP' and productName in ('Monopril','Lotensin','Acertil') ) or --Monopril ,Lotensin,Acertil
 (Mkt='NIAD' and productName in ('Glucophage','Glucobay','Amaryl') ) or --Glucophage,Glucobay,NovoNorm
 (Mkt='ONCFCS' and productName in ('Taxol','Taxotere','Gemzar')) or --Taxol ,Taxotere,Gemzar
 (Mkt='Platinum' and productName in ('PARAPLATIN') ) or
 (Mkt='CCB' and productName in ('ADALAT','CONIEL','LACIPIL','NORVASC','PLENDIL','YUAN ZHI','ZANIDIP') ) 
)  --todo
and  MoneyType='US' and Molecule='N' and class='N' and Prod<>'000'

--Share
declare @currentMonth varchar(10)
select @currentMonth=MonthEN from tblMonthList where MonSeq=1
insert into KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
	DataType,Category,Y,X,X_Idx,Series_Idx)
select 
case when a.mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then
		convert(varchar(5),'MAT') 
	 when a.mkt ='DPP4' then 
		convert(varchar(5),'MQT') 
	 when a.mkt in('HYP','CCB') then 
		convert(varchar(5),'YTD') end as  TimeFrame,
a.MoneyType,a.molecule,a.class,a.mkt,a.Mktname,a.Market,a.Prod,
a.Productname+' Share('+  case when a.mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then 'MAT ' 
							   when a.mkt ='DPP4' then 'MQT '
							   when a.mkt in ('HYP','CCB') then 'YTD ' end +@currentMonth+')' as Series,
'Share' as DateType, 'Value' as Category,
case when a.mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then
		(case when b.MAT00 is null or b.MAT00 = 0 then 0 else 1.0*a.MAT00/b.MAT00 end)
	 when a.mkt ='DPP4' then 
		(case when b.R3M00 is null or b.R3M00 = 0 then 0 else 1.0*a.R3M00/b.R3M00 end)
	 when a.mkt in ('HYP','CCB') then 
		(case when b.YTD00 is null or b.YTD00 = 0 then 0 else 1.0*a.YTD00/b.YTD00 end)  end as Y,
'National' as X, 100 as X_Idx, convert(int,a.prod)+2 as Series_Idx
from (
	select *  
	from TempCHPAPreReports_For_KPI_FRAME 
	where (
	 (Mkt='ARV' and productName in ('Baraclude','Run Zhong','Heptodin','Sebivo') ) or
	 (Mkt='DPP4' and productName in ('Onglyza ','Januvia','Galvus','TRAJENTA','JANUMET') ) or
	 (Mkt='Eliquis' and productName in ('Eliquis','Xarelto') ) or
	 (Mkt='HYP' and productName in ('Monopril','Lotensin','Acertil') ) or --Monopril ,Lotensin,Acertil
	 (Mkt='NIAD' and productName in ('Glucophage','Glucobay','Amaryl') ) or --Glucophage,Glucobay,NovoNorm
	 (Mkt='ONCFCS' and productName in ('Taxol','Taxotere','Gemzar')) or --Taxol ,Taxotere,Gemzar
	 (Mkt='Platinum' and productName in ('PARAPLATIN') ) or
	 (Mkt='CCB' and productName in ('ADALAT','CONIEL','LACIPIL','NORVASC','PLENDIL','YUAN ZHI','ZANIDIP') )  
)  and  MoneyType='US' and Molecule='N' and class='N' and prod <> '000' --todo
) a join (
	select *  
	from TempCHPAPreReports_For_KPI_FRAME 
	where Mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS','DPP4','HYP','CCB')  and  MoneyType='US' and Molecule='N' and class='N' and prod ='000' --todo
) b on a.Molecule=b.molecule and a.class=b.class and a.mkt=b.mkt and a.mktname=b.mktname and a.Market=b.Market 
	and a.MoneyType=b.MoneyType 
	
--Current-Share vs. Last-Share	
insert into KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
	DataType,Category,Y,X,X_Idx,Series_Idx)
select 
case when a.mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then
		convert(varchar(5),'MAT') 
	 when a.mkt ='DPP4' then 
		convert(varchar(5),'MQT') 
	 when a.mkt in ('HYP','CCB') then 
		convert(varchar(5),'YTD') end as  TimeFrame,
a.MoneyType,a.molecule,a.class,a.mkt,a.Mktname,a.Market,a.Prod,
a.Productname+ case when a.mkt='dpp4' then ' Share Change(vs.last Quarter)' else ' Share Change(Y2Y)' end as Series,'CurrShare vs. LastShare' as DateType, 'Value' as Category,
case when a.mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS') then
		(case when b.MAT00 is null or b.MAT00 = 0 then 0 else 1.0*a.MAT00/b.MAT00 end - case when b.MAT12 is null or b.MAT12=0 then 0 else 1.0*a.MAT12/b.MAT12 end)
	 when a.mkt ='DPP4' then 
		(case when b.R3M00 is null or b.R3M00 = 0 then 0 else 1.0*a.R3M00/b.R3M00 end - case when b.R3M03 is null or b.R3M03=0 then 0 else 1.0*a.R3M03/b.R3M03 end)
	 when a.mkt in ('HYP','CCB') then 
		(case when b.YTD00 is null or b.YTD00 = 0 then 0 else 1.0*a.YTD00/b.YTD00 end - case when b.YTD12 is null or b.YTD12=0 then 0 else 1.0*a.YTD12/b.YTD12 end)  end as Y,
'National' as X, 100 as X_Idx, convert(int,a.prod)+3 as Series_Idx
from (
	select *  
	from TempCHPAPreReports_For_KPI_FRAME 
	where ( (Mkt='arv' and prod='100') or (Mkt='Eliquis' and prod='100') or (Mkt='NIAD' and prod='100') 
			or  (Mkt='Platinum' and prod='100') or (Mkt='ONCFCS' and prod='100') or (Mkt='DPP4' and prod='100') 
			or (Mkt='HYP' and prod='100') or (Mkt='CCB' and prod='100')
	) --todo 
	   and  MoneyType='US' and Molecule='N' and class='N' 
) a join (
	select *  
	from TempCHPAPreReports_For_KPI_FRAME 
	where Mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS','DPP4','HYP','CCB') and  MoneyType='US' and Molecule='N' and class='N' and prod ='000'
) b on a.Molecule=b.molecule and a.class=b.class and a.mkt=b.mkt and a.mktname=b.mktname and a.Market=b.Market 
	and a.MoneyType=b.MoneyType 







----Byetta market GR		
--insert into KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
--	DataType,Category,Y,X,X_Idx,Series_Idx)
--select 
--convert(varchar(5),'MAT') as  TimeFrame,
--MoneyType,
--Molecule,
--Class,
--Mkt,
--Mktname,
--Market,
--Prod,
--case when Productname ='Oncology Focused Brands' then 'Oncology Market' else Productname end
-- +' GR(Y2Y)' as Series,
--convert(varchar(50),'Growth') as DataType,
--convert(varchar(20),'Value') as Category,
--convert(decimal(20,8), case when MAT12 is null or MAT12 = 0 then null else 1.0*(MAT00-MAT12)/MAT12 end) as Y, 
--Audi_des as X,
--row_number() over(partition by Molecule,class,mkt,mktname,market order by MAT00 desc) as X_Idx,
--case when prod='000' then convert(int,prod)+1	else convert(int,prod) end as Series_Idx
--from ByettaMarket_TempCityDashboard 
--where  MoneyType='US' and Molecule='N' and class='N' and Lev='City' and Prod='000'

----Byetta Product GR
--insert into KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
--	DataType,Category,Y,X,X_Idx,Series_Idx)
--select 
--convert(varchar(5),'MAT') as  TimeFrame,
--MoneyType,
--Molecule,
--Class,
--Mkt,
--Mktname,
--Market,
--Prod,
--Productname+' GR(Y2Y)' as Series,
--convert(varchar(50),'Growth') as DataType,
--convert(varchar(20),'Value') as Category,
--case when MAT12 is null or MAT12 = 0 then null else 1.0*(MAT00-MAT12)/MAT12 end as Y, 
--Audi_des as X,
--null as X_Idx,
--case when prod='000' then convert(int,prod)+1	else convert(int,prod) end as Series_Idx
--from ByettaMarket_TempCityDashboard
--where MoneyType='US' and Molecule='N' and class='N' and Lev='City' and Prod<>'000'

----ByettaProductShare
--insert into KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,DataType,Category,Y,X,X_Idx,Series_Idx)
--select 
--'MAT' as TimeFrame,a.MoneyType,a.molecule,a.class,a.mkt,a.Mktname,a.Market,a.Prod,
--a.Productname+' Share(MAT '+@currentMonth+')' as Series,'Share' as DateType, 'Value' as Category,
--case when b.MAT00 is null or b.MAT00 = 0 then 0 else 1.0*a.MAT00/b.MAT00 end as Y,
--a.Audi_des as X, null as X_Idx, convert(int,a.prod)+2 as Series_Idx
--from (
--	select *  
--	from ByettaMarket_TempCityDashboard 
--	where  MoneyType='US' and Molecule='N' and class='N' and prod <> '000' --todo
--) a join (
--	select *  
--	from ByettaMarket_TempCityDashboard 
--	where  MoneyType='US' and Molecule='N' and class='N' and prod ='000' --todo
--) b on a.Molecule=b.molecule and a.class=b.class and a.mkt=b.mkt and a.mktname=b.mktname and a.Market=b.Market 
--	and a.MoneyType=b.MoneyType and a.Audi_des=b.Audi_des and a.Audi_cod=b.Audi_cod
	
----Current-Share vs. Last-Share	
--insert into KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
--	DataType,Category,Y,X,X_Idx,Series_Idx)
--select 
--'MAT' as TimeFrame,a.MoneyType,a.molecule,a.class,a.mkt,a.Mktname,a.Market,a.Prod,
--a.Productname+' Share Change(Y2Y)' as Series,'CurrShare vs. LastShare' as DateType, 'Value' as Category,
--case when b.MAT00 is null or b.MAT00 = 0 then 0 else 1.0*a.MAT00/b.MAT00 end - 
--	case when b.MAT12 is null or b.MAT12=0 then 0 else 1.0*a.MAT12/b.MAT12 end as Y,
--a.Audi_des as X, null as X_Idx, convert(int,a.prod)+3 as Series_Idx
--from (
--	select *  
--	from ByettaMarket_TempCityDashboard 
--	where  prod='300'
--	   and  MoneyType='US' and Molecule='N' and class='N' 
--) a join (
--	select *  
--	from ByettaMarket_TempCityDashboard 
--	where  MoneyType='US' and Molecule='N' and class='N' and prod ='000'
--) b on a.Molecule=b.molecule and a.class=b.class and a.mkt=b.mkt and a.mktname=b.mktname and a.Market=b.Market 
--	and a.MoneyType=b.MoneyType and a.Audi_des=b.Audi_des and a.Audi_cod=b.Audi_cod	
--Update City Index which the index value is null	
update a
set a.X_Idx= b.X_Idx
from KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity a join 
(
	select distinct X,X_Idx,mkt,market,mktname
	from KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity 
	where Series like '%Market GR(Y2Y)' or Series like '%Market GR(vs.last Quarter)'
) b on a.X=b.X and a.mkt=b.mkt and a.market=b.market and a.mktname=b.mktname
where a.X_Idx is null		

update KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity
set x_idx=1000
where x='Guangdong'

delete from 
--select distinct market,x,x_idx from 
KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity 
where  exists(
		select * from 
		(
			select market,X_Idx,row_number() over(partition by market order by x_idx) as row_Num 
			from (select distinct market, x_idx,x from KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity where x <>'Guangdong') a
		) t1 where t1.row_num>15 and KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity.market=t1.market 
				   and	KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity.x_idx=t1.x_idx
	)	
and X not in ('National','Wuhan','Chengdu','Shenyang','Xian','Wulumuqi','Guangdong') and mkt<>'CCB'

delete from KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity
where mkt='CCB' and x not in ('National','Guangdong','Beijing','Shenyang','Shanghai','Hangzhou','Guangzhou','Qingdao','Jinan','Harbin','Fuxiaquan','Wulumuqi')


update KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity
set Series_idx= case when Series like 'Amaryl GR%' then 600
				     when Series like 'Amaryl Share%' then 602 else Series_idx end
where 	mkt='niad'	

update KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity
set Series = replace(Series,'JANUMET','Janumet')
from KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity where Series  like 'JANUMET%' and mkt='dpp4'


update KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity
set Series = replace(Series,'TRAJENTA','Trajenta')
from KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity where Series like 'TRAJENTA%' and mkt='dpp4'


GO


-- KPI: IMS Audit - Key City(TOP 10 - 15 cities)-- Byetta Market

--KPI: IMS Audit - 48 Cities
--经测试发现客户提供的是Volume的数据，不是value
IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'KPI_Frame_MarketAnalyzer_IMSAudit_48Cities') AND TYPE='U')
BEGIN
	DROP TABLE KPI_Frame_MarketAnalyzer_IMSAudit_48Cities
END

--Baraclude
select 
convert(varchar(10),'MAT') as TimeFrame,b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
convert(varchar(200),'City Contri.') as Series,convert(varchar(50),'Share') as DataType, convert(varchar(20),'Volume') as Category,
convert(decimal(20,8),case when a.mat00 is null or a.mat00 = 0 then 0 else 1.0*b.mat00/a.mat00 end) as Y,
b.Audi_des as X,null as X_Idx, 1 as Series_Idx
into KPI_Frame_MarketAnalyzer_IMSAudit_48Cities
from 
(
	select * from TempCityDashboard_For_KPI_FRAME 
	where prod='000' and  Mkt in ('arv') and MoneyType='Un' and Molecule='N' and Class='N' 
) a join
(
	select * from TempCityDashboard_For_KPI_FRAME 
	where Mkt='arv' and prod='100'
	 and MoneyType='Un' and Molecule='N' and Class='N'
) b on a.Molecule=b.Molecule and a.Class=b.Class and a.Mktname=b.Mktname and a.market=b.market and a.MoneyType=b.MoneyType 
 and a.Audi_cod=b.Audi_cod and a.Audi_des=b.Audi_des
 
insert into  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
Datatype,Category,Y,X,X_Idx,Series_Idx)
select 
convert(varchar(10),'MAT') as TimeFrame,b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
convert(varchar(200),'Year-to-Year Growth') as Series,convert(varchar(50),'Growth') as DataType, convert(varchar(20),'Volume') as Category,
convert(decimal(20,8),case when b.mat12 is null or b.mat12 = 0 then 0 else 1.0*(b.mat00-b.mat12)/b.mat12 end) as Y,
b.Audi_des as X,null as X_Idx, 2 as Series_Idx
from  TempCityDashboard_For_KPI_FRAME b
where Mkt='arv' and prod='100' and MoneyType='Un' and Molecule='N' and Class='N'

insert into  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
Datatype,Category,Y,X,X_Idx,Series_Idx)
select 
convert(varchar(10),'MAT') as TimeFrame,b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
b.Productname+' Sales' as Series,convert(varchar(50),'Size') as DataType, convert(varchar(20),'Volume') as Category,
b.mat00 as Y,b.Audi_des as X,
row_number() over(partition by MoneyType,Molecule,class,Mkt,mktname,market,prod order by mat00 desc) as X_Idx, 
3 as Series_Idx
from  TempCityDashboard_For_KPI_FRAME b
where Mkt='arv' and prod='100' and MoneyType='Un' and Molecule='N' and Class='N'


--Glucophage,Onglyza,monopril,Taxol,Pareplatin
insert into  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
Datatype,Category,Y,X,X_Idx,Series_Idx)
select 
case when b.mkt in ('NIAD','Eliquis','Platinum','ONCFCS') then
		convert(varchar(5),'MAT') 
	 when b.mkt ='DPP4' then 
		convert(varchar(5),'MQT') 
	 when b.mkt in ('HYP','CCB') then 
		convert(varchar(5),'YTD') end as  TimeFrame,
b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
convert(varchar(200),'City Contri.') as Series,convert(varchar(50),'Share') as DataType, convert(varchar(20),'Value') as Category,
case when b.mkt in ('NIAD','Eliquis','Platinum','ONCFCS') then
		convert(decimal(20,8),case when a.mat00 is null or a.mat00 = 0 then 0 else 1.0*b.mat00/a.mat00 end)
	 when b.mkt ='DPP4' then 
		convert(decimal(20,8),case when a.r3m00 is null or a.r3m00 = 0 then 0 else 1.0*b.r3m00/a.r3m00 end)
	 when b.mkt in ('HYP','CCB')then 
		convert(decimal(20,8),case when a.ytd00 is null or a.ytd00 = 0 then 0 else 1.0*b.ytd00/a.ytd00 end) end as  Y,
b.Audi_des as X,null as X_Idx, 1 as Series_Idx
from 
(
	select * from TempCityDashboard_For_KPI_FRAME 
	where prod='000' and  Mkt in ('NIAD','DPP4','Eliquis','HYP','Platinum','ONCFCS','CCB') and MoneyType='US' and Molecule='N' and Class='N' 
) a join
(
	select * from TempCityDashboard_For_KPI_FRAME 
	where ( (Mkt='Eliquis' and prod='100') or (Mkt='NIAD' and prod='100') 
	or (Mkt='HYP' and prod='100')or (Mkt='CCB' and prod='100') or (Mkt='DPP4' and prod='100') or (Mkt='Platinum' and prod='100') or (Mkt='ONCFCS' and prod='100') )
	 and MoneyType='US' and Molecule='N' and Class='N'
) b on a.Molecule=b.Molecule and a.Class=b.Class and a.Mktname=b.Mktname and a.market=b.market and a.MoneyType=b.MoneyType 
 and a.Audi_cod=b.Audi_cod and a.Audi_des=b.Audi_des
 
insert into  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
Datatype,Category,Y,X,X_Idx,Series_Idx)
select 
case when b.mkt in ('NIAD','Eliquis','Platinum','ONCFCS') then
		convert(varchar(5),'MAT') 
	 when b.mkt ='DPP4' then 
		convert(varchar(5),'MQT') 
	 when b.mkt IN ('HYP','CCB') then 
		convert(varchar(5),'YTD') end as  TimeFrame,
b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
case when mkt='DPP4' then convert(varchar(200),'MQT Growth(vs.last Quarter)') else  convert(varchar(200),'Year-to-Year Growth') end as Series,convert(varchar(50),'Growth') as DataType, convert(varchar(20),'Value') as Category,
case when b.mkt in ('NIAD','Eliquis','Platinum','ONCFCS') then
		convert(decimal(20,8),case when b.mat12 is null or b.mat12 = 0 then null else 1.0*(b.mat00-b.mat12)/b.mat12 end)
	 when b.mkt ='DPP4' then 
		convert(decimal(20,8),case when b.r3m03 is null or b.r3m03 = 0 then null else 1.0*(b.r3m00-b.r3m03)/b.r3m03 end)
	 when b.mkt IN ('HYP','CCB') then 
		convert(decimal(20,8),case when b.ytd12 is null or b.ytd12 = 0 then null else 1.0*(b.ytd00-b.ytd12)/b.ytd12 end) end as  Y,
b.Audi_des as X,null as X_Idx, 2 as Series_Idx
from  TempCityDashboard_For_KPI_FRAME b
where ( (Mkt='Eliquis' and prod='100') or (Mkt='NIAD' and prod='100') 
	or (Mkt='HYP' and prod='100') or (Mkt='CCB' and prod='100') or (Mkt='DPP4' and prod='100') or (Mkt='Platinum' and prod='100') or (Mkt='ONCFCS' and prod='100') ) and MoneyType='US' and Molecule='N' and Class='N'

insert into  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
Datatype,Category,Y,X,X_Idx,Series_Idx)
select 
case when b.mkt in ('NIAD','Eliquis','Platinum','ONCFCS') then
		convert(varchar(5),'MAT') 
	 when b.mkt ='DPP4' then 
		convert(varchar(5),'MQT') 
	 when b.mkt IN ('HYP','CCB') then 
		convert(varchar(5),'YTD') end as  TimeFrame,
b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
b.Productname+' Sales' as Series,convert(varchar(50),'Size') as DataType, convert(varchar(20),'Value') as Category,
case when b.mkt in ('NIAD','Eliquis','Platinum','ONCFCS') then
		b.mat00
	 when b.mkt ='DPP4' then 
		b.r3m00
	 when b.mkt IN ('HYP','CCB') then 
		b.ytd00 end as  Y,
b.Audi_des as X,
row_number() over(partition by MoneyType,Molecule,class,Mkt,mktname,market,prod order by (
		case when mkt in ('NIAD','Eliquis','Platinum','ONCFCS') then MAT00				
			 when mkt ='DPP4' then R3M00		
			 when mkt IN ('HYP','CCB') then YTD00 end) desc) as X_Idx, 
3 as Series_Idx
from  TempCityDashboard_For_KPI_FRAME b
where ( (Mkt='Eliquis' and prod='100') or (Mkt='NIAD' and prod='100') 
	or (Mkt='HYP' and prod='100')or (Mkt='CCB' and prod='100')  or (Mkt='DPP4' and prod='100') or (Mkt='Platinum' and prod='100') or (Mkt='ONCFCS' and prod='100') ) and MoneyType='US' and Molecule='N' and Class='N'


/*

National
*/
--Nation
--Baraclude
insert into  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
Datatype,Category,Y,X,X_Idx,Series_Idx)
select 
convert(varchar(10),'MAT') as TimeFrame,b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
convert(varchar(200),'City Contri.') as Series,convert(varchar(50),'Share') as DataType, convert(varchar(20),'Volume') as Category,
convert(decimal(20,8),case when a.mat00 is null or a.mat00 = 0 then 0 else 1.0*b.mat00/a.mat00 end) as Y,
'National' as X,null as X_Idx, 1 as Series_Idx
from 
(
	select * from TempCHPAPreReports_For_KPI_FRAME 
	where prod='000' and  Mkt in ('arv') and MoneyType='Un' and Molecule='N' and Class='N' 
) a join
(
	select * from TempCHPAPreReports_For_KPI_FRAME 
	where Mkt='arv' and prod='100'
	 and MoneyType='Un' and Molecule='N' and Class='N'
) b on a.Molecule=b.Molecule and a.Class=b.Class and a.Mktname=b.Mktname and a.market=b.market and a.MoneyType=b.MoneyType 

 
insert into  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
Datatype,Category,Y,X,X_Idx,Series_Idx)
select 
convert(varchar(10),'MAT') as TimeFrame,b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
case when mkt='DPP4' then convert(varchar(200),'MQT Growth') else  convert(varchar(200),'Year-to-Year Growth') end as Series,convert(varchar(50),'Growth') as DataType, convert(varchar(20),'Volume') as Category,
convert(decimal(20,8),case when b.mat12 is null or b.mat12 = 0 then 0 else 1.0*(b.mat00-b.mat12)/b.mat12 end) as Y,
'National' as X,null as X_Idx, 2 as Series_Idx
from  TempCHPAPreReports_For_KPI_FRAME b
where Mkt='arv' and prod='000' and MoneyType='Un' and Molecule='N' and Class='N'

insert into  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
Datatype,Category,Y,X,X_Idx,Series_Idx)
select 
convert(varchar(10),'MAT') as TimeFrame,b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
b.Productname+' Sales' as Series,convert(varchar(50),'Size') as DataType, convert(varchar(20),'Volume') as Category,
b.mat00 as Y, 'National'  as X,
row_number() over(partition by MoneyType,Molecule,class,Mkt,mktname,market,prod order by mat00 desc) as X_Idx, 
3 as Series_Idx
from  TempCHPAPreReports_For_KPI_FRAME b
where Mkt='arv' and prod='100' and MoneyType='Un' and Molecule='N' and Class='N'

--National
--Glucophage,Onglyza,monopril,Taxol,Pareplatin
insert into  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
Datatype,Category,Y,X,X_Idx,Series_Idx)
select 
case when b.mkt in ('NIAD','Eliquis','Platinum','ONCFCS') then
		convert(varchar(5),'MAT') 
	 when b.mkt ='DPP4' then 
		convert(varchar(5),'MQT') 
	 when b.mkt in ('HYP','CCB') then 
		convert(varchar(5),'YTD') end as  TimeFrame,
b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
convert(varchar(200),'City Contri.') as Series,convert(varchar(50),'Share') as DataType, convert(varchar(20),'Value') as Category,
case when b.mkt in ('NIAD','Eliquis','Platinum','ONCFCS') then
		convert(decimal(20,8),case when a.mat00 is null or a.mat00 = 0 then 0 else 1.0*b.mat00/a.mat00 end)
	 when b.mkt ='DPP4' then 
		convert(decimal(20,8),case when a.r3m00 is null or a.r3m00 = 0 then 0 else 1.0*b.r3m00/a.r3m00 end)
	 when b.mkt in ('HYP','CCB') then 
		convert(decimal(20,8),case when a.ytd00 is null or a.ytd00 = 0 then 0 else 1.0*b.ytd00/a.ytd00 end) end as  Y,
'National'  as X,null as X_Idx, 1 as Series_Idx
from 
(
	select * from TempCHPAPreReports_For_KPI_FRAME 
	where prod='000' and  Mkt in ('NIAD','DPP4','Eliquis','HYP','Platinum','ONCFCS','CCB') and MoneyType='US' and Molecule='N' and Class='N' 
) a join
(
	select * from TempCHPAPreReports_For_KPI_FRAME 
	where ( (Mkt='Eliquis' and prod='100') or (Mkt='NIAD' and prod='100') 
	or (Mkt='HYP' and prod='100')or (Mkt='CCB' and prod='100') or (Mkt='DPP4' and prod='100') or (Mkt='Platinum' and prod='100') or (Mkt='ONCFCS' and prod='100') )
	 and MoneyType='US' and Molecule='N' and Class='N'
) b on a.Molecule=b.Molecule and a.Class=b.Class and a.Mktname=b.Mktname and a.market=b.market and a.MoneyType=b.MoneyType 
and a.mkt=b.mkt
 
insert into  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
Datatype,Category,Y,X,X_Idx,Series_Idx)
select 
case when b.mkt in ('NIAD','Eliquis','Platinum','ONCFCS') then
		convert(varchar(5),'MAT') 
	 when b.mkt ='DPP4' then 
		convert(varchar(5),'MQT') 
	 when b.mkt in ('HYP','CCB') then 
		convert(varchar(5),'YTD') end as  TimeFrame,
b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
case when mkt='DPP4' then convert(varchar(200),'MQT Growth(vs.last Quarter)') else  convert(varchar(200),'Year-to-Year Growth') end as Series,convert(varchar(50),'Growth') as DataType, convert(varchar(20),'Value') as Category,
case when b.mkt in ('NIAD','Eliquis','Platinum','ONCFCS') then
		convert(decimal(20,8),case when b.mat12 is null or b.mat12 = 0 then null else 1.0*(b.mat00-b.mat12)/b.mat12 end)
	 when b.mkt ='DPP4' then 
		convert(decimal(20,8),case when b.r3m03 is null or b.r3m03 = 0 then null else 1.0*(b.r3m00-b.r3m03)/b.r3m03 end)
	 when b.mkt in ('HYP','CCB') then 
		convert(decimal(20,8),case when b.ytd12 is null or b.ytd12 = 0 then null else 1.0*(b.ytd00-b.ytd12)/b.ytd12 end) end as  Y,
'National' as X,null as X_Idx, 2 as Series_Idx
from  TempCHPAPreReports_For_KPI_FRAME b
where ( (Mkt='Eliquis' and prod='000') or (Mkt='NIAD' and prod='000') 
	or (Mkt='HYP' and prod='000')or (Mkt='CCB' and prod='000') or (Mkt='DPP4' and prod='000') or (Mkt='Platinum' and prod='000') or (Mkt='ONCFCS' and prod='000') ) and MoneyType='US' and Molecule='N' and Class='N'

insert into  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
Datatype,Category,Y,X,X_Idx,Series_Idx)
select 
case when b.mkt in ('NIAD','Eliquis','Platinum','ONCFCS') then
		convert(varchar(5),'MAT') 
	 when b.mkt ='DPP4' then 
		convert(varchar(5),'MQT') 
	 when b.mkt in ('HYP','CCB') then 
		convert(varchar(5),'YTD') end as  TimeFrame,
b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
b.Productname+' Sales' as Series,convert(varchar(50),'Size') as DataType, convert(varchar(20),'Value') as Category,
case when b.mkt in ('NIAD','Eliquis','Platinum','ONCFCS') then
		b.mat00
	 when b.mkt ='DPP4' then 
		b.r3m00
	 when b.mkt in ('HYP','CCB') then 
		b.ytd00 end as  Y,
'National' as X,
null X_Idx, 
3 as Series_Idx
from  TempCHPAPreReports_For_KPI_FRAME b
where ( (Mkt='Eliquis' and prod='100') or (Mkt='NIAD' and prod='100') 
	or (Mkt='HYP' and prod='100')or (Mkt='CCB' and prod='100') or (Mkt='DPP4' and prod='100') or (Mkt='Platinum' and prod='100') or (Mkt='ONCFCS' and prod='100') ) and MoneyType='US' and Molecule='N' and Class='N'



----BeyttaRelatedData

--insert into  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
--Datatype,Category,Y,X,X_Idx,Series_Idx)
--select 
--convert(varchar(10),'MAT') as TimeFrame,b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
--convert(varchar(200),'City Contri.') as Series,convert(varchar(50),'Share') as DataType, convert(varchar(20),'Volume') as Category,
--convert(decimal(20,8),case when a.mat00 is null or a.mat00 = 0 then 0 else 1.0*b.mat00/a.mat00 end) as Y,
--b.Audi_des as X,null as X_Idx, 1 as Series_Idx
--from 
--(
--	select * from ByettaMarket_TempCityDashboard 
--	where prod='000' and  MoneyType='Un' and Molecule='N' and Class='N' 
--) a join
--(
--	select * from ByettaMarket_TempCityDashboard 
--	where prod='300' and MoneyType='Un' and Molecule='N' and Class='N'
--) b on a.Molecule=b.Molecule and a.Class=b.Class and a.Mktname=b.Mktname and a.market=b.market and a.MoneyType=b.MoneyType 
-- and a.Audi_cod=b.Audi_cod and a.Audi_des=b.Audi_des
 
--insert into  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
--Datatype,Category,Y,X,X_Idx,Series_Idx)
--select 
--convert(varchar(10),'MAT') as TimeFrame,b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
--convert(varchar(200),'Year-to-Year Growth') as Series,convert(varchar(50),'Growth') as DataType, convert(varchar(20),'Volume') as Category,
--convert(decimal(20,8),case when b.mat12 is null or b.mat12 = 0 then 0 else 1.0*(b.mat00-b.mat12)/b.mat12 end) as Y,
--b.Audi_des as X,null as X_Idx, 2 as Series_Idx
--from  ByettaMarket_TempCityDashboard b
--where prod='300' and MoneyType='Un' and Molecule='N' and Class='N'

--insert into  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
--Datatype,Category,Y,X,X_Idx,Series_Idx)
--select 
--convert(varchar(10),'MAT') as TimeFrame,b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
--b.Productname+' Sales' as Series,convert(varchar(50),'Size') as DataType, convert(varchar(20),'Volume') as Category,
--b.mat00 as Y,b.Audi_des as X,
--row_number() over(partition by MoneyType,Molecule,class,Mkt,mktname,market,prod order by mat00 desc) as X_Idx, 
--2 as Series_Idx
--from  ByettaMarket_TempCityDashboard b
--where prod='300' and MoneyType='Un' and Molecule='N' and Class='N'

update a
set a.X_IDX=b.X_Idx
from KPI_Frame_MarketAnalyzer_IMSAudit_48Cities a join 
(select distinct Market,mkt,X,X_Idx from KPI_Frame_MarketAnalyzer_IMSAudit_48Cities where X_Idx is not null) b 
on a.market=b.market and a.x=b.x and a.mkt=b.mkt
where a.X_Idx is null

update KPI_Frame_MarketAnalyzer_IMSAudit_48Cities
set x_idx=60
where x='National'

update KPI_Frame_MarketAnalyzer_IMSAudit_48Cities
set x_idx=100
where x='Guangdong'

GO
--KPI: Growth Trend(for Monopril only)
/*
productname	prod
Acertil	200
Lotensin	700
Monopril	100
Tritace	800
*/
IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'KPI_Frame_MarketAnalyzer_GrowthTrend_For_Monopril') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MarketAnalyzer_GrowthTrend_For_Monopril
END


select MonSeq,'MQT '+MonthEN as RequiName
from tblMonthList
where (((Month-1)%3 = 0 and Year>2010 and year <2013) or year>2012) and MonSeq<25

declare @sql_mqt varchar(max)
declare @i int
declare @lastYear varchar(300)
declare @currYear varchar(300)
declare @MonthEN varchar(30)
declare @mqtList varchar(4000)
set @sql_mqt =''
set @i=0
set @lastYear=''
set @currYear=''
set @MonthEN=''
set @mqtList=''
while @i<35
begin
	select @MonthEN=MonthEN from tblMonthList where MonSeq=@i+1
	set @currYear=right('0'+convert(varchar(2),@i),2)
	set @lastYear=right('0'+convert(varchar(2),@i+12),2)
	set @sql_mqt=@sql_mqt+'case when R3M'+@lastYear+' is null or R3M'+@lastYear+'=0 then null else 1.0*(R3M'+@currYear+'-R3M'+@lastYear+')/(R3M'+@lastYear+') end as [MQT '+@MonthEN+'],'
	set @mqtList=@mqtList+'[MQT '+@MonthEN+'],'	
	set @i=@i+1	
end
set @sql_mqt=left(@sql_mqt,len(@sql_mqt)-1)
set @mqtList=left(@mqtList,len(@mqtList)-1)


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'KPI_Frame_MarketAnalyzer_GrowthTrend_For_Monopril_Mid1') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MarketAnalyzer_GrowthTrend_For_Monopril_Mid1
END

declare @sql varchar(max)
set @sql= '
select convert(varchar(5),''MQT'') as TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,Prod,Productname as Series,
convert(varchar(50),''GrowthTrent'') as DataType,convert(varchar(20),''Value'') as Category,'+@sql_mqt+'
into KPI_Frame_MarketAnalyzer_GrowthTrend_For_Monopril_Mid1
from dbo.TempCHPAPreReports where market=''monopril'' and molecule=''N'' and class=''N'' and MoneyType=''US'' and mkt=''HYP''
and prod in (''100'',''200'',''700'',''800'')'
print @sql
exec (' '+@sql)

select * from KPI_Frame_MarketAnalyzer_GrowthTrend_For_Monopril_Mid1
declare @sql2 varchar(max)
set @sql2='
select t.Timeframe,t.MoneyType,t.Molecule,t.Class,t.mkt,t.mktname,t.market,t.prod,t.Series,t.DataType,t.Category,
convert(decimal(20,8),t.Y) as y,convert(varchar(20),t.X) as X, convert(int, t.prod) as Series_idx,convert(int,null) as X_Idx
into KPI_Frame_MarketAnalyzer_GrowthTrend_For_Monopril
from KPI_Frame_MarketAnalyzer_GrowthTrend_For_Monopril_Mid1 a 
unpivot (
	Y FOR X IN ('+@mqtList+')
)  t'
print @sql2
exec (' ' + @sql2)

--仅保留需要的MQT数据
update a
set a.X_Idx=100-b.MonSeq
from KPI_Frame_MarketAnalyzer_GrowthTrend_For_Monopril a join 
(
	select MonSeq,'MQT '+MonthEN as RequiName
	from tblMonthList
	where (((Month-1)%3 = 0 and Year>2010 and year <2013) or year>2012) and MonSeq<25
) b on a.X=b.RequiName
delete from KPI_Frame_MarketAnalyzer_GrowthTrend_For_Monopril where X_Idx is null
drop table dbo.KPI_Frame_MarketAnalyzer_GrowthTrend_For_Monopril_Mid1
GO

--KPI: Xarelto Value - Top 30 Cities (for Eliquis only)

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'KPI_Frame_MarketAnalyzer_XareltoValue_For_Eliquis') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MarketAnalyzer_XareltoValue_For_Eliquis
END

select * 
INTO KPI_Frame_MarketAnalyzer_XareltoValue_For_Eliquis
from 
(
	SELECT convert(varchar(5),'MAT') as TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,Prod,
	convert(varchar(200),Productname+' Sales Value') as Series,convert(varchar(50),null) as DataType,convert(varchar(20),null) as Category,
	convert(decimal(20,8),MAT00) AS Y,Audi_des as X, 1 AS Series_Idx
	, row_number() over(partition by MoneyType,Molecule,Class,Mkt,Mktname,Market,Prod order by MAT00 desc) as X_Idx
	FROM tempCityDashboard_AllCity 
	WHERE MARKET='ELIQUIS' AND PRODUCTNAME='XARELTO'  AND moneyType='US' and Molecule='N' and Class='N' and audi_des<>'Guangdong'
	union all
	SELECT convert(varchar(5),'MAT') as TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,Prod,
	convert(varchar(200),Productname+' Sales Value') as Series,convert(varchar(50),null) as DataType,convert(varchar(20),null) as Category,
	convert(decimal(20,8),MAT00) AS Y,Audi_des as X, 1 AS Series_Idx
	, 1000 as X_Idx
	FROM tempCityDashboard_AllCity 
	WHERE MARKET='ELIQUIS' AND PRODUCTNAME='XARELTO'  AND moneyType='US' and Molecule='N' and Class='N' and audi_des='Guangdong'
	
) a where a.X_Idx<=30 or a.x='Guangdong'

insert into KPI_Frame_MarketAnalyzer_XareltoValue_For_Eliquis(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,Prod,
	Series,DataType,Category,Y,X,Series_Idx,X_Idx)
select TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,Prod,Series,DataType,Category,Y,X,Series_Idx,X_Idx
from (
	SELECT convert(varchar(5),'MAT') as TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,Prod,
	'Growth' as Series,convert(varchar(50),null) as DataType,convert(varchar(20),null) as Category,
	case when MAT12 IS NULL OR MAT12=0 then 0 else 1.0*(MAT00-MAT12)/MAT12 end as Y,
	Audi_des as X, 2 AS Series_Idx ,
	row_number() over(partition by MoneyType,Molecule,Class,Mkt,Mktname,Market,Prod order by MAT00 desc) as X_Idx
	FROM tempCityDashboard_AllCity 
	WHERE MARKET='ELIQUIS' AND PRODUCTNAME='XARELTO'  AND moneyType='US' and Molecule='N' and Class='N' and audi_des<>'Guangdong'
	union all
	SELECT convert(varchar(5),'MAT') as TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,Prod,
	'Growth' as Series,convert(varchar(50),null) as DataType,convert(varchar(20),null) as Category,
	case when MAT12 IS NULL OR MAT12=0 then 0 else 1.0*(MAT00-MAT12)/MAT12 end as Y,
	Audi_des as X, 2 AS Series_Idx ,
	1000 as X_Idx
	FROM tempCityDashboard_AllCity 
	WHERE MARKET='ELIQUIS' AND PRODUCTNAME='XARELTO'  AND moneyType='US' and Molecule='N' and Class='N' and audi_des='Guangdong'
) a where a.X_Idx<=30	or a.x='Guangdong'

declare @NationAvg decimal(20,8)
select @NationAvg=case when MAT12 IS NULL OR MAT12=0 then 0 else 1.0*(MAT00-MAT12)/MAT12 end 
from dbo.TempCHPAPreReports where MARKET='ELIQUIS' AND PRODUCTNAME='XARELTO'  AND moneyType='US' and Molecule='N' and Class='N'

insert into KPI_Frame_MarketAnalyzer_XareltoValue_For_Eliquis(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,Prod,
	Series,DataType,Category,Y,X,Series_Idx,X_Idx)
select distinct TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,Prod,
'National Average Growth' as Series,DataType,Category,@NationAvg as Y, X,3 as Series_Idx,X_Idx
from KPI_Frame_MarketAnalyzer_XareltoValue_For_Eliquis
GO
----------------------------------------------
--KPI: Generics Trend (for Baraclude only)
----------------------------------------------
IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'KPI_Frame_MarketAnalyzer_GenericsTrend') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MarketAnalyzer_GenericsTrend
END

select 
	TimeFrame,Currency as MoneyType,'N' as Molecule,'N' as Class, 'ARV' as Mkt, 'ARV Market' as MktName,'Baraclude' as market,
	convert(varchar(200),null) as Prod,
	case when a.IsShow='Y' and  a.Series='Entecavir Size' then 'ETV Category Size'
	     when a.IsShow='Y' and  a.Series='Baraclude MS(%)' then 'Baraclude'
	     when a.IsShow='Y' and  a.Series='Run zhong MS(%)' then 'Entecavir RUN ZHONG'
	     when a.IsShow='L' then a.Series end
	 as Series,
	convert(varchar(50),null) as DataType, convert(varchar(50),null) as Category,Y as Y,
	'20'+right(replace(b.X,'MTH ',''),2)+left(replace(b.X,'MTH ',''),3) as X,b.XIdx-23 as X_Idx,
	SeriesIdx
into KPI_Frame_MarketAnalyzer_GenericsTrend	
from output a join (select distinct X,XIdx from output where linkchartcode='R777' and IsShow='Y') b on a.XIdx=b.XIdx
where a.linkchartcode='r777' and a.XIdx>23

GO

---------------------------------------------------------------------
--KPI: BMS Brand vs. Generic Brand (for Baraclude only)
--Result: 这个部分数据城市和China都是正确的，但是Tier 2和Tier3 不正确，
--这是应为，Excel里‘Suxi’属于Tier 2，但是在我们的数据库里是属于Tier 3
----------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'KPI_Frame_MarketAnalyzer_BMSBrandvsGenericBrand') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MarketAnalyzer_BMSBrandvsGenericBrand
END

--CityVel
select 'MTH' as TimeFrame,a.MoneyType,a.Molecule,a.Class,a.mkt,a.Mktname,a.Market, 
	convert(varchar(200),null) as Prod,'vs. RunZ' as Series,
	convert(varchar(50),null) as DataType, convert(varchar(20),null) as Category,
	convert(decimal(20,8),case when c.mth00 is null or c.mth00=0 then 0 else 1.0*a.mth00/c.mth00-1.0*b.mth00/c.mth00 end) as Y,a.Audi_des as X, convert(int,null) as X_Idx, 1 as Series_Idx
into KPI_Frame_MarketAnalyzer_BMSBrandvsGenericBrand
from (
	select Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,Audi_Cod,Audi_des,
          case when Audi_des='Nanning'  then 3 when Audi_des='Guangdong' then '-'  else Tier end as Tier, MTH00   
	from  dbo.tempCityDashboard_AllCity
    where Mkt='ARV' and Productname in ('Baraclude') and MoneyType='UN' and Molecule='N' and class='N'
  ) a join  (
	select Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,Audi_Cod,Audi_des,
           case when Audi_des='Nanning'  then 3 when Audi_des='Guangdong' then '-'  else Tier end as Tier, MTH00   
	from  dbo.tempCityDashboard_AllCity
    where Mkt='ARV' and Productname in ('RUN ZHONG') and MoneyType='UN' and Molecule='N' and class='N'
  ) b  on a.Molecule=b.Molecule and a.Class=b.Class and a.Mkt=b.Mkt and a.Mktname=b.mktname and a.market=b.market 
	and a.MoneyType=b.MoneyType and a.Audi_cod=b.Audi_cod and a.Audi_des=b.Audi_des and a.Tier=b.Tier
	  join  (
	select Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,Audi_Cod,Audi_des,
           case when Audi_des='Nanning'  then 3 when Audi_des='Guangdong' then '-'  else Tier end as Tier, MTH00   
	from  dbo.tempCityDashboard_AllCity
    where Mkt='ARV' and Prod='000' and MoneyType='UN' and Molecule='N' and class='N'
  ) c on a.Molecule=c.Molecule and a.Class=c.Class and a.Mkt=c.Mkt and a.Mktname=c.mktname and a.market=c.market 
	and a.MoneyType=c.MoneyType and a.Audi_cod=c.Audi_cod and a.Audi_des=c.Audi_des and a.Tier=c.Tier
	
--Nation Level
declare @maxMonth int
declare @baracludeMS decimal(20,8)
declare @runZhongMS decimal(20,8)

select @maxMonth=max(X_Idx) from KPI_Frame_MarketAnalyzer_GenericsTrend
select @baracludeMS=Y from KPI_Frame_MarketAnalyzer_GenericsTrend where Series in ('Baraclude MS(%)') and X_Idx=@maxMonth
select @runZhongMS=Y from KPI_Frame_MarketAnalyzer_GenericsTrend where Series in ('Run zhong MS(%)') and X_Idx=@maxMonth

insert into dbo.KPI_Frame_MarketAnalyzer_BMSBrandvsGenericBrand ( TimeFrame,MoneyType,Molecule,Class,mkt,Mktname,Market,
	prod,Series,DataType,Category,Y,X,X_Idx,Series_Idx
	)
select distinct TimeFrame,MoneyType,Molecule,Class,mkt,Mktname,Market,
	prod,Series,DataType,Category,@baracludeMS-@runZhongMS as Y,'China' as X,null as X_Idx,Series_Idx
from KPI_Frame_MarketAnalyzer_BMSBrandvsGenericBrand

--TierLevel
IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'TempBMSBrandvsGenericBrand') and type='U')
BEGIN
	DROP TABLE TempBMSBrandvsGenericBrand
END

SELECT Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,
'Tier '+convert(varchar(3),Tier)+' ('+convert(varchar(3),count(distinct Audi_des))+')' as Audi_Cod,
'Tier '+convert(varchar(3),Tier)+' ('+convert(varchar(3),count(distinct Audi_des))+')' as Audi_Des,
SUM(MTH00) as MTH00
INTO TempBMSBrandvsGenericBrand
FROM (
	select Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,Audi_Cod,Audi_des,
           case when Audi_des='Nanning' then 3 else Tier end as Tier, MTH00   
	from  dbo.tempCityDashboard_AllCity where mkt='arv' and MoneyType='UN' and Molecule='N' and Class='N'
		and tier is not null
) a
group by Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,Tier


insert into dbo.KPI_Frame_MarketAnalyzer_BMSBrandvsGenericBrand ( TimeFrame,MoneyType,Molecule,Class,mkt,Mktname,Market,
	prod,Series,DataType,Category,Y,X,X_Idx,Series_Idx
	)
select 'MTH' as TimeFrame,a.MoneyType,a.Molecule,a.Class,a.mkt,a.Mktname,a.Market, 
	convert(varchar(200),null) as Prod,'vs. RunZ' as Series,
	convert(varchar(50),null) as DataType, convert(varchar(20),null) as Category,
	convert(decimal(20,8),case when c.mth00 is null or c.mth00=0 then 0 else 1.0*a.mth00/c.mth00-1.0*b.mth00/c.mth00 end) as Y,a.Audi_des as X, convert(int,null) as X_Idx, 1 as Series_Idx
from (
	select Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,Audi_Cod,Audi_des, MTH00   
	from  dbo.TempBMSBrandvsGenericBrand
    where Mkt='ARV' and Productname in ('Baraclude') and MoneyType='UN' and Molecule='N' and class='N'
  ) a join  (
	select Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,Audi_Cod,Audi_des, MTH00   
	from  dbo.TempBMSBrandvsGenericBrand
    where Mkt='ARV' and Productname in ('RUN ZHONG') and MoneyType='UN' and Molecule='N' and class='N'
  ) b  on a.Molecule=b.Molecule and a.Class=b.Class and a.Mkt=b.Mkt and a.Mktname=b.mktname and a.market=b.market 
	and a.MoneyType=b.MoneyType and a.Audi_cod=b.Audi_cod and a.Audi_des=b.Audi_des 
	  join  (
	select Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,Audi_Cod,Audi_des, MTH00   
	from  dbo.TempBMSBrandvsGenericBrand
    where Mkt='ARV' and Prod='000' and MoneyType='UN' and Molecule='N' and class='N'
  ) c on a.Molecule=c.Molecule and a.Class=c.Class and a.Mkt=c.Mkt and a.Mktname=c.mktname and a.market=c.market 
	and a.MoneyType=c.MoneyType and a.Audi_cod=c.Audi_cod and a.Audi_des=c.Audi_des 
/*
select a.X
from (
	select distinct X from KPI_Frame_MarketAnalyzer_BMSBrandvsGenericBrand 
) a left join dbo.[' BMSBrandvsRunZhong_City$'] b on a.X=b.City_Name
where b.City_name is null
*/	
GO

----HandleAfterDataOK
--if not exists(select 1 from   syscolumns   where   id=object_id(N'dbo.KPI_Frame_MarketAnalyzer_IMSAudit_CHPA')   and   name='Category_Idx')
--begin
--	alter table KPI_Frame_MarketAnalyzer_IMSAudit_CHPA add Category_Idx int
--end	

update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA
set Category_Idx = case when category='Value' then 1
						when category='Volume' then 2 end

update a 						
set a.x= convert(varchar(5),b.year)+left(b.MonthEN,3)
from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA a join tblMonthList b on convert(int,right(a.x,2))+1=b.MonSeq
where a.DataType='Share'

USE [BMSChinaCIA_IMS]
GO
IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'[KPI_Frame_MarketAnalyzer_PRDLProvince_For_Byetta]') and type='U')
BEGIN
	DROP TABLE [KPI_Frame_MarketAnalyzer_PRDLProvince_For_Byetta]
END
CREATE TABLE [dbo].[KPI_Frame_MarketAnalyzer_PRDLProvince_For_Byetta](
	[TimeFrame] [varchar](5) NULL,
	[MoneyType] [varchar](50) NOT NULL,
	[Molecule] [varchar](2) NOT NULL,
	[Class] [varchar](2) NOT NULL,
	[Mkt] [varchar](50) NULL,
	[Mktname] [varchar](50) NULL,
	[Market] [varchar](50) NULL,
	[Prod] [varchar](200) NULL,
	[Series] [varchar](200) NULL,
	[DataType] [varchar](50) NULL,
	[Category] [varchar](20) NULL,
	[Y] [decimal](20, 8) NULL,
	[X] [varchar](200) NULL,
	[Series_Idx] [int] NOT NULL,
	[X_Idx] [bigint] NULL
) ON [PRIMARY]

GO


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'TempPRDLProvince') and type='U')
BEGIN
	DROP TABLE TempPRDLProvince
END
--go
--select cast('PRDL' as varchar(10)) as DataSource,'MTH' as [TimeFrame] ,Moneytype,[Molecule],[Class],mkt,[Mktname],[Market],[Prod],ProductName as Series,cast('Sales' as Varchar(20)) as DataType,cast('Value' as varchar(20)) as Category, 1 as [Series_Idx],
--sum(MTH00) as MTH00,
--sum(MTH01) as MTH01,
--sum(MTH02) as MTH02,
--sum(MTH03) as MTH03,
--sum(MTH04) as MTH04,
--sum(MTH05) as MTH05,
--sum(MTH06) as MTH06,
--sum(MTH07) as MTH07,
--sum(MTH08) as MTH08,
--sum(MTH09) as MTH09,
--sum(MTH10) as MTH10,
--sum(MTH11) as MTH11
--into TempPRDLProvince 
--from dbo.TempCityDashboard 
--where ProductName in ('Byetta') and Molecule='N' and class='N' and Mkt='NIAD'
--and Moneytype='US' and Audi_des in
--	(select City_En from dbo.PRDL_Province_City_Mapping)
--group by Moneytype,[Molecule],[Class],mkt,[Mktname],[Market],[Prod],ProductName

select cast('PRDL' as varchar(10)) as DataSource,'MTH' as [TimeFrame],cast('US' as varchar(5)) as MoneyType,
'N' as molecule,'N' as Class,'NIAD' as Mkt,'NIAD Market' as MktName,'Glucophage' as market,convert(varchar(5),'300') as Prod,
convert(varchar(30),'Byetta') as Series,cast('Sales' as Varchar(20)) as DataType,cast('Value' as varchar(20)) as Category, 
1 as [Series_Idx],
sum(MTH00US) as MTH00,
sum(MTH01US) as MTH01,
sum(MTH02US) as MTH02,
sum(MTH03US) as MTH03,
sum(MTH04US) as MTH04,
sum(MTH05US) as MTH05,
sum(MTH06US) as MTH06,
sum(MTH07US) as MTH07,
sum(MTH08US) as MTH08,
sum(MTH09US) as MTH09,
sum(MTH10US) as MTH10,
sum(MTH11US) as MTH11
into TempPRDLProvince 
from mthCity_pkau 
where pack_cod in( 
	select distinct pack_cod from tblMktDef_MRBIChina where Prod_Name in ('Byetta') and Molecule='N' and class='N'
	and Mkt='NIAD') and CITY_ID in
	(select CITY_ID from dbo.Dim_City where City_Name in
	(select City_En from dbo.PRDL_Province_City_Mapping))
go
insert into TempPRDLProvince
select 'PRDL','MTH','US' as MoneyType,'N','N','NIAD','NIAD Market','Glucophage','800','Victoza','Sales','Value',2 ,
sum(MTH00US) as MTH00,
sum(MTH01US) as MTH01,
sum(MTH02US) as MTH02,
sum(MTH03US) as MTH03,
sum(MTH04US) as MTH04,
sum(MTH05US) as MTH05,
sum(MTH06US) as MTH06,
sum(MTH07US) as MTH07,
sum(MTH08US) as MTH08,
sum(MTH09US) as MTH09,
sum(MTH10US) as MTH10,
sum(MTH11US) as MTH11
from mthCity_pkau 
where pack_cod in( 
	select pack_cod from tblMktDef_MRBIChina where Prod_Name in ('Victoza') and Molecule='N' and class='N' and Prod='000'
	and Mkt='NIAD') and CITY_ID in
	(select CITY_ID from dbo.Dim_City where City_Name in
	(select City_En from dbo.PRDL_Province_City_Mapping))
go

--insert into TempPRDLProvince
--select 'National', 'MTH' as [TimeFrame] ,Moneytype,[Molecule],[Class],mkt,[Mktname],[Market],[Prod],ProductName as Series,'Sales' as DataType,'Value' as Category, 1 as [Series_Idx],
--sum(MTH00) as MTH00,
--sum(MTH01) as MTH01,
--sum(MTH02) as MTH02,
--sum(MTH03) as MTH03,
--sum(MTH04) as MTH04,
--sum(MTH05) as MTH05,
--sum(MTH06) as MTH06,
--sum(MTH07) as MTH07,
--sum(MTH08) as MTH08,
--sum(MTH09) as MTH09,
--sum(MTH10) as MTH10,
--sum(MTH11) as MTH11
-- from TempCHPAPreReports where ProductName in ('Byetta')and Molecule='N' and class='N' and Mkt='NIAD'
--and Moneytype='US'
--group by Moneytype,[Molecule],[Class],mkt,[Mktname],[Market],[Prod],ProductName
insert into TempPRDLProvince
select 'National','MTH','US' as MoneyType,'N','N','NIAD','NIAD Market','Glucophage','300','Byetta','Sales','Value',1 ,
sum(MTH00US) as MTH00,
sum(MTH01US) as MTH01,
sum(MTH02US) as MTH02,
sum(MTH03US) as MTH03,
sum(MTH04US) as MTH04,
sum(MTH05US) as MTH05,
sum(MTH06US) as MTH06,
sum(MTH07US) as MTH07,
sum(MTH08US) as MTH08,
sum(MTH09US) as MTH09,
sum(MTH10US) as MTH10,
sum(MTH11US) as MTH11
from mthCHPA_pkau where pack_cod in( 
select distinct pack_cod from tblMktDef_MRBIChina where Prod_Name in ('Byetta') and Molecule='N' and class='N'
and Mkt='NIAD')
go

insert into TempPRDLProvince
select 'National','MTH','US' as MoneyType,'N','N','NIAD','NIAD Market','Glucophage','800','Victoza','Sales','Value',2 ,
sum(MTH00US) as MTH00,
sum(MTH01US) as MTH01,
sum(MTH02US) as MTH02,
sum(MTH03US) as MTH03,
sum(MTH04US) as MTH04,
sum(MTH05US) as MTH05,
sum(MTH06US) as MTH06,
sum(MTH07US) as MTH07,
sum(MTH08US) as MTH08,
sum(MTH09US) as MTH09,
sum(MTH10US) as MTH10,
sum(MTH11US) as MTH11
from mthCHPA_pkau where pack_cod in( 
select pack_cod from tblMktDef_MRBIChina where Prod_Name in ('Victoza') and Molecule='N' and class='N' and Prod='000'
and Mkt='NIAD')
go
insert into TempPRDLProvince
select A.DataSource, A.TimeFrame, A.Moneytype, A.Molecule, A.Class, A.mkt, A.Mktname, A.Market, A.Prod, A.Series, A.DataType, 'Contribution', A.Series_Idx,
case B.MTH00 when 0 then null else A.MTH00*1.0/B.MTH00 end as MTH00,
case B.MTH01 when 0 then null else A.MTH01*1.0/B.MTH01 end as MTH01,
case B.MTH02 when 0 then null else A.MTH02*1.0/B.MTH02 end as MTH02,
case B.MTH03 when 0 then null else A.MTH03*1.0/B.MTH03 end as MTH03,
case B.MTH04 when 0 then null else A.MTH04*1.0/B.MTH04 end as MTH04,
case B.MTH05 when 0 then null else A.MTH05*1.0/B.MTH05 end as MTH05,
case B.MTH06 when 0 then null else A.MTH06*1.0/B.MTH06 end as MTH06,
case B.MTH07 when 0 then null else A.MTH07*1.0/B.MTH07 end as MTH07,
case B.MTH08 when 0 then null else A.MTH08*1.0/B.MTH08 end as MTH08,
case B.MTH09 when 0 then null else A.MTH09*1.0/B.MTH09 end as MTH09,
case B.MTH10 when 0 then null else A.MTH10*1.0/B.MTH10 end as MTH10,
case B.MTH11 when 0 then null else A.MTH11*1.0/B.MTH11 end as MTH11
from TempPRDLProvince A inner join TempPRDLProvince B
on  A.series=B.Series
where A.DataSource='PRDL' and B.DataSource='National'
go
delete from TempPRDLProvince where DataSource='National'
go
--select * from TempPRDLProvince order by category,series_idx
go
print 'Create Output Table for Byetta'
go
truncate table [KPI_Frame_MarketAnalyzer_PRDLProvince_For_Byetta]
go
insert into [KPI_Frame_MarketAnalyzer_PRDLProvince_For_Byetta]
select Timeframe, MoneyType, Molecule, Class, mkt, mktname, market, prod, Series, DataType, Category, y, X, Series_idx,abs(convert(int,right(t.X,2)))+1 as X_Idx from
(select * from TempPRDLProvince) A
unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11)
 ) T
go
update [KPI_Frame_MarketAnalyzer_PRDLProvince_For_Byetta]
set X=B.MonthEn from [KPI_Frame_MarketAnalyzer_PRDLProvince_For_Byetta] A inner join tblMonthlist B
on A.X_Idx=B.Monseq
go
update [KPI_Frame_MarketAnalyzer_PRDLProvince_For_Byetta]
set X_Idx=abs(X_Idx-(select max(X_Idx)from [KPI_Frame_MarketAnalyzer_PRDLProvince_For_Byetta]))+1
--select  *from tblMonthlist
--select * from [KPI_Frame_MarketAnalyzer_PRDLProvince_For_Byetta]
go


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'[KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]') and type='U')
BEGIN
	DROP TABLE [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
END
select * into [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel] 
from [KPI_Frame_MarketAnalyzer_PRDLProvince_For_Byetta] where 1=2
go


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'TempRDPACAudic') and type='U')
BEGIN
	DROP TABLE TempRDPACAudic
END
go
declare @LCQuerter varchar(max)
declare @sql varchar(max)

set @sql=' '
select @LCQuerter=stuff((
select ',['+right(convert(varchar(10),year),2)+Quarter+'LC]'
from (select distinct year,quarter from tblMonthList where qtrseq<>0) a 
for xml path(''))
,1,1,'')

--set @LCQuerter=replace(@LCQuerter,',[14Q2LC]','')

set @sql='
select [Product Name] as ProductName,Y,X,left(X,2) as [Year],right(X,2) as MoneyType, 1 as ProdIdx
into TempRDPACAudic from
(select * from inHKAPI_New where [Product Name] in (''Glivec'',''Tasigna'',''Sprycel'',''SPYCEL'')) A
unpivot (
	Y for X in ( '+@LCQuerter+' ) 
 ) T
 '
 Exec( @sql)
go
update TempRDPACAudic 
set Y=Y/2 where ProductName='GLIVEC'
go
update TempRDPACAudic
set ProductName='GLIVEC-CML' where ProductName='GLIVEC'
go
update TempRDPACAudic
set ProdIdx=case ProductName when 'GLIVEC-CML' then 1 when 'Tasigna' then '2' else 3 end
--select * from TempRDPACAudic
go


print 'Create Output table for RDPAC Audit'
go
truncate table [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
go
insert into [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
(Timeframe, MoneyType, Molecule, Class, mkt, mktname, market, prod, Series, DataType, Category, y, X, Series_idx, X_Idx)
select 'Year',Moneytype,'N','N','SPRYCEL','SPRYCEL Market','SPRYCEL',ProdIdx+'00',ProductName,'Sales','Value',sum(Y)*1000 as Y,[Year],ProdIdx,cast([year] as int)
from TempRDPACAudic where [year]>='08'
group by Moneytype,ProductName,[Year],ProdIdx
go
insert into [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
(Timeframe, MoneyType, Molecule, Class, mkt, mktname, market, prod, Series, DataType, Category, y, X, Series_idx, X_Idx)
select 'SoQtr',Moneytype,'N','N','SPRYCEL','SPRYCEL Market','SPRYCEL',ProdIdx+'00',ProductName,'Sales','Value',sum(Y)*1000 as Y,X,ProdIdx,cast([year]+left(right(X,3),1) as int)
from TempRDPACAudic where [year]>='12'
group by Moneytype,ProductName,X,[Year],ProdIdx
go
insert into [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
(Timeframe, MoneyType, Molecule, Class, mkt, mktname, market, prod, Series, DataType, Category, y, X, Series_idx, X_Idx)
select 'EaQtr',Moneytype,'N','N','SPRYCEL','SPRYCEL Market','SPRYCEL',ProdIdx+'00',ProductName,'Sales','Value',sum(Y)*1000 as Y,X,ProdIdx,cast([year]+left(right(X,3),1) as int)
from TempRDPACAudic A
where exists(select * from (select ProductName,min(X) as MinX  from TempRDPACAudic
where Y<>0
group by Productname) B where A.ProductName=B.ProductName and A.X>=B.MinX) and ProductName in ('Tasigna','Sprycel')
group by Moneytype,ProductName,X,[Year],ProdIdx
go
update [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
set X=replace(X,'LC','')
update [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
set X='20'+X where len(X)<=2
go
update [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
set series=A.series+' (Start from 20' +left(B.StartQtr,2)+''''+right(B.StartQtr,2)+')' 
from [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel] A inner join 
		(select timeframe,series,min(X) as StartQtr from [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
		where timeframe='EaQtr'
		group by timeframe,series) B
on A.series=b.series and a.timeframe=b.timeframe
go
delete from [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel] 
where timeframe='EaQtr' and series like '%TASIGNA%'
 and X not in
(
	  select distinct a.x from(
		select x,row_number() over(order by x) row_num from [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
		where timeframe='EaQtr' and series like '%TASIGNA%'
	  ) a join (
			select x,row_number() over(order by x) row_num from [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel] 
			where timeframe='EaQtr' and series like '%Sprycel%'
	 ) b on a.row_num=b.row_num	
 )
go
update [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
set X='L+'+cast(B.Rank as varchar(3))+'Q'
from [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel] A inner join 
(select *,RANK() OVER (PARTITION BY  series order by X_idx) as RANK
from [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel] where timeframe='EaQtr') B
on A.timeFrame=B.timeFrame and A.X=B.X and A.series=B.series
go
--select * from [KPI_Frame_MarketAnalyzer_RDPACAudit_For_Sprycel]
 


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'[KPI_Frame_MarketAnalyzer_MktBrandGrowth]') and type='U')
BEGIN
	DROP TABLE [KPI_Frame_MarketAnalyzer_MktBrandGrowth]
END
select * into [KPI_Frame_MarketAnalyzer_MktBrandGrowth] 
from [KPI_Frame_MarketAnalyzer_PRDLProvince_For_Byetta] where 1=2
go

--Consumption BMS PRODUCT from FF reporting
go
IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'Temp') and type='U')
BEGIN
	DROP TABLE Temp
END
select *,cast(replace(date,'Mth','') as int) as Idx
into Temp from db36.BMSChinaCSR_Testing.dbo.OutputCIA
where ActualSales<>0
order by Market,Idx
go
IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'TempConsumptionBMSPRODUCT') and type='U')
BEGIN
	DROP TABLE TempConsumptionBMSPRODUCT
END
declare @cur_Idx int
select @cur_Idx=b.Idx
from tblMonthList a join Temp b on a.Date=b.YM
where a.MonSeq=1

select A.*,A.Idx-@cur_Idx+1 as RealIdx
into TempConsumptionBMSPRODUCT from Temp A
go
-- End Consumption BMS PRODUCT from FF reporting

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'TempKPIFrameMktBrandGrowth') and type='U')
BEGIN
	DROP TABLE TempKPIFrameMktBrandGrowth
END
--Market Data
select 'MAT' as [TimeFrame] ,Moneytype,[Molecule],[Class],mkt,[Mktname],[Market],[Prod],ProductName as Series,
cast('Sales' as Varchar(20)) as DataType,cast('Growth' as varchar(20)) as Category, 1 as [Series_Idx],cast('IMS Market' as varchar(30)) as X,1 as X_Idx,
sum(MAT00) as MAT00,sum(MAT12) as MAT12
into TempKPIFrameMktBrandGrowth
from TempCHPAPreReports 
where Moneytype='US' and Prod='000' and
mkt in ('ARV','HYP','NIAD','ONCFCS') and Molecule='N' and Class='N'
group by Moneytype,[Molecule],[Class],mkt,[Mktname],[Market],[Prod],ProductName
go
insert into TempKPIFrameMktBrandGrowth(timeFrame,Moneytype,[Molecule],[Class],MktName,Series_Idx,X,X_Idx,MAT00,MAT12)
select 'MAT' as [TimeFrame] ,Moneytype,[Molecule],[Class],case when mkt='Cold' then 'OTC(Cold)' when mkt='MV' then  'OTC(MVs)' end as mktname,
 1 as [Series_Idx],cast('IMS Market' as varchar(30)) as X,1 as X_Idx,
sum(MAT00) as MAT00,sum(MAT12) as MAT12
from TempCHPAPreReports_For_OTC 
where Moneytype='US' and Prod='000' and
mkt in ('Cold','MV') and Molecule='N' and Class='N'
group by Moneytype,[Molecule],[Class],mkt,[Mktname],[Market],[Prod],ProductName

--insert into TempKPIFrameMktBrandGrowth(timeFrame,Moneytype,[Molecule],[Class],MktName,Series_Idx,X,X_Idx,MAT00,MAT12)
--select 'MAT','US','N','N',case ATC3_cod when 'A11A' then 'OTC(MVs)' else 'OTC(Cold)' end,1,'IMS Market',1,sum(MAT00US),sum(MAT12US)
-- from mthCHPA_pkau where ATC3_cod in('A11A','R05A')
--group by case ATC3_cod when 'A11A' then 'OTC(MVs)' else 'OTC(Cold)' end

go
insert into TempKPIFrameMktBrandGrowth
select 'MAT' as [TimeFrame] ,Moneytype,[Molecule],[Class],mkt,[Mktname],[Market],[Prod],ProductName as Series,
cast('Sales' as Varchar(20)) as DataType,cast('Growth' as varchar(20)) as Category, 1 as [Series_Idx],'IMS BMS Product' as X,2 as X_Idx,
sum(MAT00) as MAT00,sum(MAT12) as MAT12
from TempCHPAPreReports 
where Moneytype='US' and ProductName in ('Baraclude','Monopril','Glucophage','Taxol') and
mkt in ('ARV','HYP','NIAD','ONCFCS') and Molecule='N' and Class='N'
group by Moneytype,[Molecule],[Class],mkt,[Mktname],[Market],[Prod],ProductName
go

insert into TempKPIFrameMktBrandGrowth(timeFrame,Moneytype,[Molecule],[Class],MktName,Series_Idx,X,X_Idx,MAT00,MAT12)
select 'MAT','US','N','N',case ATC3_cod when 'A11A' then 'OTC(MVs)' else 'OTC(Cold)' end,1,'IMS BMS Product',2,sum(MAT00US),sum(MAT12US)
from mthCHPA_pkau A left join dbo.Dim_Product B
on A.Prod_cod=B.Product_Code where ATC3_cod in('A11A','R05A')
and B.Product_Name in ('GOLD THERAGRAN','BUFFERIN COLD')
--    and corp_cod in(select Corporation_ID from dbo.Dim_Manufacturer where Manufacturer_Abbr like '%BSG%' )
group by case ATC3_cod when 'A11A' then 'OTC(MVs)' else 'OTC(Cold)' end
go

insert into TempKPIFrameMktBrandGrowth(timeFrame,Moneytype,[Molecule],[Class],MktName,series,Series_Idx,X,X_Idx,MAT00,MAT12)
select 'MAT','US','N','N','Total','Total',1,'IMS Market',1,sum(MAT00US),sum(MAT12US)
from mthCHPA_pkau
go
insert into TempKPIFrameMktBrandGrowth(timeFrame,Moneytype,[Molecule],[Class],MktName,series,Series_Idx,X,X_Idx,MAT00,MAT12)
select 'MAT','US','N','N','Total','Total',1,'IMS BMS Product',2,sum(MAT00US),sum(MAT12US)
from mthCHPA_pkau 
where corp_cod in(select Corporation_ID from dbo.Dim_Manufacturer where Manufacturer_Abbr like '%BSG%' )

go
update TempKPIFrameMktBrandGrowth
set mkt=mktname,series=mktname where mkt is null
go

go
insert into TempKPIFrameMktBrandGrowth
(timeFrame,Moneytype,[Molecule],[Class],series,Series_Idx,X,X_Idx,MAT00,MAT12)
select 'MAT','US','N','N',A.Market,1,'Consumption BMS PRODUCT',3,MAT00,MAT12 from
	(select Market,sum(ActualSales) as MAT00 
	from TempConsumptionBMSPRODUCT 
	where RealIdx>=1 and RealIdx<=12
	Group By Market) A
inner join
		(select Market,sum(ActualSales) as MAT12 
		from TempConsumptionBMSPRODUCT 
		where RealIdx>12 and RealIdx<=24
		Group By Market) B
on A.Market=B.Market
go

update TempKPIFrameMktBrandGrowth
set series=case mkt when 'ARV' then 'Hep B Market'
when 'HYP' then 'Hypertension'
when 'NIAD' then 'OAD (Glucophage)'
when 'ONCFCS' then 'Oncology (Taxol)' else series end
go
update TempKPIFrameMktBrandGrowth
set series_idx=case series when 'Total' then 1
when 'Hep B Market' then 2
when 'Hypertension' then 3
when 'OAD (Glucophage)' then 4
when 'Oncology (Taxol)' then 5
when 'OTC(MVs)' then 6
when 'OTC(Cold)' then 7 end
go
Alter table TempKPIFrameMktBrandGrowth
Add Growth float
go
update TempKPIFrameMktBrandGrowth
set Growth=case MAT12 when 0 then 0 else (MAT00-MAT12)/MAT12 end
go

truncate table [KPI_Frame_MarketAnalyzer_MktBrandGrowth]
go
insert into [KPI_Frame_MarketAnalyzer_MktBrandGrowth]
(timeFrame,Moneytype,[Molecule],[Class],Series,Series_Idx,X,X_Idx,Y)
select 'MAT','US','N','N',Series,Series_Idx,X,X_Idx,Growth from TempKPIFrameMktBrandGrowth order by x_idx,series_idx
go

--select * from [KPI_Frame_MarketAnalyzer_MktBrandGrowth]
--select * from  TempKPIFrameMktBrandGrowth order by x_idx,series_idx

--select * from [KPI_Frame_MarketAnalyzer_MktBrandGrowth]
--select * from  TempKPIFrameMktBrandGrowth order by x_idx,series_idx
--select distinct market from KPI_Frame_MarketAnalyzer_PRDLProvince_For_Byetta
update KPI_Frame_MarketAnalyzer_PRDLProvince_For_Byetta
set market='Byetta'

update dbo.KPI_Frame_MarketAnalyzer_GenericsTrend 
set Y=Y*100
--select *,Y*100 from KPI_Frame_MarketAnalyzer_GenericsTrend 
where Series in ('Baraclude MS(%)','BR Of Total ETV(%)','Run zhong MS(%)')




update a
set X_idx=
case when a.X ='China' then 1
	 when a.x='Guangdong' then 1000
	 when a.X like 'Tier 1%' then 100
	 when a.X like 'Tier 2%' then 200
	 when a.X like 'Tier 3%' then 300
	 when a.X like 'Tier 4%' then 400
	 when b.Tier=1 then 100+b.city_Rank 
	 when b.Tier=2 then 200+b.city_Rank
	 when b.Tier=3 then 300+b.city_Rank
	 when b.Tier=4 then 400+b.city_Rank end 
from dbo.KPI_Frame_MarketAnalyzer_BMSBrandvsGenericBrand a left join 
(
	select t.*,  row_number() over(partition by Tier order by Audi_des) as city_Rank
	from (
		select distinct Audi_des, case when Audi_des='Nanning' then 3 else Tier end as Tier
		from  dbo.tempCityDashboard_AllCity
		where Mkt='ARV' and Productname in ('Baraclude') and MoneyType='UN' and Molecule='N' and class='N'
	) t		
) b on a.X=b.Audi_des

update  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities
set Series_Idx=3
where Series like '% Sales'


 update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA
 set Series_Idx =	
	case when DataType='Growth' and Series='Total Market' then 1
	     when DataType='Growth' and Series='Baraclude' then 2
	     when DataType='Growth' and Series='Heptodin' then 3
	     when DataType='Growth' and Series='Sebivo' then 4
	     when DataType='Growth' and Series='Hepsera' then 5
	     when DataType='Growth' and Series='Run Zhong' then 6
	     when DataType='Growth' and Series='Total ETV' then 7
	     when DataType='Growth' and Series='Total ADV' then 8
	     when DataType='Share' and Series='ARV Market' then 1
	     when DataType='Share' and Series='Baraclude' then 2
	     when DataType='Share' and Series='Entecavir Run Zhong' then 3
	     when DataType='Share' and Series='Hepsera' then 4
	     when DataType='Share' and Series='Heptodin' then 5
	     when DataType='Share' and Series='Sebivo' then 6
	     when DataType='Share' and Series='Total ETV' then 7
	     when DataType='Share' and Series='Other ETV Total' then 8
	     when DataType='Share' and Series='Total ADV' then 9 end
 where market='baraclude'
go

