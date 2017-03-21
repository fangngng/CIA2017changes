use BMSCNProc2_test
go









select N'需要增加的翻译：'
select distinct Molecule_EN from inPipelineMarketDefinition
except 
select distinct Mole_Des from tblMolecule_CN_EN_PipeLine

delete from tblMolecule_CN_EN_PipeLine_Google
insert into tblMolecule_CN_EN_PipeLine_Google values(N'阿卡波糖' , 'ACARBOSE') 
insert into tblMolecule_CN_EN_PipeLine_Google values(N'消渴丸' , 'GLIBENCLAMIDE') 
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

--201309月份
insert into tblMolecule_CN_EN_PipeLine_Google (Molecule_CN_Src,Mole_Des) 
values (N'达比加群酯','DABIGATRAN ETEXILATE')

insert into tblMolecule_CN_EN_PipeLine_Google (Molecule_CN_Src,Mole_Des) 
values (N'阿哌沙班','APIXABAN')
GO

--insert
insert into tblMolecule_CN_EN_PipeLine
select * from tblMolecule_CN_EN_PipeLine_Google 
where Molecule_CN_Src in( 
    select distinct 药品名称 from inCPAData_pipeline
    )
    and Molecule_CN_Src not in (
        select  distinct Molecule_CN_Src from tblMolecule_CN_EN_PipeLine
)
GO





--select * into BMSCNProc_bak.dbo.tblPackageXRefCPA_Pipeline_2012Q4All
--from tblPackageXRefCPA_Pipeline
if object_id(N'BMSCNProc_bak.dbo.tblPackageXRefCPA_Pipeline_2016Q1All',N'U') is null-- todo
	select * into BMSCNProc_bak.dbo.tblPackageXRefCPA_Pipeline_2016Q1All from tblPackageXRefCPA_Pipeline
GO


--	select * from tblPackageXRefCPA_Pipeline
update tblPackageXRefCPA_Pipeline set newFlag='N' 
GO


Print('------------------------------------------------------
1.  Manufacture  Definition:	tblDefManufacture_CN_EN
------------------------------------------------------------')
--备份
if object_id(N'tblDefManufacture_CN_EN__2016Q1All',N'U') is null
select * into tblDefManufacture_CN_EN__2016Q1All --todo
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
        select 生产厂家, row_number() over(order by 生产厂家) rnk 
		from Temp_newAddManufacture
	) b 
inner join (
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
select N'***********************需要翻译的厂商***********************'
select * from test_tblDefManufacture_CN_EN
--特殊处理 (这部分厂的翻译我们在现有系统中找不到):根据我们 网上找的翻译dbo.inManuDef_Gool 更新ManuNameEN

--insert into inManuDef_Gool (name,namec) values('CIPLA LTD, INDIA (ID)',N'CIPLA LTD,INDIA(ID)')
--insert into inManuDef_Gool (name,namec) values('Guangdong nine Ming pharmaceutical co., LTD',N'广东九明制药有限公司')
--insert into inManuDef_Gool (name,namec) values('Slovenia lai ke medicines and chemical products co., LTD',N'斯洛文尼亚莱柯药品及化学制品有限公司')

--Xiaoyu.Chen 2015-05-19
--insert into inManuDef_Gool(NAMEC,NAME) 
--values(N'Abraxis BioScience, LLC （US）','Abraxis BioScience, LLC （US）')

--insert into inManuDef_Gool(NAMEC,NAME) 
--values(N'上海信谊药厂有限公司','ShangHai XinYi Factory Pharmaceutical Co., Ltd.')

----吉林金恒制药股份有限公司
--insert into inManuDef_Gool(NAMEC,NAME) 
--values(N'吉林金恒制药股份有限公司','JiLin JinHeng Pharmaceutical Group Co., Ltd.')

--insert into inManuDef_Gool(NAMEC,NAME) 
--values(N'山西仟源制药股份有限公司','Shanxi Qianyuan Pharmaceutical Co., Ltd.')

--insert into inManuDef_Gool(NAMEC,NAME) 
--values(N'幸福医药有限公司 （HK）','XingFu Pharmaceutical Co., Ltd. (HK)')

--insert into inManuDef_Gool(NAMEC,NAME) 
--values(N'拜耳医药保健有限公司启东分公司','Bayer HealthCare, Sheng Branch')

--insert into inManuDef_Gool(NAMEC,NAME) 
--values(N'湖北华世通潜龙药业有限公司','Hubei WATERSTONE Qianlong Pharmaceutical Co., Ltd.')
--insert into inManuDef_Gool(NAMEC,NAME) 

--insert into inManuDef_Gool(NAMEC,NAME) 
--values(N'美国礼来制药公司 （US）','Eli Lilly & Company, US')

--insert into inManuDef_Gool(NAMEC,NAME) 
--values(N'南京东捷药业有限公司','The Nanjing Contrel Pharmaceutical Co., Ltd.')


/*
南京东捷药业有限公司
美国礼来制药公司 （US）
*/

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
-- eddy use hospital cn_en 
select distinct isnull(b.Molecule_Code, a.Mole_Code) as Mole_Code, a.Mole_EN as Mole_EN, a.Mole_CN as Mole_CN
into tblDefMolecule_CN_EN_PipeLine
from DB4.BMSChinaMRBI_test.dbo.tblDefMolecule_CN_EN  a ----include All Molecule EN-CN for pipeline
left join (
          select distinct Molecule_Code, Molecule_Name
          from Db4.BMSChinaCIA_IMS.dbo.Dim_Molecule where Molecule_Name in(
          select distinct MOlecule_EN from inPipelineMarketDefinition
          ) 
) b
on a.mole_en = b.Molecule_Name
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
     	from inCPAData_pipeline 
        where 药品名称 in(
            select Mole_CN from tblDefMolecule_CN_EN_PipeLine
            )
    ) a 
left join tblDefMolecule_CN_EN_PipeLine b on a.NewMole = b.Mole_CN 
left join DB4.BMSChinaMRBI_test.dbo.tblDefProduct_CN_EN c  on a.NewProd=c.Prod_CN
order by NewMole, NewProd
GO

delete from TempNewProducts_pipeline where Mole_Code is null
GO




update TempNewProducts_pipeline  set Prod_EN=b.[ENAME]  -- select *  
from TempNewProducts_pipeline a 
inner join DB4.BMSChinaMRBI_test.dbo.inProdDef_Gool b on a.NewProd=b.[NAMEC]
where a.Prod_EN is null
GO


/*==========NewProd 2==============*/
select N'本次手工网上Google翻译的 product：'
select *  from TempNewProducts_pipeline where Prod_EN is null
/*

人工翻译：
--2013/5/22 17:11:10
insert into DB4.BMSChinaMRBI_test.dbo.inProdDef_Gool(NAMEC,ENAME) values (N'噻氯匹定','Ticlopidine')

--2013/11/19
insert into DB4.BMSChinaMRBI_test.dbo.inProdDef_Gool(NAMEC,ENAME) values (N'泰毕全','PRADAXA (B.I)')
GO


*/

update a
set a.Prod_EN=b.ENAME
--select *
from TempNewProducts_pipeline a join DB4.BMSChinaMRBI_test.dbo.inProdDef_Gool b
on a.NewProd=b.namec
where a.Prod_EN is null


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

update tblPackageXRefCPA_Pipeline set Prod_code = b.Prod_code + replicate('0',3-len(rnk)) + rnk
-- select *, b.Prod_code + replicate('0',2-len(rnk)) + rnk
from tblPackageXRefCPA_Pipeline a
inner join (
    select  Prod_code, Prod_EN
        , cast(row_number() over(partition by Prod_code order by Prod_EN) as varchar) as rnk 
    from tblPackageXRefCPA_Pipeline_test
) b 
on a.Prod_code = b.Prod_code and a.Prod_EN = b.Prod_EN
GO
-- select * from tblPackageXRefCPA_Pipeline order by Prod_code,Prod_EN


----2.  指定唯一的Pack_Cod
drop table tblPackageXRefCPA_Pipeline_test
GO
select distinct Prod_Code, form_src+Strength_Src as Pack_Des
into tblPackageXRefCPA_Pipeline_test from tblPackageXRefCPA_Pipeline
GO
--select * from tblPackageXRefCPA_Pipeline_test

update tblPackageXRefCPA_Pipeline set Pack_Cod = b.Prod_Code + replicate('0',3-len(rnk)) + rnk
-- select *,b.Prod_Code + replicate('0',2-len(rnk)) + rnk
from tblPackageXRefCPA_Pipeline a
inner join (
    select Prod_Code, Pack_Des
        , cast(row_number() over(partition by Prod_Code order by Pack_Des) as varchar) as rnk 
    from tblPackageXRefCPA_Pipeline_test
) b 
on a.Prod_Code = b.Prod_Code and a.form_src+a.Strength_Src= b.Pack_Des
GO
-- select * from tblPackageXRefCPA_Pipeline order by Prod_Code,form_src,Strength_Src



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
if object_id(N'tblQueryToolDriverHosp_Pipeline_2016Q1_all',N'U') is null
select * into tblQueryToolDriverHosp_Pipeline_2016Q1_all --todo
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



