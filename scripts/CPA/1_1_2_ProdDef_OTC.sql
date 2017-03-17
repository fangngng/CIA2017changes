use BMSChinaMRBI_test
GO
--select distinct prod_des,prod_cod
--from BMSChinaCIA_IMS.dbo.tblMktDef_ATCDriver 
--where prod_des in (
--	'Contac NT',
--	'21-Super Vita',
--	'Centrum',
--	'Centrum Silver',
--	'Gold Theragran',
--	'Bufferin Cold',
--	'White & Black',
--	'Tylenol'
--) order by prod_des

--select * into tblDefMolecule_CN_EN_OTC from tblDefMolecule_CN_EN where 0=1
--select * into tblDefProduct_CN_EN_OTC from tblDefProduct_CN_EN where 0=1 order by mole_cn
--Molecule CN&EN
truncate table tblDefMolecule_CN_EN_OTC

insert into tblDefMolecule_CN_EN_OTC(Mole_Code,Mole_EN,Mole_CN)
values(null,'Pseudoephedrine hydrochloride mixture',N'复方盐酸伪麻黄碱')

insert into tblDefMolecule_CN_EN_OTC(Mole_Code,Mole_EN,Mole_CN)
values (null,'Pseudoephedrine hydrochloride mixture',N'复方麻黄碱')
	  
insert into tblDefMolecule_CN_EN_OTC(Mole_Code,Mole_EN,Mole_CN)
values (null,'Multiple vitamin',N'多维元素')

insert into tblDefMolecule_CN_EN_OTC(Mole_Code,Mole_EN,Mole_CN)
values  (null,'CPH&CDH',N'氨酚伪麻美芬片/氨麻美敏片Ⅱ')

insert into tblDefMolecule_CN_EN_OTC(Mole_Code,Mole_EN,Mole_CN)
values (null,'CPH&CDH',N'氨麻美敏')

insert into tblDefMolecule_CN_EN_OTC(Mole_Code,Mole_EN,Mole_CN)
values (null,'Compound Pseudoephedrine Hydrochloride',N'酚麻美敏')

insert into tblDefMolecule_CN_EN_OTC(Mole_Code,Mole_EN,Mole_CN)
values(null,'CPHII',N'氨麻苯美')

insert into tblDefMolecule_CN_EN_OTC(Mole_Code,Mole_EN,Mole_CN)
values (null,'CPHII',N'氨酚伪麻美芬片II/氨麻苯美片')	  

update a
set a.Mole_Code=b.Mole_Code
from tblDefMolecule_CN_EN_OTC a join (
	select distinct mole_en,right('000000'+convert(varchar(8),dense_rank() over(order by Mole_EN)),7) as Mole_Code
	from tblDefMolecule_CN_EN_OTC
) b on a.Mole_En=b.Mole_En



truncate table tblDefProduct_CN_EN_OTC
insert into tblDefProduct_CN_EN_OTC(Prod_CN,Prod_EN)
values (N'新康泰克', 'CONTAC NT')
insert into tblDefProduct_CN_EN_OTC(Prod_CN,Prod_EN)
values(N'21金维他', '21-SUPER VITA')
insert into tblDefProduct_CN_EN_OTC(Prod_CN,Prod_EN)
values(N'善存',	'CENTRUM')
insert into tblDefProduct_CN_EN_OTC(Prod_CN,Prod_EN)
values(N'善存银',	'CENTRUM SILVER')
insert into tblDefProduct_CN_EN_OTC(Prod_CN,Prod_EN)
values(N'金施尔康',	'GOLD THERAGRAN')
insert into tblDefProduct_CN_EN_OTC(Prod_CN,Prod_EN)
values(N'日夜百服咛',	'BUFFERIN COLD')
insert into tblDefProduct_CN_EN_OTC(Prod_CN,Prod_EN)
values(N'日夜百服宁',	'BUFFERIN COLD')
insert into tblDefProduct_CN_EN_OTC(Prod_CN,Prod_EN)
values(N'白加黑',	'White & Black ')
insert into tblDefProduct_CN_EN_OTC(Prod_CN,Prod_EN)
values(N'泰诺',	'TYLENOL')
insert into tblDefProduct_CN_EN_OTC(Prod_CN,Prod_EN)
values(N'多维元素',	'Multiple vitamin')

if object_id(N'TempProducts_OTC',N'U') is not null
	drop table TempProducts_OTC;
GO
select distinct a.Mole, a.Prod, a.Prod_FullName, b.Mole_Code, b.Mole_EN, c.Prod_EN
into TempProducts_OTC
from (  
      select distinct Molecule as Mole, Product as Prod, Product+'('+ltrim(rtrim(Manufacture))+')' as Prod_FullName
      from inCPAData t1 
      union 
      select distinct Molecule as Mole, Product as Prod, Product+'('+ltrim(rtrim(Manufacture))+')' as Prod_FullName
      from inSeaRainbowData t1 
      union 
      select distinct Molecule as Mole, Product as Prod, Product+'('+ltrim(rtrim(Manufacture))+')' as Prod_FullName
      from inPharmData t1 
      ) a 
inner join tblDefMolecule_CN_EN_OTC b on a.Mole = b.Mole_CN 
join tblDefProduct_CN_EN_OTC c  on a.Prod=c.Prod_CN
order by Mole, Prod
GO


truncate table tblPackageXRefHosp_OTC
GO

insert into tblPackageXRefHosp_OTC
select distinct t.* from (
select distinct 
     a.Molecule, a.Product, a.Form, a.Specification, a.Manufacture, NUll as ATC_Code
     , b.Mole_Code, b.Mole_EN
     , Null as Product_Code, b.Prod_EN
     , NUll as Package_Name
     , Null as Package_Code
     , Null as AA, c.Manu_ID, c.Manu_Cod, c.MNC
     , 'CPA' as Source, c.Manu_EN
     , Null as NewFlag
from 
     inCPAData a 
inner join TempProducts_OTC b 
on b.Mole=a.Molecule 
   and b.Prod=a.Product 
   and b.Prod_FullName = a.Product+'('+ltrim(rtrim(a.Manufacture))+')'
left join tblDefManufacture_CN_EN c
on a.Manufacture=c.Manu_CN
union 
select distinct 
     a.Molecule, a.Product, a.FormI, a.Specification, a.Manufacture, NUll as ATC_Code
     , b.Mole_Code, b.Mole_EN
     , Null as Product_Code, b.Prod_EN
     , NUll as Package_Name
     , Null as Package_Code
     , Null as AA, c.Manu_ID, c.Manu_Cod, c.MNC
     , 'SeaRainbow' as Source, c.Manu_EN
     , Null as NewFlag
from 
     inSeaRainbowData a 
inner join TempProducts_OTC b 
on b.Mole=a.Molecule 
   and b.Prod=a.Product 
   and b.Prod_FullName = a.Product+'('+ltrim(rtrim(a.Manufacture))+')'
left join tblDefManufacture_CN_EN c
on a.Manufacture=c.Manu_CN
union 
select distinct 
     a.Molecule, a.Product, a.Form, a.Specification, a.Manufacture, NUll as ATC_Code
     , b.Mole_Code, b.Mole_EN
     , Null as Product_Code, b.Prod_EN
     , NUll as Package_Name
     , Null as Package_Code
     , Null as AA, c.Manu_ID, c.Manu_Cod, c.MNC
     , 'Pharm' as Source, c.Manu_EN
     , Null as NewFlag
from 
     inPharmData a 
inner join TempProducts_OTC b 
on b.Mole=a.Molecule 
   and b.Prod=a.Product 
   and b.Prod_FullName = a.Product+'('+ltrim(rtrim(a.Manufacture))+')'
left join tblDefManufacture_CN_EN c
on a.Manufacture=c.Manu_CN
) t
--select * from tblPackageXRefHosp_OTC

--update a
--set a.product_code= isnull(b.prod_cod,a.product_EN)
--from tblPackageXRefHosp_OTC a left join (
--	select distinct prod_des,prod_cod
--	from BMSChinaCIA_IMS.dbo.tblMktDef_ATCDriver 
--) b on a.product_en=b.prod_des


--Manu to product
update tblPackageXRefHosp_OTC set Product_EN = Product_EN+'('+Manu_SC+')'
--指定唯一的product_code
update tblPackageXRefHosp_OTC set Product_code ='H'+Mole_Code_IMS

update tblPackageXRefHosp_OTC set Product_code = b.Product_code + replicate('0',3-len(rnk)) + rnk
-- select *, b.Product_code + replicate('0',3-len(rnk)) + rnk
from tblPackageXRefHosp_OTC a
inner join (
	select  Product_code, Product_EN
	, cast(row_number() over(partition by Product_code order by Product_EN) as varchar) as rnk 
	from (
		select distinct  Product_code, Product_EN 
		from tblPackageXRefHosp_OTC
	)t
) b 
on a.Product_code = b.Product_code and a.Product_EN = b.Product_EN

--指定唯一的Package_code
update tblPackageXRefHosp_OTC set package_name  = Product_EN + Form_Src + Specification_Src 


update tblPackageXRefHosp_OTC set Package_code = b.Product_code + replicate('0',2-len(rnk)) + rnk
-- select *,b.Product_code + replicate('0',2-len(rnk)) + rnk
from tblPackageXRefHosp_OTC a
inner join (
select Product_code,package_name
, cast(row_number() over(partition by Product_code order by package_name) as varchar) as rnk 
from (
	select distinct Product_code, package_name
	from tblPackageXRefHosp_OTC
  ) t
) b 
on a.Product_code = b.Product_code and a.package_name = b.package_name

update tblPackageXRefHosp_OTC set Manu_ID = Manu_SC 
where Manu_ID is null
GO

update tblPackageXRefHosp_OTC set MNC = 'N' 
where MNC is null

select * from tblPackageXRefHosp_OTC