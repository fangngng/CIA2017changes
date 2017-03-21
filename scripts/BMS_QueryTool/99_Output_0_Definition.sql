use BMSChinaQueryToolNew
go


if not exists(select 1 from master.dbo.sysdatabases where name='BMSChinaQueryToolNew')
BEGIN
	RAISERROR ('The connection server is not 172.20.0.82, please re-connect the correct server!!',21,1) with log
END

IF OBJECT_ID(N'tblDataPeriod',N'U') IS NOT NULL
	DROP TABLE tblDataPeriod
GO
SELECT * INTO tblDataPeriod FROM BMSCNProc2_test.dbo.tblDataPeriod
go
IF OBJECT_ID(N'tblDepartmentList',N'U') IS NOT NULL
	DROP TABLE tblDepartmentList
GO
SELECT * INTO tblDepartmentList FROM BMSCNProc2_test.dbo.tblDepartmentList
go
IF OBJECT_ID(N'OutputGeo',N'U') IS NOT NULL
	DROP TABLE OutputGeo
GO
SELECT * INTO OutputGeo FROM BMSCNProc2_test.dbo.OutputGeo

if not exists(select 1 from outputgeo where geo='Guangdong')
begin
	insert into outputgeo(geo,Lev,Product)
	select distinct 'Guangdong' as geo,2 as Lev,product FROM BMSCNProc2_test.dbo.OutputGeo 
	where product is not null
	
	update outputgeo
	set geoname=N'�㶫'
	where geo='Guangdong'
	
end

if not exists(select 1 from outputgeo where geo='Suxi')
begin
	insert into outputgeo(geo,Lev,Product)
	select distinct 'Suxi' as geo,2 as Lev,product FROM BMSCNProc2_test.dbo.OutputGeo 
	where geo='Wuxi'
	
	update outputgeo
	set geoname=N'����'
	where geo='Suxi'
end

if not exists(select 1 from outputgeo where geo='Suxi')
begin
	insert into outputgeo(geo,Lev,Product)
	select distinct 'Suxi' as geo,2 as Lev,product FROM BMSCNProc2_test.dbo.OutputGeo 
	where geo='Wuxi'
	
	update outputgeo
	set geoname=N'����'
	where geo='Suxi'
end



go
IF OBJECT_ID(N'tblGeoList',N'U') IS NOT NULL
	DROP TABLE tblGeoList
GO
SELECT * INTO tblGeoList FROM BMSCNProc2_test.dbo.tblGeoList
go



