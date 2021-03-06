/****** Script for SelectTopNRows command from SSMS  ******/
use BMSChinaMRBI
go
SELECT province,city,Y + right('0'+M,2) as YM,
datasource,b.CPA_code,CPA_name as hospital,CPA_name_english as hospital_english,
Molecule,Product,Package,Specification,Value,Volume,Form,Manufacture
  FROM [BMSChinaMRBI].[dbo].[inCPAData] a
  inner join [BMSChinaMRBI].[dbo].[tblHospitalMaster] b
  on a.CPA_ID = b.ID and Y+right('0'+M,2)=(select max(Y+right('0'+M,2)) from [BMSChinaMRBI].[dbo].[inCPAData])
  union all
select a.province,a.city, YM,datasource,cpa_code,hospital,
cpa_name_english as hospital_english,molecule,product,
package_num as package,Specification,Value,Volume,formI as form,Manufacture
from [BMSChinaMRBI].[dbo].inSeaRainbowData a
inner join [BMSChinaMRBI].[dbo].[tblHospitalMaster] b
on a.CPA_ID = b.ID and a.YM=(select max(YM) from [BMSChinaMRBI].[dbo].inSeaRainbowData)
union all
SELECT b.province,b.city,Y + right('0'+M,2) as YM,
datasource,b.CPA_code,CPA_name as hospital,CPA_name_english as hospital_english,
Molecule,Product,null as Package,Specification,Value,Volume,Form,Manufacture
  FROM [BMSChinaMRBI].[dbo].[inPharmData] a
  inner join [BMSChinaMRBI].[dbo].[tblHospitalMaster] b
  on a.CPA_ID = b.ID and a.Y + right('0'+a.M,2)=(select max(Y + right('0'+M,2)) from [BMSChinaMRBI].[dbo].[inPharmData])



--select top 1 * from [BMSChinaMRBI].[dbo].[inPharmData]
--select top 1 * from [BMSChinaMRBI].[dbo].[inCPAData]
--select top 1 * from tempoutput.dbo.PharmRawData_201504