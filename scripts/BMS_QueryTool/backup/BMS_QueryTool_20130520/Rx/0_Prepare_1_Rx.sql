/*

处方数据   每半年更新一次

保存处理最近5年的数据

*/

use BMSCNProc2
go

update tblDataPeriod set DataPeriod = '201212' where QType = 'Rx'
GO


select * into inRx_Aric20130508
from inRx
GO


PRINT N'
--------------------------------------
一.  Importing latest data
--------------------------------------
'
if object_id(N'inRx',N'U') is not null
	drop table inRx
go
select 
	a.Area,a.[Date], a.source as [处方来源], a. Department as Dpt, a.expense as [报销] ,
	a.Mole_code as RxProd_Cod,b.[药品大类],b.[药品亚类],
	b.[中文通用名] as Molecule_CN,b.[英文名称] as Molecule_EN,
	a.Product as Product_CN, a. specifications as Strength,
	a.route as Form, a.Rx as Rx,
	a.unit as [取药数量], a.amount as Sales, cast(null as nvarchar(255)) 原始诊断
into inRx
from db4.BMSChinaMRBI.dbo.inRx a
inner join db4.BMSChinaOtherDB.dbo.inRx_MoleculeRef b on a.Mole_code  = b.[药品编码]
go


--特殊处理：中文通用名 的英文翻译错误 处理
update inRx set Molecule_EN = 'ACETYLSALICYLIC ACID'   where Molecule_CN = N'阿司匹林' 
update inRx set Molecule_EN = 'BATROXOBIN'             where Molecule_CN = N'巴曲酶(东菱克栓酶)' 
update inRx set Molecule_EN = 'BERAPROST'              where Molecule_CN = N'贝前列素钠' 
update inRx set Molecule_EN = 'CILOSTAZOL'             where Molecule_CN = N'西洛他唑' 
update inRx set Molecule_EN = 'CLOPIDOGREL'            where Molecule_CN = N'氯吡格雷' 
update inRx set Molecule_EN = 'OZAGREL'                where Molecule_CN = N'奥扎格雷钠' 
update inRx set Molecule_EN = 'SARPOGRELATE'           where Molecule_CN = N'沙格雷酯' 
update inRx set Molecule_EN = 'SULODEXIDE'             where Molecule_CN = N'舒络地特' 
update inRx set Molecule_EN = 'TICLOPIDINE'            where Molecule_CN = N'噻氯匹定' 
update inRx set Molecule_EN = 'TIROFIBAN'              where Molecule_CN = N'替罗非班' 
update inRx set Molecule_EN = 'DONEPEZIL'              where Molecule_CN = N'多奈哌齐' 
update inRx set Molecule_EN = 'HUPERZINE A'            where Molecule_CN = N'石杉碱甲' 
update inRx set Molecule_EN = 'MEMANTINE'              where Molecule_CN = N'美金刚' 
update inRx set Molecule_EN = 'RIVASTIGMINE'           where Molecule_CN = N'卡巴拉汀' 
update inRx set Molecule_EN = 'ENOXAPARIN SODIUM'      where Molecule_CN = N'依诺肝素钠' 
update inRx set Molecule_EN = 'HEPARIN'                where Molecule_CN = N'低分子肝素钠' 
update inRx set Molecule_EN = 'HEPARIN'                where Molecule_CN = N'肝素钠' 
update inRx set Molecule_EN = 'NADROPARIN CALCIUM'     where Molecule_CN = N'低分子肝素钙' 
update inRx set Molecule_EN = 'RIVAROXABAN'            where Molecule_CN = N'利伐沙班' 
update inRx set Molecule_EN = 'WARFARIN'               where Molecule_CN = N'华法林钠' 
update inRx set Molecule_EN = 'SORAFENIB'              where Molecule_CN = N'索拉非尼' 
update inRx set Molecule_EN = 'SUNITINIB'              where Molecule_CN = N'舒尼替尼' 
update inRx set Molecule_EN = 'PEGINTERFERON ALFA-2A'  where Molecule_CN = N'聚乙二醇干扰素α-2a' 
update inRx set Molecule_EN = 'PEGINTERFERON ALFA-2B'  where Molecule_CN = N'聚乙二醇干扰素α-2b' 
update inRx set Molecule_EN = 'ETANERCEPT'             where Molecule_CN = N'重组人Ⅱ型肿瘤坏死因子受体-抗体融合蛋白' 
update inRx set Molecule_EN = 'INFLIXIMAB'             where Molecule_CN = N'英夫利西单抗' 
GO

update tblProductList_Rx set Molecule_EN = 'ACETYLSALICYLIC ACID'   where Molecule_CN = N'阿司匹林' 
update tblProductList_Rx set Molecule_EN = 'BATROXOBIN'             where Molecule_CN = N'巴曲酶(东菱克栓酶)' 
update tblProductList_Rx set Molecule_EN = 'BERAPROST'              where Molecule_CN = N'贝前列素钠' 
update tblProductList_Rx set Molecule_EN = 'CILOSTAZOL'             where Molecule_CN = N'西洛他唑' 
update tblProductList_Rx set Molecule_EN = 'CLOPIDOGREL'            where Molecule_CN = N'氯吡格雷' 
update tblProductList_Rx set Molecule_EN = 'OZAGREL'                where Molecule_CN = N'奥扎格雷钠' 
update tblProductList_Rx set Molecule_EN = 'SARPOGRELATE'           where Molecule_CN = N'沙格雷酯' 
update tblProductList_Rx set Molecule_EN = 'SULODEXIDE'             where Molecule_CN = N'舒络地特' 
update tblProductList_Rx set Molecule_EN = 'TICLOPIDINE'            where Molecule_CN = N'噻氯匹定' 
update tblProductList_Rx set Molecule_EN = 'TIROFIBAN'              where Molecule_CN = N'替罗非班' 
update tblProductList_Rx set Molecule_EN = 'DONEPEZIL'              where Molecule_CN = N'多奈哌齐' 
update tblProductList_Rx set Molecule_EN = 'HUPERZINE A'            where Molecule_CN = N'石杉碱甲' 
update tblProductList_Rx set Molecule_EN = 'MEMANTINE'              where Molecule_CN = N'美金刚' 
update tblProductList_Rx set Molecule_EN = 'RIVASTIGMINE'           where Molecule_CN = N'卡巴拉汀' 
update tblProductList_Rx set Molecule_EN = 'ENOXAPARIN SODIUM'      where Molecule_CN = N'依诺肝素钠' 
update tblProductList_Rx set Molecule_EN = 'HEPARIN'                where Molecule_CN = N'低分子肝素钠' 
update tblProductList_Rx set Molecule_EN = 'HEPARIN'                where Molecule_CN = N'肝素钠' 
update tblProductList_Rx set Molecule_EN = 'NADROPARIN CALCIUM'     where Molecule_CN = N'低分子肝素钙' 
update tblProductList_Rx set Molecule_EN = 'RIVAROXABAN'            where Molecule_CN = N'利伐沙班' 
update tblProductList_Rx set Molecule_EN = 'WARFARIN'               where Molecule_CN = N'华法林钠' 
update tblProductList_Rx set Molecule_EN = 'SORAFENIB'              where Molecule_CN = N'索拉非尼' 
update tblProductList_Rx set Molecule_EN = 'SUNITINIB'              where Molecule_CN = N'舒尼替尼' 
update tblProductList_Rx set Molecule_EN = 'PEGINTERFERON ALFA-2A'  where Molecule_CN = N'聚乙二醇干扰素α-2a' 
update tblProductList_Rx set Molecule_EN = 'PEGINTERFERON ALFA-2B'  where Molecule_CN = N'聚乙二醇干扰素α-2b' 
update tblProductList_Rx set Molecule_EN = 'ETANERCEPT'             where Molecule_CN = N'重组人Ⅱ型肿瘤坏死因子受体-抗体融合蛋白' 
update tblProductList_Rx set Molecule_EN = 'INFLIXIMAB'             where Molecule_CN = N'英夫利西单抗' 
GO

--特殊处理：
select distinct 
RxProd_Cod,Molecule_cn,Product_CN
from inRx where Molecule_cn in (N'卡铂',N'顺铂',N'奈达铂')
order by Molecule_cn,Product_CN

update inRx set Product_CN = N'伯尔定'
where Molecule_cn in (N'卡铂',N'顺铂',N'奈达铂') and Product_CN = N'铂尔定'
GO
update inRx set Product_CN = N'捷佰舒'
where Molecule_cn in (N'卡铂',N'顺铂',N'奈达铂') and Product_CN = N'捷伯舒'
GO













PRINT N'
--------------------------------------
二.  refresh market definition 

--数据结构查看:
select top 10 *  from inRx
select top 10 *  from tblProductList_Rx
select top 10 *  from tblQueryToolDriverRx  
--------------------------------------
'
-- Backup driver tables
declare @indate  varchar(4)
select @indate=max(Date) from inRx
--产品定义表
exec('
if object_id(N''BMSCNProc_bak.dbo.tblProductList_Rx_'+@indate+'all'',N''U'') is null
select * into BMSCNProc_bak.dbo.tblProductList_Rx_'+@indate+'all from tblProductList_Rx
');
--市场定义表
exec('
if object_id(N''BMSCNProc_bak.dbo.tblQueryToolDriverRx_'+@indate+'all'',N''U'') is null
select * into BMSCNProc_bak.dbo.tblQueryToolDriverRx_'+@indate+'all from tblProductList_Rx
')
GO


PRINT N'
------------------------------------------------------------------------------------------------------------
2.1    Rx 产品定义：  tblProductList_Rx
------------------------------------------------------------------------------------------------------------
'

/* 第一步   将源数据新增的产品 插入:  tblProductList_Rx_NewAdd */
truncate table tblProductList_Rx_NewAdd
GO

insert into tblProductList_Rx_NewAdd
select distinct
  RxProd_Cod                    --[RxProd_Cod]      
  ,''                           --[Prod_Cod]        
  ,''                           --[Pack_Cod]        
  ,药品大类                     --[RxCat]           
  ,药品亚类                     --[RxSubCat]        
  ,Molecule_CN                  --[Molecule_CN]     
  ,Molecule_EN                  --[Molecule_EN]     
  ,Product_CN                   --[Product_CN]      
  ,Strength                     --[Strength]        
  ,Form                         --[Form]            
  ,Product_CN+Strength+Form     --[Package_Name_CN] 
from inRx t1                  
where not exists(select * from tblProductList_Rx t2
                 where   t1.RxProd_Cod=t2.RxProd_Cod 
                         and t1.Product_CN=t2.Product_CN 
                         and t1.Strength=t2.Strength
                         and t1.Form=t2.Form )
GO


/* 第二步   给新增的产品   编制Prod_Cod  : select * from tblProductList_Rx_NewAdd */
drop table test
GO
select distinct  RxProd_Cod, Product_CN 
into test from tblProductList_Rx_NewAdd 
GO

update tblProductList_Rx_NewAdd set Prod_Cod = b.RxProd_Cod + replicate('0',2-len(rnk)) + rnk --select * 
from tblProductList_Rx_NewAdd a
inner join (
select RxProd_Cod,Product_CN
       , cast(row_number() over(partition by RxProd_Cod order by Product_CN) as varchar) as rnk 
from test
) b on a.RxProd_Cod = b.RxProd_Cod and a.Product_CN = b.Product_CN
GO

/* 第三步   给新增的产品   编制Pack_Cod  : select * from tblProductList_Rx_NewAdd */
drop table test
GO
select distinct  Prod_Cod,Package_Name_CN
into test from tblProductList_Rx_NewAdd 
GO

update tblProductList_Rx_NewAdd set Pack_Cod = b.Prod_Cod + replicate('0',3-len(rnk)) + rnk --select * 
from tblProductList_Rx_NewAdd a
inner join (
      select Prod_Cod,Package_Name_CN
             , cast(row_number() over(partition by Prod_Cod order by Package_Name_CN) as varchar) as rnk 
	  from test
) b on a.Prod_Cod = b.Prod_Cod and a.Package_Name_CN = b.Package_Name_CN
GO


/* 第四步   新增的产品 转移到:  tblProductList_Rx */
insert into tblProductList_Rx
select * from tblProductList_Rx_NewAdd
GO



--------->>查询相同product具有不同的Product_Code

select  * 
from tblProductList_Rx  where RxProd_Cod in (
select distinct RxProd_Cod
from tblProductList_Rx
group by RxProd_Cod,Product_CN having count(distinct Prod_Cod)>1 
)
order by RxProd_Cod
GO

delete 
from tblProductList_Rx  where RxProd_Cod in (
select distinct RxProd_Cod
from tblProductList_Rx
group by RxProd_Cod,Product_CN having count(distinct Prod_Cod)>1 
)
GO



/*
其它：
--1.3  抽样检查一下
select *  from tblProductList_Rx 
where 
RxProd_Cod='W050008'
and Product_CN=N'葡萄糖酸锌'
and Strength='0.35% 10 ML'
and Form=N'口服'
--
select  *  from inRx 
where 
RxProd_Cod='W050008'
and Product_CN=N'葡萄糖酸锌'
and Strength='0.35% 10 ML'
and Form=N'口服'
--
select *  from tblProductList_Rx 
where Molecule_CN = N'阿司匹林' 

update tblProductList_Rx set Molecule_EN = 'ACETYLSALICYLIC ACID'   where Molecule_CN = N'阿司匹林' 
*/










PRINT N'
------------------------------------------------------------------------------------------------------------
2.2    Rx 市场定义：  tblQueryToolDriverRx
------------------------------------------------------------------------------------------------------------
'
truncate table tblQueryToolDriverRx
GO

/* 1.  In-line Market */
insert into tblQueryToolDriverRx
select 
  'In-line Market'                                              --[MktType] 
  ,b.Mkt                                                        --[Mkt]     
  ,b.MktName                                                    --[MktName] 
  ,null                                                         --[ATC3_COD]
  ,null                                                         --[Class]   
  ,RxProd_Cod                                                   --[Mole_Cod]
  ,Molecule_EN                                                  --[Mole_Des]
  ,Prod_Cod                                                     --[Prod_Cod]
  ,Molecule_EN +'('+ Product_CN+')' as Prod_Des                 --[Prod_Des]
  ,Pack_Cod                                                     --[Pack_Cod]
  ,Molecule_EN   +'('+ Product_CN+Strength+Form+')' as Pack_Des --[Pack_Des]
  ,null                                                         --[Corp_Cod]
  ,null                                                         --[Corp_Des]
  ,null                                                         --[Manu_Cod]
  ,null                                                         --[Manu_Des]
  ,null                                                         --[MNC]     
  ,null                                                         --[ClsInd]  
from tblProductList_Rx a
inner join (
select distinct Mkt,MktName,Mole_Des from tblQueryToolDriverHosp
where MktType='In-line Market'
) b
on a.Molecule_EN = b.Mole_Des
GO


/* 2.  Pipeline Market */
insert into tblQueryToolDriverRx
select 
  'Pipeline Market'
  ,null
  ,b.MktName 
  ,null
  ,null
  ,a.RxProd_Cod
  ,a.Molecule_EN
  ,a.Prod_Cod
  ,a.Molecule_EN +'('+ a.Product_CN+')' as Prod_Des
  ,a.Pack_Cod
  ,a.Molecule_EN   +'('+ a.Product_CN+a.Strength+a.Form+')' as Pack_Des
  ,null
  ,null
  ,null
  ,null
  ,null
  ,null
from tblProductList_Rx a
inner join (
select distinct MktName,Molecule_EN from inPipelineMarketDefinition
) b
on a.Molecule_EN = b.Molecule_EN
GO



/* 3.  Global TA market	 */
insert into tblQueryToolDriverRx
select 
  'Global TA'                                                   --[MktType] 
  ,b.Mkt                                                        --[Mkt]     
  ,b.MktName                                                    --[MktName] 
  ,null                                                         --[ATC3_COD]
  ,null                                                         --[Class]   
  ,RxProd_Cod                                                   --[Mole_Cod]
  ,Molecule_EN                                                  --[Mole_Des]
  ,Prod_Cod                                                     --[Prod_Cod]
  ,Molecule_EN +'('+ Product_CN+')' as Prod_Des                 --[Prod_Des]
  ,Pack_Cod                                                     --[Pack_Cod]
  ,Molecule_EN   +'('+ Product_CN+Strength+Form+')' as Pack_Des --[Pack_Des]
  ,null                                                         --[Corp_Cod]
  ,null                                                         --[Corp_Des]
  ,null                                                         --[Manu_Cod]
  ,null                                                         --[Manu_Des]
  ,null                                                         --[MNC]     
  ,null                                                         --[ClsInd]  
from tblProductList_Rx a
inner join (
select distinct Mkt,MktName,Mole_Des from tblQueryToolDriverIMS
where MktType='Global TA' 
) b
on a.Molecule_EN = b.Mole_Des
GO



