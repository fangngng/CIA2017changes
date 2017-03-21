/*

按 季度 更新数据 每年分4季度

共保存处理最近的24季度，6年的数据

*/

use BMSCNProc2_test
go





update tblDataPeriod set DataPeriod = '201609' --todo
where QType = 'HOSP_P'
GO


exec dbo.sp_Log_Event 'Prepare','QT_CPA_Inline','0_Prepare_1_Hospital_Pipeline.sql','Start',null,null



truncate table tblDataQtrConv
go
insert into [tblDataQtrConv] ([Y],[Q],[Datamonth])
select '2016', '3', '201609' union all--todo
select '2016', '2', '201606' union all
select '2016', '1', '201603' union all
select '2015', '4', '201512' union all
select '2015', '3', '201509' union all
select '2015', '2', '201506' union all
select '2015', '1', '201503' union all
select '2014', '4', '201412' union all
select '2014', '3', '201409' union all
select '2014', '2', '201406' union all
select '2014', '1', '201403' union all
select '2013', '4', '201312' union all
select '2013', '3', '201309' union all 
select '2013', '2', '201306' union all 
select '2013', '1', '201303' union all 
select '2012', '4', '201212' union all
select '2012', '3', '201209' union all
select '2012', '2', '201206' union all
select '2012', '1', '201203' union all
select '2011', '4', '201112' union all
select '2011', '3', '201109' union all
select '2011', '2', '201106' union all
select '2011', '1', '201103' union all
select '2010', '4', '201012' union all
select '2010', '3', '201009' union all
select '2010', '2', '201006' union all
select '2010', '1', '201003' union all
select '2009', '4', '200912' union all
select '2009', '3', '200909' union all
select '2009', '2', '200906' union all
select '2009', '1', '200903' union all
select '2008', '4', '200812' union all
select '2008', '3', '200803' union all
select '2008', '2', '200806' union all
select '2008', '1', '200809' union all
select '2007', '4', '200712' union all
select '2007', '3', '200709' union all
select '2007', '2', '200706' 
GO
update [tblDataQtrConv] set QSeq = b.rk, DQ='Q'+cast(b.rk as varchar(5))
from [tblDataQtrConv] a 
inner join (
            select Y, Q, rank() over(order by Y desc, Q desc) as rk
            from [tblDataQtrConv]
            ) b
on a.Y=b.Y and a.Q=b.Q
GO


-- SELECT [Area] 
--       ,[Y]
--       ,[Q]
--       ,[CPA_Code]
--       ,[ATC_Code]
--       ,[Molecule]
--       ,[Product]
--       ,[Package]
--       ,[Specification]
--       ,[Package_Num]
--       ,[Value]
--       ,[Volume]
--       ,[Form]
--       ,[Way]
--       ,[Manufacture]
-- into inCPAData_pipeline_2016Q3 --todo 修改表明为最新的季度表
-- FROM [BMSCNProc2_test].[dbo].[inCPAData]
-- where Y='2016' and Q='3'--todo 修改为最新的季度
-- GO


-- --back up
-- --select * into BMSCNProc_bak.dbo.inCPAData_pipeline_2012Q4_all
-- --from inCPAData_pipeline 
-- select * into inCPAData_pipeline_2016Q2_all from inCPAData_pipeline --todo 每次插数据之前备份上个季度的数据（这里Q1是要随季度变动的）

-- delete all data that will insert 
-- rerun the script will cause repeat data 

delete inCPAData_pipeline
where 年 = '2016' and 季_度 = '3' -- todo 

insert into inCPAData_pipeline
select * from inCPAData_pipeline_2016Q3--todo 修改表名
go
exec dbo.sp_Log_Event 'Prepare','QT_CPA_Inline','0_Prepare_1_Hospital_Pipeline.sql','End',null,null

