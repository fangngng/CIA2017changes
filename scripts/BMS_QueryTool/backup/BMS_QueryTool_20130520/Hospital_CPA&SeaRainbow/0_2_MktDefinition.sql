/* 

修改时间: 2013/5/2 17:09:29
处理内容：市场定义表

前置依赖：
DB4.BMSChinaMRBI.dbo.tblPackageXRefHosp      --产品定义表

*/
use BMSCNProc2
go


-- Backup：
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


-- update：
truncate table tblQueryToolDriverHosp
GO
insert into tblQueryToolDriverHosp
select distinct a.MktType, a.Mkt, a.MktName, a.ATC3_Cod, a.Class, a.Mole_Cod, a.Mole_Des, 
                b.Product_Code, upper(b.Product_EN) as Product_EN, b.Package_Code, 
                upper(b.Package_Name) as Package_Name,  Null as Corp_Cod, null as Corp_Des
                , b.Manu_ID, upper(b.Manu_EN) as Manu_EN, b.MNC, 'N' as ClsInd
from tblPackageXRefHosp b 
inner join (
           select distinct MktType, Mkt, MktName, ATC3_Cod, Class, Mole_Cod, Mole_Des 
           from tblQueryToolDriverIMS
           where MktType='In-line Market'
           ) a 
on a.Mole_cod=b.Mole_Code_IMS
where b.Mole_Code_IMS in (
                          select Mole_Cod from tblQueryToolDriverIMS
                          where MktType='In-line Market'
                          )
GO

-- 特殊处理：

--Special Monopril Market only include 4 Products:   acertil,lotensin,monopril,tritace  
delete from tblQueryToolDriverHosp
where Mkt='HYPM' 
and ltrim(rtrim(substring(Prod_Des,1,charindex('(',Prod_Des)-1))) 
not in ('ACERTIL','LOTENSIN','MONOPRIL','TRITACE')
GO
