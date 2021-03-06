/****** Script for SelectTopNRows command from SSMS  ******/
select * from BMSChinaCIA_IMS.DBO.L01_L02_01
drop table BMSChinaCIA_IMS.DBO.L01_L02_01
SELECT rtrim(c.product_name)+space(19-len(c.product_name))+ltrim(manufacturer_abbr) as product_name,a.atc3_cod,a.atc4_cod,
	  sum(MTH01LC) as MTH01RMB
      ,sum(MTH02LC) as MTH02RMB
      ,sum(MTH03LC) as MTH03RMB
      ,sum(MTH04LC) as MTH04RMB
      ,sum(MTH05LC) as MTH05RMB
      ,sum(MTH06LC) as MTH06RMB
      ,sum(MTH07LC) as MTH07RMB
      ,sum(MTH08LC) as MTH08RMB
      ,sum(MTH09LC) as MTH09RMB
      ,sum(MTH10LC) as MTH10RMB
      ,sum(MTH11LC) as MTH11RMB
      ,sum(MTH12LC) as MTH12RMB
      ,sum(MTH13LC) as MTH13RMB
      ,sum(MTH14LC) as MTH14RMB
      ,sum(MTH15LC) as MTH15RMB
      ,sum(MTH16LC) as MTH16RMB
      ,sum(MTH17LC) as MTH17RMB
      ,sum(MTH18LC) as MTH18RMB
      ,sum(MTH19LC) as MTH19RMB
      ,sum(MTH20LC) as MTH20RMB
      ,sum(MTH21LC) as MTH21RMB
      ,sum(MTH22LC) as MTH22RMB
      ,sum(MTH23LC) as MTH23RMB
      ,sum(MTH24LC) as MTH24RMB
      ,sum(MTH25LC) as MTH25RMB
      ,sum(MTH26LC) as MTH26RMB
      ,sum(MTH27LC) as MTH27RMB
      ,sum(MTH28LC) as MTH28RMB
      ,sum(MTH29LC) as MTH29RMB
      ,sum(MTH30LC) as MTH30RMB
      ,sum(MTH31LC) as MTH31RMB
      ,sum(MTH32LC) as MTH32RMB
      ,sum(MTH33LC) as MTH33RMB
      ,sum(MTH34LC) as MTH34RMB
      ,sum(MTH35LC) as MTH35RMB
      ,sum(MTH36LC) as MTH36RMB
      ,sum(MTH37LC) as MTH37RMB
      ,sum(MTH38LC) as MTH38RMB
      ,sum(MTH39LC) as MTH39RMB
      ,sum(MTH40LC) as MTH40RMB
      ,sum(MTH41LC) as MTH41RMB
      ,sum(MTH42LC) as MTH42RMB
      ,sum(MTH43LC) as MTH43RMB
      ,sum(MTH44LC) as MTH44RMB
      ,sum(MTH45LC) as MTH45RMB
      ,sum(MTH46LC) as MTH46RMB
      ,sum(MTH47LC) as MTH47RMB
      ,sum(MTH48LC) as MTH48RMB
      ,sum(MTH49LC) as MTH49RMB
      ,sum(MTH50LC) as MTH50RMB

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

	  ,sum(MTH01UN) as MTH01UNIT
      ,sum(MTH02UN) as MTH02UNIT
      ,sum(MTH03UN) as MTH03UNIT
      ,sum(MTH04UN) as MTH04UNIT
      ,sum(MTH05UN) as MTH05UNIT
      ,sum(MTH06UN) as MTH06UNIT
      ,sum(MTH07UN) as MTH07UNIT
      ,sum(MTH08UN) as MTH08UNIT
      ,sum(MTH09UN) as MTH09UNIT
      ,sum(MTH10UN) as MTH10UNIT
      ,sum(MTH11UN) as MTH11UNIT
      ,sum(MTH12UN) as MTH12UNIT
      ,sum(MTH13UN) as MTH13UNIT
      ,sum(MTH14UN) as MTH14UNIT
      ,sum(MTH15UN) as MTH15UNIT
      ,sum(MTH16UN) as MTH16UNIT
      ,sum(MTH17UN) as MTH17UNIT
      ,sum(MTH18UN) as MTH18UNIT
      ,sum(MTH19UN) as MTH19UNIT
      ,sum(MTH20UN) as MTH20UNIT
      ,sum(MTH21UN) as MTH21UNIT
      ,sum(MTH22UN) as MTH22UNIT
      ,sum(MTH23UN) as MTH23UNIT
      ,sum(MTH24UN) as MTH24UNIT
      ,sum(MTH25UN) as MTH25UNIT
      ,sum(MTH26UN) as MTH26UNIT
      ,sum(MTH27UN) as MTH27UNIT
      ,sum(MTH28UN) as MTH28UNIT
      ,sum(MTH29UN) as MTH29UNIT
      ,sum(MTH30UN) as MTH30UNIT
      ,sum(MTH31UN) as MTH31UNIT
      ,sum(MTH32UN) as MTH32UNIT
      ,sum(MTH33UN) as MTH33UNIT
      ,sum(MTH34UN) as MTH34UNIT
      ,sum(MTH35UN) as MTH35UNIT
      ,sum(MTH36UN) as MTH36UNIT
      ,sum(MTH37UN) as MTH37UNIT
      ,sum(MTH38UN) as MTH38UNIT
      ,sum(MTH39UN) as MTH39UNIT
      ,sum(MTH40UN) as MTH40UNIT
      ,sum(MTH41UN) as MTH41UNIT
      ,sum(MTH42UN) as MTH42UNIT
      ,sum(MTH43UN) as MTH43UNIT
      ,sum(MTH44UN) as MTH44UNIT
      ,sum(MTH45UN) as MTH45UNIT
      ,sum(MTH46UN) as MTH46UNIT
      ,sum(MTH47UN) as MTH47UNIT
      ,sum(MTH48UN) as MTH48UNIT
      ,sum(MTH49UN) as MTH49UNIT
      ,sum(MTH50UN) as MTH50UNIT

into BMSChinaCIA_IMS.DBO.L01_L02_01
  FROM [BMSChinaCIARawdata].[dbo].[MTHCHPA_PKAU_201302] a
  inner join BMSChinaCIARawdata.dbo.Dim_Pack_201302 b
  on a.pack_id = b.pack_id
  inner join BMSChinaCIARawdata.dbo.Dim_Product_201302 c
  on b.product_id = c.product_id  
  inner join BMSChinaCIARawdata.dbo.Dim_Manufacturer_201302 d
  on c.[Manufacturer_ID]=d.[Manufacturer_ID]
   where atc2_cod in ('l01','l02')
   group by rtrim(c.product_name)+space(19-len(c.product_name))+ltrim(manufacturer_abbr),a.atc3_cod,a.atc4_cod


   --replace(manufacturer_abbr,'"','')
SELECT rtrim(replace(c.product_name,'"',''))+space(19-len(replace(c.product_name,'"','')))+ltrim(replace(manufacturer_abbr,'"','')) as product_name,a.atc3_cod,a.atc4_cod,
       sum(MTH00LC) as MTH00RMB
	  ,sum(MTH01LC) as MTH01RMB
      ,sum(MTH02LC) as MTH02RMB
      ,sum(MTH03LC) as MTH03RMB
      ,sum(MTH04LC) as MTH04RMB
      ,sum(MTH05LC) as MTH05RMB
      ,sum(MTH06LC) as MTH06RMB
      ,sum(MTH07LC) as MTH07RMB
      ,sum(MTH08LC) as MTH08RMB
      ,sum(MTH09LC) as MTH09RMB
      ,sum(MTH10LC) as MTH10RMB
      ,sum(MTH11LC) as MTH11RMB
      ,sum(MTH12LC) as MTH12RMB
      ,sum(MTH13LC) as MTH13RMB
      ,sum(MTH14LC) as MTH14RMB
      ,sum(MTH15LC) as MTH15RMB
      ,sum(MTH16LC) as MTH16RMB
      ,sum(MTH17LC) as MTH17RMB
      ,sum(MTH18LC) as MTH18RMB
      ,sum(MTH19LC) as MTH19RMB
      ,sum(MTH20LC) as MTH20RMB
      ,sum(MTH21LC) as MTH21RMB
      ,sum(MTH22LC) as MTH22RMB
      ,sum(MTH23LC) as MTH23RMB
      ,sum(MTH24LC) as MTH24RMB
      ,sum(MTH25LC) as MTH25RMB
      ,sum(MTH26LC) as MTH26RMB
      ,sum(MTH27LC) as MTH27RMB
      ,sum(MTH28LC) as MTH28RMB
      ,sum(MTH29LC) as MTH29RMB
      ,sum(MTH30LC) as MTH30RMB
      ,sum(MTH31LC) as MTH31RMB
      ,sum(MTH32LC) as MTH32RMB
      ,sum(MTH33LC) as MTH33RMB
      ,sum(MTH34LC) as MTH34RMB
      ,sum(MTH35LC) as MTH35RMB
      ,sum(MTH36LC) as MTH36RMB
	  ,sum(MTH37LC) as MTH37RMB
	  ,sum(MTH38LC) as MTH38RMB

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

      ,sum(MTH00UN) as MTH00UNIT
	  ,sum(MTH01UN) as MTH01UNIT
      ,sum(MTH02UN) as MTH02UNIT
      ,sum(MTH03UN) as MTH03UNIT
      ,sum(MTH04UN) as MTH04UNIT
      ,sum(MTH05UN) as MTH05UNIT
      ,sum(MTH06UN) as MTH06UNIT
      ,sum(MTH07UN) as MTH07UNIT
      ,sum(MTH08UN) as MTH08UNIT
      ,sum(MTH09UN) as MTH09UNIT
      ,sum(MTH10UN) as MTH10UNIT
      ,sum(MTH11UN) as MTH11UNIT
      ,sum(MTH12UN) as MTH12UNIT
      ,sum(MTH13UN) as MTH13UNIT
      ,sum(MTH14UN) as MTH14UNIT
      ,sum(MTH15UN) as MTH15UNIT
      ,sum(MTH16UN) as MTH16UNIT
      ,sum(MTH17UN) as MTH17UNIT
      ,sum(MTH18UN) as MTH18UNIT
      ,sum(MTH19UN) as MTH19UNIT
      ,sum(MTH20UN) as MTH20UNIT
      ,sum(MTH21UN) as MTH21UNIT
      ,sum(MTH22UN) as MTH22UNIT
      ,sum(MTH23UN) as MTH23UNIT
      ,sum(MTH24UN) as MTH24UNIT
      ,sum(MTH25UN) as MTH25UNIT
      ,sum(MTH26UN) as MTH26UNIT
      ,sum(MTH27UN) as MTH27UNIT
      ,sum(MTH28UN) as MTH28UNIT
      ,sum(MTH29UN) as MTH29UNIT
      ,sum(MTH30UN) as MTH30UNIT
      ,sum(MTH31UN) as MTH31UNIT
      ,sum(MTH32UN) as MTH32UNIT
      ,sum(MTH33UN) as MTH33UNIT
      ,sum(MTH34UN) as MTH34UNIT
      ,sum(MTH35UN) as MTH35UNIT
      ,sum(MTH36UN) as MTH36UNIT
	  ,sum(MTH37UN) as MTH37UNIT
	  ,sum(MTH38UN) as MTH38UNIT
into L01_L02_02
	  FROM MTHCHPA_PKAU A
  inner join BMSChinaCIARawdata.dbo.Dim_Pack_201605 b
  on a.pack_id = b.pack_id
  inner join BMSChinaCIARawdata.dbo.Dim_Product_201605 c
  on b.product_id = c.product_id  
   inner join BMSChinaCIARawdata.dbo.Dim_Manufacturer_201605 d
  on c.[Manufacturer_ID]=d.[Manufacturer_ID]
   where atc2_cod in ('l01','l02')
   group by rtrim(replace(c.product_name,'"',''))+space(19-len(replace(c.product_name,'"','')))+ltrim(replace(manufacturer_abbr,'"','')),a.atc3_cod,a.atc4_cod



   select case when a.product_name is null then b.product_name else a.product_name end as product_name,case when a.atc3_cod is null then b.atc3_cod else a.atc3_cod end as atc3_cod,case when a.atc4_cod is null then b.atc4_cod else a.atc4_cod end as atc4_cod

,b.MTH50RMB
,b.MTH49RMB
,b.MTH48RMB
,b.MTH47RMB
,b.MTH46RMB
,b.MTH45RMB
,b.MTH44RMB
,b.MTH43RMB
,b.MTH42RMB
,b.MTH41RMB
,b.MTH40RMB
,b.MTH39RMB
,b.MTH38RMB
,b.MTH37RMB
,b.MTH36RMB
,b.MTH35RMB
,b.MTH34RMB
,b.MTH33RMB
,b.MTH32RMB
,b.MTH31RMB
,b.MTH30RMB
,b.MTH29RMB
,b.MTH28RMB
,b.MTH27RMB
,b.MTH26RMB
,b.MTH25RMB
,b.MTH24RMB
,b.MTH23RMB
,b.MTH22RMB
,b.MTH21RMB
,b.MTH20RMB
,b.MTH19RMB
,b.MTH18RMB
,b.MTH17RMB
,b.MTH16RMB
,b.MTH15RMB
,b.MTH14RMB
,b.MTH13RMB
,b.MTH12RMB
,b.MTH11RMB
,b.MTH10RMB
,b.MTH09RMB
,b.MTH08RMB
,b.MTH07RMB
,b.MTH06RMB
,b.MTH05RMB
,b.MTH04RMB
,b.MTH03RMB
,b.MTH02RMB
,b.MTH01RMB
,a.MTH38RMB 
,a.MTH37RMB 
,a.MTH36RMB 
,a.MTH35RMB
,a.MTH34RMB
,a.MTH33RMB
,a.MTH32RMB
,a.MTH31RMB
,a.MTH30RMB
,a.MTH29RMB
,a.MTH28RMB
,a.MTH27RMB
,a.MTH26RMB
,a.MTH25RMB
,a.MTH24RMB
,a.MTH23RMB
,a.MTH22RMB
,a.MTH21RMB
,a.MTH20RMB
,a.MTH19RMB
,a.MTH18RMB
,a.MTH17RMB
,a.MTH16RMB
,a.MTH15RMB
,a.MTH14RMB
,a.MTH13RMB
,a.MTH12RMB
,a.MTH11RMB
,a.MTH10RMB
,a.MTH09RMB
,a.MTH08RMB
,a.MTH07RMB
,a.MTH06RMB
,a.MTH05RMB
,a.MTH04RMB
,a.MTH03RMB
,a.MTH02RMB
,a.MTH01RMB
,a.MTH00RMB

,b.MTH50UNIT
,b.MTH49UNIT
,b.MTH48UNIT
,b.MTH47UNIT
,b.MTH46UNIT
,b.MTH45UNIT
,b.MTH44UNIT
,b.MTH43UNIT
,b.MTH42UNIT
,b.MTH41UNIT
,b.MTH40UNIT
,b.MTH39UNIT
,b.MTH38UNIT
,b.MTH37UNIT
,b.MTH36UNIT
,b.MTH35UNIT
,b.MTH34UNIT
,b.MTH33UNIT
,b.MTH32UNIT
,b.MTH31UNIT
,b.MTH30UNIT
,b.MTH29UNIT
,b.MTH28UNIT
,b.MTH27UNIT
,b.MTH26UNIT
,b.MTH25UNIT
,b.MTH24UNIT
,b.MTH23UNIT
,b.MTH22UNIT
,b.MTH21UNIT
,b.MTH20UNIT
,b.MTH19UNIT
,b.MTH18UNIT
,b.MTH17UNIT
,b.MTH16UNIT
,b.MTH15UNIT
,b.MTH14UNIT
,b.MTH13UNIT
,b.MTH12UNIT
,b.MTH11UNIT
,b.MTH10UNIT
,b.MTH09UNIT
,b.MTH08UNIT
,b.MTH07UNIT
,b.MTH06UNIT
,b.MTH05UNIT
,b.MTH04UNIT
,b.MTH03UNIT
,b.MTH02UNIT
,b.MTH01UNIT
,a.MTH38UNIT 
,a.MTH37UNIT 
,a.MTH36UNIT 
,a.MTH35UNIT
,a.MTH34UNIT
,a.MTH33UNIT
,a.MTH32UNIT
,a.MTH31UNIT
,a.MTH30UNIT
,a.MTH29UNIT
,a.MTH28UNIT
,a.MTH27UNIT
,a.MTH26UNIT
,a.MTH25UNIT
,a.MTH24UNIT
,a.MTH23UNIT
,a.MTH22UNIT
,a.MTH21UNIT
,a.MTH20UNIT
,a.MTH19UNIT
,a.MTH18UNIT
,a.MTH17UNIT
,a.MTH16UNIT
,a.MTH15UNIT
,a.MTH14UNIT
,a.MTH13UNIT
,a.MTH12UNIT
,a.MTH11UNIT
,a.MTH10UNIT
,a.MTH09UNIT
,a.MTH08UNIT
,a.MTH07UNIT
,a.MTH06UNIT
,a.MTH05UNIT
,a.MTH04UNIT
,a.MTH03UNIT
,a.MTH02UNIT
,a.MTH01UNIT
,a.MTH00UNIT

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
,b.MTH19USD
,b.MTH18USD
,b.MTH17USD
,b.MTH16USD
,b.MTH15USD
,b.MTH14USD
,b.MTH13USD
,b.MTH12USD
,b.MTH11USD
,b.MTH10USD
,b.MTH09USD
,b.MTH08USD
,b.MTH07USD
,b.MTH06USD
,b.MTH05USD
,b.MTH04USD
,b.MTH03USD
,b.MTH02USD
,b.MTH01USD
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
   
   SELECT *
      from L01_L02_02 a
   full join L01_L02_01 b
   on a.product_name=b.product_name 