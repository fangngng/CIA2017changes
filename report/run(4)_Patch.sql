use BMSChina_ppt_test
go







update [Output_PPT] set [Category]='Dosing Units'
where [LinkChartCode] like 'R502' 
and Product='ParaPlatin'

delete  
FROM [BMSChina_ppt_test].[dbo].[Output_PPT] 
where [LinkChartCode] like 'R051'  and Product='ParaPlatin' and Series not in ('PARAPLATIN','Platinum Market')

update output_ppt
set category='Treatment Day'
where product='Glucophage' and category='Dosing Units'  and datasource='IMS' 
and ( 
		LinkchartCode not like 'R%' or 
		left(LinkchartCode,3) in( 'R03','R42','R43','R04','R32','R06','R05','R09','R11','R12','R44',
						'R45','R45','R46','R47','R47','R49','R49','R50','R51','R51'
					)     
)

go
--格华止把Dosing Units更新为Treatment Day
update tblChartTitle
set Category='Treatment Day',
	SubCaption=replace(SubCaption,'Dosing Units','Treatment Day'),
	SlideTitle=replace(SlideTitle,'Dosing Units','Treatment Day'),
	PYAxisName=replace(PYAxisName,'Dosing Units','Treatment Day'),
	SYAxisName=replace(SYAxisName,'Dosing Units','Treatment Day'),
	OutputName=replace(OutputName,'Dosing Units','Treatment Day')
--select * from BMSChina_ppt_test.dbo.tblChartTitle
where product='Glucophage' and category='Dosing Units' 
and ( 
		LinkchartCode not like 'R%' or 
		parentcode in( 'R030','R420','R430','R040','R320','R060','R050','R090','R110','R120','R440',
						'R451','R452','R460','R471','R472','R491','R492','R500','R511','R512'
					)     
)	and datasource='IMS'	

update tblPPTOutputCombine 
set OutputName=replace(OutputName,'Dosing Units','Treatment Day'),
	SubChartTitle=replace(SubChartTitle,'Dosing Units','Treatment Day')
where product='Glucophage' and left(outputname,4) in (
	select distinct parentcode 
	from tblChartTitle where product='Glucophage' and category='Treatment Day'  and datasource='IMS'
)and OutputName like '%Dosing Units%'
			
go
use BMSChina_staging_test
go

update webChartTitle
set Category='Treatment Day',
	SubCaption=replace(SubCaption,'Dosing Units','Treatment Day'),
	SlideTitle=replace(SlideTitle,'Dosing Units','Treatment Day'),
	PYAxisName=replace(PYAxisName,'Dosing Units','Treatment Day'),
	SYAxisName=replace(SYAxisName,'Dosing Units','Treatment Day'),
	OutputName=replace(OutputName,'Dosing Units','Treatment Day'),
	yaxisname=replace(yaxisname,'Dosing Units','Treatment Day'),
	Caption=replace(Caption,'Dosing Units','Treatment Day')
	--yaxisname
--select * from webChartTitle
where product='Glucophage' and category='Dosing Units'  and datasource='IMS' 
and ( 
		LinkchartCode not like 'R%' or 
		left(LinkchartCode,3) in( 'R03','R42','R43','R04','R32','R06','R05','R09','R11','R12','R44',
						'R45','R45','R46','R47','R47','R49','R49','R50','R51','R51'
					)     
)

update output
set category='Treatment Day'
where product='Glucophage' and category='Dosing Units'  and datasource='IMS' 
and ( 
		LinkchartCode not like 'R%' or 
		left(LinkchartCode,3) in( 'R03','R42','R43','R04','R32','R06','R05','R09','R11','R12','R44',
						'R45','R45','R46','R47','R47','R49','R49','R50','R51','R51'
					)     
)

update tblSlide
set SlideName=replace(SlideName,'Dosing Units','Treatment Day'),
	SubTitle=replace(SubTitle,'Dosing Units','Treatment Day')
where SlideCode like 'Glucophage%' and left(SlideName,4) in (
	select distinct parentcode 
	from BMSChina_ppt_test.dbo.tblChartTitle where product='Glucophage' and category='Treatment Day'  and datasource='IMS'
)and SlideName like '%Dosing Units%'

use BMSChina_ppt_test
update tblPPTOutputCombine set product='Eliquis' where slidecategory like 'eliquis%'