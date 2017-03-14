use BMSChinaCIA_IMS_test
GO


exec dbo.sp_Log_Event 'Output','CIA','3_1_Output_D_C160.sql','Start',null,null



truncate table MID_C160_RegionData
GO
insert into MID_C160_RegionData  
SELECT 
 	'Sales' as Type
--       [Molecule]
--      ,[Class]
	,[mkt]
	,[mktname]
	,[Market]
	,[prod]
	,[Productname]
	,[Moneytype]
	,[Audi_cod]
	,[Audi_des]
--      ,[Lev]
	,[Region]
	,sum([R3M00])  [R3M00]
	,sum([R3M01])  [R3M01]
	,sum([R3M02])  [R3M02]
	,sum([R3M03])  [R3M03]
	,sum([R3M04])  [R3M04]
	,sum([R3M05])  [R3M05]
	,sum([R3M06])  [R3M06]
	,sum([R3M07])  [R3M07]
	,sum([R3M08])  [R3M08]
	,sum([R3M09])  [R3M09]
	,sum([R3M10])  [R3M10]
	,sum([R3M11])  [R3M11]
	,sum([R3M12])  [R3M12]
	,sum([R3M13])  [R3M13]
	,sum([R3M14])  [R3M14]
	,sum([R3M15])  [R3M15]
	,sum([R3M16])  [R3M16]
	,sum([R3M17])  [R3M17]
	,sum([R3M18])  [R3M18]
	,sum([R3M19])  [R3M19]
	,sum([R3M20])  [R3M20]
	,sum([R3M21])  [R3M21]
	,sum([R3M22])  [R3M22]
	,sum([R3M23])  [R3M23]
	,sum([R3M24])  [R3M24]
	,sum([R3M25])  [R3M25]
	,sum([R3M26])  [R3M26]
	,sum([R3M27])  [R3M27]
	,sum([R3M28])  [R3M28]
	,sum([R3M29])  [R3M29]
	,sum([R3M30])  [R3M30]
	,sum([R3M31])  [R3M31]
	,sum([R3M32])  [R3M32]
	,sum([R3M33])  [R3M33]
	,sum([R3M34])  [R3M34]
	,sum([R3M35])  [R3M35]
	,sum([R3M36])  [R3M36]
	,sum([R3M37])  [R3M37]
	,sum([R3M38])  [R3M38]
	,sum([R3M39])  [R3M39]
	,sum([R3M40])  [R3M40]
	,sum([R3M41])  [R3M41]
	,sum([R3M42])  [R3M42]
	,sum([R3M43])  [R3M43]
	,sum([R3M44])  [R3M44]
	,sum([R3M45])  [R3M45]
--      ,sum([R3M46])  [R3M46]
--      ,sum([R3M47])  [R3M47]
--      ,sum([R3M48])  [R3M48]
--      ,sum([R3M49])  [R3M49]
--      ,sum([R3M50])  [R3M50]
--      ,sum([R3M51])  [R3M51]
--      ,sum([R3M52])  [R3M52]
--      ,sum([R3M53])  [R3M53]
--      ,sum([R3M54])  [R3M54]
--      ,sum([R3M55])  [R3M55]
--      ,sum([R3M56])  [R3M56]
--      ,sum([R3M57])  [R3M57]
	,sum([MTH00])  [MTH00]
	,sum([MTH01])  [MTH01]
	,sum([MTH02])  [MTH02]
	,sum([MTH03])  [MTH03]
	,sum([MTH04])  [MTH04]
	,sum([MTH05])  [MTH05]
	,sum([MTH06])  [MTH06]
	,sum([MTH07])  [MTH07]
	,sum([MTH08])  [MTH08]
	,sum([MTH09])  [MTH09]
	,sum([MTH10])  [MTH10]
	,sum([MTH11])  [MTH11]
	,sum([MTH12])  [MTH12]
	,sum([MTH13])  [MTH13]
	,sum([MTH14])  [MTH14]
	,sum([MTH15])  [MTH15]
	,sum([MTH16])  [MTH16]
	,sum([MTH17])  [MTH17]
	,sum([MTH18])  [MTH18]
	,sum([MTH19])  [MTH19]
	,sum([MTH20])  [MTH20]
	,sum([MTH21])  [MTH21]
	,sum([MTH22])  [MTH22]
	,sum([MTH23])  [MTH23]
	,sum([MTH24])  [MTH24]
	,sum([MTH25])  [MTH25]
	,sum([MTH26])  [MTH26]
	,sum([MTH27])  [MTH27]
	,sum([MTH28])  [MTH28]
	,sum([MTH29])  [MTH29]
	,sum([MTH30])  [MTH30]
	,sum([MTH31])  [MTH31]
	,sum([MTH32])  [MTH32]
	,sum([MTH33])  [MTH33]
	,sum([MTH34])  [MTH34]
	,sum([MTH35])  [MTH35]
	,sum([MTH36])  [MTH36]
	,sum([MTH37])  [MTH37]
	,sum([MTH38])  [MTH38]
	,sum([MTH39])  [MTH39]
	,sum([MTH40])  [MTH40]
	,sum([MTH41])  [MTH41]
	,sum([MTH42])  [MTH42]
	,sum([MTH43])  [MTH43]
	,sum([MTH44])  [MTH44]
	,sum([MTH45])  [MTH45]
	,sum([MTH46])  [MTH46]
	,sum([MTH47])  [MTH47]
	,sum([MTH48])  [MTH48]
--      ,sum([MTH49])  [MTH49]
--      ,sum([MTH50])  [MTH50]
--      ,sum([MTH51])  [MTH51]
--      ,sum([MTH52])  [MTH52]
--      ,sum([MTH53])  [MTH53]
--      ,sum([MTH54])  [MTH54]
--      ,sum([MTH55])  [MTH55]
--      ,sum([MTH56])  [MTH56]
--      ,sum([MTH57])  [MTH57]
--      ,sum([MTH58])  [MTH58]
--      ,sum([MTH59])  [MTH59]
	,sum([MAT00])  [MAT00]
	,sum([MAT01])  [MAT01]
	,sum([MAT02])  [MAT02]
	,sum([MAT03])  [MAT03]
	,sum([MAT04])  [MAT04]
	,sum([MAT05])  [MAT05]
	,sum([MAT06])  [MAT06]
	,sum([MAT07])  [MAT07]
	,sum([MAT08])  [MAT08]
	,sum([MAT09])  [MAT09]
	,sum([MAT10])  [MAT10]
	,sum([MAT11])  [MAT11]
	,sum([MAT12])  [MAT12]
	,sum([MAT13])  [MAT13]
	,sum([MAT14])  [MAT14]
	,sum([MAT15])  [MAT15]
	,sum([MAT16])  [MAT16]
	,sum([MAT17])  [MAT17]
	,sum([MAT18])  [MAT18]
	,sum([MAT19])  [MAT19]
	,sum([MAT20])  [MAT20]
	,sum([MAT21])  [MAT21]
	,sum([MAT22])  [MAT22]
	,sum([MAT23])  [MAT23]
	,sum([MAT24])  [MAT24]
	,sum([MAT25])  [MAT25]
	,sum([MAT26])  [MAT26]
	,sum([MAT27])  [MAT27]
	,sum([MAT28])  [MAT28]
	,sum([MAT29])  [MAT29]
	,sum([MAT30])  [MAT30]
	,sum([MAT31])  [MAT31]
	,sum([MAT32])  [MAT32]
	,sum([MAT33])  [MAT33]
	,sum([MAT34])  [MAT34]
	,sum([MAT35])  [MAT35]
	,sum([MAT36])  [MAT36]
	,sum([MAT37])  [MAT37]
	,sum([MAT38])  [MAT38]
	,sum([MAT39])  [MAT39]
	,sum([MAT40])  [MAT40]
	,sum([MAT41])  [MAT41]
	,sum([MAT42])  [MAT42]
	,sum([MAT43])  [MAT43]
	,sum([MAT44])  [MAT44]
	,sum([MAT45])  [MAT45]
	,sum([MAT46])  [MAT46]
	,sum([MAT47])  [MAT47]
	,sum([MAT48])  [MAT48]
	,sum([YTD00])  [YTD00]
	,sum([YTD01])  [YTD01]
	,sum([YTD02])  [YTD02]
	,sum([YTD03])  [YTD03]
	,sum([YTD04])  [YTD04]
	,sum([YTD05])  [YTD05]
	,sum([YTD06])  [YTD06]
	,sum([YTD07])  [YTD07]
	,sum([YTD08])  [YTD08]
	,sum([YTD09])  [YTD09]
	,sum([YTD10])  [YTD10]
	,sum([YTD11])  [YTD11]
	,sum([YTD12])  [YTD12]
	,sum([YTD13])  [YTD13]
	,sum([YTD14])  [YTD14]
	,sum([YTD15])  [YTD15]
	,sum([YTD16])  [YTD16]
	,sum([YTD17])  [YTD17]
	,sum([YTD18])  [YTD18]
	,sum([YTD19])  [YTD19]
	,sum([YTD20])  [YTD20]
	,sum([YTD21])  [YTD21]
	,sum([YTD22])  [YTD22]
	,sum([YTD23])  [YTD23]
	,sum([YTD24])  [YTD24]
	,sum([YTD25])  [YTD25]
	,sum([YTD26])  [YTD26]
	,sum([YTD27])  [YTD27]
	,sum([YTD28])  [YTD28]
	,sum([YTD29])  [YTD29]
	,sum([YTD30])  [YTD30]
	,sum([YTD31])  [YTD31]
	,sum([YTD32])  [YTD32]
	,sum([YTD33])  [YTD33]
	,sum([YTD34])  [YTD34]
	,sum([YTD35])  [YTD35]
	,sum([YTD36])  [YTD36]
	,sum([YTD37])  [YTD37]
	,sum([YTD38])  [YTD38]
	,sum([YTD39])  [YTD39]
	,sum([YTD40])  [YTD40]
	,sum([YTD41])  [YTD41]
	,sum([YTD42])  [YTD42]
	,sum([YTD43])  [YTD43]
	,sum([YTD44])  [YTD44]
	,sum([YTD45])  [YTD45]
	,sum([YTD46])  [YTD46]
	,sum([YTD47])  [YTD47]
	,sum([YTD48])  [YTD48]
--      ,sum([YTD49])  [YTD49]
--      ,sum([YTD50])  [YTD50]
--      ,sum([YTD51])  [YTD51]
--      ,sum([YTD52])  [YTD52]
--      ,sum([YTD53])  [YTD53]
--      ,sum([YTD54])  [YTD54]
--      ,sum([YTD55])  [YTD55]
--      ,sum([YTD56])  [YTD56]
--      ,sum([YTD57])  [YTD57]
--      ,sum([YTD58])  [YTD58]
--      ,sum([YTD59])  [YTD59]
--      ,sum([YTD60])  [YTD60]
	,sum([Qtr00])  [Qtr00]
	,sum([Qtr01])  [Qtr01]
	,sum([Qtr02])  [Qtr02]
	,sum([Qtr03])  [Qtr03]
	,sum([Qtr04])  [Qtr04]
	,sum([Qtr05])  [Qtr05]
	,sum([Qtr06])  [Qtr06]
	,sum([Qtr07])  [Qtr07]
	,sum([Qtr08])  [Qtr08]
	,sum([Qtr09])  [Qtr09]
	,sum([Qtr10])  [Qtr10]
	,sum([Qtr11])  [Qtr11]
	,sum([Qtr12])  [Qtr12]
	,sum([Qtr13])  [Qtr13]
	,sum([Qtr14])  [Qtr14]
	,sum([Qtr15])  [Qtr15]
	,sum([Qtr16])  [Qtr16]
	,sum([Qtr17])  [Qtr17]
	,sum([Qtr18])  [Qtr18]
	,sum([Qtr19])  [Qtr19]
-- select * 
FROM [TempRegionCityDashboard]
where 
	(	mkt='ONCFCS' and mktname='Oncology Focused Brands' and Market='Taxol' and MoneyType<>'PN'
		and Prod in ('000','100') and Lev='City' and [Molecule]='N' and  [Class]='N') 
	or 
	(	mkt='Platinum' and mktname='Platinum Market' and Market='Paraplatin' and MoneyType<>'UN'
		and Prod in ('000','100') and Lev='City' and [Molecule]='N' and  [Class]='N')  
group by 
	[mkt]
	,[mktname]
	,[Market]
	,[prod]
	,[Productname]
	,[Moneytype]
	,[Audi_cod]
	,[Audi_des]
	,[Region]
GO
-->   select * from MID_C160_RegionData where type ='Sales' 



insert into MID_C160_RegionData  
SELECT 
	'Growth' as Type
	,[mkt]
	,[mktname]
	,[Market]
	,[prod]
	,[Productname]
	,[Moneytype]
	,[Audi_cod]
	,[Audi_des]
	,[Region]
	,case when [R3M12]=0 then 0 else ( [R3M00] - [R3M12] ) / [R3M12] end
	,case when [R3M13]=0 then 0 else ( [R3M01] - [R3M13] ) / [R3M13] end
	,case when [R3M14]=0 then 0 else ( [R3M02] - [R3M14] ) / [R3M14] end
	,case when [R3M15]=0 then 0 else ( [R3M03] - [R3M15] ) / [R3M15] end
	,case when [R3M16]=0 then 0 else ( [R3M04] - [R3M16] ) / [R3M16] end
	,case when [R3M17]=0 then 0 else ( [R3M05] - [R3M17] ) / [R3M17] end
	,case when [R3M18]=0 then 0 else ( [R3M06] - [R3M18] ) / [R3M18] end
	,case when [R3M19]=0 then 0 else ( [R3M07] - [R3M19] ) / [R3M19] end
	,case when [R3M20]=0 then 0 else ( [R3M08] - [R3M20] ) / [R3M20] end
	,case when [R3M21]=0 then 0 else ( [R3M09] - [R3M21] ) / [R3M21] end
	,case when [R3M22]=0 then 0 else ( [R3M10] - [R3M22] ) / [R3M22] end
	,case when [R3M23]=0 then 0 else ( [R3M11] - [R3M23] ) / [R3M23] end
	,case when [R3M24]=0 then 0 else ( [R3M12] - [R3M24] ) / [R3M24] end
	,case when [R3M25]=0 then 0 else ( [R3M13] - [R3M25] ) / [R3M25] end
	,case when [R3M26]=0 then 0 else ( [R3M14] - [R3M26] ) / [R3M26] end
	,case when [R3M27]=0 then 0 else ( [R3M15] - [R3M27] ) / [R3M27] end
	,case when [R3M28]=0 then 0 else ( [R3M16] - [R3M28] ) / [R3M28] end
	,case when [R3M29]=0 then 0 else ( [R3M17] - [R3M29] ) / [R3M29] end
	,case when [R3M30]=0 then 0 else ( [R3M18] - [R3M30] ) / [R3M30] end
	,case when [R3M31]=0 then 0 else ( [R3M19] - [R3M31] ) / [R3M31] end
	,case when [R3M32]=0 then 0 else ( [R3M20] - [R3M32] ) / [R3M32] end
	,case when [R3M33]=0 then 0 else ( [R3M21] - [R3M33] ) / [R3M33] end
	,case when [R3M34]=0 then 0 else ( [R3M22] - [R3M34] ) / [R3M34] end
	,case when [R3M35]=0 then 0 else ( [R3M23] - [R3M35] ) / [R3M35] end
	,case when [R3M36]=0 then 0 else ( [R3M24] - [R3M36] ) / [R3M36] end
	,case when [R3M37]=0 then 0 else ( [R3M25] - [R3M37] ) / [R3M37] end
	,case when [R3M38]=0 then 0 else ( [R3M26] - [R3M38] ) / [R3M38] end
	,case when [R3M39]=0 then 0 else ( [R3M27] - [R3M39] ) / [R3M39] end
	,case when [R3M40]=0 then 0 else ( [R3M28] - [R3M40] ) / [R3M40] end
	,case when [R3M41]=0 then 0 else ( [R3M29] - [R3M41] ) / [R3M41] end
	,case when [R3M42]=0 then 0 else ( [R3M30] - [R3M42] ) / [R3M42] end
	,case when [R3M43]=0 then 0 else ( [R3M31] - [R3M43] ) / [R3M43] end
	,case when [R3M44]=0 then 0 else ( [R3M32] - [R3M44] ) / [R3M44] end
	,case when [R3M45]=0 then 0 else ( [R3M33] - [R3M45] ) / [R3M45] end
	-- ,case when [R3M46]=0 then 0 else ( [R3M34] - [R3M46] ) / [R3M46] end
	-- ,case when [R3M47]=0 then 0 else ( [R3M35] - [R3M47] ) / [R3M47] end
	-- ,case when [R3M48]=0 then 0 else ( [R3M36] - [R3M48] ) / [R3M48] end
	-- ,case when [R3M49]=0 then 0 else ( [R3M37] - [R3M49] ) / [R3M49] end
	-- ,case when [R3M50]=0 then 0 else ( [R3M38] - [R3M50] ) / [R3M50] end
	-- ,case when [R3M51]=0 then 0 else ( [R3M39] - [R3M51] ) / [R3M51] end
	-- ,case when [R3M52]=0 then 0 else ( [R3M40] - [R3M52] ) / [R3M52] end
	-- ,case when [R3M53]=0 then 0 else ( [R3M41] - [R3M53] ) / [R3M53] end
	-- ,case when [R3M54]=0 then 0 else ( [R3M42] - [R3M54] ) / [R3M54] end
	-- ,case when [R3M55]=0 then 0 else ( [R3M43] - [R3M55] ) / [R3M55] end
	-- ,case when [R3M56]=0 then 0 else ( [R3M44] - [R3M56] ) / [R3M56] end
	-- ,case when [R3M57]=0 then 0 else ( [R3M45] - [R3M57] ) / [R3M57] end
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,case when [MTH12]=0 then 0 else ( [MTH00] - [MTH12] ) / [MTH12] end
	,case when [MTH13]=0 then 0 else ( [MTH01] - [MTH13] ) / [MTH13] end
	,case when [MTH14]=0 then 0 else ( [MTH02] - [MTH14] ) / [MTH14] end
	,case when [MTH15]=0 then 0 else ( [MTH03] - [MTH15] ) / [MTH15] end
	,case when [MTH16]=0 then 0 else ( [MTH04] - [MTH16] ) / [MTH16] end
	,case when [MTH17]=0 then 0 else ( [MTH05] - [MTH17] ) / [MTH17] end
	,case when [MTH18]=0 then 0 else ( [MTH06] - [MTH18] ) / [MTH18] end
	,case when [MTH19]=0 then 0 else ( [MTH07] - [MTH19] ) / [MTH19] end
	,case when [MTH20]=0 then 0 else ( [MTH08] - [MTH20] ) / [MTH20] end
	,case when [MTH21]=0 then 0 else ( [MTH09] - [MTH21] ) / [MTH21] end
	,case when [MTH22]=0 then 0 else ( [MTH10] - [MTH22] ) / [MTH22] end
	,case when [MTH23]=0 then 0 else ( [MTH11] - [MTH23] ) / [MTH23] end
	,case when [MTH24]=0 then 0 else ( [MTH12] - [MTH24] ) / [MTH24] end
	,case when [MTH25]=0 then 0 else ( [MTH13] - [MTH25] ) / [MTH25] end
	,case when [MTH26]=0 then 0 else ( [MTH14] - [MTH26] ) / [MTH26] end
	,case when [MTH27]=0 then 0 else ( [MTH15] - [MTH27] ) / [MTH27] end
	,case when [MTH28]=0 then 0 else ( [MTH16] - [MTH28] ) / [MTH28] end
	,case when [MTH29]=0 then 0 else ( [MTH17] - [MTH29] ) / [MTH29] end
	,case when [MTH30]=0 then 0 else ( [MTH18] - [MTH30] ) / [MTH30] end
	,case when [MTH31]=0 then 0 else ( [MTH19] - [MTH31] ) / [MTH31] end
	,case when [MTH32]=0 then 0 else ( [MTH20] - [MTH32] ) / [MTH32] end
	,case when [MTH33]=0 then 0 else ( [MTH21] - [MTH33] ) / [MTH33] end
	,case when [MTH34]=0 then 0 else ( [MTH22] - [MTH34] ) / [MTH34] end
	,case when [MTH35]=0 then 0 else ( [MTH23] - [MTH35] ) / [MTH35] end
	,case when [MTH36]=0 then 0 else ( [MTH24] - [MTH36] ) / [MTH36] end
	,case when [MTH37]=0 then 0 else ( [MTH25] - [MTH37] ) / [MTH37] end
	,case when [MTH38]=0 then 0 else ( [MTH26] - [MTH38] ) / [MTH38] end
	,case when [MTH39]=0 then 0 else ( [MTH27] - [MTH39] ) / [MTH39] end
	,case when [MTH40]=0 then 0 else ( [MTH28] - [MTH40] ) / [MTH40] end
	,case when [MTH41]=0 then 0 else ( [MTH29] - [MTH41] ) / [MTH41] end
	,case when [MTH42]=0 then 0 else ( [MTH30] - [MTH42] ) / [MTH42] end
	,case when [MTH43]=0 then 0 else ( [MTH31] - [MTH43] ) / [MTH43] end
	,case when [MTH44]=0 then 0 else ( [MTH32] - [MTH44] ) / [MTH44] end
	,case when [MTH45]=0 then 0 else ( [MTH33] - [MTH45] ) / [MTH45] end
	,case when [MTH46]=0 then 0 else ( [MTH34] - [MTH46] ) / [MTH46] end
	,case when [MTH47]=0 then 0 else ( [MTH35] - [MTH47] ) / [MTH47] end
	,case when [MTH48]=0 then 0 else ( [MTH36] - [MTH48] ) / [MTH48] end
	-- ,case when [MTH49]=0 then 0 else ( [MTH37] - [MTH49] ) / [MTH49] end
	-- ,case when [MTH50]=0 then 0 else ( [MTH38] - [MTH50] ) / [MTH50] end
	-- ,case when [MTH51]=0 then 0 else ( [MTH39] - [MTH51] ) / [MTH51] end
	-- ,case when [MTH52]=0 then 0 else ( [MTH40] - [MTH52] ) / [MTH52] end
	-- ,case when [MTH53]=0 then 0 else ( [MTH41] - [MTH53] ) / [MTH53] end
	-- ,case when [MTH54]=0 then 0 else ( [MTH42] - [MTH54] ) / [MTH54] end
	-- ,case when [MTH55]=0 then 0 else ( [MTH43] - [MTH55] ) / [MTH55] end
	-- ,case when [MTH56]=0 then 0 else ( [MTH44] - [MTH56] ) / [MTH56] end
	-- ,case when [MTH57]=0 then 0 else ( [MTH45] - [MTH57] ) / [MTH57] end
	-- ,case when [MTH58]=0 then 0 else ( [MTH46] - [MTH58] ) / [MTH58] end
	-- ,case when [MTH59]=0 then 0 else ( [MTH47] - [MTH59] ) / [MTH59] end
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,case when [MAT12]=0 then 0 else ( [MAT00] - [MAT12] ) / [MAT12] end
	,case when [MAT13]=0 then 0 else ( [MAT01] - [MAT13] ) / [MAT13] end
	,case when [MAT14]=0 then 0 else ( [MAT02] - [MAT14] ) / [MAT14] end
	,case when [MAT15]=0 then 0 else ( [MAT03] - [MAT15] ) / [MAT15] end
	,case when [MAT16]=0 then 0 else ( [MAT04] - [MAT16] ) / [MAT16] end
	,case when [MAT17]=0 then 0 else ( [MAT05] - [MAT17] ) / [MAT17] end
	,case when [MAT18]=0 then 0 else ( [MAT06] - [MAT18] ) / [MAT18] end
	,case when [MAT19]=0 then 0 else ( [MAT07] - [MAT19] ) / [MAT19] end
	,case when [MAT20]=0 then 0 else ( [MAT08] - [MAT20] ) / [MAT20] end
	,case when [MAT21]=0 then 0 else ( [MAT09] - [MAT21] ) / [MAT21] end
	,case when [MAT22]=0 then 0 else ( [MAT10] - [MAT22] ) / [MAT22] end
	,case when [MAT23]=0 then 0 else ( [MAT11] - [MAT23] ) / [MAT23] end
	,case when [MAT24]=0 then 0 else ( [MAT12] - [MAT24] ) / [MAT24] end
	,case when [MAT25]=0 then 0 else ( [MAT13] - [MAT25] ) / [MAT25] end
	,case when [MAT26]=0 then 0 else ( [MAT14] - [MAT26] ) / [MAT26] end
	,case when [MAT27]=0 then 0 else ( [MAT15] - [MAT27] ) / [MAT27] end
	,case when [MAT28]=0 then 0 else ( [MAT16] - [MAT28] ) / [MAT28] end
	,case when [MAT29]=0 then 0 else ( [MAT17] - [MAT29] ) / [MAT29] end
	,case when [MAT30]=0 then 0 else ( [MAT18] - [MAT30] ) / [MAT30] end
	,case when [MAT31]=0 then 0 else ( [MAT19] - [MAT31] ) / [MAT31] end
	,case when [MAT32]=0 then 0 else ( [MAT20] - [MAT32] ) / [MAT32] end
	,case when [MAT33]=0 then 0 else ( [MAT21] - [MAT33] ) / [MAT33] end
	,case when [MAT34]=0 then 0 else ( [MAT22] - [MAT34] ) / [MAT34] end
	,case when [MAT35]=0 then 0 else ( [MAT23] - [MAT35] ) / [MAT35] end
	,case when [MAT36]=0 then 0 else ( [MAT24] - [MAT36] ) / [MAT36] end
	,case when [MAT37]=0 then 0 else ( [MAT25] - [MAT37] ) / [MAT37] end
	,case when [MAT38]=0 then 0 else ( [MAT26] - [MAT38] ) / [MAT38] end
	,case when [MAT39]=0 then 0 else ( [MAT27] - [MAT39] ) / [MAT39] end
	,case when [MAT40]=0 then 0 else ( [MAT28] - [MAT40] ) / [MAT40] end
	,case when [MAT41]=0 then 0 else ( [MAT29] - [MAT41] ) / [MAT41] end
	,case when [MAT42]=0 then 0 else ( [MAT30] - [MAT42] ) / [MAT42] end
	,case when [MAT43]=0 then 0 else ( [MAT31] - [MAT43] ) / [MAT43] end
	,case when [MAT44]=0 then 0 else ( [MAT32] - [MAT44] ) / [MAT44] end
	,case when [MAT45]=0 then 0 else ( [MAT33] - [MAT45] ) / [MAT45] end
	,case when [MAT46]=0 then 0 else ( [MAT34] - [MAT46] ) / [MAT46] end
	,case when [MAT47]=0 then 0 else ( [MAT35] - [MAT47] ) / [MAT47] end
	,case when [MAT48]=0 then 0 else ( [MAT36] - [MAT48] ) / [MAT48] end
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,case when [YTD12]=0 then 0 else ( [YTD00] - [YTD12] ) / [YTD12] end
	,case when [YTD13]=0 then 0 else ( [YTD01] - [YTD13] ) / [YTD13] end
	,case when [YTD14]=0 then 0 else ( [YTD02] - [YTD14] ) / [YTD14] end
	,case when [YTD15]=0 then 0 else ( [YTD03] - [YTD15] ) / [YTD15] end
	,case when [YTD16]=0 then 0 else ( [YTD04] - [YTD16] ) / [YTD16] end
	,case when [YTD17]=0 then 0 else ( [YTD05] - [YTD17] ) / [YTD17] end
	,case when [YTD18]=0 then 0 else ( [YTD06] - [YTD18] ) / [YTD18] end
	,case when [YTD19]=0 then 0 else ( [YTD07] - [YTD19] ) / [YTD19] end
	,case when [YTD20]=0 then 0 else ( [YTD08] - [YTD20] ) / [YTD20] end
	,case when [YTD21]=0 then 0 else ( [YTD09] - [YTD21] ) / [YTD21] end
	,case when [YTD22]=0 then 0 else ( [YTD10] - [YTD22] ) / [YTD22] end
	,case when [YTD23]=0 then 0 else ( [YTD11] - [YTD23] ) / [YTD23] end
	,case when [YTD24]=0 then 0 else ( [YTD12] - [YTD24] ) / [YTD24] end
	,case when [YTD25]=0 then 0 else ( [YTD13] - [YTD25] ) / [YTD25] end
	,case when [YTD26]=0 then 0 else ( [YTD14] - [YTD26] ) / [YTD26] end
	,case when [YTD27]=0 then 0 else ( [YTD15] - [YTD27] ) / [YTD27] end
	,case when [YTD28]=0 then 0 else ( [YTD16] - [YTD28] ) / [YTD28] end
	,case when [YTD29]=0 then 0 else ( [YTD17] - [YTD29] ) / [YTD29] end
	,case when [YTD30]=0 then 0 else ( [YTD18] - [YTD30] ) / [YTD30] end
	,case when [YTD31]=0 then 0 else ( [YTD19] - [YTD31] ) / [YTD31] end
	,case when [YTD32]=0 then 0 else ( [YTD20] - [YTD32] ) / [YTD32] end
	,case when [YTD33]=0 then 0 else ( [YTD21] - [YTD33] ) / [YTD33] end
	,case when [YTD34]=0 then 0 else ( [YTD22] - [YTD34] ) / [YTD34] end
	,case when [YTD35]=0 then 0 else ( [YTD23] - [YTD35] ) / [YTD35] end
	,case when [YTD36]=0 then 0 else ( [YTD24] - [YTD36] ) / [YTD36] end
	,case when [YTD37]=0 then 0 else ( [YTD25] - [YTD37] ) / [YTD37] end
	,case when [YTD38]=0 then 0 else ( [YTD26] - [YTD38] ) / [YTD38] end
	,case when [YTD39]=0 then 0 else ( [YTD27] - [YTD39] ) / [YTD39] end
	,case when [YTD40]=0 then 0 else ( [YTD28] - [YTD40] ) / [YTD40] end
	,case when [YTD41]=0 then 0 else ( [YTD29] - [YTD41] ) / [YTD41] end
	,case when [YTD42]=0 then 0 else ( [YTD30] - [YTD42] ) / [YTD42] end
	,case when [YTD43]=0 then 0 else ( [YTD31] - [YTD43] ) / [YTD43] end
	,case when [YTD44]=0 then 0 else ( [YTD32] - [YTD44] ) / [YTD44] end
	,case when [YTD45]=0 then 0 else ( [YTD33] - [YTD45] ) / [YTD45] end
	,case when [YTD46]=0 then 0 else ( [YTD34] - [YTD46] ) / [YTD46] end
	,case when [YTD47]=0 then 0 else ( [YTD35] - [YTD47] ) / [YTD47] end
	,case when [YTD48]=0 then 0 else ( [YTD36] - [YTD48] ) / [YTD48] end
	-- ,case when [YTD49]=0 then 0 else ( [YTD37] - [YTD49] ) / [YTD49] end
	-- ,case when [YTD50]=0 then 0 else ( [YTD38] - [YTD50] ) / [YTD50] end
	-- ,case when [YTD51]=0 then 0 else ( [YTD39] - [YTD51] ) / [YTD51] end
	-- ,case when [YTD52]=0 then 0 else ( [YTD40] - [YTD52] ) / [YTD52] end
	-- ,case when [YTD53]=0 then 0 else ( [YTD41] - [YTD53] ) / [YTD53] end
	-- ,case when [YTD54]=0 then 0 else ( [YTD42] - [YTD54] ) / [YTD54] end
	-- ,case when [YTD55]=0 then 0 else ( [YTD43] - [YTD55] ) / [YTD55] end
	-- ,case when [YTD56]=0 then 0 else ( [YTD44] - [YTD56] ) / [YTD56] end
	-- ,case when [YTD57]=0 then 0 else ( [YTD45] - [YTD57] ) / [YTD57] end
	-- ,case when [YTD58]=0 then 0 else ( [YTD46] - [YTD58] ) / [YTD58] end
	-- ,case when [YTD59]=0 then 0 else ( [YTD47] - [YTD59] ) / [YTD59] end
	-- ,case when [YTD60]=0 then 0 else ( [YTD48] - [YTD60] ) / [YTD60] end
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,case when [Qtr12]=0 then 0 else ( [Qtr00] - [Qtr12] ) / [Qtr12] end
	,case when [Qtr13]=0 then 0 else ( [Qtr01] - [Qtr13] ) / [Qtr13] end
	,case when [Qtr14]=0 then 0 else ( [Qtr02] - [Qtr14] ) / [Qtr14] end
	,case when [Qtr15]=0 then 0 else ( [Qtr03] - [Qtr15] ) / [Qtr15] end
	,case when [Qtr16]=0 then 0 else ( [Qtr04] - [Qtr16] ) / [Qtr16] end
	,case when [Qtr17]=0 then 0 else ( [Qtr05] - [Qtr17] ) / [Qtr17] end
	,case when [Qtr18]=0 then 0 else ( [Qtr06] - [Qtr18] ) / [Qtr18] end
	,case when [Qtr19]=0 then 0 else ( [Qtr07] - [Qtr19] ) / [Qtr19] end
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
	,0
FROM  MID_C160_RegionData where Type = 'Sales' 
GO
-->   select * from MID_C160_RegionData where Type = 'Growth'



insert into MID_C160_RegionData  
SELECT 
	'Share' as Type
	,a.[mkt]
	,a.[mktname]
	,a.[Market]
	,a.[prod]
	,a.[Productname]
	,a.[Moneytype]
	,a.[Audi_cod]
	,a.[Audi_des]
	,a.[Region]
	,case when b.[R3M00]=0 then 0 else a.[R3M00] / b.[R3M00] end
	,case when b.[R3M01]=0 then 0 else a.[R3M01] / b.[R3M01] end
	,case when b.[R3M02]=0 then 0 else a.[R3M02] / b.[R3M02] end
	,case when b.[R3M03]=0 then 0 else a.[R3M03] / b.[R3M03] end
	,case when b.[R3M04]=0 then 0 else a.[R3M04] / b.[R3M04] end
	,case when b.[R3M05]=0 then 0 else a.[R3M05] / b.[R3M05] end
	,case when b.[R3M06]=0 then 0 else a.[R3M06] / b.[R3M06] end
	,case when b.[R3M07]=0 then 0 else a.[R3M07] / b.[R3M07] end
	,case when b.[R3M08]=0 then 0 else a.[R3M08] / b.[R3M08] end
	,case when b.[R3M09]=0 then 0 else a.[R3M09] / b.[R3M09] end
	,case when b.[R3M10]=0 then 0 else a.[R3M10] / b.[R3M10] end
	,case when b.[R3M11]=0 then 0 else a.[R3M11] / b.[R3M11] end
	,case when b.[R3M12]=0 then 0 else a.[R3M12] / b.[R3M12] end
	,case when b.[R3M13]=0 then 0 else a.[R3M13] / b.[R3M13] end
	,case when b.[R3M14]=0 then 0 else a.[R3M14] / b.[R3M14] end
	,case when b.[R3M15]=0 then 0 else a.[R3M15] / b.[R3M15] end
	,case when b.[R3M16]=0 then 0 else a.[R3M16] / b.[R3M16] end
	,case when b.[R3M17]=0 then 0 else a.[R3M17] / b.[R3M17] end
	,case when b.[R3M18]=0 then 0 else a.[R3M18] / b.[R3M18] end
	,case when b.[R3M19]=0 then 0 else a.[R3M19] / b.[R3M19] end
	,case when b.[R3M20]=0 then 0 else a.[R3M20] / b.[R3M20] end
	,case when b.[R3M21]=0 then 0 else a.[R3M21] / b.[R3M21] end
	,case when b.[R3M22]=0 then 0 else a.[R3M22] / b.[R3M22] end
	,case when b.[R3M23]=0 then 0 else a.[R3M23] / b.[R3M23] end
	,case when b.[R3M24]=0 then 0 else a.[R3M24] / b.[R3M24] end
	,case when b.[R3M25]=0 then 0 else a.[R3M25] / b.[R3M25] end
	,case when b.[R3M26]=0 then 0 else a.[R3M26] / b.[R3M26] end
	,case when b.[R3M27]=0 then 0 else a.[R3M27] / b.[R3M27] end
	,case when b.[R3M28]=0 then 0 else a.[R3M28] / b.[R3M28] end
	,case when b.[R3M29]=0 then 0 else a.[R3M29] / b.[R3M29] end
	,case when b.[R3M30]=0 then 0 else a.[R3M30] / b.[R3M30] end
	,case when b.[R3M31]=0 then 0 else a.[R3M31] / b.[R3M31] end
	,case when b.[R3M32]=0 then 0 else a.[R3M32] / b.[R3M32] end
	,case when b.[R3M33]=0 then 0 else a.[R3M33] / b.[R3M33] end
	,case when b.[R3M34]=0 then 0 else a.[R3M34] / b.[R3M34] end
	,case when b.[R3M35]=0 then 0 else a.[R3M35] / b.[R3M35] end
	,case when b.[R3M36]=0 then 0 else a.[R3M36] / b.[R3M36] end
	,case when b.[R3M37]=0 then 0 else a.[R3M37] / b.[R3M37] end
	,case when b.[R3M38]=0 then 0 else a.[R3M38] / b.[R3M38] end
	,case when b.[R3M39]=0 then 0 else a.[R3M39] / b.[R3M39] end
	,case when b.[R3M40]=0 then 0 else a.[R3M40] / b.[R3M40] end
	,case when b.[R3M41]=0 then 0 else a.[R3M41] / b.[R3M41] end
	,case when b.[R3M42]=0 then 0 else a.[R3M42] / b.[R3M42] end
	,case when b.[R3M43]=0 then 0 else a.[R3M43] / b.[R3M43] end
	,case when b.[R3M44]=0 then 0 else a.[R3M44] / b.[R3M44] end
	,case when b.[R3M45]=0 then 0 else a.[R3M45] / b.[R3M45] end
	-- ,case when b.[R3M46]=0 then 0 else a.[R3M46] / b.[R3M46] end
	-- ,case when b.[R3M47]=0 then 0 else a.[R3M47] / b.[R3M47] end
	-- ,case when b.[R3M48]=0 then 0 else a.[R3M48] / b.[R3M48] end
	-- ,case when b.[R3M49]=0 then 0 else a.[R3M49] / b.[R3M49] end
	-- ,case when b.[R3M50]=0 then 0 else a.[R3M50] / b.[R3M50] end
	-- ,case when b.[R3M51]=0 then 0 else a.[R3M51] / b.[R3M51] end
	-- ,case when b.[R3M52]=0 then 0 else a.[R3M52] / b.[R3M52] end
	-- ,case when b.[R3M53]=0 then 0 else a.[R3M53] / b.[R3M53] end
	-- ,case when b.[R3M54]=0 then 0 else a.[R3M54] / b.[R3M54] end
	-- ,case when b.[R3M55]=0 then 0 else a.[R3M55] / b.[R3M55] end
	-- ,case when b.[R3M56]=0 then 0 else a.[R3M56] / b.[R3M56] end
	-- ,case when b.[R3M57]=0 then 0 else a.[R3M57] / b.[R3M57] end
	,case when b.[MTH00]=0 then 0 else a.[MTH00] / b.[MTH00] end
	,case when b.[MTH01]=0 then 0 else a.[MTH01] / b.[MTH01] end
	,case when b.[MTH02]=0 then 0 else a.[MTH02] / b.[MTH02] end
	,case when b.[MTH03]=0 then 0 else a.[MTH03] / b.[MTH03] end
	,case when b.[MTH04]=0 then 0 else a.[MTH04] / b.[MTH04] end
	,case when b.[MTH05]=0 then 0 else a.[MTH05] / b.[MTH05] end
	,case when b.[MTH06]=0 then 0 else a.[MTH06] / b.[MTH06] end
	,case when b.[MTH07]=0 then 0 else a.[MTH07] / b.[MTH07] end
	,case when b.[MTH08]=0 then 0 else a.[MTH08] / b.[MTH08] end
	,case when b.[MTH09]=0 then 0 else a.[MTH09] / b.[MTH09] end
	,case when b.[MTH10]=0 then 0 else a.[MTH10] / b.[MTH10] end
	,case when b.[MTH11]=0 then 0 else a.[MTH11] / b.[MTH11] end
	,case when b.[MTH12]=0 then 0 else a.[MTH12] / b.[MTH12] end
	,case when b.[MTH13]=0 then 0 else a.[MTH13] / b.[MTH13] end
	,case when b.[MTH14]=0 then 0 else a.[MTH14] / b.[MTH14] end
	,case when b.[MTH15]=0 then 0 else a.[MTH15] / b.[MTH15] end
	,case when b.[MTH16]=0 then 0 else a.[MTH16] / b.[MTH16] end
	,case when b.[MTH17]=0 then 0 else a.[MTH17] / b.[MTH17] end
	,case when b.[MTH18]=0 then 0 else a.[MTH18] / b.[MTH18] end
	,case when b.[MTH19]=0 then 0 else a.[MTH19] / b.[MTH19] end
	,case when b.[MTH20]=0 then 0 else a.[MTH20] / b.[MTH20] end
	,case when b.[MTH21]=0 then 0 else a.[MTH21] / b.[MTH21] end
	,case when b.[MTH22]=0 then 0 else a.[MTH22] / b.[MTH22] end
	,case when b.[MTH23]=0 then 0 else a.[MTH23] / b.[MTH23] end
	,case when b.[MTH24]=0 then 0 else a.[MTH24] / b.[MTH24] end
	,case when b.[MTH25]=0 then 0 else a.[MTH25] / b.[MTH25] end
	,case when b.[MTH26]=0 then 0 else a.[MTH26] / b.[MTH26] end
	,case when b.[MTH27]=0 then 0 else a.[MTH27] / b.[MTH27] end
	,case when b.[MTH28]=0 then 0 else a.[MTH28] / b.[MTH28] end
	,case when b.[MTH29]=0 then 0 else a.[MTH29] / b.[MTH29] end
	,case when b.[MTH30]=0 then 0 else a.[MTH30] / b.[MTH30] end
	,case when b.[MTH31]=0 then 0 else a.[MTH31] / b.[MTH31] end
	,case when b.[MTH32]=0 then 0 else a.[MTH32] / b.[MTH32] end
	,case when b.[MTH33]=0 then 0 else a.[MTH33] / b.[MTH33] end
	,case when b.[MTH34]=0 then 0 else a.[MTH34] / b.[MTH34] end
	,case when b.[MTH35]=0 then 0 else a.[MTH35] / b.[MTH35] end
	,case when b.[MTH36]=0 then 0 else a.[MTH36] / b.[MTH36] end
	,case when b.[MTH37]=0 then 0 else a.[MTH37] / b.[MTH37] end
	,case when b.[MTH38]=0 then 0 else a.[MTH38] / b.[MTH38] end
	,case when b.[MTH39]=0 then 0 else a.[MTH39] / b.[MTH39] end
	,case when b.[MTH40]=0 then 0 else a.[MTH40] / b.[MTH40] end
	,case when b.[MTH41]=0 then 0 else a.[MTH41] / b.[MTH41] end
	,case when b.[MTH42]=0 then 0 else a.[MTH42] / b.[MTH42] end
	,case when b.[MTH43]=0 then 0 else a.[MTH43] / b.[MTH43] end
	,case when b.[MTH44]=0 then 0 else a.[MTH44] / b.[MTH44] end
	,case when b.[MTH45]=0 then 0 else a.[MTH45] / b.[MTH45] end
	,case when b.[MTH46]=0 then 0 else a.[MTH46] / b.[MTH46] end
	,case when b.[MTH47]=0 then 0 else a.[MTH47] / b.[MTH47] end
	,case when b.[MTH48]=0 then 0 else a.[MTH48] / b.[MTH48] end
	-- ,case when b.[MTH49]=0 then 0 else a.[MTH49] / b.[MTH49] end
	-- ,case when b.[MTH50]=0 then 0 else a.[MTH50] / b.[MTH50] end
	-- ,case when b.[MTH51]=0 then 0 else a.[MTH51] / b.[MTH51] end
	-- ,case when b.[MTH52]=0 then 0 else a.[MTH52] / b.[MTH52] end
	-- ,case when b.[MTH53]=0 then 0 else a.[MTH53] / b.[MTH53] end
	-- ,case when b.[MTH54]=0 then 0 else a.[MTH54] / b.[MTH54] end
	-- ,case when b.[MTH55]=0 then 0 else a.[MTH55] / b.[MTH55] end
	-- ,case when b.[MTH56]=0 then 0 else a.[MTH56] / b.[MTH56] end
	-- ,case when b.[MTH57]=0 then 0 else a.[MTH57] / b.[MTH57] end
	-- ,case when b.[MTH58]=0 then 0 else a.[MTH58] / b.[MTH58] end
	-- ,case when b.[MTH59]=0 then 0 else a.[MTH59] / b.[MTH59] end
	,case when b.[MAT00]=0 then 0 else a.[MAT00] / b.[MAT00] end
	,case when b.[MAT01]=0 then 0 else a.[MAT01] / b.[MAT01] end
	,case when b.[MAT02]=0 then 0 else a.[MAT02] / b.[MAT02] end
	,case when b.[MAT03]=0 then 0 else a.[MAT03] / b.[MAT03] end
	,case when b.[MAT04]=0 then 0 else a.[MAT04] / b.[MAT04] end
	,case when b.[MAT05]=0 then 0 else a.[MAT05] / b.[MAT05] end
	,case when b.[MAT06]=0 then 0 else a.[MAT06] / b.[MAT06] end
	,case when b.[MAT07]=0 then 0 else a.[MAT07] / b.[MAT07] end
	,case when b.[MAT08]=0 then 0 else a.[MAT08] / b.[MAT08] end
	,case when b.[MAT09]=0 then 0 else a.[MAT09] / b.[MAT09] end
	,case when b.[MAT10]=0 then 0 else a.[MAT10] / b.[MAT10] end
	,case when b.[MAT11]=0 then 0 else a.[MAT11] / b.[MAT11] end
	,case when b.[MAT12]=0 then 0 else a.[MAT12] / b.[MAT12] end
	,case when b.[MAT13]=0 then 0 else a.[MAT13] / b.[MAT13] end
	,case when b.[MAT14]=0 then 0 else a.[MAT14] / b.[MAT14] end
	,case when b.[MAT15]=0 then 0 else a.[MAT15] / b.[MAT15] end
	,case when b.[MAT16]=0 then 0 else a.[MAT16] / b.[MAT16] end
	,case when b.[MAT17]=0 then 0 else a.[MAT17] / b.[MAT17] end
	,case when b.[MAT18]=0 then 0 else a.[MAT18] / b.[MAT18] end
	,case when b.[MAT19]=0 then 0 else a.[MAT19] / b.[MAT19] end
	,case when b.[MAT20]=0 then 0 else a.[MAT20] / b.[MAT20] end
	,case when b.[MAT21]=0 then 0 else a.[MAT21] / b.[MAT21] end
	,case when b.[MAT22]=0 then 0 else a.[MAT22] / b.[MAT22] end
	,case when b.[MAT23]=0 then 0 else a.[MAT23] / b.[MAT23] end
	,case when b.[MAT24]=0 then 0 else a.[MAT24] / b.[MAT24] end
	,case when b.[MAT25]=0 then 0 else a.[MAT25] / b.[MAT25] end
	,case when b.[MAT26]=0 then 0 else a.[MAT26] / b.[MAT26] end
	,case when b.[MAT27]=0 then 0 else a.[MAT27] / b.[MAT27] end
	,case when b.[MAT28]=0 then 0 else a.[MAT28] / b.[MAT28] end
	,case when b.[MAT29]=0 then 0 else a.[MAT29] / b.[MAT29] end
	,case when b.[MAT30]=0 then 0 else a.[MAT30] / b.[MAT30] end
	,case when b.[MAT31]=0 then 0 else a.[MAT31] / b.[MAT31] end
	,case when b.[MAT32]=0 then 0 else a.[MAT32] / b.[MAT32] end
	,case when b.[MAT33]=0 then 0 else a.[MAT33] / b.[MAT33] end
	,case when b.[MAT34]=0 then 0 else a.[MAT34] / b.[MAT34] end
	,case when b.[MAT35]=0 then 0 else a.[MAT35] / b.[MAT35] end
	,case when b.[MAT36]=0 then 0 else a.[MAT36] / b.[MAT36] end
	,case when b.[MAT37]=0 then 0 else a.[MAT37] / b.[MAT37] end
	,case when b.[MAT38]=0 then 0 else a.[MAT38] / b.[MAT38] end
	,case when b.[MAT39]=0 then 0 else a.[MAT39] / b.[MAT39] end
	,case when b.[MAT40]=0 then 0 else a.[MAT40] / b.[MAT40] end
	,case when b.[MAT41]=0 then 0 else a.[MAT41] / b.[MAT41] end
	,case when b.[MAT42]=0 then 0 else a.[MAT42] / b.[MAT42] end
	,case when b.[MAT43]=0 then 0 else a.[MAT43] / b.[MAT43] end
	,case when b.[MAT44]=0 then 0 else a.[MAT44] / b.[MAT44] end
	,case when b.[MAT45]=0 then 0 else a.[MAT45] / b.[MAT45] end
	,case when b.[MAT46]=0 then 0 else a.[MAT46] / b.[MAT46] end
	,case when b.[MAT47]=0 then 0 else a.[MAT47] / b.[MAT47] end
	,case when b.[MAT48]=0 then 0 else a.[MAT48] / b.[MAT48] end
	,case when b.[YTD00]=0 then 0 else a.[YTD00] / b.[YTD00] end
	,case when b.[YTD01]=0 then 0 else a.[YTD01] / b.[YTD01] end
	,case when b.[YTD02]=0 then 0 else a.[YTD02] / b.[YTD02] end
	,case when b.[YTD03]=0 then 0 else a.[YTD03] / b.[YTD03] end
	,case when b.[YTD04]=0 then 0 else a.[YTD04] / b.[YTD04] end
	,case when b.[YTD05]=0 then 0 else a.[YTD05] / b.[YTD05] end
	,case when b.[YTD06]=0 then 0 else a.[YTD06] / b.[YTD06] end
	,case when b.[YTD07]=0 then 0 else a.[YTD07] / b.[YTD07] end
	,case when b.[YTD08]=0 then 0 else a.[YTD08] / b.[YTD08] end
	,case when b.[YTD09]=0 then 0 else a.[YTD09] / b.[YTD09] end
	,case when b.[YTD10]=0 then 0 else a.[YTD10] / b.[YTD10] end
	,case when b.[YTD11]=0 then 0 else a.[YTD11] / b.[YTD11] end
	,case when b.[YTD12]=0 then 0 else a.[YTD12] / b.[YTD12] end
	,case when b.[YTD13]=0 then 0 else a.[YTD13] / b.[YTD13] end
	,case when b.[YTD14]=0 then 0 else a.[YTD14] / b.[YTD14] end
	,case when b.[YTD15]=0 then 0 else a.[YTD15] / b.[YTD15] end
	,case when b.[YTD16]=0 then 0 else a.[YTD16] / b.[YTD16] end
	,case when b.[YTD17]=0 then 0 else a.[YTD17] / b.[YTD17] end
	,case when b.[YTD18]=0 then 0 else a.[YTD18] / b.[YTD18] end
	,case when b.[YTD19]=0 then 0 else a.[YTD19] / b.[YTD19] end
	,case when b.[YTD20]=0 then 0 else a.[YTD20] / b.[YTD20] end
	,case when b.[YTD21]=0 then 0 else a.[YTD21] / b.[YTD21] end
	,case when b.[YTD22]=0 then 0 else a.[YTD22] / b.[YTD22] end
	,case when b.[YTD23]=0 then 0 else a.[YTD23] / b.[YTD23] end
	,case when b.[YTD24]=0 then 0 else a.[YTD24] / b.[YTD24] end
	,case when b.[YTD25]=0 then 0 else a.[YTD25] / b.[YTD25] end
	,case when b.[YTD26]=0 then 0 else a.[YTD26] / b.[YTD26] end
	,case when b.[YTD27]=0 then 0 else a.[YTD27] / b.[YTD27] end
	,case when b.[YTD28]=0 then 0 else a.[YTD28] / b.[YTD28] end
	,case when b.[YTD29]=0 then 0 else a.[YTD29] / b.[YTD29] end
	,case when b.[YTD30]=0 then 0 else a.[YTD30] / b.[YTD30] end
	,case when b.[YTD31]=0 then 0 else a.[YTD31] / b.[YTD31] end
	,case when b.[YTD32]=0 then 0 else a.[YTD32] / b.[YTD32] end
	,case when b.[YTD33]=0 then 0 else a.[YTD33] / b.[YTD33] end
	,case when b.[YTD34]=0 then 0 else a.[YTD34] / b.[YTD34] end
	,case when b.[YTD35]=0 then 0 else a.[YTD35] / b.[YTD35] end
	,case when b.[YTD36]=0 then 0 else a.[YTD36] / b.[YTD36] end
	,case when b.[YTD37]=0 then 0 else a.[YTD37] / b.[YTD37] end
	,case when b.[YTD38]=0 then 0 else a.[YTD38] / b.[YTD38] end
	,case when b.[YTD39]=0 then 0 else a.[YTD39] / b.[YTD39] end
	,case when b.[YTD40]=0 then 0 else a.[YTD40] / b.[YTD40] end
	,case when b.[YTD41]=0 then 0 else a.[YTD41] / b.[YTD41] end
	,case when b.[YTD42]=0 then 0 else a.[YTD42] / b.[YTD42] end
	,case when b.[YTD43]=0 then 0 else a.[YTD43] / b.[YTD43] end
	,case when b.[YTD44]=0 then 0 else a.[YTD44] / b.[YTD44] end
	,case when b.[YTD45]=0 then 0 else a.[YTD45] / b.[YTD45] end
	,case when b.[YTD46]=0 then 0 else a.[YTD46] / b.[YTD46] end
	,case when b.[YTD47]=0 then 0 else a.[YTD47] / b.[YTD47] end
	,case when b.[YTD48]=0 then 0 else a.[YTD48] / b.[YTD48] end
	-- ,case when b.[YTD49]=0 then 0 else a.[YTD49] / b.[YTD49] end
	-- ,case when b.[YTD50]=0 then 0 else a.[YTD50] / b.[YTD50] end
	-- ,case when b.[YTD51]=0 then 0 else a.[YTD51] / b.[YTD51] end
	-- ,case when b.[YTD52]=0 then 0 else a.[YTD52] / b.[YTD52] end
	-- ,case when b.[YTD53]=0 then 0 else a.[YTD53] / b.[YTD53] end
	-- ,case when b.[YTD54]=0 then 0 else a.[YTD54] / b.[YTD54] end
	-- ,case when b.[YTD55]=0 then 0 else a.[YTD55] / b.[YTD55] end
	-- ,case when b.[YTD56]=0 then 0 else a.[YTD56] / b.[YTD56] end
	-- ,case when b.[YTD57]=0 then 0 else a.[YTD57] / b.[YTD57] end
	-- ,case when b.[YTD58]=0 then 0 else a.[YTD58] / b.[YTD58] end
	-- ,case when b.[YTD59]=0 then 0 else a.[YTD59] / b.[YTD59] end
	-- ,case when b.[YTD60]=0 then 0 else a.[YTD60] / b.[YTD60] end
	,case when b.[Qtr00]=0 then 0 else a.[Qtr00] / b.[Qtr00] end
	,case when b.[Qtr01]=0 then 0 else a.[Qtr01] / b.[Qtr01] end
	,case when b.[Qtr02]=0 then 0 else a.[Qtr02] / b.[Qtr02] end
	,case when b.[Qtr03]=0 then 0 else a.[Qtr03] / b.[Qtr03] end
	,case when b.[Qtr04]=0 then 0 else a.[Qtr04] / b.[Qtr04] end
	,case when b.[Qtr05]=0 then 0 else a.[Qtr05] / b.[Qtr05] end
	,case when b.[Qtr06]=0 then 0 else a.[Qtr06] / b.[Qtr06] end
	,case when b.[Qtr07]=0 then 0 else a.[Qtr07] / b.[Qtr07] end
	,case when b.[Qtr08]=0 then 0 else a.[Qtr08] / b.[Qtr08] end
	,case when b.[Qtr09]=0 then 0 else a.[Qtr09] / b.[Qtr09] end
	,case when b.[Qtr10]=0 then 0 else a.[Qtr10] / b.[Qtr10] end
	,case when b.[Qtr11]=0 then 0 else a.[Qtr11] / b.[Qtr11] end
	,case when b.[Qtr12]=0 then 0 else a.[Qtr12] / b.[Qtr12] end
	,case when b.[Qtr13]=0 then 0 else a.[Qtr13] / b.[Qtr13] end
	,case when b.[Qtr14]=0 then 0 else a.[Qtr14] / b.[Qtr14] end
	,case when b.[Qtr15]=0 then 0 else a.[Qtr15] / b.[Qtr15] end
	,case when b.[Qtr16]=0 then 0 else a.[Qtr16] / b.[Qtr16] end
	,case when b.[Qtr17]=0 then 0 else a.[Qtr17] / b.[Qtr17] end
	,case when b.[Qtr18]=0 then 0 else a.[Qtr18] / b.[Qtr18] end
	,case when b.[Qtr19]=0 then 0 else a.[Qtr19] / b.[Qtr19] end
FROM (select * from MID_C160_RegionData where Type = 'Sales' and prod <> 0) a 
inner join (select * from MID_C160_RegionData where Type = 'Sales' and prod = 0)  b
on 
  a.[mkt]            = b.[mkt]  
  and a.[mktname]    = b.[mktname]         
  and a.[Market]     = b.[Market]         
  and a.[Moneytype]  = b.[Moneytype]  
  and a.[Audi_cod]   = b.[Audi_cod]
  and a.[Audi_des]   = b.[Audi_des]
  and a.[Region]     = b.[Region]         
GO







truncate table OUT_C160_RegionData
GO
--MTH
insert into OUT_C160_RegionData
select t1.*, t2.Share, t3.Growth from 
(
	select [mkt],[mktname],[Market],[prod],[Productname],[Moneytype],[Audi_cod],[Audi_des],[Region],'MTH00' as Period,MTH00 as Sales 
	from MID_C160_RegionData where prod='100' and [Type]='Sales' 
) t1
inner join 
(
	select [mkt],[mktname],[Market],[prod],[Productname],[Moneytype],[Audi_cod],[Audi_des],[Region],'MTH00' as Period,MTH00 as Share 
	from MID_C160_RegionData where prod='100' and [Type]='Share' 
) t2
on t1.[mkt]=t2.[mkt] and t1.[mktname]=t2.[mktname] and t1.[Market]=t2.[Market] and t1.[prod]=t2.[prod] and t1.[Productname]=t2.[Productname] and t1.[Moneytype]=t2.[Moneytype] and t1.[Audi_cod]=t2.[Audi_cod] and t1.[Audi_des]=t2.[Audi_des] and t1.[Region]=t2.[Region]
inner join 
(
	select [mkt],[mktname],[Market],[prod],[Productname],[Moneytype],[Audi_cod],[Audi_des],[Region],'MTH00' as Period,MTH00 as Growth 
	from MID_C160_RegionData where prod='100' and [Type]='Growth'
) t3
on t1.[mkt]=t3.[mkt] and t1.[mktname]=t3.[mktname] and t1.[Market]=t3.[Market] and t1.[prod]=t3.[prod] and t1.[Productname]=t3.[Productname] and t1.[Moneytype]=t3.[Moneytype] and t1.[Audi_cod]=t3.[Audi_cod] and t1.[Audi_des]=t3.[Audi_des] and t1.[Region]=t3.[Region]
GO

--MQT
insert into OUT_C160_RegionData
select t1.*, t2.Share, t3.Growth from 
(
	select [mkt],[mktname],[Market],[prod],[Productname],[Moneytype],[Audi_cod],[Audi_des],[Region],'MQT00' as Period,R3M00 as Sales 
	from MID_C160_RegionData where prod='100' and [Type]='Sales' 
) t1
inner join 
(
	select [mkt],[mktname],[Market],[prod],[Productname],[Moneytype],[Audi_cod],[Audi_des],[Region],'MQT00' as Period,R3M00 as Share 
	from MID_C160_RegionData where prod='100' and [Type]='Share' 
) t2
on t1.[mkt]=t2.[mkt] and t1.[mktname]=t2.[mktname] and t1.[Market]=t2.[Market] and t1.[prod]=t2.[prod] and t1.[Productname]=t2.[Productname] and t1.[Moneytype]=t2.[Moneytype] and t1.[Audi_cod]=t2.[Audi_cod] and t1.[Audi_des]=t2.[Audi_des] and t1.[Region]=t2.[Region]
inner join 
(
	select [mkt],[mktname],[Market],[prod],[Productname],[Moneytype],[Audi_cod],[Audi_des],[Region],'MQT00' as Period,R3M00 as Growth 
	from MID_C160_RegionData where prod='100' and [Type]='Growth'
) t3
on t1.[mkt]=t3.[mkt] and t1.[mktname]=t3.[mktname] and t1.[Market]=t3.[Market] and t1.[prod]=t3.[prod] and t1.[Productname]=t3.[Productname] and t1.[Moneytype]=t3.[Moneytype] and t1.[Audi_cod]=t3.[Audi_cod] and t1.[Audi_des]=t3.[Audi_des] and t1.[Region]=t3.[Region]
GO

--MAT
insert into OUT_C160_RegionData
select t1.*, t2.Share, t3.Growth from 
(
	select [mkt],[mktname],[Market],[prod],[Productname],[Moneytype],[Audi_cod],[Audi_des],[Region],'MAT00' as Period,MAT00 as Sales 
	from MID_C160_RegionData where prod='100' and [Type]='Sales' 
) t1
inner join 
(
	select [mkt],[mktname],[Market],[prod],[Productname],[Moneytype],[Audi_cod],[Audi_des],[Region],'MAT00' as Period,MAT00 as Share 
	from MID_C160_RegionData where prod='100' and [Type]='Share' 
) t2
on t1.[mkt]=t2.[mkt] and t1.[mktname]=t2.[mktname] and t1.[Market]=t2.[Market] and t1.[prod]=t2.[prod] and t1.[Productname]=t2.[Productname] and t1.[Moneytype]=t2.[Moneytype] and t1.[Audi_cod]=t2.[Audi_cod] and t1.[Audi_des]=t2.[Audi_des] and t1.[Region]=t2.[Region]
inner join 
(
	select [mkt],[mktname],[Market],[prod],[Productname],[Moneytype],[Audi_cod],[Audi_des],[Region],'MAT00' as Period,MAT00 as Growth 
	from MID_C160_RegionData where prod='100' and [Type]='Growth'
) t3
on t1.[mkt]=t3.[mkt] and t1.[mktname]=t3.[mktname] and t1.[Market]=t3.[Market] and t1.[prod]=t3.[prod] and t1.[Productname]=t3.[Productname] and t1.[Moneytype]=t3.[Moneytype] and t1.[Audi_cod]=t3.[Audi_cod] and t1.[Audi_des]=t3.[Audi_des] and t1.[Region]=t3.[Region]
GO


--> select * from OUT_C160_RegionData

-- select distinct Market,MoneyType from OUT_C160_RegionData



-- 清除历史冗余数据
delete from [output_stage] where LinkChartCode='C160' and lev='China'
GO
insert into [output_stage](LinkChartCode,Series,SeriesIdx,Product,lev,Geo,Currency,TimeFrame,X,XIdx,Y,Size,IsShow)
select 
	'C160'                                     --LinkChartCode
	, Audi_des                                  --Series
	, RANK() OVER (ORDER BY [Audi_cod]) AS Rank --SeriesIdx
	,Productname                                --Product
	,'China'                                    --lev
	,'China'                                    --Geo
	,MoneyType                                  --Currency
	,subString(Period,1,3)                      --TimeFrame
	,Share                                      --X
	,RANK() OVER (ORDER BY Share) AS Rank       --XIdx
	,Growth                                     --Y
	,Sales                                      --Size
	,'Y'                                        --IsShow
from OUT_C160_RegionData where prod='100' and region <>'china'
GO

-- 清除历史冗余数据
delete from [output_stage] where LinkChartCode='C160' and lev='Region'
GO
insert into [output_stage](LinkChartCode,Series,SeriesIdx,Product,lev,Geo,Currency,TimeFrame,X,XIdx,Y,Size,IsShow)
select 
	'C160'                                     --LinkChartCode
	, Audi_des                                  --Series
	, RANK() OVER (ORDER BY [Audi_cod]) AS Rank --SeriesIdx
	,Productname                                --Product
	,'Region'                                   --lev
	,Region                                     --Geo
	,MoneyType                                  --Currency
	,subString(Period,1,3)                      --TimeFrame
	,Share                                      --X
	,RANK() OVER (ORDER BY Share) AS Rank       --XIdx
	,Growth                                     --Y
	,Sales                                      --Size
	,'Y'                                        --IsShow
from OUT_C160_RegionData where prod='100'
GO



--后期处理
--update [output_stage] set X = subString(t1.X,1,3) + ' ' + t2.MonthEN -- select * 
--from [output_stage] t1
--inner join tblMonthList t2
--on cast(subString(t1.X,5,1) as int)+1 = t2.MonSeq
--where LinkChartCode='C160' and IsShow='Y'
--go
update [output_stage] 
set LinkedY=b.LinkY 
from [output_stage] A 
inner join(
	select product,min(parentgeo) as LinkY  from outputgeo where lev=2
	group by product
) B
on A.product=B.product
where A.LinkChartCode='C160'
go
update [output_stage] set LinkSeriesCode=Product+'_'+LinkChartCode+Series+cast(SeriesIdx as varchar(10)) where LinkChartCode='C160'
go


update [output_stage] 
set Category=
	case Currency 
		when 'UN' then 'Dosing Units'
		when 'PN' then 'Adjusted patient number' else 'Value' end
where LinkChartCode='C160'
go
update [output_stage] 
set Currency=
	case Currency
		when 'US' then 'USD' 
		when 'LC' then 'RMB'
		when 'UN' then 'UNIT'
		when 'PN' then 'UNIT' else Currency end 
where LinkChartCode='C160'
go



--update [output_stage] set Series = b.City_abb
--from [output_stage] a
--inner join City_abb b
--on a.Series=b.City_pinyin
--where LinkChartCode='C160' and lev='China'
--GO



--> select * from [output_stage] where LinkChartCode='C160' 






select distinct Category,[Currency]
FROM output_stage where [LinkChartCode]='C160'  and Product ='Paraplatin'


select distinct Category,[Currency]
FROM output_stage where [LinkChartCode]='C160'  and Product <> 'Paraplatin'

exec dbo.sp_Log_Event 'Output','CIA','3_1_Output_D_C160.sql','End',null,null