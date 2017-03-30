
--time 
--exec dbo.sp_Log_Event 'KPI Frame_1','CIA IMS','Market_Analyzer数据提取_new.sql','Start',null,null

USE [BMSChinaCIA_IMS]
GO

if object_id (N'TempCHPAPreReports_For_CV_Focus_City',N'U') is not null
	drop table TempCHPAPreReports_For_CV_Focus_City
	
select --a.City_Code,a.City_Name,a.City_Name_CH 
	c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype,'FocusCity' as Audi_des,
	sum(MTH00) AS MTH00, sum(MTH01) as MTH01,sum(MTH02) as MTH02,sum(MTH03) as MTH03,sum(MTH04) as MTH04,sum(MTH05) as MTH05,
	sum(MTH06) AS MTH06, sum(MTH07) as MTH07,sum(MTH08) as MTH08,sum(MTH09) as MTH09,sum(MTH10) as MTH10,sum(MTH11) as MTH11, sum(MTH12) as MTH12,
	sum(YTD00) as YTD00,sum(YTD12) as YTD12
into TempCHPAPreReports_For_CV_Focus_City
from dim_city a join inCV_Focus_City b 
on a.city_name_ch=b.city_cn
join TempCityDashboard_AllCity c on a.city_code+'_'=c.Audi_Cod and c.market=b.product
group by c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype

print '
		------------------------------------------
			Coniel Middle Table Creating
		------------------------------------------
'

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
  ,1
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
  ,1
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
		when a.Prod_Des='PLENDIL' and Manu_cod='AZM' then '700'
		else '940'
        end   as [Prod]         
  ,
  case when a.Prod_Des='Coniel' and Manu_cod='KHK' then prod_des
		when a.Prod_Des='YUAN ZHI' and Manu_cod='S3D' then prod_des
		when a.Prod_Des='LACIPIL' and Manu_cod='GSK' then prod_des
		when a.Prod_Des='ZANIDIP' and Manu_cod='REC' then prod_des
		when a.Prod_Des='NORVASC' and Manu_cod='PZD' then prod_des
		when a.Prod_Des='ADALAT' and Manu_cod='BY6' then prod_des
		when a.Prod_Des='PLENDIL' and Manu_cod='AZM' then prod_des
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
  ,1
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
		from MTHCITY_PKAU A inner join tblMktDef_MRBIChina_For_CCB B
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
		while (@i<=48)--
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
if object_id (N'TempFocusCityReports_For_CCB',N'U') is not null
	drop table  TempFocusCityReports_For_CCB

select --a.City_Code,a.City_Name,a.City_Name_CH 
c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype,'FocusCity' as Audi_des,
sum(MTH00) AS MTH00, sum(MTH01) as MTH01,sum(MTH02) as MTH02,sum(MTH03) as MTH03,sum(MTH04) as MTH04,sum(MTH05) as MTH05,
sum(MTH06) AS MTH06, sum(MTH07) as MTH07,sum(MTH08) as MTH08,sum(MTH09) as MTH09,sum(MTH10) as MTH10,sum(MTH11) as MTH11, sum(MTH12) as MTH12,
sum(YTD00) as YTD00,sum(YTD12) as YTD12,sum(MAT00) AS MAT00,sum(MAT12) AS MAT12,sum(r3m00) as r3m00, sum(r3m03) as r3m03,sum(r3m12) as r3m12
into TempFocusCityReports_For_CCB
from dim_city a join inCV_Focus_City b 
on a.city_name_ch=b.city_cn
join TempcityDashboard_For_CCB c on a.city_code+'_'=c.Audi_Cod and c.market=b.product
group by c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype

insert into TempFocusCityReports_For_CCB (Molecule,class,Mkt,MktName,Market,prod,productname,moneytype,Audi_des,
	MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12,YTD00,YTD12,MAT00,MAT12,r3m00,r3m03,r3m12)
select Molecule,class,Mkt,MktName,Market,'101' as prod,'Coniel-CHPA'productname,moneytype,'Nation' as Audi_des,
MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12,YTD00,YTD12,MAT00,MAT12,r3m00,r3m03,r3m12
from 	TempCHPAPreReports_For_CCB where prod='100'

insert into TempFocusCityReports_For_CCB (Molecule,class,Mkt,MktName,Market,prod,productname,moneytype,Audi_des,
	MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12,YTD00,YTD12,MAT00,MAT12,r3m00,r3m03,r3m12)
select Molecule,class,Mkt,MktName,Market,prod,productname,moneytype,'Nation' as Audi_des,
MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12,YTD00,YTD12,MAT00,MAT12,r3m00,r3m03,r3m12
from 	TempCHPAPreReports_For_CCB where prod='000' and molecule='N' and class='N'


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
-- where prod_des in ('Fraxiparine','Clexane','Xarelto','Arixtra','Eliquis','Pradaxa')
where Mole_cod in ('406260','408800','408827','413885','703259','704307','710047','711981','719372', '904100') 
		and Prod_cod <> '14146' -- 去掉复方产品
go

--eliquis noac mkt define
if OBJECT_ID(N'tblMktDef_Inline_For_Eliquis_noac',N'U') is not null
	drop table tblMktDef_Inline_For_Eliquis_noac
go
select * into tblMktDef_Inline_For_Eliquis_noac from tblMktDef_Inline where 1=2

insert into tblMktDef_Inline_For_Eliquis_noac
select cast('ELIQUIS' as varchar(50)) as Mkt,cast('Eliquis Market' as varchar(50)) as MktName,* 
from tblMktDef_ATCDriver
where prod_des in ('Eliquis','XARELTO','PRADAXA')
go
--end
if OBJECT_ID(N'tblMktDef_MRBIChina_For_Eliquis',N'U') is not null
	drop table tblMktDef_MRBIChina_For_Eliquis
go
select * into tblMktDef_MRBIChina_For_Eliquis from tblMktDef_MRBIChina where 1=2

insert into tblMktDef_MRBIChina_For_Eliquis
SELECT distinct 
  'Eliquis' Mkt,'Eliquis Market' MktName
  ,'000' as Prod,'VTEp Market' as ProductName
  ,'N' as Molecule
  ,'N' as Class
  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
  ,pack_cod, Pack_des
  ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
  ,Mole_cod
  ,Mole_des as Mole_Name
  ,Corp_cod
  ,Manu_Cod
  ,Gene_Cod
  ,'Y' as Active
  ,GetDate() as Date, '201404 add new products & packages' as Comment
  ,1
FROM tblMktDef_Inline_For_Eliquis A WHERE A.MKT = 'Eliquis' and prod_des <>'Pradaxa'

insert into tblMktDef_MRBIChina_For_Eliquis
SELECT distinct 
   'Eliquis' as Mkt
  ,'Eliquis Market' as MktName
  ,case when a.Prod_Des='ELIQUIS' then '100'   
        when a.Prod_Des='CLEXANE' then '200'     
        when a.Prod_Des='XARELTO' then '300'        
        when a.Prod_Des='FRAXIPARINE' then '400'      
        when a.Prod_Des='ARIXTRA' then '500' 
        when a.Prod_Des='Pradaxa' then '600'
		else Prod_cod
        end   as [Prod]         
  ,a.Prod_Des as ProductName
  ,'N'        as Molecule
  ,'N'        as Class 
  ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
  ,pack_cod, Pack_des
  ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
  ,Mole_cod
  ,Mole_des as Mole_Name
  ,Corp_cod
  ,Manu_Cod
  ,Gene_Cod
  ,'Y'       as Active
  ,GetDate() as Date, '201404 add new products & packages'  -- select * 
  ,1
FROM tblMktDef_Inline_For_Eliquis A 
WHERE A.MKT = 'Eliquis' 

--alter table tblMktDef_MRBIChina_For_Eliquis add  Rat float
go
update tblMktDef_MRBIChina_For_Eliquis
-- set Rat = case when Prod_Name='Fraxiparine' then 0.2070
-- 					 when Prod_Name='Clexane' then 0.1590
-- 					 when Prod_Name='Xarelto' then 0.60
-- 					 when Prod_Name='Arixtra' then 0.05
-- 					 when Prod_Name='Eliquis' then 1.0 end
set Rat = case 
				-- when Mole_cod='239900' then 0.01  --WARFARIN
				when Mole_cod='406260' then 0.03 --ENOXAPARIN SODIUM 
				when Mole_cod='408800' then 0.01 --HEPARIN
				when Mole_cod='408827' then 0.02 --DALTEPARIN SODIUM
				when Mole_cod='413885' then 0.01 --LOW MOLECULAR WEIGHT HEPARIN
				when Mole_cod='703259' then 0.01 --FONDAPARINUX SODIUM
				when Mole_cod='704307' then 0.01 --NADROPARIN CALCIUM
			--  when Mole_cod='710047' then 0.03 --DABIGATRAN ETEXILATE
				when Mole_cod='711981' then 0.36 --RIVAROXABAN
				when Mole_cod='719372' then 1.0 --APIXABAN
				when Mole_cod='904100' then 0.01  --LOW MOLECULAR WEIGHT HEPARIN CALCIUM
			end

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
		while (@i<=48)--
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
        on A.pack_cod=B.pack_cod where B.Active=''Y'' and b.prod<>''000'' and b.ProductName <>''Pradaxa''
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
set Market=	
	case Market when 'ONC' then 'Taxol' 
				when 'HYP' then 'Monopril'
				when 'NIAD' then 'Glucophage'
				when 'ACE' then 'Monopril'
				when 'DIA' then 'Glucophage'
				when 'ONCFCS' then 'Taxol'
				when 'HBV' then 'Baraclude'
				when 'ARV' then 'Baraclude' 
				when 'DPP4' then 'Onglyza' 
				when 'CML' then 'Sprycel' 
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
while (@i<=48)--
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
		select Molecule,Class,mkt,mktname,Market,''000'',''VTEp Market'',MoneyType,'+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
		from TempCHPAPreReports_For_Eliquis
		group by Molecule,Class,mkt,mktname,Market,MoneyType			
	'
print @sql	
exec (@sql)

--CHPA for eliquis VTEp end

if object_id(N'TempCityDashboard_For_Eliquis',N'U') is not null
	drop table TempCityDashboard_For_Eliquis 
go
select * into TempCityDashboard_For_Eliquis from TempCityDashboard WHERE 1=0
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
			set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*RAT as R3M'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end

        set @i=0    
--		while (@i<=59)
        while (@i<=48)
		begin
			set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*RAT as MTH'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
			set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*RAT as MAT'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
--		while (@i<=60)
		while (@i<=48)
		begin
			set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*RAT as YTD'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
        set @sqlQtr=''
		while (@i<=19)
		begin
			set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*RAT as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
        set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		exec('insert into TempCityDashboard_For_Eliquis 
        select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,'+'''' +@MoneyType+''''+' as Moneytype, A.audi_cod,'''',''City'',null,'
			+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
		from MTHCITY_PKAU A inner join tblMktDef_MRBIChina_For_Eliquis B
        on A.pack_cod=B.pack_cod where B.Active=''Y'' and  b.prod<>''000'' and b.ProductName <>''Pradaxa''
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname,A.audi_cod,B.RAT')
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go

declare @i int,@sql varchar(8000),@sql1 varchar(8000),@sql3 varchar(8000),@sqlMAT varchar(2000),@sqlYTD varchar(2000),@sqlQtr varchar(2000)
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(8000)
	set @i=0
	set @sql1=''
    set @sql3=''
--		while (@i<=57)
    while (@i<=45)
	begin
	set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
	set @i=@i+1
	end

    set @i=0    
--		while (@i<=59)
    while (@i<=48)
	begin
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
--		while (@i<=60)
while (@i<=48)
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
	--print @sql1

	exec('insert into TempCityDashboard_For_Eliquis 		
    select  Molecule,Class,mkt,mktname,market,''000'',''VTEp Market'',moneyType,audi_cod,audi_des,lev,tier,'+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
	from TempCityDashboard_For_Eliquis
	group by Molecule,Class,mkt,mktname,market,moneyType,audi_cod,audi_des,lev,tier')
go

update TempCityDashboard_For_Eliquis
set AUDI_des=City_Name from TempCityDashboard_For_Eliquis A inner join dbo.Dim_City B
on A.AUDI_cod=B.City_Code+'_'
go

update TempCityDashboard_For_Eliquis
set Market=case  
when Market in ('HYP','ACE') then 'Monopril'
when Market in ('NIAD','DIA') then 'Glucophage'
when Market in ('ONC','ONCFCS') then 'Taxol' 
when Market in ('HBV','ARV') then 'Baraclude'
when Market in ('DPP4') then 'Onglyza' 
when Market in ('CML') then 'Sprycel' 
when Market in ('Platinum') then 'Paraplatin'
when Market in ('CCB') then 'Coniel'
else Market end
go

insert into TempCityDashboard_For_Eliquis (Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
	Audi_cod,audi_des,lev)
select  Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
	Audi_cod,audi_des,lev 
from (
	select A.*,Audi_cod,audi_des,lev 
	from  (select distinct Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype from TempCityDashboard_For_Eliquis) A
	inner join
	(select distinct  Molecule,Class,mkt,mktname,Market,Moneytype,Audi_cod,audi_des,lev from TempCityDashboard_For_Eliquis) B
	on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
		and a.Moneytype=b.Moneytype) A 
	where not exists(
			select * from TempCityDashboard_For_Eliquis B
			where a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
				and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and a.Prod=B.Prod)
go
update TempCityDashboard_For_Eliquis
set Tier=B.Tier from TempCityDashboard_For_Eliquis A inner join Dim_City B
on A.Audi_cod=B.CIty_Code+'_'
go



if object_id (N'TempFocusCityReports_For_Eliquis',N'U') is not null
	drop table  TempFocusCityReports_For_Eliquis

select --a.City_Code,a.City_Name,a.City_Name_CH 
	c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype,'FocusCity' as Audi_des,
	sum(MTH00) AS MTH00, sum(MTH01) as MTH01,sum(MTH02) as MTH02,sum(MTH03) as MTH03,sum(MTH04) as MTH04,sum(MTH05) as MTH05,
	sum(MTH06) AS MTH06, sum(MTH07) as MTH07,sum(MTH08) as MTH08,sum(MTH09) as MTH09,sum(MTH10) as MTH10,sum(MTH11) as MTH11, sum(MTH12) as MTH12,
	sum(YTD00) as YTD00,sum(YTD12) as YTD12,sum(MAT00) AS MAT00,sum(MAT12) AS MAT12,sum(R3M00) AS R3M00,sum(R3M03) AS R3M03,sum(r3m12) as r3m12
into TempFocusCityReports_For_Eliquis
from dim_city a join inCV_Focus_City b 
on a.city_name_ch=b.city_cn
join TempCityDashboard_For_Eliquis c on a.city_code+'_'=c.Audi_Cod and c.market=b.product
group by c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype

--alince added for update focus city to CHPA
if object_id (N'KPI_Frame_TempCHPAReports_For_Eliquis',N'U') is not null
	drop table  KPI_Frame_TempCHPAReports_For_Eliquis

select --a.City_Code,a.City_Name,a.City_Name_CH 
	c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype,'CHPA' as Audi_des,
	sum(MTH00) AS MTH00, sum(MTH01) as MTH01,sum(MTH02) as MTH02,sum(MTH03) as MTH03,sum(MTH04) as MTH04,sum(MTH05) as MTH05,
	sum(MTH06) AS MTH06, sum(MTH07) as MTH07,sum(MTH08) as MTH08,sum(MTH09) as MTH09,sum(MTH10) as MTH10,sum(MTH11) as MTH11, sum(MTH12) as MTH12,
	sum(YTD00) as YTD00,sum(YTD12) as YTD12,sum(MAT00) AS MAT00,sum(MAT12) AS MAT12,sum(R3M00) AS R3M00,sum(R3M03) AS R3M03,sum(r3m12) as r3m12
into KPI_Frame_TempCHPAReports_For_Eliquis
from TempCHPAPreReports_For_Eliquis c
group by c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype


--insert into TempFocusCityReports_For_Eliquis (Molecule,class,Mkt,MktName,Market,prod,productname,moneytype,Audi_des,
--	MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12,YTD00,YTD12,MAT00,MAT12,R3M00,R3M03,r3m12)
--select Molecule,class,Mkt,MktName,Market,'101' as prod,'Eliquis-CHPA'productname,moneytype,'Nation' as Audi_des,
--MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12,YTD00,YTD12,MAT00,MAT12,R3M00,R3M03,r3m12
--from 	TempCHPAPreReports_For_Eliquis where prod='100'



if object_id (N'TempFocusCityReports_For_Eliquis_KeyCity',N'U') is not null
	drop table  TempFocusCityReports_For_Eliquis_KeyCity

select --a.City_Code,a.City_Name,a.City_Name_CH 
	c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype,'FocusCity' as Audi_des,
	sum(MTH00) AS MTH00, sum(MTH01) as MTH01,sum(MTH02) as MTH02,sum(MTH03) as MTH03,sum(MTH04) as MTH04,sum(MTH05) as MTH05,
	sum(MTH06) AS MTH06, sum(MTH07) as MTH07,sum(MTH08) as MTH08,sum(MTH09) as MTH09,sum(MTH10) as MTH10,sum(MTH11) as MTH11, sum(MTH12) as MTH12,
	sum(YTD00) as YTD00,sum(YTD12) as YTD12,sum(MAT00) AS MAT00,sum(MAT12) AS MAT12,sum(R3M00) AS R3M00,sum(R3M03) AS R3M03,sum(r3m12) as r3m12
	into TempFocusCityReports_For_Eliquis_KeyCity
from dim_city a join inCV_Focus_City b 
on a.city_name_ch=b.city_cn
join TempCityDashboard_For_Eliquis c on a.city_code+'_'=c.Audi_Cod and c.market=b.product
group by c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype

insert into TempFocusCityReports_For_Eliquis_KeyCity (Molecule,class,Mkt,MktName,Market,prod,productname,moneytype,Audi_des,
	MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12,YTD00,YTD12,MAT00,MAT12,R3M00,R3M03,r3m12)
select Molecule,class,Mkt,MktName,Market, prod,productname,moneytype,'Nation' as Audi_des,
MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12,YTD00,YTD12,MAT00,MAT12,R3M00,R3M03,r3m12
from 	TempCHPAPreReports_For_Eliquis where prod='000' and molecule='N' and class='N'


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
  ,1
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
  ,1
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
  ,1
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
  ,1
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
		while (@i<=48)--
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

------------------------------------
--Baraclude
------------------------------------

if object_id(N'tblMktDef_MRBIChina_For_Baraclude',N'U') is not null
	drop table tblMktDef_MRBIChina_For_Baraclude
select *--, case when productName='Tenofovir Disoproxil' then 0.8 else 1 end as Rat
into tblMktDef_MRBIChina_For_Baraclude from tblMktDef_MRBIChina where mkt='arv'

update tblMktDef_MRBIChina_For_Baraclude
set rat=case when prod_name='VIREAD' then 1 else 1 end

if object_id(N'TempCHPAPreReports_For_Baraclude',N'U') is not null
	drop table TempCHPAPreReports_For_Baraclude
select * into TempCHPAPreReports_For_Baraclude from TempCHPAPreReports where 0=1


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
		set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)*Rat) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
		set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)*Rat) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
		set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)*Rat) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
		while (@i<=48)--
		begin
		set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)*Rat) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
		set @sqlQtr=''
		while (@i<=19)
		begin
		set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)*Rat) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		set @SQL2_1='insert into TempCHPAPreReports_For_Baraclude 
		select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,
--         A.MNFL_COD,B.Gene_cod,
        '+'''' +@MoneyType+''''+' as Moneytype, '+@sql1+', '+@sql3+', '
        set @SQL2_2=@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
		from mthCHPA_pkau A inner join tblMktDef_MRBIChina_For_Baraclude B
        on A.pack_cod=B.pack_cod where B.Active=''Y'' 
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname'
       print @SQL2_1+@SQL2_2
		exec( @SQL2_1+@SQL2_2)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR

update TempCHPAPreReports_For_Baraclude
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

delete 
from TempCHPAPreReports_For_Baraclude
where Market <> 'Paraplatin' and MoneyType = 'PN'
go

update tblExcelConfig
set ConfigValue= (select max(date) from tblMonthList)
where configkey='DataMonth'

update tblExcelConfig											--todo time config table update
set ConfigValue='Jan.17 vs. Jan.16'
where configkey in('Brandview__product_X','Brandview_X')

go
--KPI: IMS Audit - CHPA(both Volume and value)
IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_MarketAnalyzer_IMSAudit_CHPA') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MarketAnalyzer_IMSAudit_CHPA
END

go


--BaracludeValue
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,Series,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,case when prod='000' then convert(int,prod)+1 else convert(int,Prod)  end as Series_Idx,
	convert(varchar(20),'') as Lev
INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA
from (
	select convert(varchar(5),'MTH') as TimeFrame,B.Moneytype,A.Molecule,A.Class,B.Mkt,B.Mktname,B.Market,B.Prod,
		case when B.Productname = 'Adefovir Dipivoxil' then 'Total ADV'
			when B.Productname = 'Entecavir' then 'Total ETV'
			when B.ProductName ='Tenofovir Disoproxil' then 'Tenofovir'
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
		from TempCHPAPreReports_For_Baraclude A inner join TempCHPAPreReports_For_Baraclude B
		on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
		and A.Market=B.Market and A.prod='000' and B.prod<>'000'
		where ((B.class='N' and B.Molecule='N') or (b.molecule='Y' and b.class='N' and b.market='baraclude' and b.productname in ('Entecavir','Adefovir Dipivoxil','Tenofovir Disoproxil'))) and b.Moneytype IN ('US','UN') and b.Mktname in ('ARV Market') and b.productname not in ('ARV Others')
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
	from TempCHPAPreReports_For_Baraclude A 
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
      ,case when X='MAT Growth' then 1
		    when X='YTD Growth' then 2
			when X='MTH Growth' then 3
			when X='YTD00 Share' then 5
			when X='YTD12 Share' then 6
		    end as X_Idx      
      ,case when prod='000' then convert(int,prod)+1 else convert(int,Prod)  end as Series_Idx
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
		case --when A.Productname = 'Adefovir Dipivoxil' then 'Total ADV'
			when A.Productname = 'Entecavir' then 'Total ETV'
			when a.Productname = 'Tenofovir Disoproxil'  then 'Tenofovir'
			when A.Productname = 'Other Entecavir'	then 'Other ETV Total' else A.Productname end as Series,convert(varchar(50),'Growth') as DataType,
		case when a.MoneyType='US' then 'Value' 
			when a.MoneyType='UN' then 'Volume' end as Category,
		case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
		case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
		case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]
		from TempCHPAPreReports_For_Baraclude a
		where ((a.class='N' and a.Molecule='N') or (a.molecule='Y' and a.class='N' and a.market='baraclude' and a.productname in ('Entecavir','Adefovir Dipivoxil','Tenofovir Disoproxil'))) and a.Moneytype IN ('US','UN') and a.Mktname in ('ARV Market') and a.prod<>'000' 
		AND A.Productname not in ('Other Entecavir','ARV Others')
		group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
		union
		select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
		case when A.Productname = 'ARV Market' then 'Total Market' else A.Productname end as Series,convert(varchar(50),'Growth') as DataType,
		case when a.MoneyType='US' then 'Value' 
			when a.MoneyType='UN' then 'Volume' end as Category,
		case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
		case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
		case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]
	from TempCHPAPreReports_For_Baraclude a
	where a.class='N' and a.Molecule='N' and a.Moneytype IN ('US','UN') and a.Mktname in ('ARV Market') and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth],[MAT Growth],[YTD Growth],[YTD00 Share],[YTD12 Share])
)     t
GO
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
      ,case when X='MAT Growth' then 1
			when X='YTD Growth' then 2
		    when X='MTH Growth' then 3 
			when X='YTD00 Share' then 5
			when X='YTD12 Share' then 6
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
	--	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth(Y2Y)],
		case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
		case when sum(mth12) =0 or sum(mth12) is null then null else 1.0*(sum(mth00)-sum(mth12))/sum(mth12) end as [MTH Growth],
		case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]
		from TempCHPAPreReports_For_OTC a
		where a.molecule='N' and a.class='N'  and a.Moneytype IN ('US','UN') and a.mkt='Cold'
		and a.prod<>'000'  and a.productname not like '%others%'
		group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
		union
		select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
		A.Productname as Series,convert(varchar(50),'Growth') as DataType,
		case when a.MoneyType='US' then 'Value' 
			when a.MoneyType='UN' then 'Volume' end as Category,
	--	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth(Y2Y)],
		case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
		case when sum(mth12) =0 or sum(mth12) is null then null else 1.0*(sum(mth00)-sum(mth12))/sum(mth12) end as [MTH Growth],
		case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]
	from TempCHPAPreReports_For_OTC a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.mkt='Cold' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth],[MAT Growth],[YTD Growth],[YTD00 Share],[YTD12 Share])
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
      ,case when X='MAT Growth' then 1
			when X='YTD Growth' then 2
		    when X='MTH Growth' then 3 
		    when X='YTD00 Share' then 5
			when X='YTD12 Share' then 6
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
	--	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth(Y2Y)],
		case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
		case when sum(mth12) =0 or sum(mth12) is null then null else 1.0*(sum(mth00)-sum(mth12))/sum(mth12) end as [MTH Growth],
		case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]
		from TempCHPAPreReports_For_OTC a
		where a.molecule='N' and a.class='N'  and a.Moneytype IN ('US','UN') and a.mkt='MV'
		and a.prod<>'000'  and a.productname not like '%others%'
		group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
		union
		select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
		A.Productname as Series,convert(varchar(50),'Growth') as DataType,
		case when a.MoneyType='US' then 'Value' 
			when a.MoneyType='UN' then 'Volume' end as Category,
	--	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth(Y2Y)],
		case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
		case when sum(mth12) =0 or sum(mth12) is null then null else 1.0*(sum(mth00)-sum(mth12))/sum(mth12) end as [MTH Growth],
		case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]
	from TempCHPAPreReports_For_OTC a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.mkt='MV' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MAT Growth],[MTH Growth],[YTD Growth],[YTD00 Share],[YTD12 Share])
)     t

update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA
set y=null
where mkt='MV' and Y=10000

GO
--Eliquis Focus City Share
-- 20141209 add series PRADAXA,but 20141222 need delete series PRADAXA

INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],Lev)
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,Series,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='VTEp Market' then 1
	 when Series='FRAXIPARINE' then 2
	 when Series='CLEXANE' then 3
	 when Series='XARELTO' then 4 
	 when Series='ARIXTRA' then 5 
	 when Series='ELIQUIS' then 6
	 when Series='ELIQUIS-CHPA' then 6
	  --when Series='PRADAXA' then 7
	 end
 as Series_Idx,'FocusCity'  as Lev
from (
	select convert(varchar(5),'MTH') as TimeFrame,B.Moneytype,A.Molecule,A.Class,B.Mkt,B.Mktname,B.Market,B.Prod,
		b.ProductName as Series,convert(varchar(50) ,'Share') as DataType,
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
	from TempFocusCityReports_For_Eliquis A 
	inner join TempFocusCityReports_For_Eliquis B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and  a.Class=b.Class and a.Molecule=b.Molecule
		and A.Market=B.Market and A.prod='000' and B.prod not in ('000','101')
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
	from TempFocusCityReports_For_Eliquis A 
	where MoneyType IN ('US','UN') and a.prod='000' and molecule='N' and class='N' and a.mkt ='Eliquis'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T


--Eliquis Focus City Growth
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],Lev)
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] 
      ,case when X='MAT Growth' then 1
		    when X='YTD Growth' then 2
			when X='MTH Growth' then 3
			when X='YTD00 Share' then 5
			when X='YTD12 Share' then 6			
			end as X_Idx      
      ,case when Series='VTEp Market' then 1
	 when Series='FRAXIPARINE' then 2
	 when Series='CLEXANE' then 3
	 when Series='XARELTO' then 4 
	 when Series='ARIXTRA' then 5 
	 when Series='ELIQUIS' then 6
	 when Series='ELIQUIS-CHPA' then 6
	 --when Series='PRADAXA' then 7
	 end
 as Series_Idx,'FocusCity' as Lev
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
		A.ProductName as Series,convert(varchar(50),'Growth') as DataType,
		case when a.MoneyType='US' then 'Value' 
			when a.MoneyType='UN' then 'Volume' end as Category,
		case when sum(MTH12) =0 or sum(MTH12) is null then 10000 else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	--	case when sum(r3m03) =0 or sum(r3m03) is null then 10000 else 1.0*(sum(r3m00)-sum(r3m03))/sum(r3m03) end as [MQT Growth(vs. last quarter)],
		case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
		case when sum(ytd12) =0 or sum(ytd12) is null then 10000 else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]
		from TempFocusCityReports_For_Eliquis a
		where a.molecule='N' and a.class='N'  and a.Moneytype IN ('US','UN') and a.market='Eliquis' and a.mkt='Eliquis'
		and a.prod not in('000' ,'101')
		group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
		union
		select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
		A.Productname as Series,convert(varchar(50),'Growth') as DataType,
		case when a.MoneyType='US' then 'Value' 
			when a.MoneyType='UN' then 'Volume' end as Category,
		case when sum(MTH12) =0 or sum(MTH12) is null then 10000 else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
		--case when sum(r3m03) =0 or sum(r3m03) is null then 10000 else 1.0*(sum(r3m00)-sum(r3m03))/sum(r3m03) end as [MQT Growth(vs. last quarter)],
		case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
		case when sum(ytd12) =0 or sum(ytd12) is null then 10000 else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]
	from TempFocusCityReports_For_Eliquis a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.market='Eliquis' and a.mkt='Eliquis' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth],[MAT Growth],[YTD Growth],[YTD00 Share],[YTD12 Share])
)     t

GO
--Eliquis Nation Share
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],Lev)
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,Series,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='VTEp Market' then 1
	 when Series='FRAXIPARINE' then 2
	 when Series='CLEXANE' then 3
	 when Series='XARELTO' then 4 
	 when Series='ARIXTRA' then 5 
	 when Series='ELIQUIS' then 6
	 
	  --when Series='PRADAXA' then 7
	 end
 as Series_Idx ,'Nation' as Lev
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


--Eliquis Nation Growth
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],Lev)
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] 
      ,case when X='MAT Growth' then 1 
		    when X='YTD Growth' then 2
			when X='MTH Growth' then 3
			when X='YTD00 Share' then 5
			when X='YTD12 Share' then 6		
			end as X_Idx      
      ,case when Series='VTEp Market' then 1
	 when Series='FRAXIPARINE' then 2
	 when Series='CLEXANE' then 3
	 when Series='XARELTO' then 4 
	 when Series='ARIXTRA' then 5 
	 when Series='ELIQUIS' then 6	 
	 --when Series='PRADAXA' then 7
	 end
 as Series_Idx,'Nation' as Lev
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
		A.ProductName as Series,convert(varchar(50),'Growth') as DataType,
		case when a.MoneyType='US' then 'Value' 
			when a.MoneyType='UN' then 'Volume' end as Category,
		case when sum(MTH12) =0 or sum(MTH12) is null then 10000 else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	--	case when sum(r3m03) =0 or sum(r3m03) is null then 10000 else 1.0*(sum(r3m00)-sum(r3m03))/sum(r3m03) end as [MQT Growth(vs. last quarter)],
		case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
		case when sum(ytd12) =0 or sum(ytd12) is null then 10000 else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]
	from TempCHPAPreReports_For_Eliquis a
	where a.molecule='N' and a.class='N'  and a.Moneytype IN ('US','UN') and a.market='Eliquis' and a.mkt='Eliquis'
	and a.prod not in('000' ,'101')
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
	union
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
		A.Productname as Series,convert(varchar(50),'Growth') as DataType,
		case when a.MoneyType='US' then 'Value' 
			when a.MoneyType='UN' then 'Volume' end as Category,
		case when sum(MTH12) =0 or sum(MTH12) is null then 10000 else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	--	case when sum(r3m03) =0 or sum(r3m03) is null then 10000 else 1.0*(sum(r3m00)-sum(r3m03))/sum(r3m03) end as [MQT Growth(vs. last quarter)],
		case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
		case when sum(ytd12) =0 or sum(ytd12) is null then 10000 else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]
	from TempCHPAPreReports_For_Eliquis a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.market='Eliquis' and a.mkt='Eliquis' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MAT Growth],[MTH Growth],[YTD Growth],[YTD00 Share],[YTD12 Share])
)     t

GO

update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA
set y=null
where mkt='Eliquis' and Y=10000

GO

--Eliquis Focus City Share NOAC Market
-- 20151214 add series ELIQUIS,ELIQUIS,XARELTO

if OBJECT_ID(N'tblMktDef_MRBIChina_For_Eliquis_NOAC',N'U') is not null
	drop table tblMktDef_MRBIChina_For_Eliquis_NOAC
go
select * into tblMktDef_MRBIChina_For_Eliquis_NOAC from tblMktDef_MRBIChina where 1=2

insert into tblMktDef_MRBIChina_For_Eliquis_NOAC
SELECT distinct 
  'Eliquis' Mkt,'Eliquis Market' MktName
  ,'000' as Prod,'NOAC Market' as ProductName
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
  ,GetDate() as Date,null as comment
  ,1
FROM tblMktDef_Inline_For_Eliquis_NOAC A WHERE A.MKT = 'Eliquis'

insert into tblMktDef_MRBIChina_For_Eliquis_NOAC
SELECT distinct 
   'Eliquis' as Mkt
  ,'Eliquis Market' as MktName
  ,case when a.Prod_Des='ELIQUIS' then '100'   
        when a.Prod_Des='XARELTO' then '200'     
        when a.Prod_Des='PRADAXA' then '300'        
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
  ,1
FROM tblMktDef_Inline_For_Eliquis_NOAC A 
WHERE A.MKT = 'Eliquis' 

--alter table tblMktDef_MRBIChina_For_Eliquis_NOAC add  Rat float
go
-- update tblMktDef_MRBIChina_For_Eliquis_NOAC
-- set Rat = case when Prod_Name='Pradaxa' then 0.95
-- 					 when Prod_Name='Xarelto' then 0.296
-- 					 when Prod_Name='Eliquis' then 1.0 end

-- 20161107 noac need no rat
update tblMktDef_MRBIChina_For_Eliquis_NOAC
set Rat = case when Prod_Name='Pradaxa' then 1.0
					 when Prod_Name='Xarelto' then 1.0
					 when Prod_Name='Eliquis' then 1.0 end

go



--CHPA eliquis NOAC Middle table

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'TempCHPAPreReports_For_Eliquis_NOAC') AND TYPE ='U')
	DROP TABLE TempCHPAPreReports_For_Eliquis_NOAC

select * into TempCHPAPreReports_For_Eliquis_NOAC from TempCHPAPreReports where 1=2

declare @i int,@sql varchar(8000),@sql1 varchar(8000),@sql3 varchar(8000),@sqlMAT varchar(8000),@sqlYTD varchar(8000),@sqlQtr varchar(8000)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2_1 VARCHAR(max)
DECLARE @SQL2_2 VARCHAR(max)
declare @transfer varchar(100)		
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		set @transfer=''
		if @MoneyType='un'
		begin
			--   set @transfer='*isnull(c.dd,1)'		
			set @transfer='*1'		
		end
		set @i=0
		set @sql1=''
        set @sql3=''
		while (@i<=48)
		begin
			set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+@transfer+',0))*Rat as R3M'+right('00'+cast(@i as varchar(3)),2)+','
			set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+@transfer+',0))*Rat as MTH'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
			set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+@transfer+',0))*Rat as MAT'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
		while (@i<=48)--
		begin
			set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+@transfer+',0))*Rat as YTD'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
		set @sqlQtr=''
		while (@i<=19)
		begin
			set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+@transfer+',0))*Rat as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		set @SQL2_1='insert into TempCHPAPreReports_For_Eliquis_NOAC 
			select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,
	--         A.MNFL_COD,B.Gene_cod,
			'+'''' +@MoneyType+''''+' as Moneytype, '+@sql1+', '+@sql3+', '
        set @SQL2_2=@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
			from mthCHPA_pkau A inner join tblMktDef_MRBIChina_For_Eliquis_NOAC B
			on A.pack_cod=B.pack_cod 
			inner join inEliquis_NOAC_DOT_Transfer c
			on b.prod_name=c.product
			where B.Active=''Y'' and b.prod<>''000''
			group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname,B.Rat'
        print @SQL2_1+@SQL2_2
		exec( @SQL2_1+@SQL2_2)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
update TempCHPAPreReports_For_Eliquis_NOAC
set Market=
	case Market 
		when 'ONC' then 'Taxol' 
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
from TempCHPAPreReports_For_Eliquis_NOAC
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
while (@i<=48)--
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

set @sql ='insert into TempCHPAPreReports_For_Eliquis_NOAC 
		select Molecule,Class,mkt,mktname,Market,''000'',''NOAC Market'',MoneyType,'+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
		from TempCHPAPreReports_For_Eliquis_NOAC
		group by Molecule,Class,mkt,mktname,Market,MoneyType			
	'
print @sql	
exec (@sql)
--end
if object_id(N'TempCityDashboard_For_Eliquis',N'U') is not null
	drop table TempCityDashboard_For_Eliquis_NOAC
go
select * into TempCityDashboard_For_Eliquis_NOAC from TempCityDashboard WHERE 1=0
declare @i int,@sql varchar(8000),@sql1 varchar(8000),@sql3 varchar(8000),@sqlMAT varchar(8000),@sqlYTD varchar(8000),@sqlQtr varchar(4000)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(8000)
declare @transfer varchar(100)		
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		set @transfer=''
		if @MoneyType='un'
		begin
			--   set @transfer='*isnull(c.dd,1)'	--20161107 noac 不需要系数	
			  set @transfer='*1'		
		end
		set @i=0
		set @sql1=''
        set @sql3=''
--		while (@i<=57)
        while (@i<=45)
		begin
			set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+@transfer+',0))*RAT as R3M'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end

        set @i=0    
--		while (@i<=59)
        while (@i<=48)
		begin
			set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+@transfer+',0))*RAT as MTH'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
			set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+@transfer+',0))*RAT as MAT'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
--		while (@i<=60)
		while (@i<=48)
		begin
			set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+@transfer+',0))*RAT as YTD'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
        set @sqlQtr=''
		while (@i<=19)
		begin
			set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+@transfer+',0))*RAT as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
        set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		exec('insert into TempCityDashboard_For_Eliquis_NOAC 
        select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,'+'''' +@MoneyType+''''+' as Moneytype, A.audi_cod,'''',''City'',null,'
		+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
		from MTHCITY_PKAU A 
		inner join tblMktDef_MRBIChina_For_Eliquis_NOAC B
        on A.pack_cod=B.pack_cod 
		inner join inEliquis_NOAC_DOT_Transfer c
		on b.prod_name=c.product
		where B.Active=''Y'' and  b.prod<>''000'' and b.productname in(''ELIQUIS'',''PRADAXA'',''XARELTO'',''NOAC Market'')
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname,A.audi_cod,B.RAT')
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go

declare @i int,@sql varchar(8000),@sql1 varchar(8000),@sql3 varchar(8000),@sqlMAT varchar(2000),@sqlYTD varchar(2000),@sqlQtr varchar(2000)
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(8000)
	set @i=0
	set @sql1=''
    set @sql3=''
--		while (@i<=57)
    while (@i<=45)
	begin
		set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
	end

    set @i=0    
--		while (@i<=59)
    while (@i<=48)
	begin
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
--		while (@i<=60)
	while (@i<=48)
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
	--print @sql1

	exec('insert into TempCityDashboard_For_Eliquis_NOAC 		
    select  Molecule,Class,mkt,mktname,market,''000'',''NOAC Market'',moneyType,audi_cod,audi_des,lev,tier,'
	+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
	from TempCityDashboard_For_Eliquis_NOAC
	group by Molecule,Class,mkt,mktname,market,moneyType,audi_cod,audi_des,lev,tier')
go

update TempCityDashboard_For_Eliquis_NOAC
set AUDI_des=City_Name from TempCityDashboard_For_Eliquis_NOAC A 
inner join dbo.Dim_City B
on A.AUDI_cod=B.City_Code+'_'
go

update TempCityDashboard_For_Eliquis_NOAC
set Market=
	case when Market in ('HYP','ACE') then 'Monopril'
		when Market in ('NIAD','DIA') then 'Glucophage'
		when Market in ('ONC','ONCFCS') then 'Taxol' 
		when Market in ('HBV','ARV') then 'Baraclude'
		when Market in ('DPP4') then 'Onglyza' 
		when Market in ('CML') then 'Sprycel' 
		when Market in ('Platinum') then 'Paraplatin'
		when Market in ('CCB') then 'Coniel'
		else Market 
	end
go

insert into TempCityDashboard_For_Eliquis_NOAC (Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
Audi_cod,audi_des,lev)
select  Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
Audi_cod,audi_des,lev 
from (
	select A.*,Audi_cod,audi_des,lev 
	from 
	(select distinct Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype from TempCityDashboard_For_Eliquis_NOAC) A
	inner join
	(select distinct  Molecule,Class,mkt,mktname,Market,Moneytype,Audi_cod,audi_des,lev from TempCityDashboard_For_Eliquis_NOAC) B
	on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market and a.Moneytype=b.Moneytype
	) A 
where not exists(
	select * from TempCityDashboard_For_Eliquis_NOAC B
	where a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
		and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and a.Prod=B.Prod)
go
update TempCityDashboard_For_Eliquis_NOAC
set Tier=B.Tier from TempCityDashboard_For_Eliquis_NOAC A inner join Dim_City B
on A.Audi_cod=B.CIty_Code+'_'
go
--Eliquis NOAC  CHPA PART
if object_id (N'TempCHPAReports_For_Eliquis_NOAC',N'U') is not null
	drop table  TempCHPAReports_For_Eliquis_NOAC

select --a.City_Code,a.City_Name,a.City_Name_CH 
	c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype,'FocusCity_2' as Audi_des,
	sum(MTH00) AS MTH00, sum(MTH01) as MTH01,sum(MTH02) as MTH02,sum(MTH03) as MTH03,sum(MTH04) as MTH04,sum(MTH05) as MTH05,
	sum(MTH06) AS MTH06, sum(MTH07) as MTH07,sum(MTH08) as MTH08,sum(MTH09) as MTH09,sum(MTH10) as MTH10,sum(MTH11) as MTH11, sum(MTH12) as MTH12,
	sum(YTD00) as YTD00,sum(YTD12) as YTD12,sum(MAT00) AS MAT00,sum(MAT12) AS MAT12,sum(R3M00) AS R3M00,sum(R3M03) AS R3M03,sum(r3m12) as r3m12
into TempCHPAReports_For_Eliquis_NOAC
from TempCHPAPreReports_For_Eliquis_NOAC c
group by c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype



--Eliquis CHPA NOAC market Share
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],Lev)
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,Series,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='NOAC Market' then 1
	 when Series='ELIQUIS' then 2
	 when Series='PRADAXA' then 3
	 when Series='XARELTO' then 4 
	  --when Series='PRADAXA' then 7
	 end
 as Series_Idx,'Nation_2'  as Lev
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
	from TempCHPAReports_For_Eliquis_NOAC A inner join TempCHPAReports_For_Eliquis_NOAC B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and  a.Class=b.Class and a.Molecule=b.Molecule
	and A.Market=B.Market and A.prod='000' and B.prod not in ('000','101')
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
	from TempCHPAReports_For_Eliquis_NOAC A 
	where MoneyType IN ('US','UN') and a.prod='000' and molecule='N' and class='N' and a.mkt ='Eliquis'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T


--Eliquis CHPA NOAC market Growth
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],Lev)
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] 
      ,case when X='MAT Growth' then 1
		    when X='YTD Growth' then 2
			when X='MTH Growth' then 3
			when X='YTD00 Share' then 5
			when X='YTD12 Share' then 6			
			end as X_Idx      
      ,case when Series='NOAC Market' then 1
	 when Series='ELIQUIS' then 2
	 when Series='PRADAXA' then 3
	 when Series='XARELTO' then 4 
	 end
 as Series_Idx,'Nation_2' as Lev
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.ProductName as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then 10000 else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
--	case when sum(r3m03) =0 or sum(r3m03) is null then 10000 else 1.0*(sum(r3m00)-sum(r3m03))/sum(r3m03) end as [MQT Growth(vs. last quarter)],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then 10000 else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
	sum(ytd00) as [YTD00 Share],
	sum(ytd12) as [YTD12 Share]
	from TempCHPAReports_For_Eliquis_NOAC a
	where a.molecule='N' and a.class='N'  and a.Moneytype IN ('US','UN') and a.market='Eliquis' and a.mkt='Eliquis'
	and a.prod not in('000' ,'101')
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
	union
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
		A.Productname as Series,convert(varchar(50),'Growth') as DataType,
		case when a.MoneyType='US' then 'Value' 
			when a.MoneyType='UN' then 'Volume' end as Category,
		case when sum(MTH12) =0 or sum(MTH12) is null then 10000 else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
		--case when sum(r3m03) =0 or sum(r3m03) is null then 10000 else 1.0*(sum(r3m00)-sum(r3m03))/sum(r3m03) end as [MQT Growth(vs. last quarter)],
		case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
		case when sum(ytd12) =0 or sum(ytd12) is null then 10000 else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]
	from TempCHPAReports_For_Eliquis_NOAC a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.market='Eliquis' and a.mkt='Eliquis' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth],[MAT Growth],[YTD Growth],[YTD00 Share],[YTD12 Share])
)     t

GO



--Coniel Focus city

if object_id (N'TempFocusCityReports_For_Coniel',N'U') is not null
	drop table  TempFocusCityReports_For_Coniel

select --a.City_Code,a.City_Name,a.City_Name_CH 
c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype,'FocusCity_2' as Audi_des,
sum(MTH00) AS MTH00, sum(MTH01) as MTH01,sum(MTH02) as MTH02,sum(MTH03) as MTH03,sum(MTH04) as MTH04,sum(MTH05) as MTH05,
sum(MTH06) AS MTH06, sum(MTH07) as MTH07,sum(MTH08) as MTH08,sum(MTH09) as MTH09,sum(MTH10) as MTH10,sum(MTH11) as MTH11, sum(MTH12) as MTH12,
sum(YTD00) as YTD00,sum(YTD12) as YTD12,sum(MAT00) AS MAT00,sum(MAT12) AS MAT12,sum(R3M00) AS R3M00,sum(R3M03) AS R3M03,sum(r3m12) as r3m12
into TempFocusCityReports_For_Coniel
from TempcityDashboard_For_CCB c 
inner join dim_city a
on a.city_code+'_'=c.Audi_Cod
group by c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype







--Eliquis NOAC Focus city part
if object_id (N'TempFocusCityReports_For_Eliquis_NOAC',N'U') is not null
	drop table  TempFocusCityReports_For_Eliquis_NOAC

select --a.City_Code,a.City_Name,a.City_Name_CH 
c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype,'FocusCity_2' as Audi_des,
sum(MTH00) AS MTH00, sum(MTH01) as MTH01,sum(MTH02) as MTH02,sum(MTH03) as MTH03,sum(MTH04) as MTH04,sum(MTH05) as MTH05,
sum(MTH06) AS MTH06, sum(MTH07) as MTH07,sum(MTH08) as MTH08,sum(MTH09) as MTH09,sum(MTH10) as MTH10,sum(MTH11) as MTH11, sum(MTH12) as MTH12,
sum(YTD00) as YTD00,sum(YTD12) as YTD12,sum(MAT00) AS MAT00,sum(MAT12) AS MAT12,sum(R3M00) AS R3M00,sum(R3M03) AS R3M03,sum(r3m12) as r3m12
into TempFocusCityReports_For_Eliquis_NOAC
from dim_city a join inCV_Focus_City b 
on a.city_name_ch=b.city_cn
join TempCityDashboard_For_Eliquis_NOAC c on a.city_code+'_'=c.Audi_Cod and c.market=b.product
group by c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype

--Eliquis Focus City NOAC market Share
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],Lev)
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,Series,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='NOAC Market' then 1
	 when Series='ELIQUIS' then 2
	 when Series='PRADAXA' then 3
	 when Series='XARELTO' then 4 
	  --when Series='PRADAXA' then 7
	 end
 as Series_Idx,'FocusCity_2'  as Lev
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
		from TempFocusCityReports_For_Eliquis_NOAC A inner join TempFocusCityReports_For_Eliquis_NOAC B
		on A.mkt=b.mkt and A.Moneytype=b.Moneytype and  a.Class=b.Class and a.Molecule=b.Molecule
		and A.Market=B.Market and A.prod='000' and B.prod not in ('000','101')
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
	from TempFocusCityReports_For_Eliquis_NOAC A 
	where MoneyType IN ('US','UN') and a.prod='000' and molecule='N' and class='N' and a.mkt ='Eliquis'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T


--Eliquis Focus City NOAC market Growth
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],Lev)
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] 
      ,case when X='MAT Growth' then 1
		    when X='YTD Growth' then 2
			when X='MTH Growth' then 3
			when X='YTD00 Share' then 5
			when X='YTD12 Share' then 6			
			end as X_Idx      
      ,case when Series='NOAC Market' then 1
	 when Series='ELIQUIS' then 2
	 when Series='PRADAXA' then 3
	 when Series='XARELTO' then 4 
	 end
 as Series_Idx,'FocusCity_2' as Lev
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.ProductName as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then 10000 else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
--	case when sum(r3m03) =0 or sum(r3m03) is null then 10000 else 1.0*(sum(r3m00)-sum(r3m03))/sum(r3m03) end as [MQT Growth(vs. last quarter)],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then 10000 else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
	sum(ytd00) as [YTD00 Share],
	sum(ytd12) as [YTD12 Share]
	from TempFocusCityReports_For_Eliquis_NOAC a
	where a.molecule='N' and a.class='N'  and a.Moneytype IN ('US','UN') and a.market='Eliquis' and a.mkt='Eliquis'
	and a.prod not in('000' ,'101')
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
	union
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.Productname as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then 10000 else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	--case when sum(r3m03) =0 or sum(r3m03) is null then 10000 else 1.0*(sum(r3m00)-sum(r3m03))/sum(r3m03) end as [MQT Growth(vs. last quarter)],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then 10000 else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
	sum(ytd00) as [YTD00 Share],
	sum(ytd12) as [YTD12 Share]
	from TempFocusCityReports_For_Eliquis_NOAC a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.market='Eliquis' and a.mkt='Eliquis' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth],[MAT Growth],[YTD Growth],[YTD00 Share],[YTD12 Share])
)     t

GO

--Coniel Share(CHPA)
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],lev)
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,Series,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='CCB Market' then 1
	 when Series='CONIEL' then 2
	 when Series='YUAN ZHI' then 4
	 when Series='LACIPIL' then 5
	 when Series='ZANIDIP' then 6 
	 when Series='NORVASC' then 7
	 when Series='ADALAT' then 8
	 when Series='PLENDIL' then 9
	 end
 as Series_Idx ,'Nation' as lev
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


--Coniel Growth(CHPA)
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],lev)
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] 
      ,case when X='MAT Growth' then 1
			when X='YTD Growth' then 2
			when X='MTH Growth' then 3
			when X='YTD00 Share' then 5
			when X='YTD12 Share' then 6
			end as X_Idx      
      ,case when Series='CCB Market' then 1
	 when Series='CONIEL' then 2
	 when Series='YUAN ZHI' then 4
	 when Series='LACIPIL' then 5
	 when Series='ZANIDIP' then 6 
	 when Series='NORVASC' then 7
	 when Series='ADALAT' then 8
	 when Series='PLENDIL' then 9
	 end
 as Series_Idx,'Nation' as lev
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.ProductName as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
	sum(ytd00) as [YTD00 Share],
	sum(ytd12) as [YTD12 Share]
	from TempCHPAPreReports_For_CCB a
	where a.molecule='N' and a.class='N'  and a.Moneytype IN ('US','UN') and a.market='Coniel' and a.mkt='CCB'
	and a.productname <>'CCB Others'and a.prod not in ('000' ,'101')
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
	union
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.Productname as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
	sum(ytd00) as [YTD00 Share],
	sum(ytd12) as [YTD12 Share]
	from TempCHPAPreReports_For_CCB a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.market='Coniel' and a.mkt='ccb' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth],[MAT Growth],[YTD Growth],[YTD00 Share],[YTD12 Share])
)     t

GO





--Coniel Share(CITY)
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],lev)
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,Series,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='CCB Market' then 1
	 when Series='CONIEL' then 2
	 when Series='YUAN ZHI' then 4
	 when Series='LACIPIL' then 5
	 when Series='ZANIDIP' then 6 
	 when Series='NORVASC' then 7
	 when Series='ADALAT' then 8
	 when Series='PLENDIL' then 9
	 end
 as Series_Idx ,'FocusCity' as lev
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
	from TempFocusCityReports_For_Coniel A inner join TempFocusCityReports_For_Coniel B
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
	from TempFocusCityReports_For_Coniel A 
	where MoneyType IN ('US','UN') and a.prod='000' and molecule='N' and class='N' and a.mkt ='ccb'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T


--Coniel Growth(CITY)
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],lev)
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] 
      ,case when X='MAT Growth' then 1
			when X='YTD Growth' then 2
			when X='MTH Growth' then 3
			when X='YTD00 Share' then 5
			when X='YTD12 Share' then 6
			end as X_Idx      
      ,case when Series='CCB Market' then 1
	 when Series='CONIEL' then 2
	 when Series='YUAN ZHI' then 4
	 when Series='LACIPIL' then 5
	 when Series='ZANIDIP' then 6 
	 when Series='NORVASC' then 7
	 when Series='ADALAT' then 8
	 when Series='PLENDIL' then 9
	 end
 as Series_Idx,'FocusCity' as lev
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.ProductName as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
	sum(ytd00) as [YTD00 Share],
	sum(ytd12) as [YTD12 Share]
	from TempFocusCityReports_For_Coniel a
	where a.molecule='N' and a.class='N'  and a.Moneytype IN ('US','UN') and a.market='Coniel' and a.mkt='CCB'
	and a.productname <>'CCB Others'and a.prod not in ('000' ,'101')
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
	union
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 A.Productname as Series,convert(varchar(50),'Growth') as DataType,
	case when a.MoneyType='US' then 'Value' 
		 when a.MoneyType='UN' then 'Volume' end as Category,
	case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
	case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
	sum(ytd00) as [YTD00 Share],
	sum(ytd12) as [YTD12 Share]
	from TempFocusCityReports_For_Coniel a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.market='Coniel' and a.mkt='ccb' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth],[MAT Growth],[YTD Growth],[YTD00 Share],[YTD12 Share])
)     t

GO

if object_id (N'TempCHPAPreReports_For_Glucophage',N'U') is not null
	drop table TempCHPAPreReports_For_Glucophage
select * into TempCHPAPreReports_For_Glucophage from TempCHPAPreReports where 1=0
	
declare @i int,@sql varchar(8000),@sql1 varchar(8000),@sql3 varchar(8000),@sqlMAT varchar(8000),@sqlYTD varchar(8000),@sqlQtr varchar(8000)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(8000)
DECLARE @SQL4 VARCHAR(8000)
declare @transfer varchar(100)	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		set @transfer=''
		if @MoneyType='un'
			  set @transfer='/isnull(c.dd,1)'
		
		set @i=0
		set @sql1=''
        set @sql3=''
		while (@i<=48)
		begin
		set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+@transfer+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
		set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+@transfer+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
		set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+@transfer+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
		while (@i<=48)--
		begin
		set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+@transfer+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
		set @sqlQtr=''
		while (@i<=19)
		begin
		set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+@transfer+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1
		print 'insert into TempCHPAPreReports_For_Glucophage 
		select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,
--         A.MNFL_COD,B.Gene_cod,
        '+'''' +@MoneyType+''''+' as Moneytype, '
       print @sql1
       print ', '+@sql3
       print ', '+ @sqlMAT
       print ', '+@sqlYTD
       print ', '+@sqlQtr+'
		from mthCHPA_pkau A inner join tblMktDef_MRBIChina B
        on A.pack_cod=B.pack_cod 
        left join dbo.inGlucophageDOT_Transfer c on b.pack_des=c.package
        where B.Active=''Y'' and b.Mkt=''NIAD''
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname'
		
		
		exec( 'insert into TempCHPAPreReports_For_Glucophage 
		select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,
--         A.MNFL_COD,B.Gene_cod,
        '+'''' +@MoneyType+''''+' as Moneytype, '+@sql1+', '+@sql3+', '+ @sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
		from mthCHPA_pkau A inner join tblMktDef_MRBIChina B
        on A.pack_cod=B.pack_cod 
        left join dbo.inGlucophageDOT_Transfer c on b.pack_des=c.package
        where B.Active=''Y'' and b.Mkt=''NIAD''
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname')
       print @SQL2+@sql+@sql4
		exec( @SQL2+@sql+@sql4)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
update TempCHPAPreReports_For_Glucophage
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
from TempCHPAPreReports_For_Glucophage
where Market <> 'Paraplatin' and MoneyType = 'PN'


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
	from TempCHPAPreReports_For_Glucophage A inner join TempCHPAPreReports_For_Glucophage B
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
	from TempCHPAPreReports_For_Glucophage A 
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
      ,case when X='MAT Growth' then 1
			when X='YTD Growth' then 2
			when X='MTH Growth' then 3
			when X='YTD00 Share' then 5
			when X='YTD12 Share' then 6
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
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
	sum(ytd00) as [YTD00 Share],
	sum(ytd12) as [YTD12 Share]
	from TempCHPAPreReports_For_Glucophage a
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
	case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
	sum(ytd00) as [YTD00 Share],
	sum(ytd12) as [YTD12 Share]
	from TempCHPAPreReports_For_Glucophage a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.market='Glucophage ' and a.mkt='NIAD' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth],[MAT Growth],[YTD Growth],[YTD00 Share],[YTD12 Share])
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
molecule,class,atc1_cod,atc2_cod,atc3_cod,atc4_cod,pack_cod,pack_des,prod_cod,prod_name,prod_FullName,mole_cod,mole_name,corp_cod,manu_cod,gene_cod,active,date,comment,rat
from tblMktDef_MRBIChina 
where prod_name in ('Janumet','Trajenta') and mkt='dpp4'
union
select mkt,mktname, prod ,ProductName,
molecule,class,atc1_cod,atc2_cod,atc3_cod,atc4_cod,pack_cod,pack_des,prod_cod,prod_name,prod_FullName,mole_cod,mole_name,corp_cod,manu_cod,gene_cod,active,date,comment ,rat
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
		while (@i<=48)--
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
--Monopril CHPA

if object_id (N'TempCHPAPreReports_For_Monopril',N'U') is not null
	drop table TempCHPAPreReports_For_Monopril
	
select 
	c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype,'Nation' as Audi_des,
	sum(MTH00) AS MTH00, sum(MTH01) as MTH01,sum(MTH02) as MTH02,sum(MTH03) as MTH03,sum(MTH04) as MTH04,sum(MTH05) as MTH05,
	sum(MTH06) AS MTH06, sum(MTH07) as MTH07,sum(MTH08) as MTH08,sum(MTH09) as MTH09,sum(MTH10) as MTH10,sum(MTH11) as MTH11, sum(MTH12) as MTH12,
	sum(YTD00) as YTD00,sum(YTD12) as YTD12,sum(MAT00) AS MAT00, sum(MAT12) AS MAT12,sum(r3m00) as r3m00,sum(r3m12) as r3m12,sum(r3m03) as r3m03
into TempCHPAPreReports_For_Monopril
from TempCHPAPreReports  c
where c.market='Monopril' and c.mkt='hyp'
group by c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype

--end 
if object_id (N'TempFocusCityReports_For_Monopril',N'U') is not null
	drop table TempFocusCityReports_For_Monopril
	
select --a.City_Code,a.City_Name,a.City_Name_CH 
	c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype,'FocusCity' as Audi_des,
	sum(MTH00) AS MTH00, sum(MTH01) as MTH01,sum(MTH02) as MTH02,sum(MTH03) as MTH03,sum(MTH04) as MTH04,sum(MTH05) as MTH05,
	sum(MTH06) AS MTH06, sum(MTH07) as MTH07,sum(MTH08) as MTH08,sum(MTH09) as MTH09,sum(MTH10) as MTH10,sum(MTH11) as MTH11, sum(MTH12) as MTH12,
	sum(YTD00) as YTD00,sum(YTD12) as YTD12,sum(MAT00) AS MAT00, sum(MAT12) AS MAT12,sum(r3m00) as r3m00,sum(r3m12) as r3m12,sum(r3m03) as r3m03
into TempFocusCityReports_For_Monopril
from dim_city a 
join inCV_Focus_City b on a.city_name_ch=b.city_cn
join TempCityDashboard_AllCity c on a.city_code+'_'=c.Audi_Cod and c.market=b.product
where c.market='Monopril' and c.mkt='hyp'
group by c.Molecule,c.Class,c.Mkt,c.MktName,c.Market,c.prod,c.productname,c.Moneytype

--TempCHPAPreReports


--MonoprilShare(CHPA)
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],lev)
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,Series,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='Hypertension Market' then 1
	 when Series='Acertil' then 2
	 when Series='Lotensin' then 3
	 when Series='Monopril' then 4 
	 when Series='Tritace' then 6 end
 as Series_Idx ,'Nation' as lev
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
	from TempCHPAPreReports_For_Monopril A 
	inner join TempCHPAPreReports_For_Monopril B 
		on A.mkt=b.mkt and A.Moneytype=b.Moneytype and  a.Class=b.Class and a.Molecule=b.Molecule 
			and A.Market=B.Market and A.prod='000' and B.prod<>'000'
	where  b.Moneytype IN ('US','UN') and  b.market='Monopril' and b.mkt='HYP'
           and b.Molecule='N' and b.Class='N' and b.productname in ('Acertil','Lotensin','Monopril','Tritace','Monopril-CHPA')
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
	from TempCHPAPreReports_For_Monopril A 
	where MoneyType IN ('US','UN') and a.prod='000' and molecule='N' and class='N' and a.mkt ='hyp'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T


--MonoprilGrowth(CHPA)
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],lev)
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] 
      ,case 
			when X='MAT Growth' then 1
		    when X='YTD Growth' then 2
			when X='MTH Growth' then 3 
			when X='YTD00 Share' then 5
			when X='YTD12 Share' then 6
			end as X_Idx      
      ,case when Series='Hypertension Market' then 1
	 when Series='Acertil' then 2
	 when Series='Lotensin' then 3
	 when Series='Monopril' then 4
	 when Series='Tritace' then 5
	 end
 as Series_Idx,'Nation' as lev
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
		A.ProductName as Series,convert(varchar(50),'Growth') as DataType,
		case when a.MoneyType='US' then 'Value' 
			when a.MoneyType='UN' then 'Volume' end as Category,
		case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
		case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
		case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]	,
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]
	from TempCHPAPreReports_For_Monopril a
	where a.molecule='N' and a.class='N'  and a.Moneytype IN ('US','UN') and a.market='Monopril' and a.mkt='HYP'
		and a.productname in ('Acertil','Lotensin','Monopril','Tritace')and a.prod not in ('000' ,'101')
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
	union
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
	 	A.Productname as Series,convert(varchar(50),'Growth') as DataType,
		case when a.MoneyType='US' then 'Value' 
			when a.MoneyType='UN' then 'Volume' end as Category,
		case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
		case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
		case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]
	from TempCHPAPreReports_For_Monopril a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.market='Monopril' and a.mkt='HYP' and a.prod='000' 
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth],[MAT Growth],[YTD Growth],[YTD00 Share],[YTD12 Share])
)     t

GO




--MonoprilShare(City)
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],lev)
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,Series,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
	case when Series='Hypertension Market' then 1
		when Series='Acertil' then 2
		when Series='Lotensin' then 3
		when Series='Monopril' then 4 
		when Series='Tritace' then 6 end
	as Series_Idx ,'FocusCity' as lev
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
	from TempFocusCityReports_For_Monopril A inner join TempFocusCityReports_For_Monopril B
		on A.mkt=b.mkt and A.Moneytype=b.Moneytype and  a.Class=b.Class and a.Molecule=b.Molecule 
			and A.Market=B.Market and A.prod='000' and B.prod<>'000'
	where  b.Moneytype IN ('US','UN') and  b.market='Monopril' and b.mkt='HYP'
           and b.Molecule='N' and b.Class='N' and b.productname in ('Acertil','Lotensin','Monopril','Tritace','Monopril-CHPA')
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
	from TempFocusCityReports_For_Monopril A 
	where MoneyType IN ('US','UN') and a.prod='000' and molecule='N' and class='N' and a.mkt ='hyp'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T


--MonoprilGrowth(City)
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],lev)
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] 
      ,case 
			when X='MAT Growth' then 1
		    when X='YTD Growth' then 2
			when X='MTH Growth' then 3 
			when X='YTD00 Share' then 5
			when X='YTD12 Share' then 6
			end as X_Idx      
      ,case when Series='Hypertension Market' then 1
	 when Series='Acertil' then 2
	 when Series='Lotensin' then 3
	 when Series='Monopril' then 4
	 when Series='Tritace' then 5
	 end
 as Series_Idx,'FocusCity' as lev
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
		A.ProductName as Series,convert(varchar(50),'Growth') as DataType,
		case when a.MoneyType='US' then 'Value' 
			when a.MoneyType='UN' then 'Volume' end as Category,
		case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
		case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
		case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth]	,
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]
	from TempFocusCityReports_For_Monopril a
	where a.molecule='N' and a.class='N'  and a.Moneytype IN ('US','UN') and a.market='Monopril' and a.mkt='HYP'
		and a.productname in ('Acertil','Lotensin','Monopril','Tritace')and a.prod not in ('000' ,'101')
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
	union
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
		A.Productname as Series,convert(varchar(50),'Growth') as DataType,
		case when a.MoneyType='US' then 'Value' 
			when a.MoneyType='UN' then 'Volume' end as Category,
		case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
		case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
		case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]
	from TempFocusCityReports_For_Monopril a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.market='Monopril' and a.mkt='HYP' and a.prod='000' 
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth],[MAT Growth],[YTD Growth],[YTD00 Share],[YTD12 Share])
)     t

GO





--TaxolShare CHPA
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],Lev)
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,
case when Series='Oncology Focused Brands' then 'Oncology Market' else Series end as Series
 ,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='Oncology Focused Brands' then 1
	 when Series='AI SU' then 2
	 when Series='LI PU SU' then 4 
	 when Series='Taxotere' then 5 
	 when Series='Taxol' then 7
	 when Series='Abraxane' then 8
	 when Series='Anzatax' then 9
	 when Series='Total Paclitaxel' then 10 end	 
 as Series_Idx ,'nation'
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
				( b.Molecule='N' and b.Class='N' and b.productname in ('AI SU','LI PU SU','Taxotere','Taxol','Abraxane','Anzatax') ) or
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


--TaxolGrowth CHPA
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],lev)
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,case when Series='Oncology Focused Brands' then 'Oncology Market' else Series end as Series ,[DataType] ,[Category],[Y] ,[X] 
      ,case when X='MAT Growth' then 1
			when X='YTD Growth' then 2
			when X='MTH Growth' then 3		    
			when X='YTD00 Share' then 5
			when X='YTD12 Share' then 6
			end as X_Idx      
      ,case when Series='Oncology Focused Brands' then 1
	 when Series='AI SU' then 2
	 when Series='LI PU SU' then 4 
	 when Series='Taxotere' then 5 
	 when Series='Taxol' then 7
	 when Series='Abraxane' then 8
	 when Series='Anzatax' then 9
	 when Series='Total Paclitaxel' then 10 end	 
 as Series_Idx,'nation'
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
		case when a.ProductName='Paclitaxel' then 'Total Paclitaxel' else a.ProductName end as Series,convert(varchar(50),'Growth') as DataType,
		case when a.MoneyType='US' then 'Value' 
			when a.MoneyType='UN' then 'Volume' end as Category,
		case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
		case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
		case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]
	from TempCHPAPreReports a
	where  a.Moneytype IN ('US','UN') and a.Market='Taxol'  and a.mktName='Oncology Focused Brands'
           and (
				( a.Molecule='N' and a.Class='N' and a.productname in ('AI SU','LI PU SU','Taxotere','Taxol','Abraxane','Anzatax') ) or
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
		case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]	
	from TempCHPAPreReports a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.mkt ='ONCFCS' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth],[MAT Growth],[YTD Growth],[YTD00 Share],[YTD12 Share])
)  t

GO
--TaxolShare CITY
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],Lev)
select TimeFrame,MoneyType,Molecule,Class,Mkt,mktname,market,prod,
case when Series='Oncology Focused Brands' then 'Oncology Market' else Series end as Series
 ,DataType,Category,convert(decimal(20,8),Y) as Y,X, 12-convert(int,right(t.X,2)) as X_Idx,
case when Series='Oncology Focused Brands' then 1
	 when Series='AI SU' then 2
	 when Series='LI PU SU' then 4 
	 when Series='Taxotere' then 5 
	 when Series='Taxol' then 7
	 when Series='Abraxane' then 8
	 when Series='Anzatax' then 9
	 when Series='Total Paclitaxel' then 10 end	 
 as Series_Idx ,'FocusCity'  as Lev
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
	from TempCityDashboard A inner join TempCityDashboard B
		on A.mkt=b.mkt and A.Moneytype=b.Moneytype and  a.Class=b.Class and a.Molecule=b.Molecule
			and A.Market=B.Market and A.prod='000' and B.prod<>'000'
	where  b.Moneytype IN ('US','UN') and  b.Market='Taxol'  and b.mktName='Oncology Focused Brands'
           and (
				( b.Molecule='N' and b.Class='N' and b.productname in ('AI SU','LI PU SU','Taxotere','Taxol','Abraxane','Anzatax') ) or
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
	from TempCityDashboard A 
	where MoneyType IN ('US','UN') and a.prod='000' and molecule='N' and class='N' and a.mkt ='ONCFCS'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
) a unpivot (
	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12)
 ) T


--TaxolGrowth CITY
INSERT INTO KPI_Frame_MarketAnalyzer_IMSAudit_CHPA ([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],Lev)
SELECT [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,case when Series='Oncology Focused Brands' then 'Oncology Market' else Series end as Series ,[DataType] ,[Category],[Y] ,[X] 
      ,case when X='MAT Growth' then 1
			when X='YTD Growth' then 2
			when X='MTH Growth' then 3		    
			when X='YTD00 Share' then 5
			when X='YTD12 Share' then 6
			end as X_Idx      
      ,case when Series='Oncology Focused Brands' then 1
	 when Series='AI SU' then 2
	 when Series='LI PU SU' then 4 
	 when Series='Taxotere' then 5 
	 when Series='Taxol' then 7
	 when Series='Abraxane' then 8
	 when Series='Anzatax' then 9
	 when Series='Total Paclitaxel' then 10 end	 
 as Series_Idx,'FocusCity'  as Lev
FROM (
	select 'MTH' as TimeFrame,A.Moneytype,A.Molecule,A.Class,A.Mkt,A.Mktname,A.Market,A.Prod,
		case when a.ProductName='Paclitaxel' then 'Total Paclitaxel' else a.ProductName end as Series,convert(varchar(50),'Growth') as DataType,
		case when a.MoneyType='US' then 'Value' 
			when a.MoneyType='UN' then 'Volume' end as Category,
		case when sum(MTH12) =0 or sum(MTH12) is null then null else 1.0*(sum(MTH00)-sum(MTH12))/sum(MTH12) end as [MTH Growth],
		case when sum(mat12) =0 or sum(mat12) is null then null else 1.0*(sum(mat00)-sum(mat12))/sum(mat12) end as [MAT Growth],
		case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]
	from TempCityDashboard a
	where  a.Moneytype IN ('US','UN') and a.Market='Taxol'  and a.mktName='Oncology Focused Brands'
           and (
				( a.Molecule='N' and a.Class='N' and a.productname in ('AI SU','LI PU SU','Taxotere','Taxol','Abraxane','Anzatax') ) or
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
		case when sum(ytd12) =0 or sum(ytd12) is null then null else 1.0*(sum(ytd00)-sum(ytd12))/sum(ytd12) end as [YTD Growth],
		sum(ytd00) as [YTD00 Share],
		sum(ytd12) as [YTD12 Share]	
	from TempCityDashboard a
	where a.class='N' and a.Molecule='N'  and a.Moneytype IN ('US','UN') and a.mkt ='ONCFCS' and a.prod='000'
	group by A.Moneytype,A.Mkt,A.Molecule,A.Class,A.Mktname,A.Market,A.Prod,A.Productname
)  a unpivot (
	Y for X in ([MTH Growth],[MAT Growth],[YTD Growth],[YTD00 Share],[YTD12 Share])
)  t

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
		while (@i<=48)--
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
select @max_Mon=max(monSeq)+12 from tblMonthList where date >= (select convert(varchar(6),convert(int,left(max(date),4))-2)+'01' from tblMonthList)

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
select @max_Mon=max(monSeq) from tblMonthList where date >=(select convert(varchar(6),convert(int,left(max(date),4))-2)+'01' from tblMonthList)
declare @i int
declare @mqt_Name varchar(8000)
declare @mqt_GR varchar(8000)
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
	 from MTHCITY_PKAU A inner join tblMktDef_MRBIChina B
        on A.pack_cod=B.pack_cod where B.Active='Y' AND b.prod_name='Victoza' and b.mkt='niad' and b.Molecule='N' and b.class='N' 
        and b.prod='000'
	group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod_name ,a.Audi_cod       
	union        
	select B.Molecule,B.Class,B.mkt,B.mktname,'Byetta' as market,'1000' as prod,b.prod_name as ProductName,'US' AS MoneyType,a.Audi_cod, convert(varchar(200),null) as Audi_des,'City' as Lev,
		sum(MTH00US) AS MTH00,sum(MTH01US) AS MTH01,sum(MTH02US) AS MTH02,sum(MTH03US) AS MTH03,
		sum(MTH04US) AS MTH04,sum(MTH05US) AS MTH05,sum(MTH06US) AS MTH06,sum(MTH07US) AS MTH07,
		sum(MTH08US) AS MTH08,sum(MTH09US) AS MTH09,sum(MTH10US) AS MTH10,sum(MTH11US) AS MTH11,
		sum(MTH12US) AS MTH12,sum(mat00US) as MAT00,sum(mat12US) as MAT12
	 from MTHCITY_PKAU A inner join tblMktDef_MRBIChina B
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
		from MTHCITY_PKAU A inner join tblMktDef_MRBIChina_For_Onglyza B
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
	select * from tempCityDashboard_AllCity where mkt NOT IN ('DPP4','CCB','Eliquis')
	UNION 
	select * from TempCityDashboard_For_Onglyza
	UNION
	select * from TempcityDashboard_For_CCB
	UNION
	select * from TempcityDashboard_For_Eliquis
) b


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'TempCHPAPreReports_For_KPI_FRAME') and type='U')
BEGIN
	DROP TABLE TempCHPAPreReports_For_KPI_FRAME
END
select * into TempCHPAPreReports_For_KPI_FRAME
from (
	select * from TempCHPAPreReports where mkt NOT IN ('DPP4','CCB','Eliquis')
	UNION 
	select * from TempCHPAPreReports_FOR_Onglyza
	union
	select * from TempCHPAPreReports_For_CCB
	union
	select * from TempCHPAPreReports_For_Eliquis
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

--Taxol??Taxol??????
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
)  --
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
)  and  MoneyType='US' and Molecule='N' and class='N' and prod <> '000' --
) a join (
	select *  
	from TempCityDashboard_For_KPI_FRAME 
	where Mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS','DPP4','HYP','CCB')  and  MoneyType='US' and Molecule='N' and class='N' and prod ='000' --
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
	) -- 
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
)  --
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
)  and  MoneyType='US' and Molecule='N' and class='N' and prod <> '000' --
) a join (
	select *  
	from TempCHPAPreReports_For_KPI_FRAME 
	where Mkt in ('arv','NIAD','Eliquis','Platinum','ONCFCS','DPP4','HYP','CCB')  and  MoneyType='US' and Molecule='N' and class='N' and prod ='000' --
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
	) -- 
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
--	where  MoneyType='US' and Molecule='N' and class='N' and prod <> '000' --
--) a join (
--	select *  
--	from ByettaMarket_TempCityDashboard 
--	where  MoneyType='US' and Molecule='N' and class='N' and prod ='000' --
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
	case when b.mkt in ('NIAD','Platinum','ONCFCS') then
			convert(varchar(5),'MAT') 
		when b.mkt in ('DPP4','Eliquis') then 
			convert(varchar(5),'MQT') 
		when b.mkt in ('HYP','CCB') then 
			convert(varchar(5),'YTD') end as  TimeFrame,
	b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
	convert(varchar(200),'City Contri.') as Series,convert(varchar(50),'Share') as DataType, convert(varchar(20),'Value') as Category,
	case when b.mkt in ('NIAD','Platinum','ONCFCS') then
			convert(decimal(20,8),case when a.mat00 is null or a.mat00 = 0 then 0 else 1.0*b.mat00/a.mat00 end)
		when b.mkt  in ('DPP4','Eliquis') then 
			convert(decimal(20,8),case when a.r3m00 is null or a.r3m00 = 0 then 0 else 1.0*b.r3m00/a.r3m00 end)
		when b.mkt in ('HYP','CCB')then 
			convert(decimal(20,8),case when a.ytd00 is null or a.ytd00 = 0 then 0 else 1.0*b.ytd00/a.ytd00 end) end as  Y,
	b.Audi_des as X,null as X_Idx, 1 as Series_Idx
from 
(
	select Molecule,Class,mkt,Mktname,market,prod,productname,moneyType,Audi_cod,Audi_des,lev,tier,mat00,r3m00,ytd00
	from TempCityDashboard_For_KPI_FRAME 
	where prod='000' and  Mkt in ('NIAD','DPP4','Eliquis','HYP','Platinum','ONCFCS','CCB') and MoneyType='US' and Molecule='N' and Class='N' 
	union
	select Molecule,Class,Mkt,Mktname,market,prod,productname,moneyType,'' AS Audi_cod,'FocusCityTotal' as Audi_des,'' as lev,null as tier,mat00,r3m00,ytd00
	from dbo.TempFocusCityReports_For_Monopril-- focus cities requirement
	where prod='000' and MoneyType='US' and Molecule='N' and Class='N' and audi_des='FocusCity'
	union
	select Molecule,Class,Mkt,Mktname,market,prod,productname,moneyType,'' AS Audi_cod,'FocusCityTotal' as Audi_des,'' as lev,null as tier,mat00,r3m00,ytd00
	from dbo.TempFocusCityReports_For_CCB-- focus cities requirement
	where prod='000' and MoneyType='US' and Molecule='N' and Class='N' and audi_des='FocusCity'
	union
	select Molecule,Class,Mkt,Mktname,market,prod,productname,moneyType,'' AS Audi_cod,'FocusCityTotal' as Audi_des,'' as lev,null as tier,mat00,r3m00,ytd00
	from dbo.TempFocusCityReports_For_Eliquis_KeyCity-- focus cities requirement
	where prod='000' and MoneyType='US' and Molecule='N' and Class='N' and audi_des='FocusCity'
) a join
(
	select Molecule,Class,mkt,Mktname,market,prod,productname,moneyType,Audi_cod,Audi_des,lev,tier,mat00,r3m00,ytd00
	from TempCityDashboard_For_KPI_FRAME 
	where ( (Mkt='Eliquis' and prod='100') or (Mkt='NIAD' and prod='100') 
		or (Mkt='HYP' and prod='100')or (Mkt='CCB' and prod='100') or (Mkt='DPP4' and prod='100') or (Mkt='Platinum' and prod='100') or (Mkt='ONCFCS' and prod='100') )
	 	and MoneyType='US' and Molecule='N' and Class='N'
	union
	select Molecule,Class,Mkt,Mktname,market,prod,productname,moneyType,'' AS Audi_cod,'FocusCityTotal' as Audi_des,'' as lev,null as tier,mat00,r3m00,ytd00
	from dbo.TempFocusCityReports_For_Monopril-- focus cities requirement
	where prod='100' and MoneyType='US' and Molecule='N' and Class='N' 
	union
	select Molecule,Class,Mkt,Mktname,market,prod,productname,moneyType,'' AS Audi_cod,'FocusCityTotal' as Audi_des,'' as lev,null as tier,mat00,r3m00,ytd00
	from dbo.TempFocusCityReports_For_CCB-- focus cities requirement
	where prod='100' and MoneyType='US' and Molecule='N' and Class='N' 
	union
	select Molecule,Class,Mkt,Mktname,market,prod,productname,moneyType,'' AS Audi_cod,'FocusCityTotal' as Audi_des,'' as lev,null as tier,mat00,r3m00,ytd00
	from dbo.TempFocusCityReports_For_Eliquis_KeyCity-- focus cities requirement
	where prod='100' and MoneyType='US' and Molecule='N' and Class='N' 
	
	 
) b on a.Molecule=b.Molecule and a.Class=b.Class and a.Mktname=b.Mktname and a.market=b.market and a.MoneyType=b.MoneyType 
 and a.Audi_cod=b.Audi_cod and a.Audi_des=b.Audi_des
 
insert into  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
	Datatype,Category,Y,X,X_Idx,Series_Idx)
select 
	case when b.mkt in ('NIAD','Platinum','ONCFCS') then
			convert(varchar(5),'MAT') 
		when b.mkt in ('DPP4','Eliquis') then 
			convert(varchar(5),'MQT') 
		when b.mkt IN ('HYP','CCB') then 
			convert(varchar(5),'YTD') end as  TimeFrame,
	b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
	case when mkt in ('DPP4','Eliquis') then convert(varchar(200),'MQT Growth(vs.last Quarter)') else  convert(varchar(200),'Year-to-Year Growth') end as Series,convert(varchar(50),'Growth') as DataType, convert(varchar(20),'Value') as Category,
	case when b.mkt in ('NIAD','Platinum','ONCFCS') then
			convert(decimal(20,8),case when b.mat12 is null or b.mat12 = 0 then null else 1.0*(b.mat00-b.mat12)/b.mat12 end)
		when b.mkt in ('DPP4','Eliquis') then 
			convert(decimal(20,8),case when b.r3m03 is null or b.r3m03 = 0 then null else 1.0*(b.r3m00-b.r3m03)/b.r3m03 end)
		when b.mkt IN ('HYP','CCB') then 
			convert(decimal(20,8),case when b.ytd12 is null or b.ytd12 = 0 then null else 1.0*(b.ytd00-b.ytd12)/b.ytd12 end) end as  Y,
	b.Audi_des as X,null as X_Idx, 2 as Series_Idx
from ( 
	select Molecule,Class,mkt,Mktname,market,prod,productname,moneyType,Audi_cod,Audi_des,lev,tier,mat00,r3m00,ytd00,mat12,r3m03,r3m12,ytd12
	from TempCityDashboard_For_KPI_FRAME 	
	union all
	select Molecule,Class,Mkt,Mktname,market,prod,productname,moneyType,'' AS Audi_cod,'FocusCityTotal' as Audi_des,'' as lev,null as tier,mat00,r3m00,ytd00,mat12,r3m03,r3m12,ytd12
	from dbo.TempFocusCityReports_For_Monopril-- focus cities requirement
	union all
	select Molecule,Class,Mkt,Mktname,market,prod,productname,moneyType,'' AS Audi_cod,'FocusCityTotal' as Audi_des,'' as lev,null as tier,mat00,r3m00,ytd00,mat12,r3m03,r3m12,ytd12
	from dbo.TempFocusCityReports_For_CCB-- focus cities requirement
	union all
	select Molecule,Class,Mkt,Mktname,market,prod,productname,moneyType,'' AS Audi_cod,'FocusCityTotal' as Audi_des,'' as lev,null as tier,mat00,r3m00,ytd00,mat12,r3m03,r3m12,ytd12
	from dbo.TempFocusCityReports_For_Eliquis_KeyCity-- focus cities requirement
	
) b
where ( (Mkt='Eliquis' and prod='100') or (Mkt='NIAD' and prod='100') 
	or (Mkt='HYP' and prod='100') or (Mkt='CCB' and prod='100') or (Mkt='DPP4' and prod='100') or (Mkt='Platinum' and prod='100') or (Mkt='ONCFCS' and prod='100') ) and MoneyType='US' and Molecule='N' and Class='N'

insert into  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
	Datatype,Category,Y,X,X_Idx,Series_Idx)
select 
	case when b.mkt in ('NIAD','Platinum','ONCFCS') then
			convert(varchar(5),'MAT') 
		when b.mkt  in ('DPP4','Eliquis') then 
			convert(varchar(5),'MQT') 
		when b.mkt IN ('HYP','CCB') then 
			convert(varchar(5),'YTD') end as  TimeFrame,
	b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
	b.Productname+' Sales' as Series,convert(varchar(50),'Size') as DataType, convert(varchar(20),'Value') as Category,
	case when b.mkt in ('NIAD','Platinum','ONCFCS') then
			b.mat00
		when b.mkt  in ('DPP4','Eliquis') then 
			b.r3m00
		when b.mkt IN ('HYP','CCB') then 
			b.ytd00 end as  Y,
	b.Audi_des as X,
	row_number() over(partition by MoneyType,Molecule,class,Mkt,mktname,market,prod order by (
			case when Audi_des= 'FocusCityTotal' then 0
				when mkt in ('NIAD','Platinum','ONCFCS') then MAT00				
				when mkt  in ('DPP4','Eliquis') then R3M00		
				when mkt IN ('HYP','CCB') then YTD00 end) desc) as X_Idx, 
	3 as Series_Idx
from   ( 
	select Molecule,Class,mkt,Mktname,market,prod,productname,moneyType,Audi_cod,Audi_des,lev,tier,mat00,r3m00,ytd00,mat12,r3m03,r3m12,ytd12
	from TempCityDashboard_For_KPI_FRAME 	
	union all
	select Molecule,Class,Mkt,Mktname,market,prod,productname,moneyType,'' AS Audi_cod,'FocusCityTotal' as Audi_des,'' as lev,null as tier,mat00,r3m00,ytd00,mat12,r3m03,r3m12,ytd12
	from dbo.TempFocusCityReports_For_Monopril-- focus cities requirement
	union all
	select Molecule,Class,Mkt,Mktname,market,prod,productname,moneyType,'' AS Audi_cod,'FocusCityTotal' as Audi_des,'' as lev,null as tier,mat00,r3m00,ytd00,mat12,r3m03,r3m12,ytd12
	from dbo.TempFocusCityReports_For_CCB-- focus cities requirement
	union all
	select Molecule,Class,Mkt,Mktname,market,prod,productname,moneyType,'' AS Audi_cod,'FocusCityTotal' as Audi_des,'' as lev,null as tier,mat00,r3m00,ytd00,mat12,r3m03,r3m12,ytd12
	from dbo.TempFocusCityReports_For_Eliquis_KeyCity-- focus cities requirement
)  b
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
where Mkt='arv' and prod='100' and MoneyType='Un' and Molecule='N' and Class='N'

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
	case when b.mkt in ('NIAD','Platinum','ONCFCS') then
			convert(varchar(5),'MAT') 
		when b.mkt in ('DPP4','Eliquis') then 
			convert(varchar(5),'MQT') 
		when b.mkt in ('HYP','CCB') then 
			convert(varchar(5),'YTD') end as  TimeFrame,
	b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
	convert(varchar(200),'City Contri.') as Series,convert(varchar(50),'Share') as DataType, convert(varchar(20),'Value') as Category,
	case when b.mkt in ('NIAD','Platinum','ONCFCS') then
			convert(decimal(20,8),case when a.mat00 is null or a.mat00 = 0 then 0 else 1.0*b.mat00/a.mat00 end)
		when b.mkt in( 'DPP4','Eliquis') then 
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
case when b.mkt in ('NIAD','Platinum','ONCFCS') then
		convert(varchar(5),'MAT') 
	 when b.mkt  in ('DPP4','Eliquis') then 
		convert(varchar(5),'MQT') 
	 when b.mkt in ('HYP','CCB') then 
		convert(varchar(5),'YTD') end as  TimeFrame,
b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
case when mkt in ('DPP4','Eliquis') then convert(varchar(200),'MQT Growth(vs.last Quarter)') else  convert(varchar(200),'Year-to-Year Growth') end as Series,convert(varchar(50),'Growth') as DataType, convert(varchar(20),'Value') as Category,
case when b.mkt in ('NIAD','Platinum','ONCFCS') then
		convert(decimal(20,8),case when b.mat12 is null or b.mat12 = 0 then null else 1.0*(b.mat00-b.mat12)/b.mat12 end)
	 when b.mkt in ('DPP4','Eliquis') then 
		convert(decimal(20,8),case when b.r3m03 is null or b.r3m03 = 0 then null else 1.0*(b.r3m00-b.r3m03)/b.r3m03 end)
	 when b.mkt in ('HYP','CCB') then 
		convert(decimal(20,8),case when b.ytd12 is null or b.ytd12 = 0 then null else 1.0*(b.ytd00-b.ytd12)/b.ytd12 end) end as  Y,
'National' as X,null as X_Idx, 2 as Series_Idx
from  TempCHPAPreReports_For_KPI_FRAME b
where ( (Mkt='Eliquis' and prod='100') or (Mkt='NIAD' and prod='100') 
	or (Mkt='HYP' and prod='100')or (Mkt='CCB' and prod='100') or (Mkt='DPP4' and prod='100') or (Mkt='Platinum' and prod='100') or (Mkt='ONCFCS' and prod='100') ) and MoneyType='US' and Molecule='N' and Class='N'

insert into  KPI_Frame_MarketAnalyzer_IMSAudit_48Cities(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,prod,Series,
Datatype,Category,Y,X,X_Idx,Series_Idx)
select 
case when b.mkt in ('NIAD','Platinum','ONCFCS') then
		convert(varchar(5),'MAT') 
	 when b.mkt in ('DPP4','Eliquis') then 
		convert(varchar(5),'MQT') 
	 when b.mkt in ('HYP','CCB') then 
		convert(varchar(5),'YTD') end as  TimeFrame,
b.MoneyType,b.Molecule,b.Class,b.Mkt,b.Mktname,b.Market,b.Prod,
b.Productname+' Sales' as Series,convert(varchar(50),'Size') as DataType, convert(varchar(20),'Value') as Category,
case when b.mkt in ('NIAD','Platinum','ONCFCS') then
		b.mat00
	 when b.mkt in ('DPP4','Eliquis') then 
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
set x_idx=100
where x='National'

update KPI_Frame_MarketAnalyzer_IMSAudit_48Cities
set x_idx=60
where x='FocusCityTotal'

delete from KPI_Frame_MarketAnalyzer_IMSAudit_48Cities
where x='Guangdong'

delete from KPI_Frame_MarketAnalyzer_IMSAudit_48Cities
where x='Zhejiang'

--select * from KPI_Frame_MarketAnalyzer_IMSAudit_48Cities

delete from c
from KPI_Frame_MarketAnalyzer_IMSAudit_48Cities c
where mkt in ('CCB','HYP','Eliquis') and x not in ('National','FocusCityTotal') 
and not exists (
	select *
	from dim_city a join inCV_Focus_City b 
	on a.city_name_ch=b.city_cn
	where c.Market=b.product and c.x=a.city_name
)

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

--??��???MQT??
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

--KPI: Xarelto Value - Top 30 Cities (for Eliquis VTEp only)

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
	WHERE MARKET='Eliquis VTEp' AND PRODUCTNAME='XARELTO'  AND moneyType='US' and Molecule='N' and Class='N' and audi_des<>'Guangdong'
	union all
	SELECT convert(varchar(5),'MAT') as TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,Prod,
	convert(varchar(200),Productname+' Sales Value') as Series,convert(varchar(50),null) as DataType,convert(varchar(20),null) as Category,
	convert(decimal(20,8),MAT00) AS Y,Audi_des as X, 1 AS Series_Idx
	, 1000 as X_Idx
	FROM tempCityDashboard_AllCity 
	WHERE MARKET='Eliquis VTEp' AND PRODUCTNAME='XARELTO'  AND moneyType='US' and Molecule='N' and Class='N' and audi_des='Guangdong'
	
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
	WHERE MARKET='Eliquis VTEp' AND PRODUCTNAME='XARELTO'  AND moneyType='US' and Molecule='N' and Class='N' and audi_des<>'Guangdong'
	union all
	SELECT convert(varchar(5),'MAT') as TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,Prod,
	'Growth' as Series,convert(varchar(50),null) as DataType,convert(varchar(20),null) as Category,
	case when MAT12 IS NULL OR MAT12=0 then 0 else 1.0*(MAT00-MAT12)/MAT12 end as Y,
	Audi_des as X, 2 AS Series_Idx ,
	1000 as X_Idx
	FROM tempCityDashboard_AllCity 
	WHERE MARKET='Eliquis VTEp' AND PRODUCTNAME='XARELTO'  AND moneyType='US' and Molecule='N' and Class='N' and audi_des='Guangdong'
) a where a.X_Idx<=30	or a.x='Guangdong'

declare @NationAvg decimal(20,8)
select @NationAvg=case when MAT12 IS NULL OR MAT12=0 then 0 else 1.0*(MAT00-MAT12)/MAT12 end 
from dbo.TempCHPAPreReports where MARKET='ELIQUIS VTEp' AND PRODUCTNAME='XARELTO'  AND moneyType='US' and Molecule='N' and Class='N'

insert into KPI_Frame_MarketAnalyzer_XareltoValue_For_Eliquis(TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,Prod,
	Series,DataType,Category,Y,X,Series_Idx,X_Idx)
select distinct TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,Market,Prod,
'National Average Growth' as Series,DataType,Category,@NationAvg as Y, X,3 as Series_Idx,X_Idx
from KPI_Frame_MarketAnalyzer_XareltoValue_For_Eliquis
GO

update KPI_Frame_MarketAnalyzer_XareltoValue_For_Eliquis set market='Eliquis'
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
--Result: ?????????China?��???��?��Tier 2?Tier3 ???��
--?��??��ExcelonSuxio??Tier 2��?��???????o��??Tier 3
----------------------------------------------------------------------
IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'KPI_Frame_MarketAnalyzer_BMSBrandvsGenericBrand') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MarketAnalyzer_BMSBrandvsGenericBrand
END

--CityVel
select 'MAT' as TimeFrame,a.MoneyType,a.Molecule,a.Class,a.mkt,a.Mktname,a.Market, 
	convert(varchar(200),null) as Prod,'vs. RunZ' as Series,
	convert(varchar(50),null) as DataType, convert(varchar(20),null) as Category,
	convert(decimal(20,8),case when c.MAT00 is null or c.MAT00=0 then 0 else 1.0*a.MAT00/c.MAT00-1.0*b.MAT00/c.MAT00 end) as Y,a.Audi_des as X, convert(int,null) as X_Idx, 1 as Series_Idx
into KPI_Frame_MarketAnalyzer_BMSBrandvsGenericBrand
from (
	select Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,Audi_Cod,Audi_des,
          case when Audi_des='Nanning'  then 3 when Audi_des='Guangdong' then '-'  else Tier end as Tier, MAT00   
	from  dbo.tempCityDashboard_AllCity
    where Mkt='ARV' and Productname in ('Baraclude') and MoneyType='UN' and Molecule='N' and class='N'
  ) a join  (
	select Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,Audi_Cod,Audi_des,
           case when Audi_des='Nanning'  then 3 when Audi_des='Guangdong' then '-'  else Tier end as Tier, MAT00   
	from  dbo.tempCityDashboard_AllCity
    where Mkt='ARV' and Productname in ('RUN ZHONG') and MoneyType='UN' and Molecule='N' and class='N'
  ) b  on a.Molecule=b.Molecule and a.Class=b.Class and a.Mkt=b.Mkt and a.Mktname=b.mktname and a.market=b.market 
	and a.MoneyType=b.MoneyType and a.Audi_cod=b.Audi_cod and a.Audi_des=b.Audi_des and a.Tier=b.Tier
	  join  (
	select Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,Audi_Cod,Audi_des,
           case when Audi_des='Nanning'  then 3 when Audi_des='Guangdong' then '-'  else Tier end as Tier, MAT00   
	from  dbo.tempCityDashboard_AllCity
    where Mkt='ARV' and Prod='000' and MoneyType='UN' and Molecule='N' and class='N'
  ) c on a.Molecule=c.Molecule and a.Class=c.Class and a.Mkt=c.Mkt and a.Mktname=c.mktname and a.market=c.market 
	and a.MoneyType=c.MoneyType and a.Audi_cod=c.Audi_cod and a.Audi_des=c.Audi_des and a.Tier=c.Tier
	
--Nation Level
--declare @maxMonth int
--declare @baracludeMS decimal(20,8)
--declare @runZhongMS decimal(20,8)

--select @maxMonth=max(X_Idx) from KPI_Frame_MarketAnalyzer_GenericsTrend
--select @baracludeMS=Y from KPI_Frame_MarketAnalyzer_GenericsTrend where Series in ('Baraclude MS(%)') and X_Idx=@maxMonth
--select @runZhongMS=Y from KPI_Frame_MarketAnalyzer_GenericsTrend where Series in ('Run zhong MS(%)') and X_Idx=@maxMonth

--insert into dbo.KPI_Frame_MarketAnalyzer_BMSBrandvsGenericBrand ( TimeFrame,MoneyType,Molecule,Class,mkt,Mktname,Market,
--	prod,Series,DataType,Category,Y,X,X_Idx,Series_Idx
--	)
--select distinct TimeFrame,MoneyType,Molecule,Class,mkt,Mktname,Market,
--	prod,Series,DataType,Category,@baracludeMS-@runZhongMS as Y,'China' as X,null as X_Idx,Series_Idx
--from KPI_Frame_MarketAnalyzer_BMSBrandvsGenericBrand

insert into dbo.KPI_Frame_MarketAnalyzer_BMSBrandvsGenericBrand ( TimeFrame,MoneyType,Molecule,Class,mkt,Mktname,Market,
    prod,Series,DataType,Category,Y,X,X_Idx,Series_Idx
    )
select 'MAT' as TimeFrame,a.MoneyType,a.Molecule,a.Class,a.mkt,a.Mktname,a.Market, 
    convert(varchar(200),null) as Prod,'vs. RunZ' as Series,
    convert(varchar(50),null) as DataType, convert(varchar(20),null) as Category,
    convert(decimal(20,8),case when c.MAT00 is null or c.MAT00=0 then 0 else 1.0*a.MAT00/c.MAT00-1.0*b.MAT00/c.MAT00 end) as Y,'China' as X, convert(int,null) as X_Idx, 1 as Series_Idx
from (
    select Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,MAT00   
    from  dbo.TempCHPAPreReports
    where Mkt='ARV' and Productname in ('Baraclude') and MoneyType='UN' and Molecule='N' and class='N'
  ) a join  (
    select Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,MAT00  
    from  dbo.TempCHPAPreReports
    where Mkt='ARV' and Productname in ('RUN ZHONG') and MoneyType='UN' and Molecule='N' and class='N'
  ) b  on a.Molecule=b.Molecule and a.Class=b.Class and a.Mkt=b.Mkt and a.Mktname=b.mktname and a.market=b.market 
    and a.MoneyType=b.MoneyType 
      join  (
    select Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,MAT00  
    from  dbo.TempCHPAPreReports
    where Mkt='ARV' and Prod='000' and MoneyType='UN' and Molecule='N' and class='N'
  ) c on a.Molecule=c.Molecule and a.Class=c.Class and a.Mkt=c.Mkt and a.Mktname=c.mktname and a.market=c.market 
    and a.MoneyType=c.MoneyType


--TierLevel
IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'TempBMSBrandvsGenericBrand') and type='U')
BEGIN
	DROP TABLE TempBMSBrandvsGenericBrand
END

SELECT Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,
'Tier '+convert(varchar(3),Tier)+' ('+convert(varchar(3),count(distinct Audi_des))+')' as Audi_Cod,
'Tier '+convert(varchar(3),Tier)+' ('+convert(varchar(3),count(distinct Audi_des))+')' as Audi_Des,
SUM(MAT00) as MAT00
INTO TempBMSBrandvsGenericBrand
FROM (
	select Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,Audi_Cod,Audi_des,
           case when Audi_des='Nanning' then 3 else Tier end as Tier, MAT00   
	from  dbo.tempCityDashboard_AllCity where mkt='arv' and MoneyType='UN' and Molecule='N' and Class='N'
		and tier is not null
) a
group by Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,Tier


insert into dbo.KPI_Frame_MarketAnalyzer_BMSBrandvsGenericBrand ( TimeFrame,MoneyType,Molecule,Class,mkt,Mktname,Market,
	prod,Series,DataType,Category,Y,X,X_Idx,Series_Idx
	)
select 'MAT' as TimeFrame,a.MoneyType,a.Molecule,a.Class,a.mkt,a.Mktname,a.Market, 
	convert(varchar(200),null) as Prod,'vs. RunZ' as Series,
	convert(varchar(50),null) as DataType, convert(varchar(20),null) as Category,
	convert(decimal(20,8),case when c.MAT00 is null or c.MAT00=0 then 0 else 1.0*a.MAT00/c.MAT00-1.0*b.MAT00/c.MAT00 end) as Y,a.Audi_des as X, convert(int,null) as X_Idx, 1 as Series_Idx
from (
	select Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,Audi_Cod,Audi_des, MAT00   
	from  dbo.TempBMSBrandvsGenericBrand
    where Mkt='ARV' and Productname in ('Baraclude') and MoneyType='UN' and Molecule='N' and class='N'
  ) a join  (
	select Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,Audi_Cod,Audi_des, MAT00   
	from  dbo.TempBMSBrandvsGenericBrand
    where Mkt='ARV' and Productname in ('RUN ZHONG') and MoneyType='UN' and Molecule='N' and class='N'
  ) b  on a.Molecule=b.Molecule and a.Class=b.Class and a.Mkt=b.Mkt and a.Mktname=b.mktname and a.market=b.market 
	and a.MoneyType=b.MoneyType and a.Audi_cod=b.Audi_cod and a.Audi_des=b.Audi_des 
	  join  (
	select Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,Audi_Cod,Audi_des, MAT00   
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



go
--Alince for adding YTD Share and YTD Share Change 2015-10-26

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_bk') and type='U')
BEGIN
	DROP TABLE KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp
END

select [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],[lev]
into KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA 
where x_idx in (5,6) and datatype='Growth'

delete from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA where x_idx in (5,6) and datatype='Growth'

--YTD Share
update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp 
set y=case when b.y =0 then 0 else 1.0*a.y/b.y 
end
from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp a
inner join 
(
select * from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp where prod='000') b
on a.timeframe=b.timeframe and a.moneytype=b.moneytype and a.mkt=b.mkt-- and a.molecule=b.molecule and a.class=b.class
and a.mktname=b.mktname and a.datatype=b.datatype and a.category=b.category and a.x=b.x
where a.mkt not in ('Eliquis','ONCFCS','HYP','ccb')

--YTD Share change
insert into KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],[lev])
select a.timeframe,a.moneytype,a.molecule,a.class,a.mkt,a.mktname,a.market,a.prod,a.series,a.datatype,a.category,a.y-b.y as  y, 'YTD Share Change' as X,b.x_idx,a.series_idx,a.lev
from 
(select * from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp where x_idx='5' ) a
inner join 
(select * from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp where x_idx='6') b
on a.timeframe=b.timeframe and a.moneytype=b.moneytype and a.mkt=b.mkt and a.molecule=b.molecule and a.class=b.class
and a.mktname=b.mktname and a.datatype=b.datatype and a.category=b.category and a.prod=b.prod 
and a.series=b.series
where a.mkt not in ('Eliquis','ONCFCS','HYP','ccb')

--Eliquis
--YTD Share
update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp 
set y=case when b.y =0 then 0 else 1.0*a.y/b.y 
end
from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp a
inner join 
(
select * from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp where prod='000') b
on a.timeframe=b.timeframe and a.moneytype=b.moneytype and a.mkt=b.mkt-- and a.molecule=b.molecule and a.class=b.class
and a.mktname=b.mktname and a.datatype=b.datatype and a.category=b.category and a.lev= b.lev and a.x=b.x
where a.mkt in ('Eliquis','HYP','ccb')
--
--taxol
--YTD Share
update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp 
set y=case when b.y =0 then 0 else 1.0*a.y/b.y 
end
from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp a
inner join 
(
select * from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp where prod='000') b
on a.timeframe=b.timeframe and a.moneytype=b.moneytype and a.mkt=b.mkt --and a.molecule=b.molecule and a.class=b.class
and a.mktname=b.mktname and a.datatype=b.datatype and a.category=b.category and a.lev= b.lev and a.x=b.x
where a.mkt in ('ONCFCS')
---


--Eliquis/taxol
--YTD Share change
insert into KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],[lev])
select a.timeframe,a.moneytype,a.molecule,a.class,a.mkt,a.mktname,a.market,a.prod,a.series,a.datatype,a.category,a.y-b.y as  y, 'YTD Share Change' as X,b.x_idx,a.series_idx,a.lev
from 
(select * from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp where x_idx='5' ) a
inner join 
(select * from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp where x_idx='6') b
on a.timeframe=b.timeframe and a.moneytype=b.moneytype and a.mkt=b.mkt --and a.molecule=b.molecule and a.class=b.class
and a.mktname=b.mktname and a.datatype=b.datatype and a.category=b.category and a.prod=b.prod 
and a.series=b.series and a.lev=b.lev
where a.mkt in ('Eliquis','ONCFCS','HYP','ccb')

delete from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp where x='YTD12 Share'


update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp 
set x='YTD Share'
where x='YTD00 Share'

insert into KPI_Frame_MarketAnalyzer_IMSAudit_CHPA([TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],[lev])
select [TimeFrame] ,[Moneytype] ,[Molecule],[Class],[Mkt] ,[Mktname],[Market]
      ,[Prod] ,[Series] ,[DataType] ,[Category],[Y] ,[X] ,[X_Idx],[Series_Idx],[lev] from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp

select * from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA_temp
------------------------------------------Alince for adding YTD Share and YTD Share Change 2015-10-26 end

update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA
set Category_Idx = case when category='Value' then 1
						when category='Volume' then 2 end

update a 						
set a.x= convert(varchar(5),b.year)+left(b.MonthEN,3)
from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA a join tblMonthList b on convert(int,right(a.x,2))+1=b.MonSeq
where a.DataType='Share'


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
from MTHCITY_PKAU 
where pack_cod in( 
		select distinct pack_cod from tblMktDef_MRBIChina 
		where Prod_Name in ('Byetta') and Molecule='N' and class='N'
		and Mkt='NIAD' 
	) and city_ID in
	(	select city_ID from dbo.Dim_City 
		where City_Name in (select City_En from dbo.PRDL_Province_City_Mapping)
	)
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
from MTHCITY_PKAU 
where pack_cod in( 
	select pack_cod from tblMktDef_MRBIChina where Prod_Name in ('Victoza') and Molecule='N' and class='N' and Prod='000'
	and Mkt='NIAD') and city_ID in
	(select city_ID from dbo.Dim_City where City_Name in
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
select a.*,cast(replace(date,'Mth','') as int) as Idx
into Temp 
from db36.BMSChinaCSR_Testing.dbo.OutputCIA a
inner join dim_city b
on a.citynameen=b.city_name
where YM <=(select value from config where Parameter = 'IMS') and ActualSales<>0  and market<>'total'
union
select *,cast(replace(date,'Mth','') as int) as Idx
from db36.BMSChinaCSR_Testing.dbo.OutputCIA a
where YM <=(select value from config where Parameter = 'IMS') and ActualSales<>0  and market='total'
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
	     when DataType='Growth' and Series='Tenofovir' then 7
	     when DataType='Growth' and Series='Total ETV' then 8
	     when DataType='Growth' and Series='Total ADV' then 9
	     when DataType='Share' and Series='ARV Market' then 1
	     when DataType='Share' and Series='Baraclude' then 2
	     when DataType='Share' and Series='Entecavir Run Zhong' then 3
	     when DataType='Share' and Series='Hepsera' then 4
	     when DataType='Share' and Series='Heptodin' then 5
	     when DataType='Share' and Series='Sebivo' then 6
	     when DataType='Share' and Series='Tenofovir' then 7
	     when DataType='Share' and Series='Total ETV' then 8
	     when DataType='Share' and Series='Other ETV Total' then 9
	     when DataType='Share' and Series='Total ADV' then 10 end
 where market='baraclude'
go

update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA 
set series='Viread'
where series='Tenofovir'

delete from KPI_Frame_MarketAnalyzer_IMSAudit_CHPA where Series_Idx is null



--Alince Wang 2015-12-11 adding for KPI_Frame_ChinaMarket_Brandview data



IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_ChinaMarket_Brandview_data_temp') and type='U')
BEGIN
	DROP TABLE KPI_Frame_ChinaMarket_Brandview_data_temp
END

select RANK ( )OVER (order by sum(MTH00US) desc ) as Rank_mth,RANK ( )OVER (order by sum(YTD00US) desc ) as Rank_ytd,CORP_cod,sum(MTH00US) as MTH00US,sum(MTH12US) as MTH12US,sum(ytd00US) as ytd00US,sum(ytd12US) as ytd12US
into KPI_Frame_ChinaMarket_Brandview_data_temp
from dbo.MTHCHPA_PKAU A
where exists(select * from MTHCHPA_PKAU B  
where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD IN ('I','J'))
group by CORP_cod


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_ChinaMarket_Brandview_data') and type='U')
BEGIN
	DROP TABLE KPI_Frame_ChinaMarket_Brandview_data
END

select 'MTH' AS period,'US' as moneytype,cast(null as varchar(20)) as [Ranking in MNC(mth)],cast(null as varchar(20)) as [Ranking in MNC(ytd)],'Total China Hospital Market' as series,
case isnull(sum(MTH12US),0) when 0 then cast(0 as varchar(20)) else cast((isnull(sum(MTH00US),0)-isnull(sum(MTH12US),0))*1.0/isnull(sum(MTH12US),0) as varchar(20)) end  as  [Growth(Y2Y)(mth)],
case isnull(sum(YTD12US),0) when 0 then cast(0 as varchar(20)) else cast((isnull(sum(YTD00US),0)-isnull(sum(YTD12US),0))*1.0/isnull(sum(YTD12US),0) as varchar(20)) end  as  [Growth(Y2Y)(ytd)],
cast(null as varchar(20)) as CORP_Cod,cast(null as varchar(20)) as Prod_Cod
into KPI_Frame_ChinaMarket_Brandview_data
from dbo.MTHCHPA_Pkau
union

select 'MTH' AS period,'US' as moneytype,cast(null as varchar(20)) as [Ranking in MNC(mth)],cast(null as varchar(20)) as [Ranking in MNC(ytd)],'China Market' as series,
cast(0 as varchar(20)) ,cast(0 as varchar(20)),null,null
union
select 'MTH' AS period,'US' as moneytype,cast(null as varchar(20)) as [Ranking in MNC(mth)],cast(null as varchar(20)) as [Ranking in MNC(ytd)],'Total MNC Company' as series,
case isnull(sum(MTH12US),0) when 0 then cast(0 as varchar(20))else cast((isnull(sum(MTH00US),0)-isnull(sum(MTH12US),0))*1.0/isnull(sum(MTH12US),0) as varchar(20)) end  as [Growth(Y2Y)(mth)],
case isnull(sum(YTD12US),0) when 0 then cast(0 as varchar(20)) else cast((isnull(sum(YTD00US),0)-isnull(sum(YTD12US),0))*1.0/isnull(sum(YTD12US),0) as varchar(20)) end  as [Growth(Y2Y)(ytd)],
null,null
from dbo.MTHCHPA_Pkau A
where exists(select * from MTHCHPA_PKAU B  
		where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD in('I','J')) 
union
select 'MTH' AS period,'US' as moneytype,cast(null as varchar(20)) as [Ranking in MNC(mth)],cast(null as varchar(20)) as [Ranking in MNC(ytd)],'BMS' as series,
cast(0 as varchar(20)) ,cast(0 as varchar(20)),null,null
union
--insert into KPI_Frame_ChinaMarket_Brandview_data

select  'MTH' AS period,'US' as moneytype,cast(null as varchar(20)) as [Ranking in MNC(mth)],cast(null as varchar(20)) as [Ranking in MNC(ytd)],'Company view:  BMS' as series ,
case isnull(MTH12US,0) when 0 then cast(0 as varchar(20)) else cast(cast((isnull(MTH00US,0)-isnull(MTH12US,0))*1.0/isnull(MTH12US,0) as decimal(12,10)) as varchar(20)) end  as [Growth(Y2Y)(mth)],
case isnull(YTD12US,0) when 0 then cast(0 as varchar(20)) else  cast((isnull(YTD00US,0)-isnull(YTD12US,0))*1.0/isnull(YTD12US,0) as varchar(20)) end  as [Growth(Y2Y)(ytd)],c.corp_cod as corp_cod,null
from KPI_Frame_ChinaMarket_Brandview_data_temp a
inner join (select distinct corp_cod,prod_cod from  MTHCHPA_PKAU) c
on a.corp_cod=c.corp_cod
inner join dim_product b
on b.product_code=c.prod_cod
where b.product_name='baraclude'
union
select 'MTH' AS period,'US' as moneytype,cast(null as varchar(20)) as [Ranking in MNC(mth)],cast(null as varchar(20)) as [Ranking in MNC(ytd)],'Brand view:  Baraclude' as series,
case isnull(sum(MTH12US),0) when 0 then cast(0 as varchar(20)) else cast((isnull(sum(MTH00US),0)-isnull(sum(MTH12US),0))*1.0/isnull(sum(MTH12US),0) as varchar(20))end  as [Growth(Y2Y)(mth)],
case isnull(sum(YTD12US),0) when 0 then cast(0 as varchar(20)) else cast((isnull(sum(YTD00US),0)-isnull(sum(YTD12US),0))*1.0/isnull(sum(YTD12US),0) as varchar(20)) end  as [Growth(Y2Y)(ytd)],
null as CORP_Cod,30173 as Prod_Cod
from dbo.MTHCHPA_PKAU A where Prod_Cod like '%30173%'

GO
select * from KPI_Frame_ChinaMarket_Brandview_data
update KPI_Frame_ChinaMarket_Brandview_data set [Ranking in MNC(ytd)]=B.Rank_ytd 
from KPI_Frame_ChinaMarket_Brandview_data A 
inner join KPI_Frame_ChinaMarket_Brandview_data_temp B
on A.CORP_cod=B.CORP_cod
			
		
update KPI_Frame_ChinaMarket_Brandview_data set [Ranking in MNC(mth)]=B.Rank_mth
from KPI_Frame_ChinaMarket_Brandview_data A 
inner join KPI_Frame_ChinaMarket_Brandview_data_temp b
on a.corp_cod=b.corp_cod

--remove the two products('PULMICORT RESP','ALBUMIN HUMAN') to improve the rank of Baraclude 
update KPI_Frame_ChinaMarket_Brandview_data
		set [Ranking in MNC(YTD)]=B.Rank from KPI_Frame_ChinaMarket_Brandview_data A inner join (
							select RANK ( )OVER (order by sum(YTD00US) desc ) as Rank,PROD_cod,sum(YTD00US) as YTD00US
							from dbo.MTHCHPA_PKAU A 
							inner join dim_product b
							on a.prod_cod=b.product_code
							where CORP_Cod in(select CORP_Cod from KPI_Frame_ChinaMarket_Brandview_data_temp)  and product_name not in ('PULMICORT RESP','ALBUMIN HUMAN')
							group by PROD_cod) B
		on A.PROD_cod=B.PROD_cod


update KPI_Frame_ChinaMarket_Brandview_data
		set [Ranking in MNC(MTH)]=B.Rank from KPI_Frame_ChinaMarket_Brandview_data A inner join (
							select RANK ( )OVER (order by sum(MTH00US) desc ) as Rank,PROD_cod,sum(MTH00US) as MTH00US
							from dbo.MTHCHPA_PKAU A 
							inner join dim_product b
							on a.prod_cod=b.product_code
							where CORP_Cod in(select CORP_Cod from KPI_Frame_ChinaMarket_Brandview_data_temp)  and product_name not in ('PULMICORT RESP','ALBUMIN HUMAN')
							group by PROD_cod) B
		on A.PROD_cod=B.PROD_cod


update KPI_Frame_ChinaMarket_Brandview_data set [Ranking in MNC(mth)]='0',[Ranking in MNC(ytd)]='0' where [Ranking in MNC(mth)] is null or [Ranking in MNC(ytd)] is null
GO
IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_ChinaMarket_Brandview') and type='U')
BEGIN
	DROP TABLE KPI_Frame_ChinaMarket_Brandview
END

select series, Y,X,
case when Series='China Market' then 1
	 when Series='Total China Hospital Market' then 2
	 when Series='Total MNC Company' then 3
	 when Series='BMS' then 4 
	 when series='Company view:  BMS' then 5
	 when series='Brand view:  Baraclude' then 6
	 end as Series_Idx
 into KPI_Frame_ChinaMarket_Brandview
 from
(
select series,[Ranking in MNC(ytd)],[Ranking in MNC(mth)],[Growth(Y2Y)(mth)],[Growth(Y2Y)(ytd)]
from KPI_Frame_ChinaMarket_Brandview_data
)a 
unpivot (
	Y for X in ([Ranking in MNC(ytd)],[Ranking in MNC(mth)],[Growth(Y2Y)(mth)],[Growth(Y2Y)(ytd)])
 ) T


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_ChinaMarket_Brandview_X') and type='U')
BEGIN
	DROP TABLE KPI_Frame_ChinaMarket_Brandview_X
END

select series,case when (series='Total China Hospital Market'or series='Total MNC Company') and( x='Ranking in MNC(mth)' or x='Ranking in MNC(ytd)' )then '/' else y end as y,x,series_idx,
case when x='Ranking in MNC(mth)' then '1'
				when x='Growth(Y2Y)(mth)' then '2'
				when x='Ranking in MNC(ytd)' then '3'
				when x='Growth(Y2Y)(ytd)' then '4'end as x_idx
into KPI_Frame_ChinaMarket_Brandview_X
from KPI_Frame_ChinaMarket_Brandview

update KPI_Frame_ChinaMarket_Brandview_X set y='#'+y where series='Company view:  BMS' and (x='Ranking in MNC(ytd)' or x='Ranking in MNC(mth)')
update KPI_Frame_ChinaMarket_Brandview_X set y='#'+y where series='Brand view:  Baraclude'  and (x='Ranking in MNC(ytd)' or x='Ranking in MNC(mth)')

--KPI_Frame_ChinaMarket_Brandview_data_middle
IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_ChinaMarket_Brandview_data_middle') and type='U')
BEGIN
	DROP TABLE KPI_Frame_ChinaMarket_Brandview_data_middle
END

select  'Baralcude' as series,b.mth00/a.mth00 as [Market Share(mth)],(b.mth00-b.mth12)/b.mth12 as [ Growth (Y2Y)(MTH)],b.YTD00/a.ytd00 as [Market Share(YTD)],
(b.YTD00-b.YTD12)/b.YTD12 as [Growth (Y2Y)(ytd)],(a.MTH00-a.MTH12)/a.MTH12 as [Total Market Growth(Y2Y)(MTH)],
(a.YTD00-a.YTD12)/a.YTD12 as [Total Market Growth(Y2Y)(ytd)]
into KPI_Frame_ChinaMarket_Brandview_data_middle
from TempCHPAPreReports_For_Baraclude a
inner join TempCHPAPreReports_For_Baraclude b
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
	and A.Market=B.Market and A.prod='000' and B.prod<>'000'
	where ((B.class='N' and B.Molecule='N') or (b.molecule='Y' and b.class='N' and b.market='baraclude' and b.productname in ('Entecavir','Adefovir Dipivoxil','Tenofovir Disoproxil'))) and b.Moneytype IN ('US','UN') and b.Mktname in ('ARV Market') and b.productname not in ('ARV Others')
		and a.moneytype='US'   AND b.productname IN ('baraclude')
union
select  'Glucophage' as series,a.MTH00US/b.MTH00US_total,(a.MTH00US-a.MTH12US)/a.MTH12US,a.YTD00US/b.YTD00US_total,
(YTD00US-YTD12US)/YTD12US,(MTH00US_total-MTH12US_total)/MTH12US_total,(YTD00US_total-YTD12US_total)/YTD12US_total
from 
(
select  sum(MTH00US) as MTH00US,sum(MTH12US) as MTH12US,sum(YTD00US) as YTD00US,sum(YTD12US) as YTD12US
from MTHCHPA_Pkau a inner join tblMktDef_MRBIChina b
on a.pack_cod=b.pack_cod	 
where b.mkt='NIAD' and b.productname='Glucophage' and B.prod<>'000' and B.Active='Y' and Molecule='N' and class='N'
) a,(
select sum(MTH00US) as MTH00US_total,sum(MTH12US) as MTH12US_total,sum(YTD00US) as YTD00US_total,sum(YTD12US) as YTD12US_total
from MTHCHPA_Pkau a inner join tblMktDef_MRBIChina b
on a.pack_cod=b.pack_cod
where b.mkt='NIAD' and B.prod='000'and B.Active='Y' and Molecule='N' and class='N'
)b

union
select 'Eliquis (CHPA)' as series,b.mth00/a.mth00,(b.mth00-b.mth12)/b.mth12,b.YTD00/a.YTD00,(b.YTD00-b.YTD12)/b.YTD12,(a.mth00-a.mth12)/a.mth12,(a.YTD00-a.YTD12)/a.YTD12
from KPI_Frame_TempCHPAReports_For_Eliquis a 
inner join KPI_Frame_TempCHPAReports_For_Eliquis b
on a.molecule=b.molecule and a.class= b.class and a.mkt=b.mkt
where a.prod='000' and b.productname='ELIQUIS' and a.moneytype='US' and b.moneytype='US' and b.prod not in('000' ,'101')
and b.Molecule='N' and b.Class='N'

union
select 'Eliquis (7 Focus City)' as series,b.mth00/a.mth00,(b.mth00-b.mth12)/b.mth12,b.YTD00/a.YTD00,(b.YTD00-b.YTD12)/b.YTD12,(a.mth00-a.mth12)/a.mth12,(a.YTD00-a.YTD12)/a.YTD12
from TempFocusCityReports_For_Eliquis a 
inner join TempFocusCityReports_For_Eliquis b
on a.molecule=b.molecule and a.class= b.class and a.mkt=b.mkt
where a.prod='000' and b.productname='ELIQUIS' and a.moneytype='US' and b.moneytype='US' and b.prod not in('000' ,'101')
and b.Molecule='N' and b.Class='N'

union 

select 'Eliquis NOAC (CHPA)' as series,b.mth00/a.mth00,(b.mth00-b.mth12)/b.mth12,b.YTD00/a.YTD00,(b.YTD00-b.YTD12)/b.YTD12,(a.mth00-a.mth12)/a.mth12,(a.YTD00-a.YTD12)/a.YTD12
from TempCHPAReports_For_Eliquis_NOAC a 
inner join TempCHPAReports_For_Eliquis_NOAC b
on a.molecule=b.molecule and a.class= b.class and a.mkt=b.mkt
where a.prod='000' and b.prod<>'000' and b.productname='ELIQUIS' and a.moneytype='US' and b.moneytype='US'

union 

select 'Eliquis NOAC (7 Focus City)' as series,b.mth00/a.mth00,(b.mth00-b.mth12)/b.mth12,b.YTD00/a.YTD00,(b.YTD00-b.YTD12)/b.YTD12,(a.mth00-a.mth12)/a.mth12,(a.YTD00-a.YTD12)/a.YTD12
from TempFocusCityReports_For_Eliquis_NOAC a 
inner join TempFocusCityReports_For_Eliquis_NOAC b
on a.molecule=b.molecule and a.class= b.class and a.mkt=b.mkt
where a.prod='000' and b.prod<>'000' and b.productname='ELIQUIS' and a.moneytype='US' and b.moneytype='US'

union 

select 'Coniel (CHPA)' as series,a.mth00/b.mth00,(a.mth00-a.mth12)/a.mth12,a.YTD00/b.YTD00,(a.ytd00-a.ytd12)/a.ytd12,(B.MTH00-B.MTH12)/B.MTH12,(B.YTD00-B.YTD12)/B.YTD12
from TempCHPAPreReports_For_CCB a
inner join TempCHPAPreReports_For_CCB b
on a.molecule=b.molecule and a.class=b.class and a.mkt=b.mkt and a.moneytype=b.moneytype
where a.prod<>'000' and a.productname='CONIEL' and a.moneytype='US' and b.prod='000'

union

select 'Coniel (7 Focus City)' as series,a.mth00/b.mth00,(a.mth00-a.mth12)/a.mth12,a.YTD00/b.YTD00,(a.ytd00-a.ytd12)/a.ytd12,(B.MTH00-B.MTH12)/B.MTH12,(B.YTD00-B.YTD12)/B.YTD12
from TempFocusCityReports_For_Coniel a
inner join TempFocusCityReports_For_Coniel b
on a.molecule=b.molecule and a.class=b.class and a.mkt=b.mkt and a.audi_des=b.audi_des and a.moneytype=b.moneytype
where a.prod<>'000' and a.productname='CONIEL' and a.moneytype='US' and b.prod='000'
union

select 'Monopril (CHPA)' as series,a.mth00/b.mth00,(a.mth00-a.mth12)/a.mth12,a.YTD00/b.YTD00,(a.ytd00-a.ytd12)/a.ytd12,(B.MTH00-B.MTH12)/B.MTH12,(B.YTD00-B.YTD12)/B.YTD12
from TempCHPAPreReports a
inner join TempCHPAPreReports b
on a.molecule=b.molecule and a.class=b.class and a.mkt=b.mkt and a.moneytype=b.moneytype and a.market=b.market
where a.prod<>'000' and a.productname='Monopril' and a.moneytype='US' and b.prod='000' and a.market='Monopril' and a.mkt='hyp'

union
select 'Monopril (7 Focus City)' as series,a.mth00/b.mth00,(a.mth00-a.mth12)/a.mth12,a.YTD00/b.YTD00,(a.ytd00-a.ytd12)/a.ytd12,(B.MTH00-B.MTH12)/B.MTH12,(B.YTD00-B.YTD12)/B.YTD12
from TempFocusCityReports_For_Monopril a
inner join TempFocusCityReports_For_Monopril b
on a.molecule=b.molecule and a.class=b.class and a.mkt=b.mkt and a.audi_des=b.audi_des and a.moneytype=b.moneytype
where a.prod<>'000' and a.audi_des='FocusCity' and a.productname='Monopril' and a.moneytype='US' and b.prod='000'

union

select 'Taxol (CHPA)' as series,sum(a.MTH00)/sum(b.MTH00),(sum(a.MTH00)-sum(a.MTH12))/sum(a.MTH12),sum(a.YTD00)/sum(b.YTD00),(sum(a.YTD00)-sum(a.YTD12))/sum(a.YTD12),(SUM(B.MTH00)-SUM(B.MTH12))/SUM(B.MTH12),
(SUM(B.YTD00)-SUM(B.YTD12))/SUM(B.YTD12)
from TempCHPAPreReports a inner join TempCHPAPreReports b
on a.molecule=b.molecule and a.class=b.class and a.mkt=b.mkt and a.mktname=b.mktname and a.moneytype=b.moneytype
where a.prod<>'000' and  a.moneytype='US' and b.prod='000' and a.productname='Taxol'

union
select 'Taxol (7 Focus City)' as series,sum(a.MTH00)/sum(b.MTH00),(sum(a.MTH00)-sum(a.MTH12))/sum(a.MTH12),sum(a.YTD00)/sum(b.YTD00),(sum(a.YTD00)-sum(a.YTD12))/sum(a.YTD12),(SUM(B.MTH00)-SUM(B.MTH12))/SUM(B.MTH12),
(SUM(B.YTD00)-SUM(B.YTD12))/SUM(B.YTD12)
from TempCityDashboard a inner join TempCityDashboard b
on a.molecule=b.molecule and a.class=b.class and a.mkt=b.mkt and a.mktname=b.mktname and a.moneytype=b.moneytype and a.audi_des=b.audi_des
inner join dim_city c
on a.audi_des=c.city_name
where a.prod<>'000' and  a.moneytype='US' and b.prod='000' and a.productname='Taxol'

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_ChinaMarket_Brandview_product') and type='U')
BEGIN
	DROP TABLE KPI_Frame_ChinaMarket_Brandview_product
END


select series, Y,X,
case when Series='Baralcude' then 1
	 when Series='Glucophage' then 2
	 when Series='Eliquis (7 Focus City)' then 8
	 when Series='Eliquis (CHPA)' then 3	 
	 when Series='Eliquis NOAC (7 Focus City)' then 9
	 when Series='Eliquis NOAC (CHPA)' then 4 	 
	 when series='Coniel (7 Focus City)' then 10
	 when series='Coniel (CHPA)' then 5	 
	 when series='Monopril (7 Focus City)' then 11
	 when series='Monopril (CHPA)' then 6	 
	 when series='Taxol (7 Focus City)' then 12
	 when series='Taxol (CHPA)' then 7	 
	 end as Series_Idx
 into KPI_Frame_ChinaMarket_Brandview_product
 from
(
select series,[Market Share(mth)],[ Growth (Y2Y)(MTH)],[Market Share(YTD)],[Growth (Y2Y)(ytd)],[Total Market Growth(Y2Y)(MTH)],[Total Market Growth(Y2Y)(ytd)]
from KPI_Frame_ChinaMarket_Brandview_data_middle
)a 
unpivot (
	Y for X in ([Market Share(mth)],[ Growth (Y2Y)(MTH)],[Market Share(YTD)],[Growth (Y2Y)(ytd)],[Total Market Growth(Y2Y)(MTH)],[Total Market Growth(Y2Y)(ytd)])
 ) T
 
GO
 IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID= OBJECT_ID(N'KPI_Frame_ChinaMarket_Brandview_product_x') and type='U')
BEGIN
	DROP TABLE KPI_Frame_ChinaMarket_Brandview_product_x
END
 
 select *,case when x='Market Share(mth)' then '1'
				when x=' Growth (Y2Y)(mth)' then '2'
				when x='Market Share(YTD)' then '3'
				when x='Growth (Y2Y)(YTD)' then '4'
				when x='Total Market Growth(Y2Y)(mth)' then '5'
				when x='Total Market Growth(Y2Y)(YTD)' then '6'			
				end as x_idx
into KPI_Frame_ChinaMarket_Brandview_product_x
from KPI_Frame_ChinaMarket_Brandview_product


--MNC Company Ranking 20160901
IF OBJECT_ID(N'KPI_Frame_MNC_Company_Ranking_data',N'U') IS NOT NULL

DROP TABLE KPI_Frame_MNC_Company_Ranking_data
go
select top 15 cast('MTH' as varchar(20)) as [Period],1 as CurrRank,1 as PrevRank,CORP_cod,replace(replace(b.Manufacturer_Name,' GROUP',''),' GRP','') as corp_des,
		sum(MTH00US) as MTH00US,sum(MTH12US) as MTH12US
into KPI_Frame_MNC_Company_Ranking_data
		from dbo.MTHCHPA_PKAU A 
		INNER JOIN Dim_Manufacturer b
		on A.CORP_cod=B.Corporation_ID
		and B.Manufacturer_ID=B.Corporation_ID
		where exists(select * from MTHCHPA_PKAU B  
		where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD IN ('I','J'))
		group by CORP_cod,b.Manufacturer_Name
		order by
		sum(MTH00US) desc

INSERT INTO KPI_Frame_MNC_Company_Ranking_data
select top 15 cast('YTD' as varchar(20)) as [Period],1 as CurrRank,1 as PrevRank,CORP_cod,replace(replace(b.Manufacturer_Name,' GROUP',''),' GRP','') as corp_des,
		sum(YTD00US) as YTD00US,sum(YTD12US) as YTD12US
		from dbo.MTHCHPA_PKAU A 
		INNER JOIN Dim_Manufacturer b
		on A.CORP_cod=B.Corporation_ID
		and B.Manufacturer_ID=B.Corporation_ID
		where exists(select * from MTHCHPA_PKAU B  
		where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD IN ('I','J'))
		group by CORP_cod,b.Manufacturer_Name
		order by
		sum(YTD00US) desc
go

update KPI_Frame_MNC_Company_Ranking_data
		set CurrRank=B.Rank from KPI_Frame_MNC_Company_Ranking_data A inner join (
							select RANK ( )OVER (order by sum(MTH00US) desc ) as Rank,CORP_cod,sum(MTH00US) as MTH00US
							from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
								where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD IN ('I','J'))
							group by CORP_cod) B
		on A.CORP_cod=B.CORP_cod and A.[Period]='MTH'

update KPI_Frame_MNC_Company_Ranking_data
		set CurrRank=B.Rank from KPI_Frame_MNC_Company_Ranking_data A inner join (
							select RANK ( )OVER (order by sum(YTD00US) desc ) as Rank,CORP_cod,sum(YTD00US) as YTD00US
							from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
								where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD IN ('I','J'))
							group by CORP_cod) B
		on A.CORP_cod=B.CORP_cod and A.[Period]='YTD'

update KPI_Frame_MNC_Company_Ranking_data
		set PrevRank=B.Rank from KPI_Frame_MNC_Company_Ranking_data A inner join (
							select RANK ( )OVER (order by sum(MTH12US) desc ) as Rank,CORP_cod,sum(MTH12US) as MTH12US
							from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
								where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD IN ('I','J'))
							group by CORP_cod) B
		on A.CORP_cod=B.CORP_cod and A.[Period]='MTH' 

update KPI_Frame_MNC_Company_Ranking_data
		set PrevRank=B.Rank from KPI_Frame_MNC_Company_Ranking_data A inner join (
							select RANK ( )OVER (order by sum(YTD12US) desc ) as Rank,CORP_cod,sum(YTD12US) as YTD12US
							from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
								where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD IN ('I','J'))
							group by CORP_cod) B
		on A.CORP_cod=B.CORP_cod and A.[Period]='YTD' 

ALTER TABLE KPI_Frame_MNC_Company_Ranking_data ADD Series_Idx varchar(10),X_Idx varchar(10),[Y2Y GR] float
go
update  KPI_Frame_MNC_Company_Ranking_data set [Y2Y GR]=(MTH00US-MTH12US)/MTH12US

update KPI_Frame_MNC_Company_Ranking_data set Series_Idx=currrank

IF OBJECT_ID(N'KPI_Frame_MNC_Company_Ranking_temp',N'U') IS NOT NULL

drop table KPI_Frame_MNC_Company_Ranking_temp
go
SELECT period,CORP_cod,CORP_Des,x,y,series_Idx,X_idx,currRank,PrevRank
into KPI_Frame_MNC_Company_Ranking_temp
from
(
select period,currRank,PrevRank,CORP_cod,CORP_Des,MTH00US,MTH12US,[Y2Y GR],series_Idx,X_idx
from KPI_Frame_MNC_Company_Ranking_data
)a
unpivot (
Y  for X in (MTH00US,MTH12US,[Y2Y GR])
) T

IF OBJECT_ID(N'KPI_Frame_MNC_Company_Ranking_temp2',N'U') IS NOT NULL
drop table KPI_Frame_MNC_Company_Ranking_temp2
go
select period,CORP_cod,CORP_Des,x,y,temp_x,temp_y,series_Idx,X_idx
into KPI_Frame_MNC_Company_Ranking_temp2
from (
select * from KPI_Frame_MNC_Company_Ranking_temp )a
unpivot
(
temp_y for temp_x IN(currRank,PrevRank)
) t

IF OBJECT_ID(N'KPI_Frame_MNC_Company_Ranking',N'U') IS NOT NULL
drop table KPI_Frame_MNC_Company_Ranking
go
select period,corp_des,x,y,series_idx,x_idx into KPI_Frame_MNC_Company_Ranking from KPI_Frame_MNC_Company_Ranking_temp2 where 1=0

insert into KPI_Frame_MNC_Company_Ranking
select period,corp_des,x,y,series_Idx,X_Idx from KPI_Frame_MNC_Company_Ranking_temp2 
union 
select period,corp_des,temp_x,temp_y,series_Idx,X_Idx from KPI_Frame_MNC_Company_Ranking_temp2 

update a set x_idx=case when x='MTH00US' then 1
						when x='MTH12US' then 2
						when x='Y2Y GR' then 3
						when x='PrevRank' then 4
						when x='currRank' then 5
						end
from KPI_Frame_MNC_Company_Ranking a

update a set x=case when right(left(x,5),2)='00' then period+' '+(select monthen from tblmonthlist where monseq=1) 
				  when right(left(x,5),2)='12' then period+' '+(select monthen from tblmonthlist where monseq=13)
				  when X='currRank' then period+' '+(select monthen from tblmonthlist where monseq=1)+' Ranking'
				  when X='PrevRank' then period+' '+(select monthen from tblmonthlist where monseq=13)+' Ranking'
				  else x end
from KPI_Frame_MNC_Company_Ranking a

--MNC Brand Ranking
IF OBJECT_ID(N'KPI_Frame_MNC_Brand_Ranking_data',N'U') IS NOT NULL
	DROP TABLE KPI_Frame_MNC_Brand_Ranking_data
	go

	select top 14 cast('MTH' as varchar(20)) as [Period],1 as CurrRank,1 as PrevRank,a.Prod_cod,b.product_name,
	sum(MTH00US) as MTH00US ,sum(MTH12US) as MTH12US
	into KPI_Frame_MNC_Brand_Ranking_data
	from MTHCHPA_PKAU  a
	inner join dim_product b
	on A.Prod_cod=B.product_code
	where exists(select * from MTHCHPA_PKAU B  where A.PROD_COD=B.PROD_COD and B.MNFL_COD IN ('I','J')) and b.product_name not in ('PULMICORT RESP','ALBUMIN HUMAN')
	group by a.Prod_cod,b.product_name
	order by
	sum(MTH00US) desc

	if exists(select * from KPI_Frame_MNC_Brand_Ranking_data 
		where product_name like '%GLUCOPHAGE%' and period='MTH')
	print 'GLUCOPHAGE in Top 14 MTH US'
	else
	insert into KPI_Frame_MNC_Brand_Ranking_data
	select 'YTD',1,1,'06470',b.product_name, sum(YTD00US),sum(YTD12US)
	from dbo.MTHCHPA_PKAU A 
	inner join dim_product b
	on A.Prod_cod=B.Product_code
	where product_name like '%GLUCOPHAGE%'
	group by b.product_name

insert into KPI_Frame_MNC_Brand_Ranking_data
	select top 14 cast('YTD' as varchar(20)) as [Period],1 as CurrRank,1 as PrevRank,a.Prod_cod,b.product_name,
		sum(YTD00US) as YTD00US ,sum(YTD12US) as YTD12US
		from MTHCHPA_PKAU  a
		inner join dim_product b
		on A.Prod_cod=B.Product_code
		where exists(select * from MTHCHPA_PKAU B  where A.PROD_COD=B.PROD_COD and B.MNFL_COD IN ('I','J')) and b.product_name not in ('PULMICORT RESP','ALBUMIN HUMAN')
		group by a.Prod_cod,b.product_name
		order by
		sum(YTD00US) desc

if exists(select * from KPI_Frame_MNC_Brand_Ranking_data 
	where product_name like '%GLUCOPHAGE%' and period='YTD')
	print 'GLUCOPHAGE in Top 14 MTH US'
else
	insert into KPI_Frame_MNC_Brand_Ranking_data
	select 'YTD',1,1,'06470',b.product_name, sum(YTD00US),sum(YTD12US)
	from dbo.MTHCHPA_PKAU A 
	inner join dim_product b
	on A.Prod_cod=B.Product_code
	where product_name like '%GLUCOPHAGE%'
	group by b.product_name


	
	update KPI_Frame_MNC_Brand_Ranking_data
			set CurrRank=B.Rank from KPI_Frame_MNC_Brand_Ranking_data A inner join (
								select RANK ( )OVER (order by sum(MTH00US) desc ) as Rank,PROD_COD,sum(MTH00US) as MTH00US
								from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
									where A.PROD_COD=B.PROD_COD and B.MNFL_COD IN ('I','J'))
								group by PROD_COD) B
			on A.PROD_COD=B.PROD_COD and A.[Period]='MTH'
	
	update KPI_Frame_MNC_Brand_Ranking_data
			set CurrRank=B.Rank from KPI_Frame_MNC_Brand_Ranking_data A inner join (
								select RANK ( )OVER (order by sum(YTD00US) desc ) as Rank,PROD_COD,sum(YTD00US) as YTD00US
								from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
									where A.PROD_COD=B.PROD_COD and B.MNFL_COD IN ('I','J'))
								group by PROD_COD) B
			on A.PROD_COD=B.PROD_COD and A.[Period]='YTD'
	
	update KPI_Frame_MNC_Brand_Ranking_data
			set PrevRank=B.Rank from KPI_Frame_MNC_Brand_Ranking_data A inner join (
								select RANK ( )OVER (order by sum(MTH12US) desc ) as Rank,PROD_COD,sum(MTH12US) as MTH12US
								from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
									where A.PROD_COD=B.PROD_COD and B.MNFL_COD IN ('I','J'))
								group by PROD_COD) B
			on A.PROD_COD=B.PROD_COD and A.[Period]='MTH' 
	
	update KPI_Frame_MNC_Brand_Ranking_data
			set PrevRank=B.Rank from KPI_Frame_MNC_Brand_Ranking_data A inner join (
								select RANK ( )OVER (order by sum(YTD12US) desc ) as Rank,PROD_COD,sum(YTD12US) as YTD12US
								from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
									where A.PROD_COD=B.PROD_COD and B.MNFL_COD IN ('I','J'))
								group by PROD_COD) B
			on A.PROD_COD=B.PROD_COD and A.[Period]='YTD' 
	
	ALTER TABLE KPI_Frame_MNC_Brand_Ranking_data ADD Series_Idx varchar(10),X_Idx varchar(10),[Y2Y GR] float
	go
	update  KPI_Frame_MNC_Brand_Ranking_data set [Y2Y GR]=(MTH00US-MTH12US)/MTH12US
	
	update KPI_Frame_MNC_Brand_Ranking_data set Series_Idx=currrank

	go
	
	IF OBJECT_ID(N'KPI_Frame_MNC_Brand_Ranking_temp',N'U') IS NOT NULL
	
	drop table KPI_Frame_MNC_Brand_Ranking_temp
	go
	SELECT period,prod_cod,product_name,x,y,series_Idx,X_idx,currRank,PrevRank
	into KPI_Frame_MNC_Brand_Ranking_temp
	from
	(
	select period,currRank,PrevRank,prod_cod,product_name,MTH00US,MTH12US,[Y2Y GR],series_Idx,X_idx
	from KPI_Frame_MNC_Brand_Ranking_data
	)a
	unpivot (
	Y  for X in (MTH00US,MTH12US,[Y2Y GR])
	) T
	
	IF OBJECT_ID(N'KPI_Frame_MNC_Brand_Ranking_temp2',N'U') IS NOT NULL
	drop table KPI_Frame_MNC_Brand_Ranking_temp2
	go
	select period,prod_cod,product_name,x,y,temp_x,temp_y,series_Idx,X_idx
	into KPI_Frame_MNC_Brand_Ranking_temp2
	from (
	select * from KPI_Frame_MNC_Brand_Ranking_temp )a
	unpivot
	(
	temp_y for temp_x IN(currRank,PrevRank)
	) t
	
	IF OBJECT_ID(N'KPI_Frame_MNC_Brand_Ranking',N'U') IS NOT NULL
	drop table KPI_Frame_MNC_Brand_Ranking
	go
	select period,product_name,x,y,series_idx,x_idx into KPI_Frame_MNC_Brand_Ranking from KPI_Frame_MNC_Brand_Ranking_temp2 where 1=0
	
	insert into KPI_Frame_MNC_Brand_Ranking
	select period,product_name,x,y,series_Idx,X_Idx from KPI_Frame_MNC_Brand_Ranking_temp2 
	union 
	select period,product_name,temp_x,temp_y,series_Idx,X_Idx from KPI_Frame_MNC_Brand_Ranking_temp2 
	go
	update a set x_idx=case when x='MTH00US' then 1
							when x='MTH12US' then 2
							when x='Y2Y GR' then 3
							when x='PrevRank' then 4
							when x='currRank' then 5
							end
	from KPI_Frame_MNC_Brand_Ranking a
	
	update a set x=case when right(left(x,5),2)='00' then period+' '+(select monthen from tblmonthlist where monseq=1) 
					  when right(left(x,5),2)='12' then period+' '+(select monthen from tblmonthlist where monseq=13)
					  when X='currRank' then period+' '+(select monthen from tblmonthlist where monseq=1)+' Ranking'
					  when X='PrevRank' then period+' '+(select monthen from tblmonthlist where monseq=13)+' Ranking'
					  else x end
	from KPI_Frame_MNC_Brand_Ranking a

	alter table KPI_Frame_MNC_Brand_Ranking alter column series_idx int
	alter table KPI_Frame_MNC_Brand_Ranking alter column x_idx int
	
	alter table KPI_Frame_MNC_Company_Ranking alter column series_idx int
	alter table KPI_Frame_MNC_Company_Ranking alter column x_idx int


 update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA set lev ='Nation' where lev is null
 update KPI_Frame_MarketAnalyzer_IMSAudit_CHPA set lev ='Nation' where lev =''
 
delete KPI_Frame_MarketAnalyzer_IMSAudit_KeyCity where x = '' 
delete KPI_Frame_MarketAnalyzer_IMSAudit_48Cities where x = '' 
SELECT * FROM KPI_Frame_MarketAnalyzer_Hospital_Segment
--exec dbo.sp_Log_Event 'KPI Frame_1','CIA IMS','Market_Analyzer数据提取_new.sql','End',null,null