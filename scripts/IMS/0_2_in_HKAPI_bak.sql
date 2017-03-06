use BMSChinaOtherDB
GO


/*************************Update RawData****************************
--backup all rawdata
	--dbo.[HKAPI_2010Q4]
	if object_id(N'dbo.HKAPI_2010Q4_bak_20140109',N'U') is  null
		--drop table HKAPI_2011H1_bak_20140109
	select * into HKAPI_2010Q4_bak_20140109 from dbo.HKAPI_2010Q4

	--dbo.HKAPI_2011H1
	if object_id(N'dbo.HKAPI_2011H1_bak_20140109',N'U') is  null
		--drop table HKAPI_2011H1_bak_20140109
	select * into HKAPI_2011H1_bak_20140109 from dbo.HKAPI_2011H1

	--dbo.HKAPI_2011H1STLY
	if object_id(N'dbo.HKAPI_2011H1STLY_bak_20140109',N'U') is  null
		--drop table HKAPI_2011H1STLY_bak_20140109
	select * into HKAPI_2011H1STLY_bak_20140109 from dbo.HKAPI_2011H1STLY

	--dbo.HKAPI_2011Q1
	if object_id(N'dbo.HKAPI_2011Q1_bak_20140109',N'U') is  null
		--drop table HKAPI_2011Q1_bak_20140109
	select * into HKAPI_2011Q1_bak_20140109 from dbo.HKAPI_2011Q1


	--dbo.HKAPI_2011Q1STLY
	if object_id(N'dbo.HKAPI_2011Q1STLY_bak_20140109',N'U') is  null
		--drop table HKAPI_2011Q1STLY_bak_20140109
	select * into HKAPI_2011Q1STLY_bak_20140109 from dbo.HKAPI_2011Q1STLY

	--dbo.HKAPI_2011Q3
	if object_id(N'dbo.HKAPI_2011Q3_bak_20140109',N'U') is  null
		--drop table HKAPI_2011Q3_bak_20140109
	select * into HKAPI_2011Q3_bak_20140109 from dbo.HKAPI_2011Q3

	--dbo.HKAPI_2011Q3STLY
	if object_id(N'dbo.HKAPI_2011Q3STLY_bak_20140109',N'U') is  null
		--drop table HKAPI_2011Q3STLY_bak_20140109
	select * into HKAPI_2011Q3STLY_bak_20140109 from dbo.HKAPI_2011Q3STLY

	--dbo.HKAPI_2011Q4
	if object_id(N'dbo.HKAPI_2011Q4_bak_20140109',N'U') is  null
		--drop table HKAPI_2011Q4_bak_20140109
	select * into HKAPI_2011Q4_bak_20140109 from dbo.HKAPI_2011Q4

	--dbo.HKAPI_2011Q4STLY
	if object_id(N'dbo.HKAPI_2011Q4STLY_bak_20140109',N'U') is  null
		--drop table HKAPI_2011Q4STLY_bak_20140109
	select * into HKAPI_2011Q4STLY_bak_20140109 from dbo.HKAPI_2011Q4STLY

	--dbo.HKAPI_2012Q1
	if object_id(N'dbo.HKAPI_2012Q1_bak_20140109',N'U') is  null
		--drop table HKAPI_2012Q1_bak_20140109
	select * into HKAPI_2012Q1_bak_20140109 from dbo.HKAPI_2012Q1

	--dbo.HKAPI_2012Q1STLY
	if object_id(N'dbo.HKAPI_2012Q1STLY_bak_20140109',N'U') is null
		--drop table HKAPI_2012Q1STLY_bak_20140109
	select * into HKAPI_2012Q1STLY_bak_20140109 from dbo.HKAPI_2012Q1STLY

	--dbo.HKAPI_2012Q2
	if object_id(N'dbo.HKAPI_2012Q2_bak_20140109',N'U') is null
		--drop table HKAPI_2012Q2_bak_20140109
	select * into HKAPI_2012Q2_bak_20140109 from dbo.HKAPI_2012Q2

	--dbo.HKAPI_2012Q2STLY
	if object_id(N'dbo.HKAPI_2012Q2STLY_bak_20140109',N'U') is null
		--drop table HKAPI_2012Q2STLY_bak_20140109
	select * into HKAPI_2012Q2STLY_bak_20140109 from dbo.HKAPI_2012Q2STLY

	--dbo.HKAPI_2012Q3
	if object_id(N'dbo.HKAPI_2012Q3_bak_20140109',N'U') is null
		--drop table HKAPI_2012Q3_bak_20140109
	select * into HKAPI_2012Q3_bak_20140109 from dbo.HKAPI_2012Q3

	--dbo.HKAPI_2012Q3STLY
	if object_id(N'dbo.HKAPI_2012Q3STLY_bak_20140109',N'U') is null
		--drop table HKAPI_2012Q3STLY_bak_20140109
	select * into HKAPI_2012Q3STLY_bak_20140109 from dbo.HKAPI_2012Q3STLY

	--dbo.HKAPI_2012Q4
	if object_id(N'dbo.HKAPI_2012Q4_bak_20140109',N'U') is null
		--drop table HKAPI_2012Q4_bak_20140109
	select * into HKAPI_2012Q4_bak_20140109 from dbo.HKAPI_2012Q4

	--dbo.HKAPI_2012Q4STLY
	if object_id(N'dbo.HKAPI_2012Q4STLY_bak_20140109',N'U') is null
		--drop table HKAPI_2012Q4STLY_bak_20140109
	select * into HKAPI_2012Q4STLY_bak_20140109 from dbo.HKAPI_2012Q4STLY

	--dbo.HKAPI_2013Q1
	if object_id(N'dbo.HKAPI_2013Q1_bak_20140109',N'U') is null
		--drop table HKAPI_2013Q1_bak_20140109
	select * into HKAPI_2013Q1_bak_20140109 from dbo.HKAPI_2013Q1

	--dbo.HKAPI_2013Q1STLY
	if object_id(N'dbo.HKAPI_2013Q1STLY_bak_20140109',N'U') is null
		--drop table HKAPI_2013Q1STLY_bak_20140109
	select * into HKAPI_2013Q1STLY_bak_20140109 from dbo.HKAPI_2013Q1STLY

	--dbo.HKAPI_2013Q2
	if object_id(N'dbo.HKAPI_2013Q2_bak_20140109',N'U') is null
		--drop table HKAPI_2013Q2_bak_20140109
	select * into HKAPI_2013Q2_bak_20140109 from dbo.HKAPI_2013Q2

	--dbo.HKAPI_2013Q2STLY
	if object_id(N'dbo.HKAPI_2013Q2STLY_bak_20140109',N'U') is null
		--drop table HKAPI_2013Q2STLY_bak_20140109
	select * into HKAPI_2013Q2STLY_bak_20140109 from dbo.HKAPI_2013Q2STLY

	--dbo.HKAPI_2013Q3
	if object_id(N'dbo.HKAPI_2013Q3_bak_20140109',N'U') is null
		--drop table HKAPI_2013Q3_bak_20140109
	select * into HKAPI_2013Q3_bak_20140109 from dbo.HKAPI_2013Q3

	--dbo.HKAPI_2013Q3STLY
	if object_id(N'dbo.HKAPI_2013Q3STLY_bak_20140109',N'U') is null
		--drop table HKAPI_2013Q3STLY_bak_20140109
	select * into HKAPI_2013Q3STLY_bak_20140109 from dbo.HKAPI_2013Q3STLY

--Update RawData

	--dbo.[HKAPI_2010Q4]
		update [HKAPI_2010Q4]
		set [Company Name]='BHC'
		where [Company Name]='BSP'
	
		update [HKAPI_2010Q4]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2010Q4]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2010Q4]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2010Q4]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')
		
	--dbo.[HKAPI_2011H1]
		update HKAPI_2011H1
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2011H1]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2011H1]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2011H1]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2011H1]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


	--dbo.[HKAPI_2011H1STLY]
		update HKAPI_2011H1STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2011H1STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2011H1STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2011H1STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2011H1STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


	--dbo.[HKAPI_2011Q1]
		update HKAPI_2011Q1
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2011Q1]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2011Q1]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2011Q1]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2011Q1]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2011Q1STLY]
		update HKAPI_2011Q1STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2011Q1STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2011Q1STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2011Q1STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2011Q1STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2011Q3]
		update HKAPI_2011Q3
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2011Q3]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2011Q3]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2011Q3]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2011Q3]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


	--dbo.[HKAPI_2011Q3STLY]
		update HKAPI_2011Q3STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2011Q3STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2011Q3STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2011Q3STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2011Q3STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2011Q4]
		update HKAPI_2011Q4
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2011Q4]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2011Q4]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2011Q4]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2011Q4]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2011Q4STLY]
		update HKAPI_2011Q4STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2011Q4STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2011Q4STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2011Q4STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2011Q4STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2012Q1]
		update HKAPI_2012Q1
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2012Q1]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2012Q1]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2012Q1]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2012Q1]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2012Q1STLY]
		update HKAPI_2012Q1STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2012Q1STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2012Q1STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2012Q1STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2012Q1STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2012Q2]
		update HKAPI_2012Q2
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2012Q2]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2012Q2]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2012Q2]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2012Q2]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2012Q2STLY]
		update HKAPI_2012Q2STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2012Q2STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2012Q2STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2012Q2STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2012Q2STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2012Q3]
		update HKAPI_2012Q3
		set [Company Name]='BHC'
		where [Company Name]='BSP'
	
		update [HKAPI_2012Q3]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2012Q3]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2012Q3]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2012Q3]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2012Q3STLY]
		update HKAPI_2012Q3STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2012Q3STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2012Q3STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2012Q3STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2012Q3STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2012Q4]
		update HKAPI_2012Q4
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2012Q4]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2012Q4]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2012Q4]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2012Q4]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

		
		
	--dbo.[HKAPI_2012Q4STLY]
		update HKAPI_2012Q4STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
	
		update [HKAPI_2012Q4STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2012Q4STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2012Q4STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2012Q4STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


	--dbo.[HKAPI_2013Q1]
		update HKAPI_2013Q1
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2013Q1]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2013Q1]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2013Q1]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2013Q1]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


	--dbo.[HKAPI_2013Q1STLY]
		update HKAPI_2013Q1STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2013Q1STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2013Q1STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2013Q1STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2013Q1STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2013Q2]
		update HKAPI_2013Q2
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2013Q2]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2013Q2]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2013Q2]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2013Q2]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

	--dbo.[HKAPI_2013Q2STLY]
		update HKAPI_2013Q2STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2013Q2STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2013Q2STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2013Q2STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2013Q2STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


	--dbo.[HKAPI_2013Q3]
		update HKAPI_2013Q3
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2013Q3]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2013Q3]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2013Q3]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2013Q3]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


	--dbo.[HKAPI_2013Q3STLY]
		update HKAPI_2013Q3STLY
		set [Company Name]='BHC'
		where [Company Name]='BSP'
		
		update [HKAPI_2013Q3STLY]
		set [Product Name]='FLUDARA(BHC)'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

		update [HKAPI_2013Q3STLY]
		set [Product Name]='BAYASPIRIN'
		where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

		update [HKAPI_2013Q3STLY]
		set [Product Name]='NIMOTOP'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

		update [HKAPI_2013Q3STLY]
		set [Product Name]='NT30MG 20''S'
		where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


********************************************************************/





----check data
--select * from dbo.HKAPI_2011H1 A inner join dbo.HKAPI_2011Q3 B
--on  a.[Company Name]=b.[Company Name] and a.[Product Name]=B.[Product Name]
--and a.[Therapeutic Class]=B.[Therapeutic Class]

--select * from dbo.HKAPI_2011H1 A where not exists(select * from dbo.HKAPI_2011Q3 B
--where  a.[Company Name]=b.[Company Name] and a.[Product Name]=B.[Product Name]
--and a.[Therapeutic Class]=B.[Therapeutic Class])
--select * from dbo.HKAPI_2011Q3 A where not exists(select * from dbo.HKAPI_2011H1  B
--where  a.[Company Name]=b.[Company Name] and a.[Product Name]=B.[Product Name]
--and a.[Therapeutic Class]=B.[Therapeutic Class])
--go
----Create table inHKAPI_Linda



select [Therapeutic Class],[Company Name],[Company Name],[Product Name],ta,count(*) from [HKAPI_2010Q4]
group by [Therapeutic Class],[Company Name],[Product Name],TA
having count(*)>1

select [Company Name],[Company Name],[Product Name],count(*) from [HKAPI_2011Q1]
group by [Company Name],[Company Name],[Product Name]
having count(*)>1

select [Company Name],[Company Name],[Product Name],count(*) from [HKAPI_2011H1]
group by [Company Name],[Company Name],[Product Name]
having count(*)>1

select [Company Name],[Company Name],[Product Name],count(*) from [HKAPI_2011Q3]
group by [Company Name],[Company Name],[Product Name]
having count(*)>1

select [Company Name],[Company Name],[Product Name],count(*) from [HKAPI_2011Q4]
group by [Company Name],[Company Name],[Product Name]
having count(*)>1

select [Company Name],[Therapeutic Class],[Product Name],count(*) from [HKAPI_2012Q1]
group by [Company Name],[Therapeutic Class],[Product Name]
having count(*)>1

select [Company Name],[Therapeutic Class],[Product Name],count(*) from [HKAPI_2012Q2]
group by [Company Name],[Therapeutic Class],[Product Name]
having count(*)>1
go
select [Company Name],[Therapeutic Class],[Product Name],count(*) from [HKAPI_2012Q3]
group by [Company Name],[Therapeutic Class],[Product Name]
having count(*)>1
go
select [Company Name],[Therapeutic Class],[Product Name],count(*) from [HKAPI_2012Q4]
group by [Company Name],[Therapeutic Class],[Product Name]
having count(*)>1
go
select [Company Name],[Therapeutic Class],[Product Name],count(*) from [HKAPI_2013Q1]
group by [Company Name],[Therapeutic Class],[Product Name]
having count(*)>1
go
select [Company Name],[Therapeutic Class],[Product Name],count(*) from [HKAPI_2013Q2]
group by [Company Name],[Therapeutic Class],[Product Name]
having count(*)>1
go
select [Company Name],[Therapeutic Class],[Product Name],count(*) from [HKAPI_2013Q3]
group by [Company Name],[Therapeutic Class],[Product Name]
having count(*)>1
go

update HKAPI_2012Q1
set [Product name]='SPRYCEL' where [Product Name]='SPYCEL'
go 
--select * into [HKAPI_2010Q4_bak_20140109] from [HKAPI_2010Q4]
--update [HKAPI_2010Q4]
--set [Company Name]='BHC'
--where [Company Name]='BSP'

--update [HKAPI_2010Q4]
--set [Product Name]='FLUDARA(BHC)'
--where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

--update [HKAPI_2010Q4]
--set [Product Name]='BAYASPIRIN'
--where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

--update [HKAPI_2010Q4]
--set [Product Name]='NIMOTOP'
--where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

--update [HKAPI_2010Q4]
--set [Product Name]='NT30MG 20''S'
--where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')


drop table [tempHKAPI_2010Q4]
go
select [Company Name],[Product Name],[Therapeutic Class],TA,sum(isnull([06Q1],0)) as [06Q1]
      ,sum(isnull([06Q2],0)) as [06Q2]
      ,sum(isnull([06Q3],0)) as [06Q3]
      ,sum(isnull([06Q4],0)) as [06Q4]
      ,sum(isnull([07Q1],0)) as [07Q1]
      ,sum(isnull([07Q2],0)) as [07Q2]
      ,sum(isnull([07Q3],0)) as [07Q3]
      ,sum(isnull([07Q4],0)) as [07Q4]
      ,sum(isnull([08Q1],0)) as [08Q1]
      ,sum(isnull([08Q2],0)) as [08Q2]
      ,sum(isnull([08Q3],0)) as [08Q3]
      ,sum(isnull([08Q4],0)) as [08Q4]
      ,sum(isnull([09Q1],0)) as [09Q1]
      ,sum(isnull([09Q2],0)) as [09Q2]
      ,sum(isnull([09Q3],0)) as [09Q3]
      ,sum(isnull([09Q4],0)) as [09Q4]
      ,sum(isnull([2010Q1],0)) as [2010Q1]
      ,sum(isnull([2010Q2],0)) as [2010Q2]
      ,sum(isnull([2010Q3],0)) as [2010Q3]
      ,sum(isnull([2010Q4],0)) as [2010Q4]
     ,sum(isnull([QTR 06Q1],0)) as [QTR 06Q1]
	 ,sum(isnull([YTD 06Q2],0)) as [YTD 06Q2]
	 ,sum(isnull([YTD 06Q3],0)) as [YTD 06Q3]
	 ,sum(isnull([YTD 06Q4],0)) as [YTD 06Q4]
	 ,sum(isnull([QTR 07Q1],0)) as [QTR 07Q1]
	 ,sum(isnull([YTD 07Q2],0)) as [YTD 07Q2]
	 ,sum(isnull([YTD 07Q3],0)) as [YTD 07Q3]
	 ,sum(isnull([YTD 07Q4],0)) as [YTD 07Q4]
	 ,sum(isnull([QTR 08Q1],0)) as [QTR 08Q1]
	 ,sum(isnull([YTD 08Q2],0)) as [YTD 08Q2]
	 ,sum(isnull([YTD 08Q3],0)) as [YTD 08Q3]
	 ,sum(isnull([YTD 08Q4],0)) as [YTD 08Q4]
	 ,sum(isnull([QTR 09Q1],0)) as [QTR 09Q1]
	 ,sum(isnull([YTD09Q2],0)) as [YTD 09Q2]
	 ,sum(isnull([YTD09Q3],0)) as [YTD 09Q3]
	 ,sum(isnull([YTD 09Q4],0)) as [YTD 09Q4]
	 ,sum(isnull([YTD 2010Q1],0)) as [YTD 2010Q1]
	 ,sum(isnull([YTD 2010Q2],0)) as [YTD 2010Q2]
	 ,sum(isnull([YTD 2010Q3],0)) as [YTD 2010Q3]
	 ,sum(isnull([YTD 2010Q4],0)) as [YTD 2010Q4]
 into [tempHKAPI_2010Q4] from [HKAPI_2010Q4]
group by [Company Name],[Product Name],[Therapeutic Class],TA
go
go

if exists (select * from dbo.sysobjects where id = object_id(N'inHKAPI_Linda') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table inHKAPI_Linda
go
select isnull(isnull(isnull(isnull(A.[Company Name],B.[Company Name]),C.[Company Name]),D.[Company Name]),E.[Company Name]) AS [Company Name]
      ,isnull(isnull(isnull(isnull(A.[Product Name],B.[Product Name]),C.[Product Name]),D.[Product Name]),E.[Product Name]) [Product Name]
      ,[TA]
--      ,[KEY PRODUCT]
--      ,isnull(isnull(CAST(A.[New Product] AS VARCHAR(20)),B.[New Product]),C.[New Product]) [New Product]
--      ,isnull(isnull(CAST(A.[When the new _product launched]AS VARCHAR(20)),B.[When the new _product launched]),C.[When the new _product launched]) [When the new _product launched]
      ,isnull(isnull(isnull(isnull(CAST(A.[Therapeutic Class] AS VARCHAR(20)),B.[Therapeutic Class]),C.[Therapeutic Class]),D.[Therapeutic Class]),E.[Therapeutic Class]) [Therapeutic Class]
into dbo.inHKAPI_Linda
FROM [dbo].[tempHKAPI_2010Q4] A full join dbo.HKAPI_2011Q1 B
on a.[Company Name]=b.[Company Name] and a.[Product Name]=B.[Product Name]
and a.[Therapeutic Class]=B.[Therapeutic Class]
full join dbo.HKAPI_2011H1 C
on a.[Company Name]=C.[Company Name] and a.[Product Name]=C.[Product Name]
and a.[Therapeutic Class]=C.[Therapeutic Class]
full join dbo.HKAPI_2011Q3 D
on a.[Company Name]=D.[Company Name] and a.[Product Name]=D.[Product Name]
and a.[Therapeutic Class]=D.[Therapeutic Class]
full join dbo.HKAPI_2011Q4 E
on a.[Company Name]=E.[Company Name] and a.[Product Name]=E.[Product Name]
and a.[Therapeutic Class]=E.[Therapeutic Class]
GROUP BY ISNULL(isnull(isnull(isnull(A.[Company Name],B.[Company Name]),C.[Company Name]),D.[Company Name]),E.[Company Name])
      ,isnull(isnull(isnull(isnull(A.[Product Name],B.[Product Name]),C.[Product Name]),D.[Product Name]),E.[Product Name])
      ,[TA]
--      ,[KEY PRODUCT]
--      ,isnull(isnull(CAST(A.[New Product] AS VARCHAR(20)),B.[New Product]),C.[New Product])
--      ,isnull(isnull(CAST(A.[When the new _product launched]AS VARCHAR(20)),B.[When the new _product launched]),C.[When the new _product launched])
      ,isnull(isnull(isnull(isnull(CAST(A.[Therapeutic Class] AS VARCHAR(20)),B.[Therapeutic Class]),C.[Therapeutic Class]),D.[Therapeutic Class]),E.[Therapeutic Class])

--Q4
if exists(
select * from dbo.HKAPI_2011Q4STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2011Q4STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go
--Q3
if exists(
select * from dbo.HKAPI_2011Q3STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2011Q3STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go
--H1
if exists(
select * from dbo.HKAPI_2011H1STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2011H1STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go
--Q1
if exists(
select * from dbo.HKAPI_2011Q1STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2011Q1STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go


--2012Q1 STLY
if exists(
select * from dbo.HKAPI_2012Q1STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2012Q1STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go
--2012Q1
if exists(
select * from dbo.HKAPI_2012Q1 A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2012Q1 A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go

--2012Q2 STLY
if exists(
select * from dbo.HKAPI_2012Q2STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2012Q2STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go
--2012Q2
if exists(
select * from dbo.HKAPI_2012Q2 A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2012Q2 A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go


--2012Q3 STLY
if exists(
select * from dbo.HKAPI_2012Q3STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2012Q3STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go
--2012Q3
if exists(
select * from dbo.HKAPI_2012Q3 A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2012Q3 A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go


--2012Q4 STLY
if exists(
select * from dbo.HKAPI_2012Q4STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2012Q4STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go
--2012Q4
if exists(
select * from dbo.HKAPI_2012Q4 A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2012Q4 A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go




--2013Q1 STLY
if exists(
select * from dbo.HKAPI_2013Q1STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2013Q1STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go
--2013Q1
if exists(
select * from dbo.HKAPI_2013Q1 A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2013Q1 A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go


--2013Q2 STLY
if exists(
select * from dbo.HKAPI_2013Q2STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2013Q2STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go
--2013Q2
if exists(
select * from dbo.HKAPI_2013Q2 A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2013Q2 A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go


--2013Q3 STLY
if exists(
select * from dbo.HKAPI_2013Q3STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2013Q3STLY A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go
--2013Q3
if exists(
select * from dbo.HKAPI_2013Q3 A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]))

insert into inHKAPI_Linda ([Company Name]
      ,[Product Name]
      ,[Therapeutic Class])
select distinct [Company Name]
      ,[Product Name]
      ,[Therapeutic Class] from dbo.HKAPI_2013Q3 A where not exists(
select * from inHKAPI_Linda B
where A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class])
go
--todo: Add the new Quterarly Data






 Alter table inHKAPI_Linda
Add [06Q1LC] [float] NULL default 0,
	[06Q2LC] [float] NULL default 0,
	[06Q3LC] [float] NULL default 0,
	[06Q4LC] [float] NULL default 0,
	[07Q1LC] [float] NULL default 0,
	[07Q2LC] [float] NULL default 0,
	[07Q3LC] [float] NULL default 0,
	[07Q4LC] [float] NULL default 0,
	[08Q1LC] [float] NULL default 0,
	[08Q2LC] [float] NULL default 0,
	[08Q3LC] [float] NULL default 0,
	[08Q4LC] [float] NULL default 0,
	[09Q1LC] [float] NULL default 0,
	[09Q2LC] [float] NULL default 0,
	[09Q3LC] [float] NULL default 0,
	[09Q4LC] [float] NULL default 0,
	[10Q1LC] [float] NULL default 0,
	[10Q2LC] [float] NULL default 0,
	[10Q3LC] [float] NULL default 0,
	[10Q4LC] [float] NULL default 0,
	[11Q1LC] [float] NULL default 0,
	[11Q2LC] [float] NULL default 0,
	[11Q3LC] [float] NULL default 0,
	[11Q4LC] [float] NULL default 0,
	[12Q1LC] [float] NULL default 0,
	[12Q2LC] [float] NULL default 0,
	[12Q3LC] [float] NULL default 0,
	[12Q4LC] [float] NULL default 0,
	[13Q1LC] [float] NULL default 0,
	[13Q2LC] [float] NULL default 0,
	[13Q3LC] [float] NULL default 0,--todo
	[YTD 06Q1LC] [float] NULL default 0,
	[YTD 06Q2LC] [float] NULL default 0,
	[YTD 06Q3LC] [float] NULL default 0,
	[YTD 06Q4LC] [float] NULL default 0,
	[YTD 07Q1LC] [float] NULL default 0,
	[YTD 07Q2LC] [float] NULL default 0,
	[YTD 07Q3LC] [float] NULL default 0,
	[YTD 07Q4LC] [float] NULL default 0,
	[YTD 08Q1LC] [float] NULL default 0,
	[YTD 08Q2LC] [float] NULL default 0,
	[YTD 08Q3LC] [float] NULL default 0,
	[YTD 08Q4LC] [float] NULL default 0,
	[YTD 09Q1LC] [float] NULL default 0,
	[YTD 09Q2LC] [float] NULL default 0,
	[YTD 09Q3LC] [float] NULL default 0,
	[YTD 09Q4LC] [float] NULL default 0,
	[YTD 10Q1LC] [float] NULL default 0,
	[YTD 10Q2LC] [float] NULL default 0,
	[YTD 10Q3LC] [float] NULL default 0,
	[YTD 10Q4LC] [float] NULL default 0,
	[YTD 11Q1LC] [float] NULL default 0,
	[YTD 11Q2LC] [float] NULL default 0,
	[YTD 11Q3LC] [float] NULL default 0,
	[YTD 11Q4LC] [float] NULL default 0,
	[YTD 12Q1LC] [float] NULL default 0,
	[YTD 12Q2LC] [float] NULL default 0,
	[YTD 12Q3LC] [float] NULL default 0,
	[YTD 12Q4LC] [float] NULL default 0,
	[YTD 13Q1LC] [float] NULL default 0,
	[YTD 13Q2LC] [float] NULL default 0,
	[YTD 13Q3LC] [float] NULL default 0--todo
go
update inHKAPI_Linda
set 
[06Q1LC] = 0,
	[06Q2LC] = 0,
	[06Q3LC] = 0,
	[06Q4LC] = 0,
	[07Q1LC] = 0,
	[07Q2LC] = 0,
	[07Q3LC] = 0,
	[07Q4LC] = 0,
	[08Q1LC] = 0,
	[08Q2LC] = 0,
	[08Q3LC] = 0,
	[08Q4LC] = 0,
	[09Q1LC] = 0,
	[09Q2LC] = 0,
	[09Q3LC] = 0,
	[09Q4LC] = 0,
	[10Q1LC] = 0,
	[10Q2LC] = 0,
	[10Q3LC] = 0,
	[10Q4LC] = 0,
	[11Q1LC] = 0,
	[11Q2LC] = 0,
	[11Q3LC] = 0,
	[11Q4LC] = 0,
	[12Q1LC] = 0,
	[12Q2LC] = 0,
	[12Q3LC] = 0,
	[12Q4LC] = 0,
	[13Q1LC] = 0,
	[13Q2LC] = 0,
	[13Q3LC] = 0,--todo
	[YTD 06Q1LC] = 0,
	[YTD 06Q2LC] = 0,
	[YTD 06Q3LC] = 0,
	[YTD 06Q4LC] = 0,
	[YTD 07Q1LC] = 0,
	[YTD 07Q2LC] = 0,
	[YTD 07Q3LC] = 0,
	[YTD 07Q4LC] = 0,
	[YTD 08Q1LC] = 0,
	[YTD 08Q2LC] = 0,
	[YTD 08Q3LC] = 0,
	[YTD 08Q4LC] = 0,
	[YTD 09Q1LC] = 0,
	[YTD 09Q2LC] = 0,
	[YTD 09Q3LC] = 0,
	[YTD 09Q4LC] = 0,
	[YTD 10Q1LC] = 0,
	[YTD 10Q2LC] = 0,
	[YTD 10Q3LC] = 0,
	[YTD 10Q4LC] = 0,
	[YTD 11Q1LC] = 0,
	[YTD 11Q2LC] = 0,
	[YTD 11Q3LC] = 0,
	[YTD 11Q4LC] = 0,
	[YTD 12Q1LC] = 0,
	[YTD 12Q2LC] = 0,
	[YTD 12Q3LC] = 0,
	[YTD 12Q4LC] = 0,
	[YTD 13Q1LC] = 0,
	[YTD 13Q2LC] = 0,
	[YTD 13Q3LC] = 0--todo
go

update inHKAPI_Linda
set [06Q1LC]=B.[06Q1],
	[06Q2LC]=B.[06Q2],
	[06Q3LC]=B.[06Q3],
	[06Q4LC]=B.[06Q4],
	[07Q1LC]=B.[07Q1],
	[07Q2LC]=B.[07Q2],
	[07Q3LC]=B.[07Q3],
	[07Q4LC]=B.[07Q4],
	[08Q1LC]=B.[08Q1],
	[08Q2LC]=B.[08Q2],
	[08Q3LC]=B.[08Q3],
	[08Q4LC]=B.[08Q4],
	[09Q1LC]=B.[09Q1],
	[09Q2LC]=B.[09Q2],
	[09Q3LC]=B.[09Q3],
	[09Q4LC]=B.[09Q4],
	[YTD 06Q1LC]=B.[QTR 06Q1],
	[YTD 06Q2LC]=B.[YTD 06Q2],
	[YTD 06Q3LC]=B.[YTD 06Q3],
	[YTD 06Q4LC]=B.[YTD 06Q4],
	[YTD 07Q1LC]=B.[QTR 07Q1],
	[YTD 07Q2LC]=B.[YTD 07Q2],
	[YTD 07Q3LC]=B.[YTD 07Q3],
	[YTD 07Q4LC]=B.[YTD 07Q4],
	[YTD 08Q1LC]=B.[QTR 08Q1],
	[YTD 08Q2LC]=B.[YTD 08Q2],
	[YTD 08Q3LC]=B.[YTD 08Q3],
	[YTD 08Q4LC]=B.[YTD 08Q4],
	[YTD 09Q1LC]=B.[QTR 09Q1],
	[YTD 09Q2LC]=B.[YTD 09Q2],
	[YTD 09Q3LC]=B.[YTD 09Q3],
	[YTD 09Q4LC]=B.[YTD 09Q4]
from inHKAPI_Linda A inner join [tempHKAPI_2010Q4] B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]


go
update inHKAPI_Linda
set [YTD 10Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2011Q1STLY group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]

go
update inHKAPI_Linda
set [YTD 11Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2011Q1 group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]

go
update inHKAPI_Linda
set [YTD 10Q2LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2011H1STLY group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]

go
update inHKAPI_Linda
set [YTD 11Q2LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2011H1 group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]

go
update inHKAPI_Linda
set [YTD 10Q3LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2011Q3STLY group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]

go
update inHKAPI_Linda
set [YTD 11Q3LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2011Q3 group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]

go
update inHKAPI_Linda
set [YTD 10Q4LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2011Q4STLY group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]

go
update inHKAPI_Linda
set [YTD 11Q4LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2011Q4 group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]




go
update inHKAPI_Linda
set [YTD 11Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2012Q1STLY group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]

go
update inHKAPI_Linda
set [YTD 12Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2012Q1 group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]

go
update inHKAPI_Linda
set [YTD 11Q2LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2012Q2STLY group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]
go
update inHKAPI_Linda
set [YTD 12Q2LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2012Q2 group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]


go
update inHKAPI_Linda
set [YTD 11Q3LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2012Q3STLY group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]
go
update inHKAPI_Linda
set [YTD 12Q3LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2012Q3 group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]

--2012Q4
update inHKAPI_Linda
set [YTD 11Q4LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2012Q4STLY group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]
go
update inHKAPI_Linda
set [YTD 12Q4LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2012Q4 group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]
go


--2013Q1
update inHKAPI_Linda
set [YTD 12Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2013Q1STLY group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]
go
update inHKAPI_Linda
set [YTD 13Q1LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2013Q1 group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]
go

--2013Q2
update inHKAPI_Linda
set [YTD 12Q2LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2013Q2STLY group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]
go
update inHKAPI_Linda
set [YTD 13Q2LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2013Q2 group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]
go

--2013Q3
update inHKAPI_Linda
set [YTD 12Q3LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2013Q3STLY group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]
go
update inHKAPI_Linda
set [YTD 13Q3LC]=B.Sales from inHKAPI_Linda A inner join 
(select [Company Name]
      ,[Product Name]
      ,[Therapeutic Class],sum(isnull([Imported (RMB)],0)+isnull([Local Manufactured (RMB)],0)) as Sales
 from dbo.HKAPI_2013Q3 group by [Company Name]
      ,[Product Name]
      ,[Therapeutic Class]) B
on A.[Company Name]=B.[Company Name] and A.[Product Name]=B.[Product Name]
and A.[Therapeutic Class]=B.[Therapeutic Class]
go
--todo: Update use new quarterly data


----****************************************
--update inHKAPI_Linda
--set [Product Name]='FLUDARA(BHC)'
--where [Company Name] in ('BSP','BHC') and [Product Name] in ('FLUDARA','FLUDARA(BSP)','FLUDARA(BHC)')

--update inHKAPI_Linda
--set [Product Name]='BAYASPIRIN'
--where [Company Name] in ('BSP','BHC') and [Product Name] ='BAYASPIRIN PROTECT'

--update inHKAPI_Linda
--set [Product Name]='NIMOTOP'
--where [Company Name] in ('BSP','BHC') and [Product Name] in ('NIMOTOP IV')

--update inHKAPI_Linda
--set [Product Name]='NT30MG 20''S'
--where [Company Name] in ('BSP','BHC') and [Product Name] in ('NT30MG  20''S')

--if object_id(N'temp_inHKAPI_Linda',N'U') is not null
--	drop table temp_inHKAPI_Linda

--select 
--[Company Name],[Product Name],TA,[Therapeutic Class],
--sum([06Q1LC] ) as [06Q1LC] ,
--sum([06Q2LC] ) as [06Q2LC] ,
--sum([06Q3LC] ) as [06Q3LC] ,
--sum([06Q4LC] ) as [06Q4LC] ,
--sum([07Q1LC] ) as [07Q1LC] ,
--sum([07Q2LC] ) as [07Q2LC] ,
--sum([07Q3LC] ) as [07Q3LC] ,
--sum([07Q4LC] ) as [07Q4LC] ,
--sum([08Q1LC] ) as [08Q1LC] ,
--sum([08Q2LC] ) as [08Q2LC] ,
--sum([08Q3LC] ) as [08Q3LC] ,
--sum([08Q4LC] ) as [08Q4LC] ,
--sum([09Q1LC] ) as [09Q1LC] ,
--sum([09Q2LC] ) as [09Q2LC] ,
--sum([09Q3LC] ) as [09Q3LC] ,
--sum([09Q4LC] ) as [09Q4LC] ,
--sum([10Q1LC] ) as [10Q1LC] ,
--sum([10Q2LC] ) as [10Q2LC] ,
--sum([10Q3LC] ) as [10Q3LC] ,
--sum([10Q4LC] ) as [10Q4LC] ,
--sum([11Q1LC] ) as [11Q1LC] ,
--sum([11Q2LC] ) as [11Q2LC] ,
--sum([11Q3LC] ) as [11Q3LC] ,
--sum([11Q4LC] ) as [11Q4LC] ,
--sum([12Q1LC] ) as [12Q1LC] ,
--sum([12Q2LC] ) as [12Q2LC] ,
--sum([12Q3LC] ) as [12Q3LC] ,
--sum([12Q4LC] ) as [12Q4LC] ,
--sum([13Q1LC] ) as [13Q1LC] ,
--sum([13Q2LC] ) as [13Q2LC] ,
--sum([13Q3LC]) as [13Q3LC], --todo
--sum([YTD 06Q1LC] ) as [YTD 06Q1LC] ,
--sum([YTD 06Q2LC] ) as [YTD 06Q2LC] ,
--sum([YTD 06Q3LC] ) as [YTD 06Q3LC] ,
--sum([YTD 06Q4LC] ) as [YTD 06Q4LC] ,
--sum([YTD 07Q1LC] ) as [YTD 07Q1LC] ,
--sum([YTD 07Q2LC] ) as [YTD 07Q2LC] ,
--sum([YTD 07Q3LC] ) as [YTD 07Q3LC] ,
--sum([YTD 07Q4LC] ) as [YTD 07Q4LC] ,
--sum([YTD 08Q1LC] ) as [YTD 08Q1LC] ,
--sum([YTD 08Q2LC] ) as [YTD 08Q2LC] ,
--sum([YTD 08Q3LC] ) as [YTD 08Q3LC] ,
--sum([YTD 08Q4LC] ) as [YTD 08Q4LC] ,
--sum([YTD 09Q1LC] ) as [YTD 09Q1LC] ,
--sum([YTD 09Q2LC] ) as [YTD 09Q2LC] ,
--sum([YTD 09Q3LC] ) as [YTD 09Q3LC] ,
--sum([YTD 09Q4LC] ) as [YTD 09Q4LC] ,
--sum([YTD 10Q1LC] ) as [YTD 10Q1LC] ,
--sum([YTD 10Q2LC] ) as [YTD 10Q2LC] ,
--sum([YTD 10Q3LC] ) as [YTD 10Q3LC] ,
--sum([YTD 10Q4LC] ) as [YTD 10Q4LC] ,
--sum([YTD 11Q1LC] ) as [YTD 11Q1LC] ,
--sum([YTD 11Q2LC] ) as [YTD 11Q2LC] ,
--sum([YTD 11Q3LC] ) as [YTD 11Q3LC] ,
--sum([YTD 11Q4LC] ) as [YTD 11Q4LC] ,
--sum([YTD 12Q1LC] ) as [YTD 12Q1LC] ,
--sum([YTD 12Q2LC] ) as [YTD 12Q2LC] ,
--sum([YTD 12Q3LC] ) as [YTD 12Q3LC] ,
--sum([YTD 12Q4LC] ) as [YTD 12Q4LC] ,
--sum([YTD 13Q1LC] ) as [YTD 13Q1LC] ,
--sum([YTD 13Q2LC] ) as [YTD 13Q2LC] ,
--sum([YTD 13Q3LC]) as [YTD 13Q3LC] --to
--into temp_inHKAPI_Linda
--from inHKAPI_Linda	
--group by [Company Name],[Product Name],TA,[Therapeutic Class]

--drop table inHKAPI_Linda

--select * into inHKAPI_Linda from temp_inHKAPI_Linda


----****************************************


update inHKAPI_Linda set 
	[10Q1LC]= [YTD 10Q1LC],
	[10Q2LC]= [YTD 10Q2LC]- [YTD 10Q1LC],
	[10Q3LC]= [YTD 10Q3LC]- [YTD 10Q2LC],
	[10Q4LC]= [YTD 10Q4LC]- [YTD 10Q3LC],
	[11Q1LC]= [YTD 11Q1LC],
	[11Q2LC]= [YTD 11Q2LC]- [YTD 11Q1LC],
	[11Q3LC]= [YTD 11Q3LC]- [YTD 11Q2LC],
	[11Q4LC]= [YTD 11Q4LC]- [YTD 11Q3LC],
	[12Q1LC]= [YTD 12Q1LC],
	[12Q2LC]= [YTD 12Q2LC]- [YTD 12Q1LC],
	[12Q3LC]= [YTD 12Q3LC]- [YTD 12Q2LC],
	[12Q4LC]= [YTD 12Q4LC]- [YTD 12Q3LC],
	[13Q1LC]= [YTD 13Q1LC],
	[13Q2LC]= [YTD 13Q2LC]- [YTD 13Q1LC],
	[13Q3LC]= [YTD 13Q3LC]- [YTD 13Q2LC]
	--todo
go
Alter table inHKAPI_Linda
add [06Q1US] float null default 0
      ,[06Q2US] float null default 0
      ,[06Q3US] float null default 0
      ,[06Q4US] float null default 0
      ,[07Q1US] float null default 0
      ,[07Q2US] float null default 0
      ,[07Q3US] float null default 0
      ,[07Q4US] float null default 0
      ,[08Q1US] float null default 0
      ,[08Q2US] float null default 0
      ,[08Q3US] float null default 0
      ,[08Q4US] float null default 0
      ,[09Q1US] float null default 0
      ,[09Q2US] float null default 0
      ,[09Q3US] float null default 0
      ,[09Q4US] float null default 0
      ,[10Q1US] float null default 0
      ,[10Q2US] float null default 0
      ,[10Q3US] float null default 0
      ,[10Q4US] float null default 0
      ,[11Q1US] float null default 0
      ,[11Q2US] float null default 0
      ,[11Q3US] float null default 0
      ,[11Q4US] float null default 0
      ,[12Q1US] float null default 0
      ,[12Q2US] float null default 0
      ,[12Q3US] float null default 0
      ,[12Q4US] float null default 0
	  ,[13Q1US] float null default 0
	  ,[13Q2US] float null default 0
	  ,[13Q3US] float null default 0
	  --todo
go
update inHKAPI_Linda
set [06Q1US]=A.[06Q1LC]/B.Rate
      ,[06Q2US]=A.[06Q2LC]/B.Rate
      ,[06Q3US]=A.[06Q3LC]/B.Rate
      ,[06Q4US]=A.[06Q4LC]/B.Rate
      ,[07Q1US]=A.[07Q1LC]/B.Rate
      ,[07Q2US]=A.[07Q2LC]/B.Rate
      ,[07Q3US]=A.[07Q3LC]/B.Rate
      ,[07Q4US]=A.[07Q4LC]/B.Rate
      ,[08Q1US]=A.[08Q1LC]/B.Rate
      ,[08Q2US]=A.[08Q2LC]/B.Rate
      ,[08Q3US]=A.[08Q3LC]/B.Rate
      ,[08Q4US]=A.[08Q4LC]/B.Rate
      ,[09Q1US]=A.[09Q1LC]/B.Rate
      ,[09Q2US]=A.[09Q2LC]/B.Rate
      ,[09Q3US]=A.[09Q3LC]/B.Rate
      ,[09Q4US]=A.[09Q4LC]/B.Rate
      ,[10Q1US]=A.[10Q1LC]/B.Rate
      ,[10Q2US]=A.[10Q2LC]/B.Rate
      ,[10Q3US]=A.[10Q3LC]/B.Rate
      ,[10Q4US]=A.[10Q4LC]/B.Rate
      ,[11Q1US]=A.[11Q1LC]/B.Rate
      ,[11Q2US]=A.[11Q2LC]/B.Rate
      ,[11Q3US]=A.[11Q3LC]/B.Rate 
      ,[11Q4US]=A.[11Q4LC]/B.Rate
      ,[12Q1US]=A.[12Q1LC]/B.Rate
      ,[12Q2US]=A.[12Q2LC]/B.Rate
      ,[12Q3US]=A.[12Q3LC]/B.Rate 
      ,[12Q4US]=A.[12Q4LC]/B.Rate  
	  ,[13Q1US]=A.[13Q1LC]/B.Rate  
	  ,[13Q2US]=A.[13Q2LC]/B.Rate  
	  ,[13Q3US]=A.[13Q3LC]/B.Rate  
	  --todo
from inHKAPI_Linda A,IMSDBPlus_201109.dbo.tblRate B
go

select * from inHKAPI_Linda
where [Product name] like '%gli%' or [Product name] like 'sp%'

if object_id(N'inHKAPI_New_bak',N'U') is not null
	drop table inHKAPI_New_bak
select * into dbo.inHKAPI_New_bak from dbo.inHKAPI_Linda

if object_id(N'inHKAPI_New',N'U') is not null
	drop table inHKAPI_New
select * into dbo.inHKAPI_New from dbo.inHKAPI_Linda

--todo
if object_id(N'inHKAPI_2013Q3',N'U') is not null
	drop table inHKAPI_2013Q3
select * into dbo.inHKAPI_2013Q3 from dbo.inHKAPI_Linda

/*
select *
 from inHKAPI_New A where  exists(select * from 
IMSDBPlus_201109.dbo.tblMktDef_MRBIChina B
where A.[Product Name]=B.productname)

select distinct [Company name] from dbo.inHKAPI_New A where [Company name] not in (select Abbreviation
from dbo.HKAPI_CompanyName)

insert into HKAPI_CompanyName values('DSC','DAIICHI SANKYO PHARMA')
select * from HKAPI_CompanyName

use IMSDB2US
go
select * into dbo.inHKAPI from BMSChinaOtherDB.dbo.inHKAPI_New
select * into dbo.HKAPI_CompanyName from BMSChinaOtherDB.dbo.HKAPI_CompanyName
select * into dbo.MTHCHPA_PKAU from IMSDBPlus_201109.dbo.MTHCHPA_PKAU
select * into dbo.MTHCITY_PKAU from IMSDBPlus_201109.dbo.MTHCITY_PKAU

*/