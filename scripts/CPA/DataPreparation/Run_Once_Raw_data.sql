/* 
手工处理脚本：

Import Data 
 
*/

--Time: 00:09

/*

说明:
对于每次源数据的表名,必须要命名如下(一下以201312月份数据举例)
CPA源数据:			cpa_RawData_201312
CPA替换数据或更新数据:		cpa_Replace_Data_201312
CPA补充数据：		cpa_Supplementary_Data_201312
SeaRainbow源数据：	SeaRainbow_RawData_201312
SeaRainbow补充历史数据：SeaRainbow_AddHospital_HistoryData_201312

*/


use BMSChinaOtherDB --DB4
GO
exec BMSChinaCIA_IMS.dbo.sp_Log_Event 'Hosp-RawData','CIA','Run_Once_Raw_data.sql','Start',null,null
--current month : 201312 
--last month : 201311 
declare @currentMonth varchar(10)
declare @lastMonth varchar(10)
declare @sql nvarchar(max)
set @currentMonth='201701' -- todo
set @lastMonth='201612' -- todo
set @sql=' '
------------------------------------------------------------------------------------
-- 1. CPA数据处理
------------------------------------------------------------------------------------

/*
年初更新CPA的历史数据
select * from dbo.inCPAData_201312_All 
where molecule=N'多西他赛' and product=N'多帕菲' and manufacture=N'山东齐鲁制药有限公司' and Specification in ('20 MG 0.5 ML','40 MG 1 ML')

update inCPAData_201312_All
set Specification= case when Specification='20 MG 1 ML' then '20 MG 0.5 ML' 
		 when Specification='40 MG 2 ML' then '40 MG 1 ML'  end 
where molecule=N'多西他赛' and product=N'多帕菲' and manufacture=N'山东齐鲁制药有限公司' and Specification in ('20 MG 1 ML','40 MG 2 ML')

3022	天津市	天津市	天津	天津市长征医院	合入天津中医药研究院附属医院(3031)
3037	天津市	天津市	天津	天津市天和医院	合入天津医院(3005)

		 
update inCPAData_201312_All
set cpa_code='3031'
where cpa_code='3022'

update inCPAData_201312_All
set cpa_code='3005'
where cpa_code='3037'

alter table inCPAData_201312_All alter column cpa_code nvarchar(10)

update a
set a.cpa_code=b.cpa_code
from inCPAData_201406_All a 
join (
	select distinct cpa_code_Old,cpa_code 
	from BMSChinaMRBI.dbo.tblHospitalMaster where datasource='CPA') b
on a.cpa_code=b.cpa_code_Old
--(1804698 row(s) affected)

*/
exec BMSChinaCIA_IMS.dbo.sp_Log_Event 'Hosp-RawData','CIA','Run_Once_Raw_data.sql','CPA',null,null

--Step1:	把上个月的CPA源数据结果表的值导入到当前月
set @sql = N'
if object_id(N''inCPAData_'+@currentMonth+N'_All'',N''U'') is not null
	drop table inCPAData_'+@currentMonth+N'_All

select * into inCPAData_'+@currentMonth+N'_All
from dbo.inCPAData_'+@lastMonth+N'_All	
'
--print @sql
exec (@sql)

--CPA 201507 month data replace: delete old data and insert new data to new month table
--The new data has included table dbo.cpa_RawData_201507, so add the following delete data operation

--select * into inCPAData_201507_All from inCPAData_201505_All where 0=1
--delete from inCPAData_201507_All
----select * from inCPAData_201507_All
--where (cpa_code='100131' and ((Y=2014 and m in (10,11,12)) or (y=2015 and m in (1,3)))) or
--	  (cpa_code='230051' and y=2015 and m=5) or  	
--	  (cpa_code='510021' and y=2015 and m in (2,3,4,5)) or 
--	  (cpa_code='510431' and y=2015 and m in (2,3,4,5)) or
--	  (cpa_code='710041' and y=2015 and m=3)
----order by cpa_code,y,m	  

--Step2:	删除需要替换的数据,一般都是在一个季度的最后一个月才会有这样的数据
set @sql = N'
if object_id(N''TempOutput.dbo.cpa_Replace_Data_'+@currentMonth+N''',N''U'') is not null
begin
	print N''删除需要替换的数据,一般都是在一个季度的最后一个月才会有这样的数据''
	delete from inCPAData_'+@currentMonth+N'_All
	where exists( select 1 from TempOutput.dbo.cpa_Replace_Data_'+@currentMonth+N' a 
				  where  inCPAData_'+@currentMonth+N'_All.cpa_code=a.医院编码 
			      and inCPAData_'+@currentMonth+N'_All.Y=a.年
			      and inCPAData_'+@currentMonth+N'_All.M=a.月
			      --and inCPAData_'+@currentMonth+N'_All.product=a.商品名
			    )
end			    
'
--print @sql
exec (@sql)

--Step3:	创建新的月份数据表，并向表里插入值
set @sql = N'
if object_id(N''inCPA_'+@currentMonth+N''',N''U'') is not null
	drop table inCPA_'+@currentMonth+N'

select * into inCPA_'+@currentMonth+N'
from dbo.inCPA_'+@lastMonth+N'
where 1=0	
'
--print @sql
exec (@sql)        
--select * into  inCPA_201312 from inCPA_201311 where 1=0
set @sql =N'
insert into  inCPA_'+@currentMonth+N' (
	[地区]
	,[年]
	,[季度]
	,[月]
	,[医院编码]
	,[ATC码]
	,[药品名称]
	,[商品名]
	,[包装]
	,[规格]
	,[包装数量]
	,[金额(元)]
	,[数量(支/片)]
	,[剂型]
	,[给药途径]
	,[生产厂家]
)
select 
	replace([城市], N''市'', '''')         as  [地区]        
	,[年]          as  [年]         
	,[季度]        as  [季度]       
	,[月]          as  [月]         
	,[医院编码]    as  [医院编码]   
	,[ATC码]     as  [ATC码]      
	,[药品名称]    as  [药品名称]   
	,[商品名]      as  [商品名]     
	,[包装单位]    as  [包装]       
	,[药品规格]    as  [规格]       
	,[包装数量]    as  [包装数量]   
	,[金额(元)]    as  [金额(元)]   
	,[数量(支/片)] as  [数量(支/片)]
	,[剂型]        as  [剂型]       
	,[给药途径]    as  [给药途径]   
	,[生产企业]    as  [生产厂家]   
from [TempOutput].[dbo].cpa_RawData_'+@currentMonth+N'
'
--print @sql
exec (@sql)

-- --当有要替换的数据时，运行下面的脚本
-- print 'Test'
-- set @sql=N'
-- if object_id(N''TempOutput.dbo.cpa_Replace_Data_'+@currentMonth+N''',N''U'') is not null
-- begin
-- 	print N''插入替换数据''
-- 	insert into  inCPA_'+@currentMonth+N'(
-- 	 [地区],[年],[季度],[月],[医院编码],[ATC码],[药品名称],[商品名],[包装],[规格]
-- 	 ,[包装数量],[金额(元)],[数量(支/片)],[剂型],[给药途径],[生产厂家]
-- 	)
-- 	select 
-- 	 [地区]         as  [地区]        
-- 	 ,[年]          as  [年]         
-- 	 ,[季度]        as  [季度]       
-- 	 ,[月]          as  [月]         
-- 	 ,[医院编码]    as  [医院编码]   
-- 	 ,[ATC码]     as  [ATC码]      
-- 	 ,[药品名称]    as  [药品名称]   
-- 	 ,[商品名]      as  [商品名]     
-- 	 ,[包装单位]    as  [包装]       
-- 	 ,[药品规格]    as  [规格]       
-- 	 ,[包装数量]    as  [包装数量]   
-- 	 ,[金额(元)]    as  [金额(元)]   
-- 	 ,[数量(支/片)] as  [数量(支/片)]
-- 	 ,[剂型]        as  [剂型]       
-- 	 ,[给药途径]    as  [给药途径]   
-- 	 ,[生产企业]    as  [生产厂家]   
-- 	from TempOutput.dbo.cpa_Replace_Data_'+@currentMonth+N'
-- end	
-- '
-- --print @sql
-- exec (@sql)

-- --当有新补充的数据时，运行如下脚本
-- set @sql=N'
-- if object_id(N''TempOutput.dbo.cpa_Supplementary_Data_'+@currentMonth+N''',N''U'') is not null
-- begin
-- 	insert into  inCPA_'+@currentMonth+N' (
-- 	 [地区]
-- 	 ,[年]
-- 	 ,[季度]
-- 	 ,[月]
-- 	 ,[医院编码]
-- 	 ,[ATC码]
-- 	 ,[药品名称]
-- 	 ,[商品名]
-- 	 ,[包装]
-- 	 ,[规格]
-- 	 ,[包装数量]
-- 	 ,[金额(元)]
-- 	 ,[数量(支/片)]
-- 	 ,[剂型]
-- 	 ,[给药途径]
-- 	 ,[生产厂家]
-- 	)
-- 	select 
-- 	 [地区]         as  [地区]        
-- 	 ,[年]          as  [年]         
-- 	 ,[季度]        as  [季度]       
-- 	 ,[月]          as  [月]         
-- 	 ,[医院编码]    as  [医院编码]   
-- 	 ,[ATC码]     as  [ATC码]      
-- 	 ,[药品名称]    as  [药品名称]   
-- 	 ,[商品名]      as  [商品名]     
-- 	 ,[包装单位]    as  [包装]       
-- 	 ,[药品规格]    as  [规格]       
-- 	 ,[包装数量]    as  [包装数量]   
-- 	 ,[金额(元)]    as  [金额(元)]   
-- 	 ,[数量(支/片)] as  [数量(支/片)]
-- 	 ,[剂型]        as  [剂型]       
-- 	 ,[给药途径]    as  [给药途径]   
-- 	 ,[生产企业]    as  [生产厂家]   
-- 	from TempOutput.dbo.cpa_Supplementary_Data_'+@currentMonth+N'
-- end
-- '
-- --print @sql
-- exec (@sql)

-- 所有数据
set @sql=N'
insert into inCPAData_'+@currentMonth+N'_All
select * from inCPA_'+@currentMonth+N'
'
--print @sql
exec (@sql)

-- 特殊处理
-- 合并的医院
set @sql=N'
update inCPAData_'+@currentMonth+N'_All set cpa_code = ''1330'' where cpa_code = ''1324''
' --1324	吉林省	吉林市	吉林	吉林市医院	合入吉林市人民医院（1330）
--print @sql
exec (@sql)

set @sql=N'
update inCPAData_'+@currentMonth+N'_All set cpa_code = ''450191'' where cpa_code = ''450271''
' 
--450271	河南省	郑州	郑州大学第四附属医院（河南省口腔医院）	合入（450191）
--print @sql
exec (@sql)


set @sql=N'
update inCPAData_'+@currentMonth+N'_All set cpa_code = ''510011'' where cpa_code = ''510311''
' 
--510311	河南省	郑州	中山大学第一附属医院东山院区	合入（510011）
--print @sql
exec (@sql)

-- 产品更新
set @sql=N'
update inCPAData_'+@currentMonth+N'_All 
set Product = N''凯素''
where Manufacture = ''American Pharmaceutical Partners,Inc'' and Product = N''紫杉醇''
'
--print @sql
exec (@sql)



------------------------------------------------------------------------------------
-- 2. 海虹数据处理
------------------------------------------------------------------------------------
/*
在年初更新历史医院的医院
update  a
set a.hospital=b.hospitalName
from dbo.inSeaRainbowData_201312_all_Transfer a join (
SELECT distinct 医院名称 as hospitalName,bms曾用名 as bmsUsedName,更新医院名称 as update_Hosp_name,
	更新BMS曾用名 as update_BMSUsedName
 FROM [BMSChinaOtherDB].[dbo].[inSeaRainbow_HospitalList_2014_Finally]
 )b on (a.hospital=b.update_BMSUsedName) or(a.hospital=b.update_Hosp_name) or(a.hospital=b.bmsUsedName)
  
*/

exec BMSChinaCIA_IMS.dbo.sp_Log_Event 'Hosp-RawData','CIA','Run_Once_Raw_data.sql','SeaRainbow',null,null
set @sql=N'
if object_id(N''inSeaRainbowData_'+@currentMonth+N'_all_Transfer'',N''U'') is not null
	drop table inSeaRainbowData_'+@currentMonth+N'_all_Transfer

select * into inSeaRainbowData_'+@currentMonth+N'_all_Transfer  
from dbo.inSeaRainbowData_'+@lastMonth+N'_all_Transfer
'
--print @sql
exec (@sql)
print 'SeaRainbow raw data'
set @sql=N'
insert into inSeaRainbowData_'+@currentMonth+N'_all_Transfer (
	[Province]
	,[City]
	,[Hospital]
	,[Molecule]
	,[CommonName]
	,[Product]
	,[FormI]
	,[Specification]
	,[TransferPercentage]
	,[Package_Num]
	,[Package_Material]
	,[Manufacture]
	,[YM]
	,[Price]
	,[Volume]
	,[Value]
	,[ReturnVolume]
	,[ReturnValue]
)
select 
	[省份]       as [Province]
	,[城市]       as [City]
	,[医院名称]   as [Hospital]
	,[标准通用名] as [Molecule]
	,[通用名]     as [CommonName]
	,[商品名]     as [Product]
	,[剂型]       as [FormI]
	,[规格]       as [Specification]
	,[转换比] as [TransferPercentage]
	,[单位]       as [Package_Num]
	,[包装]       as [Package_Material]
	,[生产企业]   as [Manufacture]
	,[年月]       as [YM]
	,[价格]       as [Price]
	,[转换比]*[订货数量（盒）]   as [Volume]
	,[订货金额（元）]   as [Value]
	,[退货数量（盒）]   as [ReturnVolume]
	,[退货金额（元）]   as [ReturnValue]
from TempOutput.dbo.SeaRainbow_RawData_'+@currentMonth+N'
where 年月 = '''+@currentMonth+N'''
'
--print @sql
exec (@sql)

set @sql=N'
if object_id(N''TempOutput.dbo.SeaRainbow_AddHospital_HistoryData_'+@currentMonth+N''',N''U'') is not null
begin
	insert into inSeaRainbowData_'+@currentMonth+N'_all_Transfer (
	[Province]
	,[City]
	,[Hospital]
	,[Molecule]
	,[CommonName]
	,[Product]
	,[FormI]
	,[Specification]
	,[TransferPercentage]
	,[Package_Num]
	,[Package_Material]
	,[Manufacture]
	,[YM]
	,[Price]
	,[Volume]
	,[Value]
	,[ReturnVolume]
	,[ReturnValue]
)
select 
	[省份]       as [Province]
	,[城市]       as [City]
	,[医院名称]   as [Hospital]
	,[标准通用名] as [Molecule]
	,[通用名]     as [CommonName]
	,[商品名]     as [Product]
	,[剂型]       as [FormI]
	,[规格]       as [Specification]
	,[转换比] as [TransferPercentage]
	,[单位]       as [Package_Num]
	,[包装]       as [Package_Material]
	,[生产企业]   as [Manufacture]
	,[年月]       as [YM]
	,[价格]       as [Price]
	,[转换比]*[订货数量（盒）]   as [Volume]
	,[订货金额（元）]   as [Value]
	,[退货数量（盒）]   as [ReturnVolume]
	,[退货金额（元）]   as [ReturnValue]
from TempOutput.dbo.SeaRainbow_AddHospital_HistoryData_'+@currentMonth+N'
end
'
exec (@sql)


----新增医院15年历史数据：
--set @sql=N'
--insert into inSeaRainbowData_'+@currentMonth+N'_all_Transfer (
--  [Province]
-- ,[City]
-- ,[Hospital]
-- ,[Molecule]
-- ,[CommonName]
-- ,[Product]
-- ,[FormI]
-- ,[Specification]
-- ,[TransferPercentage]
-- ,[Package_Num]
-- ,[Package_Material]
-- ,[Manufacture]
-- ,[YM]
-- ,[Price]
-- ,[Volume]
-- ,[Value]
-- ,[ReturnVolume]
-- ,[ReturnValue]
--)
--select 
--  [省份]       as [Province]
-- ,[城市]       as [City]
-- ,[医院名称]   as [Hospital]
-- ,[标准通用名] as [Molecule]
-- ,[通用名]     as [CommonName]
-- ,[商品名]     as [Product]
-- ,[剂型]       as [FormI]
-- ,[规格]       as [Specification]
-- ,[转换比] as [TransferPercentage]
-- ,[单位]       as [Package_Num]
-- ,[包装]       as [Package_Material]
-- ,[生产企业]   as [Manufacture]
-- ,[年月]       as [YM]
-- ,[价格]       as [Price]
-- ,[转换比]*[订货数量（盒）]   as [Volume]
-- ,[订货金额（元）]   as [Value]
-- ,[退货数量（盒）]   as [ReturnVolume]
-- ,[退货金额（元）]   as [ReturnValue]
--from TempOutput.dbo.SeaRainbow_RawData_new_manuf

--'
--exec (@sql)

--
--补充201605广西数据：
--set @sql=N'
--insert into inSeaRainbowData_'+@currentMonth+N'_all_Transfer (
--  [Province]
-- ,[City]
-- ,[Hospital]
-- ,[Molecule]
-- ,[CommonName]
-- ,[Product]
-- ,[FormI]
-- ,[Specification]
-- ,[TransferPercentage]
-- ,[Package_Num]
-- ,[Package_Material]
-- ,[Manufacture]
-- ,[YM]
-- ,[Price]
-- ,[Volume]
-- ,[Value]
-- ,[ReturnVolume]
-- ,[ReturnValue]
--)
--select 
--  [省份]       as [Province]
-- ,[城市]       as [City]
-- ,[医院名称]   as [Hospital]
-- ,[标准通用名] as [Molecule]
-- ,[通用名]     as [CommonName]
-- ,[商品名]     as [Product]
-- ,[剂型]       as [FormI]
-- ,[规格]       as [Specification]
-- ,[转换比] as [TransferPercentage]
-- ,[单位]       as [Package_Num]
-- ,[包装]       as [Package_Material]
-- ,[生产企业]   as [Manufacture]
-- ,[年月]       as [YM]
-- ,[价格]       as [Price]
-- ,[转换比]*[订货数量（盒）]   as [Volume]
-- ,[订货金额（元）]   as [Value]
-- ,[退货数量（盒）]   as [ReturnVolume]
-- ,[退货金额（元）]   as [ReturnValue]
--from TempOutput.dbo.SeaRainbow_RawData_Guangxi_201606

--'
--exec (@sql)

----新增药品15年历史数据：
--set @sql=N'
--insert into inSeaRainbowData_'+@currentMonth+N'_all_Transfer (
--  [Province]
-- ,[City]
-- ,[Hospital]
-- ,[Molecule]
-- ,[CommonName]
-- ,[Product]
-- ,[FormI]
-- ,[Specification]
-- ,[TransferPercentage]
-- ,[Package_Num]
-- ,[Package_Material]
-- ,[Manufacture]
-- ,[YM]
-- ,[Price]
-- ,[Volume]
-- ,[Value]
-- ,[ReturnVolume]
-- ,[ReturnValue]
--)
--select 
--  [省份]       as [Province]
-- ,[城市]       as [City]
-- ,[医院名称]   as [Hospital]
-- ,[标准通用名] as [Molecule]
-- ,[通用名]     as [CommonName]
-- ,[商品名]     as [Product]
-- ,[剂型]       as [FormI]
-- ,[规格]       as [Specification]
-- ,[转换比] as [TransferPercentage]
-- ,[单位]       as [Package_Num]
-- ,[包装]       as [Package_Material]
-- ,[生产企业]   as [Manufacture]
-- ,[年月]       as [YM]
-- ,[价格]       as [Price]
-- ,[转换比]*[订货数量（盒）]   as [Volume]
-- ,[订货金额（元）]   as [Value]
-- ,[退货数量（盒）]   as [ReturnVolume]
-- ,[退货金额（元）]   as [ReturnValue]
--from TempOutput.dbo.SeaRainbow_RawData_newprod_2015

--'
--exec (@sql)
---------------------------------------------------
--			国药数据的处理
---------------------------------------------------
exec BMSChinaCIA_IMS.dbo.sp_Log_Event 'Hosp-RawData','CIA','Run_Once_Raw_data.sql','PHA',null,null
print '
---------------------------------------------------
--			Pharmatrust Data
---------------------------------------------------'
set @sql=N'
if object_id(N''inPharmData_'+@currentMonth+N'_all'',N''U'') is not null
	drop table inPharmData_'+@currentMonth+N'_all

select * into inPharmData_'+@currentMonth+N'_all
from dbo.inPharmData_'+@lastMonth+N'_all
'
--print @sql
exec (@sql)

set @sql = N'
	update TempOutput.dbo.PharmRawData_'+@currentMonth+N'
	set 商品名 = 通用名
	where 商品名 is null or ltrim(rtrim(商品名)) = ''''
'
print(@sql)

exec (@sql)

set @sql=N'
insert into inPharmData_'+@currentMonth+N'_all (
	Province ,
	City ,
	Y ,
	Q,
	M ,
	Pharm_Hospital_Code ,
	Tier,
	Molecule,
	Product,
	Specification,
	Form ,
	Package_Num,
	Way,
	Volume,
	Value,
	Manufacture
)
select 
	   [省份]
      ,[城市]
      ,[年]
      ,[季度]
      ,[月份]
      ,[医院编码]
      ,[医院等级]
      ,[通用名]
      ,[商品名]
      ,[规格]
      ,[剂型]
      ,[包装规格]
      ,[给药途径]
      ,[最小制剂单位数量]
      ,[金额(元)]
      ,[生产企业]
from TempOutput.dbo.PharmRawData_'+@currentMonth+N'
where convert(varchar(10),年)+ right(''0''+convert(varchar(10),月份),2)='''+@currentMonth+N'''
'
exec (@sql)

--update data

set @sql=N'
update b
set b.Volume=a.[最小制剂单位数量],
	b.Value=a.[金额(元)]
from TempOutput.dbo.PharmRawData_'+@currentMonth+N' a 
join inPharmData_'+@currentMonth+N'_all b
on a.省份=b.Province and a.城市=b.City and a.年=b.Y and a.月份=b.M and a.医院编码=b.Pharm_Hospital_Code and a.通用名=b.Molecule
  and a.商品名=b.Product and a.规格=b.Specification and a.剂型=b.Form and a.包装规格=b.Package_Num
  and a.给药途径=b.way and a.生产企业=b.Manufacture
where convert(varchar(10),a.年)+ right(''0''+convert(varchar(10),a.月份),2)<>'''+@currentMonth+N'''
'
exec ( @sql)


set @sql=N'
insert into inPharmData_'+@currentMonth+N'_all (
	Province ,
	City ,
	Y ,
	Q,
	M ,
	Pharm_Hospital_Code ,
	Tier,
	Molecule,
	Product,
	Specification,
	Form ,
	Package_Num,
	Way,
	Volume,
	Value,
	Manufacture
)
select 
	   [省份]
      ,[城市]
      ,[年]
      ,[季度]
      ,[月份]
      ,[医院编码]
      ,[医院等级]
      ,[通用名]
      ,[商品名]
      ,[规格]
      ,[剂型]
      ,[包装规格]
      ,[给药途径]
      ,[最小制剂单位数量]
      ,[金额(元)]
      ,[生产企业]
from TempOutput.dbo.PharmRawData_'+@currentMonth+N' a 
where not exists(
	select 1 from inPharmData_'+@currentMonth+N'_all b
	where a.省份=b.Province and a.城市=b.City and a.年=b.Y and a.月份=b.M and a.医院编码=b.Pharm_Hospital_Code and a.通用名=b.Molecule
		  and a.商品名=b.Product and a.规格=b.Specification and a.剂型=b.Form and a.包装规格=b.Package_Num
		  and a.给药途径=b.way and a.生产企业=b.Manufacture
)
and convert(varchar(10),a.年)+ right(''0''+convert(varchar(10),a.月份),2)<>'''+@currentMonth+N'''
'
exec ( @sql)