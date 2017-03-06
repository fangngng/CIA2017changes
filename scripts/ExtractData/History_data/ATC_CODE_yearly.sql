/****** Script for SelectTopNRows command from SSMS  ******/
USE BMSChinaCIA_IMS

--select * from BMSChinaCIA_IMS.DBO.L01_L02_01
drop table BMSChinaCIA_IMS.DBO.L01_L02_01
drop table BMSChinaCIA_IMS.DBO.L01_L02_02
SELECT rtrim(c.product_name)+space(19-len(c.product_name))+ltrim(manufacturer_abbr) as product_name,a.atc3_cod,a.atc4_cod

      ,sum(MTH20US) as MTH20USD
      ,sum(MTH21US) as MTH21USD
      ,sum(MTH22US) as MTH22USD
      ,sum(MTH23US) as MTH23USD
      ,sum(MTH24US) as MTH24USD
      ,sum(MTH25US) as MTH25USD
      ,sum(MTH26US) as MTH26USD
      ,sum(MTH27US) as MTH27USD
      ,sum(MTH28US) as MTH28USD
      ,sum(MTH29US) as MTH29USD
      ,sum(MTH30US) as MTH30USD
      ,sum(MTH31US) as MTH31USD
      ,sum(MTH32US) as MTH32USD
      ,sum(MTH33US) as MTH33USD
      ,sum(MTH34US) as MTH34USD
      ,sum(MTH35US) as MTH35USD
      ,sum(MTH36US) as MTH36USD
      ,sum(MTH37US) as MTH37USD
      ,sum(MTH38US) as MTH38USD
      ,sum(MTH39US) as MTH39USD
      ,sum(MTH40US) as MTH40USD
      ,sum(MTH41US) as MTH41USD
      ,sum(MTH42US) as MTH42USD
      ,sum(MTH43US) as MTH43USD
      ,sum(MTH44US) as MTH44USD
      ,sum(MTH45US) as MTH45USD
      ,sum(MTH46US) as MTH46USD
      ,sum(MTH47US) as MTH47USD
      ,sum(MTH48US) as MTH48USD
      ,sum(MTH49US) as MTH49USD
      ,sum(MTH50US) as MTH50USD
      ,sum(MTH51US) as MTH51usd
      ,sum(MTH52US) as MTH52USD
      ,sum(MTH53US) as MTH53USD
      ,sum(MTH54US) as MTH54USD
      ,sum(MTH55US) as MTH55USD
      ,sum(MTH56US) as MTH56USD
      ,sum(MTH57US) as MTH57USD
      ,sum(MTH58US) as MTH58USD
      ,sum(MTH59US) as MTH59USD
      ,sum(MTH60US) as MTH60USD



into BMSChinaCIA_IMS.DBO.L01_L02_01
  FROM [BMSChinaCIARawdata].[dbo].[MTHCHPA_PKAU_201302] a
  inner join BMSChinaCIARawdata.dbo.Dim_Pack_201302 b
  on a.pack_id = b.pack_id
  inner join BMSChinaCIARawdata.dbo.Dim_Product_201302 c
  on b.product_id = c.product_id  
  inner join BMSChinaCIARawdata.dbo.Dim_Manufacturer_201302 d
  on c.[Manufacturer_ID]=d.[Manufacturer_ID]
   --where atc2_cod in ('l01','l02')
   group by rtrim(c.product_name)+space(19-len(c.product_name))+ltrim(manufacturer_abbr),a.atc3_cod,a.atc4_cod

--total
insert into BMSChinaCIA_IMS.DBO.L01_L02_01
SELECT 'China' as product_name,'',''

      ,sum(MTH20US) as MTH20USD
      ,sum(MTH21US) as MTH21USD
      ,sum(MTH22US) as MTH22USD
      ,sum(MTH23US) as MTH23USD
      ,sum(MTH24US) as MTH24USD
      ,sum(MTH25US) as MTH25USD
      ,sum(MTH26US) as MTH26USD
      ,sum(MTH27US) as MTH27USD
      ,sum(MTH28US) as MTH28USD
      ,sum(MTH29US) as MTH29USD
      ,sum(MTH30US) as MTH30USD
      ,sum(MTH31US) as MTH31USD
      ,sum(MTH32US) as MTH32USD
      ,sum(MTH33US) as MTH33USD
      ,sum(MTH34US) as MTH34USD
      ,sum(MTH35US) as MTH35USD
      ,sum(MTH36US) as MTH36USD
      ,sum(MTH37US) as MTH37USD
      ,sum(MTH38US) as MTH38USD
      ,sum(MTH39US) as MTH39USD
      ,sum(MTH40US) as MTH40USD
      ,sum(MTH41US) as MTH41USD
      ,sum(MTH42US) as MTH42USD
      ,sum(MTH43US) as MTH43USD
      ,sum(MTH44US) as MTH44USD
      ,sum(MTH45US) as MTH45USD
      ,sum(MTH46US) as MTH46USD
      ,sum(MTH47US) as MTH47USD
      ,sum(MTH48US) as MTH48USD
      ,sum(MTH49US) as MTH49USD
      ,sum(MTH50US) as MTH50USD
      ,sum(MTH51US) as MTH51usd
      ,sum(MTH52US) as MTH52USD
      ,sum(MTH53US) as MTH53USD
      ,sum(MTH54US) as MTH54USD
      ,sum(MTH55US) as MTH55USD
      ,sum(MTH56US) as MTH56USD
      ,sum(MTH57US) as MTH57USD
      ,sum(MTH58US) as MTH58USD
      ,sum(MTH59US) as MTH59USD
      ,sum(MTH60US) as MTH60USD



  FROM [BMSChinaCIARawdata].[dbo].[MTHCHPA_PKAU_201302] a
  inner join BMSChinaCIARawdata.dbo.Dim_Pack_201302 b
  on a.pack_id = b.pack_id
  inner join BMSChinaCIARawdata.dbo.Dim_Product_201302 c
  on b.product_id = c.product_id  
  inner join BMSChinaCIARawdata.dbo.Dim_Manufacturer_201302 d
  on c.[Manufacturer_ID]=d.[Manufacturer_ID]




   --replace(manufacturer_abbr,'"','')
SELECT rtrim(replace(c.product_name,'"',''))+space(19-len(replace(c.product_name,'"','')))+ltrim(replace(manufacturer_abbr,'"','')) as product_name,a.atc3_cod,a.atc4_cod
    
	  ,sum(MTH00US) as MTH00USD
	  ,sum(MTH01US) as MTH01USD
      ,sum(MTH02US) as MTH02USD
      ,sum(MTH03US) as MTH03USD
      ,sum(MTH04US) as MTH04USD
      ,sum(MTH05US) as MTH05USD
      ,sum(MTH06US) as MTH06USD
      ,sum(MTH07US) as MTH07USD
      ,sum(MTH08US) as MTH08USD
      ,sum(MTH09US) as MTH09USD
      ,sum(MTH10US) as MTH10USD
      ,sum(MTH11US) as MTH11USD
      ,sum(MTH12US) as MTH12USD
      ,sum(MTH13US) as MTH13USD
      ,sum(MTH14US) as MTH14USD
      ,sum(MTH15US) as MTH15USD
      ,sum(MTH16US) as MTH16USD
      ,sum(MTH17US) as MTH17USD
      ,sum(MTH18US) as MTH18USD
      ,sum(MTH19US) as MTH19USD
      ,sum(MTH20US) as MTH20USD
      ,sum(MTH21US) as MTH21USD
      ,sum(MTH22US) as MTH22USD
      ,sum(MTH23US) as MTH23USD
      ,sum(MTH24US) as MTH24USD
      ,sum(MTH25US) as MTH25USD
      ,sum(MTH26US) as MTH26USD
      ,sum(MTH27US) as MTH27USD
      ,sum(MTH28US) as MTH28USD
      ,sum(MTH29US) as MTH29USD
      ,sum(MTH30US) as MTH30USD
      ,sum(MTH31US) as MTH31USD
      ,sum(MTH32US) as MTH32USD
      ,sum(MTH33US) as MTH33USD
      ,sum(MTH34US) as MTH34USD
      ,sum(MTH35US) as MTH35USD
      ,sum(MTH36US) as MTH36USD
	  ,sum(MTH37US) as MTH37USD
	  ,sum(MTH38US) as MTH38USD
      ,sum(MTH39US) as MTH39USD
      ,sum(MTH40US) as MTH40USD
      ,sum(MTH41US) as MTH41USD
      ,sum(MTH42US) as MTH42USD
      ,sum(MTH43US) as MTH43USD
      ,sum(MTH44US) as MTH44USD
      ,sum(MTH45US) as MTH45USD
      ,sum(MTH46US) as MTH46USD
      ,sum(MTH47US) as MTH47USD
      ,sum(MTH48US) as MTH48USD
      ,sum(MTH49US) as MTH49USD
      ,sum(MTH50US) as MTH50USD
      ,sum(MTH51US) as MTH51USD
      ,sum(MTH52US) as MTH52USD
      ,sum(MTH53US) as MTH53USD
      ,sum(MTH54US) as MTH54USD
      ,sum(MTH55US) as MTH55USD
      ,sum(MTH56US) as MTH56USD
      ,sum(MTH57US) as MTH57USD
	  ,sum(MTH58US) as MTH58USD
	  ,sum(MTH59US) as MTH59USD

--into L01_L02_02
	  FROM MTHCHPA_PKAU A
  inner join BMSChinaCIARawdata.dbo.Dim_Pack_201607 b--todo
  on a.pack_id = b.pack_id
  inner join BMSChinaCIARawdata.dbo.Dim_Product_201607 c
  on b.product_id = c.product_id  
   inner join BMSChinaCIARawdata.dbo.Dim_Manufacturer_201607 d
  on c.[Manufacturer_ID]=d.[Manufacturer_ID]
   --where atc2_cod in ('l01','l02')
   group by rtrim(replace(c.product_name,'"',''))+space(19-len(replace(c.product_name,'"','')))+ltrim(replace(manufacturer_abbr,'"','')),a.atc3_cod,a.atc4_cod

--total
insert into L01_L02_02
SELECT 'China' as product_name,'',''
    
	  ,sum(MTH00US) as MTH00USD
	  ,sum(MTH01US) as MTH01USD
      ,sum(MTH02US) as MTH02USD
      ,sum(MTH03US) as MTH03USD
      ,sum(MTH04US) as MTH04USD
      ,sum(MTH05US) as MTH05USD
      ,sum(MTH06US) as MTH06USD
      ,sum(MTH07US) as MTH07USD
      ,sum(MTH08US) as MTH08USD
      ,sum(MTH09US) as MTH09USD
      ,sum(MTH10US) as MTH10USD
      ,sum(MTH11US) as MTH11USD
      ,sum(MTH12US) as MTH12USD
      ,sum(MTH13US) as MTH13USD
      ,sum(MTH14US) as MTH14USD
      ,sum(MTH15US) as MTH15USD
      ,sum(MTH16US) as MTH16USD
      ,sum(MTH17US) as MTH17USD
      ,sum(MTH18US) as MTH18USD
      ,sum(MTH19US) as MTH19USD
      ,sum(MTH20US) as MTH20USD
      ,sum(MTH21US) as MTH21USD
      ,sum(MTH22US) as MTH22USD
      ,sum(MTH23US) as MTH23USD
      ,sum(MTH24US) as MTH24USD
      ,sum(MTH25US) as MTH25USD
      ,sum(MTH26US) as MTH26USD
      ,sum(MTH27US) as MTH27USD
      ,sum(MTH28US) as MTH28USD
      ,sum(MTH29US) as MTH29USD
      ,sum(MTH30US) as MTH30USD
      ,sum(MTH31US) as MTH31USD
      ,sum(MTH32US) as MTH32USD
      ,sum(MTH33US) as MTH33USD
      ,sum(MTH34US) as MTH34USD
      ,sum(MTH35US) as MTH35USD
      ,sum(MTH36US) as MTH36USD
	  ,sum(MTH37US) as MTH37USD
	  ,sum(MTH38US) as MTH38USD
      ,sum(MTH39US) as MTH39USD
      ,sum(MTH40US) as MTH40USD
      ,sum(MTH41US) as MTH41USD
      ,sum(MTH42US) as MTH42USD
      ,sum(MTH43US) as MTH43USD
      ,sum(MTH44US) as MTH44USD
      ,sum(MTH45US) as MTH45USD
      ,sum(MTH46US) as MTH46USD
      ,sum(MTH47US) as MTH47USD
      ,sum(MTH48US) as MTH48USD
      ,sum(MTH49US) as MTH49USD
      ,sum(MTH50US) as MTH50USD
      ,sum(MTH51US) as MTH51USD
      ,sum(MTH52US) as MTH52USD
      ,sum(MTH53US) as MTH53USD
      ,sum(MTH54US) as MTH54USD
      ,sum(MTH55US) as MTH55USD
      ,sum(MTH56US) as MTH56USD
      ,sum(MTH57US) as MTH57USD
	  ,sum(MTH58US) as MTH58USD
	  ,sum(MTH59US) as MTH59USD

	  FROM MTHCHPA_PKAU A
  inner join BMSChinaCIARawdata.dbo.Dim_Pack_201607 b
  on a.pack_id = b.pack_id
  inner join BMSChinaCIARawdata.dbo.Dim_Product_201607 c
  on b.product_id = c.product_id  
   inner join BMSChinaCIARawdata.dbo.Dim_Manufacturer_201607 d
  on c.[Manufacturer_ID]=d.[Manufacturer_ID]


--MTH
   select case when a.product_name is null then b.product_name else a.product_name end as product_name,
   case when a.atc3_cod is null then b.atc3_cod else a.atc3_cod end as atc3_cod,
   case when a.atc4_cod is null then b.atc4_cod else a.atc4_cod end as atc4_cod
 
,b.MTH60USD
,b.MTH59USD
,b.MTH58USD
,b.MTH57USD
,b.MTH56USD
,b.MTH55USD
,b.MTH54USD
,b.MTH53USD
,b.MTH52USD
,b.MTH51USD   
,b.MTH50USD
,b.MTH49USD
,b.MTH48USD
,b.MTH47USD
,b.MTH46USD
,b.MTH45USD
,b.MTH44USD
,b.MTH43USD
,b.MTH42USD
,b.MTH41USD
,b.MTH40USD
,b.MTH39USD
,b.MTH38USD
,b.MTH37USD
,b.MTH36USD
,b.MTH35USD
,b.MTH34USD
,b.MTH33USD
,b.MTH32USD
,b.MTH31USD
,b.MTH30USD
,b.MTH29USD
,b.MTH28USD
,b.MTH27USD
,b.MTH26USD
,b.MTH25USD
,b.MTH24USD
,b.MTH23USD
,b.MTH22USD
,b.MTH21USD
,b.MTH20USD

,a.MTH59USD 
,a.MTH58USD 
,a.MTH57USD 
,a.MTH56USD 
,a.MTH55USD
,a.MTH54USD
,a.MTH53USD
,a.MTH52USD
,a.MTH51USD
,a.MTH50USD
,a.MTH49USD
,a.MTH48USD
,a.MTH47USD
,a.MTH46USD
,a.MTH45USD
,a.MTH44USD
,a.MTH43USD
,a.MTH42USD
,a.MTH41USD
,a.MTH40USD
,a.MTH39USD
,a.MTH38USD 
,a.MTH37USD 
,a.MTH36USD 
,a.MTH35USD
,a.MTH34USD
,a.MTH33USD
,a.MTH32USD
,a.MTH31USD
,a.MTH30USD
,a.MTH29USD
,a.MTH28USD
,a.MTH27USD
,a.MTH26USD
,a.MTH25USD
,a.MTH24USD
,a.MTH23USD
,a.MTH22USD
,a.MTH21USD
,a.MTH20USD
,a.MTH19USD
,a.MTH18USD
,a.MTH17USD
,a.MTH16USD
,a.MTH15USD
,a.MTH14USD
,a.MTH13USD
,a.MTH12USD
,a.MTH11USD
,a.MTH10USD
,a.MTH09USD
,a.MTH08USD
,a.MTH07USD
,a.MTH06USD
,a.MTH05USD
,a.MTH04USD
,a.MTH03USD
,a.MTH02USD
,a.MTH01USD
,a.MTH00USD

   from L01_L02_02 a
   full join L01_L02_01 b
   on a.product_name=b.product_name 
   AND A.ATC4_COD = B.ATC4_COD
   
drop table L01_L02
   --yearly
  select case when a.product_name is null then b.product_name else a.product_name end as product_name,case when a.atc3_cod is null then b.atc3_cod else a.atc3_cod end as atc3_cod,case when a.atc4_cod is null then b.atc4_cod else a.atc4_cod end as atc4_cod
 
,b.MTH60USD+b.MTH59USD+b.MTH58USD+b.MTH57USD+b.MTH56USD+b.MTH55USD+b.MTH54USD+b.MTH53USD+b.MTH52USD+b.MTH51USD   as year_08
,b.MTH50USD+b.MTH49USD+b.MTH48USD+b.MTH47USD+b.MTH46USD+b.MTH45USD+b.MTH44USD+b.MTH43USD+b.MTH42USD+b.MTH41USD+b.MTH40USD+b.MTH39USD as year_09
,b.MTH38USD+b.MTH37USD+b.MTH36USD+b.MTH35USD+b.MTH34USD+b.MTH33USD+b.MTH32USD+b.MTH31USD+b.MTH30USD+b.MTH29USD+b.MTH28USD+b.MTH27USD as year_10
,b.MTH26USD+b.MTH25USD+b.MTH24USD+b.MTH23USD+b.MTH22USD+b.MTH21USD+b.MTH20USD+a.MTH59USD+a.MTH58USD+a.MTH57USD+a.MTH56USD+a.MTH55USD as year_11
,a.MTH54USD+a.MTH53USD+a.MTH52USD+a.MTH51USD+a.MTH50USD+a.MTH49USD+a.MTH48USD+a.MTH47USD+a.MTH46USD+a.MTH45USD+a.MTH44USD+a.MTH43USD as year_12
,a.MTH42USD+a.MTH41USD+a.MTH40USD+a.MTH39USD+a.MTH38USD+a.MTH37USD+a.MTH36USD+a.MTH35USD+a.MTH34USD+a.MTH33USD+a.MTH32USD+a.MTH31USD as year_13
,a.MTH30USD+a.MTH29USD+a.MTH28USD+a.MTH27USD+a.MTH26USD+a.MTH25USD+a.MTH24USD+a.MTH23USD+a.MTH22USD+a.MTH21USD+a.MTH20USD+a.MTH19USD as year_14
,a.MTH18USD+a.MTH17USD+a.MTH16USD+a.MTH15USD+a.MTH14USD+a.MTH13USD+a.MTH12USD+a.MTH11USD+a.MTH10USD+a.MTH09USD+a.MTH08USD+a.MTH07USD as year_15
,a.MTH06USD+a.MTH05USD+a.MTH04USD+a.MTH03USD+a.MTH02USD+a.MTH01USD+a.MTH00USD as year_16
into L01_L02
   from L01_L02_02 a
   full join L01_L02_01 b
   on a.product_name=b.product_name 

   update L01_L02 set year_08=case when year_08 is null then 0 else year_08	end,year_09=case when year_09 is null then 0 else year_09 end,
					  year_10=case when year_10 is null then 0 else year_10 end,year_11=case when year_11 is null then 0 else year_11 end,
					  year_12 =case when year_12 is null then 0 else year_12 end ,year_13=case when year_13 is null then 0 else year_13 end,
					  year_14 =case when year_14 is null then 0 else year_14 end,year_15 =case when year_15 is null then 0 else year_15 end,
					  year_16 =case when year_16 is null then 0 else year_16 end

select * from L01_L02