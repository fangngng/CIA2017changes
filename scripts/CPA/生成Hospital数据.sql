/****** Script for SelectTopNRows command from SSMS  ******/
SELECT province,city,Y + right('0'+M,2) as YM,
datasource,b.CPA_code,CPA_name as hospital,CPA_name_english as hospital_english,
Molecule,Product,Package,Specification,Value,Volume,Form,Manufacture
  FROM [BMSChinaMRBI_test].[dbo].[inCPAData] a
  inner join [BMSChinaMRBI_test].[dbo].[tblHospitalMaster] b
  on a.CPA_ID = b.ID and Y+right('0'+M,2)=(select max(Y+right('0'+M,2)) from [BMSChinaMRBI_test].[dbo].[inCPAData])
  union
select a.province,a.city, YM,datasource,cpa_code,hospital,
cpa_name_english as hospital_english,molecule,product,
package_num as package,Specification,Value,Volume,formI as form,Manufacture
from [BMSChinaMRBI_test].[dbo].inSeaRainbowData a
inner join [BMSChinaMRBI_test].[dbo].[tblHospitalMaster] b
on a.CPA_ID = b.ID and a.YM=(select max(YM) from [BMSChinaMRBI_test].[dbo].inSeaRainbowData)




