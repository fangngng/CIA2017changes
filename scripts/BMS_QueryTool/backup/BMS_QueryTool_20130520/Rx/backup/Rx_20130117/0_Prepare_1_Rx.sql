use BMSCNProc2
go

update tblDataPeriod set DataPeriod = '201206' where QType = 'Rx'
GO

PRINT '-- Importing latest data'

print '-- Importing Rx'
if object_id(N'inRx',N'U') is not null
	drop table inRx
go
select 
	a.Area,a.Date, a.[处方来源], a.[科室] as Dpt, a.报销,
	a.[药品编码] as RxProd_Cod,b.[药品大类],b.[药品亚类],
	b.[中文通用名] as Molecule_CN,b.[英文名称] as Molecule_EN,
	a.[商品名称] as Product_CN, a.[药品规格] as Strength,
	a.[给药途径] as Form, a.[处方张数] as Rx,
	a.[取药数量], cast(0 as float) Sales, a.原始诊断
into inRx
from db4.BMSChinaOtherDB.dbo.inRx_2010H2 a
inner join db4.BMSChinaOtherDB.dbo.inRx_MoleculeRef b on a.[药品编码] = b.[药品编码]
go

insert into inRx
select 
	a.Area,a.Date, a.[处方来源], a.[科室] as Dpt, a.报销,
	a.[药品编码] as RxProd_Cod,b.[药品大类],b.[药品亚类],
	b.[中文通用名] as Molecule_CN,b.[英文名称] as Molecule_EN,
	a.[商品名称] as Product_CN, a.[药品规格] as Strength,
	a.[给药途径] as Form, a.[处方张数] as Rx,
	a.[取药数量], a.[金额] as Sales, a.原始诊断
from db4.BMSChinaOtherDB.dbo.inRx_2011H2 a
inner join db4.BMSChinaOtherDB.dbo.inRx_MoleculeRef b on a.[药品编码] = b.[药品编码]
go
