use BMSChinaCIA_IMS
select * from IMS_NOAC_PROD
--city lev
if exists (select * from dbo.sysobjects where id = object_id(N'IMS_NOAC') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table IMS_NOAC
go


select 
	m.region as Region,
	audi_cod as [AUDIT SHORT DESC],
	I.city_name as [AUDIT DESC],
	manufacturer_abbr as [CORPORATE SHORT DESC],
	manufacturer_name as [CORPORATE DESC],
	f.manufacturertype_code as [MANUF.TYPE SHORT DESC],
	f.manufacturertype_name as [MANUF.TYPE DESC],
	left(Therapeutic_Code,1) as [TC I SHORT DESC],
	cast(null as varchar(255)) as [TC I DESC],
	left(Therapeutic_Code,3) as [TC II SHORT DESC],
	cast(null as varchar(255)) as [TC II DESC],
	left(Therapeutic_Code,4) as [TC III SHORT DESC],
	cast(null as varchar(255)) as [TC III DESC],
	Therapeutic_Code as [TC IV SHORT DESC],
	cast(null as varchar(255)) as [TC IV DESC],
	rtrim(left(c.product_name,5))	as [PRODUCT SHORT DESC],
	rtrim(c.product_name)+space(19-len(c.product_name))+ltrim(manufacturer_abbr) as [PRODUCT DESC],
	h.pack_res as [PACK SHORT DESC],
	c.product_name+' '+b.pack_description as [PACK DESC],
    MTH59LC as   V201101,
    MTH58LC as   V201102,
    MTH57LC as   V201103,
    MTH56LC as   V201104,
    MTH55LC as   V201105,
    MTH54LC as   V201106,
    MTH53LC as   V201107,
    MTH52LC as   V201108,
    MTH51LC as   V201109,
    MTH50LC as   V201110,
    MTH49LC as   V201111,
    MTH48LC as   V201112,
    MTH47LC as   V201201,
    MTH46LC as   V201202,
    MTH45LC as   V201203,
    MTH44LC as   V201204,
    MTH43LC as   V201205,
    MTH42LC as   V201206,
    MTH41LC as   V201207,
    MTH40LC as   V201208,
    MTH39LC as   V201209,
    MTH38LC as   V201210,
    MTH37LC as   V201211,
    MTH36LC as   V201212,
    MTH35LC as   V201301,
    MTH34LC as   V201302,
    MTH33LC as   V201303,
    MTH32LC as   V201304,
    MTH31LC as   V201305,
    MTH30LC as   V201306,
    MTH29LC as   V201307,
    MTH28LC as   V201308,
    MTH27LC as   V201309,
    MTH26LC as   V201310,
    MTH25LC as   V201311,
    MTH24LC as   V201312,
    MTH23LC as   V201401,
    MTH22LC as   V201402,
    MTH21LC as   V201403,
    MTH20LC as   V201404,
    MTH19LC as   V201405,
    MTH18LC as   V201406,
    MTH17LC as   V201407,
    MTH16LC as   V201408,
    MTH15LC as   V201409,
    MTH14LC as   V201410,
    MTH13LC as   V201411,
    MTH12LC as   V201412,
    MTH11LC as   V201501,
    MTH10LC as   V201502,
    MTH09LC as   V201503,
    MTH08LC as   V201504,
    MTH07LC as   V201505,
    MTH06LC as   V201506,
    MTH05LC as   V201507,
    MTH04LC as   V201508,
    MTH03LC as   V201509,
    MTH02LC as   V201510,
    MTH01LC as   V201511,
    MTH00LC as   V201512,
    MTH59UN as   U201101,
    MTH58UN as   U201102,
    MTH57UN as   U201103,
    MTH56UN as   U201104,
    MTH55UN as   U201105,
    MTH54UN as   U201106,
    MTH53UN as   U201107,
    MTH52UN as   U201108,
    MTH51UN as   U201109,
    MTH50UN as   U201110,
    MTH49UN as   U201111,
    MTH48UN as   U201112,
    MTH47UN as   U201201,
    MTH46UN as   U201202,
    MTH45UN as   U201203,
    MTH44UN as   U201204,
    MTH43UN as   U201205,
    MTH42UN as   U201206,
    MTH41UN as   U201207,
    MTH40UN as   U201208,
    MTH39UN as   U201209,
    MTH38UN as   U201210,
    MTH37UN as   U201211,
    MTH36UN as   U201212,
    MTH35UN as   U201301,
    MTH34UN as   U201302,
    MTH33UN as   U201303,
    MTH32UN as   U201304,
    MTH31UN as   U201305,
    MTH30UN as   U201306,
    MTH29UN as   U201307,
    MTH28UN as   U201308,
    MTH27UN as   U201309,
    MTH26UN as   U201310,
    MTH25UN as   U201311,
    MTH24UN as   U201312,
    MTH23UN as   U201401,
    MTH22UN as   U201402,
    MTH21UN as   U201403,
    MTH20UN as   U201404,
    MTH19UN as   U201405,
    MTH18UN as   U201406,
    MTH17UN as   U201407,
    MTH16UN as   U201408,
    MTH15UN as   U201409,
    MTH14UN as   U201410,
    MTH13UN as   U201411,
    MTH12UN as   U201412,
    MTH11UN as   U201501,
    MTH10UN as   U201502,
    MTH09UN as   U201503,
    MTH08UN as   U201504,
    MTH07UN as   U201505,
    MTH06UN as   U201506,
    MTH05UN as   U201507,
    MTH04UN as   U201508,
    MTH03UN as   U201509,
    MTH02UN as   U201510,
    MTH01UN as   U201511,
    MTH00UN as 	 U201512
into IMS_NOAC
from mthcity_pkau a
inner join Dim_Pack b
on a.pack_cod=b.pack_code
inner join Dim_Product c
on b.product_id=c.product_id
inner join(select distinct rtrim(left([product desc],19)) as [product desc] from IMS_NOAC_PROD) d
	on c.product_name=rtrim(left(d.[product desc],19))
inner join Dim_Manufacturer e
on c.manufacturer_id=e.manufacturer_id
inner join Dim_ManufacturerType f
on e.manufacturerType_id=f.manufacturerType_id
inner join Dim_Therapeutic_Class g
on b.Therapeutic_ID=g.Therapeutic_ID
inner join pack h
on b.pack_code=h.pack_cod
inner join dim_city I
on a.city_id=I.city_id
inner join region m
on I.city_name=m.[audit desc]

GO

insert into IMS_NOAC
select 
	'CHPA' as Region,
	'CHPA' as [AUDIT SHORT DESC],
	'CHPA' as [AUDIT DESC],
	manufacturer_abbr as [CORPORATE SHORT DESC],
	manufacturer_name as [CORPORATE DESC],
	f.manufacturertype_code as [MANUF.TYPE SHORT DESC],
	f.manufacturertype_name as [MANUF.TYPE DESC],
	left(Therapeutic_Code,1) as [TC I SHORT DESC],
	cast(null as varchar(255)) as [TC I DESC],
	left(Therapeutic_Code,3) as [TC II SHORT DESC],
	cast(null as varchar(255)) as [TC II DESC],
	left(Therapeutic_Code,4) as [TC III SHORT DESC],
	cast(null as varchar(255)) as [TC III DESC],
	Therapeutic_Code as [TC IV SHORT DESC],
	cast(null as varchar(255)) as [TC IV DESC],
	rtrim(left(c.product_name,5))	as [PRODUCT SHORT DESC],
	rtrim(c.product_name)+space(19-len(c.product_name))+ltrim(manufacturer_abbr) as [PRODUCT DESC],
	h.pack_res as [PACK SHORT DESC],
	c.product_name+' '+b.pack_description as [PACK DESC],
    MTH59LC as   V201101,
    MTH58LC as   V201102,
    MTH57LC as   V201103,
    MTH56LC as   V201104,
    MTH55LC as   V201105,
    MTH54LC as   V201106,
    MTH53LC as   V201107,
    MTH52LC as   V201108,
    MTH51LC as   V201109,
    MTH50LC as   V201110,
    MTH49LC as   V201111,
    MTH48LC as   V201112,
    MTH47LC as   V201201,
    MTH46LC as   V201202,
    MTH45LC as   V201203,
    MTH44LC as   V201204,
    MTH43LC as   V201205,
    MTH42LC as   V201206,
    MTH41LC as   V201207,
    MTH40LC as   V201208,
    MTH39LC as   V201209,
    MTH38LC as   V201210,
    MTH37LC as   V201211,
    MTH36LC as   V201212,
    MTH35LC as   V201301,
    MTH34LC as   V201302,
    MTH33LC as   V201303,
    MTH32LC as   V201304,
    MTH31LC as   V201305,
    MTH30LC as   V201306,
    MTH29LC as   V201307,
    MTH28LC as   V201308,
    MTH27LC as   V201309,
    MTH26LC as   V201310,
    MTH25LC as   V201311,
    MTH24LC as   V201312,
    MTH23LC as   V201401,
    MTH22LC as   V201402,
    MTH21LC as   V201403,
    MTH20LC as   V201404,
    MTH19LC as   V201405,
    MTH18LC as   V201406,
    MTH17LC as   V201407,
    MTH16LC as   V201408,
    MTH15LC as   V201409,
    MTH14LC as   V201410,
    MTH13LC as   V201411,
    MTH12LC as   V201412,
    MTH11LC as   V201501,
    MTH10LC as   V201502,
    MTH09LC as   V201503,
    MTH08LC as   V201504,
    MTH07LC as   V201505,
    MTH06LC as   V201506,
    MTH05LC as   V201507,
    MTH04LC as   V201508,
    MTH03LC as   V201509,
    MTH02LC as   V201510,
    MTH01LC as   V201511,
    MTH00LC as   V201512,
    MTH59UN as   U201101,
    MTH58UN as   U201102,
    MTH57UN as   U201103,
    MTH56UN as   U201104,
    MTH55UN as   U201105,
    MTH54UN as   U201106,
    MTH53UN as   U201107,
    MTH52UN as   U201108,
    MTH51UN as   U201109,
    MTH50UN as   U201110,
    MTH49UN as   U201111,
    MTH48UN as   U201112,
    MTH47UN as   U201201,
    MTH46UN as   U201202,
    MTH45UN as   U201203,
    MTH44UN as   U201204,
    MTH43UN as   U201205,
    MTH42UN as   U201206,
    MTH41UN as   U201207,
    MTH40UN as   U201208,
    MTH39UN as   U201209,
    MTH38UN as   U201210,
    MTH37UN as   U201211,
    MTH36UN as   U201212,
    MTH35UN as   U201301,
    MTH34UN as   U201302,
    MTH33UN as   U201303,
    MTH32UN as   U201304,
    MTH31UN as   U201305,
    MTH30UN as   U201306,
    MTH29UN as   U201307,
    MTH28UN as   U201308,
    MTH27UN as   U201309,
    MTH26UN as   U201310,
    MTH25UN as   U201311,
    MTH24UN as   U201312,
    MTH23UN as   U201401,
    MTH22UN as   U201402,
    MTH21UN as   U201403,
    MTH20UN as   U201404,
    MTH19UN as   U201405,
    MTH18UN as   U201406,
    MTH17UN as   U201407,
    MTH16UN as   U201408,
    MTH15UN as   U201409,
    MTH14UN as   U201410,
    MTH13UN as   U201411,
    MTH12UN as   U201412,
    MTH11UN as   U201501,
    MTH10UN as   U201502,
    MTH09UN as   U201503,
    MTH08UN as   U201504,
    MTH07UN as   U201505,
    MTH06UN as   U201506,
    MTH05UN as   U201507,
    MTH04UN as   U201508,
    MTH03UN as   U201509,
    MTH02UN as   U201510,
    MTH01UN as   U201511,
    MTH00UN as 	 U201512
from mthchpa_pkau a
inner join Dim_Pack b
on a.pack_cod=b.pack_code
inner join Dim_Product c
on b.product_id=c.product_id
inner join(select distinct rtrim(left([product desc],19)) as [product desc] from IMS_NOAC_PROD) d
	on c.product_name=rtrim(left(d.[product desc],19))
inner join Dim_Manufacturer e
on c.manufacturer_id=e.manufacturer_id
inner join Dim_ManufacturerType f
on e.manufacturerType_id=f.manufacturerType_id
inner join Dim_Therapeutic_Class g
on b.Therapeutic_ID=g.Therapeutic_ID
inner join pack h
on b.pack_code=h.pack_cod

update IMS_NOAC set [TC I DESC]=b.Therapeutic_Name
from IMS_NOAC a
inner join Dim_Therapeutic_Class b
on a.[TC I SHORT DESC] = b.Therapeutic_Code

update IMS_NOAC set [TC II DESC]=b.Therapeutic_Name
from IMS_NOAC a
inner join Dim_Therapeutic_Class b
on a.[TC II SHORT DESC] = b.Therapeutic_Code

update IMS_NOAC set [TC III DESC]=b.Therapeutic_Name
from IMS_NOAC a
inner join Dim_Therapeutic_Class b
on a.[TC III SHORT DESC] = b.Therapeutic_Code

update IMS_NOAC set [TC IV DESC]=b.Therapeutic_Name
from IMS_NOAC a
inner join Dim_Therapeutic_Class b
on a.[TC IV SHORT DESC] = b.Therapeutic_Code


select * from IMS_NOAC
