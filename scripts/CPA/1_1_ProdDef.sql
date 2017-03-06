/* 
修改时间: 2013/4/23 11:28:11
修改内容: 将Hosp的定义部分前后统一到一起(原因：不统一，前后会产生很大差异问题，而且前面一直是加不进来新产品的。)

维护方式：半手工


处理内容：产品定义，将源数据新增的产品添加到 产品定义表： tblPackageXRefHosp

前置依赖：BMSChinaCIA_IMS.dbo.tblMktDef_Inline

*/
--Time:01:30

use BMSChinaMRBI--DB4
GO

exec dbo.sp_Log_Event 'process data','CIA_CPA','1_1_ProdDef.sql','Start',null,null







Print('---------------------
          Backup
----------------------------')
declare 
  @curHOSP_I varchar(6), 
  @lastHOSP_I varchar(6)
  
select @curHOSP_I= Value1 from tblDSDates where Item = 'CPA'  
set @lastHOSP_I = convert(varchar(6), dateadd(month, -1, cast(@curHOSP_I+'01' as datetime)), 112)

-- 产品 定义表
exec('
if object_id(N''BMSChinaMRBI_Repository.dbo.tblPackageXRefHosp_'+@lastHOSP_I+''',N''U'') is null
   select * into BMSChinaMRBI_Repository.dbo.tblPackageXRefHosp_'+@lastHOSP_I+'
   from tblPackageXRefHosp
');
-- Manufacture_CN_EN
exec('
if object_id(N''BMSChinaMRBI_Repository.dbo.tblDefManufacture_CN_EN_'+@lastHOSP_I+''',N''U'') is null
   select * into BMSChinaMRBI_Repository.dbo.tblDefManufacture_CN_EN_'+@lastHOSP_I+'
   from tblDefManufacture_CN_EN
');
-- Product_CN_EN
exec('
if object_id(N''BMSChinaMRBI_Repository.dbo.tblDefProduct_CN_EN_'+@lastHOSP_I+''',N''U'') is null
   select * into BMSChinaMRBI_Repository.dbo.tblDefProduct_CN_EN_'+@lastHOSP_I+'
   from tblDefProduct_CN_EN
')
GO








Print('------------------------------------------------------
1.1    Molecule  Definition:	tblDefMolecule_CN_EN
------------------------------------------------------------')
-- select  * from tblDefMolecule_CN_EN
if object_id(N'tblDefMolecule_CN_EN',N'U') is not null
	drop table tblDefMolecule_CN_EN;
GO
select distinct 
	  b.Mole_Cod as Mole_Code
	, a.MoleculeEN as Mole_EN
	, a.MoleculeCN as Mole_CN
into tblDefMolecule_CN_EN
--  select * 
from tblMoleConfig  a -- include all Molecule CN-EN for in-line Market(历史的，一直没有更新过。)(Aric与2013/5/23 17:09:08进行了改造)(Eddy于2016/11/03 11:10有修改)
inner join  
      (
       select distinct Mole_Cod, Mole_Des 
       from BMSChinaCIA_IMS.dbo.tblMktDef_Inline where Mole_des <> 'RIVAROXABAN'
       --todo 针对Eliquis market进行的特殊处理2013/6/19 17:18:02
       union 
       select '999999', 'RIVAROXABAN'
	   union
       select distinct mole_cod,mole_des from BMSChinaCIA_IMS.dbo.tblMktDef_atcdriver where prod_des in('PRADAXA','ARIXTRA')
      ) b
on a.MoleculeEN = b.Mole_Des
GO
--Add OTC Related Molecule

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values(null,'Pseudoephedrine hydrochloride mixture',N'复方盐酸伪麻黄碱')

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (null,'Pseudoephedrine hydrochloride mixture',N'复方麻黄碱')
	  
insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (null,'Multiple vitamin',N'多维元素')

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values  (null,'CPH&CDH',N'氨酚伪麻美芬片/氨麻美敏片Ⅱ')

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (null,'CPH&CDH',N'氨麻美敏')

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (null,'Compound Pseudoephedrine Hydrochloride',N'酚麻美敏')

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values(null,'CPHII',N'氨麻苯美')

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (null,'CPHII',N'氨酚伪麻美芬片II/氨麻苯美片')	  

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (null,'PEMETREXED',N'培美曲塞')	

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (null,'Thioctic acid',N'α-硫辛酸')	

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (null,'Kinedak',N'依帕司他')	

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (239900,'Warfarin',N'华法林')	

-- insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
-- values (null,'Warfarin Sodium',N'华法林钠')	

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (null,'Pioglitazone',N'吡格列酮二甲双胍')	

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (null,'Melformin Hydrochioride',N'复方二甲双胍格列吡嗪')	

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (null,'Plavix',N'氢氯吡格雷')	

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (null,'Plavix',N'氯吡格雷')	

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (null,'Zincsulfate',N'硫酸锌')	

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (null,'acetylsalicylic acid',N'阿司匹林')	

-- 20161103 dulplicate record
-- insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
-- values (null,'Heparin sodium',N'肝素钠')	

-- insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
-- values (null,'Dalteparin Sodium',N'达肝素钠')	

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (null,'TENOFOVIR DISOPROXIL',N'替诺福韦/二吡呋酯')	

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (null,'BJHAFWMMFPAMBMP',N'氨酚伪麻美芬片Ⅱ/氨麻苯美片')	

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN)
values (408827,'Dalteparin Sodium',N'达肝素')	


--insert into tblMoleConfig select N'磺达肝癸钠','FONDAPARINUX SODIUM',000000,N'历史数据'
--insert into tblMoleConfig select N'福辛普利钠','Fosinopril',000000,N'历史数据'
--insert into tblMoleConfig select N'氯沙坦钾','Losartan',000000,N'历史数据'
--insert into tblMoleConfig select N'培哚普利吲达帕胺','Perindopril',000000,N'历史数据'
--insert into tblMoleConfig select N'紫杉醇脂质体','PACLITAXEL',000000,N'历史数据'
--insert into tblMoleConfig select N'那曲肝素钙','NADROPARIN CALCIUM',000000,N'历史数据'
--insert into tblMoleConfig select N'替诺福韦二吡呋酯','TENOFOVIR DISOPROXIL',000000,N'历史数据'
--insert into tblMoleConfig select N'依诺肝素','ENOXAPARIN SODIUM',000000,N'历史数据'
update a
set a.Mole_Code=b.Mole_Code
from tblDefMolecule_CN_EN a join (
	select distinct mole_en,right('000000'+convert(varchar(8),dense_rank() over(order by Mole_EN)),7) as Mole_Code
	from tblDefMolecule_CN_EN where Mole_Code is null
) b on a.Mole_En=b.Mole_En
where a.Mole_Code is null

insert into tblDefMolecule_CN_EN(Mole_Code,Mole_EN,Mole_CN) 
select Mole_Code,'PEMETREXED',N'培美曲塞二钠' from tblDefMolecule_CN_EN where mole_cn=N'培美曲塞'



--检查tblDefMolecule_CN_EN数据是否有误
select Mole_CN,count(Mole_EN) 
from tblDefMolecule_CN_EN
group by Mole_CN having count(Mole_EN) > 1

select Mole_CN,count(Mole_Code) 
from tblDefMolecule_CN_EN
group by Mole_CN having count(Mole_Code) > 1

select N'***请查看下面相同Mole_Code对应的是否属于同一个产品，即同一个Molecule,只是中文叫法不同:***'
select * from  tblDefMolecule_CN_EN 
where Mole_Code in (
         select a.Mole_Code from tblDefMolecule_CN_EN a
         inner join (
                     --这种情况必须是同一个产品，即同一个Molecule,只是中文叫法不同。
                     select Mole_Code,Mole_EN
                     from tblDefMolecule_CN_EN
                     where Mole_Code is not null
                     group by  Mole_Code,Mole_EN having count(Mole_CN) > 1
                     ) b 
         on a.Mole_Code=b.Mole_Code and a.Mole_EN=b.Mole_EN
) 



Print(N'
------------------------------------------------------------------------
1.2    Manufacture  Definition:	tblDefManufacture_CN_EN(追加方式)
------------------------------------------------------------------------')
-- 从源数据取New Add Manufacture
if object_id(N'Temp_newAddManufacture',N'U') is not null
	drop table Temp_newAddManufacture;
GO
select distinct [Manufacture] into Temp_newAddManufacture
from inCPAData where [Manufacture] not in (select Manu_CN from dbo.tblDefManufacture_CN_EN)
GO
insert into Temp_newAddManufacture
select distinct [Manufacture] 
from inSeaRainbowData where [Manufacture] not in (select Manu_CN from dbo.tblDefManufacture_CN_EN)
GO
insert into Temp_newAddManufacture
select distinct [Manufacture] 
from inPharmData where [Manufacture] not in (select Manu_CN from dbo.tblDefManufacture_CN_EN)
if object_id(N'Temp_newAddManufacture_b',N'U') is not null
	drop table Temp_newAddManufacture_b;
GO
select distinct Manufacture into Temp_newAddManufacture_b from Temp_newAddManufacture
if object_id(N'Temp_newAddManufacture',N'U') is not null
	drop table Temp_newAddManufacture;
GO
select * into Temp_newAddManufacture from Temp_newAddManufacture_b

-- 为新增的Manufacture指定Manu_code ，Manu_EN 。然后插入到tblDefManufacture_CN_EN
if object_id(N'test_tblDefManufacture_CN_EN',N'U') is not null
	drop table test_tblDefManufacture_CN_EN;
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
insert into tblDefManufacture_CN_EN  
select * from test_tblDefManufacture_CN_EN where Manu_EN is not null
GO
delete from test_tblDefManufacture_CN_EN where Manu_EN is not null
GO

--特殊处理 (这部分厂的翻译客户没有给到):根据我们 网上找的翻译dbo.inManuDef_Gool 更新ManuNameEN
select N'本次手工网上Google翻译的 厂商：'
select * from test_tblDefManufacture_CN_EN where Manu_EN is null
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
--select  * from tblDefManufacture_CN_EN where manu_en in ('American Pharmaceutical Partners, Inc','Shanghai Xinyi Pharmaceutical Co., Ltd.')
--delete from tblDefManufacture_CN_EN where manu_cn=N'Abraxis BioScience, LLC （US）'

select Manu_CN,count(Manu_cod) 
from tblDefManufacture_CN_EN
group by Manu_CN having count(Manu_cod) > 1





Print('------------------------------------------------------
1.3 Product  Definition:tblDefProduct_CN_EN   TempProducts
------------------------------------------------------------')
if object_id(N'tblDefProduct_CN_EN',N'U') is not null
	drop table tblDefProduct_CN_EN;
GO
select distinct 
	productcn as Prod_CN
  , producten as Prod_EN 
into tblDefProduct_CN_EN
from tblProdConfig --include all Product CN-EN for in-line Market(历史的，一直没有更新过。)(Eddy 更新于20161103)
GO
--update tblProdConfig set producten='QI ZHI PING'  where productcn=N'齐致平'
--update tblProdConfig set producten='BAI XING FU'  where productcn=N'百兴服'

insert into tblDefProduct_CN_EN(Prod_CN)
select distinct Product from inCPAData 
where Product not in (select Prod_CN from dbo.tblDefProduct_CN_EN) and Molecule in (select Mole_CN from tblDefMolecule_CN_EN)
union 
select distinct Product from inSeaRainbowData 
where Product not in (select Prod_CN from dbo.tblDefProduct_CN_EN) and Molecule in (select Mole_CN from tblDefMolecule_CN_EN)
union
select distinct Product from inPharmData 
where Product not in (select Prod_CN from dbo.tblDefProduct_CN_EN) and Molecule in (select Mole_CN from tblDefMolecule_CN_EN)
GO

--根据客户给的inProdDef_IMS 更新没有英文的数据的Prod_EN
update tblDefProduct_CN_EN  set Prod_EN=b.[ENAME]  -- select *  
from tblDefProduct_CN_EN a inner join inProdDef_IMS b on a.Prod_CN=b.[NAMEC]
where Prod_EN is null
GO
update tblDefProduct_CN_EN  set Prod_EN=b.[ENAME]  -- select *  
from tblDefProduct_CN_EN a inner join inProdDef_Gool b on a.Prod_CN=b.[NAMEC]
where Prod_EN is null
GO

--特殊处理 ( 对客户 没有给到的product翻译 ):根据我们 网上找的翻译dbo.inProdDef_Gool 更新Prod_CN
select N'本次手工网上Google翻译的 product：'
select * from tblDefProduct_CN_EN where Prod_EN is null
GO

update tblDefProduct_CN_EN  set Prod_EN=b.[ENAME]  -- select *  
from tblDefProduct_CN_EN a inner join inProdDef_Gool b on a.Prod_CN=b.[NAMEC]
where Prod_EN is null
GO


--检查tblDefProduct_CN_EN 翻译数据是否有误
select Prod_CN
from tblDefProduct_CN_EN
group by Prod_CN having count(distinct Prod_EN) > 1





Print('--------------------------------------------------------
2. 	Get new products from rowdata
--------------------------------------------------------------')
/* Get Products - Need manually mapping the product-EN

Step 1, run NewProd 1
Step 2, run NewProd 2
Step 3, Manually add new Prod CN-EN relations and Insert into table : tblDefProduct_CN_EN
Step 4, re-run NewProd 1
Step 5, run NewProd 3 ===> Get Products.

*/

/*==========NewProd 1==============*/
if object_id(N'TempProducts',N'U') is not null
	drop table TempProducts;
GO
select distinct a.Mole, a.Prod, a.Prod_FullName, b.Mole_Code, b.Mole_EN, c.Prod_EN
into TempProducts
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
inner join tblDefMolecule_CN_EN b on a.Mole = b.Mole_CN 
left join tblDefProduct_CN_EN c  on a.Prod=c.Prod_CN
order by Mole, Prod
GO


-- select * from TempProducts where Mole_Code is null



/*==========NewProd 2==============*/

/*

select  distinct Prod  from TempProducts where Prod_EN is null




*/


/*==========NewProd 3==============*/
--select *  from TempProducts

--检查tblDefProduct_CN_EN 翻译数据是否有误
select Prod
from TempProducts
group by Prod having count(distinct Prod_EN) > 1

select Mole
from TempProducts
group by Mole having count(distinct Mole_EN) > 1

select Mole
from TempProducts
group by Mole having count(distinct Mole_Code) > 1




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
	inner join TempProducts b 
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
	inner join TempProducts b 
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
		 , 'PHA' as Source, c.Manu_EN
		 , Null as NewFlag
	from 
		 inPharmData a 
	inner join TempProducts b 
	on b.Mole=a.Molecule 
	   and b.Prod=a.Product 
	   and b.Prod_FullName = a.Product+'('+ltrim(rtrim(a.Manufacture))+')'
	left join tblDefManufacture_CN_EN c
	on a.Manufacture=c.Manu_CN

) t
--GO
------相同厂商名修改

--update tblPackageXRefHosp set manu_cn_src=N'江苏苏州长征－欣凯制药有限公司' ,manu_id='JF9',manu_sc='JF9',
--manu_en='The Jiangsu Suzhou Long March - the Xinkai Pharmaceutical Co., Ltd.'
--where manu_cn_src=N'苏州长征-欣凯制药有限公司'

--update tblPackageXRefHosp set manu_cn_src=N'江苏正大天晴药业股份有限公司' ,manu_id='IY4',manu_sc='IY4',
--manu_en='JCTT Pharmaceutical Co., Ltd.'
--where manu_cn_src=N'正大天晴药业集团股份有限公司'

--update tblPackageXRefHosp set manu_cn_src=N'海南中和药业有限公司' ,manu_id='M2098',manu_sc='FR9',
--manu_en='HAINAN ZHONGHE PH'
--where manu_cn_src=N'海南中和药业股份有限公司'

--update tblPackageXRefHosp set manu_cn_src=N'福建广生堂药业有限公司' ,manu_id='M603',manu_sc='XE7',
--manu_en='FJ.COSUNTER PHARM'
--where manu_cn_src=N'福建广生堂药业股份有限公司'

--update tblPackageXRefHosp set manu_cn_src=N'浙江福韦药业有限公司' ,manu_id='KY6',manu_sc='KY6',
--manu_en='Zhejiang Dipivoxil Pharmaceutical Co., Ltd.'
--where manu_cn_src=N'浙江安科福韦药业有限公司'


--update tblPackageXRefHosp set manu_cn_src=N'江苏苏州东瑞制药有限公司' ,manu_id='JC7',manu_sc='JC7',
--manu_en='Dawnrays Pharmaceutical Co., Ltd., Jiangsu Suzhou'
--where manu_cn_src=N'苏州东瑞制药有限公司'

--update tblPackageXRefHosp set manu_cn_src=N'瑞士诺华制药有限公司' ,manu_id='M578',manu_sc='WF8',
--manu_en='NOVARTIS'
--where manu_cn_src=N'北京诺华制药有限公司'

--update tblPackageXRefHosp set manu_cn_src=N'北京双鹭药业有限公司' ,manu_id='BO4',manu_sc='BO4',
--manu_en='Beijing SL Pharmaceutical Co., Ltd.'
--where manu_cn_src=N'北京双鹭药业股份有限公司'

--update tblPackageXRefHosp set manu_cn_src=N'北京悦康药业有限公司' ,manu_id='CH6',manu_sc='CH6',
--manu_en='Beijing Yuekang Pharmaceutical Co., Ltd.'
--where manu_cn_src=N'悦康药业集团有限公司'

--update tblPackageXRefHosp set manu_cn_src=N'山东齐鲁制药有限公司' ,manu_id='FD5',manu_sc='FD5',
--manu_en='Shandong Qilu Pharmaceutical Co., Ltd.'
--where manu_cn_src=N'齐鲁制药有限公司'

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

-----------------------------------------------------
--					OTC Market packageXRefHosp
-----------------------------------------------------








Print(N'----------------------------------------------------------------------------------------------------
        下面为校验脚本：
------------------------------------------------------------------------------------------------------------')

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

insert into test 
select distinct t1.Molecule,t1.Product,t1.Manufacture   
from inPharmData t1 where y>2008 
and not exists (
select distinct
t2.Molecule_CN_Src ,t2.Product_CN_Src,t2.Manu_CN_Src
from tblPackageXRefHosp t2
where 
    t1.Molecule=t2.Molecule_CN_Src 
and t1.Product=t2.Product_CN_Src and t1.Manufacture=t2.Manu_CN_Src     
)
go

select * from test a
left join tblDefMolecule_CN_EN b on a.Molecule = b.Mole_CN 
where Mole_Code is not null






--2.2 Package 级别:
drop table test
GO
select distinct t1.Molecule,t1.Product,t1.Manufacture,t1.Form,convert(nvarchar(500),t1.Specification) as Specification  into test
from inPharmData t1 where y>2008 
and not exists (
select distinct
t2.Molecule_CN_Src ,t2.Product_CN_Src,t2.Manu_CN_Src,  t2.Form_Src ,t2.Specification_Src  
from tblPackageXRefHosp t2
where 
    t1.Molecule=t2.Molecule_CN_Src 
and t1.Product=t2.Product_CN_Src and t1.Manufacture=t2.Manu_CN_Src     
and t1.Form=t2.Form_Src and t1.Specification=t2.Specification_Src  
)
go
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
insert into test
select distinct t1.Molecule,t1.Product,t1.Manufacture,t1.Form,convert(nvarchar(500),t1.Specification) as Specification 
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



select * from test a
left join tblDefMolecule_CN_EN b on a.Molecule = b.Mole_CN 
where Mole_Code is not null order by Molecule,Product
GO










select * from tblPackageXRefHosp where Mole_Code_IMS is null or Product_Code is null or Package_Code is null 

--------->>查询相同product具有   不同的Product_Code
select Molecule_CN_Src,Product_CN_Src,Manu_CN_Src
from tblPackageXRefHosp
group by Molecule_CN_Src,Product_CN_Src,Manu_CN_Src having count(distinct Product_Code)>1

--------->>查询相同Package具有   不同的Package_Code
select a.* from tblPackageXRefHosp a,
(

select  Product_Code,Package_Name
from tblPackageXRefHosp
group by Product_Code,Package_Name having count(distinct Package_Code)>1

) b
where a.Product_Code=b.Product_Code and a.Package_Name=b.Package_Name
order by  a.Product_Code, a.Package_Name

exec dbo.sp_Log_Event 'process data','CIA_CPA','1_1_ProdDef.sql','End',null,null


print 'over!'