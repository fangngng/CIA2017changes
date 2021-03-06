use BMSChinaMRBI
go

--backup
select * into BMSChinaMRBI_Repository.dbo.tblHospitalMaster_2012 from tblHospitalMaster
go


--deal
if object_id(N'tblHospitalMaster',N'U') is not null
	drop table tblHospitalMaster
go
create table tblHospitalMaster(
	id					int not null primary key,
	DataSource			varchar(10),
	CPA_Code			varchar(10),
	New_CPA_Code			varchar(10),
	CPA_Name			nvarchar(255),
	CPA_Name_English	nvarchar(255),
	Tier				varchar(5),
	Province			nvarchar(255),
	City				nvarchar(255),
	city_en				varchar(50),
	IsDuplicated		bit not null default 0,
	BMS_Code			varchar(10),
	BMS_Hosp_Name		nvarchar(225)
)
go
insert into tblHospitalMaster(id,DataSource,CPA_Code,New_CPA_Code,CPA_Name,cpa_Name_english,Tier,Province,City,city_en)
select 
   id
   , source
   ,CPA_Code
   ,CPA_New_Code
   ,CPA_Name
   ,cpa_Name_english
   ,Tier
   ,Province
   , City
   ,city_en
from BMSChinaOtherDB.dbo.tblAllHospital_2014 where source = 'cpa'
go
insert into tblHospitalMaster(id,DataSource,CPA_Name,cpa_Name_english,Tier,Province,City,city_en)
select 
   id
   , source
   ,CPA_Name
   , cpa_Name_english
   ,Tier
   ,Province
   , City
   ,city_en
from BMSChinaOtherDB.dbo.tblAllHospital_2014 a 
where source = 'sea' and not exists(
select *from tblHospitalMaster b where  a.id = b.id)
go

-- 设置某一个医院是否在两个hospital list都存在

update tblHospitalMaster set IsDuplicated = 1
where id in (
	select distinct id
	from BMSChinaOtherDB.dbo.tblAllHospital_2014 a
	inner join BMSChinaOtherDB.dbo.inSeaRainbow_HospitalList_2014 b on a.cpa_Name = b.Hospital_Name
	where a.source = 'cpa' 
)
go
update tblHospitalMaster set IsDuplicated = 1
where id in(
select a.id from BMSChinaOtherDB.dbo.tblAllHospital_2014 a
where a.source = 'cpa' and exists(
select * from BMSChinaOtherDB.dbo.tblAllHospital_2014 b where b.source = 'sea' and a.id = b.id)
) and isDuplicated = 0
go


--用mapping表更新CPA医院的信息
update a
set 
--a.CPA_Name_English= case when b.BMS_Code is null or b.BMS_Code='#N/A' then '' else b.BMS_Code end +a.CPA_Name_English,
	a.BMS_Code=b.BMS_code,
	a.BMS_Hosp_Name=b.BMS_Name
from tblHospitalMaster a 
join (select distinct cpa_code,BMS_Code,BMS_Name from  dbo.CPA_BMS_Mapping_2014) b on a.cpa_code=b.cpa_code
where a.DataSource='CPA' and a.bms_hosp_name is null

--update tblHospitalMaster
--set cpa_code='01001'
--where  cpa_name =N'北京广外社区卫生服务中心'

--select * from tblHospitalMaster where cpa_name =N'北京广外社区卫生服务中心'


--用老的SeaRainbow和BMS的关系表更新SeaRainbow的医院信息
update a 
set 
--a.cpa_name_english = case when b.[BMS Code] is null or b.[BMS Code]='#N/A' then '' else b.[BMS Code] end +a.CPA_Name_English,
	a.BMS_Code=b.[BMS Code],
	a.BMS_Hosp_Name=b.[BMS Name]
from tblHospitalMaster a join dbo.tblHospitalMasterNew_2 b on a.cpa_name=b.[SR name]
where a.DataSource='Sea' and a.BMS_hosp_name is null

update tblHospitalMaster
set BMS_Code='#N/A' where BMS_Code is null

update tblHospitalMaster
set BMS_Hosp_Name='#N/A' where BMS_Hosp_Name is null



drop table OutputHospital
go
/****** Object:  Table [dbo].OutputHospital    Script Date: 11/24/2011 17:47:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].OutputHospital(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LinkChartCode] [varchar](50) NULL,
	[LinkSeriesCode] [varchar](50) NULL,
	[Series] [varchar](100) NULL,
	[SeriesIdx] [int] NOT NULL,
	[Category] [varchar](50) NULL,
	[Product] [varchar](50) NULL,
	[Lev] [varchar](50) NULL,
	[ParentGeo] [varchar](50) NULL,
	[Geo] [varchar](50) NULL,
	[Currency] [varchar](50) NULL,
	[TimeFrame] [varchar](50) NULL,
	[X] [varchar](50) NULL,
	[XIdx] [int] NOT NULL,
	[Y] [varchar](50) NULL,
	[LinkedY] [varchar](200) NULL,
	[Size] [varchar](max) NULL,
	[OtherParameters] [varchar](1000) NULL,
	[Color] [varchar](10) NULL,
	[R] [bigint] NULL,
	[G] [bigint] NULL,
	[B] [bigint] NULL,
	[IsShow] [char](1) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF