--创建人  ：Aric
--用   途 ：获取当前月份的 YTD所需统计的 月份
--时间    ：2013/5/7 15:29:04
--执行环境：DB32



use  BMSCNProc2
go

if object_id(N'fun_getYTDMonths()',N'U') is not null
	DROP FUNCTION fun_getYTDMonths
GO
CREATE FUNCTION fun_getYTDMonths(@mth varchar(10)) 
returns nvarchar(500)                                

AS 
BEGIN  



declare @YTD nvarchar(500)   

select @YTD =IsNull(@YTD,'')+DM+'+' from (
select Y,DM 
From tblDataMonthConv 
where [Datamonth] <= @mth and [Datamonth] >= subString(@mth,1,4)+'01'
) as t

set @YTD = LEFT(@YTD,LEN(@YTD)-1)



RETURN @YTD
END   




-- 调用一个函数语法  ：  select dbo.fun_getYTDMonths('201302')  



 