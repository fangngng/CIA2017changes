use BMSChinaMRBI
go
if object_id(N'tempHospitalData_For_TOP110_Eliquis',N'U') is not null
	drop table tempHospitalData_For_TOP110_Eliquis
select DataSource,Mkt,Prod,Cpa_Id,Tier,UYTD,UYTDStly
	--case when prod='300' then 1.0*0.6*UYTD else UYTD end as UYTD,
	--case when prod='300' then 1.0*0.6*UYTDStly else UYTDStly end as UYTDStly
into tempHospitalData_For_TOP110_Eliquis
from tempHospitalData where mkt='Eliquis VTEP' and prod <>'000'

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
