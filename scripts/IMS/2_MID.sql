use BMSChinaCIA_IMS --db4
GO

--17分钟
--35分钟
--33分钟 201307月份数据
--17分钟 20161110


exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','Start',null,null

print (N'
------------------------------------------------------------------------------------------------------------
1.                                   City
------------------------------------------------------------------------------------------------------------
')
if object_id(N'tblNewCity', N'U') is not null
  drop table tblNewCity
go
select a.City_Code+'_' as AUDI_COD, a.City_Name as AUDI_DES, 'Y' as Active 
into tblNewCity
from Dim_City a 
inner join (
	select City_ID,max(Monseq) as Monseq, sum(Quantity_UN) as Quantity_UN 
	from inMonthlySales 
	group by City_ID) b
on a.City_ID = b.City_ID where b.Quantity_UN <> 0 and b.Monseq < 13
go

if object_id(N'tblProdDef', N'U') is not null
	drop table tblProdDef
go
select distinct Product_Code prod_cod,Product_Name Prod_des,Product_Name as Product
into tblProdDef from dbo.Dim_Product
go
update tblProdDef set Product=upper(left(Product,1))+lower(right(Product,len(Product)-1))
go

--add City NanChang
--delete from Dim_City where City_Name = 'NanChang'
go
--insert into Dim_City
--select * from BMSChinaCIARawdata.dbo.Dim_City_201212 where City_Name = 'NanChang'
go






print (N'
------------------------------------------------------------------------------------------------------------
2.                                   Slide 3 
------------------------------------------------------------------------------------------------------------
')
if exists (select * from dbo.sysobjects where id = object_id(N'OutputTop10TAPerformance') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table OutputTop10TAPerformance
go
CREATE TABLE [dbo].[OutputTop10TAPerformance](
	[Period] [varchar](20) NULL,
    [MoneyType][varchar](20) NULL,
	[Atc3_cod] [varchar](40) NULL,
	[Atc3_des] [varchar](50) NULL,
	[Mat00] [float] NULL,
	[Mat12] [float] NULL,
	[Mat24] [float] NULL
) ON [PRIMARY]

GO
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(max)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
--		print @MoneyType

		set @SQL2='
		insert into OutputTop10TAPerformance 
		select top 10 cast(''MAT'' as varchar(20)) as [Period],'+'''' +@MoneyType+''''+' as MoneyType,B.GTA,B.GTAName,
			sum(Mat00' +@MoneyType+'),sum(Mat12' +@MoneyType+') ,sum(Mat24' +@MoneyType+')
		from dbo.MTHCHPA_PKAU A 
		inner join dbo.tblMktDef_GlobalTA B on A.PACK_cod=B.PACK_cod 
		where B.GTA<>''OTH''
		group by B.GTA,B.GTAName
		order by sum(Mat00' +@MoneyType+') desc

		insert into OutputTop10TAPerformance
		select top 10 ''MQT'','+'''' +@MoneyType+''''+' as MoneyType,B.GTA,B.GTAName,
			sum(R3M00' +@MoneyType+'),sum(R3M12' +@MoneyType+') ,sum(R3M24' +@MoneyType+')
		from MTHCHPA_PKAU A 
		inner join dbo.tblMktDef_GlobalTA B on A.PACK_cod=B.PACK_cod 
		where B.GTA<>''OTH''
		group by B.GTA,B.GTAName
		order by sum(R3M00' +@MoneyType+') desc
		
		insert into OutputTop10TAPerformance
		select top 10 ''YTD'','+'''' +@MoneyType+''''+' as MoneyType,B.GTA,B.GTAName,
			sum(YTD00' +@MoneyType+'),sum(YTD12' +@MoneyType+') ,sum(YTD24' +@MoneyType+')
		from MTHCHPA_PKAU A 
		inner join dbo.tblMktDef_GlobalTA B on A.PACK_cod=B.PACK_cod 
		where B.GTA<>''OTH''
		group by B.GTA,B.GTAName
		order by sum(YTD00' +@MoneyType+') desc
		
		insert into OutputTop10TAPerformance
		select top 10 ''MTH'','+'''' +@MoneyType+''''+' as MoneyType,B.GTA,B.GTAName,
			sum(MTH00' +@MoneyType+'),sum(MTH12' +@MoneyType+') ,sum(MTH24' +@MoneyType+')
		from MTHCHPA_PKAU A 
		inner join dbo.tblMktDef_GlobalTA B on A.PACK_cod=B.PACK_cod 
		where B.GTA<>''OTH''
		group by B.GTA,B.GTAName
		order by sum(MTH00' +@MoneyType+') desc
		'
--		print @SQL2
		exec( @SQL2)
		
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
Alter table OutputTop10TAPerformance Add Mat00Growth float,Mat12Growth float
go
update OutputTop10TAPerformance
set Mat00Growth=case Mat12 when 0 then case Mat00 when 0 then 0 else null end else (Mat00-Mat12)*1.0/Mat12 end
update OutputTop10TAPerformance
set Mat12Growth=case Mat24 when 0 then case Mat12 when 0 then 0 else null end else (Mat12-Mat24)*1.0/Mat24 end
go
--update OutputTop10TAPerformance
--set Atc3_des=B.Atc3_des from OutputTop10TAPerformance A inner join MTHCHPA_ATC3 B
--on A.Atc3_cod=B.Atc3_cod
--go
Alter table OutputTop10TAPerformance
Add [Rank] int
go
update OutputTop10TAPerformance
set [Rank]=B.Rank 
from OutputTop10TAPerformance A
inner join (select Period, MoneyType, [Atc3_cod], RANK ( )over (PARTITION by Period,MoneyType order by Mat00 desc ) as Rank
from OutputTop10TAPerformance) B
on A.Period=B.Period and A.MoneyType=B.MoneyType and A.[Atc3_cod]=b.[Atc3_cod]
go 

--select * from OutputTop10TAPerformance







print (N'
------------------------------------------------------------------------------------------------------------
3.                                   Slide 2 
------------------------------------------------------------------------------------------------------------
')
go
if exists (select * from dbo.sysobjects where id = object_id(N'[OurputKey10TAVSTotalMkt]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [OurputKey10TAVSTotalMkt]
go
CREATE TABLE [dbo].[OurputKey10TAVSTotalMkt](
    [Period] [varchar](20) NULL,
	[MoneyType] [varchar](20) NULL,
	[Market] [varchar](50) NOT NULL,
    [Marketidx] int,
	[Mat00] [float] NULL,
	[Mat12] [float] NULL,
	[Mat24] [float] NULL,
	[Mat36] [float] NULL,
	[Mat48] [float] NULL,
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
	[MTH11] [float] null,
	[MTH12] [float] null,
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
	[MTH23] [float] NULL
	
) ON [PRIMARY]

GO
GO
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(max)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
--		print @MoneyType

		set @SQL2='
		insert into OurputKey10TAVSTotalMkt(Period, MoneyType, Market, Marketidx, Mat00, Mat12, Mat24, Mat36, Mat48)
		select ''MAT'','+'''' +@MoneyType+''''+',''China Market'',1,sum(Mat00' +@MoneyType+'),
			sum(Mat12' +@MoneyType+'),sum(Mat24' +@MoneyType+'),sum(Mat36' +@MoneyType+'),sum(Mat48' +@MoneyType+')
		from dbo.MTHCHPA_Pkau
		union
		select ''MAT'','+'''' +@MoneyType+''''+',''MNCs Market'',2,sum(Mat00' +@MoneyType+'),
			sum(Mat12' +@MoneyType+'),sum(Mat24' +@MoneyType+'),sum(Mat36' +@MoneyType+'),sum(Mat48' +@MoneyType+')
		from MTHCHPA_Pkau A 
		where exists(select * from MTHCHPA_PKAU B where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
		--inner join dbo.tblMktDef_BMSFocused10Mkt B on A.PACK_cod=B.PACK_cod
		union
		select ''MQT'','+'''' +@MoneyType+''''+',''China Market'',1,sum(R3M00' +@MoneyType+'),
			sum(R3M12' +@MoneyType+'),sum(R3M24' +@MoneyType+'),sum(R3M36' +@MoneyType+'),sum(R3M48' +@MoneyType+')
		from dbo.MTHCHPA_Pkau
		union
		select ''MQT'','+'''' +@MoneyType+''''+',''MNCs Market'',2,sum(R3M00' +@MoneyType+'),
			sum(R3M12' +@MoneyType+'),sum(R3M24' +@MoneyType+'),sum(R3M36' +@MoneyType+'),sum(R3M48' +@MoneyType+')
		from MTHCHPA_Pkau A 
		where exists(select * from MTHCHPA_PKAU B where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
		--inner join dbo.tblMktDef_BMSFocused10Mkt B on A.PACK_cod=B.PACK_cod
		union
		select ''YTD'','+'''' +@MoneyType+''''+',''China Market'',1,sum(YTD00' +@MoneyType+'),
			sum(YTD12' +@MoneyType+'),sum(YTD24' +@MoneyType+'),sum(YTD36' +@MoneyType+'),sum(YTD48' +@MoneyType+')
		from dbo.MTHCHPA_Pkau
		union
		select ''YTD'','+'''' +@MoneyType+''''+',''MNCs Market'',2,sum(YTD00' +@MoneyType+'),
			sum(YTD12' +@MoneyType+'),sum(YTD24' +@MoneyType+'),sum(YTD36' +@MoneyType+'),sum(YTD48' +@MoneyType+')
		from MTHCHPA_Pkau A 
		where exists(select * from MTHCHPA_PKAU B where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
		-- inner join dbo.tblMktDef_BMSFocused10Mkt B on A.PACK_cod=B.PACK_cod'

--		print @SQL2
		exec( @SQL2)

		set @SQL2='
		insert into OurputKey10TAVSTotalMkt(Period, MoneyType, Market, Marketidx,
			MTH00, MTH01, MTH02, MTH03, MTH04, MTH05, MTH06, MTH07, 
			MTH08, MTH09, MTH10, MTH11, MTH12, MTH13, MTH14, MTH15,
			MTH16, MTH17, MTH18, MTH19, MTH20, MTH21, MTH22, MTH23
		)
		select ''MTH'','+'''' +@MoneyType+''''+',''China Market'',1,
			sum(MTH00' + @MoneyType + '),
			sum(MTH01' + @MoneyType + '),
			sum(MTH02' + @MoneyType + '),
			sum(MTH03' + @MoneyType + '),
			sum(MTH04' + @MoneyType + '),
			sum(MTH05' + @MoneyType + '),
			sum(MTH06' + @MoneyType + '),
			sum(MTH07' + @MoneyType + '),
			sum(MTH08' + @MoneyType + '),
			sum(MTH09' + @MoneyType + '),
			sum(MTH10' + @MoneyType + '),
			sum(MTH11' + @MoneyType + '),
			sum(MTH12' + @MoneyType + '),
			sum(MTH13' + @MoneyType + '),
			sum(MTH14' + @MoneyType + '),
			sum(MTH15' + @MoneyType + '),
			sum(MTH16' + @MoneyType + '),
			sum(MTH17' + @MoneyType + '),
			sum(MTH18' + @MoneyType + '),
			sum(MTH19' + @MoneyType + '),
			sum(MTH20' + @MoneyType + '),
			sum(MTH21' + @MoneyType + '),
			sum(MTH22' + @MoneyType + '),
			sum(MTH23' + @MoneyType + ')
		from dbo.MTHCHPA_Pkau
		union
		select ''MTH'','+'''' +@MoneyType+''''+',''MNCs Market'',2,
			sum(MTH00' + @MoneyType + '),
			sum(MTH01' + @MoneyType + '),
			sum(MTH02' + @MoneyType + '),
			sum(MTH03' + @MoneyType + '),
			sum(MTH04' + @MoneyType + '),
			sum(MTH05' + @MoneyType + '),
			sum(MTH06' + @MoneyType + '),
			sum(MTH07' + @MoneyType + '),
			sum(MTH08' + @MoneyType + '),
			sum(MTH09' + @MoneyType + '),
			sum(MTH10' + @MoneyType + '),
			sum(MTH11' + @MoneyType + '),
			sum(MTH12' + @MoneyType + '),
			sum(MTH13' + @MoneyType + '),
			sum(MTH14' + @MoneyType + '),
			sum(MTH15' + @MoneyType + '),
			sum(MTH16' + @MoneyType + '),
			sum(MTH17' + @MoneyType + '),
			sum(MTH18' + @MoneyType + '),
			sum(MTH19' + @MoneyType + '),
			sum(MTH20' + @MoneyType + '),
			sum(MTH21' + @MoneyType + '),
			sum(MTH22' + @MoneyType + '),
			sum(MTH23' + @MoneyType + ')
		from MTHCHPA_Pkau A 
		where exists(select * from MTHCHPA_PKAU B where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
		-- inner join dbo.tblMktDef_BMSFocused10Mkt B on A.PACK_cod=B.PACK_cod
		'

--		print @SQL2
		exec( @SQL2)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
insert into OurputKey10TAVSTotalMkt
select A.Period, A.MoneyType, 'MNCs Performance % of China Market', 3,
	B.Mat00*1.0/A.Mat00,
	B.Mat12*1.0/A.Mat12, 
	B.Mat24*1.0/A.Mat24, 
	B.Mat36*1.0/A.Mat36, 
	B.Mat48*1.0/A.Mat48,
	B.MTH00*1.0/A.MTH00,
	B.MTH01*1.0/A.MTH01,
	B.MTH02*1.0/A.MTH02,
	B.MTH03*1.0/A.MTH03,
	B.MTH04*1.0/A.MTH04,
	B.MTH05*1.0/A.MTH05,
	B.MTH06*1.0/A.MTH06,
	B.MTH07*1.0/A.MTH07,
	B.MTH08*1.0/A.MTH08,
	B.MTH09*1.0/A.MTH09,
	B.MTH10*1.0/A.MTH10,
	B.MTH11*1.0/A.MTH11,
	B.MTH12*1.0/A.MTH12,
	B.MTH13*1.0/A.MTH13,
	B.MTH14*1.0/A.MTH14,
	B.MTH15*1.0/A.MTH15,
	B.MTH16*1.0/A.MTH16,
	B.MTH17*1.0/A.MTH17,
	B.MTH18*1.0/A.MTH18,
	B.MTH19*1.0/A.MTH19,
	B.MTH20*1.0/A.MTH20,
	B.MTH21*1.0/A.MTH21,
	B.MTH22*1.0/A.MTH22,
	B.MTH23*1.0/A.MTH23
from OurputKey10TAVSTotalMkt A 
inner join OurputKey10TAVSTotalMkt B
	on A.Period=B.Period and A.MoneyType=B.MoneyType
		and A.Market='China Market' and B.Market='MNCs Market'
go
insert into OurputKey10TAVSTotalMkt
select Period,MoneyType,Market+' Growth',[Marketidx]*10,
	case Mat12 when 0 then case Mat00 when 0 then 0 else null end else (Mat00-Mat12)*1.0/Mat12 end,
	case Mat24 when 0 then case Mat12 when 0 then 0 else null end else (Mat12-Mat24)*1.0/Mat24 end,
	case Mat36 when 0 then case Mat24 when 0 then 0 else null end else (Mat24-Mat36)*1.0/Mat36 end,
	case Mat48 when 0 then case Mat36 when 0 then 0 else null end else (Mat36-Mat48)*1.0/Mat48 end,
	null,
	case MTH12 when 0 then case MTH00 when 0 then 0 else null end else (MTH00-MTH12)*1.0/MTH12 end,
	case MTH13 when 0 then case MTH01 when 0 then 0 else null end else (MTH01-MTH13)*1.0/MTH13 end,
	case MTH14 when 0 then case MTH02 when 0 then 0 else null end else (MTH02-MTH14)*1.0/MTH14 end,
	case MTH15 when 0 then case MTH03 when 0 then 0 else null end else (MTH03-MTH15)*1.0/MTH15 end,
	case MTH16 when 0 then case MTH04 when 0 then 0 else null end else (MTH04-MTH16)*1.0/MTH16 end,
	case MTH17 when 0 then case MTH05 when 0 then 0 else null end else (MTH05-MTH17)*1.0/MTH17 end,
	case MTH18 when 0 then case MTH06 when 0 then 0 else null end else (MTH06-MTH18)*1.0/MTH18 end,
	case MTH19 when 0 then case MTH07 when 0 then 0 else null end else (MTH07-MTH19)*1.0/MTH19 end,
	case MTH20 when 0 then case MTH08 when 0 then 0 else null end else (MTH08-MTH20)*1.0/MTH20 end,
	case MTH21 when 0 then case MTH09 when 0 then 0 else null end else (MTH09-MTH21)*1.0/MTH21 end,
	case MTH22 when 0 then case MTH10 when 0 then 0 else null end else (MTH10-MTH22)*1.0/MTH22 end,
	case MTH23 when 0 then case MTH11 when 0 then 0 else null end else (MTH11-MTH23)*1.0/MTH23 end,
	null ,null,null ,null,null ,null,null ,null,null ,null,null ,null
from OurputKey10TAVSTotalMkt 
where market<> 'MNCs Performance % of China Market'
go
insert into OurputKey10TAVSTotalMkt
select Period,MoneyType,Market+' CAGR',[Marketidx]*100,
	case when mat48>0 then Power((MAT00/MAT48),1.0/4)-1 else 0 end,0,0,0,0,
	0,0,0,0,0, 0,0,0,0,0, 0,0,
	0,0,0,0,0, 0,0,0,0,0, 0,0
from OurputKey10TAVSTotalMkt 
where market in('China Market','MNCs Market')

go
alter table OurputKey10TAVSTotalMkt
drop column 
	MTH12,
	MTH13,
	MTH14,
	MTH15,
	MTH16,
	MTH17,
	MTH18,
	MTH19,
	MTH20,
	MTH21,
	MTH22,
	MTH23
go 
--select * from dbo.OurputKey10TAVSTotalMkt



exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','OutputKeyMNCsPerformance',null,null
print (N'
------------------------------------------------------------------------------------------------------------
4.                                   Slide 4 
------------------------------------------------------------------------------------------------------------
')
if exists (select * from dbo.sysobjects where id = object_id(N'OutputKeyMNCsPerformance') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputKeyMNCsPerformance
go
CREATE TABLE [dbo].[OutputKeyMNCsPerformance](
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
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(max)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN	

		set @SQL2='
		
		insert into OutputKeyMNCsPerformance 
		select top 10 cast(''MAT'' as varchar(20)) as [Period],'+'''' +@MoneyType+''''+',1 as CurrRank,1 as PrevRank,CORP_cod,'''',
			sum(Mat00' +@MoneyType+') as Mat00' +@MoneyType+',sum(Mat12' +@MoneyType+') as Mat12' +@MoneyType+',0
		from dbo.MTHCHPA_PKAU A 
		where exists(select * from MTHCHPA_PKAU B where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
		group by CORP_cod
		order by sum(Mat00' +@MoneyType+') desc

		insert into OutputKeyMNCsPerformance 
		select top 10 cast(''MTH'' as varchar(20)) as [Period],'+'''' +@MoneyType+''''+',1 as CurrRank,1 as PrevRank,CORP_cod,'''',
			sum(MTH00' +@MoneyType+') as MTH00' +@MoneyType+',sum(MTH12' +@MoneyType+') as MTH12' +@MoneyType+',0
		from dbo.MTHCHPA_PKAU A 
		where exists(select * from MTHCHPA_PKAU B where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
		group by CORP_cod
		order by sum(MTH00' +@MoneyType+') desc

		insert into OutputKeyMNCsPerformance 
		select top 10 cast(''MQT'' as varchar(20)) as [Period],'+'''' +@MoneyType+''''+',1 as CurrRank,1 as PrevRank,CORP_cod,'''',
			sum(R3M00' +@MoneyType+') as R3M00' +@MoneyType+',sum(R3M12' +@MoneyType+') as R3M12' +@MoneyType+',0
		from dbo.MTHCHPA_PKAU A 
		where exists(select * from MTHCHPA_PKAU B where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
		group by CORP_cod
		order by sum(R3M00' +@MoneyType+') desc

		insert into OutputKeyMNCsPerformance 
		select top 10 cast(''YTD'' as varchar(20)) as [Period],'+'''' +@MoneyType+''''+',1 as CurrRank,1 as PrevRank,CORP_cod,'''',
			sum(YTD00' +@MoneyType+') as YTD00' +@MoneyType+',sum(YTD12' +@MoneyType+') as YTD12' +@MoneyType+',0
		from dbo.MTHCHPA_PKAU A 
		where exists(select * from MTHCHPA_PKAU B where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
		group by CORP_cod
		order by sum(YTD00' +@MoneyType+') desc
		

		if exists(
				select * from OutputKeyMNCsPerformance 
				where CORP_Cod =   (select Corporation_ID from Dim_Manufacturer where Manufacturer_Abbr like ''%BSG%'')
        			and Period=''MAT'' and MoneyType='+''''  +@MoneyType+'''' +'
				)
		begin
			print ''BMS COPR in Top 10 MAT ' +@MoneyType+'''
		end
		else
		begin
			insert into OutputKeyMNCsPerformance
			select ''MAT'','+'''' +@MoneyType+''''+',1,1,CORP_cod,'''',
				sum(Mat00' +@MoneyType+') as Mat00' +@MoneyType+',sum(Mat12' +@MoneyType+') as Mat12' +@MoneyType+',0
			from dbo.MTHCHPA_PKAU A 
			where CORP_Cod =  (select Corporation_ID from Dim_Manufacturer where Manufacturer_Abbr like ''%BSG%'')
			group by CORP_cod
			order by sum(Mat00' +@MoneyType+') desc
		end

		if exists(
				select * from OutputKeyMNCsPerformance 
				where CORP_Cod =   (select Corporation_ID from Dim_Manufacturer where Manufacturer_Abbr like ''%BSG%'')
        			and Period=''MTH'' and MoneyType='+''''  +@MoneyType+'''' +'
				)
		begin
			print ''BMS COPR in Top 10 MTH ' +@MoneyType+'''
		end
		else
		begin
			insert into OutputKeyMNCsPerformance
			select ''MTH'','+'''' +@MoneyType+''''+',1,1,CORP_cod,'''',
				sum(MTH00' +@MoneyType+') as MTH00' +@MoneyType+',sum(MTH12' +@MoneyType+') as MTH12' +@MoneyType+',0
			from dbo.MTHCHPA_PKAU A 
			where CORP_Cod =  (select Corporation_ID from Dim_Manufacturer where Manufacturer_Abbr like ''%BSG%'')
			group by CORP_cod
			order by sum(MTH00' +@MoneyType+') desc
		end
		
		if exists(
				select * from OutputKeyMNCsPerformance 
				where CORP_Cod =   (select Corporation_ID from Dim_Manufacturer where Manufacturer_Abbr like ''%BSG%'')
        			and Period=''YTD'' and MoneyType='+''''  +@MoneyType+'''' +'
				)
		begin
			print ''BMS COPR in Top 10 YTD ' +@MoneyType+'''
		end
		else
		begin
			insert into OutputKeyMNCsPerformance
			select ''YTD'','+'''' +@MoneyType+''''+',1,1,CORP_cod,'''',
				sum(YTD00' +@MoneyType+') as YTD00' +@MoneyType+',sum(YTD12' +@MoneyType+') as YTD12' +@MoneyType+',0
			from dbo.MTHCHPA_PKAU A 
			where CORP_Cod =  (select Corporation_ID from Dim_Manufacturer where Manufacturer_Abbr like ''%BSG%'')
			group by CORP_cod
			order by sum(YTD00' +@MoneyType+') desc
		end
		
		if exists(
				select * from OutputKeyMNCsPerformance 
				where CORP_Cod =   (select Corporation_ID from Dim_Manufacturer where Manufacturer_Abbr like ''%BSG%'')
        			and Period=''MQT'' and MoneyType='+''''  +@MoneyType+'''' +'
				)
		begin
			print ''BMS COPR in Top 10 MQT ' +@MoneyType+'''
		end
		else
		begin
			insert into OutputKeyMNCsPerformance
			select ''MQT'','+'''' +@MoneyType+''''+',1,1,CORP_cod,'''',
				sum(R3M00' +@MoneyType+') as R3M00' +@MoneyType+',sum(R3M12' +@MoneyType+') as R3M12' +@MoneyType+',0
			from dbo.MTHCHPA_PKAU A 
			where CORP_Cod =  (select Corporation_ID from Dim_Manufacturer where Manufacturer_Abbr like ''%BSG%'')
			group by CORP_cod
			order by sum(R3M00' +@MoneyType+') desc
		end
		'

		print @SQL2
		exec( @SQL2)

		set @SQL2='
		update OutputKeyMNCsPerformance
		set CurrRank=B.Rank 
		from OutputKeyMNCsPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(Mat00' +@MoneyType+') desc ) as Rank,CORP_cod,sum(Mat00' +@MoneyType+') as Mat00' +@MoneyType+' 
			from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
				where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
			group by CORP_cod) B
		on A.CORP_cod=B.CORP_cod and A.[Period]=''MAT'' and MoneyType='+'''' +@MoneyType+'''' +'

		update OutputKeyMNCsPerformance
		set PrevRank=B.Rank 
		from OutputKeyMNCsPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(Mat12' +@MoneyType+') desc ) as Rank,CORP_cod,sum(Mat12' +@MoneyType+') as Mat12' +@MoneyType+' 
			from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
				where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
			group by CORP_cod) B
		on A.CORP_cod=B.CORP_cod and A.[Period]=''MAT'' and MoneyType='+'''' +@MoneyType+'''' +'

		update OutputKeyMNCsPerformance
		set CurrRank=B.Rank 
		from OutputKeyMNCsPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(R3M00' +@MoneyType+') desc ) as Rank,CORP_cod,sum(R3M00' +@MoneyType+') as R3M00' +@MoneyType+' 
			from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
				where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
			group by CORP_cod) B
		on A.CORP_cod=B.CORP_cod and A.[Period]=''MQT'' and MoneyType='+'''' +@MoneyType+'''' +'

		update OutputKeyMNCsPerformance
		set PrevRank=B.Rank 
		from OutputKeyMNCsPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(R3M12' +@MoneyType+') desc ) as Rank,CORP_cod,sum(R3M12' +@MoneyType+') as R3M12' +@MoneyType+' 
			from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
				where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
			group by CORP_cod) B
		on A.CORP_cod=B.CORP_cod and A.[Period]=''MQT'' and MoneyType='+'''' +@MoneyType+'''' +'
		
		update OutputKeyMNCsPerformance
		set CurrRank=B.Rank 
		from OutputKeyMNCsPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(MTH00' +@MoneyType+') desc ) as Rank,CORP_cod,sum(MTH00' +@MoneyType+') as MTH00' +@MoneyType+' 
			from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
				where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
			group by CORP_cod) B
		on A.CORP_cod=B.CORP_cod and A.[Period]=''MTH'' and MoneyType='+'''' +@MoneyType+'''' +'

		update OutputKeyMNCsPerformance
		set PrevRank=B.Rank 
		from OutputKeyMNCsPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(MTH12' +@MoneyType+') desc ) as Rank,CORP_cod,sum(MTH12' +@MoneyType+') as MTH12' +@MoneyType+' 
			from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
				where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
			group by CORP_cod) B
		on A.CORP_cod=B.CORP_cod and A.[Period]=''MTH'' and MoneyType='+'''' +@MoneyType+'''' +'

		update OutputKeyMNCsPerformance
		set CurrRank=B.Rank 
		from OutputKeyMNCsPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(YTD00' +@MoneyType+') desc ) as Rank,CORP_cod,sum(YTD00' +@MoneyType+') as YTD00' +@MoneyType+' 
			from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
				where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
			group by CORP_cod) B
		on A.CORP_cod=B.CORP_cod and A.[Period]=''YTD'' and MoneyType='+'''' +@MoneyType+'''' +'

		update OutputKeyMNCsPerformance
		set PrevRank=B.Rank 
		from OutputKeyMNCsPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(YTD12' +@MoneyType+') desc ) as Rank,CORP_cod,sum(YTD12' +@MoneyType+') as YTD12' +@MoneyType+' 
			from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
				where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
			group by CORP_cod) B
		on A.CORP_cod=B.CORP_cod and A.[Period]=''YTD'' and MoneyType='+'''' +@MoneyType+'''' +'

		update OutputKeyMNCsPerformance
		set Total=B.Total 
		from OutputKeyMNCsPerformance A,
			(	select sum(Mat00' +@MoneyType+')  as Total 
				from  dbo.MTHCHPA_PKAU A 
		   		where exists(select * from MTHCHPA_PKAU B where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
			) B
		where A.MoneyType='+'''' +@MoneyType+'''' +' and Period=''MAT''
	    
		update OutputKeyMNCsPerformance
		set Total=B.Total 
		from OutputKeyMNCsPerformance A,
			(	select sum(R3M00' +@MoneyType+')  as Total from  dbo.MTHCHPA_PKAU A 
		   		where exists(select * from MTHCHPA_PKAU B  where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
			) B
		where A.MoneyType='+'''' +@MoneyType+'''' +' and Period=''MQT''
		
		update OutputKeyMNCsPerformance
		set Total=B.Total 
		from OutputKeyMNCsPerformance A,
			(	select sum(MTH00' +@MoneyType+')  as Total 
				from  dbo.MTHCHPA_PKAU A 
		   		where exists(select * from MTHCHPA_PKAU B where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
			) B
		where A.MoneyType='+'''' +@MoneyType+'''' +' and Period=''MTH''
	    
		update OutputKeyMNCsPerformance
		set Total=B.Total 
		from OutputKeyMNCsPerformance A,
			(	select sum(YTD00' +@MoneyType+')  as Total from  dbo.MTHCHPA_PKAU A 
		   		where exists(select * from MTHCHPA_PKAU B  where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD=''I'')
			) B
		where A.MoneyType='+'''' +@MoneyType+'''' +' and Period=''YTD''
		
		'
		print @SQL2
		exec( @SQL2)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
Alter table OutputKeyMNCsPerformance 
Add Share float,ShareTotal float,Mat00Growth float
go
update OutputKeyMNCsPerformance
set Mat00Growth=case Mat12 when 0 then case Mat00 when 0 then 0 else null end else (Mat00-Mat12)*1.0/Mat12 end

update OutputKeyMNCsPerformance
set Share=Mat00*1.0/Total


update OutputKeyMNCsPerformance
set ShareTotal=B.ShareTotal 
from OutputKeyMNCsPerformance A 
left join
    (select Period,MoneyType,sum(Mat00)*1.0/Total as ShareTotal
     from OutputKeyMNCsPerformance group by Period,MoneyType,total) B
on A.[Period]=B.[Period] and A.MoneyType=B.MoneyType
go
update OutputKeyMNCsPerformance
set CORP_des=replace(replace(B.Manufacturer_Name,' Group',''),' GRP','') 
from OutputKeyMNCsPerformance A 
inner join dbo.Dim_Manufacturer B
on A.CORP_cod=B.Corporation_ID
	and B.Manufacturer_ID=B.Corporation_ID
go
--update OutputKeyMNCsPerformance
--set CORP_des=replace(replace(B.Manufacturer_Name,' Group',''),' GRP','') 
--from OutputKeyMNCsPerformance A inner join dbo.Dim_Manufacturer B
--on A.CORP_cod=B.Corporation_ID
--where CORP_des=''
go
Alter table OutputKeyMNCsPerformance 
Add ChangeRank int
go
update OutputKeyMNCsPerformance
set ChangeRank=-sign(CurrRank-PrevRank)
go
update OutputKeyMNCsPerformance
set Corp_des=B.newname 
from OutputKeyMNCsPerformance A 
inner join tblTextNameRef B
on A.Corp_des=B.oldname
go
--select * from OutputKeyMNCsPerformance





if exists (select * from dbo.sysobjects where id = object_id(N'MID_TopIL_CompaniesPerformance') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table MID_TopIL_CompaniesPerformance
go
CREATE TABLE [dbo].[MID_TopIL_CompaniesPerformance](
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
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(max)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN	

		set @SQL2='
		insert into MID_TopIL_CompaniesPerformance 
		select top 10 cast(''MAT'' as varchar(20)) as [Period],'+'''' +@MoneyType+''''+',1 as CurrRank,1 as PrevRank,CORP_cod,'''',
		sum(Mat00' +@MoneyType+') as Mat00' +@MoneyType+',sum(Mat12' +@MoneyType+') as Mat12' +@MoneyType+',0
		from dbo.MTHCHPA_PKAU A 
		where exists(	select * from MTHCHPA_PKAU B  
						where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD in (''I'',''L''))
		group by CORP_cod
		order by sum(Mat00' +@MoneyType+') desc

		if exists(	select * from MID_TopIL_CompaniesPerformance 
				  	where CORP_Cod =  (select Corporation_ID from Dim_Manufacturer where Manufacturer_Abbr like ''%BSG%'')
        				and Period=''MAT'' and MoneyType='+''''  +@MoneyType+'''' +'
		)
			print ''BMS COPR in Top 10 MAT ' +@MoneyType+'''
		else
			insert into MID_TopIL_CompaniesPerformance
			select ''MAT'','+'''' +@MoneyType+''''+',1,1,CORP_cod,'''',
			sum(Mat00' +@MoneyType+') as Mat00' +@MoneyType+',sum(Mat12' +@MoneyType+') as Mat12' +@MoneyType+',0
			from dbo.MTHCHPA_PKAU A 
			where CORP_Cod =  (select Corporation_ID from Dim_Manufacturer where Manufacturer_Abbr like ''%BSG%'')
			group by CORP_cod
			order by sum(Mat00' +@MoneyType+') desc'
		exec( @SQL2)

		set @SQL2='update MID_TopIL_CompaniesPerformance
		set CurrRank=B.Rank 
		from MID_TopIL_CompaniesPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(Mat00' +@MoneyType+') desc ) as Rank,CORP_cod,sum(Mat00' +@MoneyType+') as Mat00' +@MoneyType+' 
			from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
				where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD in (''I'',''L''))
			group by CORP_cod) B
		on A.CORP_cod=B.CORP_cod and A.[Period]=''MAT'' and MoneyType='+'''' +@MoneyType+'''' +'

		update MID_TopIL_CompaniesPerformance
		set PrevRank=B.Rank 
		from MID_TopIL_CompaniesPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(Mat12' +@MoneyType+') desc ) as Rank,CORP_cod,sum(Mat12' +@MoneyType+') as Mat12' +@MoneyType+' 
			from dbo.MTHCHPA_PKAU A where exists(select * from MTHCHPA_PKAU B  
				where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD in (''I'',''L''))
			group by CORP_cod) B
		on A.CORP_cod=B.CORP_cod and A.[Period]=''MAT'' and MoneyType='+'''' +@MoneyType+'''' +'

		
		update MID_TopIL_CompaniesPerformance
		set Total=B.Total 
		from MID_TopIL_CompaniesPerformance A,
		(	select sum(Mat00' +@MoneyType+')  as Total 
			from  dbo.MTHCHPA_PKAU A 
		  	where exists(	select * from MTHCHPA_PKAU B  
							where A.CORP_Cod=B.CORP_Cod and B.MNFL_COD in (''I'',''L''))
		) B
		where A.MoneyType='+'''' +@MoneyType+'''' +' and Period=''MAT'''
	    
--		print @SQL2
		exec( @SQL2)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
Alter table MID_TopIL_CompaniesPerformance Add Share float,ShareTotal float,Mat00Growth float
go
update MID_TopIL_CompaniesPerformance
set Mat00Growth=case Mat12 when 0 then case Mat00 when 0 then 0 else null end else (Mat00-Mat12)*1.0/Mat12 end

update MID_TopIL_CompaniesPerformance
set Share=Mat00*1.0/Total

-- ShareTotal: Onco Market Top 10 Companies + BMS占所有统计公司的一个Share
update MID_TopIL_CompaniesPerformance
set ShareTotal=B.ShareTotal from MID_TopIL_CompaniesPerformance A left join
    (select Period,MoneyType,sum(Mat00)*1.0/Total as ShareTotal
     from MID_TopIL_CompaniesPerformance group by Period,MoneyType,total) B
on A.[Period]=B.[Period] and A.MoneyType=B.MoneyType
go
update MID_TopIL_CompaniesPerformance
set CORP_des=replace(replace(B.Manufacturer_Name,' Group',''),' GRP','') from MID_TopIL_CompaniesPerformance A inner join dbo.Dim_Manufacturer B
on A.CORP_cod=B.Corporation_ID
and B.Manufacturer_ID=B.Corporation_ID
go

Alter table MID_TopIL_CompaniesPerformance Add ChangeRank int
go
update MID_TopIL_CompaniesPerformance
set ChangeRank=-sign(CurrRank-PrevRank)
go
update MID_TopIL_CompaniesPerformance
set Corp_des=B.newname from MID_TopIL_CompaniesPerformance A inner join tblTextNameRef B
on A.Corp_des=B.oldname
go
--select * from MID_TopIL_CompaniesPerformance


exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','OutputKeyMNCsProdPerformance',null,null
print (N'
------------------------------------------------------------------------------------------------------------
5.                                   Slide 5
------------------------------------------------------------------------------------------------------------
')
if exists (select * from dbo.sysobjects where id = object_id(N'OutputKeyMNCsProdPerformance') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table OutputKeyMNCsProdPerformance
go
CREATE TABLE [dbo].[OutputKeyMNCsProdPerformance](
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
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(max)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType

		set @SQL2='
		insert into OutputKeyMNCsProdPerformance 
		select top 10 cast(''MAT'' as varchar(20)) as [Period],'+'''' +@MoneyType+''''+',1 as CurrRank,1 as PrevRank,Prod_cod,'''',
			sum(Mat00' +@MoneyType+'),sum(Mat12' +@MoneyType+'),0
		from MTHCHPA_PKAU A
		left join dbo.Dim_Product C on A.Prod_cod = c.Product_code
		where CORP_Cod in(select CORP_Cod from OutputKeyMNCsPerformance where Period=''MAT'' and MoneyType='+''''  +@MoneyType+'''' +')
			and c.Product_Name not in (''Albumin human'', ''Pulmicort resp'')
		group by Prod_cod
		order by sum(Mat00' +@MoneyType+') desc

		if exists(	select * from OutputKeyMNCsProdPerformance 
					where Prod_Cod like ''%30173%'' and Period=''MAT'' and MoneyType='+''''  +@MoneyType+'''' +')
			print ''Baraclude COPR in Top 10 MAT ' +@MoneyType+'''
		else
			insert into OutputKeyMNCsProdPerformance
			select ''MAT'','+'''' +@MoneyType+''''+',1,1,Prod_cod,'''',
				sum(Mat00' +@MoneyType+'),sum(Mat12' +@MoneyType+'),0
			from dbo.MTHCHPA_PKAU A 
			where Prod_Cod like ''%30173%''
			group by Prod_cod
			order by sum(Mat00' +@MoneyType+') desc

		--Rolling 3 Month
		insert into OutputKeyMNCsProdPerformance 
		select top 10 cast(''MQT'' as varchar(20)) as [Period],'+'''' +@MoneyType+''''+',1 as CurrRank,1 as PrevRank,Prod_cod,'''',
			sum(R3M00' +@MoneyType+'),sum(R3M12' +@MoneyType+'),0
		from MTHCHPA_PKAU A
		left join dbo.Dim_Product C on A.Prod_cod = c.Product_code
		where CORP_Cod in(select CORP_Cod from OutputKeyMNCsPerformance where Period=''MQT'' and MoneyType='+''''  +@MoneyType+'''' +')
			and c.Product_Name not in (''Albumin human'', ''Pulmicort resp'')
		group by Prod_cod
		order by sum(R3M00' +@MoneyType+') desc

		if exists(	select * from OutputKeyMNCsProdPerformance 
					where Prod_Cod like ''%30173%'' and Period=''MQT'' and MoneyType='+''''  +@MoneyType+'''' +')
			print ''Baraclude COPR in Top 10 MQT ' +@MoneyType+'''
		else
			insert into OutputKeyMNCsProdPerformance
			select ''MQT'','+'''' +@MoneyType+''''+',1,1,Prod_cod,'''',
				sum(R3M00' +@MoneyType+'),sum(R3M12' +@MoneyType+'),0
			from dbo.MTHCHPA_PKAU A 
			where Prod_Cod like ''%30173%''
			group by Prod_cod
			order by sum(R3M00' +@MoneyType+') desc
		
		-- MTH
		insert into OutputKeyMNCsProdPerformance 
		select top 10 cast(''MTH'' as varchar(20)) as [Period],'+'''' +@MoneyType+''''+',1 as CurrRank,1 as PrevRank,Prod_cod,'''',
			sum(MTH00' +@MoneyType+'),sum(MTH12' +@MoneyType+'),0
		from MTHCHPA_PKAU A
		left join dbo.Dim_Product C on A.Prod_cod = c.Product_code
		where CORP_Cod in(select CORP_Cod from OutputKeyMNCsPerformance where Period=''MTH'' and MoneyType='+''''  +@MoneyType+'''' +')
			and c.Product_Name not in (''Albumin human'', ''Pulmicort resp'')
		group by Prod_cod
		order by sum(MTH00' +@MoneyType+') desc

		if exists(	select * from OutputKeyMNCsProdPerformance 
					where Prod_Cod like ''%30173%'' and Period=''MTH'' and MoneyType='+''''  +@MoneyType+'''' +')
			print ''Baraclude COPR in Top 10 MTH ' +@MoneyType+'''
		else
			insert into OutputKeyMNCsProdPerformance
			select ''MTH'','+'''' +@MoneyType+''''+',1,1,Prod_cod,'''',
				sum(MTH00' +@MoneyType+'),sum(MTH12' +@MoneyType+'),0
			from dbo.MTHCHPA_PKAU A 
			where Prod_Cod like ''%30173%''
			group by Prod_cod
			order by sum(MTH00' +@MoneyType+') desc

		-- YTD
		insert into OutputKeyMNCsProdPerformance 
		select top 10 cast(''YTD'' as varchar(20)) as [Period],'+'''' +@MoneyType+''''+',1 as CurrRank,1 as PrevRank,Prod_cod,'''',
			sum(YTD00' +@MoneyType+'),sum(YTD12' +@MoneyType+'),0
		from MTHCHPA_PKAU A
		left join dbo.Dim_Product C on A.Prod_cod = c.Product_code
		where CORP_Cod in(select CORP_Cod from OutputKeyMNCsPerformance where Period=''YTD'' and MoneyType='+''''  +@MoneyType+'''' +')
			and c.Product_Name not in (''Albumin human'', ''Pulmicort resp'')
		group by Prod_cod
		order by sum(YTD00' +@MoneyType+') desc

		if exists(	select * from OutputKeyMNCsProdPerformance 
					where Prod_Cod like ''%30173%'' and Period=''YTD'' and MoneyType='+''''  +@MoneyType+'''' +')
			print ''Baraclude COPR in Top 10 YTD ' +@MoneyType+'''
		else
			insert into OutputKeyMNCsProdPerformance
			select ''YTD'','+'''' +@MoneyType+''''+',1,1,Prod_cod,'''',
				sum(YTD00' +@MoneyType+'),sum(YTD12' +@MoneyType+'),0
			from dbo.MTHCHPA_PKAU A 
			where Prod_Cod like ''%30173%''
			group by Prod_cod
			order by sum(YTD00' +@MoneyType+') desc

		'

		exec( @SQL2)

		set @SQL2='
		update OutputKeyMNCsProdPerformance
		set CurrRank=B.Rank 
		from OutputKeyMNCsProdPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(Mat00' +@MoneyType+') desc ) as Rank,a.PROD_cod,sum(Mat00' +@MoneyType+') as Mat00' +@MoneyType+' 
			from dbo.MTHCHPA_PKAU A 
			left join dbo.Dim_Product C on A.Prod_cod = c.Product_code
			where CORP_Cod in(
					select CORP_Cod from OutputKeyMNCsPerformance 
					where Period=''MAT'' and MoneyType='+''''  +@MoneyType+'''' +' )
				and c.Product_Name not in (''Albumin human'', ''Pulmicort resp'')
			group by a.PROD_cod) B
		on A.PROD_cod=B.PROD_cod and A.[Period]=''MAT'' and MoneyType='+'''' +@MoneyType+'''' +'
		
		update OutputKeyMNCsProdPerformance
		set PrevRank=B.Rank 
		from OutputKeyMNCsProdPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(Mat12' +@MoneyType+') desc ) as Rank,a.PROD_cod,sum(Mat12' +@MoneyType+') as Mat12' +@MoneyType+'
			from dbo.MTHCHPA_PKAU A 
			left join dbo.Dim_Product C on A.Prod_cod = c.Product_code
			where CORP_Cod in(	select CORP_Cod from OutputKeyMNCsPerformance where Period=''MAT'' and MoneyType='+''''  +@MoneyType+'''' +')
				and c.Product_Name not in (''Albumin human'', ''Pulmicort resp'')
			group by a.PROD_cod
		) B
		on A.PROD_cod=B.PROD_cod and A.[Period]=''MAT'' and MoneyType='+'''' +@MoneyType+'''' +'
	

		update OutputKeyMNCsProdPerformance
		set CurrRank=B.Rank 
		from OutputKeyMNCsProdPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(R3M00' +@MoneyType+') desc ) as Rank,a.PROD_cod,sum(R3M00' +@MoneyType+') as R3M00' +@MoneyType+' 
			from dbo.MTHCHPA_PKAU A 
			left join dbo.Dim_Product C on A.Prod_cod = c.Product_code
			where CORP_Cod in(select CORP_Cod from OutputKeyMNCsPerformance where Period=''MQT'' and MoneyType='+''''  +@MoneyType+'''' +')
				and c.Product_Name not in (''Albumin human'', ''Pulmicort resp'')
			group by a.PROD_cod
		) B
		on A.PROD_cod=B.PROD_cod and A.[Period]=''MQT'' and MoneyType='+'''' +@MoneyType+'''' +'
		
		update OutputKeyMNCsProdPerformance
		set PrevRank=B.Rank 
		from OutputKeyMNCsProdPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(R3M12' +@MoneyType+') desc ) as Rank, a.PROD_cod,sum(R3M12' +@MoneyType+') as R3M12' +@MoneyType+'
			from dbo.MTHCHPA_PKAU A 
			left join dbo.Dim_Product C on A.Prod_cod = c.Product_code
			where CORP_Cod in(select CORP_Cod from OutputKeyMNCsPerformance where Period=''MQT'' and MoneyType='+''''  +@MoneyType+'''' +')
				and c.Product_Name not in (''Albumin human'', ''Pulmicort resp'')
			group by a.PROD_cod) B
		on A.PROD_cod=B.PROD_cod and A.[Period]=''MQT'' and MoneyType='+'''' +@MoneyType+'''' +'

		update OutputKeyMNCsProdPerformance
		set CurrRank=B.Rank 
		from OutputKeyMNCsProdPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(R3M12' +@MoneyType+') desc ) as Rank, a.PROD_cod,sum(R3M12' +@MoneyType+') as R3M12' +@MoneyType+'
			from dbo.MTHCHPA_PKAU A 
			left join dbo.Dim_Product C on A.Prod_cod = c.Product_code
			where CORP_Cod in(select CORP_Cod from OutputKeyMNCsPerformance where Period=''MQT'' and MoneyType='+''''  +@MoneyType+'''' +')
				and c.Product_Name not in (''Albumin human'', ''Pulmicort resp'')
			group by a.PROD_cod) B
		on A.PROD_cod=B.PROD_cod and A.[Period]=''MTH'' and MoneyType='+'''' +@MoneyType+'''' +'
		
		update OutputKeyMNCsProdPerformance
		set PrevRank=B.Rank 
		from OutputKeyMNCsProdPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(R3M12' +@MoneyType+') desc ) as Rank, a.PROD_cod,sum(R3M12' +@MoneyType+') as R3M12' +@MoneyType+'
			from dbo.MTHCHPA_PKAU A 
			left join dbo.Dim_Product C on A.Prod_cod = c.Product_code
			where CORP_Cod in(select CORP_Cod from OutputKeyMNCsPerformance where Period=''MQT'' and MoneyType='+''''  +@MoneyType+'''' +')
				and c.Product_Name not in (''Albumin human'', ''Pulmicort resp'')
			group by a.PROD_cod) B
		on A.PROD_cod=B.PROD_cod and A.[Period]=''MTH'' and MoneyType='+'''' +@MoneyType+'''' +'
		
		update OutputKeyMNCsProdPerformance
		set CurrRank=B.Rank 
		from OutputKeyMNCsProdPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(R3M12' +@MoneyType+') desc ) as Rank, a.PROD_cod,sum(R3M12' +@MoneyType+') as R3M12' +@MoneyType+'
			from dbo.MTHCHPA_PKAU A 
			left join dbo.Dim_Product C on A.Prod_cod = c.Product_code
			where CORP_Cod in(select CORP_Cod from OutputKeyMNCsPerformance where Period=''MQT'' and MoneyType='+''''  +@MoneyType+'''' +')
				and c.Product_Name not in (''Albumin human'', ''Pulmicort resp'')
			group by a.PROD_cod) B
		on A.PROD_cod=B.PROD_cod and A.[Period]=''YTD'' and MoneyType='+'''' +@MoneyType+'''' +'
		
		update OutputKeyMNCsProdPerformance
		set PrevRank=B.Rank 
		from OutputKeyMNCsProdPerformance A 
		inner join (
			select RANK ( )OVER (order by sum(R3M12' +@MoneyType+') desc ) as Rank, a.PROD_cod,sum(R3M12' +@MoneyType+') as R3M12' +@MoneyType+'
			from dbo.MTHCHPA_PKAU A 
			left join dbo.Dim_Product C on A.Prod_cod = c.Product_code
			where CORP_Cod in(select CORP_Cod from OutputKeyMNCsPerformance where Period=''MQT'' and MoneyType='+''''  +@MoneyType+'''' +')
				and c.Product_Name not in (''Albumin human'', ''Pulmicort resp'')
			group by a.PROD_cod) B
		on A.PROD_cod=B.PROD_cod and A.[Period]=''YTD'' and MoneyType='+'''' +@MoneyType+'''' +'
		
		-- production Pulmicort resp, albumin human not in rank 
		update OutputKeyMNCsProdPerformance
		set PrevRank = 99 ,
			CurrRank = 99
		from OutputKeyMNCsProdPerformance A 
		left join dbo.Dim_Product C on A.Prod_cod = c.Product_code
		where c.Product_Name in (''Albumin human'', ''Pulmicort resp'')


		--update Total
		update OutputKeyMNCsProdPerformance
		set Total=B.Total 
		from OutputKeyMNCsProdPerformance A,
			(	select sum(Mat00' +@MoneyType+')  as Total 
				from  dbo.MTHCHPA_PKAU A 
				where CORP_Cod in(select CORP_Cod from OutputKeyMNCsPerformance where Period=''MAT'' and MoneyType='+''''  +@MoneyType+'''' +')
			) B
		where A.MoneyType='+'''' +@MoneyType+'''' +' and Period=''MAT''
	    
        update OutputKeyMNCsProdPerformance
		set Total=B.Total 
		from OutputKeyMNCsProdPerformance A,
			(	select sum(R3M00' +@MoneyType+')  as Total 
				from  dbo.MTHCHPA_PKAU A 
				where CORP_Cod in(select CORP_Cod from OutputKeyMNCsPerformance where Period=''MQT'' and MoneyType='+''''  +@MoneyType+'''' +')
			) B
		where A.MoneyType='+'''' +@MoneyType+'''' +' and Period=''MQT''
		
		update OutputKeyMNCsProdPerformance
		set Total=B.Total 
		from OutputKeyMNCsProdPerformance A,
			(	select sum(MTH00' +@MoneyType+')  as Total 
				from  dbo.MTHCHPA_PKAU A 
				where CORP_Cod in(select CORP_Cod from OutputKeyMNCsPerformance where Period=''MTH'' and MoneyType='+''''  +@MoneyType+'''' +')
			) B
		where A.MoneyType='+'''' +@MoneyType+'''' +' and Period=''MTH''

		update OutputKeyMNCsProdPerformance
		set Total=B.Total 
		from OutputKeyMNCsProdPerformance A,
			(	select sum(YTD00' +@MoneyType+')  as Total 
				from  dbo.MTHCHPA_PKAU A 
				where CORP_Cod in(select CORP_Cod from OutputKeyMNCsPerformance where Period=''YTD'' and MoneyType='+''''  +@MoneyType+'''' +')
			) B
		where A.MoneyType='+'''' +@MoneyType+'''' +' and Period=''YTD''
		'

		exec( @SQL2)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
Alter table OutputKeyMNCsProdPerformance
Add Share float,ShareTotal float,Mat00Growth float
go
update OutputKeyMNCsProdPerformance
set Mat00Growth=case Mat12 when 0 then case Mat00 when 0 then 0 else null end else (Mat00-Mat12)*1.0/Mat12 end
go
update OutputKeyMNCsProdPerformance
set Share = Mat00*1.0/Total
go
update OutputKeyMNCsProdPerformance
set ShareTotal=B.ShareTotal 
from OutputKeyMNCsProdPerformance A 
left join
	(	select Period, MoneyType, sum(Mat00)*1.0/Total as ShareTotal
		from OutputKeyMNCsProdPerformance
		group by Period,MoneyType,total
	) B
on A.[Period]=B.[Period] and A.MoneyType=B.MoneyType
go
update OutputKeyMNCsProdPerformance
set Prod_des=B.product 
from OutputKeyMNCsProdPerformance A 
inner join tblProdDef B
on A.Prod_cod=B.Prod_cod
go
Alter table OutputKeyMNCsProdPerformance Add ChangeRank int
go
update OutputKeyMNCsProdPerformance
set ChangeRank=-sign(CurrRank-PrevRank)
go
update OutputKeyMNCsProdPerformance
set Prod_des=B.newname 
from OutputKeyMNCsProdPerformance A 
inner join tblTextNameRef B
on A.Prod_des=B.oldname
go
--select  *from OutputKeyMNCsProdPerformance







-- exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','OutputCityPerformance',null,null
-- print (N'
-- ------------------------------------------------------------------------------------------------------------
-- 6.                                   Slide 6
-- ------------------------------------------------------------------------------------------------------------
-- ')
-- if exists (select * from dbo.sysobjects where id = object_id(N'OutputCityPerformance') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
-- drop table OutputCityPerformance
-- go
-- CREATE TABLE [dbo].[OutputCityPerformance](
-- 	[Period] [varchar](10) NULL,
--     [MoneyType] [varchar](10) NULL,
-- 	[Audi_cod] [varchar](10) NULL,
-- 	[AUDI_DES] [varchar](100) NULL,
-- 	[MAT00] [float] NULL,
-- 	[MAT12] [float] NULL
-- ) ON [PRIMARY]

-- GO
-- DECLARE TMP_CURSOR CURSOR
-- READ_ONLY
-- FOR select [Type]  from dbo.tblMoneyType
-- DECLARE @MoneyType varchar(10)
-- DECLARE @SQL2 VARCHAR(max)
	
-- OPEN TMP_CURSOR
	
-- FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
-- WHILE (@@FETCH_STATUS <> -1)
-- BEGIN

-- 	IF (@@FETCH_STATUS <> -2)
-- 	BEGIN
-- 		print @MoneyType

-- 		set @SQL2='
-- 		insert into OutputCityPerformance
-- 		select Cast(''MAT'' as varchar(10)) as [Period],'+'''' +@MoneyType+''''+',Audi_cod,'''',sum(MAT00' +@MoneyType+'),sum(MAT12' +@MoneyType+')
-- 		from dbo.MTHCITY_PKAU 
-- 		where audi_cod <>''ZJH_'' and audi_cod <>''GDH_''
-- 		group by Audi_cod

-- 		insert into OutputCityPerformance
-- 		select Cast(''YTD'' as varchar(10)) as [Period],'+'''' +@MoneyType+''''+',Audi_cod,'''',sum(YTD00' +@MoneyType+'),sum(YTD12' +@MoneyType+')
-- 		from dbo.MTHCITY_PKAU 
-- 		where audi_cod <>''ZJH_'' and audi_cod <>''GDH_''
-- 		group by Audi_cod
		
-- 		insert into OutputCityPerformance
-- 		select Cast(''MQT'' as varchar(10)) as [Period],'+'''' +@MoneyType+''''+',Audi_cod,'''',sum(R3M00' +@MoneyType+'),sum(R3M12' +@MoneyType+')
-- 		from dbo.MTHCITY_PKAU 
-- 		where audi_cod <>''ZJH_'' and audi_cod <>''GDH_''
-- 		group by Audi_cod

-- 		insert into OutputCityPerformance
-- 		select Cast(''MTH'' as varchar(10)) as [Period],'+'''' +@MoneyType+''''+',Audi_cod,'''',sum(MTH00' +@MoneyType+'),sum(MTH12' +@MoneyType+')
-- 		from dbo.MTHCITY_PKAU 
-- 		where audi_cod <>''ZJH_'' and audi_cod <>''GDH_''
-- 		group by Audi_cod
-- 		'

-- 		exec( @SQL2)
-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
-- go
-- alter table OutputCityPerformance
-- Add Growth float, Contribution float,PrevContribution float,TotalContribution float
-- go
-- DECLARE TMP_CURSOR CURSOR
-- READ_ONLY
-- FOR select [Type]  from dbo.tblMoneyType
-- DECLARE @MoneyType varchar(10)
-- DECLARE @SQL2 VARCHAR(max)
	
-- OPEN TMP_CURSOR
	
-- FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
-- WHILE (@@FETCH_STATUS <> -1)
-- BEGIN

-- 	IF (@@FETCH_STATUS <> -2)
-- 	BEGIN
-- 		print @MoneyType

-- 		set @SQL2='	
-- 		update OutputCityPerformance
-- 		set Contribution=A.Mat00*1.0/B.Mat00' +@MoneyType+' 
-- 		from OutputCityPerformance A 
-- 		inner join 
-- 			(	select ''MAT'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(Mat00' +@MoneyType+') as  Mat00' +@MoneyType+'
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''YTD'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(YTD00' +@MoneyType+')
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''MQT'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(R3M00' +@MoneyType+')
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''MTH'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(MTH00' +@MoneyType+')
-- 				from MTHCHPA_PKAU
-- 			) B
-- 		on A.Period=B.Period and A.MoneyType=B.MoneyType

-- 		update OutputCityPerformance
-- 		set PrevContribution=A.Mat12*1.0/B.Mat12' +@MoneyType+' 
-- 		from OutputCityPerformance A 
-- 		inner join 
-- 			(	select ''MAT'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(Mat12' +@MoneyType+') as  Mat12' +@MoneyType+'
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''YTD'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(YTD12' +@MoneyType+') as  Mat12' +@MoneyType+'
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''MQT'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(R3M12' +@MoneyType+') as  Mat12' +@MoneyType+'
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''MTH'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(MTH12' +@MoneyType+') as  Mat12' +@MoneyType+'
-- 				from MTHCHPA_PKAU
-- 			) B
-- 		on A.Period=B.Period and A.MoneyType=B.MoneyType

-- 		update OutputCityPerformance
-- 		set TotalContribution=B.Mat00' +@MoneyType+'*1.0/C.Mat00' +@MoneyType+' 
-- 		from OutputCityPerformance A 
-- 		inner join
-- 			(	select MoneyType,Period,sum(Mat00) as  Mat00' +@MoneyType+' 
-- 				from OutputCityPerformance A 
-- 				group by MoneyType,Period
-- 			) B 
-- 		on A.Period=B.Period and A.MoneyType=B.MoneyType 
-- 		inner join 
-- 			(	select ''MAT'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(Mat00' +@MoneyType+') as  Mat00' +@MoneyType+'
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''YTD'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(YTD00' +@MoneyType+')
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''MQT'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(R3M00' +@MoneyType+')
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''MTH'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(MTH00' +@MoneyType+')
-- 				from MTHCHPA_PKAU
-- 			) C
-- 		on C.Period=B.Period and C.MoneyType=B.MoneyType'


-- 		exec( @SQL2)
-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
-- go

-- update OutputCityPerformance
-- set AUDI_des=City_Name 
-- from OutputCityPerformance A 
-- inner join dbo.Dim_City B
-- on A.AUDI_cod=B.City_Code+'_'
-- go
-- update OutputCityPerformance
-- set Growth=case Mat12 when 0 then case Mat00 when 0 then 0 else null end else (Mat00-Mat12)*1.0/Mat12 end
-- where audi_des not in (select audi_des from tblNewCity)
-- go
-- --update OutputCityPerformance
-- --set Mat00=Mat00*1.0/1000000000,
-- --    Mat12=Mat12*1.0/1000000000
-- --go
-- Alter table OutputCityPerformance Add ChangeContribution int
-- go
-- update OutputCityPerformance
-- set ChangeContribution=-sign(Contribution-PrevContribution)
-- go
-- Alter table OutputCityPerformance
-- Add [CurrRank] int,[PrevRank] int,ChangeRank int
-- go
-- update OutputCityPerformance
-- set [CurrRank]=B.Rank 
-- from OutputCityPerformance A 
-- inner join
--     (select Period,MoneyType, Audi_des,Audi_cod, RANK ( )OVER (PARTITION BY Period,MoneyType order by Mat00 desc ) as Rank from OutputCityPerformance where audi_des not in (select audi_des from tblNewCity)) B
-- on A.Period=B.Period and A.MoneyType=B.MoneyType and A.Audi_cod=b.Audi_cod
-- go
-- update OutputCityPerformance
-- set [PrevRank]=B.Rank 
-- from OutputCityPerformance A 
-- inner join
--     (select Period,MoneyType, Audi_cod, RANK ( )OVER (PARTITION BY Period,MoneyType order by Mat12 desc ) as Rank from OutputCityPerformance where audi_des not in (select audi_des from tblNewCity)) B
-- on A.Period=B.Period and A.MoneyType=B.MoneyType and A.Audi_cod=b.Audi_cod
-- go
-- update OutputCityPerformance
-- set ChangeRank=-sign([CurrRank]-[PrevRank]) 
-- where audi_des not in (select audi_des from tblNewCity)
-- go
-- Alter table OutputCityPerformance
-- Add [Avg.Growth] float
-- go
-- update OutputCityPerformance
-- set [Avg.Growth]=B.Growth 
-- from  OutputCityPerformance A 
-- inner join
-- (
-- 	select Period,Moneytype,sum(growth)*1.0/count(*) as Growth
-- 	from OutputCityPerformance where audi_des not in (select audi_des from tblNewCity)
-- 	group by Period,Moneytype 
-- ) B
-- on A.Period=B.Period and A.Moneytype=B.Moneytype








-- exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','OutputCityPerformance_BMS10TA',null,null
-- print (N'
-- ------------------------------------------------------------------------------------------------------------
-- 7.                                   Slide 7 : OutputCityPerformance_BMS10TA
-- ------------------------------------------------------------------------------------------------------------
-- ')
-- if exists (select * from dbo.sysobjects where id = object_id(N'OutputCityPerformance_BMS10TA') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
-- 	drop table OutputCityPerformance_BMS10TA
-- go
-- CREATE TABLE [dbo].[OutputCityPerformance_BMS10TA](
-- 	[Period] [varchar](10) NULL,
--     [MoneyType] [varchar](10) NULL,
-- 	[Audi_cod] [varchar](10) NULL,
-- 	[AUDI_DES] [varchar](100) NULL,
-- 	[MAT00] [float] NULL,
-- 	[MAT12] [float] NULL
-- ) ON [PRIMARY]

-- GO
-- DECLARE TMP_CURSOR CURSOR
-- READ_ONLY
-- FOR select [Type]  from dbo.tblMoneyType
-- DECLARE @MoneyType varchar(10)
-- DECLARE @SQL2 VARCHAR(max)
	
-- OPEN TMP_CURSOR
	
-- FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
-- WHILE (@@FETCH_STATUS <> -1)
-- BEGIN

-- 	IF (@@FETCH_STATUS <> -2)
-- 	BEGIN
-- 		print @MoneyType

-- 		set @SQL2='
-- 		insert into OutputCityPerformance_BMS10TA
-- 		select Cast(''MAT'' as varchar(10)) as [Period],'+'''' +@MoneyType+''''+',Audi_cod,'''',sum(MAT00' +@MoneyType+'),sum(MAT12' +@MoneyType+')
-- 		from dbo.MTHCITY_PKAU A 
-- 		inner join dbo.tblMktDef_BMSFocused10Mkt B on A.PACK_cod=B.PACK_cod
-- 		where A.audi_cod <>''ZJH_'' and a.audi_cod<>''GDH_''
-- 		group by Audi_cod

-- 		insert into OutputCityPerformance_BMS10TA
-- 		select Cast(''YTD'' as varchar(10)) as [Period],'+'''' +@MoneyType+''''+',Audi_cod,'''',sum(YTD00' +@MoneyType+'),sum(YTD12' +@MoneyType+')
-- 		from dbo.MTHCITY_PKAU A 
-- 		inner join tblMktDef_BMSFocused10Mkt B on A.PACK_cod=B.PACK_cod
-- 		where A.audi_cod <>''ZJH_'' and a.audi_cod<>''GDH_''
-- 		group by Audi_cod
		
-- 		insert into OutputCityPerformance_BMS10TA
-- 		select Cast(''MQT'' as varchar(10)) as [Period],'+'''' +@MoneyType+''''+',Audi_cod,'''',sum(R3M00' +@MoneyType+'),sum(R3M12' +@MoneyType+')
-- 		from dbo.MTHCITY_PKAU A 
-- 		inner join tblMktDef_BMSFocused10Mkt B on A.PACK_cod=B.PACK_cod
-- 		where A.audi_cod <>''ZJH_'' and a.audi_cod<>''GDH_''
-- 		group by Audi_cod
		
-- 		insert into OutputCityPerformance_BMS10TA
-- 		select Cast(''MTH'' as varchar(10)) as [Period],'+'''' +@MoneyType+''''+',Audi_cod,'''',sum(MTH00' +@MoneyType+'),sum(MTH12' +@MoneyType+')
-- 		from dbo.MTHCITY_PKAU A 
-- 		inner join tblMktDef_BMSFocused10Mkt B on A.PACK_cod=B.PACK_cod
-- 		where A.audi_cod <>''ZJH_'' and a.audi_cod<>''GDH_''
-- 		group by Audi_cod
		
-- 		'

-- 		exec( @SQL2)
-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
-- go
-- alter table OutputCityPerformance_BMS10TA
-- Add Growth float, Contribution float,PrevContribution float,TotalContribution float
-- go
-- DECLARE TMP_CURSOR CURSOR
-- READ_ONLY
-- FOR select [Type]  from dbo.tblMoneyType
-- DECLARE @MoneyType varchar(10)
-- DECLARE @SQL2 VARCHAR(max)
	
-- OPEN TMP_CURSOR
	
-- FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
-- WHILE (@@FETCH_STATUS <> -1)
-- BEGIN

-- 	IF (@@FETCH_STATUS <> -2)
-- 	BEGIN


-- 		set @SQL2='	
-- 		update OutputCityPerformance_BMS10TA
-- 		set Contribution=A.Mat00*1.0/B.Mat00' +@MoneyType+' 
-- 		from OutputCityPerformance_BMS10TA A 
-- 		inner join 
-- 			(	select ''MAT'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(Mat00' +@MoneyType+') as  Mat00' +@MoneyType+'
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''YTD'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(YTD00' +@MoneyType+')
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''MQT'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(R3M00' +@MoneyType+')
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''MTH'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(MTH00' +@MoneyType+')
-- 				from MTHCHPA_PKAU
-- 			) B
-- 		on A.Period=B.Period and A.MoneyType=B.MoneyType

-- 		update OutputCityPerformance_BMS10TA
-- 		set PrevContribution=A.Mat12*1.0/B.Mat12' +@MoneyType+' 
-- 		from OutputCityPerformance_BMS10TA A 
-- 		inner join 
-- 			(	select ''MAT'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(Mat12' +@MoneyType+') as  Mat12' +@MoneyType+'
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''YTD'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(YTD12' +@MoneyType+') as  Mat12' +@MoneyType+'
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''MQT'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(R3M12' +@MoneyType+') as  Mat12' +@MoneyType+'
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''MTH'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(MTH12' +@MoneyType+') as  Mat12' +@MoneyType+'
-- 				from MTHCHPA_PKAU
-- 			) B
-- 		on A.Period=B.Period and A.MoneyType=B.MoneyType

-- 		update OutputCityPerformance_BMS10TA
-- 		set TotalContribution=B.Mat00' +@MoneyType+'*1.0/C.Mat00' +@MoneyType+' 
-- 		from OutputCityPerformance_BMS10TA A 
-- 		inner join
-- 			(	select MoneyType,Period,sum(Mat00) as  Mat00' +@MoneyType+' 
-- 				from OutputCityPerformance_BMS10TA A group by MoneyType,Period
-- 			) B 
-- 		on A.Period=B.Period and A.MoneyType=B.MoneyType inner join 
-- 			(	select ''MAT'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(Mat00' +@MoneyType+') as  Mat00' +@MoneyType+'
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''YTD'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(YTD00' +@MoneyType+')
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''MQT'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(R3M00' +@MoneyType+')
-- 				from MTHCHPA_PKAU
-- 				union
-- 				select ''MTH'' as Period,'+'''' +@MoneyType+''''+' as MoneyType,sum(MTH00' +@MoneyType+')
-- 				from MTHCHPA_PKAU
-- 			) C
-- 		on C.Period=B.Period and C.MoneyType=B.MoneyType'


-- 		exec( @SQL2)
-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
-- go
-- update OutputCityPerformance_BMS10TA
-- set AUDI_des=City_Name 
-- from OutputCityPerformance_BMS10TA A 
-- inner join dbo.Dim_City B
-- on A.AUDI_cod=B.City_Code+'_'
-- go
-- update OutputCityPerformance_BMS10TA
-- set Growth=case Mat12 when 0 then case Mat00 when 0 then 0 else null end else (Mat00-Mat12)*1.0/Mat12 end 
-- where audi_des not in (select audi_des from tblNewCity)
-- go

-- --update OutputCityPerformance_BMS10TA
-- --set Mat00=Mat00*1.0/1000000000,
-- --    Mat12=Mat12*1.0/1000000000
-- --go
-- Alter table OutputCityPerformance_BMS10TA Add ChangeContribution int
-- go
-- update OutputCityPerformance_BMS10TA
-- set ChangeContribution=-sign(Contribution-PrevContribution)
-- go

-- Alter table OutputCityPerformance_BMS10TA
-- Add [CurrRank] int,[PrevRank] int, ChangeRank int
-- go

-- update OutputCityPerformance_BMS10TA
-- set [CurrRank]=B.Rank 
-- from OutputCityPerformance_BMS10TA A 
-- inner join
--     (	select Period,MoneyType, Audi_cod, RANK ( )OVER (PARTITION BY Period,MoneyType order by Mat00 desc ) as Rank 
-- 		from OutputCityPerformance_BMS10TA 
-- 		where audi_des not in (select audi_des from tblNewCity)
-- 	) B
-- on A.Period=B.Period and A.MoneyType=B.MoneyType and A.Audi_cod=b.Audi_cod
-- go

-- update OutputCityPerformance_BMS10TA
-- set [PrevRank]=B.Rank 
-- from OutputCityPerformance_BMS10TA A 
-- inner join
--     (	select Period,MoneyType, Audi_cod, RANK ( )OVER (PARTITION BY Period,MoneyType order by Mat12 desc ) as Rank 
-- 		from OutputCityPerformance_BMS10TA 
-- 		where audi_des not in (select audi_des from tblNewCity)
-- 	) B
-- on A.Period=B.Period and A.MoneyType=B.MoneyType and A.Audi_cod=b.Audi_cod
-- go

-- update OutputCityPerformance_BMS10TA
-- set ChangeRank=-sign([CurrRank]-PrevRank) 
-- where audi_des not in (select audi_des from tblNewCity)
-- go

-- Alter table OutputCityPerformance_BMS10TA
-- Add [Avg.Growth] float
-- go

-- update OutputCityPerformance_BMS10TA
-- set [Avg.Growth]=B.Growth 
-- from  OutputCityPerformance_BMS10TA A 
-- inner join
-- (	select Period,Moneytype,sum(growth)*1.0/count(*) as Growth
-- 	from OutputCityPerformance_BMS10TA 
-- 	where audi_des not in (select audi_des from tblNewCity)
-- 	group by Period,Moneytype ) B
-- on A.Period=B.Period and A.Moneytype=B.Moneytype




-- exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','OutputBMSProdSummaryInChina',null,null

-- print (N'
-- ------------------------------------------------------------------------------------------------------------
-- 8.                                   Slide 8 : OutputBMSProdSummaryInChina
-- ------------------------------------------------------------------------------------------------------------
-- ')
-- if exists (select * from dbo.sysobjects where id = object_id(N'OutputBMSProdSummaryInChina') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
-- 	drop table OutputBMSProdSummaryInChina
-- go
-- CREATE TABLE [dbo].OutputBMSProdSummaryInChina(
--     [Type] [varchar](50) NULL,
-- 	[Period] [varchar](20)  NULL,
-- 	[MoneyType] [varchar](20)  NULL,
-- 	[Prod_cod] [varchar](10) NULL,
-- 	[Prod_des] [varchar](100)  NULL,
-- 	[Mat00] [float] NULL,
-- 	[Mat12] [float] NULL
-- ) ON [PRIMARY]

-- GO
-- DECLARE TMP_CURSOR CURSOR
-- READ_ONLY
-- FOR select [Type]  from dbo.tblMoneyType
-- DECLARE @MoneyType varchar(10)
-- DECLARE @SQL2 VARCHAR(max)
	
-- OPEN TMP_CURSOR
	
-- FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
-- WHILE (@@FETCH_STATUS <> -1)
-- BEGIN

-- 	IF (@@FETCH_STATUS <> -2)
-- 	BEGIN


-- 		set @SQL2='
-- 		insert into OutputBMSProdSummaryInChina
-- 		select ''Product'',''MAT'','+'''' +@MoneyType+''''+',a.prod_cod,'''',sum(mat00' +@MoneyType+'),sum(mat12' +@MoneyType+') 
-- 		from mthchpa_pkau A 
-- 		where A.prod_cod in
-- 				(	select distinct B.PRod_cod 
-- 					from tblMktDef_MRBIChina A 
-- 					inner join tblProddef B on A.productname=B.Product
-- 					where A.prod=''100'' and A.productname<>''Onglyza'')
-- 		group by A.prod_cod

-- 		insert into OutputBMSProdSummaryInChina
-- 		select ''Market'',''MAT'','+'''' +@MoneyType+''''+',B.mkt,'''',sum(mat00' +@MoneyType+'),sum(mat12' +@MoneyType+') 
-- 		from mthchpa_pkau A 
-- 		inner join tblMktDef_MRBIChina B
-- 		on A.pack_cod=b.pack_cod
-- 		where B.prod=''000'' and B.mkt in(''NIAD'',''ARV'',''ONCFCS'',''HYP'',''CCB'',''Platinum'') and Molecule=''N'' and Class=''N''
-- 		group by B.mkt

-- 		insert into OutputBMSProdSummaryInChina
-- 		select ''Product'',''MQT'','+'''' +@MoneyType+''''+',a.prod_cod,'''',sum(R3M00' +@MoneyType+'),sum(R3M12' +@MoneyType+') 
-- 		from mthchpa_pkau A 
-- 		where A.prod_cod in
-- 				(	select distinct B.PRod_cod 
-- 					from tblMktDef_MRBIChina A 
-- 					inner join tblProddef B on A.productname=B.Product
-- 					where A.prod=''100'' and A.productname<>''Onglyza'')
-- 		group by A.prod_cod

-- 		insert into OutputBMSProdSummaryInChina
-- 		select ''Market'',''MQT'','+'''' +@MoneyType+''''+',B.mkt,'''',sum(R3M00' +@MoneyType+'),sum(R3M12' +@MoneyType+') 
-- 		from mthchpa_pkau A 
-- 		inner join tblMktDef_MRBIChina B
-- 		on A.pack_cod=b.pack_cod
-- 		where B.prod=''000'' and B.mkt in(''NIAD'',''ARV'',''ONCFCS'',''HYP'',''CCB'',''Platinum'') and Molecule=''N'' and Class=''N''
-- 		group by B.mkt

-- 		insert into OutputBMSProdSummaryInChina
-- 		select ''Product'',''MTH'','+'''' +@MoneyType+''''+',a.prod_cod,'''',sum(MTH00' +@MoneyType+'),sum(MTH12' +@MoneyType+') 
-- 		from mthchpa_pkau A 
-- 		where A.prod_cod in
-- 				(	select distinct B.PRod_cod 
-- 					from tblMktDef_MRBIChina A 
-- 					inner join tblProddef B on A.productname=B.Product
-- 					where A.prod=''100'' and A.productname<>''Onglyza'')
-- 		group by A.prod_cod

-- 		insert into OutputBMSProdSummaryInChina
-- 		select ''Market'',''MTH'','+'''' +@MoneyType+''''+',B.mkt,'''',sum(MTH00' +@MoneyType+'),sum(MTH12' +@MoneyType+') 
-- 		from mthchpa_pkau A 
-- 		inner join tblMktDef_MRBIChina B
-- 		on A.pack_cod=b.pack_cod
-- 		where B.prod=''000'' and B.mkt in(''NIAD'',''ARV'',''ONCFCS'',''HYP'',''CCB'',''Platinum'') and Molecule=''N'' and Class=''N''
-- 		group by B.mkt

-- 		insert into OutputBMSProdSummaryInChina
-- 		select ''Product'',''YTD'','+'''' +@MoneyType+''''+',a.prod_cod,'''',sum(YTD00' +@MoneyType+'),sum(YTD12' +@MoneyType+') 
-- 		from mthchpa_pkau A 
-- 		where A.prod_cod in
-- 				(select distinct B.PRod_cod from tblMktDef_MRBIChina A inner join tblProddef B
-- 				on A.productname=B.Product
-- 				where A.prod=''100'' and A.productname<>''Onglyza'')
-- 		group by A.prod_cod

-- 		insert into OutputBMSProdSummaryInChina
-- 		select ''Market'',''YTD'','+'''' +@MoneyType+''''+',B.mkt,'''',sum(YTD00' +@MoneyType+'),sum(YTD12' +@MoneyType+') 
-- 		from mthchpa_pkau A inner join tblMktDef_MRBIChina B
-- 		on A.pack_cod=b.pack_cod
-- 		where  B.prod=''000'' and B.mkt in(''NIAD'',''ARV'',''ONCFCS'',''HYP'',''CCB'',''Platinum'') and Molecule=''N'' and Class=''N''
-- 		group by B.mkt'


-- 		exec( @SQL2)
-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
-- go
-- delete from OutputBMSProdSummaryInChina where Prod_cod='ACE'
-- go
-- alter table OutputBMSProdSummaryInChina
-- Add Growth float
-- go
-- update OutputBMSProdSummaryInChina
-- set Growth=case Mat12 when 0 then case Mat00 when 0 then 0 else null end else (Mat00-Mat12)*1.0/Mat12 end
-- go
-- update OutputBMSProdSummaryInChina
-- set Prod_des=
-- 	case Prod_cod 
-- 		when 'ACE' then 'Monopril' 
-- 		when 'ARV' then 'Baraclude' 
-- 		when 'NIAD' then 'Glucophage'
-- 		when 'ONCFCS' then 'Taxol'
-- 		when 'HYP' then 'Monopril' when 'DPP4' then 'Onglyza' 
-- 		when 'Platinum' then 'Paraplatin'
-- 		when 'CCB' then 'Coniel'
-- 		else Prod_cod end
-- go
-- update OutputBMSProdSummaryInChina
-- set Prod_cod=case Prod_des 
-- 				when 'Baraclude' then 1 
-- 				when 'Glucophage' then 2 when 'Monopril' then 3 
-- 				when 'Onglyza' then 5 when 'Taxol' then 4 
-- 				when 'Paraplatin' then 6
-- 				when 'Coniel' then 7
-- 				else Prod_cod end
-- GO
-- update OutputBMSProdSummaryInChina
-- set Prod_des=B.product from OutputBMSProdSummaryInChina A inner join
-- dbo.tblProdDef B
-- on A.Prod_des=B.prod_cod
-- go
-- alter table OutputBMSProdSummaryInChina
-- Add MarketShare float
-- go


-- delete 
-- from OutputBMSProdSummaryInChina 
-- where Prod_Des<>'Paraplatin' and MoneyType='PN'
-- go

-- update OutputBMSProdSummaryInChina
-- set MarketShare=B.MarketShare from OutputBMSProdSummaryInChina A inner join
-- (
-- 	select B.[Type],B.Period,B.MoneyType,B.prod_cod,B.prod_des,A.mat00*1.0/B.mat00 as MarketShare 
-- 	from OutputBMSProdSummaryInChina A 
-- 	inner join OutputBMSProdSummaryInChina B
-- 	on A.Period=B.Period and A.MoneyType=B.MoneyType and A.prod_des=b.prod_des
-- 	where A.[type]='Product' and  B.[type]='Market'
-- ) B
-- on A.Period=B.Period and A.MoneyType=B.MoneyType and A.prod_des=b.prod_des
-- 	and A.[type]=b.[type]

-- --when Onglyza have 6 month data, need delete the following sql.
-- go
-- --update OutputBMSProdSummaryInChina
-- --set Growth=null where Prod_des='Onglyza' and [Type]='Product'
-- --go




exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','inHKAPI_New',null,null

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
	[YTD00US] float,
	[YTD12US] float,
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
    [YTD00US]=isnull(1.0*[YTD 16Q4LC]/(select rate from tblrate),0),
    [YTD12US]=isnull(1.0*[YTD 15Q4LC]/(select rate from tblrate),0),
    [LastYear00LC]=isnull([YTD 15Q4LC],0),
    [LastYear12LC]=isnull([YTD 14Q4LC],0),
    [LastYear00US]=isnull(1.0*[YTD 15Q4LC]/(select rate from tblrate),0),
    [LastYear12US]=isnull(1.0*[YTD 14Q4LC]/(select rate from tblrate),0),
    [MAT00LC]=isnull([16Q1LC],0)+isnull([16Q3LC],0)+isnull([16Q2LC],0)+isnull([16Q4LC],0),
    [MAT12LC]=isnull([15Q1LC],0)+isnull([15Q3LC],0)+isnull([15Q2LC],0)+isnull([15Q4LC],0),
    [MAT24LC]=isnull([14Q1LC],0)+isnull([14Q3LC],0)+isnull([14Q2LC],0)+isnull([14Q4LC],0),
    [MAT36LC]=isnull([13Q1LC],0)+isnull([13Q3LC],0)+isnull([13Q2LC],0)+isnull([13Q4LC],0),
    [MAT48LC]=isnull([12Q1LC],0)+isnull([12Q3LC],0)+isnull([12Q2LC],0)+isnull([12Q4LC],0),    
    [MAT00US]=isnull([16Q1US],0)+isnull([16Q3US],0)+isnull([16Q2US],0)+isnull([16Q4US],0),
    [MAT12US]=isnull([15Q1US],0)+isnull([15Q3US],0)+isnull([15Q2US],0)+isnull([15Q4US],0),
    [MAT24US]=isnull([14Q1US],0)+isnull([14Q3US],0)+isnull([14Q2US],0)+isnull([14Q4US],0),
    [MAT36US]=isnull([13Q1US],0)+isnull([13Q3US],0)+isnull([13Q2US],0)+isnull([13Q4US],0),
    [MAT48US]=isnull([12Q1US],0)+isnull([12Q3US],0)+isnull([12Q2US],0)+isnull([12Q4US],0)
    
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
	'YTD', 'RMB', [company name], 1, 1, sum(isnull([YTD00LC],0))*1000, sum(isnull([YTD12LC],0))*1000
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
(	select sum(isnull([YTD00LC],0))*1000 as sales from inHKAPI_New
) B
where A.[Period]='YTD'

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
 ,sum(isnull([LastYear12LC],0))*1000  --Mat12： [LastYear12LC]=isnull([11Q1LC],0)
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
from [OutputKeyMNCsPerformance_HKAPI] A ,(select sum(isnull([LastYear00LC],0))*1000 as sales from inHKAPI_New) B
where A.[Period]='Last Year'
go

update OutputKeyMNCsPerformance_HKAPI
set CurrRank=B.rank
from OutputKeyMNCsPerformance_HKAPI A inner join(
select Period,Moneytype,corp_cod,RANK ( )OVER (PARTITION BY Period,Moneytype order by Mat00 desc) as Rank
 from OutputKeyMNCsPerformance_HKAPI) B
on A.Period=B.Period and A.Moneytype=B.Moneytype and A.corp_cod=B.corp_cod
go
update OutputKeyMNCsPerformance_HKAPI
set PrevRank=B.rank
from OutputKeyMNCsPerformance_HKAPI A inner join(
select Period,Moneytype,corp_cod,RANK ( )OVER (PARTITION BY Period,Moneytype order by Mat12 desc) as Rank
 from OutputKeyMNCsPerformance_HKAPI) B
on A.Period=B.Period and A.Moneytype=B.Moneytype and A.corp_cod=B.corp_cod
go
Alter table OutputKeyMNCsPerformance_HKAPI Add Share float,ShareTotal float,Mat00Growth float
go
update OutputKeyMNCsPerformance_HKAPI
set Mat00Growth=case Mat12 when 0 then case Mat00 when 0 then 0 else null end else (Mat00-Mat12)*1.0/Mat12 end

update OutputKeyMNCsPerformance_HKAPI
set Share=Mat00*1.0/Total


update OutputKeyMNCsPerformance_HKAPI
set ShareTotal=B.ShareTotal from OutputKeyMNCsPerformance_HKAPI A left join
    (select Period,MoneyType,sum(Mat00)*1.0/Total as ShareTotal
     from OutputKeyMNCsPerformance_HKAPI group by Period,MoneyType,total) B
on A.[Period]=B.[Period] and A.MoneyType=B.MoneyType
go
update OutputKeyMNCsPerformance_HKAPI
set CORP_des= case when B.[Company Name] is null then a.corp_cod else b.[Company Name] end from OutputKeyMNCsPerformance_HKAPI A left join 
BMSChinaOtherDB.dbo.HKAPI_CompanyName B
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
if exists(select * from [OutputKeyMNCsProdPerformance_HKAPI] 
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
set [Total]=B.sales 
from [OutputKeyMNCsProdPerformance_HKAPI] A ,
(	select sum(isnull([YTD00LC],0))*1000 as sales
	from inHKAPI_New
	where [Company name] in (select CORP_Cod from OutputKeyMNCsPerformance_HKAPI where Period='YTD')
) B
where A.[Period]='YTD'

--Last Year
insert into [OutputKeyMNCsProdPerformance_HKAPI]
	([Period],[MoneyType],[Prod_cod],[CurrRank],[PrevRank],[Mat00],[Mat12])
select top 10 'Last Year','RMB', [Product name],1,1,sum(isnull([LastYear00LC],0))*1000,sum(isnull([LastYear12LC],0))*1000
from inHKAPI_New
where [Company name] in (select CORP_Cod from OutputKeyMNCsPerformance_HKAPI where Period='Last Year')
group by [Product name]
order by sum(isnull([LastYear00LC],0)) desc
go
if exists(	select * from [OutputKeyMNCsProdPerformance_HKAPI] 
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
set [Total]=B.sales 
from [OutputKeyMNCsProdPerformance_HKAPI] A ,
(	select sum(isnull([LastYear00LC],0))*1000 as sales
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
	from [OutputKeyMNCsProdPerformance_HKAPI]
	) B
on A.Period=B.Period and A.Moneytype=B.Moneytype and A.Prod_cod=B.Prod_cod
go
update [OutputKeyMNCsProdPerformance_HKAPI]
set PrevRank=B.rank
from [OutputKeyMNCsProdPerformance_HKAPI] A 
inner join(
	select Period,Moneytype,Prod_cod,RANK ( )OVER (PARTITION BY Period,Moneytype order by Mat12 desc) as Rank
	from [OutputKeyMNCsProdPerformance_HKAPI]
	) B
on A.Period=B.Period and A.Moneytype=B.Moneytype and A.Prod_cod=B.Prod_cod

go
Alter table [OutputKeyMNCsProdPerformance_HKAPI] Add Share float,ShareTotal float,Mat00Growth float
go
update [OutputKeyMNCsProdPerformance_HKAPI]
set Mat00Growth=case Mat12 when 0 then case Mat00 when 0 then 0 else null end else (Mat00-Mat12)*1.0/Mat12 end

update [OutputKeyMNCsProdPerformance_HKAPI]
set Share=Mat00*1.0/Total


update [OutputKeyMNCsProdPerformance_HKAPI]
set ShareTotal=B.ShareTotal 
from [OutputKeyMNCsProdPerformance_HKAPI] A 
left join
(	select Period,MoneyType,sum(Mat00)*1.0/Total as ShareTotal
    from [OutputKeyMNCsProdPerformance_HKAPI] group by Period,MoneyType,total
) B
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





exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','OutputProdSalesPerformanceInChina',null,null
print (N'
------------------------------------------------------------------------------------------------------------
11.                                   Slide 12 : OutputProdSalesPerformanceInChina
------------------------------------------------------------------------------------------------------------
')

if exists (select * from dbo.sysobjects where id = object_id(N'OutputProdSalesPerformanceInChina') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputProdSalesPerformanceInChina
go
CREATE TABLE [dbo].OutputProdSalesPerformanceInChina(
    [TypeIdx] int,
    [Type] [varchar](50) NULL,
	[Period] [varchar](20)  NULL,
	[MoneyType] [varchar](20)  NULL,
	[Market] [varchar](20)  NULL,
	[Prod_cod] [varchar](20) NULL,
	[Prod_des] [varchar](100)  NULL,
	[Mat00] [float] NULL,
	[Mat12] [float] NULL,
	[Mat24] [float] NULL,
	[Mat36] [float] NULL,
	[Mat48] [float] NULL,

	[MQT00] [float] NULL,
	[MQT12] [float] NULL,
	[MQT24] [float] NULL,
	[MQT36] [float] NULL,
	[MQT48] [float] NULL,

	[YTD00] [float] NULL,
	[YTD12] [float] NULL,
	[YTD24] [float] NULL,
	[YTD36] [float] NULL,
	[YTD48] [float] NULL,

    [Mth06] [float] NULL,
	[Mth07] [float] NULL,
	[Mth08] [float] NULL,
	[Mth09] [float] NULL,
	[Mth10] [float] NULL,
	[Mth11] [float] NULL,
	[Mth12] [float] NULL,
	[Mth13] [float] NULL,
	[Mth14] [float] NULL,
	[Mth15] [float] NULL,
	[Mth16] [float] NULL,
	[Mth17] [float] NULL,
    [Mth18] [float] NULL,
	[Mth19] [float] NULL,
	[Mth20] [float] NULL,
	[Mth21] [float] NULL,
	[Mth22] [float] NULL,
	[Mth23] [float] NULL,
	[Mth24] [float] NULL	
) ON [PRIMARY]

GO
-- for not eliquis mkt 
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @Rat varchar(10)
DECLARE @SQL2 VARCHAR(max)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		if @MoneyType='UN'
			set @Rat='/(b.Rat)'
		else  set @Rat=''
		set @SQL2='
		insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[Mat00],[Mat12],[Mat24],[Mat36],[Mat48])
		select 1,''Product'',''MAT'','+'''' +@MoneyType+''''+',B.mkt,a.prod_cod,''''
			,sum(mat00' +@MoneyType+@Rat+'),sum(mat12' +@MoneyType+@Rat+'),sum(mat24' +@MoneyType+@Rat+')
			,sum(mat36' +@MoneyType+@Rat+') ,sum(mat48' +@MoneyType+@Rat+')
		from mthchpa_pkau A 
		inner join
		(	select distinct A.mkt,B.PRod_cod,a.pack_cod,a.Rat 
			from tblMktDef_MRBIChina A 
			inner join tblProddef B on A.productname=B.Product
			where A.prod=''100'' and a.mkt not like ''eliquis%'') B
        on A.pack_cod=B.pack_cod
        group by B.mkt,a.prod_cod

		insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[Mat00],[Mat12],[Mat24],[Mat36],[Mat48])
		select 3,''Market Size'',''MAT'','+'''' +@MoneyType+''''+',B.mkt,B.mkt,''''
			,sum(mat00' +@MoneyType+@Rat+'),sum(mat12' +@MoneyType+@Rat+'),sum(mat24' +@MoneyType+@Rat+')
			,sum(mat36' +@MoneyType+@Rat+') ,sum(mat48' +@MoneyType+@Rat+')
		from mthchpa_pkau A 
		inner join tblMktDef_MRBIChina B on A.pack_cod=b.pack_cod
		where B.prod=''000'' and B.mkt in(''DPP4'',''NIAD'',''ARV'',''ONCFCS'',''HYP'',''CCB'',''Platinum'') and Molecule=''N'' and Class=''N'' and B.Active=''Y''
		group by B.mkt

		insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[MQT00],[MQT12],[MQT24],[MQT36],[MQT48])
		select 1,''Product'',''MQT'','+'''' +@MoneyType+''''+',B.mkt,a.prod_cod,''''
			,sum(R3M00' +@MoneyType+@Rat+'),sum(R3M12' +@MoneyType+@Rat+'),sum(R3M24' +@MoneyType+@Rat+')
			,sum(R3M36' +@MoneyType+@Rat+') ,sum(R3M48' +@MoneyType+@Rat+')
		from mthchpa_pkau A 
		inner join
		(	select distinct A.mkt,B.PRod_cod,a.pack_cod,a.Rat 
			from tblMktDef_MRBIChina A 
			inner join tblProddef B on A.productname=B.Product
			where A.prod=''100'' and a.mkt not like ''eliquis%'') B
        on A.pack_cod=B.pack_cod
        group by B.mkt,a.prod_cod

		insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[MQT00],[MQT12],[MQT24],[MQT36],[MQT48])
		select 3,''Market Size'',''MQT'','+'''' +@MoneyType+''''+',B.mkt,B.mkt,''''
			,sum(R3M00' +@MoneyType+@Rat+'),sum(R3M12' +@MoneyType+@Rat+'),sum(R3M24' +@MoneyType+@Rat+')
			,sum(R3M36' +@MoneyType+@Rat+') ,sum(R3M48' +@MoneyType+@Rat+')
		from mthchpa_pkau A 
		inner join tblMktDef_MRBIChina B on A.pack_cod=b.pack_cod
		where B.prod=''000'' and B.mkt in(''DPP4'',''NIAD'',''ARV'',''ONCFCS'',''HYP'',''CCB'',''Platinum'') and Molecule=''N'' and Class=''N'' and B.Active=''Y''
		group by B.mkt

		insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[YTD00],[YTD12],[YTD24],[YTD36],[YTD48])
		select 1,''Product'',''YTD'','+'''' +@MoneyType+''''+',B.mkt,a.prod_cod,''''
			,sum(YTD00' +@MoneyType+@Rat+'),sum(YTD12' +@MoneyType+@Rat+') ,sum(YTD24' +@MoneyType+@Rat+')
			,sum(YTD36' +@MoneyType+@Rat+') ,sum(YTD48' +@MoneyType+@Rat+')
		from mthchpa_pkau A 
		inner join
		(	select distinct A.mkt,B.PRod_cod,a.pack_cod,a.Rat 
			from tblMktDef_MRBIChina A inner join tblProddef B
			on A.productname=B.Product
			where A.prod=''100''and a.mkt not like ''eliquis%'') B
        on A.pack_cod=B.pack_cod
        group by B.mkt,a.prod_cod


		insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[YTD00],[YTD12],[YTD24],[YTD36],[YTD48])
		select 3, ''Market Size'',''YTD'','+'''' +@MoneyType+''''+',B.mkt,B.mkt,''''
			,sum(YTD00' +@MoneyType+@Rat+'),sum(YTD12' +@MoneyType+@Rat+') ,sum(YTD24' +@MoneyType+@Rat+')
			,sum(YTD36' +@MoneyType+@Rat+') ,sum(YTD48' +@MoneyType+@Rat+')
		from mthchpa_pkau A 
		inner join tblMktDef_MRBIChina B on A.pack_cod=b.pack_cod
		where B.prod=''000'' and B.mkt in(''DPP4'',''NIAD'',''ARV'',''ONCFCS'',''HYP'',''CCB'',''Platinum'') and Molecule=''N'' and Class=''N''and B.Active=''Y''
		group by B.mkt
		'
	    print @SQL2
		exec( @SQL2)

       set @SQL2='insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[Mat00],[Mat12],[Mat24],[Mat36],[Mat48],
	   		[Mth06], [Mth07], [Mth08], [Mth09], [Mth10], [Mth11], [Mth12], [Mth13], [Mth14], [Mth15], [Mth16], [Mth17], [Mth18], [Mth19], [Mth20], [Mth21], [Mth22], [Mth23], [Mth24])
		select 1,''Product'',''MTH'','+'''' +@MoneyType+''''+',B.mkt,a.prod_cod,''''
			,sum(MTH00' +@MoneyType+@Rat+')
			,sum(MTH01' +@MoneyType+@Rat+')
			,sum(MTH02' +@MoneyType+@Rat+')
			,sum(MTH03' +@MoneyType+@Rat+')
			,sum(MTH04' +@MoneyType+@Rat+')
			,sum(MTH05' +@MoneyType+@Rat+')
			,sum(MTH06' +@MoneyType+@Rat+')
			,sum(MTH07' +@MoneyType+@Rat+')
			,sum(MTH08' +@MoneyType+@Rat+')
			,sum(MTH09' +@MoneyType+@Rat+')
			,sum(MTH10' +@MoneyType+@Rat+')
			,sum(MTH11' +@MoneyType+@Rat+')
			
			,sum(MTH12' +@MoneyType+@Rat+')		
			,sum(MTH13' +@MoneyType+@Rat+')
			,sum(MTH14' +@MoneyType+@Rat+')
			,sum(MTH15' +@MoneyType+@Rat+')
			,sum(MTH16' +@MoneyType+@Rat+')
			,sum(MTH17' +@MoneyType+@Rat+')
			,sum(MTH18' +@MoneyType+@Rat+')
			,sum(MTH19' +@MoneyType+@Rat+')
			,sum(MTH20' +@MoneyType+@Rat+')
			,sum(MTH21' +@MoneyType+@Rat+')
			,sum(MTH22' +@MoneyType+@Rat+')
			,sum(MTH23' +@MoneyType+@Rat+')		
		from mthchpa_pkau A 
		inner join
		(	select distinct A.mkt,B.PRod_cod ,a.pack_cod,a.Rat 
			from tblMktDef_MRBIChina A 
			inner join tblProddef B
			on A.productname=B.Product
			where A.prod=''100'' and a.mkt not like ''eliquis%'' 
		) B
        on A.pack_cod=B.pack_cod
        group by B.mkt,a.prod_cod


		insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[Mat00],[Mat12],[Mat24],[Mat36],[Mat48],
	   		[Mth06], [Mth07], [Mth08], [Mth09], [Mth10], [Mth11], [Mth12], [Mth13], [Mth14], [Mth15], [Mth16], [Mth17], [Mth18], [Mth19], [Mth20], [Mth21], [Mth22], [Mth23], [Mth24])
		select 3,''Market Size'',''MTH'','+'''' +@MoneyType+''''+',B.mkt,B.mkt,''''
			,sum(MTH00' +@MoneyType+@Rat+')
			,sum(MTH01' +@MoneyType+@Rat+')
			,sum(MTH02' +@MoneyType+@Rat+')
			,sum(MTH03' +@MoneyType+@Rat+')
			,sum(MTH04' +@MoneyType+@Rat+')
			,sum(MTH05' +@MoneyType+@Rat+')
			,sum(MTH06' +@MoneyType+@Rat+')
			,sum(MTH07' +@MoneyType+@Rat+')
			,sum(MTH08' +@MoneyType+@Rat+')
			,sum(MTH09' +@MoneyType+@Rat+')
			,sum(MTH10' +@MoneyType+@Rat+')
			,sum(MTH11' +@MoneyType+@Rat+')
			
			,sum(MTH12' +@MoneyType+@Rat+')		
			,sum(MTH13' +@MoneyType+@Rat+')
			,sum(MTH14' +@MoneyType+@Rat+')
			,sum(MTH15' +@MoneyType+@Rat+')
			,sum(MTH16' +@MoneyType+@Rat+')
			,sum(MTH17' +@MoneyType+@Rat+')
			,sum(MTH18' +@MoneyType+@Rat+')
			,sum(MTH19' +@MoneyType+@Rat+')
			,sum(MTH20' +@MoneyType+@Rat+')
			,sum(MTH21' +@MoneyType+@Rat+')
			,sum(MTH22' +@MoneyType+@Rat+')
			,sum(MTH23' +@MoneyType+@Rat+')			
		from mthchpa_pkau A 
		inner join tblMktDef_MRBIChina B
		on A.pack_cod=b.pack_cod
		where B.prod=''000'' and B.mkt in(''DPP4'',''NIAD'',''ARV'',''ONCFCS'',''HYP'',''CCB'',''Platinum'') and Molecule=''N'' and Class=''N''and B.Active=''Y''
		group by B.mkt'

		print @SQL2
		exec( @SQL2)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
-- for eliquis mkt 
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @Rat varchar(10)
DECLARE @SQL2 VARCHAR(max)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		set @Rat='*b.Rat'
		set @SQL2='
		insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[Mat00],[Mat12],[Mat24],[Mat36],[Mat48])
		select 1,''Product'',''MAT'','+'''' +@MoneyType+''''+',B.mkt,a.prod_cod,''''
			,sum(mat00' +@MoneyType+@Rat+'),sum(mat12' +@MoneyType+@Rat+'),sum(mat24' +@MoneyType+@Rat+')
			,sum(mat36' +@MoneyType+@Rat+') ,sum(mat48' +@MoneyType+@Rat+')
		from mthchpa_pkau A 
		inner join
		(	select distinct A.mkt,B.PRod_cod,a.pack_cod,a.Rat from tblMktDef_MRBIChina A inner join tblProddef B
			on A.productname=B.Product
			where A.prod=''100'' and a.mkt like ''eliquis%'') B
        on A.pack_cod=B.pack_cod
        group by B.mkt,a.prod_cod

		insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[Mat00],[Mat12],[Mat24],[Mat36],[Mat48])
		select 3,''Market Size'',''MAT'','+'''' +@MoneyType+''''+',B.mkt,B.mkt,''''
			,sum(mat00' +@MoneyType+@Rat+'),sum(mat12' +@MoneyType+@Rat+'),sum(mat24' +@MoneyType+@Rat+')
			,sum(mat36' +@MoneyType+@Rat+') ,sum(mat48' +@MoneyType+@Rat+')
		from mthchpa_pkau A 
		inner join tblMktDef_MRBIChina B
		on A.pack_cod=b.pack_cod
		where B.prod=''000'' and B.mkt in(''ELIQUIS VTEp'',''ELIQUIS VTEt'',''ELIQUIS NOAC'') and Molecule=''N'' and Class=''N'' and B.Active=''Y''
		group by B.mkt

		insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[MQT00],[MQT12],[MQT24],[MQT36],[MQT48])
		select 1,''Product'',''MQT'','+'''' +@MoneyType+''''+',B.mkt,a.prod_cod,''''
			,sum(R3M00' +@MoneyType+@Rat+'),sum(R3M12' +@MoneyType+@Rat+'),sum(R3M24' +@MoneyType+@Rat+')
			,sum(R3M36' +@MoneyType+@Rat+') ,sum(R3M48' +@MoneyType+@Rat+')
		from mthchpa_pkau A 
		inner join
		(	select distinct A.mkt,B.PRod_cod,a.pack_cod,a.Rat from tblMktDef_MRBIChina A inner join tblProddef B
			on A.productname=B.Product
			where A.prod=''100'' and a.mkt like ''eliquis%'') B
        on A.pack_cod=B.pack_cod
        group by B.mkt,a.prod_cod

		insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[MQT00],[MQT12],[MQT24],[MQT36],[MQT48])
		select 3,''Market Size'',''MQT'','+'''' +@MoneyType+''''+',B.mkt,B.mkt,''''
			,sum(R3M00' +@MoneyType+@Rat+'),sum(R3M12' +@MoneyType+@Rat+'),sum(R3M24' +@MoneyType+@Rat+')
			,sum(R3M36' +@MoneyType+@Rat+') ,sum(R3M48' +@MoneyType+@Rat+')
		from mthchpa_pkau A 
		inner join tblMktDef_MRBIChina B
		on A.pack_cod=b.pack_cod
		where B.prod=''000'' and B.mkt in(''ELIQUIS VTEp'',''ELIQUIS VTEt'',''ELIQUIS NOAC'') and Molecule=''N'' and Class=''N'' and B.Active=''Y''
		group by B.mkt

		insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[YTD00],[YTD12],[YTD24],[YTD36],[YTD48])
		select 1,''Product'',''YTD'','+'''' +@MoneyType+''''+',B.mkt,a.prod_cod,''''
			,sum(YTD00' +@MoneyType+@Rat+'),sum(YTD12' +@MoneyType+@Rat+') ,sum(YTD24' +@MoneyType+@Rat+')
			,sum(YTD36' +@MoneyType+@Rat+') ,sum(YTD48' +@MoneyType+@Rat+')
		from mthchpa_pkau A inner join
		(	select distinct A.mkt,B.PRod_cod,a.pack_cod,a.Rat from tblMktDef_MRBIChina A inner join tblProddef B
			on A.productname=B.Product
			where A.prod=''100'' and a.mkt like ''eliquis%'') B
        on A.pack_cod=B.pack_cod
        group by B.mkt,a.prod_cod


		insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[YTD00],[YTD12],[YTD24],[YTD36],[YTD48])
		select 3, ''Market Size'',''YTD'','+'''' +@MoneyType+''''+',B.mkt,B.mkt,''''
			,sum(YTD00' +@MoneyType+@Rat+'),sum(YTD12' +@MoneyType+@Rat+') ,sum(YTD24' +@MoneyType+@Rat+')
			,sum(YTD36' +@MoneyType+@Rat+') ,sum(YTD48' +@MoneyType+@Rat+')
		from mthchpa_pkau A inner join tblMktDef_MRBIChina B
		on A.pack_cod=b.pack_cod
		where B.prod=''000'' and B.mkt in(''ELIQUIS VTEp'',''ELIQUIS VTEt'',''ELIQUIS NOAC'') and Molecule=''N'' and Class=''N''and B.Active=''Y''
		group by B.mkt'
	    print @SQL2
		exec( @SQL2)

       set @SQL2='insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[Mat00],[Mat12],[Mat24],[Mat36],[Mat48],
	   		[Mth06], [Mth07], [Mth08], [Mth09], [Mth10], [Mth11], [Mth12], [Mth13], [Mth14], [Mth15], [Mth16], [Mth17], [Mth18], [Mth19], [Mth20], [Mth21], [Mth22], [Mth23], [Mth24])
		select 1,''Product'',''MTH'','+'''' +@MoneyType+''''+',B.mkt,a.prod_cod,'''',sum(MTH00' +@MoneyType+@Rat+')
			,sum(MTH01' +@MoneyType+@Rat+')
			,sum(MTH02' +@MoneyType+@Rat+')
			,sum(MTH03' +@MoneyType+@Rat+')
			,sum(MTH04' +@MoneyType+@Rat+')
			,sum(MTH05' +@MoneyType+@Rat+')
			,sum(MTH06' +@MoneyType+@Rat+')
			,sum(MTH07' +@MoneyType+@Rat+')
			,sum(MTH08' +@MoneyType+@Rat+')
			,sum(MTH09' +@MoneyType+@Rat+')
			,sum(MTH10' +@MoneyType+@Rat+')
			,sum(MTH11' +@MoneyType+@Rat+')
			
			,sum(MTH12' +@MoneyType+@Rat+')		
			,sum(MTH13' +@MoneyType+@Rat+')
			,sum(MTH14' +@MoneyType+@Rat+')
			,sum(MTH15' +@MoneyType+@Rat+')
			,sum(MTH16' +@MoneyType+@Rat+')
			,sum(MTH17' +@MoneyType+@Rat+')
			,sum(MTH18' +@MoneyType+@Rat+')
			,sum(MTH19' +@MoneyType+@Rat+')
			,sum(MTH20' +@MoneyType+@Rat+')
			,sum(MTH21' +@MoneyType+@Rat+')
			,sum(MTH22' +@MoneyType+@Rat+')
			,sum(MTH23' +@MoneyType+@Rat+')			
		from mthchpa_pkau A inner join
		(select distinct A.mkt,B.PRod_cod ,a.pack_cod,a.Rat from tblMktDef_MRBIChina A inner join tblProddef B
		on A.productname=B.Product
		where A.prod=''100'' and a.mkt like ''eliquis%'') B
        on A.pack_cod=B.pack_cod
        group by B.mkt,a.prod_cod


		insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[Mat00],[Mat12],[Mat24],[Mat36],[Mat48],
	   		[Mth06], [Mth07], [Mth08], [Mth09], [Mth10], [Mth11], [Mth12], [Mth13], [Mth14], [Mth15], [Mth16], [Mth17], [Mth18], [Mth19], [Mth20], [Mth21], [Mth22], [Mth23], [Mth24])
		select 3,''Market Size'',''MTH'','+'''' +@MoneyType+''''+',B.mkt,B.mkt,'''',sum(MTH00' +@MoneyType+@Rat+')
			,sum(MTH01' +@MoneyType+@Rat+')
			,sum(MTH02' +@MoneyType+@Rat+')
			,sum(MTH03' +@MoneyType+@Rat+')
			,sum(MTH04' +@MoneyType+@Rat+')
			,sum(MTH05' +@MoneyType+@Rat+')
			,sum(MTH06' +@MoneyType+@Rat+')
			,sum(MTH07' +@MoneyType+@Rat+')
			,sum(MTH08' +@MoneyType+@Rat+')
			,sum(MTH09' +@MoneyType+@Rat+')
			,sum(MTH10' +@MoneyType+@Rat+')
			,sum(MTH11' +@MoneyType+@Rat+')
			
			,sum(MTH12' +@MoneyType+@Rat+')		
			,sum(MTH13' +@MoneyType+@Rat+')
			,sum(MTH14' +@MoneyType+@Rat+')
			,sum(MTH15' +@MoneyType+@Rat+')
			,sum(MTH16' +@MoneyType+@Rat+')
			,sum(MTH17' +@MoneyType+@Rat+')
			,sum(MTH18' +@MoneyType+@Rat+')
			,sum(MTH19' +@MoneyType+@Rat+')
			,sum(MTH20' +@MoneyType+@Rat+')
			,sum(MTH21' +@MoneyType+@Rat+')
			,sum(MTH22' +@MoneyType+@Rat+')
			,sum(MTH23' +@MoneyType+@Rat+')			
		from mthchpa_pkau A inner join tblMktDef_MRBIChina B
		on A.pack_cod=b.pack_cod
		where B.prod=''000'' and B.mkt in(''ELIQUIS VTEp'',''ELIQUIS VTEt'',''ELIQUIS NOAC'') 
			and Molecule=''N'' and Class=''N''and B.Active=''Y''
		group by B.mkt'

		print @SQL2
		exec( @SQL2)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
--select * from OutputProdSalesPerformanceInChina
--alter table OutputProdSalesPerformanceInChina
--Add Growth float
--go
--update OutputProdSalesPerformanceInChina
--set Growth=case Mat12 when 0 then 0 else (Mat00-Mat12)*1.0/Mat12 end
--go
update OutputProdSalesPerformanceInChina
set Prod_des=B.product 
from OutputProdSalesPerformanceInChina A 
inner join dbo.tblProdDef B
on A.prod_cod=B.prod_cod

update OutputProdSalesPerformanceInChina
set Prod_des=B.mktname 
from OutputProdSalesPerformanceInChina A 
inner join dbo.tblMktDef_MRBIChina B
on A.prod_cod=B.mkt
go
delete from OutputProdSalesPerformanceInChina where market in('DIA','ACE')
go
update OutputProdSalesPerformanceInChina
set market=case market 
	when 'ACE' then 'Monopril' when 'HYP' then 'Monopril' 
	when 'ARV' then 'Baraclude' 
	when 'NIAD' then 'Glucophage'
	when 'ONCFCS' then 'Taxol'
	when 'DPP4' then 'Onglyza' 
	when 'Platinum' then 'Paraplatin' 
	when 'CCB' then 'Coniel'
	when 'ELIQUIS VTEp' then 'ELIQUIS (VTEp)'
	when 'ELIQUIS NOAC' then 'ELIQUIS (NOAC)'
	when 'ELIQUIS VTEt' then 'ELIQUIS (VTEt)'
	else market end
go
insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des]
	,[Mat00],[Mat12],[Mat24],[Mat36],[Mat48]
	,[MQT00],[MQT12],[MQT24],[MQT36],[MQT48]
	,[YTD00],[YTD12],[YTD24],[YTD36],[YTD48]
	,[Mth06],[Mth07],[Mth08],[Mth09],[Mth10],[Mth11],[Mth12])
select 4,'Market Growth',A.Period,A.Moneytype,A.Market,a.prod_cod,a.prod_des,
	case mat12 when 0 then 0 else (mat00-MTH13)/MTH13 end,
	case mat24 when 0 then 0 else (mat12-MTH14)/MTH14 end,
	case mat36 when 0 then 0 else (mat24-MTH15)/MTH15 end,
	case mat48 when 0 then 0 else (mat36-MTH16)/MTH16 end, 
	case MTH06 when 0 then 0 else (mat48-MTH17)/MTH17 end,
	case MQT12 when 0 then 0 else (MQT00-MQT12)/MQT12 end,
	case MQT24 when 0 then 0 else (MQT12-MQT24)/MQT24 end,
	case MQT36 when 0 then 0 else (MQT24-MQT36)/MQT36 end,
	case MQT48 when 0 then 0 else (MQT36-MQT48)/MQT48 end, '',
	case YTD12 when 0 then 0 else (YTD00-YTD12)/YTD12 end,
	case YTD24 when 0 then 0 else (YTD12-YTD24)/YTD24 end,
	case YTD36 when 0 then 0 else (YTD24-YTD36)/YTD36 end,
	case YTD48 when 0 then 0 else (YTD36-YTD48)/YTD48 end, '',
	case MTH07 when 0 then 0 else (MTH06-MTH18)/MTH18 end,
	case MTH08 when 0 then 0 else (MTH07-MTH19)/MTH19 end,
	case MTH09 when 0 then 0 else (MTH08-MTH20)/MTH20 end,
	case MTH10 when 0 then 0 else (MTH09-MTH21)/MTH21 end,
	case MTH11 when 0 then 0 else (MTH10-MTH22)/MTH22 end,
	case MTH12 when 0 then 0 else (MTH11-MTH23)/MTH23 end,
	case MTH13 when 0 then 0 else (MTH12-MTH23)/MTH24 end
from OutputProdSalesPerformanceInChina a where [type]='Market Size' and period<>'MTH'
go

insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des]
	,[Mat00],[Mat12],[Mat24],[Mat36],[Mat48]
	,[MQT00],[MQT12],[MQT24],[MQT36],[MQT48]
	,[YTD00],[YTD12],[YTD24],[YTD36],[YTD48]
	,[Mth06],[Mth07],[Mth08],[Mth09],[Mth10],[Mth11],[Mth12])
select 5,A.Prod_des+' Growth',A.Period,A.Moneytype,A.Market,a.prod_cod,a.prod_des,
	case mat12 when 0 then 0 else (mat00-MTH13)/MTH13 end,
	case mat24 when 0 then 0 else (mat12-MTH14)/MTH14 end,
	case mat36 when 0 then 0 else (mat24-MTH15)/MTH15 end,
	case mat48 when 0 then 0 else (mat36-MTH16)/MTH16 end, 
	case MTH06 when 0 then 0 else (mat48-MTH17)/MTH17 end,
	case MQT12 when 0 then 0 else (MQT00-MQT12)/MQT12 end,
	case MQT24 when 0 then 0 else (MQT12-MQT24)/MQT24 end,
	case MQT36 when 0 then 0 else (MQT24-MQT36)/MQT36 end,
	case MQT48 when 0 then 0 else (MQT36-MQT48)/MQT48 end, '',
	case YTD12 when 0 then 0 else (YTD00-YTD12)/YTD12 end,
	case YTD24 when 0 then 0 else (YTD12-YTD24)/YTD24 end,
	case YTD36 when 0 then 0 else (YTD24-YTD36)/YTD36 end,
	case YTD48 when 0 then 0 else (YTD36-YTD48)/YTD48 end, '',
	case MTH07 when 0 then 0 else (MTH06-MTH18)/MTH18 end,
	case MTH08 when 0 then 0 else (MTH07-MTH19)/MTH19 end,
	case MTH09 when 0 then 0 else (MTH08-MTH20)/MTH20 end,
	case MTH10 when 0 then 0 else (MTH09-MTH21)/MTH21 end,
	case MTH11 when 0 then 0 else (MTH10-MTH22)/MTH22 end,
	case MTH12 when 0 then 0 else (MTH11-MTH23)/MTH23 end,
	case MTH13 when 0 then 0 else (MTH12-MTH23)/MTH24 end
 from OutputProdSalesPerformanceInChina a where [type]='Product'  and period<>'MTH'
go

insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des]
	,[Mat00],[Mat12],[Mat24],[Mat36],[Mat48]
	,[MQT00],[MQT12],[MQT24],[MQT36],[MQT48]
	,[YTD00],[YTD12],[YTD24],[YTD36],[YTD48]
	,[Mth06],[Mth07],[Mth08],[Mth09],[Mth10],[Mth11],[Mth12])
select 4,'Market Growth',A.Period,A.Moneytype,A.Market,a.prod_cod,a.prod_des,
	case mat12 when 0 then 0 else (mat00-MTH13)/MTH13 end,
	case mat24 when 0 then 0 else (mat12-MTH14)/MTH14 end,
	case mat36 when 0 then 0 else (mat24-MTH15)/MTH15 end,
	case mat48 when 0 then 0 else (mat36-MTH16)/MTH16 end, 
	case MTH06 when 0 then 0 else (mat48-MTH17)/MTH17 end,
	case MQT12 when 0 then 0 else (MQT00-MQT12)/MQT12 end,
	case MQT24 when 0 then 0 else (MQT12-MQT24)/MQT24 end,
	case MQT36 when 0 then 0 else (MQT24-MQT36)/MQT36 end,
	case MQT48 when 0 then 0 else (MQT36-MQT48)/MQT48 end, '',
	case YTD12 when 0 then 0 else (YTD00-YTD12)/YTD12 end,
	case YTD24 when 0 then 0 else (YTD12-YTD24)/YTD24 end,
	case YTD36 when 0 then 0 else (YTD24-YTD36)/YTD36 end,
	case YTD48 when 0 then 0 else (YTD36-YTD48)/YTD48 end, '',
	case MTH07 when 0 then 0 else (MTH06-MTH18)/MTH18 end,
	case MTH08 when 0 then 0 else (MTH07-MTH19)/MTH19 end,
	case MTH09 when 0 then 0 else (MTH08-MTH20)/MTH20 end,
	case MTH10 when 0 then 0 else (MTH09-MTH21)/MTH21 end,
	case MTH11 when 0 then 0 else (MTH10-MTH22)/MTH22 end,
	case MTH12 when 0 then 0 else (MTH11-MTH23)/MTH23 end,
	case MTH13 when 0 then 0 else (MTH12-MTH23)/MTH24 end
 from OutputProdSalesPerformanceInChina a where [type]='Market Size' and period='MTH'
go

insert into OutputProdSalesPerformanceInChina([TypeIdx],[Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des]
	,[Mat00],[Mat12],[Mat24],[Mat36],[Mat48]
	,[MQT00],[MQT12],[MQT24],[MQT36],[MQT48]
	,[YTD00],[YTD12],[YTD24],[YTD36],[YTD48]
	,[Mth06],[Mth07],[Mth08],[Mth09],[Mth10],[Mth11],[Mth12])
select 5,A.Prod_des+' Growth',A.Period,A.Moneytype,A.Market,a.prod_cod,a.prod_des,
	case mat12 when 0 then 0 else (mat00-MTH13)/MTH13 end,
	case mat24 when 0 then 0 else (mat12-MTH14)/MTH14 end,
	case mat36 when 0 then 0 else (mat24-MTH15)/MTH15 end,
	case mat48 when 0 then 0 else (mat36-MTH16)/MTH16 end, 
	case MTH06 when 0 then 0 else (mat48-MTH17)/MTH17 end,
	case MQT12 when 0 then 0 else (MQT00-MQT12)/MQT12 end,
	case MQT24 when 0 then 0 else (MQT12-MQT24)/MQT24 end,
	case MQT36 when 0 then 0 else (MQT24-MQT36)/MQT36 end,
	case MQT48 when 0 then 0 else (MQT36-MQT48)/MQT48 end, '',
	case YTD12 when 0 then 0 else (YTD00-YTD12)/YTD12 end,
	case YTD24 when 0 then 0 else (YTD12-YTD24)/YTD24 end,
	case YTD36 when 0 then 0 else (YTD24-YTD36)/YTD36 end,
	case YTD48 when 0 then 0 else (YTD36-YTD48)/YTD48 end, '',
	case MTH07 when 0 then 0 else (MTH06-MTH18)/MTH18 end,
	case MTH08 when 0 then 0 else (MTH07-MTH19)/MTH19 end,
	case MTH09 when 0 then 0 else (MTH08-MTH20)/MTH20 end,
	case MTH10 when 0 then 0 else (MTH09-MTH21)/MTH21 end,
	case MTH11 when 0 then 0 else (MTH10-MTH22)/MTH22 end,
	case MTH12 when 0 then 0 else (MTH11-MTH23)/MTH23 end,
	case MTH13 when 0 then 0 else (MTH12-MTH23)/MTH24 end
 from OutputProdSalesPerformanceInChina a where [type]='Product'  and period='MTH'
go

update OutputProdSalesPerformanceInChina
set [Type]=prod_des+' Sales' 
where [type]='Product'
go





--------------------------------------------
--Pre defined
--------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'TempCHPAPreReportsByMNC') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table TempCHPAPreReportsByMNC
go
if exists (select * from dbo.sysobjects where id = object_id(N'TempCHPAPreReports') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table TempCHPAPreReports
go
if exists (select * from dbo.sysobjects where id = object_id(N'TempCHPAPreReports_Mole') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table TempCHPAPreReports_Mole
go
CREATE TABLE [dbo].TempCHPAPreReportsByMNC(
    [Molecule] [varchar](2)  NOT NULL,
    [Class] [varchar](2)  NOT NULL,
    [mkt] [varchar](50)  NULL,
	[mktname] [varchar](50)  NULL,
	[Market] [varchar](50)  NULL,
	[prod] [varchar](200)  NULL,
	[Productname] [varchar](200)  NULL,
	[MNFL_COD] [varchar](10)  NULL,
	[Moneytype] [varchar](2)  NOT NULL,
	[R3M00] [float] NULL default 0,
	[R3M01] [float] NULL default 0,
	[R3M02] [float] NULL default 0,
	[R3M03] [float] NULL default 0,
	[R3M04] [float] NULL default 0,
	[R3M05] [float] NULL default 0,
	[R3M06] [float] NULL default 0,
	[R3M07] [float] NULL default 0,
	[R3M08] [float] NULL default 0,
	[R3M09] [float] NULL default 0,
	[R3M10] [float] NULL default 0,
	[R3M11] [float] NULL default 0,
	[R3M12] [float] NULL default 0,
	[R3M13] [float] NULL default 0,
	[R3M14] [float] NULL default 0,
	[R3M15] [float] NULL default 0,
	[R3M16] [float] NULL default 0,
	[R3M17] [float] NULL default 0,
	[R3M18] [float] NULL default 0,
    [R3M19] float null default 0,
	[R3M20] float null default 0,
	[R3M21] float null default 0,
	[R3M22] float null default 0,
	[R3M23] float null default 0,
	[R3M24] float null default 0,
	[R3M25] float null default 0,
	[R3M26] float null default 0,
	[R3M27] float null default 0,
	[R3M28] float null default 0,
	[R3M29] float null default 0,
	[R3M30] float null default 0,
	[R3M31] float null default 0,
	[R3M32] float null default 0,
	[R3M33] float null default 0,
	[R3M34] float null default 0,
	[R3M35] float null default 0,
	[R3M36] float null default 0,
	[R3M37] float null default 0,
	[R3M38] float null default 0,
	[R3M39] float null default 0,
	[R3M40] float null default 0,
	[R3M41] float null default 0,
	[R3M42] float null default 0,
	[R3M43] float null default 0,
	[R3M44] float null default 0,
	[R3M45] float null default 0,
	[R3M46] float null default 0,
	[R3M47] float null default 0,
	[R3M48] float null default 0,

	[MTH00] [float] NULL default 0,
	[MTH01] [float] NULL default 0,
	[MTH02] [float] NULL default 0,
	[MTH03] [float] NULL default 0,
	[MTH04] [float] NULL default 0,
	[MTH05] [float] NULL default 0,
	[MTH06] [float] NULL default 0,
	[MTH07] [float] NULL default 0,
	[MTH08] [float] NULL default 0,
	[MTH09] [float] NULL default 0,
	[MTH10] [float] NULL default 0,
	[MTH11] [float] NULL default 0,
	[MTH12] [float] NULL default 0,
	[MTH13] [float] NULL default 0,
	[MTH14] [float] NULL default 0,
	[MTH15] [float] NULL default 0,
	[MTH16] [float] NULL default 0,
	[MTH17] [float] NULL default 0,
	[MTH18] [float] NULL default 0,
	[MTH19] [float] NULL default 0,
	[MTH20] [float] NULL default 0,
	[MTH21] [float] NULL default 0,
	[MTH22] [float] NULL default 0,
	[MTH23] [float] NULL default 0,
	[MTH24] [float] NULL default 0,
	[MTH25] [float] NULL default 0,
	[MTH26] [float] NULL default 0,
	[MTH27] [float] NULL default 0,
	[MTH28] [float] NULL default 0,
	[MTH29] [float] NULL default 0,
	[MTH30] [float] NULL default 0,
	[MTH31] [float] NULL default 0,
	[MTH32] [float] NULL default 0,
	[MTH33] [float] NULL default 0,
	[MTH34] [float] NULL default 0,
	[MTH35] [float] NULL default 0,
	[MTH36] [float] NULL default 0,
	[MTH37] [float] NULL default 0,
	[MTH38] [float] NULL default 0,
	[MTH39] [float] NULL default 0,
	[MTH40] [float] NULL default 0,
	[MTH41] [float] NULL default 0,
	[MTH42] [float] NULL default 0,
	[MTH43] [float] NULL default 0,
	[MTH44] [float] NULL default 0,
	[MTH45] [float] NULL default 0,
	[MTH46] [float] NULL default 0,
	[MTH47] [float] NULL default 0,
	[MTH48] [float] NULL default 0,

	[MAT00] [float] NULL default 0,
	[MAT01] [float] NULL default 0,
	[MAT02] [float] NULL default 0,
	[MAT03] [float] NULL default 0,
	[MAT04] [float] NULL default 0,
	[MAT05] [float] NULL default 0,
	[MAT06] [float] NULL default 0,
	[MAT07] [float] NULL default 0,
	[MAT08] [float] NULL default 0,
	[MAT09] [float] NULL default 0,
	[MAT10] [float] NULL default 0,
	[MAT11] [float] NULL default 0,
	[MAT12] [float] NULL default 0,
	[MAT13] [float] NULL default 0,
	[MAT14] [float] NULL default 0,
	[MAT15] [float] NULL default 0,
	[MAT16] [float] NULL default 0,
	[MAT17] [float] NULL default 0,
	[MAT18] [float] NULL default 0,
	[MAT19] [float] NULL default 0,
	[MAT20] [float] NULL default 0,
	[MAT21] [float] NULL default 0,
	[MAT22] [float] NULL default 0,
	[MAT23] [float] NULL default 0,
	[MAT24] [float] NULL default 0,
	[MAT25] [float] NULL default 0,
	[MAT26] [float] NULL default 0,
	[MAT27] [float] NULL default 0,
	[MAT28] [float] NULL default 0,
	[MAT29] [float] NULL default 0,
	[MAT30] [float] NULL default 0,
	[MAT31] [float] NULL default 0,
	[MAT32] [float] NULL default 0,
	[MAT33] [float] NULL default 0,
	[MAT34] [float] NULL default 0,
	[MAT35] [float] NULL default 0,
	[MAT36] [float] NULL default 0,
	[MAT37] [float] NULL default 0,
	[MAT38] [float] NULL default 0,
	[MAT39] [float] NULL default 0,
	[MAT40] [float] NULL default 0,
	[MAT41] [float] NULL default 0,
	[MAT42] [float] NULL default 0,
	[MAT43] [float] NULL default 0,
	[MAT44] [float] NULL default 0,
	[MAT45] [float] NULL default 0,
	[MAT46] [float] NULL default 0,
	[MAT47] [float] NULL default 0,
	[MAT48] [float] NULL default 0,

	[YTD00] [float] NULL default 0,
	[YTD01] [float] NULL default 0,
	[YTD02] [float] NULL default 0,
	[YTD03] [float] NULL default 0,
	[YTD04] [float] NULL default 0,
	[YTD05] [float] NULL default 0,
	[YTD06] [float] NULL default 0,
	[YTD07] [float] NULL default 0,
	[YTD08] [float] NULL default 0,
	[YTD09] [float] NULL default 0,
	[YTD10] [float] NULL default 0,
	[YTD11] [float] NULL default 0,
	[YTD12] [float] NULL default 0,
	[YTD13] [float] NULL default 0,
	[YTD14] [float] NULL default 0,
	[YTD15] [float] NULL default 0,
	[YTD16] [float] NULL default 0,
	[YTD17] [float] NULL default 0,
	[YTD18] [float] NULL default 0,
	[YTD19] [float] NULL default 0,
	[YTD20] [float] NULL default 0,
	[YTD21] [float] NULL default 0,
	[YTD22] [float] NULL default 0,
	[YTD23] [float] NULL default 0,
	[YTD24] [float] NULL default 0,
	[YTD25] [float] NULL default 0,
	[YTD26] [float] NULL default 0,
	[YTD27] [float] NULL default 0,
	[YTD28] [float] NULL default 0,
	[YTD29] [float] NULL default 0,
	[YTD30] [float] NULL default 0,
	[YTD31] [float] NULL default 0,
	[YTD32] [float] NULL default 0,
	[YTD33] [float] NULL default 0,
	[YTD34] [float] NULL default 0,
	[YTD35] [float] NULL default 0,
	[YTD36] [float] NULL default 0,
	[YTD37] [float] NULL default 0,
	[YTD38] [float] NULL default 0,
	[YTD39] [float] NULL default 0,
	[YTD40] [float] NULL default 0,
	[YTD41] [float] NULL default 0,
	[YTD42] [float] NULL default 0,
	[YTD43] [float] NULL default 0,
	[YTD44] [float] NULL default 0,
	[YTD45] [float] NULL default 0,
	[YTD46] [float] NULL default 0,
	[YTD47] [float] NULL default 0,
	[YTD48] [float] NULL default 0,

  	[Qtr00] [float] NULL default 0,
	[Qtr01] [float] NULL default 0,
	[Qtr02] [float] NULL default 0,
	[Qtr03] [float] NULL default 0,
	[Qtr04] [float] NULL default 0,
	[Qtr05] [float] NULL default 0,
	[Qtr06] [float] NULL default 0,
	[Qtr07] [float] NULL default 0,
	[Qtr08] [float] NULL default 0,
	[Qtr09] [float] NULL default 0,
	[Qtr10] [float] NULL default 0,
	[Qtr11] [float] NULL default 0,
	[Qtr12] [float] NULL default 0,
	[Qtr13] [float] NULL default 0,
	[Qtr14] [float] NULL default 0,
	[Qtr15] [float] NULL default 0,
	[Qtr16] [float] NULL default 0,
	[Qtr17] [float] NULL default 0,
	[Qtr18] [float] NULL default 0,
	[Qtr19] [float] NULL default 0
) ON [PRIMARY]

GO
select * into TempCHPAPreReports from TempCHPAPreReportsByMNC where 1=2
select * into TempCHPAPreReports_Mole from TempCHPAPreReportsByMNC where 1=2
go
Alter table TempCHPAPreReports drop column [MNFL_COD]
Alter table TempCHPAPreReports_Mole drop column [MNFL_COD]
go

exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','TempCHPAPreReportsByMNC',null,null

declare @i int,@sql varchar(max),@sql1 varchar(max),@sql3 varchar(max),@sqlMAT varchar(max),
	@sqlYTD varchar(max),@sqlQtr varchar(max), @sqlMQT varchar(max)

DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(max)
DECLARE @SQL4 VARCHAR(max)	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		if @MoneyType='UN'
			set @MoneyType=@MoneyType+'/b.rat'
		set @i=0
		set @sql1=''
        set @sql3=''
		while (@i<=48)
		begin
			set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
			set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
			set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
		while (@i<=48)
		begin
			set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)


        set @i=0
		set @sqlQtr=''
		while (@i<=19)
		begin
			set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		set @SQL2='insert into TempCHPAPreReportsByMNC 
		select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,
			A.MNFL_COD,
			'+'''' +left(@MoneyType,2)+''''+' as Moneytype, '+@sql1+', ' + @sql3 + ', '
		
		set @SQL4= @sqlMAT+', '+@sqlYTD+ ', ' +@sqlQtr+'
		from mthCHPA_pkau A inner join tblMktDef_MRBIChina B
        on A.pack_cod=B.pack_cod where B.Active=''Y''
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname, A.MNFL_COD'
       print @SQL2+@SQL4
		exec( @SQL2+@sql4)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
update TempCHPAPreReportsByMNC
set Market=case Market when 'ONC' then 'Taxol' 
	when 'HYP' then 'Monopril'
	when 'NIAD' then 'Glucophage'
	when 'ACE' then 'Monopril'
	when 'DIA' then 'Glucophage'
	when 'ONCFCS' then 'Taxol'
	when 'HBV' then 'Baraclude'
	when 'ARV' then 'Baraclude' 
	when 'DPP4' then 'Onglyza' 
	when 'CML' then 'Sprycel' 
	when 'Platinum' then 'Paraplatin'
	when 'CCB' then 'Coniel'
	else Market end



exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','TempCHPAPreReports',null,null
declare @i int,@sql varchar(max),@sql1 varchar(max),@sql3 varchar(max),@sqlMAT varchar(max),
	@sqlYTD varchar(max),@sqlQtr varchar(max), @sqlMQT varchar(max)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(max)
DECLARE @SQL4 VARCHAR(max)	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		if @MoneyType='UN'
		set @MoneyType=@MoneyType+'/b.rat'
		set @i=0
		set @sql1=''
        set @sql3=''
		while (@i<=48)
		begin
			set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
			set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
			set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
		while (@i<=48)
		begin
			set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
		set @sqlQtr=''
		while (@i<=19)
		begin
			set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		set @SQL2='insert into TempCHPAPreReports 
		select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,
--         A.MNFL_COD,B.Gene_cod,
        '+'''' +left(@MoneyType,2)+''''+' as Moneytype, '+@sql1+', '+@sql3+', '

        set @SQL4= @sqlMAT+', '+@sqlYTD+', ' +@sqlQtr+'
		from mthCHPA_pkau A inner join tblMktDef_MRBIChina B
        on A.pack_cod=B.pack_cod where B.Active=''Y'' and b.mkt not like ''eliquis%''
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname'
       print @SQL2+@SQL4
		exec( @SQL2+@SQL4)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go

declare @i int,@sql varchar(max),@sql1 varchar(max),@sql3 varchar(max),@sqlMAT varchar(max),
	@sqlYTD varchar(max),@sqlQtr varchar(max), @sqlMQT varchar(max)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(max)
DECLARE @SQL4 VARCHAR(max)	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		set @MoneyType=@MoneyType+'*b.rat'
		set @i=0
		set @sql1=''
        set @sql3=''
		while (@i<=48)
		begin
			set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
			set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
			set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
		while (@i<=48)
		begin
			set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)


        set @i=0
		set @sqlQtr=''
		while (@i<=19)
		begin
			set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		set @SQL2='insert into TempCHPAPreReports 
		select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,
--         A.MNFL_COD,B.Gene_cod,
        '+'''' +left(@MoneyType,2)+''''+' as Moneytype, '+@sql1+', '+@sql3+', '
        
		set @SQL4= @sqlMAT+', '+@sqlYTD+', ' +@sqlQtr+'
		from mthCHPA_pkau A inner join tblMktDef_MRBIChina B
        on A.pack_cod=B.pack_cod where B.Active=''Y'' and b.mkt like ''eliquis%''
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname'
       print @SQL2+@SQL4
		exec( @SQL2+@SQL4)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go

update TempCHPAPreReports
set Market=
	case Market when 'ONC' then 'Taxol' 
		when 'HYP' then 'Monopril'
		when 'NIAD' then 'Glucophage'
		when 'ACE' then 'Monopril'
		when 'DIA' then 'Glucophage'
		when 'ONCFCS' then 'Taxol'
		when 'HBV' then 'Baraclude'
		when 'ARV' then 'Baraclude' when 'DPP4' then 'Onglyza' when 'CML' then 'Sprycel' 
		when 'Platinum' then 'Paraplatin'
		when 'CCB' then 'Coniel'
		else Market end
go

delete 
from TempCHPAPreReports
where Market <> 'Paraplatin' and MoneyType = 'PN'

go

exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','TempCHPAPreReports_Mole',null,null

declare @i int,@sql varchar(max),@sql1 varchar(max),@sql3 varchar(max),@sqlMAT varchar(max),
	@sqlYTD varchar(max),@sqlQtr varchar(max), @sqlMQT varchar(max)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(max)
DECLARE @SQL4 VARCHAR(max)	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		if @MoneyType='UN'
			set @MoneyType=@MoneyType+'/b.rat'
		set @i=0
		set @sql1=''
        set @sql3=''
		while (@i<=48)
		begin
			set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
			set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
			set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
		while (@i<=48)
		begin
			set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
		set @sqlQtr=''
		while (@i<=19)
		begin
			set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		set @SQL2='insert into TempCHPAPreReports_Mole 
		select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,
--         A.MNFL_COD,B.Gene_cod,
        '+'''' +left(@MoneyType,2)+''''+' as Moneytype, '+@sql1+', ' + @sql3 + ', '
        
		set @SQL4 = @sqlMAT+', '+@sqlYTD+', ' +@sqlQtr+'
		from mthCHPA_pkau A inner join tblMktDef_MRBIChina_Mole B
        on A.pack_cod=B.pack_cod where B.Active=''Y''
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname'
       print @SQL2+@sql4
		exec( @SQL2+@sql4)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
update TempCHPAPreReports_Mole
set Market=
	case Market when 'Paclitaxel' then 'Taxol' 
		when 'Metformin' then 'Glucophage'
		when 'ACEI' then 'Monopril'
		when 'Entecavir' then 'Baraclude'
		when 'Carboplatin' then 'Paraplatin'
		when 'CCB' then 'Coniel'
		else Market end
go
--Li Pu Su	N	L	B
--Run Zhong	N	L	B
--Ai Su	N	L	B
--Region city Dashboard




----------------------------------------------
-- TempCityDashboard
----------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'TempCityDashboard') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table TempCityDashboard
go
if exists (select * from dbo.sysobjects where id = object_id(N'TempCityDashboard_Mole') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table TempCityDashboard_Mole
go
CREATE TABLE [dbo].[TempCityDashboard](
    [Molecule] [varchar](2)  NOT NULL,
    [Class] [varchar](2)  NOT NULL,
    [mkt] [varchar](50)  NULL,
	[mktname] [varchar](50)  NULL,
	[Market] [varchar](50)  NULL,
	[prod] [varchar](200)  NULL,
	[Productname] [varchar](200)  NULL,
	[Moneytype] [varchar](50)  NOT NULL,
	[Audi_cod] [varchar](200)  NULL,
	[Audi_des] [varchar](200)  NULL,
	[Lev] [varchar](200)  NULL,
	[Tier] [varchar](10)  NULL,
	[R3M00] float null default 0,
	[R3M01] float null default 0,
	[R3M02] float null default 0,
	[R3M03] float null default 0,
	[R3M04] float null default 0,
	[R3M05] float null default 0,
	[R3M06] float null default 0,
	[R3M07] float null default 0,
	[R3M08] float null default 0,
	[R3M09] float null default 0,
	[R3M10] float null default 0,
	[R3M11] float null default 0,
	[R3M12] float null default 0,
	[R3M13] float null default 0,
	[R3M14] float null default 0,
	[R3M15] float null default 0,
	[R3M16] float null default 0,
	[R3M17] float null default 0,
	[R3M18] float null default 0,
	[R3M19] float null default 0,
	[R3M20] float null default 0,
	[R3M21] float null default 0,
	[R3M22] float null default 0,
	[R3M23] float null default 0,
	[R3M24] float null default 0,
	[R3M25] float null default 0,
	[R3M26] float null default 0,
	[R3M27] float null default 0,
	[R3M28] float null default 0,
	[R3M29] float null default 0,
	[R3M30] float null default 0,
	[R3M31] float null default 0,
	[R3M32] float null default 0,
	[R3M33] float null default 0,
	[R3M34] float null default 0,
	[R3M35] float null default 0,
	[R3M36] float null default 0,
	[R3M37] float null default 0,
	[R3M38] float null default 0,
	[R3M39] float null default 0,
	[R3M40] float null default 0,
	[R3M41] float null default 0,
	[R3M42] float null default 0,
	[R3M43] float null default 0,
	[R3M44] float null default 0,
	[R3M45] float null default 0,
--	[R3M46] float null default 0,
--	[R3M47] float null default 0,
--	[R3M48] float null default 0,
--	[R3M49] float null default 0,
--	[R3M50] float null default 0,
--	[R3M51] float null default 0,
--	[R3M52] float null default 0,
--	[R3M53] float null default 0,
--	[R3M54] float null default 0,
--	[R3M55] float null default 0,
--	[R3M56] float null default 0,
--	[R3M57] float null default 0,

	[MTH00] [float] NULL default 0,
	[MTH01] [float] NULL default 0,
	[MTH02] [float] NULL default 0,
	[MTH03] [float] NULL default 0,
	[MTH04] [float] NULL default 0,
	[MTH05] [float] NULL default 0,
	[MTH06] [float] NULL default 0,
	[MTH07] [float] NULL default 0,
	[MTH08] [float] NULL default 0,
	[MTH09] [float] NULL default 0,
	[MTH10] [float] NULL default 0,
	[MTH11] [float] NULL default 0,
	[MTH12] [float] NULL default 0,
	[MTH13] [float] NULL default 0,
	[MTH14] [float] NULL default 0,
	[MTH15] [float] NULL default 0,
	[MTH16] [float] NULL default 0,
	[MTH17] [float] NULL default 0,
	[MTH18] [float] NULL default 0,
	[MTH19] [float] NULL default 0,
	[MTH20] [float] NULL default 0,
	[MTH21] [float] NULL default 0,
	[MTH22] [float] NULL default 0,
	[MTH23] [float] NULL default 0,
	[MTH24] [float] NULL default 0,
	[MTH25] [float] NULL default 0,
	[MTH26] [float] NULL default 0,
	[MTH27] [float] NULL default 0,
	[MTH28] [float] NULL default 0,
	[MTH29] [float] NULL default 0,
	[MTH30] [float] NULL default 0,
	[MTH31] [float] NULL default 0,
	[MTH32] [float] NULL default 0,
	[MTH33] [float] NULL default 0,
	[MTH34] [float] NULL default 0,
	[MTH35] [float] NULL default 0,
	[MTH36] [float] NULL default 0,
	[MTH37] [float] NULL default 0,
	[MTH38] [float] NULL default 0,
	[MTH39] [float] NULL default 0,
	[MTH40] [float] NULL default 0,
	[MTH41] [float] NULL default 0,
	[MTH42] [float] NULL default 0,
	[MTH43] [float] NULL default 0,
	[MTH44] [float] NULL default 0,
	[MTH45] [float] NULL default 0,
	[MTH46] [float] NULL default 0,
	[MTH47] [float] NULL default 0,
	[MTH48] [float] NULL default 0,
--	[MTH49] [float] NULL default 0,
--	[MTH50] [float] NULL default 0,
--	[MTH51] [float] NULL default 0,
--	[MTH52] [float] NULL default 0,
--	[MTH53] [float] NULL default 0,
--	[MTH54] [float] NULL default 0,
--	[MTH55] [float] NULL default 0,
--	[MTH56] [float] NULL default 0,
--	[MTH57] [float] NULL default 0,
--	[MTH58] [float] NULL default 0,
--	[MTH59] [float] NULL default 0,

	[MAT00] [float] NULL default 0,
	[MAT01] [float] NULL default 0,
	[MAT02] [float] NULL default 0,
	[MAT03] [float] NULL default 0,
	[MAT04] [float] NULL default 0,
	[MAT05] [float] NULL default 0,
	[MAT06] [float] NULL default 0,
	[MAT07] [float] NULL default 0,
	[MAT08] [float] NULL default 0,
	[MAT09] [float] NULL default 0,
	[MAT10] [float] NULL default 0,
	[MAT11] [float] NULL default 0,
	[MAT12] [float] NULL default 0,
	[MAT13] [float] NULL default 0,
	[MAT14] [float] NULL default 0,
	[MAT15] [float] NULL default 0,
	[MAT16] [float] NULL default 0,
	[MAT17] [float] NULL default 0,
	[MAT18] [float] NULL default 0,
	[MAT19] [float] NULL default 0,
	[MAT20] [float] NULL default 0,
	[MAT21] [float] NULL default 0,
	[MAT22] [float] NULL default 0,
	[MAT23] [float] NULL default 0,
	[MAT24] [float] NULL default 0,
	[MAT25] [float] NULL default 0,
	[MAT26] [float] NULL default 0,
	[MAT27] [float] NULL default 0,
	[MAT28] [float] NULL default 0,
	[MAT29] [float] NULL default 0,
	[MAT30] [float] NULL default 0,
	[MAT31] [float] NULL default 0,
	[MAT32] [float] NULL default 0,
	[MAT33] [float] NULL default 0,
	[MAT34] [float] NULL default 0,
	[MAT35] [float] NULL default 0,
	[MAT36] [float] NULL default 0,
	[MAT37] [float] NULL default 0,
	[MAT38] [float] NULL default 0,
	[MAT39] [float] NULL default 0,
	[MAT40] [float] NULL default 0,
	[MAT41] [float] NULL default 0,
	[MAT42] [float] NULL default 0,
	[MAT43] [float] NULL default 0,
	[MAT44] [float] NULL default 0,
	[MAT45] [float] NULL default 0,
	[MAT46] [float] NULL default 0,
	[MAT47] [float] NULL default 0,
	[MAT48] [float] NULL default 0,

	[YTD00] [float] NULL default 0,
	[YTD01] [float] NULL default 0,
	[YTD02] [float] NULL default 0,
	[YTD03] [float] NULL default 0,
	[YTD04] [float] NULL default 0,
	[YTD05] [float] NULL default 0,
	[YTD06] [float] NULL default 0,
	[YTD07] [float] NULL default 0,
	[YTD08] [float] NULL default 0,
	[YTD09] [float] NULL default 0,
	[YTD10] [float] NULL default 0,
	[YTD11] [float] NULL default 0,
	[YTD12] [float] NULL default 0,
	[YTD13] [float] NULL default 0,
	[YTD14] [float] NULL default 0,
	[YTD15] [float] NULL default 0,
	[YTD16] [float] NULL default 0,
	[YTD17] [float] NULL default 0,
	[YTD18] [float] NULL default 0,
	[YTD19] [float] NULL default 0,
	[YTD20] [float] NULL default 0,
	[YTD21] [float] NULL default 0,
	[YTD22] [float] NULL default 0,
	[YTD23] [float] NULL default 0,
	[YTD24] [float] NULL default 0,
	[YTD25] [float] NULL default 0,
	[YTD26] [float] NULL default 0,
	[YTD27] [float] NULL default 0,
	[YTD28] [float] NULL default 0,
	[YTD29] [float] NULL default 0,
	[YTD30] [float] NULL default 0,
	[YTD31] [float] NULL default 0,
	[YTD32] [float] NULL default 0,
	[YTD33] [float] NULL default 0,
	[YTD34] [float] NULL default 0,
	[YTD35] [float] NULL default 0,
	[YTD36] [float] NULL default 0,
	[YTD37] [float] NULL default 0,
	[YTD38] [float] NULL default 0,
	[YTD39] [float] NULL default 0,
	[YTD40] [float] NULL default 0,
	[YTD41] [float] NULL default 0,
	[YTD42] [float] NULL default 0,
	[YTD43] [float] NULL default 0,
	[YTD44] [float] NULL default 0,
	[YTD45] [float] NULL default 0,
	[YTD46] [float] NULL default 0,
	[YTD47] [float] NULL default 0,
	[YTD48] [float] NULL default 0,
--	[YTD49] [float] NULL default 0,
--	[YTD50] [float] NULL default 0,
--	[YTD51] [float] NULL default 0,
--	[YTD52] [float] NULL default 0,
--	[YTD53] [float] NULL default 0,
--	[YTD54] [float] NULL default 0,
--	[YTD55] [float] NULL default 0,
--	[YTD56] [float] NULL default 0,
--	[YTD57] [float] NULL default 0,
--	[YTD58] [float] NULL default 0,
--	[YTD59] [float] NULL default 0,
--	[YTD60] [float] NULL default 0,
	
    [Qtr00] [float] NULL default 0,
	[Qtr01] [float] NULL default 0,
	[Qtr02] [float] NULL default 0,
	[Qtr03] [float] NULL default 0,
	[Qtr04] [float] NULL default 0,
	[Qtr05] [float] NULL default 0,
	[Qtr06] [float] NULL default 0,
	[Qtr07] [float] NULL default 0,
	[Qtr08] [float] NULL default 0,
	[Qtr09] [float] NULL default 0,
	[Qtr10] [float] NULL default 0,
	[Qtr11] [float] NULL default 0,
	[Qtr12] [float] NULL default 0,
	[Qtr13] [float] NULL default 0,
	[Qtr14] [float] NULL default 0,
	[Qtr15] [float] NULL default 0,
	[Qtr16] [float] NULL default 0,
	[Qtr17] [float] NULL default 0,
	[Qtr18] [float] NULL default 0,
	[Qtr19] [float] NULL default 0
) ON [PRIMARY]

GO
select * into TempCityDashboard_Mole from TempCityDashboard where 1=2
go
exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','TempCityDashboard',null,null

declare @i int,@sql varchar(max),@sql1 varchar(max),@sql3 varchar(max),@sqlMAT varchar(max),
	@sqlYTD varchar(max),@sqlQtr varchar(max), @sqlMQT varchar(max)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(max)
DECLARE @SQL4 VARCHAR(max)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN
	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		if @MoneyType='UN'
			set @MoneyType=@MoneyType+'/b.rat'
		set @i=0
		set @sql1=''
        set @sql3=''
        while (@i<=45)
		begin
			set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end

        set @i=0    
        while (@i<=48)
		begin
			set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
			set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
		while (@i<=48)
		begin
			set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)


        set @i=0
        set @sqlQtr=''
		while (@i<=19)
		begin
			set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
        set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		set @sql2 = 'insert into TempCityDashboard 
        	select distinct B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,'+'''' +left(@MoneyType,2)+''''+' as Moneytype, A.audi_cod,'''',''City'',null,'+@sql1+', '+@sql3+', '
        
		set @sql4 = @sqlMAT+', '+@sqlYTD+', ' + @sqlQtr+'
			from mthcity_pkau A 
			inner join tblMktDef_MAX B
			on A.pack_cod=B.pack_cod 
			where B.Active=''Y'' and A.audi_cod<>''ZJH_'' and b.mkt not like''eliquis%''
			group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname,A.audi_cod'
		exec (@sql2+@sql4)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go

declare @i int,@sql varchar(max),@sql1 varchar(max),@sql3 varchar(max),@sqlMAT varchar(max),
	@sqlYTD varchar(max),@sqlQtr varchar(max), @sqlMQT varchar(max)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(max)
DECLARE @SQL4 VARCHAR(max)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		set @MoneyType=@MoneyType+'*b.rat'
		set @i=0
		set @sql1=''
        set @sql3=''
        while (@i<=45)
		begin
			set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end

        set @i=0    
        while (@i<=48)
		begin
			set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
			set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
		while (@i<=48)
		begin
			set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
        set @sqlQtr=''
		while (@i<=19)
		begin
			set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
        set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		set @sql2='insert into TempCityDashboard 
        	select distinct B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,'+'''' +left(@MoneyType,2)
			+''''+' as Moneytype, A.audi_cod,'''',''City'',null,'+@sql1+', '+@sql3+', '
        
		set @sql4 = @sqlMAT+', '+@sqlYTD+', ' + @sqlQtr+'
			from mthcity_pkau A 
			inner join tblMktDef_MAX B
			on A.pack_cod=B.pack_cod 
			where B.Active=''Y'' and A.audi_cod<>''ZJH_'' and b.mkt like''eliquis%''
			group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname,A.audi_cod'
		exec (@sql2+@sql4)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go


update TempCityDashboard
set AUDI_des=City
from TempCityDashboard A 
inner join dbo.tblcitymax B
on A.AUDI_cod = B.city 
go

update TempCityDashboard
set Market=case  
		when Market in ('HYP','ACE') then 'Monopril'
		when Market in ('NIAD','DIA') then 'Glucophage'
		when Market in ('ONC','ONCFCS') then 'Taxol' 
		when Market in ('HBV','ARV') then 'Baraclude'
		when Market in ('DPP4') then 'Onglyza' 
		when Market in ('CML') then 'Sprycel' 
		when Market in ('Platinum') then 'Paraplatin'
		when Market in ('CCB') then 'Coniel'
		else Market end
go

insert into TempCityDashboard (Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
	Audi_cod,audi_des,lev)
select  Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
	Audi_cod,audi_des,lev 
from (
		select A.*,Audi_cod,audi_des,lev 
		from 
			(select distinct Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype from TempCityDashboard) A
		inner join
			(select distinct  Molecule,Class,mkt,mktname,Market,Moneytype,Audi_cod,audi_des,lev from TempCityDashboard) B
		on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
			and a.Moneytype=b.Moneytype
	) A 
where not exists(
	select * from TempCityDashboard B
	where a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
		and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and a.Prod=B.Prod)
go
update TempCityDashboard
set Tier=B.Tier 
from TempCityDashboard A 
inner join tblCityMax B
on A.Audi_cod = B.city
go

go

exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','TempCityDashboard_Mole',null,null


declare @i int,@sql varchar(max),@sql1 varchar(max),@sql3 varchar(max),@sqlMAT varchar(max),
	@sqlYTD varchar(max),@sqlQtr varchar(max), @sqlMQT varchar(max)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(max)
DECLARE @SQL4 VARCHAR(max)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		if @MoneyType='UN'
			set @MoneyType=@MoneyType+'/b.rat'
		set @i=0
		set @sql1=''
        set @sql3=''
        while (@i<=45)
		begin
		set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end

        set @i=0    
        while (@i<=48)
		begin
		set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
		set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
        while (@i<=48)
		begin
		set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)


        set @i=0
        set @sqlQtr=''
		while (@i<=19)
		begin
		set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
		set @i=@i+1
		end
        set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		set @sql2='insert into TempCityDashboard_Mole 
        select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,'+'''' +left(@MoneyType,2)+''''+' as Moneytype, A.audi_cod,'''',''City'',null,'+@sql1+', '+@sql3+', '
        
		set @sql4 = @sqlMAT+', '+@sqlYTD+', ' + @sqlQtr+'
		from mthcity_pkau A 
		inner join tblMktDef_MAX B
        on A.pack_cod=B.pack_cod where B.Active=''Y'' and A.audi_cod <>''ZJH_''
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname,A.audi_cod'
		exec (@sql2+@sql4)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR

go

update TempCityDashboard_Mole
set AUDI_des=City
from TempCityDashboard_Mole A 
inner join dbo.tblcitymax B
on A.AUDI_cod = B.City 
go

update TempCityDashboard_Mole
set Market=case Market 
	when 'Paclitaxel' then 'Taxol' 
	when 'Metformin' then 'Glucophage'
	when 'ACEI' then 'Monopril'
	when 'Entecavir' then 'Baraclude'
	when 'Carboplatin' then 'Paraplatin'
	when 'CCB' then 'Coniel'
	else Market end
go

insert into TempCityDashboard_Mole (Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
	Audi_cod,audi_des,lev)
select  Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
	Audi_cod,audi_des,lev 
from (
	select A.*,Audi_cod,audi_des,lev 
	from 
		(select distinct Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype from TempCityDashboard_Mole) A
	inner join
		(select distinct  Molecule,Class,mkt,mktname,Market,Moneytype,Audi_cod,audi_des,lev from TempCityDashboard_Mole) B
	on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
		and a.Moneytype=b.Moneytype
) A 
where not exists(
	select * from TempCityDashboard_Mole B
	where a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
		and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and a.Prod=B.Prod
	)
go
update TempCityDashboard_Mole
set Tier=B.Tier 
from TempCityDashboard_Mole A 
inner join tblCityMax B
on A.Audi_cod= B.City
go


if exists (select * from dbo.sysobjects where id = object_id(N'TempCityDashboard_forPre') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table TempCityDashboard_forPre
go
select * into TempCityDashboard_forPre from TempCityDashboard where audi_des <>'Guangdong' and audi_des <>'Zhejiang'
go

if exists (select * from dbo.sysobjects where id = object_id(N'TempCityDashboard_AllCity') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table TempCityDashboard_AllCity
go
select * into TempCityDashboard_AllCity from TempCityDashboard where audi_des <>'Zhejiang' 
go

--select  market,count(distinct audi_des) from TempCityDashboard
--group by market
delete TempCityDashboard 
from TempCityDashboard A
where not exists(
		select * from dbo.outputgeo B
		where A.Market=B.Product and A.audi_des=b.geo
		) 
	and market not like 'eliquis%'
go


------------------------------------------------------
-- TempRegionCityDashboard
------------------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'TempRegionCityDashboard') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table TempRegionCityDashboard
go
select * into TempRegionCityDashboard from TempCityDashboard where 1=2
go
Alter table TempRegionCityDashboard add Region varchar(200)
go
insert into TempRegionCityDashboard
select A.*,B.ParentGeo 
from TempCityDashboard A 
inner join dbo.outputgeo B
on A.Market=B.Product and A.audi_des=b.geo
go

insert into TempRegionCityDashboard
select A.*,B.ParentGeo 
from TempCityDashboard A 
inner join dbo.outputgeo B
on left(A.Market,7)=B.Product and A.audi_des=b.geo
where a.mkt in ('Eliquis NOAC','Eliquis VTEt','Eliquis VTEp')
go

Alter table TempRegionCityDashboard drop column Tier
go
exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','TempRegionCityDashboard',null,null

declare @i int,@sql varchar(max),@sql1 varchar(max),@sql3 varchar(max),@sqlMAT varchar(max),
	@sqlYTD varchar(max),@sqlQtr varchar(max), @sqlMQT varchar(max)
DECLARE @SQL2 VARCHAR(max)
	set @i=0
	set @sql1=''
	set @sql3=''
	while (@i<=45)
	begin
		set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+',0)),'
		set @i=@i+1
	end

	set @i=0    
	while (@i<=48)
	begin
		set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+',0)) ,'
		set @i=@i+1
	end
	set @sql1=left(@sql1,len(@sql1)-1)
	set @sql3=left(@sql3,len(@sql3)-1)

	set @i=0
	set @sqlMAT=''
	while (@i<=48)
	begin
		set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+',0)),'
		set @i=@i+1
	end
	set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

	set @i=0
	set @sqlYTD=''
--		while (@i<=60)
	while (@i<=48)
	begin
		set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+',0)),'
		set @i=@i+1
	end
	set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)


	set @i=0
	set @sqlQtr=''
	while (@i<=19)
	begin
		set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+',0)),'
		set @i=@i+1
	end
	set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
	--print @sql1

	exec('
	insert into TempRegionCityDashboard
	select [Molecule],[Class],[mkt],[mktname],Market,[prod],[Productname],MoneyType,
		[Region],[Region],''Region'','+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', ' + @sqlQtr+',[Region] 
	from TempRegionCityDashboard A
	group by [Molecule],[Class],[mkt],[mktname],Market,[prod],[Productname],[Moneytype],[Region]')
go
declare @i int,@sql varchar(max),@sql1 varchar(max),@sql3 varchar(max),@sqlMAT varchar(2000),
	@sqlYTD varchar(2000),@sqlQtr varchar(2000), @sqlMQT varchar(max)
DECLARE @SQL2 VARCHAR(max)
		set @i=0
		set @sql1=''
        set @sql3=''
--		while (@i<=57)
		while (@i<=45)
		begin
			set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+',0)),'
			set @i=@i+1
		end

        set @i=0    
--		while (@i<=59)
		while (@i<=48)
		begin
			set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+',0)) ,'
			set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
			set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+',0)),'
			set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
--		while (@i<=60)
		while (@i<=48)
		begin
			set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+',0)),'
			set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)


        set @i=0
        set @sqlQtr=''
		while (@i<=19)
		begin
			set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+',0)),'
			set @i=@i+1
		end
        set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		exec('
		insert into TempRegionCityDashboard
		select [Molecule],[Class],[mkt],[mktname],Market,[prod],[Productname],MoneyType,
			''China'',''China'',''China'','+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD + ', '  + @sqlQtr+',''China'' 
		from TempCityDashboard A
        where exists(select * from dbo.outputgeo B where A.Market=B.Product and A.audi_des=b.geo)
		group by [Molecule],[Class],[mkt],[mktname],Market,[prod],[Productname],[Moneytype]')
go
delete from TempRegionCityDashboard where region=''

go

-- ------------------------------------------------------
-- --	Eliquis Market CHPA Middle Table
-- ------------------------------------------------------
-- --Market Definition
-- if OBJECT_ID(N'tblMktDef_Inline_For_Eliquis',N'U') is not null
-- 	drop table tblMktDef_Inline_For_Eliquis
-- go
-- select * into tblMktDef_Inline_For_Eliquis from tblMktDef_Inline where 1=2

-- insert into tblMktDef_Inline_For_Eliquis
-- select cast('ELIQUIS VTEp' as varchar(50)) as Mkt,cast('Eliquis (VTEp) Market' as varchar(50)) as MktName,* 
-- from tblMktDef_ATCDriver
-- where prod_des in ('Fraxiparine','Clexane','Xarelto','Arixtra','Eliquis')
-- go

-- if OBJECT_ID(N'tblMktDef_MRBIChina_For_Eliquis',N'U') is not null
-- 	drop table tblMktDef_MRBIChina_For_Eliquis
-- go
-- select * into tblMktDef_MRBIChina_For_Eliquis from tblMktDef_MRBIChina where 1=2

-- insert into tblMktDef_MRBIChina_For_Eliquis
-- SELECT distinct 
-- 	'Eliquis VTEp' Mkt,'Eliquis (VTEp) Market' MktName
-- 	,'000' as Prod,'Eliquis VTEp' as ProductName
-- 	,'N' as Molecule
-- 	,'N' as Class
-- 	,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
-- 	,pack_cod, Pack_des
-- 	,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
-- 	,'' Mole_cod
-- 	,'' Mole_Name
-- 	,Corp_cod
-- 	,Manu_Cod
-- 	,Gene_Cod
-- 	,'Y' as Active
-- 	,GetDate() as Date, '201404 add new products & packages' as Comment
-- 	,1
-- FROM tblMktDef_Inline_For_Eliquis A WHERE A.MKT = 'ELIQUIS VTEp' and prod_des <>'Pradaxa'

-- insert into tblMktDef_MRBIChina_For_Eliquis
-- SELECT distinct 
--    'Eliquis VTEp' as Mkt
--   ,'Eliquis (VTEp) Market' as MktName
--   ,case when a.Prod_Des='ELIQUIS' then '100'   
--         when a.Prod_Des='CLEXANE' then '200'     
--         when a.Prod_Des='XARELTO' then '300'        
--         when a.Prod_Des='FRAXIPARINE' then '400'      
--         when a.Prod_Des='ARIXTRA' then '500' 
--         end   as [Prod]         
--   ,a.Prod_Des as ProductName
--   ,'N'        as Molecule
--   ,'N'        as Class 
--   ,ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod
--   ,pack_cod, Pack_des
--   ,Prod_cod,Prod_des as Prod_Name,Prod_des + ' (' +Manu_cod +')' as Prod_FullName
--   ,'' Mole_cod,'' Mole_Name
--   ,Corp_cod
--   ,Manu_Cod
--   ,Gene_Cod
--   ,'Y'       as Active
--   ,GetDate() as Date, '201404 add new products & packages'  -- select * 
--   ,1
-- FROM tblMktDef_Inline_For_Eliquis A 
-- WHERE A.MKT = 'Eliquis VTEp' 

-- --alter table tblMktDef_MRBIChina_For_Eliquis add  Rat float
-- go
-- update tblMktDef_MRBIChina_For_Eliquis
-- set Rat = case when Prod_Name='Fraxiparine' then 1
-- 				when Prod_Name='Clexane' then 1
-- 				when Prod_Name='Xarelto' then 1
-- 				when Prod_Name='Arixtra' then 1
-- 				when Prod_Name='Eliquis' then 1 end

-- go

-- --CHPA Middle table

-- IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'TempCHPAPreReports_For_Eliquis') AND TYPE ='U')
-- 	DROP TABLE TempCHPAPreReports_For_Eliquis

-- select * into TempCHPAPreReports_For_Eliquis from TempCHPAPreReports where 1=2

-- declare @i int,@sql varchar(max),@sql1 varchar(max),@sql3 varchar(max),@sqlMAT varchar(max),@sqlYTD varchar(max),@sqlQtr varchar(max)
-- DECLARE TMP_CURSOR CURSOR
-- READ_ONLY
-- FOR select [Type]  from dbo.tblMoneyType
-- DECLARE @MoneyType varchar(10)
-- DECLARE @SQL2_1 VARCHAR(max)
-- DECLARE @SQL2_2 VARCHAR(max)
	
-- OPEN TMP_CURSOR
	
-- FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
-- WHILE (@@FETCH_STATUS <> -1)
-- BEGIN

-- 	IF (@@FETCH_STATUS <> -2)
-- 	BEGIN
-- 		print @MoneyType
-- 		set @i=0
-- 		set @sql1=''
--         set @sql3=''
-- 		while (@i<=48)
-- 		begin
-- 		set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*Rat as R3M'+right('00'+cast(@i as varchar(3)),2)+','
-- 		set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*Rat as MTH'+right('00'+cast(@i as varchar(3)),2)+','
-- 		set @i=@i+1
-- 		end
-- 		set @sql1=left(@sql1,len(@sql1)-1)
--         set @sql3=left(@sql3,len(@sql3)-1)

--         set @i=0
-- 		set @sqlMAT=''
-- 		while (@i<=48)
-- 		begin
-- 		set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*Rat as MAT'+right('00'+cast(@i as varchar(3)),2)+','
-- 		set @i=@i+1
-- 		end
-- 		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

--         set @i=0
--         set @sqlYTD=''
-- 		while (@i<=48)
-- 		begin
-- 		set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*Rat as YTD'+right('00'+cast(@i as varchar(3)),2)+','
-- 		set @i=@i+1
-- 		end
--         set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

--         set @i=0
-- 		set @sqlQtr=''
-- 		while (@i<=19)
-- 		begin
-- 		set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*Rat as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
-- 		set @i=@i+1
-- 		end
-- 		set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
-- 		--print @sql1

-- 		set @SQL2_1='insert into TempCHPAPreReports_For_Eliquis 
-- 			select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,
-- 	--         A.MNFL_COD,B.Gene_cod,
-- 			'+'''' +@MoneyType+''''+' as Moneytype, '+@sql1+', '+@sql3+', '
--         set @SQL2_2=@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
-- 			from mthCHPA_pkau A inner join tblMktDef_MRBIChina_For_Eliquis B
-- 			on A.pack_cod=B.pack_cod where B.Active=''Y'' and b.prod<>''000'' and b.ProductName <>''Pradaxa''
-- 			group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname,B.Rat'
--        	print @SQL2_1+@SQL2_2
-- 		exec( @SQL2_1+@SQL2_2)
-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
-- go
-- update TempCHPAPreReports_For_Eliquis
-- set Market=case Market 
-- 	when 'ONC' then 'Taxol' 
-- 	when 'HYP' then 'Monopril'
-- 	when 'NIAD' then 'Glucophage'
-- 	when 'ACE' then 'Monopril'
-- 	when 'DIA' then 'Glucophage'
-- 	when 'ONCFCS' then 'Taxol'
-- 	when 'HBV' then 'Baraclude'
-- 	when 'ARV' then 'Baraclude' when 'DPP4' then 'Onglyza' when 'CML' then 'Sprycel' 
-- 	when 'Platinum' then 'Paraplatin'
-- else Market end
-- go

-- delete 
-- from TempCHPAPreReports_For_Eliquis
-- where Market <> 'Paraplatin' and MoneyType = 'PN'
-- go
-- declare @i int,@sql varchar(max),@sql1 varchar(max),@sql3 varchar(max),@sqlMAT varchar(max),@sqlYTD varchar(max),@sqlQtr varchar(max)	

-- set @i=0
-- set @sql1=''
-- set @sql3=''
-- while (@i<=48)
-- begin
-- 	set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
-- 	set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
-- 	set @i=@i+1
-- end
-- set @sql1=left(@sql1,len(@sql1)-1)
-- set @sql3=left(@sql3,len(@sql3)-1)

-- set @i=0
-- set @sqlMAT=''
-- while (@i<=48)
-- begin
-- 	set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
-- 	set @i=@i+1
-- end
-- set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

-- set @i=0
-- set @sqlYTD=''
-- while (@i<=48)
-- begin
-- 	set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
-- 	set @i=@i+1
-- end
-- set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

-- set @i=0
-- set @sqlQtr=''
-- while (@i<=19)
-- begin
-- 	set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
-- 	set @i=@i+1
-- end
-- set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)

-- set @sql ='insert into TempCHPAPreReports_For_Eliquis 
-- 		select Molecule,Class,mkt,mktname,Market,''000'',''VTEp Market'',MoneyType,'+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
-- 		from TempCHPAPreReports_For_Eliquis
-- 		group by Molecule,Class,mkt,mktname,Market,MoneyType			
-- 	'
-- print @sql	
-- exec (@sql)

-- if object_id(N'TempCityDashboard_For_Eliquis',N'U') is not null
-- 	drop table TempCityDashboard_For_Eliquis 
-- go
-- select * into TempCityDashboard_For_Eliquis from TempCityDashboard WHERE 1=0
-- declare @i int,@sql varchar(max),@sql1 varchar(max),@sql3 varchar(max),@sqlMAT varchar(2000),@sqlYTD varchar(2000),@sqlQtr varchar(2000)
-- DECLARE TMP_CURSOR CURSOR
-- READ_ONLY
-- FOR select [Type]  from dbo.tblMoneyType
-- DECLARE @MoneyType varchar(10)
-- DECLARE @SQL2 VARCHAR(max)
	
-- OPEN TMP_CURSOR
	
-- FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
-- WHILE (@@FETCH_STATUS <> -1)
-- BEGIN

-- 	IF (@@FETCH_STATUS <> -2)
-- 	BEGIN
-- 		print @MoneyType
-- 		set @i=0
-- 		set @sql1=''
--         set @sql3=''
-- --		while (@i<=57)
--         while (@i<=45)
-- 		begin
-- 			set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*RAT as R3M'+right('00'+cast(@i as varchar(3)),2)+','
-- 			set @i=@i+1
-- 		end

--         set @i=0    
-- --		while (@i<=59)
--         while (@i<=48)
-- 		begin
-- 			set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*RAT as MTH'+right('00'+cast(@i as varchar(3)),2)+','
-- 			set @i=@i+1
-- 		end
-- 		set @sql1=left(@sql1,len(@sql1)-1)
--         set @sql3=left(@sql3,len(@sql3)-1)

--         set @i=0
-- 		set @sqlMAT=''
-- 		while (@i<=48)
-- 		begin
-- 			set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*RAT as MAT'+right('00'+cast(@i as varchar(3)),2)+','
-- 			set @i=@i+1
-- 		end
-- 		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

--         set @i=0
--         set @sqlYTD=''
-- --		while (@i<=60)
-- 		while (@i<=48)
-- 		begin
-- 			set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*RAT as YTD'+right('00'+cast(@i as varchar(3)),2)+','
-- 			set @i=@i+1
-- 		end
--         set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

--         set @i=0
--         set @sqlQtr=''
-- 		while (@i<=19)
-- 		begin
-- 			set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0))*RAT as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
-- 			set @i=@i+1
-- 		end
--         set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
-- 		--print @sql1

-- 		exec('insert into TempCityDashboard_For_Eliquis 
--         select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,'+'''' +@MoneyType+''''+' as Moneytype, A.audi_cod,'''',''City'',null,'+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
-- 		from mthcity_pkau A inner join tblMktDef_MRBIChina_For_Eliquis B
--         on A.pack_cod=B.pack_cod where B.Active=''Y''  and b.prod<>''000''  and b.ProductName <>''Pradaxa''
-- 		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname,A.audi_cod,B.RAT')
-- 	END
-- 	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
-- END
-- CLOSE TMP_CURSOR
-- DEALLOCATE TMP_CURSOR
-- go

-- declare @i int,@sql varchar(max),@sql1 varchar(max),@sql3 varchar(max),@sqlMAT varchar(2000),@sqlYTD varchar(2000),@sqlQtr varchar(2000)
-- DECLARE @MoneyType varchar(10)
-- DECLARE @SQL2 VARCHAR(max)
-- 	set @i=0
-- 	set @sql1=''
--     set @sql3=''
-- --		while (@i<=57)
--     while (@i<=45)
-- 	begin
-- 		set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
-- 		set @i=@i+1
-- 	end

--     set @i=0    
-- --		while (@i<=59)
--     while (@i<=48)
-- 	begin
-- 		set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
-- 		set @i=@i+1
-- 	end
-- 	set @sql1=left(@sql1,len(@sql1)-1)
--     set @sql3=left(@sql3,len(@sql3)-1)

--     set @i=0
-- 	set @sqlMAT=''
-- 	while (@i<=48)
-- 	begin
-- 		set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
-- 		set @i=@i+1
-- 	end
-- 	set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

--     set @i=0
--     set @sqlYTD=''
-- --		while (@i<=60)
-- 	while (@i<=48)
-- 	begin
-- 		set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
-- 		set @i=@i+1
-- 	end
--     set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

--     set @i=0
--     set @sqlQtr=''
-- 	while (@i<=19)
-- 	begin
-- 		set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
-- 		set @i=@i+1
-- 	end
--     set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
-- 	--print @sql1

-- 	exec('insert into TempCityDashboard_For_Eliquis 		
--     select  Molecule,Class,mkt,mktname,market,''000'',''VTEp Market'',moneyType,audi_cod,audi_des,lev,tier,'+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
-- 	from TempCityDashboard_For_Eliquis
-- 	group by Molecule,Class,mkt,mktname,market,moneyType,audi_cod,audi_des,lev,tier')
-- go

-- update TempCityDashboard_For_Eliquis
-- set AUDI_des=City_Name from TempCityDashboard_For_Eliquis A inner join dbo.Dim_City B
-- on A.AUDI_cod=B.City_Code+'_'
-- go

-- update TempCityDashboard_For_Eliquis
-- set Market=case  
-- 	when Market in ('HYP','ACE') then 'Monopril'
-- 	when Market in ('NIAD','DIA') then 'Glucophage'
-- 	when Market in ('ONC','ONCFCS') then 'Taxol' 
-- 	when Market in ('HBV','ARV') then 'Baraclude'
-- 	when Market in ('DPP4') then 'Onglyza' 
-- 	when Market in ('CML') then 'Sprycel' 
-- 	when Market in ('Platinum') then 'Paraplatin'
-- 	when Market in ('CCB') then 'Coniel'
-- 	else Market end
-- go

-- insert into TempCityDashboard_For_Eliquis (Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
-- 	Audi_cod,audi_des,lev)
-- select  Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
-- 	Audi_cod,audi_des,lev 
-- from (
-- 	select A.*,Audi_cod,audi_des,lev from 
-- 	(select distinct Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype from TempCityDashboard_For_Eliquis) A
-- 	inner join
-- 	(select distinct  Molecule,Class,mkt,mktname,Market,Moneytype,Audi_cod,audi_des,lev from TempCityDashboard_For_Eliquis) B
-- 	on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
-- 	and a.Moneytype=b.Moneytype
-- ) A 
-- where not exists(
-- 	select * from TempCityDashboard_For_Eliquis B
-- 	where a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
-- 		and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and a.Prod=B.Prod)
-- go

-- update TempCityDashboard_For_Eliquis
-- set Tier=B.Tier from TempCityDashboard_For_Eliquis A inner join Dim_City B
-- on A.Audi_cod=B.CIty_Code+'_'


-- --------------------------------------------------------
-- ----	Eliquis Ending
-- --------------------------------------------------------
GO





--select * from TempRegionCityDashboard
exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','OutputGeoHBVSummaryT1',null,null
if exists (select * from dbo.sysobjects where id = object_id(N'[OutputGeoHBVSummaryT1]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [OutputGeoHBVSummaryT1]
GO
select B.[Molecule],B.[Class],B.[mkt],B.Market,B.[mktname],B.[prod],B.[Productname],B.[Moneytype]
      ,B.[Audi_cod],B.[Audi_des],B.[Region],
	case isnull(A.R3M00,0) when 0 then 0 else isnull(B.R3M00,0)*1.0/isnull(A.R3M00,0) end  as R3M00,
	case isnull(A.R3M01,0) when 0 then 0 else isnull(B.R3M01,0)*1.0/isnull(A.R3M01,0) end  as R3M01,
	case isnull(A.R3M02,0) when 0 then 0 else isnull(B.R3M02,0)*1.0/isnull(A.R3M02,0) end  as R3M02,
	case isnull(A.R3M03,0) when 0 then 0 else isnull(B.R3M03,0)*1.0/isnull(A.R3M03,0) end  as R3M03,
	case isnull(A.R3M04,0) when 0 then 0 else isnull(B.R3M04,0)*1.0/isnull(A.R3M04,0) end  as R3M04,
	case isnull(A.R3M05,0) when 0 then 0 else isnull(B.R3M05,0)*1.0/isnull(A.R3M05,0) end  as R3M05,
	case isnull(A.R3M06,0) when 0 then 0 else isnull(B.R3M06,0)*1.0/isnull(A.R3M06,0) end  as R3M06,
	case isnull(A.R3M07,0) when 0 then 0 else isnull(B.R3M07,0)*1.0/isnull(A.R3M07,0) end  as R3M07,
	case isnull(A.R3M08,0) when 0 then 0 else isnull(B.R3M08,0)*1.0/isnull(A.R3M08,0) end  as R3M08,
	case isnull(A.R3M09,0) when 0 then 0 else isnull(B.R3M09,0)*1.0/isnull(A.R3M09,0) end  as R3M09,
	case isnull(A.R3M10,0) when 0 then 0 else isnull(B.R3M10,0)*1.0/isnull(A.R3M10,0) end  as R3M10,
	case isnull(A.R3M11,0) when 0 then 0 else isnull(B.R3M11,0)*1.0/isnull(A.R3M11,0) end  as R3M11,
	case isnull(A.R3M12,0) when 0 then 0 else isnull(B.R3M12,0)*1.0/isnull(A.R3M12,0) end  as R3M12,
	case isnull(A.R3M13,0) when 0 then 0 else isnull(B.R3M13,0)*1.0/isnull(A.R3M13,0) end  as R3M13,
	case isnull(A.R3M14,0) when 0 then 0 else isnull(B.R3M14,0)*1.0/isnull(A.R3M14,0) end  as R3M14,
	case isnull(A.R3M15,0) when 0 then 0 else isnull(B.R3M15,0)*1.0/isnull(A.R3M15,0) end  as R3M15,
	case isnull(A.R3M16,0) when 0 then 0 else isnull(B.R3M16,0)*1.0/isnull(A.R3M16,0) end  as R3M16,
	case isnull(A.R3M17,0) when 0 then 0 else isnull(B.R3M17,0)*1.0/isnull(A.R3M17,0) end  as R3M17,
	case isnull(A.R3M18,0) when 0 then 0 else isnull(B.R3M18,0)*1.0/isnull(A.R3M18,0) end  as R3M18,
	case isnull(A.R3M19,0) when 0 then 0 else isnull(B.R3M19,0)*1.0/isnull(A.R3M19,0) end  as R3M19,
	case isnull(A.R3M20,0) when 0 then 0 else isnull(B.R3M20,0)*1.0/isnull(A.R3M20,0) end  as R3M20,
	case isnull(A.R3M21,0) when 0 then 0 else isnull(B.R3M21,0)*1.0/isnull(A.R3M21,0) end  as R3M21,
	case isnull(A.R3M22,0) when 0 then 0 else isnull(B.R3M22,0)*1.0/isnull(A.R3M22,0) end  as R3M22,
	case isnull(A.R3M23,0) when 0 then 0 else isnull(B.R3M23,0)*1.0/isnull(A.R3M23,0) end  as R3M23,
	case isnull(A.R3M24,0) when 0 then 0 else isnull(B.R3M24,0)*1.0/isnull(A.R3M24,0) end  as R3M24,
	
	case isnull(A.MTH00,0) when 0 then 0 else isnull(B.MTH00,0)*1.0/isnull(A.MTH00,0) end  as MTH00,
	case isnull(A.MTH01,0) when 0 then 0 else isnull(B.MTH01,0)*1.0/isnull(A.MTH01,0) end  as MTH01,
	case isnull(A.MTH02,0) when 0 then 0 else isnull(B.MTH02,0)*1.0/isnull(A.MTH02,0) end  as MTH02,
	case isnull(A.MTH03,0) when 0 then 0 else isnull(B.MTH03,0)*1.0/isnull(A.MTH03,0) end  as MTH03,
	case isnull(A.MTH04,0) when 0 then 0 else isnull(B.MTH04,0)*1.0/isnull(A.MTH04,0) end  as MTH04,
	case isnull(A.MTH05,0) when 0 then 0 else isnull(B.MTH05,0)*1.0/isnull(A.MTH05,0) end  as MTH05,
	case isnull(A.MTH06,0) when 0 then 0 else isnull(B.MTH06,0)*1.0/isnull(A.MTH06,0) end  as MTH06,
	case isnull(A.MTH07,0) when 0 then 0 else isnull(B.MTH07,0)*1.0/isnull(A.MTH07,0) end  as MTH07,
	case isnull(A.MTH08,0) when 0 then 0 else isnull(B.MTH08,0)*1.0/isnull(A.MTH08,0) end  as MTH08,
	case isnull(A.MTH09,0) when 0 then 0 else isnull(B.MTH09,0)*1.0/isnull(A.MTH09,0) end  as MTH09,
	case isnull(A.MTH10,0) when 0 then 0 else isnull(B.MTH10,0)*1.0/isnull(A.MTH10,0) end  as MTH10,
	case isnull(A.MTH11,0) when 0 then 0 else isnull(B.MTH11,0)*1.0/isnull(A.MTH11,0) end  as MTH11,
	case isnull(A.MTH12,0) when 0 then 0 else isnull(B.MTH12,0)*1.0/isnull(A.MTH12,0) end  as MTH12,
	case isnull(A.MTH13,0) when 0 then 0 else isnull(B.MTH13,0)*1.0/isnull(A.MTH13,0) end  as MTH13,
	case isnull(A.MTH14,0) when 0 then 0 else isnull(B.MTH14,0)*1.0/isnull(A.MTH14,0) end  as MTH14,
	case isnull(A.MTH15,0) when 0 then 0 else isnull(B.MTH15,0)*1.0/isnull(A.MTH15,0) end  as MTH15,
	case isnull(A.MTH16,0) when 0 then 0 else isnull(B.MTH16,0)*1.0/isnull(A.MTH16,0) end  as MTH16,
	case isnull(A.MTH17,0) when 0 then 0 else isnull(B.MTH17,0)*1.0/isnull(A.MTH17,0) end  as MTH17,
	case isnull(A.MTH18,0) when 0 then 0 else isnull(B.MTH18,0)*1.0/isnull(A.MTH18,0) end  as MTH18,
	case isnull(A.MTH19,0) when 0 then 0 else isnull(B.MTH19,0)*1.0/isnull(A.MTH19,0) end  as MTH19,
	case isnull(A.MTH20,0) when 0 then 0 else isnull(B.MTH20,0)*1.0/isnull(A.MTH20,0) end  as MTH20,
	case isnull(A.MTH21,0) when 0 then 0 else isnull(B.MTH21,0)*1.0/isnull(A.MTH21,0) end  as MTH21,
	case isnull(A.MTH22,0) when 0 then 0 else isnull(B.MTH22,0)*1.0/isnull(A.MTH22,0) end  as MTH22,
	case isnull(A.MTH23,0) when 0 then 0 else isnull(B.MTH23,0)*1.0/isnull(A.MTH23,0) end  as MTH23,
	case isnull(A.MTH24,0) when 0 then 0 else isnull(B.MTH24,0)*1.0/isnull(A.MTH24,0) end  as MTH24,

	case isnull(A.MAT00,0) when 0 then 0 else isnull(B.MAT00,0)*1.0/isnull(A.MAT00,0) end  as MAT00,
	case isnull(A.MAT01,0) when 0 then 0 else isnull(B.MAT01,0)*1.0/isnull(A.MAT01,0) end  as MAT01,
	case isnull(A.MAT02,0) when 0 then 0 else isnull(B.MAT02,0)*1.0/isnull(A.MAT02,0) end  as MAT02,
	case isnull(A.MAT03,0) when 0 then 0 else isnull(B.MAT03,0)*1.0/isnull(A.MAT03,0) end  as MAT03,
	case isnull(A.MAT04,0) when 0 then 0 else isnull(B.MAT04,0)*1.0/isnull(A.MAT04,0) end  as MAT04,
	case isnull(A.MAT05,0) when 0 then 0 else isnull(B.MAT05,0)*1.0/isnull(A.MAT05,0) end  as MAT05,
	case isnull(A.MAT06,0) when 0 then 0 else isnull(B.MAT06,0)*1.0/isnull(A.MAT06,0) end  as MAT06,
	case isnull(A.MAT07,0) when 0 then 0 else isnull(B.MAT07,0)*1.0/isnull(A.MAT07,0) end  as MAT07,
	case isnull(A.MAT08,0) when 0 then 0 else isnull(B.MAT08,0)*1.0/isnull(A.MAT08,0) end  as MAT08,
	case isnull(A.MAT09,0) when 0 then 0 else isnull(B.MAT09,0)*1.0/isnull(A.MAT09,0) end  as MAT09,
	case isnull(A.MAT10,0) when 0 then 0 else isnull(B.MAT10,0)*1.0/isnull(A.MAT10,0) end  as MAT10,
	case isnull(A.MAT11,0) when 0 then 0 else isnull(B.MAT11,0)*1.0/isnull(A.MAT11,0) end  as MAT11,
	case isnull(A.MAT12,0) when 0 then 0 else isnull(B.MAT12,0)*1.0/isnull(A.MAT12,0) end  as MAT12,
	case isnull(A.MAT13,0) when 0 then 0 else isnull(B.MAT13,0)*1.0/isnull(A.MAT13,0) end  as MAT13,
	case isnull(A.MAT14,0) when 0 then 0 else isnull(B.MAT14,0)*1.0/isnull(A.MAT14,0) end  as MAT14,
	case isnull(A.MAT15,0) when 0 then 0 else isnull(B.MAT15,0)*1.0/isnull(A.MAT15,0) end  as MAT15,
	case isnull(A.MAT16,0) when 0 then 0 else isnull(B.MAT16,0)*1.0/isnull(A.MAT16,0) end  as MAT16,
	case isnull(A.MAT17,0) when 0 then 0 else isnull(B.MAT17,0)*1.0/isnull(A.MAT17,0) end  as MAT17,
	case isnull(A.MAT18,0) when 0 then 0 else isnull(B.MAT18,0)*1.0/isnull(A.MAT18,0) end  as MAT18,
	case isnull(A.MAT19,0) when 0 then 0 else isnull(B.MAT19,0)*1.0/isnull(A.MAT19,0) end  as MAT19,
	case isnull(A.MAT20,0) when 0 then 0 else isnull(B.MAT20,0)*1.0/isnull(A.MAT20,0) end  as MAT20,
	case isnull(A.MAT21,0) when 0 then 0 else isnull(B.MAT21,0)*1.0/isnull(A.MAT21,0) end  as MAT21,
	case isnull(A.MAT22,0) when 0 then 0 else isnull(B.MAT22,0)*1.0/isnull(A.MAT22,0) end  as MAT22,
	case isnull(A.MAT23,0) when 0 then 0 else isnull(B.MAT23,0)*1.0/isnull(A.MAT23,0) end  as MAT23,
	case isnull(A.MAT24,0) when 0 then 0 else isnull(B.MAT24,0)*1.0/isnull(A.MAT24,0) end  as MAT24,

	case isnull(A.YTD00,0) when 0 then 0 else isnull(B.YTD00,0)*1.0/isnull(A.YTD00,0) end  as YTD00,
	case isnull(A.YTD01,0) when 0 then 0 else isnull(B.YTD01,0)*1.0/isnull(A.YTD01,0) end  as YTD01,
	case isnull(A.YTD02,0) when 0 then 0 else isnull(B.YTD02,0)*1.0/isnull(A.YTD02,0) end  as YTD02,
	case isnull(A.YTD03,0) when 0 then 0 else isnull(B.YTD03,0)*1.0/isnull(A.YTD03,0) end  as YTD03,
	case isnull(A.YTD04,0) when 0 then 0 else isnull(B.YTD04,0)*1.0/isnull(A.YTD04,0) end  as YTD04,
	case isnull(A.YTD05,0) when 0 then 0 else isnull(B.YTD05,0)*1.0/isnull(A.YTD05,0) end  as YTD05,
	case isnull(A.YTD06,0) when 0 then 0 else isnull(B.YTD06,0)*1.0/isnull(A.YTD06,0) end  as YTD06,
	case isnull(A.YTD07,0) when 0 then 0 else isnull(B.YTD07,0)*1.0/isnull(A.YTD07,0) end  as YTD07,
	case isnull(A.YTD08,0) when 0 then 0 else isnull(B.YTD08,0)*1.0/isnull(A.YTD08,0) end  as YTD08,
	case isnull(A.YTD09,0) when 0 then 0 else isnull(B.YTD09,0)*1.0/isnull(A.YTD09,0) end  as YTD09,
	case isnull(A.YTD10,0) when 0 then 0 else isnull(B.YTD10,0)*1.0/isnull(A.YTD10,0) end  as YTD10,
	case isnull(A.YTD11,0) when 0 then 0 else isnull(B.YTD11,0)*1.0/isnull(A.YTD11,0) end  as YTD11,
	case isnull(A.YTD12,0) when 0 then 0 else isnull(B.YTD12,0)*1.0/isnull(A.YTD12,0) end  as YTD12,
	case isnull(A.YTD13,0) when 0 then 0 else isnull(B.YTD13,0)*1.0/isnull(A.YTD13,0) end  as YTD13,
	case isnull(A.YTD14,0) when 0 then 0 else isnull(B.YTD14,0)*1.0/isnull(A.YTD14,0) end  as YTD14,
	case isnull(A.YTD15,0) when 0 then 0 else isnull(B.YTD15,0)*1.0/isnull(A.YTD15,0) end  as YTD15,
	case isnull(A.YTD16,0) when 0 then 0 else isnull(B.YTD16,0)*1.0/isnull(A.YTD16,0) end  as YTD16,
	case isnull(A.YTD17,0) when 0 then 0 else isnull(B.YTD17,0)*1.0/isnull(A.YTD17,0) end  as YTD17,
	case isnull(A.YTD18,0) when 0 then 0 else isnull(B.YTD18,0)*1.0/isnull(A.YTD18,0) end  as YTD18,
	case isnull(A.YTD19,0) when 0 then 0 else isnull(B.YTD19,0)*1.0/isnull(A.YTD19,0) end  as YTD19,
	case isnull(A.YTD20,0) when 0 then 0 else isnull(B.YTD20,0)*1.0/isnull(A.YTD20,0) end  as YTD20,
	case isnull(A.YTD21,0) when 0 then 0 else isnull(B.YTD21,0)*1.0/isnull(A.YTD21,0) end  as YTD21,
	case isnull(A.YTD22,0) when 0 then 0 else isnull(B.YTD22,0)*1.0/isnull(A.YTD22,0) end  as YTD22,
	case isnull(A.YTD23,0) when 0 then 0 else isnull(B.YTD23,0)*1.0/isnull(A.YTD23,0) end  as YTD23,
	case isnull(A.YTD24,0) when 0 then 0 else isnull(B.YTD24,0)*1.0/isnull(A.YTD24,0) end  as YTD24,

	-- case isnull(A.YTD00,0) when 0 then 0 else isnull(B.YTD00,0)*1.0/isnull(A.YTD00,0) end as YTD00,
	-- case isnull(A.YTD12,0) when 0 then 0 else isnull(B.YTD12,0)*1.0/isnull(A.YTD12,0) end as YTD12,
	-- case isnull(A.YTD24,0) when 0 then 0 else isnull(B.YTD24,0)*1.0/isnull(A.YTD24,0) end as YTD24,
	case isnull(A.YTD36,0) when 0 then 0 else isnull(B.YTD36,0)*1.0/isnull(A.YTD36,0) end as YTD36,
	case isnull(A.YTD48,0) when 0 then 0 else isnull(B.YTD48,0)*1.0/isnull(A.YTD48,0) end as YTD48
into OutputGeoHBVSummaryT1 
from TempRegionCityDashboard A 
inner join TempRegionCityDashboard B
on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
	and A.[Audi_cod]=B.[Audi_cod] and A.Region=B.Region
	and A.prod='000' and B.prod<>'000'
	and A.lev=B.lev and A.lev='City'
go
update OutputGeoHBVSummaryT1
set audi_cod=B.rank 
from OutputGeoHBVSummaryT1 A 
inner join 
(	select A.*,dense_Rank ( )OVER (PARTITION BY Region order by audi_des) as Rank 
	from OutputGeoHBVSummaryT1 A
) B
on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
	and A.[Audi_cod]=B.[Audi_cod] and A.Region=B.Region
go
delete from OutputGeoHBVSummaryT1 where market='Baraclude' and Productname<>'Baraclude'
delete from OutputGeoHBVSummaryT1 where market='Glucophage' and mkt='NIAD' and Class='N' and Productname not in('Glucophage','Onglyza')
delete from OutputGeoHBVSummaryT1 where market='Glucophage' and mkt='DIA'
delete from OutputGeoHBVSummaryT1 where market='Glucophage' and mkt='NIAD' and Class='Y' and Productname<>'DPP4'

delete from OutputGeoHBVSummaryT1 where market='Monopril' and mkt='HYP' and Class='N' and Productname<>'Monopril'
delete from OutputGeoHBVSummaryT1 where market='Monopril' and mkt='HYP' and Class='Y' and Productname<>'ACEI'
delete from OutputGeoHBVSummaryT1 where market='Monopril' and mkt='ACE' 
delete from OutputGeoHBVSummaryT1 where market='Coniel' and mkt='CCB' and productname<>'Coniel' 

delete from OutputGeoHBVSummaryT1 where market='Taxol' and mkt='ONCFCS' and Class='N' and Productname<>'Taxol'
delete from OutputGeoHBVSummaryT1 where market='Paraplatin' and mkt='Platinum' and Class='N' and Productname<>'Paraplatin'

delete from OutputGeoHBVSummaryT1 where market='Taxol' and mkt='ONC' and Class='Y'
delete from OutputGeoHBVSummaryT1 where market='Onglyza' and Productname<>'Onglyza'

delete from OutputGeoHBVSummaryT1 where market='Eliquis VTEp' and productname<>'Eliquis' 
delete from OutputGeoHBVSummaryT1 where market='Eliquis NOAC' and productname<>'Eliquis' 
delete from OutputGeoHBVSummaryT1 where market='Eliquis VTEt' and productname<>'Eliquis' 
go
update OutputGeoHBVSummaryT1
set Market='Onglyza' where  market='glucophage' and Class='N' and Productname='Onglyza'
go



if exists (select * from dbo.sysobjects where id = object_id(N'[OutputGeoHBVSummaryT1_MTH]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [OutputGeoHBVSummaryT1_MTH]
GO
select B.[Molecule],B.[Class],B.[mkt],B.Market,B.[mktname],B.[prod],B.[Productname],B.[Moneytype]
      ,B.[Audi_cod],B.[Audi_des],B.[Region],
	case isnull(A.MTH00,0) when 0 then 0 else isnull(B.MTH00,0)*1.0/isnull(A.MTH00,0) end  as MTH00,
	case isnull(A.MTH01,0) when 0 then 0 else isnull(B.MTH01,0)*1.0/isnull(A.MTH01,0) end  as MTH01,
	case isnull(A.MTH02,0) when 0 then 0 else isnull(B.MTH02,0)*1.0/isnull(A.MTH02,0) end  as MTH02,
	case isnull(A.MTH03,0) when 0 then 0 else isnull(B.MTH03,0)*1.0/isnull(A.MTH03,0) end  as MTH03,
	case isnull(A.MTH04,0) when 0 then 0 else isnull(B.MTH04,0)*1.0/isnull(A.MTH04,0) end  as MTH04,
	case isnull(A.MTH05,0) when 0 then 0 else isnull(B.MTH05,0)*1.0/isnull(A.MTH05,0) end  as MTH05,
	case isnull(A.MTH06,0) when 0 then 0 else isnull(B.MTH06,0)*1.0/isnull(A.MTH06,0) end  as MTH06,
	case isnull(A.MTH07,0) when 0 then 0 else isnull(B.MTH07,0)*1.0/isnull(A.MTH07,0) end  as MTH07,
	case isnull(A.MTH08,0) when 0 then 0 else isnull(B.MTH08,0)*1.0/isnull(A.MTH08,0) end  as MTH08,
	case isnull(A.MTH09,0) when 0 then 0 else isnull(B.MTH09,0)*1.0/isnull(A.MTH09,0) end  as MTH09,
	case isnull(A.MTH10,0) when 0 then 0 else isnull(B.MTH10,0)*1.0/isnull(A.MTH10,0) end  as MTH10,
	case isnull(A.MTH11,0) when 0 then 0 else isnull(B.MTH11,0)*1.0/isnull(A.MTH11,0) end  as MTH11,
	case isnull(A.MTH12,0) when 0 then 0 else isnull(B.MTH12,0)*1.0/isnull(A.MTH12,0) end  as MTH12,
	case isnull(A.MTH13,0) when 0 then 0 else isnull(B.MTH13,0)*1.0/isnull(A.MTH13,0) end  as MTH13,
	case isnull(A.MTH14,0) when 0 then 0 else isnull(B.MTH14,0)*1.0/isnull(A.MTH14,0) end  as MTH14,
	case isnull(A.MTH15,0) when 0 then 0 else isnull(B.MTH15,0)*1.0/isnull(A.MTH15,0) end  as MTH15,
	case isnull(A.MTH16,0) when 0 then 0 else isnull(B.MTH16,0)*1.0/isnull(A.MTH16,0) end  as MTH16,
	case isnull(A.MTH17,0) when 0 then 0 else isnull(B.MTH17,0)*1.0/isnull(A.MTH17,0) end  as MTH17,
	case isnull(A.MTH18,0) when 0 then 0 else isnull(B.MTH18,0)*1.0/isnull(A.MTH18,0) end  as MTH18,
	case isnull(A.MTH19,0) when 0 then 0 else isnull(B.MTH19,0)*1.0/isnull(A.MTH19,0) end  as MTH19,
	case isnull(A.MTH20,0) when 0 then 0 else isnull(B.MTH20,0)*1.0/isnull(A.MTH20,0) end  as MTH20,
	case isnull(A.MTH21,0) when 0 then 0 else isnull(B.MTH21,0)*1.0/isnull(A.MTH21,0) end  as MTH21,
	case isnull(A.MTH22,0) when 0 then 0 else isnull(B.MTH22,0)*1.0/isnull(A.MTH22,0) end  as MTH22,
	case isnull(A.MTH23,0) when 0 then 0 else isnull(B.MTH23,0)*1.0/isnull(A.MTH23,0) end  as MTH23,
	case isnull(A.MTH24,0) when 0 then 0 else isnull(B.MTH24,0)*1.0/isnull(A.MTH24,0) end  as MTH24,
	case isnull(A.YTD00,0) when 0 then 0 else isnull(B.YTD00,0)*1.0/isnull(A.YTD00,0) end as YTD00,
	case isnull(A.YTD12,0) when 0 then 0 else isnull(B.YTD12,0)*1.0/isnull(A.YTD12,0) end as YTD12,
	case isnull(A.YTD24,0) when 0 then 0 else isnull(B.YTD24,0)*1.0/isnull(A.YTD24,0) end as YTD24,
	case isnull(A.YTD36,0) when 0 then 0 else isnull(B.YTD36,0)*1.0/isnull(A.YTD36,0) end as YTD36,
	case isnull(A.YTD48,0) when 0 then 0 else isnull(B.YTD48,0)*1.0/isnull(A.YTD48,0) end as YTD48
	--case isnull(A.YTD60,0) when 0 then 0 else isnull(B.YTD60,0)*1.0/isnull(A.YTD60,0) end as YTD60
into OutputGeoHBVSummaryT1_MTH 
from TempRegionCityDashboard A 
inner join TempRegionCityDashboard B
on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
	and A.[Audi_cod]=B.[Audi_cod] and A.Region=B.Region
	and A.prod='000' and B.prod<>'000'
	and A.lev=B.lev and A.lev='City'
go
update OutputGeoHBVSummaryT1_MTH
set audi_cod=B.rank from OutputGeoHBVSummaryT1_MTH A 
inner join 
(	select A.*,dense_Rank ( )OVER (PARTITION BY Region order by audi_des) as Rank 
	from OutputGeoHBVSummaryT1_MTH A) B
on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
	and A.[Audi_cod]=B.[Audi_cod] and A.Region=B.Region
go
delete from OutputGeoHBVSummaryT1_MTH where market='Baraclude' and Productname<>'Baraclude'
delete from OutputGeoHBVSummaryT1_MTH where market='Glucophage' and mkt='NIAD' and Class='N' and Productname not in('Glucophage','Onglyza')
delete from OutputGeoHBVSummaryT1_MTH where market='Glucophage' and mkt='DIA'
delete from OutputGeoHBVSummaryT1_MTH where market='Glucophage' and mkt='NIAD' and Class='Y' and Productname<>'DPP4'

delete from OutputGeoHBVSummaryT1_MTH where market='Monopril' and mkt='HYP' and Class='N' and Productname<>'Monopril'
delete from OutputGeoHBVSummaryT1_MTH where market='Monopril' and mkt='HYP' and Class='Y' and Productname<>'ACEI'
delete from OutputGeoHBVSummaryT1_MTH where market='Monopril' and mkt='ACE' 
delete from OutputGeoHBVSummaryT1_MTH where market='Coniel' and mkt='CCB' and productname<>'Coniel' 

delete from OutputGeoHBVSummaryT1_MTH where market='Taxol' and mkt='ONCFCS' and Class='N' and Productname<>'Taxol'
delete from OutputGeoHBVSummaryT1_MTH where market='Paraplatin' and mkt='Platinum' and Class='N' and Productname<>'Paraplatin'

delete from OutputGeoHBVSummaryT1_MTH where market='Taxol' and mkt='ONC' and Class='Y'
delete from OutputGeoHBVSummaryT1_MTH where market='Onglyza' and Productname<>'Onglyza'
go
update OutputGeoHBVSummaryT1_MTH
set Market='Onglyza' where  market='glucophage' and Class='N' and Productname='Onglyza'
go

exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','OutputGeoHBVSummaryT2',null,null
--------------------------------------------
--OutputGeoHBVSummaryT2
--------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'OutputGeoHBVSummaryT2') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputGeoHBVSummaryT2
GO

select 
	A.lev
	,cast('Product' as varchar(20)) as [Type]
	,B.[Molecule]
	,B.[Class]
	,B.[mkt]
	,B.Market
	,B.[mktname]
	,B.[prod]
	,B.[Productname]
	,B.[Moneytype]
	,B.[Audi_cod]
	,B.[Audi_des]
	,B.[Region]
	,B.R3M00
	,B.YTD00
	,B.MAT00 
	,B.MTH00
	,B.R3M12
	,B.YTD12
	,B.MAT12
	,B.MTH12
	--case A.R3M00 when 0 then 0 else B.R3M00*1.0/A.R3M00 end  as R3M00,
	--case A.YTD00 when 0 then 0 else B.YTD00*1.0/A.YTD00 end  as YTD00,
	--case A.MAT00 when 0 then 0 else B.MAT00*1.0/A.MAT00 end  as MAT00,
	--case A.R3M12 when 0 then 0 else B.R3M12*1.0/A.R3M12 end  as R3M12,
	--case A.YTD12 when 0 then 0 else B.YTD12*1.0/A.YTD12 end  as YTD12,
	--case A.MAT12 when 0 then 0 else B.MAT12*1.0/A.MAT12 end  as MAT12
into 
  OutputGeoHBVSummaryT2 
from
  TempRegionCityDashboard A 
inner join 
  TempRegionCityDashboard B
on 
  A.mkt=b.mkt 
  and A.Moneytype=b.Moneytype and A.class=B.class 
  and A.Molecule=B.Molecule
  and A.[Audi_cod]=B.[Audi_cod] and A.Region=B.Region
  and A.prod='000' and A.Molecule='N' and B.prod<>'000' and B.productname<>'HYP Others'
  and A.lev=B.lev and A.lev in ('City','Region')
go

insert into OutputGeoHBVSummaryT2
select 
	'Region'
	,'Product'
	,B.[Molecule]
	,B.[Class]
	,B.[mkt]
	,B.Market
	,B.[mktname]
	,B.[prod]
	,B.[Productname]
	,B.[Moneytype]
	,'CHT_'
	,'National'
	,'China'
	,B.R3M00
	,B.YTD00
	,B.MAT00 
	,B.MTH00
	,B.R3M12
	,B.YTD12
	,B.MAT12
	,B.MTH12
from dbo.TempCHPAPreReports B where Prod<>'000' and productname<>'HYP Others'
go

delete from OutputGeoHBVSummaryT2 where market='Baraclude' and mkt='HBV'
delete from OutputGeoHBVSummaryT2 where market='Baraclude' and mkt='ARV' and molecule='Y'
delete from OutputGeoHBVSummaryT2 where market='Glucophage' and mkt='DIA'
delete from OutputGeoHBVSummaryT2 where market='Glucophage' and mkt='NIAD' and molecule='Y' 
delete from OutputGeoHBVSummaryT2 where market='Monopril' and mkt='ACE'-- and Class='N' and Productname not in('Monopril'
delete from OutputGeoHBVSummaryT2 where market='Taxol' and mkt<>'ONCFCS' 
delete from OutputGeoHBVSummaryT2 where market='Taxol' and mkt='ONCFCS' and molecule='Y' 
delete from OutputGeoHBVSummaryT2 where market='Paraplatin' and mkt='Platinum' and molecule='Y' 
go

--delete region level
delete from OutputGeoHBVSummaryT2 where lev='Region' and (molecule='Y' or class='Y')
delete from OutputGeoHBVSummaryT2 where lev='Region' and Market='Onglyza' and mkt='NIAD'
go

insert into OutputGeoHBVSummaryT2
select 
	lev
	,'Market Total'
	,B.[Molecule]
	,B.[Class]
	,B.[mkt]
	,B.Market
	,B.[mktname]
	,'000'
	,B.[mktname]
	,B.[Moneytype]
	,B.[Audi_cod]
	,B.[Audi_des]
	,B.[Region]
	,sum(R3M00) as R3M00
	,sum(YTD00)  as YTD00 
	,sum(MAT00)  as MAT00
	,sum(MTH00)  as MTH00
	,sum(R3M12)  as R3M12
	,sum(YTD12)  as YTD12 
	,sum(MAT12)  as MAT12
	,sum(MTH12)  as MTH12
from OutputGeoHBVSummaryT2 B
group by 
  lev,B.[Molecule],B.[Class],B.[mkt],B.Market,B.[mktname],B.[Moneytype],B.[Audi_cod],B.[Audi_des],B.[Region]

insert into OutputGeoHBVSummaryT2
select 
	B.lev
	,'Share'
	,B.[Molecule]
	,B.[Class]
	,B.[mkt]
	,B.Market
	,B.[mktname]
	,B.[prod]
	,B.[Productname]
	,B.[Moneytype]
	,B.[Audi_cod]
	,B.[Audi_des]
	,B.[Region]
	,case A.R3M00 when 0 then 0 else B.R3M00*1.0/A.R3M00 end  as R3M00
	,case A.YTD00 when 0 then 0 else B.YTD00*1.0/A.YTD00 end  as YTD00
	,case A.MAT00 when 0 then 0 else B.MAT00*1.0/A.MAT00 end  as MAT00
	,case A.MTH00 when 0 then 0 else B.MTH00*1.0/A.MTH00 end  as MTH00
	,case A.R3M12 when 0 then 0 else B.R3M12*1.0/A.R3M12 end  as R3M12
	,case A.YTD12 when 0 then 0 else B.YTD12*1.0/A.YTD12 end  as YTD12
	,case A.MAT12 when 0 then 0 else B.MAT12*1.0/A.MAT12 end  as MAT12
	,case A.MTH12 when 0 then 0 else B.MTH12*1.0/A.MTH12 end  as MTH12
from
  OutputGeoHBVSummaryT2 A 
inner join 
  OutputGeoHBVSummaryT2 B
on 
  A.mkt=b.mkt 
  and A.Moneytype=b.Moneytype 
  and A.class=B.class 
  and A.Molecule=B.Molecule
  and A.[Audi_cod]=B.[Audi_cod] and A.Region=B.Region and A.lev=B.lev
  and A.[Type]='Market Total' and B.[Type]='Product' 
go

update OutputGeoHBVSummaryT2 set 
 audi_cod=B.rank 
from 
  OutputGeoHBVSummaryT2 A 
inner join 
  (
  select B.*,dense_rank() OVER (order by case audi_des when 'National' then 'ZZZZ' else audi_des end) as Rank 
  from OutputGeoHBVSummaryT2 B
  ) B
on 
  A.audi_des=B.audi_des
go

delete from OutputGeoHBVSummaryT2 where type='Product'
go
--Add Onglyza Market
insert into [OutputGeoHBVSummaryT2]
SELECT 
  lev
 ,[Type]
 ,[Molecule]
 ,[Class]
 ,[mkt]
 ,'Onglyza'
 ,[mktname]
 ,[prod]
 ,[Productname]
 ,[Moneytype]
 ,[Audi_cod]
 ,[Audi_des]
 ,[Region]
 ,[R3M00]
 ,[YTD00]
 ,[MAT00]
 ,[MTH00]
 ,[R3M12]
 ,[YTD12]
 ,[MAT12]
 ,[MTH12]
FROM [dbo].[OutputGeoHBVSummaryT2]
where Market='Glucophage' and Class='N' and lev='City'
go


if exists (select * from dbo.sysobjects where id = object_id(N'OutputKeyBrandPerformanceByRegion') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputKeyBrandPerformanceByRegion
go

select * 
into OutputKeyBrandPerformanceByRegion
from [OutputGeoHBVSummaryT2] where lev='Region'
go

delete from [OutputGeoHBVSummaryT2] where lev='Region'
go


exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','OutputGeoHBVSummaryGrowthT1',null,null
--------------------------------------------
--OutputGeoHBVSummaryGrowthT1
--------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'OutputGeoHBVSummaryGrowthT1') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputGeoHBVSummaryGrowthT1
go

select 
  [Molecule]
  ,[Class]
  ,[mkt]
  ,Market
  ,[mktname]
  ,[prod]
  ,[Productname]
  ,[Moneytype]
  ,lev
  ,[Region]
  ,Audi_cod
  ,[Audi_des]
  ,case R3M12 when 0 then case R3M00 when 0 then 0 else null end else (R3M00-R3M12)*1.0/R3M12 end as R3M00
  ,case YTD12 when 0 then case YTD00 when 0 then 0 else null end else (YTD00-YTD12)*1.0/YTD12 end as YTD00
  ,case MAT12 when 0 then case MAT00 when 0 then 0 else null end else (MAT00-MAT12)*1.0/MAT12 end as MAT00
  ,case MTH12 when 0 then case MTH00 when 0 then 0 else null end else (MTH00-MTH12)*1.0/MTH12 end as MTH00
into OutputGeoHBVSummaryGrowthT1 
from TempRegionCityDashboard where lev in('City','Region')
go
insert into OutputGeoHBVSummaryGrowthT1
select 
   [Molecule]
  ,[Class]
  ,[mkt]
  ,Market
  ,[mktname]
  ,[prod]
  ,[Productname]
  ,[Moneytype]
  ,'Region'
  ,'China'
  ,'CHT_'
  ,'National'
  ,case R3M12 when 0 then case R3M00 when 0 then 0 else null end else (R3M00-R3M12)*1.0/R3M12 end as R3M00
  ,case YTD12 when 0 then case YTD00 when 0 then 0 else null end else (YTD00-YTD12)*1.0/YTD12 end as YTD00
  ,case MAT12 when 0 then case MAT00 when 0 then 0 else null end else (MAT00-MAT12)*1.0/MAT12 end as MAT00
  ,case MTH12 when 0 then case MTH00 when 0 then 0 else null end else (MTH00-MTH12)*1.0/MTH12 end as MTH00
from TempCHPAPreReports
go
update OutputGeoHBVSummaryGrowthT1 set 
   R3M00=Null
  ,YTD00=Null
  ,MAT00=Null 
where audi_des in (select audi_des from tblNewcity)


-- declare @i int,@sql varchar(max),@sql1 varchar(max),@sql2 varchar(max)
-- set @i=0
-- set @sql1=''
-- while (@i<=11)
-- begin
-- set @sql1=@sql1+'
-- case R3M'+right('00'+cast(@i+12 as varchar(3)),2)+' when 0 then case R3M'+right('00'+cast(@i as varchar(3)),2)+' when 0 then 0 else 1 end else (R3M'+right('00'+cast(@i as varchar(3)),2)+'-R3M'+right('00'+cast(@i+12 as varchar(3)),2)+')*1.0/R3M'+right('00'+cast(@i+12 as varchar(3)),2)+' end as R3M'+right('00'+cast(@i as varchar(3)),2)+','
-- set @i=@i+1
-- end
-- set @sql1=left(@sql1,len(@sql1)-1)
-- print @sql1
-- set @sql='
-- select [Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],[Region],'+@sql1+'
-- into OutputGeoHBVSummaryGrowthT1 from TempRegionCityDashboard where lev=''Region'''

-- print @sql
-- exec (@sql)

go

delete from OutputGeoHBVSummaryGrowthT1 where market='Baraclude' and (mkt='HBV' or molecule='Y')
delete from OutputGeoHBVSummaryGrowthT1 where market='Baraclude' and Productname not in('Baraclude','ARV Market','Heptodin','Run Zhong','Sebivo','Viread')

delete from OutputGeoHBVSummaryGrowthT1 where market='Glucophage' and mkt='NIAD' and Class='N' and Productname not in('Glucophage','NIAD Market','Glucobay','Onglyza','Januvia','Galvus')
delete from OutputGeoHBVSummaryGrowthT1 where market='Glucophage' and mkt='DIA'
delete from OutputGeoHBVSummaryGrowthT1 where market='Glucophage' and mkt='NIAD' and Class='Y' and Productname not in('DPP4','NIAD Market')

delete from OutputGeoHBVSummaryGrowthT1 where market='Monopril' and mkt='HYP' and Class='N' and Productname not in('Hypertension Market','Monopril','Diovan')
delete from OutputGeoHBVSummaryGrowthT1 where market='Monopril' and mkt='HYP' and Class='Y' and Productname not in ('Hypertension Market','ACEI')
delete from OutputGeoHBVSummaryGrowthT1 where market='Monopril' and mkt='ACE'-- and Class='N' and Productname not in('Monopril'
delete from OutputGeoHBVSummaryGrowthT1 where market='Coniel' and mkt='CCB' and productname not in ('CCB Market','Coniel')

delete from OutputGeoHBVSummaryGrowthT1 where market='Taxol' and mkt='ONCFCS' and Class='N' and Productname not in('Oncology Focused Brands','Taxol','Taxotere')
delete from OutputGeoHBVSummaryGrowthT1 where market='Taxol' and mkt<>'ONCFCS' 
delete from OutputGeoHBVSummaryGrowthT1 where market='Taxol' and mkt='ONCFCS' and (class='Y' or molecule='Y')
--delete region level
delete from OutputGeoHBVSummaryGrowthT1 where lev='Region' and (molecule='Y' or class='Y')
delete from OutputGeoHBVSummaryGrowthT1 where lev='Region' and Market='Onglyza' and mkt='NIAD'
--delete from OutputGeoHBVSummaryGrowthT1 where Market='Onglyza' and Class='N' and Productname not in ('DPP4 Market','Onglyza')
go
go
insert into OutputGeoHBVSummaryGrowthT1
select distinct 
	a.Molecule
	, a.Class
	, a.mkt
	, a.Market
	, a.mktname
	, C.prod
	, C.Productname
	, a.Moneytype
	, a.lev
	, a.Region
	, a.Audi_cod
	, a.Audi_des
	, null
	, null
	, null
	, NULL
from
  OutputGeoHBVSummaryT2  A 
inner join
  (
   select distinct 
      molecule
     ,class
     ,mkt
     ,market
     ,prod
     ,Productname 
   from OutputGeoHBVSummaryGrowthT1 
   ) C
on a.molecule=C.molecule and a.class=C.class and a.mkt=C.mkt and a.market=C.market
where not exists(
                 select * from OutputGeoHBVSummaryGrowthT1 B
                 where a.molecule=b.molecule and a.class=b.class and a.mkt=b.mkt and a.market=b.market
                 and a.moneytype=b.moneytype and a.region=b.region and a.audi_des=b.audi_des
                 )
go

update OutputGeoHBVSummaryGrowthT1 set Productname='Monopril Market' 
where molecule='N' and class='N' and market='Monopril' and Prod='000' and Productname='Hypertension Market'
go
update OutputGeoHBVSummaryGrowthT1 set Productname='Taxol Market' 
where molecule='N' and class='N'
and market='Taxol' and Prod='000' and Productname='Oncology Focused Brands'
go

--Add the Onglyza and NIAD Growth
update OutputGeoHBVSummaryGrowthT1 set market='Onglyza' 
where market='Glucophage' and mkt='NIAD' and Class='N' and Productname in('Onglyza','Januvia','Galvus') and lev='City'
go

delete from OutputGeoHBVSummaryGrowthT1 
where market='Glucophage' and mkt='NIAD' and Class='N' and Productname in('Onglyza','Januvia','Galvus') and lev='Region'
go
insert into [OutputGeoHBVSummaryGrowthT1]
SELECT 
  [Molecule]
 ,[Class]
 ,[mkt]
 ,'Onglyza'
 ,[mktname]
 ,[prod]
 ,[Productname]
 ,[Moneytype]
 ,[Lev]
 ,[Region]
 ,[Audi_cod]
 ,[Audi_des]
 ,[R3M00]
 ,[YTD00]
 ,[MAT00]
 ,[MTH00]
FROM [dbo].[OutputGeoHBVSummaryGrowthT1]
where market='Glucophage' and mkt='NIAD' and Class='N' and Productname in('NIAD Market') and lev='city'
go

insert into OutputGeoHBVSummaryGrowthT1(Molecule, Class, mkt, Market, mktname, prod, Productname, Moneytype, lev,Region, Audi_cod, Audi_des)
select * 
from 
    (
          select  A.*,B.lev,B.Region, B.Audi_cod, B.Audi_des 
          from
            (
            select distinct  Molecule, Class, mkt, Market, mktname, prod, Productname, Moneytype
            from dbo.OutputGeoHBVSummaryGrowthT1 where Class='N' and lev='City'
            ) A 
            inner join
            (
            select distinct Molecule, Class, mkt, Market, mktname,Moneytype,lev,Region, Audi_cod, Audi_des
            from dbo.OutputGeoHBVSummaryGrowthT1 where Class='N' and lev='City'
            ) B
          on A.moneytype=b.moneytype and a.mkt=b.mkt and a.market=b.market and a.Class=b.Class
    ) A 
where not exists(
                 select * 
                 from OutputGeoHBVSummaryGrowthT1 B 
                 where 
                    class='N'
                    and a.moneytype=b.moneytype and a.mkt=b.mkt and a.market=b.market and a.Class=b.Class
                    and A.audi_des=b.audi_des and A.region=B.region and a.prod=b.prod and lev='City'
                 )
go

insert into OutputGeoHBVSummaryGrowthT1(Molecule, Class, mkt, Market, mktname, prod, Productname, Moneytype, lev,Region, Audi_cod, Audi_des)
select * 
from 
   (
        select  A.*,B.lev,B.Region, B.Audi_cod, B.Audi_des 
        from
           (
            select distinct  Molecule, Class, mkt, Market, mktname, prod, Productname, Moneytype
            from dbo.OutputGeoHBVSummaryGrowthT1 
            where Class='N' and lev='Region'
            ) A 
            inner join
            (select distinct Molecule, Class, mkt, Market, mktname,Moneytype,lev,Region, Audi_cod, Audi_des
             from dbo.OutputGeoHBVSummaryGrowthT1 where Class='N' and lev='Region'
            ) B
            on A.moneytype=b.moneytype and a.mkt=b.mkt and a.market=b.market and a.Class=b.Class
   ) A 
where not exists(
                 select * from OutputGeoHBVSummaryGrowthT1 B where class='N'
                 and a.moneytype=b.moneytype and a.mkt=b.mkt and a.market=b.market and a.Class=b.Class
                 and A.audi_des=b.audi_des and A.region=B.region and a.prod=b.prod and lev='Region'
                 )
go 

update OutputGeoHBVSummaryGrowthT1 set audi_cod=B.rank 
from 
  OutputGeoHBVSummaryGrowthT1 A 
inner join 
  (	select B.*,dense_rank() OVER (order by case audi_des when 'National' then 'ZZZZ' else audi_des end) as Rank 
  	from OutputGeoHBVSummaryGrowthT1 B
  ) B
on A.audi_des=B.audi_des
go   



---------------------------------------------------
-- OutputKeyBrandPerformanceByRegionGrowth
---------------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'OutputKeyBrandPerformanceByRegionGrowth') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputKeyBrandPerformanceByRegionGrowth
go
select * 
into OutputKeyBrandPerformanceByRegionGrowth
from OutputGeoHBVSummaryGrowthT1 where lev='Region'
go
delete from OutputGeoHBVSummaryGrowthT1 where lev='Region'
go

--delete OutputGeoHBVSummaryGrowthT1 from OutputGeoHBVSummaryGrowthT1 A 
--where not exists(select * from tblD020GrowthProduct B
--where A.type=B.type and A.market=B.market and A.ta=B.TA and A.product=b.Product)
--go






exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','OutputCityPerformanceByBrand',null,null
--------------------------------------------
--OutputCityPerformanceByBrand
--------------------------------------------

--横坐标间隔全部改为3个月，而不是一个月 2012/11/07
if exists (select * from dbo.sysobjects where id = object_id(N'OutputCityPerformanceByBrand') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputCityPerformanceByBrand
go

select cast('Volume Trend' as varchar(50)) as Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],[Region],
	sum(R3M00) as R3M00,sum(R3M03) as R3M01,
	sum(R3M06) as R3M02,sum(R3M09) as R3M03,
	sum(R3M12) as R3M04,sum(R3M15) as R3M05,
	sum(R3M12) as R3M12,sum(R3M15) as R3M13,
	sum(R3M18) as R3M14,sum(R3M21) as R3M15,
	sum(R3M24) as R3M16,sum(R3M27) as R3M17,
	sum(YTD00) as YTD00,sum(YTD12) as YTD12, 
	sum(YTD24) as YTD24,sum(YTD36) as YTD36, 
	sum(YTD48) as YTD48,
	sum(MAT00) as MAT00,sum(MAT12) as MAT12, 
	sum(MAT24) as MAT24,sum(MAT36) as MAT36, 
	sum(MAT48) as MAT48,
	sum(MTH00) as MTH00,sum(MTH12) as MTH12, 
	sum(MTH24) as MTH24,sum(MTH36) as MTH36, 
	sum(MTH48) as MTH48
into OutputCityPerformanceByBrand 
from TempRegionCityDashboard 
where lev='City'
group by [Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],[Region]
go
insert into OutputCityPerformanceByBrand
select 'Market Share Trend',A.[Molecule],A.[Class],A.[mkt],A.Market,A.[mktname],A.[prod],A.[Productname],A.[Moneytype]
      ,A.[Audi_cod],A.[Audi_des],A.[Region],
	case B.R3M00 when 0 then 0 else A.R3M00/B.R3M00 end,
	case B.R3M01 when 0 then 0 else A.R3M01/B.R3M01 end,
	case B.R3M02 when 0 then 0 else A.R3M02/B.R3M02 end,
	case B.R3M03 when 0 then 0 else A.R3M03/B.R3M03 end,
	case B.R3M04 when 0 then 0 else A.R3M04/B.R3M04 end,
	case B.R3M05 when 0 then 0 else A.R3M05/B.R3M05 end,
	case B.R3M12 when 0 then 0 else A.R3M12/B.R3M12 end,
	case B.R3M13 when 0 then 0 else A.R3M13/B.R3M13 end,
	case B.R3M14 when 0 then 0 else A.R3M14/B.R3M14 end,
	case B.R3M15 when 0 then 0 else A.R3M15/B.R3M15 end,
	case B.R3M16 when 0 then 0 else A.R3M16/B.R3M16 end,
	case B.R3M17 when 0 then 0 else A.R3M17/B.R3M17 end,

	case B.YTD00 when 0 then 0 else A.YTD00/B.YTD00 end,
	case B.YTD12 when 0 then 0 else A.YTD12/B.YTD12 end,
	case B.YTD24 when 0 then 0 else A.YTD24/B.YTD24 end,
	case B.YTD36 when 0 then 0 else A.YTD36/B.YTD36 end,
	case B.YTD48 when 0 then 0 else A.YTD48/B.YTD48 end,
	
	case B.MAT00 when 0 then 0 else A.MAT00/B.MAT00 end,
	case B.MAT12 when 0 then 0 else A.MAT12/B.MAT12 end,
	case B.MAT24 when 0 then 0 else A.MAT24/B.MAT24 end,
	case B.MAT36 when 0 then 0 else A.MAT36/B.MAT36 end,
	case B.MAT48 when 0 then 0 else A.MAT48/B.MAT48 end,
	
	case B.MTH00 when 0 then 0 else A.MTH00/B.MTH00 end,
	case B.MTH12 when 0 then 0 else A.MTH12/B.MTH12 end,
	case B.MTH24 when 0 then 0 else A.MTH24/B.MTH24 end,
	case B.MTH36 when 0 then 0 else A.MTH36/B.MTH36 end,
	case B.MTH48 when 0 then 0 else A.MTH48/B.MTH48 end
from OutputCityPerformanceByBrand A 
inner join OutputCityPerformanceByBrand B
on A.Moneytype=B.Moneytype and A.[mkt]=B.[mkt] and A.Region=B.Region and A.class=B.class and A.Molecule=B.Molecule
	and A.Audi_Cod=B.Audi_Cod and B.prod='000' and A.prod<>'000'
go
insert into OutputCityPerformanceByBrand
select 'Market Share Trend',A.[Molecule],A.[Class],A.[mkt],A.Market,A.[mktname],A.[prod],A.[Productname],A.[Moneytype]
      ,A.[Audi_cod],A.[Audi_des],A.[Region],0,0,0,0,0,0,0,0,0,0,0,0,
	  0,0,0,0,0,
	  0,0,0,0,0,
	  0,0,0,0,0
from OutputCityPerformanceByBrand A where prod='000'
go
insert into OutputCityPerformanceByBrand
select 'Growth Trend',A.[Molecule],A.[Class],A.[mkt],A.Market,A.[mktname],A.[prod],A.[Productname],A.[Moneytype]
      ,A.[Audi_cod],A.[Audi_des],A.[Region],
	case R3M12 when 0 then case R3M00 when 0 then 0 else null end else (R3M00-R3M12)/R3M12 end,
	case R3M13 when 0 then case R3M01 when 0 then 0 else null end else (R3M01-R3M13)/R3M13 end,
	case R3M14 when 0 then case R3M02 when 0 then 0 else null end else (R3M02-R3M14)/R3M14 end,
	case R3M15 when 0 then case R3M03 when 0 then 0 else null end else (R3M03-R3M15)/R3M15 end,
	case R3M16 when 0 then case R3M04 when 0 then 0 else null end else (R3M04-R3M16)/R3M16 end,
	case R3M17 when 0 then case R3M05 when 0 then 0 else null end else (R3M05-R3M17)/R3M17 end,
	0,0,0,0,0,0,
	case YTD12 when 0 then case YTD00 when 0 then 0 else null end else (YTD00-YTD12)/YTD12 end,
	case YTD24 when 0 then case YTD12 when 0 then 0 else null end else (YTD12-YTD24)/YTD24 end,
	case YTD36 when 0 then case YTD24 when 0 then 0 else null end else (YTD24-YTD36)/YTD36 end,
	case YTD48 when 0 then case YTD36 when 0 then 0 else null end else (YTD36-YTD48)/YTD48 end,
	0,
	case MAT12 when 0 then case MAT00 when 0 then 0 else null end else (MAT00-MAT12)/MAT12 end,
	case MAT24 when 0 then case MAT12 when 0 then 0 else null end else (MAT12-MAT24)/MAT24 end,
	case MAT36 when 0 then case MAT24 when 0 then 0 else null end else (MAT24-MAT36)/MAT36 end,
	case MAT48 when 0 then case MAT36 when 0 then 0 else null end else (MAT36-MAT48)/MAT48 end,
	0,
	case MTH12 when 0 then case MTH00 when 0 then 0 else null end else (MTH00-MTH12)/MTH12 end,
	case MTH24 when 0 then case MTH12 when 0 then 0 else null end else (MTH12-MTH24)/MTH24 end,
	case MTH36 when 0 then case MTH24 when 0 then 0 else null end else (MTH24-MTH36)/MTH36 end,
	case MTH48 when 0 then case MTH36 when 0 then 0 else null end else (MTH36-MTH48)/MTH48 end,
	0
from OutputCityPerformanceByBrand A where Chart='Volume Trend'
go
insert into OutputCityPerformanceByBrand
select 'Share of Growth Trend',A.[Molecule],A.[Class],A.[mkt],A.Market,A.[mktname],A.[prod],A.[Productname],A.[Moneytype]
      ,A.[Audi_cod],A.[Audi_des],A.[Region],
	case (B.R3M00-B.R3M12) when 0 then 0 else (A.R3M00-A.R3M12)/(B.R3M00-B.R3M12) end,
	case (B.R3M01-B.R3M13) when 0 then 0 else (A.R3M01-A.R3M13)/(B.R3M01-B.R3M13) end,
	case (B.R3M02-B.R3M14) when 0 then 0 else (A.R3M02-A.R3M14)/(B.R3M02-B.R3M14) end,
	case (B.R3M03-B.R3M15) when 0 then 0 else (A.R3M03-A.R3M15)/(B.R3M03-B.R3M15) end,
	case (B.R3M04-B.R3M16) when 0 then 0 else (A.R3M04-A.R3M16)/(B.R3M04-B.R3M16) end,
	case (B.R3M05-B.R3M17) when 0 then 0 else (A.R3M05-A.R3M17)/(B.R3M05-B.R3M17) end,
	0,0,0,0,0,0,
	case (B.YTD00-B.YTD12) when 0 then 0 else (A.YTD00-A.YTD12)/(B.YTD00-B.YTD12) end,
	case (B.YTD12-B.YTD24) when 0 then 0 else (A.YTD12-A.YTD24)/(B.YTD12-B.YTD24) end,
	case (B.YTD24-B.YTD36) when 0 then 0 else (A.YTD24-A.YTD36)/(B.YTD24-B.YTD36) end,
	case (B.YTD36-B.YTD48) when 0 then 0 else (A.YTD36-A.YTD48)/(B.YTD36-B.YTD48) end,
	0,
	case (B.MAT00-B.MAT12) when 0 then 0 else (A.MAT00-A.MAT12)/(B.MAT00-B.MAT12) end,
	case (B.MAT12-B.MAT24) when 0 then 0 else (A.MAT12-A.MAT24)/(B.MAT12-B.MAT24) end,
	case (B.MAT24-B.MAT36) when 0 then 0 else (A.MAT24-A.MAT36)/(B.MAT24-B.MAT36) end,
	case (B.MAT36-B.MAT48) when 0 then 0 else (A.MAT36-A.MAT48)/(B.MAT36-B.MAT48) end,
	0,
	case (B.MTH00-B.MTH12) when 0 then 0 else (A.MTH00-A.MTH12)/(B.MTH00-B.MTH12) end,
	case (B.MTH12-B.MTH24) when 0 then 0 else (A.MTH12-A.MTH24)/(B.MTH12-B.MTH24) end,
	case (B.MTH24-B.MTH36) when 0 then 0 else (A.MTH24-A.MTH36)/(B.MTH24-B.MTH36) end,
	case (B.MTH36-B.MTH48) when 0 then 0 else (A.MTH36-A.MTH48)/(B.MTH36-B.MTH48) end,
	0
from OutputCityPerformanceByBrand A 
inner join OutputCityPerformanceByBrand B
on A.Moneytype=B.Moneytype and A.[mkt]=B.[mkt] and A.Region=B.Region and A.class=B.class and A.Molecule=B.Molecule
	and A.Audi_Cod=B.Audi_Cod and B.prod='000' and A.prod<>'000'
	and A.Chart='Volume Trend' and A.Chart=B.Chart
go
insert into OutputCityPerformanceByBrand
SELECT [Chart]
      ,[Molecule]
      ,[Class]
      ,[mkt]
      ,'Onglyza'
      ,[mktname]
      ,[prod]
      ,[Productname]
      ,[Moneytype]
      ,[Audi_cod]
      ,[Audi_des]
      ,[Region]
      ,[R3M00]
      ,[R3M01]
      ,[R3M02]
      ,[R3M03]
      ,[R3M04]
      ,[R3M05]
      ,[R3M12]
      ,[R3M13]
      ,[R3M14]
      ,[R3M15]
      ,[R3M16]
      ,[R3M17]
	,YTD00,YTD12,YTD24,YTD36,YTD48
	,MAT00,MAT12,MAT24,MAT36,MAT48
	,MTH00,MTH12,MTH24,MTH36,MTH48
FROM [dbo].[OutputCityPerformanceByBrand]
where market='Glucophage' and class='N' and mkt='NIAD'

--update OutputCityPerformanceByBrand
--set Prod=B.rank from OutputCityPerformanceByBrand A inner join 
--(select B.*,row_number() OVER (PARTITION BY chart order by mkt,molecule,class,prod,audi_des) as Rank from OutputCityPerformanceByBrand B) B
--on A.chart=B.chart and a.mkt=b.mkt and a.molecule=b.molecule and a.class=b.class and A.audi_des=B.audi_des and A.moneytype=b.moneytype
--and A.productname=b.productname
--go
go
--CAGR

insert into OutputCityPerformanceByBrand(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],
	audi_cod,audi_des,region,R3M00,YTD00, MAT00, MTH00)
select 'CAGR',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,
	case when R3M05<>0 then Power((R3M00/R3M05),1.0/5)-1  
		when R3M05=0 and R3M04<>0  then Power((R3M00/R3M04),1.0/4)-1 
		when R3M05=0 and R3M04=0 and R3M03<>0 then Power((R3M00/R3M03),1.0/3)-1 
		when R3M05=0 and R3M04=0 and R3M03=0 and R3M02<>0 then Power((R3M00/R3M02),1.0/2)-1 
		when R3M05=0 and R3M04=0 and R3M03=0 and R3M02=0 and R3M01<>0 then Power((R3M00/R3M01),1.0/1)-1 
		when R3M05=0 and R3M04=0 and R3M03=0 and R3M02=0 and R3M01=0  then 0 
	end as R3M00,
	case when mkt='arv' and YTD48<>0 then Power((YTD00/YTD48),1.0/4)-1 
		when mkt='arv' and YTD48=0 and YTD36<>0 then Power((YTD00/YTD36),1.0/3)-1 
		when mkt='arv' and YTD48=0 and YTD36=0 and YTD24<>0 then Power((YTD00/YTD24),1.0/2)-1 
		when mkt='arv' and YTD48=0 and YTD36=0 and YTD24=0  and YTD12<>0  then Power((YTD00/YTD12),1.0/1)-1 
		when mkt='arv' and YTD48=0 and YTD36=0 and YTD24=0 and YTD12=0 then 0
		else null
	end as YTD00,
	case when mkt='arv' and MAT48<>0 then Power((MAT00/MAT48),1.0/4)-1
		when mkt='arv' and MAT48=0 and MAT36<>0 then Power((MAT00/MAT36),1.0/3)-1
		when mkt='arv' and MAT48=0 and MAT36=0 and MAT24<>0 then Power((MAT00/MAT24),1.0/2)-1
		when mkt='arv' and MAT48=0 and MAT36=0 and MAT24=0  and MAT12<>0  then Power((MAT00/MAT12),1.0/1)-1
		when mkt='arv' and MAT48=0 and MAT36=0 and MAT24=0 and MAT12=0 then 0
		else null
	end as MAT00,
	case when mkt='arv' and MTH48<>0 then Power((MTH00/MTH48),1.0/4)-1
		when mkt='arv' and MTH48=0 and MTH36<>0 then Power((MTH00/MTH36),1.0/3)-1
		when mkt='arv' and MTH48=0 and MTH36=0 and MTH24<>0 then Power((MTH00/MTH24),1.0/2)-1
		when mkt='arv' and MTH48=0 and MTH36=0 and MTH24=0  and MTH12<>0  then Power((MTH00/MTH12),1.0/1)-1
		when mkt='arv' and MTH48=0 and MTH36=0 and MTH24=0 and MTH12=0 then 0
		else null
	end as MTH00	  
from OutputCityPerformanceByBrand A 
where exists(
	select * 
	from (
		select distinct Molecule,Class,mkt,Market,mktname,Moneytype,audi_cod,region
		from OutputCityPerformanceByBrand where Chart='Volume Trend'
			and R3M05<>0 and prod='000'
	) B
	where a.Molecule=b.Molecule and A.Class=B.Class and A.mkt=B.mkt and A.Market=B.Market
		and A.Moneytype=B.moneytype 
) and Chart='Volume Trend' 
go 

--insert into OutputCityPerformanceByBrand(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,R3M00)
--select 'CAGR',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,
--Power((R3M00/R3M05),1.0/5)-1
-- from OutputCityPerformanceByBrand A where exists(select * from (
--select distinct Molecule,Class,mkt,Market,mktname,Moneytype,audi_cod,region
--from OutputCityPerformanceByBrand where Chart='Volume Trend'
--and R3M05<>0 and prod='000') B
--where a.Molecule=b.Molecule and A.Class=B.Class and A.mkt=B.mkt and A.Market=B.Market
--and A.Moneytype=B.moneytype )
--and R3M05<>0 and Chart='Volume Trend' 

--insert into OutputCityPerformanceByBrand(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,R3M00)
--select 'CAGR',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,
--Power((R3M00/R3M04),1.0/4)-1
-- from OutputCityPerformanceByBrand A where exists(select * from (
--select distinct Molecule,Class,mkt,Market,mktname,Moneytype,audi_cod,region
--from OutputCityPerformanceByBrand where Chart='Volume Trend'
--and R3M05<>0 and prod='000') B
--where a.Molecule=b.Molecule and A.Class=B.Class and A.mkt=B.mkt and A.Market=B.Market
--and A.Moneytype=B.moneytype )
--and R3M05=0 and R3M04<>0 and Chart='Volume Trend' 

--insert into OutputCityPerformanceByBrand(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,R3M00)
--select 'CAGR',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,
--Power((R3M00/R3M03),1.0/3)-1
-- from OutputCityPerformanceByBrand A where exists(select * from (
--select distinct Molecule,Class,mkt,Market,mktname,Moneytype,audi_cod,region
--from OutputCityPerformanceByBrand where Chart='Volume Trend'
--and R3M05<>0 and prod='000') B
--where a.Molecule=b.Molecule and A.Class=B.Class and A.mkt=B.mkt and A.Market=B.Market
--and A.Moneytype=B.moneytype )
--and R3M05=0 and R3M04=0 and R3M03<>0 and Chart='Volume Trend' 

--insert into OutputCityPerformanceByBrand(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,R3M00)
--select 'CAGR',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,
--Power((R3M00/R3M02),1.0/2)-1
--from OutputCityPerformanceByBrand A where exists(select * from (
--select distinct Molecule,Class,mkt,Market,mktname,Moneytype,audi_cod,region
--from OutputCityPerformanceByBrand where Chart='Volume Trend'
--and R3M05<>0 and prod='000') B
--where a.Molecule=b.Molecule and A.Class=B.Class and A.mkt=B.mkt and A.Market=B.Market
--and A.Moneytype=B.moneytype )
--and R3M05=0 and R3M04=0 and R3M03=0 and R3M02<>0 and Chart='Volume Trend' 

--insert into OutputCityPerformanceByBrand(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,R3M00)
--select 'CAGR',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,
--Power((R3M00/R3M01),1.0/1)-1
--from OutputCityPerformanceByBrand A where exists(select * from (
--select distinct Molecule,Class,mkt,Market,mktname,Moneytype,audi_cod,region
--from OutputCityPerformanceByBrand where Chart='Volume Trend'
--and R3M05<>0 and prod='000') B
--where a.Molecule=b.Molecule and A.Class=B.Class and A.mkt=B.mkt and A.Market=B.Market
--and A.Moneytype=B.moneytype )
--and R3M05=0 and R3M04=0 and R3M03=0 and R3M02=0 and R3M01<>0 and Chart='Volume Trend' 


--insert into OutputCityPerformanceByBrand(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,R3M00)
--select 'CAGR',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,
--0 from OutputCityPerformanceByBrand A where exists(select * from (
--select distinct Molecule,Class,mkt,Market,mktname,Moneytype,audi_cod,region
--from OutputCityPerformanceByBrand where Chart='Volume Trend'
--and R3M05<>0 and prod='000') B
--where a.Molecule=b.Molecule and A.Class=B.Class and A.mkt=B.mkt and A.Market=B.Market
--and A.Moneytype=B.moneytype )
--and R3M05=0 and R3M04=0 and R3M03=0 and R3M02=0 and R3M01=0 and R3M00=0 and Chart='Volume Trend' 

----CAGR:	Baraclude需要YTD的CAGR值

--insert into OutputCityPerformanceByBrand(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,YTD00)
--select 'CAGR',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,
--Power((YTD00/YTD48),1.0/4)-1
-- from OutputCityPerformanceByBrand A where exists(select * from (
--select distinct Molecule,Class,mkt,Market,mktname,Moneytype,audi_cod,region
--from OutputCityPerformanceByBrand where Chart='Volume Trend'
--and YTD48<>0 and prod='000') B
--where a.Market='Baraclude' and a.Molecule=b.Molecule and A.Class=B.Class and A.mkt=B.mkt and A.Market=B.Market
--and A.Moneytype=B.moneytype )
--and YTD48<>0 and Chart='Volume Trend' 

--insert into OutputCityPerformanceByBrand(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,YTD00)
--select 'CAGR',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,
--Power((YTD00/YTD36),1.0/3)-1
-- from OutputCityPerformanceByBrand A where exists(select * from (
--select distinct Molecule,Class,mkt,Market,mktname,Moneytype,audi_cod,region
--from OutputCityPerformanceByBrand where Chart='Volume Trend'
--and YTD48<>0 and prod='000') B
--where  a.Market='Baraclude' and a.Molecule=b.Molecule and A.Class=B.Class and A.mkt=B.mkt and A.Market=B.Market
--and A.Moneytype=B.moneytype )
--and YTD48=0 and YTD36<>0 and Chart='Volume Trend' 

--insert into OutputCityPerformanceByBrand(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,YTD00)
--select 'CAGR',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,
--Power((YTD00/YTD24),1.0/2)-1
-- from OutputCityPerformanceByBrand A where exists(select * from (
--select distinct Molecule,Class,mkt,Market,mktname,Moneytype,audi_cod,region
--from OutputCityPerformanceByBrand where Chart='Volume Trend'
--and YTD48<>0 and prod='000') B
--where  a.Market='Baraclude' and a.Molecule=b.Molecule and A.Class=B.Class and A.mkt=B.mkt and A.Market=B.Market
--and A.Moneytype=B.moneytype )
--and YTD48=0 and YTD36=0 and YTD24<>0 and Chart='Volume Trend' 


--insert into OutputCityPerformanceByBrand(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,YTD00)
--select 'CAGR',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,
--Power((YTD00/YTD12),1.0/1)-1
--from OutputCityPerformanceByBrand A where exists(select * from (
--select distinct Molecule,Class,mkt,Market,mktname,Moneytype,audi_cod,region
--from OutputCityPerformanceByBrand where Chart='Volume Trend'
--and YTD48<>0 and prod='000') B
--where  a.Market='Baraclude' and a.Molecule=b.Molecule and A.Class=B.Class and A.mkt=B.mkt and A.Market=B.Market
--and A.Moneytype=B.moneytype )
--and YTD48=0 and YTD36=0 and YTD24=0  and YTD12<>0 and Chart='Volume Trend' 


--insert into OutputCityPerformanceByBrand(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,YTD00)
--select 'CAGR',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,
--0 from OutputCityPerformanceByBrand A where exists(select * from (
--select distinct Molecule,Class,mkt,Market,mktname,Moneytype,audi_cod,region
--from OutputCityPerformanceByBrand where Chart='Volume Trend'
--and YTD48<>0 and prod='000') B
--where  a.Market='Baraclude' and  a.Molecule=b.Molecule and A.Class=B.Class and A.mkt=B.mkt and A.Market=B.Market
--and A.Moneytype=B.moneytype )
--and YTD48=0 and YTD36=0 and YTD24=0 and YTD12=0 and YTD00=0 and Chart='Volume Trend' 




go
insert into OutputCityPerformanceByBrand(Chart,[Molecule],[Class],[mkt],Market,[mktname],[Moneytype],audi_cod,audi_des,region,[prod],[Productname])
select * from (
	select A.*,B.Prod,B.Productname 
	from (
		select distinct [Chart]
			  ,[Molecule]
			  ,[Class]
			  ,[mkt]
			  ,[Market]
			  ,[mktname]
		--      ,[prod]
		--      ,[Productname]
			  ,[Moneytype]
			  ,[Audi_cod]
			  ,[Audi_des]
			  ,[Region] 
		from [OutputCityPerformanceByBrand]
	) A 
	inner join tblD080OutputProduct B  
	on A.Chart=B.Chart and A.molecule=B.molecule and A.class=B.Class and A.mkt=B.mkt and A.Market=B.Market
		and B.Active='Y' and A.Chart in ('Volume Trend','CAGR')
) A
where not exists(
	select * from [OutputCityPerformanceByBrand] B
	where A.Chart=B.Chart and A.molecule=B.molecule and A.class=B.Class and A.mkt=B.mkt and A.Market=B.Market
		and A.Productname=B.productname and A.audi_cod=B.audi_cod and A.region=B.region
)

--todo : 2013/7/1 11:39:41 Aric
-- 原因：客户反映要加的竞争品牌Anzatax在Taxol_dashboard城市数据里面没有加,查到这里有一张死表,然后做了如下处理：

-- insert into tblD080OutputProduct 
-- select 'Growth Trend','N','N','ONCFCS','Taxol','Oncology Focused Brands','860','Anzatax','Y' union all
-- select 'Market Share Trend','N','N','ONCFCS','Taxol','Oncology Focused Brands','860','Anzatax','Y' union all
-- select 'Share of Growth Trend','N','N','ONCFCS','Taxol','Oncology Focused Brands','860','Anzatax','Y' 
-- GO


go

 --and market='Baraclude' and mkt='HBV'
go
if exists(
	select * from tblD080OutputProduct A where not exists(select * from OutputCityPerformanceByBrand B
	where A.chart=B.chart and A.molecule=B.molecule and A.Class=B.Class
		and a.mkt=b.mkt and a.market=B.Market and a.productname=B.productname) and Active='Y')
	print 'need update table tblD080OutputProduct'
go
delete OutputCityPerformanceByBrand 
from OutputCityPerformanceByBrand A 
where not exists
	(
		select * from tblD080OutputProduct B
		where A.chart=B.chart and A.molecule=B.molecule and A.Class=B.Class
		and a.mkt=b.mkt and a.market=B.Market and a.productname=B.productname and Active='Y'
	)
	and market<>'Paraplatin'
go
update OutputCityPerformanceByBrand
set R3M00=null,R3M01=null,R3M02=null,R3M03=null,R3M04=null,R3M05=null,
	R3M12=null,R3M13=null,R3M14=null,R3M15=null,R3M16=null,R3M17=null,
	YTD00 = null, YTD12 = null, YTD24 = null, YTD36 = null,
	MAT00 = null, MAT12 = null, MAT24 = null, MAT36 = null,
	MTH00 = null, MTH12 = null, MTH24 = null, MTH36 = null
from OutputCityPerformanceByBrand A 
where exists(
	select * 
	from tblD080OutputProduct B
	where A.chart=B.chart and A.molecule=B.molecule and A.Class=B.Class
		and a.mkt=b.mkt and a.market=B.Market and a.productname=B.productname and Active='N'
)
go
update OutputCityPerformanceByBrand
set Productname='Monopril Market' 
where molecule='N' and class='N' and mkt='hyp'
	and Prod='000' and Productname='Hypertension Market'
go
update OutputCityPerformanceByBrand
set Productname='Taxol Market' 
where molecule='N' and class='N' and mkt='ONCFCS'
	and Prod='000' and Productname='Oncology Focused Brands'
go
-- 
-- delete from
-- OutputCityPerformanceByBrand where   market='baraclude' and class='Y'
-- and prod<>'000' and  chart in('Market Share Trend')

-- delete from
-- OutputCityPerformanceByBrand where market='baraclude'
-- and  (productname like '%HBV%' or mkt like  '%HBV%')
-- go
-- delete from OutputCityPerformanceByBrand where chart in('Volume Trend','CAGR') and (molecule='Y' or class='Y')
-- and Productname not in ('ARV Market','Entecavir') and market='Baraclude'
-- go
-- update OutputCityPerformanceByBrand
-- set Prod='000' 
-- where  chart in('Volume Trend','CAGR') and (molecule='Y' or class='Y')
-- and Productname  in ('ARV Market') and market='Baraclude' and Prod='910'
-- go
-- delete from OutputCityPerformanceByBrand where chart in('Volume Trend','CAGR') and molecule='N' and class='N'
-- and Productname not in ('ARV Market','Baraclude') and market='Baraclude'

-- delete from OutputCityPerformanceByBrand where chart in('Volume Trend','CAGR') and (molecule='Y' or class='Y')
-- and Productname not in ('NIAD','AGI','DPP4') and market='Glucophage'
-- delete from OutputCityPerformanceByBrand where chart in('Volume Trend','CAGR') and molecule='N' and class='N'
-- and Productname not in ('NIAD Market','Glucophage') and market='Glucophage'

-- delete from OutputCityPerformanceByBrand where chart not in ('Volume Trend','CAGR')
-- and (mkt='Dia' or molecule='Y') and market='Glucophage'

-- delete from OutputCityPerformanceByBrand where chart in('Volume Trend','CAGR') and (molecule='Y' or class='Y')
-- and Productname not in ('ACEI','ARB') and market='Monopril'
-- delete from OutputCityPerformanceByBrand where chart in('Volume Trend','CAGR') and molecule='N' and class='N'
-- and Productname not in ('Hypertension Market','Monopril') and market='Monopril'
-- delete from OutputCityPerformanceByBrand where market='monopril' and chart not in ('Volume Trend','CAGR')
-- and mkt='ACE'

-- delete from OutputCityPerformanceByBrand where chart in('Volume Trend','CAGR') and mkt<>'ONCFCS' 
-- and market='Taxol'
-- delete from OutputCityPerformanceByBrand where chart in('Volume Trend','CAGR') and mkt='ONCFCS' 
-- and market='Taxol' and Productname not in ('Oncology Focused Brands','Taxol')
-- delete from OutputCityPerformanceByBrand where market='taxol' and (class='Y' or molecule='Y')
-- go
-- delete OutputCityPerformanceByBrand from OutputCityPerformanceByBrand A where chart='Volume Trend' 
-- and not exists(select * from tblD081TrendProduct B where A.type=B.type and A.market=B.market and A.ta=B.TA and A.product=b.Product)
-- go

-- select distinct type,market,ta,product
-- into tblD081TrendProduct 
-- from OutputCityPerformanceByBrand
-- order by  type,market,ta,product


exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','OurputPreClassVSClass',null,null
--Predefined Reports slide 2
if exists (select * from dbo.sysobjects where id = object_id(N'[OurputPreClassVSClass]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [OurputPreClassVSClass]
go
CREATE TABLE [dbo].[OurputPreClassVSClass](
    [Type] [varchar](50)  NULL,
    [Molecule] [varchar](2)  NOT NULL,
    [Class] [varchar](2)  NOT NULL,
    [mkt] [varchar](50)  NULL,
	[mktname] [varchar](50)  NULL,
	[Market] [varchar](50)  NULL,
	[prod] [varchar](200)  NULL,
	[Productname] [varchar](200)  NULL,
	[Moneytype] [varchar](2)  NOT NULL,
	[Mat00] [float] NULL,
	[Mat12] [float] NULL,
	[Mat24] [float] NULL,
	[Mat36] [float] NULL,
	[Mat48] [float] NULL,
	[YTD00] [float] NULL,
	[YTD12] [float] NULL,
	[YTD24] [float] NULL,
	[YTD36] [float] NULL,
	[YTD48] [float] NULL,
--	[YTD60] [float] NULL,
    [R3M00] [float] NULL,
	[R3M01] [float] NULL,
	[R3M02] [float] NULL,
	[R3M03] [float] NULL,
	[R3M04] [float] NULL,
	[R3M05] [float] NULL,
	[R3M12] [float] NULL,
	[R3M13] [float] NULL,
	[R3M14] [float] NULL,
	[R3M15] [float] NULL,
	[R3M16] [float] NULL,
	[R3M17] [float] NULL
) ON [PRIMARY]

GO
insert into [OurputPreClassVSClass]
select 'Sales',[Molecule],[Class],[mkt],[mktname],Market,[prod],[Productname],[Moneytype],
	sum(isnull(Mat00,0)),sum(isnull(Mat12,0)),sum(isnull(Mat24,0)),sum(isnull(Mat36,0)),sum(isnull(Mat48,0)),
	sum(isnull(YTD00,0)),sum(isnull(YTD12,0)),sum(isnull(YTD24,0)),sum(isnull(YTD36,0)),sum(isnull(YTD48,0)),--sum(isnull(YTD60,0)),
	sum(R3M00) as R3M00,sum(R3M03) as R3M01,
	sum(R3M06) as R3M02,sum(R3M09) as R3M03,
	sum(R3M12) as R3M04,sum(R3M15) as R3M05,
	sum(R3M12) as R3M12,sum(R3M15) as R3M13,
	sum(R3M18) as R3M14,sum(R3M21) as R3M15,
	sum(R3M24) as R3M16,sum(R3M27) as R3M17
from TempCHPAPreReports
group by [Molecule],[Class],[mkt],[mktname],Market,[prod],[Productname],[Moneytype]
go
UPDATE OurputPreClassVSClass
SET Class='Y' where  mkt='Dia' and class='N' and prod='000'
go
UPDATE OurputPreClassVSClass
SET Class='N' where market='baraclude' and class='Y' and mkt='HBV'
go
UPDATE OurputPreClassVSClass
SET Class='Y' where market='Taxol' and class='N' and prod='000' and mkt='ONC'
go
insert into OurputPreClassVSClass
select 'Market Share',B.[Molecule],B.[Class],B.[mkt],B.[mktname],B.Market,B.[prod],B.[Productname],B.[Moneytype],
	case A.Mat00 when 0 then 0 else B.Mat00*1.0/A.Mat00 end,
	case A.Mat12 when 0 then 0 else B.Mat12*1.0/A.Mat12 end,
	case A.Mat24 when 0 then 0 else B.Mat24*1.0/A.Mat24 end,
	case A.Mat36 when 0 then 0 else B.Mat36*1.0/A.Mat36 end,
	case A.Mat48 when 0 then 0 else B.Mat48*1.0/A.Mat48 end,
	case A.YTD00 when 0 then 0 else B.YTD00/A.YTD00 end,
	case A.YTD12 when 0 then 0 else B.YTD12/A.YTD12 end,
	case A.YTD24 when 0 then 0 else B.YTD24/A.YTD24 end,
	case A.YTD36 when 0 then 0 else B.YTD36/A.YTD36 end,
	case A.YTD48 when 0 then 0 else B.YTD48/A.YTD48 end,
	--case A.YTD60 when 0 then 0 else B.YTD60/A.YTD60 end,
	case A.R3M00 when 0 then 0 else B.R3M00/A.R3M00 end,
	case A.R3M01 when 0 then 0 else B.R3M01/A.R3M01 end,
	case A.R3M02 when 0 then 0 else B.R3M02/A.R3M02 end,
	case A.R3M03 when 0 then 0 else B.R3M03/A.R3M03 end,
	case A.R3M04 when 0 then 0 else B.R3M04/A.R3M04 end,
	case A.R3M05 when 0 then 0 else B.R3M05/A.R3M05 end,
	case A.R3M12 when 0 then 0 else B.R3M12/A.R3M12 end,
	case A.R3M13 when 0 then 0 else B.R3M13/A.R3M13 end,
	case A.R3M14 when 0 then 0 else B.R3M14/A.R3M14 end,
	case A.R3M15 when 0 then 0 else B.R3M15/A.R3M15 end,
	case A.R3M16 when 0 then 0 else B.R3M16/A.R3M16 end,
	case A.R3M17 when 0 then 0 else B.R3M17/A.R3M17 end
from OurputPreClassVSClass A inner join OurputPreClassVSClass B
on A.[Molecule]=B.[Molecule] and A.[Class]=B.[Class] and A.Market=B.Market and A.[mkt]=B.[mkt] and A.MoneyType=B.MoneyType and A.[prod]='000' and B.prod<>'000'
GO
insert into OurputPreClassVSClass( [Type], [Molecule],[Class],
    [mkt],[mktname],[Market],[prod],[Productname],[Moneytype])
select 'Market Share',A.[Molecule],A.[Class],A.[mkt],A.[mktname],A.Market,A.[prod],A.[Productname],A.[Moneytype]
from OurputPreClassVSClass A where prod='000'
--and A.Class='HBV' and B.Class='ARV'
go
insert into OurputPreClassVSClass
select 'Growth',[Molecule],[Class],[mkt],[mktname],Market,[prod],[Productname],[Moneytype],
	case Mat12 when 0 then case Mat00 when 0 then 0 else null end else (Mat00-Mat12)*1.0/Mat12 end,
	case Mat24 when 0 then case Mat12 when 0 then 0 else null end else (Mat12-Mat24)*1.0/Mat24 end,
	case Mat36 when 0 then case Mat24 when 0 then 0 else null end else (Mat24-Mat36)*1.0/Mat36 end,
	case Mat48 when 0 then case Mat36 when 0 then 0 else null end else (Mat36-Mat48)*1.0/Mat48 end,
	null,
	case YTD12 when 0 then case YTD00 when 0 then 0 else null end else (YTD00-YTD12)*1.0/YTD12 end,
	case YTD24 when 0 then case YTD12 when 0 then 0 else null end else (YTD12-YTD24)*1.0/YTD24 end,
	case YTD36 when 0 then case YTD24 when 0 then 0 else null end else (YTD24-YTD36)*1.0/YTD36 end,
	case YTD48 when 0 then case YTD36 when 0 then 0 else null end else (YTD36-YTD48)*1.0/YTD48 end,
	--case YTD60 when 0 then case YTD48 when 0 then 0 else null end else (YTD48-YTD60)*1.0/YTD60 end,
	null,
	case R3M12 when 0 then case R3M00 when 0 then 0 else null end else (R3M00-R3M12)/R3M12 end,
	case R3M13 when 0 then case R3M01 when 0 then 0 else null end else (R3M01-R3M13)/R3M13 end,
	case R3M14 when 0 then case R3M02 when 0 then 0 else null end else (R3M02-R3M14)/R3M14 end,
	case R3M15 when 0 then case R3M03 when 0 then 0 else null end else (R3M03-R3M15)/R3M15 end,
	case R3M16 when 0 then case R3M04 when 0 then 0 else null end else (R3M04-R3M16)/R3M16 end,
	case R3M17 when 0 then case R3M05 when 0 then 0 else null end else (R3M05-R3M17)/R3M17 end,0,0,0,0,0,0
from OurputPreClassVSClass where type='Sales'
go

insert into OurputPreClassVSClass(type,[Molecule],[Class],[mkt],[mktname],Market,[prod],[Productname],[Moneytype],R3M00,YTD00,MAT00)
select 'CAGR' as type,[Molecule],[Class],[mkt],[mktname],Market,[prod],[Productname],[Moneytype],
	case when r3m00 is null or r3m00=0 then 0 
		else  (case when R3M05 <>0 then  Power((R3M00/R3M05),1.0/5)
					when R3M05=0 and R3M04<>0 then Power((R3M00/R3M04),1.0/4) 
					when R3M05=0 and R3M04=0 and R3M03<>0 then Power((R3M00/R3M03),1.0/3)
					when R3M05=0 and R3M04=0 and R3M03=0 and R3M02<>0 then Power((R3M00/R3M02),1.0/2)
					when R3M05=0 and R3M04=0 and R3M03=0 and R3M02=0 and R3M01<>0 then Power((R3M00/R3M01),1.0/1)
					else 1 end)-1 
		end as R3M00,				   
	case when ytd00 is null or ytd00 =0 then 0 
		else (case when YTD48 <>0 then Power((YTD00/YTD48),1.0/4)	
					when YTD48=0 and YTD36<>0 then Power((YTD00/YTD36),1.0/3) 
					when YTD48=0 and YTD36=0 and YTD24<>0 then Power((YTD00/YTD24),1.0/2)
					when YTD48=0 and YTD36=0 and YTD24=0 and YTD12<>0 then Power((YTD00/YTD12),1.0/1)
					else 1 end)-1 
		end as YTD00,
	case when MAT00 is null or MAT00 =0 then 0 
		else (case when MAT48 <>0 then Power((MAT00/MAT48),1.0/4)	
					when MAT48=0 and MAT36<>0 then Power((MAT00/MAT36),1.0/3) 
					when MAT48=0 and MAT36=0 and MAT24<>0 then Power((MAT00/MAT24),1.0/2)
					when MAT48=0 and MAT36=0 and MAT24=0 and MAT12<>0 then Power((MAT00/MAT12),1.0/1)
					else 1 end)-1 
		end as MAT00				    				   
from OurputPreClassVSClass A where exists(select * from (
select distinct Molecule,Class,mkt,Market,mktname,Moneytype
from OurputPreClassVSClass where [type]='Sales'
and (R3M05<>0 or YTD48<>0 or MAT48<>0) and prod='000') B
where a.Molecule=b.Molecule and A.Class=B.Class and A.mkt=B.mkt and A.Market=B.Market
and A.Moneytype=B.moneytype )
and  [type]='Sales'




insert into OurputPreClassVSClass
select 'Share of Growth',B.[Molecule],B.[Class],B.[mkt],B.[mktname],B.Market,B.[prod],B.[Productname],B.[Moneytype],
	case (A.Mat00-A.Mat12) when 0 then 0 else (B.Mat00-B.Mat12)/(A.Mat00-A.Mat12) end,
	case (A.Mat12-A.Mat24) when 0 then 0 else (B.Mat12-B.Mat24)/(A.Mat12-A.Mat24) end,
	case (A.Mat24-A.Mat36) when 0 then 0 else (B.Mat24-B.Mat36)/(A.Mat24-A.Mat36) end,
	case (A.Mat36-A.Mat48) when 0 then 0 else (B.Mat36-B.Mat48)/(A.Mat36-A.Mat48) end,
	0,
	case (A.YTD00-A.YTD12) when 0 then 0 else (B.YTD00-B.YTD12)/(A.YTD00-A.YTD12) end,
	case (A.YTD12-A.YTD24) when 0 then 0 else (B.YTD12-B.YTD24)/(A.YTD12-A.YTD24) end,
	case (A.YTD24-A.YTD36) when 0 then 0 else (B.YTD24-B.YTD36)/(A.YTD24-A.YTD36) end,
	case (A.YTD36-A.YTD48) when 0 then 0 else (B.YTD36-B.YTD48)/(A.YTD36-A.YTD48) end,
	--case (A.YTD48-A.YTD60) when 0 then 0 else (B.YTD48-B.YTD60)/(A.YTD48-A.YTD60) end,
	0,
	case (A.R3M00-A.R3M12) when 0 then 0 else (B.R3M00-B.R3M12)/(A.R3M00-A.R3M12) end,
	case (A.R3M01-A.R3M13) when 0 then 0 else (B.R3M01-B.R3M13)/(A.R3M01-A.R3M13) end,
	case (A.R3M02-A.R3M14) when 0 then 0 else (B.R3M02-B.R3M14)/(A.R3M02-A.R3M14) end,
	case (A.R3M03-A.R3M15) when 0 then 0 else (B.R3M03-B.R3M15)/(A.R3M03-A.R3M15) end,
	case (A.R3M04-A.R3M16) when 0 then 0 else (B.R3M04-B.R3M16)/(A.R3M04-A.R3M16) end,
	case (A.R3M05-A.R3M17) when 0 then 0 else (B.R3M05-B.R3M17)/(A.R3M05-A.R3M17) end,
	0,0,0,0,0,0
from OurputPreClassVSClass A inner join OurputPreClassVSClass B
on A.[Molecule]=B.[Molecule] and A.[Class]=B.[Class] and A.Market=B.Market and A.[mkt]=B.[mkt] and A.MoneyType=B.MoneyType and A.[prod]='000' and B.prod<>'000'
	and A.[Type]=B.[Type] and A.[Type]='Sales'
go
--select * from OurputPreClassVSClass
if exists (select * from dbo.sysobjects where id = object_id(N'[OurputPreMarketTrendT1]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [OurputPreMarketTrendT1]
go
select * into [OurputPreMarketTrendT1] from [OurputPreClassVSClass]
go

drop table [OurputPreMarketTrendT1_4_R010]
select * into [OurputPreMarketTrendT1_4_R010]
from [OurputPreMarketTrendT1] where market='Taxol' and [type] in ('Sales') and Prod='000' and mkt='ONC'
GO

delete from [OurputPreMarketTrendT1] where type='CAGR'-- and Market<>'Baraclude'
delete from [OurputPreMarketTrendT1] where market='baraclude' and mkt<>'HBV'
delete from [OurputPreMarketTrendT1] where market='baraclude' and mkt='HBV' and type='Market Share' and Prod='000'
delete from [OurputPreMarketTrendT1] where market='baraclude' and [type]='Share of Growth'

delete from [OurputPreMarketTrendT1] where market='Taxol' and mkt<>'ONC'
delete from [OurputPreMarketTrendT1] where market='Taxol' and molecule='Y'
delete from [OurputPreMarketTrendT1] where market='Taxol' and [type] in ('Market Share','Share of Growth')
delete from [OurputPreMarketTrendT1] where market='Taxol' and [type] in ('Sales') and Prod='000'

delete from [OurputPreMarketTrendT1] where market='Monopril' and mkt<>'HYP'
delete from [OurputPreMarketTrendT1] where market='Monopril' and mkt='HYP' and class='N'
delete from [OurputPreMarketTrendT1] where market='Monopril' and Class='N' and Prod<>'000'
delete from [OurputPreMarketTrendT1] where market='Monopril' and [type] in ('Share of Growth') 
delete from [OurputPreMarketTrendT1] where market='Monopril'and [type] in ('Sales') and Prod='000'

delete from [OurputPreMarketTrendT1] where market='glucophage' and [type] in ('Share of Growth') 
delete from [OurputPreMarketTrendT1] where market='glucophage' and Productname='DIA Others'
delete from [OurputPreMarketTrendT1] where market='glucophage' and mkt='NIAD' and Class='N'
delete from [OurputPreMarketTrendT1] where market='glucophage' and mkt='NIAD' and Prod='000'
delete from [OurputPreMarketTrendT1] where type='Market Share' and Prod='000'
delete from [OurputPreMarketTrendT1] where Market='Onglyza'
delete from [OurputPreMarketTrendT1] where Market='Sprycel'

delete 
from [OurputPreMarketTrendT1]
where Market <> 'Paraplatin' and MoneyType = 'PN'
go
insert into [OurputPreMarketTrendT1](type,[Molecule],[Class],[mkt],[mktname],Market,[prod],[Productname],[Moneytype],MAT00,YTD00)
select 'CAGR',[Molecule],[Class],[mkt],[mktname],Market,[prod],[Productname],[Moneytype],
	case when MAT00 IS NULL OR MAT00=0 THEN 0 ELSE Power((MAT00/MAT48),1.0/4)-1 END,
	case when YTD00 IS NULL OR YTD00=0 THEN 0 ELSE Power((YTD00/YTD48),1.0/4)-1 END
 from [OurputPreMarketTrendT1] A where [type]='Sales' and market='baraclude'
go
--select * from [OurputPreMarketTrendT1]
if exists (select * from dbo.sysobjects where id = object_id(N'[OurputPreBrandTotalPerformance]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [OurputPreBrandTotalPerformance]
go

select * into  [OurputPreBrandTotalPerformance] from [OurputPreClassVSClass] 
where type in('Sales','Market Share') and mkt in ('ARV','NIAD','HYP','ONCFCS','Platinum','CCB')
	and molecule='N' and Class='N' and prod<>'000' and Productname not like '%other%'
order by market,type, molecule,class,mkt,mktname,prod,productname
go

alter table [OurputPreBrandTotalPerformance]
add Mat00Growth float default 0 null,CurrRank int,
	YTD00Growth float default 0 null,YTDRank int
go

update [OurputPreBrandTotalPerformance]
set Mat00Growth=case Mat12 when 0 then case Mat00 when 0 then 0 else null end else (Mat00-Mat12)*1.0/Mat12 end
go

update [OurputPreBrandTotalPerformance]
set CurrRank=B.Rank 
from [OurputPreBrandTotalPerformance] A 
inner join
	(	select A.*, RANK ( )OVER (PARTITION BY MoneyType,mkt,Market order by MAT00 desc ) as Rank 
		from [OurputPreBrandTotalPerformance] A where type='Sales'
	) B
on A.[Molecule]=B.[Molecule] and A.[Class]=B.[Class] and A.Market=B.Market and A.[mkt]=B.[mkt] and A.MoneyType=B.MoneyType and A.[productname]=B.[productname]
go

update [OurputPreBrandTotalPerformance]
set YTD00Growth=case YTD12 when 0 then case YTD00 when 0 then 0 else null end else (YTD00-YTD12)*1.0/YTD12 end
go

update [OurputPreBrandTotalPerformance]
set YTDRank=B.Rank from [OurputPreBrandTotalPerformance] A 
inner join
	(	select A.*, RANK ( )OVER (PARTITION BY MoneyType,mkt,Market order by YTD00 desc ) as Rank 
 		from [OurputPreBrandTotalPerformance] A where type='Sales'
	) B
on A.[Molecule]=B.[Molecule] and A.[Class]=B.[Class] and A.Market=B.Market and A.[mkt]=B.[mkt] and A.MoneyType=B.MoneyType and A.[productname]=B.[productname]
go

insert into [OurputPreMarketTrendT1_4_R010](type,[Molecule],[Class],[mkt],[mktname],Market,[prod],[Productname],[Moneytype],MAT00)
select 'CAGR',[Molecule],[Class],[mkt],[mktname],Market,[prod],[Productname],[Moneytype],
	Power((MAT00/MAT48),1.0/4)-1
from [OurputPreMarketTrendT1_4_R010] A where [type]='Sales' and market='Taxol'
go



if exists (select * from dbo.sysobjects where id = object_id(N'[OurputPreMarketPerformance]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [OurputPreMarketPerformance]
go
select * into [OurputPreMarketPerformance] from [OurputPreClassVSClass]
GO
insert into [OurputPreMarketPerformance]
SELECT [Type]
      ,[Molecule]
      ,[Class]
      ,[mkt]
      ,[mktname]
      ,'Onglyza'
      ,[prod]
      ,[Productname]
      ,[Moneytype]
      ,[Mat00]
      ,[Mat12]
      ,[Mat24]
      ,[Mat36]
      ,[Mat48]
      ,[YTD00]
      ,[YTD12]
      ,[YTD24]
      ,[YTD36]
      ,[YTD48]
--      ,[YTD60]
      ,[R3M00]
      ,[R3M01]
      ,[R3M02]
      ,[R3M03]
      ,[R3M04]
      ,[R3M05]
      ,[R3M12]
      ,[R3M13]
      ,[R3M14]
      ,[R3M15]
      ,[R3M16]
      ,[R3M17]
FROM [dbo].[OurputPreMarketPerformance]
where Market='Glucophage' and mkt='NIAD' and Class='N'
go
if exists(
		select *
		from tblR050OutputProduct A
		where not exists(
					select *
					from [OurputPreMarketPerformance] B
					where A.[TYPE]=B.[TYPE] and A.molecule=B.molecule and A.Class=B.Class
						and a.mkt=b.mkt and a.market=B.Market and a.productname=B.productname
					) and Active='Y'
		)
	print 'need update table tblR050OutputProduct'
go
delete [OurputPreMarketPerformance] 
from [OurputPreMarketPerformance] A 
where not exists(
		select * 
		from tblR050OutputProduct B
		where A.[TYPE]=B.[TYPE] and A.molecule=B.molecule and A.Class=B.Class
			and a.mkt=b.mkt and a.market=B.Market and a.productname=B.productname 
		)
	and market not in ('Paraplatin' ,'Coniel')
go
update [OurputPreMarketPerformance]
set R3M00=null,R3M01=null,R3M02=null,R3M03=null,R3M04=null,R3M05=null,
	R3M12=null,R3M13=null,R3M14=null,R3M15=null,R3M16=null,R3M17=null
from [OurputPreMarketPerformance] A 
where exists(
		select * from tblR050OutputProduct B
		where A.[TYPE]=B.[TYPE] and A.molecule=B.molecule and A.Class=B.Class
			and a.mkt=b.mkt and a.market=B.Market and a.productname=B.productname and Active='N'
		)
go
update [OurputPreMarketPerformance]
set Productname='Monopril Market' 
where molecule='N' and class='N' and mkt='hyp'
	and Prod='000' and Productname='Hypertension Market'
go
update [OurputPreMarketPerformance]
set Productname='Taxol Market' 
where molecule='N' and class='N' and mkt='ONCFCS'
	and Prod='000' and Productname='Oncology Focused Brands'


-- delete from [OurputPreMarketPerformance] where market='baraclude' and mkt<>'ARV'
-- delete from [OurputPreMarketPerformance] where market='baraclude' and [type] in('Sales','CAGR')
-- and Productname not in ('Baraclude','Entecavir','ARV Market')

-- delete from [OurputPreMarketPerformance] where market='Taxol' and mkt<>'ONCFCS'
-- delete from [OurputPreMarketPerformance] where market='Taxol' and [type] in ('Sales','CAGR')
-- and Productname not in ('Taxol','Oncology Focused Brands')

-- delete from [OurputPreMarketPerformance] where market='Monopril' and [type] in('Sales','CAGR') and
-- not ((mkt='HYP' and Productname in ('ACEI','ARB','Monopril','Hypertension Market')) 
-- or (mkt='ACE' and Productname in ('Monopril','ACE Class')))

-- delete from [OurputPreMarketPerformance] where market='glucophage' and [type] in('Sales','CAGR') and
-- not ((mkt='DIA' and Productname in ('Diabetes Market','NIAD','Insulin') )
-- or (mkt='NIAD' and Productname in ('DPP4','AGI','NIAD Market','Glucophage')))

-- select distinct market,type,molecule,class,mkt,mktname,prod,productname 
-- from [OurputPreMarketPerformance] where type in('Market Share') 
-- and ((molecule='N' and class='N') or prod='000') and mkt not in('Dia','ACE')
-- order by market,type,molecule,class,mkt,mktname,prod,productname

-- select distinct market,type,molecule,class,mkt,mktname,prod,productname 
-- from [OurputPreMarketPerformance] where type in('Market Share') 
-- and ((molecule='Y' or class='Y') or prod='000') and mkt not in('Dia','ACE')
-- and not (mkt='NIAD' and molecule='Y')
-- order by market,type,molecule,class,mkt,mktname,prod,productname

-- select distinct market,type,molecule,class,mkt,mktname,prod,productname 
-- from [OurputPreMarketPerformance] where type in('Market Share') 
-- and mkt in('Dia','ACE')
-- order by market,type,molecule,class,mkt,mktname,prod,productname

-- --CAGR
-- --Sales
-- --Share of Growth
-- --Growth
-- --Market Share

go

exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','OutputPreCityPerformance',null,null
if exists (select * from dbo.sysobjects where id = object_id(N'OutputPreCityPerformance') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputPreCityPerformance
go
CREATE TABLE [dbo].[OutputPreCityPerformance](
	[Period] [varchar](10) NULL,
    [MoneyType] [varchar](10) NULL,
	[market] [varchar](10) NULL,
	[Molecule] [varchar](10) NULL,
	[Class] [varchar](10) NULL,
	[Mkt] [varchar](10) NULL,
	[MktName] [varchar](100) NULL,
	[Prod] [varchar](10) NULL,
	[Productname] [varchar](100) NULL,
	[Audi_cod] [varchar](50) NULL,
	[AUDI_DES] [varchar](100) NULL,
	[Qtr00] [float] NULL,
	[Qtr12] [float] NULL,
) ON [PRIMARY]
GO
insert into OutputPreCityPerformance
select Cast('MQT' as varchar(10)) as [Period],Moneytype,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,Audi_cod,Audi_des,sum(R3M00),sum(R3M12)
from dbo.TempCityDashboard_forPre
where lev='city' and (
		(prod='000' and mkt in ('ARV','ONCFCS','ACE','Platinum','CCB') and class='N' and molecule='N')
		or (prod='000' and mkt in ('NIAD','HYP') and class='Y' and molecule='N')
		or (market='Glucophage' and mkt='dia' and Productname in ('Diabetes Market','NIAD','Insulin'))
		or (Prod='000' and mkt='DPP4')
		)
group by Moneytype,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,Audi_cod,Audi_des

insert into OutputPreCityPerformance
select Cast('YTD' as varchar(10)) as [Period],Moneytype,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,Audi_cod,Audi_des,sum(YTD00),sum(YTD12)
from dbo.TempCityDashboard_forPre
where lev='city' and ((prod='000' and mkt in ('ARV','ONCFCS','ACE','Platinum','CCB') and class='N' and molecule='N')
	or (prod='000' and mkt in ('NIAD','HYP') and class='Y' and molecule='N')
	or (market='Glucophage' and mkt='dia' and Productname in ('Diabetes Market','NIAD','Insulin'))
	or (Prod='000' and mkt='DPP4'))
group by Moneytype,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,Audi_cod,Audi_des
go
insert into OutputPreCityPerformance
select *,0,0 
from (	select * from (SELECT distinct  [Period]
			,[MoneyType]
			,[market]
			,[Molecule]
			,[Class]
			,[Mkt]
			,[MktName]
			,[Prod]
			,[Productname]
		FROM [dbo].[OutputPreCityPerformance]) A,
			(select distinct audi_cod,audi_des from [OutputPreCityPerformance] )B
) A
where not exists(
		select * 
		from [OutputPreCityPerformance] B
		where A.Period=B.Period and A.MoneyType=B.MoneyType and A.market=B.market and A.Molecule=B.Molecule 
			and A.Class=B.Class and A.mkt=b.mkt and A.mktname=B.mktname
			and A.[Productname]=B.[Productname] and A.audi_des=B.audi_des
		)
go
alter table OutputPreCityPerformance
Add Growth float, Contribution float,PrevContribution float,TotalContribution float
go
update OutputPreCityPerformance
set Contribution=A.Qtr00*1.0/B.R3M00 
from OutputPreCityPerformance A 
inner join 
(	select 'MQT' as Period,MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,sum(R3M00) as  R3M00
	from dbo.TempCHPAPreReports
	where  ((prod='000' and mkt in ('ARV','ONCFCS','ACE','Platinum','CCB') and class='N' and molecule='N')
		or (prod='000' and mkt in ('NIAD','HYP') and class='Y' and molecule='N')
		or (market='Glucophage' and mkt='dia' and Productname in ('Diabetes Market','NIAD','Insulin') )
		or (Prod='000' and mkt='DPP4')
		)
	group by MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName
union
	select 'YTD' as Period,MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,sum(YTD00)
	from dbo.TempCHPAPreReports
	where  ((prod='000' and mkt in ('ARV','ONCFCS','ACE','Platinum','CCB') and class='N' and molecule='N')
	or (prod='000' and mkt in ('NIAD','HYP') and class='Y' and molecule='N')
	or (market='Glucophage' and mkt='dia' and Productname in ('Diabetes Market','NIAD','Insulin'))
	or (Prod='000' and mkt='DPP4'))
	group by MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName
) B
on A.Period=B.Period and A.MoneyType=B.MoneyType and A.market=B.market and a.Molecule=B.Molecule and A.Class=B.Class and A.mkt=b.mkt and a.mktname=B.mktname and a.productname=B.Productname

update OutputPreCityPerformance
set PrevContribution=A.Qtr12*1.0/B.R3M12 
from OutputPreCityPerformance A 
inner join 
		(select 'MQT' as Period,MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,sum(R3M12) as  R3M12
		from dbo.TempCHPAPreReports
		where  ((prod='000' and mkt in ('ARV','ONCFCS','ACE','Platinum','CCB') and class='N' and molecule='N')
		or (prod='000' and mkt in ('NIAD','HYP') and class='Y' and molecule='N')
		or (market='Glucophage' and mkt='dia' and Productname in ('Diabetes Market','NIAD','Insulin'))
		or (Prod='000' and mkt='DPP4'))
		group by MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName
	union
		select 'YTD' as Period,MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,sum(YTD12)
		from dbo.TempCHPAPreReports
		where  ((prod='000' and mkt in ('ARV','ONCFCS','ACE','Platinum','CCB') and class='N' and molecule='N')
		or (prod='000' and mkt in ('NIAD','HYP') and class='Y' and molecule='N')
		or (market='Glucophage' and mkt='dia' and Productname in ('Diabetes Market','NIAD','Insulin'))
		or (Prod='000' and mkt='DPP4'))
		group by MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName) B
on A.Period=B.Period and A.MoneyType=B.MoneyType and A.market=B.market and a.Molecule=B.Molecule and A.Class=B.Class and A.mkt=b.mkt and a.mktname=B.mktname and a.productname=B.Productname


update OutputPreCityPerformance
set TotalContribution=B.R3M00*1.0/C.R3M00 
from OutputPreCityPerformance A 
inner join
		(select Period,MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,sum(Qtr00) as  R3M00
		from OutputPreCityPerformance A group by Period,MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName) B 
		on A.Period=B.Period and A.MoneyType=B.MoneyType and A.market=B.market and A.Molecule=B.Molecule and A.Class=B.Class and A.mkt=b.mkt and A.mktname=B.mktname and A.productname=B.Productname inner join 
		(select 'MQT' as Period,MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,sum(R3M00) as  R3M00
		from dbo.TempCHPAPreReports
		where  ((prod='000' and mkt in ('ARV','ONCFCS','ACE','Platinum','CCB') and class='N' and molecule='N')
		or (prod='000' and mkt in ('NIAD','HYP') and class='Y' and molecule='N')
		or (market='Glucophage' and mkt='dia' and Productname in ('Diabetes Market','NIAD','Insulin'))
		or (Prod='000' and mkt='DPP4')	)
		group by MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName
	union
		select 'YTD' as Period,MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,sum(YTD00)
		from dbo.TempCHPAPreReports
		where  ((prod='000' and mkt in ('ARV','ONCFCS','ACE','Platinum','CCB') and class='N' and molecule='N')
		or (prod='000' and mkt in ('NIAD','HYP') and class='Y' and molecule='N')
		or (market='Glucophage' and mkt='dia' and Productname in ('Diabetes Market','NIAD','Insulin'))
		or (Prod='000' and mkt='DPP4'))
		group by MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName) C
on C.Period=B.Period and C.MoneyType=B.MoneyType and C.market=B.market and C.Molecule=B.Molecule and C.Class=B.Class and C.mkt=b.mkt and C.mktname=B.mktname and C.productname=B.Productname
go
update OutputPreCityPerformance
set Market='Glucophage' where market='Onglyza'
go
update OutputPreCityPerformance
set Growth=case Qtr12 when 0 then case Qtr00 when 0 then 0 else null end else (Qtr00-Qtr12)*1.0/Qtr12 end where audi_des not in (select audi_des from tblNewCity)
go
Alter table OutputPreCityPerformance 
Add ChangeContribution int
go
update OutputPreCityPerformance
set ChangeContribution=-sign(Contribution-PrevContribution)
go
Alter table OutputPreCityPerformance
Add [CurrRank] int,[PrevRank] int,changeRank int
go
update OutputPreCityPerformance
set [CurrRank]=B.Rank 
from OutputPreCityPerformance A 
inner join
    (	select Period,MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName, Audi_cod, RANK ( )OVER (PARTITION BY Period,MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName order by Qtr00 desc ) as Rank 
		from OutputPreCityPerformance where audi_des not in (select audi_des from tblNewCity)
	) B
on A.Period=B.Period and A.MoneyType=B.MoneyType and A.Audi_cod=b.Audi_cod and A.market=B.market and a.Molecule=B.Molecule and A.Class=B.Class and A.mkt=b.mkt and a.mktname=B.mktname and A.prod=B.prod
go
--update OutputPreCityPerformance
--set [CurrRank]=B.Rank from OutputPreCityPerformance A inner join
--    (select Period,MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName, Audi_cod,Audi_des,Qtr00, RANK ( )OVER (PARTITION BY Period,MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName order by Qtr00 desc ) as Rank from OutputPreCityPerformance where Productname='NIAD' and audi_des not in (select audi_des from tblNewCity)) B
--on A.Period=B.Period and A.MoneyType=B.MoneyType and A.Audi_cod=b.Audi_cod and A.market=B.market and A.mkt=b.mkt and a.mktname=B.mktname 
--where A.mkt='Dia'
go
update OutputPreCityPerformance
set [CurrRank]=B.Rank 
from OutputPreCityPerformance A 
inner join
    (	select 
			Period,MoneyType,market,Molecule,Class,Mkt,MKtName,
			Audi_cod,Audi_des,Qtr00, 
			RANK ( )OVER (PARTITION BY Period,MoneyType,market,Molecule,Class,Mkt,MKtName
			order by Qtr00 desc ) as Rank 
		from 
			(	select Period,MoneyType,market,Molecule,Class,Mkt,MKtName,audi_cod,audi_des,sum(Qtr00) as Qtr00 
				from OutputPreCityPerformance 
				where Productname in('NIAD','Insulin') and audi_des not in (select audi_des from tblNewCity)
				group by Period,MoneyType,market,Molecule,Class,Mkt,MKtName,audi_cod,audi_des
			) A
) B
on A.Period=B.Period and A.MoneyType=B.MoneyType and A.Audi_cod=b.Audi_cod and A.market=B.market 
	and A.mkt=b.mkt and a.mktname=B.mktname 
where A.mkt='Dia'
go

update OutputPreCityPerformance
set [CurrRank]=B.Rank+100 
from OutputPreCityPerformance A 
inner join
    (	select 
			Period,MoneyType,market,Molecule,Class,Mkt,MKtName,
			Audi_cod,Audi_des,Qtr00, 
			RANK ( )OVER (PARTITION BY Period,MoneyType,market,Molecule,Class,Mkt,MKtName
			order by Qtr00 desc ) as Rank 
		from 
			(	select Period,MoneyType,market,Molecule,Class,Mkt,MKtName,audi_cod,audi_des,sum(Qtr00) as Qtr00 
				from OutputPreCityPerformance 
				where Productname in('NIAD','Insulin') and audi_des in (select audi_des from tblNewCity
			)
		group by Period,MoneyType,market,Molecule,Class,Mkt,MKtName,audi_cod,audi_des) A
) B
on A.Period=B.Period and A.MoneyType=B.MoneyType and A.Audi_cod=b.Audi_cod and A.market=B.market and A.mkt=b.mkt and a.mktname=B.mktname 
where A.mkt='Dia'
go

update OutputPreCityPerformance
set [PrevRank]=B.Rank 
from OutputPreCityPerformance A
inner join
	(	select Period, MoneyType, market, Molecule, Class, Mkt, MKtName, Prod, ProductName, Audi_cod, RANK ( )over (PARTITION by Period,MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName order by Qtr12 desc ) as Rank
		from OutputPreCityPerformance
		where audi_des not in (
				select audi_des from tblNewCity)
	) B
	on A.Period=B.Period and A.MoneyType=B.MoneyType and A.Audi_cod=b.Audi_cod and A.market=B.market and a.Molecule=B.Molecule and A.Class=B.Class and A.mkt=b.mkt and a.mktname=B.mktname and A.prod=B.prod
go
update OutputPreCityPerformance
set changeRank=-sign([CurrRank]-[PrevRank]) where audi_des not in (select audi_des from tblNewCity)
go
Alter table OutputPreCityPerformance
Add [Avg.Growth] float
go
update OutputPreCityPerformance
set [Avg.Growth]=B.Growth 
from  OutputPreCityPerformance A 
inner join
(
	select  Period,MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,sum(growth)*1.0/count(*) as Growth
	from OutputPreCityPerformance 
	where audi_des not in (select audi_des from tblNewCity)
	group by  Period,MoneyType,market,Molecule,Class,Mkt,MKtName,Prod,ProductName 
) B
on A.Period=B.Period and A.Moneytype=B.Moneytype and A.market=B.market and a.Molecule=B.Molecule and A.Class=B.Class and A.mkt=b.mkt and a.mktname=B.mktname and A.productname=B.Productname
go
if exists (select * from dbo.sysobjects where id = object_id(N'OutputPreCityPerformance2') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputPreCityPerformance2
go

SELECT A.[Period],A.Moneytype,A.market,A.Molecule,A.Class,A.Mkt,A.MKtName,A.Prod,A.ProductName,A.Audi_cod,A.Audi_des,
	case B.R3M00 when 0 then 0 else A.R3M00*1.0/B.R3M00 end as Share
INTO OutputPreCityPerformance2 
FROM 
(	select Cast('MQT' as varchar(10)) as [Period],Moneytype,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,Audi_cod,Audi_des,sum(R3M00) AS R3M00
	from dbo.TempCityDashboard_forPre
	where lev='city' 
		and Productname in ('Onglyza','Januvia','Galvus','Metformin' ,'Glucophage','Monopril','Baraclude','Entecavir','Taxol','Paraplatin','Coniel')
		and mkt<>'ACE' AND Moneytype='UN' 
	GROUP BY Moneytype,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,Audi_cod,Audi_des
) A
INNER JOIN
(
	select Cast('MQT' as varchar(10)) as [Period],Moneytype,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,Audi_cod,Audi_des,sum(R3M00)AS R3M00
	from dbo.TempCityDashboard_forPre
	where lev='city' AND Moneytype='UN' AND mkt in ('ARV','NIAD','HYP','ONCFCS','Platinum','CCB') and Prod='000' AND MOLECULE='N' AND CLASS='N'
		and mkt<>'ACE' 
	GROUP BY Moneytype,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,Audi_cod,Audi_des
) B
ON A.Period=B.Period and A.MoneyType=B.MoneyType and A.market=B.market  and A.mkt=b.mkt and a.mktname=B.mktname and A.AUDI_COD=B.AUDI_COD

UNION

SELECT A.[Period],A.Moneytype,A.market,A.Molecule,A.Class,A.Mkt,A.MKtName,A.Prod,A.ProductName,A.Audi_cod,A.Audi_des,
case B.YTD00 when 0 then 0 else A.YTD00*1.0/B.YTD00 end as Share FROM 
(select Cast('YTD' as varchar(10)) as [Period],Moneytype,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,Audi_cod,Audi_des,sum(YTD00) AS YTD00
from dbo.TempCityDashboard_forPre
where lev='city' and Productname in ('Onglyza','Januvia','Galvus','Metformin'
,'Glucophage','Monopril','Baraclude','Entecavir','Taxol','Paraplatin','Coniel')
and mkt<>'ACE' AND Moneytype='UN' 
GROUP BY Moneytype,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,Audi_cod,Audi_des) A
INNER JOIN
(
select Cast('YTD' as varchar(10)) as [Period],Moneytype,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,Audi_cod,Audi_des,sum(YTD00)AS YTD00
from dbo.TempCityDashboard_forPre
where lev='city' AND Moneytype='UN' AND mkt in ('ARV','NIAD','HYP','ONCFCS','Platinum','CCB') and Prod='000' AND MOLECULE='N' AND CLASS='N'
and mkt<>'ACE' 
GROUP BY Moneytype,market,Molecule,Class,Mkt,MKtName,Prod,ProductName,Audi_cod,Audi_des) B
ON A.Period=B.Period and A.MoneyType=B.MoneyType and A.market=B.market  and A.mkt=b.mkt and a.mktname=B.mktname and A.AUDI_COD=B.AUDI_COD
GO
update OutputPreCityPerformance2
set Market='Onglyza' where Productname in ('Onglyza','Galvus','Januvia')
go
insert into OutputPreCityPerformance2
	(Period, Moneytype, market, Molecule, Class, Mkt, MKtName, Prod, ProductName, Audi_cod, Audi_des, Share)
select Period, Moneytype, market, Molecule, Class, Mkt, MKtName, Prod, ProductName, Audi_cod, Audi_des, 0 
from (
	select distinct A.Period, A.MoneyType, A.Market, A.Molecule, A.Class, A.mkt, A.MKtName,A.Prod, A.productname,B.Audi_cod,B.Audi_des
	from OutputPreCityPerformance2 A ,OutputPreCityPerformance2 B where A.Market='Onglyza' and A.Market=B.Market) B
where not exists(
	select * from OutputPreCityPerformance2 A
	where A.Period=B.Period and A.MoneyType=B.MoneyType and A.market=B.market  and A.mkt=b.mkt  and A.AUDI_des=B.AUDI_des and A.Productname=B.Productname
) and Market='Onglyza'
go
Alter table OutputPreCityPerformance2 add CurrRank int
go
update OutputPreCityPerformance2
set CurrRank=B.Rank from OutputPreCityPerformance2 A inner join(
select A.*,
dense_Rank ( )OVER (PARTITION BY Period,MoneyType,Market,mkt order by Share desc) as Rank from OutputPreCityPerformance2 A
where (Market in ('Baraclude','Glucophage') and Molecule='Y') or Market not in ('Baraclude','Glucophage')) B
on A.Period=B.Period and A.MoneyType=B.MoneyType and A.market=B.market  and A.mkt=b.mkt and a.mktname=B.mktname and A.AUDI_COD=B.AUDI_COD
go
update OutputPreCityPerformance2
set CurrRank=B.Rank from OutputPreCityPerformance2 A inner join(
select A.*,
dense_Rank ( )OVER (PARTITION BY Period,MoneyType,Market,mkt order by Share desc) as Rank from 
(
select Period, Moneytype, market, Molecule, Class, Mkt, MKtName,  Audi_cod, Audi_des, sum(Share) as Share
 from OutputPreCityPerformance2 where Market='Onglyza'
group by Period, Moneytype, market, Molecule, Class, Mkt, MKtName,  Audi_cod, Audi_des) A
) B
on A.Period=B.Period and A.MoneyType=B.MoneyType and A.market=B.market  and A.mkt=b.mkt and a.mktname=B.mktname and A.AUDI_COD=B.AUDI_COD
go
insert into OutputPreCityPerformance2
select A.[Period],A.Moneytype,A.market,A.Molecule,A.Class,A.Mkt,A.MKtName,A.Prod,A.ProductName+' Generics',A.Audi_cod,A.Audi_des,
A.Share-B.share,A.CurrRank
from OutputPreCityPerformance2 A 
inner join  OutputPreCityPerformance2 B
on A.Period=B.Period and A.MoneyType=B.MoneyType and A.Audi_cod=b.Audi_cod 
	and A.market=B.market and A.mkt=b.mkt and a.mktname=B.mktname 
	and A.market in ('Glucophage','Baraclude') and A.prod='010' and B.prod='100'
go
delete from OutputPreCityPerformance2 where molecule='Y' and productname not like '%Generics%'
go


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
inner join
	(select distinct mkt,mktname,Prod,Productname from tblMktDef_MRBIChina) B
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
set CurrRank=B.Rank 
from OutputPreHKAPIBrandPerformance A inner join
(select A.*, RANK ( )OVER (PARTITION BY Period,MoneyType,mkt,Market order by YTD00 desc ) as Rank 
 from OutputPreHKAPIBrandPerformance A) B
on A.Market=B.Market and A.[mkt]=B.[mkt] and A.MoneyType=B.MoneyType and A.period=B.period and A.[productname]=B.[productname]
go

insert into OutputPreHKAPIBrandPerformance
select Period,'USD',Market,mkt,MktName,Prod,Productname,YTD00*1.0/B.Rate,YTD12*1.0/B.Rate,Growth,CurrRank
from OutputPreHKAPIBrandPerformance, tblRate B

go

--delete OutputCityPerformance from OutputCityPerformance
--where audi_des in (select audi_des from tblNewCity where Active='N')
--delete OutputCityPerformance_BMS10TA from OutputCityPerformance_BMS10TA
--where audi_des in (select audi_des from tblNewCity where Active='N')
--delete OutputPreCityPerformance from OutputPreCityPerformance
--where audi_des in (select audi_des from tblNewCity where Active='N')
--delete OutputPreCityPerformance2 from OutputPreCityPerformance2
--where audi_des in (select audi_des from tblNewCity where Active='N')

exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','OutputKeyBrandPerformance',null,null

if exists (select * from dbo.sysobjects where id = object_id(N'OutputKeyBrandPerformance') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table OutputKeyBrandPerformance
go
declare @i int,@sql varchar(max),@sqlR varchar(max)
set @i=0
set @sql=''
set @sqlR=''
while (@i<=24)
begin
	set @sql=@sql+'
	case sum(A.MAT'+right('00'+cast(@i as varchar(2)),2)+') when 0 then null else sum(B.MAT'+right('00'+cast(@i as varchar(2)),2)+')*1.0/sum(A.MAT'+right('00'+cast(@i as varchar(2)),2)+') end as MAT'+right('00'+cast(@i as varchar(2)),2)+','
	set @i=@i+1
end
set @sqlR='
	select ''MAT'' as Period,B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname,'+
	left(@sql,len(@sql)-1)+' into OutputKeyBrandPerformance from TempCHPAPreReports A inner join TempCHPAPreReports B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
	and A.Market=B.Market and A.prod=''000'' and B.prod<>''000''
	where B.class=''N'' and B.Molecule=''N''
	group by B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname'
print @sqlR
exec (@sqlR)

set @i=0
set @sql=''
set @sqlR=''
while (@i<=24)
begin
set @sql=@sql+'
case sum(A.R3M'+right('00'+cast(@i as varchar(2)),2)+') when 0 then null else sum(B.R3M'+right('00'+cast(@i as varchar(2)),2)+')*1.0/sum(A.R3M'+right('00'+cast(@i as varchar(2)),2)+') end,'
set @i=@i+1
end
set @sqlR='insert into OutputKeyBrandPerformance
select ''MQT'' as Period,B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname,'+
left(@sql,len(@sql)-1)+' from TempCHPAPreReports A inner join TempCHPAPreReports B
on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
and A.Market=B.Market and A.prod=''000'' and B.prod<>''000''
where B.class=''N'' and B.Molecule=''N''
group by B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname'
print @sqlR
exec (@sqlR)

set @i=0
set @sql=''
set @sqlR=''
while (@i<=24)
begin
set @sql=@sql+'
case sum(A.MTH'+right('00'+cast(@i as varchar(2)),2)+') when 0 then null else sum(B.MTH'+right('00'+cast(@i as varchar(2)),2)+')*1.0/sum(A.MTH'+right('00'+cast(@i as varchar(2)),2)+') end,'
set @i=@i+1
end
set @sqlR='insert into OutputKeyBrandPerformance
select ''MTH'' as Period,B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname,'+
left(@sql,len(@sql)-1)+' from TempCHPAPreReports A inner join TempCHPAPreReports B
on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
and A.Market=B.Market and A.prod=''000'' and B.prod<>''000''
where B.class=''N'' and B.Molecule=''N''
group by B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname'
print @sqlR
exec (@sqlR)


set @i=0
set @sql=''
set @sqlR=''
while (@i<=24)
begin
set @sql=@sql+'
case sum(A.YTD'+right('00'+cast(@i as varchar(2)),2)+') when 0 then null else sum(B.YTD'+right('00'+cast(@i as varchar(2)),2)+')*1.0/sum(A.YTD'+right('00'+cast(@i as varchar(2)),2)+') end,'
set @i=@i+1
end
set @sqlR='insert into OutputKeyBrandPerformance
select ''YTD'' as Period,B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname,'+
left(@sql,len(@sql)-1)+' from TempCHPAPreReports A inner join TempCHPAPreReports B
on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
and A.Market=B.Market and A.prod=''000'' and B.prod<>''000''
where B.class=''N'' and B.Molecule=''N''
group by B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname'
print @sqlR
exec (@sqlR)
go
delete from OutputKeyBrandPerformance where Molecule='Y' or class='Y'
delete from OutputKeyBrandPerformance where mkt not in ('ARV','DPP4','HYP','ONCFCS','NIAD','Platinum','CCB')
go
--OutputKeyBrandPerformanceByRegion
--OutputKeyBrandPerformanceByRegionGrowth




------------------------------------------------
-- OutputKeyMoleculeBrandPerformance
------------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'OutputKeyMoleculeBrandPerformance') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table OutputKeyMoleculeBrandPerformance
go

select 'MQT' as timeframe,Molecule,Class,mkt,mktname,Market,Prod,Productname,Moneytype,
	sum(R3M00) as R3M00,sum(R3M01) as R3M01,sum(R3M02) as R3M02,
	sum(R3M03) as R3M03,sum(R3M04) as R3M04,sum(R3M05) as R3M05,
	sum(R3M06) as R3M06,sum(R3M07) as R3M07,sum(R3M08) as R3M08,
	sum(R3M09) as R3M09,sum(R3M10) as R3M10,sum(R3M11) as R3M11,sum(R3M12) as R3M12,
	cast(null as float) as CAGR 
	,cast(null as float) as MonthGrowth 
into OutputKeyMoleculeBrandPerformance 
from TempCHPAPreReports
where Market in ('baraclude','Taxol','Paraplatin') and class='N' and Productname not like '%Other%' and Prod<>'000'
group by Molecule,Class,mkt,mktname,Market,Prod,Productname,Moneytype
go 
insert into OutputKeyMoleculeBrandPerformance 
select 'MTH' as timeframe,Molecule,Class,mkt,mktname,Market,Prod,Productname,Moneytype,
sum(MTH00),sum(MTH01),sum(MTH02),
sum(MTH03),sum(MTH04),sum(MTH05),
sum(MTH06),sum(MTH07),sum(MTH08),
sum(MTH09),sum(MTH10),sum(MTH11),sum(MTH12),
cast(null as float) as CAGR 
,cast(null as float) as MonthGrowth 
from TempCHPAPreReports
where Market in ('baraclude','Taxol','Paraplatin') and class='N' and Productname not like '%Other%' and Prod<>'000'
group by Molecule,Class,mkt,mktname,Market,Prod,Productname,Moneytype
go
insert into OutputKeyMoleculeBrandPerformance 
select 'MAT' as timeframe,Molecule,Class,mkt,mktname,Market,Prod,Productname,Moneytype,
sum(MAT00) as MAT00,sum(MAT12) as MAT12,sum(MAT24) as MAT24,sum(MAT36) as MAT36,sum(MAT48) as MAT48,0,0,0,0,0,0,0,0,
 cast(null as float) as CAGR,cast(null as float) as MonthGrowth 
from TempCHPAPreReports
where Market in ('baraclude','Taxol','Paraplatin') and class='N' and Productname not like '%Other%' and Prod<>'000'
group by Molecule,Class,mkt,mktname,Market,Prod,Productname,Moneytype
go
insert into OutputKeyMoleculeBrandPerformance 
select 'YTD' as timeframe,Molecule,Class,mkt,mktname,Market,Prod,Productname,Moneytype,
sum(YTD00) as YTD00,sum(YTD12) as YTD12,sum(YTD24) as YTD24,sum(YTD36) as YTD36,sum(YTD48) as YTD48,0,0,0,0,0,0,0,0,
 cast(null as float) as CAGR,cast(null as float) as MonthGrowth 
from TempCHPAPreReports
where Market in ('baraclude','Taxol','Paraplatin') and class='N' and Productname not like '%Other%' and Prod<>'000'
group by Molecule,Class,mkt,mktname,Market,Prod,Productname,Moneytype
go


update OutputKeyMoleculeBrandPerformance set CAGR= 
case R3M01 when 0 then 0 
           else case R3M02 when 0 then Power((R3M00/R3M01),1.0/1)-1
                           else case R3M03 when 0 then Power((R3M00/R3M02),1.0/2)-1
                                           else case R3M04 when 0 then Power((R3M00/R3M03),1.0/3)-1
                                                           else Power((R3M00/R3M04),1.0/4)-1 
                                                           end 
                                           end 
                            end 
           end 
where timeframe in('MAT', 'YTD')
go

update OutputKeyMoleculeBrandPerformance
set CAGR = case R3M11 when 0 then 0 else Power((R3M00/R3M11),1.0/11)-1 end 
where timeframe in ('MQT')

update OutputKeyMoleculeBrandPerformance
set CAGR = case R3M11 when 0 then 0 else R3M00/R3M11-1 end 
where timeframe in ('MTH')

update OutputKeyMoleculeBrandPerformance
set MonthGrowth = case R3M01 when 0 then 0 else R3M00/R3M01-1 end 


--select * from OutputKeyMoleculeBrandPerformance

-- declare @i int, @min int,@max int,@sql varchar(max),@sqlR varchar(max)
-- set @min=(select min(Monseq-1) from tblmonthlist where quarter%3=0)
-- set @i=(select min(Monseq-1) from tblmonthlist where quarter%3=0)
-- set @max=(select min(Monseq-1+36) from tblmonthlist where quarter%3=0)
-- set @sql=''
-- set @sqlR=''
-- while (@i<=@max)
-- begin
-- set @sql=@sql+'
-- sum(MAT'+right('00'+cast(@i as varchar(2)),2)+') as MAT'+right('00'+cast(@i as varchar(2)),2)+','
-- set @i=@i+12
-- end
-- set @sqlR='insert into OutputKeyMoleculeBrandPerformance
-- select ''MAT'' as Timeframe,Molecule,Class,mkt,mktname,Market,Prod,Productname,Moneytype,'+
-- @sql+'cast(null as float) as CAGR  from TempCHPAPreReports
-- where Market in (''baraclude'',''Taxol'') and class=''N'' and Productname not like ''%Other%'' and Prod<>''000''
-- group by Molecule,Class,mkt,mktname,Market,Prod,Productname,Moneytype'
-- print @sqlR
-- exec (@sqlR)


-- go
-- declare @i int, @min int,@max int,@sql varchar(max),@sqlR varchar(max)
-- set @min=(select min(Monseq-1) from tblmonthlist where quarter%3=0)
-- set @i=(select min(Monseq-1) from tblmonthlist where quarter%3=0)
-- set @max=(select min(Monseq-1+36) from tblmonthlist where quarter%3=0)
-- set @sql=''
-- set @sqlR=''
-- while (@i<=@max)
-- begin
-- set @sql=@sql+'
-- sum(R3M'+right('00'+cast(@i as varchar(2)),2)+') as MQT'+right('00'+cast(@i as varchar(2)),2)+','
-- set @i=@i+12
-- end
-- set @sqlR='insert into OutputKeyMoleculeBrandPerformance 
-- select ''MQT'' as Timeframe,Molecule,Class,mkt,mktname,Market,Prod,Productname,Moneytype,'+
-- @sql+'cast(null as float) as CAGR  from TempCHPAPreReports
-- where Market in (''baraclude'',''Taxol'') and class=''N'' and Productname not like ''%Other%'' and Prod<>''000''
-- group by Molecule,Class,mkt,mktname,Market,Prod,Productname,Moneytype'
-- print @sqlR
-- exec (@sqlR)

-- set @sqlR='
-- update OutputKeyMoleculeBrandPerformance
-- set CAGR=case MAT'+right('00'+cast(@max-12 as varchar(2)),2)+' when 0 then 
-- Power((MAT'+right('00'+cast(@min as varchar(2)),2)+'/MAT'+right('00'+cast(@max-24 as varchar(2)),2)+'),1.0/1)-1
-- else
-- case MAT'+right('00'+cast(@max as varchar(2)),2)+' when 0 then 
-- Power((MAT'+right('00'+cast(@min as varchar(2)),2)+'/MAT'+right('00'+cast(@max-12 as varchar(2)),2)+'),1.0/2)-1
-- else Power((MAT'+right('00'+cast(@min as varchar(2)),2)+'/MAT'+right('00'+cast(@max as varchar(2)),2)+'),1.0/3)-1 end end '
-- print @sqlR
-- exec (@sqlR)
-- go




if exists (select * from dbo.sysobjects where id = object_id(N'OutputBrandvGene') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table OutputBrandvGene
go
select Moneytype,Market,CAST(case MNFL_cod when 'L' then 'LOCAL' else 'MNC' end AS varchar(20)) as MNFL_cod ,
	case MNFL_cod when 'L' then 2 else 1 end as MNFLIdx,
	sum(MAT00) as MAT00,
	sum(MAT12) as MAT12,
	sum(MAT24) as MAT24,
	sum(MAT36) as MAT36,
	sum(MAT48) as MAT48,
	sum(YTD00) as YTD00,
	sum(YTD12) as YTD12,
	sum(YTD24) as YTD24,
	sum(YTD36) as YTD36,
	sum(YTD48) as YTD48
into OutputBrandvGene
from TempCHPAPreReportsByMNC 
where Prod in('000') and 
	((Class='N' and molecule='N' and mkt in ('ARV','NIAD','ONCFCS','Platinum','CCB')) or (Class='Y' and mkt='Hyp'))
group by Moneytype,Market,case MNFL_cod when 'L' then 'LOCAL' else 'MNC' end,case MNFL_cod when 'L' then 2 else 1 end
go
--keep all records
insert into OutputBrandvGene
select A.*,0,0,0,0,0,0,0,0,0,0 
from (
select *from 
	(select distinct Moneytype,market from OutputBrandvGene) A,
	(select distinct MNFL_COD,MNFLIdx from OutputBrandvGene) B
) A 
where not exists(
	select * from OutputBrandvGene B
	where A.Moneytype=B.Moneytype and A.Market=B.Market and A.MNFL_COD=B.MNFL_COD and A.MNFLIdx=B.MNFLIdx)
go
insert into OutputBrandvGene
select Moneytype,Market,MNFL_cod+' GR',MNFLIdx*10,
	case Mat12 when 0 then case Mat00 when 0 then 0 else null end else (Mat00-Mat12)*1.0/Mat12 end,
	case Mat24 when 0 then case Mat12 when 0 then 0 else null end else (Mat12-Mat24)*1.0/Mat24 end,
	case Mat36 when 0 then case Mat24 when 0 then 0 else null end else (Mat24-Mat36)*1.0/Mat36 end,
	case Mat48 when 0 then case Mat36 when 0 then 0 else null end else (Mat36-Mat48)*1.0/Mat48 end,null,
	case YTD12 when 0 then case YTD00 when 0 then 0 else null end else (YTD00-YTD12)*1.0/YTD12 end,
	case YTD24 when 0 then case YTD12 when 0 then 0 else null end else (YTD12-YTD24)*1.0/YTD24 end,
	case YTD36 when 0 then case YTD24 when 0 then 0 else null end else (YTD24-YTD36)*1.0/YTD36 end,
	case YTD48 when 0 then case YTD36 when 0 then 0 else null end else (YTD36-YTD48)*1.0/YTD48 end,null
from OutputBrandvGene
--select * from TempCHPAPreReports
go


if exists (select * from dbo.sysobjects where id = object_id(N'TempOutputBrandvGeneRight') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table TempOutputBrandvGeneRight
go
select Moneytype,Market,cast('Total' as varchar(30)) as MNFL_COD,1 as MNFLIdx,
	sum(MAT00) as MAT00,sum(MAT12) as MAT12,sum(MAT24) as MAT24,sum(MAT36) as MAT36,sum(MAT48) as MAT48,
	sum(YTD00) as YTD00,sum(YTD12) as YTD12,sum(YTD24) as YTD24,sum(YTD36) as YTD36,sum(YTD48) as YTD48,
	cast(null as float) Growth,cast(null as float) CAGR, cast(null as float) YTDGrowth,cast(null as float) YTDCAGR
into TempOutputBrandvGeneRight from OutputBrandvGene
where MNFLIdx<3
group by Moneytype,Market
go
insert into TempOutputBrandvGeneRight
select A.*,null,null,null,null from OutputBrandvGene A where MNFLIdx<3
go
update TempOutputBrandvGeneRight
set Growth=case MAT12 when 0 then null else (MAT00-MAT12)/MAT12 end
go
update TempOutputBrandvGeneRight
set CAGR=case MAT12 
		when 0 then 0 
		else
			case MAT24 when 0 then Power((MAT00/MAT12),1.0/1)-1
			else
				case MAT36 when 0 then Power((MAT00/MAT24),1.0/2)-1
				else 
					case MAT48 when 0 then Power((MAT00/MAT36),1.0/3)-1
					else Power((MAT00/MAT48),1.0/4)-1 
					end 
				end 
			end 
		end

update TempOutputBrandvGeneRight
set YTDGrowth=case YTD12 when 0 then null else (YTD00-YTD12)/YTD12 end
go
update TempOutputBrandvGeneRight
set YTDCAGR=case YTD12 when 0 then 0 
			else
				case YTD24 when 0 then Power((YTD00/YTD12),1.0/1)-1
				else
					case YTD36 when 0 then Power((YTD00/YTD24),1.0/2)-1
					else 
						case YTD48 when 0 then Power((YTD00/YTD36),1.0/3)-1
						else Power((YTD00/YTD48),1.0/4)-1 
						end
					end 
				end 
			end

go
if exists (select * from dbo.sysobjects where id = object_id(N'OutputBrandvGeneRight') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputBrandvGeneRight
go
select 'MAT' as Period, Moneytype,Market,MNFL_COD,MNFLIdx*4 as MNFLIdx,MAT00
into OutputBrandvGeneRight from TempOutputBrandvGeneRight
order by market,Moneytype
go
insert into OutputBrandvGeneRight
select 'MAT' as Period,Moneytype,Market,MNFL_COD+' CAGR',MNFLIdx*4+1,CAGR from TempOutputBrandvGeneRight
order by market,Moneytype
go
insert into OutputBrandvGeneRight
select distinct 'MAT' as Period, Moneytype,Market,'Title',1,null from TempOutputBrandvGeneRight
order by market,Moneytype
go
insert into OutputBrandvGeneRight
select 'MAT' as Period,A.Moneytype,A.market,B.Productname,1000,case A.MAT00 when 0 then 0 else B.MAT00/A.MAT00 end
from 
(	select * from TempCHPAPreReports 
	where Prod in('000') and 
		((Class='N' and molecule='N' and mkt in ('ARV','NIAD','ONCFCS','Platinum','CCB')) or (Class='Y' and mkt='Hyp'))
) A
inner join
(	select * from TempCHPAPreReports 
	where Prod in('100') and Class='N' and molecule='N'
		and mkt in ('ARV','NIAD','HYP','ONCFCS','Platinum','CCB')
) B
on a.Market=b.Market and a.Moneytype=b.moneytype
go

insert into OutputBrandvGeneRight
select 'YTD' as Period, Moneytype,Market,MNFL_COD,MNFLIdx*4 as MNFLIdx,YTD00
from TempOutputBrandvGeneRight
order by market,Moneytype
go
insert into OutputBrandvGeneRight
select 'YTD' as Period,Moneytype,Market,MNFL_COD+' CAGR',MNFLIdx*4+1,CAGR from TempOutputBrandvGeneRight
order by market,Moneytype
go
insert into OutputBrandvGeneRight
select distinct'YTD' as Period, Moneytype,Market,'Title',1,null from TempOutputBrandvGeneRight
order by market,Moneytype
go
insert into OutputBrandvGeneRight
select 'YTD' as Period,A.Moneytype,A.market,B.Productname,1000,case A.YTD00 when 0 then 0 else B.YTD00/A.YTD00 end
from 
(select * from TempCHPAPreReports where Prod in('000') and 
((Class='N' and molecule='N' and mkt in ('ARV','NIAD','ONCFCS','Platinum','CCB')) or (Class='Y' and mkt='Hyp'))
) A
inner join
(select * from TempCHPAPreReports where Prod in('100') and Class='N' and molecule='N'
and mkt in ('ARV','NIAD','HYP','ONCFCS','Platinum','CCB')) B
on a.Market=b.Market and a.Moneytype=b.moneytype
go

update OutputBrandvGeneRight
set MNFLIdx=2 where MNFL_Cod='Total'
update OutputBrandvGeneRight
set MNFLIdx=3 where MNFL_Cod='Total CAGR'
go
alter table OutputBrandvGeneRight
add series varchar(100),Y varchar(50)
go
update OutputBrandvGeneRight
set series= 
case MNFL_cod when 'Title' then 'Facts about the #MKT Market'
when 'Total' then '#MKT market size - sales value (#Time)' 
when 'Total CAGR' then '#MKT market growth, 5 years CAGR (#CAGR)' 
when 'MNC' then 'MNC sales value (#Time)' 
when 'MNC CAGR' then 'MNC market growth, 5 years CAGR (#CAGR)'
when 'LOCAL' then 'Local sales value (#Time)' 
when 'LOCAL CAGR' then 'Local market growth, 5 years CAGR (#CAGR)'
else MNFL_cod end

go
update OutputBrandvGeneRight
set series=replace(series,'#MKT',case Market when 'Baraclude' then 'ARV' when 'Glucophage' then 'NIAD' when 'Taxol' then 'Taxol'
when 'Monopril' then 'HPN' else market end)

update OutputBrandvGeneRight
set series=replace(series,'#Time','' + Period + ' '+(select right(year,2)+'/'+right(Date,2) from tblmonthlist where Monseq=1))

update OutputBrandvGeneRight
set series=replace(series,'#CAGR','' + Period + ' '+(select right(year,2)+'/'+right(Date,2) from tblmonthlist where Monseq=49)+'-'+(select right(year,2)+'/'+right(date,2) from tblmonthlist where Monseq=1))
go
update OutputBrandvGeneRight
set series= series+ ' (' + Period + ' '+(select right(year,2)+'/'+right(date,2) from tblmonthlist where Monseq=1)
+') has a market share of '+ cast(cast(mat00*100 as decimal(22,1)) as varchar(20))+'%' where MNFLIdx=1000
go
update OutputBrandvGeneRight
set Y=cast(cast(mat00*100 as decimal(22,1)) as varchar(20))+'%' where MNFL_cod like '%CAGR%'

update OutputBrandvGeneRight
set Y=cast(cast(MAT00/
(case 
when cast(mat00 as float) between 5000 and 1000000000 then 1000000
when cast(mat00 as float) > 1000000000 then 1000000000 else 1 end ) as decimal(22,2)) as varchar(10))+
case 
when cast(mat00 as float) between 5000 and 1000000000 then ' mio.'
when cast(mat00 as float) > 1000000000 then ' bn.' else '' end
where MNFL_Cod in ('MNC','LOCAL','Total')

--
--Baraclude (by molecule): Entecavir / Adefovir Dipivoxil / Lamivudine / Telbivudine
--Glucophage (by class): AGI / BI / DDP-IV / GLIN / GLP1 / SU / TZD
--Monopril (by class): ACEI / ARB / BB / CCB
--Taxol (by molecule): Gemcitabine / Docetaxel / Paclitaxel

if exists (select * from dbo.sysobjects where id = object_id(N'OutputBrandvGenebyClass') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table OutputBrandvGenebyClass
go
select Moneytype,Molecule,Class,Market,Prod,Productname,CAST('Total' AS varchar(20)) as MNFL_cod ,
10 as MNFLIdx,
sum(MAT00) as MAT00,
sum(MAT12) as MAT12,
sum(MAT24) as MAT24,
sum(MAT36) as MAT36,
sum(MAT48) as MAT48,
sum(YTD00) as YTD00,
sum(YTD12) as YTD12,
sum(YTD24) as YTD24,
sum(YTD36) as YTD36,
sum(YTD48) as YTD48
into OutputBrandvGenebyClass
from TempCHPAPreReports 
where Prod<>'000' and Productname not like '%other%' and 
((Class='Y' and mkt in ('NIAD','HYP')) or (molecule='Y' and mkt in ('ARV','ONCFCS','Platinum')))
--and mkt in ('ARV','NIAD','HYP','DPP4','ONCFCS')
group by Moneytype,Molecule,Class,Market,Prod,Productname
go
delete from OutputBrandvGenebyClass where Productname like '%other%'
go
insert into OutputBrandvGenebyClass
select B.Moneytype,B.Molecule,B.Class,B.Market,B.Prod,B.Productname,
	B.MNFL_COD,B.MNFLIdx,
	case A.Mat00 when 0 then 0 else B.Mat00*1.0/A.Mat00 end,
	case A.Mat12 when 0 then 0 else B.Mat12*1.0/A.Mat12 end,
	case A.Mat24 when 0 then 0 else B.Mat24*1.0/A.Mat24 end,
	case A.Mat36 when 0 then 0 else B.Mat36*1.0/A.Mat36 end,
	case A.Mat48 when 0 then 0 else B.Mat48*1.0/A.Mat48 end,
	case A.YTD00 when 0 then 0 else B.YTD00*1.0/A.YTD00 end,
	case A.YTD12 when 0 then 0 else B.YTD12*1.0/A.YTD12 end,
	case A.YTD24 when 0 then 0 else B.YTD24*1.0/A.YTD24 end,
	case A.YTD36 when 0 then 0 else B.YTD36*1.0/A.YTD36 end,
	case A.YTD48 when 0 then 0 else B.YTD48*1.0/A.YTD48 end
from OutputBrandvGenebyClass A 
inner join 
(
	select Moneytype,Molecule,Class,Market,Prod,Productname,CAST(case MNFL_cod when 'L' then 'LOCAL' else 'MNC' end AS varchar(20)) as MNFL_cod ,
		case MNFL_cod when 'L' then 2 else 1 end as MNFLIdx,
		sum(MAT00) as MAT00,
		sum(MAT12) as MAT12,
		sum(MAT24) as MAT24,
		sum(MAT36) as MAT36,
		sum(MAT48) as MAT48,
		sum(YTD00) as YTD00,
		sum(YTD12) as YTD12,
		sum(YTD24) as YTD24,
		sum(YTD36) as YTD36,
		sum(YTD48) as YTD48
	from TempCHPAPreReportsByMNC 
	where Prod<>'000' and Productname not like '%other%' and 
		((Class='Y' and mkt in ('NIAD','HYP')) or (molecule='Y' and mkt in ('ARV','ONCFCS','Platinum')))
		--and mkt in ('ARV','NIAD','HYP','DPP4','ONCFCS')
	group by Moneytype,Molecule,Class,Market,Prod,Productname,case MNFL_cod when 'L' then 'LOCAL' else 'MNC' end,case MNFL_cod when 'L' then 2 else 1 end
) B
on A.Moneytype=B.Moneytype and A.Molecule=B.Molecule and A.Class=B.Class and A.Market=B.Market
	and A.Prod=B.Prod and A.Productname=B.Productname
go
update OutputBrandvGenebyClass
set MNFL_Cod=case MNFL_Cod when 'MNC' then 'Brand' when 'LOCAL' then 'Generic' else MNFL_Cod end
go
--select * from OutputBrandvGenebyClass


-- if exists (select * from dbo.sysobjects where id = object_id(N'OutputBrandvGenebyClassTable') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
-- drop table OutputBrandvGenebyClassTable
-- go
-- select B.Moneytype,B.Molecule,B.Class,B.Market,B.Prod,B.Productname,
-- CAST(case MNFL_cod when 'L' then 'LOCAL' else 'MNC' end AS varchar(20)) as MNFL_cod,
-- sum(MAT00) as MAT00,sum(MAT12) as MAT12,sum(MAT24) as MAT24,sum(MAT36) as MAT36,sum(MAT48) as MAT48,cast(null as float) as CAGR
-- into OutputBrandvGenebyClassTable
-- from TempCHPAPreReports B where Prod='000' and Class='N' and molecule='N'
-- and mkt in ('ARV','NIAD','HYP','DPP4','ONCFCS')
-- group by B.Moneytype,B.Molecule,B.Class,B.Market,B.Prod,B.Productname,
-- CAST(case MNFL_cod when 'L' then 'LOCAL' else 'MNC' end AS varchar(20))
-- go
-- update OutputBrandvGenebyClassTable
-- set CAGR=case MAT36 when 0 then Power((MAT00/MAT24),1.0/2)-1  
-- else
-- case MAT48 when 0 then 
-- Power((MAT00/MAT36),1.0/3)-1
-- else Power((MAT00/MAT48),1.0/4)-1 end end 
-- select * from OutputBrandvGenebyClassTable
-- go

if exists (select * from dbo.sysobjects where id = object_id(N'OutputKeyMarketPerfByCity') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table OutputKeyMarketPerfByCity
go
select Molecule,Class,mkt,mktname,Market,Prod,Productname,Moneytype,Audi_cod,audi_des,
cast(null as int) as Tier,
RANK ( )OVER (PARTITION BY Molecule,Class,mkt,market,Moneytype order by MAT00 desc ) as RankMAT,
RANK ( )OVER (PARTITION BY Molecule,Class,mkt,market,Moneytype order by R3M00 desc ) as RankMQT,
RANK ( )OVER (PARTITION BY Molecule,Class,mkt,market,Moneytype order by YTD00 desc ) as RankYTD,
MAT00,R3M00,YTD00
into OutputKeyMarketPerfByCity from TempCityDashboard_forPre where Prod='000' and 
((Class='Y' and mkt in ('NIAD','HYP')) or (molecule='Y' and mkt in ('ARV','ONCFCS','Platinum')))
go
insert into OutputKeyMarketPerfByCity
select A.Molecule,A.Class,A.mkt,A.mktname,A.Market,A.Prod,A.productname,A.Moneytype,A.Audi_cod,A.audi_des,cast(null as int) as Tier,
null,null,NULL,
case B.MAT00 when 0 then 0 else A.MAT00*1.0/B.MAT00 end as MarketShareMAT,
case B.R3M00 when 0 then 0 else A.R3M00*1.0/B.R3M00 end as MarketShareMQT,
case B.YTD00 when 0 then 0 else A.YTD00*1.0/B.YTD00 end as MarketShareYTD
from TempCityDashboard_forPre A inner join TempCityDashboard_forPre B
on a.Molecule=B.Molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod 
where  A.Prod<>'000' and A.Productname not like '%other%' and 
((A.Class='Y' and A.mkt in ('NIAD','HYP')) or (A.molecule='Y' and A.mkt in ('ARV','ONCFCS','Platinum'))) and B.Prod='000' 
go
update OutputKeyMarketPerfByCity
set Tier=B.Tier from OutputKeyMarketPerfByCity A 
inner join tblCityMax B
on A.Audi_cod= B.CIty
go
update OutputKeyMarketPerfByCity
set RankMAT=B.RankMAT,
RankMQT=B.RankMQT from OutputKeyMarketPerfByCity A inner join 
                (select * from OutputKeyMarketPerfByCity where Prod='000') B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod 
where A.prod<>'000'
go
update OutputKeyMarketPerfByCity
set Productname=Productname+' Contrib.' where Prod<>'000'
go
update OutputKeyMarketPerfByCity
set Productname=replace(Productname,'Hypertension Market','HPN Market')+' Value' where Prod='000'
go
--select * from OutputKeyMarketPerfByCity
if exists (select * from dbo.sysobjects where id = object_id(N'OutputKeyBrandPerfByCity') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputKeyBrandPerfByCity
go
select A.Molecule,A.Class,A.mkt,A.mktname,A.Market,A.Prod,A.productname,A.Moneytype,A.Audi_cod,A.audi_des,
	cast(null as int) as Tier,cast(null as int) as RankMAT,cast(null as int) as RankMQT,
	A.MAT00,A.R3M00,A.YTD00,
	case B.MAT00 when 0 then 0 else A.MAT00*1.0/B.MAT00 end as MarketShareMAT,
	case B.R3M00 when 0 then 0 else A.R3M00*1.0/B.R3M00 end as MarketShareMQT,
	case B.R3M00 when 0 then 0 else A.YTD00*1.0/B.YTD00 end as MarketShareYTD
into OutputKeyBrandPerfByCity
from TempCityDashboard_forPre A 
inner join TempCityDashboard_forPre B
on a.Molecule=B.Molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod 
where A.Molecule='N' and A.class='N' and A.mkt in ('ARV','NIAD','HYP','ONCFCS','Platinum','CCB')
	and A.Prod<>'000' and B.Prod='000' 
go

-- insert into OutputKeyBrandPerfByCity
-- select A.Molecule,A.Class,A.mkt,A.mktname,A.Market,B.Prod,B.productname,A.Moneytype,A.Audi_cod,A.audi_des,
-- null,null,null,0,0
--  from 
-- (select distinct  Molecule,Class,mkt,mktname,Market,Moneytype,
-- Audi_cod,audi_des,tier
-- from OutputKeyBrandPerfByCity) A inner join
-- (select distinct  Molecule,Class,mkt,mktname,Market,Moneytype,
-- Prod,productname
-- from OutputKeyBrandPerfByCity) B
-- on a.Molecule=B.Molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
-- and a.Moneytype=b.Moneytype 
-- and not exists(select * from OutputKeyBrandPerfByCity C
-- where a.Molecule=C.Molecule and A.Class=C.Class and a.mkt=C.mkt and a.market=C.market
-- and a.Moneytype=C.Moneytype and B.Productname=C.Productname and a.audi_cod=C.audi_cod)
-- -- and  a.market='Taxol' and a.audi_cod='LYH_'

go
update OutputKeyBrandPerfByCity
set Tier=B.Tier 
from OutputKeyBrandPerfByCity A 
inner join tblCityMax B
on A.Audi_cod=B.CIty
go
update OutputKeyBrandPerfByCity
set RankMAT=B.Rank
from OutputKeyBrandPerfByCity A 
inner join (
	select A.*,RANK ( )OVER (PARTITION BY Molecule,Class,mkt,market,Moneytype,case when tier in (1,2) then 1 else 3 end order by MAT00 desc,audi_des ) as Rank
	from OutputKeyBrandPerfByCity A where Prod='100'
) B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and A.Prod='100'
go
update OutputKeyBrandPerfByCity
set RankMQT=B.Rank
from OutputKeyBrandPerfByCity A 
inner join (
	select A.*,RANK ( )OVER (PARTITION BY Molecule,Class,mkt,market,Moneytype,case when tier in (1,2) then 1 else 3 end order by R3M00 desc, audi_des) as Rank
	from OutputKeyBrandPerfByCity A where Prod='100'
) B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and A.Prod='100'
go
update OutputKeyBrandPerfByCity
set RankMAT=B.RankMAT,
	RankMQT=B.RankMQT 
from OutputKeyBrandPerfByCity A 
inner join (select * from OutputKeyBrandPerfByCity where Prod='100') B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod 
where A.prod<>'100'
go


if exists (select * from dbo.sysobjects where id = object_id(N'OutputCityCumShare') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputCityCumShare
go

select A.Molecule,A.Class,A.mkt,A.mktname,A.Market,A.Prod,A.productname,A.Moneytype,
	A.Audi_cod,A.audi_des,cast(null as int) as Tier,
	cast(null as int) as RankMAT, sum(isnull(MAT00,0)) as MAT00, cast(null as float) as MATShare,
	cast(null as int) as RankYTD, sum(isnull(YTD00,0)) as YTD00, cast(null as float) as YTDShare
into OutputCityCumShare
from TempCityDashboard_forPre A 
where A.Molecule='N' and A.class='N' and A.mkt in ('ARV','NIAD','HYP','ONCFCS','Platinum','CCB') and Prod<>'000'
group by  A.Molecule,A.Class,A.mkt,A.mktname,A.Market,A.Prod,A.productname,A.Moneytype,
	A.Audi_cod,A.audi_des
go
update OutputCityCumShare
set Tier=B.Tier 
from OutputCityCumShare A 
inner join tblCityMax B
on A.Audi_cod=B.CIty
go
update OutputCityCumShare
set RankMAT=B.Rank
from OutputCityCumShare A 
inner join (
	select A.*,RANK ( )OVER (PARTITION BY Molecule,Class,mkt,market,Moneytype order by MAT00 desc,audi_des ) as Rank
	from OutputCityCumShare A where Prod='100'
) B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and A.Prod='100'
go
update OutputCityCumShare
set RankMAT=B.RankMAT 
from OutputCityCumShare A 
inner join (select * from OutputCityCumShare where Prod='100') B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod 
where A.prod<>'100'
go
update OutputCityCumShare
set RankYTD=B.Rank
from OutputCityCumShare A inner join (
	select A.*,RANK ( )OVER (PARTITION BY Molecule,Class,mkt,market,Moneytype order by YTD00 desc,audi_des ) as Rank
	from OutputCityCumShare A where Prod='100') B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and A.Prod='100'
go
update OutputCityCumShare
set RankYTD=B.RankYTD 
from OutputCityCumShare A 
inner join (select * from OutputCityCumShare where Prod='100') B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod 
where A.prod<>'100'
go

--select * from OutputCityCumShare where market='baraclude' and prod='200' and moneytype='us' order by rankmat
update OutputCityCumShare
set MATShare=case B.MAT00 when 0 then 0 else A.MAT00/B.MAT00 end 
from OutputCityCumShare A 
inner join 
(	select Molecule,class,mkt,mktname,market,Prod,Productname,Moneytype,sum(MAT00) as MAT00 from OutputCityCumShare
	group by Molecule,class,mkt,mktname,market,Prod,Productname,Moneytype) B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.Prod=b.Prod
go
update OutputCityCumShare
set YTDShare=case B.YTD00 when 0 then 0 else A.YTD00/B.YTD00 end 
from OutputCityCumShare A 
inner join 
   (select Molecule,class,mkt,mktname,market,Prod,Productname,Moneytype,sum(YTD00) as YTD00 from OutputCityCumShare
     group by Molecule,class,mkt,mktname,market,Prod,Productname,Moneytype) B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.Prod=b.Prod
go

Alter table OutputCityCumShare
add [CumShareMAT] float, [CumShareYTD] float
go
update OutputCityCumShare
set [CumShareMAT]  =  MATShare
where RankMAT=1
go
update OutputCityCumShare
set [CumShareYTD]  =  YTDShare
where RankYTD=1
go
Declare @idx int
set @idx=1
while @idx <=(select max(RankMAT) from OutputCityCumShare)-1
begin
	update OutputCityCumShare
	set [CumShareMAT] = a.[CumShareMAT]+OutputCityCumShare.[MATShare]
	from (select * from OutputCityCumShare where RankMAT = @idx)A
	where a.Molecule=OutputCityCumShare.Molecule and a.Class=OutputCityCumShare.Class  
		and a.Market=OutputCityCumShare.Market and a.mkt=OutputCityCumShare.mkt
		and a.Moneytype=OutputCityCumShare.Moneytype and a.Productname=OutputCityCumShare.Productname
		and OutputCityCumShare.RankMAT =@idx+1

	update OutputCityCumShare
	set [CumShareYTD] = a.[CumShareYTD]+OutputCityCumShare.[YTDShare]
	from (select * from OutputCityCumShare where RankYTD = @idx)A
	where a.Molecule=OutputCityCumShare.Molecule and a.Class=OutputCityCumShare.Class  
		and a.Market=OutputCityCumShare.Market and a.mkt=OutputCityCumShare.mkt
		and a.Moneytype=OutputCityCumShare.Moneytype and a.Productname=OutputCityCumShare.Productname
		and OutputCityCumShare.RankYTD =@idx+1

Set @idx=@idx+1
end
go


if exists (select * from dbo.sysobjects where id = object_id(N'TempOutputEIByCity') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table TempOutputEIByCity
go
select A.Molecule,A.Class,A.mkt,A.mktname,A.Market,A.Prod,A.productname,A.Moneytype,
	A.Audi_cod,A.audi_des,
	case MAT12 when 0 then null else (MAT00-MAT12)*1.0/MAT12 end as MAT00Growth,
	case R3M12 when 0 then null else (R3M00-R3M12)*1.0/R3M12 end as MQT00Growth,
	case YTD12 when 0 then null else (YTD00-YTD12)*1.0/YTD12 end as YTD00Growth
into TempOutputEIByCity
from TempCityDashboard_forPre A 
where A.Molecule='N' and A.class='N' and A.mkt in ('ARV','NIAD','HYP','ONCFCS','Platinum','CCB')
go


if exists (select * from dbo.sysobjects where id = object_id(N'OutputEIByCity') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputEIByCity
go
select A.Molecule,A.Class,A.mkt,A.mktname,A.Market,A.Prod,A.productname,A.Moneytype,
	A.Audi_cod,A.audi_des,
	case when B.MAT00Growth = -1 then null else (1+A.MAT00Growth)*1.0/(1+B.MAT00Growth)*100 end as EIMAT,
	case when B.MQT00Growth = -1 then null else (1+A.MQT00Growth)*1.0/(1+B.MQT00Growth)*100 end as EIMQT,
	case when B.YTD00Growth = -1 then null else (1+A.YTD00Growth)*1.0/(1+B.YTD00Growth)*100 end as EIYTD,
	cast(null as int) as Tier,cast(null as int) as RankMAT,cast(null as int) as RankMQT,cast(null as int) as RankYTD
into OutputEIByCity
from TempOutputEIByCity A inner join TempOutputEIByCity B
on B.Prod='000' and A.Prod<>'000'
	and a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod
go
update OutputEIByCity
set Tier=B.Tier 
from OutputEIByCity A 
inner join tblCityMax B
on A.Audi_cod=B.CIty
go
update OutputEIByCity
set RankMAT=B.Rank
from OutputEIByCity A 
inner join 
( 	select A.*,RANK ( )OVER (PARTITION BY Molecule,Class,mkt,market,Moneytype order by EIMAT desc,audi_des ) as Rank
	from OutputEIByCity A where Prod='100') B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and A.Prod='100'
go
update OutputEIByCity
set RankMQT=B.Rank
from OutputEIByCity A 
inner join 
(	select A.*,RANK ( )OVER (PARTITION BY Molecule,Class,mkt,market,Moneytype order by EIMQT desc,audi_des  ) as Rank
	from OutputEIByCity A where Prod='100') B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and A.Prod='100'
go
update OutputEIByCity
set RankYTD=B.Rank
from OutputEIByCity A 
inner join (
	select A.*,RANK ( )OVER (PARTITION BY Molecule,Class,mkt,market,Moneytype order by EIYTD desc,audi_des  ) as Rank
	from OutputEIByCity A where Prod='100') B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and A.Prod='100'
go
update OutputEIByCity
set RankMAT=B.RankMAT,
	RankMQT=B.RankMQT,
	RankYTD=B.RankYTD 
from OutputEIByCity A 
inner join (select * from OutputEIByCity where Prod='100') B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod 
where A.prod<>'100'
go

if exists (select * from dbo.sysobjects where id = object_id(N'OutputBrandShareByCity') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputBrandShareByCity
go
select A.Molecule,A.Class,A.mkt,A.mktname,A.Market,A.Prod,A.productname,A.Moneytype,
	A.Audi_cod,A.audi_des,
	case B.MAT00 when 0 then 0 else A.MAT00/B.MAT00*100 end as MATShare,
	case B.R3M00 when 0 then 0 else A.R3M00/B.R3M00*100 end as MQTShare,
	case B.YTD00 when 0 then 0 else A.YTD00/B.YTD00*100 end as YTDShare,
	cast(null as int) as Tier,
	cast(null as int) as RankMAT,cast(null as int) as RankMQT,cast(null as int) as RankYTD
into OutputBrandShareByCity 
from TempCityDashboard_forPre A 
inner join TempCityDashboard_forPre B
on B.Prod='000' and A.Prod<>'000'
	and a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod
	and A.Molecule='N' and A.class='N' and A.mkt in ('ARV','NIAD','HYP','ONCFCS','Platinum','CCB')
go
update OutputBrandShareByCity
set Tier=B.Tier 
from OutputBrandShareByCity A 
inner join tblCityMax B
on A.Audi_cod=B.CIty
go
update OutputBrandShareByCity
set RankMAT=B.Rank
from OutputBrandShareByCity A 
inner join (
	select A.*,RANK ( )OVER (PARTITION BY Molecule,Class,mkt,market,Moneytype order by MATShare desc ) as Rank
	from OutputBrandShareByCity A where Prod='100') B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and A.Prod='100'
go
update OutputBrandShareByCity
set RankMQT=B.Rank
from OutputBrandShareByCity A 
inner join (
	select A.*,RANK ( )OVER (PARTITION BY Molecule,Class,mkt,market,Moneytype order by MQTShare desc ) as Rank
	from OutputBrandShareByCity A where Prod='100') B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and A.Prod='100'
go
update OutputBrandShareByCity
set RankYTD=B.Rank
from OutputBrandShareByCity A 
inner join (
	select A.*,RANK ( )OVER (PARTITION BY Molecule,Class,mkt,market,Moneytype order by YTDShare desc ) as Rank
	from OutputBrandShareByCity A where Prod='100') B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and A.Prod='100'
go

update OutputBrandShareByCity
set RankMAT=B.RankMAT,
	RankMQT=B.RankMQT,
	RankYTD=B.RankYTD 
from OutputBrandShareByCity A 
inner join (select * from OutputBrandShareByCity where Prod='100') B
on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod 
where A.prod<>'100'
go

if exists (select * from dbo.sysobjects where id = object_id(N'TempOutputBrandShareByCitySeg') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table TempOutputBrandShareByCitySeg
go

select  A.Molecule,A.Class,A.mkt,A.mktname,A.Market,A.Prod,A.productname,A.Moneytype,cast('CHPA' as varchar(20)) as Segment,
	convert(int, 1) as  SegIdx,
	sum(MAT00) as MAT00,sum(R3M00) as R3M00,sum(YTD00) as YTD00
into TempOutputBrandShareByCitySeg 
from TempCHPAPreReports A 
where Molecule='N' and class='N' and mkt in ('ARV','NIAD','HYP','ONCFCS','Platinum','CCB')
group by  A.Molecule,A.Class,A.mkt,A.mktname,A.Market,A.Prod,A.productname,A.Moneytype
go

insert into TempOutputBrandShareByCitySeg
select  A.Molecule,A.Class,A.mkt,A.mktname,A.Market,A.Prod,A.productname,A.Moneytype,tier,tier+2,
sum(MAT00) as MAT00,sum(R3M00) as R3M00,sum(YTD00) as YTD00
 from TempCityDashboard_forPre A where Molecule='N' and class='N' and mkt in ('ARV','NIAD','HYP','ONCFCS','Platinum','CCB')
group by  A.Molecule,A.Class,A.mkt,A.mktname,A.Market,A.Prod,A.productname,A.Moneytype,tier
go

update TempOutputBrandShareByCitySeg
set Segment=case Segment when '1' then 'Tier I cities'
when '2' then 'Tier II cities'
when '3' then 'Tier III cities'
when '4' then 'Tier IV cities'
else segment end
go

if exists (select * from dbo.sysobjects where id = object_id(N'OutputBrandShareByCitySeg') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputBrandShareByCitySeg
go
select A.Molecule,A.Class,A.mkt,A.mktname,A.Market,A.Prod,A.productname,A.Moneytype,
	A.Segment,A.SegIdx,
	case B.MAT00 when 0 then 0 else A.MAT00/B.MAT00 end as MATShare,
	case B.R3M00 when 0 then 0 else A.R3M00/B.R3M00 end as MQTShare,
	case B.YTD00 when 0 then 0 else A.YTD00/B.YTD00 end as YTDShare
	into OutputBrandShareByCitySeg 
from TempOutputBrandShareByCitySeg A 
inner join TempOutputBrandShareByCitySeg B
on B.Prod='000' and A.Prod<>'000'
	and a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
	and a.Moneytype=b.Moneytype and a.segment=b.segment
go

if exists (select * from dbo.sysobjects where id = object_id(N'OutputMoleBrandPerf') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table OutputMoleBrandPerf
go
--Chart
select 1 as TypeIdx,cast('Chart' as varchar(100)) as Type,B.mkt,B.Market,B.Prod,B.Productname,B.Moneytype,A.mkt as TotalMkt,b.AUDI_COD,b.AUDI_DES,
	B.LEV,B.TIER,B.YTD00 as ProdYTD,A.YTD00 as TotalYTD,
	case A.YTD00 when 0 then 0 else B.YTD00/A.YTD00 end AS SHARE
	INTO OutputMoleBrandPerf
from dbo.TempCityDashboard_forPre A 
inner join TempCityDashboard_Mole B
on a.Moneytype=B.Moneytype and A.Market=B.market AND A.AUDI_COD=B.AUDI_COD
where A.mkt in ('ARV','NIAD','HYP','ONCFCS','Platinum','CCB') and A.Prod='000'
	and (A.Molecule='Y' or A.Class='Y' )
order by b.mkt,b.prod
go
insert into OutputMoleBrandPerf
select 1,'Chart',B.mkt,B.Market,B.Prod,B.Productname,B.Moneytype,A.mkt as TotalMkt,'CHT_','CHPA','China','0',B.YTD00,A.YTD00,
	case A.YTD00 when 0 then 0 else B.YTD00/A.YTD00 end
from dbo.TempCHPAPreReports A 
inner join TempCHPAPreReports_Mole B
on a.Moneytype=B.Moneytype and A.Market=B.market
where A.mkt in ('ARV','NIAD','HYP','ONCFCS','Platinum','CCB') and A.Prod='000'
	and (A.Molecule='Y' or A.Class='Y' )
order by b.mkt,b.prod
go


delete from OutputMoleBrandPerf where Prod='000'
--table City %
insert into OutputMoleBrandPerf
select 2,a.mkt+' City %',A.mkt,A.Market,A.Prod,A.Productname,A.Moneytype,'',A.audi_cod,A.Audi_des,A.lev,A.Tier,0,0,
	A.YTD00/B.YTD00*100 as CityShare
from TempCityDashboard_Mole A 
inner join TempCHPAPreReports_Mole B
on A.mkt=b.mkt and a.Market=b.Market and a.Prod=b.Prod and a.moneytype=b.moneytype
where A.Prod='000' and  B.YTD00<>0
go
insert into OutputMoleBrandPerf
select 2,mkt+' City %',mkt,Market,Prod,Productname,Moneytype,'','CHT_','CHPA','China','0',0,0,100
 from TempCHPAPreReports_Mole where Prod in ('000')
go
--talbe size
insert into OutputMoleBrandPerf
select 3,mkt+' Size',mkt,Market,Prod,Productname,Moneytype,'',audi_cod,Audi_des,lev,Tier,0,0,YTD00
from TempCityDashboard_Mole 
where Prod='000'

insert into OutputMoleBrandPerf
select 3,mkt+' Size',mkt,Market,Prod,Productname,Moneytype,'','CHT_','CHPA','China','0',0,0,YTD00
from TempCHPAPreReports_Mole 
where Prod in ('000')

go


--table Prod in Molecule
insert into OutputMoleBrandPerf
select 4,a.Market+' % in '+a.mkt,A.mkt,A.Market,A.Prod,A.Productname,A.Moneytype,'','CHT_','CHPA','China','0',0,0,
	case when B.YTD00 = 0 then 0 else A.YTD00/B.YTD00*100 end as ProdShare
from TempCHPAPreReports_Mole A 
inner join TempCHPAPreReports_Mole B
on A.mkt=b.mkt and a.Market=b.Market and a.moneytype=b.moneytype
where B.Prod='000' and A.prod='100' and B.YTD00<>0
go
insert into OutputMoleBrandPerf
select 4,a.Market+' % in '+a.mkt,A.mkt,A.Market,A.Prod,A.Productname,A.Moneytype,'',A.audi_cod,A.Audi_des,A.lev,A.Tier,0,0,
	case when B.YTD00 = 0 then 0 else A.YTD00/B.YTD00*100 end as ProdShare
from TempCityDashboard_Mole A 
inner join TempCityDashboard_Mole B
on A.mkt=b.mkt and a.Market=b.Market and a.moneytype=b.moneytype and a.audi_cod=B.audi_cod
where B.Prod='000' and A.prod='100'
go
alter table OutputMoleBrandPerf add Idx int
go
update OutputMoleBrandPerf
set Idx=1 where audi_des='CHPA'


update OutputMoleBrandPerf
set Idx=b.rank+1 from OutputMoleBrandPerf A inner join 
    (select B.*,dense_RANK ( )OVER (order by audi_des ) as Rank
     from OutputMoleBrandPerf B where audi_des<>'CHPA') B
on a.audi_des=b.audi_des

go
update OutputMoleBrandPerf
set type=type+' ('+Div1+')',
    Share=Share/Div
from OutputMoleBrandPerf A inner join (
select Market,Moneytype,
	case 
		when cast(min(Share) as float) <1000000 then 1000
		when cast(min(Share) as float) between 1000000 and 1000000000 then 1000000
		when cast(min(Share) as float) > 1000000000 then 1000000000 else 1 end as Div,
	case 
		when cast(min(Share) as float) <1000000 then '000'
		when cast(min(Share) as float) between 1000000 and 1000000000 then 'mio.'
		when cast(min(Share) as float) > 1000000000 then 'bn.' else '' end as Div1
from OutputMoleBrandPerf where typeIdx=3 and tier<>0
group by Market,Moneytype ) B
on A.Market=b.market and a.Moneytype=B.Moneytype
where a. typeIdx=3
go
update OutputMoleBrandPerf
set Share=null where share=0
go





------------------------------------------------------------------------
-- OutputCMLChinaMarketTrend
------------------------------------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'OutputCMLChinaMarketTrend') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputCMLChinaMarketTrend
go
-- MAT Month 
select 
	cast('Sales' as varchar(10)) as [Type],cast('MAT Month' as varchar(20)) as Period,Moneytype,mkt,mktname,Market,cast(Prod as int) as ProdIdx,Prod,Productname,Molecule,Class,
	sum(Mat00) as Mat00,sum(Mat12) as Mat12,sum(Mat24) as Mat24,sum(Mat36) as Mat36,sum(Mat48) as Mat48
	-- sum(MTH00) as MTH00,sum(MTH12) as MTH12,sum(MTH24) as MTH24,sum(MTH36) as MTH36,sum(MTH48) as MTH48,
	-- sum(R3M00) as MQT00,sum(R3M12) as MQT12,sum(R3M24) as MQT24,sum(R3M36) as MQT36,sum(R3M48) as MQT48,
	-- sum(YTD00) as YTD00,sum(YTD12) as YTD12,sum(YTD24) as YTD24,sum(YTD36) as YTD36,sum(YTD48) as YTD48--, sum(YTD60) as YTD60
into OutputCMLChinaMarketTrend
from TempCHPAPreReports where mkt='CML'
group by Moneytype,mkt,mktname,Market,Prod,Productname,Molecule,Class
go
-- MTH
insert into OutputCMLChinaMarketTrend
select 
	cast('Sales' as varchar(10)) as [Type],cast('MTH' as varchar(20)) as Period,Moneytype,mkt,mktname,Market,cast(Prod as int) as ProdIdx,Prod,Productname,Molecule,Class,
	-- sum(Mat00) as Mat00,sum(Mat12) as Mat12,sum(Mat24) as Mat24,sum(Mat36) as Mat36,sum(Mat48) as Mat48,
	sum(MTH00) as MTH00,sum(MTH12) as MTH12,sum(MTH24) as MTH24,sum(MTH36) as MTH36,sum(MTH48) as MTH48
	-- sum(R3M00) as MQT00,sum(R3M12) as MQT12,sum(R3M24) as MQT24,sum(R3M36) as MQT36,sum(R3M48) as MQT48,
	-- sum(YTD00) as YTD00,sum(YTD12) as YTD12,sum(YTD24) as YTD24,sum(YTD36) as YTD36,sum(YTD48) as YTD48--, sum(YTD60) as YTD60
from TempCHPAPreReports where mkt='CML'
group by Moneytype,mkt,mktname,Market,Prod,Productname,Molecule,Class
go
-- MQT
insert into OutputCMLChinaMarketTrend
select 
	cast('Sales' as varchar(10)) as [Type],cast('MQT' as varchar(20)) as Period,Moneytype,mkt,mktname,Market,cast(Prod as int) as ProdIdx,Prod,Productname,Molecule,Class,
	-- sum(Mat00) as Mat00,sum(Mat12) as Mat12,sum(Mat24) as Mat24,sum(Mat36) as Mat36,sum(Mat48) as Mat48,
	-- sum(MTH00) as MTH00,sum(MTH12) as MTH12,sum(MTH24) as MTH24,sum(MTH36) as MTH36,sum(MTH48) as MTH48,
	sum(R3M00) as MQT00,sum(R3M12) as MQT12,sum(R3M24) as MQT24,sum(R3M36) as MQT36,sum(R3M48) as MQT48
	-- sum(YTD00) as YTD00,sum(YTD12) as YTD12,sum(YTD24) as YTD24,sum(YTD36) as YTD36,sum(YTD48) as YTD48--, sum(YTD60) as YTD60
from TempCHPAPreReports where mkt='CML'
group by Moneytype,mkt,mktname,Market,Prod,Productname,Molecule,Class
go
-- YTD
insert into OutputCMLChinaMarketTrend
select 
	cast('Sales' as varchar(10)) as [Type],cast('YTD' as varchar(20)) as Period,Moneytype,mkt,mktname,Market,cast(Prod as int) as ProdIdx,Prod,Productname,Molecule,Class,
	-- sum(Mat00) as Mat00,sum(Mat12) as Mat12,sum(Mat24) as Mat24,sum(Mat36) as Mat36,sum(Mat48) as Mat48,
	-- sum(MTH00) as MTH00,sum(MTH12) as MTH12,sum(MTH24) as MTH24,sum(MTH36) as MTH36,sum(MTH48) as MTH48,
	-- sum(R3M00) as MQT00,sum(R3M12) as MQT12,sum(R3M24) as MQT24,sum(R3M36) as MQT36,sum(R3M48) as MQT48,
	sum(YTD00) as YTD00,sum(YTD12) as YTD12,sum(YTD24) as YTD24,sum(YTD36) as YTD36,sum(YTD48) as YTD48--, sum(YTD60) as YTD60
from TempCHPAPreReports where mkt='CML'
group by Moneytype,mkt,mktname,Market,Prod,Productname,Molecule,Class
go

delete from OutputCMLChinaMarketTrend where MoneyType='PN'

--todo
------*******************************************************-----------2013/6/20 13:15:34处理代码：
--if not exists(select * from tblmonthlist where Month%3=0 and monseq=1)
--insert into OutputCMLChinaMarketTrend
--select * from OutputCMLChinaMarketTrend_2012Q4 where period='MAT Quarter'
--go
--由于上面一段代码被注释，漏掉，最终导致C201这种PPT跑不出来，报BUG.

--处理如下：
--select * into OutputCMLChinaMarketTrend_2013Q1 from BMSChinaCIA_IMS_201303.dbo.OutputCMLChinaMarketTrend

--select * into dbo.OutputCMLChinaMarketTrend_2012Q2 from IMSDBPlus.dbo.OutputCMLChinaMarketTrend_2012Q2
--select * into dbo.OutputCMLChinaMarketTrend_2012Q3 from IMSDBPlus.dbo.OutputCMLChinaMarketTrend_2012Q3
--select * into dbo.OutputCMLChinaMarketTrend_2012Q4 from IMSDBPlus.dbo.OutputCMLChinaMarketTrend_2012Q4
--select * into dbo.OutputCMLChinaMarketTrend_2013Q1 from BMSChinaCIA_IMS.dbo.OutputCMLChinaMarketTrend_2013Q1
--GO

if exists(select * from tblmonthlist where Month%3=0 and monseq=1)
begin 
	insert into OutputCMLChinaMarketTrend
	select 
		cast('Sales' as varchar(10)) as [Type],'MAT Quarter' as Period,Moneytype,mkt,mktname,Market,
		cast(Prod as int) as ProdIdx,Prod,Productname,Molecule,Class,
		sum(Mat00) as Mat00,sum(Mat12) as Mat12,sum(Mat24) as Mat24,sum(Mat36) as Mat36,sum(Mat48) as Mat48
		-- sum(MTH00) as MTH00,sum(MTH12) as MTH12,sum(MTH24) as MTH24,sum(MTH36) as MTH36,sum(MTH48) as MTH48,
		-- sum(R3M00) as MQT00,sum(R3M12) as MQT12,sum(R3M24) as MQT24,sum(R3M36) as MQT36,sum(R3M48) as MQT48,
		-- sum(YTD00) as YTD00,sum(YTD12) as YTD12,sum(YTD24) as YTD24,sum(YTD36) as YTD36,sum(YTD48) as YTD48--, sum(YTD60) as YTD60
	from TempCHPAPreReports where mkt='CML'
	group by Moneytype,mkt,mktname,Market,Prod,Productname,Molecule,Class
end 
else 
begin
    --todo
    declare @Y varchar(4), @Q  varchar(2),@sql nvarchar(1000)
	select @Y = [year] from tblmonthlist where QtrSeq = '1'
	select @Q = [Quarter] from tblmonthlist where QtrSeq = '1'
	set @sql='
	insert into OutputCMLChinaMarketTrend
	select [Type],[Period],[Moneytype],[mkt],[mktname],[Market],[ProdIdx],[Prod],[Productname]
		,[Molecule],[Class]
		,[Mat00],[Mat12],[Mat24],[Mat36],[Mat48]
		-- ,0 ,0 ,0 ,0 ,0
		-- ,0 ,0 ,0 ,0 ,0
		-- ,[YTD00],[YTD12],[YTD24],[YTD36],[YTD48]
	from OutputCMLChinaMarketTrend_' + @Y + @Q + ' 
	where period = ''MAT Quarter''
	'
	print @sql
	exec(@sql)
end 
GO


------*******************************************************-----------


insert into OutputCMLChinaMarketTrend
select 'Growth',Period,Moneytype,mkt,mktname,Market,(Prod+1)*100,Prod,Productname,Molecule,Class,
	case Mat12 when 0 then case Mat00 when 0 then 0 else null end else (Mat00-Mat12)*1.0/Mat12 end,
	case Mat24 when 0 then case Mat12 when 0 then 0 else null end else (Mat12-Mat24)*1.0/Mat24 end,
	case Mat36 when 0 then case Mat24 when 0 then 0 else null end else (Mat24-Mat36)*1.0/Mat36 end,
	case Mat48 when 0 then case Mat36 when 0 then 0 else null end else (Mat36-Mat48)*1.0/Mat48 end,
	null
	-- case MTH12 when 0 then case MTH00 when 0 then 0 else null end else (MTH00-MTH12)*1.0/MTH12 end,
	-- case MTH24 when 0 then case MTH12 when 0 then 0 else null end else (MTH12-MTH24)*1.0/MTH24 end,
	-- case MTH36 when 0 then case MTH24 when 0 then 0 else null end else (MTH24-MTH36)*1.0/MTH36 end,
	-- case MTH48 when 0 then case MTH36 when 0 then 0 else null end else (MTH36-MTH48)*1.0/MTH48 end,
	-- null,
	-- case MQT12 when 0 then case MQT00 when 0 then 0 else null end else (MQT00-MQT12)*1.0/MQT12 end,
	-- case MQT24 when 0 then case MQT12 when 0 then 0 else null end else (MQT12-MQT24)*1.0/MQT24 end,
	-- case MQT36 when 0 then case MQT24 when 0 then 0 else null end else (MQT24-MQT36)*1.0/MQT36 end,
	-- case MQT48 when 0 then case MQT36 when 0 then 0 else null end else (MQT36-MQT48)*1.0/MQT48 end,
	-- null,
	-- case YTD12 when 0 then case YTD00 when 0 then 0 else null end else (YTD00-YTD12)*1.0/YTD12 end,
	-- case YTD24 when 0 then case YTD12 when 0 then 0 else null end else (YTD12-YTD24)*1.0/YTD24 end,
	-- case YTD36 when 0 then case YTD24 when 0 then 0 else null end else (YTD24-YTD36)*1.0/YTD36 end,
	-- case YTD48 when 0 then case YTD36 when 0 then 0 else null end else (YTD36-YTD48)*1.0/YTD48 end,
	-- --case YTD60 when 0 then case YTD48 when 0 then 0 else null end else (YTD48-YTD60)*1.0/YTD60 end,
	-- null
from OutputCMLChinaMarketTrend where Prod='000' and [Type]='Sales'
go
insert into OutputCMLChinaMarketTrend
select 'CAGR',Period,Moneytype,mkt,mktname,Market,900,Prod,Productname,Molecule,Class,
	Power((MAT00/MAT48),1.0/4)-1,0,0,0,0
	-- Power((MTH00/MTH48),1.0/4)-1,0,0,0,0,
	-- Power((MQT00/MQT48),1.0/4)-1,0,0,0,0,
	-- 0,0,0,0,0--,0
from OutputCMLChinaMarketTrend where Prod='000' and [Type]='Sales' and MAT48<>0
go
delete from OutputCMLChinaMarketTrend where [Type]='Sales' and Prod=0
go


--backup
if exists(select * from tblmonthlist where Month%3=0 and monseq=1)
begin
	--todo
    declare @Y varchar(4), @Q  varchar(2),@sql nvarchar(1000)
	select @Y = [year] from tblmonthlist where QtrSeq = '1'
	select @Q = [Quarter] from tblmonthlist where QtrSeq = '1'
	
	set @sql=N'
	if not exists (select * from dbo.sysobjects where id = object_id(N''OutputCMLChinaMarketTrend_'+@y+@q+N''')'+N' and OBJECTPROPERTY(id, N''IsUserTable'') = 1)
	begin

		select * into OutputCMLChinaMarketTrend_' + @Y + @Q + N' from OutputCMLChinaMarketTrend		
	end	'
	exec( @sql)
end










------------------------------------------------------------------------
-- OutputCMLChina_HKAPI
------------------------------------------------------------------------
--00 newest quarter
if exists (select * from dbo.sysobjects where id = object_id(N'OutputCMLChina_HKAPI') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table OutputCMLChina_HKAPI
go
select 'Sprycel' as Market,'MAT' as Period,[Product Name] as Product,cast(1 as int) as ProdIdx,'USD' as Moneytype
	,sum(MAT00US)*1000 as MAT00
	,sum(MAT12US)*1000 as MAT12
	,sum(MAT24US)*1000 as MAT24
	,sum(MAT36US)*1000 as MAT36
	,sum(MAT48US)*1000 as MAT48
	,sum([15Q4US])*1000 as Qtr04
	,sum([16Q1US])*1000 as Qtr03
	,sum([16Q2US])*1000 as Qtr02
	,sum([16Q3US])*1000 as Qtr01
	,sum([16Q4US])*1000 as Qtr00--todo
	,cast(0 as float) as Growth
into OutputCMLChina_HKAPI from inHKAPI_New where [Product Name] like '%spycel%' or  [Product Name] in(
select distinct Prod_name from tblMktDef_MRBIChina where mkt='CML')
group by [Product Name]
go
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
from inHKAPI_New where [Product Name] like '%spycel%' or  [Product Name] in(
select distinct Prod_name from tblMktDef_MRBIChina where mkt='CML')
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


--select * from OutputCMLChina_HKAPI

-------------------------------------------------------------------------
--			Create middle table of Baraclude modification first slide
-------------------------------------------------------------------------


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'OutputKeyBrandPerformance_For_Baraclude_Modify') and type = 'U')
	DROP TABLE OutputKeyBrandPerformance_For_Baraclude_Modify
GO
declare @i int,@sql varchar(max),@sqlR varchar(max)
set @i=0
set @sql=''
set @sqlR=''

set @sql=@sql+'
	case sum(A.MAT00) when 0 then null else sum(B.MAT00)*1.0/sum(A.MAT00) end as MAT00, 
	case sum(A.MAT12) when 0 then null else sum(B.MAT12)*1.0/sum(A.MAT12) end as MAT12, 
	case sum(A.MAT24) when 0 then null else sum(B.MAT24)*1.0/sum(A.MAT24) end as MAT24, 
	case sum(A.MAT36) when 0 then null else sum(B.MAT36)*1.0/sum(A.MAT36) end as MAT36, 
	case sum(A.MAT48) when 0 then null else sum(B.MAT48)*1.0/sum(A.MAT48) end as MAT48,'
-- while (@i<=24)
-- begin
-- 	set @sql=@sql+'
-- 	case sum(A.MAT'+right('00'+cast(@i as varchar(2)),2)+') when 0 then null else sum(B.MAT'+right('00'+cast(@i as varchar(2)),2)+')*1.0/sum(A.MAT'+right('00'+cast(@i as varchar(2)),2)+') end as MAT'+right('00'+cast(@i as varchar(2)),2)+','
-- 	set @i=@i+1
-- end
set @sqlR='
	select ''MAT'' as Period,B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname,'+
	left(@sql,len(@sql)-1)+' into OutputKeyBrandPerformance_For_Baraclude_Modify from TempCHPAPreReports A inner join TempCHPAPreReports B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
	and A.Market=B.Market and A.prod=''000'' and B.prod<>''000''
	where B.Market = ''baraclude'' and B.Productname in (''Entecavir'',''Adefovir Dipivoxil'') and B.Molecule = ''Y'' and B.Class = ''N''
	group by B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname'
print @sqlR
exec (@sqlR)

set @i=0
set @sql=''
set @sqlR=''

set @sql=@sql+'
	case sum(A.R3M00) when 0 then null else sum(B.R3M00)*1.0/sum(A.R3M00) end as R3M00, 
	case sum(A.R3M12) when 0 then null else sum(B.R3M12)*1.0/sum(A.R3M12) end as R3M12, 
	case sum(A.R3M24) when 0 then null else sum(B.R3M24)*1.0/sum(A.R3M24) end as R3M24, 
	case sum(A.R3M36) when 0 then null else sum(B.R3M36)*1.0/sum(A.R3M36) end as R3M36, 
	case sum(A.R3M48) when 0 then null else sum(B.R3M48)*1.0/sum(A.R3M48) end as R3M48,'
-- while (@i<=24)
-- begin
-- 	set @sql=@sql+'
-- 	case sum(A.R3M'+right('00'+cast(@i as varchar(2)),2)+') when 0 then null else sum(B.R3M'+right('00'+cast(@i as varchar(2)),2)+')*1.0/sum(A.R3M'+right('00'+cast(@i as varchar(2)),2)+') end,'
-- 	set @i=@i+1
-- end
set @sqlR='insert into OutputKeyBrandPerformance_For_Baraclude_Modify
	select ''MQT'' as Period,B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname,'+
	left(@sql,len(@sql)-1)+' from TempCHPAPreReports A inner join TempCHPAPreReports B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
	and A.Market=B.Market and A.prod=''000'' and B.prod<>''000''
	where B.Market = ''baraclude'' and B.Productname in (''Entecavir'',''Adefovir Dipivoxil'') and B.Molecule = ''Y'' and B.Class = ''N''
	group by B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname'
print @sqlR
exec (@sqlR)

set @i=0
set @sql=''
set @sqlR=''

set @sql=@sql+'
	case sum(A.MTH00) when 0 then null else sum(B.MTH00)*1.0/sum(A.MTH00) end as MTH00, 
	case sum(A.MTH12) when 0 then null else sum(B.MTH12)*1.0/sum(A.MTH12) end as MTH12, 
	case sum(A.MTH24) when 0 then null else sum(B.MTH24)*1.0/sum(A.MTH24) end as MTH24, 
	case sum(A.MTH36) when 0 then null else sum(B.MTH36)*1.0/sum(A.MTH36) end as MTH36, 
	case sum(A.MTH48) when 0 then null else sum(B.MTH48)*1.0/sum(A.MTH48) end as MTH48,'
-- while (@i<=24)
-- begin
-- 	set @sql=@sql+'
-- 	case sum(A.MTH'+right('00'+cast(@i as varchar(2)),2)+') when 0 then null else sum(B.MTH'+right('00'+cast(@i as varchar(2)),2)+')*1.0/sum(A.MTH'+right('00'+cast(@i as varchar(2)),2)+') end,'
-- 	set @i=@i+1
-- end
set @sqlR='insert into OutputKeyBrandPerformance_For_Baraclude_Modify
	select ''MTH'' as Period,B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname,'+
	left(@sql,len(@sql)-1)+' from TempCHPAPreReports A inner join TempCHPAPreReports B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
	and A.Market=B.Market and A.prod=''000'' and B.prod<>''000''
	where B.Market = ''baraclude'' and B.Productname in (''Entecavir'',''Adefovir Dipivoxil'') and B.Molecule = ''Y'' and B.Class = ''N''
	group by B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname'
print @sqlR
exec (@sqlR)


set @i=0
set @sql=''
set @sqlR=''

set @sql=@sql+'
	case sum(A.YTD00) when 0 then null else sum(B.YTD00)*1.0/sum(A.YTD00) end as YTD00, 
	case sum(A.YTD12) when 0 then null else sum(B.YTD12)*1.0/sum(A.YTD12) end as YTD12, 
	case sum(A.YTD24) when 0 then null else sum(B.YTD24)*1.0/sum(A.YTD24) end as YTD24, 
	case sum(A.YTD36) when 0 then null else sum(B.YTD36)*1.0/sum(A.YTD36) end as YTD36, 
	case sum(A.YTD48) when 0 then null else sum(B.YTD48)*1.0/sum(A.YTD48) end as YTD48,'
-- while (@i<=24)
-- begin
-- 	set @sql=@sql+'
-- 	case sum(A.YTD'+right('00'+cast(@i as varchar(2)),2)+') when 0 then null else sum(B.YTD'+right('00'+cast(@i as varchar(2)),2)+')*1.0/sum(A.YTD'+right('00'+cast(@i as varchar(2)),2)+') end,'
-- 	set @i=@i+1
-- end
set @sqlR='insert into OutputKeyBrandPerformance_For_Baraclude_Modify
	select ''YTD'' as Period,B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname,'+
	left(@sql,len(@sql)-1)+' from TempCHPAPreReports A inner join TempCHPAPreReports B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
	and A.Market=B.Market and A.prod=''000'' and B.prod<>''000''
	where B.Market = ''baraclude'' and B.Productname in (''Entecavir'',''Adefovir Dipivoxil'') and B.Molecule = ''Y'' and B.Class = ''N''
	group by B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname'
print @sqlR
exec (@sqlR)
go



-- ----------------------------------------------------------------------
-- --				Create middle table of Baraclude Modifation Slide 6
-- -----------------------------------------------------------------------			

-- IF NOT EXISTS (SELECT 1 FROM SYSCOLUMNS WHERE ID = OBJECT_ID(N'OUTPUT') AND NAME = 'INTY')
-- BEGIN
-- 	alter table output add inty float
-- END
-- GO
-- -- Creating middle table OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6
-- IF OBJECT_ID(N'OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6_1',N'U') IS NOT NULL
-- 	DROP TABLE dbo.OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6_1
-- GO

-- select lev, type, molecule,class,mkt,market,mktname,prod,Productname,moneyType,Audi_cod,Audi_des,Region,
-- 	   sum([R3M00]) as [R3M00],sum([YTD00]) as [YTD00],sum([MAT00]) as [MAT00],sum([MTH00]) as [MTH00],sum([R3M12]) as [R3M12],sum([YTD12]) as [YTD12],sum([MAT12]) as [MAT12],sum([MTH12]) as [MTH12]
-- into dbo.OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6_1
-- from (
-- 	select 
-- 		lev, type, molecule,class,mkt,market,mktname,
-- 		case when Productname in ('Other Entecavir','ARV Others') then '900' else Prod end prod,
-- 		case when Productname in ('Other Entecavir','ARV Others') then 'Others' else Productname end Productname,
-- 		moneyType, 
-- 		case when Audi_des like 'East II%' 	then '2'
-- 		 	 when Audi_des like 'East I%' 	then '1'
-- 			 when Audi_des like 'South%' 	then '3'
-- 			 when Audi_des like 'North East%' and Audi_des <> 'National' then '5'
-- 			 when Audi_des like 'North%' 	and Audi_des <> 'National' then '4'
-- 			 when Audi_des like 'Central%' 	then '6'
-- 			 when Audi_des like 'West%' 	then '7'
-- 			 else Audi_cod
-- 		end as Audi_cod,
		
-- 		case 
-- 			 when Audi_des like 'East II%' 	then 'East II'
-- 			 when Audi_des like 'East I%' 	then 'East I'
-- 			 when Audi_des like 'South%' 	then 'South'
-- 			 when Audi_des like 'North East%' and Audi_des <> 'National' then 'North East'
-- 			 when Audi_des like 'North%' 	and Audi_des <> 'National' then 'North'
-- 			 when Audi_des like 'Central%' 	then 'Central'
-- 			 when Audi_des like 'West%' 	then 'West'
-- 			 else Audi_des
-- 		end as Audi_des,
		
-- 		--case when Audi_des like 'E%' then 'East'
-- 		--	 when Audi_des like 'S%' then 'South'
-- 		--	 when Audi_des like 'N%' and Audi_des <> 'National' then 'North'
-- 		--	 else Audi_des
-- 		--end as Audi_des,
-- 		case 
-- 			 when Audi_des like 'East II%' 	then 'East II'
-- 			 when Audi_des like 'East I%' 	then 'East I'
-- 			 when Audi_des like 'South%' 	then 'South'
-- 			 when Audi_des like 'North East%' and Audi_des <> 'National' then 'North East'
-- 			 when Audi_des like 'North%' 	and Audi_des <> 'National' then 'North'
-- 			 when Audi_des like 'Central%' 	then 'Central'
-- 			 when Audi_des like 'West%' 	then 'West'
-- 			 else Audi_des
-- 		end as Region,
-- 		[R3M00],[YTD00],[MAT00],[MTH00],[R3M12],[YTD12],[MAT12],[MTH12]
-- 	from 
-- 	(
-- 		select  a.lev, b.type,
-- 			--a.Type as volume_Type, b.Type as share_Type,
-- 			a.molecule,a.class,a.mkt,b.market,b.mktname,b.prod,b.Productname,b.moneytype,b.audi_cod,b.audi_des,b.region,
-- 			b.R3M00*a.R3M00 as R3M00,b.YTD00*a.YTD00 as YTD00, b.MAT00*a.MAT00 as MAT00,b.MTH00*a.MTH00 as MTH00,
-- 			b.R3M12*a.R3M12 as R3M12,b.YTD12*a.YTD12 as YTD12, b.MAT12*a.MAT12 as MAT12,b.MTH12*a.MTH12 as MTH12
-- 		from (
-- 			select * 
-- 			from OutputKeyBrandPerformanceByRegion 
-- 			where market = 'baraclude' and Type = 'Market Total'
-- 		) a join (
-- 			select * 
-- 			from OutputKeyBrandPerformanceByRegion 
-- 			where market = 'baraclude' and type = 'share'
-- 		) b
-- 		on a.mkt=b.mkt and a.MoneyType=b.MoneyType and a.class=b.class and a.molecule = b.molecule and a.audi_cod=b.audi_cod and a.region=b.region and a.lev = b.lev
		
-- 	) mid where audi_des <> 'National'

-- ) a
-- group by lev, type, molecule,class,mkt,market,mktname,prod,Productname,moneyType,Audi_cod,Audi_des,Region
-- go

-- insert into  OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6_1 (lev,type,molecule,class,mkt,market,mktname,prod,ProductName,
-- 					moneyType,Audi_cod,Audi_des,Region,R3M00,YTD00,MAT00,MTH00,R3M12,YTD12,MAT12,MTH12)
-- select lev,type,molecule,class,mkt,market,mktname,prod,ProductName,
-- 		moneyType,Audi_cod,Audi_des,Region,
-- 		SUM(R3M00) AS R3M00,SUM(YTD00) AS YTD00,SUM(MAT00) AS MAT00,SUM(MTH00) AS MTH00,SUM(R3M12) AS R3M12,
-- 		SUM(YTD12) AS YTD12,SUM(MAT12) AS MAT12,SUM(MTH12) AS MTH12
-- from (
-- 	select 
-- 		lev, type, molecule,class,mkt,market,mktname,
-- 		Prod,Productname,moneyType, 		
-- 		case 
-- 			 when Audi_des like 'East II%' 	then '2'
-- 			 when Audi_des like 'East I%' 	then '1'
-- 			 when Audi_des like 'South%' 	then '3'
-- 			 when Audi_des like 'North East%' and Audi_des <> 'National' then '5'
-- 			 when Audi_des like 'North%' 	and Audi_des <> 'National' then '4'
-- 			 when Audi_des like 'Central%' 	then '6'
-- 			 when Audi_des like 'West%' 	then '7'
-- 			 else Audi_cod
-- 		end as Audi_cod,
		
-- 		case 
-- 			 when Audi_des like 'East II%' 	then 'East II'
-- 			 when Audi_des like 'East I%' 	then 'East I'
-- 			 when Audi_des like 'South%' 	then 'South'
-- 			 when Audi_des like 'North East%' and Audi_des <> 'National' then 'North East'
-- 			 when Audi_des like 'North%' 	and Audi_des <> 'National' then 'North'
-- 			 when Audi_des like 'Central%' 	then 'Central'
-- 			 when Audi_des like 'West%' 	then 'West'
-- 			else Audi_des
-- 		end as Audi_des,
		
-- 		--case when Audi_des like 'E%' then 'East'
-- 		--	 when Audi_des like 'S%' then 'South'
-- 		--	 when Audi_des like 'N%' and Audi_des <> 'National' then 'North'
-- 		--	 else Audi_des
-- 		--end as Audi_des,
-- 		case 
-- 			 when Audi_des like 'East II%' 	then 'East II'
-- 			 when Audi_des like 'East I%' 	then 'East I'
-- 			 when Audi_des like 'South%' 	then 'South'
-- 			 when Audi_des like 'North East%' and Audi_des <> 'National' then 'North East'
-- 			 when Audi_des like 'North%' 	and Audi_des <> 'National' then 'North'
-- 			 when Audi_des like 'Central%' 	then 'Central'
-- 			 when Audi_des like 'West%' 	then 'West'
-- 			else Audi_des
-- 		end as Region,
-- 		[R3M00],[YTD00],[MAT00],[MTH00],[R3M12],[YTD12],[MAT12],[MTH12]
-- 	from	OutputKeyBrandPerformanceByRegion where market = 'baraclude' and Type = 'Market Total'
-- ) A
-- where Audi_des <> 'National'
-- GROUP BY lev,type,molecule,class,mkt,market,mktname,prod,ProductName,moneyType,Audi_cod,Audi_des,Region
-- GO



-- IF OBJECT_ID(N'OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6',N'U') IS NOT NULL
-- 	DROP TABLE dbo.OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6
-- GO

-- select a.lev,a.type,a.molecule,a.class,a.mkt,a.market,a.mktname,a.prod,a.productname,a.moneyType,a.Audi_cod,a.Audi_des,a.Region,
-- 	case when b.R3M00 =0 then 0 else 1.0*a.R3M00/b.R3M00 end as R3M00, 
-- 	case when b.YTD00 =0 then 0 else 1.0*a.YTD00/b.YTD00 end as YTD00, 
-- 	case when b.MAT00 =0 then 0 else 1.0*a.MAT00/b.MAT00 end as MAT00,
-- 	case when b.MTH00 =0 then 0 else 1.0*a.MTH00/b.MTH00 end as MTH00,
-- 	case when b.R3M12 =0 then 0 else 1.0*a.R3M12/b.R3M12 end as R3M12, 
-- 	case when b.YTD12 =0 then 0 else 1.0*a.YTD12/b.YTD12 end as YTD12, 
-- 	case when b.MAT12 =0 then 0 else 1.0*a.MAT12/b.MAT12 end as MAT12,
-- 	case when b.MTH12 =0 then 0 else 1.0*a.MTH12/b.MTH12 end as MTH12
-- into OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6
-- from  
-- 	(select * from OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6_1 WHERE prod <> '000') a 
-- join
-- 	(select lev,type,molecule,class,mkt,market,mktname,Audi_cod,Audi_des,Region,moneyType,
-- 			sum(R3M00) as R3M00, sum(YTD00) as YTD00,sum(MAT00) as MAT00,sum(MTH00) as MTH00,
-- 			sum(R3M12) as R3M12, sum(YTD12) as YTD12,sum(MAT12) as MAT12,sum(MTH12) as MTH12
-- 	from OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6_1 where prod <> '000'
-- 	group by lev,type,molecule,class,mkt,market,mktname,Audi_cod,Audi_des,Region,moneyType
-- 	) b
-- on a.lev=b.lev and a.type = b.type and a.molecule=b.molecule and a.class=b.class and a.mkt=b.mkt and a.Audi_cod=b.Audi_cod and a.Audi_des = b.Audi_des and a.moneyType=b.moneyType

-- update OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6
-- set audi_cod= case  
-- 					when Audi_des like 'East II%' 	then '2'
-- 					when Audi_des like 'East I%' 	then '1'
-- 					when Audi_des like 'South%' 	then '3'
-- 					when Audi_des like 'North East%' then '5'
-- 					when Audi_des like 'North%' 	then '4'
-- 					when Audi_des like 'Central%' 	then '6'
-- 					when Audi_des like 'West%' 	then '7'
-- 	               end


GO



-- Creating middle table OutputKeyBrandPerformanceByRegionGrowth_For_Baraclude_Slide6

IF OBJECT_ID(N'OutputKeyBrandPerformanceByRegionGrowth_For_Baraclude_Slide6',N'U') IS NOT NULL
	DROP TABLE dbo.OutputKeyBrandPerformanceByRegionGrowth_For_Baraclude_Slide6
GO

select 
  [Molecule]
  ,[Class]
  ,[mkt]
  ,Market
  ,[mktname]
  ,[prod]
  ,[Productname]
  ,[Moneytype]
  ,lev
  ,[Region]
  ,Audi_cod
  ,[Audi_des]
  ,case R3M12 when 0 then case R3M00 when 0 then 0 else null end else (R3M00-R3M12)*1.0/R3M12 end as R3M00
  ,case YTD12 when 0 then case YTD00 when 0 then 0 else null end else (YTD00-YTD12)*1.0/YTD12 end as YTD00
  ,case MAT12 when 0 then case MAT00 when 0 then 0 else null end else (MAT00-MAT12)*1.0/MAT12 end as MAT00
  ,case MTH12 when 0 then case MTH00 when 0 then 0 else null end else (MTH00-MTH12)*1.0/MTH12 end as MTH00
into OutputKeyBrandPerformanceByRegionGrowth_For_Baraclude_Slide6
from OutputKeyBrandPerformanceByRegion_For_Baraclude_Slide6_1

delete from OutputKeyBrandPerformanceByRegionGrowth_For_Baraclude_Slide6 where market='Baraclude' and Productname not in('Baraclude','ARV Market','Heptodin','Run Zhong','Sebivo','Viread')

update OutputKeyBrandPerformanceByRegionGrowth_For_Baraclude_Slide6 set audi_cod=B.rank 
from 
  OutputKeyBrandPerformanceByRegionGrowth_For_Baraclude_Slide6 A 
inner join 
  (select B.*,dense_rank() OVER (order by case audi_des when 'National' then 'ZZZZ' else audi_des end) as Rank 
  from OutputKeyBrandPerformanceByRegionGrowth_For_Baraclude_Slide6 B
  ) B
on A.audi_des=B.audi_des

go

--------------------------------------------------------
--	Create Mid table of Baraclude Modification Slide 7
--------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'MID_OutputProdSalesPerformanceInChina_R777') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table MID_OutputProdSalesPerformanceInChina_R777
go
CREATE TABLE [dbo].MID_OutputProdSalesPerformanceInChina_R777(
    [TypeIdx] int,
    [Type] [varchar](50) NULL,
	[Period] [varchar](20)  NULL,
	[MoneyType] [varchar](20)  NULL,
	[Market] [varchar](20)  NULL,
	[Prod_cod] [varchar](10) NULL,
	[Prod_des] [varchar](100)  NULL,
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
	[Mth10] [float] NULL,
	[Mth11] [float] NULL,
	[Mth12] [float] NULL,
	[Mth13] [float] NULL,
	[Mth14] [float] NULL,
	[Mth15] [float] NULL,
	[Mth16] [float] NULL,
	[Mth17] [float] NULL,
	[Mth18] [float] NULL,
	[Mth19] [float] NULL,
	[Mth20] [float] NULL,
	[Mth21] [float] NULL,
	[Mth22] [float] NULL,
	[Mth23] [float] NULL,
	[Mth24] [float] NULL,
	[Mth25] [float] NULL,
	[Mth26] [float] NULL,
	[Mth27] [float] NULL,
	[Mth28] [float] NULL,
	[Mth29] [float] NULL,
	[Mth30] [float] NULL,
	[Mth31] [float] NULL,
	[Mth32] [float] NULL,
	[Mth33] [float] NULL,	
	[Mth34] [float] NULL,	
	[Mth35] [float] NULL
) ON [PRIMARY]
print 'carete table finished'
GO
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType where [Type]='UN'
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(max)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType

		set @SQL2='insert into MID_OutputProdSalesPerformanceInChina_R777
		select 1,''Product'',''MTH'','+'''' +@MoneyType+''''+',B.mkt,a.prod_cod,''''
			,sum(MTH00' +@MoneyType+')
			,sum(MTH01' +@MoneyType+')
			,sum(MTH02' +@MoneyType+')
			,sum(MTH03' +@MoneyType+')
			,sum(MTH04' +@MoneyType+')
			,sum(MTH05' +@MoneyType+')
			,sum(MTH06' +@MoneyType+')
			,sum(MTH07' +@MoneyType+')
			,sum(MTH08' +@MoneyType+')
			,sum(MTH09' +@MoneyType+')
			,sum(MTH10' +@MoneyType+')
			,sum(MTH11' +@MoneyType+')
			,sum(MTH12' +@MoneyType+')
			,sum(MTH13' +@MoneyType+')
			,sum(MTH14' +@MoneyType+')
			,sum(MTH15' +@MoneyType+')
			,sum(MTH16' +@MoneyType+')
			,sum(MTH17' +@MoneyType+')
			,sum(MTH18' +@MoneyType+')
			,sum(MTH19' +@MoneyType+')
			,sum(MTH20' +@MoneyType+')
			,sum(MTH21' +@MoneyType+')
			,sum(MTH22' +@MoneyType+')
			,sum(MTH23' +@MoneyType+')
			,sum(MTH24' +@MoneyType+')
			,sum(MTH25' +@MoneyType+')
			,sum(MTH26' +@MoneyType+')
			,sum(MTH27' +@MoneyType+')
			,sum(MTH28' +@MoneyType+')
			,sum(MTH29' +@MoneyType+')
			,sum(MTH30' +@MoneyType+')
			,sum(MTH31' +@MoneyType+')
			,sum(MTH32' +@MoneyType+')
			,sum(MTH33' +@MoneyType+')
			,sum(MTH34' +@MoneyType+')
			,sum(MTH35' +@MoneyType+')		
		from mthchpa_pkau A 
        inner join(
           select distinct A.mkt,B.PRod_cod from tblMktDef_MRBIChina A inner join tblProddef B
		   on A.productname=B.Product
		   where A.mkt = ''ARV'' and A.prod in (''100'',''400'')
        ) B
        on A.PRod_cod=B.PRod_cod
        group by B.mkt,a.prod_cod

        insert into MID_OutputProdSalesPerformanceInChina_R777
		select 2,''Molecule'',''MTH'','+'''' +@MoneyType+''''+',B.mkt,''010'',''''
			,sum(MTH00' +@MoneyType+')
			,sum(MTH01' +@MoneyType+')
			,sum(MTH02' +@MoneyType+')
			,sum(MTH03' +@MoneyType+')
			,sum(MTH04' +@MoneyType+')
			,sum(MTH05' +@MoneyType+')
			,sum(MTH06' +@MoneyType+')
			,sum(MTH07' +@MoneyType+')
			,sum(MTH08' +@MoneyType+')
			,sum(MTH09' +@MoneyType+')
			,sum(MTH10' +@MoneyType+')
			,sum(MTH11' +@MoneyType+')
			,sum(MTH12' +@MoneyType+')
			,sum(MTH13' +@MoneyType+')
			,sum(MTH14' +@MoneyType+')
			,sum(MTH15' +@MoneyType+')
			,sum(MTH16' +@MoneyType+')
			,sum(MTH17' +@MoneyType+')
			,sum(MTH18' +@MoneyType+')
			,sum(MTH19' +@MoneyType+')
			,sum(MTH20' +@MoneyType+')
			,sum(MTH21' +@MoneyType+')
			,sum(MTH22' +@MoneyType+')
			,sum(MTH23' +@MoneyType+')
			,sum(MTH24' +@MoneyType+')
			,sum(MTH25' +@MoneyType+')
			,sum(MTH26' +@MoneyType+')
			,sum(MTH27' +@MoneyType+')
			,sum(MTH28' +@MoneyType+')
			,sum(MTH29' +@MoneyType+')
			,sum(MTH30' +@MoneyType+')
			,sum(MTH31' +@MoneyType+')
			,sum(MTH32' +@MoneyType+')
			,sum(MTH33' +@MoneyType+')
			,sum(MTH34' +@MoneyType+')
			,sum(MTH35' +@MoneyType+')		
		from mthchpa_pkau A 
        inner join(
           select distinct A.mkt,A.PRod_cod from tblMktDef_MRBIChina A 
		   where A.mkt = ''ARV'' and A.prod in (''010'') 
        ) B
        on A.PRod_cod=B.PRod_cod
        group by B.mkt
        
		insert into MID_OutputProdSalesPerformanceInChina_R777
		select 3,''Market'',''MTH'','+'''' +@MoneyType+''''+',B.mkt,B.mkt,''''
			,sum(MTH00' +@MoneyType+')
			,sum(MTH01' +@MoneyType+')
			,sum(MTH02' +@MoneyType+')
			,sum(MTH03' +@MoneyType+')
			,sum(MTH04' +@MoneyType+')
			,sum(MTH05' +@MoneyType+')
			,sum(MTH06' +@MoneyType+')
			,sum(MTH07' +@MoneyType+')
			,sum(MTH08' +@MoneyType+')
			,sum(MTH09' +@MoneyType+')
			,sum(MTH10' +@MoneyType+')
			,sum(MTH11' +@MoneyType+')
			,sum(MTH12' +@MoneyType+')
			,sum(MTH13' +@MoneyType+')
			,sum(MTH14' +@MoneyType+')
			,sum(MTH15' +@MoneyType+')
			,sum(MTH16' +@MoneyType+')
			,sum(MTH17' +@MoneyType+')
			,sum(MTH18' +@MoneyType+')
			,sum(MTH19' +@MoneyType+')
			,sum(MTH20' +@MoneyType+')
			,sum(MTH21' +@MoneyType+')
			,sum(MTH22' +@MoneyType+')
			,sum(MTH23' +@MoneyType+')
			,sum(MTH24' +@MoneyType+')
			,sum(MTH25' +@MoneyType+')
			,sum(MTH26' +@MoneyType+')
			,sum(MTH27' +@MoneyType+')
			,sum(MTH28' +@MoneyType+')
			,sum(MTH29' +@MoneyType+')
			,sum(MTH30' +@MoneyType+')
			,sum(MTH31' +@MoneyType+')
			,sum(MTH32' +@MoneyType+')
			,sum(MTH33' +@MoneyType+')
			,sum(MTH34' +@MoneyType+')
			,sum(MTH35' +@MoneyType+')	
		from mthchpa_pkau A inner join tblMktDef_MRBIChina B
		on A.pack_cod=b.pack_cod
		where B.prod=''000'' and B.mkt in(''ARV'') and Molecule=''N'' and Class=''N''and B.Active=''Y''
		group by B.mkt'

		print @SQL2
		exec( @SQL2)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go

print 'Insert ARV market and the three products finished'

update MID_OutputProdSalesPerformanceInChina_R777
set Prod_des=B.product 
from MID_OutputProdSalesPerformanceInChina_R777 A inner join
dbo.tblProdDef B
on A.prod_cod=B.prod_cod
where Type<>'Molecule'

update MID_OutputProdSalesPerformanceInChina_R777
set Prod_des = 'Entecavir Size' where Type = 'Molecule'

update MID_OutputProdSalesPerformanceInChina_R777
set Prod_des=B.mktname from MID_OutputProdSalesPerformanceInChina_R777 A inner join
dbo.tblMktDef_MRBIChina B
on A.prod_cod=B.mkt
go

update MID_OutputProdSalesPerformanceInChina_R777
set market=case market 
when 'ARV' then 'Baraclude' 
else market end
go

insert into MID_OutputProdSalesPerformanceInChina_R777--([Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[Mat00],[Mat12],[Mat24],[Mat36],[Mat48])
select 4,A.prod_des+' Share',A.Period,A.Moneytype,A.Market,B.prod_cod,B.prod_des,
	case A.MTH00 when 0 then 0 else 1.0*B.MTH00/A.MTH00 end,
	case A.MTH01 when 0 then 0 else 1.0*B.MTH01/A.MTH01 end,
	case A.MTH02 when 0 then 0 else 1.0*B.MTH02/A.MTH02 end,
	case A.MTH03 when 0 then 0 else 1.0*B.MTH03/A.MTH03 end,
	case A.MTH04 when 0 then 0 else 1.0*B.MTH04/A.MTH04 end,
	case A.MTH05 when 0 then 0 else 1.0*B.MTH05/A.MTH05 end,
	case A.MTH06 when 0 then 0 else 1.0*B.MTH06/A.MTH06 end,
	case A.MTH07 when 0 then 0 else 1.0*B.MTH07/A.MTH07 end,
	case A.MTH08 when 0 then 0 else 1.0*B.MTH08/A.MTH08 end,
	case A.MTH09 when 0 then 0 else 1.0*B.MTH09/A.MTH09 end,
	case A.MTH10 when 0 then 0 else 1.0*B.MTH10/A.MTH10 end,
	case A.MTH11 when 0 then 0 else 1.0*B.MTH11/A.MTH11 end,

	case A.MTH12 when 0 then 0 else 1.0*B.MTH12/A.MTH12 end,
	case A.MTH13 when 0 then 0 else 1.0*B.MTH13/A.MTH13 end,
	case A.MTH14 when 0 then 0 else 1.0*B.MTH14/A.MTH14 end,
	case A.MTH15 when 0 then 0 else 1.0*B.MTH15/A.MTH15 end,
	case A.MTH16 when 0 then 0 else 1.0*B.MTH16/A.MTH16 end,
	case A.MTH17 when 0 then 0 else 1.0*B.MTH17/A.MTH17 end,
	case A.MTH18 when 0 then 0 else 1.0*B.MTH18/A.MTH18 end,
	case A.MTH19 when 0 then 0 else 1.0*B.MTH19/A.MTH19 end,
	case A.MTH20 when 0 then 0 else 1.0*B.MTH20/A.MTH20 end,
	case A.MTH21 when 0 then 0 else 1.0*B.MTH21/A.MTH21 end,
	case A.MTH22 when 0 then 0 else 1.0*B.MTH22/A.MTH22 end,
	case A.MTH23 when 0 then 0 else 1.0*B.MTH23/A.MTH23 end,

	case A.MTH24 when 0 then 0 else 1.0*B.MTH24/A.MTH24 end,
	case A.MTH25 when 0 then 0 else 1.0*B.MTH25/A.MTH25 end,
	case A.MTH26 when 0 then 0 else 1.0*B.MTH26/A.MTH26 end,
	case A.MTH27 when 0 then 0 else 1.0*B.MTH27/A.MTH27 end,
	case A.MTH28 when 0 then 0 else 1.0*B.MTH28/A.MTH28 end,
	case A.MTH29 when 0 then 0 else 1.0*B.MTH29/A.MTH29 end,
	case A.MTH30 when 0 then 0 else 1.0*B.MTH30/A.MTH30 end,
	case A.MTH31 when 0 then 0 else 1.0*B.MTH31/A.MTH31 end,
	case A.MTH32 when 0 then 0 else 1.0*B.MTH32/A.MTH32 end,
	case A.MTH33 when 0 then 0 else 1.0*B.MTH33/A.MTH33 end,
	case A.MTH34 when 0 then 0 else 1.0*B.MTH34/A.MTH34 end,
	case A.MTH35 when 0 then 0 else 1.0*B.MTH35/A.MTH35 end

from (select * from MID_OutputProdSalesPerformanceInChina_R777 where [type]='Market') A 
left join (select * from MID_OutputProdSalesPerformanceInChina_R777 where [type]='product' ) B
on A.Period=b.Period and A.Moneytype=B.Moneytype and A.market=B.market
go

update MID_OutputProdSalesPerformanceInChina_R777
set [Type]=prod_des+' Sales' where [type]='Product'
go

update MID_OutputProdSalesPerformanceInChina_R777
set [Type]=prod_des+' '+[Type] 
where TypeIdx=3
go

insert into MID_OutputProdSalesPerformanceInChina_R777--([Type] ,[Period],[MoneyType],Market,[Prod_cod],[Prod_des],[Mat00],[Mat12],[Mat24],[Mat36],[Mat48])
select 5,'Baraclude Share Of ETV',A.Period,A.Moneytype,A.Market,B.prod_cod,B.prod_des,
case A.MTH00 when 0 then 0 else 1.0*B.MTH00/A.MTH00 end,
case A.MTH01 when 0 then 0 else 1.0*B.MTH01/A.MTH01 end,
case A.MTH02 when 0 then 0 else 1.0*B.MTH02/A.MTH02 end,
case A.MTH03 when 0 then 0 else 1.0*B.MTH03/A.MTH03 end,
case A.MTH04 when 0 then 0 else 1.0*B.MTH04/A.MTH04 end,
case A.MTH05 when 0 then 0 else 1.0*B.MTH05/A.MTH05 end,
case A.MTH06 when 0 then 0 else 1.0*B.MTH06/A.MTH06 end,
case A.MTH07 when 0 then 0 else 1.0*B.MTH07/A.MTH07 end,
case A.MTH08 when 0 then 0 else 1.0*B.MTH08/A.MTH08 end,
case A.MTH09 when 0 then 0 else 1.0*B.MTH09/A.MTH09 end,
case A.MTH10 when 0 then 0 else 1.0*B.MTH10/A.MTH10 end,
case A.MTH11 when 0 then 0 else 1.0*B.MTH11/A.MTH11 end,

case A.MTH12 when 0 then 0 else 1.0*B.MTH12/A.MTH12 end,
case A.MTH13 when 0 then 0 else 1.0*B.MTH13/A.MTH13 end,
case A.MTH14 when 0 then 0 else 1.0*B.MTH14/A.MTH14 end,
case A.MTH15 when 0 then 0 else 1.0*B.MTH15/A.MTH15 end,
case A.MTH16 when 0 then 0 else 1.0*B.MTH16/A.MTH16 end,
case A.MTH17 when 0 then 0 else 1.0*B.MTH17/A.MTH17 end,
case A.MTH18 when 0 then 0 else 1.0*B.MTH18/A.MTH18 end,
case A.MTH19 when 0 then 0 else 1.0*B.MTH19/A.MTH19 end,
case A.MTH20 when 0 then 0 else 1.0*B.MTH20/A.MTH20 end,
case A.MTH21 when 0 then 0 else 1.0*B.MTH21/A.MTH21 end,
case A.MTH22 when 0 then 0 else 1.0*B.MTH22/A.MTH22 end,
case A.MTH23 when 0 then 0 else 1.0*B.MTH23/A.MTH23 end,

case A.MTH24 when 0 then 0 else 1.0*B.MTH24/A.MTH24 end,
case A.MTH25 when 0 then 0 else 1.0*B.MTH25/A.MTH25 end,
case A.MTH26 when 0 then 0 else 1.0*B.MTH26/A.MTH26 end,
case A.MTH27 when 0 then 0 else 1.0*B.MTH27/A.MTH27 end,
case A.MTH28 when 0 then 0 else 1.0*B.MTH28/A.MTH28 end,
case A.MTH29 when 0 then 0 else 1.0*B.MTH29/A.MTH29 end,
case A.MTH30 when 0 then 0 else 1.0*B.MTH30/A.MTH30 end,
case A.MTH31 when 0 then 0 else 1.0*B.MTH31/A.MTH31 end,
case A.MTH32 when 0 then 0 else 1.0*B.MTH32/A.MTH32 end,
case A.MTH33 when 0 then 0 else 1.0*B.MTH33/A.MTH33 end,
case A.MTH34 when 0 then 0 else 1.0*B.MTH34/A.MTH34 end,
case A.MTH35 when 0 then 0 else 1.0*B.MTH35/A.MTH35 end

from (select * from MID_OutputProdSalesPerformanceInChina_R777 where [type]='Molecule') A 
left join (select * from MID_OutputProdSalesPerformanceInChina_R777 where [type]='Baraclude Sales' ) B
on A.Period=b.Period and A.Moneytype=B.Moneytype and A.market=B.market
go



update MID_OutputProdSalesPerformanceInChina_R777
set Prod_des = Prod_des +' MS(%)'
where type = 'ARV Market Share'

update MID_OutputProdSalesPerformanceInChina_R777
set Prod_des = 'BR Of Total ETV(%)'
where type = 'Baraclude Share Of ETV'


GO

-------------------------------
--	Mid table: Monopril CIV-CV modification Slide6
-------------------------------


IF EXISTS(SELECT 1 FROM dbo.SYSOBJECTS WHERE ID = OBJECT_ID(N'OutputPerformanceByBrand_CV_Modi_Slide6') AND TYPE = 'U')
BEGIN
	DROP TABLE OutputPerformanceByBrand_CV_Modi_Slide6
END	
select cast('Volume Trend' as varchar(50)) as Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],
sum(MTH00) as MTH00,
sum(MTH12) as MTH12,
sum(YTD00) as YTD00,
sum(YTD12) as YTD12
into dbo.OutputPerformanceByBrand_CV_Modi_Slide6
from TempCityDashboard 
group by [Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des]
      
      
insert into OutputPerformanceByBrand_CV_Modi_Slide6(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],[Audi_cod],[Audi_des],MTH00,MTH12,YTD00,YTD12)
select cast('Volume Trend' as varchar(50)) as Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,'CHT_' as [Audi_cod],'Nation' as [Audi_des],
sum(MTH00) as MTH00,
sum(MTH12) as MTH12,
sum(YTD00) as YTD00,
sum(YTD12) as YTD12
from TempCHPAPreReports 
group by [Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]   


  

   
      

-- **********************      
-- --Test
-- --select * from OutputPerformanceByBrand_CV_Modi_Slide6 
-- --where market = 'monopril' and mkt = 'HYP'  and prod = '000' and MoneyType = 'US' and Chart = 'Volume Trend'
-- --and class = 'N' and molecule = 'N'

-- --SELECT [Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
-- --      ,[Audi_cod],[Audi_des],SUM(YTD01) AS YTD01, SUM(YTD13) AS YTD13
-- --FROM TempCityDashboard
-- --WHERE market = 'monopril' and mkt = 'HYP'  and prod = '000' and MoneyType = 'US'
-- --and class = 'N' and molecule = 'N'
-- --group by [Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
-- --      ,[Audi_cod],[Audi_des]
-- --ORDER BY AUDI_DES      
-- ************************


--Step1: Insert Monopril Market Value GR
INSERT INTO dbo.OutputPerformanceByBrand_CV_Modi_Slide6(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,YTD00)
SELECT case when mkt='HYP' then 'Monopril Market Value GR' when mkt='CCB' then 'Coniel Market Value GR' end as Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],
      CASE WHEN MTH12 = 0 OR MTH12 IS NULL THEN 0 ELSE 1.0*(MTH00-MTH12)/MTH12 END AS MTH00,
      CASE WHEN YTD12 = 0 OR YTD12 IS NULL THEN 0 ELSE 1.0*(YTD00-YTD12)/YTD12 END AS YTD00
FROM  dbo.OutputPerformanceByBrand_CV_Modi_Slide6     
WHERE ((market = 'monopril' and mkt = 'HYP') or (market='Coniel' and mkt='CCB'))  and prod = '000' and MoneyType = 'US' and Chart = 'Volume Trend'
and class = 'N' and molecule = 'N'

--Step2: Insert Monopril Product Value GR
INSERT INTO  dbo.OutputPerformanceByBrand_CV_Modi_Slide6(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,YTD00)
SELECT case when mkt='HYP' then 'Monopril Product Value GR' when mkt='CCB' then 'Coniel Product Value GR' end as Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],  
      CASE WHEN MTH12 = 0 OR MTH12 IS NULL THEN 0 ELSE 1.0*(MTH00-MTH12)/MTH12 END AS MTH00,
      CASE WHEN YTD12 = 0 OR YTD12 IS NULL THEN 0 ELSE 1.0*(YTD00-YTD12)/YTD12 END AS YTD00
FROM  dbo.OutputPerformanceByBrand_CV_Modi_Slide6
WHERE  ((market = 'monopril' and mkt = 'HYP') or (market='Coniel' and mkt='CCB'))  and MoneyType = 'US' and Chart = 'Volume Trend'
and class = 'N' and molecule = 'N' and prod = '100' 

--Step3: Insert Monopril Product value share of Monpril(HP) Market
INSERT INTO dbo.OutputPerformanceByBrand_CV_Modi_Slide6(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,YTD00,MTH12,YTD12)
SELECT case when a.mkt='HYP' then 'Monopril Product Value Share' when a.mkt='CCB' then 'Coniel Product Value Share' end as Chart,a.[Molecule],a.[Class],a.[mkt],a.Market,a.[mktname],a.[prod],a.[Productname],a.[Moneytype]
      ,a.[Audi_cod],a.[Audi_des],
      CASE WHEN b.MTH00= 0 OR b.MTH00 IS NULL THEN 0 ELSE 1.0*a.MTH00/b.MTH00 END AS MTH00,
      CASE WHEN b.YTD00= 0 OR b.YTD00 IS NULL THEN 0 ELSE 1.0*a.YTD00/b.YTD00 END AS YTD00,
      CASE WHEN b.MTH12= 0 OR b.MTH12 IS NULL THEN 0 ELSE 1.0*a.MTH12/b.MTH12 END AS MTH12,
      CASE WHEN b.YTD12= 0 OR b.YTD12 IS NULL THEN 0 ELSE 1.0*a.YTD12/b.YTD12 END AS YTD12
FROM
(
	SELECT * FROM dbo.OutputPerformanceByBrand_CV_Modi_Slide6
	WHERE((market = 'monopril' and mkt = 'HYP') or (market='Coniel' and mkt='CCB'))  and prod = '000' and MoneyType = 'US' and Chart = 'Volume Trend'
	and class = 'N' and molecule = 'N'
)b join
(
	SELECT * FROM dbo.OutputPerformanceByBrand_CV_Modi_Slide6
	WHERE ((market = 'monopril' and mkt = 'HYP') or (market='Coniel' and mkt='CCB'))  and prod = '100' and MoneyType = 'US' and Chart = 'Volume Trend'
	and class = 'N' and molecule = 'N'
) a on a.market=b.market and a.mkt=b.mkt and a.MoneyType=b.MoneyType and a.Chart=b.Chart and a.Class=b.Class and a.molecule=b.molecule
 and a.Audi_cod=b.Audi_cod and a.Audi_des=b.Audi_des
 
 --Step4: Insert Monopril Product value Share GR 
INSERT INTO dbo.OutputPerformanceByBrand_CV_Modi_Slide6(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,YTD00)
SELECT case when mkt='HYP' then 'Monopril Product Value Share GR' when mkt='CCB' then 'Coniel Product Value Share GR' end as Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],
      1.0*(MTH00 - MTH12) AS MTH00,
      1.0*(YTD00 - YTD12) AS YTD00
FROM  dbo.OutputPerformanceByBrand_CV_Modi_Slide6
WHERE ((market = 'monopril' and mkt = 'HYP') or (market='Coniel' and mkt='CCB'))   and prod = '100' and MoneyType = 'US' and Chart in ( 'Monopril Product Value Share','Coniel Product Value Share')
	and class = 'N' and molecule = 'N'           
	
GO

-------------------------------
--	Mid table: Monopril CIA-CV modification
-------------------------------

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'OutputPerformanceByBrand_CV_Modi_Slide7') AND TYPE = 'U')
BEGIN
	DROP TABLE OutputPerformanceByBrand_CV_Modi_Slide7
END
SELECT * INTO OutputPerformanceByBrand_CV_Modi_Slide7 FROM OutputPerformanceByBrand_CV_Modi_Slide6 
WHERE CHART = 'Volume Trend' AND (PRODUCTNAME<>'ACEI' and audi_des <>'Nation') and mkt in ('HYP','CCB')

insert into OutputPerformanceByBrand_CV_Modi_Slide7(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],[Audi_cod],[Audi_des],MTH00,MTH12,YTD00,YTD12)
select cast('Volume Trend' as varchar(50)) as Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],
	sum(MTH00) as MTH00,
	sum(MTH12) as MTH12,
	sum(YTD00) as YTD00,
	sum(YTD12) as YTD12
from dbo.TempCityDashboard_For_Eliquis  where audi_des not in ('GuangDong','Zhejiang')
group by [Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des]
union all               
--insert into OutputPerformanceByBrand_CV_Modi_Slide6(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],[Audi_cod],[Audi_des],MTH00,MTH12,YTD00,YTD12)
select cast('Volume Trend' as varchar(50)) as Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,'Nation' as [Audi_cod],'Nation' as [Audi_des],
	sum(MTH00) as MTH00,
	sum(MTH12) as MTH12,
	sum(YTD00) as YTD00,
	sum(YTD12) as YTD12
from dbo.TempCHPAPreReports_For_Eliquis 
group by [Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]  



INSERT INTO dbo.OutputPerformanceByBrand_CV_Modi_Slide7(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,MTH12,YTD00,YTD12)
SELECT chart,'N' as molecule,'Y' as Class,mkt,market,mktname,'910' as prod,'ACEI' as productname,moneytype 
	,[Audi_cod],[Audi_des],SUM(MTH00) AS MTH00,SUM(MTH12) AS MTH12,SUM(YTD00) AS YTD00,SUM(YTD12) AS YTD12
FROM OutputPerformanceByBrand_CV_Modi_Slide6 
WHERE PRODUCTNAME IN ('Monopril','Lotensin','Tritace','Acertil') and CHART = 'Volume Trend' and  market = 'monopril' and mkt = 'HYP' and audi_des <>'Nation'
GROUP BY chart,mkt,market,mktname,moneytype,audi_cod,audi_des   


--计算每个产品（包括prod=000的市场）所有城市的销售总和
INSERT INTO dbo.OutputPerformanceByBrand_CV_Modi_Slide7(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,MTH12,YTD00,YTD12)
SELECT 'Volume Trend',
Molecule, class,mkt,Market,mktname,prod,Productname,Moneytype,'Nation','Nation',
	    MTH00,  MTH12,  YTD00,  YTD12
FROM tempCHPAPreReports 
WHERE Market in( 'Monopril','Coniel') and mkt in('CCB', 'HYP') and ( 
--(Molecule = 'N'and class='Y' and Prod='910') or 
(Molecule = 'N' and Class = 'N')) and MoneyType = 'LC'

INSERT INTO dbo.OutputPerformanceByBrand_CV_Modi_Slide7(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,MTH12,YTD00,YTD12)
SELECT 'Volume Trend',
'N' as Molecule, 'Y' as class,mkt,Market,mktname,'910' as prod,'ACEI' as Productname,Moneytype,'Nation','Nation',
	    sum(MTH00) as MTH00,  sum(MTH12) as MTH12,  sum(YTD00) YTD00,  sum(YTD12) YTD12
FROM tempCHPAPreReports 
WHERE Market = 'Monopril' and mkt = 'HYP' 
	and ( 
		--(Molecule = 'N'and class='Y' and Prod='910') or 
		(Molecule = 'N' and Class = 'N')) 
	and MoneyType = 'LC' and productname in ('Monopril','Lotensin','Tritace','Acertil')
GROUP BY mkt,Market,mktname,Moneytype




--计算每个城市的贡献比
INSERT INTO dbo.OutputPerformanceByBrand_CV_Modi_Slide7(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,MTH12,YTD00,YTD12)
SELECT 'City Market&Product Share',
      b.[Molecule],b.[Class],b.[mkt],b.Market,b.[mktname],b.[prod],b.[Productname],b.[Moneytype]
      ,b.[Audi_cod],b.[Audi_des],
      CASE WHEN a.MTH00= 0 OR a.MTH00 IS NULL THEN 0 ELSE 1.0*b.MTH00/a.MTH00 END AS MTH00,
      CASE WHEN a.MTH12= 0 OR a.MTH12 IS NULL THEN 0 ELSE 1.0*b.MTH12/a.MTH12 END AS MTH12,
      CASE WHEN a.YTD00= 0 OR a.YTD00 IS NULL THEN 0 ELSE 1.0*b.YTD00/a.YTD00 END AS YTD00,
      CASE WHEN a.YTD12= 0 OR a.YTD12 IS NULL THEN 0 ELSE 1.0*b.YTD12/a.YTD12 END AS YTD12
      
FROM 
	(
		SELECT * FROM OutputPerformanceByBrand_CV_Modi_Slide7 
		WHERE CHART =  'Volume Trend' and (
			(Market = 'Monopril' and mkt = 'HYP')or (Market='Coniel' and mkt='CCB') or (Market='Eliquis VTEp' and mkt='Eliquis VTEp')
		) and Molecule = 'N' and Class = 'N' and MoneyType = 'LC' and Prod = '000' and Audi_des ='Nation'
	) a join      
	(
		SELECT * FROM OutputPerformanceByBrand_CV_Modi_Slide7
		WHERE CHART =  'Volume Trend' and (
			(Market = 'Monopril' and mkt = 'HYP')or (Market='Coniel' and mkt='CCB')  or (Market='Eliquis VTEp' and mkt='Eliquis VTEp')
			) and Molecule = 'N' and Class = 'N' and MoneyType = 'LC' and Prod = '000' 
	) b
	on a.chart=b.chart and a.market=b.market and a.mkt=b.mkt and a.molecule=b.molecule and a.class=b.class and a.MoneyType=b.MoneyType

--计算每个城市各个产品的market share
INSERT INTO dbo.OutputPerformanceByBrand_CV_Modi_Slide7(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,MTH12,YTD00,YTD12)
SELECT 'City Market&Product Share',
      b.[Molecule],b.[Class],b.[mkt],b.Market,b.[mktname],b.[prod],b.[Productname],b.[Moneytype]
      ,b.[Audi_cod],b.[Audi_des],
      CASE WHEN a.MTH00= 0 OR a.MTH00 IS NULL THEN 0 ELSE 1.0*b.MTH00/a.MTH00 END AS MTH00,
      CASE WHEN a.MTH12= 0 OR a.MTH12 IS NULL THEN 0 ELSE 1.0*b.MTH12/a.MTH12 END AS MTH12,
      CASE WHEN a.YTD00= 0 OR a.YTD00 IS NULL THEN 0 ELSE 1.0*b.YTD00/a.YTD00 END AS YTD00,
      CASE WHEN a.YTD12= 0 OR a.YTD12 IS NULL THEN 0 ELSE 1.0*b.YTD12/a.YTD12 END AS YTD12
      
FROM 
	(
		SELECT * FROM OutputPerformanceByBrand_CV_Modi_Slide7 
		WHERE CHART =  'Volume Trend' and (
			(Market = 'Monopril' and mkt = 'HYP')or (Market='Coniel' and mkt='CCB') or (Market='Eliquis VTEp' and mkt='Eliquis VTEp')
			) and Molecule = 'N' and Class = 'N' and MoneyType = 'LC' and Prod = '000' 
	) a join      
	(
		SELECT * FROM OutputPerformanceByBrand_CV_Modi_Slide7
		WHERE CHART =  'Volume Trend' and (
			(Market = 'Monopril' and mkt = 'HYP')or (Market='Coniel' and mkt='CCB') or (Market='Eliquis VTEp' and mkt='Eliquis VTEp')
			) and Molecule = 'N' and Class = 'N' and MoneyType = 'LC' and Prod <> '000'
	) b
	on a.chart=b.chart and a.market=b.market and a.mkt=b.mkt and a.molecule=b.molecule and a.class=b.class and a.MoneyType=b.MoneyType and a.Audi_des=b.Audi_des


--计算每个城市各个产品的market growth
INSERT INTO dbo.OutputPerformanceByBrand_CV_Modi_Slide7(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,YTD00)
SELECT 'City Product Market GR',
      [Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],
      CASE WHEN MTH12= 0 OR MTH12 IS NULL THEN 0 ELSE 1.0*(MTH00-MTH12)/MTH12 END AS MTH00,      
      CASE WHEN YTD12= 0 OR YTD12 IS NULL THEN 0 ELSE 1.0*(YTD00-YTD12)/YTD12 END AS YTD00      
FROM OutputPerformanceByBrand_CV_Modi_Slide7
WHERE CHART =  'Volume Trend' and (
	(Market = 'Monopril' and mkt = 'HYP')or (Market='Coniel' and mkt='CCB') or (Market='Eliquis VTEp' and mkt='Eliquis VTEp')
) and Molecule = 'N' and Class = 'N' and MoneyType = 'LC'



--计算ACEI&CCB的市场销量和销量的GR
--销量
INSERT INTO OutputPerformanceByBrand_CV_Modi_Slide7 (Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,MTH12,YTD00,YTD12)
SELECT 'ACEI Market Size',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,MTH12,YTD00,YTD12
FROM OutputPerformanceByBrand_CV_Modi_Slide7 
WHERE mkt = 'hyp' and market = 'monopril' and molecule = 'N' and class='Y' and ProductName = 'ACEI' and MONEYTYPE= 'LC' and chart = 'Volume Trend'

INSERT INTO OutputPerformanceByBrand_CV_Modi_Slide7 (Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,MTH12,YTD00,YTD12)
SELECT 'CCB Market Size',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,MTH12,YTD00,YTD12
FROM OutputPerformanceByBrand_CV_Modi_Slide7 
WHERE mkt = 'ccb' and market = 'coniel' and molecule = 'N' and class='N' and ProductName = 'CCB Market' and MONEYTYPE= 'LC' and chart = 'Volume Trend'

INSERT INTO OutputPerformanceByBrand_CV_Modi_Slide7 (Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,MTH12,YTD00,YTD12)
SELECT 'VTEp Market Size',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,MTH12,YTD00,YTD12
FROM OutputPerformanceByBrand_CV_Modi_Slide7 
WHERE mkt = 'Eliquis VTEp' and market = 'Eliquis VTEp' and molecule = 'N' and class='N' and ProductName = 'VTEp Market' and MONEYTYPE= 'LC' and chart = 'Volume Trend'

--GR
INSERT INTO OutputPerformanceByBrand_CV_Modi_Slide7 (Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,YTD00)
SELECT 'ACEI Market GR',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],
      CASE WHEN MTH12= 0 OR MTH12 IS NULL THEN 0 ELSE 1.0*(MTH00-MTH12)/MTH12 END AS MTH00,
      CASE WHEN YTD12= 0 OR YTD12 IS NULL THEN 0 ELSE 1.0*(YTD00-YTD12)/YTD12 END AS YTD00
FROM  OutputPerformanceByBrand_CV_Modi_Slide7  
WHERE mkt = 'hyp' and market = 'monopril' and molecule = 'N' and class='Y' and ProductName = 'ACEI' and MONEYTYPE= 'LC' and chart = 'Volume Trend'  

INSERT INTO OutputPerformanceByBrand_CV_Modi_Slide7 (Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,YTD00)
SELECT 'CCB Market GR',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],
      CASE WHEN MTH12= 0 OR MTH12 IS NULL THEN 0 ELSE 1.0*(MTH00-MTH12)/MTH12 END AS MTH00,
      CASE WHEN YTD12= 0 OR YTD12 IS NULL THEN 0 ELSE 1.0*(YTD00-YTD12)/YTD12 END AS YTD00
FROM  OutputPerformanceByBrand_CV_Modi_Slide7  
WHERE mkt = 'ccb' and market = 'coniel' and molecule = 'N' and class='N' and ProductName = 'CCB Market' and MONEYTYPE= 'LC' and chart = 'Volume Trend'

INSERT INTO OutputPerformanceByBrand_CV_Modi_Slide7 (Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],MTH00,YTD00)
SELECT 'VTEp Market GR',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],
      CASE WHEN MTH12= 0 OR MTH12 IS NULL THEN 0 ELSE 1.0*(MTH00-MTH12)/MTH12 END AS MTH00,
      CASE WHEN YTD12= 0 OR YTD12 IS NULL THEN 0 ELSE 1.0*(YTD00-YTD12)/YTD12 END AS YTD00
FROM  OutputPerformanceByBrand_CV_Modi_Slide7  
WHERE mkt = 'Eliquis VTEp' and market = 'Eliquis VTEp' and molecule = 'N' and class='N' and ProductName = 'VTEp Market' and MONEYTYPE= 'LC' and chart = 'Volume Trend'

	
--提取数据并生成Rank


-- prod	productname
-- 000	Hypertension Market
-- 100	Monopril
-- 200	Acertil
-- 700	Lotensin
-- 800	Tritace

go
IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'OutputPerformanceByBrand_CV_Modi_Slide7_Rank') AND TYPE = 'U')
BEGIN
	DROP TABLE OutputPerformanceByBrand_CV_Modi_Slide7_Rank
END
go

DECLARE @city_Num int
SELECT @city_Num=COUNT(DISTINCT AUDI_DES) FROM OutputPerformanceByBrand_CV_Modi_Slide7 where market='Monopril'

SELECT 
	case when a.Audi_des='Nation' then @city_Num else a.row_Num -1 end as row_Num,
	case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end as Audi_des ,
	a.market,
	a.MoneyType,
	a.City_CON_Percentage
	,b.Monopril_MS
	,c.Monopril_GR 
	,d.Acertil_MS 
	,e.Acertil_GR
	,f.Lotensin_MS
	,g.Lotensin_GR
	,h.ACEI_MS_Size
	,i.ACEI_GR
INTO OutputPerformanceByBrand_CV_Modi_Slide7_Rank
FROM 
	(
		SELECT Audi_des,market,MoneyType,City_CON_Percentage,ROW_NUMBER() over(partition by market order by City_CON_Percentage DESC) AS row_Num FROM (
			SELECT Audi_des,market,MoneyType, YTD00 AS City_CON_Percentage
			FROM OutputPerformanceByBrand_CV_Modi_Slide7 
			WHERE CHART = 'City Market&Product Share' AND PROD='000' AND [Molecule] = 'N' AND CLASS = 'N' and market='Monopril'
		) t
	)	a
	join
	(
		SELECT Market,Audi_des, YTD00 AS Monopril_MS
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Market&Product Share' AND PROD = '100' AND [Molecule] = 'N' AND CLASS = 'N'
	) b on a.Audi_des=b.Audi_des and a.Market=b.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Monopril_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Product Market GR' AND PROD = '100' AND [Molecule] = 'N' AND CLASS = 'N'
	) c on c.Audi_des=b.Audi_des and a.Market=c.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Acertil_MS
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Market&Product Share' AND PROD = '200' AND [Molecule] = 'N' AND CLASS = 'N'
	) d on c.Audi_des=d.Audi_des and a.Market=d.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Acertil_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Product Market GR' AND PROD = '200' AND [Molecule] = 'N' AND CLASS = 'N'
	) e on e.Audi_des=d.Audi_des and a.Market=e.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Lotensin_MS
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Market&Product Share' AND PROD = '700' AND [Molecule] = 'N' AND CLASS = 'N'
	) f on f.Audi_des=e.Audi_des and a.Market=f.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Lotensin_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Product Market GR' AND PROD = '700' AND [Molecule] = 'N' AND CLASS = 'N'
	) g on g.Audi_des=f.Audi_des and a.Market=g.Market
	join
	(
		SELECT Market,Audi_des, YTD00 AS ACEI_MS_Size
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART =  'ACEI Market Size' AND PROD = '910' AND [Molecule] = 'N' AND CLASS = 'Y'
	) h on h.Audi_des=g.Audi_des and a.Market=h.Market
	join
	(
		SELECT Market,Audi_des, YTD00 AS ACEI_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART =  'ACEI Market GR' AND PROD = '910' AND [Molecule] = 'N' AND CLASS = 'Y'
	) i on i.Audi_des=h.Audi_des and a.Market=i.Market
--where a.Audi_des<>'Nanchang'	
order by row_num	


GO


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'OutputPerformanceByBrand_CV_Modi_Slide7_Rank_Coniel') AND TYPE = 'U')
BEGIN
	DROP TABLE OutputPerformanceByBrand_CV_Modi_Slide7_Rank_Coniel
END
GO
DECLARE @city_Num int
SELECT @city_Num=COUNT(DISTINCT AUDI_DES) FROM OutputPerformanceByBrand_CV_Modi_Slide7 where market='Coniel'

SELECT 
	case when a.Audi_des='Nation' then @city_Num else a.row_Num -1 end as row_Num,case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end as Audi_des ,
	a.market,
	a.MoneyType,
	a.City_CON_Percentage
	,b.Coniel_MS
	,c.Coniel_GR 
	,d.Yuan_Zhi_MS 
	,e.Yuan_Zhi_GR
	,f.Lacipil_MS
	,g.Lacipil_GR
	,h.Zanidip_MS
	,i.Zanidip_GR
	,j.Norvasc_MS
	,k.Norvasc_GR
	,l.Adalat_MS
	,m.Adalat_GR
	,n.Plendil_MS
	,o.Plendil_GR
	,p.CCB_MS_Size
	,q.CCB_GR
INTO OutputPerformanceByBrand_CV_Modi_Slide7_Rank_Coniel
FROM 
	(
		SELECT Audi_des,market,MoneyType,City_CON_Percentage,ROW_NUMBER() over(partition by market order by City_CON_Percentage DESC) AS row_Num FROM (
			SELECT Audi_des,market,MoneyType, YTD00 AS City_CON_Percentage
			FROM OutputPerformanceByBrand_CV_Modi_Slide7 
			WHERE CHART = 'City Market&Product Share' AND PROD='000' AND [Molecule] = 'N' AND CLASS = 'N' and market='Coniel'
		) t
	)	a
	join
	(
		SELECT Market,Audi_des, YTD00 AS Coniel_MS
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Market&Product Share' AND PROD = '100' AND [Molecule] = 'N' AND CLASS = 'N'
	) b on a.Audi_des=b.Audi_des and a.Market=b.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Coniel_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Product Market GR' AND PROD = '100' AND [Molecule] = 'N' AND CLASS = 'N'
	) c on c.Audi_des=b.Audi_des and a.Market=c.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Yuan_Zhi_MS
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Market&Product Share' AND PROD = '200' AND [Molecule] = 'N' AND CLASS = 'N'
	) d on c.Audi_des=d.Audi_des and a.Market=d.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Yuan_Zhi_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Product Market GR' AND PROD = '200' AND [Molecule] = 'N' AND CLASS = 'N'
	) e on e.Audi_des=d.Audi_des and a.Market=e.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Lacipil_MS
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Market&Product Share' AND PROD = '300' AND [Molecule] = 'N' AND CLASS = 'N'
	) f on f.Audi_des=e.Audi_des and a.Market=f.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Lacipil_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Product Market GR' AND PROD = '300' AND [Molecule] = 'N' AND CLASS = 'N'
	) g on g.Audi_des=f.Audi_des and a.Market=g.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Zanidip_MS
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Market&Product Share' AND PROD = '400' AND [Molecule] = 'N' AND CLASS = 'N'
	) h on a.Audi_des=h.Audi_des and a.Market=h.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Zanidip_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Product Market GR' AND PROD = '400' AND [Molecule] = 'N' AND CLASS = 'N'
	) i on a.Audi_des=i.Audi_des and a.Market=i.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Norvasc_MS
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Market&Product Share' AND PROD = '500' AND [Molecule] = 'N' AND CLASS = 'N'
	) j on a.Audi_des=j.Audi_des and a.Market=j.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Norvasc_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Product Market GR' AND PROD = '500' AND [Molecule] = 'N' AND CLASS = 'N'
	) k on a.Audi_des=k.Audi_des and a.Market=k.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Adalat_MS
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Market&Product Share' AND PROD = '600' AND [Molecule] = 'N' AND CLASS = 'N'
	) l on a.Audi_des=l.Audi_des and a.Market=l.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Adalat_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Product Market GR' AND PROD = '600' AND [Molecule] = 'N' AND CLASS = 'N'
	) m on a.Audi_des=m.Audi_des and a.Market=m.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Plendil_MS
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Market&Product Share' AND PROD = '700' AND [Molecule] = 'N' AND CLASS = 'N'
	) n on a.Audi_des=n.Audi_des and a.Market=n.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Plendil_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Product Market GR' AND PROD = '700' AND [Molecule] = 'N' AND CLASS = 'N'
	) o on a.Audi_des=o.Audi_des and a.Market=o.Market
	join
	(
		SELECT Market,Audi_des, YTD00 AS CCB_MS_Size
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART =  'CCB Market Size' AND PROD = '000' AND [Molecule] = 'N' AND CLASS = 'N'
	) p on a.Audi_des=p.Audi_des and a.Market=p.Market
	join
	(
		SELECT Market,Audi_des, YTD00 AS CCB_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART =  'CCB Market GR' AND PROD = '000' AND [Molecule] = 'N' AND CLASS = 'N'
	) q on a.Audi_des=q.Audi_des and a.Market=q.Market
--where a.Audi_des<>'Nanchang'	
order by row_num	


GO


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'OutputPerformanceByBrand_CV_Modi_Slide7_Rank_Eliquis') AND TYPE = 'U')
BEGIN
	DROP TABLE OutputPerformanceByBrand_CV_Modi_Slide7_Rank_Eliquis
END
GO
DECLARE @city_Num int
SELECT @city_Num=COUNT(DISTINCT AUDI_DES) FROM OutputPerformanceByBrand_CV_Modi_Slide7 where market='Eliquis VTEp'
SELECT 
	case when a.Audi_des='Nation' then @city_Num else a.row_Num -1 end as row_Num,case when a.Audi_des='Nation' then 'China(CHPA)' else a.Audi_des end as Audi_des ,
	a.market,
	a.MoneyType,
	a.City_CON_Percentage
	,b.Eliquis_MS
	,c.Eliquis_GR 
	,d.Clexane_MS 
	,e.Clexane_GR
	,f.Xarelto_MS
	,g.Xarelto_GR
	,h.Fraxiparine_MS
	,i.Fraxiparine_GR
	,j.Arixtra_MS
	,k.Arixtra_GR
	,p.VTEp_MS_Size
	,q.VTEp_GR
INTO OutputPerformanceByBrand_CV_Modi_Slide7_Rank_Eliquis
FROM 
	(
		SELECT Audi_des,market,MoneyType,City_CON_Percentage,ROW_NUMBER() over(partition by market order by City_CON_Percentage DESC) AS row_Num FROM (
			SELECT Audi_des,market,MoneyType, YTD00 AS City_CON_Percentage
			FROM OutputPerformanceByBrand_CV_Modi_Slide7 
			WHERE CHART = 'City Market&Product Share' AND PROD='000' AND [Molecule] = 'N' AND CLASS = 'N' and market='Eliquis VTEp'
		) t
	)	a
	join
	(
		SELECT Market,Audi_des, YTD00 AS Eliquis_MS
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Market&Product Share' AND PROD = '100' AND [Molecule] = 'N' AND CLASS = 'N'
	) b on a.Audi_des=b.Audi_des and a.Market=b.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Eliquis_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Product Market GR' AND PROD = '100' AND [Molecule] = 'N' AND CLASS = 'N'
	) c on c.Audi_des=b.Audi_des and a.Market=c.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Clexane_MS
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Market&Product Share' AND PROD = '200' AND [Molecule] = 'N' AND CLASS = 'N'
	) d on c.Audi_des=d.Audi_des and a.Market=d.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Clexane_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Product Market GR' AND PROD = '200' AND [Molecule] = 'N' AND CLASS = 'N'
	) e on e.Audi_des=d.Audi_des and a.Market=e.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Xarelto_MS
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Market&Product Share' AND PROD = '300' AND [Molecule] = 'N' AND CLASS = 'N'
	) f on f.Audi_des=e.Audi_des and a.Market=f.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Xarelto_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Product Market GR' AND PROD = '300' AND [Molecule] = 'N' AND CLASS = 'N'
	) g on g.Audi_des=f.Audi_des and a.Market=g.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Fraxiparine_MS
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Market&Product Share' AND PROD = '400' AND [Molecule] = 'N' AND CLASS = 'N'
	) h on a.Audi_des=h.Audi_des and a.Market=h.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Fraxiparine_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Product Market GR' AND PROD = '400' AND [Molecule] = 'N' AND CLASS = 'N'
	) i on a.Audi_des=i.Audi_des and a.Market=i.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Arixtra_MS
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Market&Product Share' AND PROD = '500' AND [Molecule] = 'N' AND CLASS = 'N'
	) j on a.Audi_des=j.Audi_des and a.Market=j.Market
	join
	(
		SELECT Market,Audi_des,YTD00 AS Arixtra_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART = 'City Product Market GR' AND PROD = '500' AND [Molecule] = 'N' AND CLASS = 'N'
	) k on a.Audi_des=k.Audi_des and a.Market=k.Market
	
	join
	(
		SELECT Market,Audi_des, YTD00 AS VTEp_MS_Size
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART =  'VTEp Market Size' AND PROD = '000' AND [Molecule] = 'N' AND CLASS = 'N'
	) p on a.Audi_des=p.Audi_des and a.Market=p.Market
	join
	(
		SELECT Market,Audi_des, YTD00 AS VTEp_GR
		FROM OutputPerformanceByBrand_CV_Modi_Slide7 WHERE CHART =  'VTEp Market GR' AND PROD = '000' AND [Molecule] = 'N' AND CLASS = 'N'
	) q on a.Audi_des=q.Audi_des and a.Market=q.Market
--where a.Audi_des<>'Nanchang'	
order by row_num	
GO




-------------------------------
--	Mid table: Monopril CIA-CV modification Slide 5 Xiaoyu.Chen 20130905
-------------------------------


IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'OutputPerformanceByBrand_CV_Modi_Slide5') and type ='U')
BEGIN
	DROP TABLE OutputPerformanceByBrand_CV_Modi_Slide5
END

SELECT CAST('Volume Trend' AS NVARCHAR(100)) AS TYPE,
Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,
MTH00,
MTH01,
MTH02,
MTH03,
MTH04,
MTH05,
MTH06,
MTH07,
MTH08,
MTH09,
MTH10,
MTH11,
MTH12,
MTH13,
MTH14,
--MTH15,
--MTH16,
--MTH17,
--MTH18,
--MTH19,
--MTH20,
--MTH21,
--MTH22,
--MTH23,
--MTH24,
--MTH25,
MAT00,
MAT01,
MAT02,
MAT03,
MAT04,
MAT05,
MAT06,
MAT07,
MAT08,
MAT09,
MAT10,
MAT11,
MAT12,
MAT13,
MAT14,
--MAT15,
--MAT16,
--MAT17,
--MAT18,
--MAT19,
--MAT20,
--MAT21,
--MAT22,
--MAT23,
--MAT24,
--MAT25,
YTD00,
YTD12
INTO OutputPerformanceByBrand_CV_Modi_Slide5 FROM dbo.TempCHPAPreReports 
go


--Insert Value & Volume share to table
INSERT INTO OutputPerformanceByBrand_CV_Modi_Slide5(TYPE,
Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,
MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12,MTH13,MTH14,
--MTH15,MTH16,MTH17,MTH18,MTH19,MTH20,MTH21,MTH22,MTH23,MTH24,MTH25,  
MAT00,MAT01,MAT02,MAT03,MAT04,MAT05,MAT06,MAT07,MAT08,MAT09,MAT10,MAT11,MAT12,MAT13,MAT14,
--MAT15,MAT16,MAT17,MAT18,MAT19,MAT20,MAT21,MAT22,MAT23,MAT24,MAT25,
YTD00,YTD12
)
SELECT CASE WHEN b.Moneytype = 'UN' THEN 'Volume Share'
			WHEN b.Moneytype = 'US' THEN 'Value Share' ELSE '' END AS [Type], 
	   b.Molecule,b.Class,b.mkt,b.mktname,b.Market,b.prod,b.Productname,b.Moneytype,
	 CASE WHEN a.MTH00 = 0 OR a.MTH00 IS NULL THEN 0 ELSE 1.0*b.MTH00/a.MTH00 END AS MTH00,
	 CASE WHEN a.MTH01 = 0 OR a.MTH01 IS NULL THEN 0 ELSE 1.0*b.MTH01/a.MTH01 END AS MTH01,
	 CASE WHEN a.MTH02 = 0 OR a.MTH02 IS NULL THEN 0 ELSE 1.0*b.MTH02/a.MTH02 END AS MTH02,
	 CASE WHEN a.MTH03 = 0 OR a.MTH03 IS NULL THEN 0 ELSE 1.0*b.MTH03/a.MTH03 END AS MTH03,
	 CASE WHEN a.MTH04 = 0 OR a.MTH04 IS NULL THEN 0 ELSE 1.0*b.MTH04/a.MTH04 END AS MTH04,
	 CASE WHEN a.MTH05 = 0 OR a.MTH05 IS NULL THEN 0 ELSE 1.0*b.MTH05/a.MTH05 END AS MTH05,
	 CASE WHEN a.MTH06 = 0 OR a.MTH06 IS NULL THEN 0 ELSE 1.0*b.MTH06/a.MTH06 END AS MTH06,
	 CASE WHEN a.MTH07 = 0 OR a.MTH07 IS NULL THEN 0 ELSE 1.0*b.MTH07/a.MTH07 END AS MTH07,
	 CASE WHEN a.MTH08 = 0 OR a.MTH08 IS NULL THEN 0 ELSE 1.0*b.MTH08/a.MTH08 END AS MTH08,
	 CASE WHEN a.MTH09 = 0 OR a.MTH09 IS NULL THEN 0 ELSE 1.0*b.MTH09/a.MTH09 END AS MTH09,
	 CASE WHEN a.MTH10 = 0 OR a.MTH10 IS NULL THEN 0 ELSE 1.0*b.MTH10/a.MTH10 END AS MTH10,
	 CASE WHEN a.MTH11 = 0 OR a.MTH11 IS NULL THEN 0 ELSE 1.0*b.MTH11/a.MTH11 END AS MTH11,
	 CASE WHEN a.MTH12 = 0 OR a.MTH12 IS NULL THEN 0 ELSE 1.0*b.MTH12/a.MTH12 END AS MTH12,
	 CASE WHEN a.MTH13 = 0 OR a.MTH13 IS NULL THEN 0 ELSE 1.0*b.MTH13/a.MTH13 END AS MTH13,
	 CASE WHEN a.MTH14 = 0 OR a.MTH14 IS NULL THEN 0 ELSE 1.0*b.MTH14/a.MTH14 END AS MTH14,
	 --CASE WHEN a.MTH15 = 0 OR a.MTH15 IS NULL THEN 0 ELSE 1.0*b.MTH15/a.MTH15 END AS MTH15,
	 --CASE WHEN a.MTH16 = 0 OR a.MTH16 IS NULL THEN 0 ELSE 1.0*b.MTH16/a.MTH16 END AS MTH16,
	 --CASE WHEN a.MTH17 = 0 OR a.MTH17 IS NULL THEN 0 ELSE 1.0*b.MTH17/a.MTH17 END AS MTH17,
	 --CASE WHEN a.MTH18 = 0 OR a.MTH18 IS NULL THEN 0 ELSE 1.0*b.MTH18/a.MTH18 END AS MTH18,
	 --CASE WHEN a.MTH19 = 0 OR a.MTH19 IS NULL THEN 0 ELSE 1.0*b.MTH19/a.MTH19 END AS MTH19,
	 --CASE WHEN a.MTH20 = 0 OR a.MTH20 IS NULL THEN 0 ELSE 1.0*b.MTH20/a.MTH20 END AS MTH20,
	 --CASE WHEN a.MTH21 = 0 OR a.MTH21 IS NULL THEN 0 ELSE 1.0*b.MTH21/a.MTH21 END AS MTH21,
	 --CASE WHEN a.MTH22 = 0 OR a.MTH22 IS NULL THEN 0 ELSE 1.0*b.MTH22/a.MTH22 END AS MTH22,
	 --CASE WHEN a.MTH23 = 0 OR a.MTH23 IS NULL THEN 0 ELSE 1.0*b.MTH23/a.MTH23 END AS MTH23,
	 --CASE WHEN a.MTH24 = 0 OR a.MTH24 IS NULL THEN 0 ELSE 1.0*b.MTH24/a.MTH24 END AS MTH24,
	 --CASE WHEN a.MTH25 = 0 OR a.MTH25 IS NULL THEN 0 ELSE 1.0*b.MTH25/a.MTH25 END AS MTH25,
	 CASE WHEN a.MAT00 = 0 OR a.MAT00 IS NULL THEN 0 ELSE 1.0*b.MAT00/a.MAT00 END AS MAT00,
	 CASE WHEN a.MAT01 = 0 OR a.MAT01 IS NULL THEN 0 ELSE 1.0*b.MAT01/a.MAT01 END AS MAT01,
	 CASE WHEN a.MAT02 = 0 OR a.MAT02 IS NULL THEN 0 ELSE 1.0*b.MAT02/a.MAT02 END AS MAT02,
	 CASE WHEN a.MAT03 = 0 OR a.MAT03 IS NULL THEN 0 ELSE 1.0*b.MAT03/a.MAT03 END AS MAT03,
	 CASE WHEN a.MAT04 = 0 OR a.MAT04 IS NULL THEN 0 ELSE 1.0*b.MAT04/a.MAT04 END AS MAT04,
	 CASE WHEN a.MAT05 = 0 OR a.MAT05 IS NULL THEN 0 ELSE 1.0*b.MAT05/a.MAT05 END AS MAT05,
	 CASE WHEN a.MAT06 = 0 OR a.MAT06 IS NULL THEN 0 ELSE 1.0*b.MAT06/a.MAT06 END AS MAT06,
	 CASE WHEN a.MAT07 = 0 OR a.MAT07 IS NULL THEN 0 ELSE 1.0*b.MAT07/a.MAT07 END AS MAT07,
	 CASE WHEN a.MAT08 = 0 OR a.MAT08 IS NULL THEN 0 ELSE 1.0*b.MAT08/a.MAT08 END AS MAT08,
	 CASE WHEN a.MAT09 = 0 OR a.MAT09 IS NULL THEN 0 ELSE 1.0*b.MAT09/a.MAT09 END AS MAT09,
	 CASE WHEN a.MAT10 = 0 OR a.MAT10 IS NULL THEN 0 ELSE 1.0*b.MAT10/a.MAT10 END AS MAT10,
	 CASE WHEN a.MAT11 = 0 OR a.MAT11 IS NULL THEN 0 ELSE 1.0*b.MAT11/a.MAT11 END AS MAT11,
	 CASE WHEN a.MAT12 = 0 OR a.MAT12 IS NULL THEN 0 ELSE 1.0*b.MAT12/a.MAT12 END AS MAT12,
	 CASE WHEN a.MAT13 = 0 OR a.MAT13 IS NULL THEN 0 ELSE 1.0*b.MAT13/a.MAT13 END AS MAT13,
	 CASE WHEN a.MAT14 = 0 OR a.MAT14 IS NULL THEN 0 ELSE 1.0*b.MAT14/a.MAT14 END AS MAT14,
	 --CASE WHEN a.MAT15 = 0 OR a.MAT15 IS NULL THEN 0 ELSE 1.0*b.MAT15/a.MAT15 END AS MAT15,
	 --CASE WHEN a.MAT16 = 0 OR a.MAT16 IS NULL THEN 0 ELSE 1.0*b.MAT16/a.MAT16 END AS MAT16,
	 --CASE WHEN a.MAT17 = 0 OR a.MAT17 IS NULL THEN 0 ELSE 1.0*b.MAT17/a.MAT17 END AS MAT17,
	 --CASE WHEN a.MAT18 = 0 OR a.MAT18 IS NULL THEN 0 ELSE 1.0*b.MAT18/a.MAT18 END AS MAT18,
	 --CASE WHEN a.MAT19 = 0 OR a.MAT19 IS NULL THEN 0 ELSE 1.0*b.MAT19/a.MAT19 END AS MAT19,
	 --CASE WHEN a.MAT20 = 0 OR a.MAT20 IS NULL THEN 0 ELSE 1.0*b.MAT20/a.MAT20 END AS MAT20,
	 --CASE WHEN a.MAT21 = 0 OR a.MAT21 IS NULL THEN 0 ELSE 1.0*b.MAT21/a.MAT21 END AS MAT21,
	 --CASE WHEN a.MAT22 = 0 OR a.MAT22 IS NULL THEN 0 ELSE 1.0*b.MAT22/a.MAT22 END AS MAT22,
	 --CASE WHEN a.MAT23 = 0 OR a.MAT23 IS NULL THEN 0 ELSE 1.0*b.MAT23/a.MAT23 END AS MAT23,
	 --CASE WHEN a.MAT24 = 0 OR a.MAT24 IS NULL THEN 0 ELSE 1.0*b.MAT24/a.MAT24 END AS MAT24,
	 --CASE WHEN a.MAT25 = 0 OR a.MAT25 IS NULL THEN 0 ELSE 1.0*b.MAT25/a.MAT25 END AS MAT25,
	 CASE WHEN a.YTD00 = 0 OR a.YTD00 IS NULL THEN 0 ELSE 1.0*b.YTD00/a.YTD00 END AS YTD00,
	 CASE WHEN a.YTD12 = 0 OR a.YTD12 IS NULL THEN 0 ELSE 1.0*b.YTD12/a.YTD12 END AS YTD12
	   
FROM 
(
	SELECT * FROM dbo.OutputPerformanceByBrand_CV_Modi_Slide5 
	WHERE market in ('Coniel', 'Monopril') AND Moneytype IN ('US','UN') AND MOLECULE = 'N' AND CLASS = 'N' AND MKT in ('CCB','HYP') AND Prod ='000' AND type= 'Volume Trend'
) a	join
(
	SELECT * FROM dbo.OutputPerformanceByBrand_CV_Modi_Slide5
	WHERE market in ('Coniel', 'Monopril') AND Moneytype IN ('US','UN') AND MOLECULE = 'N' AND CLASS = 'N' AND MKT in ('CCB','HYP') AND Prod <> '000' AND type= 'Volume Trend'
) b ON a.Molecule=b.Molecule AND a.Class=b.Class AND a.mkt=b.mkt AND a.mktname=b.mktname AND a.Market=b.Market AND a.Moneytype = b.Moneytype




--Inset Volume & Value Growth data into table
INSERT INTO OutputPerformanceByBrand_CV_Modi_Slide5 (TYPE,
Molecule,Class,mkt,mktname,Market,prod,Productname,Moneytype,
MTH00,MAT00,YTD00)
SELECT 
	  CASE WHEN Moneytype = 'US' THEN 'Value GR' WHEN Moneytype='UN' THEN 'Volume GR' ELSE '' END AS TYPE,
	  Molecule, Class,mkt,mktname,Market,Prod,Productname,Moneytype,
	  CASE WHEN MTH12 = 0 OR MTH12 IS NULL THEN 0 ELSE 1.0*(MTH00-MTH12)/MTH12 END AS MTH00,
	  CASE WHEN MAT12 = 0 OR MAT12 IS NULL THEN 0 ELSE 1.0*(MAT00-MAT12)/MAT12 END AS MAT00,
	  CASE WHEN YTD12 = 0 OR YTD12 IS NULL THEN 0 ELSE 1.0*(YTD00-YTD12)/YTD12 END AS YTD00	  
FROM OutputPerformanceByBrand_CV_Modi_Slide5
WHERE market in ('Coniel', 'Monopril') AND Moneytype IN ('US','UN') AND MOLECULE = 'N' AND CLASS = 'N' AND MKT  in ('HYP','CCB') AND TYPE = 'Volume Trend'

--创建Value & volume share 输出表

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'OutputPerformanceByBrand_CV_Modi_Slide5_Output') AND TYPE = 'U')
BEGIN
	DROP TABLE OutputPerformanceByBrand_CV_Modi_Slide5_Output
END
SELECT Type,Molecule,class,mkt,mktname,market,prod,productname,moneytype,Left(X,3) as TimeFrame,X,Y,convert(int,null) as xidx
INTO OutputPerformanceByBrand_CV_Modi_Slide5_Output
FROM (
	SELECT * FROM 
	OutputPerformanceByBrand_CV_Modi_Slide5 
	WHERE market in ('Coniel', 'Monopril') and Molecule = 'N' and Class ='N' and mkt in ('CCB','HYP') and Moneytype in ('UN','US') and 
	(  (TYPE='Volume Trend' and Prod='000')  OR type in ('Value Share','Volume Share')  )
) A
UNPIVOT (Y FOR X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,MTH10,MTH11,MTH12,MTH13,MTH14,  MAT00,MAT01,MAT02,MAT03,MAT04,MAT05,MAT06,MAT07,MAT08,MAT09,MAT10,MAT11,MAT12,MAT13,MAT14,YTD00,YTD12)) T

update  a
set a.x= case when b.Month = 1 or b.Month = 12 then left(b.MonthEN,3) +char(10)+convert(varchar(5),b.year) else left(b.MonthEN,3) end,
	a.xidx=b.MonSeq
from [OutputPerformanceByBrand_CV_Modi_Slide5_Output] a join tblMonthList b on convert(int,right(a.x,2))+1=b.MonSeq

--update [OutputPerformanceByBrand_CV_Modi_Slide5_Output]
--set X=case X 
--when 'MTH00' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=1)
--when 'MTH01' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=2)
--when 'MTH02' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=3)
--when 'MTH03' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=4)
--when 'MTH04' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=5)
--when 'MTH05' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=6)
--when 'MTH06' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=7)
--when 'MTH07' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=8)
--when 'MTH08' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=9)
--when 'MTH09' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=10)
--when 'MTH10' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=11)
--when 'MTH11' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=12)
--when 'MTH12' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=13)
--when 'MTH13' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=14)
--when 'MTH14' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=15)
--when 'MTH15' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=16)
--when 'MTH16' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=17)
--when 'MTH17' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=18)
--when 'MTH18' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=19)
--when 'MTH19' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=20)
--when 'MTH20' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=21)
--when 'MTH21' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=22)
--when 'MTH22' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=23)
--when 'MTH23' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=24)
--when 'MTH24' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=25)
--when 'MTH25' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=26)else X
--end 

--update [OutputPerformanceByBrand_CV_Modi_Slide5_Output]
--set X=case X 
--when 'MAT00' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=1)
--when 'MAT01' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=2)
--when 'MAT02' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=3)
--when 'MAT03' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=4)
--when 'MAT04' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=5)
--when 'MAT05' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=6)
--when 'MAT06' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=7)
--when 'MAT07' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=8)
--when 'MAT08' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=9)
--when 'MAT09' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=10)
--when 'MAT10' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=11)
--when 'MAT11' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=12)
--when 'MAT12' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=13)
--when 'MAT13' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=14)
--when 'MAT14' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=15)
--when 'MAT15' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=16)
--when 'MAT16' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=17)
--when 'MAT17' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=18)
--when 'MAT18' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=19)
--when 'MAT19' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=20)
--when 'MAT20' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=21)
--when 'MAT21' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=22)
--when 'MAT22' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=23)
--when 'MAT23' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=24)
--when 'MAT24' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=25)
--when 'MAT25' then SUBSTRING(X,1,3) + ' '+(select [MonthEN] from tblMonthList where monseq=26)else X END

GO

-----------------------------------------------------------
--		CIA-CV_Modification(Eliquis) Slide 3 and Slide4's Mid table
-----------------------------------------------------------

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'Output_CIA_CV_Modification_Slide_3And4') AND TYPE='U')
BEGIN
	DROP TABLE Output_CIA_CV_Modification_Slide_3And4
END
--Market Value
select [TYPE], Molecule,class,mkt,mktname,market,prod,productname,MoneyType,Audi_cod,Audi_des, 
	case when X='YTD00' then 'YTD'
		when X='MTH00' then 'MTH'
		when X='QTR00' then 'QTR' end as TimeFrame,
	Y,
	row_number() over(partition by [Type],Molecule,class,mkt,mktname,market,prod,MoneyType,X order by Y desc) as Audi_Rank
into Output_CIA_CV_Modification_Slide_3And4
from
(
	select cast('MarketValue' as varchar(50))AS [TYPE], Molecule,class,mkt,mktname,market,prod,productname,MoneyType,Audi_cod,Audi_des,YTD00,MTH00,QTR00
	from dbo.TempRegionCityDashboard where mkt = 'Eliquis VTEp' and moneyType in ('LC','UN','US')  and Lev='City' and prod='000'
	 and Molecule='N' and Class ='N'
) t1 unpivot (
		Y for X in (YTD00,MTH00,QTR00)
) T2

--Product Value
insert into Output_CIA_CV_Modification_Slide_3And4([Type],Molecule,class,mkt,mktname,market,prod,productname,moneyType,Audi_cod,Audi_des,TimeFrame,Y,Audi_Rank)
select [TYPE], Molecule,class,mkt,mktname,market,prod,productname,MoneyType,Audi_cod,Audi_des, 
	case when X='YTD00' then 'YTD'
		when X='MTH00' then 'MTH'
		when X='QTR00' then 'QTR' end as TimeFrame,
	Y,
	null as Audi_Rank --Update with market value rank
from
(
	select cast('ProductValue' as varchar(50))AS [TYPE], Molecule,class,mkt,mktname,market,prod,productname,MoneyType,Audi_cod,Audi_des,YTD00,MTH00,QTR00
	from dbo.TempRegionCityDashboard where mkt = 'Eliquis VTEp' and moneyType in ('LC','UN','US') and Lev='City' and prod<>'000'
	 and Molecule='N' and Class ='N'
) t1 unpivot (
		Y for X in (YTD00,MTH00,QTR00)
) T2

--National market value
insert into Output_CIA_CV_Modification_Slide_3And4([Type],Molecule,class,mkt,mktname,market,prod,productname,moneyType,Audi_cod,Audi_des,TimeFrame,Y,Audi_Rank)
select [Type],Molecule,class,mkt,mktname,market,prod,productname,moneyType,'NAT_','Nation',TimeFrame,SUM(Y) as Y, null as Audi_Rank
from Output_CIA_CV_Modification_Slide_3And4 where type ='MarketValue'
group by Type,Molecule,class,mkt,mktname,market,prod,productName,MoneyType,TimeFrame

--Market&Product Growth
insert into Output_CIA_CV_Modification_Slide_3And4([Type],Molecule,class,mkt,mktname,market,prod,productname,moneyType,Audi_cod,Audi_des,TimeFrame,Y,Audi_Rank)
select [Type],Molecule,class,mkt,mktname,market,prod,productname,moneyType,Audi_cod,Audi_des,
	case when X='YTD00' then 'YTD'
		when X='MTH00' then 'MTH'
		when X='QTR00' then 'QTR' end as TimeFrame,
	Y,Audi_Rank
from
(
		select 'MarketGrowth' as [Type],Molecule,class,mkt,mktname,market,prod,productname,MoneyType,Audi_cod,Audi_des,
				case when YTD12 IS NULL OR YTD12 =0 then 0 else 1.0*(YTD00-YTD12)/YTD12 end as YTD00,
				case when MTH12 IS NULL OR MTH12 =0 then 0 else 1.0*(MTH00-MTH12)/MTH12 end as MTH00,
				case when QTR12 IS NULL OR QTR12 =0 then 0 else 1.0*(QTR00-QTR12)/QTR12 end as QTR00,
				null Audi_Rank
		from dbo.TempRegionCityDashboard where mkt = 'Eliquis VTEp' and moneyType in ('LC','UN','US') and Lev='City' and prod='000'
		 and Molecule='N' and Class ='N'
		union
		select 'ProductGrowth' as [Type],Molecule,class,mkt,mktname,market,prod,productname,MoneyType,Audi_cod,Audi_des,
				case when YTD12 IS NULL OR YTD12 =0 then 0 else 1.0*(YTD00-YTD12)/YTD12 end as YTD00,
				case when MTH12 IS NULL OR MTH12 =0 then 0 else 1.0*(MTH00-MTH12)/MTH12 end as MTH00,
				case when QTR12 IS NULL OR QTR12 =0 then 0 else 1.0*(QTR00-QTR12)/QTR12 end as QTR00,
				null Audi_Rank
		from dbo.TempRegionCityDashboard where mkt = 'Eliquis VTEp' and moneyType in ('LC','UN','US') and Lev='City' and prod<>'000'
		 and Molecule='N' and Class ='N'
) t1 unpivot (
	Y for X in (YTD00,MTH00,QTR00)
) t2		

--AvgGrowth
insert into Output_CIA_CV_Modification_Slide_3And4([Type],Molecule,class,mkt,mktname,market,prod,productname,moneyType,Audi_cod,Audi_des,TimeFrame,Y,Audi_Rank)
select b.Type,b.Molecule,b.class,b.mkt,b.mktname,b.market,b.prod,b.productname,b.MoneyType,a.Audi_cod,a.Audi_des,b.TimeFrame,b.Y,
	a.Audi_Rank
from
(
	select * from  Output_CIA_CV_Modification_Slide_3And4 where [Type]='MarketGrowth'
) a join 
(	
	select 'AvgMarketGrowth' as [Type],Molecule,class,mkt,mktname,market,prod,productname,moneyType,TimeFrame,
	1.0*sum(Y)/count(Audi_des) as Y
	from Output_CIA_CV_Modification_Slide_3And4 where [Type]='MarketGrowth'
	group by Molecule,class,mkt,mktname,market,prod,productname,moneyType,TimeFrame
) b on a.Molecule=b.molecule and a.class=b.class and a.mkt=b.mkt and a.mktname=b.mktname and a.market=b.market and a.prod=b.prod and a.moneyType=b.moneyType and a.TimeFrame=b.TimeFrame	

--Contribution
--Calculate National level value
insert into Output_CIA_CV_Modification_Slide_3And4 ([Type],Molecule,class,mkt,mktname,market,prod,productname,moneyType,Audi_cod,Audi_des,TimeFrame,Y,Audi_Rank)
select  
	'MarketContribution' as [Type],
	b.Molecule,b.Class,b.mkt,b.mktname,b.market,b.prod,b.productname,b.moneytype,b.Audi_cod,b.Audi_des,b.Timeframe,
	case when a.Y is null or a.Y =0 then 0 else 1.0*b.y/a.y end as Y,
	b.Audi_Rank
from (
	select * from Output_CIA_CV_Modification_Slide_3And4 where type='marketValue' and Audi_des='Nation'
) a join (
	select * from Output_CIA_CV_Modification_Slide_3And4 where type='marketValue' and Audi_des<>'Nation'
) b on a.Molecule=b.Molecule and a.class=b.class and a.mkt=b.mkt and a.mktname=b.mktname and a.prod=b.prod and a.productname=b.productname
	   and a.MoneyType=b.MoneyType and a.TimeFrame=b.TimeFrame

--Product Value Share
insert into Output_CIA_CV_Modification_Slide_3And4 ([Type],Molecule,class,mkt,mktname,market,prod,productname,moneyType,Audi_cod,Audi_des,TimeFrame,Y,Audi_Rank)
select 
	'ProductValueShare' as [Type],
	b.Molecule,b.class, b.mkt, b.mktname, b.market, b.prod, b.productname,b.moneyType, b.Audi_cod, b.Audi_des, b.TimeFrame, 
	case when a.Y is null or a.Y=0 then 0 else 1.0*b.Y/a.Y end as Y,
	b.Audi_Rank
from (
	select * from Output_CIA_CV_Modification_Slide_3And4 where type='marketValue' and Audi_des<>'Nation'
) a join (
	select * from Output_CIA_CV_Modification_Slide_3And4 where type='productValue'
) b on a.Molecule=b.Molecule and a.class=b.class and a.mkt=b.mkt and a.mktname=b.mktname and a.market=b.market and a.MoneyType=b.MoneyType
	   and a.Audi_des=b.Audi_des and a.TimeFrame=b.TimeFrame



update Output_CIA_CV_Modification_Slide_3And4
set Audi_Rank=a.Audi_Rank
from (
	select distinct Audi_des, Audi_Rank,TimeFrame,MoneyType from Output_CIA_CV_Modification_Slide_3And4 where [Type]='MarketValue'
) a join Output_CIA_CV_Modification_Slide_3And4 b on a.TimeFrame=b.TimeFrame and a.Audi_Des=b.Audi_des and a.MoneyType=b.MoneyType
where b.Audi_Rank is null
go
delete from Output_CIA_CV_Modification_Slide_3And4 where Audi_des='Nation'
delete from Output_CIA_CV_Modification_Slide_3And4 where Type = 'ProductValue'
GO


-- ----------------------------------------------------
-- --		CIA-CV_Modification(Eliquis) Slide2(left Chart) mid table: Added by Xiaoyu.Chen on 20130923
-- ----------------------------------------------------
-- IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'Output_CIA_CV_Modification_Slide_2') AND TYPE='U')
-- BEGIN
-- 	DROP TABLE Output_CIA_CV_Modification_Slide_2
-- END
-- --Market&Product Value
-- SELECT *
-- INTO Output_CIA_CV_Modification_Slide_2
-- FROM
-- (
-- 	select cast('Value' as varchar(50)) as Type, Molecule,class,mkt,mktname,market,prod,ProductName,MoneyType,
-- 		   MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,
-- 		   R3M00 AS QTR00,QTR01,QTR02,QTR03,QTR04,QTR05,QTR06,QTR07,QTR08,QTR09
-- 	from TempCHPAPreReports where  mkt = 'Eliquis VTEp' and moneyType ='US' and Prod='000' and Molecule='N' and Class ='N'
--  ) T1 UNPIVOT (
-- 	Y FOR X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,
-- 		   QTR00,QTR01,QTR02,QTR03,QTR04,QTR05,QTR06,QTR07,QTR08,QTR09)
-- ) t2

-- --Product Share
-- INSERT INTO Output_CIA_CV_Modification_Slide_2(TYPE,Molecule,class,mkt,mktname,market,prod,ProductName,MoneyType,Y,X)
-- SELECT TYPE,Molecule,class,mkt,mktname,market,prod,ProductName,MoneyType,Y,X
-- FROM
-- (
-- 	select 'ProductValueShare' as Type, b.Molecule,b.class,b.mkt,b.mktname,b.market,b.prod,b.ProductName,b.MoneyType,
-- 		case when a.MTH00 is null or a.MTH00=0 then 0 else  1.0*b.MTH00/a.MTH00 end as MTH00,
-- 		case when a.MTH01 is null or a.MTh01=0 then 0 else  1.0*b.MTH01/a.MTH01 end as MTH01,
-- 		case when a.MTH02 is null or a.MTH02=0 then 0 else  1.0*b.MTH02/a.MTH02 end as MTH02,
-- 		case when a.MTH03 is null or a.MTH03=0 then 0 else  1.0*b.MTH03/a.MTH03 end as MTH03,
-- 		case when a.MTH04 is null or a.MTH04=0 then 0 else  1.0*b.MTH04/a.MTH04 end as MTH04,
-- 		case when a.MTH05 is null or a.MTH05=0 then 0 else  1.0*b.MTH05/a.MTH05 end as MTH05,
-- 		case when a.MTH06 is null or a.MTH06=0 then 0 else  1.0*b.MTH06/a.MTH06 end as MTH06,
-- 		case when a.MTH07 is null or a.MTH07=0 then 0 else  1.0*b.MTH07/a.MTH07 end as MTH07,
-- 		case when a.MTH08 is null or a.MTH08=0 then 0 else  1.0*b.MTH08/a.MTH08 end as MTH08,
-- 		case when a.MTH09 is null or a.MTH09=0 then 0 else  1.0*b.MTH09/a.MTH09 end as MTH09,
-- 		case when a.R3M00 is null or a.R3M00=0 then 0 else  1.0*b.R3M00/a.R3M00 end as QTR00,
-- 		case when a.QTR01 is null or a.QTR01=0 then 0 else  1.0*b.QTR01/a.QTR01 end as QTR01,
-- 		case when a.QTR02 is null or a.QTR02=0 then 0 else  1.0*b.QTR02/a.QTR02 end as QTR02,
-- 		case when a.QTR03 is null or a.QTR03=0 then 0 else  1.0*b.QTR03/a.QTR03 end as QTR03,
-- 		case when a.QTR04 is null or a.QTR04=0 then 0 else  1.0*b.QTR04/a.QTR04 end as QTR04,
-- 		case when a.QTR05 is null or a.QTR05=0 then 0 else  1.0*b.QTR05/a.QTR05 end as QTR05,
-- 		case when a.QTR06 is null or a.QTR06=0 then 0 else  1.0*b.QTR06/a.QTR06 end as QTR06,
-- 		case when a.QTR07 is null or a.QTR07=0 then 0 else  1.0*b.QTR07/a.QTR07 end as QTR07,
-- 		case when a.QTR08 is null or a.QTR08=0 then 0 else  1.0*b.QTR08/a.QTR08 end as QTR08,
-- 		case when a.QTR09 is null or a.QTR09=0 then 0 else  1.0*b.QTR09/a.QTR09 end as QTR09
-- 	from (
-- 		   select * from TempCHPAPreReports where  mkt = 'Eliquis VTEp' and moneyType ='US'	and Prod='000'
-- 		    and Molecule='N' and Class ='N'
-- 		 ) a join ( 
-- 				select * from TempCHPAPreReports where  mkt = 'Eliquis VTEp' and moneyType ='US' and Prod<>'000'
-- 				 and Molecule='N' and Class ='N'
-- 		 ) b  on a.Molecule=b.Molecule and a.Class=b.Class and a.mkt=b.mkt and a.market=b.market and a.Moneytype=b.MoneyType 
				
--  ) T1 UNPIVOT (
-- 	Y FOR X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,
-- 		   QTR00,QTR01,QTR02,QTR03,QTR04,QTR05,QTR06,QTR07,QTR08,QTR09)
-- ) t2
-- GO


-- --c661 Eliquis NOAC

-- IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'Output_CIA_CV_Modification_Slide_2_NOAC') AND TYPE='U')
-- BEGIN
-- 	DROP TABLE Output_CIA_CV_Modification_Slide_2_NOAC
-- END
-- --Market&Product Value
-- SELECT *
-- INTO Output_CIA_CV_Modification_Slide_2_NOAC
-- FROM
-- (
-- 	select cast('Value' as varchar(50)) as Type, Molecule,class,mkt,mktname,market,prod,ProductName,MoneyType,
-- 		   MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,
-- 		   R3M00 AS QTR00,QTR01,QTR02,QTR03,QTR04,QTR05,QTR06,QTR07,QTR08,QTR09
-- 	from TempCHPAPreReports where  mkt = 'Eliquis NOAC' and moneyType ='US' and Prod='000' and Molecule='N' and Class ='N'
--  ) T1 UNPIVOT (
-- 	Y FOR X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,
-- 		   QTR00,QTR01,QTR02,QTR03,QTR04,QTR05,QTR06,QTR07,QTR08,QTR09)
-- ) t2

-- --Product Share
-- INSERT INTO Output_CIA_CV_Modification_Slide_2_NOAC(TYPE,Molecule,class,mkt,mktname,market,prod,ProductName,MoneyType,Y,X)
-- SELECT TYPE,Molecule,class,mkt,mktname,market,prod,ProductName,MoneyType,Y,X
-- FROM
-- (
-- 	select 'ProductValueShare' as Type, b.Molecule,b.class,b.mkt,b.mktname,b.market,b.prod,b.ProductName,b.MoneyType,
-- 	case when a.MTH00 is null or a.MTH00=0 then 0 else  1.0*b.MTH00/a.MTH00 end as MTH00,
-- 	case when a.MTH01 is null or a.MTh01=0 then 0 else  1.0*b.MTH01/a.MTH01 end as MTH01,
-- 	case when a.MTH02 is null or a.MTH02=0 then 0 else  1.0*b.MTH02/a.MTH02 end as MTH02,
-- 	case when a.MTH03 is null or a.MTH03=0 then 0 else  1.0*b.MTH03/a.MTH03 end as MTH03,
-- 	case when a.MTH04 is null or a.MTH04=0 then 0 else  1.0*b.MTH04/a.MTH04 end as MTH04,
-- 	case when a.MTH05 is null or a.MTH05=0 then 0 else  1.0*b.MTH05/a.MTH05 end as MTH05,
-- 	case when a.MTH06 is null or a.MTH06=0 then 0 else  1.0*b.MTH06/a.MTH06 end as MTH06,
-- 	case when a.MTH07 is null or a.MTH07=0 then 0 else  1.0*b.MTH07/a.MTH07 end as MTH07,
-- 	case when a.MTH08 is null or a.MTH08=0 then 0 else  1.0*b.MTH08/a.MTH08 end as MTH08,
-- 	case when a.MTH09 is null or a.MTH09=0 then 0 else  1.0*b.MTH09/a.MTH09 end as MTH09,
-- 	case when a.R3M00 is null or a.R3M00=0 then 0 else  1.0*b.R3M00/a.R3M00 end as QTR00,
-- 	case when a.QTR01 is null or a.QTR01=0 then 0 else  1.0*b.QTR01/a.QTR01 end as QTR01,
-- 	case when a.QTR02 is null or a.QTR02=0 then 0 else  1.0*b.QTR02/a.QTR02 end as QTR02,
-- 	case when a.QTR03 is null or a.QTR03=0 then 0 else  1.0*b.QTR03/a.QTR03 end as QTR03,
-- 	case when a.QTR04 is null or a.QTR04=0 then 0 else  1.0*b.QTR04/a.QTR04 end as QTR04,
-- 	case when a.QTR05 is null or a.QTR05=0 then 0 else  1.0*b.QTR05/a.QTR05 end as QTR05,
-- 	case when a.QTR06 is null or a.QTR06=0 then 0 else  1.0*b.QTR06/a.QTR06 end as QTR06,
-- 	case when a.QTR07 is null or a.QTR07=0 then 0 else  1.0*b.QTR07/a.QTR07 end as QTR07,
-- 	case when a.QTR08 is null or a.QTR08=0 then 0 else  1.0*b.QTR08/a.QTR08 end as QTR08,
-- 	case when a.QTR09 is null or a.QTR09=0 then 0 else  1.0*b.QTR09/a.QTR09 end as QTR09
-- 	from (
-- 		   select * from TempCHPAPreReports where  mkt = 'Eliquis NOAC' and moneyType ='US'	and Prod='000'
-- 		    and Molecule='N' and Class ='N'
-- 		 ) a join ( 
-- 				select * from TempCHPAPreReports where  mkt = 'Eliquis NOAC' and moneyType ='US' and Prod<>'000'
-- 				 and Molecule='N' and Class ='N'
-- 		 ) b  on a.Molecule=b.Molecule and a.Class=b.Class and a.mkt=b.mkt and a.market=b.market and a.Moneytype=b.MoneyType 
				
--  ) T1 UNPIVOT (
-- 	Y FOR X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,
-- 		   QTR00,QTR01,QTR02,QTR03,QTR04,QTR05,QTR06,QTR07,QTR08,QTR09)
-- ) t2
GO


--END
----------------------------------------------------
--		CIA-CV_Modification(Eliquis) Slide2(Right Chart) mid table: Added by Xiaoyu.Chen on 20130926
----------------------------------------------------
-- Treatment Day 的处理逻辑
-- Treatment Day=dosing unit/ daily doze
-- 转换单位:
-- 1.转换后结果=(产品的销量*产品的包装)*产品对应的占比/转换比.
-- 2.求出产品对应的占比(利用RX数据,只用骨科的占比)
-- 3.转换比:
--   Xarelto=1
--   Fraxiparine(IU)=4000
--   Clexane(IU)=4000
--   Clexane(MG)=4
--	 ELIQUIS=1
--	 ARIXTRA=1
-- 4.每年用当年的占比值

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'CIA_CV_Modi_Slide2_RX_ZB') and type='U')
BEGIN
	DROP TABLE CIA_CV_Modi_Slide2_RX_ZB
END
GO
SELECT a.*,b.year 
INTO CIA_CV_Modi_Slide2_RX_ZB
FROM
(
	select 
	a.Lev,a.Geo,a.Product,a.Mkt,a.Prod,a.Department,
	case when b.H1 is null or b.H1=0 then 0 else 1.0*a.H1/b.H1 end as H1,
	case when b.H2 is null or b.H2=0 then 0 else 1.0*a.H2/b.H2 end as H2,
	case when b.H3 is null or b.H3=0 then 0 else 1.0*a.H3/b.H3 end as H3,
	case when b.H4 is null or b.H4=0 then 0 else 1.0*a.H4/b.H4 end as H4,
	case when b.H5 is null or b.H5=0 then 0 else 1.0*a.H5/b.H5 end as H5,
	case when b.H6 is null or b.H6=0 then 0 else 1.0*a.H6/b.H6 end as H6,
	case when b.H7 is null or b.H7=0 then 0 else 1.0*a.H7/b.H7 end as H7
	-- case when b.H8 is null or b.H8=0 then 0 else 1.0*a.H8/b.H8 end as H8 --20161109
	from (
			select Lev,Geo,Product,Mkt,Prod,Department,H7,H6,H5,H4,H3,H2,H1
			from BMSChinaMRBI.dbo.tempoutputRx 
			where product='eliquis' and Lev='nat' and Department=115
		 )a join 
		 (
			select Lev,Geo,Product,Mkt,Prod, 'All Dept' Department, 
			SUM(H7) AS H7,SUM(H6) AS H6,SUM(H5) AS H5,SUM(H4) AS H4,SUM(H3) AS H3,SUM(H2) AS H2,SUM(H1) AS H1
			from BMSChinaMRBI.dbo.tempoutputRx 
			where product='eliquis' and Lev='nat'	
			group by Lev,Geo,Product,Mkt,Prod
		 ) b on a.Lev=b.Lev and a.geo=b.geo and a.product=b.product and a.mkt=b.mkt and a.prod=b.prod
) t1 unpivot (
	zb for Halfyear in (H1,H2,H3,H4,H5,H6,H7)
) a join ( 		
	select * from (
		select *, row_number() over(partition by [Year] order by HalfYear) as rowNum
		from
		(
			select '20'+left(H,2) AS [Year], 'H'+cast(Idx as varchar(3)) AS HalfYear 
			from BMSChinaMRBI.dbo.tblRxHalfYearList where Idx <8
		) t
	) t2 where rowNum=1
) b on a.halfyear=b.halfyear	
GO

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'TempCHPA_CIA_CV_MODI_Slide2_Right') and type='U')
BEGIN
	DROP TABLE TempCHPA_CIA_CV_MODI_Slide2_Right
END
GO

declare @MoneyType varchar(10)
declare @sqlMTH varchar(max)
declare @sqlQTR varchar(max)
declare @sqlMQT varchar(max)
declare @sql varchar(max)
declare @i int
set @MoneyType='UN'
set @sqlMTH=''
set @sqlQTR=''
set @sqlMQT=''
set @sql=''
set @i=0
while (@i<=9)
begin
	set @sqlMQT=@sqlMQT+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
	set @sqlMTH=@sqlMTH+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
	set @i=@i+1
end
set @sqlMQT=left(@sqlMQT,len(@sqlMQT)-1)
set @sqlMTH=left(@sqlMTH,len(@sqlMTH)-1)

set @i=0
while (@i<=9)
begin
	set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
	set @i=@i+1
end
set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
set @sql=' 
		select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt AS market,B.prod,B.Productname,b.Pack_cod,
--         A.MNFL_COD,B.Gene_cod,
        '+'''' +@MoneyType+''''+' as Moneytype, '+@sqlMQT+', '+@sqlMTH+', '+@sqlQtr+'
        into TempCHPA_CIA_CV_MODI_Slide2_Right
		from mthCHPA_pkau A inner join tblMktDef_MRBIChina B
        on A.pack_cod=B.pack_cod where B.Active=''Y'' and b.mkt=''Eliquis VTEp'' and b.Molecule=''N'' and b.Class=''N'' and b.Prod<>''000''
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname,b.Pack_cod'
print @sql
exec(@sql)
GO
-- IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'Output_CIA_CV_MODI_Slide2_Right') and type='U')
-- BEGIN
-- 	DROP TABLE Output_CIA_CV_MODI_Slide2_Right
-- END
-- GO

-- select cast('TreatmentDay' as varchar(50)) as [Type],Molecule,Class,mkt,mktname,market,prod,Productname,MoneyType,Y,
-- 	left(X,3) as TimeFrame,	case when X LIKE 'MTH%' then (	select distinct MonthEN from tblMonthList 
-- 													 	 	where MonSeq =cast( right(X,1) as int)+1) 
-- 							 when X Like 'QTR%' then (	select distinct cast([Year] as char(4))+Quarter  
-- 							 							from 
-- 															(	select distinct	year,quarter,
-- 																	dense_rank() over(order by QtrSeq)	 as QtrSeq
-- 																from tblMonthList ) a
-- 														where QtrSeq=cast( right(X,1) as int)+1 ) end  as X,
-- 					10-cast( right(X,1) as int) as XIdx
-- into Output_CIA_CV_MODI_Slide2_Right			
-- from 
-- (
-- 	select  a.Molecule,a.Class,a.mkt,a.mktname,a.market,a.prod,a.Productname,a.Moneytype,
-- 			SUM(a.R3M00*b.Pack_size/b.zhb) as QTR00, SUM(a.QTR01*b.Pack_size/b.zhb) as QTR01,
-- 			SUM(a.QTR02*b.pack_size/b.zhb) as QTR02, SUM(a.QTR03*b.Pack_size/b.zhb) as QTR03,
-- 			SUM(a.QTR04*b.pack_size/b.zhb) as QTR04, SUM(a.QTR05*b.Pack_size/b.zhb) as QTR05,
-- 			SUM(a.QTR06*b.Pack_size/b.zhb) as QTR06, SUM(a.QTR07*b.Pack_size/b.zhb) as QTR07,
-- 			SUM(a.QTR08*b.Pack_size/b.zhb) as QTR08, SUM(a.QTR09*b.Pack_size/b.zhb) as QTR09,
-- 			SUM(a.MTH00*b.Pack_size/b.zhb) as MTH00, SUM(a.MTH01*b.Pack_size/b.zhb) as MTH01,
-- 			SUM(a.MTH02*b.Pack_size/b.zhb) as MTH02, SUM(a.MTH03*b.Pack_size/b.zhb) as MTH03,
-- 			SUM(a.MTH04*b.Pack_size/b.zhb) as MTH04, SUM(a.MTH05*b.Pack_size/b.zhb) as MTH05,
-- 			SUM(a.MTh06*b.Pack_size/b.zhb) as MTH06, SUM(a.MTH07*b.Pack_size/b.zhb) as MTH07,
-- 			SUM(a.MTH08*b.Pack_size/b.zhb) as MTH08, SUM(a.MTH09*b.Pack_size/b.zhb) as MTH09		
-- 	from TempCHPA_CIA_CV_MODI_Slide2_Right a 
-- 		join dbo.Eliquis_Prod_Pack_Zhb b on a.ProductName=b.Prod_des and a.Pack_cod=b.Pack_cod
-- 	group by a.Molecule,a.Class,a.mkt,a.mktname,a.market,a.prod,a.Productname,a.Moneytype
-- ) t1 unpivot (
-- 	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,
-- 		   QTR00,QTR01,QTR02,QTR03,QTR04,QTR05,QTR06,QTR07,QTR08,QTR09)
-- ) t2
-- GO
	   
-- update Output_CIA_CV_MODI_Slide2_Right
-- set Y=a.Y*b.zb
-- from Output_CIA_CV_MODI_Slide2_Right a join CIA_CV_Modi_Slide2_RX_ZB b 
-- on a.mkt=b.mkt and a.prod=b.prod and 
-- 				case when a.TimeFrame='MTH' then '20'+right(X,2)
-- 					 when a.TimeFrame='QTR' then left(X,4) end =b.Year		
-- GO					 			
-- --Market Treatment Day
-- insert into Output_CIA_CV_MODI_Slide2_Right(Type,Molecule,Class,mkt,mktname,market,prod,Productname,moneyType,Y,TimeFrame,X,XIdx)
-- select Type,Molecule,Class,mkt,mktname,market,'000','Eliquis Market',MoneyType,SUM(Y),TimeFrame,X,XIdx
-- from Output_CIA_CV_MODI_Slide2_Right
-- where type='TreatmentDay'
-- group by Type,Molecule,Class,mkt,mktname,market,MoneyType,TimeFrame,X,XIdx


-- --Product Treatment Day Share
-- insert into Output_CIA_CV_MODI_Slide2_Right(Type,Molecule,Class,mkt,mktname,market,prod,Productname,moneyType,Y,TimeFrame,X,XIdx)
-- select 
-- 	'ProductTreatmentDayShare' as Type, b.Molecule,b.Class,b.mkt,b.mktname,b.market,b.prod,b.ProductName,b.moneyType,
-- 	case when a.Y is null or a.Y=0 then 0 else 1.0*b.Y/a.Y end as Y,b.TimeFrame,b.X,b.XIdx
-- from (	select * from Output_CIA_CV_MODI_Slide2_Right 
-- 		where type='TreatmentDay' and Prod='000') a 
-- join (
-- 	    select * from Output_CIA_CV_MODI_Slide2_Right 
-- 	    where type='TreatmentDay' and Prod<>'000') b 
-- on a.Molecule=b.Molecule and a.Class=b.Class and a.Mkt=b.Mkt and a.market=b.market and a.MoneyType=b.MoneyType 
-- 	and a.TimeFrame=b.TimeFrame and a.X=b.X
-- GO



-- --Eliquis NOAC c660


-- IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'TempCHPA_CIA_CV_MODI_Slide2_Right_NOAC') and type='U')
-- BEGIN
-- 	DROP TABLE TempCHPA_CIA_CV_MODI_Slide2_Right_NOAC
-- END
-- GO

-- declare @MoneyType varchar(10)
-- declare @sqlMTH varchar(max)
-- declare @sqlQTR varchar(max)
-- declare @sqlMQT varchar(max)
-- declare @sql varchar(max)
-- declare @i int
-- set @MoneyType='UN'
-- set @sqlMTH=''
-- set @sqlQTR=''
-- set @sqlMQT=''
-- set @sql=''
-- set @i=0
-- while (@i<=9)
-- begin
-- 	set @sqlMQT=@sqlMQT+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
-- 	set @sqlMTH=@sqlMTH+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
-- 	set @i=@i+1
-- end
-- set @sqlMQT=left(@sqlMQT,len(@sqlMQT)-1)
-- set @sqlMTH=left(@sqlMTH,len(@sqlMTH)-1)

-- set @i=0
-- while (@i<=9)
-- begin
-- 	set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
-- 	set @i=@i+1
-- end
-- set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
-- set @sql=' 
-- 		select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt AS market,B.prod,B.Productname,b.Pack_cod,
-- --         A.MNFL_COD,B.Gene_cod,
--         '+'''' +@MoneyType+''''+' as Moneytype, '+@sqlMQT+', '+@sqlMTH+', '+@sqlQtr+'
--         into TempCHPA_CIA_CV_MODI_Slide2_Right_NOAC
-- 		from mthCHPA_pkau A inner join tblMktDef_MRBIChina B
--         on A.pack_cod=B.pack_cod where B.Active=''Y'' and b.mkt=''Eliquis NOAC'' and b.Molecule=''N'' and b.Class=''N'' and b.Prod<>''000''
-- 		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname,b.Pack_cod'
-- print @sql
-- exec(@sql)
-- GO
-- IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'Output_CIA_CV_MODI_Slide2_Right_NOAC') and type='U')
-- BEGIN
-- 	DROP TABLE Output_CIA_CV_MODI_Slide2_Right_NOAC
-- END
-- GO

-- select cast('TreatmentDay' as varchar(50)) as [Type],Molecule,Class,mkt,mktname,market,prod,Productname,MoneyType,Y,
-- 	left(X,3) as TimeFrame,	case 	when X LIKE 'MTH%' 
-- 									then (	select distinct MonthEN 
-- 											from tblMonthList 
-- 											where MonSeq =cast( right(X,1) as int)+1) 
-- 							 		when X Like 'QTR%' 
-- 									then (	select distinct cast([Year] as char(4))+Quarter  
-- 											from 
-- 											(	select distinct	year,quarter,
-- 												dense_rank() over(order by QtrSeq)	 as QtrSeq
-- 												from tblMonthList ) a
-- 											where QtrSeq=cast( right(X,1) as int)+1 ) end  as X,
-- 					10-cast( right(X,1) as int) as XIdx
-- into Output_CIA_CV_MODI_Slide2_Right_NOAC			
-- from 
-- (
-- 	select  a.Molecule,a.Class,a.mkt,a.mktname,a.market,a.prod,a.Productname,a.Moneytype,
-- 			SUM(a.R3M00*b.Pack_size/b.zhb) as QTR00, SUM(a.QTR01*b.Pack_size/b.zhb) as QTR01,
-- 			SUM(a.QTR02*b.pack_size/b.zhb) as QTR02, SUM(a.QTR03*b.Pack_size/b.zhb) as QTR03,
-- 			SUM(a.QTR04*b.pack_size/b.zhb) as QTR04, SUM(a.QTR05*b.Pack_size/b.zhb) as QTR05,
-- 			SUM(a.QTR06*b.Pack_size/b.zhb) as QTR06, SUM(a.QTR07*b.Pack_size/b.zhb) as QTR07,
-- 			SUM(a.QTR08*b.Pack_size/b.zhb) as QTR08, SUM(a.QTR09*b.Pack_size/b.zhb) as QTR09,
-- 			SUM(a.MTH00*b.Pack_size/b.zhb) as MTH00, SUM(a.MTH01*b.Pack_size/b.zhb) as MTH01,
-- 			SUM(a.MTH02*b.Pack_size/b.zhb) as MTH02, SUM(a.MTH03*b.Pack_size/b.zhb) as MTH03,
-- 			SUM(a.MTH04*b.Pack_size/b.zhb) as MTH04, SUM(a.MTH05*b.Pack_size/b.zhb) as MTH05,
-- 			SUM(a.MTh06*b.Pack_size/b.zhb) as MTH06, SUM(a.MTH07*b.Pack_size/b.zhb) as MTH07,
-- 			SUM(a.MTH08*b.Pack_size/b.zhb) as MTH08, SUM(a.MTH09*b.Pack_size/b.zhb) as MTH09		
-- 	from TempCHPA_CIA_CV_MODI_Slide2_Right_NOAC a 
-- 		join dbo.Eliquis_Prod_Pack_Zhb_NOAC b on a.ProductName=b.Prod_des and a.Pack_cod=b.Pack_cod
-- 	group by a.Molecule,a.Class,a.mkt,a.mktname,a.market,a.prod,a.Productname,a.Moneytype
-- ) t1 unpivot (
-- 	Y for X in (MTH00,MTH01,MTH02,MTH03,MTH04,MTH05,MTH06,MTH07,MTH08,MTH09,
-- 		   QTR00,QTR01,QTR02,QTR03,QTR04,QTR05,QTR06,QTR07,QTR08,QTR09)
-- ) t2
-- GO
	   
-- update Output_CIA_CV_MODI_Slide2_Right_NOAC
-- set Y=a.Y*b.zb
-- from Output_CIA_CV_MODI_Slide2_Right_NOAC a join CIA_CV_Modi_Slide2_RX_ZB b 
-- on a.mkt=b.mkt and a.prod=b.prod and 
-- 				case when a.TimeFrame='MTH' then '20'+right(X,2)
-- 					 when a.TimeFrame='QTR' then left(X,4) end =b.Year		
-- GO					 			
-- --Market Treatment Day
-- insert into Output_CIA_CV_MODI_Slide2_Right_NOAC(Type,Molecule,Class,mkt,mktname,market,prod,Productname,moneyType,Y,TimeFrame,X,XIdx)
-- select Type,Molecule,Class,mkt,mktname,market,'000','Eliquis Market',MoneyType,SUM(Y),TimeFrame,X,XIdx
-- from Output_CIA_CV_MODI_Slide2_Right_NOAC
-- where type='TreatmentDay'
-- group by Type,Molecule,Class,mkt,mktname,market,MoneyType,TimeFrame,X,XIdx


-- --Product Treatment Day Share
-- insert into Output_CIA_CV_MODI_Slide2_Right_NOAC(Type,Molecule,Class,mkt,mktname,market,prod,Productname,moneyType,Y,TimeFrame,X,XIdx)
-- select 
-- 	'ProductTreatmentDayShare' as Type, b.Molecule,b.Class,b.mkt,b.mktname,b.market,b.prod,b.ProductName,b.moneyType,
-- 	case when a.Y is null or a.Y=0 then 0 else 1.0*b.Y/a.Y end as Y,b.TimeFrame,b.X,b.XIdx
-- from (	select * from Output_CIA_CV_MODI_Slide2_Right_NOAC 
-- 		where type='TreatmentDay' and Prod='000') a 
-- join (
-- 	    select * from Output_CIA_CV_MODI_Slide2_Right_NOAC 
-- 	    where type='TreatmentDay' and Prod<>'000') b 
-- on a.Molecule=b.Molecule and a.Class=b.Class and a.Mkt=b.Mkt and a.market=b.market and a.MoneyType=b.MoneyType 
-- 	and a.TimeFrame=b.TimeFrame and a.X=b.X
-- GO



-- --END




---------------------------------------------------------------------------------
--					Other ETV split to multi-products related mid table
---------------------------------------------------------------------------------

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID=OBJECT_ID(N'tblMktDef_MRBIChina_For_OtherETV') AND TYPE ='U')
BEGIN
	DROP TABLE tblMktDef_MRBIChina_For_OtherETV
END
SELECT distinct Mkt,MktName,
	case Prod_des
		when 'HE EN' then  '601'
		when 'LEI YI DE' then '602'
		when 'WEI LI QING' then '603'
		when 'ENTECAVIR' then '604'
		else '800' end as Prod ,
	case Prod_des
		when 'HE EN' then  'He En'
		when 'LEI YI DE' then 'Lei Yi De'
		when 'WEI LI QING' then 'Wei Li Qing'
		when 'ENTECAVIR' then 'Other Entecavir(prod)'
		else 'ARV Others'end  as Productname,
	'N' as Molecule, 'N' as Class,
	ATC1_Cod,ATC2_Cod,ATC3_Cod,ATC4_Cod,
	pack_cod, Pack_des,Prod_cod,Prod_des as Prod_Name,
	Prod_des + ' (' +Manu_cod +')' as Prod_FullName,
	'' Mole_cod,'' Mole_Name,
	Corp_cod, Manu_Cod, Gene_Cod, 'Y' as Active,
	GetDate() as Date, '201307 add new products & packages' AS Comment
	,1 as Rat
INTO tblMktDef_MRBIChina_For_OtherETV	
FROM tblMktDef_Inline A 
WHERE A.MKT = 'ARV' AND A.MOLE_DES = 'Entecavir'
and NOT EXISTS(
	SELECT * FROM tblMktDef_MRBIChina B 
	WHERE B.MKT = 'ARV' AND B.Class='N' and molecule='N' and PROD between '100' and '500'
		AND A.PACK_COD = B.PACK_COD and a.atc3_cod=b.atc3_cod
)
insert into tblMktDef_MRBIChina_For_OtherETV
select * from tblMktDef_MRBIChina where mkt='arv' and prod='800'
go

IF EXISTS(SELECT 1 FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'TempCityDashboard_For_OtherETV') AND TYPE ='U')
BEGIN
	DROP TABLE TempCityDashboard_For_OtherETV
END

select * into TempCityDashboard_For_OtherETV from TempCityDashboard where not (mkt='arv' and productname in ('Other Entecavir','ARV Others'))
go
declare @i int,@sql varchar(max),@sql1 varchar(max),@sql3 varchar(max),@sqlMAT varchar(2000),@sqlYTD varchar(2000),@sqlQtr varchar(2000)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(max)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		set @i=0
		set @sql1=''
        set @sql3=''
        while (@i<=45)
		begin
			set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end

        set @i=0    
        while (@i<=48)
		begin
			set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
			set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
		while (@i<=48)
		begin
			set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
        set @sqlQtr=''
		while (@i<=19)
		begin
			set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
        set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		exec('insert into TempCityDashboard_For_OtherETV 
        select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,'+'''' +@MoneyType+''''+' as Moneytype, A.audi_cod,'''',''City'',null,'+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
		from mthcity_pkau A 
		inner join tblMktDef_MRBIChina_For_OtherETV B
        on A.pack_cod=B.pack_cod where B.Active=''Y'' and A.audi_cod<>''ZJH_''
		group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname,A.audi_cod')
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go


update TempCityDashboard_For_OtherETV
set AUDI_des=City
from TempCityDashboard_For_OtherETV A 
inner join dbo.tblCityMax B
on A.AUDI_cod=B.City
go

update TempCityDashboard_For_OtherETV
set Market=case  
		when Market in ('HYP','ACE') then 'Monopril'
		when Market in ('NIAD','DIA') then 'Glucophage'
		when Market in ('ONC','ONCFCS') then 'Taxol' 
		when Market in ('HBV','ARV') then 'Baraclude'
		when Market in ('DPP4') then 'Onglyza' 
		when Market in ('CML') then 'Sprycel' 
		when Market in ('Platinum') then 'Paraplatin'
		when Market in ('CCB') then 'Coniel'
		else Market end
go

insert into TempCityDashboard_For_OtherETV (Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
Audi_cod,audi_des,lev)
select  Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype,
Audi_cod,audi_des,lev 
from (
	select A.*,Audi_cod,audi_des,lev 
	from (
			select distinct Molecule,Class,mkt,mktname,Market,Prod,productname,Moneytype 
			from TempCityDashboard_For_OtherETV
		) A 
		inner join ( 
			select distinct  Molecule,Class,mkt,mktname,Market,Moneytype,Audi_cod,audi_des,lev 
			from TempCityDashboard_For_OtherETV
		) B on a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
			   and a.Moneytype=b.Moneytype
) A 
where not exists(
		select * from TempCityDashboard_For_OtherETV B
		where a.Molecule=b.molecule and A.Class=B.Class and a.mkt=b.mkt and a.market=b.market
			and a.Moneytype=b.Moneytype and a.audi_cod=b.audi_cod and a.Prod=B.Prod
	)
go
update TempCityDashboard_For_OtherETV
set Tier=B.Tier 
from TempCityDashboard_For_OtherETV A 
inner join tblCityMax B
on A.Audi_cod=B.CIty
go
--delete TempCityDashboard_For_OtherETV from TempCityDashboard_For_OtherETV A
--where not exists(select * from (select * from dbo.outputgeo where product='Baraclude') B
--where A.audi_des=b.geo)

--insert into TempCityDashboard_For_OtherETV
--select * from TempCityDashboard
--select distinct Mkt,productname,prod from TempCityDashboard_For_OtherETV where mkt='arv' order by prod
--delete from TempCityDashboard_For_OtherETV where mkt='arv' and productname='Other Entecavir'

delete TempCityDashboard_For_OtherETV from TempCityDashboard_For_OtherETV A
where not exists(select * from dbo.outputgeo B
where A.Market=B.Product and A.audi_des=b.geo) and a.mkt not in ('Eliquis VTEp','Eliquis NOAC','Eliquis VTEt')
go

delete TempCityDashboard_For_OtherETV from TempCityDashboard_For_OtherETV A
where not exists(select * from dbo.outputgeo B
where left(A.Market,7)=B.Product and A.audi_des=b.geo) AND A.mkt in ('Eliquis VTEp','Eliquis NOAC''Eliquis VTEt')
go

if object_id(N'TempCHPAPreReports_For_OtherETV',N'U') is not null
	drop table TempCHPAPreReports_For_OtherETV
go

select * into TempCHPAPreReports_For_OtherETV  from TempCHPAPreReports where not (mkt='arv' and productname in ('Other Entecavir','ARV Others'))

declare @i int,@sql varchar(max),@sql1 varchar(max),@sql3 varchar(max),@sqlMAT varchar(2000),@sqlYTD varchar(2000),@sqlQtr varchar(2000)
DECLARE TMP_CURSOR CURSOR
READ_ONLY
FOR select [Type]  from dbo.tblMoneyType
DECLARE @MoneyType varchar(10)
DECLARE @SQL2 VARCHAR(max)
	
OPEN TMP_CURSOR
	
FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
WHILE (@@FETCH_STATUS <> -1)
BEGIN

	IF (@@FETCH_STATUS <> -2)
	BEGIN
		print @MoneyType
		set @i=0
		set @sql1=''
        set @sql3=''
		while (@i<=48)
		begin
			set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as R3M'+right('00'+cast(@i as varchar(3)),2)+','
			set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MTH'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
			set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as MAT'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
		while (@i<=48)
		begin
			set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as YTD'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
		set @sqlQtr=''
		while (@i<=19)
		begin
			set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+@MoneyType+',0)) as Qtr'+right('00'+cast(@i as varchar(3)),2)+','
			set @i=@i+1
		end
		set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		set @SQL2='insert into TempCHPAPreReports_For_OtherETV 
			select  B.Molecule,B.Class,B.mkt,B.mktname,B.mkt,B.prod,B.Productname,
	--         A.MNFL_COD,B.Gene_cod,
			'+'''' +@MoneyType+''''+' as Moneytype, '+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+'
			from mthCHPA_pkau A inner join tblMktDef_MRBIChina_For_OtherETV B
			on A.pack_cod=B.pack_cod where B.Active=''Y''
			group by B.Molecule,B.Class,B.mkt,B.mktname,B.prod,B.Productname'
       	print @SQL2
		exec( @SQL2)
	END
	FETCH NEXT FROM TMP_CURSOR INTO @MoneyType
END
CLOSE TMP_CURSOR
DEALLOCATE TMP_CURSOR
go
update TempCHPAPreReports_For_OtherETV
set Market=case Market when 'ONC' then 'Taxol' 
	when 'HYP' then 'Monopril'
	when 'NIAD' then 'Glucophage'
	when 'ACE' then 'Monopril'
	when 'DIA' then 'Glucophage'
	when 'ONCFCS' then 'Taxol'
	when 'HBV' then 'Baraclude'
	when 'ARV' then 'Baraclude' when 'DPP4' then 'Onglyza' when 'CML' then 'Sprycel' 
	when 'Platinum' then 'Paraplatin'
	when 'CCB' then 'Coniel'
	else Market end
go

delete 
from TempCHPAPreReports_For_OtherETV
where Market <> 'Paraplatin' and MoneyType = 'PN'

--select distinct mkt,productname,prod from TempCHPAPreReports_For_OtherETV where mkt='arv' order by prod
--delete from TempCHPAPreReports_For_OtherETV where mkt='arv' and productname='Other Entecavir'
GO



------------------------------------------------------
-- TempRegionCityDashboard_For_OtherETV
------------------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'TempRegionCityDashboard_For_OtherETV') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table TempRegionCityDashboard_For_OtherETV
go
select * into TempRegionCityDashboard_For_OtherETV from TempCityDashboard_For_OtherETV where 1=2
go
Alter table TempRegionCityDashboard_For_OtherETV add Region varchar(200)
go
insert into TempRegionCityDashboard_For_OtherETV
select A.*,B.ParentGeo 
from TempCityDashboard_For_OtherETV A 
inner join dbo.outputgeo B
	on A.Market=B.Product and A.audi_des=b.geo
GO
-- insert into TempRegionCityDashboard_For_OtherETV
-- select A.*,B.ParentGeo 
-- from TempCityDashboard_For_OtherETV A 
-- inner join dbo.outputgeo B
-- 	on left(A.Market,7)=B.Product and A.audi_des=b.geo 
-- where a.mkt in ('Eliquis VTEp','Eliquis NOAC','Eliquis VTEt')
go
Alter table TempRegionCityDashboard_For_OtherETV 
drop column Tier
go
declare @i int,@sql varchar(max),@sql1 varchar(max),@sql3 varchar(max),@sqlMAT varchar(2000),@sqlYTD varchar(2000),@sqlQtr varchar(2000)
DECLARE @SQL2 VARCHAR(max)
		set @i=0
		set @sql1=''
        set @sql3=''
        while (@i<=45)
		begin
			set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+',0)),'
			set @i=@i+1
		end

        set @i=0    
        while (@i<=48)
		begin
			set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+',0)) ,'
			set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
			set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+',0)),'
			set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
        while (@i<=48)
		begin
			set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+',0)),'
			set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
        set @sqlQtr=''
		while (@i<=19)
		begin
			set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+',0)),'
			set @i=@i+1
		end
        set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		exec('
		insert into TempRegionCityDashboard_For_OtherETV
		select [Molecule],[Class],[mkt],[mktname],Market,[prod],[Productname],MoneyType,
			[Region],[Region],''Region'','+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+',[Region] 
		from TempRegionCityDashboard_For_OtherETV A
		group by [Molecule],[Class],[mkt],[mktname],Market,[prod],[Productname],[Moneytype],[Region]')
go
declare @i int,@sql varchar(max),@sql1 varchar(max),@sql3 varchar(max),@sqlMAT varchar(2000),@sqlYTD varchar(2000),@sqlQtr varchar(2000)
DECLARE @SQL2 VARCHAR(max)
		set @i=0
		set @sql1=''
        set @sql3=''
		while (@i<=45)
		begin
			set @sql1=@sql1+'sum(isnull(R3M'+right('00'+cast(@i as varchar(3)),2)+',0)),'
			set @i=@i+1
		end

        set @i=0    
		while (@i<=48)
		begin
			set @sql3=@sql3+'sum(isnull(MTH'+right('00'+cast(@i as varchar(3)),2)+',0)) ,'
			set @i=@i+1
		end
		set @sql1=left(@sql1,len(@sql1)-1)
        set @sql3=left(@sql3,len(@sql3)-1)

        set @i=0
		set @sqlMAT=''
		while (@i<=48)
		begin
			set @sqlMAT=@sqlMAT+'sum(isnull(MAT'+right('00'+cast(@i as varchar(3)),2)+',0)),'
			set @i=@i+1
		end
		set @sqlMAT=left(@sqlMAT,len(@sqlMAT)-1)

        set @i=0
        set @sqlYTD=''
		while (@i<=48)
		begin
			set @sqlYTD=@sqlYTD+'sum(isnull(YTD'+right('00'+cast(@i as varchar(3)),2)+',0)),'
			set @i=@i+1
		end
        set @sqlYTD=left(@sqlYTD,len(@sqlYTD)-1)

        set @i=0
        set @sqlQtr=''
		while (@i<=19)
		begin
			set @sqlQtr=@sqlQtr+'sum(isnull(Qtr'+right('00'+cast(@i as varchar(3)),2)+',0)),'
			set @i=@i+1
		end
        set @sqlQtr=left(@sqlQtr,len(@sqlQtr)-1)
		--print @sql1

		exec('
		insert into TempRegionCityDashboard_For_OtherETV
		select [Molecule],[Class],[mkt],[mktname],Market,[prod],[Productname],MoneyType,
			''China'',''China'',''China'','+@sql1+', '+@sql3+', '+@sqlMAT+', '+@sqlYTD+', '+@sqlQtr+',''China'' 
		from TempCityDashboard_For_OtherETV A
        where exists(select * from dbo.outputgeo B 
					where (A.Market=B.Product and A.audi_des=b.geo and a.mkt not in (''Eliquis VTEp'',''Eliquis NOAC'',''Eliquis VTEt''))
						or (left(A.Market,7)=B.Product and A.audi_des=b.geo and a.mkt in (''Eliquis VTEp'',''Eliquis NOAC'',''Eliquis VTEt'') ))
		group by [Molecule],[Class],[mkt],[mktname],Market,[prod],[Productname],[Moneytype]')
go
delete from TempRegionCityDashboard_For_OtherETV where region=''

go


--------------------------------------------
--OutputGeoHBVSummaryT2_For_OtherETV
--------------------------------------------
if exists (select * from dbo.sysobjects where id = object_id(N'OutputGeoHBVSummaryT2_For_OtherETV') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputGeoHBVSummaryT2_For_OtherETV
GO

select 
	A.lev
	,cast('Product' as varchar(20)) as [Type]
	,B.[Molecule]
	,B.[Class]
	,B.[mkt]
	,B.Market
	,B.[mktname]
	,B.[prod]
	,B.[Productname]
	,B.[Moneytype]
	,B.[Audi_cod]
	,B.[Audi_des]
	,B.[Region]
	,B.R3M00
	,B.YTD00
	,B.MAT00 
	,B.MTH00
	,B.R3M12
	,B.YTD12
	,B.MAT12
	,B.MTH12
	--case A.R3M00 when 0 then 0 else B.R3M00*1.0/A.R3M00 end  as R3M00,
	--case A.YTD00 when 0 then 0 else B.YTD00*1.0/A.YTD00 end  as YTD00,
	--case A.MAT00 when 0 then 0 else B.MAT00*1.0/A.MAT00 end  as MAT00,
	--case A.R3M12 when 0 then 0 else B.R3M12*1.0/A.R3M12 end  as R3M12,
	--case A.YTD12 when 0 then 0 else B.YTD12*1.0/A.YTD12 end  as YTD12,
	--case A.MAT12 when 0 then 0 else B.MAT12*1.0/A.MAT12 end  as MAT12
into OutputGeoHBVSummaryT2_For_OtherETV 
from TempRegionCityDashboard_For_OtherETV A 
inner join TempRegionCityDashboard_For_OtherETV B
on 
  A.mkt=b.mkt 
  and A.Moneytype=b.Moneytype and A.class=B.class 
  and A.Molecule=B.Molecule
  and A.[Audi_cod]=B.[Audi_cod] and A.Region=B.Region
  and A.prod='000' and A.Molecule='N' and isnull(B.prod,'')<>'000' and isnull(B.productname,'')<>'HYP Others'
  and A.lev=B.lev and A.lev in ('City','Region')
go

insert into OutputGeoHBVSummaryT2_For_OtherETV
select 
	'Region'
	,'Product'
	,B.[Molecule]
	,B.[Class]
	,B.[mkt]
	,B.Market
	,B.[mktname]
	,B.[prod]
	,B.[Productname]
	,B.[Moneytype]
	,'CHT_'
	,'National'
	,'China'
	,B.R3M00
	,B.YTD00
	,B.MAT00 
	,B.MTH00
	,B.R3M12
	,B.YTD12
	,B.MAT12
	,B.MTH12
from dbo.TempCHPAPreReports_For_OtherETV B where isnull(Prod,'')<>'000' and isnull(productname,'')<>'HYP Others'
go

delete from OutputGeoHBVSummaryT2_For_OtherETV where market='Baraclude' and mkt='HBV'
delete from OutputGeoHBVSummaryT2_For_OtherETV where market='Baraclude' and mkt='ARV' and molecule='Y'
delete from OutputGeoHBVSummaryT2_For_OtherETV where market='Glucophage' and mkt='DIA'
delete from OutputGeoHBVSummaryT2_For_OtherETV where market='Glucophage' and mkt='NIAD' and molecule='Y' 
delete from OutputGeoHBVSummaryT2_For_OtherETV where market='Monopril' and mkt='ACE'-- and Class='N' and Productname not in('Monopril'
delete from OutputGeoHBVSummaryT2_For_OtherETV where market='Taxol' and mkt<>'ONCFCS' 
delete from OutputGeoHBVSummaryT2_For_OtherETV where market='Taxol' and mkt='ONCFCS' and molecule='Y' 
delete from OutputGeoHBVSummaryT2_For_OtherETV where market='Paraplatin' and mkt='Platinum' and molecule='Y' 
go

--delete region level
delete from OutputGeoHBVSummaryT2_For_OtherETV where lev='Region' and (molecule='Y' or class='Y')
delete from OutputGeoHBVSummaryT2_For_OtherETV where lev='Region' and Market='Onglyza' and mkt='NIAD'
go

insert into OutputGeoHBVSummaryT2_For_OtherETV
select 
	lev
	,'Market Total'
	,B.[Molecule]
	,B.[Class]
	,B.[mkt]
	,B.Market
	,B.[mktname]
	,'000'
	,B.[mktname]
	,B.[Moneytype]
	,B.[Audi_cod]
	,B.[Audi_des]
	,B.[Region]
	,sum(R3M00) as R3M00
	,sum(YTD00)  as YTD00 
	,sum(MAT00)  as MAT00
	,sum(MTH00)  as MTH00
	,sum(R3M12)  as R3M12
	,sum(YTD12)  as YTD12 
	,sum(MAT12)  as MAT12
	,sum(MTH12)  as MTH12
from OutputGeoHBVSummaryT2_For_OtherETV B
group by 
  lev,B.[Molecule],B.[Class],B.[mkt],B.Market,B.[mktname],B.[Moneytype],B.[Audi_cod],B.[Audi_des],B.[Region]

insert into OutputGeoHBVSummaryT2_For_OtherETV
select 
	B.lev
	,'Share'
	,B.[Molecule]
	,B.[Class]
	,B.[mkt]
	,B.Market
	,B.[mktname]
	,B.[prod]
	,B.[Productname]
	,B.[Moneytype]
	,B.[Audi_cod]
	,B.[Audi_des]
	,B.[Region]
	,case A.R3M00 when 0 then 0 else B.R3M00*1.0/A.R3M00 end  as R3M00
	,case A.YTD00 when 0 then 0 else B.YTD00*1.0/A.YTD00 end  as YTD00
	,case A.MAT00 when 0 then 0 else B.MAT00*1.0/A.MAT00 end  as MAT00
	,case A.MTH00 when 0 then 0 else B.MTH00*1.0/A.MTH00 end  as MTH00
	,case A.R3M12 when 0 then 0 else B.R3M12*1.0/A.R3M12 end  as R3M12
	,case A.YTD12 when 0 then 0 else B.YTD12*1.0/A.YTD12 end  as YTD12
	,case A.MAT12 when 0 then 0 else B.MAT12*1.0/A.MAT12 end  as MAT12
	,case A.MTH12 when 0 then 0 else B.MTH12*1.0/A.MTH12 end  as MTH12
from
  OutputGeoHBVSummaryT2_For_OtherETV A 
inner join 
  OutputGeoHBVSummaryT2_For_OtherETV B
on 
  A.mkt=b.mkt 
  and A.Moneytype=b.Moneytype 
  and A.class=B.class 
  and A.Molecule=B.Molecule
  and A.[Audi_cod]=B.[Audi_cod] and A.Region=B.Region and A.lev=B.lev
  and A.[Type]='Market Total' and B.[Type]='Product' 
go

update OutputGeoHBVSummaryT2_For_OtherETV set 
 audi_cod=B.rank 
from 
  OutputGeoHBVSummaryT2_For_OtherETV A 
inner join 
  (
  select B.*,dense_rank() OVER (order by case audi_des when 'National' then 'ZZZZ' else audi_des end) as Rank 
  from OutputGeoHBVSummaryT2_For_OtherETV B
  ) B
on 
  A.audi_des=B.audi_des
go

delete from OutputGeoHBVSummaryT2_For_OtherETV where type='Product'
delete from OutputGeoHBVSummaryT2_For_OtherETV where prod is null and productname is null
go
--Add Onglyza Market
insert into [OutputGeoHBVSummaryT2_For_OtherETV]
SELECT 
  lev
 ,[Type]
 ,[Molecule]
 ,[Class]
 ,[mkt]
 ,'Onglyza'
 ,[mktname]
 ,[prod]
 ,[Productname]
 ,[Moneytype]
 ,[Audi_cod]
 ,[Audi_des]
 ,[Region]
 ,[R3M00]
 ,[YTD00]
 ,[MAT00]
 ,[MTH00]
 ,[R3M12]
 ,[YTD12]
 ,[MAT12]
 ,[MTH12]
FROM [dbo].[OutputGeoHBVSummaryT2_For_OtherETV]
where Market='Glucophage' and Class='N' and lev='City'
go


if exists (select * from dbo.sysobjects where id = object_id(N'OutputKeyBrandPerformanceByRegion_For_OtherETV') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputKeyBrandPerformanceByRegion_For_OtherETV
go

select * 
into OutputKeyBrandPerformanceByRegion_For_OtherETV
from [OutputGeoHBVSummaryT2_For_OtherETV] 
where lev='Region'
go

delete from [OutputGeoHBVSummaryT2_For_OtherETV] where lev='Region'
go


if exists (select * from dbo.sysobjects where id = object_id(N'OutputKeyBrandPerformance_For_OtherETV') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table OutputKeyBrandPerformance_For_OtherETV
go
declare @i int,@sql varchar(max),@sqlR varchar(max)
set @i=0
set @sql=''
set @sqlR=''
set @sql=@sql+'
	case sum(A.MAT00) when 0 then null else sum(B.MAT00)*1.0/sum(A.MAT00) end as MAT00, 
	case sum(A.MAT12) when 0 then null else sum(B.MAT12)*1.0/sum(A.MAT12) end as MAT12, 
	case sum(A.MAT24) when 0 then null else sum(B.MAT24)*1.0/sum(A.MAT24) end as MAT24, 
	case sum(A.MAT36) when 0 then null else sum(B.MAT36)*1.0/sum(A.MAT36) end as MAT36, 
	case sum(A.MAT48) when 0 then null else sum(B.MAT48)*1.0/sum(A.MAT48) end as MAT48,'
-- while (@i<=24)
-- begin
-- 	set @sql=@sql+'
-- 	case sum(A.MAT'+right('00'+cast(@i as varchar(2)),2)+') when 0 then null else sum(B.MAT'+right('00'+cast(@i as varchar(2)),2)+')*1.0/sum(A.MAT'+right('00'+cast(@i as varchar(2)),2)+') end as MAT'+right('00'+cast(@i as varchar(2)),2)+','
-- 	set @i=@i+1
-- end
set @sqlR='
	select ''MAT'' as Period,B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname,'+
		left(@sql,len(@sql)-1)+' 
	into OutputKeyBrandPerformance_For_OtherETV 
	from TempCHPAPreReports_For_OtherETV A 
	inner join TempCHPAPreReports_For_OtherETV B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
		and A.Market=B.Market and A.prod=''000'' and B.prod<>''000''
	where B.class=''N'' and B.Molecule=''N''
	group by B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname'
print @sqlR
exec (@sqlR)

set @i=0
set @sql=''
set @sqlR=''
set @sql=@sql+'
	case sum(A.R3M00) when 0 then null else sum(B.R3M00)*1.0/sum(A.R3M00) end as R3M00, 
	case sum(A.R3M12) when 0 then null else sum(B.R3M12)*1.0/sum(A.R3M12) end as R3M12, 
	case sum(A.R3M24) when 0 then null else sum(B.R3M24)*1.0/sum(A.R3M24) end as R3M24, 
	case sum(A.R3M36) when 0 then null else sum(B.R3M36)*1.0/sum(A.R3M36) end as R3M36, 
	case sum(A.R3M48) when 0 then null else sum(B.R3M48)*1.0/sum(A.R3M48) end as R3M48,'
-- while (@i<=24)
-- begin
-- 	set @sql=@sql+'
-- 	case sum(A.R3M'+right('00'+cast(@i as varchar(2)),2)+') when 0 then null else sum(B.R3M'+right('00'+cast(@i as varchar(2)),2)+')*1.0/sum(A.R3M'+right('00'+cast(@i as varchar(2)),2)+') end,'
-- 	set @i=@i+1
-- end
set @sqlR='
	insert into OutputKeyBrandPerformance_For_OtherETV
	select ''MQT'' as Period,B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname,'+
	left(@sql,len(@sql)-1)+' 
	from TempCHPAPreReports_For_OtherETV A 
	inner join TempCHPAPreReports_For_OtherETV B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
	and A.Market=B.Market and A.prod=''000'' and B.prod<>''000''
	where B.class=''N'' and B.Molecule=''N''
	group by B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname'
print @sqlR
exec (@sqlR)

set @i=0
set @sql=''
set @sqlR=''
set @sql=@sql+'
	case sum(A.MTH00) when 0 then null else sum(B.MTH00)*1.0/sum(A.MTH00) end as MTH00, 
	case sum(A.MTH12) when 0 then null else sum(B.MTH12)*1.0/sum(A.MTH12) end as MTH12, 
	case sum(A.MTH24) when 0 then null else sum(B.MTH24)*1.0/sum(A.MTH24) end as MTH24, 
	case sum(A.MTH36) when 0 then null else sum(B.MTH36)*1.0/sum(A.MTH36) end as MTH36, 
	case sum(A.MTH48) when 0 then null else sum(B.MTH48)*1.0/sum(A.MTH48) end as MTH48,'
-- while (@i<=24)
-- begin
-- 	set @sql=@sql+'
-- 	case sum(A.MTH'+right('00'+cast(@i as varchar(2)),2)+') when 0 then null else sum(B.MTH'+right('00'+cast(@i as varchar(2)),2)+')*1.0/sum(A.MTH'+right('00'+cast(@i as varchar(2)),2)+') end,'
-- 	set @i=@i+1
-- end
set @sqlR='insert into OutputKeyBrandPerformance_For_OtherETV
	select ''MTH'' as Period,B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname,'+
	left(@sql,len(@sql)-1)+' 
	from TempCHPAPreReports_For_OtherETV A 
	inner join TempCHPAPreReports_For_OtherETV B
	on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
		and A.Market=B.Market and A.prod=''000'' and B.prod<>''000''
	where B.class=''N'' and B.Molecule=''N''
	group by B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname'
print @sqlR
exec (@sqlR)


set @i=0
set @sql=''
set @sqlR=''
set @sql=@sql+'
	case sum(A.YTD00) when 0 then null else sum(B.YTD00)*1.0/sum(A.YTD00) end as YTD00, 
	case sum(A.YTD12) when 0 then null else sum(B.YTD12)*1.0/sum(A.YTD12) end as YTD12, 
	case sum(A.YTD24) when 0 then null else sum(B.YTD24)*1.0/sum(A.YTD24) end as YTD24, 
	case sum(A.YTD36) when 0 then null else sum(B.YTD36)*1.0/sum(A.YTD36) end as YTD36, 
	case sum(A.YTD48) when 0 then null else sum(B.YTD48)*1.0/sum(A.YTD48) end as YTD48,'
-- while (@i<=24)
-- begin
-- set @sql=@sql+'
-- case sum(A.YTD'+right('00'+cast(@i as varchar(2)),2)+') 
-- 	when 0 then null 
-- 	else sum(B.YTD'+right('00'+cast(@i as varchar(2)),2)+')*1.0/sum(A.YTD'+right('00'+cast(@i as varchar(2)),2)+') end,'
-- set @i=@i+1
-- end
set @sqlR='insert into OutputKeyBrandPerformance_For_OtherETV
select ''YTD'' as Period,B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname,'+
left(@sql,len(@sql)-1)+' 
from TempCHPAPreReports_For_OtherETV A 
inner join TempCHPAPreReports_For_OtherETV B
on A.mkt=b.mkt and A.Moneytype=b.Moneytype and A.class=B.class and A.Molecule=B.Molecule
	and A.Market=B.Market and A.prod=''000'' and B.prod<>''000''
where B.class=''N'' and B.Molecule=''N''
group by B.Moneytype,B.Molecule,B.Class,B.Mkt,B.Mktname,B.Market,B.Prod,B.Productname'
print @sqlR
exec (@sqlR)
go
delete from OutputKeyBrandPerformance_For_OtherETV where Molecule='Y' or class='Y'
delete from OutputKeyBrandPerformance_For_OtherETV 
where mkt not in ('ARV','DPP4','HYP','ONCFCS','NIAD','Platinum','CCB','Eliquis NOAC','Eliquis VTEp','Eliquis VTEt')
go



--------------------------------------------
--OutputCityPerformanceByBrand_For_OtherETV
--------------------------------------------

--横坐标间隔全部改为3个月，而不是一个月 2012/11/07
if exists (select * from dbo.sysobjects where id = object_id(N'OutputCityPerformanceByBrand_For_OtherETV') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table OutputCityPerformanceByBrand_For_OtherETV
go

select cast('Volume Trend' as varchar(50)) as Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
    ,[Audi_cod],[Audi_des],[Region],
	sum(R3M00) as R3M00,sum(R3M03) as R3M01,
	sum(R3M06) as R3M02,sum(R3M09) as R3M03,
	sum(R3M12) as R3M04,sum(R3M15) as R3M05,
	sum(R3M12) as R3M12,sum(R3M15) as R3M13,
	sum(R3M18) as R3M14,sum(R3M21) as R3M15,
	sum(R3M24) as R3M16,sum(R3M27) as R3M17,
	sum(YTD00) as YTD00,sum(YTD12) as YTD12, 
	sum(YTD24) as YTD24,sum(YTD36) as YTD36, 
	sum(YTD48) as YTD48,
	sum(MAT00) as MAT00,sum(MAT12) as MAT12, 
	sum(MAT24) as MAT24,sum(MAT36) as MAT36, 
	sum(MAT48) as MAT48,
	sum(MTH00) as MTH00,sum(MTH12) as MTH12, 
	sum(MTH24) as MTH24,sum(MTH36) as MTH36, 
	sum(MTH48) as MTH48
into OutputCityPerformanceByBrand_For_OtherETV 
from TempRegionCityDashboard_For_OtherETV where lev='City'
group by [Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype]
      ,[Audi_cod],[Audi_des],[Region]
go
insert into OutputCityPerformanceByBrand_For_OtherETV
select 'Market Share Trend',A.[Molecule],A.[Class],A.[mkt],A.Market,A.[mktname],A.[prod],A.[Productname],A.[Moneytype]
      ,A.[Audi_cod],A.[Audi_des],A.[Region],
	case B.R3M00 when 0 then 0 else A.R3M00/B.R3M00 end,
	case B.R3M01 when 0 then 0 else A.R3M01/B.R3M01 end,
	case B.R3M02 when 0 then 0 else A.R3M02/B.R3M02 end,
	case B.R3M03 when 0 then 0 else A.R3M03/B.R3M03 end,
	case B.R3M04 when 0 then 0 else A.R3M04/B.R3M04 end,
	case B.R3M05 when 0 then 0 else A.R3M05/B.R3M05 end,
	case B.R3M12 when 0 then 0 else A.R3M12/B.R3M12 end,
	case B.R3M13 when 0 then 0 else A.R3M13/B.R3M13 end,
	case B.R3M14 when 0 then 0 else A.R3M14/B.R3M14 end,
	case B.R3M15 when 0 then 0 else A.R3M15/B.R3M15 end,
	case B.R3M16 when 0 then 0 else A.R3M16/B.R3M16 end,
	case B.R3M17 when 0 then 0 else A.R3M17/B.R3M17 end,

	case B.YTD00 when 0 then 0 else A.YTD00/B.YTD00 end,
	case B.YTD12 when 0 then 0 else A.YTD12/B.YTD12 end,
	case B.YTD24 when 0 then 0 else A.YTD24/B.YTD24 end,
	case B.YTD36 when 0 then 0 else A.YTD36/B.YTD36 end,
	case B.YTD48 when 0 then 0 else A.YTD48/B.YTD48 end,
	
	case B.MAT00 when 0 then 0 else A.MAT00/B.MAT00 end,
	case B.MAT12 when 0 then 0 else A.MAT12/B.MAT12 end,
	case B.MAT24 when 0 then 0 else A.MAT24/B.MAT24 end,
	case B.MAT36 when 0 then 0 else A.MAT36/B.MAT36 end,
	case B.MAT48 when 0 then 0 else A.MAT48/B.MAT48 end,
	
	case B.MTH00 when 0 then 0 else A.MTH00/B.MTH00 end,
	case B.MTH12 when 0 then 0 else A.MTH12/B.MTH12 end,
	case B.MTH24 when 0 then 0 else A.MTH24/B.MTH24 end,
	case B.MTH36 when 0 then 0 else A.MTH36/B.MTH36 end,
	case B.MTH48 when 0 then 0 else A.MTH48/B.MTH48 end
from OutputCityPerformanceByBrand_For_OtherETV A 
inner join OutputCityPerformanceByBrand_For_OtherETV B
on A.Moneytype=B.Moneytype and A.[mkt]=B.[mkt] and A.Region=B.Region and A.class=B.class and A.Molecule=B.Molecule
	and A.Audi_Cod=B.Audi_Cod and B.prod='000' and A.prod<>'000'
go
insert into OutputCityPerformanceByBrand_For_OtherETV
select 'Market Share Trend',A.[Molecule],A.[Class],A.[mkt],A.Market,A.[mktname],A.[prod],A.[Productname],A.[Moneytype]
      ,A.[Audi_cod],A.[Audi_des],A.[Region],0,0,0,0,0,0,0,0,0,0,0,0,
	  0,0,0,0,0,
	  0,0,0,0,0,
	  0,0,0,0,0
from OutputCityPerformanceByBrand_For_OtherETV A where prod='000'
go
insert into OutputCityPerformanceByBrand_For_OtherETV
select 'Growth Trend',A.[Molecule],A.[Class],A.[mkt],A.Market,A.[mktname],A.[prod],A.[Productname],A.[Moneytype]
      ,A.[Audi_cod],A.[Audi_des],A.[Region],
	case R3M12 when 0 then case R3M00 when 0 then 0 else null end else (R3M00-R3M12)/R3M12 end,
	case R3M13 when 0 then case R3M01 when 0 then 0 else null end else (R3M01-R3M13)/R3M13 end,
	case R3M14 when 0 then case R3M02 when 0 then 0 else null end else (R3M02-R3M14)/R3M14 end,
	case R3M15 when 0 then case R3M03 when 0 then 0 else null end else (R3M03-R3M15)/R3M15 end,
	case R3M16 when 0 then case R3M04 when 0 then 0 else null end else (R3M04-R3M16)/R3M16 end,
	case R3M17 when 0 then case R3M05 when 0 then 0 else null end else (R3M05-R3M17)/R3M17 end,
	0,0,0,0,0,0,
	case YTD12 when 0 then case YTD00 when 0 then 0 else null end else (YTD00-YTD12)/YTD12 end,
	case YTD24 when 0 then case YTD12 when 0 then 0 else null end else (YTD12-YTD24)/YTD24 end,
	case YTD36 when 0 then case YTD24 when 0 then 0 else null end else (YTD24-YTD36)/YTD36 end,
	case YTD48 when 0 then case YTD36 when 0 then 0 else null end else (YTD36-YTD48)/YTD48 end,
	0,
	case MAT12 when 0 then case MAT00 when 0 then 0 else null end else (MAT00-MAT12)/MAT12 end,
	case MAT24 when 0 then case MAT12 when 0 then 0 else null end else (MAT12-MAT24)/MAT24 end,
	case MAT36 when 0 then case MAT24 when 0 then 0 else null end else (MAT24-MAT36)/MAT36 end,
	case MAT48 when 0 then case MAT36 when 0 then 0 else null end else (MAT36-MAT48)/MAT48 end,
	0,
	case MTH12 when 0 then case MTH00 when 0 then 0 else null end else (MTH00-MTH12)/MTH12 end,
	case MTH24 when 0 then case MTH12 when 0 then 0 else null end else (MTH12-MTH24)/MTH24 end,
	case MTH36 when 0 then case MTH24 when 0 then 0 else null end else (MTH24-MTH36)/MTH36 end,
	case MTH48 when 0 then case MTH36 when 0 then 0 else null end else (MTH36-MTH48)/MTH48 end,
	0
from OutputCityPerformanceByBrand_For_OtherETV A where Chart='Volume Trend'
go
insert into OutputCityPerformanceByBrand_For_OtherETV
select 'Share of Growth Trend',A.[Molecule],A.[Class],A.[mkt],A.Market,A.[mktname],A.[prod],A.[Productname],A.[Moneytype]
      ,A.[Audi_cod],A.[Audi_des],A.[Region],
	case (B.R3M00-B.R3M12) when 0 then 0 else (A.R3M00-A.R3M12)/(B.R3M00-B.R3M12) end,
	case (B.R3M01-B.R3M13) when 0 then 0 else (A.R3M01-A.R3M13)/(B.R3M01-B.R3M13) end,
	case (B.R3M02-B.R3M14) when 0 then 0 else (A.R3M02-A.R3M14)/(B.R3M02-B.R3M14) end,
	case (B.R3M03-B.R3M15) when 0 then 0 else (A.R3M03-A.R3M15)/(B.R3M03-B.R3M15) end,
	case (B.R3M04-B.R3M16) when 0 then 0 else (A.R3M04-A.R3M16)/(B.R3M04-B.R3M16) end,
	case (B.R3M05-B.R3M17) when 0 then 0 else (A.R3M05-A.R3M17)/(B.R3M05-B.R3M17) end,
	0,0,0,0,0,0,
	case (B.YTD00-B.YTD12) when 0 then 0 else (A.YTD00-A.YTD12)/(B.YTD00-B.YTD12) end,
	case (B.YTD12-B.YTD24) when 0 then 0 else (A.YTD12-A.YTD24)/(B.YTD12-B.YTD24) end,
	case (B.YTD24-B.YTD36) when 0 then 0 else (A.YTD24-A.YTD36)/(B.YTD24-B.YTD36) end,
	case (B.YTD36-B.YTD48) when 0 then 0 else (A.YTD36-A.YTD48)/(B.YTD36-B.YTD48) end,
	0,
	case (B.MAT00-B.MAT12) when 0 then 0 else (A.MAT00-A.MAT12)/(B.MAT00-B.MAT12) end,
	case (B.MAT12-B.MAT24) when 0 then 0 else (A.MAT12-A.MAT24)/(B.MAT12-B.MAT24) end,
	case (B.MAT24-B.MAT36) when 0 then 0 else (A.MAT24-A.MAT36)/(B.MAT24-B.MAT36) end,
	case (B.MAT36-B.MAT48) when 0 then 0 else (A.MAT36-A.MAT48)/(B.MAT36-B.MAT48) end,
	0,
	case (B.MTH00-B.MTH12) when 0 then 0 else (A.MTH00-A.MTH12)/(B.MTH00-B.MTH12) end,
	case (B.MTH12-B.MTH24) when 0 then 0 else (A.MTH12-A.MTH24)/(B.MTH12-B.MTH24) end,
	case (B.MTH24-B.MTH36) when 0 then 0 else (A.MTH24-A.MTH36)/(B.MTH24-B.MTH36) end,
	case (B.MTH36-B.MTH48) when 0 then 0 else (A.MTH36-A.MTH48)/(B.MTH36-B.MTH48) end,
	0
from OutputCityPerformanceByBrand_For_OtherETV A 
inner join OutputCityPerformanceByBrand_For_OtherETV B
on A.Moneytype=B.Moneytype and A.[mkt]=B.[mkt] and A.Region=B.Region and A.class=B.class and A.Molecule=B.Molecule
and A.Audi_Cod=B.Audi_Cod and B.prod='000' and A.prod<>'000'
and A.Chart='Volume Trend' and A.Chart=B.Chart
go
insert into OutputCityPerformanceByBrand_For_OtherETV
SELECT [Chart]
      ,[Molecule]
      ,[Class]
      ,[mkt]
      ,'Onglyza'
      ,[mktname]
      ,[prod]
      ,[Productname]
      ,[Moneytype]
      ,[Audi_cod]
      ,[Audi_des]
      ,[Region]
      ,[R3M00]
      ,[R3M01]
      ,[R3M02]
      ,[R3M03]
      ,[R3M04]
      ,[R3M05]
      ,[R3M12]
      ,[R3M13]
      ,[R3M14]
      ,[R3M15]
      ,[R3M16]
      ,[R3M17]
	,YTD00,YTD12,YTD24,YTD36,YTD48
	,MAT00,MAT12,MAT24,MAT36,MAT48
	,MTH00,MTH12,MTH24,MTH36,MTH48
FROM [dbo].[OutputCityPerformanceByBrand_For_OtherETV]
where market='Glucophage' and class='N' and mkt='NIAD'

--update OutputCityPerformanceByBrand_For_OtherETV
--set Prod=B.rank from OutputCityPerformanceByBrand_For_OtherETV A inner join 
--(select B.*,row_number() OVER (PARTITION BY chart order by mkt,molecule,class,prod,audi_des) as Rank from OutputCityPerformanceByBrand_For_OtherETV B) B
--on A.chart=B.chart and a.mkt=b.mkt and a.molecule=b.molecule and a.class=b.class and A.audi_des=B.audi_des and A.moneytype=b.moneytype
--and A.productname=b.productname
--go
go
--CAGR
insert into OutputCityPerformanceByBrand_For_OtherETV(Chart,[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],
	audi_cod,audi_des,region,R3M00,YTD00, MAT00, MTH00)
select 'CAGR',[Molecule],[Class],[mkt],Market,[mktname],[prod],[Productname],[Moneytype],audi_cod,audi_des,region,
	case when R3M05<>0 then Power((R3M00/R3M05), 1.0/5)-1 
		when R3M05=0 and R3M04<>0  then Power((R3M00/R3M04),1.0/4)-1
		when R3M05=0 and R3M04=0 and R3M03<>0 then Power((R3M00/R3M03),1.0/3)-1
		when R3M05=0 and R3M04=0 and R3M03=0 and R3M02<>0 then Power((R3M00/R3M02),1.0/2)-1
		when R3M05=0 and R3M04=0 and R3M03=0 and R3M02=0 and R3M01<>0 then Power((R3M00/R3M01),1.0/1)-1
		when R3M05=0 and R3M04=0 and R3M03=0 and R3M02=0 and R3M01=0  then 0 
	end as R3M00, 
	case when mkt='arv' and YTD48<>0 then Power((YTD00/YTD48),1.0/4)-1
		when mkt='arv' and YTD48=0 and YTD36<>0 then Power((YTD00/YTD36),1.0/3)-1
		when mkt='arv' and YTD48=0 and YTD36=0 and YTD24<>0 then Power((YTD00/YTD24),1.0/2)-1
		when mkt='arv' and YTD48=0 and YTD36=0 and YTD24=0  and YTD12<>0  then Power((YTD00/YTD12),1.0/1)-1
		when mkt='arv' and YTD48=0 and YTD36=0 and YTD24=0 and YTD12=0 then 0
		else null
	end as YTD00, 
	case when mkt='arv' and MAT48<>0 then Power((MAT00/MAT48),1.0/4)-1
		when mkt='arv' and MAT48=0 and MAT36<>0 then Power((MAT00/MAT36),1.0/3)-1
		when mkt='arv' and MAT48=0 and MAT36=0 and MAT24<>0 then Power((MAT00/MAT24),1.0/2)-1
		when mkt='arv' and MAT48=0 and MAT36=0 and MAT24=0  and MAT12<>0  then Power((MAT00/MAT12),1.0/1)-1
		when mkt='arv' and MAT48=0 and MAT36=0 and MAT24=0 and MAT12=0 then 0
		else null
	end as YTD00,
	case when mkt='arv' and MTH48<>0 then Power((MTH00/MTH48),1.0/4)-1
		when mkt='arv' and MTH48=0 and MTH36<>0 then Power((MTH00/MTH36),1.0/3)-1
		when mkt='arv' and MTH48=0 and MTH36=0 and MTH24<>0 then Power((MTH00/MTH24),1.0/2)-1
		when mkt='arv' and MTH48=0 and MTH36=0 and MTH24=0  and MTH12<>0  then Power((MTH00/MTH12),1.0/1)-1
		when mkt='arv' and MTH48=0 and MTH36=0 and MTH24=0 and MTH12=0 then 0
		else null
	end as YTD00	  
from OutputCityPerformanceByBrand_For_OtherETV A 
where exists(
	select * from (
		select distinct Molecule,Class,mkt,Market,mktname,Moneytype,audi_cod,region
		from OutputCityPerformanceByBrand_For_OtherETV 
		where Chart='Volume Trend' and R3M05<>0 and prod='000'
	) B
	where a.Molecule=b.Molecule and A.Class=B.Class and A.mkt=B.mkt and A.Market=B.Market
		and A.Moneytype=B.moneytype 
) and Chart='Volume Trend' 



go
insert into OutputCityPerformanceByBrand_For_OtherETV(Chart,[Molecule],[Class],[mkt],Market,[mktname],[Moneytype],audi_cod,audi_des,region,[prod],[Productname])
select * from (
select A.*,B.Prod,B.Productname from (
select distinct [Chart]
      ,[Molecule]
      ,[Class]
      ,[mkt]
      ,[Market]
      ,[mktname]
--      ,[prod]
--      ,[Productname]
      ,[Moneytype]
      ,[Audi_cod]
      ,[Audi_des]
      ,[Region] from [OutputCityPerformanceByBrand_For_OtherETV]) A inner join tblD080OutputProduct B  
on A.Chart=B.Chart and A.molecule=B.molecule and A.class=B.Class and A.mkt=B.mkt and A.Market=B.Market
and B.Active='Y' and A.Chart in ('Volume Trend','CAGR')) A
where not exists(
	select * 
	from [OutputCityPerformanceByBrand_For_OtherETV] B
	where A.Chart=B.Chart and A.molecule=B.molecule and A.class=B.Class and A.mkt=B.mkt and A.Market=B.Market
		and A.Productname=B.productname and A.audi_cod=B.audi_cod and A.region=B.region
)
go

 --and market='Baraclude' and mkt='HBV'
go
if exists(
	select * from tblD080OutputProduct A where not exists(select * from OutputCityPerformanceByBrand_For_OtherETV B
	where A.chart=B.chart and A.molecule=B.molecule and A.Class=B.Class
		and a.mkt=b.mkt and a.market=B.Market and a.productname=B.productname) and Active='Y'
)
	print 'need update table tblD080OutputProduct'
go
delete OutputCityPerformanceByBrand_For_OtherETV 
from OutputCityPerformanceByBrand_For_OtherETV A 
where not exists(
	select * from tblD080OutputProduct B
	where A.chart=B.chart and A.molecule=B.molecule and A.Class=B.Class
		and a.mkt=b.mkt and a.market=B.Market and a.productname=B.productname and Active='Y')
		and market not in ('Paraplatin','Coniel','Eliquis NOAC','Eliquis VTEp','Eliquis VTEt')
go
update OutputCityPerformanceByBrand_For_OtherETV
set R3M00=null,R3M01=null,R3M02=null,R3M03=null,R3M04=null,R3M05=null,
	R3M12=null,R3M13=null,R3M14=null,R3M15=null,R3M16=null,R3M17=null,
	YTD00 = null, YTD12 = null, YTD24 = null, YTD36 = null,
	MAT00 = null, MAT12 = null, MAT24 = null, MAT36 = null,
	MTH00 = null, MTH12 = null, MTH24 = null, MTH36 = null
from OutputCityPerformanceByBrand_For_OtherETV A 
where exists(
	select * from tblD080OutputProduct B
	where A.chart=B.chart and A.molecule=B.molecule and A.Class=B.Class
		and a.mkt=b.mkt and a.market=B.Market and a.productname=B.productname and Active='N'
)
go
update OutputCityPerformanceByBrand_For_OtherETV
set Productname='Monopril Market' 
where molecule='N' and class='N' and mkt='hyp'
	and Prod='000' and Productname='Hypertension Market'
go
update OutputCityPerformanceByBrand_For_OtherETV
set Productname='Taxol Market' 
where molecule='N' and class='N' and mkt='ONCFCS'
	and Prod='000' and Productname='Oncology Focused Brands'
go

exec dbo.sp_Log_Event 'MID','CIA','2_MID.sql','End',null,null