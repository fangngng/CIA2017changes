--select  a.ParentGeo as Region,d.[cpa name] as Hospital,a.Geo as City,c.productName,a.UYTD,a.UYTDStly,a.UYTDGrowth,UYTDShare
--from
--(
--	select distinct Product,Lev,ParentGeo,Geo,DataSource,Mkt,Prod,Cpa_id,
--	convert(int,UYTD/14) as UYTD,convert(int,UYTDStly/14) as UYTDStly,UYTDGrowth,UYTDShare
--	from tempHospitalDataByGeo 
--	where mkt='HYP' and prod in ('910','100','200','700','800') and Lev='City'
--)a join tblHospitalMaster b on a.cpa_id=b.id
--join (select distinct mkt,prod,productname from dbo.tblMktDefHospital) c on a.mkt=c.mkt and a.prod=c.prod
--join (
--		select distinct [cpa name] 
--		from BMS_CPA_Hosp_Category 
--		where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Monopril Hospital Category] ='TOP110'
--) d on d.[cpa name]=b.cpa_name



----------------------------------------------
--172.20.0.4
use BMSChinaMRBI

select c.Region,a.[cpa name] as Hospital,b.city_en as city,d.CurrentRank as CurrentRank,
convert(int,isnull(e.[Monopril Last Year YTD]/14,0)) as [Monopril Last Year YTD],
convert(int,isnull(e.[Monopril YTD]/14,0)) as [Monopril YTD],
case when e.[Monopril GR] is null then '-' else convert(varchar(5),convert(int,e.[Monopril GR]*100))+'%' end as [Monopril GR],
case when e.[Monopril Share] is null then '-' else convert(varchar(5),convert(int,e.[Monopril Share]*100))+'%' end as [Monopril Share],

convert(int,isnull(f.[Acertil Last Year YTD]/14,0)) as [Acertil Last Year YTD],
convert(int,isnull(f.[Acertil YTD]/14,0)) as [Acertil YTD],
case when f.[Acertil GR] is null then '-' else convert(varchar(5),convert(int,f.[Acertil GR]*100))+'%' end as [Acertil GR],
case when f.[Acertil Share] is null then '-' else convert(varchar(5),convert(int,f.[Acertil Share]*100))+'%' end as [Acertil Share],


convert(int,isnull(g.[Lotensin Last Year YTD]/14,0)) as [Lotensin Last Year YTD],
convert(int,isnull(g.[Lotensin YTD]/14,0)) as [Lotensin YTD],
case when g.[Lotensin GR] is null then '-' else convert(varchar(5),convert(int,g.[Lotensin GR]*100))+'%' end as [Lotensin GR],
case when g.[Lotensin Share] is null then '-' else convert(varchar(5),convert(int,g.[Lotensin Share]*100))+'%' end as [Lotensin Share],

convert(int,isnull(h.[Tritace Last Year YTD]/14,0)) as [Tritace Last Year YTD],
convert(int,isnull(h.[Tritace YTD]/14,0)) as [Tritace YTD],
case when h.[Tritace GR] is null then '-' else convert(varchar(5),convert(int,h.[Tritace GR]*100))+'%' end as [Tritace GR],
case when h.[Tritace Share] is null then '-' else convert(varchar(5),convert(int,h.[Tritace Share]*100))+'%' end as [Tritace Share],

convert(int,isnull(i.[ACEI Last Year YTD]/14,0)) as [ACEI Last Year YTD],
convert(int,isnull(i.[ACEI YTD]/14,0)) as [ACEI YTD],
case when i.[ACEI GR] is null then '-' else convert(varchar(5),convert(int,i.[ACEI GR]*100))+'%' end as [ACEI GR]

----f.[Acertil Last Year YTD],f.[Acertil YTD],f.[Acertil GR],f.[Acertil Share],
--g.[Lotensin Last Year YTD],g.[Lotensin YTD],g.[Lotensin GR],g.[Lotensin Share],
--h.[Tritace Last Year YTD],h.[Tritace YTD],h.[Tritace GR],h.[Tritace Share],
--i.[ACEI YTD],i.[ACEI Last Year YTD],i.[ACEI GR]
from
(
		select distinct [cpa code],[cpa name] 
		from BMS_CPA_Hosp_Category 
		where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Monopril Hospital Category] ='Top100'
		union
		select '150031',N'哈尔滨医大第二附属医院'
) a join tblHospitalMaster b on a.[cpa code]=b.cpa_code
left join (select distinct Region,city from tblSalesRegion where product='Monopril') c on b.city_en=c.city
left join (
	select cpa_id,prod,CurrentRank 
	from (
			select distinct Mkt,Prod,Cpa_id,UYTD,row_number()over(partition by cpa_id order by UYTD desc) as CUrrentRank
			from (
				select * from 
				tempHospitalData  
				where mkt='HYPFCS' and prod in ('100','200','700','800') 
			) t1
		) t2 where t2.prod='100'			
)  d on d.cpa_id=b.id
left join (
	--monopril
	select 
	t1.cpa_id,t1.UYTD as [Monopril YTD],t1.UYTDStly as [Monopril Last Year YTD ],
	case when t1.UYTDStly is null or t1.UYTDStly=0 then null else (t1.UYTD-t1.UYTDStly)/t1.UYTDStly end as [Monopril GR],
	case when t2.UYTD is null or t2.UYTD =0 then 0 else t1.UYTD/t2.UYTD end as [Monopril Share]
	from (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='HYPFCS' and prod ='100'
		 ) t1 join (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='HYPFCS' and prod ='000'
		 ) t2 on t1.cpa_id=t2.cpa_id
) e on e.cpa_id=b.id
left join (
	--Acertil
	select 
	t1.cpa_id,t1.UYTD as [Acertil YTD],t1.UYTDStly as [Acertil Last Year YTD ],
	case when t1.UYTDStly is null or t1.UYTDStly=0 then null else (t1.UYTD-t1.UYTDStly)/t1.UYTDStly end as [Acertil GR],
	case when t2.UYTD is null or t2.UYTD =0 then 0 else t1.UYTD/t2.UYTD end as [Acertil Share]
	from (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='HYPFCS' and prod ='200'
		 ) t1 join (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='HYPFCS' and prod ='000'
		 ) t2 on t1.cpa_id=t2.cpa_id
) f on f.cpa_id=b.id
left join (
	--Lotensin
	select 
	t1.cpa_id,t1.UYTD as [Lotensin YTD],t1.UYTDStly as [Lotensin Last Year YTD ],
	case when t1.UYTDStly is null or t1.UYTDStly=0 then null else (t1.UYTD-t1.UYTDStly)/t1.UYTDStly end as [Lotensin GR],
	case when t2.UYTD is null or t2.UYTD =0 then 0 else t1.UYTD/t2.UYTD end as [Lotensin Share]
	from (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='HYPFCS' and prod ='700'
		 ) t1 join (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='HYPFCS' and prod ='000'
		 ) t2 on t1.cpa_id=t2.cpa_id
) g on g.cpa_id=b.id
left join (
	--Tritace
	select 
	t1.cpa_id,t1.UYTD as [Tritace YTD],t1.UYTDStly as [Tritace Last Year YTD ],
	case when t1.UYTDStly is null or t1.UYTDStly=0 then null else (t1.UYTD-t1.UYTDStly)/t1.UYTDStly end as [Tritace GR],
	case when t2.UYTD is null or t2.UYTD =0 then 0 else t1.UYTD/t2.UYTD end as [Tritace Share]
	from (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='HYPFCS' and prod ='800'
		 ) t1 join (
			select distinct cpa_id,prod,UYTD,UYTDStly 
			from tempHospitalData  
			where mkt='HYPFCS' and prod ='000'
		 ) t2 on t1.cpa_id=t2.cpa_id
) h on h.cpa_id=b.id
left join (
	--ACEI
	select distinct cpa_id,'910'prod,sum(UYTD) as [ACEI YTD] ,sum(UYTDStly) as [ACEI Last Year YTD],
		case when sum(UYTDStly) is null or sum(UYTDStly) =0 then null else (sum(UYTD)-sum(UYTDStly))/sum(UYTDStly) end as [ACEI GR]
	from tempHospitalData  
	where mkt='HYP' and prod in ('100','200','700','800')
	group by cpa_id
)i on i.cpa_id=b.id
order by region
/*

prod	productname
100	Monopril
200	Acertil
700	Lotensin
800	Tritace
910	ACEI

*/

--select distinct prod,productname from dbo.tblMktDefHospital where Mkt='HYP' and prod in ('910','100','200','700','800') 