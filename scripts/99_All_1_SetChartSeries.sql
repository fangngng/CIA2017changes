use BMSChina_PPT
go











update output_PPT set
	R = b.r,
	B = b.b,
	G = b.G
from Output_PPT a
inner join dbo.tblRGBToColor b on a.color = b.rgb
go

update tblChartTitle set CategoryIdx = 1 where Category='Value' and LinkChartCode in('C202','D130','D110','D111','D150','D050','D051','D060')
go
update tblChartTitle set CategoryIdx = 2 where Category='Dosing Units' and LinkChartCode in('C202','D130','D110','D111','D150','D050','D051','D060')
go
--Paraplatin
update tblChartTitle set CategoryIdx = 3 where Category='Adjusted patient number' and LinkChartCode in ('D050','D051','D110','D111','D130')



update tblChartTitle set product = 
case when product='BARACLUDE' then 'Baraclude'
     when product='GLUCOPHAGE' then 'Glucophage'
     when product='MONOPRIL' then 'Monopril'
     when product='TAXOL' then 'Taxol' 
     else product end 
GO

update tblChartTitle set [ParentCode]=linkchartcode
go

-- select distinct Parentcode from tblChartTitle
update tblChartTitle set Parentcode = left(LinkChartCode,len(LinkChartCode)-1)+'0' 
go
update tblChartTitle set ParentCode = LinkChartCode 
where LinkChartCode in ('R451','R452','R471','R472','R491','R492','R511','R512','R777')
go

update tblChartTitle set 
[Templatename] = [ParentCode]+'_'+product+'.pptx',
[Outputname] = [ParentCode]+'_'+product+'_'+ParentGeo+'_'+Geo+'_'+currency+'_'+timeframe+'_'+category+'.pptx'
go


update tblPPTGraphDef set product = 
case when product='BARACLUDE' then 'Baraclude'
     when product='GLUCOPHAGE' then 'Glucophage'
     when product='MONOPRIL' then 'Monopril'
     when product='TAXOL' then 'Taxol' 
     else product end 
GO



update tblChartTitle
set caption =replace(caption,'Molecule','Molecule:')
where  caption not like '%Molecule:%'
and parentcode in ('d090')
go

update output_ppt
set x=ltrim(rtrim(x))
go

delete tblChartTitle
where LinkChartCode like 'R15%' and Product = 'Glucophage' 
go

update Output_PPT set Lev = 'Nation' where lev = 'China'
go
update Output_PPT set Lev = 'Nation' where lev = 'Nat'
go

update tblChartTitle set Lev = 'Nation' where lev = 'China'
go
update tblChartTitle set Lev = 'Nation' where lev = 'Nat'
go

update tblChartTitle
set parentgeo='China' where product='Sprycel'
go

update tblChartTitle
set [Templatename]=[ParentCode]+'_'+product+'.pptx',
[Outputname]=[ParentCode]+'_'+product+'_'+ParentGeo+'_'+Geo+'_'+currency+'_'+timeframe+'_'+category+'.pptx'
where LinkChartCode ='C202'
go


update tblChartTitle
set SubCaption=replace(SubCaption,'49',B.CityNum)--todo:当Taxol的区域划分有变化时，改动数字
from tblChartTitle A 
inner join (
select ParentGeo,cast(count(distinct Geo) as nvarchar(10))  CityNum
from DB4.BMSChinaCIA_IMS.dbo.outputgeo where lev=2 and Product='taxol'
group by ParentGeo
) B
on A.Geo=B.ParentGeo
where  A.LinkChartCode ='C160'

--Glucophage的slidetitle改动，不显示dosing units
--alince.2015.10.21
update tblChartTitle set slidetitle=replace(slidetitle,'+Dosing Units','')
where product='glucophage' and parentcode='R500' and category='value'



--特殊处理：

update [BMSChina_ppt].[dbo].[Output_PPT]
set Category='Dosing Units'
where [LinkChartCode] in( 'R402' ,'R412')and Product='ParaPlatin'


delete from  [Output_PPT]
where [LinkChartCode] in( 'R402')and Product='ParaPlatin' and TimeFrame='MTH'


--千分位的处理
update output_ppt
set y= CASE WHEN LOG(convert(int,convert(float,replace(y, ',', ''))) )/LOG(10)<3 THEN CONVERT(VARCHAR(9),convert(int,convert(float,replace(y, ',', ''))))
	 WHEN LOG(convert(int,convert(float,replace(y, ',', ''))) )/LOG(10)>=3 AND LOG(convert(int,convert(float,replace(y, ',', ''))) )/LOG(10)<6 THEN SubString(CONVERT(VARCHAR(9),convert(int,convert(float,replace(y, ',', '')))),1,len(CONVERT(VARCHAR(9),convert(int,convert(float,replace(y, ',', '')))))-3)+','+right(CONVERT(VARCHAR(9),convert(int,convert(float,replace(y, ',', '')))),3)
	 WHEN LOG(convert(int,convert(float,replace(y, ',', ''))) )/LOG(10)>=6 AND LOG(convert(int,convert(float,replace(y, ',', ''))) )/LOG(10)<9 THEN SubString(CONVERT(VARCHAR(9),convert(int,convert(float,replace(y, ',', '')))),1,len(CONVERT(VARCHAR(9),convert(int,convert(float,replace(y, ',', '')))))-6)+','+left(right(CONVERT(VARCHAR(9),convert(int,convert(float,replace(y, ',', '')))),6),3)+','+right(CONVERT(VARCHAR(9),convert(int,convert(float,replace(y, ',', '')))),3) end
where Linkchartcode in ('R620','R630','R720','R730') AND X like '% MS Size (K RMB)'


print 'over!'