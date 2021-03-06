use BMSCNProc2
go

update tblDataPeriod set DataPeriod = '201206' where QType = 'Rx'
GO



PRINT '
--------------------------------------
1.  Importing latest data
--------------------------------------
'
if object_id(N'inRx',N'U') is not null
	drop table inRx
go
select 
	a.Area,a.Date, a.source as [处方来源], a. Department as Dpt, a.expense as [报销] ,a.Mole_code as RxProd_Cod,
	b.[药品大类],b.[药品亚类],b.[中文通用名] as Molecule_CN,b.[英文名称] as Molecule_EN,
	a.Product as Product_CN, a. specifications as Strength,a.route as Form, a.Rx as Rx,
	a.unit as [取药数量], a.amount as Sales, cast(null as nvarchar(255)) 原始诊断
into inRx
from db4.BMSChinaMRBI.dbo.inRx a
inner join db4.BMSChinaOtherDB.dbo.inRx_MoleculeRef b on a.Mole_code  = b.[药品编码]
go

--特殊处理：检查铂类是否有数据问题
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



PRINT '
--------------------------------------
2.  refresh market definition 
--------------------------------------
'
/*

--2.1  back up
select * into dbo.tblQueryToolDriverRx_20130228 from dbo.tblQueryToolDriverRx

--2.2  refresh
truncate table dbo.tblQueryToolDriverRx

insert into dbo.tblQueryToolDriverRx select * from dbo.tblQueryToolDriverRx_20130122 where mkttype = 'Global TA'
insert into dbo.tblQueryToolDriverRx  select * from dbo.tblQueryToolDriverHosp
insert into dbo.tblQueryToolDriverRx  select * from dbo.tblQueryToolDriverHosp_Pipeline_new

*/




--第一步：tblHospMoleXRefProd_Rx

--1.1	Manually add 铂类and product into tblHospMoleXRefProd_Rx
--select *  from tblHospMoleXRefProd_Rx where Molecule_cn in (N'卡铂',N'顺铂',N'奈达铂')
delete tblHospMoleXRefProd_Rx where Molecule_cn in (N'卡铂',N'顺铂',N'奈达铂')
go
insert into tblHospMoleXRefProd_Rx (Molecule_CN,Molecule_EN,Product_CN,Product_EN)
select distinct 
      molecule_cn,Molecule_EN,Product_CN
	  ,Molecule_EN +'('+ product_cn+')'
from inRx a
where molecule_cn in (N'卡铂',N'顺铂',N'奈达铂')
and not exists(select * from tblHospMoleXRefProd_Rx b 
			   where a.molecule_cn=b.Molecule_cn and a.Product_cn = b.Product_cn)
go

-- 1.2	Manually add 铂类into tblHospMolecule_Rx（产品类配置表）
delete tblHospMolecule_Rx where Molecule_cn in (N'奈达铂',N'卡铂',N'顺铂')
go
insert into tblHospMolecule_Rx values('L01XA02','T050012',N'卡铂','Carboplatin')
go
insert into tblHospMolecule_Rx values('L01XA01','T050003',N'顺铂','Cisplatin')
go
insert into tblHospMolecule_Rx values('L01XA50','T050070',N'奈达铂','Nedaplatin')
go

--1.3	mole_code
update tblHospMoleXRefProd_Rx set 
	Mole_Code_IMS = b.mole_code_ims
from tblHospMoleXRefProd_Rx a
inner join tblHospMolecule_Rx b on a.Molecule_cn = b.Molecule_cn
where a.Mole_Code_IMS is null
go

--1.4	product_code
update tblHospMoleXRefProd_Rx set 
	Product_Code = replicate('0',2-len(cast(id as varchar))) + cast(id as varchar)
where Molecule_cn in (N'卡铂',N'顺铂',N'奈达铂') and Product_code is null
go


 
--第二步：tempBoleiDef_Rx
--2.1
drop table tempBoleiDef_Rx
go
--select * from tempBoleiDef_Rx
select * into tempBoleiDef_Rx from tblQueryToolDriverRx
where 1 = 0
go
-- select top 5 * from inRx  select top 5 * from tblHospMolecule_Rx
--注：Product_EN与Product_code一一对应，且由2部分决定：Molecule_EN,Product_CN
--注：Pack_Des与Pack_cod一一对应，且由这4部分决定：Molecule_EN,Product_CN，Strength,Form
insert into tempBoleiDef_Rx
select distinct 
 'In-line Market','PLATINUM','PLATINUM MARKET','L01X',	'NA',null,
 Molecule_EN
,null
, Molecule_EN +'('+ product_cn+')' as Prod_Des
,null
,Molecule_EN   +'('+ Product_CN+Strength+Form+')' as Pack_Des
,null,null,null,null,null,'N'
from inRx
where Molecule_CN in (N'卡铂',N'顺铂',N'奈达铂')
order by Molecule_EN
go


--2.2	更新Mole_Code
--select * from tempBoleiDef_Rx
update tempBoleiDef_Rx set 
      Mole_Cod = b.Mole_code_IMS
from tempBoleiDef_Rx a
inner join tblHospMolecule_Rx b 
on b.Molecule_en = a.Mole_Des
go

--2.3	更新Prod_Cod  
update tempBoleiDef_Rx set 
      Prod_Cod = subString(b.Mole_Code_IMS,1,6) +replicate('0',2-len(b.Product_Code))+b.Product_Code
from tempBoleiDef_Rx a
inner join tblHospMoleXRefProd_Rx b 
on b.Molecule_en = a.Mole_Des and a.Prod_Des = b.Product_en
go

--2.4	更新Pack_Cod
update tempBoleiDef_Rx set Pack_cod = b.Prod_cod + replicate('0',2-len(rnk)) + rnk--select * 
from tempBoleiDef_Rx a
inner join (
      select Prod_cod,Pack_Des, cast(row_number() over(partition by Prod_cod order by Pack_Des) as varchar) as rnk 
	  from tempBoleiDef_Rx
) b on a.Prod_cod = b.Prod_cod and a.Pack_Des = b.Pack_Des
go

 

--第三步：tblQueryToolDriverRx
--清除历史数据
delete from tblQueryToolDriverRx 
where MktType='In-line Market' and MKt='PLATINUM' and MktName='PLATINUM MARKET'
go
--更新
insert into  tblQueryToolDriverRx 
select * from tempBoleiDef_Rx order by mole_cod,prod_cod,pack_cod
go


--第四步：tblProductList_Rx
drop table tblProductList_Rx_bolei
GO
select * into tblProductList_Rx_bolei from tblProductList_Rx where 1=0
GO
insert into tblProductList_Rx_bolei
select distinct
	t1.RxProd_Cod,t2.Prod_Cod,t2.Pack_Cod,t1.药品大类,t1.药品亚类
	,t1.Molecule_CN,t1.Molecule_EN
	,t1.Product_CN
	,t1.Strength,t1.Form,t1.Product_CN+t1.Strength+t1.Form
from inRx t1
inner join tempBoleiDef_Rx t2 
on t1.RxProd_Cod=t2.Mole_Cod 
	 and t1.Molecule_EN +'('+ t1.Product_CN+')' = t2.Prod_Des
	 and t1.Molecule_EN +'('+ t1.Product_CN+t1.Strength+t1.Form+')'=t2.Pack_Des
GO
--	select * from tblProductList_Rx_bolei  
--	select * from tblProductList_Rx where molecule_CN in (N'卡铂',N'顺铂',N'耐达铂')
delete from tblProductList_Rx where molecule_CN in (N'卡铂',N'顺铂',N'耐达铂')
GO
insert into tblProductList_Rx
select * from tblProductList_Rx_bolei
GO
