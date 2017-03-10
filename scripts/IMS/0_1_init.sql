USE BMSChinaCIA_IMS_test--DB4
GO

--time 00:01



exec dbo.sp_Log_Event 'Init','CIA','0_1_init.sql','Start',null,null




print (N'
------------------------------------------------------------------------------------------------------------
1. 函数
------------------------------------------------------------------------------------------------------------
')
----- * fnGetParameter * ----- 
--获取IMS和HKAPI最新日期
if object_id(N'fnGetParameter', N'FN') is not null
  drop function dbo.fnGetParameter
go
create function dbo.fnGetParameter(@inParameter varchar(50))
returns int
as
begin
  declare @Value as varchar(50)
  select @Value = [Value] from Config where Parameter = @inParameter 
  return @Value
end
go
--Print dbo.fnGetParameter('IMS')
--Print dbo.fnGetParameter('HKAPI')

----- * 1. fnAddColumns * ----- 
if object_id(N'fnAddColumns', N'FN') is not null
  drop function dbo.fnAddColumns
go
create function dbo.fnAddColumns(@field varchar(50), @Currency varchar(50), @Count int)
returns varchar(8000)
as
begin
	declare @i int, @j int
	declare @sql as varchar(8000)
	set @sql=''
	set @i = 0
	while @i <= @Count
	begin
		set @sql = @sql + '
			' + @field + right('0' + cast(@i as varchar),2) + @Currency + ' float not null default 0,'
		set @i = @i + 1
	end
	set @sql = left(@sql, len(@sql) - 1) 
	return @sql
end
go

----- * 2. fnGetformulaMAT * ----- 
if object_id(N'fnGetformulaMAT', N'FN') is not null
	drop function dbo.fnGetformulaMAT
go
create function dbo.fnGetformulaMAT(@Currency varchar(50), @Count int)
returns varchar(8000)
as
begin
	declare @i int, @j int
	declare @sql as varchar(8000)
	declare @formula as varchar(500)

	set @sql=''
	set @i = 0
	while @i <= @Count
	begin
		set @formula = ''
		select @j = @i
		while @j <= @i + 11
		begin 
			set @formula = @formula + '+Mth' + right('0' + cast(@j as varchar),2) + @Currency
			set @j = @j + 1
		end 
		set @formula = right(@formula, len(@formula) - 1)

		set @sql= @sql + '
			MAT' + right('0' + cast(@i as varchar),2) + @Currency + '=' + @formula + ','
		set @i = @i + 1
	end
	set @sql = left(@sql, len(@sql) - 1) 
	return @sql
end
go

----- * 3. fnGetformulaR3M * ----- 
if object_id(N'fnGetformulaR3M', N'FN') is not null
	drop function dbo.fnGetformulaR3M
go
create function dbo.fnGetformulaR3M(@Currency varchar(50), @Count int)
returns varchar(8000)
as
begin
	declare @i int, @j int
	declare @sql as varchar(8000)
	declare @formula as varchar(500)

	set @sql=''
	set @i = 0
	while @i <= @Count
	begin
		set @formula = ''
		select @j = @i
		while @j <= @i + 2
		begin 
			set @formula = @formula + '+Mth' + right('0' + cast(@j as varchar),2) + @Currency
			set @j = @j + 1
		end 
		set @formula = right(@formula, len(@formula) - 1)

		set @sql= @sql + '
			R3M' + right('0' + cast(@i as varchar),2) + @Currency + '=' + @formula + ','
		set @i = @i + 1
	end
	set @sql = left(@sql, len(@sql) - 1) 
	return @sql
end
go

----- * 4. fnGetformulaQTR * ----- 
if object_id(N'fnGetformulaQTR', N'FN') is not null
	drop function dbo.fnGetformulaQTR
go
create function dbo.fnGetformulaQTR(@Currency varchar(50), @Count int)
returns varchar(8000)
as
begin
	declare @i int, @j int
	declare @sql as varchar(8000)
	declare @formula as varchar(500)

	set @sql=''
	set @i = 0
	while @i <= @Count
	begin
		set @formula = ''
		select @j = Min(MonSeq) from tblMonthList where QtrSeq = @i + 1
		while @j <= (select Max(MonSeq) from tblMonthList where QtrSeq = @i + 1)
		begin 
			set @formula = @formula + '+Mth' + right('0' + cast(@j - 1 as varchar),2) + @Currency
			set @j = @j + 1
		end 
		set @formula = right(@formula, len(@formula) - 1)

		set @sql= @sql + '
			QTR' + right('0' + cast(@i as varchar),2) + @Currency + '=' + @formula + ','
		set @i = @i + 1
	end
	set @sql = left(@sql, len(@sql) - 1) 
	return @sql
end
go

----- * 5. fnGetformulaYTD * ----- 
if object_id(N'fnGetformulaYTD', N'FN') is not null
	drop function dbo.fnGetformulaYTD
go
create function dbo.fnGetformulaYTD(@Currency varchar(50), @Count int)
returns varchar(8000)
as
begin
	declare @i int, @j int
	declare @sql as varchar(8000)
	declare @formula as varchar(500)

	set @sql=''
	set @i = 0
	while @i <= @Count
	begin
		set @formula = ''
		select @j = Min(MonSeq) from tblYTDList where YTDSeq = @i + 1
		while @j <= (select Max(MonSeq) from tblYTDList where YTDSeq = @i + 1)
		begin 
			set @formula = @formula + '+Mth' + right('0' + cast(@j -1 as varchar),2) + @Currency
			set @j = @j + 1
		end 
		set @formula = right(@formula, len(@formula) - 1)

		set @sql= @sql + '
			YTD' + right('0' + cast(@i as varchar),2) + @Currency + '=' + @formula + ','
		set @i = @i + 1
	end
	set @sql = left(@sql, len(@sql) - 1) 
	return @sql
end
go



if object_id(N'fun_upperFirst', N'FN') is not null
	drop function dbo.fun_upperFirst
go
create   function   [dbo].[fun_upperFirst](@col   varchar(2000))
returns   varchar(2000)   
as   
begin
     set @col=replace(@col,'  ',' ')
     set @col=replace(@col,',','**,')
     set @col=replace(@col,' ',',')
     
     declare @sql varchar(2000)   
    set   @sql=''
    while charindex(',',@col)>0
        select @sql=@sql+upper(left(@col,1))+LOWER(replace(substring(@col,2,charindex(',',@col)-1),',',' ')),
        @col=substring(@col,charindex(',',@col)+1,len(@col)-charindex(',',@col))    
    set   @sql=@sql+upper(left(@col,1)) + replace(LOWER(right(@col,len(@col)-1)),',',' ')
    set @sql=replace(@sql,'** ',',')
    set @sql=replace(@sql,',,',', ')
    return(@sql)
end
GO


if object_id(N'fun_upperFirst', N'FN') is not null
	drop function dbo.fun_upperFirst
go
create   function   [dbo].[fun_upperFirst](@col   varchar(2000))
returns   varchar(2000)   
as   
begin
     set @col=replace(@col,'  ',' ')
     set @col=replace(@col,',','**,')
     set @col=replace(@col,' ',',')
     
     declare @sql varchar(2000)   
    set   @sql=''
    while charindex(',',@col)>0
        select @sql=@sql+upper(left(@col,1))+LOWER(replace(substring(@col,2,charindex(',',@col)-1),',',' ')),
        @col=substring(@col,charindex(',',@col)+1,len(@col)-charindex(',',@col))    
    set   @sql=@sql+upper(left(@col,1)) + replace(LOWER(right(@col,len(@col)-1)),',',' ')
    set @sql=replace(@sql,'** ',',')
    set @sql=replace(@sql,',,',', ')
    return(@sql)
end
GO





print (N'
------------------------------------------------------------------------------------------------------------
2. 配置表
------------------------------------------------------------------------------------------------------------
')

-- select * from tblMonthList
if object_id(N'tblMonthList', N'U') is not null
	drop table tblMonthList
go

create table tblMonthList (
  [MonSeq]	int,
  [Date]		varchar(10),
  [YerSeq]	int,
  [Year]		int,
  [Month]		int,
  [MonthEN]	varchar(10),
  [QtrSeq]	int,
  [Quarter]	varchar(10)
) 
go

declare @MonSeq int, @YerSeq int, @QtrSeq int
declare @i int, @curDate datetime, @Date varchar(8), @Year varchar(6), @Month varchar(6)
set @i = 1
set @YerSeq = 1
set @QtrSeq = 0
set @MonSeq = 1
set @curDate = cast(dbo.fnGetParameter('IMS') as varchar) + '01' 
while convert(varchar(6), dateadd(month, 1 - @i, @curDate) ,112) >= '200601' 
begin
	set @Date = convert(varchar(8), dateadd(month, 1 - @i, @curDate) ,112)
	set @Year = cast(year(@Date) as varchar)
	set @Month = cast(month(@Date) as varchar)

	if @Month = 12 and @i <> 1
	begin 
		set @YerSeq = @YerSeq + 1
	end 

	if @Month % 3 = 0  
	begin 
		set @QtrSeq = @QtrSeq + 1
	end 
	
	set @MonSeq = @i

	insert into tblMonthList([MonSeq],[Date],[YerSeq],[Year],[Month],[QtrSeq]) 
	select @MonSeq, left(@Date, 6), @YerSeq, @Year, @Month,@QtrSeq

	set @i = @i + 1
end
go

update tblMonthList set MonthEN = b.MonthEN + '''' + cast(right(Year,2) as varchar), Quarter = b.Quarter
from tblMonthList a inner join tblMonth b on a.[Month] = b.[Month]
go



-- select * from tblYTDList
if object_id(N'tblYTDList', N'U') is not null
	drop table tblYTDList
go

select a.MonSeq as YTDSeq,a.[Year] as YTD_Year,a.[Month] as YTD_Month, b.[MonSeq],b.[Year],b.[Month]
into tblYTDList from 
(select MonSeq, Year, Month from tblMonthList) a inner join 
(select MonSeq, Year, Month from tblMonthList) b
on a.[Year] = b.[Year] and a.[Month] >= b.[Month]
order by YTDSeq
GO





print (N'
------------------------------------------------------------------------------------------------------------
3. 建表语句
------------------------------------------------------------------------------------------------------------
')

USE [BMSChinaCIA_IMS_test]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
/****** Object:  Table [dbo].[MID_C150_RegionData]    Script Date: 07/18/2013 13:21:44 ******/
if object_id(N'MID_C150_RegionData', N'U') is not null
  drop table MID_C150_RegionData
go
CREATE TABLE [dbo].[MID_C150_RegionData](
	[Type] [varchar](20) NOT NULL,
	[mkt] [varchar](50) NULL,
	[mktname] [varchar](50) NULL,
	[Market] [varchar](50) NULL,
	[prod] [varchar](200) NULL,
	[Productname] [varchar](200) NULL,
	[Moneytype] [varchar](50) NOT NULL,
	[Region] [varchar](200) NULL,
	[R3M00] [float] NULL,
	[R3M01] [float] NULL,
	[R3M02] [float] NULL,
	[R3M03] [float] NULL,
	[R3M04] [float] NULL,
	[R3M05] [float] NULL,
	[R3M06] [float] NULL,
	[R3M07] [float] NULL,
	[R3M08] [float] NULL,
	[R3M09] [float] NULL,
	[R3M10] [float] NULL,
	[R3M11] [float] NULL,
	[R3M12] [float] NULL,
	[R3M13] [float] NULL,
	[R3M14] [float] NULL,
	[R3M15] [float] NULL,
	[R3M16] [float] NULL,
	[R3M17] [float] NULL,
	[R3M18] [float] NULL,
	[R3M19] [float] NULL,
	[R3M20] [float] NULL,
	[R3M21] [float] NULL,
	[R3M22] [float] NULL,
	[R3M23] [float] NULL,
	[R3M24] [float] NULL,
	[R3M25] [float] NULL,
	[R3M26] [float] NULL,
	[R3M27] [float] NULL,
	[R3M28] [float] NULL,
	[R3M29] [float] NULL,
	[R3M30] [float] NULL,
	[R3M31] [float] NULL,
	[R3M32] [float] NULL,
	[R3M33] [float] NULL,
	[R3M34] [float] NULL,
	[R3M35] [float] NULL,
	[R3M36] [float] NULL,
	[R3M37] [float] NULL,
	[R3M38] [float] NULL,
	[R3M39] [float] NULL,
	[R3M40] [float] NULL,
	[R3M41] [float] NULL,
	[R3M42] [float] NULL,
	[R3M43] [float] NULL,
	[R3M44] [float] NULL,
	[R3M45] [float] NULL,
	--[R3M46] [float] NULL,
	--[R3M47] [float] NULL,
	--[R3M48] [float] NULL,
	--[R3M49] [float] NULL,
	--[R3M50] [float] NULL,
	--[R3M51] [float] NULL,
	--[R3M52] [float] NULL,
	--[R3M53] [float] NULL,
	--[R3M54] [float] NULL,
	--[R3M55] [float] NULL,
	--[R3M56] [float] NULL,
	--[R3M57] [float] NULL,
	[MTH00] [float] NULL,
	[MTH01] [float] NULL,
	[MTH02] [float] NULL,
	[MTH03] [float] NULL,
	[MTH04] [float] NULL,
	[MTH05] [float] NULL,
	[MTH06] [float] NULL,
	[MTH07] [float] NULL,
	[MTH08] [float] NULL,
	[MTH09] [float] NULL,
	[MTH10] [float] NULL,
	[MTH11] [float] NULL,
	[MTH12] [float] NULL,
	[MTH13] [float] NULL,
	[MTH14] [float] NULL,
	[MTH15] [float] NULL,
	[MTH16] [float] NULL,
	[MTH17] [float] NULL,
	[MTH18] [float] NULL,
	[MTH19] [float] NULL,
	[MTH20] [float] NULL,
	[MTH21] [float] NULL,
	[MTH22] [float] NULL,
	[MTH23] [float] NULL,
	[MTH24] [float] NULL,
	[MTH25] [float] NULL,
	[MTH26] [float] NULL,
	[MTH27] [float] NULL,
	[MTH28] [float] NULL,
	[MTH29] [float] NULL,
	[MTH30] [float] NULL,
	[MTH31] [float] NULL,
	[MTH32] [float] NULL,
	[MTH33] [float] NULL,
	[MTH34] [float] NULL,
	[MTH35] [float] NULL,
	[MTH36] [float] NULL,
	[MTH37] [float] NULL,
	[MTH38] [float] NULL,
	[MTH39] [float] NULL,
	[MTH40] [float] NULL,
	[MTH41] [float] NULL,
	[MTH42] [float] NULL,
	[MTH43] [float] NULL,
	[MTH44] [float] NULL,
	[MTH45] [float] NULL,
	[MTH46] [float] NULL,
	[MTH47] [float] NULL,
	[MTH48] [float] NULL,
	--[MTH49] [float] NULL,
	--[MTH50] [float] NULL,
	--[MTH51] [float] NULL,
	--[MTH52] [float] NULL,
	--[MTH53] [float] NULL,
	--[MTH54] [float] NULL,
	--[MTH55] [float] NULL,
	--[MTH56] [float] NULL,
	--[MTH57] [float] NULL,
	--[MTH58] [float] NULL,
	--[MTH59] [float] NULL,
	[MAT00] [float] NULL,
	[MAT01] [float] NULL,
	[MAT02] [float] NULL,
	[MAT03] [float] NULL,
	[MAT04] [float] NULL,
	[MAT05] [float] NULL,
	[MAT06] [float] NULL,
	[MAT07] [float] NULL,
	[MAT08] [float] NULL,
	[MAT09] [float] NULL,
	[MAT10] [float] NULL,
	[MAT11] [float] NULL,
	[MAT12] [float] NULL,
	[MAT13] [float] NULL,
	[MAT14] [float] NULL,
	[MAT15] [float] NULL,
	[MAT16] [float] NULL,
	[MAT17] [float] NULL,
	[MAT18] [float] NULL,
	[MAT19] [float] NULL,
	[MAT20] [float] NULL,
	[MAT21] [float] NULL,
	[MAT22] [float] NULL,
	[MAT23] [float] NULL,
	[MAT24] [float] NULL,
	[MAT25] [float] NULL,
	[MAT26] [float] NULL,
	[MAT27] [float] NULL,
	[MAT28] [float] NULL,
	[MAT29] [float] NULL,
	[MAT30] [float] NULL,
	[MAT31] [float] NULL,
	[MAT32] [float] NULL,
	[MAT33] [float] NULL,
	[MAT34] [float] NULL,
	[MAT35] [float] NULL,
	[MAT36] [float] NULL,
	[MAT37] [float] NULL,
	[MAT38] [float] NULL,
	[MAT39] [float] NULL,
	[MAT40] [float] NULL,
	[MAT41] [float] NULL,
	[MAT42] [float] NULL,
	[MAT43] [float] NULL,
	[MAT44] [float] NULL,
	[MAT45] [float] NULL,
	[MAT46] [float] NULL,
	[MAT47] [float] NULL,
	[MAT48] [float] NULL,
	[YTD00] [float] NULL,
	[YTD01] [float] NULL,
	[YTD02] [float] NULL,
	[YTD03] [float] NULL,
	[YTD04] [float] NULL,
	[YTD05] [float] NULL,
	[YTD06] [float] NULL,
	[YTD07] [float] NULL,
	[YTD08] [float] NULL,
	[YTD09] [float] NULL,
	[YTD10] [float] NULL,
	[YTD11] [float] NULL,
	[YTD12] [float] NULL,
	[YTD13] [float] NULL,
	[YTD14] [float] NULL,
	[YTD15] [float] NULL,
	[YTD16] [float] NULL,
	[YTD17] [float] NULL,
	[YTD18] [float] NULL,
	[YTD19] [float] NULL,
	[YTD20] [float] NULL,
	[YTD21] [float] NULL,
	[YTD22] [float] NULL,
	[YTD23] [float] NULL,
	[YTD24] [float] NULL,
	[YTD25] [float] NULL,
	[YTD26] [float] NULL,
	[YTD27] [float] NULL,
	[YTD28] [float] NULL,
	[YTD29] [float] NULL,
	[YTD30] [float] NULL,
	[YTD31] [float] NULL,
	[YTD32] [float] NULL,
	[YTD33] [float] NULL,
	[YTD34] [float] NULL,
	[YTD35] [float] NULL,
	[YTD36] [float] NULL,
	[YTD37] [float] NULL,
	[YTD38] [float] NULL,
	[YTD39] [float] NULL,
	[YTD40] [float] NULL,
	[YTD41] [float] NULL,
	[YTD42] [float] NULL,
	[YTD43] [float] NULL,
	[YTD44] [float] NULL,
	[YTD45] [float] NULL,
	[YTD46] [float] NULL,
	[YTD47] [float] NULL,
	[YTD48] [float] NULL,
	--[YTD49] [float] NULL,
	--[YTD50] [float] NULL,
	--[YTD51] [float] NULL,
	--[YTD52] [float] NULL,
	--[YTD53] [float] NULL,
	--[YTD54] [float] NULL,
	--[YTD55] [float] NULL,
	--[YTD56] [float] NULL,
	--[YTD57] [float] NULL,
	--[YTD58] [float] NULL,
	--[YTD59] [float] NULL,
	--[YTD60] [float] NULL,
	[Qtr00] [float] NULL,
	[Qtr01] [float] NULL,
	[Qtr02] [float] NULL,
	[Qtr03] [float] NULL,
	[Qtr04] [float] NULL,
	[Qtr05] [float] NULL,
	[Qtr06] [float] NULL,
	[Qtr07] [float] NULL,
	[Qtr08] [float] NULL,
	[Qtr09] [float] NULL,
	[Qtr10] [float] NULL,
	[Qtr11] [float] NULL,
	[Qtr12] [float] NULL,
	[Qtr13] [float] NULL,
	[Qtr14] [float] NULL,
	[Qtr15] [float] NULL,
	[Qtr16] [float] NULL,
	[Qtr17] [float] NULL,
	[Qtr18] [float] NULL,
	[Qtr19] [float] NULL
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[OUT_C150_RegionData]    Script Date: 07/18/2013 13:33:08 ******/
if object_id(N'OUT_C150_RegionData', N'U') is not null
  drop table OUT_C150_RegionData
go
CREATE TABLE [dbo].[OUT_C150_RegionData](
	[Type] [varchar](20) NOT NULL,
	[mkt] [varchar](50) NULL,
	[mktname] [varchar](50) NULL,
	[Market] [varchar](50) NULL,
	[prod] [varchar](200) NULL,
	[Productname] [varchar](200) NULL,
	[Moneytype] [varchar](50) NOT NULL,
	[Region] [varchar](200) NULL,
	[Period] [varchar](50) NOT NULL,
	[Value] [float] NULL
) ON [PRIMARY]

GO


/****** Object:  Table [dbo].[MID_C160_RegionData]    Script Date: 07/18/2013 13:36:37 ******/
if object_id(N'MID_C160_RegionData', N'U') is not null
  drop table MID_C160_RegionData
go
CREATE TABLE [dbo].[MID_C160_RegionData](
	[Type] [varchar](20) NOT NULL,
	[mkt] [varchar](50) NULL,
	[mktname] [varchar](50) NULL,
	[Market] [varchar](50) NULL,
	[prod] [varchar](200) NULL,
	[Productname] [varchar](200) NULL,
	[Moneytype] [varchar](50) NOT NULL,
	[Audi_cod] [varchar](200) NULL,
	[Audi_des] [varchar](200) NULL,
	[Region] [varchar](200) NULL,
	[R3M00] [float] NULL,
	[R3M01] [float] NULL,
	[R3M02] [float] NULL,
	[R3M03] [float] NULL,
	[R3M04] [float] NULL,
	[R3M05] [float] NULL,
	[R3M06] [float] NULL,
	[R3M07] [float] NULL,
	[R3M08] [float] NULL,
	[R3M09] [float] NULL,
	[R3M10] [float] NULL,
	[R3M11] [float] NULL,
	[R3M12] [float] NULL,
	[R3M13] [float] NULL,
	[R3M14] [float] NULL,
	[R3M15] [float] NULL,
	[R3M16] [float] NULL,
	[R3M17] [float] NULL,
	[R3M18] [float] NULL,
	[R3M19] [float] NULL,
	[R3M20] [float] NULL,
	[R3M21] [float] NULL,
	[R3M22] [float] NULL,
	[R3M23] [float] NULL,
	[R3M24] [float] NULL,
	[R3M25] [float] NULL,
	[R3M26] [float] NULL,
	[R3M27] [float] NULL,
	[R3M28] [float] NULL,
	[R3M29] [float] NULL,
	[R3M30] [float] NULL,
	[R3M31] [float] NULL,
	[R3M32] [float] NULL,
	[R3M33] [float] NULL,
	[R3M34] [float] NULL,
	[R3M35] [float] NULL,
	[R3M36] [float] NULL,
	[R3M37] [float] NULL,
	[R3M38] [float] NULL,
	[R3M39] [float] NULL,
	[R3M40] [float] NULL,
	[R3M41] [float] NULL,
	[R3M42] [float] NULL,
	[R3M43] [float] NULL,
	[R3M44] [float] NULL,
	[R3M45] [float] NULL,
	--[R3M46] [float] NULL,
	--[R3M47] [float] NULL,
	--[R3M48] [float] NULL,
	--[R3M49] [float] NULL,
	--[R3M50] [float] NULL,
	--[R3M51] [float] NULL,
	--[R3M52] [float] NULL,
	--[R3M53] [float] NULL,
	--[R3M54] [float] NULL,
	--[R3M55] [float] NULL,
	--[R3M56] [float] NULL,
	--[R3M57] [float] NULL,
	[MTH00] [float] NULL,
	[MTH01] [float] NULL,
	[MTH02] [float] NULL,
	[MTH03] [float] NULL,
	[MTH04] [float] NULL,
	[MTH05] [float] NULL,
	[MTH06] [float] NULL,
	[MTH07] [float] NULL,
	[MTH08] [float] NULL,
	[MTH09] [float] NULL,
	[MTH10] [float] NULL,
	[MTH11] [float] NULL,
	[MTH12] [float] NULL,
	[MTH13] [float] NULL,
	[MTH14] [float] NULL,
	[MTH15] [float] NULL,
	[MTH16] [float] NULL,
	[MTH17] [float] NULL,
	[MTH18] [float] NULL,
	[MTH19] [float] NULL,
	[MTH20] [float] NULL,
	[MTH21] [float] NULL,
	[MTH22] [float] NULL,
	[MTH23] [float] NULL,
	[MTH24] [float] NULL,
	[MTH25] [float] NULL,
	[MTH26] [float] NULL,
	[MTH27] [float] NULL,
	[MTH28] [float] NULL,
	[MTH29] [float] NULL,
	[MTH30] [float] NULL,
	[MTH31] [float] NULL,
	[MTH32] [float] NULL,
	[MTH33] [float] NULL,
	[MTH34] [float] NULL,
	[MTH35] [float] NULL,
	[MTH36] [float] NULL,
	[MTH37] [float] NULL,
	[MTH38] [float] NULL,
	[MTH39] [float] NULL,
	[MTH40] [float] NULL,
	[MTH41] [float] NULL,
	[MTH42] [float] NULL,
	[MTH43] [float] NULL,
	[MTH44] [float] NULL,
	[MTH45] [float] NULL,
	[MTH46] [float] NULL,
	[MTH47] [float] NULL,
	[MTH48] [float] NULL,
	--[MTH49] [float] NULL,
	--[MTH50] [float] NULL,
	--[MTH51] [float] NULL,
	--[MTH52] [float] NULL,
	--[MTH53] [float] NULL,
	--[MTH54] [float] NULL,
	--[MTH55] [float] NULL,
	--[MTH56] [float] NULL,
	--[MTH57] [float] NULL,
	--[MTH58] [float] NULL,
	--[MTH59] [float] NULL,
	[MAT00] [float] NULL,
	[MAT01] [float] NULL,
	[MAT02] [float] NULL,
	[MAT03] [float] NULL,
	[MAT04] [float] NULL,
	[MAT05] [float] NULL,
	[MAT06] [float] NULL,
	[MAT07] [float] NULL,
	[MAT08] [float] NULL,
	[MAT09] [float] NULL,
	[MAT10] [float] NULL,
	[MAT11] [float] NULL,
	[MAT12] [float] NULL,
	[MAT13] [float] NULL,
	[MAT14] [float] NULL,
	[MAT15] [float] NULL,
	[MAT16] [float] NULL,
	[MAT17] [float] NULL,
	[MAT18] [float] NULL,
	[MAT19] [float] NULL,
	[MAT20] [float] NULL,
	[MAT21] [float] NULL,
	[MAT22] [float] NULL,
	[MAT23] [float] NULL,
	[MAT24] [float] NULL,
	[MAT25] [float] NULL,
	[MAT26] [float] NULL,
	[MAT27] [float] NULL,
	[MAT28] [float] NULL,
	[MAT29] [float] NULL,
	[MAT30] [float] NULL,
	[MAT31] [float] NULL,
	[MAT32] [float] NULL,
	[MAT33] [float] NULL,
	[MAT34] [float] NULL,
	[MAT35] [float] NULL,
	[MAT36] [float] NULL,
	[MAT37] [float] NULL,
	[MAT38] [float] NULL,
	[MAT39] [float] NULL,
	[MAT40] [float] NULL,
	[MAT41] [float] NULL,
	[MAT42] [float] NULL,
	[MAT43] [float] NULL,
	[MAT44] [float] NULL,
	[MAT45] [float] NULL,
	[MAT46] [float] NULL,
	[MAT47] [float] NULL,
	[MAT48] [float] NULL,
	[YTD00] [float] NULL,
	[YTD01] [float] NULL,
	[YTD02] [float] NULL,
	[YTD03] [float] NULL,
	[YTD04] [float] NULL,
	[YTD05] [float] NULL,
	[YTD06] [float] NULL,
	[YTD07] [float] NULL,
	[YTD08] [float] NULL,
	[YTD09] [float] NULL,
	[YTD10] [float] NULL,
	[YTD11] [float] NULL,
	[YTD12] [float] NULL,
	[YTD13] [float] NULL,
	[YTD14] [float] NULL,
	[YTD15] [float] NULL,
	[YTD16] [float] NULL,
	[YTD17] [float] NULL,
	[YTD18] [float] NULL,
	[YTD19] [float] NULL,
	[YTD20] [float] NULL,
	[YTD21] [float] NULL,
	[YTD22] [float] NULL,
	[YTD23] [float] NULL,
	[YTD24] [float] NULL,
	[YTD25] [float] NULL,
	[YTD26] [float] NULL,
	[YTD27] [float] NULL,
	[YTD28] [float] NULL,
	[YTD29] [float] NULL,
	[YTD30] [float] NULL,
	[YTD31] [float] NULL,
	[YTD32] [float] NULL,
	[YTD33] [float] NULL,
	[YTD34] [float] NULL,
	[YTD35] [float] NULL,
	[YTD36] [float] NULL,
	[YTD37] [float] NULL,
	[YTD38] [float] NULL,
	[YTD39] [float] NULL,
	[YTD40] [float] NULL,
	[YTD41] [float] NULL,
	[YTD42] [float] NULL,
	[YTD43] [float] NULL,
	[YTD44] [float] NULL,
	[YTD45] [float] NULL,
	[YTD46] [float] NULL,
	[YTD47] [float] NULL,
	[YTD48] [float] NULL,
	--[YTD49] [float] NULL,
	--[YTD50] [float] NULL,
	--[YTD51] [float] NULL,
	--[YTD52] [float] NULL,
	--[YTD53] [float] NULL,
	--[YTD54] [float] NULL,
	--[YTD55] [float] NULL,
	--[YTD56] [float] NULL,
	--[YTD57] [float] NULL,
	--[YTD58] [float] NULL,
	--[YTD59] [float] NULL,
	--[YTD60] [float] NULL,
	[Qtr00] [float] NULL,
	[Qtr01] [float] NULL,
	[Qtr02] [float] NULL,
	[Qtr03] [float] NULL,
	[Qtr04] [float] NULL,
	[Qtr05] [float] NULL,
	[Qtr06] [float] NULL,
	[Qtr07] [float] NULL,
	[Qtr08] [float] NULL,
	[Qtr09] [float] NULL,
	[Qtr10] [float] NULL,
	[Qtr11] [float] NULL,
	[Qtr12] [float] NULL,
	[Qtr13] [float] NULL,
	[Qtr14] [float] NULL,
	[Qtr15] [float] NULL,
	[Qtr16] [float] NULL,
	[Qtr17] [float] NULL,
	[Qtr18] [float] NULL,
	[Qtr19] [float] NULL
) ON [PRIMARY]
GO


/****** Object:  Table [dbo].[OUT_C160_RegionData]    Script Date: 07/18/2013 13:39:23 ******/
if object_id(N'OUT_C160_RegionData', N'U') is not null
  drop table OUT_C160_RegionData
go
CREATE TABLE [dbo].[OUT_C160_RegionData](
	[mkt] [varchar](50) NULL,
	[mktname] [varchar](50) NULL,
	[Market] [varchar](50) NULL,
	[prod] [varchar](200) NULL,
	[Productname] [varchar](200) NULL,
	[Moneytype] [varchar](50) NOT NULL,
	[Audi_cod] [varchar](200) NULL,
	[Audi_des] [varchar](200) NULL,
	[Region] [varchar](200) NULL,
	[Period] [nvarchar](10) NOT NULL,
	[Sales] [float] NULL,
	[Share] [float] NULL,
	[Growth] [float] NULL
) ON [PRIMARY]
GO

SET ANSI_PADDING OFF

exec dbo.sp_Log_Event 'Init','CIA','0_1_init.sql','End',null,null