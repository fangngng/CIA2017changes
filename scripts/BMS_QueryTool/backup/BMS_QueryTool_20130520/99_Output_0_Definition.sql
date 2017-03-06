use BMSChinaQueryToolNew
go

select 'Definition tables'
go



IF OBJECT_ID(N'OutputGeo',N'U') IS NOT NULL
	DROP TABLE OutputGeo
GO
SELECT * INTO OutputGeo FROM db2.BMSCNProc2.dbo.OutputGeo
go

IF OBJECT_ID(N'tblDataPeriod',N'U') IS NOT NULL
	DROP TABLE tblDataPeriod
GO
SELECT * INTO tblDataPeriod FROM db2.BMSCNProc2.dbo.tblDataPeriod
go

IF OBJECT_ID(N'tblDepartmentList',N'U') IS NOT NULL
	DROP TABLE tblDepartmentList
GO
SELECT * INTO tblDepartmentList FROM db2.BMSCNProc2.dbo.tblDepartmentList
go

IF OBJECT_ID(N'tblGeoList',N'U') IS NOT NULL
	DROP TABLE tblGeoList
GO
SELECT * INTO tblGeoList FROM db2.BMSCNProc2.dbo.tblGeoList
go

