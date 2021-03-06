use BMSCNProc2
go




exec dbo.sp_Log_Event 'Process','QT_CPA_Inline','Step_1_Create_tblHospitalDataRaw.sql','Start',null,null


--backup
declare @curIMSMth varchar(6), @lastIMSMth varchar(6)
select @curIMSMth= DataPeriod from tblDataPeriod where QType = 'HOSP_I'
set @lastIMSMth = convert(varchar(6), dateadd(month, -1, cast(@curIMSMth+'01' as datetime)), 112)
exec('
if object_id(N''BMSCNProc_bak.dbo.tblHospitalMaster_'+@lastIMSMth+''',N''U'') is null
select * into BMSCNProc_bak.dbo.tblHospitalMaster_'+@lastIMSMth+'
from tblHospitalMaster
')
GO
--reflash
truncate table tblHospitalMaster
go
Insert into tblHospitalMaster
select distinct 
[ID], DataSource, CPA_Code, CPA_Name, CPA_Name_English, Tier, Province, City, City as Area, City_En
from db4.BMSChinaMRBI.dbo.tblHospitalMaster
go
update tblHospitalMaster set 
City = N'海南',City_en = 'HaiNan'
where city = N'省直辖县级行政单位'
go
--检查tblHospitalMaster更新的数据是否正常
select 'Duplicated hospitals in raw tblHospitalmaster: '+ convert(varchar, count(*)) 
from (select [ID], COUNT(*) as DupCount from tblHospitalMaster group by [ID] having COUNT(*)>1) as t1
go
select 'Duplicated hospitals in dedupped tblHospitalmaster: '+ convert(varchar, count(*)) 
from (select [ID], COUNT(*) as DupCount from tblHospitalMaster group by [ID] having COUNT(*)>1) as t1
go
truncate table tblHospitalList
go
insert into tblHospitalList
select  
	ID as Hosp_ID
	, CPA_Name as Hosp_Des_CN
	, upper(CPA_Name_English) as Hosp_Des_EN,
	Tier, Province, City as City_CN
	, upper(City_EN) as City_EN 
	, ''
from tblHospitalmaster 


UPDATE a 
SET a.Province_EN = b.Province_EN
--SELECT DISTINCT a.province, b.Province_CN, b.Province_EN 
FROM dbo.tblHospitalList AS a
INNER JOIN dbo.tblCityListForHospital AS b ON a.Province = b.Province_CN


UPDATE a 
SET a.City_EN = b.City_EN
--SELECT DISTINCT a.province, b.Province_CN, b.Province_EN 
FROM dbo.tblHospitalList AS a
INNER JOIN dbo.tblCityListForHospital AS b ON a.City_CN = b.City_CN


go


--dataDeal
if object_id(N'tblHospitalDataRaw',N'U') is not null
drop table tblHospitalDataRaw
go
select convert(varchar(13),t2.Package_Code) as Package_Code, t3.DM, t1.CPA_ID
, convert(int, sum(t1.Value)) as Value , convert(int, sum(t1.Volume)) as Volume
into tblHospitalDataRaw 
from inCPAData t1 inner join (
	select distinct Molecule_CN_Src,Product_CN_Src ,Manu_CN_Src,Form_Src,Specification_Src,Package_Code
	from DB4.BMSChinaMRBI.dbo.tblPackageXRefHosp) t2
on t1.Molecule=t2.Molecule_CN_Src and t1.Product=t2.Product_CN_Src and t1.Manufacture=t2.Manu_CN_Src
and t1.Form=t2.Form_Src and t1.Specification=t2.Specification_Src 
inner join tblDatamonthConv t3  on t1.Y=t3.Y and t1.M=t3.M inner join tblHospitalMaster t4 on t1.CPA_ID=t4.ID  
where t4.DataSource='CPA'
group by Package_code, DM, CPA_ID
go

insert into tblHospitalDataRaw
select convert(varchar(13),Package_Code) as Package_Code, DM, CPA_ID
, convert(int, sum(Value)) as Value, convert(int, sum(Volume)) as Volume
from inSeaRainbowData t1 inner join (
	select distinct Molecule_CN_Src,Product_CN_Src ,Manu_CN_Src,Form_Src,Specification_Src,Package_Code
	from DB4.BMSChinaMRBI.dbo.tblPackageXRefHosp) t2
on t1.Molecule=t2.Molecule_CN_Src and t1.Product=t2.Product_CN_Src and t1.Manufacture=t2.Manu_CN_Src
and FormI=Form_Src and t1.Specification=t2.Specification_Src          
inner join tblDatamonthConv t3 on t1.YM=t3.Datamonth inner join tblHospitalMaster t4 on t1.CPA_ID=t4.ID
where t4.Datasource='SEA' 
group by Package_code, DM, CPA_ID 
go
insert into tblHospitalDataRaw
select convert(varchar(13),t2.Package_Code) as Package_Code, t3.DM, t1.CPA_ID
, convert(int, sum(t1.Value)) as Value , convert(int, sum(t1.Volume)) as Volume
from inPharmData t1 inner join (
	select distinct Molecule_CN_Src,Product_CN_Src ,Manu_CN_Src,Form_Src,Specification_Src,Package_Code
	from DB4.BMSChinaMRBI.dbo.tblPackageXRefHosp) t2
on t1.Molecule=t2.Molecule_CN_Src and t1.Product=t2.Product_CN_Src and t1.Manufacture=t2.Manu_CN_Src
and t1.Form=t2.Form_Src and t1.Specification=t2.Specification_Src 
inner join tblDatamonthConv t3  on t1.Y=t3.Y and t1.M=t3.M inner join tblHospitalMaster t4 on t1.CPA_ID=t4.ID  
where t4.DataSource='PHA'
group by Package_code, DM, CPA_ID
go

--Add OTC Market
insert into tblHospitalDataRaw
select convert(varchar(13),t2.Package_Code) as Package_Code, t3.DM, t1.CPA_ID
, convert(int, sum(t1.Value)) as Value , convert(int, sum(t1.Volume)) as Volume
from inCPAData t1 inner join (
	select distinct Molecule_CN_Src,Product_CN_Src ,Manu_CN_Src,Form_Src,Specification_Src,Package_Code
	from  db4.BMSChinaMRBI.dbo.tblPackageXRefHosp_OTC a
	where not exists(
		select 1
		from db4.BMSChinaMRBI.dbo.tblPackageXRefHosp b
		where a.molecule_cn_src=b.molecule_cn_src and a.product_cn_src=b.product_cn_src 
		and a.manu_cn_Src=b.manu_cn_Src and a.package_code=b.package_code and a.Form_Src=b.Form_Src  and a.Specification_Src=b.Specification_Src
		)
	) t2
on t1.Molecule=t2.Molecule_CN_Src and t1.Product=t2.Product_CN_Src and t1.Manufacture=t2.Manu_CN_Src
and t1.Form=t2.Form_Src and t1.Specification=t2.Specification_Src 
inner join tblDatamonthConv t3  on t1.Y=t3.Y and t1.M=t3.M inner join tblHospitalMaster t4 on t1.CPA_ID=t4.ID  
where t4.DataSource='CPA'
group by Package_code, DM, CPA_ID
go

insert into tblHospitalDataRaw
select convert(varchar(13),Package_Code) as Package_Code, DM, CPA_ID
, convert(int, sum(Value)) as Value, convert(int, sum(Volume)) as Volume
from inSeaRainbowData t1 inner join (
	select distinct Molecule_CN_Src,Product_CN_Src ,Manu_CN_Src,Form_Src,Specification_Src,Package_Code
	from  db4.BMSChinaMRBI.dbo.tblPackageXRefHosp_OTC a
	where not exists(
		select 1
		from db4.BMSChinaMRBI.dbo.tblPackageXRefHosp b
		where a.molecule_cn_src=b.molecule_cn_src and a.product_cn_src=b.product_cn_src 
		and a.manu_cn_Src=b.manu_cn_Src and a.package_code=b.package_code and a.Form_Src=b.Form_Src  and a.Specification_Src=b.Specification_Src
		)
	) t2
on t1.Molecule=t2.Molecule_CN_Src and t1.Product=t2.Product_CN_Src and t1.Manufacture=t2.Manu_CN_Src
and FormI=Form_Src and t1.Specification=t2.Specification_Src          
inner join tblDatamonthConv t3 on t1.YM=t3.Datamonth inner join tblHospitalMaster t4 on t1.CPA_ID=t4.ID
where t4.Datasource='SEA' 
group by Package_code, DM, CPA_ID 
go
insert into tblHospitalDataRaw
select convert(varchar(13),t2.Package_Code) as Package_Code, t3.DM, t1.CPA_ID
, convert(int, sum(t1.Value)) as Value , convert(int, sum(t1.Volume)) as Volume
from inPharmData t1 inner join (
	select distinct Molecule_CN_Src,Product_CN_Src ,Manu_CN_Src,Form_Src,Specification_Src,Package_Code
	from  db4.BMSChinaMRBI.dbo.tblPackageXRefHosp_OTC a
	where not exists(
		select 1
		from db4.BMSChinaMRBI.dbo.tblPackageXRefHosp b
		where a.molecule_cn_src=b.molecule_cn_src and a.product_cn_src=b.product_cn_src 
		and a.manu_cn_Src=b.manu_cn_Src and a.package_code=b.package_code and a.Form_Src=b.Form_Src  and a.Specification_Src=b.Specification_Src
		)
	) t2
on t1.Molecule=t2.Molecule_CN_Src and t1.Product=t2.Product_CN_Src and t1.Manufacture=t2.Manu_CN_Src
and t1.Form=t2.Form_Src and t1.Specification=t2.Specification_Src 
inner join tblDatamonthConv t3  on t1.Y=t3.Y and t1.M=t3.M inner join tblHospitalMaster t4 on t1.CPA_ID=t4.ID  
where t4.DataSource='PHA'
group by Package_code, DM, CPA_ID



update tblHospitalDataRaw set Value=isNull(Value,0),Volume=isNull(Volume,0)
GO


IF OBJECT_ID(N'tblHospitalDataCT',N'U') IS NOT NULL
 DROP TABLE tblHospitalDataCT
GO
CREATE TABLE [dbo].[tblHospitalDataCT](
	[DataType] [nvarchar](10) NULL,
	[Pack_Cod] [nvarchar](13) NULL,
	[CPA_ID] [int] NULL,
	[M48] [float] NULL,
	[M47] [float] NULL,
	[M46] [float] NULL,
	[M45] [float] NULL,
	[M44] [float] NULL,
	[M43] [float] NULL,
	[M42] [float] NULL,
	[M41] [float] NULL,
	[M40] [float] NULL,
	[M39] [float] NULL,
	[M38] [float] NULL,
	[M37] [float] NULL,
	[M36] [float] NULL,
	[M35] [float] NULL,
	[M34] [float] NULL,
	[M33] [float] NULL,
	[M32] [float] NULL,
	[M31] [float] NULL,
	[M30] [float] NULL,
	[M29] [float] NULL,
	[M28] [float] NULL,
	[M27] [float] NULL,
	[M26] [float] NULL,
	[M25] [float] NULL,
	[M24] [float] NULL,
	[M23] [float] NULL,
	[M22] [float] NULL,
	[M21] [float] NULL,
	[M20] [float] NULL,
	[M19] [float] NULL,
	[M18] [float] NULL,
	[M17] [float] NULL,
	[M16] [float] NULL,
	[M15] [float] NULL,
	[M14] [float] NULL,
	[M13] [float] NULL,
	[M12] [float] NULL,
	[M11] [float] NULL,
	[M10] [float] NULL,
	[M09] [float] NULL,
	[M08] [float] NULL,
	[M07] [float] NULL,
	[M06] [float] NULL,
	[M05] [float] NULL,
	[M04] [float] NULL,
	[M03] [float] NULL,
	[M02] [float] NULL,
	[M01] [float] NULL
) 
go

INSERT INTO tblHospitalDataCT
select 'MTHRMB' AS DATATYPE,*
FROM 
(SELECT PACKAGE_CODE,DM,CPA_ID,VALUE from tblHospitalDataRaw) a
pivot (
	sum(Value) for DM in(
	 M48,M47,M46,M45,M44,M43,M42,M41,M40,M39,M38,M37
	,M36,M35,M34,M33,M32,M31,M30,M29,M28,M27,M26,M25
	,M24,M23,M22,M21,M20,M19,M18,M17,M16,M15,M14,M13
	,M12,M11,M10,M09,M08,M07,M06,M05,M04,M03,M02,M01)
) pvt
GO

INSERT INTO tblHospitalDataCT
select 'MTHUSD' AS DATATYPE,*
FROM 
(SELECT PACKAGE_CODE,DM,CPA_ID,[VALUE]/(select rate from db4.bmschinacia_ims.dbo.tblrate) AS [VALUE] from tblHospitalDataRaw) a
pivot (
	sum([Value]) for DM in(
	 M48,M47,M46,M45,M44,M43,M42,M41,M40,M39,M38,M37
	,M36,M35,M34,M33,M32,M31,M30,M29,M28,M27,M26,M25
	,M24,M23,M22,M21,M20,M19,M18,M17,M16,M15,M14,M13
	,M12,M11,M10,M09,M08,M07,M06,M05,M04,M03,M02,M01)
) pvt
GO

INSERT INTO tblHospitalDataCT
select 'MTHUNT' AS DATATYPE,*
FROM 
(SELECT PACKAGE_CODE,DM,CPA_ID,Volume from tblHospitalDataRaw) a
pivot (
	sum(Volume) for DM in(
	 M48,M47,M46,M45,M44,M43,M42,M41,M40,M39,M38,M37
	,M36,M35,M34,M33,M32,M31,M30,M29,M28,M27,M26,M25
	,M24,M23,M22,M21,M20,M19,M18,M17,M16,M15,M14,M13
	,M12,M11,M10,M09,M08,M07,M06,M05,M04,M03,M02,M01)
) pvt
GO

UPDATE tblHospitalDataCT SET M01 = 0 WHERE M01 IS NULL
go
UPDATE tblHospitalDataCT SET M02 = 0 WHERE M02 IS NULL
go
UPDATE tblHospitalDataCT SET M03 = 0 WHERE M03 IS NULL
go
UPDATE tblHospitalDataCT SET M04 = 0 WHERE M04 IS NULL
go
UPDATE tblHospitalDataCT SET M05 = 0 WHERE M05 IS NULL
go
UPDATE tblHospitalDataCT SET M06 = 0 WHERE M06 IS NULL
go
UPDATE tblHospitalDataCT SET M07 = 0 WHERE M07 IS NULL
go
UPDATE tblHospitalDataCT SET M08 = 0 WHERE M08 IS NULL
go
UPDATE tblHospitalDataCT SET M09 = 0 WHERE M09 IS NULL
go
UPDATE tblHospitalDataCT SET M10 = 0 WHERE M10 IS NULL
go
UPDATE tblHospitalDataCT SET M11 = 0 WHERE M11 IS NULL
go
UPDATE tblHospitalDataCT SET M12 = 0 WHERE M12 IS NULL
go
UPDATE tblHospitalDataCT SET M13 = 0 WHERE M13 IS NULL
go
UPDATE tblHospitalDataCT SET M14 = 0 WHERE M14 IS NULL
go
UPDATE tblHospitalDataCT SET M15 = 0 WHERE M15 IS NULL
go
UPDATE tblHospitalDataCT SET M16 = 0 WHERE M16 IS NULL
go
UPDATE tblHospitalDataCT SET M17 = 0 WHERE M17 IS NULL
go
UPDATE tblHospitalDataCT SET M18 = 0 WHERE M18 IS NULL
go
UPDATE tblHospitalDataCT SET M19 = 0 WHERE M19 IS NULL
go
UPDATE tblHospitalDataCT SET M20 = 0 WHERE M20 IS NULL
go
UPDATE tblHospitalDataCT SET M21 = 0 WHERE M21 IS NULL
go
UPDATE tblHospitalDataCT SET M22 = 0 WHERE M22 IS NULL
go
UPDATE tblHospitalDataCT SET M23 = 0 WHERE M23 IS NULL
go
UPDATE tblHospitalDataCT SET M24 = 0 WHERE M24 IS NULL
go


UPDATE tblHospitalDataCT SET M48 = 0 WHERE M48 IS NULL
GO
UPDATE tblHospitalDataCT SET M47 = 0 WHERE M47 IS NULL
GO
UPDATE tblHospitalDataCT SET M46 = 0 WHERE M46 IS NULL
GO
UPDATE tblHospitalDataCT SET M45 = 0 WHERE M45 IS NULL
GO
UPDATE tblHospitalDataCT SET M44 = 0 WHERE M44 IS NULL
GO
UPDATE tblHospitalDataCT SET M43 = 0 WHERE M43 IS NULL
GO
UPDATE tblHospitalDataCT SET M42 = 0 WHERE M42 IS NULL
GO
UPDATE tblHospitalDataCT SET M41 = 0 WHERE M41 IS NULL
GO
UPDATE tblHospitalDataCT SET M40 = 0 WHERE M40 IS NULL
GO
UPDATE tblHospitalDataCT SET M39 = 0 WHERE M39 IS NULL
GO
UPDATE tblHospitalDataCT SET M38 = 0 WHERE M38 IS NULL
GO
UPDATE tblHospitalDataCT SET M37 = 0 WHERE M37 IS NULL
GO
UPDATE tblHospitalDataCT SET M36 = 0 WHERE M36 IS NULL
GO
UPDATE tblHospitalDataCT SET M35 = 0 WHERE M35 IS NULL
GO
UPDATE tblHospitalDataCT SET M34 = 0 WHERE M34 IS NULL
GO
UPDATE tblHospitalDataCT SET M33 = 0 WHERE M33 IS NULL
GO
UPDATE tblHospitalDataCT SET M32 = 0 WHERE M32 IS NULL
GO
UPDATE tblHospitalDataCT SET M31 = 0 WHERE M31 IS NULL
GO
UPDATE tblHospitalDataCT SET M30 = 0 WHERE M30 IS NULL
GO
UPDATE tblHospitalDataCT SET M29 = 0 WHERE M29 IS NULL
GO
UPDATE tblHospitalDataCT SET M28 = 0 WHERE M28 IS NULL
GO
UPDATE tblHospitalDataCT SET M27 = 0 WHERE M27 IS NULL
GO
UPDATE tblHospitalDataCT SET M26 = 0 WHERE M26 IS NULL
GO
UPDATE tblHospitalDataCT SET M25 = 0 WHERE M25 IS NULL
GO
exec dbo.sp_Log_Event 'Process','QT_CPA_Inline','Step_1_Create_tblHospitalDataRaw.sql','End',null,null
