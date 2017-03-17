use BMSChinaMRBI_test
go
if object_id(N'inCPA_HYP_Data_Extract_eliquis','U') is not null
    drop table inCPA_HYP_Data_Extract_eliquis
GO  
select 
d.Region as Region,
c.Province as Province,
c.City as City,
a.Y as Y,
a.M as M,
a.CPA_Code as CPA_Code,
c.CPA_Name as CPA_Name,
a.Tier as Tier,
a.ATC_Code as ATC_Code,
a.Molecule as Molecule_CN,
a.Product as Product_CN,
b.prod_en as Product_EN,
a.Package as Package,
a.Specification as Specification,
a.Package_Num as Package_Num,
a.Value as Value,
a.Volume as Volume,
a.Form as Form,
a.Way as Way,
a.Manufacture as Manufacture,
case when e.BMS_Code <>'#N/A' then 'BMS'  else e.BMS_Code end CPA_type1,
h.[Eliquis hospital category] as CPA_type2,
g.Molecular as Molecular,
f.[BMS VTEP Market Brand level] as [BMS VTEP Market Brand level]
into inCPA_HYP_Data_Extract_eliquis
from db4.BMSChinaMRBI_test.dbo.inCPAData a join dbo.tblHospitalMaster c on a.cpa_id=c.id 
                   left join (select * from tblsalesregion where product='eliquis') d on d.city=c.city_en
                  left join dbo.[tblDefProduct_CN_EN] b on a.Product = b.prod_cn
				   left join tblHospitalMaster e
				   on a.cpa_code=e.cpa_code
				   left join Brand_level f
				   on a.Product=f.Product
				   left join Molecular g
				   on a.Molecule=g.Molecule_cn
				   left join BMS_CPA_Hosp_Category h
				   on a.cpa_code=h.[cpa code]
where a.product in (N'������',N'̩��ȫ',N'������')
--and Y = 2015 and M = 1

update a
set a.Region=b.Region
from inCPA_HYP_Data_Extract_eliquis a
join dbo.inCPA_Province_Region_Map_For_HYP_Data_Extract b
on a.province=b.province
where a.region is null

update inCPA_HYP_Data_Extract_eliquis
set Region='Other'
where region is null

GO

--update inCPA_HYP_Data_Extract_eliquis 
--set Region=case when Region ='East1' then 'E1'
--	  when Region ='East2' then 'E2'
--	  when Region ='North1' then 'N1'
--	  when Region ='North2' then 'N2'
--	  when Region ='Northwest' then 'NW'
--	  when Region ='South' then 'S'
--	  when Region ='Other' then 'Other'
--	  end

update inCPA_HYP_Data_Extract_eliquis set CPA_type2='#N/A' where CPA_type2 is null
update inCPA_HYP_Data_Extract_eliquis set [BMS VTEP Market Brand level]='' where [BMS VTEP Market Brand level] is null
select  * from inCPA_HYP_Data_Extract_eliquis --where Y= 2015
--where CPA_TYPE2 ='#N/A' AND CPA_TYPE1 <>'CPA_TYPE'
order by Y,M desc
