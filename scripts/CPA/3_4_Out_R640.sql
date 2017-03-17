use BMSChinaMRBI_test

exec dbo.sp_Log_Event 'output','CIA_CPA','3_4_Out_R640.sql','Start',null,null

----------------------------
--	CIA-CV Modification Slide 8 : Xiaoyu.Chen 20130905
----------------------------
delete from OutputHospital_All where LinkChartCode = 'R640' and product='Monopril'
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R640',
	  'R640'+ case when [Type] ='TOP100'    then '2'
				   when [Type] ='Region300' then '3'
				   when [Type] ='CHC'  then '1'
				   when [Type] ='Others'    then '4'
				   when [Type] ='Total'     then '5'
			  end as LinkSeriesCode,
	type as Series,

	case when [Type] ='TOP100'    then 2
		 when [Type] ='Region300' then 3
		 when [Type] ='CHC'  then 1
		 when [Type] ='Others'    then 4
		 when [Type] ='Total'     then 5
	end as SeriesIdx,
	'Value' AS Category,
	'Monopril' as Product,
	'Nat' as Lev,
	'China' as Geo,
	'RMB' as Currency,
	'YTD' as TimeFrame,
	case when Productname ='Monopril' and X='hosp_Count' then 'Hosp. # matched with BMS hospital'
		 when Productname ='Monopril' and X='MarketContr' then 'Monopril market Sales contribution'
		 when Productname ='Monopril' and X='ProductMarketShare' then 'Monopril Share'
		 when Productname ='Monopril' and X='ProductMarketGrowth' then 'Monopril GR'
		 when Productname ='Lotensin' and X='ProductMarketShare' then 'Lotensin Share'
		 when Productname ='Lotensin' and X='ProductMarketGrowth' then 'Lotensin GR'
		 when Productname ='Tritace' and X='ProductMarketShare' then 'Tritace Share'
		 when Productname ='Tritace' and X='ProductMarketGrowth' then 'Tritace GR'
		 when Productname ='Acertil' and X='ProductMarketShare' then 'Acertil Share'
		 when Productname ='Acertil' and X='ProductMarketGrowth' then 'Acertil GR'
	end as X,
	case when Productname ='Monopril' and X='hosp_Count' then 1
		 when Productname ='Monopril' and X='MarketContr' then 2
		 when Productname ='Monopril' and X='ProductMarketShare' then 3
		 when Productname ='Monopril' and X='ProductMarketGrowth' then 4
		 when Productname ='Lotensin' and X='ProductMarketShare' then 5
		 when Productname ='Lotensin' and X='ProductMarketGrowth' then 6
		 when Productname ='Tritace' and X='ProductMarketShare' then 7
		 when Productname ='Tritace' and X='ProductMarketGrowth' then 8
		 when Productname ='Acertil' and X='ProductMarketShare' then 9
		 when Productname ='Acertil' and X='ProductMarketGrowth' then 10
	end as XIdx,
	Y as Y,
	'D' as IsShow
from  OutputPerformanceByHosp_CV_Modi_Slide8_Mid

declare @currentMonth varchar(10)
declare @lastMonth varchar(10)
select @currentMonth=value1 from tblDSDates where Item='CPA'
set @lastMonth=convert(varchar(5),convert(int,left(@currentMonth,4))-1)+right(@currentMonth,2)

delete from OutputHospital_All where LinkChartCode = 'R640' and product='Coniel'
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R640' ,
		'R640'+ case when [Type] ='TOP100'    then '2'
					when [Type] ='Region300' then '3'
					when [Type] ='CHC'  then '1'
					when [Type] ='Others'    then '4'
					when [Type] ='Total'     then '5'
				end as LinkSeriesCode,
	[Type] as Series,

	case when [Type] ='TOP100'    then 2
			when [Type] ='Region300' then 3
			when [Type] ='CHC'  then 1
			when [Type] ='Others'    then 4
			when [Type] ='Total'     then 5
	end as SeriesIdx,
	'Value' AS Category,
	'Coniel' as Product,
	'Nat' as Lev,
	'China' as Geo,
	'RMB' as Currency,
	'YTD' as TimeFrame,
		case when Productname ='Coniel' and X='hosp_Count' then 'Hosp. # matched with BMS hospital'
			when Productname ='Coniel' and X='MarketContr' then 'Coniel market Sales contribution'
			when Productname ='Coniel' and X='ProductMarketShare' then 'Coniel Share ' +@currentMonth
			when Productname ='Coniel' and X='ProductMarketGrowth' then 'Coniel GR('+@currentMonth+' vs. '+@lastMonth+')'
			when Productname ='Lacipil' and X='ProductMarketShare' then 'Lacipil Share ' +@currentMonth
			when Productname ='Lacipil' and X='ProductMarketGrowth' then 'Lacipil GR('+@currentMonth+' vs. '+@lastMonth+')'
			when Productname ='Yuan Zhi' and X='ProductMarketShare' then 'Yuan Zhi Share ' +@currentMonth
			when Productname ='Yuan Zhi' and X='ProductMarketGrowth' then 'Yuan Zhi GR('+@currentMonth+' vs. '+@lastMonth+')'
			when Productname ='Zanidip' and X='ProductMarketShare' then 'Zanidip Share ' +@currentMonth
			when Productname ='Zanidip' and X='ProductMarketGrowth' then 'Zanidip GR('+@currentMonth+' vs. '+@lastMonth+')'
		 
			when Productname ='Norvasc' and X='ProductMarketShare' then 'Norvasc Share ' +@currentMonth
			when Productname ='Norvasc' and X='ProductMarketGrowth' then 'Norvasc GR('+@currentMonth+' vs. '+@lastMonth+')'
			when Productname ='Adalat' and X='ProductMarketShare' then 'Adalat Share ' +@currentMonth
			when Productname ='Adalat' and X='ProductMarketGrowth' then 'Adalat GR('+@currentMonth+' vs. '+@lastMonth+')'
			when Productname ='Plendil' and X='ProductMarketShare' then 'Plendil Share ' +@currentMonth
			when Productname ='Plendil' and X='ProductMarketGrowth' then 'Plendil GR('+@currentMonth+' vs. '+@lastMonth+')'
	end as X,
	case when Productname ='Coniel' and X='hosp_Count' then 1
			when Productname ='Coniel' and X='MarketContr' then 2
			when Productname ='Coniel' and X='ProductMarketShare' then 3
			when Productname ='Coniel' and X='ProductMarketGrowth' then 4
			when Productname ='Lacipil' and X='ProductMarketShare' then 5
			when Productname ='Lacipil' and X='ProductMarketGrowth' then 6
			when Productname ='Yuan Zhi' and X='ProductMarketShare' then 7
			when Productname ='Yuan Zhi' and X='ProductMarketGrowth' then 8
			when Productname ='Zanidip' and X='ProductMarketShare' then 9
			when Productname ='Zanidip' and X='ProductMarketGrowth' then 10
		 
			when Productname ='Norvasc' and X='ProductMarketShare' then 11
			when Productname ='Norvasc' and X='ProductMarketGrowth' then 12
			when Productname ='Adalat' and X='ProductMarketShare' then 13
			when Productname ='Adalat' and X='ProductMarketGrowth' then 14
			when Productname ='Plendil' and X='ProductMarketShare' then 15
			when Productname ='Plendil' and X='ProductMarketGrowth' then 16
	end as XIdx,
	case when Y=10000 then null else Y end as Y,
	'D' as IsShow
from OutputPerformanceByHosp_CV_Modi_Slide8_Mid_Coniel

--select * from tblDSDates
GO










--log
insert into Logs 
select 'CPA' as 项目,'2_1_Hospital_Making_Output_R640.sql' as 处理内容,'end' as 标示,getdate() as 时间 

go









GO
if object_id(N'tblMktDefHospital_Eliquis_CPA_R640',N'U') is not null
	drop table tblMktDefHospital_Eliquis_CPA_R640
go

select *
into tblMktDefHospital_Eliquis_CPA_R640
from tblMktDefHospital
where mkt='Eliquis VTEP' and productname in ('Xarelto','Eliquis')

insert into tblMktDefHospital_Eliquis_CPA_R640
select mkt,mktname,'000' as Prod,'Eliquis VTEP Market' as productname,'N' as Molecule,'N' as Class,
	   atc3_cod,atc_cpa,mole_des_cn,mole_Des_En,Prod_des_cn,Prod_des_en,FocusedBrand,IMSMoleCode,IMSProdCode,product,1 as lev
from tblMktDefHospital_Eliquis_CPA_R640 where  productname in ('Xarelto','Eliquis')

--add Eliquis CPA KPIFrame Temp
print('------------------------------------------------------
                   tempHospitalDataByMth_Eliquis_CPA_R640
-------------------------------------------------------------')
if object_id(N'tempHospitalDataByMth_Eliquis_CPA_R640',N'U') is not null
  drop table tempHospitalDataByMth_Eliquis_CPA_R640
GO
--1. CPA :
select 
   'CPA' as DataSource
 , c.Mkt
 , c.Prod
 , a.cpa_id
 , a.Tier
 , convert(varchar(6),convert(Datetime,a.M+'/1/'+Y,101),112) as Mth
 , sum(Value*(case when prod='300' then 0.6 else 1 end))  as Sales
 , sum(Volume*(case when prod='300' then 0.6 else 1 end)) as Units
 , sum(Volume*cast(subString(Specification,1,charindex(' ',Specification)) as float)/AvgPatientMG) as Adjusted_PatientNumber
into tempHospitalDataByMth_Eliquis_CPA_R640
from inCPAData a
inner join tblMktDefHospital_Eliquis_CPA_R640 c                                     
on a.Molecule = c.Mole_Des_CN and a.Product = c.Prod_Des_CN
where exists(
            select * from tblHospitalMaster b 
            where a.cpa_id = b.id and b.DataSource = 'CPA'
            ) and c.prod<>'000'
group by c.Mkt,c.Prod,a.cpa_id, a.Tier,a.M+'/1/'+Y
go
insert into tempHospitalDataByMth_Eliquis_CPA_R640 (DataSource,Mkt,Prod,cpa_id,Tier,Mth,Sales,Units,Adjusted_PatientNumber)
select DataSource,Mkt,'000' as Prod,cpa_id,Tier,Mth,sum(sales) as Sales,sum(units) as Units,sum(Adjusted_PatientNumber) as Adjusted_PatientNumber
from tempHospitalDataByMth_Eliquis_CPA_R640
group by DataSource,Mkt,cpa_id,Tier,Mth

update tempHospitalDataByMth_Eliquis_CPA_R640 set Adjusted_PatientNumber = 0 where Adjusted_PatientNumber is null
GO

--进行行列转置
print('------------------------------------------------------
                   tempHospitalData_Eliquis_CPA_R640
-------------------------------------------------------------')
if object_id(N'tempHospitalData_Eliquis_CPA_R640',N'U') is not null
	drop table tempHospitalData_Eliquis_CPA_R640
go
select distinct DataSource,Mkt,Prod,Cpa_id,Tier
into tempHospitalData_Eliquis_CPA_R640
from tempHospitalDataByMth_Eliquis_CPA_R640
go

create nonclustered index idx on tempHospitalData_Eliquis_CPA_R640(cpa_id)
go

declare @i int, @sql varchar(8000)
set @sql = 'alter table tempHospitalData_Eliquis_CPA_R640 add
'
set @i = 1
while @i <= 36
begin
   set @sql = @sql 
                   + 'UM' + cast(@i as varchar) + ' decimal(22,6) not null default 0,
'
                   + 'VM' + cast(@i as varchar) + ' decimal(22,6) not null default 0,
'
                   + 'PM' + cast(@i as varchar) + ' decimal(22,6) not null default 0,
'
   set @i = @i + 1
end
set @sql = left(@sql,len(@sql)-3)
execute(@sql)
go

declare @i int, @sql varchar(8000), @mth as datetime
set @i = 1
select @mth = convert(DateTime,Value1+'01',112) from tblDSDates where Item='CPA'
while @i <= 36
begin
	set @sql = 
'update tempHospitalData_Eliquis_CPA_R640 set 
 UM' + cast(@i as varchar) + '=b.Units
,VM' + cast(@i as varchar) + '=b.Sales
,PM' + cast(@i as varchar) + '=b.Adjusted_PatientNumber
from tempHospitalData_Eliquis_CPA_R640 a
inner join tempHospitalDataByMth_Eliquis_CPA_R640 b on a.Mkt = b.Mkt and a.Prod = b.Prod and a.cpa_id = b.cpa_id
where b.Mth = (select Mth from tblHospitalMthList where idx = ' + cast(@i as varchar) + ')
'
	exec (@sql)
	set @i = @i + 1
end 
go


  --Rollup到YTD,MAT
alter table tempHospitalData_Eliquis_CPA_R640 add
	UYTD		decimal(22,6),
	UYTDStly	decimal(22,6),
	UMAT1		DECIMAL(22,6),
	UMAT2		DECIMAL(22,6),
	UMAT3		DECIMAL(22,6),

	VYTD		decimal(22,6),
	VYTDStly	decimal(22,6),
	VMAT1		DECIMAL(22,6),
	VMAT2		DECIMAL(22,6),
	VMAT3		DECIMAL(22,6),

	PYTD		decimal(22,6),
	PYTDStly	decimal(22,6),
	PMAT1		DECIMAL(22,6),
	PMAT2		DECIMAL(22,6),
	PMAT3		DECIMAL(22,6)
GO

declare @cnt int, @sql varchar(max)
select @cnt = max(idx) from tblHospitalMthlist where Left(Mth,4) = (select left(Mth,4) from tblHospitalMthList where Idx = 1)
set @sql = '
UPDATE tempHospitalData_Eliquis_CPA_R640 SET
	UYTD = (' + DBO.f_assemble_sum('UM',1, @cnt) + '),
	UYTDSTLY = (' + DBO.f_assemble_sum('UM',1+12, @cnt+12) + '),
	UMAT1 = (' + DBO.f_assemble_sum('UM',1,12) + '),
	UMAT2 = (' + DBO.f_assemble_sum('UM',13,24) + '),
	UMAT3 = (' + DBO.f_assemble_sum('UM',25,36) + '),
	VYTD = (' + DBO.f_assemble_sum('VM',1, @cnt) + '),
	VYTDSTLY = (' + DBO.f_assemble_sum('VM',1+12, @cnt+12) + '),
	VMAT1 = (' + DBO.f_assemble_sum('VM',1,12) + '),
	VMAT2 = (' + DBO.f_assemble_sum('VM',13,24) + '),
	VMAT3 = (' + DBO.f_assemble_sum('VM',25,36) + '),
    PYTD = (' + DBO.f_assemble_sum('PM',1, @cnt) + '),
	PYTDSTLY = (' + DBO.f_assemble_sum('PM',1+12, @cnt+12) + '),
	PMAT1 = (' + DBO.f_assemble_sum('PM',1,12) + '),
	PMAT2 = (' + DBO.f_assemble_sum('PM',13,24) + '),
	PMAT3 = (' + DBO.f_assemble_sum('PM',25,36) + ')
' 
--print @SQL
EXEC  (@SQL)
GO

EXEC P_EXTEND_TABLE 'tempHospitalData_Eliquis_CPA_R640','UR3M',1,24, 'DECIMAL(22,6)'
GO
EXEC P_EXTEND_TABLE 'tempHospitalData_Eliquis_CPA_R640','VR3M',1,24, 'DECIMAL(22,6)'
GO
EXEC P_EXTEND_TABLE 'tempHospitalData_Eliquis_CPA_R640','PR3M',1,24, 'DECIMAL(22,6)'
GO



DECLARE @I INT,@sql varchar(8000)
declare @st int, @ed int
set @i = 1
set @sql = 'update tempHospitalData_Eliquis_CPA_R640 set
'
Set @i = 1
while @i <= 24
begin
	set @sql = @sql + 'UR3M' + cast(@i as varchar) + '=' + dbo.f_assemble_sum('UM',@i,@i+2) + ','
	set @sql = @sql + 'VR3M' + cast(@i as varchar) + '=' + dbo.f_assemble_sum('VM',@i,@i+2) + ','
    set @sql = @sql + 'PR3M' + cast(@i as varchar) + '=' + dbo.f_assemble_sum('PM',@i,@i+2) + ',
'
	set @i = @i + 1
end

SET @SQL = LEFT(@SQL,LEN(@SQL)-3)
EXEC(@SQL)
GO

IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'TempR640_CPAPart') and type='U')
BEGIN
	DROP TABLE TempR640_CPAPart
END


select case when a.DataSource is not null then a.DataSource else 'CPA' end as DataSource ,
	b.Mkt,b.Prod,b.ProductName,a.cpa_id,ISNULL(a.VM1,0) as VM1,ISNULL(a.VM13,0) as VM13,ISNULL(a.UM1,0) as UM1,ISNULL(a.UM13,0) as UM13,
	ISNULL(a.VYTD,0) as VYTD, ISNULL(a.VYTDStly,0) as VYTDStly,ISNULL(a.VR3M1,0) as VR3M1, ISNULL(a.VR3M13,0) as VR3M13,ISNULL(a.UYTD,0) as UYTD,ISNULL(a.UYTDStly,0) as UYTDStly
INTO TempR640_CPAPart
from (
	select * 
	from tempHospitalData_Eliquis_CPA_R640 
	where DataSource='CPA'
)  a  join (
	select distinct mkt,prod,productname 
	from tblMktDefHospital_Eliquis_CPA_R640
) b on a.Mkt=b.Mkt and a.prod=b.prod
	
IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_R640_CPAPart_Eliquis') and type='U')
	DROP TABLE Mid_R640_CPAPart_Eliquis
go

IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Mid_R640_CPAPart_Eliquis_For_Prod') and type='U')
	DROP TABLE Mid_R640_CPAPart_Eliquis_For_Prod
GO


--Eliquis part
	declare @mktEliquis varchar(20)
	set @mktEliquis='Eliquis VTEP'
	--计算所有的医院数=匹配医院个数+未匹配医院个数
	select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
		count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	INTO Mid_R640_CPAPart_Eliquis
	from TempR640_CPAPart a 
	join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id 
	join (	select distinct [cpa code] 
			from BMS_CPA_Hosp_Category 
			where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Eliquis Hospital Category]<>'#N/A'
		 ) c on c.[cpa code]=b.cpa_code
	where mkt=@mktEliquis
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	----计算所有的匹配医院个数
	--INSERT INTO Mid_R640_CPAPart_Eliquis (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	--select convert(varchar(20),'Total Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	--count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	--from TempR640_CPAPart a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id join 
	--	 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Eliquis Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	--where mkt=@mktEliquis
	--group by a.DataSource,a.mkt,a.prod,a.ProductName

	----计算所有的未匹配的医院个数
	--INSERT INTO Mid_R640_CPAPart_Eliquis (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	--select convert(varchar(20),'Non-Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	--count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	--from TempR640_CPAPart a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left join 
	--	 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Eliquis Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	--where mkt=@mktEliquis and c.[cpa code] is null
	--group by a.DataSource,a.mkt,a.prod,a.ProductName

	--计算各个Category匹配上的医院个数
	INSERT INTO Mid_R640_CPAPart_Eliquis (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	  --A,B,C,D tier
	select c.[Eliquis Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
		count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from TempR640_CPAPart a 
	join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id 
	join (	select distinct [cpa code],[Eliquis Hospital Category] 
			from BMS_CPA_Hosp_Category 
			where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Eliquis Hospital Category]<>'#N/A'
		) c 
		on c.[cpa code]=b.cpa_code
	where a.mkt=@mktEliquis	 
	group by c.[Eliquis Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
	go

	--产品在YTD Sales>0的情况下，能匹配到的医院个数
	declare @mktEliquis2 varchar(20)
	set @mktEliquis2='Eliquis VTEP'
	--计算所有的医院数=匹配医院个数+未匹配医院个数
	select convert(varchar(20),'Total') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
		count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	INTO Mid_R640_CPAPart_Eliquis_For_Prod
	from (select * from TempR640_CPAPart where VYTD>0) a 
	join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id  
	join (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Eliquis Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	where mkt=@mktEliquis2
	group by a.DataSource,a.mkt,a.prod,a.ProductName

	----计算所有的匹配医院个数
	--INSERT INTO Mid_R640_CPAPart_Eliquis_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	--select convert(varchar(20),'Total Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	--count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	--from (select * from TempR640_CPAPart where VYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id  join 
	--	 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Eliquis Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	--where mkt=@mktEliquis2
	--group by a.DataSource,a.mkt,a.prod,a.ProductName

	----计算所有的未匹配的医院个数
	--INSERT INTO Mid_R640_CPAPart_Eliquis_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	--select convert(varchar(20),'Non-Targeted') as Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
	--count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	--from (select * from TempR640_CPAPart where VYTD>0) a join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id left  join 
	--	 (select distinct [cpa code] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Eliquis Hospital Category]<>'#N/A') c on c.[cpa code]=b.cpa_code
	--where mkt=@mktEliquis2 and c.[cpa code] is null
	--group by a.DataSource,a.mkt,a.prod,a.ProductName

	----每个Category匹配上的医院个数
	INSERT INTO Mid_R640_CPAPart_Eliquis_For_Prod (Tier,DataSource,mkt,prod,productname,Mapped_Hosp,VYTD,VYTDStly)
	  --A,B,C,D tier
	select c.[Eliquis Hospital Category] as tier,a.DataSource,a.mkt,a.prod,a.ProductName,
		count(distinct cpa_id) AS Mapped_Hosp,sum(VYTD) as VYTD,sum(VYTDStly) as VYTDStly
	from (select * from TempR640_CPAPart where VYTD>0) a 
	join (SELECT DISTINCT id,cpa_code FROM tblHospitalMaster where DataSource='CPA') b on a.cpa_id = b.id 
	join (select distinct [cpa code],[Eliquis Hospital Category] from BMS_CPA_Hosp_Category where [cpa name]<> '#N/A' and [cpa name] is not null and [cpa code] is not null and [Eliquis Hospital Category]<>'#N/A') c 
			on c.[cpa code]=b.cpa_code
	where a.mkt=@mktEliquis2	 
	group by c.[Eliquis Hospital Category] ,a.DataSource,a.mkt,a.prod,a.ProductName
	go





IF EXISTS(SELECT 1 FROM dbo.sysobjects where id=object_id(N'Output_Eliquis_R640_CPAPart') and type='U')
BEGIN
	DROP TABLE Output_Eliquis_R640_CPAPart
END

select Tier,DataSource,mkt,prod,ProductName,y,x
into Output_Eliquis_R640_CPAPart
from (
	select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp, 
	convert(decimal(20,8),case when b.VYTD is null or b.VYTD=0 then 0 else 1.0*a.VYTD/b.VYTD end) as [Market Size],
	convert(decimal(20,8),a.VYTD) as [Market Size Value]
	from (
		select * from  Mid_R640_CPAPart_Eliquis where prod='000'
	  ) a join 
		 (
		select * from  Mid_R640_CPAPart_Eliquis where  prod='000' and Tier ='Total'
	  ) b on a.DataSource=b.DataSource and a.mkt=b.mkt and a.prod=b.prod and a.ProductName=b.ProductName
 ) t1 unpivot (
	Y for X in (Mapped_Hosp,[Market Size],[Market Size Value])
)  t2
union all
select  Tier,DataSource,mkt,prod,ProductName,y,x
from (
	select a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,
		convert(decimal(20,8),case when a.VYTDStly is null or a.VYTDStly=0 then 10000 else 1.0*(a.VYTD-a.VYTDStly)/a.VYTDStly end) as [ProductMarketGrowth],
		convert(decimal(20,8),case when b.VYTD is null or b.VYTD =0 then 0 else 1.0*a.VYTD/b.VYTD end) as [ProductMarketShare]
	from (select * from   Mid_R640_CPAPart_Eliquis ) a join
		(select * from Mid_R640_CPAPart_Eliquis where prod='000') b on a.Tier=b.Tier and a.DataSource=b.DataSource and a.mkt=b.mkt
) t1 unpivot (
	Y for X in ([ProductMarketGrowth],[ProductMarketShare])
)	t2	
union all	
	select Tier,DataSource,mkt,prod,ProductName,y,x
from (
	select * from
	(select  a.Tier,a.DataSource,a.mkt,a.prod,a.ProductName,convert(decimal(20,8), a.Mapped_Hosp) as Mapped_Hosp_Prod
	from Mid_R640_CPAPart_Eliquis_For_Prod a where prod<>'000') b unpivot (
	Y for X in (Mapped_Hosp_Prod)) t
) t2
delete  from Output_Eliquis_R640_CPAPart where mkt='Eliquis VTEP' and productname in ('CLEXANE','ARIXTRA','FRAXIPARINE','ENOXAPARIN SODIUM')
delete from Output_Eliquis_R640_CPAPart where mkt='Eliquis VTEP' and prod='000' and x='ProductMarketShare'

IF EXISTS(select 1 from dbo.sysobjects where id=object_id(N'Output_Eliquis_R640') and type='U')
BEGIN
	DROP TABLE Output_Eliquis_R640
END
declare @CPAMonth varchar(50)
select @CPAMonth=left(A.MonthEN,3) from BMSChinaCIA_IMS.dbo.tblMonthlist a join tblDSDates b on a.Date=b.Value1 
where b.item='CPA'
--select @CPAMonth=Value1 from tblDSDates where Item='CPA'


SELECT 'YTD' AS TimeFrame, 'USD' as MoneyType, 'N' as Molecule,'N' as class,mkt,
	 case when mkt='NIAD'     then 'NIAD Market'
		  when mkt='ARV'      then 'ARV Market'
		  when mkt='HYPFCS'   then 'HYP Market'
		  when mkt='CCB'      then 'CCB Market' 
		  when mkt='Eliquis VTEP'  then 'Eliquis VTEP Market' 
		  when mkt='ONCFCS' then 'Oncology Market' 
		  end as MktName,
	 case when mkt='NIAD'     then 'Glucophage'
		  when mkt='ARV'      then 'Baraclude'
		  when mkt='HYPFCS'   then 'Monopril'
		  when mkt='CCB'      then 'Coniel'
		  when mkt='Eliquis VTEP'  then 'Eliquis VTEP'
		  when mkt='ONCFCS'  then 'Taxol'
		  end as Market,
	 prod,
	case when Tier='2-A' then 'A'
		 when Tier='3-B' then 'B'
		 when Tier='4-C' then 'C'
		 when Tier='6-D' then 'D' 
		 when Tier='1-S' then 'S'
		 else Tier end as Series,
	convert(varchar(50),null) as DataType,convert(varchar(20),null)	as Category,
	case when mkt in('CCB','Eliquis') and y=10000 then null else Y end as Y,
	case when x='Market Size' and mkt='Eliquis VTEP' then 'VTEP Market Contribution'
		 when x='Market Size' then mkt+' Market Contribution'
			when x='Mapped_Hosp' then '# Hospital CPA matched with BMS'
			when x='ProductMarketShare' then ProductName+' Share ('+(
												case when mkt='NIAD' then 'YTD'--'MTH' 
													 when mkt='HYPFCS' then 'YTD'
													 when mkt='DPP4' then 'YTD'-- 'MQT' 
													 when mkt='ARV' then 'YTD'
													 when mkt='CCB' then 'YTD'
													 when mkt='Eliquis VTEP' then 'YTD'
													 when mkt='ONCFCS' then 'YTD'
													 end) +@CPAMonth +')'
			when x='ProductMarketGrowth' then case when ProductName = 'ARV Market' then 'Total'
													when ProductName = 'Monopril Market' then 'Total'
													when ProductName = 'NIAD Market' then 'Total'
													when ProductName = 'CCB Market' then 'Total'
													when ProductName = 'Eliquis VTEP Market' then 'Total'
													when ProductName = 'Taxol Market' then 'Total'
												   else productname end +' GR(Y2Y)'			
			when x='Market Size Volume' then mkt+' Market Size (YTD '+@CPAMonth+' volume)'
			when x='Market Size Value' and mkt='Eliquis VTEP' then 'VTEP Market Size (YTD '+@CPAMonth+' Value)'
			when x='Market Size Value' then mkt+' Market Size (YTD '+@CPAMonth+' Value)'
			when x='Mapped_Hosp_Prod' then ProductName+' listed. #'
	end  as X,
	case when Tier like 'Key%' then 1
		 when Tier like 'Bal%' then 2
		 when Tier like 'Top%' then 2
		 when Tier like 'Region%' then 3
		 when Tier like 'High productivity%' then 4
		 when Tier like 'other%' then 5
		 when Tier='A' then 2
		 when Tier='B' then 3
		 when Tier='C' then 4
		 when Tier='D' then 5 
		 when Tier='2-A' then 2
		 when Tier='3-B' then 3
		 when Tier='4-C' then 4
		 when Tier='6-D' then 5 
		 when Tier IN ('1-S','S') then 1
		 when Tier='Total' then 8
		 when Tier='Total Targeted' then 6
		 when Tier='Non-Targeted ' then 7
	end as Series_Idx,
	case when x='Mapped_Hosp' then 1
			when x='Mapped_Hosp_Prod' and productname in ('Baraclude','Glucophage','Lotensin','Coniel','Xarelto','Taxol') then 2
			when x='Mapped_Hosp_Prod' and productname in ('Heptodin','Glucobay','Monopril','Zanidip','Pradaxa','Taxotere') then 3
			when x='Mapped_Hosp_Prod' and productname in ('Run Zhong','Amaryl','Tritace','Norvasc','Eliquis','Gemzar') then 4
			when x='Mapped_Hosp_Prod' and productname in ('Sebivo','Acertil','Adalat') then 5
			when x='Mapped_Hosp_Prod' and productname in ('Plendil','Tenofovir') then 6
			
			when x='ProductMarketGrowth' and productname in ('ARV Market','NIAD Market','Monopril Market','CCB Market','Eliquis Market','Taxol Market') then 7
			when x='ProductMarketGrowth' and productname in ('Baraclude','Glucophage','Lotensin','Coniel','Xarelto','Taxol') then 8
			when x='ProductMarketGrowth' and productname in ('Heptodin','Glucobay','Monopril','Zanidip','Pradaxa','Taxotere') then 9
			when x='ProductMarketGrowth' and productname in ('Run Zhong','Amaryl','Tritace','Norvasc','Eliquis','Gemzar') then 10
			when x='ProductMarketGrowth' and productname in ('Sebivo','Acertil','Adalat') then 11
			when x='ProductMarketGrowth' and productname in ('Plendil','Tenofovir') then 12
			
			when x='ProductMarketShare' and productname in ('Baraclude','Glucophage','Lotensin','Coniel','Xarelto','Taxol') then 13
			when x='ProductMarketShare' and productname in ('Heptodin','Glucobay','Monopril','Zanidip','Pradaxa','Taxotere') then 14
			when x='ProductMarketShare' and productname in ('Run Zhong','Amaryl','Tritace','Norvasc','Eliquis','Gemzar') then 15
			when x='ProductMarketShare' and productname in ('Sebivo','Acertil','Adalat') then 16
			when x='ProductMarketShare' and productname in ('Plendil','Tenofovir') then 17
			
			when x='Market Size Volume' then 18
			when x='Market Size Value' then 18
			when x='Market Size' then 19						
	end as X_Idx	
into Output_Eliquis_R640
from Output_Eliquis_R640_CPAPart where mkt in ('Eliquis VTEP')


delete from OutputHospital_All where Linkchartcode='R640' and product='Eliquis VTEP'
insert into OutputHospital_All(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev,  Geo, Currency, TimeFrame, X, XIdx, Y,IsShow)
select 'R640' as LinkChartCode,
	'R640' + Case when Series ='Key' then '1'
				  when Series ='Top' then '2'
				  when Series ='Other' then '3'
				  when Series ='Total' then '4' end as LinkSeriesCode,
	Case when Series ='Total' then 'Total'
			  else Series end as Series,
	Case when Series ='Key' then 1
				  when Series ='Top' then 2
				  when Series ='Other' then 3
				  when Series ='Total' then 4 end as SeriesIdx,
	'Value' AS Category,
	'Eliquis VTEP' as Product,
	'Nat' as Lev,
	'China' as Geo,
	'RMB' as Currency,
	'YTD' as TimeFrame,		
	case when x='# Hospital CPA matched with BMS' then 'Hosp. # matched with BMS Hospital'
		 when x='VTEP Market Contribution' then 'VTEP Market Sales Contribution'
		 else rtrim(substring (x,1,charindex('(',x)-1)) end as x,
	case when x='# Hospital CPA matched with BMS' then 1 when x='VTEP Market Contribution' then 2
		 when x like 'Xarelto Share%' then 3 when x like 'Xarelto GR%' then 4
		 when x like 'Pradaxa Share%' then 5 when x like 'Pradaxa GR%' then 6
		 when x like 'Eliquis Share%' then 7 when x like 'Eliquis GR%' then 8 end as XIdx,	
	Y, 'D' as IsShow	 	 
from Output_Eliquis_R640 
where market='Eliquis VTEP' --and Series not in ('Total','Non-Targeted')
and (x like '%GR(%' or x like '%Share (%' 
	or x='# Hospital CPA matched with BMS' or x='VTEP Market Contribution') and x<>'Total GR(Y2Y)'

exec dbo.sp_Log_Event 'output','CIA_CPA','3_4_Out_R640.sql','End',null,null
