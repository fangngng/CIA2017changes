/* 
�޸�ʱ��: 2013/4/12 16:38:17

Ԥ����ű�����Ҫ�ֹ�ά�� ��
inManuDef��inProdDef �Ǹ��ݿͻ�����IMS�������ݾ��������ֹ�Ԥ���������� ������Hosp�õ� ԭʼ���롣

*/

use BMSCNProc2
GO







Print('----------------------------
1.1.1  Get new molecules from inCPA��inSeaRainbowData
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

-- ��û��ָ��Mole_Code�Ĳ�Ʒ��ʱ����
delete  -- select *
from TempNewMolecules where Mole_Code is null
GO







print(N'
-------------------------------------------------------------------------      
         1. inManuDef    ���̷������ݴ���
-------------------------------------------------------------------------
')

--��ѯ�����ķ��룬���뵽��ʱ��temp
IF OBJECT_ID(N'temp',N'U') IS NOT NULL
	DROP TABLE temp
GO
select * into temp
from BMSCNProc_bak.dbo.Manu$ where namec not in (
select distinct namec from BMSCNProc2.dbo.inManuDef
)
GO

--ͬһ���� ��Ӧ ���Ӣ�� ����������ֻ��ȡһ������
select * from temp where namec in (
select namec from temp
group by namec having count(name)>1
)

delete -- select * 
from inManuDef 
where manucode in ('4270','5504','6315')
GO


--��inManuDef_Gool �������ݵ��������ݽ��д���

select distinct * from inManuDef_Gool where namec in (
select namec from inManuDef_Gool group by namec having count([name]) >1
)
--

--2013/4/20 23:56:19
select  * from inManuDef_Gool 

insert into inManuDef_Gool  values('BIOTON S.A. (PO)',N'BIOTON S.A. (PO)')
GO
insert into inManuDef_Gool  values('Inferior jilin pharmaceutical co., LTD',N'���ָ�����ҩ���޹�˾')
GO
insert into inManuDef_Gool  values('Germany aventis belin co., LTD',N'�¹������ر������޹�˾')
GO
insert into inManuDef_Gool  values('GanLi pharmaceutical co., LTD',N'����ҩҵ���޹�˾')
GO


print(N'
-------------------------------------------------------------------------      
           2. ��inProdDefԴ���ݵ��������ݽ��д���
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



2. ȷ��db4.BMSChinaMRBI.dbo.tblMoleConfig  :��Ȼ Molecule ��Ӣ���������Լ��졣
   ʵ�������յ�tblQueryToolDriverHosp��mole_EN�Ǵ�tblQueryToolDriverIMS���ģ�ͨ��mole_code��������





select distinct Product_CN_Src,Manu_CN_Src from BMSCNProc2.dbo.tblPackageXRefHosp
