--������  ��Aric
--��   ; ����ȡ��ǰ�·ݵ� YTD����ͳ�Ƶ� �·�
--ʱ��    ��2013/5/7 15:29:04
--ִ�л�����DB32



use  BMSCNProc2_test
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




-- ����һ�������﷨  ��  select dbo.fun_getYTDMonths('201302')  



 