use BMSCNProc2
go



--Check whether there are these two tables? 
--select top 2 * from tblHospitalDataRaw 
--select top 2 * from  tblHospitalDataRawPrv


--Hospital Data Processing (12/26/11)
--Refresh tblDatamonthConv first...
--
--drop table tblHospAvailCPA
go
--select distinct t1.CPA_Code, t1.CPA_ID, CPA_Name, CPA_Name_English
--into tblHospAvailCPA from inCPAData t1 inner join tblHospitalmaster t2 on t1.CPA_Code=t2.CPA_Code
--where t2.DataSource='CPA'
go
--drop table tblHospAvailSEA
go
--select distinct CPA_ID, Hospital as CPA_Name into tblHospAvailSea from inSearainbowdata
go
--delete tblHospAvailSea where CPA_ID in (select distinct CPA_ID from tblHospAvailCPA)
go



if object_id(N'tblHospitalMasterPrv',N'U') is not null
	drop table tblHospitalMasterPrv
go

select * into tblHospitalMasterPrv from tblHospitalMaster
go


truncate table tblHospitalMaster
go
Insert into tblHospitalMaster
select distinct [ID], DataSource, CPA_Code, CPA_Name, CPA_Name_English, Tier, Province, City, City as Area, City_En
from db4.BMSChinaMRBI.dbo.tblHospitalMaster
go
update tblHospitalMaster set City = N'海南',City_en = 'HaiNan'
where city = N'省直辖县级行政单位'
go
/*
select 'Duplicated hospitals in raw tblHospitalmaster: '+ convert(varchar, count(*)) 
from (select [ID], COUNT(*) as DupCount from tblHospitalMaster group by [ID] having COUNT(*)>1) as t1
go
select 'Duplicated hospitals in dedupped tblHospitalmaster: '+ convert(varchar, count(*)) 
from (select [ID], COUNT(*) as DupCount from tblHospitalMaster group by [ID] having COUNT(*)>1) as t1
go
*/


truncate table tblHospitalList
go
insert into tblHospitalList
select  ID as Hosp_ID, CPA_Name as Hosp_Des_CN, upper(CPA_Name_English) as Hosp_Des_EN,
Tier, Province, City as City_CN, upper(City_EN) as City_EN 
from tblHospitalmaster 
go


if object_id(N'tblHospitalDataRawPrv',N'U') is not null
	drop table tblHospitalDataRawPrv
go
select * into tblHospitalDataRawPrv from tblHospitalDataRaw
go






Print('----------------------------
		tblHospitalDataRaw
----------------------------------')
drop table tblHospitalDataRaw
go
select 
    convert(varchar(12),t2.Package_Code) as Package_Code
    , t3.DM
    , t1.CPA_ID
    , convert(int, sum(t1.Value)) as Value
    , convert(int, sum(t1.Volume)) as Volume
into tblHospitalDataRaw 
from inCPAData t1 inner join tblPackageXRefHosp t2
on t1.Molecule=t2.Molecule_CN_Src and t1.Product=t2.Product_CN_Src 
	 and Form_Src=Form and t1.Specification=t2.Specification_Src 
	 and t1.Manufacture=t2.Manu_CN_Src
inner join tblDatamonthConv t3 on t1.Y=t3.Y and t1.M=t3.M--（201101-201212）
inner join tblHospitalMaster t4 on t1.CPA_ID=t4.ID 
where t4.DataSource='CPA'
group by Package_code, DM, CPA_ID
go




/*
Insert ONCFCS market rollup including sales from all 3 oncology molecules from CPA data.  
Sea Rainbow has no ONCOLOGY data:

insert into tblHospitalDataRaw
select 'ONCFCSMKT00' as Packge_Code, DM, CPA_ID, convert(int, sum(Value)) as Value, convert(int, sum(Volume)) as Volume
from inCPAData t1
inner join tblDatamonthConv t3 on t1.Y=t3.Y and t1.M=t3.M
inner join tblHospitalMaster t4 on t1.CPA_ID=t4.ID 
where t4.DataSource='CPA' and ATC_Code in ('L01CD01', 'L01CD02', 'L01BC05')
group by DM, CPA_ID
*/

insert into tblHospitalDataRaw
select 
    convert(varchar(12),Package_Code) as Package_Code
    , DM
    , CPA_ID
    , convert(int, sum(Value)) as Value
    , convert(int, sum(Volume)) as Volume
from inSeaRainbowData t1 inner join tblPackageXRefHosp t2
on t1.Molecule=t2.Molecule_CN_Src and t1.Product=t2.Product_CN_Src and Form_Src=FormI 
   and t1.Specification=t2.Specification_Src and t1.Manufacture=t2.Manu_CN_Src
inner join tblDatamonthConv t3 on t1.YM=t3.Datamonth
inner join tblHospitalMaster t4 on t1.CPA_ID=t4.ID
where t4.Datasource='SEA' 
group by Package_code, DM, CPA_ID 
go







Print('----------------------------
		tblHospitalDataCT
----------------------------------')
IF OBJECT_ID(N'tblHospitalDataCT',N'U') IS NOT NULL
	DROP TABLE tblHospitalDataCT
GO

CREATE TABLE [dbo].[tblHospitalDataCT](
	[DataType] [nvarchar](10) NULL,
	[Pack_Cod] [nvarchar](12) NULL,
	[CPA_ID] [int] NULL,
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
	sum(Value) for DM in(M24,M23,M22,M21,M20,M19,M18,M17,M16,M15,M14,M13,M12,M11,M10,M09,M08,M07,M06,M05,M04,M03,M02,M01)
) pvt
GO

INSERT INTO tblHospitalDataCT
select 'MTHUSD' AS DATATYPE,*
FROM 
(SELECT PACKAGE_CODE,DM,CPA_ID,[VALUE]/6.34888 AS [VALUE] from tblHospitalDataRaw) a
pivot (
	sum([Value]) for DM in(M24,M23,M22,M21,M20,M19,M18,M17,M16,M15,M14,M13,M12,M11,M10,M09,M08,M07,M06,M05,M04,M03,M02,M01)
) pvt
GO

INSERT INTO tblHospitalDataCT
select 'MTHUNT' AS DATATYPE,*
FROM 
(SELECT PACKAGE_CODE,DM,CPA_ID,Volume from tblHospitalDataRaw) a
pivot (
	sum(Volume) for DM in(M24,M23,M22,M21,M20,M19,M18,M17,M16,M15,M14,M13,M12,M11,M10,M09,M08,M07,M06,M05,M04,M03,M02,M01)
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
GO
