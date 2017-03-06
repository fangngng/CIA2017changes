
use BMSChinaMRBI

select c.Region,a.[cpa name] as Hospital,b.city_en as city,
case when d.CurrentRank>0 then convert(char(1),d.CurrentRank) else '' end as CurrentRank,
convert(int,isnull(e.[Coniel Last Year YTD]/7,0)) as [Coniel Last Year YTD],
convert(int,isnull(e.[Coniel YTD]/7,0)) as [Coniel YTD],
case when e.[Coniel GR] is null then '-' else convert(varchar(5),convert(int,e.[Coniel GR]*100))+'%' end as [Coniel GR],
case when e.[Coniel Share] is null then '-' else convert(varchar(5),convert(int,e.[Coniel Share]*100))+'%' end as [Coniel Share],

convert(int,isnull(f.[YUAN ZHI Last Year YTD]/7,0)) as [YUAN ZHI Last Year YTD],
convert(int,isnull(f.[YUAN ZHI YTD]/7,0)) as [YUAN ZHI YTD],
case when f.[YUAN ZHI GR] is null then '-' else convert(varchar(5),convert(int,f.[YUAN ZHI GR]*100))+'%' end as [YUAN ZHI GR],
case when f.[YUAN ZHI Share] is null then '-' else convert(varchar(5),convert(int,f.[YUAN ZHI Share]*100))+'%' end as [YUAN ZHI Share],


convert(int,isnull(g.[LACIPIL Last Year YTD]/7,0)) as [LACIPIL Last Year YTD],
convert(int,isnull(g.[LACIPIL YTD]/7,0)) as [LACIPIL YTD],
case when g.[LACIPIL GR] is null then '-' else convert(varchar(5),convert(int,g.[LACIPIL GR]*100))+'%' end as [LACIPIL GR],
case when g.[LACIPIL Share] is null then '-' else convert(varchar(5),convert(int,g.[LACIPIL Share]*100))+'%' end as [LACIPIL Share],

convert(int,isnull(h.[ZANIDIP Last Year YTD]/7,0)) as [ZANIDIP Last Year YTD],
convert(int,isnull(h.[ZANIDIP YTD]/7,0)) as [ZANIDIP YTD],
case when h.[ZANIDIP GR] is null then '-' else convert(varchar(5),convert(int,h.[ZANIDIP GR]*100))+'%' end as [ZANIDIP GR],
case when h.[ZANIDIP Share] is null then '-' else convert(varchar(5),convert(int,h.[ZANIDIP Share]*100))+'%' end as [ZANIDIP Share],


convert(int,isnull(i.[NORVASC Last Year YTD]/7,0)) as [NORVASC Last Year YTD],
convert(int,isnull(i.[NORVASC YTD]/7,0)) as [NORVASC YTD],
case when i.[NORVASC GR] is null then '-' else convert(varchar(5),convert(int,i.[NORVASC GR]*100))+'%' end as [NORVASC GR],
case when i.[NORVASC Share] is null then '-' else convert(varchar(5),convert(int,i.[NORVASC Share]*100))+'%' end as [NORVASC Share],

convert(int,isnull(j.[ADALAT Last Year YTD]/7,0)) as [ADALAT Last Year YTD],
convert(int,isnull(j.[ADALAT YTD]/7,0)) as [ADALAT YTD],
case when j.[ADALAT GR] is null then '-' else convert(varchar(5),convert(int,j.[ADALAT GR]*100))+'%' end as [ADALAT GR],
case when j.[ADALAT Share] is null then '-' else convert(varchar(5),convert(int,j.[ADALAT Share]*100))+'%' end as [ADALAT Share],

convert(int,isnull(k.[PLENDIL Last Year YTD]/7,0)) as [PLENDIL Last Year YTD],
convert(int,isnull(k.[PLENDIL YTD]/7,0)) as [PLENDIL YTD],
case when k.[PLENDIL GR] is null then '-' else convert(varchar(5),convert(int,k.[PLENDIL GR]*100))+'%' end as [PLENDIL GR],
case when k.[PLENDIL Share] is null then '-' else convert(varchar(5),convert(int,k.[PLENDIL Share]*100))+'%' end as [PLENDIL Share],


convert(int,isnull(l.[Total Last Year YTD]/7,0)) as [Total Last Year YTD],
convert(int,isnull(l.[Total YTD]/7,0)) as [Total YTD],
case when l.[Total GR] is null then '-' else convert(varchar(5),convert(int,l.[Total GR]*100))+'%' end as [Total GR]

----f.[Acertil Last Year YTD],f.[Acertil YTD],f.[Acertil GR],f.[Acertil Share],
--g.[Lotensin Last Year YTD],g.[Lotensin YTD],g.[Lotensin GR],g.[Lotensin Share],
--h.[Tritace Last Year YTD],h.[Tritace YTD],h.[Tritace GR],h.[Tritace Share],
--i.[ACEI YTD],i.[ACEI Last Year YTD],i.[ACEI GR]
from
(
		select distinct [cpa code],[cpa name] 
		from BMS_CPA_Hosp_Category 
		where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Coniel Hospital Category] ='Top100'

) a join tblHospitalMaster b on a.[cpa code]=b.cpa_code
left join (select distinct Region,city from tblSalesRegion where product='Coniel') c on b.city_en=c.city
left join (
	select cpa_id,prod,CurrentRank 
	from (
			select distinct Mkt,Prod,Cpa_id,UYTD,row_number()over(partition by cpa_id order by UYTD desc) as CUrrentRank
			from (
				select * from 
				tempHospitalData  
				where mkt='CCB' and prod in ('100','200','300','400','500','600','700') 
			) t1
		) t2 where t2.prod='100'			
)  d on d.cpa_id=b.id
left join (
	--Coniel
	select 
	t1.cpa_id,t1.UYTD as [Coniel YTD],t1.UYTDStly as [Coniel Last Year YTD ],
	case when t1.UYTDStly is null or t1.UYTDStly=0 then null else (t1.UYTD-t1.UYTDStly)/t1.UYTDStly end as [Coniel GR],
	case when t2.UYTD is null or t2.UYTD =0 then 0 else t1.UYTD/t2.UYTD end as [Coniel Share]
	from (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='CCB' and prod ='100'
		 ) t1 join (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='CCB' and prod ='000'
		 ) t2 on t1.cpa_id=t2.cpa_id
) e on e.cpa_id=b.id
left join (
	--YUAN ZHI
	select 
	t1.cpa_id,t1.UYTD as [YUAN ZHI YTD],t1.UYTDStly as [YUAN ZHI Last Year YTD ],
	case when t1.UYTDStly is null or t1.UYTDStly=0 then null else (t1.UYTD-t1.UYTDStly)/t1.UYTDStly end as [YUAN ZHI GR],
	case when t2.UYTD is null or t2.UYTD =0 then 0 else t1.UYTD/t2.UYTD end as [YUAN ZHI Share]
	from (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='CCB' and prod ='200'
		 ) t1 join (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='CCB' and prod ='000'
		 ) t2 on t1.cpa_id=t2.cpa_id
) f on f.cpa_id=b.id
left join (
	--LACIPIL
	select 
	t1.cpa_id,t1.UYTD as [LACIPIL YTD],t1.UYTDStly as [LACIPIL Last Year YTD ],
	case when t1.UYTDStly is null or t1.UYTDStly=0 then null else (t1.UYTD-t1.UYTDStly)/t1.UYTDStly end as [LACIPIL GR],
	case when t2.UYTD is null or t2.UYTD =0 then 0 else t1.UYTD/t2.UYTD end as [LACIPIL Share]
	from (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='CCB' and prod ='300'
		 ) t1 join (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='CCB' and prod ='000'
		 ) t2 on t1.cpa_id=t2.cpa_id
) g on g.cpa_id=b.id
left join (
	--ZANIDIP
	select 
	t1.cpa_id,t1.UYTD as [ZANIDIP YTD],t1.UYTDStly as [ZANIDIP Last Year YTD ],
	case when t1.UYTDStly is null or t1.UYTDStly=0 then null else (t1.UYTD-t1.UYTDStly)/t1.UYTDStly end as [ZANIDIP GR],
	case when t2.UYTD is null or t2.UYTD =0 then 0 else t1.UYTD/t2.UYTD end as [ZANIDIP Share]
	from (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='CCB' and prod ='400'
		 ) t1 join (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='CCB' and prod ='000'
		 ) t2 on t1.cpa_id=t2.cpa_id
) h on h.cpa_id=b.id

left join (
	--NORVASC
	select 
	t1.cpa_id,t1.UYTD as [NORVASC YTD],t1.UYTDStly as [NORVASC Last Year YTD ],
	case when t1.UYTDStly is null or t1.UYTDStly=0 then null else (t1.UYTD-t1.UYTDStly)/t1.UYTDStly end as [NORVASC GR],
	case when t2.UYTD is null or t2.UYTD =0 then 0 else t1.UYTD/t2.UYTD end as [NORVASC Share]
	from (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='CCB' and prod ='500'
		 ) t1 join (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='CCB' and prod ='000'
		 ) t2 on t1.cpa_id=t2.cpa_id
) i on i.cpa_id=b.id
left join (
	--ADALAT
	select 
	t1.cpa_id,t1.UYTD as [ADALAT YTD],t1.UYTDStly as [ADALAT Last Year YTD ],
	case when t1.UYTDStly is null or t1.UYTDStly=0 then null else (t1.UYTD-t1.UYTDStly)/t1.UYTDStly end as [ADALAT GR],
	case when t2.UYTD is null or t2.UYTD =0 then 0 else t1.UYTD/t2.UYTD end as [ADALAT Share]
	from (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='CCB' and prod ='600'
		 ) t1 join (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='CCB' and prod ='000'
		 ) t2 on t1.cpa_id=t2.cpa_id
) j on j.cpa_id=b.id
left join (
	--PLENDIL
	select 
	t1.cpa_id,t1.UYTD as [PLENDIL YTD],t1.UYTDStly as [PLENDIL Last Year YTD ],
	case when t1.UYTDStly is null or t1.UYTDStly=0 then null else (t1.UYTD-t1.UYTDStly)/t1.UYTDStly end as [PLENDIL GR],
	case when t2.UYTD is null or t2.UYTD =0 then 0 else t1.UYTD/t2.UYTD end as [PLENDIL Share]
	from (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='CCB' and prod ='700'
		 ) t1 join (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='CCB' and prod ='000'
		 ) t2 on t1.cpa_id=t2.cpa_id
) k on k.cpa_id=b.id
left join (
	--Total
	select distinct cpa_id,'' prod,sum(UYTD) as [Total YTD] ,sum(UYTDStly) as [Total Last Year YTD],
		case when sum(UYTDStly) is null or sum(UYTDStly) =0 then null else (sum(UYTD)-sum(UYTDStly))/sum(UYTDStly) end as [Total GR]
	from tempHospitalData  
	where mkt='CCB' and prod in ('100','200','300','400','500','600','700') 
	group by cpa_id
)l on l.cpa_id=b.id
order by region
