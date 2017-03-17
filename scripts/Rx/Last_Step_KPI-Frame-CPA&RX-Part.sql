USE BMSChinaMRBI_test
GO
--------------------------------------------
--	KPI: Hospital Performance
--------------------------------------------
/*
--Glucophage market
productname	prod
Amaryl	200
Glucobay	500
Glucophage	100
NIAD Market	000

*/
IF EXISTS (SELECT 1 FROM dbo.sysobjects where id=object_id(N'KPI_Frame_CPA_Part_Market_Product_Mapping') and type='U')
BEGIN
	DROP TABLE KPI_Frame_CPA_Part_Market_Product_Mapping
END

SELECT distinct convert(varchar(100),productname) as productname,convert(varchar(20),prod) as prod,mkt,mktname
INTO KPI_Frame_CPA_Part_Market_Product_Mapping
FROM [dbo].[tblMktDefHospital]
WHERE (mkt='NIAD' and prod in ('100','200','500','000')) or (mkt='dpp4' and prod in ('300','200','100','000')) or
		(mkt='HYPFCS' and prod in ('200','100','700','800','000') ) or (mkt='arv' and prod in ('000','100','300','400','500'))--todo
DELETE FROM KPI_Frame_CPA_Part_Market_Product_Mapping WHERE productname='DPP-IV Market' and mkt='dpp4'

insert into KPI_Frame_CPA_Part_Market_Product_Mapping (productname,prod,mkt,mktname)
select distinct case when productname='TRAJENTA' then 'Trajenta'
					 when productname='JANUMET' then 'Janumet' end as productname,
prod,mkt,mktname
from bmschinacia_ims.dbo.tblMktDef_MRBIChina_For_Onglyza  where productname in ('TRAJENTA','JANUMET')

IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'TempKPIFrame_CPAPart') and type='U')
BEGIN
	DROP TABLE TempKPIFrame_CPAPart
END

select case when a.DataSource is not null then a.DataSource else 'CPA' end as DataSource ,
b.Mkt,b.Prod,b.ProductName,a.cpa_id,ISNULL(a.VM1,0) as VM1,ISNULL(a.VM13,0) as VM13,ISNULL(a.UM1,0) as UM1,ISNULL(a.UM13,0) as UM13,
	ISNULL(a.VYTD,0) as VYTD, ISNULL(a.VYTDStly,0) as VYTDStly,ISNULL(a.VR3M1,0) as VR3M1, ISNULL(a.VR3M13,0) as VR3M13,ISNULL(a.UYTD,0) as UYTD,ISNULL(a.UYTDStly,0) as UYTDStly
INTO TempKPIFrame_CPAPart
from (select * from tempHospitalData where DataSource='CPA')  a right join KPI_Frame_CPA_Part_Market_Product_Mapping b on a.Mkt=b.Mkt and a.prod=b.prod
	--join (SELECT DISTINCT id,cpa_name FROM tblHospitalMaster) c on a.cpa_id = c.id join 
	--(select distinct [cpa name],[Glucophage Hospital Category] from dbo.[glucophage mapping] where [cpa name]<> '#N/A') d on d.[cpa name]=c.cpa_name	


GO
IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_NIAD') and type='U')
BEGIN
	DROP TABLE Mid_KPIFrame_CPAPart_NIAD
END
go
IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_HYP') and type='U')
BEGIN
	DROP TABLE Mid_KPIFrame_CPAPart_HYP
END
go
IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_DPP4') and type='U')
BEGIN
	DROP TABLE Mid_KPIFrame_CPAPart_DPP4
END
go
--todo
IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_ARV') and type='U')
BEGIN
	DROP TABLE Mid_KPIFrame_CPAPart_ARV
END


IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_DPP4_NOTZero_Hosp') and type='U')
BEGIN
	DROP TABLE Mid_KPIFrame_CPAPart_DPP4_NOTZero_Hosp
END
--NIAD Part
declare @mktGlucophage varchar(20)
set @mktGlucophage='NIAD'
  ----Total Tier
select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
INTO Mid_KPIFrame_CPAPart_NIAD
from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_name FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
	 (select distinct [cpa name] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Glucophage Hospital Category] <> '#N/A') c on c.[cpa name]=b.cpa_name
where mkt=@mktGlucophage
group by a.DataSource,a.mkt,a.prod,a.ProductName

INSERT INTO Mid_KPIFrame_CPAPart_NIAD (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
  --A,B,C,D tier
select c.[Glucophage Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_name FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
	 (select distinct [cpa name],[Glucophage Hospital Category] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Glucophage Hospital Category] <> '#N/A') c 
		on c.[cpa name]=b.cpa_name
where a.mkt=@mktGlucophage	 
group by c.[Glucophage Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName

--HYP part
declare @mktMonopril varchar(20)
set @mktMonopril='HYPFCS'
select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
INTO Mid_KPIFrame_CPAPart_HYP
from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_name FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
	 (select distinct [cpa name] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Monopril Hospital Category] <> '#N/A') c on c.[cpa name]=b.cpa_name
where mkt=@mktMonopril
group by a.DataSource,a.mkt,a.prod,a.ProductName

INSERT INTO Mid_KPIFrame_CPAPart_HYP (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
  --A,B,C,D tier
select c.[Monopril Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_name FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
	 (select distinct [cpa name],[Monopril Hospital Category] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Monopril Hospital Category] <> '#N/A') c 
		on c.[cpa name]=b.cpa_name
where a.mkt=@mktMonopril	 
group by c.[Monopril Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
go

--ARV --todo

declare @mktBaraclude varchar(20)
set @mktBaraclude='ARV'
select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
INTO Mid_KPIFrame_CPAPart_ARV
from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_name FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
	 (select distinct [cpa name] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Baraclude Hospital Category]<>'#N/A') c on c.[cpa name]=b.cpa_name
where mkt=@mktBaraclude
group by a.DataSource,a.mkt,a.prod,a.ProductName

INSERT INTO Mid_KPIFrame_CPAPart_ARV (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
  --A,B,C,D tier
select c.[Baraclude Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_name FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
	 (select distinct [cpa name],[Baraclude Hospital Category] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Baraclude Hospital Category]<>'#N/A') c 
		on c.[cpa name]=b.cpa_name
where a.mkt=@mktBaraclude	 
group by c.[Baraclude Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
go





--DPP4 part
declare @mktOnglyza varchar(20)
set @mktOnglyza='DPP4'

select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
INTO Mid_KPIFrame_CPAPart_DPP4
from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_name FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
	 (select distinct [cpa name] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Onglyza  Hospital Category]<>'#N/A') c on c.[cpa name]=b.cpa_name
where mkt=@mktOnglyza
group by a.DataSource,a.mkt,a.prod,a.ProductName

INSERT INTO Mid_KPIFrame_CPAPart_DPP4 (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
  --A,B,C,D tier
select c.[Onglyza  Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_name FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
	 (select distinct [cpa name],[Onglyza  Hospital Category] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Onglyza  Hospital Category]<>'#N/A') c 
		on c.[cpa name]=b.cpa_name
where a.mkt=@mktOnglyza	 
group by c.[Onglyza  Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName


 --Not zero data hospital part
select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
INTO Mid_KPIFrame_CPAPart_DPP4_NOTZero_Hosp
from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_name FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
	 (select distinct [cpa name] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Onglyza  Hospital Category]<>'#N/A') c on c.[cpa name]=b.cpa_name
where mkt=@mktOnglyza and VYTD>0
group by a.DataSource,a.mkt,a.prod,a.ProductName

INSERT INTO Mid_KPIFrame_CPAPart_DPP4_NOTZero_Hosp (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
  --A,B,C,D tier
select c.[Onglyza  Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_name FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
	 (select distinct [cpa name],[Onglyza  Hospital Category] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Onglyza  Hospital Category]<>'#N/A') c 
		on c.[cpa name]=b.cpa_name
where a.mkt=@mktOnglyza	 and VYTD>0
group by c.[Onglyza  Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
go

--select * from Mid_KPIFrame_CPAPart_DPP4
IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Output_KPI_Frame_CPAPart') and type='U')
BEGIN
	DROP TABLE Output_KPI_Frame_CPAPart
END

select Tier,DataSource,mkt,prod,ProductName,y,x
into Output_KPI_Frame_CPAPart
from (
	select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp, 
	convert(decimal(20,8),case when b.VYTD is null or b.VYTD=0 then 0 else 1.0*a.VYTD/b.VYTD end) as [Market Size]
	from (
		select * from  Mid_KPIFrame_CPAPart_NIAD where prod='000'
	  ) a join 
		 (
		select * from  Mid_KPIFrame_CPAPart_NIAD where  prod='000' and Tier ='Total'
	  ) b on a.DataSource=b.DataSource and a.mkt=b.mkt and a.prod=b.prod and a.ProductName=b.ProductName
 ) t1 unpivot (
	Y for X in (Mapped_Hosp,[Market Size])
)  t2

insert into Output_KPI_Frame_CPAPart(Tier,DataSource,mkt,prod,ProductName,y,x)
select  Tier,DataSource,mkt,prod,ProductName,y,x
from (
	select a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
		convert(decimal(20,8),case when a.VYTDStly is null or a.VYTDStly=0 then null else 1.0*(a.VYTD-a.VYTDStly)/a.VYTDStly end) as [ProductMarketGrowth],
		convert(decimal(20,8),case when b.VYTD is null or b.VYTD =0 then 0 else 1.0*a.VYTD/b.VYTD end) as [ProductMarketShare]
	from (select * from   Mid_KPIFrame_CPAPart_NIAD where prod <>'000') a join
		(select * from Mid_KPIFrame_CPAPart_NIAD where prod='000') b on a.Tier=b.Tier and a.DataSource=b.DataSource and a.mkt=b.mkt
) t1 unpivot (
	Y for X in ([ProductMarketGrowth],[ProductMarketShare])
)	t2	
	

--DPP4
insert into Output_KPI_Frame_CPAPart(Tier,DataSource,mkt,prod,ProductName,y,x)
select Tier,DataSource,mkt,prod,ProductName,y,x
from (
	select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp, 
	convert(decimal(20,8),case when b.VYTD is null or b.VYTD=0 then 0 else 1.0*a.VYTD/b.VYTD end) as [Market Size]
	from (
		select * from  Mid_KPIFrame_CPAPart_DPP4 where prod='000'
	  ) a join 
		 (
		select * from  Mid_KPIFrame_CPAPart_DPP4 where  prod='000' and Tier ='Total'
	  ) b on a.DataSource=b.DataSource and a.mkt=b.mkt and a.prod=b.prod and a.ProductName=b.ProductName
 ) t1 unpivot (
	Y for X in (Mapped_Hosp,[Market Size])
)  t2
union all
select  Tier,DataSource,mkt,prod,ProductName,y,x
from (
	select a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
		convert(decimal(20,8),case when a.VYTDStly is null or a.VYTDStly=0 then null else 1.0*(a.VYTD-a.VYTDStly)/a.VYTDStly end) as [ProductMarketGrowth],
		convert(decimal(20,8),case when b.VYTD is null or b.VYTD =0 then 0 else 1.0*a.VYTD/b.VYTD end) as [ProductMarketShare]
	from (select * from   Mid_KPIFrame_CPAPart_DPP4 where prod <>'000') a join
		(select * from Mid_KPIFrame_CPAPart_DPP4 where prod='000') b on a.Tier=b.Tier and a.DataSource=b.DataSource and a.mkt=b.mkt
) t1 unpivot (
	Y for X in ([ProductMarketGrowth],[ProductMarketShare])
)	t2	

  --Hosp. # (Onglyza sales>0): Specified Series to DPP4
insert into Output_KPI_Frame_CPAPart(Tier,DataSource,mkt,prod,ProductName,y,x)
select Tier,DataSource,mkt,prod,ProductName,y,x
from (
	select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp_NotZeroSales
	from (
		select * from  Mid_KPIFrame_CPAPart_DPP4_NOTZero_Hosp where prod='100'
	  ) a )t1 unpivot (
	Y for X in (Mapped_Hosp_NotZeroSales)
)  t2

--HYP	
insert into Output_KPI_Frame_CPAPart(Tier,DataSource,mkt,prod,ProductName,y,x)
select Tier,DataSource,mkt,prod,ProductName,y,x
from (
	select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp, 
	convert(decimal(20,8),case when b.VYTD is null or b.VYTD=0 then 0 else 1.0*a.VYTD/b.VYTD end) as [Market Size]
	from (
		select * from  Mid_KPIFrame_CPAPart_HYP where prod='000'
	  ) a join 
		 (
		select * from  Mid_KPIFrame_CPAPart_HYP where  prod='000' and Tier ='Total'
	  ) b on a.DataSource=b.DataSource and a.mkt=b.mkt and a.prod=b.prod and a.ProductName=b.ProductName
 ) t1 unpivot (
	Y for X in (Mapped_Hosp,[Market Size])
)  t2
union all
select  Tier,DataSource,mkt,prod,ProductName,y,x
from (
	select a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
		convert(decimal(20,8),case when a.VYTDStly is null or a.VYTDStly=0 then null else 1.0*(a.VYTD-a.VYTDStly)/a.VYTDStly end) as [ProductMarketGrowth],
		convert(decimal(20,8),case when b.VYTD is null or b.VYTD =0 then 0 else 1.0*a.VYTD/b.VYTD end) as [ProductMarketShare]
	from (select * from   Mid_KPIFrame_CPAPart_HYP where prod <>'000') a join
		(select * from Mid_KPIFrame_CPAPart_HYP where prod='000') b on a.Tier=b.Tier and a.DataSource=b.DataSource and a.mkt=b.mkt
) t1 unpivot (
	Y for X in ([ProductMarketGrowth],[ProductMarketShare])
)	t2	

--ARV
insert into Output_KPI_Frame_CPAPart(Tier,DataSource,mkt,prod,ProductName,y,x)
select Tier,DataSource,mkt,prod,ProductName,y,x
from (
	select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp, 
	convert(decimal(20,8),case when b.VYTD is null or b.VYTD=0 then 0 else 1.0*a.VYTD/b.VYTD end) as [Market Size]
	from (
		select * from  Mid_KPIFrame_CPAPart_ARV where prod='000'
	  ) a join 
		 (
		select * from  Mid_KPIFrame_CPAPart_ARV where  prod='000' and Tier ='Total'
	  ) b on a.DataSource=b.DataSource and a.mkt=b.mkt and a.prod=b.prod and a.ProductName=b.ProductName
 ) t1 unpivot (
	Y for X in (Mapped_Hosp,[Market Size])
)  t2
union all
select  Tier,DataSource,mkt,prod,ProductName,y,x
from (
	select a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
		convert(decimal(20,8),case when a.VYTDStly is null or a.VYTDStly=0 then null else 1.0*(a.VYTD-a.VYTDStly)/a.VYTDStly end) as [ProductMarketGrowth],
		convert(decimal(20,8),case when b.VYTD is null or b.VYTD =0 then 0 else 1.0*a.VYTD/b.VYTD end) as [ProductMarketShare]
	from (select * from   Mid_KPIFrame_CPAPart_ARV where prod <>'000') a join
		(select * from Mid_KPIFrame_CPAPart_ARV where prod='000') b on a.Tier=b.Tier and a.DataSource=b.DataSource and a.mkt=b.mkt
) t1 unpivot (
	Y for X in ([ProductMarketGrowth],[ProductMarketShare])
)	t2	

	
GO

IF EXISTS(select 1 from dbo.sysobjects where id=object_id(N'KPI_Frame_AnalyzerMarket_HospitalPerformance') and type='U')
BEGIN
	DROP TABLE KPI_Frame_AnalyzerMarket_HospitalPerformance
END
declare @CPAMonth varchar(50)
select @CPAMonth=left(A.MonthEN,3) from BMSChinaCIA_IMS.dbo.tblMonthlist a join tblDSDates b on a.Date=b.Value1 
where b.item='CPA'
--select @CPAMonth=Value1 from tblDSDates where Item='CPA'

SELECT case when mkt='NIAD' then 'YTD'--'MTH' 
		 when mkt in ('HYPFCS','ARV') then 'YTD'
		 when mkt='DPP4' then 'YTD'--'MQT'
	end AS TimeFrame, 'USD' as MoneyType, 'N' as Molecule,'N' as class,mkt,
	case when mkt='NIAD' then 'NIAD Market' 
		 when mkt='HYPFCS' then 'HYP Market'
		 when mkt='DPP4' then 'DPP4 Market'
		 when mkt='ARV' then 'ARV Market'
	end as MktName,
	case when mkt='NIAD' then 'Glucophage' 
		 when mkt='HYPFCS' then 'Monopril'
		 when mkt='DPP4' then 'Onglyza'
		 when mkt='ARV' then 'Baraclude'
	end as Market,prod,
	case when Tier='2-A' then 'A'
		 when Tier='3-B' then 'B'
		 when Tier='4-C' then 'C'
		 when Tier='6-D' then 'D' 
		 when Tier='1-S' then 'S'
		 else Tier end as Series,
	convert(varchar(50),null) as DataType,convert(varchar(20),null)	as Category,Y,
	case when x='Market Size' then mkt+' Market Size'
			when x='Mapped_Hosp' then '# Hospital CPA matched with BMS'
			when x='ProductMarketShare' then ProductName+' Share ('+(
												case when mkt='NIAD' then 'YTD '--'MTH' 
													 when mkt='HYPFCS' then 'YTD '
													 when mkt='DPP4' then 'YTD '-- 'MQT' 
													 when mkt='ARV' then 'YTD '
													 end) +@CPAMonth +')'
			when x='ProductMarketGrowth' then ProductName+' GR(Y2Y)'
			when x='Mapped_Hosp_NotZeroSales' and mkt='DPP4' then 'Hosp. # (Onglyza sales>0)'
	end  as X,
	case when Tier='A' then 1
		 when Tier='B' then 2
		 when Tier='C' then 3
		 when Tier='D' then 4 
		 when Tier='2-A' then 2
		 when Tier='3-B' then 3
		 when Tier='4-C' then 4
		 when Tier='6-D' then 5 
		 when Tier='1-S' then 1
		 when Tier='Total' then 6
		 when Tier='Region300' then 2
		 when Tier like 'top %' then 1
		 when Tier='High productivity' then 3
		 when Tier='Others' then 4
	end as Series_Idx,
	case when x='Market Size' then 3
			when x='Mapped_Hosp' then 1
			when x='ProductMarketShare' and ProductName in ('Glucophage','Onglyza', 'Lotensin','Baraclude') then 4 
			when x='ProductMarketGrowth' and ProductName in ('Glucophage','Onglyza', 'Lotensin','Baraclude') then 5
			when x='ProductMarketShare' and ProductName in ('Glucobay','Galvus', 'Monopril','Heptodin') then 6 
			when x='ProductMarketGrowth' and ProductName in ('Glucobay','Galvus', 'Monopril','Heptodin') then 7
			when x='ProductMarketShare' and ProductName in ('Amaryl','Januvia', 'Tritace','Run Zhong') then 8
			when x='ProductMarketGrowth' and ProductName in ('Amaryl','Januvia', 'Tritace','Run Zhong') then 9
			when x='ProductMarketShare' and ProductName in ('Acertil','Sebivo','Janumet') then 10
			when x='ProductMarketGrowth' and ProductName in ('Acertil','Sebivo','Janumet') then 11
			when x='ProductMarketShare' and ProductName in ('Trajenta') then 12
			when x='ProductMarketGrowth' and ProductName in ('Trajenta') then 13
			when x='Mapped_Hosp_NotZeroSales' and mkt='DPP4' then 2
	end as X_Idx		
into KPI_Frame_AnalyzerMarket_HospitalPerformance
from Output_KPI_Frame_CPAPart
GO

----------------------------------------------
--	LABEL: RX Audit
----------------------------------------------
IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'KPI_FRAME_BusinessSourceOfXarelto') and type='U')
BEGIN
	DROP TABLE KPI_FRAME_BusinessSourceOfXarelto
END
select a.Department_EN,a.date,a.ProductName,sum(a.rx) as rx,sum(a.amount) as amount,b.rx_All,b.amount_All
INTO #TempKPI_FRAME_BusinessSourceOfXarelto
from 
(
	select case when ��������=N'��ͨ����'then 'General surgery'
				when ��������=N'�ǿ�' then 'Orthopedics'
				when ��������=N'Ѫ�ܿ�' then 'Vascular department'
				when ��������=N'�߸ɱ���' then 'Senior Cadres of Health'
				when ��������=N'���ڿ�' then 'Cardiology'
				else 'All other' end as Department_EN,
				DATE,
				�������� as rx,
				���� as amount,
				��Ʒ���� as ProductName		    
	from dbo.inRx_201306
	where [��Ʒ����]=N'������' and date>='10Q4'
) a  join 
(
	select distinct ��Ʒ���� as ProductName,Date,  sum(��������) as rx_All,sum(����) as amount_All
	from dbo.inRx_201306
	where [��Ʒ����]=N'������'  and date>='10Q4'
	group by ��Ʒ����,Date
) b on a.ProductName=b.ProductName and a.Date=b.Date
group by a.Department_EN,a.ProductName,a.date,b.rx_All,b.amount_All
order by date

insert INTO #TempKPI_FRAME_BusinessSourceOfXarelto
select a.Department_EN,a.date,a.ProductName,sum(a.rx) as rx,sum(a.amount) as amount,b.rx_All,b.amount_All
from 
(
	select case when ��������=N'��ͨ����'then 'General surgery'
				when ��������=N'�ǿ�' then 'Orthopedics'
				when ��������=N'Ѫ�ܿ�' then 'Vascular department'
				when ��������=N'�߸ɱ���' then 'Senior Cadres of Health'
				when ��������=N'���ڿ�' then 'Cardiology'
				else 'All other' end as Department_EN,
				DATE,
				�������� as rx,
				���� as amount,
				��Ʒ���� as ProductName		    
	from dbo.inRx_2015Q3
	where [��Ʒ����]=N'������'
) a  join 
(
	select distinct ��Ʒ���� as ProductName,Date,  sum(��������) as rx_All,sum(����) as amount_All
	from dbo.inRx_2015Q3
	where [��Ʒ����]=N'������'
	group by ��Ʒ����,Date
) b on a.ProductName=b.ProductName and a.Date=b.Date
group by a.Department_EN,a.ProductName,a.date,b.rx_All,b.amount_All
order by date


SELECT 'QTR' as TimeFrame, 'RMB' as MoneyType, 'N' as Molecule,'N' as Class,'Eliquis' as Mkt,'Eliquis Market' as mktName,'Eliquis' as Market,
	convert(varchar(20),null) as prod,b.Department_EN as Series,convert(varchar(50),null) as DataType,convert(varchar(20),null) as Category,
   convert(decimal(20,8),case when amount_All is null or amount_All=0 then 0 else 1.0*amount/amount_All end) as Y,b.Date as X,
   case when b.Department_EN='Orthopedics' then 1
		when b.Department_EN='General surgery' then 2
		when b.Department_EN='Vascular department' then 3
		when b.Department_EN='Senior Cadres of Health' then 4
		when b.Department_EN='Cardiology' then 5
		when b.Department_EN='All other' then 6 end as Series_Idx,
  dense_rank() over(order by b.Date) as X_Idx	
INTO KPI_FRAME_BusinessSourceOfXarelto
FROM #TempKPI_FRAME_BusinessSourceOfXarelto a right join 
(
	select *
	from ( 
			select distinct department_EN from #TempKPI_FRAME_BusinessSourceOfXarelto
		) t1 cross join (select distinct Date from #TempKPI_FRAME_BusinessSourceOfXarelto) t2
) b on a.Date=b.Date and a.Department_EN=b.Department_EN

select * from KPI_FRAME_BusinessSourceOfXarelto order by x_idx
drop table #TempKPI_FRAME_BusinessSourceOfXarelto
GO

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'KPI_FRAME_MoleculePerformanceInOrthopedics') and type='U')
BEGIN
	DROP TABLE KPI_FRAME_MoleculePerformanceInOrthopedics
END


select  b.Ӣ������ as Mole_EN,a.Date,sum(a.����) as amount 
into #TempRx
from inRX_201306 a join BMSChinaOtherDB.dbo.inRx_MoleculeRef  b on a.ҩƷ����=b.ҩƷ����
where a.��������=N'�ǿ�' and b.Ӣ������ in ('Rivaroxaban','Nadroparin Calcium','Enoxaparin sodium','Dalteparin sodium',
		'Fondaparinux','Heparin sodium','Warfarin sodium','Extract cepae/heparin sodium/allantoin','Heparin calcium'
	)  and date>='10Q4'
group by 	b.Ӣ������,a.Date

insert into #TempRx
select  b.Ӣ������ as Mole_EN,a.Date,sum(a.����) as amount 
from inRX_2015Q3 a join BMSChinaOtherDB.dbo.inRx_MoleculeRef  b on a.ҩƷ����=b.ҩƷ����
where a.��������=N'�ǿ�' and b.Ӣ������ in ('Rivaroxaban','Nadroparin Calcium','Enoxaparin sodium','Dalteparin sodium',
		'Fondaparinux','Heparin sodium','Warfarin sodium','Extract cepae/heparin sodium/allantoin','Heparin calcium'
	)
group by 	b.Ӣ������,a.Date

select 'QTR' as TimeFrame, 'RMB' as MoneyType, 'N' as Molecule,'N' as Class,'Eliquis' as Mkt,'Eliquis Market' as mktName,'Eliquis' as Market,
	convert(varchar(20),null) as prod,c.Mole_en as Series,convert(varchar(50),null) as DataType,convert(varchar(20),null) as Category,
	convert(decimal(20,8),case when b.amount_All is null or b.amount_All=0 then 0 else 1.0*a.amount/b.amount_All end) as Y,
	c.Date as X,
	case when a.mole_en = 'Rivaroxaban' then 1
		 when a.mole_en = 'Nadroparin Calcium' then 2
		 when a.mole_en = 'Enoxaparin sodium' then 3
		 when a.mole_en = 'Dalteparin sodium' then 4
		 when a.mole_en = 'Fondaparinux' then 5
		 when a.mole_en = 'Heparin sodium' then 6 
		 when a.mole_en = 'Warfarin sodium' then 7
		 when a.mole_en = 'Extract cepae/heparin sodium/allantoin' then 8
		 when a.mole_en = 'Heparin calcium' then 9 end as Series_Idx,
	dense_rank()over(order by  c.date)	 as X_Idx
into 	KPI_FRAME_MoleculePerformanceInOrthopedics
from #TempRx a join (
			select distinct date,sum(amount) as amount_All 
			from #TempRx group by Date
		) b on a.Date=b.Date right join
	 (
		
		select *
		from ( select distinct mole_en from #TempRx ) t1 cross join (
			select distinct date from #TempRx ) t2
		
	 ) c on a.Date=c.date and a.mole_en=c.mole_en		 		
drop table #TempRx
GO

USE BMSChinaCIA_IMS
GO


--Transfer the data to BMSChina_CIA_IMS database
IF EXISTS(SELECT 1 FROM BMSChinaCIA_IMS.dbo.sysobjects where id=object_id(N'dbo.KPI_Frame_AnalyzerMarket_HospitalPerformance') and type='U')
BEGIN
	DROP TABLE  BMSChinaCIA_IMS.dbo.KPI_Frame_AnalyzerMarket_HospitalPerformance
END
SELECT * INTO  BMSChinaCIA_IMS.dbo.KPI_Frame_AnalyzerMarket_HospitalPerformance 
FROM BMSChinaMRBI_test.dbo.KPI_Frame_AnalyzerMarket_HospitalPerformance


IF EXISTS(SELECT 1 FROM  BMSChinaCIA_IMS.dbo.sysobjects where id=object_id(N'dbo.KPI_FRAME_BusinessSourceOfXarelto') and type='U')
BEGIN
	DROP TABLE  BMSChinaCIA_IMS.dbo.KPI_FRAME_BusinessSourceOfXarelto
END
SELECT * INTO dbo.KPI_FRAME_BusinessSourceOfXarelto 
FROM BMSChinaMRBI_test.dbo.KPI_FRAME_BusinessSourceOfXarelto


IF EXISTS(SELECT 1 FROM  BMSChinaCIA_IMS.dbo.sysobjects where id=object_id(N'dbo.KPI_Frame_CPA_Part_Market_Product_Mapping') and type='U')
BEGIN
	DROP TABLE  BMSChinaCIA_IMS.dbo.KPI_Frame_CPA_Part_Market_Product_Mapping
END
SELECT * INTO  BMSChinaCIA_IMS.dbo.KPI_Frame_CPA_Part_Market_Product_Mapping 
FROM BMSChinaMRBI_test.dbo.KPI_Frame_CPA_Part_Market_Product_Mapping

IF EXISTS(SELECT 1 FROM  BMSChinaCIA_IMS.dbo.sysobjects where id=object_id(N'dbo.KPI_FRAME_MoleculePerformanceInOrthopedics') and type='U')
BEGIN
	DROP TABLE  BMSChinaCIA_IMS.dbo.KPI_FRAME_MoleculePerformanceInOrthopedics
END
SELECT * INTO  BMSChinaCIA_IMS.dbo.KPI_FRAME_MoleculePerformanceInOrthopedics 
FROM BMSChinaMRBI_test.dbo.KPI_FRAME_MoleculePerformanceInOrthopedics