/*

按 季度 更新数据 每年分4季度

共保存处理最近的24分季度，6年的数据

*/

use BMSCNProc2
go






update tblDataPeriod set DataPeriod = '201212' --Hospital Pipeline Data Month
where QType = 'HOSP_P'
GO
--select * from tblDataPeriod


Print('----------------------------
		tblDataQtrConv
----------------------------------')
-- select * from tblDataQtrConv order by QSeq
truncate table tblDataQtrConv
go
-- refresh the quater list table for Hosp_P
insert into [tblDataQtrConv] ([Y],[Q],[Datamonth])
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
select '2007', '2', '200706' union all
select '2007', '1', '200703' 
GO
update [tblDataQtrConv] set QSeq = b.rk, DQ='Q'+cast(b.rk as varchar(5))
from [tblDataQtrConv] a 
inner join (
            select Y, Q, rank() over(order by Y desc, Q desc) as rk
            from [tblDataQtrConv]
            ) b
on a.Y=b.Y and a.Q=b.Q
GO







Print('----------------------------
     inCPAData_pipeline
----------------------------------')
--1. backup
select * 
into inCPAData_pipeline_2012Q3_all
from inCPAData_pipeline 
go


--2. Import hospital pipeline data
insert into inCPAData_pipeline_2012Q4
select distinct * 
from OpenRowSet('MICROSOFT.JET.OLEDB.4.0'
,'Excel 8.0;HDR=Yes;IMEX=1;Database=D:\BMSChina_QueryTool\DataSource\130222施贵宝4Q12季度检索.xls'
,[施贵宝4Q12$]) 
go


--3. insert季度数据到inCPAData_pipeline
insert into inCPAData_pipeline
select * from inCPAData_pipeline_2012Q4
go

--4.检查数据情况
select distinct 年,季_度 
from inCPAData_pipeline

select 年,季_度,count(1)  
from inCPAData_pipeline
GROUP BY 年,季_度
ORDER BY 年,季_度

