use BMSCNProc2
go

Insert into tblRxProcessedRawCT
select 
     'MAT'+SUBSTRING(DataType, 3, 3) as DataType, Geo, Dept, Pack_Cod,
     0
     ,Mth_10+Mth_9
     , MTH_9+MTH_8
     , MTH_8+MTH_7
     , MTH_7+MTH_6
     , MTH_6+MTH_5
     , MTH_5+MTH_4
     , MTH_4+MTH_3
     , MTH_3+MTH_2
     , MTH_2+MTH_1
from tblRxProcessedRawCT 

