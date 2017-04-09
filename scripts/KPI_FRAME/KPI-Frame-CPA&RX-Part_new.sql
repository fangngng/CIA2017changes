USE BMSChinaMRBI
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
time:
*/
--add Eliquis CPA KPIFrame Market
--log

exec dbo.sp_Log_Event 'KPI Frame','CIA CPA','KPI-Frame-CPA&RX-Part_new.sql','Start',null,null

go
alter table dbo.BMS_CPA_Hosp_Category alter column [CPA Code] varchar (20)

update BMS_CPA_Hosp_Category
set [CPA Code]='0'+[CPA Code]
where len([cpa code])=5


if object_id(N'tblMktDefHospital_Eliquis_CPA_KPIFrame',N'U') is not null
	drop table tblMktDefHospital_Eliquis_CPA_KPIFrame
go

--select *
--into tblMktDefHospital_Eliquis_CPA_KPIFrame
--from tblMktDefHospital
--where mkt='Eliquis' and Prod_Des_EN in ('Xarelto','Eliquis')

select *
into tblMktDefHospital_Eliquis_CPA_KPIFrame
from tblMktDefHospital
where mkt='Eliquis VTEp' and productname in ('Xarelto','Eliquis')
-- where mkt='Eliquis VTEp' and IMSMoleCode in ('406260','408800','408827','413885','703259','704307','710047','711981','719372', '904100','999999') 
--  		and Prod_des_en <> 'CONTRACTUBEX' -- 去掉复方产品

-- insert into tblMktDefHospital_Eliquis_CPA_KPIFrame
-- select mkt,mktname,'000' as Prod,'Eliquis Market' as productname,'N' as Molecule,'N' as Class,
-- 	   atc3_cod,atc_cpa,mole_des_cn,mole_Des_En,Prod_des_cn,Prod_des_en,FocusedBrand,IMSMoleCode,IMSProdCode,product,1
-- from tblMktDefHospital_Eliquis_CPA_R640 where  productname in ('Xarelto','Eliquis')

insert into tblMktDefHospital_Eliquis_CPA_KPIFrame
select mkt,mktname,'000' as Prod,'Eliquis Market' as productname,'N' as Molecule,'N' as Class,
	   atc3_cod,atc_cpa,mole_des_cn,mole_Des_En,Prod_des_cn,Prod_des_en,FocusedBrand,IMSMoleCode,IMSProdCode,product,rat
from tblMktDefHospital 
where mkt='Eliquis VTEp' and IMSMoleCode in ('406260','408800','408827','413885','703259','704307','710047','711981','719372', '904100','999999') 
 		and Prod_des_en <> 'CONTRACTUBEX' -- 去掉复方产品
		and prod  = '000'


-- insert into tblMktDefHospital_Eliquis_CPA_KPIFrame
-- select mkt,mktname,'000' as Prod,'Eliquis Market' as productname,'N' as Molecule,'N' as Class,
-- 	   atc3_cod,atc_cpa,mole_des_cn,mole_Des_En,Prod_des_cn,Prod_des_en,FocusedBrand,IMSMoleCode,IMSProdCode,product,1
-- from tblMktDefHospital_Eliquis_CPA_R640 where  productname not in ('Xarelto','Eliquis') 
-- 	and IMSMoleCode in ('406260','408800','408827','413885','703259','704307','710047','711981','719372', '904100','999999') 
-- 		and Prod_des_en <> 'CONTRACTUBEX'

-- update tblMktDefHospital_Eliquis_CPA_KPIFrame
-- set Rat = case 
-- 				-- when Mole_cod='239900' then 0.01  --WARFARIN
-- 				when IMSMoleCode='406260' then 0.03 --ENOXAPARIN SODIUM 
-- 				when IMSMoleCode='408800' then 0.01 --HEPARIN
-- 				when IMSMoleCode='408827' then 0.02 --DALTEPARIN SODIUM
-- 				when IMSMoleCode='413885' then 0.01 --LOW MOLECULAR WEIGHT HEPARIN
-- 				when IMSMoleCode='703259' then 0.01 --FONDAPARINUX SODIUM
-- 				when IMSMoleCode='704307' then 0.01 --NADROPARIN CALCIUM
-- 			--  when IMSMoleCode='710047' then 0.03 --DABIGATRAN ETEXILATE
-- 				when IMSMoleCode='711981' then 0.36 --RIVAROXABAN
-- 				when IMSMoleCode='999999' then 0.36 --RIVAROXABAN
-- 				when IMSMoleCode='719372' then 1.0 --APIXABAN
-- 				when IMSMoleCode='904100' then 0.01  --LOW MOLECULAR WEIGHT HEPARIN CALCIUM
-- 			end

--add Eliquis CPA KPIFrame Temp
print('------------------------------------------------------
                   tempHospitalDataByMth_Eliquis_CPA_KPIFrame
-------------------------------------------------------------')
if object_id(N'tempHospitalDataByMth_Eliquis_CPA_KPIFrame',N'U') is not null
  drop table tempHospitalDataByMth_Eliquis_CPA_KPIFrame
GO
--1. CPA :
select 
	'CPA' as DataSource
	, c.Mkt
	, c.Prod
	, a.cpa_id
	, a.Tier
	, convert(varchar(6),convert(Datetime,a.M+'/1/'+Y,101),112) as Mth
	, sum(Value*rat)  as Sales
	, sum(Volume*rat) as Units
	, sum(Volume*rat*cast(subString(Specification,1,charindex(' ',Specification)) as float)/AvgPatientMG) as Adjusted_PatientNumber
into tempHospitalDataByMth_Eliquis_CPA_KPIFrame
from inCPAData a
inner join tblMktDefHospital_Eliquis_CPA_KPIFrame c                                     
on a.Molecule = c.Mole_Des_CN and a.Product = c.Prod_Des_CN
where exists(
            select * from tblHospitalMaster b 
            where a.cpa_id = b.id and b.DataSource = 'CPA'
            )
group by c.Mkt,c.Prod,a.cpa_id, a.Tier,a.M+'/1/'+Y
go

update tempHospitalDataByMth_Eliquis_CPA_KPIFrame set Adjusted_PatientNumber = 0 where Adjusted_PatientNumber is null
GO

--进行行列转置
print('------------------------------------------------------
                   tempHospitalData_Eliquis_CPA_KPIFrame
-------------------------------------------------------------')
if object_id(N'tempHospitalData_Eliquis_CPA_KPIFrame',N'U') is not null
	drop table tempHospitalData_Eliquis_CPA_KPIFrame
go
select distinct DataSource,Mkt,Prod,Cpa_id,Tier
into tempHospitalData_Eliquis_CPA_KPIFrame
from tempHospitalDataByMth_Eliquis_CPA_KPIFrame
go

create nonclustered index idx on tempHospitalData_Eliquis_CPA_KPIFrame(cpa_id)
go

declare @i int, @sql varchar(8000)
set @sql = 'alter table tempHospitalData_Eliquis_CPA_KPIFrame add
'
set @i = 1
while @i <= 36
begin
   set @sql = @sql 
                   + 'UM' + cast(@i as varchar) + ' decimal(22,6) not null default 0,
'
                   + 'VM' + cast(@i as varchar) + ' decimal(22,6) not null default 0,
'
                   + 'PM' + cast(@i as varchar) + ' decimal(22,6) not null default 0,
'
   set @i = @i + 1
end
set @sql = left(@sql,len(@sql)-3)
execute(@sql)
go

declare @i int, @sql varchar(8000), @mth as datetime
set @i = 1
select @mth = convert(DateTime,Value1+'01',112) from tblDSDates where Item='CPA'
while @i <= 36
begin
	set @sql = 
'update tempHospitalData_Eliquis_CPA_KPIFrame set 
 UM' + cast(@i as varchar) + '=b.Units
,VM' + cast(@i as varchar) + '=b.Sales
,PM' + cast(@i as varchar) + '=b.Adjusted_PatientNumber
from tempHospitalData_Eliquis_CPA_KPIFrame a
inner join tempHospitalDataByMth_Eliquis_CPA_KPIFrame b on a.Mkt = b.Mkt and a.Prod = b.Prod and a.cpa_id = b.cpa_id
where b.Mth = (select Mth from tblHospitalMthList where idx = ' + cast(@i as varchar) + ')
'
	exec (@sql)
	set @i = @i + 1
end 
go


  --Rollup到YTD,MAT
alter table tempHospitalData_Eliquis_CPA_KPIFrame add
	UYTD		decimal(22,6),
	UYTDStly	decimal(22,6),
	UMAT1		DECIMAL(22,6),
	UMAT2		DECIMAL(22,6),
	UMAT3		DECIMAL(22,6),

	VYTD		decimal(22,6),
	VYTDStly	decimal(22,6),
	VMAT1		DECIMAL(22,6),
	VMAT2		DECIMAL(22,6),
	VMAT3		DECIMAL(22,6),

	PYTD		decimal(22,6),
	PYTDStly	decimal(22,6),
	PMAT1		DECIMAL(22,6),
	PMAT2		DECIMAL(22,6),
	PMAT3		DECIMAL(22,6)
GO

declare @cnt int, @sql varchar(max)
select @cnt = max(idx) from tblHospitalMthlist where Left(Mth,4) = (select left(Mth,4) from tblHospitalMthList where Idx = 1)
set @sql = '
UPDATE tempHospitalData_Eliquis_CPA_KPIFrame SET
	UYTD = (' + DBO.f_assemble_sum('UM',1, @cnt) + '),
	UYTDSTLY = (' + DBO.f_assemble_sum('UM',1+12, @cnt+12) + '),
	UMAT1 = (' + DBO.f_assemble_sum('UM',1,12) + '),
	UMAT2 = (' + DBO.f_assemble_sum('UM',13,24) + '),
	UMAT3 = (' + DBO.f_assemble_sum('UM',25,36) + '),
	VYTD = (' + DBO.f_assemble_sum('VM',1, @cnt) + '),
	VYTDSTLY = (' + DBO.f_assemble_sum('VM',1+12, @cnt+12) + '),
	VMAT1 = (' + DBO.f_assemble_sum('VM',1,12) + '),
	VMAT2 = (' + DBO.f_assemble_sum('VM',13,24) + '),
	VMAT3 = (' + DBO.f_assemble_sum('VM',25,36) + '),
    PYTD = (' + DBO.f_assemble_sum('PM',1, @cnt) + '),
	PYTDSTLY = (' + DBO.f_assemble_sum('PM',1+12, @cnt+12) + '),
	PMAT1 = (' + DBO.f_assemble_sum('PM',1,12) + '),
	PMAT2 = (' + DBO.f_assemble_sum('PM',13,24) + '),
	PMAT3 = (' + DBO.f_assemble_sum('PM',25,36) + ')
' 
--print @SQL
EXEC  (@SQL)
GO

EXEC P_EXTEND_TABLE 'tempHospitalData_Eliquis_CPA_KPIFrame','UR3M',1,24, 'DECIMAL(22,6)'
GO
EXEC P_EXTEND_TABLE 'tempHospitalData_Eliquis_CPA_KPIFrame','VR3M',1,24, 'DECIMAL(22,6)'
GO
EXEC P_EXTEND_TABLE 'tempHospitalData_Eliquis_CPA_KPIFrame','PR3M',1,24, 'DECIMAL(22,6)'
GO



DECLARE @I INT,@sql varchar(8000)
declare @st int, @ed int
set @i = 1
set @sql = 'update tempHospitalData_Eliquis_CPA_KPIFrame set
'
Set @i = 1
while @i <= 24
begin
	set @sql = @sql + 'UR3M' + cast(@i as varchar) + '=' + dbo.f_assemble_sum('UM',@i,@i+2) + ','
	set @sql = @sql + 'VR3M' + cast(@i as varchar) + '=' + dbo.f_assemble_sum('VM',@i,@i+2) + ','
    set @sql = @sql + 'PR3M' + cast(@i as varchar) + '=' + dbo.f_assemble_sum('PM',@i,@i+2) + ',
'
	set @i = @i + 1
end

SET @SQL = LEFT(@SQL,LEN(@SQL)-3)
EXEC(@SQL)
GO


if object_id(N'tblMktDefHospital_Baraclude_CPA_KPIFrame',N'U') is not null
	drop table tblMktDefHospital_Baraclude_CPA_KPIFrame
go

select *
into tblMktDefHospital_Baraclude_CPA_KPIFrame
from tblMktDefHospital
where mkt='arv' 

insert into tblMktDefHospital_Baraclude_CPA_KPIFrame (
	Mkt,MktName,prod,productName,molecule,class,atc3_cod,atc_cpa,mole_des_cn,mole_des_en,
	prod_des_cn,prod_des_en,FocusedBrand,IMSMoleCode,IMSProdCode,Product
)
select Mkt,MktName,'800' as prod,'VIREAD' as productName,molecule,class,atc3_cod,atc_cpa,mole_des_cn,mole_des_en,
	prod_des_cn,prod_des_en,FocusedBrand,IMSMoleCode,IMSProdCode,Product
from tblMktDefHospital where mkt='arv' and prod_des_en='VIREAD'



--add Eliquis CPA KPIFrame Temp
print('------------------------------------------------------
                   tempHospitalDataByMth_Baraclude_CPA_KPIFrame
-------------------------------------------------------------')
if object_id(N'tempHospitalDataByMth_Baraclude_CPA_KPIFrame',N'U') is not null
  drop table tempHospitalDataByMth_Baraclude_CPA_KPIFrame
GO
--1. CPA :
select 
   'CPA' as DataSource
 , c.Mkt
 , c.Prod
 , a.cpa_id
 , a.Tier
 , convert(varchar(6),convert(Datetime,a.M+'/1/'+Y,101),112) as Mth
 , sum(Value*(case when c.prod_des_en='VIREAD' then 1 else 1 end))  as Sales
 , sum(Volume*(case when c.prod_des_en='VIREAD' then 1 else 1 end)) as Units
 , sum(Volume*cast(subString(Specification,1,charindex(' ',Specification)) as float)/AvgPatientMG) as Adjusted_PatientNumber
into tempHospitalDataByMth_Baraclude_CPA_KPIFrame
from inCPAData a
inner join tblMktDefHospital_Baraclude_CPA_KPIFrame c                                     
on a.Molecule = c.Mole_Des_CN and a.Product = c.Prod_Des_CN and not(c.molecule='Y' and c.Prod = 800  )
where exists(
            select * from tblHospitalMaster b 
            where a.cpa_id = b.id and b.DataSource = 'CPA'
            )
group by c.Mkt,c.Prod,a.cpa_id, a.Tier,a.M+'/1/'+Y
go

update tempHospitalDataByMth_Baraclude_CPA_KPIFrame set Adjusted_PatientNumber = 0 where Adjusted_PatientNumber is null
GO

--进行行列转置
print('------------------------------------------------------
                   tempHospitalData_Baraclude_CPA_KPIFrame
-------------------------------------------------------------')
if object_id(N'tempHospitalData_Baraclude_CPA_KPIFrame',N'U') is not null
	drop table tempHospitalData_Baraclude_CPA_KPIFrame
go
select distinct DataSource,Mkt,Prod,Cpa_id,Tier
into tempHospitalData_Baraclude_CPA_KPIFrame
from tempHospitalDataByMth_Baraclude_CPA_KPIFrame
go

create nonclustered index idx on tempHospitalData_Baraclude_CPA_KPIFrame(cpa_id)
go

declare @i int, @sql varchar(8000)
set @sql = 'alter table tempHospitalData_Baraclude_CPA_KPIFrame add
'
set @i = 1
while @i <= 36
begin
   set @sql = @sql 
                   + 'UM' + cast(@i as varchar) + ' decimal(22,6) not null default 0,
'
                   + 'VM' + cast(@i as varchar) + ' decimal(22,6) not null default 0,
'
                   + 'PM' + cast(@i as varchar) + ' decimal(22,6) not null default 0,
'
   set @i = @i + 1
end
set @sql = left(@sql,len(@sql)-3)
execute(@sql)
go

declare @i int, @sql varchar(8000), @mth as datetime
set @i = 1
select @mth = convert(DateTime,Value1+'01',112) from tblDSDates where Item='CPA'
while @i <= 36
begin
	set @sql = 
'update tempHospitalData_Baraclude_CPA_KPIFrame set 
 UM' + cast(@i as varchar) + '=b.Units
,VM' + cast(@i as varchar) + '=b.Sales
,PM' + cast(@i as varchar) + '=b.Adjusted_PatientNumber
from tempHospitalData_Baraclude_CPA_KPIFrame a
inner join tempHospitalDataByMth_Baraclude_CPA_KPIFrame b on a.Mkt = b.Mkt and a.Prod = b.Prod and a.cpa_id = b.cpa_id
where b.Mth = (select Mth from tblHospitalMthList where idx = ' + cast(@i as varchar) + ')
'
	exec (@sql)
	set @i = @i + 1
end 
go


  --Rollup到YTD,MAT
alter table tempHospitalData_Baraclude_CPA_KPIFrame add
	UYTD		decimal(22,6),
	UYTDStly	decimal(22,6),
	UMAT1		DECIMAL(22,6),
	UMAT2		DECIMAL(22,6),
	UMAT3		DECIMAL(22,6),

	VYTD		decimal(22,6),
	VYTDStly	decimal(22,6),
	VMAT1		DECIMAL(22,6),
	VMAT2		DECIMAL(22,6),
	VMAT3		DECIMAL(22,6),

	PYTD		decimal(22,6),
	PYTDStly	decimal(22,6),
	PMAT1		DECIMAL(22,6),
	PMAT2		DECIMAL(22,6),
	PMAT3		DECIMAL(22,6)
GO

declare @cnt int, @sql varchar(max)
select @cnt = max(idx) from tblHospitalMthlist where Left(Mth,4) = (select left(Mth,4) from tblHospitalMthList where Idx = 1)
set @sql = '
UPDATE tempHospitalData_Baraclude_CPA_KPIFrame SET
	UYTD = (' + DBO.f_assemble_sum('UM',1, @cnt) + '),
	UYTDSTLY = (' + DBO.f_assemble_sum('UM',1+12, @cnt+12) + '),
	UMAT1 = (' + DBO.f_assemble_sum('UM',1,12) + '),
	UMAT2 = (' + DBO.f_assemble_sum('UM',13,24) + '),
	UMAT3 = (' + DBO.f_assemble_sum('UM',25,36) + '),
	VYTD = (' + DBO.f_assemble_sum('VM',1, @cnt) + '),
	VYTDSTLY = (' + DBO.f_assemble_sum('VM',1+12, @cnt+12) + '),
	VMAT1 = (' + DBO.f_assemble_sum('VM',1,12) + '),
	VMAT2 = (' + DBO.f_assemble_sum('VM',13,24) + '),
	VMAT3 = (' + DBO.f_assemble_sum('VM',25,36) + '),
    PYTD = (' + DBO.f_assemble_sum('PM',1, @cnt) + '),
	PYTDSTLY = (' + DBO.f_assemble_sum('PM',1+12, @cnt+12) + '),
	PMAT1 = (' + DBO.f_assemble_sum('PM',1,12) + '),
	PMAT2 = (' + DBO.f_assemble_sum('PM',13,24) + '),
	PMAT3 = (' + DBO.f_assemble_sum('PM',25,36) + ')
' 
--print @SQL
EXEC  (@SQL)
GO

EXEC P_EXTEND_TABLE 'tempHospitalData_Baraclude_CPA_KPIFrame','UR3M',1,24, 'DECIMAL(22,6)'
GO
EXEC P_EXTEND_TABLE 'tempHospitalData_Baraclude_CPA_KPIFrame','VR3M',1,24, 'DECIMAL(22,6)'
GO
EXEC P_EXTEND_TABLE 'tempHospitalData_Baraclude_CPA_KPIFrame','PR3M',1,24, 'DECIMAL(22,6)'
GO



DECLARE @I INT,@sql varchar(8000)
declare @st int, @ed int
set @i = 1
set @sql = 'update tempHospitalData_Baraclude_CPA_KPIFrame set
'
Set @i = 1
while @i <= 24
begin
	set @sql = @sql + 'UR3M' + cast(@i as varchar) + '=' + dbo.f_assemble_sum('UM',@i,@i+2) + ','
	set @sql = @sql + 'VR3M' + cast(@i as varchar) + '=' + dbo.f_assemble_sum('VM',@i,@i+2) + ','
    set @sql = @sql + 'PR3M' + cast(@i as varchar) + '=' + dbo.f_assemble_sum('PM',@i,@i+2) + ',
'
	set @i = @i + 1
end

SET @SQL = LEFT(@SQL,LEN(@SQL)-3)
EXEC(@SQL)
GO


if object_id(N'tblMktDefHospital_Taxol_CPA_KPIFrame',N'U') is not null
	drop table tblMktDefHospital_Taxol_CPA_KPIFrame
go

select *
into tblMktDefHospital_Taxol_CPA_KPIFrame
from tblMktDefHospital
where mkt='oncfcs' and productname<> 'Oncology Focused Brands'

insert into tblMktDefHospital_Taxol_CPA_KPIFrame (
	Mkt,MktName,prod,productName,molecule,class,atc3_cod,atc_cpa,mole_des_cn,mole_des_en,
	prod_des_cn,prod_des_en,FocusedBrand,IMSMoleCode,IMSProdCode,Product
)
select Mkt,MktName,'010' as prod,'Total Paclitaxel' as productName,'Y' as molecule,'N' as class,atc3_cod,atc_cpa,mole_des_cn,mole_des_en,
	prod_des_cn,prod_des_en,FocusedBrand,IMSMoleCode,IMSProdCode,Product
from tblMktDefHospital where mkt='oncfcs' and Mole_des_en='PACLITAXEL' and prod='000'



--add Eliquis CPA KPIFrame Temp
print('------------------------------------------------------
                   tempHospitalDataByMth_Taxol_CPA_KPIFrame
-------------------------------------------------------------')
if object_id(N'tempHospitalDataByMth_Taxol_CPA_KPIFrame',N'U') is not null
  drop table tempHospitalDataByMth_Taxol_CPA_KPIFrame
GO
--1. CPA :
select 
   'CPA' as DataSource
 , c.Mkt
 , c.Prod
 , a.cpa_id
 , a.Tier
 , convert(varchar(6),convert(Datetime,a.M+'/1/'+Y,101),112) as Mth
 , sum(Value)  as Sales
 , sum(Volume) as Units
 , sum(Volume*cast(subString(Specification,1,charindex(' ',Specification)) as float)/AvgPatientMG) as Adjusted_PatientNumber
into tempHospitalDataByMth_Taxol_CPA_KPIFrame
from inCPAData a
inner join tblMktDefHospital_Taxol_CPA_KPIFrame c                                     
on a.Molecule = c.Mole_Des_CN and a.Product = c.Prod_Des_CN
where exists(
            select * from tblHospitalMaster b 
            where a.cpa_id = b.id and b.DataSource = 'CPA'
            )
group by c.Mkt,c.Prod,a.cpa_id, a.Tier,a.M+'/1/'+Y
go

update tempHospitalDataByMth_Taxol_CPA_KPIFrame set Adjusted_PatientNumber = 0 where Adjusted_PatientNumber is null
GO

--进行行列转置
print('------------------------------------------------------
                   tempHospitalData_Taxol_CPA_KPIFrame
-------------------------------------------------------------')
if object_id(N'tempHospitalData_Taxol_CPA_KPIFrame',N'U') is not null
	drop table tempHospitalData_Taxol_CPA_KPIFrame
go
select distinct DataSource,Mkt,Prod,Cpa_id,Tier
into tempHospitalData_Taxol_CPA_KPIFrame
from tempHospitalDataByMth_Taxol_CPA_KPIFrame
go

create nonclustered index idx on tempHospitalData_Taxol_CPA_KPIFrame(cpa_id)
go

declare @i int, @sql varchar(8000)
set @sql = 'alter table tempHospitalData_Taxol_CPA_KPIFrame add
'
set @i = 1
while @i <= 36
begin
   set @sql = @sql 
                   + 'UM' + cast(@i as varchar) + ' decimal(22,6) not null default 0,
'
                   + 'VM' + cast(@i as varchar) + ' decimal(22,6) not null default 0,
'
                   + 'PM' + cast(@i as varchar) + ' decimal(22,6) not null default 0,
'
   set @i = @i + 1
end
set @sql = left(@sql,len(@sql)-3)
execute(@sql)
go

declare @i int, @sql varchar(8000), @mth as datetime
set @i = 1
select @mth = convert(DateTime,Value1+'01',112) from tblDSDates where Item='CPA'
while @i <= 36
begin
	set @sql = 
'update tempHospitalData_Taxol_CPA_KPIFrame set 
 UM' + cast(@i as varchar) + '=b.Units
,VM' + cast(@i as varchar) + '=b.Sales
,PM' + cast(@i as varchar) + '=b.Adjusted_PatientNumber
from tempHospitalData_Taxol_CPA_KPIFrame a
inner join tempHospitalDataByMth_Taxol_CPA_KPIFrame b on a.Mkt = b.Mkt and a.Prod = b.Prod and a.cpa_id = b.cpa_id
where b.Mth = (select Mth from tblHospitalMthList where idx = ' + cast(@i as varchar) + ')
'
	exec (@sql)
	set @i = @i + 1
end 
go


  --Rollup到YTD,MAT
alter table tempHospitalData_Taxol_CPA_KPIFrame add
	UYTD		decimal(22,6),
	UYTDStly	decimal(22,6),
	UMAT1		DECIMAL(22,6),
	UMAT2		DECIMAL(22,6),
	UMAT3		DECIMAL(22,6),

	VYTD		decimal(22,6),
	VYTDStly	decimal(22,6),
	VMAT1		DECIMAL(22,6),
	VMAT2		DECIMAL(22,6),
	VMAT3		DECIMAL(22,6),

	PYTD		decimal(22,6),
	PYTDStly	decimal(22,6),
	PMAT1		DECIMAL(22,6),
	PMAT2		DECIMAL(22,6),
	PMAT3		DECIMAL(22,6)
GO

declare @cnt int, @sql varchar(max)
select @cnt = max(idx) from tblHospitalMthlist where Left(Mth,4) = (select left(Mth,4) from tblHospitalMthList where Idx = 1)
set @sql = '
UPDATE tempHospitalData_Taxol_CPA_KPIFrame SET
	UYTD = (' + DBO.f_assemble_sum('UM',1, @cnt) + '),
	UYTDSTLY = (' + DBO.f_assemble_sum('UM',1+12, @cnt+12) + '),
	UMAT1 = (' + DBO.f_assemble_sum('UM',1,12) + '),
	UMAT2 = (' + DBO.f_assemble_sum('UM',13,24) + '),
	UMAT3 = (' + DBO.f_assemble_sum('UM',25,36) + '),
	VYTD = (' + DBO.f_assemble_sum('VM',1, @cnt) + '),
	VYTDSTLY = (' + DBO.f_assemble_sum('VM',1+12, @cnt+12) + '),
	VMAT1 = (' + DBO.f_assemble_sum('VM',1,12) + '),
	VMAT2 = (' + DBO.f_assemble_sum('VM',13,24) + '),
	VMAT3 = (' + DBO.f_assemble_sum('VM',25,36) + '),
    PYTD = (' + DBO.f_assemble_sum('PM',1, @cnt) + '),
	PYTDSTLY = (' + DBO.f_assemble_sum('PM',1+12, @cnt+12) + '),
	PMAT1 = (' + DBO.f_assemble_sum('PM',1,12) + '),
	PMAT2 = (' + DBO.f_assemble_sum('PM',13,24) + '),
	PMAT3 = (' + DBO.f_assemble_sum('PM',25,36) + ')
' 
--print @SQL
EXEC  (@SQL)
GO

EXEC P_EXTEND_TABLE 'tempHospitalData_Taxol_CPA_KPIFrame','UR3M',1,24, 'DECIMAL(22,6)'
GO
EXEC P_EXTEND_TABLE 'tempHospitalData_Taxol_CPA_KPIFrame','VR3M',1,24, 'DECIMAL(22,6)'
GO
EXEC P_EXTEND_TABLE 'tempHospitalData_Taxol_CPA_KPIFrame','PR3M',1,24, 'DECIMAL(22,6)'
GO



DECLARE @I INT,@sql varchar(8000)
declare @st int, @ed int
set @i = 1
set @sql = 'update tempHospitalData_Taxol_CPA_KPIFrame set
'
Set @i = 1
while @i <= 24
begin
	set @sql = @sql + 'UR3M' + cast(@i as varchar) + '=' + dbo.f_assemble_sum('UM',@i,@i+2) + ','
	set @sql = @sql + 'VR3M' + cast(@i as varchar) + '=' + dbo.f_assemble_sum('VM',@i,@i+2) + ','
    set @sql = @sql + 'PR3M' + cast(@i as varchar) + '=' + dbo.f_assemble_sum('PM',@i,@i+2) + ',
'
	set @i = @i + 1
end

SET @SQL = LEFT(@SQL,LEN(@SQL)-3)
EXEC(@SQL)
Go






if object_id(N'tempHospitalData_All_For_KPI_Frame',N'U') is not null
	drop table tempHospitalData_All_For_KPI_Frame
select * into tempHospitalData_All_For_KPI_Frame from tempHospitalData_All where mkt not in ('Eliquis VTEp','ARV','ONCFCS')

insert tempHospitalData_All_For_KPI_Frame
select * from tempHospitalData_Eliquis_CPA_KPIFrame

insert tempHospitalData_All_For_KPI_Frame
select * from tempHospitalData_Baraclude_CPA_KPIFrame 


insert tempHospitalData_All_For_KPI_Frame
select * from tempHospitalData_Taxol_CPA_KPIFrame
--delete from tempHospitalData where mkt='CCB'
go











IF EXISTS (SELECT 1 FROM dbo.sysobjects where id=object_id(N'KPI_Frame_CPA_Part_Market_Product_Mapping') and type='U')
BEGIN
	DROP TABLE KPI_Frame_CPA_Part_Market_Product_Mapping
END


--Eliquis CPA MktDef change :only include three products:'Xarelto','Pradaxa','Eliquis'

IF EXISTS (SELECT 1 FROM dbo.sysobjects where id=object_id(N'tblMktDefHospital_KPIFrame_CPA_Eliquis') and type='U')
BEGIN
	DROP TABLE tblMktDefHospital_KPIFrame_CPA_Eliquis
END

select * into tblMktDefHospital_KPIFrame_CPA_Eliquis
from tblMktDefHospital_Eliquis_CPA_KPIFrame


SELECT distinct convert(varchar(100),productname) as productname,convert(varchar(20),prod) as prod,mkt,mktname
INTO KPI_Frame_CPA_Part_Market_Product_Mapping
FROM [dbo].[tblMktDefHospital]
WHERE (mkt='NIAD' and prod in ('100','200','500','000')) or (mkt='dpp4' and prod in ('300','200','100','000')) or
		(mkt='HYPFCS' and prod in ('200','100','700','800','000') ) --or (mkt='arv' and prod in ('000','100','300','400','500'))
		or (mkt='CCB' and prod in ('100','200','300','400','500','600','700','000'))
		--or  (mkt='Eliquis' and prod in ('100','300','000','600','200','400','500'))
		or (mkt='ONCFCS' and prod in ('000','100','300','600','700','800','850','860','880'))  --todo
DELETE FROM KPI_Frame_CPA_Part_Market_Product_Mapping WHERE productname='DPP-IV Market' and mkt='dpp4'

insert into KPI_Frame_CPA_Part_Market_Product_Mapping
SELECT distinct convert(varchar(100),productname) as productname,convert(varchar(20),prod) as prod,mkt,mktname
from tblMktDefHospital_KPIFrame_CPA_Eliquis

--Baraclude Market Definition
insert into KPI_Frame_CPA_Part_Market_Product_Mapping
SELECT distinct convert(varchar(100),case when productname='VIREAD' then 'Tenofovir' else productname end) as productname,convert(varchar(20),prod) as prod,mkt,mktname
from tblMktDefHospital_Baraclude_CPA_KPIFrame
where mkt='arv' and prod in ('000','100','300','400','500','800')


update KPI_Frame_CPA_Part_Market_Product_Mapping
set productname=case when productname like '%CONIEL%' then replace(productname,'CONIEL','Coniel')
	     when productname like '%LACIPIL%' then replace(productname,'LACIPIL','Lacipil')
	     when productname like '%NORVASC%' then replace(productname,'NORVASC','Norvasc')
	     when productname like '%ADALAT%' then replace(productname,'ADALAT','Adalat')
	     when productname like '%PLENDIL%' then replace(productname,'PLENDIL','Plendil')
	     when productname like '%YUAN ZHI%' then replace(productname,'YUAN ZHI','Yuan Zhi')
	     when productname like '%ZANIDIP%' then replace(productname,'ZANIDIP','Zanidip')
	     else productname
	end
where mkt='CCB'

update KPI_Frame_CPA_Part_Market_Product_Mapping
set productname=case 
	     when productname like '%XARELTO%' then replace(productname,'XARELTO','Xarelto')
		 when productname like '%PRADAXA%' then replace(productname,'PRADAXA','Pradaxa')
		 when productname like '%ELIQUIS%' then replace(productname,'ELIQUIS','Eliquis')
	     else productname
	end
where mkt='Eliquis VTEp'




if not exists(select 1 from KPI_Frame_CPA_Part_Market_Product_Mapping where mkt='ccb' and productname='Zanidip')
BEGIN
	insert into KPI_Frame_CPA_Part_Market_Product_Mapping(productname,prod,mkt,mktname)
	values('Zanidip','400','CCB','CCB Market')
END


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
from (select * from tempHospitalData_All_For_KPI_Frame where DataSource='CPA')  a 
right join KPI_Frame_CPA_Part_Market_Product_Mapping b on a.Mkt=b.Mkt and a.prod=b.prod
	--join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster) c on a.cpa_id = c.id join 
	--(select distinct [cpa code],[Glucophage Hospital Category] from dbo.[glucophage mapping] where [cpa name]<> '#N/A') d on d.[cpa name]=c.cpa_name	


GO
IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_NIAD') and type='U')
	DROP TABLE Mid_KPIFrame_CPAPart_NIAD
go

IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_NIAD_For_Prod') and type='U')
	DROP TABLE Mid_KPIFrame_CPAPart_NIAD_For_Prod
GO

IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_ONCFCS') and type='U')
	DROP TABLE Mid_KPIFrame_CPAPart_ONCFCS
go

IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_ONCFCS_For_Prod') and type='U')
	DROP TABLE Mid_KPIFrame_CPAPart_ONCFCS_For_Prod
GO

IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_HYP') and type='U')
	DROP TABLE Mid_KPIFrame_CPAPart_HYP
go

IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_HYP_For_Prod') and type='U')
	DROP TABLE Mid_KPIFrame_CPAPart_HYP_For_Prod
GO

IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_CCB') and type='U')
	DROP TABLE Mid_KPIFrame_CPAPart_CCB
go

IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_CCB_For_Prod') and type='U')
	DROP TABLE Mid_KPIFrame_CPAPart_CCB_For_Prod
GO

IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_DPP4') and type='U')
	DROP TABLE Mid_KPIFrame_CPAPart_DPP4
go
--todo
IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_ARV') and type='U')
	DROP TABLE Mid_KPIFrame_CPAPart_ARV
GO
IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_ARV_For_Prod') and type='U')
	DROP TABLE Mid_KPIFrame_CPAPart_ARV_For_Prod
GO	

IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_DPP4_NOTZero_Hosp') and type='U')
	DROP TABLE Mid_KPIFrame_CPAPart_DPP4_NOTZero_Hosp
GO

IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_Eliquis') and type='U')
	DROP TABLE Mid_KPIFrame_CPAPart_Eliquis
go

IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_KPIFrame_CPAPart_Eliquis_For_Prod') and type='U')
	DROP TABLE Mid_KPIFrame_CPAPart_Eliquis_For_Prod
GO


--NIAD Part
	declare @mktGlucophage varchar(20)
	set @mktGlucophage='NIAD'
	--计算所有的医院数=匹配医院个数+未匹配医院个数
	select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
		count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	INTO Mid_KPIFrame_CPAPart_NIAD
	from TempKPIFrame_CPAPart a 
	join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id 
	left join (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Glucophage Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktGlucophage
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的匹配医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_NIAD (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Total Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a 
	join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id 
	join (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Glucophage Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktGlucophage
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的未匹配的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_NIAD (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Non-Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
		count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a 
	join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id 
	left join (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Glucophage Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktGlucophage and c.[cpa code] is null
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算各个Category匹配上的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_NIAD (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	  --A,B,C,D tier
	select c.[Glucophage Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a 
	join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id 
	join (select distinct [cpa code],[Glucophage Hospital Category] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Glucophage Hospital Category]<>'#N/A') c 
			on c.[cpa code]=b.cpa_code
	where a.mkt=@mktGlucophage	 
	group by c.[Glucophage Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
	go

	--产品在YTD Sales>0的情况下，能匹配到的医院个数
	declare @mktGlucophage2 varchar(20)
	set @mktGlucophage2='NIAD'
	--计算所有的医院数=匹配医院个数+未匹配医院个数
	select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	INTO Mid_KPIFrame_CPAPart_NIAD_For_Prod
	from (select * from TempKPIFrame_CPAPart where VYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Glucophage Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktGlucophage2
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的匹配医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_NIAD_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Total Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where VYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id  join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Glucophage Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktGlucophage2
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的未匹配的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_NIAD_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Non-Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where VYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left  join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Glucophage Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktGlucophage2 and c.[cpa code] is null
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	----每个Category匹配上的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_NIAD_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	  --A,B,C,D tier
	select c.[Glucophage Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where VYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
		 (select distinct [cpa code],[Glucophage Hospital Category] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Glucophage Hospital Category]<>'#N/A') c 
			on c.[cpa code]=b.cpa_code
	where a.mkt=@mktGlucophage2	 
	group by c.[Glucophage Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
	go








--HYP part
	declare @mktMonopril varchar(20)
	set @mktMonopril='HYPFCS'
	--计算所有的医院数=匹配医院个数+未匹配医院个数
	select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	INTO Mid_KPIFrame_CPAPart_HYP
	from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Monopril Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktMonopril
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的匹配医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_HYP (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Total Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Monopril Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktMonopril
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的未匹配的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_HYP (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Non-Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Monopril Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktMonopril and c.[cpa code] is null
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算各个Category匹配上的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_HYP (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	  --A,B,C,D tier
	select c.[Monopril Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
		 (select distinct [cpa code],[Monopril Hospital Category] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Monopril Hospital Category]<>'#N/A') c 
			on c.[cpa code]=b.cpa_code
	where a.mkt=@mktMonopril	 
	group by c.[Monopril Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
	go

	--产品在YTD Sales>0的情况下，能匹配到的医院个数
	declare @mktMonopril2 varchar(20)
	set @mktMonopril2='HYPFCS'
	--计算所有的医院数=匹配医院个数+未匹配医院个数
	select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	INTO Mid_KPIFrame_CPAPart_HYP_For_Prod
	from (select * from TempKPIFrame_CPAPart where VYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Monopril Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktMonopril2
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的匹配医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_HYP_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Total Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where VYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id  join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Monopril Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktMonopril2
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的未匹配的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_HYP_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Non-Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where VYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left  join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Monopril Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktMonopril2 and c.[cpa code] is null
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	----每个Category匹配上的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_HYP_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	  --A,B,C,D tier
	select c.[Monopril Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where VYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
		 (select distinct [cpa code],[Monopril Hospital Category] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Monopril Hospital Category]<>'#N/A') c 
			on c.[cpa code]=b.cpa_code
	where a.mkt=@mktMonopril2	 
	group by c.[Monopril Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
	go








--CCB

	--CCB part
	--参考Monopril Hospital Category
	declare @mktConiel varchar(20)
	set @mktConiel='CCB'
	--计算所有的医院数=匹配医院个数+未匹配医院个数
	select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
		count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	INTO Mid_KPIFrame_CPAPart_CCB
	from TempKPIFrame_CPAPart a 
	join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id 
	left join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Coniel Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktConiel
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的匹配医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_CCB (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Total Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a 
	join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id 
	left join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Coniel Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktConiel
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的未匹配的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_CCB (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Non-Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a 
	join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id 
	left join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Coniel Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktConiel and c.[cpa code] is null
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算各个Category匹配上的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_CCB (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	  --A,B,C,D tier
	select c.[Coniel Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a 
	join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id 
	left join 
		 (select distinct [cpa code],[Coniel Hospital Category] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Coniel Hospital Category]<>'#N/A') c 
			on c.[cpa code]=b.cpa_code
	where a.mkt=@mktConiel	 
	group by c.[Coniel Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
	go
	--Add Zanidip to CCB Market
	declare ccb_Zanidip cursor for select distinct tier from Mid_KPIFrame_CPAPart_CCB
	declare @tier varchar(50)
	open ccb_Zanidip
	FETCH NEXT FROM  ccb_Zanidip INTO @tier
	while (@@FETCH_STATUS=0)
	BEGIN
		if not exists (select 1 from Mid_KPIFrame_CPAPart_CCB where tier=@tier and mkt='ccb' and productname='Zanidip')
		begin
			insert into Mid_KPIFrame_CPAPart_CCB(Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
			values (@tier,'CPA','CCB','400','Zanidip',0,0,0)
		end
		FETCH NEXT FROM  ccb_Zanidip INTO @tier
	END
	close ccb_Zanidip
	deallocate ccb_Zanidip

	GO



	--产品在YTD Sales>0的情况下，能匹配到的医院个数
	declare @mktConiel2 varchar(20)
	set @mktConiel2='CCB'
	--计算所有的医院数=匹配医院个数+未匹配医院个数
	select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	INTO Mid_KPIFrame_CPAPart_CCB_For_Prod
	from (select * from TempKPIFrame_CPAPart where VYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Coniel Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktConiel2
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的匹配医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_CCB_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Total Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where VYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id  join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Coniel Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktConiel2
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的未匹配的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_CCB_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Non-Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where VYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left  join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Coniel Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktConiel2 and c.[cpa code] is null
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	----每个Category匹配上的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_CCB_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	  --A,B,C,D tier
	select c.[Coniel Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where VYTD>0) a join (
			SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA'
		) b on a.cpa_id = b.id join (	
			select distinct [cpa code],[Coniel Hospital Category] 
			from BMS_CPA_Hosp_Category 
			where [cpa name]<> '#N/A' and [cpa name] is not null and 
				[cpa code] is not null and [Coniel Hospital Category]<>'#N/A') c 
			on c.[cpa code]=b.cpa_code
	where a.mkt=@mktConiel2	 
	group by c.[Coniel Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
	go
		--Add Zanidip to CCB Market
	declare ccb_Zanidip cursor for select distinct tier from Mid_KPIFrame_CPAPart_CCB
	declare @tier varchar(50)
	open ccb_Zanidip
	FETCH NEXT FROM  ccb_Zanidip INTO @tier
	while (@@FETCH_STATUS=0)
	BEGIN
		if not exists (select 1 from Mid_KPIFrame_CPAPart_CCB_For_Prod where tier=@tier and mkt='ccb' and productname='Zanidip')
		begin
			insert into Mid_KPIFrame_CPAPart_CCB(Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
			values (@tier,'CPA','CCB','400','Zanidip',0,0,0)
		end
		FETCH NEXT FROM  ccb_Zanidip INTO @tier
	END
	close ccb_Zanidip
	deallocate ccb_Zanidip

	GO
	




--Eliquis part
	declare @mktEliquis varchar(20)
	set @mktEliquis='Eliquis VTEp'
	--计算所有的医院数=匹配医院个数+未匹配医院个数
	select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
		count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	INTO Mid_KPIFrame_CPAPart_Eliquis
	from TempKPIFrame_CPAPart a 
	join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id 
	left join (
				select distinct [cpa code] 
				from BMS_CPA_Hosp_Category 
				where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null 
					and [Eliquis Hospital Category]<>'#N/A'
			) c on c.[cpa code] = b.cpa_code
	where mkt=@mktEliquis
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的匹配医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_Eliquis (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Total Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Eliquis Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktEliquis
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的未匹配的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_Eliquis (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Non-Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Eliquis Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktEliquis and c.[cpa code] is null
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算各个Category匹配上的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_Eliquis (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	  --A,B,C,D tier
	select c.[Eliquis Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
		 (select distinct [cpa code],[Eliquis Hospital Category] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Eliquis Hospital Category]<>'#N/A') c 
			on c.[cpa code]=b.cpa_code
	where a.mkt=@mktEliquis	 
	group by c.[Eliquis Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
	go

	--产品在YTD Sales>0的情况下，能匹配到的医院个数
	declare @mktEliquis2 varchar(20)
	set @mktEliquis2='Eliquis VTEp'
	--计算所有的医院数=匹配医院个数+未匹配医院个数
	select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	INTO Mid_KPIFrame_CPAPart_Eliquis_For_Prod
	from (select * from TempKPIFrame_CPAPart where VYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Eliquis Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktEliquis2
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的匹配医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_Eliquis_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Total Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where VYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id  join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Eliquis Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktEliquis2
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的未匹配的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_Eliquis_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Non-Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where VYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left  join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Eliquis Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktEliquis2 and c.[cpa code] is null
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	----每个Category匹配上的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_Eliquis_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	  --A,B,C,D tier
	select c.[Eliquis Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where VYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
		 (select distinct [cpa code],[Eliquis Hospital Category] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Eliquis Hospital Category]<>'#N/A') c 
			on c.[cpa code]=b.cpa_code
	where a.mkt=@mktEliquis2	 
	group by c.[Eliquis Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
	go











--ARV --todo

	declare @mktBaraclude varchar(20)
	set @mktBaraclude='ARV'
	--计算所有的医院数=匹配医院个数+未匹配医院个数
	select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
	INTO Mid_KPIFrame_CPAPart_ARV
	from TempKPIFrame_CPAPart a join (
		SELECT DISTINCT id,cpa_code 
		FROM tblHospitalMaster where DataSource='CPA'
	) b on a.cpa_id = b.id left join (
		select distinct [cpa code] 
		from BMS_CPA_Hosp_Category 
		where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null 
			and [Baraclude Hospital Category]<>'#N/A'
	) c on c.[cpa code]=b.cpa_code
	where mkt=@mktBaraclude
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的匹配医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_ARV (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Total Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a join (
		SELECT DISTINCT id,cpa_code 
		FROM tblHospitalMaster 
		where DataSource='CPA'
	) b on a.cpa_id = b.id join (
		select distinct [cpa code] 
		from BMS_CPA_Hosp_Category 
		where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null 
			and [Baraclude Hospital Category]<>'#N/A'
	) c on c.[cpa code]=b.cpa_code
	where mkt=@mktBaraclude
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的未匹配的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_ARV (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Non-Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a join (
		SELECT DISTINCT id,cpa_code 
		FROM tblHospitalMaster 
		where DataSource='CPA'
	) b on a.cpa_id = b.id left join (
		select distinct [cpa code] 
		from BMS_CPA_Hosp_Category 
		where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null 
			and [Baraclude Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktBaraclude and c.[cpa code] is null
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算各个Category匹配上的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_ARV (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	  --A,B,C,D tier
	select c.[Baraclude Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a join (
		SELECT DISTINCT id,cpa_code 
		FROM tblHospitalMaster 
		where DataSource='CPA'
	) b on a.cpa_id = b.id join (
		select distinct [cpa code], 
			case when [Baraclude Hospital Category] like 'bal%' then 'bal'
				 else [Baraclude Hospital Category] end as [Baraclude Hospital Category]
		from BMS_CPA_Hosp_Category 
		where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null 
			and [Baraclude Hospital Category]<>'#N/A'
	) c on c.[cpa code]=b.cpa_code
	where a.mkt=@mktBaraclude	 
	group by c.[Baraclude Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
	go

	--产品在YTD Sales>0的情况下，能匹配到的医院个数
	declare @mktBaraclude2 varchar(20)
	set @mktBaraclude2='ARV'
	--计算所有的医院数=匹配医院个数+未匹配医院个数
	select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
	INTO Mid_KPIFrame_CPAPart_ARV_For_Prod
	from (select * from TempKPIFrame_CPAPart where UYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Baraclude Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktBaraclude2
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的匹配医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_ARV_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Total Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where UYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id  join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Baraclude Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktBaraclude2
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的未匹配的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_ARV_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Non-Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where UYTD>0) a join (
		SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA'
	) b on a.cpa_id = b.id left  join (
		select distinct [cpa code] 
		from BMS_CPA_Hosp_Category 
		where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Baraclude Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktBaraclude2 and c.[cpa code] is null
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--每个Category匹配上的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_ARV_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	  --A,B,C,D tier
	select c.[Baraclude Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where UYTD>0) a join (
			SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA'
	) b on a.cpa_id = b.id join  (
		select distinct [cpa code],
			case when [Baraclude Hospital Category] like 'bal%' then 'bal'
				 else [Baraclude Hospital Category] end as [Baraclude Hospital Category] 
		from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Baraclude Hospital Category]<>'#N/A') c 
			on c.[cpa code]=b.cpa_code
	where a.mkt=@mktBaraclude2	 
	group by c.[Baraclude Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
	go





--ONCFCS

	declare @mktTaxol varchar(20)
	set @mktTaxol='ONCFCS'
	--计算所有的医院数=匹配医院个数+未匹配医院个数
	select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
	INTO Mid_KPIFrame_CPAPart_ONCFCS
	from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Taxol Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktTaxol
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的匹配医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_ONCFCS (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Total Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Taxol Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktTaxol
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的未匹配的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_ONCFCS (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Non-Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Taxol Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktTaxol and c.[cpa code] is null
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算各个Category匹配上的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_ONCFCS (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	  --A,B,C,D tier
	select c.[Taxol Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
	from TempKPIFrame_CPAPart a join (
		SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA'
	) b on a.cpa_id = b.id join (
		select distinct [cpa code],
			case when [Taxol Hospital Category]  like 'bal%' then 'Bal'
				 when [Taxol Hospital Category]  like 'key%' then 'Key'
				 else 'Others' end as [Taxol Hospital Category]
		from BMS_CPA_Hosp_Category 
		where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null 
			and [Taxol Hospital Category]<>'#N/A'
	) c on c.[cpa code]=b.cpa_code
	where a.mkt=@mktTaxol	 
	group by c.[Taxol Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
	go

	--产品在YTD Sales>0的情况下，能匹配到的医院个数
	declare @mktTaxol2 varchar(20)
	set @mktTaxol2='ONCFCS'
	--计算所有的医院数=匹配医院个数+未匹配医院个数
	select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
	INTO Mid_KPIFrame_CPAPart_ONCFCS_For_Prod
	from (select * from TempKPIFrame_CPAPart where UYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Taxol Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktTaxol2
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的匹配医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_ONCFCS_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Total Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where UYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id  join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Taxol Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktTaxol2
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算所有的未匹配的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_ONCFCS_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	select convert(varchar(20),'Non-Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where UYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left  join 
		 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Taxol Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktTaxol2 and c.[cpa code] is null
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	--每个Category匹配上的医院个数
	INSERT INTO Mid_KPIFrame_CPAPart_ONCFCS_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	  --A,B,C,D tier
	select c.[Taxol Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	count(distinct cpa_id) AS Mapped_Hosp,sum(UYTD) as VYTD,sum(UYTDStly) as VYTDStly
	from (select * from TempKPIFrame_CPAPart where UYTD>0) a join (
		SELECT DISTINCT id,cpa_code 
		FROM tblHospitalMaster where DataSource='CPA'
	) b on a.cpa_id = b.id join (
		  select distinct [cpa code],
			case when [Taxol Hospital Category]  like 'bal%' then 'Bal'
				 when [Taxol Hospital Category]  like 'key%' then 'Key'
				 else 'Others' end as [Taxol Hospital Category] 
		  from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null 
		  and [cpa code] is not null and [Taxol Hospital Category]<>'#N/A'
	) c on c.[cpa code]=b.cpa_code
	where a.mkt=@mktTaxol2	 
	group by c.[Taxol Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
	go




-- -- DPP4 part
-- declare @mktOnglyza varchar(20)
-- set @mktOnglyza='DPP4'

-- select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
-- count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
-- INTO Mid_KPIFrame_CPAPart_DPP4
-- from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
-- 	 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Onglyza  Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
-- where mkt=@mktOnglyza
-- group by a.DataSource,a.mkt,a.prod,a.ProductName

-- INSERT INTO Mid_KPIFrame_CPAPart_DPP4 (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
--  --A,B,C,D tier
-- select c.[Onglyza  Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
-- count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
-- from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
-- 	 (select distinct [cpa code],[Onglyza  Hospital Category] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Onglyza  Hospital Category]<>'#N/A') c 
-- 		on c.[cpa code]=b.cpa_code
-- where a.mkt=@mktOnglyza	 
-- group by c.[Onglyza  Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName


-- --Not zero data hospital part
-- select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
-- count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
-- INTO Mid_KPIFrame_CPAPart_DPP4_NOTZero_Hosp
-- from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
-- 	 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Onglyza  Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
-- where mkt=@mktOnglyza and VYTD>0
-- group by a.DataSource,a.mkt,a.prod,a.ProductName

-- INSERT INTO Mid_KPIFrame_CPAPart_DPP4_NOTZero_Hosp (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
--  --A,B,C,D tier
-- select c.[Onglyza  Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
-- count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
-- from TempKPIFrame_CPAPart a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
-- 	 (select distinct [cpa code],[Onglyza  Hospital Category] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Onglyza  Hospital Category]<>'#N/A') c 
-- 		on c.[cpa code]=b.cpa_code
-- where a.mkt=@mktOnglyza	 and VYTD>0
-- group by c.[Onglyza  Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
-- go

--select * from Mid_KPIFrame_CPAPart_DPP4
IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Output_KPI_Frame_CPAPart') and type='U')
BEGIN
	DROP TABLE Output_KPI_Frame_CPAPart
END
--NIAD
	select Tier,DataSource,mkt,prod,ProductName,y,x
	into Output_KPI_Frame_CPAPart
	from (
		select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp, 
			convert(decimal(20,8),case when b.VYTD is null or b.VYTD=0 then 0 else 1.0*a.VYTD/b.VYTD end) as [Market Size],
			convert(decimal(20,8),a.VYTD) as [Market Size Value]
		from (
			select * from  Mid_KPIFrame_CPAPart_NIAD where prod='000'
		  ) a join 
			 (
			select * from  Mid_KPIFrame_CPAPart_NIAD where  prod='000' and Tier ='Total'
		  ) b on a.DataSource=b.DataSource and a.mkt=b.mkt and a.prod=b.prod and a.ProductName=b.ProductName
	 ) t1 unpivot (
		Y for X in (Mapped_Hosp,[Market Size],[Market Size Value])
	)  t2

	insert into Output_KPI_Frame_CPAPart(Tier,DataSource,mkt,prod,ProductName,y,x)
	select  Tier,DataSource,mkt,prod,ProductName,y,x
	from (
		select a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
			convert(decimal(20,8),case when a.VYTDStly is null or a.VYTDStly=0 then null else 1.0*(a.VYTD-a.VYTDStly)/a.VYTDStly end) as [ProductMarketGrowth],
			convert(decimal(20,8),case when b.VYTD is null or b.VYTD =0 then 0 else 1.0*a.VYTD/b.VYTD end) as [ProductMarketShare]
		from (select * from   Mid_KPIFrame_CPAPart_NIAD) a join
			(select * from Mid_KPIFrame_CPAPart_NIAD where prod='000') b on a.Tier=b.Tier and a.DataSource=b.DataSource and a.mkt=b.mkt
	) t1 unpivot (
		Y for X in ([ProductMarketGrowth],[ProductMarketShare])
	)	t2	
	union all
	select Tier,DataSource,mkt,prod,ProductName,y,x
	from (
		select * from
		(select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp_Prod
		from Mid_KPIFrame_CPAPart_NIAD_For_Prod a where prod<>'000') b unpivot (
		Y for X in (Mapped_Hosp_Prod)) t
	) t2
	delete from Output_KPI_Frame_CPAPart where mkt='NIAD' and prod='000' and x='ProductMarketShare'


	

-- --DPP4
-- insert into Output_KPI_Frame_CPAPart(Tier,DataSource,mkt,prod,ProductName,y,x)
-- select Tier,DataSource,mkt,prod,ProductName,y,x
-- from (
-- 	select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp, 
-- 	convert(decimal(20,8),case when b.VYTD is null or b.VYTD=0 then 0 else 1.0*a.VYTD/b.VYTD end) as [Market Size]
-- 	from (
-- 		select * from  Mid_KPIFrame_CPAPart_DPP4 where prod='000'
-- 	  ) a join 
-- 		 (
-- 		select * from  Mid_KPIFrame_CPAPart_DPP4 where  prod='000' and Tier ='Total'
-- 	  ) b on a.DataSource=b.DataSource and a.mkt=b.mkt and a.prod=b.prod and a.ProductName=b.ProductName
-- ) t1 unpivot (
-- 	Y for X in (Mapped_Hosp,[Market Size])
-- )  t2
-- union all
-- select  Tier,DataSource,mkt,prod,ProductName,y,x
-- from (
-- 	select a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
-- 		convert(decimal(20,8),case when a.VYTDStly is null or a.VYTDStly=0 then null else 1.0*(a.VYTD-a.VYTDStly)/a.VYTDStly end) as [ProductMarketGrowth],
-- 		convert(decimal(20,8),case when b.VYTD is null or b.VYTD =0 then 0 else 1.0*a.VYTD/b.VYTD end) as [ProductMarketShare]
-- 	from (select * from   Mid_KPIFrame_CPAPart_DPP4 where prod <>'000') a join
-- 		(select * from Mid_KPIFrame_CPAPart_DPP4 where prod='000') b on a.Tier=b.Tier and a.DataSource=b.DataSource and a.mkt=b.mkt
-- ) t1 unpivot (
-- 	Y for X in ([ProductMarketGrowth],[ProductMarketShare])
-- )	t2	

--  --Hosp. # (Onglyza sales>0): Specified Series to DPP4
-- insert into Output_KPI_Frame_CPAPart(Tier,DataSource,mkt,prod,ProductName,y,x)
-- select Tier,DataSource,mkt,prod,ProductName,y,x
-- from (
-- 	select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp_NotZeroSales
-- 	from (
-- 		select * from  Mid_KPIFrame_CPAPart_DPP4_NOTZero_Hosp where prod='100'
-- 	  ) a )t1 unpivot (
-- 	Y for X in (Mapped_Hosp_NotZeroSales)
-- )  t2

--HYP	
	insert into Output_KPI_Frame_CPAPart(Tier,DataSource,mkt,prod,ProductName,y,x)
	select Tier,DataSource,mkt,prod,ProductName,y,x
	from (
		select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp, 
		convert(decimal(20,8),case when b.VYTD is null or b.VYTD=0 then 0 else 1.0*a.VYTD/b.VYTD end) as [Market Size],
		convert(decimal(20,8),a.VYTD) as [Market Size Value]
		from (
			select * from  Mid_KPIFrame_CPAPart_HYP where prod='000'
		  ) a join 
			 (
			select * from  Mid_KPIFrame_CPAPart_HYP where  prod='000' and Tier ='Total'
		  ) b on a.DataSource=b.DataSource and a.mkt=b.mkt and a.prod=b.prod and a.ProductName=b.ProductName
	 ) t1 unpivot (
		Y for X in (Mapped_Hosp,[Market Size],[Market Size Value])
	)  t2
	union all
	select  Tier,DataSource,mkt,prod,ProductName,y,x
	from (
		select a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
			convert(decimal(20,8),case when a.VYTDStly is null or a.VYTDStly=0 then null else 1.0*(a.VYTD-a.VYTDStly)/a.VYTDStly end) as [ProductMarketGrowth],
			convert(decimal(20,8),case when b.VYTD is null or b.VYTD =0 then 0 else 1.0*a.VYTD/b.VYTD end) as [ProductMarketShare]
		from (select * from   Mid_KPIFrame_CPAPart_HYP ) a join
			(select * from Mid_KPIFrame_CPAPart_HYP where prod='000') b on a.Tier=b.Tier and a.DataSource=b.DataSource and a.mkt=b.mkt
	) t1 unpivot (
		Y for X in ([ProductMarketGrowth],[ProductMarketShare])
	)	t2
	union all	
		select Tier,DataSource,mkt,prod,ProductName,y,x
	from (
		select * from
		(select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp_Prod
		from Mid_KPIFrame_CPAPart_HYP_For_Prod a where prod<>'000') b unpivot (
		Y for X in (Mapped_Hosp_Prod)) t
	) t2
	delete from Output_KPI_Frame_CPAPart where mkt='HYPFCS' and prod='000' and x='ProductMarketShare'






--CCB	
	insert into Output_KPI_Frame_CPAPart(Tier,DataSource,mkt,prod,ProductName,y,x)
	select Tier,DataSource,mkt,prod,ProductName,y,x
	from (
		select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp, 
			convert(decimal(20,8),case when b.VYTD is null or b.VYTD=0 then 0 else 1.0*a.VYTD/b.VYTD end) as [Market Size],
			convert(decimal(20,8),a.VYTD) as [Market Size Value]
		from (
			select * from  Mid_KPIFrame_CPAPart_CCB where prod='000'
		  ) a 
		join 
			 (
			select * from  Mid_KPIFrame_CPAPart_CCB where  prod='000' and Tier ='Total'
		  ) b on a.DataSource=b.DataSource and a.mkt=b.mkt and a.prod=b.prod and a.ProductName=b.ProductName
	 ) t1 unpivot (
		Y for X in (Mapped_Hosp,[Market Size],[Market Size Value])
	)  t2
	union all
	select  Tier,DataSource,mkt,prod,ProductName,y,x
	from (
		select a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
			convert(decimal(20,8),case when a.VYTDStly is null or a.VYTDStly=0 then 10000 else 1.0*(a.VYTD-a.VYTDStly)/a.VYTDStly end) as [ProductMarketGrowth],
			convert(decimal(20,8),case when b.VYTD is null or b.VYTD =0 then 0 else 1.0*a.VYTD/b.VYTD end) as [ProductMarketShare]
		from (select * from   Mid_KPIFrame_CPAPart_CCB ) a join
			(select * from Mid_KPIFrame_CPAPart_CCB where prod='000') b on a.Tier=b.Tier and a.DataSource=b.DataSource and a.mkt=b.mkt
	) t1 unpivot (
		Y for X in ([ProductMarketGrowth],[ProductMarketShare])
	)	t2	
	union all	
		select Tier,DataSource,mkt,prod,ProductName,y,x
	from (
		select * from
		(select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp_Prod
		from Mid_KPIFrame_CPAPart_CCB_For_Prod a where prod<>'000') b unpivot (
		Y for X in (Mapped_Hosp_Prod)) t
	) t2

	delete from Output_KPI_Frame_CPAPart where mkt='CCB' and prod='000' and x='ProductMarketShare'
	--delete from Output_KPI_Frame_CPAPart where mkt='CCB' and ProductName in ('Lacipil','Yuan Zhi')



--Eliquis	
	insert into Output_KPI_Frame_CPAPart(Tier,DataSource,mkt,prod,ProductName,y,x)
	select Tier,DataSource,mkt,prod,ProductName,y,x
	from (
		select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp, 
		convert(decimal(20,8),case when b.VYTD is null or b.VYTD=0 then 0 else 1.0*a.VYTD/b.VYTD end) as [Market Size],
		convert(decimal(20,8),a.VYTD) as [Market Size Value]
		from (
			select * from  Mid_KPIFrame_CPAPart_Eliquis where prod='000'
		  ) a join 
			 (
			select * from  Mid_KPIFrame_CPAPart_Eliquis where  prod='000' and Tier ='Total'
		  ) b on a.DataSource=b.DataSource and a.mkt=b.mkt and a.prod=b.prod and a.ProductName=b.ProductName
	 ) t1 unpivot (
		Y for X in (Mapped_Hosp,[Market Size],[Market Size Value])
	)  t2
	union all
	select  Tier,DataSource,mkt,prod,ProductName,y,x
	from (
		select a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
			convert(decimal(20,8),case when a.VYTDStly is null or a.VYTDStly=0 then 10000 else 1.0*(a.VYTD-a.VYTDStly)/a.VYTDStly end) as [ProductMarketGrowth],
			convert(decimal(20,8),case when b.VYTD is null or b.VYTD =0 then 0 else 1.0*a.VYTD/b.VYTD end) as [ProductMarketShare]
		from (select * from   Mid_KPIFrame_CPAPart_Eliquis ) a join
			(select * from Mid_KPIFrame_CPAPart_Eliquis where prod='000') b on a.Tier=b.Tier and a.DataSource=b.DataSource and a.mkt=b.mkt
	) t1 unpivot (
		Y for X in ([ProductMarketGrowth],[ProductMarketShare])
	)	t2	
	union all	
		select Tier,DataSource,mkt,prod,ProductName,y,x
	from (
		select * from
		(select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp_Prod
		from Mid_KPIFrame_CPAPart_Eliquis_For_Prod a where prod<>'000') b unpivot (
		Y for X in (Mapped_Hosp_Prod)) t
	) t2
	delete  from Output_KPI_Frame_CPAPart where mkt='Eliquis VTEp' and productname in ('CLEXANE','ARIXTRA','FRAXIPARINE','ENOXAPARIN SODIUM')
	delete from Output_KPI_Frame_CPAPart where mkt='Eliquis VTEp' and prod='000' and x='ProductMarketShare'



--ARV
	insert into Output_KPI_Frame_CPAPart(Tier,DataSource,mkt,prod,ProductName,y,x)
	select Tier,DataSource,mkt,prod,ProductName,y,x
	from (
		select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp, 
		convert(decimal(20,8),case when b.VYTD is null or b.VYTD=0 then 0 else 1.0*a.VYTD/b.VYTD end) as [Market Size],
		convert(decimal(20,8),a.VYTD) as [Market Size Volume]
		from (
			select * from  Mid_KPIFrame_CPAPart_ARV where prod='000'
		  ) a join 
			 (
			select * from  Mid_KPIFrame_CPAPart_ARV where  prod='000' and Tier ='Total'
		  ) b on a.DataSource=b.DataSource and a.mkt=b.mkt and a.prod=b.prod and a.ProductName=b.ProductName
	 ) t1 unpivot (
		Y for X in (Mapped_Hosp,[Market Size],[Market Size Volume])
	)  t2
	union all
	select  Tier,DataSource,mkt,prod,ProductName,y,x
	from (
		select a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
			convert(decimal(20,8),case when a.VYTDStly is null or a.VYTDStly=0 then null else 1.0*(a.VYTD-a.VYTDStly)/a.VYTDStly end) as [ProductMarketGrowth],
			convert(decimal(20,8),case when b.VYTD is null or b.VYTD =0 then 0 else 1.0*a.VYTD/b.VYTD end) as [ProductMarketShare]
		from (select * from   Mid_KPIFrame_CPAPart_ARV ) a join
			(select * from Mid_KPIFrame_CPAPart_ARV where prod='000') b on a.Tier=b.Tier and a.DataSource=b.DataSource and a.mkt=b.mkt
	) t1 unpivot (
		Y for X in ([ProductMarketGrowth],[ProductMarketShare])
	)	t2	
	union all
	select Tier,DataSource,mkt,prod,ProductName,y,x
	from (
		select * from
		(select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp_Prod
		from Mid_KPIFrame_CPAPart_ARV_For_Prod a where prod<>'000') b unpivot (
		Y for X in (Mapped_Hosp_Prod)) t
	) t2
	delete from Output_KPI_Frame_CPAPart where mkt='arv' and prod='000' and x='ProductMarketShare'




--ONCFCS
	insert into Output_KPI_Frame_CPAPart(Tier,DataSource,mkt,prod,ProductName,y,x)
	select Tier,DataSource,mkt,prod,ProductName,y,x
	from (
		select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp, 
		convert(decimal(20,8),case when b.VYTD is null or b.VYTD=0 then 0 else 1.0*a.VYTD/b.VYTD end) as [Market Size],
		convert(decimal(20,8),a.VYTD) as [Market Size Volume]
		from (
			select * from  Mid_KPIFrame_CPAPart_ONCFCS where prod='000'
		  ) a join 
			 (
			select * from  Mid_KPIFrame_CPAPart_ONCFCS where  prod='000' and Tier ='Total'
		  ) b on a.DataSource=b.DataSource and a.mkt=b.mkt and a.prod=b.prod and a.ProductName=b.ProductName
	 ) t1 unpivot (
		Y for X in (Mapped_Hosp,[Market Size],[Market Size Volume])
	)  t2
	union all
	select  Tier,DataSource,mkt,prod,ProductName,y,x
	from (
		select a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
			convert(decimal(20,8),case when a.VYTDStly is null or a.VYTDStly=0 then null else 1.0*(a.VYTD-a.VYTDStly)/a.VYTDStly end) as [ProductMarketGrowth],
			convert(decimal(20,8),case when b.VYTD is null or b.VYTD =0 then 0 else 1.0*a.VYTD/b.VYTD end) as [ProductMarketShare]
		from (select * from   Mid_KPIFrame_CPAPart_ONCFCS ) a join
			(select * from Mid_KPIFrame_CPAPart_ONCFCS where prod='000') b on a.Tier=b.Tier and a.DataSource=b.DataSource and a.mkt=b.mkt
	) t1 unpivot (
		Y for X in ([ProductMarketGrowth],[ProductMarketShare])
	)	t2	
	union all
	select Tier,DataSource,mkt,prod,ProductName,y,x
	from (
		select * from
		(select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp_Prod
		from Mid_KPIFrame_CPAPart_ONCFCS_For_Prod a where prod<>'000') b unpivot (
		Y for X in (Mapped_Hosp_Prod)) t
	) t2
	delete from Output_KPI_Frame_CPAPart where mkt='ONCFCS' and prod='000' and x='ProductMarketShare'
	delete  from Output_KPI_Frame_CPAPart where mkt='ONCFCS' and productname in ('Ai Su','Ze Fei','Li Pu Su','Abraxane','Anzatax','Taxol Others')--Total Paclitaxel
	
GO

IF EXISTS(select 1 from dbo.sysobjects where id=object_id(N'KPI_Frame_AnalyzerMarket_HospitalPerformance') and type='U')
BEGIN
	DROP TABLE KPI_Frame_AnalyzerMarket_HospitalPerformance
END
declare @CPAMonth varchar(50)
select @CPAMonth=left(A.MonthEN,3) 
from BMSChinaCIA_IMS.dbo.tblMonthlist a 
join tblDSDates b on a.Date=b.Value1 
where b.item='CPA'
--select @CPAMonth=Value1 from tblDSDates where Item='CPA'


SELECT 'YTD' AS TimeFrame, 'USD' as MoneyType, 'N' as Molecule,'N' as class,mkt,
	 case when mkt='NIAD'     then 'NIAD Market'
		  when mkt='ARV'      then 'ARV Market'
		  when mkt='HYPFCS'   then 'HYP Market'
		  when mkt='CCB'      then 'CCB Market' 
		  when mkt='Eliquis VTEp'  then 'Eliquis Market' 
		  when mkt='ONCFCS' then 'Oncology Market' 
		  end as MktName,
	 case when mkt='NIAD'     then 'Glucophage'
		  when mkt='ARV'      then 'Baraclude'
		  when mkt='HYPFCS'   then 'Monopril'
		  when mkt='CCB'      then 'Coniel'
		  when mkt='Eliquis VTEp'  then 'Eliquis'
		  when mkt='ONCFCS'  then 'Taxol'
		  end as Market,
	 prod,
	case when Tier='2-A' then 'A'
		 when Tier='3-B' then 'B'
		 when Tier='4-C' then 'C'
		 when Tier='6-D' then 'D' 
		 when Tier='1-S' then 'S'
		 else Tier end as Series,
	convert(varchar(50),null) as DataType,convert(varchar(20),null)	as Category,
	case when mkt in('CCB','Eliquis VTEp') and y=10000 then null else Y end as Y,
	case 	when x='Market Size' and mkt='Eliquis VTEp' then 'VTEp Market Contribution'
		 	when x='Market Size' then mkt+' Market Contribution'
			when x='Mapped_Hosp' then '# Hospital CPA matched with BMS'
			when x='ProductMarketShare' then ProductName+' Share ('+(
												case when mkt='NIAD' then 'YTD'--'MTH' 
														when mkt='HYPFCS' then 'YTD'
														when mkt='DPP4' then 'YTD'-- 'MQT' 
														when mkt='ARV' then 'YTD'
														when mkt='CCB' then 'YTD'
														when mkt='Eliquis VTEp' then 'YTD'
														when mkt='ONCFCS' then 'YTD'
														end) +@CPAMonth +')'
			when x='ProductMarketGrowth' then case when ProductName = 'ARV Market' then 'Total'
													when ProductName = 'Monopril Market' then 'Total'
													when ProductName = 'NIAD Market' then 'Total'
													when ProductName = 'CCB Market' then 'Total'
													when ProductName = 'Eliquis Market' then 'Total'
													when ProductName = 'Taxol Market' then 'Total'
													else productname end +' GR(Y2Y)'			
			when x='Market Size Volume' then mkt+' Market Size (YTD '+@CPAMonth+' volume)'
			when x='Market Size Value' and mkt='Eliquis VTEp' then 'VTEp Market Size (YTD '+@CPAMonth+' Value)'
			when x='Market Size Value' then mkt+' Market Size (YTD '+@CPAMonth+' Value)'
			when x='Mapped_Hosp_Prod' then ProductName+' listed. #'
	end  as X,
	case when Tier like 'Key%' then 1
		 when Tier like 'Bal%' then 2
		 when Tier like 'Top%' then 2
		 when Tier like 'Region%' then 3
		 when Tier like 'High productivity%' then 4
		 when Tier like 'other%' then 5
		 when Tier='A' then 2
		 when Tier='B' then 3
		 when Tier='C' then 4
		 when Tier='D' then 5 
		 when Tier='2-A' then 2
		 when Tier='3-B' then 3
		 when Tier='4-C' then 4
		 when Tier='6-D' then 5 
		 when Tier IN ('1-S','S') then 1
		 when Tier='Total' then 8
		 when Tier='Total Targeted' then 6
		 when Tier='Non-Targeted ' then 7
	end as Series_Idx,
	case when x='Mapped_Hosp' then 1
			when x='Mapped_Hosp_Prod' and productname in ('Baraclude','Glucophage','Lotensin','Coniel','Xarelto','Taxol') then 2
			when x='Mapped_Hosp_Prod' and productname in ('Heptodin','Glucobay','Monopril','Zanidip','Pradaxa','Taxotere') then 3
			when x='Mapped_Hosp_Prod' and productname in ('Run Zhong','Amaryl','Tritace','Norvasc','Eliquis','Gemzar') then 4
			when x='Mapped_Hosp_Prod' and productname in ('Sebivo','Acertil','Adalat') then 5
			when x='Mapped_Hosp_Prod' and productname in ('Plendil','Tenofovir') then 6
			
			when x='ProductMarketGrowth' and productname in ('ARV Market','NIAD Market','Monopril Market','CCB Market','Eliquis Market','Taxol Market') then 7
			when x='ProductMarketGrowth' and productname in ('Baraclude','Glucophage','Lotensin','Coniel','Xarelto','Taxol') then 8
			when x='ProductMarketGrowth' and productname in ('Heptodin','Glucobay','Monopril','Zanidip','Pradaxa','Taxotere') then 9
			when x='ProductMarketGrowth' and productname in ('Run Zhong','Amaryl','Tritace','Norvasc','Eliquis','Gemzar') then 10
			when x='ProductMarketGrowth' and productname in ('Sebivo','Acertil','Adalat') then 11
			when x='ProductMarketGrowth' and productname in ('Plendil','Tenofovir') then 12
			
			when x='ProductMarketShare' and productname in ('Baraclude','Glucophage','Lotensin','Coniel','Xarelto','Taxol') then 13
			when x='ProductMarketShare' and productname in ('Heptodin','Glucobay','Monopril','Zanidip','Pradaxa','Taxotere') then 14
			when x='ProductMarketShare' and productname in ('Run Zhong','Amaryl','Tritace','Norvasc','Eliquis','Gemzar') then 15
			when x='ProductMarketShare' and productname in ('Sebivo','Acertil','Adalat') then 16
			when x='ProductMarketShare' and productname in ('Plendil','Tenofovir') then 17
			
			when x='Market Size Volume' then 18
			when x='Market Size Value' then 18
			when x='Market Size' then 19						
	end as X_Idx	
into KPI_Frame_AnalyzerMarket_HospitalPerformance	
from Output_KPI_Frame_CPAPart 
where mkt in ('ARV','NIAD','HYPFCS','Eliquis VTEp','ONCFCS') or (mkt='CCB' and ProductName not in ('Lacipil','Yuan Zhi'))

insert into KPI_Frame_AnalyzerMarket_HospitalPerformance (TimeFrame,MoneyType,Molecule,class,mkt,MktName,Market,prod,
		Series,DataType,Category,Y,X,Series_Idx,X_Idx)
SELECT case when mkt='NIAD' then 'YTD'--'MTH' 
		 when mkt in ('HYPFCS','ARV','CCB') then 'YTD'
		 when mkt='DPP4' then 'YTD'--'MQT'
	end AS TimeFrame, 'USD' as MoneyType, 'N' as Molecule,'N' as class,mkt,
	case when mkt='NIAD' then 'NIAD Market' 
		 when mkt='HYPFCS' then 'HYP Market'
		 when mkt='DPP4' then 'DPP4 Market'
		 when mkt='ARV' then 'ARV Market'
		 when mkt='CCB' then 'CCB Market'
	end as MktName,
	case when mkt='NIAD' then 'Glucophage' 
		 when mkt='HYPFCS' then 'Monopril'
		 when mkt='DPP4' then 'Onglyza'
		 when mkt='ARV' then 'Baraclude'
		 when mkt='CCB' then 'Coniel'
	end as Market,prod,
	case when Tier='2-A' then 'A'
		 when Tier='3-B' then 'B'
		 when Tier='4-C' then 'C'
		 when Tier='6-D' then 'D' 
		 when Tier='1-S' then 'S'
		 else Tier end as Series,
	convert(varchar(50),null) as DataType,convert(varchar(20),null)	as Category,
	case when mkt in('CCB','Eliquis VTEp') and y=10000 then null else Y end as Y,
	case when x='Market Size' then mkt+' Market Size'
			when x='Mapped_Hosp' then '# Hospital CPA matched with BMS'
			when x='ProductMarketShare' then ProductName+' Share ('+(
												case when mkt='NIAD' then 'YTD'--'MTH' 
													 when mkt in ('HYPFCS','CCB') then 'YTD'
													 when mkt='DPP4' then 'YTD'-- 'MQT' 
													 when mkt='ARV' then 'YTD'
													 end) +@CPAMonth +')'
			when x='ProductMarketGrowth' then ProductName+' GR(Y2Y)'
			when x='Mapped_Hosp_NotZeroSales' and mkt='DPP4' then 'Hosp. # (Onglyza sales>0)'
	end  as X,
	case when Tier='A' then 2
		 when Tier='B' then 3
		 when Tier='C' then 4
		 when Tier='D' then 5 
		 when Tier='2-A' then 2
		 when Tier='3-B' then 3
		 when Tier='4-C' then 4
		 when Tier='6-D' then 5 
		 when Tier in ('1-S','S') then 1
		 when Tier='Total' then 6
		 when Tier='Region300' then 2
		 when Tier like 'top%' then 1
		 when Tier='High productivity' then 3
		 when Tier='Others' then 4
	end as Series_Idx,
	case when x='Market Size' then 3
			when x='Mapped_Hosp' then 1
			when x='ProductMarketShare' and ProductName in ('Glucophage','Onglyza', 'Lotensin','Baraclude','Coniel') then 4 
			when x='ProductMarketGrowth' and ProductName in ('Glucophage','Onglyza', 'Lotensin','Baraclude','Coniel') then 5
			when x='ProductMarketShare' and ProductName in ('Glucobay','Galvus', 'Monopril','Heptodin','Lacipil') then 6 
			when x='ProductMarketGrowth' and ProductName in ('Glucobay','Galvus', 'Monopril','Heptodin','Lacipil') then 7
			when x='ProductMarketShare' and ProductName in ('Amaryl','Januvia', 'Tritace','Run Zhong','Yuan Zhi') then 8
			when x='ProductMarketGrowth' and ProductName in ('Amaryl','Januvia', 'Tritace','Run Zhong','Yuan Zhi') then 9
			when x='ProductMarketShare' and ProductName in ('Acertil','Sebivo','Janumet','Zanidip') then 10
			when x='ProductMarketGrowth' and ProductName in ('Acertil','Sebivo','Janumet','Zanidip') then 11
			when x='ProductMarketShare' and ProductName in ('Trajenta','NORVASC') then 12
			when x='ProductMarketGrowth' and ProductName in ('Trajenta','NORVASC') then 13			
			when x='ProductMarketShare' and ProductName in ('ADALAT') then 14
			when x='ProductMarketGrowth' and ProductName in ('ADALAT') then 15
			when x='ProductMarketShare' and ProductName in ('PLENDIL') then 16
			when x='ProductMarketGrowth' and ProductName in ('PLENDIL') then 17
			when x='Mapped_Hosp_NotZeroSales' and mkt='DPP4' then 2
	end as X_Idx		
from Output_KPI_Frame_CPAPart 
where mkt not in ('ARV','NIAD','HYPFCS','CCB','Eliquis VTEp','ONCFCS')



--update KPI_Frame_AnalyzerMarket_HospitalPerformance
--set x=case when x like '%CONIEL%' then replace(x,'CONIEL','Coniel')
--	     when x like '%LACIPIL%' then replace(x,'LACIPIL','Lacipil')
--	     when x like '%NORVASC%' then replace(x,'NORVASC','Norvasc')
--	     when x like '%ADALAT%' then replace(x,'ADALAT','Adalat')
--	     when x like '%PLENDIL%' then replace(x,'PLENDIL','Plendil')
--	     when x like '%YUAN ZHI%' then replace(x,'YUAN ZHI','Yuan Zhi')
--	     else x
--	end

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
	select case when 科室名称=N'普通外科'then 'General surgery'
				when 科室名称=N'骨科' then 'Orthopedics'
				when 科室名称=N'血管科' then 'Vascular department'
				when 科室名称=N'高干保健' then 'Senior Cadres of Health'
				when 科室名称=N'心内科' then 'Cardiology'
				else 'All other' end as Department_EN,
				DATE,
				处方张数 as rx,
				金额 as amount,
				商品名称 as ProductName		    
	from [TempOutput].[dbo].[RX_Raw_data_201412]
	where [商品名称]=N'拜瑞妥'
	--union
	--select case when 科室名称=N'普通外科'then 'General surgery'
	--			when 科室名称=N'骨科' then 'Orthopedics'
	--			when 科室名称=N'血管科' then 'Vascular department'
	--			when 科室名称=N'高干保健' then 'Senior Cadres of Health'
	--			when 科室名称=N'心内科' then 'Cardiology'
	--			else 'All other' end as Department_EN,
	--			DATE,
	--			处方张数 as rx,
	--			金额 as amount,
	--			商品名称 as ProductName		    
	--from [TempOutput].[dbo].[RX_Raw_data_201403]
	--where [商品名称]=N'拜瑞妥' and date in ('10Q1','10Q2','10Q3','10Q4')
) a  join 
(
	select distinct 商品名称 as ProductName,Date,  sum(处方张数) as rx_All,sum(金额) as amount_All
	from [TempOutput].[dbo].[RX_Raw_data_201412]
	where [商品名称]=N'拜瑞妥'
	group by 商品名称,Date
	--union
	--select distinct 商品名称 as ProductName,Date,  sum(处方张数) as rx_All,sum(金额) as amount_All
	--from [TempOutput].[dbo].[RX_Raw_data_201403]
	--where [商品名称]=N'拜瑞妥' and date in ('10Q1','10Q2','10Q3','10Q4')
	--group by 商品名称,Date
) b on a.ProductName=b.ProductName and a.Date=b.Date
group by a.Department_EN,a.ProductName,a.date,b.rx_All,b.amount_All
order by date

insert INTO #TempKPI_FRAME_BusinessSourceOfXarelto
select a.Department_EN,a.date,a.ProductName,sum(a.rx) as rx,sum(a.amount) as amount,b.rx_All,b.amount_All

from 
(
	select case when 科室名称=N'普通外科'then 'General surgery'
				when 科室名称=N'骨科' then 'Orthopedics'
				when 科室名称=N'血管科' then 'Vascular department'
				when 科室名称=N'高干保健' then 'Senior Cadres of Health'
				when 科室名称=N'心内科' then 'Cardiology'
				else 'All other' end as Department_EN,
				DATE,
				处方张数 as rx,
				金额 as amount,
				商品名称 as ProductName		    
	from [TempOutput].[dbo].[RX_Raw_data_2015Q3]
	where [商品名称]=N'拜瑞妥'
	--union
	--select case when 科室名称=N'普通外科'then 'General surgery'
	--			when 科室名称=N'骨科' then 'Orthopedics'
	--			when 科室名称=N'血管科' then 'Vascular department'
	--			when 科室名称=N'高干保健' then 'Senior Cadres of Health'
	--			when 科室名称=N'心内科' then 'Cardiology'
	--			else 'All other' end as Department_EN,
	--			DATE,
	--			处方张数 as rx,
	--			金额 as amount,
	--			商品名称 as ProductName		    
	--from [TempOutput].[dbo].[RX_Raw_data_201403]
	--where [商品名称]=N'拜瑞妥' and date in ('10Q1','10Q2','10Q3','10Q4')
) a  join 
(
	select distinct 商品名称 as ProductName,Date,  sum(处方张数) as rx_All,sum(金额) as amount_All
	from [TempOutput].[dbo].[RX_Raw_data_2015Q3]
	where [商品名称]=N'拜瑞妥'
	group by 商品名称,Date
	--union
	--select distinct 商品名称 as ProductName,Date,  sum(处方张数) as rx_All,sum(金额) as amount_All
	--from [TempOutput].[dbo].[RX_Raw_data_201403]
	--where [商品名称]=N'拜瑞妥' and date in ('10Q1','10Q2','10Q3','10Q4')
	--group by 商品名称,Date
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


select  b.英文名称 as Mole_EN,a.Date,sum(a.金额) as amount 
into #TempRx
from (select area,date,医院级别,科室名称,处方来源,报销,药品编码,商品名称,规格,给药途径,处方张数,取药数量,单价,金额 
	  from [TempOutput].[dbo].[RX_Raw_data_201412]
	  --union
	  --select * from [TempOutput].[dbo].[RX_Raw_data_201403] where date in ('10Q1','10Q2','10Q3','10Q4')
	)
a join BMSChinaOtherDB.dbo.inRx_MoleculeRef  b on a.药品编码=b.药品编码
where a.科室名称=N'骨科' and b.英文名称 in ('Rivaroxaban','Nadroparin Calcium','Enoxaparin sodium','Dalteparin sodium',
		'Fondaparinux','Heparin sodium','Warfarin sodium','Extract cepae/heparin sodium/allantoin','Heparin calcium'
	)
group by 	b.英文名称,a.Date

insert into #TempRx
select  b.英文名称 as Mole_EN,a.Date,sum(a.金额) as amount 

from (select area,date,医院级别,科室名称,处方来源,报销,药品编码,商品名称,规格,给药途径,处方张数,取药数量,金额 
	  from [TempOutput].[dbo].[RX_Raw_data_2015Q3] 
	  --union
	  --select * from [TempOutput].[dbo].[RX_Raw_data_201403] where date in ('10Q1','10Q2','10Q3','10Q4')
	)
a join BMSChinaOtherDB.dbo.inRx_MoleculeRef  b on a.药品编码=b.药品编码
where a.科室名称=N'骨科' and b.英文名称 in ('Rivaroxaban','Nadroparin Calcium','Enoxaparin sodium','Dalteparin sodium',
		'Fondaparinux','Heparin sodium','Warfarin sodium','Extract cepae/heparin sodium/allantoin','Heparin calcium'
	)
group by 	b.英文名称,a.Date

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

print '--------------------------------------------------
--		BAL Hospital Starting
--------------------------------------------------'
--Middle Table
IF OBJECT_ID(N'TempHospitalData_For_BAL_Hospital',N'U') IS NOT NULL
	DROP TABLE TempHospitalData_For_BAL_Hospital	

select  a.*,c.DataSource,c.prod,c.Cpa_id,c.Tier,c.UYTD,c.UYTDStly,c.VYTD,c.VYTDStly
into TempHospitalData_For_BAL_Hospital
from (
	select convert(varchar(20),'ARV') as Market, [BMS Code] as Hospital_Code,
		[BMS Name (1)] as Hospital_Name,[cpa code] as cpa_code,[cpa name] as cpa_name,[Baraclude Hospital Category] as Hospital_Category
	from dbo.BMS_CPA_Hosp_Category
	union all
	select convert(varchar(20),'ONCFCS') as Market, [BMS Code] as Hospital_Code,
		[BMS Name (1)] as Hospital_Name,[cpa code] as cpa_code,[cpa name] as cpa_name,[Taxol Hospital Category] as Hospital_Category
	from dbo.BMS_CPA_Hosp_Category
	union all
	select convert(varchar(20),'CML') as Market, [BMS Code] as Hospital_Code,
		[BMS Name (1)] as Hospital_Name,[cpa code] as cpa_code,[cpa name] as cpa_name,[Sprycel Hospital Category] as Hospital_Category
	from dbo.BMS_CPA_Hosp_Category
) a 
left join tblHospitalMaster b on a.[cpa_code]=b.cpa_code 
left join tempHospitalData_All_For_KPI_Frame c on a.Market=c.Mkt and b.id=c.cpa_id
where Hospital_Category <>'#N/A'
Go
if object_id(N'Temp_MktDef_For_Bal_Hospital',N'U') is not null
	drop table Temp_MktDef_For_Bal_Hospital
GO	
select * 
into Temp_MktDef_For_Bal_Hospital
from (	
	select distinct Mkt,Prod,ProductName,
		case when productName='Baraclude' then 1
			 when productName='Hepsera' then 2
			 when productName='Heptodin' then 3
			 when productName='Run Zhong' then 4
			 when productName='Sebivo' then 5
			 when productName='VIREAD' then 6 end as Prod_Idx
	from tblMktDefHospital_Baraclude_CPA_KPIFrame
	where prod in ('100','200','300','400','500','800')
	union all
	select distinct Mkt,Prod,ProductName,
		case when productName= 'Taxol' then 1
			 when productName= 'Abraxane' then 2
			 when productName= 'Anzatax' then 3
			 when productName= 'Li Pu Su' then 4
			 when productName= 'Taxotere' then 5
			 when productName= 'Ai Su' then 6 end as Prod_Idx
	from tblMktDefHospital where mkt='ONCFCS'and prod in ('100','200','860','700','800','300')
	union all
	select distinct Mkt,Prod,ProductName,
		case when productName= 'Sprycel' then 1
			 when productName= 'Gleevec' then 2
			 when productName= 'Tasigna' then 3 end as Prod_Idx
	from tblMktDefHospital where mkt='cml'and prod in ('100','200','300')
) a 
GO
if object_id(N'tempdb..#Temp_Data_For_Bal_Hospital',N'U') is not null
	drop table #Temp_Data_For_Bal_Hospital

select a.*,b.*,isnull(c.Share,'') as Market_Share
into #Temp_Data_For_Bal_Hospital
from Temp_MktDef_For_Bal_Hospital a 
join (
	select distinct market,Hospital_Code,Hospital_Name,convert(nvarchar(255),isnull(Cpa_Code,'#N/A')) AS Cpa_Code,isnull(CPA_Name,'#N/A') as CPA_Name
	from TempHospitalData_For_BAL_Hospital 
	where Hospital_Category like 'bal%'
) b on a.mkt=b.market
left join (
	select b.*,
		case when b.Market='CML' then 
				(case when a.VYTD >0  then convert(varchar(30),1.0*b.VYTD/a.VYTD) else '' end)
			else	
				(case when a.UYTD >0  then convert(varchar(30),1.0*b.UYTD/a.UYTD,2) else '' end)
		end   as Share
	from TempHospitalData_For_BAL_Hospital a join TempHospitalData_For_BAL_Hospital b 
		on a.Market=b.market and a.hospital_code=b.hospital_code and a.Hospital_category=b.hospital_category and a.datasource=b.datasource
			and a.prod='000' and b.prod<>'000'		
	where b.Hospital_Category like 'bal%'	
) c on b.Market=c.Market and a.Prod=c.Prod and b.Hospital_code=c.Hospital_Code	

truncate table dbo.KPI_Frame_MarketAnalyzer_BAL_Hospials

insert into dbo.KPI_Frame_MarketAnalyzer_BAL_Hospials(TimeFrame,MoneyType,Molecule,Class,Mkt,
	MktName,market,prod,Series,DataType,Category,Y,X,Series_Idx,X_Idx)
select 'YTD','UN','','',Mkt,Mkt,
	case when mkt='arv' then 'Baraclude' 
		 when mkt='ONCFCS' then 'Taxol' 
		 when mkt='cml' then 'Sprycel' end as Market,
	'' as Prod,Hospital_Code as Series,null,null,Y,
	case when x='Hospital_Name' then 'Hospital Name'
		 when x='cpa_code' then 'CPA Code'
		 when x='cpa_name' then 'CPA Name' end as X	,Hosp_Code_Idx as Series_Idx,
	case when x='Hospital_Name' then 1
		 when x='cpa_code' then 2
		 when x='cpa_name' then 3 end as X_Idx	 
from (
	select Mkt,Hospital_Code, row_number() over(partition by Mkt order by Hospital_Code) as Hosp_Code_Idx,Hospital_Name,cpa_code,cpa_name
	from (select distinct mkt,Hospital_Code,Hospital_Name,Cpa_Code,cpa_name from #Temp_Data_For_Bal_Hospital) b
)a unpivot (
	Y for X in (
		[Hospital_Name],[cpa_code],[cpa_name]
	)
)t

insert into dbo.KPI_Frame_MarketAnalyzer_BAL_Hospials(TimeFrame,MoneyType,Molecule,Class,Mkt,
	MktName,market,prod,Series,DataType,Category,Y,X,Series_Idx,X_Idx)
select 'YTD','UN','','',Mkt,Mkt,
	case when mkt='arv' then 'Baraclude' 
		 when mkt='ONCFCS' then 'Taxol' 
		 when mkt='cml' then 'Sprycel' end as Market,
	'' as Prod,Hospital_Code as Series,null,null,Y,
	productName as X	,Hosp_Code_Idx as Series_Idx,
	Prod_Idx+3 as X_Idx	 
from (
	select Mkt,Hospital_Code, dense_rank() over(partition by Mkt order by Hospital_Code) as Hosp_Code_Idx,productName ,Prod_Idx,Market_Share as Y
	from #Temp_Data_For_Bal_Hospital 
)a
print '------------------------------------------
--				BAL Hospital Ending
------------------------------------------'

print '
-------------------------------------------
--				Hospital Segment Starting
-------------------------------------------
'

IF OBJECT_ID(N'Temp_HospitalData_For_Hospital_Segment',N'U') IS NOT NULL
	DROP TABLE Temp_HospitalData_For_Hospital_Segment
select a.Market,convert(char(5),a.prod) as prod,b.ProductName,b.Molecule,b.Class, case when a.Hospital_Category like 'BAL%' then 'BAL' 
						 when a.hospital_category like 'key%' then 'Key' 
						 else 'Others' end as Hospital_Category,
	sum(a.UYTD) as UYTD,sum(a.UYTDStly) as UYTDStly,sum(a.VYTD) as VYTD ,sum(a.VYTDStly) as VYTDStly
into Temp_HospitalData_For_Hospital_Segment	
from TempHospitalData_For_BAL_Hospital a join (
	select distinct Mkt,Prod,productName,Molecule,Class
	from tblMktDefHospital_Baraclude_CPA_KPIFrame
	--where prod in ('100','200','300','400','500','800')
	union all
	select distinct Mkt,Prod,productName,Molecule,Class
	from tblMktDefHospital_Taxol_CPA_KPIFrame where mkt='ONCFCS'
	union all
	select distinct Mkt,Prod,productName,Molecule,Class
	from tblMktDefHospital where mkt='cml'
) b on a.market=b.mkt and a.prod=b.prod
where a.prod is not null
group by a.Market,a.prod,b.ProductName,b.Molecule,b.Class,case when Hospital_Category like 'BAL%' then 'BAL' 
						 when hospital_category like 'key%' then 'Key' 
						 else 'Others' end  

--Add Sprycel 'Other' product
insert into Temp_HospitalData_For_Hospital_Segment (market,prod,productname,molecule,class,hospital_category,UYTD,UYTDStly,VYTD,VYTDStly)
select a.market,'400' as prod, 'Others' as ProductName,'N' as Molecule,'N' as Class,a.Hospital_Category,
	a.UYTD-b.UYTD as UYTD,a.UYTDStly-b.UYTDStly as UYTDStly,a.VYTD-b.VYTD as VYTD, a.VYTDStly-b.VYTDStly as VYTDStly
from (
	select * 
	from Temp_HospitalData_For_Hospital_Segment 
	where market='cml' and prod='000'
) a join (
	select market,'' as Prod,'Non-Other' as ProductName,Molecule,Class,Hospital_Category,
		sum(UYTD) as UYTD,sum(UYTDStly) as UYTDStly,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from Temp_HospitalData_For_Hospital_Segment where market='cml' and prod in ('100','200','300')
	group by market,Molecule,Class,Hospital_Category
) b on a.market=b.market and a.Molecule=b.Molecule and a.class=b.class and a.hospital_category=b.hospital_Category



--Add Total Category
insert into Temp_HospitalData_For_Hospital_Segment (market,prod,productname,molecule,class,hospital_category,UYTD,UYTDStly,VYTD,VYTDStly)
select Market,Prod,productName,molecule,Class,'Total' as Hospital_Category,
	sum(UYTD) as UYTD,sum(UYTDStly) as UYTDStly,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
from Temp_HospitalData_For_Hospital_Segment
group by  Market,Prod,productName,molecule,Class

--# Matched Hospital
insert into Temp_HospitalData_For_Hospital_Segment (market,prod,productname,molecule,class,hospital_category,UYTD,UYTDStly,VYTD,VYTDStly)
select market,'00000' as Prod,'# Matched Hospitals', 'N' as Molecule,'N' as Class,
	case when a.Hospital_Category like 'BAL%' then 'BAL' 
			 when a.hospital_category like 'key%' then 'Key' 
			 else 'Others' end as Hospital_Category, 
 count(distinct Hospital_Code) as Mathched_Hosp_Num,0,0,0
from TempHospitalData_For_BAL_Hospital a where cpa_id is not null
group by market,case when a.Hospital_Category like 'BAL%' then 'BAL' 
			 when a.hospital_category like 'key%' then 'Key' 
			 else 'Others' end 
union all			 
select market,'00000' as Prod,'# Matched Hospitals', 'N' as Molecule,'N' as Class,
	'Total' as Hospital_Category, 
 count(distinct Hospital_Code) as Mathched_Hosp_Num,0,0,0
from TempHospitalData_For_BAL_Hospital a where cpa_id is not null
group by market

--Baraclude & Taxol & Sprycel YTD Volumn Share
truncate table KPI_Frame_MarketAnalyzer_Hospital_Segment
insert into KPI_Frame_MarketAnalyzer_Hospital_Segment ( TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,market,
	prod,Series,DataType,Category,Y,X,X_Idx,Series_Idx,Category_Idx
)
select 'YTD' as TimeFrame,'UN' as MoneyType,a.Molecule,a.Class,a.market as Mkt,a.market as MktName,
	case when a.market='arv' then 'Baraclude' 
		 when a.market='cml' then 'Sprycel' 
		 when a.market='ONCFCS' then 'Taxol' end as Market,
	a.prod,a.productName as Series,'Share' as DataType,'Volume' as Category,
	case when b.UYTD >0 then 1.0*a.UYTD/b.UYTD else null end as Y,
	a.Hospital_Category as X,
	case when a.Hospital_Category='BAL' then 1 
		 when a.Hospital_Category='key' then 2
		 when a.Hospital_Category='Others' then 3  end as x_idx,
	case when a.market='arv' and a.productName='Baraclude' then 1
		 when a.market='arv' and a.productName='Hepsera' then 2
		 when a.market='arv' and a.productName='Heptodin' then 3
		 when a.market='arv' and a.productName='Run Zhong' then 4
		 when a.market='arv' and a.productName='Sebivo' then 5
		 when a.market='arv' and a.productName='VIREAD' then 6
		 when a.market='arv' and a.productName='Other Entecavir' then 7
		 when a.market='arv' and a.productName='ARV Others' then 8
		 when a.market='ONCFCS' and a.productName='Taxol' then 1
		 when a.market='ONCFCS' and a.productName='Abraxane' then 2
		 when a.market='ONCFCS' and a.productName='Ai Su' then 3
		 when a.market='ONCFCS' and a.productName='Anzatax' then 4
		 when a.market='ONCFCS' and a.productName='Gemzar' then 5
		 when a.market='ONCFCS' and a.productName='Li Pu Su' then 6
		 when a.market='ONCFCS' and a.productName='Taxotere' then 7
		 when a.market='ONCFCS' and a.productName='Ze Fei' then 8
		 when a.market='ONCFCS' and a.productName='Taxol Others' then 9
		 when a.market='cml' and a.productName='Sprycel' then 1
		 when a.market='cml' and a.productName='Gleevec' then 2
		 when a.market='cml' and a.productName='Tasigna' then 3
		 when a.market='cml' and a.productName='Others' then 4 end as Series_Idx, 
	2 as Category_Idx
from Temp_HospitalData_For_Hospital_Segment a join Temp_HospitalData_For_Hospital_Segment b 
on a.Market=b.Market and a.molecule=b.molecule and a.class=b.class and a.Hospital_Category=b.Hospital_Category
 and a.prod<>'000' and b.prod='000' and a.Hospital_Category <>'Total'
where (a.market='arv' and a.prod in ('100','200','300','400','500','600','700','800')) 
	or (a.market='ONCFCS' and a.prod in ('100','200','300','600','860','850','700','800','880'))
	or (a.market='cml' and a.prod in ('100','200','300','400'))

--Baraclude & Taxol & Sprycel YTD value Share
insert into KPI_Frame_MarketAnalyzer_Hospital_Segment ( TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,market,
	prod,Series,DataType,Category,Y,X,X_Idx,Series_Idx,Category_Idx
)
select 'YTD' as TimeFrame,'US' as MoneyType,a.Molecule,a.Class,a.market as Mkt,a.market as MktName,
	case when a.market='arv' then 'Baraclude' 
		 when a.market='cml' then 'Sprycel' 
		 when a.market='ONCFCS' then 'Taxol' end as Market,
	a.prod,a.productName as Series,'Share' as DataType,'Value' as Category,
	case when b.VYTD >0 then 1.0*a.VYTD/b.VYTD else null end as Y,
	a.Hospital_Category as X,
	case when a.Hospital_Category='BAL' then 1 
		 when a.Hospital_Category='key' then 2
		 when a.Hospital_Category='Others' then 3  end as x_idx,
		case when a.market='arv' and a.productName='Baraclude' then 1
		 when a.market='arv' and a.productName='Hepsera' then 2
		 when a.market='arv' and a.productName='Heptodin' then 3
		 when a.market='arv' and a.productName='Run Zhong' then 4
		 when a.market='arv' and a.productName='Sebivo' then 5
		 when a.market='arv' and a.productName='VIREAD' then 6
		 when a.market='arv' and a.productName='Other Entecavir' then 7
		 when a.market='arv' and a.productName='ARV Others' then 8
		 when a.market='ONCFCS' and a.productName='Taxol' then 1
		 when a.market='ONCFCS' and a.productName='Abraxane' then 2
		 when a.market='ONCFCS' and a.productName='Ai Su' then 3
		 when a.market='ONCFCS' and a.productName='Anzatax' then 4
		 when a.market='ONCFCS' and a.productName='Gemzar' then 5
		 when a.market='ONCFCS' and a.productName='Li Pu Su' then 6
		 when a.market='ONCFCS' and a.productName='Taxotere' then 7
		 when a.market='ONCFCS' and a.productName='Ze Fei' then 8
		 when a.market='ONCFCS' and a.productName='Taxol Others' then 9
		 when a.market='cml' and a.productName='Sprycel' then 1
		 when a.market='cml' and a.productName='Gleevec' then 2
		 when a.market='cml' and a.productName='Tasigna' then 3
		 when a.market='cml' and a.productName='Others' then 4 end as Series_Idx, 
		 1 as Category_Idx
from Temp_HospitalData_For_Hospital_Segment a join Temp_HospitalData_For_Hospital_Segment b 
on a.Market=b.Market and a.molecule=b.molecule and a.class=b.class and a.Hospital_Category=b.Hospital_Category
 and a.prod<>'000' and b.prod='000' and a.Hospital_Category <>'Total'
where (a.market='arv' and a.prod in ('100','200','300','400','500','600','700','800')) 
	or (a.market='ONCFCS' and a.prod in ('100','200','300','600','860','850','700','800','880'))
	or (a.market='cml' and a.prod in ('100','200','300','400'))

--Baraclude & Taxol & Sprycel YTD value Growth

insert into KPI_Frame_MarketAnalyzer_Hospital_Segment ( TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,market,
	prod,Series,DataType,Category,Y,X,X_Idx,Series_Idx,Category_Idx
)
select 'YTD' as TimeFrame,'US' as MoneyType,a.Molecule,a.Class,a.market as Mkt,a.market as MktName,
	case when a.market='arv' then 'Baraclude' 
		 when a.market='cml' then 'Sprycel' 
		 when a.market='ONCFCS' then 'Taxol' end as Market,
	a.prod,
	case when a.market='arv' and a.productName='Entecavir' then 'Total ETV'
		 when a.market='arv' and a.productName='Adefovir Dipivoxil' then 'Total ADV'
		 when a.market='arv' and a.productName='VIREAD' then 'Tenofovir'
		 when a.market='cml' and a.productName='Gleevec' then 'Glivec'
		 when a.market='cml' and a.productName='DASATINIB' then 'Total Dasatinib'
		 when a.prod='000' then 'Total'
		 else a.ProductName end as Series,
	'Growth' as DataType,'Value' as Category,
	case when a.prod='00000' then UYTD else 
		(case when a.VYTDStly >0 then 1.0*(a.VYTD-a.VYTDStly)/a.VYTDStly else null end) end as Y,
	case when a.Hospital_Category='BAL' then 'BAL Hospitals' 
		 when a.Hospital_Category='key' then 'Key Hospitals'
		 when a.Hospital_Category='Others' then 'Other Hospitals'
		 when a.Hospital_Category='Total' then 'Total'  end as X,
	case when a.Hospital_Category='BAL' then 1 
		 when a.Hospital_Category='key' then 2
		 when a.Hospital_Category='Others' then 3
		 when a.Hospital_Category='Total' then 4  end as x_idx,
	case when a.prod='00000' then 1
		 when a.market='arv' and a.prod='000' then 2
		 when a.market='arv' and a.productName='Baraclude' then 3
		 when a.market='arv' and a.productName='Hepsera' then 4
		 when a.market='arv' and a.productName='Heptodin' then 5
		 when a.market='arv' and a.productName='Run Zhong' then 6
		 when a.market='arv' and a.productName='Sebivo' then 7
		 when a.market='arv' and a.productName='VIREAD' then 8
		 when a.market='arv' and a.productName='Entecavir' then 9
		 when a.market='arv' and a.productName='Adefovir Dipivoxil' then 10
		 when a.market='ONCFCS' and a.prod='000' then 2
		 when a.market='ONCFCS' and a.productName='Taxol' then 3
		 when a.market='ONCFCS' and a.productName='Abraxane' then 4
		 when a.market='ONCFCS' and a.productName='Ai Su' then 5
		 when a.market='ONCFCS' and a.productName='Anzatax' then 6
		 when a.market='ONCFCS' and a.productName='Gemzar' then 7
		 when a.market='ONCFCS' and a.productName='Li Pu Su' then 8
		 when a.market='ONCFCS' and a.productName='Taxotere' then 9
		 when a.market='ONCFCS' and a.productName='Ze Fei' then 10
		 when a.market='ONCFCS' and a.productName='Total Paclitaxel' then 11
		 when a.market='cml' and a.prod='000' then 2
		 when a.market='cml' and a.productName='Sprycel' then 3
		 when a.market='cml' and a.productName='Gleevec' then 4
		 when a.market='cml' and a.productName='Tasigna' then 5
		 when a.market='cml' and a.productName='DASATINIB' then 6 end as Series_Idx, 
		 1 as Category_Idx
from Temp_HospitalData_For_Hospital_Segment a 
where (a.market='arv' and a.prod in ('000','010','020','100','200','300','400','500','800','00000'))
	or (a.market='ONCFCS' and a.prod in ('000','100','200','300','860','600','700','800','850','010','00000'))
	or (a.market='cml' and a.prod in ('000','100','200','300','010','00000'))

--Baraclude & Taxol & Sprycel YTD Volume Growth

insert into KPI_Frame_MarketAnalyzer_Hospital_Segment ( TimeFrame,MoneyType,Molecule,Class,Mkt,Mktname,market,
	prod,Series,DataType,Category,Y,X,X_Idx,Series_Idx,Category_Idx
)
select 'YTD' as TimeFrame,'UN' as MoneyType,a.Molecule,a.Class,a.market as Mkt,a.market as MktName,
	case when a.market='arv' then 'Baraclude' 
		 when a.market='cml' then 'Sprycel' 
		 when a.market='ONCFCS' then 'Taxol' end as Market,
	a.prod,
	case when a.market='arv' and a.productName='Entecavir' then 'Total ETV'
		 when a.market='arv' and a.productName='Adefovir Dipivoxil' then 'Total ADV'
		 when a.market='arv' and a.productName='VIREAD' then 'Tenofovir'
		 when a.market='cml' and a.productName='Gleevec' then 'Glivec'
		 when a.market='cml' and a.productName='DASATINIB' then 'Total Dasatinib'
		 when a.prod='000' then 'Total'
		 else a.ProductName end as Series,
	'Growth' as DataType,'Volume' as Category,
	case when a.prod='00000' then UYTD 
	else (case when a.UYTDStly >0 then 1.0*(a.UYTD-a.UYTDStly)/a.UYTDStly else null end) end as Y,
	case when a.Hospital_Category='BAL' then 'BAL Hospitals' 
		 when a.Hospital_Category='key' then 'Key Hospitals'
		 when a.Hospital_Category='Others' then 'Other Hospitals'
		 when a.Hospital_Category='Total' then 'Total'  end as X,
	case when a.Hospital_Category='BAL' then 1 
		 when a.Hospital_Category='key' then 2
		 when a.Hospital_Category='Others' then 3
		 when a.Hospital_Category='Total' then 4  end as x_idx,
	case when a.prod='00000' then 1
		 when a.market='arv' and a.prod='000' then 2
		 when a.market='arv' and a.productName='Baraclude' then 3
		 when a.market='arv' and a.productName='Hepsera' then 4
		 when a.market='arv' and a.productName='Heptodin' then 5
		 when a.market='arv' and a.productName='Run Zhong' then 6
		 when a.market='arv' and a.productName='Sebivo' then 7
		 when a.market='arv' and a.productName='VIREAD' then 8
		 when a.market='arv' and a.productName='Entecavir' then 9
		 when a.market='arv' and a.productName='Adefovir Dipivoxil' then 10
		 when a.market='ONCFCS' and a.prod='000' then 2
		 when a.market='ONCFCS' and a.productName='Taxol' then 3
		 when a.market='ONCFCS' and a.productName='Abraxane' then 4
		 when a.market='ONCFCS' and a.productName='Ai Su' then 5
		 when a.market='ONCFCS' and a.productName='Anzatax' then 6
		 when a.market='ONCFCS' and a.productName='Gemzar' then 7
		 when a.market='ONCFCS' and a.productName='Li Pu Su' then 8
		 when a.market='ONCFCS' and a.productName='Taxotere' then 9
		 when a.market='ONCFCS' and a.productName='Ze Fei' then 10
		 when a.market='ONCFCS' and a.productName='Total Paclitaxel' then 11
		 when a.market='cml' and a.prod='000' then 2
		 when a.market='cml' and a.productName='Sprycel' then 3
		 when a.market='cml' and a.productName='Gleevec' then 4
		 when a.market='cml' and a.productName='Tasigna' then 5
		 when a.market='cml' and a.productName='DASATINIB' then 6 end as Series_Idx, 
		 2 as Category_Idx
from Temp_HospitalData_For_Hospital_Segment a 
where (a.market='arv' and a.prod in ('000','010','020','100','200','300','400','500','800','00000'))
	or (a.market='ONCFCS' and a.prod in ('000','100','200','300','860','600','700','800','850','010','00000'))
	or (a.market='cml' and a.prod in ('000','100','200','300','010','00000'))

--把Tenofovir替换为Viread
update KPI_Frame_AnalyzerMarket_HospitalPerformance 
set x=replace(x,'Tenofovir','Viread')
where market='baraclude' and x like 'Tenofovir%'

update KPI_Frame_MarketAnalyzer_Hospital_Segment 
set series='Viread'
where market='baraclude' and series='Tenofovir'

USE BMSChinaCIA_IMS
GO


--Transfer the data to BMSChina_CIA_IMS database
IF EXISTS(SELECT 1 FROM BMSChinaCIA_IMS.dbo.sysobjects where id=object_id(N'dbo.KPI_Frame_AnalyzerMarket_HospitalPerformance') and type='U')
BEGIN
	DROP TABLE  BMSChinaCIA_IMS.dbo.KPI_Frame_AnalyzerMarket_HospitalPerformance
END
SELECT * INTO  BMSChinaCIA_IMS.dbo.KPI_Frame_AnalyzerMarket_HospitalPerformance 
FROM BMSChinaMRBI.dbo.KPI_Frame_AnalyzerMarket_HospitalPerformance


IF EXISTS(SELECT 1 FROM  BMSChinaCIA_IMS.dbo.sysobjects where id=object_id(N'dbo.KPI_FRAME_BusinessSourceOfXarelto') and type='U')
BEGIN
	DROP TABLE  BMSChinaCIA_IMS.dbo.KPI_FRAME_BusinessSourceOfXarelto
END
SELECT * INTO dbo.KPI_FRAME_BusinessSourceOfXarelto 
FROM BMSChinaMRBI.dbo.KPI_FRAME_BusinessSourceOfXarelto


IF EXISTS(SELECT 1 FROM  BMSChinaCIA_IMS.dbo.sysobjects where id=object_id(N'dbo.KPI_Frame_CPA_Part_Market_Product_Mapping') and type='U')
BEGIN
	DROP TABLE  BMSChinaCIA_IMS.dbo.KPI_Frame_CPA_Part_Market_Product_Mapping
END
SELECT * INTO  BMSChinaCIA_IMS.dbo.KPI_Frame_CPA_Part_Market_Product_Mapping 
FROM BMSChinaMRBI.dbo.KPI_Frame_CPA_Part_Market_Product_Mapping

IF EXISTS(SELECT 1 FROM  BMSChinaCIA_IMS.dbo.sysobjects where id=object_id(N'dbo.KPI_FRAME_MoleculePerformanceInOrthopedics') and type='U')
BEGIN
	DROP TABLE  BMSChinaCIA_IMS.dbo.KPI_FRAME_MoleculePerformanceInOrthopedics
END
SELECT * INTO  BMSChinaCIA_IMS.dbo.KPI_FRAME_MoleculePerformanceInOrthopedics 
FROM BMSChinaMRBI.dbo.KPI_FRAME_MoleculePerformanceInOrthopedics

IF EXISTS(SELECT 1 FROM  BMSChinaCIA_IMS.dbo.sysobjects where id=object_id(N'dbo.KPI_Frame_MarketAnalyzer_BAL_Hospials') and type='U')
BEGIN
	DROP TABLE  BMSChinaCIA_IMS.dbo.KPI_Frame_MarketAnalyzer_BAL_Hospials
END
SELECT * INTO  BMSChinaCIA_IMS.dbo.KPI_Frame_MarketAnalyzer_BAL_Hospials 
FROM BMSChinaMRBI.dbo.KPI_Frame_MarketAnalyzer_BAL_Hospials

IF EXISTS(SELECT 1 FROM  BMSChinaCIA_IMS.dbo.sysobjects where id=object_id(N'dbo.KPI_Frame_MarketAnalyzer_Hospital_Segment') and type='U')
BEGIN
	DROP TABLE  BMSChinaCIA_IMS.dbo.KPI_Frame_MarketAnalyzer_Hospital_Segment
END
SELECT * INTO  BMSChinaCIA_IMS.dbo.KPI_Frame_MarketAnalyzer_Hospital_Segment 
FROM BMSChinaMRBI.dbo.KPI_Frame_MarketAnalyzer_Hospital_Segment


exec dbo.sp_Log_Event 'KPI Frame','CIA CPA','KPI-Frame-CPA&RX-Part_new.sql','End',null,null

