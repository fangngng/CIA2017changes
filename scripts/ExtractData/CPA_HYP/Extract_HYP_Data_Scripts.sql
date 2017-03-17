use BMSChinaMRBI_test
go
if object_id(N'inCPA_HYP_Data_Extract','U') is not null
	drop table inCPA_HYP_Data_Extract
GO	
select 
	convert(nvarchar(255),
	case when d.Region ='East1' then 'E1'
		  when d.Region ='East2' then 'E2'
		  when d.Region ='North1' then 'N1'
		  when d.Region ='North2' then 'N2'
		  when d.Region ='Northwest' then 'NW'
		  when d.Region ='South' then 'S'
		  when d.Region ='Other' then 'Other'
		  end
	) as Region,
	convert(nvarchar(255),c.Province) as Province,
	convert(nvarchar(255),c.City) as City,
	convert(nvarchar(255),a.Y) as Y,
	convert(nvarchar(255),a.M) as M,
	convert(nvarchar(255),a.CPA_Code) as CPA_Code,
	convert(nvarchar(255),c.CPA_Name) as CPA_Name,
	convert(nvarchar(255),a.Tier) as Tier,
	convert(nvarchar(255),a.ATC_Code) as ATC_Code,
	convert(nvarchar(255),a.Molecule) as Molecule,
	convert(nvarchar(255),a.Product) as Product,
	convert(nvarchar(255),b.prod_en) as Product_EN,
	convert(nvarchar(255),a.Package) as Package,
	convert(nvarchar(255),a.Specification) as Specification,
	convert(nvarchar(255),a.Package_Num) as Package_Num,
	a.Value as Value,
	a.Volume as Volume,
	convert(nvarchar(255),a.Form) as Form,
	convert(nvarchar(255),a.Way) as Way,
	convert(nvarchar(255),a.Manufacture) as Manufacture
into inCPA_HYP_Data_Extract
from dbo.inCPAData a join dbo.tblHospitalMaster c on a.cpa_id=c.id 
                   left join (select * from tblsalesregion where product='monopril') d on d.city=c.city_en
                  left join dbo.[tblDefProduct_CN_EN] b on a.Product = b.prod_cn
where (substring(a.ATC_Code,1,3) in ('C02','C03','C07','C08','C09') or a.molecule=N'������ƽ')

update a
set a.Region=case when b.Region ='East1' then 'E1'
				  when b.Region ='East2' then 'E2'
				  when b.Region ='North1' then 'N1'
				  when b.Region ='North2' then 'N2'
				  when b.Region ='Northwest' then 'NW'
				  when b.Region ='South' then 'S'
				  when b.Region ='Other' then 'Other'
				  end
from inCPA_HYP_Data_Extract a
join dbo.inCPA_Province_Region_Map_For_HYP_Data_Extract b
on a.province=b.province
where a.region is null

update inCPA_HYP_Data_Extract
set Region='Other'
where region is null

--select top 1 *
--from inCPA_HYP_Data_Extract --where region='other'

select * from inCPA_HYP_Data_Extract