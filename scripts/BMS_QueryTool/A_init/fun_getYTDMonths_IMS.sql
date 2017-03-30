--������  ��Aric
--��   ; ����ȡ��ǰ�·ݵ� YTD����ͳ�Ƶ� �·�
--ʱ��    ��2013/5/9 17:13:42
--ִ�л�����DB32



use  BMSCNProc2
go

if object_id(N'fun_getYTDMonths_IMS()',N'U') is not null
	DROP FUNCTION fun_getYTDMonths_IMS
GO
CREATE FUNCTION fun_getYTDMonths_IMS(@mth varchar(10)) 
returns nvarchar(500)                                

AS 
BEGIN  



declare @YTD nvarchar(500)   

select @YTD =IsNull(@YTD,'')+DMshow+'+' from (
select Y,DMshow 
From tblDataMonthConv_IMS 
where [Datamonth] <= @mth and [Datamonth] >= subString(@mth,1,4)+'01'
) as t

set @YTD = LEFT(@YTD,LEN(@YTD)-1)



RETURN @YTD
END   




-- ����һ�������﷨  ��  select dbo.fun_getYTDMonths_IMS('200905')  



 