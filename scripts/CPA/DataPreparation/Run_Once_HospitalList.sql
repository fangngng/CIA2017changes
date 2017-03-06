/* 
 手工处理脚本
*/
use  BMSChinaOtherDB
GO

-- 数据查看
select * from dbo.inSeaRainbow_HospitalList_2013
select * from dbo.inCPA_HospitalList_2013 

--设置Tier值
ALTER TABLE inCPA_HospitalList_2013 ADD Tier varchar(2)
update inCPA_HospitalList_2013 set 
	tier = case 
	when left(Reference,1)=N'一' then '1' 
	when left(Reference,1)=N'二' then '2' 
	when left(Reference,1)=N'三' then '3' 
	else 'NT' end
go

ALTER TABLE inSeaRainbow_HospitalList_2013 ADD Tier varchar(2)
update inSeaRainbow_HospitalList_2013 set 
	tier = case 
	when left([等级],1)=N'1' then '1' 
	when left([等级],1)=N'2' then '2' 
	when left([等级],1)=N'3' then '3' 
	else 'NT' end
go

ALTER TABLE inSeaRainbow_HospitalList_2013 ADD Original_Name nvarchar(255)
go
--update inSeaRainbow_HospitalList_2013 set Original_Name = cpa_Name
--go


-- SeaRainbow医院列表中标记为CPA的医院，但是在CPA医院列表中找不到的，
-- 进行手工匹配
--select * from incpa_hospitallist_2013 where  cpa_name like N'%解放军第%'
--go

update inSeaRainbow_HospitalList_2013 set cpa_name = N'东莞市塘厦人民医院' where Original_Name = N'东莞市塘厦医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'中国中医科学院望京医院' where Original_Name = N'中国中医研究院望京医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'中国中医科学院眼科医院' where Original_Name = N'中国中医研究院眼科医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'中国医学科学院肿瘤医院' where Original_Name = N'中国医学科学院肿瘤医院肿瘤研究所'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'民航总医院' where cpa_name = N'中国民用航空总医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'中山大学附属肿瘤医院' where Original_Name = N'中山大学肿瘤防治中心'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'中山医科大学黄埔医院（中山大学附属第一医院黄埔院区）' where Original_Name = N'中山大学附属第一医院（黄埔院区）'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'中山大学附属第二医院' where Original_Name = N'中山大学附属第二医院（中山医科大学孙逸仙纪念医院）'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'广州市第六人民医院（中山大学附属第六医院）' where Original_Name = N'中山大学附属第六人民医院（中山大学附属胃肠肛门医院）'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'广东中山火炬开发区医院' where Original_Name = N'中山市火炬开发区医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'佛山市中医院' where Original_Name = N'佛山市南海区中医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'首都医科大学附属北京世纪坛医院' where Original_Name = N'北京世纪坛医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'首都医科大附属北京地坛医院' where Original_Name = N'北京地坛医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'北京普仁医院' where Original_Name = N'北京市普仁医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'北京大学第四临床医院北京积水潭医院' where Original_Name = N'北京积水潭医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'北京大学肿瘤医院' where Original_Name = N'北京肿瘤医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'北京华信医院（清华大学第一附属医院）' where Original_Name = N'华信医院(清华大学第一附属医院)'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'山东省单县中心医院' where Original_Name = N'单县中心医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'南京第二医院' where Original_Name = N'南京市第二医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'广西南宁市第四人民医院' where Original_Name = N'南宁市第四人民医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'南方医科大学附属南方医院' where Original_Name = N'南方医科大学南方医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'珠江医院' where Original_Name = N'南方医科大学珠江医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'广州港湾医院' where Original_Name = N'广州医学院港湾医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'广州市中医院' where Original_Name = N'广州市中医医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'广州经济技术开发区医院' where Original_Name = N'广州开发区医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'广州新海医院' where Original_Name = N'广州新海医院（广州海员医院）'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'广州市海珠区第一人民医院' where Original_Name = N'海珠区第一人民医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'广州市海珠区第二人民医院' where Original_Name = N'海珠区第二人民医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'深圳市南山区人民医院' where Original_Name = N'深圳市南山区人民医院（深圳市第六人民医院）'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'深圳市孙逸仙心血管病医院' where Original_Name = N'深圳市孙逸仙心血管医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'深圳市宝安区人民医院' where Original_Name = N'深圳市宝安区人民医院（深圳市第八人民医院）'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'深圳市西乡人民医院' where Original_Name = N'深圳市宝安区西乡人民医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'深圳罗湖中医院' where Original_Name = N'深圳市罗湖区中医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'深圳市龙岗中心医院' where Original_Name = N'深圳市龙岗中心医院（深圳市第九人民医院）'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'山东滨州医学院附属医院' where Original_Name = N'滨州医学院附属医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'潮州市中心医院（原潮州市中心人民医院）' where Original_Name = N'潮州市中心医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'清华大学附属玉泉医院' where Original_Name = N'玉泉医院(清华大学第二附属医院)'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'解放军空军总医院' where Original_Name = N'空军总医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'解放军三〇六医院' where Original_Name = N'解放军第306医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'解放军第三〇九医院' where Original_Name = N'解放军第309医院'
go
--update inSeaRainbow_HospitalList_2013 set cpa_name = N'解放军第466医院' where Original_Name = N'解放军第466医院'
--go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'广州市越秀区第一人民医院' where Original_Name = N'越秀区第一人民医院'
go
--update inSeaRainbow_HospitalList_2013 set cpa_name = N'连云港市第一人民医院' where Original_Name = N'连云港市第一人民医院'
--go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'青岛市立医院' where Original_Name = N'青岛市市立医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'青岛第八医院' where Original_Name = N'青岛市第八人民医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'胶州市中心医院' where Original_Name = N'青岛市胶州中心医院'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'首都医科大学附属北京朝阳医院（西院）' where Original_Name = N'首都医科大学附属北京朝阳医院（京西院区）'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'北京大学首钢医院' where Original_Name = N'首钢总医院'
go


/*
select * from dbo.inSeaRainbow_HospitalList_2013 a where isincpa = 'cpa'
and not exists(select * from inCPA_HospitalList_2013 b where a.cpa_name = b.cpa_name)



*/

truncate table tblAllHospital_2013
go

insert into tblAllHospital_2013(Year, Source, cpa_Code, CPA_Name,  province, city, Tier)
select '2013' as [Year], 'CPA' as Source,CPA_Code,Cpa_Name,
	Province,City,Tier
from inCPA_HospitalList_2013

update tblAllHospital_2013 set cpa_OldName = cpa_Name
go

insert into tblAllHospital_2013(Year, Source, cpa_Code, CPA_Name,cpa_oldName,  province, city, Tier)
select '2013' as [Year], 'Sea' as Source, [组织机构代码] as cpa_code, cpa_Name, Original_Name, province,city,tier
from inSeaRainbow_HospitalList_2013 a
where not exists(select * from tblAllHospital_2013 b where a.cpa_Name = b.cpa_Name)
go

-- 统一省份名各城市名
-- 2094
update tblAllHospital_2013 set 
	Province = b.Province
from tblAllHospital_2013 a inner join 
(select distinct Province from tblAllHospital_2012) b on a.province like b.province + '%'
go
-- 1902
update tblAllHospital_2013 set 
	City = b.City,
	City_en=b.City_en
from tblAllHospital_2013 a inner join 
(select distinct city,city_en from tblAllHospital_2012) b on a.city like b.city + '%'
go

select distinct city from tblAllHospital_2013 where city_en is null and right(city,1) not in (N'县',N'市')

update tblAllHospital_2013 set city = N'保亭' where City=N'保亭县（省直管）'
update tblAllHospital_2013 set city = N'定安' where City=N'定安县（省直管）'
update tblAllHospital_2013 set city = N'琼海' where City=N'琼海市（省直管）'
update tblAllHospital_2013 set city = N'兴安' where City=N'兴安盟'
go

-- 省属意味着这些医院行政级别不属于任何一个城市的。
-- 但是对于BMS的销售来说，仍然要指定这个医院地理上是属于哪一个城市
select * from tblAllHospital_2013 where city=N'省属'

select distinct 'update tblAllHospital_2013 set city = N'''' where City=N''' + N'省属'+''' and cpa_Name = '''+cpa_Name+'''' from tblAllHospital_2013 where city=N'省属'

update tblAllHospital_2013 set city = N'广州',City_en='Guangzhou' where City=N'省属' and cpa_Name = N'华南理工大学医院'
update tblAllHospital_2013 set city = N'广州',City_en='Guangzhou' where City=N'省属' and cpa_Name = N'南方医科大学第三附属医院'
update tblAllHospital_2013 set city = N'广州',City_en='Guangzhou' where City=N'省属' and cpa_Name = N'广东省公安厅机关服务中心门诊部'
update tblAllHospital_2013 set city = N'广州',City_en='Guangzhou' where City=N'省属' and cpa_Name = N'广东省电力一局医院'
update tblAllHospital_2013 set city = N'广州',City_en='Guangzhou' where City=N'省属' and cpa_Name = N'广东省第二中医院'
update tblAllHospital_2013 set city = N'广州',City_en='Guangzhou' where City=N'省属' and cpa_Name = N'广东省荣誉军人康复医院'
update tblAllHospital_2013 set city = N'广州',City_en='Guangzhou' where City=N'省属' and cpa_Name = N'广东省计划生育专科医院'
update tblAllHospital_2013 set city = N'广州',City_en='Guangzhou' where City=N'省属' and cpa_Name = N'广州中医药大学附属骨伤科医院'
update tblAllHospital_2013 set city = N'广州',City_en='Guangzhou' where City=N'省属' and cpa_Name = N'广州市越秀区人民医院'
update tblAllHospital_2013 set city = N'广州',City_en='Guangzhou' where City=N'省属' and cpa_Name = N'暨南大学附属第一医院（广州华侨医院）'
go


select distinct city from tblAllHospital_2013 where city_en is null and right(city,1) = N'市'
go 
update tblAllHospital_2013 set City = left(City,len(city)-1) 
where city_en is null and right(city,1) = N'市'
go

select distinct city from tblAllHospital_2013 where city_en is null and right(city,1) = N'县'
go 
update tblAllHospital_2013 set city = N'临高' where City=N'临高县'
update tblAllHospital_2013 set city = N'昌江' where City=N'昌江黎族自治县'
update tblAllHospital_2013 set city = N'白沙' where City=N'白沙黎族自治县'
update tblAllHospital_2013 set city = N'隆林' where City=N'隆林各族自治县'
go

	
-- 使用中文转拼音函数来设置城市的英文名
update tblAllHospital_2013 set City_en =b.City_en
from tblAllHospital_2013 a inner join (
select distinct City,dbo.fnGetQuanPin(city) as City_en
from tblAllHospital_2013 where city_en is null ) b on a.city= b.city
where a.city_en is null
go
-- 额外处理两个转拼音不正确的城市的拼音名
update tblAllHospital_2013 set City_en = 'YiChun' where City = N'宜春'
update tblAllHospital_2013 set City_en = 'DuYun' where City = N'都匀'
go


-- 1324	吉林省	吉林市	吉林	吉林市医院	合入 吉林市人民医院（1330）


-- 寻找Sea Rainbow2013医院列表中的医院，和历史比较是否有发生名字改变的情况
-- 从下面的查找中发现，这些不在历史列表中医院，都属于2013新增的医院
select * from tblAllHospital_2013 a 
where a.source = 'sea' and not exists(select * from tblAllHospital_2012 b where a.cpa_name = b.cpa_Name)
	and not exists(select * from inSeaRainbow_HospitalList_2013 b where b.[2012年样本]=N'2012年样本' and b.cpa_Name = a.cpa_Name)

select * from tblAllHospital_2013 a 
where a.source = 'sea' and not exists(select * from tblAllHospital_2012 b where a.cpa_name = b.cpa_Name)
	and exists(select * from inSeaRainbow_HospitalList_2013 b where b.[2012年样本]=N'2013年新增' and b.cpa_Name = a.cpa_Name)

-- 2094
select count(*) from tblAllHospital_2013 a where source = 'sea'
-- 170
select count(*) from tblAllHospital_2012 a  where source = 'sea'

-- 更新医院的英文名字
update tblAllHospital_2013 set 
	cpa_Name_english = b.cpa_Name_english,
	cpa_Name_english_full = b.cpa_name_english_full
from tblAllHospital_2013 a
inner join (
	select distinct cpa_name,cpa_Name_english,cpa_name_english_full from tblAllHospital_2012
) b on a.cpa_Name= b.cpa_Name
where a.cpa_name_english is null
go
--对于cpa医院如果通过名字更新不了英文名字，表明它的中文名字有一些变化，
--这时通过cpa_code来更新，同时，设置cpa_oldname为上一期的中文名字
update tblAllHospital_2013 set 
	cpa_OldName = b.cpa_Name,
	Cpa_Name_english = b.cpa_Name_english,
	cpa_Name_english_full = b.cpa_name_english_full
-- select *
from tblAllHospital_2013 a inner join (
	select distinct cpa_code,cpa_name,cpa_Name_english,cpa_name_english_full from tblAllHospital_2012 where source = 'cpa'
)b on a.cpa_code = b.cpa_code
where a.cpa_name_english is null
go

--检查是否cap中更新不了名字的都是2013新增的医院
-- 结论：是
select * from tblAllHospital_2013 a 
where source='cpa' and cpa_Name_english is null
go
select * from tblAllHospital_2013 a 
where source='cpa' and cpa_Name_english is null
	and not exists(select * from inCPA_HospitalList_2013 b where isnew is null and b.cpa_code=b.cpa_code)
go
select * from tblAllHospital_2013 a 
where source='cpa' and cpa_Name_english is null
	and exists(select * from inCPA_HospitalList_2013 b where isnew is not null and b.cpa_code=b.cpa_code)
go

--检查是否sea中更新不了名字的都是2013新增的医院
select * from tblAllHospital_2013 a 
where source='SEA' and cpa_Name_english is null
go
select * from tblAllHospital_2013 a 
where source='SEA' and cpa_Name_english is null
	and not exists(select * from inSeaRainbow_HospitalList_2013 b where b.[2012年样本]=N'2012年样本' and b.cpa_Name=b.cpa_Name)
go
select * from tblAllHospital_2013 a 
where source='SEA' and cpa_Name_english is null
	and exists(select * from inSeaRainbow_HospitalList_2013 b where b.[2012年样本]=N'2013年新增' and b.cpa_Name=b.cpa_Name)
go

--更新医院名字
delete tblAllHospital_2013
-- select *
from tblAllHospital_2013 a
where exists(
	select * from (	select cpa_name,max(pk)pk from tblAllHospital_2013 group by cpa_Name having count(*) > 1) b
	where a.pk = b.pk
)
go 

update tblAllHospital_2013 set 
	cpa_Name_english = 'Huaxi Hosp. of Sichuan Univ.',
	cpa_Name_English_full = 'Huaxi Hospital of Sichuan University'
where cpa_Name = N'四川大学华西医院'
go
update tblAllHospital_2013 set 
	cpa_Name_english = 'Huaxi 2nd Hosp. of Sichuan Univ.',
	cpa_Name_English_full = 'Huaxi 2nd Hospital of Sichuan University'
where cpa_Name = N'四川大学华西第二医院'
go
update tblAllHospital_2013 set 
	cpa_Name=N'广州市皮防所'
where cpa_Name = N'广州市皮肤病防治所'
go

-- 新医院的英文名字

update tblAllHospital_2013 set cpa_Name_english = b.cpa_name_english
from tblAllHospital_2013 a
inner join tempHospName b on a.cpa_name = b.cpa_name
where a.cpa_name_english is null
go

update tblAllHospital_2013 set cpa_name_english_full = cpa_name_english
where cpa_name_english_full is null
go


-- 缩短医院的英文名字
/*
25
1.       Hospital – Hosp.
2.       Medical – Med.
3.       Medicine – Med.
4.       University – Univ.
5.       People – Ppl.
6.       Affiliated – Aff.
7.       Center – Ctr.
8.       District – Dist.
*/

update tblAllHospital_2013 set cpa_Name_English = replace(cpa_Name_English,'Hospital','Hosp.')
where len(cpa_Name_English) > 25
update tblAllHospital_2013 set cpa_Name_English = replace(cpa_Name_English,'Medical','Med.')
where len(cpa_Name_English) > 25
update tblAllHospital_2013 set cpa_Name_English = replace(cpa_Name_English,'Medicine','Med.')
where len(cpa_Name_English) > 25
update tblAllHospital_2013 set cpa_Name_English = replace(cpa_Name_English,'University','Univ.')
where len(cpa_Name_English) > 25
update tblAllHospital_2013 set cpa_Name_English = replace(cpa_Name_English,'People','Ppl.')
where len(cpa_Name_English) > 25
update tblAllHospital_2013 set cpa_Name_English = replace(cpa_Name_English,'Affiliated','Aff.')
where len(cpa_Name_English) > 25
update tblAllHospital_2013 set cpa_Name_English = replace(cpa_Name_English,'Center','Ctr.')
where len(cpa_Name_English) > 25
update tblAllHospital_2013 set cpa_Name_English = replace(cpa_Name_English,'District','Dist.')
where len(cpa_Name_English) > 25
go

update tblAllHospital_2012 set cpa_Name_English = replace(cpa_Name_English,'shanghai','SH') where cpa_Name_English like '%shanghai%'
update tblAllHospital_2012 set cpa_Name_English = replace(cpa_Name_English,'beijing','BJ')where cpa_Name_English like '%beijing%'
update tblAllHospital_2012 set cpa_Name_English = replace(cpa_Name_English,'cHONGQING','CQ')where cpa_Name_English like '%cHONGQING%'
update tblAllHospital_2012 set cpa_Name_English = replace(cpa_Name_English,'TIANJIN','TJ')where cpa_Name_English like '%TIANJIN%'
go


--设置每个医院一个唯一的ID
update tblAllHospital_2013 set id= b.id 
from tblAllHospital_2013 a 
inner join (
	select cpa_Name,rank() over(order by cpa_name) id from(select distinct cpa_Name from tblAllHospital_2013) a
) b on a.cpa_name = b.cpa_Name
go
-- 查找是否有重复的医院
-- 北京胸科医院(原:北京胸部肿瘤结核病医院)
update tblAllHospital_2013 set cpa_Name = N'北京市胸科医院',id = 354 where cpa_Name = N'北京胸部肿瘤结核病医院' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name = N'北京市丰台医院',id = 295 where cpa_Name = N'北京市丰台区医院' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name = N'广州中医药大学附属广东省第二中医院',id = 860 where cpa_Name = N'广东省第二中医院' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name = N'桂林市中医医院',id = 1150 where cpa_Name = N'桂林市中医院' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name = N'桂林市中医医院',id = 1150 where cpa_Name = N'桂林市中医院' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name_english = 'Laibin Heshan People''s Hospital'
where cpa_Name = N'合山市人民医院'
go
update tblAllHospital_2013 set cpa_Name_english = 'Jiangmeng Heshan People''s Hospital'
where cpa_Name = N'鹤山市人民医院'
go
update tblAllHospital_2013 set cpa_Name_english = 'People''s Hospital of Jilin City' where cpa_Name = N'吉林市人民医院' 
go
update tblAllHospital_2013 set cpa_Name_english = 'People''s Hospital of Jilin Province' where cpa_Name = N'吉林省人民医院'
go
update tblAllHospital_2013 set cpa_Name = N'临沂市人民医院',id = 163 where cpa_Name = N'山东省临沂市人民医院' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name = N'佛山市南海区人民医院',id = 207 where cpa_Name = N'南海区人民医院' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name = N'解放军307医院',id = 1765 where cpa_Name = N'解放军第307医院' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name = N'深圳市第三人民医院',id = 1451,cpa_Name_english='3rd People''s Hospital of Shengzhen' 
where cpa_Name_english = N'Shenzhen Donghu Hospital'
go
update tblAllHospital_2013 set cpa_Name = N'深圳盐田区盐港医院',id = 1471 where cpa_Name = N'深圳市盐田区盐港医院' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name = N'无锡市中医医院',id = 1084 where cpa_Name = N'无锡市中医院' and source = 'sea'
go

update tblAllHospital_2013 set cpa_Name_english = 'Maoming MXinyi People''s Hospital'
where cpa_Name = N'信宜市人民医院'
go
update tblAllHospital_2013 set cpa_Name_english = 'Xuzhou Xinyi People''s Hospital'
where cpa_Name = N'新沂市人民医院'
go

update tblAllHospital_2013 set cpa_Name = N'徐州市中心医院',id = 973 where cpa_Name = N'徐州市中心医院（四院）' and source = 'sea'
go

select cpa_Name,id, cpa_oldName, source from tblAllHospital_2013 a where cpa_Name_english in (
select cpa_Name_english from tblAllHospital_2013 group by cpa_name_english having count(*) > 1)
order by cpa_Name_english
go
