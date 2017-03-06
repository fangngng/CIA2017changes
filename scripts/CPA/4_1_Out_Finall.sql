/* 这个脚本对于数据在Web或者PPT中显示，进行了一些必要的格式化（设置颜色等）*/

use BMSChinaMRBI --DB4
go


--Time:00:03




--log
exec dbo.sp_Log_Event 'output','CIA_CPA','4_1_Out_Finall.sql','Start',null,null
go


PRINT ('--------------------------
            tblTimeFrame
---------------------------------')
-- todo : Added the value into tblTimeFrame when new time frame available
update tblTimeFrame set TFValue = 'MAT ' + (select Replace(right(convert(varchar(11),convert(datetime, Value2,112),6),6),' ','''') from tblDSDates where Item = 'CPA')
where DataSource = 'CPA' and TimeFrame = 'MAT'
go
update tblTimeFrame set TFValue = 'MAT Month ' + (select Replace(right(convert(varchar(11),convert(datetime, Value2,112),6),6),' ','''') from tblDSDates where Item = 'CPA')
where DataSource = 'CPA' and TimeFrame = 'MAT Month'
go
update tblTimeFrame set TFValue = 'MQT ' + (select Replace(right(convert(varchar(11),convert(datetime, Value2,112),6),6),' ','''') from tblDSDates where Item = 'CPA')
where DataSource = 'CPA' and TimeFrame = 'MQT'
go
update tblTimeFrame set TFValue = 'MAT Quarter ' + (select Replace(right(convert(varchar(11),convert(datetime, Value2,112),6),6),' ','''') from tblDSDates where Item = 'CPA')
where DataSource = 'CPA' and TimeFrame = 'MAT Quarter'
go


PRINT (N'-------------------------
 OutputHospital : 数据刷选
---------------------------------')
truncate table OutputHospital
go
insert into OutputHospital(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters, Color, R, G, B, IsShow,AddY)
select 
    LinkChartCode
  , LinkSeriesCode
  , Series
  , SeriesIdx
  , Category
  , Product
  , Lev
  , ParentGeo
  , Geo
  , Currency
  , TimeFrame
  , X
  , XIdx
  , Y
  , LinkedY
  , Size
  , OtherParameters
  , Color
  , R
  , G
  , B
  , IsShow
  , AddY
from OutputHospital_All
where Product in('Sprycel','Taxol','Glucophage','Monopril','Coniel','Eliquis NOAC','Eliquis VTEP') and LinkChartCode like 'D%'
go
insert into OutputHospital(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters, Color, R, G, B, IsShow,AddY)
select 
    LinkChartCode
  , LinkSeriesCode
  , Series
  , SeriesIdx
  , Category
  , Product
  , Lev
  , ParentGeo
  , Geo
  , Currency
  , TimeFrame
  , X
  , XIdx
  , Y
  , LinkedY
  , Size
  , OtherParameters
  , Color
  , R
  , G
  , B
  , IsShow
  , AddY
from OutputHospital_All
where Product in('Sprycel','Taxol','Glucophage','Monopril','Coniel','Eliquis NOAC','Eliquis VTEP') and TimeFrame <> 'YTD' and LinkChartCode not like 'D%'

--------------------------------
--	CIA-CV Modification: Slide8 Xiaoyu.Chen 20130905
--------------------------------
insert into OutputHospital(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters, Color, R, G, B, IsShow,AddY)
select 
    LinkChartCode
  , LinkSeriesCode
  , Series
  , SeriesIdx
  , Category
  , Product
  , Lev
  , ParentGeo
  , Geo
  , Currency
  , TimeFrame
  , X
  , XIdx
  , Y
  , LinkedY
  , Size
  , OtherParameters
  , Color
  , R
  , G
  , B
  , IsShow
  , AddY
from OutputHospital_All where LinkchartCode = 'R640' and Product in ('Monopril','Coniel','Eliquis VTEP')



go
insert into OutputHospital(LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters, Color, R, G, B, IsShow,AddY)
select 
    LinkChartCode
  , LinkSeriesCode
  , Series
  , SeriesIdx
  , Category
  , Product
  , Lev
  , ParentGeo
  , Geo
  , Currency
  , TimeFrame
  , X
  , XIdx
  , Y
  , LinkedY
  , Size
  , OtherParameters
  , Color
  , R
  , G
  , B
  , IsShow
  , AddY
from OutputHospital_All
where Product = 'Baraclude'
go
insert into OutputHospital (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters, Color, R, G, B, IsShow,AddY)
select 
    LinkChartCode
  , LinkSeriesCode
  , Series
  , SeriesIdx
  , Category
  , Product
  , Lev
  , ParentGeo
  , Geo
  , Currency
  , TimeFrame
  , X
  , XIdx
  , Y
  , LinkedY
  , Size
  , OtherParameters
  , Color
  , R
  , G
  , B
  , IsShow
  , AddY
from OutputHospital_Onglyza
where Product = 'Onglyza' and TimeFrame <> 'YTD' 
go


insert into OutputHospital (LinkChartCode, LinkSeriesCode, Series, SeriesIdx, Category, Product, Lev, ParentGeo, Geo, Currency, TimeFrame, X, XIdx, Y, LinkedY, Size, OtherParameters, Color, R, G, B, IsShow,AddY)
select 
    LinkChartCode
  , LinkSeriesCode
  , Series
  , SeriesIdx
  , Category
  , Product
  , Lev
  , ParentGeo
  , Geo
  , Currency
  , TimeFrame
  , X
  , XIdx
  , Y
  , LinkedY
  , Size
  , OtherParameters
  , Color
  , R
  , G
  , B
  , IsShow
  , AddY
from OutputHospital_All
where Product = 'Paraplatin'
go





select 'Records with IsShow=''Y''',count(*) from OutputHospital where isshow = 'y'
select 'Records with IsShow=''Y'' and colored''',count(*) from OutputHospital  where isshow = 'y' and color is not null
go

--log
exec dbo.sp_Log_Event 'output','CIA_CPA','4_1_Out_Finall.sql','End',null,null
go



print 'over!'
