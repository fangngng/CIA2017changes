use BMSCNProc2_test
go

exec dbo.sp_Log_Event 'Process','QT_CPA_Inline','Step_2_RollupMAT.sql','Start',null,null
go
--Roll up MAT data:
delete from tblHospitalDataCT_Pipeline where DataType like 'MAT%';
GO
insert into tblHospitalDataCT_Pipeline (DataType, Pack_Cod, CPA_Code, M24, M23, M22, M21, M20, M19, M18, M17, M16, M15, M14, M13, M12, M11, M10, M09, M08, M07, M06, M05, M04, M03, M02, M01)
select 
  'MAT'+substring(DataType, 4, 3) as DataType, Pack_Cod, CPA_Code,
  0,
  0,
  0,
  M24+M23+M22+M21, 
  M23+M22+M21+M20, 
  M22+M21+M20+M19, 
  M21+M20+M19+M18, 
  M20+M19+M18+M17, 
  M19+M18+M17+M16, 
  M18+M17+M16+M15, 
  M17+M16+M15+M14, 
  M16+M15+M14+M13, 
  M15+M14+M13+M12, 
  M14+M13+M12+M11, 
  M13+M12+M11+M10, 
  M12+M11+M10+M09, 
  M11+M10+M09+M08, 
  M10+M09+M08+M07, 
  M09+M08+M07+M06, 
  M08+M07+M06+M05, 
  M07+M06+M05+M04, 
  M06+M05+M04+M03, 
  M05+M04+M03+M02, 
  M04+M03+M02+M01 
from tblHospitalDataCT_Pipeline where DataType like 'MQT%'
go



--Roll up YTD data:
declare @mth varchar(10),@sql nvarchar(MAX)
select  @mth = DataPeriod from tblDataPeriod where QType = 'HOSP_P'

set @sql = 'insert into tblHospitalDataCT_Pipeline (DataType, Pack_Cod, CPA_Code, M24, M23, M22, M21, M20, M19, M18, M17, M16, M15, M14, M13, M12, M11, M10, M09, M08, M07, M06, M05, M04, M03, M02, M01)
select ''YTD''+substring(DataType, 4, 3) as DataType, Pack_Cod, CPA_Code
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-23*3,cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-22*3,cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-21*3,cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-20*3,cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-19*3,cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-18*3,cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-17*3,cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-16*3,cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-15*3,cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-14*3,cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-13*3,cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-12*3,cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-11*3,cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-10*3,cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-9*3, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-8*3, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-7*3, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-6*3, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-5*3, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-4*3, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-3*3, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-2*3, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(convert(varchar(6), dateadd(month,-1*3, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths_HospitalPipeline(@mth)+'
from tblHospitalDataCT_Pipeline where DataType like ''MQT%''
'
-- print(@sql)
exec(@sql)
GO
exec dbo.sp_Log_Event 'Process','QT_CPA_Inline','Step_2_RollupMAT.sql','End',null,null
