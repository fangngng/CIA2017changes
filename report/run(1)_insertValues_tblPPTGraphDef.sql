use BMSChina_ppt
go



-- todo  lastMonth : 201611









-- backup 
if object_id(N'tblPPTGraphDef_201611',N'U') is null
  select * into tblPPTGraphDef_201611 from tblPPTGraphDef
go








truncate table tblPPTGraphDef
go

insert into tblPPTGraphDef
select 'C020','C020','Portfolio','Portfolio','Chart','Y','Series||X','1','1'

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('C660','C660','Eliquis VTEP','Eliquis VTEP','chart','Y','Series||X','1','1')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('C660','C661','Eliquis NOAC','Eliquis NOAC','chart','Y','Series||X','1','1')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('C690','C690','Eliquis VTEP','Eliquis VTEP','chart','Y','Series||X','1','1')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('C690','C691','Eliquis NOAC','Eliquis NOAC','chart','Y','Series||X','1','1')
go
insert into tblPPTGraphDef
select 'C020','C020','Portfolio','Portfolio','sheet','D','Series||X','1','1'
go
insert into tblPPTGraphDef
select 'C030','C030','Portfolio','Portfolio','Chart','Y','Series||X','1','1'
go
insert into tblPPTGraphDef
select 'C040','C040','Portfolio','Portfolio','Chart','Y','Series||X','1','1'
go
insert into tblPPTGraphDef
select 'C040','C040','Portfolio','Portfolio','SpecialTable','D','Series||X','1','1'	
go				
insert into tblPPTGraphDef
select 'C050','C050','Portfolio','Portfolio','Chart','Y','Series||X','1','1'
go
insert into tblPPTGraphDef
select 'C050','C050','Portfolio','Portfolio','SpecialTable','D','Series||X','1','1'	
go		
insert into tblPPTGraphDef
select 'C060','C060','Portfolio','Portfolio','Chart','Y','Series||X','1','1'
go
insert into tblPPTGraphDef
select 'C060','C060','Portfolio','Portfolio','SpecialTable','D','Series||','1','1'	
go	
insert into tblPPTGraphDef
select 'C070','C070','Portfolio','Portfolio','Chart','Y','Series||X','1','1'
go
insert into tblPPTGraphDef
select 'C070','C070','Portfolio','Portfolio','SpecialTable','D','Series||','1','1'	
go
insert into tblPPTGraphDef
select 'C080','C080','Portfolio','Portfolio','Chart','Y','Series||X','1','1'
go	
insert into tblPPTGraphDef
select 'C100','C100','Portfolio','Portfolio','Chart','Y','Series||X','1','1'
go
insert into tblPPTGraphDef
select 'C100','C100','Portfolio','Portfolio','SpecialTable','D','Series||X','1','1'	
go				
insert into tblPPTGraphDef
select 'C110','C110','Portfolio','Portfolio','Chart','Y','Series||X','1','1'
go
insert into tblPPTGraphDef
select 'C110','C110','Portfolio','Portfolio','SpecialTable','D','Series||X','1','1'	
go
insert into tblPPTGraphDef
select distinct 'C120','C120',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='C120'
go
insert into tblPPTGraphDef
select distinct 'C120','C121',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='C121'
GO



print('---------------------
				Region Lev
----------------------')

insert into tblPPTGraphDef
select distinct 'D030',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D031'
go
insert into tblPPTGraphDef
select distinct 'D030',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D032'
go

insert into tblPPTGraphDef
select distinct 'D030',linkchartcode,product,product,'ppttable','D','Series||x','1','1'	
from tblChartTitle where linkchartcode='D031'
go
insert into tblPPTGraphDef
select distinct 'D030',linkchartcode,product,product,'sheet1','L','Series||','1','1'	
from tblChartTitle where linkchartcode='D032'
go


insert into tblPPTGraphDef
select distinct 'D020',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D021'
go
insert into tblPPTGraphDef
select distinct 'D020',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D022'
go

insert into tblPPTGraphDef
select distinct 'D020',linkchartcode,product,product,'ppttable','D','Series||X','1','1'	
from tblChartTitle where linkchartcode='D021'
go

insert into tblPPTGraphDef
select distinct 'D020',linkchartcode,product,product,'sheet1','L','Series||','1','1'	
from tblChartTitle where linkchartcode='D022'
go


insert into tblPPTGraphDef
select distinct 'D020',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D023'
go
insert into tblPPTGraphDef
select distinct 'D020',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D024'
go

insert into tblPPTGraphDef
select distinct 'D020',linkchartcode,product,product,'ppttable','D','Series||X','1','1'	
from tblChartTitle where linkchartcode='D023'
go

insert into tblPPTGraphDef
select distinct 'D020',linkchartcode,product,product,'sheet1','L','Series||','1','1'	
from tblChartTitle where linkchartcode='D024'
go

insert into tblPPTGraphDef
select distinct 'D040',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D041'
go
insert into tblPPTGraphDef
select distinct 'D040',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D042'
go

insert into tblPPTGraphDef
select distinct 'D040',linkchartcode,product,product,'ppttable','D','Series||X','1','1'	
from tblChartTitle where linkchartcode='D041'
go

insert into tblPPTGraphDef
select distinct 'D040',linkchartcode,product,product,'sheet1','L','Series||','1','1'	
from tblChartTitle where linkchartcode='D042'
go


insert into tblPPTGraphDef
select distinct 'D050',linkchartcode,product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D050'
go
insert into tblPPTGraphDef
select distinct 'D050',linkchartcode,product,product,'SpecialTable','D','Series||','1','1'	
from tblChartTitle where linkchartcode='D050'
go
insert into tblPPTGraphDef
select distinct 'D050',linkchartcode,product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D051'
go
insert into tblPPTGraphDef
select distinct 'D050',linkchartcode,product,product,'SpecialTable','D','Series||','1','1'	
from tblChartTitle where linkchartcode='D051'
go

insert into tblPPTGraphDef
select distinct 'D060',linkchartcode,product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D060'
go
insert into tblPPTGraphDef
select distinct 'D060',linkchartcode,product,product,'SpecialTable','D','Series||','1','1'	
from tblChartTitle where linkchartcode='D060'
go



print('---------------------
				city Lev(brand)
----------------------')

insert into tblPPTGraphDef
select distinct 'D090',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D091'
go
insert into tblPPTGraphDef
select distinct 'D090',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D092'
go
insert into tblPPTGraphDef
select distinct 'D090',linkchartcode,product,product,'Chart3','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D093'
go
insert into tblPPTGraphDef
select distinct 'D090',linkchartcode,product,product,'Chart4','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D094'
go


print('---------------------
				city Lev
----------------------')

insert into tblPPTGraphDef
select distinct 'D080',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D081'
go
insert into tblPPTGraphDef
select distinct 'D080',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D082'
go
insert into tblPPTGraphDef
select distinct 'D080',linkchartcode,product,product,'Chart3','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D083'
go
insert into tblPPTGraphDef
select distinct 'D080',linkchartcode,product,product,'Chart4','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D084'
GO
insert into tblPPTGraphDef
select distinct 'D080',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D085'
go
insert into tblPPTGraphDef
select distinct 'D080',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D086'
go
insert into tblPPTGraphDef
select distinct 'D080',linkchartcode,product,product,'Chart3','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D087'
go
insert into tblPPTGraphDef
select distinct 'D080',linkchartcode,product,product,'Chart4','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D088'
GO

insert into tblPPTGraphDef
select distinct 'D100',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D101'
go
insert into tblPPTGraphDef
select distinct 'D100',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D102'
go
insert into tblPPTGraphDef
select distinct 'D100',linkchartcode,product,product,'Chart3','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D103'
go
insert into tblPPTGraphDef
select distinct 'D100',linkchartcode,product,product,'Chart4','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D104'
GO



print('---------------------
				city Lev
----------------------')
insert into tblPPTGraphDef
select distinct 'D110',linkchartcode,product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D110'
go

insert into tblPPTGraphDef
select distinct 'D110',linkchartcode,product,product,'SpecialTable','D','Series||','1','1'	
from tblChartTitle where linkchartcode='D110'
go
insert into tblPPTGraphDef
select distinct 'D110',linkchartcode,product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D111'
go

insert into tblPPTGraphDef
select distinct 'D110',linkchartcode,product,product,'SpecialTable','D','Series||','1','1'	
from tblChartTitle where linkchartcode='D111'
go

insert into tblPPTGraphDef
select distinct 'D130',linkchartcode,product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D130'
go


insert into tblPPTGraphDef
select distinct 'D150',linkchartcode,product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='D150'
and  product  in ('Monopril')
go





print('---------------------
				Brand Reports:R020
----------------------')

insert into tblPPTGraphDef
select distinct 'R020',linkchartcode,product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R020'
go
insert into tblPPTGraphDef
select distinct 'R020',linkchartcode,product,product,'sheet','L','Series||X','1','1'	
from tblChartTitle where linkchartcode='R020' and product='Baraclude'
go
insert into tblPPTGraphDef
select distinct 'R020',linkchartcode,product,product,'sheet1','D','Series||x','1','2'	
from tblChartTitle where linkchartcode='R020'
and product not in ('Baraclude')
go
insert into tblPPTGraphDef
select distinct 'R020',linkchartcode,product,product,'sheet2','L','Series||','1','2'	
from tblChartTitle where linkchartcode='R020'
and product not in ('Baraclude')
go
print('---------------------
				R030
----------------------')
insert into tblPPTGraphDef
select distinct 'R030',linkchartcode,product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle 
where linkchartcode='R030'
go

insert into tblPPTGraphDef
select distinct 'R030',linkchartcode,product,product,'sheet1','D','Series||x','1','2'	
from tblChartTitle 
where linkchartcode='R030'
go
insert into tblPPTGraphDef
select distinct 'R030',linkchartcode,product,product,'sheet2','L','Series||','1','2'	
from tblChartTitle 
where linkchartcode='R030'
go

print('---------------------
				R040
----------------------')
insert into tblPPTGraphDef
select distinct 'R040',linkchartcode,product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R040'
go
insert into tblPPTGraphDef
select distinct 'R040',linkchartcode,product,product,'sheet','L','Series||X','1','1'	
from tblChartTitle where linkchartcode='R040' 
go

print('---------------------
				R050
----------------------')
insert into tblPPTGraphDef
select distinct 'R050',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R051'
go
insert into tblPPTGraphDef
select distinct 'R050',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R052'
go
insert into tblPPTGraphDef
select distinct 'R050',linkchartcode,product,product,'Chart3','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R053'
go
insert into tblPPTGraphDef
select distinct 'R050',linkchartcode,product,product,'Chart4','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R054'
go


print('---------------------
				R060
----------------------')
insert into tblPPTGraphDef
select distinct 'R060',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R061'
go
insert into tblPPTGraphDef
select distinct 'R060',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R062'
go
insert into tblPPTGraphDef
select distinct 'R060',linkchartcode,product,product,'Chart3','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R063'
go
insert into tblPPTGraphDef
select distinct 'R060',linkchartcode,product,product,'Chart4','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R064'
go
print('---------------------
				R070
----------------------')
insert into tblPPTGraphDef
select distinct 'R070',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R071'
go
insert into tblPPTGraphDef
select distinct 'R070',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R072'
go
insert into tblPPTGraphDef
select distinct 'R070',linkchartcode,product,product,'Chart3','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R073'
go
insert into tblPPTGraphDef
select distinct 'R070',linkchartcode,product,product,'Chart4','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R074'
go

print('---------------------
				R080
----------------------')
insert into tblPPTGraphDef
select distinct 'R080',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R081'
go
insert into tblPPTGraphDef
select distinct 'R080',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R082'
go
insert into tblPPTGraphDef
select distinct 'R080',linkchartcode,product,product,'Chart3','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R083'
go
insert into tblPPTGraphDef
select distinct 'R080',linkchartcode,product,product,'Chart4','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R084'
go




print('---------------------
				R090
----------------------')
insert into tblPPTGraphDef
select distinct 'R090',linkchartcode,product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R090'
go
insert into tblPPTGraphDef
select distinct 'R090',linkchartcode,product,product,'SpecialTable','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R090' 
go
print('---------------------
				R100
----------------------')
insert into tblPPTGraphDef
select distinct 'R100',linkchartcode,product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R100' 
go
insert into tblPPTGraphDef
select distinct 'R100',linkchartcode,product,product,'SpecialTable','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R100' and product not in ('Glucophage')
go
print('---------------------
				R110
----------------------')
insert into tblPPTGraphDef
select distinct 'R110',linkchartcode,product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R110'
go
insert into tblPPTGraphDef
select distinct 'R110',linkchartcode,product,product,'SpecialTable','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R110' 
go
print('---------------------
				R120
----------------------')
insert into tblPPTGraphDef
select distinct 'R120',linkchartcode,product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R120'
go
print('---------------------
				R130
----------------------')
insert into tblPPTGraphDef
select distinct 'R130',linkchartcode,product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R130'
go

print('---------------------
				R150
----------------------')
insert into tblPPTGraphDef
select distinct 'R150',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R151'
go
insert into tblPPTGraphDef
select distinct 'R150',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R152'
go
insert into tblPPTGraphDef
select distinct 'R150',linkchartcode,product,product,'Chart3','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R153'
go
insert into tblPPTGraphDef
select distinct 'R150',linkchartcode,product,product,'Chart4','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R154'
go
-- removed Diabetes by class
delete tblPPTGraphDef
where code = 'R150' and product = 'Glucophage'
go

print('---------------------
				R160
----------------------')
insert into tblPPTGraphDef
select distinct 'R160',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R161'
go
insert into tblPPTGraphDef
select distinct 'R160',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R162'
go
insert into tblPPTGraphDef
select distinct 'R160',linkchartcode,product,product,'Chart3','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R163'
go
insert into tblPPTGraphDef
select distinct 'R160',linkchartcode,product,product,'Chart4','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R164'
go


print('---------------------
				R170
----------------------')
insert into tblPPTGraphDef
select distinct 'R170',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R171'
go
insert into tblPPTGraphDef
select distinct 'R170',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R172'
go
insert into tblPPTGraphDef
select distinct 'R170',linkchartcode,product,product,'Chart3','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R173'
go
insert into tblPPTGraphDef
select distinct 'R170',linkchartcode,product,product,'Chart4','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R174'
go


print('---------------------
				R180
----------------------')
insert into tblPPTGraphDef
select distinct 'R180',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R181'
go
insert into tblPPTGraphDef
select distinct 'R180',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R182'
go
insert into tblPPTGraphDef
select distinct 'R180',linkchartcode,product,product,'Chart3','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R183'
go
insert into tblPPTGraphDef
select distinct 'R180',linkchartcode,product,product,'Chart4','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R184'
go

print('---------------------
				R190
----------------------')
insert into tblPPTGraphDef
select distinct 'R190',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R191'
go
insert into tblPPTGraphDef
select distinct 'R190',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R191'
go
insert into tblPPTGraphDef
select distinct 'R190',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R192'
go

print('---------------------
				R200
----------------------')
insert into tblPPTGraphDef
select distinct 'R200',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R201'
go
insert into tblPPTGraphDef
select distinct 'R200',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R202'
go
insert into tblPPTGraphDef
select distinct 'R200',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R201'
go
print('---------------------
				R210
----------------------')
insert into tblPPTGraphDef
select distinct 'R210',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R211'
go
insert into tblPPTGraphDef
select distinct 'R210',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R212'
go
insert into tblPPTGraphDef
select distinct 'R210',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R211'
go


print('---------------------
				R220
----------------------')
insert into tblPPTGraphDef
select distinct 'R220',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R221'
go
insert into tblPPTGraphDef
select distinct 'R220',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R222'
go
insert into tblPPTGraphDef
select distinct 'R220',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R221'
go


print('---------------------
				R230
----------------------')
insert into tblPPTGraphDef
select distinct 'R230',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R231'
go
insert into tblPPTGraphDef
select distinct 'R230',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R232'
go
insert into tblPPTGraphDef
select distinct 'R230',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R231'
go

print('---------------------
				R240
----------------------')
insert into tblPPTGraphDef
select distinct 'R240',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R241'
go
insert into tblPPTGraphDef
select distinct 'R240',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R242'
go
insert into tblPPTGraphDef
select distinct 'R240',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R241'
go

print('---------------------
				R250
----------------------')
insert into tblPPTGraphDef
select distinct 'R250',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R251'
go
insert into tblPPTGraphDef
select distinct 'R250',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R252'
go
insert into tblPPTGraphDef
select distinct 'R250',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R251'
go

print('---------------------
				R260
----------------------')
insert into tblPPTGraphDef
select distinct 'R260',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R261'
go
insert into tblPPTGraphDef
select distinct 'R260',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R262'
go
insert into tblPPTGraphDef
select distinct 'R260',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R261'
go

print('---------------------
				R270
----------------------')
insert into tblPPTGraphDef
select distinct 'R270',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R271'
go
insert into tblPPTGraphDef
select distinct 'R270',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R272'
go
insert into tblPPTGraphDef
select distinct 'R270',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R271'
go

print('---------------------
				R280
----------------------')
insert into tblPPTGraphDef
select distinct 'R280',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R281'
go
insert into tblPPTGraphDef
select distinct 'R280',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R282'
go
insert into tblPPTGraphDef
select distinct 'R280',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R281'
go
print('---------------------
				R290
----------------------')
insert into tblPPTGraphDef
select distinct 'R290',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R291'
go
insert into tblPPTGraphDef
select distinct 'R290',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R292'
go
insert into tblPPTGraphDef
select distinct 'R290',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R291'
go

print('---------------------
				R300
----------------------')
insert into tblPPTGraphDef
select distinct 'R300',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R301'
go
insert into tblPPTGraphDef
select distinct 'R300',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R302'
go
insert into tblPPTGraphDef
select distinct 'R300',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R301'
go

print('---------------------
				R900
----------------------')
insert into tblPPTGraphDef
select distinct 'R900',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R901'
go
insert into tblPPTGraphDef
select distinct 'R900',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R902'
go
insert into tblPPTGraphDef
select distinct 'R900',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R901'
go
print('---------------------
				R960
----------------------')
insert into tblPPTGraphDef
select distinct 'R960',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R961'
go
insert into tblPPTGraphDef
select distinct 'R960',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R962'
go
insert into tblPPTGraphDef
select distinct 'R960',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R961'
go

print('---------------------
				Onglyza DPP-IV for Hospital
----------------------')
insert into tblPPTGraphDef
select distinct 'R910',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R911'
go
insert into tblPPTGraphDef
select distinct 'R910',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R912'
go
insert into tblPPTGraphDef
select distinct 'R910',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R911'
go

insert into tblPPTGraphDef
select distinct 'R970',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R971'
go
insert into tblPPTGraphDef
select distinct 'R970',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R972'
go
insert into tblPPTGraphDef
select distinct 'R970',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R971'
go

insert into tblPPTGraphDef
select distinct 'R920',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R921'
go
insert into tblPPTGraphDef
select distinct 'R920',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R922'
go
insert into tblPPTGraphDef
select distinct 'R920',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R921'
go

insert into tblPPTGraphDef
select distinct 'R980',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R981'
go
insert into tblPPTGraphDef
select distinct 'R980',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R982'
go
insert into tblPPTGraphDef
select distinct 'R980',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R981'
go

insert into tblPPTGraphDef
select distinct 'R930',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R931'
go
insert into tblPPTGraphDef
select distinct 'R930',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R932'
go
insert into tblPPTGraphDef
select distinct 'R930',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R931'
go

insert into tblPPTGraphDef
select distinct 'R990',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R991'
go
insert into tblPPTGraphDef
select distinct 'R990',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R992'
go
insert into tblPPTGraphDef
select distinct 'R990',linkchartcode,product,product,'sheet','D','Series||','1','1'	
from tblChartTitle where linkchartcode='R991'
go


print('---------------------
				R320
----------------------')
insert into tblPPTGraphDef
select distinct 'R320',linkchartcode,product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R320'
go


print('---------------------
				R340
----------------------')
insert into tblPPTGraphDef
select distinct 'R340',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R341'
go
insert into tblPPTGraphDef
select distinct 'R340',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R342'
go
insert into tblPPTGraphDef
select distinct 'R340',linkchartcode,product,product,'sheet','D','Series||X','1','1'	
from tblChartTitle where linkchartcode='R342'
go

print('---------------------
				R350
----------------------')
insert into tblPPTGraphDef
select distinct 'R350',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R351'
go
insert into tblPPTGraphDef
select distinct 'R350',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R352'
go
insert into tblPPTGraphDef
select distinct 'R350',linkchartcode,product,product,'sheet','D','Series||X','1','1'	
from tblChartTitle where linkchartcode='R352'
go

print('---------------------
				R360
----------------------')
insert into tblPPTGraphDef
select distinct 'R360',linkchartcode,product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R361'
go
insert into tblPPTGraphDef
select distinct 'R360',linkchartcode,product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R362'
go
insert into tblPPTGraphDef
select distinct 'R360',linkchartcode,product,product,'sheet','D','Series||X','1','1'	
from tblChartTitle where linkchartcode='R362'
go


--'R200',
--'R190',
--'R910',
--'R210',
--'R920',
--'R220',
--'R230',
--'R930',
--'R260',
--'R250',
--'R970',
--'R270',
--'R980',
--'R280',
--'R290',
--'R990'
print 'Patch for Onglyza'

insert into tblPPTGraphDef
select 'R250','R252','Onglyza','Onglyza','Chart2','Y','Series||X',1,1
insert into tblPPTGraphDef
select 'R270','R272','Onglyza','Onglyza','Chart2','Y','Series||X',1,1
insert into tblPPTGraphDef
select 'R280','R282','Onglyza','Onglyza','Chart2','Y','Series||X',1,1
insert into tblPPTGraphDef
select 'R970','R972','Onglyza','Onglyza','Chart2','Y','Series||X',1,1
insert into tblPPTGraphDef
select 'R980','R982','Onglyza','Onglyza','Chart2','Y','Series||X',1,1
go
--------------------------------------------
--	R777: Baraclude Modification Slide 7
--------------------------------------------
insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R777','R777','Baraclude','Baraclude','Chart','Y','Series||X','1','1')

insert into  tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R777','R777','Baraclude','Baraclude','sheet','L','Series||','1','1')

--------------------------------------------
-- CIA-CV Monopril Modification
--------------------------------------------

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R610','R610','Monopril','Monopril','pptTable','D','Series||X','1','1')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R620','R620','Monopril','Monopril','pptTable','D','Series||X','2','2')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R630','R630','Monopril','Monopril','pptTable','D','Series||X','2','2')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R720','R720','Coniel','Coniel','pptTable','D','Series||X','2','2')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R730','R730','Coniel','Coniel','pptTable','D','Series||X','2','2')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R640','R640','Monopril','Monopril','pptTable','D','Series||X','1','3')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R650','R651','Monopril','Monopril','chart1','Y','Series||X','1','1')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R650','R652','Monopril','Monopril','chart2','Y','Series||X','1','1')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R650','R653','Monopril','Monopril','ppttable1','D','Series||X','1','1')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R650','R654','Monopril','Monopril','pptTable2','D','Series||X','1','1')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R620','R620','Eliquis VTEP','Eliquis VTEP','pptTable','D','Series||X','2','2')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R630','R630','Eliquis VTEP','Eliquis VTEP','pptTable','D','Series||X','2','2')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R640','R640','Eliquis VTEP','Eliquis VTEP','pptTable','D','Series||X','1','3')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R660','R661','Eliquis VTEP','Eliquis VTEP','chart1_colums','Y','Series||','1','2')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R660','R662','Eliquis VTEP','Eliquis VTEP','chart2_colums','Y','Series||','1','2')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R660','R663','Eliquis VTEP','Eliquis VTEP','chart3_colums','Y','Series||','1','2')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R660','R664','Eliquis VTEP','Eliquis VTEP','chart4_colums','Y','Series||','1','2')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R660','R665','Eliquis VTEP','Eliquis VTEP','chart5_colums','Y','Series||','1','2')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R660','R666','Eliquis VTEP','Eliquis VTEP','chart6_colums','Y','Series||','1','2')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R660','R667','Eliquis VTEP','Eliquis VTEP','chart7_colums','Y','Series||','1','2')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R660','R668','Eliquis VTEP','Eliquis VTEP','chart8_colums','Y','Series||','1','2')


insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R670','R670','Eliquis VTEP','Eliquis VTEP','chart','Y','Series||X','1','1')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R670','R670','Eliquis VTEP','Eliquis VTEP','sheet','L','Series||X','1','1')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R680','R680','Eliquis VTEP','Eliquis VTEP','chart','Y','Series||X','1','1')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R680','R680','Eliquis VTEP','Eliquis VTEP','sheet','L','Series||X','1','1')

insert into tblPPTGraphDef (Code,LinkChartCode,Product,LinkchartProduct,GraphType,Active,Axis,StartCols,StartRows)
values ('R710','R710','Monopril','Monopril','chart','Y','Series||X','1','1')

-- New 15 slides for Brand reports

print '-- C130'
insert into tblPPTGraphDef
select distinct 'C130','C130',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='C130'
go
print '-- C130'
insert into tblPPTGraphDef
select distinct 'C130','C131',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='C131'
go
print '-- C140'
insert into tblPPTGraphDef
select distinct 'C140','C140',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='C140'
go
insert into tblPPTGraphDef
select distinct 'C140','C140',product,product,'Sheet','L','Series||','1','1'	
from tblChartTitle where linkchartcode='C140'
go
insert into tblPPTGraphDef
select distinct 'C140','C141',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='C141'
go
insert into tblPPTGraphDef
select distinct 'C140','C141',product,product,'Sheet','L','Series||','1','1'	
from tblChartTitle where linkchartcode='C141'
go
print '-- c170'
insert into tblPPTGraphDef
select distinct 'c170','c170',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='c170'
go
insert into tblPPTGraphDef
select distinct 'c170','c170',product,product,'Sheet','L','Series||','1','1'	
from tblChartTitle where linkchartcode='c170'
go
print '-- C900'
insert into tblPPTGraphDef
select distinct 'C900','C900',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='C900'
go
insert into tblPPTGraphDef
select distinct 'C900','C900',product,product,'Sheet','L','Series||','1','1'	
from tblChartTitle where linkchartcode='C900'

print '-- C200'
insert into tblPPTGraphDef
select distinct 'C200','C201',product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='C201' and Product in('Sprycel')
go
insert into tblPPTGraphDef
select distinct 'C200','C202',product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='C202' and Product in('Sprycel')
go


print '-- C210'
insert into tblPPTGraphDef
select distinct 'C210','C210',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='C210' and Product in('Sprycel')
go
insert into tblPPTGraphDef
select distinct 'C210','C210',product,product,'Sheet','d','Series||','1','1'	
from tblChartTitle where linkchartcode='C210' and Product in('Sprycel')
go

print '-- C220'
insert into tblPPTGraphDef
select distinct 'C220','C220',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='C220' and Product in('Sprycel')
go

print '-- R400'
insert into tblPPTGraphDef
select distinct 'R400','R401',product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R401' and Product in('Baraclude','Taxol','Paraplatin')
go
insert into tblPPTGraphDef
select distinct 'R400','R401',product,product,'Sheet1','N','Series||X','1','1'	
from tblChartTitle where linkchartcode='R401' and Product in('Baraclude','Taxol','Paraplatin')
go
insert into tblPPTGraphDef
select distinct 'R400','R402',product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R402' and Product in('Baraclude','Taxol','Paraplatin')
go
insert into tblPPTGraphDef
select distinct 'R400','R402',product,product,'Sheet2','N','Series||X','1','1'	
from tblChartTitle where linkchartcode='R402' and Product in('Baraclude','Taxol','Paraplatin')
go


print '-- R410'
insert into tblPPTGraphDef
select distinct 'R410','R411',product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R411' and Product in('Baraclude','Taxol','Paraplatin')
go

insert into tblPPTGraphDef
select distinct 'R410','R411',product,product,'Sheet','N','Series||X','1','1'	
from tblChartTitle where linkchartcode='R411' and Product in('Baraclude','Taxol','Paraplatin')
go
insert into tblPPTGraphDef
select distinct 'R410','R412',product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R412' and Product in('Baraclude','Taxol','Paraplatin')
go


print '-- R420'
insert into tblPPTGraphDef
select distinct 'R420','R420',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R420'
go
insert into tblPPTGraphDef
select distinct 'R420','R420',product,product,'Sheet','N','Series||X','1','1'	
from tblChartTitle where linkchartcode='R420' 
go

print '-- R430'
insert into tblPPTGraphDef
select distinct 'R430','R430',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R430'
go
insert into tblPPTGraphDef
select distinct 'R430','R430',product,product,'Sheet','N','Series||X','1','1'	
from tblChartTitle where linkchartcode='R430' 
go

print '-- R440'
insert into tblPPTGraphDef
select distinct 'R440','R440',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R440'
go

print '-- R450'
insert into tblPPTGraphDef
select distinct 'R451','R451',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R451' 
go
insert into tblPPTGraphDef
select distinct 'R451','R451',product,product,'Sheet','N','Series||X','1','1'	
from tblChartTitle where linkchartcode='R451' 
go

insert into tblPPTGraphDef
select distinct 'R452','R452',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R452'
go
insert into tblPPTGraphDef
select distinct 'R452','R452',product,product,'Sheet','N','Series||X','1','1'	
from tblChartTitle where linkchartcode='R452'
go


print '-- R460'
insert into tblPPTGraphDef
select distinct 'R460','R460',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R460'
go

print '-- R470'
insert into tblPPTGraphDef
select distinct 'R471','R471',product,product,'SpecialTable','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R471' 
go
insert into tblPPTGraphDef
select distinct 'R472','R472',product,product,'SpecialTable','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R472'
go


print '-- R480'
insert into tblPPTGraphDef
select distinct 'R480','R480',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R480'
go


print '-- R490'
insert into tblPPTGraphDef
select distinct 'R491','R491',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R491' 
go
insert into tblPPTGraphDef
select distinct 'R492','R492',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R492'
go

-- todo there is no code for R501 & R502
print '-- R500'
insert into tblPPTGraphDef
select distinct 'R500','R501',product,product,'Chart1','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R501'
go
insert into tblPPTGraphDef
select distinct 'R500','R502',product,product,'Chart2','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R502'
go

print '-- R510'
insert into tblPPTGraphDef
select distinct 'R511','R511',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R511'
go
insert into tblPPTGraphDef
select distinct 'R511','R511',product,product,'Sheet','N','Series||','1','1'	
from tblChartTitle where linkchartcode='R511'
go
insert into tblPPTGraphDef
select distinct 'R512','R512',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R512'
go
insert into tblPPTGraphDef
select distinct 'R512','R512',product,product,'Sheet','N','Series||','1','1'	
from tblChartTitle where linkchartcode='R512'
go




print '-- C150'
delete from tblPPTGraphDef where Code='C150'

insert into tblPPTGraphDef
select distinct 'C150','C150',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='C150'
union all
select distinct 'C150','C150',product,product,'Sheet','D','Series||X','1','1'	
from tblChartTitle where linkchartcode='C150'
go

print '-- C160'--泡泡图
insert into tblPPTGraphDef
select distinct 'C160','C160',product,product,'bubble','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='C160'

print '-- R010'
insert into tblPPTGraphDef
select distinct 'R010','R010',product,product,'Chart','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R010'

print '-- R520'--泡泡图
insert into tblPPTGraphDef
select distinct 'R520','R520',product,product,'bubble','Y','Series||X','1','1'	
from tblChartTitle where linkchartcode='R520'

print '-- R530'
insert into tblPPTGraphDef
select distinct 'R531','R531',product,product,'SpecialTable','Y','Series','2','3'	
from tblChartTitle where linkchartcode='R531' 

insert into tblPPTGraphDef
select distinct 'R532','R532',product,product,'SpecialTable','Y','Series','2','3'	
from tblChartTitle where linkchartcode='R532'

insert into tblPPTGraphDef
select distinct 'R533','R533',product,product,'SpecialTable','Y','Series','2','3'	
from tblChartTitle where linkchartcode='R533'

insert into tblPPTGraphDef
select distinct 'R534','R534',product,product,'SpecialTable','Y','Series','2','3'	
from tblChartTitle where linkchartcode='R534'
go

insert into tblPPTGraphDef
select distinct 'R535','R535',product,product,'SpecialTable','Y','Series','2','3'	
from tblChartTitle where linkchartcode='R535'
go


insert into tblPPTGraphDef(code,LinkChartCode,product,LinkChartProduct,GraphType,Active,Axis,StartCols,StartRows)
select code,LinkChartCode,'Coniel','Coniel',GraphType,Active,Axis,StartCols,StartRows 
from  tblPPTGraphDef where product='Monopril'














----------------------------------------------------------------------数据检查：

select N'Compare the # with previous months 与上期比较：'
select count(*) from tblPPTGraphDef
select count(*) from tblPPTGraphDef_201611
go


select N'Compare the #  of Portfolio with previous months 与上期比较：'
select count(*) from tblPPTGraphDef where code like 'c%'
select count(*) from tblPPTGraphDef_201611 where code like 'c%'
go

select N'Compare the #  of dashboard with previous months 与上期比较：'
select count(*) from tblPPTGraphDef where code like 'd%'
select count(*) from tblPPTGraphDef_201611 where code like 'd%'
go

select N'Compare the #  of Brand Report with previous months 与上期比较：'
select count(*) from tblPPTGraphDef where code like 'r%'
select count(*) from tblPPTGraphDef_201611 where code like 'r%'
go

select * from tblPPTGraphDef_201611 a
where not exists(
	select * from tblPPTGraphDef b
	where a.code = b.code and a.linkchartcode = b.linkchartcode and a.graphtype = b.graphtype
)
go

select * from tblPPTGraphDef_201611 a
where not exists(select * from tblPPTGraphDef b where a.code = b.code and a.product = b.product)
go

select distinct Code, LinkChartCode, Product, LinkChartProduct, GraphType, Active, Axis, StartCols, StartRows 
from tblPPTGraphDef_201611

if object_id(N'tblPPTGraphDef_temp',N'U') is not null
  drop table tblPPTGraphDef_temp
go

select distinct Code, LinkChartCode, Product, LinkChartProduct, GraphType, Active, Axis, StartCols, StartRows 
into tblPPTGraphDef_temp
from tblPPTGraphDef

TRUNCATE TABLE tblPPTGraphDef

insert into tblPPTGraphDef(Code, LinkChartCode, Product, LinkChartProduct, GraphType, Active, Axis, StartCols, StartRows)
select Code, LinkChartCode, Product, LinkChartProduct, GraphType, Active, Axis, StartCols, StartRows
from tblPPTGraphDef_temp




print 'over!'