use BMSCNProc2
go

--	Before this processor, set newflag = 'N'   
--	select * from tblPackageXRefHosp
update tblPackageXRefHosp set newFlag='N'
GO




Print('------------------------------------------------------
1.  Manufacture  Definition:	tblDefManufacture_CN_EN
------------------------------------------------------------')
--New Add Manufacture
select distinct ManuNameEN, ManuNameCN from inManuDef 
where ManuNameCN not in (select Manu_CN from dbo.tblDefManufacture_CN_EN)

drop table Temp_newAddManufacture
select distinct [Manufacture] 
into Temp_newAddManufacture
from inCPAData 
where [Manufacture] not in (select Manu_CN from dbo.tblDefManufacture_CN_EN)
GO
--updata tblDefManufacture_CN_EN
insert into tblDefManufacture_CN_EN(Manu_Cod,Manu_CN)
select 
	 c.Manu_code
	,b.Manufacture
from (
      --New Add Manufacture  排序
      select Manufacture, row_number() over(order by Manufacture) rnk
      from Temp_newAddManufacture
     ) b 
inner join 
	(
	 ---- Available Manu_code 排序
     select Manu_code, row_number() over (order by Manu_code) rnk
     from tempCodeingManu 
	 where Manu_Code not in (select Manu_Cod from dbo.tblDefManufacture_CN_EN)
	) c 
on b.rnk = c.rnk
GO


Print('------------------------------------------------------
2.1  Molecule  Definition:	tblDefMolecule_CN_EN
------------------------------------------------------------')
if object_id(N'tblDefMolecule_CN_EN',N'U') is not null
	drop table tblDefMolecule_CN_EN;
GO
select distinct 
	  b.Mole_Cod as Mole_Code
	, a.MoleculeEN as Mole_EN
	, a.MoleculeCN as Mole_CN
into tblDefMolecule_CN_EN
from db4.BMSChinaMRBI.dbo.tblMoleConfig  a --include all Molecule CN-EN for in-line Market
left join  
      (select distinct Mole_Cod, Mole_Des 
       from tblQueryToolDriverIMS where MktType='In-line Market' --Only Inline Marke
      ) b
on a.MoleculeEN = b.Mole_Des
GO

delete from tblDefMolecule_CN_EN
where 
	Mole_Code is null 
	and Mole_CN in (select distinct Molecule_CN_Src from tblPackageXRefHosp)
GO

insert into tblDefMolecule_CN_EN
select distinct 
	Mole_Code_IMS
	, Molecule_EN
	, Molecule_CN_Src  
from tblPackageXRefHosp a
where not exists (
                  select * from tblDefMolecule_CN_EN b 
                  where 
                       b.Mole_Code=a.Mole_Code_IMS 
                       and b.Mole_EN=a.Molecule_EN 
                       and b.Mole_CN=a.Molecule_CN_Src
                 )
GO



Print('----------------------------
2.2  Get new molecules from inCPA
----------------------------------')
if object_id(N'TempNewMolecules',N'U') is not null
	drop table TempNewMolecules;
GO
select NewMole, b.Mole_Code, b.Mole_EN
into TempNewMolecules
from (
     select distinct Molecule as NewMole
     from inCPAData t1 
     where not exists (
                       select * from tblPackageXRefHosp t2
                       where t1.Molecule=t2.Molecule_CN_Src 
                       )
     ) a 
left join 
     tblDefMolecule_CN_EN b
on a.NewMole = b.Mole_CN
GO
-- 对没有指定Mole_Code的产品暂时舍弃
delete from TempNewMolecules where Mole_Code is null
GO


Print('------------------------------------------------------
3.  Product  Definition: -->tblDefProduct_CN_EN -->TempNewProducts
------------------------------------------------------------')
if object_id(N'tblDefProduct_CN_EN',N'U') is not null
	drop table tblDefProduct_CN_EN;
GO
select 
	productcn as Prod_CN
	, producten as Prod_EN 
into tblDefProduct_CN_EN
from db4.BMSChinaMRBI.dbo.tblProdConfig
GO

Print('----------------------------
3.1	Get new products from inCPAData
----------------------------------')
/* New Products - Need manually mapping the product-EN

Step 1, run NewProd 1
Step 2, run NewProd 2
Step 3, Manually add new Prod CN-EN relations and Insert into table : tblDefProduct_CN_EN
Step 4, re-run NewProd 1
Step 5, run NewProd 3 ===> Get new products.

*/

/*==========NewProd 1==============*/
if object_id(N'TempNewProducts',N'U') is not null
	drop table TempNewProducts;
GO
select 
	a.NewMole, a.NewProd, a.NewProd_FullName, b.Mole_Code, b.Mole_EN, c.Prod_EN
into TempNewProducts
from (
	    select distinct 
			Molecule as NewMole, Product as NewProd, Product+'('+ltrim(rtrim(Manufacture))+')' as NewProd_FullName
	    from inCPAData t1 
	    where y>2010 
	    and not exists (
	                     select distinct
							t2.Molecule_CN_Src,t2.product_cn_src,t2.Product_CN_Src+'('+rtrim(t2.Manu_CN_Src)+')' 
                         from tblPackageXRefHosp t2
	                     where t1.Molecule=t2.Molecule_CN_Src 
                               and t1.Product=t2.product_cn_src
							   and t1.Product+'('+ltrim(rtrim(t1.Manufacture))+')'=t2.Product_CN_Src+'('+ltrim(rtrim(t2.Manu_CN_Src))+')'  
	                    )
      ) a 
left join tblDefMolecule_CN_EN b on a.NewMole = b.Mole_CN 
left join tblDefProduct_CN_EN c  on a.NewProd=c.Prod_CN
order by NewMole, NewProd
GO
delete from TempNewProducts where Mole_Code is null
GO


/*==========NewProd 2==============*/

/*
手工为新产品添加 Prod_EN：
select *  from TempNewProducts where Prod_EN is null

insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'悦康普欣','Yue Kang Pu Xin')
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'唐力','Tang Li')
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'唐瑞','AMRES')
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'安唐平','Antang level')
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'芙格清','Fu Ge Qing')
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'贝加','Bega')
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'迪方','Di Fang')
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'那格列奈','Nateglinide')
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'齐复','Qi complex')
*/


/*==========NewProd 3==============*/
select *  from TempNewProducts




Print('------------------------------------------------------
4.	为新RECORDS指定Product_code,Package_code。
    并insert into 产品市场定义表:tblPackageXRefHosp
------------------------------------------------------------')
select * into tblPackageXRefHosp_20130310_newAdd from tblPackageXRefHosp where 1=0
select * from tblPackageXRefHosp_20130310_newAdd
go 
insert into tblPackageXRefHosp_20130310_newAdd
select distinct 
     a.Molecule, a.Product, a.Form, a.Specification, a.Manufacture, a.ATC_Code
     , b.Mole_Code, b.Mole_EN
     , Null as Product_Code, b.Prod_EN
     , b.Prod_EN+' '+a.Form+' '+a.Specification as Package_Name
     , Null as Package_Code
     , Null as AA, c.Manu_ID, c.Manu_Cod, c.MNC
     , 'CPA' as Source, c.Manu_EN
     , 'Y' as NewFlag
from 
     inCPAData a 
inner join 
     TempNewProducts b 
on b.NewMole=a.Molecule and b.NewProd=a.Product
left join 
     tblDefManufacture_CN_EN c
on a.Manufacture=c.Manu_CN
GO

--Manu to Product_EN
update tblPackageXRefHosp_20130310_newAdd set Product_EN = Product_EN+' ('+Manu_SC+')'
where newFlag='Y'
GO

select * from tblPackageXRefHosp_20130310_newAdd

--Existing product
update tblPackageXRefHosp_20130310_newAdd set Product_Code= b.Product_COde
from tblPackageXRefHosp_20130310_newAdd a 
inner join (
            select distinct Mole_Code_IMS, Product_EN, Product_COde 
            from tblPackageXRefHosp where newFlag='N'
            ) b
on a.Mole_Code_IMS = b.Mole_Code_IMS and a.Product_EN=b.Product_EN
where a.newFlag='Y'
GO

--对新增product指定唯一的product_code
select  distinct Mole_Code_IMS, Product_EN, Product_code 
from tblPackageXRefHosp_20130310_newAdd 


update tblPackageXRefHosp_20130310_newAdd set Product_code ='H'+subString(Mole_Code_IMS,1,5)
GO
update tblPackageXRefHosp_20130310_newAdd set Product_code = b.Product_code + replicate('0',3-len(rnk)) + rnk
from tblPackageXRefHosp_20130310_newAdd a
inner join (
      select 
			Product_code
			, Product_EN
			, cast(row_number() over(partition by Product_code order by Product_EN) as varchar) as rnk 
	  from tblPackageXRefHosp_20130310_newAdd
) b 
on a.Product_code = b.Product_code and a.Product_EN = b.Product_EN
GO

--对新增product指定唯一的Package_code
update tblPackageXRefHosp_20130310_newAdd set Package_code = b.Product_code + replicate('0',2-len(rnk)) + rnk
from tblPackageXRefHosp_20130310_newAdd a
inner join (
      select 
		Product_code
		, form_src,specification_src
		, cast(row_number() over(partition by Product_code order by form_src,specification_src) as varchar) as rnk 
      from tblPackageXRefHosp_20130310_newAdd
) b 
on a.Product_code = b.Product_code and a.form_src = b.form_src and a.specification_src = b.specification_src
GO

--将新产品定义更新到：tblPackageXRefHosp_20130310_newAdd
select * into tblPackageXRefHosp_2013xxxx 
from tblPackageXRefHosp
GO
insert into tblPackageXRefHosp
select * from tblPackageXRefHosp_20130310_newAdd
GO
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

--back up
select * 
into tblQueryToolDriverHosp_20130227
from tblQueryToolDriverHosp
GO
--update
truncate table tblQueryToolDriverHosp
GO
insert into tblQueryToolDriverHosp
select distinct a.MktType, a.Mkt, a.MktName, a.ATC3_Cod, a.Class, a.Mole_Cod, a.Mole_Des, 
                b.Product_Code, upper(b.Product_EN) as Product_EN, b.Package_Code, 
                upper(b.Package_Name) as Package_Name,  Null as Corp_Cod, null as Corp_Des
                , b.Manu_ID, upper(b.Manu_EN) as Manu_EN, b.MNC, 'N' as ClsInd
from tblPackageXRefHosp b 
inner join (
           select distinct MktType, Mkt, MktName, ATC3_Cod, Class, Mole_Cod, Mole_Des 
           from tblQueryToolDriverIMS
           where MktType='In-line Market'
           ) a 
on a.Mole_cod=b.Mole_Code_IMS
where b.Mole_Code_IMS in (
                          select Mole_Cod from tblQueryToolDriverIMS
                          where MktType='In-line Market'
                          )
GO

/*
Special Monopril Market only include 4 Products:   acertil,lotensin,monopril,tritace
*/   
delete from tblQueryToolDriverHosp
where Mkt='HYPM' 
and ltrim(rtrim(substring(Prod_Des,1,charindex(' (',Prod_Des)))) 
not in ('ACERTIL','LOTENSIN','MONOPRIL','TRITACE')
GO