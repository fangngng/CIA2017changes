
use BMSCNProc2
go

-- Manually add the manufacture

select distinct Manufacture from inCPAData a
where Molecule in (N'�δﲬ',N'����',N'˳��')
      and not exists(
            select * from tblHospManufacture b where a.Manufacture = b.Manu_CN
      )
go

/*

��������ȵ�յ��ҩҵ���޹�˾
���ϸ�����ҩҵ�������ι�˾
�������ݾ�̩ҩҵ�������ι�˾
ɽ�������ҩ�ɷ����޹�˾
�������ʱ��ʩ�󱦹�˾

*/


delete tblHospManufacture where Manu_cn in(
      N'�������ʱ��ʩ�󱦹�˾'
      ,N'��������ȵ�յ��ҩҵ���޹�˾'
      ,N'���ϸ�����ҩҵ�������ι�˾'
      ,N'�������ݾ�̩ҩҵ�������ι�˾'
      ,N'ɽ�������ҩ�ɷ����޹�˾'
)

go

 

insert into tblHospManufacture values(N'�������ʱ��ʩ�󱦹�˾', 'BMS (ITY)', 'Y', null)
go
insert into tblHospManufacture values(N'��������ȵ�յ��ҩҵ���޹�˾', 'The Yunnan Dengzhanhua Pharmaceutical Co., Ltd.', 'N', null)
go
insert into tblHospManufacture values(N'���ϸ�����ҩҵ�������ι�˾', 'Yunnan GeJiu Pharmaceutical Co., Ltd.', 'N', null)
go
insert into tblHospManufacture values(N'�������ݾ�̩ҩҵ�������ι�˾', 'Liaoning Jinzhou JiuTai Pharmaceutical Co., Ltd.', 'N', null)
go
insert into tblHospManufacture values(N'ɽ�������ҩ�ɷ����޹�˾', 'Shandong Phoenix Pharmaceutical Co., Ltd.', 'N', null)
go

 

update tblHospManufacture set Manu_code = c.manu_code
from tblHospManufacture a
inner join (
      select manu_cn, row_number() over(order by manu_cn) rnk
      from tblHospManufacture a
      where manu_code is null
) b on a.Manu_cn = b.Manu_cn
inner join (
      select Manu_code, row_number() over (order by Manu_code) rnk
      from tempCodeingManu 
      where Manu_Code not in (select Manu_Code from dbo.tblHospManufacture where manu_code is not null)
) c on b.rnk = c.rnk
go

 

/*
Carboplatin����(ATC_Code:L01XA02), Cisplatin˳��(L01XA01), Nedaplatin�δﲬ(L01XA50)

Carboplatin:mole_cod='031172'      Cisplatin:mole_cod='501750'     Nedaplatin:mole_cod='398650'

*/

 

-- Manually add ����into tblHospMolecule
delete tblHospMolecule where Molecule_cn in (N'�δﲬ',N'����',N'˳��')
go
insert into tblHospMolecule values('L01XA02','031172',N'����','Carboplatin')
go
insert into tblHospMolecule values('L01XA01','501750',N'˳��','Cisplatin')
go
insert into tblHospMolecule values('L01XA50','398650',N'�δﲬ','Nedaplatin')
go

 

-- Manually add ����and product into tblHospMoleXRefProd
delete tblHospMoleXRefProd where Molecule_cn in (N'����',N'˳��',N'�δﲬ')
go

 

insert into tblHospMoleXRefProd (Molecule_cn,Product_cn)
select distinct 
      Molecule,Product
from inCPAData a
where Molecule in (N'����',N'˳��',N'�δﲬ')
and not exists(select * from tblHospMoleXRefProd b where a.Molecule=b.Molecule_cn and a.Product = b.Product_cn)
go

 

update tblHospMoleXRefProd set Product_Code = 'H' + replicate('0',4-len(cast(id as varchar))) + cast(id as varchar)
where Product_code is null
go

update tblHospMoleXRefProd set Molecule_en = b.Molecule_en, mole_code_ims = b.mole_code_ims
from tblHospMoleXRefProd a
inner join tblHospMolecule b on a.Molecule_cn = b.Molecule_cn
where a.molecule_en is null
go

 

update tblHospMoleXRefProd set Product_en= 'PARAPLATIN'      where Product_cn = N'������'
update tblHospMoleXRefProd set Product_en= 'Carboplatin'     where Product_cn =N'����'
update tblHospMoleXRefProd set Product_en= 'AO XIAN DA'      where Product_cn = N'���ȴ�'
update tblHospMoleXRefProd set Product_en= 'JIE BAI SHU'     where Product_cn = N'�ݰ���'
update tblHospMoleXRefProd set Product_en= 'Fang Tan'  where Product_cn = N'��̹'
update tblHospMoleXRefProd set Product_en= 'QUAN BO'   where Product_cn = N'Ȫ��'
update tblHospMoleXRefProd set Product_en= 'BO BEI'    where Product_cn = N'����'
update tblHospMoleXRefProd set Product_en= 'Loca'      where Product_cn = N'�忨'
update tblHospMoleXRefProd set Product_en= 'Nuo Xin'   where Product_cn = N'ŵ��'
update tblHospMoleXRefProd set Product_en= 'Jin Shun'  where Product_cn = N'��˳'
update tblHospMoleXRefProd set Product_en= 'BO LON'    where Product_cn = N'����'
update tblHospMoleXRefProd set Product_en= 'Cisplatin' where Product_cn = N'˳��'
update tblHospMoleXRefProd set Product_en= 'LU BEI'    where Product_cn = N'³��'
go

 

if object_id(N'tempBoleiDef',N'U') is not null
      drop table tempBoleiDef
go
select * into tempBoleiDef from tblPackageXrefHosp
where 1 = 0
go
insert into tempBoleiDef(Molecule_cn_src, Product_cn_src,form_src,specification_src,Manu_cn_src,Source)
select distinct 
      Molecule,Product, Form,Specification, Manufacture ,'CPA'
from inCPAData
where Molecule in (N'����',N'˳��',N'�δﲬ')
/*
and Product in (N'����',N'����',N'������'
				,N'˳��',N'����',N'ŵ��',N'��̹',N'��˳'
				,N'���ȴ�',N'�ݰ���',N'³��',N'Ȫ��')
*/
order by Molecule,Product
go

 

update tempBoleiDef set 
      ATC_code = b.ATC_code,
      Mole_Code_IMS = b.Mole_code_IMS,
      Molecule_en = b.Molecule_en
from tempBoleiDef a
inner join tblHospMolecule b on b.Molecule_cn = a.Molecule_cn_src
go

 

update tempBoleiDef set 
      Product_code = b.Product_code,
      Product_en = b.Product_en
from tempBoleiDef a
inner join tblHospMoleXRefProd b on a.Molecule_cn_src = b.Molecule_cn and a.Product_cn_src = b.Product_cn
go

 

update tempBoleiDef set
      Manu_sc = b.Manu_code,
      Manu_en = b.Manu_en,
      MNc = b.MNC
from tempBoleiDef a
inner join tblHospManufacture b on a.Manu_cn_src = b.Manu_cn
go

 

update tempBoleiDef set Package_Name = Product_en + ' ' + form_SRc + ' ' + specification_src
go


update tempBoleiDef set Product_en = Product_en + ' (' + manu_sc + ')'
go

-- set the final product code





select * from tempBoleiDef
/*
select *, b.Product_code + replicate('0',4-len(rnk)) + rnk
from tempBoleiDef a
inner join (
      select Product_code, manu_sc, cast(row_number() over(partition by Product_code order by Manu_sc) as varchar) as rnk from tempBoleiDef
) b on a.Product_code = b.Product_code and a.Manu_sc = b.Manu_sc
*/

update tempBoleiDef set Product_code = b.Product_code + replicate('0',4-len(rnk)) + rnk
from tempBoleiDef a
inner join (
      select Product_code, manu_sc, cast(row_number() over(partition by Product_code order by Manu_sc) as varchar) as rnk from tempBoleiDef
) b on a.Product_code = b.Product_code and a.Manu_sc = b.Manu_sc
go
-------------------

select * from tblPackageXRefHosp_newAdd
/*
select *, b.Product_code + replicate('0',4-len(rnk)) + rnk
from tblPackageXRefHosp_newAdd a
inner join (
select 
Product_code
, manu_sc
, cast(row_number() over(partition by Product_code order by Manu_sc) as varchar) as rnk 
from tblPackageXRefHosp_newAdd
where newFlag='Y'
) b on a.Product_code = b.Product_code and a.Manu_sc = b.Manu_sc
*/

update tblPackageXRefHosp_newAdd set Product_code = b.Product_code + replicate('0',4-len(rnk)) + rnk
from tblPackageXRefHosp_newAdd a
inner join (
select 
Product_code
, manu_sc
, cast(row_number() over(partition by Product_code order by Manu_sc) as varchar) as rnk 
from tblPackageXRefHosp_newAdd
where newFlag='Y'
) b 
on a.Product_code = b.Product_code and a.Manu_sc = b.Manu_sc
go
















-- set the final package code
/*
select *, b.Product_code + replicate('0',4-len(rnk)) + rnk
from tempBoleiDef a
inner join (
      select Product_code, form_src,specification_src, cast(row_number() over(partition by Product_code order by form_src,specification_src) as varchar) as rnk from tempBoleiDef
) b on a.Product_code = b.Product_code and a.form_src = b.form_src and a.specification_src = b.specification_src
*/

update tempBoleiDef set Package_code = b.Product_code + replicate('0',2-len(rnk)) + rnk
from tempBoleiDef a
inner join (
      select Product_code, form_src,specification_src, cast(row_number() over(partition by Product_code order by form_src,specification_src) as varchar) as rnk from tempBoleiDef
) b on a.Product_code = b.Product_code and a.form_src = b.form_src and a.specification_src = b.specification_src

go

 

update tempBoleiDef set Manu_id = Manu_sc
go
update tempBoleiDef set newFlag = 'T'
go

--select * from tempBoleiDef   where product_CN_Src=N'�忨'
------------back up
select * 
into tblPackageXRefHosp_20130227
from tblPackageXRefHosp
GO

delete tblPackageXRefHosp where molecule_cn_src in (N'����',N'˳��',N'�δﲬ')
go

insert into  tblPackageXRefHosp 
select * from tempBoleiDef
go

