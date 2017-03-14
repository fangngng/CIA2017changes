use BMSChina_ppt_test
go






update tblChartTitle set 
ParentGeo=Geo
where Geo='China'


update tblChartTitle  set ParentCode=LinkChartCode
where LinkChartCode like  'R53%'
update tblChartTitle set 
[Templatename] = [ParentCode]+'_'+product+'.pptx',
[Outputname] = [ParentCode]+'_'+product+'_'+ParentGeo+'_'+Geo+'_'+currency+'_'+timeframe+'_'+category+'.pptx'
where LinkChartCode like  'R53%'
go

update tblChartTitle set 
Caption=replace(Caption,'Taxol','Platinum')
where LinkChartCode like  'R53%' and Product='Paraplatin'


update tblChartTitle set Caption='Total Onco Market Trend'
where LinkChartCode='R010'
update tblChartTitle set SYAxisName=null
where LinkChartCode='R010'

update tblChartTitle set Caption='Top companies in China Onco Market (MNC + Local)'
where LinkChartCode='R520'
update tblChartTitle set SYAxisName=null
where LinkChartCode='R520'


update tblChartTitle set PYAxisName='Market Share%'
where linkchartcode like 'C15%'

update tblChartTitle set 
[Templatename] = 'C660_Eliquis.pptx'
where LinkChartCode in('C660','C661')

update tblChartTitle set 
[Templatename] = 'C690_Eliquis.pptx'
where LinkChartCode in('C690','C691')

print 'over!'