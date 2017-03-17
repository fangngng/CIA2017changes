use BMSChina_ppt_test
go










update tblDates 
	set DateValue = 'MAT 14Q4 to MAT 16Q4'  -- todo only changed to new quarter when last month of a quarter
where dateSource = 'CPAMATQuarterDate'
go

declare @mth varchar(10),@PrevMth varchar(10), @val varchar(30)

select @mth = left(dt,3) + '''' + right(dt,2) ,
	@PrevMth = left(prevdt,3) + '''' + right(prevdt,2)
from(
select convert(varchar(20),convert(datetime,value2,112),107) dt,
	convert(varchar(20),dateadd(year,-2,convert(datetime,value2,112)),107) PrevDT
from db4.BMSChinaMRBI_test.dbo.tbldsdates where item = 'cpa'
) a
select @val = 'MAT ' + @prevMth + ' to MAT ' + @mth 

update tblDates  set DateValue =  @val where dateSource = 'CPAMATDate'
go


--update tblDates set DateValue = 'Mar''12' where DateSource = 'HKAPITime'

declare @mth varchar(10)

select @mth = left(dt,3) + '''' + right(dt,2) from(
	select convert(varchar(20),convert(datetime,value2,112),107) dt 
	from db4.BMSChinaMRBI_test.dbo.tbldsdates where item = 'cpa'
) a

go

declare @mth varchar(10)

select @mth = left(dt,3) + '''' + right(dt,2) from(
	select convert(varchar(20),convert(datetime,value2,112),107) dt 
	from db4.BMSChinaMRBI_test.dbo.tbldsdates where item = 'cpa'
) a

update tblDates set dateValue = @mth
where DateSource = 'CPATime'
go

update tblDates set dateValue = '2014H2 vs. 2013H1' -- todo
where DateSource = 'RxCompareTime'
go


select * from tblDates order by DateValue
go













-----------------------------------------------------------------------------------------------------------------------------
use BMSChina_staging_test
go




select * from tblVersionInfo where [Name] = 'DataMonth'
go






declare @mth varchar(10),@mth2 varchar(10)

select @mth = left(dt,3) + '-' + right(dt,2) from(
	select convert(varchar(20),convert(datetime,Datevalue + '01',112),107) dt 
	from tblDates where dateSource = 'CurrentMonthlyDate'
) a

select @mth2 = Datevalue
from tblDates where dateSource = 'CurrentMonthlyDate' 

update tblVersionInfo set
	CN = N'数据月: ' + left(@mth2,4) + N'年' + right(@mth2,2) + N'月',
	EN = 'Data Month: ' + @mth
where [Name] = 'DataMonth'
go
select * from tblVersionInfo where [Name] = 'DataMonth'
go

--select * from dbo.WebChartExplain where datasource like '%cpa%'
--go

declare @mth varchar(10)

select @mth = left(dt,3) + '''' + right(dt,2) from(
select convert(varchar(20),convert(datetime,value2,112),107) dt 
from db4.BMSChinaMRBI_test.dbo.tbldsdates where item = 'cpa'
) a

update WebChartExplain set 
	DataSource = 'Data Source: CPA/Sea Rainbow/PHA ' + @mth,
	DataSource_CN = 'Data Source: CPA/Sea Rainbow/PHA ' + @mth
where datasource like '%cpa%' and Code not in ('C201','C202')

update WebChartExplain set 
	DataSource = 'Data Source: CPA ' + @mth,
	DataSource_CN = 'Data Source: CPA ' + @mth
where code = 'R480'

update WebChartExplain set 
	DataSource = 'Data Source: CPA/Sea Rainbow/PHA ' + @mth,
	DataSource_CN = 'Data Source: CPA/Sea Rainbow/PHA ' + @mth
where Code = 'C202'
go


update WebChartExplain set 
	DataSource = 'Data Source: Rx Data 2014 H2',-- todo
	DataSource_CN = 'Data Source: Rx Data 2014 H2'--todo
where datasource like '%rx%'
go



-------------------------------------------------------------数据查看：


select * from dbo.WebChartExplain where datasource like '%cpa%'
go

select * from dbo.WebChartExplain where datasource like '%rx%'
GO

select * from dbo.WebChartExplain where datasource like '%IMS%'
GO


select * from dbo.WebChartExplain where datasource like '%HKAPI%'
GO

select 'Finish at',getdate()
go




print 'over!'