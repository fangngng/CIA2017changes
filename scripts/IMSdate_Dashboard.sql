USE BMSChinaCIA_IMS--DB4

update Config set [Value] = '201701' where Parameter = 'IMS'   --todo :月数据(备注：MaxMonth项表示 IMS一共出72个月的数据.)
update Config set [Value] = '201612' where Parameter = 'MAXDATA'   --todo 
GO
update Config set [Value] = '201612' where Parameter = 'HKAPI' --todo :(暂时没有用),HKAPI是季度数据
update Config set [current_quarter] = '2016Q4',[last_value]='2016Q3' where Parameter = 'HKAPI'
GO
update tblDateHKAPI set [Year]='2016' ,Qtr='Q4',[Month]='Dec'  --todo : 季度数据
