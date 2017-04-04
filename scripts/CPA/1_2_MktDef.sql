/* 

前置依赖：
BMSChinaCIA_IMS.dbo.tblMktDef_Inline
BMSChinaCIA_IMS.dbo.tblMktDef_MRBIChina_All
BMSChinaCIA_IMS.dbo.tblMktDef_ATCDriver

特殊处理：
update tblMktDefHospital set MktName='Oncology Focused Brands' ,Prod='860',ProductName='anzatax',FocusedBrand='Y'
--   select * from tblMktDefHospital
where Product = 'taxol' and Prod between '100' and '899'           and Prod_Des_EN = 'anzatax'
GO

*/

--Time:00:01

use BMSChinaMRBI
go

exec dbo.sp_Log_Event 'Market Define','CIA_CPA','1_2_MktDef.sql','Start',null,null






/*

说明：

000: market total
0XX: molecule level
XX0: product level
9xx: CLASS LEVEL
在XX0中可能会有一个code的名字叫作all others或者 others之类的。

*/


alter table tblMktDefHospital drop column rat
GO

--backup
declare @curHOSP_I varchar(6), @lastHOSP_I varchar(6)
  
select @curHOSP_I= Value1 from tblDSDates where Item = 'CPA'  
set @lastHOSP_I = convert(varchar(6), dateadd(month, -1, cast(@curHOSP_I+'01' as datetime)), 112)

-- tblMoleProd
exec('
if object_id(N''BMSChinaMRBI_Repository.dbo.tblMoleProd_'+@lastHOSP_I+''',N''U'') is null
   select * into BMSChinaMRBI_Repository.dbo.tblMoleProd_'+@lastHOSP_I+'
   from tblMoleProd
');
-- tblMktDefHospital
exec('
if object_id(N''BMSChinaMRBI_Repository.dbo.tblMktDefHospital_'+@lastHOSP_I+''',N''U'') is null
   select * into BMSChinaMRBI_Repository.dbo.tblMktDefHospital_'+@lastHOSP_I+'
   from tblMktDefHospital
');
-- tblMktDefRx
exec('
if object_id(N''BMSChinaMRBI_Repository.dbo.tblMktDefRx_'+@lastHOSP_I+''',N''U'') is null
   select * into BMSChinaMRBI_Repository.dbo.tblMktDefRx_'+@lastHOSP_I+'
   from tblMktDefRx
')
GO

--补齐 other Entecavir和ARV Others的产品
-- insert into tblMktDefHospital 
-- select 'ARV','ARV Market','600','Other Entecavir','N','N','J05B','J05AF10',N'恩替卡韦','Entecavir',N'天丁','Tian Ding','N','707295','','Baraclude',1
-- insert into tblMktDefHospital 
-- select 'ARV','ARV Market','600','Other Entecavir','N','N','J05B','J05AF10',N'恩替卡韦','Entecavir',N'恩甘定','Entecavir Capsules','N','707295','','Baraclude',1


-- insert into tblMktDefHospital 
-- select 'ARV','ARV Market','700','ARV Others','N','N','J05B','',N'拉米夫定','Lamivudine',N'贺甘定','He Gan Ding','N','700025','','',1
-- insert into tblMktDefHospital 
-- select 'ARV','ARV Market','700','ARV Others','N','N','J05B','',N'拉米夫定','Lamivudine',N'立古欣','Li Gu Xin','N','700025','','',1
-- insert into tblMktDefHospital 
-- select 'ARV','ARV Market','700','ARV Others','N','N','J05B','',N'拉米夫定','Lamivudine',N'银丁','Yin Ding','N','700025','','',1
-- insert into tblMktDefHospital 
-- select 'ARV','ARV Market','700','ARV Others','N','N','J05B','',N'阿德福韦酯','Adefovir dipivoxil',N'爱路韦','Ai Lu Wei','N','704405','','',1




------------------------------------------------------------------------------------------------------------------------
--第一步,获得新增 Molecule或Product   : tblMoleProd
------------------------------------------------------------------------------------------------------------------------
--CPA
truncate table tblMoleProd
GO

insert into tblMoleProd (ATC_CPA,Mole_Des_CN,Mole_Des_EN,Prod_Des_CN,Prod_Des_EN)
select distinct 
  ATC_Code,Molecule_CN_Src,Molecule_EN,Product_CN_Src,subString(Product_EN,0,charindex('(',Product_EN))
from tblPackageXRefHosp t1
where not exists (select distinct t2.Mole_Des_CN,t2.Prod_Des_CN 
                  from tblMktDefHospital t2
                  where t1.Molecule_CN_Src=t2.Mole_Des_CN and t1.Product_CN_Src=t2.Prod_Des_CN 
                  ) 
GO

update tblMoleProd set Molecule='N'
update tblMoleProd set Class='N'
update tblMoleProd set FocusedBrand='N'
update tblMoleProd set IMSProdCode=''
update tblMoleProd set ifNew='N'
update tblMoleProd set ifMoleNew='N'
update tblMoleProd set ifProdNew='N'
go



--新Product
--update tblMoleProd set ifNew='Y' from tblMoleProd a 
--inner join BMSChinaCIA_IMS.dbo.tblMktDef_Inline b on a.mole_des_en=b.mole_des and a.prod_des_en=b.prod_des
--go

update tblMoleProd set ifNew='Y' from tblMoleProd a 
inner join BMSChinaCIA_IMS.dbo.tblMktDef_Inline b on a.mole_des_en=b.mole_des and a.prod_des_en=
(case when b.prod_des='ENTECAVIR' and b.mkt='arv' then 'Entecavir Capsules' else b.prod_des end)
go 

--新Product中  已有Molecule
update tblMoleProd set ifMoleNew='Y' from tblMoleProd a 
where not exists (select * from tblMktDefHospital b where a.mole_des_cn=b.mole_des_cn and a.ifNew='Y') and a.ifNew='Y' 
go


-->检查：
select '1.--------------Error: English Name of Molecule or Product is not set!'
select * from tblMoleProd where mole_des_en is null or prod_des_en is null
go

select N'2.-------------本次新增：'
select * from tblMoleProd where ifNew='Y' 





------------------------------------------------------------------------------------------------------------------------
--第二步,市场定义 ： tblMktDefHospital
------------------------------------------------------------------------------------------------------------------------


--2.1 Molecule已有  但没有该Product
if object_id(N'tblCPAResults',N'U') is not null
	drop table tblCPAResults
go
select distinct 
  b.mkt
  ,b.mktname
  ,b.Prod
  ,b.ProductName
  ,b.molecule
  ,b.class
  ,b.ATC3_cod
  ,a.atc_cpa
  ,a.mole_des_cn
  ,a.mole_des_en
  ,a.prod_des_cn
  ,a.Prod_Des_EN
  ,a.focusedbrand
  ,b.mole_cod IMSMoleCode
into tblCPAResults
from tblMoleProd a 
inner join (
      select distinct 
       a.Mkt
       ,a.MktName
       ,a.Prod
       ,a.ProductName
       ,case when a.Prod = '000' then 'N' else a.Molecule end as Molecule
       ,case when a.Prod = '000' then 'N' else a.Class end as Class
       ,a.ATC3_cod
       ,b.Mole_Cod
       ,b.Mole_Des
       ,b.Prod_Cod
       ,b.Prod_Des
      from BMSChinaCIA_IMS.dbo.tblMktDef_MRBIChina_All a
      inner join BMSChinaCIA_IMS.dbo.tblMktDef_ATCDriver b 
      on a.atc1_cod = b.atc1_cod
         and a.atc2_cod = b.atc2_cod
         and a.atc3_cod = b.atc3_cod
         and a.atc4_cod = b.atc4_cod
         and a.Prod_cod = b.Prod_cod
      where not  a.prod between '100' and '899'
      ) b 
--on a.mole_des_en=b.mole_des and a.Prod_Des_EN=b.prod_des
on a.mole_des_en=b.mole_des and a.Prod_Des_EN=
(case when b.prod_des='ENTECAVIR' and b.mkt='arv' then 'Entecavir Capsules' else b.prod_des end)
where ifNew='Y' and ifMoleNew='N'
order by b.Mkt,b.Prod
go

alter table tblCPAResults add IMSProdCode varchar(5),Product varchar(20)
go

delete tblCPAResults  
where prod+atc3_cod+prod_des_en in (
      select distinct prod+atc3_cod+prod_des_en 
      from  tblCPAResults 
      where mole_des_cn = N'二甲双胍格列本脲' and prod not in ('000','910','010','810')
      )
go

update tblCPAResults set Product = 'Glucophage' where Mkt in('Dia','NIAD')
update tblCPAResults set Product = 'Baraclude' where Mkt in('HBV')
update tblCPAResults set Product = 'Monopril' where Mkt in('HYP')
update tblCPAResults set Product = 'Taxol' where Mkt in('ONC')
update tblCPAResults set Product = 'Monopril' where Mkt in('ACE')
update tblCPAResults set Product = 'Eliquis' where Mkt in ('Eliquis')
update tblCPAResults set Product = 'Coniel' where Mkt in ('CCB')
go

insert into tblMktDefHospital select * from tblCPAResults
go


--2.2 新的Molecule
if object_id(N'tblCPAResults',N'U') is not null
	drop table tblCPAResults
go
select distinct 
  b.mkt
  ,b.mktname
  ,b.Prod
  ,b.ProductName
  ,b.molecule
  ,b.class
  ,b.ATC3_cod
  ,a.atc_cpa
  ,a.mole_des_cn
  ,a.mole_des_en
  ,a.prod_des_cn
  ,a.prod_des_en
  ,a.focusedbrand
  ,b.mole_cod IMSMoleCode
into tblCPAResults
from tblMoleProd a 
inner join (
           select distinct a.Mkt,a.MktName,a.Prod,a.ProductName,
           case when a.Prod = '000' then 'N' else a.Molecule end as Molecule,
           case when a.Prod = '000' then 'N' else a.Class end as Class, 
           a.ATC3_cod,b.Mole_Cod,b.Mole_Des,b.Prod_Cod,b.Prod_Des
           from BMSChinaCIA_IMS.dbo.tblMktDef_MRBIChina_All a
           inner join BMSChinaCIA_IMS.dbo.tblMktDef_ATCDriver b 
           on a.atc1_cod = b.atc1_cod
              and a.atc2_cod = b.atc2_cod
              and a.atc3_cod = b.atc3_cod
              and a.atc4_cod = b.atc4_cod
              and a.Prod_cod = b.Prod_cod
           where not  a.prod between '100' and '899'
          ) b 
on a.mole_des_en=b.mole_des 
where ifNew='Y' and ifMoleNew='Y'
order by b.Mkt,b.Prod
go

alter table tblCPAResults add IMSProdCode varchar(5),Product varchar(20)
go

delete tblCPAResults  
where prod+atc3_cod+prod_des_en in (
      select distinct prod+atc3_cod+prod_des_en 
      from  tblCPAResults 
      where mole_des_cn = N'二甲双胍格列本脲' and prod not in ('000','910','010','810')
      )
go

update tblCPAResults set Product = 'Glucophage' where Mkt in('Dia','NIAD')
update tblCPAResults set Product = 'Baraclude' where Mkt in('HBV')
update tblCPAResults set Product = 'Monopril' where Mkt in('HYP')
update tblCPAResults set Product = 'Taxol' where Mkt in('ONC')
update tblCPAResults set Product = 'Monopril' where Mkt in('ACE')
update tblCPAResults set Product = 'Eliquis' where Mkt in ('Eliquis')
update tblCPAResults set Product = 'Coniel' where Mkt in ('CCB')
go

insert into tblMktDefHospital select * from tblCPAResults
go



--3. 特殊处理：
insert into tblMktDefHospital
select 
  Mkt,MktName,'850','HYP Others'
  , Molecule,class,atc3_cod,atc_cpa, mole_des_cn, mole_des_en,
  prod_des_cn, prod_des_en, FocusedBrand, IMSMoleCode,IMSProdCode,Product
from tblMktDefHospital a
where mkt ='hyp' and prod = '000' 
	and not exists(select * from tblMktDefHospital b where a.Mkt = b.Mkt and b.Prod between '100' and '899' and a.Mole_des_cn = b.Mole_des_cn and a.Prod_des_cn = b.Prod_des_cn)
go

insert into tblMktDefHospital
select 
  Mkt,MktName,'990','Other Class'
  , Molecule,class,atc3_cod,atc_cpa, mole_des_cn, mole_des_en,
	prod_des_cn, prod_des_en, FocusedBrand, IMSMoleCode,IMSProdCode,Product
from tblMktDefHospital a
where mkt ='hyp' and prod = '000' 
	and not exists(select * from tblMktDefHospital b where a.Mkt = b.Mkt and b.Prod between '900' and '999' and a.Mole_des_cn = b.Mole_des_cn and a.Prod_des_cn = b.Prod_des_cn)
go

insert into tblMktDefHospital
select 
  Mkt,MktName,'810','NIAD Others'
  , Molecule,class,atc3_cod,atc_cpa, mole_des_cn, mole_des_en,
  prod_des_cn, prod_des_en, FocusedBrand, IMSMoleCode,IMSProdCode,Product
from tblMktDefHospital a
where mkt ='NIAD' and prod = '000' 
	and not exists(select * from tblMktDefHospital b where b.Prod between '100' and '899' and a.Mole_des_cn = b.Mole_des_cn and a.Prod_des_cn = b.Prod_des_cn)
GO




--4. Paraplatin
delete from tblMktDefHospital where [Mkt] = 'Platinum'
GO
insert into tblMktDefHospital
select distinct
	'Platinum'          as [Mkt]          
	,'Platinum Market'   as [MktName]      
	,'000'               as [Prod]         
	,'Platinum Market'   as [ProductName]  
	,'N'                 as [Molecule]     
	,'N'                 as [Class]        
	,'L01X'              as [ATC3_Cod]     
	,ATC_Code            as [ATC_CPA]      
	,Molecule_CN_Src     as [Mole_Des_CN]  
	,Molecule_EN         as [Mole_Des_EN]  
	,Product_CN_Src      as [Prod_Des_CN]  
	,subString(Product_EN,0,charindex('(',Product_EN)) as [Prod_Des_EN]  
	,case when Product_CN_Src in (N'伯尔定',N'波贝',N'诺欣',N'顺铂',N'奥先达',N'捷佰舒',N'鲁贝') then 'Y' 
		else 'N'                 
		end            as [FocusedBrand] 
	,Mole_Code_IMS       as [IMSMoleCode]  
	,''                  as [IMSProdCode]  
	,'Paraplatin'        as [Product] 
from tblPackageXRefHosp
where Molecule_CN_Src in (N'卡铂',N'顺铂',N'奈达铂')
GO

insert into tblMktDefHospital
select distinct 
 'Platinum'          as [Mkt]          
,'Platinum Market'   as [MktName]      
,case when Molecule_CN_Src=N'卡铂' then '010'  
      when Molecule_CN_Src=N'顺铂'   then '020'   
      when Molecule_CN_Src=N'奈达铂'   then '030'
      end            as [Prod]         
,Molecule_EN         as [ProductName]  
,'Y'                 as [Molecule]     
,'N'                 as [Class]        
,'L01X'              as [ATC3_Cod]     
,ATC_Code            as [ATC_CPA]      
,Molecule_CN_Src     as [Mole_Des_CN]  
,Molecule_EN         as [Mole_Des_EN]  
,Product_CN_Src      as [Prod_Des_CN]  
,subString(Product_EN,0,charindex('(',Product_EN)) as [Prod_Des_EN]  
,'Y'                 as [FocusedBrand] 
,Mole_Code_IMS       as [IMSMoleCode]  
,''                  as [IMSProdCode]  
,'Paraplatin'        as [Product]  
from tblPackageXRefHosp
where Molecule_CN_Src in (N'卡铂',N'顺铂',N'奈达铂')
GO

insert into tblMktDefHospital
select distinct 
 'Platinum'          as [Mkt]          
,'Platinum Market'   as [MktName]      
,case when Product_CN_Src=N'伯尔定' then '100'  
      when Product_CN_Src=N'波贝'   then '200'   
      when Product_CN_Src=N'诺欣'   then '300'
      when Product_CN_Src=N'顺铂'   then '400'
      when Product_CN_Src=N'奥先达' then '500'
      when Product_CN_Src=N'捷佰舒' then '600'
      when Product_CN_Src=N'鲁贝'   then '700'
      else '888' 
      end            as [Prod]         
,subString(Product_EN,0,charindex('(',Product_EN)) as [ProductName]  
,'N'                 as [Molecule]     
,'N'                 as [Class]        
,'L01X'              as [ATC3_Cod]     
,ATC_Code            as [ATC_CPA]      
,Molecule_CN_Src     as [Mole_Des_CN]  
,Molecule_EN         as [Mole_Des_EN]  
,Product_CN_Src      as [Prod_Des_CN]  
,subString(Product_EN,0,charindex('(',Product_EN)) as [Prod_Des_EN]  
,'Y'                 as [FocusedBrand] 
,Mole_Code_IMS       as [IMSMoleCode]  
,''                  as [IMSProdCode]  
,'Paraplatin'        as [Product]  
from tblPackageXRefHosp
where Molecule_CN_Src in (N'卡铂',N'顺铂',N'奈达铂')
GO

update tblMktDefHospital set [ProductName] = 'Others',[FocusedBrand] = 'N'
where [Mkt] = 'Platinum' and [Prod] = '888'
GO

SET ansi_warnings OFF
--Eliquis Product Level
delete from tblMktDefHospital where [Mkt] = 'Eliquis VTEp'
GO
--insert market
insert into tblMktDefHospital
select distinct
	 'Eliquis VTEp'          as [Mkt]          
	,'Eliquis (VTEp) Market'   as [MktName]      
	,'000'             as [Prod]         
	,'Eliquis (VTEp) Market'   as [ProductName]  
	,'N'                 as [Molecule]     
	,'N'                 as [Class]        
	,''          as [ATC3_Cod]     
	,ATC_Code            as [ATC_CPA]      
	,Molecule_CN_Src     as [Mole_Des_CN]  
	,Molecule_EN         as [Mole_Des_EN]  
	,Product_CN_Src      as [Prod_Des_CN]  
	,subString(Product_EN,0,charindex('(',Product_EN)) as [Prod_Des_EN]  
	,'Y' as [FocusedBrand] 
	,Mole_Code_IMS       as [IMSMoleCode]  
	,''                  as [IMSProdCode]  
	,'Eliquis VTEp'        as [Product] 
from tblPackageXRefHosp a 
join (select *  from BMSChinaCIA_IMS.dbo.tblMktDef_MRBIChina_All where molecule='N' and class='N' ) b 
	on subString(a.Product_EN,0,charindex('(',a.Product_EN))=b.ProductName
--where  subString(a.Product_EN,0,charindex('(',a.Product_EN)) in('FRAXIPARINE','CLEXANE','XARELTO','ELIQUIS','ARIXTRA')
where a.Mole_Code_IMS in ('406260','408800','408827','413885','703259','704307','711981','719372', '904100', '999999')
go

-- insert product
insert into tblMktDefHospital
select distinct
	 'Eliquis VTEp'          as [Mkt]          
	,'Eliquis (VTEp) Market'   as [MktName]      
	,b.Prod              as [Prod]         
	,b.ProductName   as [ProductName]  
	,'N'                 as [Molecule]     
	,'N'                 as [Class]        
	, b.ATC3_COD          as [ATC3_Cod]     
	,ATC_Code            as [ATC_CPA]      
	,Molecule_CN_Src     as [Mole_Des_CN]  
	,Molecule_EN         as [Mole_Des_EN]  
	,Product_CN_Src      as [Prod_Des_CN]  
	,subString(Product_EN,0,charindex('(',Product_EN)) as [Prod_Des_EN]  
	,'Y' as [FocusedBrand] 
	,Mole_Code_IMS       as [IMSMoleCode]  
	,''                  as [IMSProdCode]  
	,'Eliquis VTEp'        as [Product] 
from tblPackageXRefHosp a 
	join (	select *  from BMSChinaCIA_IMS.dbo.tblMktDef_MRBIChina_All 
			where molecule='N' and class='N' and Prod <> '600'
		) b 
	on subString(a.Product_EN,0,charindex('(',a.Product_EN))=b.ProductName
where  b.Mkt='Eliquis VTEp'

go
-- 20161103 add VTEt
delete from tblMktDefHospital where [Mkt] = 'Eliquis VTEt'
go
insert into tblMktDefHospital
select distinct
	 'Eliquis VTEt'          as [Mkt]          
	,'Eliquis (VTEt) Market'   as [MktName]      
	,'000'             as [Prod]         
	,'Eliquis (VTEt) Market'   as [ProductName]  
	,'N'                 as [Molecule]     
	,'N'                 as [Class]        
	, b.ATC3_COD          as [ATC3_Cod]     
	,ATC_Code            as [ATC_CPA]      
	,Molecule_CN_Src     as [Mole_Des_CN]  
	,Molecule_EN         as [Mole_Des_EN]  
	,Product_CN_Src      as [Prod_Des_CN]  
	,subString(Product_EN,0,charindex('(',Product_EN)) as [Prod_Des_EN]  
	,'Y' as [FocusedBrand] 
	,Mole_Code_IMS       as [IMSMoleCode]  
	,''                  as [IMSProdCode]  
	,'Eliquis VTEt'        as [Product] 
from tblPackageXRefHosp a 
join (	select *  from BMSChinaCIA_IMS.dbo.tblMktDef_MRBIChina_All where molecule='N' and class='N'
		) b 
	on subString(a.Product_EN,0,charindex('(',a.Product_EN))=b.ProductName
where a.Mole_Code_IMS in ('239900', '406260','408800','408827','413885','703259','704307','711981', '904100', '999999')

go
insert into tblMktDefHospital
select distinct
	 'Eliquis VTEt'          as [Mkt]          
	,'Eliquis (VTEt) Market'   as [MktName]      
	,b.Prod              as [Prod]         
	,b.ProductName   as [ProductName]  
	,'N'                 as [Molecule]     
	,'N'                 as [Class]        
	, b.ATC3_COD          as [ATC3_Cod]     
	,ATC_Code            as [ATC_CPA]      
	,Molecule_CN_Src     as [Mole_Des_CN]  
	,Molecule_EN         as [Mole_Des_EN]  
	,Product_CN_Src      as [Prod_Des_CN]  
	,subString(Product_EN,0,charindex('(',Product_EN)) as [Prod_Des_EN]  
	,'Y' as [FocusedBrand] 
	,Mole_Code_IMS       as [IMSMoleCode]  
	,''                  as [IMSProdCode]  
	,'Eliquis VTEt'        as [Product] 
from tblPackageXRefHosp a 
	join (	select *  from BMSChinaCIA_IMS.dbo.tblMktDef_MRBIChina_All 
			where molecule='N' and class='N' and Prod <> '600'
		) b 
	on subString(a.Product_EN,0,charindex('(',a.Product_EN))=b.ProductName
where  b.Mkt='Eliquis VTEt' 
go

delete from tblMktDefHospital where [Mkt] = 'Eliquis NOAC'
go
insert into tblMktDefHospital
select distinct
	 'Eliquis NOAC'          as [Mkt]          
	,'Eliquis (NOAC) Market'   as [MktName]      
	,'000'             as [Prod]         
	,'Eliquis (NOAC) Market'   as [ProductName]  
	,'N'                 as [Molecule]     
	,'N'                 as [Class]        
	, b.ATC3_COD          as [ATC3_Cod]     
	,ATC_Code            as [ATC_CPA]      
	,Molecule_CN_Src     as [Mole_Des_CN]  
	,Molecule_EN         as [Mole_Des_EN]  
	,Product_CN_Src      as [Prod_Des_CN]  
	,subString(Product_EN,0,charindex('(',Product_EN)) as [Prod_Des_EN]  
	,'Y' as [FocusedBrand] 
	,Mole_Code_IMS       as [IMSMoleCode]  
	,''                  as [IMSProdCode]  
	,'Eliquis NOAC'        as [Product] 
from tblPackageXRefHosp a 
join (select *  from BMSChinaCIA_IMS.dbo.tblMktDef_MRBIChina_All where molecule='N' and class='N'
		) b 
	on subString(a.Product_EN,0,charindex('(',a.Product_EN))=b.ProductName
where  subString(a.Product_EN,0,charindex('(',a.Product_EN)) in('Eliquis','XARELTO','PRADAXA')

go
insert into tblMktDefHospital
select distinct
	 'Eliquis NOAC'          as [Mkt]          
	,'Eliquis (NOAC) Market'   as [MktName]      
	,b.Prod              as [Prod]         
	,b.ProductName   as [ProductName]  
	,'N'                 as [Molecule]     
	,'N'                 as [Class]        
	, b.ATC3_COD          as [ATC3_Cod]     
	,ATC_Code            as [ATC_CPA]      
	,Molecule_CN_Src     as [Mole_Des_CN]  
	,Molecule_EN         as [Mole_Des_EN]  
	,Product_CN_Src      as [Prod_Des_CN]  
	,subString(Product_EN,0,charindex('(',Product_EN)) as [Prod_Des_EN]  
	,'Y' as [FocusedBrand] 
	,Mole_Code_IMS       as [IMSMoleCode]  
	,''                  as [IMSProdCode]  
	,'Eliquis NOAC'        as [Product] 
from tblPackageXRefHosp a 
	join (select *  from BMSChinaCIA_IMS.dbo.tblMktDef_MRBIChina_All where molecule='N' and class='N'
		) b 
	on subString(a.Product_EN,0,charindex('(',a.Product_EN))=b.ProductName
where  b.Mkt='Eliquis NOAC' 

SET ansi_warnings ON
GO

-- add vtep and vtet rat
-- update tblMktDefHospital
-- set rat = 0
-- where 

--------------------------------------------------
--	Coinel Market
--------------------------------------------------
delete from tblMktDefHospital where [Mkt] = 'CCB'

insert into tblMktDefHospital
select distinct
	'CCB'          as [Mkt]          
	,'CCB Market'   as [MktName]      
	,b.Prod              as [Prod]         
	,b.ProductName   as [ProductName]  
	,b.[Molecule]     
	,b.[Class]        
	, b.ATC3_COD          as [ATC3_Cod]     
	,ATC_Code            as [ATC_CPA]      
	,Molecule_CN_Src     as [Mole_Des_CN]  
	,Molecule_EN         as [Mole_Des_EN]  
	,Product_CN_Src      as [Prod_Des_CN]  
	,subString(Product_EN,0,charindex('(',Product_EN)) as [Prod_Des_EN]  
	,'Y' as [FocusedBrand] 
	,Mole_Code_IMS       as [IMSMoleCode]  
	,''                  as [IMSProdCode]  
	,'Coniel'        as [Product] 
from tblPackageXRefHosp a 
	join BMSChinaCIA_IMS.dbo.tblMktDef_MRBIChina_All b 
	on a.mole_code_ims =b.mole_cod 
	and
	left(a.Product_EN,len(a.product_en)-5)=b.prod_name
	--subString(a.Product_EN,0,charindex('(',a.Product_EN))=b.prod_name
where  b.Mkt='ccb' and class <>'Y' 
--and b.prod_name not in ('Coniel','Yuan Zhi','Zanidip','Lacipil','Norvasc','Adalat','Plendil')



insert into tblMktDefHospital
select t1.*
from (
	select distinct
	 'CCB'          as [Mkt]          
	,'CCB Market'   as [MktName]      
	,b.Prod              as [Prod]         
	,b.ProductName   as [ProductName]  
	,b.[Molecule]     
	,b.[Class]        
	, b.ATC3_COD          as [ATC3_Cod]     
	,ATC_Code            as [ATC_CPA]      
	,Molecule_CN_Src     as [Mole_Des_CN]  
	,Molecule_EN         as [Mole_Des_EN]  
	,Product_CN_Src      as [Prod_Des_CN]  
	,subString(Product_EN,0,charindex('(',Product_EN)) as [Prod_Des_EN]  
	,'Y' as [FocusedBrand] 
	,Mole_Code_IMS       as [IMSMoleCode]  
	,''                  as [IMSProdCode]  
	,'Coniel'        as [Product] 
	from (select t1.* from tblPackageXRefHosp t1 except (
				select distinct a.*
				from tblPackageXRefHosp a 
					join BMSChinaCIA_IMS.dbo.tblMktDef_MRBIChina_All b 
					on 
					left(a.Product_EN,len(a.product_en)-5)=b.prod_name
					--subString(a.Product_EN,0,charindex('(',a.Product_EN))=b.prod_name
				where  b.Mkt='ccb' and class <>'Y' 
			)
	) a 
	join BMSChinaCIA_IMS.dbo.tblMktDef_MRBIChina_All b 
	on a.mole_code_ims =b.mole_cod 
	where  b.Mkt='ccb' and class <>'Y' 
) t1 where not exists (	
	select 1 from tblMktDefHospital t2
	where t2.mkt='ccb' and t1.prod=t2.prod and t1.prod_des_en=t2.prod_des_en and t2.prod in ('000','940')
)	and not exists(
	select 1 from tblMktDefHospital t3
	where t3.mkt='ccb' and t1.prod=t3.prod and t1.productname=t3.productname and t3.prod not in ('000','940')
)
	--and b.prod_name in ('Coniel','Yuan Zhi','Zanidip','Lacipil','Norvasc','Adalat','Plendil')



-- select * from tblMktDefHospital where [Mkt] = 'Eliquis'

-- select * from tblMktDefHospital where [Mkt] = 'NIAD'
-- select * from tblMktDefHospital where Product = 'Taxol'

--




--后期处理：
update tblMktDefHospital set ProductName = 'DPP-IV'
where productName in ('DPP4', 'DPP-IV') 
go
alter table tblMktDefHospital add rat float
go
-- update tblMktDefHospital set rat=1
-- where mkt like 'eliquis VTEp' and prod_des_en='ARIXTRA'
-- update tblMktDefHospital set rat=1
-- where mkt like 'eliquis VTEp%' and prod_des_en='CLEXANE'
-- update tblMktDefHospital set rat=1
-- where mkt like 'eliquis VTEp%' and prod_des_en='ELIQUIS'
-- update tblMktDefHospital set rat=1
-- where mkt like 'eliquis VTEp%' and prod_des_en='FRAXIPARINE'
-- update tblMktDefHospital set rat=1
-- where mkt like 'eliquis VTEp%' and prod_des_en='XARELTO'

update a
set a.rat = b.rat
from tblMktDefHospital  as a 
inner join BMSChinaCIA_IMS.dbo.inMktDef_MRBIChina_rat as b 
on a.Mkt = b.Mkt and a.IMSMoleCode = b.Mole_Cod and b.IsMole = 'Y'

update tblMktDefHospital set rat=1
where mkt like 'eliquis noac' and prod_des_en='Eliquis'
update tblMktDefHospital set rat=1
where mkt like 'eliquis noac' and prod_des_en='Xarelto'
update tblMktDefHospital set rat=1
where mkt like 'eliquis noac' and prod_des_en='Pradaxa'

update tblMktDefHospital set rat=1 where  mkt not like 'eliquis%'
--select * from tblMktDefHospital where mktName
--select * into tblMktDefHospital_eliquis from tblMktDefHospital

-- delete the error history data
delete tblMktDefHospital
where Mkt = 'Eliquis VTEp'
	and Prod_Des_en = 'XARELTO'
	and mole_des_en <> 'RIVAROXABAN'

  
--20170321
--only need Baraclude, Monopril, Taxol, Sprycel market 
-- delete tblMktDefHospital 
-- where mkt not in ('ARV', 'ONCFCS', 'CML', 'HYPFCS', 'HYP', 'ACE') 

exec dbo.sp_Log_Event 'Market Define','CIA_CPA','1_2_MktDef.sql','End',null,null
print 'over!'