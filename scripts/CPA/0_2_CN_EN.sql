--/*

--预处理脚本，需要手工维护 ： 
--修改时间: 2013/4/12 16:38:17
--英文预处理脚本: 





--1. 历史的：

--insert into tblMoleConfig(MoleculeCN,MoleculeEN,AddMonth,Description)
--values(N'阿哌沙班','APIXABAN','201309','Eliquis的一个Molecule')

-- 20161103 Eddy
-- update tblMoleConfig
-- set MoleculeEn = 'LOW MOLECULAR WEIGHT HEPARIN CALCIUM' 
-- where MoleculeCN = N'低分子肝素钙'

-- update tblMoleConfig
-- set MoleculeEn = 'HEPARIN' 
-- where MoleculeCN = N'肝素钠'

-- insert into dbo.tblMoleConfig ( MoleculeCN, MoleculeEN, AddMonth, Description )
-- values	( N'低分子肝素', -- MoleculeCN - nvarchar(500)
		  -- 'LOW MOLECULAR WEIGHT HEPARIN CALCIUM', -- MoleculeEN - varchar(500)
		  -- '201611', -- AddMonth - varchar(6)
		  -- N'国药数据中出现的'  -- Description - nvarchar(1000)
		  -- )

-- insert into dbo.tblMoleConfig ( MoleculeCN, MoleculeEN, AddMonth, Description )
-- values	( N'达肝素钠', -- MoleculeCN - nvarchar(500)
		  -- 'Dalteparin Sodium', -- MoleculeEN - varchar(500)
		  -- '201611', -- AddMonth - varchar(6)
		  -- N'Inline Market have Dalteparin Sodium'  -- Description - nvarchar(1000)
		  -- )


--tblMoleConfig  --include all Molecule CN-EN for in-line Market   --记录数 123
--tblProdConfig  --Product CN-EN for in-line Market                --记录数 609

-- 20161103 Eddy
-- update dbo.tblProdConfig
-- set producten = 'LOW MOLECULAR WEIGHT HEPARIN CALCIUM',
	-- addDate = getdate()
-- where  productcn = N'低分子肝素钙'

-- update dbo.tblProdConfig
-- set producten = 'LOW MOLECULAR WEIGHT HEPARIN SODIUM',
	-- addDate = getdate()
-- where  productcn = N'低分子肝素钠'

-- update dbo.tblProdConfig
-- set producten = 'JI PAI LIN',
	-- addDate = getdate()
-- where  productcn = N'吉派林'

--2. 根据客户给的IMS翻译数据经过处理后产生的 用来给Hosp用的 原始翻译:
--inManuDef_IMS
--inProdDef_IMS

--3. 网上，手工翻译的：
--dbo.inManuDef_Gool
--dbo.inProdDef_Gool

--*/

--use BMSChinaMRBI--192.168.1.4
--go







--Print('----------------------------
--1.1.1  Get new molecule
------------------------------------')
--if object_id(N'TempNewMolecules',N'U') is not null
--	drop table TempNewMolecules;
--GO
--select NewMole, b.Mole_Code, b.Mole_EN
--into TempNewMolecules
--from (
--     select distinct Molecule as NewMole from inCPAData t1 
--     where not exists (
--                       select * from tblPackageXRefHosp t2
--                       where t1.Molecule=t2.Molecule_CN_Src 
--                       )
--     ) a 
--left join 
--     tblDefMolecule_CN_EN b
--on a.NewMole = b.Mole_CN
--GO

--insert into TempNewMolecules
--select NewMole, b.Mole_Code, b.Mole_EN
--from (
--     select distinct Molecule as NewMole from inSeaRainbowData t1 
--     where not exists (
--                       select * from tblPackageXRefHosp t2
--                       where t1.Molecule=t2.Molecule_CN_Src 
--                       )
--     ) a 
--left join 
--     tblDefMolecule_CN_EN b
--on a.NewMole = b.Mole_CN
--GO

---- 对没有指定Mole_Code的产品暂时舍弃
--delete  -- select *
--from TempNewMolecules where Mole_Code is null
--GO







--print(N'
---------------------------------------------------------------------------      
--         1. inManuDef_IMS    厂商翻译
---------------------------------------------------------------------------
--')

----查询新增的翻译，插入到临时表temp
--IF OBJECT_ID(N'temp',N'U') IS NOT NULL
--	DROP TABLE temp
--GO
--select * into temp
--from dbo.Manu$ where namec not in (
--select distinct namec from inManuDef_IMS
--)
--GO

----同一中文 对应 多个英文 （不能容许，只能取一个。）
--select * from temp where namec in (
--select namec from temp
--group by namec having count(name)>1
--)


----2013/4/20 23:56:19
--select  * from inManuDef_Gool 

----inManuDef_Gool 翻译数据的问题数据：
--select distinct * from inManuDef_Gool where namec in (
--select namec from inManuDef_Gool group by namec having count([name]) >1
--)


----2013/6/19 21:27:19
--insert into inManuDef_Gool 
--select 'Slovenia lai ke medicines and chemical products co., LTD',N'斯洛文尼亚莱柯药品及化学制品有限公司' union all
--select 'Jiangsu wuzhong pharmaceutical group co., LTD. Suzhou pharmaceutical factory',N'江苏吴中医药集团有限公司苏州制药厂' 
--GO
----2013/7/17 16:41:14
--insert into inManuDef_Gool 
--select 'Guangdong nine Ming pharmaceutical co., LTD',N'广东九明制药有限公司'



select * from tblDefManufacture_CN_EN where manu_cn like N'%生物技术有限公司%'

/**********************插入下列四个新的厂商: Xiaoyu.chen 2013-08-19(H1&Q2数据)*************************

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'德国Bayer Schering Pharma AG','Germany''s Bayer Schering Pharma AG')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'江苏晨牌药业集团股份有限公司','Jiangsu morning brand pharmaceutical group co., LTD')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'济川药业集团股份有限公司','Sichuan pharmaceutical group co., LTD')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'赛诺菲(北京)制药有限公司','Sanofi (Beijing) pharmaceutical co., LTD')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'正大天晴药业集团股份有限公司','CTTQ Pharmaceutical Group Co., Ltd.')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'江苏晨牌邦德药业有限公司','JiangSu ChenPai BOND Pharmaceutical Co., Ltd.')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'菏泽睿鹰制药有限公司','Heze Ruiying Pharmaceutical Co., Ltd.')

--xiao.chen 20140321
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'Patheon Puerto Rico Inc. (US)','Patheon Puerto Rico Inc. (US)')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'四川海思科制药有限公司','Haisco Pharmaceutical Co., Ltd.')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'济南东方制药有限公司','Jinan Dongfang Pharmaceutical Co., Ltd.')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'远大医药(中国)有限公司','GrandPharma(China) Co., Ltd.')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'意大利Merck Sharp & Dohme Italia SPA(杭州默沙东制药有限公司分装)','Italian Merck Sharp & Dohme Italia SPA(Hangzhou MSD pharmaceutical co., LTD. Partial shipments)')
---xiaoyu.chen 20140321
insert into inManuDef_Gool(namec,name)
select a.更新后生产企业,b.name
from (
	select distinct 原生产企业,更新后生产企业 
	from  dbo.inManu_Change_201501
) a join inManuDef_Gool b on a.原生产企业=b.namec


insert into inManuDef_Gool(NAMEC,NAME) 
values(N'CIPLA LTD,INDIA(ID)','CIPLA LTD, INDIA (ID)')


insert into inManuDef_Gool (name,namec)
values ('Beijing SciClone Pharmaceutical Co., Ltd.',N'北京赛生药业有限公司')

insert into inManuDef_Gool (name,namec)
values ('Novo Nordisk Novo Nordisk A / S (Novo Nordisk China packing)',N'丹麦诺和诺德公司Novo Nordisk  A/S(诺和诺德中国分装)')


--xiaoyu.chen 20140616
insert into inManuDef_Gool (name,namec)
values ('JianLang Medicine Pharmaceutical Co., Ltd.',N'湖南健朗药业有限公司')

insert into inManuDef_Gool (name,namec)
values ('JumpCan Pharmaceutical Group Co., Ltd.',N'济川药业集团有限公司')

insert into inManuDef_Gool (name,namec)
values ('JiLin HengZhi Pharmaceutical Group Co., Ltd.',N'吉林金恒制药股份有限公司')

--xiaoyu.chen 20140818
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'PHARMACARE LIMITED trading as ASPEN PHARMACARE （SO）','PHARMACARE LIMITED trading as ASPEN PHARMACARE (SO)')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'山东烟台西苑制药厂','Shandong Yantai Xiyuan Pharmaceutical Factory')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'美国Bristol-Myers Squibb Manufacturing Company(上海施贵宝分装)','United States Bristol-Myers Squibb Manufacturing Company (Shanghai Shi Squibb packaging)')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'RECORDATI(IT)','RECORDATI(IT)')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'北大医药股份有限公司','PKU HealthCare Corp.,Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'天方药业有限公司','Tianfang Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'山东罗欣药业集团股份有限公司','Shandong Luoxin Pharmaceutical Group Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'德国Bayer Pharma AG','Bayer Schering Pharma AG Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'阜新芝田药业有限公司','Fuxin Zhitian Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'远大医药黄石飞云制药有限公司','GrandPharma Huangshi Feiyun Pharmaceutical Co., Ltd.')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'德国Bayer Schering Pharma AG(拜耳医药保健有限公司分装)','Germany Bayer Schering Pharma AG(Bayer Healthcare Co.Ltd packaging)')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'德国勃林格殷格翰公司Boehringer Ingelheim Pharma GmbH & Co. KG(上海勃林格殷格翰药业分装)','Germany Boehringer Ingelheim Pharma GmbH & Co. KG(Shanghai Boehringer Ingelheim Pharma GmbH Pharmaceutical packaging)')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'杭州华东医药集团有限公司','East China Pharmaceutical Group Limited Co., Ltd.')


-----------Add By Xiaoyu 2015/02/15
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'波多黎各Patheon Puerto Rico Inc.(Caguas)','Patheon Puerto Rico Inc.(Caguas)')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'赛诺菲(杭州)制药有限公司','Sanofi (Hangzhou) pharmaceutical co., LTD')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'海南良方医药有限公司','Hainan Liangfang Pharmaceutical Co., LTD.')


Abraxis BioScience, LLC （US）
上海信谊药厂有限公司
南非PHARMACARE LIMITED trading as ASPEN PHARMACARE
山东明仁福瑞达制药股份有限公司
幸福医药有限公司 （HK）
拜耳医药保健有限公司启东分公司
沈阳澳华制药股份有限公司
浙江万晟药业有限公司

select * from inManuDef_Gool where namec like N'%拜耳%'
--2015/03/24 add xiaoyu
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'Abraxis BioScience, LLC （US）','Abraxis BioScience, LLC （US）')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'上海信谊药厂有限公司','ShangHai XinYi Factory Pharmaceutical Co., Ltd.')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'上海信谊医药有限公司','ShangHai XinYi Pharmaceutical Co., Ltd.')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'南非PHARMACARE LIMITED trading as ASPEN PHARMACARE','South Africa PHARMACARE LIMITED trading as ASPEN PHARMACARE')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'山东明仁福瑞达制药股份有限公司','Shandong MingRen FuRuiDa Pharmaceutical Co., Ltd.')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'幸福医药有限公司 （HK）','XingFu Pharmaceutical Co., Ltd. (HK)')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'拜耳医药保健有限公司启东分公司','Bayer HealthCare, Sheng Branch')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'沈阳澳华制药股份有限公司','ShenYang Aohua Pharmaceutical Co., Ltd.')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'浙江万晟药业有限公司','Zhejiang WanSheng Pharmaceutical Co., Ltd.')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'山西仟源制药股份有限公司','Shanxi Qianyuan Pharmaceutical Co., Ltd.')
--山西仟源制药股份有限公司

--xiaoyu.chen 2015-05-14
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'湖北华世通潜龙药业有限公司','Hubei WATERSTONE Qianlong Pharmaceutical Co., Ltd.')


insert into inManuDef_Gool (namec,name)
select Manu_CN,Manu_En from inPharmManu_Transplant_201503


--xiaoyu.chen 2015-06-18
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'吉林恒金药业股份有限公司','Jilin HengJin Pharmaceutical Group Co., Ltd.')

--xiaoyu.chen 2015-07-17
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'美国礼来制药公司 （US）','Eli Lilly and Company(US)')

select * from inManuDef_Gool where namec like N'%恒金%'
RECORDATI(IT)

--xiaoyu.chen 2015-08-18

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'Cipla Ltd.','Cipla Ltd.')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'广西百琪药业有限公司','Guangxi BaiQi Pharmaceutical Co., Ltd.')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'国药集团汕头金石制药有限公司','Sinopharm Shantou Jinshi Pharmaceutical Co., Ltd.')



山西华元医药生物技术有限公司
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'山西华元医药生物技术有限公司','Shanxi Huayuan Biotechnology Co., Ltd.')


Cipla Ltd.
国药集团汕头金石制药有限公司
广西百琪药业有限公司


--Alince.wang 2015-09-16


insert into inManuDef_Gool(NAMEC,NAME) 
values(N'北京太洋药业股份有限公司','Beijing Taiyang Pharmaceutical Co., Ltd.')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'宜昌东阳光长江药业股份有限公司','Yichangdong Yangguang Changjiang Pharmaceutical Co., Ltd.')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'江苏德源药业股份有限公司','Jiangsu Deyuan Pharmaceutical Co., Ltd.')

北京太洋药业股份有限公司
宜昌东阳光长江药业股份有限公司
江苏德源药业股份有限公司

--Alince.wang 2015-10-19
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'上海创诺制药有限公司','Shanghai Acebright Pharmaceuticals Co., Ltd.')

上海创诺制药有限公司

--Alince.wang 2015-11-23
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'山东力诺制药有限公司','ShanDong Linuo Pharmaceuticals Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'新乡中杰药业有限公司','ZhongJie Pharmaceuticals Co., Ltd.')
山东力诺制药有限公司
新乡中杰药业有限公司

--Alince.wang 2015-11-23
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'北京京丰制药集团有限公司','Beijing Jingfeng Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'成都迪康药业有限公司','Chengdu Dikang Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'海南先通药业有限公司','HaiNan Xiantong Pharmaceutical Co., Ltd.')
北京京丰制药集团有限公司
成都迪康药业有限公司
海南先通药业有限公司

--Alince 20160322
Hospira Australia Pty Ltd （AU）
Salutas Pharma GmbH （GE）
Vetter Pharma-Fertigung GmbH （GE）
南京健友生物化学制药有限公司
大同市利群药业有限责任公司
山西兰花七佛山制药有限公司
常州千红生化制药有限公司
杭州赛诺菲安万特民生制药有限公司
河南帅克制药有限公司
海南通用同盟药业有限公司
海正辉瑞制药有限公司
烟台东诚北方制药有限公司
石家庄康力药业有限公司
神威药业集团有限公司
西安博华制药有限责任公司
郑州市协和制药厂
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'Hospira Australia Pty Ltd （AU）','Hospira Australia Pty Ltd （AU）')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'Salutas Pharma GmbH （GE）','Salutas Pharma GmbH （GE）')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'Vetter Pharma-Fertigung GmbH （GE）','Vetter Pharma-Fertigung GmbH （GE）')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'南京健友生物化学制药有限公司','Nanjing King-friend Biochemical Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'大同市利群药业有限责任公司','Datong Liqun Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'山西兰花七佛山制药有限公司','Shanxi Lanhua Qifoshan Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'常州千红生化制药有限公司','Changzhou Qianhong Bio-pharma Co., Ltd')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'杭州赛诺菲安万特民生制药有限公司','Sanofi-aventis hangzhou minsheng Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'河南帅克制药有限公司','Henan Shuaike Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'海南通用同盟药业有限公司','Hainan Unipul Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'海正辉瑞制药有限公司','Haizheng Pfizer  Pharmaceutical Co., Ltd')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'烟台东诚北方制药有限公司','Yantai Dongcheng Pharmaceutical Group Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'石家庄康力药业有限公司','Shiajiazhuang Kangli Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'神威药业集团有限公司','Shenwie Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'西安博华制药有限责任公司','Xian Bodyguard Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'郑州市协和制药厂','Zhengzhou Xiehe Pharmaceutical factory')

--20160422
--Alfa Wassermann S.P.A.
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'Alfa Wassermann S.P.A.','Alfa Wassermann S.P.A.')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'山东信谊制药有限公司','Shandong XinYi Pharmaceutical Co., Ltd')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'广东台城制药有限公司','Guangdong TaiCheng Pharmaceutical Co., Ltd')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'株洲市金泰制药有限公司','Zhuzhou JinTai Pharmaceutical Co., Ltd')

--20160520
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'珠海润都制药股份有限公司','Rundu Pharmaceutical Co., Ltd')

insert into inManuDef_Gool(NAMEC,NAME) 
values('Bayer AG','Bayer AG, Ltd')

--20160616
上海信谊延安药业有限公司
上药东英(江苏)药业有限公司
依比威药品有限公司
南非Aspen Port Elizabeth (Pty) Ltd
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'上海信谊延安药业有限公司','Shanghai Xinyi Yanan Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'上药东英(江苏)药业有限公司',' Dong Ying (Jiangsu) Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'依比威药品有限公司','Ebewe Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'南非Aspen Port Elizabeth (Pty) Ltd','South Africa Aspen Port Elizabeth (Pty) Ltd')
201605 Alince
Salutas Pharma GmbH
山西国润制药有限公司
盐城制药有限公司
苏州爱美津制药有限公司
insert into inManuDef_Gool(NAMEC,NAME) 
values('Salutas Pharma GmbH','Salutas Pharma GmbH')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'山西国润制药有限公司',' ShanXi GuoRun Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'盐城制药有限公司','Yancheng Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'苏州爱美津制药有限公司','SuZhou Amerigen Pharmaceutical Co., Ltd')
--20160819
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'成都苑东生物制药股份有限公司','Easton BIO Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'日晖药业有限公司','Ri Hui Pharmaceutical Co., Ltd')
--20160918
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'珠海同源药业有限公司','Zhuhai Tongyuan Pharmaceutical Co., Ltd')
--20161018
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'广东三才石岐制药有限公司','Guangdong Succhi Shiqi Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'湖北欧力制药有限公司','Hubei Oulyt Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'印度Cipla Ltd.','Cipla Ltd.')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'英国·葛兰素史克','Glaxo Operations (UK)')

insert into inManuDef_Gool(NAMEC,NAME) 
values(N'Glaxo Operations (UK)','Glaxo Operations (UK)')

-- 20170216
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'上海上药第一生化药业有限公司', 'Shanghai No.1 Biochemical& Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'华润双鹤利民药业(济南)有限公司', 'Jinan Limin Phamaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'四川升和药业股份有限公司', 'Sichuan Sunnyhope Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'江苏万高药业股份有限公司', 'Jiangsu Vanguard Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'百正药业股份有限公司', 'Baizheng Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'石家庄市康达制药厂', 'Shijiazhuang Kangda Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'陕西必康制药集团控股有限公司', 'Shanxi Bicon Pharmaceutical Group Holding Co., Ltd.')

-- 20170330
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'瑞士巴塞尔豪夫迈.罗氏有限公司F. Hoffmann-La Roche Ltd.(上海罗氏制药分装)', 'F. Hoffmann-La Roche Ltd （SW）')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'F. Hoffmann-La Roche Ltd （SW）', 'F. Hoffmann-La Roche Ltd （SW）')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'ROCHE SpA （IT）', 'ROCHE S.p.A')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'云南医药工业股份有限公司昆明振华制药厂', 'Yunnan Pharmaceutical Industry Co., Ltd. Kunming Zhenhua Pharmaceutical Factory')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'兰州大得利生物化学制药（厂）有限公司', 'Lanzhou Dadeli Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'厦门特宝生物工程股份有限公司', 'Xiamen Amoytop Biotech Engineering Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'国药控股星鲨制药(厦门)有限公司', 'Sinopharm Xingsha Pharmaceutical(Xiamen) Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'山东仁和制药有限公司', 'Shandong Renhe Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'山西晋新双鹤药业有限责任公司', 'Shanxi Jinxin Shuanghe Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'山西银湖制药有限责任公司', 'Shanxi Yinhu Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'广东三才石岐制药股份有限公司', 'Guangdong Succhi Shiqi Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'广西圣保堂健康产业股份有限公司', 'Guangxi Sanpotel Health Industry Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'开封制药 （集团）有限公司', 'Kaifeng Pharmaceutical(Group) Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'德国诺华Novartis　Pharma　Produktions　GmbH', 'Novartis Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'必康制药江苏有限公司', 'Jiangsu Bicon Pharmaceutical Listed Company')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'江苏吴中实业股份有限公司苏州第六制药厂', 'Jiangsu Wuzhong Industrial Co., Ltd. Suzhou sixth pharmaceutical factory')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'江苏天际药业有限公司', 'Jiangsu Tianji Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'江苏悦兴药业有限公司', 'Jiangsu Yuexing Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'江苏普华克胜药业有限公司', 'Jiangsu Puhua kesheng Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'江苏远恒药业有限公司', 'Jiangsu Farever Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'江西上饶康达制药有限公司', 'Jiangxi Shangrao Kangda Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'江西汇仁药业有限公司', 'Jiangxi Huiren Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'沈阳绿洲制药有限责任公司', 'Shenyang Lvzhou Pharmaceutical Co., Ltd.')
insert into inManuDef_Gool(NAMEC,NAME) 
values(N'河南龙源药业股份有限公司', 'Henan Longyuan Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) values(N'泗水希尔康制药有限公司', 'Sishui Xierkang Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) values(N'浙江诚意药业股份有限公司', 'Zhejiang Chengyi Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) values(N'湖北清大康迪药业有限公司', 'Hubei Qingda Kangdi Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) values(N'湖南金健药业有限责任公司', 'Hunan Jinjian Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) values(N'爱尔兰先灵葆雅公司(Schering-Plough (Brinny) Co.)', 'Schering-Plough (Brinny) Co.')
insert into inManuDef_Gool(NAMEC,NAME) values(N'瑞士巴塞尔豪夫迈.罗氏有限公司F. Hoffmann-La Roche Ltd.(上海罗氏制药分装)', 'F. Hoffmann-La Roche Ltd （SW）')
insert into inManuDef_Gool(NAMEC,NAME) values(N'甘肃大得利制药有限公司', 'Gansu Dadeli Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) values(N'芜湖康奇制药有限公司', 'Wuhu Kangqi Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) values(N'裕松源药业有限公司', 'Yusongyuan Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) values(N'遂成药业股份有限公司', 'Suicheng Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) values(N'郑州卓峰制药厂', 'Zhengzhou CheukFeng Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) values(N'郑州卓峰制药有限公司', 'Zhengzhou CheukFeng Pharmaceutical Co., Ltd')
insert into inManuDef_Gool(NAMEC,NAME) values(N'SP(brinny) Company', 'SP(brinny) Company')

******************************************************************************************************/



--print(N'
---------------------------------------------------------------------------    
--           2. inProdDef   Product翻译
---------------------------------------------------------------------------
--')

--select * into inProdDef from dbo.PRD$
--GO

--drop table test_inProdDef
--GO
--select * into test_inProdDef from inProdDef where 1=0
--GO
--insert into test_inProdDef
--select max(PRODCODE),max(LABCODE),NAMEC,max(ENAME),max(LABNAME) 
--from inProdDef group by NAMEC
--GO
--drop table inProdDef
--EXEC sp_rename 'test_inProdDef', 'inProdDef'
--GO






----对客户 没有给到的product翻译，手工为新产品添加 Prod_EN：
--insert into inProdDef_Gool(NAMEC, ENAME) values(N'二甲双胍格列吡嗪','METFORMIN&GLIPIZIDE')
--insert into inProdDef_Gool(NAMEC, ENAME) values(N'二甲双胍格列本脲(Ⅰ)','METFORMIN&GLIBENCL(1)')
--insert into inProdDef_Gool(NAMEC, ENAME) values(N'格列齐特(Ⅱ)','GLICLAZIDE(2)')
--GO
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'达尔得','Gliclazide Tablets')
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'唐格','Metformin Hydrochloride Sustained-release Tablets')
--GO

-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'可宾','May Bin') Add by Xiaoyu.Chen on 20130918
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'伊马替尼','Imatinib')
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'宁泰','Ningtai')
--2013/12/17
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'卡伏平','KaFuping')

--2014/02/18
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'达沙替尼','Dasatinib') 
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'同丁','TongDing')
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'卡培他滨','Capecitabine')
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'艾滨','Ai Bin')
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'天丁','Tian Ding')
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'山诺宁','Shan Nuo Ning')
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'首辅','ShouFu')
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'息洛新','Xi LuoXin')

--xiaoyu.chen 20140616
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'比索洛尔','Bisoprolo')

--依尼舒
--锐列安
--倍怡
--天伦
--xiaoyu.chen 2015/03/24
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'依尼舒','Yi Ni Shu')
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'锐列安','Rui Lie An')
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'倍怡','Bei Yi')
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'天伦','Tian Lun')
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'立古欣','Li Gu Xin')
--print 'over!'
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'康铭诺','Kang Ming Nuo')
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'灭糖尿','Mie Tang Niao')
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'罗茜','Luo Xi')

-- xiaoyu.chen 2015/07/16
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'多维元素','Multiple vitamin')

--xiaoyu.chen 2015-08-18
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'蒙得康','meng de kang')
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'将唐君','Jiang Tang Jun')
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'山诺宁','Shan Nuo Ning')
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'普普罗新希罗新希','Pu Pu Luo Xin Xi Luo Xin Xi')
----Alince.wang 2015/11/23
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'友森','You Sen')
--
----Alince.wang 2016/03/22
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'山益新','SHAN YI XIN')

----Alince.wang 2016/09/18
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'替诺福韦二吡呋酯','TENOFOVIR DISOPROXIL')

-- Eddy 2016/11/03
--insert into inProdDef_Gool(NAMEC,ENAME) values(N'速避凝','FRAXIPARINE')

--Eddy 2016/12/16
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'二叶诺','ER YE NUO')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'健甘灵','JIAN GAN LING')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'木畅','MU CHANG')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'赛倍畅','SAI BEI CHANG')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'万生力克','WANG SHENG LI KE')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'卓仑','ZHUO LUN')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'帅信','SHUAI XIN')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'波啡克','BO FEI KE')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'甘倍轻','GAN BEI QING')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'益非','YI FEI')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'责吉','ZE JI')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'逸泰','YI TAI')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'普洛静','PU LUO JING')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'苏和','SU HE')

--Eddy 2017/01/17
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'易甘平','YI GAN PING')

--Eddy 2017/03/30
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'吉非替尼','Gefitinib')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'诺利宁','Norlyin')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'贝双定','Beishuangding')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'格尼可','Gurney')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'派格宾','Pigeon')
-- insert into inProdDef_Gool(NAMEC,ENAME) values(N'昕维','Xinwei')














