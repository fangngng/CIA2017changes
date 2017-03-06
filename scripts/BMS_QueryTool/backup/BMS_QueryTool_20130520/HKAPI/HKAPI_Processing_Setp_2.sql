use BMSCNProc2
go

--HKAPI_QTR_RMB
print('
-----------------------------------
		tblHKAPI_QTR_RMB
--------------------------------')
if object_id(N'tblHKAPI_QTR_RMB',N'U') is not null
	drop table tblHKAPI_QTR_RMB
go

declare @i int, @strPVT varchar(max), @strFields varchar(max)
set @i=1
set @strPVT=''
set @strFields=''
while @i<25
begin
	set @strPVT = @strPVT + 'QTR_'+cast(@i as varchar(5))+','
	set @strFields = @strFields + ', QTR_'+cast(@i as varchar(5))+' as VR_QTR_'+cast(@i as varchar(5))
	set @i=@i+1
end

set @strPVT = left(@strPVT, len(@strPVT)-1)

exec('
select Comp_Code_Output, Company, Product_Output'+@strFields+' 
into tblHKAPI_QTR_RMB
from
(
SELECT c.Comp_Code_Output, d.Company, c.Product_Output, b.VQrt ,sum(a.SalesRMB) as SalesRMB
FROM tblHKAPIDataMaster a 
INNER JOIN tblPeriod b ON a.DataQrt=b.DataQrt
INNER JOIN tblCompanyProductList c ON a.Comp_Code=c.Comp_Code AND a.Product=c.Product
INNER JOIN tblHKAPICompanyList d ON c.Comp_Code_Output=d.Comp_Code
GROUP BY c.Comp_Code_Output, d.Company, c.Product_Output, b.VQrt
) a
pivot (sum(SalesRMB) for VQrt in ('+@strPVT+')
) pvt
')
GO

--HKAPI_QTR_USD
print('
-----------------------------------
		tblHKAPI_QTR_USD
--------------------------------')
if object_id(N'tblHKAPI_QTR_USD',N'U') is not null
	drop table tblHKAPI_QTR_USD
go

declare @i int, @strPVT varchar(max), @strFields varchar(max)
set @i=1
set @strPVT=''
set @strFields=''
while @i<25
begin
	set @strPVT = @strPVT + 'QTR_'+cast(@i as varchar(5))+','
	set @strFields = @strFields + ', QTR_'+cast(@i as varchar(5))+' as VU_QTR_'+cast(@i as varchar(5))
	set @i=@i+1
end

set @strPVT = left(@strPVT, len(@strPVT)-1)

exec('
select Comp_Code_Output, Company, Product_Output'+@strFields+' 
into tblHKAPI_QTR_USD
from
(
SELECT c.Comp_Code_Output, d.Company, c.Product_Output, b.VQrt ,sum(a.SalesUSD) as SalesUSD
FROM tblHKAPIDataMaster a 
INNER JOIN tblPeriod b ON a.DataQrt=b.DataQrt
INNER JOIN tblCompanyProductList c ON a.Comp_Code=c.Comp_Code AND a.Product=c.Product
INNER JOIN tblHKAPICompanyList d ON c.Comp_Code_Output=d.Comp_Code
GROUP BY c.Comp_Code_Output, d.Company, c.Product_Output, b.VQrt
) a
pivot (sum(SalesUSD) for VQrt in ('+@strPVT+')
) pvt
')
GO


print('
-----------------------------------
		tblOutput_HKAPI
--------------------------------')

truncate table tblOutput_HKAPI;
GO

declare @i int, @strFields varchar(max)
set @i=1
set @strFields=''
while @i<25
begin
	set @strFields = @strFields + ', VR_QTR_'+cast(@i as varchar(5))+ ', VU_QTR_'+cast(@i as varchar(5))
	set @i=@i+1
end

exec('
INSERT INTO tblOutput_HKAPI ( Comp_Code, Company, Product_Name'+@strFields+')
SELECT a.Comp_Code_Output, a.Company, a.Product_Output'+@strFields+'
FROM tblHKAPI_QTR_RMB a INNER JOIN tblHKAPI_QTR_USD b
ON a.Product_Output = b.Product_Output AND a.Comp_Code_Output = b.Comp_Code_Output;
')
GO


--Rollup MAT
declare @i int, @strFields varchar(max), @sql varchar(max)
declare @j int, @VRStrFields varchar(max), @VUStrFields varchar(max)
set @i=1
set @strFields=''
while @i<22
begin
	set @j=@i
	set @VRStrFields = ''
	set @VUStrFields = ''
	while @j<@i+4
	begin
		set @VRStrFields = @VRStrFields + '+ isnull(VR_QTR_'+cast(@j as varchar(5))+', 0)'
		set @VUStrFields = @VUStrFields + '+ isnull(VU_QTR_'+cast(@j as varchar(5))+', 0)'
		set @j=@j+1
	end
	set @VRStrFields = right(@VRStrFields, len(@VRStrFields)-1)
	set @VUStrFields = right(@VUStrFields, len(@VUStrFields)-1)
	set @strFields = @strFields + ', VR_MAT_'+cast(@i as varchar(5))+ ' = (' + @VRStrFields + ')'
						    	+ ', VU_MAT_'+cast(@i as varchar(5))+ ' = (' + @VUStrFields + ')'
	set @i=@i+1
end

set @sql = '
update tblOutput_HKAPI set '+right(@strFields, len(@strFields)-2)+'
'
exec(@sql)
GO


--set NULL to 0
declare @i int, @sql varchar(max)
set @i=1
while @i<25
begin
	if @i<22
	begin
		set @sql = '
		update tblOutput_HKAPI set VR_MAT_'+cast(@i as varchar(5))+ ' = 0 where VR_MAT_'+cast(@i as varchar(5))+ ' is null;
		update tblOutput_HKAPI set VU_MAT_'+cast(@i as varchar(5))+ ' = 0 where VU_MAT_'+cast(@i as varchar(5))+ ' is null;
		'
	end

	set @sql = @sql + '
	update tblOutput_HKAPI set VR_QTR_'+cast(@i as varchar(5))+ ' = 0 where VR_QTR_'+cast(@i as varchar(5))+ ' is null;
	update tblOutput_HKAPI set VU_QTR_'+cast(@i as varchar(5))+ ' = 0 where VU_QTR_'+cast(@i as varchar(5))+ ' is null;
	'
	exec(@sql)
	set @i=@i+1
end
GO


print('
---------------Refresh tblQueryToolDriverHK
')

insert into tblQueryToolDriverHK
select distinct Comp_Code, Company, Product_Name from tblOutput_HKAPI a where not exists
(
select * from tblQueryToolDriverHK  b
where a.Comp_Code=b.Comp_Code and a.Company=b.Company and a.Product_Name=b.Product_Name)
GO
