use BMSCNProc2
go

--HKAPI data month
update tblDataPeriod set DataPeriod = '201212' where QType = 'HKAPI'
GO

/*
Step 1,
Refresh tblPeroid
*/
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
select * from tblPeriod
/*
Step 2, 
Import HKAPI data 
--select top 10 * 
from db4.IMSDBPlus.dbo.inHKAPI_new
into tblHKAPIDataMaster
*/
print('
-----------------------------------
		tblQtrForPivot
--------------------------------')
if object_id(N'tblQtrForPivot',N'U') is not null
	drop table tblQtrForPivot
go

select rank() over(order by DataQrt desc) as QSeq
,DataQrt, right(DataQrt,4)+'LC' as Fld_LC, right(DataQrt, 4)+'US' as Fld_US
into tblQtrForPivot
from tblPeriod
GO

print('
-----------------------------------
		tblHKAPIMaster_RMB
--------------------------------')
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



print('
-----------------------------------
		tblHKAPIMaster_USD
--------------------------------')
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


print('
-----------------------------------
		tblHKAPIDataMaster
--------------------------------')

truncate table tblHKAPIDataMaster;
GO

insert into tblHKAPIDataMaster
select a.Comp, a.Prod, a.DataQrt, SalesRMB*1000, SalesUSD*1000
from tblHKAPIMaster_RMB a inner join tblHKAPIMaster_USD b
on a.Comp=b.Comp and a.Prod=b.Prod and a.DataQrt=b.DataQrt
GO

delete from tblHKAPIDataMaster where SalesRMB=0;
GO

/*
Step 3,
Append new Company/Product
to tblHKAPICompanyList/tblCompanyProductList
*/
--Import new Company list
print('
-----------------------------------
		TempHKAPICompanyList
--------------------------------')
if object_id(N'TempHKAPICompanyList',N'U') is not null
	drop table TempHKAPICompanyList
go

--get all Company lists
select Abbreviation, [Company Name] 
into TempHKAPICompanyList
from OpenRowSet('Microsoft.Jet.OLEDB.4.0'
, 'Excel 8.0;HDR=Yes;IMEX=1;Database=D:\BMSChina_QueryTool\DataSource\China Report 1st half 2012 (Draft).xls', [CompanyName$]) 
GO

delete from TempHKAPICompanyList where Abbreviation is null
GO

print('
---------------Append new Companies
')
insert into tblHKAPICompanyList
select * from TempHKAPICompanyList a 
where not exists (select * from  tblHKAPICompanyList b where a.Abbreviation=b.Comp_Code )
GO
/*

insert into tblHKAPICompanyList
values ('JSN','XIAN-JANSSEN PHARMACEUTICAL LTD')
GO

*/


print('
---------------Append new Products
')
insert into tblCompanyProductList(Comp_Code, Product, Product_Output)
select Comp_Code, Product, Product from 
(
select distinct Comp_Code, Product from tblHKAPIDataMaster
) a where not exists (
select * from tblCompanyProductList b where a.Comp_Code=b.Comp_Code and a.Product=b.Product
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

