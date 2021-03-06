/* 
修改时间: 2013/4/23 11:28:11

维护方式：半手工


处理内容：市场定义表

*/
use BMSCNProc2
go




-->处理开始
Print('---------------------
          Backup
----------------------------')
declare 
  @curHOSP_I varchar(6), 
  @lastHOSP_I varchar(6)
  
select @curHOSP_I= DataPeriod from tblDataPeriod where QType = 'HOSP_I'
set @lastHOSP_I = convert(varchar(6), dateadd(month, -1, cast(@curHOSP_I+'01' as datetime)), 112)

--产品 定义表
exec('
if object_id(N''BMSCNProc_bak.dbo.tblPackageXRefHosp_'+@lastHOSP_I+''',N''U'') is null
   select * into BMSCNProc_bak.dbo.tblPackageXRefHosp_'+@lastHOSP_I+'
   from tblPackageXRefHosp
');
--市场 定义表
exec('
if object_id(N''BMSCNProc_bak.dbo.tblQueryToolDriverHosp_'+@lastHOSP_I+''',N''U'') is null
   select * into BMSCNProc_bak.dbo.tblQueryToolDriverHosp_'+@lastHOSP_I+'
   from tblQueryToolDriverHosp
');
GO
--厂商
exec('
if object_id(N''BMSCNProc_bak.dbo.tblDefManufacture_CN_EN_'+@lastHOSP_I+''',N''U'') is null
   select * into BMSCNProc_bak.dbo.tblDefManufacture_CN_EN_'+@lastHOSP_I+'
   from tblDefManufacture_CN_EN
')
GO






------------------------------------------------------------------------------------------------------------
--A.  产品定义部分：将源数据新增的产品添加到 产品定义表：tblPackageXRefHosp
------------------------------------------------------------------------------------------------------------

Print('------------------------------------------------------
1.1    Molecule  Definition:	tblDefMolecule_CN_EN
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



Print('------------------------------------------------------
1.2    Manufacture  Definition:	tblDefManufacture_CN_EN
------------------------------------------------------------')
-- 从源数据取New Add Manufacture
drop table Temp_newAddManufacture
GO
select distinct [Manufacture] into Temp_newAddManufacture
from inCPAData where [Manufacture] not in (select Manu_CN from dbo.tblDefManufacture_CN_EN)
GO
insert into Temp_newAddManufacture
select distinct [Manufacture] 
from inSeaRainbowData where [Manufacture] not in (select Manu_CN from dbo.tblDefManufacture_CN_EN)
GO

--为新增的Manufacture指定Manu_code ，Manu_EN 。然后插入到tblDefManufacture_CN_EN
drop table test_tblDefManufacture_CN_EN
GO
select * into  test_tblDefManufacture_CN_EN from tblDefManufacture_CN_EN where 1=0
GO

insert into test_tblDefManufacture_CN_EN(Manu_Cod,Manu_CN)
select 
	 c.Manu_code
	,b.Manufacture
from (
      --New Add Manufacture 排序
      select Manufacture, row_number() over(order by Manufacture) rnk
      from Temp_newAddManufacture
     ) b 
inner join 
    (
     -- Available Manu_code 排序
     select Manu_code, row_number() over (order by Manu_code) rnk
     from tempCodeingManu 
     where Manu_Code not in (select Manu_Cod from dbo.tblDefManufacture_CN_EN)
    ) c 
on b.rnk = c.rnk
GO
--根据客户给的inManuDef_IMS更新ManuNameEN
update test_tblDefManufacture_CN_EN  set Manu_EN=b.[name]
from test_tblDefManufacture_CN_EN a left join inManuDef_IMS b on a.Manu_CN=b.[namec]
GO
insert into tblDefManufacture_CN_EN  select * from test_tblDefManufacture_CN_EN where Manu_EN is not null
GO
delete from test_tblDefManufacture_CN_EN where Manu_EN is not null
GO

--特殊处理 (这部分厂的翻译客户没有给到):根据我们 网上找的翻译dbo.inManuDef_Gool 更新ManuNameEN
select N'本次手工网上Google翻译的 厂商 数量：'
select count(*) from test_tblDefManufacture_CN_EN where Manu_EN is null
GO

update test_tblDefManufacture_CN_EN  set Manu_EN=b.[name]
from test_tblDefManufacture_CN_EN a left join dbo.inManuDef_Gool b on a.Manu_CN=b.[namec]
GO
insert into tblDefManufacture_CN_EN  select * from test_tblDefManufacture_CN_EN where Manu_EN is not null
GO

--> 检查tblDefManufacture_CN_EN数据是否有误
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

select Manu_EN,count(Manu_CN) 
from tblDefManufacture_CN_EN
group by Manu_EN having count(Manu_CN) > 1

select Manu_CN,count(Manu_cod) 
from tblDefManufacture_CN_EN
group by Manu_CN having count(Manu_cod) > 1



Print('------------------------------------------------------
1.3 Product  Definition:tblDefProduct_CN_EN   TempNewProducts
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

--根据客户给的inProdDef_IMS更新没有英文的数据的Prod_EN
update tblDefProduct_CN_EN  set Prod_EN=b.[ENAME]  -- select *  
from tblDefProduct_CN_EN a inner join inProdDef_IMS b on a.Prod_CN=b.[NAMEC]
where Prod_EN is null
GO

delete from tblDefProduct_CN_EN where Prod_EN is null
GO 

--检查tblDefProduct_CN_EN 翻译数据是否有误
select Prod_CN
from tblDefProduct_CN_EN
group by Prod_CN having count(distinct Prod_EN) > 1



Print('----------------------------
2. 	Get new products from inCPAData
----------------------------------')
/* Get Products - Need manually mapping the product-EN

Step 1, run NewProd 1
Step 2, run NewProd 2
Step 3, Manually add new Prod CN-EN relations and Insert into table : tblDefProduct_CN_EN
Step 4, re-run NewProd 1
Step 5, run NewProd 3 ===> Get Products.

*/

/*==========NewProd 1==============*/
if object_id(N'TempNewProducts',N'U') is not null
	drop table TempNewProducts;
GO
select distinct a.NewMole, a.NewProd, a.NewProd_FullName, b.Mole_Code, b.Mole_EN, c.Prod_EN
into TempNewProducts
from (  
select distinct Molecule as NewMole, Product as NewProd, Product+'('+ltrim(rtrim(Manufacture))+')' as NewProd_FullName
from inCPAData t1 where y>2008
union 
select distinct Molecule as NewMole, Product as NewProd, Product+'('+ltrim(rtrim(Manufacture))+')' as NewProd_FullName
from inSeaRainbowData t1 where YM>200901
      ) a 
left join tblDefMolecule_CN_EN b on a.NewMole = b.Mole_CN 
left join tblDefProduct_CN_EN c  on a.NewProd=c.Prod_CN
order by NewMole, NewProd
GO

delete from TempNewProducts where Mole_Code is null
GO


/*==========NewProd 2==============*/

/*

select  distinct NewProd  from TempNewProducts where Prod_EN is null

对客户 没有给到的product翻译，手工为新产品添加 Prod_EN：

insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'二甲双胍格列吡嗪','METFORMIN&GLIPIZIDE')
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'二甲双胍格列本脲(Ⅰ)','METFORMIN&GLIBENCL(1)')
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'格列齐特(Ⅱ)','GLICLAZIDE(2)')
insert into tblDefProduct_CN_EN(Prod_CN, Prod_EN) values(N'酒石酸罗格列酮','Tartaric acid rosiglitazone')
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





Print(N'------------------------------------------------------
4.	为Products指定Product_code,Package_code。

    并insert into 产品市场定义表:tblPackageXRefHosp
------------------------------------------------------------')
truncate table tblPackageXRefHosp
GO

insert into tblPackageXRefHosp 
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
inner join TempNewProducts b 
on b.NewMole=a.Molecule 
   and b.NewProd=a.Product 
   and b.NewProd_FullName = a.Product+'('+ltrim(rtrim(a.Manufacture))+')'
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
inner join TempNewProducts b 
on b.NewMole=a.Molecule 
   and b.NewProd=a.Product 
   and b.NewProd_FullName = a.Product+'('+ltrim(rtrim(a.Manufacture))+')'
left join tblDefManufacture_CN_EN c
on a.Manufacture=c.Manu_CN
) t
GO

--Manu to Product_EN
update tblPackageXRefHosp set Product_EN = Product_EN+'('+Manu_SC+')'
GO
--> select * from tblPackageXRefHosp  where Product_EN is null  select distinct * from tblPackageXRefHosp



--指定唯一的product_code
update tblPackageXRefHosp set Product_code ='H'+Mole_Code_IMS
GO
--set the final product code
drop table test_tblPackageXRefHosp
GO
select distinct  Product_code, Product_EN 
into test_tblPackageXRefHosp from tblPackageXRefHosp
GO

update tblPackageXRefHosp set Product_code = b.Product_code + replicate('0',3-len(rnk)) + rnk
-- select *, b.Product_code + replicate('0',3-len(rnk)) + rnk
from tblPackageXRefHosp a
inner join (
select  Product_code, Product_EN
, cast(row_number() over(partition by Product_code order by Product_EN) as varchar) as rnk 
from test_tblPackageXRefHosp
) b 
on a.Product_code = b.Product_code and a.Product_EN = b.Product_EN
GO
--> select * from tblPackageXRefHosp order by Product_code,Product_EN 




--指定唯一的Package_code
update tblPackageXRefHosp set package_name  = Product_EN + Form_Src + Specification_Src 
GO
--set the final Package_code
drop table test_tblPackageXRefHosp
GO
select distinct Product_code, package_name
into test_tblPackageXRefHosp from tblPackageXRefHosp
GO

update tblPackageXRefHosp set Package_code = b.Product_code + replicate('0',2-len(rnk)) + rnk
-- select *,b.Product_code + replicate('0',2-len(rnk)) + rnk
from tblPackageXRefHosp a
inner join (
select Product_code,package_name
, cast(row_number() over(partition by Product_code order by package_name) as varchar) as rnk 
from test_tblPackageXRefHosp
) b 
on a.Product_code = b.Product_code and a.package_name = b.package_name
GO
--> select * from tblPackageXRefHosp order by Product_code,package_name




--特殊处理
update tblPackageXRefHosp set Manu_ID = Manu_SC 
where Manu_ID is null
GO

update tblPackageXRefHosp set MNC = 'N' 
where MNC is null
GO







--------->>检查是否所有产品都被加进来了 
--2.1 Product 级别:
drop table test
GO

select distinct t1.Molecule,t1.Product,t1.Manufacture   into test
from inCPAData t1 where y>2008 
and not exists (
select distinct
t2.Molecule_CN_Src ,t2.Product_CN_Src,t2.Manu_CN_Src
from tblPackageXRefHosp t2
where 
    t1.Molecule=t2.Molecule_CN_Src 
and t1.Product=t2.Product_CN_Src and t1.Manufacture=t2.Manu_CN_Src     
)
GO
insert into test 
select distinct t1.Molecule,t1.Product,t1.Manufacture   
from inSeaRainbowData t1 where YM>200901
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
where Molecule_CN_Src=N'二甲双胍' and Product_CN_Src=N'二甲双胍' and Manu_CN_Src=N'浙江亚太药业股份有限公司' 

select * from inCPAData 
where Molecule=N'二甲双胍' and Product=N'二甲双胍' and Manufacture=N'浙江亚太药业股份有限公司'

select * from inSeaRainbowData 
where Molecule=N'二甲双胍' and Product=N'二甲双胍' and Manufacture=N'浙江亚太药业股份有限公司'




--2.2 Package 级别:
drop table test
GO
select distinct t1.Molecule,t1.Product,t1.Manufacture,t1.Form,t1.Specification   into test
from inCPAData t1 where y>2008 
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
insert into test
select distinct t1.Molecule,t1.Product,t1.Manufacture,t1.FormI,t1.Specification   
from inSeaRainbowData t1 where YM>200901
and not exists (
select distinct
t2.Molecule_CN_Src ,t2.Product_CN_Src,t2.Manu_CN_Src,  t2.Form_Src ,t2.Specification_Src  
from tblPackageXRefHosp t2
where 
    t1.Molecule=t2.Molecule_CN_Src 
and t1.Product=t2.Product_CN_Src and t1.Manufacture=t2.Manu_CN_Src     
and t1.FormI=t2.Form_Src and t1.Specification=t2.Specification_Src  
)
GO

select * from test a
left join tblDefMolecule_CN_EN b on a.Molecule = b.Mole_CN 
where Mole_Code is not null order by Molecule,Product
GO

--进一步抽查：
select * from tblPackageXRefHosp 
where Molecule_CN_Src=N'二甲双胍' and Product_CN_Src=N'二甲双胍' and Manu_CN_Src=N'浙江亚太药业股份有限公司' 
and Form_Src=N'薄膜衣片' and Specification_Src=N'0.25g'

select * from inCPAData 
where Molecule=N'二甲双胍' and Product=N'二甲双胍' and Manufacture=N'浙江亚太药业股份有限公司' 
and Form=N'薄膜衣片' and Specification=N'0.25g'

select * from inSeaRainbowData 
where Molecule=N'二甲双胍' and Product=N'二甲双胍' and Manufacture=N'浙江亚太药业股份有限公司' 
and FormI=N'薄膜衣片' and Specification=N'0.25g'









select * from tblPackageXRefHosp

--------->>查询相同product具有   不同的Product_Code
select Molecule_CN_Src,Product_CN_Src,Manu_CN_Src
from tblPackageXRefHosp
group by Molecule_CN_Src,Product_CN_Src,Manu_CN_Src having count(distinct Product_Code)>1

--------->>查询相同Package具有   不同的Package_Code
select  Product_Code,Package_Name
from tblPackageXRefHosp
group by Product_Code,Package_Name having count(distinct Package_Code)>1
--查询相同Package具有   几个Package_Code
select a.* from tblPackageXRefHosp a,
(
select  Product_Code,Package_Name
from tblPackageXRefHosp
group by Product_Code,Package_Name having count(Package_Code)>1
) b
where a.Product_Code=b.Product_Code and a.Package_Name=b.Package_Name
order by  a.Product_Code, a.Package_Name



------------------------------------------------------------------------------------------------------------
--B.  市场定义部分：
------------------------------------------------------------------------------------------------------------
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
and ltrim(rtrim(substring(Prod_Des,1,charindex('(',Prod_Des)-1))) 
not in ('ACERTIL','LOTENSIN','MONOPRIL','TRITACE')
GO

-->处理结束








select '
------------------------------------------------------------------------------------------------------------------------
校验脚本：
------------------------------------------------------------------------------------------------------------------------
'