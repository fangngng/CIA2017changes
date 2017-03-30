/* 

修改时间: 2013/5/2 17:09:29
处理内容：MarketDefinition 

前置依赖：
DB4.BMSChinaMRBI.dbo.tblPackageXRefHosp 
*/
use BMSCNProc2
go






exec dbo.sp_Log_Event 'MKT','QT_CPA_Inline','0_2_MktDefinition.sql','Start',null,null




--1. Backup：
declare 
  @curHOSP_I varchar(6), 
  @lastHOSP_I varchar(6)
  
select @curHOSP_I= DataPeriod from tblDataPeriod where QType = 'HOSP_I'
set @lastHOSP_I = convert(varchar(6), dateadd(month, -1, cast(@curHOSP_I+'01' as datetime)), 112)
exec('
if object_id(N''BMSCNProc_bak.dbo.tblQueryToolDriverHosp_'+@lastHOSP_I+''',N''U'') is null
   select * into BMSCNProc_bak.dbo.tblQueryToolDriverHosp_'+@lastHOSP_I+'
   from tblQueryToolDriverHosp
');
GO




--2.1 update：
truncate table tblQueryToolDriverHosp
GO

insert into tblQueryToolDriverHosp
select distinct a.MktType, a.Mkt, a.MktName, a.Class, a.Mole_Cod, a.Mole_Des, 
                b.Product_Code, upper(b.Product_EN) as Product_EN, b.Package_Code, 
                upper(b.Package_Name) as Package_Name,  Null as Corp_Cod, null as Corp_Des
                , b.Manu_ID, upper(b.Manu_EN) as Manu_EN, b.MNC, 'N' as ClsInd,1
from DB4.BMSChinaMRBI.dbo.tblPackageXRefHosp  b 
inner join (
           select distinct MktType, Mkt, MktName, Class, Mole_Cod, Mole_Des 
           from tblQueryToolDriverIMS 
           where MktType='In-line Market'        
           ) a 
on a.Mole_Des=b.molecule_en
where b.package_code is not null
--where b.Mole_Code_IMS in (
--                         select Mole_Cod from tblQueryToolDriverIMS
--                          where MktType = 'In-line Market'
--                          )
GO



delete from tblQueryToolDriverHosp where mkt like 'eliquis%'


-- ---- 2.2 特殊处理： Hosp:Eliquis market[Eliquis(艾乐妥) and Xarelto (拜瑞妥)] 新增FRAXIPARINE，CLEXANE，ARIXTRA（安卓）三种产品，组成Eliquis VTEp Market
-- --2.2 特殊处理： Eliquis VTEp Market
-- insert into tblQueryToolDriverHosp
-- select distinct 
--   'In-line Market' as MktType, 'ELIQUIS VTEp' as Mkt, 'ELIQUIS(VTEp) MARKET' as MktName
--   ,'NA' as Class, Mole_Code_IMS as Mole_Cod, Molecule_EN as Mole_Des
--   , Product_Code, upper(Product_EN) as Product_EN
--   , Package_Code, upper(Package_Name) as Package_Name
--   , Null as Corp_Cod, null as Corp_Des 
--   , Manu_ID, upper(Manu_EN) as Manu_EN, MNC, 'N' as ClsInd,1
-- from DB4.BMSChinaMRBI.dbo.tblPackageXRefHosp 
-- where Mole_Code_IMS in ('406260','408800','408827','413885','703259','704307','710047','711981','719372', '904100', '999999')
--   and Product_EN <> '%CONTRACTUBEX%' -- 去掉复方
-- --where ltrim(rtrim(substring(Product_EN,1,charindex('(',Product_EN)-1)))  in('Eliquis','Xarelto','FRAXIPARINE','CLEXANE','ARIXTRA') 
-- --FRAXIPARINE+CLEXANE+XARELTO+ELIQUIS+ARIXTRA（安卓）
GO
-- insert into tblQueryToolDriverHosp
-- select distinct 
-- 'In-line Market' as MktType, 'ELIQUIS NOAC' as Mkt, 'ELIQUIS(NOAC) MARKET' as MktName
-- ,'NA' as Class, Mole_Code_IMS as Mole_Cod, Molecule_EN as Mole_Des
-- , Product_Code, upper(Product_EN) as Product_EN
-- , Package_Code, upper(Package_Name) as Package_Name
-- , Null as Corp_Cod, null as Corp_Des 
-- , Manu_ID, upper(Manu_EN) as Manu_EN, MNC, 'N' as ClsInd,1
-- from DB4.BMSChinaMRBI.dbo.tblPackageXRefHosp 
-- where ltrim(rtrim(substring(Product_EN,1,charindex('(',Product_EN)-1)))  in('Eliquis','XARELTO','PRADAXA')
-- --FRAXIPARINE+CLEXANE+XARELTO+ELIQUIS+ARIXTRA（安卓）

-- 20161102
-- insert into tblQueryToolDriverHosp
-- select distinct 
--   'In-line Market' as MktType, 'ELIQUIS VTEt' as Mkt, 'ELIQUIS(VTEt) MARKET' as MktName
--   ,'NA' as Class, Mole_Code_IMS as Mole_Cod, Molecule_EN as Mole_Des
--   , Product_Code, upper(Product_EN) as Product_EN
--   , Package_Code, upper(Package_Name) as Package_Name
--   , Null as Corp_Cod, null as Corp_Des 
--   , Manu_ID, upper(Manu_EN) as Manu_EN, MNC, 'N' as ClsInd, 1
-- from DB4.BMSChinaMRBI.dbo.tblPackageXRefHosp 
-- where Mole_Code_IMS in ('406260','408800','408827','413885','703259','704307','710047','711981','719372', '239900', '904100', '999999')
--    and Product_EN <> '%CONTRACTUBEX%' -- 去掉复方
GO
-- delete from tblQueryToolDriverHosp where Mkt like 'ELIQUIS%' and prod_des like 'XARELTO%' and mole_des not in ('RIVAROXABAN')
GO
-- --2.3 OTC Market
-- insert into tblQueryToolDriverHosp
-- select distinct 
-- 	'In-line Market' as MktType, 'OTC' as Mkt, 'OTC MARKET' as MktName
-- 	,'NA' as Class, Mole_Code_IMS as Mole_Cod, Molecule_EN as Mole_Des
-- 	, Product_Code, upper(Product_EN) as Product_EN
-- 	, Package_Code, upper(Package_Name) as Package_Name
-- 	, Null as Corp_Cod, null as Corp_Des 
-- 	, Manu_ID, upper(Manu_EN) as Manu_EN, MNC, 'N' as ClsInd,1
-- from DB4.BMSChinaMRBI.dbo.tblPackageXRefHosp_OTC 


--2.3 Special Monopril Market only include 4 Products:   acertil,lotensin,monopril,tritace  
delete from tblQueryToolDriverHosp
where Mkt='HYPM' 
	and ltrim(rtrim(substring(Prod_Des,1,charindex('(',Prod_Des)-1))) 
	not in ('ACERTIL','LOTENSIN','MONOPRIL','TRITACE')

delete from tblQueryToolDriverHosp
where mktname in ('HYPERTENSION MARKET','CONIEL MARKET') and mole_des='bisoprolol'

GO
--Added by Alince.wang 2015.09.18

--select * into tblDefProduct_CN_EN_QT from db4.BMSChinaMRBI.dbo.tblDefProduct_CN_EN
--where prod_CN like N'拜新同' or prod_CN like N'波依定' or prod_CN like N'可力洛' or prod_CN like N'乐息平'
--or prod_CN like N'络活喜' or prod_CN like N'元治' or prod_CN like N'再宁平'


update tblQueryToolDriverHosp set prod_des=b.prod_en
from tblQueryToolDriverHosp a
inner join tblDefProduct_CN_EN_QT b
on reverse(substring(reverse(a.prod_des) ,charindex('(',reverse(a.prod_des)) + 1 , len(a.prod_des)))=b.prod_en

update tblQueryToolDriverHosp set prod_cod='H'+a.mole_cod
from tblQueryToolDriverHosp a
inner join tblDefProduct_CN_EN_QT b
on a.prod_des=b.prod_en

--set the final product code
if object_id(N'test_tblQueryToolDriverHosp',N'U') is not null
	drop table test_tblQueryToolDriverHosp
GO
select distinct  prod_cod, prod_des 
into test_tblQueryToolDriverHosp from tblQueryToolDriverHosp
GO

update tblQueryToolDriverHosp 
set prod_cod = b.prod_cod + replicate('0',3-len(rnk)) + rnk
-- select *, b.Product_code + replicate('0',3-len(rnk)) + rnk
from tblQueryToolDriverHosp a
inner join (
	select  prod_cod, prod_des
	  , cast(row_number() over(partition by prod_cod order by prod_des) as varchar) as rnk 
	from test_tblQueryToolDriverHosp
	) b 
on a.prod_cod = b.prod_cod and a.prod_des = b.prod_des
GO

update tblQueryToolDriverHosp 
set manu_cod=null , manu_des=null , mnc=null
from tblQueryToolDriverHosp a
inner join tblDefProduct_CN_EN_QT b
on a.prod_des=b.prod_en

GO
-- 20170321
-- only need Taxol, Sprycel, Monopril, Baraclude market in querytool 
delete tblQueryToolDriverHosp 
where Mkt not in ('ONCFCS', 'CML', 'HYPM', 'ARV')


-- update tblQueryToolDriverHosp set rat=1
-- where mkt like 'ELIQUIS VTEp'

-- update tblQueryToolDriverHosp set rat=1
-- where mkt like 'ELIQUIS VTEt'

-- update tblQueryToolDriverHosp set rat=1
-- where mkt like 'ELIQUIS VTEp' and prod_des like 'ARIXTRA%'
-- update tblQueryToolDriverHosp set rat=1
-- where mkt like 'ELIQUIS VTEp' and prod_des like 'CLEXANE%'
-- update tblQueryToolDriverHosp set rat=1
-- where mkt like 'ELIQUIS VTEp' and prod_des like 'ELIQUIS%'
-- update tblQueryToolDriverHosp set rat=1
-- where mkt like 'ELIQUIS VTEp' and prod_des like 'FRAXIPARINE%'
-- update tblQueryToolDriverHosp set rat=1
-- where mkt like 'ELIQUIS VTEp' and prod_des like 'XARELTO%'

-- update tblQueryToolDriverHosp set rat=1
-- where mkt like 'ELIQUIS VTEt' and prod_des like 'Eliquis%'
-- update tblQueryToolDriverHosp set rat=1
-- where mkt like 'ELIQUIS VTEt' and prod_des like 'Xarelto%'
-- update tblQueryToolDriverHosp set rat=1
-- where mkt like 'ELIQUIS VTEt' and prod_des like 'Pradaxa%'

exec dbo.sp_Log_Event 'MKT','QT_CPA_Inline','0_2_MktDefinition.sql','End',null,null