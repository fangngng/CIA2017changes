use BMSChina_staging
--db33·þÎñÆ÷
--select * from WebPage where ParentID= 29 order by Idx
--select * from WebPage where ParentID= 30 order by Idx

--delete from webpage where id=307


--insert into WebPage(ID,Code,ImageURL,Lev,Idx,ParentId,IsShow)
--values(293,'III.TOP Hospital CPA Data','Eliquis Raw Data CPA from SFE - 2014 Dec.xlsx',10,3,29,'y')

--insert into WebPage(ID,Code,ImageURL,Lev,Idx,ParentId,IsShow)
--values(307,'VII.TOP100 Hospital CPA Data','Coniel Raw Data CPA from SFE - 2014 Dec.xlsx',10,7,30,'Y')

update webpage
set ImageURL= replace(imageurl,'2016 Jun','2016 Jul')
where id in (248,293,307)