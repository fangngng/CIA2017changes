use BMSCNProc2_test
go

exec dbo.sp_Log_Event 'Process','QT_CPA_Inline','Step_1_Create_tblHospitalDataRaw.sql','Start',null,null


-- add new hospital -> tblHospitalList_Pipeline
insert into tblHospitalList_Pipeline
select CPA_code, CPA_Name, CPA_Name_ENglish, Tier, Province, City, City_en 
from tblHospitalMaster where
CPA_CODE in (
            select distinct [医院_编码] from inCPAData_pipeline a
            where not exists (
                              select * from tblHospitalList_Pipeline b
                              where a.[医院_编码]=b.hosp_ID
                              )
            )

--new hospital -> tblHospitalMaster
insert into tblHospitalMaster
	(DataSource, CPA_Code, CPA_Name, CPA_Name_English, Tier, Province, City, Area, City_EN)
select 'CPA', Hosp_ID, Hosp_Des_CN,Hosp_Des_EN, Tier,Province, City_CN, City_CN, City_EN
from tblHospitalList_Pipeline 
where Hosp_ID in (
                 select distinct [医院_编码] 
                 from inCPAData_pipeline a
                 where not exists (
                                   select * from tblHospitalMaster b
                                   where a.[医院_编码]=b.CPA_code
                                   )
                 )




drop table tblHospitalDataRaw_pipeline
go
select 
	convert(varchar(13),Pack_Cod) as Package_Code, DQ, t4.CPA_Code 
     , convert(int, sum([金额_(元)])) as Value
     , convert(int, sum([数量_(支/片)])) as Volume
into tblHospitalDataRaw_pipeline
from inCPAData_pipeline t1 
inner join [tblPackageXRefCPA_Pipeline] t2
on 
	t1.药品名称=t2.Molecule_CN_Src 
	and t1.商品名=t2.Product_CN_Src and t1.生产厂家=t2.Manuf_CN_Src 
	and t1.剂型=t2.Form_Src and t1.规格=t2.Strength_Src  
inner join tblDataQtrConv t3 on t1.年 =t3.Y and t1.季_度=t3.Q
inner join tblHospitalMaster t4 on t1.[医院_编码]=t4.CPA_Code 
where t4.DataSource='CPA'
group by Pack_Cod, DQ, t4.CPA_code 
GO


IF OBJECT_ID(N'tblHospitalDataCT_pipeline',N'U') IS NOT NULL
	DROP TABLE tblHospitalDataCT_pipeline
GO
CREATE TABLE [dbo].[tblHospitalDataCT_pipeline](
	[DataType] [nvarchar](10) NULL,
	[Pack_Cod] [nvarchar](13) NULL,
	[CPA_Code] [int] NULL,
	[M01] [float] NULL,
	[M02] [float] NULL,
	[M03] [float] NULL,
	[M04] [float] NULL,
	[M05] [float] NULL,
	[M06] [float] NULL,
	[M07] [float] NULL,
	[M08] [float] NULL,
	[M09] [float] NULL,
	[M10] [float] NULL,
	[M11] [float] NULL,
	[M12] [float] NULL,
	[M13] [float] NULL,
	[M14] [float] NULL,
	[M15] [float] NULL,
	[M16] [float] NULL,
	[M17] [float] NULL,
	[M18] [float] NULL,
	[M19] [float] NULL,
	[M20] [float] NULL,
	[M21] [float] NULL,
	[M22] [float] NULL,
	[M23] [float] NULL,
	[M24] [float] NULL,
	[M25] [float] NULL,
	[M26] [float] NULL,
	[M27] [float] NULL
) 
go


INSERT INTO tblHospitalDataCT_pipeline
select 
   'MQTRMB' AS DATATYPE, PACKAGE_CODE,CPA_Code
   ,Q1 as M01,Q2 as M02,Q3 as M03,Q4 as M04,Q5 as M05,Q6 as M06
   ,Q7 as M07, Q8 as M08, Q9 as M09, Q10 as M10, Q11 as M11, Q12 as M12
   ,Q13 as M13, Q14 as M14, Q15 as M15, Q16 as M16, Q17 as M17, Q18 as M18
   ,Q19 as M19, Q20 as M20, Q21 as M21, Q22 as M22, Q23 as M23, Q24 as M24
   ,Q25 AS M25, Q26 AS M26, Q27 AS M27
FROM 
(	SELECT PACKAGE_CODE,DQ,CPA_Code,VALUE from tblHospitalDataRaw_pipeline	) a
pivot (
	sum(Value) for DQ in(Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15,Q16
		,Q17,Q18,Q19,Q20,Q21,Q22,Q23,Q24,Q25,Q26,Q27)
) pvt
GO

INSERT INTO tblHospitalDataCT_pipeline
select 'MQTUSD' AS DATATYPE, PACKAGE_CODE,CPA_Code
	,Q1 as M01,Q2 as M02,Q3 as M03,Q4 as M04,Q5 as M05,Q6 as M06
	, Q7 as M07, Q8 as M08, Q9 as M09, Q10 as M10, Q11 as M11, Q12 as M12
	, Q13 as M13, Q14 as M14, Q15 as M15, Q16 as M16, Q17 as M17, Q18 as M18
	, Q19 as M19, Q20 as M20, Q21 as M21, Q22 as M22, Q23 as M23, Q24 as M24
	, Q25 AS M25, Q26 AS M26, Q27 AS M27
FROM 
(SELECT PACKAGE_CODE,DQ,CPA_Code,[VALUE]/(select rate from db4.bmschinacia_ims.dbo.tblrate) AS [VALUE] from tblHospitalDataRaw_pipeline) a
pivot (
	sum(Value) for DQ in(Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15,Q16
		,Q17,Q18,Q19,Q20,Q21,Q22,Q23,Q24,Q25,Q26,Q27)
) pvt
GO

INSERT INTO tblHospitalDataCT_pipeline
select 'MQTUNT' AS DATATYPE, PACKAGE_CODE, CPA_Code
	,Q1 as M01,Q2 as M02,Q3 as M03,Q4 as M04,Q5 as M05,Q6 as M06
	, Q7 as M07, Q8 as M08, Q9 as M09, Q10 as M10, Q11 as M11, Q12 as M12
	, Q13 as M13, Q14 as M14, Q15 as M15, Q16 as M16, Q17 as M17, Q18 as M18
	, Q19 as M19, Q20 as M20, Q21 as M21, Q22 as M22, Q23 as M23, Q24 as M24
	,Q25 AS M25,Q26 AS M26, Q27 AS M27
FROM 
(SELECT PACKAGE_CODE,DQ,CPA_Code,Volume from tblHospitalDataRaw_pipeline) a
pivot (
	sum(Volume) for DQ in(Q1,Q2,Q3,Q4,Q5,Q6,Q7,Q8,Q9,Q10,Q11,Q12,Q13,Q14,Q15,Q16
		,Q17,Q18,Q19,Q20,Q21,Q22,Q23,Q24,Q25,Q26,Q27)
) pvt
GO

UPDATE tblHospitalDataCT_pipeline SET M01 = 0 WHERE M01 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M02 = 0 WHERE M02 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M03 = 0 WHERE M03 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M04 = 0 WHERE M04 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M05 = 0 WHERE M05 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M06 = 0 WHERE M06 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M07 = 0 WHERE M07 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M08 = 0 WHERE M08 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M09 = 0 WHERE M09 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M10 = 0 WHERE M10 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M11 = 0 WHERE M11 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M12 = 0 WHERE M12 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M13 = 0 WHERE M13 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M14 = 0 WHERE M14 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M15 = 0 WHERE M15 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M16 = 0 WHERE M16 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M17 = 0 WHERE M17 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M18 = 0 WHERE M18 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M19 = 0 WHERE M19 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M20 = 0 WHERE M20 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M21 = 0 WHERE M21 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M22 = 0 WHERE M22 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M23 = 0 WHERE M23 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M24 = 0 WHERE M24 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M25 = 0 WHERE M25 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M26 = 0 WHERE M26 IS NULL
go
UPDATE tblHospitalDataCT_pipeline SET M27 = 0 WHERE M27 IS NULL

exec dbo.sp_Log_Event 'Process','QT_CPA_Inline','Step_1_Create_tblHospitalDataRaw.sql','End',null,null


