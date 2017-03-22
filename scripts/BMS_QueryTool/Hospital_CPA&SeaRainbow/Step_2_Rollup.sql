/* 对月数据进行Roll up */

use BMSCNProc2
go

exec dbo.sp_Log_Event 'Process','QT_CPA_Inline','Step_2_Rollup.sql','Start',null,null





delete from tblHospitalDataCT
where DataType like 'MQT%' 

delete from tblHospitalDataCT
where DataType like 'MAT%' 
GO

--Roll up MQT data:
insert into tblHospitalDataCT
select 'MQT'+substring(DataType, 4, 3) as DataType, Pack_Cod, CPA_ID 
, 0
, 0
, M48+M47+M46
, M47+M46+M45
, M46+M45+M44
, M45+M44+M43
, M44+M43+M42
, M43+M42+M41
, M42+M41+M40
, M41+M40+M39
, M40+M39+M38
, M39+M38+M37
, M38+M37+M36
, M37+M36+M35
, M36+M35+M34
, M35+M34+M33
, M34+M33+M32
, M33+M32+M31
, M32+M31+M30
, M31+M30+M29
, M30+M29+M28
, M29+M28+M27
, M28+M27+M26
, M27+M26+M25
, M26+M25+M24
, M25+M24+M23
, M24+M23+M22
, M23+M22+M21
, M22+M21+M20
, M21+M20+M19
, M20+M19+M18
, M19+M18+M17
, M18+M17+M16
, M17+M16+M15
, M16+M15+M14
, M15+M14+M13
, M14+M13+M12
, M13+M12+M11
, M12+M11+M10
, M11+M10+M09
, M10+M09+M08
, M09+M08+M07
, M08+M07+M06
, M07+M06+M05
, M06+M05+M04
, M05+M04+M03
, M04+M03+M02
, M03+M02+M01
from tblHospitalDataCT
go

--Roll up MAT data:
insert into tblHospitalDataCT
select 'MAT'+substring(DataType, 4, 3) as DataType, Pack_Cod, CPA_ID
, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
M48+M47+M46+M45+M44+M43+M42+M41+M40+M39+M38+M37,
M47+M46+M45+M44+M43+M42+M41+M40+M39+M38+M37+M36,
M46+M45+M44+M43+M42+M41+M40+M39+M38+M37+M36+M35,
M45+M44+M43+M42+M41+M40+M39+M38+M37+M36+M35+M34,
M44+M43+M42+M41+M40+M39+M38+M37+M36+M35+M34+M33,
M43+M42+M41+M40+M39+M38+M37+M36+M35+M34+M33+M32,
M42+M41+M40+M39+M38+M37+M36+M35+M34+M33+M32+M31,
M41+M40+M39+M38+M37+M36+M35+M34+M33+M32+M31+M30,
M40+M39+M38+M37+M36+M35+M34+M33+M32+M31+M30+M29,
M39+M38+M37+M36+M35+M34+M33+M32+M31+M30+M29+M28,
M38+M37+M36+M35+M34+M33+M32+M31+M30+M29+M28+M27,
M37+M36+M35+M34+M33+M32+M31+M30+M29+M28+M27+M26,
M36+M35+M34+M33+M32+M31+M30+M29+M28+M27+M26+M25,
M35+M34+M33+M32+M31+M30+M29+M28+M27+M26+M25+M24,
M34+M33+M32+M31+M30+M29+M28+M27+M26+M25+M24+M23,
M33+M32+M31+M30+M29+M28+M27+M26+M25+M24+M23+M22,
M32+M31+M30+M29+M28+M27+M26+M25+M24+M23+M22+M21,
M31+M30+M29+M28+M27+M26+M25+M24+M23+M22+M21+M20,
M30+M29+M28+M27+M26+M25+M24+M23+M22+M21+M20+M19,
M29+M28+M27+M26+M25+M24+M23+M22+M21+M20+M19+M18,
M28+M27+M26+M25+M24+M23+M22+M21+M20+M19+M18+M17,
M27+M26+M25+M24+M23+M22+M21+M20+M19+M18+M17+M16,
M26+M25+M24+M23+M22+M21+M20+M19+M18+M17+M16+M15,
M25+M24+M23+M22+M21+M20+M19+M18+M17+M16+M15+M14,
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


--Roll up YTD data:
declare @mth varchar(10)
select  @mth = DataPeriod from tblDataPeriod where QType = 'HOSP_I'
declare @sql varchar(max)
set @sql = 'insert into tblHospitalDataCT
select ''YTD''+substring(DataType, 4, 3) as DataType, Pack_Cod, CPA_ID
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -47, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -46, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -45, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -44, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -43, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -42, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -41, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -40, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -39, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -38, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -37, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -36, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -35, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -34, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -33, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -32, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -31, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -30, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -29, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -28, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -27, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -26, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -25, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -24, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -23, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -22, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -21, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -20, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -19, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -18, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -17, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -16, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -15, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -14, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -13, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -12, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -11, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -10, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -9, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -8, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -7, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -6, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -5, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -4, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -3, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -2, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(convert(varchar(6), dateadd(month, -1, cast(@mth+'01' as datetime)), 112))+'
  ,' + dbo.fun_getYTDMonths(@mth)+'
from tblHospitalDataCT where DataType like ''MTH%''
'
exec(@sql)
GO

exec dbo.sp_Log_Event 'Process','QT_CPA_Inline','Step_2_Rollup.sql','End',null,null





