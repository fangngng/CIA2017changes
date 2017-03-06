/* 
修改时间: 2013/4/12 16:38:17

预处理脚本，需要手工维护 ：
inManuDef，inProdDef 是根据客户给的IMS翻译数据经过下面手工预处理后产生的 用来给Hosp用的 原始翻译。

*/

use BMSCNProc2
GO







Print('----------------------------
1.1.1  Get new molecules from inCPA，inSeaRainbowData
----------------------------------')
if object_id(N'TempNewMolecules',N'U') is not null
	drop table TempNewMolecules;
GO
select NewMole, b.Mole_Code, b.Mole_EN
into TempNewMolecules
from (
     select distinct Molecule as NewMole from inCPAData t1 
     where not exists (
                       select * from tblPackageXRefHosp t2
                       where t1.Molecule=t2.Molecule_CN_Src 
                       )
     and t1.y>2008
     ) a 
left join 
     tblDefMolecule_CN_EN b
on a.NewMole = b.Mole_CN
GO

insert into TempNewMolecules
select NewMole, b.Mole_Code, b.Mole_EN
from (
     select distinct Molecule as NewMole from inSeaRainbowData t1 
     where not exists (
                       select * from tblPackageXRefHosp t2
                       where t1.Molecule=t2.Molecule_CN_Src 
                       )
     and t1.YM>200901
     ) a 
left join 
     tblDefMolecule_CN_EN b
on a.NewMole = b.Mole_CN
GO

-- 对没有指定Mole_Code的产品暂时舍弃
delete  -- select *
from TempNewMolecules where Mole_Code is null
GO







print(N'
-------------------------------------------------------------------------      
         1. inManuDef    厂商翻译数据处理
-------------------------------------------------------------------------
')

--查询新增的翻译，插入到临时表temp
IF OBJECT_ID(N'temp',N'U') IS NOT NULL
	DROP TABLE temp
GO
select * into temp
from BMSCNProc_bak.dbo.Manu$ where namec not in (
select distinct namec from BMSCNProc2.dbo.inManuDef
)
GO

--同一中文 对应 多个英文 （不能容许，只能取一个。）
select * from temp where namec in (
select namec from temp
group by namec having count(name)>1
)

delete -- select * 
from inManuDef 
where manucode in ('4270','5504','6315')
GO


--对inManuDef_Gool 翻译数据的问题数据进行处理

select distinct * from inManuDef_Gool where namec in (
select namec from inManuDef_Gool group by namec having count([name]) >1
)
--

--2013/4/20 23:56:19
select  * from inManuDef_Gool 

insert into inManuDef_Gool  values('BIOTON S.A. (PO)',N'BIOTON S.A. (PO)')
GO
insert into inManuDef_Gool  values('Inferior jilin pharmaceutical co., LTD',N'吉林富春制药有限公司')
GO
insert into inManuDef_Gool  values('Germany aventis belin co., LTD',N'德国安万特贝林有限公司')
GO
insert into inManuDef_Gool  values('GanLi pharmaceutical co., LTD',N'甘李药业有限公司')
GO


print(N'
-------------------------------------------------------------------------      
           2. 对inProdDef源数据的问题数据进行处理
-------------------------------------------------------------------------
')

select * from BMSCNProc_bak.dbo.PRD$

select NAMEC, count(ENAME) from  BMSCNProc_bak.dbo.PRD$ 
group by NAMEC having count(ENAME)>1


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





select distinct Product_CN_Src,Manu_CN_Src from BMSCNProc2.dbo.tblPackageXRefHosp
