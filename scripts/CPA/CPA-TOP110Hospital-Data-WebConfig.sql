--select * from webpage where id like '24%' order by id

--insert into webpage(id,code,ImageURL,Lev,Idx,ParentId,IsShow)
--values (248,'VIII:TOP110 Hospital CPA Data','Monopril Raw Data CPA from SFE - 2014 Feb.xlsx',10,8,24,'y')

--select * from webpage where id=248

--172.20.0.33
use BMSChina_staging

update webpage
set ImageURL='Monopril Raw Data CPA from SFE - 2014 Nov.xlsx'
where id=248