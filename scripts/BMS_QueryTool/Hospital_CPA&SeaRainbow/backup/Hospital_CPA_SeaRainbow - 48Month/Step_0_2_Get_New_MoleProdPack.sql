/*

1. 确认inManuDef，inProdDef是客户给的最新的:不然 厂商 及 产品 的英文名都得自己造。
   
   --箔类：
   用inManuDef更新tblDefManufacture_CN_EN where SourceFlag='inManuDef' 翻译
   用inProdDef更新tblHospMoleXRefProd 翻译
 
--对inManuDef源数据的问题数据进行处理
select * from inManuDef

select namec,count(name) from inManuDef 
group by namec having count(name)>1

select * from inManuDef 
where namec in (N'中美上海施贵宝制药有限公司',N'四川诺迪康威光制药有限公司',N'威海华洋药业有限公司')

delete -- select * 
from inManuDef 
where manucode in ('4270','5504','6315')
GO
--对inManuDef_Gool 翻译数据的问题数据进行处理
select namec from inManuDef_Gool group by namec having count([name]) >1


--对inProdDef源数据的问题数据进行处理
select * from inProdDef

select NAMEC, count(ENAME) from inProdDef group by NAMEC having count(ENAME)>1

drop table test_inProdDef
GO
select * into test_inProdDef from inProdDef where 1=0
GO
insert into test_inProdDef
select max(PRODCODE),max(LABCODE),NAMEC,max(ENAME),max(LABNAME) 
from inProdDef group by NAMEC
GO
drop table inProdDef
EXEC sp_rename 'test_inProdDef', 'inProdDef'
GO



2. 确认db4.BMSChinaMRBI.dbo.tblMoleConfig  :不然 Molecule 的英文名都得自己造。
   实际上最终的tblQueryToolDriverHosp的mole_EN是从tblQueryToolDriverIMS来的（通过mole_code关联）。

*/


use BMSCNProc2
go
--  back up
select * into BMSCNProc_bak.dbo.tblPackageXRefHosp_201302 from tblPackageXRefHosp          --产品 定义表
GO 
select * into BMSCNProc_bak.dbo.tblQueryToolDriverHosp_201302 from tblQueryToolDriverHosp  --市场 定义表
GO





------------------------------------------------------------------------------------------------------------
--  产品定义部分：将源数据新增的产品添加到 产品定义表：tblPackageXRefHosp
------------------------------------------------------------------------------------------------------------
update tblPackageXRefHosp set newFlag='N' 
GO

Print('------------------------------------------------------
1.  Manufacture  Definition:	tblDefManufacture_CN_EN
------------------------------------------------------------')
--备份
drop table tblDefManufacture_CN_EN_bak
GO
select * into tblDefManufacture_CN_EN_bak
from tblPackageXRefCPA_Pipeline
GO

--New Add Manufacture:为了保险起见  我们直接从源数据取New Add Manufacture，而inManuDef只用来更新ManuNameEN
drop table Temp_newAddManufacture
GO
select distinct [Manufacture] 
into Temp_newAddManufacture
from inCPAData 
where [Manufacture] not in (select Manu_CN from dbo.tblDefManufacture_CN_EN)
GO
select * from Temp_newAddManufacture

--为新增的Manufacture指定Manu_code ，然后插入到tblDefManufacture_CN_EN
drop table test_tblDefManufacture_CN_EN
GO
select * into  test_tblDefManufacture_CN_EN from tblDefManufacture_CN_EN where 1=0
GO
insert into test_tblDefManufacture_CN_EN(Manu_Cod,Manu_CN)
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
--根据客户给的inManuDef更新ManuNameEN
update test_tblDefManufacture_CN_EN  set Manu_EN=b.[name]
from test_tblDefManufacture_CN_EN a left join inManuDef b on a.Manu_CN=b.[namec]
GO
insert into tblDefManufacture_CN_EN  select * from test_tblDefManufacture_CN_EN where Manu_EN is not null
GO
delete from test_tblDefManufacture_CN_EN where Manu_EN is not null
GO

--特殊处理 (这部分厂的翻译客户没有给到):根据我们 网上找的翻译dbo.inManuDef_Gool 更新ManuNameEN
select * from test_tblDefManufacture_CN_EN where Manu_EN is null

update test_tblDefManufacture_CN_EN  set Manu_EN=b.[name]
from test_tblDefManufacture_CN_EN a left join dbo.inManuDef_Gool b on a.Manu_CN=b.[namec]
GO

insert into tblDefManufacture_CN_EN
select * from test_tblDefManufacture_CN_EN 
GO 



--检查tblDefManufacture_CN_EN数据是否有误
select * from tblDefManufacture_CN_EN
where Manu_CN is null or Manu_cod is null

select * from  tblDefManufacture_CN_EN 
where Manu_CN in (
select Manu_CN
from tblDefManufacture_CN_EN
where Manu_EN is not null
group by Manu_CN having count(Manu_EN) > 1
) 
GO

select Manu_CN,count(Manu_cod) 
from tblDefManufacture_CN_EN
group by Manu_CN having count(Manu_cod) > 1





Print('------------------------------------------------------
2.1  Molecule  Definition:	tblDefMolecule_CN_EN
------------------------------------------------------------')
--检查db4.BMSChinaMRBI.dbo.tblMoleConfig  数据是否有误
select moleculecn,count(moleculeen) 
from db4.BMSChinaMRBI.dbo.tblMoleConfig 
group by moleculecn having count(moleculeen) > 1

--
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

delete from tblDefMolecule_CN_EN where Mole_Code is null 
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

--检查tblDefMolecule_CN_EN数据是否有误
select Mole_CN,count(Mole_EN) 
from tblDefMolecule_CN_EN
group by Mole_CN having count(Mole_EN) > 1

select Mole_CN,count(Mole_Code) 
from tblDefMolecule_CN_EN
group by Mole_CN having count(Mole_Code) > 1

select * from  tblDefMolecule_CN_EN 
where Mole_Code in (
         select a.Mole_Code from tblDefMolecule_CN_EN a
         inner join (
                     select Mole_Code,Mole_EN
                     from tblDefMolecule_CN_EN
                     where Mole_Code is not null
                     group by  Mole_Code,Mole_EN having count(Mole_CN) > 1
                     ) b 
         on a.Mole_Code=b.Mole_Code and a.Mole_EN=b.Mole_EN
) 



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
delete  -- select *
from TempNewMolecules where Mole_Code is null
GO


Print('------------------------------------------------------
3.  Product  Definition: -->tblDefProduct_CN_EN -->TempNewProducts
------------------------------------------------------------')
--检查db4.BMSChinaMRBI.dbo.tblProdConfig  数据是否有误
select productcn,count(producten) 
from db4.BMSChinaMRBI.dbo.tblProdConfig 
group by productcn having count(producten) > 1

if object_id(N'tblDefProduct_CN_EN',N'U') is not null
	drop table tblDefProduct_CN_EN;
GO
select 
	productcn as Prod_CN
	, producten as Prod_EN 
into tblDefProduct_CN_EN
from db4.BMSChinaMRBI.dbo.tblProdConfig
GO

--根据客户给的inProdDef更新Prod_EN
update tblDefProduct_CN_EN  set Prod_EN=b.[ENAME]  -- select *  
from tblDefProduct_CN_EN a inner join inProdDef b on a.Prod_CN=b.[NAMEC]
GO

delete from tblDefProduct_CN_EN where Prod_EN is null
GO 

--检查tblDefProduct_CN_EN 翻译数据是否有误
select Prod_CN
from tblDefProduct_CN_EN
group by Prod_CN having count(distinct Prod_EN) > 1



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
	    where y>2008 
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

select *  from TempNewProducts where Prod_EN is null

对客户inProdDef里 没有给到的product翻译，
手工为新产品添加 Prod_EN：
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'伯思平','Bai si Ping')
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'圣特','Shen Te')
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'二甲双胍/格列苯脲','Ee Jia Shuang Gu/Ge Lie Ben Niao')
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'吉西他滨','Ji Xi Ta Bin')
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'欣尔金','Xin Er Jin')
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'罗格列酮','Luo Ge Lie Tong')
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'那格列奈','Na Ge Lie Nai')
GO

*/


/*==========NewProd 3==============*/
select *  from TempNewProducts

--检查tblDefProduct_CN_EN 翻译数据是否有误
select NewProd
from TempNewProducts
group by NewProd having count(distinct Prod_EN) > 1

select NewMole
from TempNewProducts
group by NewMole having count(distinct Mole_EN) > 1

select NewMole
from TempNewProducts
group by NewMole having count(distinct Mole_Code) > 1





Print N('------------------------------------------------------
4.	为新Products指定Product_code,Package_code。

    并insert into 产品市场定义表:tblPackageXRefHosp
------------------------------------------------------------')
truncate table tblPackageXRefHosp_newAdd
GO

insert into tblPackageXRefHosp_newAdd
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
inner join TempNewProducts b 
on b.NewMole=a.Molecule 
   and b.NewProd=a.Product 
   and b.NewProd_FullName = a.Product+'('+ltrim(rtrim(a.Manufacture))+')'
left join tblDefManufacture_CN_EN c
on a.Manufacture=c.Manu_CN
GO
select * from tblPackageXRefHosp_newAdd

--Manu to Product_EN
update tblPackageXRefHosp_newAdd set Product_EN = Product_EN+'('+Manu_SC+')'
GO

--Existing product
update tblPackageXRefHosp_newAdd set Product_Code= b.Product_COde,newFlag='N'
from tblPackageXRefHosp_newAdd a 
inner join (
            select distinct Mole_Code_IMS, Product_EN, Product_COde 
            from tblPackageXRefHosp where newFlag='N'
            ) b
on a.Mole_Code_IMS = b.Mole_Code_IMS and a.Product_EN=b.Product_EN
GO

select * from tblPackageXRefHosp_newAdd  where Product_code is not null

--对新增product还没有product_code的   指定唯一的product_code
select  distinct Mole_Code_IMS, Product_EN, Product_code 
from tblPackageXRefHosp_newAdd  where newFlag='N'

select * from tblPackageXRefHosp_newAdd where newFlag='Y'
--

update tblPackageXRefHosp_newAdd set Product_code ='H'+Mole_Code_IMS
where newFlag='Y'
GO


-- set the final product code
select * from tblPackageXRefHosp_newAdd where newFlag='Y'

drop table tblPackageXRefHosp_newAdd_test
GO
select distinct  Product_code, Product_EN 
into tblPackageXRefHosp_newAdd_test from tblPackageXRefHosp_newAdd where newFlag='Y'
GO

update tblPackageXRefHosp_newAdd set Product_code = b.Product_code + replicate('0',2-len(rnk)) + rnk
-- select *, b.Product_code + replicate('0',2-len(rnk)) + rnk
from tblPackageXRefHosp_newAdd a
inner join (
select  Product_code, Product_EN
, cast(row_number() over(partition by Product_code order by Product_EN) as varchar) as rnk 
from tblPackageXRefHosp_newAdd_test
) b 
on a.Product_code = b.Product_code and a.Product_EN = b.Product_EN
GO

select * from tblPackageXRefHosp_newAdd order by Product_code,Product_EN




-->>>.........对新增product指定唯一的Package_code
drop table tblPackageXRefHosp_newAdd_test
GO
select distinct Product_code, form_src,specification_src
into tblPackageXRefHosp_newAdd_test from tblPackageXRefHosp_newAdd
GO

update tblPackageXRefHosp_newAdd set Package_code = b.Product_code + replicate('0',2-len(rnk)) + rnk
-- select *,b.Product_code + replicate('0',2-len(rnk)) + rnk
from tblPackageXRefHosp_newAdd a
inner join (
select Product_code, form_src,specification_src
, cast(row_number() over(partition by Product_code order by form_src,specification_src) as varchar) as rnk 
from tblPackageXRefHosp_newAdd_test
) b 
on a.Product_code = b.Product_code and a.form_src = b.form_src and a.specification_src = b.specification_src
GO

select * from tblPackageXRefHosp_newAdd order by Product_code,form_src,specification_src







-- 检查新增产品是否正确:

--新产品是否在tblPackageXRefHosp中已经被定义
select * from tblPackageXRefHosp_newAdd t1
inner join tblPackageXRefHosp t2
on t1.Molecule_CN_Src=t2.Molecule_CN_Src 
and t1.Product_CN_Src=t2.Product_CN_Src and t1.Manu_CN_Src=t2.Manu_CN_Src     
and t1.Form_Src=t2.Form_Src and t1.Specification_Src=t2.Specification_Src 


--查询是否有： 相同产品 多个Package_Code的  问题数据
select distinct Molecule_CN_Src,Product_CN_Src ,Form_Src,Specification_Src ,Manu_CN_Src,count(Package_Code)
from tblPackageXRefHosp_newAdd 
group by Molecule_CN_Src,Product_CN_Src ,Form_Src,Specification_Src ,Manu_CN_Src
having count(Package_Code) > 1

/*-->临时处理脚本
select * from tblPackageXRefHosp
where Molecule_CN_Src= N'二甲双胍' and Product_CN_Src=N'二甲双胍' and Manu_CN_Src=N'华北制药集团制剂有限公司'


delete  from tblPackageXRefHosp_newAdd where Package_Code in ('H0206055001')
GO

select * from tblPackageXRefHosp_newAdd
where Molecule_CN_Src= N'格列齐特' and Product_CN_Src=N'格列齐特' and Manu_CN_Src=N'山东力诺科峰制药有限公司'
and Form_Src='TAB' and Specification_Src='40 MG' 


update  tblPackageXRefHosp_newAdd set Package_Code='H0347092065' 
where Molecule_CN_Src= N'二甲双胍' and Product_CN_Src=N'二甲双胍' and Manu_CN_Src=N'华北制药集团制剂有限公司'
and Form_Src='CAP' and Specification_Src='250 MG' 
GO



格列齐特	格列齐特	TAB	30 MG	天津中新药业集团股份有限公司新新制药厂
格列齐特	格列齐特	TAB	40 MG	山东力诺科峰制药有限公司
-->*/

select Manu_EN
from tblPackageXRefHosp_newAdd
group by Manu_EN having count(distinct Manu_Sc) > 1

select Product_CN_Src,Manu_SC
from tblPackageXRefHosp_newAdd
group by Product_CN_Src,Manu_SC having count(distinct Product_EN) > 1 





----将新产品定义更新到：tblPackageXRefHosp
insert into tblPackageXRefHosp 
select a.* from(
select * from tblPackageXRefHosp_newAdd 
except 
select * from tblPackageXRefHosp
) a
GO

--特殊处理
update tblPackageXRefHosp set Manu_ID = Manu_SC 
where Manu_ID is null
GO

update tblPackageXRefHosp set MNC = 'N' 
where MNC is null
GO


--检查tblPackageXRefHosp数据是否有误
select * from tblPackageXRefHosp
where Molecule_EN is null or Product_EN is null or Package_Name is null 
or Package_Code is null or Product_Code is null 

--1. 检查 相同产品 多个Package_Code的  问题数据
select Molecule_CN_Src,Product_CN_Src ,Form_Src,Specification_Src ,Manu_CN_Src
from tblPackageXRefHosp 
group by Molecule_CN_Src,Product_CN_Src ,Form_Src,Specification_Src ,Manu_CN_Src
having count(Package_Code) > 1

--2. 检查是否所有产品都被加进来了 
------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>2.1 Product 级别:
drop table test
GO
select distinct
 t1.Molecule,t1.Product,t1.Manufacture   into test
from inCPAData t1 
where y>2008 
and not exists (
select distinct
t2.Molecule_CN_Src ,t2.Product_CN_Src,t2.Manu_CN_Src
from tblPackageXRefHosp t2
where 
    t1.Molecule=t2.Molecule_CN_Src 
and t1.Product=t2.Product_CN_Src and t1.Manufacture=t2.Manu_CN_Src     
)
GO

select * from test a
left join tblDefMolecule_CN_EN b on a.Molecule = b.Mole_CN 
where Mole_Code is not null

--进一步抽查：
select * from tblPackageXRefHosp 
where Molecule_CN_Src=N'二甲双胍' and Product_CN_Src=N'伯思平' and Manu_CN_Src=N'沈阳万隆药业有限公司' 

select * from inCPAData 
where Molecule=N'二甲双胍' and Product=N'伯思平' and Manufacture=N'沈阳万隆药业有限公司'

select * from tblDefMolecule_CN_EN where Mole_CN =N'格列美脲'
------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>2.2 Package 级别:
drop table test
GO
select distinct
 t1.Molecule,t1.Product,t1.Manufacture,t1.Form,t1.Specification   into test
from inCPAData t1 
where y>2008 
and not exists (
select distinct
t2.Molecule_CN_Src ,t2.Product_CN_Src,t2.Manu_CN_Src,  t2.Form_Src ,t2.Specification_Src  
from tblPackageXRefHosp t2
where 
    t1.Molecule=t2.Molecule_CN_Src 
and t1.Product=t2.Product_CN_Src and t1.Manufacture=t2.Manu_CN_Src     
and t1.Form=t2.Form_Src and t1.Specification=t2.Specification_Src  
)
GO
drop table TempNewProducts_PackageLevel
GO
select * into TempNewProducts_PackageLevel
from test a
left join tblDefMolecule_CN_EN b on a.Molecule = b.Mole_CN 
where Mole_Code is not null order by Molecule,Product
GO

select * from TempNewProducts_PackageLevel

--进一步抽查：
select * from tblPackageXRefHosp 
where Molecule_CN_Src=N'二甲双胍' and Product_CN_Src=N'二甲双胍' and Manu_CN_Src=N'华北制药集团制剂有限公司' and Form_Src='CAP' and Specification_Src=N'250 MG'

select * from inCPAData 
where Molecule=N'二甲双胍' and Product=N'二甲双胍' and Manufacture=N'华北制药集团制剂有限公司' and Form='CAP' and Specification=N'250 MG'

-->>特殊处理一下：
truncate table tblPackageXRefHosp_newAdd
GO
insert into tblPackageXRefHosp_newAdd
select distinct 
     b.Molecule_CN_Src, b.Product_CN_Src, a.Form, a.Specification, b.Manu_CN_Src , b.ATC_Code
     , b.Mole_Code_IMS, b.Molecule_EN
     , b.Product_Code, b.Product_EN
     , b.Product_EN+' '+a.Form+' '+a.Specification as Package_Name
     , Null as Package_Code
     , Null as AA, b.Manu_ID, b.Manu_SC, b.MNC
     , 'CPA' as Source, b.Manu_EN
     , 'P' as NewFlag
from TempNewProducts_PackageLevel a
inner join tblPackageXRefHosp b
on a.Molecule=b.Molecule_CN_Src 
and a.Product=b.Product_CN_Src and a.Manufacture=b.Manu_CN_Src   
GO
select * from tblPackageXRefHosp_newAdd
------------转到   -->>>.........对新增product指定唯一的Package_code
GO




--
select Molecule_CN_Src,count(distinct Molecule_EN) 
from tblPackageXRefHosp
group by Molecule_CN_Src having count(distinct Molecule_EN) > 1
--
select * 
from  tblPackageXRefHosp 
where Manu_CN_Src in (
select Manu_CN_Src
from tblPackageXRefHosp
group by Manu_CN_Src having count(distinct Manu_Sc) > 1
union all
select Manu_CN_Src
from tblPackageXRefHosp
group by Manu_CN_Src having count(distinct Manu_EN) > 1
union all
select Manu_Sc
from tblPackageXRefHosp
group by Manu_Sc having count(distinct Manu_EN) > 1
) 
--
select * 
from  tblPackageXRefHosp 
where Product_CN_Src in (
select Product_CN_Src--,Manu_SC
from tblPackageXRefHosp
group by Product_CN_Src,Manu_SC having count(distinct Product_EN) > 1 
) 







--特殊处理：  相同产品 多个Package_Code的  问题数据
drop table tblPackageXRefHosp_test
GO
select a.* into tblPackageXRefHosp_test 
from tblPackageXRefHosp a
inner join (
select Molecule_CN_Src,Product_CN_Src ,Form_Src,Specification_Src ,Manu_CN_Src
from tblPackageXRefHosp 
group by Molecule_CN_Src,Product_CN_Src ,Form_Src,Specification_Src ,Manu_CN_Src
having count(Package_Code) > 1
) b
on a.Molecule_CN_Src=b.Molecule_CN_Src and a.Product_CN_Src= b.Product_CN_Src
and a.Form_Src= b.Form_Src and a.Specification_Src=b.Specification_Src 
and a.Manu_CN_Src=b.Manu_CN_Src
GO

drop table tblPackageXRefHosp_bak
select a.* into tblPackageXRefHosp_bak 
from(
select * from tblPackageXRefHosp 
except 
select distinct * from tblPackageXRefHosp_test
) a
GO

drop table tblPackageXRefHosp
EXEC sp_rename 'tblPackageXRefHosp_bak', 'tblPackageXRefHosp'
GO









------------------------------------------------------------------------------------------------------------
--  市场定义部分：
------------------------------------------------------------------------------------------------------------

select * from tblPackageXRefHosp
--------->>查询相同product具有不同的Product_Code

select Molecule_CN_Src,Product_CN_Src,Manu_CN_Src,count(distinct Product_Code)
from tblPackageXRefHosp
group by Molecule_CN_Src,Product_CN_Src,Manu_CN_Src having count(distinct Product_Code)>1

/*
--product_code临时处理：
drop table test
GO
select Molecule_CN_Src,Product_CN_Src,Manu_CN_Src into test01 from tblPackageXRefHosp where 1=0
GO 
insert into test01 
select distinct Molecule_CN_Src,Product_CN_Src,Manu_CN_Src
from tblPackageXRefHosp
group by Molecule_CN_Src,Product_CN_Src,Manu_CN_Src having count(distinct Product_Code)>1
GO


--delete from tblPackageXRefHosp
insert into tblPackageXRefHosp_newAdd
select a.* 
from tblPackageXRefHosp_0328testzhq a
inner join test01 b
on  a.Molecule_CN_Src= b.Molecule_CN_Src
and a.Product_CN_Src=b.Product_CN_Src
and a.Manu_CN_Src=b.Manu_CN_Src
GO


select * from tblPackageXRefHosp_newAdd

select * from TempNewProducts

delete from TempNewProducts
GO
insert into TempNewProducts
select 
	a.Molecule_CN_Src,a.product_cn_src,a.Product_CN_Src+'('+rtrim(Manu_CN_Src)+')', b.Mole_Code, b.Mole_EN, c.Prod_EN
from tblPackageXRefHosp_newAdd a
left join tblDefMolecule_CN_EN b on a.Molecule_CN_Src = b.Mole_CN 
left join tblDefProduct_CN_EN c  on a.product_cn_src=c.Prod_CN
GO

select * into BMSCNProc_bak.dbo.TempNewProducts20130328 from TempNewProducts
GO

----> 转到TempNewProducts部分
*/

--
drop table test
GO
select  Product_EN,Product_Code into test
from tblPackageXRefHosp where 1=0
GO
insert into test  -->
select  Product_EN,max(Product_Code) 
from tblPackageXRefHosp
group by Product_EN having count(distinct Product_Code)>1
GO
update tblPackageXRefHosp set Product_Code = b.Product_Code -- select * 
from tblPackageXRefHosp a
left join test b 
on a.Product_EN=b.Product_EN
GO
--------->>查询相同Package_Name具有不同的Package_Code
drop table test
GO
select  Product_EN,Manu_SC,Package_Name,Package_Code into test
from tblPackageXRefHosp where 1=0
GO
insert into test  -->
select  Product_EN,Manu_SC,Package_Name,max(Package_Code) 
from tblPackageXRefHosp
group by Product_EN,Manu_SC,Package_Name having count( distinct Package_Code)>1
GO
update tblPackageXRefHosp set Package_Code = b.Package_Code -- select * 
from tblPackageXRefHosp a
left join test b 
on a.Product_EN=b.Product_EN and a.Manu_SC=b.Manu_SC and a.Package_Name=b.Package_Name
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



