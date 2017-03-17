use BMSChinaCIA_IMS_test --db4
GO


print (N'
------------------------------------------------------------------------------------------------------------
9.                                   Slide 10 : inHKAPI_New
------------------------------------------------------------------------------------------------------------
')
if exists (select * from dbo.sysobjects where id = object_id(N'inHKAPI_New') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
    drop table inHKAPI_New
go
select * into inHKAPI_New from BMSChinaOtherDB.dbo.inHKAPI_New
go
update inHKAPI_New
set [Product name]='SPRYCEL' where [Product Name]='SPYCEL'
go
Alter table inHKAPI_New
Add 
    [YTD00LC] float,
    [YTD12LC] float,
    [YTD24LC] float,
    [YTD36LC] float,
    [YTD48LC] float,
    [YTD00US] float,
    [YTD12US] float,
    [YTD24US] float,
    [YTD36US] float,
    [YTD48US] float,
    [LastYear00LC] float,
    [LastYear12LC] float,
    [LastYear00US] float,
    [LastYear12US] float,
    [MAT00LC] float,
    [MAT12LC] float,
    [MAT24LC] float,
    [MAT36LC] float,
    [MAT48LC] float,
    [MAT00US] float,
    [MAT12US] float,
    [MAT24US] float,
    [MAT36US] float,
    [MAT48US] float
go
update inHKAPI_New
set [YTD00LC]=isnull([YTD 16Q4LC],0),--todo
    [YTD12LC]=isnull([YTD 15Q4LC],0),
    [YTD24LC]=isnull([YTD 15Q3LC],0),
    [YTD36LC]=isnull([YTD 15Q2LC],0),
    [YTD48LC]=isnull([YTD 15Q1LC],0),
    [YTD00US]=isnull(1.0*[YTD 16Q4LC]/6.34888,0),
    [YTD12US]=isnull(1.0*[YTD 15Q4LC]/6.34888,0),
    [YTD24US]=isnull(1.0*[YTD 15Q3LC]/6.34888,0),
    [YTD36US]=isnull(1.0*[YTD 15Q2LC]/6.34888,0),
    [YTD48US]=isnull(1.0*[YTD 15Q1LC]/6.34888,0),
    [LastYear00LC]=isnull([YTD 15Q4LC],0),
    [LastYear12LC]=isnull([YTD 14Q4LC],0),
    [LastYear00US]=isnull(1.0*[YTD 15Q4LC]/6.34888,0),
    [LastYear12US]=isnull(1.0*[YTD 14Q4LC]/6.34888,0),
    [MAT00LC]=isnull([16Q3LC],0)+isnull([16Q2LC],0)+isnull([16Q1LC],0)+isnull([16Q4LC],0),
    [MAT12LC]=isnull([15Q3LC],0)+isnull([15Q2LC],0)+isnull([15Q1LC],0)+isnull([15Q4LC],0),
    [MAT24LC]=isnull([14Q3LC],0)+isnull([14Q2LC],0)+isnull([14Q1LC],0)+isnull([14Q4LC],0),
    [MAT36LC]=isnull([13Q3LC],0)+isnull([13Q2LC],0)+isnull([13Q1LC],0)+isnull([13Q4LC],0),
    [MAT48LC]=isnull([12Q3LC],0)+isnull([12Q2LC],0)+isnull([12Q1LC],0)+isnull([12Q4LC],0),    
    [MAT00US]=isnull([16Q3US],0)+isnull([16Q2US],0)+isnull([16Q1US],0)+isnull([16Q4US],0),
    [MAT12US]=isnull([15Q3US],0)+isnull([15Q2US],0)+isnull([15Q1US],0)+isnull([15Q4US],0),
    [MAT24US]=isnull([14Q3US],0)+isnull([14Q2US],0)+isnull([14Q1US],0)+isnull([14Q4US],0),
    [MAT36US]=isnull([13Q3US],0)+isnull([13Q2US],0)+isnull([13Q1US],0)+isnull([13Q4US],0),
    [MAT48US]=isnull([12Q3US],0)+isnull([12Q2US],0)+isnull([12Q1US],0)+isnull([12Q4US],0)
    
    --[MAT00US]=isnull([13Q2US],0)+isnull([13Q1US],0)+isnull([12Q3US],0)+isnull([12Q4US],0),
    --[MAT12US]=isnull([12Q2US],0)+isnull([12Q1US],0)+isnull([11Q3US],0)+isnull([11Q4US],0),
    --[MAT24US]=isnull([11Q2US],0)+isnull([11Q1US],0)+isnull([10Q3US],0)+isnull([10Q4US],0),
    --[MAT36US]=isnull([10Q2US],0)+isnull([10Q1US],0)+isnull([09Q3US],0)+isnull([09Q4US],0),
    --[MAT48US]=isnull([09Q2US],0)+isnull([09Q1US],0)+isnull([08Q3US],0)+isnull([08Q4US],0)



------------------------------------------------------------------------------------------
-- OutputKeyMNCsPerformance_HKAPI
------------------------------------------------------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'OutputKeyMNCsPerformance_HKAPI') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
    drop table OutputKeyMNCsPerformance_HKAPI
go
CREATE TABLE [dbo].[OutputKeyMNCsPerformance_HKAPI](
	[Period] [varchar](20) NULL,
	[MoneyType] [varchar](20) NULL,
	[CurrRank] [int] NOT NULL,
	[PrevRank] [int] NOT NULL,
	[CORP_cod] [varchar](30)  NULL,
	[CORP_des] [varchar](100) NULL,
	[Mat00] [float] NULL,
	[Mat12] [float] NULL,
    [Total] [float] NULL
) ON [PRIMARY]

GO      

--YTD
insert into [OutputKeyMNCsPerformance_HKAPI]
([Period],[MoneyType],[CORP_cod],[CurrRank],[PrevRank],[Mat00],[Mat12])
select top 10 
    'YTD'
    ,'RMB'
    ,[company name]
    ,1
    ,1
    ,sum(isnull([YTD00LC],0))*1000
    ,sum(isnull([YTD12LC],0))*1000
from inHKAPI_New
group by [company name]
order by sum(isnull([YTD00LC],0)) desc
go
if exists(select * from OutputKeyMNCsPerformance_HKAPI 
				  where CORP_Cod like '%BMS%' and Period='YTD' and MoneyType='RMB'
		)
    print 'BMS COPR in Top 10 YTD'
else
    insert into [OutputKeyMNCsPerformance_HKAPI]
        ([Period],[MoneyType],[CORP_cod],[CurrRank],[PrevRank],[Mat00],[Mat12])
    select 'YTD','RMB', [company name],1,1,sum(isnull([YTD00LC],0))*1000,sum(isnull([YTD12LC],0))*1000
    from inHKAPI_New
    where [company name] like '%BMS%'
    group by [company name]
go
update [OutputKeyMNCsPerformance_HKAPI]
set [Total]=B.sales 
from [OutputKeyMNCsPerformance_HKAPI] A ,
    (select sum(isnull([YTD00LC],0))*1000 as sales from inHKAPI_New
    ) B
where A.[Period]='YTD'

go


--MAT
insert into [OutputKeyMNCsPerformance_HKAPI]
([Period],[MoneyType],[CORP_cod],[CurrRank],[PrevRank],[Mat00],[Mat12])
select top 10 
    'MAT'
    ,'RMB'
    ,[company name]
    ,1
    ,1
    ,sum(isnull([MAT00LC],0))*1000
    ,sum(isnull([MAT12LC],0))*1000
from inHKAPI_New
group by [company name]
order by sum(isnull([MAT00LC],0)) desc
go
if exists(select * from OutputKeyMNCsPerformance_HKAPI 
				  where CORP_Cod like '%BMS%' and Period='MAT' and MoneyType='RMB'
		)
    print 'BMS COPR in Top 10 MAT'
else
    insert into [OutputKeyMNCsPerformance_HKAPI]
        ([Period],[MoneyType],[CORP_cod],[CurrRank],[PrevRank],[Mat00],[Mat12])
    select 'MAT','RMB', [company name],1,1,sum(isnull([MAT00LC],0))*1000,sum(isnull([MAT12LC],0))*1000
    from inHKAPI_New
    where [company name] like '%BMS%'
    group by [company name]
go
update [OutputKeyMNCsPerformance_HKAPI]
set [Total]=B.sales 
from [OutputKeyMNCsPerformance_HKAPI] A ,
    (select sum(isnull([MAT00LC],0))*1000 as sales from inHKAPI_New
    ) B
where A.[Period]='MAT'

go


--MQT
declare @MQT00 varchar(10), @MQT12 varchar(10), @sql varchar(max)
set @MQT00 = right((SELECT convert(varchar(10), year) + Quarter FROM dbo.tblMonthList where MonSeq = 1 ), 4) + 'LC'
set @MQT12 = right((SELECT convert(varchar(10), year) + Quarter FROM dbo.tblMonthList where MonSeq = 12 ), 4) + 'LC'

set @sql = '
insert into [OutputKeyMNCsPerformance_HKAPI]
([Period],[MoneyType],[CORP_cod],[CurrRank],[PrevRank],[Mat00],[Mat12])
select top 10 
    ''MQT''
    ,''RMB''
    ,[company name]
    ,1
    ,1
    ,sum(isnull([' + @MQT00 + '],0))*1000
    ,sum(isnull([' + @MQT12 + '],0))*1000
from inHKAPI_New
group by [company name]
order by sum(isnull([' + @MQT00 + '],0)) desc

if exists(select * from OutputKeyMNCsPerformance_HKAPI 
				  where CORP_Cod like ''%BMS%'' and Period=''MQT'' and MoneyType=''RMB''
		)
    print ''BMS COPR in Top 10 MQT''
else
    insert into [OutputKeyMNCsPerformance_HKAPI]
        ([Period],[MoneyType],[CORP_cod],[CurrRank],[PrevRank],[Mat00],[Mat12])
    select ''MQT'',''RMB'', [company name],1,1,sum(isnull([' + @MQT00 + '],0))*1000,sum(isnull([' + @MQT12 + '],0))*1000
    from inHKAPI_New
    where [company name] like ''%BMS%''
    group by [company name]

update [OutputKeyMNCsPerformance_HKAPI]
set [Total]=B.sales 
from [OutputKeyMNCsPerformance_HKAPI] A ,
    (select sum(isnull([' + @MQT00 + '],0))*1000 as sales from inHKAPI_New
    ) B
where A.[Period]=''MQT''
'
print @sql 
exec(@sql)

go


--Last Year
insert into [OutputKeyMNCsPerformance_HKAPI]([Period],[MoneyType],[CORP_cod],[CurrRank],[PrevRank],[Mat00],[Mat12])
select top 10 
    'Last Year'
    ,'RMB'
    ,[company name]
    ,1
    ,1
    ,sum(isnull([LastYear00LC],0))*1000  --Mat00:  [LastYear00LC]=isnull([12Q1LC],0)
    ,sum(isnull([LastYear12LC],0))*1000  --Mat12�� [LastYear12LC]=isnull([11Q1LC],0)
from inHKAPI_New
group by [company name]
order by sum(isnull([LastYear00LC],0)) desc
go

if exists(
    select * from OutputKeyMNCsPerformance_HKAPI 
    where CORP_Cod like '%BMS%' and Period='Last Year' and MoneyType='RMB'
)
    print 'BMS COPR in Top 10 LastYear'
else
    insert into [OutputKeyMNCsPerformance_HKAPI]([Period],[MoneyType],[CORP_cod],[CurrRank],[PrevRank],[Mat00],[Mat12])

select 
    'Last Year'
    ,'RMB'
    ,[company name]
    ,1
    ,1
    ,sum(isnull([LastYear00LC],0))*1000
    ,sum(isnull([LastYear12LC],0))*1000
from inHKAPI_New
where [company name] like '%BMS%'
group by [company name]
go

update [OutputKeyMNCsPerformance_HKAPI]
set [Total]=B.sales 
from [OutputKeyMNCsPerformance_HKAPI] A ,
    (select sum(isnull([LastYear00LC],0))*1000 as sales from inHKAPI_New) B
where A.[Period]='Last Year'
go

update OutputKeyMNCsPerformance_HKAPI
set CurrRank=B.rank
from OutputKeyMNCsPerformance_HKAPI A 
inner join(
    select Period,Moneytype,corp_cod,RANK ( )OVER (PARTITION BY Period,Moneytype order by Mat00 desc) as Rank
    from OutputKeyMNCsPerformance_HKAPI) B
on A.Period=B.Period and A.Moneytype=B.Moneytype and A.corp_cod=B.corp_cod
go
update OutputKeyMNCsPerformance_HKAPI
set PrevRank=B.rank
from OutputKeyMNCsPerformance_HKAPI A 
inner join(
    select Period,Moneytype,corp_cod,RANK ( )OVER (PARTITION BY Period,Moneytype order by Mat12 desc) as Rank
    from OutputKeyMNCsPerformance_HKAPI) B
on A.Period=B.Period and A.Moneytype=B.Moneytype and A.corp_cod=B.corp_cod
go
Alter table OutputKeyMNCsPerformance_HKAPI Add Share float,ShareTotal float,Mat00Growth float
go
update OutputKeyMNCsPerformance_HKAPI
set Mat00Growth=case Mat12 
                when 0 then case Mat00 
                            when 0 then 0 
                            else null 
                            end 
                else (Mat00-Mat12)*1.0/Mat12 
                end

update OutputKeyMNCsPerformance_HKAPI
set Share=Mat00*1.0/Total


update OutputKeyMNCsPerformance_HKAPI
set ShareTotal=B.ShareTotal 
from OutputKeyMNCsPerformance_HKAPI A 
left join
    (select Period,MoneyType,sum(Mat00)*1.0/Total as ShareTotal
     from OutputKeyMNCsPerformance_HKAPI group by Period,MoneyType,total) B
on A.[Period]=B.[Period] and A.MoneyType=B.MoneyType
go
update OutputKeyMNCsPerformance_HKAPI
set CORP_des= case when B.[Company Name] is null then a.corp_cod else b.[Company Name] end 
from OutputKeyMNCsPerformance_HKAPI A 
left join BMSChinaOtherDB.dbo.HKAPI_CompanyName B
on A.CORP_cod=B.Abbreviation
go
Alter table OutputKeyMNCsPerformance_HKAPI Add ChangeRank int
go
update OutputKeyMNCsPerformance_HKAPI
set ChangeRank=-sign(CurrRank-PrevRank)
go

insert into [OutputKeyMNCsPerformance_HKAPI]
SELECT [Period]
      ,'USD'
      ,[CurrRank]
      ,[PrevRank]
      ,[CORP_cod]
      ,[CORP_des]
      ,[Mat00]/B.Rate
      ,[Mat12]/B.Rate
      ,[Total]/B.Rate
      ,[Share]
      ,[ShareTotal]
      ,[Mat00Growth]
      ,[ChangeRank]
  FROM [dbo].[OutputKeyMNCsPerformance_HKAPI] A, tblRate B
go
update [OutputKeyMNCsPerformance_HKAPI]
set corp_des=B.newname from [OutputKeyMNCsPerformance_HKAPI] A inner join tblTextNameRef B
on A.corp_des=B.oldname
go
--select * from [OutputKeyMNCsPerformance_HKAPI]





print (N'
------------------------------------------------------------------------------------------------------------
10.                                   Slide 11 : OutputKeyMNCsProdPerformance_HKAPI
------------------------------------------------------------------------------------------------------------
')
if exists (select * from dbo.sysobjects where id = object_id(N'OutputKeyMNCsProdPerformance_HKAPI') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table OutputKeyMNCsProdPerformance_HKAPI
go
CREATE TABLE [dbo].[OutputKeyMNCsProdPerformance_HKAPI](
	[Period] [varchar](20)  NULL,
	[MoneyType] [varchar](20)  NULL,
	[CurrRank] [int] NOT NULL,
	[PrevRank] [int] NOT NULL,
	[Prod_cod] [varchar](50) NULL,
	[Prod_des] [varchar](100)  NULL,
	[Mat00] [float] NULL,
	[Mat12] [float] NULL,
    [Total] [float] NULL
) ON [PRIMARY]

GO
--select [Product name], from BMSChinaOtherDB.dbo.HKAPI_2011Q3

insert into [OutputKeyMNCsProdPerformance_HKAPI]
    ([Period],[MoneyType],[Prod_cod],[CurrRank],[PrevRank],[Mat00],[Mat12])
select top 10 'YTD','RMB', [Product name],1,1,sum(isnull([YTD00LC],0))*1000,sum(isnull([YTD12LC],0))*1000
from inHKAPI_New
where [Company name] in (select CORP_Cod from OutputKeyMNCsPerformance_HKAPI where Period='YTD')
group by [Product name]
order by sum(isnull([YTD00LC],0)) desc
go
if exists(  select * 
            from [OutputKeyMNCsProdPerformance_HKAPI] 
			where Prod_Cod like '%Bara%' and Period='YTD' and MoneyType='RMB'
		)
print 'BARACLUDE Prod in Top 10 YTD'
else
insert into [OutputKeyMNCsProdPerformance_HKAPI]
    ([Period],[MoneyType],[Prod_cod],[CurrRank],[PrevRank],[Mat00],[Mat12])
select 'YTD','RMB', [Product name],1,1,sum(isnull([YTD00LC],0))*1000,sum(isnull([YTD12LC],0))*1000
from inHKAPI_New
where  [Product name] like '%Bara%'
group by [Product name]
go
update [OutputKeyMNCsProdPerformance_HKAPI]
set [Total]=B.sales from [OutputKeyMNCsProdPerformance_HKAPI] A ,
(   select sum(isnull([YTD00LC],0))*1000 as sales
    from inHKAPI_New
    where [Company name] in (select CORP_Cod from OutputKeyMNCsPerformance_HKAPI where Period='YTD')
) B
where A.[Period]='YTD'

-- MAT
insert into [OutputKeyMNCsProdPerformance_HKAPI]
    ([Period],[MoneyType],[Prod_cod],[CurrRank],[PrevRank],[Mat00],[Mat12])
select top 10 'MAT','RMB', [Product name],1,1,sum(isnull([MAT00LC],0))*1000,sum(isnull([MAT12LC],0))*1000
from inHKAPI_New
where [Company name] in (select CORP_Cod from OutputKeyMNCsPerformance_HKAPI where Period='MAT')
group by [Product name]
order by sum(isnull([MAT00LC],0)) desc
go
if exists(  select * 
            from [OutputKeyMNCsProdPerformance_HKAPI] 
			where Prod_Cod like '%Bara%' and Period='MAT' and MoneyType='RMB'
		)
print 'BARACLUDE Prod in Top 10 MAT'
else
insert into [OutputKeyMNCsProdPerformance_HKAPI]
    ([Period],[MoneyType],[Prod_cod],[CurrRank],[PrevRank],[Mat00],[Mat12])
select 'MAT','RMB', [Product name],1,1,sum(isnull([MAT00LC],0))*1000,sum(isnull([MAT12LC],0))*1000
from inHKAPI_New
where  [Product name] like '%Bara%'
group by [Product name]
go
update [OutputKeyMNCsProdPerformance_HKAPI]
set [Total]=B.sales from [OutputKeyMNCsProdPerformance_HKAPI] A ,
(   select sum(isnull([MAT00LC],0))*1000 as sales
    from inHKAPI_New
    where [Company name] in (select CORP_Cod from OutputKeyMNCsPerformance_HKAPI where Period='MAT')
) B
where A.[Period]='MAT'


--MQT
declare @MQT00 varchar(10), @MQT12 varchar(10), @sql varchar(max)
set @MQT00 = right((SELECT convert(varchar(10), year) + Quarter FROM dbo.tblMonthList where MonSeq = 1 ), 4) + 'LC'
set @MQT12 = right((SELECT convert(varchar(10), year) + Quarter FROM dbo.tblMonthList where MonSeq = 12 ), 4) + 'LC'

set @sql = '
insert into [OutputKeyMNCsProdPerformance_HKAPI]
    ([Period],[MoneyType],[Prod_cod],[CurrRank],[PrevRank],[Mat00],[Mat12])
select top 10 ''MQT'',''RMB'', [Product name],1,1,sum(isnull([' + @MQT00 + '],0))*1000,sum(isnull([' + @MQT12 + '],0))*1000
from inHKAPI_New
where [Company name] in (select CORP_Cod from OutputKeyMNCsPerformance_HKAPI where Period=''MQT'')
group by [Product name]
order by sum(isnull([' + @MQT00 + '],0)) desc

if exists(  select * 
            from [OutputKeyMNCsProdPerformance_HKAPI] 
			where Prod_Cod like ''%Bara%'' and Period=''MQT'' and MoneyType=''RMB''
		)
    print ''BARACLUDE Prod in Top 10 MQT''
else
    insert into [OutputKeyMNCsProdPerformance_HKAPI]
        ([Period],[MoneyType],[Prod_cod],[CurrRank],[PrevRank],[Mat00],[Mat12])
    select ''MQT'',''RMB'', [Product name],1,1,sum(isnull([' + @MQT00 + '],0))*1000,sum(isnull([' + @MQT12 + '],0))*1000
    from inHKAPI_New
    where  [Product name] like ''%Bara%''
    group by [Product name]

update [OutputKeyMNCsProdPerformance_HKAPI]
set [Total]=B.sales from [OutputKeyMNCsProdPerformance_HKAPI] A ,
(   select sum(isnull([' + @MQT00 + '],0))*1000 as sales
    from inHKAPI_New
    where [Company name] in (select CORP_Cod from OutputKeyMNCsPerformance_HKAPI where Period=''MQT'')
) B
where A.[Period]=''MQT''
'
print @sql 
exec(@sql)



--Last Year
insert into [OutputKeyMNCsProdPerformance_HKAPI]
    ([Period],[MoneyType],[Prod_cod],[CurrRank],[PrevRank],[Mat00],[Mat12])
select top 10 'Last Year','RMB', [Product name],1,1,sum(isnull([LastYear00LC],0))*1000,sum(isnull([LastYear12LC],0))*1000
from inHKAPI_New
where [Company name] in (select CORP_Cod from OutputKeyMNCsPerformance_HKAPI where Period='Last Year')
group by [Product name]
order by sum(isnull([LastYear00LC],0)) desc
go
if exists(select * from [OutputKeyMNCsProdPerformance_HKAPI] 
				  where Prod_Cod like '%Bara%' and Period='Last Year' and MoneyType='RMB'
		)
print 'BARACLUDE Prod in Top 10 LastYear'
else
insert into [OutputKeyMNCsProdPerformance_HKAPI]
    ([Period],[MoneyType],[Prod_cod],[CurrRank],[PrevRank],[Mat00],[Mat12])
select 'Last Year','RMB', [Product name],1,1,sum(isnull([LastYear00LC],0))*1000,sum(isnull([LastYear12LC],0))*1000
from inHKAPI_New
where  [Product name] like '%Bara%'
group by [Product name]
go
update [OutputKeyMNCsProdPerformance_HKAPI]
set [Total]=B.sales from [OutputKeyMNCsProdPerformance_HKAPI] A ,
(select sum(isnull([LastYear00LC],0))*1000 as sales
from inHKAPI_New
where [Company name] in (select CORP_Cod from OutputKeyMNCsPerformance_HKAPI where Period='Last Year')
) B
where A.[Period]='Last Year'
go
update [OutputKeyMNCsProdPerformance_HKAPI]
set CurrRank=B.rank
from [OutputKeyMNCsProdPerformance_HKAPI] A 
inner join(
    select Period,Moneytype,Prod_cod,RANK ( )OVER (PARTITION BY Period,Moneytype order by Mat00 desc) as Rank
    from [OutputKeyMNCsProdPerformance_HKAPI]) B
on A.Period=B.Period and A.Moneytype=B.Moneytype and A.Prod_cod=B.Prod_cod
go
update [OutputKeyMNCsProdPerformance_HKAPI]
set PrevRank=B.rank
from [OutputKeyMNCsProdPerformance_HKAPI] A 
inner join(
    select Period,Moneytype,Prod_cod,RANK ( )OVER (PARTITION BY Period,Moneytype order by Mat12 desc) as Rank
    from [OutputKeyMNCsProdPerformance_HKAPI]) B
on A.Period=B.Period and A.Moneytype=B.Moneytype and A.Prod_cod=B.Prod_cod

go
Alter table [OutputKeyMNCsProdPerformance_HKAPI] Add Share float,ShareTotal float,Mat00Growth float
go
update [OutputKeyMNCsProdPerformance_HKAPI]
set Mat00Growth=case Mat12 when 0 then case Mat00 when 0 then 0 else null end else (Mat00-Mat12)*1.0/Mat12 end

update [OutputKeyMNCsProdPerformance_HKAPI]
set Share=Mat00*1.0/Total


update [OutputKeyMNCsProdPerformance_HKAPI]
set ShareTotal=B.ShareTotal from [OutputKeyMNCsProdPerformance_HKAPI] A 
left join
    (select Period,MoneyType,sum(Mat00)*1.0/Total as ShareTotal
     from [OutputKeyMNCsProdPerformance_HKAPI] group by Period,MoneyType,total) B
on A.[Period]=B.[Period] and A.MoneyType=B.MoneyType
go
update [OutputKeyMNCsProdPerformance_HKAPI]
set Prod_des=Prod_cod
go
Alter table [OutputKeyMNCsProdPerformance_HKAPI] Add ChangeRank int
go
update [OutputKeyMNCsProdPerformance_HKAPI]
set ChangeRank=-sign(CurrRank-PrevRank)
go
insert into [OutputKeyMNCsProdPerformance_HKAPI]
SELECT [Period]
      ,'USD'
      ,[CurrRank]
      ,[PrevRank]
      ,[Prod_cod]
      ,[Prod_des]
      ,[Mat00]/B.Rate
      ,[Mat12]/B.Rate
      ,[Total]/B.Rate
      ,[Share]
      ,[ShareTotal]
      ,[Mat00Growth]
      ,[ChangeRank]
  FROM [dbo].[OutputKeyMNCsProdPerformance_HKAPI] A, tblRate B
go
update [OutputKeyMNCsProdPerformance_HKAPI]
set Prod_des=B.newname from [OutputKeyMNCsProdPerformance_HKAPI] A inner join tblTextNameRef B
on A.Prod_des=B.oldname
go
--select  * from [OutputKeyMNCsProdPerformance_HKAPI]

--select * from [OutputKeyMNCsPerformance_HKAPI]





--UPDATE OutputPreCityPerformance2
--SET PRODUCTNAME=PRODUCTNAME+' Generics'WHERE MOLECULE='Y'
GO
if exists (select * from dbo.sysobjects where id = object_id(N'OutputPreHKAPIBrandPerformance') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table OutputPreHKAPIBrandPerformance
go
select 'YTD' as Period,'RMB' as Moneytype,B.Mkt as Market,B.MKt,B.MktName,B.prod,B.productname,
sum(isnull([YTD00LC],0))*1000 as YTD00,sum(isnull([YTD12LC],0))*1000 as YTD12
into OutputPreHKAPIBrandPerformance
from inHKAPI_New A 
inner join (select distinct mkt,mktname,Prod,Productname from tblMktDef_MRBIChina) B
on A.[Product Name]=B.productname
where B.mkt not in ('ACE','DPP4')
group by B.Mkt,B.MktName,B.prod,B.productname
go
alter table OutputPreHKAPIBrandPerformance
add Growth float null
go

update OutputPreHKAPIBrandPerformance
set Growth=case YTD12 when 0 then case YTD00 when 0 then 0 else null end else (YTD00-YTD12)*1.0/YTD12 end
go
update OutputPreHKAPIBrandPerformance
set Market=
case market when 'ACE' then 'Monopril' 
            when 'ARV' then 'Baraclude' 
            when 'NIAD' then 'Glucophage'
            when 'ONCFCS' then 'Taxol'
            when 'HYP' then 'Monopril' 
            when 'DPP4' then 'Onglyza' 
			when 'Platinum' then 'Paraplatin'
			when 'CCB' then 'Coniel'
			else market end
go
alter table OutputPreHKAPIBrandPerformance
add CurrRank int
go
update OutputPreHKAPIBrandPerformance
set CurrRank=B.Rank from OutputPreHKAPIBrandPerformance A inner join
(select A.*, RANK ( )OVER (PARTITION BY Period,MoneyType,mkt,Market order by YTD00 desc ) as Rank 
 from OutputPreHKAPIBrandPerformance A) B
on A.Market=B.Market and A.[mkt]=B.[mkt] and A.MoneyType=B.MoneyType and A.period=B.period and A.[productname]=B.[productname]
go

insert into OutputPreHKAPIBrandPerformance
select Period,'USD',Market,mkt,MktName,Prod,Productname,YTD00*1.0/B.Rate,YTD12*1.0/B.Rate,Growth,CurrRank
from OutputPreHKAPIBrandPerformance, tblRate B

go


------------------------------------------------------------------------
-- OutputCMLChina_HKAPI
------------------------------------------------------------------------
--00 newest quarter
if exists (select * from dbo.sysobjects where id = object_id(N'OutputCMLChina_HKAPI') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
    drop table OutputCMLChina_HKAPI
go
-- MAT 
select 'Sprycel' as Market,'MAT' as Period,[Product Name] as Product,cast(1 as int) as ProdIdx,'USD' as Moneytype
    ,sum(MAT00US)*1000 as MAT00
    ,sum(MAT12US)*1000 as MAT12
    ,sum(MAT24US)*1000 as MAT24
    ,sum(MAT36US)*1000 as MAT36
    ,sum(MAT48US)*1000 as MAT48
    ,sum([15Q4US])*1000 as Qtr04--todo
    ,sum([16Q1US])*1000 as Qtr03
    ,sum([16Q2US])*1000 as Qtr02
    ,sum([16Q3US])*1000 as Qtr01
    ,sum([16Q4US])*1000 as Qtr00
    ,cast(0 as float) as Growth
into OutputCMLChina_HKAPI 
from inHKAPI_New 
where [Product Name] like '%spycel%' or  [Product Name] in(select distinct Prod_name from tblMktDef_MRBIChina where mkt='CML')
group by [Product Name]

-- MQT 
declare @MQT00 varchar(10), @MQT12 varchar(10), @MQT24 varchar(10), @MQT36 varchar(10), @MQT48 varchar(10), 
    @sql varchar(max)
set @MQT00 = right((SELECT convert(varchar(10), year) + Quarter FROM dbo.tblMonthList where MonSeq = 1 ), 4) + 'US'
set @MQT12 = right((SELECT convert(varchar(10), year) + Quarter FROM dbo.tblMonthList where MonSeq = 12 ), 4) + 'US'
set @MQT24 = right((SELECT convert(varchar(10), year) + Quarter FROM dbo.tblMonthList where MonSeq = 24 ), 4) + 'US'
set @MQT36 = right((SELECT convert(varchar(10), year) + Quarter FROM dbo.tblMonthList where MonSeq = 36 ), 4) + 'US'
set @MQT48 = right((SELECT convert(varchar(10), year) + Quarter FROM dbo.tblMonthList where MonSeq = 48 ), 4) + 'US'

set @sql = '
insert into OutputCMLChina_HKAPI
select ''Sprycel'' as Market,''MQT'' as Period,[Product Name] as Product,cast(1 as int) as ProdIdx,''USD'' as Moneytype
    ,sum([' + @MQT00 + '])*1000 as MQT00
    ,sum([' + @MQT12 + '])*1000 as MQT12
    ,sum([' + @MQT24 + '])*1000 as MQT24
    ,sum([' + @MQT36 + '])*1000 as MQT36
    ,sum([' + @MQT48 + '])*1000 as MQT48
    ,sum([15Q4US])*1000 as Qtr04--todo
    ,sum([16Q1US])*1000 as Qtr03
    ,sum([16Q2US])*1000 as Qtr02
    ,sum([16Q3US])*1000 as Qtr01
    ,sum([16Q4US])*1000 as Qtr00
    ,cast(0 as float) as Growth
from inHKAPI_New 
where [Product Name] like ''%spycel%'' or  [Product Name] in(select distinct Prod_name from tblMktDef_MRBIChina where mkt=''CML'')
group by [Product Name]
'
print @sql 
exec(@sql)


-- YTD 
insert into OutputCMLChina_HKAPI
select 'Sprycel' as Market,'YTD' as Period,[Product Name] as Product,cast(1 as int) as ProdIdx,'USD' as Moneytype
    ,sum(YTD00US)*1000 as YTD00
    ,sum(YTD12US)*1000 as YTD12
    ,sum(YTD24US)*1000 as YTD24
    ,sum(YTD36US)*1000 as YTD36
    ,sum(YTD48US)*1000 as YTD48
    ,sum([15Q4US])*1000 as Qtr04--todo
    ,sum([16Q1US])*1000 as Qtr03
    ,sum([16Q2US])*1000 as Qtr02
    ,sum([16Q3US])*1000 as Qtr01
    ,sum([16Q4US])*1000 as Qtr00
    ,cast(0 as float) as Growth
from inHKAPI_New 
where [Product Name] like '%spycel%' or  [Product Name] in(select distinct Prod_name from tblMktDef_MRBIChina where mkt='CML')
group by [Product Name]

go
-- MAT 
insert into OutputCMLChina_HKAPI
select 'Sprycel','MAT',[Product Name] as Product,1,'RMB' as Moneytype
    ,sum(MAT00LC)*1000 as MAT00
    ,sum(MAT12LC)*1000 as MAT12
    ,sum(MAT24LC)*1000 as MAT24
    ,sum(MAT36LC)*1000 as MAT36
    ,sum(MAT48LC)*1000 as MAT48
    ,sum([15Q4LC])*1000 as Qtr04
    ,sum([16Q1LC])*1000 as Qtr03
    ,sum([16Q2LC])*1000 as Qtr02
    ,sum([16Q3LC])*1000 as Qtr01
    ,sum([16Q4LC])*1000 as Qtr00--todo
    ,cast(0 as float) as Growth
from inHKAPI_New 
where [Product Name] like '%spycel%' or  [Product Name] in(select distinct Prod_name from tblMktDef_MRBIChina where mkt='CML')
group by [Product Name]

-- MQT 
declare @MQT00 varchar(10), @MQT12 varchar(10), @MQT24 varchar(10), @MQT36 varchar(10), @MQT48 varchar(10), 
    @sql varchar(max)
set @MQT00 = right((SELECT convert(varchar(10), year) + Quarter FROM dbo.tblMonthList where MonSeq = 1 ), 4) + 'LC'
set @MQT12 = right((SELECT convert(varchar(10), year) + Quarter FROM dbo.tblMonthList where MonSeq = 12 ), 4) + 'LC'
set @MQT24 = right((SELECT convert(varchar(10), year) + Quarter FROM dbo.tblMonthList where MonSeq = 24 ), 4) + 'LC'
set @MQT36 = right((SELECT convert(varchar(10), year) + Quarter FROM dbo.tblMonthList where MonSeq = 36 ), 4) + 'LC'
set @MQT48 = right((SELECT convert(varchar(10), year) + Quarter FROM dbo.tblMonthList where MonSeq = 48 ), 4) + 'LC'

set @sql = '
insert into OutputCMLChina_HKAPI
select ''Sprycel'',''MQT'',[Product Name] as Product,1,''RMB'' as Moneytype
    ,sum([' + @MQT00 + '])*1000 as MQT00
    ,sum([' + @MQT12 + '])*1000 as MQT12
    ,sum([' + @MQT24 + '])*1000 as MQT24
    ,sum([' + @MQT36 + '])*1000 as MQT36
    ,sum([' + @MQT48 + '])*1000 as MQT48
    ,sum([15Q4LC])*1000 as Qtr04
    ,sum([16Q1LC])*1000 as Qtr03
    ,sum([16Q2LC])*1000 as Qtr02
    ,sum([16Q3LC])*1000 as Qtr01
    ,sum([16Q4LC])*1000 as Qtr00--todo
    ,cast(0 as float) as Growth
from inHKAPI_New 
where [Product Name] like ''%spycel%'' or  [Product Name] in(select distinct Prod_name from tblMktDef_MRBIChina where mkt=''CML'')
group by [Product Name]
'
print @sql 
exec(@sql)
-- YTD 
insert into OutputCMLChina_HKAPI
select 'Sprycel','YTD',[Product Name] as Product,1,'RMB' as Moneytype
    ,sum(YTD00LC)*1000 as YTD00
    ,sum(YTD12LC)*1000 as YTD12
    ,sum(YTD24LC)*1000 as YTD24
    ,sum(YTD36LC)*1000 as YTD36
    ,sum(YTD48LC)*1000 as YTD48
    ,sum([15Q4LC])*1000 as Qtr04
    ,sum([16Q1LC])*1000 as Qtr03
    ,sum([16Q2LC])*1000 as Qtr02
    ,sum([16Q3LC])*1000 as Qtr01
    ,sum([16Q4LC])*1000 as Qtr00--todo
    ,cast(0 as float) as Growth
from inHKAPI_New 
where [Product Name] like '%spycel%' or  [Product Name] in(select distinct Prod_name from tblMktDef_MRBIChina where mkt='CML')
group by [Product Name]
go
update OutputCMLChina_HKAPI
set Product=replace(Product,'SPYCEL','SPRYCEL')
go
update OutputCMLChina_HKAPI
set ProdIdx=case Product when 'GLIVEC' then 1 when 'SPRYCEL' then 2 when 'TASIGNA' then 3 else 10 end
go
update OutputCMLChina_HKAPI
set Growth=case Mat12 when 0 then case Mat00 when 0 then 0 else null end else (Mat00-Mat12)*1.0/Mat12 end
--update OutputCMLChina_HKAPI
--set Product=upper(left(Product,1))+lower(right(Product,len(Product)-1))
--go
