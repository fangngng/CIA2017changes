use BMSCNProc2_test
go
exec dbo.sp_Log_Event 'Process','QT_Rx','Step_2_Add_MAT_Data.sql','Start',null,null
go
Insert into tblRxProcessedRawCT (DataType,Geo,Dept,Pack_Cod,[Mth_20],
[Mth_19],[Mth_18],[Mth_17],[Mth_16],[Mth_15],[Mth_14],[Mth_13],[Mth_12],[Mth_11],
[Mth_10],[Mth_9],[Mth_8],[Mth_7],[Mth_6],[Mth_5],[Mth_4],[Mth_3],[Mth_2],[Mth_1])
select 
     'MAT'+SUBSTRING(DataType, 3, 3) as DataType, Geo, Dept, Pack_Cod
     , 0
     , 0
     , 0
     , MTH_20+MTH_19+MTH_18+MTH_17
     , MTH_19+MTH_18+MTH_17+MTH_16
     , MTH_18+MTH_17+MTH_16+MTH_15
     , MTH_17+MTH_16+MTH_15+MTH_14
     , MTH_16+MTH_15+MTH_14+MTH_13
     , MTH_15+MTH_14+MTH_13+MTH_12
     , MTH_14+MTH_13+MTH_12+MTH_11
     , MTH_13+MTH_12+MTH_11+MTH_10
     , MTH_12+MTH_11+MTH_10+MTH_9
     , MTH_11+MTH_10+MTH_9+MTH_8
     , MTH_10+MTH_9+MTH_8+MTH_7
     , MTH_9+MTH_8+MTH_7+MTH_6
     , MTH_8+MTH_7+MTH_6+MTH_5
     , MTH_7+MTH_6+MTH_5+MTH_4
     , MTH_6+MTH_5+MTH_4+MTH_3
     , MTH_5+MTH_4+MTH_3+MTH_2
     , MTH_4+MTH_3+MTH_2+MTH_1
from tblRxProcessedRawCT 

exec dbo.sp_Log_Event 'Process','QT_Rx','Step_2_Add_MAT_Data.sql','End',null,null