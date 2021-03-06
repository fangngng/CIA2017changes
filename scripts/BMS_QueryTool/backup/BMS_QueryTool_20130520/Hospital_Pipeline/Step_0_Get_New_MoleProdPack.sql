use BMSCNProc2
go


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++                         第一部分： 定义表准备部分                                        ++--
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


--中英文翻译处理：

-- select * from tblMolecule_CN_EN_PipeLine ：molecule中英文翻译

--缺失的中英文对照
select distinct Molecule_EN from inPipelineMarketDefinition
except 
select distinct Mole_Des from tblMolecule_CN_EN_PipeLine

--网上翻译
delete from tblMolecule_CN_EN_PipeLine_Google
insert into tblMolecule_CN_EN_PipeLine_Google values(N'阿卡波糖' , 'ACARBOSE') 
insert into tblMolecule_CN_EN_PipeLine_Google values(N'格列本脲' , 'GLIBENCLAMIDE') 
insert into tblMolecule_CN_EN_PipeLine_Google values(N'格列齐特' , 'GLICLAZIDE') 
insert into tblMolecule_CN_EN_PipeLine_Google values(N'格列美脲' , 'GLIMEPIRIDE') 
insert into tblMolecule_CN_EN_PipeLine_Google values(N'格列吡嗪' , 'GLIPIZIDE') 
insert into tblMolecule_CN_EN_PipeLine_Google values(N'格列喹酮' , 'GLIQUIDONE') 
insert into tblMolecule_CN_EN_PipeLine_Google values(N'人肿瘤坏死因子-0受体II：IG G FC融合蛋白','HUMAN TNF-0 RECEPTOR II: IG G FC FUSION PROTEIN') 
insert into tblMolecule_CN_EN_PipeLine_Google values(N'二甲双胍'	,'METFORMIN') 
insert into tblMolecule_CN_EN_PipeLine_Google values(N'那格列奈'	,'NATEGLINIDE') 
insert into tblMolecule_CN_EN_PipeLine_Google values(N'吡格列酮'  ,'PIOGLITAZONE') 
insert into tblMolecule_CN_EN_PipeLine_Google values(N'瑞格列奈'	,'REPAGLINIDE') 
insert into tblMolecule_CN_EN_PipeLine_Google values(N'罗格列酮'	,'ROSIGLITAZONE') 
insert into tblMolecule_CN_EN_PipeLine_Google values(N'伏格列波糖','VOGLIBOSE')
GO

--insert
insert into tblMolecule_CN_EN_PipeLine
select * from tblMolecule_CN_EN_PipeLine_Google 
where Molecule_CN_Src in( 
select distinct 药品名称 from inCPAData_pipeline
) --过滤掉在源数据找不到数据的
GO






--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++                         第二部分： 产品定义部分                                          ++--
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--备份
select * into BMSCNProc_bak.dbo.tblPackageXRefCPA_Pipeline_2012Q4All
from tblPackageXRefCPA_Pipeline
GO
--	select * from tblPackageXRefCPA_Pipeline
update tblPackageXRefCPA_Pipeline set newFlag='N' --Before this processor, set newflag = 'N'
GO


Print('------------------------------------------------------
1.  Manufacture  Definition:	tblDefManufacture_CN_EN
------------------------------------------------------------')
--备份
drop table tblDefManufacture_CN_EN_bak
GO
select * into tblDefManufacture_CN_EN_bak
from tblDefManufacture_CN_EN
GO
--  select * from tblDefManufacture_CN_EN
drop table Temp_newAddManufacture
GO
select distinct 生产厂家 
into Temp_newAddManufacture
from inCPAData_pipeline 
where 生产厂家 not in (select Manu_CN from tblDefManufacture_CN_EN)
GO

--> select * from Temp_newAddManufacture

--为新增的Manufacture指定Manu_code ，然后插入到tblDefManufacture_CN_EN
drop table test_tblDefManufacture_CN_EN
GO
select * into  test_tblDefManufacture_CN_EN from tblDefManufacture_CN_EN where 1=0
GO
insert into test_tblDefManufacture_CN_EN(Manu_Cod,Manu_CN,SourceFlag)
select 
	 c.Manu_code
	,b.生产厂家
    ,'inCPAData_pipeline'
from (
      --New Add Manufacture  排序
      select 生产厂家, row_number() over(order by 生产厂家) rnk
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
--> select * from test_tblDefManufacture_CN_EN

--根据客户给IMS的inManuDef_IMS更新ManuNameEN
update test_tblDefManufacture_CN_EN  set Manu_EN=b.[name]
from test_tblDefManufacture_CN_EN a left join inManuDef_IMS b on a.Manu_CN=b.[namec]
GO
insert into tblDefManufacture_CN_EN  
select * from test_tblDefManufacture_CN_EN where Manu_EN is not null
GO
delete from test_tblDefManufacture_CN_EN where Manu_EN is not null
GO

--特殊处理 (这部分厂的翻译我们在现有系统中找不到):根据我们 网上找的翻译dbo.inManuDef_Gool 更新ManuNameEN
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
from 
--test_tblDefManufacture_CN_EN
tblDefManufacture_CN_EN
group by Manu_CN having count(Manu_EN) > 1
) 
GO

select Manu_CN,count(Manu_cod) 
from tblDefManufacture_CN_EN
group by Manu_CN having count(Manu_cod) > 1




Print('----------------------------------------------------------------
2.  Molecule Definition : tblDefMolecule_CN_EN_PipeLine
----------------------------------------------------------------------')
if object_id(N'tblDefMolecule_CN_EN_PipeLine',N'U') is not null
	drop table tblDefMolecule_CN_EN_PipeLine;
GO
--get Mole_Code
select distinct b.Molecule_Code as Mole_Code, b.Molecule_Name as Mole_EN, a.Molecule_CN_Src as Mole_CN
into tblDefMolecule_CN_EN_PipeLine
from tblMolecule_CN_EN_PipeLine  a ----include All Molecule EN-CN for pipeline
left join (
          select distinct Molecule_Code, Molecule_Name
          from DB4.IMSDBPlus.dbo.Dim_Molecule where Molecule_Name in(
          select distinct MOlecule_EN from inPipelineMarketDefinition
          ) 
) b
on a.Mole_Des = b.Molecule_Name
GO

delete -- select * 
from tblDefMolecule_CN_EN_PipeLine
where Mole_Code is null 
and  Mole_EN not in(
          select distinct MOlecule_EN from inPipelineMarketDefinition
          ) 
GO




Print('----------------------------------------------------------------
3.  将产品定义到产品定义表：tblPackageXRefCPA_Pipeline
----------------------------------------------------------------------')

/* 
Get new products from inCPAData_Pipeline:

Step 1, run NewProd 1
Step 2, run NewProd 2
Step 3, Manually add new Prod CN-EN relations and Insert into table - tblDefProduct_CN_EN_pipeline
Step 4, re-run NewProd 1
Step 5, run NewProd 3 ===> Get new products
Step 6, run NewProd 4 ===> assign Product_code,Package_code. 
*/

/*==========NewProd 1==============*/
if object_id(N'TempNewProducts_pipeline',N'U') is not null
	drop table TempNewProducts_pipeline;
GO
select a.NewMole, a.NewProd, b.Mole_Code, b.Mole_EN, c.Prod_EN
into TempNewProducts_pipeline
from (
     	select distinct 药品名称 as NewMole, 商品名 as NewProd
     	from inCPAData_pipeline where 药品名称 in(
        select Mole_CN from tblDefMolecule_CN_EN_PipeLine
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

--产品翻译表:tblDefProduct_CN_EN_pipeline  
--暂时没有更新脚本及客户数据  只能先从客户给的Hospital的product翻译inProdDef 来找Prod_EN
--如何还没有找的部分就用 google网上找翻译 手工加进去。

update tblDefProduct_CN_EN_pipeline set Prod_EN = 
from tblDefProduct_CN_EN_pipeline a 
left join inProdDef b on a.Prod_CN=b.NAMEC
GO

/*

手工为新产品添加 Prod_EN：
insert into tblDefProduct_CN_EN_pipeline(Prod_CN, Prod_EN) values(N'悦康普欣','Yue Kang Pu Xin')

*/

/*==========NewProd 3==============*/
select * from TempNewProducts_pipeline

Print (N'------------------------------------------------------
    为新Products指定Product_code,Package_code。
    并insert into 产品市场定义表:tblPackageXRefCPA_Pipeline
------------------------------------------------------------')
truncate table tblPackageXRefCPA_Pipeline
GO
insert into tblPackageXRefCPA_Pipeline
select distinct 
   b.Mole_Code 
   , a.药品名称 as Molecule_CN
   , a.商品名 as Product_CN_Src
   , a.剂型 as Form_Src, a.规格 as Strength_Src
   , a.生产厂家 as Manuf_CN_Src
   , Null as Pack_Cod
   , Null as NewFlag
   , Null as Prod_Code
   ,b.Prod_EN+'('+c.Manu_Cod+')' as Prod_EN
   ,c.Manu_EN
   ,c.Manu_ID, c.MNC
from inCPAData_pipeline a 
inner join TempNewProducts_pipeline b on b.NewMole=a.药品名称 and b.NewProd=a.商品名
left join tblDefManufacture_CN_EN c on a.生产厂家=c.Manu_CN
GO

--> select * from tblPackageXRefCPA_Pipeline



/*==========NewProd 4==============*/

----1.  指定唯一的Prod_code
update tblPackageXRefCPA_Pipeline set Prod_code ='H'+Mole_Cod
GO
--1.2 set the final product code
drop table tblPackageXRefCPA_Pipeline_test
GO
select distinct  Prod_code, Prod_EN 
into tblPackageXRefCPA_Pipeline_test from tblPackageXRefCPA_Pipeline
GO

update tblPackageXRefCPA_Pipeline set Prod_code = b.Prod_code + replicate('0',2-len(rnk)) + rnk
-- select *, b.Prod_code + replicate('0',2-len(rnk)) + rnk
from tblPackageXRefCPA_Pipeline a
inner join (
select  Prod_code, Prod_EN
, cast(row_number() over(partition by Prod_code order by Prod_EN) as varchar) as rnk 
from tblPackageXRefCPA_Pipeline_test
) b 
on a.Prod_code = b.Prod_code and a.Prod_EN = b.Prod_EN
GO

select * from tblPackageXRefCPA_Pipeline order by Prod_code,Prod_EN

----2.  指定唯一的Pack_Cod
drop table tblPackageXRefCPA_Pipeline_test
GO
select distinct Prod_Code, form_src+Strength_Src as Pack_Des
into tblPackageXRefCPA_Pipeline_test from tblPackageXRefCPA_Pipeline
GO

--select * from tblPackageXRefCPA_Pipeline_test

update tblPackageXRefCPA_Pipeline set Pack_Cod = b.Prod_Code + replicate('0',2-len(rnk)) + rnk
-- select *,b.Prod_Code + replicate('0',2-len(rnk)) + rnk
from tblPackageXRefCPA_Pipeline a
inner join (
select Prod_Code, Pack_Des
, cast(row_number() over(partition by Prod_Code order by Pack_Des) as varchar) as rnk 
from tblPackageXRefCPA_Pipeline_test
) b 
on a.Prod_Code = b.Prod_Code and a.form_src+a.Strength_Src= b.Pack_Des
GO

select * from tblPackageXRefCPA_Pipeline order by Prod_Code,form_src,Strength_Src


--特殊处理
update tblPackageXRefCPA_Pipeline set MNC = 'N' 
where MNC is null
GO

-------------------------------------------------------------------------------------------检查新增产品是否正确:

--------->>查询: 相同Package多个Package_Code的  问题数据
select distinct Molecule_CN_Src,Product_CN_Src ,Manuf_CN_Src,Form_Src,Strength_Src ,count(distinct Pack_Cod)
from tblPackageXRefCPA_Pipeline 
group by Molecule_CN_Src,Product_CN_Src ,Manuf_CN_Src,Form_Src,Strength_Src having count(distinct Pack_Cod) > 1

--------->>查询: 相同product具有不同的Product_Code的  问题数据
select distinct Molecule_CN_Src,Product_CN_Src ,Manuf_CN_Src, count(distinct Prod_Code)
from tblPackageXRefCPA_Pipeline
group by Molecule_CN_Src,Product_CN_Src ,Manuf_CN_Src having count(distinct Prod_Code) > 1

select * from tblPackageXRefCPA_Pipeline 
where Molecule_CN_Src=N'奥扎格雷钠' and Product_CN_Src=N'凯泉'







--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++                         第三部分： 市场定义部分                                          ++--
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--back up
select * into tblQueryToolDriverHosp_Pipeline_2012Q4_all_Aric20130320
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
