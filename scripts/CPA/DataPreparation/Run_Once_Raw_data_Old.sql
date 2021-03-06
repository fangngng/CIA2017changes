/* 
手工处理脚本：

Import Data 
 
*/


use BMSChinaOtherDB --DB4
GO

--current month : 201312 
--last month : 201311 






------------------------------------------------------------------------------------
-- 1. CPA数据处理
------------------------------------------------------------------------------------


select * into inCPAData_201312_All
from  dbo.inCPAData_201311_All
GO

--6月份数据需要替换的要先删除掉
/*
delete -- select *
from inCPAData_201306_All
where (CPA_Code = '0105' and  Y= '2013' and M= '3') 
      or (CPA_Code = '1141' and  Y= '2013' and M= '5')
*/      

--9月份数据需要替换的要先删除掉
/*
delete -- select *
from inCPAData_201311_All
where (CPA_Code = '0527' and  Y= '2013' and M= '1') 
      or (CPA_Code = '3113' and  Y= '2013' and M= '3')
      or (CPA_Code = '3302' and  Y= '2013' and M in ( '3','4','5','6','7'))
*/

--12月份数据需要替换的要先删除掉
delete 
from inCPAData_201312_All
where 
	      (CPA_Code = '0504' and  Y= '2013' and M in ( '1','2','3','4','5','6','7','8','9','10','11'))
      or (CPA_Code = '2068' and  Y= '2013' and M= '10')
      or (CPA_Code = '2074' and  Y= '2013' and M in ( '2','3','4','5','6','7','8','9'))
      or (CPA_Code = '3129' and  Y= '2013' and M in ( '5'))
      or (CPA_Code = '6506' and  Y= '2013' and M in ('10') )     
      
-- 每月数据

select * into  inCPA_201312 from inCPA_201311 where 1=0
GO
insert into  inCPA_201312(
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
 [地区]         as  [地区]        
 ,[年]          as  [年]         
 ,[季度]        as  [季度]       
 ,[月]          as  [月]         
 ,[医院编码]    as  [医院编码]   
 ,[ATC编码]     as  [ATC码]      
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
from [TempOutput].[dbo].[201312_cpa]

--当有要替换的数据时，运行下面的脚本

insert into  inCPA_201312(
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
 [地区]         as  [地区]        
 ,[年]          as  [年]         
 ,[季度]        as  [季度]       
 ,[月]          as  [月]         
 ,[医院编码]    as  [医院编码]   
 ,[ATC编码]     as  [ATC码]      
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
from [TempOutput].[dbo].[201312_cpa_替换数据$]


insert into  inCPA_201312(
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
 [地区]         as  [地区]        
 ,[年]          as  [年]         
 ,[季度]        as  [季度]       
 ,[月]          as  [月]         
 ,[医院编码]    as  [医院编码]   
 ,[ATC编码]     as  [ATC码]      
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
from [TempOutput].[dbo].[201312_cpa_补充数据]




-- 所有数据

insert into inCPAData_201312_All
select * from inCPA_201312
GO


-- 特殊处理
update inCPAData_201312_All set cpa_code = '1330' where cpa_code = '1324' --1324	吉林省	吉林市	吉林	吉林市医院	合入吉林市人民医院（1330）
go

update inCPAData_201312_All set Product = N'凯素'
where Manufacture = 'American Pharmaceutical Partners,Inc' and Product = N'紫杉醇'
go











------------------------------------------------------------------------------------
-- 2. 海虹数据处理
------------------------------------------------------------------------------------
select * into inSeaRainbowData_201312_all_Transfer  
from dbo.inSeaRainbowData_201311_all_Transfer
GO

insert into inSeaRainbowData_201312_all_Transfer (
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
 ,[单位转换比] as [TransferPercentage]
 ,[单位]       as [Package_Num]
 ,[包材]       as [Package_Material]
 ,[生产企业]   as [Manufacture]
 ,[年月]       as [YM]
 ,[价格]       as [Price]
 ,[单位转换比]*[订货数量]   as [Volume]
 ,[订货金额]   as [Value]
 ,[退货数量]   as [ReturnVolume]
 ,[退货金额]   as [ReturnValue]
from TempOutput.dbo.[201312_SeaRb_BMS-12月检索数据]
where 年月 = '201312'
GO



/*

2013/7/10 10:38:32
应客户要求，将包装盒转为片
select 
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
 ,[TransferPercentage]*[Volume] as [Volume]
 ,[Value]
 ,[ReturnVolume]
 ,[ReturnValue]
into inSeaRainbowData_201311_all_Transfer
from dbo.inSeaRainbowData_201307_all
GO

*/


