/* 预处理 */

use BMSChinaMRBI --DB4
go

--time 04:42

exec dbo.sp_Log_Event 'Init','CIA_CPA','0_1_Import.sql','Start',null,null




update tblDSDates set 
	Value2 = '20170131', -- todo -- 注意选择每月的最后一天
	Value1 = '201701'    -- todo
where Item = 'CPA'  
go

----Alince Wang 2015-11-05 for updatding tblHospitalMaster new BMS_Code and BMS_Name from CSR's tables
----begin
--code
update tblHospitalMaster set BMS_Code=b.PAR_CUST_CD
from tblHospitalMaster a 
join 
	(select distinct CUST_CD,PAR_CUST_CD from  db6.[BMSChinaCSR2013_DBDev].[dbo].[inCustomer_Merge] ) b
on a.BMS_Code=b.CUST_CD
--name
update tblHospitalMaster set BMS_Hosp_Name=right(INS_NAME,len(INS_NAME)-11)
from tblHospitalMaster a
join 
	(select distinct INS_CODE,INS_NAME from  db6.[BMSChinaCSR2013_DBDev].[dbo].[inHospitalMaster] ) b
on a.BMS_Code=b.INS_CODE
---end

-- update BAL hospital 
if object_id(N'tblBALHospital',N'U') is not null
	drop table tblBALHospital
go 
SELECT * INTO tblBALHospital FROM DB36.[BMSChinaCSR_Testing].[dbo].Output_BAL_Hospital_ForCIA


print '-----------------------------------
         inCPAData
------------------------------------------'
if object_id(N'inCPAData',N'U') is not null
	drop table inCPAData
go
declare @mth varchar(6), @mthdt varchar(8), @sql varchar(500)
select @mthdt = Value2, @mth = Value1 from tblDSDates where Item = 'CPA'
set @sql = '
select * into inCPAData 
from BMSChinaOtherDB.dbo.inCPAData_' + @mth + '_All a' + '
where left(convert(varchar(8),convert(datetime,a.m+''/1/''+a.y,101),112),6) <=''' + @mth + '''
	and left(convert(varchar(8),convert(datetime,a.m+''/1/''+a.y,101),112),6) >=''200901''
'
--print @sql
exec (@sql)
go

alter table inCPAData add AvgPatientMG float 
GO
update inCPAData set AvgPatientMG =
   case when Molecule = N'卡铂'   then 600
        when Molecule = N'顺铂'   then 120
        when Molecule = N'奈达铂' then 150
        else null
        end

--由于医院的合并，更新合并的医院code为并入的医院的code 2015/03/24  xiaoyu.chen     
--成都市儿童医院（610201）和成都市妇幼保健院（610341）并入到 成都市妇女儿童 中心医院(610481)
update inCPAData
set cpa_code='610481'
where cpa_code in ('610341','610201')

--update CPA _CODE
update inCPAData set cpa_code='110563' where cpa_code='110561'
update inCPAData set cpa_code='230233' where cpa_code='230231'

-- 医院合并 --Eddy 20170117
update inCPAData set cpa_code='510011' where cpa_code='510311'
update inCPAData set cpa_code='450191' where cpa_code='450271'


GO 

-- 追加cpa_id，tier
alter table inCPAData add 
	cpa_id int,
	tier varchar(5)
go
update inCPAData set cpa_id = id,tier = b.Tier
from inCPAData a
inner join tblHospitalMaster b on a.cpa_code = b.cpa_code
go

-- 删除没有列在出版目录中的医院数据
select 'hospital which is not in our list and it would be deleted'
select N'CPA的记录条数',count(*) from inCPAData
select N'cpa_id为空的记录条数',count(*) from inCPAData where cpa_id is null
go
delete inCPAData where cpa_id is null
go




/*****************************************特殊处理 开始******************************************/

-- From Jun'12, ignore the negative data
update inCPAData set [Value] = 0 where [Value] < 0
go
update inCPAData set Volume = 0 where Volume < 0
go

--update inCPAData set Product = N'凯素'
--where Manufacture = 'American Pharmaceutical Partners,Inc' and Product = N'紫杉醇'
--go

--更新产品的名字 2015/03/24 xiaoyu.chen
update inCPAData set product=N'天伦' where molecule=N'多西他赛' and product=N'多西他赛' and manufacture=N'扬子江药业集团江苏制药股份有限公司'
update inCPAData set product=N'天伦' where molecule=N'多西他赛' and product=N'多西他赛' and manufacture=N'扬子江药业集团有限公司'
update inCPAData set product=N'依尼舒' where molecule=N'达沙替尼' and product=N'达沙替尼' and manufacture=N'江苏正大天晴药业股份有限公司'


-- 同一个厂商的 药厂名字更新或者有误的：
update inCPAData set Manufacture=N'江苏扬州奥赛康药业有限公司' where [Product] =N'奥素'  and Y='2012' and m in ('8','9','10','11','12')
go
update inCPAData set Manufacture=N'江苏扬州奥赛康药业有限公司' where [Product] =N'奥名润'  and Y='2012' 
go
update inCPAData set Manufacture=N'江苏扬州奥赛康药业有限公司' where [Product] =N'吉西他滨'  and Y='2012' 
go
--
update inCPAData set Manufacture = N'山东威海迪沙药业有限公司'              where Molecule = N'硝苯地平' and Product=N'硝苯地平'           
update inCPAData set Manufacture = N'华北制药集团制剂有限公司'              where Molecule = N'卡托普利' and Product=N'卡托普利'
update inCPAData set Manufacture = N'上海九福药业有限公司'                  where Molecule = N'卡托普利' and Product=N'卡托普利'
update inCPAData set Manufacture = N'东北制药集团股份有限公司'              where Molecule = N'氨氯地平' and Product=N'伏络清'
update inCPAData set Manufacture = N'上海新亚药业有限公司'                  where Molecule = N'贝那普利' and Product=N'新亚利普'
update inCPAData set Manufacture = N'山东鲁南制药股份有限公司'              where Molecule = N'缬沙坦'   and Product=N'平欣'  
update inCPAData set Manufacture = N'百特集团'                              where Molecule = N'艾塞那肽' and Product=N'百泌达'
update inCPAData set Manufacture = N'华北制药集团制剂有限公司'              where Molecule = N'二甲双胍' and Product=N'二甲双胍'
update inCPAData set Manufacture = N'石家庄制药集团四药股份有限公司'        where Molecule = N'格列齐特' and Product=N'依利唐可'
update inCPAData set Manufacture = N'山东威海迪沙药业有限公司'              where Molecule = N'格列吡嗪' and Product=N'格列吡嗪'
update inCPAData set Manufacture = N'扬子江药业集团江苏制药股份有限公司'    where Molecule = N'格列吡嗪' and Product=N'秦苏'
update inCPAData set Manufacture = N'扬子江药业集团江苏制药股份有限公司'    where Molecule = N'格列美脲' and Product=N'佑苏'
update inCPAData set Manufacture = N'太极集团四川太极制药有限公司'          where Molecule = N'罗格列酮' and Product=N'太罗'
update inCPAData set Manufacture = N'北京双鹤药业股份有限公司'              where Molecule = N'吡格列酮' and Product=N'列洛'
update inCPAData set Manufacture = N'江苏南京思科药业有限公司'              where Molecule = N'紫杉醇'   and Product=N'力扑素'  
GO
--2013/4/2 15:57:49
update inCPAData set Manufacture = N'中美上海施贵宝制药有限公司'            where Molecule = N'卡铂'   and Product=N'伯尔定'  
GO
--2013/4/21 21:43:04
update inCPAData set Manufacture=N'珠海联邦制药股份有限公司中山分公司'      where Manufacture=N'珠海联邦制药股份有限公司'
GO
--2013/7/18 10:03:06
update inCPAData set Manufacture=N'英国葛兰素史克集团'                      where Manufacture like N'%史克%'


update inCPAData set Manufacture=N'瑞士诺华制药有限公司' where Manufacture =N'北京诺华制药有限公司'
--Modify Manufacture of 201403 month data
update inCPAData set Manufacture=N'海口市制药厂有限公司' where Manufacture=N'海南轻骑海药股份有限公司' and Molecule=N'紫杉醇'


--更新厂商的名字
update inCPAData set Manufacture = N'扬子江药业集团广州海瑞药业有限公司'  where Molecule = N'厄贝沙坦' and Product=N'厄贝沙坦' and Manufacture = N'扬子江药业集团北京海燕药业有限公司'
update inCPAData set Manufacture = N'上海信谊天平药业有限公司'  where Molecule = N'替米沙坦' and Product=N'嘉瑟宜' and Manufacture = N'上海信谊嘉华药业有限公司'
update inCPAData set Manufacture = N'四川科伦药业股份有限公司'  where Molecule = N'替米沙坦' and Product=N'斯泰乐' and Manufacture = N'四川珍珠制药有限公司'
update inCPAData set Manufacture = N'四川科伦药业股份有限公司'  where Molecule = N'替米沙坦' and Product=N'斯泰乐' and Manufacture = N'四川珍珠制药有限公司'
update inCPAData set Manufacture = N'世贸天阶制药（江苏）有限责任公司'  where Molecule = N'二甲双胍' and Product=N'二甲双胍' and Manufacture = N'江苏方强制药厂'
update inCPAData set Manufacture = N'天津亚宝药业科技有限公司'  where Molecule = N'二甲双胍' and Product=N'二甲双胍' and Manufacture = N'亚宝药业集团股份有限公司'
update inCPAData set Manufacture = N'世贸天阶制药（江苏）有限责任公司'  where Molecule = N'格列吡嗪' and Product=N'格列吡嗪' and Manufacture = N'江苏方强制药厂'
update inCPAData set Manufacture = N'上海信谊药厂有限公司'  where Molecule = N'格列吡嗪' and Product=N'优哒灵' and Manufacture = N'上海医药(集团)有限公司信谊制药总厂'
update inCPAData set Manufacture = N'吉林金恒制药股份有限公司'  where Molecule = N'格列喹酮' and Product=N'格列喹酮' and Manufacture = N'吉林恒和制药股份有限公司'
update inCPAData set Manufacture = N'江苏德源药业有限公司'  where Molecule = N'那格列奈' and Product=N'唐瑞' and Manufacture = N'江苏恒瑞医药股份有限公司'
update inCPAData set Manufacture = N'武汉生物化学制药有限公司'  where Molecule = N'那格列奈' and Product=N'那格列奈' and Manufacture = N'武汉长联来福生化药业有限责任公司'
update inCPAData set Manufacture = N'国药集团工业有限公司'  where Molecule = N'硝苯地平' and Product=N'硝苯地平' and Manufacture = N'国药集团工业股份有限公司北京顺义分公司'
update inCPAData set Manufacture = N'山西太原药业有限公司'  where Molecule = N'硝苯地平' and Product=N'硝苯地平' and Manufacture = N'华北制药集团山西博康药业有限公司'
update inCPAData set Manufacture = N'上海信谊天平药业有限公司'  where Molecule = N'硝苯地平' and Product=N'硝苯地平' and Manufacture = N'上海天平制药有限公司'
update inCPAData set Manufacture = N'南京正大天晴制药有限公司'  where Molecule = N'吉西他滨' and Product=N'益菲' and Manufacture = N'江苏正大天晴药业股份有限公司'
update inCPAData set Manufacture = N'Abraxis BioScience, LLC （US）'  where Molecule = N'紫杉醇' and Product=N'紫杉醇' and Manufacture = N'American Pharmaceutical Partners,Inc'
update inCPAData set Manufacture = N'美国百时美施贵宝制药公司 (US)'  where Molecule = N'紫杉醇' and Product=N'泰素' and Manufacture = N'中美上海施贵宝制药有限公司'
update inCPAData set Manufacture = N'扬子江药业集团有限公司'  where Molecule = N'紫杉醇' and Product=N'福王' and Manufacture = N'扬子江药业集团江苏制药股份有限公司'
update inCPAData set Manufacture = N'德国安万特贝林有限公司'  where Molecule = N'多西他赛' and Product=N'泰索帝' and Manufacture = N'浙江杭州赛诺菲圣德拉堡民生制药有限公司'
update inCPAData set Manufacture = N'扬子江药业集团有限公司'  where Molecule = N'多西他赛' and Product=N'天伦' and Manufacture = N'扬子江药业集团江苏制药股份有限公司'
update inCPAData set Manufacture = N'天津亚宝药业科技有限公司'  where Molecule = N'卡托普利' and Product=N'卡托普利' and Manufacture = N'天津飞鹰制药有限公司'
update inCPAData set Manufacture = N'杭州康恩贝制药有限公司'  where Molecule = N'吡格列酮' and Product=N'吡格列酮' and Manufacture = N'浙江康恩贝制药股份有限公司'
update inCPAData set Manufacture = N'扬子江药业集团北京海燕药业有限公司'  where Molecule = N'厄贝沙坦' and ATC_code='C09CA04' and Manufacture = N'扬子江药业集团广州海瑞药业有限公司'
update inCPAData set Manufacture = N'上海医药(集团)有限公司信谊制药总厂'  where Molecule = N'卡托普利' and ATC_code='C09AA01' and Manufacture = N'上海天平胃舒平制药厂'
update inCPAData set product=N'将唐君' where ATC_CODE='A10BA02' and molecule=N'二甲双胍' and manufacture=N'广东深圳中联制药厂' and form='CAP' and way='OR' and product=N'美迪康'
update inCPAData set Manufacture=N'海南中和药业有限公司' where Manufacture=N'海南中和药业股份有限公司'
update inCPAData set Manufacture=N'江苏奥赛康药业股份有限公司' where Manufacture=N'江苏扬州奥赛康药业有限公司'
update inCPAData set Manufacture=N'山东鲁抗辰欣药业有限公司' where Manufacture=N'湘北威尔曼制药公司'
update inCPAData set Manufacture=N'湘北威尔曼制药有限公司' where Manufacture=N'湖北威尔曼制药有限公司'
update inCPAData set Manufacture=N'湘北威尔曼制药有限公司' where Manufacture=N'湖南湘北威尔曼制药有限公司'
update inCPAData set Manufacture=N'黑龙江哈尔滨三联药业有限公司' where Manufacture=N'哈尔滨三联药业有限公司'
update inCPAData set Manufacture=N'南京绿叶思科药业有限公司' where Manufacture=N'江苏南京思科药业有限公司'
update inCPAData set Manufacture=N'四川三精升和制药有限公司' where Manufacture=N'四川升和制药有限公司'
update inCPAData set Manufacture=N'山西普德药业股份有限公司' where Manufacture=N'山西普德药业有限公司'
update inCPAData set Manufacture=N'北京悦康药业有限公司' where Manufacture=N'悦康药业集团有限公司'
update inCPAData set Manufacture=N'海南中化联合制药工业股份有限公司' where Manufacture=N'海南中化联合制药工业有限公司'
update inCPAData set Manufacture=N'重庆莱美药业股份有限公司' where Manufacture=N'重庆莱美药业有限公司'
update inCPAData set Manufacture=N'武汉李时珍药业有限公司' where Manufacture=N'黄石李时珍医药集团有限公司'
update inCPAData set Manufacture=N'浙江万晟药业有限公司' where Manufacture=N'浙江万马药业有限公司'
update inCPAData set Manufacture=N'北京赛诺菲-安万特制药有限公司' where Manufacture=N'德国安万特贝林有限公司'
update inCPAData set Manufacture=N'北京协和药厂' where Manufacture=N'北京协和制药厂'


-- 生产企业更新

update inCPAData set Manufacture = N'海正辉瑞制药有限公司' where Manufacture = N'浙江海正药业股份有限公司' and Product = N'多西他赛' and Molecule = N'多西他赛'  
update inCPAData set Manufacture = N'齐鲁制药有限公司' where Manufacture = 'N山东齐鲁制药有限公司' and Product in ( N'多帕菲') and Molecule = N'多西他赛'  
update inCPAData set Manufacture = N'齐鲁制药有限公司' where Manufacture = N'山东齐鲁制药有限公司' and Product = N'亿来芬' and Molecule = N'阿德福韦酯' 
update inCPAData set Manufacture = N'深圳万乐药业有限公司' where Manufacture = N'广东深圳万乐药业有限公司' and Product in ( N'希存' ) and Molecule = N'多西他赛' 
update inCPAData set Manufacture = N'深圳万乐药业有限公司' where Manufacture = N'广东深圳万乐药业有限公司' and Product = N'杉素' and Molecule = N'紫杉醇' 
update inCPAData set Manufacture = N'美国百时美施贵宝制药公司 （US）' where Manufacture = N'美国百时美施贵宝制药公司 (US)' and Product = N'泰素' and Molecule = N'紫杉醇' 
update inCPAData set Manufacture = N'苏州东瑞制药有限公司' where Manufacture = N'江苏苏州东瑞制药有限公司' and Product = N'雷易得' and Molecule = N'恩替卡韦' 
update inCPAData set Manufacture = N'深圳海王药业有限公司' where Manufacture = N'广东深圳海王药业有限公司' and Product = N'紫杉醇' and Molecule = N'紫杉醇' 
update inCPAData set Manufacture = N'北京协和药厂' where Manufacture = N'北京协和制药厂' and Product = N'紫素' and Molecule = N'紫杉醇' 
update inCPAData set Manufacture = N'北京双鹭药业股份有限公司' where Manufacture = N'北京双鹭药业有限公司' and Product = N'紫杉醇' and Molecule = N'紫杉醇' 
update inCPAData set Manufacture = N'北京双鹭药业股份有限公司' where Manufacture = N'北京双鹭药业有限公司' and Product = N'北京双鹭药业有限公司' and Molecule = N'阿德福韦酯' 


/**********************************更新医院的名称************************************/



/*****************************************特殊处理 结束******************************************/




--创建索引
create nonclustered index idx1  on inCPAData(cpa_code)
go
create nonclustered index idx2  on inCPAData(Molecule,Product)
go











print '-----------------------------------
         inSeaRainbowData
------------------------------------------'
if object_id(N'inSeaRainbowData',N'U') is not null
	drop table inSeaRainbowData
go
declare @mth varchar(6), @mthdt varchar(8), @sql varchar(500)
select @mthdt = Value2, @mth = Value1 from tblDSDates where Item = 'CPA'
set @sql = '
select * into inSeaRainbowData
from BMSChinaOtherDB.dbo.inSeaRainbowData_' + @mth + '_all_Transfer' + '
where YM <=''' + @mth + '''
and YM >=''200901''
'
--print @sql
exec (@sql)
go
--更新医院的名称
update inSeaRainbowData
set hospital=N'徐州市中心医院'
where Hospital=N'徐州市中心医院（四院）'


alter table inSeaRainbowData add AvgPatientMG float 
GO
update inSeaRainbowData set AvgPatientMG =
   case when Molecule = N'卡铂'   then 600
        when Molecule = N'顺铂'   then 120
        when Molecule = N'奈达铂' then 150
        else null
        end
where Molecule in (N'卡铂',N'顺铂',N'奈达铂')
GO 

alter table inSeaRainbowData add 
	cpa_id int,
	Tier varchar(5)
go
update inSeaRainbowData set cpa_id = b.id,tier = b.tier
from inSeaRainbowData a
inner join (select * from tblHospitalMaster where datasource='Sea') b  
	on a.Hospital = b.cpa_name

--update inSeaRainbowData set cpa_id = b.id,tier = b.tier
--from inSeaRainbowData a
--inner join BMSChinaOtherDB.dbo.tblAllHospital_2013 b  -- todo(每年一次)
--	on a.Hospital = b.cpa_OldName
--go
--update inSeaRainbowData set cpa_id = b.id,tier = b.tier
--from inSeaRainbowData a
--inner join BMSChinaOtherDB.dbo.tblAllHospital_2013 b  -- todo(每年一次)
--	on a.Hospital = b.cpa_Name
go
-- 删除没有列在出版目录中的医院数据
select N'SeaRainbow的记录条数',count(*) from inSeaRainbowData
select N'cpa_id为空的记录条数',count(*) from inSeaRainbowData where cpa_id is null
go
delete inSeaRainbowData where cpa_id is null
go
select N'删除cpa_id为空的数据后的记录条数',count(*) from inSeaRainbowData
go




/*****************************************特殊处理 开始******************************************/

-- From Jun'12, ignore the negative data
update inSeaRainbowData set Value = 0 where Value < 0
go
update inSeaRainbowData set Volume = 0 where Volume < 0
go
-- Product名为无
select N'Product名为无的记录条数',count(*) from inSeaRainbowData where Product= N'无'
update inSeaRainbowData  set Product = Molecule
where Product= N'无'
go


-- 同一个厂商的 药厂名字更新或者有误的（有的是CPA和SeaRainbow的叫法不同）：
update inSeaRainbowData set Manufacture=N'德国勃林格殷格翰国际公司Boehringer Ingelheim Pharma GmbH & Co.KG'
where Manufacture=N'德国勃林格殷格翰国际公司Boehringer Ingelheim Pharma GmbH & Co. KG'
GO
update inSeaRainbowData set Manufacture=N'海口奇力制药有限公司'
where Manufacture=N'海口奇力制药股份有限公司'
GO
update inSeaRainbowData set Manufacture=N'上海实业联合集团长城制药有限公司'
where Manufacture=N'上海实业联合集团长城药业有限公司'
GO
update inSeaRainbowData set Manufacture=N'上海信谊医药有限公司'
where Manufacture=N'上海信谊药厂有限公司'
GO
update inSeaRainbowData set Manufacture=N'珠海润都制药有限公司'
where Manufacture=N'珠海润都制药股份有限公司'
GO
--2013/7/18 10:03:06
update inSeaRainbowData set Manufacture=N'英国葛兰素史克集团'
where Manufacture like N'%史克%'

--2013/11/21
update inSeaRainbowData set Manufacture=N'瑞士诺华制药有限公司' where Manufacture in (N'北京诺华制药有限公司',N'瑞士诺华制药有限公司Novartis Pharma Stein AG')
--2015/1/21
update inSeaRainbowData set Manufacture=N'江苏苏州长征－欣凯制药有限公司' where Manufacture=N'苏州长征-欣凯制药有限公司'

update inSeaRainbowData set Manufacture=N'江苏正大天晴药业股份有限公司'where Manufacture=N'正大天晴药业集团股份有限公司'
update inSeaRainbowData set Manufacture=N'福建广生堂药业有限公司' where Manufacture=N'福建广生堂药业股份有限公司'

update inSeaRainbowData set Manufacture=N'浙江福韦药业有限公司'where Manufacture=N'浙江安科福韦药业有限公司'
update inSeaRainbowData set Manufacture=N'江苏苏州东瑞制药有限公司'where Manufacture=N'苏州东瑞制药有限公司'
update inSeaRainbowData set Manufacture=N'山东鲁抗辰欣药业有限公司' where Manufacture=N'辰欣药业股份有限公司'
update inSeaRainbowData set Manufacture=N'北京悦康药业有限公司' where Manufacture=N'悦康药业集团有限公司'
update inSeaRainbowData set Manufacture=N'海南中化联合制药工业股份有限公司' where Manufacture=N'海南中化联合制药工业有限公司'
update inSeaRainbowData set Manufacture=N'浙江万晟药业有限公司' where Manufacture=N'浙江万马药业有限公司'
/*****************************************特殊处理 结束******************************************/

GO
print '-----------------------------------
         inPharmData
------------------------------------------'
if object_id(N'inPharmData',N'U') is not null
	drop table inPharmData
go
declare @mth varchar(6), @mthdt varchar(8), @sql varchar(500)
select @mthdt = Value2, @mth = Value1 from tblDSDates where Item = 'CPA'
set @sql = '
select *,convert(int,null) as cpa_id,convert(float,null) as AvgPatientMG into inPharmData
from BMSChinaOtherDB.dbo.inPharmData_' + @mth + '_all' + '
where left(convert(varchar(8),convert(datetime,m+''/1/''+y,101),112),6) <=''' + @mth + '''
'
--print @sql
exec (@sql)

update inPharmData set AvgPatientMG =
   case when Molecule = N'卡铂'   then 600
        when Molecule = N'顺铂'   then 120
        when Molecule = N'奈达铂' then 150
        else null
        end

update inPharmData set cpa_id = b.id,tier=b.tier
from inPharmData a
inner join tblHospitalMaster b on a.Pharm_Hospital_Code = b.cpa_code

update inPharmData
set Molecule=N'氨酚伪麻美芬片II/氨麻苯美片'
where Molecule=N'氨酚伪麻美芬片Ⅱ/氨麻苯美片'

update inPharmData set Manufacture=N'江苏正大天晴药业股份有限公司'where Manufacture=N'正大天晴药业集团股份有限公司'
update inPharmData set Manufacture=N'江苏苏州东瑞制药有限公司'where Manufacture=N'苏州东瑞制药有限公司'
update inPharmData set Manufacture=N'瑞士诺华制药有限公司'where Manufacture=N'北京诺华制药有限公司'

update inPharmData set Manufacture=N'北京双鹭药业有限公司'where Manufacture=N'北京双鹭药业股份有限公司'
update inPharmData set Manufacture=N'北京悦康药业有限公司' where Manufacture=N'悦康药业集团有限公司'
update inPharmData set Manufacture=N'山东齐鲁制药有限公司' where Manufacture=N'齐鲁制药有限公司'
update inPharmData set Manufacture='Hospira Australia Pty Ltd （AU）' where Manufacture='Hospira Australia Pty Ltd'
update inPharmData set Manufacture=N'江苏奥赛康药业股份有限公司' where Manufacture=N'江苏奥赛康药业有限公司'
update inPharmData set Manufacture=N'山东鲁抗辰欣药业有限公司' where Manufacture=N'辰欣药业股份有限公司'
update inPharmData set Manufacture=N'美国礼来制药公司 （US）' where Manufacture='Lilly France'
update inPharmData set Manufacture=N'黑龙江哈尔滨三联药业有限公司' where Manufacture=N'哈尔滨三联药业有限公司'
update inPharmData set Manufacture=N'南京绿叶思科药业有限公司' where Manufacture=N'南京思科药业有限公司'
update inPharmData set Manufacture=N'广东深圳万乐药业有限公司' where Manufacture=N'深圳万乐药业有限公司'
update inPharmData set Manufacture=N'浙江万晟药业有限公司' where Manufacture=N'浙江万马药业有限公司'
update inPharmData set Manufacture=N'北京赛诺菲-安万特制药有限公司' where Manufacture='Aventis Pharma Dagenham'
update inPharmData set Manufacture=N'海口市制药厂有限公司' where Manufacture=N'海南海药股份有限公司海口市制药厂'
update inPharmData set Manufacture=N'美国百时美施贵宝制药公司 (US)' where Manufacture='Corden Pharma Latina S.P.A.'

select N'Pharm的记录条数',count(*) from inPharmData
select N'cpa_id为空的Pharm记录条数',count(*) from inPharmData where cpa_id is null
go
delete inPharmData where cpa_id is null
go
select N'删除cpa_id为空的数据后Pharm的记录条数',count(*) from inPharmData
go
--update null product to molecule
update inPharmData set product=molecule where product is null




print('------------------------------------------------------
                   tblHospitalMthList
-------------------------------------------------------------')
if object_id(N'tblHospitalMthList',N'U') is not null
	drop table tblHospitalMthList
go
create table tblHospitalMthList(
	idx	smallint not null primary key,
	Mth varchar(6),
	Qtr varchar(6),
	QtrIdx smallint
)
go
declare @mth datetime, @idx int
select @mth = convert(datetime,value2,112) from tblDSDates where item='CPA'
set @idx = 1
while @idx <= 36
begin
	insert into tblHospitalMthList(Idx, Mth) values(@idx, convert(varchar(6), @mth,112))
	set @mth = dateadd(m,-1,@mth)
	set @idx = @idx + 1
end
go

update tblHospitalMthList set Qtr = left(Mth,4) + 'Q' + cast(datepart(q, Mth+'01') as varchar)
go

declare @oldQ varchar(6),@newQ varchar(6), @QIdx int
declare c_c cursor for select Qtr from tblHospitalMthList order by idx
open c_c
fetch next from c_c into @newQ
set @QIdx = 1
set @oldQ = @newQ
while @@fetch_status = 0 
begin
	if @newQ <> @oldQ 
	begin
		set @QIdx = @QIdx + 1
		set @oldQ = @newQ
	end 
	update tblHospitalMthList set Qtridx = @QIdx where Qtr = @newQ
	fetch next from c_c into @newQ
end
close c_c
deallocate c_c
go
--log


exec dbo.sp_Log_Event 'Init','CIA_CPA','0_1_Import.sql','End',null,null


print 'over!'