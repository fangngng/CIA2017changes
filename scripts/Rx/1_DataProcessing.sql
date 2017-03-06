use BMSChinaMRBI
go









if object_id(N'tempRxRollupByDate',N'U') is not null
	drop table tempRxRollupByDate
go

select cast('Nat' as varchar(5)) as Lev, cast('China' as nvarchar(50)) as Geo, b.Product, b.Mkt,b.Prod,a.Department,a.Date,sum(Rx) Rx 
into tempRxRollupByDate
from inRx a
inner join tblMktDefRx b 
on (a.Molecule = b.Mole_Des_CN and a.Product = b.Prod_Des_CN) 
	or (a.Molecule_en=b.Mole_Des_EN and a.Product=b.Prod_Des_CN) --在RX里存在英文名称与表tblMktDefRx英文名称相同的molecule，但是中文名称不同的情况（Eiliquis/NADROPARIN CALCIUM）
group by b.Product, b.Mkt,b.Prod,a.Department,a.Date
go


insert into tempRxRollupByDate
select 'City' as Lev, a.Area as Geo, b.Product, b.Mkt,b.Prod,a.Department,a.Date,sum(Rx) Rx 
from inRx a
inner join tblMktDefRx b 
on (a.Molecule = b.Mole_Des_CN and a.Product = b.Prod_Des_CN) 
	or (a.Molecule_en=b.Mole_Des_EN and a.Product=b.Prod_Des_CN)
group by a.Area, b.Product, b.Mkt,b.Prod,a.Department,a.Date
go


if object_id(N'tempRxRollup',N'U') is not null
	drop table tempRxRollup
go
select distinct Lev,Geo,Product, Mkt,Prod,Department
into tempRxRollup
from tempRxRollupByDate
go

declare @i int,@sql varchar(max)
select @i = count(*) from tblRxHalfYearList
set @sql = 'alter table tempRxRollup add
'
while @i >= 1
begin
	set @sql = @sql + 'H' + cast(@i as varchar) + ' decimal(19,6) not null default 0,
'
	set @i = @i -1
end
set @sql = left(@sql,len(@sql)-3)
-- print @sql
exec(@sql)
go

declare @i int,@H varchar(4),@sql varchar(max)
select @i = count(*) from tblRxHalfYearList
set @sql = ''
while @i >= 1
begin
	select @H= H from tblRxHalfYearList where Idx = @i
	set @sql = @sql + 'update tempRxRollup set H' + cast(@i as varchar) + '= b.Rx
from tempRxRollup a inner join tempRxRollupByDate b on
	a.lev = b.Lev and a.Geo = b.Geo and a.Product = b.Product and a.Mkt = b.Mkt 
	and a.Prod = b.Prod and a.Department = b.Department and b.Date = ''' + @H + '''
'
	set @i = @i -1
end
set @sql = left(@sql,len(@sql)-2)
-- print @sql
exec(@sql)
go

alter table tempRxRollup add H1Rank int
go

update tempRxRollup set H1Rank = b.Rank
from tempRxRollup a
inner join (
	select Lev,Geo,Product,Mkt,Prod,Department,row_number() over(partition by Lev,Geo,Product,Mkt,Prod order by H1 desc) rank 
	from tempRxRollup
) b on a.Lev = b.Lev and a.Geo = b.Geo and a.Product =b.Product and a.Mkt = b.Mkt 
	and a.Prod= b.Prod and a.Department = b.Department
go



if object_id(N'tempOutputRx',N'U') is not null
	drop table tempOutputRx
go


select Lev,Geo,Product, Mkt, Prod, Department,H19,H18,H17,H16,H15,H14,H13,H12,H11,H10,H9, H8, H7, H6, H5, H4, H3, H2, H1, H1Rank -- todo
into tempOutputRx
from tempRxRollup where H1Rank <= 4 and Mkt IN('NIAD','DPP4','ARV','ONCFCS','HYPFCS','HYP','Platinum','Eliquis vtep','CCB') AND PROD = '000'
go

declare @i int, @sql varchar(max)
select @i = count(*) from tblRxHalfYearList
set @sql = 'insert into tempOutputRx
select Lev,Geo,Product,Mkt,Prod,''9999'' as department,
'
while @i >= 1
begin
	set @sql = @sql + 'sum(H' + cast(@i as varchar) + '),'
	set @i = @i -1
end
set @sql = @sql + '99999 as H1Rank
from tempRxRollup 
where H1Rank > 4 and Mkt IN(''NIAD'',''DPP4'',''ARV'',''ONCFCS'',''HYPFCS'',''HYP'',''Platinum'',''Eliquis vtep'',''CCB'') AND PROD = ''000''
group by Lev,Geo,Product,Mkt,Prod'
exec(@sql)
print @sql
go

insert into tempOutputRx
SELECT * FROM tempRxRollup A
WHERE  a.Mkt IN('NIAD','DPP4','ARV','ONCFCS','HYPFCS','HYP','Platinum','Eliquis vtep','CCB') and a.Prod <> '000' and EXISTS(
	SELECT * FROM tempOutputRx B 
    WHERE a.lev = b.Lev and a.Geo = b.Geo and a.Product = b.Product and a.mkt = b.Mkt and a.Department = b.Department
)
go


declare @i int, @sql varchar(max)
select @i = count(*) from tblRxHalfYearList
set @sql = 'insert into tempOutputRx
select Lev,Geo,Product,Mkt,Prod,''9999'' as department,
'
while @i >= 1
begin
	set @sql = @sql + 'sum(H' + cast(@i as varchar) + '),'
	set @i = @i -1
end
set @sql = @sql + '99999 as H1Rank
FROM tempRxRollup A
WHERE  a.Mkt IN(''NIAD'',''DPP4'',''ARV'',''ONCFCS'',''HYPFCS'',''HYP'',''Platinum'',''Eliquis vtep'',''CCB'') and a.Prod <> ''000'' and not EXISTS(
	SELECT * FROM tempOutputRx B WHERE a.Lev = b.Lev and a.Geo = b.Geo and a.Product = b.Product and a.mkt = b.Mkt and a.Department = b.Department
)
group by a.Lev, a.Geo, Product,Mkt,Prod'
print @sql
exec(@sql)
go


declare @i int,@sql varchar(max)
select @i = count(*) from tblRxHalfYearList
set @sql = 'alter table tempOutputRx add
'
while @i >= 1
begin
	set @sql = @sql + 'HS' + cast(@i as varchar) + ' decimal(22,6) not null default 0,
'
	set @i = @i -1
end
set @sql = left(@sql,len(@sql)-3)
-- print @sql
exec(@sql)
go


declare @i int,@sql varchar(max)
select @i = count(*)-1 from tblRxHalfYearList
set @sql = 'alter table tempOutputRx add
'
while @i >= 1
begin
	set @sql = @sql + 'HG' + cast(@i as varchar) + ' decimal(22,6) not null default 0,
'
	set @i = @i -1
end
set @sql = left(@sql,len(@sql)-3)
-- print @sql
exec(@sql)
go

Declare @i int, @sql varchar(max)
select @i = count(*) from tblRxHalfYearList
set @sql = 'update tempOutputRx set
'
while @i >= 1
begin
	set @sql = @sql + 'HS'+cast(@i as varchar) + '=case when b.H' + cast(@i as varchar) + '=0 then 0 else a.H'+cast(@i as varchar) + '/b.H'+cast(@i as varchar) + ' end,
'
	set @i = @i -1
end
set @sql = left(@sql,len(@sql)-3) + '
from tempOutputRx a
inner join (select * from tempOutputRx where prod = ''000'') b on
	a.Lev = b.Lev and a.Geo = b.Geo and a.Product = b.Product and a.Mkt = b.Mkt and a.Department = b.Department'
print @sql
exec(@sql)
go


Declare @i int, @sql varchar(max)
select @i = count(*)-1 from tblRxHalfYearList
set @sql = 'update tempOutputRx set
'
while @i >= 1
begin
	set @sql = @sql + 'HG'+cast(@i as varchar) + '=case when H' + cast(@i+1 as varchar) + '=0 then SIGN(H'+cast(@i as varchar) + ') else H'+cast(@i as varchar) + '/H'+cast(@i+1 as varchar) + '-1 end,
'
	set @i = @i -1
end
set @sql = left(@sql,len(@sql)-3)
print @sql
exec(@sql)
go


update tempOutputRx set Department = b.Id
from tempOutputRx a
inner join tblRxDepartment b on a.Department = b.Department
go

-------------------------------------------------------------
--				CIA-CV-Modification Slide 1's middle table
-------------------------------------------------------------

IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE ID=OBJECT_ID(N'Output_CIA_CV_Modification_Slide_1') AND TYPE='U' )
BEGIN
	DROP TABLE Output_CIA_CV_Modification_Slide_1
END
declare @currHalfYear varchar(10)
declare @lastHalfYear varchar(10)
declare @sql nvarchar(max)
select @currHalfYear=right(H,2)+'_20'+left(H,2) from dbo.tblRxHalfYearList where Idx=1
select @lastHalfYear=right(H,2)+'_20'+left(H,2) from dbo.tblRxHalfYearList where Idx=3

set @sql='
SELECT distinct t.*, ''ValueTrend'' as [Type] 
INTO Output_CIA_CV_Modification_Slide_1
FROM
(
	select a.product,a.Prod,c.ProductName,a.Department as Dep_Id,b.Department_en ,sum(H1) as '+ @currHalfYear +',sum(H3) AS '+@lastHalfYear+' 
	from tempoutputRx a join tblRxDepartment b on a.Department=b.id join tblMktDefRx c on a.Prod=c.Prod and a.product=c.product
	where a.product=''Eliquis VT'' and a.Lev=''nat'' and a.Prod<>''000''
	group by a.product,a.Prod, b.Department_en,c.ProductName,a.Department
	union
	select a.product,a.Prod,c.ProductName,a.Department as Dep_Id,''Others'' as Department_en ,sum(H1) as H1_2013,sum(H3) AS H1_2012
	from tempoutputRx a join tblMktDefRx c on a.Prod=c.Prod and a.product=c.product
	where a.product=''Eliquis VT'' and a.Lev=''nat'' and a.Department=9999 and a.Prod<>''000''
	group by a.product,a.Prod,c.ProductName,a.Department
) A unpivot (
	Y for X in ('+@currHalfYear+','+@lastHalfYear+')
) t'

--print @sql
exec(@sql + ' ')



--SELECT * FROM Output_CIA_CV_Modification_Slide_1
--ORDER BY Prod,X,Dep_Id

DELETE FROM Output_CIA_CV_Modification_Slide_1 WHERE Dep_Id='000' and [Type]='ValueTrend'
INSERT INTO Output_CIA_CV_Modification_Slide_1 (product,Prod,ProductName,Dep_Id,Department_en,Y,X,[Type])
SELECT product,Prod,ProductName,'000' as Dep_Id,'All Department' as Department_en,SUM(Y) as Y,X,'ValueTrend' as [Type]
FROM Output_CIA_CV_Modification_Slide_1
GROUP BY product,Prod,ProductName,X

GO

--Insert value share of each Department
INSERT INTO Output_CIA_CV_Modification_Slide_1 (product,Prod,ProductName,Dep_Id,Department_en,Y,X,[Type])
SELECT a.product,a.prod,a.ProductName,a.Dep_Id,a.Department_en,
	   case when b.Y IS NULL or b.Y=0 then 0 else 1.0*a.Y/b.Y end as Y,
	   a.X as X, 'ValueShare' as [Type]
FROM ( select * from Output_CIA_CV_Modification_Slide_1 where Dep_Id<>'000' and Type='ValueTrend' ) a join 
     ( select * from Output_CIA_CV_Modification_Slide_1 where Dep_Id='000' and Type='ValueTrend' )	b 
     on a.product=b.product and a.prod=b.prod and a.X=b.X	





print 'over!'