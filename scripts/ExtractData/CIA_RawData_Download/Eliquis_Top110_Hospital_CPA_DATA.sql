use BMSChinaMRBI_test
go
--3:13


----------------------------统计没有乘上系数的temp表
--将源数据统计到 Prod
print('------------------------------------------------------
                   tempHospitalDataByMth_NoRat
-------------------------------------------------------------')
if object_id(N'tempHospitalDataByMth_NoRat',N'U') is not null
  drop table tempHospitalDataByMth_NoRat
GO
--1. CPA :
select 
   	'CPA' as DataSource
	, c.Mkt
	, c.Prod
	, a.cpa_id
	, a.Tier
	, convert(varchar(6),convert(Datetime,a.M+'/1/'+Y,101),112) as Mth
	, sum(Value*1)  as Sales
	, sum(Volume*1) as Units
	, sum(Volume*cast(subString(Specification,1,charindex(' ',Specification)) as float)/AvgPatientMG) as Adjusted_PatientNumber
into tempHospitalDataByMth_NoRat
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
insert into tempHospitalDataByMth_NoRat
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
insert into tempHospitalDataByMth_NoRat
select 'Sea' as DataSource, c.Mkt,c.Prod,a.cpa_id,a.Tier,
	a.YM as Mth, sum(isnull(Value*1,0)) Sales, sum(isnull(Volume*1,0)) Units
	,null
from inSeaRainbowData a
inner join tblMktDefHospital c on 
	a.Molecule = c.Mole_Des_CN and
	a.Product = c.Prod_Des_CN
where exists(select * from dbo.tblHospitalMaster b where b.DataSource = 'Sea' and	b.id = a.cpa_id)
	
	and  a.Molecule not in (N'卡铂',N'顺铂',N'奈达铂')
group by c.Mkt,c.Prod,a.cpa_id,a.Tier,a.YM
go
insert into tempHospitalDataByMth_NoRat
select 'Sea' as DataSource, c.Mkt,c.Prod,a.cpa_id,a.Tier,
	a.YM as Mth, sum(isnull(Value*1,0)) Sales, sum(isnull(Volume*1,0)) Units
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
insert into tempHospitalDataByMth_NoRat
select 'Sea' as DataSource, 'All' Mkt,'999' Prod,a.cpa_id, a.Tier,
	a.YM as Mth,sum(isnull(Value,0)) Sales, sum(isnull(Volume,0)) Units
	,null
from inSeaRainbowData a
where exists(select * from dbo.tblHospitalMaster b where b.DataSource = 'Sea' and b.id = a.cpa_id)
	and  a.Molecule not in (N'卡铂',N'顺铂',N'奈达铂') 
group by a.cpa_id, a.Tier,a.YM
go
insert into tempHospitalDataByMth_NoRat
select 'Sea' as DataSource, 'All' Mkt,'999' Prod,a.cpa_id, a.Tier,
	a.YM as Mth,sum(isnull(Value,0)) Sales, sum(isnull(Volume,0)) Units
	, sum(Volume*cast(subString(Specification,1,charindex(' ',Specification)) as float)/AvgPatientMG) as Adjusted_PatientNumber
from inSeaRainbowData a
where exists(select * from dbo.tblHospitalMaster b where b.DataSource = 'Sea' and b.id = a.cpa_id)
	and  a.Molecule  in (N'卡铂',N'顺铂',N'奈达铂') 
group by a.cpa_id, a.Tier,a.YM
go


--3. PHA :
insert into tempHospitalDataByMth_NoRat
select 
	'PHA' as DataSource
	, c.Mkt
	, c.Prod
	, a.cpa_id
	, a.Tier
	, convert(varchar(6),convert(Datetime,a.M+'/1/'+Y,101),112) as Mth
	, sum(Value*1)  as Sales
	, sum(Volume*1) as Units
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
insert into tempHospitalDataByMth_NoRat
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




  
-- select top 100 * from tempHospitalDataByMth_NoRat

update tempHospitalDataByMth_NoRat set Adjusted_PatientNumber = 0 where Adjusted_PatientNumber is null
GO



--进行行列转置
print('------------------------------------------------------
                   tempHospitalData_NoRat
-------------------------------------------------------------')
if object_id(N'tempHospitalData_NoRat',N'U') is not null
	drop table tempHospitalData_NoRat
go
select distinct DataSource,Mkt,Prod,Cpa_id,Tier
into tempHospitalData_NoRat
from tempHospitalDataByMth_NoRat
go

create nonclustered index idx on tempHospitalData_NoRat(cpa_id)
go

declare @i int, @sql varchar(8000)
set @sql = 'alter table tempHospitalData_NoRat add
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
		'update tempHospitalData_NoRat set 
		UM' + cast(@i as varchar) + '=b.Units
		,VM' + cast(@i as varchar) + '=b.Sales
		,PM' + cast(@i as varchar) + '=b.Adjusted_PatientNumber
		from tempHospitalData_NoRat a
		inner join tempHospitalDataByMth_NoRat b on a.Mkt = b.Mkt and a.Prod = b.Prod and a.cpa_id = b.cpa_id
		where b.Mth = (select Mth from tblHospitalMthList where idx = ' + cast(@i as varchar) + ')
'
	exec (@sql)
	set @i = @i + 1
end 
go


  --Rollup到YTD,MAT
alter table tempHospitalData_NoRat add
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
UPDATE tempHospitalData_NoRat SET
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

EXEC P_EXTEND_TABLE 'tempHospitalData_NoRat','UR3M',1,24, 'DECIMAL(22,6)'
GO
EXEC P_EXTEND_TABLE 'tempHospitalData_NoRat','VR3M',1,24, 'DECIMAL(22,6)'
GO
EXEC P_EXTEND_TABLE 'tempHospitalData_NoRat','PR3M',1,24, 'DECIMAL(22,6)'
GO



DECLARE @I INT,@sql varchar(8000)
declare @st int, @ed int
set @i = 1
set @sql = 'update tempHospitalData_NoRat set
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
delete from tempHospitalData_NoRat where mkt='Eliquis VTEp' and prod in (500,600)
--delete from tempHospitalData_NoRat where mkt='CCB'
go

------------------------------------
if object_id(N'tempHospitalData_For_TOP110_Eliquis',N'U') is not null
	drop table tempHospitalData_For_TOP110_Eliquis
select DataSource,Mkt,Prod,Cpa_Id,Tier,UYTD,UYTDStly
	--case when prod='300' then 1.0*0.6*UYTD else UYTD end as UYTD,
	--case when prod='300' then 1.0*0.6*UYTDStly else UYTDStly end as UYTDStly
into tempHospitalData_For_TOP110_Eliquis
from tempHospitalData_NoRat where mkt='Eliquis VTEP' and prod <>'000'

--select * from tempHospitalData_For_TOP110_Eliquis
insert into tempHospitalData_For_TOP110_Eliquis(DataSource,Mkt,Prod,Cpa_ID,Tier,UYTD,UYTDStly)
select DataSource,Mkt,'000',Cpa_ID,Tier,sum(UYTD) as UYTD,sum(UYTDStly) as UYTDStly
from tempHospitalData_For_TOP110_Eliquis
where prod in ('100','300')
group by DataSource,Mkt,Cpa_ID,Tier


----------------------------------------------
select c.Region,a.[cpa name] as Hospital,b.city_en as city,case when d.CurrentRank>0 then convert(char(1),d.CurrentRank) else '' end as CurrentRank,
convert(int,isnull(e.[Eliquis Last Year YTD]/10,0)) as [Eliquis Last Year YTD],
convert(int,isnull(e.[Eliquis YTD]/10,0)) as [Eliquis YTD],
case when e.[Eliquis GR] is null then '-' else convert(varchar(5),convert(int,round(e.[Eliquis GR],2)*100))+'%' end as [Eliquis GR],
case when e.[Eliquis Share] is null then '-' else convert(varchar(5),convert(int,round(e.[Eliquis Share],2)*100))+'%' end as [Eliquis Share],

convert(int,isnull(f.[Xarelto Last Year YTD]/5,0)) as [Xarelto Last Year YTD],
convert(int,isnull(f.[Xarelto YTD]/5,0)) as [Xarelto YTD],
case when f.[Xarelto GR] is null then '-' else convert(varchar(5),convert(int,round(f.[Xarelto GR],2)*100))+'%' end as [Xarelto GR],
case when f.[Xarelto Share] is null then '-' else convert(varchar(5),convert(int,round(f.[Xarelto Share],2)*100))+'%' end as [Xarelto Share],

convert(int,isnull(i.[Total Last Year YTD],0)) as [Total Last Year YTD],
convert(int,isnull(i.[Total YTD],0)) as [Total YTD],
case when i.[Total GR] is null then '-' else convert(varchar(5),convert(int,round(i.[Total GR],2)*100))+'%' end as [Total GR]

----f.[Xarelto Last Year YTD],f.[Xarelto YTD],f.[Xarelto GR],f.[Xarelto Share],
--g.[Lotensin Last Year YTD],g.[Lotensin YTD],g.[Lotensin GR],g.[Lotensin Share],
--h.[Tritace Last Year YTD],h.[Tritace YTD],h.[Tritace GR],h.[Tritace Share],
--i.[Total YTD],i.[Total Last Year YTD],i.[Total GR]
from
(
		select distinct [cpa code],[cpa name] 
		from BMS_CPA_Hosp_Category 
		where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Eliquis Hospital Category] ='TOP'
) a join tblHospitalMaster b on a.[cpa code]=b.cpa_code
left join (select distinct Region,city from tblSalesRegion where product='Eliquis') c on b.city_en=c.city
left join (
	select cpa_id,prod,CurrentRank 
	from (
			select distinct Mkt,Prod,Cpa_id,UYTD,row_number()over(partition by cpa_id order by UYTD desc) as CUrrentRank
			from (
				select * from 
				tempHospitalData_For_TOP110_Eliquis  
				where mkt='Eliquis VTEP' and prod in ('100','300') 
			) t1
		) t2 where t2.prod='100'			
)  d on d.cpa_id=b.id
left join (
	--Eliquis
	select 
	t1.cpa_id,t1.UYTD as [Eliquis YTD],t1.UYTDStly as [Eliquis Last Year YTD ],
	case when t1.UYTDStly is null or t1.UYTDStly=0 then null else (t1.UYTD-t1.UYTDStly)/t1.UYTDStly end as [Eliquis GR],
	case when t2.UYTD is null or t2.UYTD =0 then 0 else t1.UYTD/t2.UYTD end as [Eliquis Share]
	from (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData_For_TOP110_Eliquis  
			where mkt='Eliquis VTEP' and prod ='100'
		 ) t1 join (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData_For_TOP110_Eliquis  
			where mkt='Eliquis VTEP' and prod ='000'
		 ) t2 on t1.cpa_id=t2.cpa_id
) e on e.cpa_id=b.id
left join (
	--Xarelto
	select 
	t1.cpa_id,t1.UYTD as [Xarelto YTD],t1.UYTDStly as [Xarelto Last Year YTD ],
	case when t1.UYTDStly is null or t1.UYTDStly=0 then null else (t1.UYTD-t1.UYTDStly)/t1.UYTDStly end as [Xarelto GR],
	case when t2.UYTD is null or t2.UYTD =0 then 0 else t1.UYTD/t2.UYTD end as [Xarelto Share]
	from (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData_For_TOP110_Eliquis  
			where mkt='Eliquis VTEP' and prod ='300'
		 ) t1 join (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData_For_TOP110_Eliquis  
			where mkt='Eliquis VTEP' and prod ='000'
		 ) t2 on t1.cpa_id=t2.cpa_id
) f on f.cpa_id=b.id
left join (
	--Total
	select distinct cpa_id,'' prod,sum(UYTD) as [Total YTD] ,sum(UYTDStly) as [Total Last Year YTD],
		case when sum(UYTDStly) is null or sum(UYTDStly) =0 then null else (sum(UYTD)-sum(UYTDStly))/sum(UYTDStly) end as [Total GR]
	from (
		select DataSource,Mkt,Prod,cpa_id,tier, 
		1.0*UYTD/( case when prod='100' then 10 when prod='300' then 5 end) as UYTD,
		1.0*UYTDStly/( case when prod='100' then 10 when prod='300' then 5 end) as UYTDStly
		from tempHospitalData_For_TOP110_Eliquis  where mkt='Eliquis VTEP' and prod in ('100','300')
	) a
	group by cpa_id
	--select distinct cpa_id,'' prod,sum(UYTD) as [ACEI YTD] ,sum(UYTDStly) as [ACEI Last Year YTD],
	--	case when sum(UYTDStly) is null or sum(UYTDStly) =0 then null else (sum(UYTD)-sum(UYTDStly))/sum(UYTDStly) end as [ACEI GR]
	--from (
	--	select cpa_id,
	--		   case when prod='300' then 1.0*0.6*UYTD else UYTD end as UYTD,
	--		   case when prod='300' then 1.0*0.6*UYTDStly else UYTDStly end as UYTDStly
	--	from tempHospitalData_For_TOP110_Eliquis  
	--	where mkt='Eliquis' and prod in ('100','300')
	--) a
	--group by cpa_id
	
)i on i.cpa_id=b.id
order by region
