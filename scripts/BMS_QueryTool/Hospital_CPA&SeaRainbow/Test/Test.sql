use BMSCNProc2_test
go 


/* �����ű� */

--�����м���������
select * from tblHospitalDataCT
where  pack_cod in (
select 
package_code
from  tblOutput_Hosp_TA_Master
where 
datatype='MTHUNT'
and mkttype='In-line Market'
and geo='CHINA'
and product_name='AO SU (PL2)'
)
and datatype='MTHUNT'

select * from inCPAData t1 
inner join tblPackageXRefHosp t2
on t1.Molecule=t2.Molecule_CN_Src and t1.Product=t2.Product_CN_Src 
   and Form_Src=Form and t1.Specification=t2.Specification_Src 
   and t1.Manufacture=t2.Manu_CN_Src
where product=N'����'
and y='2012'
order by [Area],[Y],[Q],[M],[Molecule],[Product]

select t1.* 
from DB4.BMSChinaMRBI_test.dbo.inCPAData t1 
inner join tblPackageXRefHosp t2
on t1.Molecule=t2.Molecule_CN_Src and t1.Product=t2.Product_CN_Src 
	 and Form_Src=Form and t1.Specification=t2.Specification_Src 
	 and t1.Manufacture=t2.Manu_CN_Src
where  t2.Package_Code in (
select 
package_code
from  tblOutput_Hosp_TA_Master
where 
datatype='MTHUNT'
and mkttype='In-line Market'
and geo='CHINA'
and product_name='AO SU (PL2)'
)
order by Y ,M

--�鿴mktDefinition��Դ����������
select * from tblQueryToolDriverHosp
where mole_Des='GEMCITABINE' and prod_des='Gemcitabine  (TK5)'

select * from tblPackageXRefHosp
where molecule_cn_src=N'��������' and product_cn_src=N'��������'  
and manu_cn_src=N'���ݰ���ɽ�⻪��ҩ�ɷ����޹�˾'

SELECT * FROM inCPAData
where y>2010 and 
[Product] = N'��������'  and  manufacture like N'%������ҩ%'
order by [Y],[Q],[M],[Molecule],[Product]



