
use BMSCNProc2
go

--Roll up MQT data:
insert into tblHospitalDataCT
select 'MQT'+substring(DataType, 4, 3) as DataType, Pack_Cod, CPA_ID, 
0, 0, M24+M23+M22, M23+M22+M21, M22+M21+M20, M21+M20+M19, 
M20+M19+M18, M19+M18+M17, M18+M17+M16, M17+M16+M15, M16+M15+M14, M15+M14+M13, 
M14+M13+M12, M13+M12+M11, M12+M11+M10, M11+M10+M09, M10+M09+M08, M09+M08+M07, 
M08+M07+M06, M07+M06+M05, M06+M05+M04, M05+M04+M03, M04+M03+M02, M03+M02+M01
from tblHospitalDataCT
go
--Roll up MAT data:
insert into tblHospitalDataCT
select 'MAT'+substring(DataType, 4, 3) as DataType, Pack_Cod, CPA_ID, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
M24+M23+M22+M21+M20+M19+M18+M17+M16+M15+M14+M13, 
M23+M22+M21+M20+M19+M18+M17+M16+M15+M14+M13+M12, 
M22+M21+M20+M19+M18+M17+M16+M15+M14+M13+M12+M11, 
M21+M20+M19+M18+M17+M16+M15+M14+M13+M12+M11+M10, 
M20+M19+M18+M17+M16+M15+M14+M13+M12+M11+M10+M09, 
M19+M18+M17+M16+M15+M14+M13+M12+M11+M10+M09+M08, 
M18+M17+M16+M15+M14+M13+M12+M11+M10+M09+M08+M07, 
M17+M16+M15+M14+M13+M12+M11+M10+M09+M08+M07+M06, 
M16+M15+M14+M13+M12+M11+M10+M09+M08+M07+M06+M05, 
M15+M14+M13+M12+M11+M10+M09+M08+M07+M06+M05+M04, 
M14+M13+M12+M11+M10+M09+M08+M07+M06+M05+M04+M03, 
M13+M12+M11+M10+M09+M08+M07+M06+M05+M04+M03+M02, 
M12+M11+M10+M09+M08+M07+M06+M05+M04+M03+M02+M01 
from tblHospitalDataCT where DataType like 'MTH%'
go
