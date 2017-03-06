use TempOutput --DB33
GO






--  1. 备份






--  2. 用web工具对.dbf文件入库






--  3. check

select count(*) from dbo.MTHCHPA_CMPS
select count(*) from TempOutput_201304.dbo.MTHCHPA_CMPS

select count(*) from dbo.MTHCHPA_PKAU
select count(*) from TempOutput_201304.dbo.MTHCHPA_PKAU

select count(*) from dbo.MTHCHPA_PKML
select count(*) from TempOutput_201304.dbo.MTHCHPA_PKML

select count(*) from dbo.MTHCITY_CMPS
select count(*) from TempOutput_201304.dbo.MTHCITY_CMPS

select count(*) from dbo.MTHCITY_PKAU
select count(*) from TempOutput_201304.dbo.MTHCITY_PKAU

select count(*) from dbo.MTHCITY_PKML 
select count(*) from TempOutput_201304.dbo.MTHCITY_PKML 





