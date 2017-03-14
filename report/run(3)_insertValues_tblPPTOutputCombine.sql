use BMSChina_ppt_test
GO
set nocount on

-- todo  lastMonth : 201611









------------------------------------------------------------------------------------
--                        tblPPTOutputCombine 
------------------------------------------------------------------------------------

--backup
if object_id(N'tblPPTOutputCombine_201611',N'U') is null
   select * into tblPPTOutputCombine_201611 from tblPPTOutputCombine 
go


--refash
if exists (select * from dbo.sysobjects where id=object_id(N'[tblPPTOutputCombine]') and objectproperty(id,N'Isusertable')=1)
drop table [tblPPTOutputCombine]
go
CREATE TABLE [dbo].[tblPPTOutputCombine](
	[Product] [varchar](300) NULL,
	[ParentGeo] [varchar](300) NULL,
	[Geo] [varchar](300) NULL,
	[SlideCategory] [varchar](3000) NULL,
	[ChartTitle] [varchar](3000) NULL,
	[SubChartTitle] [varchar](300) NULL,
	[Outputname] [varchar](8000)  NULL,
	[Lev] varchar(10) null
) ON [PRIMARY]
GO


--select * from tblChartTitle where linkchartcode in ('C120','C130','C140')
--select * from outputgeo where geo = 'china'


insert into tblPPTOutputCombine
select distinct  product,ParentGeo,geo,product+'_D',caption,slidetitle,outputname,'' 
from tblChartTitle  A
where exists (select * from outputgeo B
where a.geo=b.geo and (a.product=b.product or left(a.product,7)=b.product)) and  linkchartcode like'd%'
order by product,ParentGeo,geo,outputname 
go

insert into tblPPTOutputCombine
select distinct  product,ParentGeo,geo,product+'_D',caption,slidetitle,outputname,'' 
from tblChartTitle  A
where  linkchartcode like'c%'
order by product,ParentGeo,geo,outputname 
go

insert into tblPPTOutputCombine
select distinct  product,ParentGeo,geo,product+'_R',caption,slidetitle,outputname,''
from tblChartTitle  A
where  linkchartcode like'R%'
	and product <> 'sprycel'
order by product,ParentGeo,geo,outputname 
go

update tblPPTOutputCombine set lev=
	case b.lev 
	when '0' then 'Portfolio' 
	when '1' then 'Region' 
	when '2' then 'City' end 
from tblPPTOutputCombine A 
inner join OutputGeo B
	on a.product=b.product and a.geo=b.geo
go
update tblPPTOutputCombine set lev=
	case b.lev 
	when '0' then 'Portfolio' 
	when '1' then 'Region' 
	when '2' then 'City' end 
from tblPPTOutputCombine A 
inner join OutputGeo B
	on (a.product=b.product or left(a.product,7)=b.product) and a.geo=b.geo
	
update tblPPTOutputCombine set lev='Portfolio'
where product='Portfolio'
go
update tblPPTOutputCombine set lev='Predefined'
where [SlideCategory] like '%R'
go
update tblPPTOutputCombine set Lev = 'Nation'
where geo = 'china' and lev = ''
go

delete tblPPTOutputCombine
where OutputName like 'R500%Unit%'
	or outputName like 'R410%Unit%'
	or outputName like 'R400%Unit%'
go

alter table tblPPTOutputCombine add 
	SectionID int null,
	[ShoppingCardID] INT null,
	[SlideRank] INT null,
	[OutputName4Rank] varchar(800)
go

update tblPPTOutputCombine set SectionID = null
go

update  tblPPTOutputCombine set SectionID = b.ID
from tblPPTOutputCombine a
inner join tblPPTSection b on left(a.OutputName,4) = b.Code and a.Product = b.Product
where b.Product = 'Portfolio'
GO

update  tblPPTOutputCombine set SectionID = b.ID
from tblPPTOutputCombine a
inner join tblPPTSection b on left(a.OutputName,4) = b.Code and a.Product = b.Product
where LEFT(a.Outputname,1) = 'R'
GO

update  tblPPTOutputCombine set SectionID = b.ID
from tblPPTOutputCombine a
inner join tblPPTSection b on left(a.OutputName,4) = b.Code and a.Product = b.Product
where LEFT(a.Outputname,1) = 'S'
GO

update  tblPPTOutputCombine set SectionID = b.ID
from tblPPTOutputCombine a
inner join tblPPTSection b on left(a.OutputName,4) = b.Code and a.Product = b.Product
where LEFT(a.Outputname,1) <> 'R' and b.Product <> 'Portfolio'
GO

update tblPPTOutputCombine set OutputName4Rank = 
	case 
		when OutputName like 'D030%' then replace(OutputName, 'D030','D020')
		when OutputName like 'D020%' then replace(OutputName, 'D020','D030')

		when OutputName like 'D090%' then replace(OutputName, 'D090','D080')
		when OutputName like 'D080%' then replace(OutputName, 'D080','D090')

		when SlideCategory<> 'Glucophage_R' and OutputName like 'R050%'  then replace(OutputName, 'R050','R060')
		when SlideCategory<> 'Glucophage_R' and OutputName like 'R060%'  then replace(OutputName, 'R060','R050')

		when SlideCategory = 'Glucophage_R' and OutputName like 'R050%'  then replace(OutputName, 'R050','R070')
		when SlideCategory = 'Glucophage_R' and OutputName like 'R070%'  then replace(OutputName, 'R070','R050')

		when OutputName like 'R200%' then replace(OutputName,'R200','R001')
		when OutputName like 'R190%' then replace(OutputName,'R190','R002')
		when OutputName like 'R910%' then replace(OutputName,'R910','R003')
		when OutputName like 'R210%' then replace(OutputName,'R210','R004')
		when OutputName like 'R920%' then replace(OutputName,'R920','R005')
		when OutputName like 'R220%' then replace(OutputName,'R220','R006')
		when OutputName like 'R230%' then replace(OutputName,'R230','R007')
		when OutputName like 'R930%' then replace(OutputName,'R930','R008')

		
		when OutputName like 'R260%' then replace(OutputName,'R200','R011')
		when OutputName like 'R250%' then replace(OutputName,'R200','R012')
		when OutputName like 'R970%' then replace(OutputName,'R200','R013')
		when OutputName like 'R270%' then replace(OutputName,'R200','R014')
		when OutputName like 'R980%' then replace(OutputName,'R200','R015')
		when OutputName like 'R280%' then replace(OutputName,'R200','R016')
		when OutputName like 'R290%' then replace(OutputName,'R200','R017')
		when OutputName like 'R990%' then replace(OutputName,'R200','R018')

		else outputname 
	end 
go

update tblPPTOutputCombine set OutputName4Rank = 
	case 
		when OutputName4Rank like '%_UNIT_%' then replace(OutputName4Rank,'_UNIT_','_USD_')
		when OutputName4Rank like '%_USD_%' then replace(OutputName4Rank,'_USD_','_UNIT_')
		else OutputName4Rank
	end
go

update tblPPTOutputCombine set OutputName4Rank = Replace(OutputName4Rank,'Dosing Units','Units')
-- select * from tblPPTOutputCombine
where OutputName4Rank like '%Dosing Units%'
go



-- Update SlideRank
if exists(select * from dbo.sysobjects where id=object_id(N'TempRank')and objectproperty(id,N'isusertable')=1)
drop table TempRank
go
select SlideCategory,product,ParentGeo,geo,outputname, rank() over(
		partition by SlideCategory,product,ParentGeo,geo
		order by SectionID,OutputName4Rank asc
	) as [SlideRank]
into TempRank
from tblPPTOutputCombine
go

update tblPPTOutputCombine set [SlideRank]=b.[SlideRank]
from tblPPTOutputCombine A 
inner join TempRank B
	on a.SlideCategory=b.SlideCategory 
	and a.product=b.product 
	and a.parentgeo=b.parentgeo 
	and a.geo=b.geo 
	and a.outputname=b.outputname
go

-- Update ShoppingCardID
if exists(select * from dbo.sysobjects where id=object_id(N'TempRank')and objectproperty(id,N'isusertable')=1)
drop table TempRank
go
select outputname,subcharttitle,rank() over(
		order by 
		SectionID,OutputName4Rank asc
		,subcharttitle asc

) as [SlideRank]
into TempRank
from tblPPTOutputCombine
go

update tblPPTOutputCombine set [ShoppingCardID]=b.[SlideRank]
from tblPPTOutputCombine A 
inner join TempRank B
	on  a.outputname=b.outputname 
	and isnull(a.subcharttitle,'')=isnull(b.subcharttitle,'')
go


update tblPPTOutputCombine
set Geo='China'
where product in ('Monopril','Coniel') and outputname like 'r710%'

drop table TempRank
go




------------------------------------------------------------------------------------
-- check 
------------------------------------------------------------------------------------

--������
declare @currNum int , @lastNum int , @diffNum int 
select @currNum = count(1) from tblPPTOutputCombine 
select @lastNum = count(1) from tblPPTOutputCombine_201611
set @diffNum = @currNum - @lastNum 
if (@diffNum < 0 )
begin 
	print N'����������PPT�������ϴ��٣�   '+ convert(nvarchar,abs(@diffNum)) + N'    �ţ�'
end 
if (@diffNum > 300 )
begin 
	print N'����������PPT���������ˣ�   '+ convert(nvarchar,abs(@diffNum)) + N'    �ţ�'
end 
GO

--LEV
if exists (select * from dbo.sysobjects where id=object_id(N'temp_test_tblPPTOutputCombine') and objectproperty(id,N'Isusertable')=1)
drop table temp_test_tblPPTOutputCombine
GO
select distinct 
  case left(OutputName,1) when 'R' then 'BrandReport' else 'Dashboard' end as Page,product,lev,parentgeo,geo 
into temp_test_tblPPTOutputCombine 
from tblPPTOutputCombine 
where lev<>''
GO

declare @levNum int 
select @levNum = count(1) from temp_test_tblPPTOutputCombine where geo = 'China' 
if (@levNum <> 12 )
begin 
	print N'��ע�⣬China������PPT���� 12 �ţ� ����Ϊ��' + convert(nvarchar,abs(@levNum))
end 


--select [Page],lev,Product,count(geo) as geo_num from temp_test_tblPPTOutputCombine  
--where geo <> 'China' 
--group by [Page],lev,Product
--order by [Page],lev,Product



select @levNum = count(1) from temp_test_tblPPTOutputCombine  where geo <> 'China' and lev ='City' and Product = 'Baraclude'
if (@levNum <> 49 )
begin 
	print N'��ע�⣬ Baraclude ��Ʒ��city���� 49 �� ����Ϊ��' + convert(nvarchar,abs(@levNum))
end

select @levNum = count(1) from temp_test_tblPPTOutputCombine  where geo <> 'China' and lev ='City' and Product = 'Glucophage'
if (@levNum <> 49 )
begin 
	print N'��ע�⣬ Glucophage ��Ʒ��city���� 49 �� ����Ϊ��' + convert(nvarchar,abs(@levNum))
end

select @levNum = count(1) from temp_test_tblPPTOutputCombine  where geo <> 'China' and lev ='City' and Product = 'Monopril'
if (@levNum <> 48 )
begin 
	print N'��ע�⣬ Monopril ��Ʒ��city���� 48 �� ����Ϊ��' + convert(nvarchar,abs(@levNum))
end

select @levNum = count(1) from temp_test_tblPPTOutputCombine  where geo <> 'China' and lev ='City' and Product = 'Onglyza'
if (@levNum <> 49 )
begin 
	print N'��ע�⣬ Onglyza ��Ʒ��city���� 49 �� ����Ϊ��' + convert(nvarchar,abs(@levNum))
end

select @levNum = count(1) from temp_test_tblPPTOutputCombine  where geo <> 'China' and lev ='City' and Product = 'Taxol'
if (@levNum <> 49 )
begin 
	print N'��ע�⣬ Taxol ��Ʒ��city���� 49 �� ����Ϊ��' + convert(nvarchar,abs(@levNum))
end

--

select @levNum = count(1) from temp_test_tblPPTOutputCombine  where geo <> 'China' and lev ='Region' and Product = 'Baraclude'
if (@levNum <> 13 )
begin 
	print N'��ע�⣬ Baraclude ��Ʒ��Region���� 13 �� ����Ϊ��' + convert(nvarchar,abs(@levNum))
end

select @levNum = count(1) from temp_test_tblPPTOutputCombine  where geo <> 'China' and lev ='Region' and Product = 'Glucophage'
if (@levNum <> 7 )
begin 
	print N'��ע�⣬ Glucophage ��Ʒ��Region���� 7 �� ����Ϊ��' + convert(nvarchar,abs(@levNum))
end

select @levNum = count(1) from temp_test_tblPPTOutputCombine  where geo <> 'China' and lev ='Region' and Product = 'Monopril'
if (@levNum <> 4 )
begin 
	print N'��ע�⣬ Monopril ��Ʒ��Region���� 4 �� ����Ϊ��' + convert(nvarchar,abs(@levNum))
end

select @levNum = count(1) from temp_test_tblPPTOutputCombine  where geo <> 'China' and lev ='Region' and Product = 'Onglyza'
if (@levNum <> 7 )
begin 
	print N'��ע�⣬ Onglyza ��Ʒ��Region���� 7 �� ����Ϊ��' + convert(nvarchar,abs(@levNum))
end

select @levNum = count(1) from temp_test_tblPPTOutputCombine  where geo <> 'China' and lev ='Region' and Product = 'Taxol'
if (@levNum <> 5 )
begin 
	print N'��ע�⣬ Onglyza ��Ʒ��Region���� 5 �� ����Ϊ��' + convert(nvarchar,abs(@levNum))
end

--
declare @currNum int , @lastNum int , @diffNum int 

select @currNum = count(1) from (
select distinct LinkChartCode,Product from output_PPT --389
) a

select @lastNum = count(1) from (
select distinct LinkChartCode,Product from BMSChina_bk.dbo.Output_PPT_201611--389 --todo
) a

set @diffNum = @currNum - @lastNum 
if (@diffNum <> 0 )
begin 
	
print N'��������Ʒcode��������,����������' + convert(nvarchar,abs(@diffNum))

print N'�鿴 ���α��ϴ� ���ģ���ִ������sql: ' + '
select distinct LinkChartCode,Product from output_PPT 
except
select distinct LinkChartCode,Product from BMSChina_bk.dbo.Output_PPT_201611
'

print N'�鿴 ���α��ϴ� �ٵģ�����ִ������sql: ' + '
select distinct LinkChartCode,Product from BMSChina_bk.dbo.Output_PPT_201611
except
select distinct LinkChartCode,Product from output_PPT 
'
end


set nocount off
GO






















------------------------------------------------------------------------------------
--                        tblSlide                                       
------------------------------------------------------------------------------------
use BMSChina_staging_test
go

--backup
if object_id(N'BMSChina_bk.dbo.tblSlide_201611',N'U') is null
	select * into BMSChina_bk.dbo.tblSlide_201611 from tblSlide
go



truncate table tblSlide
go
-- todo
select '201611, Max ID', max(id) from BMSChina_bk.dbo.tblSlide_201611
go 
-- 201208: max_id = 7511
-- 201207: max_id = 7502
-- 201206: max_id = 7488
-- 201204: max_id = 7461
-- 201203: max_id = 7061
-- 201202: Max_id = 4604
-- 201201: Max_id = 2699

insert into tblSlide(slidename,slidecode,title,subtitle,sequence,status,prodid,categoryid)
select 
  outputname          --slidename 
  ,SlideCategory      --slidecode 
  ,charttitle         --title     
  ,subcharttitle      --SubTitle  
  ,[ShoppingCardID]   --sequence  
  ,'Y'                --status    
  ,1                  --prodid    
  ,1                  --categoryid
from BMSChina_ppt_test.dbo.tblPPTOutputCombine
where [ShoppingCardID] is not null 
go

update tblSlide set id = b.id
from tblSlide a
inner join BMSChina_bk.dbo.tblSlide_201611 b -- todo
	on a.SlideName=b.SlideName
go
-- 
declare @id int
select @id=max(id) from BMSChina_bk.dbo.tblSlide_201611-- todo


update tblSlide set id = b.rank+@id
from tblSlide a
inner join (
	select slidename,rank() over(order by sequence) rank
	from tblSlide
	where id is null
) b on a.SlideName=b.SlideName
where a.Id is null
go

select 'Current Month Max ID:', max(id) from tblSlide
go

update tblSlide set ProdID = b.ProdID
from tblSlide a
inner join (
	select a.Code as Page, b.Code as Product, b.id as ProdID
	from (
		select * from WebPage where Lev = 1
	) a inner join (
		select * from webPage where Lev = 2
	) b on b.ParentID = a.ID
) b on b.Page = case left(SlideName,1) when 'R' then 'BrandReport' else 'Dashboard' end
	and b.Product = left(SlideCode,len(Slidecode)-2)
go

update tblSlide set ProdID = b.ProdID
from tblSlide a
inner join (
	select a.Code as Page, b.Code as Product, b.id as ProdID
	from (
		select * from WebPage where Lev = 1
	) a inner join (
		select * from webPage where Lev = 2
	) b on b.ParentID = a.ID
) b on b.Page = case left(SlideName,1) when 'R' then 'BrandReport' else 'Dashboard' end
	and b.Product = left(left(SlideCode,len(Slidecode)-2),7)
	and b.product='eliquis'

update tblSlide set SlideCode='Eliquis_R' where SlideCode='Eliquis VTEP_R' and slidename like 'R6%'


-- todo
-- make sure the date in BMSChina_ppt_test.dbo.tblDates is correct

select * from BMSChina_ppt_test.dbo.tblDates
go
truncate table tblDates
go
insert into tblDates
select * from BMSChina_ppt_test.dbo.tblDates
go
select * from tblDates
go




print 'over!'



