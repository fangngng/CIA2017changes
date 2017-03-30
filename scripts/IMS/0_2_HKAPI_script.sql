use BMSChinaOtherDB
GO

--Time: 00:12
exec BMSChinaCIA_IMS.dbo.sp_Log_Event 'In','CIA','0_2_in_HKAPI.sql','Start',null,null
declare @currQuarter varchar(10)
select @currQuarter = convert(varchar(6),Year)+Qtr
from BMSChinaCIA_IMS.dbo.tblDateHKAPI 

--update product name and companyname

if not exists(select 1 from BMSChinaOtherDB.dbo.hkapi_Time_Config where Quarter=@currQuarter)
begin
	insert into BMSChinaOtherDB.dbo.hkapi_Time_Config (Quarter)
	values(@currQuarter)
end

--update current quarter product and company

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
from BMSChinaCIA_IMS.dbo.tblDateHKAPI 
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

--add new product or company


declare cursor_HKAPI_Quarter cursor for 
select quarter from BMSChinaOtherDB.dbo.hkapi_Time_Config where Quarter<>'2010Q4'
declare @Quarter varchar(10),@column_last varchar(20)
declare @sql varchar(max)
set @sql=' '
select @column_last=right(year,2)+quarter from [BMSChinaCIA_IMS].[dbo].[tblMonthList] 
where monseq in (
	select a.monseq+3 as monseq 
	from [BMSChinaCIA_IMS].[dbo].[tblMonthList] a
	inner join (select max(quarter)as quarter  
				from BMSChinaOtherDB.dbo.hkapi_Time_Config) b
	on a.year=left(b.quarter,4) and a.quarter=right(b.quarter,2) and right(a.date,2)%3=0 
)	
set @sql='
if object_id(N''inHKAPI_Linda'',N''U'') is not null
	drop table inHKAPI_Linda
select * into dbo.inHKAPI_Linda from dbo.inHKAPI_20'+@column_last+'
'
print @sql
exec(@sql)
	
open cursor_HKAPI_Quarter
FETCH NEXT FROM cursor_HKAPI_Quarter INTO @Quarter 
WHILE @@FETCH_STATUS=0
BEGIN
	set @sql='
	delete from HKAPI_'+@Quarter+'STLY where [company name] is null

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
	delete from HKAPI_'+@Quarter+' where [company name] is null
	if exists(	select * 
				from dbo.HKAPI_'+@Quarter+' A 
				where not exists(	select * from 
									inHKAPI_Linda B
									where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
								)
			)

	insert into inHKAPI_Linda ([Company Name],[Product Name])
	select distinct [Company Name] ,[Product Name]
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
--add current/pervious quarter data

declare @sql varchar(max),@column_last varchar(20),@column_STLY_last varchar(20),@column varchar(20),@column_STLY varchar(20)
select @column_last=right(year,2)+quarter 
from [BMSChinaCIA_IMS].[dbo].[tblMonthList] 
where monseq in (
	select a.monseq+3 as monseq 
	from [BMSChinaCIA_IMS].[dbo].[tblMonthList] a
	inner join (
			select max(quarter)as quarter  
			from BMSChinaOtherDB.dbo.hkapi_Time_Config ) b
	on a.year=left(b.quarter,4) and a.quarter=right(b.quarter,2) and right(a.date,2)%3=0 
	)


select @column=right(max(quarter),4) from BMSChinaOtherDB.dbo.hkapi_Time_Config

select @column_STLY_last=right(year,2)+quarter 
from [BMSChinaCIA_IMS].[dbo].[tblMonthList] 
where monseq in (
	select a.monseq+15 as monseq 
	from [BMSChinaCIA_IMS].[dbo].[tblMonthList] a
	inner join ( select max(quarter)as quarter  from BMSChinaOtherDB.dbo.hkapi_Time_Config ) b
	on a.year=left(b.quarter,4) and a.quarter=right(b.quarter,2) and right(a.date,2)%3=0 
	)

select @column_STLY=right(year,2)+quarter 
from [BMSChinaCIA_IMS].[dbo].[tblMonthList] 
where monseq in (
	select a.monseq+12 as monseq 
	from [BMSChinaCIA_IMS].[dbo].[tblMonthList] a
	inner join (select max(quarter)as quarter  from BMSChinaOtherDB.dbo.hkapi_Time_Config) b
	on a.year=left(b.quarter,4) and a.quarter=right(b.quarter,2) and right(a.date,2)%3=0 
	)
set @sql=''
set @sql='

IF EXISTS ( 
	SELECT 1 FROM SYSOBJECTS T1  
  	INNER JOIN SYSCOLUMNS T2 ON T1.ID=T2.ID  
 	WHERE T1.NAME=''inHKAPI_Linda'' AND T2.NAME='''+@column+'LC''  
	) 
BEGIN
	alter table inHKAPI_Linda drop column ['+@column+'LC],[YTD '+@column+'LC],['+@column+'US]

	alter table inHKAPI_Linda 
	add ['+@column+'LC] [float] NULL ,
		[YTD '+@column+'LC] [float] NULL ,
		['+@column+'US] [float] NULL 

end
else
	begin
	alter table inHKAPI_Linda 
	add ['+@column+'LC] [float] NULL ,
		[YTD '+@column+'LC] [float] NULL ,
		['+@column+'US] [float] NULL 
end
'
print @column
print @column_STLY
print @sql

exec(@sql)


set @sql='
update inHKAPI_Linda
set [YTD '+@column_STLY+'LC]=B.Sales 
from inHKAPI_Linda A 
inner join 
	(	select [Company Name]
			,[Product Name]
			,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
		from BMSChinaOtherDB.dbo.HKAPI_20'+@column+'STLY 
		group by [Company Name], [Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
'
print @sql
exec(@sql)

set @sql='
update inHKAPI_Linda
set [YTD '+@column+'LC]=B.Sales from inHKAPI_Linda A inner join 
(	select [Company Name]
		,[Product Name]
		,sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 	from BMSChinaOtherDB.dbo.HKAPI_20'+@column+' 
	group by [Company Name] ,[Product Name]
      ) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]

'
print @sql
exec(@sql)

set @sql='
update inHKAPI_Linda 
set [YTD '+@column+'LC]=case when [YTD '+@column+'LC] is null then 0 else [YTD '+@column+'LC] end,
	['+@column+'LC]=case when left(right('''+@column+'LC'',4),2)=''Q1'' then [YTD '+@column+'LC] else [YTD '+@column+'LC]-[YTD '+@column_last+'LC] end,
	['+@column_STLY+'LC]=case when left(right('''+@column+'LC'',4),2)=''Q1'' then [YTD '+@column_STLY+'LC] else [YTD '+@column_STLY+'LC]-[YTD '+@column_STLY_last+'LC] end


'
print @sql
exec (@sql)


declare cursor_HKAPI_update_null cursor for 
select right(year,2)+quarter as quarter from [BMSChinaCIA_IMS].[dbo].[tblMonthList] where right(date,2)%3=0 
declare @quarter_all varchar(20)
--declare @sql varchar(max)
--set @sql=''
open cursor_HKAPI_update_null
fetch next from cursor_HKAPI_update_null into @quarter_all
while @@FETCH_STATUS =0
begin
	set @sql='
	update inHKAPI_Linda set ['+@quarter_all+'LC]=case when  ['+@quarter_all+'LC] is null then 0 else  ['+@quarter_all+'LC] end,
							 ['+@quarter_all+'US]=case when  ['+@quarter_all+'US] is null then 0 else  ['+@quarter_all+'US] end,
							 [YTD '+@quarter_all+'LC]=case when  [YTD '+@quarter_all+'LC] is null then 0 else  [YTD '+@quarter_all+'LC] end
	'
	print @sql	
	exec (@sql)
	fetch next from cursor_HKAPI_update_null into @quarter_all
end
close cursor_HKAPI_update_null
deallocate cursor_HKAPI_update_null


set @sql='
update inHKAPI_Linda set ['+@column+'US]=A.['+@column+'LC]/B.Rate,['+@column_STLY+'US]=A.['+@column_STLY+'LC]/B.Rate
from inHKAPI_Linda A,db4.BMSChinaCIA_IMS.dbo.tblRate B
'
print @sql
exec(@sql)


--set @sql='
--update inHKAPI_Linda set ['+@column+'LC]=case when ['+@column+'LC] is null then 0 else ['+@column+'LC] end,
--['+@column_STLY+'LC]=case when ['+@column_STLY+'LC] is null then 0 else ['+@column_STLY+'LC] end

--'
--print @sql
--exec (@sql)

set @sql=''
set @sql='

if object_id(N''inHKAPI_20'+@column+''',N''U'') is not null
	drop table inHKAPI_20'+@column+'
select * into dbo.inHKAPI_20'+@column+' from dbo.inHKAPI_Linda


'
print @sql
exec(@sql)

if object_id(N'inHKAPI_New',N'U') is not null
	drop table inHKAPI_New
select * into dbo.inHKAPI_New from dbo.inHKAPI_Linda