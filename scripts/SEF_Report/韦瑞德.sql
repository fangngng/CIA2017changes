
select 
   'CPA' as DataSource
 , c.Mkt
 , c.Prod
 , a.cpa_id
 , a.Tier
 , sum(Value*(case when c.prod_des_en='VIREAD' then 0.73 else 1 end))  as Sales
 , sum(Volume*(case when c.prod_des_en='VIREAD' then 0.73 else 1 end)) as Units
 , sum(Volume*cast(subString(Specification,1,charindex(' ',Specification)) as float)/AvgPatientMG) as Adjusted_PatientNumber

--

select *
from inCPAData a
inner join tblMktDefHospital_Baraclude_CPA_KPIFrame c                                     
on a.Molecule = c.Mole_Des_CN and a.Product = c.Prod_Des_CN-- and c.molecule='N'
where exists(
            select * from tblHospitalMaster b 
            where a.cpa_id = b.id and b.DataSource = 'CPA'
            ) and y=2016 and prod=800 and cpa_code='430031' and a.product=N'Î¤ÈðµÂ'
			
			--and prod<>000 and prod not like '0%'   and cpa_code='430031'
group by c.Mkt,c.Prod,a.cpa_id, a.Tier


select sum(value),product from incpadata where y = '2016' and molecule in (N'À­Ã×·ò¶¨',N'°¢µÂ¸£Î¤õ¥',N'¶÷Ìæ¿¨Î¤',N'ÌæÅµ¸£Î¤¶þßÁß»õ¥',N'Ìæ±È·ò¶¨')
 and cpa_code='430031'
 group by product