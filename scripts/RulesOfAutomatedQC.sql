----Sample of Compare tables
-- exec [dbo].[sp_qc_CompareTables] 'CIA','KP_SIT','KP_UAT'
--	-- select * from [dbo].[NJTableComparison_v1]

-- --Smaple of Compare Columns 
-- exec  [dbo].[sp_qc_CompareColumns]  'CIA','KP_SIT','KP_UAT'
--	--select * from [dbo].[NJCompareColumns]

-- exec  [dbo].[sp_qc_CompareIndexes] 'CIA','KP_SIT','KP_UAT'
	--select * from [dbo].[CooperIndexComparison]
	--select *from CooperHospitalCompareIndex
 --Sample of compare data according to specified rule
truncate table tblQC_CheckResults
truncate table tblQC_CheckRule
	--select * from tblQC_CheckResults
insert into tblQC_CheckRule(ProjectID,RuleID,SrcDB,SrcTable,SrcColumn,SrcExpression,DestDB,DestTable,DestColumn,DestExpression,[Rule],Flag)
values('CIA',1,'BMSChinaCIA_IMS','Dim_Fact_Sales','amount_ic',' city_id=16 
	and convert (varchar(10),year)+right(''0''+convert(varchar(5),month),3) 
	= (select max(convert (varchar(10),year)+right(''0''+convert(varchar(5),month),3) ) from Dim_Fact_Sales)'
	,'BMSChinaCIA_IMS','MTHCHPA_PKAU','mth00lc','','sum',1)

insert into tblQC_CheckRule(ProjectID,RuleID,SrcDB,SrcTable,SrcColumn,SrcExpression,DestDB,DestTable,DestColumn,DestExpression,[Rule],Flag)
values('CIA',2,'BMSChinaCIA_IMS','output','GeoID',' is null or ProductID is null'
	,'','','','','NORecords',1)

insert into tblQC_CheckRule(ProjectID,RuleID,SrcDB,SrcTable,SrcColumn,SrcExpression,DestDB,DestTable,DestColumn,DestExpression,[Rule],Flag)
values('CIA',3,'BMSChinaCIA_IMS','output','datasource',' is null'
	,'','','','','NORecords',1)
	
insert into tblQC_CheckRule(ProjectID,RuleID,SrcDB,SrcTable,SrcColumn,SrcExpression,DestDB,DestTable,DestColumn,DestExpression,[Rule],Flag)
values('CIA',4,'BMSChinaCIA_IMS','WebChartSeries','code',' is null or Geo is null'
	,'','','','','NORecords',1)		
--
insert into tblQC_CheckRule(ProjectID,RuleID,SrcDB,SrcTable,SrcColumn,SrcExpression,DestDB,DestTable,DestColumn,DestExpression,[Rule],Flag)
values('CIA',1001,'BMSChinaCIA_IMS','dim_city','city_code',' is null'
	,'','','','','NORecords',1)
	
insert into tblQC_CheckRule(ProjectID,RuleID,SrcDB,SrcTable,SrcColumn,SrcExpression,DestDB,DestTable,DestColumn,DestExpression,[Rule],Flag)
values('CIA',1002,'BMSChinaCIA_IMS','dim_product','product_code',' is null'
	,'','','','','NORecords',1)	

insert into tblQC_CheckRule(ProjectID,RuleID,SrcDB,SrcTable,SrcColumn,SrcExpression,DestDB,DestTable,DestColumn,DestExpression,[Rule],Flag)
values('CIA',1003,'BMSChinaCIA_IMS','dim_city','city_name',' is null and City_Name_CH in(N''�㶫'',N''�㽭'')'
	,'','','','','NORecords',1)
	
---
truncate table tblQC_CheckRuleEx

insert into tblQC_CheckRuleEx  (ProjectID,RuleID,SqlText,RuleDesc,Flag)
values('CIA',1,'
select  * 
from BMSChinaMRBI.dbo.tblPackageXRefHosp a
where not exists(
	select * from BMSChinaMRBI.dbo.tblDefProduct_CN_EN b
	where a.product_cn_src=b.Prod_CN	
)','Check if product in in hospital product-molecule table included into product config table',1)


insert into tblQC_CheckRuleEx  (ProjectID,RuleID,SqlText,RuleDesc,Flag)
values('CIA',2,'
select * from dbo.Output 
where linkchartcode in (''D021'',''D022'') and product=''Eliquis''',
'Check eliquis has data on ppt d020',1)

insert into tblQC_CheckRuleEx  (ProjectID,RuleID,SqlText,RuleDesc,Flag)
values('CIA',3,'
select * 
from output where (category=''Units'' and Currency = ''UNIT'') and Product = ''Paraplatin''',
'Check if paraplatin has units cagegory',1)

insert into tblQC_CheckRuleEx  (ProjectID,RuleID,SqlText,RuleDesc,Flag)
values('CIA',4,'
select * 
from output where (category=''Adjusted patient number'' or Currency = ''PN'') and Product <> ''Paraplatin''',
'Check if product except paraplatin has patient number cagegory',1)

insert into tblQC_CheckRuleEx  (ProjectID,RuleID,SqlText,RuleDesc,Flag)
values('CIA',5,'
select  * from dbo.TempCityDashboard a
where not exists(
	select * from outputgeo b
	where a.audi_des=b.geo
)',
'Check if geo in city temp table are included in geo config table',1)


---
insert into tblQC_CheckRuleEx  (ProjectID,RuleID,SqlText,RuleDesc,Flag)
values('CIA',1001,'
select  * 
from dbo.Dim_Fact_Sales 
where city_id is null or pack_id is null','Check if city or package have null value',1)


insert into tblQC_CheckRuleEx  (ProjectID,RuleID,SqlText,RuleDesc,Flag)
values('CIA',1002,'select * from BMSChinaMRBI.dbo.incpadata a
where not exists (
	select * from BMSChinaMRBI.dbo.tblHospitalMaster b
	where a.cpa_code=b.cpa_code
)','Check if all searainbow hospital includded into hospital master table',1)

insert into tblQC_CheckRuleEx  (ProjectID,RuleID,SqlText,RuleDesc,Flag)
values('CIA',1003,'
select * from BMSChinaMRBI.dbo.inCpaData a
where not exists (
	select * from BMSChinaMRBI.dbo.tblHospitalMaster b
	where a.cpa_code=b.cpa_code
)','Check if all cpa code included into hospital master table',1)

insert into tblQC_CheckRuleEx  (ProjectID,RuleID,SqlText,RuleDesc,Flag)
values('CIA',1004,'
select * from BMSChinaMRBI.dbo.inPharmData a
where not exists (
	select * from BMSChinaMRBI.dbo.tblHospitalMaster b
	where a.pharm_hospital_code=b.cpa_code
)','Check if all pharm hospital included into hospital master table',1)

insert into tblQC_CheckRuleEx  (ProjectID,RuleID,SqlText,RuleDesc,Flag)
values('CIA',1005,'
SELECT * FROM BMSChinaCIARawdata.dbo.DIM_CITY_201505 A FULL JOIN BMSChinaCIARawdata.dbo.DIM_CITY_201506 B
ON A.CITY_ID=B.CITY_ID AND A.CITY_CODE=B.CITY_CODE
WHERE A.CITY_ID IS NULL OR B.CITY_ID IS NULL
','Check city changes with last month',1)

--truncate table tblQC_CheckRuleParameter

--select * from tblQC_CheckResults

--exec [dbo].[sp_QC_CheckRules] 'CIA','5'