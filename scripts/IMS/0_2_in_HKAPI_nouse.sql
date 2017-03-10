use BMSChinaOtherDB
GO

--Time: 00:05
exec BMSChinaCIA_IMS_test.dbo.sp_Log_Event 'In','CIA','0_2_in_HKAPI.sql','Start',null,null

----create table hkapi_Time_Config (Quarter varchar(10))
--insert into BMSChinaOtherDB.dbo.hkapi_Time_Config (Quarter)
--select '2010Q4'
--union all
--select '2011H1'
--union all
--select '2011Q1'
--union all
--select '2011Q3'
--union all
--select '2011Q4'
--union all
--select '2012Q1'
--union all
--select '2012Q2'
--union all
--select '2012Q3'
--union all
--select '2012Q4'
--union all
--select '2013Q1'
--union all
--select '2013Q2'
--union all
--select '2013Q3'
--union all
--select '2013Q4'
declare @currQuarter varchar(10)
select @currQuarter = convert(varchar(6),Year)+Qtr
from BMSChinaCIA_IMS_test.dbo.tblDateHKAPI 
--print @currQuarter
--select * from BMSChinaCIA_IMS_test.dbo.tblDateHKAPI

if not exists(select 1 from BMSChinaOtherDB.dbo.hkapi_Time_Config where Quarter=@currQuarter)
begin
	insert into BMSChinaOtherDB.dbo.hkapi_Time_Config (Quarter)
	values(@currQuarter)
end

declare  updateProduct cursor for 
select distinct  [company name],[product name],[New Product Name] 
from dbo.HKAPI_Update_ProductName_List

open updateProduct
declare @companyName nvarchar(225)
declare @productName nvarchar(225)
--declare @Quarter nvarchar(225)
declare @NewProductName nvarchar(225)
declare @sql varchar(4000)
set @sql=' '
fetch next from updateProduct into @companyname,@productName,@NewProductName
while @@FETCH_STATUS =0
begin
	set @sql= 'update HKAPI_'+@currQuarter+' 
			   set [product name]='''+replace(@NewProductName,'''','''''')+'''
			   where [company name]='''+@companyName+''' and [product name] ='''+replace(@productName,'''','''''')+''''
	print @sql	
	exec (@sql)
	
	if @currQuarter<>'2010Q4'
	begin
		set @sql= 'update HKAPI_'+@currQuarter+'STLY'+' 
				   set [product name]='''+replace(@NewProductName,'''','''''')+'''
				   where [company name]='''+@companyName+''' and [product name] ='''+replace(@productName,'''','''''')+''''		  
		print @sql	 
		exec (@sql)
	end	
	   
	fetch next from updateProduct into @companyname,@productName,@NewProductName
end

close updateProduct
deallocate updateProduct

GO
declare @currQuarter varchar(10)
select @currQuarter = convert(varchar(6),Year)+Qtr
from BMSChinaCIA_IMS_test.dbo.tblDateHKAPI 
print @currQuarter


declare  updateCompany cursor for 
select distinct Old_Company_Name,New_Company_Name from dbo.HKAPI_Company_Update_List
	
open updateCompany
declare @OldcompanyName nvarchar(225)
--declare @Quarter nvarchar(225)
declare @NewCompanyName nvarchar(225)
declare @sql varchar(4000)
set @sql=' '
fetch next from updateCompany into @OldcompanyName,@NewCompanyName
while @@FETCH_STATUS =0
begin
	set @sql= 'update HKAPI_'+@currQuarter+' 
			   set [company name]='''+@NewCompanyName+'''
			   where [company name]='''+@OldcompanyName+'''' 
	print @sql	
	exec (@sql)
	
	if @currQuarter<>'2010Q4'
	begin
		set @sql= 'update HKAPI_'+@currQuarter+'STLY'+' 
				   set [company name]='''+@NewCompanyName+'''
				   where [company name]='''+@OldcompanyName+'''' 	  
		print @sql	 
		exec (@sql)
	end   
	fetch next from updateCompany into @OldcompanyName,@NewCompanyName
end

close updateCompany
deallocate updateCompany

go

/*************************Update RawData****************************
--backup all rawdata
	--dbo.[HKAPI_2010Q4]
	if object_id(N'dbo.HKAPI_2010Q4_bak_20140109',N'U') is  null
		--drop table HKAPI_2011H1_bak_20140109
	select * into HKAPI_2010Q4_bak_20140109 from dbo.HKAPI_2010Q4

	--dbo.HKAPI_2011H1
	if object_id(N'dbo.HKAPI_2011H1_bak_20140109',N'U') is  null
		--drop table HKAPI_2011H1_bak_20140109
	select * into HKAPI_2011H1_bak_20140109 from dbo.HKAPI_2011H1

	--dbo.HKAPI_2011H1STLY
	if object_id(N'dbo.HKAPI_2011H1STLY_bak_20140109',N'U') is  null
		--drop table HKAPI_2011H1STLY_bak_20140109
	select * into HKAPI_2011H1STLY_bak_20140109 from dbo.HKAPI_2011H1STLY

	--dbo.HKAPI_2011Q1
	if object_id(N'dbo.HKAPI_2011Q1_bak_20140109',N'U') is  null
		--drop table HKAPI_2011Q1_bak_20140109
	select * into HKAPI_2011Q1_bak_20140109 from dbo.HKAPI_2011Q1


	--dbo.HKAPI_2011Q1STLY
	if object_id(N'dbo.HKAPI_2011Q1STLY_bak_20140109',N'U') is  null
		--drop table HKAPI_2011Q1STLY_bak_20140109
	select * into HKAPI_2011Q1STLY_bak_20140109 from dbo.HKAPI_2011Q1STLY

	--dbo.HKAPI_2011Q3
	if object_id(N'dbo.HKAPI_2011Q3_bak_20140109',N'U') is  null
		--drop table HKAPI_2011Q3_bak_20140109
	select * into HKAPI_2011Q3_bak_20140109 from dbo.HKAPI_2011Q3

	--dbo.HKAPI_2011Q3STLY
	if object_id(N'dbo.HKAPI_2011Q3STLY_bak_20140109',N'U') is  null
		--drop table HKAPI_2011Q3STLY_bak_20140109
	select * into HKAPI_2011Q3STLY_bak_20140109 from dbo.HKAPI_2011Q3STLY

	--dbo.HKAPI_2011Q4
	if object_id(N'dbo.HKAPI_2011Q4_bak_20140109',N'U') is  null
		--drop table HKAPI_2011Q4_bak_20140109
	select * into HKAPI_2011Q4_bak_20140109 from dbo.HKAPI_2011Q4

	--dbo.HKAPI_2011Q4STLY
	if object_id(N'dbo.HKAPI_2011Q4STLY_bak_20140109',N'U') is  null
		--drop table HKAPI_2011Q4STLY_bak_20140109
	select * into HKAPI_2011Q4STLY_bak_20140109 from dbo.HKAPI_2011Q4STLY

	--dbo.HKAPI_2012Q1
	if object_id(N'dbo.HKAPI_2012Q1_bak_20140109',N'U') is  null
		--drop table HKAPI_2012Q1_bak_20140109
	select * into HKAPI_2012Q1_bak_20140109 from dbo.HKAPI_2012Q1

	--dbo.HKAPI_2012Q1STLY
	if object_id(N'dbo.HKAPI_2012Q1STLY_bak_20140109',N'U') is null
		--drop table HKAPI_2012Q1STLY_bak_20140109
	select * into HKAPI_2012Q1STLY_bak_20140109 from dbo.HKAPI_2012Q1STLY

	--dbo.HKAPI_2012Q2
	if object_id(N'dbo.HKAPI_2012Q2_bak_20140109',N'U') is null
		--drop table HKAPI_2012Q2_bak_20140109
	select * into HKAPI_2012Q2_bak_20140109 from dbo.HKAPI_2012Q2

	--dbo.HKAPI_2012Q2STLY
	if object_id(N'dbo.HKAPI_2012Q2STLY_bak_20140109',N'U') is null
		--drop table HKAPI_2012Q2STLY_bak_20140109
	select * into HKAPI_2012Q2STLY_bak_20140109 from dbo.HKAPI_2012Q2STLY

	--dbo.HKAPI_2012Q3
	if object_id(N'dbo.HKAPI_2012Q3_bak_20140109',N'U') is null
		--drop table HKAPI_2012Q3_bak_20140109
	select * into HKAPI_2012Q3_bak_20140109 from dbo.HKAPI_2012Q3

	--dbo.HKAPI_2012Q3STLY
	if object_id(N'dbo.HKAPI_2012Q3STLY_bak_20140109',N'U') is null
		--drop table HKAPI_2012Q3STLY_bak_20140109
	select * into HKAPI_2012Q3STLY_bak_20140109 from dbo.HKAPI_2012Q3STLY

	--dbo.HKAPI_2012Q4
	if object_id(N'dbo.HKAPI_2012Q4_bak_20140109',N'U') is null
		--drop table HKAPI_2012Q4_bak_20140109
	select * into HKAPI_2012Q4_bak_20140109 from dbo.HKAPI_2012Q4

	--dbo.HKAPI_2012Q4STLY
	if object_id(N'dbo.HKAPI_2012Q4STLY_bak_20140109',N'U') is null
		--drop table HKAPI_2012Q4STLY_bak_20140109
	select * into HKAPI_2012Q4STLY_bak_20140109 from dbo.HKAPI_2012Q4STLY

	--dbo.HKAPI_2013Q1
	if object_id(N'dbo.HKAPI_2013Q1_bak_20140109',N'U') is null
		--drop table HKAPI_2013Q1_bak_20140109
	select * into HKAPI_2013Q1_bak_20140109 from dbo.HKAPI_2013Q1

	--dbo.HKAPI_2013Q1STLY
	if object_id(N'dbo.HKAPI_2013Q1STLY_bak_20140109',N'U') is null
		--drop table HKAPI_2013Q1STLY_bak_20140109
	select * into HKAPI_2013Q1STLY_bak_20140109 from dbo.HKAPI_2013Q1STLY

	--dbo.HKAPI_2013Q2
	if object_id(N'dbo.HKAPI_2013Q2_bak_20140109',N'U') is null
		--drop table HKAPI_2013Q2_bak_20140109
	select * into HKAPI_2013Q2_bak_20140109 from dbo.HKAPI_2013Q2

	--dbo.HKAPI_2013Q2STLY
	if object_id(N'dbo.HKAPI_2013Q2STLY_bak_20140109',N'U') is null
		--drop table HKAPI_2013Q2STLY_bak_20140109
	select * into HKAPI_2013Q2STLY_bak_20140109 from dbo.HKAPI_2013Q2STLY

	--dbo.HKAPI_2013Q3
	if object_id(N'dbo.HKAPI_2013Q3_bak_20140109',N'U') is null
		--drop table HKAPI_2013Q3_bak_20140109
	select * into HKAPI_2013Q3_bak_20140109 from dbo.HKAPI_2013Q3

	--dbo.HKAPI_2013Q3STLY
	if object_id(N'dbo.HKAPI_2013Q3STLY_bak_20140109',N'U') is null
		--drop table HKAPI_2013Q3STLY_bak_20140109
	select * into HKAPI_2013Q3STLY_bak_20140109 from dbo.HKAPI_2013Q3STLY

--Update RawData

	--dbo.[HKAPI_2010Q4]
		update [HKAPI_2010Q4]
		set [Company Name]='BHC'
		where [Company Name]='BSP'
	
		update [HKAPI_2010Q4]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2010Q4]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2010Q4]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2010Q4]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')
		
	--dbo.[HKAPI_2011H1]
		update HKAPI_2011H1
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2011H1]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2011H1]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2011H1]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2011H1]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


	--dbo.[HKAPI_2011H1STLY]
		update HKAPI_2011H1STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2011H1STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2011H1STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2011H1STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2011H1STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


	--dbo.[HKAPI_2011Q1]
		update HKAPI_2011Q1
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2011Q1]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2011Q1]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2011Q1]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2011Q1]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2011Q1STLY]
		update HKAPI_2011Q1STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2011Q1STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2011Q1STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2011Q1STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2011Q1STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2011Q3]
		update HKAPI_2011Q3
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2011Q3]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2011Q3]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2011Q3]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2011Q3]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


	--dbo.[HKAPI_2011Q3STLY]
		update HKAPI_2011Q3STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2011Q3STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2011Q3STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2011Q3STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2011Q3STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2011Q4]
		update HKAPI_2011Q4
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2011Q4]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2011Q4]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2011Q4]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2011Q4]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2011Q4STLY]
		update HKAPI_2011Q4STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2011Q4STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2011Q4STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2011Q4STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2011Q4STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2012Q1]
		update HKAPI_2012Q1
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2012Q1]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2012Q1]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2012Q1]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2012Q1]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2012Q1STLY]
		update HKAPI_2012Q1STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2012Q1STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2012Q1STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2012Q1STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2012Q1STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2012Q2]
		update HKAPI_2012Q2
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2012Q2]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2012Q2]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2012Q2]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2012Q2]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2012Q2STLY]
		update HKAPI_2012Q2STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2012Q2STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2012Q2STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2012Q2STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2012Q2STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2012Q3]
		update HKAPI_2012Q3
		set [Company Name]='BHC'
		where [Company Name]='BSP'
	
		update [HKAPI_2012Q3]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2012Q3]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2012Q3]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2012Q3]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2012Q3STLY]
		update HKAPI_2012Q3STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2012Q3STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2012Q3STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2012Q3STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2012Q3STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2012Q4]
		update HKAPI_2012Q4
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2012Q4]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2012Q4]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2012Q4]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2012Q4]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

		
		
	--dbo.[HKAPI_2012Q4STLY]
		update HKAPI_2012Q4STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
	
		update [HKAPI_2012Q4STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2012Q4STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2012Q4STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2012Q4STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


	--dbo.[HKAPI_2013Q1]
		update HKAPI_2013Q1
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2013Q1]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2013Q1]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2013Q1]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2013Q1]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


	--dbo.[HKAPI_2013Q1STLY]
		update HKAPI_2013Q1STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2013Q1STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2013Q1STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2013Q1STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2013Q1STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2013Q2]
		update HKAPI_2013Q2
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2013Q2]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2013Q2]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2013Q2]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2013Q2]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2013Q2STLY]
		update HKAPI_2013Q2STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2013Q2STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2013Q2STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2013Q2STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2013Q2STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


	--dbo.[HKAPI_2013Q3]
		update HKAPI_2013Q3
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2013Q3]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2013Q3]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2013Q3]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2013Q3]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


	--dbo.[HKAPI_2013Q3STLY]
		update HKAPI_2013Q3STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2013Q3STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2013Q3STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2013Q3STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2013Q3STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2013Q4]
		update HKAPI_2013Q4
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2013Q4]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2013Q4]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2013Q4]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2013Q4]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


	--dbo.[HKAPI_2013Q4STLY]
		update HKAPI_2013Q4STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2013Q4STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2013Q4STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2013Q4STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2013Q4STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


--Update special product name
	--2013Q3's rawdata
		update HKAPI_2013Q3
		set [product name] = 'ALBOTHYL OVULES'
		where [product name] like 'albothyl ovules%'

		update HKAPI_2013Q3STLY
		set [product name] = 'ALBOTHYL OVULES'
		where [product name] like 'albothyl ovules%'


********************************************************************/





----check data
--select * from dbo.HKAPI_2011H1 A inner join dbo.HKAPI_2011Q3 B
--on  a.[Company Name]=b.[Company Name] and a.[Product Name]=B.[Product Name]
--and a.[Therapeutic Class]=B.[Therapeutic Class]

--select * from dbo.HKAPI_2011H1 A where not exists(select * from dbo.HKAPI_2011Q3 B
--where  a.[Company Name]=b.[Company Name] and a.[Product Name]=B.[Product Name]
--and a.[Therapeutic Class]=B.[Therapeutic Class])
--select * from dbo.HKAPI_2011Q3 A where not exists(select * from dbo.HKAPI_2011H1  B
--where  a.[Company Name]=b.[Company Name] and a.[Product Name]=B.[Product Name]
--and a.[Therapeutic Class]=B.[Therapeutic Class])
--go
----Create table inHKAPI_Linda



select [Company Name],[Company Name],[Product Name],ta,count(*) from [HKAPI_2010Q4]
group by [Company Name],[Product Name],TA
having count(*)>1

select [Company Name],[Company Name],[Product Name],count(*) from [HKAPI_2011Q1]
group by [Company Name],[Company Name],[Product Name]
having count(*)>1

select [Company Name],[Company Name],[Product Name],count(*) from [HKAPI_2011H1]
group by [Company Name],[Company Name],[Product Name]
having count(*)>1

select [Company Name],[Company Name],[Product Name],count(*) from [HKAPI_2011Q3]
group by [Company Name],[Company Name],[Product Name]
having count(*)>1

select [Company Name],[Company Name],[Product Name],count(*) from [HKAPI_2011Q4]
group by [Company Name],[Company Name],[Product Name]
having count(*)>1

select [Company Name],[Product Name],count(*) from [HKAPI_2012Q1]
group by [Company Name],[Product Name]
having count(*)>1

select [Company Name],[Product Name],count(*) from [HKAPI_2012Q2]
group by [Company Name],[Product Name]
having count(*)>1
go
select [Company Name],[Product Name],count(*) from [HKAPI_2012Q3]
group by [Company Name],[Product Name]
having count(*)>1
go
select [Company Name],[Product Name],count(*) from [HKAPI_2012Q4]
group by [Company Name],[Product Name]
having count(*)>1
go
select [Company Name],[Product Name],count(*) from [HKAPI_2013Q1]
group by [Company Name],[Product Name]
having count(*)>1
go
select [Company Name],[Product Name],count(*) from [HKAPI_2013Q2]
group by [Company Name],[Product Name]
having count(*)>1
go
select [Company Name],[Product Name],count(*) from [HKAPI_2013Q3]
group by [Company Name],[Product Name]
having count(*)>1
go
select [Company Name],[Product Name],count(*) from [HKAPI_2013Q4]
group by [Company Name],[Product Name]
having count(*)>1
go


update HKAPI_2012Q1
set [Product name]='SPRYCEL' where [Product Name]='SPYCEL'
go 
--select * into [HKAPI_2010Q4_bak_20140109] from [HKAPI_2010Q4]
--update [HKAPI_2010Q4]
--set [Company Name]='BHC'
--where [Company Name]='BSP'

--update [HKAPI_2010Q4]
--set [Product Name]='FLUDARA(BHC)'
--where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

--update [HKAPI_2010Q4]
--set [Product Name]='BAYASPIRIN'
--where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

--update [HKAPI_2010Q4]
--set [Product Name]='NIMOTOP'
--where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

--update [HKAPI_2010Q4]
--set [Product Name]='NT30MG 20''S'
--where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


drop table [tempHKAPI_2010Q4]
go
select [Company Name],[Product Name],sum(isnull([06Q1],0)) as [06Q1]
      ,sum(isnull([06Q2],0)) as [06Q2]
      ,sum(isnull([06Q3],0)) as [06Q3]
      ,sum(isnull([06Q4],0)) as [06Q4]
      ,sum(isnull([07Q1],0)) as [07Q1]
      ,sum(isnull([07Q2],0)) as [07Q2]
      ,sum(isnull([07Q3],0)) as [07Q3]
      ,sum(isnull([07Q4],0)) as [07Q4]
      ,sum(isnull([08Q1],0)) as [08Q1]
      ,sum(isnull([08Q2],0)) as [08Q2]
      ,sum(isnull([08Q3],0)) as [08Q3]
      ,sum(isnull([08Q4],0)) as [08Q4]
      ,sum(isnull([09Q1],0)) as [09Q1]
      ,sum(isnull([09Q2],0)) as [09Q2]
      ,sum(isnull([09Q3],0)) as [09Q3]
      ,sum(isnull([09Q4],0)) as [09Q4]
      ,sum(isnull([2010Q1],0)) as [2010Q1]
      ,sum(isnull([2010Q2],0)) as [2010Q2]
      ,sum(isnull([2010Q3],0)) as [2010Q3]
      ,sum(isnull([2010Q4],0)) as [2010Q4]
     ,sum(isnull([QTR 06Q1],0)) as [QTR 06Q1]
	 ,sum(isnull([YTD 06Q2],0)) as [YTD 06Q2]
	 ,sum(isnull([YTD 06Q3],0)) as [YTD 06Q3]
	 ,sum(isnull([YTD 06Q4],0)) as [YTD 06Q4]
	 ,sum(isnull([QTR 07Q1],0)) as [QTR 07Q1]
	 ,sum(isnull([YTD 07Q2],0)) as [YTD 07Q2]
	 ,sum(isnull([YTD 07Q3],0)) as [YTD 07Q3]
	 ,sum(isnull([YTD 07Q4],0)) as [YTD 07Q4]
	 ,sum(isnull([QTR 08Q1],0)) as [QTR 08Q1]
	 ,sum(isnull([YTD 08Q2],0)) as [YTD 08Q2]
	 ,sum(isnull([YTD 08Q3],0)) as [YTD 08Q3]
	 ,sum(isnull([YTD 08Q4],0)) as [YTD 08Q4]
	 ,sum(isnull([QTR 09Q1],0)) as [QTR 09Q1]
	 ,sum(isnull([YTD09Q2],0)) as [YTD 09Q2]
	 ,sum(isnull([YTD09Q3],0)) as [YTD 09Q3]
	 ,sum(isnull([YTD 09Q4],0)) as [YTD 09Q4]
	 ,sum(isnull([YTD 2010Q1],0)) as [YTD 2010Q1]
	 ,sum(isnull([YTD 2010Q2],0)) as [YTD 2010Q2]
	 ,sum(isnull([YTD 2010Q3],0)) as [YTD 2010Q3]
	 ,sum(isnull([YTD 2010Q4],0)) as [YTD 2010Q4]
 into [tempHKAPI_2010Q4] from ( select distinct * from [HKAPI_2010Q4]) a
group by [Company Name],[Product Name]
go
go

if exists (select * from dbo.sysobjects where id = object_id(N'inHKAPI_Linda') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table inHKAPI_Linda
go
select isnull(isnull(isnull(isnull(A.[Company Name],B.[Company Name]),C.[Company Name]),D.[Company Name]),E.[Company Name]) AS [Company Name]
      ,isnull(isnull(isnull(isnull(A.[Product Name],B.[Product Name]),C.[Product Name]),D.[Product Name]),E.[Product Name]) [Product Name]
      --,[TA]
--      ,[KEY PRODUCT]
--      ,isnull(isnull(CAST(A.[New Product] AS VARCHAR(20)),B.[New Product]),C.[New Product]) [New Product]
--      ,isnull(isnull(CAST(A.[When the new _product launched]AS VARCHAR(20)),B.[When the new _product launched]),C.[When the new _product launched]) [When the new _product launched]
      --,isnull(isnull(isnull(isnull(CAST(A.[Therapeutic Class] AS VARCHAR(20)),B.[Therapeutic Class]),C.[Therapeutic Class]),D.[Therapeutic Class]),E.[Therapeutic Class]) [Therapeutic Class]
into dbo.inHKAPI_Linda
FROM [dbo].[tempHKAPI_2010Q4] A full join dbo.HKAPI_2011Q1 B
on a.[Company Name]=b.[Company Name] and a.[Product Name]=B.[Product Name]
--and a.[Therapeutic Class]=B.[Therapeutic Class]
full join dbo.HKAPI_2011H1 C
on a.[Company Name]=C.[Company Name] and a.[Product Name]=C.[Product Name]
--and a.[Therapeutic Class]=C.[Therapeutic Class]
full join dbo.HKAPI_2011Q3 D
on a.[Company Name]=D.[Company Name] and a.[Product Name]=D.[Product Name]
--and a.[Therapeutic Class]=D.[Therapeutic Class]
full join dbo.HKAPI_2011Q4 E
on a.[Company Name]=E.[Company Name] and a.[Product Name]=E.[Product Name]
--and a.[Therapeutic Class]=E.[Therapeutic Class]
GROUP BY ISNULL(isnull(isnull(isnull(A.[Company Name],B.[Company Name]),C.[Company Name]),D.[Company Name]),E.[Company Name])
      ,isnull(isnull(isnull(isnull(A.[Product Name],B.[Product Name]),C.[Product Name]),D.[Product Name]),E.[Product Name])
      --,[TA]
--      ,[KEY PRODUCT]
--      ,isnull(isnull(CAST(A.[New Product] AS VARCHAR(20)),B.[New Product]),C.[New Product])
----      ,isnull(isnull(CAST(A.[When the new _product launched]AS VARCHAR(20)),B.[When the new _product launched]),C.[When the new _product launched])
--      ,isnull(isnull(isnull(isnull(CAST(A.[Therapeutic Class] AS VARCHAR(20)),B.[Therapeutic Class]),C.[Therapeutic Class]),D.[Therapeutic Class]),E.[Therapeutic Class])
go

declare cursor_HKAPI_Quarter cursor for 
select quarter from BMSChinaOtherDB.dbo.hkapi_Time_Config where Quarter<>'2010Q4'
declare @Quarter varchar(10)
declare @sql varchar(max)
open cursor_HKAPI_Quarter
FETCH NEXT FROM cursor_HKAPI_Quarter INTO @Quarter 
WHILE @@FETCH_STATUS=0
BEGIN
	set @sql=' '
	set @sql='
	if exists(	select * 
				from dbo.HKAPI_'+@Quarter+'STLY A 
				where not exists(	select * from 
									inHKAPI_Linda B
									where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
								)
			)

	insert into inHKAPI_Linda ([Company Name],[Product Name])
	select distinct [Company Name]
		  ,[Product Name]
	from dbo.HKAPI_'+@Quarter+'STLY A 
	where not exists(
					select * from inHKAPI_Linda B
					where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
	)'
	print @sql
	exec(@sql)
	
	set @sql='
	if exists(	select * 
				from dbo.HKAPI_'+@Quarter+' A 
				where not exists(	select * from 
									inHKAPI_Linda B
									where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
								)
			)

	insert into inHKAPI_Linda ([Company Name],[Product Name])
	select distinct [Company Name]
		  ,[Product Name]
	from dbo.HKAPI_'+@Quarter+' A 
	where not exists(
					select * from inHKAPI_Linda B
					where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
	)'
	print @sql
	exec(@sql)
	FETCH NEXT FROM cursor_HKAPI_Quarter INTO @Quarter 
END
close cursor_HKAPI_Quarter
deallocate cursor_HKAPI_Quarter

GO




----Q4
--if exists(
--select * from dbo.HKAPI_2011Q4STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2011Q4STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go
----Q3
--if exists(
--select * from dbo.HKAPI_2011Q3STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2011Q3STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go
----H1
--if exists(
--select * from dbo.HKAPI_2011H1STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2011H1STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go
----Q1
--if exists(
--select * from dbo.HKAPI_2011Q1STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2011Q1STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go


----2012Q1 STLY
--if exists(
--select * from dbo.HKAPI_2012Q1STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2012Q1STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go
----2012Q1
--if exists(
--select * from dbo.HKAPI_2012Q1 A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2012Q1 A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go

----2012Q2 STLY
--if exists(
--select * from dbo.HKAPI_2012Q2STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2012Q2STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go
----2012Q2
--if exists(
--select * from dbo.HKAPI_2012Q2 A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2012Q2 A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go


----2012Q3 STLY
--if exists(
--select * from dbo.HKAPI_2012Q3STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2012Q3STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go
----2012Q3
--if exists(
--select * from dbo.HKAPI_2012Q3 A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2012Q3 A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go


----2012Q4 STLY
--if exists(
--select * from dbo.HKAPI_2012Q4STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2012Q4STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go
----2012Q4
--if exists(
--select * from dbo.HKAPI_2012Q4 A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2012Q4 A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go




----2013Q1 STLY
--if exists(
--select * from dbo.HKAPI_2013Q1STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2013Q1STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go
----2013Q1
--if exists(
--select * from dbo.HKAPI_2013Q1 A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2013Q1 A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go


----2013Q2 STLY
--if exists(
--select * from dbo.HKAPI_2013Q2STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2013Q2STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go
----2013Q2
--if exists(
--select * from dbo.HKAPI_2013Q2 A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2013Q2 A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go


----2013Q3 STLY
--if exists(
--select * from dbo.HKAPI_2013Q3STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2013Q3STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go
----2013Q3
--if exists(
--select * from dbo.HKAPI_2013Q3 A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2013Q3 A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--go

----2013Q4 STLY
--if exists(
--select * from dbo.HKAPI_2013Q4STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2013Q4STLY A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)
--GO
----2013Q4
--if exists(
--select * from dbo.HKAPI_2013Q4 A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--))

--insert into inHKAPI_Linda ([Company Name]
--      ,[Product Name]
--      )
--select distinct [Company Name]
--      ,[Product Name]
--       from dbo.HKAPI_2013Q4 A where not exists(
--select * from inHKAPI_Linda B
--where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
--)







 Alter table inHKAPI_Linda
Add [06Q1LC] [float] NULL default 0,
	[06Q2LC] [float] NULL default 0,
	[06Q3LC] [float] NULL default 0,
	[06Q4LC] [float] NULL default 0,
	[07Q1LC] [float] NULL default 0,
	[07Q2LC] [float] NULL default 0,
	[07Q3LC] [float] NULL default 0,
	[07Q4LC] [float] NULL default 0,
	[08Q1LC] [float] NULL default 0,
	[08Q2LC] [float] NULL default 0,
	[08Q3LC] [float] NULL default 0,
	[08Q4LC] [float] NULL default 0,
	[09Q1LC] [float] NULL default 0,
	[09Q2LC] [float] NULL default 0,
	[09Q3LC] [float] NULL default 0,
	[09Q4LC] [float] NULL default 0,
	[10Q1LC] [float] NULL default 0,
	[10Q2LC] [float] NULL default 0,
	[10Q3LC] [float] NULL default 0,
	[10Q4LC] [float] NULL default 0,
	[11Q1LC] [float] NULL default 0,
	[11Q2LC] [float] NULL default 0,
	[11Q3LC] [float] NULL default 0,
	[11Q4LC] [float] NULL default 0,
	[12Q1LC] [float] NULL default 0,
	[12Q2LC] [float] NULL default 0,
	[12Q3LC] [float] NULL default 0,
	[12Q4LC] [float] NULL default 0,
	[13Q1LC] [float] NULL default 0,
	[13Q2LC] [float] NULL default 0,
	[13Q3LC] [float] NULL default 0,
	[13Q4LC] [float] NULL default 0,
	[14Q1LC] [float] NULL default 0,
	[14Q2LC] [float] NULL default 0,
	[14Q3LC] [float] NULL default 0,
	[14Q4LC] [float] NULL default 0,
	[15Q1LC] [float] NULL default 0,
	[15Q2LC] [float] NULL default 0,
	[15Q3LC] [float] NULL default 0,
	[15Q4LC] [float] NULL default 0,
	[16Q1LC] [float] NULL default 0,--todo	
	[YTD 06Q1LC] [float] NULL default 0,
	[YTD 06Q2LC] [float] NULL default 0,
	[YTD 06Q3LC] [float] NULL default 0,
	[YTD 06Q4LC] [float] NULL default 0,
	[YTD 07Q1LC] [float] NULL default 0,
	[YTD 07Q2LC] [float] NULL default 0,
	[YTD 07Q3LC] [float] NULL default 0,
	[YTD 07Q4LC] [float] NULL default 0,
	[YTD 08Q1LC] [float] NULL default 0,
	[YTD 08Q2LC] [float] NULL default 0,
	[YTD 08Q3LC] [float] NULL default 0,
	[YTD 08Q4LC] [float] NULL default 0,
	[YTD 09Q1LC] [float] NULL default 0,
	[YTD 09Q2LC] [float] NULL default 0,
	[YTD 09Q3LC] [float] NULL default 0,
	[YTD 09Q4LC] [float] NULL default 0,
	[YTD 10Q1LC] [float] NULL default 0,
	[YTD 10Q2LC] [float] NULL default 0,
	[YTD 10Q3LC] [float] NULL default 0,
	[YTD 10Q4LC] [float] NULL default 0,
	[YTD 11Q1LC] [float] NULL default 0,
	[YTD 11Q2LC] [float] NULL default 0,
	[YTD 11Q3LC] [float] NULL default 0,
	[YTD 11Q4LC] [float] NULL default 0,
	[YTD 12Q1LC] [float] NULL default 0,
	[YTD 12Q2LC] [float] NULL default 0,
	[YTD 12Q3LC] [float] NULL default 0,
	[YTD 12Q4LC] [float] NULL default 0,
	[YTD 13Q1LC] [float] NULL default 0,
	[YTD 13Q2LC] [float] NULL default 0,
	[YTD 13Q3LC] [float] NULL default 0,
	[YTD 13Q4LC] [float] NULL default 0,
	[YTD 14Q1LC] [float] NULL default 0,
	[YTD 14Q2LC] [float] NULL default 0,
	[YTD 14Q3LC] [float] NULL default 0,
	[YTD 14Q4LC] [float] NULL default 0,
	[YTD 15Q1LC] [float] NULL default 0,
	[YTD 15Q2LC] [float] NULL default 0,
	[YTD 15Q3LC] [float] NULL default 0,
	[YTD 15Q4LC] [float] NULL default 0,
	[YTD 16Q1LC] [float] NULL default 0--todo	
go
update inHKAPI_Linda
set 
[06Q1LC] = 0,
	[06Q2LC] = 0,
	[06Q3LC] = 0,
	[06Q4LC] = 0,
	[07Q1LC] = 0,
	[07Q2LC] = 0,
	[07Q3LC] = 0,
	[07Q4LC] = 0,
	[08Q1LC] = 0,
	[08Q2LC] = 0,
	[08Q3LC] = 0,
	[08Q4LC] = 0,
	[09Q1LC] = 0,
	[09Q2LC] = 0,
	[09Q3LC] = 0,
	[09Q4LC] = 0,
	[10Q1LC] = 0,
	[10Q2LC] = 0,
	[10Q3LC] = 0,
	[10Q4LC] = 0,
	[11Q1LC] = 0,
	[11Q2LC] = 0,
	[11Q3LC] = 0,
	[11Q4LC] = 0,
	[12Q1LC] = 0,
	[12Q2LC] = 0,
	[12Q3LC] = 0,
	[12Q4LC] = 0,
	[13Q1LC] = 0,
	[13Q2LC] = 0,
	[13Q3LC] = 0,
	[13Q4LC] = 0,
	[14Q1LC] = 0,
	[14Q2LC] = 0,
	[14Q3LC] = 0,
	[14Q4LC] = 0,
	[15Q1LC] = 0,
	[15Q2LC] = 0,
	[15Q3LC] = 0,
	[15Q4LC] = 0,
	[16Q1LC] = 0,--todo	
	[YTD 06Q1LC] = 0,
	[YTD 06Q2LC] = 0,
	[YTD 06Q3LC] = 0,
	[YTD 06Q4LC] = 0,
	[YTD 07Q1LC] = 0,
	[YTD 07Q2LC] = 0,
	[YTD 07Q3LC] = 0,
	[YTD 07Q4LC] = 0,
	[YTD 08Q1LC] = 0,
	[YTD 08Q2LC] = 0,
	[YTD 08Q3LC] = 0,
	[YTD 08Q4LC] = 0,
	[YTD 09Q1LC] = 0,
	[YTD 09Q2LC] = 0,
	[YTD 09Q3LC] = 0,
	[YTD 09Q4LC] = 0,
	[YTD 10Q1LC] = 0,
	[YTD 10Q2LC] = 0,
	[YTD 10Q3LC] = 0,
	[YTD 10Q4LC] = 0,
	[YTD 11Q1LC] = 0,
	[YTD 11Q2LC] = 0,
	[YTD 11Q3LC] = 0,
	[YTD 11Q4LC] = 0,
	[YTD 12Q1LC] = 0,
	[YTD 12Q2LC] = 0,
	[YTD 12Q3LC] = 0,
	[YTD 12Q4LC] = 0,
	[YTD 13Q1LC] = 0,
	[YTD 13Q2LC] = 0,
	[YTD 13Q3LC] = 0,
	[YTD 13Q4LC] = 0,
	[YTD 14Q1LC] = 0,
	[YTD 14Q2LC] = 0,
	[YTD 14Q3LC] = 0,
	[YTD 14Q4LC] = 0,
	[YTD 15Q1LC] = 0,
	[YTD 15Q2LC] = 0,
	[YTD 15Q3LC] = 0,
	[YTD 15Q4LC] = 0,
	[YTD 16Q1LC] = 0	--todo	
go

update inHKAPI_Linda
set [06Q1LC]=B.[06Q1],
	[06Q2LC]=B.[06Q2],
	[06Q3LC]=B.[06Q3],
	[06Q4LC]=B.[06Q4],
	[07Q1LC]=B.[07Q1],
	[07Q2LC]=B.[07Q2],
	[07Q3LC]=B.[07Q3],
	[07Q4LC]=B.[07Q4],
	[08Q1LC]=B.[08Q1],
	[08Q2LC]=B.[08Q2],
	[08Q3LC]=B.[08Q3],
	[08Q4LC]=B.[08Q4],
	[09Q1LC]=B.[09Q1],
	[09Q2LC]=B.[09Q2],
	[09Q3LC]=B.[09Q3],
	[09Q4LC]=B.[09Q4],
	[YTD 06Q1LC]=B.[QTR 06Q1],
	[YTD 06Q2LC]=B.[YTD 06Q2],
	[YTD 06Q3LC]=B.[YTD 06Q3],
	[YTD 06Q4LC]=B.[YTD 06Q4],
	[YTD 07Q1LC]=B.[QTR 07Q1],
	[YTD 07Q2LC]=B.[YTD 07Q2],
	[YTD 07Q3LC]=B.[YTD 07Q3],
	[YTD 07Q4LC]=B.[YTD 07Q4],
	[YTD 08Q1LC]=B.[QTR 08Q1],
	[YTD 08Q2LC]=B.[YTD 08Q2],
	[YTD 08Q3LC]=B.[YTD 08Q3],
	[YTD 08Q4LC]=B.[YTD 08Q4],
	[YTD 09Q1LC]=B.[QTR 09Q1],
	[YTD 09Q2LC]=B.[YTD 09Q2],
	[YTD 09Q3LC]=B.[YTD 09Q3],
	[YTD 09Q4LC]=B.[YTD 09Q4]
from inHKAPI_Linda A inner join [tempHKAPI_2010Q4] B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]



go
update inHKAPI_Linda
set [YTD 10Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2011Q1STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]


go
update inHKAPI_Linda
set [YTD 11Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2011Q1 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]


go
update inHKAPI_Linda
set [YTD 10Q2LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2011H1STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]


go
update inHKAPI_Linda
set [YTD 11Q2LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2011H1 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]


go
update inHKAPI_Linda
set [YTD 10Q3LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2011Q3STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]


go
update inHKAPI_Linda
set [YTD 11Q3LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2011Q3 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]


go
update inHKAPI_Linda
set [YTD 10Q4LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2011Q4STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]


go
update inHKAPI_Linda
set [YTD 11Q4LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2011Q4 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]





go
update inHKAPI_Linda
set [YTD 11Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2012Q1STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]


go
update inHKAPI_Linda
set [YTD 12Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2012Q1 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]


go
update inHKAPI_Linda
set [YTD 11Q2LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2012Q2STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go
update inHKAPI_Linda
set [YTD 12Q2LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2012Q2 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]



go
update inHKAPI_Linda
set [YTD 11Q3LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2012Q3STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go
update inHKAPI_Linda
set [YTD 12Q3LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2012Q3 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]


--2012Q4
update inHKAPI_Linda
set [YTD 11Q4LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2012Q4STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go
update inHKAPI_Linda
set [YTD 12Q4LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2012Q4 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go


--2013Q1
update inHKAPI_Linda
set [YTD 12Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2013Q1STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go
update inHKAPI_Linda
set [YTD 13Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2013Q1 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go

--2013Q2
update inHKAPI_Linda
set [YTD 12Q2LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2013Q2STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go
update inHKAPI_Linda
set [YTD 13Q2LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2013Q2 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go

--2013Q3
update inHKAPI_Linda
set [YTD 12Q3LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2013Q3STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go
update inHKAPI_Linda
set [YTD 13Q3LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2013Q3 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go

--2013Q4
update inHKAPI_Linda
set [YTD 12Q4LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2013Q4STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go
update inHKAPI_Linda
set [YTD 13Q4LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2013Q4 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go


--2014Q1
update inHKAPI_Linda
set [YTD 13Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2014Q1STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go
update inHKAPI_Linda
set [YTD 14Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2014Q1 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go

--2014Q2
update inHKAPI_Linda
set [YTD 13Q2LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2014Q2STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go
update inHKAPI_Linda
set [YTD 14Q2LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2014Q2 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
go

--2014Q3
update inHKAPI_Linda
set [YTD 13Q3LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2014Q3STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go
update inHKAPI_Linda
set [YTD 14Q3LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2014Q3 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
go

--2014Q4
update inHKAPI_Linda
set [YTD 13Q4LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2014Q4STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go
update inHKAPI_Linda
set [YTD 14Q4LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2014Q4 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]


--2015Q1
update inHKAPI_Linda
set [YTD 14Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2015Q1STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go
update inHKAPI_Linda
set [YTD 15Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2015Q1 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go

--2015Q2
update inHKAPI_Linda
set [YTD 14Q2LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2015Q2STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go
update inHKAPI_Linda
set [YTD 15Q2LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2015Q2 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
go

--2015Q3
update inHKAPI_Linda
set [YTD 14Q3LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2015Q3STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go
update inHKAPI_Linda
set [YTD 15Q3LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2015Q3 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
go

--2015Q4
update inHKAPI_Linda
set [YTD 14Q4LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2015Q4STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go
update inHKAPI_Linda
set [YTD 15Q4LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2015Q4 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
go

--2016Q1
update inHKAPI_Linda
set [YTD 15Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2016Q1STLY group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

go
update inHKAPI_Linda
set [YTD 16Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2016Q1 group by [Company Name]
      ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
go
--todo: Update use new quarterly data

update inHKAPI_Linda set 
	[10Q1LC]= [YTD 10Q1LC],
	[10Q2LC]= [YTD 10Q2LC]- [YTD 10Q1LC],
	[10Q3LC]= [YTD 10Q3LC]- [YTD 10Q2LC],
	[10Q4LC]= [YTD 10Q4LC]- [YTD 10Q3LC],
	[11Q1LC]= [YTD 11Q1LC],
	[11Q2LC]= [YTD 11Q2LC]- [YTD 11Q1LC],
	[11Q3LC]= [YTD 11Q3LC]- [YTD 11Q2LC],
	[11Q4LC]= [YTD 11Q4LC]- [YTD 11Q3LC],
	[12Q1LC]= [YTD 12Q1LC],
	[12Q2LC]= [YTD 12Q2LC]- [YTD 12Q1LC],
	[12Q3LC]= [YTD 12Q3LC]- [YTD 12Q2LC],
	[12Q4LC]= [YTD 12Q4LC]- [YTD 12Q3LC],
	[13Q1LC]= [YTD 13Q1LC],
	[13Q2LC]= [YTD 13Q2LC]- [YTD 13Q1LC],
	[13Q3LC]= [YTD 13Q3LC]- [YTD 13Q2LC],
	[13Q4LC]= [YTD 13Q4LC]- [YTD 13Q3LC],
	[14Q1LC]= [YTD 14Q1LC],
	[14Q2LC]= [YTD 14Q2LC]- [YTD 14Q1LC],
	[14Q3LC]= [YTD 14Q3LC]- [YTD 14Q2LC],
	[14Q4LC]= [YTD 14Q4LC]- [YTD 14Q3LC],
	[15Q1LC]= [YTD 15Q1LC],
	[15Q2LC]= [YTD 15Q2LC]- [YTD 15Q1LC],
	[15Q3LC]= [YTD 15Q3LC]- [YTD 15Q2LC],
	[15Q4LC]= [YTD 15Q4LC]- [YTD 15Q3LC],
	[16Q1LC]= [YTD 16Q1LC]
	--todo
go
Alter table inHKAPI_Linda
add [06Q1US] float null default 0
      ,[06Q2US] float null default 0
      ,[06Q3US] float null default 0
      ,[06Q4US] float null default 0
      ,[07Q1US] float null default 0
      ,[07Q2US] float null default 0
      ,[07Q3US] float null default 0
      ,[07Q4US] float null default 0
      ,[08Q1US] float null default 0
      ,[08Q2US] float null default 0
      ,[08Q3US] float null default 0
      ,[08Q4US] float null default 0
      ,[09Q1US] float null default 0
      ,[09Q2US] float null default 0
      ,[09Q3US] float null default 0
      ,[09Q4US] float null default 0
      ,[10Q1US] float null default 0
      ,[10Q2US] float null default 0
      ,[10Q3US] float null default 0
      ,[10Q4US] float null default 0
      ,[11Q1US] float null default 0
      ,[11Q2US] float null default 0
      ,[11Q3US] float null default 0
      ,[11Q4US] float null default 0
      ,[12Q1US] float null default 0
      ,[12Q2US] float null default 0
      ,[12Q3US] float null default 0
      ,[12Q4US] float null default 0
	  ,[13Q1US] float null default 0
	  ,[13Q2US] float null default 0
	  ,[13Q3US] float null default 0
	  ,[13Q4US] float null default 0
	  ,[14Q1US] float null default 0
	  ,[14Q2US] float null default 0
	  ,[14Q3US] float null default 0
	  ,[14Q4US] float null default 0
	  ,[15Q1US] float null default 0
	  ,[15Q2US] float null default 0
	  ,[15Q3US] float null default 0
	  ,[15Q4US] float null default 0	
	  ,[16Q1US] float null default 0	  
	  --todo
go
update inHKAPI_Linda
set [06Q1US]=A.[06Q1LC]/B.Rate
      ,[06Q2US]=A.[06Q2LC]/B.Rate
      ,[06Q3US]=A.[06Q3LC]/B.Rate
      ,[06Q4US]=A.[06Q4LC]/B.Rate
      ,[07Q1US]=A.[07Q1LC]/B.Rate
      ,[07Q2US]=A.[07Q2LC]/B.Rate
      ,[07Q3US]=A.[07Q3LC]/B.Rate
      ,[07Q4US]=A.[07Q4LC]/B.Rate
      ,[08Q1US]=A.[08Q1LC]/B.Rate
      ,[08Q2US]=A.[08Q2LC]/B.Rate
      ,[08Q3US]=A.[08Q3LC]/B.Rate
      ,[08Q4US]=A.[08Q4LC]/B.Rate
      ,[09Q1US]=A.[09Q1LC]/B.Rate
      ,[09Q2US]=A.[09Q2LC]/B.Rate
      ,[09Q3US]=A.[09Q3LC]/B.Rate
      ,[09Q4US]=A.[09Q4LC]/B.Rate
      ,[10Q1US]=A.[10Q1LC]/B.Rate
      ,[10Q2US]=A.[10Q2LC]/B.Rate
      ,[10Q3US]=A.[10Q3LC]/B.Rate
      ,[10Q4US]=A.[10Q4LC]/B.Rate
      ,[11Q1US]=A.[11Q1LC]/B.Rate
      ,[11Q2US]=A.[11Q2LC]/B.Rate
      ,[11Q3US]=A.[11Q3LC]/B.Rate 
      ,[11Q4US]=A.[11Q4LC]/B.Rate
      ,[12Q1US]=A.[12Q1LC]/B.Rate
      ,[12Q2US]=A.[12Q2LC]/B.Rate
      ,[12Q3US]=A.[12Q3LC]/B.Rate 
      ,[12Q4US]=A.[12Q4LC]/B.Rate  
	  ,[13Q1US]=A.[13Q1LC]/B.Rate  
	  ,[13Q2US]=A.[13Q2LC]/B.Rate  
	  ,[13Q3US]=A.[13Q3LC]/B.Rate  
	  ,[13Q4US]=A.[13Q4LC]/B.Rate  
	  ,[14Q1US]=A.[14Q1LC]/B.Rate  
	  ,[14Q2US]=A.[14Q2LC]/B.Rate 
	  ,[14Q3US]=A.[14Q3LC]/B.Rate 
	  ,[14Q4US]=A.[14Q4LC]/B.Rate 
	  ,[15Q1US]=A.[15Q1LC]/B.Rate 
	  ,[15Q2US]=A.[15Q2LC]/B.Rate 
	  ,[15Q3US]=A.[15Q3LC]/B.Rate
	  ,[15Q4US]=A.[15Q4LC]/B.Rate
	  ,[16Q1US]=A.[16Q1LC]/B.Rate	  
	  --todo
from inHKAPI_Linda A,db4.BMSChinaCIA_IMS_test.dbo.tblRate B
go
---IMSDBPlus_201109.dbo.tblRate

select * from inHKAPI_Linda
where [Product name] like '%gli%' or [Product name] like 'sp%'

if object_id(N'inHKAPI_New_bak',N'U') is not null
	drop table inHKAPI_New_bak
select * into dbo.inHKAPI_New_bak from dbo.inHKAPI_Linda

if object_id(N'inHKAPI_New',N'U') is not null
	drop table inHKAPI_New
select * into dbo.inHKAPI_New from dbo.inHKAPI_Linda

--todo
if object_id(N'inHKAPI_2016Q1',N'U') is not null
	drop table inHKAPI_2016Q1
select * into dbo.inHKAPI_2016Q1 from dbo.inHKAPI_Linda

exec BMSChinaCIA_IMS_test.dbo.sp_Log_Event 'In','CIA','0_2_in_HKAPI.sql','End',null,null
/*
select *
 from inHKAPI_New A where  exists(select * from 
IMSDBPlus_201109.dbo.tblMktDef_MRBIChina B
where A.[Product Name]=B.productname)

select distinct [Company name] from dbo.inHKAPI_New A where [Company name] not in (select Abbreviation
from dbo.HKAPI_CompanyName)

insert into HKAPI_CompanyName values('DSC','DAIICHI SANKYO PHARMA')
select * from HKAPI_CompanyName

use IMSDB2US
go
select * into dbo.inHKAPI from BMSChinaOtherDB.dbo.inHKAPI_New
select * into dbo.HKAPI_CompanyName from BMSChinaOtherDB.dbo.HKAPI_CompanyName
select * into dbo.MTHCHPA_PKAU from IMSDBPlus_201109.dbo.MTHCHPA_PKAU
select * into dbo.MTHCITY_PKAU from IMSDBPlus_201109.dbo.MTHCITY_PKAU

*/