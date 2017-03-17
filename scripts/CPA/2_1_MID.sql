
/* 
这个脚本生成中间表


201301:
	new HP region definition
201206:
	add Sprycel market & processing 36 months data instead of 26 months
201203:
	keep only IMS city to fix issues of "Taizhou" for city "台州" & "泰州"
201202:
	new region defination
	new cpa 2 region mapping logic
	growth should be null when STLY is 0 or null


alter table tblMktDefHospital add Product varchar(10)
update tblMktDefHospital set Product = case 
when Mkt in ('NIAD','DIA') then 'Glucophage'
when Mkt in ('HYP','ACE') then 'Monopril'
when Mkt in ('ONC','ONCFCS') then 'Taxol'
when Mkt in ('HBV','ARV') then 'Baraclude' end
go

*/


use BMSChinaMRBI_test
go

--Time:22:54 20160511



--log
exec dbo.sp_Log_Event 'MID','CIA_CPA','2_1_MID.sql','Start',null,null
go







--将源数据统计到 Prod
print('------------------------------------------------------
                   tempHospitalDataByMth
-------------------------------------------------------------')
if object_id(N'tempHospitalDataByMth',N'U') is not null
  drop table tempHospitalDataByMth
GO
--1. CPA :
select 
   	'CPA' as DataSource
	, c.Mkt
	, c.Prod
	, a.cpa_id
	, a.Tier
	, convert(varchar(6),convert(Datetime,a.M+'/1/'+Y,101),112) as Mth
	, sum(Value*c.rat)  as Sales
	, sum(Volume*c.rat) as Units
	, sum(Volume*cast(subString(Specification,1,charindex(' ',Specification)) as float)/AvgPatientMG) as Adjusted_PatientNumber
into tempHospitalDataByMth
from inCPAData a
inner join tblMktDefHospital c                                     
on a.Molecule = c.Mole_Des_CN and a.Product = c.Prod_Des_CN
where exists(
            select * from tblHospitalMaster b 
            where a.cpa_id = b.id and b.DataSource = 'CPA'
            )
group by c.Mkt,c.Prod,a.cpa_id, a.Tier,a.M+'/1/'+Y
go
  --1.1 all
insert into tempHospitalDataByMth
select 
	'CPA' as DataSource
	, 'All' as Mkt
	, '999' as Prod
	, a.cpa_Id
	, a.Tier
	, convert(varchar(6),convert(Datetime,a.M+'/1/'+Y,101),112) as Mth
	, sum(Value) as Sales
	, sum(Volume) as Units
	, sum(Volume*cast(subString(Specification,1,charindex(' ',Specification)) as float)/AvgPatientMG) as Adjusted_PatientNumber
from inCPAData a
where exists(
            select * from dbo.tblHospitalMaster b 
            where b.DataSource = 'CPA' and b.id = a.cpa_id
            )
group by a.cpa_Id, a.Tier,a.M+'/1/'+Y
go






--2. SeaRainbow :
insert into tempHospitalDataByMth
select 'Sea' as DataSource, c.Mkt,c.Prod,a.cpa_id,a.Tier,
	a.YM as Mth, sum(isnull(Value*c.rat,0)) Sales, sum(isnull(Volume*c.rat,0)) Units
,null
from inSeaRainbowData a
inner join tblMktDefHospital c on 
	a.Molecule = c.Mole_Des_CN and
	a.Product = c.Prod_Des_CN
where exists(select * from dbo.tblHospitalMaster b where b.DataSource = 'Sea' and	b.id = a.cpa_id)
and  a.Molecule not in (N'卡铂',N'顺铂',N'奈达铂')
group by c.Mkt,c.Prod,a.cpa_id,a.Tier,a.YM
go
insert into tempHospitalDataByMth
select 'Sea' as DataSource, c.Mkt,c.Prod,a.cpa_id,a.Tier,
	a.YM as Mth, sum(isnull(Value*c.rat,0)) Sales, sum(isnull(Volume*c.rat,0)) Units
, sum(Volume*cast(subString(Specification,1,charindex(' ',Specification)) as float)/AvgPatientMG) as Adjusted_PatientNumber
from inSeaRainbowData a
inner join tblMktDefHospital c on 
	a.Molecule = c.Mole_Des_CN and
	a.Product = c.Prod_Des_CN
where exists(select * from dbo.tblHospitalMaster b where b.DataSource = 'Sea' and	b.id = a.cpa_id)
and  a.Molecule  in (N'卡铂',N'顺铂',N'奈达铂')
group by c.Mkt,c.Prod,a.cpa_id,a.Tier,a.YM
go
  --2.1 all
insert into tempHospitalDataByMth
select 'Sea' as DataSource, 'All' Mkt,'999' Prod,a.cpa_id, a.Tier,
	a.YM as Mth,sum(isnull(Value,0)) Sales, sum(isnull(Volume,0)) Units
,null
from inSeaRainbowData a
where exists(select * from dbo.tblHospitalMaster b where b.DataSource = 'Sea' and b.id = a.cpa_id)
and  a.Molecule not in (N'卡铂',N'顺铂',N'奈达铂')
group by a.cpa_id, a.Tier,a.YM
go
insert into tempHospitalDataByMth
select 'Sea' as DataSource, 'All' Mkt,'999' Prod,a.cpa_id, a.Tier,
	a.YM as Mth,sum(isnull(Value,0)) Sales, sum(isnull(Volume,0)) Units
, sum(Volume*cast(subString(Specification,1,charindex(' ',Specification)) as float)/AvgPatientMG) as Adjusted_PatientNumber
from inSeaRainbowData a
where exists(select * from dbo.tblHospitalMaster b where b.DataSource = 'Sea' and b.id = a.cpa_id)
and  a.Molecule  in (N'卡铂',N'顺铂',N'奈达铂')
group by a.cpa_id, a.Tier,a.YM
go


--3. PHA :
insert into tempHospitalDataByMth
select 
   'PHA' as DataSource
 , c.Mkt
 , c.Prod
 , a.cpa_id
 , a.Tier
 , convert(varchar(6),convert(Datetime,a.M+'/1/'+Y,101),112) as Mth
 , sum(Value*c.rat)  as Sales
 , sum(Volume*c.rat) as Units
 , null
 --, sum(Volume*cast(subString(Specification,1,charindex(' ',Specification)) as float)/AvgPatientMG) as Adjusted_PatientNumber
from inPharmData a
inner join tblMktDefHospital c                                     
on a.Molecule = c.Mole_Des_CN and a.Product = c.Prod_Des_CN
where exists(
            select * from tblHospitalMaster b 
            where a.cpa_id = b.id and b.DataSource = 'PHA'
            )
group by c.Mkt,c.Prod,a.cpa_id, a.Tier,a.M+'/1/'+Y
go
  --3.1 all
insert into tempHospitalDataByMth
select 
   'PHA' as DataSource
 , 'All' as Mkt
 , '999' as Prod
 , a.cpa_Id
 , a.Tier
 , convert(varchar(6),convert(Datetime,a.M+'/1/'+Y,101),112) as Mth
 , sum(Value) as Sales
 , sum(Volume) as Units
 , null
 --, sum(Volume*cast(subString(Specification,1,charindex(' ',Specification)) as float)/AvgPatientMG) as Adjusted_PatientNumber
from inPharmData a
where exists(
            select * from dbo.tblHospitalMaster b 
            where b.DataSource = 'PHA' and b.id = a.cpa_id
            )
group by a.cpa_Id, a.Tier,a.M+'/1/'+Y
go




  
-- select top 100 * from tempHospitalDataByMth

update tempHospitalDataByMth set Adjusted_PatientNumber = 0 where Adjusted_PatientNumber is null
GO



--进行行列转置
print('------------------------------------------------------
                   tempHospitalData
-------------------------------------------------------------')
if object_id(N'tempHospitalData',N'U') is not null
	drop table tempHospitalData
go
select distinct DataSource,Mkt,Prod,Cpa_id,Tier
into tempHospitalData
from tempHospitalDataByMth
go

create nonclustered index idx on tempHospitalData(cpa_id)
go

declare @i int, @sql varchar(8000)
set @sql = 'alter table tempHospitalData add
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
		'update tempHospitalData set 
		UM' + cast(@i as varchar) + '=b.Units
		,VM' + cast(@i as varchar) + '=b.Sales
		,PM' + cast(@i as varchar) + '=b.Adjusted_PatientNumber
		from tempHospitalData a
		inner join tempHospitalDataByMth b on a.Mkt = b.Mkt and a.Prod = b.Prod and a.cpa_id = b.cpa_id
		where b.Mth = (select Mth from tblHospitalMthList where idx = ' + cast(@i as varchar) + ')
'
	exec (@sql)
	set @i = @i + 1
end 
go


  --Rollup到YTD,MAT
alter table tempHospitalData add
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
UPDATE tempHospitalData SET
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

EXEC P_EXTEND_TABLE 'tempHospitalData','UR3M',1,24, 'DECIMAL(22,6)'
GO
EXEC P_EXTEND_TABLE 'tempHospitalData','VR3M',1,24, 'DECIMAL(22,6)'
GO
EXEC P_EXTEND_TABLE 'tempHospitalData','PR3M',1,24, 'DECIMAL(22,6)'
GO



DECLARE @I INT,@sql varchar(8000)
declare @st int, @ed int
set @i = 1
set @sql = 'update tempHospitalData set
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
if object_id(N'tempHospitalData_All',N'U') is not null
	drop table tempHospitalData_All
select * into tempHospitalData_All from tempHospitalData

delete from tempHospitalData where mkt='Eliquis VTEp' and prod in (500,600)
--delete from tempHospitalData where mkt='CCB'
go


if object_id(N'tblMktDefHospital_Eliquis_CPA_R640',N'U') is not null
	drop table tblMktDefHospital_Eliquis_CPA_R640
go

select *
into tblMktDefHospital_Eliquis_CPA_R640
from tblMktDefHospital
where mkt='Eliquis VTEp' and productname in ('Xarelto','Eliquis')

insert into tblMktDefHospital_Eliquis_CPA_R640
select mkt,mktname,'000' as Prod,'Eliquis Market' as productname,'N' as Molecule,'N' as Class,
	   atc3_cod,atc_cpa,mole_des_cn,mole_Des_En,Prod_des_cn,Prod_des_en,FocusedBrand,IMSMoleCode,IMSProdCode,product,rat
from tblMktDefHospital_Eliquis_CPA_R640 where  productname in ('Xarelto','Eliquis')

--add Eliquis CPA KPIFrame Temp
print('------------------------------------------------------
                   tempHospitalDataByMth_Eliquis_CPA_R640
-------------------------------------------------------------')
if object_id(N'tempHospitalDataByMth_Eliquis_CPA_R640',N'U') is not null
  drop table tempHospitalDataByMth_Eliquis_CPA_R640
GO
--1. CPA :
select 
   'CPA' as DataSource
	, c.Mkt
	, c.Prod
	, a.cpa_id
	, a.Tier
	, convert(varchar(6),convert(Datetime,a.M+'/1/'+Y,101),112) as Mth
	, sum(Value*(case when prod='300' then 0.6 else 1 end))  as Sales
	, sum(Volume*(case when prod='300' then 0.6 else 1 end)) as Units
	, sum(Volume*cast(subString(Specification,1,charindex(' ',Specification)) as float)/AvgPatientMG) as Adjusted_PatientNumber
into tempHospitalDataByMth_Eliquis_CPA_R640
from inCPAData a
inner join tblMktDefHospital_Eliquis_CPA_R640 c                                     
on a.Molecule = c.Mole_Des_CN and a.Product = c.Prod_Des_CN
where exists(
            select * from tblHospitalMaster b 
            where a.cpa_id = b.id and b.DataSource = 'CPA'
            )
group by c.Mkt,c.Prod,a.cpa_id, a.Tier,a.M+'/1/'+Y
go

update tempHospitalDataByMth_Eliquis_CPA_R640 set Adjusted_PatientNumber = 0 where Adjusted_PatientNumber is null
GO

--进行行列转置
print('------------------------------------------------------
                   tempHospitalData_Eliquis_CPA_R640
-------------------------------------------------------------')
if object_id(N'tempHospitalData_Eliquis_CPA_R640',N'U') is not null
	drop table tempHospitalData_Eliquis_CPA_R640
go
select distinct DataSource,Mkt,Prod,Cpa_id,Tier
into tempHospitalData_Eliquis_CPA_R640
from tempHospitalDataByMth_Eliquis_CPA_R640
go

create nonclustered index idx on tempHospitalData_Eliquis_CPA_R640(cpa_id)
go

declare @i int, @sql varchar(8000)
set @sql = 'alter table tempHospitalData_Eliquis_CPA_R640 add
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
'update tempHospitalData_Eliquis_CPA_R640 set 
 UM' + cast(@i as varchar) + '=b.Units
,VM' + cast(@i as varchar) + '=b.Sales
,PM' + cast(@i as varchar) + '=b.Adjusted_PatientNumber
from tempHospitalData_Eliquis_CPA_R640 a
inner join tempHospitalDataByMth_Eliquis_CPA_R640 b on a.Mkt = b.Mkt and a.Prod = b.Prod and a.cpa_id = b.cpa_id
where b.Mth = (select Mth from tblHospitalMthList where idx = ' + cast(@i as varchar) + ')
'
	exec (@sql)
	set @i = @i + 1
end 
go


  --Rollup到YTD,MAT
alter table tempHospitalData_Eliquis_CPA_R640 add
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
UPDATE tempHospitalData_Eliquis_CPA_R640 SET
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

EXEC P_EXTEND_TABLE 'tempHospitalData_Eliquis_CPA_R640','UR3M',1,24, 'DECIMAL(22,6)'
GO
EXEC P_EXTEND_TABLE 'tempHospitalData_Eliquis_CPA_R640','VR3M',1,24, 'DECIMAL(22,6)'
GO
EXEC P_EXTEND_TABLE 'tempHospitalData_Eliquis_CPA_R640','PR3M',1,24, 'DECIMAL(22,6)'
GO



DECLARE @I INT,@sql varchar(8000)
declare @st int, @ed int
set @i = 1
set @sql = 'update tempHospitalData_Eliquis_CPA_R640 set
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







-- 统计到每个Product各自的GEO
-- Each product has it's special sales region.
print('------------------------------------------------------
                   tempHospitalDataByGeo
-------------------------------------------------------------')
if object_id(N'tempHospitalDataByGeo',N'U') is not null
	drop table tempHospitalDataByGeo
go
-- Region level:  From 201301, The cities were aligned to region for all product
select distinct 
	b.Product
	, 'Region' as Lev
	, cast('China' as varchar(50)) as ParentGeo
	, cast(d.Region as nvarchar(50)) as Geo
	, a.* 
into tempHospitalDataByGeo
from tempHospitalData a
inner join (
           select distinct Product,Mkt 
           from tblMktDefHospital 
           where Product in ('Taxol','Monopril','Baraclude','Sprycel')
		--    where Product in ('Taxol','Monopril','Baraclude','Paraplatin','Coniel','Eliquis VTEp','Eliquis NOAC','Eliquis VTEt')
           ) b on  b.Mkt = a.Mkt
inner join tblHospitalMaster c on a.cpa_id = c.id
inner join (
           select distinct Product,Region,Province1,City1,City
           from tblSalesRegion 
           where Product in ('Taxol','Monopril','Baraclude','Sprycel')
        --    where Product in ('Taxol','Monopril','Glucophage','Baraclude','Paraplatin','Coniel','Eliquis')
           ) d on (d.Product=b.Product or left(b.product,7)=d.product)and d.Province1 = c.Province and d.City1 = c.City
go

-- City level
insert into tempHospitalDataByGeo
select distinct 
	b.Product
	,'City'
	, d.Region as ParentGeo
	, c.City as Geo
	, a.* 
from tempHospitalData a
inner join (
           select distinct Product,Mkt 
           from tblMktDefHospital 
           where Product in ('Taxol','Monopril','Baraclude','Sprycel')
        --    where Product in ('Taxol','Monopril','Glucophage','Baraclude','Paraplatin','Coniel','Eliquis VTEp','Eliquis NOAC','Eliquis VTEt')
           ) b on 	b.Mkt = a.Mkt
inner join tblHospitalMaster c on a.cpa_id = c.id
inner join (
           select distinct Product,Region, Province1,City1 
           from tblSalesRegion 
           where Product in ('Taxol','Monopril','Baraclude','Sprycel')
		--    where Product in ('Taxol','Monopril','Glucophage','Baraclude','Paraplatin','Coniel','Eliquis')
           ) d on (d.Product=b.Product or left(b.product,7)=d.product) and d.Province1 = c.Province and d.City1 = c.City
go

-- Hospital Total
insert into tempHospitalDataByGeo
select 
  b.Product
 ,b.Lev
 ,b.ParentGeo
 ,b.Geo
 ,a.*
from tempHospitalData a 
inner join (
           select distinct Product, Lev, ParentGeo, Geo ,CPA_ID
           from tempHospitalDataByGeo
           ) b on a.cpa_id = b.cpa_id
where a.Mkt = 'All' and a.Prod = '999'
go

-- Nation level
insert into tempHospitalDataByGeo
select distinct 
	b.Product
	,'Nat' Lev
	,'China' as ParentGeo
	,'China' Geo
	,a.*
from tempHospitalData a 
inner join (
           select distinct Product,Mkt 
           from tblMktDefHospital
           ) b on a.Mkt = b.Mkt
go

-- only reserve the ims city
delete tempHospitalDataByGeo
from tempHospitalDataByGeo a
where a.lev = 'city' and not exists(
	select * from tblSalesRegion b 
	where b.IMSCity is not null
		and a.Product = b.Product 
		and a.parentGeo = b.Region 
		and a.Geo = b.City1
)  and a.mkt not like 'eliquis%'
go

-- Convert the city to city_english 
update tempHospitalDataByGeo set Geo = b.Geo
from tempHospitalDataByGeo a
inner join (
	select distinct Product,Region,city1,isnull(imscity ,city) Geo
	from tblSalesRegion 
) b on (a.Product=b.Product or left(a.product,7)=b.product) and a.ParentGeo = b.Region and a.Geo = b.City1
where a.Lev = 'City'
go

update tempHospitalDataByGeo set Geo = b.City_en
from tempHospitalDataByGeo a
inner join (select distinct city,city_en from tblHospitalMaster) b on a.Geo = b.City
where a.Lev = 'City' 
go

create nonclustered index idx on tempHospitalDataByGeo(Product, Lev,Geo,Mkt,Prod,cpa_id)
go



-- HOSPITAL RANK
alter table tempHospitalDataByGeo add
	UC3MRANK INT,
	UYTDRANK INT,
	UMATRANK INT,
	
	VC3MRANK INT,
	VYTDRANK INT,
	VMATRANK INT,
	
	PC3MRANK INT,
	PYTDRANK INT,
	PMATRANK INT
GO

UPDATE tempHospitalDataByGeo SET UC3MRANK = B.RANK
FROM tempHospitalDataByGeo A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,ParentGeo, GEO, Mkt,Prod ORDER BY UR3M1 DESC) RANK
	FROM tempHospitalDataByGeo
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByGeo SET UYTDRANK = B.RANK
FROM tempHospitalDataByGeo A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,ParentGeo, GEO, Mkt,Prod ORDER BY UYTD DESC) RANK
	FROM tempHospitalDataByGeo
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByGeo SET UMATRANK = B.RANK
FROM tempHospitalDataByGeo A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,ParentGeo, GEO, Mkt,Prod ORDER BY UMAT1 DESC) RANK
	FROM tempHospitalDataByGeo
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByGeo SET VC3MRANK = B.RANK
FROM tempHospitalDataByGeo A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,ParentGeo, GEO, Mkt,Prod ORDER BY VR3M1 DESC) RANK
	FROM tempHospitalDataByGeo
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByGeo SET VYTDRANK = B.RANK
FROM tempHospitalDataByGeo A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,ParentGeo, GEO, Mkt,Prod ORDER BY VYTD DESC) RANK
	FROM tempHospitalDataByGeo
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByGeo SET VMATRANK = B.RANK
FROM tempHospitalDataByGeo A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,ParentGeo, GEO, Mkt,Prod ORDER BY VMAT1 DESC) RANK
	FROM tempHospitalDataByGeo
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByGeo SET PC3MRANK = B.RANK
FROM tempHospitalDataByGeo A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,ParentGeo, GEO, Mkt,Prod ORDER BY PR3M1 DESC) RANK
	FROM tempHospitalDataByGeo
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByGeo SET PYTDRANK = B.RANK
FROM tempHospitalDataByGeo A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,ParentGeo, GEO, Mkt,Prod ORDER BY PYTD DESC) RANK
	FROM tempHospitalDataByGeo
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByGeo SET PMATRANK = B.RANK
FROM tempHospitalDataByGeo A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,ParentGeo, GEO, Mkt,Prod ORDER BY PMAT1 DESC) RANK
	FROM tempHospitalDataByGeo
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO


-- HOSPITAL Growth
alter table tempHospitalDataByGeo add
	UC3MGrowth Decimal(22,6),
	UYTDGrowth Decimal(22,6),
	UMATGrowth DECIMAL(22,6),
	
	VC3MGrowth Decimal(22,6),
	VYTDGrowth Decimal(22,6),
	VMATGrowth decimal(22,6),
	
	PC3MGrowth Decimal(22,6),
	PYTDGrowth Decimal(22,6),
	PMATGrowth DECIMAL(22,6)

GO

update tempHospitalDataByGeo set
	UC3MGrowth = case when UR3M13 = 0 then null else UR3M1/UR3M13 -1 end,
	UYTDGrowth = case when UYTDstly = 0 then null else UYTD/UYTDstly-1 end,
	UMATGrowth = case when UMAT2 = 0 then null else UMAT1/UMAT2-1 end,
	VC3MGrowth = case when VR3M13 = 0 then null else VR3M1/VR3M13 -1 end,
	VYTDGrowth = case when VYTDstly = 0 then null else VYTD/VYTDstly-1 end,
	VMATGrowth = case when VMAT2 = 0 then null else VMAT1/VMAT2-1 end,
	PC3MGrowth = case when PR3M13 = 0 then null else PR3M1/PR3M13 -1 end,
	PYTDGrowth = case when PYTDstly = 0 then null else PYTD/PYTDstly-1 end,
	PMATGrowth = case when PMAT2 = 0 then null else PMAT1/PMAT2-1 end

go

alter table tempHospitalDataByGeo add
	UC3MShare Decimal(22,6),
	UYTDShare Decimal(22,6),
	UMATShare Decimal(22,6),
	UMShare1  Decimal(22,6),
	
	VC3MShare Decimal(22,6),
	VYTDShare Decimal(22,6),
	VMATShare Decimal(22,6),
	VMShare1  Decimal(22,6),	
	
	PC3MShare Decimal(22,6),
	PYTDShare Decimal(22,6),
	PMATShare Decimal(22,6),
	PMShare1  Decimal(22,6)	

GO

update tempHospitalDataByGeo 
set
	UC3MShare = case when b.UR3M1 = 0 then 0 else A.UR3M1/B.UR3M1 end,
	UYTDShare = case when B.UYTD = 0 then 0 else A.UYTD/B.UYTD end,
	UMATShare = case when b.UMAT1 = 0 then 0 else a.UMAT1/b.UMAT1 end,
	UMShare1 = case when b.UM1 = 0 then 0 else a.UM1/b.UM1 end,
	VC3MShare = case when B.VR3M1 = 0 then 0 else A.VR3M1/B.VR3M1 end,
	VYTDShare = case when B.VYTD = 0 then 0 else A.VYTD/B.VYTD end,
	VMATShare = case when b.VMAT1 = 0 then 0 else a.VMAT1/B.VMAT1 end,
	VMShare1 = case when b.VM1 = 0 then 0 else a.VM1/b.VM1 end,	
	PC3MShare = case when B.PR3M1 = 0 then 0 else A.PR3M1/B.PR3M1 end,
	PYTDShare = case when B.PYTD = 0 then 0 else A.PYTD/B.PYTD end,
	PMATShare = case when b.PMAT1 = 0 then 0 else a.PMAT1/B.PMAT1 end,
	PMShare1 = case when b.PM1 = 0 then 0 else a.PM1/b.PM1 end	
from tempHospitalDataByGeo a
inner join (select * from tempHospitalDataByGeo where Prod = '000') b 
on
	a.Product = b.Product and a.Lev = b.Lev and a.ParentGeo = b.ParentGeo and a.Geo = b.Geo and a.Mkt = b.Mkt and a.CPA_ID = b.Cpa_id
go



EXEC P_EXTEND_TABLE 'tempHospitalDataByGeo','UMGrowth',1,12
GO
EXEC P_EXTEND_TABLE 'tempHospitalDataByGeo','VMGrowth',1,12
GO
EXEC P_EXTEND_TABLE 'tempHospitalDataByGeo','PMGrowth',1,12
GO
EXEC P_EXTEND_TABLE 'tempHospitalDataByGeo','UR3MGrowth',1,12
GO
EXEC P_EXTEND_TABLE 'tempHospitalDataByGeo','VR3MGrowth',1,12
GO
EXEC P_EXTEND_TABLE 'tempHospitalDataByGeo','PR3MGrowth',1,12
GO

declare @sql varchar(8000), @i int
set @i = 1
set @sql = 'update tempHospitalDataByGeo set  
'
while @i <= 12
begin
	set @sql = @sql + 'UR3MGrowth' + cast(@i as varchar) + '=case when UR3M' + cast(@i+12 as varchar) + '=0 then null else UR3M'+ cast(@i as varchar) + '/UR3M' + cast(@i+12 as varchar) + ' end,
'
	set @sql = @sql + 'VR3MGrowth' + cast(@i as varchar) + '=case when VR3M' + cast(@i+12 as varchar) + '=0 then null else VR3M'+ cast(@i as varchar) + '/VR3M' + cast(@i+12 as varchar) + ' end,
'
	set @sql = @sql + 'PR3MGrowth' + cast(@i as varchar) + '=case when PR3M' + cast(@i+12 as varchar) + '=0 then null else PR3M'+ cast(@i as varchar) + '/PR3M' + cast(@i+12 as varchar) + ' end,
'
	set @sql = @sql + 'UMGrowth' + cast(@i as varchar) + '=case when UM' + cast(@i+12 as varchar) + '=0 then null else UM'+ cast(@i as varchar) + '/UM' + cast(@i+12 as varchar) + ' end,
'
	set @sql = @sql + 'VMGrowth' + cast(@i as varchar) + '=case when VM' + cast(@i+12 as varchar) + '=0 then null else VM'+ cast(@i as varchar) + '/VM' + cast(@i+12 as varchar) + ' end,
'
	set @sql = @sql + 'PMGrowth' + cast(@i as varchar) + '=case when PM' + cast(@i+12 as varchar) + '=0 then null else PM'+ cast(@i as varchar) + '/PM' + cast(@i+12 as varchar) + ' end,
'
	SET @i = @i + 1
END
SET @SQL = LEFT(@sql,len(@sql)-3)
exec(@sql)
GO



print('------------------------------------------------------
                   tempHospitalDataByTier
-------------------------------------------------------------')
if object_id(N'tempHospitalDataByTier',N'U') is not null
	drop table tempHospitalDataByTier
go
select a.*
into tempHospitalDataByTier
from tempHospitalDataByGeo a
inner join tblHospitalMaster b on a.cpa_id = b.id
where Lev ='Nat'
go

alter table tempHospitalDataByTier add
	UR3M1Rank int,
	VR3M1Rank int,
	PR3M1Rank int,
	UMATDSRANK INT,
	VMATDSRANK INT,
	PMATDSRANK INT
GO

UPDATE tempHospitalDataByTier SET UR3M1Rank = B.RANK
FROM tempHospitalDataByTier A
INNER JOIN (
	SELECT Product, Lev,GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,GEO, Mkt,Prod,Tier ORDER BY UR3M1 DESC) RANK
	FROM tempHospitalDataByTier
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByTier SET VR3M1Rank = B.RANK
FROM tempHospitalDataByTier A
INNER JOIN (
	SELECT Product, Lev,GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,GEO, Mkt,Prod,Tier ORDER BY VR3M1 DESC) RANK
	FROM tempHospitalDataByTier
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByTier SET PR3M1Rank = B.RANK
FROM tempHospitalDataByTier A
INNER JOIN (
	SELECT Product, Lev,GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,GEO, Mkt,Prod,Tier ORDER BY PR3M1 DESC) RANK
	FROM tempHospitalDataByTier
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO
--
UPDATE tempHospitalDataByTier SET UC3MRANK = B.RANK
FROM tempHospitalDataByTier A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,GEO, Mkt,Prod,Tier ORDER BY UR3M1 DESC) RANK
	FROM tempHospitalDataByTier
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByTier SET UYTDRANK = B.RANK
FROM tempHospitalDataByTier A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,GEO, Mkt,Prod,Tier ORDER BY UYTD DESC) RANK
	FROM tempHospitalDataByTier
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByTier SET UMATRANK = B.RANK
FROM tempHospitalDataByTier A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,GEO, Mkt,Prod,Tier ORDER BY UMAT1 DESC) RANK
	FROM tempHospitalDataByTier
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByTier SET UMATdsRANK = B.RANK
FROM tempHospitalDataByTier A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,GEO, Mkt,Prod,DataSource ORDER BY UMAT1 DESC) RANK
	FROM tempHospitalDataByTier
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO
--
UPDATE tempHospitalDataByTier SET VC3MRANK = B.RANK
FROM tempHospitalDataByTier A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,GEO, Mkt,Prod,Tier ORDER BY VR3M1 DESC) RANK
	FROM tempHospitalDataByTier
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByTier SET VYTDRANK = B.RANK
FROM tempHospitalDataByTier A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,GEO, Mkt,Prod,Tier ORDER BY VYTD DESC) RANK
	FROM tempHospitalDataByTier
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByTier SET VMATRANK = B.RANK
FROM tempHospitalDataByTier A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,GEO, Mkt,Prod,Tier ORDER BY VMAT1 DESC) RANK
	FROM tempHospitalDataByTier
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByTier SET VMATDSRANK = B.RANK
FROM tempHospitalDataByTier A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,GEO, Mkt,Prod,DataSource ORDER BY VMAT1 DESC) RANK
	FROM tempHospitalDataByTier
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO
--

UPDATE tempHospitalDataByTier SET PC3MRANK = B.RANK
FROM tempHospitalDataByTier A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,GEO, Mkt,Prod,Tier ORDER BY PR3M1 DESC) RANK
	FROM tempHospitalDataByTier
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByTier SET PYTDRANK = B.RANK
FROM tempHospitalDataByTier A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,GEO, Mkt,Prod,Tier ORDER BY PYTD DESC) RANK
	FROM tempHospitalDataByTier
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByTier SET PMATRANK = B.RANK
FROM tempHospitalDataByTier A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,GEO, Mkt,Prod,Tier ORDER BY PMAT1 DESC) RANK
	FROM tempHospitalDataByTier
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO

UPDATE tempHospitalDataByTier SET PMATDSRANK = B.RANK
FROM tempHospitalDataByTier A
INNER JOIN (
	SELECT Product, Lev,ParentGeo, GEO, Mkt,Prod, CPA_id, 
		ROW_NUMBER() OVER(PARTITION BY Product, Lev,GEO, Mkt,Prod,DataSource ORDER BY PMAT1 DESC) RANK
	FROM tempHospitalDataByTier
)B ON A.Product = B.Product AND A.Lev = B.Lev AND a.ParentGeo = b.ParentGeo and a.Geo = b.geo 
	and a.mkt =b.mkt and a.prod = b.prod and a.cpa_id = b.cpa_id
GO


EXEC P_EXTEND_TABLE 'tempHospitalDataByTier','UR3MShr',1,24
GO
EXEC P_EXTEND_TABLE 'tempHospitalDataByTier','VR3MShr',1,24
GO
EXEC P_EXTEND_TABLE 'tempHospitalDataByTier','PR3MShr',1,24
GO


declare @i int, @sql varchar(8000)
set @i = 1
set @sql = 'update tempHospitalDataByTier set
'
while @i <= 24
begin
	set @sql = @sql + 'UR3MShr' + cast(@i as varchar) + '=case when b.UR3M' + cast(@i as varchar) + '=0 then 0 else a.UR3M' + cast(@i as varchar) + '/b.UR3M' + cast(@i as varchar) + ' end,
'
	set @sql = @sql + 'VR3MShr' + cast(@i as varchar) + '=case when b.VR3M' + cast(@i as varchar) + '=0 then 0 else a.VR3M' + cast(@i as varchar) + '/b.VR3M' + cast(@i as varchar) + ' end,
'
	set @sql = @sql + 'PR3MShr' + cast(@i as varchar) + '=case when b.PR3M' + cast(@i as varchar) + '=0 then 0 else a.PR3M' + cast(@i as varchar) + '/b.PR3M' + cast(@i as varchar) + ' end,
'
	set @i = @i + 1
end
SET @SQL = LEFT(@SQL,LEN(@SQL)-3) +'
FROM tempHospitalDataByTier A
INNER JOIN (SELECT * FROM tempHospitalDataByTier WHERE PROD = ''000'') B ON
	A.Product = b.Product and a.Lev = b.Lev and a.ParentGeo = b.ParentGeo and a.Geo = b.Geo 
	and a.Mkt = b.Mkt and a.cpa_id = b.cpa_id
where a.Prod <> ''999'''
exec(@sql)
go





if object_id(N'tempHospitalRollupByTier',N'U') is not null
	drop table tempHospitalRollupByTier
go
select Product, Lev,Geo,ParentGeo,Mkt,Prod,Tier,
	sum(UM1) UM1,sum(UM2) UM2,sum(UM3) UM3,sum(UM4) UM4,sum(UM5) UM5,sum(UM6) UM6,sum(UM7) UM7,sum(UM8) UM8,sum(UM9) UM9,sum(UM10) UM10,sum(UM11) UM11,sum(UM12) UM12,sum(UM13) UM13,sum(UM14) UM14,sum(UM15) UM15,sum(UM16) UM16,sum(UM17) UM17,sum(UM18) UM18,sum(UM19) UM19,sum(UM20) UM20,sum(UM21) UM21,sum(UM22) UM22,sum(UM23) UM23,sum(UM24) UM24,
	sum(VM1) VM1,sum(VM2) VM2,sum(VM3) VM3,sum(VM4) VM4,sum(VM5) VM5,sum(VM6) VM6,sum(VM7) VM7,sum(VM8) VM8,sum(VM9) VM9,sum(VM10) VM10,sum(VM11) VM11,sum(VM12) VM12,sum(VM13) VM13,sum(VM14) VM14,sum(VM15) VM15,sum(VM16) VM16,sum(VM17) VM17,sum(VM18) VM18,sum(VM19) VM19,sum(VM20) VM20,sum(VM21) VM21,sum(VM22) VM22,sum(VM23) VM23,sum(VM24) VM24,
    sum(PM1) PM1,sum(PM2) PM2,sum(PM3) PM3,sum(PM4) PM4,sum(PM5) PM5,sum(PM6) PM6,sum(PM7) PM7,sum(PM8) PM8,sum(PM9) PM9,sum(PM10) PM10,sum(PM11) PM11,sum(PM12) PM12,sum(PM13) PM13,sum(PM14) PM14,sum(PM15) PM15,sum(PM16) PM16,sum(PM17) PM17,sum(PM18) PM18,sum(PM19) PM19,sum(PM20) PM20,sum(PM21) PM21,sum(PM22) PM22,sum(PM23) PM23,sum(PM24) PM24,

	sum(VR3M1) VR3M1,sum(VR3M2)VR3M2,sum(VR3M3) VR3M3,sum(VR3M4)VR3M4,sum(VR3M5)VR3M5,
	sum(VR3M6)VR3M6,sum(VR3M7)VR3M7,sum(VR3M8)VR3M8,sum(VR3M9)VR3M9,sum(VR3M10)VR3M10,sum(VR3M11)VR3M11,
	sum(VR3M12)VR3M12,sum(VR3M13)VR3M13,sum(VR3M14)VR3M14,sum(VR3M15)VR3M15,sum(VR3M16)VR3M16,
	sum(VR3M17)VR3M17,sum(VR3M18)VR3M18,sum(VR3M19)VR3M19,sum(VR3M20)VR3M20,sum(VR3M21)VR3M21,
	sum(VR3M22)VR3M22,sum(VR3M23)VR3M23,sum(VR3M24)VR3M24,

	sum(UR3M1) UR3M1,sum(UR3M2)UR3M2,sum(UR3M3) UR3M3,sum(UR3M4)UR3M4,sum(UR3M5)UR3M5,
	sum(UR3M6)UR3M6,sum(UR3M7)UR3M7,sum(UR3M8)UR3M8,sum(UR3M9)UR3M9,sum(UR3M10)UR3M10,sum(UR3M11)UR3M11,
	sum(UR3M12)UR3M12,sum(UR3M13)UR3M13,sum(UR3M14)UR3M14,sum(UR3M15)UR3M15,sum(UR3M16)UR3M16,
	sum(UR3M17)UR3M17,sum(UR3M18)UR3M18,sum(UR3M19)UR3M19,sum(UR3M20)UR3M20,sum(UR3M21)UR3M21,
	sum(UR3M22)UR3M22,sum(UR3M23)UR3M23,sum(UR3M24)UR3M24,

    sum(PR3M1) PR3M1,sum(PR3M2)PR3M2,sum(PR3M3) PR3M3,sum(PR3M4)PR3M4,sum(PR3M5)PR3M5,
	sum(PR3M6)PR3M6,sum(PR3M7)PR3M7,sum(PR3M8)PR3M8,sum(PR3M9)PR3M9,sum(PR3M10)PR3M10,sum(PR3M11)PR3M11,
	sum(PR3M12)PR3M12,sum(PR3M13)PR3M13,sum(PR3M14)PR3M14,sum(PR3M15)PR3M15,sum(PR3M16)PR3M16,
	sum(PR3M17)PR3M17,sum(PR3M18)PR3M18,sum(PR3M19)PR3M19,sum(PR3M20)PR3M20,sum(PR3M21)PR3M21,
	sum(PR3M22)PR3M22,sum(PR3M23)PR3M23,sum(PR3M24)PR3M24,

	sum(UYTD) UYTD,	sum(UYTDStly) UYTDStly,
    sum(VYTD) VYTD,	sum(VYTDStly) VYTDStly,
    sum(PYTD) PYTD,	sum(PYTDStly) PYTDStly,

	sum(UMAT1) UMAT1,  sum(UMAT2) UMAT2,sum(UMAT3) UMAT3,
    sum(VMAT1) VMAT1,  sum(VMAT2) VMAT2,sum(VMAT3) VMAT3,
    sum(PMAT1) PMAT1,  sum(PMAT2) PMAT2,sum(PMAT3) PMAT3
into tempHospitalRollupByTier
from tempHospitalDataByGeo a
Group by Product, Lev,Geo,ParentGeo,Mkt,Prod,Tier
go

-- Add Monthly Share columns
declare @sql varchar(8000),@i int
set @i = 1
set @sql = 'alter table tempHospitalRollupByTier add '
while @i <= 24
begin
	set @sql = @sql + 'UMS'+ cast(@i as varchar) + ' decimal(22,6),
'                   + 'VMS'+ cast(@i as varchar) + ' decimal(22,6),
'                   + 'PMS'+ cast(@i as varchar) + ' decimal(22,6),
'
	set @i = @i + 1
end
set @sql = left(@sql,len(@sql)-3)
exec (@sql)
go

-- Add Monthly Growth Columns
declare @sql varchar(8000),@i int
set @i = 1
set @sql = 'alter table tempHospitalRollupByTier add '
while @i <= 12
begin
	set @sql = @sql + 'UMG'+ cast(@i as varchar) + ' decimal(22,6), 
'                   + 'VMG'+ cast(@i as varchar) + ' decimal(22,6),
'                   + 'PMG'+ cast(@i as varchar) + ' decimal(22,6),
'
	set @i = @i + 1
end
set @sql = left(@sql,len(@sql)-3)
exec (@sql)
go

-- Add Rolling 3 Months Growth Columns
declare @sql varchar(8000),@i int
set @i = 1
set @sql = 'alter table tempHospitalRollupByTier add '
while @i <= 12
begin
	set @sql = @sql + 'UR3MG'+ cast(@i as varchar) + ' decimal(22,6), 
'                   + 'VR3MG'+ cast(@i as varchar) + ' decimal(22,6),
'                   + 'PR3MG'+ cast(@i as varchar) + ' decimal(22,6),
'
	set @i = @i + 1
end
set @sql = left(@sql,len(@sql)-3)
exec (@sql)
go

declare @sql varchar(3000), @i int
set @i = 1
set @sql = ''
while @i <= 24
begin
	set @sql = 'update tempHospitalRollupByTier set 
UMS' + cast(@i as varchar) + '=case when b.UM' + cast(@i as varchar) + '=0 then 0 else a.UM' + cast(@i as varchar) + '/b.UM' + cast(@i as varchar) + ' end,
VMS' + cast(@i as varchar) + '=case when b.VM' + cast(@i as varchar) + '=0 then 0 else a.VM' + cast(@i as varchar) + '/b.VM' + cast(@i as varchar) + ' end,
PMS' + cast(@i as varchar) + '=case when b.PM' + cast(@i as varchar) + '=0 then 0 else a.PM' + cast(@i as varchar) + '/b.PM' + cast(@i as varchar) + ' end
FROM tempHospitalRollupByTier A
INNER JOIN (SELECT * FROM tempHospitalRollupByTier B WHERE B.PROD = ''000'') B ON 
	A.Product=B.Product and a.Lev=b.Lev and a.Geo = b.Geo and a.Mkt = b.Mkt and a.Tier = b.Tier'
	exec(@sql)
	set @i = @i + 1
end 
go

declare @sql varchar(3000), @i int
set @i = 1
set @sql = ''
while @i <= 12
begin
	set @sql = 'update tempHospitalRollupByTier set 
UMG' + cast(@i as varchar) + '=case when UM' + cast(@i+12 as varchar) + '=0 then null else UM' + cast(@i as varchar) + '/UM' + cast(@i+12 as varchar) + '-1 end,
VMG' + cast(@i as varchar) + '=case when VM' + cast(@i+12 as varchar) + '=0 then null else VM' + cast(@i as varchar) + '/VM' + cast(@i+12 as varchar) + '-1 end,
PMG' + cast(@i as varchar) + '=case when PM' + cast(@i+12 as varchar) + '=0 then null else PM' + cast(@i as varchar) + '/PM' + cast(@i+12 as varchar) + '-1 end
'
	exec(@sql)
	set @i = @i + 1
end 
go

declare @sql varchar(3000), @i int
set @i = 1
set @sql = ''
while @i <= 12
begin
	set @sql = 'update tempHospitalRollupByTier set 
UR3MG' + cast(@i as varchar) + '=case when UR3M' + cast(@i+12 as varchar) + '=0 then null else UR3M' + cast(@i as varchar) + '/UR3M' + cast(@i+12 as varchar) + '-1 end,
VR3MG' + cast(@i as varchar) + '=case when VR3M' + cast(@i+12 as varchar) + '=0 then null else VR3M' + cast(@i as varchar) + '/VR3M' + cast(@i+12 as varchar) + '-1 end,
PR3MG' + cast(@i as varchar) + '=case when PR3M' + cast(@i+12 as varchar) + '=0 then null else PR3M' + cast(@i as varchar) + '/PR3M' + cast(@i+12 as varchar) + '-1 end
'
	exec(@sql)
	set @i = @i + 1
end 
go







print('------------------------------------------------------
                   OutputTopCPA
-------------------------------------------------------------')
if object_id(N'OutputTopCPA',N'U') is not null
	drop table OutputTopCPA
go
-- Region Top 10 Hospital ARV Market/NIAD Market/DPP-IV Market/Hypertension Market/Oncology Focused Brand Total Performance(YTD/Current 3 Months)
select cast('UC3M' as varchar(10)) AS RankSource,
	Product, Lev, ParentGeo,Geo, Mkt,Prod, CPA_id,uc3mrank as Rank
into OutputTopCPA
from dbo.tempHospitalDataByGeo 
where uc3mrank <= 10 --and Tier in('2','3')
go
insert into OutputTopCPA
select cast('VC3M' as varchar(10)) AS RankSource,
	Product, Lev, ParentGeo,Geo, Mkt,Prod, CPA_id,Vc3mrank as Rank
from dbo.tempHospitalDataByGeo 
where Vc3mrank <= 10  --and Tier in('2','3')
go
insert into OutputTopCPA
select cast('PC3M' as varchar(10)) AS RankSource,
	Product, Lev, ParentGeo,Geo, Mkt,Prod, CPA_id,PC3MRANK as Rank
from dbo.tempHospitalDataByGeo 
where PC3MRANK <= 10  --and Tier in('2','3')
go


insert into OutputTopCPA
select cast('UYTD' as varchar(10)) AS RankSource,
	Product, Lev, ParentGeo,Geo, Mkt,Prod, CPA_id,uYTDrank as Rank
from dbo.tempHospitalDataByGeo 
where UYTDrank <= 10  --and Tier in('2','3')
go
insert into OutputTopCPA
select cast('VYTD' as varchar(10)) AS RankSource,
	Product, Lev, ParentGeo,Geo, Mkt,Prod, CPA_id,VYTDrank as Rank
from dbo.tempHospitalDataByGeo 
where VYTDrank <= 10 --and Tier in('2','3')
go
insert into OutputTopCPA
select cast('PYTD' as varchar(10)) AS RankSource,
	Product, Lev, ParentGeo,Geo, Mkt,Prod, CPA_id,PYTDRANK as Rank
from dbo.tempHospitalDataByGeo 
where PYTDRANK <= 10 --and Tier in('2','3')
go
exec dbo.sp_Log_Event 'MID','CIA_CPA','2_1_MID.sql','End',null,null
