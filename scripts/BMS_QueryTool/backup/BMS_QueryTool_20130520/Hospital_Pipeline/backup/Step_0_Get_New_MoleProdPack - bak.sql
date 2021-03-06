use BMSCNProc2
go


/*
Before this processor, set newflag = 'N'
*/
select * into tblPackageXRefCPA_Pipeline_2012Q3All
from tblPackageXRefCPA_Pipeline
GO
--	select * from tblPackageXRefCPA_Pipeline
update tblPackageXRefCPA_Pipeline set newFlag='N'
GO

/*
New Manufacture
*/
select distinct 生产厂家 
from inCPAData_pipeline 
where 生产厂家 not in (select Manu_CN from tblDefManufacture_CN_EN)


/* tblMolecule_CN_EN_PipeLine -- All Molecule EN-CN for pipeline*/

Print('----------------------------
		tblDefMolecule_CN_EN_PipeLine
----------------------------------')
if object_id(N'tblDefMolecule_CN_EN_PipeLine',N'U') is not null
	drop table tblDefMolecule_CN_EN_PipeLine;
GO

select distinct b.Mole_Cod as Mole_Code, b.Mole_Des as Mole_EN, a.Molecule_CN_Src as Mole_CN
into tblDefMolecule_CN_EN_PipeLine
--select *
from tblMolecule_CN_EN_PipeLine  a 
left join  
         (select distinct Mole_Cod, Mole_Des 
         from tblQueryToolDriverIMS where MktType='Pipeline Market' --Only Pipeline Market
         ) b
on a.Mole_Des = b.Mole_Des
GO


delete from tblDefMolecule_CN_EN_PipeLine
where Mole_Code is null 
and Mole_CN in (select distinct Molecule_CN_Src from tblPackageXRefCPA_Pipeline)
GO




Print('----------------------------
	Get new molecules from inCPA_Pipeline
----------------------------------')
if object_id(N'TempNewMolecules_pipeline',N'U') is not null
	drop table TempNewMolecules_pipeline;
GO
select NewMole, b.Mole_Code, b.Mole_EN
into TempNewMolecules_pipeline
from (
      select distinct 药品名称 as NewMole
      from inCPAData_pipeline t1 
      where not exists (
                        select * from tblPackageXRefCPA_Pipeline t2
                        where t1.药品名称=t2.Molecule_CN_Src
                        )
      ) a left join tblDefMolecule_CN_EN_PipeLine b
on a.NewMole = b.Mole_CN
GO

delete from TempNewMolecules_pipeline where Mole_Code is null
GO


Print('----------------------------
	Get new products from inCPAData_Pipeline
----------------------------------')
/* New Products - Need manually mapping the product-EN
Step 1, run NewProd 1
Step 2, run NewProd 2
Step 3, Manually add new Prod CN-EN relations and Insert into table - tblDefProduct_CN_EN_pipeline
Step 4, re-run NewProd 1
Step 5, run NewProd 3 ===> Get new products.
*/

/*==========NewProd 1==============*/
if object_id(N'TempNewProducts_pipeline',N'U') is not null
	drop table TempNewProducts_pipeline;
GO
select a.NewMole, a.NewProd, b.Mole_Code, b.Mole_EN, c.Prod_EN
into TempNewProducts_pipeline
from (
     	select distinct 药品名称 as NewMole, 商品名 as NewProd
     	from inCPAData_pipeline t1
     	where not exists (
     	                  select * from tblPackageXRefCPA_Pipeline t2
     	                  where t1.药品名称=t2.Molecule_CN_Src and t1.商品名=t2.Product_CN_Src 
     	                  )
     ) a 
left join tblDefMolecule_CN_EN_PipeLine b on a.NewMole = b.Mole_CN 
left join tblDefProduct_CN_EN_PipeLine c  on a.NewProd=c.Prod_CN
order by NewMole, NewProd
GO

delete from TempNewProducts_pipeline where Mole_Code is null
GO

/*==========NewProd 2==============*/
select *  from TempNewProducts_pipeline where Prod_EN is null

/*
insert into tblDefProduct_CN_EN_pipeline(Prod_CN, Prod_EN) values(N'悦康普欣','Yue Kang Pu Xin')
*/

/*==========NewProd 3==============*/
select *  from TempNewProducts_pipeline


Print('==============================================================
		insert new RECORDS into: tblPackageXRefCPA_Pipeline
==============================================================')
insert into tblPackageXRefCPA_Pipeline
select distinct 
   b.Mole_Code, a.药品名称 as Molecule
   , a.商品名 as Product
   , a.剂型 as Form, a.规格 as Specification
   , a.生产厂家 as Manuf
   , Null as Package_Code
   , 'Y' as NewFlag
   , Null as Prod_Code
from inCPAData_pipeline a 
inner join TempNewProducts_pipeline b on b.NewMole=a.药品名称 and b.NewProd=a.商品名
left join tblDefManufacture_CN_EN c on a.生产厂家=c.Manu_CN
GO


--Product EN
update tblPackageXRefCPA_Pipeline set Prod_EN = b.Prod_EN
from tblPackageXRefCPA_Pipeline a 
inner join tblDefProduct_CN_EN_PipeLine b
on a.Product_CN_Src = b.Prod_CN
where newFlag='Y'
GO

--Manufacture
update tblPackageXRefCPA_Pipeline set 
		Manu_EN = b.Manu_EN, Manu_ID = b.Manu_ID, MNC=b.MNC, Prod_EN = Prod_EN+' ('+b.Manu_COd+')'
from tblPackageXRefCPA_Pipeline a 
inner join tblDefManufacture_CN_EN b
on a.Manuf_CN_Src = b.Manu_CN
where newFlag='Y'


--Existing product
update tblPackageXRefCPA_Pipeline set Prod_Code= b.Prod_Code
from tblPackageXRefCPA_Pipeline a 
inner join (
            select distinct Mole_Cod, Prod_Code, Product_CN_Src 
            from tblPackageXRefCPA_Pipeline 
            where newFlag='N'
            ) b
on a.Mole_Cod = b.Mole_Cod and a.Product_CN_Src=b.Product_CN_Src
where a.newFlag='Y'
GO
--new product - Coding
select  distinct Mole_Cod, Product_CN_Src, Prod_Code 
from tblPackageXRefCPA_Pipeline 
where newFlag='Y' and Prod_Code is null
order by Mole_Cod, Product_CN_Src
/*
select max(Prod_Code) from tblPackageXRefCPA_Pipeline
update tblPackageXRefCPA_Pipeline set Prod_Code='H00001155' where Mole_Cod='159780' and Product_CN_Src=N'优普荣'
update tblPackageXRefCPA_Pipeline set Prod_Code='H00001156' where Mole_Cod='159780' and Product_CN_Src=N'噻氯匹定'
*/

--new package - codeing
select  distinct Mole_Cod, Prod_Code, Form_Src, Strength_Src, Pack_Cod
from tblPackageXRefCPA_Pipeline where newFlag='Y'
order by Prod_Code
/*
update tblPackageXRefCPA_Pipeline set Pack_Cod='H0000115501' where Mole_Cod='159780' and Prod_Code='H00001155' and Form_Src='TAB' and Strength_Src='125 MG' 
update tblPackageXRefCPA_Pipeline set Pack_Cod='H0000115602' where Mole_Cod='159780' and Prod_Code='H00001156' and Form_Src='CAP' and Strength_Src='125 MG' 
*/




-----------------------------------------------------------------------------------------------------------
--back up
select * into tblQueryToolDriverHosp_Pipeline__2012Q3_all
from tblQueryToolDriverHosp_Pipeline
GO

--update data
truncate table tblQueryToolDriverHosp_Pipeline
GO
insert into tblQueryToolDriverHosp_Pipeline
select distinct 
    a.MktType, a.Mkt, a.MktName, Null as ATC3_Cod, Null as Class, a.Mole_Cod, a.Mole_Des
    , b.Prod_Code, upper(b.Prod_EN) as Prod_Des
    , b.Pack_Cod,  upper(b.Prod_EN + b.Form_Src+' '+ b.Strength_Src) as Pack_Des
    ,  Null as Corp_Cod, null as Corp_Des
    , b.Manu_ID, upper(b.Manu_EN) as Manu_Des
    , b.MNC, 'N' as ClsInd
from tblPackageXRefCPA_Pipeline b 
inner join (
           select distinct MktType, Mkt, MktName, Mole_Cod, Mole_Des 
           from tblQueryToolDriverIMS
           where MktType='pipeline Market'
           ) a 
on a.Mole_cod=b.Mole_cod
where b.Mole_cod in (
                    select Mole_Cod from tblQueryToolDriverIMS
                    where MktType='pipeline Market'
                    )
GO
