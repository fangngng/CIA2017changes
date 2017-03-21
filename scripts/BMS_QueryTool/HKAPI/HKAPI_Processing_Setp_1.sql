/*
前置依赖：

db4.BMSChinaOtherDB.dbo.inHKAPI_new

OpenRowSet('Microsoft.Jet.OLEDB.4.0'
, 'Excel 8.0;HDR=Yes;IMEX=1;Database=D:\BMSChina_QueryTool\DataSource\China Report 1st half 2012 (Draft).xls'
, [CompanyName$]) 
GO
*/



use BMSCNProc2_test
GO

exec dbo.sp_Log_Event 'Process','QT_HKAPI','HKAPI_Processing_Setp_1.sql','Start',null,null



update tblDataPeriod set DataPeriod = '201612'  --todo : HKAPI data month
where QType = 'HKAPI'
GO










declare 
  @curDate  varchar(6), 
  @lastDate varchar(6)
  
select @curDate= DataPeriod from tblDataPeriod where QType = 'HKAPI'
set @lastDate = convert(varchar(6), dateadd(month, -3, cast(@curDate+'01' as datetime)), 112)

exec('
if object_id(N''BMSCNProc_bak.dbo.tblHKAPICompanyList_'+@lastDate+''',N''U'') is null
   select * into BMSCNProc_bak.dbo.tblHKAPICompanyList_'+@lastDate+'
   from tblHKAPICompanyList
');
exec('
if object_id(N''BMSCNProc_bak.dbo.tblCompanyProductList_'+@lastDate+''',N''U'') is null
   select * into BMSCNProc_bak.dbo.tblCompanyProductList_'+@lastDate+'
   from tblCompanyProductList
');
GO

declare @HKAPIDataPrd varchar(6), @HKAPIDataMth int, @HKAPIDataQtr varchar(6)

select @HKAPIDataPrd=DataPeriod from tblDataPeriod where QType = 'HKAPI'
set @HKAPIDataMth = cast(right(@HKAPIDataPrd,2) as int)

if @HKAPIDataMth in (1,2,3)
	set @HKAPIDataQtr = left(@HKAPIDataPrd,4)+'Q1'
else if @HKAPIDataMth in (4,5,6)
	set @HKAPIDataQtr = left(@HKAPIDataPrd,4)+'Q2'
else if @HKAPIDataMth in (7,8,9)
	set @HKAPIDataQtr = left(@HKAPIDataPrd,4)+'Q3'
else
	set @HKAPIDataQtr = left(@HKAPIDataPrd,4)+'Q4'

if not exists(select * from tblPeriod where DataQrt = @HKAPIDataQtr)
begin
	delete from tblPeriod where VQrt='QTR_24';
	update tblPeriod set VQrt = 'QTR_' + cast((cast(replace(VQrt,'QTR_','') as int) + 1) as varchar(10));
	insert into tblPeriod(DataQrt, VQrt) values(@HKAPIDataQtr, 'QTR_1');
end
GO

if object_id(N'tblQtrForPivot',N'U') is not null
	drop table tblQtrForPivot
go

select rank() over(order by DataQrt desc) as QSeq
,DataQrt, right(DataQrt,4)+'LC' as Fld_LC, right(DataQrt, 4)+'US' as Fld_US
into tblQtrForPivot
from tblPeriod
GO





--db4.BMSChinaOtherDB.dbo.inHKAPI_new --> tblHKAPIMaster_RMB, tblHKAPIMaster_USD -->tblHKAPIDataMaster
if object_id(N'tblHKAPIMaster_RMB',N'U') is not null
	drop table tblHKAPIMaster_RMB
go

declare @str varchar(max), @strField1 varchar(max), @strField2 varchar(max)
set @str =
(select '['+Fld_LC+'] as ['+DataQrt+']' vl  FROM tblQtrForPivot N
FOR XML AUTO )
set @strField1 = replace(replace(@str,'<N vl="', ','), '"/>', '')
set @str =
(select '['+DataQrt+']' vl  FROM tblQtrForPivot N
FOR XML AUTO )
set @strField2 = replace(replace(@str,'<N vl="', ','), '"/>', '')
set @strField2 = right(@strField2,len(@strField2)-1)

declare @sql varchar(max)
set @sql = '
select Comp, Prod, DataQrt, SalesRMB
into tblHKAPIMaster_RMB
from
(
select [Company Name] as Comp, [Product Name] as Prod'+@strField1+'
from db4.BMSChinaOtherDB.dbo.inHKAPI_new
) p
unpivot (
SalesRMB for DataQrt in ('+@strField2+')
) as unpvt
'
exec(@sql);
GO

if object_id(N'tblHKAPIMaster_USD',N'U') is not null
	drop table tblHKAPIMaster_USD
go

declare @str varchar(max), @strField1 varchar(max), @strField2 varchar(max)
set @str =
(select '['+Fld_US+'] as ['+DataQrt+']' vl  FROM tblQtrForPivot N
FOR XML AUTO )
set @strField1 = replace(replace(@str,'<N vl="', ','), '"/>', '')
set @str =
(select '['+DataQrt+']' vl  FROM tblQtrForPivot N
FOR XML AUTO )
set @strField2 = replace(replace(@str,'<N vl="', ','), '"/>', '')
set @strField2 = right(@strField2,len(@strField2)-1)

declare @sql varchar(max)
set @sql = '
select Comp, Prod, DataQrt, SalesUSD
into tblHKAPIMaster_USD
from
(
select [Company Name] as Comp, [Product Name] as Prod'+@strField1+'
from db4.BMSChinaOtherDB.dbo.inHKAPI_new
) p
unpivot (
SalesUSD for DataQrt in ('+@strField2+')
) as unpvt
'
exec(@sql);
GO

truncate table tblHKAPIDataMaster;
GO

insert into tblHKAPIDataMaster
select a.Comp, a.Prod, a.DataQrt, SalesRMB*1000, SalesUSD*1000
from tblHKAPIMaster_RMB a inner join tblHKAPIMaster_USD b
on a.Comp=b.Comp and a.Prod=b.Prod and a.DataQrt=b.DataQrt
GO

delete from tblHKAPIDataMaster 
where SalesRMB > 0 and SalesUSD=0
GO
delete from tblHKAPIDataMaster where SalesRMB=0;
GO

update tblHKAPIDataMaster set salesRMB=0,salesUSD=0
where comp_code='ABBV' and left(DataQrt,4)='2012' and product in
	(select distinct product from tblHKAPIDataMaster where comp_code='ABT' )





---Append new Company/Product -- > tblHKAPICompanyList/tblCompanyProductList
truncate table TempHKAPICompanyList
go


-- insert into TempHKAPICompanyList
-- select Abbreviation, [Company Name] 
-- from OpenRowSet('Microsoft.Jet.OLEDB.4.0'
-- , 'Excel 8.0;HDR=Yes;IMEX=1;Database=D:\BMSChina_QueryTool\DataSource\China Report 1st half 2012 (Draft).xls', [CompanyName$]) 
-- GO--get all Company lists

delete from TempHKAPICompanyList where Abbreviation is null
GO

insert into tblHKAPICompanyList(Comp_Code, Company)
select distinct * 
from TempHKAPICompanyList 
where Abbreviation not in (
                           select distinct Comp_Code from tblHKAPICompanyList
                           )
GO--Append new Companies



--insert into tblHKAPICompanyList values ('JSN','XIAN-JANSSEN PHARMACEUTICAL LTD')

insert into tblCompanyProductList(Comp_Code, Product, Product_Output)
select Comp_Code, Product, Product 
from (
     select distinct Comp_Code, Product from tblHKAPIDataMaster
     ) a 
where not exists (
                  select * from tblCompanyProductList b 
                  where a.Comp_Code=b.Comp_Code and a.Product=b.Product
                 )
GO

--for exist company
update tblCompanyProductList set Comp_Code_Output = b.Comp_Code_Output
from tblCompanyProductList a inner join (
select distinct Comp_Code, Comp_Code_Output from tblCompanyProductList
) b
on a.Comp_Code = b.Comp_Code
where a.Comp_Code_Output is null or a.Comp_Code_Output='';
GO

--for new company
update tblCompanyProductList set Comp_Code_Output = Comp_Code
where Comp_Code_Output is null or Comp_Code_Output='';
GO


--update abt to abbv
update tblCompanyProductList
set comp_code_output= case  --when comp_code_output= 'abt' then 'abbv' 
							when comp_code_output= 'dss' then 'DSC' end
where comp_code <> Comp_Code_Output and comp_code_output in ('dss')

exec dbo.sp_Log_Event 'Process','QT_HKAPI','HKAPI_Processing_Setp_1.sql','End',null,null
