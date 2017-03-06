use  BMSChinaMRBI
GO

/*
-----------------------------------------------
--????BMS??CPA???????????BMSCode
-----------------------------------------------

update [in_152hospitalMapping]
set [Hospital Code]='511006',hospital=N'????????????????????????§Ø????????????',[CPA&SR NAME]=N'?????????????????????'
where hospital = N'?????????????????????' and [CPA&SR NAME] =N'???????????????'

*/

--Time:00:07

-- select * from in_152hospitalMapping order by [CPA&SR Name]
-- select * from D_ProductKeyHospitals
exec dbo.sp_Log_Event 'output','CIA_CPA','3_3_Out_R530.sql','Start',null,null

delete from D_ProductKeyHospitals
go
insert into D_ProductKeyHospitals( [Cpa_id],[Hosp_BMSCode],[Hosp_BMSName],[CPA_Name],[isMatching],BuName)
SELECT t2.id
      ,t1.[BMS_Hospital_Code]
      ,convert(varchar(20),t1.[BMS_Hospital_Code])+'-'+t1.[Hospital Name] as [Hosp_BMSName]
      ,t2.CPA_Name
      ,'Y' as IsMatching
      ,t1.BuName
FROM [BMSChinaMRBI].[dbo].inTaxolAndParaplatinKeyHospital t1
inner join tblHospitalMaster t2
on t1.[CPA Name]=t2.CPA_Name
--SELECT t2.id
--      ,t1.[Hospital Code]
--      ,convert(varchar(10),t1.[Hospital Code])+'-'+t1.Hospital as [Hosp_BMSName]
--      ,t2.CPA_Name
--      ,'Y'
--FROM [BMSChinaMRBI].[dbo].[in_152hospitalMapping] t1
--inner join tblHospitalMaster t2
--on t1.[CPA&SR NAME]=t2.CPA_Name

go
insert into D_ProductKeyHospitals( [Cpa_id],[Hosp_BMSCode],[Hosp_BMSName],[CPA_Name] ,[isMatching],BuName)
select null as Cpa_ID,
	   BMS_Hospital_Code,
	   convert(varchar(20),[BMS_Hospital_Code])+'-'+[Hospital Name] as [Hosp_BMSName],
	   case when [CPA Name] is null or [CPA Name]='#N/A' then [Hospital name] else [CPA Name] end as CPA_Name,
	   'N' as IsMatching,
	   BuName
from [BMSChinaMRBI].[dbo].inTaxolAndParaplatinKeyHospital
where [Hospital Name] is null or [Hospital Name] not in (
	select distinct case when Hosp_BMSName like '%-%' then right(Hosp_BMSName,len(Hosp_BMSName)-charindex('-',Hosp_BMSName))
						 else Hosp_BMSName end --,len(Hosp_BMSName),charindex('-',Hosp_BMSName)
	from D_ProductKeyHospitals 
) 

--select null
--      ,[Hospital Code]
--      ,convert(varchar(10),[Hospital Code])+'-'+Hospital as [Hosp_BMSName]
--      ,case when [CPA&SR Name] is null then Hospital else [CPA&SR NAME] end 
--      ,'N'
--from dbo.in_152hospitalMapping 
--where [CPA&SR Name] is null or [CPA&SR Name] not in (
--select distinct CPA_Name from D_ProductKeyHospitals 
--) 
GO





if object_id(N'tblDataMonthConv',N'U') is not null
	drop table tblDataMonthConv
go
CREATE TABLE [dbo].[tblDataMonthConv](
	[Y] [nvarchar](255) NULL,
	[M] [nvarchar](255) NULL,
	[MSeq] [int] NULL,
	[Datamonth] [nvarchar](510) NULL,
	[DM] [varchar](3) NOT NULL
)
go
declare @mth varchar(10), @idx int
select @mth = value1 from tblDSDates where item='CPA'
set @idx = 1
while @idx <= 13
begin
	insert into tblDataMonthConv values(
	  left(@mth,4)
	, cast(right(@mth,2) as int)
	, cast(right(@mth,2) as int)
	, @mth
	, 'M' + cast(@idx as varchar))
	set @mth = convert(varchar(6),dateadd(month,-1,convert(datetime,@mth+'01',112)),112)
	set @idx = @idx + 1
end
go
update tblDataMonthConv set DM = left(DM,1) + '0' + right(DM,1)
where len(dm) = 2
go



if object_id(N'D_1_R530',N'U') is not null
  drop table D_1_R530
GO
select distinct 
product
, 1 as ID --IDENTITY(int,1,1) as ID
,Mole_Des_EN
,case when Prod_Des_EN in('Taxol','Li Pu Su','Anzatax','Abraxane','Taxotere','Ai Su','Gemzar') then Prod_Des_EN 
     else 'Other' 
     end as Prod_Des_EN 
into D_1_R530  -- select *  
from tblMktDefHospital 
where product ='Taxol' and Mkt='ONCFCS' and ProductName = 'Taxol Market' 
order by Mole_Des_EN
GO
update D_1_R530 set ID=1 where Mole_Des_EN='PACLITAXEL' and Prod_Des_EN='Taxol'
update D_1_R530 set ID=2 where Mole_Des_EN='PACLITAXEL' and Prod_Des_EN='Li Pu Su'
update D_1_R530 set ID=3 where Mole_Des_EN='PACLITAXEL' and Prod_Des_EN='Anzatax'
update D_1_R530 set ID=4 where Mole_Des_EN='PACLITAXEL' and Prod_Des_EN='ABRAXANE'
update D_1_R530 set ID=5 where Mole_Des_EN='PACLITAXEL' and Prod_Des_EN='Other'

update D_1_R530 set ID=6 where Mole_Des_EN='Docetaxel' and Prod_Des_EN='Taxotere'
update D_1_R530 set ID=7 where Mole_Des_EN='Docetaxel' and Prod_Des_EN='Ai Su'
update D_1_R530 set ID=8 where Mole_Des_EN='Docetaxel' and Prod_Des_EN='Other'

update D_1_R530 set ID=9 where Mole_Des_EN='Gemcitabine' and Prod_Des_EN='Gemzar'
update D_1_R530 set ID=10 where Mole_Des_EN='Gemcitabine' and Prod_Des_EN='Other'
GO


insert into D_1_R530 
select distinct
product
,  1 as ID --IDENTITY(int,1,1) as ID
,Mole_Des_EN
,case when Prod_Des_EN in('Paraplatin','Bo Bei','Nuo Xin','Cisplatin','Ao Xian Da','Jie Bai Shu','Lu Bei') then Prod_Des_EN 
     else 'Other' 
     end as Prod_Des_EN 
 -- select *
from tblMktDefHospital 
where product ='Paraplatin' and Mkt='Platinum' and ProductName = 'Platinum Market' 
order by Mole_Des_EN
GO
update D_1_R530 set ID=1 where Mole_Des_EN='Carboplatin' and Prod_Des_EN='Paraplatin'  and  Product = 'Paraplatin'
update D_1_R530 set ID=2 where Mole_Des_EN='Carboplatin' and Prod_Des_EN='Bo Bei'  and Product = 'Paraplatin'
update D_1_R530 set ID=3 where Mole_Des_EN='Carboplatin' and Prod_Des_EN='Other'  and Product = 'Paraplatin'

update D_1_R530 set ID=4 where Mole_Des_EN='Cisplatin' and Prod_Des_EN='Nuo Xin'  and Product = 'Paraplatin'
update D_1_R530 set ID=5 where Mole_Des_EN='Cisplatin' and Prod_Des_EN='Cisplatin'  and Product = 'Paraplatin'
update D_1_R530 set ID=6 where Mole_Des_EN='Cisplatin' and Prod_Des_EN='Other'  and Product = 'Paraplatin'

update D_1_R530 set ID=7 where Mole_Des_EN='NEDAPLATIN' and Prod_Des_EN='Ao Xian Da'  and Product = 'Paraplatin'
update D_1_R530 set ID=8 where Mole_Des_EN='NEDAPLATIN' and Prod_Des_EN='Jie Bai Shu'  and Product = 'Paraplatin'
update D_1_R530 set ID=9 where Mole_Des_EN='NEDAPLATIN' and Prod_Des_EN='Lu Bei'  and Product = 'Paraplatin'
update D_1_R530 set ID=10 where Mole_Des_EN='NEDAPLATIN' and Prod_Des_EN='Other'  and Product = 'Paraplatin'
GO
-- select * from D_1_R530 order by Product,ID


if object_id(N'D_2_R530',N'U') is not null
  drop table D_2_R530
GO
select t2.Product ,'MAT' as TimePeriod, t1.Hosp_BMSName,t1.CPA_Name ,t2.Mole_Des_EN ,t2.Prod_Des_EN ,t2.ID as Product_IDX
into D_2_R530
from D_ProductKeyHospitals t1,D_1_R530 t2 where t1.BuName=t2.Product--2015??Taxol??Paraplatin??key hospital?????????????????????????Where????
-- select * from D_2_R530 order by Product,TimePeriod,CPA_Name,Mole_Des_EN,Prod_Des_EN,Product_IDX

select Product,TimePeriod,CPA_Name,count(*) 
from D_2_R530 group by Product,TimePeriod,CPA_Name having count(*)<>10


--??????????? Prod
if object_id(N'MID_R530',N'U') is not null
  drop table MID_R530
GO
--1. CPA :
select 
   c.product
 , 'MTH' as TimePeriod
 , c.Mole_Des_EN
 , c.Prod_Des_EN
 , b.CPA_Name
 , d.DM--convert(varchar(6),convert(Datetime,a.M+'/1/'+Y,101),112) as Mth
 , sum(isnull([Value],0)) Sales
 , sum(isnull(Volume,0)) Units
 , sum(Volume*cast(subString(Specification,1,charindex(' ',Specification)) as float)/AvgPatientMG) as Adjusted_PatientNumber
into MID_R530
from inCPAData a
inner join tblHospitalMaster b on a.cpa_id = b.id 
inner join (
select distinct product,Mole_Des_CN,Mole_Des_EN,Prod_Des_CN,Prod_Des_EN
from tblMktDefHospital 
where product ='Taxol' and Mkt='ONCFCS' and ProductName = 'Taxol Market' 
union all 
select distinct product,Mole_Des_CN,Mole_Des_EN,Prod_Des_CN,Prod_Des_EN
from tblMktDefHospital 
where product ='ParaPlatin' and Mkt='Platinum' and ProductName = 'Platinum Market' 
) c                                     
on a.Molecule = c.Mole_Des_CN and a.Product = c.Prod_Des_CN
inner join tblDatamonthConv d  on a.Y=d.Y and a.M=d.M 
where b.DataSource = 'CPA'
group by c.product,c.Mole_Des_EN, c.Prod_Des_EN, b.CPA_Name, d.DM
go
--2. SeaRainbow :
insert into MID_R530
select 
   c.product
 , 'MTH' as TimePeriod
 , c.Mole_Des_EN
 , c.Prod_Des_EN
 , b.CPA_Name
 , d.DM--a.YM as Mth
 , sum(isnull([Value],0)) Sales
 , sum(isnull(Volume,0)) Units
 , sum(Volume*cast(subString(Specification,1,charindex(' ',Specification)) as float)/AvgPatientMG) as Adjusted_PatientNumber
from inSeaRainbowData a
inner join tblHospitalMaster b on a.cpa_id = b.id 
inner join (
select distinct product,Mole_Des_CN,Mole_Des_EN,Prod_Des_CN,Prod_Des_EN
from tblMktDefHospital 
where product ='Taxol' and Mkt='ONCFCS' and ProductName = 'Taxol Market' 
union all 
select distinct product,Mole_Des_CN,Mole_Des_EN,Prod_Des_CN,Prod_Des_EN
from tblMktDefHospital 
where product ='ParaPlatin' and Mkt='Platinum' and ProductName = 'Platinum Market' 
) c                                     
on a.Molecule = c.Mole_Des_CN and a.Product = c.Prod_Des_CN
inner join tblDatamonthConv d on a.YM=d.Datamonth
where b.DataSource = 'Sea'
group by c.product,c.Mole_Des_EN, c.Prod_Des_EN, b.CPA_Name, d.DM
go

insert into MID_R530
select 
  Product
, 'MAT' as TimePeriod
, Mole_Des_EN
, Prod_Des_EN
, CPA_Name
, 'M01' as DM
, sum(Sales) as Sales
, sum(Units) as Units
, sum(Adjusted_PatientNumber) as Adjusted_PatientNumber
from MID_R530
where DM < 'M13'
group by  Product, Mole_Des_EN, Prod_Des_EN, CPA_Name
GO

-- select * from MID_R530 where TimePeriod='MAT' and CPA_Name=N'?????????????????' and Prod_Des_EN='Taxol'

if object_id(N'Temp_R530',N'U') is not null
  drop table Temp_R530
GO
select 
  t1.Product
, t1.TimePeriod
, t1.CPA_Name
, t1.Mole_Des_EN
, t1.Prod_Des_EN 
, 1 as Product_IDX
, t1.Sales
, case when t1.Product = 'Paraplatin' then t1.Adjusted_PatientNumber else t1.Units 
  end as Units
into Temp_R530 
from MID_R530 t1
inner join (select distinct cpa_name,BuName from D_ProductKeyHospitals) t2  --todo
on t1.CPA_Name=t2.CPA_Name  and t1.Product=t2.BuName
where TimePeriod='MAT'
order by t1.Product, t1.TimePeriod, t1.CPA_Name
GO


update Temp_R530 set Prod_Des_EN = 'Other'
where Prod_Des_EN not in(
'Taxol','Li Pu Su','Anzatax','Abraxane','Taxotere','Ai Su','Gemzar'
,'Paraplatin','Bo Bei','Nuo Xin','Cisplatin','Ao Xian Da','Jie Bai Shu','Lu Bei'
) 
GO


--????
if object_id(N'Temp_1_R530_bak',N'U') is not null
  drop table Temp_1_R530_bak
GO
select distinct * into Temp_1_R530_bak from Temp_R530

if object_id(N'Temp_R530',N'U') is not null
  drop table Temp_R530
GO
select distinct * into Temp_R530 from Temp_1_R530_bak



if object_id(N'Temp_1_R530',N'U') is not null
  drop table Temp_1_R530
GO
select Product,TimePeriod,CPA_Name,Mole_Des_EN,Prod_Des_EN,Product_IDX,sum(Sales) Sales ,sum(Units) Units
into Temp_1_R530
from Temp_R530
group by Product,TimePeriod,CPA_Name,Mole_Des_EN,Prod_Des_EN,Product_IDX
GO

-- select * from Temp_R530  where CPA_Name=N'???????????????' order by Product	

if object_id(N'OUT_R530',N'U') is not null
  drop table OUT_R530
GO
select 
  t1.Product
, t1.TimePeriod
, t1.Hosp_BMSName as CPA_NAME
, t1.Mole_Des_EN
, t1.Prod_Des_EN
, t1.Product_IDX
, t2.Sales
, t2.Units
into OUT_R530
from D_2_R530 t1
left join Temp_1_R530 t2
on t1.Product=t2.Product and t1.CPA_Name=t2.CPA_Name 
   and t1.Mole_Des_EN=t2.Mole_Des_EN 
   and t1.Prod_Des_EN=t2.Prod_Des_EN 
-- select * from OUT_R530 order by Product,TimePeriod,CPA_Name
GO
update OUT_R530 set 
 Sales=0
,Units=0
where Sales is null or Units is null
GO
-- select * from OUT_R530  where CPA_Name=N'?????????????????' order by Product

select Product,TimePeriod,CPA_Name,count(*) 
from OUT_R530 
group by Product,TimePeriod,CPA_Name having count(*)<>10



-- ???????????????
delete from OutputHospital_All where LinkChartCode like 'R53%' 
GO
--RMB
insert into OutputHospital_All(LinkChartCode,Series,SeriesIdx,Product,lev,Geo,Currency,TimeFrame,X,XIdx,Y,Size,IsShow)
select 
 'R530'                                     --LinkChartCode
, CPA_Name                                  --Series
, RANK() OVER (ORDER BY CPA_Name) AS Rank   --SeriesIdx
,Product                                    --Product
,'Nat'                                      --lev
,'China'                                    --Geo
,'RMB'                                      --Currency
,TimePeriod                                 --TimeFrame
,Prod_Des_EN                                --X
,Product_IDX                                --XIdx
,Sales                                      --Y
,null                                       --Size
,'Y'                                        --IsShow
from OUT_R530
GO
--USD
insert into OutputHospital_All(LinkChartCode,Series,SeriesIdx,Product,lev,Geo,Currency,TimeFrame,X,XIdx,Y,Size,IsShow)
select 
LinkChartCode
,Series
,SeriesIdx
,Product
,lev
,Geo
,'USD' as Currency
,TimeFrame
,X
,XIdx
,cast(Y as Float)/(select Rate from BMSChinaCIA_IMS.dbo.tblRate)--Y
,Size
,IsShow
from OutputHospital_All where LinkChartCode='R530' and Currency='RMB'
GO
--UNIT
insert into OutputHospital_All(LinkChartCode,Series,SeriesIdx,Product,lev,Geo,Currency,TimeFrame,X,XIdx,Y,Size,IsShow)
select 
 'R530'                                     --LinkChartCode
, CPA_Name                                  --Series
, RANK() OVER (ORDER BY CPA_Name) AS Rank   --SeriesIdx
,Product                                    --Product
,'Nat'                                      --lev
,'China'                                    --Geo
,'UNIT'                                     --Currency
,TimePeriod                                 --TimeFrame
,Prod_Des_EN                                --X
,Product_IDX                                --XIdx
,Units                                      --Y
,null                                       --Size
,'Y'                                        --IsShow
from OUT_R530
GO

-- select * from OutputHospital_All where LinkChartCode like 'R53%'  and Product ='Paraplatin' and Series=N'?????????????????' and Currency='RMB'  and x='Paraplatin'


--???????

update OutputHospital_All set SeriesIdx = t2.SeriesIdx,[Size]=t2.SeriesIdx
from OutputHospital_All t1
inner join (
select 
 Product,Series,sum(Y) as Y
--,RANK() OVER (ORDER BY sum(Y) desc) as SeriesIdx
,row_number() over(partition by Product order by sum(Y) desc)  as SeriesIdx 
from OutputHospital_All
where LinkChartCode like 'R53%' 
group by Product,Series
) as t2
on t1.Product=t2.Product and t1.Series=t2.Series
go

update OutputHospital_All set Category=case Currency when 'UNIT' then 'Dosing Units' else 'Value' end
where LinkChartCode like 'R53%' and Product <> 'Paraplatin'
go
update OutputHospital_All set Category=case Currency when 'UNIT' then 'Adjusted patient number' else 'Value' end
where LinkChartCode like 'R53%' and Product = 'Paraplatin'
go
update OutputHospital_All set LinkChartCode = case 
when SeriesIdx<=32 then 'R531' 
when (SeriesIdx>32 and  SeriesIdx<=64) then 'R532'
when (SeriesIdx>64 and  SeriesIdx<=96) then 'R533'
when (SeriesIdx>96 and  SeriesIdx<=128) then 'R534'
when SeriesIdx>128 then 'R535' end 
where LinkChartCode like 'R53%' 
go


--> select * from OutputHospital_All where LinkChartCode like 'R53%' order by LinkChartCode,Product,SeriesIdx

-- select * from OutputHospital_All where LinkChartCode like 'R53%' and Series=N'???????????????' and Product='Taxol' and Currency='RMB' order by XIdx
select Product,TimeFrame,Series,Currency,count(*) 
from OutputHospital_All 
where LinkChartCode like 'R53%'  
group by  Product,TimeFrame,Series,Currency having count(*)<>10


select distinct Series
from OutputHospital_All 
where LinkChartCode like 'R53%'  

exec dbo.sp_Log_Event 'output','CIA_CPA','3_3_Out_R530.sql','End',null,null


--select  * 
--from dbo.OutputHospital_All
--where LinkChartCode  like  'R53%' and Currency='RMB' and seriesidx=1 and product = 'taxol'
----and  XIdx=1 
--order by XIdx 







-- ?????
--select b.id,b.DataSource,b.CPA_code,b.CPA_Name,b.CPA_Name_English,b.Tier,b.Province,b.City
--from D_ProductKeyHospitals a
--inner join dbo.tblHospitalMaster b
--on a.CPA_Name=b.CPA_Name


--     select distinct Product,Parentcode,parentgeo,Geo,
--    Currency,TimeFrame,Category,outputname,Caption,SlideTitle 
--     from tblChartTitle A 
--     where ( exists (select * from outputgeo B where a.geo=b.geo and a.product=b.product) 
--     or  a.linkchartcode  like'c%' or a.linkchartcode like 'r%' )
--   and not (ParentCode in('R400','R410','R500') and Category in ( 'Dosing Units','Adjusted patient number') )
--
--   and parentcode like 'R53%' and Product in ('Taxol')  and Currency='RMB'

--select  * 
--from Output_ppt
--where LinkChartCode  like  'R53%' and Currency='RMB' and seriesidx=100 and product = 'taxol'
----and  XIdx=1 
--order by XIdx 